let apiDatas = new Object();
let yearData = getSiteMainSchCollection('year');
let monthData = getSiteMainSchCollection('month');
let yesterData = getSiteMainSchCollection('yesterday');
let dayData = getSiteMainSchCollection('day');
let hourData = getSiteMainSchCollection('hour');
let minIntervalCount = 0;

//대시보드 먼슬리 && 데일리 차트 시리증 설정.
const seriesArray = [
	{name: i18nManager.tr("dashboard_charge"), type: 'column', color: 'var(--circle-charge)', data: 'chargeList', suffix: 'kWh'},
	{name: i18nManager.tr("dashboard_discharge"), type: 'column', color: 'var(--grey)', data: 'dischargeList', suffix: 'kWh'},
	{name: i18nManager.tr("dashboard_photovoltaic"), type: 'column', color: 'var(--circle-solar-power)', data: 'pvList', suffix: 'kWh'},
	{name: i18nManager.tr("dashboard_payment"), type: 'spline', color: 'var(--white)', data: 'payList', suffix: i18nManager.tr("gmain.1000won")},
];

const typeSeriesArray = [
	{name: i18nManager.tr("dashboard_generation"), type: 'column', color: 'var(--turquoise)', data: 'yesterdayGenList', suffix: 'kWh'},
	{name: i18nManager.tr("dashboard_generation_forecast"), type: 'column', color: 'var(--grey)', data: 'yesterdayForeList', suffix: 'kWh'}
];

// 특수문자 정규식 변수(공백 미포함)
const replaceChar = /[~!@\#$%^&*\()\-=+_'\;<>\/.\`:\"\\,\[\]?|{}]/gi;
// 완성형 아닌 한글 정규식
const replaceNotFullKorean = /[ㄱ-ㅎㅏ-ㅣ]/gi;

/**
 * 그룹 & 중개거래 대시보드
 * 공통 이벤트 처리
 */
$(document).ready(function () {
	setInitList('alarmNotice'); //알람 공지 세팅
	$('#statusSiteList').find('.ESS').remove();
	setInitList('siteList'); //사이트 리스트

	// 모든 table 헤더에 클릭 이벤트를 설정한다.
	var tables = document.querySelectorAll("table.dashboard-sort");
	for (var i = 0; i < tables.length; ++i) {
		var headers = tables[i].getElementsByTagName("th");
		for (var j = 0; j < headers.length; ++j) {
			// 지역 유효범위에 생성할 중첩 함수
			(function (table, n) {
				headers[j].onclick = function () {
					let sort = 'down';
					if (this.getElementsByTagName('button')[0].classList.length == 1) {
						this.getElementsByTagName('button')[0].classList.add('down');
						sort = 'down';
					} else {
						if (this.getElementsByTagName('button')[0].classList[1] == 'up') {
							this.getElementsByTagName('button')[0].classList.replace('up', 'down');
							sort = 'down';
						} else {
							this.getElementsByTagName('button')[0].classList.replace('down', 'up');
							sort = 'up';
						}
					}

					for (var k = 0; k < headers.length; k++) {
						if (n != k) {
							if (!isEmpty(headers[k].getElementsByTagName('button')[0].classList)) {
								headers[k].getElementsByTagName('button')[0].classList.remove('up');
								headers[k].getElementsByTagName('button')[0].classList.remove('down');
							}
						}
					}
					SortTable(table, n, sort)
				};
			}(tables[i], j));
		}
	}

	//검색어 입력 제어 이벤트
	$("#searchName").on('focusout', function() {
		var x = $(this).val();
		if (x.length > 0) {
			if (x.match(replaceChar) || x.match(replaceNotFullKorean)) {
				x = x.replace(replaceChar, '').replace(replaceNotFullKorean, '');
			}
			$(this).val(x);
		}
	}).on('keyup', function() {
		$(this).val($(this).val().replace(replaceChar, ''));
	});

	$('img.next').on('click', function() {
		let siteSids = new Array();
		siteList.forEach(site => { siteSids.push(site.sid);});
		const standard = $(this).parent().find('span').data('standard');
		if ($('img.next').index(this) === 0) {
			standard.setFullYear(standard.getFullYear() + 1);
			if (today.getFullYear() <= standard.getFullYear()) {
				$(this).parent().find('img.next').addClass('hidden');
			} else {
				$(this).parent().find('img.next').removeClass('hidden');
			}
			$('#miniLoadingCircle_month').show();
			monthlyChartDraw(siteSids, standard);
		} else if ($('img.next').index(this) === 1) {
			standard.setMonth(standard.getMonth() + 1);
			if (((today.getFullYear() === standard.getFullYear()) && today.getMonth() > standard.getMonth()) || today.getFullYear() != standard.getFullYear()) {
				$(this).parent().find('img.next').removeClass('hidden');
			} else {
				$(this).parent().find('img.next').addClass('hidden');
			}
			$('#miniLoadingCircle_daily').show();
			dailyChartDraw(siteSids, standard);
		} else {
			const yesterday = new Date();
			yesterday.setDate(Number(today.getDate()) - 1);
			standard.setDate(standard.getDate() + 1);
			if (yesterday.getFullYear() === standard.getFullYear() && yesterday.getMonth() === standard.getMonth() && yesterday.getDate() === standard.getDate()) {
				$(this).parent().find('img.next').addClass('hidden');
			} else {
				$(this).parent().find('img.next').removeClass('hidden');
			}
			$('#miniLoadingCircle_type').show();
			typeSiteDraw(siteSids, standard);
		}
	});

	$('img.back').on('click', function() {
		let siteSids = new Array();
		siteList.forEach(site => { siteSids.push(site.sid);});
		const standard = $(this).parent().find('span').data('standard');
		if ($('img.back').index(this) === 0) {
			standard.setFullYear(standard.getFullYear() - 1);
			if (today.getFullYear() > standard.getFullYear()) {
				$(this).parent().find('img.next').removeClass('hidden');
			} else {
				$(this).parent().find('img.next').addClass('hidden');
			}
			$('#miniLoadingCircle_month').show();
			monthlyChartDraw(siteSids, standard);
		} else if ($('img.back').index(this) === 1) {
			standard.setMonth(standard.getMonth() - 1);
			if (((today.getFullYear() === standard.getFullYear()) && today.getMonth() > standard.getMonth()) || today.getFullYear() != standard.getFullYear()) {
				$(this).parent().find('img.next').removeClass('hidden');
			} else {
				$(this).parent().find('img.next').addClass('hidden');
			}
			$('#miniLoadingCircle_daily').show();
			dailyChartDraw(siteSids, standard);
		} else {
			const yesterday = new Date();
			yesterday.setDate(Number(today.getDate()) - 1);
			standard.setDate(standard.getDate() - 1);
			if (yesterday.getFullYear() === standard.getFullYear() && yesterday.getMonth() === standard.getMonth() && yesterday.getDate() === standard.getDate()) {
				$(this).parent().find('img.next').addClass('hidden');
			} else {
				$(this).parent().find('img.next').removeClass('hidden');
			}
			$('#miniLoadingCircle_type').show();
			typeSiteDraw(siteSids, standard);
		}
	});
});

/**
 * 페이지 초기 진입시
 * 필요한 데이터를 모두 조회한다. 
 */
const firstAjax = () => {
	yearData = getSiteMainSchCollection('year');
	monthData = getSiteMainSchCollection('month');
	yesterData = getSiteMainSchCollection('yesterday');
	dayData = getSiteMainSchCollection('day');
	hourData = getSiteMainSchCollection('hour');

	let siteSids = new Array();
	siteList.forEach(site => { siteSids.push(site.sid);});

	monthlyChartDraw(siteSids);
	dailyChartDraw(siteSids);
	typeSiteDraw(siteSids);
	getTodayTotalDetail(siteSids);
	searchSite(siteSids);
	alarmInfoList(siteSids);

	if (location.pathname.match('jmain')) {
		setRealtimeRecord(siteSids);
	}
}

/**
 * 1분마다 갱신할 API 데이터
 */
const minAjax = async () => {
	const targetApi = new Array();
	let siteSids = new Array();
	const today = new Date();
	siteList.forEach(site => { siteSids.push(site.sid); });

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/now/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
			metering_type: '2',
			interval: 'month'
		}),
		timeout: 50000
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/now/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
			metering_type: '2',
			interval: 'day'
		}),
		timeout: 50000
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/weather/site',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: Number(dayData.startTime),
			endTime: Number(dayData.endTime),
			interval: 'hour',
			formId: 'v2'
		})
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/alarms',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
			startTime: Number(dayData.startTime),
			endTime: Number(dayData.endTime),
			confirm: false
		})
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/status/health',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
		})
	}));

	const deviceRaw = new Array();
	siteList.forEach(site => {
		if (site.hasDevices) {
			deviceRaw.push(site.sid)
		}
	});

	targetApi.push($.ajax({
		url: apiHost + '/get/status/raw/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: deviceRaw.toString(),
			formId: 'v2',
			isLimited: true,
			displayType: 'dashboard',
			operation: 'overall'
		})
	}));

	siteList.forEach(site => {
		if (site.hasDevices) {
			targetApi.push($.ajax({
				url: apiHost + '/status/raw/site',
				type: 'GET',
				data: {
					sid: site.sid,
					formId: 'v2'
				}
			}));
		}
	});

	new Promise(resolve => {
		return resolve(Promise.all(targetApi));
	}).then(response => {
		let acPowerSum = 0, capacitySum = 0, invertorCount = 0, energySum = 0;
		response.forEach((resData, index) => {
			if (!isEmpty(resData)) {
				if (index === 0) {
					const standard = $('#monthlySum').parent().find('.term span').data('standard');
					//월간 차트
					let energy = 0, money = 0, cenergy = 0, denergy = 0;
					const siteNowEnergyData = resData['data'];
					Object.entries(siteNowEnergyData).forEach(([siteKey, siteData]) => {
						if (!isEmpty(siteData) && siteData['start'].toString().slice(0, 6) === String(today.getFullYear()) + ('0' + (today.getMonth() + 1)).slice(-2)) {
							if (!isEmpty(siteData['energy'])) { energy += siteData['energy']; }
							if (!isEmpty(siteData['cenergy'])) { cenergy += siteData['cenergy']; }
							if (!isEmpty(siteData['denergy'])) { denergy += siteData['denergy']; }
							if (!isEmpty(siteData['money'])) { money += siteData['money']; }
						}
					});

					if (today.getFullYear() === standard.getFullYear()) {
						let seriesLength = monthlyChart.series.length;
						for (let i = seriesLength - 1; i > -1; i--) {
							const seriesData = monthlyChart.series[i].yData;
							if (monthlyChart.series[i].name === i18nManager.tr("dashboard_payment")) {
								seriesData[today.getMonth()] = Math.round(money / 1000)
							} else if (monthlyChart.series[i].name === i18nManager.tr("dashboard_photovoltaic")) {
								seriesData[today.getMonth()] = Math.round(energy / 1000)
							}
							monthlyChart.series[i].setData(seriesData);
						}
						monthlyChart.redraw();
					}

					$('#monthlySum li.charge').html(i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal(Math.floor(cenergy / 1000), 'kWh', 3, 2).join(' '));
					$('#monthlySum li.discharge').html(i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal(Math.floor(denergy / 1000), 'kWh', 3, 2).join(' '));
					$('#monthlySum li.pv').html(i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal((Math.floor($('#monthlySum li.pv').data('part') + energy) / 1000), 'kWh', 3, 2).join(' '));
					//월간 차트
				} else if (index === 1) {
					const standard = $('#dailySum').parent().find('.term span').data('standard');
					//일간 차트
					let co2Sum = 0, moneySum = 0, cenergy = 0, denergy = 0;
					let energySum2 = 0, moneySum2 = 0;
					const siteNowEnergyData = resData['data'];
					let yesterDay = new Date();
					yesterDay.setDate(yesterDay.getDate() - 1);
					Object.entries(siteNowEnergyData).forEach(([siteKey, siteData]) => {
						if (!isEmpty(siteData)) {
							if (String(siteData['start']).substr(0, 8) === today.format('yyyyMMdd')) {
								if (!isEmpty(siteData['co2'])) { co2Sum += siteData['co2']; }
								if (!isEmpty(siteData['energy'])) { energySum += siteData['energy']; }
								if (!isEmpty(siteData['cenergy'])) { cenergy += siteData['cenergy']; }
								if (!isEmpty(siteData['denergy'])) { denergy += siteData['denergy']; }
								if (!isEmpty(siteData['money'])) { moneySum += siteData['money']; }
							} else if (String(siteData['start']).substr(0, 8) === yesterDay.format('yyyyMMdd')) {
								if (!isEmpty(siteData['energy'])) { energySum2 += siteData['energy']; }
								if (!isEmpty(siteData['money'])) { moneySum2 += siteData['money']; }
							}

							$('#siteList tr.dbclickopen').each(function() {
								if ($(this).data('sid') === siteKey) {
									$(this).find('td:eq(7)').text(numberComma(Math.round(siteData['energy'] / 1000)));

									const detail = $(this).next('tr.detail-info');
									detail.find('.di-bottom-sec .left .di-list li:eq(1) span.di-li-text').text(numberComma(Math.round(siteData['energy'] / 1000)));
								}
							});
						}
					});

					if (today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth()) {
						let yesterDayGen = Number($('#dailySum').data('yesterDayGen')) + energySum2;
						let yesterDayMoney = Number($('#dailySum').data('yesterDayMoney')) + moneySum2;
						let seriesLength = dailyChart.series.length;
						for (let i = seriesLength - 1; i > -1; i--) {
							const seriesData = dailyChart.series[i].yData;
							if (dailyChart.series[i].name === i18nManager.tr("dashboard_payment")) {
								seriesData[today.getDate() - 2] = Math.round(yesterDayMoney / 1000)
								seriesData[today.getDate() - 1] = Math.round(moneySum / 1000)
							} else if (dailyChart.series[i].name === i18nManager.tr("dashboard_photovoltaic")) {
								seriesData[today.getDate() - 2] = Math.round(yesterDayGen / 1000);
								seriesData[today.getDate() - 1] = Math.round(energySum / 1000);
							}
							dailyChart.series[i].setData(seriesData);
						}
						dailyChart.redraw();
					}

					$('#dailySum li.charge').html(i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal(Math.floor(cenergy / 1000), 'kWh', 3, 2).join(' '));
					$('#dailySum li.discharge').html(i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal(Math.floor(denergy / 1000), 'kWh', 3, 2).join(' '));
					$('#dailySum li.pv').html(i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal((Math.floor($('#dailySum li.pv').data('part') + energySum) / 1000), 'kWh', 3, 2).join(' '));
					//일간 차트

					$('.gmain-chart4 .chart-info-right ul li:nth-child(1) span').text(numberComma(Math.floor(energySum / 1000)));
					$('#centerTbody tr td:nth-child(5)').html(numberComma(Math.floor(co2Sum / 1000)) + '<em>&nbsp;&nbsp;kg</em>');
					$('#centerTbody tr td:nth-child(6)').html(numberComma(Math.floor(moneySum / 1000)) + '<em>&nbsp;&nbsp;'+i18nManager.tr('dashboard_in_thousands_of_won')+'</em>');
					energySum += energySum2; // 해외사업소가 잇는경우 다른날짜의 발전량이 같이 들어온다 그걸위해서 나눠서 저장해서 합침
				} else if (index === 2) {
					$('#siteList tr.dbclickopen').each(function() {
						const siteId = $(this).data('sid');
						let temperature = '-', humidity = '-';

						if (!isEmpty(resData)) {
							//시간 역순으로 정렬한 다음에 Observed 값을 만나면 그값이 쓰는값
							const weatherData = resData['data'];
							if (!isEmpty(weatherData) && !isEmpty(weatherData[siteId]) && !isEmpty(weatherData[siteId]['items'])) {
								const siteWeatherData = weatherData[siteId]['items'];
								siteWeatherData.sort((a, b) => {
									if (a.basetime > b.basetime) {return -1;}
									if (a.basetime < b.basetime) {return 1;}
									return 0;
								});

								const observedData = siteWeatherData.find(weather => weather.observed === true);
								if (!isEmpty(observedData)) {
									temperature = isEmpty(observedData['temperature']) ? '-' : observedData['temperature'];
									humidity = isEmpty(observedData['humidity']) ? '-' : observedData['humidity'];
								}
							}
						}

						const detail = $(this).next('tr.detail-info');
						detail.find('.di-top-sec .fr .tx2:eq(0)').text(temperature + ' °C');
						detail.find('.di-top-sec .fr .tx2:eq(1)').text(humidity + ' %');
					});
				} else if (index === 3) {
					$('#siteList tr.dbclickopen').each(function() {
						const siteId = $(this).data('sid');
						let alarmWarning = 0, alarmError = 0;
						if (!isEmpty(resData)) {
							resData.forEach(alarm => {
								if (siteId === alarm.sid) {
									if (alarm.level == 0 || alarm.level == 1 || alarm.level == 9) {
										alarmWarning++;
									} else {
										alarmError++;
									}
								}
							});
						}

						$(this).find('td:eq(1)').text(alarmError);
						$(this).find('td:eq(2)').text(alarmWarning);

						const detail = $(this).next('tr.detail-info');
						detail.find('.di-bottom-sec .right .di-text-box a p.tx span').text(numberComma(alarmWarning + alarmError) + ' 건');
					});
				} else if (index === 4) {
					$('#siteList tr.dbclickopen').each(function() {
						const siteId = $(this).data('sid');
						let rtuStatus = '';
						if (!isEmpty(resData) && !isEmpty(resData.sites)) {
							(resData.sites).forEach(data => {
								if (siteId === data.sid) {
									if (!isEmpty(data.rtus) && data.rtus.length > 0) {
										const operation = data.rtus.find(e => e.operation === 1);
										if (!isEmpty(operation)) {
											rtuStatus = '<span class="status-button normal">정상</span>';
										} else {
											rtuStatus = '<span class="status-button error">이상</span>';
										}
									} else {
										rtuStatus = '<span class="status-button error">이상</span>';
									}
								}
							});
						}

						$(this).find('td:eq(3)').html(rtuStatus);
					});
				} else {
					Object.entries(resData).forEach(([site_id, siteDevice]) => {
						let operation = new Array(), activePower = '', capacity = '',
							inverterCnt = '', irradiationPoa = '';
						Object.entries(siteDevice).forEach(([deviceType, deviceData]) => {
							if (!isEmpty(deviceData)) {
								if (deviceType.match('INV')) {
									if (!operation.includes(deviceData['operation'])) { operation.push(deviceData['operation']); }
									acPowerSum += (isEmpty(deviceData['activePower'])) ? 0 : Number(deviceData['activePower']);
									capacitySum += (isEmpty(deviceData['capacity'])) ? 0 : Number(deviceData['capacity']);
									invertorCount += (isEmpty(deviceData['devices'])) ? 0 : deviceData['devices'].length;

									activePower = (activePower != '-') ? Number(activePower) + Number(deviceData['activePower']) : Number(deviceData['activePower']);
									capacity = (capacity != '-') ? Number(capacity) + Number(deviceData['capacity']) : Number(deviceData['capacity']);
									inverterCnt = (!isEmpty(deviceData['devices'])) ? deviceData['devices'].length : '-';

									if ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < deviceData['timestamp'])) {
										const dbTime = new Date(deviceData['timestamp']);
										$('.dbTime').data('timestamp', deviceData['timestamp']).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
									}
								} else if (deviceType === 'SENSOR_SOLAR') {
									if (!isEmpty(deviceData) && !isEmpty(deviceData['irradiationPoa'])) {
										irradiationPoa = (deviceData['irradiationPoa']).toFixed(1);
									}
								}
							}
						});

						$('#siteList tr.dbclickopen').each(function() {
							if ($(this).data('sid') === site_id) {
								$(this).find('td:eq(5)').text(numberComma(Math.round(capacity / 1000)));
								$(this).data('operation', operation);

								const detail = $(this).next('tr.detail-info');
								detail.find('.di-top-sec .fl .tx2').text(irradiationPoa + ' W/㎡');
								detail.find('.di-bottom-sec .left .di-list li:eq(0) span.di-li-text').text(numberComma(Math.round(activePower / 1000)));
								detail.find('.di-bottom-sec .right .di-list li:eq(0) span.di-li-text').text(numberComma(Math.round(capacity / 1000)));
								detail.find('.di-bottom-sec .right .di-list li:eq(1) span.di-li-text').text(numberComma(inverterCnt));

								let activePercent = 0, title = '', etc = 0;
								if ((!isNaN(activePower) || activePower > 0) && (!isNaN(capacity) || capacity > 0)) {
									activePercent = Math.floor((activePower / capacity) * 100);
									etc = 100 - activePercent;
									title = activePercent + '%';
									if (isNaN(activePercent)) { title = '- %'; }
								} else {
									title = '0%';
									activePercent = 0;
									etc = 0;
								}

								const chartId = $(this).next('tr.detail-info').find('.inchart').attr('id');
								const targetChart = $('#' + chartId).highcharts();
								targetChart.setTitle({text: title});
								targetChart.series[0].data.forEach((e, idx) => {
									if (e.name === '현재 효율') {
										e.update({y: activePercent});
									} else {
										e.update({y: etc});
									}
								});
								targetChart.redraw();
							}
						});
					});
				}
			}
		});
		return {acPowerSum, capacitySum, invertorCount, energySum}
	}).then(({acPowerSum, capacitySum, invertorCount, energySum}) => {
		const usage = Math.floor((acPowerSum / capacitySum) * 100)
			, other = 100 - usage
			, generationHour = (Math.round((energySum / capacitySum) * 100) / 100).toFixed(2);

		$('#centerTbody tr td:nth-child(4)').html(generationHour + '<em>&nbsp;&nbsp;Hrs</em>');
		pieChart.setTitle({text: Math.floor(acPowerSum / 1000).toLocaleString() + 'kW'});
		pieChart.series[0].data.forEach((e, idx) => {
			if (e.name === i18nManager.tr("dashboard_photovoltaic")) {
				e.update({y: usage});
			} else if (e.name === i18nManager.tr("dashboard_unused_amount")) {
				e.update({y: other});
			} else {
				e.update({y: 0});
			}
		});
		pieChart.redraw();

		$('#centerTbody tr td:nth-child(2)').html(numberComma(invertorCount) + '<em>&nbsp;&nbsp;'+i18nManager.tr('dashboard_units')+'</em>');
		$('#centerTbody tr td:nth-child(3)').html(numberComma(Math.round(capacitySum / 1000)) + '<em>&nbsp;&nbsp;kW</em>');

		searchOperationSite();
	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});

	alarmInfoList(siteSids);

	if (location.pathname.match('jmain')) {
		setRealtimeRecord(siteSids);
	}
}


/**
 * 월간 차트
 * 조회기간 1년
 *
 * @returns {Promise<void | boolean>}
 */
const monthlyChartDraw = async (siteSids, standard) => {
	const targetApi = new Array();
	let startTime = '', endTime = '';
	if (standard != undefined && (today.getFullYear() != standard.getFullYear())) {
		$('.gmain-chart1 span.term span').text(standard.getFullYear() + '.01.01 ~ ' + standard.getFullYear() + '.12.31').data('standard', standard);
		startTime = Number(standard.getFullYear() + '0101000000'), endTime = Number(standard.getFullYear() + '1231235959');
	} else {
		$('.gmain-chart1 span.term span').text(today.getFullYear() + '.01.01 ~ ' + today.getFullYear() + '.' + ('0' + (Number(today.getMonth()) + 1)).slice(-2) + '.' + ('0' + today.getDate()).slice(-2)).data('standard', new Date());
		startTime = Number(yearData.startTime), endTime = Number(yearData.endTime);
	}

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: startTime,
			endTime: endTime,
			interval: 'month',
			displayType: 'dashboard',
			formId: 'v2'
		})
	}));

	if (standard === undefined || (today.getFullYear() === standard.getFullYear())) {
		targetApi.push($.ajax({
			url: apiHost + '/get/energy/now/sites',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify({
				sids: siteSids.toString(),
				metering_type: '2',
				interval: 'month'
			}),
			timeout: 50000
		}));
	}

	new Promise(resolve => {
		resolve(Promise.all(targetApi));
	}).then(response => {
		const chargeList = new Array(12).fill(0);
		const dischargeList = new Array(12).fill(0);
		const pvList = new Array(12).fill(0);
		const payList = new Array(12).fill(0);
		const sumObj = { chargeSum: 0, dischargeSum: 0, pvSum: 0, pvPart: 0 };
		response.forEach((resData, index) => {
			if (index === 1) {
				if (!isEmpty(resData)) {
					const siteNowEnergyData = resData['data'];
					Object.entries(siteNowEnergyData).forEach(([siteKey, siteData]) => {
						if (!isEmpty(siteData) && siteData['start'].toString().slice(0, 6) === String(today.getFullYear()) + ('0' + (today.getMonth() + 1)).slice(-2)) {
							const index = Number(siteData['start'].toString().slice(4, 6)) - 1;
							if (!isEmpty(siteData['energy'])) {
								pvList[index] += siteData['energy'];
								sumObj['pvSum'] += siteData['energy'];
							}

							if (!isEmpty(siteData['money'])) {
								payList[index] += siteData['money'];
							}
						}
					});
				}
			} else {
				if (!isEmpty(resData)) {
					const siteEnergyData = resData['data'];
					if (!isEmpty(siteEnergyData)) {
						Object.entries(siteEnergyData).forEach(([siteId, siteEnergyItem]) => {
							if (!isEmpty(siteEnergyItem)) {
								siteEnergyItem.forEach(siteEnergy => {
									const items = siteEnergy['items'];
									if (!isEmpty(items)) {
										items.forEach(item => {
											const index = Number(String(item['basetime']).slice(4, 6)) - 1;
											chargeList[index] += item['cenergy'];
											sumObj['chargeSum'] += item['cenergy'];

											dischargeList[index] += item['denergy'];
											sumObj['dischargeSum'] += item['denergy'];

											pvList[index] += item['energy'];
											payList[index] += item['money'];
											sumObj['pvSum'] += item['energy'];
											sumObj['pvPart'] += item['energy'];
										});
									}
								});
							}
						});
					}
				}
			}
		});

		return {chargeList, dischargeList, pvList, payList, sumObj};
	}).then(({chargeList, dischargeList, pvList, payList, sumObj}) => {
		let maxValue = 0;
		let seriesLength = monthlyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			monthlyChart.series[i].remove();
		}

		seriesArray.forEach((el, index) => {
			let totalValue = 0;
			let chartSeries = new Object();
			chartSeries.name = el.name;
			chartSeries.type = el.type;
			chartSeries.color = el.color;
			chartSeries.data = eval(el.data);

			if (!isEmpty(chartSeries.data)) {
				(chartSeries.data).forEach((e, index) => { (chartSeries.data)[index] = Math.floor(e / 1000); });
				const targetMaxValue = (chartSeries.data).reduce( function (previous, current) {
					return previous > current ? previous:current;
				});

				totalValue = (chartSeries.data).reduce( function add(sum, currValue) {
					return sum + currValue;
				});

				if (maxValue < targetMaxValue) { maxValue = targetMaxValue; }
			}

			if ((index === 0 || index === 1) && totalValue === 0) {
				chartSeries.showInLegend = false
			} else if (index === 3) {
				chartSeries.dashStyle = 'ShortDash';
				chartSeries.yAxis = 1;
			}

			chartSeries.tooltip = {valueSuffix: (/원/.test(el.suffix)) ? '만원' : el.suffix}
			monthlyChart.addSeries(chartSeries, false);
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'kWh', 3, 2);
		const rtnUnit = refineMaxValue[1];

		monthlyChart.yAxis[0].setTitle({
			text: rtnUnit,
			align: 'low',
			rotation: 0,
			y: 25,
			x: 40,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		});
		monthlyChart.redraw();

		new Promise(resolve => {
			let str = '';
			Object.entries(sumObj).forEach(([key, value]) => {
				if (key === 'chargeSum') {
					str += '<li class="charge">' + i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal(Math.floor(value / 1000), 'kWh', 3, 2).join(' ') + '</li>';
				}
				if (key === 'dischargeSum') {
					str += '<li class="discharge">' + i18nManager.tr('dashboard_discharge') + ' : ' + displayNumberFixedDecimal(Math.floor(value / 1000), 'kWh', 3, 2).join(' ') + '</li>';
				}
				if (key === 'pvSum') {
					str += '<li class="pv" data-part="' + sumObj.pvPart + '">' + i18nManager.tr('dashboard_photovoltaic') + ' : ' + displayNumberFixedDecimal(Math.floor(value / 1000), 'kWh', 3, 2).join(' ') + '</li>';
				}
			});

			resolve(str);
		}).then(res => {
			$('#monthlySum').append(res);
		});
	}).catch(error => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	}).finally(() =>{
		$('#miniLoadingCircle_month').hide();
	});
}

/**
 * 일별차트 데이터 가공
 *
 * @returns {Promise<void | boolean>}
 */
const dailyChartDraw = async (siteSids, standard) => {
	const today = new Date();
	let lastDay = 0, startTime = '', endTime = '';
	if (standard !== undefined && (today.getFullYear() != standard.getFullYear() || today.getMonth() != standard.getMonth())) {
		lastDay = new Date(standard.getFullYear(), standard.getMonth() + 1, 0);
		$('.gmain-chart2 span.term span').text(standard.format('yyyy.MM') + '.01 ~ ' + standard.format('yyyy.MM') + '.' + ('0' + lastDay.getDate()).slice(-2)).data('standard', standard);
		startTime = Number(standard.format('yyyyMM') + '01000000'), endTime = Number(lastDay.format('yyyyMMdd') + '235959');
	} else {
		lastDay = new Date(today.getFullYear(), today.getMonth() + 2, 0);
		$('.gmain-chart2 span.term span').text(today.format('yyyy.MM') + '.01 ~ ' + today.format('yyyy.MM') + '.' + ('0' + today.getDate()).slice(-2)).data('standard', new Date());
		startTime = Number(monthData.startTime), endTime = Number(monthData.endTime);
	}

	let categories = new Array();
	for (let i = 1; i <= lastDay.getDate(); i++) { categories.push(String(i)); }

	const targetApi = new Array();

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: startTime,
			endTime: endTime,
			interval: 'day',
			displayType: 'dashboard',
			formId: 'v2'
		})
	}));

	if (standard === undefined || (today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth())) {
		targetApi.push($.ajax({
			url: apiHost + '/get/energy/now/sites',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify({
				sids: siteSids.toString(),
				metering_type: '2',
				interval: 'day'
			}),
			timeout: 50000
		}));
	}

	new Promise(resolve => {
		resolve(Promise.all(targetApi));
	}).then(response => {
		const chargeList = new Array(lastDay.getDate()).fill(0);
		const dischargeList = new Array(lastDay.getDate()).fill(0);
		const pvList = new Array(lastDay.getDate()).fill(0);
		const payList = new Array(lastDay.getDate()).fill(0);
		const sumObj = { chargeSum: 0, dischargeSum: 0, pvSum: 0, pvPart: 0};

		let yesterDayGen = 0;
		let yesterDayMoney = 0;

		response.forEach((resData, index) => {
			if (index === 1) {
				if (!isEmpty(resData)) {
					const siteNowEnergyData = resData['data'];
					Object.entries(siteNowEnergyData).forEach(([siteKey, siteData]) => {
						if (!isEmpty(siteData)) {
							const index = Number(String(siteData['start']).slice(6, 8)) - 1;

							if (!isEmpty(siteData['energy'])) {
								pvList[index] += siteData['energy'];
								sumObj['pvSum'] += siteData['energy'];
							}

							if (!isEmpty(siteData['money'])) {
								payList[index] += siteData['money'];
							}
						}
					});
				}
			} else {
				if (!isEmpty(resData)) {
					const siteEnergyData = resData['data'];
					if (!isEmpty(siteEnergyData)) {
						Object.entries(siteEnergyData).forEach(([siteId, siteEnergyItem]) => {
							if (!isEmpty(siteEnergyItem)) {
								siteEnergyItem.forEach(siteEnergy => {
									const items = siteEnergy['items'];
									if (!isEmpty(items)) {
										items.forEach(item => {
											const index = Number(String(item['basetime']).slice(6, 8)) - 1;
											if (index === today.getDate() - 2) {
												yesterDayGen += item['energy'];
												yesterDayMoney += item['money'];
											}

											pvList[index] += item['energy'];
											payList[index] += item['money'];
											sumObj['pvSum'] += item['energy'];
											sumObj['pvPart'] += item['energy'];
										});
									}
								});
							}
						});
					}
				}
			}
		});

		return {chargeList, dischargeList, pvList, payList, sumObj, yesterDayGen, yesterDayMoney};
	}).then(({chargeList, dischargeList, pvList, payList, sumObj, yesterDayGen, yesterDayMoney}) => {
		let maxValue = 0;
		let seriesLength = dailyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			dailyChart.series[i].remove();
		}

		seriesArray.forEach((el, index) => {
			let totalValue = 0;
			let chartSeries = new Object();
			chartSeries.name = el.name;
			chartSeries.type = el.type;
			chartSeries.color = el.color;
			chartSeries.data = eval(el.data);

			if (!isEmpty(chartSeries.data)) {
				(chartSeries.data).forEach((e, index) => { (chartSeries.data)[index] = Math.floor(e / 1000); });
				const targetMaxValue = (chartSeries.data).reduce( function (previous, current) {
					return previous > current ? previous:current;
				});

				totalValue = (chartSeries.data).reduce( function add(sum, currValue) {
					return sum + currValue;
				});

				if (maxValue < targetMaxValue) { maxValue = targetMaxValue; }
			}

			if ((index === 0 || index === 1) && totalValue === 0) {
				chartSeries.showInLegend = false
			} else if (index === 3) {
				chartSeries.dashStyle = 'ShortDash';
				chartSeries.yAxis = 1;
			}

			chartSeries.tooltip = {valueSuffix: (/원/.test(el.suffix)) ? '만원' : el.suffix}
			dailyChart.addSeries(chartSeries, false);
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'kWh', 3, 2);
		const rtnUnit = refineMaxValue[1];

		dailyChart.yAxis[0].setTitle({
			text: rtnUnit,
			align: 'low',
			rotation: 0,
			y: 25,
			x: 40,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		});
		dailyChart.xAxis[0].setCategories(categories);
		dailyChart.redraw();

		$('#dailySum').data('yesterDayGen', yesterDayGen).data('yesterDayMoney', yesterDayMoney);
		new Promise(resolve => {
			let str = '';
			Object.entries(sumObj).forEach(([key, value]) => {
				if (key === 'chargeSum') {
					str += '<li class="charge">' + i18nManager.tr('dashboard_charge') + ' : ' + displayNumberFixedDecimal(Math.floor(value / 1000), 'kWh', 3, 2).join(' ') + '</li>';
				}
				if (key === 'dischargeSum') {
					str += '<li class="discharge">' + i18nManager.tr('dashboard_discharge') + ' : ' + displayNumberFixedDecimal(Math.floor(value / 1000), 'kWh', 3, 2).join(' ') + '</li>';
				}
				if (key === 'pvSum') {
					str += '<li class="pv" data-part="' + sumObj.pvPart + '">' + i18nManager.tr('dashboard_photovoltaic') + ' : ' + displayNumberFixedDecimal(Math.floor(value / 1000), 'kWh', 3, 2).join(' ') + '</li>';
				}
			});

			resolve(str);
		}).then(res => {
			$('#dailySum').append(res);
		});
	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	}).finally(() =>{
		$('#miniLoadingCircle_daily').hide();
	});
}

const typeSiteDraw = async (siteSids, standard) => {
	const targetApi = new Array();

	const yesterday = new Date();
	yesterday.setDate(Number(today.getDate()) - 1);
	let startTime = '', endTime = '';

	if (standard !== undefined && (today.getFullYear() != standard.getFullYear() || today.getMonth() != standard.getMonth() || today.getDate() != standard.getDate())) {
		$('.gmain-chart3 span.term span').text(standard.format('yyyy.MM.dd')).data('standard', standard);
		startTime = Number(standard.format('yyyyMMdd') + '000000'), endTime = Number(standard.format('yyyyMMdd') + '235959');
	} else {
		$(`.gmain-chart3 span.term span`).text(yesterday.format('yyyy.MM.dd')).data('standard', yesterday);
		startTime = Number(yesterData.startTime), endTime = Number(yesterData.endTime);
	}

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: Number(startTime),
			endTime: Number(endTime),
			interval: 'day',
			displayType: 'dashboard',
			formId: 'v2'
		})
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/forecasting/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: Number(startTime),
			endTime: Number(endTime),
			interval: 'day',
			formId: 'v2'
		}),
		timeout: 50000
	}));

	new Promise(resolve => {
		resolve(Promise.all(targetApi));
	}).then(response => {
		const siteGenArray = new Object;
		const siteForeGenArray = new Object;

		response.forEach((apiData, index) => {
			const siteEnergyData = apiData['data'];
			if (!isEmpty(siteEnergyData)) {
				Object.entries(siteEnergyData).forEach(([siteId, siteEnergyItem]) => {
					if (!isEmpty(siteEnergyItem)) {
						siteEnergyItem.forEach(siteEnergy => {
							const items = siteEnergy['items'];
							if (!isEmpty(items)) {
								items.forEach(item => {
									if (index === 0) {
										if (isEmpty(siteGenArray[siteId])) siteGenArray[siteId] = 0;
										siteGenArray[siteId] += item['energy'] / 1000;
									} else {
										if (isEmpty(siteForeGenArray[siteId])) siteForeGenArray[siteId] = 0;
										siteForeGenArray[siteId] += item['energy'] / 1000;
									}
								});
							}
						});
					}
				});
			}
		});

		return {
			siteGenArray: siteGenArray,
			siteForeGenArray: siteForeGenArray
		};
	}).then(({siteGenArray, siteForeGenArray}) => {
		let maxValue = 0;
		let emptyObj = {};

		if (isEmpty(siteGenArray)) { emptyObj.siteGenData = 0; }
		if (isEmpty(siteForeGenArray)) { emptyObj.siteForeGenData = 0; }

		let seriesLength = typeSiteCurrent.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			typeSiteCurrent.series[i].remove();
		}

		let categories = new Array();
		let yesterdayGenList = new Array();
		let yesterdayForeList = new Array();

		siteList.forEach(site => {
			const siteId = site.sid, siteName = site.name;

			if (!isEmpty(siteGenArray[siteId]) && siteGenArray[siteId] > 0) {
				const siteGen = isEmpty(siteGenArray[siteId]) ? 0 : siteGenArray[siteId];
				const siteForeGen = isEmpty(siteForeGenArray[siteId]) ? 0 : siteForeGenArray[siteId];

				categories.push(siteName);
				yesterdayGenList.push(siteGen);
				yesterdayForeList.push(siteForeGen);
			}
		});

		typeSeriesArray.forEach((el, index) => {
			let totalValue = 0;
			let chartSeries = new Object();
			chartSeries.name = el.name;
			chartSeries.color = el.color;
			chartSeries.data = eval(el.data);
			chartSeries.pointWidth = 9;
			chartSeries.pointPadding = 0.25;

			if (!isEmpty(chartSeries.data)) {
				//(chartSeries.data).forEach((e, index) => { (chartSeries.data)[index] = Math.floor(e / 1000); });
				const targetMaxValue = (chartSeries.data).reduce( function (previous, current) {
					return previous > current ? previous:current;
				});

				totalValue = (chartSeries.data).reduce( function add(sum, currValue) {
					return sum + currValue;
				});

				if (maxValue < targetMaxValue) { maxValue = targetMaxValue; }
			}

			if (totalValue === 0) {
				chartSeries.showInLegend = false
			}

			chartSeries.tooltip = {valueSuffix: (/원/.test(el.suffix)) ? '만원' : el.suffix}
			typeSiteCurrent.addSeries(chartSeries, false);
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'kWh', 3, 2);
		const rtnUnit = refineMaxValue[1];

		if(categories.length > 4){
			typeSiteCurrent.update({
				xAxis: {
					max: 5,
					categories: categories,
					scrollbar: {
						enabled: true,
						minWidth: 40,
						barBackgroundColor: 'var(--white40)',
						barBorderRadius: 5,
						barBorderWidth: 0,
						buttonBackgroundColor: 'none',
						buttonBorderWidth: 0,
						buttonBorderRadius: 7,
						trackBackgroundColor: 'none',
						trackBorderWidth: 3,
						trackBorderRadius: 0,
						trackBorderColor: 'none'
					},
				},
				yAxis: [{
					text: rtnUnit,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}],
				plotOptions: {
					pointPadding: 0.1,
				},
			});
		} else {
			typeSiteCurrent.update({
				xAxis: {
					categories: categories,
				},
				yAxis: [{
					text: rtnUnit,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}],
				plotOptions: {
					pointPadding: 0.1,
				},
			});
		}

		typeSiteCurrent.redraw();

		let str = '';
		let genSum = 0;
		let genForecastSum = 0;

		if(!isEmpty(yesterdayGenList)){
			genSum = yesterdayGenList.reduce((acc, val) => { return acc + val } , 0);
			str += '<li class="charge">'+ i18nManager.tr("dashboard_generation") + ' : ' + displayNumberFixedDecimal(genSum, 'kWh', 3, 2).join(' ') + '</li>';
		}
		if(!isEmpty(yesterdayForeList)){
			genForecastSum = yesterdayForeList.reduce((acc, val) => { return acc + val } , 0);
			str += '<li class="discharge">' + i18nManager.tr("dashboard_generation_forecast") + ' : ' + displayNumberFixedDecimal(genForecastSum, 'kWh', 3, 2).join(' ') + '</li>';
		}
		$('#yesterdaySum').append(str);
	}).catch(error => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	}).finally(() =>{
		$('#miniLoadingCircle_type').hide();
	});
}

/**
 * 현재출력 데이터 정제
 *
 * @returns {Promise<unknown>}
 */
const getTodayTotalDetail = async function (siteSids) {
	const targetApi = new Array();
	let targetArea = $('.gmain-chart4 .chart-info-right ul li');

	$('.gmain-chart4 .chart-info-right ul li:nth-child(1) span').text(0);
	$('.gmain-chart4 .chart-info-right ul li:nth-child(2) span').text(0);

	$('#centerTbody tr td:nth-child(1)').html(Math.floor(siteList.length) + '<em>&nbsp;&nbsp;'+i18nManager.tr('dashboard.EA')+'</em>');
	$('#centerTbody tr td:nth-child(2)').text('');
	$('#centerTbody tr td:nth-child(3)').text('');
	$('#centerTbody tr td:nth-child(4)').text('');
	$('#centerTbody tr td:nth-child(5)').text('');
	$('#centerTbody tr td:nth-child(6)').text('');

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/now/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
			metering_type: '2',
			interval: 'day'
		}),
		timeout: 50000
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/forecasting/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: Number(dayData.startTime),
			endTime: Number(dayData.endTime),
			metering_type: 2,
			interval: 'day',
			formId: 'v2'
		}),
		timeout: 50000
	}));

	const deviceRaw = new Array();
	siteList.forEach(site => {
		if (site.hasDevices) {
			deviceRaw.push(site.sid)
		}
	});

	targetApi.push($.ajax({
		url: apiHost + '/get/status/raw/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: deviceRaw.toString(),
			formId: 'v2',
			isLimited: true,
			displayType: 'dashboard',
			operation: 'overall'
		})
	}));

	new Promise(resolve => {
		resolve(Promise.all(targetApi));
	}).then(response => {
		let acPowerSum = 0, capacitySum = 0, invertorCount = 0, energySum = 0;
		response.forEach((apiData, index) => {
			if (!isEmpty(apiData) && !isEmpty(apiData['data'])) {
				const resultData = apiData['data'];
				if (index === 0) {
					let co2Sum = 0, moneySum = 0;
					Object.entries(resultData).forEach(([siteKey, siteNowEnergy]) => {
						if (!isEmpty(siteNowEnergy)) {
							co2Sum += Math.floor(isEmpty(siteNowEnergy['co2']) ? 0 : siteNowEnergy['co2']);
							energySum += Math.floor(isEmpty(siteNowEnergy['energy']) ? 0 : siteNowEnergy['energy']);
							moneySum += Math.floor(isEmpty(siteNowEnergy['money']) ? 0 : siteNowEnergy['money']);
						}
					});

					$('.gmain-chart4 .chart-info-right ul li:nth-child(1) span').text(numberComma(Math.floor(energySum / 1000)));
					$('#centerTbody tr td:nth-child(5)').html(numberComma(Math.floor(co2Sum / 1000)) + '<em>&nbsp;&nbsp;kg</em>');
					$('#centerTbody tr td:nth-child(6)').html(numberComma(Math.floor(moneySum / 1000)) + '<em>&nbsp;&nbsp;'+i18nManager.tr('dashboard_in_thousands_of_won')+'</em>');
				} else if (index === 1) {
					let generationForecastSum = 0;
					Object.entries(resultData).forEach(([siteId, siteForeEnergyItem]) => {
						if (!isEmpty(siteForeEnergyItem)) {
							siteForeEnergyItem.forEach(siteForeEnergy => {
								siteForeEnergy['items'].map(e => generationForecastSum += e['energy']);

								$('.gmain-chart4 .chart-info-right ul li:nth-child(2) span').text(numberComma(Math.floor(generationForecastSum / 1000)));
							});
						}
					});
				}
			} else if (!isEmpty(apiData) && index >= 2) {
				Object.entries(apiData).forEach(([site_id, siteDevice]) => {
					Object.entries(siteDevice).forEach(([deviceType, deviceData]) => {
						if (deviceType.match('INV') && !isEmpty(deviceData)) {
							acPowerSum += (isEmpty(deviceData['activePower'])) ? 0 : deviceData['activePower'];
							capacitySum += (isEmpty(deviceData['capacity'])) ? 0 : deviceData['capacity'];
							invertorCount += (isEmpty(deviceData['devices'])) ? 0 : deviceData['devices'].length;

							if ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < deviceData['timestamp'])) {
								const dbTime = new Date(deviceData['timestamp']);
								$('.dbTime').data('timestamp', deviceData['timestamp']).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
							}
						}
					});
				});
			}
		});

		return {acPowerSum, capacitySum, invertorCount, energySum};
	}).then(({acPowerSum, capacitySum, invertorCount, energySum}) => {
		const usage = Math.floor((acPowerSum / capacitySum) * 100)
			, other = 100 - usage
			, generationHour = (Math.round((energySum / capacitySum) * 100) / 100).toFixed(2);

		$('#centerTbody tr td:nth-child(4)').html(generationHour + '<em>&nbsp;&nbsp;Hrs</em>');
		pieChart.setTitle({text: Math.floor(acPowerSum / 1000).toLocaleString() + 'kW'});
		pieChart.series[0].data.forEach((e, idx) => {
			if (e.name === i18nManager.tr("dashboard_photovoltaic")) {
				e.update({y: usage});
			} else if (e.name === i18nManager.tr("dashboard_unused_amount")) {
				e.update({y: other});
			} else {
				e.update({y: 0});
			}
		});
		pieChart.redraw();

		$('#centerTbody tr td:nth-child(2)').html(numberComma(invertorCount) + '<em>&nbsp;&nbsp;'+i18nManager.tr('dashboard_units')+'</em>');
		$('#centerTbody tr td:nth-child(3)').html(numberComma(Math.round(capacitySum / 1000)) + '<em>&nbsp;&nbsp;kW</em>');
	}).catch((error) => {
		console.error(error);
		return false;
	});
}

/**
 * 알람 이력 리스트 생성
 *
 * @returns {Promise<void>}
 */
const alarmInfoList = async (siteSids) => {
	const alarmColorTemp = ['info', 'warning', 'critical', 'shutoff', 'urgent'];
	$.ajax({
		url: apiHost + '/get/alarms',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
			startTime: Number(dayData.startTime),
			endTime: Number(dayData.endTime),
			confirm: false
		})
	}).done((data, textStatus, jqXHR) => {
		if (!isEmpty(data)) {
			//localtime 오름차순 정렬
			data.sort((a, b) => {
				return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
			});

			let alarmList = new Array();
			let alarmColor = "";
			let alarmEl = $('.indiv[data-alarm]');

			data.forEach(alarm => {
				if (alarm.level !== 0) {
					let localTime = (alarm.localtime != null && alarm.localtime != '') ? String(alarm.localtime) : '';
					alarm.standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
					alarmList.push(alarm);
				}
			});

			if (alarmList.length > 0) {
				const alarmColorList = alarmList.slice();
				alarmColorList.sort((a, b) => {
					return a.level < b.level ? -1 : a.level > b.level ? 1 : 0;
				});

				const targetLevel = alarmColorList[0].level;
				if (targetLevel > 4) {
					alarmColor = '';
				} else {
					alarmColor = alarmColorTemp[targetLevel];
				}
			} else {
				alarmColor = '';
			}

			alarmEl.attr('data-alarm', alarmColor);
			alarmEl.find('em').text(alarmList.length);
			setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}}); //list생성
		} else {
			let alarmEl = $('.indiv[data-alarm]');
			alarmEl.attr('data-alarm', '');
			$('#alarmNotice').empty();
		}
	}).fail((jqXHR, textStatus, errorThrown) => {
		console.error(textStatus);
	});
}

/**
 * 알람 이력 레벨 클래스
 * 리스트 작성시 level별 클래스 지정
 *
 * @param level
 * @returns {string}
 */
const levelClass = (level) => {
	let rtnClass = '';
	switch (level) {
		case 1 :
			rtnClass = 'warning';
			break;
		case 2 :
			rtnClass = 'critical';
			break;
		case 3 :
			rtnClass = 'shutoff';
			break;
		case 4 :
			rtnClass = 'urgent';
			break;
		case 0 :
			rtnClass = 'info';
			break;
		default :
			rtnClass = '';
	}

	return rtnClass;
}

/**
 * 사이트명 && 작동상태로 검색 기능 작동
 */
const searchSite = async function (siteSids) {
	const targetApi = new Array();
	const searchName = document.getElementById('searchName').value.trim();
	const deviceStatus = new Array();
	document.querySelectorAll('[name="deviceStatus"]:checked').forEach(chk => {
		deviceStatus.push(chk.value);
	});

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: Number(yesterData.startTime),
			endTime: Number(yesterData.endTime),
			interval: 'day',
			displayType: 'dashboard',
			formId: 'v2'
		})
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/now/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
			metering_type: '2',
			interval: 'day'
		}),
		timeout: 50000
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/energy/forecasting/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: Number(dayData.startTime),
			endTime: Number(dayData.endTime),
			metering_type: 2,
			interval: 'day',
			formId: 'v2'
		}),
		timeout: 50000
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/weather/site',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sid: siteSids.toString(),
			startTime: Number(dayData.startTime),
			endTime: Number(dayData.endTime),
			interval: 'hour',
			formId: 'v2'
		})
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/alarms',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
			startTime: Number(dayData.startTime),
			endTime: Number(dayData.endTime),
			confirm: false
		})
	}));

	targetApi.push($.ajax({
		url: apiHost + '/get/status/health',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: siteSids.toString(),
		})
	}));

	const deviceRaw = new Array();
	siteList.forEach(site => {
		if (site.hasDevices) {
			deviceRaw.push(site.sid)
		}
	});

	targetApi.push($.ajax({
		url: apiHost + '/get/status/raw/sites',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({
			sids: deviceRaw.toString(),
			formId: 'v2',
			isLimited: true,
			displayType: 'dashboard',
			operation: 'overall'
		})
	}));

	new Promise(resolve => {
		resolve(Promise.all(targetApi));
	}).then(response => {
		const refineList = siteList.slice();
		siteList.forEach((site, siteIdx) => {
			const siteId = site.sid;
			response.forEach((apiData, index) => {
				const resultData = apiData['data'];
				if (index === 0) {
					let siteYesterGenSum = 0;
					if (!isEmpty(apiData) && !isEmpty(resultData[siteId])) {
						const siteEnergy = resultData[siteId];
						siteEnergy.forEach(siteForeEnergyItem => {
							if (!isEmpty(siteForeEnergyItem['items'])) {
								siteForeEnergyItem['items'].map(e => siteYesterGenSum += e['energy']);
								refineList[siteIdx]['beforeDay'] = displayNumberFixedUnit(siteYesterGenSum, 'Wh', 'kWh', 0)[0];
							} else {
								refineList[siteIdx]['beforeDay'] = '-';
							}
						});
					} else {
						refineList[siteIdx]['beforeDay'] = '-';
					}
				} else if (index === 1) { //금일 누적
					if (!isEmpty(apiData) && !isEmpty(resultData[siteId])) {
						const siteNowEnergy = resultData[siteId];
						if(!isEmpty(siteNowEnergy) && !isEmpty(siteNowEnergy['energy'])) {
							refineList[siteIdx]['accumulate'] = displayNumberFixedUnit(siteNowEnergy['energy'], 'Wh', 'kWh', 0)[0];
						} else {
							refineList[siteIdx]['accumulate'] = '-';
						}
					} else {
						refineList[siteIdx]['accumulate'] = '-';
					}
				} else if (index === 2) { //금일 예측
					let siteForeGenSum = 0;
					if (!isEmpty(apiData) && !isEmpty(resultData[siteId])) {
						const siteEnergy = resultData[siteId];
						siteEnergy.forEach(siteForeEnergyItem => {
							if (!isEmpty(siteForeEnergyItem['items'])) {
								siteForeEnergyItem['items'].map(e => siteForeGenSum += e['energy']);
								refineList[siteIdx]['forecast'] = displayNumberFixedUnit(siteForeGenSum, 'Wh', 'kWh', 0)[0];
							} else {
								refineList[siteIdx]['forecast'] = '-';
							}
						});
					} else {
						refineList[siteIdx]['forecast'] = '-';
					}
				} else if (index === 3) {
					let temperature = '-', humidity = '-';
					if (!isEmpty(apiData) && !isEmpty(apiData)) {
						//시간 역순으로 정렬한 다음에 Observed 값을 만나면 그값이 쓰는값
						const weatherData = apiData['data'];
						if (!isEmpty(weatherData) && !isEmpty(weatherData[siteId]) && !isEmpty(weatherData[siteId]['items'])) {
							const siteWeatherData = weatherData[siteId]['items'];
							siteWeatherData.sort((a, b) => {
								if (a.basetime > b.basetime) {return -1;}
								if (a.basetime < b.basetime) {return 1;}
								return 0;
							});

							const observedData = siteWeatherData.find(weather => weather.observed === true);
							if (!isEmpty(observedData)) {
								temperature = isEmpty(observedData['temperature']) ? '-' : observedData['temperature'];
								humidity = isEmpty(observedData['humidity']) ? '-' : observedData['humidity'];
							}
						}
					}

					refineList[siteIdx]['temperature'] = temperature + ' °C';
					refineList[siteIdx]['humidity'] = humidity + ' %'
				} else if (index === 4) {
					let alarmWarning = 0, alarmError = 0;
					if (!isEmpty(apiData)) {
						apiData.forEach(alarm => {
							if (siteId === alarm.sid) {
								if (alarm.level == 0 || alarm.level == 1 || alarm.level == 9) {
									alarmWarning++;
								} else {
									alarmError++;
								}
							}
						});
					}

					refineList[siteIdx]['alarmWarning'] = alarmWarning;
					refineList[siteIdx]['alarmError'] = alarmError;
					refineList[siteIdx]['alarmTotal'] = alarmError + alarmWarning;
				} else if (index === 5) {
					if (!isEmpty(apiData) && !isEmpty(apiData.sites)) {
						(apiData.sites).forEach(data => {
							if (siteId === data.sid) {
								if (!isEmpty(data.rtus) && data.rtus.length > 0) {
									const operation = data.rtus.find(e => e.operation === 1);
									if (!isEmpty(operation)) {
										site['rtustatus'] = '정상';
										site['rtustatusClass'] = 'normal';
									} else {
										site['rtustatus'] = '이상';
										site['rtustatusClass'] = 'error';
									}
								} else {
									site['rtustatus'] = '이상';
									site['rtustatusClass'] = 'error';
								}
							}
						});
					} else {
						site['rtustatus'] = '이상';
						site['rtustatusClass'] = 'error';
					}
				} else {
					let operation = new Array();
					let activePower = '';
					let capacity = '';
					let inverterCount = '';
					let irradiationPoa = '';

					let targetDevice = false;
					if (!isEmpty(apiData)) {
						Object.entries(apiData).forEach(([site_id, siteDevice]) => {
							if (!isEmpty(siteDevice) && site_id === siteId) {
								Object.entries(siteDevice).forEach(([deviceType, deviceData]) => {

									targetDevice = true;
									if (!operation.includes(deviceData['operation']) && deviceData['operation'] != undefined) {
										operation.push(deviceData['operation']);
									}

									//대상은 INV 인버터 타입 대상
									if (deviceType.match('INV')) {
										activePower = (activePower != '-') ? activePower + deviceData['activePower'] : deviceData['activePower'];
										capacity = (capacity != '-') ? capacity + deviceData['capacity'] : deviceData['capacity'];
										inverterCount = (!isEmpty(deviceData['devices'])) ? deviceData['devices'].length : '-';
									} else if (deviceType === 'SENSOR_SOLAR') {
										if (!isEmpty(deviceData) && !isEmpty(deviceData['irradiationPoa'])) {
											irradiationPoa = (deviceData['irradiationPoa']).toFixed(1);
										}
									}
								});
							}
						});
					}

					if (targetDevice) {
						if (isNaN(capacity)) { capacity = '-'; }
						if (isNaN(activePower)) { activePower = '-'; }

						site['inverterCount'] = inverterCount //사이트에 속한 인버터 갯수.
						site['operation'] = operation; //사이트 상태 정보.
						site['capacity'] = capacity;   //사이트에 속한 인버터 설비 용량 정보.
						site['capacityView'] = (isEmpty(capacity) || capacity === '-') ? '-' : displayNumberFixedUnit(capacity, 'W', 'kW', 0)[0];   //사이트에 속한 인버터 설비 용량 정보.
						site['activePower'] = activePower;   //사이트에 속한 인버터.
						site['activePowerView'] =(isEmpty(activePower) || activePower === '-') ? '-' : displayNumberFixedUnit(activePower, 'W', 'kW', 0)[0];   //사이트에 속한 인버터.
						site['irradiationPoa'] = irradiationPoa;   //사이트에 속한 인버터 설비 용량 정보.
					}
				}

			});
		});

		refineList.forEach((site, siteIdx) => {
			const operation = site.operation;
			let targetOperation = false;
			let searchSite = false;

			if (!isEmpty(operation)) {
				const searchOperation = operation.some(target => {
					return deviceStatus.includes(String(target));
				});

				if (searchOperation) {
					targetOperation = true;
				}
			} else {
				if (deviceStatus.length == 3) { //전체 선택이면 operation 없는 디바이스도 표시
					targetOperation = true;
				} else {
					targetOperation = false;
				}
			}

			if (!isEmpty(searchName)) {
				const searchPattern = new RegExp(searchName, 'i'); //ignoreCase 대소문자 구분X
				if (searchPattern.test(site.name) || searchPattern.test(site.address)) {
					searchSite = true;
				}
			} else {
				searchSite = true;
			}

			if (operation !== undefined) {
				if (operation.includes(0)) {
					site['status'] = '중지';
					site['statusClass'] = 'status-stop';
				} else if (operation.includes(1)) {
					site['status'] = '정상';
					site['statusClass'] = 'status-drv';
				} else if (operation.includes(2)) {
					site['status'] = '트립';
					site['statusClass'] = 'status-error';
				} else {
					site['status'] = '이상';
					site['statusClass'] = 'status-error';
				}
			} else {
				site['status'] = '이상';
				site['statusClass'] = 'status-error';
			}

			if (site['accumulate'] === undefined) site['accumulate'] = '-';
			if (site['forecast'] === undefined) site['forecast'] = '-';
			if (site['inverterCount'] === undefined) site['inverterCount'] = '-';
			if (site['operation'] === undefined) site['operation'] = '-';
			if (site['capacityView'] === undefined) site['capacityView'] = '-';
			if (site['activePower'] === undefined) site['activePower'] = '-';
			if (site['activePowerView'] === undefined) site['activePowerView'] = '-';
			if (site['irradiationPoa'] === undefined) site['irradiationPoa'] = '-';
			if (site['alarmError'] === undefined) site['alarmError'] = '-';
			if (site['alarmWarning'] === undefined) site['alarmWarning'] = '-';
			if (site['alarmTotal'] === undefined) site['alarmTotal'] = '-';

			site['resourceClass'] = resourceIcon(site['resource_type']);
			if (targetOperation && searchSite) {
				site['displayClass'] = '';
			} else {
				site['displayClass'] = 'hidden';
			}
		});

		if (refineList.length > 0) {
			refineList.sort(
				firstBy(function(a, b) {return Number(String(b['accumulate']).replace(/[^0-9]/g, '')) - Number(String(a['accumulate']).replace(/[^0-9]/g, ''));})
					.thenBy(function(a, b) {return Number(String(b['capacity']).replace(/[^0-9]/g, '')) - Number(String(a['capacity']).replace(/[^0-9]/g, ''));})
			);

			setMakeList(refineList, 'siteList', {'dataFunction': {'align': alignFunc}}); //list생성

			if (typeof (geocodeAddress) == 'function' && isEmpty(makerObject)) {
				map = new google.maps.Map(document.getElementById('gMainMap'), {
					mapTypeId: 'satellite',
					zoom: 7.3,
					mapTypeControl: false, //맵타입
					streetViewControl: false, //스트리트뷰
					fullscreenControl: false, //전체보기
					center: {lat: 36.549012, lng: 127.788546} // center: new google.maps.LatLng(37.549012, 126.988546),
				});

				if (refineList.length > 0) {
					makerObject = new Object();

					// 0: '중지' <  1: '정상'  <<  2: '트립'  <<<  "undefined": '이상' (나오면 안되기 때문에 발견시 rtu에서 데이터 수정 필요!!!)
					refineList.forEach((site, idx) => {
						if (site.latlng != null) {
							let operationText = "";
							let operationColor = "";

							if(site.operation != "null"){
								if(site.operation == '0') {
									operationText = "[ 중지 ]&ensp;";
									operationColor = '#f2a363';
								} else if(site.operation == '1') {
									operationText = "[ 정상 ]&ensp;";
									operationColor = '#90caf3';
								} else if(site.operation == '2') {
									operationText = "[ 트립 ]&ensp;";
									operationColor = '#e97373';
								} else {
									operationText = "[ 이상 ]&ensp;";
									operationColor = '#ffd954';
								}
							} else {
								operationText = "[ 발전량 없음 ]&ensp;";
								operationColor = '#878787';
							}

							if(site.latlng.includes(",")) {
								geocodeAddress(site.address, site.sid, site.name, site.latlng, operationColor, operationText);
							}
						} else {
							makerObject[site.sid] = new Object();
						}
					});

					let clusterStyles = [
						{
							textColor: 'black',
							textSize: 16,
							anchorText: [11, 20], // [yPos, xPos]
							fontWeight: 'normal',
							url: '/img/map_icons/cluster_blue.png',
							height: 40,
							width: 40
						},
					];

					let clusterOptions = {
						gridSize: 40,
						styles: clusterStyles,
						maxZoom: 15
					};

					let markerCluster = new MarkerClusterer(map, markers, clusterOptions);
					markerCluster.addMarkers(markers);

					google.maps.event.addListener(markerCluster, "mouseover", function (c) {});
					google.maps.event.addListener(markerCluster, "mouseout", function (c) {});
				}
			}

			setTimeout(function () {
				refineList.forEach((site, siteIdx) => {
					let capacity = (site.capacity === undefined || (site.capacity == '-' && isNaN(site.capacity))) ? 0 :site.capacity;
					let activePower = (site.activePower === undefined || (site.activePower == '-' && isNaN(site.activePower))) ? 0 : site.activePower;

					let activePercent = 0, title = '', etc = 0;
					if ((!isNaN(capacity) && capacity > 0) && (!isNaN(activePower) && activePower > 0)) {
						activePercent = Math.floor((Number(activePower) / Number(capacity)) * 100);
						title = activePercent + '%';
						etc = 100 - activePercent;
					} else {
						activePercent = 0;
						title = '0%';
						etc = 100;
					}
					let series = [{
						type: 'pie',
						innerSize: '70%',
						name: '설비용량',
						colorByPoint: true,
						data: [{
							color: 'var(--turquoise)',
							name: '현재 효율',
							dataLabels: {
								enabled: false
							},
							y: Number(activePercent)
						}, {
							color: 'var(--dove-gray)',
							name: '현재 비효율',
							dataLabels: {
								enabled: false
							},
							y: Number(etc) //30% 나머지
						}]
					}];

					siteListChart('type_chart' + siteIdx, series, title);
				});
			}, 400);
		} else {
			setMakeList(refineList, 'siteList', {'dataFunction': {'align': alignFunc}}); //list생성
			document.getElementById('miniLoadingCircle').style.display = 'none';
		}
	}).catch(error => {
		console.error(error);
		document.getElementById('loadingCircleDashboard').style.display =  'none';
		$('#errMsg').text(error);
		$('#errorModal').modal('show');
		setTimeout(function(){
			$('#errorModal').modal('hide');
		}, 2000);
		return false;
	});
}

/**
 * 사이트 검색
 *
 * @param operation
 */
const searchOperationSite = () => {
	const searchName = document.getElementById('searchName').value.trim();
	const deviceStatus = new Array();
	document.querySelectorAll('[name="deviceStatus"]:checked').forEach(chk => {
		deviceStatus.push(chk.value);
	});

	$('#siteList tr.dbclickopen').each(function() {
		// const operation = $(this).data('operation')
		const siteAddress = $(this).data('address')
			, siteName = $(this).find('td:eq(4)').text()
			, rtuStatus = $(this).find('td:eq(3)').text();
		let operation = 1;

		// operation: rtuStatus로 만든 text로 설정
		if(rtuStatus == '중지') {
			operation = 0;
		} else if(rtuStatus == '이상') {
			operation = 2;
		}

		if (deviceStatus.length === 3) {
			const searchPattern = new RegExp(searchName, 'i'); //ignoreCase 대소문자 구분X
			if (searchPattern.test(siteName) || searchPattern.test(siteAddress)) {
				$(this).removeClass('hidden');
			} else {
				$(this).addClass('hidden');
				$(this).next('.detail-info').find('.di-wrap').hide();
			}
		} else {
			if (deviceStatus.includes(String(operation))) {
				if (isEmpty(searchName)) {
					$(this).removeClass('hidden');
				} else {
					const searchPattern = new RegExp(searchName, 'i'); //ignoreCase 대소문자 구분X
					if (searchPattern.test(siteName) || searchPattern.test(siteAddress)) {
						$(this).removeClass('hidden');
					} else {
						$(this).addClass('hidden');
						$(this).next('.detail-info').find('.di-wrap').hide();
					}
				}
			} else {
				$(this).addClass('hidden');
				$(this).next('.detail-info').find('.di-wrap').hide();
			}
		}
	});
}

/**
 * 테이블 정렬 처리
 *
 * @param table
 * @param n
 * @param sort
 * @constructor
 */
function SortTable(table, n, sort) {
	// table 에 tbody tag 가 반드시 존재한다고 가정한다.
	let tbody = table.tBodies[0];
	let rows = tbody.querySelectorAll('tr.dbclickopen');
	let rows2 = tbody.querySelectorAll('tr.detail-info');
	rows = Array.prototype.slice.call(rows, 0);
	rows.sort(function (row1, row2) {
		var cell1 = row1.getElementsByTagName("td")[n];
		var cell2 = row2.getElementsByTagName("td")[n];
		var value1 = cell1.textContent || cell1.innerText;
		var value2 = cell2.textContent || cell2.innerText;

		value1 = value1 == '-' ? '0' : String(value1).replace(/^\s+|\s+$/g, "");;
		value2 = value2 == '-' ? '0' : String(value2).replace(/^\s+|\s+$/g, "");;

		if (isNumberic(value1)) {
			value1 = Number(value1.replace(/[^0-9]/g, ''));
		}

		if (isNumberic(value2)) {
			value2 = Number(value2.replace(/[^0-9]/g, ''));
		}

		if (sort == 'up') {
			if (value1 < value2) return -1;
			if (value1 > value2) return 1;
		} else {
			if (value1 < value2) return 1;
			if (value1 > value2) return -1;
		}

		return 0;
	});

	// 정렬된 배열로 row 를 다시 저장한다. 문서에 이미 존재하는 node 는 삽입하면 해당 node 는 자동으로 제거되고 새 위치에 저장된다.
	for (let i = 0; i < rows.length; ++i) {
		let flag = rows[i].classList[1];
		tbody.appendChild(rows[i]);

		for (let j = 0; j < rows2.length; j++) {
			if (rows2[j].classList.contains(flag)) {
				tbody.appendChild(rows2[j]);
			}
		}
	}
}

/**
 * 사이트 리소스 아이콘 세팅
 *
 * @param resourceType
 * @returns {string}
 */
const resourceIcon = (resourceType) => {
	let rtnClass = 'solar';
	switch(resourceType) {
		case 1: rtnClass = 'solar'; break;
		case 2: rtnClass = 'wind'; break;
		case 3: rtnClass = 'water'; break;
		default: rtnClass = 'solar';
	}

	return rtnClass;
}

/**
 * 날씨 아이콘
 *
 * @param weatherId
 * @returns {string}
 */
const getWeatherIconClass = (weatherId) => {
	let weatherIconClass = 'w1';
	switch (weatherId) {
		case 1 :
			weatherIconClass = 'w1';
			break;
		case 7 :
			weatherIconClass = 'w4';
			break;
		case 11 :
			weatherIconClass = 'w8';
			break;
		case 12 :
			weatherIconClass = 'w10';
			break;
		case 13 :
			weatherIconClass = 'w6';
			break;
		case 17 :
			weatherIconClass = 'w9';
			break;
		case 20 :
			weatherIconClass = 'w3';
			break;
		default :
			weatherIconClass = 'w1';
			break;
	}
	return weatherIconClass
}

function setMarker (){
	return '/img/map_icons/cluster_yellow.png'
}