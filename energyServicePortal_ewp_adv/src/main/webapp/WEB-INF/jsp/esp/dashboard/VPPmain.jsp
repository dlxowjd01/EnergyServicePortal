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
				<div>그래프</div>
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
							<p>- 만원</p>
						</div>
						<div class="vpp-infobox">
							<p>당해</p>
							<p>- 만원</p>
						</div>
					</div>
					<div>
						<h3>예측 수익</h3>
						<div class="vpp-infobox">
							<p>당월</p>
							<p>- 만원</p>
						</div>
						<div class="vpp-infobox">
							<p>당해</p>
							<p>- 만원</p>
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
							<img src="" alt="" />
						</div>
						<div class="actived" id="subResource_fuelcell">
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
				<div class="auto-rolling play">
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
					<div>32</div>
					<p>8%</p>
				</div>
				<div class="actived">
					<div>42</div>
					<p>6%</p>
				</div>
				<div class="actived">
					<div>15</div>
					<p>10%</p>
				</div>
				<div class="actived">
					<div>4</div>
					<p>20%</p>
				</div>
				<div class="actived">
					<div>1</div>
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
	$(_ => {
		$.when(
			$.ajax({
				type: "GET",
				url: apiHost + "/config/vpp-groups/" + tempId,
				data: {
					includeSites: true,
					includeDevices: true,
				},
			}).done(r1 => {
				const sids = r1.sites.map(x => x.sid).join();

				$.ajax({
					url: apiHost + "/vpp/energy/sites",
					data: {
						sid: sids,
						interval: "15min",
						isLimited: true,
						startTime: getTime(0, true)
					},
					async: false,
				}).done(r2 => {
					r1.energyData = Object.entries(r2.data).map(x => {
						x[1].sid = x[0];

						return x[1];
					});
				});

				$.ajax({
					url: apiHost + "/energy/forecast/accuracy",
					type: "POST",
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify({
						"sids": sids,
						"startTime": interval[0],
						"endTime": interval[1],
						"interval": "day",
						"cal_incentive": true,
						"additionalProp1": {}
					}),
					async: false
				}).done(r3 => {
					App.acc = r3.data.data;
				});

				return r1;
			})
		).then(r => {
			console.log(r);
			App.sites = r.sites;
			App.energyData = r.energyData;
			App.sids = r.sites.map(x => x.sid).join();

			App.init();
		})

	});

	// 임시 VPP ID --------
	const tempId = "8b3c35b9-8229-447e-a9c2-b3c8e65bd622";
	const interval = getDayInterval();

	// 메인 객체
	const App = {
		sites: [],
		sids: [],
		energyData: [],
		acc: [],

		init() {
			App.setEvent();
			TotalTrading.init();
			TotalProfit.init();
			Resources.init();
			Graph1.refresh();
			SiteStatus.init();
			Prediction.accuracy();
			PieGraph.init();
			Table.init();
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
					$(this).toggleClass("play stop");
					rolling();
				})
				.on("click", ".vpp-1-3 > .title-area > .title", function(e) {
					$(".vpp-1-3 > .title-area > .title.actived").removeClass("actived");
					$(this).addClass("actived");

					$(".vpp-1-3-content").removeClass("view");
					$(".vpp-1-3-"+($(this).index() + 1)).addClass("view");
				})
				.on("click", ".vpp-focus-map, .vpp-pin", VppMap.focusTo)
		},
	}

	// 금일 총 전력거래량
	const TotalTrading = {
		init() {
			$("#totalEnergy").html((App.energyData.reduce((acc, cur) => acc + cur.energy, 0) / 1000 / 1000).toFixed(2));
			$("#mainEnergy").html((App.energyData.reduce((acc, cur) => acc + cur.energyPrimary, 0) / 1000 / 1000).toFixed(2));
			$("#subEnergy").html((App.energyData.reduce((acc, cur) => acc + cur.energySecondary, 0) / 1000 / 1000).toFixed(2));
		},
	}

	// 금일 총 수익
	const TotalProfit = {
		init() {
			$.when(getNow(), getForecast()).then((now, forecast) => {
				now = Object.entries(now[0].data).map(x => {
					x[1].sid = x[0];
					
					return x[1];
				});
				
				forecast = Object.entries(forecast[0].data).map(x => x[1][0].items[0]);
				
				$("#totalMoney, #todaySMP").html((now.reduce((acc, cur) => acc + cur.money, 0) / 1000).toFixed(2));
				$("#todayPredictionMoney").html((forecast.reduce((acc, cur) => acc + cur.money, 0) / 1000).toFixed(2));
			});
		},
	}

	// 전력거래량 예측
	const Graph1 = {
		series: [
			{name: '실측', type: 'area', color: 'var(--circle-solar-power)', data: [], suffix: 'kWh'},
			{name: '예측', type: 'line', color: 'var(--white)', data: [], suffix: 'kWh'},
		],
		target: {},

		setOption() {
			Graph1.target = Highcharts.chart("vppGraph1", {
				chart: {
					marginLeft: 0,
					backgroundColor: 'transparent',
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
						x: 9,
						align: 'center',
						style: {
							color: 'var(--grey)',
							fontSize: '10px',
							rotation: 0
						}
					},
					tickInterval: 1,
					title: {
						text: null
					},
					categories: ['2', '4', '6', '8', '10', '12', '14', '16', '18', '20', '22', '24'],
				}],
				yAxis: [{
					lineColor: 'var(--grey)',
					tickColor: 'var(--grey)',
					gridLineColor: 'var(--white25)',
					gridLineWidth: 1,
					title: {
						x: 10,
						y: 30,
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
						y: 15,
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

		refresh() {
			$.when(getNow("15min"), getForecast("hour")).then((now, forecast) => {
				const data = [
					Object.entries(now[0].data).map(x => {
						x[1].sid = x[0];
						
						return x[1].energy;
					}),
					Object.entries(forecast[0].data).map(x => x[1][0].items[0].energy)
				];
		
				$.each(Graph1.series, (ix, el) => {
					Graph1.series[ix].data = fillArray(data[ix], 12);
				});

				console.log(Graph1.series)

				Graph1.setOption();

				Graph1.target.redraw();
			})
		},
	}

	const PieGraph = {
		init() {
			Highcharts.chart("vppPie", {
				chart: {
					backgroundColor: "transparent",
					plotBorderWidth: 0,
					height: 103
				},
				title: {
					text: '95.1%',
					align: 'center',
					verticalAlign: 'middle',
					y: 0,
					style: {
						fontSize: "15px",
						color: "var(--white87)",
						fontWeight: "normal"
					}
				},
				plotOptions: {
					pie: {
						startAngle: 0,
						endAngle: 360,
						center: ['50%', '50%'],
						size: '98px'
					}
				},
				series: [{
					type: 'pie',
					name: '예측',
					innerSize: '50%',
					color: "#cfcfcf",
					data: [
						['예측', 95.1],
					]
				}]
			});
		}
	}

	const MoneyStatus = {
		init() {
			
		},

		refresh() {
			
		},
	}

	// 자원 현황
	const Resources = {
		init() {
			App.energyData.map(x => {
				if (!x.ess) {
					$("#subResource_ESS").removeClass("actived");
				}

				let resource = "";
				switch (x.resource_type) {
					case 1:
						resource = "#mainResource_sun";
					break;
					
					case 2:
						resource = "#mainResource_wind";
					break;

					case 4:
						resource = "#subResource_fuelcell";
					break;
				}

				$(resource).addClass("actived");
				if ($(resource).find(".network-status-img").attr("src") === "" && (x.energyPrimary <= 0 || x.energySecondary <= 0)) {
					$(resource).find(".network-status-img").attr("src", "/img/vpp/network-error-yellow.svg");
				} else {
					$(resource).find(".network-status-img").attr("src", "/img/vpp/network-normal.svg");
				}
			});
		}
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

		focusTo() {
			if (typeof(VppMap.smoothZoom) == 'function') {
				let self = $(this);
				let sid = self.data('sid');
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
		init() {
			let tableTemplate = ``;
			let energy = {};
			App.sites.map(x => {
				energy = App.energyData.find(v => v.sid === x.sid);

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
						<td> <span class="status-button normal">정상</span> </td>
						<td> <span class="status-button error">이상</span> </td>
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
											<p>- kWh</p>
										</div>
									</div>
									<div>
										<div class="vpp-infobox">
											<p>금일 SMP 수익</p>
											<p>- 천원</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 예측 수익</p>
											<p>- 천원</p>
										</div>
										<div class="vpp-infobox">
											<p>금일 총 수익</p>
											<p>- 천원</p>
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
		},

		rolling() {
			const play = $(".auto-rolling").hasClass("play") ? true : false;

		}
	}

	const Prediction = {
		site() {

		},

		capacity() {

		},

		accuracy() {

		}
	}

	// 주간 예측오차율 
	const Table = {
		target: null,

		init() {
			Table.target = $("#vpp-3-2-dataTable").DataTable({
				autoWidth: false,
				"table-layout": "fixed",
				scrollX: false,
				scrollY: '720px',
				scrollCollapse: true,
				sortable: true,
				paging: false,
				columns: [
					{
						title: "사이트 명",
						data: 'name',
						className: 'dt-head-left dt-body-left'
					},
					{
						title: "용량",
						data: 'capacity',
						className: 'dt-head-right dt-body-right'
					},
					{
						title: "금일 <br> 오차<br>",
						data: 'todayError',
						className: 'dt-head-right dt-body-right'
					},
					{
						title: "주간 <br> 오차<br>",
						data: 'weekError',
						className: 'dt-head-right dt-body-right'
					},
					{
						title: "이전 <br> 30일 오차<br>",
						data: 'beforeError',
						className: 'dt-head-right dt-body-right'
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
					{targets: [0], width: "185px"},
					{targets: [1, 2, 3, 4], width: "75px"},
				],
				dom: 'tip',
			});

			Table.refresh();
		},

		refresh() {
			const tableData = [];

			App.sites.forEach((site, ix) => {
				const ed = App.energyData.find(x => x.sid === site.sid);

				tableData[ix] = {
					name: site.name,
					capacity: Math.round(ed.capacity / 1000),
					todayError: "-",
					weekError: "-",
					beforeError: "-",
				}
			})

			console.log(tableData);

			Table.target.clear();
			Table.target.rows.add(tableData);
			Table.target.draw();
			Table.target.columns.adjust();
		}
	}
	
	// 금일 데이터
	function getNow(intv = "day") {
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
	function getForecast(intv = "day") {
		return $.ajax({
			url: apiHost+"/get/energy/forecasting/sites",
			type: "POST",
			dataType: 'json',
			contentType: "application/json",
			data: JSON.stringify({
				"sid": App.sids,
				"startTime": interval[0],
				"endTime": interval[1],
				"interval": intv,
				"displayType": "dashboard",
				"formId": "v2"
			}),
		});
	}
</script>