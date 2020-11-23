<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	$(function() {
		const withdrawForm = $('#withdrawForm');
		const spcList = $('#spcList');
		const withdrawList = $('#withdrawList');
		const tableBody = $("#tableBody");
		const purposeList = $("#purposeList");
		const receiveList = $("#receiveList");
		const firstRow = tableBody.find("tr:first-child")
		const dropdownOpt = withdrawForm.find('.dropdown-menu:not(.chk-type)');
		const cloned = spcList.clone().html();
		const copyWithdrawList = $("#withdrawList").clone().html();
		const copyReceiveList = $("#receiveList").clone().html();
		const copyPurposeList = $("#purposeList").clone().html();
		const copyBankList = $("#bankList").clone().html();
		let fileList = [];
		// let uploadForm = $("#uploadForm")[0];
		let totalAmount = 0;

		spcList.empty();
		withdrawList.empty();
		receiveList.empty();
		purposeList.empty();

		unCheckAll(tableBody);
		getSpcList();
		calcTotal();
		bankProperties();
		$("#total").val(totalAmount);

		$("#requestedDate").change(function(){
			let val = $(this).val();
			let d = $("#tableBody").find(".fromDate");
			d.each(function(){
				$(this).val(val);
			});
		});

		$("#fileInput").change(function() {
			let fieldName = genUuid();
			for(let i = 0, fileLength = $(this)[0].files.length; i < fileLength; i++) {
				let fieldName = genUuid();
				uploadFile('post', $(this)[0].files[i], fieldName);
			}

			$('#fileInput').val('');
		});

		let purposeArr = [
			{ name: "관리운영비", val: 0 },
			{ name: "사무수탁비", val: 1 },
			{ name: "부채상환", val: 2 },
			{ name: "공사비", val: 9 },
			{ name: "임대료", val: 10 },
			{ name: "대납금", val: 11 },
			{ name: "대수선비", val: 3 },
			{ name: "배당금 적립", val: 4 },
			{ name: "일반 지출", val: 5 },
			{ name: "DSRA 적립", val: 6 },
			{ name: "기타", val: 7 },
			{ name: "운영계좌", val: 8 },
		];
		// let purposeArr = [
		// 	{ name: "REC 수익", val: 0 },
		// 	{ name: "SMP 수익", val: 1 },
		// 	{ name: "DSRA 적립", val: 2 },
		// 	{ name: "유보 계좌", val: 3 },
		// 	{ name: "운영 계좌", val: 4 },
		// 	{ name: "기타", val: 5 },
		// ];
		for(let i=0; i<purposeArr.length; i++){
			let str = copyPurposeList.replace(/\*purposeTitle\*/g, purposeArr[i].name).replace(/\*purposeValue\*/g, purposeArr[i].val);
			purposeList.append($(str));
		}

		purposeList.find("li a").on("click", function(){
			let val = $(this).parent().data("value");
			purposeList.prev().data("value", val);
		});

		function getAmount() {
			const spcId = $('#spcList').prev().data('value');
			const account = $('#withdrawList').prev().data('value').replace(/[^\d]/g, '');

			if (!isEmpty(spcId) && !isEmpty(account)) {
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

		function getSpcList() {
			let action = 'get';
			let syncOpt = true;
			let option = {
				url: apiHost + "/spcs?oid="+oid,
				type: action,
				async: syncOpt
			}

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				spcList.empty();
				(json.data).sortOn('name');
				json.data.forEach((item, index) => {
					let listItem = '';
					if(item.name == ""){
						listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, "spc_noName"+ '_' + index);
					} else {
						listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, item.name);
					}
					spcList.append($(listItem));
				});
				spcList.find("li a").on("click", function(){
					let val = $(this).parent().data("value");
					$("#spcList").prev().data("value", val);
					$("#withdrawList").prev().html('선택<span class="caret">');
					$("#withdrawList").empty();
					getAccountInfo(val);
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		function getAccountInfo (id) {
			if (isEmpty(id)) return false;
			let action = 'get';
			let syncOpt = true;
			let option= {
				url: apiHost + '/spcs/' + id + '?oid=' + oid + "&includeGens=true",
				type: action,
				async: syncOpt
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				let sending = '';
				let receiving = '';
				console.log("json--", json.data[0].spcGens)
				if (json.data[0].spcGens && json.data[0].spcGens.length > 0 ) {
					let gensInfo = json.data[0].spcGens;
					var tempArr = [];
					var promises = [];

					$.each(gensInfo, function(index, element){
						promises.push(Promise.resolve(JSON.parse(element.finance_info)));
						// promises.push(resolve(JSON.parse(element)));
					});
					Promise.all(promises).then(res => {
						$(".receive-list").empty();
						$(".receive-list").prev().html('선택<span class="caret">');

						// mergeArr(result)
						res.map(x => {
							// console.log("x===", x)
							Object.entries(x).map((item, index) => {
								const strAccType = "입출금_구분";
								const strAccNum = "계좌_번호";
								const bankName = "은행_리스트";
								const accHolder = "예금주";

								if(item[0].match(strAccType)){
									let n = item[0].replace(strAccType, '');
									let myObj = {};
									console.log("item=====", item)
									myObj.accCategory = item[0];
									myObj.accType = item[1];
									myObj.accNum = x[strAccNum+n];
									myObj.bankName = x[bankName+n];
									myObj.accHolder = x[accHolder+n];
									tempArr.push(myObj);
								}

							});
						});
						// console.log("tempArr---", tempArr)
					}).then(() => {
						const filteredArr = tempArr.reduce((acc, current) => {
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
						}, []);
						
						filteredArr.map(v => {
							let sending = '';
							let receiving = '';
							let bankName = '';
							let accNum = '';
							let accHolder = '';
							if(v.accType.match("출금")){
								accNum = v.accNum;
								accHolder = v.accHolder;
								bankName = v.bankName;
								sending = copyWithdrawList.replace(/\*bank_name\*/g, bankName).replace(/\*acc_num\*/g, accNum).replace(/\*acc_holder\*/g, accHolder);
								withdrawList.append($(sending));
							} else {
								bankName = v.bankName;
								accNum = v.accNum;
								accHolder = v.accHolder;
								receiving = copyReceiveList.replace(/\*to_acc_type\*/g, v.accType).replace(/\*to_bank_name\*/g, bankName).replace(/\*to_account_no\*/g, accNum).replace(/\*acc_holder\*/g, accHolder);
								$(".receive-list").each(function(){
									$(this).append($(receiving));
								});
							}
						});
					}).finally(() => {
						$(".receive-list").append(`<li data-value="직접입력"><a href="#" tabindex="-1">직접입력</a></li>`);
					});
				} else {
					sending = copyWithdrawList.replace(/\*bank_name\*/g, '등록 계좌 없음').replace(/\*acc_num\*/g,'').replace(/\*acc_holder\*/g, '');
					receiving = copyReceiveList.replace(/\*to_acc_type\*/g, '등록된 입금 계좌가 없습니다.').replace(/\*to_bank_name\*/g, '등록 계좌 없음').replace(/\*to_account_no\*/g, '').replace(/\*acc_holder\*/g, '');
					withdrawList.append($(sending));
					receiveList.append($(receiving));
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
			setTimeout(function(){
				withdrawList.find("li").on("click", function(){
					withdrawList.prev().data({"value": $(this).data("value"), "name": $(this).data("name"), "acc-holder" : $(this).data("acc-holder") });
					getAmount();
				});
				receiveList.find("li").on("click", function(){
					receiveList.prev().data({"value": $(this).data("value"), "name": $(this).data("name") });
				});
			}, 300);
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
			jsonData.spc_id = spcList.prev().data("value");
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
				let purposeOpt = $elm.find('td:nth-of-type(3) .dropdown-toggle');
				let amountOpt = $elm.find('td:nth-of-type(4) input');
				let accOpt = $elm.find('td:nth-of-type(5) .dropdown-toggle').eq(0);
				let accOpt2 = $elm.find('td:nth-of-type(5) .dropdown-toggle').eq(1);
				let accNo = $elm.find('td:nth-of-type(5) input');
				let descOpt = $elm.find('td:nth-of-type(6) input');
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
			jsonData.total_amount = totalAmount;
			jsonData.to_account = JSON.stringify(arr);
			// console.log("json--", jsonData);
			let newJson = JSON.stringify(jsonData);
			let formArr = [ jsonData.spc_id, jsonData.withdraw_bank, jsonData.withdraw_day, arr ];

			var flagArr = [];
			flagArr.length = 0;

			$.each(formArr, function(index, value){
				if(index < 2) {
					if(value == undefined ||  value == "선택" || value == "") {
						warning.eq(index).removeClass('hidden');
						console.log("warning---", )
					} else {
						warning.eq(index).addClass('hidden');
					}
				} else if( index == 3) {
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
						warning.eq(2).removeClass('hidden');
					} else {
						warning.eq(2).addClass('hidden');
					}
				}
			});
			if(flagArr.length > 0){
				warning.eq(2).removeClass('hidden');
			} else {
				warning.eq(2).addClass('hidden');
			}

			if( withdrawForm.find(".warning.hidden").length == 4 ){
				let opt = {
					url: apiHost + '/spcs/transactions?oid='+oid,
					type: "POST",
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(jsonData)
				};

				$.ajax(opt).done(function (json, textStatus, jqXHR) {
					window.location.href = window.location.origin + '/spc/transactionHistory.do'
				}).fail(function (jqXHR, textStatus, errorThrown) {
					alert('처리 중 오류가 발생했습니다.');
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});
			} else {
				console.log("warning length===" )
			}
		});

		function uploadFile(action, file, filedName){
			let formData = new FormData($('#fileUploadForm')[0]);
			formData.append(filedName, file);
			console.log(file);

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
						let temp = copyBankList.replace(/\*code\*/g, propName).replace(/\*bankName\*/g, propName);
						$('.bank-list').append(temp);
					});
				} else {
					$('.bank-list').append(copyBankList.replace(/\*code\*/g, '').replace(/\*bankName\*/g, '조회된 은행이 없습니다.'));
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});
		}
	});

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
		<h1 class="page-header">출금 요청서 신청</h1>
	</div>
</div>

<form id="fileUploadForm" name="fileUploadForm"></form>
<form id="withdrawForm" name="withdraw_form" action="#" method="post">
	<div class="row spc-search-bar">
		<div class="col-12">
			<div class="sa-select"><!--
			--><span class="tx-tit">SPC 선택</span><!--
			--><div class="dropdown"><!--
				--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택" data-value="">선택<span class="caret"></span></button><!--
				--><ul id="spcList" class="dropdown-menu unused center" role="menu"><li id="*spcName*" data-value="*spcId*"><a href="javascript:void(0);" tabindex="-1">*spcName*</a></li></ul><!--
				--><small class="hidden warning">SPC를 선택해 주세요.</small>
				</div>
			</div>
			<div class="sa-select"><!--
			--><span class="tx-tit">출금 계좌번호</span><!--
			--><div class="dropdown"><!--
				--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택" data-value="">선택<span class="caret"></span></button>
					<ul id="withdrawList" class="dropdown-menu unused center" role="menu"><li data-acc-holder="*acc_holder*" data-name="*bank_name*" data-value="*acc_num*"><a href="#" tabindex="-1">*bank_name* *acc_num*</a></li></ul>
					<small class="hidden warning">출금 요청 계좌를 선택해 주세요.</small>
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
						<tr>
							<td>
								<a class="chk-type select_row">
									<input type="checkbox" id="apply" name="apply">
									<label for="apply"></label>
								</a>
							</td>
							<td>
								<div class="sel-calendar"><input type="text" id="requestedDate" name="requestedDate" class="sel fromDate" value="" autocomplete="off" placeholder="선택"></div>
							</td>
							<td>
								<div class="sa-select">
									<div class="dropdown placeholder">
										<button type="button" class="dropdown-toggle" data-clone="empty" data-toggle="dropdown" data-name="" data-value="">선택<span class="caret"></span></button>
										<ul id="purposeList" class="dropdown-menu" role="menu">
											<li data-value="*purposeValue*"><a href="#" tabindex="-1">*purposeTitle*</a></li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="text-input-type"><!--
								--><input type="text" id="transferAmount" class="amount right" name="transfer_amount" placeholder="직접 입력" maxlength="18"><!--
							--></div><!--
						--></td>
							<td>
								<div class="sa-select">
									<div class="dropdown placeholder" id="receiveDropDown">
										<button type="button" class="dropdown-toggle" data-clone="empty" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
										<ul id="receiveList" class="receive-list dropdown-menu" role="menu"><li data-acc-holder="*acc_holder*" data-acc-type="*to_acc_type*" data-name="*to_bank_name*" data-value="*to_account_no*"><a href="#" tabindex="-1">*to_bank_name* *to_account_no* (*acc_holder*)</a></li></ul>
									</div>
								</div>
								<div class="sa-select hidden">
									<div class="dropdown placeholder">
										<button type="button" class="dropdown-toggle" data-clone="empty" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
										<ul id="bankList" class="bank-list dropdown-menu" role="menu"><li data-value="*code*"><a href="#" tabindex="-1">*bankName*</a></li></ul>
									</div>
								</div><!--
							--><div class="text-input-type hidden"><!--
								--><input type="text" id="accountNo" class="center" name="accountNo" placeholder="계좌번호" maxlength="18"><!--
							--></div><!--
						--></td>
							<td>
								<div class="text-input-type"><input type="text" id="note" name="note" placeholder="직접 입력"></div>
							</td>
						</tr>
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
					--><small class="hidden warning">테이블의 출금 요청 정보를 모두 기입해 주세요.</small><!--
					--><small class="hidden warning">출금 요청 정보를 기입해 주세요.</small><!--
				--></div><!--
				--><button type="button" id="deleteRowBtn" class="btn-type07">선택 삭제</button><!--
				--><button type="button" id="addRowBtn" class="btn-text-blue">열 추가</button><!--
			--></div>
			</div>
			<div class="indiv mt-25">
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
				--><button type="button" onclick="location.href='/spc/transactionCalendar.do'" class="btn btn-type03 w-80px mr-12">목록</button><!--
				--><button type="submit" class="btn btn-type">제출</button><!--
			--></div>
			</div>
		</div>
	</div>
</form>
