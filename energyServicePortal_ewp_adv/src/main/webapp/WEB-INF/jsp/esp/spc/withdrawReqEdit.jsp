<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
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
			let fieldName = genUuid();
			for(let i = 0, fileLength = $(this)[0].files.length; i < fileLength; i++) {
				let fieldName = genUuid();
				uploadFile('post', $(this)[0].files[i], fieldName);
			}

			$('#fileInput').val('');
		});

		function getAmount() {
			const account = $('#withdrawList').prev().data('value').replace(/[^\d]/g, '');

			if (!isEmpty(account)) {
				$.ajax({
					url: apiHost + '/spcs/transactions/real/balance',
					type: 'GET',
					data: {
						oid: oid,
						spcIds: spcId
					}
				}).done(function (json, textStatus, jqXHR) {
					if (!isEmpty(json) && !isEmpty(json.data) && !isEmpty(json.data.items)) {
						const targetAccount = json.data.items.find(e => e.account_no === account);

						if (isEmpty(targetAccount)) {
							$('[name="availableAmount"]').val('');
						} else {
							$('[name="availableAmount"]').val(numberComma(targetAccount.account_balance));
						}
					} else {
						$('[name="availableAmount"]').val('');
					}
				}).fail(function (jqXHR, textStatus, errorThrown) {
					alert('처리 중 오류가 발생했습니다.');
					return false;
				});
			} else {
				$('[name="availableAmount"]').val('');
			}
		}

		getData(spcId);

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
					withdrawList.prev().data({"value": transactionData.withdraw_account_no, "name": transactionData.withdraw_bank }).html(transactionData.withdraw_bank + '&nbsp;' + transactionData.withdraw_account_no + '<span class="caret"></span>');
					getAmount();
					if(transactionData.to_account){
						var withdraw_day = transactionData.withdraw_day;
						if (!isEmpty(withdraw_day) && withdraw_day.length == 8) {
							withdraw_day = withdraw_day.substring(0, 4)+'-'+withdraw_day.substring(4, 6)+'-'+withdraw_day.substring(6, 8);
						}
						var savedTotal = transactionData.total_amount.toLocaleString() + ' 원';
						Promise.resolve(JSON.parse(transactionData.to_account)).then(item => {
							$.each(item, function(index, element){
								let tbodyStr = '';
								let req_date = '';
								let req_amount = '';
								let purpose = '';
								let purpose_val = '';
								let bank_name = '';
								let account_num = '';
								let desc = '';
								let accHolder = '';
								let idx = '';
								let purposeArr = [
									{ label: "출금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대수선비", "배당금 적립", "일반 지출", "DSRA 적립", "기타", "운영계좌", "공사비", "임대료", "대납금"]},
									{ label: "입금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
								];
								if(index == 0){
									idx = '';
								} else {
									idx = index;
								}
								if(!isEmpty(withdraw_day)){
									req_date = withdraw_day;
								} else {
									req_date = '-';
								}

								if(!isEmpty(element.purpose)){
									// console.log("element.purpose===", element)
									purpose = purposeArr[0].value[element.purpose];
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

								if(!isEmpty(element.to_account_owner) ){
									accHolder = element.to_account_owner;
								} else {
									accHolder = "-";
								}

								tbodyStr = copyTableRow.replace(/\*index\*/g, idx)
									.replace(/\*selectedReqDate\*/g, req_date)
									.replace(/\*purposeVal\*/g, purpose_val)
									.replace(/\*purposeTitle\*/g, purpose)
									.replace(/\*reqAmount\*/g, req_amount)
									.replace(/\*bankName\*/g, bank_name)
									.replace(/\*accHolder\*/g, accHolder)
									.replace(/\*accNum\*/g, account_num)
									.replace(/\*desc\*/g, desc)
								$("#tableBody").append($(tbodyStr));
							});
							totalAmount = transactionData.total_amount;
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
									const y = acc.find(item => (item.accNum === current.accNum && item.accType === current.accType));
									if (!x) {
										return acc.concat([current]);
									} else {
										if (!y) {
											return acc.concat([current]);
										} else {
											return acc;
										}
									}
								}, []).map((v, i) => {
									let sending = '';
									let receiving = '';
									let bankName = '';
									let accNum = '';
									let accHolder = '';
									console.log("v===", v.accHolder)
									if(v.accType.match("출금")){
										accNum = v.accNum;
										accHolder = v.accHolder;
										bankName = v.bankName;
										// console.log("v---", v);
										let accInfo = bankName + '&nbsp;' + accNum;
										let newHtml;
										//withdrawList.prev().data({"value": accNum, "name": bankName }).html(accInfo + '<span class="caret"></span>');
										// selectedAcc.html( selectedAcc.html().replace(/\*bank_name\*/g, bankName).replace(/\*acc_num\*/g, accNum) );
										sending = copyWithdrawList.replace(/\*bank_name\*/g, bankName).replace(/\*acc_num\*/g, accNum).replace(/\*acc_holder\*/g, accHolder);
										withdrawList.append($(sending));
									} else {
										bankName = v.bankName;
										accNum = v.accNum;
										accHolder = v.accHolder;

										let copyReceiveList = '<li data-acc-holder="*acc_holder*" data-acc-type="*to_acc_type*" data-name="*to_bank_name*" data-value="*to_account_no*"><a href="#" tabindex="-1">*to_bank_name* *to_account_no* *acc_holder*</a></li>';

										receiving = copyReceiveList.replace(/\*to_acc_type\*/g, v.accType).replace(/\*to_bank_name\*/g, bankName).replace(/\*to_account_no\*/g, accNum).replace(/\*acc_holder\*/g, accHolder);

										$(".receive-list").each(function(){
											$(this).append($(receiving));
											$(this).find("li").on("click", function(){
												// console.log("receive list clicking---")
												$(this).prev().data({"value": $(this).data("value"), "name": $(this).data("name") });
											});
										});

									}
								})
							});
							$(".purpose-list").each(function(){
								let purpose = $(this);
								$(this).find("li").on("click", function(){
									// console.log("purpose===", purpose)
									purpose.data("value", $(this).data("value"));
								})
							});
						}).then(() => {
							calcTotal();
							withdrawList.find("li").on("click", function(){
								// console.log("withdrawList clicking---")
								withdrawList.prev().data({"value": $(this).data("value"), "name": $(this).data("name"), "acc-holder" : $(this).data("acc-holder") });
								getAmount();
							});
						}).finally(() => {
							setDatepicker();
							$(".receive-list").append(`<li data-value="직접입력"><a href="#" tabindex="-1">직접입력</a></li>`);
							bankProperties();
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
				$(".purpose-list").each(function(){
					let purpose = $(this);
					$(this).find("li").on("click", function(){
						console.log("purpose===", purpose)
						purpose.data("value", $(this).data("value"));
					})
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
					var attachment = ''
					var addFileList = $("#addFileList").find(".file_list");
					if(res.length > 0){
						addFileList.find("ul").empty();
						res.forEach(attach => {
							let downUrl = apiHost + '/files/download/' + attach.filedName + '?oid=' + oid + '&orgFilename=' + attach.originalName.trim();
							let templateAttach = `
								<li class="upload-text" data-id="${'${attach.filedName}'}">${'${attach.originalName.trim()}'}
									<button type="button" class="btn-close btn-icon" onclick="deleteFile($(this))"></button>
								</li>
							`;
							addFileList.append(templateAttach);
						});
					}
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
			jsonData.requested_by_uid = userInfoId;
			jsonData.requested_at = new Date();
			jsonData.transfer_agent = loginName;
			jsonData.total_amount = totalAmount;
			
			// console.log("total---", totalAmount);

			let fileNames = $("#addFileList").find("li.upload-text");
			$.each(fileNames, function(index, element){
				let obj = {};
				obj.originalName = $(this).text();
				obj.filedName = $(this).data("id");
				finalNameList.push(obj);
			});
			jsonData.attachement_info = JSON.stringify(finalNameList);

			tr.each(function(index, element){
				let $elm = $(element);
				let purposeOpt = $elm.find("td:nth-of-type(3) .dropdown-toggle");
				let amountOpt = $elm.find("td:nth-of-type(4) input");
				let accOpt = $elm.find("td:nth-of-type(5) .dropdown-toggle").eq(0);
				let accOpt2 = $elm.find('td:nth-of-type(5) .dropdown-toggle').eq(1);
				let accNo = $elm.find('td:nth-of-type(5) input');
				let descOpt = $elm.find("td:nth-of-type(6) input");
				let obj = {};

				obj.purpose = purposeOpt.data("value");
				obj.amount = Number(amountOpt.val().replace(/,/g, ''));
				obj.desc = descOpt.val();
				if (accOpt.data("value") == '직접입력') {
					obj.to_account_owner = '직접입력';
					obj.to_account_bank = accOpt2.data("value");
					obj.to_account_no = accNo.val();
				} else {
					obj.to_account_owner = accOpt.data("acc-holder");
					obj.to_account_bank = accOpt.data("name");
					obj.to_account_no = accOpt.data("value");
				}
				arr.push(obj);
			});
			// console.log("total===0", totalAmount)

			jsonData.to_account = JSON.stringify(arr);
			// console.log("json--", jsonData);
			let newJson = JSON.stringify(jsonData);
			let formArr = [ jsonData.withdraw_day, arr ];
			var flagArr = [];
			flagArr.length = 0;
			// console.log("formArr===", formArr)
			$.each(formArr, function(index, value){
				if(index === 0) {
					console.log("arr===", arr)
					arr.forEach((item, index) => {
						if(item.purpose != 0 && item.purpose == "" || item.purpose != 0 && item.purpose == "undefined" ) {
							let obj = { label: "purposeEmpty", val: 0 }
							flagArr.push(obj);
							// warning.eq(2).removeClass('hidden');
						}
						if (item.amount == 0) {
							let obj = { label: "amountEmpty", val: 1 }
							flagArr.push(obj);
						}
						if (item.to_account_no == "undefined" ) {
							let obj = { label: "accNumEmpty", val: 2 }
							flagArr.push(obj);
						}
					});
				} else {
					if(value == undefined ||  value == "선택" || value == "") {
						flagArr.push("withdrawDayEmpty");
						console.log("withdrawDayEmpty===", item.value)
					}
				}
			});

			if(flagArr.length > 0){
				console.log("flag===", flagArr)
				warning.removeClass('hidden');
			} else {
				warning.addClass('hidden');
			}

			if( withdrawForm.find(".warning.hidden").length === 1 ){
				let opt = {
					url: apiHost + '/spcs/transactions/' + reqId + '?oid=' + oid,
					type: "patch",
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
				let fileList = json.files;

				if ($('#fileInput').parent().find('div.file_list li').length == 1 && $('#fileInput').parent().find('div.file_list li').text() == '선택된 파일이 없습니다.') {
					$('#fileInput').parent().find('div.file_list ul').empty();
				}

				fileList.forEach(file => {
					let listItem = `<li class='upload-text' data-id="${'${file.fieldname}'}">
									${'${file.originalname}'}
									<button type='button' class='btn-close btn-icon' onclick='deleteFile($(this))'></button>
								</li>`;

					$('#fileInput').parent().find('div.file_list ul').append(listItem);
				});
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

			// TO: 정차장님 아래로 하면 한번만 선언해도 되는데 확인 부탁드릴꼐요.
			// this.value = this.value.replace(/,/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			
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
			let total = document.getElementById("total");
			totalAmount = 0;
			$(".amount").each(function(){
				let toAdd = Number(this.value.replace(/,/g,""));
				totalAmount += toAdd;
			});
			total.value = totalAmount.toLocaleString() + ' 원';
		});

		$("#selectAll").on("click", function(){
			$("#tableBody").find('input:checkbox').prop('checked', this.checked);
		});

		function bankProperties() {
			let opt = {
				url: apiHost + '/config/view/properties?types=bank_name',
				type: 'GET',
				dataType: 'json'
			};

			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				const bankList = json.bank_name;
				$('.bank-list').empty();
				if (bankList != null) {
					Object.entries(bankList).map(bank => {
						let bankObj = bank[1];
						let propName = (langStatus == 'KO') ? bankObj.name.kr : bankObj.name.en;
						let temp = `<li data-value="${'${propName}'}"><a href="#" tabindex="-1">${'${propName}'}</a></li>`
						$('.bank-list').append(temp);
					});
				} else {
					let temp = `<li data-value=""><a href="#" tabindex="-1">조회된 은행이 없습니다.</a></li>`
					$('.bank-list').append(temp);
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});
		}
	});

	function setDatepicker() {
		$(document).find('.fromDate').prop('disabled', true);
		$(document).find('.fromDate').first().prop('disabled', false).datepicker({
			showOn: "both",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function(selectedDate) {
				$('.fromDate').val(selectedDate);
			}
		});
	}

	function rtnDropdown($selector) {
		if ($selector.match('receiveDropDown')) {
			const obj = $('#' + $selector);
			const selValue = obj.find('button').data('value');
			if (selValue == '직접입력') {
				obj.parents('td').find('div:nth-child(2)').removeClass('hidden');
				obj.parents('td').find('div:nth-child(3)').removeClass('hidden');
			} else {
				obj.parents('td').find('div:nth-child(2)').addClass('hidden');
				obj.parents('td').find('div:nth-child(3)').addClass('hidden');
			}
		}
	}
</script>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 수정</h1>
	</div>
</div>

<form id="fileUploadForm" name="fileUploadForm"></form>
<form id="withdrawForm" name="withdraw_form" action="#" method="post">
	<div class="row spc-search-bar">
		<div class="col-12">
			<div class="sa-select"><!--
			--><span class="tx-tit">SPC 선택</span><!--
			--><div class="dropdown"><button type="button" id="selectedSpcId" class="btn btn-primary readonly" data-value=""></button></div>
			</div>
			<div class="sa-select"><!--
			--><span class="tx-tit">출금 계좌번호</span><!--
			--><div class="dropdown"><!--
				--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="" data-value=""><span class="caret"></span></button>
					<ul id="withdrawList" class="dropdown-menu unused center" role="menu"><li data-acc-holder="*acc_holder*" data-name="*bank_name*" data-value="*acc_num*"><a href="#" tabindex="-1">*bank_name* *acc_num*</a></li></ul>
				</div>
			</div>
			<div class="sa-select"><!--
			--><label for="availableAmount" class="tx-tit">계좌 잔액</label><!--
			--><div class="text-input-type"><input type="text" id="" name="availableAmount" disabled="" readonly=""></div>
			</div>
		</div>
	</div>
	<div class="row content-wrapper spc-transaction">
		<div class="col-12">
			<div class="indiv spc-balance-post">
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
							<a class="chk-type select_row">
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
									<a class="chk-type select_row">
										<input type="checkbox" id="apply*index*" name="apply*index*">
										<label for="apply*index*"></label>
									</a>
								</td>
								<td>
									<div class="sel-calendar"><input type="text" id="requestedDate*index*" name="requestedDate*index*" class="sel fromDate" value="*selectedReqDate*" autocomplete="off" placeholder="선택"></div>
								</td>
								<td>
									<div class="sa-select">
										<div class="dropdown placeholder">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="*purposeTitle*" data-value="*purposeVal*">*purposeTitle*<span class="caret"></span></button>
											<ul id="purposeList*index*" class="purpose-list dropdown-menu" role="menu">
												<li data-value="0"><a href="#" tabindex="-1">관리운영비</a></li>
												<li data-value="1"><a href="#" tabindex="-1">사무수탁비</a></li>
												<li data-value="9"><a href="#" tabindex="-1">공사비</a></li>
												<li data-value="10"><a href="#" tabindex="-1">임대료</a></li>
												<li data-value="11"><a href="#" tabindex="-1">대납금</a></li>
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
									<div class="text-input-type"><!--
									--><input type="text" id="transferAmount*index*" class="amount right" name="transfer_amount" value="*reqAmount*" placeholder="직접 입력" maxlength="18"><!--
								--></div><!--
							--></td>
								<td>
									<div class="sa-select">
										<div class="dropdown placeholder" id="receiveDropDown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-acc-holder="*accHolder*" data-name="*bankName*" data-value="*accNum*">*bankName*  *accNum* (*accHolder*)<span class="caret"></span></button>
												<ul id="receiveList*index*" class="receive-list dropdown-menu" role="menu"></ul>
										</div>
									</div>
									<div class="sa-select w-50 hidden">
										<div class="dropdown placeholder">
											<button type="button" class="dropdown-toggle" data-clone="empty" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
											<ul id="bankList" class="bank-list dropdown-menu" role="menu"></ul>
										</div>
									</div><!--
								--><div class="text-input-type hidden"><!--
									--><input type="text" id="accountNo" class="right" name="accountNo" placeholder="계좌번호" maxlength="18"><!--
								--></div><!--
							--></td>
								<td>
									<div class="text-input-type"><input type="text" id="note*index*" name="note*index*" value="*desc*" placeholder="직접 입력"></div>
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
				<div class="btn-wrap-type">
					<div class="fl"><!--
					--><small class="hidden warning">출금 요청 정보를 기입해 주세요.</small><!--
				--></div><!--
				--><button type="button" id="deleteRowBtn" class="btn-type07">선택 삭제</button><!--
				--><button type="button" id="addRowBtn" class="btn-text-blue">열 추가</button><!--
			--></div>
			</div>
			<div class="indiv mt25">
				<div class="spc-table-row">
					<table id="secondTable">
						<colgroup>
							<col style="width:15%">
							<col style="width:85%">
							<col>
						</colgroup>
						<tr>
							<th class="th_type">증빙 첨부</th>
							<td id="addFileList" class="flex-start-td"><!--
								--><input type="file" name="file" id="fileInput" class="btn-upload hidden stand-alone" accept=".pdf" multiple><!--
								--><label for="fileInput" class="btn file-upload">파일 선택</label><!--
								--><div class="file_list ml-16"><ul><li>선택된 파일이 없습니다.</li></ul></div>
							</td>
							<td></td>
						</tr>
					</table>
				</div>

				<div class="btn-wrap-type05"><!--
				--><button type="button" onclick="location.href='/spc/transactionHistory.do'" class="btn btn-type03 w80 mr-12">목록</button><!--
				--><button type="submit" class="btn btn-type">제출</button><!--
			--></div>
			</div>
		</div>
	</div>
</form>
