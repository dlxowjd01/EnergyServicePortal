<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	let today = new Date();
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';
	const loginMail = '<c:out value="${sessionScope.userInfo.contact_email}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');
	const site_id = '<c:out value="${param.site_id}" escapeXml="false" />';
	const spc_id = '<c:out value="${param.spc_id}" escapeXml="false" />';
	let yyyymm = '<c:out value="${param.yyyymm}" escapeXml="false" />';

	$(function () {

		callAjax({
			url: 'http://iderms.enertalk.com:8443/spcs/${param.spc_id}/balance/month',
			type: 'get',
			data: {
				oid: oid,
				site_id: site_id
			}
		}, setTable);

		//수기 입력
		$('#noteDown').on('click', function () {
			if ($(this).is(':checked')) {
				$('#balanceTable').find('input[placeholder="자동 입력"]').prop('readonly', false).parent().removeClass('read').addClass('edit');
			} else {
				$('#balanceTable').find('input[placeholder="자동 입력"]').prop('readonly', true).parent().removeClass('edit').addClass('read');
			}
		});

		$('input[type="file"]').on('change', function() {
			let uuid = genUuid();
			let thisId = $(this).prop('id');

			$(this).clone().appendTo('#upload');
			$('#upload').find('input').attr('name', uuid).attr('id', uuid);

			callAjax({
				type: 'post',
				enctype: 'multipart/form-data',
				url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
				data: new FormData($('#upload')[0]),
				processData: false,
				contentType: false,
				cache: false,
				timeout: 600000
			}, setUploadAfter, thisId);
		});

		$('button.btn_close').on('click', function() {
			setDefaultFile($(this));
		});

		$(document).on('click', '.dropdown li', function () {
			let dataValue = $(this).data('value');
			let dataText = $(this).text();
			$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);

			yyyymm = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2);

			callAjax({
				url: 'http://iderms.enertalk.com:8443/spcs/${param.spc_id}/balance/month',
				type: 'get',
				data: {
					oid: oid,
					site_id: site_id
				}
			}, setTable);
		});

		siteList.some(function(v, k) {
			if(v.sid == site_id) {
				$('#spcGen').text(v.name);
			}
		});
	});

	const callAjax = function (option, callBack, param) {
		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if(typeof callBack == 'function') {
				callBack.call(this, data, param);
			} else if(typeof callBack == 'string') {
				eval(callBack+'("' + param +'")');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	//목록
	const list = function () {
		location.href = '/spc/balanceSheet.do';
	}
	
	//수정시 현재 페이지 이동
	const nowPage = function () {
		location.href = '/spc/entityDetailsBySite.do?spc_id=' + spc_id + '&site_id=' + site_id + '&balance_yyyy=' + yyyymm;
	}

	//등록
	const register = function () {
		let standard = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2);
		let rtnObj = new Object();
		let option = {};

		$('#balanceTable input[type="text"]').each(function () {
			rtnObj[$(this).prop('name')] = $(this).val().replace(/[^-0-9.]/g, '');
		});

		$('#balanceTable input[type="hidden"]').each(function () {
			rtnObj[$(this).prop('name')] = $(this).val();
		});

		let data = new Object();
		data.balance_info = JSON.stringify(rtnObj);
		data.updated_by = loginId;

		option = {
			url: 'http://iderms.enertalk.com:8443/spcs/${param.spc_id}/balance/month?oid=' + oid + '&site_id=${param.site_id}&yyyymm=${param.yyyymm}',
			type: 'patch',
			dataType: 'json',
			contentType: "application/json",
			traditional: true,
			data: JSON.stringify(data)
		};

		callAjax(option, saveHistory);
	}

	const saveHistory = function() {
		let data = new Object();
		data.ui_id = 1;
		data.spc_id = Number(spc_id);
		data.site_id = site_id;
		data.changed_start = (new Date()).toISOString();
		data.changed_end = (new Date()).toISOString();
		data.contents = $('#year button').data('value') + '년' + $('#month button').data('value') + '월 SPC 원가 관리 정보 수정';
		data.user_login_id = loginId;
		data.user_name = loginName;
		data.user_email = loginMail;

		option = {
			url: 'http://iderms.enertalk.com:8443/spcs/history?oid=' + oid,
			type: 'post',
			dataType: 'json',
			contentType: "application/json",
			traditional: true,
			data: JSON.stringify(data)
		};

		callAjax(option, saveToList);
	}

	const saveToList = function() {
		alert('저장이 완료되었습니다.');
		nowPage();
		return false;
	}

	const setTable = function (json) {
		let dataList = json.data;
		let balanceYear = new Array();

		initTable();
		if(dataList.length > 0) {
			let setIndex = 0;

			//수정 가능한 월 리스트화
			for (var i=0; i<dataList.length; i++) {
				$.map(dataList[i], function(val, key) {
					if(key.match('balance_yyyymm')) {
						balanceYear.push(val);
					}
				});
				if(dataList[i].balance_yyyymm == yyyymm) {
					setIndex = i ;
					break;
				}else{
					setIndex = dataList.length-1; // 처음 시작시 마지막인덱스(최근데이터)로 저장
				}
			}
			setBalanceYear(balanceYear);

			$('#spc').text(json.data[setIndex].spc_name);
			let balanceInfo = JSON.parse(json.data[setIndex].balance_info);
			let income = new Object();
			let taxAdjustment = new Object();

			let num = 0;
			let indexArray = new Array();
			$.map(balanceInfo, function(v, k){
				if(k.match('loan')) {
					let keyName = k.replace(/[^0-9]/g, '');
					if ($.inArray(keyName, indexArray) === -1) indexArray.push(keyName);
				}

				//세금계산서
				if(k.match('income')) {
					if(k.match('_fieldname')) {
						income['fieldname'] = v;
					} else {
						income['originalname'] = v;
					}
				}

				//
				if(k.match('taxAdjustment')) {
					if(k.match('_fieldname')) {
						taxAdjustment['fieldname'] = v;
					} else {
						taxAdjustment['originalname'] = v;
					}
				}
			});

			if(indexArray.length > 0) {
				indexArray.sort();
				indexArray.forEach(index => {
					if (index != 0) {
						let tr = $('<tr>').addClass('interestTr');
						tr.append('<th>차입금 상환(' + String.fromCharCode(Number(index) + 65) + ')</th>');
						tr.append('<td>').find('td').append('<div>').find('div').addClass('tx_inp_type').addClass('read');
						tr.find('div.tx_inp_type').append('<input type="text" id="loan_' + index + '" name="loan_' + index + '" placeholder="자동 입력" readonly>');
						tr.append('<th>이자 비용(' + String.fromCharCode(Number(index) + 65) + ')</th>');
						tr.append('<td>').find('td:eq(1)').append('<div>').find('div').addClass('tx_inp_type').addClass('read');
						tr.find('div:eq(1).tx_inp_type').append('<input type="text" id="interestCost_' + index + '" name="interestCost_' + index + '" placeholder="자동 입력" readonly>');

						$('tr.interestTr').eq($('tr.interestTr').length - 1).after(tr);
					}
				});
			}

			if(!isEmpty(income)) {
				let file = new Object();
				let fileArray = new Array();

				fileArray.push(income);
				file['files'] = fileArray;
				setUploadAfter(file, 'income');
			} else {
				setDefaultFile($('#income'));
			}

			if(!isEmpty(taxAdjustment)) {
				let file = new Object();
				let fileArray = new Array();

				fileArray.push(taxAdjustment);
				file['files'] = fileArray;
				setUploadAfter(file, 'taxAdjustment');
			} else {
				setDefaultFile($('#taxAdjustment'));
			}

			setJsonAutoMapping(balanceInfo, 'balanceTable');
		}
	}

	const setUploadAfter = function(data, propName) {
		if(data.files.length > 0) {
			let prop = $('#'+propName);
			prop.parents('tr').find('label').addClass("hidden");
			prop.parents('tr').find('.btn_close').removeClass("hidden");


			let linkUrl = 'http://iderms.enertalk.com:8443/files/download/'+data.files[0].fieldname+'?oid='+oid + '&orgFilename' + data.files[0].originalname;
			let linkTag = $('<a>').prop('href', linkUrl).html(data.files[0].originalname);
			let pTag = $('<p>').addClass('tx_file').append(linkTag);
			let inpOgin = $('<input>').prop('type', 'hidden').prop('id', propName + '_originalname').prop('name', propName + '_originalname').val(data.files[0].originalname);
			let inpField = $('<input>').prop('type', 'hidden').prop('id', propName + '_fieldname').prop('name', propName + '_fieldname').val(data.files[0].fieldname);
			prop.parent().append(pTag).append(inpOgin).append(inpField);
		}
	}

	const setDefaultFile = function(obj) {
		let tr = obj.parents('tr.th_span');
		tr.find('p.tx_file').remove();
		tr.find('label').show();
		tr.find('button.btn_close').addClass("hidden");

		tr.find('input[name$="_originalname"]').val('');
		tr.find('input[name$="_fieldname"]').val('');
	}

	const setBalanceYear = function(balanceYear) {
		balanceYear.forEach(function(v, idx) {
			let year = v.substring(0 ,4);
			let month = v.substring(4, 6);

			setDropDownMenu($('#year'), year, '년');
			setDropDownMenu($('#month'), month, '월');

			if(v == yyyymm) {
				$('#year button').html(year + '년 <span class="caret"></span>').data('value', year);
				$('#month button').html(month + '월 <span class="caret"></span>').data('value', month);
				return false;
			}else if(balanceYear.length-1 == idx){
				$('#year button').html(year + '년 <span class="caret"></span>').data('value', year);
				$('#month button').html(month + '월 <span class="caret"></span>').data('value', month);
			}
		});
	}

	const setDropDownMenu = function(obj, setVal, suffix) {
		if(obj.find('li').length > 0) {
			let dup = false;
			obj.find('li').each(function() {
				if($(this).data('value') == setVal) {
					return dup = true;
				}
			});

			if(!dup) {
				obj.find('ul').append('<li data-value="' + setVal + '" ><a href="javascript:void(0);">' + setVal + suffix +'</a></li>');
			}
		} else {
			obj.find('ul').append('<li data-value="' + setVal + '" ><a href="javascript:void(0);">' + setVal +  suffix +'</a></li>');
		}
	}

	const initTable = function() {
		let balanceInput = $('#balanceTable input[type="text"]');
		balanceInput.each(function() {
			$(this).val('');
		});

		$('tr.interestTr:not(:eq(0))').remove();
		setDefaultFile($('#income'));
		setDefaultFile($('#taxAdjustment'));
	}
</script>
<!-- 파일 업로드 폼 -->
<form id="upload" name="upload" method="multipart/form-data">
</form>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 금융관리 수정</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv bal_edit">
			<div class="spc_bal_post">
				<table>
					<colgroup>
						<col style="width:50%">
						<col style="width:50%">
					</colgroup>
					<thead>
					<tr>
						<th>SPC 명</th>
						<th>발전소 명</th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<td id="spc">
						</td>
						<td id="spcGen">
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="clear mt30">
				<div class="fl">
					<span class="tx_tit">기준</span>
					<div class="sa_select">
						<div class="dropdown" id="year">
							<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">
<%--								${fn:substring(param.yyyymm, 0, 4)}년--%>
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu">
<%--								<li><a href="javascript:void(0);">${fn:substring(param.yyyymm, 0, 4)}년</a></li>--%>
							</ul>
						</div>
					</div>
					<div class="sa_select">
						<div class="dropdown" id="month">
							<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">
<%--								${fn:substring(param.yyyymm, 4, 6)}월--%>
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu">
<%--								<li><a href="javascript:void(0);">${fn:substring(param.yyyymm, 4, 6)}월</a></li>--%>
							</ul>
						</div>
					</div>
				</div>
				<div class="fr">
					<p class="tx_type fl">단위:원</p>
					<div class="chk_type fl">
						<input type="checkbox" id="noteDown" name="noteDown" value="1">
						<label for="noteDown">수기입력 활성화</label>
					</div>
				</div>
			</div>
			<div class="spc_tbl_row st_edit">
				<table id="balanceTable">
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>전력 판매 대금</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="siteBilling" name="siteBilling" value="" placeholder="자동 입력"
								       readonly>
							</div>
						</td>
						<th>REC 매매대금</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="siteMoney" name="siteMoney" value="" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr class="interestTr">
						<th>차임금 상환(A)</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="loan_0" name="loan_0" value="" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>이자 비용(A)</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="interestCost_0" name="interestCost_0" value="" placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr class="service_chargeTr">
						<th>대리기관 수수료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="conversionCharge_0" name="conversionCharge_0" value="" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>관리 운영 수수료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="managementCharge_0" name="managementCharge_0" value="" placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th>법인세</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="corporateTax" name="corporateTax" value="" placeholder="직접 입력">
							</div>
						</td>
						<th>부가세</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="additionalTax" name="additionalTax" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>임대료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="rental" name="rental" placeholder="자동 계산" readonly>
							</div>
						</td>
						<th>기타 비용</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="expense" name="expense" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>현금 유입 합계</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="inflowOfCash" name="inflowOfCash" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>현금 유출 합계</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="outflowOfCash" name="outflowOfCash" placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th>기말 현금</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="endOfTerm" name="endOfTerm" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>기말 현금흐름</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="endOfTermFlow" name="endOfTermFlow" placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr class="th_span">
						<th>손익 계산서 <label for="income" class="btn_add fr">추가</label></th>
						<td colspan="2">
							<input type="file" id="income" name="income" class="uploadBtn hidden">
							<p class="tx_file">
								<a href="javascript:void(0);" class="filedown"></a>
							</p>
						</td>
						<td><button class="btn_close hidden">삭제</button></td>
					</tr>
					<tr class="th_span">
						<th>세무 조정 계산<label for="taxAdjustment" class="btn_add fr">추가</label></th>
						<td colspan="2">
							<input type="file" id="taxAdjustment" name="taxAdjustment" class="uploadBtn hidden">
							<p class="tx_file">
								<a href="javascript:void(0);" class="filedown"></a>
							</p>
						</td>
						<td><button class="btn_close hidden">삭제</button></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02 mt30">
				<button type="button" class="btn_type03" onclick="list()">목록</button>
				<button type="button" class="btn_type" onclick="register()">수정</button>
			</div>
		</div>
	</div>
</div>
