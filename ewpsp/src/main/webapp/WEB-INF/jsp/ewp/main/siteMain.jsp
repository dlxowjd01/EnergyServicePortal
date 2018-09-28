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
						<h1 class="page-header">롯데정밀화학</h1>
					</div>
				</div>
				<form id="schForm" name="schForm">
				<input type="hidden" id="selTermFrom" name="selTermFrom">
				<input type="hidden" id="selTermTo" name="selTermTo">
				<input type="hidden" id="selTerm" name="selTerm" value="day">
				<input type="hidden" id="selPeriodVal" name="selPeriodVal" value="hour">
				<input type="hidden" id="siteId" name="siteId" value="17094385">
				</form>
				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv alarm">
									<div class="chart_top clear">
										<h2 class="ntit fl">알람</h2>
										<div class="fr today_alarm">
											<div class="total">금일발생 <span id="todayTotalAlarmCnt">0</span></div>
											<div class="no"><span style="display: none;">0</span></div>
										</div>
									</div>
									<!-- no-data { -->
									<!-- <div class="no-data">
										<span>알람 정보를 가져올 수 없습니다.</span>
									</div> -->
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
											<li>
												<a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망. 메시지가 길면 절삭처리 됩니다. 메시지가 길면 절삭처리 됩니다.</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망.</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망.</a>
												<span>2018-08-12 11:41:26</span>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_soc">
									<div class="chart_top clear">
										<h2 class="ntit fl">SOC (잔량)</h2>
										<div class="time fr">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>SOC 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->
									<div class="soc mt15 clear">
										<div class="batt_wrap fl">
											<div class="battery"><span style="width:85.4%;">잔량</span></div>
											<div class="battery_per"><span>85.4<em>%</em></span></div>
										</div>
										<div class="charge_dis fr">
											<dl>
												<dt>오늘 충전량 <span id="socTodayCrg">1,350.5<em>kWh</em></span></dt>
												<dd>
													<div class="today_charge"><span style="width:80%;">충전량</span></div>
												</dd>
											</dl>
											<dl>
												<dt>오늘 방전량 <span id="socTodayDiscrg">1,124.7<em>kWh</em></span> </dt>
												<dd>
													<div class="today_discharge"><span style="width:70%;">방전량</span></div>
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
										<h2 class="ntit fl">사용량 구성 (DER)</h2>
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
											                return  '<b>' + this.series.name + '</b><br/>' + this.x + '<br/><span style="color:#438fd7">' + this.y + ' kwh</span>';
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
											        color: '#438fd7' /* 한전 사용량 */
											    },{
											        color: '#13af67' /* ESS 사용량 */
											    },{
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
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="der_datatable">
											    <thead>
											        <tr>
											            <th>2018-08</th>
											            <th>한전 사용량</th>
											            <th>ESS 사용량</th>
											            <th>PV 사용량</th>
											        </tr>
											    </thead>
											    <tbody>
											        <tr>
											            <th>1</th>
											            <td>50</td>
											            <td>400</td>
											            <td>100</td>										            
											        </tr>
											        <tr>
											            <th>2</th>
											            <td>300</td>
											            <td>500</td>
											            <td>300</td>										            
											        </tr>
											        <tr>
											            <th>3</th>
											            <td>200</td>
											            <td>550</td>
											            <td>150</td>										            
											        </tr>
											        <tr>
											            <th>4</th>
											            <td>400</td>
											            <td>540</td>
											            <td>550</td>										            
											        </tr>
											        <tr>
											            <th>5</th>
											            <td>300</td>
											            <td>550</td>
											            <td>300</td>										            
											        </tr>
											        <tr>
											            <th>6</th>
											            <td>500</td>
											            <td>520</td>
											            <td>450</td>										            
											        </tr>
											        <tr>
											            <th>7</th>
											            <td>400</td>
											            <td>530</td>
											            <td>500</td>										            
											        </tr>
											        <tr>
											            <th>8</th>
											            <td>300</td>
											            <td>750</td>
											            <td>500</td>										            
											        </tr>
											        <tr>
											            <th>9</th>
											            <td>450</td>
											            <td>800</td>
											            <td>400</td>										            
											        </tr>
											        <tr>
											            <th>10</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>11</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>12</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>13</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>14</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>15</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>16</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>17</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>18</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>19</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>20</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>21</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>22</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>23</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>24</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											    </tbody>
											</table>			
										</div>										
									</div>
									<div class="chart_footer">
										<ul class="clear">
											<li>현재 사용량 <span id="nowUsage">900kWh</span></li>
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
										<h2 class="ntit fl">피크전력현황</h2>
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
											                return  '<b>' + this.series.name + '</b><br/>' + this.x + '<br/><span style="color:#438fd7">' + this.y + ' kW</span>';
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
											        color: '#438fd7', /* 최대 피크 전력 */
											        type: 'column'
											    },{
											        color: '#13af67' /* 한전 계약 전력 */
											    },{
											        color: '#f75c4a' /* 요금 적용 전력 */
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
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="peak_datatable">
											    <thead>
											        <tr>
											            <th>2018-08</th>
											            <th>피크 전력</th>
											            <th>한전 계약 전력</th>
											            <th>요금 적용 전력</th>
											        </tr>
											    </thead>
											    <tbody>
											        <tr>
											            <th>1</th>
											            <td>0</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>2</th>
											            <td>150</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>3</th>
											            <td>10</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>4</th>
											            <td>210</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>5</th>
											            <td>125</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>6</th>
											            <td>50</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>7</th>
											            <td>30</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>8</th>
											            <td>50</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>9</th>
											            <td>125</td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>10</th>
											            <td></td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>11</th>
											            <td></td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>12</th>
											            <td></td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>13</th>
											            <td></td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>14</th>
											            <td></td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											        <tr>
											            <th>15</th>
											            <td></td>
											            <td>2000</td>
											            <td>500</td>
											        </tr>
											    </tbody>
											</table>			
										</div>									
									</div>									
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_device">
									<div class="chart_top clear">
										<h2 class="ntit fl">장치현황</h2>
										<div class="time fr" id="updtTimeDevice">2018-08-12 11:41:26</div>
									</div>
									<ul class="device clear" id="deviceList">
										<li class="pcs">
											<a href="#;"></a>
											<span class="dname">PCS_1</span>
											<span class="dmemo">텍스트 정보 텍스트 정보 텍스트 정보 텍스트 정보</span>
										</li>
										<li class="pcs alert">
											<a href="#;"></a>
											<span class="dname">PCS_2</span>
											<span class="dmemo">텍스트 정보</span>
										</li>
										<li class="bms">
											<a href="#;"></a>
											<span class="dname">BMS_1</span>
											<span class="dmemo">텍스트 정보</span>
										</li>
										<li class="bms">
											<a href="#;"></a>
											<span class="dname">BMS_2</span>
											<span class="dmemo">텍스트 정보</span>
										</li>
										<li class="ioe">
											<a href="#;"></a>
											<span class="dname">IOE_1</span>
											<span class="dmemo">텍스트 정보</span>
										</li>
										<li class="ioe">
											<a href="#;"></a>
											<span class="dname">IOE_2</span>
											<span class="dmemo">텍스트 정보</span>
										</li>
										<li class="ioe">
											<a href="#;"></a>
											<span class="dname">IOE_3</span>
											<span class="dmemo">텍스트 정보</span>
										</li>
										<li class="pv">
											<a href="#;"></a>
											<span class="dname">PV_1</span>
											<span class="dmemo">텍스트 정보</span>
										</li>
									</ul>
									<div class="paging clear">
										<a href="#;" class="prev">PREV</a>
										<span><strong>1</strong> / 3</span>
										<a href="#;" class="next">NEXT</a>
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
										<h2 class="ntit fl">수익현황</h2>
										<div class="time fr" id="updtTimeRevenue">2018-08-12 11:41:26</div>
									</div>
									<div class="inchart">
										<div id="income_chart" style="height:252px;"></div>
										<script language="JavaScript"> 
										$(function () { 
											var incomeChart = Highcharts.chart('income_chart', {
												data: {
											        table: 'income_datatable' /* 테이블에서 데이터 불러오기 */
											    },

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
											                return  '<b>' + this.series.name + '</b><br/>' + this.x + '<br/><span style="color:#438fd7">' + this.y + ' won</span>';
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
											        color: '#438fd7' /* ESS 수익 */
											    },{
											        color: '#13af67' /* DR 수익 */
											    },{
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
										});
										</script>
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="income_datatable">
											    <thead>
											        <tr>
											            <th></th>
											            <th>ESS 수익</th>
											            <th>DR 수익</th>
											            <th>PV 수익</th>
											        </tr>
											    </thead>
											    <tbody>
											        <tr>
											            <th>1</th>
											            <td>500</td>
											            <td>400</td>
											            <td>100</td>										            
											        </tr>
											        <tr>
											            <th>2</th>
											            <td>300</td>
											            <td>500</td>
											            <td>300</td>										            
											        </tr>
											        <tr>
											            <th>3</th>
											            <td>200</td>
											            <td>550</td>
											            <td>150</td>										            
											        </tr>
											        <tr>
											            <th>4</th>
											            <td>400</td>
											            <td>540</td>
											            <td>550</td>										            
											        </tr>
											        <tr>
											            <th>5</th>
											            <td>300</td>
											            <td>550</td>
											            <td>300</td>										            
											        </tr>
											        <tr>
											            <th>6</th>
											            <td>500</td>
											            <td>520</td>
											            <td>450</td>										            
											        </tr>
											        <tr>
											            <th>7</th>
											            <td>400</td>
											            <td>530</td>
											            <td>500</td>										            
											        </tr>
											        <tr>
											            <th>8</th>
											            <td>300</td>
											            <td>750</td>
											            <td>500</td>										            
											        </tr>
											        <tr>
											            <th>9</th>
											            <td>450</td>
											            <td>800</td>
											            <td>400</td>										            
											        </tr>
											        <tr>
											            <th>10</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>11</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>12</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>13</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>14</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>15</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>16</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>17</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>18</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>19</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>20</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>21</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>22</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>23</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											        <tr>
											            <th>24</th>
											            <td></td>
											            <td></td>
											            <td></td>										            
											        </tr>
											    </tbody>
											</table>			
										</div>										
									</div>
									<div class="chart_footer">
										<ul class="clear">
											<li>전체수익 <span>120,000 won</span></li>
										</ul>
									</div>									
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv charge">
									<div class="chart_top clear">
										<h2 class="ntit fl">충/방전량</h2>
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
											                return  '<b>' + this.series.name + '</b><br/>' + this.x + '<br/><span style="color:#438fd7">' + this.y + ' kWh</span>';
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
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="charge_datatable">
											    <thead>
											        <tr>
											            <th></th>
											            <th>충전량</th>
											            <th>충전 계획</th>
											            <th>방전량</th>
											            <th>방전 계획</th>
											        </tr>
											    </thead>
											    <tbody>
											        <tr>
											            <th>1</th>
											            <th>100</th>
											            <th>100</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>2</th>
											            <th>150</th>
											            <th>200</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>3</th>
											            <th>200</th>
											            <th>400</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>4</th>
											            <th>300</th>
											            <th>350</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>5</th>
											            <th>400</th>
											            <th>450</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>6</th>
											            <th>500</th>
											            <th>700</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>7</th>
											            <th>600</th>
											            <th>400</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>8</th>
											            <th>700</th>
											            <th>750</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>9</th>
											            <th>800</th>
											            <th>900</th>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>10</th>
											            <th></th>
											            <th></th>
											            <td>-900</td>
											            <td>-800</td>
											        </tr>
											        <tr>
											            <th>11</th>
											            <td></td>
											            <td></td>
											            <td>-800</td>
											            <td>-820</td>
											        </tr>
											        <tr>
											            <th>12</th>
											            <td></td>
											            <td></td>
											            <td>-700</td>
											            <td>-600</td>
											        </tr>
											        <tr>
											            <th>13</th>
											            <td></td>
											            <td></td>
											            <td>-500</td>
											            <td>-550</td>
											        </tr>
											        <tr>
											            <th>14</th>
											            <td></td>
											            <td></td>
											            <td>-400</td>
											            <td>-700</td>
											        </tr>
											        <tr>
											            <th>15</th>
											            <td></td>
											            <td></td>
											            <td>-300</td>
											            <td>-400</td>
											        </tr>
											        <tr>
											            <th>16</th>
											            <td></td>
											            <td></td>
											            <td>-200</td>
											            <td>-220</td>
											        </tr>
											        <tr>
											            <th>17</th>
											            <td></td>
											            <td></td>
											            <td>-100</td>
											            <td>-150</td>
											        </tr>
											        <tr>
											            <th>18</th>
											            <td></td>
											            <td></td>
											            <td>-50</td>
											            <td>-100</td>
											        </tr>
											        <tr>
											            <th>19</th>
											            <td>50</td>
											            <td>60</td>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>20</th>
											            <td>100</td>
											            <td>120</td>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>21</th>
											            <td>300</td>
											            <td>250</td>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>22</th>
											            <td></td>
											            <td></td>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>23</th>
											            <td></td>
											            <td></td>
											            <td></td>
											            <td></td>
											        </tr>
											        <tr>
											            <th>24</th>
											            <td></td>
											            <td></td>
											            <td></td>
											            <td></td>
											        </tr>
											    </tbody>
											</table>			
										</div>						
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
														<td id="todayCrg">1,350.5 kWh</td>
														<td id="todayDiscrg">850.5 kWh</td>
														<td id="todayRevenue">2.1</td>
													</tr>
													<tr>
														<th>THIS MONTH</th>
														<td id="monthCrg">8.9 MWh</td>
														<td id="monthDiscrg">12.1 MWh</td>
														<td id="monthRevenue">64.9</td>
													</tr>
													<tr>
														<th>THIS YEAR</th>
														<td id="yearCrg">58.9 MWh</td>
														<td id="yearDiscrg">192.1 MWh</td>
														<td id="yearRevenue">464.9</td>
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






    <!-- ###### 통합 명세서 Popup Start ###### -->
    <div id="layerbox" class="totaldprint" style="margin:250px 0 50px;">
        <div class="ltit">      	
			<a href="javascript:popupClose('totaldprint');">닫기</a>
        </div>
		<div class="lbody mt30">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;">
						(종합)에너지절감 솔루션 제공 전기요금 절감 수익 배분 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : 고객Site_1</td>
					<td height="30" align="right" style="font-size:12px;">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
						이번 달 청구 금액은 <strong style="color:#438fd7">37,938,260</strong>원 입니다
						<p style="padding-top:10px;font-size:12px;font-weight:normal;">(수익배분기간 : 2018-01-01 ~ 2018-12-31)</p>
					</td>
				</tr>
			</table>

			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%;">
					<h2>1. 전기요금 내역</h2>
					<table class="tbl" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th>기본요금</th>
								<td align="right">10,000</td>
							</tr>
							<tr>
								<th>전력량요금</th>
								<td align="right">2,000,000</td>
							</tr>
							<tr>
								<th>전기요금계</th>
								<td align="right">2,010,000</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">200,000</td>
							</tr>
							<tr>
								<th>전력기금</th>
								<td align="right">10,006</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">-6</td>
							</tr>
							<tr>
								<th>당월요금계</th>
								<td align="right">2,220,000</td>
							</tr>
							<tr>
								<th>미납요금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>&nbsp;</th>
								<td align="right">&nbsp;</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>청구금액</th>
								<td align="right">2,220,000</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div class="fr" style="width:49%;">
					<h2>2. 에너지 절감 솔루션 수익 분배 청구 내역 </h2>
					<table class="tbl" style="margin-top:10px;">
						<thead>
							<tr>
								<th>구분</th>
								<th>절감금액</th>
								<th>수익배분</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>①기본 요금 절감(피크저감)</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>②전려량 요금 절감(계시별)</th>
								<td align="right">3,188076</td>
								<td align="right">2,869,268</td>
							</tr>
							<tr>
								<th>③ESS 충전 요금 할인</th>
								<td align="right">2,227,088</td>
								<td align="right">2,004,379</td>
							</tr>
							<tr>
								<th>④ESS 전용 요금 할인</th>
								<td align="right">25,311,670</td>
								<td align="right">22,798,503</td>
							</tr>
							<tr>
								<th>총   계</th>
								<td align="right">30,746,834</td>
								<td align="right">27,672,151</td>
							</tr>
							<tr>
								<th colspan="2">수익배분 계</th>
								<td align="right">27,672,151</td>
							</tr>
							<tr>
								<th colspan="2">부가가치세</th>
								<td align="right">2,767,215</td>
							</tr>
							<tr>
								<th colspan="2">원단위절사</th>
								<td align="right">-6</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th colspan="2">청구금액</th>
								<td align="right">30,439,360</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%;">
					<h2>3. DR (수요반응) 수익 배분 청구 내역</h2>
					<table class="tbl" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>용량 정산금</th>
								<td align="right">900,000</td>
							</tr>
							<tr>
								<th>감축 정산금</th>
								<td align="right">100,000</td>
							</tr>
							<tr>
								<th>총 정산금액</th>
								<td align="right">1,000,000</td>
							</tr>
							<tr>
								<th>고객 정산 금액</th>
								<td align="right">800,000</td>
							</tr>
							<tr>
								<th>①수익배분 계</th>
								<td align="right">200,000</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">20,006</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">-6</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>청구금액</th>
								<td align="right">220,000</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div class="fr" style="width:49%;">
					<h2>4. PV 발전 수익 배분 청구 내역</h2>
					<table class="tbl" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>①REC 수익</th>
								<td align="right">12,775,000</td>
							</tr>
							<tr>
								<th>②SMP 수익</th>
								<td align="right">10,220,000</td>
							</tr>
							<tr>
								<th>③총 수익</th>
								<td align="right">22,995,000</td>
							</tr>
							<tr>
								<th>고객 정산 금액</th>
								<td align="right"></td>
							</tr>
							<tr>
								<th>④수익배분 계</th>
								<td align="right">4,599,000</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">459,906</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">-6</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>청구금액</th>
								<td align="right">5,058,900</td>
							</tr>
						</tfoot>
					</table>					
				</div>
			</div>
			<div class="clear" style="margin-top:20px;">
				<h2>5. 납입 정보</h2>
				<table class="tbl" style="margin-top:10px;">
					<colgroup>
						<col>
						<col width="25%">
					</colgroup>
					<tbody>
						<tr>
							<th>
								총 청구 금액<br/>
								(전기요금 + 에너지 절감 수익 배분 + DR 수익 배분 + PV 발전 수익 배분)
							</th>
							<td align="right"><span style="font-weight:bold;">37,938,260</span></td>
						</tr>
					</tbody>
				</table>
			</div>

		</div>
		<div class="lbutton mt40">
			<a href="#;" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="#;" class="lbtn_print"><span>인쇄</span></a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>






</body>
</html>