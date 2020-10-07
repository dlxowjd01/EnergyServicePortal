//대시보드 먼슬리 && 데일리 차트 시리증 설정.
const seriesArray = [
	{name: '충전', type: 'column', color: 'var(--circle-charge)', data: 'chargeList', suffix: 'kWh'},
	{name: '방전', type: 'column', color: 'var(--grey)', data: 'dischargeList', suffix: 'kWh'},
	{name: '태양광', type: 'column', color: 'var(--circle-solar-power)', data: 'pvList', suffix: 'kWh'},
	{name: '정산금', type: 'spline', color: 'var(--white)', data: 'payList', suffix: '천원'},
];

const keyArray = ['battery', 'generation'];

let monthlyBefore = 0;
let monthlyNow = 0;

let dailyBefore = 0;
let dailyNow = 0;

const resourceTemplate = new Array();

<!-- properties 조회 -->
const resourceProperties = async () => {
	$.ajax({
		url: apiHost + '/config/view/properties',
		type: 'get',
		async: false,
		data: {
			types: 'resource'
		},
		dataType: 'json',
		success: function (result) {
			Object.entries(result.resource).map(obj => {
				if (langStatus == 'KO') {
					resourceTemplate[obj[1].code] = obj[1].name.kr;
				} else {
					resourceTemplate[obj[1].code] = obj[1].name.en;
				}
			});
		}
	});
};

/**
 * 대쉬보드 먼슬리 차트 그리기
 */
const chartColorArray = ['var(--circle-charge)', 'var(--grey)', 'var(--circle-solar-power)', 'var(--white)'];
const getYearGenData = async function () {
	const formData = getSiteMainSchCollection('year');//api에 맞게 수정 필요

	let resourceType = new Object();
	let urls = new Array();
	let deferreds = new Array();

	let pvList = new Object();
	let sumObj = new Object();
	$(`.gmain-chart1 span.term`).text(today.getFullYear() + '.1.1 ~ ' + today.getFullYear() + '.' + (Number(today.getMonth()) + 1) + '.' + today.getDate());
	siteList.forEach(site => {
		resourceType[site.sid] = site.resource_type;

		urls.push({
			url: apiHost + '/energy/sites',
			type: "GET",
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				displayType: 'dashboard',
				interval: 'month'
			}
		});
	});

	//ajax 한번에 실행
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
		for (let index = 0; index < arguments.length; index++) {
			const resultData = arguments[index].data[0];
			const siteId = resultData.sid;
			const resTp = resourceType[siteId];

			Object.entries(resultData).forEach(result => {
				if (result[0] === 'generation') {
					const items = result[1].items;
					items.forEach(item => {
						if (item.energy != null && item.energy != '') {
							const month = Number(String(item.basetime).slice(4, 6)) - 1;
							if (isEmpty(pvList[resTp])) {
								pvList[resTp] = new Array(12).fill(0);
								sumObj[resTp] = 0;
							}
							pvList[resTp][month] += Math.floor(item.energy / 1000);
							sumObj[resTp] += Math.floor(item.energy / 1000);
						}
					});
				}
			});
		}

		let seriesLength = monthlyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			monthlyChart.series[i].remove();
		}

		Object.entries(resourceTemplate).forEach(resource => {
			if (!isEmpty(pvList[resource[0]])) {
				let chartSeries = new Object();
				chartSeries['name'] = resource[1];
				chartSeries['type'] = 'column';
				chartSeries['color'] = chartColorArray[resource[0]];
				chartSeries['data'] = pvList[resource[0]];
				chartSeries['tooltip'] = {valueSuffix: 'kWh'}

				monthlyChart.addSeries(chartSeries, false);
			}
		});

		monthlyChart.redraw();

		return new Promise((resolve, reject) => {
			let str = '';
			Object.entries(resourceTemplate).forEach(([key, value]) => {
				let newValue = '';
				if (!isEmpty(sumObj[key])) {
					if (String(sumObj[key]).length  >= 5) {
						newValue = numberComma(sumObj[key] / 1000) + ' M';
					} else {
						newValue = String(sumObj[key]);
					}

					str += '<li class="pv">' + value + ' : ' + newValue + '</li>';
				}
			});
			resolve(str);
		}).then(res => {
			$("#monthlySum").append(res)
		});
	});
}

const monthlyChart = Highcharts.chart('monthlyChart', {
	chart: {
		marginTop: 40,
		marginLeft: 60,
		marginRight: 55,
		backgroundColor: 'transparent',
		zoomType: 'xy'
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
	xAxis: [{
		lineColor: 'var(--white60)', /* 눈금선색 */
		tickWidth: 1,
		tickColor: 'var(--white60)',
		tickInterval: 1,
		gridLineColor: 'var(--white60)',
		plotLines: [{
			color: 'var(--white60)',
			width: 1
		}],
		type: 'datetime',
		dateTimeLabelFormats: {
			millisecond: '%H:%M:%S.%L',
			second: '%H:%M:%S',
			minute: '%H:%M',
			hour: '%H',
			day: '%m.%d ',
			week: '%m.%e',
			month: '%m',
			year: '%Y'
		},
		labels: {
			align: 'center',
			y: 27, /* 그래프와 거리 */
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
		title: {
			text: null
		},
		categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
		crosshair: true
	}],
	yAxis: [{ // Primary yAxis
		lineColor: 'var(--white60)', /* 눈금선색 */
		tickColor: 'var(--white60)',
		gridLineColor: 'var(--white60)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--white60)',
			width: 1
		}],
		title: {
			text: 'kWh',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: 15,
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		labels: {
			formatter: function () {
				if (String(this.value).length  >= 5) {
					return numberComma(this.value / 1000) + ' M';
				} else {
					return this.value;
				}
			},
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		}
	}],
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				let suffix = point.series.userOptions.tooltip.valueSuffix;
				return s + ' 월 <br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(point.y) + suffix;
			}, '<b>' + this.x + '</b>');
		},
		shared: true, /* 툴팁 공유 */
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--white87)'
		}
	},
	/* 범례 */
	legend: {
		enabled: true,
		align: 'right',
		verticalAlign: 'top',
		x: 5,
		y: -15,
		itemStyle: {
			color: 'var(--white60)',
			fontSize: '12px',
			fontWeight: 400
		},
		itemHoverStyle: {
			color: '' /* 마우스 오버시 색 */
		},
		symbolPadding: 0, /* 심볼 - 텍스트간 거리 */
		symbolHeight: 7 /* 심볼 크기 */
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
			stacking: 'normal' /*위로 쌓이는 막대  ,normal */
		}
	},
	series: null,
	/* 출처 */
	credits: {
		enabled: false
	},
	/* 반응형 */
	responsive: {
		rules: [{ /* 차트 사이즈 - 4K용 */
			condition: {
				minWidth: 787,
			},
			chartOptions: {
				xAxis: {
					labels: {
						style: {
							fontSize: '12px'
						}
					}
				},
				yAxis: [{
					title: {
						y: 30,
						x: 20,
						style: {
							fontSize: '12px'
						}
					},
					labels: {
						style: {
							fontSize: '12px'
						}
					}
				}],
				legend: {
					itemStyle: {
						fontSize: '12px'
					},
					symbolPadding: 5,
					symbolHeight: 10
				}
			}
		}, { /* 차트 사이즈 - 모바일용 */
			condition: {
				maxWidth: 481
			},
			chartOptions: {
				chart: {
					marginTop: 55
				}
			}
		}]
	}
});

const getDailyGenData = async function () {
	const today = new Date();
	const lastDay = new Date(today.getFullYear(), today.getMonth() + 2, 0);
	const formData = getSiteMainSchCollection("month");//api에 맞게 수정 필요

	let resourceType = new Object();
	let urls = new Array();
	let deferreds = new Array();

	let pvList = new Object();
	let sumObj = {
		pvSum: 0,
	};

	// let chargeList = new Array(lastDay.getDate()).fill(0);
	// let dischargeList = new Array(lastDay.getDate()).fill(0);
	// let pvList = new Array(lastDay.getDate()).fill(0);
	// let payList = new Array(lastDay.getDate()).fill(0);

	let categories = new Array();
	for (let i = 1; i <= lastDay.getDate(); i++) {
		categories.push(String(i));
	}

	$(`.gmain-chart2 span.term`).text(today.format('yyyy.MM') + '.1 ~ ' + today.format('yyyy.MM') + '.' + today.getDate());
	siteList.forEach(site => {
		resourceType[site.sid] = site.resource_type;

		urls.push({
			url: apiHost + '/energy/sites',
			type: "GET",
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				displayType: 'dashboard',
				interval: 'day'
			}
		});

		urls.push({
			url: apiHost + '/energy/now/sites',
			type: 'GET',
			data: {
				sids: site.sid,
				metering_type: 2,
				interval: 'day'
			}
		});
	});

	//ajax 한번에 실행
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
		for (let index = 0; index < arguments.length; index++) {
			const reqUrl = arguments[index].url;

			if (reqUrl.match('/energy/sites')) {
				const resultData = arguments[index].data[0];
				const siteId = resultData.sid;
				const resTp = resourceType[siteId];

				Object.entries(resultData).forEach(result => {
					if (result[0] === 'generation') {
						const items = result[1].items;
						items.forEach(item => {
							if (item.energy != null && item.energy != '') {
								const day = Number(String(item.basetime).slice(6, 8)) - 1;
								if (isEmpty(pvList[resTp])) {
									pvList[resTp] = new Array(lastDay.getDate()).fill(0);
									sumObj[resTp] = 0;
								}
								pvList[resTp][day] += Math.floor(item.energy / 1000);
								sumObj.pvSum += Math.floor(item.energy / 1000);
							}
						});
					}
				});
			} else {
				const resultData = arguments[index].data;
				Object.entries(resultData).forEach(result => {
					const sid = result[0];
					const data = result[1];
					const resTp = resourceType[siteId];

					const day = Number(String(data.start).slice(6, 8)) - 1;
					if (data.energy) {
						if (isEmpty(pvList[resTp])) {
							pvList[resTp] = new Array(lastDay.getDate()).fill(0);
							sumObj[resTp] = 0;
						}

						pvList[resTp][day] += Math.floor(data.energy / 1000);
						sumObj.pvSum += Math.floor(data.energy / 1000);
					}
				});
			}
		}

		let seriesLength = dailyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			dailyChart.series[i].remove();
		}

		Object.entries(resourceTemplate).forEach(resource => {
			if (!isEmpty(pvList[resource[0]])) {
				let chartSeries = new Object();
				chartSeries['name'] = resource[1];
				chartSeries['type'] = 'column';
				chartSeries['color'] = chartColorArray[resource[0]];
				chartSeries['data'] = pvList[resource[0]];
				chartSeries['tooltip'] = {valueSuffix: 'kWh'}

				dailyChart.addSeries(chartSeries, false);
			}
		});
		dailyChart.xAxis[0].setCategories(categories);
		dailyChart.redraw(); // 차트 데이터를 다시 그린다

		return new Promise((resolve, reject) => {
			let str = '';
			Object.entries(resourceTemplate).forEach(([key, value]) => {
				let newValue = '';
				if (!isEmpty(sumObj[key])) {
					if (String(sumObj[key]).length  >= 5) {
						newValue = numberComma(sumObj[key] / 1000) + ' M';
					} else {
						newValue = String(sumObj[key]);
					}

					str += '<li class="pv">' + value + ' : ' + newValue + '</li>';
				}
			});
			resolve(str);
		}).then(res => {
			$("#dailySum").append(res)
		});
	});
}

const dailyChart = Highcharts.chart('dailyChart', {
	chart: {
		marginTop: 40,
		marginLeft: 50,
		marginRight: 50,
		backgroundColor: 'transparent',
		zoomType: 'xy'
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
	xAxis: [{
		// lineColor: 'var(--white60)',
		tickWidth: 1,
		tickColor: 'var(--white60)',
		plotLines: [{
			color: 'red',
			width: 1
		}],
		type: 'datetime', // 08.20 이우람 추가
		dateTimeLabelFormats: { // 08.20 이우람 추가
			millisecond: '%H:%M:%S.%L',
			second: '%H:%M:%S',
			minute: '%H:%M',
			hour: '%H',
			day: '%m.%d ',
			week: '%m.%e',
			month: '%m',
			year: '%Y'
		},
		labels: {
			align: 'center',
			y: 27, /* 그래프와 거리 */
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		tickWidth: 1,
		tickColor: 'var(--white87)',
		tickInterval: 1,
		title: {
			text: null
		},
		categories: null,
		crosshair: true
	}],
	yAxis: [{ // Primary yAxis
		lineColor: 'var(--white87)', /* 눈금선색 */
		tickColor: 'var(--white87)',
		gridLineColor: 'var(--white87)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--white87)',
			width: 1
		}],
		title: {
			text: 'kWh',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: 15,
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		labels: {
			formatter: function () {
				if (String(this.value).length  >= 5) {
					return numberComma(this.value / 1000) + ' M';
				} else {
					return this.value;
				}
			},
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		}
	}],
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				let suffix = point.series.userOptions.tooltip.valueSuffix;
				return s + ' 일 <br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(point.y) + suffix;
			}, '<b>' + this.x + '</b>');
		},
		shared: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--white87)'
		}
	},
	/* 범례 */
	legend: {
		enabled: true,
		align: 'right',
		verticalAlign: 'top',
		x: 5,
		y: -15,
		itemStyle: {
			color: 'var(--white60)',
			fontSize: '12px',
			fontWeight: 400
		},
		itemHoverStyle: {
			color: '' /* 마우스 오버시 색 */
		},
		symbolPadding: 0, /* 심볼 - 텍스트간 거리 */
		symbolHeight: 7 /* 심볼 크기 */
	},
	/* 옵션 */
	plotOptions: {
		series: {
			label: {
				connectorAllowed: false
			},
			borderWidth: 0, /* 보더 0 */
			events: {
				legendItemClick: function () {
					var visibility = this.visible ? 'visible' : 'hidden';
					this.legendItem.styles.color == 'var(--white60)'
					// var visibility = this.visible ? 'visible' : 'hidden';

				}
			}
		},
		line: {
			marker: {
				enabled: false /* 마커 안보이기 */
			}
		},
		column: {
			stacking: 'normal' /*위로 쌓이는 막대  ,normal */
		}
	},
	series: [],
	/* 출처 */
	credits: {
		enabled: false
	}
});

let yesterDayGen = 0;
let yesterDayFore = 0;
const getGenDataBySiteYesterday = async function () { //3번째 indiv 사업소별 탭
	const formData = getSiteMainSchCollection('yesterday');
	const formBeforeTwoData = getSiteMainSchCollection('beforeTwo');
	const yesterday = new Date();
	let siteGenArray = new Array(siteList.length).fill(0);
	let siteForeGenArray = new Array(siteList.length).fill(0);
	let categories = new Array();

	let resourceType = new Object();
	let urls = new Array();
	let deferreds = new Array();

	let pvList = new Object();
	let sumObj = {
		pvSum: 0,
	};

	$(`.gmain-chart3 span.term`).text(yesterday.getFullYear() + '.' + (Number(yesterday.getMonth()) + 1) + '.' + yesterday.getDate());
	
	siteList.forEach((site, siteIdx) => {
		let siteGenSum = 0;
		let siteForeGenSum = 0;

		categories.push(site.name);

		//전일
		urls.push({
			url: apiHost + '/energy/sites',
			type: 'GET',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		});

		//전전일
		urls.push({
			url: apiHost + '/energy/sites',
			type: 'GET',
			data: {
				sid: site.sid,
				startTime: formBeforeTwoData.startTime,
				endTime: formBeforeTwoData.endTime,
				interval: 'day'
			}
		});
	});

	//ajax 한번에 실행
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
		for (let index = 0; index < arguments.length; index++) {
			const resultData = arguments[index].data[0];
			const siteId = resultData.sid;

			Object.entries(resultData).forEach(result => {
				if (result[0] === 'generation') {
					const items = result[1].items;
					items.forEach(item => {
						if (!isEmpty(item.energy)) {
							const date = String(item.basetime).slice(0, 8);
							if (isEmpty(siteGenArray[siteId])) {
								siteGenArray[siteId] = 0;
								siteForeGenArray[siteId] = 0;
							}

							if (formData.startTime.match(date)) {
								siteGenArray[siteId] += Math.floor(item.energy / 1000);;
							} else {
								siteForeGenArray[siteId] += Math.floor(item.energy / 1000);
							}
						}
					});
				}
			});
		}

		let tempGenArray = new Array();
		let tempForeArray = new Array();

		siteList.forEach(site => {
			const sid = site.sid;
			siteGen = isEmpty(siteGenArray[sid]) ? 0 : siteGenArray[sid];
			siteForeGen = isEmpty(siteForeGenArray[sid]) ? 0 : siteForeGenArray[sid];
			tempGenArray.push(siteGen);
			tempForeArray.push(siteForeGen);
		});

		let seriesLength = typeSiteCurrent.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			typeSiteCurrent.series[i].remove();
		}

		typeSiteCurrent.addSeries({
			name: '전일 발전',
			color: 'var(--turquoise)',
			data: tempGenArray,
			tooltip: {
				valueSuffix: 'kWh'
			}
		});

		typeSiteCurrent.addSeries({
			name: '그제 발전',
			color: 'var(--grey)',
			data: tempForeArray,
			tooltip: {
				valueSuffix: 'kWh'
			}
		});
		typeSiteCurrent.xAxis[0].setCategories(categories);
		typeSiteCurrent.redraw(); // 차트 데이터를 다시 그린다

		let str = '';
		let genSum = 0;
		let genForecastSum = 0;

		if(!isEmpty(tempGenArray)){
			let newValue = '';
			genSum = tempGenArray.reduce((acc, val) => { return acc + val } , 0);
			if ( ( String(genSum).length  >= 3 ) && ( String(genSum).length  < 5 ) ) {
				newValue = String(genSum).replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " kWh";
			} else if (String(genSum).length  >= 5) {
				newValue = String(numberComma(genSum / 1000))  + ' M';
			} else {
				newValue = String(genSum) + "kWh";
			}
			str += '<li class="charge">발전 : ' + newValue + '</li>';
		}
		if(!isEmpty(tempForeArray)){
			let newValue = '';
			genForecastSum = tempForeArray.reduce((acc, val) => { return acc + val } , 0);

			if ( ( String(genForecastSum).length  >= 3 ) && ( String(genForecastSum).length  < 5 ) ) {
				newValue = String(genForecastSum).replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " kWh";
			} else if (String(genForecastSum).length  >= 5) {
				newValue = String(numberComma(genForecastSum / 1000)) + ' M';
			} else {
				newValue = String(genForecastSum) + "kWh";
			}
			str += '<li class="discharge">발전 예측 : ' + newValue + '</li>';
		}
		$("#yesterdaySum").append(str);
		setSiteList();
	});
}

// 전날: bar chart option
const typeSiteCurrent = Highcharts.chart('typeSiteCurrent', {
	chart: {
		renderTo: 'typeSiteCurrent',
		// height: series.length * 20 + 30,
		marginTop: 0,
		marginRight: 16,
		backgroundColor: 'transparent',
		type: 'bar'
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
		lineColor: 'var(--white60)', /* 눈금선색 */
		tickColor: 'var(--white60)',
		gridLineColor: 'var(--white60)',
		plotLines: [{
			color: 'var(--white60)',
			width: 1
		}],
		labels: {
			align: 'left',
			reserveSpace: true,
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		categories: null,
		title: {
			text: null
		}
	},
	yAxis: {
		lineColor: 'var(--white60)', /* 눈금선색 */
		tickColor: 'var(--white60)',
		gridLineColor: 'var(--white60)',
		plotLines: [{
			color: 'var(--white60)',
			width: 1
		}],
		gridLineWidth: 0, /* 기준선 grid 안보이기/보이기 */
		min: 0, /* 최소값 지정 */
		title: {
			text: '',
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		labels: {
			overflow: 'justify',
			x: -10, /* 그래프와의 거리 조정 */
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		}
	},
	legend: {
		enabled: true,
		align: 'right',
		verticalAlign: 'top',
		x: 5,
		y: -10,
		itemStyle: {
			color: 'var(--white60)',
			fontSize: '12px',
			fontWeight: 400
		},
		itemHoverStyle: {
			color: '' /* 마우스 오버시 색 */
		},
		symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
		symbolHeight: 7 /* 심볼 크기 */
	},
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				let suffix = point.series.userOptions.tooltip.valueSuffix;
				return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(point.y) + suffix;
			}, '<b>' + this.x + '</b>');
		},
		shared: true, /* 툴팁 공유 */
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--white87)'
		}
	},
	plotOptions: {
		series: {
			label: {
				connectorAllowed: true
			},
			borderWidth: 0,
        	borderColor: 'transparent'
		},
		bar: {
			dataLabels: {
				enabled: true,
				// inside: true, /* 막대 안으로 라벨 수치 넣기 */
				// format: '{y} kWh', /* 단위 넣기 */
				style: {
					color: 'var(--white87)',
					fontSize: '12px',
					fontWeight: 400,
					textOutline: 0,
					textShadow: true,
					
				},
				formatter: function () {
					if (String(this.y).length > 3) {
						return numberComma((this.y / 1000).toFixed(2)) + 'MWh';
					} else {
						return numberComma(this.y) + 'kWh';
					}
				}
			},
		},
		pointWidth: 15, /* 막대 두께 */
		groupPadding: 0.1,
		pointPadding: 0
	},
	credits: {
		enabled: false
	}
});

//알람이력
const getAlarmInfo = function () {
	const formData = getSiteMainSchCollection('day');
	let siteArray = new Array();

	siteList.forEach(site => {
		siteArray.push(site.sid);
	});

	$.ajax({
		url: apiHost + '/alarms',
		type: 'get',
		data: {
			sids: siteArray.join(','),
			startTime: formData.startTime,
			endTime: formData.endTime,
			confirm: false
		},
	}).done(function (data, textStatus, jqXHR) {
		//localtime 오름차순 정렬
		data.sort((a, b) => {
			return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
		});

		//데이터 세팅
		let alarmList = new Array();
		data.forEach((element, index) => {
			if(element.level != 0) {
				let localTime = (element.localtime != null && element.localtime != '') ? String(element.localtime) : '';
				data[index].standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
				alarmList.push(element);
			}
		});

		$('.alarm-alert').find('em').text(alarmList.length);
		setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}}); //list생성
	}).fail(function (jqXHR, textStatus, errorThrown) {
		console.error(jqXHR);
		console.error(textStatus);
		console.error(errorThrown);

		alert('처리 중 오류가 발생했습니다.');
		return false;
	})
}

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

const beforeTodayTotal = function () {
	let countPromise = 0;
	siteList.forEach((site, siteIdx) => {
		beforeTodayTotalPromise(site).then(rtnValue => {
			siteList[siteIdx]['acPowerSum'] = rtnValue.acPowerSum;
			siteList[siteIdx]['capacity'] = rtnValue.capacity;
			countPromise++;
		}).catch(error => {
			siteList[siteIdx]['acPowerSum'] = 0;
			siteList[siteIdx]['capacity'] = 0;
			countPromise++;
		}).finally(() => {
			if(siteList.length == countPromise) {
				getTodayTotalDetail();

				let siteArray = new Array();
				siteList.forEach(site => {
					siteArray.push(site.sid);
				});

				$.ajax({
					url: apiHost + '/energy/now/sites',
					type: 'get',
					async: false,
					data: {
						sids: siteArray.join(','),
						metering_type: '2',
						interval: 'day'
					}
				}).done(function (data, textStatus, jqXHR) {
					let resultData = data.data;
					siteList.forEach((site, siteIdx) => {
						let siteId = site.sid,
							idx = siteIdx;

						$.map(resultData, function (el, key) {
							if (siteId == key) {
								if (isEmpty(el)) {
									siteList[idx].accumulate = 0;
								} else {
									siteList[idx].accumulate = el.energy;
								}
							}
						});
					});
				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.error(jqXHR);
					console.error(textStatus);
					console.error(errorThrown);
				});

				siteList.sort(
					firstBy(function(a, b) {return Number(b['accumulate']) - Number(a['accumulate']);})
					.thenBy(function(a, b) {return Number(b['capacity']) - Number(a['capacity']);})
				);

				if (first) {
					getYearGenData();
					getDailyGenData();
					getGenDataBySiteYesterday();
					searchSiteList();
				}
			}
		});
	});
}

const firstBy = (function() {
	function extend(f) {
		f.thenBy = tb;
		return f;
	}

	function tb(y) {
		var x = this;
		return extend(function(a, b) {
			return x(a, b) || y(a, b);
		});
	}
	return extend;
})();

const beforeTodayTotalPromise = (site) => {
	return new Promise((resolve, reject) => {
		$.ajax({
			url: apiHost + '/status/raw/site',
			type: 'get',
			data: {
				sid: site.sid,
				formId: 'v2'
			},
		}).done(function (data, textStatus, jqXHR) {
			let acPowerSum = null,
				capacity = 0;

			let resolveObj = new Object();

			$.map(data, function (val, key) {
				if (oid.match('testkpx')) {
					if (key == 'KPX_EMS') {
						if (!isEmpty(val.activePower)) {
							acPowerSum += val.activePower;
						}

						if (!isEmpty(val.capacity)) {
							capacity += val.capacity;
						}

						if ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < val.timestamp)) {
							const dbTime = new Date(val.timestamp);
							$('.dbTime').data('timestamp', val.timestamp).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
						}
					}
				} else {
					if (key.match('INV')) {
						if (!isEmpty(val.activePower)) {
							acPowerSum += val.activePower;
						}

						if (!isEmpty(val.capacity)) {
							capacity += val.capacity;
						}

						if ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < val.timestamp)) {
							const dbTime = new Date(val.timestamp);
							$('.dbTime').data('timestamp', val.timestamp).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
						}
					}
				}
			});

			resolveObj['acPowerSum'] = acPowerSum;
			resolveObj['capacity'] = capacity;
			resolve(resolveObj);
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	});
}


const getTodayTotalDetail = async function () {

	$('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(1) span').text(0);
	$('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(2) span').text(0);

	const formData = getSiteMainSchCollection('day');
	if (!oid.match('testkpx')) {
		$('#centerTbody tr td:nth-child(1)').html(Math.floor(siteList.length) + '<em>&nbsp;&nbsp;개소</em>');
		$('#centerTbody tr td:nth-child(2)').text('');
		$('#centerTbody tr td:nth-child(3)').text('');
		$('#centerTbody tr td:nth-child(4)').text('');
		$('#centerTbody tr td:nth-child(5)').text('');
	} else {
		$('#centerTbody tr:eq(0) td:nth-child(2)').text(' - ');
		$('#centerTbody tr:eq(0) td:nth-child(3)').text(' - ');
		$('#centerTbody tr:eq(0) td:nth-child(5)').text(' - ');
		$('#centerTbody tr:eq(0) td:nth-child(6)').text(' - ');

		$('.gmain-chart-kpx .chart-box .chart-info .chart-info-right ul li:nth-child(1) span').text('')
		$('.gmain-chart-kpx .chart-box .chart-info .chart-info-right ul li:nth-child(2) span').text('')
		$('.gmain-chart-kpx .chart-box .chart-info .chart-info-right ul li:nth-child(3) span').text('')
	}

	let deviceArray = new Array();
	let capacity = 0;
	let acPower = 0;
	siteList.forEach((site, siteIdx) => {
		capacity += site.capacity;
	});

	siteList.forEach((site, siteIdx) => {
		const devices = site.devices;
		const resourceType = site.resource_type;
		devices.forEach(device => {
			let did = device.did;
			if (device.device_type !== 'KPX_EMS') {
				return false;
			}
			$.ajax({
				url: apiHost + '/status/raw',
				type: 'get',
				async: false,
				data: {
					dids: device.did
				},
			}).done(function (data, textStatus, jqXHR) {
				const rtnData = data[did].data;

				let reacPower = 0;
				let maxacPower = 0;
				rtnData.forEach(di => {
					let aPower = di.activePower;
					let tPower = di.targetActivePower;
					let prevVal1 = Number($('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(1) span').text().replace(/[^0-9]/g, ''));
					$('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(1) span').text(numberComma(Math.floor(prevVal1 += (aPower / 1000))));
					let prevVal2 = Number($('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(2) span').text().replace(/[^0-9]/g, ''));
					$('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(2) span').text(numberComma(Math.floor(prevVal2 += (tPower / 1000))));

					let prevVal3 = Number($('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(3) span').text().replace(/[^0-9]/g, ''));
					$('.gmain-chart4 .chart-box .chart-info .chart-info-right ul li:nth-child(3) span').text(numberComma(Math.floor(prevVal3 += (capacity / 1000))));

					if (resourceType == 1) {
						deviceArray.push({
							color: 'var(--circle-solar-power)',
							name: '태양광',
							dataLabels: {
								enabled: false
							},
							y: Math.floor((aPower / capacity) * 100)
						})
					} else {
						deviceArray.push({
							color: 'var(--blueberry)',
							name: '풍력',
							dataLabels: {
								enabled: false
							},
							y: Math.floor((aPower / capacity) * 100)
						})
					}
					acPower += aPower;
				});

				if (resourceType == 1) {
					let sitePreVal = Number($('#centerTbody tr:eq(0) td:nth-child(5)').text().replace(/[^0-9]/g, ''));
					let capacityPreVal = Number($('#centerTbody tr:eq(0) td:nth-child(6)').text().replace(/[^0-9]/g, ''));

					$('#centerTbody tr:eq(0) td:nth-child(4)').html('태양광'); //구분
					$('#centerTbody tr:eq(0) td:nth-child(5)').html(sitePreVal + 1 + '<em>&nbsp;&nbsp;개소</em>'); //사업소
					$('#centerTbody tr:eq(0) td:nth-child(6)').html(numberComma(Math.floor(capacityPreVal += (site.capacity / 1000)) + '<em>&nbsp;&nbsp;kW</em>')); //설비용량
				} else if (resourceType == 2) {
					let sitePreVal = Number($('#centerTbody tr:eq(0) td:nth-child(2)').text().replace(/[^0-9]/g, ''));
					let capacityPreVal = Number($('#centerTbody tr:eq(0) td:nth-child(3)').text().replace(/[^0-9]/g, ''));
					$('#centerTbody tr:eq(0) td:nth-child(1)').html('풍력'); //구분
					$('#centerTbody tr:eq(0) td:nth-child(2)').html(sitePreVal + 1 + '<em>&nbsp;&nbsp;개소</em>'); //사업소
					$('#centerTbody tr:eq(0) td:nth-child(3)').html(numberComma(Math.floor(capacityPreVal += (site.capacity / 1000)) + '<em>&nbsp;&nbsp;kW</em>')); //설비용량
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		});
	});

	pieChart.setTitle({text: Math.floor(acPower / 1000) + 'kW'});
	let usage = Math.floor((acPower / capacity) * 100);
	let other = 100 - usage;

	deviceArray.push({
		color: 'var(--grey)',
		name: '미사용량',
		dataLabels: {
			enabled: false
		},
		y: other
	});

	let seriesData = {
		type: 'pie',
		innerSize: '70%',
		name: '발전량',
		colorByPoint: true,
		data: deviceArray
	};

	let seriesLength = pieChart.series.length;
	for (let i = seriesLength - 1; i > -1; i--) {
		pieChart.series[i].remove();
	}

	pieChart.addSeries(seriesData, false);
	pieChart.redraw();
}

var pieChart = Highcharts.chart('pie_chart', {
	chart: {
		marginTop: 0,
		marginLeft: 0,
		marginRight: 0,
		backgroundColor: 'transparent',
		zoomType: 'xy',
		plotBorderWidth: 0,
		plotShadow: false,
		height: 180
	},
	navigation: {
		buttonOptions: {
			enabled: false /* 메뉴 안보이기 */
		}
	},
	title: {
		text: '- kW', // 총용량 표기
		align: 'center',
		verticalAlign: 'middle',
		y: 10,
		x: 0,
		style: {
			fontSize: '14px',
			color: 'var(--white60)'
		}
	},
	subtitle: {
		text: ''
	},
	credits: {
		enabled: false
	},
	tooltip: {
		shared: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--white87)'
		},
		valueSuffix: ' kwh',
		pointFormat: '<b>{point.percentage:.0f}%</b>'
	},
	plotOptions: {
		pie: {
			dataLabels: {
				enabled: false,
				style: {
					fontWeight: 'bold',
					color: 'var(--white87)'
				}
			},
			center: ['40%', '50%'],
			borderWidth: 0,
			size: '100%'
		}
	},
	series: [{
		type: 'pie',
		innerSize: '70%',
		name: '발전량',
		colorByPoint: true,
		data: [{
			color: 'var(--circle-solar-power)',
			name: '태양광',
			dataLabels: {
				enabled: false
			},
			y: 60 //60% -- 아래로 총합 100%
		}, {
			color: 'var(--grey)',
			name: '미사용량',
			dataLabels: {
				enabled: false
			},
			y: 20 //20% 나머지
		}]
	}],
	responsive: { // 반응형
		rules: [{
			condition: {
				maxWidth: 768
			},
			chartOptions: {
				plotOptions: {
					pie: {
						center: ['50%', '50%']
					}
				}
			}
		}]
	}
});

//우측 사이트 리스트 세팅
let siteListNow = false;
let siteListAlarm = false;
let siteListForeCnt = 0;
let siteListWeatherCnt = 0;
let siteListActive = 0;
const searchSiteList = async function () {
	const formData = getSiteMainSchCollection('day');
	let siteArray = new Array();

	siteListNow = false;
	siteListAlarm = false;
	siteListForeCnt = 0;
	siteListWeatherCnt = 0;
	siteListActive = 0;

	siteList.forEach((site, siteIdx) => {
		let inverterCount = 0;
		if (site.devices != undefined) {
			site.devices.forEach(device => {
				if (device.device_type.match('INV')) {
					inverterCount++;
				}
			});
		}

		siteList[siteIdx].inverterCount = inverterCount;
		siteArray.push(site.sid);

		$.ajax({
			url: apiHost + '/energy/forecasting/sites',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		}).done(function (data, textStatus, jqXHR) {
			let resultData = data.data[0];
			let siteForeGenSum = 0;
			$.map(resultData, function (val, key) {
				if (key == 'generation') {
					if (val.items.length > 0) {
						$.each(val.items, function (i, element) {
							if (element.energy != null && element.energy != '') {
								siteForeGenSum += element.energy;
							}
						});
					}
				}
			});

			if (siteForeGenSum == 0) {
				siteList[siteIdx].forecast = '-';
			} else {
				siteList[siteIdx].forecast = displayNumberFixedUnit(siteForeGenSum, 'Wh', 'kWh', 0)[0];
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		}).always(function (jqXHR, textStatus) {
			setSiteList('fore');
		});

		$.ajax({
			url: apiHost + '/status/raw/site',
			type: 'get',
			data: {
				sid: site.sid,
				formId: 'v2'
			},
		}).done(function (data, textStatus, jqXHR) {
			if (isEmpty(data)) {
				siteList[siteIdx].activePower = '-';
				siteList[siteIdx].irradiationPoa = '-';
				siteList[siteIdx].operation = new Array();
			} else {
				let siteOperation = new Array();
				let activePower = '-';
				let irradiationPoa = '-';
				$.map(data, function (val, key) {
					if ($.inArray(val.operation, siteOperation) === -1) {
						if (val.operation != undefined) {
							siteOperation.push(val.operation);
						}
					}
					if (key == 'INV_PV') {
						activePower = displayNumberFixedUnit(val.activePower, 'W', 'kW', 0)[0];
					} else if (key == 'SENSOR_SOLAR') {
						if (isEmpty(val)) {
							irradiationPoa = '-';
						} else {
							irradiationPoa = val.irradiationPoa.toFixed(1);
						}
					}
				});

				siteList[siteIdx].operation = siteOperation;
				siteList[siteIdx].activePower = activePower;
				siteList[siteIdx].irradiationPoa = irradiationPoa;
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		}).always(function (jqXHR, textStatus) {
			setSiteList('active');
		});
	});

	siteList.forEach((site, siteIdx) => {
		$.ajax({
			url: apiHost + '/weather/site',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'hour'
			},
		}).done(function (data, textStatus, jqXHR) {
			let dummy = new Array();
			$.each(data, function (i, el) {
				if (el.observed) {
					dummy.push(el)
				}
			});

			if (dummy.length == 0) {
				siteList[siteIdx].temperature = '- °C';
				siteList[siteIdx].humidity = '- %';
			} else {
				siteList[siteIdx].temperature = dummy[dummy.length - 1].temperature + ' °C';
				siteList[siteIdx].humidity = dummy[dummy.length - 1].humidity + ' %';
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		}).always(function (jqXHR, textStatus) {
			setSiteList('weather');
		});
	})


	$.ajax({
		url: apiHost + '/energy/now/sites',
		type: 'get',
		data: {
			sids: siteArray.join(','),
			metering_type: '2',
			interval: 'day'
		}
	}).done(function (data, textStatus, jqXHR) {
		let resultData = data.data;
		siteList.forEach((site, siteIdx) => {
			let siteId = site.sid,
				idx = siteIdx;

			$.map(resultData, function (el, key) {
				if (siteId == key) {
					if (isEmpty(el)) {
						siteList[idx].accumulate = 0;
					} else {
						siteList[idx].accumulate = el.energy;
					}
				}
			});
		});
	}).fail(function (jqXHR, textStatus, errorThrown) {
		console.error(jqXHR);
		console.error(textStatus);
		console.error(errorThrown);
	}).always(function (jqXHR, textStatus) {
		setSiteList('now');
	});

	$.ajax({
		url: apiHost + '/alarms',
		type: 'get',
		data: {
			sids: siteArray.join(','),
			startTime: formData.startTime,
			endTime: formData.endTime,
			confirm: false
		},
	}).done(function (data, textStatus, jqXHR) {
		siteList.forEach((site, siteIdx) => {
			let siteId = site.sid,
				alarmWarning = 0,
				alarmError = 0;

			data.forEach(alarm => {
				if (siteId == alarm.sid) {
					if (alarm.level == 0 || alarm.level == 1 || alarm.level == 9) {
						alarmWarning++;
					} else {
						alarmError++;
					}
				}
			});

			siteList[siteIdx].alarmWarning = alarmWarning;
			siteList[siteIdx].alarmError = alarmError;
			siteList[siteIdx].alarmTotal = alarmError + alarmWarning;
		});
	}).fail(function (jqXHR, textStatus, errorThrown) {
		console.error(jqXHR);
		console.error(textStatus);
		console.error(errorThrown);

		alert('처리 중 오류가 발생했습니다.');
		return false;
	}).always(function (jqXHR, textStatus) {
		setSiteList('alarm');
	});
}


/**
 * 오른쪽 사이트 리스트 세팅
 *
 * @param type
 */
const setSiteList = function (type) {
	if (type == 'now') {
		siteListNow = true;
	} else if (type == 'weather') {
		siteListWeatherCnt++;
	} else if (type == 'fore') {
		siteListForeCnt++;
	} else if (type == 'active') {
		siteListActive++;
	} else if (type == 'alarm') {
		siteListAlarm = true;
	}

	if (siteListNow && siteListAlarm && siteListForeCnt == siteList.length && siteListWeatherCnt == siteList.length && siteListActive == siteList.length) {
		searchSite();
	}
}

/**
 * 사이트명 && 작동상태로 검색 기능 작동
 */
const searchSite = function () {
	let searchName = $('#searchName').val().trim();
	let deviceStatus = $.makeArray($(':checkbox[name="deviceStatus"]:checked').map(function () {
			return $(this).val();
		})
	);

	let refineList = new Array();
	siteList.forEach((site, siteIdx) => {
		if (!isEmpty(searchName)) {
			if ((site.name.toUpperCase()).match(searchName.toUpperCase()) || (site.address.toUpperCase()).match(searchName.toUpperCase())) {
				if (deviceStatus.length == 3) {
					refineList.push(site);
				} else {
					deviceStatus.some(status => {
						if(site.operation[0] == undefined){
							site.operation.push(0);
						}
						if ($.inArray(Number(status), site.operation) != -1) {
							return refineList.push(site);
						}
					});
				}
			}
		} else {
			if (deviceStatus.length == 3) {
				refineList.push(site);
			} else {
				deviceStatus.some(status => {
					if(site.operation[0] == undefined){
						site.operation.push(0);
					}
					if ($.inArray(Number(status), site.operation) != -1) {
						return refineList.push(site);
					}
				});
			}
		}
	});

	refineList.forEach((site, siteIdx) => {
		siteList[siteIdx].resourceClass = resourceIcon(site.resource_type);

		if (oid.match('testkpx')) {
			const devices = site.devices;
			let deviceArray = new Array();
			devices.forEach(device => {
				if (device.device_type === 'KPX_EMS' || device.device_type === 'SENSOR_WEATHER') {
					deviceArray.push(device.did);
				}
			});

			$.ajax({
				url: apiHost + '/status/raw',
				type: 'get',
				async: false,
				data: {
					dids: deviceArray.join(',')
				},
			}).done(function (data, textStatus, jqXHR) {
				Object.entries(data).map(obj => {
					let deviceData = obj[1].data;
					let deviceType = obj[1].device_type;

					if (deviceType == 'KPX_EMS') {
						deviceData.forEach(di => {
							refineList[siteIdx].activePower = numberComma(di.activePower / 1000);
							refineList[siteIdx].reactivePower = numberComma(di.reactivePower / 1000);
							refineList[siteIdx].essActivePower = numberComma(di.essDActivePower - di.essCActivePower / 1000);
							refineList[siteIdx].maxActivePower = numberComma(di.maxActivePower / 1000);
							refineList[siteIdx].essMaxActivePower = numberComma(di.essMaxActivePower / 1000);
							refineList[siteIdx].essMinActivePower = numberComma(di.essMinActivePower / 1000);
							refineList[siteIdx].essSoc = numberComma(di.essSoc / 1000);

							let temperature = isEmpty(di.temperature) ? '-' : di.temperature;
							let irradiationPoa = isEmpty(di.irradiationPoa) ? '-' : di.irradiationPoa;
							let humidity = isEmpty(di.humidity) ? '-' : di.humidity;

							refineList[siteIdx].temperature = temperature + ' °C';
							refineList[siteIdx].irradiationPoa = irradiationPoa + ' W/㎡';
							refineList[siteIdx].humidity = humidity + ' %';

							let lastTargetActivePowerReqDate = String(di.lastTargetActivePowerReqDate);
							let lastTargetActivePowerRecvDate = String(di.lastTargetActivePowerReqDate);
							let targetActivePower = di.targetActivePower;
							let rtus = new Array();
							siteList.forEach(siteRtu => {
								if (site.sid == siteRtu.sid) {
									if (!isEmpty(siteRtu.rtus)) {
										siteRtu.rtus.forEach(rtu => {
											rtus.push(rtu.rid);
										})
									}
								}
							});

							let statusClass = 'status-drv';
							$.ajax({
								url: apiHost + '/control/command_history',
								type: 'get',
								async: false,
								data: {
									oid: oid,
									rids: rtus.join(','),
									cmdTypes: 'kpx_targetPower',
									isRecent: true
								},
							}).done(function (data, textStatus, jqXHR) {
								if (!isEmpty(data.data)) {
									if (isEmpty(lastTargetActivePowerReqDate)) {
										lastTargetActivePowerReqDate = String(data.data[0].requested_at);
									} else {
										let statusDate = new Date(lastTargetActivePowerReqDate.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$2/$3/$1 $4:$5:$6'));
										let hitoryDate = new Date(data.data[0].requested_at.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$2/$3/$1 $4:$5:$6'));
										if (statusDate.getTime() < hitoryDate.getTime()) {
											lastTargetActivePowerReqDate = hitoryDate.format('yyyyMMddHHmmss');
											lastTargetActivePowerRecvDate = '-'
											const cmdBody = JSON.parse(data.data[0].cmd_body);
											targetActivePower = cmdBody.targetPower;

											let diffTime = Math.floor(((new Date() - hitoryDate) / 1000) / 60 / 60 % 24);
											if (diffTime >= 1) {
												statusClass = 'status-error';
											}
										}
									}
								}
							});


							const operation = site.operation;
							let dateLocal = new Date(String(di.localtime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$2-$3-$3 $4:$5:$6'));
							let diffTime = Math.floor(((new Date() - dateLocal) / 1000) / 60 / 60 % 24);
							if (diffTime >= 1) {
								statusClass = 'status-error';
							} else {
								if (operation.includes('0')) {
									refineList[siteIdx].status = '중지';
									statusClass = 'status-stop';
								} else if (operation.includes('1')) {
									refineList[siteIdx].status = '정상';
									statusClass = 'status-drv';
								} else if (operation.includes('2')) {
									refineList[siteIdx].status = '트립';
									statusClass = 'status-error';
								} else {
									refineList[siteIdx].status = '에러';
									statusClass = 'status-error';
								}
							}

							refineList[siteIdx].statusClass = statusClass;
							refineList[siteIdx].statusLocalTime = String(di.localtime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
							refineList[siteIdx].targetActivePower = numberComma(targetActivePower / 1000);
							refineList[siteIdx].lastTargetActivePowerReqDate = String(lastTargetActivePowerReqDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
							if (lastTargetActivePowerRecvDate != '-') {
								refineList[siteIdx].lastTargetActivePowerRecvDate = String(lastTargetActivePowerRecvDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
							} else {
								refineList[siteIdx].lastTargetActivePowerRecvDate = lastTargetActivePowerRecvDate
							}
						});
					}
				});

			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});


		} else {
			if(typeof site.accumulate !== 'string') {
				if (site.accumulate == 0) {
					refineList[siteIdx].accumulate = '-';
				} else {
					refineList[siteIdx].accumulate = displayNumberFixedUnit(site.accumulate, 'Wh', 'kWh', 0)[0];
				}
			}
		}
	});

	setMakeList(refineList, 'siteList', {'dataFunction': {'align': alignFunc, 'capacity': setUnit}}); //list생성

	if (typeof (geocodeAddress) == 'function') {
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

			refineList.forEach((site, idx) => {
				if (site.latlng != null) {
					let operationColor = '#90caf3';
					if(site.operation == '0') {
						operationColor = '#f2a363';
					} else if(site.operation == '1') {
						operationColor = '#90caf3';
					} else {
						operationColor = '#e97373';
					}

					geocodeAddress(site.address, site.sid, site.name, site.latlng, operationColor);
				} else {
					makerObject[site.sid] = new Object();
				}
			});
		}
	}

	setTimeout(function () {
		refineList.forEach((site, siteIdx) => {
			let capacity = (site.targetActivePower == '-' || site.targetActivePower == 0) ? 0 : site.targetActivePower * 1000;
			let activePower = (site.activePower == '-' || site.activePower == 0) ? 0 : Number(site.activePower.replace(/[^0-9]/g, ''));

			let activePercent = 0;
			let title = '';
			if (capacity == 0) {
				title = '- %';
			} else {
				activePercent = Math.floor((activePower / capacity) * 100);
				title = activePercent + '%';
				if (isNaN(activePercent)) {
					title = '- %';
				}
			}

			let etc = 100 - activePercent;
			let series = [{
				type: 'pie',
				innerSize: '50%',
				name: '설비용량',
				colorByPoint: true,
				data: [{
					color: 'var(--turquoise)',
					name: '유효전력',
					dataLabels: {
						enabled: false
					},
					y: activePercent
				}, {
					color: 'var(--grey)',
					name: '목표전력',
					dataLabels: {
						enabled: false
					},
					y: etc //30% 나머지
				}]
			}];

			siteListChart('type_chart' + siteIdx, series, title);
		});
	}, 500);

	first = false;
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

const setUnit = (capacity) => {
	return displayNumberFixedUnit(capacity, 'W', 'kW', 0)[0];
}

/**
 * 사업소 리스트에 배터리 용량 차트 그래프
 *
 * @param selector
 * @param seriesData
 */
const siteListChart = function (selector, seriesData, title) {
	let chartSelector = $('#' + selector).highcharts();
	if (chartSelector) {
		chartSelector.destroy();
	}

	let option = {
		chart: {
			marginTop: -50,
			marginLeft: 0,
			marginRight: 0,
			// marginBottom: 20,
			backgroundColor: 'transparent',
			renderTo: selector,
			plotBorderWidth: 0,
			plotShadow: false,
			// height: 190
		},
		navigation: {
			buttonOptions: {
				enabled: false /* 메뉴 안보이기 */
			}
		},
		title: {
			text: title, // %표기
			align: 'center',
			verticalAlign: 'middle',
			// x: 0,
			// y: 32,
			// y: 200,
			style: {
				fontSize: '14px',
				color: 'var(--white60)'
			}
		},
		subtitle: {
			text: ''
		},
		/* 출처 */
		credits: {
			enabled: false
		},
		tooltip: {
			pointFormat: '<b>{point.percentage:.0f}%</b>'
		},
		plotOptions: {
			pie: {
				dataLabels: {
					enabled: false,
					style: {
						fontWeight: 'bold',
						color: 'var(--white87)'
					}
				},
				startAngle: -90,
				endAngle: 90,
				center: ['50%', '72%'],
				borderWidth: 0,
				size: '100%'
			}
		},
		series: seriesData,
		responsive: {
			rules: [
				{
					condition: {
						maxWidth: 992,
					},
					chart: {
						marginTop: -20,
						// marginBottom: -90
					}
				}
			]
		}
	}

	chartSelector = new Highcharts.Chart(option);
	chartSelector.redraw();
}

$(document).ready(function () {
	// 모든 table 헤더에 클릭 이벤트를 설정한다.
	var tables = document.getElementsByTagName("table");
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
							headers[k].getElementsByTagName('button')[0].classList.remove('up');
							headers[k].getElementsByTagName('button')[0].classList.remove('down');
						}
					}
					SortTable(table, n, sort)
				};
			}(tables[i], j));
		}
	}
});

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
	for (var i = 0; i < rows.length; ++i) {
		let flag = rows[i].classList[1];
		tbody.appendChild(rows[i]);

		for (var j = 0; j < rows2.length; j++) {
			if (rows2[j].classList.contains(flag)) {
				tbody.appendChild(rows2[j]);
			}
		}
	}
}

const makeSiteList = () => {
	let ess = false;
	siteList.forEach(site => {
		if (site.devices != null) {
			const devices = site.devices;
			devices.forEach(device => {
				// console.log(device.device_type);
				if ((device.device_type.toUpperCase()).match('ESS')) {
					ess = true;
				}
			});
		}
	});

	if (!ess) {
		$('#statusSiteList').find('.ESS').remove();
	}

	setInitList('siteList'); //사이트 리스트
}

// 특수문자 정규식 변수(공백 미포함)
const replaceChar = /[~!@\#$%^&*\()\-=+_'\;<>\/.\`:\"\\,\[\]?|{}]/gi;

// 완성형 아닌 한글 정규식
const replaceNotFullKorean = /[ㄱ-ㅎㅏ-ㅣ]/gi;

$(document).ready(function(){

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