<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

	<script type="text/javascript">
	$(function(){ 
    	$("input[name='deviceStatus']").on("click", function() {
			var flag = $(this).is(":checked");
			var str = $(this).val();
			
			var $tbody = $(".intable").find('tbody');
			if(flag){
				if(str == "정상") $tbody.find('.flag1').css("display", "");
				if(str == "경고") $tbody.find('.flag2').css("display", "");
				if(str == "이상") $tbody.find('.flag3').css("display", "");
			} else {
				if(str == "정상") $tbody.find('.flag1').css("display", "none");
				if(str == "경고") $tbody.find('.flag2').css("display", "none");
				if(str == "이상") $tbody.find('.flag3').css("display", "none");
			}
			
        });
	});
    </script>

	<!-- 메인페이지용 스타일/스크립트 파일 -->
	<link type="text/css" href="/css/custom.css" rel="stylesheet">
	<script type="text/javascript" src="/js/modules/rounded-corners.js"></script>
	<script type="text/javascript" src="/js/jquery.rwdImageMaps.min.js"></script>

				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_pv emain clear">
									<div class="chart_top clear">
										<h2 class="ntit">연간 충/방전량(2020년)</h2>
									</div>
									<div class="inchart">
										<div id="echart1"></div>
										<script type="text/javascript">
										var chargeChart = Highcharts.chart('echart1', {
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
										    	lineColor: '#515562', /* 눈금선색 */
												tickColor: '#515562',
												gridLineColor: '#515562',
												plotLines: [{
											        color: '#515562',
											        width: 1
											    }],
											    labels: {
													align: 'center',
													y:27, /* 그래프와 거리 */
													style: {
														color: '#a4aebf',
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
										    	lineColor: '#515562', /* 눈금선색 */
												tickColor: '#515562',
												gridLineColor: '#515562',
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												plotLines: [{
											         color: '#515562',
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
										                color: '#ffffff',
												        fontSize: '12px'
										            }
										        },
										        labels: {
										            format: '{value}',
										            style: {
										                color: '#a4aebf',
												        fontSize: '12px'
										            }
										        }
										    }, { // Secondary yAxis
										    	lineColor: '#515562', /* 눈금선색 */
												tickColor: '#515562',
												gridLineColor: '#515562',
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												plotLines: [{
											         color: '#515562',
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
										                color: '#ffffff',
												        fontSize: '12px'
										            }
										        },
										        labels: {
										            format: '{value}',
										            style: {
										                color: '#a4aebf',
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
													  //stacking: 'normal' /*위로 쌓이는 막대  ,normal */
												}
										    },
										    series: [{
										        name: '충전량',
										        type: 'column',
										        color: '#438fd7',
										        data: [500, 500, 600, 300, 500, 600, 300, 500, 900, 600, 600, 500],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    }, {
										        name: '방전량',
										        type: 'column',
										        color: '#84848F',
										        data: [500, 100, 300, 700, 200, 200, 500, 200, 500, 800, 700, 800],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }
										    }, {
										        name: '수익',
										        type: 'spline',
										        dashStyle: 'ShortDash',
										        color: '#E85B30',
										        yAxis: 1, //두번째 Y축으로 사용
										        data: [100, 200, 300, 500, 200, 700, 300, 800, 400, 500, 300, 200],
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
											    }]
											}											
										});

										</script>				
									</div>
									<ul class="fr">
										<li>
											<div><strong>올해 누적 충전량</strong></div>
											<div><span>15.2</span><em>MWh</em></div>
											<div>▲(6,804)</div>
										</li>
										<li>
											<div><strong>올해 누적 방전량</strong></div>
											<div><span>14.4</span><em>MWh</em></div>
											<div>▼(13,481)</div>
										</li>
										<li>
											<div><strong>올해 누적 수익</strong></div>
											<div><span>6,804,300</span><em>￦</em></div>
											<div>▼(13,481)</div>
										</li>
									</ul>
								</div>
							</div>
						</div>						
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_pv emain clear">
									<div class="chart_top clear">
										<h2 class="ntit">월간 충/방전량(2020.09)</h2>
									</div>
									<div class="inchart">
										<div id="echart2"></div>
										<script type="text/javascript">
										var chargeChart = Highcharts.chart('echart2', {
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
										    	lineColor: '#515562', /* 눈금선색 */
												tickColor: '#515562',
												gridLineColor: '#515562',
												plotLines: [{
											        color: '#515562',
											        width: 1
											    }],
											    labels: {
													align: 'center',
													y:27, /* 그래프와 거리 */
													style: {
														color: '#a4aebf',
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
										    	lineColor: '#515562', /* 눈금선색 */
												tickColor: '#515562',
												gridLineColor: '#515562',
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												plotLines: [{
											         color: '#515562',
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
										                color: '#ffffff',
												        fontSize: '12px'
										            }
										        },
										        labels: {
										            format: '{value}',
										            style: {
										                color: '#a4aebf',
												        fontSize: '12px'
										            }
										        }
										    }, { // Secondary yAxis
										    	lineColor: '#515562', /* 눈금선색 */
												tickColor: '#515562',
												gridLineColor: '#515562',
												gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												plotLines: [{
											         color: '#515562',
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
										                color: '#ffffff',
												        fontSize: '12px'
										            }
										        },
										        labels: {
										            format: '{value}',
										            style: {
										                color: '#a4aebf',
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
													  //stacking: 'normal' /*위로 쌓이는 막대  ,normal */
												}
										    },
										    series: [{
										        name: '충전량',
										        type: 'column',
										        color: '#438fd7',
										        data: [50, 50, 60, 30, 50, 60, 30, 50, 90, 60, 60, 50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    }, {
										        name: '방전량',
										        type: 'column',
										        color: '#84848F',
										        yAxis: 1,
										        data: [40, 30, 50, 70, 60, 80, 50, 70, 60, 40, 30, 20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }
										    }, {
										        name: '수익',
										        type: 'spline',
										        dashStyle: 'ShortDash',
										        color: '#E85B30',
										        yAxis: 1, //두번째 Y축으로 사용
										        data: [30, 40, 50, 70, 60, 80, 50, 70, 60, 40, 30, 20,,,,,,,,,,,,,,,,,,],
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
											    }]
											}											
										});

										</script>				
									</div>
									<ul class="fr">
										<li>
											<div><strong>이번달 누적 충전량</strong></div>
											<div><span>2.1</span><em>MWh</em></div>
											<div>▲(6,804)</div>
										</li>
										<li>
											<div><strong>이번달 누적 방전량</strong></div>
											<div><span>11.4</span><em>MWh</em></div>
											<div>▼(13,481)</div>
										</li>
										<li>
											<div><strong>이번달 누적 수익</strong></div>
											<div><span>304,300</span><em>￦</em></div>
											<div>▼(13,481)</div>
										</li>
									</ul>
								</div>
							</div>
						</div>				
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_map smain_circle emain">
									<div class="chart_top clear">
										<h2 class="ntit">${siteName }<c:if test="${empty siteName }">동국제강</c:if></h2>
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
														        text: '70%', // % 표기
														        align: 'center',
														        verticalAlign: 'middle',
														        y:0,
														        x:-20,
														        style: {
														            fontSize: '14px',
														            color: 'white'
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
																	startAngle: -90,
																	endAngle: 90,
																	center: ['40%', '50%'],
																	borderWidth: 0,
																	size: '100%'
																}
															},

															series: [{
																type: 'pie',
																innerSize: '50%',
																name: '출력용량',
																colorByPoint: true,
																data: [{
																	color: '#438fd7',
																	name: '현재출력',
																	dataLabels: {
														                enabled: false
														            },
																	y: 70 //70% -- 아래로 총합 100%
																}, {
																	color: '#84848f',
																	name: '미사용량',
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
											<div class="ci_center ct1">
												<dl>
													<dt>현재출력</dt>
													<dd><span>65</span><em>MWh</em></dd>
												</dl>
												<dl>
													<dt>총출력</dt>
													<dd><span>65</span><em>MWh</em></dd>
												</dl>
											</div>
											<div class="ci_right">
												<div class="soc">
													<h2>SOC(잔량)</h2>
													<div class="batt_wrap">
														<div class="battery"><span style="width:85.4%;"><!--잔량--></span></div>
														<div class="battery_per"><span><em>85.4</em>%</span></div>
													</div>
												</div>
											</div>
											<div class="ci_center ct2">
												<dl>
													<dt>총용량</dt>
													<dd><span>250</span><em>MWh</em></dd>
												</dl>
											</div>
										</div>										
									</div>	
									<div class="local_info emain s_center">
										<table>
											<thead>
												<tr>
													<th>오늘 누적 충전량</th>
													<th>오늘 충전 계획</th>
													<th>오늘 누적 방전량</th>
													<th>오늘 방전 계획</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span>150</span>MWh</td>
													<td><span>150</span>MWh</td>
													<td><span>150</span>MWh</td>
													<td><span>150</span>MWh</td>
												</tr>
											</tbody>
										</table>
									</div>							
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_map smain_circle emain">
									<div class="chart_top clear">
										<h2 class="ntit">금일 충/방전현황</h2>
									</div>
									<div class="sa_wrap">
										<div class="inchart">
											<div id="echart4"></div>
											<script language="JavaScript">
											$(function () { 
												var saChart4 = Highcharts.chart('echart4', {
													data: {
												        table: 'edatatable4' /* 테이블에서 데이터 불러오기 */
												    },

													chart: {
														marginTop:40,
														marginLeft:50,
														marginRight:0,
														backgroundColor: 'transparent',
														type: 'column',
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
															y:27, /* 그래프와 거리 */
															style: {
																color: '#a4aebf',
																fontSize: '12px'
															}
														},
														tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
														title: {
															text: null
														},
														crosshair: true
													},

													yAxis: {
														lineColor: '#515562', /* 눈금선색 */
														tickColor: '#515562',
														gridLineColor: '#515562',
														plotLines: [{
												            color: '#515562',
												            width: 1
												        }],
														gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
													    //min: 0, /* 최소값 지정 하면 + 만 나옴 */
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
												        shared: true
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
															  //stacking: 'normal' /*위로 쌓이는 막대  ,normal */
														}
												    },

													/* 출처 */
													credits: {
														enabled: false
													},

													/* 그래프 스타일 */
												    series: [{
												    	type: 'column',
												        name: '충전',
												        color: '#438fd7', /* 충전 */
												        tooltip: {
												            valueSuffix: 'kWh'
												        }
												    },{
												    	type: 'column',
												        name: '방전',
												        color: '#84848F', /* 방전 */
												        tooltip: {
												            valueSuffix: 'kWh'
												        }
												    },{
												    	type: 'spline',
												        name: '충전계획',
												        color: '#438fd7', /* 충전계획 */
										        		dashStyle: 'ShortDash',
										        		tooltip: {
												            valueSuffix: 'kWh'
												        }
												    },{
												    	type: 'spline',
												        name: '방전계획',
												        color: '#84848F', /* 방전계획 */
										        		dashStyle: 'ShortDash',
										        		tooltip: {
												            valueSuffix: 'kWh'
												        }
												    }],

												    /* 반응형 */
													responsive: {
													    rules: [{
													        condition: {
													            minWidth: 870 /* 차트 사이즈 */									                
													        },
													        chartOptions: {
													        	chart: {
																	marginLeft:75
																},
																xAxis: {
																	labels: {
																        style: {
																            fontSize: '18px'
																        }
																	}
																},
																yAxis: {
																	title: {
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
																legend: {									
																	itemStyle: {
																        fontSize: '18px'
																    },
																    symbolPadding:5,
																    symbolHeight:10
																}
													        }
													    }]
													}

												});
											});
											</script>
											<!-- 데이터 추출용 -->
											<div class="chart_table" style="display:none;">			
												<table id="edatatable4">
												    <thead>
												        <tr>
												            <th></th>
												            <th>충전</th>
												            <th>방전</th>
												            <th>충전계획</th>
												            <th>방전계획</th>
												        </tr>
												    </thead>
												    <tbody>
												        <tr>
												            <th>1</th>
												            <td>500</td>
												            <td></td>	
												            <td>550</td>								            
												            <td></td>
												        </tr>
												        <tr>
												            <th>2</th>
												            <td>600</td>
												            <td></td>
												            <td>650</td>								            
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>3</th>
												            <td>520</td>
												            <td></td>
												            <td>550</td>								            
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>4</th>
												            <td>550</td>
												            <td></td>	
												            <td>590</td>								            
												            <td></td>									            
												        </tr>
												        <tr>
												            <th>5</th>
												            <td>560</td>
												            <td></td>	
												            <td>650</td>								            
												            <td></td>									            
												        </tr>
												        <tr>
												            <th>6</th>
												            <td>570</td>
												            <td></td>	
												            <td>700</td>								            
												            <td></td>									            
												        </tr>
												        <tr>
												            <th>7</th>
												            <td></td>
												            <td>-590</td>	
												            <td></td>									            
												            <td>-650</td>
												        </tr>
												        <tr>
												            <th>8</th>
												            <td></td>
												            <td>-600</td>	
												            <td></td>									            
												            <td>-750</td>									            
												        </tr>
												        <tr>
												            <th>9</th>
												            <td></td>
												            <td>-620</td>	
												            <td></td>									            
												            <td>-680</td>									            
												        </tr>
												        <tr>
												            <th>10</th>
												            <td></td>
												            <td>-640</td>	
												            <td></td>									            
												            <td>-780</td>									            
												        </tr>
												        <tr>
												            <th>11</th>
												            <td></td>
												            <td>-630</td>	
												            <td></td>									            
												            <td>-710</td>									            
												        </tr>
												        <tr>
												            <th>12</th>
												            <td></td>
												            <td>-650</td>	
												            <td></td>									            
												            <td>-660</td>									            
												        </tr>
												        <tr>
												            <th>13</th>
												            <td></td>
												            <td>-770</td>
												            <td></td>									            
												            <td>-850</td>										            
												        </tr>
												        <tr>
												            <th>14</th>
												            <td></td>
												            <td>-780</td>	
												            <td></td>									            
												            <td>-950</td>									            
												        </tr>
												        <tr>
												            <th>15</th>
												            <td></td>
												            <td>-850</td>	
												            <td></td>									            
												            <td>-950</td>									            
												        </tr>
												        <tr>
												            <th>16</th>
												            <td></td>
												            <td>-840</td>	
												            <td></td>									            
												            <td>-990</td>									            
												        </tr>
												        <tr>
												            <th>17</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>18</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>19</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>20</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>21</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>22</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>23</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												        <tr>
												            <th>24</th>
												            <td></td>
												            <td></td>										            
												        </tr>
												    </tbody>
												</table>			
											</div>										
										</div>																			
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv emain">
									<div class="chart_top clear">
										<h2 class="ntit">시스템 충/방전 제어</h2>
										<div class="not_top fr">
											<span class="st1">운전모드 <em>자동</em></span>
											<span class="st2">화제경보</span>
											<span class="st3">비상정지</span>
										</div>
									</div>
									<dl class="scontrol">
										<dd>
											<ul>
												<li>
													<table>
														<tr>
															<td>
																<div class="pcs">
																	<div class="sbj clear">
																		PCS#1(1,000kW)
																		<span class="fr">STOP</span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_pcs">PCS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>충방상태</th>
																					<td>없음</td>
																				</tr>
																				<tr>
																					<th>지령값</th>
																					<td>0.000MW</td>
																				</tr>
																				<tr>
																					<th>유효전력</th>
																					<td>0.000MW</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
															</td>
															<td>
																<div class="bms">
																	<div class="sbj clear">
																		BMS#1(1,000kW)
																		<span class="fr">STOP</span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_bms">BMS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>운전상태</th>
																					<td>idle</td>
																				</tr>
																				<tr>
																					<th>SOC</th>
																					<td>23.20%</td>
																				</tr>
																				<tr>
																					<th>Cell 온도</th>
																					<td>23.05℃</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
															</td>
														</tr>
													</table>
												</li>
												<li>
													<table>
														<tr>
															<td>
																<div class="pcs">
																	<div class="sbj clear">
																		PCS#2(1,000kW)
																		<span class="fr"></span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_pcs">PCS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>충방상태</th>
																					<td>없음</td>
																				</tr>
																				<tr>
																					<th>지령값</th>
																					<td>0.000MW</td>
																				</tr>
																				<tr>
																					<th>유효전력</th>
																					<td>0.000MW</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
															</td>
															<td>
																<div class="bms">
																	<div class="sbj clear">
																		BMS#2(2,000kW)
																		<span class="fr"></span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_bms">BMS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>운전상태</th>
																					<td>idle</td>
																				</tr>
																				<tr>
																					<th>SOC</th>
																					<td>23.20%</td>
																				</tr>
																				<tr>
																					<th>Cell 온도</th>
																					<td>23.05℃</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
																<div class="bms">
																	<div class="sbj clear">
																		BMS#2(2,000kW)
																		<span class="fr"></span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_bms">BMS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>운전상태</th>
																					<td>idle</td>
																				</tr>
																				<tr>
																					<th>SOC</th>
																					<td>23.20%</td>
																				</tr>
																				<tr>
																					<th>Cell 온도</th>
																					<td>23.05℃</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
																<div class="bms">
																	<div class="sbj clear">
																		BMS#2(2,000kW)
																		<span class="fr"></span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_bms">BMS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>운전상태</th>
																					<td>idle</td>
																				</tr>
																				<tr>
																					<th>SOC</th>
																					<td>23.20%</td>
																				</tr>
																				<tr>
																					<th>Cell 온도</th>
																					<td>23.05℃</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
															</td>
														</tr>
													</table>
												</li>
												<li>
													<table>
														<tr>
															<td>
																<div class="pcs">
																	<div class="sbj clear">
																		PCS#3(1,000kW)
																		<span class="fr">STOP</span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_pcs">PCS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>충방상태</th>
																					<td>없음</td>
																				</tr>
																				<tr>
																					<th>지령값</th>
																					<td>0.000MW</td>
																				</tr>
																				<tr>
																					<th>유효전력</th>
																					<td>0.000MW</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
															</td>
															<td>
																<div class="bms">
																	<div class="sbj clear">
																		BMS#3(1,000kW)
																		<span class="fr">STOP</span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_bms">BMS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>운전상태</th>
																					<td>idle</td>
																				</tr>
																				<tr>
																					<th>SOC</th>
																					<td>23.20%</td>
																				</tr>
																				<tr>
																					<th>Cell 온도</th>
																					<td>23.05℃</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
																<div class="bms">
																	<div class="sbj clear">
																		BMS#3(1,000kW)
																		<span class="fr">STOP</span>
																	</div>
																	<div class="cont clear">
																		<div class="tfl">
																			<span class="ic_bms">BMS 아이콘</span>
																		</div>
																		<div class="tfr">
																			<table>
																				<tr>
																					<th>운전상태</th>
																					<td>idle</td>
																				</tr>
																				<tr>
																					<th>SOC</th>
																					<td>23.20%</td>
																				</tr>
																				<tr>
																					<th>Cell 온도</th>
																					<td>23.05℃</td>
																				</tr>
																			</table>
																		</div>
																	</div>
																</div>
															</td>
														</tr>
													</table>
												</li>
											</ul>
										</dd>
									</dl>
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
											<a href="#" class="btn cancel_btn">상세보기</a>
										</div>
									</div>
									<div class="alarm_notice">
										<ul>
											<li>
												<a href="javascript:list_detail_open('list3');">동국제강 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">동국제강 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">동국제강 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">동국제강 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">동국제강 - 인버터21 발전 정지</a>
												<span>2018-08-12 11:41:26</span>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_table smain">
									<div class="gtbl_top clear">
										<div class="fl">
											<span>키워드</span>
											<input type="text" class="input" value="">
											<button type="submit">적용</button>
											<div class="check-option">
												<label><input type="checkbox" name="deviceStatus" value="정상" checked> 정상</label>
												<label><input type="checkbox" name="deviceStatus" value="경고" checked> 경고</label>
												<label><input type="checkbox" name="deviceStatus" value="이상" checked> 이상</label>
											</div>
										</div>									
									</div>
									<ul class="type_list">
										<li>
											<div class="chart_top clear">
												<h2 class="ntit">PCS(10)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상 9</span> 
													<span class="inv_error">이상 1</span>
													<span class="inv_alert">경고 2</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="local_info smain">
													<table>
														<colgroup>
															<col>
															<col>
															<col>
															<col>
														</colgroup>
														<thead>
															<tr>
																<th>순시 출력</th>
																<th>캐비닛 온도 최대/최소</th>
																<th>금일 누적 충전량</th>
																<th>금일 누적 방전량</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td><span>85</span>kW</td>
																<td><span>42/25</span>℃</td>
																<td><span>3</span>MWh</td>
																<td><span>5</span>MWh</td>
															</tr>
														</tbody>
													</table>
												</div>									
												<div class="gtbl_wrap">										
													<div class="intable">
														<table>
															<colgroup>
																<col>
																<col>
																<col>
																<col>
																<col>
																<col>
															</colgroup>
															<thead>
																<tr>
																	<th>상태</th>
																	<th>설비명</th>
																	<th>출력</th>
																	<th>금일누적충전</th>
																	<th>금일누적방전</th>
																	<th>온도</th>
																</tr>
															</thead>
															<tbody>
																<tr class="flag1">
																	<td>정상</td>
																	<td>PCS#1</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag2">
																	<td>경고</td>
																	<td>PCS#2</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>PCS#3</td>
																	<td>1,000kWh</td>
																	<td>585kWh</td>
																	<td>152kWh</td>
																	<td>30℃</td>
																</tr>
															</tbody>
														</table>
													</div>
												</div>
											</div>
										</li>
										<li>
											<div class="chart_top clear">
												<h2 class="ntit">BMS(10)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상 8</span> 
													<span class="inv_error">이상 1</span>
													<span class="inv_alert">경고 1</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="local_info smain">
													<table>
														<colgroup>
															<col>
															<col>
															<col>
														</colgroup>
														<thead>
															<tr>
																<th>평균 SOC</th>
																<th>최고 온도</th>
																<th>최저 온도</th>
																<th>DC 전력</th>
																<th>최대 전압</th>
																<th>최소 전압</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td><span>85</span>%</td>
																<td><span>50</span>℃</td>
																<td><span>35</span>℃</td>
																<td><span>185</span>kW</td>
																<td><span>55</span>V</td>
																<td><span>85</span>V</td>
															</tr>
														</tbody>
													</table>
												</div>	
											</div>
										</li>
										<li>
											<div class="chart_top clear">
												<h2 class="ntit">계량기(18)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상 18</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="local_info smain">
													<table>
														<colgroup>
															<col>
															<col>
															<col>
															<col>
														</colgroup>
														<thead>
															<tr>
																<th>순시 유효 전력</th>
																<th>금일 누적 전력</th>
																<th>순시 무효 전력</th>
																<th>금일 누적 무효 전력</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td><span>85</span>kW</td>
																<td><span>85</span>kWh</td>
																<td><span>85</span>kW</td>
																<td><span>85</span>kWh</td>
															</tr>
														</tbody>
													</table>
												</div>	
											</div>
										</li>
										<li>
											<div class="chart_top clear">
												<h2 class="ntit">환경센서(2)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상 2</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="local_info smain">
													<table>
														<colgroup>
															<col>
															<col>
															<col>
															<col>
															<col>
															<col>
														</colgroup>
														<thead>
															<tr>
																<th>기온</th>
																<th>풍속</th>
																<th>경사일사량</th>
																<th>강수량</th>
																<th>평균 습도</th>
																<th>수평일사량</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td><span>15.4</span>℃</td>
																<td><span>10.1</span>km/h</td>
																<td><span>45</span>kWh/㎡․day</td>
																<td><span>0</span>mm</td>
																<td><span>47</span>%</td>
																<td><span>40</span>kWh/㎡․day</td>
															</tr>
														</tbody>
													</table>
												</div>	
											</div>
										</li>
									</ul>																									
								</div>
							</div>
						</div>
					</div>
				</div>