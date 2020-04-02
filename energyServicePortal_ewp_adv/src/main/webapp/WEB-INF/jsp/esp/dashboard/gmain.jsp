<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

	<!-- 메인페이지용 스타일/스크립트 파일 -->
	<link type="text/css" href="/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="/js/modules/rounded-corners.js"></script>
	<script type="text/javascript" src="/js/jquery.rwdImageMaps.min.js"></script>
				<div class="row">
					<div class="time">
						<span>CURRENT TIME</span>
						<em id="currTime">${nowTime}</em>
						<span>DATA BASE TIME</span>
						<em>2018-07-27 17:01:02</em>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_chart gmain_chart1">
									<div class="chart_top clear">
										<h2 class="ntit">월간</h2>
										<span class="term">2020.1.1 ~ 2020.2.29</span>
									</div>
									<div class="inchart">
									    <div id="gchart1"></div>
										<script type="text/javascript">
										var chargeChart = Highcharts.chart('gchart1', {
										    chart: {
										    	marginTop:40,
												marginLeft:50,
												marginRight:50,
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
											    labels: {
													align: 'center',
													y:27, /* 그래프와 거리 */
													style: {
														color: 'var(--color2)',
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
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										    	title: {
										            text: 'kWh',
										            align: 'low',
												    rotation: 0, /* 타이틀 기울기 */
												    y:25, /* 타이틀 위치 조정 */
												    x:15,
										            style: {
										                color: 'var(--color3)',
												        fontSize: '12px'
										            }
										        },
										        labels: {
										            format: '{value}',
										            style: {
										                color: 'var(--color2)',
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
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										        title: {
										            text: '만원',
										            align: 'low',
												    rotation: 0, /* 타이틀 기울기 */
												    y:25, /* 타이틀 위치 조정 */
												    x:-12,
										            style: {
										                color: 'var(--color3)',
												        fontSize: '12px'
										            }
										        },
										        labels: {
										            format: '{value}',
										            style: {
										                color: 'var(--color2)',
												        fontSize: '12px'
										            }
										        },
										        opposite: true
										    }],
										    tooltip: {
										        shared: true
										    },
										    /* 범례 */
											legend: {
												enabled: true,
												align:'right',
												verticalAlign:'top',
												x:5,
												y:-32,
												itemStyle: {
											        color: 'var(--color2)',
											        fontSize: '12px',
											        fontWeight: 400
											    },
											    itemHoverStyle: {
											        color: '' /* 마우스 오버시 색 */
											    },
											    symbolPadding:0, /* 심볼 - 텍스트간 거리 */
											    symbolHeight:7 /* 심볼 크기 */
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
										        data: [-10, -10, -50, -40, -90, -40, -70, -60, -30, -20, -40, -30],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '방전',
										        type: 'column',
										        color: '#878787',
										        data: [50, 50, 60, 30, 50, 60, 30, 50, 90, 60, 60, 50],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '태양광',
										        type: 'column',
										        color: '#9363FD',
										        data: [50, 10, 30, 70, 20, 20, 50, 20, 50, 80, 70, 80],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '풍력',
										        type: 'column',
										        color: '#5269EF',
										        data: [50, 10, 30, 70, 20, 20, 50, 20, 50, 80, 70, 80],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '소수력',
										        type: 'column',
										        color: '#4FB5FF',
										        data: [50, 10, 30, 70, 20, 20, 50, 20, 50, 80, 70, 80],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '정산금',
										        type: 'spline',
										        color: 'var(--color3)',
										        dashStyle: 'ShortDash',
										        yAxis: 1,
										        data: [100, 110, 120, 130, 150, 180, 160, 130, 90, 110, 160, 120],
										        tooltip: {
										            valueSuffix: '만원'
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
											            minWidth: 870 									                
											        },
											        chartOptions: {
											        	chart: {
											        		marginTop:50,
															marginLeft:75,
															marginRight:75
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
																y:30,
																x:20,															
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
																y:30,
																x:-15,
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
														    symbolPadding:5,
														    symbolHeight:10
														}
											        }
											    },{ /* 차트 사이즈 - 모바일용 */	
												    condition: {
												        maxWidth: 481 								                
												    },
												    chartOptions: {
														chart: {
													    	marginTop:55
													    }
													}														
												}]
											}											
										});

										</script>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_chart gmain_chart2">
									<div class="chart_top clear">
										<h2 class="ntit">일간</h2>
										<span class="term">2020.3.1 ~ 2020.3.6</span>
									</div>
									<div class="inchart">
										<div id="gchart2"></div>
										<script type="text/javascript">
										var chargeChart = Highcharts.chart('gchart2', {
										    chart: {
										    	marginTop:40,
												marginLeft:50,
												marginRight:50,
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
											    labels: {
													align: 'center',
													y:27, /* 그래프와 거리 */
													style: {
														color: 'var(--color2)',
														fontSize: '12px'
													}
												},
											    tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
											    title: {
													text: null
												},
										        categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12','13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'],
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
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										    	title: {
										            text: 'kWh',
										            align: 'low',
												    rotation: 0, /* 타이틀 기울기 */
												    y:25, /* 타이틀 위치 조정 */
												    x:15,
										            style: {
										                color: 'var(--color3)',
												        fontSize: '12px'
										            }
										        },
										        labels: {
										            format: '{value}',
										            style: {
										                color: 'var(--color2)',
												        fontSize: '12px'
										            }
										        }
										    }, { // Secondary yAxis
										    	lineColor:'var(--colo1)', /* 눈금선색 */
												tickColor: 'var(--colo1)',
												gridLineColor: 'var(--colo1)',
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												plotLines: [{
											         color: 'var(--colo1)',
											         width: 1
											    }],
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										        title: {
										            text: '만원',
										            align: 'low',
												    rotation: 0, /* 타이틀 기울기 */
												    y:25, /* 타이틀 위치 조정 */
												    x:-12,
															style: {
																color: 'var(--color3)',
																fontSize: '12px'
															}
										        },
										        labels: {
															format: '{value}',
															style: {
																color: 'var(--color2)',
																fontSize: '12px'
															}
										        },
										        opposite: true
										    }],
										    tooltip: {
										        shared: true
										    },
										    /* 범례 */
											legend: {
												enabled: true,
												align:'right',
												verticalAlign:'top',
												x:5,
												y:-32,
												itemStyle: {
											        color: 'var(--color2)',
											        fontSize: '12px',
											        fontWeight: 400
											    },
											    itemHoverStyle: {
											        color: '' /* 마우스 오버시 색 */
											    },
											    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
											    symbolHeight:7 /* 심볼 크기 */
											},
										    /* 옵션 */
											plotOptions: {
										    	series: {
											        label: {
											            connectorAllowed: false
											        },
											        borderColor: '#a4aebf',
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
										        data: [-10, -10, -50, -40, -90, -40, -70, -60, -30, -20, -40, -30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '방전',
										        type: 'column',
										        color: '#878787',
										        data: [50, 50, 60, 30, 50, 60, 30, 50, 90, 60, 60, 50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '태양광',
										        type: 'column',
										        color: '#9363FD',
										        data: [50, 10, 30, 70, 20, 20, 50, 20, 50, 80, 70, 80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '풍력',
										        type: 'column',
										        color: '#5269EF',
										        data: [50, 10, 30, 70, 20, 20, 50, 20, 50, 80, 70, 80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '소수력',
										        type: 'column',
										        color: '#4FB5FF',
										        data: [50, 10, 30, 70, 20, 20, 50, 20, 50, 80, 70, 80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    },{
										        name: '정산금',
										        type: 'spline',
										        color: 'var(--color3)',
										        dashStyle: 'ShortDash',
										        yAxis: 1,
										        data: [10, 50, 70, 30, 50, 20, 90, 70, 90, 60, 60, 20,,,,,,,,,,,,,,,,,,],
										        tooltip: {
										            valueSuffix: '만원'
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
											        		marginTop:50,
															marginLeft:75,
															marginRight:75
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
																y:30,
																x:20,															
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
																y:30,
																x:-15,
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
														    symbolPadding:5,
														    symbolHeight:10
														}
											        }
											    },{ /* 차트 사이즈 - 모바일용 */	
												    condition: {
												        maxWidth: 481 								                
												    },
												    chartOptions: {
														chart: {
													    	marginTop:55
													    }
													}														
												}]
											}											
										});

										</script>									
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_chart gmain_chart3">
									<div class="chart_top clear">
										<h2 class="ntit">전일</h2>
										<span class="term">2020.3.6</span>
									</div>
									<ul class="gtab_menu">
										<li class="active"><a href="#;">사업소별 현황</a></li>
										<li><a href="#;">유형별 발전 현황</a></li>								
									</ul>
									<div class="tblDisplay">
										<div>
											<!-- 사업소별 현황 -->
											<div class="sa_chart">
												<div class="inchart">
													<div id="gchart3" style="height:auto;"></div>
													<script language="JavaScript"> 
													$(function () { 
														var peakChart3 = Highcharts.chart('gchart3', {
															data: {
														        table: 'gdatatable3' /* 테이블에서 데이터 불러오기 */
														    },

															chart: {
																marginTop:40,
																marginRight:0,
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
															        x:-10, /* 그래프와의 거리 조정 */
															        style: {
															            color: '#a4aebf',
															            fontSize: '12px'
															        }
															    }
															},									    

															/* 범례 */
															legend: {
																enabled: true,
																align:'right',
																verticalAlign:'top',
																x:5,
																y:-10,										
																itemStyle: {
															        color: '#a4aebf',
															        fontSize: '12px',
															        fontWeight: 400
															    },
															    itemHoverStyle: {
															        color: '' /* 마우스 오버시 색 */
															    },
															    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
															    symbolHeight:7 /* 심볼 크기 */
															},

															/* 툴팁 */
															tooltip: {
																    valueSuffix: ' kwh'
															},

															/* 옵션 */
															plotOptions: {
														        series: {
														            label: {
														                connectorAllowed: true
														            },
														            borderWidth: 0, /* 보더 0 */
														            borderRadiusTopLeft: '50%', /* 막대 모서리 둥글게 효과 */
			        												borderRadiusTopRight: '50%', /* 막대 모서리 둥글게 효과 */
			        												pointWidth: 8, /* 막대 두께 */
			        												pointPadding: 0.25 /* 막대 사이 간격 */
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

															/* 출처 */
															credits: {
																enabled: false
															},

															/* 그래프 스타일 */
														    series: [{
														        color: '#25CCC8' /* 금일발전 */
														    },{
														        color: '#878787' /* 금일예측 */
														    }],

														    /* 반응형 */
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
																		    symbolPadding:5,
																		    symbolHeight:10
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
													});
													</script>
												</div>
											</div>
											<!-- 데이터 추출용 테이블 -->
											<div class="hidden_table" style="display:none">
												<table id="gdatatable3">
												    <thead>
												        <tr>
												            <th></th>
												            <th>전일발전</th>
												            <th>전일예측</th>
												        </tr>
												    </thead>
												    <tbody>
												        <tr>
												            <th>사업소#13</th>
												            <td>50</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>사업소#12</th>
												            <td>90</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>사업소#11</th>
												            <td>70</td>
												            <td>90</td>
												        </tr>
												        <tr>
												            <th>사업소#10</th>
												            <td>30</td>
												            <td>40</td>
												        </tr>
												        <tr>
												            <th>사업소#09</th>
												            <td>100</td>
												            <td>92</td>
												        </tr>
												        <tr>
												            <th>사업소#08</th>
												            <td>100</td>
												            <td>92</td>
												        </tr>
												        <tr>
												            <th>사업소#07</th>
												            <td>100</td>
												            <td>92</td>
												        </tr>
												    </tbody>
												</table>
											</div>	
										</div>
										<div>
											<!-- 유형별 발전 현황 -->
											<div class="sa_chart type-table">
												<div class="inchart type-left">
													<div id="gchart4"></div>
													<script language="JavaScript"> 
													$(function () { 
														var peakChart4 = Highcharts.chart('gchart4', {
															data: {
														        table: 'gdatatable4' /* 테이블에서 데이터 불러오기 */
														    },

															chart: {
																marginTop:40,
																marginLeft:50,
																backgroundColor: 'transparent',
																type: 'column'
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
																	align: 'center',
																	reserveSpace: true,
																	style: {
																		color: '#a4aebf',
																		fontSize: '12px'
																	}
																},
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
															    	text: 'kWh',
															    	align: 'low',
															    	rotation: 0, /* 타이틀 기울기 */
															        y:25, /* 타이틀 위치 조정 */
															        x:10,
															        style: {
															            color: '#a4aebf',
															            fontSize: '12px'
															        }
															    },
															    labels: {
															        overflow: 'justify',
															        x:-10, /* 그래프와의 거리 조정 */
															        style: {
															            color: '#a4aebf',
															            fontSize: '12px'
															        }
															    }
															},									    

															/* 범례 */
															legend: {
																enabled: true,
																align:'right',
																verticalAlign:'top',
																x:5,
																y:-10,									
																itemStyle: {
															        color: '#a4aebf',
															        fontSize: '12px',
															        fontWeight: 400
															    },
															    itemHoverStyle: {
															        color: '' /* 마우스 오버시 색 */
															    },
															    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
															    symbolHeight:7 /* 심볼 크기 */
															},

															/* 툴팁 */
															tooltip: {
																    valueSuffix: ' kwh'
															},

															/* 옵션 */
															plotOptions: {
														        series: {
														            label: {
														                connectorAllowed: true
														            },
														            borderWidth: 0, /* 보더 0 */
														            //borderRadiusTopLeft: '50%', /* 막대 모서리 둥글게 효과 */
			        												//borderRadiusTopRight: '50%' /* 막대 모서리 둥글게 효과 */
														        },
														        line: {
																    marker: {
																         enabled: false /* 마커 안보이기 */
																    }
																},
																column: {
																	  
																}
														    },

															/* 출처 */
															credits: {
																enabled: false
															},

															/* 그래프 스타일 */
														    series: [{
														        color: '#25CCC8' /* 전일발전 */
														    },{
														        color: '#878787' /* 전일예측 */
														    }],

														    /* 반응형 */
														    responsive: {
														        rules: [{
														            condition: {
														                minWidth: 412 /* 차트 사이즈 */									                
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
																			},
																			title: {
																		        style: {
																		            fontSize: '18px'
																		        }
																		    }
																		},
																		legend: {									
																			itemStyle: {
																		        fontSize: '18px'
																		    },
																		    symbolPadding:5,
																		    symbolHeight:10
																		},
																		plotOptions: {
																	        series: {
						        												
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
													});
													</script>
												</div>
												<div class="type-right">
													<dl class="sun">
														<dt><span>태양광</span></dt>
														<dd>
															<p><strong>가동설비</strong> <span>13</span><em>기</em></p>
															<p><strong>용량</strong> <span>13</span><em>MW</em></p>
															<p><strong>전일발전량</strong> <span>3,500</span><em>kWH</em></p>
														</dd>
													</dl>
													<dl class="wind">
														<dt><span>풍력</span></dt>
														<dd>
															<p><strong>가동설비</strong> <span>13</span><em>기</em></p>
															<p><strong>용량</strong> <span>13</span><em>MW</em></p>
															<p><strong>전일발전량</strong> <span>3,500</span><em>kWH</em></p>
														</dd>
													</dl>
													<dl class="water">
														<dt><span>소수력</span></dt>
														<dd>
															<p><strong>가동설비</strong> <span>13</span><em>기</em></p>
															<p><strong>용량</strong> <span>13</span><em>MW</em></p>
															<p><strong>전일발전량</strong> <span>3,500</span><em>kWH</em></p>
														</dd>
													</dl>
												</div>											
											</div>
											<!-- 데이터 추출용 테이블 -->
											<div class="hidden_table" style="display:none">
												<table id="gdatatable4">
												    <thead>
												        <tr>
												            <th></th>
												            <th>전일발전량</th>
												            <th>예측발전량</th>
												        </tr>
												    </thead>
												    <tbody>
												        <tr>
												            <th>태양광</th>
												            <td>50</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>풍력</th>
												            <td>90</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>소수력</th>
												            <td>70</td>
												            <td>90</td>
												        </tr>
												    </tbody>
												</table>
											</div>	
										</div>
									</div>
								</div>
							</div>
						</div>				
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_map gmain_chart gmain_chart4 ">
									<div class="chart_top clear">
										<h2 class="ntit">현재 출력</h2>
									</div>
									<div class="chart_box">
										<div class="chart_info">
											<div class="ci_left">
												<div class="inchart">
													<div id="pie_chart" style="height:200px;"></div>
													<script language="JavaScript">
													$(window).resize(function() { //브라우저 사이즈 변경될때마다 새로고침 (차트사이즈 재설정)
													    location.reload();
													});
													$(function () {														
														var pieChart = Highcharts.chart('pie_chart', {
															chart: {
																marginTop:0,
																marginLeft:0,
																marginRight:0,
																backgroundColor: 'transparent',

																plotBorderWidth: 0,
																plotShadow: false
															},

															navigation: {
																buttonOptions: {
																	enabled: false /* 메뉴 안보이기 */
																}
															},

															title: {																
														        text: '102Wh', // 총용량 표기
														        align: 'center',
														        verticalAlign: 'middle',
														        y:0,
														        x:-20,
														        style: {
														            fontSize: '14px',
														            color: 'var(--color3)'
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
														                    color: 'white'
														                }																		
																	},
																	startAngle: 0,
																	endAngle: 360,
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
																	color: '#5269EF',
																	name: '풍력',
																	dataLabels: {
														                enabled: false
														            },
																	y: 10 //10%
																}, {
																	color: '#4FB5FF',
																	name: '소수력',
																	dataLabels: {
														                enabled: false
														            },
																	y: 10 //10% 
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
																	        x:-30,
																	        style: {
																	            fontSize: '16px',
																	        }
																		}															
																	}
																},{
														            condition: {
														                maxWidth: 481
														            },
														            chartOptions: {
														            	title: {
																	        x:0
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
													});
													</script>
												</div>

											</div>
											<div class="ci_right">
												<ul>
													<li><strong>금일 누적발전량</strong> <span>13</span><em>Wh</em></li>
													<li><strong>금일 예측발전량</strong> <span>13</span><em>Wh</em></li>
													<li><strong>금일 충/방전</strong> <span>13.2</span><em>Wh</em> / <span>12.1</span><em>Wh</em></li>
													<li><strong>금일 예측충/방전</strong> <span>25.0</span><em>Wh</em> / <span>24.8</span><em>Wh</em></li>
												</ul>
											</div>
										</div>										
									</div>	
									<div class="local_info s_center">
										<table>
											<thead>
												<tr>
													<th>총 사업소</th>
													<th>총 설비(인버터,PCS)</th>
													<th>총 설비용량</th>
													<th>금일 CO2저감량</th>
													<th>금일 누적수익</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td>16개소</td>
													<td>35대</td>
													<td>13MW/20MWh</td>
													<td>12tCO2</td>
													<td>329,493KRW</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_map2">
									<div class="map_wrap">
										<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1641462.880600535!2d126.99803822323253!3d36.53042408172777!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x356455ebcb11ba9b%3A0x91249b00ba88db4b!2z64yA7ZWc66-86rWt!5e0!3m2!1sko!2skr!4v1581334740687!5m2!1sko!2skr" width="100%" height="100%" frameborder="0" style="border:0;" allowfullscreen=""></iframe>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_alarm">
									<div class="alarm_stat clear">
										<div class="a_alert clear">
											<span>금일 발생 오류</span>
											<em>5</em>
										</div>
										<div class="a_warning clear">
											<a href="#" class="btn">상세보기</a>
										</div>
									</div>
									<div class="alarm_notice">
										<ul>
											<li>
												<a href="javascript:list_detail_open('list3');">사업소#3 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">사업소#3 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">사업소#3 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">사업소#3 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">사업소#3 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_table">
									<div class="gtbl_top clear">
										<div class="upper clear">
											<input type="text" class="input fl" value="사업소">
											<button class="fl" type="submit">검색</button>
											<div class="check-option fr">
												<label><input type="checkbox"> 정상</label>
												<label><input type="checkbox"> 경고</label>
												<label><input type="checkbox"> 이상</label>
											</div>
										</div>
										<div class="lower fr">
											<span>페이지 당 표시:</span>
											<select name="" id="" class="sel">
												<option value="10">10</option>
												<option value="20">20</option>
												<option value="30">30</option>
												<option value="40">40</option>
												<option value="50">50</option>
												<option value="100">100</option>
											</select>
										</div>										
									</div>
									<div class="gtbl_wrap">
										<div class="intable">
											<table>
												<colgroup>
													<col>
													<col width="40">
													<col>
													<col>
													<col>
													<col>
													<col>
													<col>
													<col>
												</colgroup>
											    <thead>
											      <tr>
											      	<th><a href="">설비상태</a></span></th>
											      	<th><a href="">배터리</a></span></th>
											      	<th><a href="">오류</a></th>
											      	<th><a href="">경고</a></th>
											        <th style="text-align:left;"><a href="" class="sort_icon desc">사업소</a></th> <!-- asc [올림차순] -->
											        <th><a href="">설비용량</a></th>							        
											        <th><a href="">발전량</a></th>
											        <th><a href="">충전량</a></th>
											        <th><a href="">방전량</a></th>
											      </tr>
											    </thead>
											    <tbody>
											      <tr class="dbclickopen">
											        <td><span class="status status_err" title="통신이상">통신이상</span></td>
											        <td><!--<span class="battery_icon batter_in">충전</span>--></td>
											        <td>0</td>
											        <td>0</td>
											        <td><div class="cname">사업소#1</div></td>
												    <td>800</td>											        
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			<div class="type1">								      			
												      			<dl>
												      				<dt>
																		<div class="inchart">
																			<div id="type_chart1" style="height:130px"></div>
																			<script language="JavaScript">
																			$(function () {														
																				var pieChart = Highcharts.chart('type_chart1', {
																					chart: {
																						marginTop:0,
																						marginLeft:0,
																						marginRight:0,
																						backgroundColor: 'transparent',

																						plotBorderWidth: 0,
																						plotShadow: false
																					},

																					navigation: {
																						buttonOptions: {
																							enabled: false /* 메뉴 안보이기 */
																						}
																					},

																					title: {																
																				        text: '70%', // %표기
																				        align: 'center',
																				        verticalAlign: 'middle',
																				        y:10,
																				        x:0,
																				        style: {
																				            fontSize: '12px',
																				            color: 'var(--color3)'
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
																							//startAngle: -90,
																							//endAngle: 90,
																							center: ['50%', '50%'],
																							borderWidth: 0,
																							size: '100%'
																						}
																					},

																					series: [{
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
																							y: 70 //70% -- 아래로 총합 100%
																						}, {
																							color: '#84848f',
																							name: '미설비용량',
																							dataLabels: {
																								enabled: false
																							},
																							y: 30 //30% 나머지 
																						}]
																					}],
																					responsive: { // 반응형
																						rules: [{
																				            condition: {
																				                minWidth: 305
																				            },
																				            chartOptions: {					            	
																				            	title: {
																							        x:0,
																							        y:10,
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


																				});
																			});
																			</script>
																		</div>																			
												      				</dt>
												      				<dd>
												      					<div class="link"><a href="#" class="btn_cancel">대시보드 바로가기</a></div>
												      					<div class="di_top">
																      		<span class="sbj">사업소#1</span>
																      		<span class="type_img type_sun">태양광</span>
																      		<!--
																      		<span class="type_img type_wind">풍력</span>
																      		<span class="type_img type_water">소수력</span>
																      		<span class="type_img type_battery">배터리 룸</span>
																      		-->
																      		<span>일사량 <em>30</em>kWh/㎡․day </span>
																      		<span>현재온도 <em>30</em>℃</span>
																      		<span>현재습도 <em>65</em>%</span>
																      	</div>													      												      					
												      					<ul class="clear">
												      						<li class="clear">
												      							<span class="fl">총 설비용량</span>
												      							<span class="fl"><em>10</em>MW</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">총 인버터수량</span>
												      							<span class="fl"><em>30</em>EA</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 발전예측</span>
												      							<span class="fl"><em>28</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 누적발전</span>
												      							<span class="fl"><em>18.1</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">전일 누적발전</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">전일 발전매전</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      					</ul>
												      					<div class="error">
												      						<h2>최근 미처리 오류 : <span>2</span>건</h2>
												      						<div>
													      						<p>2020-02-10 12:00:01 데이터 disconnected</p>
													      						<p>2020-02-09 11:41:26 인버터#1 이상 감지</p>
												      						</div>
												      					</div>
												      				</dd>
												      			</dl>
											      			</div>
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen status_error">
											      	<td><span class="status status_drv" title="운전">운전</span></td>
											      	<td><span class="battery_icon batter_in">충전</span></td>
											      	<td>2</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#2</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			<div class="type2">								      			
												      			<dl>
												      				<dt>
																		<div class="inchart">
																			<div id="type_chart2" style="height:130px;"></div>
																			<script language="JavaScript">
																			$(function () {														
																				var pieChart2 = Highcharts.chart('type_chart2', {
																					chart: {
																						marginTop:0,
																						marginLeft:0,
																						marginRight:0,
																						backgroundColor: 'transparent',

																						plotBorderWidth: 0,
																						plotShadow: false
																					},

																					navigation: {
																						buttonOptions: {
																							enabled: false /* 메뉴 안보이기 */
																						}
																					},

																					title: {																
																				        text: '70%', // %표기
																				        align: 'center',
																				        verticalAlign: 'middle',
																				        y:10,
																				        x:0,
																				        style: {
																				            fontSize: '14px',
																				            color: 'var(--color3)'
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
																							//startAngle: -90,
																							//endAngle: 90,
																							center: ['50%', '50%'],
																							borderWidth: 0,
																							size: '100%'
																						}
																					},

																					series: [{
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
																							y: 70 //70% -- 아래로 총합 100%
																						}, {
																							color: '#84848f',
																							name: '미설비용량',
																							dataLabels: {
																								enabled: false
																							},
																							y: 30 //30% 나머지 
																						}]
																					}],
																					responsive: { // 반응형
																						rules: [{
																				            condition: {
																				                minWidth: 305
																				            },
																				            chartOptions: {					            	
																				            	title: {
																							        x:0,
																							        y:10,
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


																				});
																			});
																			</script>
																		</div>	
																		<div class="summ">
												      						<div class="soc">
												      							<div class="batt_wrap clear">
																					<div class="battery"><span style="width:30%;"><!--잔량--></span><em>30%</em></div>
																				</div>
												      						</div>
												      					</div>
												      				</dt>
												      				<dd>	
													      				<div class="link"><a href="#" class="btn_cancel">대시보드 바로가기</a></div>	
													      				<div class="di_top">
																      		<span class="sbj">사업소#2</span>
																      		<span class="type_img type_battery">배터리 룸</span>
																      		<span>배터리 룸 </span>
																      		<span>온도 <em>30</em>℃</span>
																      		<span>습도 <em>30</em>%</span>
																      	</div>											      					
												      					<ul class="clear">
												      						<li class="clear">
												      							<span class="fl">총 설비용량</span>
												      							<span class="fl"><em>10</em>MW / <em>20</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 충전예측</span>
												      							<span class="fl"><em>28</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 누적충전</span>
												      							<span class="fl"><em>18.1</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 방전예측</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 누적방전</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      					</ul>
												      					<div class="error">
												      						<h2>최근 미처리 오류 : <span>2</span>건</h2>
												      						<div>
													      						<p>2020-02-10 12:00:01 데이터 disconnected</p>
													      						<p>2020-02-09 11:41:26 인버터#1 이상 감지</p>
												      						</div>
												      					</div>
												      				</dd>
												      			</dl>
											      			</div>
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen">
											      	<td><span class="status status_drv" title="운전">운전</span></td>
											      	<td><span class="battery_icon batter_out">방전</span></td>
											      	<td>0</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#3</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info list3">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			<div class="type1">
												      			<dl>
												      				<dt>
																		<div class="inchart">
																			<div id="type_chart11" style="height:130px"></div>
																			<script language="JavaScript">
																			$(function () {														
																				var pieChart11 = Highcharts.chart('type_chart11', {
																					chart: {
																						marginTop:0,
																						marginLeft:0,
																						marginRight:0,
																						backgroundColor: 'transparent',

																						plotBorderWidth: 0,
																						plotShadow: false
																					},

																					navigation: {
																						buttonOptions: {
																							enabled: false /* 메뉴 안보이기 */
																						}
																					},

																					title: {																
																				        text: '70%', // %표기
																				        align: 'center',
																				        verticalAlign: 'middle',
																				        y:10,
																				        x:0,
																				        style: {
																				            fontSize: '12px',
																				            color: 'var(--color3)'
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
																							//startAngle: -90,
																							//endAngle: 90,
																							center: ['50%', '50%'],
																							borderWidth: 0,
																							size: '100%'
																						}
																					},

																					series: [{
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
																							y: 70 //70% -- 아래로 총합 100%
																						}, {
																							color: '#84848f',
																							name: '미설비용량',
																							dataLabels: {
																								enabled: false
																							},
																							y: 30 //30% 나머지 
																						}]
																					}],
																					responsive: { // 반응형
																						rules: [{
																				            condition: {
																				                minWidth: 305
																				            },
																				            chartOptions: {					            	
																				            	title: {
																							        x:0,
																							        y:10,
																							        style: {
																							            fontSize: '12px',
																													color: 'var(--color3)'
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


																				});
																			});
																			</script>
																		</div>	
												      				</dt>
												      				<dd>
													      				<div class="link"><a href="#" class="btn_cancel">대시보드 바로가기</a></div>	
													      				<div class="di_top">
																      		<span class="sbj">사업소#3</span>
																      		<span class="type_img type_sun">태양광</span>
																      		<!--
																      		<span class="type_img type_wind">풍력</span>
																      		<span class="type_img type_water">소수력</span>
																      		<span class="type_img type_battery">배터리 룸</span>
																      		-->
																      		<span>일사량 <em>30</em>kWh/㎡․day </span>
																      		<span>현재온도 <em>30</em>℃</span>
																      		<span>현재습도 <em>65</em>%</span>
																      	</div>								      					
												      					<ul class="clear">
												      						<li class="clear">
												      							<span class="fl">총 설비용량</span>
												      							<span class="fl"><em>10</em>MW</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">총 인버터수량</span>
												      							<span class="fl"><em>30</em>EA</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 발전예측</span>
												      							<span class="fl"><em>28</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 누적발전</span>
												      							<span class="fl"><em>18.1</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">전일 누적발전</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">전일 발전매전</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      					</ul>
												      					<div class="error">
												      						<h2>최근 미처리 오류 : <span>2</span>건</h2>
												      						<div>
													      						<p>2020-02-10 12:00:01 데이터 disconnected</p>
													      						<p>2020-02-09 11:41:26 인버터#1 이상 감지</p>
												      						</div>
												      					</div>												      					
												      				</dd>
												      			</dl>
											      			</div>
											      			<div class="type2">
																<dl>
												      				<dt>
																		<div class="inchart">
																			<div id="type_chart22" style="height:130px;"></div>
																			<script language="JavaScript">
																			$(function () {														
																				var pieChart22 = Highcharts.chart('type_chart22', {
																					chart: {
																						marginTop:0,
																						marginLeft:0,
																						marginRight:0,
																						backgroundColor: 'transparent',

																						plotBorderWidth: 0,
																						plotShadow: false
																					},

																					navigation: {
																						buttonOptions: {
																							enabled: false /* 메뉴 안보이기 */
																						}
																					},

																					title: {																
																				        text: '70%', // %표기
																				        align: 'center',
																				        verticalAlign: 'middle',
																				        y:10,
																				        x:0,
																				        style: {
																				            fontSize: '14px',
																				            color: 'var(--color3)'
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
																							//startAngle: -90,
																							//endAngle: 90,
																							center: ['50%', '50%'],
																							borderWidth: 0,
																							size: '100%'
																						}
																					},

																					series: [{
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
																							y: 70 //70% -- 아래로 총합 100%
																						}, {
																							color: '#84848f',
																							name: '미설비용량',
																							dataLabels: {
																								enabled: false
																							},
																							y: 30 //30% 나머지 
																						}]
																					}],
																					responsive: { // 반응형
																						rules: [{
																				            condition: {
																				                minWidth: 305
																				            },
																				            chartOptions: {					            	
																				            	title: {
																							        x:0,
																							        y:10,
																							        style: {
																							            fontSize: '12px',
																													color: 'var(--color3)'
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


																				});
																			});
																			</script>
																		</div>	
																		<div class="summ">
												      						<div class="soc">
												      							<div class="batt_wrap clear">
																					<div class="battery"><span style="width:30%;"><!--잔량--></span><em>30%</em></div>
																				</div>
												      						</div>
												      					</div>
												      				</dt>
												      				<dd>	
													      				<div class="di_top">
																      		<span class="sbj">사업소#2</span>
																      		<span class="type_img type_battery">배터리 룸</span>
																      		<span>배터리 룸 </span>
																      		<span>온도 <em>30</em>℃</span>
																      		<span>습도 <em>30</em>%</span>
																      	</div>									      					
												      					<ul class="clear">
												      						<li class="clear">
												      							<span class="fl">총 설비용량</span>
												      							<span class="fl"><em>10</em>MW / <em>20</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 충전예측</span>
												      							<span class="fl"><em>28</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 누적충전</span>
												      							<span class="fl"><em>18.1</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 방전예측</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      						<li class="clear">
												      							<span class="fl">금일 누적방전</span>
												      							<span class="fl"><em>20</em>MWh</span>
												      						</li>
												      					</ul>
												      					<div class="error">
												      						<h2>최근 미처리 오류 : <span>2</span>건</h2>
												      						<div>
													      						<p>2020-02-10 12:00:01 데이터 disconnected</p>
													      						<p>2020-02-09 11:41:26 인버터#1 이상 감지</p>
												      						</div>
												      					</div>
												      				</dd>
												      			</dl>
											      			</div>											      			
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen">
											      	<td><span class="status status_drv" title="운전">운전</span></td>
											      	<td><!--<span class="battery_icon batter_out">방전</span>--></td>
											      	<td>0</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#4</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen">
											      	<td><span class="status status_stp" title="정지">정지</span></td>
											      	<td><!--<span class="battery_icon batter_in">충전</span>--></td>
											      	<td>0</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#5</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen status_alert">
											      	<td><span class="status status_drv" title="운전">운전</span></td>
											      	<td><!--<span class="battery_icon batter_out">방전</span>--></td>
											      	<td>0</td>
											      	<td>1</td>
											        <td><div class="cname">사업소#6</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen">
											      	<td><span class="status status_drv" title="운전">운전</span></td>
											      	<td><!--<span class="battery_icon batter_in">충전</span>--></td>
											      	<td>0</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#7</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen">
											        <td><span class="status status_drv" title="운전">운전</span></td>
											        <td><!--<span class="battery_icon batter_in">충전</span>--></td>
											        <td>0</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#8</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen">
											      	<td><span class="status status_hld" title="대기">대기</span></td>
											      	<td><!--<span class="battery_icon batter_out">방전</span>--></td>
											      	<td>0</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#9</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			
											      		</div>
											      	</td>
											      </tr>
											      <tr class="dbclickopen">
											      	<td><span class="status status_drv" title="운전">운전</span></td>
											      	<td><!--span class="battery_icon batter_in">충전</span>--></td>
											      	<td>0</td>
											      	<td>0</td>
											        <td><div class="cname">사업소#10</div></td>
												    <td>800</td>
											        <td>500</td>
											        <td>13.2</td>
											        <td>12.1</td>
											      </tr>
											      <tr class="detail_info">
											      	<td colspan="9">
											      		<div class="di_wrap">
											      			
											      		</div>
											      	</td>
											      </tr>
											    </tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>