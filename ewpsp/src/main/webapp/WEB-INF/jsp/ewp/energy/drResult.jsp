<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/energy/drResult.js" type="text/javascript"></script>
</head>
<body>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="energy" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">DR 실적 현황</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">DR 실적 합계</h2>
							<ul class="chart_total">
								<li class="ct1">
									<div class="ctit ct1"><span>실제 사용량</span></div>
									<div class="cval" id="pastUseTot"><span>0</span>kWh</div>
								</li>
								<li>
									<div class="ctit"><span>감축량</span></div>
									<div class="cval" id="totalReduceAmt"><span>0</span>kWh</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv dr_chart">
							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="energy_drResult" name="schGbn"/>
							</jsp:include>
							<div class="inchart">
								<div id="chart2"></div>
								<script language="JavaScript"> 
// 								$(function () { 
									var myChart = Highcharts.chart('chart2', {
// 										data: {
// 									        table: 'datatable' /* 테이블에서 데이터 불러오기 */
// 									    },

										chart: {
											marginLeft:80,
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
												style: {
													color: '#3d4250',
													fontSize: '18px'
												}
											},
											tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
											title: {
												text: null
											},
											/* 기준선 */
											plotLines: [{
									            value: 9, /* 현재 */
									            color: '#438fd7',
									            width: 2,
									            zIndex: 0,
									            label: {
									                 text: ''
									            }
									        }]
											, crosshair: true // 08.22 이우람 추가
										},

										yAxis: {
											gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										    min: 0, /* 최소값 지정 */
										    title: {
										    	text: '(kWh)',
										    	align: 'low',
										    	rotation: 0, /* 타이틀 기울기 */
										        y:25, /* 타이틀 위치 조정 */
										        x:5, /* 타이틀 위치 조정 */
										        style: {
										            color: '#3d4250',
										            fontSize: '18px'
										        }
										    },
										    labels: {
										        overflow: 'justify',
										        x:-20, /* 그래프와의 거리 조정 */
										        style: {
										            color: '#3d4250',
										            fontSize: '18px'
										        }
										    }
										},									    

										/* 범례 */
										legend: {
											enabled: true,
											align:'right',
											verticalAlign:'top',
											x:0,										
											itemStyle: {
										        color: '#3d4250',
										        fontSize: '16px',
										        fontWeight: 400
										    },
										    itemHoverStyle: {
										        color: '' /* 마우스 오버시 색 */
										    },
										    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
										    symbolHeight:8 /* 심볼 크기 */
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
									        color: '#438fd7' /* 실제 사용량 */
									    }],

									    /* 반응형 */
									    responsive: {
									        rules: [{
									            condition: {
									               maxWidth: 414 /* 차트 사이즈 */									                
									            },
									            chartOptions: {
									            	chart: {
									            		marginLeft:60,
									            		marginTop:30
													},
													xAxis: {
														labels: {
															style: {
													            fontSize: '13px'
													        }
														}
													},
													yAxis: {
														title: {
															style: {
													            fontSize: '13px'
													        }
														},
														labels: {
															x:-10, /* 그래프와의 거리 조정 */
													        style: {
													            fontSize: '13px'
													        }
														}
													},
									                legend: {									                    
									                    layout: 'horizontal',
									                    verticalAlign: 'bottom',
									                    align:'center',
									                    x:0,
									                    itemStyle: {
												        	fontSize: '13px'
												    	}
									                }
									            }
									        }]
									    }

									});
// 								});
								</script>
							</div>	
						</div>
					</div>
				</div>
				<div class="row dr_chart_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">DR 실적 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn">데이터저장</a></li>
								</ul>
							</div>
							<div class="tbl_wrap">
								<div class="fold_div" id="pc_use_dataDiv">
									<!-- PC 버전용 테이블 -->
									<div class="chart_table">			
										<table class="dr_use">
											<thead>
												<tr>
													<th>감축일</th>
													<th>감축시간대</th>
													<th>사용량(kWh)</th>
													<th>고객기준부하(kW)</th>
													<th>계약용량(kWh)</th>
													<th>목표사용량(kWh)</th>
													<th>감축량(kWh)</th>
													<th>이행률(%)</th>
												</tr>
											</thead>
											<tbody id="drResultTbody">
												<tr>
													<td>2016-01-14</td>
													<td>16:00 ~ 17:00</td>
													<td>750</td>
													<td>5,000</td>
													<td>4,000</td>
													<td>1,000</td>
													<td>4,250</td>
													<td>106.25%</td>
												</tr>
												<tr>
													<td>2016-01-14</td>
													<td>17:00 ~ 18:00</td>
													<td>800</td>
													<td>5,500</td>
													<td>4,000</td>
													<td>1,500</td>
													<td>4,700</td>
													<td>117.50%</td>
												</tr>
											</tbody>
										</table>	
									</div>							
									<!-- 데이터 추출용 -->
									<div class="chart_table2" style="display:none;">			
										<table id="datatable">
										    <thead>
										        <tr>
										            <th>2018-08</th>
										            <th>실제 사용량</th>
										        </tr>
										    </thead>
										    <tbody>
										        <tr>
										            <th>1</th>
										            <td>200</td>
										        </tr>
										        <tr>
										            <th>2</th>
										            <td>400</td>
										        </tr>
										        <tr>
										            <th>3</th>
										            <td>300</td>
										        </tr>
										        <tr>
										            <th>4</th>
										            <td>650</td>
										        </tr>
										        <tr>
										            <th>5</th>
										            <td>480</td>
										        </tr>
										        <tr>
										            <th>6</th>
										            <td>1000</td>
										        </tr>
										        <tr>
										            <th>7</th>
										            <td>500</td>
										        </tr>
										        <tr>
										            <th>8</th>
										            <td>700</td>
										        </tr>
										        <tr>
										            <th>9</th>
										            <td>620</td>
										        </tr>
										        <tr>
										            <th>10</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>11</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>12</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>13</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>14</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>15</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>16</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>17</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>18</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>19</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>20</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>21</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>22</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>23</th>
										            <td></td>
										        </tr>
										        <tr>
										            <th>24</th>
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
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>

</body>
</html>