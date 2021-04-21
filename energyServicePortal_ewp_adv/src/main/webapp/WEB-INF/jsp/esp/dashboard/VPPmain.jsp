<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
<script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyAgEDjSwQWd_Q9RF_owO8WkMtf-6lmVSpc"></script>


<link type="text/css" rel="stylesheet" href="/css/vppDashboard.css" />

<!-- <div id="loadingCircle" class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div> -->

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
								<p><span id="accLastDay">-</span> %</p>
							</div>
							<div class="vpp-infobox">
								<p>전주</p>
								<p><span id="accLastWeek">-</span> %</p>
							</div>
						</div>
						<div>
							<div class="vpp-infobox">
								<p>전월</p>
								<p><span id="accLastMonth">-</span> %</p>
							</div>
							<div class="vpp-infobox">
								<p>전년</p>
								<p><span id="accLastYear">-</span> %</p>
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
							<p><span id="smpMonth">-</span> 천원</p>
						</div>
						<div class="vpp-infobox">
							<p>당해</p>
							<p><span id="smpYear">-</span> 천원</p>
						</div>
					</div>
					<div>
						<h3>예측 수익</h3>
						<div class="vpp-infobox">
							<p>당월</p>
							<p><span id="accMonth">-</span> 천원</p>
						</div>
						<div class="vpp-infobox">
							<p>당해</p>
							<p><span id="accYear">-</span> 천원</p>
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
					<p>6%</p>
				</div>
				<div class="actived">
					<div>0</div>
					<p>8%</p>
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
			url: apiHost + "/config/vpp-groups/" + vppId,
			data: {
				includeSites: true,
				includeDevices: true,
			},
		}).done(result => { 
			console.log(result)

			if (!result.sites || result.sites.length === 0) {
				showError("등록된 사이트가 없습니다.");
			} else {
				App.sites = result.sites;

				App.init();
			}
		}).fail(error => {
			console.error(error);
			
			showError("존재하지 않는 그룹입니다.");
		});

		setInterval(_ => {
			App.init();
		}, 1000 * 60 * 30);

		setInitList("locationULList");
	});

	const vppId = '${vgid}';
	const interval = {
		today: getDayInterval(),
		yesterday: getYesterdayInterval(),
		month: getMonthInterval(),
		year: getYearInterval(),
		week: getLast7DaysInterval()
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
						detailByBasetime: true,
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
// 						"displayType": "dashboard",
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
// 						"displayType": "dashboard",
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
// 						"displayType": "dashboard",
						"formId": "v2"
					}),
				}),
				/* $.ajax({ // 6
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
					}),
				}), */
				$.ajax({ // 7 - 1
					url: apiHost + "/get/energy/forecasting/sites",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sid": sids,
						"startTime": interval.today[0],
						"endTime": interval.today[1],
						"interval": "day",	
// 						"displayType": "dashboard",
						"formId": "v2"
					}),
				}),
				$.ajax({ // 8 - 1
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
				$.ajax({ // 9 - 1 //  상태 조회용
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

				$.ajax({ // 10 - 1 // 통신 조회용
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
				$.ajax({ // 11 - 1 // 테이블용
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
				$.ajax({ // 12 - 1 // 테이블용
					url: apiHost + "/energy/now/sites",
					type: "GET",
					data: {
						sids: sids,
						metering_type: 2,
						interval: "hour",
					},
				}),
				$.ajax({ // 13 - 1
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
				$.ajax({ // 14 - 1 // 테이블용
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
					}),
				}),
				$.ajax({ // 15 - 1 // 기상정보
					url: apiHost + "/get/weather/site",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sid": sids,
						"startTime": interval.today[0],
						"endTime": interval.today[1],
						"interval": "day",
						"formId": "v2",
					}),
				}),
				$.ajax({ // 16 - 1 // 주간오차
					url: apiHost + "/energy/forecast/accuracy",
					type: "POST",
					dataType: "json",
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"startTime": interval.week[0],
						"endTime": interval.week[1],
						"interval": "custom",
						"cal_incentive": false,
						"includeEachSite": true,
					}),
				}),
				$.ajax({ // 17 - 1
					type: "GET",
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						startTime: interval.year[0],
						endTime: interval.year[1],
						interval: "month",
						detailByBasetime: true,
					},
				}),
				// $.ajax({ // n // 당해 incentive
				// 	url: apiHost + "/energy/forecast/accuracy",
				// 	type: "POST",
				// 	dataType: "json",
				// 	contentType: "application/json",
				// 	data: JSON.stringify({
				// 		"sids": sids,
				// 		"startTime": interval.year[0],
				// 		"endTime": interval.today[1],
				// 		"interval": "year",
				// 		"cal_incentive": true,
				// 		"includeEachSite": false,
				// 	}),
				// }),
				/* $.ajax({ // 18 - 1
					type: "GET",
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						startTime: interval.year[0],
						endTime: interval.year[1],
						interval: "month",
						detailByBasetime: true,
					},
				}), */
				$.ajax({ // 17 // 임시 전일: // 6 호출 주석처리 되돌리면 삭제 필요
				url: apiHost + "/energy/forecast/accuracy",
				type: "POST",
				dataType: "json",
				contentType: "application/json",
				data: JSON.stringify({
					"sids": sids,
					"startTime": interval.yesterday[0],
					"endTime": interval.yesterday[1],
					"interval": "day",
					"cal_incentive": false,
					}),
				}),
			];

			new Promise ((resolve, reject) => {
				resolve(Promise.all(apis));

				$("#loadingCircleDashboard").show();
			}).then(res => {
				$("#loadingCircleDashboard").hide();

				const vppInfo = {
					"day" : Object.entries(res[0].data),
					"15min" : Object.entries(res[1].data),
					"month" : Object.entries(res[7].data),
					"hour" : Object.entries(res[12].data),
					"year" : Object.entries(res[16].data),
				};
				const acc = {
					"day": res[2].data.data,
					/* "month": res[6].data.data, */
					"month": [],
					"week": res[15].data.data,
					"year": [],
					"lastMonth": [],
					"lastYear": [] // res[17].data.data
				};
				const forecast = {
					"hour": res[3].data,
					"15min": res[4].data,
					"month": res[5].data,
					"day": res[6].data,
				};
				const status = {
					"active": res[8],
					"overall": res[9],
				};

				// const weeklyMeanAccuracy2 = getWeeklyMeanAccuracy(res[6].data.data.each); // [일~오늘] 에서 [7일전~어제(api호출값)]로 변경
				const weeklyMeanAccuracy = convertFormatWeeklyAccuracy(acc.week.each);
				TotalTrading(vppInfo.hour.map(x => x[1])); // 금일 총 전력거래량
				TotalProfit(vppInfo.hour.map(x => x[1]), acc.day); // 금일 총 수익
				Graph1.setOption(vppInfo.hour.map(x => x[1]), Object.values(forecast.hour)); // 전력거래량 예측
				Graph2.setOption(vppInfo.hour.map(x => x[1])); // 보조자원 예측
				Graph3.setOption(vppInfo.month.map(x => x[1]), vppInfo.year.map(x => x[1]), acc.month, acc.year); // 수익 현황
				PieGraph.draw(Object.values(acc.day.total).length ? Object.values(acc.day.total)[0].accuracy : "-"); // 예측 정확도
// 				PieGraph.setTextData(Object.values(acc.month.total), Object.values(acc.week.total)[0].accuracy, acc.lastMonth, acc.lastYear); // 예측 정확도 라벨 // 6 주석 되돌리면 반영 필요, 아래줄 삭제
				PieGraph.setTextData(Object.values(res[17].data.data.total), Object.values(acc.week.total)[0].accuracy, acc.lastMonth, acc.lastYear); // 예측 정확도 라벨
				setResourceStatus(vppInfo.hour); // 자원 현황
				SiteStatus.refresh(vppInfo.hour, forecast.day, acc.day, status, res[14]); // 발전 현황
				setPrediction(forecast["15min"], vppInfo.day.map(x => x[1]), Object.values(acc.day.total).length ? Object.values(acc.day.total)[0].accuracy : "-"); // 총 예측사이트 , 설비용량 , 정확도
				Table.refresh(vppInfo.hour, res[10], res[13].data.data, weeklyMeanAccuracy); // 주간 예측오차율
			}).catch(error => {
				console.log(error);
				
				showError("오류가 발생했습니다.");
			});

			if (!Table.target) {
				Table.init();
			}
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

					Table.target.draw();
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
		const smp = now.reduce((acc, cur) => acc + cur.money, 0);
		const incentive = Object.values(forecast.total).length ? Object.values(forecast.total)[0].incentive : 0;
		
		$("#todaySMP").html(Math.round(smp / 1000).toLocaleString());
		$("#todayPredictionMoney").html(Math.round(incentive / 1000).toLocaleString());
		$("#totalMoney").html(Math.round((incentive + smp) / 1000).toLocaleString())
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
			this.series[0].data = this.series[1].data = [];

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

			let temp = Object.entries(nowData).sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0);
				temp.pop();
				
			const today = String(interval.today[0]).substr(0, 8);
			for (let i = 0; i < 24; i++) {
				let indexTime = String(i).padStart(2, 0);
			
				if (!temp.find(x => x[0].substr(8, 2) === indexTime)) {
					temp.push([today+indexTime+"0000", 0]);
				}

				this.series[1].data.push(forecast.map(x => x[0].items).reduce((acc, cur) => acc + cur[i].energy, 0));
			}

			temp = temp.sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0);

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
					enabled: false
				},
				series: [{
					type: 'pie',
					innerSize: '70%',
					name: "예측 정확도",
					colorByPoint: true,
					data: [{
						color: '#cfcfcf',
						y: acc === "-" ? 0 : 100 - (acc * 100)
					}, {
						color: '#656565',
						y: acc === "-" ? 100 : acc * 100
					}]
				}],
			});
		},

		setTextData(day, week, month, year) {
// 			day.pop() // 6번 주석처리 취소시 반영 필요
			console.log(day, week, month, year)
// 			$("#accLastDay").html((100 - (day.pop().accuracy) * 100).toFixed(1)); // 6번 주석처리 취소시 반영 필요, 아래 삭
			$("#accLastDay").html((100 - (day[0].accuracy) * 100).toFixed(1));
			$("#accLastWeek").html((100 - (week) * 100).toFixed(1));
			// $("#accLastMonth").html((100 - (day) * 100).toFixed(1));
			// $("#accLastYear").html((100 - (day) * 100).toFixed(1));
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
			this.series[0].data = this.series[1].data = [];

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
			{name: '예측', color: '#878787', data: []},
			{name: 'SMP', color: '#26ccc8', data: []},
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
					stackLabels: {
						enabled: true,
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
					column: {
						stacking: 'normal',
						dataLabels: {
							enabled: false
						}
					}
				},
				series: Graph3.series
			});
		},

		setOption(smpMonth, smpYear, accMonth, accYear) {
			this.series[0].data = this.series[1].data = [];
			
			const nowData = {};

			$.each(smpMonth.map(x => x.detail), (ix, el) => {
				$.each(el, (k, v) => {
					nowData[k] = (nowData[k] ? nowData[k] : 0);
					if (k !== "devices") {
						nowData[k] += v.money;
					}
				});
			});
			
			let temp = Object.entries(nowData).sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0);
				temp.pop();
			
			if(accMonth.total) {
				fillArray(Object.entries(accMonth.total).map(x => x[1].incentive), getLastDay()).forEach((v, k) => {
					this.series[0].data.push(v);
				});
			}

			this.series[1].data = fillArray(temp.map(x => x[1]), getLastDay());

			$("#smpMonth").html(Math.round(smpMonth.reduce((acc, cur) => acc + cur.money, 0) / 1000).toLocaleString())
			$("#smpYear").html(Math.round(smpYear.reduce((acc, cur) => acc + cur.money, 0) / 1000).toLocaleString());
			if(accMonth.total) {$("#accMonth").html(Math.round(Object.values(accMonth.total).reduce((acc, cur) => acc + cur.incentive, 0) / 1000).toLocaleString());}
			// $("#accYear").html(Math.round(Object.values(accYear.total).reduce((acc, cur) => acc + cur.incentive, 0) / 1000).toLocaleString());
			console.log(smpMonth, smpYear, accMonth, accYear)
			
			this.draw();
		},
	}

	// 자원 현황
	const setResourceStatus = (energy) => {
		energy = energy.map(x => x[1]);
		
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
	}
	
	// 발전 현황 지도
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

		refresh(energyData, forecast, acc, status, weather) {
			let tableTemplate = ``;

			App.sites.map(x => {
				let now = energyData.find(v => v[0] === x.sid)[1];
				let forecastEnergy = forecast[x.sid] ? forecast[x.sid][0].items[0].energy : 0;
				let incentive = acc.each[x.sid] ? Object.values(acc.each[x.sid])[0].incentive : 0;
				let active = Object.values(status.active[x.sid]).length ? ["normal", "정상"] : ["error", "이상"];
				let overall = Object.values(status.overall[x.sid]).length ? ["normal", "정상"] : ["NA", "N/A"];
				let weatherData = weather.data[x.sid].items[0];
				let irr = 
					weatherData.sensor_solar.irradiationPoa
					? weatherData.sensor_solar.irradiationPoa
					: weatherData.irradiationPoa;

				irr = irr === null && "-";

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
											<li>${'${irr}'} kWh/m.day</li>
										</ul>
										<div class="flex-center">
											<ul>
												<li>온도</li>
												<li>${'${weatherData.temperature}'}%</li>
											</ul>
											<ul>
												<li>습도</li>
												<li>${'${weatherData.humidity}'}%</li>
											</ul>
										</div>
									</div>
								</div>

								<div class="vpp-fold-menu-content">
									<div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>${'${((now.capacity / 1000).toFixed(2) * 1).toLocaleString()}'} kW</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 누적거래량</p>
											<p>${'${((now.energy / 1000).toFixed(2) * 1).toLocaleString()}'} kWh</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 예측거래량</p>
											<p>${'${((forecastEnergy / 1000).toFixed(2) * 1).toLocaleString()}'} kWh</p>
										</div>
									</div>
									<div>
										<div class="vpp-infobox">
											<p>금일 SMP 수익</p>
											<p>${'${Math.round(now.money / 1000).toLocaleString()}'} 천원</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 예측 수익</p>
											<p>${'${Math.round(incentive / 1000).toLocaleString()}'} 천원</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 총 수익</p>
											<p>${'${Math.round((incentive + now.money) / 1000).toLocaleString()}'} 천원</p>
										</div>
									</div>
								</div>
							</div>
						</td>
					</tr>
				`;

				VppMap.geocodeAddress(x.address, x.sid, x.latlng, "#90caf3");
			});
			$("#vppMapTable tbody").html(tableTemplate);

			this.rolling();
		},

		rolling() {
			clearInterval(this.interval);
			
			this.idx = 0;
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
		$("#totalAcc").html(acc === "-" ? "-" : (100 - (acc * 100)).toFixed(1));
	}

	// 주간 예측오차율 
	const Table = {
		target: null,

		init() {
			Table.target = $("#vpp-3-2-dataTable").DataTable({
				autoWidth: true,
				fixedHeader: true,
				"table-layout": "fixed",
				scrollX: false,
				scrollY: false,
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
						title: "설비용량",
						data: 'capacity',
						className: 'dt-head-right dt-body-right',
						render(data) {
							return data === "-" ? "-" : Math.round(data / 1000);
						},
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
						title: "금일 오차",
						data: 'todayError',
						className: 'dt-head-right dt-body-right',
						render(data) {
							return data === "-" ? "-" : data.toFixed(1);
						},
					},
					{
						title: "주간 오차",
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
					{targets: [1, 2, 3, 4], width: "60px"},
				],
				dom: 'tip',
			});
		},

		refresh(capacity, activePower, todayError, weekError) {
			Table.target.clear();
			
			const tableData = [];

			Table.range = [
				{min: 0, max: 6, index: 0, count: 0},
				{min: 6, max: 8, index: 1, count: 0},
				{min: 8, max: 10, index: 2, count: 0},
				{min: 10, max: 20, index: 3, count: 0},
				{min: 20, max: Infinity, index: 4, count: 0},
			];
			App.sites.forEach((site, ix) => {
				let ap = Object.values(activePower[site.sid])

				tableData[ix] = {
					name: site.name,
					capacity: capacity.find(x => x[0] === site.sid)[1].capacity,
					activePower: (ap.length === 0 || Object.keys(ap)[0] === "0") ? "-" : ap[0].activePower,
					todayError: todayError.each[site.sid] ? Object.values(todayError.each[site.sid])[0].accuracy * 100 : "-",
					weekError: weekError[site.sid] ? weekError[site.sid] * 100 : "-",
				}
				
				Table.range.some((range, index) => {
					let acc = tableData[ix].weekError === '-' ? 100 : tableData[ix].weekError;

					if (range.min < acc && acc <= range.max) {
						Table.range[index].count++;

						$(".vpp-3-2-graph > div:nth-child("+(index + 1)+") > div").html(Table.range[index].count);

						return true;
					}
				});
			});
			console.log(tableData)

			$.fn.dataTable.ext.search.push (
				function(settings, data, dataIndex) {
					const acc = data[4] === '-' ? 100 : data[4];

					let targetBoolean = false;
					Table.range.forEach((range, index) => {
						if (range.min < acc && acc <= range.max) {
							if ($(".vpp-3-2-graph > div").eq(range['index']).hasClass('actived')) {
								targetBoolean = true;
							}
						}
					});

					return targetBoolean;
				}
			)

			Table.target.rows.add(tableData);
			Table.target.columns.adjust();
			Table.target.draw();
		},
	}

	// Etc. ƒunction
	const showError = (msg) => {
		$('#errMsg').text(msg);2
		$('#errorModal').modal('show');
		setTimeout(function () {
			$('#errorModal').modal('hide');
		}, 2000);
	}

	const convertFormatWeeklyAccuracy = (each) => {
		let result = {};
		for(sid in each) {
			result[sid] = Object.values(each[sid])[0].accuracy;
		}
		return result;
	}

	const getWeeklyMeanAccuracy = (eachSiteDailyAccuracy) => {
		let weeklyAccuracyMean = {};
		const weekStart = getWeekInterval()[0];
		const daysInWeek = getLast7Days();

		for(site in eachSiteDailyAccuracy) {
			const siteData = eachSiteDailyAccuracy[site];
			let accuSum = 0;
			let count = 0;
			for(date of daysInWeek) {
				if(siteData[date]) {
					accuSum += siteData[date].accuracy;
					count += 1;
				}
			}

			if(count > 0) {
				const accuMean = accuSum / count;
				weeklyAccuracyMean[site] = accuMean;
			}
		}
		return weeklyAccuracyMean;
	}


</script>