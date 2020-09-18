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

/**
 * 대쉬보드 먼슬리 차트 그리기
 */
const getYearGenData = async function () {
	const formData = getSiteMainSchCollection('year');//api에 맞게 수정 필요

	monthlyBefore = 0;
	monthlyNow = 0;
	let chargeList = new Array(12).fill(0);
	let dischargeList = new Array(12).fill(0);
	let pvList = new Array(12).fill(0);
	let payList = new Array(12).fill(0);
	let sumObj = {
		chargeSum: 0,
		dischargeSum: 0,
		pvSum: 0,
	};

	$(`.gmain_chart1 span.term`).text(today.getFullYear() + '.1.1 ~ ' + today.getFullYear() + '.' + (Number(today.getMonth()) + 1) + '.' + today.getDate());
	siteList.forEach(site => {
		$.ajax({
			url: apiHost + '/energy/sites',
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
									sumObj.chargeSum += element.energy;
									sumObj.chargeSum += element.energy;
								});
							} else if (k == 'discharging') {
								$.each(el.items, function (i, element) {
									const month = Number(String(element.basetime).slice(4, 6)) - 1;
									dischargeList[month] += element.energy;
									sumObj.dischargeSum += element.energy;
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
									sumObj.pvSum += Math.floor(element.energy / 1000);
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
			// alert('처리 중 오류가 발생했습니다.');
			$("#errMsg").text("처리 중 오류가 발생했습니다." + r);
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			return false;
		}).always(function (jqXHR, textStatus) {
			monthlyChartDraw('before', chargeList, dischargeList, pvList, payList, sumObj);
		});

		$.ajax({
			url: apiHost + '/energy/now/sites',
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
				sumObj.pvSum += Math.floor(data.data[site.sid].energy / 1000);
			}
			if (data.data[site.sid].money) {
				const month = Number(data.data[site.sid].start.toString().slice(4, 6)) - 1;
				payList[month] += Math.floor(data.data[site.sid].money / 1000);
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			// alert('처리 중 오류가 발생했습니다.');
			$("#errMsg").text("처리 중 오류가 발생했습니다." + r);
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			return false;
		}).always(function (jqXHR, textStatus) {
			monthlyChartDraw('now', chargeList, dischargeList, pvList, payList, sumObj);
		});
	});
}

const monthlyChartDraw = function (type, chargeList, dischargeList, pvList, payList, obj) {
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

		return new Promise((resolve, reject) => {
			let str = '';
			Object.entries(obj).forEach(([key, value]) => {
				if(key == "chargeSum"){
					let newValue = '';
					if (String(value).length  >= 5) {
						newValue = numberComma(value / 1000) + ' M';
					} else {
						newValue = String(value);
					}
					str += '<li class="charge">충전 : ' + newValue + '</li>';
				}
				if(key == "dischargeSum"){
					let newValue = '';
					if (String(value).length  >= 5) {
						newValue = numberComma(value / 1000) + ' M';
					} else {
						newValue = String(value);
					}
					str += '<li class="discharge">방전 : ' + newValue + '</li>';
				}
				if(key == "pvSum"){
					let newValue = '';
					if (String(value).length  >= 5) {
						newValue = numberComma(value / 1000) + ' M';
					} else {
						newValue = String(value);
					}
					str += '<li class="pv">태양광 : ' + newValue + '</li>';
				}
			});
			resolve(str);
		}).then(res => {
			$("#monthlySum").append(res)
		});

	}


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
	}, { // Secondary yAxis
		gridLineWidth: 0,
		title: {
			text: '천원',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: -12,
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
		},
		opposite: true
	}],
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
	series: [{
		name: '충전',
		type: 'column',
		color: 'var(--circle-charge)',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '방전',
		type: 'column',
		color: 'var(--grey)',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '태양광',
		type: 'column',
		color: 'var(--circle-solar-power)',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '정산금',
		type: 'spline',
		color: 'var(--white87)',
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
				}, {
					title: {
						y: 30,
						x: -15,
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
	let sumObj = {
		chargeSum: 0,
		dischargeSum: 0,
		pvSum: 0,
	};

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
			url: apiHost + '/energy/sites',
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
									sumObj.chargeSum += element.energy;
								});
							} else if (k == 'discharging') {
								$.each(el.items, function (i, element) {
									const day = Number(String(element.basetime).slice(6, 8)) - 1;
									dischargeList[day] += element.energy;
									sumObj.dischargeSum += element.energy;
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
									sumObj.pvSum += Math.floor(element.energy / 1000);
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
			dailyChartDraw('before', chargeList, dischargeList, pvList, payList, categories, sumObj);
		});

		$.ajax({
			url: apiHost + '/energy/now/sites',
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
				sumObj.pvSum += Math.floor(data.data[site.sid].energy / 1000);
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
			dailyChartDraw('now', chargeList, dischargeList, pvList, payList, categories, sumObj);
		});
	});
}

const dailyChartDraw = function (type, chargeList, dischargeList, pvList, payList, categories, obj) {
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
		return new Promise((resolve, reject) => {
			let str = '';
			Object.entries(obj).forEach(([key, value]) => {
				if(key == "chargeSum"){
					let newValue = '';
					if (String(value).length  >= 5) {
						newValue = numberComma(value / 1000) + ' M';
					} else {
						newValue = String(value);
					}
					str += '<li class="charge">충전 : ' + newValue + '</li>';
				}
				if(key == "dischargeSum"){
					let newValue = '';
					if (String(value).length  >= 5) {
						newValue = numberComma(value / 1000) + ' M';
					} else {
						newValue = String(value);
					}
					str += '<li class="discharge">방전 : ' + newValue + '</li>';
				}
				if(key == "pvSum"){
					let newValue = '';
					if (String(value).length  >= 5) {
						newValue = numberComma(value / 1000) + ' M';
					} else {
						newValue = String(value);
					}
					str += '<li class="pv">태양광 : ' + newValue + '</li>';
				}
			});
			resolve(str);
		}).then(res => {
			$("#dailySum").append(res)
		});

	}
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
	}, { // Secondary yAxis
		gridLineWidth: 0, /* 기준선 grid 안보이기/보이기 */
		title: {
			text: '천원',
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: -12,
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
		},
		opposite: true
	}],
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				let suffix = point.series.userOptions.tooltip.valueSuffix;
				return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(point.y) + suffix;
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
	series: [{
		name: '충전',
		type: 'column',
		color: 'var(--circle-charge)',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '방전',
		type: 'column',
		color: 'var(--grey)',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '태양광',
		type: 'column',
		color: 'var(--circle-solar-power)',
		tooltip: {
			valueSuffix: 'kWh'
		}

	}, {
		name: '정산금',
		type: 'spline',
		color: 'var(--white87)',
		dashStyle: 'ShortDash',
		yAxis: 1,
		tooltip: {
			valueSuffix: '천원'
		}
	}],
	/* 출처 */
	credits: {
		enabled: false
	}
});

let yesterDayGen = 0;
let yesterDayFore = 0;
const getGenDataBySiteYesterday = async function () { //3번째 indiv 사업소별 탭
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
			url: apiHost + '/energy/sites',
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
			siteGenArray[siteIdx] = Number(String(siteGenSum).replace(/[^0-9]/g, ''));

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
			siteForeGenArray[siteIdx] = Number(String(siteForeGenSum).replace(/[^0-9]/g, ''));
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

const setGenDataBySiteYesterday = function (type, siteGenArray, siteForeGenArray, categories, obj) {
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

		let tmepGenArray = new Array();
		let tempForeArray = new Array();
		for (var i = 0; i < siteGenArray.length; i++) {
			if (!isEmpty(siteGenArray[i]) && siteGenArray[i] > 0) {
				tmepGenArray.push(siteGenArray[i]);
				tempForeArray.push(siteForeGenArray[i]);
			}
		}

		typeSiteCurrent.addSeries({
			name: '발전',
			color: 'var(--turquoise)',
			data: tmepGenArray,
			tooltip: {
				valueSuffix: 'kWh'
			}
		});

		typeSiteCurrent.addSeries({
			name: '발전 예측',
			color: 'var(--grey)',
			data: tempForeArray,
			tooltip: {
				valueSuffix: 'kWh'
			}
		});

		//typeSiteCurrent.xAxis[0].categories = true;
		typeSiteCurrent.xAxis[0].setCategories(categories);
		typeSiteCurrent.redraw();
		
		let str = '';
		let genSum = 0;
		let genForecastSum = 0;

		if(!isEmpty(tmepGenArray)){
			let newValue = '';
			genSum = tmepGenArray.reduce((acc, val) => { return acc + val } , 0);
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
	}
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
				format: '{y} kWh', /* 단위 넣기 */
				style: {
					color: 'var(--white87)',
					fontSize: '12px',
					fontWeight: 400,
					textOutline: 0,
					textShadow: true,
					
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

		$('.a_alert').find('em').text(alarmList.length);
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

	$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(0);
	$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text(0);

	const formData = getSiteMainSchCollection('day');
	$('#centerTbody tr td:nth-child(1)').html(Math.floor(siteList.length) + '<em>&nbsp;&nbsp;개소</em>');
	$('#centerTbody tr td:nth-child(2)').text('');
	$('#centerTbody tr td:nth-child(3)').text('');
	$('#centerTbody tr td:nth-child(4)').text('');
	$('#centerTbody tr td:nth-child(5)').text('');

	let co2Sum = 0;
	let acPowerSum = 0;
	let capacity = 0;
	siteList.forEach(site => {
		let siteAcPowerSum = site.acPowerSum;
		let siteCapacity = site.capacity;

		if(!isEmpty(siteAcPowerSum)) {
			acPowerSum += siteAcPowerSum;
		}

		if(!isEmpty(siteCapacity)) {
			capacity += siteCapacity;
		}
	});

	pieChart.setTitle({text: Math.floor(acPowerSum / 1000) + 'kW'});

	let usage = Math.floor((acPowerSum / capacity) * 100);
	let other = 100 - usage;

	pieChart.series[0].data.forEach((e, idx) => {
		if (e.name === "태양광") {
			e.update({y: usage});
		} else if (e.name === "미사용량") {
			e.update({y: other});
		} else {
			e.update({y: 0});
		}
	});
	pieChart.redraw();

	siteList.forEach((site, siteIdx) => {
		$.ajax({
			url: apiHost + '/energy/forecasting/sites',
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
			let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text().replace(/[^0-9]/g, ''));
			$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text(numberComma(Math.floor(prevVal += generationForecastSum / 1000)));
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});

		$.ajax({
			url: apiHost + '/energy/now/sites',
			type: 'get',
			data: {
				sids: site.sid,
				metering_type: 2,
				interval: 'day'
			},
		}).done(function (data, textStatus, jqXHR) {
			if (!isEmpty(data.data[site.sid])) {
				co2Sum += Math.floor(data.data[site.sid].co2);
				let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text().replace(/[^0-9]/g, ''));
				$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(numberComma(Math.floor(prevVal += (data.data[site.sid].energy / 1000))));
				$('#centerTbody tr td:nth-child(4)').html(numberComma(Math.floor(co2Sum / 1000)) + '<em>&nbsp;&nbsp;kg</em>');

				let prevPay = Number($('#centerTbody tr td:nth-child(5)').text().replace(/[^0-9]/g, ''));
				let money = Math.floor(data.data[site.sid].money / 1000);
				$('#centerTbody tr td:nth-child(5)').html(numberComma(prevPay + money) + '<em>&nbsp;&nbsp;천원</em>');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});

		if (site.devices != undefined) {
			site.devices.forEach(device => {
				if (device.device_type.match('INV')) {
					let inverterCount = Number($('#centerTbody tr td:nth-child(2)').text().replace(/[^0-9]/g, '')) + 1;
					$('#centerTbody tr td:nth-child(2)').html(numberComma(inverterCount) + '<em>&nbsp;&nbsp;대</em>');
				} else {
					let inverterCount = Number($('#centerTbody tr td:nth-child(2)').text().replace(/[^0-9]/g, ''));
					$('#centerTbody tr td:nth-child(2)').html(numberComma(inverterCount) + '<em>&nbsp;&nbsp;대</em>');
				}
			});
		}

		let capacity = Number($('#centerTbody tr td:nth-child(3)').text().replace(/[^0-9]/g, '')) + Math.round(site.capacity / 1000);
		$('#centerTbody tr td:nth-child(3)').html(numberComma(capacity) + '<em>&nbsp;&nbsp;kW</em>');
	});
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
		const operation = site.operation;
		let statusClass = '';
		if (operation.includes('0')) {
			refineList[siteIdx].status = '중지';
			statusClass = 'status_stp';
		} else if (operation.includes('1')) {
			refineList[siteIdx].status = '정상';
			statusClass = 'status_drv';
		} else if (operation.includes('2')) {
			refineList[siteIdx].status = '트립';
			statusClass = 'status_err';
		} else {
			refineList[siteIdx].status = '에러';
			statusClass = 'status_err';
		}
		refineList[siteIdx].statusClass = statusClass;

		if(typeof site.accumulate !== 'string') {
			if (site.accumulate == 0) {
				refineList[siteIdx].accumulate = '-';
			} else {
				refineList[siteIdx].accumulate = displayNumberFixedUnit(site.accumulate, 'Wh', 'kWh', 0)[0];
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
			let capacity = (site.capacity == '-' || site.capacity == 0) ? 0 :site.capacity / 1000;
			let activePower = (site.activePower == '-' || site.activePower == 0) ? 0 : Number(site.activePower.replace(/[^0-9]/g, ''));

			let activePercent = Math.floor((activePower / capacity) * 100);
			let title = activePercent + '%';
			if (isNaN(activePercent)) {
				title = '- %';
			}

			let etc = capacity - activePower;
			let series = [{
				type: 'pie',
				innerSize: '50%',
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
					color: 'var(--grey)',
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
	let rows2 = tbody.querySelectorAll('tr.detail_info');
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

const getDashboardTable = (table) => {
	let id = "#" + table;
	let newArr = [];
	var gmainTable = $('#gmainTable').DataTable({
		"aaData": newArr,
		"table-layout": "fixed",
		"fixedHeader": true,
		"bAutoWidth": true,
		"bSearchable" : true,
		"retrieve": true,
		// "ScrollX": true,
		// "sScrollX": "110%",
		// "sScrollXInner": "110%",
		"sScrollY": true,
		"scrollY": "720px",
		"bScrollCollapse": true,
		"pageLength": 100,
		// "bFilter": false, disabling this option will prevent table.search()
		"aaSorting": [[ 0, 'asc' ]],
		"bSortable": true,
		"order": [[ 1, 'asc' ]],
		"aoColumnDefs": [
			{
				"aTargets": [ 0 ],
				"bSortable": false,
				"orderable": false
			},
		],
		"aoColumns": [
			{
				"title": "순번",
				"data": null,
				"className": "dt-center no-sorting"
			},
			{
				"sTitle": "발전소 명",
				"mData": "null",
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "인버터 가동 상태",
				"mData": null,
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "경고 알람",
				"mData": "null",
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "현재 발전량(kW)",
				"mData": "null",
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "현재 날씨",
				"mData": null,
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "전일 발전",
				"mData": "null",
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "전일 날씨",
				"mData": null,
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "월간 발전량(MWh)",
				"mData": "null",
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "전년 동월 발전량(MWh)",
				"mData": "null",
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
			{
				"sTitle": "전년 동월 대비 발전 비율(%)",
				"mData": null,
				"mRender": function ( data, type, full, rowIndex )  {
					return ''
				},
			},
		],
		"language": {
			"emptyTable": "조회된 데이터가 없습니다.",
			"zeroRecords":  "검색된 결과가 없습니다."
		},
		"dom": 'tip',
		initComplete: function(settings, json ){
			this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
				cell.innerHTML = i+1;
				$(cell).data("id", i);
			});
		},
		// every time DataTables performs a draw
		drawCallback: function (settings) {

		},
	}).columns.adjust();

	gmainTable.on( 'column-sizing.dt', function ( e, settings ) {
		$(".dataTables_scrollHeadInner").css( "width", "100%" );
	});

	// new $.fn.dataTable.Buttons( gmainTable, {
	// 	name: 'commands',
	// 	"buttons": [
	// 		{
	// 			extend: 'excelHtml5',
	// 			className: "save_btn",
	// 			text: '엑셀 다운로드',
	// 			// exportOptions: {
	// 			// 	modifier: {
	// 			// 		page: 'current'
	// 			// 	}
	// 			// },
	// 			customize: function( xlsx ) {
	// 				var sheet = xlsx.xl.worksheets['sheet1.xml'];
	// 				$('row:first c', sheet).attr( 's', '42' );
	// 				var sheet = xlsx.xl.worksheets['sheet1.xml'];
	// 				// var lastCol = sheet.getElementsByTagName('col').length - 1;
	// 				// var colRange = createCellPos( lastCol ) + '1';
	// 				// //Has to be done this way to avoid creation of unwanted namespace atributes.
	// 				// var afSerializer = new XMLSerializer();
	// 				// var xmlString = afSerializer.serializeToString(sheet);
	// 				// var parser = new DOMParser();
	// 				// var xmlDoc = parser.parseFromString(xmlString,'text/xml');
	// 				// var xlsxFilter = xmlDoc.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main','autoFilter');
	// 				// var filterAttr = xmlDoc.createAttribute('ref');
	// 				// filterAttr.value = 'A1:' + colRange;
	// 				// xlsxFilter.setAttributeNode(filterAttr);
	// 				// sheet.getElementsByTagName('worksheet')[0].appendChild(xlsxFilter);

	// 			}
	// 		},
	// 		// {
	// 		// 	extend: 'csvHtml5',
	// 		// 	className: "btn_type03",
	// 		// 	text: 'CSV'
	// 		// },
	// 		// {
	// 		// 	extend: 'pdfHtml5',
	// 		// 	className: "btn_type03",
	// 		// 	text: 'PDF',
	// 		// },
	// 	],
	// });

	// gmainTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
}

const destroyDashboardTable = (table) => {
	let id = "#" + table;
	$("#gmainTable").DataTable().clear().destroy();
}