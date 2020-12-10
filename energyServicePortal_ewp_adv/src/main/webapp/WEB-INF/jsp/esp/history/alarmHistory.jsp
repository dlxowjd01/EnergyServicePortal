<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<!-- 파일 업로드 폼 -->
<form id="picupload" name="upload" method="multipart/form-data"></form>
<div id="alarmConfirm" class="modal fade" role="dialog">
	<div class="modal-dialog modal-s">
		<div class="modal-content">
			<h2 class="modal-title"><fmt:message key='alarm.table.confirm' /></h2>
			<p class="text-line1 mt-20 mb-24"><fmt:message key='alarm.confirm.YN' /></p>
			<div class="btn-wrap-type05"><!--
			--><button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key='alarm.confirm.N' /></button><!--
			--><button type="button" class="btn-type ml-12" onclick="alarmConfirmProcess();"><fmt:message key='alarm.confirm.Y' /></button><!--
		--></div>
		</div>
	</div>
</div>

<div id="alarmMeasure" class="modal fade" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content alarm-modal-content">
			<div class="modal-header">
				<h2><fmt:message key="alertshistory.4.acknowledgement" /></h2>
			</div>
			<div class="modal-body">
				<div class="flex-align-top">
					<span class="input-label"><fmt:message key='alarm.popup.history' /></span>
					<textarea id="ticket_log" name="ticket_log" class="textarea" readonly></textarea>
				</div>
				<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				<div class="flex-start">
					<span class="input-label"><fmt:message key='alarm.popup.image' /></span>
					<div class="text-input-type">
						<input type="text" id="photoFile" name="photoFile" placeholder="<fmt:message key='alarm.popup.filename' />" readonly="" autocomplete="off" accept="image/*">
					</div>
					<div class="btn-wrapper ml-6">
						<button type="button" id="fileUpload" class="btn-type"><fmt:message key='alarm.popup.upload' /></button>
						<input type="file" id="picture" name="filename" class="btn-upload hidden"/>
						<span class="upload-text ml-16 hidden"></span>
					</div>
				</div>

				<hr class="hidden">

				<div class="upload-photo">
					<ul>
					</ul>
				</div>

				<hr>
				</c:if>

				<div class="flex-start">
					<span class="input-label"><fmt:message key='alarm.popup.status.current' /></span>
					<div id="ticket_status" class="dropdown">
						<button type="button" class="dropdown-toggle required" placeholder="<fmt:message key='alarm.popup.status.select' />" data-toggle="dropdown"><span class="caret"></span></button>
						<ul class="dropdown-menu">
							<li data-value="new"><a href="javascript:void(0);"><fmt:message key='alarm.popup.status.new' /></a></li>
							<li data-value="open"><a href="javascript:void(0);"><fmt:message key='alarm.popup.status.working' /></a></li>
							<li data-value="on-hold"><a href="javascript:void(0);"><fmt:message key='alarm.popup.status.pending' /></a></li>
							<li data-value="resolved"><a href="javascript:void(0);"><fmt:message key='alarm.popup.status.sitework' /></a></li>
							<li data-value="pending"><a href="javascript:void(0);"><fmt:message key='alarm.popup.status.confirm' /></a></li>
							<li data-value="closed"><a href="javascript:void(0);"><fmt:message key='alarm.popup.status.done' /></a></li>
						</ul>
					</div>
				</div>
				<hr>

				<div class="flex-start">
					<span class="input-label"><fmt:message key='alarm.popup.person' /></span>
					<div id="userlist" class="dropdown w-20">
						<button type="button" class="dropdown-toggle required" data-toggle="dropdown"><fmt:message key='alarm.popup.status.select' /><span class="caret"></span></button>
						<ul class="dropdown-menu"></ul>
					</div>
					<div class="text-input-type w-20 ml-6">
						<input type="hidden" id="ticket_user_id" name="ticket_user_id" placeholder="<fmt:message key='alarm.selfInput' />" readonly autocomplete="off">
						<input type="text" id="ticket_phone" name="ticket_phone" placeholder="<fmt:message key='alarm.selfInput' />" autocomplete="off">
					</div>
				</div>

				<hr>

				<div class="flex-align-top">
					<span class="input-label"><fmt:message key='alarm.popup.memo' /></span>
					<textarea id="memo" name="memo" class="textarea"></textarea>
				</div>

				<hr>

				<div class="flex-start">
					<span class="input-label"><fmt:message key='alarm.report' /></span>
					<div id="maintenanceReportList" class="dropdown">
						<button type="button" class="dropdown-toggle" placeholder="<fmt:message key='alarm.popup.status.select' />" data-toggle="dropdown"><fmt:message key='alarm.popup.status.select' /><<span class="caret"></span></button>
						<ul class="dropdown-menu"></ul>
					</div>
				</div>

				<hr class="hidden">

				<div class="report-select">
					<ul>
					</ul>
				</div>

				<hr>

				<div class="btn-wrap-type02"><!--
				--><button type="button" class="btn-type03" data-dismiss="modal"><fmt:message key='alarm.popup.cancel' /></button><!--
				--><button type="button" class="btn-type ml-12" onclick="ackProcess();"><fmt:message key='alarm.popup.confirm' /></button><!--
			--></div>
			</div>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl"><fmt:message key='alarm.popup.history' /></h1>
	</div>
</div>

<div class="row history_search">
	<div class="col-12">
		<form id="alarmHistorySearchForm">
			<div class="sa-select">
				<div class="dropdown" id="site">
					<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='alarm.search.select' />"><fmt:message key='alarm.search.select' /><span class="caret"></span></button>
					<ul class="dropdown-menu chk-type" role="menu" id="siteList">
						<li data-value="[sid]">
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
								<label for="site_[INDEX]">[name]</label>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<div id="searchDetail" class="search-expand sa-select">
				<button type="button" class="btn clear-btn" data-target="#searchDropdown" data-name="상세 조건" onclick="$('#searchDetail').toggleClass('open')"><fmt:message key='alarm.detailSearch' /><span class="caret"></span></button>
				<div id="searchDropdown" class="dropdown-menu search-dropdown">
					<div class="flex-start3">
						<div class="sa-select">
							<h2 class="tx-tit"><fmt:message key="alertshistory.1.devicetype" /></h2>
							<div id="equipmentList" class="dropdown">
								<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='alarm.popup.status.select' />">
									<fmt:message key='alarm.popup.status.select' /><span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk-type" role="menu" id="device">
									<li data-value="[type]">
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="type_[INDEX]" value="[type]" name="deviceType">
											<label for="type_[INDEX]">[name]</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="flex-start3">
						<div class="sa-select">
							<h2 class="tx-tit"><fmt:message key='alarm.search.alarmType' /></h2>
							<div class="dropdown">
								<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='default.dataNameSelect' />"><fmt:message key="alertshistory.1.all" /><span class="caret"></span></button>
								<ul class="dropdown-menu chk-type" role="menu">
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm1" value="9" name="alarm" checked>
											<label for="alarm1"><fmt:message key='alarm.search.level.unknown' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm2" value="0" name="alarm" checked>
											<label for="alarm2"><fmt:message key='alarm.search.level.info' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm3" value="1" name="alarm" checked>
											<label for="alarm3"><fmt:message key='alarm.search.level.warn' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm4" value="2" name="alarm" checked>
											<label for="alarm4"><fmt:message key='alarm.search.level.abnornal' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm5" value="3" name="alarm" checked>
											<label for="alarm5"><fmt:message key='alarm.search.level.trip' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm6" value="4" name="alarm" checked>
											<label for="alarm6"><fmt:message key='alarm.search.level.normal' /></label>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="sa-select">
							<h2 class="tx-tit"><fmt:message key="alarm.table.isChecked" /></h2>
							<div class="dropdown short" id="alarmstatus">	
								<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='default.dataNameSelect' />"><fmt:message key="alarm.search.confirm.N" /><span class="caret"></span></button>
								<ul class="dropdown-menu chk-type" role="menu" id="alstatus">
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alstatus1" name="confirm">
											<label for="alstatus1"><fmt:message key='alarm.search.confirm.Y' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alstatus2" name="confirm" checked>
											<label for="alstatus2"><fmt:message key='alarm.search.confirm.N' /></label>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="sa-select">
							<h2 class="tx-tit"><fmt:message key='alarm.search.repairStatus' /></h2>
							<div class="dropdown">
								<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='alarm.search.all' />"><fmt:message key='alarm.search.all' /><span class="caret"></span></button>
								<ul class="dropdown-menu chk-type" role="menu" id="status">
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status1" name="status" value="new" checked>
											<label for="status1"><fmt:message key='alarm.popup.status.new' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status2" name="status" value="open" checked>
											<label for="status2"><fmt:message key='alarm.popup.status.working' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status3" name="status" value="on-hold" checked>
											<label for="status3"><fmt:message key='alarm.popup.status.pending' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status4" name="status" value="resolved" checked>
											<label for="status4"><fmt:message key='alarm.popup.status.sitework' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status5" name="status" value="pending" checked>
											<label for="status5"><fmt:message key='alarm.popup.status.confirm' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status7" name="status" value="closed" checked>
											<label for="status7"><fmt:message key='alarm.popup.status.done' /></label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="flex-start3 dateField">
						<div class="sa-select">
							<h2 class="tx-tit"><fmt:message key="alertshistory.1.timeframe" /></h2>
							<div class="dropdown short">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key='alarm.search.period.day' /><span class="caret"></span></button>
								<ul class="dropdown-menu" role="menu" id="term">
									<li data-value="day"><a href="javascript:void(0)"><fmt:message key='alarm.search.period.day' /></a></li>
									<li class="on" data-value="week"><a href="javascript:void(0)"><fmt:message key='alarm.search.period.week' /></a></li>
									<li data-value="month"><a href="javascript:void(0)"><fmt:message key='alarm.search.period.month' /></a></li>
									<li data-value="setup"><a href="javascript:void(0)"><fmt:message key='alarm.search.period.manual' /></a></li>
								</ul>
							</div>
						</div>
						<div class="sa-select">
							<label class="tx-tit" for="fromDate"><fmt:message key="alertshistory.1.period" /></label>
							<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="" autocomplete="off">
						</div>
						<div class="sa-select">
							<label for="toDate" class="tx-tit"></label>
							<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off">
						</div>
						<div class="sa-select">
							<h2 class="tx-tit"><fmt:message key='alarm.search.unit' /></h2>
							<div id="cycle" class="dropdown short">
								<button type="button" class="dropdown-toggle interval" data-toggle="dropdown"><fmt:message key='alarm.popup.status.select' /><span class="caret"></span></button>
								<ul class="dropdown-menu" id="detailterm">
									<li data-value="15min"><a href="javascript:void(0);"><fmt:message key='alarm.search.unit.15min' /></a></li>
									<li data-value="hour"><a href="javascript:void(0);"><fmt:message key='alarm.search.unit.1h' /></a></li>
									<li data-value="day"><a href="javascript:void(0);"><fmt:message key='alarm.search.period.day' /></a></li>
									<li data-value="month"><a href="javascript:void(0);"><fmt:message key='alarm.search.period.month' /></a></li>
								</ul>
							</div>
						</div>
					</div>

					<div class="btn-wrap-type02">
						<button style="padding: 0px 12px;" type="button" class="btn-type03 w-80px" onclick="$('#searchDetail').removeClass('open')"><fmt:message key='alarm.popup.cancel' /></button><!--
					--><button style="padding: 0px 12px;" type="button" class="btn-type w-80px" onclick="$('#searchDetail').removeClass('open')"><fmt:message key='alarm.apply' /></button>
					</div>
				</div>

				<div class="sa-select">
					<button type="button" id="search" class="btn-type ml-6"><fmt:message key="alertshistory.1.update" /></button>
				</div>
			</div>
		</form>
	</div>
</div>


<div class="row">
	<div class="col-xl-8 col-lg-9 col-md-6 col-sm-12">
		<div class="indiv alarm-history">
			<div class="alarm-header">
				<h2 class="ntit fl"><fmt:message key="alertshistory.2.alertstatus" /></h2>
				<div id="chartType" class="flex-end">
					<div class="radio-type">
						<input type="radio" id="rdo03_1" name="chartType" value="type" checked>
						<label for="rdo03_1"><fmt:message key="alertshistory.2.devicetype" /></label>
					</div>
					<div class="radio-type">
						<input type="radio" id="rdo03_2" name="chartType" value="alarm">
						<label for="rdo03_2"><fmt:message key="alertshistory.2.alerttype" /></label>
					</div>
				</div>
			</div>
			<div class="inchart">
				<div id="hchart2"></div>
			</div>
		</div>
	</div>
	<div class="col-xl-4 col-lg-3 col-md-6 col-sm-12">
		<div class="indiv alarm-pie-wrapper">
			<div class="inchart">
				<div id="hchart2_2">
				</div>
			</div>
			<div id="legendArea" class="chart-legend-wrapper">
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="indiv alarm-detail-wrapper">
			<div class="table-wrap-type">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	const sgid = '${sessionScope.sgid}';
	const vgid = '${sessionScope.vgid}';

	let dataList = [];
	let changeTablegird = null;
	let ticketFileList = new Array();
	let ticketLogList = new Array();
	let confirmstate = "";
	const sidparam = "${param.sid}";
	let sites = JSON.parse('${siteList}');
	const deviceTemplate = new Array();

	const levelTemplate = [
		{
			9: "알수없음",
			0: "정보",
			1: "경고",
			2: "이상",
			3: "트립",
			4: "정상",
		},
		{
			9: '<fmt:message key="alarm.search.level.unknown" />',
			0: '<fmt:message key="alarm.search.level.info" />',
			1: '<fmt:message key="alarm.search.level.warn" />',
			2: '<fmt:message key="alarm.search.level.abnornal" />',
			3: '<fmt:message key="alarm.search.level.trip" />',
			4: '<fmt:message key="alarm.search.level.normal" />',
		}
	];
	const statusTemplate = {
		'null': '<fmt:message key="alarm.popup.status.new" />', //신규
		'new': '<fmt:message key="alarm.popup.status.new" />', //신규
		'open': '<fmt:message key="alarm.popup.status.working" />', //작업처리중
		'on-hold': '<fmt:message key="alarm.popup.status.pending" />', //추가 정보 대기
		'resolved': '<fmt:message key="alarm.popup.status.sitework" />', //현장 조치 완료
		'pending': '<fmt:message key="alarm.popup.status.confirm" />', //처리 결과 확인
		'closed': '<fmt:message key="alarm.popup.status.done" />', //처리 완료
	};

	// <!-- properties 조회 -->
	const deviceProperties = async () => {
		$.ajax({
			url: apiHost + '/config/view/device_properties',
			type: 'get',
			async: false,
			data: {},
			success: function (result) {
				Object.entries(result).map(obj => {
					let propName = (langStatus == 'KO') ? obj[1].name.kr : obj[1].name.en;
					deviceTemplate[obj[0]] = propName;
				});
			},
			dataType: 'json'
		});
	};

	$(function() {
		deviceProperties();
		setInitList('siteList');
		setInitList('device');
		siteList(sidparam);
		if (sidparam != "") {
			deviceTypeList(sidparam);
		}

		//사이트 선택시
		$('#fromDate').datepicker('setDate', 'today');
		$('#toDate').datepicker('setDate', 'today');

		$('.radio-type').on('click', function () {
			if ($(this).find('input').is(':checked')) { } else {
				$(this).find('input').prop('checked', true);
			}
		});

		$('#term li').on('click', function () {
			if ($(this).data('value') == 'setup') {
				$('#dateArea').show();
			} else {
				if ($(this).data('value') == 'day') { //오늘
					$('#fromDate').datepicker('setDate', 'today');
					$('#toDate').datepicker('setDate', 'today');
				} else if ($(this).data('value') == 'week') { //이번주
					$('#fromDate').datepicker('setDate', '-6');
					$('#toDate').datepicker('setDate', 'today');
				} else if ($(this).data('value') == 'month') { //이번달
					$('#fromDate').datepicker('setDate', '-30');
					$('#toDate').datepicker('setDate', 'today');
				}
			}
		});

		if (sidparam != '') {
			$('#detailterm').prev().html('1시간 &nbsp;<span class="caret"></span>').data('value', 'hour');
			periodData();
			fetchCharts();
			$('#search').trigger('click');
		}

		$('#search').on('click', function () {
			let interval = $('#cycle').find('button').data('value');
			if (isEmpty(interval)) {
				alert('<fmt:message key="alarm.alert.1" />');
				return false;
			} else {
				periodData();
				fetchCharts();
			}
		});

		$('#chartType input').on('click', function () {
			fetchCharts();
		});

		$('#fileUpload').on('click', function () {
			$('#picture').trigger('click');
		});

	});

	$(document).on('change', 'input[type="file"]', function () {
		let uuid = genUuid();
		let liStr = '';
		$('#picupload').empty();
		$(this).clone().appendTo('#picupload');
		$('#picupload').find('input').attr('name', uuid).attr('id', uuid);
		$.ajax({
			enctype: 'multipart/form-data',
			url: apiHost + '/files/upload?oid=' + oid,
			data: new FormData($('#picupload')[0]),
			type: 'post',
			async: false,
			processData: false,
			contentType: false,
			success: function (result) {
				if (result.files.length > 0) {
					if ($('.upload-photo li').length == 0) { $('.upload-photo').prev().removeClass('hidden'); }
					liStr += '<li class="flex-start"><span class="photo-text"><a href="' + apiHost + '/files/download/' + result.files[0].fieldname + '?oid=' + oid + '&orgFilename=' + result.files[0].originalname + '">' + result.files[0].originalname + '</a></span>';
					liStr += '<button type="button" class="btn-close" data-time="' + new Date().toISOString() + '" value="' + result.files[0].fieldname + '" name="file_original_name">삭제</button></li>';
				}
				$('.upload-photo ul').append(liStr);

				if ($('.upload-photo').css('display') == 'none') {
					$('.upload-photo').show();
				}
			},
			error: function (error) {
				console.error(error);
			}
		});
	});

	$(document).on('click', 'button[name="file_original_name"]', function () {
		$(this).parent().remove();
		if ($('.upload-photo li').length == 0) { $('.upload-photo').prev().addClass('hidden'); }
	});

	$(document).on('click', '#userlist li', function () {
		if ($(this).text() == '직접 입력') {
			$('#ticket_user_id').val('').prop('readonly', false);
			$('#ticket_phone').val('');
		} else {
			$('#ticket_user_id').val($(this).data('value')).prop('readonly', true);
			$('#ticket_phone').val($(this).data('phone'));
		}
	});

	$(document).on('click', '.report-select .btn-close', function() {
		$(this).parents('li.flex-start').remove();

		if ($('.report-select').find('li').length == 0) {
			$('.report-select').prev().addClass('hidden');
		}
	});

	const rtnDropdown = function (id) {
		if (id == 'site') {
			deviceTypeList();
		} else if (id == 'maintenanceReportList') {
			addReportId();
		}
	}
	
	const siteList = function (sidparam) {
		const makeSite = Array.from(sites);
		makeSite.sortOn('name');
		makeSite.unshift({ sid: 'all', name: '<fmt:message key="alarm.search.all" />'});
		setMakeList(makeSite, 'siteList', {'dataFunction': {}}); //list생성
		$('#siteList').append(`<li class="btn-wrap-type03 btn-wrap-border"><button type="button" class="btn-type mr-16"><fmt:message key='alarm.apply' /></button></li>`);
		$('#siteList').find('input[value="all"]').parent().after('<li class="btn-wrap-border-min"></li>');


		if (sidparam == '' || sidparam == undefined) {
			$(':checkbox[name="site"]').prop('checked', false);
		} else{
			$(':checkbox[name="site"][value="' + sidparam + '"]').prop('checked', true);
		}

		displayDropdown($('#site'));
	};

	const deviceTypeList = function (sidparam) {
		$('#equipmentList > div > ul').empty();
		let deviceList = [];
		let sites = JSON.parse('${siteList}');
		dataList = deviceType(sites, sidparam);
		
		$.each(dataList[0], function(i, deviceName){
			const kdeviceName = eval('deviceTemplate.' + deviceName);
			deviceList.push({name:kdeviceName, type:deviceName});
		});

		deviceList.sortOn('name');
		setMakeList(deviceList, 'device', { 'dataFunction': {} });

		if (sidparam == '' || sidparam == undefined) {
			$(':checkbox[name="deviceType"]').prop('checked', false);
		} else {
			$(':checkbox[name="deviceType"]').prop('checked', true);
		}
	};

	const periodData = function () {
		$('.table-wrap-type').empty();

		if ($(':checkbox[name="deviceType"]:checked').length == 0) {
			alert('<fmt:message key="alarm.alert.2" />');
			return false;
		}

		if ($(':checkbox[name="alarm"]:checked').length == 0) {
			alert('<fmt:message key="alarm.alert.3" />');
			return false;
		}

		$('.history-table tbody').empty();

		let alarmData = '';
		let siteArray = '';
		let deviceArray = new Array();
		let alarmArray = new Array();
		let statusArray = new Array();

		$(':checkbox[name="deviceType"]:checked').each(function () {
			deviceArray.push($(this).val());
		});
		$(':checkbox[name="alarm"]:checked').each(function () {
			alarmArray.push($(this).val());
		});
		$(':checkbox[name="status"]:checked').each(function () {
			statusArray.push($(this).val());
		});

		if (!isEmpty(sgid) || !isEmpty(vgid)) {
			siteArray = dataList[1].join(',')
		} else {
			siteArray = 'all';
		}

		if ($(':checkbox[name="confirm"]:checked').length == 2) {
			alarmData = {
				sids: siteArray,
				deviceTypes: deviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
			}
		} else {
			let confirm = "";
			if ($(':checkbox[name="confirm"]:checked').next('label').text() === '<fmt:message key="alarm.confirm.N" />') {
				confirm = false;
			} else {
				confirm = true;
			}
			alarmData = {
				sids: siteArray,
				deviceTypes: deviceArray.join(','),
				confirm: confirm,
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
			}
		}

		$.ajax({
			url: apiHost + '/alarms',
			type: 'get',
			async: false,
			data: alarmData,
			success: function (result) {
				let data = [];
				let jsonList = [];
				gridDataFilter(data, statusArray, alarmArray, result); //알람 및 조치상태 필터링
				
				changeTablegird = data;
				
				for(let i in deviceArray){
					jsonList.push(new Array());
				}
				
				$('.history-table').remove();
				
				for(let i in data){
					var temp = data[i];
					
					data[i].localtime = temp.localtime; // 알람발생시간
					data[i].tlocaltime = dateFormat(String(temp.localtime)); // 테이블에 보여질 알람발생시간
					data[i].alarmtype = ((isEmpty(temp.level)) ? '-' : levelTemplate[1][temp.level]); // 테이블에 보여질 알람타입;
					data[i].level = temp.level; // 알람타입
					data[i].message = ((isEmpty(temp.message)) ? "" : temp.message); // 알람메시지
					
					if (temp.confirm == false) {
						data[i].confirm  = '<a href="javascript:alarmConfirm(\'' + temp.alarm_id + '\',\'' + temp.ticket_id + '\');" class="table-link" ><fmt:message key="alarm.confirm.N" /></a>'; // 알람상태
					} else {
						data[i].confirm = '<fmt:message key="alarm.search.confirm.Y" />'; // 알람상태
					}
					
					if (!(isEmpty(temp.status))) {
						data[i].status = '<a href="javascript:updateAck(\'' + temp.alarm_id + '\',\'' + temp.ticket_id + '\');" class="table-link" >' + statusTemplate[temp.status] + '</a>'; // 조치상태
					} else {
						data[i].status = '<a href="javascript:createAck(\'' + temp.alarm_id + '\');" class="table-link" ><fmt:message key="alarm.popup.status.new" /></a>'; // 조치상태
					}
					
					if (!(isEmpty(temp.status_timestamp))) {
						data[i].status_timestamp = new Date(temp.status_timestamp).format('yyyy-MM-dd HH:mm:ss'); // 최종업데이트 시간
					} else {
						data[i].status_timestamp = '';
					}
				}
				
				$.each(data, function(i, datalist){
					$.each(deviceArray, function (j, e2) {
						if(datalist.device_type == e2){
							jsonList[j].push(data[i]);
						}
					})
				})
				$.each(deviceArray, function (i, el) {
					makeDiv(el);
					makeTableHead(el);
					setInitList(el);
					setMakeList(jsonList[i], el, { 'dataFunction': { 'INDEX': getNumberIndex } }); //list생성
				});
			},
			dataType: 'json'
		});
	}
	
	const getNumberIndex = function(index) {
		return index + 1;
	}
	
	const makeDiv = function (deviceType) {
		let divStr = '';
		divStr += '<div class="table-top clear">';
		divStr += '<h2 class="ntit fl">' + deviceTemplate[deviceType] + '</h2>';
		divStr += '<button type="button" class="btn-type03 fr" onclick="alarmConfirmAll(\'' + deviceType + '\');"><fmt:message key="alarm.checkAll" /></button>';
		divStr += '</div>';
		$(".table-wrap-type").append(divStr);
	}
	
	const makeTableHead = function (deviceType) {
		let newContainer = document.createElement('Div');
		let newHeadTable = document.createElement('table');
		let colList = ['<fmt:message key="alarm.table.site" />', '<fmt:message key="alarm.table.deviceName" />', '<fmt:message key="alarm.table.alarmTime" />', '<fmt:message key="alarm.table.alarmType" />', '<fmt:message key="alarm.table.alarmMsg" />', '<fmt:message key="alarm.table.isChecked" />', '<fmt:message key="alarm.table.status" />', '<fmt:message key="alarm.table.finalUpdated" />']; // 테이블
		let tdList = ['[site_name]', '[device_name]', '[tlocaltime]', '[alarmtype]', '[message]', '[confirm]', '[status]', '[status_timestamp]'];
		let thead = newHeadTable.createTHead();
		let tbody = newHeadTable.createTBody();
		let tRow = thead.insertRow();
		let bRow = tbody.insertRow();

		for (let i = 0; i < colList.length + 1; i++) {
			let hCell = document.createElement("th");
			if (i == 0) {
				hCell.innerHTML = '<input type="checkbox" id="alarmConfirmCheck' + deviceType + '" onclick="alarmConfirmCheckAll(\'' + deviceType + '\');"><label for="alarmConfirmCheck' + deviceType + '"></label>';
				tRow.appendChild(hCell);
			} else {
				hCell.innerHTML = '<button type="button" class="btn-align">' + colList[i - 1] + '</button>';
				tRow.appendChild(hCell);
			}
		}
		
		for (let i = 0; i < tdList.length + 1; i++) {
			let dCell = document.createElement("td");
			if (i == 0) {
				dCell.innerHTML = '<input type="checkbox" id="chk_op[INDEX]" name="rowCheck" value="[alarm_id]"><label for="chk_op[INDEX]">[INDEX]</label>';
				bRow.appendChild(dCell);
			} else {
				dCell.innerHTML =  tdList[i - 1];
				bRow.appendChild(dCell);
			}
		}
		
		newHeadTable.setAttribute('class', 'sort-table history-table chk-type');
		newHeadTable.setAttribute('id', deviceType+'Table');
		tbody.setAttribute('id', deviceType);
		newContainer.setAttribute('class', 'table-scroll');
		newContainer.appendChild(newHeadTable);
		$(".table-wrap-type").append(newContainer);
	}
	
	const createAck = function (alarmId) {
		$('#alarmMeasure').modal('show').data('value', alarmId).data('ticket', '');
		ackStatusInit();
		confirmstate = alarmIdAjax(alarmId);
	}

	const alarmIdAjax = function (alarmId) {
		let confirmData = "";

		$.ajax({
			url: apiHost + '/alarms/' + alarmId,
			type: 'get',
			async: false,
			data: {
				alarmId: alarmId
			},
			success: function (result) {
				confirmData = {
					localtime: result.localtime,
					confirm: result.confirm,
					createuser: '',
					userName: '',
					status: result.status
				};

				if (result.manager == null) {
					confirmData.createuser = 'spadmin';
					confirmData.userName = 'S-POWER';
				} else {
					confirmData.createuser = result.manager.split(',')[1];
					confirmData.userName = result.manager.split(',')[0];
				}
				if ($('#alarmMeasure').data('ticket') == '') {
					if (confirmData.confirm) {
						let textStr = '';
						textStr += '[ ' + dateFormat(String(confirmData.localtime)) + ' ] by [ ' + confirmData.userName + ' ( ' + confirmData.createuser + ' ) ]\r\n';
						textStr += '미확인 -> 확인 처리\r\n';
						textStr += '----------------------------------------------\r\n';
						$('#ticket_log').append(textStr);
					}
				}
			},
			dataType: 'json',
			error: function (error) {
				console.error(error);
			}
		});
		return confirmData;
	}

	//조치상태 팝업 초기화
	const ackStatusInit = function () {
		ticketLogList = '';

		$('.upload-photo').prev().addClass('hidden');
		$('.upload-photo').find('li').remove();
		$('.report-select').prev().addClass('hidden');
		$('.report-select').find('li').remove();

		$('#alarmMeasure input').each(function() {
			$(this).val('');
		});
		$('#ticket_log').empty();

		$('#userlist button').html('<fmt:message key="default.dataNameSelect" /> &nbsp;<span class="caret"></span>');
		$('#ticket_status button').html('<fmt:message key="default.dataNameSelect" /> &nbsp;<span class="caret"></span>');
		$('#ticket_report button').html('<fmt:message key="default.dataNameSelect" /> &nbsp;<span class="caret"></span>');
		$('#maintenanceReportList button').html('<fmt:message key="default.dataNameSelect" /> &nbsp;<span class="caret"></span>');

		userListRender(oid); //OID에 속한 사용자 리스트
		reportList();
	}

	const updateAck = function (alarmId, ticketId) {
		$('#alarmMeasure').modal('show').data('value', alarmId).data('ticket', ticketId);
		ackStatusInit();

		let ticketArray = {
			oid: oid,
			alarm_id: alarmId,
			ticket_id: ticketId
		}
		confirmstate = alarmIdAjax(alarmId);

		$.ajax({
			url: apiHost + '/alarm_ticket',
			dataType: 'json',
			type: 'get',
			async: false,
			data: ticketArray,
			success: function (result) {
				let data = result.data[0];

				if (data.pic_file_link != '') {
					ticketFileList = JSON.parse(data.pic_file_link);
				}

				if (!isEmpty(data.ticket_log)) {
					ticketLogList = JSON.parse(data.ticket_log);

					$.each(ticketLogList, function (i, el) {
						let memoDate = '';
						if (typeof (el.memo_dt) == 'number') {
							memoDate = dateFormat(String(el.memo_dt));
						} else {
							memoDate = new Date(el.memo_dt).format('yyyy-MM-dd hh:mm:ss');
						}

						let textStr = '';
						textStr += '----------------------------------------------\r\n';
						if (isEmpty(el.createperson_at_memo)) {
							textStr += '[ ' + memoDate + ' ] by [ ' + loginName + '(' + loginId + ')' + ' ]\r\n';
						} else {
							textStr += '[ ' + memoDate + ' ] by [ ' + el.createperson_at_memo + ' ]\r\n';
						}
						if (el.memo.trim() != '미확인 -> 확인으로 처리') {
							textStr += '조치 상태 : ' + statusTemplate[el.status_at_memo] + ', 담당자 : ' + el.person_at_memo + '\r\n';
						}
						textStr += '메모 : ' + el.memo + '\r\n';
						if (!isEmpty(el.file_at_memo)) {
							textStr += '사진 : ' + el.file_at_memo + '\r\n';
						}
						$('#ticket_log').append(textStr);
					});

				} else {
					ticketLogList = [];
				}

				$.each(ticketFileList, function (i, el) {
					let liStr = '';
					if (ticketFileList.length > 0) {
						liStr += '<li class="flex-start"><span class="photo-text"><a href="' + apiHost + '/files/download/' + el.file_key + '?oid=' + oid + '&orgFilename=' + el.file_original_name + '">' + el.file_original_name + '</a></span>';
						liStr += '<button type="button" class="btn-close" data-time= "' + el.update_dt + '" value="' + el.file_key + '" name="file_original_name">삭제</button></li>';
					}
					$('.upload-photo ul').append(liStr);
				})

				if ($('.upload-photo li').length > 0) {
					$('.upload-photo').show();
				}

				$('#ticket_status button').html(statusTemplate[data.ticket_status] + '&nbsp;<span class="caret"></span>').data('value', data.ticket_status);

				//유져리스트
				const userIdArray = $.makeArray($('#userlist li').map(function () {
					return $(this).data('value');
				}));

				if ($.inArray(data.ticket_user_id, userIdArray) > -1) {
					$('#userlist button').html(data.ticket_person + '&nbsp;<span class="caret"></span>').data('value', data.ticket_user_id);
					$('#ticket_user_id').val(data.ticket_person).prop('readonly', true);
				} else {
					$('#userlist button').html('직접 입력 &nbsp;<span class="caret"></span>').data('value', '직접 입력');
					$('#ticket_user_id').val(data.ticket_person).prop('readonly', false);
				}
				$('#ticket_phone').val(data.ticket_phone);

				if (!isEmpty(data.ticket_report) && $('#maintenanceReportList li').length) {
					let ticketReportArray = new Array();
					if (data.ticket_report.match(',')) {
						ticketReportArray = data.ticket_report.split(',');
					} else {
						ticketReportArray.push(data.ticket_report);
					}

					$('#maintenanceReportList li').each(function() {
						const reportId = $(this).data('value');
						if (ticketReportArray.includes(reportId)) {
							const reportNm = $(this).text();
							if ($('.report-select li').length == 0) { $('.report-select').prev().removeClass('hidden'); }
							$('.report-select ul').append(`<li class="flex-start" data-value="${'${reportId}'}"><span class="report-text">${'${reportNm}'}</span><button class="btn-close">삭제</button></li>`)
						}
					});
				}
			},
			error: function (error) {
				console.error(error);
			}
		});
	}

	const ackProcess = function () {
		let ticketUserId = "";
		let ticketPerson = "";
		let ticketPhone = "";
		if (isEmpty($('#ticket_status button').data('value'))) {
			alert('<fmt:message key="alarm.alert.4" />');
			return false;
		}

		if (isEmpty($('#ticket_user_id').val())) {
			alert('<fmt:message key="alarm.alert.5" />');
			$('#ticket_user_id').focus();
			return false;
		}

		ticketUserId = $('#userlist button').data('value');
		ticketPerson = $('#userlist button').text().trim();
		ticketPhone = $('#ticket_phone').val().trim();

		if (!isEmpty(ticketUserId)) {
			ticketUserId = String(ticketUserId);
		}

		let pic_file_link = new Array();
		let fileMemo = '';
		$(':button[name="file_original_name"]').each(function (i) {
			pic_file_link.push({
				update_dt: $(this).data('time'),
				file_key: $(this).val(),
				file_original_name: $(this).parent().find('a').text(),
				upload_id: loginId
			});
			if (i == 0) {
				fileMemo = $(this).parent().find('a').text();
			} else {
				fileMemo += ', ' + $(this).parent().find('a').text();
			}
		});

		let reportArray = new Array();
		$('.report-select li').each(function() {
			let reportId = $(this).data('value');
			reportArray.push(reportId);
		});

		pic_file_link = JSON.stringify(pic_file_link);
		if (ticketLogList == '') {
			let ticketLog = [];
			if (confirmstate.confirm == true) {
				ticketLog.push({
					memo_dt: confirmstate.localtime,
					memo: '미확인 -> 확인 처리',
					status_at_memo: confirmstate.status,
					person_at_memo: confirmstate.createuser + '(' + confirmstate.createuser + ')',
					createperson_at_memo: loginName + '( ' + loginId + ' )',
					file_at_memo: ''
				});
			}

			ticketLog.push({
				memo_dt: new Date().toISOString(),
				memo: $('#memo').val(),
				status_at_memo: $('#ticket_status button').data('value'),
				person_at_memo: ticketPerson + ' ( ' + ticketUserId + ' )',
				createperson_at_memo: loginName + '( ' + loginId + ' )',
				file_at_memo: fileMemo
			});

			let alarmData = {
				alarm_confirmed_at: new Date().toISOString(),
				alarm_confirmed_by: loginId,
				ticket_status: $('#ticket_status button').data('value'),
				ticket_user_id: ticketUserId,
				ticket_person: ticketPerson,
				ticket_phone: ticketPhone,
				pic_file_link: pic_file_link,
				ticket_report: reportArray.toString(),
				ticket_log: JSON.stringify(ticketLog),
				updated_by: loginId
			};

			if (alarmData.ticket_status == '' || alarmData.ticket_user_id == '') {
				alert('<fmt:message key="alarm.alert.6" />');
			} else if (alarmData.ticket_log == '') {
				return false;
			} else {
				$.ajax({
					url: apiHost + '/alarm_ticket?oid=' + oid + '&alarm_id=' + $('#alarmMeasure').data('value'),
					dataType: 'json',
					type: 'post',
					async: false,
					contentType: 'application/json',
					data: JSON.stringify(alarmData),
					success: function (result) {
						alert('<fmt:message key="alarm.alert.7" />', '<fmt:message key="alarm.alert.7.1" />');
						$('#alarmMeasure').modal('hide');
						periodData();
					},
					error: function (error) {
						console.error(error);
					}
				});
			}
		} else {
			let ticketId = Number($('#alarmMeasure').data('ticket'));
			let beforeData = ticketLogList[ticketLogList.length - 1];

			if (beforeData.person_at_memo == $('#ticket_user_id').val() && beforeData.status_at_memo == $('#ticket_status button').data('value')) {
				if (!confirm('<fmt:message key="alarm.confirm.1" />')) {
					return false;
				}
			}

			let ticketArray = {
				oid: oid,
				alarm_id: $('#alarmMeasure').data('value'),
				ticket_id: ticketId
			}

			$.ajax({
				url: apiHost + '/alarm_ticket',
				dataType: 'json',
				type: 'get',
				async: false,
				data: ticketArray,
				success: function (result) {
					let data = result.data[0];
					ticketLogList = JSON.parse(data.ticket_log);
				},
				error: function (error) {
					console.error(error);
				}
			});

			ticketLogList.push({
				memo_dt: new Date().toISOString(),
				memo: $('#memo').val(),
				status_at_memo: $('#ticket_status button').data('value'),
				person_at_memo: ticketPerson + "(" + ticketUserId + ")",
				createperson_at_memo: loginName + ' ( ' + loginId + ' )',
				file_at_memo: fileMemo
			});

			if (!isEmpty(ticketLogList)) {

				let upAlarmData = {
					alarm_confirmed_at: new Date().toISOString(),
					alarm_confirmed_by: loginId,
					ticket_status: $('#ticket_status button').data('value'),
					ticket_user_id: ticketUserId,
					ticket_person: ticketPerson,
					ticket_phone: ticketPhone,
					pic_file_link: pic_file_link,
					ticket_report: reportArray.toString(),
					ticket_log: JSON.stringify(ticketLogList),
					updated_by: loginId
				}

				$.ajax({
					url: apiHost + '/alarm_ticket/' + ticketId + '?oid=' + oid,
					dataType: 'json',
					type: 'patch',
					async: false,
					contentType: 'application/json',
					data: JSON.stringify(upAlarmData),
					success: function (result) {
						alert('<fmt:message key="alarm.alert.7" />');
						$('#alarmMeasure').modal('hide');
						periodData();
					},
					error: function (error) {
						console.error(error);
						ticketLogList.splice(ticketLogList.length - 1, 1);
					}
				});
			} else {
				return false;
			}
		}
	}

	const measurePopup = function () {
		$('#myModal01').modal('show');
	}

	const userListRender = function (oid) {
		$.ajax({
			url: apiHost + '/config/users',
			dataType: 'json',
			type: 'get',
			async: false,
			data: {oid: oid},
			success: function (result) {
				result.forEach(user => {
					$('#userlist ul').append(`<li data-value="${'${user[\'login_id\']}'}" data-phone="${'${user[\'contact_phone\']}'}"><a href="javascript:void(0)">${'${user[\'name\']}'}</a></li>`);
				});
			},
			error: function (error) {
				console.error(error);
			}
		});
	}

	const reportList = () => {
		$('#maintenanceReportList ul').empty();

		$.ajax({
			url: apiHost + '/reports/remote_work',
			type: 'get',
			async: false,
			data: {oid: oid},
		}).done((json, textStatus, jqXHR) => {
			const data = json['data'];
			if (!isEmpty(json) && !isEmpty(data)) {
				data.forEach(rowData => {
					$('#maintenanceReportList ul').append(`<li data-value=${'${rowData.report_id}'}><a href="javascript:void(0);"> ${'${rowData.report_name}'}</a></li>`);
				});
			} else {
				$('#maintenanceReportList ul').append(`<li><a href="javascript:void(0);"><fmt:message key="alarm.noReslt" /></a></li>`);
			}
		}).fail((jqXHR, textStatus, errorThrown) => {
			const r = formatErrorMessage(jqXHR, errorThrown);
			$('#errMsg').text('처리 중 오류가 발생했습니다.' + r);
			$('#errorModal').modal('show');
			setTimeout(function(){
				$('#errorModal').modal('hide');
			}, 2000);

			$('#maintenanceReportList ul').append(`<li><a href="javascript:void(0);"><fmt:message key="alarm.noReslt" /></a></li>`);
		});
	};

	const addReportId = () => {
		const target = $('#maintenanceReportList button')
			, targetId = target.data('value')
			, targetNm = target.text();

		if ($('.report-select li').length == 0) { $('.report-select').prev().removeClass('hidden'); }
		$('.report-select ul').append(`<li class="flex-start" data-value="${'${targetId}'}"><span class="report-text">${'${targetNm}'}</span><button class="btn-close">삭제</button></li>`)
	}

	const dataFilter = function (array, key) {
		let filterArray = [];
		for (let i = 0; i < array.length; i++) {
			let data = array[i];
			if (filterArray.includes(data[key])) {
				continue;
			} else {
				filterArray.push(data[key]);
			}
		}
		return filterArray;
	}

	const gridDataFilter = function (data, statusArray, alarmArray, result) {
		let filterArray = [];
		
		$.each(result, function (i, el) {
			$.each(statusArray, function (j, e2) {
				if (e2 == 'new') {
					if(el.status == null || el.status == 'new'){
						filterArray.push(result[i]);
					}
				}else{
					if (el.status == e2) {
						filterArray.push(result[i]);
					}
				}
			})
		});
		
		$.each(filterArray, function(k, filterData){
			$.each(alarmArray, function(i, checkalarm){
				if(filterData.level == Number(checkalarm)){
					data.push(filterArray[k]);
				}
			})
		});
	}
	
	const deviceType = function (sites, sidparam) {
		if (sidparam != undefined && sidparam != "") {
			$('#equipmentList button').empty().append('<fmt:message key="alarm.search.all" /><span class="caret"></span>');
		} else {
			$('#equipmentList button').empty().append('<fmt:message key="alarm.popup.status.select" /><span class="caret"></span>');
		}
		let siteArray = new Array();
		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => {
				if (check.value !== 'all') {
					siteArray.push(check.value);
				}
			});
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				siteArray.push(checked.value);
			});
		}

		let deviceTypes = [];
		const siteOid = sites[0].oid;
		if (siteArray.length > 0) {
			const arr = deviceInternet(siteArray, siteOid);
			const deviceTypeArray = dataFilter(arr, 'device_type');
			const sidArray = dataFilter(arr, 'sid');
			deviceTypes.push(deviceTypeArray);
			deviceTypes.push(sidArray);
		}

		return deviceTypes;
	}

	const deviceInternet = function (siteArray, oid) {
		let arr = [];
		$.each(siteArray, function (i, site) {
			$.ajax({
				url: apiHost + '/config/devices/',
				type: 'get',
				async: false,
				data: {
					oid: oid,
					sid: site
				},
				success: function (data) {
					arr = arr.concat(data);
				},
				error: function (error) {
					console.error(error);
				},
				dataType: 'json'
			});

		})
		return arr;
	}
	let dateArr = new Array();

	var fetchCharts = function () {
		dateArr = new Array();
		let interval = $('#cycle button').data('value');
		let sDate = $('#fromDate').val().replace(/-/g, '');
		let eDate = $('#toDate').val().replace(/-/g, '');

		if (interval == 'day') {
			let diffDay = getDiff(eDate, sDate, 'day');
			for (let j = 0; j < diffDay; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
				sDateTime.setDate(Number(sDateTime.getDate()) + j);
				let toDate = sDateTime.format('yyyyMMdd');
				dateArr.push(toDate);
			}
		} else if (interval == 'month') {
			let diffMonth = getDiff(eDate, sDate, 'month');
			for (let j = 0; j < diffMonth; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) + j - 1, 1);
				let toDate = sDateTime.format('yyyyMM');
				dateArr.push(toDate);
			}
		} else {
			let diffDay = getDiff(eDate, sDate, 'day');
			//diffDay 1보다 크면 시작일과 종료일이 다르다.
			for (let j = 0; j < diffDay; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
				sDateTime.setDate(sDateTime.getDate() + j);
				let toDate = sDateTime.format('yyyyMMdd');

				for (let i = 0; i < 24; i++) {
					if (interval == '15min') { //15분
						if (String(i).length == 1) {
							dateArr.push(toDate + '0' + i + '0000');
							dateArr.push(toDate + '0' + i + '1500');
							dateArr.push(toDate + '0' + i + '3000');
							dateArr.push(toDate + '0' + i + '4500');
						} else {
							dateArr.push(toDate + i + '0000');
							dateArr.push(toDate + i + '1500');
							dateArr.push(toDate + i + '3000');
							dateArr.push(toDate + i + '4500');
						}
					} else if (interval == '30min') { //30분
						if (String(i).length == 1) {
							dateArr.push(toDate + '0' + i + '0000');
							dateArr.push(toDate + '0' + i + '3000');
						} else {
							dateArr.push(toDate + i + '0000');
							dateArr.push(toDate + i + '3000');
						}
					} else { //시간
						if (String(i).length == 1) {
							dateArr.push(toDate + '0' + i + '0000');
						} else {
							dateArr.push(toDate + i + '0000');
						}
					}
				}
			}
		}

		let data = changeTablegird;

		var substringCnt = 0;
		if (interval == '15min') {
			substringCnt = 12;
		} else if (interval == 'hour') {
			substringCnt = 10;
		} else if (interval == 'day') {
			substringCnt = 8;
		} else if (interval == 'month') {
			substringCnt = 6;
		}

		var gr_type = $('#rdo03_1').is(':checked');

		var chartTypeNm = (gr_type == true) ? 'deviceType' : 'alarm';
		let dataMap = new Map();

		dataMap.set(dataList[1], data);

		let columnSeriesData = new Array();
		let typeColorArr = [
			'var(--turquoise)',
			'var(--sandy-brown)',
			'var(--cream-can)',
			'var(--summer-sky)',
			'var(--orange-red)',
			'var(--blue-yonder)',
			'var(--eucalyptus)',
			'var(--sandy-brown)',
			'var(--grey)'
		];
		let alarmColorArr = {
			0: 'var(--jordy-blue)',
			1: 'var(--sandy-brown)',
			2: 'var(--mustard)',
			3: 'var(--sunglow)',
			4: 'var(--error)',
			9: 'var(--grey)'
		};

		let colorArr = (gr_type == true) ? typeColorArr : alarmColorArr;
		let num = 0;

		dataMap.forEach(function (v, k) {
			data.sort(function (a, b) {
				return a['localtime'] - b['localtime'];
			});

			let vMap = new Map();
			$.each(dateArr, function (j, stnd) {
				let stndTime = stnd.substring(0, substringCnt); //각 날짜 스트링
				var tpCntArr = new Map(); //타입 선택후 날짜별 타입현황 인덱스는 종류를 나타냄

				$.each(v, function (i, el) {
					var type = (gr_type == true) ? el.device_type : el.level;
					if (tpCntArr.get(type) == undefined) tpCntArr.set(type, 0);
					let base = String(el.localtime);
					if (stndTime == base.substring(0, substringCnt) && substringCnt < 12) {
						var cnt = tpCntArr.get(type) + 1;
						tpCntArr.set(type, cnt);
					} else {
						base = dateFilter(base.substring(0, substringCnt));
						if (stndTime == base) {
							var cnt = tpCntArr.get(type) + 1;
							tpCntArr.set(type, cnt);
						}
					}
				});

				tpCntArr.forEach(function (val, key) {
					var arr = new Array();

					if (vMap.get(key) != undefined) {
						arr = vMap.get(key);
					}
					arr.push([
						stnd, val
					]);

					vMap.set(key, arr);

				});
			});

			vMap.forEach(function (val, key) {
				if (val.length > 1000) {
					alert('<fmt:message key="alarm.alert.8" />');
				}
				var typeNm = key;

				$(':checkbox[name="' + chartTypeNm + '"]:checked').each(function () {
					if (key == $(this).val()) {
						typeNm = $(this).next('label').text();
					}
				});

				if (gr_type == true) {
					let $temp = {
						name: typeNm,
						type: 'column',
						stack: k,
						tooltip: {
							valueSuffix: '<fmt:message key="alarm.cases" />'
						},
						color: colorArr[num],
						data: val
					};
					columnSeriesData.push($temp)
					num++;
				} else {
					let $temp = {
						name: typeNm,
						type: 'column',
						stack: k,
						tooltip: {
							valueSuffix: '<fmt:message key="alarm.cases" />'
						},
						color: colorArr[key],
						data: val
					};
					columnSeriesData.push($temp)
					num++;
				}
			});

		});

		pieMap = new Map();
		$.each(data, function (i, el) {
			let tp = '';
			var type = (gr_type == true) ? el.device_type : el.level;
			let equalTy = '';
			let pieCnt = 0;

			$(':checkbox[name="' + chartTypeNm + '"]:checked').each(function () {
				tp = $(this).val();
				if (tp == type) {
					pieCnt++;
					if (gr_type == true) equalTy = eval('deviceTemplate.' + tp);
					if (gr_type == false) equalTy = levelTemplate[0][tp];
				}
			});

			if (pieMap.get(equalTy) != undefined) {
				var a = pieMap.get(equalTy);
				pieMap.set(equalTy, pieCnt + a);
			} else {
				pieMap.set(equalTy, pieCnt);
			}
		});

		pieSeriesData = new Array();

		var num2 = 0;
		var liStr = "";

		pieMap.forEach(function (val, key, legendAreaCopy) {
			var typeNm = key;
			var enName = [];
			var colorNum;

			console.log(key)
			if(key == "긴급"){
				colorNum = 4;
				enName = ["Urgent", "urgent"];
			} else if(key == "트립"){
				colorNum = 3;
				enName = ["Shutoff", "shutoff"];
			} else if(key == "이상") {
				colorNum = 2;
				enName = ["Fault", "critical"];
			} else if(key == "경고"){
				colorNum = 1;
				enName = ["Warning", "warning"];
			} else if(key == "정상"){
				colorNum = 0;
				enName = ["Info", "info"];
			} else {
				colorNum = 9;
				enName = ["Unknown", ""];
			}

			$(':checkbox[name="' + chartTypeNm + '"]:checked').each(function () {
				if (key == $(this).val()) typeNm = $(this).next('label').text();
			});

			if (val != undefined) {
				if(gr_type == true){
					$temp = {
						name: typeNm,
						dataLabels: {
							enabled: false
						},
						color: typeColorArr[num2],
						y: val
					};
					liStr += '<li data-alarm="' + (num2+1) + '">' + (key) + '<span class="legend-value">' + val + '<fmt:message key="alarm.cases" /></span></li>';

				} else {
					$temp = {
						name: typeNm,
						dataLabels: {
							enabled: false
						},
						color: colorArr[colorNum],
						y: val
					};
					liStr += '<li data-alarm="' + enName[1] + '">' + (langStatus === "EN" ? enName[0] : key) + '<span class="legend-value">' + val + '<fmt:message key="alarm.cases" /></span></li>';
				}
				num2++;
				pieSeriesData.push($temp);
				$(`#legendArea`).html("<ul>"+liStr+"</ul>");
			}
		});

		chartDraw(columnSeriesData, pieSeriesData);
		liStr = "";
	}

	const chartDraw = function (columnSeriesData, pieSeriesData) {
		let chart = $('#hchart2').highcharts();
		if (chart) {
			chart.destroy();
		}
		let myChart = {
			chart: {
				renderTo: 'hchart2',
				marginTop: 50,
				marginLeft: 0,
				marginRight: 0,
				backgroundColor: 'transparent',
				type: 'column',
				height: 360
			},
			navigation: {
				buttonOptions: {
					enabled: false
				}
			},
			title: {
				text: ''
			},
			subtitle: {
				text: ''
			},
			xAxis: {
				categories: dateArr,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				tickInterval: 1,
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				labels: {
					align: 'center',
					style: {
						color: 'var(--grey)',
						fontSize: '8px'
					},
					y: 40,
					formatter: function () {
						return dateFormat(this.value);
					}
				},
				title: {
					text: null
				},
				crosshair: true
			},
			yAxis: {
				tickColor: 'var(--grey)',
				lineColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				min: 0,
				plotLines: [{
					color: 'var(--color1)',
					width: 1
				}],
				title: {
					text: '<fmt:message key="alarm.cases" />',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 5,
					style: {
						color: 'var(--white60)',
						fontSize: '12px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -20,
					style: {
						color: 'var(--white60)',
						fontSize: '14px'
					}
				}
			},
			legend: {
				enabled: true,
				align: 'right',
				verticalAlign: 'top',
				x: 10,
				itemStyle: {
					color: 'var(--white60)',
					fontSize: '14px',
					fontWeight: 400
				},
				itemHoverStyle: {
					color: ''
				},
				symbolPadding: 3,
				symbolHeight: 8
			},
			tooltip: {
				formatter: function () {
					return this.points.reduce(function (s, point) {
						let displayValue = displayNumberFixedDecimal(point.y, '', 3, 0);
						// let displayValue = [point.y, "unit"];
						let displayNumber = displayValue[0] == undefined ? '' : displayValue[0];
						let displayUnit = displayValue[1] == undefined ? '' : '<fmt:message key="alarm.cases" />';
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + displayNumber + displayUnit;
					}, '<b>' + dateFormat(this.points[0].point.name) + '</b>');
				},
				shared: true,
				borderColor: 'none',
				backgroundColor: 'var(--bg-color)',
				padding: 16,
				style: {
					color: 'var(--white87)',
					lineHeight: '18px'
				}
			},
			plotOptions: {
				series: {
					label: {
						connectorAllowed: false
					},
					borderWidth: 0
				},
				line: {
					marker: {
						enabled: false
					}
				},
				column: {
					stacking: 'normal'
				}
			},
			credits: {
				enabled: false
			},
			series: columnSeriesData
		}

		chart = new Highcharts.Chart(myChart);
		chart.redraw();

		var myPieChart = {
			chart: {
				renderTo: 'hchart2_2',
				marginTop: 36,
				marginLeft: 0,
				marginRight: 0,
				backgroundColor: 'transparent',
				plotBorderWidth: 0,
				plotShadow: false,
				height: 270
			},

			navigation: {
				buttonOptions: {
					enabled: false /* 메뉴 안보이기 */
				}
			},

			title: {
				text: ''
			},

			subtitle: {
				text: ''
			},
			legend: {
				enabled: true,
				align: 'left',
				verticalAlign: 'bottom',
				x: -15,
				y: 0,
				itemStyle: {
					color: '#3d4250',
					fontSize: '14px',
					fontWeight: 400
				},
				itemHoverStyle: {
					color: ''
				},
				symbolPadding: 3,
				symbolHeight: 8
			},
			tooltip: {
				shared: true
			},
			plotOptions: {
				pie: {
					dataLabels: {
						enabled: false,
						style: {
							fontWeight: 'bold',
							color: 'white'
						}
					},
					center: ['50%', '50%'],
					borderWidth: 0,
					size: '100%'
				}
			},

			/* 출처 */
			credits: {
				enabled: false
			},

			/* 그래프 스타일 */
			series: [{
				type: 'pie',
				innerSize: '60%',
				colorByPoint: true,
				data: pieSeriesData
			}]

		}

		myChart3_2 = new Highcharts.Chart(myPieChart);
		myChart3_2.redraw();

	}

	const dateFilter = function (base) {
		let newbaseTime = '';
		let minute = Number(base.substring(10, 12));
		if (minute >= 0 && minute < 15) {
			newbaseTime = base.substring(0, 10) + '00';
		} else if (minute >= 15 && minute < 30) {
			newbaseTime = base.substring(0, 10) + '15';
		} else if (minute >= 30 && minute < 45) {
			newbaseTime = base.substring(0, 10) + '30';
		} else {
			newbaseTime = base.substring(0, 10) + '45';
		}
		return newbaseTime;
	}

	//두기간 사이 차이 구하기.
	const getDiff = function (eDate, sDate, type) {
		eDate = new Date(eDate.substring(2, 4), eDate.substring(4, 6), eDate.substring(6, 8));
		sDate = new Date(sDate.substring(2, 4), sDate.substring(4, 6), sDate.substring(6, 8));
		if (type == 'day') {
			return (((((eDate - sDate) / 1000) / 60) / 60) / 24) + 1;
		} else if (type == 'month') {
			if (eDate.format('yyyyMMdd').substring(0, 4) == sDate.format('yyyyMMdd').substring(0, 4)) {
				return (eDate.format('yyyyMMdd').substring(4, 6) * 1 - sDate.format('yyyyMMdd').substring(4, 6) * 1) + 1;
			} else {
				return Math.round((eDate - sDate) / (1000 * 60 * 60 * 24 * 365 / 12)) + 1;
			}
		}
	}

	//날짜포멧 변경(yyyyMMddHHmmss형)
	var dateFormat = function (val) {
		if ((val != undefined && val != 0)) {
			if (String(val).length == 4) {
				date = val.substring(0, 4)
			} else if (String(val).length == 6) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6);
			} else if (String(val).length == 12) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8) + ' ' + val.substring(8, 10) + ':' + val.substring(10, 12);
			} else if (String(val).length > 12) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8) + ' ' + val.substring(8, 10) + ':' + val.substring(10, 12) + ':' + val.substring(12, 14);
			} else {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8);
			}
		}
		return date;
	}

	const alarmConfirm = function (alarmId, ticketId) {
		$('#alarmConfirm').modal('show').data('value', alarmId).data('ticket', ticketId);
	}

	const alarmConfirmCheckAll = function (tableId) {
		if ($('#' + tableId + "Table" + '> thead tr :checkbox:checked').length == 0) {
			$('#' + tableId + "Table" + '> tbody tr :checkbox').prop('checked', false);
		} else {
			$('#' + tableId + "Table" + '> tbody tr :checkbox').prop(	'checked', true);
		}
	}

	const alarmConfirmAll = function (tableId) {
		if ($('#' + tableId + 'Table > tbody tr :checkbox:checked').length == 0) {
			alert('<fmt:message key="alarm.alert.9" />');
			return false;
		} else {
			let cnt = 0;
			$('#' + tableId + 'Table > tbody tr :checkbox:checked').each(function () {
				let data = {
					confirm: true
				}

				$.ajax({
					url: apiHost + '/alarms/' + $(this).val(),
					type: 'patch',
					dataType: 'json',
					async: false,
					contentType: 'application/json',
					data: JSON.stringify(data),
					success: function (result) {
						cnt++;
					}
				});
			});

			alert(cnt + '개의 알람을 확인했습니다.');
			$('#search').trigger('click');
		}
	}

	const alarmConfirmProcess = function () {
		let alarmId = $('#alarmConfirm').data('value');
		let ticketId = Number($('#alarmConfirm').data('ticket'));
		let preStatus = "";

		if (isNaN(ticketId) == false) {
			let ticketArray = {
				oid: oid,
				alarm_id: $('#alarmConfirm').data("value"),
				ticket_id: Number($('#alarmConfirm').data('ticket'))
			}

			let prevData = {
				ticket_status: '',
				ticket_user_id: '',
				ticket_person: '',
				pic_file_link: '',
			}

			$.ajax({
				url: apiHost + '/alarm_ticket',
				dataType: 'json',
				type: 'get',
				async: false,
				data: ticketArray,
				success: function (result) {
					let data = result.data[0];
					ticketLogList = JSON.parse(data.ticket_log);
					prevData = {
						ticket_status: data.ticket_status,
						ticket_user_id: data.ticket_user_id,
						ticket_person: data.ticket_person,
						pic_file_link: data.pic_file_link,
						file_at_memo: ticketLogList[0].file_at_memo
					}
				},
				error: function (error) {
					console.error(error);
				}
			});

			ticketLogList.push({
				memo_dt: new Date().toISOString(),
				memo: '미확인 -> 확인으로 처리',
				status_at_memo: prevData.ticket_status,
				person_at_memo: prevData.ticket_person + '( ' + prevData.ticket_person + ' )',
				createperson_at_memo: loginName + '( ' + loginId + ' )',
				file_at_memo: prevData.file_at_memo
			});

			let upAlarmData = {
				alarm_confirmed_at: new Date().toISOString(),
				alarm_confirmed_by: loginId,
				ticket_status: prevData.ticket_status,
				ticket_user_id: prevData.ticket_user_id,
				ticket_person: prevData.ticket_person,
				pic_file_link: prevData.pic_file_link,
				ticket_log: JSON.stringify(ticketLogList),
				updated_by: loginId
			}

			$.ajax({
				url: apiHost + '/alarm_ticket/' + ticketId + '?oid=' + oid,
				dataType: 'json',
				type: 'patch',
				async: false,
				contentType: 'application/json',
				data: JSON.stringify(upAlarmData),
				success: function (result) {
					console.log(result)
				},
				error: function (error) {
					console.error(error);
					ticketLogList.splice(ticketLogList.length - 1, 1);
				}
			});
		}

		$.ajax({
			url: apiHost + '/alarms/' + alarmId,
			type: 'patch',
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify({
				confirm: true,
				manager: loginName + ',' + loginId
			}),
			success: function (result) {
				alert('<fmt:message key="alarm.alert.10" />');
				$('#alarmConfirm').modal('hide').data('value', '');
				$('#search').trigger('click');
			},
			dataType: 'json'
		});
	}
</script>
