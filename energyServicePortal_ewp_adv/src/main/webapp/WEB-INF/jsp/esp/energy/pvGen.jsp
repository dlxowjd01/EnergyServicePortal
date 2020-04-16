<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">발전</h1>
					</div>
					<div class="header_drop_area col-lg-2">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">사업소#1,사업소#2
							<span class="caret"></span></button>
							<ul class="dropdown-menu dropdown-menu-form chk_type">
								<li class="dropdown_cov clear">
									<div class="sec_li_bx">
										<p class="tx_li_tit">사업소 별</p>
										<ul>
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="checkbox" id="chk_op01" value="사업소#1">
													<label for="chk_op01"><span></span>사업소#1</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="checkbox" id="chk_op02" value="사업소#2">
													<label for="chk_op02"><span></span>사업소#2</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="checkbox" id="chk_op03" value="사업소#3">
													<label for="chk_op03"><span></span>사업소#3</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="checkbox" id="chk_op04" value="사업소#4">
													<label for="chk_op04"><span></span>사업소#4</label>
												</a>
											</li>
										<ul>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">발전량 합계</h2>
							<div class="value_area">
								<h3 class="value_tit">실제 발전량</h3>
								<p class="value_num"><span class="num">12,230</span>kwh</p>
							</div>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv usage_chart pv_chart">
							<div class="chart_top clear">
								<div class="fl">
									<span class="tx_tit">계량값</span>
									<div class="sa_select">
										<div class="dropdown">
										  <button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">복수 선택
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu dropdown-menu-form chk_type">
											<!--
												섹션(사업소)이 2개 일 때 : width:380px
												섹션(사업소)이 3개 일 때 : width:550px
												갯수가 하나씩 추가 될때마다 +170px 해주세요.
											-->
											<li class="dropdown_cov clear" style="width:380px">
												<!-- 섹션 -->
												<div class="sec_li_bx">
													<p class="tx_li_tit">사업소#1</p>
													<ul>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op01" value="인버터#1">
																<label for="chk_op01"><span></span>인버터#1</label>
															</a>
														</li>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op02" value="인버터#2">
																<label for="chk_op02"><span></span>인버터#2</label>
															</a>
														</li>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op03" value="인버터#3">
																<label for="chk_op03"><span></span>인버터#3</label>
															</a>
														</li>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op04" value="인버터#4">
																<label for="chk_op04"><span></span>인버터#4</label>
															</a>
														</li>
													<ul>
												</div>
												<!-- //섹션 -->
												<div class="sec_li_bx">
													<p class="tx_li_tit">사업소#2</p>
													<ul>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op011" value="인버터#1">
																<label for="chk_op011"><span></span>인버터#1</label>
															</a>
														</li>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op022" value="인버터#2">
																<label for="chk_op022"><span></span>인버터#2</label>
															</a>
														</li>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op033" value="인버터#3">
																<label for="chk_op033"><span></span>인버터#3</label>
															</a>
														</li>
														<li>
															<a href="#" data-value="option1" tabindex="-1">
																<input type="checkbox" id="chk_op044" value="인버터#4">
																<label for="chk_op044"><span></span>인버터#4</label>
															</a>
														</li>
													<ul>
												</div>
												<div class="li_btn_bx clear">
													<div class="fl">
														<button type="submit" class="btn_type03">모두 선택</button>
														<button type="submit" class="btn_type03">모두 해제</button>
													</div>
													<div class="fr"><button type="submit" class="btn_type">적용</button></div>
												</div>
											</li>
										</ul>
										</div>
									</div>
								</div>
								<div class="fl">
									<span class="tx_tit">조회 기간</span>
									<div class="sa_select">
										<div class="dropdown">
										  <button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">오늘
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu">
											<li class="on"><a href="#">오늘</a></li>
											<li><a href="#">이번 주</a></li>
											<li><a href="#">이번 달</a></li>
											<li><a href="#">기간 설정</a></li>
										  </ul>
										</div>
									</div>
								</div>
								
								<div class="fl">
									<span class="tx_tit">기간 설정</span>
									<div class="sel_calendar">
									  <input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
									  <em></em>
									  <input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
									</div>
								</div>
								
								<div class="fl">
									<span class="tx_tit">주기</span>
									<div class="sa_select">
										<div class="dropdown">
										  <button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">기간
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu">
											<li class="on"><a href="#">15분</a></li>
											<li><a href="#">30분</a></li>
											<li><a href="#">1시간</a></li>
											<li><a href="#">1일</a></li>
											<li><a href="#">1월</a></li>
										  </ul>
										</div>
									</div>
								</div>
								<div class="fl"><button type="submit" class="btn_type">조회</button></div>
								
								<div class="fr">
									<span class="tx_tit">그래프 스타일</span>
									<div class="sa_select">
										<div class="dropdown">
										  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체 합산
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu">
											<li class="on"><a href="#">전체 합산</a></li>
											<li><a href="#">사이트별 합산</a></li>
											<li><a href="#">개별 막대</a></li>
										  </ul>
										</div>
									</div>
								</div>
							</div>
							<p class="tx_time">2020-03-06 22:00:09</p>
							<br>
							<br>
							<br>
							<br>
							<div class="inchart">
								
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
												value: 15, /* 현재 */
												color: '#438fd7',
												width: 2,
												zIndex: 0,
												label: {
													 text: ''
												}
											}],
											crosshair: true /* 포커스 선 */
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
											shared: true /* 툴팁 공유 */
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
											color: '#438fd7', /* 실제 발전량 */
											type:'column',
											tooltip: {
												valueSuffix: 'kWh'
											}
										}, {
											color: '#84848f', /* 예측 발전량 */
											type: 'spline',
											dashStyle: 'ShortDash',
											tooltip: {
												valueSuffix: 'kWh'
											}
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
											myChart.series[0].update({
												type: "column"
											});

										});
										$('.chart_change_line').click(function () {
											$(this).hide();
											$('.chart_change_column').show();
											myChart.series[0].update({
												type: "spline"
											});

										});
									});
								});
								</script>
							</div>	
						</div>
					</div>
				</div>
				<div class="row pv_chart_table">
					<div class="col-lg-12">
						<div class="indiv clear">
							<div class="tbl_save_bx">
							  <a href="#;" class="save_btn">데이터저장</a>
							</div>
							<div class="tbl_top clear">
								<h2 class="ntit fl">발전량 도표</h2>
								<ul class="fr">
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
													<th>2020-08-01</th>
													<th>01:00</th>
													<th>02:00</th>
													<th>03:00</th>
													<th>04:00</th>
													<th>05:00</th>
													<th>06:00</th>
													<th>07:00</th>
													<th>08:00</th>
													<th>09:00</th>
													<th>10:00</th>
													<th>11:00</th>
													<th>12:00</th>
													<th>13:00</th>
													<th>14:00</th>
													<th>15:00</th>
													<th>16:00</th>
													<th>17:00</th>
													<th>18:00</th>
													<th>19:00</th>
													<th>20:00</th>
													<th>21:00</th>
													<th>22:00</th>
													<th>23:00</th>
													<th>24:00</th>
													<th>합계</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th><span class="bu t1">사업소#1 매전량</span></th>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>50</td>
													<td>10</td>
													<td>200</td>
													<td>40</td>
													<td>50</td>
													<td>40</td>
													<td>300</td>
													<td>20</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>458</td>
												</tr>
												<tr>
													<th><span class="bu t2">사업소#1 대시보드 계량</span></th>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>50</td>
													<td>10</td>
													<td>200</td>
													<td>40</td>
													<td>50</td>
													<td>40</td>
													<td>300</td>
													<td>20</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>458</td>
												</tr>
												<tr>
													<th><span class="bu t3">사업소#1 매전량</span></th>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>50</td>
													<td>10</td>
													<td>20</td>
													<td>10</td>
													<td>40</td>
													<td>50</td>
													<td>30</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>300</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>458</td>
												</tr>
												<tr>
													<th><span class="bu t4">사업소#1 대시보드 계량</span></th>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>50</td>
													<td>10</td>
													<td>200</td>
													<td>40</td>
													<td>50</td>
													<td>40</td>
													<td>300</td>
													<td>20</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>0</td>
													<td>458</td>
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
													<th>실제 발전량</th>
													<th>예측 발전량</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th>1</th>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th>2</th>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th>3</th>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th>4</th>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th>5</th>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th>6</th>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th>7</th>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<th>8</th>
													<td>50</td>
													<td>100</td>
												</tr>
												<tr>
													<th>9</th>
													<td>100</td>
													<td>200</td>
												</tr>
												<tr>
													<th>10</th>
													<td>200</td>
													<td>400</td>
												</tr>
												<tr>
													<th>11</th>
													<td>400</td>
													<td>1000</td>
												</tr>
												<tr>
													<th>12</th>
													<td>500</td>
													<td>900</td>
												</tr>
												<tr>
													<th>13</th>
													<td>400</td>
													<td>800</td>
												</tr>
												<tr>
													<th>14</th>
													<td>300</td>
													<td>700</td>
												</tr>
												<tr>
													<th>15</th>
													<td>200</td>
													<td>500</td>
												</tr>
												<tr>
													<th>16</th>
													<td></td>
													<td></td>
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
