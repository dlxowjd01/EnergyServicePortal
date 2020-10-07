<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">발전 예측</h1>
	</div>
	<div class="dropdown-wrapper col-lg-2">
		<div class="dropdown" id="siteList">
			<button type="button" class="dropdown-toggle" data-toggle="dropdown">
				<fmt:message key="genforecast.1.select" /><span class="caret"></span>
			</button>
			<ul class="dropdown-menu chk-type"></ul>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-3 col-md-4">
		<div class="indiv chart-diagnosis">
			<h2 class="ntit"><fmt:message key="genforecast.2.forecast_summary" /></h2>
			<div class="value-wrapper">
				<h3 class="value-title"><fmt:message key="genforecast.2.actual" /></h3>
				<p class="value-num"></p>
			</div>
			<div class="value-wrapper">
				<h3 class="value-title"><fmt:message key="genforecast.2.forecasted" /></h3>
				<p class="value-num"></p>
			</div>
			<div class="value-wrapper">
				<h3 class="value-title"><fmt:message key="genforecast.2.forecast_err_average" /></h3>
				<p class="value-num"></p>
			</div>
			<div class="toggle-box">
				<div class="table-area clear">
					<p class="table-text fl"><fmt:message key="genforecast.2.forecast_err_method" /></p>
					<button type="button" class="table-fold-btn fr">펼치기</button>
				</div>
				<div class="table-fold-container">
					<div class="dropdown" id="measure">
						<button type="button" class="dropdown-toggle w8" data-toggle="dropdown"
							data-value="NMAE">
							NMAE<span class="caret"></span>
						</button>
						<ul class="dropdown-menu">
							<li data-value="NMAE" class="on">
								<a href="javascript:void(0);">NMAE</a>
							</li>
							<li data-value="MAPE"><a href="javascript:void(0);">MAPE</a></li>
							<li data-value="RRMSE"><a href="javascript:void(0);">RRMSE</a></li>
						</ul>
					</div>
					<p class="table-text">오차 계산 데이터 필터</p>
					<div class="dropdown mb-10" id="ignore_ref">
						<button type="button" class="dropdown-toggle" data-toggle="dropdown">
							용량 대비 발전량 % 이상<span class="caret"></span>
						</button>
						<ul class="dropdown-menu">
							<li data-value="" class="on">
								<a href="javascript:void(0);"><fmt:message key="genforecast.2.all" /></a>
							</li>
							<li data-value="capacity">
								<a href="javascript:void(0);"><fmt:message key="genforecast.2.power_gen_overcapacity" /></a>
							</li>
							<li data-value="observation">
								<a href="javascript:void(0);"><fmt:message key="genforecast.2.generation_kwhormore" /></a>
							</li>
						</ul>
					</div>
					<div class="flex-wrapper">
						<div class="text-input-type unit w-100">
							<input type="number" name="ignore_tolerance1" />
							<span>%</span>
						</div>
						<div class="text-input-type unit t1 w-100">
							<input type="number" name="ignore_tolerance2" />
							<span>kWh</span>
						</div>
					</div>
					<button type="button" class="btn-type" id="application">
						<fmt:message key="genforecast.2.apply" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<div class="col-lg-9 col-md-8">
		<div class="indiv chart-diagnosis">
			<div class="chart-top">
				<div id="deviceType">
					<span class="tx-tit"><fmt:message key="genforecast.3.measured_data" /></span>
					<div class="sa-select">
						<div class="dropdown">
							<button type="button" class="dropdown-toggle w7" type="button" data-toggle="dropdown" data-name="복수 선택">
								<fmt:message key="genforecast.3.multiple_selection" /><span class="caret"></span>
							</button>
							<div class="dropdown-menu chk-type"><!--
							--><ul class="dropdown-cov clear selectDevices"></ul><!--
							--><div class="li-btn-box clear">
									<div class="fl">
										<button type="button" class="btn-type03"><fmt:message key="genforecast.3.selectall" /></button>
										<button type="button" class="btn-type03"><fmt:message key="genforecast.3.clearall" /></button>
									</div>
									<div class="end">
										<button type="button" class="btn-type fr"><fmt:message key="genforecast.3.apply" /></button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="inline-flex">
					<div class="period">
						<span class="tx-tit">기간</span>
						<div class="sa-select">
							<div class="dropdown" id="period">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="오늘">
									<fmt:message key="genforecast.3.today" /><span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li data-value="today" class="on"><a href="javascript:void(0);"><fmt:message key="genforecast.3.today" /></a></li>
									<li data-value="week"><a href="javascript:void(0);"><fmt:message key="genforecast.3.thisweek" /></a></li>
									<li data-value="month"><a href="javascript:void(0);"><fmt:message key="genforecast.3.thismonth" /></a></li>
									<li data-value="setup"><a href="javascript:void(0);"><fmt:message key="genforecast.3.period" /></a></li>
								</ul>
							</div>
						</div>
					</div>

					<div class="duration" id="dateArea">
						<span class="tx-tit"><fmt:message key="genforecast.3.period" /></span>
						<div class="sel-calendar">
							<input type="text" id="fromDate" class="sel fromDate" value="" autocomplete="off" readonly /></div>
						<div class="sel-calendar">
							<input type="text" id="toDate" class="sel toDate" value="" autocomplete="off" readonly /></div>
					</div>

					<div class="unit" id="cycle">
						<span class="tx-tit">단위</span>
						<div class="sa-select">
							<div class="dropdown" id="interval">
								<button type="button" class="dropdown-toggle w3" data-toggle="dropdown">
									<fmt:message key="genforecast.3.term" /><span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li data-value="15min" class="on"><a href="javascript:void(0);"><fmt:message key="genforecast.3.15min" /></a></li>
									<li data-value="hour"><a href="javascript:void(0);"><fmt:message key="genforecast.3.1hr" /></a></li>
									<li data-value="day"><a href="javascript:void(0);"><fmt:message key="genforecast.3.1day" /></a></li>
									<li data-value="month"><a href="javascript:void(0);"><fmt:message key="genforecast.3.1month" /></a></li>
								</ul>
							</div>
						</div>
					</div>
					<button type="button" class="btn-type" id="renderBtn"><fmt:message key="genforecast.3.update" /></button>
				</div>
			</div>
			<a href="javascript:void(0);" class="link-chart-change" id="changeChart">그래프</a>
			<div class="inchart">
				<p class="text-time"></p>
				<div id="chart2"></div>
			</div>
		</div>
	</div>
</div>


<div class="row chart-pv-table">
	<div class="col-lg-12">
		<div class="indiv table-diagnosis">
			<div class="table-save-box">
				<a href="javascript:void(0);" class="btn-save"><fmt:message key="genforecast.4.dataextracts" /></a>
			</div>
			<div class="table-top clear">
				<h2 class="ntit fl"><fmt:message key="genforecast.4.datatable" /></h2>
				<ul class="fr">
					<li><a href="javascript:void(0);" class="btn-fold">표접기</a></li>
				</ul>
			</div>
			<div class="table-wrapper">
				<div class="fold-box" id="table-desktop"></div>
			</div>
		</div>
	</div>
</div>
<form name="form" method="post">
	<input type="hidden" name="observed" />
	<input type="hidden" name="forecasted" />
	<input type="hidden" name="sid" />
	<input type="hidden" name="did" />
	<input type="hidden" name="measure" />
	<input type="hidden" name="ignore_ref" />
	<input type="hidden" name="ignore_tolerance" />
	<input type="hidden" name="interval" />
</form>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	let standard = new Array();
	let deferreds = new Array();
	let accociation = new Map();
	let dup = false;
	let applicationData = {
		observed: null,
		observedType: 'column',
		forecasted: null,
		forecastedType: 'column'
	};

	$(function () {
		makeSiteList(); //사이트 조회

		//전체 선택/전체 해제
		$('#deviceType button.btn-type03').on('click', function (e) {
			var idx = $('#deviceType button.btn-type03').index($(this));

			if (idx == 0) {
				$(':checkbox[name="device"]').prop('checked', true);
				$('#deviceType button').eq(0).html('전체 <span class="caret"></span>');
			} else {
				$(':checkbox[name="device"]').prop('checked', false);
				$('#deviceType button').eq(0).html('복수 선택 <span class="caret"></span>');
			}
		});

		$('#renderBtn').on('click', function () {
			fetchGenData();
		});

		$('#period li').on('click', function () {
			if ($(this).data('value') == 'today') { //오늘
				$('#fromDate').datepicker('setDate', 'today'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			} else if ($(this).data('value') == 'week') { //이번주
				$('#fromDate').datepicker('setDate', '-6'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			} else { //이번달
				$('#fromDate').datepicker('setDate', '-30'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			}
		});

		$('.table-fold-btn').click(function () {
			var tbl_height = $(".table-fold-container").height();
			$('.table-fold-container').slideToggle();
			$(this).toggleClass("on");
			$(this).text($(this).text() == '내용접기' ? '펼치기' : '내용접기');
		});

		//몬가를 선택함.
		$('#measure li').on('click', function () {
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).html($(this).find('a').text() + '&nbsp;<span class="caret"></span>');
		});

		//몬가를 선택함.
		$('#interval li').on('click', function () {
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).html($(this).find('a').text() + '&nbsp;<span class="caret"></span>');
		});

		//몬가를 선택함.
		$('#ignore_ref li').on('click', function () {
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).html($(this).find('a').text() + '&nbsp;<span class="caret"></span>');
			if ($(this).data('value') == 'capacity') {
				$('input[name="ignore_tolerance1"]').prop('disabled', false);
				$('input[name="ignore_tolerance2"]').prop('disabled', true);
			} else if ($(this).data('value') == 'observation') {
				$('input[name="ignore_tolerance1"]').prop('disabled', true);
				$('input[name="ignore_tolerance2"]').prop('disabled', false);
			} else {
				$('input[name="ignore_tolerance1"]').prop('disabled', false);
				$('input[name="ignore_tolerance2"]').prop('disabled', false);
			}
		});

		$('#changeChart').on('click', function () {

			if (applicationData.type == '3') {
				applicationData.type = '1';
				applicationData.observedType = 'column';
				applicationData.forecastedType = 'column';
			} else if (applicationData.type == '2') {
				applicationData.type = '3';
				applicationData.observedType = 'spline';
				applicationData.forecastedType = 'spline';
			} else {
				applicationData.type = '2';
				applicationData.observedType = 'column';
				applicationData.forecastedType = 'spline';
			}

			chartMakeData();
		});

		$('.btn-save').on('click', function (e) {
			let excelName = '발전예측';
			let $val = $('#table-desktop').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {
					tableToExcel('table-desktop', excelName, e);
				}
			}
		});

		//올차범위 조회
		$('#application').on('click', function () {
			application();
		});

		$('#fromDate').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
	});

	const rtnDropdown = ($dropdownId) => {
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

	const application = function (stat) {
		const sites = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		//체크된 디바이스
		const checkedDevices = new Array();
		document.querySelectorAll('input[name="device"]:checked').forEach(chk => {
			const did = chk.dataset['did'];
			if (!isEmpty(did)) {
				if (did.match(',')) {
					const dids = did.split(',');
					dids.forEach(di => {
						if (!checkedDevices.includes(di)) {
							checkedDevices.push(di);
						}
					});
				} else {
					if (!checkedDevices.includes(did)) {
						checkedDevices.push(did);
					}
				}
			}
		});

		if (stat == 'basic') {
			$('#measure li a').eq(0).addClass('on');
			$('#measure button').data('value', 'NMAE').html('NMAE &nbsp;<span class="caret"></span>');

			$('#ignore_ref li a').eq(1).addClass('on');
			$('#ignore_ref button').data('value', 'capacity').html('용량 대비 발전량 % 이상 &nbsp;<span class="caret"></span>');

			$('input[name="ignore_tolerance1"]').val('10');
			$('input[name="ignore_tolerance2"]').val('');
		}

		let ignore_ref = $('#ignore_ref button').data('value');
		let ignore_tolerance = null;
		if (ignore_ref == 'capacity') {
			ignore_tolerance = $('input[name="ignore_tolerance1"]').val();
		} else if (ignore_ref == 'observation') {
			ignore_tolerance = $('input[name="ignore_tolerance2"]').val();
		} else {
			ignore_ref = null;
			ignore_tolerance = null;
		}

		if (!isEmpty(applicationData.observed) && !isEmpty(applicationData.forecasted)) {
			let data = {
				'observed': applicationData.observed,
				'forecasted': applicationData.forecasted,
				'sid': sites,
				'did': checkedDevices,
				'measure': $('#measure button').data('value'),
				'ignore_ref': ignore_ref,
				'ignore_tolerance': ignore_tolerance,
				'interval': $('#interval button').data('value')
			}

			$.ajax({
				url: apiHost + '/energy/forecasting/error_calculator',
				type: "post",
				async: false,
				contentType: "application/json",
				traditional: true,
				data: JSON.stringify(data),
				success: function (result) {
					$('.value-num').eq(2).empty();
					if (result != null && result != '' && result.message == 'OK') {
						let calWat = result.value;
						if (calWat != null) {
							$('.value-num').eq(2).append('<span class="num">' + calWat.toFixed(2) + '</span>%');
						} else {
							alert('예측 오차 계산의 비교 대상 데이터가 없습니다.');
							$('.value-num').eq(2).append('<span class="num"> </span>%');
						}
					}
				},
				error: function (error) {
					$('.value-num').eq(2).empty();
					console.error(error);
				}
			});
		}
	};

	//사업소 호출
	const makeSiteList = function () {
		$('#siteList ul').empty();

		let str = '';
		siteList.forEach((site, index) => {
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
		$('#deviceType .dropdown-toggle').empty().append('복수 선택').append('<span class="caret"></span>');

		if ($(':checkbox[name="site"]:checked').length > 0) {
			$('#deviceType .sec-li-box').remove();
			$(':checkbox[name="site"]:checked').each(function () {
				const sid = $(this).val()
					, sNm = $(this).next('label').text()
					, dashboardArray = new Array()
					, billingArray = new Array();

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
							let siteGrp = $('<div>').addClass('sec-li-box');
							siteGrp.append('<p>');
							siteGrp.find('p').addClass('tx-li-title').text(sNm);
							siteGrp.append('<ul>');

							let chargeArr = new Array();
							let dashArr = new Array();
							let deviceType = ['SM', 'SM_ISMART', 'SM_KPX', 'SM_CRAWLING', 'SM_MANUAL', 'INV_PV', 'INV_WIND', 'PCS_ESS', 'BMS_SYS',
								'BMS_RACK', 'SENSOR_SOLAR', 'SENSOR_FLAME', 'SENSOR_TEMP_HUMIDITY', 'CCTV', 'COMBINER_BOX', 'CIRCUIT_BREAKER'
							];
							$.each(devices, function (i, el) {
								if (el.billing) billingArray.push(el.did);
								if (el.dashboard) dashboardArray.push(el.did);
								$.each(deviceType, function (j, tp) {
									if (tp == el.device_type && (el.dashboard || el.billing)) {
										let deviceHtml = $('<li>').append('<a>');
										deviceHtml.find('a').attr('href', '#').attr('tabindex', '-1');
										deviceHtml.find('a').append('<input id="' + el.did + '" name="device" type="checkbox" value="' + el.did + '" data-name="' + sNm + '_' + el.name + '" data-did="' + el.did + '">').append('<label>');
										deviceHtml.find('label').attr('for', el.did).append('<span>').append('&nbsp;' + el.name);
										siteGrp.find('ul').append(deviceHtml);
									}
								});
							});

							$('#deviceType .selectDevices').prepend(siteGrp);

							let deviceHtml1 = $('<li>').append('<a>');
							deviceHtml1.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml1.find('a').append('<input id="device_billing_' + sid + '" name="device" type="checkbox" value="' + sid + '" data-name="' + sNm + '_매전" data-did="' + billingArray.toString() + '">').append('<label>');
							deviceHtml1.find('label').attr('for', 'device_billing_' + sid).append('<span>').append('&nbsp;매전량');
							siteGrp.find('ul').prepend(deviceHtml1);

							let deviceHtml2 = $('<li>').append('<a>');
							deviceHtml2.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml2.find('a').append('<input id="device_dash_' + sid + '" name="device" type="checkbox" value="' + sid + '" data-name="' + sNm + '_대시보드" data-did="' + dashboardArray.toString() + '">').append('<label>');
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
		const startTime = $('#fromDate').val().replace(/-/g, '') + "000000";
		const endTime = $('#toDate').val().replace(/-/g, '') + "235959";
		//주기 확인
		let interval = $('#interval button').data('value');
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
		}

		let urls = new Array();
		accociation = new Map();

		//매전량
		if (billingSites.length > 0) {
			urls.push({
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
				}
			});
		}

		//매전량 예측
		if (billingSites.length > 0) {
			urls.push({
				url: apiHost + '/energy/forecasting/sites',
				type: "get",
				async: false,
				data: {
					sid: billingSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'billing',
					formId: 'v2'
				}
			});
		}

		//대시보드
		if (dashSites.length > 0) {
			urls.push({
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
				}
			});
		}

		//대시보드
		if (dashSites.length > 0) {
			urls.push({
				url: apiHost + '/energy/forecasting/sites',
				type: "get",
				async: false,
				data: {
					sid: dashSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'dashboard',
					formId: 'v2'
				}
			});
		}

		if (checkedDevices.length > 0) {
			//API 호출
			urls.push({
				url: apiHost + '/energy/devices',
				type: "get",
				async: false,
				data: {
					dids: checkedDevices.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval
				}
			});
		}

		if (checkedDevices.length > 0) {
			urls.push({
				url: apiHost + '/energy/forecasting/devices',
				type: "get",
				async: false,
				data: {
					dids: checkedDevices.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval
				}
			});
		}

		deferreds = new Array();
		urls.forEach(function (url) {
			let deferred = $.Deferred();
			deferreds.push(deferred);

			$.ajax(url).done(function (data) {
				data['url'] = url['url'];
				(function (deferred) {
					return deferred.resolve(data);
				})(deferred);
			}).fail(function (error) {
				console.log(error);
			});
		});

		$.when.apply($, deferreds).then(function () {
			let responseParams = [];
			for (let index = 0; index < arguments.length; index++) {
				let data = arguments[index];
				let genData = data['data'];
				if (data['url'].match('fore')) {
					Object.entries(genData).map(el => {
						if (el[1][0].items) {
							let energyData = el[1][0].items;
							if (accociation.get('prediction') == undefined) {
								accociation.set('prediction', energyData);

								if (accociation.get('actual') === undefined) {
									let dummy = new Array(energyData.length).fill('');
									accociation.set('actual', dummy);
								}
							} else {
								$.each(energyData, function (j, elj) {
									let dupData = false;
									let bt = elj.basetime;
									$.each(accociation.get('prediction'), function (k, elk) {
										if (elk.basetime == bt) {
											elk.energy += elj.energy;
											elk.money += elj.money;
											dupData = true;
										}
									});
									if (!dupData) {
										accociation.get('prediction').push(elj);
									}
								});
							}
						}
					});

					if (accociation.get('prediction') !== undefined && accociation.get('actual') === undefined) {
						let dummy = new Array();
						accociation.get('prediction').forEach(gData => {
							dummy.push({
								basetime: gData['basetime'],
								energy: null,
								money: null,
								cenergy: null,
								cmoney: null,
								denergy: null,
								dmoney: null
							});
						});
						accociation.set('actual', dummy);
					}
				} else {
					Object.entries(genData).map(el => {
						if (el[1][0].items) {
							let energyData = el[1][0].items;
							if (accociation.get('actual') == undefined) {
								accociation.set('actual', energyData);
							} else {
								$.each(energyData, function (j, elj) {
									let dupData = false;
									let bt = elj.basetime;
									$.each(accociation.get('actual'), function (k, elk) {
										if (elk.basetime == bt) {
											elk.energy += elj.energy;
											elk.money += elj.money;
											dupData = true;
										}
									});
									if (!dupData) {
										accociation.get('actual').push(elj);
									}
								});
							}
						}
					});

					if (accociation.get('actual') !== undefined && accociation.get('prediction') === undefined) {
						let dummy = new Array();
						accociation.get('actual').forEach(gData => {
							dummy.push({
								basetime: gData['basetime'],
								energy: null,
								money: null,
								cenergy: null,
								cmoney: null,
								denergy: null,
								dmoney: null
							});
						});
						accociation.set('prediction', dummy);
					}
				}
			}

			// 순서대로 모아진 결과를 화면에 출력하기
			if (!dup) {
				dup = true;
				drawPage();
			}
		});
	}

	function drawPage() {
		$('table.table-desktop tbody').empty();

		let interval = $('#interval button').data('value');

		standard = makeStandard(interval);
		let gridData = gridDataMake(interval);

		let totalArr = new Array();
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
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								$dataTd.html(data);
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
					time = el.substring(8, 10) + ':' + el.substring(10, 12);
					th.text(time);
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
								let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									$dataTd.html(data);
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
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								$dataTd.html(data);
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
					time = el.substring(6, 8);
					th.text(time);
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
								let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									$dataTd.html(data);
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
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								$dataTd.html(data);
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
		$(".indiv.chart-diagnosis").addClass("fixed");
		$(".indiv.table-diagnosis").addClass("fixed");
		chartMakeData(interval);
		dup = false;
	}

	//그리드 데이터 만들기
	function gridDataMake(type) {
		let dataArr = new Array();

		accociation.forEach(function (val, key) {
			if (val != undefined) {
				let arr = val;
				arr.sort(function (a, b) {
					return a['basetime'] - b['basetime'];
				});

				let arrDevice = new Array();
				let stdDate = '';
				let total = 0;
				$.each(standard, function (j, stnd) {
					let timeValue = '-';
					if (stdDate == '') {
						if (type == 'day') {
							stdDate = stnd.substring(0, 6);
						} else if (type == 'month') {
							stdDate = stnd.substring(0, 4);
						} else {
							stdDate = stnd.substring(0, 8);
						}
					} else if (stdDate != '' &&
						(((type == '15min' || type == 'hour') && stdDate != stnd.substring(0, 8)) ||
							(type == 'day' && stdDate != stnd.substring(0, 6)) ||
							(type == 'month' && stdDate != stnd.substring(0, 4))) ||
						standard.length == j + 1) {
						if (standard.length == j + 1) {
							$.each(arr, function (k, elk) {
								let basetime = String(elk.basetime);
								if (basetime.match(stnd)) {
									timeValue = displayNumberFixedUnit(elk.energy, 'Wh', 'kWh', 2);
									total += elk.energy;
								}
							});

							arrDevice.push(timeValue[0]);
						}
						let totalArr = displayNumberFixedUnit(total, 'Wh', 'kWh', 2);
						arrDevice.push(totalArr[0]); //합계.

						let dataName = '';
						if (key == 'actual') {
							dataName = '실측';
						} else {
							dataName = '예측';
						}

						dataArr.push({
							name: dataName,
							id: key,
							std: stdDate,
							data: arrDevice
						});

						if (type == 'day') {
							stdDate = stnd.substring(0, 6);
						} else if (type == 'month') {
							stdDate = stnd.substring(0, 4);
						} else {
							stdDate = stnd.substring(0, 8);
						}
						total = 0;
						arrDevice = new Array();
					}

					$.each(arr, function (k, elk) {
						let basetime = String(elk.basetime);
						if (basetime.match(stnd)) {
							timeValue = displayNumberFixedUnit(elk.energy, 'Wh', 'kWh', 2);
							total += elk.energy;
						}
					});

					arrDevice.push(timeValue[0]);
				});
			}
		});

		return dataArr;
	}

	//차트
	const chartMakeData = function (type) {
		let seriesData = new Array();
		let num = 0;
		let colorArr = ['var(--turquoise)',
						'var(--sandy-brown)',
						'var(--cream-can)',
						'var(--summer-sky)',
						'var(--orange-red)',
						'var(--blue-yonder)',
						'var(--eucalyptus)',
						'var(--yellow-green)',
						'var(--sea-pink)',
						'var(--deep-lilac)',
						'var(--grey)',
						'var(--vivid-blue)'];

		accociation.forEach(function (val, key) {
			if (val != undefined) {
				let arr = val;
				arr.sort(function (a, b) {
					return a['basetime'] - b['basetime'];
				});

				let arrDevice = new Array();
				let dummy = new Array();
				let stdDate = '';
				let total = 0;
				$.each(standard, function (j, stnd) {
					let timeValue = null;
					let timeValue2 = null;
					if (stdDate == '') {
						stdDate = stnd.substring(0, 8);
					} else if (standard.length == j + 1) {
						$.each(arr, function (k, elk) {
							let basetime = String(elk.basetime);
							if (basetime.match(stnd)) {
								timeValue = Number((elk.energy / 1000).toFixed(2));
								total += timeValue;
							}
						});
						arrDevice.push([
							stnd, timeValue
						]);

						let dataName = '';
						if (key == 'actual') {
							dataName = '실측';
							let $temp = {
								name: dataName,
								type: applicationData.observedType,
								stack: 0,
								tooltip: {
									valueSuffix: 'kWh'
								},
								color: colorArr[0],
								data: arrDevice
							};
							seriesData.push($temp);
							applicationData.observed = dummy;
							summary(total, 0);
						} else {
							dataName = '예측';
							let $temp = {
								name: dataName,
								type: applicationData.forecastedType,
								stack: 1,
								tooltip: {
									valueSuffix: 'kWh'
								},
								color: colorArr[1],
								data: arrDevice
							};
							seriesData.push($temp);
							applicationData.forecasted = dummy;
							summary(total, 1);
						}
						arrDevice = new Array();
					}

					$.each(arr, function (k, elk) {
						let basetime = String(elk.basetime);
						if (basetime.match(stnd)) {
							timeValue = Number((elk.energy / 1000).toFixed(2));
							timeValue2 = elk.energy;
							total += timeValue;
						}
					});

					if (timeValue == null || timeValue == '') {
						dummy.push(0);
					} else {
						dummy.push(timeValue2);
					}

					arrDevice.push([
						stnd, timeValue
					]);
				});
			}
		});

		chartDraw(seriesData);

		application('basic');
	}

	/**
		* 차트 그리기
		*
		* @param standard
		* @param seriesData
		*/
	const chartDraw = function (seriesData) {
		let chart = $('#chart2').highcharts();
		if (chart) {
			chart.destroy();
		}

		let option = {
			chart: {
				renderTo: 'chart2',
				marginLeft: 60,
				marginRight: 20,
				backgroundColor: 'transparent',
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
						color: 'var(--white)',
						fontSize: '18px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -20,
					/* 그래프와의 거리 조정 */
					style: {
						color: 'var(--white)',
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
					color: 'var(--white)',
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
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(point.y) + point.series.userOptions.tooltip.valueSuffix;
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

	function summary(total, type) {
		let loopCnt = 0;
		for (let k = 0; k < 4; k++) {
			if (String(Math.round(total)).length > 3) {
				total = total / 1000
				loopCnt++;
			}
		}

		let unit = 'kWh';
		if (loopCnt == 1) {
			unit = 'MWh';
		} else if (loopCnt == 2) {
			unit = 'GWh';
		} else {
			unit = 'kWh';
		}

		$('.value-num').eq(type).empty().append('<span class="num">' + total.toFixed(2) + '</span>' + unit);
	}

	function dateFormat(val) {
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