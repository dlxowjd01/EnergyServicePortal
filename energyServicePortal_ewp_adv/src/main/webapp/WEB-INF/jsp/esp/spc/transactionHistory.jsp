<%@ page language='java' contentType='text/html; charset=utf-8' pageEncoding='utf-8'%>
<%@ include file='/decorators/include/taglibs.jsp'%>
<script src='/js/commonDropdown.js'></script>
<script>
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';

	$(function() {
		const tableList = $('#tableBody');
		const tableCloned = tableList.find("template.table-body").clone().html();
		const tableFooter = tableList.find("template.table_footer").clone().html();
		const searchBar = $('.spc-search-bar');
		const searchForm = $('#transactionForm');
		const dropdownOpt = $('#searchOption').find('.dropdown-menu:not(.chk_type) li');
		tableList.find("template").remove();

		let action = 'get';
		let syncOpt = true;
		let options = [
			{
				url: "http://iderms.enertalk.com:8443/spcs?oid="+oid,
				type: action,
				async: syncOpt
			},
			{
				url: 'http://iderms.enertalk.com:8443/spcs/bankbook?oid=' + oid,
				type: action,
				async: syncOpt
			},
			{
				url: 'http://iderms.enertalk.com:8443/spcs/transaction?oid=' + oid,
				type: 'post',
				async: syncOpt
			},
		];

		unCheckAll(searchBar);
		getSpcList(options);
		selectAll($("#spcList"));
		getDataList();
		setDropdownValue(dropdownOpt);

		searchForm.on('submit', function(e){
			e.preventDefault();

			let spcOpts = $('#spcList').find("input:checked");
			let fromDate = $('#fromDate');
			let toDate = $('#toDate');
			let spcStatus = $('#spcStatus').parent().find("input:checked");
			let unitOpt = $('#unitOpt').parent().find('.dropdown-toggle');
			let transactionType = $('#transactionType').parent().find('.dropdown-toggle');
			let purpose = $('#purpose').find("input:checked");
			let warning = $('.warning');
			let formArr = [];

			warning.addClass('hidden');
			formArr.push(spcOpts.val(), fromDate.val(), toDate.val(), spcStatus.val(), unitOpt.val(), transactionType.val(), purpose.val());

			$.each(formArr, function(index, value){
				if(value ==  undefined ||  value == "선택" || value == "" ) {
					warning.eq(index).removeClass('hidden');
				} else {
					warning.eq(index).addClass('hidden');
				}
			});
			if(searchForm.find('.warning.hidden').length == formArr.length){
				getDataList(1,formArr); 
			}
			// getDataList(1); 
		});

		// function nvl(value, str) {
		// 	if (isEmpty(value)) {
		// 		return str;
		// 	} else {
		// 		return value;
		// 	}
		// }

		// function getCsvDown() {
		// 	var column = ['name', '발전소_명', '설치_용량', '관리_운영_기간', '', ''], //json Key
		// 		header = ['SPC명', '발전소 명', '용량', '관리 운영기간	', '이관자료', '첨부파일']; //csv 파일 헤더

		// 	getJsonCsvDownload($('#listData').data('gridJsonData'), column, header, 'spc_spower.csv'); // json list, 컬럼, 헤더명, 파일명
		// }

		function getSpcList(options) {
			const spcList = $('#spcList');
			const cloned = spcList.clone().html();

			$.ajax(options[0]).done(function (json, textStatus, jqXHR) {
				spcList.empty();
				json.data.unshift({"spc_id": "allSelect", "name": "전체"});
				json.data.forEach((item, index) => {
					let listItem = '';
					if(item.name == ""){
						listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, "spc_no_name"+ index);
					} else {
						listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, item.name).replace(/\*uniqName\*/g, item.spc_id + '_'+index);
					}
					spcList.append($(listItem));
				});
				
				spcList.find('input').prop("checked", true);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		function getDataList(page, arr) {
			let spcId = '';
			if(page == undefined){
				page = 1;
			}
			arr==undefined ? spcId = 18 : spcId = arr[0];
			// console.log("spcInd===", arr[0])
			$.ajax({
				url: 'http://iderms.enertalk.com:8443/spcs/' + spcId + '/gens?oid=' + oid,
				// url: 'http://iderms.enertalk.com:8443/spcs/18/gens?oid=' + oid,
				type: 'get',
				async: false,
				success: function(json) {
					$('#searchOption').removeClass('in');
					tableList.empty();
					let data = json.data;
					if (data.length > 0) {
						data.forEach(function (v, k) {
							let str = '';
							let finance = ''
							return new Promise((resolve, reject) => {
								resolve(JSON.parse(v.finance_info))
							}).then(data => {
								finance = data;
							}).catch(error => {
								console.log(error);
								
							}).finally(() => {
								let newTime = v.updated_at.substring(0, 10) + ' ' + v.updated_at.substring(11, 19);
								let latest = finance["계약_체결일"].substring(0, 10) + ' ' + finance["계약_체결일"].substring(11, 19)
								let statusList = ["승인완료", "승인 대기", "승인 증"]
								let assetManager = ["자산운용사A", "자산운용사B", "자산운용사C"]

								str = tableCloned.replace(/\*updated_at\*/g, newTime)
									.replace(/\*transaction_type\*/g, finance["입출금_구분0"])
									.replace(/\*purpose\*/g, v.updated_by)
									.replace(/\*account_type\*/g, finance["계좌구분0"])
									.replace(/\*amount\*/g, finance["대출_약정액"] )
									.replace(/\*latest_update\*/g, latest)
									.replace(/\*updated_by\*/g, loginId)
									.replace(/\*approved_by\*/g, assetManager[k])
									.replace(/\*status\*/g, statusList[k])
								tableList.append(str)
							});
						});
					};
				},
				error: function(request, status, error) {
					alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
				}
			});
		}

		function getNumberIndex(index) {
			return index + 1;
		}

	});
</script>

<div class='row header-wrapper'>
	<div class='col-12'>
		<h1 class='page-header'>입출금 관리 내역</h1>
		<div class='time fr'>
			<span>CURRENT TIME</span>
			<em class='currTime'>${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class='dbTime'>2018-07-27 17:01:02</em>
		</div>
	</div>
</div>

<div class='row spc-search-bar'>
	<div class='col-12'><!--
	--><form id='transactionForm'><!--
		--><span class='tx_tit'>SPC 선택</span><!--
		--><div class='sa_select'>
				<div class='dropdown'>
					<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택" value="">선택<span class='caret'></span></button>
					<ul id='spcList' class='dropdown-menu chk_type' role='menu'>
						<li><!--
						--><a href="javascript:void(0);" tabindex="-1"><!--
							--><input type="checkbox" id="*spcName*" value="*spcId*" name="*uniqName*"><!--
							--><label for="*spcName*">*spcName*</label><!--
						--></a><!--
					--></li><!--
				--></ul>
					<small class="hidden warning">선택해 주세요.</small>
				</div>
			</div>
			<div class='dropdown'>
				<button type='button' id='collapseBtn' class='btn btn-primary dropdown-toggle no_bg ml-24' data-toggle='collapse' data-target='#searchOption'>상세 조건<span class='caret'></span></button>
				<ul id='searchOption' class='collapse dropdown-menu unused'>
					<li>
						<div class='bx_row aN2'>
							<h2 class='comp_tit'>조회 기간</h2>
							<div class='bx_align dropdown'>
								<input type='text' id='fromDate' name='fromDate' class='sel fromDate' value='' autocomplete='off' placeholder='시작'>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
							<div class='bx_align dropdown'>
								<input type='text' id='toDate' name='toDate' class='sel toDate' value='' autocomplete='off' placeholder='종료'>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
						</div>
					</li>
					<li>
						<div class='bx_row aN2'>
							<h2 class='comp_tit'>상태</h2>
							<div class='bx_align dropdown'>
								<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택" value="">선택<span class='caret'></span></button>
								<ul id="spcStatus" class='dropdown-menu chk_type dropdown_offset' role='menu'>
									<li data-value='allSelect'>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='allSelect' value='전체' name=''>
											<label for='allSelect'>전체</label>
										</a>
									</li>
									<li data-value='approved'>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='approved' value='approved' name=''>
											<label for='approved'>승인 완료</label>
										</a>
									</li>
									<li data-value='onHold'>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='onHold' value='onHold' name=''>
											<label for='onHold'>승인 대기</label>
										</a>
									</li>
									<li data-value='inProgress'>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='inProgress' value='inProgress' name='approvalStatus'>
											<label for='inProgress'>승인 중</label>
										</a>
									</li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
						</div>
					</li>
					<li>
						<div class='bx_row aN3'>
							<div class='bx_align dropdown'>
								<h2 class='comp_tit'>단위</h2>
								<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택" value="선택">선택<span class='caret'></span></button>
								<ul id="unitOpt" class='dropdown-menu dropdown_offset' role='menu'>
									<li data-value="yearly"><a href='javascript:void(0)' tabindex='-1'>년</a></li>
									<li data-value="monthly"><a href='javascript:void(0)' tabindex='-1'>월</a></li>
									<li data-value="daily"><a href='javascript:void(0)' tabindex='-1'>일</a></li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>

							<div class='bx_align dropdown'>
								<h2 class='comp_tit'>입출금 구분</h2>
								<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' value="">선택<span class='caret'></span></button>
								<ul id="transactionType" class='dropdown-menu dropdown_offset' role='menu'>
									<li data-value='deposit'><a href='javascript:void(0)' tabindex='-1'>입금</a></li>
									<li data-value='withdraw'><a href='javascript:void(0)' tabindex='-1'>출금</a></li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
							<div class='bx_align'>
								<h2 class='comp_tit'>용도 구분</h2>
								<div class='dropdown'>
									<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택">선택<span class='caret'></span></button>
									<ul id="purpose" class='dropdown-menu chk_type dropdown_offset' role='menu'>
										<li data-value='allPurpose'>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='allPurpose' value='전체' name='purpose'>
												<label for='allPurpose'>전체</label>
											</a>
										</li>
										<li data-value='electricitySalesPrice'>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='electricitySalesPrice' value='electricitySalesPrice' name='purpose'>
												<label for='electricitySalesPrice'>전력판매대금</label>
											</a>
										</li>
										<li data-value='rfcSalesPrice'>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='rfcSalesPrice' value='rfcSalesPrice' name='purpose'>
												<label for='rfcSalesPrice'>RFC 판매대금</label>
											</a>
										</li>
										<li data-value='operationFee'>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='operationFee' value='operationFee' name='purpose'>
												<label for='operationFee'>관리운영비</label>
											</a>
										</li>
										<li data-value='rentalFee'>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='rentalFee' value='rentalFee' name='purpose'>
												<label for='rentalFee'>일반 렌탈</label>
											</a>
										</li>
										<li data-value='commissionFee'>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='commissionFee' value='commissionFee' name='purpose'>
												<label for='commissionFee'>전력 중개 수수료</label>
											</a>
										</li>
										<li data-value='electricityBill'>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='electricityBill' value='electricityBill' name='purpose'>
												<label for='electricityBill'>전기 요금</label>
											</a>
										</li>
										<li data-value='principalCap'>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='principalCap' value='principalCap' name='purpose'>
												<label for='principalCap'>원리금</label>
											</a>
										</li>
									</ul>
									<small class="hidden warning">선택해 주세요.</small>
								</div>
							</div>
						</div>
					</li>
					<li class='btn_wrap_type03 btn_wrap_border'>
						<button type='button' data-toggle='collapse' data-target='#searchOption' class='btn_type03' id='closeDropdown'>취소</button>
						<button type='submit' class='btn_type ml-6' id='renderBtn'>검색</button>
					</li>
				</ul>
			</div>
		</form>
	</div>
</div>

<div class='row spc_transaction'>
	<div class='col-12'>
		<div class='indiv'>
			<div class='spc_tbl'>
				<table class='sort_table table_footer'>
					<colgroup>
						<col style='width:16%'>
						<col style='width:8%'>
						<col style='width:8%'>
						<col style='width:10%'>
						<col style='width:12%'>
						<col style='width:14%'>
						<col style='width:10%'>
						<col style='width:10%'>
						<col style='width:12%'>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th><button class='btn_align down'>기간</button></th>
							<th><button class='btn_align down'>입출금 구분</button></th>
							<th><button class='btn_align down'>용도 구분</button></th>
							<th><button class='btn_align down'>계좌 구분</button></th>
							<th><button class='btn_align down'>금액</button></th>
							<th><button class='btn_align down'>최종 업데이트</button></th>
							<th>요청자</th>
							<th>승인자</th>
							<th class='left'><button class='btn_align down'>상태</button></th>
						</tr>
					</thead>
					<tbody id='tableBody'>
						<tr><td colspan='9' class='no-data center'>데이터가 없습니다.</td></tr></tr>
						<template class='table-body'>
							<tr>
								<td>*updated_at*</td>
								<td>*transaction_type*</td>
								<td>*purpose*</td>
								<td>*account_type*</td>
								<td>*amount*</td>
								<td>*latest_update*</td>
								<td>*updated_by*</td>
								<td>*approved_by*</td>
								<td class='left'><span class="icon_header">*status*</span><span><a href='/spc/withdrawReqEdit.do' class='icon_edit'></a><a href='#' class='icon_delete'></a></span></td>
							</tr>
						</template>
					</tbody>
					<tfoot>
						<tr>
							<template class='table_footer'>
								<td>합계</td>
								<td colspan='3'></td>
								<td>*total*</td>
								<td colspan='4'></td>
							</template>
						</tr>
					</tfoot>
				</table>
				<div class='paging_wrap' id='paging'><a href='javascript:void(0);' class='btn_prev first_prev'>prev</a><a href='javascript:getDataList(1);'><strong>1</strong></a><a href='javascript:void(0);' class='btn_next larst_next'>next</a></div>
			</div>
		</div>
	</div>
</div>