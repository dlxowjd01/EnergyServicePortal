<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	const nowDate = new Date();
	let addListCnt1 = 0; // 첨부하는 파일 추가할 경우 카운트 1씩 증가 ( 현장점검 )
	let addListCnt2 = 0; // 첨부하는 파일 추가할 경우 카운트 1씩 증가 ( 첨부파일 )

	$(function () {
		setInitList('genList');

		initAddListHtml();
		getGenData();

		$('#출장_시기_from').datepicker('setDate', nowDate);
	});

	$(document).on('keyup', '#repair_maintenance_info input', function() {
		let inputVal = $(this).val();

		if ($(this).prop('id') !== '기타명') {
			let total = 0;
			inputVal = inputVal.replace(/[^0-9]/g, '');

			$('#repair_maintenance_info input').each(function() {
				const thisVal = $(this).val().replace(/[^0-9]/g, '')
					, thisId = $(this).prop('id');

				if (thisId !== '기타명' && thisId !== '총_수선_유지비') {
					total += Number(thisVal);
				}
			});

			$('#총_수선_유지비').val(numberComma(total));
			$(this).val(numberComma(inputVal));
		}
	});

	const getGenData = () => {
		$.ajax({
			url: apiHost + '/auth/me/sites',
			type: 'get',
			async: false,
			success: function (json) {
				setMakeList(json, 'genList', {'dataFunction': {}});
			},
			error: function (request, status, error) {
				console.error(error);
			}
		});
	}

	const initAddListHtml = () => {
		$('#addFileList01').data('form', $('#addFileList01').html());
		$('#addFileList02').data('form', $('#addFileList02').html());
	}

	const setSaveData = () => {
		const report_type = $('#report_type button').data('value'),
			report_name = $('#report_name').val(),
			site_id = $('#gen button').data('value');

		if (isEmpty(report_type)) {
			alert('<fmt:message key="report.post.alert.1" />');
			return false;
		}

		if (isEmpty(report_name)) {
			alert('<fmt:message key="report.post.alert.2" />');
			return false;
		}

		if (isEmpty(site_id)) {
			alert('<fmt:message key="report.post.alert.3" />');
			return false;
		}

		setInsertReportData();
	}

	function loopFile(target, index, fileList) {
		if (fileList[index] != undefined) {
			if (target.textContent.trim() != fileList[index].name) {
				fileList.splice(index, 1);
				loopFile(target, index, fileList);
			}
		}
	}

	const setInsertReportData = () => {
		const work_info = setAreaParamData('work_info')
			, repair_maintenance_info = setAreaParamData('repair_maintenance_info')
			, work_detail_info = setAreaParamData('work_detail_info')
			, report_type = $('#report_type button').data('value')
			, report_name = $('#report_name').val()
			, site_id = $('#gen button').data('value');
		let resultFiles = new Array();

		$('#insertReportModal').modal(); // 처리중 모달띄우기

		if (!isEmpty(repair_maintenance_info.기타)) {
			if (isEmpty(repair_maintenance_info.기타명)) {
				alert('<fmt:message key="report.post.alert.4" />');
				return false;
			}
		}

		$('#work_detail_info').find('input[type="file"]').each(function () {
			const liList =$(this).parent().find('.file_list li');
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
						alert('<fmt:message key="report.post.alert.5" />');
					}
				});
			}
		});

		if (!isEmpty(resultFiles)) {
			work_detail_info['files'] = resultFiles;
		}

		$.ajax({
			url: apiHost + '/reports/remote_work?oid=' + oid,
			type: 'post',
			dataType: 'json',
			async: false,
			contentType: 'application/json',
			data: JSON.stringify({
				report_type: String(report_type),
				report_name: report_name,
				site_id: site_id,
				work_info: JSON.stringify(work_info),
				repair_maintenance_info: JSON.stringify(repair_maintenance_info),
				work_detail_info: JSON.stringify(work_detail_info),
				updated_by: loginId
			}),
			success: function (result) {
				alert('<fmt:message key="report.post.alert.6" />');
				goMoveList();
			},
			error: function (request, status, error) {
				alert('<fmt:message key="report.post.alert.7" />');
				return false;
			}
		});
	}

	function goMoveList() {
		location.href = '/report/maintenanceReport.do';
	}
</script>

<form id="fileUploadForm" name="fileUploadForm"></form>
<!-- Modal (처리 중 모달)-->
<div id="insertReportModal" class="modal fade" role="dialog">
	<div class="modal-dialog history-alarm">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-title">
				<h2 class="ly_tit" style="text-align: center;">처리중...</h2>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header"><fmt:message key='report.post.title' /> </h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div>
			<span class="tx-tit asterisk"><fmt:message key='report.post.type' /></span>
			<div class="sa-select">
				<div class="dropdown" id="report_type">
					<button type="button" class="dropdown-toggle w9" data-toggle="dropdown" data-value="">
						<fmt:message key='button.select' /><span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type" role="menu">
						<li data-value="1"><a href="javascript:void(0);"><fmt:message key='report.post.type.1' /></a></li>
						<li data-value="2"><a href="javascript:void(0);"><fmt:message key='report.post.type.2' /></a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv report-post" id="work_info">
			<div class="table-top">
				<h2 class="ntit mt-25"><fmt:message key='report.post.visit' /></h2>
			</div>
			<div class="spc-table-row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><span class="asterisk"><fmt:message key='report.post.name' /></span></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="report_name" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th><span class="asterisk"><fmt:message key='report.post.plant' /></span></th>
						<td class="group-type">
							<div class="dropdown placeholder edit" id="gen" >
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="">
									<fmt:message key='button.select' /> <span class="caret"></span>
								</button>
								<ul id="genList" class="dropdown-menu" role="menu">
									<li data-value="[sid]"><a href="javascript:void(0);">[name]</a></li>
								</ul>
							</div>
						</td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.date' /></th>
						<td>
							<div class="sel-calendar edit twin clear">
								<input type="text" id="출장_시기_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="<fmt:message key='workreport.2.startDate' />" readonly>
								<input type="text" id="출장_시기_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="<fmt:message key='workreport.2.endDate' />" readonly>
							</div>
						</td>
						<th><fmt:message key='workreport.2.placeVisited' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="출장_장소" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.writeDate' /></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="작성_일자" class="sel datepicker" value="" autocomplete="off" placeholder="<fmt:message key='workreport.2.selectDate' />">
							</div>
						</td>
						<th><fmt:message key='workreport.2.purpose' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="출장_목적" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.dep' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="소속_부서" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th><fmt:message key='report.post.reporter' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="출장자" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv report-post mt-20" id="repair_maintenance_info">
			<div class="table-top">
				<h2 class="ntit mt-25"><fmt:message key='report.post.history' /></h2>
			</div>
			<div class="spc-table-row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><fmt:message key='report.post.history.1' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="인버터_수리" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.2' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="tracker_보수" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.3' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="모듈_보수" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.4' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="구조물_보수" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.5' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="접속반_보수" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.6' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="케이블_보수" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.7' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="보수공사_기타" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.8' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="모니터링" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.9' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="예초_및_각도" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.10' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="민원_및_피해보상" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>
							<div class="text-input-type edit w-150px">
								<input type="text" id="기타명" placeholder="<fmt:message key='report.post.history.11' />">
							</div>
						</th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="기타" placeholder="<fmt:message key='report.post.placeholder.1' />">
							</div>
						</td>
						<th></th>
						<td>

						</td>
					</tr>
					<tr>
						<th><fmt:message key='report.post.history.12' /></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="총_수선_유지비" placeholder="<fmt:message key='report.post.placeholder.3' />" readonly>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>

		<form id="work_detail_info" name="work_detail_info">
			<div class="indiv mt-25 report-post02">
				<div class="table-top">
					<h2 class="ntit mt-25"><fmt:message key='report.post.result' /></h2>
				</div>
				<div class="spc-table-row">
					<table>
						<tr>
							<th class="th-title"><fmt:message key="report.post.result.1" /></th>
							<td>
								<div class="textarea-input-type">
									<textarea placeholder="<fmt:message key='report.post.placeholder.2' />" id="시스템_개요" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="th-title"><fmt:message key="report.post.result.2" /></th>
							<td id="addFileList01">
								<input type="file" name="work_report_file_01" class="hidden" id="work_report_file_01" accept="image/*" multiple>
								<label for="work_report_file_01" class="btn file-upload"><fmt:message key="report.post.result.7" /></label>
								<div class="file_list ml-16">
									<ul></ul>
								</div>
							</td>
						</tr>
						<tr>
							<th class="th-title"><fmt:message key="report.post.result.3" /></th>
							<td>
								<div class="textarea-input-type">
									<textarea id="특이사항" placeholder="<fmt:message key='report.post.placeholder.2' />" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="th-title"><fmt:message key="report.post.result.4" /></th>
							<td>
								<div class="textarea-input-type">
									<textarea id="향후_진행예정_업무" placeholder="<fmt:message key='report.post.placeholder.2' />" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="th-title"><fmt:message key="report.post.result.5" /></th>
							<td>
								<div class="textarea-input-type">
									<textarea id="담당자_의견" placeholder="<fmt:message key='report.post.placeholder.2' />" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="th-title"><fmt:message key="report.post.result.6" /></th>
							<td id="addFileList02">
								<input name="work_report_file_02" type="file" class="hidden" id="work_report_file_02" accept="image/*" multiple>
								<label for="work_report_file_02" class="btn file-upload"><fmt:message key="report.post.result.7" /></label>
								<div class="file_list ml-16">
									<ul></ul>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" onclick="goMoveList();"><fmt:message key="report.post.back" /></button>
					<button type="button" class="btn-type" onclick="setSaveData();"><fmt:message key="report.post.register" /></button>
				</div>
			</div>
		</form>
	</div>
</div>