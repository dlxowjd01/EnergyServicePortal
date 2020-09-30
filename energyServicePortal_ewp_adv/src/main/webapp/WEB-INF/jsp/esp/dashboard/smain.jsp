<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="container-fluid">
	<div class="row header-wrapper">
		<div class="col-12">
			<h1 class="page-header fl">${siteName}</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime"></em>
				<span>DATA BASE TIME</span>
				<em class="dbTime"></em>
			</div>
		</div>
	</div>

	<%--
	--%>
	<div class="row content-wrapper">
		<div class="col-12">
			<div class="flex_start">
				<div class="dropdown">
					<!-- <button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="2" disabled>태양광 대시보드 #2<span class="caret"></span></button> -->
					<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="1" disabled>사이트 대시보드 #1<span class="caret"></span></button>
					<ul id="viewOptList" class="dropdown-menu">
						<li data-value="1" data-name="사이트 대시보드 #1"><a href="#" tabindex="-1">사이트 대시보드 #1</a></li>
						<li data-value="2" data-name="태양광 대시보드 #1"><a href="#" tabindex="-1">태양광 대시보드 #2</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>


	<div id="defaultDashboard" class="row">
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
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
				<div class="chart_mid clear">
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
					<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
					<div class="box type">
						<span class="tx_tit">그래프 옵션</span>
						<div class="sa_select">
							<div class="dropdown" id="chartType">
								<button type="button" class="dropdown-toggle w8" data-toggle="dropdown">
									PR<span class="caret"></span>
								</button>
								<ul class="dropdown-menu rdo_type" role="menu">
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t1" name="radio_t" value="1" checked>
											<label for="radio_t1">PR</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t2" name="radio_t" value="2">
											<label for="radio_t2">발전시간</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t3" name="radio_t" value="3">
											<label for="radio_t3">매전량</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					</c:if>
				</div>
				<div class="smain inchart">
					<div id="dailyChart"></div>
				</div>
			</div>
			<div class="indiv smain_cal">
				<div class="chart_top clear">
					<h2 class="ntit">이 달의 발전 달력</h2>
					<h1 class="stit">
						<fmt:parseDate var="sDate" value="${startDate}" pattern="yyyyMMddHHmmss"/>
						<fmt:parseDate var="eDate" value="${startTime}" pattern="yyyyMMddHHmmss"/>
						<fmt:formatDate var="sDt" pattern="yyyy-MM-dd" value="${sDate}"/>
						<fmt:formatDate var="eDt" pattern="yyyy-MM-dd" value="${eDate}"/>
						<em>${sDt} ~ ${eDt}</em>
					</h1>
				</div>
				<div class="calendar_wrap">
					<table class="calendar">
						<thead>
							<tr>
								<th>일</th>
								<th>월</th>
								<th>화</th>
								<th>수</th>
								<th>목</th>
								<th>금</th>
								<th>토</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="week" items="${calList}">
								<tr>
									<c:forEach var="day" items="${week }">
										<c:choose>
											<c:when test="${day ne 0 }">
												<td <c:if test="${nowDay eq day }">class="today"</c:if>>
													<div class="flex_wrapper">
														<em class="calWeatherDay day">${day }</em>
														<em id="calWeatherValue_${day }"></em>
													</div>
													<div id="calWeatherIcon_${day }" class="wicon"></div>
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
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv gmain_map smain_circle">
				<div class="chart_top clear">
					<h2 class="ntit">${siteName} <c:if test="${empty siteName }">사업소 현황</c:if></h2>
					<div class="btn_bx_type">
						<a href="javascript:void(0);" class="btn cancel_btn" id="cctv">CCTV 보기</a>
					</div>
				</div>
				<div class="chart_box">
					<div class="chart_info">
						<div class="ci_left">
							<div class="inchart">
								<div id="pie_chart" style="height:200px; width:230px"></div>
							</div>
						</div>
						<div class="ci_right">
							<div class="legend_wrap">
								<span class="bu1">태양광</span>
								<span class="bu4">미 사용량</span>
							</div>
							<ul>
								<c:choose>
									<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
										<li><strong>목표출력</strong> <span id="siteCapacity">-</span><em>kW</em></li>
										<li><strong>수신시간</strong> <span id="siteDcPower">-</span></li>
										<li><strong>송신시간</strong> <span id="siteAcPower">-</span></li>
									</c:when>
									<c:otherwise>
										<li><strong>총 설비용량</strong> <span id="siteCapacity">-</span><em>kW</em></li>
										<li><strong>실시간 DC입력</strong> <span id="siteDcPower">-</span><em>kW</em></li>
										<li><strong>실시간 AC출력</strong> <span id="siteAcPower">-</span><em>kW</em></li>
									</c:otherwise>
								</c:choose>

							</ul>
						</div>
					</div>
				</div>
				<div class="local_info smain s_center">
					<table>
						<c:choose>
							<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
						<thead>
						<tr>
							<th>설비 용량</th>
							<th>금일 누적 발전량</th>
							<th>전일 누적 발전량</th>
							<th>금일 발전 시간</th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td><em>&nbsp;&nbsp;kW</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;H</em></td>
						</tr>
						</tbody>
							</c:when>
							<c:otherwise>
						<thead>
						<tr>
							<th>PV 용량</th>
							<th>금일 누적 발전량</th>
							<th>금일 발전 예측량</th>
							<th>SMP 수익 예상</th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td><em>&nbsp;&nbsp;kW</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;천원</em></td>
						</tr>
						</tbody>
							</c:otherwise>
						</c:choose>
					</table>
				</div>
			</div>
			<div class="indiv gmain_map smain_circle">
				<div class="chart_top clear">
					<h2 class="ntit">금일 발전현황</h2>
				</div>
				<div class="sa_wrap">
					<div class="inchart">
						<div id="hourlyChart"></div>
					</div>
				</div>
			</div>
			<div class="indiv smain weather">
				<div class="chart_top clear">
					<h2 class="ntit">기상 정보</h2>
					<h1 id="currentTimeA" class="stit">${nowTime }</h1>
				</div>
				<div class="weather-wrap clear">
					<div class="fl weather-table-box">
						<dl class="weather-table">
							<dt>
								<span id="weekIcon"></span>
								<strong> - </strong>
								<em id="weekTemp"></em>
							</dt>
							<dd class="dd_tbl">
								<table>
									<tr>
										<th>오늘</th>
										<th>내일</th>
										<th>모레</th>
									</tr>
									<tr>
										<td><span id="weekIcon1"></span></td>
										<td><span id="weekIcon2"></span></td>
										<td><span id="weekIcon3"></span></td>
									</tr>
									<tr>
										<td id="weekTemp1"></td>
										<td id="weekTemp2"></td>
										<td id="weekTemp3"></td>
										<td id="weekTemp4"></td>
										<td id="weekTemp5"></td>
										<td id="weekTemp6"></td>
										<td id="weekTemp7"></td>
									</tr>
								</table>
							</dd>
						</dl>
					</div>
					<div class="fr wt_list_wrap">
						<ul class="list_type">
							<li><strong>풍향</strong> <span id="weekWindDirection">-</span> &deg;</li>
							<li><strong>풍속</strong> <span id="weekWindVelocity"></span></li>
							<li><strong>습도</strong> <span id="weekHum"></span></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv smain_alarm wrap_type">
				<div class="alarm_stat clear">
					<div class="a_alert"><span>금일 발생 오류</span><em>0</em></div>
					<div class="a_warning"><a href="javascript:void(0);" onclick="pageMove('', 'alarm');" class="btn cancel_btn">상세보기</a></div>
				</div>
				<div class="alarm_notice">
					<ul id="alarmNotice">
						<li>
							<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');" class="[level]">
								<span class="err_msg">[site_name] - [message]</span>
								<span class="err_time">[standardTime]</span>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<div class="indiv gmain_table smain wrap_type">
				<div class="gtbl_top clear">
					<div class="fl">
						<input type="text" class="input" name="keyword" value="" placeholder="키워드">
					</div>
					<div class="fr">
						<span class="tx_tit">설비 상태</span>
						<div class="sa_select">
							<div class="dropdown" id="statusDevice">
								<button type="button" class="dropdown-toggle w8" data-toggle="dropdown" data-name="선택">
									전체 <span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu">
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="0" checked>
											<label for="deviceStatus1">중지</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="1" checked>
											<label for="deviceStatus2">정상</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus3" name="deviceStatus" value="2" checked>
											<label for="deviceStatus3">트립</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				<ul class="type_list" id="typeList">
					<li class="[type]">
						<div class="chart_top clear">
							<h2 class="ntit">[name] (<span>0</span>)</h2>
							<div class="alert_icon fr">
								<span class="inv_normal">정상 (<span>0</span>)</span>
								<span class="inv_error">트립 (<span>0</span>)</span>
								<span class="inv_alert">중지 (<span>0</span>)</span>
							</div>
						</div>
						<div class="type_list_detail">
							<div class="tbl_type">
								[head]
							</div>
							<div class="gtbl_wrap type">
								<div class="intable">
									[body]
								</div>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<%--
	--%>

	<div id="solarDashboard" class="hidden">
		<div class="row">
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit">현재 발전</h3>
					<p class="word-wrap"><span class="data-num">2342432</span><span class="data-unit">kW</span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit">현재 발전 효율</h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit">금일 발전량</h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit">전일 발전량</h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit">월간 발전량</h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit">누적 발전량</h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-xl-4 col-lg-5 col-md-6 col-sm-12">
				<div class="indiv">
					<h2 class="ntit">금일 발전현황</h2>
					<div id="hourlySolarChart"></div>
				</div>
			</div>

			<div class="col-xl-4 col-lg-7 col-md-6 col-sm-12">
				<div class="indiv">
					<h2 class="ntit">인버터별 출력 현황</h2>
					<div id="hourlyINVChart"></div>
				</div>
			</div>

			<div class="col-xl-4 col-lg-12 col-md-12 col-sm-12">
				<div class="indiv gmain_table smain wrap_type unset">
					<div class="gtbl_top clear">
						<h2 class="tx_tit">인버터 상태</h2>
					</div>
					<ul class="inverter_list" id="inverterList">
						<li class="[type]">
							<div class="chart_top clear">
								<h2 class="ntit">[name] (<span>0</span>)</h2>
								<div class="alert_icon fr">
									<span class="inv_normal">정상 (<span>0</span>)</span>
									<span class="inv_error">트립 (<span>0</span>)</span>
									<span class="inv_alert">중지 (<span>0</span>)</span>
								</div>
							</div>
							<div class="type_list_detail">
								<div class="tbl_type">
									[head]
								</div>
								<div class="gtbl_wrap type">
									<div class="intable">
										[body]
									</div>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>

		</div>

		<div class="row">
			<div class="col-xl-4 col-lg-5 col-md-6 col-sm-12">
				<div class="indiv smain-tab-box">
					<ul class="nav nav-tabs w-60">
						<li class="nav-item active">
							<a class="nav-link" data-toggle="tab" href="#weatherInfo">기상 정보</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" data-toggle="tab" href="#powerConnctor">접속반</a>
						</li>
					</ul>
					<span id="currentTimeB" class="stit">${nowTime}</span>
					<div class="tab-content">
						<div class="tab-pane fade active in" id="weatherInfo">
							<div class="weather-wrap clear">
								<div class="fl weather-table-box">
									<dl class="weather-table">
										<dt>
											<span id="weekSolarIcon"></span>
											<strong> - </strong>
											<em id="sTemp"></em>
										</dt>
										<dd class="dd_tbl">
											<table>
												<tr>
													<th>오늘</th>
													<th>내일</th>
													<th>모레</th>
												</tr>
												<tr>
													<td><span id="sWeatherIcon1"></span></td>
													<td><span id="sWeatherIcon2"></span></td>
													<td><span id="sWeatherIcon3"></span></td>
												</tr>
												<tr>
													<td id="sTemp1"></td>
													<td id="sTemp2"></td>
													<td id="sTemp3"></td>
													<td id="sTemp4"></td>
													<td id="sTemp5"></td>
													<td id="sTemp6"></td>
													<td id="sTemp7"></td>
												</tr>
											</table>
										</dd>
									</dl>
								</div>
								<div class="fr wt_list_wrap">
									<ul class="list_type">
										<li><strong>풍향</strong> <span id="sWindDirection">-</span> &deg;</li>
										<li><strong>풍속</strong> <span id="sWindVelocity"></span></li>
										<li><strong>습도</strong> <span id="sHumidity"></span></li>
									</ul>
								</div>
							</div>
							
						</div>
						<div class="tab-pane fade" id="powerConnctor">
							<h2>현재 데이터가 없습니다.</h2>
						</div>
					</div>
				</div>
			</div>

			<div class="col-xl-8 col-lg-7 col-md-6 col-sm-12">
				<div class="indiv">
					<h2 class="ntit">일별 발전량</h2>
					<div id="dailySolarChart"></div>
					<div id="dailySolarTrendChart"></div>
				</div>
			</div>
		</div>
	</div>

</div>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		let viewOptList = $('#viewOptList');
		let switchFlag = false;
		let refreshMinInterval = setInterval(getMinuteData, 60 * 1000);
		let refreshQuarterInterval = setInterval(getQuarterData, 15 * 60 * 1000);

		// let today = new Date().format('yyyy-MM-dd HH:mm:ss');

		$('input[name="keyword"]').on('keyup', function(e) {
			if (e.which == '13') {
				getDvcInfo();
			}
		});

		if(!isEmpty(sList[0].devices) && sList[0].devices.length>0){
			let dList = sList[0].devices;
			for(let i=0, arrLength = dList.length; i<arrLength; i++){
				if(dList[i].device_type == "INV_PV"){
					viewOptList.prev().prop("disabled", false);
					break;
				}
			};
		} else {
			viewOptList.prev().prop("disabled", true);
		}


		if(viewOptList.prev().data("value") == "2"){
			// $("#currentTimeB").text(today);
			$('#defaultDashboard').addClass("hidden");
			$('#solarDashboard').removeClass("hidden");
			setInitList('inverterList');
		} else {
			$('#defaultDashboard').removeClass("hidden");
			$('#solarDashboard').addClass("hidden");
			setInitList('typeList');
			setInitList('alarmNotice');
		}


		if (!isEmpty(siteList)) {
			siteList.forEach(site => {
				if (isEmpty(site.cctv)) {
					$('#cctv').addClass('hidden');
				} else {
					$('#cctv').attr('href', site.cctv);
				}
			});
		}


		getDvcProperties();
		getWeatherData();
		getNowEnergy();

		getMinuteData();
		getQuarterData();

		Highcharts.setOptions({
			lang : {
				resetZoom : '확대/축소 초기화'
			}
		});

		viewOptList.find('li').on('click', function(){
			let val = $(this).data("value");
			let name = $(this).data("name");

			if(switchFlag == false) {
				if(viewOptList.prev().text() != name) {
					if(val == "1"){
						$('#defaultDashboard').removeClass("hidden");
						$('#solarDashboard').addClass("hidden");
					} else {
						// $("#currentTimeB").text(today);
						getMinuteData(val);
						getQuarterData(val);
						getWeatherData(val);
						setInitList('inverterList');
						$('#defaultDashboard').addClass("hidden");
						$('#solarDashboard').removeClass("hidden");
					}
				}

			} else {
				console.log("btnText2===", viewOptList.prev().text(), "name===", name);
				if(viewOptList.prev().text() != name) {
					if(val == "1"){
						$('#defaultDashboard').removeClass("hidden");
						$('#solarDashboard').addClass("hidden");
					} else {
						// $("#currentTimeB").text(today);
						getMinuteData(val);
						getQuarterData(val);
						getWeatherData(val);
						setInitList('inverterList');
						$('#defaultDashboard').addClass("hidden");
						$('#solarDashboard').removeClass("hidden");
					}
					clearInterval(refreshMinInterval);
					clearInterval(refreshQuarterInterval);
					setTimeout(function(){
						refreshMinInterval = setInterval(getMinuteData, 60 * 1000);
						refreshQuarterInterval = setInterval(getQuarterData, 15 * 60 * 1000);
					}, 300);
				}
			}
			switchFlag = true;
			viewOptList.prev().data("value", val);
		});

	});

	const siteId = '${sid}';
	const siteList = JSON.parse('${siteList}');
	const apiEnergySite = '/energy/sites';
	const apiEnergyNowSite = '/energy/now/sites';
	const apiEnergyDvc = '/energy/devices';
	const apiWeather = '/weather/site';
	const apiForecastingSite = '/energy/forecasting/sites';
	const apiStatusRawSite = '/status/raw/site';
	const apiStatusRaw = '/status/raw';
	const apiConfigDevice = '​/config/devices';
	const apiGetDvcProperties = '/config/view/device_properties';
	const featureProperties = new Object();
	const featurePropertiesSub = new Object();
	const pollingTerm = 1000 * 60 * 15;

	let sList = JSON.parse('${siteList}');
	let first = true;
	let toDayEnergy = 0;
	let toDayRaw = 0;

	var num12List = [];
	var num24List = [];
	var num31List = [];

	for(let i=0; i<12; i++){
		num12List.push(String(i+1));
	}
	for(let i=0; i<24; i++){
		num24List.push(String(i+1));
	}
	for(let i=0; i<31; i++){
		num31List.push(String(i+1));
	}

	var pieChart = Highcharts.chart('pie_chart', {
		chart: {
			marginTop: 0,
			marginLeft: 0,
			marginRight: 0,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			plotBorderWidth: 0,
			plotShadow: false,
			height: 180
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: '- Wh',
			align: 'center',
			verticalAlign: 'middle',
			y: 10,
			x: 0,
			style: {
				fontSize: '14px',
				color: 'var(--white60)'
			}
		},
		subtitle: {
			text: ''
		},
		credits: {
			enabled: false
		},
		tooltip: {
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)'
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
						color: 'var(--white)'
					}
				},
				center: ['40%', '50%'],
				borderWidth: 0,
				size: '100%'
			}
		},
		series: [{
			type: 'pie',
			innerSize: '70%',
			name: '발전량',
			colorByPoint: true,
			data: [{
				color: 'var(--circle-solar-power)',
				name: '태양광',
				dataLabels: {
					enabled: false
				},
				y: 60
			}, {
				color: 'var(--grey)',
				name: '미사용량',
				dataLabels: {
					enabled: false
				},
				y: 20
			}]
		}],
		responsive: {
			rules: [{
				condition: {
					maxWidth: 768
				},
				chartOptions: {
					plotOptions: {
						pie: {
							center: ['50%', '50%']
						}
					}
				}
			}]
		}
	});

	var dailyChart = Highcharts.chart('dailyChart', {
		chart: {
			marginTop: 40,
			marginLeft: 50,
			marginRight: 50,
			height: 280,
			backgroundColor: 'transparent',
			zoomType: 'xy'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [{
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 1,
			title: {
				text: null
			},
			categories: num12List,
			crosshair: true
		}],
		yAxis: [
			{
				lineColor: 'var(--white60)',
				tickColor: 'var(--white60)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [{
					color: 'var(--white60)',
					width: 1
				}],
				gridLineWidth: 1,
				title: {
					text: 'kWh',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 15,
					style: {
						color: 'var(--white)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						if (String(this.value).length  >= 7) {
							return numberComma(this.value / 1000000) + ' G';
						} else if (String(this.value).length  >= 5) {
							return numberComma(this.value / 1000) + ' M';
						} else {
							return this.value;
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}
			},
			<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			{
				lineColor: 'var(--white60)',
				tickColor: 'var(--white60)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [
					{
						color: 'var(--white60)',
						width: 1
					}
				],
				gridLineWidth: 1,
				title: {
					text: '천원',
					align: 'low',
					rotation: 0,
					y: 25,
					x: -12,
					style: {
						color: 'var(--white)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						if (String(this.value).length  >= 7) {
							return numberComma(this.value / 1000000) + ' G';
						} else if (String(this.value).length  >= 5) {
							return numberComma(this.value / 1000) + ' M';
						} else {
							return this.value;
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				opposite: true
			}
			</c:if>
		],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(point.y) + suffix;
				}, '<b>' + this.x + '</b>');
			},
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)'
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: -10,
			y: -10,
			itemStyle: {
				color: 'var(--grey)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			line: {
				marker: {
					enabled: false
				}
			},
			column: {
				stacking: 'normal'
			}
		},
		series: [
			{
				<c:choose>
					<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				name: '발전 실적',
					</c:when>
					<c:otherwise>
				name: 'PV발전량',
					</c:otherwise>
				</c:choose>
				type: 'column',
				color: 'var(--turquoise)',
				data: [],
				tooltip: {
					valueSuffix: 'kWh'
				}

			},
			<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			{
				name: '일사량',
				type: 'spline',
				dashStyle: 'ShortDash',
				color: 'var(--white60)',
				yAxis: 1,
				data: [],
				tooltip: {
					valueSuffix: '천원'
				}
			}
			</c:if>
		],
		credits: {
			enabled: false
		},
		responsive: {
			rules: [{
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
			}]
		}
	});

	var dailySolarChart = Highcharts.chart('dailySolarChart', {
		chart: {
			marginTop: 80,
			marginLeft: 0,
			marginRight: 60,
			height: 280,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			events: {
				selection: function(e) {
					// if (mouseMovedBy < 0) {
					// 	e.target.xAxis[0].setExtremes();
					// 	return false;
					// }
				}
			}
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [{
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 1,
			title: {
				text: null
			},
			categories: num12List,
			// categories: num31List,
			crosshair: true
		}],
		yAxis: [
			{
				opposite: true,
				lineColor: 'var(--white60)',
				tickColor: 'var(--white60)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [
					{
						color: 'var(--white60)',
						width: 1
					}
				],
				// offset: -40,
				title: {
					text: 'kWh',
					align: 'low',
					rotation: 0,
					y: 30,
					x: -13,
					style: {
						color: 'var(--grey)',
						fontSize: '12px',
					}
				},
				labels: {
					// y: -8,
					overflow: 'justify',
					style: {
						color: 'var(--grey)',
						fontSize: '12px',
					},
				}
			},
		],
		tooltip: {
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)'
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: -10,
			y: -10,
			itemStyle: {
				color: 'var(--grey)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 0,
			symbolHeight: 7,
			lineHeight: 12
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			line: {
				marker: {
					enabled: true
				}
			},
			column: {
				stacking: 'normal'
			}
		},
		credits: {
			enabled: false
		},
		responsive: {
			rules: [{
				condition: {
					minWidth: 787
				},
				chartOptions: {
					xAxis: {
						labels: {
							style: {
								fontSize: '12px'
							}
						}
					},
					yAxis: [{
						title: {
							style: {
								fontSize: '12px'
							}
						},
						labels: {
							style: {
								fontSize: '12px'
							}
						}
					}],
				}
			}]
		}
	});

	var dailySolarTrendChart = Highcharts.chart('dailySolarTrendChart', {
		chart: {
			// marginTop: 70,
			// marginLeft: 0,
			// marginRight: 20,
			marginTop: 0,
			marginLeft: 0,
			marginRight: 60,
			height: 120,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			// resetZoom: '확대/축소 초기화'
			// type: 'line'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [{
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 1,
			title: {
				text: null
			},
			categories: num31List,
			// categories: num31List,
			crosshair: true
		}],
		yAxis: {
				visible: false,
				// lineColor: 'var(--white60)',
				// tickColor: 'var(--white60)',
				// gridLineColor: 'var(--white25)',
				// gridLineWidth: 1,
				// plotLines: [
				// 	{
				// 		color: 'var(--white60)',
				// 		width: 1
				// 	}
				// ],
				// // offset: -40,
				// title: {
				// 	text: 'kWh',
				// 	align: 'low',
				// 	rotation: 0,
				// 	y: 30,
				// 	x: -13,
				// 	style: {
				// 		// color: 'var(--white60)',
				// 		color: 'var(--alarm)',
				// 		fontSize: '12px'
				// 	}
				// },
				// labels: {
				// 	// y: -8,
				// 	overflow: 'justify',
				// 	style: {
				// 		color: 'var(--grey)',
				// 		fontSize: '12px'
				// 	}
				// }
			},
		
		tooltip: {
			// shared: true,
			shared: false,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)'
			},
			valueSuffix: ' kwh',
		},
		legend: {
			enabled: false,
			// enabled: true,
			// align: 'right',
			// verticalAlign: 'top',
			// x: -10,
			// y: -10,
			// itemStyle: {
			// 	color: 'var(--grey)',
			// 	fontSize: '12px',
			// 	fontWeight: 400
			// },
			// itemHoverStyle: {
			// 	color: ''
			// },
			// symbolPadding: 0,
			// symbolHeight: 7,
			// lineHeight: 12
		},
		plotOptions: {
			// cursor: 'pointer',
			series: {
				label: {
					connectorAllowed: false
				},
				// !!!!!!!!!!!!!!!!IMPORTANT
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			borderColor: 'var(--grey)',
			borderWidth: 0,
			// series: {
			// 	label: {
			// 		connectorAllowed: false
			// 	},
			// 	borderColor: 'var(--grey)',
			// 	borderWidth: 0
			// },
			marker: {
                lineWidth: 1
            }
		},
		credits: {
			enabled: false
		},
		responsive: {
			rules: [
				{
					condition: {
						minWidth: 787
					},
					{
						title: {
							style: {
								fontSize: '12px'
							}
						},
						labels: {
							style: {
								fontSize: '12px'
							}
						}
					}],
				}
			}]
		}
	});

	var dailySolarTrendChart = Highcharts.chart('dailySolarTrendChart', {
		chart: {
			// marginTop: 70,
			// marginLeft: 0,
			// marginRight: 20,
			marginTop: 0,
			marginLeft: 0,
			marginRight: 60,
			height: 120,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			// resetZoom: '확대/축소 초기화'
			// type: 'line'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [{
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 1,
			title: {
				text: null
			},
			categories: num31List,
			// categories: num31List,
			crosshair: true
		}],
		yAxis: {
				visible: false,
				// lineColor: 'var(--white60)',
				// tickColor: 'var(--white60)',
				// gridLineColor: 'var(--white25)',
				// gridLineWidth: 1,
				// plotLines: [
				// 	{
				// 		color: 'var(--white60)',
				// 		width: 1
				// 	}
				// ],
				// // offset: -40,
				// title: {
				// 	text: 'kWh',
				// 	align: 'low',
				// 	rotation: 0,
				// 	y: 30,
				// 	x: -13,
				// 	style: {
				// 		// color: 'var(--white60)',
				// 		color: 'var(--alarm)',
				// 		fontSize: '12px'
				// 	}
				// },
				// labels: {
				// 	// y: -8,
				// 	overflow: 'justify',
				// 	style: {
				// 		color: 'var(--grey)',
				// 		fontSize: '12px'
				// 	}
				// }
			},
		
		tooltip: {
			// shared: true,
			shared: false,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)'
			},
			valueSuffix: ' kwh',
		},
		legend: {
			enabled: false,
			// enabled: true,
			// align: 'right',
			// verticalAlign: 'top',
			// x: -10,
			// y: -10,
			// itemStyle: {
			// 	color: 'var(--grey)',
			// 	fontSize: '12px',
			// 	fontWeight: 400
			// },
			// itemHoverStyle: {
			// 	color: ''
			// },
			// symbolPadding: 0,
			// symbolHeight: 7,
			// lineHeight: 12
		},
		plotOptions: {
			// cursor: 'pointer',
			series: {
				label: {
					connectorAllowed: false
				},
				// !!!!!!!!!!!!!!!!IMPORTANT
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			borderColor: 'var(--grey)',
			borderWidth: 0,
			// series: {
			// 	label: {
			// 		connectorAllowed: false
			// 	},
			// 	borderColor: 'var(--grey)',
			// 	borderWidth: 0
			// },
			marker: {
                lineWidth: 1
            }
		},
		credits: {
			enabled: false
		},
		responsive: {
			rules: [
				{
					condition: {
						minWidth: 787
					},
					chartOptions: {
						xAxis: {
							labels: {
								style: {
									fontSize: '12px'
								}
							}
						},
						yAxis: [{
							title: {
								style: {
									fontSize: '12px'
								}
							},
							labels: {
								style: {
									fontSize: '12px'
								}
							}
						},
						{
							title: {
								style: {
									fontSize: '12px'
								}
							},
							labels: {
								style: {
									fontSize: '12px'
								}
							}
						}],
					}
				},
				{
					condition: {
						minWidth: 991
					},
					chartOptions: {
						marginRight: 30,
					}
				}
			]
		}
	});

	var hourlyChart = Highcharts.chart('hourlyChart', {
		chart: {
			marginTop: 40,
			marginLeft: 50,
			marginRight: 0,
			height: 301,
			backgroundColor: 'transparent',
			type: 'column'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: {
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 1,
			title: {
				text: null
			},
			categories: num24List,
			crosshair: true
		},
		yAxis: {
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			gridLineWidth: 1,
			min: 0,
			title: {
				text: 'kWh',
				align: 'low',
			rotation: 0,
				y: 25,
				x: 10,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			labels: {
				overflow: 'justify',
				x: -10,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			}
		},
		tooltip: {
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white87)'
			},
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -10,
			itemStyle: {
				color: 'var(--grey)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			line: {
				marker: {
					enabled: false
				}
			},
			column: {
				//stacking: 'normal'
			}
		},
		credits: {
			enabled: false
		},
		series: [{
			type: 'column',
			<c:choose>
				<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			name: '발전 실적',
				</c:when>
				<c:otherwise>
			name: 'PV발전량',
				</c:otherwise>
			</c:choose>
			color: 'var(--turquoise)', /* PV발전량 */
			tooltip: {valueSuffix: 'kWh'},
			data: []
		}, {
			type: 'column',
			<c:choose>
				<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			name: '전일 발전량',
				</c:when>
				<c:otherwise>
			name: '발전 예측',
				</c:otherwise>
			</c:choose>

			color: 'var(--grey)',
			tooltip: {valueSuffix: 'kWh'},
			data: []
		}],
		responsive: {
			rules: [{
				condition: {
					minWidth: 870
				},
				chartOptions: {
					chart: {
						marginLeft: 75
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
						symbolPadding: 5,
						symbolHeight: 10
					}
				}
			}]
		}
	});


	var hourlySolarChart = Highcharts.chart('hourlySolarChart', {
		chart: {
			marginTop: 80,
			marginLeft: 0,
			marginRight: 60,
			height: 320,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			// events: {
			// 	load: function () {
					// set up the updating of the chart each second
					// var series = this.series[0];
					// setInterval(function () {
					// var x = (new Date()).getTime(), // current time
					// 	y = Math.round(Math.random() * 100);
					// series.addPoint([x, y], true, true);
					// }, 1000);
			// 	}
			// }
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: {
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 1,
			title: {
				text: null
			},
			categories: num24List,
			crosshair: true
		},
		yAxis: [
			{
				opposite: true,
				lineColor: 'var(--white60)',
				tickColor: 'var(--white60)',
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--white60)',
					width: 1
				}],
				gridLineWidth: 1,
				min: 0,
				title: {
					text: 'kWh',
					align: 'low',
					rotation: 0,
					y: 30,
					x: -13,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}
			},
			{
				lineColor: 'var(--white60)',
				tickColor: 'var(--white60)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [
					{
						color: 'var(--white60)',
						width: 1
					}
				],
				gridLineWidth: 1,
				title: {
					text: '천원',
					align: 'low',
					rotation: 0,
					y: 25,
					x: -12,
					style: {
						color: 'var(--white)',
						fontSize: '12px'
					}
				},
				labels: {
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				opposite: true
			}
		],
		tooltip: {
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			valueSuffix: 'kWh',
			style: {
				color: 'var(--white87)'
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -10,
			itemStyle: {
				color: 'var(--grey)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			line: {
				marker: {
					enabled: false
				}
			},
			column: {
				// stacking: 'normal'
			}
		},
		credits: {
			enabled: false
		},
		responsive: {
			rules: [{
				condition: {
					minWidth: 870
				},
				chartOptions: {
					chart: {
						marginLeft: 75
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
						symbolPadding: 5,
						symbolHeight: 10
					}
				}
			}]
		},
	});


	var hourlyINVChart = Highcharts.chart('hourlyINVChart', {
		chart: {
			marginTop: 40,
			marginLeft: 0,
			marginRight: 60,
			height: 320,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			lang: {
				noData: "데이터가 없습니다."
			},
			noData: {
				style: {
					fontSize: '12px',
					color: 'var(--white87)'
				}
			}
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: {
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 1,
			title: {
				text: null
			},
			categories: num24List,
			crosshair: true
		},
		yAxis: [
			{
				opposite: true,
				lineColor: 'var(--white60)',
				tickColor: 'var(--white60)',
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--white60)',
					width: 1
				}],
				gridLineWidth: 1,
				min: 0,
				title: {
					text: 'kWh',
					align: 'low',
					rotation: 0,
					y: 30,
					x: -13,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}
			},
			{
				lineColor: 'var(--white60)',
				tickColor: 'var(--white60)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [
					{
						color: 'var(--white60)',
						width: 1
					}
				],
				gridLineWidth: 1,
				title: {
					text: 'kWh',
					align: 'low',
					rotation: 0,
					y: 25,
					x: -12,
					style: {
						color: 'var(--white)',
						fontSize: '12px'
					}
				},
				labels: {
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				opposite: true
			}
		],
		tooltip: {
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			valueSuffix: 'kWh',
			style: {
				color: 'var(--white87)'
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -10,
			itemStyle: {
				color: 'var(--grey)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			line: {
				marker: {
					enabled: false
				}
			},
			column: {
				// stacking: 'normal'
			}
		},
		credits: {
			enabled: false
		},
		responsive: {
			rules: [{
				condition: {
					minWidth: 870
				},
				chartOptions: {
					chart: {
						marginLeft: 75
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
						symbolPadding: 5,
						symbolHeight: 10
					}
				}
			}]
		},

	});


	// noRepeatCycle => 1hr too long
	function getWeatherData(option) {
		const fromDate = new Date();
		const toDate = new Date(fromDate.getFullYear(), fromDate.getMonth(), fromDate.getDate() + 3);

		const timeFromDate = new Date(fromDate.getFullYear(), fromDate.getMonth(), fromDate.getDate() - 2);
		const formData = getSiteMainSchCollection('day');

		let weekWeather = {
			url: apiHost + apiWeather,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: fromDate.format('yyyyMMdd') + '000000',
				endTime: toDate.format('yyyyMMdd') + '235959',
				interval: 'day'
			}
		}
		let weekWeatherTime = new Object();

		if (oid.match('testkpx')) {
			let did = '';

			siteList.forEach(site => {
				const devices = site.devices;
				if (!isEmpty(devices)) {
					devices.forEach(di => {
						const deviceType = di.device_type;
						if (deviceType === 'KPX_EMS') {
							did = di.did;
						}
					});
				}
			});

			let weekWeatherTime = {
				url: apiHost + apiWeather,
				type: 'get',
				dataType: 'json',
				data: {
					sid: siteId,
					startTime: timeFromDate.format('yyyyMMdd') + '000000',
					endTime: fromDate.format('yyyyMMdd') + '235959',
					interval: 'hour'
				}
			}
			let statusRaw = {
				url: apiHost + apiStatusRaw,
				type: 'get',
				dataType: 'json',
				data: {
					dids: did
				}
			}

			$.when($.ajax(weekWeather), $.ajax(weekWeatherTime), $.ajax(statusRaw)).done(function (weekWeatherData, weekWeatherTimeData, statusRawData) {
				
				if (weekWeatherData[1] == 'success') {
					let weekWeather = weekWeatherData[0];

					if($('#viewOptList').prev().data("value") == "2"){
						console.log("weekWeather---", weekWeather);

						weekWeather.forEach((el, index) => {
							$('#sTemp' + (index + 1)).text((el.temperature).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#sWeatherIcon' + (index + 1)).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
						});
					} else {
						weekWeather.forEach((el, index) => {
							console.log("el.temperature==", el.temperature)
							$('#weekTemp' + (index + 1)).text((el.temperature).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#weekIcon' + (index + 1)).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
						});
					}
				}

				if (weekWeatherTimeData[1] == 'success') {
					let items = weekWeatherTimeData[0];
					if (items.length > 0) {
						let tempArray = new Array();
						$.each(items, function (i, el) {
							if (el.observed != undefined && el.observed) {
								tempArray.push(el);
							}
						});

						if (tempArray.length > 0) {
							let weatherIconClass = getWeatherIcons(tempArray[tempArray.length - 1].sky);
							console.log("weatherIconClass==")
							if($('#viewOptList').prev().data("value") == "2"){
								$('#sTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + ' ' + '&#8451;');
								$('#weekSolarIcon').html('<i class="ico_weather ' + weatherIconClass + '"></i>').next('strong').html(siteList[0].location);
							} else {
								$('#weekTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + ' ' + '&#8451;');
								$('#weekIcon').html('<i class="ico_weather ' + weatherIconClass + '"></i>').next('strong').html(siteList[0].location);
							}
						}
					}
				}

				if (statusRawData[1] == 'success') {
					let items = statusRawData[0];
					if (!isEmpty(items)) {
						Object.entries(items).map(obj => {
							let deviceData = obj[1].data;

							deviceData.forEach(di => {
								let humidity = isEmpty(di.humidity) ? '-' : di.humidity;
								let windDirection = isEmpty(di.windDirection) ? '-' : di.windDirection;
								let windSpeed = isEmpty(di.windSpeed) ? '-' : di.windSpeed;
								let wind_velocity = isEmpty(di.wind_velocity) ? '-' : di.wind_velocity;
								let temperature = isEmpty(di.temperature) ? '-' : (di.temperature).toFixed(1);
								if($('#viewOptList').prev().data("value") == "2"){
									$('#sTemp').html(temperature + '&#8451;');
									$('#weekSolarIcon').next('strong').html(siteList[0].location);
									$('#sWindVelocity').text((windSpeed).toFixed(1) + ' km/h');
									$('#sWindDirection').text(windDirection);
									$('#sHumidity').html(humidity + ' ' + '&#37;');

									$('.weather .stit').html(new Date(di.timestamp).format('yyyy-MM-dd HH:mm:ss'));

								} else {
									$('#weekTemp').text(temperature + '&#8451;');
									$('#weekIcon').next('strong').html(siteList[0].location);
									$('#weekWindVelocity').text((windSpeed).toFixed(1) + ' km/h');
									$('#weekWindDirection').text(windDirection);
									$('#weekHum').html(humidity + ' ' + '&#37;');

									$('.weather .stit').html(new Date(di.timestamp).format('yyyy-MM-dd HH:mm:ss'));
								}
							});
						});
					}
				}
			}).fail(function () {
				console.log('rejected');
			});
		} else {
			let weekWeatherTime = {
				url: apiHost + apiWeather,
				type: 'get',
				dataType: 'json',
				data: {
					sid: siteId,
					startTime: timeFromDate.format('yyyyMMdd') + '000000',
					endTime: fromDate.format('yyyyMMdd') + '235959',
					interval: 'hour'
				}
			}

			$.when($.ajax(weekWeather), $.ajax(weekWeatherTime)).done(function (weekWeatherData, weekWeatherTimeData) {
				let weekWeather = weekWeatherData[0];

				if (weekWeatherData[1] == 'success') {

					if($('#viewOptList').prev().data("value") == "2"){
						weekWeather.forEach((el, index) => {
							$('#sTemp' + (index + 1)).text((el.temperature).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#sWeatherIcon' + (index + 1)).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
						});
					} else {

						weekWeather.forEach((el, index) => {
							$('#weekTemp' + (index + 1)).text((el.temperature).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#weekIcon' + (index + 1)).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
						});
					}
				}

				if (weekWeatherTimeData[1] == 'success') {
					let items = weekWeatherTimeData[0];
					
					if (items.length > 0) {
						let tempArray = new Array();
						$.each(items, function (i, el) {
							if (el.observed != undefined && el.observed) {
								tempArray.push(el);
							}
						});

						if (tempArray.length > 0) {
							let weatherIconClass = getWeatherIcons(tempArray[tempArray.length - 1].sky);

							if($('#viewOptList').prev().data("value") == "2") {
								$('#sTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + '&#8451;');
								$('#weekSolarIcon').html('<i class="ico_weather ' + weatherIconClass + '"></i>');
								$('#weekSolarIcon').next('strong').html(siteList[0].location);
								$('#sWindVelocity').text((tempArray[tempArray.length - 1].wind_speed).toFixed(1) + ' km/h');
								$('#sWindDirection').text(tempArray[tempArray.length - 1].wind_velocity);
								$('#sHumidity').html((tempArray[tempArray.length - 1].humidity).toFixed(1) + ' ' + '&#37;');
								$('#currentTimeB').html(String(tempArray[tempArray.length - 1].basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
							} else {
								$('#weekTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + '&#8451;');
								$('#weekIcon').html('<i class="ico_weather ' + weatherIconClass + '"></i>');
								$('#weekIcon').next('strong').html(siteList[0].location);
								$('#weekWindVelocity').text((tempArray[tempArray.length - 1].wind_speed).toFixed(1) + ' km/h');
								$('#weekWindDirection').text(tempArray[tempArray.length - 1].wind_velocity);
								$('#weekHum').html((tempArray[tempArray.length - 1].humidity).toFixed(1) + ' ' + '&#37;');
								$('#currentTimeA').html(String(tempArray[tempArray.length - 1].basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
							}
						}
					}
				}
			}).fail(function () {
				console.log('rejected');
			});

		}
	}

	function getMinuteData(option) {
		if(isEmpty(option)){
			getAlarmInfo();
			getTodayTotal();
			todayGeneration();
			if (!first) {
				getDvcInfo();
				todayGeneration();
			}
		} else {
			getTodayTotal("solarDashboard");
			todayGeneration("solarDashboard");
			getDvcInfo("solarDashboard");
		}
	}

	// TODO!!!! => 15min cycle is too long...
	function getQuarterData(option) {
		if(isEmpty(option)){
			chargeChartPoll(); //월별 발전량 종합
			getWeatherCalendarEnergyData(); //이 달의 발전 달력
		} else {
			chargeChartPoll("solarDashboard"); //월별 발전량 종합
		}
	}

	function rtnDropdown($selectId) {
		if ($selectId == 'chartType') {
			chargeChartPoll();
		} else if ($selectId == 'statusDevice') {
			getDvcInfo();
		}
	}

	function getNowEnergy() {
		let getNowEnergyDay = {
			url: apiHost + apiEnergyNowSite,
				type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'day'
			}
		};

		let getNowEnergyMonth = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'month'
			}
		};

		let getNowEnergyYear = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'year'
			}
		}

		$.when($.ajax(getNowEnergyMonth), $.ajax(getNowEnergyYear)).done(function (getNowEnergyMonthData, getNowEnergyYearData) {
			if (getNowEnergyYearData[1] == 'success') {
				if (!isEmpty(getNowEnergyYearData[0].data[siteId]) && !isEmpty(getNowEnergyYearData[0].data[siteId].energy)) {
					let yearData = getNowEnergyYearData[0].data[siteId].energy;
					yearData = displayNumberFixedDecimal(yearData, 'Wh', 3, 2);
					$('#yearEnergyValue').html('<span class="pv">' + yearData[0] + '</span><em>' + yearData[1] + '</em>');
				} else {
					$('#yearEnergyValue').html('<span class="pv"> - </span><em></em>');
				}
			}

			if(getNowEnergyMonthData[1] == 'success') {
				if (!isEmpty(getNowEnergyMonthData[0].data[siteId]) && !isEmpty(getNowEnergyMonthData[0].data[siteId].energy)) {
					let monthData = getNowEnergyMonthData[0].data[siteId].energy;
					monthData = displayNumberFixedDecimal(monthData, 'Wh', 3, 2);

					$('#monthEnergyValue').html('<span class="pv">' + monthData[0] + '</span><em>' + monthData[1] + '</em>');
				} else {
					$('#monthEnergyValue').html('<span class="pv"> - </span><em></em>');
				}
			}

		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
			$("#errMsg").text("처리 중 오류가 발생했습니다.");
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			// alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	function getDvcProperties() {
		$.ajax({
			url: apiHost + apiGetDvcProperties,
			type: 'get',
			dataType: 'json',
			data: {},
		}).done(function (data, textStatus, jqXHR) {
			$.map(data, function (val, key) {
				let deviceName = key;
				let propList = val.properties;
				let tempFeature = new Array();
				let tempFeature2 = new Array();

				$.map(propList, function (v, k) {
					if (v.dashboard_head) {
						let tempObj = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;

						tempObj['key'] = k;
						tempObj['value'] = propName;
						tempObj['suffix'] = unit;
						tempObj['reducer'] = v.dashboard_head_reducer;
						tempFeature.push(tempObj);

						featureProperties[deviceName] = {
							name: propName,
							prop: tempFeature
						};
					}

					if (v.dashboard_detail) {
						let tempObj2 = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;

						tempObj2['key'] = k;
						tempObj2['value'] = propName;
						tempObj2['suffix'] = unit;
						tempFeature2.push(tempObj2);

						featurePropertiesSub[deviceName] = {
							name: propName,
							prop: tempFeature2
						};
					}
				});
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			let r = JSON.parse(jqXHR.responseText);
			console.log("에러코드:" + jqXHR.status + "\n" + "메세지: " + r);
			$("#errMsg").text("처리 중 오류가 발생했습니다.");
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			// alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function(jqXHR, textStatus) {
			getDvcInfo();
			first = false;
		});
	};

	function deviceSearch(dname, operation) {
		let searchBoolean = true,
			keyoard = $('input[name="keyword"]').val().trim();

		const deviceStatusArray = $.makeArray(
			$(':checkbox[name="deviceStatus"]:checked').map(
				function () {
					return $(this).val();
				}
			)
		);

		if (keyoard != '') {
			if(dname.toUpperCase().match(keyoard.toUpperCase())) {
				if ($.inArray(String(operation), deviceStatusArray) >= 0) {
					searchBoolean = true;
				} else {
					searchBoolean = false;
				}
			} else {
				searchBoolean = false;
			}
		} else {
			if ($.inArray(String(operation), deviceStatusArray) >= 0) {
				searchBoolean = true;
			} else {
				searchBoolean = false;
			}
		}
		return searchBoolean;
	}

	function getDvcInfo(option) {
		let deviceArray = new Array();

		if (!isEmpty(siteList[0].devices)) {
			siteList[0].devices.forEach(el => {
				deviceArray.push(el.did);
			});
		}

		if(deviceArray.length > 0) {
			$.ajax({
				url: apiHost + apiStatusRaw,
				type: 'get',
				dataType: 'json',
				data: {
					dids: deviceArray.toString()
				}
			}).done(function (data, textStatus, jqXHR) {
				let devLength = data.length;
				if (!isEmpty(option)){
					let inverterArray = new Array();
					$.map(data, function(val, key) {
						if ( val.device_type == "INV_PV"){

							const formData = getSiteMainSchCollection('day');

							let hourlyINV = {
								url: apiHost + apiEnergyDvc,
								type: 'get',
								dataType: 'json',
								data: {
									dids: val.did,
									startTime: formData.startTime,
									endTime: formData.endTime,
									interval: 'hour'
								}
							}

							if ( $.inArray(val.device_type, inverterArray) === -1){
								inverterArray.push(val.device_type);
							}

							$.ajax(hourlyINV).done(function (json, textStatus, jqXHR) {
								let result = flattenObject(json.data);
								let temp = Object.entries(result)[0][1];
								
								if(temp.items.length>0){
									let hourList = [];
									let colorArr = [
										"var(--powder-blue)",
										"var(--turquoise)",
										"var(--teal)",
										"var(--light-blue)",
										"var(--blueberry)",
										"var(--royal-blue)",
									];
									if(!isEmpty(hourlyINVChart.series.length>0)){
										hourlyINVChart.series.length = 0;
									}
									
									// let suffixArr = [];
									// let suffix = "";
									for(let i=0, arrLength = temp.items.length; i<arrLength; i++){
										// let l = String(temp.items[i].energy).length;
										console.log("temp===", temp.items[i].energy)
										// if(l<=3){
										// 	hourList.push(temp.items[i].energy);
										// 	suffixArr.push("Wh");
										// } else if(l>3 && l<=6){
											let tempData = parseFloat((temp.items[i].energy / 1000).toFixed(2));
											hourList.push(tempData);
											// console.log("tempData===", tempData)
											// suffixArr.push("kWh");
										// }
									}
									// if(suffixArr.indexOf("kWh") > -1){
									// 	suffix = "wh"
									// } else {
									// 	suffix = "kWh"	
									// }

									hourlyINVChart.addSeries({
										name: val.dname,
										type: 'column',
										color: colorArr[devLength-1],
										tooltip: {
											valueSuffix: "kWh"
										},
										marker: {
											symbol: "circle"
										},
										data: hourList,
										// plotOptions: {
										// 	pointStart: 10,
										// }
									});

								}

							}).fail(function (jqXHR, textStatus, errorThrown) {
								console.log("fail==", jqXHR)
							});
						}
					});

					inverterArray.sort();

					$.each(inverterArray, function (i, el) {
						inverterArray[i] = {
							name: featurePropertiesSub[el].name,
							type: el,
							head: featureProperties[el].prop,
							body: {
								type: el,
								prop: featurePropertiesSub[el].prop
							}
						}
					});

					setMakeList(inverterArray, 'inverterList', {'dataFunction': {'head': makeHeadTable, 'body': makeBodyTable}});

					$.each(inverterArray, function (i, el) {
						let deviceType = el.type;
						let operationNormal = 0;
						let operationError = 0;
						let operationAlert = 0;
						let headerDataObject = new Object();
						let tableArray = new Array();
						let tableName = 'table_' + deviceType;

						setInitList(tableName);

						$.map(data, function(val, key) {
							let dname = val.dname;

							if (val.device_type == deviceType) {
								let rowData = val.data;
								if(!isEmpty(rowData)) {
									let operation = rowData[0]['operation'];
									if(operation == '1') {
										operationNormal++;
									} else if(operation == '2') {
										operationError++;
									} else {
										operationAlert++;
									}

									rowData[0]['dname'] = dname;

									$.map(featureProperties, function(val, key) {
										let headerData = new Object();
										if(!isEmpty(headerDataObject[key])) {
											headerData = headerDataObject[key];
										}
										if (key == deviceType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key],
													tmpObj = new Object();
												if(isEmpty(headerData[el.key])) {
													tmpObj['reducer'] = el.reducer;
												} else {
													tmpObj = headerData[el.key];
												}

												if(isEmpty(value)) {
													value = '-';
												} else {
													if((el.suffix.match('W') || el.suffix.match('Wh')) && !el.suffix.match('W/㎡')) {
														value = Number(value);
													} else if(el.suffix.match('%') || el.suffix.match('℃') || el.suffix.match('W/㎡')) {
														value = Number(value);
													}
												}

												if(value == '-') {
													if(!isEmpty(headerData[el.key])) {
														tmpObj['cnt'] = Number(tmpObj['cnt']) + 1;
													} else {
														tmpObj['value'] = '-';
														tmpObj['cnt'] = 1;
													}
												} else {
													if(!isEmpty(headerData[el.key])) {
														tmpObj['value'] = Number(value) + Number(tmpObj['value']);
														tmpObj['cnt'] = Number(tmpObj['cnt']) + 1;
													} else {
														tmpObj['value'] = Number(value);
														tmpObj['cnt'] = 1;
													}

													tmpObj['suffix'] = el.suffix;
												}

												headerData[el.key] = tmpObj;
											});
											headerDataObject[key] = headerData;
										}
									});

									$.map(featurePropertiesSub, function(val, key) {
										if (key == deviceType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key];
												if(isEmpty(value)) {
													rowData[0][el.key] = '-';
												} else {
													if((el.suffix.match('W') || el.suffix.match('Wh')) && !el.suffix.match('W/㎡')) {
														let dummy = displayNumberFixedUnit(value, 'W', 'kW', 2);
														rowData[0][el.key] = dummy[0];
													} else if(el.suffix.match('V')) {
														console.log("rowData[0][el.key]===", rowData[0]);
														rowData[0][el.key] = value
														// rowData[0][el.key] = value.toFixed(2);
													}
												}
											});
										}
									});

									if (deviceSearch(dname, operation)) {
										if(isEmpty(tableArray)) {
											let rowData = val.data;
											rowData[0]['dname'] = dname;
											tableArray = rowData;
										} else {
											let rowData = val.data;
											rowData[0]['dname'] = dname;
											tableArray = tableArray.concat(rowData);
										}
									}
								}
							}
						});

						let invEl = $('#inverterList .gtbl_wrap table');
						let invItem = $('#inverterList .INV_PV');

						$.map(headerDataObject, function(el, device) {
							let deviceType = device;

							$.map(el, function(element, key) {
								let textValue = element.value,
									suffix = element.suffix;
								if(textValue != '-') {
									if(element.reducer == 'avg') {
										textValue =  textValue / element.cnt;
									}

									textValue = displayNumberFixedDecimal(textValue, suffix, 3, 2);

									invItem.find('.tbl_type td.' + key + ' span:nth-child(1)').html(textValue[0]);
									if(suffix == 'W' || suffix == 'Wh' || suffix == 'V' || suffix == 'A') {
										invItem.find('.tbl_type td.' + key + ' span:nth-child(2)').html(textValue[1]);
									}
								} else {
									invItem.find('.tbl_type td.' + key + ' span:nth-child(1)').html(textValue);
								}

							});
						});
						let deviceCnt = tableArray.length;
						
						invItem.find('.ntit span').html(deviceCnt);
						invItem.find('.alert_icon .inv_normal span').html(operationNormal);
						invItem.find('.alert_icon .inv_error span').html(operationError);
						invItem.find('.alert_icon .inv_alert span').html(operationAlert);

						setMakeList(tableArray, 'table_' + deviceType, {'dataFunction': {'operation': setOperation}}, invEl);

					});

				} else {
					let deviceType = new Array();
					$.map(data, function(val, key) {
						if ($.inArray(val.device_type, deviceType) === -1) {
							if (val.device_type == 'SM_MANUAL') return false;
							deviceType.push(val.device_type);
						}
					});

					deviceType.sort();

					$.each(deviceType, function (i, el) {
						if (el == 'SM_MANUAL') return false;
						deviceType[i] = {
							name: featurePropertiesSub[el].name,
							type: el,
							head: featureProperties[el].prop,
							body: {
								type: el,
								prop: featurePropertiesSub[el].prop
							}
						}
					});

					setMakeList(deviceType, 'typeList', {'dataFunction': {'head': makeHeadTable, 'body': makeBodyTable}});
					
					$.each(deviceType, function (i, el) {
						let deviceType = el.type,
							operationNormal = 0,
							operationError = 0,
							operationAlert = 0,
							headerDataObject = new Object();
							
						if (el.type == 'SM_MANUAL') return false;
						setInitList('table_' + deviceType);
	
						let tableArray = new Array();

						$.map(data, function(val, key) {
							let dname = val.dname;
							if (val.device_type == deviceType) {
								let rowData = val.data;
								if(!isEmpty(rowData)) {
									let operation = rowData[0]['operation'];
									if(operation == '1') {
										operationNormal++;
									} else if(operation == '2') {
										operationError++;
									} else {
										operationAlert++;
									}

									rowData[0]['dname'] = dname;

									$.map(featureProperties, function(val, key) {
										let headerData = new Object();
										if(!isEmpty(headerDataObject[key])) {
											headerData = headerDataObject[key];
										}
										if (key == deviceType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key],
													tmpObj = new Object();
												if(isEmpty(headerData[el.key])) {
													tmpObj['reducer'] = el.reducer;
												} else {
													tmpObj = headerData[el.key];
												}

												if(isEmpty(value)) {
													value = '-';
												} else {
													if((el.suffix.match('W') || el.suffix.match('Wh')) && !el.suffix.match('W/㎡')) {
														value = Number(value);
													} else if(el.suffix.match('%') || el.suffix.match('℃') || el.suffix.match('W/㎡')) {
														value = Number(value);
													}
												}

												if(value == '-') {
													if(!isEmpty(headerData[el.key])) {
														tmpObj['cnt'] = Number(tmpObj['cnt']) + 1;
													} else {
														tmpObj['value'] = '-';
														tmpObj['cnt'] = 1;
													}
												} else {
													if(!isEmpty(headerData[el.key])) {
														tmpObj['value'] = Number(value) + Number(tmpObj['value']);
														tmpObj['cnt'] = Number(tmpObj['cnt']) + 1;
													} else {
														tmpObj['value'] = Number(value);
														tmpObj['cnt'] = 1;
													}

													tmpObj['suffix'] = el.suffix;
												}

												headerData[el.key] = tmpObj;
											});
											headerDataObject[key] = headerData;
										}
									});

									$.map(featurePropertiesSub, function(val, key) {
										if (key == deviceType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key];

												if(isEmpty(value)) {
													rowData[0][el.key] = '-';
												} else {
													if((el.suffix.match('W') || el.suffix.match('Wh')) && !el.suffix.match('W/㎡')) {
														let dummy = displayNumberFixedUnit(value, 'W', 'kW', 2);
														rowData[0][el.key] = dummy[0];
													} else if(el.suffix.match('%') || el.suffix.match('℃') || el.suffix.match('W/㎡')) {
														rowData[0][el.key] = value.toFixed(2);
													} else if(el.suffix.match('V')) {
														rowData[0][el.key] = value.toFixed(2);
													}
												}
											});
										}
									});

									if (deviceSearch(dname, operation)) {
										if(isEmpty(tableArray)) {
											let rowData = val.data;
											rowData[0]['dname'] = dname;
											tableArray = rowData;
										} else {
											let rowData = val.data;
											rowData[0]['dname'] = dname;
											tableArray = tableArray.concat(rowData);
										}
									}
								}
							}
						});

						$.map(headerDataObject, function(el, device) {
							let deviceType = device;

							$.map(el, function(element, key) {
								let textValue = element.value,
									suffix = element.suffix;
								if(textValue != '-') {
									if(element.reducer == 'avg') {
										textValue =  textValue / element.cnt;
									}

									textValue = displayNumberFixedDecimal(textValue, suffix, 3, 2);

									$('#typeList').find('.' + deviceType).find('.tbl_type td.' + key + ' span:nth-child(1)').html(textValue[0]);
									if(suffix == 'W' || suffix == 'Wh' || suffix == 'V' || suffix == 'A') {
										$('#typeList').find('.' + deviceType).find('.tbl_type td.' + key + ' span:nth-child(2)').html(textValue[1]);
									}
								} else {
									$('#typeList').find('.' + deviceType).find('.tbl_type td.' + key + ' span:nth-child(1)').html(textValue);
								}

							});
						});
						let deviceCnt = tableArray.length;

						$('#typeList').find('.' + deviceType).find('.ntit span').html(deviceCnt);
						$('#typeList').find('.' + deviceType).find('.alert_icon .inv_normal span').html(operationNormal);
						$('#typeList').find('.' + deviceType).find('.alert_icon .inv_error span').html(operationError);
						$('#typeList').find('.' + deviceType).find('.alert_icon .inv_alert span').html(operationAlert);
						setMakeList(tableArray, 'table_' + deviceType, {'dataFunction': {'operation': setOperation}});
					});

				}

			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}
	}

	function setOperation(operation) {
		let rtnText = '';
		if (operation == '1') {
			rtnText = '정상';
		} else if (operation == '2') {
			rtnText = '트립';
		} else {
			rtnText = '중지';
		}
		return rtnText;
	}

	function makeHeadTable(obj) {
		let targetTable = document.createElement('table');
		let colgroup = document.createElement('colgroup');
		let colLength = obj.length;
		let colSize = (100 / colLength).toFixed(1);

		for(let i = 0; i < colLength; i++) {
			let col = document.createElement('col');
			col.setAttribute('style', 'width:' + colSize.toString() + '%');
			colgroup.appendChild(col);

		}
		targetTable.appendChild(colgroup);

		let thead = targetTable.createTHead();
		let tbody = targetTable.createTBody();
		let hRow = thead.insertRow();
		let bRow = tbody.insertRow();

		obj.forEach(el => {
			let headerCell = document.createElement('TH');
			headerCell.innerHTML = el.value;
			hRow.appendChild(headerCell);

			let bodyCell = bRow.insertCell();
			bodyCell.setAttribute('class', el.key);
			bodyCell.innerHTML = '<span>' + el.suffix + '</span>'
		});

		return targetTable.outerHTML;
	}

	function makeBodyTable (obj) {
		let targetTable = document.createElement('table');
		let colgroup = document.createElement('colgroup');
		let colLength = obj.prop.length;
		let colSize = (100 / colLength).toFixed(1);

		for(let i = 0; i < colLength; i++) {
			let col = document.createElement('col');
			col.setAttribute('style', 'width:' + colSize.toString() + '%');
			colgroup.appendChild(col);

		}
		targetTable.appendChild(colgroup);

		let thead = targetTable.createTHead();
		let tbody = targetTable.createTBody();
		tbody.setAttribute('id', 'table_' + obj.type);
		let hRow = thead.insertRow();
		let bRow = tbody.insertRow();
		bRow.setAttribute('data-value', '[operation]')
		let hCell;

		obj.prop.forEach(el => {
			makeTableCell(hRow, hCell, bRow, el.value, el.key);
		});

		return targetTable.outerHTML;
	}

	function chargeChartPoll(option) {
		const formData = getSiteMainSchCollection('year');
		const monthFormData = getSiteMainSchCollection('month');
		const beforeYearFormData = getSiteMainSchCollection('beforeYear');

		const monthEnergy = {
			url: apiHost + apiEnergySite,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'month',
				// displayType: 'dashboard',
				formId: 'v2'
			}
		}
		const nowMonth = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			dataType: 'json',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'month'
			}
		}

		const beforeYear = {
			url: apiHost + apiEnergySite,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: beforeYearFormData.startTime,
				endTime: beforeYearFormData.endTime,
				interval: 'month',
				displayType: 'dashboard',
				formId: 'v2'
			}
		}

		const weather = {
			url: apiHost + apiWeather,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		}

		if(isEmpty(option)){
			if (oid.match('testkpx')) {
				$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear)).done(function (monthlyData, currentMonthData, prevYearData) {
					let chartItems1;
					let chartItems2;

					if (monthlyData[1] == 'success') {
						let resultData = monthlyData[0].data[0];
						if (resultData.generation.items.length > 0) {
							chartItems1 = resultData.generation.items;
							chartItems1.forEach(el => {
								if (!isEmpty(el.money)) {
									el.money = Math.floor(el.money / 1000);
								}
							});
						}
					}

					if (currentMonthData[1] == 'success') {
						let resultNow = currentMonthData[0].data[siteId];
						chartItems1.push({
							basetime: monthFormData.startTime,
							energy: resultNow.energy,
							money: Math.floor(resultNow.money / 1000)
						});
					}
					
					if (prevYearData[1] == 'success') {
						let resultData = prevYearData[0].data[0];
						chartItems2 = resultData.generation.items
					}
					setChargeChartData(chartItems1, chartItems2);

				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.log('error');
				});
			} else {
				// A. radio option
				if ($(':radio[name="radio_t"]:checked').val() == 1) {
					$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear), $.ajax(weather)).done(function (monthlyData, currentMonthData, prevYearData, weatherData) {
						let chartItems1 = new Array();
						let chartItems2 = new Array();
						let chartItems3 = new Array();
						let capacity = 0;

						if (monthlyData[1] == 'success') {
							let resultData = flattenObject(monthlyData[0].data)

							if (!isEmpty(resultData) && resultData[0].items.length > 0) {
								chartItems1 = resultData[0].items;

								chartItems1.forEach(el => {
									if (!isEmpty(el.money)) {
										el.money = Math.floor(el.money / 1000);
									}
								});
							}
						}

						if (currentMonthData[1] == 'success') {
							let resultNow = currentMonthData[0].data[siteId];
							chartItems1.push({
								basetime: monthFormData.startTime,
								energy: resultNow.energy,
								money: Math.floor(resultNow.money / 1000)
							});
						}

						if (prevYearData[1] == 'success') {
							chartItems2 = prevYearData[0];
						}

						if (weatherData[1] == 'success') {
							if(!isEmpty(weatherData[0])) {
								let standard = String(weatherData[0][0].basetime).substring(0, 6);
								let sumVal = 0;

								$.each(weatherData[0], function (i, el) {
									if (standard == String(el.basetime).substring(0, 6)) {
										sumVal += el.sensor_solar.irradiationPoa;
										if (i == (weatherData[0].length - 1)) {
											chartItems3.push({
												baseTime: standard,
												sumVal: sumVal
											});
										}
									} else {
										chartItems3.push({
											baseTime: standard,
											sumVal: sumVal
										});
										standard = String(el.basetime).substring(0, 6);
										sumVal = el.sensor_solar.irradiationPoa;
									}
								});
							}
						}

						setChargeChartData(chartItems1, chartItems2, chartItems3);
					}).fail(function () {
						console.log('rejected');
					});
				} else {
				// B.C. radio option
					$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear)).done(function (monthlyData, currentMonthData, prevYearData) {
						let chartItems1;
						let chartItems2;

						if (monthlyData[1] == 'success') {
							let resultData = flattenObject(monthlyData[0].data)

							if (!isEmpty(resultData) && resultData[0].items.length > 0) {
								chartItems1 = resultData[0].items;

								chartItems1.forEach(el => {
									if (!isEmpty(el.money)) {
										el.money = Math.floor(el.money / 1000);
									}
								});
							}
						}

						if (currentMonthData[1] == 'success') {
							let resultNow = currentMonthData[0].data[siteId];
							chartItems1.push({
								basetime: monthFormData.startTime,
								energy: resultNow.energy,
								money: Math.floor(resultNow.money / 1000)
							});
						}

						if (prevYearData[1] == 'success') {
							chartItems2 = prevYearData[0];
						}

						setChargeChartData(chartItems1, chartItems2);
					}).fail(function () {
						console.log('rejected');
					});
				
				}
			}
		} else {
			let d = new Date();
			let tenDaysAgo = new Date(d.getTime() - (10 * 24 * 60 * 60 * 1000));
			let monthAgo = new Date(d.getTime() - (30 * 24 * 60 * 60 * 1000));
			tenDaysAgo.setHours(0, 0, 0, 0);
			monthAgo.setHours(0, 0, 0, 0);

			const dailyEnergy = {
				url: apiHost + apiEnergySite,
				type: 'get',
				dataType: 'json',
				data: {
					sid: siteId,
					startTime: monthAgo.format("yyyyMMddHHmmss"),
					endTime: new Date().format("yyyyMMddHHmmss"),
					interval: 'day',
					// displayType: 'dashboard',
					formId: 'v2'
				}
			}

			const dailyWeather = {
				url: apiHost + apiWeather,
				type: 'get',
				dataType: 'json',
				data: {
					sid: siteId,
					startTime: monthAgo.format("yyyyMMddHHmmss"),
					endTime: new Date().format("yyyyMMddHHmmss"),
					interval: 'day',
				}
			}

			// console.log("dailyEnergy===", dailyEnergy.data)

			$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(dailyWeather), $.ajax(dailyEnergy)).done(function (result1A, result1B, result2, result3) {
				let el = $("#solarDashboard .mini .data-num");
				let chartItems1;
				let chartItems2;
				let chartItems3;

				if (result1A[1] == 'success') {
					let v = Object.values(result1A[0].data);
					if (!isEmpty(v) &&  v.flat()[0]["items"].length > 0) {
						let chartData1 = v.flat()[0]["items"];
						let initData = 0;

						chartItems1 = chartData1;
						chartData1.forEach(function(item, index){
							initData += item.energy;
							chartItems1[index].money = Math.floor(item.money / 1000);
						});

						monthGen = displayNumberFixedUnit(initData, 'Wh', 'kWh', 0);

						el.eq(4).text(monthGen[0]);
						el.eq(4).next().text("kWh");
					} else {
						el.eq(4).text("-");
						chartItems1 = null;
					}
				} else {
					el.eq(4).text("-");
				}

				if (result1B[1] == 'success') {
					let resultNow = result1B[0].data[siteId];
					if(!isEmpty(chartItems1)){
						chartItems1.push({
							basetime: monthFormData.startTime,
							energy: resultNow.energy,
							money: Math.floor(resultNow.money / 1000)
						});
					}
				}

				// if ( (result2[1] == 'success') && (result3[1] == 'success') ) {
				// 	let tempIrrList = [];
				// 	let data = result2[0];
				// 	let v = Object.values(result3[0].data);

				// 	$.each(data, function(index, el){
				// 		if(!isEmpty(el.sensor_solar.irradiationPoa)){
				// 			tempIrrList.push(el);
				// 		}
				// 	});
				// 	chartItems2 = addToDateList(d, 30, tempIrrList, "irradiationPoa");

				// 	if (!isEmpty(v) &&  v.flat()[0]["items"].length > 0) {
				// 		let val = v.flat()[0]["items"];
				// 		chartItems3 = addToDateList(d, 30, val, "energy");
				// 		// chartItems3 = addToDateList(d, 11, val);
				// 	}
					
				// } else {
					if (result2[1] == 'success') {
						let tempIrrList = [];
						let data = result2[0];
						let v = Object.values(result3[0].data);

						$.each(data, function(index, el){
							if(!isEmpty(el.sensor_solar.irradiationPoa)){
								tempIrrList.push(el);
							}
						});
						chartItems2 = addToDateList(d, 30, tempIrrList, "irradiationPoa");
					}

					if (result3[1] == 'success') {
						let v = Object.values(result3[0].data);
						
						if (!isEmpty(v) &&  v.flat()[0]["items"].length > 0) {
							let val = v.flat()[0]["items"];
							chartItems3 = addToDateList(d, 30, val, "energy");
							// chartItems3 = addToDateList(d, 11, val);
						}
					}

				// }

				setChargeChartData(chartItems1, chartItems2, chartItems3, "solarDashboard");
			}).fail(function () {
				console.log('rejected');
			});
		}
	}

	function setChargeChartData(chartItems1, chartItems2, chartItems3, option) {
		const today = new Date();
		const nowMonth = today.getMonth() + 1;
		// console.log("chartItems1---", chartItems1, "chartItems2---", chartItems2,  "chartItems3---", chartItems3)

		let itemChartCapacity = 0;
		let totalYearEnergy = 0;
		let totalMonthEnergy = 0;
		let totalPrevYearEnergy = 0;
		let totalPrevMonthEnergy = 0;
		let energyData = [];
		let irradiationData = [];
		let billingData = [];


		if (isEmpty(option)) {		
			siteList.forEach(site => {
				if (site.devices != undefined) {
					site.devices.forEach(device => {
						itemChartCapacity += device.capacity;
					});
				}
			});
			itemChartCapacity = Number((itemChartCapacity / 1000).toFixed(1));
			
			for (let i = 0; i < 12; i++) {	
				let matchMonth = false;
				if (!isEmpty(chartItems1)) {
					for (let d = 0, arrLength = chartItems1.length; d < arrLength; d++) {
						let dataMonth = parseInt(String(chartItems1[d].basetime).substring(4, 6));
						if (i + 1 == dataMonth) {
							energyData[i] = [i, chartItems1[d].energy / 1000];

							if (!oid.match('testkpx')) {
								if ($(':radio[name="radio_t"]:checked').val() == 1) {
									let energy = chartItems1[d].energy / 1000;
									let iRRSum = 0;
									$.each(chartItems3, function (k, el) {
										if (el.baseTime.slice(-2) == dataMonth) {
											iRRSum = el.sumVal;
										}
									});

									let resultValue = 0;
									if (iRRSum > 0) {
										resultValue = parseFloat(((energy / itemChartCapacity / (iRRSum / 1000 * 24)) * 100).toFixed(2));
									}
									billingData[i] = [i, resultValue];
								} else if ($(':radio[name="radio_t"]:checked').val() == 2) { //발전량
									let today = new Date();
									let lastDate = new Date(today.getFullYear(), dataMonth, 0).format('dd');

									if (today.getMonth() == (Number(dataMonth) - 1)) {
										lastDate = today.getDate();
									}
									let energy = chartItems1[d].energy / 1000;

									billingData[i] = [i, parseFloat(((energy / itemChartCapacity) / lastDate).toFixed(2))];
								} else {
									billingData[i] = [i, chartItems1[d].money];
								}
							}

							totalYearEnergy += chartItems1[d].energy / 1000;
							if (i + 1 == nowMonth) {
								totalMonthEnergy = chartItems1[d].energy / 1000;
							}
							matchMonth = true;
						}
					}
				}
								
				if (!matchMonth) {
					energyData[i] = [i, null];
					billingData[i] = [i, null];
				}
				
				if(!isEmpty(chartItems2)) {
					for (var d = 0; d < chartItems2.length; d++) {
						var dataMonth = parseInt(("" + chartItems2[d].basetime).substring(4, 6));
						if (i + 1 == dataMonth) {
							totalPrevYearEnergy += chartItems2[d].energy / 1000;
							if (i + 1 == nowMonth) {
								totalPrevMonthEnergy = chartItems2[d].energy / 1000;
							}
						}
					}
				}
			}

			dailyChart.series[0].setData(energyData);
			if (!oid.match('testkpx')) {
				dailyChart.series[1].setData(billingData);
				let seriesName = '';
				let suffix = '';
				if ($(':radio[name="radio_t"]:checked').val() == 1) {
					seriesName = 'PR';
					suffix = '%';
				} else if ($(':radio[name="radio_t"]:checked').val() == 2) {
					seriesName = '발전시간';
					suffix = '시간';
				} else {
					seriesName = '매전량';
					suffix = '천원';
				}
				// dailyChart.series[1].setOptions({
				// 	name: seriesName,
				// 	tooltip: {
				// 		valueSuffix: suffix
				// 	},
				// 	legend: {
				// 		title: {
				// 			text: seriesName,
				// 		},
				// 	}
				// })
				dailyChart.series[1].name = seriesName;
				dailyChart.series[1].tooltipOptions.valueSuffix = suffix;
				dailyChart.series[1].legendItem.element.firstElementChild.innerHTML = seriesName;
				dailyChart.yAxis[1].setTitle({
					text: suffix,
					align: 'low',
					rotation: 0,
					y: 25,
					x: -12,
					style: {
						color: 'var(--white)',
						fontSize: '12px'
					}
				});
			}
		} else {
			let seriesName = [
				{
					label : '${siteName}' + ' 대시보드'
				},
				{
					label : '일사량'
				}
			];
			if(!isEmpty(dailySolarChart.series.length>0)){
				dailySolarChart.series.length = 0;
				dailySolarTrendChart.series.length = 0;
			}

			dailySolarTrendChart.addSeries({
				name: seriesName[0].label,
				// type: 'line',
				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'kWh'
				},
				marker: {
					symbol: "circle"
				},
				data: chartItems3,
			});

			dailySolarTrendChart.addSeries({
				name: seriesName[1].label,
				type: 'line',
				dashStyle: 'ShortDash',
				color: 'var(--white60)',
				tooltip: {
					valueSuffix: 'kWh'
				},
				marker: {
					symbol: "circle"
				},
				data: chartItems2,
				// plotOptions: {
				// 	pointStart: 10,
				// }
			});

			dailySolarChart.addSeries({
				name: seriesName[0].label,
				type: 'column',
				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'kWh'
				},
				data: chartItems3.slice(20, 31),
			});

			dailySolarChart.addSeries({
				name: seriesName[1].label,
				type: 'line',
				dashStyle: 'ShortDash',
				color: 'var(--white60)',
				tooltip: {
					valueSuffix: 'kWh'
				},
				data: chartItems2.slice(20, 31),
			});

		}
	}

	function getWeatherCalendarEnergyData() {
		const formData = getSiteMainSchCollection('month');

		const dailyEnergy = {
			url: apiHost + apiEnergySite,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		};

		const dailyWeather = {
			url: apiHost + apiWeather,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		};

		$.when($.ajax(dailyEnergy), $.ajax(dailyWeather)).done(function (dailyEnergyData, dailyWeatherData) {
			let energyItems = dailyEnergyData[0].data[0].generation.items;
			let weatherItems = dailyWeatherData[0];
			let calendarDays = $('.calWeatherDay');

			// console.log("dailyEnergyData===", dailyEnergyData[0].data[0])

			for (let i = 1; i <= calendarDays.length; i++) {
				if (energyItems.length > 0) {
					energyItems.forEach(el => {
						let dataDay = parseInt(String(el.basetime).substring(6, 8));
						if (i == dataDay) {
							let energyText = displayNumberFixedDecimal(el.energy, 'Wh', 3, 1);
							$('#calEnergyValue_' + i).html('<strong>' + energyText[0] + '</strong><em>' + energyText[1] + '</em>');
						}
					});
				}

				if (weatherItems.length > 0) {
					weatherItems.forEach((el, index) => {
						let dataDay = parseInt(String(el.basetime).substring(6, 8));
						if (i == dataDay) {
							$('#calWeatherValue_' + i).text((el.temperature).toFixed(1) + '℃');

							let weatherIconClass = getWeatherIcons(el.sky);
							$('#calWeatherIcon_' + i).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
						}
					});
				}
			}
		}).fail(function () {
			console.log('rejected');
		}).always(function () {
			getWeatherCalendar();
		});
	}

	function getWeatherCalendar() {
		$.ajax({
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			dataType: 'json',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'day'
			}
		}).done(function (data, textStatus, jqXHR) {
			const calDate = new Date();
			if (!isEmpty(data.data[siteId])) {
				const energyText = displayNumberFixedDecimal(data.data[siteId].energy, 'Wh', 3, 1);
				$('#calEnergyValue_' + (calDate.getDate())).html('<strong>' + energyText[0] + '</strong><em>' + energyText[1] + '</em>');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	function getWeatherIcons(weatherId) {
		/*
			weather value 1 	> css w1
			weather value 20	> css w3
			weather value 7		> css w4
			weather value 13	> css w6
			weather value 11	> css w8
			weather value 17	> css w9
			weather value 12	> css w10
		*/
		let weatherIconClass = 'w1';
		switch (weatherId) {
			case 1 :
				weatherIconClass = 'w1';
				break;
			case 7 :
				weatherIconClass = 'w4';
				break;
			case 11 :
				weatherIconClass = 'w8';
				break;
			case 12 :
				weatherIconClass = 'w10';
				break;
			case 13 :
				weatherIconClass = 'w6';
				break;
			case 17 :
				weatherIconClass = 'w9';
				break;
			case 20 :
				weatherIconClass = 'w3';
				break;
			default :
				weatherIconClass = 'w1';
				break;
		}
		return weatherIconClass
	}

	function getTodayTotal(option) {
		const formData = getSiteMainSchCollection('day');
		const formYesterData = getSiteMainSchCollection('yesterday');
		let capacity = 0;
		let urls = new Array();
		let deferredList = new Array();

		if(oid.match('testkpx')) {
			$('#centerTbody tr td:nth-child(1)').html('<em>&nbsp;&nbsp;kW</em>');
			$('#centerTbody tr td:nth-child(2)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(3)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(4)').html('<em>&nbsp;&nbsp;H</em>');
		} else {
			$('#centerTbody tr td:nth-child(1)').html('<em>&nbsp;&nbsp;kW</em>');
			$('#centerTbody tr td:nth-child(2)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(3)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(4)').html('<em>&nbsp;&nbsp;천원</em>');
		}

		if(isEmpty(option)){
			if (oid.match('testkpx')) {
				let rtus = new Array();
				siteList.forEach(site => {
					if (!isEmpty(site.rtus)) {
						site.rtus.forEach(rtu => {
							rtus.push(rtu.rid);
						})
					}
				});

				urls.push({
					url: apiHost + apiEnergySite,
					type: 'GET',
					data: {
						sid: siteId,
						startTime: formData.startTime,
						endTime: formData.endTime,
						interval: 'hour',
						formId: 'v2'
					}
				});

				urls.push({
					url: apiHost + apiEnergySite,
					type: 'GET',
					data: {
						sid: siteId,
						startTime: formYesterData.startTime,
						endTime: formYesterData.endTime,
						interval: 'day',
					}
				});

				if (!isEmpty(rtus)) {
					urls.push({
						url: apiHost + '/control/command_history',
						type: 'GET',
						data: {
							oid: oid,
							rids: rtus.join(','),
							cmdTypes: 'kpx_targetPower',
							isRecent: true
						},
					});
				}
			} else {
				urls.push({
					url: apiHost + apiEnergyNowSite,
					type: 'GET',
					data: {
						sids: siteId,
						metering_type: 2,
						interval: 'day'
					}
				});

				urls.push({
					url: apiHost + apiForecastingSite,
					type: 'GET',
					data: {
						sid: siteId,
						startTime: formData.startTime,
						endTime: formData.endTime,
						interval: 'hour',
						// displayType: 'dashboard',
						formId: 'v2'
					}
				});
			}

			urls.push({
				url: apiHost + apiStatusRawSite,
				type: 'GET',
				data: {
					sid: siteId,
					formId: 'v2'
				}
			});

			//ajax 한번에 실행
			deferredList = new Array();
			urls.forEach(function (url) {
				let deferred = $.Deferred();
				deferredList.push(deferred);

				$.ajax(url).done(function (data) {
					data['url'] = url['url'];
					(function (deferred) {
						return deferred.resolve(data);
					})(deferred);
				}).fail(function (error) {
					console.log(error);
				});
			});

			$.when.apply($, deferredList).then(function () {
				let itemCapacity = null;
				let itemDcPower = null;
				let itemAcPower = null;
				let itemEfficiency = null;
				let targetActivePower = null;
				let itemEnergyDay = 0;
				let lastTargetActivePowerReqDate = '';
				let lastTargetActivePowerRecvDate = '';

				Object.entries(arguments).forEach(arg => {
					const data = arg[1];
					const url = data.url;

					if ((url).match(apiEnergySite)) {
						let getNowEnergyDay = 0;
						let nowBillingDay = 0;

						if (!isEmpty(data.data)) {
							const rstData = data.data;

							rstData.forEach(rst => {
								const generation = rst.generation.items;
								if (!isEmpty(generation)) {
									generation.forEach(gen => {
										getNowEnergyDay += gen.energy;
										nowBillingDay += gen.money;
									});
								}
							});
						} else {
							getNowEnergyDay = 0;
							nowBillingDay = 0;
						}
						if ((data.start) == formYesterData.startTime) {
							$('#centerTbody tr td:nth-child(3) em').before(displayNumberFixedUnit(getNowEnergyDay, 'Wh', 'kWh', 2)[0]);
							itemEnergyDay = getNowEnergyDay;
						} else {
							$('#centerTbody tr td:nth-child(2) em').before(displayNumberFixedUnit(getNowEnergyDay, 'Wh', 'kWh', 2)[0]);

							if (!oid.match('testkpx')) {
								$('#centerTbody tr td:nth-child(4) em').before(displayNumberFixedUnit(nowBillingDay, 'Wh', 'kWh', 2)[0]);
							}
						}

					} else if ((url).match(apiEnergyNowSite)) {
						let rstData = data.data[siteId];
						let getNowEnergyDay = rstData.energy;
						let nowBillingDay = rstData.money;

						$('#centerTbody tr td:nth-child(2) em').before(displayNumberFixedUnit(getNowEnergyDay, 'Wh', 'kWh', 2)[0]);
						$('#centerTbody tr td:nth-child(4) em').before(displayNumberFixedUnit(nowBillingDay, 'Wh', 'kWh', 2)[0]);
					} else if ((url).match(apiForecastingSite)) {
						let todayForeEnergy = 0;
						
						if (!isEmpty(data.data)) {
							const rstData = Object.values(data.data).flat()[0]["items"];
							rstData.forEach(rst => {
								const generation = rst.energy;
								if (!isEmpty(rst.energy)) {
									todayForeEnergy += rst.energy;
								}
							});
						}

						$('#centerTbody tr td:nth-child(3) em').before(displayNumberFixedUnit(todayForeEnergy, 'Wh', 'kWh', 2)[0]);
					} else if ((url).match('/control/command_history')) {
						if (!isEmpty(data.data)) {
							if (!isEmpty(lastTargetActivePowerReqDate)) {
								let statusDate = new Date(lastTargetActivePowerReqDate.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
								let hitoryDate = new Date(data.data[0].requested_at.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
								if (statusDate.getTime() < hitoryDate.getTime()) {
									lastTargetActivePowerReqDate = hitoryDate.format('yyyyMMddHHmmss');
									lastTargetActivePowerRecvDate = '-';

									const cmdBody = JSON.parse(data.data[0].cmd_body);
									targetActivePower = cmdBody.targetPower;
								}
							} else {
								lastTargetActivePowerReqDate = data.data[0].requested_at;
								lastTargetActivePowerRecvDate = '-'

								const cmdBody = JSON.parse(data.data[0].cmd_body);
								targetActivePower = cmdBody.targetPower;
							}
						}
					} else {
						if (!isEmpty(data)) {
							Object.entries(data).forEach(rawData => {
								const deviceType = rawData[0];
								const deviceData = rawData[1];

								if (!isEmpty(deviceData.timestamp) && ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < deviceData.timestamp))) {
									const dbTime = new Date(deviceData.timestamp);
									$('.dbTime').data('timestamp', deviceData.timestamp).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
								}

								if (oid.match('testkpx')) {
									if (deviceType.toLowerCase() === 'kpx_ems') {
										itemCapacity = deviceData.capacity;
										itemAcPower = deviceData.activePower;

										if (!isEmpty(lastTargetActivePowerReqDate)) {
											let hitoryDate = new Date(lastTargetActivePowerReqDate.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
											let statusDate = new Date(String(deviceData.lastTargetActivePowerReqDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
											if (statusDate.getTime() > hitoryDate.getTime()) {
												lastTargetActivePowerReqDate = String(deviceData.lastTargetActivePowerReqDate);
												lastTargetActivePowerRecvDate = String(deviceData.lastTargetActivePowerReqDate);
												targetActivePower = deviceData.targetActivePower;
											}
										} else {
											lastTargetActivePowerReqDate = String(deviceData.lastTargetActivePowerReqDate);
											lastTargetActivePowerRecvDate = String(deviceData.lastTargetActivePowerReqDate);
											targetActivePower = deviceData.targetActivePower;
										}
									}
								} else {
									if (!isEmpty(deviceData)) {
										Object.entries(deviceData).map(di => {
											const key = di[0];
											const value = di[1];

											if(key == 'capacity') {
												itemCapacity += value;
											} else if(key == 'dcPower') {
												itemDcPower += value;
											} else if(key == 'activePower') {
												itemAcPower += value;
											} else if(key == 'efficiency') {
												itemEfficiency += value;
											}
										});
									}
								}
							});
						}
					}
				});

				if (oid.match('testkpx')) {
					let genHour = isNaN(itemEnergyDay / itemCapacity) ? '-' : itemEnergyDay / itemCapacity;
					if (genHour === '-') {
						$('#centerTbody tr td:nth-child(4) em').before(genHour);
					} else {
						$('#centerTbody tr td:nth-child(4) em').before(genHour.toFixed(1));
					}

					$('#siteCapacity').text(displayNumberFixedUnit(targetActivePower, 'W', 'kW', 2)[0]);
					$('#siteAcPower').text(String(lastTargetActivePowerReqDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
					if (lastTargetActivePowerRecvDate != '-') {
						$('#siteDcPower').text(String(lastTargetActivePowerRecvDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
					}

					let usage = Math.floor((itemAcPower / targetActivePower) * 100);
					let other = 100 - usage;
					pieChart.series[0].data.forEach((e, idx) => {
						if (e.name === "태양광") {
							e.update({y: usage});
						} else if (e.name === "미사용량") {
							e.update({y: other});
						} else {
							e.update({y: 0});
						}
					});
					pieChart.redraw();
				} else {
					$('#siteCapacity').text(displayNumberFixedUnit(itemCapacity, 'W', 'kW', 1)[0]);
					$('#siteDcPower').text(displayNumberFixedUnit(itemDcPower, 'W', 'kW', 1)[0]);
					$('#siteAcPower').text(displayNumberFixedUnit(itemAcPower, 'W', 'kW', 1)[0]);

					let pie1Data = Math.round(itemEfficiency);
					let pie2Data = 100 - pie1Data;

					pieChart.series[0].setData([pie1Data, pie2Data]);
				}

				$('#centerTbody tr td:nth-child(1) em').before(displayNumberFixedUnit(itemCapacity, 'W', 'kW', 1)[0]);
				pieChart.setTitle({text: displayNumberFixedUnit(itemAcPower, 'W', 'kW', 1)[0] + 'kW'});
			});
		} else {
			let optionList = [
				{
					url: apiHost + apiStatusRawSite,
					type: 'GET',
					async: true,
					data: {
						sid: siteId,
						formId: 'v2'
					}
				},
				{
					url: apiHost + apiEnergyNowSite,
					type: 'GET',
					async: true,
					data: {
						sids: siteId,
						metering_type: 2,
						interval: 'day'
					}
				},
				{
					url: apiHost + apiEnergySite,
					type: 'GET',
					async: true,
					data: {
						sid: siteId,
						startTime: formYesterData.startTime,
						endTime: formYesterData.endTime,
						interval: 'day',
						formId: 'v2'
						
					}
				},		
			];

			let promises = [];
			promises.push( Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])),  Promise.resolve(returnAjaxRes(optionList[2])) );

			Promise.all(promises).then(res => {
				let el = $("#solarDashboard .mini .data-num");
				let accumVal = displayNumberFixedUnit(res[0].INV_PV.accumActiveEnergy, 'Wh', 'kWh', 0);
				let activePower = displayNumberFixedUnit(res[0].INV_PV.activePower, 'Wh', 'kWh', 0);
				let efficiency = toFixedNum(res[0].INV_PV.efficiency, 2);
				let dailyGen = displayNumberFixedUnit( Object.entries(res[1].data)[0][1].energy, 'Wh', 'kWh', 0);
				let yesterDayGen = [];
				let v = Object.values(res[2].data);

				if(!isEmpty(res[2].data) && v.flat()[0]["items"].length > 0 ){
					let data = v.flat()[0]["items"];
					yesterDayGen = displayNumberFixedUnit(data[0].energy,'Wh', 'kWh', 0);
				}

				el.eq(0).text(activePower[0]);
				el.eq(0).next().text("kWh");

				el.eq(1).text(efficiency);
				el.eq(1).next().text("%");

				el.eq(2).text(dailyGen[0]);
				el.eq(2).next().text("kWh");

				el.eq(3).text(yesterDayGen[0]);
				el.eq(3).next().text("kWh");

				el.eq(5).text(accumVal[0]);
				el.eq(5).next().text("kWh");
			});
		}
	}

	function todayGeneration(option) {
		const formData = getSiteMainSchCollection('day');
		const formYesterData = getSiteMainSchCollection('yesterday');

		let foreGen = new Object();
		let gen = {
			url: apiHost + apiEnergySite,
			type: 'get',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'hour',
				displayType: 'dashboard',
				formId: 'v2'
			}
		};
		let nowMonth = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			dataType: 'json',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'month'
			}
		}
		let nowGen = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'hour'
			}
		};
		let hourlyInsolation = {
			url: apiHost + apiWeather,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'hour'
			}
		}

		let energyData1 = new Array(24).fill(0);
		let energyData2 = new Array(24).fill(0);
		let energyData3 = new Array(24).fill(0);

		if (oid.match('testkpx')) { //KPX 조회시에는 전일 데이터로 변경.
			foreGen = {
				url: apiHost + apiEnergySite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: formYesterData.startTime,
					endTime: formYesterData.endTime,
					interval: 'hour',
					// displayType: 'dashboard',
					formId: 'v2'
				}
			};
		} else {
			foreGen = {
				url: apiHost + apiForecastingSite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: formData.startTime,
					endTime: formData.endTime,
					interval: 'hour',
					// displayType: 'dashboard',
					formId: 'v2'
				}
			};
		}

		if(isEmpty(option)){
			$.when($.ajax(gen), $.ajax(foreGen), $.ajax(nowGen)).done(function (genData, foreGenData, nowGenData) {
				if (genData[1] == 'success') {
					if (!isEmpty(genData[0].data) &&  Object.values(genData[0].data).flat()[0]["items"].length > 0) {
						let v = Object.values(genData[0].data);
						let dummyItem = v.flat()[0]["items"];
						if (dummyItem.length > 0) {
							dummyItem.forEach(el => {
								let index = Number(String(el.basetime).substring(8, 10));
								energyData1[index] =  el.energy;
							});
						}
					}
				}

				if (foreGenData[1] == 'success') {
					if (!isEmpty(foreGenData[0].data) && Object.values(foreGenData[0].data).flat()[0]["items"].length > 0) {
						let v = Object.values(foreGenData[0].data).flat()[0]["items"];
						// console.log("foreGenData===", foreGenData[0].data)
						v.forEach((el, index) => {
							energyData2[index] =  parseFloat((el.energy / 1000).toFixed(2));
						});
					}
				}

				if (nowGenData[1] == 'success') {
					let today = new Date();
					let hour = today.getHours();
					if(!isEmpty(nowGenData[0].data[siteId])) {
						// energyData1[index] === energyData[hour] ( current time E: NOW 에만 있는 데이터!!!!)
						energyData1[hour] = nowGenData[0].data[siteId].energy;
					}
				}

				energyData1.forEach((el, index) => {
					energyData1[index] = parseFloat((el / 1000).toFixed(2));
				});

				// energyData2.forEach((el, index) => {
				// 	energyData2[index] = el;
				// });

				hourlyChart.series[0].setData(energyData1);
				hourlyChart.series[1].setData(energyData2);
			}).fail(function () {
				console.log('rejected');
			});
		} else {
			$.when($.ajax(gen), $.ajax(foreGen), $.ajax(nowGen), $.ajax(hourlyInsolation)).done(function (genData, foreGenData, nowGenData, insolationData) {
				if (genData[1] == 'success') {
					if (!isEmpty(genData[0].data) &&  Object.values(genData[0].data).flat()[0]["items"].length > 0) {
						let v = Object.values(genData[0].data);
						let dummyItem = v.flat()[0]["items"];
						if (dummyItem.length > 0) {
							dummyItem.forEach(el => {
								let index = Number(String(el.basetime).substring(8, 10));
								energyData1[index] = el.energy;
							});
						}
					}
				}

				if (foreGenData[1] == 'success') {
					if (!isEmpty(foreGenData[0].data) && Object.values(foreGenData[0].data).flat()[0]["items"].length > 0) {
						let v = Object.values(foreGenData[0].data).flat()[0]["items"];

						v.forEach((el, index) => {
							// energyData2[index] = parseFloat((el.energy / 1000).toFixed(2));
							// energyData2[index] = numberComma(el.energy / 1000000);
							// console.log("energyData2===", el)
							energyData2[index] = parseFloat((el.energy / 1000).toFixed(2));
						});
					}
				}

				if (nowGenData[1] == 'success') {
					let today = new Date();
					let hour = today.getHours();

					if(!isEmpty(nowGenData[0].data[siteId])) {
						// energyData1[hour] = parseFloat((nowGenData[0].data[siteId].energy / 1000).toFixed(2));
						energyData1[hour] = nowGenData[0].data[siteId].energy;
						console.log("nowGenData[0].data[siteId].energy===", nowGenData[0].data[siteId])
					}
				}

				energyData1.forEach((el, index) => {
					energyData1[index] = parseFloat((el / 1000).toFixed(2));
					// energyData1[index] = numberComma(el / 1000000);
				});

				if (insolationData[1] == 'success') {
					// console.log("insolationData---", insolationData);
					if (!isEmpty(insolationData[0]) && insolationData[0].length>0) {
						let standard = String(insolationData[0][0].basetime).substring(0, 6);
						let sumVal = 0;

						for(let i=0, arrLength = insolationData.length; i<arrLength; i++){
							energyData3[i] = parseFloat(insolationData[0][i].sensor_solar.irradiationPoa / 1000).toFixed(2);
						}
					}
				}
				
				if(!isEmpty(hourlySolarChart.series.length>0)){
					hourlySolarChart.series.length = 0;
				}

				if(energyData1.length>0){
					// if (first) {
						// hourlySolarChart.series[0].setData(energyData1);

						hourlySolarChart.addSeries({
							name: '발전 실적',
							type: 'column',
							color: 'var(--turquoise)',
							tooltip: {
								valueSuffix: 'kWh'
							},
							data: energyData1
						});
					// } else {
					// 	hourlySolarChart.series[0].setData(energyData1);
					// }

				}

				if(energyData2.length>0){
					// hourlySolarChart.series.push(energyData2);
					// if (first) {
							hourlySolarChart.addSeries({
								name: '발전 에측',
								type: 'column',
								color: 'var(--white25)',
								tooltip: {
									valueSuffix: 'kWh'
								},
								data: energyData2
							});
					// } else {
					// 	hourlySolarChart.series[1].setData(energyData2);
					// }
				}

				if(energyData3.length>0){
					// hourlySolarChart.series[2].setData(energyData3);
					// if (first) {
						hourlySolarChart.addSeries({
							name: '일사량',
							type: 'line',
							dashStyle: 'ShortDash',
							yAxis: 1,
							color: 'var(--white60)',
							tooltip: {
								valueSuffix: '%'
							},
							data: energyData3
						});
					// } else {
					// 	hourlySolarChart.series[2].setData(energyData3);
					// }
				}
			}).fail(function () {
				console.log('rejected');
			});
		}
	}

	function getAlarmInfo () {
		const formData = getSiteMainSchCollection('day');
		let siteArray = new Array();

		$.ajax({
			url: apiHost + '/alarms',
			type: 'get',
			data: {
				sids: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				confirm: false
			},
		}).done(function (data, textStatus, jqXHR) {
			//localtime 오름차순 정렬
			data.sort((a, b) => {
				return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
			});

			//데이터 세팅
			let alarmList = new Array();
			
			data.forEach((el, index) => {
				if(el.level != 0) {
					let localTime = (el.localtime != null && el.localtime != '') ? String(el.localtime) : '';
					data[index].standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
					alarmList.push(el);
				}
			});
			$('.a_alert').find('em').text(alarmList.length);
			setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}});

		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		})
	}

	function levelClass(level) {
		let rtnClass = '';
		switch (level) {
			case 1 :
				rtnClass = 'warning';
				break;
			case 2 :
				rtnClass = 'critical';
				break;
			case 3 :
				rtnClass = 'shutoff';
				break;
			case 4 :
				rtnClass = 'urgent';
				break;
			case 0 :
				rtnClass = 'info';
				break;
			default :
				rtnClass = '';
		}

		return rtnClass;
	}

	function pageMove (id, action) {
		let $form = $('#linkSiteForm');

		id = id == '' ? siteId : id;
		let $inp = $('<input>').attr('type', 'hidden').attr('name', 'sid').val(id);

		$form.append($inp);
		if (action == 'alarm') {
			$form.attr('action', '/history/alarmHistory.do').submit();
		} else {
			$form.attr('action', '/dashboard/smain.do').submit();
		}
	}

	function flattenObject (obj) {
		let flat = {};
		for (const [key, value] of Object.entries(obj)) {
			if (typeof value === 'object' && value !== null) {
			for (const [subkey, subvalue] of Object.entries(value)) {
				// avoid overwriting duplicate keys: merge instead into array
				typeof flat[subkey] === 'undefined' ?
				flat[subkey] = subvalue :
				Array.isArray(flat[subkey]) ?
					flat[subkey].push(subvalue) :
					flat[subkey] = [flat[subkey], subvalue]
				}
			} else {
				flat = {...flat, ...{[key]: value}};
			}
		}
		return flat;
	}

	function addToDateList(today, idx, data, option){
		let now = today || new Date();
		let dates = [now.getDate()];
		let length = idx;

		while(idx--){
			now.setDate(now.getDate()-1);
			let num = now.format("yyyyMMdd").substring(4, 8);
			let val;


			if(length != data.length){
				let found = data.findIndex( x => ( parseInt(String(x.basetime).substring(4, 8)) == num) );
				if(found > -1 ){
					if(option == "energy"){
						val =  parseFloat((data[found].energy / 1000).toFixed(2));
					} else if(option == "irradiationPoa"){
						val = parseFloat((data[found].sensor_solar.irradiationPoa).toFixed(2));
					}
				
					// if(String(data[found].energy).length <= 5){
					// 	val =  parseFloat((data[found].energy/1000).toFixed(2));
					// } else {
					// 	val =  numberComma(data[found].energy/1000000);
					// }
				} else {
					val = null;
				}
				dates.push(val);
			} else {
				if(option == "energy"){
					val = parseFloat((data[idx].energy / 1000).toFixed(2));
				} else if(option == "irradiationPoa"){
					val = parseFloat((data[idx].sensor_solar.irradiationPoa).toFixed(2));
				}
				// if(String(data[idx].energy).length <= 5){
				// 	val = parseFloat((data[idx].energy/1000).toFixed(2));
				// } else {
				// 	val = parseFloat((data[idx].energy/1000000).toFixed(2));
				// }
				dates.push(val);
			}
			// dates.push(now.getDate());
		}
		// console.log("dates---", dates)
		return dates.reverse();
	}

</script>