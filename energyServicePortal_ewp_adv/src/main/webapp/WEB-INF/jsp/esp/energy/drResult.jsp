<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">수요자원</h1>
		<div class="sa_select">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">당진태양광
				<span class="caret"></span></button>
				<ul class="dropdown-menu">
					<li class="on"><a href="#">전체</a></li>
					<li><a href="#">당진태양광</a></li>
					<li><a href="#">제일화성</a></li>
					<li><a href="#">동국제강</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-2 use_total dr_total">
		<div class="indiv">
			<h2 class="ntit">DR 실적 합계</h2>
			<ul class="chart_total">
				<li class="ct1">
					<div class="ctit ct1"><span>실제 사용량</span></div>
					<div class="cval"><span>14,976</span>kWh</div>
				</li>
				<li>
					<div class="ctit"><span>감축량</span></div>
					<div class="cval"><span>20,976</span>kWh</div>
				</li>
			</ul>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="indiv usage_chart dr_chart">
			<div class="chart_top clear">
				<h2 class="ntit fl">롯데정밀화학</h2>
				<div class="term fl clear">
					<div class="dropdown fl">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">1일(날짜선택)
						<span class="caret"></span></button>
						<ul class="dropdown-menu">
						<li class="on"><a href="#">1일(오늘)</a></li>
						<li><a href="#">1일(날짜선택)</a></li>
						</ul>
					</div>
					<div class="dropdown fl">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">15분
						<span class="caret"></span></button>
						<ul class="dropdown-menu">
						<li class="on"><a href="#">15분</a></li>
						<li><a href="#">1시간</a></li>
						</ul>
					</div>
				</div>
				<div class="today_date fl">
					<span>날짜선택</span>
					<input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
				</div>
				<div class="search_opt fl">
					<span>기준부하 시간설정</span>
					<input type="text" class="input" maxlength="2" value="10" style="width:60px;"> 
					<span> ~ </span>
					<input type="text" class="input" maxlength="2" value="14" style="width:60px;">
					<button type="submit">조회</button>
				</div>
				<div class="checkbox fl">
					<input id="check1" type="checkbox" class="styled" checked>
					<label for="check1">실시간 자동 갱신</label>
				</div>
				<div class="real_time fl"><span>00:00</span></div>
				<div class="meter fl">
					<span class="fl">계량값</span>
					<div class="dropdown fl">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체
						<span class="caret"></span></button>
						<ul class="dropdown-menu">
							<li class="on"><a href="#">전체</a></li>
							<li><a href="#">계량#1</a></li>
							<li><a href="#">계량#2</a></li>
							<li><a href="#">계량#3</a></li>
						</ul>
					</div>
				</div>
				<div class="time fr">2018-08-12 11:41:26</div>
			</div>
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
								value: 9, /* 현재 */
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
// 									    series: [{
// 									    	type: 'spline',
// 									        color: '#438fd7', /* 실제 사용량 */
// 									        tooltip: {
// 										        valueSuffix: 'kWh'
// 										    }
// 									    },{
// 									    	type: 'spline',
// 									        dashStyle: 'ShortDash',
// 									        color: '#84848f', /* 감축량 */
// 									        tooltip: {
// 										        valueSuffix: 'kWh'
// 										    }
// 									    }],
						/* 그래프 스타일 */
						series: [{
							type: 'line',
							color: '#438fd7', /* 실제 사용량 */
							tooltip: {
								valueSuffix: 'kWh'
							}
						},{
							type: 'area',
							color: '#84848F', /* 목표사용량 */
							fillOpacity: 0.1,
							tooltip: {
								valueSuffix: 'kWh'
							}
						},{
							type: 'area',
							color: '#84848F', /* 목표사용량 */
							fillOpacity: 0.1,
							linkedTo: ':previous', // 전의 series와 하나로 연결한다
							tooltip: {
								valueSuffix: 'kWh'
							}
						},{
							type: 'line',
							color: '#f10075', /* 기준부하 */
							tooltip: {
								valueSuffix: 'kWh'
							}
						},{
							type: 'line',
							color: '#f10075', /* 기준부하 */
							linkedTo: ':previous', // 전의 series와 하나로 연결한다
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
				});
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
				<div class="fold_div">
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
							<tbody>
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
									<th>실제사용량</th>
									<th>목표사용량</th>
									<th>목표사용량</th>
									<th>기준부하</th>
									<th>기준부하</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>1</th>
									<td>0</td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>2</th>
									<td>200</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>3</th>
									<td>300</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>4</th>
									<td>500</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>5</th>
									<td>480</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>6</th>
									<td>600</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>7</th>
									<td>500</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>8</th>
									<td>700</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>9</th>
									<td>620</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>10</th>
									<td>630</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>11</th>
									<td>640</td>
									<td>720</td>
									<td></td>
									<td>920</td>
									<td></td>
								</tr>
								<tr>
									<th>12</th>
									<td>720</td>
									<td>720</td>
									<td></td>
									<td>920</td>
									<td></td>
								</tr>
								<tr>
									<th>13</th>
									<td></td>
									<td>720</td>
									<td>820</td>
									<td>920</td>
									<td>1020</td>
								</tr>
								<tr>
									<th>14</th>
									<td></td>
									<td></td>
									<td>820</td>
									<td></td>
									<td>1020</td>
								</tr>
								<tr>
									<th>15</th>
									<td></td>
									<td></td>
									<td>820</td>
									<td></td>
									<td>1020</td>
								</tr>
								<tr>
									<th>16</th>
									<td></td>
									<td></td>
									<td>820</td>
									<td></td>
									<td>1020</td>
								</tr>
								<tr>
									<th>17</th>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>18</th>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>19</th>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>20</th>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>21</th>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<th>22</th>
									<td></td>
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
									<td></td>
								</tr>
								<tr>
									<th>24</th>
									<td></td>
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
