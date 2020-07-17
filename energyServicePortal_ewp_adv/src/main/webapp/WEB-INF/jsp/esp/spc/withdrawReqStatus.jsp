<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="/js/commonDropdown.js"></script>

<script type="text/javascript">
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';

	// unCheckAll($("#reqStatus"));
	selectAll($("#reqStatus"));
	setDropdownValue($("#reqStatus"));
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

		// [자산운용사]
		// "반송" : 0 => redEdit.jsp , "검토 대기" : 1" => do nothing, "검토중" : "2" => withdrawReqStatusDetail, "검토 완료": "3"

		$("#searchForm").on("submit", function(e){
			e.preventDefault();
			let searchOpt = {};
			let checkbox = $("#reqStatus").find("input[type='checkbox']");
			var status= [];
			checkbox.each(function(){
				if($(this).is(":checked")){
					status.push($(this).val())
				}
			});
			searchOpt.status = status;
			searchOpt.keyword = $("#keyword").val().trim().toLowerCase();
			getDataList(1, searchOpt);
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

		function getDataList(page, searchOpt) {
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
					var totalAmount = 0;
					let perPage = 14;
					let startNum = (Number(currentPage) - 1) * perPage;
					let endNum = Number(currentPage) * perPage + 1;
					let data = json.data.slice(startNum, endNum);

					tableBody.empty();
					tableFooter.empty();

					makeNavigation(Number(currentPage), data.length)
					if(filter){
						data.filter((item, index) => {
							filter.status.some(x => {
								if(x == item.status) {
							// console.log("item---", item)
									let found = spcArr.findIndex(x => x.spc_id === item.spc_id);
									let perPage = 14;
									let spc_name = ''
									let total_amount = '';
									let transaction_spc_id = item.spc_id;
									let transaction_req_id = item.request_id;
									let withdraw_account_info = '';
									withdraw_account_info = item.withdraw_bank+item.withdraw_account_no;
									// person
									let requested_by = '';
									let transfer_agent = '';
									let status_changed_by = '';
									// status
									let status = '';
									let status_val = '';
									let link_attr = '';
									// dates
									let withdraw_day = item.withdraw_day.substring(0, 10).replace(/-/g, '') + ' ' + item.withdraw_day.substring(11, 19).replace(/-/g, '');
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
									if(!isEmpty(filter.keyword)){
										totalAmount += item.total_amount;
										$.each(data, function(index, element){
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
														requested_at = item.requested_at.substring(0, 10) + ' ' + item.requested_at.substring(11, 19);
													} else if(index == 4) {
														status_changed_at = item.status_changed_at.substring(0, 10) + ' ' + item.status_changed_at.substring(11, 19);
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

											let str = '';
											str = tableCloned.replace(/\*transactionSpcId\*/g, transaction_spc_id)
												.replace(/\*spcName\*/g, spc_name)
												.replace(/\*transactionReqId\*/g, transaction_req_id)
												.replace(/\*withdrawAccountInfo\*/g, withdraw_account_info)
												.replace(/\*chkOpt\*/g, 'chkOpt_'+ index).replace(/\*reviewOpt\*/g, 'review_opt_'+ index)
												.replace(/\*withdrawDay\*/g, withdraw_day)
												.replace(/\*spcName\*/g, spc_name)
												.replace(/\*statusVal\*/g, status_val)
												.replace(/\*totalAmount\*/g, total_amount)
												.replace(/\*requestedAt\*/g, requested_at).replace(/\*statusChangedAt\*/g, status_changed_at)
												.replace(/\*transferAgent\*/g, transfer_agent).replace(/\*requestedBy\*/g, requested_by)
												.replace(/\*statusChangedBy\*/g, status_changed_by).replace(/\*status\*/g, status).replace(/\*linkAttr\*/g, link_attr)
											tableBody.append($(str));
									} else {
										if( dataArr.includes(filter.keyword)) {
											totalAmount += item.total_amount;
											
											$.each(data, function(index, element){
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
														requested_at = item.requested_at.substring(0, 10) + ' ' + item.requested_at.substring(11, 19);
													} else if(index == 4) {
														status_changed_at = item.status_changed_at.substring(0, 10) + ' ' + item.status_changed_at.substring(11, 19);
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

											let str = '';
											str = tableCloned.replace(/\*transactionSpcId\*/g, transaction_spc_id)
												.replace(/\*spcName\*/g, spc_name)
												.replace(/\*transactionReqId\*/g, transaction_req_id)
												.replace(/\*withdrawAccountInfo\*/g, withdraw_account_info)
												.replace(/\*chkOpt\*/g, 'chkOpt_'+ index).replace(/\*reviewOpt\*/g, 'review_opt_'+ index)
												.replace(/\*withdrawDay\*/g, withdraw_day)
												.replace(/\*spcName\*/g, spc_name)
												.replace(/\*statusVal\*/g, status_val)
												.replace(/\*totalAmount\*/g, total_amount)
												.replace(/\*requestedAt\*/g, requested_at).replace(/\*statusChangedAt\*/g, status_changed_at)
												.replace(/\*transferAgent\*/g, transfer_agent).replace(/\*requestedBy\*/g, requested_by)
												.replace(/\*statusChangedBy\*/g, status_changed_by).replace(/\*status\*/g, status).replace(/\*linkAttr\*/g, link_attr)
											tableBody.append($(str));
										}
									}
								}
							});
						});
						let str = totalAmount.toString();
						let tfootStr = '';
						tfootStr = tfootClone.replace(/\*total\*/g, totalAmount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,'))
						tableFooter.append($(tfootStr));
					} else {
						data.map((item, index) => {
							totalAmount += item.total_amount;
							// console.log("item---", item)
							let found = spcArr.findIndex(x => x.spc_id === item.spc_id);
							let perPage = 14;
							let spc_name = ''
							let total_amount = '';
							let transaction_spc_id = item.spc_id;
							let transaction_req_id = item.request_id;
							let withdraw_account_info = '';
							withdraw_account_info = item.withdraw_bank+item.withdraw_account_no;
							// person
							let requested_by = '';
							let transfer_agent = '';
							let status_changed_by = '';
							// status
							let status = '';
							let status_val = '';
							let link_attr = '';
							// dates
							let withdraw_day = item.withdraw_day.substring(0, 10).replace(/-/g, '') + ' ' + item.withdraw_day.substring(11, 19).replace(/-/g, '');
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
										requested_at = item.requested_at.substring(0, 10) + ' ' + item.requested_at.substring(11, 19);
									} else if(index == 4) {
										status_changed_at = item.status_changed_at.substring(0, 10) + ' ' + item.status_changed_at.substring(11, 19);
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

							let str = '';
							str = tableCloned.replace(/\*transactionSpcId\*/g, transaction_spc_id)
								.replace(/\*spcName\*/g, spc_name)
								.replace(/\*transactionReqId\*/g, transaction_req_id)
								.replace(/\*withdrawAccountInfo\*/g, withdraw_account_info)
								.replace(/\*chkOpt\*/g, 'chkOpt_'+ index).replace(/\*reviewOpt\*/g, 'review_opt_'+ index)
								.replace(/\*withdrawDay\*/g, withdraw_day)
								.replace(/\*spcName\*/g, spc_name)
								.replace(/\*statusVal\*/g, status_val)
								.replace(/\*totalAmount\*/g, total_amount)
								.replace(/\*requestedAt\*/g, requested_at).replace(/\*statusChangedAt\*/g, status_changed_at)
								.replace(/\*transferAgent\*/g, transfer_agent).replace(/\*requestedBy\*/g, requested_by)
								.replace(/\*statusChangedBy\*/g, status_changed_by).replace(/\*status\*/g, status).replace(/\*linkAttr\*/g, link_attr)
							tableBody.append($(str));
						});
						let str = totalAmount.toString();
						let tfootStr = '';
						tfootStr = tfootClone.replace(/\*total\*/g, totalAmount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,'))
						tableFooter.append($(tfootStr));
					}
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

			console.log("totalNav===", totalNav, "navGroup===", navGroup);

			if (navGroup == 1) {
				pageStr += '<a href="javascript:void(0);" data-value="1" class="btn-prev first-arrow"></a>';
			} else {
				let current = startPage -1;
				console.log("totoalPAge===", totalPage)
				pageStr += '<a href="javascript:void(0);" data-value="' + totalPage + '" class="btn-prev last-arrow"></a>';
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
				console.log("navGroup < totalNav===", totalNav, "endPage===", endPage)
				let current = currentPage + 1;
				pageStr += '<a href="javascript:void(0);" class="btn-next" data-value="'+ current +'></a>';
			} else {
				let current = currentPage + 1;
				console.log("navGroup > totalNav===", totalNav, "endPage===", currentPage + 1)
				pageStr += '<a href="javascript:void(0);" class="btn-next" data-value="' + current + '"></a>';
			}
			$('#pagination').append(pageStr);

			$('#pagination a').on("click", function(){
				let page = $(this).data("value");
				if(currentPage == page) {
					return false;
				}

				// let join = spcId.join();
				// newArr.push(join);
				// console.log("newArr----", newArr)
				// console.log("newArr----", newArr)
				getDataList(page);
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
			if ($(this).find('button').length > 0) {
				var table = $(this).parents("table");
				var rows = tableBody.find('tr').toArray().sort(comparer($('.sort_table th').index(this)));
				this.asc = !this.asc;
				if (!this.asc) {
					rows = rows.reverse();
					$(this).addClass('down').removeClass('up');
				} else {
					$(this).removeClass('down').addClass('up');
				}
				for (var i = 0, rowLength = rows.length; i < rowLength; i++) {
					// TO DO !!!!! sorting json data
					tableBody.append(rows[i])
				}
			}
		});
	});

	function goToDetail(self) {
		let spcId = $(self).parent().data("id");
		let spcName = $(self).parent().data("name");
		let reqId = self.data("id");
		let accNum = self.data("value");
		let status = self.text();
		let statusVal = self.parent().data("value");

		$("#reviewStatus").val(status);
		$("#reviewStatusVal").val(statusVal);

		$("#reviewSpcId").val(spcId);
		$("#reviewSpcName").val(spcName);
		$("#reviewReqId").val(reqId);
		$("#reviewAccountInfo").val(accNum);
		// [자산 운용사]
		// "반송" : 0, "검토 중" : "2", "승인완료": "3"	 => /spc/withdrawReqStatusDetail.do
		// "검토 대기" : 1" 						  => /spc/withdrawReqEdit.do
		if(self.parent().data("value")===1) {
			let newData = {}
			newData.status = 2;
			newData.status_changed_by = loginName;
			newData.status_changed_at = new Date().toISOString();
			newData.requested_by = loginName;
			newData.requested_at = new Date().toISOString();

			let opt = {
				url: apiHost + '/spcs/transactions/' + reqId + '?oid=' + oid,
				type: "patch",
				async: true,
				dataType: 'json',
				contentType: "application/json",
				data: JSON.stringify(newData)
			};
			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				$("#reviewDetailForm").submit();

			}).fail(function (jqXHR, textStatus, errorThrown) {
				$("#warningModal .modal-title").text('처리 중 오류가 발생했습니다.');
				$("#warningModal").modal("show");
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});
		} else {
			$("#reviewDetailForm").submit();
		}

	}

</script>

<form id="reviewDetailForm" class="" action="/spc/withdrawReqStatusDetail.do" method="post">
	<input type="hidden" id="reviewSpcId" name="review_spc_id" value=''/>
	<input type="hidden" id="reviewSpcName" name="review_spc_name" value=''/>
	<input type="hidden" id="reviewReqId" name="review_req_id" value=''/>
	<input type="hidden" id="reviewAccountInfo" name="review_acc_info" value=''/>
	<input type="hidden" id="reviewStatus" name="review_status" value=''/>
	<input type="hidden" id="reviewStatusVal" name="review_status_val" value=''/>
</form>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 목록</h1>
		<div class="time fr"><span>CURRENT TIME</span><em class="currTime">${nowTime}</em><span>DATA BASE TIME</span><em class="dbTime"></em></div>
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
		<div class="indiv no_border spc_bal_post">
			<div class="btn_wrap_type01">
				<button type="button" class="btn_type">선택 인쇄</button>
			</div>
			<table class="sort_table table-footer transaction-table">
				<colgroup>
					<col style="width:6%">
					<col style="width:9%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:14%">
					<col style="width:10%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:14%">
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
						<button class="btn_align down">출금 일자</button>
					</th>
					<th>
						<button class="btn_align down">SPC 명</button>
					</th>
					<th>
						<button class="btn_align down">금액</button>
					</th>
					<th>
						<button class="btn_align down">요청/수정일</button>
					</th>
					<th>
						<button class="btn_align down">사무 수탁사</button>
					</th>
					<th>
						<button class="btn_align down">담당자</button>
					</th>
					<th>
						<button class="btn_align down">상태</button>
					</th>

					<th>
						<button class="btn_align down">승인자</button>
					</th>
					<th>
						<button class="btn_align down">승인일</button>
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
							<td>*totalAmount*</td>
							<td>*requestedAt*</td>
							<td>*requestedBy*</td>
							<td>*transferAgent*</td>
							<td data-id="*transactionSpcId*" data-name="*spcName*" data-value="*statusVal*"><a href="javascript:void(0);" data-value="*withdrawAccountInfo*" data-id="*transactionReqId*" onclick="goToDetail($(this))" class="*linkAttr*">*status*</a></td>
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
