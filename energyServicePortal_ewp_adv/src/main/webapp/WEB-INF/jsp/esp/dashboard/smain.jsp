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
				  <div class="time">
				    <span>CURRENT TIME</span>
				    <em class="currTime">${nowTime}</em>
				    <span>DATA BASE TIME</span>
				    <em>2018-07-27 17:01:02</em>
				  </div>
				</div>

				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_pv clear">
									<div class="chart_top clear">
										<h2 class="ntit">월별 발전량 종합</h2>
										<h1 class="stit">
											<fmt:parseDate var="startPrint" value="${startMonth }" pattern="yyyyMMddHHmmss"/>
											<fmt:parseDate var="endPrint" value="${startTime }" pattern="yyyyMMddHHmmss"/>

											<fmt:formatDate value="${startPrint}" pattern="yyyy.MM.dd"/>
											 ~
											 <fmt:formatDate value="${endPrint}" pattern="yyyy.MM.dd"/>
										</h1>
									</div>
									<div  class="chart_mid clear">
										<div class="box">
											<div class="line1">이번달 총 발전량</div>
											<div class="line2" id="monthEnergyValue"></div>
											<div class="line3" id="diffMonthEnergyValue"></div>
										</div>
										<div class="box">
											<div class="line1">올해 누적 발전량</div>
											<div class="line2" id="yearEnergyValue"></div>
											<div class="line3" id="diffYearEnergyValue"></div>
										</div>
									</div>
									<div class="inchart">
										<div id="schart1"></div>
										<script type="text/javascript">
										var chargeChart = Highcharts.chart('schart1', {
										    chart: {
										    	marginTop:40,
												marginLeft:50,
												marginRight:50,
												height: 286,
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
													  stacking: 'normal' /*위로 쌓이는 막대  ,normal */
												}
										    },
										    series: [{
										        name: 'PV발전량',
										        type: 'column',
										        color: '#26ccc8',
										        data: [],
										        tooltip: {
										            valueSuffix: 'kWh'
										        }

										    }, {
										        name: '매전량',
										        type: 'spline',
										        color: 'var(--color4)',
										        dashStyle: 'ShortDash',
										        yAxis: 1,
										        data: [],
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
	<script>

		const pollingTerm = 1000 * 60 * 15;
		const pollingTimeout = 5000;
		const debugMode = true;

		const apiURL = "http://iderms.enertalk.com:8443";
		const apiEnergySite = "/energy/sites";
		const apiWeather = "/weather";
		const apiForecastingSite = "/energy/forecasting/sites";

		const siteId = "0c7c90c6-9505-4f77-b42d-500c2879c689";

		let nowMonth = "<c:out value="${nowMonth}"/>";
		let nowWeek = "<c:out value="${nowWeek}"/>";
		let nowDay = "<c:out value="${nowDay}"/>";

		let chargeChartUrl = apiURL + apiEnergySite;
		let chargeChartData = {
			sid : siteId,
			startTime : "<c:out value="${startMonth }"/>",
			endTime : "<c:out value="${endMonth }"/>",
			interval : "month"
		};

		let chargeChartBeforeData = {
			sid : siteId,
			startTime : "<c:out value="${beforeStartMonth }"/>",
			endTime : "<c:out value="${beforeEndMonth }"/>",
			interval : "month"
		};

		let chargeChartItems1;
		let chargeChartItems2;

		function chargeChartPoll() {
			$.ajax({
				url : chargeChartUrl,
				type : "get",
				async : false,
				data : chargeChartData,
				success: function(result) {
					var data = result.data[0];
					chargeChartItems1 = data.generation.items;
					if(debugMode){ console.log("chargeChart:", chargeChartItems1); }
				},
	            dataType: "json",
	            complete: function() { chargeChartBeofrePoll(); },
	            timeout: pollingTimeout
	        })
		}

		function chargeChartBeofrePoll() {
			$.ajax({
				url : chargeChartUrl,
				type : "get",
				async : false,
				data : chargeChartBeforeData,
				success: function(result) {
					var data = result.data[0];
					chargeChartItems2 = data.generation.items;
					if(debugMode){ console.log("chargeChartBeofre:", chargeChartItems2); }

					setChargeChartData();
				},
	            dataType: "json",
	            complete: setTimeout(function() {chargeChartPoll()}, pollingTerm),
	            timeout: pollingTimeout
	        })
		}

		function setChargeChartData(){
			var totYearEnergy = 0;
			var totMonthEnergy = 0;
			var totBeforeYearEnergy = 0;
			var totBeforeMonthEnergy = 0;

			var energyData = [];
			var billingData = [];
			for (var i = 0; i < 12; i++) {
				if(i < chargeChartItems1.length){
					energyData[i] = [i, chargeChartItems1[i].energy];
					billingData[i] = [i, chargeChartItems1[i].billing];

					totYearEnergy += chargeChartItems1[i].energy;
					if( i+1 ==  nowMonth){ totMonthEnergy = chargeChartItems1[i].energy; }
				}else{
					energyData[i] = [i, null];
					billingData[i] = [i, null];
				}
			}

			for (var i = 0; i < 12; i++) {
				if(i < chargeChartItems2.length){
					totBeforeYearEnergy += chargeChartItems2[i].energy;
					if( i+1 ==  nowMonth){ totBeforeMonthEnergy = chargeChartItems2[i].energy; }
				}
			}

			if(debugMode){
				console.log("chargeChart energyData:", energyData);
				console.log("chargeChart billingData:", billingData);
			}

			chargeChart.series[0].setData(energyData);
			chargeChart.series[1].setData(billingData);


			diffYearEnergy = totYearEnergy - totBeforeYearEnergy;
			diffMonthEnergy = totMonthEnergy - totBeforeMonthEnergy;

			if(debugMode){
				console.log("chargeChart totYearEnergy", totYearEnergy);
				console.log("chargeChart totBeforeYearEnergy", totBeforeYearEnergy);
				console.log("chargeChart diffYearEnergy", diffYearEnergy);

				console.log("chargeChart totMonthEnergy", totMonthEnergy);
				console.log("chargeChart totBeforeMonthEnergy", totBeforeMonthEnergy);
				console.log("chargeChart diffMonthEnergy", diffMonthEnergy);
			}

			//TOTAL DATA
			/*
			yearEnergyValue  = <span class="pv">14.4</span><em>MWh</em>
			monthEnergyValue  = <span class="pv">763</span><em>kWh</em>

			diffYearEnergyValue = <i class="fa fa-arrow-down"></i><span>6,804</span>
			diffMonthEnergyValue = <i class="fa fa-arrow-down"></i><span>511</span>
			*/

			var diffYearIconClass = diffYearEnergy > 0 ? "fa-arrow-up" : (diffYearEnergy < 0 ? "fa-arrow-up" : "");
			if(totYearEnergy > 10000){
				$("#yearEnergyValue").html("<span class='pv'>" + numberComma((totYearEnergy / 1000).toFixed(2)) + "</span><em>MWh</em>");
				$("#diffYearEnergyValue").html("<i class='fa " + diffYearIconClass + "'></i><span>" + numberComma((Math.abs(diffYearEnergy) / 1000).toFixed(2))  + "</span>");
			}else{
				$("#yearEnergyValue").html("<span class='pv'>" + numberComma(totYearEnergy) + "</span><em>kWh</em>");
				$("#diffYearEnergyValue").html("<i class='fa " + diffIconClass + "'></i><span>" + numberComma(Math.abs(diffYearEnergy))  + "</span>");
			}

			var diffMonthIconClass = diffMonthEnergy > 0 ? "fa-arrow-up" : (diffMonthEnergy < 0 ? "fa-arrow-up" : "");
			if(totMonthEnergy > 10000){
				$("#monthEnergyValue").html("<span class='pv'>" + numberComma((totMonthEnergy / 1000).toFixed(2)) + "</span><em>MWh</em>");
				$("#diffMonthEnergyValue").html("<i class='fa " + diffMonthIconClass + "'></i><span>" + numberComma((Math.abs(diffMonthEnergy) / 1000).toFixed(2))  + "</span>");
			}else{
				$("#monthEnergyValue").html("<span class='pv'>" + numberComma(totMonthEnergy) + "</span><em>kWh</em>");
				$("#diffMonthEnergyValue").html("<i class='fa " + diffMonthIconClass + "'></i><span>" + numberComma(Math.abs(diffMonthEnergy))  + "</span>");
			}

		}

		chargeChartPoll();

	</script>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_cal">
									<div class="chart_top clear">
										<h2 class="ntit">이 달의 발전 달력</h2>
										<h1 class="stit"><em>${nowTime }</em></h1>
									</div>
									<div>
										<table class="calendar">
											<tr>
												<th>일</th>
												<th>월</th>
												<th>화</th>
												<th>수</th>
												<th>목</th>
												<th>금</th>
												<th>토</th>
											</tr>

											<c:forEach var="week" items="${calList}">
												<tr>
													<c:forEach var="day" items="${week }">
														<c:choose>
															<c:when test="${day ne 0 }">

																<td <c:if test="${nowDay eq day }">class="today"</c:if>>
																	<div>
																		<em class="calWeatherDay fl day">${day }</em>
																		<em id="calWeatherValue_${day }" class="fr"></em>
																	</div>
																	<div>
																		<div id="calWeatherIcon_${day }" class="wicon"></div>
																	</div>
																	<span id="calEnergyValue_${day }"></span>
																</td>

															</c:when>
															<c:otherwise>
																<td class="disabled">
																</td>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</tr>
											</c:forEach>

											<%--
												<i class="ico_weather w1"></i> 	1	- 맑음 o
												<i class="ico_weather w2"></i>   	- 바람 x
												<i class="ico_weather w3"></i>	20	- 안개 o
												<i class="ico_weather w4"></i>	7	- 흐림 o
												<i class="ico_weather w5"></i>	 	- 바람/비 x
												<i class="ico_weather w6"></i>	13	- 비또는눈 o
												<i class="ico_weather w7"></i>  	- 구름/바람/비 x
												<i class="ico_weather w8"></i>	11	- 눈 o
												<i class="ico_weather w9"></i>	17	- 천둥번개 o
												<i class="ico_weather w10"></i>	12 - 가끔눈 o
											--%>
											</tr>
										</table>


										<script>
										/*
											calWeatherValue_1 =  16.5℃
											calWeatherIcon_1 =  <i class="ico_weather w1"></i>
											calEnergyValue_1 = <strong>936</strong><em>kWh</em>
										*/

										//해당월의 에너지 데이터 - polling 없음
										let wCalendarEnergyUrl = apiURL + apiEnergySite;
										let wCalendarEnergyData = {
											sid : siteId,
											startTime : "<c:out value="${startDate }"/>",
											endTime : "<c:out value="${endDate }"/>",
											interval : "day"
										};

										$.ajax({
											url : wCalendarEnergyUrl,
											type : "get",
											async : false,
											data : wCalendarEnergyData,
											success: function(result) {
												var data = result.data[0];
												var items = data.generation.items;
												if(debugMode){ console.log("wCalendar:", items); }

												setWCalendarEnergyData(items);
											},
								            dataType: "json",
								            timeout: pollingTimeout
								        });

										function setWCalendarEnergyData(items){
											var calendarDays = $(".calWeatherDay");
											for (var i = 0; i < calendarDays.length; i++) {
												if(i < items.length){
													$("#calWeatherValue_" + (i+1)).text("16.5℃");
													$("#calWeatherIcon_" + (i+1)).html("<i class='ico_weather w1'></i>");


													if(items[i].energy > 10000){
														$("#calEnergyValue_" + (i+1)).html("<strong>" + numberComma((items[i].energy / 1000).toFixed(1)) + "</strong><em>MWh</em>");
													}else{
														$("#calEnergyValue_" + (i+1)).html("<strong>" + items[i].energy + "</strong><em>kWh</em>");
													}
												}
											}
										}

										//당일 에너지 데이터 - polling 사용
										let wCalendarEnergyDayUrl = apiURL + apiEnergySite;
										let wCalendarEnergyDayData = {
											sid : siteId,
											startTime : "<c:out value="${startTime}"/>",
											endTime : "<c:out value="${endTime }"/>",
											interval : "day"
										};

										(function wCalendarDayPoll() {
											$.ajax({
												url : wCalendarEnergyDayUrl,
												type : "get",
												async : false,
												data : wCalendarEnergyDayData,
												success: function(result) {
													var data = result.data[0];
													var items = data.generation.items;
													if(debugMode){ console.log("wCalendarDay:", items); }

													setWCalendarEnergyDayData(items);
												},
									            dataType: "json",
									            complete: setTimeout(function() {wCalendarDayPoll()}, pollingTerm),
									            timeout: pollingTimeout
									        })
										})();

										function setWCalendarEnergyDayData(items){
											if(items.length > 0){
												if(items[0].energy > 10000){
													$("#calEnergyValue_" + nowDay).html("<strong>" + numberComma((items[0].energy / 1000).toFixed(1)) + "</strong><em>MWh</em>");
												}else{
													$("#calEnergyValue_" + nowDay).html("<strong>" + items[0].energy + "</strong><em>kWh</em>");
												}
											}
										}

										//해당월의 날씨 데이터 - polling 없음
										let wCalendarWeatherUrl = apiURL + apiWeather;
										let wCalendarWeatherData = {
											sid : siteId,
											startTime : "<c:out value="${startDate }"/>",
											endTime : "<c:out value="${endDate }"/>",
											interval : "day"
										};

										$.ajax({
											url : wCalendarWeatherUrl,
											type : "get",
											async : false,
											data : wCalendarWeatherData,
											success: function(result) {
												var items = result;
												if(debugMode){ console.log("wCalendarWeatherData:", items); }

												setWCalendarWeatherData(items);
											},
								            dataType: "json",
								            timeout: pollingTimeout
								        });

										function getWeatherIconClass(weatherId){
											/*
											weather value 1 	> css w1
											weather value 20	> css w3
											weather value 7	> css w4
											weather value 13	> css w6
											weather value 11	> css w8
											weather value 17	> css w9
											weather value 12	> css w10
											*/

											var weatherIconClass = 1;
											switch(weatherId){
												case 1 :
													weatherIconClass = "w1";
													break;
												case 7 :
													weatherIconClass = "w4";
													break;
												case 11 :
													weatherIconClass = "w8";
													break;
												case 12 :
													weatherIconClass = "w10";
													break;
												case 13 :
													weatherIconClass = "w6";
													break;
												case 17 :
													weatherIconClass = "w9";
													break;
												case 20 :
													weatherIconClass = "w3";
													break;
											}
											return weatherIconClass
										}

										function setWCalendarWeatherData(items){
											var calendarDays = $(".calWeatherDay");
											for (var i = 0; i < calendarDays.length; i++) {
												if(i < items.length){
													$("#calWeatherValue_" + (i+1)).text( (items[i].temperature).toFixed(1) + "℃");

													var weatherIconClass = getWeatherIconClass(items[i].weather);
													$("#calWeatherIcon_" + (i+1)).html("<i class='ico_weather " + weatherIconClass + "'></i>");
												}
											}
										}
										</script>

									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_map smain_circle">
									<div class="chart_top clear">
										<h2 class="ntit">${siteName }<c:if test="${empty siteName }">사업소 현황</c:if></h2>
										<div class="btn_bx_type">
											<a href="#" class="btn cancel_btn">CCTV 보기</a>
										</div>
									</div>
									<div class="chart_box">
										<div class="chart_info">
											<div class="ci_left">
												<div class="inchart">
													<div id="pie_chart" style="height:200px;"></div>
													<script language="JavaScript">
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
																	/*
																	startAngle: -90,
																	endAngle: 90,
																	*/
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
																	color: '#9363fd',
																	name: '태양광',
																	dataLabels: {
														                enabled: false
														            },
																	y: 60 //60% -- 아래로 총합 100%
																}, {
																	color: '#84848f',
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
													<li><strong>총 설비용량</strong> <span>- </span><em>MW</em></li>
													<li><strong>실시간 DC입력</strong> <span>- </span><em>MW</em></li>
													<li><strong>실시간 AC출력</strong> <span>- </span><em>MW</em></li>
												</ul>
											</div>
										</div>
									</div>
									<div class="local_info smain s_center">
										<table>
											<thead>
												<tr>
													<th>PV 용량</th>
													<th>오늘 누적 발전량</th>
													<th>오늘 발전 예측</th>
													<th>SMP 수익 예상</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span>- </span>kWh</td>
													<td id="dayEnergyValue"></td>
													<td id="dayEnergyForeValue"></td>
													<td><span>- </span>￦</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_map smain_circle">
									<div class="chart_top clear">
										<h2 class="ntit">금일 발전현황</h2>
									</div>
									<div class="sa_wrap">
										<div class="inchart">
											<div id="schart2"></div>
											<script language="JavaScript">
												var saChart2 = Highcharts.chart('schart2', {
													chart: {
														marginTop:40,
														marginLeft:50,
														marginRight:0,
														height:301,
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
														categories: [
															'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
															'13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'
														],
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

													/* 출처 */
													credits: {
														enabled: false
													},

													/* 그래프 스타일 */
												    series: [{
												    	type: 'column',
												        name: 'PV발전량',
												        color: '#26ccc8', /* PV발전량 */
												        tooltip: { valueSuffix: 'kWh' },
												        data: []
												    },{
												    	type: 'column',
												        name: '발전 예측',
												        color: '#878787', /* 발전 예측 */
												        tooltip: { valueSuffix: 'kWh' },
												    	data: []
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
											</script>

		<script>
			let saChart2Url = apiURL + apiEnergySite;
			let saChart2Data = {
				sid : siteId,
				startTime : "<c:out value="${startTime}"/>",
				endTime : "<c:out value="${endTime}"/>",
				interval : "hour"
			};

			let saChart2ForeUrl = apiURL + apiForecastingSite;
			let saChart2ForeData = {
				sid : siteId,
				startTime : "<c:out value="${startTime}"/>",
				endTime : "<c:out value="${endTime}"/>",
				interval : "hour"
			};

			let saChart2EnergyItems1;
			let saChart2EnergyItems2;

			function saChart2Poll() {
				$.ajax({
					url : saChart2Url,
					type : "get",
					async : false,
					data : saChart2Data,
					success: function(result) {
						var data = result.data[0];
						saChart2EnergyItems1 = data.generation.items;
						if(debugMode){ console.log("saChart2:", saChart2EnergyItems1); }
					},
		            dataType: "json",
		            complete: function() {saChart2ForePoll()},
		            timeout: pollingTimeout
		        })
			}

			function saChart2ForePoll() {
				$.ajax({
					url : saChart2ForeUrl,
					type : "get",
					async : false,
					data : saChart2ForeData,
					success: function(result) {
						var data = result.data[0];
						saChart2EnergyItems2 = data.generation.items;
						if(debugMode){ console.log("saChartFore2:", saChart2EnergyItems2); }

						setSaChart2Data();
					},
		            dataType: "json",
		            complete: setTimeout(function() {saChart2Poll()}, pollingTerm),
		            timeout: pollingTimeout
		        })
			}

			function setSaChart2Data(){
				var totDayEnergy = 0;
				var totDayForeEnergy = 0;

				var energyData1 = [];
				var energyData2 = [];
				for (var i = 0; i < 24; i++) {
					if(i < saChart2EnergyItems1.length){
						energyData1[i] = [i, saChart2EnergyItems1[i].energy];
						energyData2[i] = [i, saChart2EnergyItems2[i].energy];

						totDayEnergy += saChart2EnergyItems1[i].energy;
						totDayForeEnergy += saChart2EnergyItems2[i].energy;
					}else{
						energyData1[i] = [i, null];
						energyData2[i] = [i, null];
					}
				}
				if(debugMode){
					console.log("saChart2 energyData1:", energyData1);
					console.log("saChart2 energyData2:", energyData2);
				}

				saChart2.series[0].setData(energyData1);
				saChart2.series[1].setData(energyData2)

				//TODAY DATA
				/*
				dayEnergyValue = <span>582</span>kWh
				*/
				if(totDayEnergy > 10000){
					$("#dayEnergyValue").html("<span>" + numberComma((totDayEnergy / 1000).toFixed(2)) + "</span> <em>MWh</em>");
				}else{
					$("#dayEnergyValue").html("<span>" + numberComma(totDayEnergy) + "</span> <em>kWh</em>");
				}

				if(totDayForeEnergy > 10000){
					$("#dayEnergyForeValue").html("<span>" + numberComma((totDayForeEnergy / 1000).toFixed(2)) + "</span> <em>MWh</em>");
				}else{
					$("#dayEnergyForeValue").html("<span>" + numberComma(totDayForeEnergy) + "</span> <em>kWh</em>");
				}
			}

			saChart2Poll();
		</script>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain weather">
									<div class="chart_top clear">
										<h2 class="ntit">기상 정보</h2>
										<h1 class="stit">${nowTime }</h1>
									</div>
									<div class="weater_wrap clear">
										<div class="fl wt_table_wrap">
											<!-- 날씨관련 아이콘 클래스명 확인 -->
											<!-- https://fontawesome.com/icons?d=gallery&q=weather&m=free -->
											<dl class="wt_table">
												<dt>
													<span id="weekIcon"></span>
													<strong> - </strong>
													<em id="weekTemp"></em>
												</dt>
												<dd class="dd_tbl">
													<table>
														<tr>
															<th>월</th>
															<th>화</th>
															<th>수</th>
															<th>목</th>
															<th>금</th>
															<th>토</th>
															<th>일</th>
														</tr>
														<tr>
															<td><span id="weekIcon_1"></span></td>
															<td><span id="weekIcon_2"></span></td>
															<td><span id="weekIcon_3"></span></td>
															<td><span id="weekIcon_4"></span></td>
															<td><span id="weekIcon_5"></span></td>
															<td><span id="weekIcon_6"></span></td>
															<td><span id="weekIcon_7"></span></td>
														</tr>
														<tr>
															<td id="weekTemp_1"></td>
															<td id="weekTemp_2"></td>
															<td id="weekTemp_3"></td>
															<td id="weekTemp_4"></td>
															<td id="weekTemp_5"></td>
															<td id="weekTemp_6"></td>
															<td id="weekTemp_7"></td>
														</tr>
													</table>
												</dd>
											</dl>
										</div>
										<div class="fr wt_list_wrap">
											<ul class="list_type">
												<li><strong>풍향</strong> <span> - </span></li>
												<li><strong>풍속</strong> <span id="weekWind"></span></li>
												<li><strong>습도</strong> <span id="weekHum"></span></li>
												<li><strong>경사일사량</strong><span> - kWh/㎡․day</span></li>
												<li><strong>수평일사량</strong><span> - kWh/㎡․day</span></li>
											</ul>
										</div>


										<script>
										//해당월의 날씨 데이터 - polling 없음
										let weekWeatherUrl = "http://iderms.enertalk.com:8443/weather";
										let weekWeatherData = {
											sid : siteId,
											startTime : "<c:out value="${startWeek }"/>",
											endTime : "<c:out value="${endWeek }"/>",
											interval : "day"
										};

										$.ajax({
											url : weekWeatherUrl,
											type : "get",
											async : false,
											data : weekWeatherData,
											success: function(result) {
												var items = result;
												if(debugMode){ console.log("weekWeatherData:", items); }

												setWeekWeatherData(items);
											},
								            dataType: "json",
								            timeout: pollingTimeout
								        });

										function setWeekWeatherData(items){
											/*
											weekIcon_1 = <i class="ico_weather w2"></i>
											weekTemp_1 = 16.5℃

											weekWindspped = 10.1km/h
											weekHumidity = 47%
											*/

											for (var i = 0; i < 7; i++) {
												if(i < items.length){
													$("#weekTemp_" + (i+1)).text( (items[i].temperature).toFixed(1));

													var weatherIconClass = getWeatherIconClass(items[i].weather);
													$("#weekIcon_" + (i+1)).html("<i class='ico_weather " + weatherIconClass + "'></i>");

													if(i+1 == nowWeek){
														$("#weekTemp").text( (items[i].temperature).toFixed(1) + "℃");
														$("#weekIcon").html("<i class='ico_weather " + weatherIconClass + "'></i>");
														$("#weekWind").text( (items[i].windspeed).toFixed(1) + " km/h");
														$("#weekHum").text( (items[i].humidity).toFixed(1) + " %");
													}
												}
											}
										}
										</script>

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
								<div class="indiv gmain_table smain wrap_type">
									<div class="gtbl_top clear">
										<div class="clear">
											<input type="text" class="input" value="" placeholder="키워드">
											<button type="submit">적용</button>
											<div class="check-option chk_type">
												<input type="checkbox" id="deviceStatus1" value="정상" checked>
												<label for="deviceStatus1"><span></span>정상</label>
												<input type="checkbox" id="deviceStatus2" value="경고" checked>
												<label for="deviceStatus2"><span></span>경고</label>
												<input type="checkbox" id="deviceStatus3" value="이상" checked>
												<label for="deviceStatus3"><span></span>이상</label>
											</div>
										</div>
									</div>
									<ul class="type_list">
										<li>
											<div class="chart_top clear">
												<h2 class="ntit">인버터(42)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상(39)</span>
													<span class="inv_error">이상(1)</span>
													<span class="inv_alert">경고(2)</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="tbl_type">
													<table>
														<colgroup>
														<col style="width:25%">
														<col style="width:25%">
														<col style="width:25%">
														<col style="width:25%">
														</colgroup>
														<thead>
															<tr>
																<th>순시 DC 입력</th>
																<th>금일 입력량</th>
																<th>순시 AC 출력</th>
																<th>누적 출력량</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td><span>85</span>kWh</td>
																<td><span>85</span>kWh</td>
																<td><span>85</span>kWh</td>
																<td><span>85</span>kWh</td>
															</tr>
														</tbody>
													</table>
												</div>
												<div class="gtbl_wrap type">
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
																	<th>DC입력</th>
																	<th>AC출력</th>
																	<th>효율</th>
																	<th>금일 누적발전</th>
																</tr>
															</thead>
															<tbody>
																<tr class="flag1">
																	<td>정상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag2">
																	<td>경고</td>
																	<td>인버터#2</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
																<tr class="flag3">
																	<td>이상</td>
																	<td>인버터#1</td>
																	<td>5kWh</td>
																	<td>5kWh</td>
																	<td>99%</td>
																	<td>152kWh</td>
																</tr>
															</tbody>
														</table>
													</div>
												</div>
											</div>
										</li>
										<li>
											<div class="chart_top clear">
												<h2 class="ntit">접속반(112)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상(89)</span>
													<span class="inv_error">이상(11)</span>
													<span class="inv_alert">경고(12)</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="tbl_type">
													<table>
														<thead>
															<tr>
																<th>평균 전압</th>
																<th>평균 전류</th>
																<th>평균 전력량</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td><span>85</span>kV</td>
																<td><span>85</span>kA</td>
																<td><span>85</span>kW</td>
															</tr>
														</tbody>
													</table>
												</div>
											</div>
										</li>
										<li>
											<div class="chart_top clear">
												<h2 class="ntit">계량기(3)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상(3)</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="tbl_type">
													<table>
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
												<h2 class="ntit">환경센서(3)</h2>
												<div class="alert_icon fr">
													<span class="inv_normail">정상(2)</span>
												</div>
											</div>
											<div class="type_list_detail">
												<div class="tbl_type">
													<table>
														<colgroup>
														<col style="width:33.3%">
														<col style="width:33.3%">
														<col style="width:33.3%">
														</colgroup>
														<thead>
															<tr>
																<th>기온</th>
																<th>풍속</th>
																<th>경사일사량</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td><span>15.4</span>℃</td>
																<td><span>10.1</span>km/h</td>
																<td><span>45</span>kWh/㎡․day</td>
															</tr>
														</tbody>
													</table>
												</div>
												<div class="tbl_type">
													<table>
														<colgroup>
														<col style="width:33.3%">
														<col style="width:33.3%">
														<col style="width:33.3%">
														</colgroup>
														<thead>
															<tr>
																<th>강수량</th>
																<th>평균 습도</th>
																<th>수평일사량</th>
															</tr>
														</thead>
														<tbody>
															<tr>
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