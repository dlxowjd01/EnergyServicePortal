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

// 특수문자 정규식 변수(공백 미포함)
const replaceChar = /[~!@\#$%^&*\()\-=+_'\;<>\/.\`:\"\\,\[\]?|{}]/gi;
// 완성형 아닌 한글 정규식
const replaceNotFullKorean = /[ㄱ-ㅎㅏ-ㅣ]/gi;

/**
 * 그룹 & 중개거래 대시보드
 * 공통 이벤트 처리
 */
$(document).ready(function () {
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
});

/**
 * 페이지 초기 진입시
 * 필요한 데이터를 모두 조회한다.
 */
const firstAjax = () => {
	setInitList('alarmNotice'); //알람 공지 세팅

	yearData = getSiteMainSchCollection('year');
	monthData = getSiteMainSchCollection('month');
	yesterData = getSiteMainSchCollection('yesterday');
	dayData = getSiteMainSchCollection('day');
	hourData = getSiteMainSchCollection('hour');

	let siteSids = new Array();
	let urls = new Array();
	let ess = false;

	siteList.forEach(site => {
		siteSids.push(site.sid);

		if (site.devices != null) {
			const devices = site.devices;
			devices.forEach(device => {
				if ((device.device_type.toUpperCase()).match('ESS')) {
					ess = true;
				}
			});
		}
	});

	if (isEmpty(sgid)) siteSids = 'all';

	//중개거래 대시보드에서만 사용하는 항목
	if (location.pathname.match('jmain')) {
		urls.push({
			url: apiHost + '/energy/sites?interval=hour',
			type: 'GET',
			data: {
				sid: siteSids.toString(),
				startTime: dayData.startTime,
				endTime: dayData.endTime,
				displayType: 'dashboard',
				formId: 'v2'
			}
		});

		urls.push({
			url: apiHost + '/energy/forecasting/sites?interval=hour&startTime=' + dayData.startTime + '&endTime=' + dayData.endTime,
			type: 'GET',
			data: {
				sid: siteSids.toString(),
				displayType: 'dashboard',
				formId: 'v2'
			}
		});

		urls.push({
			url: apiHost + '/energy/forecasting/sites?interval=hour&startTime=' + hourData.startTime + '&endTime=' + hourData.endTime,
			type: 'GET',
			data: {
				sid: siteSids.toString(),
				displayType: 'dashboard',
				formId: 'v2'
			}
		});

		//현재 발전량
		urls.push({
			url: apiHost + '/energy/now/sites?interval=hour',
			type: 'GET',
			data: {
				sids: siteSids.toString(),
				metering_type: 2
			}
		});
	}

	//1년 에너지 데이터
	urls.push({
		url: apiHost + '/energy/sites?interval=month',
		type: 'GET',
		data: {
			sid: siteSids.toString(),
			startTime: yearData.startTime,
			endTime: yearData.endTime,
			displayType: 'dashboard',
			formId: 'v2'
		}
	});

	//1달 에너지 데이터
	urls.push({
		url: apiHost + '/energy/sites?interval=day&startTime=' + monthData.startTime + '&endTime=' +monthData.endTime,
		type: 'GET',
		data: {
			sid: siteSids.toString(),
			displayType: 'dashboard',
			formId: 'v2'
		}
	});

	//어제 에너지 데이터
	urls.push({
		url: apiHost + '/energy/sites?interval=day&startTime=' + yesterData.startTime + '&endTime=' +yesterData.endTime,
		type: 'GET',
		data: {
			sid: siteSids.toString(),
			displayType: 'dashboard',
			formId: 'v2'
		}
	});

	urls.push({
		url: apiHost + '/energy/forecasting/sites?interval=day&startTime=' + dayData.startTime + '&endTime=' +dayData.endTime,
		type: 'GET',
		data: {
			sid: siteSids.toString(),
			formId: 'v2'
		}
	});

	urls.push({
		url: apiHost + '/energy/forecasting/sites?interval=day&startTime=' + yesterData.startTime + '&endTime=' +yesterData.endTime,
		type: 'GET',
		data: {
			sid: siteSids.toString(),
			formId: 'v2'
		}
	});

	urls.push({
		url: apiHost + '/weather/site',
		type: 'get',
		data: {
			sid: siteSids.toString(),
			startTime: dayData.startTime,
			endTime: dayData.endTime,
			interval: 'hour',
			formId: 'v2'
		}
	});

	if (!ess) {
		$('#statusSiteList').find('.ESS').remove();
	}
	setInitList('siteList'); //사이트 리스트

	apiDatas = new Object();
	searchAlarm();
	searchStatusRaw();
	ajaxData(urls);
}

/**
 * 1분마다 갱신할 API 데이터
 */
const minAjax = async () => {
	yearData = getSiteMainSchCollection('year');
	monthData = getSiteMainSchCollection('month');
	yesterData = getSiteMainSchCollection('yesterday');
	dayData = getSiteMainSchCollection('day');
	hourData = getSiteMainSchCollection('hour');

	let siteSids = new Array();
	let urls = new Array();

	siteList.forEach(site => {
		siteSids.push(site.sid);
	});

	if (isEmpty(sgid)) siteSids = 'all';

	//중개거래 대시보드에서만 사용하는 항목ㅁㅓ
	if (location.pathname.match('jmain')) {
		//현재 발전량
		urls.push({
			url: apiHost + '/energy/now/sites?interval=hour',
			type: 'GET',
			data: {
				sids: siteSids.toString(),
				metering_type: 2
			}
		});
	}

	urls.push({
		url: apiHost + '/energy/now/sites?interval=day',
		type: 'GET',
		data: {
			sids: siteSids.toString(),
			metering_type: 2
		}
	});

	delete apiDatas[apiHost + '/energy/now/sites?interval=day'];

	if (location.pathname.match('jmain')) {
		delete apiDatas[apiHost + '/energy/now/sites?interval=hour'];
	}

	searchAlarm();
	searchStatusRaw();
	ajaxData(urls, 'min');
}

/**
 * ajaxReturn Data 처리
 *
 * @param urls
 * @param target min:1분단위, hour:1시간단위
 */
const ajaxData = (urls, target) => {
	if (target !== 'min') {
		document.getElementById('loadingCircleDashboard').style.display =  '';
	}
	let deferreds = new Array();

	//ajax 한번에 실행
	urls.forEach(function (url) {
		let deferred = $.Deferred();
		deferreds.push(deferred);

		$.ajax(url).done(function (data) {
			data['url'] = url['url'];
			(function (deferred) {
				return deferred.resolve(data);
			})(deferred);
		}).fail(function (error) {
			console.error(error);
			document.getElementById('loadingCircleDashboard').style.display =  'none';

			$('#errMsg').text("처리 중 오류가 발생했습니다.");
			$('#errorModal').modal('show');
			setTimeout(function(){
				$('#errorModal').modal('hide');
			}, 2000);
			return false;
		});
	});

	$.when.apply($, deferreds).then(function () {
		Object.entries(arguments).forEach(arg => {
			const result = arg[1];
			if (!isEmpty(result)) {
				let targetUrl = result.url; //API_URL
				let siteId = '';

				if (isEmpty(apiDatas[targetUrl])) {
					apiDatas[targetUrl] = result;
				} else {
					let rtnData = apiDatas[targetUrl].data;
					if (Array.isArray(rtnData) && Array.isArray(rtnData)) {
						(result.data).forEach(rtn => {
							rtnData.push(rtn);
						});
						apiDatas[targetUrl].data = rtnData;
					} else {
						let nArray = new Array();
						nArray.push(result);
						apiDatas[targetUrl] = nArray;
					}
				}
			} else {
				document.getElementById('loadingCircleDashboard').style.display =  'none';
			}
		});

		if (target === 'min') {
			getTodayTotalDetail();
			//alarmInfoList();
			searchSite();

			if (location.pathname.match('jmain')) {
				setRealtimeRecord();
			}
		} else {
			monthlyChartDraw();
			dailyChartDraw();
			typeSiteDraw();
			getTodayTotalDetail();
			//alarmInfoList();
			searchSite();

			if (location.pathname.match('jmain')) {
				setRealtimeRecord();
			}

			minAjax();
			searchNowMonth();
		}

		document.getElementById('loadingCircleDashboard').style.display =  'none';
		dashboardViewFlag = false;
	});
}

/**
 * 월간 차트
 * 조회기간 1년
 *
 * @returns {Promise<void | boolean>}
 */
const monthlyChartDraw = async () => {
	const targetApi = [apiHost + '/energy/sites?interval=month', apiHost + '/energy/now/sites?interval=month'];
	const chargeList = new Array(12).fill(0);
	const dischargeList = new Array(12).fill(0);
	const pvList = new Array(12).fill(0);
	const payList = new Array(12).fill(0);
	const sumObj = {
		chargeSum: 0,
		dischargeSum: 0,
		pvSum: 0,
	};

	$(`.gmain-chart1 span.term`).text(today.getFullYear() + '.1.1 ~ ' + today.getFullYear() + '.' + (Number(today.getMonth()) + 1) + '.' + today.getDate());
	new Promise(resolve => {
		targetApi.forEach((targetUrl, index) => {
			const apiData = apiDatas[targetUrl];
			if (index === 0) {
				if (!isEmpty(apiData)) {
					const siteEnergyData = apiData['data'];
					if (!isEmpty(siteEnergyData)) {
						Object.entries(siteEnergyData).forEach(([siteId, siteEnergyItem]) => {
							if (!isEmpty(siteEnergyItem)) {
								siteEnergyItem.forEach(siteEnergy => {
									const items = siteEnergy['items'];
									if (!isEmpty(items)) {
										items.forEach(item => {
											const index = Number(String(item['basetime']).slice(4, 6)) - 1;
											chargeList[index] += Math.floor(item['cenergy'] / 1000);
											sumObj['chargeSum'] += Math.floor(item['cenergy'] / 1000);

											dischargeList[index] += Math.floor(item['denergy'] / 1000);
											sumObj['dischargeSum'] += Math.floor(item['denergy'] / 1000);

											pvList[index] += Math.floor(item['energy'] / 1000);
											payList[index] += Math.floor(item['money'] / 1000);
											sumObj['pvSum'] += Math.floor(item['energy'] / 1000);
										});
									}
								});
							}
						});
					}
				}
			} else {
				if (!isEmpty(apiData)) {
					const siteNowEnergyData = apiData['data'];
					Object.entries(siteNowEnergyData).forEach(([siteKey, siteData]) => {
						if (siteData['start'].toString().slice(0, 6) === String(today.getFullYear()) + ('0' + (today.getMonth() + 1)).slice(-2)) {
							const index = Number(siteData['start'].toString().slice(4, 6)) - 1;
							if (!isEmpty(siteData['energy'])) {
								pvList[index] += Math.floor(siteData['energy'] / 1000);
								sumObj.pvSum += Math.floor(siteData['energy'] / 1000);
							}

							if (!isEmpty(siteData['money'])) {
								payList[index] += Math.floor(siteData['money'] / 1000);
							}
						}
					});
				}
			}
		});

		resolve();
	}).then(() => {

		let maxValue = 0;
		let emptyObj = {};

		chargeList.forEach(data => {
			if(data===0){
				if(isEmpty(emptyObj.chargeData)) {
					emptyObj.chargeData = 0;
				}
			} else {
				emptyObj.chargeData = 1;
			}
			if (data > maxValue) {
				maxValue = data;
			}
		});

		dischargeList.forEach(data => {
			if(data===0){
				if(isEmpty(emptyObj.disChargeData)) {
					emptyObj.disChargeData = 0;
				}
			} else {
				emptyObj.disChargeData = 1;
			}
			if (data > maxValue) {
				maxValue = data;
			}
		});

		pvList.forEach(data => {
			if (data > maxValue) {
				maxValue = data;
			}
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'kWh', 3, 2);
		const rtnUnit = refineMaxValue[1];

		let seriesLength = monthlyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			monthlyChart.series[i].remove();
		}

		seriesArray.forEach(el => {	
			let chartSeries = new Object();
			chartSeries.name = el.name;
			chartSeries.type = el.type;
			chartSeries.color = el.color;
			chartSeries.data = eval(el.data);

			if (el.name == i18nManager.tr("dashboard_payment")) {
				chartSeries.dashStyle = 'ShortDash';
				chartSeries.yAxis = 1;
			}
			if(el.name == i18nManager.tr("dashboard_charge") && emptyObj.chargeData === 0){
				chartSeries.showInLegend = false
			}
			if(el.name == i18nManager.tr("dashboard_discharge") && emptyObj.disChargeData === 0){
				chartSeries.showInLegend = false
			}
			chartSeries.tooltip = {valueSuffix: el.suffix}
			monthlyChart.addSeries(chartSeries, false);
		});

		monthlyChart.yAxis[0].setTitle({
			text: rtnUnit,
			align: 'low',
			rotation: 0,
			y: 25,
			x: 15,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		});
		monthlyChart.redraw();

		new Promise(resolve => {
			let str = '';
			Object.entries(sumObj).forEach(([key, value]) => {
				if(key == "chargeSum"){
					str += '<li class="charge">' + i18nManager.tr("dashboard_charge") + ' : ' + displayNumberFixedDecimal(value, 'kWh', 3, 2).join(' ') + '</li>';
				}
				if(key == "dischargeSum"){
					str += '<li class="discharge">' + i18nManager.tr("dashboard_discharge") + ' : ' + displayNumberFixedDecimal(value, 'kWh', 3, 2).join(' ') + '</li>';
				}
				if(key == "pvSum"){
					str += '<li class="pv">' + i18nManager.tr("dashboard_photovoltaic") + ' : ' + displayNumberFixedDecimal(value, 'kWh', 3, 2).join(' ') + '</li>';
				}
			});

			resolve(str);
		}).then(res => {
			$("#monthlySum").append(res)
		});
	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

/**
 * 일별차트 데이터 가공
 *
 * @returns {Promise<void | boolean>}
 */
const dailyChartDraw = async () => {
	const monthData = getSiteMainSchCollection('month');
	const targetApi = [apiHost + '/energy/sites?interval=day&startTime=' + monthData.startTime + '&endTime=' +monthData.endTime, apiHost + '/energy/now/sites?interval=day'];

	const today = new Date();
	const lastDay = new Date(today.getFullYear(), today.getMonth() + 2, 0);

	let chargeList = new Array(lastDay.getDate()).fill(0);
	let dischargeList = new Array(lastDay.getDate()).fill(0);
	let pvList = new Array(lastDay.getDate()).fill(0);
	let payList = new Array(lastDay.getDate()).fill(0);

	let sumObj = {
		chargeSum: 0,
		dischargeSum: 0,
		pvSum: 0,
	};

	let categories = new Array();
	for (let i = 1; i <= lastDay.getDate(); i++) {
		categories.push(String(i));
	}

	$(`.gmain-chart2 span.term`).text(today.format('yyyy.MM') + '.1 ~ ' + today.format('yyyy.MM') + '.' + today.getDate());

	new Promise(resolve => {
		targetApi.forEach((targetUrl, index) => {
			const apiData = apiDatas[targetUrl];
			if (index === 0) {
				if (!isEmpty(apiData)) {
					const siteEnergyData = apiData['data'];
					if (!isEmpty(siteEnergyData)) {
						Object.entries(siteEnergyData).forEach(([siteId, siteEnergyItem]) => {
							if (!isEmpty(siteEnergyItem)) {
								siteEnergyItem.forEach(siteEnergy => {
									const items = siteEnergy['items'];
									if (!isEmpty(items)) {
										items.forEach(item => {
											// (인코어드 데이터 모니터링 용) 지우지 말아주세요. 발전량이 과도하게 많이 들어온 경우
											// if(item.energy > 10000000){
											// 	console.log("사이트 아이디===>", siteId, "에너지===>", item, "사이트 에너지 상세 ===>", siteEnergyItem )
											// }
											const index = Number(String(item['basetime']).slice(6, 8)) - 1;
											pvList[index] += Math.floor(item['energy'] / 1000);
											payList[index] += Math.floor(item['money'] / 1000);
											sumObj['pvSum'] += Math.floor(item['energy'] / 1000);
										});
									}
								});
							}
						});
					}
				}
			} else {
				if (!isEmpty(apiData)) {
					const siteNowEnergyData = apiData['data'];
					Object.entries(siteNowEnergyData).forEach(([siteKey, siteData]) => {
						if (!isEmpty(siteData)) {
							const index = Number(String(siteData['start']).slice(6, 8)) - 1;
							if (!isEmpty(siteData['energy'])) {
								pvList[index] += Math.floor(siteData['energy'] / 1000);
								sumObj['pvSum'] += Math.floor(siteData['energy'] / 1000);
							}

							if (!isEmpty(siteData['money'])) {
								payList[index] += Math.floor(siteData['money'] / 1000);
							}
						}

					});
				}
			}
		});

		resolve();
	}).then(() => {

		let maxValue = 0;
		let emptyObj = {};

		chargeList.forEach(data => {
			if(data===0){
				if(isEmpty(emptyObj.chargeData)) {
					emptyObj.chargeData = 0;
				}
			} else {
				emptyObj.chargeData = 1;
			}
			if (data > maxValue) {
				maxValue = data;
			}
		});

		dischargeList.forEach(data => {
			if(data===0){
				if(isEmpty(emptyObj.disChargeData)) {
					emptyObj.disChargeData = 0;
				}
			} else {
				emptyObj.disChargeData = 1;
			}
			if (data > maxValue) {
				maxValue = data;
			}
		});

		pvList.forEach(data => {
			if(data===0){
				if(isEmpty(emptyObj.pvData)) {
					emptyObj.pvData = 0;
				}
			} else {
				emptyObj.pvData = 1;
			}
			if (data > maxValue) {
				maxValue = data;
			}
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'kWh', 3, 2);
		const rtnUnit = refineMaxValue[1];

		let seriesLength = dailyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			dailyChart.series[i].remove();
		}

		$.each(seriesArray, function (i, el) {
			let chartSeries = new Object();
			chartSeries.name = el.name;
			chartSeries.type = el.type;
			chartSeries.color = el.color;
			chartSeries.data = eval(el.data);

			if (el.name == '정산금') {
				chartSeries.dashStyle = 'ShortDash';
				chartSeries.yAxis = 1;
				let maxData = chartSeries.data.find( x => x >= 0 );
				if(isEmpty(maxData)) {
					chartSeries.showInLegend = false;
				};
			}
			if(el.name == i18nManager.tr("dashboard_photovoltaic") && emptyObj.pvData === 0){
				chartSeries.showInLegend = false;
			}
			if(el.name == i18nManager.tr("dashboard_charge") && emptyObj.chargeData === 0){
				chartSeries.showInLegend = false
			}
			if(el.name == i18nManager.tr("dashboard_discharge") && emptyObj.disChargeData === 0){
				chartSeries.showInLegend = false
			}
			chartSeries.tooltip = {valueSuffix: el.suffix}
			dailyChart.addSeries(chartSeries, false);
		});

		dailyChart.yAxis[0].setTitle({
			text: rtnUnit,
			align: 'low',
			rotation: 0,
			y: 25,
			x: 15,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		});
		dailyChart.xAxis[0].setCategories(categories);
		dailyChart.redraw(); // 차트 데이터를 다시 그린다

		new Promise(resolve => {
			let str = '';
			Object.entries(sumObj).forEach(([key, value]) => {
				if(key == 'chargeSum'){
				
					str += '<li class="charge">' + i18nManager.tr("dashboard_charge") + ' : ' + displayNumberFixedDecimal(value, 'kWh', 3, 2).join(' ') + '</li>';
				}
				if(key == 'dischargeSum'){
					str += '<li class="discharge">' + i18nManager.tr("dashboard_discharge") + ' : ' + displayNumberFixedDecimal(value, 'kWh', 3, 2).join(' ') + '</li>';
				}
				if(key == 'pvSum'){
					str += '<li class="pv">' + i18nManager.tr("dashboard_photovoltaic") + ' : ' + displayNumberFixedDecimal(value, 'kWh', 3, 2).join(' ') + '</li>';
				}
			});
			resolve(str);
		}).then(res => {
			$('#dailySum').append(res)
		});
	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

const typeSiteDraw = async () => {
	const yesterData = getSiteMainSchCollection('yesterday');
	const targetApi = [apiHost + '/energy/sites?interval=day&startTime=' + yesterData.startTime + '&endTime=' +yesterData.endTime, apiHost + '/energy/forecasting/sites?interval=day&startTime=' + yesterData.startTime + '&endTime=' +yesterData.endTime];
	const yesterday = new Date();

	yesterday.setDate(Number(today.getDate()) - 1);

	$(`.gmain-chart3 span.term`).text(yesterday.getFullYear() + '.' + (Number(yesterday.getMonth()) + 1) + '.' + yesterday.getDate());

	new Promise(resolve => {
		const siteGenArray = new Object;
		const siteForeGenArray = new Object;

		targetApi.forEach((targetUrl, index) => {
			const apiData = apiDatas[targetUrl];
			if (!isEmpty(apiData)) {
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
			}
		});

		resolve({
			siteGenArray: siteGenArray,
			siteForeGenArray: siteForeGenArray
		});
	}).then(({siteGenArray, siteForeGenArray}) => {
		let maxValue = 0;
		let emptyObj = {};

		if( isEmpty(Object.values(siteGenArray)) ){
			emptyObj.siteGenData = 0;
		}
		Object.entries(siteGenArray).forEach(([siteId, data]) => {
			if(data===0){
				if(isEmpty(emptyObj.siteGenData)) {
					emptyObj.siteGenData = 0;
				}
			} else {
				emptyObj.siteGenData = 1;
			}
			if (data > maxValue) {
				maxValue = data;
			}
		});

		if( isEmpty(Object.values(siteForeGenArray)) ){
			emptyObj.siteForeGenData = 0;
		}
		Object.entries(siteForeGenArray).forEach(([siteId, data]) => {
			if(data===0){
				if(isEmpty(emptyObj.siteForeGenData)) {
					emptyObj.siteForeGenData = 0;
				}
			} else {
				emptyObj.siteForeGenData = 1;
			}
			if (data > maxValue) {
				maxValue = data;
			}
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'kWh', 3, 2);
		const rtnUnit = refineMaxValue[1];

		let seriesLength = typeSiteCurrent.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			typeSiteCurrent.series[i].remove();
		}

		let categories = new Array();
		let tmepGenArray = new Array();
		let tempForeArray = new Array();

		siteList.forEach(site => {
			const siteId = site.sid
				, siteName = site.name;

			if (!isEmpty(siteGenArray[siteId]) && siteGenArray[siteId] > 0) {
				const siteGen = siteGenArray[siteId];
				const siteForeGen = isEmpty(siteForeGenArray[siteId]) ? 0 : siteForeGenArray[siteId];

				categories.push(siteName);
				tmepGenArray.push(siteGen);
				tempForeArray.push(siteForeGen);
			}
		});

		typeSiteCurrent.addSeries({
			name: i18nManager.tr("dashboard_generation"),
			color: 'var(--turquoise)',
			data: tmepGenArray,
			tooltip: {
				valueSuffix: 'kWh'
			},
			pointWidth: 9,
			pointPadding: 0.25,
			showInLegend: emptyObj.siteGenData == 0 ? false : true
		});

		typeSiteCurrent.addSeries({
			name: i18nManager.tr("dashboard_generation_forecast"),
			color: 'var(--grey)',
			data: tempForeArray,
			tooltip: {
				valueSuffix: 'kWh'
			},
			pointWidth: 9,
			pointPadding: 0.25,
			showInLegend: emptyObj.siteForeGenData == 0 ? false : true
		});

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

		if(!isEmpty(tmepGenArray)){
			genSum = tmepGenArray.reduce((acc, val) => { return acc + val } , 0);
			str += '<li class="charge">'+ i18nManager.tr("dashboard_generation") + ' : ' + displayNumberFixedDecimal(genSum, 'kWh', 3, 2).join(' ') + '</li>';
		}
		if(!isEmpty(tempForeArray)){
			genForecastSum = tempForeArray.reduce((acc, val) => { return acc + val } , 0);
			str += '<li class="discharge">' + i18nManager.tr("dashboard_generation_forecast") + ' : ' + displayNumberFixedDecimal(genForecastSum, 'kWh', 3, 2).join(' ') + '</li>';
		}
		$("#yesterdaySum").append(str);
	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

/**
 * 현재출력 데이터 정제
 *
 * @returns {Promise<unknown>}
 */
const getTodayTotalDetail = async function () {
	const targetApi = [apiHost + '/energy/now/sites?interval=day', apiHost + '/energy/forecasting/sites?interval=day&startTime=' + dayData.startTime + '&endTime=' +dayData.endTime, apiHost + '/status/raw/site'];

	let targetArea = $('.gmain-chart4 .chart-info-right ul li');

	$('.gmain-chart4 .chart-info-right ul li:nth-child(1) span').text(0);
	$('.gmain-chart4 .chart-info-right ul li:nth-child(2) span').text(0);

	$('#centerTbody tr td:nth-child(1)').html(Math.floor(siteList.length) + '<em>&nbsp;&nbsp;'+i18nManager.tr('dashboard.EA')+'</em>');
	$('#centerTbody tr td:nth-child(2)').text('');
	$('#centerTbody tr td:nth-child(3)').text('');
	$('#centerTbody tr td:nth-child(4)').text('');
	$('#centerTbody tr td:nth-child(5)').text('');

	new Promise((resolve, reject) => {
		let acPowerSum = 0
		  , capacitySum = 0
		  , invertorCount = 0;

		targetApi.forEach((targetUrl, index) => {
			const apiData = apiDatas[targetUrl];
			if (!isEmpty(apiData) && !isEmpty(apiData['data'])) {
				const resultData = apiData['data'];
				if (index === 0) {
					let co2Sum = 0, energySum = 0, moneySum = 0;
					Object.entries(resultData).forEach(([siteKey, siteNowEnergy]) => {
						if (!isEmpty(siteNowEnergy)) {
							co2Sum += Math.floor(isEmpty(siteNowEnergy['co2']) ? 0 : siteNowEnergy['co2']);
							energySum += Math.floor(isEmpty(siteNowEnergy['energy']) ? 0 : siteNowEnergy['energy']);
							moneySum += Math.floor(isEmpty(siteNowEnergy['money']) ? 0 : siteNowEnergy['money']);
						}
					});

					$('.gmain-chart4 .chart-info-right ul li:nth-child(1) span').text(numberComma(Math.floor(energySum / 1000)));
					$('#centerTbody tr td:nth-child(4)').html(numberComma(Math.floor(co2Sum / 1000)) + '<em>&nbsp;&nbsp;kg</em>');
					$('#centerTbody tr td:nth-child(5)').html(numberComma(Math.floor(moneySum / 1000)) + '<em>&nbsp;&nbsp;'+i18nManager.tr('dashboard_in_thousands_of_won')+'</em>');
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
			} else if (!isEmpty(apiData) && index === 2) {
				Object.entries(apiData).forEach(([siteKey, devices]) => {
					if (!isEmpty(devices)) {
						Object.entries(devices).forEach(([deviceType, deviceData]) => {
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
					}
				});
			}
		});

		const resolveData = {
			activePower: acPowerSum,
			capacity: capacitySum,
			invertorCount: invertorCount
		}

		resolve(resolveData);
	}).then(resolveData => {
		const acPowerSum = resolveData['activePower']
			, capacitySum = resolveData['capacity']
			, invertorCount = resolveData['invertorCount']
			, usage = Math.floor((acPowerSum / capacitySum) * 100)
			, other = 100 - usage;

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
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

/**
 * 알람 이력 리스트 생성
 *
 * @returns {Promise<void>}
 */
const alarmInfoList = async () => {
	const targetApi = [apiHost + '/alarms'];

	Object.entries(apiDatas).forEach(rst => {
		const apiUrl = rst[0]
			, apiData = rst[1];

		if (targetApi.includes(apiUrl)) {
			if (!isEmpty(apiData)) {
				//localtime 오름차순 정렬
				apiData.sort((a, b) => {
					return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
				});

				let alarmList = new Array();
				let alarmColor = "";
				let alarmEl = $('.indiv[data-alarm]');
				
				apiData.forEach(alarm => {
					if(alarm.level !== 0) {
						let localTime = (alarm.localtime != null && alarm.localtime != '') ? String(alarm.localtime) : '';
						alarm.standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
						alarmList.push(alarm);
					}
				});

				if(alarmList.length>0){
					if( alarmList.findIndex(x => x.level == 4) > -1){
						alarmColor = "urgent";
					} else {
						if( alarmList.findIndex(x => x.level == 3) > -1 ){
							alarmColor = "shutoff";
						} else {
							if( alarmList.findIndex(x => x.level == 2) > -1 ){
								alarmColor = "critical";
							} else {
								if( alarmList.findIndex(x => x.level == 1) > -1 ){
									alarmColor = "warning";
								} else {
									if( alarmList.findIndex(x => x.level == 0) > -1 ){
										alarmColor = "info";
									} else {
										alarmColor = "";
									}
								}
							}
						}
					}
				} else {
					alarmColor = "";
				}

				alarmEl.attr("data-alarm", alarmColor);
				alarmEl.find('em').text(alarmList.length);
				setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}}); //list생성
			
			} else {
				let alarmEl = $('.indiv[data-alarm]');
				alarmEl.attr("data-alarm", "");
			}
		}
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
const searchSite = async function () {
	const targetApi = [apiHost + '/energy/sites?interval=day&startTime=' + yesterData.startTime + '&endTime=' +yesterData.endTime, apiHost + '/energy/now/sites?interval=day', apiHost + '/energy/forecasting/sites?interval=day&startTime=' + dayData.startTime + '&endTime=' + dayData.endTime, apiHost + '/weather/site', apiHost + '/alarms'];
	const searchName = document.getElementById('searchName').value.trim();
	const deviceStatus = new Array();
	document.querySelectorAll('[name="deviceStatus"]:checked').forEach(chk => {
		deviceStatus.push(chk.value);
	});

	document.getElementById('miniLoadingCircle').style.display = '';

	new Promise((resolve, reject) => {
		const refineList = new Array();
		siteList.forEach(site => {
			const siteId = site.sid;

			let operation = new Array()
				, capacity = '-'
				, activePower = '-'
				, inverterCount = '-'
				, irradiationPoa = '-';
			Object.entries(apiDatas).forEach(api => {
				const apiUrl = api[0]
					, apiData = api[1];

				if ((apiHost + '/status/raw/site') === apiUrl && !isEmpty(apiData[siteId])) {
					const rawDevices = apiData[siteId];
					Object.entries(rawDevices).forEach(device => {
						const deviceType = device[0]
							, deviceData = device[1];

						if (!isEmpty(deviceData)) {
							//대상은 INV 인버터 타입 대상
							if (deviceType.match('INV')) {
								if (!operation.includes(deviceData['operation'])) {
									operation.push(deviceData['operation']);
								}

								activePower = (activePower != '-') ? activePower + deviceData['activePower'] : deviceData['activePower'];
								capacity = (capacity != '-') ? capacity + deviceData['capacity'] : deviceData['capacity'];
								inverterCount = (!isEmpty(deviceData['devices'])) ? deviceData['devices'].length : '-';
							} else if (deviceType === 'SENSOR_SOLAR') {
								if (!isEmpty(deviceData) && !isEmpty(deviceData['irradiationPoa'])) {
									irradiationPoa = (deviceData['irradiationPoa']).toFixed(1);
								}
							}
						}
					});
				}
			});

			// 인버터 설비 정보가 없을경우
			// 정지로 판단한다.
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

			if(!isEmpty(operation)){
				if (targetOperation && searchSite) {
			
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
				
					site['inverterCount'] = inverterCount //사이트에 속한 인버터 갯수.
					site['operation'] = operation; //사이트 상태 정보.
					site['capacity'] = capacity;   //사이트에 속한 인버터 설비 용량 정보.
					site['capacityView'] = (isEmpty(capacity) || capacity === '-') ? '-' : displayNumberFixedUnit(capacity, 'W', 'kW', 0)[0];   //사이트에 속한 인버터 설비 용량 정보.
					site['activePower'] = activePower;   //사이트에 속한 인버터.
					site['activePowerView'] =(isEmpty(activePower) || activePower === '-') ? '-' : displayNumberFixedUnit(activePower, 'W', 'kW', 0)[0];   //사이트에 속한 인버터.
					site['irradiationPoa'] = irradiationPoa;   //사이트에 속한 인버터 설비 용량 정보.
					refineList.push(site);
				}
			} else {
				site['status'] = 'null';
				site['statusClass'] = 'status-null';
			}
		});

		if (refineList.length > 0) {
			resolve(refineList);
		} else {
			setMakeList(refineList, 'siteList', {'dataFunction': {'align': alignFunc}}); //list생성
		}
	}).then(refineList => {
		if (!isEmpty(refineList)) {
			refineList.forEach((site, siteIdx) => {
				const siteId = site['sid'];
				refineList[siteIdx].resourceClass = resourceIcon(site.resource_type);

				targetApi.forEach((targetUrl, index) => {
					const apiData = apiDatas[targetUrl];
					if (index === 3) {
						let temperature = '-'
							, humidity = '-';
						if (!isEmpty(apiData)) {
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
					} else {
						if (!isEmpty(apiData)) {
							const resultData = apiData['data'];
							if (index === 0) {
								let siteYesterGenSum = 0;
								if (!isEmpty(resultData[siteId])) {
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
								if (!isEmpty(resultData[siteId])) {
									const siteNowEnergy = resultData[siteId];
									if(!isEmpty(siteNowEnergy) && !isEmpty(siteNowEnergy['energy'])) {
										refineList[siteIdx]['accumulate'] = displayNumberFixedUnit(siteNowEnergy['energy'], 'Wh', 'kWh', 0)[0];
									} else {
										refineList[siteIdx]['accumulate'] = '-';
									}
								}
							} else if (index === 2) { //금일 예측
								let siteForeGenSum = 0;
								if (!isEmpty(resultData[siteId])) {
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
							}
						}
					}
				});
			});
		}

		refineList.sort(
			firstBy(function(a, b) {return Number(String(b['accumulate']).replace(/[^0-9]/g, '')) - Number(String(a['accumulate']).replace(/[^0-9]/g, ''));})
			.thenBy(function(a, b) {return Number(String(b['capacity']).replace(/[^0-9]/g, '')) - Number(String(a['capacity']).replace(/[^0-9]/g, ''));})
		);

		refineList.forEach(site => {
			if (site['accumulate'] === undefined) site['accumulate'] = '-';
			if (site['forecast'] === undefined) site['forecast'] = '-';
		});

		setMakeList(refineList, 'siteList', {'dataFunction': {'align': alignFunc}}); //list생성

		if (typeof (geocodeAddress) == 'function' && !isEmpty(apiDatas[apiHost + '/status/raw/site']) && !isEmpty(apiDatas[apiHost + '/energy/now/sites?interval=day'])  && isEmpty(makerObject)) {
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
				let capacity = (site.capacity == '-' && isNaN(site.capacity)) ? 0 :site.capacity;
				let activePower = (site.activePower == '-' && isNaN(site.activePower)) ? 0 : site.activePower;

				let activePercent = Math.floor((activePower / capacity) * 100);
				let title = activePercent + '%';
				if (isNaN(activePercent)) {
					title = '- %';
				}

				let etc = capacity - activePower;
				let series = [{
					type: 'pie',
					innerSize: '70%',
					name: '설비용량',
					colorByPoint: true,
					data: [{
						color: 'var(--turquoise)',
						name: '총 설비용량',
						dataLabels: {
							enabled: false
						},
						y: activePower
					}, {
						color: 'var(--dove-gray)',
						name: '미설비용량',
						dataLabels: {
							enabled: false
						},
						y: etc //30% 나머지
					}]
				}];

				siteListChart('type_chart' + siteIdx, series, title);
			});
		}, 400);
		
		document.getElementById('loadingCircleDashboard').style.display =  'none';

		if (!isEmpty(apiDatas[apiHost + '/status/raw/site']) && !isEmpty(apiDatas[apiHost + '/energy/now/sites?interval=day'])) {
			document.getElementById('miniLoadingCircle').style.display = 'none';
		}

		return refineList;
	}).catch(error => {
		console.error(error);
		if (!isEmpty(apiDatas[apiHost + '/status/raw/site']) && !isEmpty(apiDatas[apiHost + '/energy/now/sites?interval=day'])) {
			document.getElementById('miniLoadingCircle').style.display = 'none';
		}
		document.getElementById('miniLoadingCircle').style.display = '';
		document.getElementById('loadingCircleDashboard').style.display =  'none';
		$('#errMsg').text(error);
		$('#errorModal').modal('show');
		setTimeout(function(){
			$('#errorModal').modal('hide');
		}, 2000);
		return false;
	});
}

const searchAlarm = async () => {
	let siteSids = new Array();
	siteList.forEach(site => {
		siteSids.push(site.sid);
	});

	if (isEmpty(sgid)) siteSids = 'all';

	$.ajax({
		url: apiHost + '/alarms',
		type: 'GET',
		data: {
			sids: siteSids.toString(),
			startTime: dayData.startTime,
			endTime: dayData.endTime,
			confirm: false
		},
		success: (data, textStatus, jqXHR) => {
			apiDatas[apiHost + '/alarms'] = data;
			alarmInfoList();
		},
		error: (jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
			return false;
		}
	});
}

const searchStatusRaw = async () => {
	let apiUrl = new Array();
	let apiData = new Object();
	siteList.forEach(site => {
		apiUrl.push($.ajax({
			url: apiHost + '/status/raw/site',
			type: 'GET',
			data: {
				sid: site.sid,
				formId: 'v2'
			}
		}));
	});

	Promise.all(apiUrl).then(response => {
		response.forEach(device => {
			Object.entries(device).forEach(([type, data]) => {
				const sid = data.sid;
				if (!isEmpty(sid)) {
					if (isEmpty(apiData[sid]) ) {
						apiData[sid] = device;
					} else {
						if (isEmpty(apiData[sid][type])) {
							const rawData = apiData[sid];
							rawData[type] = device;
							apiData[sid] = rawData;
						}
					}
				}
			});
		});

		apiDatas[apiHost + '/status/raw/site'] = apiData;
		getTodayTotalDetail();
		searchSite();
	}).catch(errer => {});
}

const searchNowMonth = async () => {
	let siteSids = new Array();
	siteList.forEach(site => {
		siteSids.push(site.sid);
	});

	if (isEmpty(sgid)) siteSids = 'all';

	$.ajax({
		url: apiHost + '/energy/now/sites?interval=month',
		type: 'GET',
		data: {
			sids: siteSids.toString(),
			metering_type: 2,
		},
		success: (data, textStatus, jqXHR) => {
			apiDatas[apiHost + '/energy/now/sites?interval=month'] = data;
			monthlyChartDraw();
			dailyChartDraw();
		},
		error: (jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
			return false;
		}
	})
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