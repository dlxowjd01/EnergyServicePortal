<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';

	// param: withdrawReqStatus.do
	const status = '${param.review_status}';
	const statusVal = '${param.review_status_val}';
	const spcId = '${param.review_spc_id}';
	const spcName = '${param.review_spc_name}';
	const reqId = '${param.review_req_id}'; 
	const accNum = '${param.review_acc_info}';

	$(function() {
		const tableList = $('#tableBody');
		const tableCloned = tableList.find("template.table-body").clone().html();
		tableList.find("template").remove();

		const txtArea = $("textarea.textarea");
		const btnArea = $(".spc-detail .spc-btn-group");
		const btnPrint = $(".btn-print");

		if( isEmpty(spcName) || spcName == ("-")){
			$("#spcName").text("spc_no_name");
		}	else {
			$("#spcName").text(spcName);
		}

		( ( statusVal == 0 ), ( statusVal == 3 ) ) ? ( (btnArea.addClass('hidden')),(btnPrint.addClass('hidden')) ) : ( (btnArea.removeClass('hidden')), (btnPrint.removeClass('hidden')) );
		// txtArea.eq(0).val();
		unCheckAll();
		getDataList();

		function getDataList(page) {
			page == undefined ? page = 1 : page = page;
			var sortList = [];
			var totalPage = 0;
			let action = 'get';
			let syncOpt = true;
			let option= {
				url: 'http://iderms.enertalk.com:8443/spcs/transactions',
				type: action,
				data: {
					'oid' : oid,
					'spcIds': spcId,
					'request_id': reqId
				},
				async: syncOpt
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				tableList.empty();
				if (json.data.length > 0) {
					json.data.map(item => {
						let data = json.data;
						let sum = 0;
						$("#total").text(item.total_amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원');
						const promiseAccount = Promise.resolve(JSON.parse(item.to_account));
						const promiseMemo = Promise.resolve(JSON.parse(item.memo));

						Promise.all([promiseAccount, promiseMemo]).then(res => {
								$("#txt1").val(res[1].desc);
								$("#txt2").val("");
								res[0].map( x => {
									console.log("x==", x)
									let popObj = Object.assign({}, item);
									delete(popObj.to_account);

									let purposeList = [
										{ label: "출금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
										{ label: "입금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대 수선비", "배당금 적림", "일반 지출" ]},
									];
									let purpose = purposeList[0].value[x.purpose];
									let withdraw_day = popObj.withdraw_day.substring(0, 10) + ' ' + popObj.withdraw_day.substring(11, 19);
									let amount = x.amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원';
									let to_account_no = x.to_account_no;
									// let account_type_list = [  "전력 판매대금", "REC 판매대금", "관리 운영비", "일반 렌탈", "전력중개 수수료", "전기 요금", "원리금" ];
									let str = '';
									str = tableCloned.replace(/\*withdrawDay\*/g, withdraw_day)
										.replace(/\*purpose\*/g, purpose)
										.replace(/\*amount\*/g, amount)
										.replace(/\*toAccountNum\*/g, to_account_no)
									tableList.append($(str));
								});
							}).catch(error => {
								console.log(error);
							});
						});
				} else {
					return false;
				}
				totalPage = Math.ceil(sortList.length/pagePerData);
				
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("error===", jqXHR, "text000", textStatus )
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		// $("#txt2").keyup(function(){
		// 	let preserved = $("#txt1").val();
		// 	let val = $(this).val();
		// 	$("#txt1").val(preserved += val);
		// });

		// approval => status: 3
		$("#attachedFileForm").on("submit", function(e){
			e.preventDefault();
			const newStatus = 3;
			handleReq(newStatus, updateReq);
		})
		// saving only => status: null
		$("#saveBtn").on("click", function(){
			const newStatus = null;
			let input = $("#txt2").val();
			let d = new Date();
			let prefix = '\n'
				+ d.toISOString().substring(0, 10) + ' '
				+  d.toLocaleTimeString().substr(0, d.toLocaleTimeString().length-2)
				+ '/ '
				+ loginName;

				console.log("prefix---", prefix)
			if(isEmpty(input)){
				$("#warningModal").modal("show");
			} else {
				let preserved = $("#txt1").val();
				let val = prefix + input;
				$("#txt1").val(preserved += val);
			
				// handleReq(newStatus, updateReq);
			}
		});
		// rejection => status: 0
		$("#rejectBtn").on('click', function(e){
			e.preventDefault();
			const newStatus = 0;
			handleReq(newStatus, updateReq);
		});

		function handleReq(newStatus, callback){
			let memoStr = '';
			let preserved = $("#txt1").val();
			let val = $("#txt2").val();
			$("#txt1").val(preserved += val);

			if ( $("#memoOpt").is(":checked") ){
				let memoObj = {};
				memoObj.opt = 1;
				memoObj.desc = (preserved += val);
				memoStr = JSON.stringify(memoObj);
			} else {
				memoStr = (preserved += val);
			}

			callback(newStatus, memoStr);
		}

		function updateReq(newStatus, memoStr){
			let newData = {}
			newStatus ? ( newData.status = newStatus ) : null;
			newData.status_changed_by = loginName;
			newData.status_changed_at = new Date().toISOString();
			newData.requested_by = loginName;
			newData.requested_at = new Date().toISOString();
			newData.memo = memoStr;

			let opt = {
				url: 'http://iderms.enertalk.com:8443/spcs/transactions/' + reqId + '?oid=' + oid,
				type: "patch",
				async: true,
				dataType: 'json',
				contentType: "application/json",
				data: JSON.stringify(newData)
			};
			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				console.log("success===");
				window.location.href = window.location.origin + '/spc/withdrawReqStatus.do' ;
			}).fail(function (jqXHR, textStatus, errorThrown) {
				$("#warningModal .modal-title").text('처리 중 오류가 발생했습니다.');
				$("#warningModal").modal("show");
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});
		}
	});


	function initTextArea(){
		// let preserved = "";
		// let d = new Date();

		// preserved = d.toISOString().substring(0, 10) + ' ' +  d.toLocaleTimeString().substr(0, d.toLocaleTimeString().length-2) + '/ ' + loginName + ' / 메모 히스토리'
		$("#txt1").val("");
		$("#txt2").val("")

	}

	// onclick="location.href='http://iderms.enertalk.com:8443/files/download/5c71e049-f73c-2bf9-a9a0-2f91d067ef11?oid=spower&orgFilename=수익보고서_20200526100755.pdf'"

	function downloadFile(spcId){
		var genId = $("#gen").data("value");

		$("#attachement_info").find("input[type=file]").each(function(){
			$(this).attr("name", this.name + "_" + spcId +"_" + genId);
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
			data: new FormData($('#attachement_info')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			success: function (result) {
				// console.log
				// sendSpcGenPost(spcId, result.files);
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

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
			<div class="flex_wrapper">
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
							<th>요청 금액</th>
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
								<td>*amount*</td>
								<td>*toAccountNum*</td>
								<td></td>
							</tr>
						</template>
					</tbody>
					<tfoot>
						<tr>
							<td>합계</td>
							<td></td>
							<td id="total"></td>
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
				<div class="flex_wrapper">
					<h2 class="ntit">증빙 서류</h2>
				</div>
				<div class="flex_wrapper border">
					<a id="file_name" href="#" class="btn_type02">거래 내역서.pdf</a>
					<a onclick="downloadFile('spc_name')" class="save_btn"></a>
				</div>
				
				<div class="flex_wrapper">
					<h2 class="heading">출금 요청서</h2>
					<div class="fr"><button type="button" class="btn_type ml-12">다운로드</button></div>
				</div>
				<div class="flex_wrapper border mt20">
					<h2 class="heading">증빙 서류</h2>
					<div class="fr"><button type="button" class="btn_type ml-12">다운로드</button></div>
				</div>
				<div class="flex_wrapper">
<<<<<<< HEAD
					<h2 class="heading">메모 히스토리</h2>
=======
					<h2 class="heading">변경 내역</h2>
>>>>>>> a5a14a2bb43860b7276305c3d29f7901b522dd22
				</div>
				<div class="flex_wrapper border mt20">
					<textarea id="txt1" class="textarea w-100" readonly></textarea>
				</div>
				<div class="flex_wrapper">
					<h2 class="heading">메모</h2><!--
					--><a class="chk_type" href="javascript:void(0);"><input type="checkbox" id="memoOpt" name="memo_opt"><label for="memoOpt">사무수탁사 함께 보기</label></a><!--
			--></div>
				<div class="textarea-container mt20">
					<button type="button" id="saveBtn" class="btn_type03 fixed_btn">저장</button>
					<textarea placeholder="직접입력" id="txt2" class="textarea w-100"></textarea>
				</div>

				<div class="spc-btn-group mt20"><!--
				--><button type="button" id="rejectBtn" class="btn_type03 w80">반송</button><!--
				--><button type="submit" class="btn_type ml-12">승인</button><!--
			--></div>
			</div>
		</form>
	</div>
</div>
