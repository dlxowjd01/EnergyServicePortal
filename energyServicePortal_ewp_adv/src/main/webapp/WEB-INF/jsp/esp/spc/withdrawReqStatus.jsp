<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	// unCheckAll($("#reqStatus"));
	$(function() {
		const tableBody = $('#tableBody');
		const tableFooter = $('#tableFooter')
		const tableCloned = tableBody.find("template.table-body").clone().html();
		const tfootClone = tableFooter.find("template.table-footer").clone().html();
		const searchBar = $('.spc-search-bar');
		const dropdownOpt = $('#searchOption').find('.dropdown-menu:not(.chk_type) li');
		const perPage = 14;

		var spcArr = [];
		tableBody.find("template").remove();
		tableFooter.find("template").remove();

		// $("#warningModal .modal-title").text('처리 중 오류가 발생했습니다.');
		// $("#warningModal").modal("show");
		unCheckAll($("#reqStatus"));
		unCheckAll($('#tableBody').parents(".sort_table "));
		getSpcList();

		selectAll($("#reqStatus"));
		setDropdownValue($("#reqStatus"));
		// [자산운용사]
		// "반송" : 0 => redEdit.jsp , "검토 대기" : 1" => do nothing, "검토중" : "2" => withdrawReqStatusDetail, "검토 완료": "3"

		$("#searchForm").on("submit", function(e){
			e.preventDefault();
			let searchOpt = {};
			let checkbox = $("#reqStatus").find("input[type='checkbox']");
			var status= [];

			if (checkbox.first().is(':checked')) {
				checkbox.each(function(){
					status.push($(this).val())
				});
			} else {
				checkbox.each(function(){
					if($(this).is(":checked")){
						status.push($(this).val())
					}
				});
			}
			searchOpt.status = status;
			searchOpt.keyword = $("#keyword").val().trim().toLowerCase();

			if (isEmpty(searchOpt.status) && isEmpty(searchOpt.keyword)) {
				getDataList(1, null);
			} else {
				getDataList(1, searchOpt);
			}
		});

		function getSpcList() {
			let action = 'get';
			let syncOpt = true;
			let option = {
				url: apiHost + "/spcs?oid="+oid,
				type: action,
				async: syncOpt
			}
			$.ajax(option).done(function (json, callBack, param) {
				let spcInfoList = [];
				json.data.forEach((item, index) => {
					let obj = {
						spc_id: item.spc_id,
						spc_name: item.name
					}
					spcArr.push(obj);
					// spcInfoList.push(obj);
				});
				getDataList(1);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		function getDataList(page, searchOpt, sortOpt) {
			var sortList = [];
			var currentPage = '';
			let action = 'get';
			let syncOpt = true;
			let option= {
				url: apiHost + '/spcs/transactions',
				type: action,
				data: {
					'oid' : oid
				},
				async: syncOpt
			}
			var filter = searchOpt;
			page == undefined ? currentPage = "1" : currentPage = page;

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				if (json.data.length > 0) {
					let data = json.data;

					if (filter) {
						data = data.filter(item => {
							if (!isEmpty(filter.status)) {
								let found = spcArr.findIndex(x => x.spc_id === item.spc_id);
								let spc_name = spcArr[found].spc_name;
								if (!isEmpty(filter.keyword)) {
									return $.inArray(String(item.status), filter.status) >= 0 && spc_name.toLowerCase().match((filter.keyword)) ;
								} else {
									return ($.inArray(String(item.status), filter.status) >= 0);
								}
							} else {
								let found = spcArr.findIndex(x => x.spc_id === item.spc_id);
								let spc_name = spcArr[found].spc_name;
								return spc_name.toLowerCase().match((filter.keyword));
							}
						});
					}

					makeNavigation(Number(currentPage), data.length)
					var totalAmount = 0;
					let perPage = 14;
					let startNum = (Number(currentPage) - 1) * perPage;
					let endNum = Number(currentPage) * perPage + 1;

					tableBody.empty();
					tableFooter.empty();

					let refineList = new Array();
					data.map((item, index) => {
						totalAmount += item.total_amount;
						// console.log("item---", item)
						let found = spcArr.findIndex(x => x.spc_id === item.spc_id);
						let perPage = 14;
						let spc_name = ''
						let total_amount = '';
						let transaction_spc_id = item.spc_id;
						let transaction_req_id = item.request_id;
						let bank_name = item.withdraw_bank;
						let withdraw_acc_num = item.withdraw_account_no;

						// person
						let requested_by = '';
						let transfer_agent = '';
						let status_changed_by = '';
						// status
						let status = '';
						let status_val = '';
						let link_attr = '';
						// dates
						// console.log("e----", item.withdraw_day)
						let withdraw_day = item.withdraw_day.substring(0, 4) + '-' + item.withdraw_day.substring(4, 6) + '-' + item.withdraw_day.substring(6, 8);
						let requested_at = ''
						let status_changed_at = '';

						let dataArr = [
							item.total_amount,
							spcArr[found].spc_name,
							item.status,

							item.requested_at,
							item.status_changed_at,

							item.requested_by,
							item.status_changed_by,
							item.transfer_agent,
						];

						$.each(dataArr, function(index, element){
							if((!isEmpty(element)) && element != "string") {
								if(index==0) {
									total_amount = item.total_amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원'
								} else if(index==1){
									spc_name = spcArr[found].spc_name;
								} else if(index==2) {
									if (item.status == 0 ) {
										status="반송";
										link_attr = "text-link";
										status_val = 0;
									} else if (item.status == 1) {
										status="검토 대기";
										link_attr = "text-link";
										status_val = 1;
									} else if (item.status == 2) {
										status="검토 중";
										link_attr = "text-link";
										status_val = 2;
									} else if (item.status==3 ) {
										status="승인 완료";
										link_attr = "text-blue";
										status_val = 3;
									}
								} else if(index == 3) {
									requested_at = new Date(item.requested_at).format('yyyy-MM-dd HH:mm:ss');
								} else if(index == 4) {
									status_changed_at = new Date(item.status_changed_at).format('yyyy-MM-dd HH:mm:ss');
								} else if(index == 5){
									requested_by = item.requested_by;
								} else if(index == 6) {
									status_changed_by = item.status_changed_by;
								} else if(index == 7) {
									transfer_agent = item.transfer_agent;
								}
							} else {
								if(index==0) {
									total_amount = '-';
								} else if(index==1){
									spc_name = '-'
								} else if(index==2) {
									status = '-';
									link_attr = '-';
								} else if(index == 3) {
									requested_at = '-';
								} else if(index == 4) {
									status_changed_at = '-'
								} else if(index == 5){
									requested_by = '-'
								} else if(index == 6) {
									status_changed_by = '-'
								} else if(index == 7) {
									transfer_agent = '-'
								}
							}
						});

						refineList.push({
							transactionSpcId: transaction_spc_id,
							spcName: spc_name,
							transactionReqId: transaction_req_id,
							bankName: bank_name,
							accNum: withdraw_acc_num,
							chkOpt: 'chkOpt_'+ index,
							reviewOpt: 'review_opt_'+ index,
							withdrawDay: withdraw_day,
							statusVal: status_val,
							totalAmount: total_amount,
							requestedAt: requested_at,
							statusChangedAt: status_changed_at,
							transferAgent: transfer_agent,
							requestedBy: requested_by,
							statusChangedBy: status_changed_by,
							status: status,
							linkAttr: link_attr
						});
					});

					if (sortOpt) {
						refineList.sort(function(a, b) {
							var cell1 = a[sortOpt.column];
							var cell2 = b[sortOpt.column];

							if (sortOpt.column == 'totalAmount') {
								cell1 = cell1.replace('원', '').trim();
								cell2 = cell2.replace('원', '').trim();
							}

							cell1 = String(cell1).replace(/^\s+|\s+$/g, '');
							cell2 = String(cell2).replace(/^\s+|\s+$/g, '');

							if (isNumberic(cell1) && isNumberic(cell2)) {
								cell1 = Number(cell1.replace(/[^0-9]/g, ''));
								cell2 = Number(cell2.replace(/[^0-9]/g, ''));
							}

							if (sortOpt.sort == 'up') {
								if (cell1 < cell2) return -1;
								if (cell1 > cell2) return 1;
							} else {
								if (cell1 < cell2) return 1;
								if (cell1 > cell2) return -1;
							}

							return 0;
						});
					}

					refineList = refineList.slice(startNum, endNum);
					refineList.forEach(refine => {
						let str = '';
						str = tableCloned.replace(/\*transactionSpcId\*/g, refine.transactionSpcId)
						.replace(/\*spcName\*/g, refine.spcName)
						.replace(/\*transactionReqId\*/g, refine.transactionReqId)
						.replace(/\*bankName\*/g, refine.bankName).replace(/\*accNum\*/g, refine.accNum)
						.replace(/\*chkOpt\*/g, refine.chkOpt).replace(/\*reviewOpt\*/g, refine.reviewOpt)
						.replace(/\*withdrawDay\*/g, refine.withdrawDay)
						.replace(/\*statusVal\*/g, refine.statusVal)
						.replace(/\*totalAmount\*/g, refine.totalAmount)
						.replace(/\*requestedAt\*/g, refine.requestedAt).replace(/\*statusChangedAt\*/g, refine.statusChangedAt)
						.replace(/\*transferAgent\*/g, refine.transferAgent).replace(/\*requestedBy\*/g, refine.requestedBy)
						.replace(/\*statusChangedBy\*/g, refine.statusChangedBy).replace(/\*status\*/g, refine.status).replace(/\*linkAttr\*/g, refine.linkAttr)
						tableBody.append($(str));
					});

					let str = totalAmount.toString();
					let tfootStr = '';
					tfootStr = tfootClone.replace(/\*total\*/g, totalAmount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,'))
					tableFooter.append($(tfootStr));
				} else {
					return false;
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		function makeNavigation (currentPage, dataLength) {
			// console.log("spc===", spcId)
			$('#pagination').empty();
			let pageStr = '';
			let totalPage = Math.ceil( dataLength / perPage );
			let navGroup = Math.floor((page - 1) / perPage) + 1;
			let startPage = ((navGroup - 1) * perPage) + 1;
			let totalNav = Math.ceil(totalPage / perPage);
			let endPage = ((startPage + perPage - 1) > totalPage) ? totalPage : (startPage + navCount - 1);

			if (navGroup == 1) {
				pageStr += '<a href="javascript:void(0);" data-value="1" class="btn-prev first-arrow"></a>';
			} else {
				let current = startPage -1;
				pageStr += '<a href="javascript:void(0);" data-value="' + (startPage - 1) + '" class="btn-prev last-arrow"></a>';
			}

			for (let i = startPage ; i <= endPage; i++) {
				// console.log("startPage===", startPage)
				if (i==currentPage) {
					pageStr += '<a href="javascript:void(0);" class="active" data-value="'+ i +'">'+i+'</a>';
				} else {
					pageStr += '<a href="javascript:void(0)" class="" data-value="'+ i +'">'+i+'</a>';
				}
			}

			if (navGroup < totalNav) {
				let current = endPage + 1;
				pageStr += '<a href="javascript:void(0);" class="btn-next" data-value="'+ current +'"></a>';
			} else {
				pageStr += '<a href="javascript:void(0);" class="btn-next" data-value="' + endPage + '"></a>';
			}
			$('#pagination').append(pageStr);

			$('#pagination a').on("click", function(){
				let page = $(this).data("value");
				if(currentPage == page) {
					return false;
				}

				let searchOpt = {};
				let checkbox = $("#reqStatus").find("input[type='checkbox']");
				var status= [];

				if (checkbox.first().is(':checked')) {
					checkbox.each(function(){
						status.push($(this).val())
					});
				} else {
					checkbox.each(function(){
						if($(this).is(":checked")){
							status.push($(this).val())
						}
					});
				}
				searchOpt.status = status;
				searchOpt.keyword = $("#keyword").val().trim().toLowerCase();

				let sortOption = new Object();
				$('.sort_table th button').each(function() {
					if ($(this).hasClass('up') || $(this).hasClass('down')) {
						let columnName = $(this).data('column');
						if ($(this).hasClass('up')) {
							sortOption['column'] = columnName;
							sortOption['sort'] = 'up';
						} else {
							sortOption['column'] = columnName;
							sortOption['sort'] = 'down';
						}
					}
				});

				if (isEmpty(searchOpt.status) && isEmpty(searchOpt.keyword)) {
					getDataList(page, null, sortOption);
				} else {
					getDataList(page, searchOpt, sortOption);
				}
				return false;
			});

		}
		function getNumberIndex(index) {
			return index + 1;
		}

		function comparer(index) {
			return function(a, b) {
				var valA = getCellValue(a, index), valB = getCellValue(b, index);
				if (index == 3) {
					valA = valA.replace(/[^0-9]/g, ''), valB = valB.replace(/[^0-9]/g, '')
				}
				return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.toString().localeCompare(valB)
			}
		}

		function getCellValue(row, index){
			return $(row).children('td').eq(index).text()
		}

		$("#selectAll").on("click", function(){
			$("#tableBody").find('input:checkbox').prop('checked', this.checked);
		});

		$('.sort_table th').click(function(){
			let thisBtn = $(this).find('button');
			if (thisBtn.length > 0) {
				let column = thisBtn.data('column');
				// var table = $(this).parents("table");
				// var rows = tableBody.find('tr').toArray().sort(comparer($('.sort_table th').index(this)));

				let searchOpt = {};
				let checkbox = $("#reqStatus").find("input[type='checkbox']");
				var status= [];

				if (checkbox.first().is(':checked')) {
					checkbox.each(function(){
						status.push($(this).val())
					});
				} else {
					checkbox.each(function(){
						if($(this).is(":checked")){
							status.push($(this).val())
						}
					});
				}
				searchOpt.status = status;
				searchOpt.keyword = $("#keyword").val().trim().toLowerCase();

				if (isEmpty(searchOpt.status) && isEmpty(searchOpt.keyword)) {
					searchOpt = null;
				}

				if (thisBtn.hasClass('up')) {
					thisBtn.addClass('down').removeClass('up');
					getDataList(1, searchOpt, {column: column, sort: 'down'});
				} else {
					thisBtn.removeClass('down').addClass('up');
					getDataList(1, searchOpt, {column: column, sort: 'up'});
				}


				// for (var i = 0, rowLength = rows.length; i < rowLength; i++) {
				// 	// TO DO !!!!! sorting json data
				// 	tableBody.append(rows[i])
				// }
			}
		});
	});

	function goToDetail(self) {
		let spcId = $(self).parent().data("id");
		let spcName = $(self).parent().data("name");
		let reqId = self.data("req-id");
		let bankName = self.data("name")
		let accNum = self.data("value");
		let status = self.text();
		let statusVal = self.parent().data("value");
		let accInfo = bankName + ' ' + accNum;
		// console.log("accInfo===", accInfo);

		$("#reviewStatus").val(status);
		if(statusVal == 1 && task == 2){
			status = "검토 중";
			statusVal = 2;
			$("#reviewStatus").val(status);
			$("#reviewStatusVal").val(statusVal);
			// console.log("reqId===", reqId)
			updateStatus(statusVal, reqId)
		} else {
			$("#reviewStatus").val(status);
			$("#reviewStatusVal").val(statusVal);
		}
		$("#reviewSpcId").val(spcId);
		$("#reviewSpcName").val(spcName);
		$("#reviewReqId").val(reqId);
		$("#reviewAccountInfo").val(accInfo);

		
		let action = 'get';
		let syncOpt = true;
		let option = {
			url: apiHost + '/spcs/' + spcId + '?oid=' + oid + "&includeGens=true",
			type: action,
			async: syncOpt
		}
		submit(option, accInfo, accNum, statusVal);
		// [자산 운용사]
		// "반송" : 0, "검토 중" : "2", "승인완료": "3"	 => /spc/withdrawReqStatusDetail.do
		// "검토 대기" : 1" 						  => /spc/withdrawReqEdit.do
	}

	function updateStatus(newStatus, id) {
		let jsonData = {};
		jsonData.status = Number(newStatus);
		jsonData.status_changed_by = loginName;
		jsonData.status_changed_at = new Date();
		jsonData = JSON.stringify(jsonData);

		let action = 'patch';
		let syncOpt = true;
		let option = {
			url: apiHost + '/spcs/transactions/' + id + '?oid=' + oid,
			type: 'patch',
			async: true,
			dataType: 'json',
			contentType: "application/json",
			data: jsonData
		}
		$.ajax(option).done(function (json, textStatus, jqXHR) {
			// console.log("success---", json)
		}).fail(function (jqXHR, textStatus, errorThrown) {
			// console.log("error==", jqXHR)
			return false;
		});

	}

	function submit(opt, accInfo, accNum, statusVal){
		let option = opt;
		let statusValue = statusVal;
		let accountInfo = accInfo;
		$.ajax(option).done(function (json, textStatus, jqXHR) {
			if (json.data[0].spcGens && json.data[0].spcGens.length > 0 ) {
				let gensInfo = json.data[0].spcGens;
				var promises = [];

				$.each(gensInfo, function(index, element){
					promises.push(Promise.resolve(JSON.parse(element.finance_info)));
				});

				Promise.all(promises).then(res => {
					res.map(x => {
						Object.entries(x).map((item, index) => {
							const strAccNum = "계좌_번호";
							const accHolder = "예금주";

							if (typeof accNum == 'number') {
								accNum = String(accNum);
							}
							const num = accNum.replace(/[^0-9]/g, '');

							if (typeof item[1] === 'string') {
								const itmeAcc = item[1].replace(/[^0-9]/g, '');

								if(itmeAcc == num.toString()){
									let txt = item[0];
									let newTxt = txt.replace(/계좌_번호/g, '');
									let name = '  (' + x[accHolder+newTxt] + ')';
									$("#reviewAccountHolder").val(name);
									setTimeout(function(){
										$("#reviewDetailForm").submit();
									}, 300);
								}
							}
						});
					});
				});
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			return false;
		});

		// console.log("submit===", $(self))
		// let accInfo = self.data("name") + '  ' + self.data("value") + '  (' + name + ')';
	}


</script>

<form id="reviewDetailForm" class="" action="/spc/withdrawReqStatusDetail.do" method="post">
	<input type="hidden" id="reviewSpcId" name="req_detail_spc_id" value=''/>
	<input type="hidden" id="reviewSpcName" name="req_detail_spc_name" value=''/>
	<input type="hidden" id="reviewReqId" name="req_detail_req_id" value=''/>
	<input type="hidden" id="reviewAccountHolder" name="req_detail_acc_holder" value=''/>
	<input type="hidden" id="reviewAccountInfo" name="req_detail_acc_info" value=''/>
	<input type="hidden" id="reviewStatus" name="req_detail_status" value=''/>
	<input type="hidden" id="reviewStatusVal" name="req_detail_status_val" value=''/>
</form>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 목록</h1>
		<div class="time fr"><span>CURRENT TIME</span><em class="currTime">${nowTime}</em></div>
	</div>
</div>

<form id="searchForm" name="search_form">
	<div class="row spc-search-bar">
		<div class="col-12">
			<div class="sa_select"><!--
				--><span class="tx_tit">검토 상태</span><!--
				--><div id="reqStatus" class="dropdown"><!--
				--><button class="btn btn-primary dropdown-toggle unused" type="button" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button><!--
				--><ul class="dropdown-menu chk_type" role="menu"><!--
					--><li data-value="1,2,3" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="all" name="review_status" value="all"><label for="all">전체</label></a></li><!--
					--><li data-value="2" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="wait" name="review_status" value="2"><label for="wait">검토 중</label></a></li><!--
					--><li data-value="1" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="inProgress" name="review_status" value="1"><label for="inProgress">검토 대기</label></a></li><!--
					--><li data-value="3" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="complete" name="review_status" value="3"><label for="complete">승인 완료</label></a></li><!--
					--><li data-value="3" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="reject" name="review_status" value="0"><label for="reject">반송</label></a></li><!--
				--></ul>
				</div>
			</div><!--
			--><div class="sa_select">
				<div class="tx_inp_type mr-16"><input type="text" id="keyword" placeholder="입력"></div>
				<button type="submit" class="btn_type">검색</button>
			</div>
		</div>
	</div>
</form>
<div class="row content-wrapper">
	<div class="col-lg-12">
		<div class="indiv no_border spc_tbl">
			<div class="btn_wrap_type01">
<%--				<button type="button" class="btn_type">선택 인쇄</button>--%>
			</div>
			<table class="sort_table table-footer transaction-table">
				<colgroup>
					<col style="width:5%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:10%">
					<col style="width:15%">
					<col style="width:10%">
					<col style="width:9%">
					<col style="width:7%">
					<col style="width:9%">
					<col style="width:15%">
					<col>
				</colgroup>
				<thead>
				<tr>
					<th>
						<a class="chk_type select_row">
							<input type="checkbox" id="selectAll" name="select_all">
							<label for="selectAll"></label>
						</a>
					</th>
					<th>
						<button class="btn_align" data-column="withdrawDay">출금 일자</button>
					</th>
					<th>
						<button class="btn_align" data-column="spcName">SPC 명</button>
					</th>
					<th class="right">
						<button class="btn_align" data-column="totalAmount">금액</button>
					</th>
					<th>
						<button class="btn_align" data-column="requestedAt">요청/수정일</button>
					</th>
					<th>
						<button class="btn_align" data-column="requestedBy">사무 수탁사</button>
					</th>
					<th>
						<button class="btn_align" data-column="transferAgent">담당자</button>
					</th>
					<th>
						<button class="btn_align" data-column="status">상태</button>
					</th>

					<th>
						<button class="btn_align" data-column="statusChangedBy">승인자</button>
					</th>
					<th>
						<button class="btn_align" data-column="statusChangedAt">승인일</button>
					</th>
				</tr>
				</thead>
				<tbody id='tableBody'>
					<tr><td colspan='10' class='no-data center'>데이터가 없습니다.</td></tr></tr>
					<template class='table-body'>
						<tr>
							<td><a class="chk_type select_row"><input type="checkbox" id="*chkOpt*" name="reviewOpt"><label for="*chkOpt*"></label></a></td>
							<td>*withdrawDay*</td>
							<td>*spcName*</td>
							<td class="right">*totalAmount*</td>
							<td>*requestedAt*</td>
							<td>*requestedBy*</td>
							<td>*transferAgent*</td>
							<td data-id="*transactionSpcId*" data-name="*spcName*" data-value="*statusVal*"><button type="button" data-name="*bankName*" data-value="*accNum*" data-req-id="*transactionReqId*" onclick="goToDetail($(this))" class="*linkAttr* clear-btn">*status*</button></td>
							<td>*statusChangedBy*</td>
							<td>*statusChangedAt*</td>
						</tr>
					</template>
				</tbody>
				<tfoot id="tableFooter">
					<template class='table-footer'>
						<tr>
							<td></td>
							<td>합계</td>
							<td></td>
							<td>*total* 원</td>
							<td colspan="6"></td>
						</tr>
					</template>
				</tfoot>
			</table>
			<div class='pagination' id='pagination'></div>
		</div>
	</div>
</div>
