<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:if test="${dashboardMap eq 'google'}">
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyAgEDjSwQWd_Q9RF_owO8WkMtf-6lmVSpc"></script>
</c:if>

<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-6">
		<h1 class="page-header fl">${siteName}</h1>
		<label class="switch switch-slide fl">
			<input type="checkbox" id="switchBtn" class="switch-input" />
			<span class="switch-label" data-on="테이블" data-off="대시보드"></span> 
			<span class="switch-handle"></span>
		</label>
	</div>
	<div class="col-6">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv gmain_chart gmain_chart1">
			<div class="chart_top clear">
				<h2 class="ntit"><fmt:message key="gdash.1.month" /></h2><span class="term"></span>
				<ul id="monthlySum" class="sum-list mobile-visible"></ul>
			</div>
			<%--					<div class="no-data">--%>
			<%--						<span>올해 발전량 정보를 가져올 수 없습니다.</span>--%>
			<%--					</div>--%>
			<div class="inchart">
				<div id="monthlyChart"></div>
			</div>
		</div>

		<div class="indiv gmain_chart gmain_chart2">
			<div class="chart_top clear">
				<h2 class="ntit"><fmt:message key="gdash.2.daily" /></h2><span class="term"></span>
				<ul id="dailySum" class="sum-list mobile-visible"></ul>
			</div>
			<div class="inchart">
				<div id="dailyChart"></div>
			</div>
		</div>

		<div class="indiv gmain_chart gmain_chart3">
			<div class="chart_top clear">
				<h2 class="ntit"><fmt:message key="gdash.3.yesterday" /></h2><span class="term"></span>
				<ul id="yesterdaySum" class="sum-list mobile-visible"></ul>
			</div>
			<%--					<ul class="gtab_menu">--%>
			<%--						<li class="active"><a href="#;">사업소별 현황</a></li>--%>
			<%--						<li><a href="#;">유형별 발전 현황</a></li>--%>
			<%--					</ul>--%>
			<div class="tblDisplay">
				<div>
					<!-- 사업소별 현황 -->
					<div class="inchart">
						<div id="typeSiteCurrent"></div>
					</div>
					<!-- 데이터 추출용 테이블 -->
					<div class="hidden_table" style="display:none">
						<table id="gdatatable3">
							<thead>
							<tr>
								<th></th>
								<th><fmt:message key="gdash.3.actual" /></th>
								<th><fmt:message key="gdash.3.forecast" /></th>
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
						</div>
						<div class="type-right">
							<dl class="sun">
								<dt><span><fmt:message key="gdash.4.gen" /></span></dt>
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

	<div class="col-xl-8 col-md-12 col-sm-12">
		<div class="gmain_row1">
			<div class="indiv gmain_map gmain_chart gmain_chart4 ">
				<div class="chart_top clear">
					<h2 class="ntit"><fmt:message key="gdash.4.current" /></h2>
				</div>
				<div class="chart_box">
					<div class="chart_info">
						<div class="ci_left">
							<div class="inchart">
								<div id="pie_chart"></div>
							</div>
						</div>
						<div class="ci_right">
							<div class="legend_wrap">
								<span class="bu3">풍력</span>
								<span class="bu1"><fmt:message key="gdash.4.gen" /></span>
								<span class="bu4"><fmt:message key="gdash.4.idle" /></span>
							</div>
							<ul>
								<c:choose>
									<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
										<li><strong><fmt:message key="gdash.4.active_power" /></strong> <span> 0 </span><em>&nbsp;&nbsp;kW</em></li>
										<li><strong>목표전력</strong> <span> 0 </span><em>&nbsp;&nbsp;kW</em></li>
										<li><strong>설비용량</strong> <span> 0 </span><em>&nbsp;&nbsp;kW</em></li>
									</c:when>
									<c:otherwise>
										<li><strong><fmt:message key="gdash.4.today_gen" /></strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
										<li><strong><fmt:message key="gdash.4.forecast" /></strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
										<li><strong><fmt:message key="gdash.4.today_ess" /></strong> <span> - </span><em>&nbsp;&nbsp;Wh</em> / <span> - </span><em>&nbsp;&nbsp;Wh</em></li>
									</c:otherwise>
								</c:choose>
							</ul>
						</div>
					</div>
				</div>
				<div class="local_info s_center">
					<table>
						<thead>
						<c:choose>
							<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
							<tr>
								<th>구분</th>
								<th>사업소</th>
								<th>설비용량</th>
								<th>구분</th>
								<th>사업소</th>
								<th>설비용량</th>
							</tr>
							</thead>
							<tbody id="centerTbody">
							<tr>
								<td> 풍력 </td>
								<td> - </td>
								<td> - </td>
								<td> 태양광 </td>
								<td> - </td>
								<td> - </td>
							</tr>
							</c:when>
							<c:otherwise>
							<tr>
								<th><fmt:message key="gdash.4.tot_num" /></th>
								<th><fmt:message key="gdash.4.num_device" /></th>
								<th><fmt:message key="gdash.4.tot_cap" /></th>
								<th><fmt:message key="gdash.4.today_co2" /></th>
								<th><fmt:message key="gdash.4.today_revenue" /></th>
							</tr>
							</thead>
							<tbody id="centerTbody">
							<tr>
								<td><em>&nbsp;&nbsp;개소</em></td>
								<td><em>&nbsp;&nbsp;대</em></td>
								<td><em>&nbsp;&nbsp;kW</em></td>
								<td><em>&nbsp;&nbsp;kg</em></td>
								<td><em>&nbsp;&nbsp;천원</em></td>
							</tr>
							</c:otherwise>
						</c:choose>

						</tbody>
					</table>
				</div>
			</div>
			<div class="indiv gmain_alarm wrap_type">
				<div class="alarm_stat">
					<div class="a_alert"><span><fmt:message key="gdash.6.today_alerts" /></span><em>0</em></div><div class="a_warning"><a href="javascript:void(0);" onclick="pageMove('all', 'alarm');" class="btn cancel_btn"><fmt:message key="gdash.6.details" /></a></div>
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
		</div>
		<div class="gmain_row2">
			<div class="indiv gmain_table">
				<div class="gmain_map2">
					<div class="map_wrap" id="gMainMap"></div>
				</div>
				<div class="gmain_map2_content">
					<div class="gtbl_top clear">
						<div class="input_group1">
							<input type="text" class="input" id="searchName" name="searchName" value="" placeholder="사업소 검색" onkeyup="if (event.keyCode == 13) searchSiteList();">
							<button type="button" onclick="searchSite();"><fmt:message key="gdash.7.apply" /></button>
						</div>
						<div class="input_group2">
							<span class="tx_tit"><fmt:message key="gdash.7.status" /></span>
							<div class="sa_select">
								<div class="dropdown" id="deviceStatus">
									<button type="button" class="dropdown-toggle w8"
											data-toggle="dropdown" data-name="설비 상태">
										전체<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk_type" role="menu">
										<li data-value="0">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="0" checked>
												<label for="deviceStatus1">중지</label>
											</a>
										</li>
										<li data-value="1">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="1" checked>
												<label for="deviceStatus2">정상</label>
											</a>
										</li>
										<li data-value="2">
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
					<div class="gtbl_wrap">
						<div class="intable" id="statusSiteList">
							<table>
								<caption>(단위: kWh)</caption>
								<thead>
								<tr>
									<c:choose>
										<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.status" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.err" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.medium" /></button>
									</th>
									<th>
										<button type="button" class="btn_align">발전기</button>
									</th>
									<th>
										<button type="button" class="btn_align">현재출력</button>
									</th>
									<th>
										<button type="button" class="btn_align">목표출력</button>
									</th>
									<th>
										<button type="button" class="btn_align">무효전력</button>
									</th>
										</c:when>
										<c:otherwise>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.status" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.err" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.medium" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.site" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.cap" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.forecast" /></button>
									</th>
									<th>
										<button type="button" class="btn_align"><fmt:message key="gdash.7.gen" /></button>
									</th>
									<th class="ESS">
										<button type="button" class="btn_align"><fmt:message key="gdash.7.charge" /></button>
									</th>
									<th class="ESS">
										<button type="button" class="btn_align"><fmt:message key="gdash.7.discharge" /></button>
									</th>
										</c:otherwise>
									</c:choose>
								</tr>
								</thead>
								<tbody id="siteList">
									<!-- [D] 상태별 배경 : 't1' or 't2' 클래스 추가 -->
									<c:choose>
										<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
									<tr class="dbclickopen flag[INDEX]" data-sid="[sid]">
										<td class="first_td">
											<span class="status [statusClass]" title="[status]">[status]</span>
											<span class="st_bar"></span>
										</td>
										<td>[alarmError]</td>
										<td>[alarmWarning]</td>
										<td class="center">[name]</td>
										<td class="right">[activePower]</td>
										<td class="right">[targetActivePower]</td>
										<td class="right">[reactivePower]</td>
									</tr>
									<tr class="detail_info list[INDEX] flag[INDEX]">
										<td colspan="9">
											<div class="di_wrap">
												<div class="di_wrap_in">
													<div class="di_top_sec">
														<span class="ico [resourceClass]"></span>
														<div class="tx_area clear">
															<div class="fl">
																<span class="tx"><fmt:message key="gdash.7.irr" /></span>
																<span class="tx2">[irradiationPoa]</span>
															</div>
															<div class="fr">
																<span class="tx2"><fmt:message key="gdash.7.temp" /> [temperature]</span>
																<span class="tx2"><fmt:message key="gdash.7.humid" /> [humidity]</span>
															</div>
														</div>
													</div>
													<div class="di_btm_sec clear">
														<div class="sec_bx left">
															<div class="bx_in">
																<div class="bx_top">
																	<div class="inchart" id="type_chart[INDEX]"></div>
																</div>
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit">현재 유효출력 (kW)</span>
																		<span class="di_li_tx">[activePower]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">현재 무효출력 (kVar)</span>
																		<span class="di_li_tx">[reactivePower]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">ESS 유효출력 (kW)</span>
																		<span class="di_li_tx">[essActivePower]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">가용출력 (kW)</span>
																		<span class="di_li_tx">[maxActivePower]</span>
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
																		<span class="di_li_tit">목표출력 (kW)</span>
																		<span class="di_li_tx">[targetActivePower]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">송신시간</span>
																		<span class="di_li_tx">[lastTargetActivePowerReqDate]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">수신시간</span>
																		<span class="di_li_tx">[lastTargetActivePowerRecvDate]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">갱신시간</span>
																		<span class="di_li_tx">[statusLocalTime]</span>
																	</li>
																</ul>
																<div class="di_tx_bx">
																	<a href="javascript:void(0);"
																	   onclick="pageMove('[sid]', 'alarm')">
																		<p class="tx"><fmt:message key="gdash.7.num_no_ack" /> :
																			<span>[alarmTotal] 건</span></p>
																	</a>
																		<%--<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
																		<%--<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
																</div>
															</div>
														</div>
													</div>
													<div class="btn_bx clear">
														<a href="javascript:void(0);" onclick="pageMove('[sid]', 'siteMain')" class="btn_type02 fr"><fmt:message key="gdash.7.go_dashboard" /> <span class="ico_arrow"></span></a>
													</div>
												</div>
											</div>
										</td>
									</tr>
										</c:when>
										<c:otherwise>
									<tr class="dbclickopen flag[INDEX]" data-sid="[sid]">
										<td class="first_td">
											<span class="status status_drv" title="[status]">[status]</span>
											<span class="st_bar"></span>
										</td>
										<td>[alarmError]</td>
										<td>[alarmWarning]</td>
										<td class="center">[name]</td>
										<td class="right">[capacity]</td>
										<td class="right">[forecast]</td>
										<td class="right">[accumulate]</td>
										<td class="ESS">-</td>
										<td class="ESS">-</td>
									</tr>
									<tr class="detail_info list[INDEX] flag[INDEX]">
										<td colspan="9">
											<div class="di_wrap">
												<div class="di_wrap_in">
													<div class="di_top_sec">
														<span class="ico [resourceClass]"></span>
														<div class="tx_area clear">
															<div class="fl">
																<span class="tx"><fmt:message key="gdash.7.irr" /></span>
																<span class="tx2">[irradiationPoa] W/㎡</span>
															</div>
															<div class="fr">
																<span class="tx2"><fmt:message key="gdash.7.temp" /> [temperature]</span>
																<span class="tx2"><fmt:message key="gdash.7.humid" /> [humidity]</span>
															</div>
														</div>
													</div>
													<div class="di_btm_sec clear">
														<div class="sec_bx left">
															<div class="bx_in">
																<div class="bx_top">
																	<div class="inchart" id="type_chart[INDEX]"></div>
																</div>
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit"><fmt:message key="gdash.7.production" /> (kW)</span>
																		<span class="di_li_tx">[activePower]</span>
																	</li>
																	<li>
																		<span class="di_li_tit"><fmt:message key="gdash.7.gen_today" /> (kWh)</span>
																		<span class="di_li_tx">[accumulate]</span>
																	</li>
																	<li>
																		<span class="di_li_tit"><fmt:message key="gdash.7.gen_forecast" /> (kWh)</span>
																		<span class="di_li_tx">[forecast]</span>
																	</li>
																	<li>
																		<span class="di_li_tit"><fmt:message key="gdash.7.gen_yesterday" /> (kWh)</span>
																		<span class="di_li_tx">[beforeDay]</span>
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
																		<span class="di_li_tit"><fmt:message key="gdash.7.tot_cap" /> (kW)</span>
																		<span class="di_li_tx">[capacity]</span>
																	</li>
																	<li>
																		<span class="di_li_tit"><fmt:message key="gdash.7.num_inv" /> (EA)</span>
																		<span class="di_li_tx">[inverterCount]</span>
																	</li>
																</ul>
																<div class="di_tx_bx">
																	<a href="javascript:void(0);"
																	   onclick="pageMove('[sid]', 'alarm')">
																		<p class="tx"><fmt:message key="gdash.7.num_no_ack" /> :
																			<span>[alarmTotal] 건</span></p>
																	</a>
																		<%--<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
																		<%--<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
																</div>
															</div>
														</div>
													</div>
													<div class="btn_bx clear">
														<a href="javascript:void(0);" onclick="pageMove('[sid]', 'siteMain')" class="btn_type02 fr"><fmt:message key="gdash.7.go_dashboard" /> <span class="ico_arrow"></span></a>
													</div>
												</div>
											</div>
										</td>
									</tr>
										</c:otherwise>
									</c:choose>

								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="gmainTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:12%">
					<col style="width:16%">
					<col style="width:5%">
					<col style="width:6%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:10%">
					<col style="width:14%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>


<script type="text/javascript" src="/js/commonDropdown.js"></script>

<c:choose>
	<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
	<script type="text/javascript" src="/js/dashboard-kpx.js"></script>
	</c:when>
	<c:otherwise>
	<script type="text/javascript" src="/js/dashboard.js"></script>
	</c:otherwise>
</c:choose>

<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	const sgid = '<c:out value="${sgid}" escapeXml="false" />';
	const today = new Date();

	<c:if test="${dashboardMap eq 'google'}">
	let makerObject = new Object();

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
	let first = true;

	$(function () {
		if (oid.match('testkpx')) {
			resourceProperties();
		}

		setInitList('alarmNotice'); //알람 공지 세팅
		//resourceProperties();

		makeSiteList();
		if (!isEmpty(siteList) && siteList.length > 0) {
			fn_cycle_1hour();
			fn_cycle_1min();
			setInterval(() => fn_cycle_1hour(), 60 * 60 * 1000);
			setInterval(() => fn_cycle_1min(), 60 * 1000);
		} else {
			$("#errMsg").text("해당 그룹에 등록 된 사이트가 존재하지 않습니다.");
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			return false;
		}
		$("#switchBtn").on("change", function(){

		});
	});

	function switchView(){
		
	}

	function fn_cycle_1hour() {
		if (!first) {
			if (oid.match('testkpx')) {
				getYearGenDataKPX();
			} else {
				getYearGenData();
				getDailyGenData();
				getGenDataBySiteYesterday();
			}
			searchSiteList();
		}

		const now = new Date();
		$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
	}

	function fn_cycle_1min() {
		// getTodayTotalDetail();
		beforeTodayTotal();
		getAlarmInfo();

		const now = new Date();
		$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
	}

	<c:if test="${dashboardMap eq 'google'}">
	const geocodeAddress = (siteAddr, siteId, siteName, siteLatlng, siteColor) => {
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

		marker.infowindow = new google.maps.InfoWindow({
			content: siteName
		});

		makerObject[siteId] = marker;
		google.maps.event.addListener(makerObject[siteId], 'click', (function (makerArray, siteId) {
			return function () {
				$.map(makerObject, function(val, key) {
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
		return {
			path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z M -2,-30 a 2,2 0 1,1 4,0 2,2 0 1,1 -4,0',
			fillColor: color,
			fillOpacity: 1,
			strokeColor: 'var(--white87)',
			strokeWeight: 1,
			scale: 1,
		};
	}

	const list_detail_open_main = (sid) => {
		$('.dbclickopen').each(function() {
			if ($(this).data('sid') == sid) {
				let target = $(this);
				target.next().find('.di_wrap').slideDown( function() {
					$('.gtbl_wrap').animate({scrollTop:target.position().top}, 1000);
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

	const rtnDropdown = () => {
		searchSite();
	}

	const pageMove = (id, action) => {
		let $form = $('#linkSiteForm');
		let $inp = $('<input>').attr('type', 'hidden').attr('name', 'sid').val(id);

		$form.append($inp);
		if (action == 'alarm') {
			$form.attr('action', '/history/alarmHistory.do').submit();
		} else {
			$form.attr('action', '/dashboard/smain.do').submit();
		}
	}
</script>