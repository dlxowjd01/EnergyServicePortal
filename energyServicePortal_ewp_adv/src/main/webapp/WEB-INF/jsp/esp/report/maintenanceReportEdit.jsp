<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript">
	let addListCnt1 = 0; // 첨부하는 파일 추가할 경우 카운트 1씩 증가 ( 현장점검 )
	let addListCnt2 = 0; // 첨부하는 파일 추가할 경우 카운트 1씩 증가 ( 첨부파일 )

	$(function () {
		setInitList('genList');
		initAddListHtml();
		getGenData();
	});

	function getGenData() {
		$.ajax({
			url: apiHost + '/auth/me/sites',
			type: 'get',
			async: false,
			success: function (json) {
				setMakeList(json, 'genList', { 'dataFunction': {} });
				getReportData();
			},
			error: function (request, status, error) {}
		});
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

				setDropDownValue('report_type', getReportTypeName(json.data[0].report_type), json.data[0].report_type);
				setDropDownValue('gen', json.data[0].site_name, json.data[0].site_id);
				setJsonAutoMapping(json.data[0], 'work_info');
				setJsonAutoMapping(JSON.parse(json.data[0].work_info), 'work_info');
				setJsonAutoMapping(JSON.parse(json.data[0].work_detail_info), 'work_detail_info');
				getAttachFileDisplay(JSON.parse(json.data[0].work_detail_info).files);
			},
			error: function (request, status, error) {}
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

	function getAttachFileDisplay(files) {
		let fileList01 = [], fileList02 = [];
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

		setMakeList(fileList01, 'fileList01', { 'dataFunction': {} });
		setMakeList(fileList02, 'fileList02', { 'dataFunction': {} });
	}

	function setRemoveFileList(fileId, idx) {
		let jsonList = $('#' + fileId).data('gridJsonData');
		jsonList.splice(idx, 1);
		setMakeList(jsonList, fileId, { 'dataFunction': {} });
	}

	function setDropDownValue(id, text, data) {
		let $selecter = $('#' + id),
			$button = $selecter.find('button');
		$button.html(text + '<span class="caret"></span>').data('value', data);
	}

	function initAddListHtml() {
		$('#addFileList01').data('form', $('#addFileList01').html());
		$('#addFileList02').data('form', $('#addFileList02').html());

		setInitList('fileList01');
		setInitList('fileList02');
	}

	function addList(addId) {
		let $selecter = $('#' + addId);

		if (addId == 'addFileList01') {
			$selecter.append('<input name="work_report_file_01' + addListCnt1 + '" type="file" class="hidden" id="work_report_file_'+addListCnt1+'"><label for="work_report_file_'+addListCnt1+'" class="btn file_upload">파일 선택</label>')
			addListCnt1++;
		} else if (addId == 'addFileList02') {
			$selecter.append('<input name="work_report_file_02' + addListCnt2 + '" type="file" class="hidden" id="work_report_file_'+addListCnt2+'"><label for="work_report_file_'+addListCnt2+'" class="btn file_upload">파일 선택</label>')
			addListCnt2++;
		}
	}

	function setSaveData() {
		let report_type = $('#report_type button').data('value'),
			report_name = $('#report_name').val(),
			site_id = $('#gen button').data('value');

		if (report_type === undefined || report_type == '') {
			alert('보고서 구분을 선택하세요.');
			return false;
		}

		if (report_name == '') {
			alert('보고서 명을 입력하세요.');
			return false;
		}

		if (site_id == '') {
			alert('발전소를 선택하세요.');
			return false;
		}

		setUpdateReportData();
	}

	function loopFile(target, index, fileList) {
		if (fileList[index] != undefined) {
			if (target.textContent.trim() != fileList[index].name) {
				fileList.splice(index, 1);
				loopFile(target, index, fileList);
			}
		}
	}

	function setUpdateReportData() {
		const reportId = '${param.report_id}';
		let work_info = setAreaParamData('work_info'),
			report_type = $('#report_type button').data('value'),
			work_detail_info = setAreaParamData('work_detail_info'),
			report_name = $('#report_name').val(),
			site_id = $('#gen button').data('value');
		let resultFiles = new Array();

		$('#work_detail_info').find('input[type="file"]').each(function () {
			const liList = $(this).parent().find('.file_list li');
			let fileList = Array.from($(this)[0].files);

			liList.each(function(index, target) {
				loopFile(target, index, fileList);
			});

			if (fileList.length > 0) {
				let formData = new FormData($('#fileUploadForm')[0]),
					filedName = $(this).attr('name') + '_' + genUuid();
				fileList.forEach(function(file) {
					formData.append(filedName, file);
				});

				$.ajax({
					url: apiHost + '/files/upload?oid=' + oid,
					type: 'post',
					enctype: 'multipart/form-data',
					data: formData,
					processData: false,
					contentType: false,
					cache: false,
					timeout: 600000,
					async: false,
					success: function (result) {
						resultFiles = resultFiles.concat(result.files);
					},
					error: function (request, status, error) {
						alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
					}
				});
			}
		});

		resultFiles = resultFiles.concat($("#fileList01").data("gridJsonData"));
		resultFiles = resultFiles.concat($("#fileList02").data("gridJsonData"));
		work_detail_info['files'] = resultFiles;

		$.ajax({
			url: apiHost + '/reports/remote_work/' + reportId + '?oid=' + oid,
			type: 'patch',
			dataType: 'json',
			async: false,
			contentType: 'application/json',
			data: JSON.stringify({
				report_type: String(report_type),
				report_name: report_name,
				site_id: site_id,
				work_info: JSON.stringify(work_info),
				work_detail_info: JSON.stringify(work_detail_info),
				updated_by: loginId
			}),
			success: function (result) {
				alert('수정되었습니다.');
				goNowPage(reportId);
			},
			error: function (request, status, error) {
				alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
			}
		});
	}

	function goNowPage(reportId) {
		location.href = '/report/maintenanceReportDetails.do?report_id=' + reportId;
	}
	
	function goMoveList() {
		location.href = '/report/maintenanceReport.do';
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">출장/조치 보고서 </h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div>
			<span class="tx_tit">보고서 구분</span>
			<div class="sa_select">
				<div class="dropdown" id="report_type">
					<button type="button" class="dropdown-toggle w9" data-toggle="dropdown" data-value="">
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk_type" role="menu">
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
							<div class="dropdown placeholder edit" id="gen">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="">
									선택 <span class="caret"></span>
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
								<input type="text" id="출장_시기_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="출장_시기_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
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
								<input type="text" id="작성_일자" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택">
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
							<th class="vert_type">시스템 개요</th>
							<td>
								<div class="txarea_inp_type">
									<textarea placeholder="내용 추가" id="시스템_개요" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">현장 점검</th>
							<td>
								<div id="fileList01" class="hide-no-data">
									<p class="tx_file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList01', [INDEX]);">삭제</button>
									</p>
								</div>
								<div id="addFileList01">
									<input type="file" name="work_report_file_01" class="hidden" id="work_report_file_01" accept="image/*" multiple>
									<label for="work_report_file_01" class="btn file_upload">파일 선택</label>
									<div class="file_list ml-16">
										<ul></ul>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">특이사항</th>
							<td>
								<div class="txarea_inp_type">
									<textarea id="특이사항" placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">향후 진행예정 업무</th>
							<td>
								<div class="txarea_inp_type">
									<textarea id="향후_진행예정_업무" placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">담당자 의견</th>
							<td>
								<div class="txarea_inp_type">
									<textarea id="담당자_의견" placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">첨부 파일</th>
							<td>
								<div id="fileList02" class="hide-no-data">
									<p class="tx_file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList02', [INDEX]);">삭제</button>
									</p>
								</div>
								<div id="addFileList02">
									<input type="file" name="work_report_file_02" class="hidden" id="work_report_file_02" accept="image/*" multiple>
									<label for="work_report_file_02" class="btn file_upload">파일 선택</label>
									<div class="file_list ml-16">
										<ul></ul>
									</div>
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