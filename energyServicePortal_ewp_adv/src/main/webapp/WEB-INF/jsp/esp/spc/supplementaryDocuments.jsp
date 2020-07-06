<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
		setInitList("listData"); //리스트초기화

		getDataList(page);

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

	function getDataList(page, n, sort) {
		if(page == undefined){
			page = 1;
		}else{
			if(isEmpty(n) && isEmpty(sort)) {
				$('.sort_table > thead').find('button').each(function(){
					if($(this).attr('class') != 'btn_align'){
						n = $(this).data('colname');
						sort = $(this).data('classname');
					}
				});
				
			}
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
				$(".sort_table").data("nowjsp", "supplementary");
				jsonListSort(n, sort, jsonList);
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
		<h1 class="page-header">SPC 이관자료</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-3 col-md-4 col-sm-4">
		<div class="tx_btn_area">
			<div class="tx_inp_type">
				<input type="text" id="key_word" placeholder="입력">
			</div>
			<button class="btn_type" onclick="getDataList();">검색</button>
		</div>
	</div>
	<div class="col-lg-9 col-md-8 col-sm-8">
		<div class="right">
			<a href="#;" class="save_btn" onclick="getCsvDown();">CSV 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv supplementary_docs">
			<div class="spc_tbl align_type">
				<table class="sort_table chk_type">
					<colgroup>
						<col style="width:5%">
						<col style="width:15%">
						<col style="width:15%">
						<col style="width:15%">
						<col style="width:20%">
						<col style="width:10%">
						<col style="width:20%">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>
								<input type="hidden" id="chk_header" value="순번">
								<label for="chk_header">순번</label>
							</th>
							<th><button class="btn_align down">SPC명</button></th>
							<th><button class="btn_align down">발전소 명</button></th>
							<th class="right"><button class="btn_align down">용량(kW)</button></th>
							<th><button class="btn_align down">관리 운영기간</button></th>
							<th class="right"><button class="btn_align down">이관자료</button></th>
							<th class="right"><button class="btn_align up">첨부파일</button></th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>
								<input type="hidden" id="chk_op[INDEX]" name="rowCheck" value="1">
								<label for="chk_op[INDEX]">[INDEX]</label>
							</td>
							<td><a href="/spc/entityDetailsBySPC.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">[name]</a></td>
							<td><a href="/spc/entityDetailsBySPC.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">[발전소_명]</a></td>
							<td class="right">[설치_용량]</td>
							<td>[관리_운영_기간]</td>
							<td class="right">[파일_현재_개수] / [파일_총_개수]</td>
							<td class="right">[첨부파일]건</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="paging_wrap" id="paging">
			</div>
		</div>
	</div>
</div>