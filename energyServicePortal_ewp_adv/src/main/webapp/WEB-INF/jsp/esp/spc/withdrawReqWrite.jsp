<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script src="/js/commonDropdown.js"></script>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';

	$(function() {
		const withdrawForm = $('#withdrawForm');
		const checkBoxes = withdrawForm.find('input[type="checkbox"]');
		const tableBody = $("#tableBody");
		const firstRow = tableBody.find("tr:first-child")
		const deleteBtn = $("#deleteBtn");
		const dropdownOpt = tableBody.find('.dropdown-menu:not(.chk_type) li');
		const spcList = $('#spcList');
		const cloned = spcList.clone().html();
		const copyWithdrawList = $("#withdrawList").clone().html();
		const copyReceiveList = $("#receiveList").clone().html();
		let sum = 0;

		spcList.empty();
		$("#withdrawList").empty();
		$("#receiveList").empty();

		unCheckAll(tableBody);
		setDropdownValue(dropdownOpt);
		getSpcList();

		deleteBtn.on("click", function (){
			checkBoxes.each(function(index, element){
				if( $(this).is(":checked") ) {
					console.log(element)
				}
			});
		});

		tableBody.find(".auto-update").on("input", function(){
			sum = 0;
			$(this).each(function(){
				sum += $(this).val();
			})
			$("#total").text(sum.replace(/\D/gi, ''));
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
				$('#spcList').find("li a").on("click", function(){
					getWithDrawAccount($(this).parent().val())
				});

			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		// deleteBtn.on("click", function (){
		// 	checkBoxes.each(function(){
		// 		if($(this).prop("checked")){
		// 			$(this).closest("tr").remove();
		// 		} else {
		// 			return
		// 		}
		// 	});
		// });
		function getWithDrawAccount (id) {
			$("#withdrawList").empty();
			$("#receiveList").empty();
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
						console.log("item===", item)
						sending = copyWithdrawList.replace(/\*withdraw_account\*/g, item.withdraw_account_no).replace(/\*account_num\*/g, item.withdraw_bank);
						$("#withdrawList").append($(sending));
						return new Promise((resolve, reject) => {
							resolve(JSON.parse(item.to_account))
							}).then(res => {
								res.map(d => {
									// console.log('d===000', d);
									receiving = copyReceiveList.replace(/\*to_account\*/g, d.to_account_no);
									$("#receiveList").append($(receiving));
								});
							}).catch(error => {
								console.log(error);
							});
						});
				} else {
					console.log("copy---",copyWithdrawList )
					sending = copyWithdrawList.replace(/\*withdraw_account\*/g, '등록된 출금 계좌가 없습니다.').replace(/\*account_num\*/g, '');
					receiving = copyReceiveList.replace(/\*to_account\*/g, '등록된 입금 계좌가 없습니다.');
					$("#withdrawList").append($(sending));
					$("#receiveList").append($(receiving));
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		$(".auto-update").each(function() {
			$(this).on('keyup', function() {
				this.value = this.value.replace(/\D/gi, '');
			});
		});

		
		$("#addRow").on("click", function(){
			addCustomRow(tableBody, 'first');
		});

		withdrawForm.on('submit', function(e){
			e.preventDefault();
			let date = new Date();
			let data = {}
			data.spc_id = $('#spcList').prev().val();
			data.withdraw_bank = $("#withdrawList").find("li").data('value');
			data.withdraw_account_no = $("#withdrawList").prev().val();
			data.withdraw_day = $("#requestedDate").val();
			data.total_amount = sum;
			data.status = "승인 대기";
			data.status_changed_by = "";
			data.status_changed_at = "";
			data.requested_by = loginName;
			data.requested_at = date.getFullYear() + "-" + month + "-" + day + "_" +  hour + ":" + min + ":" + sec;

			warning.addClass('hidden');

			$.each(formArr, function(index, value){
				if(value ==  undefined ||  value == "선택" || value == "" ) {
					warning.eq(index).removeClass('hidden');
				} else {
					warning.eq(index).addClass('hidden');
				}
			});
			if(withdrawForm.find('.warning.hidden').length == formArr.length){
				getDataList(1,formArr); 
			}
			// getDataList(1); 
		});

		function nvl (value, str) {
			if (isEmpty(value)) {
				return str;
			} else {
				return value;
			}
		}

		function getCsvDown() {
			var column = ["name", "발전소_명", "설치_용량", "관리_운영_기간", "", ""], //json Key
				header = ["SPC명", "발전소 명", "용량", "관리 운영기간	", "이관자료", "첨부파일"]; //csv 파일 헤더

			getJsonCsvDownload($("#listData").data("gridJsonData"), column, header, "spc_spower.csv"); // json list, 컬럼, 헤더명, 파일명
		}

		// 아래부터는 기존에 SPC api 호출 시!!!!!!!!!!!!!
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

<form id="withdrawForm" name="withdraw_form">
	<div class="row spc-search-bar">
		<div class="col-11">
			<div class="sa_select"><!--
			--><span class='tx_tit'>SPC 선택</span><!--
			--><div class='dropdown'><!--
				--><button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택" value="">선택<span class='caret'></span></button>
					<ul id='spcList' class='dropdown-menu unused' role='menu'><li id="*spcName*" value="*spcId*"><a href="javascript:void(0);" tabindex="-1">*spcName*</a></li></ul>
					<small class="hidden warning">선택해 주세요.</small>
				</div>
			</div>
			<div class="sa_select"><!--
			--><span class="tx_tit">출금 계좌번호</span><!--
			--><div class="dropdown"><!--
				--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
					<ul id="withdrawList" class="dropdown-menu unused" role="menu"><li data-value="*account_num*"><a href="#" tabindex="-1">*withdraw_account*</a></li></ul>
				</div>
			</div>
			<div class="sa_select"><!--
			--><label for="availableAmount" class="tx_tit">계좌 잔액</label><!--
			--><div class="tx_inp_type"><input type="text" id="" name="availableAmount" disabled='' readonly=''></div>
			</div>
		</div>
		<div class="col-1">
			<div class="fr"><a href="#;" class="save_btn">엑셀 다운로드</a></div>
		</div>
	</div>

	<div class="row content-wrapper spc_transaction">
		<div class="col-12">
			<div class="indiv spc_bal_post">
				<table class="table_footer">
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
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택 <span class="caret"></span></button>
										<ul id="purposeList" class="dropdown-menu" role="menu">
											<li data-value=""><a href="#" tabindex="-1">관리 운영비</a></li>
											<li data-value=""><a href="#" tabindex="-1">사무 수탁비</a></li>
											<li data-value=""><a href="#" tabindex="-1">기타</a></li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="transferAmount" class="auto-update right" name="transfer_amount" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="receiveList" class="dropdown-menu" role="menu"><li data-value="*to_account*"><a href="#" tabindex="-1">*to_account*</a></li></ul>
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
					<button type="button" id="deleteBtn" class="btn_type07" onclick="deleteRow()">선택 삭제</button>
					<button type="button" id="addRow" class="btn-text-blue">열 추가</button>
				</div>
			</div>
			<div class="indiv mt25">
				<form id="attachWithdrawalDocs" name="widthdrawalDocs">
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
				</form>
				<div class="btn_wrap_type05"><!--
					--><a class="chk_type mr-24"><!--
						--><input type="checkbox" id="file" name="file"><!--
						--><label for="file">증빙 첨부 포함</label><!--
					--></a><!--
					--><a href="/spc/transactionHistory.do" class="btn btn_type03 mr-12" id="writeBtn">PDF</a><!--
					--><a href="/spc/withdrawReqWrite.do" class="btn btn_type" id="requestBtn">제출</a><!--
			--></div>
			</div>
		</div>
	</div>
</form>