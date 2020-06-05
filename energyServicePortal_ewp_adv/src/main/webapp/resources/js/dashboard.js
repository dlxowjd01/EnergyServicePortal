//대시보드 먼슬리 && 데일리 차트 시리증 설정.
const seriesArray = [
	{name: '충전', type: 'column', color: '#2BEEE9', data: 'chargeList', suffix: 'kWh'},
	{name: '방전', type: 'column', color: '#878787', data: 'dischargeList', suffix: 'kWh'},
	{name: '태양광', type: 'column', color: '#9363FD', data: 'pvList', suffix: 'kWh'},
	{name: '정산금', type: 'spline', color: 'var(--color3)', data: 'payList', suffix: '천원'},
];

const sitePieSeries = [
	{color: '#26ccc8', name: '총 설비용량'},
	{color: '#84848f', name: '미설비용량'}
];

const keyArray = ['battery', 'generation'];

let monthlyBefore = 0;
let monthlyNow = 0;

let dailyBefore = 0;
let dailyNow = 0;

/**
 * 대쉬보드 먼슬리 차트 그리기
 */
const getYearGenData = function () {
	const formData = getSiteMainSchCollection('year');//api에 맞게 수정 필요

	monthlyBefore = 0;
	monthlyNow = 0;
	let chargeList = new Array(12).fill(0);
	let dischargeList = new Array(12).fill(0);
	let pvList = new Array(12).fill(0);
	let payList = new Array(12).fill(0);

	$(`.gmain_chart1 span.term`).text(today.getFullYear() + '.1.1 ~ ' + today.getFullYear() + '.' + (Number(today.getMonth()) + 1) + '.' + today.getDate());
	siteList.forEach(site => {
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/sites',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				displayType: 'dashboard',
				interval: 'month'
			}
		}).done(function (data, textStatus, jqXHR) {
			let resultData = data.data[0];
			$.map(resultData, function (val, key) {
				if ($.inArray(key, keyArray) >= 0) {
					if (key == 'battery') {
						$.map(val, function (el, k) {
							if (k == 'charging') {
								$.each(el.items, function (i, element) {
									const month = Number(String(element.basetime).slice(4, 6)) - 1;
									chargeList[month] += element.energy;
								});
							} else if (k == 'discharging') {
								$.each(el.items, function (i, element) {
									const month = Number(String(element.basetime).slice(4, 6)) - 1;
									dischargeList[month] += element.energy;
								});
							}
						});
					} else {
						if (val.items.length > 0) {
							$.each(val.items, function (i, element) {
								if (element.energy != null && element.energy != '') {
									const month = Number(String(element.basetime).slice(4, 6)) - 1;
									pvList[month] += Math.floor(element.energy / 1000);
									payList[month] += Math.floor(element.money / 1000);
								}
							});
						}
					}
				}
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function (jqXHR, textStatus) {
			monthlyChartDraw('before', chargeList, dischargeList, pvList, payList);
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/now/sites',
			type: 'get',
			data: {
				sids: site.sid,
				metering_type: 2,
				interval: 'month'
			}
		}).done(function (data, textStatus, jqXHR) {
			if (data.data[site.sid].energy) {
				const month = Number(data.data[site.sid].start.toString().slice(4, 6)) - 1;
				pvList[month] += Math.floor(data.data[site.sid].energy / 1000);
			}
			if (data.data[site.sid].money) {
				const month = Number(data.data[site.sid].start.toString().slice(4, 6)) - 1;
				payList[month] += Math.floor(data.data[site.sid].money / 1000);
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function (jqXHR, textStatus) {
			monthlyChartDraw('now', chargeList, dischargeList, pvList, payList);
		});
	});
}

const monthlyChartDraw = function (type, chargeList, dischargeList, pvList, payList) {
	if (type == 'before') {
		monthlyBefore++;
	} else {
		monthlyNow++;
	}

	if (monthlyBefore == siteList.length && monthlyNow == siteList.length) {
		let seriesLength = monthlyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			monthlyChart.series[i].remove();
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
			}

			chartSeries.tooltip = {valueSuffix: el.suffix}
			monthlyChart.addSeries(chartSeries, false);
		});

		monthlyChart.redraw(); // 차트 데이터를 다시 그린다
	}
}

const monthlyChart = Highcharts.chart('monthlyChart', {
	chart: {
		marginTop: 40,
		marginLeft: 55,
		marginRight: 50,
		height: 285,
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
		lineColor: 'var(--color1)', /* 눈금선색 */
		tickColor: 'var(--color1)',
		gridLineColor: 'var(--color1)',
		plotLines: [{
			color: 'var(--color1)',
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
				color: 'var(--color4)',
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
		lineColor: 'var(--color1)', /* 눈금선색 */
		tickColor: 'var(--color1)',
		gridLineColor: 'var(--color1)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--color1)',
			width: 1
		}],
		title: {
			text: 'kWh',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: 15,
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		},
		labels: {
			format: '{value}',
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		}
	}, { // Secondary yAxis
		lineColor: 'var(--color1)', /* 눈금선색 */
		tickColor: 'var(--color1)',
		gridLineColor: 'var(--color1)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--color1)',
			width: 1
		}],
		title: {
			text: '천원',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: -12,
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		},
		labels: {
			format: '{value}',
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		},
		opposite: true
	}],
	tooltip: {
		shared: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--color3)'
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
			color: 'var(--color2)',
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
			borderColor: 'var(--color2)',
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
	series: [{
		name: '충전',
		type: 'column',
		color: '#2BEEE9',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '방전',
		type: 'column',
		color: '#878787',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '태양광',
		type: 'column',
		color: '#9363FD',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '정산금',
		type: 'spline',
		color: 'var(--color3)',
		dashStyle: 'ShortDash',
		yAxis: 1,
		tooltip: {
			valueSuffix: '천원'
		}
	}],
	/* 출처 */
	credits: {
		enabled: false
	},
	/* 반응형 */
	responsive: {
		rules: [{ /* 차트 사이즈 - 4K용 */
			condition: {
				minWidth: 870,
			},
			chartOptions: {
				chart: {
					marginTop: 50,
					marginLeft: 75,
					marginRight: 75
				},
				xAxis: {
					labels: {
						style: {
							fontSize: '18px'
						}
					}
				},
				yAxis: [{
					title: {
						y: 30,
						x: 20,
						style: {
							fontSize: '18px'
						}
					},
					labels: {
						style: {
							fontSize: '18px'
						}
					}
				},
					{
						title: {
							y: 30,
							x: -15,
							style: {
								fontSize: '18px'
							}
						},
						labels: {
							style: {
								fontSize: '18px'
							}
						}
					}],
				legend: {
					itemStyle: {
						fontSize: '18px'
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

const getDailyGenData = function () {
	const today = new Date();
	const lastDay = new Date(today.getFullYear(), today.getMonth() + 2, 0);
	const formData = getSiteMainSchCollection("month");//api에 맞게 수정 필요

	dailyBefore = 0;
	dailyNow = 0;

	let chargeList = new Array(lastDay.getDate()).fill(0);
	let dischargeList = new Array(lastDay.getDate()).fill(0);
	let pvList = new Array(lastDay.getDate()).fill(0);
	let payList = new Array(lastDay.getDate()).fill(0);

	let categories = new Array();
	for (let i = 1; i <= lastDay.getDate(); i++) {
		categories.push(String(i));
	}

	$(`.gmain_chart2 span.term`).text(today.format('yyyy.MM') + '.1 ~ ' + today.format('yyyy.MM') + '.' + today.getDate());
	siteList.forEach(site => {
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/sites',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				displayType: 'dashboard',
				interval: 'day'
			}
		}).done(function (data, textStatus, jqXHR) {
			let resultData = data.data[0];
			$.map(resultData, function (val, key) {
				if ($.inArray(key, keyArray) >= 0) {
					if (key == 'battery') {
						$.map(val, function (el, k) {
							if (k == 'charging') {
								$.each(el.items, function (i, element) {
									const day = Number(String(element.basetime).slice(6, 8)) - 1;
									chargeList[day] += element.energy;
								});
							} else if (k == 'discharging') {
								$.each(el.items, function (i, element) {
									const day = Number(String(element.basetime).slice(6, 8)) - 1;
									dischargeList[day] += element.energy;
								});
							}
						});
					} else {
						if (val.items.length > 0) {
							$.each(val.items, function (i, element) {
								if (element.energy != null && element.energy != '') {
									const day = Number(String(element.basetime).slice(6, 8)) - 1;
									pvList[day] += Math.floor(element.energy / 1000);
									payList[day] += Math.floor(element.money / 1000);
								}
							});
						}
					}
				}
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function (jqXHR, textStatus) {
			dailyChartDraw('before', chargeList, dischargeList, pvList, payList, categories);
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/now/sites',
			type: 'get',
			data: {
				sids: site.sid,
				metering_type: 2,
				interval: 'day'
			}
		}).done(function (data, textStatus, jqXHR) {
			const day = Number(String(data.data[site.sid].start).slice(6, 8)) - 1;
			if (data.data[site.sid].energy) {
				pvList[day] += Math.floor(data.data[site.sid].energy / 1000);
			}
			if (data.data[site.sid].money) {
				payList[day] += Math.floor(data.data[site.sid].money / 1000);
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function (jqXHR, textStatus) {
			dailyChartDraw('now', chargeList, dischargeList, pvList, payList, categories);
		});
	});
}

const dailyChartDraw = function (type, chargeList, dischargeList, pvList, payList, categories) {
	if (type == 'before') {
		dailyBefore++;
	} else {
		dailyNow++;
	}

	if (dailyBefore == siteList.length && dailyNow == siteList.length) {
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
			}

			chartSeries.tooltip = {valueSuffix: el.suffix}
			dailyChart.addSeries(chartSeries, false);
		});

		dailyChart.xAxis[0].setCategories(categories);
		dailyChart.redraw(); // 차트 데이터를 다시 그린다
	}
}

const dailyChart = Highcharts.chart('dailyChart', {
	chart: {
		marginTop: 40,
		marginLeft: 50,
		marginRight: 50,
		height: 323,
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
		lineColor: 'var(--color1)', /* 눈금선색 */
		tickColor: 'var(--color1)',
		gridLineColor: 'var(--color1)',
		plotLines: [{
			color: 'var(--color1)',
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
				color: 'var(--color4)',
				fontSize: '12px'
			}
		},
		tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
		title: {
			text: null
		},
		categories: null,
		crosshair: true
	}],
	yAxis: [{ // Primary yAxis
		lineColor: 'var(--colo1)', /* 눈금선색 */
		tickColor: 'var(--colo1)',
		gridLineColor: 'var(--colo1)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--colo1)',
			width: 1
		}],
		title: {
			text: 'kWh',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: 15,
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		},
		labels: {
			format: '{value}',
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		}
	}, { // Secondary yAxis
		lineColor: 'var(--colo1)', /* 눈금선색 */
		tickColor: 'var(--colo1)',
		gridLineColor: 'var(--colo1)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--colo1)',
			width: 1
		}],
		title: {
			text: '천원',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: -12,
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		},
		labels: {
			format: '{value}',
			style: {
				color: 'var(--color4)',
				fontSize: '12px'
			}
		},
		opposite: true
	}],
	tooltip: {
		shared: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--color3)'
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
			color: 'var(--color4)',
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
			borderColor: 'var(--color2)',
			borderWidth: 0, /* 보더 0 */
			events: {
				legendItemClick: function () {
					console.log("this---", this);
					var visibility = this.visible ? 'visible' : 'hidden';
					this.legendItem.styles.color == 'var(--color4)'
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
	series: [{
		name: '충전',
		type: 'column',
		color: '#2BEEE9',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '방전',
		type: 'column',
		color: '#878787',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '태양광',
		type: 'column',
		color: '#9363FD',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '정산금',
		type: 'spline',
		color: 'var(--color3)',
		dashStyle: 'ShortDash',
		yAxis: 1,
		tooltip: {
			valueSuffix: '천원'
		}
	}],
	/* 출처 */
	credits: {
		enabled: false
	},
	/* 반응형 */
	responsive: {
		rules: [{
			condition: {
				minWidth: 870 /* 차트 사이즈 */
			},
			chartOptions: {
				chart: {
					marginTop: 50,
					marginLeft: 75,
					marginRight: 75
				},
				xAxis: {
					labels: {
						style: {
							fontSize: '18px'
						}
					}
				},
				yAxis: [{
					title: {
						y: 30,
						x: 20,
						style: {
							fontSize: '18px'
						}
					},
					labels: {
						style: {
							fontSize: '18px'
						}
					}
				},
					{
						title: {
							y: 30,
							x: -15,
							style: {
								fontSize: '18px'
							}
						},
						labels: {
							style: {
								fontSize: '18px'
							}
						}
					}],
				legend: {
					itemStyle: {
						fontSize: '18px'
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

let yesterDayGen = 0;
let yesterDayFore = 0;
const getGenDataBySiteYesterday = function () { //3번째 indiv 사업소별 탭
	const formData = getSiteMainSchCollection('yesterday');
	const yesterday = new Date();
	let siteGenArray = new Array(siteList.length).fill(0);
	let siteForeGenArray = new Array(siteList.length).fill(0);
	let categories = new Array();

	yesterDayGen = 0;
	yesterDayFore = 0;

	yesterday.setDate(Number(today.getDate()) - 1);

	$(`.gmain_chart3 span.term`).text(yesterday.getFullYear() + '.' + (Number(yesterday.getMonth()) + 1) + '.' + yesterday.getDate());
	siteList.forEach((site, siteIdx) => {
		let siteGenSum = 0;
		let siteForeGenSum = 0;

		categories.push(site.name);

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/sites',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		}).done(function (data, textStatus, jqXHR) {
			let resultData = data.data[0];
			$.map(resultData, function (val, key) {
				if (key == 'generation') {
					if (val.items.length > 0) {
						$.each(val.items, function (i, element) {
							if (element.energy != null && element.energy != '') {
								siteGenSum += element.energy;
							}
						});
					}
				}
			});

			siteGenSum = displayNumberFixedUnit(siteGenSum, 'Wh', 'kWh', 0)[0];
			siteGenArray[siteIdx] =parseFloat(siteGenSum);

			if (siteGenSum > 0) {
				siteList[siteIdx].beforeDay = siteGenSum;
			} else {
				siteList[siteIdx].beforeDay = '-';
			}

		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function (jqXHR, textStatus) {
			setGenDataBySiteYesterday('energy', siteGenArray, siteForeGenArray, categories);
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/forecasting/sites',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		}).done(function (data, textStatus, jqXHR) {
			let resultData = data.data[0];
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

			siteForeGenSum = displayNumberFixedUnit(siteForeGenSum, 'Wh', 'kWh', 0)[0];
			siteForeGenArray[siteIdx] = parseFloat(siteForeGenSum);
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function (jqXHR, textStatus) {
			setGenDataBySiteYesterday('fore', siteGenArray, siteForeGenArray, categories);
		});
	});
}

const setGenDataBySiteYesterday = function (type, siteGenArray, siteForeGenArray, categories) {

	if (type == 'energy') {
		yesterDayGen++;
	} else {
		yesterDayFore++;
	}

	if (yesterDayGen == siteList.length && yesterDayFore == siteList.length) {
		let seriesLength = typeSiteCurrent.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			typeSiteCurrent.series[i].remove();
		}

		typeSiteCurrent.addSeries({
			name: '발전',
			color: '#25CCC8',
			data: siteGenArray,
			tooltip: {
				valueSuffix: 'kWh'
			}
		});

		typeSiteCurrent.addSeries({
			name: '발전 예측',
			color: '#878787',
			data: siteForeGenArray,
			tooltip: {
				valueSuffix: 'kWh'
			}
		});

		//typeSiteCurrent.xAxis[0].categories = true;
		typeSiteCurrent.xAxis[0].setCategories(categories);
		typeSiteCurrent.redraw();

		setSiteList();
	}
}


const typeSiteCurrent = Highcharts.chart('typeSiteCurrent', {
	chart: {
		marginTop: 50,
		marginRight: 0,
		height: 355,
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
		lineColor: '#515562', /* 눈금선색 */
		tickColor: '#515562',
		gridLineColor: '#515562',
		plotLines: [{
			color: '#515562',
			width: 1
		}],
		labels: {
			align: 'left',
			reserveSpace: true,
			style: {
				color: '#a4aebf',
				fontSize: '12px'
			}
		},
		categories: null,
		title: {
			text: null
		}
	},
	yAxis: {
		lineColor: '#515562', /* 눈금선색 */
		tickColor: '#515562',
		gridLineColor: '#515562',
		plotLines: [{
			color: '#515562',
			width: 1
		}],
		gridLineWidth: 0, /* 기준선 grid 안보이기/보이기 */
		min: 0, /* 최소값 지정 */
		title: {
			text: '',
			style: {
				color: '#a4aebf',
				fontSize: '12px'
			}
		},
		labels: {
			overflow: 'justify',
			x: -10, /* 그래프와의 거리 조정 */
			style: {
				color: '#a4aebf',
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
			color: '#a4aebf',
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
		shared: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--color3)'
		},
		valueSuffix: ' kwh'
	},
	plotOptions: {
		series: {
			label: {
				connectorAllowed: true
			},
			borderWidth: 0, /* 보더 0 */
			borderRadiusTopLeft: 2, /* 막대 모서리 둥글게 효과 */
			borderRadiusTopRight: 2, /* 막대 모서리 둥글게 효과 */
			pointWidth: 10, /* 막대 두께 */
			pointPadding: 6 /* 막대 사이 간격 */
		},
		bar: {
			dataLabels: {
				enabled: true,
				inside: true, /* 막대 안으로 라벨 수치 넣기 */
				format: '{y} kWh', /* 단위 넣기 */
				style: {
					color: '#ffffff',
					fontSize: '11px',
					fontWeight: 400
				}
			}
		}
	},
	credits: {
		enabled: false
	},
	responsive: {
		rules: [{
			condition: {
				maxWidth: 414 /* 차트 사이즈 */
			},
			chartOptions: {
				xAxis: {
					labels: {
						style: {
							fontSize: '12px'
						}
					}
				}
			}
		}],
		rules: [{
			condition: {
				minWidth: 842 /* 차트 사이즈 */
			},
			chartOptions: {
				xAxis: {
					labels: {
						style: {
							fontSize: '18px'
						}
					}
				},
				yAxis: {
					labels: {
						style: {
							fontSize: '18px'
						}
					}
				},
				legend: {
					itemStyle: {
						fontSize: '18px'
					},
					symbolPadding: 5,
					symbolHeight: 10
				},
				plotOptions: {
					series: {
						pointWidth: 8,
						pointPadding: 0.25 /* 막대 사이 간격 */
					},
					bar: {
						dataLabels: {
							style: {
								fontSize: '13px'
							}
						}
					}
				}
			}
		}]
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
		url: 'http://iderms.enertalk.com:8443/alarms',
		type: 'get',
		data: {
			sids: siteArray.join(','),
			startTime: formData.startTime,
			endTime: formData.endTime,
			confirm: false
		},
	}).done(function (data, textStatus, jqXHR) {

		$('.a_alert').find('em').text(data.length);

		//localtime 오름차순 정렬
		data.sort((a, b) => {
			return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
		});

		//데이터 세팅
		data.forEach((element, index) => {
			let localTime = (element.localtime != null && element.localtime != '') ? String(element.localtime) : '';
			data[index].standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
		});

		setMakeList(data, 'alarmNotice', {'dataFunction': {}}); //list생성
	}).fail(function (jqXHR, textStatus, errorThrown) {
		console.error(jqXHR);
		console.error(textStatus);
		console.error(errorThrown);

		alert('처리 중 오류가 발생했습니다.');
		return false;
	})
}

let toDayEnergy = 0;
let toDayRaw = 0;
const getTodayTotalDetail = function () {

	$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(0);
	$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text(0);

	const formData = getSiteMainSchCollection('day');
	$('#centerTbody tr td:nth-child(1) span').text(Math.floor(siteList.length));
	$('#centerTbody tr td:nth-child(2) span').text('');
	$('#centerTbody tr td:nth-child(3) span').text('');
	$('#centerTbody tr td:nth-child(4) span').text('');
	$('#centerTbody tr td:nth-child(5) span').text('');

	let acPowerSum = 0;
	let co2Sum = 0;

	toDayEnergy = 0;
	toDayRaw = 0;

	let capacity = 0;
	siteList.forEach((site, siteIdx) => {
		if (site.devices != undefined) {
			site.devices.forEach(device => {
				capacity += device.capacity;
			});
		}
	});

	siteList.forEach((site, siteIdx) => {
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/sites',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: '15min'
			},
		}).done(function (data, textStatus, jqXHR) {
			let generationSum = 0;
			let moneySum = 0;
			data.data[0].generation.items.map((e) => {
				generationSum += e.energy;
			});
			data.data[0].generation.items.map((e) => moneySum += e.money);

			pieChart.series[0].data.forEach((e, idx) => {
				if (e.name === '태양광') {
					e.update({y: Math.floor(generationSum / 100)});
				} else if (e.name === '미사용량') {
					e.update({y: Math.floor((generationSum / capacity) / 100)});
				} else {
					e.update({y: 0});
				}
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function (jqXHR, textStatus) {
			setDrawPieChart('energy');
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/status/raw/site',
			type: 'get',
			data: {
				sid: site.sid,
				formId: 'v2'
			},
		}).done(function (data, textStatus, jqXHR) {
			$.map(data, function (val, key) {
				if (key == 'INV_PV') {
					acPowerSum += val.activePower;

					pieChart.setTitle({text: Math.floor(acPowerSum / 1000) + 'kW'});
					pieChart.series[0].data.forEach((e, idx) => {
						if (e.name === "태양광") {
							e.update({y: Math.floor(acPowerSum / 1000)});
						} else if (e.name === "미사용량") {
							e.update({y: Math.floor((capacity - acPowerSum) / 1000)});
						} else {
							e.update({y: 0});
						}
					});
				}
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		}).always(function (jqXHR, textStatus) {
			setDrawPieChart('raw');
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/forecasting/sites',
			type: 'get',
			data: {
				sid: site.sid,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: '15min'
			},
		}).done(function (data, textStatus, jqXHR) {
			let generationForecastSum = 0;
			data.data[0].generation.items.map((e, idx) => generationForecastSum += e.energy);
			let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text().replace(/[^0-9]/, ''));
			$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text(numberComma(Math.floor(prevVal += generationForecastSum / 1000)));
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/now/sites',
			type: 'get',
			data: {
				sids: site.sid,
				metering_type: 2,
				interval: 'day'
			},
		}).done(function (data, textStatus, jqXHR) {
			if (!isEmpty(data.data[site.sid])) {
				co2Sum += Math.floor(data.data[site.sid].co2);
				let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text().replace(/[^0-9]/, ''));
				$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(numberComma(Math.floor(prevVal += (data.data[site.sid].energy / 1000))));
				$('#centerTbody tr td:nth-child(4) span').text(numberComma(Math.floor(co2Sum / 1000)));

				let prevPay = Number($('#centerTbody tr td:nth-child(5)  span').text().replace(/[^0-9]/, ''));
				let money = Math.floor(data.data[site.sid].money / 1000);
				$('#centerTbody tr td:nth-child(5) span').text(numberComma(prevPay + money));
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});

		if (site.devices != undefined) {
			site.devices.forEach(device => {
				let capacity = Number($('#centerTbody tr td:nth-child(3) span').text().replace(/[^0-9]/, '')) + Math.round(device.capacity / 1000);
				$('#centerTbody tr td:nth-child(3) span').text(numberComma(capacity));
				if (device.device_type.match('INV')) {
					let inverterCount = Number($('#centerTbody tr td:nth-child(2) span').text().replace(/[^0-9]/, '')) + 1;
					$('#centerTbody tr td:nth-child(2) span').text(numberComma(inverterCount));
				} else {
					let inverterCount = Number($('#centerTbody tr td:nth-child(2) span').text().replace(/[^0-9]/, ''));
					$('#centerTbody tr td:nth-child(2) span').text(numberComma(inverterCount));
				}
			});
		}
	});
}

const setDrawPieChart = function (type) {
	if (type = 'energy') {
		toDayEnergy++;
	} else {
		toDayRaw++;
	}

	if (toDayEnergy == siteList.length && toDayRaw == siteList.length) {
		pieChart.redraw();
	}
}

var pieChart = Highcharts.chart('pie_chart', {
	chart: {
		marginTop: 0,
		marginLeft: 0,
		marginRight: 0,
		backgroundColor: 'transparent',
		plotBorderWidth: 0,
		plotShadow: false,
	},

	navigation: {
		buttonOptions: {
			enabled: false /* 메뉴 안보이기 */
		}
	},

	title: {
		text: '- Wh', // 총용량 표기
		align: 'center',
		verticalAlign: 'middle',
		y: 10,
		x: -20,
		style: {
			fontSize: '14px',
			color: 'var(--color4)'
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
		shared: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--color3)'
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
					color: 'var(--color3)'
				}
			},
			center: ['40%', '50%'],
			borderWidth: 0,
			size: '100%'
		}
	},

	series: [{
		type: 'pie',
		innerSize: '50%',
		name: '발전량',
		colorByPoint: true,
		data: [{
			color: '#9363FD',
			name: '태양광',
			dataLabels: {
				enabled: false
			},
			y: 60 //60% -- 아래로 총합 100%
		}, {
			color: '#878787',
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
				minWidth: 305
			},
			chartOptions: {
				title: {
					x: -30,
					style: {
						fontSize: '16px',
					}
				}
			}
		}, {
			condition: {
				maxWidth: 481
			},
			chartOptions: {
				title: {
					x: 0
				},
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
const searchSiteList = function () {
	const formData = getSiteMainSchCollection('day');
	let siteArray = new Array();

	siteListNow = false;
	siteListAlarm = false;
	siteListForeCnt = 0;
	siteListWeatherCnt = 0;
	siteListActive = 0;

	siteList.forEach((site, siteIdx) => {
		let capacity = 0;
		let inverterCount = 0;
		if (site.devices != undefined) {
			site.devices.forEach(device => {
				capacity += device.capacity;

				if (device.device_type.match('INV')) {
					inverterCount++;
				}
			});

			siteList[siteIdx].capacity = displayNumberFixedUnit(capacity, 'W', 'kW', 0)[0];
			siteList[siteIdx].inverterCount = inverterCount;
		} else {
			siteList[siteIdx].capacity = '-';
			siteList[siteIdx].inverterCount = 0;
		}
		siteArray.push(site.sid);

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/forecasting/sites',
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
			url: 'http://iderms.enertalk.com:8443/status/raw/site',
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
			url: 'http://iderms.enertalk.com:8443/weather/site',
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
		url: 'http://iderms.enertalk.com:8443/energy/now/sites',
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
						siteList[idx].accumulate = '-';
					} else {
						siteList[idx].accumulate = displayNumberFixedUnit(el.energy, 'Wh', 'kWh', 0)[0];
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
		url: 'http://iderms.enertalk.com:8443/alarms',
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

	if (siteListNow && siteListAlarm && siteListForeCnt == siteList.length && yesterDayGen == siteList.length && siteListActive == siteList.length) {
		searchSite();
	}
}

/**
 * 사이트명 && 작동상태로 검색 기능 작동
 */
const searchSite = function () {
	let searchName = $('#searchName').val();
	let deviceStatus = $.makeArray($(':checkbox[name="deviceStatus"]:checked').map(
		function () {
			return $(this).val();
		}
		)
	);
	let refineList = new Array();

	siteList.forEach((site, siteIdx) => {
		if (!isEmpty(searchName)) {
			if (site.name.match(searchName) || site.address.match(searchName)) {
				if (deviceStatus.length == 3) {
					refineList.push(site);
				} else {
					deviceStatus.some(status => {
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
					if ($.inArray(Number(status), site.operation) != -1) {
						return refineList.push(site);
					}
				});
			}
		}
	});

	setMakeList(refineList, 'siteList', {'dataFunction': {'align': alignFunc}}); //list생성

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
			makerArray = new Array(refineList.length).fill(new Object());

			refineList.forEach((site, idx) => {
				if (site.latlng != null) {
					geocodeAddress(site.address, site.sid, site.name, idx);
				} else {
					makerArray[idx] = null;
				}
			});
		}
	}

	setTimeout(function () {
		refineList.forEach((site, siteIdx) => {
			let capacity = site.capacity == '-' ? 0 : Number(site.capacity.replace(/[^0-9]/, ''));
			let activePower = site.activePower == '-' ? 0 : Number(site.activePower.replace(/[^0-9]/, ''));

			let activePercent = Math.floor((activePower / capacity) * 100);
			let title = activePercent + '%';
			if(isNaN(activePercent)) {
				title = '- %';
			}

			let etc = capacity - activePower;
			let series = [{
				type: 'pie',
				innerSize: '50%',
				name: '설비용량',
				colorByPoint: true,
				data: [{
					color: '#26ccc8',
					name: '총 설비용량',
					dataLabels: {
						enabled: false
					},
					y: activePower
				}, {
					color: '#84848f',
					name: '미설비용량',
					dataLabels: {
						enabled: false
					},
					y: etc //30% 나머지
				}]
			}];

			siteListChart('type_chart' + siteIdx, series, title);
		});
	}, 500);
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
			marginTop: 0,
			marginLeft: 0,
			marginRight: 0,
			backgroundColor: 'transparent',
			renderTo: selector,
			plotBorderWidth: 0,
			plotShadow: false
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
			y: 32,
			x: 0,
			style: {
				fontSize: '14px',
				color: 'var(--color4)'
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
						color: 'var(--color3)'
					}
				},
				startAngle: -90,
				endAngle: 90,
				center: ['50%', '120%'],
				borderWidth: 0,
				size: '200%'
			}
		},
		series: seriesData,
		responsive: { // 반응형
			rules: [{
				condition: {
					minWidth: 305
				},
				chartOptions: {
					title: {
						x: 0,
						y: 10,
						style: {
							fontSize: '12px',
						}
					},
					plotOptions: {
						pie: {
							dataLabels: {
								style: {
									fontWeight: 'bold',
									color: 'var(--color3)'
								}
							},
							center: ['50%', '50%'],
							size: '100%'
						}
					}
				}
			}]
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
					if(this.getElementsByTagName('button')[0].classList.length == 1) {
						console.log(j);
						this.getElementsByTagName('button')[0].classList.add('down');
						sort = 'down';
					} else {
						if(this.getElementsByTagName('button')[0].classList[1] == 'up') {
							this.getElementsByTagName('button')[0].classList.replace('up', 'down');
							sort = 'down';
						} else {
							this.getElementsByTagName('button')[0].classList.replace('down', 'up');
							sort = 'up';
						}
					}

					for (var k = 0; k < headers.length; k++) {
						if(n != k) {
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
	let rows2 = tbody.querySelectorAll('tr.detail_info');
	rows = Array.prototype.slice.call(rows, 0);
	rows.sort(function (row1, row2) {
		var cell1 = row1.getElementsByTagName("td")[n];
		var cell2 = row2.getElementsByTagName("td")[n];
		var value1 = cell1.textContent || cell1.innerText;
		var value2 = cell2.textContent || cell2.innerText;

		value1 = value1 == '-' ? 0 : value1;
		value2 = value2 == '-' ? 0 : value2;

		console.log(isNaN(value1));
		console.log(isNaN(value2));

		if(!isNaN(value1) && typeof(value1) == 'string') {
			value1 = Number(value1.replace(/[^0-9]/, ''));
		}

		if(!isNaN(value2) && typeof(value2) == 'string') {
			value2 = Number(value2.replace(/[^0-9]/, ''));
		}

		if(sort == 'up') {
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