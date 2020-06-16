<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
		// setInitList("listData"); //리스트초기화

		// getDataList(page);

	});

	function editRow(){
		if(oid===""){
			
		}
	}
	function deleteRow(){
		
	}
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
		<h1 class="page-header">출금 요청서 검토</h1>
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
		<span class="tx_tit">검토 상태</span><div class="sa_select mr-16">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체 <span class="caret"></span></button>
				<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
					<li>
						<a class="chk_group" href="#" tabindex="-1">
							<input type="checkbox" id="statusOnWait" value="wait" name="wait">
							<label for="statusOnWait"><span></span>검토 대기</label>
						</a>
					</li>
					<li>
						<a class="chk_group" href="#" tabindex="-1">
							<input type="checkbox" id="statusInProgress" value="progress" name="progress">
							<label for="statusInProgress"><span></span>검토 중</label>
						</a>
					</li>
					<li>
						<a class="chk_group" href="#" tabindex="-1">
							<input type="checkbox" id="statusComplete" value="complete" name="complete">
							<label for="statusComplete"><span></span>승인 완료</label>
						</a>
					</li>
				</ul>
			</div>
		</div>
		<form id="spc_form" class="tx_btn_area">
			<div class="tx_inp_type">
				<input type="text" id="key_word" placeholder="입력">
			</div>
			<button type="button" class="btn_type">검색</button>
		</form>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv no_border spc_bal_post">
			<div class="btn_wrap_type01">
				<button type="button" class="btn_type">선택 인쇄</button>
			</div>
			<table class="sort_table">
				<colgroup>
					<col style="width:3%">
					<col style="width:9%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:14%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:14%">
					<col>
				</colgroup>
				<thead>
				<tr>
					<th></th>
					<th>
						<button class="btn_align down">출금 일자</button>
					</th>
					<th>
						<button class="btn_align down">SPC 명</button>
					</th>
					<th>
						<button class="btn_align down">금액</button>
					</th>
					<th>
						<button class="btn_align down">요청/수정일</button>
					</th>
					<th>
						<button class="btn_align down">사무 수탁사</button>
					</th>
					<th>
						<button class="btn_align down">담당자</button>
					</th>
					<th>
						<button class="btn_align down">상태</button>
					</th>

					<th>
						<button class="btn_align down">승인자</button>
					</th>
					<th>
						<button class="btn_align down">승인일</button>
					</th>
				</tr>
				</thead>
				<tbody id="spcStatusTable">
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-04-08</td>
						<td>SPC1</td>
						<td>200,000,000</td>
						<td>2020-05-29 16:43</td>
						<td>TRUST</td>
						<td>이종목</td>
						<%-- <td><a class="tbl_link" href="spc/widthdrawReqStatusDetail.do">승인완료</a></td> --%>
						<td><a href="#" class="tbl_link" >승인완료</a></td>
						<td>이효섭</td>
						<td>2020-06-02 12:43</td>
					</tr>
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-04-08</td>
						<td>SPC2</td>
						<td>500,000,000</td>
						<td>2020-06-09 12:43</td>
						<td>MSI</td>
						<td>홍길동</td>
						<td><a href="#" class="tbl_link" >검토중</a></td>
						<td>김길중</td>
						<td>검토중</td>
					</tr>
				</tbody>
			</table>
			<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
		</div>
	</div>
</div>
