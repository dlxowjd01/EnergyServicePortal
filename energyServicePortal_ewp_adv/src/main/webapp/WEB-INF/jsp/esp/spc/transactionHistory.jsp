<%@ page language='java' contentType='text/html; charset=utf-8' pageEncoding='utf-8'%>
<%@ include file='/decorators/include/taglibs.jsp'%>
<script type="text/javascript">
	const pathName = location.pathname;

	$(function() {
		const tableBody = $('#tableBody');
		const tableFooter = $('#tableFooter')
		const tbodyClone = tableBody.find("template.table-body").clone().html();
		const tfootClone = tableFooter.find("template.table-footer").clone().html();
		const searchForm = $('#transactionForm');

		let spcInfoArr = [];

		$('#unitOpt').find("li").on('click', function () {
			$('#toDate').datepicker('setDate', 'today')
			if ($(this).data('value') == 'daily') {
				$('#fromDate').datepicker('setDate', 'today');
			} else if ($(this).data('value') == 'monthly') {
				$('#fromDate').datepicker('setDate', '-30');
			} else if ($(this).data('value') == 'yearly') {
				$('#fromDate').datepicker('setDate', '-365');
			}
		});

		$('.sort-table th').click(function(){
			if ($(this).find('button').length > 0) {
				let rows = tableBody.find('tr').toArray().sort(comparer($('.sort-table th').index(this)))
				this.asc = !this.asc;
				if (!this.asc){
					rows = rows.reverse();
					$(this).addClass('down').removeClass('up');
				} else {
					$(this).removeClass('down').addClass('up');
				}
				for (var i = 0, rowLength = rows.length; i<rowLength; i++){
					// TO DO !!!!! sorting json data
					tableBody.append(rows[i])
				}
			}
		});

		searchForm.on('submit', function(e){
			e.preventDefault();
			let page = 1;
			let formArr = new Array();
			let transactionType = $('#transactionType').parent().find('.dropdown-toggle');
			let warning = $('.warning');

			const newStartDate = $('#fromDate').val().replace(/-/g, '');
			const newEndDate = $('#toDate').val().replace(/-/g, '');

			let selectedSpc = new Array();
			let selectedStatus = new Array();
			let selectedPurpose= new Array();

			document.querySelectorAll('#spcList input:checked').forEach(inp => {
				selectedSpc.push(inp.dataset.value);
			});
			document.querySelectorAll('#spcStatus input:checked').forEach(inp => {
				selectedStatus.push(inp.dataset.value);
			});
			document.querySelectorAll('#spcPurposeList input:checked').forEach(inp => {
				selectedPurpose.push(inp.dataset.value);
			});

			warning.addClass('hidden');
			//formArr.push(selectedSpc.toString(), newStartDate, newEndDate, selectedStatus.toString(), transactionType.data("value"));
			formArr.push(selectedSpc.toString(), newStartDate, newEndDate, selectedStatus.toString(), transactionType.data("value"), selectedPurpose.toString());

			Object.entries(formArr).forEach((target, index) => {
				const tVal = target[1];
				if(isEmpty(tVal) ||  tVal == '선택') {
					warning.eq(index).removeClass('hidden');
				} else {
					warning.eq(index).addClass('hidden');
				}
			});

			window.sessionStorage.setItem(pathName + '_spc', selectedSpc); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_status', selectedStatus); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_purpose', selectedPurpose); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_start', newStartDate); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_end', newEndDate); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_type', transactionType.data("value")); //세션스토리지에 저장한다.
			if(searchForm.find('.warning.hidden').length == formArr.length){
				getDataList(page, formArr);
			} else {
				return false;
			}
		});

		pageInit();

		function pageInit () {
			tableBody.find("template").remove();
			tableFooter.find("template").remove();
			$('#fromDate').datepicker('setDate', '-15');
			$('#toDate').datepicker('setDate', '+15');

			return new Promise((resolve, reject) => {
				const spcList = $('#spcList');
				const cloned = spcList.clone().html();
				$.ajax({
					url: apiHost + '/spcs?oid=' + oid,
					type: 'get',
				}).done(function (json) {
					spcList.empty();
					(json.data).forEach((item, index) => {
						let listItem = '';
						let uniq = item.spc_id + '_' + index;
						let spcObj = {
							spc_id: item.spc_id,
							spc_name: item.name
						}
						spcInfoArr.push(spcObj);

						if(isEmpty(item.name)){
							listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, "spc_no_name"+ index).replace(/\*uniqName\*/g, uniq);
						} else {
							listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, item.name).replace(/\*uniqName\*/g, uniq);
						}
						spcList.append($(listItem));
					});
					spcList.append(`<li class="btn-wrap-type03 btn-wrap-border"><button type="button" class="btn-type mr-16">적용</button></li>`);
					resolve('');
				}).fail(function (jqXHR, textStatus, errorThrown) {
					reject('');
				});
			}).then(() => {
				const spcList = window.sessionStorage.getItem(pathName + '_spc');
				const statusList = window.sessionStorage.getItem(pathName + '_status');
				const purposeList = window.sessionStorage.getItem(pathName + '_purpose');
				const start = window.sessionStorage.getItem(pathName + '_start');
				const end = window.sessionStorage.getItem(pathName + '_end');
				const type = window.sessionStorage.getItem(pathName + '_type');

				if (!isEmpty(spcList)) {
					let spcArray = new Array();
					if (spcList.match(',')) {
						spcArray = spcList.split(',');
					} else {
						spcArray.push(spcList);
					}
					document.querySelectorAll('#spcList input').forEach(inp => {
						if (spcArray.includes(inp.dataset.value)) {
							inp.checked = true;
						} else {
							inp.checked = false;
						}
					});

					displayDropdown($('#spcList').parents('div.dropdown'));
				}

				if (!isEmpty(start)) {
					const targetDate = new Date(start.replace(/(\d{4})(\d{2})(\d{2})/, '$1,$2,$3'));
					$('#fromDate').datepicker('setDate', targetDate);
				}

				if (!isEmpty(end)) {
					const targetDate = new Date(end.replace(/(\d{4})(\d{2})(\d{2})/, '$1,$2,$3'));
					$('#toDate').datepicker('setDate', targetDate);
				}

				if (!isEmpty(statusList)) {
					let statusArray = new Array();
					if (statusList.match(',')) {
						statusArray = statusList.split(',');
					} else {
						statusArray.push(statusList);
					}
					document.querySelectorAll('#spcStatus input').forEach(inp => {
						if (statusArray.includes(inp.dataset.value)) {
							inp.checked = true;
						} else {
							inp.checked = false;
						}
					});
					displayDropdown($('#spcStatus').parents('div.dropdown.box-align'));
				}

				if (!isEmpty(type)) {
					let displayText = '전체';
					if (type === 'deposit') {
						displayText = '입금';
					} else if (type === 'withdraw') {
						displayText = '출금';
					}

					$('#transactionType').parent().find('.dropdown-toggle').data('value', type).html(displayText + '<span class="caret"></span>');
				}

				if (!isEmpty(purposeList)) {
					let purposArray = new Array();
					if (purposeList.match(',')) {
						purposArray = purposeList.split(',');
					} else {
						purposArray.push(purposeList);
					}

					document.querySelectorAll('#spcPurposeList input').forEach(inp => {
						if (purposArray.includes(inp.dataset.value)) {
							inp.checked = true;
						} else {
							inp.checked = false;
						}
					});
				 displayDropdown($('#spcPurposeList').parents('div.dropdown.box-align'));
				}

				searchForm.submit();
			}).catch(() => {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			})
		}

		function getDataList(page, searchOptArr) {
			let currentPage = '';
			page == undefined ? currentPage = "1" : currentPage = page;
			if(!isEmpty(searchOptArr)) {
				let action = 'get';
				let syncOpt = true;
				let option = {};
				if(searchOptArr.length>1){
					option= {
						url: apiHost + '/spcs/transactions',
						type: action,
						data: {
							'oid' : oid,
							'spcIds' : searchOptArr[0],
							'startDay' : searchOptArr[1],
							'endDay' : searchOptArr[2]
						},
						async: syncOpt
					}
				} else {
					option = {
						url: apiHost + '/spcs/transactions',
						type: action,
						data: {
							'oid' : oid,
							'spcIds' : searchOptArr[0]
						},
						async: syncOpt
					}
				}

				$.ajax(option).done(function (json, textStatus, jqXHR) {
					$('#searchOption').removeClass('in');
					$('#tableBody').empty();
					$('#tableFooter').empty();
					if (json.data.length > 0) {
						let perPage = 14;
						let startNum = (Number(currentPage) - 1) * perPage;
						let endNum = Number(currentPage) * perPage + 1;

						if(searchOptArr.length > 1) {
							if (searchOptArr[4] != 'deposit') {
								let statusOpt = [...searchOptArr[3].split(",")];
								let newData = json.data.filter(x => {
									return statusOpt.indexOf(x.status.toString()) > -1
								});
								ajaxCallback(Number(currentPage), newData, searchOptArr);
							}
						} else {
							ajaxCallback(Number(currentPage), json.data);
						}
					}
				}).fail(function (jqXHR, textStatus, errorThrown) {
					alert('처리 중 오류가 발생했습니다.');
					return false;
				});
			} else {
				$("#warningModal .modal-title").text("검색된 SPC 가 없습니다.");
				$("#warningModal").modal("show");
			}
		}

		function ajaxCallback(currentPage, newData, arr) {
			let totalAmount = 0;
			let page = currentPage;
			let index = 0;
			newData.map(item => {
				totalAmount += item.total_amount;
				if(!isEmpty(arr)) {
					item.opt = arr;	
				}

				return new Promise((resolve, reject) => {
					let jsonObj = JSON.parse(item.to_account);
					if(!isEmpty(item.opt)){
						let acc = [...item.opt[5].split(',')];
						jsonObj = jsonObj.filter(x => {
							return acc.includes(String(x.purpose));
						});
						if (!isEmpty(jsonObj)) {
							resolve(jsonObj);
						}
					} else {
						resolve(jsonObj);
					}
				}).then(res => {
					index++;
					const spcMatch = spcInfoArr.findIndex(x => x.spc_id === item.spc_id);
					let perPage = 14;
					let tbodyStr = '';
					let transaction_spc_id = '';
					let transaction_req_id = '';
					let transaction_spc_name = ''
					transaction_spc_name = spcInfoArr[spcMatch].spc_name;
					// withdraw date
					let withdraw_day = item.withdraw_day.substring(0, 4) + '-' + item.withdraw_day.substring(4, 6) + '-' + item.withdraw_day.substring(6, 8);
					let withdraw_bank_name = '';
					let withdraw_acc_num = '';
					if (!isEmpty(item.withdraw_bank)) {
						withdraw_bank_name = item.withdraw_bank;
					} else {
						withdraw_bank_name = '-';
					}

					if (!isEmpty(item.withdraw_account_no)) {
						withdraw_acc_num = item.withdraw_account_no;
					} else {
						withdraw_acc_num = '-'
					}

					let transaction_type = '';
					res.length > 0 ? ( res.length ==1 ? ( transaction_type = '출금' ) : ( transaction_type = '출금 '+ (res.length) + '건' ) ): ( transaction_type = '-' );
					let amount = '';
					let updated_at = ''
					let requested_by = '';
					let approved_by = '';
					let status_changed_by = '';
					// status
					let status = '';
					let status_val = '';
					// delete icon
					let visibility = '';
					let edit_visibility = '';
					let link_attr = '';
					let purposeArr = [
						{ label: "출금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대수선비", "배당금 적립", "일반 지출", "DSRA 적립", "기타", "운영계좌", "공사비", "임대료", "대납금"]},
						{ label: "입금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
					];
					let account_type_list = [ "전력 판매대금", "REC 판매대금", "관리 운영비", "일반 렌탈", "전력중개 수수료", "전기 요금", "원리금" ];
					let purpose = '';

					const p = [];
					let size = '';

					for(let i=0, arrayLength = res.length; i < arrayLength; i++){
						p.push(res[i].purpose);
					}

					if(!isEmpty(item.opt)){
						let acc = [...item.opt[5].split(',')];
						res.filter(x => {
							return acc.includes(String(x.purpose));
						});
					}

					let uniqSet = new Set(p);
					if( uniqSet.size === 0 ) {
						purpose = '-'
					} else if( uniqSet.size == 1 ) {
						purpose = ( purposeArr[0].value[p[0]] )
					} else {
						purpose = ( purposeArr[0].value[p[0]] ) + ' 외 +' + ( uniqSet.size - 1 ) + '건';
					}
					transaction_spc_id = item.spc_id;
					transaction_req_id = item.request_id;

					if(item.status == 0) {
						status="반송"
						status_val = "0"
						visibility = "show";
						edit_visibility = "hidden";
						link_attr = "text-link";
					} else if(item.status == 1) {
						status="승인 대기"
						status_val = "1"
						visibility = "show";
						edit_visibility = "show";
						link_attr = "text-link";
					} else if (item.status == 2) {
						status="승인 중"
						status_val = "2"
						link_attr = "text-link";
						visibility = "hidden";
						edit_visibility = "hidden";
					} else if(item.status == 3) {
						status="승인 완료"
						status_val = "3"
						visibility = "hidden";
						edit_visibility = "hidden";
						link_attr = "text-blue";
					} else if(item.status == 4) {
						status="출금 가승인"
						status_val = "4"
						visibility = "hidden";
						edit_visibility = "hidden";
						link_attr = "text-link";
					} else if(item.status == 5) {
						status="출금 최종승인"
						status_val = "5"
						visibility = "hidden";
						edit_visibility = "hidden";
						link_attr = "text-blue";
					}

					item.total_amount ? ( amount = item.total_amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원' ) : amount = '-';

					( ( item.requested_by !== undefined ) && ( item.requested_by != "string" ) ) ? ( requested_by = item.requested_by ) : ( requested_by = '-' );

					item.status_changed_at ? ( updated_at = ( new Date(item.status_changed_at).toLocaleDateString("en-CA").replace(/\//g, '-') + '&emsp;&emsp;' + new Date(item.status_changed_at).toLocaleTimeString()) ) : ( updated_at = '-' );

					item.status_changed_by ? ( approved_by = item.status_changed_by ) : ( approved_by = '-' );

					// res.to_account_bank.locale
					tbodyStr = tbodyClone.replace(/\*index\*/g, (Number(page)-1)*perPage + Number(index) )
						.replace(/\*transactionSpcId\*/g, transaction_spc_id)
						.replace(/\*transactionSpcName\*/g, transaction_spc_name)
						.replace(/\*transactionReqId\*/g, transaction_req_id)
						.replace(/\*withdrawDay\*/g, withdraw_day)
						.replace(/\*withdrawBankName\*/g, withdraw_bank_name).replace(/\*withdrawAccountNum\*/g, withdraw_acc_num)
						.replace(/\*transactionType\*/g, transaction_type)
						.replace(/\*purpose\*/g, purpose)
						// .replace(/\*accountType\*/g, account_type_list[res.length])
						.replace(/\*amount\*/g, amount)
						.replace(/\*updatedAt\*/g, updated_at)
						.replace(/\*requestedBy\*/g, requested_by)
						.replace(/\*approvedBy\*/g, approved_by)
						.replace(/\*status\*/g, status)
						.replace(/\*statusVal\*/g, status_val)
						.replace(/\*linkAttr\*/g, link_attr).replace(/\*visibility\*/g, visibility).replace(/\*editVisibility\*/g, edit_visibility)
						.replace(/\*statusChangedBy\*/g, status_changed_by);
					tableBody.append($(tbodyStr));
				}).catch(error => {
					if(error){
						console.log("error", error);
						return false;
					}
				});
			})
			// let sum = totalAmount.toLocaleString('kr-KO');
			let str = totalAmount.toString();
			// str = sum.replace(/\d(?=(\d{3})+\.)/g, '$&,')
			let tfootStr = '';
			tfootStr = tfootClone.replace(/\*total\*/g, totalAmount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,'))
			tableFooter.append($(tfootStr));
		}

		function comparer(index) {
			return function(a, b) {
				var valA = getCellValue(a, index), valB = getCellValue(b, index)
				if (index == 5) {
					valA = valA.replace(/[^0-9]/g, ''), valB = valB.replace(/[^0-9]/g, '')
				}
				return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.toString().localeCompare(valB)
			}
		}

		function getCellValue(row, index){
			return $(row).children('td').eq(index).text()
		}

	});

	function deleteRow(selector) {
		let delPrompt = prompt('해당 요청서를 삭제하시겠습니까? \n삭제를 원하시면 아래 "삭제" 라고 입력하고 확인을 눌러 주세요.', '');
		if (delPrompt != '삭제') {
			return false;
		}
		let reqId = $(selector).prev().data("req-id");
		let option= {
			url: apiHost + '/spcs/transactions/' + reqId + '?oid=' + oid,
			type: 'DELETE',
			async: true
		}

		$.ajax(option).done(function (json, textStatus, jqXHR) {
			document.location.reload(true);
		}).fail(function (jqXHR, textStatus, errorThrown) {
			alert('처리 중 오류가 발생했습니다.');
			console.log("error===", jqXHR)
			return false;
		});
		// $(selector).parents().closest("tr").css("border", "none");
	}


	function goToEdit(self) {
		let spcId = self.parents().closest("td").data("id");
		let spcName = self.parents().closest("td").data("name");
		let reqId = self.data("req-id");
		let accInfo = self.data("id");

		let action = 'get';
		let syncOpt = true;
		let option = {
			url: apiHost + '/spcs/' + spcId + '?oid=' + oid + "&includeGens=true",
			type: action,
			async: syncOpt
		}

		$("#reqEditSpcId").val(spcId);
		$("#reqEditSpcName").val(spcName);
		$("#reqEditReqId").val(reqId);
		$("#reqEditForm").submit();

		// [사무수탁사]
		// "반송" : 0, "승인 중" : "2", "승인완료": "3"	 => /spc/withdrawReqStatusDetail.do
		// "승인 대기" : 1" 						  => /spc/withdrawReqEdit.do
	}


	function goToDetail(self) {
		let spcName = self.parents().closest("td").data("name");
		let reqId = self.data("req-id");
		let accInfo = self.data("name") + '  ' + self.data("value");
		let accNum = self.data("value");
		let status = self.text();
		let statusVal = self.parents().closest("td").data("value");
		let spcId = self.parents().closest("td").data("id");

		$("#reqDetailStatus").val(status);
		if(statusVal == 1 && task == 2) {
			status = "검토 중";
			statusVal = 2;
			$("#reqDetailStatus").val(status);
			$("#reqDetailStatusVal").val(statusVal);
			updateStatus(statusVal, reqId)
		} else {
			$("#reqDetailStatus").val(status);
			$("#reqDetailStatusVal").val(statusVal);
		}
		$("#reqDetailSpcId").val(spcId);
		$("#reqDetailSpcName").val(spcName);
		$("#reqDetailReqId").val(reqId);
		$("#reqDetailAccountInfo").val(accInfo);

		let action = 'get';
		let syncOpt = true;
		let option = {
			url: apiHost + '/spcs/' + spcId + '?oid=' + oid + "&includeGens=true",
			type: action,
			async: syncOpt
		}
		submit(option, accInfo, accNum, statusVal);
		// [사무수탁사]
		// "반송" : 0, "승인 중" : "2", "승인완료": "3"	 => /spc/withdrawReqStatusDetail.do
		// "승인 대기" : 1" 						  => /spc/withdrawReqEdit.do
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
			console.log("success---", json)
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.log("error==", jqXHR)
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
							let itemAcc = '';
							if (typeof item[1] === 'string') {
								itemAcc = item[1].replace(/[^0-9]/g, '');
							} else if (typeof item[1] === 'number') {
								itemAcc = item[1];
							}

							if(itemAcc == num.toString()){
								let txt = item[0];
								let newTxt = txt.replace(/계좌_번호/g, '');
								let name = accountInfo + '  (' + x[accHolder+newTxt] + ')';

								$("#reqDetailAccountInfo").val(name);
								setTimeout(function(){
									$("#reqDetailForm").submit();
								}, 300);
							}
						});
					});
				});
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			return false;
		});;
	}
</script>

<form id="reqEditForm" class="" action="/spc/withdrawReqEdit.do" method="post">
	<input type="hidden" id="reqEditSpcId" name="req_edit_spc_id" value=''/>
	<input type="hidden" id="reqEditSpcName" name="req_edit_spc_name" value=''/>
	<input type="hidden" id="reqEditReqId" name="req_edit_req_id" value=''/>
	<!-- <button type="submit" id="forwardDetailBtn" class="hidden"></button> -->
</form>

<form id="reqDetailForm" class="" action="/spc/withdrawReqStatusDetail.do" method="post">
	<input type="hidden" id="reqDetailSpcId" name="req_detail_spc_id" value=''/>
	<input type="hidden" id="reqDetailSpcName" name="req_detail_spc_name" value=''/>
	<input type="hidden" id="reqDetailReqId" name="req_detail_req_id" value=''/>
	<input type="hidden" id="reqDetailAccountInfo" name="req_detail_acc_info" value=''/>
	<input type="hidden" id="reqDetailStatus" name="req_detail_status" value=''/>
	<input type="hidden" id="reqDetailStatusVal" name="req_detail_status_val" value=''/>
	<!-- <button type="submit" id="forwardDetailBtn" class="hidden"></button> -->
</form>

<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content collect-modal-content">
			<div class="modal-header">
				<h4 lass="modal-title">조회된 데이터가 없습니다.</h4>
			</div>
			<div class="modal-footer">
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="submit" id="confirmBtn" class="btn-type">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class='row header-wrapper'>
	<div class='col-12'>
		<h1 class='page-header'>입출금 관리 내역</h1>
	</div>
</div>

<div class='row spc-search-bar header-wrapper'>
	<div class='col-11'><!--
	--><form id='transactionForm'><!--
		--><span class='tx-tit'>SPC 선택</span><!--
		--><div class='sa-select'>
				<div class='dropdown'>
					<button type='button' class='dropdown-toggle no-close' data-toggle='dropdown' data-name="선택" data-value="">전체<span class='caret'></span></button>
					<ul id='spcList' class='dropdown-menu chk-type' role='menu'>
						<li data-value="*spcId*"><!--
						--><a href="javascript:void(0);" tabindex="-1"><!--
							--><input type="checkbox" id="*spcName*" value="*spcId*" data-value="*spcId*" name="*uniqName*" checked><!--
							--><label for="*spcName*">*spcName*</label><!--
						--></a><!--
					--></li><!--
				--></ul>
					<small class="hidden warning">선택해 주세요.</small>
				</div>
			</div><!--
		--><div class='dropdown'>
				<button type='button' id='collapseBtn' class='dropdown-toggle clear-btn ml-24' data-toggle='collapse' data-target='#searchOption'>상세 조건<span class='caret'></span></button>
				<ul id='searchOption' class='collapse dropdown-menu unused'>
					<li class=""><!--
					--><h2 class='compare-title'>입출금 조회 기간</h2>
						<div class='row align-group3'>
							<div id="dateTerm" class='dropdown'>
								<button type='button' class='dropdown-toggle' data-toggle='dropdown' data-target="#dateTerm" data-name="선택" value="">선택<span class='caret'></span></button>
								<ul id="unitOpt" class='dropdown-menu dropdown-offset' role='menu'>
									<li data-value="yearly"><a href='javascript:void(0)' tabindex='-1'>년</a></li>
									<li data-value="monthly"><a href='javascript:void(0)' tabindex='-1'>월</a></li>
									<li data-value="daily"><a href='javascript:void(0)' tabindex='-1'>일</a></li>
								</ul>
							</div><!--
						--><div class='dropdown'>
								<input type='text' id='fromDate' name='fromDate' class='sel fromDate w-100' value='' autocomplete='off' placeholder='시작'>
								<small class="hidden warning">선택해 주세요.</small>
							</div><!--
						--><div class='dropdown'>
								<input type='text' id='toDate' name='toDate' class='sel toDate w-100' value='' autocomplete='off' placeholder='종료'>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
						</div><!--
				--></li><!--
				--><li class="">
						<div class='row align-group3'>
							<div class='box-align dropdown'>
								<h2 class='compare-title'>상태</h2>
								<button type='button' class='dropdown-toggle' data-toggle='dropdown' data-name="선택" value="">전체<span class='caret'></span></button>
								<ul id="spcStatus" class='dropdown-menu chk-type dropdown-offset' role='menu'>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='approved' value='' data-value='3' name='approvalStatus' checked>
											<label for='approved'>승인 완료</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='onHold' value='' data-value='1' name='approvalStatus' checked>
											<label for='onHold'>승인 대기</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='inProgress' value='' data-value='2' name='approvalStatus' checked>
											<label for='inProgress'>승인 중</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='approval' value='' data-value='4' name='approvalStatus' checked>
											<label for='approval'>출금 가승인</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='final' value='' data-value='5' name='approvalStatus' checked>
											<label for='final'>출금 최종승인</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='rejected' value='' data-value='0' name='approvalStatus' checked>
											<label for='rejected'>반송</label>
										</a>
									</li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
							<div class='box-align dropdown'>
								<h2 class='compare-title'>입출금 구분</h2>
								<button type='button' class='dropdown-toggle' data-toggle='dropdown' value="" data-value="all">전체<span class='caret'></span></button>
								<ul id="transactionType" class='dropdown-menu dropdown-offset' role='menu'>
									<li data-value='all'><a href='javascript:void(0)' tabindex='-1'>전체</a></li>
									<li data-value='deposit'><a href='javascript:void(0)' tabindex='-1'>입금</a></li>
									<li data-value='withdraw'><a href='javascript:void(0)' tabindex='-1'>출금</a></li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
							<div class='box-align'>
								<h2 class='compare-title'>용도 구분</h2>
								<div class='dropdown w-100'>
									<button type='button' class='dropdown-toggle' data-toggle='dropdown' data-name="선택">전체<span class='caret'></span></button>
									<ul id="spcPurposeList" class='dropdown-menu chk-type dropdown-offset' role='menu'>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='mngOper' data-value='0' data-name="관리운영비" name='spcPurpose' checked>
												<label for='mngOper'>관리운영비</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='officeFees' data-value='1' data-name="사무수탁비" name='spcPurpose' checked>
												<label for='officeFees'>사무수탁비</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='debtRepayment' data-value='2' data-name="부채상환" name='spcPurpose' checked>
												<label for='debtRepayment'>부채상환</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='constructionCost' data-value='9' data-name="공사비" name='spcPurpose' checked>
												<label for='constructionCost'>공사비</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='rent' data-value='10' data-name="임대료" name='spcPurpose' checked>
												<label for='rent'>임대료</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='payment' data-value='11' data-name="대납금" name='spcPurpose' checked>
												<label for='payment'>대납금</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='majorRepair' data-value='3' data-name="대수선비" name='spcPurpose' checked>
												<label for='majorRepair'>대수선비</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='dividendAccumulation' data-value='4' data-name="배당금 적립" name='spcPurpose' checked>
												<label for='dividendAccumulation'>배당금 적립</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='generalExpenditure' data-value='5' data-name="일반지출" name='spcPurpose' checked>
												<label for='generalExpenditure'>일반지출</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='dsraSaving' data-value='6' data-name="DSRA 적립" name='spcPurpose' checked>
												<label for='dsraSaving'>DSRA 적립</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='etc' data-value='7' data-name="기타" name='spcPurpose' checked>
												<label for='etc'>기타</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='activeAccount' data-value='8' data-name="운영 계좌" name='spcPurpose' checked>
												<label for='activeAccount'>운영 계좌</label>
											</a>
										</li>
									</ul>
									<small class="hidden warning">선택해 주세요.</small>
								</div>
							</div>
						</div>
					</li>
					<li class='btn-wrap-type03 btn-wrap-border'>
						<button type='button' data-toggle='collapse' data-target='#searchOption' class='btn-type03' id='closeDropdown'>취소</button>
						<button type='submit' class='btn-type ml-6'>검색</button>
					</li>
				</ul>
			</div>
		</form>
	</div>
	<div class="col-1">
		<div class='dropdown fr'><!--
		--><button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" value="" aria-expanded="true">건 별<span class="caret"></span></button><!-- 
		--><ul id='sumOptList' class='dropdown-menu' role='menu'><!--
			--><li data-value="noSum"><a href="javascript:void(0)" tabindex="-1">건 별</a></li><!--
			--><li data-value="monthSum"><a href="javascript:void(0)" tabindex="-1">월 별</a></li><!--
			--><li data-value="yearSum"><a href="javascript:void(0)" tabindex="-1">년 별</a></li><!--
		--></ul>
		</div>
	</div>
</div>


<div class='row spc-transaction'>
	<div class='col-12'>
		<div class='indiv'>
			<div class='spc-tbl'>
				<table class='sort-table table-footer transaction-table'>
					<colgroup>
						<col style='width:5%'>
						<col style='width:7%'>
						<col style='width:10%'>
						<col style='width:8%'>
						<col style='width:10%'>
						<!-- <col style='width:10%'> -->
						<col style='width:10%'>
						<col style='width:15%'>
						<col style='width:10%'>
						<col style='width:15%'>
						<col style='width:10%'>
						<col>
					</colgroup>
					<thead>
						<tr>
							<!-- <th><button type='button' class='btn-align down'>순번</button></th> -->
							<th>순번</th>
							<th><button type='button' class='btn-align down'>SPC명</button></th>
							<th><button type='button' class='btn-align down'>입출금 일자</button></th>
							<th><button type='button' class='btn-align down'>입출금 구분</button></th>
							<th><button type='button' class='btn-align down'>용도 구분</button></th>
							<!-- <th><button type='button' class='btn-align down'>계좌 구분</button></th> -->
							<th class="right pr-16"><button type='button' class='btn-align down'>금액</button></th>
							<th><button type='button' class='btn-align down'>최종 업데이트</button></th>
							<th>요청자</th>
							<th>승인자</th>
							<th class='left'><button type='button' class='btn-align down'>상태</button></th>
						</tr>
					</thead>
					<tbody id='tableBody'>
						<tr><td colspan='9' class='no-data center'>데이터가 없습니다.</td></tr></tr>
						<template class='table-body'>
							<tr>
								<td>*index*</td>
								<td>*transactionSpcName*</td>
								<td>*withdrawDay*</td>
								<td>*transactionType*</td>
								<td>*purpose*</td>
								<!-- <td>*accountType*</td> -->
								<td class="right">*amount*</td>
								<td>*updatedAt*</td>
								<td>*requestedBy*</td>
								<td>*approvedBy*</td>
								<td class='left' data-id="*transactionSpcId*" data-name="*transactionSpcName*" data-value="*statusVal*"><!--
								--><div class="flex-start"><!--
									--><button type="button" class="*linkAttr* clear-btn" data-name="*withdrawBankName*" data-value="*withdrawAccountNum*" data-req-id="*transactionReqId*" onclick="goToDetail($(this))">*status*</button><!--
									<c:if test="${userInfo.task ne 2}">
									--><a href="#" onclick="goToEdit($(this))" class='icon-edit *editVisibility*' data-req-id="*transactionReqId*"></a><!--
									--><a href="#" onclick="deleteRow(this)" class='icon-delete *visibility*'></a><!--
									</c:if>
								--></div>
								</td>
							</tr>
						</template>
					</tbody>
					<tfoot id="tableFooter">
						<template class='table-footer'>
							<tr>
								<td></td>
								<td>합계</td>
								<td colspan='3'></td>
								<td class="right">*total* 원</td>
								<td colspan='4'></td>
							</tr>
						</template>
					</tfoot>
				</table>
				<!-- <div class='pagination' id='pagination'></div> -->
			</div>
		</div>
	</div>
</div>