<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<!-- Modal (확인 여부)-->
<div id="alarmConfirm" class="modal fade" role="dialog">
	<div class="modal-dialog his_alarm">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit">알람 상태</h2>
				<p class="tx_line1">"확인" 처리 하시겠습니까?</p>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" data-dismiss="modal">아니오</button>
				<button type="button" class="btn_type" onclick="alarmConfirmProcess();">예</button>
			</div>
		</div>
	</div>
</div>

<!-- Modal (조치 상태)-->
<div id="myModal02" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit">조치 상태</h2>
				<div class="spc_tbl02_row">
					<table>
						<colgroup>
							<col style="width:157px">
							<col style="width:365px">
							<col style="width:156px">
							<col style="width:364px">
						</colgroup>
						<tbody>
						<tr>
							<th class="vert_type">조치 이력</th>
							<td colspan="3">
								<div class="txarea_inp_type lh_type">
								<textarea id="description" name="description" rows="10" readonly>
									[2020-05-04 16:14] by [sj.kim]
									조치 상태: On Hold, 담당자: 김세준
									(조치메모)
									--------------------------------------------------
									[2020-05-04 16:13] by [sj.kim]
									조치 상태: On Hold, 담당자: 김세준
									(조치메모)
									--------------------------------------------------
									[2020-05-04 16:12] by [sj.kim]
									확인으로 상태 변경
									--------------------------------------------------
									[2020-05-04 16:10] 최초 발생
								</textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">사진 올리기</th>
							<td colspan="3">
								<div class="tx_btn_area type">
									<div class="tx_inp_type">
										<input type="text" id="">
									</div>
									<button type="submit" class="btn_type">업로드</button>
								</div>
								<div class="photo_load_wrap">
									<ul>
										<li>
											<span class="pt_tx">사진 경로</span>
											<span class="pt_load">업로드 날짜 / 업로더 아이디</span>
											<button class="btn_del">삭제</button>
										</li>
										<li>
											<span class="pt_tx">사진 경로</span>
											<span class="pt_load">업로드 날짜 / 업로더 아이디</span>
											<button class="btn_del">삭제</button>
										</li>
									</ul>
								</div>
							</td>
						</tr>
						<tr>
							<th>조치 여부</th>
							<td>
								<div class="dropdown placeholder">
									<button class="btn btn-primary dropdown-toggle required" type="button"
									        data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li><a href="#">신규</a></li>
										<li><a href="#">작업 처리 중</a></li>
										<li><a href="#">추가 정보 대기</a></li>
										<li><a href="#">현장 조치 완료</a></li>
										<li><a href="#">처리 결과 확인</a></li>
										<li><a href="#">처리 완료</a></li>
									</ul>
								</div>
							</td>
							<th>담당자</th>
							<td>
								<div class="clear">
									<div class="dropdown placeholder fl" style="width:160px">
										<button class="btn btn-primary dropdown-toggle required" type="button"
										        data-toggle="dropdown">선택<span class="caret"></span></button>
										<ul class="dropdown-menu">
											<li><a href="#">유저1</a></li>
											<li><a href="#">유저2</a></li>
											<li><a href="#">유저3</a></li>
										</ul>
									</div>
									<div class="tx_inp_type fl ml" style="width:160px">
										<input type="text" id="alarmPhone" name="alarmPhone" placeholder="직접 입력">
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">조치 메모</th>
							<td colspan="3">
								<div class="txarea_inp_type lh_type">
									<textarea id="description2" name="description2" rows="7">확인으로 상태 변경</textarea>
								</div>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" data-dismiss="modal">취소</button>
				<button type="button" class="btn_type">확인</button>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">알람 이력</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv his_chart_top clear">
			<div class="sa_select fl" id="siteList">
				<div class="dropdown">
					<button class="btn btn-primary dropdown-toggle w10" type="button" data-toggle="dropdown">
						선택해주세요.<span class="caret"></span>
					</button>
					<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu"></ul>
				</div>
			</div>
			<div class="fl">
				<span class="tx_tit">설비 유형</span>
				<div id="equipmentList" class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">선택
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="device">
<!-- 							<li class="dropdown_cov type"> -->
<!-- 								<div class="sec_li_bx"> -->
<!-- 									<p class="tx_li_tit">사업소별</p> -->
<!-- 									<a href="#" tabindex="-1"> -->
<!-- 										<input type="checkbox" id="device_1" value="INV_PV"> -->
<!-- 										<label for="device_1"><span></span>태양광 인버터</label> -->
<!-- 									</a> -->
<!-- 								</div> -->
<!-- 							</li> -->
						</ul>
					</div>
				</div>
			</div>
			<div class="fl">
				<span class="tx_tit">알람 타입</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">전체
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu chk_type" role="menu">
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alarm1" value="9" name="alarm" checked>
									<label for="alarm1"><span></span>알수없음</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alarm2" value="0" name="alarm" checked>
									<label for="alarm2"><span></span>정보</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alarm3" value="1" name="alarm" checked>
									<label for="alarm3"><span></span>경고</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alarm4" value="2" name="alarm" checked>
									<label for="alarm4"><span></span>이상</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alarm5" value="3" name="alarm" checked>
									<label for="alarm5"><span></span>트립</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alarm6" value="4" name="alarm" checked>
									<label for="alarm6"><span></span>정상</label>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="fl">
				<span class="tx_tit">알람 상태</span>
				<div class="sa_select">
					<div class="dropdown" id="alarmstatus">
						<button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">전체
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="alstatus">
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alstatus1" name="confirm">
									<label for="alstatus1"><span></span>확인</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="alstatus2" name="confirm" checked>
									<label for="alstatus2"><span></span>미확인</label>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="fl">
				<span class="tx_tit">조치 상태</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">전체
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="status">
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="status1" name="status" value="null" checked>
									<label for="status1"><span></span>신규</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="status2" name="status" value="open" checked>
									<label for="status2"><span></span>작업처리중</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="status3" name="status" value="pending" checked>
									<label for="status3"><span></span>추가 정보 대기</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="status4" name="status" value="resolved" checked>
									<label for="status4"><span></span>현장 조치 완료</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="status5" name="status" value="on-hold" checked>
									<label for="status5"><span></span>처리 결과 확인</label>
								</a>
							</li>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" id="status6" name="status" value="closed" checked>
									<label for="status6"><span></span>처리 완료</label>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv his_chart_top clear">
			<div class="fl">
				<span class="tx_tit">조회 기간</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">1일
							<span class="caret"></span></button>
						<ul class="dropdown-menu" id="term">
							<li data-value="day"><a href="#">1일</a></li>
							<li class="on" data-value="week"><a href="#">1주</a></li>
							<li data-value="month"><a href="#">1월</a></li>
							<li data-value="setup"><a href="#">기간설정</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="fl">
				<span class="tx_tit" id="dateArea">기간 설정</span>
				<div class="sel_calendar">
					<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" style="width:140px">
					<em>-</em>
					<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" style="width:140px">
				</div>
			</div>
			<div class="fl">
				<button type="button" id="search" class="btn_type">조회</button>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-8">
		<div class="indiv">
			<div class="his_chart_top clear">
				<div class="clear">
					<h2 class="s_tit">알람 현황</h2>
				</div>
				<!-- 기본 항목 -->
				<div class="clear">
					<div class="fr his_inp_bx">
					    <div class="rdo_type his_rdo_bx" id="chartType">
						    <span>
								<input type="radio" id="rdo03_1" name="radio" value="type" checked>
								<label for="rdo03_1"><span></span>설비 타입</label>
							</span>
					        <span>
								<input type="radio" id="rdo03_2" name="radio" value="alarm">
								<label for="rdo03_2"><span></span>알람 타입</label>
							</span>
					    </div>
					</div>
				</div>
			</div>
			<br>
			<br>
			<div class="inchart">
				<div id="hchart2"></div>
			</div>
		</div>
	</div>
	<div class="col-lg-4 chart_area">
		<div class="indiv">
			<!-- [D] 차트 개발 시, style 삭제해주세요 -->
			<div class="inchart">
				<div id="hchart2_2"></div>
			</div>
			<!-- [D] 컬러별로 't1 ~ t9' 클래스 추가 -->
			<div class="chart_legend_area">
				<!-- [D] 두 줄 정렬일 때 ''col 클래스 추가 -->
				<ul class="chart_legend col">
					<!--           <li> -->
					<!--             <div><p class="bu t1">PCS</p><span class="value">8건</span></div> -->
					<!--           </li> -->
					<!--           <li> -->
					<!--             <div><p class="bu t2">접속반</p><span class="value">8건</span></div> -->
					<!--           </li> -->
					<!--           <li> -->
					<!--             <div><p class="bu t3">BMS</p><span class="value">8건</span></div> -->
					<!--           </li> -->
					<!--           <li> -->
					<!--             <div><p class="bu t4">환경센서</p><span class="value">8건</span></div> -->
					<!--           </li> -->
					<!--           <li> -->
					<!--             <div><p class="bu t5">태양광 인버터</p><span class="value">8건</span></div> -->
					<!--           </li> -->
					<!--           <li> -->
					<!--             <div><p class="bu t6">계량기</p><span class="value">8건</span></div> -->
					<!--           </li> -->
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="row usage_chart_table his_al">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="tbl_wrap_type">
<!-- 				<div class="tbl_top clear" id="INV_PV2"> -->
<!-- 					<h2 class="ntit fl">태양광 인버터</h2> -->
<!-- 					<button type="button" class="btn_type03 fr" onclick="alarmConfirmAll('INV_PV');">일괄 확인</button> -->
<!-- 				</div> -->
				<table class="his_tbl chk_type" id="basic">
					<thead>
					<tr>
						<th>
							<input type="checkbox" id="alarmConfirmCheck" onclick="alarmConfirmCheckAll('INV_PV');">
							<label for="alarmConfirmCheck"><span></span></label>
						</th>
						<th>
							<button class="btn_align down">사업소</button>
						</th>
						<th>
							<button class="btn_align down">장치명</button>
						</th>
						<th>
							<button class="btn_align down">알람 시간</button>
						</th>
						<th>
							<button class="btn_align down">알람 타입</button>
						</th>
						<th>
							<button class="btn_align down">알림 메시지</button>
						</th>
						<th>
							<button class="btn_align down">확인 여부</button>
						</th>
						<th>
							<button class="btn_align down">조치 상태</button>
						</th>
						<th>
							<button class="btn_align down">최종 업데이트 시간</button>
						</th>
					</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>	
		</div>
	</div>
</div>
<script type="text/javascript">
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	//const sid = '<c:out value="${param.sid}" escapeXml="false"/>';
	let responseDate = new Map();
	let responseCnt = 0;
	let dataList = [];
	let changeTablegird = null;
	let s = [];
	const debugMode = true;
	const deviceTemplate = {
		'SM': '스마트미터',
		'SM_ISMART': '한전 아이스마트',
		'SM_KPX': '전력거래소 계량포털',
		'SM_CRAWLING': '데이터 수집기',
		'SM_MANUAL': '수기 입력',
		'INV_PV': '태양광 인버터',
		'INV_WIND': '풍력 인버터',
		'PCS_ESS': 'ESS PCS',
		'BMS_SYS': 'BMS 시스템',
		'BMS_RACK': 'BMS 랙',
		'SENSOR_SOLAR': '태양광 센서',
		'SENSOR_FRAME': '불꽃 센서',
		'SENSOR_TEMP_HUMIDITY': '온습도 센서',
		'CCTV': 'CCTV'
	};
	const levelTemplate = {
//			0: 'unknown',
//			1: 'emergency',
//			2: 'critical' ,
//			3: 'warning', 
//			4: 'info'
		9: '알수없음',
		0: '정보',
		1: '경고',
		2: '이상',
		3: '트립',
		4: '정상'
	};
	const statusTemplate = {
		'null': '신규',
		'open': '작업처리중',
		'pending': '추가 정보 대기',
		'resolve': '현장 조치 완료',
		'on-hold': '처리 결과 확인',
		'closed': '처리 완료',
	};
	$(function () {
		const sidparam = "${param.sid}";
		let sites = JSON.parse('${siteList}');
		
	    siteList(sites, sidparam);
		if(sidparam != ""){
			deviceTypeList(sidparam);
		}
		//사이트 선택시
		$(document).on('click', ':checkbox[name="site"]', function () {
			if ($(':checkbox[name="site"]:checked').length <= 0) {
                $(this).parents('ul').prev('a').empty().append('선택해주세요.');
            } else {
                let extendText = '';
                if ($(':checkbox[name="site"]:checked').length > 1) {
                    extendText = '외 ' + Number($(':checkbox[name="sid"]:checked').length - 1) + '개';
                }
                $(this).parents('ul').prev('a').empty().append($(':checkbox[name="site"]:checked').eq(0).next('label').text() + '&nbsp;' + extendText);
            }
			deviceTypeList(sidparam);
		});

		$('#datepicker1').datepicker('setDate', 'today');
        $('#datepicker2').datepicker('setDate', 'today');
        
		$(document).on('click', ':checkbox[name="equipment"]', function () {
			if ($(this).is(':checked')) {
				let extendText = '';
				if ($(':checkbox[name="equipment"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="equipment"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$('#equipmentList button').html($(':checkbox[name="equipment"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
			} else {
				if ($(':checkbox[name="equipment"]:checked').length == 0) {
					$('#equipmentList button').html('전체' + '<span class="caret"></span>')
				} else {
					let extendText = '';
					if ($(':checkbox[name="equipment"]:checked').length > 1) {
						extendText = '외 ' + Number($(':checkbox[name="equipment"]:checked').length - 1) + '개';
					}
					//첫 번째 값 + 외 몇개로 표기
					$('#equipmentList button').html($(':checkbox[name="equipment"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
				}
			}
		});
		
		$("#alarmstatus button").html("미확인&nbsp;<span class='caret'></span>");

		$(".rdo_type").on('click', function () {
			if ($(this).find('input').is(':checked')) {
			} else {
				$(this).find('input').prop('checked', true);
			}
		})
		
		$('#alarm li').on('click', function () {
			let idx = $('#alarm li').index($(this));
			if (idx == 0) {
				if ($(this).find(':checkbox').is(":checked")) {
					$(':checkbox[name="alarm"]:not(:eq(0))').prop("checked", true);
				} else {
					$(':checkbox[name="alarm"]:not(:eq(0))').prop("checked", false);
				}
			} else {
				if ($(':checkbox[name="alarm"]:not(:eq(0)):checked').length == 6) {
					$(':checkbox[name="alarm"]:eq(0)').prop('checked', true);
				} else {
					$(':checkbox[name="alarm"]:eq(0)').prop('checked', false);
				}
			}
		});


		$('#term li').on('click', function () {
			if ($(this).data('value') == 'setup') {
				$('#dateArea').show();
			} else {
				if ($(this).data('value') == 'day') {//오늘
					$('#datepicker1').datepicker('setDate', 'today');
					$('#datepicker2').datepicker('setDate', 'today');
				} else if ($(this).data('value') == 'week') {//이번주
					$('#datepicker1').datepicker('setDate', '-6');
					$('#datepicker2').datepicker('setDate', 'today');
				} else if ($(this).data('value') == 'month') { //이번달
					$('#datepicker1').datepicker('setDate', '-30');
					$('#datepicker2').datepicker('setDate', 'today');
				}
			}
		});
        if(sidparam != ""){
        $("#siteList button").html($(':checkbox[name="site"]:checked').eq(0).next('label').text() + '&nbsp;<span class="caret"></span>');
        	periodData();
        	fetchCharts();
        	$('#search').trigger('click');
        }
		$('#search').on('click', function () {
			periodData();
			fetchCharts();
		});

		$('#chartType input').on('click', function () {
			fetchCharts();
		});
		//헤더 클릭
		$('.his_tbl thead th').on('click', function (e) {
			var idx = $('.his_tbl thead th').index($(this))
				, order = $(this).data('order')
				, column = $(this).data('column');
			let Selector = "";

			if (idx >= 1 && idx < 8) {
				$('.his_tbl thead th a').removeClass('asc').removeClass('desc');
				if (order == undefined || order == null || order == '') {
					changeTablegird.sort(function (a, b) {
						return a[column] - b[column];
					});
					$(this).data('order', 'asc');
					$(this).find('a').addClass('asc');
				} else if (order == 'asc') {
					changeTablegird.sort(function (a, b) {
						return b[column] - a[column];
					});
					$(this).data('order', 'desc');
					$(this).find('a').addClass('desc');
				} else {
					changeTablegird.sort(function (a, b) {
						return a[column] - b[column];
					});
					$(this).data('order', 'asc');
					$(this).find('a').addClass('asc');
				}

			}
		});
	});

	const siteList = function (sites, sidparam) {
		$('#siteList > div > ul').empty();
		let str = '';
		sites.forEach((site, index) => {
			str += '<li>';
			str += '<a href="#" data-value="'+site.sid+'" tabindex="-1">';
			if(site.sid == sidparam){
			     str += '<input type="checkbox" id="'+site.sid+'" value="'+site.sid+'" name="site" checked>';
			}
			else{
			     str += '<input type="checkbox" id="'+site.sid+'" value="'+site.sid+'" name="site">';
			}
			str +=  '<label for="'+site.sid+'"><span></span>'+site.name+'</label></a></li>';
		});
		$('#siteList>div>ul').append(str);			
	};

	const deviceTypeList = function (sidparam) {
		console.log(sidparam);
		$('#equipmentList > div > ul').empty();
		let str = '';
		let sites = JSON.parse('${siteList}');
		dataList = deviceType(sites, sidparam);
		const deviceTypes = dataList[0];

		deviceTypes.forEach((deviceTypes, index) => {
			const deviceRender = eval('deviceTemplate.' + deviceTypes);
			str +=  '<li><a href="#" data-value="'+index+'" tabindex="-1">';
			if(sidparam == ""){
			str +=	'<input type="checkbox" id="'+index+'" value="'+deviceTypes+'" name="deviceType">';
			}
			else{
			str +=   '<input type="checkbox" id="'+index+'" value="'+deviceTypes+'" name="deviceType" checked>';	
			}
			str +=	'<label for="'+index+'"><span></span>'+deviceRender+'</label>';
			str +=	'</a></li>';
		});
		$('#equipmentList>div>ul').append(str);
	};

	const periodData = function () {
		$('.tbl_wrap_type').empty();
	

		if ($(':checkbox[name="deviceType"]:checked').length == 0) {
			alert('설비타입을 한개이상 선택해 주세요.');
			return false;
		}

		if ($(':checkbox[name="alarm"]:checked').length == 0) {
			alert('알람유형을 한개이상 선택해 주세요.');
			return false;
		}
        
		$('.his_tbl tbody').empty();
		s = dataList[1];

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
				sids: s.join(','),
				deviceTypes: deviceArray.join(','),
				startTime: $('#datepicker1').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#datepicker2').datepicker('getDate').format('yyyyMMdd') + '235959',
			}
		} else {
			let confirm = "";
			if ($(':checkbox[name="confirm"]:checked').next('label').text() === "미확인") {
				confirm = false;
			} else {
				confirm = true;
			}
			alarmData = {
				sids: s.join(','),
				deviceTypes: deviceArray.join(','),
				confirm: confirm,
				startTime: $('#datepicker1').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#datepicker2').datepicker('getDate').format('yyyyMMdd') + '235959',
			}
		}
        
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/alarms',
			type: 'get',
			async: false,
			data: alarmData,
			success: function (result) {
				var data = result;
				if (debugMode) {
					console.log(data);
				}
				let filterdata = [];

				statusfilter(filterdata, statusArray, data);
				
				$(".his_tbl").remove();
				$.each(deviceArray,function(i, el){
		             makeDiv(el);
		             makeTableHead(el);
		        });
		        
				if (filterdata.length > 0) {
					$.each(filterdata, function (i, el) {
						$.each(deviceArray,function(j, e2){
							if(el.device_type === e2){
								  tablegrid(e2, el, i);							
							}						   				    	
						})
						}
					)
				}
				$.each(deviceArray,function(i, el){
                    if($("#"+el+" tbody td").length == 0){
                    	tdStr = '<th><td></td></th>';
                    	$("#"+el+" tbody").append(tdStr);
                    }
               });
				changeTablegird = filterdata;
			},
			dataType: "json"
		});
	}
	const makeDiv = function(deviceType){
		let DivStr = "";
		DivStr += '<div class="tbl_top clear">';
        DivStr += '<h2 class="ntit fl">'+deviceTemplate[deviceType]+'</h2>';
        DivStr += '<button type="button" class="btn_type03 fr" onclick="alarmConfirmAll('+deviceType+');">일괄 확인</button>';
        DivStr += '</div>';
        $(".tbl_wrap_type").append(DivStr);
	}
    const makeTableHead = function(deviceType){
    	let newHeadTable = document.createElement('table');
    	let colList = ["사업소", "장치명", "알람 시간", "알람 타입", "알람 메세지", "확인 여부", "조치 상태", "최종 업데이트 시간"];
        let thead = newHeadTable.createTHead();
        let tbody = newHeadTable.createTBody();
        let tRow = thead.insertRow(); 	
   
        	for(let i = 0; i<colList.length+1; i++){
        		 let hCell = document.createElement("th");
        		if(i==0){
        			hCell.innerHTML =  '<input type="checkbox" id="alarmConfirmCheck" onclick="alarmConfirmCheckAll('+deviceType+');"><label for="alarmConfirmCheck"><span></span></label>';
        	        tRow.appendChild(hCell);
        		}else{
        			hCell.innerHTML = colList[i-1];
                    tRow.appendChild(hCell);
        		}
        	}
        newHeadTable.setAttribute('class', 'his_tbl chk_type');
        newHeadTable.setAttribute('id', deviceType);
        $(".tbl_wrap_type").append(newHeadTable);
        
    }
	const tablegrid = function (tableId, el, i) {
		let tbodyStr = "";
		const Selector = '#' + tableId + ' tbody';
		tbodyStr += '<tr>';
		tbodyStr += '<td><input type="checkbox" value="' + el.alarm_id + '"id="chk' + i + '"><label for="chk' + i + '"><span></span></label></td>'
		tbodyStr += '	<td>' + el.site_name + '</td>'; // 장비타입
		tbodyStr += '	<td>' + el.device_name + '</td>'; // 장치명
		tbodyStr += '	<td>' + dateFormat(String(el.localtime)) + '</td>'; // 알람발생시간
		tbodyStr += '	<td>' + ((isEmpty(el.level)) ? '-' : levelTemplate[el.level]) + '</td>'; // 알람타입
		tbodyStr += '	<td>' + ((isEmpty(el.message)) ? "" : el.message) + '</td>'; // 알람메시지
		if (el.confirm == false) {
			tbodyStr += '	<td><a href="javascript:alarmConfirm(\'' + el.alarm_id + '\');" class="tbl_link" >미확인</a></td>'; // 알람상태
		} else {
			tbodyStr += '	<td>확인</td>'; // 알람상태
		}

		if (!(isEmpty(el.status))) { // 조치사항이 존재할 경우
			tbodyStr += '	<td><a href="javascript:updateACK(\'' + el.alarm_id + '\');" class="tbl_link" >' + statusTemplate[el.status] + '</a></td>'; // 조치상태
		} else {
			tbodyStr += '	<td><a href="javascript:updateACK(\'' + el.alarm_id + '\');" class="tbl_link" >신규</a></td>'; // 조치상태
		}

		if (!(isEmpty(el.status_timestamp))) {
			tbodyStr += '   <td>' + el.status_timestamp + '</td>'; // 최종업데이트 시간
		} else {
			tbodyStr += '<td></td>';
		}
		tbodyStr += '</tr>';
		$(Selector).append(tbodyStr);
	}

	function updateACK() {
		$("#myModal02").modal('show');
	}

	function measurePopup() {
		$("#myModal01").modal('show');
	}

	const datafilter = function (array, key) {
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
	const statusfilter = function (filterdata, statusArray, data) {
		$.each(data, function (i, el) {
			$.each(statusArray, function (j, e2) {
				if (e2 == "null") {
					e2 = null;
				}
				if (el.status === e2) {
					filterdata.push(data[i])
				}
			})
		})
	}
	const deviceType = function (sites ,sidparam) {
		if(sidparam != ""){
			$('#equipmentList button').empty().append('전체<span class="caret"></span>');	
		}else{
			$('#equipmentList button').empty().append('설비유형<span class="caret"></span>');    	
		}
		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			}
			)
		);
		let deviceTypes = [];
		const oid = sites[0].oid;
		if (siteArray.length > 0) {
			const arr = deviceInternet(siteArray, oid);

			const deviceTypeArray = datafilter(arr, "device_type");
			const sidArray = datafilter(arr, "sid");

			deviceTypes.push(deviceTypeArray);
			deviceTypes.push(sidArray);
		}

		return deviceTypes;
	}

	const deviceInternet = function (siteArray, oid) {
		let arr = [];
		$.each(siteArray, function (i, site) {
			$.ajax({
				url: 'http://iderms.enertalk.com:8443/config/devices/',
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
				dataType: "json"
			});

		})
		return arr;
	}
	let dateArr = new Array();
	var fetchCharts = function () {

		dateArr = new Array();

		var period = $("#term").val();
		var interval = "";
		if (period == "day") {
			interval = "hour";
		} else if (period == "week") {
			interval = "day";
		} else if (period == "month") {
			interval = "day";
		} else if (period == "year") {
			interval = "month";
		} else {
			interval = "day";
		}

		let sDate = $('#datepicker1').val().replace(/-/g, '');
		let eDate = $('#datepicker2').val().replace(/-/g, '');
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
		if (interval == "hour") {
			substringCnt = 10;
		} else if (interval == "day") {
			substringCnt = 8;
		} else if (interval == "month") {
			substringCnt = 6;
		}

		var gr_type = $("#rdo03_1").is(':checked');

		var chartTypeNm = (gr_type == true) ? "deviceType" : "alarm";
		let dataMap = new Map();

		dataMap.set(s, data);

		let columnSeriesData = new Array();
		let typeColorArr = ['#CDE1F3', '#009389', '#438FD7', '#9BF4CC', '#3EEA9C', '#13af67', '#438fd7', '#13af67', '#f75c4a', '#84848f', '#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787', '#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787'];
		let alarmColorArr = ['#438FD7', '#F75C4A', '#F49E34', '#84848F', '#438fd7', '#13af67', '#f75c4a', '#84848f', '#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787', '#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787'];
		let colorArr = (gr_type == true) ? typeColorArr : alarmColorArr;

		var num = 0;

		dataMap.forEach(function (v, k) {
			data.sort(function (a, b) {
				return a['localtime'] - b['localtime'];
			});

			var vMap = new Map();
			$.each(dateArr, function (j, stnd) {

				let stndTime = stnd.substring(0, substringCnt); //각 날짜 스트링

				var tpCntArr = new Map();//타입 선택후 날짜별 타입현황 인덱스는 종류를 나타냄
				$.each(v, function (i, el) {
					var type = (gr_type == true) ? el.device_type : el.level;
					if (tpCntArr.get(type) == undefined) tpCntArr.set(type, 0);
					let base = String(el.localtime);
					if (stndTime == base.substring(0, substringCnt)) {
						var cnt = tpCntArr.get(type) + 1;
						tpCntArr.set(type, cnt);
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
			
				var typeNm = key;

				$(':checkbox[name="' + chartTypeNm + '"]:checked').each(function () {
					if (key == $(this).val()) {
						typeNm = $(this).next('label').text();
					}
				});
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
			});
			
		});

		pieMap = new Map();
		$.each(data, function (i, el) {
			let tp = "";
			var type = (gr_type == true) ? el.device_type : el.level;
			let equalTy = "";
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
		$(".chart_legend").empty();
		var num2 = 0;
		pieMap.forEach(function (val, key) {
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
				var liStr = '<li><div><p class="bu t1">' + key + '</p><span class="value">' + val + '건</span></div></li>';
				$(".chart_legend").append(liStr);
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
				marginLeft: 80,
				marginRight: 0,
				backgroundColor: 'transparent',
				type: 'column'
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
						color: 'var(--color3)',
						fontSize: '14px'
					},
					formatter: function() {
                        return dateFormat(this.value);
                    }
				},
				categories: dateArr,
				tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
				title: {
					text: null
				},
				crosshair: true /* 포커스 선 */
			},

			yAxis: {
				gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
				min: 0, /* 최소값 지정 */
				title: {
					text: '건',
					align: 'low',
					rotation: 0, /* 타이틀 기울기 */
					y: 25, /* 타이틀 위치 조정 */
					x: 5, /* 타이틀 위치 조정 */
					style: {
						color: 'var(--color3)',
						fontSize: '14px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -20, /* 그래프와의 거리 조정 */
					style: {
						color: 'var(--color3)',
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
					color: 'var(--color3)',
					fontSize: '14px',
					fontWeight: 400
				},
				itemHoverStyle: {
					color: '' /* 마우스 오버시 색 */
				},
				symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
				symbolHeight: 8 /* 심볼 크기 */
			},

			/* 툴팁 */
			tooltip: {
				shared: true /* 툴팁 공유 */
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
				plotShadow: false
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
				symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
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
				data: pieSeriesData
			}]

		}

		myChart3_2 = new Highcharts.Chart(myPieChart);
		myChart3_2.redraw();

	}


	//두기간 사이 차이 구하기.
	function getDiff(eDate, sDate, type) {
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
    var dateFormat = function(val) {
        if((val != undefined && val != 0)) {
            if(String(val).length == 4) {
                date = val.substring(0, 4)
            } else if(String(val).length == 6) {
                date = val.substring(0, 4) + '-' + val.substring(4, 6);
            } else if(String(val).length == 12) {
                date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8) + ' ' + val.substring(8, 10) + ':' + val.substring(10, 12);
            } else if(String(val).length > 12) {
                date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8) + ' ' + val.substring(8, 10) + ':' + val.substring(10, 12) + ':' + val.substring(12, 14);
            } else {
                date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8);
            }
        }
        return date;
    }

	function alarmConfirm(alarmId) {
		$('#alarmConfirm').modal().data('value', alarmId);
	}

	function alarmConfirmCheckAll(tableId) {
		if($('#' + tableId + '> thead tr :checkbox:checked').length == 0) {
			$('#' + tableId + '> tbody tr :checkbox').prop('checked', false);
		} else {
			$('#' + tableId + '> tbody tr :checkbox').prop('checked', true);
		}
	}

	function alarmConfirmAll(tableId) {
		if($('#' + tableId + '> tbody tr :checkbox:checked').length == 0) {
			alert('확인할 알람이 선택되지않았습니다.');
			return false;
		} else {
			let cnt = 0;
			$('#' + tableId + '> tbody tr :checkbox:checked').each(function() {
				let data = {
					confirm: true
				}
				$.ajax({
					url: 'http://iderms.enertalk.com:8443/alarms/'+$(this).val(),
					type: 'patch',
					dataType: 'json',
					async: false,
					contentType: "application/json",
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

	function alarmConfirmProcess() {
		let alarmId = $('#alarmConfirm').data('value');
		let data = {
			confirm: true
		}
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/alarms/'+alarmId,
			type: 'patch',
			dataType: 'json',
			contentType: "application/json",
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
