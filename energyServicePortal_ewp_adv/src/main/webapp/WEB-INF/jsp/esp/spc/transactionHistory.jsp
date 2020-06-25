<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="/js/commonDropdown.js"></script>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
		const checkList = $(".dropdown-menu.chk_type").find("li");

		unCheckAll();
		// setInitList("listData");
		// getDataList(page);
		$("#spcTransactionSearch").on("submit", function(e){
			e.preventDefault();
		});
		checkList.each(function(){
			$(this).on("click", function() {
				let input = $(this).children("input[type='checkbox']");
				$(this).children("label").toggleClass("active");
			});
		});
	});

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

	function getNumberIndex(index) {
		return index + 1;
	}
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">입출금 관리 내역</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>

<div class="row spc_search_bar">
	<div class="col-12">
		<span class="tx_tit">SPC 선택</span><div
			class="sa_select">
			<div class="dropdown" id="spcOpt">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-value="" data-name="">전체<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu">
					<li data-value="allSPC">
						<a href="javascript:void(0)" tabindex="-1">
							<input type="checkbox" id="allSelect" value="all" name="spc_opt">
							<label for="allSelect">전체</label>
						</a>
					</li>
					<li data-value="SPC1">
						<a href="javascript:void(0)" tabindex="-1">
							<input type="checkbox" id="spc1" value="spc1" name="spc_opt">
							<label for="spc1">SPC1</label>
						</a>
					</li>
					<li data-value="SPC2">
						<a href="javascript:void(0)" tabindex="-1">
							<input type="checkbox" id="sp2" value="spc2" name="spc_opt">
							<label for="sp2">SPC2</label>
						</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="dropdown">
			<button type="button" id="collapseBtn" class="btn btn-primary dropdown-toggle no_bg ml-24" data-toggle="collapse" data-target="#searchOption">상세 검색<span class="caret"></span></button>
			<form id="spcTransactionSearch" action="#" method="post">
				<ul id="searchOption" class="collapse dropdown-menu unused">
					<li>
						<div class="bx_row aN2">
							<h2 class="comp_tit">조회 기간</h2>
							<div class="bx_align dropdown">
								<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="" autocomplete="off" placeholder="시작">
							</div>
							<div class="bx_align dropdown">
								<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off" placeholder="종료">
							</div>
						</div>
					</li>
					
					<li>
						<div class="bx_row aN2">
							<h2 class="comp_tit">상태</h2>
							<div class="bx_align dropdown">
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul class="dropdown-menu chk_type dropdown_offset" role="menu">
									<li data-value="allSelect">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="allSelect" value="allSelect" name="approvalStatus">
											<label for="allSelect">전체</label>
										</a>
									</li>
									<li data-value="approved">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="approved" value="approved" name="approvalStatus">
											<label for="approved">승인 완료</label>
										</a>
									</li>
									<li data-value="onHold">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="onHold" value="onHold" name="approvalStatus">
											<label for="onHold">승인 대기</label>
										</a>
									</li>
									<li data-value="inProgress">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="inProgress" value="inProgress" name="approvalStatus">
											<label for="inProgress">승인 중</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</li>
					<li>
						<div class="bx_row aN3">
							<div class="bx_align dropdown">
								<h2 class="comp_tit">단위</h2>
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">단위<span class="caret"></span></button>
								<ul class="dropdown-menu chk_type dropdown_offset" role="menu">
									<li data-value="searchAllTime">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="searchAllTime" value="searchAllTime" name="timeUnit">
											<label for="searchAllTime">전체</label>
										</a>
									</li>
									<li data-value="searchYearly">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="searchYearly" value="year" name="timeUnit">
											<label for="searchYearly">년</label>
										</a>
									</li>
									<li data-value="searchMonthly">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="searchMonthly" value="month" name="timeUnit">
											<label for="searchMonthly">월</label>
										</a>
									</li>
									<li data-value="searchDaily">
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="searchDaily" value="date" name="timeUnit">
											<label for="searchDaily">일</label>
										</a>
									</li>
								</ul>
							</div>
							<div class="bx_align dropdown">
								<h2 class="comp_tit">입출금 구분</h2>
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul class="dropdown-menu dropdown_offset" role="menu">
									<li data-value="deposit"><a href="javascript:void(0)" tabindex="-1">입금</a></li>
									<li data-value="withdraw"><a href="javascript:void(0)" tabindex="-1">출금</a></li>
								</ul>
							</div>
							<div class="bx_align">
								<h2 class="comp_tit">용도 구분</h2>
								<div class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu chk_type dropdown_offset" role="menu">
										<li data-value="allPurpose">
											<a href="javascript:void(0)" tabindex="-1">
												<input type="checkbox" id="allPurpose" value="allPurpose" name="purpose">
												<label for="allPurpose">전체</label>
											</a>
										</li>
										<li data-value="electricitySalesPrice">
											<a href="javascript:void(0)"tabindex="-1">
												<input type="checkbox" id="electricitySalesPrice" value="electricitySalesPrice" name="purpose">
												<label for="electricitySalesPrice">전력판매대금</label>
											</a>
										</li>
										<li data-value="rfcSalesPrice">
											<a href="javascript:void(0)" tabindex="-1">
												<input type="checkbox" id="rfcSalesPrice" value="rfcSalesPrice" name="purpose">
												<label for="rfcSalesPrice">RFC 판매대금</label>
											</a>
										</li>
										<li data-value="operationFee">
											<a href="javascript:void(0)" tabindex="-1">
												<input type="checkbox" id="operationFee" value="operationFee" name="purpose">
												<label for="operationFee">관리운영비</label>
											</a>
										</li>
										<li data-value="rentalFee">
											<a href="javascript:void(0)" tabindex="-1">
												<input type="checkbox" id="rentalFee" value="rentalFee" name="purpose">
												<label for="rentalFee">일반 렌탈</label>
											</a>
										</li>
										<li data-value="commissionFee">
											<a href="javascript:void(0)" tabindex="-1">
												<input type="checkbox" id="commissionFee" value="commissionFee" name="purpose">
												<label for="commissionFee">전력 중개 수수료</label>
											</a>
										</li>
										<li data-value="electricityBill">
											<a href="javascript:void(0)" tabindex="-1">
												<input type="checkbox" id="electricityBill" value="electricityBill" name="purpose">
												<label for="electricityBill">전기 요금</label>
											</a>
										</li>
										<li data-value="principalCap">
											<a href="javascript:void(0)" tabindex="-1">
												<input type="checkbox" id="principalCap" value="principalCap" name="purpose">
												<label for="principalCap">원리금</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</li>
					<li class="btn_wrap_type03 btn_wrap_border">
						<button type="button" data-toggle="collapse" data-target="#searchOption" class="btn_type03" id="closeDropdown">취소</button>
						<button type="submit" class="btn_type ml-6" id="renderBtn">검색</button>
					</li>
				</ul>
			</form>
		</div>
	</div>
</div>

<div class="row spc_transaction">
	<div class="col-12">
		<div class="indiv">
			<div class="spc_tbl">
				<table class="sort_table chk_type table_footer">
					<thead>
						<tr>
							<th><button class="btn_align down">기간</button></th>
							<th><button class="btn_align down">입출금 구분</button></th>
							<th><button class="btn_align down">용도 구분</button></th>
							<th><button class="btn_align down">계좌 구분</button></th>
							<th><button class="btn_align down">금액</button></th>
							<th><button class="btn_align down">최종 업데이트</button></th>
							<th>요청자</th>
							<th>승인자</th>
							<th><button class="btn_align down">상태 </button></th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>2020-04-08</td>
							<td>출금</td>
							<td>원리금</td>
							<td>계좌 구분</td>
							<td>250,000,000 </td>
							<td>2020-05-08 16:43</td>
							<td>TRUST/홍길동</td>
							<td>신한BNPP/이신한</td>
							<td class="left">승인 완료</td>
						</tr>
						<tr>
							<td>2020-04-08</td>
							<td>출금</td>
							<td>원리금</td>
							<td>계좌 구분</td>
							<td>500,000,000 </td>
							<td>2020-05-08 16:43</td>
							<td>TRUST/홍길동</td>
							<td>신한BNPP/이신한</td>
							<td class="left">승인 완료</td>
						</tr>
						<tr>
							<td>2020-04-08</td>
							<td>출금</td>
							<td>원리금</td>
							<td>계좌 구분</td>
							<td>200,000,000 </td>
							<td>2020-05-08 16:43</td>
							<td>TRUST/홍길동</td>
							<td>신한BNPP/이신한</td>
							<td class="left">승인 대기<a href="/spc/withdrawReqEdit.do" class="icon_edit"></a><a href="#" class="icon_delete"></a></td>
						</tr>
						<tr>
							<td>2020-04-08</td>
							<td>출금</td>
							<td>원리금</td>
							<td>계좌 구분</td>
							<td>150,000,000 </td>
							<td>2020-05-08 16:43</td>
							<td>TRUST/김길중</td>
							<td>신한BNPP/이신한</td>
							<td class="left">승인 대기<a href="/spc/withdrawReqEdit.do" class="icon_edit"></a><a href="#" class="icon_delete"></a></td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td>합계</td>
							<td colspan="3"></td>
							<td>1,200,000,000</td>
							<td colspan="4"></td>
						</tr>
					</tfoot>
				</table>
				<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
			</div>
		</div>
	</div>
</div>
