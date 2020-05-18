<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let today = new Date();
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');

	$(function () {
		callAjax({
			url: 'http://iderms.enertalk.com:8443/spcs/${param.spc_id}/balance/month?oid=' + oid + '&site_id=${param.site_id}&yyyymm=${param.yyyymm}',
			type: 'get',
		}, setTable);


		//수기 입력
		$('#noteDown').on('click', function () {
			if ($(this).is(':checked')) {
				$('#balanceTable').find('input[placeholder="자동 입력"]').prop('readonly', false).parent().removeClass('read').addClass('edit');
			} else {
				$('#balanceTable').find('input[placeholder="자동 입력"]').prop('readonly', true).parent().removeClass('edit').addClass('read');
			}
		});
	});

	const callAjax = function (option, callBack, param) {
		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if(typeof callBack == 'function') {
				callBack.call(this, data);
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

	//등록
	const register = function () {
		let standard = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2);
		let rtnObj = new Object();
		let option = {};

		$('#balanceTable input[type="text"]').each(function () {
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

		callAjax(option, saveToList);
	}

	const saveToList = function() {
		alert('저장이 완료되었습니다.');
		list();
		return false;
	}
	const setTable = function (json) {
		let balanceInfo = JSON.parse(json.data[0].balance_info);
		setJsonAutoMapping(balanceInfo, 'balanceTable');
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 원가관리 수정</h1>
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
			<div class="clear">
				<div class="fl">
					<span class="tx_tit">기준</span>
					<div class="sa_select">
						<div class="dropdown" id="year">
							<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">
								${fn:substring(param.yyyymm, 0, 4)}년<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu" id="type">
								<li><a href="#">${fn:substring(param.yyyymm, 0, 4)}년</a></li>
							</ul>
						</div>
					</div>
					<div class="sa_select">
						<div class="dropdown" id="month">
							<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">
								${fn:substring(param.yyyymm, 4, 6)}월<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu">
								<li><a href="#">${fn:substring(param.yyyymm, 4, 6)}월</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="fr">
					<p class="tx_type fl">단위:원</p>
					<div class="chk_type fl">
						<input type="checkbox" id="noteDown" name="noteDown" value="1">
						<label for="noteDown"><span></span>수기입력 활성화</label>
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
								<input type="text" id="loan_1" name="loan_1" value="" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>이자 비용(A)</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="interestCost_1" name="interestCost_1" value=""
								       placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr class="service_chargeTr">
						<th>대리기관 수수료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="conversionCharge_1" name="conversionCharge_1" value=""
								       placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>관리 운영 수수료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="managementCharge_1" name="managementCharge_1" value=""
								       placeholder="자동 입력" readonly>
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
						<th>
							손익 계산서
							<a href="#" class="btn_add fr">추가</a>
						</th>
						<td colspan="3"></td>
					</tr>
					<tr class="th_span">
						<th>
							세무 조정 계산
							<a href="#" class="btn_add fr">추가</a>
						</th>
						<td colspan="3"></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="list()">목록</button>
				<button type="button" class="btn_type" onclick="register()">수정</button>
			</div>
		</div>
	</div>
</div>
