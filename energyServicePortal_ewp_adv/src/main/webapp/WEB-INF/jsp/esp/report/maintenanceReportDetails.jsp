<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script type="text/javascript">
	$(function () {
		init();
		getReportData();
	});

	function init() {
		setInitList('fileList01');
		setInitList('fileList02');
	}

	function getReportData() {
		let reportId = '${param.report_id}';
		$.ajax({
			url: apiHost + '/reports/remote_work?oid=' + oid + '&report_id=' + reportId,
			type: 'get',
			async: false,
			data: {},
			success: function (json) {
				const data = json.data[0],
					workInfo = JSON.parse(data.work_info),
					workDetailInfo = JSON.parse(data.work_detail_info);

				setDropDownValue('report_type', getReportTypeName(data['report_type']), data['report_type']);
				setJsonAutoMapping(data, 'work_info');
				setJsonAutoMapping(workInfo, 'work_info');
				setJsonAutoMapping(workDetailInfo, 'work_detail_info');
				getAttachFileDisplay(workDetailInfo['files']);

				const dateArray = ['작성_일자', '출장_시기_from', '출장_시기_to'];
				dateArray.forEach(date => {
					const dateText = workInfo[date];
					if (!isEmpty(dateText)) {
						const dateVal = new Date(dateText);
						$('#' + date).text(dateVal.format('yyyy-MM-dd'));
					}
				});
			},
			error: function (request, status, error) {
				alert('조회중 오류가 발생했습니다.');
				console.error(error);
				return false;
			},
		});
	}

	function getReportTypeName(data) {
		let result = '';

		if ('1' == data) {
			result = '출장/조치 보고서';
		} else if ('2' == data) {
			result = 'QC 보고서';
		} else {
			result = data;
		}
		return result;
	}

	function setDropDownValue(id, text, data) {
		let $selecter = $('#' + id),
			$button = $selecter.find('button');
		$button.html(text + '<span class="caret"></span>').data('value', data);
	}

	function getAttachFileDisplay(files) {
		let fileList01 = [],
			fileList02 = [];
		if (!isEmpty(files)) {
			files.forEach(file => {
				if (!isEmpty(file)) {
					if (file['fieldname'].match('work_report_file_01')) {
						fileList01.push(file);
					} else if (file['fieldname'].match('work_report_file_02')) {
						fileList02.push(file);
					}
				}
			});
		}

		setMakeList(fileList01, 'fileList01', {dataFunction: {}});
		setMakeList(fileList02, 'fileList02', {dataFunction: {}});
	}

	function goMoveDelete() {

		let delPrompt = prompt('삭제하시겠습니까? \n삭제를 원하시면 아래 "삭제"라고 입력하고 확인을 눌러 주세요.', '');
		if (delPrompt != '삭제') {
			return;
		}

		$.ajax({
			url: apiHost + '/reports/remote_work/' + '${param.report_id}' + '?oid=' + oid,
			type: 'delete',
			dataType: 'json',
			async: false,
			data: {},
			success: function (result) {
				alert('삭제되었습니다.');
				goMoveList();
			},
			error: function (request, status, error) {
				alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
			},
		});
	}

	function goMoveEdit() {
		location.href = '/report/maintenanceReportEdit.do?report_id=' + '${param.report_id}';
	}

	function goMoveList() {
		location.href = '/report/maintenanceReport.do';
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">출장/조치 보고서</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div>
			<span class="tx_tit">보고서 구분</span>
			<div class="sa_select">
				<div class="dropdown" id="report_type">
					<button class="btn btn-primary dropdown-toggle w9 disabled" type="button" data-toggle="dropdown">
						출장/조치 보고서
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk_type" role="menu">
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
						<td id="site_name"></td>
					</tr>
					<tr>
						<th>출장 시기</th>
						<td>
							<span id="출장_시기_from"></span> ~ <span id="출장_시기_to"></span>
						</td>
						<th>출장 장소</th>
						<td id="출장_장소"></td>
					</tr>
					<tr>
						<th>작성 일자</th>
						<td id="작성_일자"></td>
						<th>출장 목적</th>
						<td id="출장_목적"></td>
					</tr>
					<tr>
						<th>소속 부서</th>
						<td id="소속_부서"></td>
						<th>출장자</th>
						<td id="출장자"></td>
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
						<td id="시스템_개요"></td>
					</tr>
					<tr>
						<th>현장 점검</th>
						<td>
							<div id="fileList01">
								<p class="tx_file">
									<a href="${sessionScope.apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">
										<img src="${sessionScope.apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]" alt="[originalname]"/>
									</a>
								</p>
							</div>
						</td>
					</tr>
					<tr>
						<th>특이사항</th>
						<td id="특이사항"></td>
					</tr>
					<tr>
						<th>향후 진행예정 업무</th>
						<td id="향후_진행예정_업무"></td>
					</tr>
					<tr>
						<th>담당자 의견</th>
						<td id="담당자_의견"></td>
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