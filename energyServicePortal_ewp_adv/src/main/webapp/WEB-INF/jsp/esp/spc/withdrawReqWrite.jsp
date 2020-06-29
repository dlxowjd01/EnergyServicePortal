<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="/js/commonDropdown.js"></script>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
		// setInitList("listData"); //리스트초기화

		// getDataList(page);
		const fistTable = $("#firstTable");
		const deleteBtn = $("#deleteBtn");
		const checkBoxes = $(firstTable).find('.select_row input[type="checkbox"]');
		
		unCheckAll();

		deleteBtn.on("click", function (){
			checkBoxes.each(function(){
				if($(this).prop("checked")){
					$(this).closest("tr").remove();
				} else {
					return
				}
			});
		})
	});

	$(document).on('keyup', '#key_word', function(e) {
		if (e.keyCode == 13) {
			getDataList(page);
		}
	})

	function nvl(value, str) {
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
	function getNumberIndex(index) {
		return index + 1;
	}

	function getDataList(page) {
		if(page == undefined){
			page = 1;
		}
		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs",
			type: "get",
			async: false,
			data: {
				"oid": oid,
				includeGens: true
			},
			success: function(result) {
				var jsonList = [],
					keyWord = $("#key_word").val().trim().toLowerCase();

				for (var i = 0, count = result.data.length; i < count; i++) {

					var spcGensList = result.data[i].spcGens;

					if (spcGensList !== undefined && spcGensList.length > 0) {

						for (var j = 0, jcount = spcGensList.length; j < jcount; j++) {
							var spcGensRow = spcGensList[j],
								rowData = result.data[i],
								newData = {},
								contractInfo = JSON.parse(spcGensRow.contract_info),
								deviceInfo = JSON.parse(spcGensRow.device_info),
								originFile = new Array();

							$.ajax({
								url: "http://iderms.enertalk.com:8443/spcs/" + rowData.spc_id + "/gens/" + spcGensRow.gen_id + "/supplement?oid=" + rowData.oid,
								type: "get",
								dataType: 'json',
								async: false,
								contentType: "application/json",
								success: function(json) {

									if (isEmpty(json.data[0])) {
										newData["파일_총_개수"] = '-';
										newData["파일_현재_개수"] = '-';
										newData["첨부파일"] = '-';
									} else {
										newData["파일_총_개수"] = json.data[0].file_count_all;
										newData["파일_현재_개수"] = json.data[0].file_count_now;
										newData["첨부파일"] = json.data[0].file_count_now;
										
										var supplementInfo = JSON.parse(json.data[0].supplement_info)
										var keys = Object.keys(supplementInfo);
										for ( var i in keys ) {
											if ( keys[i] != 'null' ) {
												if ( keys[i].substring(keys[i].length-12, keys[i].length) == 'originalName' && supplementInfo[keys[i]] != '') {
													originFile.push(supplementInfo[keys[i]]);
												}
											}
										}
									}

								},
								error: function(request, status, error) {
									alert('처리 중 오류가 발생했습니다.');
									return false;
								}
							});

							newData["name"] = rowData.name;
							newData["oid"] = rowData.oid;
							newData["spc_id"] = rowData.spc_id;
							newData["gen_id"] = spcGensRow.gen_id;
							newData["발전소_명"] = spcGensRow.name;
							newData["관리_운영_기간"] = nvl(contractInfo["관리_운영_기간"], "-");
							newData["설치_용량"] = nvl(contractInfo["설치_용량"], "-");
							//키워드 검색 조건 필터 처리
							if (newData["name"].toLowerCase().indexOf(keyWord) > -1 || newData["발전소_명"].toLowerCase().indexOf(keyWord) > -1) {
								jsonList.push(newData)
							} else {
								$.each(originFile, function(k,v){
									if (v.toLowerCase().indexOf(keyWord) > -1) {
										jsonList.push(newData);
									}
								});
							}
							
						}

					}

				}
				jsonList = paging(page, jsonList);
				setMakeList(jsonList, "listData", {
					"dataFunction": {
						"INDEX": getNumberIndex
					}
				}); //list생성

			},
			error: function(request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}
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

<div class="row spc_search_bar">
	<div class="col-12"><!--
	--><span class="tx_tit">SPC 선택</span><!--
	 --><div class="sa_select mr-16">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체 <span class="caret"></span></button>
				<ul class="dropdown-menu">
					<li data-value="spc1"><a href="#" tabindex="-1">SPC1</a></li>
					<li data-value="spc2"><a href="#" tabindex="-1">SPC2</a></li>
					<li data-value="spc3"><a href="#" tabindex="-1">SPC3</a></li>
				</ul>
			</div>
		</div>
		
		<span class="tx_tit ml-12">출금 계좌번호</span>
		<div class="sa_select">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체 <span class="caret"></span></button>
				<ul class="dropdown-menu" role="menu">
					<li data-value="kb"><a href="#" tabindex="-1">KB 120-634348-12-339</a></li>
					<li data-value="ibk"><a href="#" tabindex="-1">기업 650-665568-12-339</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper spc_transaction">
	<div class="col-12">
		<div class="indiv collapse" id="searchOption">
			<div class="spc_tbl">
				<table class="sort_table chk_type">
					<thead>
						<tr>
							<th>
								<strong>조회 기간</strong>
							</th>
							<th><button class="btn_align down">선택</button></th>
							<th><button class="btn_align down">상태</button></th>
							<th><button class="btn_align down">승인 대기, 승인 중</button></th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td><stron>단위</stron></td>
							<td>선택</td>
							<td>계좌 구분</td>
							<td class="right">선택</td>
						</tr>
						<tr>
							<td><strong>입출금 구분</strong></td>
							<td>계좌 구분</td>
							<td>계좌 구분</td>
							<td class="right">선택</td>
						</tr>
					</tbody>
				</table>
				<button class="btn_type fr" onclick="getDataList();">조회</button>
			</div>
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
				<tbody id="firstTable">
					<tr>
						<td>
							<a class="chk_type select_row">
								<input type="checkbox" id="chk02" name="chk02">
								<label for="chk02"></label>
							</a>
						</td>
						<td>
							<div class="sel_calendar"><input type="text" id="enforce_1" name="enforce_1" class="sel fromDate" value="" autocomplete="off" readonly placeholder="선택"></div>
						</td>
						<td>
							<div class="sa_select">
								<div class="dropdown placeholder" id="spc">
									<button class="btn btn-primary dropdown-toggle" type="button"
											data-toggle="dropdown">선택
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk_type" role="menu">
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="accountNum1" value="accountTypes1" name="accountTypes">
												<label for="accountNum1">관리 운영비</label>
											</a>
										</li>
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="accountNum2" value="accountTypes2" name="accountTypes">
												<label for="accountNum2">사무 수탁비</label>
											</a>
										</li>
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="accountTypes3" value="accountTypes3" name="accountTypes">
												<label for="accountTypes3">기타</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</td>
						<td>
							<div class="tx_inp_type">
								<input type="text" id="interestRate_1" name="interestRate_1" placeholder="직접 입력">
							</div>
						</td>
						<td>
							<div class="sa_select">
								<div class="dropdown placeholder" id="spc">
									<button class="btn btn-primary dropdown-toggle" type="button"
											data-toggle="dropdown">KB 120-634348-12-339
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-value="accountNum"><a href="#" tabindex="-1">신한 650-665568-12-339</a></li>
										<li data-value="accountNum"><a href="#" tabindex="-1">KB 650-665568-12-339</a></li>
									</ul>
								</div>
							</div>
						</td>
						<td>
							<div class="tx_inp_type"><input type="text" id="interestRate_1" name="interestRate_1" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<td>
							<a href="#" class="chk_type select_row"><input type="checkbox" id="chk01" name="chk01"><label for="chk01"></label></a>
						</td>
						<td>
							<div class="sel_calendar">
								<input type="text" id="enforce_1" name="enforce_1" class="sel fromDate" value="" autocomplete="off" readonly placeholder="선택">
							</div>
						</td>
						<td>
							<div class="sa_select">
								<div class="dropdown placeholder" id="spc">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu chk_type" role="menu">
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="accountNum1" value="accountTypes1" name="accountTypes">
												<label for="accountNum1">관리 운영비</label>
											</a>
										</li>
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="accountNum2" value="accountTypes2" name="accountTypes">
												<label for="accountNum2">사무 수탁비</label>
											</a>
										</li>
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="accountTypes3" value="accountTypes3" name="accountTypes">
												<label for="accountTypes3">기타</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</td>
						<td>
							<div class="tx_inp_type">
								<input type="text" id="interestRate_1" name="interestRate_1" placeholder="직접 입력">
							</div>
						</td>
						<td>
							<div class="sa_select">
								<div class="dropdown placeholder" id="spc">
									<button class="btn btn-primary dropdown-toggle" type="button"
											data-toggle="dropdown">기업 650-665568-12-339
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk_type" role="menu">
										<li>
											<a class="chk_group" href="#" tabindex="-1">
												<input type="checkbox" id="accountNum3" value="accountNum3" name="accountNum3">
												<label for="accountNum3">신한 650-665568-12-339</label>
											</a>
										</li>
										<li>
											<a class="chk_group" href="#" tabindex="-1">
												<input type="checkbox" id="accountNum4" value="accountNum4" name="accountNum4">
												<label for="accountNum4">KB 650-665568-12-339</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</td>
						<td>
							<div class="tx_inp_type">
								<input type="text" id="interestRate_1" name="interestRate_1" placeholder="직접 입력">
							</div>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td></td>
						<td>합계</td>
						<td></td>
						<td>100,000,000</td>
						<td colspan="2"></td>
					</tr>
				</tfoot>
			</table>
			<div class="btn_wrap_type">
				<a href="#;" class="btn_type07" id="deleteBtn">선택 삭제</a>
				<a href="javascript:void(0);" class="btn_add"
					onclick="addRowTable('firstTable'); return false;">열 추가</a>
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
					--><input type="checkbox" id="chk02" name="chk02"><!--
					--><label for="chk02">증빙 첨부 포함</label><!--
				--></a><!--
				--><a href="/spc/transactionHistory.do" class="btn btn_type03 mr-12" id="writeBtn">PDF</a><!--
				--><a href="/spc/transactionHistory.do" class="btn btn_type03 mr-12" id="writeBtn">EXCEL</a><!--
				--><a href="/spc/withdrawReqWrite.do" class="btn btn_type" id="requestBtn">제출</a><!--
		--></div>
		</div>
	</div>
</div>