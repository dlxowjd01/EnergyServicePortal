<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">발전 이력</h1>
	</div>
</div>
<div class="row content-wrapper">
	<div id="siteList" class="col-lg-2 col-md-4 col-sm-6 header_drop_area">
		<div class="dropdown">
			<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
				선택해주세요.<span class="caret"></span>
			</button>
			<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-2 col-md-5 col-sm-12 use_total">
		<div class="indiv">
			<h2 class="ntit">발전량 합계</h2>
			<div class="value_area">
			</div>
		</div>
	</div>
	<div class="col-lg-10 col-md-7 col-sm-12">
		<div class="indiv usage_chart pv_chart">
			<div class="chart_top clear">
				<div id="deviceType">
					<span class="tx_tit">계량값</span>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">복수
								선택<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type">
								<li class="dropdown_cov clear selectDevices">
									<div class="li_btn_bx clear">
										<div class="fl">
											<button type="button" class="btn_type03">모두 선택</button>
											<button type="button" class="btn_type03">모두 해제</button>
										</div>
										<div class="fr">
											<button type="button" class="btn_type">적용</button>
										</div>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="inline_flex">
					<div class="period">
						<span class="tx_tit">기간</span>
						<div class="sa_select">
							<div class="dropdown" id="period">
								<button class="btn btn-primary dropdown-toggle" type="button"
									data-toggle="dropdown">오늘<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="today" class="on"><a href="#">오늘</a></li>
									<li data-value="week"><a href="#">이번 주</a></li>
									<li data-value="month"><a href="#">이번 달</a></li>
									<li data-value="setup"><a href="#">직접 선택</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="duration" id="dateArea">
						<span class="tx_tit">날짜입력</span>
						<div class="sel_calendar">
							<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" readonly>
							<em></em>
							<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" readonly>
						</div>
					</div>
					<div class="unit" id="cycle">
						<span class="tx_tit">단위</span>
						<div class="sa_select">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle interval" type="button"
									data-toggle="dropdown">
									기간<span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li class="on"><a href="#">15분</a></li>
									<li><a href="#">1시간</a></li>
									<li><a href="#">1일</a></li>
									<li><a href="#">1월</a></li>
								</ul>
							</div>
						</div>
					</div>
					<button type="button" class="btn_type" id="renderBtn">조회</button>
				</div>
			</div>
			<div class="end">
				<span class="tx_tit">그래프</span>
				<div class="sa_select">
					<div class="dropdown" id="chartStyle">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown"
							data-value="each">
							개별 막대<span class="caret"></span>
						</button>
						<ul class="dropdown-menu">
							<li data-value="allSum">
								<a href="#">전체 합산</a>
							</li>
							<li data-value="siteSum">
								<a href="#">사이트별 합산</a>
							</li>
							<li data-value="each" class="on">
								<a href="#">개별 막대</a>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<p class="tx_time"></p>
			<div class="inchart">
				<div id="chart2"></div>
			</div>
		</div>
	</div>
</div>
<div class="row pv_chart_table" style="display:none;">
	<div class="col-12">
		<div class="indiv clear">
			<div class="tbl_save_bx">
				<a href="#;" class="save_btn">데이터저장</a>
			</div>
			<div class="tbl_top clear">
				<h2 class="ntit fl">발전량 도표</h2>
				<ul class="fr">
					<li><a href="#;" class="fold_btn">표접기</a></li>
				</ul>
			</div>
			<div class="tbl_wrap">
				<div class="fold_div" id="pc_use">
					<!-- PC 버전용 테이블 -->
					<div class="chart_table">
						<table class="pc_use">
							<thead>
								<tr>
									<th>2020-08-01</th>
									<th>01:00</th>
									<th>02:00</th>
									<th>03:00</th>
									<th>04:00</th>
									<th>05:00</th>
									<th>06:00</th>
									<th>07:00</th>
									<th>08:00</th>
									<th>09:00</th>
									<th>10:00</th>
									<th>11:00</th>
									<th>12:00</th>
									<th>13:00</th>
									<th>14:00</th>
									<th>15:00</th>
									<th>16:00</th>
									<th>17:00</th>
									<th>18:00</th>
									<th>19:00</th>
									<th>20:00</th>
									<th>21:00</th>
									<th>22:00</th>
									<th>23:00</th>
									<th>24:00</th>
									<th>합계</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	let standard = new Array(); //기준일
	let accociation = new Map(); //응답 데이터
	let responseCnt = 0; //응답 갯수
	let dup = false; //중복처리 방지

	$(function () {
		siteList(); //사이트 조회

		//사이트 선택시
		$(document).on('click', ':checkbox[name="site"]', function () {
			if ($(this).is(':checked')) {
				let extendText = '';
				if ($(':checkbox[name="site"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="site"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$('#siteList button').html($(':checkbox[name="site"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
			} else {
				if ($(':checkbox[name="site"]:checked').length == 0) {
					$('#siteList button').html('선택해주세요.' + '<span class="caret"></span>')
				} else {
					let extendText = '';
					if ($(':checkbox[name="site"]:checked').length > 1) {
						extendText = '외 ' + Number($(':checkbox[name="site"]:checked').length - 1) + '개';
					}
					//첫 번째 값 + 외 몇개로 표기
					$('#siteList button').html($(':checkbox[name="site"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
				}
			}
			device();
		});

		//전체 선택/전체 해제
		$('#deviceType button.btn_type03').on('click', function (e) {
			var idx = $('#deviceType button.btn_type03').index($(this));

			if (idx == 0) {
				$(':checkbox[name="device"]').prop('checked', true);
			} else {
				$(':checkbox[name="device"]').prop('checked', false);
			}
		});

		$('#renderBtn').on('click', function () {
			fetchGenData();
		});

		$('#period li').on('click', function () {
			if ($(this).data('value') == 'setup') {
				$('#dateArea').css("display", "block");
			} else {
				$('#dateArea').css("display", "none");
				if ($(this).data('value') == 'today') { //오늘
					// $('#cycle').
					$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
					$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
				} else if ($(this).data('value') == 'week') { //이번주
					$('#datepicker1').datepicker('setDate', '-6'); //데이트 피커 기본
					$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
				} else { //이번달
					$('#datepicker1').datepicker('setDate', '-30'); //데이트 피커 기본
					$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
				}
				// $('#dateArea').hide();
			}
		});

		$('#chartStyle li').on('click', function () {
			$(this).parents('ul').prev('button').data('value', $(this).data('value'));
			chartDataDraw();
		});

		$('.save_btn').on('click', function (e) {
			let excelName = '발전이력';
			let $val = $('#pc_use').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {
					tableToExcel('pc_use', excelName, e);
				}
			}
		});

		$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
	});

	//사업소 호출
	const siteList = function () {
		$('#siteList > div > ul').empty();

		let str = '';
		let sites = JSON.parse('${siteList}');
		sites.forEach((site, index) => {
			str += `<li>
            <a href="#" data-value="${'${site.sid}'}" tabindex="-1">
                <input type="checkbox" id="${'${site.sid}'}" value="${'${site.sid}'}" name="site">
                <label for="${'${site.sid}'}"><span></span>${'${site.name}'}</label>
            </a>
        </li>`;
		});
		$('#siteList>div>ul').append(str);
	};

	const device = function () {
		$('#deviceType button.btn-primary').empty().append('복수 선택').append('<span class="caret"></span>');

		if ($(':checkbox[name="site"]:checked').length > 0) {
			let size = 380 + (Number($(':checkbox[name="site"]:checked').length - 2) * 170);
			if (size < 380) {
				size = 380;
			}
			$('#deviceType li.selectDevices').css('width', size);
			$('#deviceType div.sec_li_bx').remove();
			$(':checkbox[name="site"]:checked').each(function () {
				let sid = $(this).val()
				let sNm = $(this).next('label').text();

				$.ajax({
					url: 'http://iderms.enertalk.com:8443/config/devices/',
					type: 'get',
					async: false,
					data: {
						oid: 'spower',
						sid: sid
					},
					success: function (result) {
						let devices = result;
						if (devices.length > 0) {
							let siteGrp = $('<div>').addClass('sec_li_bx');
							siteGrp.append('<p>');
							siteGrp.find('p').addClass('tx_li_tit').text(sNm);
							siteGrp.append('<ul>');

							let chargeArr = new Array();
							let dashArr = new Array();
							let deviceType = ['SM', 'SM_ISMART', 'SM_KPX', 'SM_CRAWLING', 'SM_MANUAL', 'INV_PV', 'INV_WIND', 'PCS_ESS', 'BMS_SYS',
								'BMS_RACK', 'SENSOR_SOLAR', 'SENSOR_FLAME', 'SENSOR_TEMP_HUMIDITY', 'CCTV', 'COMBINER_BOX', 'CIRCUIT_BREAKER'
							];
							$.each(devices, function (i, el) {
								$.each(deviceType, function (j, tp) {
									if (tp == el.device_type && (el.dashboard || el.billing)) {
										let deviceHtml = $('<li>').append('<a>');
										deviceHtml.find('a').attr('href', '#').attr('tabindex', '-1');
										deviceHtml.find('a').append('<input id="' + el.did + '" name="device" type="checkbox" value="' + el.did + '" data-sid="' + el.sid + '" data-name="' + sNm + '_' + el.name + '">').append('<label>');
										deviceHtml.find('label').attr('for', el.did).append('<span>').append('&nbsp;' + el.name);
										siteGrp.find('ul').append(deviceHtml);
									}
								});
							});

							$('#deviceType li.selectDevices').prepend(siteGrp);

							let deviceHtml1 = $('<li>').append('<a>');
							deviceHtml1.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml1.find('a').append('<input id="device_billing_' + sid + '" name="device" type="checkbox" value="' + sid + '" data-name="' + sNm + '_매전">').append('<label>');
							deviceHtml1.find('label').attr('for', 'device_billing_' + sid).append('<span>').append('&nbsp;매전량');
							siteGrp.find('ul').prepend(deviceHtml1);

							let deviceHtml2 = $('<li>').append('<a>');
							deviceHtml2.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml2.find('a').append('<input id="device_dash_' + sid + '" name="device" type="checkbox" value="' + sid + '" data-name="' + sNm + '_대시보드">').append('<label>');
							deviceHtml2.find('label').attr('for', 'device_dash_' + sid).append('<span>').append('&nbsp;대시보드');
							siteGrp.find('ul').prepend(deviceHtml2);

						}
					},
					dataType: "json"
				});
			});
		}
	};

	function fetchGenData() {
		//기간 설정 확인
		const startTime = $('#datepicker1').val().replace(/-/g, '') + "000000";
		const endTime = $('#datepicker2').val().replace(/-/g, '') + "235959";
		//주기 확인
		let interval = '';
		switch ($('button.interval').text()) {
			case '15분':
				interval = '15min';
				break;
			case '30분':
				interval = '30min';
				break;
			case '1시간':
				interval = 'hour';
				break;
			case '1일':
				interval = 'day';
				break;
			case '1월':
				interval = 'month';
				break;
			default:
				interval = 'hour';
				break;
		}

		const billingSites = $.makeArray($(':checkbox[id^="device_billing_"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		const dashSites = $.makeArray($(':checkbox[id^="device_dash_"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		//체크된 디바이스
		const checkedDevices = $.makeArray($('input[name="device"]:checked').map(
			function () {
				if (!$(this).attr('id').match('device')) {
					return $(this).attr('id');
				}
			}
		));

		responseCnt = 0;
		accociation = new Map();

		//매전량
		if (billingSites.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/sites",
				type: "get",
				async: false,
				data: {
					sid: billingSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'billing',
					formId: 'v2'
				},
				success: function (data) {
					association(data, '1');
				},
				error: function (error) {
					console.error(error);
					association(null, '1');
				}
			})
		} else {
			association(null, '1');
		}

		//대시보드
		if (dashSites.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/sites",
				type: "get",
				async: false,
				data: {
					sid: dashSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'dashboard',
					formId: 'v2'
				},
				success: function (data) {
					association(data, '2');
				},
				error: function (error) {
					console.error(error);
					association(null, '2');
				}
			})
		} else {
			association(null, '2');
		}

		if (checkedDevices.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/devices",
				type: "get",
				async: false,
				data: {
					dids: checkedDevices.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval
				},
				success: function (data) {
					association(data, '3');
				},
				error: function (error) {
					console.error(error);
					association(null, '3');
				}
			});
		} else {
			association(null, '3');
		}
	}

	function association(map, key) {
		//사이트별 구분할수 있는 값 확인필요.
		responseCnt++;
		if (map != null) {
			if (key == '1') {
				let data = map.data;
				$.map(data, function (v, k) {
					$(':checkbox[id^="device_billing_"]').each(function () {
						if ($(this).val() == k) {
							v[0].sid = $(this).val();
							v[0].name = $(this).data('name');
						}
					});
				});
				accociation.set('billing', map.data);
			} else if (key == '2') {
				let data = map.data;
				$.map(data, function (v, k) {
					$(':checkbox[id^="device_dash_"]').each(function () {
						if ($(this).val() == k) {
							v[0].sid = $(this).val();
							v[0].name = $(this).data('name');
						}
					});
				});
				accociation.set('dashboard', map.data);
			} else if (key == '3') {
				let data = map.data;
				$.map(data, function (v, k) {
					$(':checkbox[name="device"]').each(function () {
						if ($(this).data('sid') != undefined) {
							if ($(this).val() == k) {
								v[0].sid = $(this).data('sid');
								v[0].name = $(this).data('name');
							}
						}
					});
				});
				accociation.set('devices', map.data);
			} else {
				accociation.set('devices', map.data);
			}
		}

		if (responseCnt == 3) {
			if (!dup) {
				dup = true;
				drawPage();
			}
		}
	}

	function drawPage() {
		$('table.pc_use tbody').empty();

		let sDate = $('#datepicker1').val().replace(/-/g, '');
		let eDate = $('#datepicker2').val().replace(/-/g, '');
		let interval = '';
		switch ($('button.interval').text()) {
			case '15분':
				interval = '15min';
				break;
			case '30분':
				interval = '30min';
				break;
			case '1시간':
				interval = 'hour';
				break;
			case '1일':
				interval = 'day';
				break;
			case '1월':
				interval = 'month';
				break;
			default:
				interval = 'hour';
				break;
		}

		standard = new Array();
		if (interval == 'day') {
			let diffDay = getDiff(eDate, sDate, 'day');
			for (let j = 0; j < diffDay; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
				sDateTime.setDate(Number(sDateTime.getDate()) + j);
				let toDate = sDateTime.format('yyyyMMdd');
				standard.push(toDate);
			}
		} else if (interval == 'month') {
			let diffMonth = getDiff(eDate, sDate, 'month');
			for (let j = 0; j < diffMonth; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) + j - 1, 1);
				let toDate = sDateTime.format('yyyyMM');
				standard.push(toDate);
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
							standard.push(toDate + '0' + i + '0000');
							standard.push(toDate + '0' + i + '1500');
							standard.push(toDate + '0' + i + '3000');
							standard.push(toDate + '0' + i + '4500');
						} else {
							standard.push(toDate + i + '0000');
							standard.push(toDate + i + '1500');
							standard.push(toDate + i + '3000');
							standard.push(toDate + i + '4500');
						}
					} else if (interval == '30min') { //30분
						if (String(i).length == 1) {
							standard.push(toDate + '0' + i + '0000');
							standard.push(toDate + '0' + i + '3000');
						} else {
							standard.push(toDate + i + '0000');
							standard.push(toDate + i + '3000');
						}
					} else { //시간
						if (String(i).length == 1) {
							standard.push(toDate + '0' + i + '0000');
						} else {
							standard.push(toDate + i + '0000');
						}
					}
				}
			}
		}

		let gridData = gridDataMake(standard, interval);
		let totalArr = new Array();
		if (interval == '15min' || interval == 'hour') {
			let dateVal = '';
			let tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
			let tr = $('<tr>');
			$('div.chart_table').remove();

			$.each(standard, function (i, el) {
				let th = $('<th>');
				if (dateVal == '') {
					dateVal = el.substring(0, 8);
					th.text(dateVal.substring(0, 4) + '-' + dateVal.substring(4, 6) + '-' + dateVal.substring(6, 8));
					tr.append(th);

					th = $('<th>');
					let time = el.substring(8, 10) + ':' + el.substring(10, 12);
					th.text(time);
					tr.append(th);
				} else if (dateVal != el.substring(0, 8) || standard.length == (i + 1)) {
					if (standard.length == (i + 1)) {
						let time = el.substring(8, 10) + ':' + el.substring(10, 12);
						th.text(time);
						tr.append(th);
					}

					th = $('<th>').html('합계');
					tr.append(th);

					tableTemp.find('table').append('<thead>');
					tableTemp.find('thead').append(tr);
					tableTemp.find('table').append('<tbody>');

					let color = 1;
					$.each(gridData, function (q, grid) {
						if (grid.std == dateVal) {
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.deviceNm + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								if (isNaN(data)) {
									$dataTd.html(data);
								} else {
									$dataTd.html(numberComma(parseFloat(data).toFixed(2)));
								}
								$dataTr.append($dataTd);
							});

							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold_div').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
					tr = $('<tr>');
					th = $('<th>');
					dateVal = el.substring(0, 8);
					th.text(el.substring(0, 4) + '-' + el.substring(4, 6) + '-' + el.substring(6, 8));
					tr.append(th);

					th = $('<th>');
					th.text(el.substring(8, 10) + ':' + el.substring(10, 12));
					tr.append(th);
				} else {

					let time = el.substring(8, 10) + ':' + el.substring(10, 12);
					th.text(time);
					tr.append(th);
				}
			});
		} else if (interval == 'day') {
			let dateVal = '';
			let tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
			let tr = $('<tr>');
			$('div.chart_table').remove();

			$.each(standard, function (i, el) {
				let th = $('<th>');
				if (dateVal == '') {
					dateVal = el.substring(0, 6);
					th.text(dateVal.substring(0, 4) + '-' + dateVal.substring(4, 6));
					tr.append(th);

					th = $('<th>');
					let time = el.substring(6, 8);
					th.text(time);
					tr.append(th);

					if (standard.length == (i + 1)) {
						th = $('<th>').html('합계');
						tr.append(th);

						tableTemp.find('table').append('<thead>');
						tableTemp.find('thead').append(tr);
						tableTemp.find('table').append('<tbody>');

						let color = 1;
						$.each(gridData, function (q, grid) {
							if (grid.std == dateVal) {
								let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.deviceNm + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									if (isNaN(data)) {
										$dataTd.html(data);
									} else {
										$dataTd.html(numberComma(parseFloat(data).toFixed(2)));
									}
									$dataTr.append($dataTd);
								});

								tableTemp.find('tbody').append($dataTr);
								color++;
							}
						});
						$('div.fold_div').append(tableTemp);
					}
				} else if (dateVal != el.substring(0, 6) || standard.length == (i + 1)) {
					if (standard.length == (i + 1)) {
						let time = el.substring(6, 8);
						th.text(time);
						tr.append(th);
					}

					th = $('<th>').html('합계');
					tr.append(th);

					tableTemp.find('table').append('<thead>');
					tableTemp.find('thead').append(tr);
					tableTemp.find('table').append('<tbody>');

					let color = 1;
					$.each(gridData, function (q, grid) {
						if (grid.std == dateVal) {
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.deviceNm + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								if (isNaN(data)) {
									$dataTd.html(data);
								} else {
									$dataTd.html(numberComma(parseFloat(data).toFixed(2)));
								}

								$dataTr.append($dataTd);
							});

							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold_div').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
					tr = $('<tr>');
					th = $('<th>');
					dateVal = el.substring(0, 6);
					th.text(el.substring(0, 4) + '-' + el.substring(4, 6));
					tr.append(th);

					th = $('<th>');
					th.text(el.substring(6, 8));
					tr.append(th);
				} else {
					let time = el.substring(6, 8);
					th.text(time);
					tr.append(th);
				}
			});
		} else if (interval == 'month') {
			let dateVal = '';
			let tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
			let tr = $('<tr>');
			$('div.chart_table').remove();

			$.each(standard, function (i, el) {
				let th = $('<th>');
				if (dateVal == '') {
					dateVal = el.substring(0, 4);
					th.text(dateVal.substring(0, 4));
					tr.append(th);

					th = $('<th>');
					let time = el.substring(4, 6);
					th.text(time);
					tr.append(th);

					if (standard.length == (i + 1)) {
						th = $('<th>').html('합계');
						tr.append(th);

						tableTemp.find('table').append('<thead>');
						tableTemp.find('thead').append(tr);
						tableTemp.find('table').append('<tbody>');

						let color = 1;
						$.each(gridData, function (q, grid) {
							if (grid.std == dateVal) {
								let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.deviceNm + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									if (isNaN(data)) {
										$dataTd.html(data);
									} else {
										$dataTd.html(numberComma(parseFloat(data).toFixed(2)));
									}
									$dataTr.append($dataTd);
								});

								tableTemp.find('tbody').append($dataTr);
								color++;
							}
						});
						$('div.fold_div').append(tableTemp);
					}
				} else if (dateVal != el.substring(0, 4) || standard.length == (i + 1)) {
					if (standard.length == (i + 1)) {
						let time = el.substring(4, 6);
						th.text(time);
						tr.append(th);
					}

					th = $('<th>').html('합계');
					tr.append(th);

					tableTemp.find('table').append('<thead>');
					tableTemp.find('thead').append(tr);
					tableTemp.find('table').append('<tbody>');

					let color = 1;
					$.each(gridData, function (q, grid) {
						if (grid.std == dateVal) {
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.deviceNm + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								if (isNaN(data)) {
									$dataTd.html(data);
								} else {
									$dataTd.html(numberComma(parseFloat(data).toFixed(2)));
								}
								$dataTr.append($dataTd);
							});

							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold_div').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
					tr = $('<tr>');
					th = $('<th>');
					dateVal = el.substring(0, 4);
					th.text(el.substring(0, 4));
					tr.append(th);

					th = $('<th>');
					time = el.substring(4, 6);
					th.text(time);
					tr.append(th);
				} else {
					let time = el.substring(4, 6);
					th.text(time);
					tr.append(th);
				}
			});
		}

		chartDataDraw();

		responseCnt = 0;
		dup = false;
	}

	//그리드 데이터 만들기
	const gridDataMake = function (standard, type) {
		let dataArr = new Array();

		accociation.forEach(function (val, key) {
			if (val != undefined) {
				$.each(val, function (k, elk) {
					let arr = elk[0].items;
					arr.sort(function (a, b) {
						return a['basetime'] - b['basetime'];
					});

					let arrDevice = new Array();
					let deviceId = '';
					let deviceNm = '';
					let total = 0;
					let stdDate = '';

					$(':checkbox[name="device"]:checked').each(function () {
						if ($(this).val() == k) {
							if (key == 'billing') {
								if ($(this).attr('id').match('billing')) {
									deviceNm = $(this).data('name');
								}
							} else if (key == 'dashboard') {
								if ($(this).attr('id').match('dash')) {
									deviceNm = $(this).data('name');
								}
							} else {
								deviceNm = $(this).data('name');
							}
						}
					});

					$.each(standard, function (j, stnd) {
						let timeValue = '-';
						if (type == '15min' || type == 'hour') {
							if (stdDate == '') {
								stdDate = stnd.substring(0, 8);
							} else if (stdDate != '' && stdDate != stnd.substring(0, 8)) {
								let totalValue = displayNumberFixedUnit(total, 'Wh', 'kWh', 2);
								arrDevice.push(totalValue[0]); //합계.

								let tempMap = {
									deviceId: deviceId,
									deviceNm: deviceNm,
									std: stdDate,
									data: arrDevice
								}

								dataArr.push(tempMap);

								stdDate = stnd.substring(0, 8);
								total = 0;
								arrDevice = new Array();
							}

							$.each(arr, function (i, el) {
								let base = String(el.basetime);
								if (base.match(stnd)) {
									timeValue = displayNumberFixedUnit(el.energy, 'Wh', 'kWh', 2);;
									total += el.energy;
								}
							});
						} else if (type == 'day') {
							if (stdDate == '') {
								stdDate = stnd.substring(0, 6);
							} else if (stdDate != '' && stdDate != stnd.substring(0, 6)) {
								let totalValue = displayNumberFixedUnit(total, 'Wh', 'kWh', 2);
								arrDevice.push(totalValue[0]); //합계.

								let tempMap = {
									deviceId: deviceId,
									deviceNm: deviceNm,
									std: stdDate,
									data: arrDevice
								}

								dataArr.push(tempMap);

								stdDate = stnd.substring(0, 6);
								total = 0;
								arrDevice = new Array();
							}

							$.each(arr, function (i, el) {
								let base = String(el.basetime);
								if (base.match(stnd)) {
									timeValue = displayNumberFixedUnit(el.energy, 'Wh', 'kWh', 2);
									total += el.energy;
								}
							});
						} else {
							if (stdDate == '') {
								stdDate = stnd.substring(0, 4);
							} else if (stdDate != '' && stdDate != stnd.substring(0, 4)) {
								let totalValue = displayNumberFixedUnit(total, 'Wh', 'kWh', 2);
								arrDevice.push(totalValue[0]); //합계.

								let tempMap = {
									deviceId: deviceId,
									deviceNm: deviceNm,
									std: stdDate,
									data: arrDevice
								}

								dataArr.push(tempMap);

								stdDate = stnd.substring(0, 4);
								total = 0;
								arrDevice = new Array();
							}

							$.each(arr, function (i, el) {
								let base = String(el.basetime);
								if (base.match(stnd)) {
									timeValue = displayNumberFixedUnit(el.energy, 'Wh', 'kWh', 2);
									total += el.energy;
								}
							});
						}
						arrDevice.push(timeValue[0]);
					});
					arrDevice.push(total); //합계.

					let tempMap = {
						deviceId: deviceId,
						deviceNm: deviceNm,
						std: stdDate,
						data: arrDevice
					}

					dataArr.push(tempMap);
				});
			}
		});

		return dataArr;
	}

	//두기간 사이 차이 구하기.
	const getDiff = function (eDate, sDate, type) {
		eDate = new Date(eDate.substring(2, 4), eDate.substring(4, 6) - 1, eDate.substring(6, 8));
		sDate = new Date(sDate.substring(2, 4), sDate.substring(4, 6) - 1, sDate.substring(6, 8));
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

	//차트
	const chartDataDraw = function () {
		let num = 0;
		let stack = 0;
		let seriesData = new Array();
		let colorArr = ['#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787', '#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787'];
		let chartStyle = $('#chartStyle button').data('value'); //현재 선택된 스타일

		accociation.forEach(function (v, k) {
			if (JSON.stringify(v) != '{}') {
				$.each(v, function (i, el) {
					let itm = el[0].items;
					let deviceNm = el[0].name;
					let arrDevice = new Array();
					let sid = el[0].sid;
					let totalCurrent = 0;
					let dup = false;

					itm.sort(function (a, b) {
						return a['localtime'] - b['localtime'];
					});

					$.each(standard, function (j, stnd) {
						let timeValue = 0;
						$.each(itm, function (i, el) {
							let base = String(el.basetime);
							if (base.match(stnd)) {
								timeValue = el.energy;
							}
						});

						if (timeValue == null || timeValue == '') {
							timeValue = 0;
						}

						arrDevice.push([
							stnd, timeValue
						]);

						totalCurrent += timeValue;
					});

					if (chartStyle == 'allSum') {
						stack = 0;
					} else {
						if (chartStyle == 'siteSum') {
							if (seriesData.length > 0) {
								$.each(seriesData, function (k, elm) {
									if (sid == elm.sid) {
										dup = true;
										stack = elm.stack;
									}
								});

								if (!dup) {
									stack++;
								}
							} else {
								stack = 0;
							}
						} else {
							stack++;
						}
					}

					let $temp = {
						name: deviceNm,
						type: 'column',
						stack: stack,
						sid: sid,
						tooltip: {
							valueSuffix: 'Wh'
						},
						total: totalCurrent,
						color: colorArr[num],
						data: arrDevice
					};
					seriesData.push($temp);
					num++;
				});
			}
		});

		chartDraw(standard, seriesData);

		//발전량 합계
		$('.value_area').empty();
		$('table.pc_use').parents('.pv_chart_table').show();
		if (seriesData.length > 0) {
			let totalArr = new Array();
			$.each(seriesData, function (i, el) {
				if (chartStyle == 'allSum') {
					if (totalArr.length > 0) {
						totalArr[0].totVal += el.total;
					} else {
						totalArr.push({
							name: '전체',
							totVal: el.total
						});
					}
				} else {
					if (chartStyle == 'siteSum') {
						let siteNm = (el.name).split('_');
						let sid = el.sid;
						let totVal = el.total;
						if (totalArr.length > 0) {
							let dup = false;
							$.each(totalArr, function (j, element) {
								if (el.sid == element.sid) {
									dup = true;
									element.totVal += totVal;
								}
							});

							if (!dup) {
								totalArr.push({
									name: siteNm[0],
									sid: sid,
									totVal: totVal
								});
							}
						} else {
							totalArr.push({
								name: siteNm[0],
								sid: sid,
								totVal: totVal
							});
						}
					} else {
						totalArr.push({
							name: el.name,
							totVal: el.total
						});
					}
				}
			});

			console.log(totalArr);

			$.each(totalArr, function (i, el) {
				let totTitle = '<h3 class="value_tit">' + el.name + '</h3>';
				let refined = displayNumberFixedDecimal(el.totVal, 'Wh');
				totTitle += '<p class="value_num"><span class="num">' + refined[0] + '</span>' + refined[1] + '</p>';
				$('.value_area').append(totTitle);
			});
		}
	}

	const chartDraw = function (standard, seriesData) {
		let chart = $('#chart2').highcharts();

		if (chart) {
			chart.destroy();
		}

		let option = {
			chart: {
				renderTo: 'chart2',
				marginLeft: 60,
				marginRight: 20,
				backgroundColor: 'transparent'
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
						fontSize: '8px'
					},
					y: 50,
					formatter: function () {
						return dateFormat(this.value);
					},
					enabled: true
				},
				categories: standard,
				tickInterval: 1,
				/* 눈금의 픽셀 간격 조정 */
				title: {
					text: null
				},
				crosshair: true /* 포커스 선 */
			},
			yAxis: {
				gridLineWidth: 1,
				/* 기준선 grid 안보이기/보이기 */
				min: 0,
				/* 최소값 지정 */
				title: {
					text: '(kWh)',
					align: 'low',
					rotation: 0,
					/* 타이틀 기울기 */
					y: 25,
					/* 타이틀 위치 조정 */
					x: 5,
					/* 타이틀 위치 조정 */
					style: {
						color: 'var(--color3)',
						fontSize: '18px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -20,
					/* 그래프와의 거리 조정 */
					style: {
						color: 'var(--color3)',
						fontSize: '10px'
					}
				}
			},

			/* 범례 */
			legend: {
				enabled: true,
				align: 'right',
				verticalAlign: 'top',
				x: -120,
				itemStyle: {
					color: 'var(--color3)',
					fontSize: '10px',
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
						let displayValue = displayNumberFixedDecimal(point.y, 'Wh');
						let displayNumber = displayValue[0] == undefined ? '' : displayValue[0];
						let displayUnit = displayValue[1] == undefined ? '' : displayValue[1];
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + displayNumber + displayUnit;
					}, '<b>' + dateFormat(this.points[0].point.name) + '</b>');
				},
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
				column: {
					stacking: 'normal'
				},
				line: {
					marker: {
						enabled: false /* 마커 안보이기 */
					}
				}
			},

			/* 출처 */
			credits: {
				enabled: false
			},

			/* 그래프 스타일 */
			series: seriesData,

			/* 반응형 */
			responsive: {
				rules: [{
					condition: {
						maxWidth: 414 /* 차트 사이즈 */
					},
					chartOptions: {
						chart: {
							marginLeft: 60,
							marginTop: 80
						},
						xAxis: {
							labels: {
								style: {
									fontSize: '13px'
								}
							}
						},
						yAxis: {
							title: {
								style: {
									fontSize: '13px'
								}
							},
							labels: {
								x: -10,
								/* 그래프와의 거리 조정 */
								style: {
									fontSize: '13px'
								}
							}
						},
						legend: {
							layout: 'horizontal',
							verticalAlign: 'bottom',
							align: 'center',
							x: 0,
							itemStyle: {
								fontSize: '13px'
							}
						}
					}
				}]
			}
		}

		chart = new Highcharts.Chart(option);
		chart.redraw();
	}

	const dateFormat = function (val) {
		let date = '';
		if (val != undefined) {
			if (String(val).length == 4) {
				date = val.substring(0, 4)
			} else if (String(val).length == 6) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6);
			} else if (String(val).length > 8) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8) + ' ' + val.substring(8, 10) + ':' + val.substring(10, 12);
			} else {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8);
			}
		}
		return date;
	}
</script>