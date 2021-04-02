<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	// param: withdrawReqStatus.do
	const spcId = '${param.req_detail_spc_id}';
	const spcName = '${param.req_detail_spc_name}';
	const reqId = '${param.req_detail_req_id}';
	const accHolder = '${param.req_detail_acc_holder}';
	const accInfo = '${param.req_detail_acc_info}';
	const status = '${param.req_detail_status}';
	const statusVal = '${param.req_detail_status_val}';

	$(function() {
		const tableList = $('#tableBody');
		const tableCloned = tableList.find("template.table-body").clone().html();
		tableList.find("template").remove();
		const memoOpt = $("#memoOpt");
		const txtArea = $("textarea.textarea");
		const btnArea = $(".spc-detail .spc-btn-group");
		const btnPrint = $(".btn-print");
		const noHistory = "메모 히스토리가 없습니다.";

		if( isEmpty(spcName) || spcName == ("-")){
			$("#spcName").text("spc_no_name");
		}	else {
			$("#spcName").text(spcName);
		}

		// statusVal =>  "반송" : 0, "승인 대기" : 1", "승인 중" : "2", "승인완료": "3"


		// txtArea.eq(0).val();
		unCheckAll(memoOpt);
		getDataList();
		getAmount();

		// const setAttributes = function (attrs) {
		// 	for (var idx in attrs) {
		// 		if ((idx === 'styles' || idx === 'style') && typeof attrs[idx] === 'object') {
		// 			for (var prop in attrs[idx]){this.style[prop] = attrs[idx][prop];}
		// 		} else if (idx === 'html') {
		// 			this.innerHTML = attrs[idx];
		// 		} else {
		// 			this.setAttribute(idx, attrs[idx]);
		// 		}
		// 	}
		// };

		function getDataList(page) {
			page == undefined ? page = 1 : page = page;
			var sortList = [];
			// var totalPage = 0;
			let action = 'get';
			let syncOpt = true;
			let option= {
				url: apiHost + '/spcs/transactions',
				type: action,
				data: {
					'oid' : oid,
					'spcIds': spcId,
					'request_id': reqId
				},
				async: syncOpt
			}
			// console.log("spc===", spcId)
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				tableList.empty();
				if (json.data.length > 0) {
					json.data.map(item => {
						let data = json.data;
						let sum = 0;
						// console.log("item.attachement_info===", item.attachement_info)
						$("#total").text(item.total_amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원');

						if (role == 2) {
							if (item.status == 0) {
								$('#rejectBtn').parent().addClass('hidden');
							} else if(item.status == 3) {
								$('#rejectBtn').parent().find('button').addClass('hidden');
								$('#reviewBtn').removeClass('hidden');
							}
						}

						const attachmentInfo = Promise.resolve(JSON.parse(item.attachement_info));
						attachmentInfo.then((attachList) => {
							$("#proofFile").prev().text("증빙서류");
							attachList.forEach(attach => {
								let downUrl = apiHost + '/files/download/' + attach.filedName + '?oid=' + oid + '&orgFilename=' + attach.originalName.trim();
								let templateAttach = `
												<div class="flex-wrapper border">
													<a href="#" class="btn-type02">${'${attach.originalName.trim()}'}</a>
													<a href="${'${downUrl}'}" class="btn-save"></a>
												</div>`;

								$('#attachementList').append(templateAttach);
							});
						}).catch(error => {
							console.log("res=== attach", $("#proofFile").prev());
							$("#proofFile").parents().find(".file-wrapper").empty();
						})

						if(typeof item.memo == "string"){
							let showMemo = "";
							if (task == 1) {
								showMemo = item.memo_common;
							} else {
								showMemo = item.memo;
							}

							$("#txt1").val(showMemo).data('memo', item.memo).data('commonMemo', item.memo_common);
							$("#txt2").val("");
							return new Promise((resolve, reject) => {
									// typeof v.to_account !== "string" ? JSON.parse(v.to_account) : v.to_account = v.to_account	
										resolve(JSON.parse(item.to_account))
									}).then(res => {
										res.map(x => {
											// console.log("x===", x)
											let popObj = Object.assign({}, item);
											delete(popObj.to_account);
											let purposeArr = [
												{ label: "출금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대수선비", "배당금 적립", "일반 지출", "DSRA 적립", "기타", "운영계좌", "공사비", "임대료", "대납금" ]},
												{ label: "입금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
											];
											let purpose = '';
											let withdraw_day = '';
											let accNum = '';
											let bankName = '';
											let accOwner = '';
											let amount = '';
											let desc = '';
											if(!isEmpty(purposeArr[0].value[x.purpose])){
												purpose = purposeArr[0].value[x.purpose];
											} else {
												purpose = '-'
											}
											if(!isEmpty(popObj.withdraw_day)){
												withdraw_day = popObj.withdraw_day.substring(0, 4) + '-' + popObj.withdraw_day.substring(4, 6) + '-' + popObj.withdraw_day.substring(6, 8);
											} else {
												withdraw_day = '-'
											}
											if(!isEmpty(x.to_account_bank)){
												bankName = x.to_account_bank;
											} else {
												bankName = ''
											}
											if(!isEmpty(x.to_account_no)){
												accNum = x.to_account_no;
											} else {
												accNum = '-'
											}
											if(!isEmpty(x.to_account_owner)){
												accOwner = x.to_account_owner;
											} else {
												accOwner = ''
											}
											if(!isEmpty(x.amount)){
												amount = x.amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원';
											} else {
												amount = '-'
											}
											if(!isEmpty(x.desc)){
												desc = x.desc;
											} else {
												desc = '-'
											}
											// let account_type_list = [  "전력 판매대금", "REC 판매대금", "관리 운영비", "일반 렌탈", "전력중개 수수료", "전기 요금", "원리금" ];
											let str = '';
											str = tableCloned.replace(/\*withdrawDay\*/g, withdraw_day)
												.replace(/\*purpose\*/g, purpose)
												.replace(/\*amount\*/g, amount)
												.replace(/\*toAccBankName\*/g, bankName).replace(/\*toAccountNum\*/g, accNum).replace(/\*to_account_owner\*/g, accOwner)
												.replace(/\*description\*/g, desc)
											tableList.append($(str));
										});
							}, function(error) {
								if (error) {
									reject(new Error('Fail!'))
									console.log(error);
								}
							});
						} else {
							const promiseMemo = Promise.resolve(JSON.parse(item.memo));
							const promiseAccount = Promise.resolve(JSON.parse(item.to_account));

							return Promise.all([promiseAccount, promiseMemo]).then(res => {
								if(res[1]){
									$("#txt1").val(res[1].desc);
									$("#txt2").val("");
								} else {
									console.log("no memo===");
									$("#txt1").val(noHistory);
								}

								res[0].map(x => {
									let popObj = Object.assign({}, item);
									delete(popObj.to_account);
									// console.log("x===", x)
									let purposeArr = [
										{ label: "출금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대수선비", "배당금 적립", "일반 지출", "DSRA 적립", "기타", "운영계좌", "공사비", "임대료", "대납금" ]},
										{ label: "입금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
									];
									let purpose = '';
									let withdraw_day = '';
									let bankName = '';
									let accNum = '';
									let accOwner = '';
									let amount = '';
									let desc = '';
									if(!isEmpty(purposeArr[0].value[x.purpose])){
										purpose = purposeArr[0].value[x.purpose];
									} else {
										purpose = '-'
									}
									if(!isEmpty(popObj.withdraw_day)){
										withdraw_day = popObj.withdraw_day.substring(0, 4) + '-' + popObj.withdraw_day.substring(4, 6) + '-' + popObj.withdraw_day.substring(6, 8);
									} else {
										withdraw_day = '-'
									}
									if(!isEmpty(x.to_account_bank)){
										bankName = x.to_account_bank;
									} else {
										bankName = ''
									}
									if(!isEmpty(x.to_account_no)){
										accNum = x.to_account_no;
									} else {
										accNum = '-'
									}
									if(!isEmpty(x.to_account_owner)){
										accOwner = x.to_account_owner;
									} else {
										accOwner = ''
									}
									if(!isEmpty(x.amount)){
										amount = x.amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원';
									} else {
										amount = '-'
									}
									if(!isEmpty(x.desc)){
										desc = x.desc;
									} else {
										desc = '-'
									}
									// let account_type_list = [  "전력 판매대금", "REC 판매대금", "관리 운영비", "일반 렌탈", "전력중개 수수료", "전기 요금", "원리금" ];
									let str = '';
									str = tableCloned.replace(/\*withdrawDay\*/g, withdraw_day)
										.replace(/\*purpose\*/g, purpose)
										.replace(/\*amount\*/g, amount)
										.replace(/\*toAccBankName\*/g, bankName).replace(/\*toAccountNum\*/g, accNum).replace(/\*to_account_owner\*/g, accOwner)
										.replace(/\*description\*/g, desc)
									tableList.append($(str));
								});
							}).catch(error => {
								console.log(error);
							});
						}
					});
				} else {
					return false;
				}
				// totalPage = Math.ceil(sortList.length/pagePerData);
				
			}).fail(function (jqXHR, textStatus, errorThrown) {
				// console.log("error===", jqXHR, "text000", textStatus )
				// $("#warningModal .modal-title").text('처리 중 오류가 발생했습니다.');
				// $("#warningModal").modal("show");
				return false;
			});
		}

		// approval => status: 3
		$("#attachedFileForm").on("submit", function(e){
			e.preventDefault();
			const newStatus = 3;
			handleReq(newStatus, updateReq);
		});

		// saving only => status: null
		$("#saveBtn").on("click", function(){
			const newStatus = null;
			let input = $("#txt2").val();
			let d = new Date();
			let prefix = d.toISOString().substring(0, 10) + ' '
				+  d.toLocaleTimeString().substr(0, d.toLocaleTimeString().length-2)
				+ '/ '
				+ loginName
				+ '\n';

				console.log("prefix---", prefix)
			if(isEmpty(input)){
				$("#warningModal").modal("show");
			} else {
				let val = '';
				if($("#txt1").val() == noHistory){
					$("#txt1").val("");
					val = prefix + input;
				} else {
					val = '\n' + prefix + input;
				}
			
				let preserved = (isEmpty($("#txt1").data('memo')) ? '' : $("#txt1").data('memo')) ;
				let preserved2 = isEmpty($("#txt1").data('commonMemo')) ? '' : $("#txt1").data('commonMemo');
				$("#txt1").val(preserved += val).data('memo', preserved);
				if ($("#memoOpt").is(":checked")) {
					$("#txt1").data('commonMemo', preserved2 += val);
				}
				// console.log("val==", preserved)
				updateReq(undefined, preserved, preserved2);
				// handleReq(newStatus, updateReq);
			}
		});

		$("#rejectBtn").on("click", function() {
			updateReq(0);
		});

		$("#reviewBtn").on("click", function() {
			updateReq(1);
		});

		$("#provisionalBtn").on("click", function() {
			updateReq(4);
		});

		$("#finalApprovalBtn").on("click", function() {
			updateReq(3);
		});

		$("#backList").on("click", function() {
			if (document.referrer) {
				if (document.referrer.match("/spc/withdrawReqStatus.do")) {
					location.href = "/spc/withdrawReqStatus.do";
				} else if (document.referrer.match("/spc/transactionHistory.do")) {
					location.href = "/spc/transactionHistory.do";
				}
			}
		});

		function handleReq(newStatus, callback){
			callback(newStatus);
		}

		function updateReq(newStatus, memoStr, commmonMemo){
			let newData = {}
			newStatus || newStatus == 0 || newStatus == 1 ? ( newData.status = newStatus ) : null;

			if(newStatus != undefined) {
				newData.status_changed_by = loginName;
				newData.status_changed_at = new Date().toISOString();
			}

			if (memoStr != undefined) {
				newData.memo = memoStr;
			}

			if (commmonMemo != undefined) {
				newData.memo_common = commmonMemo;
			}

			let opt = {
				url: apiHost + '/spcs/transactions/' + reqId + '?oid=' + oid,
				type: "patch",
				async: true,
				dataType: 'json',
				contentType: "application/json",
				data: JSON.stringify(newData)
			};
			var reload = newStatus;
			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				if(isEmpty(reload)){
					$('#memoOpt').prop('checked', false);
					$('#txt2').val('');
					return false;
				} else {
					window.location.href = window.location.origin + '/spc/withdrawReqStatus.do' ;
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				$("#warningModal .modal-title").text('처리 중 오류가 발생했습니다.');
				$("#warningModal").modal("show");
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});
		}

		/**
		 * 입출금 내역 갱신
		 */
		$('#refresh').on('click', function () {
			$.ajax({
				url: apiHost + '/spcs/transactions/real/refresh',
				type: 'GET',
				data: {
					oid: oid,
					spc_ids: spcId
				},
				timeout: 300000
			}).done(function(data, textStatus, jqXHR) {
				getAmount();
			}).fail(function(jqXHR, textStatus, errorThrown) {
				console.error(textStatus);
				alert('입출금 내역 갱신에 실패했습니다.');
				return false;
			})
		});
	});

	function getAmount() {
		$.ajax({
			url: apiHost + '/spcs/transactions/real/balance',
			type: 'GET',
			data: {
				oid: oid,
				spcIds: Number(spcId)
			}
		}).done(function (json, textStatus, jqXHR) {
			if (!isEmpty(json) && !isEmpty(json.data) && !isEmpty(json.data.items)) {
				const targetAccount = json.data.items.find(e => e.account_no === accInfo.replace(/[^0-9]/g, ''));

				if (isEmpty(targetAccount)) {
					$('#availableAmount').html('-');
				} else {
					$('#availableAmount').html(numberComma(targetAccount.account_balance) + ' 원');
				}
			} else {
				$('#availableAmount').html('-');
			}

			if (json.refreshed_at != null) {
				$('#refresh_date').text(new Date(json.refreshed_at).format('yyyy-MM-dd HH:mm:ss'));
			} else {
				$('#refresh_date').text('');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			$('#availableAmount').html('');
			$('#refresh_date').text('');
			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	// onclick="location.href=apiHost + '/files/download/5c71e049-f73c-2bf9-a9a0-2f91d067ef11?oid=spower&orgFilename=수익보고서_20200526100755.pdf'"

	function previewPdf(self){
		let token = '${sessionScope.userInfo.token}'
		let url = '';
		let account = $("#tableBody").find("tr:first-child td:nth-child(2)").text().replace(/^\s+|\s+$|\s+(?=\s)/g, "");
		let d = new Date().toLocaleDateString("en-CA")  ;
		let name = d + '_' + spcName + '_' + account + '.pdf';

		if($(self).data("name") == "previewMergeDocs") {
			url = apiHost + '/spcs/transactions/download/request?oid='+oid + '&spc_id=' + spcId + '&request_id=' + reqId + '&evidence=true' + '&output_file_name=' + name;
		} else if($(self).data("name") == "previewReqDoc"){
			url = apiHost + '/spcs/transactions/download/request?oid='+oid + '&spc_id=' + spcId + '&request_id=' + reqId + '&output_file_name=' + name;;
		} else if($(self).data("name") == "previewProof"){
			url = apiHost + '/spcs/transactions/download/evidence?oid='+oid + '&spc_id=' + spcId + '&request_id=' + reqId + '&output_file_name=' + name;;
		};

			console.log("url=-===", url)
			
		$.ajax({
			url: url,
			method: 'GET',
			beforeSend: function (jqXHR, settings) {
				$("#loadingCircle").show();
			},
			xhrFields: {
				responseType: 'blob'
			},
			success: function(data) {
				// var blob = new Blob([data]);
				// var fileName = request.getResponseHeader('fileName');

				// console.log("data===", data);

				let src = window.URL.createObjectURL(data);
				let btn = document.createElement('div');
				let preview = document.createElement('iframe');
				let el = document.getElementById("outerWrapper");

				setAttributes(preview, {
					type: "application/pdf",
					id: "previewFrame",
					class: "iframe-fixed",
					embedded: true,

				});

				preview.src = src;

				btn.setAttribute("id", "iframeBtn");

				document.body.insertBefore(preview, el);
				document.body.insertBefore(btn, preview);

				el.setAttribute("class", "blur");

				document.getElementById("previewFrame").addEventListener("click", function(){
					this.remove();
					document.getElementById("outerWrapper").classList.remove("blur");
					document.getElementById("iframeBtn").remove();
				});

				document.getElementById("iframeBtn").addEventListener("click", function(){
					document.getElementById("previewFrame").remove();
					document.getElementById("outerWrapper").classList.remove("blur");
					this.remove();
				});
			}
		});
	}
	
	function downloadFile(self){
		let token = '${sessionScope.userInfo.token}'
		let url = '';
		let typeName = '';
		if($(self).data("name") == "downloadMergeDocs") {
			url = apiHost + '/spcs/transactions/download/request?oid='+oid + '&spc_id=' + spcId + '&request_id=' + reqId + '&evidence=true';
			typeName = '출금요청서';
		} else if($(self).data("name") == "downloadReqDoc"){
			url = apiHost + '/spcs/transactions/download/request?oid='+oid + '&spc_id=' + spcId + '&request_id=' + reqId;
			typeName = '증빙서류';
		} else if($(self).data("name") == "downloadProof"){
			url = apiHost + '/spcs/transactions/download/evidence?oid='+oid + '&spc_id=' + spcId + '&request_id=' + reqId;
			typeName = '출금요청서및증빙';
		};

		$.ajax({
			url: url,
			method: 'GET',
			xhrFields: {
				responseType: 'blob'
			},
			success: function(data) {
				let account = $("#tableBody").find("tr:first-child td:nth-child(4)").text().replace(/^\s+|\s+$|\s+(?=\s)/g, "");

				let d = $("#tableBody").find("tr:first-child td:nth-child(1)").text().replace(/[^0-9]/g, "");
				// let d = new Date();
				// d = d.toISOString().substring(0, 10).replace(/-/g, "");
				let name = d + '_' + spcName + '_' + account + '_' + typeName + '.pdf';

				var a = document.createElement('a');
				var url = window.URL.createObjectURL(data);
				a.href = url;
				a.download = name;
				document.body.append(a);
				a.click();
				setTimeout(function(){
					a.remove();
					window.URL.revokeObjectURL(url);
				}, 200);
			},
			fail: function(){
			}
		});
	}

	function setAttributes(el, attrs) {
		Object.keys(attrs).forEach(key => el.setAttribute(key, attrs[key]));
	}

	// function downloadFile(action, originalName, fakeName){
	// 		console.log("downloadFile--", action)
	// 		console.log("fakeName==", fakeName, "originalName===", originalName);


	// 		var element = document.createElement('a');
	// 		element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(originalName));
	// 		element.setAttribute('download', originalName);

	// 		element.style.display = 'none';
	// 		document.body.appendChild(element);

	// 		element.click();

	// 		document.body.removeChild(element);
			
	// 		// let option= {
	// 		// 	type: action,
	// 		// 	url: apiHost + '/files/download?oid=' + oid,
	// 		// 	data: {
	// 		// 		fileKey: fakeName,
	// 		// 		orgFilename: originalName
	// 		// 	},
	// 		// }
	// 		// $.ajax(option).done(function (json, textStatus, jqXHR) {
	// 		// 	console.log("success===", json)
	// 		// }).fail(function (jqXHR, textStatus, errorThrown) {
	// 		// 	alert('처리 중 오류가 발생했습니다.');
	// 		// 	return false;
	// 		// });
	// 	}

</script>


<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content collect-modal-content">
			<div class="modal-header">
				<h4 lass="modal-title">저장 하실 내용을 입력해 주세요.</h4>
			</div>
			<div class="modal-footer">
				<div class="btn-wrap-type02">
					<button type="button" data-dismiss="modal" class="btn-type" aria-label="Close">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 검토</h1>
	</div>
</div>
<div class="row">
	<div class="col-xl-8 col-lg-7 col-md-6 col-sm-12">
		<div class="indiv spc-detail">
			<div class="flex-wrapper mb-20">
				<h2 class="ntit">출금 요청서</h2>
				<span id="statusName" class="tx-tit blue_text">상태: ${param.req_detail_status}</span>
			</div>
			<div class="flex-start">
				<h2 class="tx-tit">SPC 명</h2>
				<span id="spcName" class="tx-tit">${param.req_detail_spc_id}</span>
			</div>
			<div class="flex-start">
				<h2 class="tx-tit">출금 계좌 번호</h2>
				<span class="tx-tit">${param.req_detail_acc_info} ${param.req_detail_acc_holder}</span>
			</div>
			<div class="flex-start">
				<h2 class="tx-tit">계좌 잔액: </h2>
				<span class="tx-tit" id="availableAmount"></span>
			</div>
			<div class="flex-start">
				<div style="flex-grow: 1">
					<h2 class="tx-tit">마지막 업데이트: </h2>
					<span class="tx-tit ml-20" id="refresh_date"></span>
				</div>
				<button type="button" id="refresh" class="btn-type03">입출금 내역 갱신</button>
			</div>

			<div class="table-wrap-type collect-wrap mt-30">
				<table class="history-table table-footer">
					<thead>
						<tr>
							<th>출금일자</th>
							<th>구분</th>
							<th class="right">요청 금액</th>
							<th>계좌번호</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody id="tableBody">
						<tr><td colspan='10' class='no-data center'>데이터가 없습니다.</td></tr></tr>
						<template class="table-body">
							<tr>
								<td>*withdrawDay*</td>
								<td>*purpose*</td>
								<td class="right">*amount*</td>
								<td>*toAccBankName*  *toAccountNum* (*to_account_owner*)</td>
								<td>*description*</td>
							</tr>
						</template>
					</tbody>
					<tfoot>
						<tr>
							<td>합계</td>
							<td></td>
							<td id="total" class="right"></td>
							<td colspan="2"></td>
						</tr>
					</tfoot>
				</table>
			</div>

		</div>
	</div>
	<div class="col-xl-4 col-lg-5 col-md-6 col-sm-12">
		<form id="attachedFileForm" name="attached_file_form" action="#" method="post">
			<div class="indiv spc-detail spc-req-status">
				<div class="flex-wrapper"><h2 class="ntit">증빙 서류</h2></div>
				<div id="attachementList" class="attachment-list"></div>

				<div class="flex-wrapper">
					<h2 class="heading">출금 요청서</h2>
					<div class="fr"><!--
					--><button type="button" class="btn-type03" onclick="previewPdf(this)" data-name="previewReqDoc">미리 보기</button><!--
					--><button type="button" class="btn-type ml-12" onclick="downloadFile(this)" data-name="downloadReqDoc">다운로드</button><!--
				--></div>
				</div>
				<div class="flex-wrapper file-wrapper">
					<h2 class="heading">증빙 서류</h2><input type="hidden" name="proof_file" id="proofFile" class="sr-only"/>
					<div class="fr"><!--
					--><button type="button" class="btn-type03" onclick="previewPdf(this)" data-name="previewProof">미리 보기</button><!--
					--><button type="button" class="btn-type ml-12" onclick="downloadFile(this)" data-name="downloadProof" >다운로드</button><!--
				--></div>
				</div>
				<div class="flex-wrapper border file-wrapper">
					<h2 class="heading">출금 요청서 + 증빙 서류</h2><input type="hidden" name="proof_file" id="proofFile" class="sr-only"/>
					<div class="fr"><!--
					--><button type="button" class="btn-type03" onclick="previewPdf(this)" data-name="previewMergeDocs">미리 보기</button><!--
					--><button type="button" class="btn-type ml-12" onclick="downloadFile(this)" data-name="downloadMergeDocs" >다운로드</button><!--
				--></div>
				</div>
				<div class="flex-wrapper mt-20">
					<h2 class="heading">메모 히스토리</h2>
				</div>
				<div class="flex-wrapper border mt-12">
					<textarea id="txt1" class="textarea w-100" readonly></textarea>
				</div>
				<!-- 사무수탁 && 출금관리 -->
				<c:choose>
					<c:when test="${userInfo.role eq 1}">
						<div class="flex-wrapper mt-20">
							<h2 class="heading">메모</h2><!--
						--><a class="chk-type" href="javascript:void(0);"><input type="checkbox" id="memoOpt" name="memo_opt"><label for="memoOpt">사무수탁사 함께 보기</label></a><!--
					--></div>
						<div class="textarea-container mt-12">
							<button type="button" id="saveBtn" class="btn-type03 btn-fixed">저장</button>
							<textarea placeholder="직접입력" id="txt2" class="textarea w-100"></textarea>
						</div>
						<c:choose>
							<c:when test="${param.req_detail_status_val eq 3}">
								<div class="spc-btn-group my-20"><!--
									--><button type="button" id="reviewBtn" class="btn-type mr-16">검토대기로 변경</button><!--
									--><button type="button" id="provisionalBtn" class="btn-type">출금 가승인</button><!--
								--></div>
							</c:when>
							<c:when test="${param.req_detail_status_val eq 4}">
								<div class="spc-btn-group my-20"><!--
									--><button type="button" id="finalApprovalBtn" class="btn-type">승인완료로 변경</button><!--
								--></div>
							</c:when>
							<c:otherwise>
								<c:if test="${(param.req_detail_status_val ne 4 and param.req_detail_status_val ne 5 and param.req_detail_status_val ne 9)}">
									<div class="spc-btn-group my-20"><!--
									--><button type="button" id="reviewBtn" class="btn-type mr-16">검토대기로 변경</button><!--
									--><button type="button" id="rejectBtn" class="btn-type03 w-80px">반송</button><!--
									--><button type="submit" class="btn-type ml-12">승인</button><!--
								--></div>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<c:if test="${userInfo.task ne 1}">
							<div class="flex-wrapper mt-20">
								<h2 class="heading">메모</h2><!--
							--><a class="chk-type" href="javascript:void(0);"><input type="checkbox" id="memoOpt" name="memo_opt"><label for="memoOpt">사무수탁사 함께 보기</label></a><!--
						--></div>
							<div class="textarea-container mt-12">
								<button type="button" id="saveBtn" class="btn-type03 btn-fixed">저장</button>
								<textarea placeholder="직접입력" id="txt2" class="textarea w-100"></textarea>
							</div>
							<c:choose>
								<c:when test="${userInfo.task eq 3 and param.req_detail_status_val eq 3}">
									<div class="spc-btn-group my-20"><!--
									--><button type="button" id="provisionalBtn" class="btn-type">출금 가승인</button><!--
								--></div>
								</c:when>
								<c:when test="${userInfo.task eq 3 and (param.req_detail_status_val eq 4 or param.req_detail_status_val eq 5)}">
									<div class="spc-btn-group my-20"><!--
									--><button type="button" id="finalApprovalBtn" class="btn-type">승인완료로 변경</button><!--
								--></div>
								</c:when>
								<c:otherwise>
									<c:if test="${userInfo.task eq 2 and (param.req_detail_status_val ne 4 and param.req_detail_status_val ne 5 and param.req_detail_status_val ne 9)}">
										<div class="spc-btn-group my-20"><!--
										--><button type="button" id="reviewBtn" class="btn-type mr-16">검토대기로 변경</button><!--
										--><button type="button" id="rejectBtn" class="btn-type03 w-80px">반송</button><!--
										--><button type="submit" class="btn-type ml-12">승인</button><!--
									--></div>
									</c:if>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:otherwise>
				</c:choose>
			</div>
		</form>
		<div class="btn-wrap-type05 my-20"><!--
		--><button type="button" id="backList" class="btn-type03 w-80px">목록</button><!--
	--></div>
	</div>
</div>
