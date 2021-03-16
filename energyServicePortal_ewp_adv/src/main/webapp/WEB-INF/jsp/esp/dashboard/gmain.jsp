<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:if test="${dashboardMap eq 'google'}">
	<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
	<script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyAgEDjSwQWd_Q9RF_owO8WkMtf-6lmVSpc"></script>
</c:if>

<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header">
		<h1 class="page-header">${siteName}</h1>
		<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			<label class="switch switch-slide">
				<input type="checkbox" value="showTable" id="switchBtn" class="switch-input" ${cookie['switch'].value} />
				<span class="switch-label" data-on="<fmt:message key='gmain.switch.table' />" data-off="<fmt:message key='gmain.switch.dashboard' />"></span>
				<span class="switch-handle"></span>
			</label>
		</c:if>
		
		<div id="dashboardTableSearch">
			<input type="text" placeholder="발전소 명 검색">
		</div>
	</div>
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATABASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv chart-wrapper gmain-chart1">
			<div class="chart-top offset">
				<div id="miniLoadingCircle_month" class="mini-loading" style="display:none;"><img class="mini-loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div>
				<h2 class="ntit"><fmt:message key="gdash.1.month"/></h2>
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span></span>
					<img src="/img/ico-next.svg" class="next hidden">
				</span>
				<ul id="monthlySum" class="sum-list mobile-visible"></ul>
			</div>
			<div class="inchart mobile-hidden">
				<div id="monthlyChart"></div>
			</div>
		</div>

		<div class="indiv chart-wrapper gmain-chart2">
			<div class="chart-top offset">
				<div id="miniLoadingCircle_daily" class="mini-loading" style="display:none;"><img class="mini-loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div>
				<h2 class="ntit"><fmt:message key="gdash.2.daily"/></h2>
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span></span>
					<img src="/img/ico-next.svg" class="next hidden">
				</span>
				<ul id="dailySum" class="sum-list mobile-visible"></ul>
			</div>
			<div class="inchart mobile-hidden">
				<div id="dailyChart"></div>
			</div>
		</div>

		<div class="indiv chart-wrapper gmain-chart3">
			<div class="chart-top offset">
				<div id="miniLoadingCircle_type" class="mini-loading" style="display:none;"><img class="mini-loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div>
				<h2 class="ntit"><fmt:message key="gdash.3.yesterday"/></h2>
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span></span>
					<img src="/img/ico-next.svg" class="next hidden">
				</span>
				<ul id="yesterdaySum" class="sum-list mobile-visible"></ul>
			</div>
			<!-- 사업소별 현황 -->
			<div class="inchart mobile-hidden">
				<div id="typeSiteCurrent"></div>
			</div>
		</div>
	</div>

	<div class="col-xl-8 col-md-12 col-sm-12">
		<div class="gmain-row1">
			<div class="indiv chart-wrapper gmain-chart4">
				<div class="chart-top">
					<h2 class="ntit"><fmt:message key="gdash.4.current"/></h2>
				</div>
				<div class="chart-info">
					<div id="pie_chart" class="chart-info-left"></div>
					<div class="chart-info-right">
						<div class="legend-wrap">
							<span class="bu1"><fmt:message key="gdash.4.gen"/></span>
							<c:if test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
								<span class="bu2"><fmt:message key='gmain.windPower' /></span>
							</c:if>
							<span class="bu4"><fmt:message key="gdash.4.idle"/></span>
						</div>
						<ul>
							<c:choose>
								<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
									<li><strong><fmt:message key="gdash.4.active_power"/></strong> <span> 0 </span><em>&nbsp;&nbsp;kW</em></li>
									<li><strong><fmt:message key='gmain.aimedPower' /></strong> <span> 0 </span><em>&nbsp;&nbsp;kW</em></li>
									<li><strong><fmt:message key='gmain.size' /></strong> <span> 0 </span><em>&nbsp;&nbsp;kW</em></li>
								</c:when>
								<c:otherwise>
									<li><strong><fmt:message key="gdash.4.today_gen"/></strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
									<li><strong><fmt:message key="gdash.4.forecast"/></strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
									<li><strong><fmt:message key="gdash.4.today_ess"/></strong> <span> - </span><em>&nbsp;&nbsp;Wh</em> / <span> - </span><em>&nbsp;&nbsp;Wh</em></li>
								</c:otherwise>
							</c:choose>
						</ul>
					</div>
				</div>
				<div class="local-info gmain-center">
					<table>
						<thead>
						<c:choose>
						<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
						<tr>
							<th><fmt:message key='gmain.catrgory' /></th>
							<th><fmt:message key='gmain.site' /></th>
							<th><fmt:message key='gmain.size' /></th>
							<th><fmt:message key='gmain.category' /></th>
							<th><fmt:message key='gmain.site' /></th>
							<th><fmt:message key='gmain.size' /></th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td> <fmt:message key='gmain.windPower' /></td>
							<td> -</td>
							<td> -</td>
							<td> <fmt:message key='gmain.sunPower' /></td>
							<td> -</td>
							<td> -</td>
						</tr>
						</c:when>
						<c:otherwise>
						<tr>
							<th><fmt:message key="gdash.4.tot_num"/></th>
							<th><fmt:message key="gdash.4.num_device"/></th>
							<th><fmt:message key="gdash.4.tot_cap"/></th>
							<th><fmt:message key="gdash.4.generation"/></th>
							<th><fmt:message key="gdash.4.today_co2"/></th>
							<th><fmt:message key="gdash.4.today_revenue"/></th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td><em>&nbsp;&nbsp;<fmt:message key='gmain.totalCount.site' /></em></td>
							<td><em>&nbsp;&nbsp;<fmt:message key='gmain.totalCount.device' /></em></td>
							<td><em>&nbsp;&nbsp;kW</em></td>
							<td><em>&nbsp;&nbsp;Hrs</em></td>
							<td><em>&nbsp;&nbsp;kg</em></td>
							<td><em>&nbsp;&nbsp;<fmt:message key='gmain.1000won' /></em></td>
						</tr>
						</c:otherwise>
						</c:choose>

						</tbody>
					</table>
				</div>
			</div>
			<div class="indiv gmain-alarm" data-alarm="">
				<div class="alarm-status">
					<div class="alarm-alert"><span><fmt:message key="gdash.6.today_alerts"/></span><em>0</em></div>
					<div class="alarm-warning"><a href="javascript:void(0);" onclick="pageMove('all', 'alarm');" class="btn btn-cancel"><fmt:message key="gdash.6.details"/></a></div>
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
		</div>

		<c:choose>
			<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				<div class="gmain-row2">
					<div class="indiv gmain-table">
						<div id="miniLoadingCircle" class="mini-loading" style="display:none;"><img class="mini-loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div>
						<div class="gmain-map2-content-kpx">
							<div class="table-top clear">
								<div class="input-group1">
									<div class="sa-select">
										<div class="dropdown" id="rowCount">
											<button type="button" class="dropdown-toggle w8" data-toggle="dropdown" data-value="-1" data-name="<fmt:message key='gmain.all' />"><fmt:message key='gmain.all' /><span class="caret"></span></button>
											<ul class="dropdown-menu chk-type" role="menu">
												<li data-value="25">
													<a href="javascript:void(0);" tabindex="-1"><fmt:message key='gmain.25' /></a>
												</li>
												<li data-value="50">
													<a href="javascript:void(0);" tabindex="-1"><fmt:message key='gmain.50' /></a>
												</li>
												<li data-value="50">
													<a href="javascript:void(0);" tabindex="-1"><fmt:message key='gmain.100' /></a>
												</li>
												<li data-value="-1">
													<a href="javascript:void(0);" tabindex="-1"><fmt:message key='gmain.all' /></a>
												</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="input-group1">
									<div class="sa-select">
										<div class="dropdown" id="resourceList">
											<button type="button" class="dropdown-toggle w8" data-toggle="dropdown" data-name="발전원"><fmt:message key='gmain.all' /><span class="caret"></span></button>
											<ul class="dropdown-menu chk-type" role="menu" id="resourceULList">
													<%-- 동적 생성 --%>
												<li data-value="[resourceCode]">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="checkbox" id="resourceType[index]" name="resourceType" value="[resourceCode]" checked>
														<label for="resourceType[index]">[resourceName]</label>
													</a>
												</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="input-group1">
									<div class="sa-select">
										<div class="dropdown" id="locationList">
											<button type="button" class="dropdown-toggle w8" data-toggle="dropdown" data-name="지역"><fmt:message key='gmain.all' /><span class="caret"></span></button>
											<ul class="dropdown-menu chk-type" role="menu" id="locationULList">
												<li data-value="[loc]">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="checkbox" id="location[index]" name="location" value="[loc]" checked>
														<label for="location[index]">[loc]</label>
													</a>
												</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="input-group1">
									<div class="sa-select">
										<div class="dropdown" id="deviceStatus">
											<button type="button" class="dropdown-toggle w8" data-toggle="dropdown" data-name="상태"><fmt:message key='gmain.all' /><span class="caret"></span></button>
											<ul class="dropdown-menu chk-type" role="menu">
												<li data-value="1">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="1" checked>
														<label for="deviceStatus1"><fmt:message key='gmain.normal' /></label>
													</a>
												</li>
												<li data-value="2">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="2" checked>
														<label for="deviceStatus2"><fmt:message key='gmain.error' /></label>
													</a>
												</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="input-group2">
									<input type="text" class="input" id="searchName" name="searchName" value="" placeholder="<fmt:message key='gmain.searchSite' />" onkeyup="if (event.keyCode == 13) searchSite();">
								</div>
							</div>

							<div class="gtbl-wrap-kpx">
								<table id="siteList">
									<colgroup>
										<col style="width:10%">
										<col style="width:15%">
										<col style="width:10%">
										<col style="width:10%">
										<col style="width:10%">
										<col style="width:10%">
										<col style="width:10%">
										<col style="width:25%">
									</colgroup>
									<thead>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</c:when>
			<c:otherwise>
				<div class="gmain-row2">
					<div class="indiv gmain-table">
						<div class="gmain-map2">
							<div class="map-wrap" id="gMainMap"></div>
						</div>
						<div class="gmain-map2-content">
							<div class="table-top clear">
								<div class="input-group1">
									<input type="text" class="input" id="searchName" name="searchName" value="" placeholder="<fmt:message key='gmain.searchSite' />" onkeyup="if (event.keyCode == 13) searchOperationSite();">
									<button type="button" class="btn-type" onclick="searchOperationSite();"><fmt:message key="gdash.7.apply"/></button>
								</div>
								<div class="input-group2">
									<span class="tx-tit"><fmt:message key="gdash.7.status"/></span>
									<div class="sa-select">
										<div class="dropdown" id="deviceStatus">
											<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown" data-name="<fmt:message key='gmain.deviceStatus' />"><fmt:message key='gmain.all' /><span class="caret"></span></button>
											<ul class="dropdown-menu chk-type" role="menu">
												<li data-value="0">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="0" checked>
														<label for="deviceStatus1"><fmt:message key='gmain.stop' /></label>
													</a>
												</li>
												<li data-value="1">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="1" checked>
														<label for="deviceStatus2"><fmt:message key='gmain.normal' /></label>
													</a>
												</li>
												<li data-value="2">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="checkbox" id="deviceStatus3" name="deviceStatus" value="2" checked>
														<label for="deviceStatus3"><fmt:message key='gmain.trip' /></label>
													</a>
												</li>
											</ul>
										</div>
									</div>
								</div>
							</div>
							<div class="gmain-wrap">
								<div class="intable" id="statusSiteList">
									<table class="dashboard-sort">
										<caption>(<fmt:message key='gmain.unit' />)</caption>
										<thead>
										<tr>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.status"/></button>
											</th>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.err"/></button>
											</th>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.medium"/></button>
											</th>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.rtu_status"/></button>
											</th>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.site"/></button>
											</th>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.cap"/></button>
											</th>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.forecast"/></button>
											</th>
											<th>
												<button type="button" class="btn-align"><fmt:message key="gdash.7.gen"/></button>
											</th>
											<th class="ESS">
												<button type="button" class="btn-align"><fmt:message key="gdash.7.charge"/></button>
											</th>
											<th class="ESS">
												<button type="button" class="btn-align"><fmt:message key="gdash.7.discharge"/></button>
											</th>
										</tr>
										</thead>
										<tbody id="siteList">
										<!-- [D] 상태별 배경 : 't1' or 't2' 클래스 추가 -->
										<tr class="dbclickopen flag[INDEX] [displayClass]" data-sid="[sid]" data-operation="[operation]" data-address="[address]">
											<td class="first-td">
												<span class="status [statusClass]" title="[status]">[status]</span>
												<!-- <span class="status-bar"></span> -->
											</td>
											<td>[alarmError]</td>
											<td>[alarmWarning]</td>
											<td><span class="status-button [rtustatusClass]">[rtustatus]</span></td>
											<td class="center">[name]</td>
											<td class="center">[capacityView]</td>
											<td class="center">[forecast]</td>
											<td class="center">[accumulate]</td>
											<td class="ESS">-</td>
											<td class="ESS">-</td>
										</tr>
										<tr class="detail-info list[INDEX] flag[INDEX]">
											<td colspan="9">
												<div class="di-wrap">
													<div class="di-wrap-in">
														<div class="di-top-sec">
															<span class="ico [resourceClass]"></span>
															<div class="text-wrapper clear">
																<div class="fl">
																	<span class="tx"><fmt:message key="gdash.7.irr"/></span>
																	<span class="tx2">[irradiationPoa] W/㎡</span>
																</div>
																<div class="fr">
																	<span class="tx"><fmt:message key="gdash.7.temp"/></span>
																	<span class="tx2">[temperature]</span>
																	<span class="tx"><fmt:message key="gdash.7.humid"/></span>
																	<span class="tx2">[humidity]</span>
																</div>
															</div>
														</div>
														<div class="di-bottom-sec clear">
															<div class="sec-box left">
																<div class="box-in">
																	<div class="box-top">
																		<div class="inchart" id="type_chart[INDEX]"></div>
																	</div>
																	<ul class="di-list">
																		<li>
																			<span class="di-li-title"><fmt:message key="gdash.7.production"/> (kW)</span>
																			<span class="di-li-text">[activePowerView]</span>
																		</li>
																		<li>
																			<span class="di-li-title"><fmt:message key="gdash.7.gen_today"/> (kWh)</span>
																			<span class="di-li-text">[accumulate]</span>
																		</li>
																		<li>
																			<span class="di-li-title"><fmt:message key="gdash.7.gen_forecast"/> (kWh)</span>
																			<span class="di-li-text">[forecast]</span>
																		</li>
																		<li>
																			<span class="di-li-title"><fmt:message key="gdash.7.gen_yesterday"/> (kWh)</span>
																			<span class="di-li-text">[beforeDay]</span>
																		</li>
																	</ul>
																</div>
															</div>
															<div class="sec-box right">
																<div class="box-in">
																	<div class="box-top">
																		<div class="box-top-inner"></div>
																	</div>
																	<ul class="di-list">
																		<li>
																			<span class="di-li-title"><fmt:message key="gdash.7.tot_cap"/> (kW)</span>
																			<span class="di-li-text">[capacityView]</span>
																		</li>
																		<li>
																			<span class="di-li-title"><fmt:message key="gdash.7.num_inv"/> (EA)</span>
																			<span class="di-li-text">[inverterCount]</span>
																		</li>
																	</ul>
																	<div class="di-text-box">
																		<a href="javascript:void(0);"
																		   onclick="pageMove('[sid]', 'alarm')">
																			<p class="tx"><fmt:message key="gdash.7.num_no_ack"/> :
																				<span>[alarmTotal] <fmt:message key='gmain.cases' /></span></p>
																		</a>
																			<%--<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
																			<%--<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
																	</div>
																</div>
															</div>
														</div>
														<div class="btn-box clear">
															<a href="javascript:void(0);" onclick="pageMove('[sid]', 'siteMain')" class="line-arrow"><fmt:message key="gdash.7.go_dashboard"/></a>
														</div>
													</div>
												</div>
											</td>
										</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</c:otherwise>
		</c:choose>

	</div>
</div>
<%@ include file="/decorators/include/dashboardTableView.jsp" %>
<script type="text/javascript">
	const secondYAxis = ${secondYAxis};
</script>
<c:choose>
	<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
		<script type="text/javascript" src="/js/dashboard/dashboardKpxV2.js"></script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript" src="/js/dashboard/dashboardV2.js"></script>
	</c:otherwise>
</c:choose>

<script type="text/javascript" src="/js/dashboard/dashboardChart.js"></script>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}')
		, sgid = '${sgid}'
		, haveMenu_gen = '${haveMenu}'
		, haveMenu_fore = '${haveMenu}'
		, today = new Date()
		, divisionLocation = '${sessionScope.divisionLocation}'
		, divisionResourceType = '${sessionScope.divisionResourceType}';

	<c:if test="${dashboardMap eq 'google'}">
	let makerObject = new Object();
	let markers = [];
	let map = new google.maps.Map(document.getElementById('gMainMap'), {
		mapTypeId: 'satellite',
		zoom: 7.3,
		mapTypeControl: false, //맵타입
		streetViewControl: false, //스트리트뷰
		fullscreenControl: false, //전체보기
		center: {lat: 36.549012, lng: 127.788546} // center: new google.maps.LatLng(37.549012, 126.988546),
	});
	let geocoder = new google.maps.Geocoder();
	let infowindow = new google.maps.InfoWindow();
	</c:if>

	$(function () {
		let target = $("#innerBody").find(".content-wrapper");
		var refreshMinInterval;
		var refreshHourInterval;
		var dashboardViewFlag = true;

		if ($("#switchBtn").is(":checked")) {
			target.eq(0).addClass("hidden").next().removeClass("hidden");
			// $($.fn.dataTable.tables(true)).DataTable().columns.adjust();
			getDashboardTable('gmainTable');
		} else {
			target.eq(0).removeClass("hidden").next().addClass("hidden");

			if (!isEmpty(siteList) && siteList.length > 0) {
				firstAjax();
				refreshHourInterval = setInterval(firstAjax, 60 * 60 * 1000); // 한시간에 한번 화면갱신
				// setInterval(() => firstAjax(), 60 * 60 * 1000); // 한시간에 한번 화면갱신
				refreshMinInterval = setInterval(() => {
					minIntervalCount++;
					if ((minIntervalCount % 60) !== 0) {
						minAjax();
					}
				}, 60 * 1000); //1분에 한번 현재현황 & 알림 갱신
			} else {
				$('#errMsg').text("<fmt:message key='gmain.warning.noSite' />");
				$('#errorModal').modal('show');
				setTimeout(function () {
					$('#errorModal').modal('hide');
				}, 2000);
				return false;
			}

			$("#dashboardTableSearch").addClass("hidden");
		}
		
		const dashboardTable = $(".dashboard-table").DataTable();
		$("#dashboardTableSearch > input").on( 'keyup search input paste cut', function(e) {
			dashboardTable.search( this.value ).draw();
		});

		$('#switchBtn').on('click', function () {
			if ($(this).is(':checked')) {
			// B. TableView
				$("#dashboardTableSearch").removeClass("hidden");
				// document.cookie = 'switch=checked; path=/';
				setCookie("switch", "checked");
				target.eq(0).addClass('hidden').next().removeClass('hidden');
				$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
				getDashboardTable('gmainTable');
				clearInterval(refreshMinInterval);
				clearInterval(refreshHourInterval);
			} else {
				// A. DashboardView
				$("#dashboardTableSearch").addClass("hidden");
				target.eq(0).removeClass('hidden').next().addClass('hidden');
				setCookie('switch', '');

				if (!isEmpty(siteList) && siteList.length > 0) {
					let pathName = window.location.pathname;

					if (pathName.includes('gmain') && dashboardViewFlag === true) {
						firstAjax();
						refreshHourInterval = setInterval(firstAjax, 60 * 60 * 1000); // 한시간에 한번 화면갱신
						refreshMinInterval = setInterval(() => {
							minIntervalCount++;
							if ((minIntervalCount % 60) !== 0) {
								minAjax();
							}
						}, 60 * 1000); //1분에 한번 현재현황 & 알림 갱신
					} else {
						if (pathName.includes('jmain')) {
							firstAjax();
							refreshHourInterval = setInterval(firstAjax, 60 * 60 * 1000); // 한시간에 한번 화면갱신
							refreshMinInterval = setInterval(() => {
								minIntervalCount++;
								if ((minIntervalCount % 60) !== 0) {
									minAjax();
								}
							}, 60 * 1000); //1분에 한번 현재혆황 & 알림 갱신
						}
					}
				} else {
					$('#errMsg').text("<fmt:message key='gmain.warning.noSite' />");
					$('#errorModal').modal('show');
					setTimeout(function () {
						$('#errorModal').modal('hide');
					}, 2000);
					return false;
				}

			}
		});

		$(window).on("unload", function(e) {
			clearInterval(refreshMinInterval);
			clearInterval(refreshHourInterval);
		});
	});

	<c:if test="${dashboardMap eq 'google'}">
	const geocodeAddress = (siteAddr, siteId, siteName, siteLatlng, siteColor, operationText) => {
		let latLng = new Object(),
			dummy = siteLatlng.split(',');
		latLng['lat'] = Number(dummy[0]);
		latLng['lng'] = Number(dummy[1]);

		let marker = new google.maps.Marker({
			map: map,
			title: siteName,
			position: latLng,
			title: siteName,
			icon: pinSymbol(siteColor),
		});
		
		if (langStatus === "EN") {
			operationText = operationText.replace(`정상`, `Normal`);
			operationText = operationText.replace(`트립`, `Trip`);
			operationText = operationText.replace(`중지`, `Stop`);
		}

		let infoWIndowContent = '<div class="gmap-content"><span style="color:' + siteColor + '">' + operationText + '</span>' + siteName + '</div>';
		marker.infowindow = new google.maps.InfoWindow({
			content: infoWIndowContent
		});

		markers.push(marker);
		makerObject[siteId] = marker;

		google.maps.event.addListener(makerObject[siteId], 'click', (function (makerArray, siteId) {
			return function () {
				$.map(makerObject, function (val, key) {
					if (!isEmpty(val)) {
						val.infowindow.close();
					}
				});
				makerObject[siteId].infowindow.open(map, makerObject[siteId]);
				list_detail_open_main(siteId);
			}
		})(makerObject, siteId));


	}

	const pinSymbol = (color) => {
		if(color == "#f2a363"){
			return {
				url: '/img/map_icons/marker_orange.png',
				height: 20,
				width: 14
			}
		} else if(color == "#90caf3"){
			return {
				url: '/img/map_icons/marker_blue.png',
				height: 20,
				width: 14
			}
		} else if(color == "#ffd954"){
			return {
				url: '/img/map_icons/marker_yellow.png',
				height: 20,
				width: 14
			}
		} else if(color == "#878787"){
			return {
				url: '/img/map_icons/marker_grey.png',
				height: 20,
				width: 14
			}
		} else {
			return {
				url: '/img/map_icons/marker_red.png',
				height: 20,
				width: 14
			}
		}
	}

	const list_detail_open_main = (sid) => {
		$('.dbclickopen').each(function (item, index) {
			var touchtime = 0;

			if ($(this).data('sid') == sid) {
				let target = $(this);
				target.next().find('.di-wrap').slideDown(function () {
					$('.gmain-wrap').animate({scrollTop: target.position().top}, 1000);
				});
			}
		});
	}
	
	const smoothZoom = (map, max, cnt, zoom) => {
		if (zoom) {
			if (cnt == 18) {
				return false;
			}

			if (cnt >= max) {
				return;
			} else {
				z = google.maps.event.addListener(map, 'zoom_changed', function (event) {
					google.maps.event.removeListener(z);
					smoothZoom(map, max, cnt + 1, true);
				});
				setTimeout(function () {
					map.setZoom(cnt)
				}, 80); // 80ms is what I found to work well on my system -- it might not work well on all systems
			}
		} else {
			if (cnt == 6) {
				return false;
			}

			if (cnt <= max) {
				return;
			} else {
				z = google.maps.event.addListener(map, 'zoom_changed', function (event) {
					google.maps.event.removeListener(z);
					smoothZoom(map, max, cnt - 1, false);
				});
				setTimeout(function () {
					map.setZoom(cnt)
				}, 80); // 80ms is what I found to work well on my system -- it might not work well on all systems
			}
		}
	}
	</c:if>

	const rtnDropdown = ($selector) => {
		if ($selector == 'rowCount') {
			const rowCount = Number($('#' + $selector + ' button').data('value'));
			siteListTable.page.len(rowCount).draw();
		} else {
			searchOperationSite();
		}
	}

	const pageMove = (id, action, target) => {
		let $form = $('#linkSiteForm');
		let $inp = $('<input>').attr('type', 'hidden').attr('name', 'sid').val(id);

		$form.empty().append($inp);

		if (!isEmpty(target) && target === 'blank') {
			let targetWin = window.open('about:blank', 'targetWin_' + id);
			$form.attr('target', 'targetWin_' + id);
		} else {
			$form.removeAttr('target');
		}

		if (action == 'alarm') {
			$form.attr('action', '/history/alarmHistory.do').submit();
		} else {
			$form.attr('action', '/dashboard/smain.do').submit();
		}
	}

	const generation = (target, interval) => {
		if (haveMenu_fore === 'true') {
			const standard = $('#typeSiteCurrent').parents('div.indiv').find('.term span').data('standard');
			const site = siteList.find(e => e.name === target);

			let $form = $('#linkSiteForm');
			let $inp = $('<input>').attr('type', 'hidden').attr('name', 'sidparam').val(site.sid);
			let $inp2 = $('<input>').attr('type', 'hidden').attr('name', 'target').val(standard.format('yyyyMMdd'));
			let $inp3 = $('<input>').attr('type', 'hidden').attr('name', 'interval').val(interval);
			$form.append($inp).append($inp2).append($inp3).attr('action', '/diagnosis/generation.do').submit();
		} else {
			$('#errMsg').html('메뉴 이동 권한이 없습니다.');
			$('#errorModal').modal('show');

			setTimeout(function(){
				$('#errorModal').modal('hide');
			}, 2000);
		}
	}

	const goPvGen = (target, interval, type, sid) => {
		if (haveMenu_gen === 'true') {
			if (!$('#switchBtn').is(':checked')) {
				if (interval === 'day') {
					const standard = $('#monthlySum').parent().find('.term span').data('standard');
					target = standard.format('yyyy') + ('0' + target).slice(-2);
				} else {
					const standard = $('#dailySum').parent().find('.term span').data('standard');
					target = standard.format('yyyyMM') + ('0' + target).slice(-2);
				}
			}

			if (isEmpty(type)) { type = ''; }
			if (isEmpty(sid)) { sid = ''; }
			let $form = $('#linkSiteForm');
			let $inp = $('<input>').attr('type', 'hidden').attr('name', 'target').val(target);
			let $inp2 = $('<input>').attr('type', 'hidden').attr('name', 'interval').val(interval);
			let $inp3 = $('<input>').attr('type', 'hidden').attr('name', 'type').val(type);
			let $inp4 = $('<input>').attr('type', 'hidden').attr('name', 'sid').val(sid);
			$form.empty().append($inp).append($inp2).append($inp3).append($inp4).attr('action', '/energy/pvGen.do').submit();
		} else {
			$('#errMsg').html('메뉴 이동 권한이 없습니다.');
			$('#errorModal').modal('show');

			setTimeout(function(){
				$('#errorModal').modal('hide');
			}, 2000);
		}
	};

	function hideAllInfoWindows(map) {
		markers.forEach(function(marker) {
			marker.infowindow.close(map, marker);
		}); 
	}
</script>
