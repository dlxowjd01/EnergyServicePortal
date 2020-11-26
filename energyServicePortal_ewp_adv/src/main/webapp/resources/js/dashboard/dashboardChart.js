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
		tickWidth: 1,
		tickColor: 'var(--grey)',
		tickInterval: 1,
		gridLineColor: 'var(--white25)',
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
			y: 27,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		tickInterval: 1,
		title: {
			text: null
		},
		categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
		crosshair: true
	}],
	yAxis: [{
		lineColor: 'var(--grey)',
		tickColor: 'var(--grey)',
		gridLineColor: 'var(--white25)',
		gridLineWidth: 1,
		plotLines: [{
			color: 'var(--grey)',
			width: 1
		}],
		title: {
			text: 'kWh',
			align: 'low',
			rotation: 0,
			y: 25,
			x: 15,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		labels: {
			formatter: function () {
				const suffix = this.chart.yAxis[0].userOptions.title.text;
				const yAxisValue = displayNumberFixedUnit(this.value, 'kWh', suffix, 1);
				return yAxisValue[0];
			},
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		showEmpty: false
	}, {
		gridLineWidth: 0,
		title: {
			text: i18nManager.tr("gmain.1000won"),
			align: 'low',
			rotation: 0,
			y: 25,
			x: -12,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		labels: {
			formatter: function () {
				return  numberComma(this.value);
			},
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		visible: secondYAxis,
		opposite: true,
		showEmpty: false
	}],
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				if(point.y !== 0){
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + numberComma(Math.round(point.y)) + ' ' + suffix;
				} else {
					return s
				}
			}, '<span style="display:flex;"><b>' + this.x + '월</b></span>');
		},
		shared: true,
		useHTML: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--white87)',
			fontSize: '12px' 
		}
	},
	legend: {
		enabled: true,
		align: 'right',
		verticalAlign: 'top',
		x: 5,
		y: -15,
		itemStyle: {
			color: 'var(--white87)',
			fontSize: '12px',
		},
		itemHoverStyle: {
			color: ''
		},
		symbolPadding: 0,
		symbolHeight: 7
	},

	plotOptions: {
		series: {
			label: {
				connectorAllowed: false
			},
			borderWidth: 0
		},
		line: {
			marker: {
				enabled: false
			}
		},
		column: {
			stacking: 'normal'
		}
	},
	series: [],
	credits: {
		enabled: false
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
		tickWidth: 1,
		tickColor: 'var(--grey)',
		plotLines: [{
			color: 'var(--grey)',
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
			y: 27,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		tickWidth: 1,
		tickColor: 'var(--grey)',
		tickInterval: 1,
		title: {
			text: null
		},
		categories: null,
		crosshair: true
	}],
	yAxis: [{
		lineColor: 'var(--grey)',
		tickColor: 'var(--grey)',
		gridLineColor: 'var(--grey)',
		gridLineWidth: 1,
		plotLines: [{
			color: 'var(--grey)',
			width: 1
		}],
		title: {
			text: 'kWh',
			align: 'low',
			rotation: 0,
			y: 25,
			x: 15,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		labels: {
			formatter: function () {
				const suffix = this.chart.yAxis[0].userOptions.title.text;
				const yAxisValue = displayNumberFixedUnit(this.value, 'kWh', suffix, 1);
				return yAxisValue[0];
			},
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		showEmpty: false
	}, {
		gridLineWidth: 0,
		title: {
			text: i18nManager.tr("gmain.1000won"),
			align: 'low',
			rotation: 0,
			y: 25,
			x: -12,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		labels: {
			formatter: function () {
				return  numberComma(this.value);
			},
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		visible: secondYAxis,
		opposite: true,
		showEmpty: false
	}],
	tooltip: {
		hideDelay: 1,
		formatter: function () {
			return this.points.reduce(function (s, point) {
				if(point.y !== 0){
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					return s + ' <br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + numberComma(Math.round(point.y)) + ' ' + suffix;
				} else {
					return s
				}
			}, '<span style="display:flex;"><b>' + this.x + '일</b></span>');
		},
		shared: true,
		useHTML: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		
		style: {
			color: 'var(--white87)',
		}
	},
	legend: {
		enabled: true,
		align: 'right',
		verticalAlign: 'top',
		x: 5,
		y: -15,
		itemStyle: {
			color: 'var(--white87)',
			fontSize: '12px',
		},
		itemHoverStyle: {
			color: ''
		},
		symbolPadding: 0,
		symbolHeight: 7
	},
	plotOptions: {
		series: {
			label: {
				connectorAllowed: false
			},
			borderWidth: 0,
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
				enabled: false
			}
		},
		column: {
			stacking: 'normal'
		}
	},
	series: [],
	credits: {
		enabled: false
	}
});

// 전날: bar chart option
const typeSiteCurrent = Highcharts.chart('typeSiteCurrent', {
	chart: {
		renderTo: 'typeSiteCurrent',
		// spacingBottom: 60,
		height: 300,
		backgroundColor: 'transparent',
		type: 'bar',
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
	xAxis: {
		min: 0,
		lineColor: 'var(--grey)',
		gridLineColor: 'var(--white25)',
		plotLines: [{
			color: 'var(--grey)',
			width: 1
		}],
		labels: {
			align: 'left',
			overflow: 'justify',
			reserveSpace: true,
			style: {
				color: 'var(--grey)',
				fontSize: '12px',
				lineHeight: '24px'
			}
		},
		categories: null,
		title: {
			text: ''
		},
		showEmpty: false
	},
	yAxis: {
		y: 28,
		lineColor: 'var(--grey)',
		gridLineColor: 'var(--white25)',
		plotLines: [{
			color: 'var(--grey)',
			width: 0
		}],
		gridLineWidth: 0,
		min: 0,
		title: {
			text: '',
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		},
		labels: {
			formatter: function () {
				const suffix = this.chart.yAxis[0].userOptions.title.text;
				const yAxisValue = displayNumberFixedUnit(this.value, 'kWh', suffix, 0);
				return yAxisValue[0]/1000 + 'K';
			},
			overflow: 'justify',
			x: -10,
			y: 28,
			style: {
				color: 'var(--grey)',
				fontSize: '12px'
			}
		}
	},
	legend: {
		enabled: true,
		align: 'right',
		verticalAlign: 'top',
		x: 5,
		y: -15,
		itemStyle: {
			color: 'var(--white87)',
			fontSize: '12px',
		},
		itemHoverStyle: {
			color: ''
		},
		symbolPadding: 3,
		symbolHeight: 7
	},
	tooltip: {
		formatter: function () {
			return this.points.reduce(function (s, point) {
				let suffix = point.series.userOptions.tooltip.valueSuffix;
				let val = displayNumberFixedUnit(point.y, 'kWh', 'kWh', 0, "round")
				return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + val[0] + ' ' + suffix;
			}, '<span style="display:flex;"><b>' + this.x + '</b></span>');
		},
		shared: true,
		useHTML: true,
		borderColor: 'none',
		backgroundColor: 'var(--bg-color)',
		padding: 16,
		style: {
			color: 'var(--white87)',
		}
	},
	plotOptions: {
		series: {
			enabled: true,
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
				// inside: true,
				style: {
					color: 'var(--white87)',
					fontSize: '11px',
					fontWeight: 400,
					textOutline: 0,
					textAlign: 'right',
					textShadow: true,
				},
				formatter: function () {
					let val = displayNumberFixedUnit(this.y, 'kWh', 'kWh', 0, "round");
					return val[0] + " " +  val[1];
				}
			},
		},
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
		margin: [0, 0, 0, 0],
		spacing: [0, 0, 0, 0],
		backgroundColor: 'transparent',
		zoomType: 'xy',
		plotBorderWidth: 0,
		plotShadow: false,
		height: 160
	},
	navigation: {
		buttonOptions: {
			enabled: false
		}
	},
	title: {
		text: '- kW',
		align: 'center',
		verticalAlign: 'middle',
		y: 10,
		x: 0,
		style: {
			fontSize: '14px',
			color: 'var(--white87)'
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
			color: 'var(--white87)',
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
			center: ['50%', '50%'],
			borderWidth: 0,
			size: '100%'
		}
	},
	series: [{
		type: 'pie',
		innerSize: '70%',
		name: i18nManager.tr("dashboard_generated_amount"),
		colorByPoint: true,
		data: [{
			color: 'var(--circle-solar-power)',
			name: i18nManager.tr("dashboard_photovoltaic"),
			dataLabels: {
				enabled: false
			},
			y: 60 //60% -- 아래로 총합 100%
		}, {
			color: 'var(--grey)',
			name: i18nManager.tr("dashboard_unused_amount"),
			dataLabels: {
				enabled: false
			},
			y: 20 //20% 나머지
		}]
	}],
	responsive: { // 반응형
		rules: [{
			condition: {
				maxWidth: 992
			},
			chart: {
				height: 180
			},
			chartOptions: {
				plotOptions: {
					pie: {
						// center: ['50%', '50%']
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
				enabled: false
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
				color: 'var(--grey)'
			}
		},
		subtitle: {
			text: ''
		},
	
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