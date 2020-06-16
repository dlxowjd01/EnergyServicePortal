<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
		// setInitList("listData");
		// getDataList(page);

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
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체 <span class="caret"></span></button>
				<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
					<li>
						<a href="#" data-value="INV_PV" tabindex="-1">
							<input type="checkbox" id="allSpc" value="all" checked>
							<label for="allSpc"><span></span>전체</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="INV_PV" tabindex="-1">
							<input type="checkbox" id="spc1" value="정상" checked>
							<label for="spc1"><span></span>SPC1</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="INV_PV" tabindex="-1">
							<input type="checkbox" id="spc2" value="트립" checked>
							<label for="spc2"><span></span>SPC2</label>
						</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="dropdown">
			<button type="button" id="collapseBtn" class="btn btn-primary dropdown-toggle no_bg ml-24" data-toggle="collapse" data-target="#searchOption">상세 검색<span class="caret"></span></button>
			<ul id="searchOption" class="collapse dropdown-menu unused">
				<li>
					<div class="bx_row aN2">
						<h2 class="comp_tit">비교 기간</h2>
						<div class="bx_align dropdown">
							<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="" autocomplete="off" placeholder="시작">
						</div>
						<div class="bx_align dropdown">
							<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off" placeholder="종료">
						</div>
					</div>

					<div class="bx_row aN2">
						<h2 class="comp_tit">상태</h2>
						<div class="bx_align dropdown">
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
							<ul class="dropdown-menu dropdown-menu-form chk_type dropdown_offset" role="menu">
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>전체</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>승인 완료</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>승인 대기</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>승인 중</label>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="bx_row aN3">
						<div class="bx_align dropdown">
							<h2 class="comp_tit">단위</h2>
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="단위">
								단위<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type dropdown_offset" role="menu">
								<li>
									<a href="#" data-value="timeUnit" tabindex="-1">
										<input type="checkbox" id="searchAllTime" value="all" name="all" checked>
										<label for="searchAllTime"><span></span>전체</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="timeUnit" tabindex="-1">
										<input type="checkbox" id="searchYearly" value="year" name="time" checked>
										<label for="searchYearly"><span></span>년</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="timeUnit" tabindex="-1">
										<input type="checkbox" id="searchMonthly" value="month" name="time" checked>
										<label for="searchMonthly"><span></span>월</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="timeUnit" tabindex="-1">
										<input type="checkbox" id="searchDaily" value="date" name="time" checked>
										<label for="searchDaily"><span></span>일</label>
									</a>
								</li>
							</ul>
						</div>
						<div class="bx_align dropdown">
							<h2 class="comp_tit">입출금 구분</h2>
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="입출금">
								선택<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type dropdown_offset" role="menu">
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>입금</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>출금</label>
									</a>
								</li>
							</ul>
						</div>
						<div class="bx_align dropdown">
							<h2 class="comp_tit">용도 구분</h2>
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="용도구분">
								선택<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type dropdown_offset" role="menu">
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>전체</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>전력판매대금</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>RFC 판매대금</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>관리운영비</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>일반 렌탈</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>전력 중개 수수료</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>전기 요금</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="allSpc" value="all" checked>
										<label for="allSpc"><span></span>원리금</label>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="btn_wrap_type03 searc">
						<button type="button" class="btn_type" id="renderBtn">확인</button>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>

<div class="row spc_transaction">
	<div class="col-12">
		<div class="indiv">
			<div class="spc_tbl">
				<table class="sort_table chk_type">
					<thead>
						<tr>
							<th><button class="btn_align down">기간</button></th>
							<th><button class="btn_align down">입출금 구분</button></th>
							<th><button class="btn_align down">계좌 구분</button></th>
							<th><button class="btn_align down">금액</button></th>
							<th><button class="btn_align down">최종 업데이트</button></th>
							<th>요창자</th>
							<th>승인자</th>
							<th><button class="btn_align down">상태 </button></th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>2020-04-08</td>
							<td>원리금</td>
							<td>계좌 구분</td>
							<td>200,000,000 </td>
							<td>2020-05-08 16:43</td>
							<td>TRUST/홍길동</td>
							<td>신한BNPP/이신한</td>
							<td class="left">승인 완료</td>
						</tr>
						<tr>
							<td>2020-04-08</td>
							<td>원리금</td>
							<td>계좌 구분</td>
							<td>200,000,000 </td>
							<td>2020-05-08 16:43</td>
							<td>TRUST/홍길동</td>
							<td>신한BNPP/이신한</td>
							<td class="left">승인 완료</td>
						</tr>
						<tr>
							<td>2020-04-08</td>
							<td>원리금</td>
							<td>계좌 구분</td>
							<td>200,000,000 </td>
							<td>2020-05-08 16:43</td>
							<td>TRUST/홍길동</td>
							<td>신한BNPP/이신한</td>
							<td class="left">승인 대기<span class="icon_edit hidden"></span><span class="icon_delete hidden"></span></td>
						</tr>
					</tbody>
				</table>
				<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
			</div>
		</div>
	</div>
</div>
