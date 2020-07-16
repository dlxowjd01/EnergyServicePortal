<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = "${sessionScope.userInfo.oid}";
	const loginId = "${sessionScope.userInfo.login_id}";

	$(function () {
		init();
		getReportData();
	});

	function init() {
		setInitList("fileList01");
		setInitList("fileList02");
	}

	function getReportData() {
		var reportId = "${param.report_id}";
		$.ajax({
			url: apiHost + "/reports/remote_work?oid=" +
				oid +
				"&report_id=" +
				reportId,
			type: "get",
			async: false,
			data: {},
			success: function (json) {
				setDropDownValue(
					"report_type_list",
					getReportTypeName(json.data[0].report_type)
				);
				setJsonAutoMapping(json.data[0], "work_info");
				setJsonAutoMapping(
					JSON.parse(json.data[0].work_info),
					"work_info"
				);
				setJsonAutoMapping(
					JSON.parse(json.data[0].work_detail_info),
					"work_detail_info"
				);
				getAttachFileDisplay(
					JSON.parse(json.data[0].work_detail_info).files
				);

				var regDt = new Date(
					JSON.parse(json.data[0].work_info)["작성_일자"]
				);
				var tripFrom = new Date(
					JSON.parse(json.data[0].work_info)["출장_시기_from"]
				);
				var tripTo = new Date(
					JSON.parse(json.data[0].work_info)["출장_시기_to"]
				);

				$("#작성_일자").text(dateFormatWorkInfo(regDt));
				$("#출장_시기_from").text(dateFormatWorkInfo(tripFrom));
				$("#출장_시기_to").text(dateFormatWorkInfo(tripTo));
			},
			error: function (request, status, error) { },
		});
	}

	function dateFormatWorkInfo(date) {
		var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var date = date.getDate();

		if (("" + month).length == 1) {
			month = "0" + month;
		}
		if (("" + date).length == 1) {
			date = "0" + date;
		}

		return year + "-" + month + "-" + date;
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

	function setDropDownValue(id, data) {
		var $selecter = $("#" + id);
		$selecter.find("li").each(function () {
			if ($(this).text() == data) {
				$selecter
					.parents(".dropdown")
					.find("button")
					.html(data + '<span class="caret"></span>')
					.data("value", data);
				return false;
			}
		});
	}

	function getAttachFileDisplay(files) {
		// 	var reportId = "${param.report_id}";
		var fileList01 = [],
			fileList02 = [];
		if (!isEmpty(files)) {
			for (var i = 0, count = files.length; i < count; i++) {
				if(files[i] != null) {
					if (files[i].fieldname.match('work_report_file_01')) {
						fileList01.push(files[i]);
					} else if (files[i].fieldname.match('work_report_file_02')) {
						fileList02.push(files[i]);
					}
				}
			}
		}

		setMakeList(fileList01, "fileList01", { dataFunction: {} });
		setMakeList(fileList02, "fileList02", { dataFunction: {} });
	}

	function goMoveDelete() {
		$.ajax({
			url:
				apiHost + "/reports/remote_work/" +
				"${param.report_id}" +
				"?oid=" +
				oid,
			type: "delete",
			dataType: "json",
			async: false,
			data: {},
			success: function (result) {
				alert("삭제되었습니다..");
				goMoveList();
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			},
		});
	}

	function goMoveEdit() {
		location.href =
			"/report/maintenanceReportEdit.do?report_id=" +
			"${param.report_id}";
	}

	function goMoveList() {
		location.href = "/report/maintenanceReport.do";
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">출장/조치 보고서</h1>
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
					<button id="report_type" class="btn btn-primary dropdown-toggle w9 disabled" type="button"
						data-toggle="dropdown">
						출장/조치 보고서
						<span class="caret"></span>
					</button>
					<ul id="report_type_list" class="dropdown-menu chk_type" role="menu" id="type">
						<li data-value="1">
							<a href="javascript:void(0);">출장/조치 보고서</a>
						</li>
						<li data-value="2">
							<a href="javascript:void(0);">QC 보고서</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<!--<div class="row">
		<div class="col-lg-12">
			<div class="right">
				<a href="#;" class="save_btn">PDF 다운로드</a>
			</div>
		</div>
	</div>-->
<div class="row">
	<div class="col-12">
		<div class="indiv" id="work_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">출장 이력</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<!-- <colgroup>
						<col style="width: 15%;" />
						<col style="width: 35%;" />
						<col style="width: 15%;" />
						<col style="width: 35%;" />
					</colgroup> -->
					<tr>
						<th>보고서 명</th>
						<td id="report_name"></td>
						<th>발전소</th>
						<td id="site_name">혜원솔라 01</td>
					</tr>
					<tr>
						<th>출장 시기</th>
						<td>
							<span id="출장_시기_from"></span> ~
							<span id="출장_시기_to"></span>
						</td>
						<th>출장 장소</th>
						<td id="출장_장소">혜원솔라 01</td>
					</tr>
					<tr>
						<th>작성 일자</th>
						<td id="작성_일자">2020.04.01</td>
						<th>출장 목적</th>
						<td id="출장_목적">
							혜원솔라 1호기 RTU 설치공사 QC 점검
						</td>
					</tr>
					<tr>
						<th>소속 부서</th>
						<td id="소속_부서">인코어드 엔지니어링팀</td>
						<th>출장자</th>
						<td id="출장자">박준호, 이세용, 최상훈, 권종인</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="work_detail_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">처리 내역</h2>
			</div>
			<div class="spc_tbl_row spc_tbl_row report_detail_box">
				<table>
					<tr>
						<th>시스템 개요</th>
						<td id="시스템_개요">
							혜원솔라 1호기 RTU 설치공사 및 데이터 QC 점검 진행건
						</td>
					</tr>
					<tr>
						<th>현장 점검</th>
						<td>
							<div id="fileList01">
								<p class="tx_file">
									<a href="${sessionScope.apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">
										<img src="${sessionScope.apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]" alt="[originalname]" />
									</a>
								</p>
							</div>
						</td>
					</tr>
					<tr>
						<th>특이사항</th>
						<td id="특이사항">
							(1) RTU 설치공사 - 양호<br />(2) RTU 데이터 통신
							상태 점검 - 양호
						</td>
					</tr>
					<tr>
						<th>향후 진행예정 업무</th>
						<td id="향후_진행예정_업무">
							데이터 정밀 검토 및 통신 상태 점검
						</td>
					</tr>
					<tr>
						<th>담당자 의견</th>
						<td id="담당자_의견">
							인버터 내에 RTU 정상 설치 완료 후 통신 상태 확인
							DATA 수신 상태 양호함
						</td>
					</tr>
					<tr>
						<th>첨부 파일</th>
						<td>
							<div id="fileList02">
								<p class="tx_file">
									<a href="${sessionScope.apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
								</p>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveDelete();">
					삭제
				</button>
				<button type="button" class="btn_type03" onclick="goMoveEdit();">
					수정
				</button>
				<button type="button" class="btn_type03" onclick="goMoveList();">
					목록
				</button>
			</div>
		</div>
	</div>
</div>