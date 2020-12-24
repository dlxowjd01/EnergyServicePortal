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

	<div class="row content-wrapper">
		<div class="col-12">
			<div class="flex-start">
				<div class="dropdown">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown" disabled><fmt:message key='default.dataNameSelect' /><span class="caret"></span></button>
					<ul id="viewOptList" class="dropdown-menu" role="menu">
						<li data-value="1" data-name="<fmt:message key='smain.dashboard1' /> #1"><a href="#" tabindex="-1"><fmt:message key='smain.dashboard1' /> #1</a></li>
						<li data-value="2" data-name="<fmt:message key='smain.dashboard2' /> #2"><a href="#" tabindex="-1"><fmt:message key='smain.dashboard2' /> #2</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<div id="defaultDashboard" class="row">
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv smain-pv clear">
				<div class="chart-top">
					<h2 class="ntit"><fmt:message key='smain.monthDevSynthesis' /></h2>
					<h1 class="stit" id="monthlyDate"></h1>
				</div>
				<div class="chart-middle clear">
					<div class="box">
						<div class="line1"><fmt:message key='smain.totalMonthDev' /></div>
						<div class="line2" id="monthEnergyValue"></div>
					</div>
					<div class="box">
						<div class="line1"><fmt:message key='smain.totalYearDev' /></div>
						<div class="line2" id="yearEnergyValue"></div>
					</div>
					<div class="box">
						<div class="line1"><fmt:message key='smain.totalMonthDevTime' /></div>
						<div class="line2" id="monthGenHours"></div>
					</div>
					<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
					<div class="box type">
						<div class="sa-select">
							<div class="dropdown" id="chartType">
								<button type="button" class="dropdown-toggle w8" data-toggle="dropdown">
									PR<span class="caret"></span>
								</button>
								<ul class="dropdown-menu radio-type" role="menu">
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t1" name="radio_t" value="1" checked>
											<label for="radio_t1">PR</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t2" name="radio_t" value="2">
											<label for="radio_t2"><fmt:message key='smain.time' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t3" name="radio_t" value="3">
											<label for="radio_t3"><fmt:message key='smain.sales' /></label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					</c:if>
				</div>
				<div class="smain inchart">
					<div id="monthlyChart"></div>
				</div>
			</div>
			<div class="indiv smain-cal">
				<div class="chart-top">
					<h2 class="ntit"><fmt:message key='smain.monthDevCalendar' /></h2>
					<h1 class="stit" id="calendarDate"></h1>
				</div>
				<div class="calendar-wrap">
					<table class="calendar">
						<thead>
							<tr>
								<th><fmt:message key='smain.sun' /></th>
								<th><fmt:message key='smain.mon' /></th>
								<th><fmt:message key='smain.tue' /></th>
								<th><fmt:message key='smain.wed' /></th>
								<th><fmt:message key='smain.thu' /></th>
								<th><fmt:message key='smain.fri' /></th>
								<th><fmt:message key='smain.sat' /></th>
							</tr>
						</thead>
						<tbody id="calendarMonth">
							<%--
								<i class="ico-weather w1"></i> 	1	- 맑음 o
								<i class="ico-weather w2"></i>   	- 바람 x
								<i class="ico-weather w3"></i>	20	- 안개 o
								<i class="ico-weather w4"></i>	7	- 흐림 o
								<i class="ico-weather w5"></i>	 	- 바람/비 x
								<i class="ico-weather w6"></i>	13	- 비또는눈 o
								<i class="ico-weather w7"></i>  	- 구름/바람/비 x
								<i class="ico-weather w8"></i>	11	- 눈 o
								<i class="ico-weather w9"></i>	17	- 천둥번개 o
								<i class="ico-weather w10"></i>	12 - 가끔눈 o
							--%>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv smain-circle">
				<div class="chart-top">
					<h2 class="ntit">${siteName} <c:if test="${empty siteName }"><fmt:message key='smain.siteStatus' /></c:if></h2>
					<!-- <div class="btn-bx-type">
						<a href="javascript:void(0);" class="btn btn-cancel" id="cctv">CCTV 보기</a>
					</div> -->
				</div>
				<div class="chart-info">
					<div id="pie_chart" class="chart-info-left"></div>
					<!-- <div class="ci-left">
						<div class="inchart">
							<div id="pie_chart" style="height:200px; width:230px"></div>
						</div>
					</div> -->
					<div class="chart-info-right">
						<!-- <div class="legend-wrap">
							<span class="bu1">태양광</span>
							<span class="bu4">미 사용량</span>
						</div> -->
						<div class="legend-wrap">
							<c:if test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
								<span class="bu2"><fmt:message key='smain.windPower' /></span>
							</c:if>
							<span class="bu1"><fmt:message key="gdash.4.gen" /></span>
							<span class="bu4"><fmt:message key="gdash.4.idle" /></span>
						</div>
						<ul>
							<c:choose>
								<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
									<li><strong><fmt:message key='smain.aimedOutput' /></strong> <span id="siteCapacity">-</span><em>kW</em></li>
									<li><strong><fmt:message key='smain.receptionTime' /></strong> <span id="siteDcPower">-</span></li>
									<li><strong><fmt:message key='smain.sendTime' /></strong> <span id="siteAcPower">-</span></li>
								</c:when>
								<c:otherwise>
									<li><strong><fmt:message key='smain.totalSize' /></strong> <span id="siteCapacity">-</span><em>kW</em></li>
									<li><strong><fmt:message key='smain.rtDCinput' /></strong> <span id="siteDcPower">-</span><em>kW</em></li>
									<li><strong><fmt:message key='smain.rtACoutput' /></strong> <span id="siteAcPower">-</span><em>kW</em></li>
								</c:otherwise>
							</c:choose>

						</ul>
					</div>
				</div>
				<div class="local-info smain-center s-center">
					<table>
						<c:choose>
							<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
								<thead>
								<tr>
									<th><fmt:message key='smain.size' /></th>
									<th><fmt:message key='smain.totalTodayDev' /></th>
									<th><fmt:message key='smain.totalYesterdayDev' /></th>
									<th><fmt:message key='smain.todayDevTime' /></th>
								</tr>
								</thead>
								<tbody id="centerTbody">
								<tr>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								</tbody>
							</c:when>
							<c:otherwise>
						<thead>
						<tr>
							<th><fmt:message key='smain.devSize' /></th>
							<th><fmt:message key='smain.todayDev1' /></th>
							<th><fmt:message key='smain.todayDevTime' /></th>
							<th><fmt:message key='smain.todayPrediction' /></th>
							<th><fmt:message key='smain.smpPrediction' /></th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td><em>&nbsp;&nbsp;kW</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;H</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;<fmt:message key='smain.1000won' /></em></td>
						</tr>
						</tbody>
							</c:otherwise>
						</c:choose>
					</table>
				</div>
			</div>
			<div class="indiv smain-circle">
				<div class="flex-wrapper mb-24">
					<h2 class="ntit"><fmt:message key='smain.todayDevStatus' /></h2>
					<a href="javascript:void(0)" class="smain-go-pvGen btn-type" onclick="toPvGen('${sid}');">발전이력</a href="javascript:void(0)">
					<div class="stit fr" id="dayGenHours"></div>
				</div>
				<div class="search-wrap">
					<div class="inchart">
						<div id="hourlyChart"></div>
					</div>
				</div>
			</div>
			<div class="indiv smain weather">
				<div class="chart-top">
					<h2 class="ntit"><fmt:message key='smain.weather' /></h2>
					<h1 id="currentTimeA" class="stit">${nowTime}</h1>
				</div>
				<div class="weather-wrap">
					<div class="weather-table">
						<div class="today">
							<span id="weekIcon"><strong> - </strong></span>
							<em id="weekTemp"></em>
						</div>

						<table>
							<tr>
								<th><fmt:message key='smain.today' /></th>
								<th><fmt:message key='smain.tomorrow' /></th>
								<th><fmt:message key='smain.dayAfterTomorrow' /></th>
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
					</div>
					<div class="wt-list-wrap">
						<ul class="list-type">
							<li class="hidden"><strong><fmt:message key='smain.sunPower' /></strong><span id="weekIrradiation">-</span> W/m&#13217;</li>
							<li><strong><fmt:message key='smain.windDirection' /></strong><span id="weekWindDirection">-</span> &deg;</li>
							<li><strong><fmt:message key='smain.windSpeed' /></strong><span id="weekWindVelocity"></span></li>
							<li><strong><fmt:message key='smain.humidity' /></strong><span id="weekHum"></span></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-4 col-lg-12 col-md-12 col-sm-12">
			<div class="indiv smain-alarm" data-alarm="">
				<div class="alarm-status clear">
					<div class="alarm-alert"><span><fmt:message key='smain.todayError' /></span><em>0</em></div>
					<div class="alarm-warning"><a href="javascript:void(0);" onclick="pageMove('', 'alarm');" class="btn btn-cancel"><fmt:message key='smain.viewDetail' /></a></div>
				</div>
				<div class="alarm-notice">
					<ul id="alarmNotice">
						<li>
							<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');" class="[level]">
								<span class="err-msg">[site_name] - [message]</span>
								<span class="err-time">[standardTime]</span>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<!-- <div class="indiv gmain-table smain wrap-type"> -->
			<div class="indiv smain-table">
				<div class="table-top clear">
					<div class="fl">
						<input type="text" class="input" name="keyword" value="" placeholder="<fmt:message key='smain.keyword' />">
					</div>
					<div class="fr">
						<span class="tx-tit"><fmt:message key='smain.deviceStatus' /></span>
						<div class="sa-select">
							<div class="dropdown" id="statusDevice">
								<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown" data-name="<fmt:message key='default.dataNameSelect' />">
									<fmt:message key='smain.all' /> <span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk-type" role="menu">
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="0" checked>
											<label for="deviceStatus1"><fmt:message key='smain.stop' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="1" checked>
											<label for="deviceStatus2"><fmt:message key='smain.normal' /></label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus3" name="deviceStatus" value="2" checked>
											<label for="deviceStatus3"><fmt:message key='smain.trip' /></label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				<ul class="type-list" id="typeList">
					<li class="[type]">
						<div class="chart-top">
							<h2 class="ntit">[name] (<span>0</span>)</h2>
							<div class="alert-icon fr">
								<span class="inv-normal"><fmt:message key='smain.normal' /> (<span>0</span>)</span>
								<span class="inv-error"><fmt:message key='smain.trip' /> (<span>0</span>)</span>
								<span class="inv-alert"><fmt:message key='smain.stop' /> (<span>0</span>)</span>
							</div>
						</div>
						<div class="type-list-detail">
							<div class="table-type">
								[head]
							</div>

							<div class="device-table">
								[body]
							</div>

						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<div id="solarDashboard" class="hidden">
		<div class="row">
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit"><fmt:message key='smain.currentDev' /></h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit"><fmt:message key='smain.currentEfficiency' /></h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit"><fmt:message key='smain.todayDev2' /></h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit"><fmt:message key='smain.yesterdayDev' /></h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit"><fmt:message key='smain.monthDev' /></h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
			<div class="col-xl-2 col-lg-2 col-md-3 col-sm-4">
				<div class="indiv mini">
					<h3 class="ntit"><fmt:message key='smain.totalDev' /></h3>
					<p class="word-wrap"><span class="data-num"></span><span class="data-unit"></span></p>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-xl-4 col-lg-5 col-md-6 col-sm-12">
				<div class="indiv narrow">
					<h2 class="ntit"><fmt:message key='smain.todayDevStatus' /></h2>
					<div id="hourlySolarChart"></div>
				</div>
			</div>

			<div class="col-xl-4 col-lg-7 col-md-6 col-sm-12">
				<div class="indiv narrow">
					<h2 class="ntit"><fmt:message key='smain.inverterOutputStatus' /></h2>
					<div id="hourlyINVChart"></div>
				</div>
			</div>

			<div class="col-xl-4 col-lg-12 col-md-12 col-sm-12">
				<div class="indiv smain-table unset">
					<div class="table-top clear">
						<!-- <h2 class="tx-tit"><fmt:message key='smain.inverterStatus' /></h2> -->
					</div>
					<ul class="inverter_list" id="invList">
						<li class="[type]">
							<div class="chart-top">
								<h2 class="ntit">[name] (<span>0</span>)</h2>
								<div class="alert-icon fr">
									<span class="inv-normal"><fmt:message key='smain.normal' /> (<span>0</span>)</span>
									<span class="inv-error"><fmt:message key='smain.trip' /> (<span>0</span>)</span>
									<span class="inv-alert"><fmt:message key='smain.stop' /> (<span>0</span>)</span>
								</div>
							</div>
							<div class="type-list-detail">
								<div class="table-type">
									[head]
								</div>
								<div class="gmain-wrap type">
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
							<a href="#weatherInfo" class="nav-link" data-toggle="tab" ><fmt:message key='smain.weather' /></a>
						</li>
						<li class="nav-item">
							<a href="#powerConnctor" class="nav-link" data-toggle="tab"><fmt:message key='smain.connecter' /></a>
						</li>
					</ul>
					<span id="currentTimeB" class="stit">${nowTime}</span>
					<div class="tab-content">
						<div id="weatherInfo" class="tab-pane fade active in">
							<div class="weather-wrap">
								<div class="weather-table">
									<div class="today">
										<span id="weekSolarIcon"><strong> - </strong></span>
										
										<em id="sTemp"></em>
									</div>
									<table>
										<tr>
											<th><fmt:message key='smain.today' /></th>
											<th><fmt:message key='smain.tomorrow' /></th>
											<th><fmt:message key='smain.dayAfterTomorrow' /></th>
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
								</div>
								<div class="wt-list-wrap">
									<ul class="list-type">
										<li class="hidden"><strong><fmt:message key='smain.sunPower' /></strong><span id="sIrradiation">-</span> W/m&#13217;</li>
										<li><strong><fmt:message key='smain.windDirection' /></strong> <span id="sWindDirection">-</span> &deg;</li>
										<li><strong><fmt:message key='smain.windSpeed' /></strong> <span id="sWindVelocity"></span></li>
										<li><strong><fmt:message key='smain.humidity' /></strong> <span id="sHumidity"></span></li>
									</ul>
								</div>
							</div>
							
						</div>
						<div class="tab-pane fade" id="powerConnctor">
							<h2 class="no-data"><fmt:message key='smain.warning.noCurData' /></h2>
						</div>
					</div>
				</div>
			</div>

			<div class="col-xl-8 col-lg-7 col-md-6 col-sm-12">
				<div class="indiv narrow">
					<div class="chart-top clear">
						<h2 class="ntit fl"><fmt:message key='smain.dayDev' /></h2>

						<div class="flex-start">
							<span class="tx-tit"><fmt:message key='smain.period' /></span>
							<div class="sa-select mr-12">
								<div id="period" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name=""><fmt:message key='smain.recent1m' /><span class="caret"></span></button>
									<ul id="durationFilter" class="dropdown-menu">
										<li data-value="60"><a href="#"><fmt:message key='smain.recent2m' /></a></li>
										<li data-value="90"><a href="#"><fmt:message key='smain.recent3m' /></a></li>
										<li data-value="120"><a href="#"><fmt:message key='smain.recent4m' /></a></li>
									</ul>
								</div>
							</div>

							<span class="tx-tit"><fmt:message key='smain.inputDate' /></span>
							<div class="sel-calendar mr-24">
								<label for="fromDate" class="sr-only"><fmt:message key='smain.startDate' /></label>
								<input type="text" name="from_date" id="fromDate" class="sel fromDate" value="" autocomplete="off"><em></em>
								<label for="toDate" class="sr-only"><fmt:message key='smain.endDate' /></label>
								<input type="text" name="to_date" id="toDate" class="sel toDate" value="" autocomplete="off">
							</div>
							<button type="button" class="btn-type" onclick="chargeChartPoll('solarDashboard', 'datepicker')"><fmt:message key='smain.lookup' /></button>
						</div>
						<small id="isInvalidPeriod" class="warning-text d-table hidden"><fmt:message key='smain.warning.date' /></small>
					</div>
					<div id="dailySolarTrendChart"></div>
				</div>
			</div>
		</div>
	</div>

</div>


<script type="text/javascript" src="/js/modules/exporting.min.js"></script>
<script type="text/javascript" src="/js/modules/highstock-exporting.min.js"></script>
<script type="text/javascript">
	$(function () {
		var viewOptList = $('#viewOptList');
		var switchFlag = false;
		var refreshMinInterval;
		var refreshQuarterInterval;

		buildCalendar();

		$('input[name="keyword"]').on('keyup', function(e) {
			if (e.which == '13') {
				getDvcInfo();
			}
		});

		if (!isEmpty(sList)) {
			// console.log("sList==", sList)
			// sList.forEach(site => {
			// 	if (isEmpty(site.cctv)) {
			// 		$('#cctv').addClass('hidden');
			// 	} else {
			// 		$('#cctv').attr('href', site.cctv);
			// 	}
			// });

			if(!isEmpty(sList[0].devices) && sList[0].devices.length>0){
				let dList = sList[0].devices;
				
				for(let i=0, arrLength = dList.length; i<arrLength; i++){
					if(dList[i].device_type == "INV_PV"){
						viewOptList.prev().prop("disabled", false);
						invFlag = true;
						break;
					}
				};
				toggleDropdown(invFlag, viewOptList);
			} else {
				toggleDropdown(invFlag, viewOptList);
			}
		}

		$('#durationFilter li').on("click", function(){
			let val = $(this).data("value");
			let minus = String(-Math.abs(val));

			$('#fromDate').datepicker('setDate', minus  );
			$('#toDate').datepicker('setDate', 'today' )

			$("#loadingCircle").show();
			chargeChartPoll('solarDashboard', val);
		});

		$('#fromDate').on("change", function(){
			let fromDateVal = $('#fromDate').datepicker('getDate').getTime();
			let endDateVal = $('#toDate').datepicker('getDate').getTime();

			if( (fromDateVal - endDateVal) >= 0){
				$('#isInvalidPeriod').removeClass("hidden");
				$('#fromDate').datepicker('setDate', '-1');
				setTimeout(function(){
					$('#isInvalidPeriod').addClass("hidden");
				}, 1800);
			}
		});

		$("#loadingCircle").show();

		getWeatherData();
		getNowEnergy();
		getDvcProperties();

		if (oid.match('testkpx')) {
			viewOptList.prev().prop("disabled", true);
			viewOptList.find("li").eq(1).remove();
		} else {
			viewOptList.find('li').on('click', function(){
				let val = $(this).data("value");
				let name = $(this).data("name");

				if(switchFlag == false) {
					if(viewOptList.prev().text() != name) {
						if(val == "1"){
							$('#defaultDashboard').removeClass("hidden");
							$('#solarDashboard').addClass("hidden");
							setInitList('typeList');
							setInitList('alarmNotice');
							getMinuteData();
							getQuarterData();
							refreshMinInterval = setInterval(getMinuteData, 60 * 1000);
							refreshQuarterInterval = setInterval(getQuarterData, 15 * 60 * 1000);
						} else {
							setInitList('invList');
							getMinuteData(val);
							getQuarterData(val);
							getWeatherData(val);
							$('#defaultDashboard').addClass("hidden");
							$('#solarDashboard').removeClass("hidden");
							refreshMinInterval = setInterval(function(){
								getMinuteData("solarDashboard");
							}, 60 * 1000);
							refreshQuarterInterval = setInterval(function(){
								getQuarterData("solarDashboard");
							}, 15 * 60 * 1000);
						}
					}
				} else {
					clearInterval(refreshMinInterval);
					clearInterval(refreshQuarterInterval);
					// dropdown selected once before
					if(viewOptList.prev().text() != name) {
						if(val == "1"){
							$('#defaultDashboard').removeClass("hidden");
							$('#solarDashboard').addClass("hidden");
							setTimeout(function(){
								refreshMinInterval = setInterval(getMinuteData, 60 * 1000);
								refreshQuarterInterval = setInterval(getQuarterData, 15 * 60 * 1000);
							}, 300);
						} else {
							// setInitList('invList');
							// getMinuteData(val);
							// getQuarterData(val);
							// getWeatherData(val);
							$('#defaultDashboard').addClass("hidden");
							$('#solarDashboard').removeClass("hidden");
							setTimeout(function(){
								refreshMinInterval = setInterval(function(){
									getMinuteData("solarDashboard");
								}, 60 * 1000);
								refreshQuarterInterval = setInterval(function(){
									getQuarterData("solarDashboard");
								}, 15 * 60 * 1000);
							}, 300);
						}

					}
				}
				switchFlag = true;
				viewOptList.prev().data("value", val);
			});	
		}

		Highcharts.setOptions({
			lang : {
				resetZoom : "<fmt:message key='smain.resetZoom' />",
				loading : "<fmt:message key='smain.loading' />",
				noData: "<fmt:message key='smain.noSearchData' />"
			},
		});

		$(window).on("unload", function(e) {
			let selected = $("#viewOptList").prev().data("value");
			setCookie("sMainView", selected, 0.5);
			clearInterval(refreshMinInterval);
			clearInterval(refreshQuarterInterval);
		});

	});

	const buildCalendar = function () { //현재 달 달력 만들기
		let today = new Date();
		let doMonth = new Date(today.getFullYear(), today.getMonth(), 1);
		let lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0);
		let calendar = document.getElementById('calendarMonth');

		$('#calendarDate').html('<em>' + today.getFullYear() + '.01.01' + ' ~ ' + (new Date()).format('yyyy.MM.dd') + '</em>')

		while (calendar.rows.length > 1) {
			calendar.deleteRow(calendar.rows.length - 1);
		}

		let row = calendar.insertRow();
		let cell = null;
		let cnt = 0;
		const thisMonth = doMonth.getMonth() + 1 + '월';

		for (let i = 0; i < doMonth.getDay(); i++) {
			cell = row.insertCell();
			cell.classList.add('disabled');
			cnt = cnt + 1;
		}

		for (let i = 1; i <= lastDate.getDate(); i++) {
			cell = row.insertCell();
			cell.innerHTML =`
							<div class="flex-wrapper">
								<em class="calWeatherDay day">${'${i}'}</em>
								<em id="calWeatherValue_${'${i}'}"></em>
							</div>
							<div id="calWeatherIcon_${'${i}'}" class="wicon"></div>
							<span id="calEnergyValue_${'${i}'}" class="fr"></span>`;
			cnt = cnt + 1;

			if (cnt % 7 === 0) {
				row = calendar.insertRow();
			}

			/* today */
			if (i === today.getDate()) {
				cell.setAttribute('class', 'today');
			}
		}
	};

	const siteId = '${sid}';
	const sList = JSON.parse('${siteList}');

	const apiEnergySite = '/energy/sites';
	const apiEnergyNowSite = '/energy/now/sites';
	const apiEnergyDvc = '/energy/devices';
	const apiWeather = '/weather/site';
	const apiForecastingSite = '/energy/forecasting/sites';
	const apiStatusRawSite = '/status/raw/site';
	const apiStatusRaw = '/status/raw';
	const apiConfigDevice = '​/config/devices';
	const apiGetDvcProperties = '/config/view/device_properties';
	const apiGetProperties = '/config/view/properties2';
	const featureProperties = {};
	const featurePropertiesSub = {};

	let cookie = getCookie("sMainView");
	let first = true;
	let invFlag = false;

	var num12List = [...Array(12)].map((item, index) => {
		return String(index + 1)
	});
	var num24List = [...Array(24)].map((item, index) => {
		return String(index)
	});
	var num31List = [...Array(31)].map((item, index) => {
		return String(index + 1)
	});
	var date31List = addToDateList(31);

	// var groupingUnits = [
	// 	[
	// 		'minute', // unit name
	// 	[60] // allowed multiples
	// 	],
	// 	[
	// 		'day', [1]],
	// 	[
	// 		'week', [1]],
	// 	[
	// 		'month', [1]]
	// ];

	// Highcharts.SVGRenderer.prototype.symbols.download = function (x, y, w, h, z) {
	// 	var path = [
	// 		// Arrow stem
	// 		'M', x + w * 0.5, y,
	// 		'L', x + w * 0.5, y + h * 0.7,
	// 		// Arrow head
	// 		'M', x + w * 0.3, y + h * 0.5,
	// 		'L', x + w * 0.5, y + h * 0.7,
	// 		'L', x + w * 0.7, y + h * 0.5,
	// 		// Box
	// 		'M', x, y + h * 0.9,
	// 		'L', x, y + h,
	// 		'L', x + w, y + h,
	// 		'L', x + w, y + h * 0.9
	// 	];
	// 	return path;
	// };
	(function (H) {
		H.SVGRenderer.prototype.symbols.download = function (x, y, w, h, z) {
			var path = [
				// Arrow stem
				'M', x + w * 0.5, y,
				'L', x + w * 0.5, y + h * 0.7,
				// Arrow head
				'M', x + w * 0.3, y + h * 0.5,
				'L', x + w * 0.5, y + h * 0.7,
				'L', x + w * 0.7, y + h * 0.5,
				// Box
				'M', x, y + h * 0.9,
				'L', x, y + h,
				'L', x + w, y + h,
				'L', x + w, y + h * 0.9
			];
			return path;
		};

		// H.wrap(H.Chart.prototype, 'getDataRows', function(proceed, multiLevelHeaders) {

		// 	var rows = proceed.call(this, multiLevelHeaders);

		// 	rows = rows.map(row => {
		// 		if (row.x) {
		// 			row[0] = Highcharts.dateFormat('%Y/%m/%d', row.x * 1000);
		// 		}
		// 		return row;
		// 	});

		// 	return rows;
		// });

	}(Highcharts));


	// Highcharts.Chart.prototype.getDataRows = function() {
	// 	var options = (this.options.exporting || {}).csv || {},
	// 		xAxis = this.xAxis[0],
	// 		yAxis = this.yAxis[0],
	// 		rows = {},
	// 		rowArr = [],
	// 		dataRows,
	// 		names = [],
	// 		i,
	// 		pick = Highcharts.pick,
	// 		each = Highcharts.each,
	// 		x,
	// 		xTitle = xAxis.options.title && xAxis.options.title.text,

	// 		// Options
	// 		dateFormat = options.dateFormat || '%Y-%m-%d %H:%M:%S',
	// 		columnHeaderFormatter = options.columnHeaderFormatter || function(series, key, keyLength) {
	// 			return series.name + (keyLength > 1 ? ' (' + key + ')' : '');
	// 		};

	// 	// Loop the series and index values
	// 	i = 0;
	// 	each(this.series, function(series) {
	// 		if(series.hasOwnProperty("legendItem")){
	// 			var keys = series.options.keys,
	// 				pointArrayMap = keys || series.pointArrayMap || ['y'],
	// 				valueCount = pointArrayMap.length,
	// 				requireSorting = series.requireSorting,
	// 				categoryMap = {},
	// 				j;

	// 			// Map the categories for value axes
	// 			each(pointArrayMap, function(prop) {
	// 				categoryMap[prop] = (series[prop + 'Axis'] && series[prop + 'Axis'].categories) || [];
	// 			});

	// 			if (series.options.includeInCSVExport !== false && series.visible !== false) { // #55
	// 				j = 0;

	// 				while (j < valueCount) {
	// 					names.push(columnHeaderFormatter(series, pointArrayMap[j], pointArrayMap.length));
	// 					j = j + 1;
	// 				}

	// 				each(series.points, function(point, pIdx) {
	// 					if (point.x >= xAxis.min && point.x <= xAxis.max && point.y >= yAxis.min && point.y <= yAxis.max) {
	// 						var key = requireSorting ? point.x : pIdx,
	// 							prop,
	// 							val;
	// 						j = 0;

	// 						if (!rows[key]) {
	// 							rows[key] = [];
	// 						}

	// 						// rows[key].x = point.x + 1;
	// 						console.log("series====", series, "xAxis===", xAxis)
	// 						rows[key].x = rows[key].x;
	
					
	// 						// Pies, funnels etc. use point name in X row
	// 						if (!series.xAxis) {
	// 							rows[key].name = point.name;
	// 						}

	// 						while (j < valueCount) {
	// 							prop = pointArrayMap[j]; // y, z etc
	// 							val = point[prop];
	// 							rows[key][i + j] = pick(categoryMap[prop][val], val); // Pick a Y axis category if present
	// 							j = j + 1;
	// 						}
	// 					}
	// 				});
	// 				i = i + j;
	// 			}
	// 		}
	// 	});


	// 	// Make a sortable array
	// 	for (x in rows) {
	// 		if (rows.hasOwnProperty(x)) {
	// 			// console.log("x===", x, "rows[x]====", rows[x])
	// 			rowArr.push(rows[x]);
	// 		}
	// 	}
	// 	// Sort it by X values
	// 	rowArr.sort(function(a, b) {
	// 		return a.x - b.x;
	// 	});

	// 	// Add header row
	// 	if (!xTitle) {
	// 		xTitle = xAxis.isDatetimeAxis ? 'DateTime' : '순서';
	// 	}
	// 	dataRows = [
	// 		[xTitle].concat(names)
	// 	];

	// 	// Transform the rows to CSV
	// 	each(rowArr, function(row) {
	// 		var category = row.name;
	// 		if (!category) {
	// 			if (xAxis.isDatetimeAxis) {
	// 				category = Highcharts.dateFormat(dateFormat, row.x);
	// 			} else if (xAxis.categories) {
	// 				category = pick(xAxis.names[row.x], xAxis.categories[row.x], row.x);
	// 			} else {
	// 				category = row.x;
	// 			}
	// 		}

	// 		// Add the X/date/category
	// 		row.unshift(category);
	// 		dataRows.push(row);
	// 	});

	// 	return dataRows;
	// };


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
			x: 0,
			y: 10,
			style: {
				fontSize: '14px',
				color: 'var(--white87)'
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
				color: 'var(--white)',
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
			name: '<fmt:message key="smain.generation" />',
			colorByPoint: true,
			data: [
				{
					color: 'var(--blueberry)',
					name: '<fmt:message key="smain.power.wind.inv" />',
					dataLabels: {
						enabled: false
					},
					y: 0
				},
				{
					color: 'var(--circle-solar-power)',
					name: '<fmt:message key="smain.power.pv.inv" />',
					dataLabels: {
						enabled: false
					},
					y: 60
				},
				{
					color: 'var(--grey)',
					name: '<fmt:message key="smain.power.unused" />',
					dataLabels: {
						enabled: false
					},
					y: 20
				}
			]
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

	var monthlyChart = Highcharts.chart('monthlyChart', {
		chart: {
			marginTop: 60,
			marginLeft: 50,
			marginRight: 40,
			height: 280,
			backgroundColor: 'transparent',
			zoomType: 'xy'
		},
		lang: {
			noData: "<fmt:message key='smain.noSearchData' />"
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
			lineColor: 'var(--grey)',
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			tickInterval: 1,
			title: {
				text: null
			},
			labels: {
				align: 'center',
				overflow: 'justify',
				rotation: 0,
				y: 25,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			categories: num12List,
			crosshair: true
		}],
		yAxis: [
			{
				showEmpty: false,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				gridLineWidth: 1,
				title: {
					text: '',
					align: 'low',
					rotation: 0,
					// x: 15,
					y: 25,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						let suffix = this.chart.yAxis[0].userOptions.title.text;
						if(suffix == "MWh"){
							let length = String(this.value).length;
							if(length >= 7 && length < 10){
								return displayNumberFixedUnit(this.value, 'kWh', suffix, 0)[0];
							} else if(length >= 10){
								return displayNumberFixedUnit(this.value, 'kWh', "Gwh", 0)[0] + "k";
							} else {
								// NOT Mwh BUT longer enough to convert into floating number
								if(length >= 3){
									return displayNumberFixedUnit(this.value, 'kWh', suffix, 0)[0];
								} else {
									return displayNumberFixedUnit(this.value, 'kWh', 'kWh', 0)[0];
								}
							}
							 
						} else {
							return displayNumberFixedUnit(this.value, 'kWh', suffix, 0)[0];
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
			},
			// NOT KPX
			<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			{
				showEmpty: false,
				opposite: true,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [
					{
						color: 'var(--grey)',
						width: 1
					}
				],
				gridLineWidth: 1,
				title: {
					text: '<fmt:message key="smain.1000won" />',
					align: 'low',
					rotation: 0,
					y: 25,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 4) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
			},
			</c:if>
		],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					let val;
					if (suffix.toLowerCase() === "hr"){
						val = displayNumberFixedDecimal(point.y, 'kWh', 'kWh', 2)[0];
					} else {
						val = displayNumberFixedDecimal(point.y, 'kWh', 'kWh', 0)[0];
					}
					return s + '<br/><span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + val + " " + suffix;
				}, '<span style="display:flex; margin-bottom:-10px;"><b>'+(langStatus === "KO" ? this.x+'월' : monthEN[this.x-1])+'</b></span>');

			},
			shared: true,
			useHTML: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)',
			}
		},
		legend: {
			enabled: true,
			// useHTML: true,
			align: 'right',
			verticalAlign: 'top',
			x: 20,
			y: -10,
			itemStyle: {
				color: 'var(--white87)',
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
				borderWidth: 0,
				// TO DO!!!!!!!!!!
				// events: {
				// 	legendItemClick: function(event) {
				// 		var thisSeries = this;
				// 		var index = thisSeries._i;
				// 		var chart = thisSeries.chart;
				// 		// var visibility = this.visible ? 'visible' : 'hidden';

				// 		console.log("thisSeries==", index)
				// 		chart.yAxis[index].
				// 		// if (this.visible === true) {
				// 		// 	this.hide();
				// 		// 	chart.get("highcharts-navigator-series").hide();
				// 		// } else {
				// 		// 	this.show();
				// 		// 	chart.series.forEach(function(el, inx) {
				// 		// 		if (el !== thisSeries) {
				// 		// 		el.hide();
				// 		// 		}
				// 		// 	});
				// 		// 	chart.get("highcharts-navigator-series").setData(thisSeries.options.data, false);
				// 		// 	chart.get("highcharts-navigator-series").show();
				// 		// }
				// 		// event.preventDefault();
				// 	}
				// }
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
					name: '<fmt:message key='smain.generationResults' />',
				</c:when>
				<c:otherwise>
					name: '<fmt:message key='smain.PVGeneratedAmount' />',
				</c:otherwise>
				</c:choose>
				type: 'column',
				color: 'var(--turquoise)',
				data: [],
				tooltip: {
					valueSuffix: 'kWh',
				}

			},
			<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			{
				name: '<fmt:message key="smain.irradiance" />',
				type: 'spline',
				dashStyle: 'ShortDash',
				color: 'var(--white60)',
				yAxis: 1,
				data: [],
				tooltip: {
					valueSuffix: '천원',
				}
			}
			</c:if>
		],
		credits: {
			enabled: false
		},
	});

	var dailySolarTrendChart = Highcharts.stockChart('dailySolarTrendChart', {
		chart: {
			marginTop: 60,
			marginLeft: 65,
			marginRight: 65,
			marginBottom: 50,
			spacingLeft: 0,
			backgroundColor: 'transparent',
			zoomType: 'xy',
		},
		lang: {
			contextButtonTitle: "<fmt:message key='smain.download' />",
			downloadTitle: "<fmt:message key='smain.download' />",
			noData: "<fmt:message key='smain.noSearchData' />",
			downloadCSV: "CSV <fmt:message key='smain.download' />",
			downloadJPEG: "JPEG <fmt:message key='smain.download' />"
		},
		exporting: {
			enabled: true,
			tableCaption: '<fmt:message key="smain.dayDev" />',
			filename: setExportFileName(),
			buttons: {
				contextButton: {
					x: -10,
					y: 0,
					symbol: 'download',
					symbolStroke: "var(--vivid-blue)",
					symbolStrokeWidth: 2,
					theme: {
						fill: "none"
					},
					_titleKey: 'downloadTitle',
					// menuItems: null,
					onclick: function () {
						this.downloadCSV();
					},
					menuItems: null,
					// menuItems: [
					// // "viewFullscreen",
					// 	"downloadCSV",
					// // 	"separator",
					// // 	"downloadPNG",
					// //	 "downloadJPEG",
					// // 	"downloadPDF",
					// // 	"downloadSVG"
					// ],
					align: 'right',
				}
			},
			csv: {
				dateFormat: '%m/%d',
				columnHeaderFormatter: function (item, key) {
					if (!item || item instanceof Highcharts.Axis) {
						// return item.options.title.text;
						return "닐짜"
					}
					return {
						topLevelColumnTitle: '<fmt:message key="smain.dayDev" />',
						columnTitle: key === 'y' ? item.name : ''
					};
				},
			}
			// dateFormat: '%Y-%m-%d'
		},
		rangeSelector: {
			enabled: false,
		},
		scrollbar: {
			enabled: false,
		},
		navigator: {
			xAxis: {
				labels: {
					enabled: true,
					formatter: function () {
						let newVal =  Highcharts.dateFormat('%m/%d',  this.value);
						return newVal;
					},
				}
			},
			maskFill: 'var(--clear)',
            series: {
				// DO NOT USE css variable!!!!
                color: '#26ccc8',
                fillOpacity: 0.00,
				lineWidth: 2,
            }
		},
		plotOptions: {
			series: {
				showInLegend: true,
				pointIntervalUnit: 'day'
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [
			{
				type: 'datetime',
				format: '{value:%m/%d}',
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				tickInterval: 1,
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				labels: {
					align: 'center',
					y: 27,
					formatter: function () {
						let newVal = Highcharts.dateFormat('%m/%d',  this.value);
						return newVal;
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				title: {
					text: null
				},
			},
			// {
			// 	visible: false,
			// }
		],
		yAxis: [
			{
				opposite: true,
				min: 0,
				gridLineWidth: 0,
				plotLines: [
					{
						color: 'var(--grey)',
						width: 1
					}
				],
				title: {
					text: 'kWh',
					x: -13,
					y: 30,
					align: 'low',
					rotation: 0,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				// offset: 0,
				labels: {
					overflow: 'justify',
					align: 'left',
					style: {
						color: 'var(--grey)',
						fontSize: '12px',
					},
				},
			},
			{
				opposite: false,
				// minRange: 1,
				min: 0,
				gridLineWidth: 0,
				plotLines: [
					{
						color: 'var(--grey)',
						width: 1
					}
				],
				title: {
					text: '',
					x: 5,
					y: 30,
					align: 'low',
					rotation: 0,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					enabled: true,
					// overflow: 'justify',
					// align: 'left',
					style: {
						color: 'var(--grey)',
						fontSize: '12px',
					},
				},
			},
		],
		tooltip: {
			shared: true,
			useHTML: true,
			split: false,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)',
			},
			formatter: function () {
				// let temp = date31List[this.x];
				let temp = this.x ? (new Date(this.x)) : null;
				let newVal = "";

				newVal = temp ? (temp.format("MM") + "/" + temp.format("dd")) : "";

				return ['<span style="display:flex; margin-bottom:-10px;"><b>' + newVal + '</b></span>'].concat(
					this.points ?
						this.points.map(function (point) {
							let suffix  = '';
							let val;
							if(point.series.name == "일사량"){
								val = Math.round(point.point.y);
							} else {
								val = displayNumberFixedUnit(point.point.y, 'kWh', 'kWh', 0)[0];
							}
							point.series.options.tooltip.valueSuffix ? (suffix = point.series.options.tooltip.valueSuffix) : (suffix = "");

							return "<br/><span style='color:" + point.series.color + "'>\u25CF</span> " + point.series.name + ": " + val + " " + suffix;
						}) : []
				);
			},
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: -35,
			// x: -10,
			y: 0,
			itemStyle: {
				color: 'var(--white87)',
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
			borderColor: 'var(--grey)',
			borderWidth: 0,
			// marker: {
			//     lineWidth: 1
			// }
		},
		credits: {
			enabled: false
		},
	});


	var hourlyChart = Highcharts.chart('hourlyChart', {
		chart: {
			marginTop: 50,
			marginLeft: 50,
			marginRight: 10,
			height: 301,
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
		xAxis: {
			lineColor: 'var(--grey)',
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			labels: {
				align: 'center',
				overflow: 'justify',
				rotation: 0,
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
				showEmpty: false,
				opposite: false,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				gridLineWidth: 1,
				min: 0,
				title: {
					x: 10,
					y: 27,
					text: 'kWh',
					align: 'low',
					rotation: 0,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					overflow: 'justify',
					formatter: function () {
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 3) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
					x: -10,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}
			}, {}
		],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					return s + '<br/><span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + numberComma(point.y) + suffix;
				}, '<span style="display:flex; margin-bottom:-10px;"><b>'+(langStatus === "KO" ? this.x+'시' : this.x+'H')+'</b></span>');
			},
			shared: true,
			useHTML: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white87)',
			},
		},
		legend: {
			enabled: true,
			x: 5,
			y: -10,
			align: 'right',
			verticalAlign: 'top',
			itemStyle: {
				color: 'var(--white87)',
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
						enabled: true
					}
				},
				column: {
					//stacking: 'normal'
				}
			},
		credits: {
			enabled: false
		},
		series: [
			{
				type: 'column',
				<c:choose>
					<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				name: '<fmt:message key="smain.generationResults" />',
					</c:when>
					<c:otherwise>
				name: '<fmt:message key='smain.PVGeneratedAmount' />',
					</c:otherwise>
				</c:choose>
				color: 'var(--turquoise)', /* PV발전량 */
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: []
			},
			{
				type: 'column',
				<c:choose>
					<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				name: '<fmt:message key="smain.yesterdayDev" />',
					</c:when>
					<c:otherwise>
				name: '<fmt:message key="smain.generationPrediction" />',
					</c:otherwise>
				</c:choose>

				color: 'var(--grey)',
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: []
			},
			{
				type: 'spline',
				dashStyle: 'ShortDash',
				<c:choose>
					<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				name: '<fmt:message key="smain.devTime" />',
					</c:when>
					<c:otherwise>
				name: '<fmt:message key="smain.devTime" />',
					</c:otherwise>
				</c:choose>

				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'H',
				},
				data: []
			},
		],

	});


	var hourlySolarChart = Highcharts.chart('hourlySolarChart', {
		chart: {
			// styledMode: true,
			marginTop: 80,
			marginLeft: 60,
			marginRight: 55,
			height: 320,
			backgroundColor: 'transparent',
			zoomType: 'xy',
		},
		lang: {
			noData: "<fmt:message key='smain.noSearchData' />"
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
			lineColor: 'var(--grey)',
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			labels: {
				align: 'center',
				overflow: 'justify',
				rotation: 0,
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
				// className: 'js-axis-title',
				showEmpty: false,
				opposite: true,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				gridLineWidth: 1,
				min: 0,
				title: {
					text: 'kWh',
					x: -13,
					y: 30,
					align: 'low',
					rotation: 0,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 4) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}
			},
			{
				showEmpty: false,
				opposite: false,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [
					{
						color: 'var(--grey)',
						width: 1
					}
				],
				title: {
					text: 'W/m\xB2',
					x: 0,
					y: 31,
					align: 'low',
					rotation: 0,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 4) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
			}
		],
		tooltip: {
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			valueSuffix: 'kWh',
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					let val = displayNumberFixedDecimal(point.y, 'kWh', 'kWh', 0)[0];

					return s + '<br/><span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ':  ' + val + " " + suffix;
				}, '<span style="display:flex; margin-bottom:-10px;"><b>'+(langStatus === "KO" ? this.x+'시' : this.x+'H')+'</b></span>');

			},
			style: {
				color: 'var(--white87)',
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: -5,
			y: -10,
			itemStyle: {
				color: 'var(--white87)',
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
		},
		credits: {
			enabled: false
		},
	});

	var hourlyINVChart = Highcharts.chart('hourlyINVChart', {
		chart: {
			marginTop: 50,
			marginLeft: 20,
			marginRight: 55,
			height: 320,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			type: "column",
			lang: {
				noData: "<fmt:message key='smain.noData' />"
			},
		},
		lang: {
			noData: "<fmt:message key='smain.noSearchData' />"
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
			lineColor: 'var(--grey)',
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			labels: {
				align: 'center',
				overflow: 'justify',
				rotation: 0,
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
				showEmpty: false,
				opposite: true,
				tickColor: 'var(--grey)',
				lineColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
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
					formatter: function () {
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 4) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}
			},
			{
				showEmpty: false,
				opposite: false,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				gridLineWidth: 1,
				title: {
					text: '',
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
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 4) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
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
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					let val = displayNumberFixedDecimal(point.y, 'kWh', 'kWh', 0)[0];

					return s + '<br/><span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ':  ' + val + " " + suffix;
				}, '<span style="display:flex; margin-bottom:-10px;"><b>'+(langStatus === "KO" ? this.x+'시' : this.x+'H')+'</b></span>');

			},
			style: {
				color: 'var(--white87)',
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: -5,
			y: -10,
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
				fontWeight: 400,
			},
			itemHoverStyle: {
				color: ''
			},
			labelFormatter: function () {
				const newName = this.name.substring(0, Math.min(this.name.length, 18));
				return newName.length === this.name.length ? newName : newName + "...";
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
			column: {
				// stacking: 'normal'
			}
		},
		credits: {
			enabled: false
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
		let weekWeatherTime = {};

		if (oid.match('testkpx')) {
			let did = '';

			sList.forEach(site => {
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

			let properties = {
				url: apiHost + apiGetProperties,
				type: 'get',
				dataType: 'json',
				data: { types: 'location' }
			}

			$.when($.ajax(weekWeather), $.ajax(weekWeatherTime), $.ajax(statusRaw), $.ajax(properties)).done(function (weekWeatherData, weekWeatherTimeData, statusRawData, propertiesData) {
				// KPX ONLY
				if (weekWeatherData[1] == 'success') {
					let weekWeather = weekWeatherData[0];
					// console.log("weekWeatherData[0]===", weekWeatherData)
					if($('#viewOptList').prev().data("value") == "2"){
						weekWeather.forEach((el, index) => {
							$('#sTemp' + (index + 1)).text((Math.round(el.temperature * 10) / 10).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#sWeatherIcon' + (index + 1)).html('<i class="ico-weather ' + weatherIconClass + '"></i>');
						});
					} else {
						weekWeather.forEach((el, index) => {
							$('#weekTemp' + (index + 1)).text((Math.round(el.temperature * 10) / 10).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#weekIcon' + (index + 1)).html('<i class="ico-weather ' + weatherIconClass + '"></i>');
						});
					}
				}

				if (weekWeatherTimeData[1] == 'success') {
					let items = weekWeatherTimeData[0];
					if (items.length > 0) {
						let tempArray = [];
						$.each(items, function (i, el) {
							if (el.observed != undefined && el.observed) {
								tempArray.push(el);
							}
						});

						let prop, siteLocation;
						if (propertiesData[1] === 'success') {
							prop = propertiesData[0].location;

							if (!isEmpty(prop)) {
								Object.entries(prop).forEach(([propIdx, country]) => {
									const location = country.locations;
									Object.entries(location).forEach(([locIdx, loc]) => {
										if (loc.code === sList[0].location) {
											siteLocation = langStatus === 'KO' ? loc.name.kr : loc.name.en;
										}
									});
								});

								if (isEmpty(siteLocation)) siteLocation = sList[0].location;
							}
						}

						if (tempArray.length > 0) {
							let weatherIconClass = getWeatherIcons(tempArray[tempArray.length - 1].sky);
							let deviceIrrData = tempArray[tempArray.length - 1].sensor_solar.irradiationPoa;

							if($('#viewOptList').prev().data("value") == "2"){
								$('#sTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + '&nbsp;' + '&#8451;');
								$('#weekSolarIcon').html('<i class="ico-weather ' + weatherIconClass + '"></i><strong>' + siteLocation + '</strong>');
								if(!isEmpty(deviceIrrData)){						
									$("#sIrradiation").parents().closest('li').removeClass('hidden');
									$("#sIrradiation").text(deviceIrrData);
								}
							} else {
								$('#weekTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + '&nbsp;' + '&#8451;');
								$('#weekIcon').html('<i class="ico-weather ' + weatherIconClass + '"></i><strong>' + siteLocation + '</strong>');
								if(!isEmpty(deviceIrrData)){	
									$("#weekIrradiation").parents().closest('li').removeClass('hidden');
									$("#weekIrradiation").text(deviceIrrData)
								}
							}
						}
					}
				}

				if (statusRawData[1] == 'success') {
					let items = statusRawData[0];
					if (!isEmpty(items)) {

						let prop, siteLocation;
						if (propertiesData[1] === 'success') {
							prop = propertiesData[0].location;

							if (!isEmpty(prop)) {
								Object.entries(prop).forEach(([propIdx, country]) => {
									const location = country.locations;
									Object.entries(location).forEach(([locIdx, loc]) => {
										if (loc.code === sList[0].location) {
											siteLocation = langStatus === 'KO' ? loc.name.kr : loc.name.en;
										}
									});
								});

								if (isEmpty(siteLocation)) siteLocation = sList[0].location;
							}
						}

						Object.entries(items).map(obj => {
							let deviceData = obj[1].data;
							deviceData.forEach(di => {
		
								let humidity = isEmpty(di.humidity) ? '-' : di.humidity;
								let windDirection = isEmpty(di.windDirection) ? '-' : di.windDirection;
								let windSpeed = isEmpty(di.windSpeed) ? '-' : di.windSpeed;
								let wind_velocity = isEmpty(di.wind_velocity) ? '-' : di.wind_velocity;
								let temperature = isEmpty(di.temperature) ? '-' : (di.temperature).toFixed(1);
								
								if($('#viewOptList').prev().data("value") == "2"){
									$('#sTemp').html(temperature + ' ' + '&#8451;');
									$('#weekSolarIcon').next('strong').html(siteLocation);
									$('#sWindVelocity').text((windSpeed).toFixed(1) + ' km/h');
									$('#sWindDirection').text(windDirection);
									$('#sHumidity').html(humidity + ' ' + '&#37;');
									$('.weather .stit').html(new Date(di.timestamp).format('yyyy-MM-dd HH:mm:ss'));

								} else {
									$('#weekTemp').html(temperature + '&#8451;');
									$('#weekIcon').find('strong').html(siteLocation);
									if(windSpeed != "-"){
										$('#weekWindVelocity').text((windSpeed).toFixed(1) + ' km/h');
									} else {
										$('#weekWindVelocity').text((windSpeed));
									}
									$('#weekWindDirection').text(windDirection);
									$('#weekHum').html(humidity + ' ' + '&#37;');
									$('.weather .stit').html(new Date(di.timestamp).format('yyyy-MM-dd HH:mm:ss'));
								}
							});
						});
					}
				}
			}).fail(function () {
				console.error('rejected');
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

			let properties = {
				url: apiHost + apiGetProperties,
				type: 'get',
				dataType: 'json',
				data: { types: 'location' }
			}

			$.when($.ajax(weekWeather), $.ajax(weekWeatherTime), $.ajax(properties)).done(function (weekWeatherData, weekWeatherTimeData, propertiesData) {
				let weekWeather = weekWeatherData[0];
				let prop = propertiesData[0];
				if (weekWeatherData[1] == 'success') {
					if($('#viewOptList').prev().data("value") == "2"){
						weekWeather.forEach((el, index) => {
							$('#sTemp' + (index + 1)).text((el.temperature).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#sWeatherIcon' + (index + 1)).html('<i class="ico-weather ' + weatherIconClass + '"></i>');
						});	
					} else {
						weekWeather.forEach((el, index) => {
							$('#weekTemp' + (index + 1)).text((el.temperature).toFixed(1));
							let weatherIconClass = getWeatherIcons(el.sky);
							$('#weekIcon' + (index + 1)).html('<i class="ico-weather ' + weatherIconClass + '"></i>');
						});
					}
				}

				if (weekWeatherTimeData[1] == 'success') {
					let items = weekWeatherTimeData[0];
					let prop, siteLocation;
					if (propertiesData[1] === 'success') {
						prop = propertiesData[0].location;

						if (!isEmpty(prop)) {
							Object.entries(prop).forEach(([propIdx, country]) => {
								const location = country.locations;
								Object.entries(location).forEach(([locIdx, loc]) => {
									if (loc.code === sList[0].location) {
										siteLocation = langStatus === 'KO' ? loc.name.kr : loc.name.en;
									}
								});
							});

							if (isEmpty(siteLocation)) siteLocation = sList[0].location;
						}
					}
					if (items.length > 0) {
						let tempArray = [];
						$.each(items, function (i, el) {
							if (el.observed != undefined && el.observed) {
								tempArray.push(el);
							}
						});
						// console.log("NOT KPX getWeatherData tempArray===", tempArray)
						if (tempArray.length > 0) {
							let weatherIconClass = getWeatherIcons(tempArray[tempArray.length - 1].sky);
							let deviceIrrData = tempArray[tempArray.length - 1].sensor_solar.irradiationPoa;

							if($('#viewOptList').prev().data("value") == "2") {
								$('#sTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + '&#8451;');
								$('#weekSolarIcon').html('<i class="ico-weather ' + weatherIconClass + '"></i><strong>' + siteLocation + '</strong>');
								$('#sWindVelocity').text((tempArray[tempArray.length - 1].wind_speed).toFixed(1) + ' km/h');
								$('#sWindDirection').text(tempArray[tempArray.length - 1].wind_velocity);
								$('#sHumidity').html((tempArray[tempArray.length - 1].humidity).toFixed(1) + ' ' + '&#37;');
								$('#currentTimeB').html(String(tempArray[tempArray.length - 1].basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));

								if(!isEmpty(deviceIrrData)){
									$("#sIrradiation").parents().closest('li').removeClass('hidden');
									$("#sIrradiation").text(deviceIrrData)
								}
							} else {
								$('#weekTemp').html((tempArray[tempArray.length - 1].temperature).toFixed(1) + '&#8451;');
								$('#weekIcon').html('<i class="ico-weather ' + weatherIconClass + '"></i><strong>' + siteLocation + '</strong>');
								$('#weekWindVelocity').text((tempArray[tempArray.length - 1].wind_speed).toFixed(1) + ' km/h');
								$('#weekWindDirection').text(tempArray[tempArray.length - 1].wind_velocity);
								$('#weekHum').html((tempArray[tempArray.length - 1].humidity).toFixed(1) + ' ' + '&#37;');
								$('#currentTimeA').html(String(tempArray[tempArray.length - 1].basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
								
								if(!isEmpty(deviceIrrData)){
									$("#weekIrradiation").parents().closest('li').removeClass('hidden');
									$("#weekIrradiation").text(deviceIrrData)
								}
							}
						}
					}
				
				}
			}).fail(function () {
				console.error('rejected');
			});

		}
	}

	function toggleDropdown(invFlag, viewOptList){

		if( !isEmpty( getCookie("sMainView")) ){
			if(cookie == "2" && invFlag == true){
				let selected = viewOptList.find("li:last-of-type").data("name");
				viewOptList.prev().prop("disabled", false).data("value", "2").contents().get(0).nodeValue = selected;
				$('#defaultDashboard').addClass("hidden");
				$('#solarDashboard').removeClass("hidden");
				setInitList('invList');
				getMinuteData("solarDashboard");
				getQuarterData("solarDashboard");

				refreshMinInterval = setInterval(function(){
					getMinuteData("solarDashboard");
				}, 60 * 1000);

				refreshQuarterInterval = setInterval(function(){
					getQuarterData("solarDashboard");
				}, 15 * 60 * 1000);

			} else {
				let selected = viewOptList.find("li:first-of-type").data("name");
				viewOptList.prev().data("value", "1").contents().get(0).nodeValue = selected;
				if(invFlag == true){
					viewOptList.prev().prop("disabled", false);
				} else {
					viewOptList.prev().prop("disabled", true);
				}
				$('#defaultDashboard').removeClass("hidden");
				$('#solarDashboard').addClass("hidden");
				setInitList('typeList');
				setInitList('alarmNotice');
				getMinuteData();
				getQuarterData();

				refreshMinInterval = setInterval(getMinuteData, 60 * 1000);
				refreshQuarterInterval = setInterval(getQuarterData, 15 * 60 * 1000);
			}			
		} else {
			// NO cookie has been set
			let selected = viewOptList.find("li:first-of-type").data("name");
			viewOptList.prev().contents().get(0).nodeValue = selected;
			if(invFlag == true){
				viewOptList.prev().prop("disabled", false);
			} else {
				viewOptList.prev().prop("disabled", true);
			}
			$('#defaultDashboard').removeClass("hidden");
			$('#solarDashboard').addClass("hidden");
			setInitList('typeList');
			setInitList('alarmNotice');
			getMinuteData();
			getQuarterData();
			refreshMinInterval = setInterval(getMinuteData, 60 * 1000);
			refreshQuarterInterval = setInterval(getQuarterData, 15 * 60 * 1000);
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
			$("#loadingCircle").show();
			getTodayTotal("solarDashboard");
			todayGeneration("solarDashboard");
			if (!first) {
				getDvcInfo("solarDashboard");
				todayGeneration();
			}
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
			let errMsg = "<fmt:message key='smain.error.1' /> <br/><fmt:message key='smain.error.2' />" + errorThrown;
			let r = formatErrorMessage(jqXHR, errorThrown);
			console.log("error===", r);
			$("#errMsg").html(errMsg);
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
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
				if(isEmpty(val.properties)) return false;
				let propList = val.properties;
				let deviceName = key;
				let tempFeature = [];
				let tempFeature2 = [];
				let devicePropName = (langStatus == 'KO') ? val.name.kr : val.name.en;

				$.map(propList, function (v, k) {
					if (v.dashboard_head) {
						let tempObj = {};
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;

						tempObj['key'] = k;
						tempObj['value'] = propName;
						tempObj['suffix'] = unit;
						tempObj['reducer'] = v.dashboard_head_reducer;
						tempFeature.push(tempObj);

						featureProperties[deviceName] = {
							name: devicePropName,
							prop: tempFeature
						};
					}

					if (v.dashboard_detail) {
						let tempObj2 = {};
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let subPropName = (langStatus == 'KO') ? v.name.kr : v.name.en;

						tempObj2['key'] = k;
						tempObj2['value'] = subPropName;
						tempObj2['suffix'] = unit;
						tempFeature2.push(tempObj2);

						featurePropertiesSub[deviceName] = {
							name: subPropName,
							prop: tempFeature2
						}
					}

				});
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			let errMsg = "<fmt:message key='smain.error.1' /> <br/><fmt:message key='smain.error.2' />" + errorThrown;
			let r = formatErrorMessage(jqXHR, errorThrown);
			console.log("error===", r);
			$("#errMsg").html(errMsg);
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			return false;
		}).always(function(jqXHR, textStatus) {
			if(cookie == "2"){
				getDvcInfo("solarDashboard");
			} else {
				getDvcInfo();
			}
			first = false;
		});
	};

	function getDvcInfo(option) {
		let deviceArray = [];
		if (!isEmpty(sList[0].devices)) {
			sList[0].devices.forEach(el => {
				deviceArray.push(el.did);
			});
		}

		if(deviceArray.length > 0) {
			// currentR,S,T, voltage R,S,T reactivePower 등의 값들 때문에 /status/raw api 호출
			$.ajax({
				url: apiHost + apiStatusRaw,
				type: 'get',
				dataType: 'json',
				data: {
					dids: deviceArray.toString()
				}
			}).done(function (data, textStatus, jqXHR) {
				if (isEmpty(option)){
					// #1 site Dashboard
					let deviceType = [];
					let sortedData;

					if(!isEmpty(data) && Object.values(data)){
						sortedData = Object.values(data).filter( x => x.data.length>0 );
						sortedData.sortOn("dname");
					}
					$.map(sortedData, function(val, key) {
						if (!isEmpty(val.data.length>0)) {
							if ($.inArray(val.device_type, deviceType) === -1) {
								deviceType.push(val.device_type);
							}
						}
					});

					$.each(deviceType, function (i, el) {
						deviceType[i] = {
							name: featureProperties[el].name,
							type: el,
							head: featureProperties[el].prop,
							body: {
								type: el,
								prop: featurePropertiesSub[el].prop
							}
						}
					});
					
					setMakeList(deviceType, 'typeList', { 'dataFunction': { 'head': makeHeadTable, 'body': makeBodyTable } });
					
					$.each(deviceType, function (i, el) {
						let dvcType = el.type;
						let operationNormal = 0;
						let operationError = 0;
						let operationAlert = 0;
						let headerDataObject = {};
						let tableArray = [];

						setInitList('table_' + dvcType);

						$.map(sortedData, function(val, key) {
							let dname = val.dname;
							if (val.device_type == dvcType) {
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

									// console.log("featureProperties===", featureProperties);
									
									$.map(featureProperties, function(val, key) {
										let headerData = {};
										let unitList = [];

										if(!isEmpty(headerDataObject[key])) {
											headerData = headerDataObject[key];
										}

										if (key == dvcType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key];
												let tempObj = {};
										
												if(isEmpty(headerData[el.key])) {
													tempObj['reducer'] = el.reducer;
												} else {
													tempObj = headerData[el.key];
												}

												if(isEmpty(value)) {
													value = '-';
												} else {
													if(value != '-' && typeof value == 'number') {
														value = Number(value);
													}
												}

												if(value == '-') {
													if(typeof tempObj['cnt'] == "number"){
														if(!isEmpty(headerData[el.key])) {
															tempObj['cnt'] = Number(tempObj['cnt']) + 1;
														} else {
															tempObj['value'] = "-";
															tempObj['cnt'] = 1;
														}
													}
												} else {
													if(!isEmpty(headerData[el.key])) {
														if(typeof tempObj['value'] == 'number') {
															tempObj['value'] = Number(value) + Number(tempObj['value']);
															tempObj['cnt'] = Number(tempObj['cnt']) + 1;
														} else {
															tempObj['value'] = value;
															tempObj['cnt'] = 1;
														}
													
													} else {
														if(typeof tempObj['value'] == 'number') {
															tempObj['value'] = Number(value);
															tempObj['cnt'] = 1;
														} else {
															tempObj['value'] = value;
															tempObj['cnt'] = 1;
														}
													}
													tempObj['suffix'] = el.suffix;
												}
												headerData[el.key] = tempObj;
											});							
											headerDataObject[key] = headerData;
										}
									});

									$.map(featurePropertiesSub, function(val, key) {
										if (key == dvcType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key];
												if(isEmpty(value)) {
													rowData[0][el.key] = "-";
												} else {
													if( el.key.match('activePower') || el.key.match('dcPower') ) {
														let strVal = '';
														if(el.key.startsWith("reactive")){
														// console.log("el.key222==", el.key, "value===", value)
														// Unit: Var => kVAR, mVAR, gVAR, tVAR)
															if(!isEmpty(value)) {
																if(value < 1000) {
																	strVal = (value % 1 === 0) ? [value, "VAR"] : displayNumberFixedDecimal(value, 'VAR', 3, 2);
																} else if(value >= 1000 && value < 1000000) {
																	strVal = displayNumberFixedUnit(value, 'VAR', 'kVAR', 0);
																} else {
																	strVal = displayNumberFixedDecimal(value, 'VAR', 3, 2);
																}
															} else {
																strVal = ["-", ""];
															}
														} else {
														// Unit: W => kW,  Wh => kWh	
															strVal = displayNumberFixedUnit(value, 'W', 'kW', 0);
														}
														rowData[0][el.key] = strVal[0] + " " + strVal[1];
													} else if( el.key.match('accumActiveEnergy') ){
														// Unit: Wh => MWh
														// Unit: Wh => kWh:(round), Wh, MWh, GWh
														let rounded = Math.round(value);
														if(rounded >= 1000 && rounded < 1000000){
															let tempVal = displayNumberFixedUnit(value, 'Wh', "kWh", 0);
															rowData[0][el.key] = tempVal[0] + ' ' + tempVal[1];
														} else {
															let tempVal = displayNumberFixedDecimal(value, 'Wh', 3, 2);
															rowData[0][el.key] = tempVal[0] + ' ' + tempVal[1];
														}
													} else if(el.suffix.match('%') || el.key.match('temperature') || el.key.match("irradiationPoa") ) {
														// Unit: percentage, celsius, meter square
														rowData[0][el.key] = displayNumberFixedDecimal(value, el.suffix, 3, 2)[0] + " " + el.suffix;
													}  else {
														rowData[0][el.key] = value;
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
								let textValue = element.value;
								let suffix = element.suffix;
								if(textValue != '-' && !isEmpty(textValue)) {
									if(element.reducer == 'avg') {
										textValue = (textValue / element.cnt);
									}
									if(!isEmpty(suffix)) {
										if(key.match("accumActiveEnergy")) {
											// Unit: Wh => kWh:(round), Wh, MWh, GWh
											let rounded = Math.round(textValue);
											if(rounded >= 1000 && rounded < 1000000){
												textValue = displayNumberFixedUnit(textValue, 'Wh', "kWh", 0);
											} else {
												textValue = displayNumberFixedDecimal(textValue, 'Wh', 3, 2);
											}
										} else if(key.match("temperature")){
											let tempVal = displayNumberFixedDecimal(textValue, suffix, 3, 2);
											textValue = [tempVal[0], "&#8451;"];
										} else if(key.match("humidity")){
											let tempVal = displayNumberFixedDecimal(textValue, suffix, 3, 2);
											textValue = [tempVal[0], "&#37;"];
										} else {
											if(suffix == "W" || suffix == "Wh"){
												textValue = displayNumberFixedUnit(textValue, "W", "kW", 0);
											} else {
												textValue = displayNumberFixedDecimal(textValue, suffix, 3, 2);
											}
										}
									} else {
										textValue = [textValue, ""];
									}
									$('#typeList').find('.' + deviceType).find('.table-type td.' + key + ' span:nth-child(1)').html(textValue[0] + " " +  textValue[1]);
								} else {
									$('#typeList').find('.' + deviceType).find('.table-type td.' + key + ' span:nth-child(1)').html("-");
								}

							});
						});				

						let deviceCnt = tableArray.length;

						$('#typeList').find('.' + dvcType).find('.ntit span').html(deviceCnt);
						$('#typeList').find('.' + dvcType).find('.alert-icon .inv-normal span').html(operationNormal);
						$('#typeList').find('.' + dvcType).find('.alert-icon .inv-error span').html(operationError);
						$('#typeList').find('.' + dvcType).find('.alert-icon .inv-alert span').html(operationAlert);
						setMakeList(tableArray, 'table_' + dvcType, {'dataFunction': {'operation': setOperation}});
					});
					$("#loadingCircle").hide();
				} else {
					// #2 solar Dashboard
					let invType = [];
					let sortedData;
					let seriesLength = hourlyINVChart.series.length;
					let deviceLength = 0;

					if(seriesLength>0){
						for(let i = seriesLength -1; i > -1; i--) {
							hourlyINVChart.series[i].remove();
						}
					}

					if(!isEmpty(data) && Object.values(data)){
						sortedData = Object.values(data).filter( x => x.data.length>0 );
						sortedData.sortOn("dname");
						let found = sortedData.findIndex( x => x.device_type == "INV_PV");
					}

					$.map(sortedData, function(val, index) {
						if (val.device_type == "INV_PV"){
							deviceLength += 1;
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

							if ($.inArray(val.device_type, invType) === -1) {
								invType.push(val.device_type);
							}
							
							$.ajax(hourlyINV).done(function (json, textStatus, jqXHR) {
								let result = Object.values(json.data).flat().filter( x => x.metering_type ===2);
								
								if(!isEmpty(result) && result[0].items.length>0){
									let temp = result[0].items;
								
									let colorArr = [
										"var(--powder-blue)",
										"var(--turquoise)",
										"var(--teal)",
										"var(--light-blue)",
										"var(--blueberry)",
										"var(--royal-blue)",
										"var(--blue-yonder)",
										"var(--circle-solar-power)",
										"var(--deep-lilac)",
										"var(--yellow-green)",
										"var(--green)",
										"var(--eucalyptus)",
										"var(--french-pass)",
										"var(--malibu)",
										"var(--vivid-blue)",
									];

									let hourList = [...Array(24)].map((item, index) => {
										let found = temp.findIndex( x => {
											let baseTime = String(x.basetime).substring(8, 10);
											if(baseTime == index) return Number(baseTime);
										});

										if(found > -1){
											return temp[found].energy ? temp[found].energy/1000 : 0;
										} else {
											return null;
										}
									});

									hourlyINVChart.addSeries({
										name: val.dname,
										index: index,
										type: 'column',
										color: (deviceLength == 1 ) ? colorArr[1] : colorArr[index],
										tooltip: {
											valueSuffix: "kWh",
										},
										marker: {
											symbol: "circle"
										},
										data: hourList,
										plotOptions: {
											pointStart: 10,
										}
									});
								}

							}).fail(function (jqXHR, textStatus, errorThrown) {
								console.error("fail==", jqXHR)
							});
						}
					});

					if(deviceLength >= 10){
						hourlyINVChart.update({
							// legend: {
							// 	marginBottom: 80
							// 	// marginTop: 80
							// },
							chart: {
								marginTop: 80
							}
						});
						hourlyINVChart.isDirtyLegend = true;
						hourlyINVChart.isDirtyBox = true;
						hourlyINVChart.redraw();
					} else {
						hourlyINVChart.isDirtyBox = true;
						hourlyINVChart.redraw();
					}

					$.each(invType, function (i, el) {
						invType[i] = {
							name: featureProperties[el].name,
							type: el,
							head: featureProperties[el].prop,
							body: {
								type: el + '2',
								prop: featurePropertiesSub[el].prop
							}
						}								
					});

					setMakeList(invType, 'invList', { 'dataFunction': { 'head': makeHeadTable, 'body': makeBodyTable } });

					$.each(invType, function (i, el) {
						let newInvType = el.type;
						let operationNormal = 0;
						let operationError = 0;
						let operationAlert = 0;
						let headerDataObject = {};

						setInitList('table_' + newInvType + '2');

						let tableArray = [];

						$.map(sortedData, function(val, key) {
							let dname = val.dname;
							if (val.device_type == newInvType) {
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
										let headerData = {};
										if(!isEmpty(headerDataObject[key])) {
											headerData = headerDataObject[key];
										}
										if (key == newInvType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key];
												let tempObj = {};
												if(isEmpty(headerData[el.key])) {
													tempObj['reducer'] = el.reducer;
												} else {
													tempObj = headerData[el.key];
												}

												if(isEmpty(value)) {
													value = '-';
												} else {
													let unitList = ['W', 'Wh', 'irradiationPoa', 'temperature', '%', 'V'];
													if(unitList.indexOf(el.suffix) > -1){
														value = Number(value);
													}
												}
												if(value == '-') {
													if(!isEmpty(headerData[el.key])) {
														tempObj['cnt'] = Number(tempObj['cnt']) + 1;
													} else {
														tempObj['value'] = '-';
														tempObj['cnt'] = 1;
													}
												} else {
													if(!isEmpty(headerData[el.key])) {
														if(value != '-') {
															tempObj['value'] =  Number(value) + Number(tempObj['value']);
														} else {
															tempObj['value'] = value;
														}
														tempObj['cnt'] = Number(tempObj['cnt']) + 1;
													} else {
														if(value != '-') {
															tempObj['value'] = Number(value);
														}
														tempObj['cnt'] = 1;
													}
													tempObj['suffix'] = el.suffix;
												}
												headerData[el.key] = tempObj;
											});
											headerDataObject[key] = headerData;
										}
									});

									$.map(featurePropertiesSub, function(val, key) {
										if (key == newInvType) {
											$.each(val.prop, function(i, el) {
												let value = rowData[0][el.key];

												if(isEmpty(value)) {
													rowData[0][el.key] = '-';
												} else {
													if( el.key.match('activePower') || el.key.match('dcPower') ) {
														let strVal = "";
														
														if(el.key.startsWith("reactive")){
															// console.log("el.key11111==", el.key, "value===", value)
															// Unit: Var => kVAR, mVAR, gVAR, tVAR)
															if(!isEmpty(value)) {
																if(value < 1000) {
																	strVal = (value % 1 === 0) ? [value, "VAR"] : displayNumberFixedDecimal(value, 'VAR', 3, 2);
																} else if(value >= 1000 && value < 1000000) {
																	strVal = displayNumberFixedUnit(value, 'VAR', 'kVAR', 0);
																} else {
																	strVal = displayNumberFixedDecimal(value, 'VAR', 3, 2);
																}
															} else {
																strVal = ["-", ""];
															}
														} else {
														// Unit: W => kW,  Wh => kWh
															strVal = displayNumberFixedUnit(value, 'W', 'kW', 0);
														}
														rowData[0][el.key] = strVal[0] + " " + strVal[1];
													} else if( el.key.match('accumActiveEnergy') ){
														// Unit: Wh => kWh:(round), Wh, MWh, GWh
														let rounded = Math.round(value);

														if(rounded >= 1000 && rounded < 1000000){
															let tempVal = displayNumberFixedUnit(value, 'Wh', "kWh", 0);
															rowData[0][el.key] = tempVal[0] + ' ' + tempVal[1];
														} else {
															let tempVal = displayNumberFixedDecimal(value, 'Wh', 3, 2);
															rowData[0][el.key] = tempVal[0] + ' ' + tempVal[1];
														}
													} else if(el.suffix.match('%') || el.key.match('temperature') || el.key.match("irradiationPoa") ) {
														// Unit: percentage, celsius, meter square
														rowData[0][el.key] = displayNumberFixedDecimal(value, el.suffix, 3, 2)[0] + " " + el.suffix;
													} else {
														rowData[0][el.key] = value;
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

						let invItem = $('#invList .INV_PV');

						$.map(headerDataObject, function(el, device) {
							$.map(el, function(element, key) {
								let textValue = element.value;
								let suffix = element.suffix;
								if(textValue != '-' && !isEmpty(textValue) ) {
									if(element.reducer == 'avg') {
										textValue =  textValue / element.cnt;
									}
									if(!isEmpty(suffix)) {
										if(key.match("accumActiveEnergy")) {
											// Unit: Wh => kWh:(round), Wh, MWh, GWh
											let rounded = Math.round(textValue);
											if(rounded >= 1000 && rounded < 1000000){
												textValue = displayNumberFixedUnit(textValue, 'Wh', "kWh", 0);
											} else {
												textValue = displayNumberFixedDecimal(textValue, 'Wh', 3, 2);
											}
										} else {
											if(suffix == "W" || suffix == "Wh"){
												textValue = displayNumberFixedUnit(textValue, "W", "kW", 0);
											} else {
												if(!isEmpty(textValue)){
													textValue = displayNumberFixedDecimal(textValue, suffix, 3, 2);
												}
											}
										}
									} else {
										textValue = [textValue, ""];
									}
									invItem.find('.table-type td.' + key + ' span:nth-child(1)').html(textValue[0] + " " +  textValue[1]);
								} else {
									invItem.find('.table-type td.' + key + ' span:nth-child(1)').html("-");
									invItem.find('.table-type td.' + key + ' span:nth-child(2)').html("-");
								}

							});
						});

						let deviceCnt = tableArray.length;
						let tableName = 'table_' + newInvType + '2';

						invItem.find('.ntit span').html(deviceCnt);
						invItem.find('.alert-icon .inv-normal span').html(operationNormal);
						invItem.find('.alert-icon .inv-error span').html(operationError);
						invItem.find('.alert-icon .inv-alert span').html(operationAlert);

						setMakeList(tableArray, tableName , {'dataFunction': {'operation': setOperation}});
					});

				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				let errMsg = "<fmt:message key='smain.error.1' /> <br/><fmt:message key='smain.error.2' />" + errorThrown;
				let r = formatErrorMessage(jqXHR, errorThrown);
				console.log("error===", r);
				$("#errMsg").html(errMsg);
				$("#errorModal").modal("show");
				setTimeout(function(){
					$("#errorModal").modal("hide");
				}, 2000);
				return false;
			});
		}
	}

	function deviceSearch(dname, operation) {
		let searchBoolean = true;
		let	keyboard = $('input[name="keyword"]').val().trim();

		const deviceStatusArray = $.makeArray(
			$(':checkbox[name="deviceStatus"]:checked').map(
				function () {
					return $(this).val();
				}
			)
		);

		if (keyboard != '') {
			if(dname.toUpperCase().match(keyboard.toUpperCase())) {
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

	function setOperation(operation) {
		let rtnText = '';
		if (operation == '1') {
			rtnText = '<fmt:message key="smain.normal" />'; // 정상
		} else if (operation == '2') {
			rtnText = '<fmt:message key="smain.trip" />'; // 트립
		} else {
			rtnText = '<fmt:message key="smain.stop" />'; // 중지
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

	function chargeChartPoll(option, duration) {
		const formData = getSiteMainSchCollection('year');
		const monthFormData = getSiteMainSchCollection('month');
		const beforeYearFormData = getSiteMainSchCollection('beforeYear');


		$('#monthlyDate').text(((formData.startTime).substr(0, 8)).replace(/(\d{4})(\d{2})(\d{2})/, '$1.$2.$3') + ' ~ ' + (new Date()).format('yyyy.MM.dd'));

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
					let chartItems1 = [];
					let chartItems2 = [];

					// ONLY 1 site => Object.keys(monthlyData[0]).length === 1
					if (monthlyData[1] == 'success') {
						let v = Object.values(monthlyData[0].data).flat();
						if (!isEmpty(v) && v[0]["items"].length > 0) {
							v.filter( item => item.metering_type == "2").map( (item, index) => { return chartItems1 = item.items }).flat();
						}
					}

					if (currentMonthData[1] == 'success') {
						let resultNow = currentMonthData[0].data[siteId];
						chartItems1.push({
							basetime: monthFormData.startTime,
							energy: isEmpty(resultNow.energy) ? 0 : resultNow.energy,
							money: isEmpty(resultNow.money) ? 0 : Math.floor(resultNow.money / 1000)
						});
					}
					
					if (prevYearData[1] == 'success') {
						chartItems2 = prevYearData[0];
					}
					setChargeChartData(chartItems1, chartItems2);

				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.error('error');
				});
			} else {
				// A. radio option
				if ($(':radio[name="radio_t"]:checked').val() == 1) {
					$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear), $.ajax(weather)).done(function (monthlyData, currentMonthData, prevYearData, weatherData) {
						let chartItems1 = [];
						let chartItems2 = [];
						let chartItems3 = [];
						let capacity = 0;

						if (monthlyData[1] == 'success') {
							let v = Object.values(monthlyData[0].data).flat();
							if (!isEmpty(v) && v[0]["items"].length > 0) {
								v.filter( item => item.metering_type == "2").map( (item, index) => { return chartItems1 = item.items }).flat();
							}
						}

						if (currentMonthData[1] == 'success') {
							let resultNow = currentMonthData[0].data[siteId];
							chartItems1.push({
								basetime: Number(monthFormData.startTime),
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
						console.error('rejected');
					});
				} else {
				// B.C. radio option
					$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear)).done(function (monthlyData, currentMonthData, prevYearData) {
						let chartItems1 = [];
						let chartItems2 = [];

						if (monthlyData[1] == 'success') {
							let resultData = monthlyData[0].data;
							let targetData;

							if (!isEmpty(resultData)){
								Object.values(resultData).forEach( x => {
									for(let i = 0, arrLength = x.length; i<arrLength; i++){
										if(x[i].metering_type == "2"){
											targetData = x[i].items;
											break;
										}
									}
								});
				
								if(!isEmpty(targetData)){
									if (targetData.length > 0) {
										chartItems1 = targetData;
										chartItems1.forEach(el => {
											if (!isEmpty(el.money)) {
												el.money = Math.floor(el.money / 1000);
											}
										});
									}
								}

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
						console.error('rejected');
					});
				
				}
			}
		} else {
			let d = new Date();
			let startOfDay = new Date().format('yyyyMMdd000001');
			let yesterday = getSiteMainSchCollection('yesterday');
			let dailyEnergy = {};
			let dailyEnergyToday = {};
			let dailyWeather = {};
			let dailyWeatherToday = {};

			if(!isEmpty(duration)) {
				let userDefinedDay;
				if(duration === "datepicker"){

				// datePicker
					userDefinedDay = $("#fromDate").datepicker('getDate');
					userDefinedDay.format('yyyyMMdd') + '000000';
					let toDate = $('#toDate').datepicker('getDate');
					let dateDiff = (toDate.getTime() - userDefinedDay.getTime() ) / (1000 * 3600 * 24);
					
					dailyEnergy = {
						url: apiHost + apiEnergySite,
						type: 'get',
						dataType: 'json',
						data: {
							sid: siteId,
							startTime: userDefinedDay.format("yyyyMMdd") + '000000',
							endTime: toDate.format("yyyyMMdd") + '235959',
							interval: 'day',
							// displayType: 'dashboard',
							formId: 'v2'
						}
					}

					dailyWeather = {
						url: apiHost + apiWeather,
						type: 'get',
						dataType: 'json',
						data: {
							sid: siteId,
							startTime: userDefinedDay.format("yyyyMMddHHmmss"),
							endTime: yesterday.endTime,
							interval: 'day',
						}
					}
					
					if(toDate.format("yyyyMMdd") == d.format("yyyyMMdd") ){
					// if last day is today
						dailyEnergyToday = {
							url: apiHost + apiEnergySite,
							type: 'get',
							dataType: 'json',
							data: {
								sid: siteId,
								startTime: startOfDay,
								endTime: d.format("yyyyMMddHHmmss"),
								interval: 'hour',
								formId: 'v2'
							}
						}

						dailyWeatherToday = {
							url: apiHost + apiWeather,
							type: 'get',
							dataType: 'json',
							data: {
								sid: siteId,
								startTime: startOfDay,
								endTime: d.format("yyyyMMddHHmmss"),
								interval: 'hour',
							}
						}

				
						$.when( $.ajax(dailyWeather), $.ajax(dailyWeatherToday), $.ajax(dailyEnergy), $.ajax(dailyEnergyToday))
						.done(function (result2A, result2B, result3A, result3B) {
							let chartItems1 = [];
							let chartItems2 = [];
							let chartItems3 = [];
							let flagDetail = [
								{ irrSensorFlag: "0" },
								{ energyFlag: "0" }
							];
							let customDateList = addToDateList(dateDiff+1);

							if(result2A[1] == 'success' && result2B[1] == 'success') {
								let tempIrrList = [];
								if(!isEmpty(result2A[0]) && result2A[0].length>0) {
									result2A[0].map((item, index) => {
										if(!isEmpty(item.sensor_solar.irradiationPoa)){
											tempIrrList.push(item);
											if(flagDetail[0].irrSensorFlag === "0"){
												flagDetail[0].irrSensorFlag = "1";
											}
										}
									});
								}

								if(!isEmpty(result2B[0]) && result2B[0].length>0) {
									let sumOfToday = 0;
									let lastIndex = result2B[0].length-1;

									result2B[0].map((item, index) => {
										if(!isEmpty(item.sensor_solar.irradiationPoa)){
											sumOfToday += item.sensor_solar.irradiationPoa;
										}
										if(index === lastIndex){
											let tempObj = item;
											tempObj.sensor_solar.irradiationPoa = Math.round(sumOfToday/(lastIndex+1));
											tempIrrList.push(tempObj);
										}
									});
								}
								chartItems2 = addToDateList((dateDiff+1), tempIrrList, "irradiationPoa", customDateList);
							}

							if(result3A[1] == 'success' && result3B[1] == 'success') {
								let result3aData = result3A[0].data;
								let result3bData = result3B[0].data;
								let v1 = Object.values(result3A[0].data).flat();
								let v2 = Object.values(result3B[0].data).flat();
				
								if (!isEmpty(v1) && v1[0]["items"].length > 0) {
									result3aData = v1.filter( item => item.metering_type == "2")[0].items;

									result3aData = result3aData.map( (item, index) => {
										!isEmpty(item.energy) ? item.energy = Math.round(item.energy / 1000): item.energy = 0;
										if(flagDetail[1].energyFlag == "0"){
											flagDetail[1].energyFlag = "1";
										}
										return item;
									});

									if (!isEmpty(v2) && v2[0]["items"].length > 0) {
										let sumOfToday = 0;
										let lastIndex = v2[0]["items"].length-1;
						
										result3bData = v2.filter( item => item.metering_type == "2")[0].items;
										result3bData.map( (item, index) => {
											sumOfToday += item.energy;
											if(index === lastIndex){
												let tempObj = item;
												tempObj.energy = Math.round(sumOfToday / 1000 );
												result3aData.push(tempObj);
											}
										});
									}
								
									chartItems3 = addToDateList((dateDiff+1), result3aData, "energy", customDateList);
								}
							}

							setChargeChartData(null, chartItems2, chartItems3, flagDetail, (dateDiff+1));
						}).fail(function () {
							console.error('rejected');
						});
					} else {
						$.when( $.ajax(dailyWeather), $.ajax(dailyEnergy))
						.done(function (result2, result3) {
							let chartItems2 = [];
							let chartItems3 = [];
							let flagDetail = [
								{ irrSensorFlag: "0" },
								{ energyFlag: "0" }
							];
							let customDateList = addToDateList(dateDiff+1);

							if(result2[1] == 'success') {
								let tempIrrList = [];
								if(!isEmpty(result2[0]) && result2[0].length>0) {
									result2[0].map((item, index) => {
										if(!isEmpty(item.sensor_solar.irradiationPoa)){
											tempIrrList.push(item);
											if(flagDetail[0].irrSensorFlag === "0"){
												flagDetail[0].irrSensorFlag = "1";
											}
										}
									});
								}
								chartItems2 = addToDateList((dateDiff+1), tempIrrList, "irradiationPoa", customDateList);
							}

							if(result3[1] == 'success') {
								let result3Data = result3[0].data;
								let v1 = Object.values(result3[0].data).flat();
				
								if (!isEmpty(v1) && v1[0]["items"].length > 0) {
									result3aData = v1.filter( item => item.metering_type == "2")[0].items;

									result3aData = result3aData.map( (item, index) => {
										!isEmpty(item.energy) ? item.energy = Math.round(item.energy / 1000): item.energy = 0;
										if(flagDetail[1].energyFlag == "0"){
											flagDetail[1].energyFlag = "1";
										}
										return item;
									});


									chartItems3 = addToDateList((dateDiff+1), result3Data, "energy", customDateList);
								}
							}

							
							setChargeChartData(null, chartItems2, chartItems3, flagDetail, (dateDiff+1));
						}).fail(function () {
							console.error('rejected');
						});
					}

				} else {
				// dropdown duration
					userDefinedDay = new Date(d.getTime() - (duration * 24 * 60 * 60 * 1000));
					userDefinedDay.setHours(0, 0, 0, 0);

					dailyEnergy = {
						url: apiHost + apiEnergySite,
						type: 'get',
						dataType: 'json',
						data: {
							sid: siteId,
							startTime: userDefinedDay.format("yyyyMMddHHmmss"),
							endTime: new Date().format("yyyyMMddHHmmss"),
							interval: 'day',
							// displayType: 'dashboard',
							formId: 'v2'
						}
					}

					dailyEnergyToday = {
						url: apiHost + apiEnergySite,
						type: 'get',
						dataType: 'json',
						data: {
							sid: siteId,
							startTime: startOfDay,
							endTime: d.format("yyyyMMddHHmmss"),
							interval: 'hour',
							formId: 'v2'
						}
					}

					dailyWeather = {
						url: apiHost + apiWeather,
						type: 'get',
						dataType: 'json',
						data: {
							sid: siteId,
							startTime: userDefinedDay.format("yyyyMMddHHmmss"),
							endTime: yesterday.endTime,
							interval: 'day',
						}
					}

					dailyWeatherToday = {
						url: apiHost + apiWeather,
						type: 'get',
						dataType: 'json',
						data: {
							sid: siteId,
							startTime: startOfDay,
							endTime: d.format("yyyyMMddHHmmss"),
							interval: 'hour',
						}
					}

					$.when( $.ajax(dailyWeather), $.ajax(dailyWeatherToday), $.ajax(dailyEnergy), $.ajax(dailyEnergyToday))
					.done(function (result2A, result2B, result3A, result3B) {
						let chartItems1 = [];
						let chartItems2 = [];
						let chartItems3 = [];
						let flagDetail = [
							{ irrSensorFlag: "0" },
							{ energyFlag: "0" }
						];
						let customDateList = addToDateList(duration+1);

						if(result2A[1] == 'success' && result2B[1] == 'success') {
							let tempIrrList = [];
							if(!isEmpty(result2A[0]) && result2A[0].length>0) {
								result2A[0].map((item, index) => {
									if(!isEmpty(item.sensor_solar.irradiationPoa)){
										tempIrrList.push(item);
										if(flagDetail[0].irrSensorFlag === "0"){
											flagDetail[0].irrSensorFlag = "1";
										}
									}
								});
							}

							if(!isEmpty(result2B[0]) && result2B[0].length>0) {
								let sumOfToday = 0;
								let lastIndex = result2B[0].length-1;

								result2B[0].map((item, index) => {
									if(!isEmpty(item.sensor_solar.irradiationPoa)){
										sumOfToday += item.sensor_solar.irradiationPoa;
									}
									if(index === lastIndex){
										let tempObj = item;
										tempObj.sensor_solar.irradiationPoa = Math.round(sumOfToday/(lastIndex+1));
										tempIrrList.push(tempObj);
									}
								});
							}
							chartItems2 = addToDateList((duration+1), tempIrrList, "irradiationPoa", customDateList);
						}

						if(result3A[1] == 'success' && result3B[1] == 'success') {
							let result3aData = result3A[0].data;
							let result3bData = result3B[0].data;
							let v1 = Object.values(result3A[0].data).flat();
							let v2 = Object.values(result3B[0].data).flat();
			
							if (!isEmpty(v1) && v1[0]["items"].length > 0) {
								result3aData = v1.filter( item => item.metering_type == "2")[0].items;

								result3aData = result3aData.map( (item, index) => {
									!isEmpty(item.energy) ? item.energy = Math.round(item.energy / 1000): item.energy = 0;
									if(flagDetail[1].energyFlag == "0"){
										flagDetail[1].energyFlag = "1";
									}
									return item;
								});

								if (!isEmpty(v2) && v2[0]["items"].length > 0) {
									let sumOfToday = 0;
									let lastIndex = v2[0]["items"].length-1;
					
									result3bData = v2.filter( item => item.metering_type == "2")[0].items;
									result3bData.map( (item, index) => {
										sumOfToday += item.energy;
										if(index === lastIndex){
											let tempObj = item;
											tempObj.energy = Math.round(sumOfToday / 1000 );
											result3aData.push(tempObj);
										}
									});
								}

								chartItems3 = addToDateList((duration+1), result3aData, "energy", customDateList);
							}
						}

						
						setChargeChartData(null, chartItems2, chartItems3, flagDetail, (duration+1));
					}).fail(function () {
						console.error('rejected');
					});
				}

			} else {
				// console.log("no element")
				let monthAgo = new Date(d.getTime() - (30 * 24 * 60 * 60 * 1000));
				monthAgo.setHours(0, 0, 0, 0);

				$('#fromDate').datepicker('setDate', '-30' );
				$('#toDate').datepicker('setDate', 'today').datepicker('option', 'maxDate', 0);
				dailyEnergy = {
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

				dailyEnergyToday = {
					url: apiHost + apiEnergySite,
					type: 'get',
					dataType: 'json',
					data: {
						sid: siteId,
						startTime: startOfDay,
						endTime: d.format("yyyyMMddHHmmss"),
						interval: 'hour',
						formId: 'v2'
					}
				}

				dailyWeather = {
					url: apiHost + apiWeather,
					type: 'get',
					dataType: 'json',
					data: {
						sid: siteId,
						startTime: monthAgo.format("yyyyMMddHHmmss"),
						endTime: yesterday.endTime,
						interval: 'day',
					}
				}

				dailyWeatherToday = {
					url: apiHost + apiWeather,
					type: 'get',
					dataType: 'json',
					data: {
						sid: siteId,
						startTime: startOfDay,
						endTime: d.format("yyyyMMddHHmmss"),
						interval: 'hour',
					}
				}

				$.when( $.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(dailyWeather), $.ajax(dailyWeatherToday), $.ajax(dailyEnergy), $.ajax(dailyEnergyToday))
				.done(function (result1A, result1B, result2A, result2B, result3A, result3B) {
					let el = $("#solarDashboard .mini .data-num");
					let chartItems1 = [];
					let chartItems2 = [];
					let chartItems3 = [];

					if(result1A[1] == 'success') {
						let v = Object.values(result1A[0].data).flat();
						if(!isEmpty(v) && v[0]["items"].length > 0) {
							v.filter( item => item.metering_type == "2").map( (item, index) => { return chartItems1 = item.items }).flat();
						}
						
						if(chartItems1.length > 0) {
							let initData = 0;
							chartItems1.forEach((item, index) => {
								initData += item.energy;
								chartItems1[index].money = Math.floor(item.money / 1000);
							});
							let monthGen = displayNumberFixedUnit(initData, 'Wh', 'MWh', 1);

							el.eq(4).text(monthGen[0]);
							el.eq(4).next().text(monthGen[1]);
						} else {
							el.eq(4).text("-");
							chartItems1 = null;
						}

					} else {
						el.eq(4).text("-");
					}

					if(result1B[1] == 'success') {
						let resultNow = result1B[0].data[siteId];
						if(!isEmpty(chartItems1)){
							chartItems1.push({
								basetime: monthFormData.startTime,
								energy: resultNow.energy,
								money: Math.floor(resultNow.money / 1000)
							});
						}
					}

					let flagDetail = [
						{ irrSensorFlag: "0" },
						{ energyFlag: "0" }
					];

					if(result2A[1] == 'success' && result2B[1] == 'success') {
						let tempIrrList = [];
						if(!isEmpty(result2A[0]) && result2A[0].length>0) {
							result2A[0].map((item, index) => {
								if(!isEmpty(item.sensor_solar.irradiationPoa)){
									tempIrrList.push(item);
									if(flagDetail[0].irrSensorFlag === "0"){
										flagDetail[0].irrSensorFlag = "1";
									}
								}
							});
						}

						if(!isEmpty(result2B[0]) && result2B[0].length>0) {
							let sumOfToday = 0;
							let lastIndex = result2B[0].length-1;

							result2B[0].map((item, index) => {
								if(!isEmpty(item.sensor_solar.irradiationPoa)){
									sumOfToday += item.sensor_solar.irradiationPoa;
								}
								if(index === lastIndex){
									let tempObj = item;
									tempObj.sensor_solar.irradiationPoa = Math.round(sumOfToday/(lastIndex+1));
									tempIrrList.push(tempObj);
								}
							});
						}
						chartItems2 = addToDateList(31, tempIrrList, "irradiationPoa");
					}

					if(result3A[1] == 'success' && result3B[1] == 'success') {
						let result3aData = result3A[0].data;
						let result3bData = result3B[0].data;
						let v1 = Object.values(result3A[0].data).flat();
						let v2 = Object.values(result3B[0].data).flat();
		
						if (!isEmpty(v1) && v1[0]["items"].length > 0) {
							result3aData = v1.filter( item => item.metering_type == "2")[0].items;

							result3aData = result3aData.map( (item, index) => {
								!isEmpty(item.energy) ? (item.energy = Math.round(item.energy / 1000)) : (item.energy = 0);
								if(flagDetail[1].energyFlag == "0"){
									flagDetail[1].energyFlag = "1";
								}
								return item;
							});

							if (!isEmpty(v2) && v2[0]["items"].length > 0) {
								let sumOfToday = 0;
								let lastIndex = v2[0]["items"].length-1;
				
								result3bData = v2.filter( item => item.metering_type == "2")[0].items;
								result3bData.map( (item, index) => {
									sumOfToday += item.energy;
									if(index === lastIndex){
										let tempObj = item;
										tempObj.energy = Math.round(sumOfToday / 1000 );
										result3aData.push(tempObj);
									}
								});
							}
							chartItems3 = addToDateList(31, result3aData, "energy");
						}
					}
					setChargeChartData(chartItems1, chartItems2, chartItems3, flagDetail);
				}).fail(function () {
					console.error('rejected');
				});
			}

		}
	}

	function setChargeChartData(chartItems1, chartItems2, chartItems3, flagDetail, searchOption) {
		const today = new Date();
		const nowMonth = today.getMonth() + 1;

		let itemChartCapacity = 0;
		let totalYearEnergy = 0;
		let totalMonthEnergy = 0;
		let totalPrevYearEnergy = 0;
		let totalPrevMonthEnergy = 0;
		let energyData = [];
		let energyMaxVal = 0;
		let irradiationData = [];
		let billingData = [];

		if (isEmpty(flagDetail)) {		
			sList.forEach(site => {
				if (site.devices != undefined) {
					site.devices.forEach(device => { 
						itemChartCapacity += device.capacity;
					});
				}
			});
			itemChartCapacity = Math.round(itemChartCapacity / 100) / 10;

			for (let i = 0; i < 12; i++) {	
				let matchMonth = false;
				if (!isEmpty(chartItems1)) {
					for (let d = 0, arrLength = chartItems1.length; d < arrLength; d++) {
						let dataMonth = parseInt(String(chartItems1[d].basetime).substring(4, 6));
						if (i + 1 == dataMonth) {
							energyData[i] = [i, chartItems1[d].energy/1000];
							if(chartItems1[d].energy/1000 > energyMaxVal ){
								energyMaxVal = chartItems1[d].energy/1000;
							}
							if (!oid.match('testkpx')) {
								if ($(':radio[name="radio_t"]:checked').val() == 1) {
								// 1. PR 발전량
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
								} else if ($(':radio[name="radio_t"]:checked').val() == 2) {
								// 2. 발전 시간
									let today = new Date();
									let lastDate = new Date(today.getFullYear(), dataMonth, 0).format('dd');

									if (today.getMonth() == (Number(dataMonth) - 1)) {
										lastDate = today.getDate();
									}
									let energy = chartItems1[d].energy / 1000;
									let tempAver = (energy / itemChartCapacity / lastDate).toFixed(2);

									billingData[i] = [i, parseFloat(tempAver)];
								} else {
								// 3. 매전량
									billingData[i] = [i, chartItems1[d].money];
								}
							}

							totalYearEnergy += chartItems1[d].energy / 1000;
							
							if (i + 1 == nowMonth) {
								totalMonthEnergy = chartItems1[d].energy / 1000;
								if(!isEmpty(chartItems1[d].energy) && itemChartCapacity>0){
									let monthlyGenHr = String(Math.round(totalMonthEnergy / itemChartCapacity / today.getDate() * 100) / 100);
									$('#monthGenHours').html('<span class="pv">' + monthlyGenHr  + '</span><em>hrs</em>');
								} else {
									monthlyGenHr = "-";
									$('#monthGenHours').html('<span class="pv">-</span>');
								}
							}
							matchMonth = true;
						}
					}
				}
					
				if (!matchMonth) {
					energyData[i] = [i, null];
					billingData[i] = [i, null];
				}
				
				for (let d = 0, dLength = chartItems2.length; d < dLength; d++) {
					let dataMonth = parseInt(("" + chartItems2[i].basetime).substring(4, 6));
					let energyData = chartData2[d].energy / 1000;
					// console.log("dataMonth===", dataMonth)
					if (i + 1 == dataMonth) {
						totalPrevYearEnergy += energyData;

						if (i + 1 == nowMonth) {
							totalPrevMonthEnergy = energyData;
						}
					}
				}
			}

			monthlyChart.series[0].setData(energyData);

			if (!oid.match('testkpx')) {
				let seriesName = '';
				let newSuffix = '';
				
				monthlyChart.series[1].setData(billingData);

	
				if ($(':radio[name="radio_t"]:checked').val() == 1) {
					seriesName = 'PR';
					newSuffix = '%';

					monthlyChart.update({
						yAxis: [
							{
								title: {
									text: displayNumberFixedDecimal(energyMaxVal, 'kWh', 3, 2)[1],
									x: 10
									
								}
							},
							{
								title:{ 
									text: newSuffix,
									x: -15
								}
							}
						],
						legend: { x: 15 }
					});
				} else if ($(':radio[name="radio_t"]:checked').val() == 2) {
					seriesName = '<fmt:message key="smain.todayDevTime" />';
					newSuffix = 'hr';
					monthlyChart.update({
						yAxis: [
							{
								title: {
									text: displayNumberFixedDecimal(energyMaxVal, 'kWh', 3, 2)[1],
									x: 10
								},
							},
							{
								title: {
									text: newSuffix,
									x: -15
								},
							}
						],
						legend: {
							x: 15,
						}
					});
				} else {
					seriesName = '<fmt:message key="smain.sales" />';
					newSuffix = '<fmt:message key="smain.1000won" />';

					monthlyChart.update({
						yAxis: [{
							title: {
								text: displayNumberFixedDecimal(energyMaxVal, 'kWh', 3, 2)[1]
							}
						}, {
							title: {
								text: newSuffix,
								x: -15,
							},
						}],
						legend: {
							x: 0,
						}
					});
				}

				monthlyChart.series[1].update({
					name: seriesName,
					tooltip: {
						valueSuffix: newSuffix,
					}
				});

				monthlyChart.redraw();

			} else {
				monthlyChart.update({
					chart: {
						marginRight: 10,
					},
					legend: {
						x: 10
					},
					yAxis: [{
						title: {
							x: 7,
							text: displayNumberFixedDecimal(energyMaxVal, 'kWh', 3, 2)[1]
						}
					}]
				});

				monthlyChart.redraw();
			}
		} else {
			// let newDailyChart = $('#monthlyChart').highcharts();
			let dailySolarMaxVal = 0;
			let dailyInvMaxVal = 0;
			let trendChartLength = dailySolarTrendChart.series.length;
			let targetDate;
			let startDate;
			let d = new Date();

			dailySolarMaxVal =  Math.max(...chartItems3);
			dailyInvMaxVal =  Math.max(...chartItems2);

			if(trendChartLength>0){
				for(let i = trendChartLength -1; i > -1; i--) {
					dailySolarTrendChart.series[i].remove();
				}
			}

			if(!isEmpty(searchOption)){
				targetDate = new Date(d.getTime() - ((searchOption-1) * 24 * 60 * 60 * 1000));
				startDate = Date.UTC(targetDate.getFullYear(), targetDate.getMonth() , targetDate.getDate());
			} else {
				targetDate = new Date(d.getTime() - (30 * 24 * 60 * 60 * 1000));
				startDate = Date.UTC(targetDate.getFullYear(), targetDate.getMonth() , targetDate.getDate());
			}

			dailySolarTrendChart.addSeries({
				name: '<fmt:message key="smain.generation" />',
				type: 'column',
				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: chartItems3,
				pointStart: startDate,
				pointInterval: (24 * 60 * 60 * 1000)
			});

			dailySolarTrendChart.addSeries({
				name: '<fmt:message key="smain.irradiance" />',
				type: 'spline',
				yAxis: 1,
				dashStyle: 'ShortDash',
				color: 'var(--white60)',
				tooltip: {
					valueSuffix: 'W/m\xB2',
				},
				marker: {
					symbol: "circle"
				},
				data: chartItems2,
				pointStart: startDate,
				pointInterval: (24 * 60 * 60 * 1000)
			});

			// let formattedDate31List = addToDateList(31, null, "date");
			// console.log("formattedDate31List===", formattedDate31List);
			
			dailySolarTrendChart.update({
				yAxis: [
					{
						title:{ text: "kWh" },
						// max: dailySolarMaxVal
					},
					{
						title:{ text: "W/m\xB2" },
						// max: dailyInvMaxVal
					},
				],
				// plotOptions: {
				// 	series: {
				// 		pointStart: startDate,
				// 		pointInterval: 24 * 60 * 60 * 1000
				// 	}
				// },

			});

			dailySolarTrendChart.isDirtyBox = true;
			dailySolarTrendChart.redraw();
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
				interval: 'day',
				formId: 'v2'
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
			let v = Object.values(dailyEnergyData[0].data);
			let energyItems;
			let weatherItems = dailyWeatherData[0];
			let calendarDays = $('.calWeatherDay');

			// console.log("dailyEnergyData===", v);
			if (!isEmpty(v) &&  v.flat()[0]["items"].length > 0) {
				energyItems = v.flat()[0]["items"];
			} else {
				energyItems = null;
			}

			for (let i = 1; i <= calendarDays.length; i++) {
				if (!isEmpty(energyItems) && energyItems.length > 0) {
					energyItems.forEach(el => {
						let dataDay = parseInt(String(el.basetime).substring(6, 8));
						if (i == dataDay) {
							let energyText;
							let rounded = Math.round(el.energy);
							if(rounded >= 1000 && rounded < 1000000){
								energyText = displayNumberFixedDecimal(el.energy, 'Wh', 3, 0);
							} else {
								energyText = displayNumberFixedDecimal(el.energy, 'Wh', 3, 1);
							}
							$('#calEnergyValue_' + i).html('<strong>' + energyText[0] + '</strong><em>' + energyText[1] + '</em>');
						}
					});
				} else {
					$('#calEnergyValue_' + i).html('<strong>-</strong>');
				}

				if (weatherItems.length > 0) {
					weatherItems.forEach((el, index) => {
						// console.log("weatherItems===", el)
						let dataDay = parseInt(String(el.basetime).substring(6, 8));
						if (i == dataDay) {
							$('#calWeatherValue_' + i).html( Math.round(el.temperature) + '&#8451;&nbsp;');

							let weatherIconClass = getWeatherIcons(el.sky);
							$('#calWeatherIcon_' + i).html('<i class="ico-weather ' + weatherIconClass + '"></i>');
						}
					});
				}
			}
		}).fail(function () {
			console.error('rejected');
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
				let rounded = Math.round(data.data[siteId].energy);
				let energyText;

				if(rounded >= 1000 && rounded < 1000000){
					energyText = displayNumberFixedDecimal(data.data[siteId].energy, 'Wh', 3, 0);
				} else {
					energyText = displayNumberFixedDecimal(data.data[siteId].energy, 'Wh', 3, 1);
				}
				
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
		let urls = [];
		let deferredList = [];

		if(oid.match('testkpx')) {
			$('#centerTbody tr td:nth-child(1)').html('<em>&nbsp;kW</em>');
			$('#centerTbody tr td:nth-child(2)').html('<em>&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(3)').html('<em>&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(4)').html('<em>&nbsp;H</em>');
		} else {
			$('#centerTbody tr td:nth-child(1)').html('<em>&nbsp;kW</em>');
			$('#centerTbody tr td:nth-child(2)').html('<em>&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(3)').html('<em>&nbsp;H</em>');
			$('#centerTbody tr td:nth-child(4)').html('<em>&nbsp;kWh</em>');
		}

		if(isEmpty(option)){
			if (oid.match('testkpx')) {
				urls.push({
					url: apiHost + apiStatusRawSite,
					type: 'GET',
					data: {
						sid: siteId,
						formId: 'v2'
					}
				});

				let rtus = [];
				sList.forEach(site => {
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
						formId: 'v2'
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
				let dids = new Array();
				if (!isEmpty(sList[0].devices)) {
					sList[0].devices.forEach(device => {
						if (device.dashboard === true && device.metering_type === 2) {
							dids.push(device.did);
						}
					});
				}

				urls.push({
					url: apiHost + apiStatusRaw,
					type: 'GET',
					data: {
						dids: dids.toString()
					}
				});

				urls.push({
					url: apiHost + apiEnergyNowSite,
					type: 'GET',
					data: {
						sids: siteId,
						metering_type: 2,
						interval: 'day',
						formId: 'v2'
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

			//ajax 한번에 실행
			deferredList = [];
			urls.forEach(function (url) {
				let deferred = $.Deferred();
				deferredList.push(deferred);

				$.ajax(url).done(function (data) {
					data['url'] = url['url'];
					(function (deferred) {
						return deferred.resolve(data);
					})(deferred);
				}).fail(function (error) {
					console.error(error);
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

					if ((url).match(apiStatusRaw) || (url).match(apiStatusRawSite)) {
						// url : apiStatusRawSite
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
										itemCapacity = deviceData.capacity ? deviceData.capacity : 0;
										itemAcPower = deviceData.activePower ? deviceData.activePower : 0;
										if (!isEmpty(lastTargetActivePowerReqDate)) {
											let historyData = new Date(lastTargetActivePowerReqDate.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
											let statusDate = new Date(String(deviceData.lastTargetActivePowerReqDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
											if (statusDate.getTime() > historyData.getTime()) {
												lastTargetActivePowerReqDate = String(deviceData.lastTargetActivePowerReqDate);
												lastTargetActivePowerRecvDate = String(deviceData.lastTargetActivePowerReqDate);
												targetActivePower = deviceData.targetActivePower;
											}
										} else {
											lastTargetActivePowerReqDate = deviceData.lastTargetActivePowerReqDate ? String(deviceData.lastTargetActivePowerReqDate) : "-";
											lastTargetActivePowerRecvDate = deviceData.lastTargetActivePowerReqDate ? String(deviceData.lastTargetActivePowerReqDate) : "-";
											targetActivePower = deviceData.targetActivePower ? deviceData.targetActivePower : 0;
										}
									}
								} else {
									if (!isEmpty(deviceData) && !isEmpty(deviceData.data)) {
										deviceData.data.forEach(el => {
											if (!isEmpty(el.dcPower)) itemDcPower += el.dcPower;
											if (!isEmpty(el.activePower)) itemAcPower += el.activePower;
											if (!isEmpty(el.efficiency)) itemEfficiency += el.efficiency;
										});
									}
								}
								itemCapacity = sList[0].capacities.gen;
							});
						}
					}

					if ((url).match(apiEnergySite)) {
						let getNowEnergyDay = 0;
						let nowBillingDay = 0;
						let v = Object.values(data.data);

						if(!isEmpty(v) && v.flat()[0]["items"].length>0){
							const rstData = v.flat()[0]["items"];
							rstData.forEach(rst => {
								if (!isEmpty(rst.energy)) {
									getNowEnergyDay += rst.energy;
									nowBillingDay += rst.money;
								}
							});
						} else {
							getNowEnergyDay = 0;
							nowBillingDay = 0;
						}
						if ((data.start) == formYesterData.startTime) {
							$('#centerTbody tr td:nth-child(3) em').before(displayNumberFixedUnit(getNowEnergyDay, 'Wh', 'kWh', 0)[0]);
							itemEnergyDay = getNowEnergyDay;
						} else {
						// KPX
							$('#centerTbody tr td:nth-child(2)').html(displayNumberFixedUnit(getNowEnergyDay, 'Wh', 'kWh', 0)[0] + '<em>&nbsp;kWh</em>');
							if (!oid.match('testkpx')) {
								$('#centerTbody tr td:nth-child(4)').html(displayNumberFixedUnit(nowBillingDay, 'Wh', 'kWh', 2)[0] + '<em>&nbsp;kWh</em>');
							}
						}
					} else if ((url).match(apiEnergyNowSite)) {
					// NOT KPX
						if(!isEmpty(data.data[siteId])) {
							let rstData = data.data[siteId];
							let getNowEnergyDay = rstData.energy;
							let nowBillingDay = rstData.money;
							let tempEnergy = displayNumberFixedUnit(getNowEnergyDay, 'Wh', 'kWh', 0);
							let tempEnergyHours = (itemCapacity > 0) ? ( Math.round( getNowEnergyDay / itemCapacity * 100) / 100 ) : [0];
							let tempSMP = displayNumberFixedUnit(nowBillingDay, 'Wh', 'kWh', 2)[0];
							let tempSmpUnit = $('#centerTbody tr td:nth-child(5) em').text().trim();
							$('#centerTbody tr td:nth-child(2)').html(tempEnergy[0] + '<em>&nbsp;kWh</em>');
							$('#centerTbody tr td:nth-child(3)').html(tempEnergyHours + '<em>&nbsp;H</em>');
							$('#centerTbody tr td:nth-child(5)').empty().html(tempSMP + '<em>&nbsp;' + tempSmpUnit + '</em>');
						}
					} else if ((url).match(apiForecastingSite)) {
						let todayForeEnergy = 0;
						
						if (!isEmpty(data.data) && Object.values(data.data).flat()[0]["items"].length > 0) {
							let v = Object.values(data.data).flat()[0]["items"];

							v.forEach(rst => {
								const generation = rst.energy;
								if (!isEmpty(rst.energy)) {
									todayForeEnergy += rst.energy;
								}
							});
						}
						$('#centerTbody tr td:nth-child(4)').html(displayNumberFixedUnit(todayForeEnergy, 'Wh', 'kWh', 0)[0] + '<em>&nbsp;kWh</em>');

					} else if ((url).match('/control/command_history')) {
						if (!isEmpty(data.data)) {
							if (!isEmpty(lastTargetActivePowerReqDate)) {
								let statusDate = new Date(lastTargetActivePowerReqDate.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
								let historyData = new Date(data.data[0].requested_at.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
								if (statusDate.getTime() < historyData.getTime()) {
									lastTargetActivePowerReqDate = historyData.format('yyyyMMddHHmmss');
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
					}

				});

				if (oid.match('testkpx')) {
					let genHour = isNaN(itemEnergyDay / itemCapacity) ? '-' : (itemEnergyDay / itemCapacity);

					if (genHour === '-') {
						$('#centerTbody tr td:nth-child(4)').html(genHour + '<em></em>');
					} else {
						$('#centerTbody tr td:nth-child(4)').html(genHour.toFixed(1) + '<em>&nbsp;kWh</em>');
					}

					$('#siteCapacity').text(displayNumberFixedUnit(targetActivePower, 'W', 'kW', 2)[0]);
					$('#siteAcPower').text(String(lastTargetActivePowerReqDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
					if (lastTargetActivePowerRecvDate != '-') {
						$('#siteDcPower').text(String(lastTargetActivePowerRecvDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
					}

					let usage = Math.floor((itemAcPower / targetActivePower) * 100);
					let other = 100 - usage;

					pieChart.series[0].data.forEach((e, idx) => {
						if (!isEmpty(sList)) {
							if(sList[0].resource_type == "1") {
								pieChart.series[0].name = "태양광"
								e.update({y: usage});
							} else if(sList[0].resource_type == "2"){
								pieChart.series[0].name = "풍력"
								e.update({y: usage});
							} else if(sList[0].resource_type == "3"){
								pieChart.series[0].name = "소수력"
								e.update({y: usage});
							}

							if (e.name === "태양광") {
								e.update({y: usage});
							} else if (e.name === "미사용량") {
								e.update({y: other});
							}
						}
					});
					pieChart.redraw();
				} else {
					isEmpty(itemDcPower) ? $('#siteDcPower').html("-&nbsp;").next().text("") : $('#siteDcPower').html(displayNumberFixedUnit(itemDcPower, 'W', 'kW', 0)[0] + "&nbsp;").next().text("kW");
					isEmpty(itemAcPower) ? $('#siteAcPower').html("-&nbsp;").next().text("") : $('#siteAcPower').html(displayNumberFixedUnit(itemAcPower, 'W', 'kW', 0)[0] + "&nbsp;").next().text("kW");
					let pie1Data = Math.round(itemAcPower/itemCapacity * 100);
					let pie2Data = 100 - pie1Data;

					if(pieChart.series[0].data.length == 3){
						pieChart.series[0].data[0].remove(true);
					}

					pieChart.series[0].setData([pie1Data, pie2Data]);
				}

				pieChart.setTitle({text: displayNumberFixedUnit(itemAcPower, 'W', 'kW', 0)[0] + 'kW'});
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

			let promises = [ makeAjaxCall(optionList[0]), makeAjaxCall(optionList[1]),  makeAjaxCall(optionList[2]) ];

			Promise.all(promises).then(res => {
				let el = $("#solarDashboard .mini .data-num");

				if(!isEmpty(res[0]) && !isEmpty(res[0].INV_PV)){
					if(typeof res[0].INV_PV.activePower == "number"){
						let activePower = displayNumberFixedUnit(res[0].INV_PV.activePower, 'W', 'kW', 1);
						el.eq(0).text(activePower[0]);
						el.eq(0).next().text(activePower[1]);
					} else {
						el.eq(0).text("-");
					}
					if(typeof res[0].INV_PV.efficiency == "number"){
						el.eq(1).text( Math.round(res[0].INV_PV.efficiency * 10)/10 )
						el.eq(1).next().text("%");
					} else {
						el.eq(1).text("-");
					}
					if(typeof res[0].INV_PV.accumActiveEnergy == "number"){
						let accumVal = displayNumberFixedUnit(res[0].INV_PV.accumActiveEnergy, 'Wh', 'MWh', 1);
						el.eq(5).text(accumVal[0]);
						el.eq(5).next().text(accumVal[1]);
					} else {
						el.eq(5).text("-");
					}
					
				} 

				if(!isEmpty(res[1].data) && typeof Object.entries(res[1].data)[0][1].energy == "number"){
					let dailyGen = displayNumberFixedUnit( Object.entries(res[1].data)[0][1].energy, 'Wh', 'kWh', 0);
					el.eq(2).text(dailyGen[0]);
					el.eq(2).next().text(dailyGen[1]);
				} else {
					el.eq(2).text("-");
				}

				let v = Object.values(res[2].data);
				if(!isEmpty(res[2].data) && v.flat()[0]["items"].length > 0 ){
					let data = v.flat()[0]["items"];
					if(typeof data[0].energy == "number"){
						let yesterDayGen = displayNumberFixedUnit(data[0].energy,'Wh', 'kWh', 0);
						el.eq(3).text(yesterDayGen[0]);
						el.eq(3).next().text(yesterDayGen[1]);
					} else {
						el.eq(3).text("-");
					}
				} else {
					el.eq(3).text("-");
				}
			});
		}
	}

	function todayGeneration(option) {
		const formData = getSiteMainSchCollection('day');
		const formYesterData = getSiteMainSchCollection('yesterday');

		let foreGen = {};
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
		let invMaxVal = 0;
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
		let efficiencyData = new Array(24).fill(0);

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
			let itemChartCapacity = 0;
			let dayPvSum = 0;
			$.when($.ajax(gen), $.ajax(foreGen), $.ajax(nowGen))
			.done(function (genData, foreGenData, nowGenData) {
				itemChartCapacity = sList[0].capacities.gen ? sList[0].capacities.gen : 0;
				let temp = itemChartCapacity ? displayNumberFixedUnit(itemChartCapacity, 'W', 'kW', 0)[0] : "-";
				if(temp == "-") {
					$('#centerTbody tr td:nth-child(1)').html(temp);
					$('#siteCapacity').html("-&nbsp;").next().text("");
				} else {
					$('#centerTbody tr td:nth-child(1)').html(temp + ' ' + '<em> kW</em>');
					$('#siteCapacity').html(temp + "&nbsp;").next().text("kW");
				} 

				if (genData[1] == 'success') {
					if (!isEmpty(genData[0].data) &&  Object.values(genData[0].data).flat()[0]["items"].length > 0) {
						let v = Object.values(genData[0].data);
						let dummyItem = v.flat()[0]["items"];
						if (dummyItem.length > 0) {
							dummyItem.forEach(el => {
								let index = Number(String(el.basetime).substring(8, 10));
								energyData1[index] = el.energy;
								dayPvSum += el.energy;
								efficiencyData[index] = parseFloat((el.energy/itemChartCapacity * 100).toFixed(2));
							});
						}
					}
				}

				if (foreGenData[1] == 'success') {
					if (!isEmpty(foreGenData[0].data) && Object.values(foreGenData[0].data).flat()[0]["items"].length > 0) {
						let v = Object.values(foreGenData[0].data).flat()[0]["items"];
						v.forEach((el, index) => {
							energyData2[index] = Math.round(el.energy / 1000);
						});
					}
				}

				if (nowGenData[1] == 'success') {
					let today = new Date();
					let hour = today.getHours();
					if(!isEmpty(nowGenData[0].data[siteId])) {
						// energyData1[index] === energyData[hour] ( current time Energy: NOW 에만 있는 데이터!!!!)
						energyData1[hour] = nowGenData[0].data[siteId].energy;
					}
				}

				energyData1.forEach((el, index) => {
					energyData1[index] = Math.round(el / 1000);
				});

				energyData2.forEach((el, index) => {
					energyData2[index] = el;
				});

				let devTime = [];
				efficiencyData.forEach((el, index) => {
					devTime[index] = (el / 100).toFixed(2) * 1;
				});
				
				hourlyChart.series[0].setData(energyData1);
				hourlyChart.series[1].setData(energyData2);
				hourlyChart.series[2].setData(devTime);

				if (!oid.match('testkpx')) {
					let tempObj = {
						name: "<fmt:message key='smain.CapacityFactor' />",
						type: 'spline',
						dashStyle: 'ShortDash',
						color: 'var(--white60)',
						data: efficiencyData,
						tooltip: {
							valueSuffix: '%',
							formatter: function () {
								return this.value;
							},
						},
						marker: {
							symbol: 'circle'
						},
						yAxis: 1,						
					}
					if(hourlyChart.series[3]){
						hourlyChart.series[3].remove();
					}

					hourlyChart.addSeries(tempObj);

					hourlyChart.yAxis[1].update({
						showEmpty: true,
						opposite: true,
						gridLineWidth: 0,
						title:{
							text: "%",
							x: -25,
							y: 25,
							align: 'low',
							rotation: 0,
							style: {
								color: 'var(--grey)',
								fontSize: '12px'
							}
						},
						labels: {
							x: 10,
							min: 0,
							max: 100,
							style: {
								color: 'var(--grey)',
								fontSize: '12px'
							}
						},
						min: 0,
						max: 100
					});

					hourlyChart.update({
						chart: {
							marginLeft: 38,
							marginRight: 36
						},
					});
					hourlyChart.redraw();

				}
				$("#loadingCircle").hide();
			}).fail(function (jqXHR, textStatus, errorThrown) {
				$("#loadingCircle").hide();
				let errMsg = "<fmt:message key='smain.error.1' /> <br/><fmt:message key='smain.error.2' />" + errorThrown;
				let r = formatErrorMessage(jqXHR, errorThrown);
				console.log("error===", r);
				$("#errMsg").html(errMsg);
				$("#errorModal").modal("show");
				setTimeout(function(){
					$("#errorModal").modal("hide");
				}, 2000);
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
							energyData2[index] = parseFloat((el.energy / 1000).toFixed(2));
						});
					}
				}

				if (nowGenData[1] == 'success') {
					let today = new Date();
					let hour = today.getHours();

					if(!isEmpty(nowGenData[0].data[siteId])) {
						energyData1[hour] = nowGenData[0].data[siteId].energy;
					}
				}

				energyData1.forEach((el, index) => {
					energyData1[index] = parseFloat((el / 1000).toFixed(2));
				});

				if (insolationData[1] == 'success') {
					if (!isEmpty(insolationData[0]) && insolationData[0].length>0) {
						let standard = String(insolationData[0][0].basetime).substring(0, 6);
						let sumVal = 0;

						for(let i=0, arrLength = insolationData[0].length; i<arrLength; i++){
							let irrPoa = insolationData[0][i].sensor_solar.irradiationPoa;
							if(!isEmpty(irrPoa)){
								energyData3[i] = numberComma(irrPoa);
								if( energyData3[i] > invMaxVal ){
									invMaxVal = energyData3[i];
								}								
							}
						}
					}
				}

				// console.log("energyData1==", energyData1, "energyData2==", energyData2, "energyData3==", energyData3);

				let solarChartLength = hourlySolarChart.series.length;

				if(solarChartLength>0){
					for(let i = solarChartLength -1; i > -1; i--) {
						hourlySolarChart.series[i].remove();
					}
				}

				if(energyData1.length>0){
					hourlySolarChart.addSeries({
						name: '<fmt:message key="smain.generationResults" />',
						type: 'column',
						color: 'var(--turquoise)',
						tooltip: {
							valueSuffix: 'kWh'
						},
						data: energyData1
						// data: {
						// csvURL: urlInput.value,
						// enablePolling: pollingCheckbox.checked === true,
						// dataRefreshRate: parseInt(pollingInput.value, 10)
						// }
					});

				}

				if(energyData2.length>0){
					hourlySolarChart.addSeries({
						name: '<fmt:message key="smain.forecasts" />',
						type: 'column',
						color: 'var(--white25)',
						tooltip: {
							valueSuffix: 'kWh'
						},
						data: energyData2
					});
				}

				if(energyData3.length>0){
					hourlySolarChart.addSeries({
						name: '<fmt:message key="smain.irradiance" />',
						type: 'spline',
						dashStyle: 'ShortDash',
						yAxis: 1,
						color: 'var(--white60)',
						tooltip: {
							valueSuffix: ' W/m\xB2'
						},
						marker: {
							symbol: 'circle'
						},
						data: energyData3
					});
				}
				hourlySolarChart.redraw();
				$("#loadingCircle").hide();
			}).fail(function () {
				console.error('rejected');
				$("#loadingCircle").hide();
			});
		}
	}

	function getAlarmInfo () {
		const formData = getSiteMainSchCollection('day');
		let siteArray = [];

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
			
			let alarmList = [];
			let alarmColor = "";
			let alarmEl = $('.indiv[data-alarm]');
			
			data.forEach((el, index) => {
				if(el.level != 0) {
					let localTime = (el.localtime != null && el.localtime != '') ? String(el.localtime) : '';
					data[index].standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
					alarmList.push(el);
				}
			});
			
			if(alarmList.length>0){
				if( alarmList.findIndex(x => x.level == 4) > -1){
					alarmColor = "urgent";
				} else {
					if( alarmList.findIndex(x => x.level == 3) > -1 ){
						alarmColor = "shutoff";
					} else {
						if( alarmList.findIndex(x => x.level == 2) > -1 ){
							alarmColor = "critical";
						} else {
							if( alarmList.findIndex(x => x.level == 1) > -1 ){
								alarmColor = "warning";
							} else {
								if( alarmList.findIndex(x => x.level == 0) > -1 ){
									alarmColor = "info";
								} else {
									alarmColor = "";
								}
							}
						}
					}
				}
			} else {
				alarmColor = "";
			}

			alarmEl.attr("data-alarm", alarmColor);
			alarmEl.find('em').text(alarmList.length);
			setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}});

		}).fail(function (jqXHR, textStatus, errorThrown) {
			let errMsg = "<fmt:message key='smain.error.1' /> <br/><fmt:message key='smain.error.2' />" + errorThrown;
			let r = formatErrorMessage(jqXHR, errorThrown);
			console.log("error===", r);
			$("#errMsg").html(errMsg);
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
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

	function rtnDropdown (id) {
		if (id == 'chartType') {
			chargeChartPoll();
		} else if (id == 'statusDevice') {
			getDvcInfo();
		}
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

	function toPvGen(sid) {
		const $form = $(`#linkSiteForm`);

		let $sid = $(`<input>`).attr({ type : `hidden`, name : `sid` }).val(sid);

		$form.append($sid).attr(`action`, `/energy/pvGen.do`).submit();
	}

	function addToDateList(idx, data, option, customDateList){
		let dateList = [];

		if(!isEmpty(data)){
			if(isEmpty(customDateList)){
				dateList = [...date31List];
			} else {
				dateList = [...customDateList];
			}
		
			data.map((item, index) => {
				let dateNum = String(item.basetime).substring(4, 8);
				let found = dateList.findIndex( x => x === dateNum);
				if(found > -1) {
					let tempDate = Date.UTC(Number(String(item.basetime).substring(0, 4)), Number(String(item.basetime).substring(4, 6)), Number(String(item.basetime).substring(6, 8)) );
					if(option == "energy"){
						// dateList[found] = [tempDate, item.energy];
						dateList[found] = item.energy;
					}
					if(option == "irradiationPoa"){
						// dateList[found] = [tempDate, Math.round(item.sensor_solar.irradiationPoa)];
						dateList[found] = Math.round(item.sensor_solar.irradiationPoa);
					}
				}
			});
			dateList.map( (item, index) => {
				if(typeof item === "string"){
					dateList[index] = null;
				}
			});
		} else {
			let now = new Date();
			now.setDate(now.getDate()-idx);
			if(!isEmpty(option)){
				dateList = [...Array(idx)].map(x => {
					now.setDate(now.getDate()+1);
					return now;
				});
			} else {
				dateList = [...Array(idx)].map(x => {
					now.setDate(now.getDate()+1);
					return now.format("yyyyMMdd").substring(4, 8);
				});
			}
		}
		return dateList;
	}

	function setExportFileName(){
		let d = new Date();
		let tempDate = d.format("yyyyMMddHHmmss");
		let newName = sList[0].name.replace(/\s/g, "") + "_" + tempDate;
		return newName
	}

</script>