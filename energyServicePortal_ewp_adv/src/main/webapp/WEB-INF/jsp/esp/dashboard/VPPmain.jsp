<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<!-- <c:if test="${dashboardMap eq 'google'}">
	<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
	<script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyAgEDjSwQWd_Q9RF_owO8WkMtf-6lmVSpc"></script>
</c:if> -->

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
				<p class="vpp-1-1-value"><span>100.00</span> <span>MWh</span></p>
				<div>
					<div class="vpp-infobox">
						<p>금일 주요자원 거래량</p>
						<p>100.05 MWh</p>
					</div>
					<div class="vpp-infobox">
						<p>금일 보조자원 거래량</p>
						<p>100.05 MWh</p>
					</div>
				</div>
			</div>
			<div class="indiv vpp1-1-2">
				<h2 class="title">금일 총 수익</h2>
				<p class="vpp-1-1-value"><span>100.00</span> <span>만원</span></p>
				<div>
					<div class="vpp-infobox">
						<p>금일 주요자원 거래량</p>
						<p>100.05 MWh</p>
					</div>
					<div class="vpp-infobox">
						<p>금일 보조자원 거래량</p>
						<p>100.05 MWh</p>
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
								<p>95%</p>
							</div>
							<div class="vpp-infobox">
								<p>전일</p>
								<p>95%</p>
							</div>
						</div>
						<div>
							<div class="vpp-infobox">
								<p>전일</p>
								<p>95%</p>
							</div>
							<div class="vpp-infobox">
								<p>전일</p>
								<p>95%</p>
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
					<div> 
						<!-- 그래프 -->
					</div>
				</div>
				<div class="vpp-1-4-2">
					<div>
						<h3>SMP 수익</h3>
						<div class="vpp-infobox">
							<p>당월</p>
							<p>3000.8 만원</p>
						</div>
						<div class="vpp-infobox">
							<p>당월</p>
							<p>3000.8 만원</p>
						</div>
					</div>
					<div>
						<h3>SMP 수익</h3>
						<div class="vpp-infobox">
							<p>당월</p>
							<p>3000.8 만원</p>
						</div>
						<div class="vpp-infobox">
							<p>당월</p>
							<p>3000.8 만원</p>
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
						<div class="actived">
							<div class="vpp-2-1-1-img">
								<img src="/img/vpp/solar-panel.svg" alt="태양광" />
								<img src="/img/vpp/network-normal.svg" alt="가동" class="network-status-img" />
							</div>
							<p>태양광</p>
						</div>
						<div>
							<div class="vpp-2-1-1-img">
								<img src="/img/vpp/wind-power.svg" alt="풍력" />
								<!-- <img src="/img/vpp/network-error-yellow.svg" alt="가동" class="network-status-img" /> -->
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
						<div class="actived">
							<div class="flex-center">
								<img src="/img/vpp/ess.svg" alt="태양광" />
								<p>ESS</p>
							</div>
							<img src="/img/vpp/network-error-yellow.svg" alt="통신" />
						</div>
						<div>
							<div class="flex-center">
								<img src="/img/vpp/fuelcell.svg" alt="풍력" />
								<p>연료전지</p>
							</div>
							<!-- <img src="/img/vpp/network-normal.svg" alt="통신" /> -->
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
						<col width="32%">
						<col width="26%">
						<col width="14%">
						<col width="14%">
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
					<tbody>
						<tr>
							<td>강릉</td>
							<td>강릉삼복태양광발전소</td>
							<td>
								<img src="/img/vpp/solar-panel.svg" alt="자원" class="actived">
								<img src="/img/vpp/wind-power.svg" alt="자원" class="actived">
								<img src="/img/vpp/ess.svg" alt="자원" class="actived">
								<img src="/img/vpp/fuelcell.svg" alt="자원" class="">
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
												<li>61 kWh/m.day</li>
											</ul>
											<div class="flex-center">
												<ul>
													<li>온도</li>
													<li>23%</li>
												</ul>
												<ul>
													<li>온도</li>
													<li>23%</li>
												</ul>
											</div>
										</div>
									</div>

									<div class="vpp-fold-menu-content">
										<div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
										</div>
										<div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
										</div>
									</div>
								</div>
							</td>
						</tr>

						<tr>
							<td>ㅇㅇ</td>
							<td>123123ㅁㄴㅇ</td>
							<td>
								<img src="/img/vpp/solar-panel.svg" alt="자원" class="">
								<img src="/img/vpp/wind-power.svg" alt="자원" class="">
								<img src="/img/vpp/ess.svg" alt="자원" class="actived">
								<img src="/img/vpp/fuelcell.svg" alt="자원" class="">
							</td>
							<td> <span class="off">정상</span> </td>
							<td> <span class="off">이상</span> </td>
						</tr>
						<tr class="vpp-fold-menu">
							<td colspan="5">
								<div>
									<div class="vpp-fold-menu-header">
										<img src="/img/weather_icons/ico1_sun.svg" alt="날씨"> 
										<div>
											<ul>
												<li>일사량</li>
												<li>61 kWh/m.day</li>
											</ul>
											<div class="flex-center">
												<ul>
													<li>온도</li>
													<li>23%</li>
												</ul>
												<ul>
													<li>온도</li>
													<li>23%</li>
												</ul>
											</div>
										</div>
									</div>

									<div class="vpp-fold-menu-content">
										<div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
										</div>
										<div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
											<div class="vpp-infobox">
												<p>발전소 용량</p>
												<p>91.12kW</p>
											</div>
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

	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv vpp-3-1">
			<div class="vpp-infobox">
				<p>총 예측 사이트</p>
				<p><span>94</span> 개소</p>
			</div>
			<div class="vpp-infobox">
				<p>총 예측 사이트</p>
				<p><span>94</span> 개소</p>
			</div>
			<div class="vpp-infobox">
				<p>총 예측 사이트</p>
				<p><span>94</span> 개소</p>
			</div>
		</div>
		<div class="indiv vpp-3-2">
			<h2 class="title">주간 예측오차율</h2>
			<!-- vpp-3-2-graph 만들때 마지막거부터 -->
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
					<col width="60px">
					<col width="60px">
					<col width="60px">
					<col width="60px">
					<col width="60px">
				</colgroup>
			</table>
		</div>
	</div>
</div>

<script>
	$(_ => {
		// 임시
		$("#vpp-3-2-dataTable").DataTable({
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
					// data: 'siteName',
					// render: function (data, type, full, rowIndex) {
					// },
					className: 'dt-head-left dt-body-left'
				},
				{
					title: "현재출력",
					// data: 'siteName',
					// render: function (data, type, full, rowIndex) {
					// },
					className: 'dt-head-left dt-body-right'
				},
				{
					title: "현시각 발전",
					// data: 'siteName',
					// render: function (data, type, full, rowIndex) {
					// },
					className: 'dt-head-left dt-body-right'
				},
				{
					title: "현시각 예측",
					// data: 'siteName',
					// render: function (data, type, full, rowIndex) {
					// },
					className: 'dt-head-left dt-body-right'
				},
				{
					title: "금일 오차",
					// data: 'siteName',
					// render: function (data, type, full, rowIndex) {
					// },
					className: 'dt-head-left dt-body-right'
				},
				{
					title: "주간 오차",
					// data: 'siteName',
					// render: function (data, type, full, rowIndex) {
					// },
					className: 'dt-head-left dt-body-right'
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
			dom: 'tip',
		}).columns.adjust().draw();

		// 이벤트 체이닝
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

		rolling();
	});

	function rolling() {
		const play = $(".auto-rolling").hasClass("play") ? true : false;

		// alert(play);
	}
</script>
