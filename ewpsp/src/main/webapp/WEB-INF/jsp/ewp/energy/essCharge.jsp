<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<!-- <script src="../js/energy/essCharge.js" type="text/javascript"></script> -->
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
						<h1 class="page-header">ESS 충•방전량 조회</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">충•방전량 합계</h2>
							<ul class="chart_total">
								<li class="es1">
									<div class="ctit es1"><span>충전량</span></div>
									<div class="cval"><span>14,976</span>kWh</div>
								</li>
								<li class="es2">
									<div class="ctit es2"><span>충전 계획</span></div>
									<div class="cval"><span>20,976</span>kWh</div>
								</li>
								<li class="es3">
									<div class="ctit es3"><span>방전량</span></div>
									<div class="cval"><span>20,976</span>kWh</div>
								</li>
								<li class="es4">
									<div class="ctit es4"><span>방전 계획</span></div>
									<div class="cval"><span>20,976</span>kWh</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv ess_chart">
							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="energy" name="schGbn"/>
							</jsp:include>
							<div class="inchart">
								<div class="chart_type">
									<a href="#;" class="chart_change_column">그래프변경</a>
									<a href="#;" class="chart_change_line" style="display:none;">그래프변경</a>
								</div>
								<div id="chart2"></div>
								<script language="JavaScript"> 
								$(function () { 
									var myChart = Highcharts.chart('chart2', {
										data: {
									        table: 'datatable' /* 테이블에서 데이터 불러오기 */
									    },

										chart: {
											marginLeft:80,
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
									            value: 21, /* 현재 */
									            color: '#438fd7',
									            width: 2,
									            zIndex: 0,
									            label: {
									                 text: ''
									            }
									        }]
										},

										yAxis: {
											gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										    title: {
										    	text: '(kWh)',
										    	align: 'low',
										    	rotation: 0, /* 타이틀 기울기 */
										        y:25, /* 타이틀 위치 조정 */
										        x:25, /* 타이틀 위치 조정 */
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
											x:-120,										
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
									                maxWidth: 414 /* 차트 사이즈 */									                
									            },
									            chartOptions: {
									            	chart: {
									            		marginLeft:60,
														marginTop:80
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

									},
									/* 차트 변경 */
							        function (myChart) {
							            $('.chart_change_column').click(function () {
							                $(this).hide();
							                $('.chart_change_line').show();
							                myChart.series[1].update({
							                    type: "column"
							                });
							                myChart.series[3].update({
							                    type: "column"
							                });

							            });
							            $('.chart_change_line').click(function () {
							            	$(this).hide();
							            	$('.chart_change_column').show();
							                myChart.series[1].update({
							                    type: "line"
							                });
							                myChart.series[3].update({
							                    type: "line"
							                });

							            });
							        });
								});
								</script>
							</div>	
						</div>
					</div>
				</div>
				<div class="row ess_chart_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">충•방전량 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn">데이터저장</a></li>
									<li><a href="#;" class="fold_btn">표접기</a></li>
								</ul>
							</div>
							<div class="tbl_wrap">
								<div class="fold_div">
									<!-- PC 버전용 테이블 -->
									<div class="chart_table">			
										<table class="pc_use">
											<thead>
												<tr>
													<th>2018-08</th>
													<th>1</th>
													<th>2</th>
													<th>3</th>
													<th>4</th>
													<th>5</th>
													<th>6</th>
													<th>7</th>
													<th>8</th>
													<th>9</th>
													<th>10</th>
													<th>11</th>
													<th>12</th>
													<th>13</th>
													<th>14</th>
													<th>15</th>
													<th>16</th>
													<th>17</th>
													<th>18</th>
													<th>19</th>
													<th>20</th>
													<th>21</th>
													<th>22</th>
													<th>23</th>
													<th>24</th>
													<th>합계</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th><div class="ctit es1"><span>충전량</span></div></th>
													<td>100</td>
													<td>150</td>
													<td>200</td>
													<td>300</td>
													<td>400</td>
													<td>500</td>
													<td>600</td>
													<td>700</td>
													<td>800</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>50</td>
													<td>100</td>
													<td>300</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th><div class="ctit es2"><span>충전 계획</span></div></th>
													<td>100</td>
													<td>200</td>
													<td>400</td>
													<td>350</td>
													<td>450</td>
													<td>700</td>
													<td>400</td>
													<td>750</td>
													<td>900</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>60</td>
													<td>120</td>
													<td>250</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th><div class="ctit es3"><span>방전량</span></th>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>-900</td>
													<td>-800</td>
													<td>-700</td>
													<td>-500</td>
													<td>-400</td>
													<td>-300</td>
													<td>-200</td>
													<td>-100</td>
													<td>-50</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th><div class="ctit es4"><span>방전 계획</span></th>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>-800</td>
													<td>-820</td>
													<td>-600</td>
													<td>-550</td>
													<td>-700</td>
													<td>-400</td>
													<td>-220</td>
													<td>-150</td>
													<td>-100</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
											</tbody>
										</table>	
									</div>
									<div class="chart_table">			
										<table class="pc_use">
											<thead>
												<tr>
													<th>2018-08</th>
													<th>1</th>
													<th>2</th>
													<th>3</th>
													<th>4</th>
													<th>5</th>
													<th>6</th>
													<th>7</th>
													<th>8</th>
													<th>9</th>
													<th>10</th>
													<th>11</th>
													<th>12</th>
													<th>13</th>
													<th>14</th>
													<th>15</th>
													<th>16</th>
													<th>17</th>
													<th>18</th>
													<th>19</th>
													<th>20</th>
													<th>21</th>
													<th>22</th>
													<th>23</th>
													<th>24</th>
													<th>합계</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th><div class="ctit es1"><span>충전량</span></div></th>
													<td>100</td>
													<td>150</td>
													<td>200</td>
													<td>300</td>
													<td>400</td>
													<td>500</td>
													<td>600</td>
													<td>700</td>
													<td>800</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>50</td>
													<td>100</td>
													<td>300</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th><div class="ctit es2"><span>충전 계획</span></div></th>
													<td>100</td>
													<td>200</td>
													<td>400</td>
													<td>350</td>
													<td>450</td>
													<td>700</td>
													<td>400</td>
													<td>750</td>
													<td>900</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>60</td>
													<td>120</td>
													<td>250</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th><div class="ctit es3"><span>방전량</span></th>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>-900</td>
													<td>-800</td>
													<td>-700</td>
													<td>-500</td>
													<td>-400</td>
													<td>-300</td>
													<td>-200</td>
													<td>-100</td>
													<td>-50</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th><div class="ctit es4"><span>방전 계획</span></th>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td>-800</td>
													<td>-820</td>
													<td>-600</td>
													<td>-550</td>
													<td>-700</td>
													<td>-400</td>
													<td>-220</td>
													<td>-150</td>
													<td>-100</td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
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