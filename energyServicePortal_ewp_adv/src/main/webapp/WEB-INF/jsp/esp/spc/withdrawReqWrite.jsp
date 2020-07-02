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
		const deleteBtn = $("#deleteBtn");
		const dropdownOpt = tableBody.find('.dropdown-menu:not(.chk_type) li');

		let syncOpt = true;
		let options = [
			{
				url: "http://iderms.enertalk.com:8443/spcs?oid=" + oid,
				type: 'get',
				async: syncOpt
			},
			{
				url: 'http://iderms.enertalk.com:8443/spcs/transaction?oid=' + oid,
				type: 'post',
				async: syncOpt
			},
		];

		unCheckAll(tableBody);
		setDropdownValue(dropdownOpt);
		setDropdownValue(dropdownOpt);

		getSpcList(options);

		deleteBtn.on("click", function (){
			checkBoxes.each(function(){
				if($(this).prop("checked")){
					$(this).closest("tr").remove();
				} else {
					return
				}
			});
		});
		$("#addRow").on("click", function(){
			addCustomRow(tableBody, 'first');
		});

		withdrawForm.on('submit', function(e){
			e.preventDefault();

			let spcOpts = $('#spcList').find("li");
			let fromDate = $('#fromDate');

			let transactionType = $('#transactionType').parent().find('.dropdown-toggle');

			let formArr = [];

			warning.addClass('hidden');
			formArr.push(spcOpts.val(), fromDate.val(), toDate.val(), spcStatus.val(), unitOpt.val(), transactionType.val(), purpose.val());

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

		function getSpcList(options) {
			const spcList = $('#spcList');
			const cloned = spcList.clone().html();

			$.ajax(options[0]).done(function (json, textStatus, jqXHR) {
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

			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		function getDataList(page) {
			if(page == undefined){
				page = 1;
			}
			$.ajax(options[0]).done(function (json, textStatus, jqXHR) {
				console.log("json===", json)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}


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
		<div class="col-12">
			<div class='sa_select'><!--
			--><span class='tx_tit'>SPC 선택</span><!--
			--><div class='dropdown'>
					<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택" value="">선택<span class='caret'></span></button>
					<ul id='spcList' class='dropdown-menu' role='menu'><li id="*spcName*" value="*spcId*"><a href="javascript:void(0);" tabindex="-1">*spcName*</a></li></ul>
					<small class="hidden warning">선택해 주세요.</small>
				</div>
			</div>

			<div class="sa_select"><!--
			--><span class="tx_tit">출금 계좌번호</span><!--
			--><div class="dropdown">
					<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
					<ul class="dropdown-menu" role="menu"><li data-value=""><a href="#" tabindex="-1">*withdraw*</a></li></ul>
				</div>
			</div>
			<div class="fr">
				<span class="amount">계좌 잔액</span>
			</div>
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
											<li><a href="#" tabindex="-1">관리 운영비</a></li>
											<li><a href="#" tabindex="-1">사무 수탁비</a></li>
											<li><a href="#" tabindex="-1">기타</a></li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="transferAmount" name="transfer_amount" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="toSendList" class="dropdown-menu" role="menu">
											<li><a href="#" tabindex="-1"></a></li>
										</ul>
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
							<td>100,000,000 원</td>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				</table>
				<div class="btn_wrap_type">
					<button type="button" class="btn_type07" id="deleteBtn">선택 삭제</button>
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
					--><a href="/spc/transactionHistory.do" class="btn btn_type03 mr-12" id="writeBtn">EXCEL</a><!--
					--><a href="/spc/withdrawReqWrite.do" class="btn btn_type" id="requestBtn">제출</a><!--
			--></div>
			</div>
		</div>
	</div>
</form>