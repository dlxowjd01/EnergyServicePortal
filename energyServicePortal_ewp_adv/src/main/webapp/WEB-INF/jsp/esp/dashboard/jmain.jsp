<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<%@ include file="/decorators/include/dashboardSchForm.jsp" %>
<!-- 메인페이지용 스타일/스크립트 파일 -->
<script type="text/javascript" src="/js/modules/rounded-corners.js"></script>
<script type="text/javascript" src="/js/jquery.rwdImageMaps.min.js"></script>
<script type="text/javascript"
        src="http://maps.google.com/maps/api/js?key=AIzaSyAyGrAQC_675C34l2ZJ5JgEqeEV3gLuY9I"></script>
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">${siteName}</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row content-wrapper">
	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv gmain_chart gmain_chart1">
			<div class="chart_top clear">
				<h2 class="ntit">월간</h2>
				<span class="term"></span>
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
				<h2 class="ntit">일간</h2>
				<span class="term"></span>
			</div>
			<div class="inchart">
				<div id="dailyChart"></div>
			</div>
		</div>
		<div class="indiv gmain_chart gmain_chart3">
			<div class="chart_top clear">
				<h2 class="ntit">전일</h2>
				<span class="term"></span>
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
				</div>
			</div>
		</div>
	</div>

	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv gmain_map gmain_chart gmain_chart4 ">
			<div class="chart_top clear">
				<h2 class="ntit">현재 출력</h2>
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
							<span class="bu1">태양광</span>
							<span class="bu4">미 사용량</span>
						</div>
						<ul>
							<li><strong>금일 누적발전량</strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
							<li><strong>금일 예측발전량</strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
							<li><strong>금일 충/방전</strong> <span> - </span><em>&nbsp;&nbsp;Wh</em> /
								<span> - </span><em>&nbsp;&nbsp;Wh</em></li>
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
						<td><em>&nbsp;&nbsp;개소</em></td>
						<td><em>&nbsp;&nbsp;대</em></td>
						<td><em>&nbsp;&nbsp;kW</em></td>
						<td><em>&nbsp;&nbsp;kg</em></td>
						<td><em>&nbsp;&nbsp;천원</em></td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="indiv gmain_chart jmain_center2">
			<div class="chart_top clear">
				<h2 class="ntit">실시간 실적</h2>
			</div>
			<div class="realtime clear" style="position:relative;">
				<div class="realtime_by_site">
					<div id="rchart1"></div>
				</div>
				<div class="realtime_total">
					<div id="rchart2"></div>
				</div>
				<div class="realtime_time"></div>
				<div class="realtime_label"></div>
			</div>
		</div>
		<div class="indiv gmain_chart jmain_center3">
			<div class="chart_top clear">
				<h2 class="ntit">입찰 현황</h2>
			</div>
			<div class="realtime_wrap">
				<div class="inchart">
					<div id="rchart3"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv jmain_alarm wrap_type">
			<div class="alarm_stat clear">
				<div class="a_alert clear"><span>금일 발생 오류</span><em>0</em></div><div class="a_warning clear"><a href="javascript:void(0);" onclick="pageMove('all', 'alarm');" class="btn cancel_btn">상세보기</a></div>
			</div>
			<div class="alarm_notice">
				<ul id="alarmNotice">
					<li>
						<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');">
							<span class="err_msg">[site_name] - [message]</span>
							<span class="err_time">[standardTime]</span>
						</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="indiv gmain_table jmain_table">
			<div class="gtbl_top clear">
				<div class="input_group1">
					<input type="text" class="input" id="searchName" name="searchName" value="" placeholder="사업소 검색" onkeyup="if (event.keyCode == 13) searchSiteList();">
					<button type="button" onclick="searchSite();">적용</button>
				</div>
				<div class="input_group2">
					<span class="tx_tit">설비 상태</span>
					<div class="sa_select">
						<div class="dropdown" id="deviceStatus">
							<button class="btn btn-primary dropdown-toggle w8" type="button"
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
				<div class="intable">
					<table>
						<caption>(단위: kWh)</caption>
						<thead>
						<tr>
							<th>
								<button class="btn_align">설비상태</button>
							</th>
							<th>
								<button class="btn_align">오류</button>
							</th>
							<th>
								<button class="btn_align">경고</button>
							</th>
							<th>
								<button class="btn_align">사업소</button>
							</th>
							<th>
								<button class="btn_align">설비용량</button>
							</th>
							<th>
								<button class="btn_align">금일예측</button>
							</th>
							<th>
								<button class="btn_align">금일누적</button>
							</th>
							<th>
								<button class="btn_align">금일충전</button>
							</th>
							<th>
								<button class="btn_align">금일방전</button>
							</th>
						</tr>
						</thead>
						<tbody id="siteList">
							<!-- [D] 상태별 배경 : 't1' or 't2' 클래스 추가 -->
							<tr class="dbclickopen flag[INDEX]">
								<td class="first_td">
									<%--<span class="status status_err" title="통신이상">통신이상</span>--%>
									<span class="status status_drv" title="[status]">[status]</span>
									<span class="st_bar"></span>
								</td>
								<td>[alarmError]</td>
								<td>[alarmWarning]</td>
								<td class="left">[name]</td>
								<td class="right">[capacity]</td>
								<td class="right">[forecast]</td>
								<td class="right">[accumulate]</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr class="detail_info list[INDEX] flag[INDEX]">
								<td colspan="9">
									<div class="di_wrap">
										<div class="di_wrap_in">
											<div class="di_top_sec">
												<span class="ico solar"></span>
												<div class="tx_area clear">
													<div class="fl">
														<span class="tx">일사량</span>
														<span class="tx2">[irradiationPoa] W/㎡</span>
													</div>
													<div class="fr">
														<span class="tx2">온도 [temperature]</span>
														<span class="tx2">습도 [humidity]</span>
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
																<span class="di_li_tit">설비 출력 (kW)</span>
																<span class="di_li_tx">[activePower]</span>
															</li>
															<li>
																<span class="di_li_tit">금일 누적발전 (kWh)</span>
																<span class="di_li_tx">[accumulate]</span>
															</li>
															<li>
																<span class="di_li_tit">금일 예측발전 (kWh)</span>
																<span class="di_li_tx">[forecast]</span>
															</li>
															<li>
																<span class="di_li_tit">전일 총발전량 (kWh)</span>
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
																<span class="di_li_tit">총 설비용량 (kW)</span>
																<span class="di_li_tx">[capacity]</span>
															</li>
															<li>
																<span class="di_li_tit">총 인버터수량 (EA)</span>
																<span class="di_li_tx">[inverterCount]</span>
															</li>
														</ul>
														<div class="di_tx_bx">
															<a href="javascript:void(0);"
																onclick="pageMove('[sid]', 'alarm')">
																<p class="tx">최근 미처리 오류 :
																	<span>[alarmTotal] 건</span></p>
															</a>
															<%--<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
															<%--<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
														</div>
													</div>
												</div>
											</div>
											<div class="btn_bx clear">
												<a href="javascript:void(0);" onclick="pageMove('[sid]', 'siteMain')" class="btn_type02 fr">대시 보드 보기 <span class="ico_arrow"></span></a>
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

<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript" src="/js/dashboard.js"></script>
<script type="text/javascript">
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');
	const sgid = '<c:out value="${sgid}" escapeXml="false" />';
	const today = new Date();

	let actualCount = 0;
	let forecastCount = 0;

	let foreCastHourCount = 0;
	let foreCastDayCount = 0;
	let nowHour = false;
	let nowDay = false;

	let pvListHourly = new Array();
	let pvListForecastingHourly = new Array();

	let first = true;

	function fn_cycle_1hour() {
		getYearGenData();
		getDailyGenData();
		getGenDataBySiteYesterday();

		if (!first) {
			searchSiteList();
		}

		const now = new Date();
		$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
	}

	function fn_cycle_1min() {
		//getTodayTotalDetail();
		beforeTodayTotal();
		getAlarmInfo();
		realtimeRecord();

		const now = new Date();
		$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
	}

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

	const realtimeRecord = () => {
		const formDataHour = getSiteMainSchCollection('hour');
		const formDataDay = getSiteMainSchCollection('day');

		let siteArray = new Array();

		pvListHourly = new Array(24).fill(0);
		pvListForecastingHourly = new Array(24).fill(0);

		actualCount = 0;
		forecastCount = 0;
		foreCastHourCount = 0;
		foreCastDayCount = 0;
		nowHour = false;
		nowDay = false;

		siteList.forEach((site, siteIdx) => {
			siteArray.push(site.sid);

			$.ajax({
				url: 'http://iderms.enertalk.com:8443/energy/sites',
				type: 'get',
				data: {
					sid: site.sid,
					startTime: formDataDay.startTime,
					endTime: formDataDay.endTime,
					interval: 'hour'
				},
			}).done(function (data, textStatus, jqXHR) {
				data.data[0].generation.items.map((e) => {
					if (e.energy) {
						const hour = Number(e.basetime.toString().slice(8, 10));
						pvListHourly[hour] += Math.floor(e.energy / 1000);
					}
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);
			}).always(function (jqXHR, textStatus) {
				setRealtimeRecord('actual');
			});

			$.ajax({
				url: 'http://iderms.enertalk.com:8443/energy/forecasting/sites',
				type: 'get',
				data: {
					sid: site.sid,
					startTime: formDataDay.startTime,
					endTime: formDataDay.endTime,
					interval: 'hour'
				},
			}).done(function (data, textStatus, jqXHR) {
				data.data[0].generation.items.map((e) => {
					if (e.energy) {
						const hour = Number(e.basetime.toString().slice(8, 10));
						pvListForecastingHourly[hour] += Math.floor(e.energy / 1000);
					}
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);
			}).always(function (jqXHR, textStatus) {
				setRealtimeRecord('forecast');
			});

			//사이트별 현재 시간 예측
			$.ajax({
				url: 'http://iderms.enertalk.com:8443/energy/forecasting/sites',
				type: 'get',
				data: {
					sid: site.sid,
					startTime: formDataHour.startTime,
					endTime: formDataHour.endTime,
					interval: 'hour'
				},
			}).done(function (data, textStatus, jqXHR) {
				if(isEmpty(data.data[0].generation.items[0])) {
					siteList[siteIdx].hourForecastingGenBySite = 0;
				} else {
					siteList[siteIdx].hourForecastingGenBySite = Math.floor(data.data[0].generation.items[0].energy / 1000);
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);
			}).always(function (jqXHR, textStatus) {
				setRealtimeRecord('foreCastHour');
			});

			//사이트별 오늘 예측
			$.ajax({
				url: 'http://iderms.enertalk.com:8443/energy/forecasting/sites',
				type: 'get',
				data: {
					sid: site.sid,
					startTime: formDataDay.startTime,
					endTime: formDataDay.endTime,
					interval: 'day'
				},
			}).done(function (data, textStatus, jqXHR) {
				//사이트 합 오늘 예측량 더하기
				if(isEmpty(data.data[0].generation.items[0])) {
					siteList[siteIdx].todayForecastingGenBySite = 0;
				} else{
					siteList[siteIdx].todayForecastingGenBySite = Math.floor(data.data[0].generation.items[0].energy / 1000);
				}
				// todayForecastingGenAllSite += todayForecastingGenBySite;
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);
			}).always(function (jqXHR, textStatus) {
				setRealtimeRecord('foreCastDay');
			});
		});

		//사이트별 현재 시간 출력
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/now/sites',
			type: 'get',
			data: {
				sids: siteArray.join(','),
				metering_type: 2,
				interval: 'hour'
			},
		}).done(function (data, textStatus, jqXHR) {
			siteList.forEach((site, siteIdx) => {
				if(isEmpty(data.data[site.sid])) {
					siteList[siteIdx].hourGenBySite = 0;
				} else {
					siteList[siteIdx].hourGenBySite = Math.floor(data.data[site.sid].energy / 1000);
				}
			});
			setRealtimeRecord('nowHour');
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});

		//사이트별 오늘 출력
		$.ajax({
			url: 'http://iderms.enertalk.com:8443/energy/now/sites',
			type: 'get',
			data: {
				sids: siteArray.join(','),
				metering_type: 2,
				interval: 'day'
			},
		}).done(function (data, textStatus, jqXHR) {
			siteList.forEach((site, siteIdx) => {
				if(isEmpty(data.data[site.sid])) {
					siteList[siteIdx].todayGenBySite = 0;
				} else {
					siteList[siteIdx].todayGenBySite = Math.floor(data.data[site.sid].energy / 1000);
				}
			});
			//todayGenAllSite += todayGenBySite;
			setRealtimeRecord('nowToday');
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	const setRealtimeRecord = (type) => {
		if (type == 'foreCastHour') {
			foreCastHourCount++;
		} else if (type == 'foreCastDay') {
			foreCastDayCount++;
		} else if (type == 'nowHour') {
			nowHour = true;
		} else if (type == 'nowToday') {
			nowDay = true;
		} else if (type == 'actual') {
			actualCount++;
		} else if (type == 'forecast') {
			forecastCount++;
		}

		//조회가 완료 되면 다음 프로세스 진행
		if (foreCastHourCount == siteList.length && foreCastDayCount == siteList.length && nowHour && nowDay
			&& actualCount == siteList.length && forecastCount == siteList.length) {
			let todayGenAllSite = 0;
			let hourGenAllSite = 0;
			let hourForecastingGenAllSite = 0;
			let ratioDaily = 0;
			let restDaily = 0;
			let seriesData = new Array();

			siteList.forEach((site, siteIdx) => {
				let ratioHourly = 0;
				let siteArray = new Array();

				hourGenAllSite += site.hourGenBySite;
				hourForecastingGenAllSite += site.hourForecastingGenBySite;

				if(site.todayForecastingGenBySite == 0 && site.todayGenBySite == 0) {
					ratioDaily = 0;
				} else {
					if (site.todayForecastingGenBySite <= site.todayGenBySite) {
						restDaily = null;
						ratioDaily = 100;
					} else {
						ratioDaily = Math.floor((site.todayGenBySite / site.todayForecastingGenBySite) * 100);
						restDaily = 100 - ratioDaily
					}
				}

				if(site.hourForecastingGenBySite == 0 && site.hourGenBySite == 0) {
					ratioHourly = 0;
				} else {
					if (site.hourForecastingGenBySite <= site.hourGenBySite) {
						ratioHourly = 100;
					} else {
						ratioHourly = Math.floor((site.hourGenBySite / site.hourForecastingGenBySite) * 100);
					}
				}

				//rchart1 변경
				siteArray.push(site.name);
				siteArray.push(10);
				siteArray.push(10);
				seriesData.push(siteArray);
			});

			rchart1.update({
				series: [{
					name: '실시간 출력량',
					data: seriesData,
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
				}]
			});
			rchart1.redraw();

			let totalRestHourly;
			let totalRatioHourly;
			if (hourForecastingGenAllSite <= hourGenAllSite) {
				totalRestHourly = null;
				totalRatioHourly = 100;
			} else {
				totalRatioHourly = Math.floor((hourGenAllSite / hourForecastingGenAllSite) * 100);
				totalRestHourly = 100 - totalRatioHourly;
			}

			//rchart2 변경
			rchart2.update({
				series: [{
					name: '입찰',
					data: [totalRestHourly],
					tooltip: {
						valueSuffix: '%'
					},
					dataLabels: {
						enabled: true
					},
					color: '#575757' /* 입찰 */
				}, {
					name: '출력',
					data: [totalRatioHourly],
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

			//입찰 현황 차트
			const nowHour = new Date().getHours();
			pvListHourly[nowHour] = Math.floor(todayGenAllSite / 1000);
			rChart3.update({
				series: [{
					name: '출력',
					type: 'column',
					color: '#2BEEE9',
					data: pvListHourly,
					tooltip: {
						valueSuffix: 'kWh'
					}
				}, {
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
			let currentTime = new Date().getHours() + ':' + new Date().getMinutes();
			let label = `${' 현재시간<br>${ currentTime }'}`;
			console.log(label)
			const now = new Date().getMinutes();
			const nowBottom = parseInt($('.realtime_time').css('bottom'), 10);
			
			if (nowBottom >= 206) {
				$(".realtime_label").html(label).css('bottom', '44px');
				$('.realtime_time').css('bottom', '63px');
			} else {
				$(".realtime_label").html(label).css('bottom', 44 + ((206 / 60) * now));
				$('.realtime_time').css('bottom', 63 + ((206 / 60) * now));
			}
		}
	}

	const rchart1 = Highcharts.chart('rchart1', {
		chart: {
			marginTop: 15,
			marginLeft: 50,
			marginRight: 0,
			paddingRight: 30,
			zoomType: 'xy',
			backgroundColor: 'transparent',
			type: 'variwide',
			height: 255
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
			lineColor: 'var(--color4)', /* 눈금선색 */
			tickColor: 'var(--color4)',
			gridLineColor: 'var(--color4)',
			plotLines: [{
				color: 'var(--color1)',
				width: 1
			}],
			labels: {
				align: 'center',
				//reserveSpace: true,
				rotation: 0,
				y: 27, /* 그래프와 거리 */
				style: {
					color: 'var(--color4)',
					fontSize: '10px'
				}
			},
			tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
			title: {
				text: null
			}
		},
		yAxis: {
			min: 0,
			max: 100,
			lineColor: 'var(--color4)', /* 눈금선색 */
			tickColor: 'var(--color4)',
			gridLineColor: 'var(--color4)',
			gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
			plotLines: [{
				color: 'var(--color4)',
				width: 1
			}],
			scrollbar: {
                enabled: true,
                showFull: false
            },
			title: {
				text: '%',
				align: 'low',
				rotation: 0, /* 타이틀 기울기 */
				y: 25, /* 타이틀 위치 조정 */
				x: 15,
				style: {
					color: 'var(--color4)',
					fontSize: '12px'
				}
			},
			labels: {
				format: '{value}',
				style: {
					color: 'var(--color4)',
					fontSize: '12px'
				},
				align: 'right',
				x: 0,
				y: -2
			},
			opposite: true
		},
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
				borderWidth: 0,
				pointPadding: .2
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
			data: null,
			dataLabels: {
				enabled: true,
				inside: true,
				format: '{point.y:.0f} %'
			},
			tooltip: {
				pointFormat: '출력: <b>{point.y} %</b>' + ''
			},
			colorByPoint: true
		}],

		/* 출처 */
		credits: {
			enabled: false
		}
	});

	const rchart2 = Highcharts.chart('rchart2', {
		chart: {
			marginTop: 5,
			marginLeft: 0,
			marginRight: 0,
			backgroundColor: 'transparent',
			type: 'column',
			height: 260
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
			tickColor: 'var(--color4)',
			gridLineColor: 'var(--color4)',
			labels: {
				enabled: false,
				align: 'right',
				reserveSpace: true,
				style: {
					color: 'var(--color4)',
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
			lineColor: 'var(--color4)',
			tickColor: 'var(--color4)',
			gridLineColor: 'var(--color4)',
			gridLineWidth: 0,
			min: 0,
			title: {
				text: '',
				style: {
					color: 'var(--color4)',
					fontSize: '12px'
				}
			},
			labels: {
				enabled: false,
				overflow: 'justify',
				x: -10, /* 그래프와의 거리 조정 */
				style: {
					color: 'var(--color4)',
					fontSize: '12px'
				}
			}
		},

		/* 범례 */
		legend: {
			enabled: false,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -10,
			itemStyle: {
				color: 'var(--color4)',
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
			data: [],
			tooltip: {
				valueSuffix: '%'
			},
			dataLabels: {
				enabled: true
			},
			color: '#575757' /* 입찰 */
		}, {
			name: '출력',
			data: [],
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
						symbolPadding: 5,
						symbolHeight: 10
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

	const rChart3 = Highcharts.chart('rchart3', {
		chart: {
			marginTop: 40,
			marginLeft: 50,
			marginRight: 0,
			backgroundColor: 'transparent',
			type: 'column',
			height: 300
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
			lineColor: 'var(--color4)', /* 눈금선색 */
			tickColor: 'var(--color4)',
			gridLineColor: 'var(--color4)',
			plotLines: [{
				color: 'var(--color4)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27, /* 그래프와 거리 */
				style: {
					color: 'var(--color4)',
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
			lineColor: 'var(--color4)', /* 눈금선색 */
			tickColor: 'var(--color4)',
			gridLineColor: 'var(--color4)',
			plotLines: [{
				color: 'var(--color4)',
				width: 1
			}],
			gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
			min: 0, /* 최소값 지정 하면 + 만 나옴 */
			title: {
				text: 'kWh',
				align: 'low',
				rotation: 0, /* 타이틀 기울기 */
				y: 25, /* 타이틀 위치 조정 */
				x: 10,
				style: {
					color: 'var(--color4)',
					fontSize: '12px'
				}
			},
			labels: {
				overflow: 'justify',
				x: -10, /* 그래프와의 거리 조정 */
				style: {
					color: 'var(--color4)',
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
				color: 'var(--color4)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: '' /* 마우스 오버시 색 */
			},
			symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
			symbolHeight: 7 /* 심볼 크기 */
		},

		series: [{
			name: '출력',
			type: 'column',
			color: '#2BEEE9',
			data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			tooltip: {
				valueSuffix: 'kWh'
			}
		}, {
			name: '입찰',
			type: 'column',
			color: '#878787',
			data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
				borderColor: 'var(--color4)',
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


	$(function () {
		setInitList('alarmNotice'); //알람 공지 세팅
		setInitList('siteList'); //사이트 리스트

		fn_cycle_1hour();
		fn_cycle_1min();
		setInterval(() => fn_cycle_1hour(), 60 * 60 * 1000);
		setInterval(() => fn_cycle_1min(), 60 * 1000);
	});
</script>









