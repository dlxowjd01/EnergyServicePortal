<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script type="text/javascript">
	let reportTable = null;

	$(function () {
		reportTable = $('#reportTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			'table-layout': 'fixed',
            scrollX: true,
			scrollY: '720px',
			scrollCollapse: true,
			sortable: true,
			paging: true,
			pageLength: 50,
			lengthMenu : [[50, 100, 200], [50, 100, 200]],
			initComplete() {
				$("#reportTable_length > label").html('<select name="reportTable_length" aria-controls="reportTable" class=""><option value="50">50</option><option value="100">100</option><option value="200">200</option></select>')
			},

			columns: [
				{
					title: '<input type="checkbox" id="allCheck"><label for="allCheck"></label>',
					data: null,
					mRender: function ( data, type, full, rowIndex ) {
						return '<input type="checkbox" class="datatable-checkbox" id="check' + rowIndex.row + '" name="table_checkbox"><label for="check' + rowIndex.row + '"></label>';
					},
					className: 'dt-center no-sorting'
				},
				{
					title: '<fmt:message key="workreportmain.2.number" />',
					data: null,
					render: function (data, type, full, rowIndex) {
						return rowIndex.row + 1;
					},
					className: 'dt-center no-sorting fixed'
				},
				{
					title: '<fmt:message key="workreportmain.2.reportType" />',
					data: 'report_type',
					render: function (data, type, full, rowIndex) {
						if ('1' === data) {
							result = '출장/조치 보고서';
						} else if ('2' === data) {
							result = 'QC 보고서';
						}
						return result;
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="workreportmain.2.documentNumber" />',
					data: 'report_id',
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="workreportmain.2.reportName" />',
					data: 'report_name',
					render: function (data, type, full, rowIndex) {
						return '<a href="/report/maintenanceReportDetails.do?report_id=' + full['report_id'] + '" class="table-link">' + data + '</a>';
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="workreportmain.2.writer" />',
					data: 'updated_by',
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="workreportmain.2.dateOfIssue" />',
					data: 'write_date',
					render: function (data, type, full, rowIndex) {
						if (data != null) {
							return data.format('yyyy-MM-dd');
						} else {
							return '-';
						}
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="workreportmain.2.registrationStatus" />',
					data: null,
					render: function (data, type, full, rowIndex) {
						return '<fmt:message key="workreportmain.2.saved" />'
					},
					className: 'dt-center'
				}
			],
			select: {
				style: 'multi',
				selector: 'td:first-child > :checkbox, tr > td:not(:has(button))'
			},
			language: {
				emptyTable: "<fmt:message key='yieldReport.noData.1' />",
				zeroRecords:  "<fmt:message key='yieldReport.noData.2' />",
				infoEmpty: "",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / <fmt:message key='table.totalCase.start' /> _TOTAL_ <fmt:message key='table.totalCase.end' />",
			},
			dom: 'tipl',
		}).on('select', function(e, dt, type, indexes) {
			reportTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
		}).on('deselect', function(e, dt, type, indexes) {
			reportTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
		}).columns.adjust().draw();

		new $.fn.dataTable.Buttons(reportTable, {
			name: 'commands',
			buttons: [
				{
					extend: 'excelHtml5',
					className: "btn-save",
					text: '<fmt:message key="workreportmain.1.dataExtracts" />',
					filename: '작업보고서_' + new Date().format('yyyyMMddHHmmss'),
					customize: function( xlsx ) {
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
						$('row:first c', sheet).attr( 's', '42' );
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
					}
				}
			]
		});

		reportTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
		getDataList();
	});

	$(document).on('keyup', '#key_word', function (e) {
		if (e.keyCode === 13) { getDataList(); }
	});

	function getDataList(page, n, sort) {
		console.log("search!")
		const write_date_from = $('#write_date_from').datepicker('getDate')
			, write_date_to = $('#write_date_to').datepicker('getDate')

		console.log(write_date_from, write_date_to)

		if ((write_date_from != null && write_date_to == null) || (write_date_from == null && write_date_to != null)) {
			$('#dateWarning').removeClass('hidden');
			return false;
		} else {
			$('#dateWarning').addClass('hidden');
		}

		$.ajax({
			url: apiHost + '/reports/remote_work',
			type: 'get',
			async: false,
			data: {oid: oid},
		}).done((json, textStatus, jqXHR) => {
			const data = json['data'];
			data.forEach((rowData, index) => {
				const workInfo = JSON.parse(rowData['work_info'])
					, workDate = workInfo['작성_일자'];
				data[index]['write_date'] = new Date(workDate);
			});

			let refineList = data.filter(rowData => jsonDataFilter(rowData));

			//작성일 기준 역순 정렬
			refineList.sort((a, b) => {
				return a['workDate'] < b['workDate'] ? 1 : a['workDate'] > b['workDate'] ? -1 : 0;
			});

			console.log(refineList);

			reportTable.clear();
			reportTable.rows.add(refineList).draw();
		}).fail((jqXHR, textStatus, errorThrown) => {
			reportTable.clear().draw();
			const r = formatErrorMessage(jqXHR, errorThrown);
			errorMsg('처리 중 오류가 발생했습니다.' + r)
		});
	}

	function jsonDataFilter(rowData) {
		const keyWord = $('#key_word').val().trim()
			, report_type = $('#report_type').data('value')
			, write_date_from = $('#write_date_from').datepicker('getDate')
			, write_date_to = $('#write_date_to').datepicker('getDate')
			, workInfo = JSON.parse(rowData['work_info']);

		let bReportType = false
		  , bWriteDate = false
		  , bKeyWord = false
		  , bResult = false; //결과값


		if (isEmpty(report_type) || (!isEmpty(report_type) && report_type == rowData['report_type'])) {
			bReportType = true;
		} else {
			bReportType = false;
		}

		//작성일자
		if (write_date_from == null && write_date_to == null) {
			bWriteDate = true;
		} else if (write_date_from != null && write_date_to != null) {
			const write_date = rowData['write_date'];

			if (write_date.getTime() >= write_date_from.getTime() && write_date.getTime() <= write_date_to.getTime()) {
				bWriteDate = true;
			} else {
				bWriteDate = false;
			}
		} else {
			bWriteDate = false;
		}

		//키워드검색
		if (!isEmpty(keyWord)) {
			const keyWordPattern = new RegExp(keyWord, 'i'); //ignoreCase 대소문자 구분X

			if (keyWordPattern.test(rowData['report_name'])
				|| keyWordPattern.test(workInfo['출장_장소'])
				|| keyWordPattern.test(workInfo['출장_목적'])
				|| keyWordPattern.test(workInfo['출장자'])
				|| keyWordPattern.test(rowData['site_name'])
				|| keyWordPattern.test(rowData['updated_by'])
			) {
				bKeyWord = true;
			} else {
				bKeyWord = false;
			}
		} else {
			bKeyWord = true;
		}

		if (bReportType && bWriteDate && bKeyWord) {
			bResult = true;
		}

		return bResult;
	}

	/**
	 * 에러 처리
	 *
	 * @param msg
	 */
	const errorMsg = msg => {
		$("#errMsg").text(msg);
		$("#errorModal").modal("show");
		setTimeout(function(){
			$("#errorModal").modal("hide");
		}, 1800);
	}
</script>
<div class="row">
	<div class="col-12">
		<h1 class="page-header">작업 보고서</h1>
	</div>
</div>
<div class="row">
	<div class="col-10">
		<div class="flex-group">
			<span class="tx-tit"><fmt:message key="workreport.1.reportType" /></span>
			<div class="dropdown">
				<button type="button" id="report_type" class="dropdown-toggle w5" data-toggle="dropdown" data-value="">
					<fmt:message key="workreportmain.1.all" />
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<li data-value="">
						<a href="javascript:void(0);"><fmt:message key="workreportmain.1.all" /></a>
					</li>
					<li data-value="1">
						<a href="javascript:void(0);"><fmt:message key="workreport.1.tripActionReport" /></a>
					</li>
					<li data-value="2">
						<a href="javascript:void(0);">QC 보고서</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="tx-tit"><fmt:message key="workreportmain.1.dateOfIssue" /></span>
			<div class="sel-calendar dateField">
				<input type="text" id="write_date_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly />
				<em></em>
				<input type="text" id="write_date_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly />
			</div>
			<small id="dateWarning" class="hidden warning">시작일과 종료일을 모두 입력해 주세요.</small>
		</div>
		<div class="flex-group maintenance-search">
			<div class="text-input-type mr-12">
				<input type="text" id="key_word" placeholder="입력" />
			</div>
			<button type="submit" class="btn-type" onclick="getDataList();">
				<fmt:message key="workreportmain.1.search" />
			</button>
		</div>
	</div>
	<div class="col-2">
		<div id="exportBtnGroup" class="fr"></div>
		<!-- <button type="button" class="btn-save ml-16 fr" onclick="$(this).prev().toggleClass('hidden')">데이터 다운로드</button>-->
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn-wrap-type01">
				<c:if test="${sessionScope.userInfo.role eq '1'}">
				<button type="button" class="btn-type" onclick="location.href='/report/maintenanceReportPost.do'">
					<fmt:message key="workreportmain.2.register" />
				</button>
				</c:if>
			</div>
			<table id="reportTable" class="chk-type">
				<colgroup>
					<col style="width:5%">
					<col style="width:5%">
					<col style="width:15%">
					<col style="width:15%">
					<col style="width:35%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:10%">
				</colgroup>
			</table>
			<div class="pagination-wrapper" id="paging"></div>
		</div>
	</div>
</div>