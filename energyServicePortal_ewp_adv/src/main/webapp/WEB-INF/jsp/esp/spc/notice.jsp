<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	$(function() {
		const disclosureOpt = $("#disclosurePersons").find("li a");
		const spcOpt = $("#spcList").parents(".input-group");
		setInitList("listData"); //리스트초기화
		getDataList(page);
		navAddClass("notice");

		disclosureOpt.on("click", function(){
			if($(this).parents("li").data("value")=="assetManager") {
				spcOpt.removeClass("hidden");
			}
		})

	});

	$(document).on('keyup', '#key_word', function(e) {
		if (e.keyCode == 13) {
			getDataList(page);
		}
	})

	function modalOpen(){
		const addNotice = $("#addNotice");
		addNotice.modal("show");
	}
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
							newData["관리_운영_기간"] = nvl(contractInfo["관리_운영_기간"], "-");
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

<div class="modal fade" id="addNotice" role="dialog">
	<div class="modal-dialog modal-lg">
		<div class="modal-content device_modal_content">
			<div class="modal-header stit">
				<h2>공지 사항 작성 </h2>
			</div>
			<div class="modal-body">
				<form id="noticeForm" action="#" method="post" name="noticeForm" novalidate>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="noticeTitle" class="input_label">제목</label>
								<input type="text" id="noticeTitle" class="input tx_inp_type w-100" name="noticeTitle" placeholder="입력">
							</div>
							<div class="input-group inline-flex top">
								<label for="noticeDetail" class="input_label">내용</label>
								<textarea name="noticeDetail" id="noticeDetail" class="textarea w-100"></textarea>
							</div>
						</div>
					</div>
					<div class="row mt8">
						<div class="col-lg-6 col-sm-12">
							<div class="input-group inline-flex"><!--
							--><h2 class="input_label">설명</h2><!--
							--><div class="dropdown"><!--
								--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul id="disclosurePersons" class="dropdown-menu"><!--
									--><li data-value="all"><a href="javascript:void(0)">전체</a></li><!--
									--><li data-value="assetManager"><a href="javascript:void(0)">자산 운용사</a></li><!--
									--><li data-value="spcCustodian"><a href="javascript:void(0)">선택 SPC 담당 사무수탁사</a></li><!--
								--></ul>
								</div>
							</div>
						</div>
						<div class="col-lg-6 col-sm-12">
							<div class="input-group inline-flex hidden"><!--
							--><h2 class="input_label">SPC 선택</h2><!--
							--><div class="dropdown"><!--
								--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul id="spcList" class="dropdown-menu"><!--
									--><li data-value="spc1"><a href="javascript:void(0)">SPC1</a></li><!--
									--><li data-value="spc2"><a href="javascript:void(0)">SPC2</a></li><!--
									--><li data-value="spc3"><a href="javascript:void(0)">SPC3</a></li><!--
								--></ul>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex"><!--
								--><h2 class="input_label">첨부 파일</h2><!--
								--><a href="javascript:addList('addFileList12')" class="btn_add">추가</a><!--
								--><input type="file" id="noticeFile" class="hidden" name="notice_file01" accept=".jpg, .png, .pdf"><!--
								--><label for="noticeFile" class="btn file_upload ml-32">파일 선택</label><!--
								--><span class="upload_text"></span><!--
							--></ul>
							<button class="btn_type07 ml-16 hidden"></button>
							</div>
						</div>
					</div>
				</form>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="submit" class="btn_type" id="addBtn">완료</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">공지 사항</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-3">
		<div class="tx_btn_area">
			<div class="tx_inp_type">
				<input type="text" id="key_word" placeholder="입력">
			</div>
			<button class="btn_type" onclick="getDataList();">검색</button>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv supplementary_docs">
			<div class="btn_wrap_type01"><button type="button" class="btn_type big" onclick="modalOpen()">작성</button></div>
			<div class="spc_tbl align_type">
				<table class="sort_table chk_type">
					<colgroup>
						<col style="width:15%">
						<col style="width:40%">
						<col style="width:15%">
						<col style="width:15%">
						<col style="width:15%">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>SPC명</th>
							<th>제목</th>
							<th>첨부 파일</th>
							<th>작성자 </th>
							<th class="right">작성일</th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td><a href="/spc/entityDetailsBySPC.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">[name]</a></td>
							<td class="left">[제목]</td>
							<td>[첨부파일]</td>
							<td class="left">[작성자]</td>
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