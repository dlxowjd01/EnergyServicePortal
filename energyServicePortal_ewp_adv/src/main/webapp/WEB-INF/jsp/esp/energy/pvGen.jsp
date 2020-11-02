<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">발전 이력</h1>
	</div>
</div>
<div class="row content-wrapper">
	<div class="col-lg-2 col-md-4 col-sm-6 dropdown-wrapper">
		<div class="dropdown" id="siteList">
			<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="<fmt:message key="renewablesgen.3.multipleselection" />"><fmt:message key="renewablesgen.1.select" /><span class="caret"></span></button>
			<ul class="dropdown-menu chk-type"></ul>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-2 col-md-4 col-sm-6">
		<div class="indiv chart-pv">
			<h2 class="ntit"><fmt:message key="renewablesgen.2.solarenergy" /></h2>
			<div class="value-wrapper"></div>
		</div>
	</div>
	<div class="col-lg-10 col-md-8 col-sm-6">
		<div class="indiv chart-pv">
			<div class="flex-wrapper">
				<div class="chart-top">
					<div id="deviceType" class="flex-group">
						<span class="tx-tit"><fmt:message key="renewablesgen.3.measureddata" /></span>
						<div class="sa-select">
							<div class="dropdown">
								<button type="button" class="dropdown-toggle w7" data-toggle="dropdown" data-name="<fmt:message key="renewablesgen.3.multipleselection" />"><fmt:message key="renewablesgen.3.multipleselection" /><span class="caret"></span></button>
								<div class="dropdown-menu chk-type"><!--
								--><ul class="dropdown-cov clear selectDevices"></ul><!--
								 --><div class="li-btn-box clear">
										<div class="fl"><!--
										--><button type="button" class="btn-type03">모두 선택</button><!--
										--><button type="button" class="btn-type03">모두 해제</button><!--
									--></div>
										<div class="fr"><button type="button" class="btn-type">적용</button></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="flex-group period">
						<span class="tx-tit">기간</span>
						<div class="sa-select">
							<div class="dropdown" id="period">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="renewablesgen.3.today" />"><fmt:message key="renewablesgen.3.today" /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="today" class="on"><a href="#"><fmt:message key="renewablesgen.3.today" /></a></li>
									<li data-value="week"><a href="#"><fmt:message key="renewablesgen.3.thisweek" /></a></li>
									<li data-value="month"><a href="#"><fmt:message key="renewablesgen.3.thismonth" /></a></li>
									<li data-value="setup"><a href="#">직접 선택</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="flex-group duration" id="dateArea">
						<span class="tx-tit">날짜입력</span>
						<div class="sel-calendar">
							<label for="fromDate" class="sr-only">시작 날짜</label>
							<input type="text" id="fromDate" class="sel fromDate" value="" autocomplete="off" readonly>
							<em></em>
							<label for="toDate" class="sr-only">종료 날짜</label>
							<input type="text" id="toDate" class="sel toDate" value="" autocomplete="off" readonly>
						</div>
					</div>
					<div class="flex-group unit" id="cycle">
						<span class="tx-tit">단위</span>
						<div class="sa-select">
							<div class="dropdown" id="interval">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
									선택 <span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li data-value="15min"><a href="#"><fmt:message key="renewablesgen.3.15min" /></a></li>
									<li data-value="hour"><a href="#"><fmt:message key="renewablesgen.3.1hr" /></a></li>
									<li data-value="day"><a href="#"><fmt:message key="renewablesgen.3.1day" /></a></li>
									<li data-value="month"><a href="#"><fmt:message key="renewablesgen.3.1month" /></a></li>
								</ul>
							</div>
						</div>
						<button type="button" class="btn-type" id="renderBtn"><fmt:message key="renewablesgen.3.update" /></button>
					</div>
				</div>
				<div class="end"><!--
				--><span class="tx-tit">그래프</span><!--
				--><div class="sa-select">
						<div class="dropdown" id="chartStyle"><!--
							--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="each"><fmt:message key="renewablesgen.3.individualbar" /><span class="caret"></span></button><!--
						--><ul class="dropdown-menu"><!--
							--><li data-value="allSum"><a href="#"><fmt:message key="renewablesgen.3.sumtotal" /></a></li><!--
							--><li data-value="siteSum"><a href="#"><fmt:message key="renewablesgen.3.sumplant" /></a></li><!--
							--><li data-value="each" class="on"><a href="#"><fmt:message key="renewablesgen.3.individualbar" /></a></li><!--
						--></ul>
						</div>
					</div>
				</div>
			</div>

			<div class="clear hidden">
				<h4 class="text-time"></h4>
				<div id="chart2" class="inchart"></div>
			</div>
		</div>
	</div>
</div>

<div id="pvTable" class="row chart-pv-table hidden">
	<div class="col-12">
		<div class="indiv chart-pv table-box">
			<div class="table-save-box"><a href="#;" class="btn-save"><fmt:message key="renewablesgen.4.dataextracts" /></a></div>
			<div class="table-top clear">
				<h2 class="ntit fl"><fmt:message key="renewablesgen.4.powergenerationchart" /></h2>
				<span class="fr"><a href="#;" class="btn-fold">표접기</a></span>
			</div>
			<div class="table-wrapper">
				<div class="fold-box" id="tableDesktop">
					<!-- PC 버전용 테이블 -->
					<div class="chart-table">
						<table>
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

	function rtnDropdown($dropdownId) {
		if ($dropdownId == 'siteList') {
			device();
		} else if ($dropdownId == 'period') {
			let period = $('#period button').data('value');
			if (period == 'today') { //오늘
				// $('#cycle').
				$('#fromDate').datepicker('setDate', 'today'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			} else if (period == 'week') { //이번주
				$('#fromDate').datepicker('setDate', '-6'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			} else { //이번달
				$('#fromDate').datepicker('setDate', '-30'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			}
		} else if ($dropdownId == 'chartStyle') {
			chartDataDraw();
		}
	}

	$(function () {
		siteList(); //사이트 조회

		//전체 선택/전체 해제
		$('#deviceType button.btn-type03').on('click', function (e) {
			let idx = $('#deviceType button.btn-type03').index($(this));
			if (idx == 0) {
				$(':checkbox[name="device"]').prop('checked', true);
			} else {
				$(':checkbox[name="device"]').prop('checked', false);
			}

			displayDropdown($('#deviceType'));
		});

		$('#renderBtn').on('click', function () {
			fetchGenData();
		});

		$('.btn-save').on('click', function (e) {
			let excelName = '발전이력';
			let $val = $('#tableDesktop').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {
					tableToExcel('table-desktop', excelName, e);
				}
			}
		});

		$('#fromDate').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
	});

	//사업소 호출
	const siteList = function () {
		$('#siteList ul').empty();

		let str = '';
		let sites = JSON.parse('${siteList}');
		sites.forEach((site, index) => {
			str += `<li>
						<a href="javascript:void(0);" data-value="${'${site.sid}'}" tabindex="-1">
							<input type="checkbox" id="${'${site.sid}'}" value="${'${site.sid}'}" name="site">
							<label for="${'${site.sid}'}">${'${site.name}'}</label>
						</a>
					</li>`;
		});
		$('#siteList ul').append(str);
	};

	const device = function () {
		$('#devices .dropdown-toggle').text().replace(/<[^>]+>/g, '복수 선택');
		if ($(':checkbox[name="site"]:checked').length > 0) {
			$('#deviceType .sec-li-box').remove();
			$(':checkbox[name="site"]:checked').each(function () {
				let sid = $(this).val()
				let sNm = $(this).next('label').text();

				$.ajax({
					url: apiHost + '/config/devices/',
					type: 'get',
					async: false,
					data: {
						oid: 'spower',
						sid: sid
					},
					success: function (result) {
						let devices = result;
						if (devices.length > 0) {
							let siteGrp = $('<li>').addClass('sec-li-box');
							siteGrp.append('<p>');
							siteGrp.find('p').addClass('tx-li-title').text(sNm);
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

							$('#deviceType .selectDevices').prepend(siteGrp);

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
		let startTime = $('#fromDate').val().replace(/-/g, '') + "000000";
		let endTime = $('#toDate').val().replace(/-/g, '') + "235959";
		//주기 확인
		const interval = $('#interval button').data('value');

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

		if (billingSites.length <= 0 && dashSites.length <= 0 && checkedDevices.length <= 0) {
			alert('계량값을 선택해 주세요.');
			return false;
		}

		if (isEmpty(interval)) {
			alert('단위를 선택해 주세요.');
			return false;
		} else if (interval == 'month') {
			startTime = startTime.substr(0, 6) + '01000000';
		}

		responseCnt = 0;
		accociation = new Map();

		//매전량
		if (billingSites.length > 0) {
			//API 호출
			$.ajax({
				url: apiHost + '/energy/sites',
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
				url: apiHost + '/energy/sites',
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
				url: apiHost + '/energy/devices',
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
		$('table.table-desktop tbody').empty();
		$('.no-data').addClass('hidden');
		let sDate = $('#fromDate').val().replace(/-/g, '');
		let eDate = $('#toDate').val().replace(/-/g, '');
		let interval = $('#interval button').data('value');

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
		gridData.sortOn("deviceNm");
		if (interval == '15min' || interval == 'hour') {
			let dateVal = '';
			let tableTemp = $('<div class="chart-table">').append('<table class="table-desktop">');
			let tr = $('<tr>');
			$('div.chart-table').remove();

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
							let $dataTr;
							if(gridData.length === 1){
								$dataTr = $('<tr>').append('<td class="bullet"><span class="color2">' + grid.deviceNm + '</span></td>');
							} else {
								$dataTr = $('<tr>').append('<td class="bullet"><span class="color' + color + '">' + grid.deviceNm + '</span></td>');
							}
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								if (isNaN(data)) {
									$dataTd.html(data);
								} else {
									$dataTd.html(numberComma(Math.round(parseFloat(data))));
								}
								$dataTr.append($dataTd);
							});

							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold-box').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart-table">').append('<table class="table-desktop">');
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
			let tableTemp = $('<div class="chart-table">').append('<table class="table-desktop">');
			let tr = $('<tr>');
			$('div.chart-table').remove();

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
								let $dataTr = $('<tr>').append('<td class="bullet"><span class="color' + color + '">' + grid.deviceNm + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									if (isNaN(data)) {
										$dataTd.html(data);
									} else {
										$dataTd.html(numberComma(Math.round(parseFloat(data))));
									}
									$dataTr.append($dataTd);
								});

								tableTemp.find('tbody').append($dataTr);
								color++;
							}
						});
						$('div.fold-box').append(tableTemp);
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
							let $dataTr = $('<tr>').append('<td class="bullet"><span class="color' + color + '">' + grid.deviceNm + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								if (isNaN(data)) {
									$dataTd.html(data);
								} else {
									$dataTd.html(numberComma(Math.round(parseFloat(data))));
								}

								$dataTr.append($dataTd);
							});

							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold-box').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart-table">').append('<table class="table-desktop">');
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
			let tableTemp = $('<div class="chart-table">').append('<table class="table-desktop">');
			let tr = $('<tr>');
			$('div.chart-table').remove();

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
								let $dataTr = $('<tr>').append('<td class="bullet"><span class="color' + color + '">' + grid.deviceNm + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									if (isNaN(data)) {
										$dataTd.html(data);
									} else {
										$dataTd.html(numberComma(Math.round(parseFloat(data))));
									}
									$dataTr.append($dataTd);
								});

								tableTemp.find('tbody').append($dataTr);
								color++;
							}
						});
						$('div.fold-box').append(tableTemp);
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
							let $dataTr = $('<tr>').append('<td class="bullet"><span class="color' + color + '">' + grid.deviceNm + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								if (isNaN(data)) {
									$dataTd.html(data);
								} else {
									$dataTd.html(numberComma(Math.round(parseFloat(data))));
								}
								$dataTr.append($dataTd);
							});

							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold-box').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart-table">').append('<table class="table-desktop">');
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
								let totalValue = numberComma(Math.round(total));
								arrDevice.push(totalValue); //합계.

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
									timeValue = displayNumberFixedUnit(el.energy, 'Wh', 'kWh', 0);;
									if (timeValue[0] != '-') {
										total += el.energy / 1000;
									}
								}
							});
						} else if (type == 'day') {
							if (stdDate == '') {
								stdDate = stnd.substring(0, 6);
							} else if (stdDate != '' && stdDate != stnd.substring(0, 6)) {
								let totalValue = numberComma(Math.round(total));
								arrDevice.push(totalValue); //합계.

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
									timeValue = displayNumberFixedUnit(el.energy, 'Wh', 'kWh', 0);
									if (timeValue[0] != '-') {
										total += el.energy / 1000;
									}
								}
							});
						} else {
							if (stdDate == '') {
								stdDate = stnd.substring(0, 4);
							} else if (stdDate != '' && stdDate != stnd.substring(0, 4)) {
								let totalValue = numberComma(Math.round(total));
								arrDevice.push(totalValue); //합계.

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
									timeValue = displayNumberFixedUnit(el.energy, 'Wh', 'kWh', 0);
									if (timeValue[0] != '-') {
										total += el.energy / 1000;
									}
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
		let colorArr = [
			"var(--powder-blue)",
			"var(--turquoise)",
			"var(--teal)",
			"var(--light-blue)",
			"var(--blueberry)",
			"var(--royal-blue)",
			"var(--blue-yonder)",
			"var(--circle-solar-power)",
			"var(--deep-lilac)",
			"var(--yellow-green)",
			"var(--green)",
			"var(--eucalyptus)",
			"var(--french-pass)",
			"var(--malibu)",
			"var(--vivid-blue)",
		];
		let chartStyle = $('#chartStyle button').data('value'); //현재 선택된 스타일

		accociation.forEach(function (v, k) {
			if (JSON.stringify(v) != '{}') {
				let sorted = Object.entries(v);
				sorted.sortOn("name", 1);

				$.each(sorted, function (i, el) {
					let itm = el[1][0].items;
					let deviceNm = el[1][0].name;
					let arrDevice = new Array();
					let sid = el[1][0].sid;
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

						const chartTimeValue = Number(String(displayNumberFixedUnit(timeValue, 'Wh', 'kWh', 0)[0]).replace(/[^0-9]/g, ''));
						arrDevice.push([
							stnd, chartTimeValue
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

					let $temp = {};

					if( accociation.size === 1 && v.length === 1){
						$temp = {
							name: deviceNm,
							type: 'column',
							stack: stack,
							sid: sid,
							tooltip: {
								valueSuffix: 'Wh',
							},
							total: totalCurrent,
							color: colorArr[1],
							data: arrDevice
						};
					} else {
						$temp = {
							name: deviceNm,
							type: 'column',
							stack: stack,
							sid: sid,
							tooltip: {
								valueSuffix: 'Wh',
							},
							total: totalCurrent,
							color: colorArr[num],
							data: arrDevice
						};
					}
					seriesData.push($temp);
					num++;
				});
			}
		});

		chartDraw(standard, seriesData);

		//발전량 합계
		$('.value-wrapper').empty();
		$('#pvTable').removeClass("hidden");
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

			$.each(totalArr, function (i, el) {
				let totTitle = '<h3 class="value-title">' + el.name + '</h3>';
				let refined = displayNumberFixedUnit(el.totVal, 'Wh', 'kWh', 0);
				// console.log("el.totVal---", el.totVal)
				totTitle += '<p class="value-num"><span class="num">' + refined[0] + '</span>' + refined[1] + '</p>';
				$('.value-wrapper').append(totTitle);
			});
		}

		const now = new Date();
		$('.text-time').text(now.format('yyyy-MM-dd HH:mm:ss'));
	}

	const chartDraw = function (standard, seriesData) {
		let chart = $('#chart2').highcharts();
		$('#chart2').parents().closest(".clear.hidden").removeClass("hidden");
		$(".indiv.chart-pv").addClass("fixed");

		if (chart) {
			chart.destroy();
		}

		let option = {
			chart: {
				renderTo: 'chart2',
				marginTop: 50,
				marginLeft: 60,
				marginRight: 30,
				backgroundColor: 'transparent',
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
			xAxis: [{
				lineColor: 'var(--grey)',
				labels: {
					align: 'center',
					style: {
						color: 'var(--grey)',
						fontSize: '8px'
					},
					y: 50,
					formatter: function () {
						return dateFormat(this.value);
					},
					enabled: true,
					rotation: -45
				},
				categories: standard,
				title: {
					text: null
				},
				crosshair: true
			}],
			yAxis: {
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				min: 0,
				title: {
					text: '(kWh)',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 5,
					style: {
						color: 'var(--grey)',
						fontSize: '10px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -20,
					style: {
				
						color: 'var(--grey)',
						fontSize: '10px'
					}
				}
			},
			legend: {
				enabled: true,
				align: 'right',
				verticalAlign: 'top',
				x: -10,
				y: -15,
				itemStyle: {
					color: 'var(--white87)',
					fontSize: '12px',
					fontWeight: 400
				},
				itemHoverStyle: {
					color: ''
				},
				symbolPadding: 0,
				symbolHeight: 7
			},
			tooltip: {
				formatter: function () {
					return this.points.reduce(function (s, point) {
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + numberComma(point.y) + 'kWh';
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
				column: {
					stacking: 'normal'
				},
				line: {
					marker: {
						enabled: false
					}
				}
			},
			credits: {
				enabled: false
			},
			series: seriesData,
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