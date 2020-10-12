<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
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
	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv gmain-chart gmain-chart1">
			<div class="chart-top clear">
				<h2 class="ntit"><fmt:message key="vppdash.1.month" /></h2>
				<span class="term"></span>
			</div>
			<%--					<div class="no-data">--%>
			<%--						<span>올해 발전량 정보를 가져올 수 없습니다.</span>--%>
			<%--					</div>--%>
			<div class="inchart">
				<div id="monthlyChart"></div>
			</div>
		</div>
		<div class="indiv gmain-chart gmain-chart2">
			<div class="chart-top clear">
				<h2 class="ntit"><fmt:message key="vppdash.2.daily" /></h2>
				<span class="term"></span>
			</div>
			<div class="inchart">
				<div id="dailyChart"></div>
			</div>
		</div>
		<div class="indiv gmain-chart gmain-chart3">
			<div class="chart-top clear">
				<h2 class="ntit"><fmt:message key="vppdash.3.yesterday" /></h2>
				<span class="term"></span>
			</div>
			<%--					<ul class="gtab-menu">--%>
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
					<div class="hidden" style="display:none">
						<table id="gdatatable3">
							<thead>
							<tr>
								<th></th>
								<th><fmt:message key="vppdash.3.actual" /></th>
								<th><fmt:message key="vppdash.3.forecast" /></th>
							</tr>
							</thead>
							<tbody id="siteGenTbody">
							</tbody>
						</table>
					</div>
				</div>
				<div>
					<!-- 유형별 발전 현황 -->
					<div class="chart-sa type-table">
						<div class="inchart type-left">
							<div id="gchart4"></div>
						</div>
						<div class="type-right">
							<dl class="sun">
								<dt><span><fmt:message key="vppdash.4.gen" /></span></dt>
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
		<div class="indiv gmain-map gmain-chart gmain-chart4 ">
			<div class="chart-top clear">
				<h2 class="ntit"><fmt:message key="vppdash.4.current" /></h2>
			</div>
			<div class="chart-box">
				<div class="chart-info">
					<div class="ci-left">
						<div class="inchart">
							<div id="pie_chart"></div>

						</div>
					</div>
					<div class="chart-info-right">
						<div class="legend-wrap">
							<span class="bu1"><fmt:message key="vppdash.4.gen" /></span>
							<span class="bu4"><fmt:message key="vppdash.4.idle" /></span>
						</div>
						<ul>
							<li><strong><fmt:message key="vppdash.4.today_gen" /></strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
							<li><strong><fmt:message key="vppdash.4.forecast" /></strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
							<li><strong><fmt:message key="vppdash.4.today_ess" /></strong> <span> - </span><em>&nbsp;&nbsp;Wh</em> /
								<span> - </span><em>&nbsp;&nbsp;Wh</em></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="local-info s-center">
				<table>
					<thead>
					<tr>
						<th><fmt:message key="vppdash.4.tot_num" /></th>
						<th><fmt:message key="vppdash.4.num_device" /></th>
						<th><fmt:message key="vppdash.4.tot_cap" /></th>
						<th><fmt:message key="vppdash.4.today_co2" /></th>
						<th><fmt:message key="vppdash.4.today_revenue" /></th>
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
		<div class="indiv gmain-chart jmain-center2">
			<div class="chart-top clear">
				<h2 class="ntit"><fmt:message key="vppdash.5.realtime_result" /></h2>
			</div>
			<div class="realtime clear" style="position:relative;">
				<div class="realtime-site">
					<div id="rchart1"></div>
				</div>
				<div class="realtime-total">
					<div id="rchart2"></div>
				</div>
				<div class="realtime-time"></div>
				<div class="realtime-label"></div>
			</div>
		</div>
		<div class="indiv gmain-chart jmain-center3">
			<div class="chart-top clear">
				<h2 class="ntit"><fmt:message key="vppdash.6.bid_status" /></h2>
			</div>
			<div class="realtime-wrap">
				<div class="inchart">
					<div id="rchart3"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv jmain-alarm wrap-type" data-alarm="">
			<div class="alarm-status">
				<div class="alarm-alert"><span><fmt:message key="vppdash.7.today_alerts"/></span><em>0</em></div>
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
		<div class="indiv gmain-table jmain-table">
			<div class="gtable-top clear">
				<div class="input-group1">
					<input type="text" class="input" id="searchName" name="searchName" value="" placeholder="사업소 검색" onkeyup="if (event.keyCode == 13) searchSiteList();">
					<button type="button" onclick="searchSite();"><fmt:message key="vppdash.8.apply" /></button>
				</div>
				<div class="input-group2">
					<span class="tx-tit"><fmt:message key="vppdash.8.status" /></span>
					<div class="sa-select">
						<div class="dropdown" id="deviceStatus">
							<button type="button" class="dropdown-toggle w8"
									data-toggle="dropdown" data-name="설비 상태">
								전체<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk-type" role="menu">
								<li data-value="0">
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="0" checked>
										<label for="deviceStatus1">중지</label>
									</a>
								</li>
								<li data-value="1">
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="1" checked>
										<label for="deviceStatus2"><fmt:message key="vppdash.8.low" /></label>
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
			<div class="gmain-wrap">
				<div class="intable" id="statusSiteList">
					<table>
						<caption>(단위: kWh)</caption>
						<thead>
						<tr>
							<th>
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.status" /></button>
							</th>
							<th>
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.err" /></button>
							</th>
							<th>
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.warn" /></button>
							</th>
							<th>
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.site" /></button>
							</th>
							<th>
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.cap" /></button>
							</th>
							<th>
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.forecast" /></button>
							</th>
							<th>
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.gen" /></button>
							</th>
							<th class="ESS">
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.charge" /></button>
							</th>
							<th class="ESS">
								<button type="button" class="btn-align"><fmt:message key="vppdash.8.discharge" /></button>
							</th>
						</tr>
						</thead>
						<tbody id="siteList">
							<tr class="dbclickopen flag[INDEX]">
								<td class="first-td">
									<span class="status [statusClass]" title="[status]">[status]</span>
									<span class="status-bar"></span>
								</td>
								<td>[alarmError]</td>
								<td>[alarmWarning]</td>
								<td class="left">[name]</td>
								<td class="right">[capacityView]</td>
								<td class="right">[forecast]</td>
								<td class="right">[accumulate]</td>
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
														<span class="tx"><fmt:message key="vppdash.8.irr" /></span>
														<span class="tx2">[irradiationPoa] W/㎡</span>
													</div>
													<div class="fr">
														<span class="tx2"><fmt:message key="vppdash.8.temp" /> [temperature]</span>
														<span class="tx2"><fmt:message key="vppdash.8.humid" /> [humidity]</span>
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
																<span class="di-li-title"><fmt:message key="vppdash.8.production" /> (kW)</span>
																<span class="di-li-text">[activePowerView]</span>
															</li>
															<li>
																<span class="di-li-title"><fmt:message key="vppdash.8.gen_today" /> (kWh)</span>
																<span class="di-li-text">[accumulate]</span>
															</li>
															<li>
																<span class="di-li-title"><fmt:message key="vppdash.8.gen_forecast" /> (kWh)</span>
																<span class="di-li-text">[forecast]</span>
															</li>
															<li>
																<span class="di-li-title"><fmt:message key="vppdash.8.gen_yesterday" /> (kWh)</span>
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
																<span class="di-li-title"><fmt:message key="vppdash.8.tot_cap" /> (kW)</span>
																<span class="di-li-text">[capacityView]</span>
															</li>
															<li>
																<span class="di-li-title"><fmt:message key="vppdash.8.num_inv" /> (EA)</span>
																<span class="di-li-text">[inverterCount]</span>
															</li>
														</ul>
														<div class="di-text-box">
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
											<div class="btn-box clear">
												<a href="javascript:void(0);" onclick="pageMove('[sid]', 'siteMain')" class="btn-type02 fr">대시 보드 보기 <span class="line-arrow"></span></a>
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
<script type="text/javascript">
	const secondYAxis = ${secondYAxis};
</script>

<script type="text/javascript" src="/js/dashboard/dashboardV2.js"></script>
<script type="text/javascript" src="/js/dashboard/dashboardChart.js"></script>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	const vgid = '<c:out value="${vgid}" escapeXml="false" />';
	const today = new Date();

	let first = true;

	$(function () {
		if (isEmpty(siteList)) {
			$('#errMsg').text('해당 그룹에 등록 된 사이트가 존재하지 않습니다.');
			$('#errorModal').modal("show");
			setTimeout(function(){
				$('#errorModal').modal("hide");
			}, 2000);
			// alert('해당 그룹에 등록 된 사이트가 존재하지 않습니다.');
			return false;
		} else {
			firstAjax();

			setInterval(() => firstAjax(), 60 * 60 * 1000); // 한시간에 한번 화면갱신
			setInterval(() => {
				minIntervalCount++;
				if ((minIntervalCount % 60) !== 0) {
					minAjax();
				}
			}, 60 * 1000); //1분에 한번 현재혆황 & 알림 갱신
		}
	});

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

	const setRealtimeRecord = async () => {
		const targetApi = [apiHost + '/energy/sites?interval=hour',
							apiHost + '/energy/forecasting/sites?interval=hour&startTime=' + dayData.startTime + '&endTime=' + dayData.endTime,
							apiHost + '/energy/forecasting/sites?interval=hour&startTime=' + hourData.startTime + '&endTime=' + hourData.endTime,
							apiHost + '/energy/forecasting/sites?interval=day&startTime=' + dayData.startTime + '&endTime=' + dayData.endTime,
							apiHost + '/energy/now/sites?interval=hour',
							apiHost + '/energy/now/sites?interval=day'];

		new Promise(resolve => {
			const pvListHourly = new Array(24).fill(0);
			const pvListForeHourly = new Array(24).fill(0);
			const hourForeGenBySite = new Object();
			const todayForeGenBySite = new Object();
			const hourGenBySite = new Object();
			const todayGenBySite = new Object();

			targetApi.forEach((targetUrl, index) => {
				const apiData = apiDatas[targetUrl];
				if (index === 0 || index === 1 || index === 2 || index === 3) {
					if (!isEmpty(apiData)) {
						const siteNowEnergyData = apiData['data'];
						if (!isEmpty(siteNowEnergyData)) {
							Object.entries(siteNowEnergyData).forEach(([siteId, energyData]) => {
								if (!isEmpty(energyData)) {
									energyData.forEach(rowData => {
										const items = rowData['items'];
										if (!isEmpty(items)) {
											items.forEach(item => {
												const hour = Number(String(item['basetime']).slice(8, 10));
												if (index === 0) {
													pvListHourly[hour] += Math.floor(item['energy'] / 1000);
												} else if (index === 1) {
													pvListForeHourly[hour] += Math.floor(item['energy'] / 1000);
												} else if (index === 2) {
													if (isEmpty(hourForeGenBySite[siteId])) hourForeGenBySite[siteId] = 0;
													hourForeGenBySite[siteId] += Math.floor(item['energy'] / 1000);
												} else {
													if (isEmpty(todayForeGenBySite[siteId])) todayForeGenBySite[siteId] = 0;
													todayForeGenBySite[siteId] += Math.floor(item['energy'] / 1000);
												}
											});
										}
									});
								}
							});
						}
					}
				} else {
					if (!isEmpty(apiData)) {
						const siteNowEnergyData = apiData['data'];
						Object.entries(siteNowEnergyData).forEach(([siteId, siteData]) => {
							if (!isEmpty(siteData) && !isEmpty(siteData['energy']) ) {
								if (index === 4) {
									if (isEmpty(hourGenBySite[siteId])) hourGenBySite[siteId] = 0;
									hourGenBySite[siteId] += Math.floor(siteData['energy'] / 1000);
								} else {
									if (isEmpty(todayGenBySite[siteId])) todayGenBySite[siteId] = 0;
									todayGenBySite[siteId] += Math.floor(siteData['energy'] / 1000);
								}
							}
						});
					}
				}
			});

			resolve({
				pvListHourly: pvListHourly,
				pvListForeHourly: pvListForeHourly,
				hourForeGenBySite: hourForeGenBySite,
				hourGenBySite: hourGenBySite,
				todayForeGenBySite: todayForeGenBySite,
				todayGenBySite: todayGenBySite
			});
		}).then(({pvListHourly, pvListForeHourly, hourForeGenBySite, hourGenBySite, todayForeGenBySite, todayGenBySite}) => {
			let hourGenAllSite = 0;
			let hourForeGenAllSite = 0;
			let todayGenAllSite = 0;
			let ratioDaily = 0;
			let restDaily = 0;
			let seriesData = new Array();

			Object.entries(hourGenBySite).forEach(([siteId, hourGenData]) => {hourGenAllSite += hourGenData});
			Object.entries(hourForeGenBySite).forEach(([siteId, hourGenData]) => {hourForeGenAllSite += hourGenData});

			siteList.forEach((site, siteIdx) => {
				let ratioHourly = 0
				  , siteArray = new Array();

				const toDayGen = isEmpty(todayGenBySite[site.sid]) ? 0 : todayGenBySite[site.sid];
				const toDayForeGen = isEmpty(todayForeGenBySite[site.sid]) ? 0 : todayForeGenBySite[site.sid];
				const hourGen = isEmpty(hourGenBySite[site.sid]) ? 0 : hourGenBySite[site.sid];
				const hourForeGen = isEmpty(hourForeGenBySite[site.sid]) ? 0 : hourForeGenBySite[site.sid];


				if (toDayGen === 0 && toDayForeGen === 0) {
					ratioDaily = 0;
				} else {
					if (toDayForeGen <= toDayGen) {
						restDaily = null;
						ratioDaily = 1000;
					} else {
						ratioDaily = Math.floor((toDayGen / toDayForeGen) * 100);
						restDaily = 100 - ratioDaily;
					}
				}

				if (hourGen === 0 && hourForeGen === 0) {
					ratioHourly = 0;
				} else {
					if (hourForeGen <= hourGen) {
						ratioHourly = 100;
					} else {
						ratioHourly = Math.floor((hourGen / hourForeGen) * 100);
					}
				}

				siteArray.push(site.name);
				siteArray.push(ratioHourly);
				siteArray.push(ratioDaily);
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
			if (hourForeGenAllSite <= hourGenAllSite) {
				totalRestHourly = null;
				totalRatioHourly = 100;
			} else {
				totalRatioHourly = Math.floor((hourGenAllSite / hourForeGenAllSite) * 100);
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
			pvListHourly[nowHour] = todayGenAllSite;

			let maxValue = 0;
			if (!isEmpty(pvListHourly)) {
				pvListHourly.forEach(energy => {
					if (maxValue < energy) {
						maxValue = energy;
					}
				});
			}

			if (!isEmpty(pvListForeHourly)) {
				pvListForeHourly.forEach(energy => {
					if (maxValue < energy) {
						maxValue = energy;
					}
				});
			}

			const refineMaxValue = displayNumberFixedDecimal(maxValue, 'kWh', 3, 2);
			const rtnUnit = refineMaxValue[1];

			let seriesLength = rChart3.series.length;
			for (let i = seriesLength - 1; i > -1; i--) {
				rChart3.series[i].remove();
			}

			rChart3.addSeries({
				name: '출력',
				type: 'column',
				color: '#2BEEE9',
				data: pvListHourly,
				tooltip: {
					valueSuffix: 'kWh'
				}
			});

			rChart3.addSeries({
				name: '입찰',
				type: 'column',
				color: '#878787',
				data: pvListForeHourly,
				tooltip: {
					valueSuffix: 'kWh'
				}
			});

			rChart3.yAxis[0].setTitle({
				text: rtnUnit,
				align: 'low',
				rotation: 0, /* 타이틀 기울기 */
				y: 25, /* 타이틀 위치 조정 */
				x: 10,
				style: {
					color: 'var(--white60)',
					fontSize: '12px'
				}
			});
			rChart3.redraw();

			const currentTime = new Date().getHours() + ':' + new Date().getMinutes();
			const label = `${' 현재시간<br>${ currentTime }'}`;
			const now = new Date().getMinutes();
			const nowBottom = parseInt($('.realtime-time').css('bottom'), 10);

			if (nowBottom >= 206) {
				$(".realtime-label").html(label).css('bottom', '44px');
				$('.realtime-time').css('bottom', '63px');
			} else {
				$(".realtime-label").html(label).css('bottom', 44 + ((206 / 60) * now));
				$('.realtime-time').css('bottom', 63 + ((206 / 60) * now));
			}
		}).catch(error => {
			$('#errMsg').text(error);
			$('#errorModal').modal("show");
			setTimeout(function(){
				$('#errorModal').modal("hide");
			}, 2000);
		});
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
			lineColor: 'var(--white60)', /* 눈금선색 */
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white60)',
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
					color: 'var(--white60)',
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
			lineColor: 'var(--white60)', /* 눈금선색 */
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white60)',
			gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
			plotLines: [{
				color: 'var(--white60)',
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
					color: 'var(--white60)',
					fontSize: '12px'
				}
			},
			labels: {
				format: '{value}',
				style: {
					color: 'var(--white60)',
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
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white60)',
			labels: {
				enabled: false,
				align: 'right',
				reserveSpace: true,
				style: {
					color: 'var(--white60)',
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
			lineColor: 'var(--white60)',
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white60)',
			gridLineWidth: 0,
			min: 0,
			title: {
				text: '',
				style: {
					color: 'var(--white60)',
					fontSize: '12px'
				}
			},
			labels: {
				enabled: false,
				overflow: 'justify',
				x: -10, /* 그래프와의 거리 조정 */
				style: {
					color: 'var(--white60)',
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
				color: 'var(--white60)',
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
						textShadow: false,
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
									fontSize: '13px',
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
		title: {text: ''},
		subtitle: {text: ''},
		xAxis: {
			lineColor: 'var(--white60)', /* 눈금선색 */
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white60)',
			plotLines: [{
				color: 'var(--white60)',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27, /* 그래프와 거리 */
				style: {
					color: 'var(--white60)',
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
			lineColor: 'var(--white60)', /* 눈금선색 */
			tickColor: 'var(--white60)',
			gridLineColor: 'var(--white60)',
			plotLines: [{
				color: 'var(--white60)',
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
					color: 'var(--white60)',
					fontSize: '12px'
				}
			},
			labels: {
				formatter: function () {
					const suffix = this.chart.yAxis[0].userOptions.title.text;
					if (suffix === 'kWh') {
						return numberComma(this.value);
					} else {
						const yAxisValue = displayNumberFixedUnit(this.value, 'kWh', suffix, 1);
						return yAxisValue[0];
					}
				},
				overflow: 'justify',
				x: -10, /* 그래프와의 거리 조정 */
				style: {
					color: 'var(--white60)',
					fontSize: '12px'
				}
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -10,
			itemStyle: {
				color: 'var(--white60)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: '' /* 마우스 오버시 색 */
			},
			symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
			symbolHeight: 7 /* 심볼 크기 */
		},
		series: [],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(Math.round(point.y)) + suffix;
				}, '<b>' + this.x + '시 </b>');
			},
			shared: true
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: 'var(--white60)',
				borderWidth: 0 /* 보더 0 */
			},
			line: {
				marker: {
					enabled: false /* 마커 안보이기 */
				}
			}
		},
		credits: {
			enabled: false
		},
		responsive: {
			rules: [{
				condition: {
					minWidth: 842
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
</script>
