<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script src="/js/commonDropdown.js"></script>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';

	$(function() {
		const withdrawForm = $('#withdrawForm');
		const spcList = $('#spcList');
		const withdrawList = $('#withdrawList');
		const tableBody = $("#tableBody");
		const purposeList = $("#purposeList");
		const receiveList = $("#receiveList");
		const firstRow = tableBody.find("tr:first-child")
		const dropdownOpt = withdrawForm.find('.dropdown-menu:not(.chk_type)');
		const cloned = spcList.clone().html();
		const copyWithdrawList = $("#withdrawList").clone().html();
		const copyReceiveList = $("#receiveList").clone().html();
		const copyPurposeList = $("#purposeList").clone().html();

		spcList.empty();
		withdrawList.empty();
		receiveList.empty();
		purposeList.empty();

		unCheckAll(tableBody);
		getSpcList();
		
		let pList = [ 
			{ name: "REC 수익", val: 1 },
			{ name: "SMP 수익", val: 1 },
			{ name: "DSRA 적립", val: 1 },
			{ name: "유보 계좌", val: 1 },
			{ name: "운영 계좌", val: 1 },
			{ name: "기타", val: 1 },
		];
		for(let i=0; i<pList.length; i++){
			let str = copyPurposeList.replace(/\*purpose_title\*/g, pList[i].name).replace(/\*purpose_value\*/g, pList[i].val);
			purposeList.append($(str));
		}

		purposeList.find("li a").on("click", function(){
			let val = $(this).parent().data("value");
			purposeList.prev().data("value", val);
		});

		function getSpcList() {
			let action = 'get';
			let syncOpt = true;
			let option = {
				url: "http://iderms.enertalk.com:8443/spcs?oid="+oid,
				type: action,
				async: syncOpt
			}

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				spcList.empty();
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
					console.log("onclick---")
					let val = $(this).parent().data("value");
					$("#spcList").prev().data("value", val);
					$("#withdrawList").empty();
					$("#withdrawList").prev().text().replace(/<[^>]+>/g, '선택');
					getAccountInfo(val);
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		function getAccountInfo (id) {
			$("#receiveList").empty();
			$("#receiveList").prev().text().replace(/<[^>]+>/g, '선택');
			if (id == undefined || id == '') {
				return;
			}
			let action = 'get';
			let syncOpt = true;
			let option= {
				url: 'http://iderms.enertalk.com:8443/spcs/transactions',
				type: action,
				data: {
					'oid' : oid,
					'spcIds' : id
				},
				async: syncOpt
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				let sending = '';
				let receiving = '';
				if (json.data.length > 0) {
					json.data.map(item => {
						let data = json.data;
						// console.log("item===", item)
						sending = copyWithdrawList.replace(/\*withdraw_account\*/g, item.withdraw_account_no).replace(/\*account_num\*/g, item.withdraw_bank);
						withdrawList.append($(sending));
						return new Promise((resolve, reject) => {
							resolve(JSON.parse(item.to_account))
							}).then(res => {
								res.map(d => {
									// console.log('d===000', d);
									receiving = copyReceiveList.replace(/\*to_account_bank_name\*/g, d.to_account_bank).replace(/\*to_account_no\*/g, d.to_account_no);
									receiveList.append($(receiving));
								});
							}).catch(error => {
								console.log(error);
							})
						});
						withdrawList.find("li a").on("click", function(){
							let val = $(this).parent().data("value");
							let name = $(this).parent().data("name");
							withdrawList.prev().data("value", val);
						});
						receiveList.find("li a").on("click", function(){
							let val = $(this).parent().data("value");
							let name = $(this).parent().data("name");
							receiveList.prev().data("value", val);
							receiveList.prev().data("name", name);
						});
				} else {
					sending = copyWithdrawList.replace(/\*withdraw_account\*/g, '등록된 출금 계좌가 없습니다.').replace(/\*account_num\*/g, '');
					receiving = copyReceiveList.replace(/\*to_account_bank_name\*/g, '등록된 입금 계좌가 없습니다.').replace(/\*to_account_no\*/g, '');
					withdrawList.append($(sending));
					receiveList.append($(receiving));
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		withdrawForm.on('submit', function(e){
			console.log("pb===")
			e.preventDefault();
			let warning = withdrawForm.find(".warning");
			let checkboxes = tableBody.find("[type='checkbox']");
			let tr = tableBody.find("tr");
			let jsonData = {}
			let arr =[];
			// data = {
			// 	spc_id: spcList.prev().data("value"),
			// 	withdraw_bank: withdrawList.prev().data("value"),
			// 	withdraw_account_no: withdrawList.prev().text(),
			// 	withdraw_day: $("#requestedDate").val(),
			// 	to_account: "",
			// 	total_amount: 5000000,
			// 	status: 1,
			// 	status_changed_by: loginName,
			// 	status_changed_at: new Date().toISOString(),
			// 	requested_by: 'S-POWER',
			// 	requested_at: '2020-07-04T19:31:04.048Z'
			// }
			jsonData.spc_id = spcList.prev().data("value");
			jsonData.withdraw_bank = withdrawList.prev().data("value");
			jsonData.withdraw_account_no = withdrawList.prev().text();
			jsonData.withdraw_day = $("#requestedDate").val();
			// to
			jsonData.to_account = "";
			jsonData.total_amount = 5000000;
			// status
			jsonData.status = 1;
			jsonData.status_changed_by = loginName;
			jsonData.status_changed_at = new Date().toISOString();
			jsonData.requested_by = loginName;
			jsonData.requested_at = new Date().toISOString();

			// console.log("w---", data.to_account)
			checkboxes.each(function(index, element){
				if($(this).is(":checked")) {
					let purposeOpt = $("#tableBody").find("td:nth-of-type(3) .dropdown-toggle");
					let amountOpt = $("#tableBody").find("td:nth-of-type(4) input");
					let accOpt = $("#tableBody").find("td:nth-of-type(5) .dropdown-toggle");
					let descOpt = $("#tableBody").find("td:nth-of-type(6) input[name='note']");
					let obj = {};
					obj.purpose = purposeOpt.eq(index).data("value");
					obj.amount = Number(amountOpt.eq(index).val());
					obj.to_account_bank = accOpt.eq(index).data("name");
					obj.to_account_no = accOpt.eq(index).data("value");
						// desc: descOpt.eq(index).val(),
					arr.push(obj);
				}
			});
			jsonData.to_account = arr;
			// let formArr = [ data.spc_id, data.withdraw_bank, data.withdraw_day, data.to_account ];

			// $.each(formArr, function(index, value){
			// 	if($('input[type="checkbox"]:checked').length > 0) {
			// 		if(index < 2) {
			// 			if(value == undefined ||  value == "선택" || value == "") {
			// 				warning.eq(index).removeClass('hidden');
			// 				console.log("warning---", )
			// 			} else {
			// 				warning.eq(index).addClass('hidden');
			// 			}
			// 		} else {
			// 			if(value == undefined ||  value == "선택" || value == "") {
			// 				warning.eq(2).removeClass('hidden');
			// 			} else {
			// 				warning.eq(2).addClass('hidden');
			// 			}
			// 		}
			// 	} else {
			// 		warning.eq(2).removeClass('hidden');
			// 	}
			// });

			let newObj = {
				"spc_id": 24,
				"withdraw_bank": "우체국",
				"withdraw_account_no": "출금계좌번호",
				"withdraw_day": "20200703",
				"total_amount": 30000,
				"to_account": "[{\"purpose\":1,\"amount\":10000,\"to_account_bank\":\"기업\",\"to_account_no\":\"123-123-123\",\"desc\":\"테스트계좌1\"},{\"purpose\":1,\"amount\":20000,\"to_account_bank\":\"국민\",\"to_account_no\":\"000-000-000\",\"desc\":\"테스트계좌2\"}]",

				"status": 1,
				"status_changed_by": "string",
				"status_changed_at": "2020-07-03T10:42:17.400Z",
				"requested_by": "string",
				"requested_at": "2020-07-03T10:42:17.400Z",
				"transfer_agent": "string"
			}
			let newJson = JSON.stringify(jsonData);
			if( withdrawForm.find(".warning.hidden").length == 4){
				let opt = {
					url: 'http://iderms.enertalk.com:8443/spcs/transactions?oid='+oid,
					type: 'post',
					async: true,
					data: newJson
				};
				console.log("newJson===", newJson );
				$.ajax(opt).done(function (json, textStatus, jqXHR) {
					window.location.href = window.location.origin + '/spc/transactionHistory.do'
				}).fail(function (jqXHR, textStatus, errorThrown) {
					alert('처리 중 오류가 발생했습니다.');
					return false;
				});
				// getDataList(1,formArr); 
			} else {
				// console.log("warning length===", withdrawForm.find(".warning.hidden') )
			}
		// getDataList(1); 
		});


		// amount number trim event
		$(".auto-update").each(function() {
			let sum = '';
			$(this).on('keypress', function(e) {
				if (e.which == "0".charCodeAt(0) && $(this).val().trim() == "") {
					return false;
				}
			});
			$(this).on('keyup', function() {
				this.value = this.value.replace(/\D/gi, '');
			});
			// tableBody.find(".auto-update").on("input", function(){
			// 	$(this).each(function(){
			// 		sum += $(this).val();
			// 	})
			// 	// $("#total").text(sum.replace(/\D/gi, ''));
			// });
		});

		$("#addRowBtn").on("click", function(){
			addCustomRow(tableBody, 'first');
		});

		$("#deleteRowBtn").on("click", function(){
			let checkboxes = tableBody.find("input[type='checkbox']");
			checkboxes.each(function(index, element){
				if($(this).is(":checked") && index>0){
					$("#tableBody").find("tr").eq(index).remove();
				}
			});
		});

		// function nvl (value, str) {
		// 	if (isEmpty(value)) {
		// 		return str;
		// 	} else {
		// 		return value;
		// 	}
		// }

		// function getCsvDown() {
		// 	var column = ["name", "발전소_명", "설치_용량", "관리_운영_기간", "", ""], //json Key
		// 		header = ["SPC명", "발전소 명", "용량", "관리 운영기간	", "이관자료", "첨부파일"]; //csv 파일 헤더

		// 	getJsonCsvDownload($("#listData").data("gridJsonData"), column, header, "spc_spower.csv"); // json list, 컬럼, 헤더명, 파일명
		// }

		function getNumberIndex (index) {
			return index + 1;
		}

	});


</script>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 신청</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>

<form id="withdrawForm" name="withdraw_form" action="#" method="post">
	<div class="row spc-search-bar">
		<div class="col-11">
			<div class="sa_select"><!--
			--><span class="tx_tit">SPC 선택</span><!--
			--><div class="dropdown"><!--
				--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택" data-value="">선택<span class="caret"></span></button>
					<ul id="spcList" class="dropdown-menu unused center" role="menu"><li id="*spcName*" data-value="*spcId*"><a href="javascript:void(0);" tabindex="-1">*spcName*</a></li></ul>
					<small class="hidden warning">SPC를 선택해 주세요.</small>
				</div>
			</div>
			<div class="sa_select"><!--
			--><span class="tx_tit">출금 계좌번호</span><!--
			--><div class="dropdown"><!--
				--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택" data-value="">선택<span class="caret"></span></button>
					<ul id="withdrawList" class="dropdown-menu unused center" role="menu"><li data-value="*account_num*"><a href="#" tabindex="-1">*withdraw_account*</a></li></ul>
					<small class="hidden warning">출금 요청 계좌를 선택해 주세요.</small>
				</div>
			</div>
			<div class="sa_select"><!--
			--><label for="availableAmount" class="tx_tit">계좌 잔액</label><!--
			--><div class="tx_inp_type"><input type="text" id="" name="availableAmount" disabled="" readonly=""></div>
			</div>
		</div>
		<div class="col-1">
			<div class="fr"><a href="#;" class="save_btn">엑셀 다운로드</a></div>
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
						<th></th>
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
								<a class="chk_type select_row">
									<input type="checkbox" id="apply" name="apply">
									<label for="apply"></label>
								</a>
							</td>
							<td>
								<div class="sel_calendar"><input type="text" id="requestedDate" name="requestedDate" class="sel fromDate" value="" autocomplete="off" placeholder="선택"></div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="" data-value="">선택<span class="caret"></span></button>
										<ul id="purposeList" class="dropdown-menu" role="menu">
											<li data-value="*purpose_value*"><a href="#" tabindex="-1">*purpose_title*</a></li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type"><!-- 
								--><input type="text" id="transferAmount" class="auto-update right" name="transfer_amount" placeholder="직접 입력"><!--
							--></div><!--
						--></td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
										<ul id="receiveList" class="dropdown-menu" role="menu"><li data-name="*to_account_bank_name*" data-value="*to_account_no*"><a href="#" tabindex="-1">*to_account_bank_name* *to_account_no*</a></li></ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type"><input type="text" id="note" name="note" placeholder="직접 입력"></div>
							</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td></td>
							<td>합계</td>
							<td></td>
							<td id="total" class="total"></td>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				</table>
				<div class="btn_wrap_type">
					<div class="fl"><!--
					--><small class="hidden warning">요청서를 신청하실 체크박스를 선택해 주세요.</small><!--
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
							<td id="addFileList01" class="flex_start_td"><!--
								--><input type="file" id="red_write_attachment" class="hidden" name="red_write_attachment" accept=".gif, .jpg, .png" multiple=""><!--
								--><label for="red_write_attachment" class="btn file_upload">파일 선택</label><!--
								--><div class="file_list ml-16"><ul><li>No Files Selected</li></ul></div>
							</td>
							<td></td>
						</tr>
					</table>
				</div>

				<div class="btn_wrap_type05"><!--
				--><a class="chk_type mr-24"><!--
					--><input type="checkbox" id="file" name="file"><!--
					--><label for="file">증빙 첨부 포함</label><!--
				--></a><!--
				--><button type="button" class="btn btn_type03 mr-12" id="writeBtn">PDF</button><!--
				--><button type="submit" class="btn btn_type">제출</button><!--
			--></div>
			</div>
		</div>
	</div>
</form>