const standardSuffix = 'MWh';

/**
 * 월간차트 선언부
 */
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
		gridLineColor: 'var(--white25)',
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
		gridLineColor: 'var(--white25)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--white60)',
			width: 1
		}],
		title: {
			text: 'MWh',
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
				return numberComma(this.value);
			},
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		}
	}, { // Secondary yAxis
		gridLineWidth: 0,
		title: {
			text: '원',
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
				return  (displayNumberFixedDecimal(this.value, '천원', 3, 0).join(' ')).replace('원', '');
			},
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		visible: false,
		opposite: true
	}],
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				let suffix = point.series.userOptions.tooltip.valueSuffix;
				return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(Math.round(point.y)) + suffix;
			}, '<b>' + this.x + '월 </b>');
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
	series: [],
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

/**
 * 일별차트 선언
 */
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
		gridLineColor: 'var(--white25)',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: 'var(--white87)',
			width: 1
		}],
		title: {
			text: 'MWh',
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
			// formatter: function () {
			// 	return  (displayNumberFixedDecimal(this.value, standardSuffix, 3, 0).join(' ')).replace('Wh', '');
			// },
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		}
	}, { // Secondary yAxis
		gridLineWidth: 0, /* 기준선 grid 안보이기/보이기 */
		title: {
			text: '원',
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
				return  numberComma(this.value);
			},
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		},
		visible: false,
		opposite: true
	}],
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				let suffix = point.series.userOptions.tooltip.valueSuffix;
				return s + ' <br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(Math.round(point.y)) + suffix;
			}, '<b>' + this.x + '일 </b>');
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

// 전날: bar chart option
const typeSiteCurrent = Highcharts.chart('typeSiteCurrent', {
	chart: {
		renderTo: 'typeSiteCurrent',
		// height: series.length * 20 + 30,
		marginTop: 36,
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
		lineColor: 'var(--white25)', /* 눈금선색 */
		//tickColor: 'var(--white60)',
		gridLineColor: 'var(--white25)',
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
		//tickColor: 'var(--white60)',
		gridLineColor: 'var(--white25)',
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
			borderColor: 'transparent',
			formatter: function () {
				return 'test';
			},
		},
		bar: {
			dataLabels: {
				enabled: true,
				inside: true, /* 막대 안으로 라벨 수치 넣기 */
				//format: '{y} kWh', /* 단위 넣기 */
				style: {
					color: 'var(--white87)',
					fontSize: '12px',
					fontWeight: 400,
					textOutline: 0,
					textShadow: true,

				},
				formatter: function () {
					return this.y + this.series.yAxis.userOptions.title.text;
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

/**
 * 현재출력 차트
 */
const pieChart = Highcharts.chart('pie_chart', {
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

/**
 * 사업소 리스트에 배터리 용량 차트 그래프
 *
 * @param selector
 * @param seriesData
 */
const siteListChart = (selector, seriesData, title) => {
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