<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<%@ include file="/decorators/include/dashboardSchForm.jsp" %>
<!-- 메인페이지용 스타일/스크립트 파일 -->
<script type="text/javascript" src="/js/modules/rounded-corners.js"></script>
<script type="text/javascript" src="/js/jquery.rwdImageMaps.min.js"></script>
<script type="text/javascript"
				src="http://maps.google.com/maps/api/js?key=AIzaSyAyGrAQC_675C34l2ZJ5JgEqeEV3gLuY9I"></script>
<script type="text/javascript">
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	var pieChartOption = {
		chart: {
			marginTop: 0,
			marginLeft: 0,
			marginRight: 0,
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
			y: 10,
			x: 0,
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
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--color3)'
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
						color: 'white'
					}
				},
				//startAngle: -90,
				//endAngle: 90,
				center: ['50%', '50%'],
				borderWidth: 0,
				size: '100%'
			}
		},

// 		series: [{
// 			type: 'pie',
// 			innerSize: '50%',
// 			name: '설비용량',
// 			colorByPoint: true,
// 			data: [{
// 				color: '#438fd7',
// 				name: '총 설비용량',
// 				dataLabels: {
// 					enabled: false
// 				},
// 				y: 70 //70% -- 아래로 총합 100%
// 			}, {
// 				color: '#84848f',
// 				name: '미설비용량',
// 				dataLabels: {
// 					enabled: false
// 				},
// 				y: 30 //30% 나머지
// 			}]
// 		}],
		responsive: { // 반응형
			rules: [{
				condition: {
					minWidth: 305
				},
				chartOptions: {
					title: {
						x: 0,
						y: 0,
						style: {
							fontSize: '18px',
						}
					},
					plotOptions: {
						pie: {
							dataLabels: {
								style: {
									fontWeight: 'bold'
								}
							},
							center: ['50%', '50%'],
							size: '100%'
						}
					}
				}
			}]
		}
	};

	// 	$(window).resize(function() { //브라우저 사이즈 변경될때마다 새로고침 (차트사이즈 재설정)
	// 	    location.reload();
	// 	});

	$(function () {
		$("input[name='deviceStatus']").on("click", function () {
			var flag = $(this).is(":checked");
			var str = $(this).val();

			var $tbody = $(".intable").find('tbody');
			if (flag) {
				if (str == "정상") $tbody.find('.flag1').css("display", "");
				if (str == "경고") $tbody.find('.flag2').css("display", "");
				if (str == "이상") $tbody.find('.flag3').css("display", "");
			} else {
				if (str == "정상") $tbody.find('.flag1').css("display", "none");
				if (str == "경고") $tbody.find('.flag2').css("display", "none");
				if (str == "이상") $tbody.find('.flag3').css("display", "none");
			}

		});
	});

	function linkSiteDashboard(t) {
		var url = "", str = "";
		if (t == 1) {
			str = "혜원 솔라 1호기";
			url = '/dashboard/smain.do';
		}
		if (t == 2) {
			str = "혜원 솔라 2호기";
			url = '/dashboard/smain.do';
		}
		$("#linkSiteName").val(str);
		document.linkSiteForm.action = url;
		$("#linkSiteForm").submit();
	}
</script>
<form id="linkSiteForm" name="linkSiteForm" method="post">
	<input type="hidden" id="linkSiteName" name="linkSiteName" value="">
</form>
<div class="row">
	<div class="time">
		<span>CURRENT TIME</span>
		<em class="currTime">${nowTime}</em>
		<span>DATA BASE TIME</span>
		<em class="dbTime">2018-07-27 17:01:02</em>
	</div>
</div>
<div class="row">
	<div class="col-lg-4">
		<div class="row">
			<div class="col-sm-12">
				<div class="indiv gmain_chart gmain_chart1">
					<div class="chart_top clear">
						<h2 class="ntit">월간</h2>
						<span class="term">2019.4.14 ~ 2020.4.13</span>
					</div>
					<div class="no-data" style="display:none;">
						<span>올해 발전량 정보를 가져올 수 없습니다.</span>
					</div>
					<div class="inchart">
						<div id="gchart1"></div>
						<script type="text/javascript">
							var chargeChart1 = Highcharts.chart('gchart1', {
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
									lineColor: 'var(--color1)', /* 눈금선색 */
									tickColor: 'var(--color1)',
									gridLineColor: 'var(--color1)',
									plotLines: [{
										color: 'var(--color1)',
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
									title: {
										text: 'kWh',
										align: 'low',
										rotation: 0, /* 타이틀 기울기 */
										y: 25, /* 타이틀 위치 조정 */
										x: 15,
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
									title: {
										text: '천원',
										align: 'low',
										rotation: 0, /* 타이틀 기울기 */
										y: 25, /* 타이틀 위치 조정 */
										x: -12,
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
									shared: true,
									borderColor: 'none',
									backgroundColor: 'var(--bg-color)',
									padding: 16,
									style: {
										color: 'var(--color3)'
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
										color: 'var(--color2)',
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
									tooltip: {
										valueSuffix: 'kWh'
									}

								}, {
									name: '방전',
									type: 'column',
									color: '#878787',
									tooltip: {
										valueSuffix: 'kWh'
									}

								}, {
									name: '태양광',
									type: 'column',
									color: '#9363FD',
									tooltip: {
										valueSuffix: 'kWh'
									}

								}, {
									name: '정산금',
									type: 'spline',
									color: 'var(--color3)',
									dashStyle: 'ShortDash',
									yAxis: 1,
									tooltip: {
										valueSuffix: '천원'
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
												marginTop: 50,
												marginLeft: 75,
												marginRight: 75
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
													y: 30,
													x: 20,
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
														y: 30,
														x: -15,
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
						<span class="term">2020.4.1 ~ 2020.4.13</span>
					</div>
					<div class="inchart">
						<div id="gchart2"></div>
						<script type="text/javascript">
							var chargeChart2 = Highcharts.chart('gchart2', {
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
									lineColor: 'var(--color1)', /* 눈금선색 */
									tickColor: 'var(--color1)',
									gridLineColor: 'var(--color1)',
									plotLines: [{
										color: 'var(--color1)',
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
											color: 'var(--color2)',
											fontSize: '12px'
										}
									},
									tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
									title: {
										text: null
									},
									categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'],
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
									title: {
										text: 'kWh',
										align: 'low',
										rotation: 0, /* 타이틀 기울기 */
										y: 25, /* 타이틀 위치 조정 */
										x: 15,
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
									lineColor: 'var(--colo1)', /* 눈금선색 */
									tickColor: 'var(--colo1)',
									gridLineColor: 'var(--colo1)',
									gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
									plotLines: [{
										color: 'var(--colo1)',
										width: 1
									}],
									title: {
										text: '천원',
										align: 'low',
										rotation: 0, /* 타이틀 기울기 */
										y: 25, /* 타이틀 위치 조정 */
										x: -12,
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
									shared: true,
									borderColor: 'none',
									backgroundColor: 'var(--bg-color)',
									padding: 16,
									style: {
										color: 'var(--color3)'
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
										color: 'var(--color2)',
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
									tooltip: {
										valueSuffix: 'kWh'
									}

								}, {
									name: '방전',
									type: 'column',
									color: '#878787',
									tooltip: {
										valueSuffix: 'kWh'
									}

								}, {
									name: '태양광',
									type: 'column',
									color: '#9363FD',
									tooltip: {
										valueSuffix: 'kWh'
									}

								}, {
									name: '정산금',
									type: 'spline',
									color: 'var(--color3)',
									dashStyle: 'ShortDash',
									yAxis: 1,
									tooltip: {
										valueSuffix: '천원'
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
												marginTop: 50,
												marginLeft: 75,
												marginRight: 75
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
													y: 30,
													x: 20,
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
														y: 30,
														x: -15,
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
						<span class="term">2020.4.12</span>
					</div>
					<%--          <ul class="gtab_menu">--%>
					<%--            <li class="active"><a href="#;">사업소별 현황</a></li>--%>
					<%--            <li><a href="#;">유형별 발전 현황</a></li>--%>
					<%--          </ul>--%>
					<div class="tblDisplay">
						<div>
							<!-- 사업소별 현황 -->
							<div class="sa_chart">
								<div class="inchart">
									<div id="gchart3"></div>
									<script language="JavaScript">
										function drawPeakChart3() {
											var peakChart3 = Highcharts.chart('gchart3', {
												data: {
													table: 'gdatatable3' /* 테이블에서 데이터 불러오기 */
												},

												chart: {
													marginTop: 50,
													marginRight: 0,
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
														x: -10, /* 그래프와의 거리 조정 */
														style: {
															color: '#a4aebf',
															fontSize: '12px'
														}
													}
												},

												/* 범례 */
												legend: {
													enabled: true,
													align: 'right',
													verticalAlign: 'top',
													x: 5,
													y: -10,
													itemStyle: {
														color: '#a4aebf',
														fontSize: '12px',
														fontWeight: 400
													},
													itemHoverStyle: {
														color: '' /* 마우스 오버시 색 */
													},
													symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
													symbolHeight: 7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													shared: true,
													borderColor: 'none',
													backgroundColor: 'var(--bg-color)',
													padding: 16,
													style: {
														color: 'var(--color3)'
													},
													valueSuffix: ' kwh'
												},

												/* 옵션 */
												plotOptions: {
													series: {
														label: {
															connectorAllowed: true
														},
														borderWidth: 0, /* 보더 0 */
														borderRadiusTopLeft: 2, /* 막대 모서리 둥글게 효과 */
														borderRadiusTopRight: 2, /* 막대 모서리 둥글게 효과 */
														pointWidth: 10, /* 막대 두께 */
														pointPadding: 6 /* 막대 사이 간격 */
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
												}, {
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
																symbolPadding: 5,
																symbolHeight: 10
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
										};
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
									<tbody id="siteGenTbody">
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
										function drawPeakChart4() {
											var peakChart4 = Highcharts.chart('gchart4', {
												data: {
													table: 'gdatatable4' /* 테이블에서 데이터 불러오기 */
												},
												align: 'center',
												chart: {
													marginTop: 50,
													backgroundColor: 'transparent',
													type: 'column',
													height: '100%',
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
													lineColor: 'var(--color2)', /* 눈금선색 */
													tickColor: 'var(--color2)',
													gridLineColor: 'var(--color2)',
													plotLines: [{
														color: 'var(--color2)',
														width: 1
													}],
													labels: {
														align: 'center',
														reserveSpace: true,
														style: {
															color: 'var(--color1)',
															fontSize: '12px'
														}
													},
													title: {
														text: null
													}
												},

												yAxis: {
													opposite: true,
													lineColor: 'var(--color2)', /* 눈금선색 */
													tickColor: 'var(--color2)',
													gridLineColor: 'var(--color2)',
													plotLines: [{
														color: 'var(--color2)',
														width: 1
													}],
													gridLineWidth: 0, /* 기준선 grid 안보이기/보이기 */
													min: 0, /* 최소값 지정 */
													title: {
														text: 'kWh',
														align: 'low',
														rotation: 0, /* 타이틀 기울기 */
														y: 25, /* 타이틀 위치 조정 */
														x: -10,
														style: {
															color: 'var(--color1)',
															fontSize: '12px'
														}
													},
													labels: {
														x: 15, /* 그래프와의 거리 조정 */
														style: {
															color: 'var(--color1)',
															fontSize: '12px'
														}
													}
												},

												/* 범례 */
												legend: {
													enabled: true,
													align: 'left',
													verticalAlign: 'top',
													x: 0,
													y: -10,
													itemStyle: {
														color: 'var(--color1)',
														fontSize: '12px',
														fontWeight: 400
													},
													itemHoverStyle: {
														color: '' /* 마우스 오버시 색 */
													},
													symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
													symbolHeight: 7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													shared: true,
													borderColor: 'none',
													backgroundColor: 'var(--bg-color)',
													padding: 16,
													style: {
														color: 'var(--color3)'
													},
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
													column: {}
												},

												/* 출처 */
												credits: {
													enabled: false
												},

												/* 그래프 스타일 */
												series: [{
													color: '#25CCC8' /* 전일발전 */
												}, {
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
																symbolPadding: 5,
																symbolHeight: 10
															},
															plotOptions: {
																series: {},
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
										};
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
									<tbody id="typeGenTbody">
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
										var pieChart;
										$(function () {
											pieChart = Highcharts.chart('pie_chart', {
												chart: {
													marginTop:0,
													marginLeft:0,
													marginRight:0,
													backgroundColor: 'transparent',
													plotBorderWidth: 0,
													plotShadow: false,
												},

												navigation: {
													buttonOptions: {
														enabled: false /* 메뉴 안보이기 */
													}
												},

												title: {
													text: '- Wh', // 총용량 표기
													align: 'center',
													verticalAlign: 'middle',
													y:10,
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
													shared: true,
													borderColor: 'none',
													backgroundColor: 'var(--bg-color)',
													padding: 16,
													style: {
														color: 'var(--color3)'
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
																color: 'var(--color3)'
															}
														},
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
								<div class="legend_wrap">
									<span class="bu1">태양광</span>
									<span class="bu4">미 사용량</span>
								</div>
								<ul>
									<li><strong>금일 누적발전량</strong> <span> 0 </span><em>kWh</em></li>
									<li><strong>금일 예측발전량</strong> <span> 0 </span><em>kWh</em></li>
									<li><strong>금일 충/방전</strong> <span> - </span><em>Wh</em> / <span> - </span><em>Wh</em></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="local_info s_center">
						<table>
							<thead>
								<tr>
									<th>총 사업소</th>
									<th>총 설비</th>
									<th>총 설비용량</th>
									<th>금일 CO2저감량</th>
									<th>금일 누적수익</th>
								</tr>
							</thead>
							<tbody id="centerTbody">
								<tr>
									<td> - 개소</td>
									<td> 2 대</td>
									<td> 194.56 kW</td>
									<td> - </td>
									<td>0</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="indiv gmain_chart jmain_center2">
					<div class="chart_top clear">
						<h2 class="ntit">실시간 실적</h2>
					</div>
					<div class="realtime clear" style="position:relative;">
						<div class="realtime_by_site">
							<div id="rchart1" style="height:195px;"></div>
							<script language="JavaScript">
								var rchart1 = Highcharts.chart('rchart1', {
									chart: {
										marginTop:5,
										marginLeft:50,
										marginRight:0,
										backgroundColor: 'transparent',
										type: 'variwide'
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
										type: 'category',
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
										}
									},

									yAxis: [
										{ // Primary yAxis
											min: 0,
											max: 100,
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
												text: '%',
												align: 'low',
												rotation: 0, /* 타이틀 기울기 */
												y:25, /* 타이틀 위치 조정 */
												x:15,
												style: {
													color: '#a4aebf',
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
										}
									],

									caption: {
										text: ''
									},

									legend: {
										enabled: false
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
										column: {
											stacking: 'percent' /*위로 쌓이는 막대  ,normal */
										},
										variwide: {
											// shared options for all variwide series
											colors: ['#00b2aa', '#009389']
										}
									},

									series: [{
										name: '실시간 출력량',
										data: [
											['혜원 솔라 02', 55, 45], /* 타이틀 | 출력량 | 컬럼폭(전체합 100% 기준으로 분할) */
											['혜원 솔라 01', 45, 55],
										],
										dataLabels: {
											enabled: true,
											inside: true,
											format: '{point.y:.0f} %'
										},
										tooltip: {
											pointFormat: '출력: <b>{point.y} %</b>' +
												''
										},
										colorByPoint: true
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
													marginLeft:75
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
						<div class="realtime_total">
							<div id="rchart2" style="height:195px;"></div>
							<script language="JavaScript">
									var rchart2 = Highcharts.chart('rchart2', {
										chart: {
											marginTop:5,
											marginLeft:0,
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
											lineColor: '', /* 눈금선색 */
											tickColor: '#515562',
											gridLineColor: '#515562',
											labels: {
												enabled: false,
												align: 'right',
												reserveSpace: true,
												style: {
													color: '#a4aebf',
													fontSize: '12px'
												}
											},
											title: {
												text: '사업소 합계',
												margin: 13
											},
											categories: ['입찰', '출력'],
											crosshair: true
										},

										yAxis: {
											lineColor: '#515562', /* 눈금선색 */
											tickColor: '#515562',
											gridLineColor: '#515562',
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
												enabled: false,
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
											enabled: false,
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
											valueSuffix: ' MWh'
										},

										/* 옵션 */
										plotOptions: {
											series: {
												stacking: 'percent',
												label: {
													connectorAllowed: true
												},
												borderWidth: 0, /* 보더 0 */
												pointWidth: 25, /* 막대 두께 */
											},
											bar: {
												dataLabels: {
													enabled: true, /* 막대 안의 수치 안보이기 */
													inside: true, /* 막대 안으로 라벨 수치 넣기 */
													format: '{point.y:.0f} %', /* 단위 넣기 */
													style: {
														color: '#ffffff',
														fontSize: '11px',
														fontWeight: 400,
														textOutline: 0 /* 막대 안의 라벨 수치 테두리 없애기 */
													}
												}
											},
											column: {
												stacking: 'percent', /*위로 쌓이는 막대  ,normal */
												pointWidth: 80,
												dataLabels: {
													format: '{point.y:.0f} %',
												}
											}
										},

										/* 출처 */
										credits: {
											enabled: false
										},

										/* 그래프 스타일 */
										series: [{
											name: '입찰',
											data: [55],
											tooltip: {
												valueSuffix: '%'
											},
											dataLabels: {
												enabled: true
											},
											color: '#575757' /* 입찰 */
										},{
											name: '출력',
											data: [45],
											tooltip: {
												valueSuffix: '%'
											},
											dataLabels: {
												enabled: true
											},
											color: '#26ccc8' /* 출력 */
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
															pointWidth: 37 /* 막대 두께 */
															//pointPadding: 0.25 /* 막대 사이 간격 */
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
							</script>
						</div>
						<div class="realtime_time"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="indiv gmain_chart jmain_center3">
					<div class="chart_top clear">
						<h2 class="ntit">입찰 현황</h2>
					</div>
					<div class="realtime_wrap">
						<div class="inchart">
							<div id="rchart3"></div>
							<script language="JavaScript">
									var rChart3 = Highcharts.chart('rchart3', {
										chart: {
											marginTop:40,
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
											min: 0, /* 최소값 지정 하면 + 만 나옴 */
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

										series: [{
											name: '출력',
											type: 'column',
											color: '#2BEEE9',
											data: [0,0,0,0,0,0,0,0,0,0,0,0],
											tooltip: {
												valueSuffix: 'kWh'
											}
										},{
											name: '입찰',
											type: 'column',
											color: '#878787',
											data: [0,0,0,0,0,0,0,0,0,0,0,0],
											tooltip: {
												valueSuffix: 'kWh'
											}
										}],

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
							</script>
							<!-- 데이터 추출용 -->
							<div class="chart_table2" style="display:none;">
								<table id="rdatatable2">
									<thead>
										<tr>
											<th></th>
											<th>출력</th>
											<th>입찰</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>1</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>2</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>3</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>4</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>5</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>6</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>7</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>8</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>9</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>10</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>11</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>12</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>13</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>14</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>15</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>16</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>17</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>18</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>19</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>20</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>21</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>22</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>23</th>
											<td>0</td>
											<td>0</td>
										</tr>
										<tr>
											<th>24</th>
											<td>0</td>
											<td>0</td>
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
				<div class="indiv gmain_alarm wrap_type">
					<div class="alarm_stat clear">
						<div class="a_alert clear">
							<span>금일 발생 오류</span>
							<em>0</em>
						</div>
						<div class="a_warning clear">
							<a href="#" class="btn cancel_btn">상세보기</a>
						</div>
					</div>
					<div class="alarm_notice">
						<ul>
							<%--              <li>--%>
							<%--                <a href="javascript:list_detail_open('list3');">혜원솔라01 - 인버터1 발전 정지</a>--%>
							<%--                <span>2018-08-12 11:41:26</span>--%>
							<%--              </li>--%>
							<%--              <li>--%>
							<%--                <a href="#;">혜원솔라01 - 인버터1 발전 정지</a>--%>
							<%--                <span>2018-08-12 11:41:26</span>--%>
							<%--              </li>--%>
							<%--              <li>--%>
							<%--                <a href="#;">혜원솔라01 - 인버터1 발전 정지</a>--%>
							<%--                <span>2018-08-12 11:41:26</span>--%>
							<%--              </li>--%>
							<%--              <li>--%>
							<%--                <a href="#;">혜원솔라01 - 인버터1 발전 정지</a>--%>
							<%--                <span>2018-08-12 11:41:26</span>--%>
							<%--              </li>--%>
							<%--              <li>--%>
							<%--                <a href="#;">혜원솔라01 - 인버터1 발전 정지</a>--%>
							<%--                <span>2018-08-12 11:41:26</span>--%>
							<%--              </li>--%>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="indiv gmain_table">
					<div class="gtbl_top clear">
						<div class="fl">
					<input type="text" class="input" value="" placeholder="키워드">
					<button type="submit">적용</button>
				</div>
				<div class="fr">
					<span class="tx_tit">설비 상태</span>
					<div class="sa_select" id="deviceType">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">
								전체<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu">
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="deviceStatus1" value="정상" checked>
										<label for="deviceStatus1"><span></span>정상</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="deviceStatus2" value="경고" checked>
										<label for="deviceStatus2"><span></span>경고</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="deviceStatus3" value="이상" checked>
										<label for="deviceStatus3"><span></span>이상</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="INV_PV" tabindex="-1">
										<input type="checkbox" id="deviceStatus4" value="트립" checked>
										<label for="deviceStatus4"><span></span>트립</label>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
					</div>
					<div class="gtbl_wrap">
						<div class="intable">
							<table>
								<!-- <colgroup>
                <col style="width:12.5%">
                <col style="width:12.5%">
                <col style="width:12.5%">
                <col style="width:12.5%">
                <col style="width:12.5%">
                <col style="width:12.5%">
                <col style="width:12.5%">
                <col style="width:12.5%">
                </colgroup> -->
								<thead>
									<tr>
										<th>설비상태</th>
										<th>오류</th>
										<th>경고</th>
										<th><button class="btn_align down">사업소</button></th>
										<th>설비용량</th>
										<th>금일예측</th>
										<th>금일누적</th>
										<th>금일충전</th>
										<th>금일방전</th>
									</tr>
								</thead>
								<tbody>
									<!--
                    [D] 상태별 배경 : 't1' or 't2' 클래스 추가
                  -->
									<tr class="dbclickopen flag1">
										<td class="first_td">
											<%--<span class="status status_hld" title="대기">대기</span>--%>
											<span class="status status_drv" title="운전">운전</span>
											<span class="st_bar"></span>
											<%--<span class="battery_icon batter_out">충전</span>--%>
										</td>
										<td>0</td>
										<td>0</td>
										<td>혜원 솔라 02</td>
										<td>97.28kW</td>
										<td>0</td>
										<td>0</td>
										<td>-</td>
										<td>-</td>
									</tr>
									<tr class="detail_info list1 flag1">
										<td colspan="9">
											<div class="di_wrap">
												<div class="di_wrap_in">
													<div class="di_top_sec">
														<span class="ico solar"></span>
														<!-- <span class="ico battery"></span>
                            <span class="ico water"></span>
                            <span class="ico wind"></span> -->
														<div class="tx_area clear">
															<div class="fl">
																<span class="tx">일사량</span>
																<span class="tx2">- kWh/㎡․day</span>
															</div>
															<div class="fr">
																<span class="tx2">온도 0°C</span>
																<span class="tx2">습도 0%</span>
															</div>
														</div>
													</div>
													<div class="di_btm_sec clear">
														<div class="sec_bx left">
															<div class="bx_in">
																<div class="bx_top">
																	<!-- [D] 차트 개발 시 style 삭제해주세요. -->
																	<div class="inchart" id="type_chart1" style="height:100%;text-align:center">차트영역</div>
																	<script language="JavaScript">
																		$(function () {
																			pieChart['1'] = Highcharts.chart('type_chart1', {
																				chart: {
																					marginTop: 0,
																					marginLeft: 0,
																					marginRight: 0,
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
																					y: 32,
																					x: 0,
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
																						startAngle: -90,
																						endAngle: 90,
																						center: ['50%', '120%'],
																						borderWidth: 0,
																						size: '200%'
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
																								x: 0,
																								y: 10,
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
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit">설비 출력</span>
																		<span class="di_li_tx">0KW</span>
																	</li>
																	<li>
																		<span class="di_li_tit">금일 누적발전</span>
																		<span class="di_li_tx">0kWh</span>
																	</li>
																	<li>
																		<span class="di_li_tit">금일 예측발전</span>
																		<span class="di_li_tx">0kWh</span>
																	</li>
																	<li>
																		<span class="di_li_tit">전일 총발전량</span>
																		<span class="di_li_tx">0kWh</span>
																	</li>
																</ul>
															</div>
														</div>
														<div class="sec_bx right">
															<div class="bx_in">
																<div class="bx_top">
																	<div class="bx_top_inner"></div>
																</div>
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit">총 설비용량</span>
																		<span class="di_li_tx">97.28kW</span>
																	</li>
																	<li>
																		<span class="di_li_tit">총 인버터수량</span>
																		<span class="di_li_tx">1EA</span>
																	</li>
																</ul>
																<div class="di_tx_bx">
																	<a href="/history/alarmHistory.do?sid=0c7c90c6-9505-4f77-b42d-500c2879c689">
																		<p class="tx">최근 미처리 오류 : <span>0건</span></p>
																	</a>

																	<%--<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
																	<%--<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
																</div>
															</div>
														</div>
													</div>
													<div class="btn_bx clear"><a href="/dashboard/smain.do?sid=0c7c90c6-9505-4f77-b42d-500c2879c689" class="btn_type02 fr">대시 보드 보기<span class="ico_arrow"></span></a></div>
												</div>
											</div>
										</td>
									</tr>
									<tr class="dbclickopen flag2">
										<td class="first_td">
											<%--<span class="status status_err" title="통신이상">통신이상</span>--%>
											<span class="status status_drv" title="운전">운전</span>
											<span class="st_bar"></span>
										</td>
										<td>0</td>
										<td>0</td>
										<td>혜원 솔라 01</td>
										<td>97.28kW</td>
										<td>0</td>
										<td>0</td>
										<td>-</td>
										<td>-</td>
									</tr>
									<tr class="detail_info list2 flag2">
										<td colspan="9">
											<div class="di_wrap">
												<%--<div class="di_wrap_in">--%>
												<%--	<div class="di_top_sec">--%>
												<%--		<span class="ico battery"></span>--%>
												<%--		<!-- <span class="ico solar"></span>--%>
												<%--		<span class="ico water"></span>--%>
												<%--		<span class="ico wind"></span> -->--%>
												<%--		<div class="tx_area clear">--%>
												<%--			<div class="fl">--%>
												<%--				<span class="tx">배터리 룸</span>--%>
												<%--			</div>--%>
												<%--			<div class="fr">--%>
												<%--				<span class="tx2">온도 30°C</span>--%>
												<%--				<span class="tx2">습도 30%</span>--%>
												<%--			</div>--%>
												<%--		</div>--%>
												<%--	</div>--%>
												<%--	<div class="di_btm_sec clear">--%>
												<%--		<div class="sec_bx">--%>
												<%--			<div class="bx_in">--%>
												<%--				<div class="bx_top">--%>
												<%--					<!-- [D] 차트 개발 시 style 삭제해주세요. -->--%>
												<%--					<div class="inchart" style="background:#555;height:100%;text-align:center">차트영역</div>--%>
												<%--				</div>--%>
												<%--				<ul class="di_list">--%>
												<%--					<li>--%>
												<%--						<span class="di_li_tit">설비 출력</span>--%>
												<%--						<span class="di_li_tx">7MW / 28MWh</span>--%>
												<%--					</li>--%>
												<%--					<li>--%>
												<%--						<span class="di_li_tit">금일 누적충전</span>--%>
												<%--						<span class="di_li_tx">28MWh</span>--%>
												<%--					</li>--%>
												<%--					<li>--%>
												<%--						<span class="di_li_tit">금일 방전예측</span>--%>
												<%--						<span class="di_li_tx">28MWh</span>--%>
												<%--					</li>--%>
												<%--					<li>--%>
												<%--						<span class="di_li_tit">금일 누적방전</span>--%>
												<%--						<span class="di_li_tx">28MWh</span>--%>
												<%--					</li>--%>
												<%--				</ul>--%>
												<%--			</div>--%>
												<%--		</div>--%>
												<%--		<div class="sec_bx">--%>
												<%--			<div class="bx_in">--%>
												<%--				<div class="bx_top">--%>
												<%--					<div class="bx_top_inner">--%>
												<%--						<div class="bg_battery">--%>
												<%--							<span class="bg"></span>--%>
												<%--							<!-- [D] 퍼센트에 맞게 width 값 조절 -->--%>
												<%--							<span class="var"><span style="width:80%"></span></span>--%>
												<%--							<span class="num">80%</span>--%>
												<%--						</div>--%>
												<%--					</div>--%>
												<%--				</div>--%>
												<%--				<ul class="di_list">--%>
												<%--					<li>--%>
												<%--						<span class="di_li_tit">총 설비용량</span>--%>
												<%--						<span class="di_li_tx">7MW / 28MWh</span>--%>
												<%--					</li>--%>
												<%--				</ul>--%>
												<%--				<div class="di_tx_bx">--%>
												<%--					<p class="tx">최근 미처리 오류 : <span>2건</span></p>--%>
												<%--					<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
												<%--					<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
												<%--				</div>--%>
												<%--			</div>--%>
												<%--		</div>--%>
												<%--	</div>--%>
												<%--	<div class="btn_bx clear"><a href="/dashboard/smain.do?sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37" class="btn_type02 fr">대시 보드 보기<span class="ico_arrow"></span></a></div>--%>
												<%--</div>--%>
												<div class="di_wrap_in">
													<div class="di_top_sec">
														<span class="ico solar"></span>
														<!-- <span class="ico battery"></span>
                            <span class="ico water"></span>
                            <span class="ico wind"></span> -->
														<div class="tx_area clear">
															<div class="fl">
																<span class="tx">일사량</span>
																<span class="tx2">- kWh/㎡․day</span>
															</div>
															<div class="fr">
																<span class="tx2">온도 0°C</span>
																<span class="tx2">습도 0%</span>
															</div>
														</div>
													</div>
													<div class="di_btm_sec clear">
														<div class="sec_bx left">
															<div class="bx_in">
																<div class="bx_top">
																	<!-- [D] 차트 개발 시 style 삭제해주세요. -->
																	<div class="inchart" id="type_chart2" style="height:100%;text-align:center">차트영역</div>
																	<script language="JavaScript">
																		$(function () {
																			pieChart['2'] = Highcharts.chart('type_chart2', {
																				chart: {
																					marginTop: 0,
																					marginLeft: 0,
																					marginRight: 0,
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
																					y: 32,
																					x: 0,
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
																						startAngle: -90,
																						endAngle: 90,
																						center: ['50%', '120%'],
																						borderWidth: 0,
																						size: '200%'
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
																								x: 0,
																								y: 10,
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
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit">설비 출력</span>
																		<span class="di_li_tx">0KW</span>
																	</li>
																	<li>
																		<span class="di_li_tit">금일 누적발전</span>
																		<span class="di_li_tx">0kWh</span>
																	</li>
																	<li>
																		<span class="di_li_tit">금일 예측발전</span>
																		<span class="di_li_tx">0kWh</span>
																	</li>
																	<li>
																		<span class="di_li_tit">전일 총발전량</span>
																		<span class="di_li_tx">0kWh</span>
																	</li>
																</ul>
															</div>
														</div>
														<div class="sec_bx right">
															<div class="bx_in">
																<div class="bx_top">
																	<div class="bx_top_inner"></div>
																</div>
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit">총 설비용량</span>
																		<span class="di_li_tx">97.28kW</span>
																	</li>
																	<li>
																		<span class="di_li_tit">총 인버터수량</span>
																		<span class="di_li_tx">1EA</span>
																	</li>
																</ul>
																<div class="di_tx_bx">
																	<a href="/history/alarmHistory.do?sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37">
																		<p class="tx">최근 미처리 오류 : <span>0건</span></p>
																	</a>
																	<%--<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
																	<%--<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
																</div>
															</div>
														</div>
													</div>
													<div class="btn_bx clear"><a href="/dashboard/smain.do?sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37" class="btn_type02 fr">대시 보드 보기<span class="ico_arrow"></span></a></div>
												</div>
											</div>
										</td>
									</tr>
									<%--<tr class="dbclickopen flag2">--%>
									<%--          <td class="first_td">--%>
									<%--	<span class="status status_drv" title="운전">운전</span>--%>
									<%--	<span class="st_bar"></span>--%>
									<%--	<span class="battery_icon batter_in">충전</span>--%>
									<%--</td>--%>
									<%--          <td>3</td>--%>
									<%--          <td>0</td>--%>
									<%--          <td>사업소사업소</td>--%>
									<%--          <td>500</td>--%>
									<%--          <td>12,345</td>--%>
									<%--          <td>1,222</td>--%>
									<%--          <td>123,456</td>--%>
									<%--        </tr>--%>
									<%--        <tr class="detail_info list2 flag2">--%>
									<%--          <td colspan="8">--%>
									<%--            <div class="di_wrap">--%>
									<%--		<div class="di_wrap_in">--%>
									<%--			<div class="di_top_sec">--%>
									<%--				<span class="ico battery"></span>--%>
									<%--				<!-- <span class="ico solar"></span>--%>
									<%--				<span class="ico water"></span>--%>
									<%--				<span class="ico wind"></span> -->--%>
									<%--				<div class="tx_area clear">--%>
									<%--					<div class="fl">--%>
									<%--						<span class="tx">배터리 룸</span>--%>
									<%--					</div>--%>
									<%--					<div class="fr">--%>
									<%--						<span class="tx2">온도 30°C</span>--%>
									<%--						<span class="tx2">습도 30%</span>--%>
									<%--					</div>--%>
									<%--				</div>--%>
									<%--			</div>--%>
									<%--			<div class="di_btm_sec clear">--%>
									<%--				<div class="sec_bx">--%>
									<%--					<div class="bx_in">--%>
									<%--						<div class="bx_top">--%>
									<%--							<!-- [D] 차트 개발 시 style 삭제해주세요. -->--%>
									<%--							<div class="inchart" style="background:#555;height:100%;text-align:center">차트영역</div>--%>
									<%--						</div>--%>
									<%--						<ul class="di_list">--%>
									<%--							<li>--%>
									<%--								<span class="di_li_tit">설비 출력</span>--%>
									<%--								<span class="di_li_tx">7MW / 28MWh</span>--%>
									<%--							</li>--%>
									<%--							<li>--%>
									<%--								<span class="di_li_tit">금일 누적충전</span>--%>
									<%--								<span class="di_li_tx">28MWh</span>--%>
									<%--							</li>--%>
									<%--							<li>--%>
									<%--								<span class="di_li_tit">금일 방전예측</span>--%>
									<%--								<span class="di_li_tx">28MWh</span>--%>
									<%--							</li>--%>
									<%--							<li>--%>
									<%--								<span class="di_li_tit">금일 누적방전</span>--%>
									<%--								<span class="di_li_tx">28MWh</span>--%>
									<%--							</li>--%>
									<%--						</ul>--%>
									<%--					</div>--%>
									<%--				</div>--%>
									<%--				<div class="sec_bx">--%>
									<%--					<div class="bx_in">--%>
									<%--						<div class="bx_top">--%>
									<%--							<div class="bx_top_inner">--%>
									<%--								<div class="bg_battery">--%>
									<%--									<span class="bg"></span>--%>
									<%--									<!-- [D] 퍼센트에 맞게 width 값 조절 -->--%>
									<%--									<span class="var"><span style="width:80%"></span></span>--%>
									<%--									<span class="num">80%</span>--%>
									<%--								</div>--%>
									<%--							</div>--%>
									<%--						</div>--%>
									<%--						<ul class="di_list">--%>
									<%--							<li>--%>
									<%--								<span class="di_li_tit">총 설비용량</span>--%>
									<%--								<span class="di_li_tx">7MW / 28MWh</span>--%>
									<%--							</li>--%>
									<%--						</ul>--%>
									<%--						<div class="di_tx_bx">--%>
									<%--							<p class="tx">최근 미처리 오류 : <span>2건</span></p>--%>
									<%--							<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
									<%--							<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
									<%--						</div>--%>
									<%--					</div>--%>
									<%--				</div>--%>
									<%--			</div>--%>
									<%--			<div class="btn_bx clear"><a href="#" class="btn_type02 fr">대시 보드 보기<span class="ico_arrow"></span></a></div>--%>
									<%--		</div>--%>
									<%--	</div>--%>
									<%--          </td>--%>
									<%--        </tr>--%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	const formData = null;

	$(function () {
		fn_cycle_1hour();
		fn_cycle_1min();
		setInterval(()=>fn_cycle_1hour(),60*60*1000);
		setInterval(()=>fn_cycle_1min(),60*1000);
	});

	function fn_cycle_1hour() {
		getYearGenData();
		drawData_year_gen();
		getMonthGenData();
		drawData_month_gen();
		getGenDataBySite();
	}

	function fn_cycle_1min() {
		getTodayTotalDetail();
		realtimeRecord();
		getAlarmInfo();
		getDeviceStatusInfo();
		const now = new Date();
		$('.dbTime').text(`${'${now.format("yyyy-MM-dd HH:mm:ss")}'}`);
	}

	//올해 발전데이터, 정산금 데이터
	let chargeList;
	let dischargeList;
	let pvList;
	let windList;
	let smallHydroList;
	let payList;

	function getYearGenData(selTerm) {
		chargeList = new Array(12).fill(0);
		dischargeList = new Array(12).fill(0);
		pvList = new Array(12).fill(0);
		payList = new Array(12).fill(0);
		const formData = getSiteMainSchCollection("year");//api에 맞게 수정 필요
		const today = new Date();
		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data: {
				oid: oid,
			},
			success: function (result) {
				$(`.gmain_chart1 span.term`).text(`${'${today.getFullYear()}'}.1.1 ~ ${'${today.getFullYear()}'}.${'${today.getMonth()+1}'}.${'${today.getDate()}'}`);
				result.forEach(site => {
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/sites",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							startTime: formData.startTime,
							endTime: formData.endTime,
							interval: "month"
						},
						success: function (result) {
							result.data[0].battery.charging.items.map((e) => {
								if (e.energy) {
									const month = Number(e.basetime.toString().slice(4, 6));
									chargeList[month - 1] += e.energy;
								}
							});
							result.data[0].battery.discharging.items.map((e) => {
								if (e.energy) {
									const month = Number(e.basetime.toString().slice(4, 6));
									dischargeList[month - 1] += e.energy;
								}
							});
							result.data[0].generation.items.map((e) => {
								if (e.energy) {
									const month = Number(e.basetime.toString().slice(4, 6));
									pvList[month - 1] += Math.floor(e.energy/1000);
								}
							});
							result.data[0].generation.items.map((e) => {
								if (e.energy) {
									const month = Number(e.basetime.toString().slice(4, 6));
									payList[month - 1] += Math.floor(e.money/1000);
								}
							});
							//데이터 세팅
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					})
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/now/sites",
						type: "get",
						async: false,
						data: {
							sids: site.sid,
							metering_type: 2,
							interval: "month"
						},
						success: function (result) {//api 요청결과
							if (result.data[site.sid].energy) {
								const month = Number(result.data[site.sid].start.toString().slice(4, 6));
								pvList[month - 1] += Math.floor(result.data[site.sid].energy/1000);
							}
							if (result.data[site.sid].money) {
								const month = Number(result.data[site.sid].start.toString().slice(4, 6));
								payList[month - 1] += Math.floor(result.data[site.sid].money/1000);
							}
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});
				})
			},
			error: function (error) {
				//error function or alert, return
				// error_getYearGenData(request, status, error);
			}
		})
		;
	}

	function drawData_year_gen() {
		const $charge = $(".gmain_chart1");
		if (chargeList.length < 1 && chargeList.length < 1 && dischargeList.length < 1 && dischargeList.length < 1) {
			$charge.find(".no-data").css("display", "");
			$charge.find(".inchart").css("display", "none");
		} else {
			$charge.find(".no-data").css("display", "none");
			$charge.find(".inchart").css("display", "");
		}

		var seriesLength = chargeChart1.series.length;
		for (var i = seriesLength - 1; i > -1; i--) {
			chargeChart1.series[i].remove();
		}

		chargeChart1.addSeries({
			name: '충전',
			type: 'column',
			color: '#2BEEE9',
			data: chargeList,
			tooltip: {
				valueSuffix: 'kWh'
			}
		}, false);
		chargeChart1.addSeries({
			name: '방전',
			type: 'column',
			color: '#878787',
			data: dischargeList,
			tooltip: {
				valueSuffix: 'kWh'
			}
		}, false);
		chargeChart1.addSeries({
			name: '태양광',
			type: 'column',
			color: '#9363FD',
			data: pvList,
			tooltip: {
				valueSuffix: 'kWh'
			}
		}, false);
		chargeChart1.addSeries({
			name: '정산금',
			type: 'spline',
			color: 'var(--color3)',
			dashStyle: 'ShortDash',
			yAxis: 1,
			data: payList,
			tooltip: {
				valueSuffix: '천원'
			}
		}, false);

		// chargeChart1.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		// chargeChart1.xAxis[0].options.labels.style.fontSize = '12px';

		chargeChart1.redraw(); // 차트 데이터를 다시 그린다
	}

	function getMonthGenData() {
		chargeList = new Array(30).fill(0);
		dischargeList = new Array(30).fill(0);
		pvList = new Array(30).fill(0);
		payList = new Array(30).fill(0);
		const formData = getSiteMainSchCollection("month");//api에 맞게 수정 필요
		const today = new Date();
		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data:{
				oid: oid,
			},
			success: function (result) {
				$(`.gmain_chart2 span.term`).text(`${'${today.getFullYear()}'}.${'${today.getMonth()+1}'}.1 ~ ${'${today.getFullYear()}'}.${'${today.getMonth()+1}'}.${'${today.getDate()}'}`);
				result.forEach(site=>{
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/sites",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							startTime: formData.startTime,
							endTime: formData.endTime,
							interval: "day"
						},
						success: function (result) {
							result.data[0].battery.charging.items.map((e) => {
								if (e.energy) {
									const day = Number(e.basetime.toString().slice(6, 8));
									chargeList[day - 1] += e.energy;
								}
							});
							result.data[0].battery.discharging.items.map((e) => {
								if (e.energy) {
									const day = Number(e.basetime.toString().slice(6, 8));
									dischargeList[day - 1] += e.energy;
								}
							});
							result.data[0].generation.items.map((e) => {
								if (e.energy) {
									const day = Number(e.basetime.toString().slice(6, 8));
									pvList[day - 1] += Math.floor(e.energy/1000);
								}
							});
							result.data[0].generation.items.map((e) => {
								if (e.energy) {
									const day = Number(e.basetime.toString().slice(6, 8));
									payList[day - 1] += Math.floor(e.money/1000);
								}
							});
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/now/sites",
						type: "get",
						async: false,
						data: {
							sids: site.sid,
							metering_type: 2,
							interval: "day"
						},
						success: function (result) {//api 요청결과
							const day = Number(result.data[site.sid].start.toString().slice(6, 8));
							if (result.data[site.sid].energy) {
								pvList[day - 1] += Math.floor(result.data[site.sid].energy/1000);
							}
							if (result.data[site.sid].money) {
								payList[day - 1] += Math.floor(result.data[site.sid].money/1000);
							}
							$('#centerTbody tr td:nth-child(5)').text(`${'${payList[day-1]}'} 천원`);
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});
				})
			},
			error: function(error){
				//error function or alert, return
				// error_getYearGenData(request, status, error);
			}
		});
	}

	function drawData_month_gen() {
		var $charge = $(".gmain_chart2");
		if (chargeList.length < 1 && chargeList.length < 1 && dischargeList.length < 1 && dischargeList.length < 1) {
			$charge.find(".no-data").css("display", "");
			$charge.find(".inchart").css("display", "none");
		} else {
			$charge.find(".no-data").css("display", "none");
			$charge.find(".inchart").css("display", "");
		}

		var seriesLength = chargeChart2.series.length;
		for (var i = seriesLength - 1; i > -1; i--) {
			chargeChart2.series[i].remove();
		}

		chargeChart2.addSeries({
			name: '충전',
			type: 'column',
			color: '#2BEEE9',
			data: chargeList,
			tooltip: {
				valueSuffix: 'kWh'
			}
		}, false);
		chargeChart2.addSeries({
			name: '방전',
			type: 'column',
			color: '#878787',
			data: dischargeList,
			tooltip: {
				valueSuffix: 'kWh'
			}
		}, false);
		chargeChart2.addSeries({
			name: '태양광',
			type: 'column',
			color: '#9363FD',
			data: pvList,
			tooltip: {
				valueSuffix: 'kWh'
			}
		}, false);
		chargeChart2.addSeries({
			name: '정산금',
			type: 'spline',
			color: 'var(--color3)',
			dashStyle: 'ShortDash',
			yAxis: 1,
			data: payList,
			tooltip: {
				valueSuffix: '천원'
			}
		}, false);

		chargeChart2.redraw(); // 차트 데이터를 다시 그린다
	}

	function getGenDataBySite() { //3번째 indiv 사업소별 탭

		const formData = getSiteMainSchCollection("yesterday");
		const today = new Date();
		const $tbody = $('#siteGenTbody');
		$tbody.empty();
		let tbodyStr = ``;
		//get siteInformation
		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data:{
				oid: oid,
			},
			success: function(result) {
				$(`.gmain_chart3 span.term`).text(`${'${today.getFullYear()}'}.${'${today.getMonth()+1}'}.${'${today.getDate()-1}'}`);
				result.forEach((site, siteIdx)=>{
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/sites",
						type: "get",
						async: false,
						data:{
							sid: site.sid,
							startTime: formData.startTime,
							endTime:formData.endTime,
							interval:"hour"
						},
						success: function(result) {//api 요청결과
							let generationSum = 0;
							result.data[0].generation.items.forEach((e) => {generationSum += e.energy;});
							let siteName =site.name.replace(/\s/g, "");
							if(generationSum>=1000){
								generationSum = (generationSum/1000);
							}else if(generationSum>=1000000){
								generationSum = (generationSum/1000000);
							}
							tbodyStr += `<tr><th>${'${siteName}'}</th><td>${'${Math.floor(generationSum)}'}</td>`;
							$(`.detail_info.flag${'${siteIdx+1}'} .sec_bx.left .di_list>li:nth-child(4)>span:nth-child(2)`).text(Math.floor(generationSum)+'kWh');
						},
						error: function(result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/forecasting/sites",
						type: "get",
						async: false,
						data:{
							sid: site.sid,
							startTime: formData.startTime,
							endTime:formData.endTime,
							interval:"hour"
						},
						success: function(result) {//api 요청결과
							let generationForecastSum = 0;
							result.data[0].generation.items.map((e)=>generationForecastSum+=e.energy);
							if(generationForecastSum>=1000){
								generationForecastSum = (generationForecastSum/1000);
							}else if(generationForecastSum>=1000000){
								generationForecastSum = (generationForecastSum/1000000);
							}
							tbodyStr += `<td>${'${Math.floor(generationForecastSum)}'}</td></tr>`;
						},
						error: function(result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});
				})
			},
			error: function(result, status, error) {
				//error function or alert, return
				// error_getYearGenData(request, status, error);
			}
		});
		$tbody.append(tbodyStr);
		drawPeakChart3();
	}

	function getGenDataByType() { //3번째 indiv 유형별 탭

		var formData = getSiteMainSchCollection();//api에 맞게 수정 필요

		//get sites information
		$.ajax({
			url: "",
			type: "post",
			async: false,
			data: formData,
			success: function (result) {//api 요청결과
				//success
				var siteList = result.list;

				var $tbody = $('#siteGenTbody');
				var tbodyStr = '';

				if (siteList != null && siteList.length > 0) {
					for (var i = 0; i < siteList.length; i++) {
						if (i < siteList.length) {
							var map = convertUnitFormat(siteList[i].usage, "Wh", 5);
							var map2 = convertUnitFormat(siteList[i].usage_plan, "Wh", 5);
							tbodyStr += '<tr>';
							tbodyStr += '<th>' + siteList[i].site_name + '</th>';
							tbodyStr += '<td>' + toFixedNum(map.get("formatNum"), 2) + '</td>';
							tbodyStr += '<td>' + toFixedNum(map2.get("formatNum"), 2) + '</td>';
							tbodyStr += '</tr>';
						}
					}

					var pagingMap = result.pagingMap;
					makePageNums2(pagingMap, "GMainSiteRanking");

				} else {
					$('#GMainSiteRankingPaging').empty();
				}

				$tbody.html(tbodyStr);

				if (myChart != null) {
					myChart.update({data: {table: 'gdatatable1'}});
				}
				//데이터 세팅
			},
			error: function (result, status, error) {
				//error function  or alert, return
				error_getMonthGenData(request, status, error);
			}
		});

		//임시 데이터 세팅
		//어제
		var $tbody = $('#typeGenTbody');
		$tbody.empty();
		var tbodyStr = '';
		tbodyStr += '<tr>';
		tbodyStr += '<th>태양광</th>';
		tbodyStr += '<td>50</td>';
		tbodyStr += '<td>100</td>';
		tbodyStr += '</tr>';
		tbodyStr += '<tr>';
		tbodyStr += '<th>풍력</th>';
		tbodyStr += '<td>50</td>';
		tbodyStr += '<td>100</td>';
		tbodyStr += '</tr>';
		tbodyStr += '<tr>';
		tbodyStr += '<th>소수력</th>';
		tbodyStr += '<td>50</td>';
		tbodyStr += '<td>100</td>';
		tbodyStr += '</tr>';

		$tbody.append(tbodyStr);

		drawPeakChart4();

		var $typeRight = $('.type-right');
		$typeRight.empty();
		var sun = '';
		sun += '<dl class="sun">';
		sun += '	<dt><span>태양광</span></dt>';
		sun += '<dd>';
		sun += '<p><strong>가동설비</strong> <span>13</span><em>기</em></p>';
		sun += '		<p><strong>용량</strong> <span>13</span><em>MW</em></p>';
		sun += '		<p><strong>전일발전량</strong> <span>3,500</span><em>kWH</em></p>';
		sun += '	</dd>';
		sun += '</dl>';
		$typeRight.append(sun);
		var wind = '';
		wind += '<dl class="wind">';
		wind += '	<dt><span>풍력</span></dt>';
		wind += '<dd>';
		wind += '<p><strong>가동설비</strong> <span>13</span><em>기</em></p>';
		wind += '		<p><strong>용량</strong> <span>13</span><em>MW</em></p>';
		wind += '		<p><strong>전일발전량</strong> <span>3,500</span><em>kWH</em></p>';
		wind += '	</dd>';
		wind += '</dl>';
		$typeRight.append(wind);

		var water = '';
		water += '<dl class="water">';
		water += '	<dt><span>소수력</span></dt>';
		water += '<dd>';
		water += '<p><strong>가동설비</strong> <span>13</span><em>기</em></p>';
		water += '		<p><strong>용량</strong> <span>13</span><em>MW</em></p>';
		water += '		<p><strong>전일발전량</strong> <span>3,500</span><em>kWH</em></p>';
		water += '	</dd>';
		water += '</dl>';
		$typeRight.append(water);
	}

	function getTodayTotalDetail() {

		pvListHourly = new Array(24).fill(0);
		pvListForecastingHourly = new Array(24).fill(0);

		$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(0);
		$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text(0);

		const formData = getSiteMainSchCollection("day");

		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data: {
				oid: oid,
			},
			success: function (result) {
				$('#centerTbody tr td:nth-child(1)').text(Math.floor(result.length));
				let acPowerSum = 0;
				let todayTotalGen = 0;
				let co2Sum = 0;
				result.forEach((site, siteIdx) => {
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/sites",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							startTime: formData.startTime,
							endTime: formData.endTime,
							interval: "hour"
						},
						success: function (result) {//api 요청결과
							let generationSum = 0;
							let moneySum = 0;
							result.data[0].generation.items.map((e) => {generationSum += e.energy;});
							result.data[0].generation.items.map((e) => moneySum += e.money);

							result.data[0].generation.items.map((e) => {
								if (e.energy) {
									const hour = Number(e.basetime.toString().slice(8, 10));
									pvListHourly[hour] += Math.floor(e.energy/1000);
								}
							});

							pieChart.series[0].data.forEach((e, idx) => {
								if (e.name === "태양광") {
									e.update({y: Math.floor(generationSum / 100)});
								} else if (e.name === "미사용량") {
									e.update({y: Math.floor((generationSum/(97280*2) )/ 100)});
								} else {
									e.update({y: 0});
								}
							});
							// let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text());
							// $('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(Math.floor(prevVal += (generationSum/1000)));
							// let prevBillVal = Number($('#centerTbody tr td:nth-child(5)').text());
							// $('#centerTbody tr td:nth-child(5)').text(Math.floor(prevBillVal += billingSum));
							<%--$(`.dbclickopen.flag${'${siteIdx+1}'} td:nth-child(7)`).text(Math.floor(generationSum/1000)+'kWh');--%>
							$(`.detail_info.list${'${siteIdx+1}'} .sec_bx.left li.clear:nth-child(3) span.fl:nth-child(2) em`).text(Math.floor(generationSum/1000));
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});

					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/forecasting/sites",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							startTime: formData.startTime,
							endTime: formData.endTime,
							interval: "hour"
						},
						success: function (result) {//api 요청결과
							let generationForecastSum = 0;
							result.data[0].generation.items.map((e, idx) => generationForecastSum += e.energy);
							let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text());
							$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text(Math.floor(prevVal += generationForecastSum/1000));
							$(`.dbclickopen.flag${'${siteIdx+1}'} td:nth-child(6)`).text(Math.floor(generationForecastSum/1000)+'kWh');
							$(`.detail_info.list${'${siteIdx+1}'} li.clear:nth-child(4) span.fl:nth-child(2) em`).text(Math.floor(generationForecastSum/1000));
							$(`.detail_info.flag${'${siteIdx+1}'} .sec_bx.left .di_list>li:nth-child(3)>span:nth-child(2)`).text(Math.floor(generationForecastSum/1000)+'kWh');
							result.data[0].generation.items.map((e) => {
								if (e.energy) {
									const hour = Number(e.basetime.toString().slice(8, 10));
									pvListForecastingHourly[hour] += Math.floor(e.energy/1000);
								}
							});
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});


					$.ajax({
						url: "http://iderms.enertalk.com:8443/status/raw/site",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							formId: 'v2'
						},
						success: function (result) {//api 요청결과
							$.map(result, function(val, key) {
								if(key == 'INV_PV') {
									acPowerSum += val.activePower;
									pieChart[`${'${siteIdx+1}'}`].setTitle({text:Math.floor(val.activePower/1000)+'kW'});
									pieChart[`${'${siteIdx+1}'}`].series[0].data.forEach((e, idx) => {
										if (e.name === "총 설비용량") {
											e.update({y: Math.floor(val.activePower/1000)});
										} else if (e.name === "미설비용량") {
											e.update({y: Math.floor(((97280*2)-val.activePower)/1000)});
										} else {
											e.update({y: 0});
										}
									});
									//$(`.dbclickopen.flag${'${siteIdx+1}'} td:nth-child(6)`).text(Math.floor(result.activePower/1000)+'kW');
									$(`.detail_info.flag${'${siteIdx+1}'} .sec_bx.left .di_list>li:nth-child(1)>span:nth-child(2)`).text(Math.floor(val.activePower/1000)+'kW');
									// $('.highcharts-title > tspan').text(Math.floor(activePowerSum/1000)+'kW');
									pieChart.setTitle({text:Math.floor(acPowerSum/1000)+'kW'});
									pieChart.series[0].data.forEach((e, idx) => {
										if (e.name === "태양광") {
											e.update({y: Math.floor(acPowerSum/1000)});
										} else if (e.name === "미사용량") {
											e.update({y: Math.floor(((97280*2)-acPowerSum)/1000)});
										} else {
											e.update({y: 0});
										}
									});
								} else if(key == 'SENSOR_SOLAR') {
									console.log('SENSOR_SOLAR', val);
									if(isEmpty(val)) {
										$(`.detail_info.flag${'${siteIdx+1}'} .tx_area .fl span:nth-child(2)`).text('- kW/㎡');
									} else {
										$(`.detail_info.flag${'${siteIdx+1}'} .tx_area .fl span:nth-child(2)`).text(displayNumberFixedUnit(val.irradiationPoa, 'W', 'W')[0] + ' W/㎡');
									}

								}
							});
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});

					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/now/sites",
						type: "get",
						async: false,
						data: {
							sids: site.sid,
							metering_type: 2,
							interval: "day"
						},
						success: function (result) {//api 요청결과
							if(!isEmpty(result.data[site.sid])) {
								todayTotalGen += Math.floor(result.data[site.sid].energy/1000);
								co2Sum += Math.floor(result.data[site.sid].co2);
								let prevVal = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text());
								$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(Math.floor(prevVal += (result.data[site.sid].energy/1000)));
								$(`.dbclickopen.flag${'${siteIdx+1}'} td:nth-child(7)`).text(Math.floor(result.data[site.sid].energy/1000)+'kWh');
								$(`.detail_info.flag${'${siteIdx+1}'} .sec_bx.left .di_list>li:nth-child(2)>span:nth-child(2)`).text(Math.floor(result.data[site.sid].energy/1000)+'kWh');
								$('#centerTbody tr td:nth-child(4)').text(`${'${Math.floor(co2Sum/1000)}'} kg`);
							}
						},
						error: function (result, status, error) {
							//error function or alert, return
							// error_getYearGenData(request, status, error);
						}
					});
				})
			},
			error: function () {

			}
		})
		pieChart.redraw();
		rChart3.update({
			series: [{
				name: '출력',
				type: 'column',
				color: '#2BEEE9',
				data: pvListHourly,
				tooltip: {
					valueSuffix: 'kWh'
				}
			},{
				name: '입찰',
				type: 'column',
				color: '#878787',
				data: pvListForecastingHourly,
				tooltip: {
					valueSuffix: 'kWh'
				}
			}],
		});
		rChart3.redraw();
	}

	function realtimeRecord(){
		const formDataHour = getSiteMainSchCollection("hour");
		const formDataDay = getSiteMainSchCollection("day");
		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data: {
				oid: oid,
			},
			success: function(sites){
				let todayForecastingGenAllSite = 0;
				let todayGenAllSite = 0;
				sites.forEach((site, siteIdx)=>{
					let thisHourForecastingGenBySite = 0;
					let thisHourGenBySite = 0;
					let todayForecastingGenBySite = 0;
					let todayGenBySite = 0;
					//사이트별 현재 시간 예측
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/forecasting/sites",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							startTime: formDataHour.startTime,
							endTime: formDataHour.endTime,
							interval: "hour"
						},
						success: function(result){
							thisHourForecastingGenBySite = Math.floor(result.data[0].generation.items[0].energy/1000);
						},
						error: function(error){
							console.error(error);
						}
					});
					//사이트별 현재 시간 출력
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/now/sites",
						type: "get",
						async: false,
						data: {
							sids: site.sid,
							metering_type: 2,
							interval: "hour"
						},
						success:function(result){
							thisHourGenBySite = Math.floor(result.data[`${'${site.sid}'}`].energy/1000);
						},
						error:function(error){
							console.error(error);
						}
					});
					//사이트별 오늘 예측
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/forecasting/sites",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							startTime: formDataDay.startTime,
							endTime: formDataDay.endTime,
							interval: "day"
						},
						success: function(result){
							//사이트 합 오늘 예측량 더하기
							todayForecastingGenBySite = Math.floor(result.data[0].generation.items[0].energy/1000);
							todayForecastingGenAllSite += todayForecastingGenBySite;
						},
						error: function(error){
							console.error(error);
						}
					});
					//사이트별 오늘 출력
					$.ajax({
						url: "http://iderms.enertalk.com:8443/energy/now/sites",
						type: "get",
						async: false,
						data: {
							sids: site.sid,
							metering_type: 2,
							interval: "day"
						},
						success:function(result){
							//사이트 합 오늘 출력량 더하기
							todayGenBySite = Math.floor(result.data[`${'${site.sid}'}`].energy/1000);
							todayGenAllSite += todayGenBySite;
						},
						error:function(error){
							console.error(error);
						}
					});

					let ratioHourly = 0;
					let restHourly = 0;
					let ratioDaily = 0;
					let restDaily = 0;

					if(todayForecastingGenAllSite<=todayGenAllSite){
						restDaily = null;
						ratioDaily = 100;
					}else{
						ratioDaily = Math.floor((todayGenAllSite/todayForecastingGenAllSite)*100);
						restDaily = 100-ratioDaily
					}

					if(thisHourForecastingGenBySite<=thisHourGenBySite){
						restHourly = null;
						ratioHourly = 100;
					}else{
						ratioHourly = Math.floor((thisHourGenBySite/thisHourForecastingGenBySite)*100);
						restHourly = 100-ratioHourly
					}

					const nowHour = new Date().getHours();
					pvListHourly[nowHour] = Math.floor(todayGenAllSite/1000);
					rChart3.update({
						series: [{
							name: '출력',
							type: 'column',
							color: '#2BEEE9',
							data: pvListHourly,
							tooltip: {
								valueSuffix: 'kWh'
							}
						},{
							name: '입찰',
							type: 'column',
							color: '#878787',
							data: pvListForecastingHourly,
							tooltip: {
								valueSuffix: 'kWh'
							}
						}],
					});
					rChart3.redraw();

					//rchart1 변경
					rchart1.series[0].data[`${'${siteIdx}'}`].z = ratioDaily;
					rchart1.series[0].data[`${'${siteIdx}'}`].y = ratioHourly;
					rchart1.redraw();

					//rchart2 변경
					rchart2.update({
						series: [{
							name: '입찰',
							data: [restHourly],
							tooltip: {
								valueSuffix: '%'
							},
							dataLabels: {
								enabled: true
							},
							color: '#575757' /* 입찰 */
						},{
							name: '출력',
							data: [ratioHourly],
							tooltip: {
								valueSuffix: '%'
							},
							dataLabels: {
								enabled: true
							},
							color: '#26ccc8' /* 출력 */
						}],
					});
					rchart2.redraw();
				});
			},
			error: function () {

			}
		});
		const now = new Date().getMinutes();
		const nowBottom = parseInt($('.realtime_time').css('bottom'),10);
		if(nowBottom >= 186){
			$('.realtime_time').css('bottom', '40px');
		}else{
			$('.realtime_time').css('bottom', 40+((146/60)*now));
		}
	}

	function getAlarmInfo() {
		// 조회 파라미터 세팅
		// 사업소 이름, 정상, 경고, 이상, 한번에 노출할 리스트 개수정보를 화면에서 던져줌. (처음- default)
		// 조회 시 세팅된 리스트 개수만큼 사이트의 리스트가 반환된다고 가정하고 작업
		// 리스트별 정보 -(알람시간,설비 유형 코드,설비 유형명,설비 id (장치id),설비명 (장치명),알람타입코드,알람타입명,알람메시지,알람상태)

		const formData = getSiteMainSchCollection("day");

		let alarmList = [];
		const $alarmList = $('.alarm_notice > ul');
		let alarmStr = '';

		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data: {
				oid: oid,
			},
			success: function (sites) {
				sites.forEach((site,siteIdx)=>{
					$.ajax({
						url: "http://iderms.enertalk.com:8443/alarms",
						type: "get",
						async: false,
						data: {
							sids: site.sid,
							startTime: formData.startTime,
							endTime: formData.endTime,
							confirm: false
						},
						success: function(alarms){
							let alarmWarning = 0;
							let alarmError = 0;

							alarms.forEach(alarm=>{
								alarmList = [...alarmList, alarm];

								console.log(alarm);
								if(alarm.level == 0 || alarm.level == 1 || alarm.level == 9) {
									alarmWarning ++;
								} else {
									alarmError ++;
								}
							});

							$(`.dbclickopen.flag${'${siteIdx+1}'} td:nth-child(2)`).text(alarmError);
							$(`.dbclickopen.flag${'${siteIdx+1}'} td:nth-child(3)`).text(alarmWarning);

							$(`.detail_info.flag${'${siteIdx+1}'} .di_tx_bx .tx span`).text(alarmError + alarmWarning + '건');
						},
						error: function(error){
							console.error(error)
						}
					});
				});
				$('.a_alert').find('em').text(`${'${alarmList.length}'}`); //알람 전체 개수
				//localtime 오름차순 정렬
				alarmList.sort((a,b)=>{
					return a.localtime > b.localtime ? -1 : a.localtime < b.localtime? 1 : 0 ;
				});
				//데이터 세팅
				alarmList.forEach((element, index)=>{
					alarmStr += `<li><a href="/history/alarmHistory.do?sid=${'${element.sid}'}&did=${'${element.did}'}"><span class="err_msg">${'${element.site_name} - ${element.message}'}</span><span class="err_time">${'${element.localtime.toString().slice(0,4)}'}-${'${element.localtime.toString().slice(4,6)}'}-${'${element.localtime.toString().slice(6,8)}'} ${'${element.localtime.toString().slice(8,10)}'}:${'${element.localtime.toString().slice(10,12)}'}:${'${element.localtime.toString().slice(12,14)}'}</span></a></li>`
				});
				$alarmList.empty();
				$alarmList.append(alarmStr);
			},
			error: function(error){
				console.error(error);
			}
		});

	}

	function getDeviceStatusInfo(){

		const formData = getSiteMainSchCollection("day");

		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data: {
				oid: oid,
			},
			success: function(sites){
				sites.forEach((site, siteIdx) => {
					$.ajax({
						url: "http://iderms.enertalk.com:8443/weather/site",
						type: "get",
						async: false,
						data: {
							sid: site.sid,
							startTime: formData.startTime,
							endTime: formData.endTime,
							interval: "hour"
						},
						success: function(weather){
							$(`.detail_info.flag${'${siteIdx+1}'} .tx_area .fr span:nth-child(1)`).text(weather[0].temperature + ' °C');
							$(`.detail_info.flag${'${siteIdx+1}'} .tx_area .fr span:nth-child(2)`).text(weather[0].humidity + ' %');
						},
						error: function(error){
							console.error(error);
						}
					})
				})
			},
			error: function(error){
				console.error(error);
			}
		})
	}
</script>









