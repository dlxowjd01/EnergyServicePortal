<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/main/siteMain.js" type="text/javascript"></script>
</head>
<body>

	<!-- 메인페이지용 스타일 파일 -->
	<link href="../css/main.css" rel="stylesheet">

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="siteMain" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">${selViewSite.site_name }</h1>
					</div>
				</div>
				<form id="schForm" name="schForm">
				<input type="hidden" id="selTermFrom" name="selTermFrom">
				<input type="hidden" id="selTermTo" name="selTermTo">
				<input type="hidden" id="selTerm" name="selTerm" value="day">
				<input type="hidden" id="selPeriodVal" name="selPeriodVal" value="hour">
				<input type="hidden" id="siteId" name="siteId" value="${selViewSiteId }">
				<input type="hidden" id="selPageNum" name="selPageNum" value="">
				</form>
				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv alarm">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/control'" style="cursor: pointer;">알람</h2>
										<div class="fr today_alarm">
											<div class="total">금일발생 <span id="todayTotalAlarmCnt">0</span></div>
											<div class="no"><span style="display: none;">0</span></div>
										</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>알람 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->
									<div class="alarm_stat mt10 clear">
										<div class="a_alert clear">
											<span>ALERT</span> <em id="todayAlarmCnt">0</em>
										</div>
										<div class="a_warning clear">
											<span>WARNING</span> <em id="todayWarninfCnt">0</em>
										</div>
									</div>
									<div class="alarm_notice">
										<h2>최근 알람</h2>
										<ul>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_soc">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/essCharge'" style="cursor: pointer;">SOC (잔량)</h2>
										<div class="time fr">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>SOC 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->
									<div class="soc mt15 clear">
										<div class="batt_wrap fl">
											<div class="battery"><span>잔량</span></div>
											<div class="battery_per"></div>
										</div>
										<div class="charge_dis fr">
											<dl>
												<dt>오늘 충전량 <span id="socTodayCrg">0<em>kWh</em></span></dt>
												<dd>
													<div class="today_charge"><span style="width:0%;">충전량</span></div>
												</dd>
											</dl>
											<dl>
												<dt>오늘 방전량 <span id="socTodayDiscrg">0<em>kWh</em></span> </dt>
												<dd>
													<div class="today_discharge"><span style="width:0%;">방전량</span></div>
												</dd>
											</dl>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv der">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/derUsage'" style="cursor: pointer;">사용량 구성 (DER)</h2>
										<div class="time fr">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>사용량 구성 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->	
									<div class="inchart">
										<div id="der_chart" style="height:220px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var derChart = Highcharts.chart('der_chart', {
// 												data: {
// 											        table: 'der_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
													backgroundColor: 'transparent',
													type: 'area'
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
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													gridZIndex: 4, // 09.10 이우람 추가
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    min: 0, /* 최소값 지정 */
												    title: {
												    	text: '(kWh)',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
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
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' kwh</span>';
											            }
												},

												/* 옵션 */
												plotOptions: {
											        series: {
											            label: {
											                connectorAllowed: false
											            },
											            marker: {
															enabled: false
														}, // 09.11 이우람 추가
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
											    series: [{
											    	name: '한전 사용량',
											    	color: '#438fd7' /* 한전 사용량 */
											    },{
											    	name: 'ESS 사용량',
											        color: '#13af67' /* ESS 사용량 */
											    },{
											    	name: 'PV 사용량',
											        color: '#f75c4a' /* PV 사용량 */
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
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
// 										});
										</script>
									</div>
									<div class="chart_footer">
										<ul class="clear">
											<li>현재 사용량 <span id="nowUsage">0kWh</span></li>
											<li>한전 <span id="kepcoPer">0%</span></li>
											<li>ESS <span id="essPer">0%</span></li>
											<li>PV <span id="pvPer">0%</span></li>
										</ul>
									</div>
								</div>
							</div>
						</div>				
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv peak">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/peak'" style="cursor: pointer;">피크전력현황</h2>
										<div class="time fr" id="updtTimePeak">2018-08-12 11:41:26</div>
									</div>
									<div class="chart_notice">지금은 <strong>요금적용전력</strong> 갱신구간 입니다. <span>(08:00 ~ 12:00)</span></div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>피크전력현황 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->									
									<div class="inchart">
										<div id="peak_chart" style="height:250px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var peakChart = Highcharts.chart('peak_chart', {
// 												data: {
// 											        table: 'peak_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
													backgroundColor: 'transparent',
													type: 'line'
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
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    min: 0, /* 최소값 지정 */
												    title: {
												    	text: '(kW)',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
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
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' kW</span>';
											            }
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
											    series: [{
											        name: '최대 피크 전력',
											    	color: '#438fd7', /* 최대 피크 전력 */
											        type: 'column'
//											    },{
//											    	name: '한전 계약 전력',
//											    	color: '#13af67' /* 한전 계약 전력 */
//											    },{
//											    	name: '요금 적용 전력',
//											    	color: '#f75c4a' /* 요금 적용 전력 */
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
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
// 										});
										</script>
									</div>									
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_device">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/deviceMonitoring?deviceGbn=IOE'" style="cursor: pointer;">장치현황</h2>
										<div class="time fr" id="updtTimeDevice">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>장치현황 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->	
									<ul class="device clear" id="deviceList">
									</ul>
									<div class="paging clear" id="DevicePaging">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv income">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/essRevenue'" style="cursor: pointer;">수익현황</h2>
										<div class="time fr" id="updtTimeRevenue">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>수익현황 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->										
									<div class="inchart">
										<div id="income_chart" style="height:252px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var incomeChart = Highcharts.chart('income_chart', {
// 												data: {
// 											        table: 'income_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
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
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    min: 0, /* 최소값 지정 */
												    title: {
												    	text: 'won',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
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
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' won</span>';
											            }
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

												/* 출처 */
												credits: {
													enabled: false
												},

												/* 그래프 스타일 */
											    series: [{
											    	name: 'ESS 수익',
											    	color: '#438fd7' /* ESS 수익 */
											    },{
											    	name: 'DR 수익',
											        color: '#13af67' /* DR 수익 */
											    },{
											    	name: 'PV 수익',
											        color: '#f75c4a' /* PV 수익 */
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
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
// 										});
										</script>
									</div>
									<div class="chart_footer">
										<ul class="clear">
											<li>전체수익 <span id="totalRv">0 won</span></li>
										</ul>
									</div>									
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv charge">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/essCharge'" style="cursor: pointer;">충/방전량</h2>
										<div class="time fr">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display:none;">
										<span>충/방전량 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->								
									<div class="inchart">
										<div id="charge_chart" style="height:226px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var chargeChart = Highcharts.chart('charge_chart', {
// 												data: {
// 											        table: 'charge_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
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
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    title: {
												    	text: '(kWh)',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
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
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' kWh</span>';
											            }
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
											    series: [{
											    	type: 'column',
											        name: '충전량',
											        color: '#438fd7'
											    },{
											    	type: 'line',
											        name: '충전 계획',
											        color: '#13af67',
											        dashStyle: 'ShortDash'
											    },{
											    	type: 'column',
											        name: '방전량',
											        color: '#f75c4a'
											    },{
											    	type: 'line',
											        name: '방전 계획',
											        color: '#84848f',
											        dashStyle: 'ShortDash'
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
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
// 										});
										</script>
									</div>
									<div class="chart_footer">
										<div class="chart_table">
											<table class="main_use">
												<thead>
													<tr>
														<th>충/방전량</th>
														<th>충전량</th>
														<th>방전량</th>
														<th>수익</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<th>TODAY</th>
														<td id="todayCrg">0 kWh</td>
														<td id="todayDiscrg">0 kWh</td>
														<td id="todayRevenue">0</td>
													</tr>
													<tr>
														<th>THIS MONTH</th>
														<td id="monthCrg">0 MWh</td>
														<td id="monthDiscrg">0 MWh</td>
														<td id="monthRevenue">0</td>
													</tr>
													<tr>
														<th>THIS YEAR</th>
														<td id="yearCrg">0 MWh</td>
														<td id="yearDiscrg">0 MWh</td>
														<td id="yearRevenue">0</td>
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
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>






</body>
</html>