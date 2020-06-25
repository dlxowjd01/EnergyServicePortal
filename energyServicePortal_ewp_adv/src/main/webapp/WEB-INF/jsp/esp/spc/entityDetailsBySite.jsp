<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	let today = new Date();
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const spcId = '<c:out value="${param.spc_id}" escapeXml="false" />';
	const siteId = '<c:out value="${param.site_id}" escapeXml="false" />';
	const balance_yyyy = '<c:out value="${param.balance_yyyy}" escapeXml="false" />';
	
	$(function () {
		setInitList('historyData');

		$(document).on('click', 'div.dropdown li', function() {
			let dataValue = $(this).data('value'), dataText = $(this).text();
			$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);

			tableData();
		});

		$('.save_btn').on('click', function(e) {
			let excelName = 'SPC 원가관리';
			let $val = $('#balanceTable').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {
					tableToExcel('balanceTable', excelName, e);
				}
			}
		});

		pageInit();
	});

	const pageInit = function() {
		callAjax({
			url: 'http://iderms.enertalk.com:8443/spcs/${param.spc_id}',
			type: 'get',
			data: {
				oid: oid,
				includeGens: true
			}
		}, setSpcGen);
	}

	const tableData = function() {
		let data = new Object();
		if($('#spcGen button').data('value') != '') {
			data.site_id = $('#spcGen button').data('value');
		}
		data.year = $('#year button').data('value');

		callAjax({
			url: 'http://iderms.enertalk.com:8443/spcs/${param.spc_id}/balance/month?oid=' + oid,
			type: 'get',
			data: data
		}, setTable);
	}

	//목록
	const list = function () {
		location.href = '/spc/balanceSheet.do';
	}

	const callAjax = function (option, callBack, param) {
		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if (typeof callBack == 'function') {
				callBack.call(this, data);
			} else if (typeof callBack == 'string') {
				eval(callBack + '("' + param + '")');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	const initTable = function() {
		let balanceTr = $('#balanceTable tr');
		balanceTr.each(function() {
			let td = $(this).find('td');
			td.each(function(a) {
				if(a != 0) {
					$(this).html('-');
				}
			});
		});
	}

	const setTable = function (json) {

		initTable();

		let dataInfo = json.data;

		$('[id^="loan_"]:not(:eq(0))').remove();
		$('[id^="interestCost_"]:not(:eq(0))').remove();

		for(var i = 0; i < dataInfo.length; i++) {
			let balanceyyyymm = dataInfo[i].balance_yyyymm;
			let mm = Number(balanceyyyymm.slice(-2));
			let balanceInfo = JSON.parse(dataInfo[i].balance_info);

			let num = 0;
			$.map(balanceInfo, function(v, k){
				if(k.match('loan')) {
					let keyName = k.split('_');
					if(num < Number(keyName[1])) {
						num = Number(keyName[1]);
					}
				}
			});

			if(num > 1) {
				for(let i = 2; i <= num; i++) {
					let tr = $('<tr>').attr('id', 'loan_' + i);
					for(let j = 0; j <= 13; j++) {
						if(j == 0) {
							tr.append('<td class="sub_td">차입금 상환(' + String.fromCharCode(num + 64) + ')</td>')
						} else {
							tr.append('<td>-</td>');
						}
					}

					$('[id^="loan_"]').eq($('[id^="interestCost_"]').length - 1).after(tr);

					tr = $('<tr>').attr('id', 'interestCost_' + i);
					for(let j = 0; j <= 13; j++) {
						if(j == 0) {
							tr.append('<td class="sub_td">이자 비용(' + String.fromCharCode(num + 64) + ')</td>')
						} else {
							tr.append('<td>-</td>');
						}
					}
					$('[id^="interestCost_"]').eq($('[id^="interestCost_"]').length - 1).after(tr);
				}
			}

			$.map(balanceInfo, function(v, k){
				let val = Math.round(v.replace(/[^0-9.-]/g, ''));
				$('#'+k).find('td').eq(mm).html(numberComma(Number(val)));
			});
		}

		let balanceTr = $('#balanceTable tr');
		balanceTr.each(function() {
			let td = $(this).find('td'), tdVal = 0;
			td.each(function() {
				tdVal += $(this).text() == '-' ? 0 : Number($(this).text().replace(/[^0-9.-]/g, ''));
			});

			td.eq(td.length - 1).html(numberComma(tdVal));
		});
	}

	const setSpcGen = function (data) {
		let siteList = data.data[0].spcGens;
		let html = '';

		//$('#spcGen button').html('전체 <span class="caret"></span>').data('value', ''); //초기화

		html += '<li data-value=""><a href="javascript:void(0);">전체</a></li>';
		for (let i in siteList) {
			let temp = siteList[i];
			if(temp.gen_id == siteId) {
				$('#spcGen button').html(temp.name +'<span class="caret"></span>').data('value', temp.gen_id);
			}
			html += '<li data-value="' + temp.gen_id + '"><a href="javascript:void(0);">' + temp.name + '</a></li>';
		}

		$('#spcGen ul').empty().append(html);

		tableData();
	}

	const historyInit = function () {
		let option = {
			url: 'http://iderms.enertalk.com:8443/spcs/history',
			type: 'get',
			data: {
				oid: oid,
				ui_id: 1,
				spc_id: spcId,
				site_id: $('#spcGen button').data('value')
			}
		};

		callAjax(option, modalPopInit);
	};

	const modalPopInit = function (data) {
		setMakeList(data.data, 'historyData', {"dataFunction" : {}});
		$('#historyModal').modal();
	}
	
	function setCheckedDataModify() {
        var locationUrl = '/spc/balanceSheetEdit.do?spc_id=' + spcId + '&site_id=' + siteId + '&yyyymm=' + balance_yyyy;
        location.href = locationUrl;
    }
</script>

<!-- Modal -->
<div class="modal fade" id="historyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit">SPC 원가관리 등록/수정 이력</h2>
				<div class="spc_tbl ly_type">
					<table id="hitoryTable">
						<colgroup>
							<col style="width:15%">
							<col>
						</colgroup>
						<thead>
						<tr>
							<th>이름</th>
							<th>사용 아이디</th>
							<th>시작 시간</th>
							<th>종료 시간</th>
							<th>내용</th>
						</tr>
						</thead>
						<tbody id="historyData">
						<tr>
							<td>[user_name]</td>
							<td>[user_login_id]</td>
							<td>[changed_start]</td>
							<td>[changed_end]</td>
							<td>[contents]</td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type" data-dismiss="modal" aria-label="Close">확인</button>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 원가관리</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="header_drop_area col-lg-2">
		<div class="dropdown" id="spcGen">
			<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">
				전체<span class="caret"></span>
			</button>
			<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
			</ul>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="right">
			<a href="javascript:void(0);" class="save_btn">다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv entity_site">
			<div class="btn_wrap_type">
				<div class="dropdown" id="year">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown" data-value="2020">
						2020년<span class="caret"></span>
					</button>
					<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
						<li data-value=""><a href="#">전체</a></li>
						<li data-value="2020"><a href="#">2020</a></li>
					</ul>
				</div>
			</div>
			<div class="spc_tbl align_type02" id="balanceTable">
				<table>
					<colgroup>
						<col style="width:15%">
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<thead>
					<tr>
						<th>구분</th>
						<th>1월</th>
						<th>2월</th>
						<th>3월</th>
						<th>4월</th>
						<th>5월</th>
						<th>6월</th>
						<th>7월</th>
						<th>8월</th>
						<th>9월</th>
						<th>10월</th>
						<th>11월</th>
						<th>12월</th>
						<th>합계</th>
					</tr>
					</thead>
					<tbody>
					<tr id="inflowOfCash">
						<td>1. 현금유입</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="siteBilling">
						<td class="sub_td">전략 판매 대금</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="siteMoney">
						<td class="sub_td">REC 매매 대금</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="outflowOfCash">
						<td>2. 현금유출</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="loan_1">
						<td class="sub_td">차입금 상환(A)</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="interestCost_1">
						<td class="sub_td">이자 비용(A)</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="conversionCharge_1">
						<td class="sub_td">대리 기관 수수료</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="managementCharge_1">
						<td class="sub_td">관리 운영 수수료</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="corporateTax">
						<td class="sub_td">법인세</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="additionalTax">
						<td class="sub_td">부가세</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="rental">
						<td class="sub_td">임대료</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="expense">
						<td class="sub_td">기타비용</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="endOfTermFlow">
						<td>3. 기말 현금 흐름</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr id="endOfTerm">
						<td class="sub_td">기말 현금</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_wrap_type02 mt30">
				<c:set var="siteId" value="${param.site_id}"/>
				<c:if test="${not empty siteId}">
				<button type="button" class="btn_type03" onclick="setCheckedDataModify();">수정</button>
				</c:if>
				<button type="button" class="btn_type03" onclick="list();">목록</button>
				<button type="button" class="btn_type" onclick="historyInit();">이력 확인</button>
			</div>
		</div>
	</div>
</div>