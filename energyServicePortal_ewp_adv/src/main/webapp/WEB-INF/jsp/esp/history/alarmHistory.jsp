<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<!-- 파일 업로드 폼 -->
<script src="/js/commonDropdown.js"></script>
<form id="picupload" name="upload" method="multipart/form-data">
</form>

<div id="alarmConfirm" class="modal fade" role="dialog">
	<div class="modal-dialog his_alarm">
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit">알람 상태</h2>
				<p class="tx_line1">"확인" 처리 하시겠습니까?</p>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">아니오</button>
				<button type="button" class="btn_type" onclick="alarmConfirmProcess();">예</button>
			</div>
		</div>
	</div>
</div>

<div id="alarmMeasure" class="modal fade" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content alarm_modal_content">
			<div class="modal-header">
				<h2><fmt:message key="alertshistory.4.acknowledgement" /></h2>
			</div>
			<div class="modal-body">
				<div class="ly_wrap">
					<div class="flex_wrap_top">
						<span class="input_label">조치 이력</span>
						<textarea id="ticket_log" name="ticket_log" class="textarea" readonly></textarea>
					</div>
					<div class="flex_wrap">
						<span class="input_label">사진 올리기</span>
						<div class="tx_inp_type">
							<input type="text" id="photoFile" name="photoFile" placeholder="사진 파일 이름" readonly=""
								autocomplete="off">
						</div>
						<div class="type">
							<button type="button" id="fileUpload" class="btn_type">업로드</button>
							<input type="file" id="picture" name="filename" class="uploadBtn hidden"/>
							<span class="upload_text ml-16 hidden"></span>
						</div>
					</div>

					<div class="photo_load_wrap">
						<hr>
						<ul>
						</ul>
						<hr>
					</div>

					<div class="flex_wrap">
						<span class="input_label">조치 여부</span>
						<div class="dropdown placeholder" id="ticket_status">
							<button type="button" class="dropdown-toggle required" placeholder="선택"
								data-toggle="dropdown"><span class="caret"></span></button>
							<ul class="dropdown-menu">
								<li data-value="new"><a href="javascript:void(0);">신규</a></li>
								<li data-value="open"><a href="javascript:void(0);">작업 처리 중</a></li>
								<li data-value="on-hold"><a href="javascript:void(0);">추가 정보 대기</a></li>
								<li data-value="resolved"><a href="javascript:void(0);">현장 조치 완료</a></li>
								<li data-value="pending"><a href="javascript:void(0);">처리 결과 확인</a></li>
								<li data-value="closed"><a href="javascript:void(0);">처리 완료</a></li>
							</ul>
						</div>
					</div>
					<hr>

					<div class="flex_wrap">
						<span class="input_label">담당자</span>
						<div class="dropdown placeholder" id="userlist">
							<button type="button" class="dropdown-toggle required"
								data-toggle="dropdown">선택<span class="caret"></span></button>
							<ul class="dropdown-menu">
							</ul>
						</div>
						<div class="tx_inp_type ml-12 w200">
							<input type="text" id="ticket_user_id" name="ticket_user_id" placeholder="직접 입력" readonly autocomplete="off">
						</div>
					</div>

					<hr>

					<div class="flex_wrap">
						<span class="input_label">조치 메모</span>
						<textarea id="memo" name="memo" class="textarea"></textarea>
					</div>
					<div class="btn_wrap_type02">
						<button type="button" class="btn_type03" data-dismiss="modal">취소</button>
						<button type="button" class="btn_type" onclick="ackProcess();">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">알람 이력</h1>
	</div>
</div>


<div class="row history_search">
	<div class="col-12">
		<form id="alarmHistorySearchForm">
			<div class="sa_select">
				<div class="dropdown" id="site">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택해주세요.">선택해주세요<span class="caret"></span></button>
					<ul class="dropdown-menu chk_type" role="menu" id="siteList">
						<li data-value="[sid]">
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
								<label for="site_[INDEX]">[name]</label>
							</a>
						</li>
					</ul>
				</div>
			</div>

			<div id="searchDetail" class="search_expand sa_select">
				<button type="button" class="btn clear-btn" data-target="#searchDropdown" data-name="상세 조건" onclick="$('#searchDetail').toggleClass('open')">상세 검색<span class="caret"></span></button>
				<div id="searchDropdown" class="dropdown-menu search_dropdown">
					<div class="flex_start3">
						<div class="sa_select">
							<h2 class="tx_tit"><fmt:message key="alertshistory.1.devicetype" /></h2>
							<div id="equipmentList" class="dropdown">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
									선택<span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu" id="device">
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
					<div class="flex_start3">
						<div class="sa_select">
							<h2 class="tx_tit">알람 종류</h2>
							<div class="dropdown">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택"><fmt:message key="alertshistory.1.all" /><span class="caret"></span></button>
								<ul class="dropdown-menu chk_type" role="menu">
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm1" value="9" name="alarm" checked>
											<label for="alarm1">알수없음</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm2" value="0" name="alarm" checked>
											<label for="alarm2">정보</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm3" value="1" name="alarm" checked>
											<label for="alarm3">경고</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm4" value="2" name="alarm" checked>
											<label for="alarm4">이상</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm5" value="3" name="alarm" checked>
											<label for="alarm5">트립</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alarm6" value="4" name="alarm" checked>
											<label for="alarm6">정상</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="sa_select">
							<h2 class="tx_tit"><fmt:message key="alertshistory.4.alertstatus" /></h2>
							<div class="dropdown short" id="alarmstatus">	
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">미확인<span class="caret"></span></button>
								<ul class="dropdown-menu chk_type" role="menu" id="alstatus">
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alstatus1" name="confirm">
											<label for="alstatus1">확인</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="alstatus2" name="confirm" checked>
											<label for="alstatus2">미확인</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="sa_select">
							<h2 class="tx_tit"><fmt:message key="alertshistory.4.acknowledgement" /></h2>
							<div class="dropdown">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">전체<span class="caret"></span></button>
								<ul class="dropdown-menu chk_type" role="menu" id="status">
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status1" name="status" value="new" checked>
											<label for="status1">신규</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status2" name="status" value="open" checked>
											<label for="status2">작업처리중</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status3" name="status" value="on-hold" checked>
											<label for="status3">추가 정보 대기</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status4" name="status" value="resolved" checked>
											<label for="status4">현장 조치 완료</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status5" name="status" value="pending" checked>
											<label for="status5">처리 결과 확인</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0)" tabindex="-1">
											<input type="checkbox" id="status7" name="status" value="closed" checked>
											<label for="status7">처리 완료</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="flex_start3 dateField">
						<div class="sa_select">
							<h2 class="tx_tit"><fmt:message key="alertshistory.1.timeframe" /></h2>
							<div class="dropdown short">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown">1일<span class="caret"></span></button>
								<ul class="dropdown-menu" role="menu" id="term">
									<li data-value="day"><a href="javascript:void(0)">1일</a></li>
									<li class="on" data-value="week"><a href="javascript:void(0)">1주</a></li>
									<li data-value="month"><a href="javascript:void(0)">1월</a></li>
									<li data-value="setup"><a href="javascript:void(0)">기간설정</a></li>
								</ul>
							</div>
						</div>
						<div class="sa_select">
							<label class="tx_tit" for="fromDate"><fmt:message key="alertshistory.1.period" /></label>
							<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="" autocomplete="off">
						</div>
						<div class="sa_select">
							<label for="toDate" class="tx_tit"></label>
							<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off">
						</div>
						<div class="sa_select">
							<h2 class="tx_tit">단위</h2>
							<div id="cycle" class="dropdown short">
								<button type="button" class="dropdown-toggle interval" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul class="dropdown-menu" id="detailterm">
									<li data-value="15min"><a href="javascript:void(0);">15분</a></li>
									<li data-value="hour"><a href="javascript:void(0);">1시간</a></li>
									<li data-value="day"><a href="javascript:void(0);">1일</a></li>
									<li data-value="month"><a href="javascript:void(0);">1월</a></li>
								</ul>
							</div>
						</div>
					</div>
										
					<div class="btn_wrap_type05">
						<button type="button" class="btn_type03 w80" onclick="$('#searchDetail').removeClass('open')">취소</button><!--
					--><button type="button" class="btn_type w80 ml-12" onclick="$('#searchDetail').removeClass('open')">적용</button>
					</div>
				</div>

				<div class="sa_select">
					<button type="button" id="search" class="btn_type ml-6"><fmt:message key="alertshistory.1.update" /></button>
				</div>
			</div>
		</form>			
	</div>
</div>


<div class="row">
	<div class="col-xl-8 col-lg-9 col-md-6 col-sm-12">
		<div class="indiv alarm_stat_wrapper">
			<div class="alarm_header">
				<h2 class="ntit fl"><fmt:message key="alertshistory.2.alertstatus" /></h2>
				<div class="his_inp_bx">
					<div class="rdo_type his_rdo_bx" id="chartType">
						<span>
							<input type="radio" id="rdo03_1" name="chartType" value="type" checked>
							<label for="rdo03_1"><fmt:message key="alertshistory.2.devicetype" /></label>
						</span>
						<span>
							<input type="radio" id="rdo03_2" name="chartType" value="alarm">
							<label for="rdo03_2"><fmt:message key="alertshistory.2.alerttype" /></label>
						</span>
					</div>
				</div>
			</div>
			<div class="inchart">
				<div id="hchart2"></div>
			</div>
		</div>
	</div>
	<div class="col-xl-4 col-lg-3 col-md-6 col-sm-12">
		<div class="indiv alarm_pie_wrapper">
			<div class="inchart">
				<div id="hchart2_2">
				</div>
			</div>
			<div id="legendArea" class="chart_legend_area">
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="indiv alarm_detail_wrapper">
			<div class="tbl_wrap_type">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	let dataList = [];
	let changeTablegird = null;
	let ticketFileList = new Array();
	let ticketLogList = new Array();
	let confirmstate = "";
	const sidparam = "${param.sid}";
	let sites = JSON.parse('${siteList}');
	const deviceTemplate = new Array();

	const levelTemplate = {
		9: '알수없음',
		0: '정보',
		1: '경고',
		2: '이상',
		3: '트립',
		4: '정상'
	};
	const statusTemplate = {
		'null': '신규',
		'new': '신규',
		'open': '작업처리중',
		'on-hold': '추가 정보 대기',
		'resolved': '현장 조치 완료',
		'pending': '처리 결과 확인',
		'closed': '처리 완료',
	};

	<!-- properties 조회 -->
	const deviceProperties = async () => {
		$.ajax({
			url: apiHost + '/config/view/device_properties',
			type: 'get',
			async: false,
			data: {},
			success: function (result) {
				Object.entries(result).map(obj => {
					deviceTemplate[obj[0]] = obj[1].name.kr;
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

		$('.rdo_type').on('click', function () {
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
			$('#detailterm').prev().html('1일 &nbsp;<span class="caret"></span>').data('value', 'day');
			periodData();
			fetchCharts();
			$('#search').trigger('click');
		}

		$('#search').on('click', function () {
			let period = $('#term').prev().text();
			let detailperiod = $('#detailterm').prev().text().trim();
			if (detailperiod == '선택' || detailperiod == '' || detailperiod == "undefined") {
				alert('시간단위를 선택해주세요.');
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
					liStr += '<li class="flex_start"><span class="pt_tx"><a href="' + apiHost + '/files/download/' + result.files[0].fieldname + '?oid=' + oid + '&orgFilename=' + result.files[0].originalname + '">' + result.files[0].originalname + '</a></span>';
					liStr += '<button type="button" class="btn_close" data-time="' + new Date().toISOString() + '" value="' + result.files[0].fieldname + '" name="file_original_name">삭제</button></li>';
				}
				$('.photo_load_wrap ul').append(liStr);

				if ($('.photo_load_wrap').css('display') == 'none') {
					$('.photo_load_wrap').show();
				}
			},
			error: function (error) {
				console.error(error);
			}
		});
	});

	$(document).on('click', 'button[name="file_original_name"]', function () {
		$(this).parent().remove();
	});

	$(document).on('click', '#userlist li', function () {
		if ($(this).text() == '직접 입력') {
			$('#ticket_user_id').val('').prop('readonly', false);
		} else {
			$('#ticket_user_id').val($(this).data('value').split(',')[0]).prop('readonly', true);
		}
	});

	const rtnDropdown = function (id) {
		if (id == 'site') {
			deviceTypeList();
		}
	}
	
	const siteList = function (sidparam) {
		let siteList = [];
		setMakeList(sites, 'siteList', {
			'dataFunction': {}
		});	//list생성
		
		if (sidparam == '' || sidparam == undefined) {
			$(':checkbox[name="site"]').prop('checked', false);
		} else if(sidparam == 'all'){
			$(':checkbox[name="site"]').prop('checked', true);
		} else{
			$.each(sites, function(i, el){
				let checkcnt = '';
				if(el.sid == sidparam){
					$(':checkbox[name="site"]').eq(i).prop('checked', true);
				}
			});
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
		
		deviceList.sort(function(a, b){
			let atype = a['type'].toUpperCase();
			let btype = b['type'].toUpperCase();
			if(atype > btype){
				return 1;
			}
			if(btype > atype){
				return -1;
			}
			return 0;
		});
		
		setMakeList(deviceList, 'device', {
			'dataFunction': {}
		});
		
		if (sidparam == '' || sidparam == undefined) {
			$(':checkbox[name="deviceType"]').prop('checked', false);
		} else {
			$(':checkbox[name="deviceType"]').prop('checked', true);
		}
	};

	const periodData = function () {
		$('.tbl_wrap_type').empty();

		if ($(':checkbox[name="deviceType"]:checked').length == 0) {
			alert('설비유형을 한개이상 선택해 주세요.');
			return false;
		}

		if ($(':checkbox[name="alarm"]:checked').length == 0) {
			alert('알람유형을 한개이상 선택해 주세요.');
			return false;
		}

		$('.his_tbl tbody').empty();

		let alarmData = "";
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
		if ($(':checkbox[name="confirm"]:checked').length == 2) {
			alarmData = {
				sids: dataList[1].join(','),
				deviceTypes: deviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
			}
		} else {
			let confirm = "";
			if ($(':checkbox[name="confirm"]:checked').next('label').text() === '미확인') {
				confirm = false;
			} else {
				confirm = true;
			}
			alarmData = {
				sids: dataList[1].join(','),
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
				// console.log(data);
				gridDataFilter(data, statusArray, alarmArray, result); //알람 및 조치상태 필터링
				
				changeTablegird = data;
				
				for(let i in deviceArray){
					jsonList.push(new Array());
				}
				
				$('.his_tbl').remove();
				
				for(let i in data){
					var temp = data[i];
					
					data[i].localtime = temp.localtime; // 알람발생시간
					data[i].tlocaltime = dateFormat(String(temp.localtime)); // 테이블에 보여질 알람발생시간
					data[i].alarmtype = ((isEmpty(temp.level)) ? '-' : levelTemplate[temp.level]); // 테이블에 보여질 알람타입;
					data[i].level = temp.level; // 알람타입
					data[i].message = ((isEmpty(temp.message)) ? "" : temp.message); // 알람메시지
					
					if (temp.confirm == false) {
						data[i].confirm  = '<a href="javascript:alarmConfirm(\'' + temp.alarm_id + '\',\'' + temp.ticket_id + '\');" class="tbl_link" >미확인</a>'; // 알람상태
					} else {
						data[i].confirm = '확인'; // 알람상태
					}
					
					if (!(isEmpty(temp.status))) {
						data[i].status = '<a href="javascript:updateAck(\'' + temp.alarm_id + '\',\'' + temp.ticket_id + '\');" class="tbl_link" >' + statusTemplate[temp.status] + '</a>'; // 조치상태
					} else {
						data[i].status = '<a href="javascript:createAck(\'' + temp.alarm_id + '\');" class="tbl_link" >신규</a>'; // 조치상태
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
		divStr += '<div class="tbl_top clear">';
		divStr += '<h2 class="ntit fl">' + deviceTemplate[deviceType] + '</h2>';
		divStr += '<button type="button" class="btn_type03 fr" onclick="alarmConfirmAll(\'' + deviceType + '\');">일괄 확인</button>';
		divStr += '</div>';
		$(".tbl_wrap_type").append(divStr);
	}
	
	const makeTableHead = function (deviceType) {
		let newHeadTable = document.createElement('table');
		let colList = ['사업소', '장치명', '알람 시간', '알람 타입', '알람 메세지', '확인 여부', '조치 상태', '최종 업데이트 시간'];
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
				hCell.innerHTML = '<button type="button" class="btn_align">' + colList[i - 1] + '</button>';
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
		
		newHeadTable.setAttribute('class', 'sort_table his_tbl chk_type');
		newHeadTable.setAttribute('id', deviceType+'Table');
		tbody.setAttribute('id', deviceType);
		$(".tbl_wrap_type").append(newHeadTable);
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
		$('.photo_load_wrap').hide().find('li').remove();
		$('#ticket_log').empty();
		$('#memo').val('');
		ticketLogList = '';
		$('#userlist button').html('선택 &nbsp;<span class="caret"></span>');
		$('#ticket_status button').html('선택 &nbsp;<span class="caret"></span>');
		$('#ticket_user_id').val('');
		userListRender(oid); //OID에 속한 사용자 리스트
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
						liStr += '<li class="flex_start"><span class="pt_tx"><a href="' + apiHost + '/files/download/' + el.file_key + '?oid=' + oid + '&orgFilename=' + el.file_original_name + '">' + el.file_original_name + '</a></span>';
						liStr += '<button type="button" class="btn_close" data-time= "' + el.update_dt + '" value="' + el.file_key + '" name="file_original_name">삭제</button></li>';
					}
					$('.photo_load_wrap ul').append(liStr);
				})

				if ($('.photo_load_wrap li').length > 0) {
					$('.photo_load_wrap').show();
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

			},
			error: function (error) {
				console.error(error);
			}
		});
	}

	const ackProcess = function () {
		let ticketUserId = "";
		let ticketPerson = "";
		if ($('#ticket_status button').data('value') == '') {
			alert('조치 여부가 선택되지 않았습니다.');
			return false;
		}

		if ($('#ticket_user_id').val() == '') {
			alert('담당자가 입력되지 않았습니다.');
			$('#ticket_user_id').focus();
			return false;
		}

		if ($("#userlist button").text() == "직접 입력") {
			ticketUserId = $('#ticket_user_id').val();
			ticketPerson = $('#ticket_user_id').val();
		} else {
			ticketUserId = $('#userlist button').data('value');
			ticketPerson = $('#userlist button').text().trim();
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
				pic_file_link: pic_file_link,
				ticket_log: JSON.stringify(ticketLog),
				updated_by: loginId
			};

			if (alarmData.ticket_status == '' || alarmData.ticket_user_id == '') {
				alert('알람상태와 회원 아이디를 꼭 입력해주세요');
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
						alert('저장에 성공했습니다.', '저장');
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
				if (!confirm('변경 사항이 없습니다. 정말 계속 진행 하시겠습니까?')) {
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
					pic_file_link: pic_file_link,
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
						alert('저장에 성공했습니다.');
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
		$('#userlist ul').empty().append('<li data-value="직접 입력"><a href="javascript:void(0)">직접 입력</a></li>');
		$.ajax({
			url: apiHost + '/config/users',
			dataType: 'json',
			type: 'get',
			async: false,
			data: {
				oid: oid
			},
			success: function (result) {
				let data = result;
				$.each(data, function (i, el) {
					let liStr = '';
					liStr += '<li data-value="' + el.login_id + '"><a href="javascript:void(0)">' + el.name + '</a></li>';
					$('#userlist ul').append(liStr);
				})
			},
			error: function (error) {
				console.error(error);
			}
		});
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
			$('#equipmentList button').empty().append('전체<span class="caret"></span>');
		} else {
			$('#equipmentList button').empty().append('설비유형<span class="caret"></span>');
		}
		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			}
		));
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
			2: 'var(--sunglow)',
			3: 'var(--white60)',
			4: 'var(--alarm)',
			9: ''
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
					alert('조회 단위 대비 조회기간이 너무 길어 차트가 생성이 안될 수 있으니 기간을 조정하여 다시 조회 해주세요');
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
							valueSuffix: '건'
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
							valueSuffix: '건'
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
					if (gr_type == false) equalTy = levelTemplate[tp];
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
		var legendInner = $('#legendArea');
		var wrapper = `
			<ul class="chart_legend col"></ul>
		`;
		legendInner.empty();
		legendInner.append(wrapper);
		pieMap.forEach(function (val, key, legendAreaCopy) {
			var typeNm = key;
			$(':checkbox[name="' + chartTypeNm + '"]:checked').each(function () {
				if (key == $(this).val()) typeNm = $(this).next('label').text();
			});
			if (val != undefined) {
				$temp = {
					name: typeNm,
					dataLabels: {
						enabled: false
					},
					color: colorArr[num2],
					y: val
				};
				pieSeriesData.push($temp);
				num2++
				var liStr = '<li><span class="bu t'+num2+'">' + key + '</span><span class="legend_val">' + val + '건</span></li>';
				legendInner.find("ul").append(liStr);
			}
		});

		chartDraw(columnSeriesData, pieSeriesData);
	}

	const chartDraw = function (columnSeriesData, pieSeriesData) {
		let chart = $('#hchart2').highcharts();
		if (chart) {
			chart.destroy();
		}
		let myChart = {
			chart: {
				renderTo: 'hchart2',
				marginTop: 70,
				marginLeft: 0,
				marginRight: 0,
				backgroundColor: 'transparent',
				type: 'column',
				height: 340
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
			xAxis: {
				labels: {
					align: 'center',
					style: {
						color: 'var(--white)',
						fontSize: '8px'
					},
					y: 40,
					formatter: function () {
						return dateFormat(this.value);
					}
				},
				categories: dateArr,
				tickInterval: 1,
				title: {
					text: null
				},
				crosshair: true /* 포커스 선 */
			},
			yAxis: {
				gridLineWidth: 1,
				lineColor: 'var(--color1)',
				tickColor: 'var(--color1)',
				gridLineColor: 'var(--color1)',
				min: 0,
				plotLines: [{
					color: 'var(--color1)',
					width: 1
				}],
				title: {
					text: '건',
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
					/* 그래프와의 거리 조정 */
					style: {
						color: 'var(--white60)',
						fontSize: '14px'
					}
				}
			},

			/* 범례 */
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
					color: '' /* 마우스 오버시 색 */
				},
				symbolPadding: 3,
				/* 심볼 - 텍스트간 거리 */
				symbolHeight: 8 /* 심볼 크기 */
			},

			/* 툴팁 */
			tooltip: {
				formatter: function () {
					return this.points.reduce(function (s, point) {
						let displayValue = displayNumberFixedDecimal(point.y);
						let displayNumber = displayValue[0] == undefined ? '' : displayValue[0];
						let displayUnit = displayValue[1] == undefined ? '' : '건';
						// console.log(displayUnit);
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + displayNumber + displayUnit;
					}, '<b>' + dateFormat(this.points[0].point.name) + '</b>');
				},
				shared: true
			},

			/* 옵션 */
			plotOptions: {
				series: {
					label: {
						connectorAllowed: false
					},
					borderWidth: 0 /* 보더 0 */
				},
				line: {
					marker: {
						enabled: false /* 마커 안보이기 */
					}
				},
				column: {
					stacking: 'normal'
				}
			},

			/* 출처 */
			credits: {
				enabled: false
			},

			/* 그래프 스타일 */
			series: columnSeriesData
		}

		chart = new Highcharts.Chart(myChart);
		chart.redraw();

		var myPieChart = {
			chart: {
				renderTo: 'hchart2_2',
				marginTop: 0,
				marginLeft: 0,
				marginRight: 0,
				backgroundColor: 'transparent',
				plotBorderWidth: 0,
				plotShadow: false,
				height: 240
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

			/* 범례 */
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
					color: '' /* 마우스 오버시 색 */
				},
				symbolPadding: 3,
				/* 심볼 - 텍스트간 거리 */
				symbolHeight: 8 /* 심볼 크기 */
			},

			/* 툴팁 */
			tooltip: {
				shared: true /* 툴팁 공유 */
			},

			/* 옵션 */
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
			alert('확인할 알람이 선택되지않았습니다.');
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
					// console.log(data);
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
		let data = {
			confirm: true,
			manager: loginName + ',' + loginId
		}
		$.ajax({
			url: apiHost + '/alarms/' + alarmId,
			type: 'patch',
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify(data),
			success: function (result) {
				alert('확인 처리 되었습니다.');
				$('#alarmConfirm').modal('hide').data('value', '');
				$('#search').trigger('click');
			},
			dataType: 'json'
		});
	}
</script>
