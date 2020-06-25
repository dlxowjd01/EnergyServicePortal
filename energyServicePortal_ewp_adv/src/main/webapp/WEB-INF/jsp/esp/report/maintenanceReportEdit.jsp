<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	let addListCnt1 = 0; // 첨부하는 파일 추가할 경우 카운트 1씩 증가 ( 현장점검 )
	let addListCnt2 = 0; // 첨부하는 파일 추가할 경우 카운트 1씩 증가 ( 첨부파일 )

	$(function () {
		initAddListHtml();
		getGenData();
	});

	$(document).on('click', '.dropdown li', function () {
		var dataValue = $(this).data('value'),
			dataText = $(this).text();
		$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);
	});

	function getGenData() {
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/auth/me/sites',
			type: "get",
			async: false,
			success: function (json) {
				setInitList("genList");
				setMakeList(json, "genList", { "dataFunction": {} });
				getReportData();
			},
			error: function (request, status, error) {

			}
		});
	}


	function getReportData() {
		var reportId = "${param.report_id}";
		$.ajax({
			url: "http://iderms.enertalk.com:8443/reports/remote_work?oid=" + oid + "&report_id=" + reportId,
			type: "get",
			async: false,
			data: {},
			success: function (json) {
				setDropDownValue("report_type_list", getReportTypeName(json.data[0].report_type));
				setDropDownValue("genList", json.data[0].site_name);
				setJsonAutoMapping(json.data[0], "work_info");
				setJsonAutoMapping(JSON.parse(json.data[0].work_info), "work_info");
				setJsonAutoMapping(JSON.parse(json.data[0].work_detail_info), "work_detail_info");
				getAttachFileDisplay(JSON.parse(json.data[0].work_detail_info).files);

				$("#report_type").data("value", json.data[0].report_type);
				$("#gen").data("value", json.data[0].site_id);
			},
			error: function (request, status, error) {

			}
		});
	}

	function getReportTypeName(data) {
		var result = "";

		if ("1" == data) {
			result = "출장/조치 보고서";
		} else if ("2" == data) {
			result = "QC 보고서";
		} else {
			result = data;
		}

		return result;
	}

	function getAttachFileDisplay(files) {
		// 	var reportId = "${param.report_id}";
		var fileList01 = [], fileList02 = [];
		for (var i = 0, count = files.length; i < count; i++) {
			if (files[i].fieldname.substring(0, 19) == "work_report_file_01") {
				fileList01.push(files[i]);
			} else if (files[i].fieldname.substring(0, 19) == "work_report_file_02") {
				fileList02.push(files[i]);
			}
		}

		setMakeList(fileList01, "fileList01", { "dataFunction": {} });
		setMakeList(fileList02, "fileList02", { "dataFunction": {} });
	}

	function setRemoveFileList(fileId, idx) {
		var jsonList = $("#" + fileId).data("gridJsonData");

		jsonList.splice(idx, 1);
		setMakeList(jsonList, fileId, { "dataFunction": {} });
	}

	function setDropDownValue(id, data) {
		var $selecter = $("#" + id);
		$selecter.find("li").each(function () {
			if ($(this).text() == data) {
				$selecter.parents('.dropdown').find('button').html(data + '<span class="caret"></span>').data('value', data);
				return false;
			}
		});
	}

	function initAddListHtml() {
		$("#addFileList01").data("form", $("#addFileList01").html());
		$("#addFileList02").data("form", $("#addFileList02").html());

		setInitList("fileList01");
		setInitList("fileList02");
	}

	function addList(addId) {
		var $selecter = $("#" + addId);
		// 	$selecter.append($selecter.data("form"));

		if (addId == 'addFileList01') {
			$selecter.append('<input name="work_report_file_01' + addListCnt1 + '" type="file" class="hidden" id="work_report_file_'+addListCnt1+'"><label for="work_report_file_'+addListCnt1+'" class="btn file_upload">파일 선택</label>')
			addListCnt1++;
		} else if (addId == 'addFileList02') {
			$selecter.append('<input name="work_report_file_02' + addListCnt2 + '" type="file" class="hidden" id="work_report_file_'+addListCnt2+'"><label for="work_report_file_'+addListCnt2+'" class="btn file_upload">파일 선택</label>')
			addListCnt2++;
		}
	}

	function setSaveData() {
		var report_type = $("#report_type").data("value").toString(),
			report_name = $("#report_name").val(),
			site_id = $("#gen").data("value");

		if (report_type === undefined || report_type == "") {
			alert("보고서 구분을 선택하세요.");
			return false;
		}

		if (report_name == "") {
			alert("보고서 명을 입력하세요.");
			return false;
		}

		if (site_id == "") {
			alert("발전소를 선택하세요.");
			return false;
		}


		setFileUpload();
	}

	function setFileUpload() {
		var reportId = "${param.report_id}";

		$("#work_detail_info").find("input[type=file]").each(function () {
			$(this).attr("name", this.name + "_" + reportId);
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid=' + oid,
			data: new FormData($('#work_detail_info')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			success: function (result) {

				var existFileList = $("#fileList01").data("gridJsonData").concat($("#fileList02").data("gridJsonData"));

				setUpdateReportData(reportId, existFileList.concat(result.files));
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function setUpdateReportData(reportId, files) {
		var work_info = setAreaParamData("work_info"),
			work_detail_info = setAreaParamData("work_detail_info"),
			report_name = $("#report_name").val(),
			site_id = $("#gen").data("value");

		work_detail_info["files"] = files;

		$.ajax({
			url: "http://iderms.enertalk.com:8443/reports/remote_work/" + reportId + "?oid=" + oid,
			type: "patch",
			dataType: 'json',
			async: false,
			contentType: "application/json",
			data: JSON.stringify({
				"report_name": report_name,
				"site_id": site_id,
				"work_info": JSON.stringify(work_info),
				"work_detail_info": JSON.stringify(work_detail_info),
				"updated_by": loginId
			}),
			success: function (result) {
				alert("수정되었습니다.");
				goNowPage(reportId);
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function goNowPage(reportId) {
		location.href = "/report/maintenanceReportDetails.do?report_id=" + reportId;	
	}
	
	function goMoveList() {
		location.href = "/report/maintenanceReport.do";
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">출장/조치 보고서 </h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2020-04-06 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div>
			<span class="tx_tit">보고서 구분</span>
			<div class="sa_select">
				<div class="dropdown">
					<button id="report_type" class="btn btn-primary dropdown-toggle w9" type="button"
						data-toggle="dropdown" data-value="">
						<span class="caret"></span>
					</button>
					<ul id="report_type_list" class="dropdown-menu chk_type" role="menu" id="type">
						<li data-value="1"><a href="javascript:void(0);">출장/조치 보고서</a></li>
						<li data-value="2"><a href="javascript:void(0);">QC 보고서</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv report_post" id="work_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">출장 이력</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>보고서 명</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="report_name" placeholder="직접 입력">
							</div>
						</td>
						<th>발전소</th>
						<td>
							<div class="dropdown placeholder edit">
								<button id="gen" class="btn btn-primary dropdown-toggle" type="button"
									data-toggle="dropdown" data-value="">선택
									<span class="caret"></span>
								</button>
								<ul id="genList" class="dropdown-menu" role="menu">
									<li data-value="[sid]"><a href="javascript:void(0);">[name]</a></li>
								</ul>
							</div>
						</td>
					</tr>
					<tr>
						<th>출장 시기</th>
						<td>
							<div class="sel_calendar edit twin clear">
								<input type="text" id="출장_시기_from" class="sel datepicker fromDate" value=""
									autocomplete="off" placeholder="시작일">
								<input type="text" id="출장_시기_to" class="sel datepicker toDate" value=""
									autocomplete="off" placeholder="종료일">
							</div>
						</td>
						<th>출장 장소</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="출장_장소" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>작성 일자</th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="작성_일자" class="sel datepicker" value="" autocomplete="off"
									placeholder="날짜 선택">
							</div>
						</td>
						<th>출장 목적</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="출장_목적" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>소속 부서</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="소속_부서" placeholder="직접 입력">
							</div>
						</td>
						<th>출장자</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="출장자" placeholder="직접 입력">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<form id="work_detail_info" name="work_detail_info">
			<div class="indiv mt25 report_post02">
				<div class="tbl_top">
					<h2 class="ntit mt25">처리 내역</h2>
				</div>
				<div class="spc_tbl_row">
					<table>
						<colgroup>
							<col style="width:15%">
							<col>
						</colgroup>
						<tr>
							<th>시스템 개요</th>
							<td>
								<div class="txarea_inp_type">
									<textarea placeholder="내용 추가" id="시스템_개요" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">현장 점검<a href="javascript:addList('addFileList01')"
									class="btn_add fr">추가</a></th>
							<td>
								<div id="fileList01">
									<p class="tx_file">
										<a
											href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button class="btn_type07"
											onclick="setRemoveFileList('fileList01', [INDEX]);">삭제</button>
									</p>
								</div>
								<div id="addFileList01">
									<input type="file" name="work_report_file_01" class="hidden" id="work_report_file_01">
									<label for="work_report_file_01" class="btn file_upload">파일 선택</label>
									<span class="upload_text ml-16"></span>
								</div>
							</td>
						</tr>
						<tr>
							<th>특이사항</th>
							<td>
								<div class="txarea_inp_type">
									<textarea id="특이사항" placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th>향후 진행예정 업무</th>
							<td>
								<div class="txarea_inp_type">
									<textarea id="향후_진행예정_업무" placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th>담당자 의견</th>
							<td>
								<div class="txarea_inp_type">
									<textarea id="담당자_의견" placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="hei_type">첨부 파일<a href="javascript:addList('addFileList02')"
									class="btn_add fr">추가</a></th>
							<td>
								<div id="fileList02">
									<p class="tx_file">
										<a
											href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button class="btn_type07"
											onclick="setRemoveFileList('fileList02', [INDEX]);">삭제</button>
									</p>
								</div>
								<div id="addFileList02">
									<input type="file" name="work_report_file_02" class="hidden" id="work_report_file_02">
									<label for="work_report_file_02" class="btn file_upload">파일 선택</label>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
					<button type="button" class="btn_type" onclick="setSaveData();">수정</button>
				</div>
			</div>
		</form>
	</div>
</div>