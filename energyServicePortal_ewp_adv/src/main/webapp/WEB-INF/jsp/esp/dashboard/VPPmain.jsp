<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

	<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
	<script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyAgEDjSwQWd_Q9RF_owO8WkMtf-6lmVSpc"></script>


<link type="text/css" rel="stylesheet" href="/css/vppDashboard.css" />


<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header"></div>
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATABASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div class="row content-wrapper" id="vppDashboardContent">
	<div class="col-xl-4 col-md-12 col-sm-12">

		<div class="vpp-1-1">
			<div class="indiv vpp-1-1-1">
				<h2 class="title">금일 총 전력 거래량</h2>
				<p class="vpp-1-1-value"><span id="totalEnergy">-</span> <span>MWh</span></p>
				<div>
					
					<div class="vpp-infobox">
						<p>금일 주요자원 거래량</p>
						<p><span id="mainEnergy">-</span> MWh</p>
					</div>
					<div class="vpp-infobox">
						<p>금일 보조자원 거래량</p>
						<p><span id="subEnergy">-</span> MWh</p>
					</div>
				</div>
			</div>
			<div class="indiv vpp1-1-2">
				<h2 class="title">금일 총 수익</h2>
				<p class="vpp-1-1-value"><span id="totalMoney">-</span> <span>천원</span></p>
				<div>
					<div class="vpp-infobox">
						<p>금일 SMP 수익</p>
						<p><span id="todaySMP">-</span> 천원</p>
					</div>
					<div class="vpp-infobox">
						<p>금일 예측 수익</p>
						<p><span id="todayPredictionMoney">-</span> 천원</p>
					</div>
				</div>
			</div>
		</div>

		<div class="indiv vpp-1-2">
			<h2 class="title">전력거래량 예측</h2>
			<div>
				<div class="vpp-1-2-1">
					<div id="vppGraph1"></div>
					<!-- 그래프 -->
				</div>
				<div class="vpp-1-2-2">
					<h3>예측 정확도</h3>
					<div class="vpp-pie-area"> <div id="vppPie"></div> </div><!-- 그래프 (pie) -->
					<div class="flex-center-between">
						<div>
							<div class="vpp-infobox">
								<p>전일</p>
								<p>- %</p>
							</div>
							<div class="vpp-infobox">
								<p>전주</p>
								<p>- %</p>
							</div>
						</div>
						<div>
							<div class="vpp-infobox">
								<p>전월</p>
								<p>- %</p>
							</div>
							<div class="vpp-infobox">
								<p>전년</p>
								<p>- %</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="indiv vpp-1-3">
			<div class="title-area">
				<h2 class="title actived">보조자원 예측</h2>
				<h2 class="title">충/방전 현황</h2>
			</div>
			<div class="vpp-1-3-1 vpp-1-3-content view">
				<div id="vppGraph2">그래프</div>
			</div>
			<div class="vpp-1-3-2 vpp-1-3-content">
				<div><!-- 그래프? --></div>
				<div class="vpp-1-3-2-1">
					<div>
						<h3>이용 현황</h3>
						<div class="vpp-infobox">
							<p>이용</p>
							<p>100 kW</p>
						</div>
						<div class="vpp-infobox">
							<p>총 용량</p>
							<p>2 MWh</p>
						</div>
					</div>
					<div>
						<h3>금일 계획</h3>
						<div class="vpp-infobox">
							<p>금일 충전 계획</p>
							<p>240 kWh</p>
						</div>
						<div class="vpp-infobox">
							<p>금일 방전 계획</p>
							<p>20 kWh</p>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="indiv vpp-1-4">
			<h2 class="title">수익 현황</h2>
			<div>
				<div class="vpp-1-4-1">
					<div id="moneyStatusGraph"> 
						<!-- 그래프 -->
					</div>
				</div>
				<div class="vpp-1-4-2">
					<div>
						<h3>SMP 수익</h3>
						<div class="vpp-infobox">
							<p>당월</p>
							<p><span id="smpMonth">-</span> 만원</p>
						</div>
						<div class="vpp-infobox">
							<p>당해</p>
							<p><span id="smpYear">-</span> 만원</p>
						</div>
					</div>
					<div>
						<h3>예측 수익</h3>
						<div class="vpp-infobox">
							<p>당월</p>
							<p><span id="accMonth">-</span> 만원</p>
						</div>
						<div class="vpp-infobox">
							<p>당해</p>
							<p><span id="accYear">-</span> 만원</p>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>

	<div class="col-xl-4 col-md-12 col-sm-12">

		<div class="indiv vpp-2-1">
			<h2 class="title">자원 현황</h2>
			<div class="flex-start-between">
				<div class="vpp-2-1-1">
					<div class="vpp-infobox">
						<p>주요 자원</p>
					</div>
					<div class="flex-center-between">
						<div id="mainResource_sun">
							<div class="vpp-2-1-1-img">
								<img src="/img/vpp/solar-panel.svg" alt="태양광" />
								<img src="" alt="" class="network-status-img" />
							</div>
							<p>태양광</p>
						</div>
						<div id="mainResource_wind">
							<div class="vpp-2-1-1-img">
								<img src="/img/vpp/wind-power.svg" alt="풍력" />
								<img src="" alt="" class="network-status-img" />
							</div>
							<p>풍력</p>
						</div>
					</div>
				</div>
				<div class="vpp-2-1-2">
					<div class="vpp-infobox">
						<p>보조 자원</p>
					</div>
					<div>
						<div class="actived" id="subResource_ESS">
							<div class="flex-center">
								<img src="/img/vpp/ess.svg" alt="태양광" />
								<p>ESS</p>
							</div>
							<img src="/img/vpp/network-normal.svg" alt="" />
						</div>
						<div class=" id="subResource_fuelcell">
							<div class="flex-center">
								<img src="/img/vpp/fuelcell.svg" alt="풍력" />
								<p>연료전지</p>
							</div>
							<img src="" alt="" />
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="indiv vpp-2-2">
			<div class="flex-start-between">
				<h2 class="title">발전 현황</h2>
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
			<div id="vppMap">

			</div>

			<div class="vpp-2-2-center">
				<p>사이트 현황</p>
				<div class="auto-rolling playing">
					<p class="play"><img src="/img/vpp/play.svg" alt="자동 재생" /> 자동 재생</p>
					<p class="stop"><img src="/img/vpp/pause.svg" alt="일시 정지" /> 일시 정지</p>
				</div>
			</div>

			<div class="vpp-2-2-tablewrap">
				<table class="vpp-2-2-table" id="vppMapTable">
					<colgroup>
						<col width="11%">
						<col width="33%">
						<col width="27%">
						<col width="13%">
						<col width="13%">
					</colgroup>
					<thead>
						<tr>
							<td>지역</td>
							<td>사이트명</td>
							<td>자원이용</td>
							<td>상태</td>
							<td>통신</td>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>

	</div>

	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv vpp-3-1">
			<div class="vpp-infobox">
				<p>총 예측 사이트</p>
				<p><span id="totalSiteCount">-</span> 개소</p>
			</div>
			<div class="vpp-infobox">
				<p>총 예측 설비용량</p>
				<p><span id="totalCapacity">-</span> MW</p>
			</div>
			<div class="vpp-infobox">
				<p>총 발전 예측 정확도</p>
				<p><span id="totalAcc">-</span> %</p>
			</div>
		</div>
		<div class="indiv vpp-3-2">
			<h2 class="title">주간 예측오차율</h2>
			<div class="vpp-3-2-graph">
				<div class="actived">
					<div>0</div>
					<p>8%</p>
				</div>
				<div class="actived">
					<div>0</div>
					<p>6%</p>
				</div>
				<div class="actived">
					<div>0</div>
					<p>10%</p>
				</div>
				<div class="actived">
					<div>0</div>
					<p>20%</p>
				</div>
				<div class="actived">
					<div>0</div>
					<p>예측 오차</p>
				</div>
			</div>

			<p>(출력/예측/발전 단위: kWh, 오차 단위: %)</p>

			<!-- dataTable -->
			<table id="vpp-3-2-dataTable">
				<colgroup>
					<col width="185px">
					<col width="75px">
					<col width="75px">
					<col width="75px">
					<col width="75px">
				</colgroup>
			</table>
		</div>
	</div>
</div>

<script>
	// Document Ready
	$(_ => {
		// VPP 그룹 정보
		$.ajax({
			type: "GET",
			url: apiHost + "/config/vpp-groups/" + tempId,
			data: {
				includeSites: true,
				includeDevices: true,
			},
		}).done(result => { 
			console.log(result)

			App.sites = result.sites;
			App.init();
		}).fail(error => {
			console.error(error);
		})
	})

	// 임시 VPP ID --------
	const tempId = "5bebbe35-7a26-401b-a8bc-c960a663eb13";
	const interval = {
		today: getDayInterval(),
		month: getMonthInterval(),
	};

	// 메인 객체
	const App = {
		sites: [],
		sids: [],
		energyData: [],
		acc: [],

		init() {
			const sids = this.sites.map(x => x.sid).join();
			console.log(sids);

			const apis = [
				$.ajax({ // 0
					type: "GET",
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						startTime: interval.today[0],
						endTime: interval.today[1],
						interval: "day",
						detailByBasetime: true,
					},
				}),
				$.ajax({ // 1
					type: "GET",
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						startTime: interval.today[0],
						endTime: interval.today[1],
						interval: "15min",
						detailByBasetime: true
					},
				}),
				$.ajax({ // 2
					url: apiHost + "/energy/forecast/accuracy",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"startTime": interval.today[0],
						"endTime": interval.today[1],
						"interval": "day",
						"cal_incentive": true,
						"additionalProp1": {}
					})
				}),
				$.ajax({ // 3
					url: apiHost + "/get/energy/forecasting/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sid": sids,
						"startTime": interval.today[0],
						"endTime": interval.today[1],
						"interval": "hour",
						"displayType": "dashboard",
						"formId": "v2"
					}),
				}),
				$.ajax({ // 4
					url: apiHost + "/get/energy/forecasting/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sid": sids,
						"startTime": interval.today[0],
						"endTime": interval.today[1],
						"interval": "15min",
						"displayType": "dashboard",
						"formId": "v2"
					}),
				}),
				$.ajax({ // 5
					url: apiHost + "/get/energy/forecasting/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sid": sids,
						"startTime": interval.month[0],
						"endTime": interval.month[1],
						"interval": "day",
						"displayType": "dashboard",
						"formId": "v2"
					}),
				}),
				$.ajax({ // 6
					url: apiHost + "/energy/forecast/accuracy",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"startTime": interval.month[0],
						"endTime": interval.month[1],
						"interval": "day",
						"cal_incentive": true,
						"additionalProp1": {}
					}),
				}),
				$.ajax({ // 7
					url: apiHost + "/get/energy/forecasting/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sid": sids,
						"startTime": interval.today[0],
						"endTime": interval.today[1],
						"interval": "day",	
						"displayType": "dashboard",
						"formId": "v2"
					}),
				}),
				$.ajax({ // 8
					type: "GET",
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						"startTime": interval.month[0],
						"endTime": interval.month[1],
						interval: "day",
						detailByBasetime: true
					},
				}),
				$.ajax({ // 9 //  상태 조회용
					url: apiHost + "/get/status/raw/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"startTime": getTime(1, false),
						"displayType": "dashboard",
						"operation": "active",
					}),
				}),

				$.ajax({ // 10 // 통신 조회용
					url: apiHost + "/get/status/raw/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"startTime": getTime(1, false),
						"displayType": "dashboard",
						"operation": "overall",
					}),
				}),
				$.ajax({ // 11 // 테이블용
					url: apiHost + "/get/status/raw/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"displayType": "dashboard",
						"operation": "active",
					}),
				}),
				$.ajax({ // 12 // 테이블용
					url: apiHost + "/energy/now/sites",
					type: "GET",
					data: {
						sids: sids,
						metering_type: 2,
						interval: "hour",
					},
				}),
				$.ajax({ // 13 // 테이블용
					type: "GET",
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						interval: "hour",
					},
				}),
				$.ajax({ // 14 // 테이블용
					url: apiHost + "/energy/forecast/accuracy",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"startTime": interval.today[0],
						"endTime": (String(getTime(0, false)).substr(0, 10)+"0000") * 1,
						"interval": "day",
						"cal_incentive": true,
						"additionalProp1": {}
					}),
				}),
				$.ajax({ // 15
					type: "GET",
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						startTime: interval.today[0],
						endTime: interval.today[1],
						interval: "hour",
						detailByBasetime: true,
					},
				}),
			]

			new Promise ((resolve, reject) => {
				resolve(Promise.all(apis));
			}).then(res => {
				const vppInfo = {
					"day" : Object.entries(res[0].data),
					"15min" : Object.entries(res[1].data),
					"month" : Object.entries(res[8].data),
					"hour" : Object.entries(res[15].data),
				};
				const acc = {
					"day": res[2].data.data,
					"month": res[6].data.data,
				};
				const forecast = {
					"hour": res[3].data,
					"15min": res[4].data,
					"month": res[5].data,
					"day": res[7].data,
				};
				const status = {
					"active": res[9],
					"overall": res[10],
				};

				console.log(acc)

				TotalTrading(vppInfo.day.map(x => x[1]));
				TotalProfit(vppInfo.day.map(x => x[1]), acc.day);
				SiteStatus.setList(vppInfo.day, forecast.day, status);
				Graph1.setOption(vppInfo["hour"].map(x => x[1]), Object.values(forecast["hour"]));
				Graph2.setOption(vppInfo.hour.map(x => x[1]));
				Graph3.setOption(vppInfo.month.map(x => x[1]), Object.values(forecast.month), acc.month);
				PieGraph.draw(Object.values(acc.day.total)[0].accuracy);
				setResourceStatus(vppInfo.day);
				Table.refresh(res[11], res[12].data, res[13].data, res[14].data.data, acc.day);
				setPrediction(forecast["15min"], vppInfo.day.map(x => x[1]), Object.values(acc.day.total)[0].accuracy);

			}).catch(error => {
				console.log(error);
			});

			Table.init();
			App.setEvent();
		},

		// 이벤트 체이닝
		setEvent() {
			$(document)
				.on("click", ".vpp-1-3 > .title-area > .title", function(e) {
					$(".vpp-1-3 > .title-area > .title.actived").removeClass("actived");
					$(this).addClass("actived");
				})
				.on("click", "#vppMapTable tbody tr:not(.vpp-fold-menu)", function(e) {
					if (!$(this).hasClass("open")) {
						$("#vppMapTable tbody tr.open").removeClass("open");
						$(this).addClass("open");
					} else {
						$("#vppMapTable tbody tr.open").removeClass("open");
					}
				})
				.on("click", ".vpp-3-2-graph > div", function(e) {
					$(this).toggleClass("actived");
				})
				.on("click", ".auto-rolling", function(e) {
					$(".auto-rolling").toggleClass("playing");

					SiteStatus.rolling();
				})
				.on("click", ".vpp-1-3 > .title-area > .title", function(e) {
					$(".vpp-1-3 > .title-area > .title.actived").removeClass("actived");
					$(this).addClass("actived");

					$(".vpp-1-3-content").removeClass("view");
					$(".vpp-1-3-"+($(this).index() + 1)).addClass("view");
				})
				.on("click", ".vpp-focus-map", function(e) {
					VppMap.focusTo($(this).data("sid"));
				})
		},
	}

	const Apis = {

	}

	// 금일 총 전력거래량
	const TotalTrading = (data) => {
		const [primary, secondary] = [
			data.reduce((acc, cur) => acc + cur.energyPrimary, 0),
			data.reduce((acc, cur) => acc + cur.energySecondary, 0),
		];
		const total = primary + secondary;

		$("#totalEnergy").html((total / 1000 / 1000).toFixed(2));
		$("#mainEnergy").html((primary / 1000 / 1000).toFixed(2));
		$("#subEnergy").html((secondary / 1000 / 1000).toFixed(2));
	}

	// 금일 총 수익
	const TotalProfit = (now, forecast) => {
		const smp = (now.reduce((acc, cur) => acc + cur.money, 0) / 1000).toFixed(2);
		const incentive = forecast.total.length ? Object.entries(forecast.total)[0][1].incentive : 0;
		// now = Object.entries(now[0].data).map(x => {
		// 	x[1].sid = x[0];
			
		// 	return x[1];
		// });
		
		// forecast = Object.entries(forecast[0].data).map(x => x[1][0].items[0]);
		
		// $("#totalMoney").html((now.reduce((acc, cur) => acc + cur.money, 0) / 1000).toFixed(2));
		$("#todaySMP").html(smp);
		$("#todayPredictionMoney").html(incentive);
	}

	// 전력거래량 예측
	const Graph1 = {
		series: [
			{name: '실측', type: 'area', color: 'var(--circle-solar-power)', data: [], suffix: 'kWh'},
			{name: '예측', type: 'line', color: 'var(--white)', data: [], suffix: 'kWh'},
		],
		target: {},

		draw() {
			Graph1.target = Highcharts.chart("vppGraph1", {
				chart: {
					marginLeft: 0,
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
					lineColor: 'var(--grey)',
					tickColor: 'var(--grey)',
					gridLineColor: 'var(--white25)',
					tickWidth: 1,
					tickLength: 6,
					labels: {
						align: 'center',
						y: 20,
						style: {
							color: 'var(--grey)',
							fontSize: '10px',
							rotation: 0
						},
						formatter() {
							return this.value + 1;
						}
					},
					tickInterval: 1,
					title: {
						text: null
					},
					crosshair: true,
				}],
				yAxis: [{
					lineColor: 'var(--grey)',
					tickColor: 'var(--grey)',
					gridLineColor: 'var(--white25)',
					gridLineWidth: 1,
					title: {
						x: 10,
						y: 35,
						text: 'kWh',
						align: 'low',
						rotation: 0,
						style: {
							color: 'var(--grey)',
							fontSize: '12px'
						}
					},
					labels: { 
						x: 0,
						y: -5,
						align: "left",
						formatter() {
							return Math.round(this.value / 1000);
						},
						style: {
							color: 'var(--grey)',
							fontSize: '12px'
						},
					},
					plotLines: [{
						color: 'var(--grey)',
						width: 1
					}],
				}],
				tooltip: {
					formatter() {
						return this.points.reduce((acc, cur) => {	
							return acc + '<br/><span style="color:' + cur.color + '">\u25CF</span> ' + cur.series.name + ': ' + (cur.y / 1000).toFixed(2) + 'kWh';
						}, '<span style="display:flex;"><b>' + (this.x + 1) + '시</b></span>');
					},
					shared: true,
					useHTML: true,
					borderColor: 'none',
					backgroundColor: 'var(--bg-color)',
					padding: 16,
					style: {
						color: 'var(--white87)',
					}
				},
				legend: {
					enabled: true,
					align: 'right',
					verticalAlign: 'top',
					x: 5,
					y: -15,
					itemStyle: {
						color: 'var(--white87)',
						fontSize: '12px',
						fontWeight: 400
					},
					itemHoverStyle: {
						color: ''
					},
					symbolPadding: 0,
					symbolHeight: 7
				},
				plotOptions: {
					series: {
						label: {
							connectorAllowed: false
						},
						borderWidth: 0
					},
					area: {
						lineColor: "transparent",
						marker: {
							enabled: false
						}
					},
				},
				series: Graph1.series
			});
		},

		setOption(now, forecast) { // 고쳐야됌
			const nowData = {};

			now = now.map(x => x.detail);

			$.each(now, (ix, el) => {
				$.each(el, (k, v) => {
					nowData[k] = (nowData[k] ? nowData[k] : 0);
					if (k !== "devices") {
						nowData[k] += v.energy;
					}
				});
			});

			for (let i = 0; i < 24; i++) {
				this.series[1].data.push(forecast.map(x => x[0].items).reduce((acc, cur) => acc + cur[i].energy, 0));
			}
			
			let temp = Object.entries(nowData).sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0);
				temp.pop();

			this.series[0].data = fillArray(temp.map(x => x[1]), 24);
	
			this.draw();
		},
	}

	const PieGraph = {
		draw(acc) { 
			Highcharts.chart("vppPie", {
				chart: {
					type: "pie",
					backgroundColor: "transparent",
					margin: [0, 0, 0, 0],
					spacing: [0, 0, 0, 0],
					zoomType: 'xy',
					plotBorderWidth: 0,
					plotShadow: false,
				},
				title: {
					text: acc === "-" ? "-" : (100 - (acc * 100)).toFixed(1)+'%',
					align: 'center',
					verticalAlign: 'middle',
					y: 13.5,
					style: {
						fontSize: "15px",
						color: "var(--white87)",
						fontWeight: "normal"
					}
				},
				plotOptions: {
					pie: {
						dataLabels: {
							enabled: false,
							style: {
								fontWeight: 'bold',
								color: 'var(--white87)'
							}
						},
						center: ['50%', '50%'],
						borderWidth: 0,
						size: 103
					}
				},	
				tooltip: {
					shared: true,
					borderColor: 'none',
					backgroundColor: 'var(--bg-color)',
					padding: 16,
					style: {
						color: 'var(--white87)',
					},
					valueSuffix: ' kwh',
					pointFormat: '<b>{point.percentage:.0f}%</b>'
				},
				series: [{
					type: 'pie',
					innerSize: '70%',
					name: "예측 정확도",
					colorByPoint: true,
					data: [{
						color: '#cfcfcf',
						name: "예측",
						dataLabels: {
							enabled: false
						},
						y: acc === "-" ? 0 : 100 - (acc * 100) //60% -- 아래로 총합 100%
					}, {
						color: '#656565',
						name: "안예측",
						dataLabels: {
							enabled: false
						},
						y: acc === "-" ? 100 : acc * 100 //20% 나머지
					}]
				}],
			});
		}
	}

	const Graph2 = {
		series: [
			{name: "실측", type: "column", color: "#26ccc8", data: [], suffix: "kWh"},
			{name: "계획", type: "line", color: "var(--white)", data: [], suffix: "kWh"},
		],
		target: {},

		draw() {
			Graph2.target = Highcharts.chart("vppGraph2", {
				chart: {
					marginLeft: 0,
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
					lineColor: 'var(--grey)',
					tickColor: 'var(--grey)',
					gridLineColor: 'var(--white25)',
					tickWidth: 1,
					tickLength: 6,
					labels: {
						align: 'center',
						y: 20,
						style: {
							color: 'var(--grey)',
							fontSize: '10px',
							rotation: 0
						},
						formatter() {
							return this.value + 1;
						},
					},
					tickInterval: 1,
					title: {
						text: null
					},
					crosshair: true,
				}],
				yAxis: [{
					lineColor: 'var(--grey)',
					tickColor: 'var(--grey)',
					gridLineColor: 'var(--white25)',
					gridLineWidth: 1,
					title: {
						x: 10,
						y: 35,
						text: 'kWh',
						align: 'low',
						rotation: 0,
						style: {
							color: 'var(--grey)',
							fontSize: '12px'
						}
					},
					labels: { 
						x: 0,
						y: -5,
						align: "left",
						formatter: function () {
							return Math.round(this.value / 1000);
						},
						style: {
							color: 'var(--grey)',
							fontSize: '12px'
						},
					},
					plotLines: [{
						color: 'var(--grey)',
						width: 1
					}],
				}],
				tooltip: {
					formatter() {
						return this.points.reduce((acc, cur) => {	
							return acc + '<br/><span style="color:' + cur.color + '">\u25CF</span> ' + cur.series.name + ': ' + (cur.y / 1000).toFixed(2) + 'kWh';
						}, '<span style="display:flex;"><b>' + (this.x + 1) + '시</b></span>');
					},
					shared: true,
					useHTML: true,
					borderColor: 'none',
					backgroundColor: 'var(--bg-color)',
					padding: 16,
					style: {
						color: 'var(--white87)',
					}
				},
				legend: {
					enabled: true,
					align: 'right',
					verticalAlign: 'top',
					x: 5,
					y: -15,
					itemStyle: {
						color: 'var(--white87)',
						fontSize: '12px',
						fontWeight: 400
					},
					itemHoverStyle: {
						color: ''
					},
					symbolPadding: 0,
					symbolHeight: 7
				},
				plotOptions: {
					series: {
						label: {
							connectorAllowed: false
						},
						borderWidth: 0
					},
					area: {
						lineColor: "transparent",
						marker: {
							enabled: false
						}
					},
				},
				series: Graph2.series
			});
		},

		setOption(data) {
			let now = {};
			let forecast = {};

			data = data.map(x => x.detail);
			
			$.each(data, (ix, el) => {
				$.each(el, (k, v) => {
					now[k] = (now[k] ? now[k] : 0);
					forecast[k] = (forecast[k] ? forecast[k] : 0);
					if (k !== "devices") {
						now[k] += v.energySecondary;
						forecast[k] += v.forecastSecondary;
					}
				});
			});

			now = Object.entries(now).sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0)
			forecast = Object.entries(forecast).sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0)

			now.pop();
			forecast.pop();

			this.series[0].data = fillArray(now.map(x => x[1]), 24)
			this.series[1].data = fillArray(forecast.map(x => x[1]), 24)

			this.draw();
		}
 	}

	// 수익현황
	const Graph3 = {
		series : [
			{name: 'SMP', color: '#26ccc8', data: []},
			{name: '예측', color: '#878787', data: []},
		],
		target: {},

		draw() {
			Graph3.target = Highcharts.chart("moneyStatusGraph", {
				chart: {
					type: "column",
					marginLeft: 0,
					backgroundColor: 'transparent',
					zoomType: 'xy',
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
					tickWidth: 1,
					tickLength: 6,
					labels: {
						align: 'center',
						y: 20,
						style: {
							color: 'var(--grey)',
							fontSize: '10px',
							rotation: 0
						},
						formatter() {
							return this.value + 1;
						}
					},
					tickInterval: 1,
					title: {
						text: null
					},
					crosshair: true,
				}],
				yAxis: [{
					lineColor: 'var(--grey)',
					tickColor: 'var(--grey)',
					gridLineColor: 'var(--white25)',
					gridLineWidth: 1,
					title: {
						x: 10,
						y: 35,
						text: '천원',
						align: 'low',
						rotation: 0,
						style: {
							color: 'var(--grey)',
							fontSize: '12px'
						}
					},
					labels: { 
						x: 0,
						y: -5,
						align: "left",
						formatter: function () {
							return Math.round(this.value / 1000);
						},
						style: {
							color: 'var(--grey)',
							fontSize: '12px'
						},
					},
					plotLines: [{
						color: 'var(--grey)',
						width: 1
					}],
				}],
				tooltip: {
					formatter() {
						return this.points.reduce((acc, cur) => {	
							return acc + '<br/><span style="color:' + cur.color + '">\u25CF</span> ' + cur.series.name + ': ' + (cur.y / 1000).toFixed(2) + '천원';
						}, '<span style="display:flex;"><b>' + (this.x + 1) + '일</b></span>');
					},
					shared: true,
					useHTML: true,
					borderColor: 'none',
					backgroundColor: 'var(--bg-color)',
					padding: 16,
					style: {
						color: 'var(--white87)',
					}
				},
				legend: {
					enabled: true,
					align: 'right',
					verticalAlign: 'top',
					x: 5,
					y: -15,
					itemStyle: {
						color: 'var(--white87)',
						fontSize: '12px',
						fontWeight: 400
					},
					itemHoverStyle: {
						color: ''
					},
					symbolPadding: 0,
					symbolHeight: 7
				},
				plotOptions: {
					series: {
						label: {
							connectorAllowed: false
						},
						borderWidth: 0
					},
					area: {
						lineColor: "transparent",
						marker: {
							enabled: false
						}
					},
				},
				series: Graph3.series
			});
		},

		setOption(now, forecast, acc) {
			// $.each(forecast, (ix, el) => {
			// 	this.series[1].data.push()
			// })
			// now = Object.values(now.detail);
			// now.pop();
			// console.log(now);
			
			// $.each(now, (ix, el) => {
			// 	let detail = Object.entries(el.detail);
			// 		detail.pop();

			// 	console.log(detail.reduce((acc, cur) => { console.log(cur) }, 0))
			// 	// this.series[0].data.push();
			// })
			// console.log(now)
			for (let i = 0; i < getLastDay(); i++) {
				
				// this.series[0].data.push(now.map(x => x.detail).reduce((acc, cur) => acc + Object.values(Object.entries(cur)[i]).money, 0));
				this.series[1].data.push(forecast.map(x => x[0].items).reduce((acc, cur) => acc + cur[i] ? cur[i].money : 0, 0));

			// 	this.series[1].data.push(forecast.map(x => x.items).reduce((acc, cur) => acc + cur[i].money, 0))
			}


			$("#accMonth").html((Object.values(acc.total).reduce((acc, cur) => acc + cur.incentive, 0)).toLocaleString());
			
	
			this.draw();
		},
	}

	// 자원 현황
	const setResourceStatus = (energy) => {
		energy = energy.map(x => x[1]);
		console.log(energy)
		if (energy.find(x => x.ess === 0)) {
			$("#subResource_ESS").removeClass("actived");
			$("#subResource_ESS > img").attr("src", "");
		}

		if (energy.find(x => x.resource_type === 1)) {
			$("#mainResource_sun").addClass("actived");
			$("#mainResource_sun .network-status-img").attr("src", "/img/vpp/network-normal.svg");
			if (energy.find(x => x.energyPrimary === 0)) {
				$("#mainResource_sun .network-status-img").attr("src", "/img/vpp/network-error-yellow.svg");
			}
		}

		if (energy.find(x => x.resource_type === 2)) {
			$("#mainResource_wind").addClass("actived");
			$("#mainResource_wind .network-status-img").attr("src", "/img/vpp/network-normal.svg");
			if (energy.find(x => x.energyPrimary === 0)) {
				$("#mainResource_wind .network-status-img").attr("src", "/img/vpp/network-error-yellow.svg");
			}
		}

		if (energy.find(x => x.resource_type === 4)) {
			$("#subResource_fuelcell").addClass("actived");
		}
		// energy.map(x => { 
		// 	x = x[1];
		// 	if (!x.ess) {
		// 		$("#subResource_ESS").removeClass("actived");
		// 		$("#subResource_ESS > img").attr("src", "");
		// 	}

		// 	let resource = "";
		// 	switch (x.resource_type) {
		// 		case 1:
		// 			resource = "#mainResource_sun";
		// 		break;
				
		// 		case 2:
		// 			resource = "#mainResource_wind";
		// 		break;

		// 		case 4:
		// 			resource = "#subResource_fuelcell";
		// 		break;
		// 	}

		// 	$(resource).addClass("actived");
		// 	// $(resource).find(".network-status-img").attr("src") === "" && 
		// 	if (((x.reource_type === 1 || x.reource_type === 2) && x.energyPrimary <= 0) || (x.reource_type === 4 && x.energySecondary <= 0)) {
		// 		$(resource).find(".network-status-img").attr("src", "/img/vpp/network-error-yellow.svg");
		// 	} else {
		// 		$(resource).find(".network-status-img").attr("src", "/img/vpp/network-normal.svg");
		// 	}
		// });
	}
	
	// 발전 현황
	const VppMap = {
		makerObject : {},
		markers : [],
		map : new google.maps.Map(document.getElementById('vppMap'), {
			mapTypeId: 'satellite',
			zoom: 7.3,
			mapTypeControl: false, //맵타입
			streetViewControl: false, //스트리트뷰
			fullscreenControl: false, //전체보기
			center: {lat: 36.549012, lng: 127.788546} // center: new google.maps.LatLng(37.549012, 126.988546),
		}),
		geocoder : new google.maps.Geocoder(),
		infowindow : new google.maps.InfoWindow(),

		geocodeAddress (siteAddr, siteId, siteLatlng, siteColor) {
			let latLng = new Object(),
				dummy = siteLatlng.split(',');
			latLng['lat'] = Number(dummy[0]);
			latLng['lng'] = Number(dummy[1]);

			let marker = new google.maps.Marker({
				map: VppMap.map,
				position: latLng,
				icon: VppMap.pinSymbol(siteColor),
			});

			let infoWIndowContent = '<div class="vpp-pin" data-sid="'+siteId+'"><span style="color:' + siteColor + '"></span></div>';
			marker.infowindow = new google.maps.InfoWindow({
				content: infoWIndowContent
			});

			VppMap.markers.push(marker);
			VppMap.makerObject[siteId] = marker;
		},

		pinSymbol(color) {
			const img = {
				url: '/img/map_icons/marker_red.png',
				height: 20,
				width: 14
			}

			switch (color) {
				case "#f2a363":
					img.url = "/img/map_icons/marker_orange.png";
				break;

				case "#90caf3":
					img.url = "/img/map_icons/marker_blue.png";
				break;

				case "#ffd954":
					img.url = "/img/map_icons/marker_yellow.png";
				break;

				case "#878787":
					img.url = "/img/map_icons/marker_grey.png";
				break;
			}

			return img;
		},

		smoothZoom(map, max, cnt, zoom) {
			if (zoom) {
				if (cnt == 18) {
					return false;
				}
		
				if (cnt >= max) {
					return;
				} else {
					z = google.maps.event.addListener(map, 'zoom_changed', function (event) {
						google.maps.event.removeListener(z);
						VppMap.smoothZoom(map, max, cnt + 1, true);
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
						VppMap.smoothZoom(map, max, cnt - 1, false);
					});
					setTimeout(function () {
						map.setZoom(cnt)
					}, 80); // 80ms is what I found to work well on my system -- it might not work well on all systems
				}
			}
		},

		focusTo(sid) {
			if (typeof(VppMap.smoothZoom) == 'function') {
				let markerIcon = VppMap.makerObject[sid];

				VppMap.map.setCenter(markerIcon.position);
				VppMap.smoothZoom(VppMap.map, 18, VppMap.map.getZoom(), true);
				google.maps.event.trigger(markerIcon, 'click');
			}
			return false;
		}
	}

	// 사이트 현황
	const SiteStatus = {
		interval: null,
		idx: 0,
		len: 0,

		setList(energyData, forecast, status) {
			let tableTemplate = ``;
			let energy = {};
			let fc = {}
			let active = {};
			let overall = {};
			// console.log(status)
			App.sites.map(x => {
				energy = energyData.find(v => v[0] === x.sid)[1];
				fc = forecast[x.sid] ? forecast[x.sid][0].items[0] : "";
				active = Object.values(status.active[x.sid]["INV_PV"]).length ? ["normal", "정상"] : ["error", "이상"];
				overall = Object.values(status.overall[x.sid]["INV_PV"]).length ? ["normal", "정상"] : ["error", "이상"];

				tableTemplate += `
					<tr class="vpp-focus-map" data-sid="${'${x.sid}'}">
						<td>${'${x.location}'}</td>
						<td>${'${x.name}'}</td>
						<td>
							<img src="/img/vpp/solar-panel.svg" alt="자원" class="${'${x.resource_type === 1 && "actived"}'}">
							<img src="/img/vpp/wind-power.svg" alt="자원" class="${'${x.resource_type === 2 && "actived"}'}">
							<img src="/img/vpp/ess.svg" alt="자원" class="${'${x.ess === 1 && "actived"}'}">
							<img src="/img/vpp/fuelcell.svg" alt="자원" class="${'${x.resource_type === 4 && "actived"}'}">
						</td>
						<td> <span class="status-button ${'${active[0]}'}">${'${active[1]}'}</span> </td>
						<td> <span class="status-button ${'${overall[0]}'}">${'${overall[1]}'}</span> </td>
					</tr>
					<tr class="vpp-fold-menu">
						<td colspan="5">
							<div>
								<div class="vpp-fold-menu-header">
									<img src="/img/weather_icons/ico1_sun.svg" alt="날씨"> 
									<div>
										<ul>
											<li>일사량</li>
											<li>- kWh/m.day</li>
										</ul>
										<div class="flex-center">
											<ul>
												<li>온도</li>
												<li>-%</li>
											</ul>
											<ul>
												<li>습도</li>
												<li>-%</li>
											</ul>
										</div>
									</div>
								</div>

								<div class="vpp-fold-menu-content">
									<div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>${'${energy.capacity.toLocaleString()}'} kW</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 누적거래량</p>
											<p>${'${(energy.energy / 1000).toLocaleString()}'} kWh</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 예측거래량</p>
											<p>${'${fc ? (fc.energy / 1000).toLocaleString() : "-"}'} kWh</p>
										</div>
									</div>
									<div>
										<div class="vpp-infobox">
											<p>금일 SMP 수익</p>
											<p>- 천원</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 예측 수익</p>
											<p>${'${fc ? (fc.money / 1000).toLocaleString() : "-"}'} 천원</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 총 수익</p>
											<p>${'${(energy.money / 1000).toLocaleString()}'} 천원</p>
										</div>
									</div>
								</div>
							</div>
						</td>
					</tr>
				`;

				VppMap.geocodeAddress(x.address, x.sid, x.latlng, "#90caf3");
			})
			$("#vppMapTable tbody").html(tableTemplate);

			this.rolling();
		},

		rolling() {
			clearInterval(this.interval);
			if ($(".auto-rolling").hasClass("playing")) {
				this.len = $(".vpp-focus-map").length - 1;
				this.interval = setInterval(_ => {
					$(".vpp-focus-map")[this.idx].click();

					this.idx = this.len > this.idx ? this.idx + 1 : 0;
				}, 10000);
			}
		},
	}

	const setPrediction = (forecast, capacity, acc) => {
		$("#totalSiteCount").html(Object.entries(forecast).length); // 총 예측 사이트
		$("#totalCapacity").html(((capacity.reduce((acc, cur) => acc + cur.capacity, 0) / 1000 / 1000).toFixed(3) * 1).toLocaleString());
		$("#totalAcc").html(acc === 0 ? "-" : (100 - (acc * 100)).toFixed(1));
	}

	// 주간 예측오차율 
	const Table = {
		target: null,

		init() {
			Table.target = $("#vpp-3-2-dataTable").DataTable({
				autoWidth: true,
				fixedHeader: true,
				// "table-layout": "fixed",
				scrollX: false,
				scrollY: '720px',
				scrollCollapse: true,
				sortable: true,
				paging: false,
				columns: [
					{
						title: "사이트 명",
						data: 'name',
						className: 'dt-head-left dt-body-left',
					},
					{
						title: "현재출력",
						data: 'activePower',
						className: 'dt-head-right dt-body-right',
						render(data) {
							return data === "-" ? "-" : Math.round(data / 1000);
						},
					},
					{
						title: "현시각 <br> 발전<br>",
						data: 'currentDev',
						className: 'dt-head-right dt-body-right',
						render(data) {
							return data === "-" ? "-" : Math.round(data / 1000);
						},
					},
					{
						title: "현시각 <br> 예측<br>",
						data: 'currentFc',
						className: 'dt-head-right dt-body-right',
						render(data) {
							return data === "-" ? "-" : Math.round(data / 1000);
						},
					},
					{
						title: "금일 <br> 오차<br>",
						data: 'todayError',
						className: 'dt-head-right dt-body-right',
						render(data) {
							return data === "-" ? "-" : data.toFixed(1);
						},
					},
					{
						title: "주간 <br> 오차<br>",
						data: 'weekError',
						className: 'dt-head-right dt-body-right',
						render(data) {
							return data === "-" ? "-" : data.toFixed(1);
						},
					},
				],
				language: {
					emptyTable: i18nManager.tr("gdash.the_data_you_have_queried_does_not_exist"),
					zeroRecords:  i18nManager.tr("gdash.your_search_has_not_returned_results"),
					infoEmpty: "",
					paginate: {
						previous: "",
						next: "",
					},
					info: "",
				},
				columnDefs: [
					{targets: [0], width: "186px"},
					{targets: [1, 2, 3], width: "60px"},
					{targets: [4, 5], width: "42"},
				],
				dom: 'tip',
			});
		},

		refresh(activePower, currentDev, currentFc, todayError, weekError) {
			Table.target.clear();
			
			const tableData = [];

			App.sites.forEach((site, ix) => {
				tableData[ix] = {
					name: site.name,
					activePower: activePower[site.sid]["INV_PV"].activePower ? activePower[site.sid]["INV_PV"].activePower : "-",
					currentDev: currentDev[site.sid] ? currentDev[site.sid].energy : "-",
					currentFc: currentFc[site.sid] ? currentFc[site.sid].forecast : "-",
					todayError: todayError.each[site.sid] ? Object.values(todayError.each[site.sid])[0].accuracy : "-",
					weekError: weekError.each[site.sid] ? Object.values(weekError.each[site.sid])[0].accuracy : "-",
				}
			});

			Table.target.rows.add(tableData);
			Table.target.draw();
			Table.target.columns.adjust();
		}
	}
	
	// 금일 데이터
	const getNow = (intv = "day") => {
		return $.ajax({
			url: apiHost+"/energy/now/sites",
			type: "get",
			data: {
				sids: App.sids,
				metering_type: "2",
				interval: intv,
			},
		});
	}

	// 금일 예측 데이터
	const getForecast = (intv = "day") => {
		return $.ajax({
			url: apiHost+"/get/energy/forecasting/sites",
			type: "POST",
			dataType: 'json',
			contentType: "application/json",
			data: JSON.stringify({
				"sid": App.sids,
				"startTime": interval.today[0],
				"endTime": interval.today[1],
				"interval": intv,
				"displayType": "dashboard",
				"formId": "v2"
			}),
		});
	}


</script>