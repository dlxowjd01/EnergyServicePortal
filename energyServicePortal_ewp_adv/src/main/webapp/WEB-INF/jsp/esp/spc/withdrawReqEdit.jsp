<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const loginName = '${sessionScope.userInfo.name}';

	// param: withdrawReqStatus.do
	const spcId = '${param.req_edit_spc_id}';
	const spcName = '${param.req_edit_spc_name}';
	const reqId = '${param.req_edit_req_id}';

	$(function() {
		const withdrawForm = $('#withdrawForm');
		const spcList = $('#spcList');
		const withdrawList = $('#withdrawList');
		const tableBody = $("#tableBody");
		const copyWithdrawList = $("#withdrawList").clone().html();
		const copyTableRow = tableBody.find(".template-row").clone().html();

		let fileList = [];
		let totalAmount = 0;
		// let uploadForm = $("#uploadForm")[0];

		withdrawList.empty();
		tableBody.find(".template-row").remove();

		unCheckAll(tableBody);

		$("#selectedSpcId").text(spcName).data("value", spcId);
		$("#requestedDate").change(function(){
			let val = $(this).val();
			let d = $("#tableBody").find(".fromDate");
			d.each(function(){
				$(this).val(val);
			});
		});

		$("#fileInput").change(function(){
			fileList = [];
			for(let i = 0, fileLength = $(this)[0].files.length; i < fileLength; i++){
				fileList.push($(this)[0].files);
			}
			// console.log("fileLost===", fileList)
		});

		getData(spcId);

		function removeDuplicates(arr) {
			var newArray = [];
			var lookupObject  = {};

			for(var i in originalArray) {
				lookupObject[originalArray[prop]] = originalArray;
			}

			for(i in lookupObject) {
				newArray.push(lookupObject);
			}
			return newArray;
		}

		function getData (id) {
			if (isEmpty(id)) return false;

			let action = 'get';
			let syncOpt = true;
			let option = [
				{
					url: apiHost + '/spcs/' + id + '?oid=' + oid + "&includeGens=true",
					type: action,
					async: syncOpt
				},
				{
					url: apiHost + '/spcs/transactions?oid=' + oid,
					type: action,
					async: syncOpt,
					data: {
						request_id: reqId,
						spcIds: id
					}
				},
			];

			$.when($.ajax(option[0]),$.ajax(option[1])).done(function (result1, result2) {
				if(!isEmpty(result1[0].data) && !isEmpty(result2[0].data)){
					// console.log("1---", result1[0].data)
					// console.log("2---", result2[0])
					handleAccData(result1[0].data, result2[0].data);
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});

		}

		function handleAccData(accInfo, transactionInfo){
			let transactionData = transactionInfo[0];
			if (accInfo[0].spcGens && accInfo[0].spcGens.length > 0 ) {
				let accData = accInfo[0];
				let gensInfo = accData.spcGens;
				let sending = '';
				let receiving = '';
				var tempArr = [];
				var promises = [];

				$.each(gensInfo, function(index, element){
					promises.push(Promise.resolve(JSON.parse(element.finance_info)));
					// promises.push(resolve(JSON.parse(element)));
				});
				Promise.all(promises).then(res => {
					if(transactionData.to_account){
						var updatedAt = transactionData.updated_at;
						var savedTotal = transactionData.total_amount.toLocaleString() + ' 원';
						Promise.resolve(JSON.parse(transactionData.to_account)).then(res => {
							$.each(res, function(index, element){
								let tbodyStr = '';
								let req_date = '';
								let req_amount = '';
								let purpose = '';
								let purpose_val = '';
								let bank_name = '';
								let account_num = '';
								let desc = '';
								let idx = '';
								let purposeList = [
									{ label: "출금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대수선비", "배당금 적림", "일반 지출", "DSRA 적립", "기타", "운영계좌" ]},
									{ label: "입금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
								];
								if(index == 0){
									idx = '';
								} else {
									idx = index;
								}
								if(!isEmpty(updatedAt)){
									req_date = new Date(updatedAt).toLocaleDateString("en-CA").replace(/\//g, '-');
								} else {
									req_date = '-';
								}

								if(!isEmpty(element.purpose)){
									// console.log("element.purpose===", element.purpose)
									purpose = purposeList[0].value[element.purpose];
									purpose_val = element.purpose;
								} else {
									purpose = '-';
								}

								if(!isEmpty(element.amount)){
									req_amount = element.amount.toString();
								} else {
									req_amount = '-';
								}

								if(!isEmpty(element.to_account_bank) ){
									bank_name = element.to_account_bank;
								} else {
									bank_name = '';
								}

								if(!isEmpty(element.to_account_no) ){
									account_num = element.to_account_no
								} else {
									account_num = '등록된 계좌가 없습니다.';
								}

								if(!isEmpty(element.desc) ){
									desc = element.desc;
								} else {
									desc = "-";
								}
								// console.log("purpose===", purpose)

								tbodyStr = copyTableRow.replace(/\*index\*/g, idx)
									.replace(/\*selectedReqDate\*/g, req_date)
									.replace(/\*purposeValue\*/g, purpose_val)
									.replace(/\*purposeTitle\*/g, purpose)
									.replace(/\*reqAmount\*/g, req_amount)
									.replace(/\*bankName\*/g, bank_name)
									.replace(/\*accNum\*/g, account_num)
									.replace(/\*desc\*/g, desc)
								$("#tableBody").append($(tbodyStr));
							});

							$("#total").val(savedTotal);
						}).then(() => {
							$.each(res, function(index, element){
								// console.log("x===", x)
								Object.entries(element).map((item, index) => {
									const strAccType = "입출금_구분";
									const strAccNum = "계좌_번호";
									const bankName = "은행_리스트";
									const accHolder = "예금주";

									if(item[0].match(strAccType)){
										let n = item[0].replace(strAccType, '');
										let myObj = {};
										myObj.accCategory = item[0];
										myObj.accType = item[1];
										myObj.accNum = element[strAccNum+n];
										myObj.bankName = element[bankName+n];
										myObj.accHolder = element[accHolder+n];
										tempArr.push(myObj);
									}
								});

								tempArr.reduce((acc, current) => {
									// comparison 1. 은행 이름
									const x = acc.find(item => item.accNum === current.accNum);
									// comparison 2.입금 || 출금 계좌
									const y = acc.find(item => item.accType === current.accType);
									if (!x) {
										return acc.concat([current]);
									} else {
										return acc;
									}
								}, []).map((v, i) => {
									let sending = '';
									let receiving = '';
									let bankName = '';
									let accNum = '';
									if(v.accType.match("출금")){
										accNum = v.accNum;
										accHolder = v.accHolder;
										bankName = v.bankName;
										// console.log("v---", v);
										let accInfo = bankName + '&nbsp;' + accNum;
										let newHtml;
										withdrawList.prev().data({"value": accNum, "name": bankName }).html(accInfo + '<span class="caret"></span>');
										// selectedAcc.html( selectedAcc.html().replace(/\*bank_name\*/g, bankName).replace(/\*acc_num\*/g, accNum) );
										sending = copyWithdrawList.replace(/\*bank_name\*/g, bankName).replace(/\*acc_num\*/g, accNum).replace(/\*acc_holder\*/g, accHolder);
										withdrawList.append($(sending));
									} else {
										bankName = v.bankName;
										accNum = v.accNum;
										accHolder = v.accHolder;

										let copyReceiveList = $(".receive-list").eq(index).clone().html();

										receiving = copyReceiveList.replace(/\*to_acc_type\*/g, v.accType).replace(/\*to_bank_name\*/g, bankName).replace(/\*to_account_no\*/g, accNum).replace(/\*acc_holder\*/g, accHolder);
										$(".receive-list").each(function(){
											$(this).empty().append($(receiving));
											$(this).find("li").on("click", function(){
												// console.log("receive list clicking---")
												$(this).prev().data({"value": $(this).data("value"), "name": $(this).data("name") });
											});
										});

									}
								});
							});
						}).then(() => {
							calcTotal();
							withdrawList.find("li").on("click", function(){
								// console.log("withdrawList clicking---")
								withdrawList.prev().data({"value": $(this).data("value"), "name": $(this).data("name"), "acc-holder" : $(this).data("acc-holder") });
							});
							
				

						});
					}
				});
			} else {
				let sendingNodata = '';
				let receivingNodata = '';
				sendingNodata = copyWithdrawList.replace(/\*bank_name\*/g, '').replace(/\*acc_num\*/g,'등록 계좌 없음').replace(/\*acc_num\*/g, '').replace(/\*acc_holder\*/g, '');
				receivingNodata = copyReceiveList.replace(/\*to_acc_type\*/g, '등록된 입금 계좌가 없습니다.').replace(/\*to_bank_name\*/g, '등록 계좌 없음').replace(/\*to_account_no\*/g, '').replace(/\*acc_holder\*/g, '');
				withdrawList.append($(sendingNodata));
				$(".receive-list").each(function(){
					$(this).empty().append($(receivingNodata));
					$(this).find("li").on("click", function(){
						// console.log("receive list clicking---")
						$(this).prev().data({"value": "", "name": "" });
					});
				});
			}

			$("#requestedDate").change(function(){
				let val = $(this).val();
				let d = $("#tableBody").find(".fromDate");
				d.each(function(){
					$(this).val(val);
				});
			});
			
			if(transactionData.attachement_info){
				Promise.resolve(JSON.parse(transactionData.attachement_info)).then(res => {
					let addFileList = $("#addFileList").find(".file_list");
					addFileList.empty();
					res.forEach(attach => {
						let downUrl = apiHost + '/files/download/' + attach.filedName + '?oid=' + oid + '&orgFilename=' + attach.originalName.trim();
						let templateAttach = `
							<li class="upload_text" data-id="${'${attach.filedName}'}">${'${attach.originalName.trim()}'}
								<button type="button" class="btn_close icon_btn" onclick="deleteFile($(this))"></button>
							</li>
						`;
						addFileList.append(templateAttach);
					});
				});
			}
		}

		function uniqBy(a, key) {
			var seen = {};
			return a.filter(function(item) {
				var k = key(item);
				return seen.hasOwnProperty(k) ? false : (seen[k] = true);
			})
		}

		withdrawForm.on('submit', function(e){
			e.preventDefault();
			let warning = withdrawForm.find(".warning");
			let tr = tableBody.find("tr");
			let jsonData = {}
			let arr =[];
			let finalNameList = [];
			let uid = `${sessionScope.userInfo.uid}`;

			warning.addClass("hidden");
			jsonData.spc_id = Number($("#selectedSpcId").data("value"));
			// from
			jsonData.withdraw_bank = withdrawList.prev().data("name");
			jsonData.withdraw_account_no = withdrawList.prev().data("value").toString();
			jsonData.withdraw_account_owner = withdrawList.prev().data("acc-holder");
			jsonData.withdraw_day = $("#requestedDate").val().replace(/-/g, "");
			// to
			jsonData.to_account = "";
			// status
			jsonData.status = 1;
			jsonData.status_changed_by = loginName;
			jsonData.status_changed_at = new Date();
			jsonData.requested_by = loginName;
			jsonData.requested_by_uid = uid;
			jsonData.requested_at = new Date();
			jsonData.transfer_agent = loginName;

			let fileNames = $("#addFileList").find("li.upload_text");
			$.each(fileNames, function(index, element){
				let obj = {};
				obj.originalName = $(this).text();
				obj.filedName = $(this).data("id");
				finalNameList.push(obj);
			});
			jsonData.attachement_info = JSON.stringify(finalNameList);

			tr.each(function(index, element){
				let purposeOpt = $("#tableBody").find("td:nth-of-type(3) .dropdown-toggle");
				let amountOpt = $("#tableBody").find("td:nth-of-type(4) input");
				let accOpt = $("#tableBody").find("td:nth-of-type(5) .dropdown-toggle");
				let descOpt = $("#tableBody").find("td:nth-of-type(6) input");
				let obj = {};
				obj.purpose = purposeOpt.eq(index).data("value");
				obj.amount = Number(amountOpt.eq(index).val().replace(/,/g, ''));
				obj.to_account_owner = accOpt.eq(index).data("acc-holder");
				obj.to_account_bank = accOpt.eq(index).data("name");
				obj.to_account_no = accOpt.eq(index).data("value");
				obj.desc = descOpt.eq(index).val();
				arr.push(obj);
			});
			jsonData.total_amount = totalAmount;
			jsonData.to_account = JSON.stringify(arr);
			// console.log("json--", jsonData);
			let newJson = JSON.stringify(jsonData);
			let formArr = [ jsonData.withdraw_day, arr ];

			// console.log("formArr===", formArr)
			$.each(formArr, function(index, value){
				if(index === 0) {
					arr.forEach((item, index) => {
						if(item.purpose == "" || item.purpose == "undefined" ) {
							warning.eq(2).removeClass('hidden');
						} else if (item.amount == 0) {
							warning.eq(2).removeClass('hidden');
						}  else if (item.to_account_no == "undefined" ) {
							warning.eq(2).removeClass('hidden');
						} else {
							warning.eq(2).addClass('hidden');
						}
					});

				} else {
					if(value == undefined ||  value == "선택" || value == "") {
						warning.eq(2).removeClass('hidden');
					} else {
						warning.eq(2).addClass('hidden');
					}
				}
			});

			if( withdrawForm.find(".warning.hidden").length == 2 ){
				let opt = {
					url: apiHost + '/spcs/transactions?oid='+oid,
					type: "POST",
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(jsonData)
				};

				$.ajax(opt).done(function (json, textStatus, jqXHR) {
					$.each(fileList, function(index, element){
						uploadFile('post', $("#fileInput")[0].files[index], finalNameList[index].filedName);
					});
					window.location.href = window.location.origin + '/spc/transactionHistory.do'
				}).fail(function (jqXHR, textStatus, errorThrown) {
					alert('처리 중 오류가 발생했습니다.');
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});
			} else {
				console.log("warning length===", withdrawForm.find(".warning").length )
			}
		});

		function uploadFile(action, file, filedName){
			let formData = new FormData($('#fileUploadForm')[0]);
			formData.append(filedName, file);

			let option= {
				type: action,
				enctype: 'multipart/form-data',
				url: apiHost + '/files/upload?oid=' + oid,
				processData: false,  // Important!
				contentType: false,
				cache: false,
				timeout: 600000,
				async: false,
				data: formData,
			}

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				console.log("success===", json)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("jqXHR===", jqXHR)
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		// amount number trim event
		function calcTotal() {
			$(".amount").each(function() {
				$(this).on('keypress', function(evt) {
					let val = $(this).val();
					
					if (evt.which == "0".charCodeAt(0) && val.trim() == "") {
						return false;
					}
					if (evt.which < 48 || evt.which > 57) {
						return false;
					}
				});

				$(this).on('keyup', function(evt, limit) {
					if( $(this).val().match(/[^\x00-\x80]/) ){
						$(this).val("");
					}
				});
			});
		}

		$(document).on("change", ".amount", function(evt) {
			let newVal = this.value;
			let total = document.getElementById("total");
			totalAmount = 0;
			newVal = this.value.replace(/,/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			this.value = newVal;
			// console.log("document on change===", evt)
			if(newVal != "") {
				// if ( (keyCode != 8 || keyCode ==32 ) && (keyCode < 48 || keyCode > 57)) { evt.preventDefault(); }
				if (evt.which < 48 || evt.which > 57) { evt.preventDefault(); }
				$(".amount").each(function(){
					let toAdd = Number(this.value.replace(/,/g,""));
					totalAmount += toAdd;
				});
				total.value = totalAmount.toLocaleString() + ' 원';
				newVal = this.value.toLocaleString();
			} else {
				total.value = 0 + " 원";
			}
		});

		$("#addRowBtn").on("click", calcTotal, function(){
			addCustomRow(tableBody, 'first');
			calcTotal();
		});

		$("#deleteRowBtn").on("click", function(){
			$("#tableBody tr:not(:first-child)").find('td input:checked').closest('tr').remove();
		});

		$("#selectAll").on("click", function(){
			$("#tableBody").find('input:checkbox').prop('checked', this.checked);
		});
	});


</script>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 수정</h1>
		<div class="time fr"><span>CURRENT TIME</span><em class="currTime">${nowTime}</em></div>
	</div>
</div>

<form id="fileUploadForm" name="fileUploadForm"></form>
<form id="withdrawForm" name="withdraw_form" action="#" method="post">
	<div class="row spc-search-bar">
		<div class="col-12">
			<div class="sa_select"><!--
			--><span class="tx_tit">SPC 선택</span><!--
			--><div class="dropdown"><button type="button" id="selectedSpcId" class="btn btn-primary readonly" data-value=""></button></div>
			</div>
			<div class="sa_select"><!--
			--><span class="tx_tit">출금 계좌번호</span><!--
			--><div class="dropdown"><!--
				--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="" data-value=""><span class="caret"></span></button>
					<ul id="withdrawList" class="dropdown-menu unused center" role="menu"><li data-acc-holder="*acc_holder*" data-name="*bank_name*" data-value="*acc_num*"><a href="#" tabindex="-1">*bank_name* *acc_num*</a></li></ul>
				</div>
			</div>
			<div class="sa_select"><!--
			--><label for="availableAmount" class="tx_tit">계좌 잔액</label><!--
			--><div class="tx_inp_type"><input type="text" id="" name="availableAmount" disabled="" readonly=""></div>
			</div>
		</div>
	</div>
	<div class="row content-wrapper spc-transaction">
		<div class="col-12">
			<div class="indiv spc_bal_post">
				<table class="table-footer">
					<colgroup>
						<col style="width:4%">
						<col style="width:16%">
						<col style="width:15%">
						<col style="width:20%">
						<col style="width:30%">
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
						<th>출금 요청 일자</th>
						<th>용도 구분</th>
						<th>요청 금액</th>
						<th>입금 계좌 번호</th>
						<th>비고</th>
					</tr>
					</thead>
					<tbody id="tableBody">
						<template class="template-row">
							<tr>
								<td>
									<a class="chk_type select_row">
										<input type="checkbox" id="apply*index*" name="apply">
										<label for="apply"></label>
									</a>
								</td>
								<td>
									<div class="sel_calendar"><input type="text" id="requestedDate*index*" name="requestedDate*index*" class="sel fromDate" value="*selectedReqDate*" autocomplete="off" placeholder="선택"></div>
								</td>
								<td>
									<div class="sa_select">
										<div class="dropdown placeholder">
											<button class="btn btn-primary dropdown-toggle" data-clone="empty" type="button" data-toggle="dropdown" data-name="" data-value="*purposeTitle*">*purposeTitle*<span class="caret"></span></button>
											<ul id="purposeList*index*" class="dropdown-menu" role="menu">
												<li data-value="0"><a href="#" tabindex="-1">관리운영비</a></li>
												<li data-value="1"><a href="#" tabindex="-1">사무수탁비</a></li>
												<li data-value="2"><a href="#" tabindex="-1">부채상환</a></li>
												<li data-value="3"><a href="#" tabindex="-1">대수선비</a></li>
												<li data-value="4"><a href="#" tabindex="-1">배당금 적립</a></li>
												<li data-value="5"><a href="#" tabindex="-1">일반 지출</a></li>
												<li data-value="6"><a href="#" tabindex="-1">DSRA 적립</a></li>
												<li data-value="8"><a href="#" tabindex="-1">운영계좌</a></li>
												<li data-value="7"><a href="#" tabindex="-1">기타</a></li>
											</ul>
										</div>
									</div>
								</td>
								<td>
									<div class="tx_inp_type"><!--
									--><input type="text" id="transferAmount*index*" class="amount right" name="transfer_amount" value="*reqAmount*" placeholder="직접 입력" maxlength="18"><!--
								--></div><!--
							--></td>
								<td>
									<div class="sa_select">
										<div class="dropdown placeholder">
											<button class="btn btn-primary dropdown-toggle" type="button" data-clone="empty" data-toggle="dropdown" data-name="*bankName*" data-value="*accNum*">*bankName*  *accNum*<span class="caret"></span></button>
												<ul id="receiveList*index*" class="receive-list dropdown-menu" role="menu">
													<li data-acc-holder="*acc_holder*" data-acc-type="*to_acc_type*" data-name="*to_bank_name*" data-value="*to_account_no*"><a href="#" tabindex="-1">*to_bank_name* *to_account_no*</a></li>
												</ul>
										</div>
									</div>
								</td>
								<td>
									<div class="tx_inp_type"><input type="text" id="note*index*" name="note*index*" value="*desc*" placeholder="직접 입력"></div>
								</td>
							</tr>
						</template>
					</tbody>
					<tfoot>
						<tr>
							<td></td>
							<td>합계</td>
							<td></td>
							<td><input type="text" id="total" class="clear-input right" readonly disabled required pattern="[0-9\.]+"></td>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				</table>
				<div class="btn_wrap_type">
					<div class="fl"><!--
					--><small class="hidden warning">테이블의 출금 요청 정보를 모두 기입해 주세요.</small><!--
					--><small class="hidden warning">출금 요청 정보를 기입해 주세요.</small><!--
				--></div><!--
				--><button type="button" id="deleteRowBtn" class="btn_type07">선택 삭제</button><!--
				--><button type="button" id="addRowBtn" class="btn-text-blue">열 추가</button><!--
			--></div>
			</div>
			<div class="indiv mt25">
				<div class="spc_tbl_row">
					<table id="secondTable">
						<colgroup>
							<col style="width:15%">
							<col style="width:85%">
							<col>
						</colgroup>
						<tr>
							<th class="th_type">증빙 첨부</th>
							<td id="addFileList" class="flex_start_td"><!--
								--><input type="file" name="file" id="fileInput" class="uploadBtn hidden" accept=".pdf" multiple><!--
								--><label for="fileInput" class="btn file_upload">파일 선택</label><!--
								--><div class="file_list ml-16"><ul><li>선택된 파일이 없습니다.</li></ul></div>
							</td>
							<td></td>
						</tr>
					</table>
				</div>

				<div class="btn_wrap_type05"><!--
				--><button type="submit" class="btn btn_type">제출</button><!--
			--></div>
			</div>
		</div>
	</div>
</form>
