<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';
	const userTask = '<c:out value="${sessionScope.userInfo.task}" escapeXml="false" />';

	// param: withdrawReqStatus.do
	const spcId = '${param.req_detail_spc_id}';
	const spcName = '${param.req_detail_spc_name}';
	const reqId = '${param.req_detail_req_id}'; 
	const accNum = '${param.req_detail_acc_info}';
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
		const noHistory = "메모 히스토리가 없습니다."

		if( isEmpty(spcName) || spcName == ("-")){
			$("#spcName").text("spc_no_name");
		}	else {
			$("#spcName").text(spcName);
		}

		// statusVal =>  "반송" : 0, "승인 대기" : 1", "승인 중" : "2", "승인완료": "3"


		// txtArea.eq(0).val();
		unCheckAll(memoOpt);
		getDataList();

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

						if (item.status == 3 || item.status == 0) {
							$('#rejectBtn').parent().addClass('hidden');
						}

						const attachmentInfo = Promise.resolve(JSON.parse(item.attachement_info));
						attachmentInfo.then((attachList) => {
							$("#proofFile").prev().text("증빙서류");
							attachList.forEach(attach => {
								let downUrl = apiHost + '/files/download/' + attach.filedName + '?oid=' + oid + '&orgFilename=' + attach.originalName.trim();
								let templateAttach = `
												<div class="flex_wrapper border">
													<a href="#" class="btn_type02">${'${attach.originalName.trim()}'}</a>
													<a href="${'${downUrl}'}" class="save_btn"></a>
												</div>`;

								$('#attachementList').append(templateAttach);
							});
						}).catch(error => {
							console.log("res=== attach", $("#proofFile").prev());
							$("#proofFile").parents().find(".file-wrapper").empty();
						})

						if(typeof item.memo == "string"){
							let showMemo = "";
							if (userTask == 1) {
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
											console.log("x===", x)
											let popObj = Object.assign({}, item);
											delete(popObj.to_account);
											let purposeList = [
												{ label: "출금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대수선비", "배당금 적림", "일반 지출", "DSRA 적립", "기타", "운영계좌" ]},
												{ label: "입금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
											];
											let purpose = '';
											let withdraw_day = '';
											let accNum = '';
											let bankName = '';
											let amount = '';
											let desc = '';
											if(!isEmpty(purposeList[0].value[x.purpose])){
												purpose = purposeList[0].value[x.purpose];
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
												.replace(/\*toAccBankName\*/g, bankName).replace(/\*toAccountNum\*/g, accNum)
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
									console.log("x===", x)
									let purposeList = [
										{ label: "출금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대수선비", "배당금 적림", "일반 지출", "DSRA 적립", "기타", "운영계좌" ]},
										{ label: "입금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
									];
									let purpose = '';
									let withdraw_day = '';
									let bankName = '';
									let accNum = '';
									let amount = '';
									let desc = '';
									if(!isEmpty(purposeList[0].value[x.purpose])){
										purpose = purposeList[0].value[x.purpose];
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
										.replace(/\*toAccBankName\*/g, bankName).replace(/\*toAccountNum\*/g, accNum)
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
				console.log("error===", jqXHR, "text000", textStatus )
				$("#warningModal .modal-title").text('처리 중 오류가 발생했습니다.');
				$("#warningModal").modal("show");
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

		function handleReq(newStatus, callback){
			callback(newStatus);
		}

		function updateReq(newStatus, memoStr, commmonMemo){
			let newData = {}
			newStatus || newStatus == 0 ? ( newData.status = newStatus ) : null;

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
	
	});


	// onclick="location.href=apiHost + '/files/download/5c71e049-f73c-2bf9-a9a0-2f91d067ef11?oid=spower&orgFilename=수익보고서_20200526100755.pdf'"

	function downloadFile(self){
		let apiUrl = '';
		if($(self).data("name") == "receipt") {

		} else if($(self).data("name") == "reqDoc"){
			apiUrl = 'request';
		} else if($(self).data("name") == "proof"){
			apiUrl = 'evidence';
		};
		// var a = document.createElement('a');
		// const url = apiHost + '/spcs/transactions/download/request?oid='+ oid + '&spc_id=' + spcId + '&request_id=' + reqId;
	
		// let account = $("#tableBody").find("tr:first-child td:nth-child(2)").text().replace(/^\s+|\s+$|\s+(?=\s)/g, "");
		// let d = new Date();
		// d = d.toISOString().substring(0, 10).replace(/-/g, "");
		// let name = d + '_' + spcName + '_' + account + '.pdf';
		// var link = window.URL.createObjectURL(url);
		// a.href = link;
		// a.download = name;
		// document.body.append(a);
		// a.click();
		// a.remove();
		// var link = window.URL.createObjectURL(data);
		// console.log("acc---", account)
		// window.URL.revokeObjectURL(link);

		// window.location= url;
		// document.location.assign(a.href);

			$.ajax({
				url: apiHost + '/spcs/transactions/download/' + apiUrl + '?oid='+oid + '&spc_id=' + spcId + '&request_id=' + reqId,
				method: 'GET',
				xhrFields: {
					responseType: 'blob'
				},
				// dataType: 'binary',
				success: function(data) {
					console.log("data---", data)
					let account = $("#tableBody").find("tr:first-child td:nth-child(2)").text().replace(/^\s+|\s+$|\s+(?=\s)/g, "");
					let d = new Date();
					d = d.toISOString().substring(0, 10).replace(/-/g, "");
					let name = d + '_' + spcName + '_' + account + '.pdf';
					var a = document.createElement('a');
					var url = window.URL.createObjectURL(data);
					a.href = url;
					a.download = name;
					document.body.append(a);
					a.click();
					a.remove();
					window.URL.revokeObjectURL(url);
				}
			});
				
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

<div class="modal fade" id="warningModal" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content collection_modal_content">
			<div class="modal-header">
				<h4 lass="modal-title">저장 하실 내용을 입력해 주세요.</h4>
			</div>
			<div class="modal-footer">
				<div class="btn_wrap_type02">
					<button type="button" data-dismiss="modal" class="btn_type" aria-label="Close">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 검토</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-xl-8 col-lg-7 col-md-6 col-sm-12">
		<div class="indiv spc-detail">
			<div class="flex_wrapper mb-20">
				<h2 class="ntit">출금 요청서</h2>
				<span id="statusName" class="tx_tit blue_text">상태: ${param.review_status}</span>
			</div>
			<div class="flex_start">
				<h2 class="tx_tit">SPC 명</h2>
				<span id="spcName" class="tx_tit"></span>
			</div>
			<div class="flex_start">
				<h2 class="tx_tit">출금 계좌 번호</h2>
				<span class="tx_tit">${param.review_acc_info}</span>
			</div>

			<div class="tbl_wrap_type collect_wrap mt30">
				<table class="his_tbl table-footer">
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
								<td>*toAccBankName*  *toAccountNum*</td>
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
			<div class="indiv spc-detail">
				<div class="flex_wrapper"><h2 class="ntit">증빙 서류</h2></div>
				<div id="attachementList" class="attachment-list"></div>

				<div class="flex_wrapper">
					<h2 class="heading">출금 요청서</h2>
					<div class="fr"><button type="button" class="btn_type ml-12" onclick="downloadFile(this)" data-name="reqDoc">다운로드</button></div>
				</div>
				<div class="flex_wrapper border file-wrapper">
					<h2 class="heading">증빙 서류</h2><input type="hidden" name="proof_file" id="proofFile" class="sr-only"/>
					<div class="fr"><button type="button" class="btn_type ml-12" onclick="downloadFile(this)" data-name="proof" >다운로드</button></div>
				</div>
				<div class="flex_wrapper mt20">
					<h2 class="heading">메모 히스토리</h2>
				</div>
				<div class="flex_wrapper border mt12">
					<textarea id="txt1" class="textarea w-100" readonly></textarea>
				</div>
				<c:if test="${userInfo.task ne 1}">
					<div class="flex_wrapper mt20">
						<h2 class="heading">메모</h2><!--
						--><a class="chk_type" href="javascript:void(0);"><input type="checkbox" id="memoOpt" name="memo_opt"><label for="memoOpt">사무수탁사 함께 보기</label></a><!--
				--></div>
					<div class="textarea-container mt12">
						<button type="button" id="saveBtn" class="btn_type03 fixed_btn">저장</button>
						<textarea placeholder="직접입력" id="txt2" class="textarea w-100"></textarea>
					</div>
					<div class="spc-btn-group my-20"><!--
					--><button type="button" id="rejectBtn" onclick="updateReq(0)" class="btn_type03 w80">반송</button><!--
					--><button type="submit" class="btn_type ml-12">승인</button><!--
				--></div>
				</c:if>
			</div>
		</form>
	</div>
</div>
