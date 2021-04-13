<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

	<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
	<script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyAgEDjSwQWd_Q9RF_owO8WkMtf-6lmVSpc"></script>


<link type="text/css" rel="stylesheet" href="/css/smainV2.css" />


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

<div class="row content-wrapper" id="smainV2Content">
	<div class="smainV2-section col-xl-4 col-md-12 col-sm-12">
		<div class="smainV2-block">
			<div class="indiv smainV2-block-s">
				<h2 class="title">금일 발전량</h2>
				<h1 class="value-unit">
					<span>3,874</span>
					<span>kW</span>
				</h1>
			</div>
			<div class="indiv smainV2-block-s">
				<h2 class="title">금일 열 생산량</h2>
				<h1 class="value-unit">
					<span>28,835</span>
					<span>Kcal/h</span>
				</h1>
			</div>
		</div>
		<div class="indiv smainV2-block-m" id="smainV2-1-2">
			<h2 class="title">실시간 운영정보</h2>
			<div>
				<div>
					<p>운전 상태</p>
					<span class="status-button normal">운전중</span>
				</div>
				<div>
					<p>통신 상태</p>
					<span class="status-button normal">정상</span>
				</div>
				<div>
					<p>인버터 상태</p>
					<span class="status-button error">이상</span>
				</div>
			</div>
			<div>
				<ul>
					<li>연료전지용량</li>
					<li><span>0.8</span> MW</li>
				</ul>
				<ul>
					<li>금일 운영시간</li>
					<li><span>4.79</span> Hrs</li>
				</ul>
			</div>
		</div>
		<div class="indiv smainV2-block-l">
			<h2 class="title mb-24">
				금일 발전현황
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span>2021.04.01 ~ 2021.04.13</span>
					<img src="/img/ico-next.svg" class="next">
				</span>
			</h2>

			<div id="">
				<!-- 금일 발전현황 그래프 -->
			</div>
		</div>
	</div>

	<div class="smainV2-section col-xl-4 col-md-12 col-sm-12">
		<div class="smainV2-block">
			<div class="indiv smainV2-block-s">
				<h2 class="title">금일 누적수익</h2>
				<h1 class="value-unit">
					<span>95</span>
					<span>천원</span>
				</h1>
			</div>
			<div class="indiv smainV2-block-s">
				<h2 class="title">전일 발전량</h2>
				<h1 class="value-unit">
					<span>8,544</span>
					<span>kWh</span>
				</h1>
			</div>
		</div>
		<div class="indiv smainV2-block-xl">
			<h2 class="title">실시간 운전현황</h2>
			<div id="smainV2-status">
				<div class="smainV2-status-left">
					<p class="subtitle">연료 유입</p>
					<div>
						<div class="smainV2-status-block">
							<ul>
								<li>
									<img src="/img/smainV2/gas.svg" alt="GAS" />
									<span>GAS</span>
								</li>
								<li><span>507</span> N<span class="small-text">m</span>3/hr</li>
							</ul>
						</div>
						<div class="arrow">
							<div></div>
							<div></div>
							<div></div>
						</div>
					</div>
				</div>
				<div class="smainV2-status-right">
					<div class="smainV2-status-block">
						<ul>
							<li>
								<img src="/img/smainV2/electricity.svg" alt="전력" />
								<span>전력</span>
							</li>
							<li><span>303,7</span> kW</li>
						</ul>
					</div>

					<div class="arrow">
						<div></div>
						<div></div>
						<div></div>
					</div>

					<div class="smainV2-status-block">
						<ul>
							<li>
								<img src="/img/smainV2/fuelcell.svg" alt="연료전지" />
								<span>연료전지</span>
							</li>
						</ul>
						<div>
							<ul>
								<li>전기 효율</li>
								<li><span>9.6</span> %</li>
							</ul>
							<ul>
								<li>열 효율</li>
								<li><span>11</span> %</li>
							</ul>
						</div>
					</div>

					<div class="arrow">
						<div></div>
						<div></div>
						<div></div>
					</div>

					<div class="smainV2-status-block">
						<ul>
							<li>
								<img src="/img/smainV2/hotwater.svg" alt="온수" />
								<span>온수</span>
							</li>
							<li><span>60</span> °C</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="smainV2-section col-xl-4 col-md-12 col-sm-12">
		<div class="smainV2-block">
			<div class="indiv smainV2-block-s">
				<h2 class="title">누적 방전량</h2>
				<h1 class="value-unit">
					<span>15,735.3</span>
					<span>MWh</span>
				</h1>
			</div>
			<div class="indiv smainV2-block-s">
				<h2 class="title">누적 열 생산량</h2>
				<h1 class="value-unit">
					<span>937</span>
					<span>Gcal/h</span>
				</h1>
			</div>
		</div>
		<div class="indiv smainV2-block-m smainV2-alarm" data-alarm="">
			<div class="alarm-status">
				<div class="alarm-alert"><span>알림 메시지</span><em>0</em></div>
			</div>
			<div class="alarm-notice">
				<ul id="alarmNotice">
					<li>
						<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');">
							<span class="err-msg">[site_name] - [message]</span>
							<span class="err-time">[standardTime]</span>
						</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="indiv smainV2-block-l">
			<h2 class="title">
				월별 발전량 종합
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span>2021.04.01 ~ 2021.04.13</span>
					<img src="/img/ico-next.svg" class="next">
				</span>
			</h2>

			<div class="smainV2-month-list">
				<ul>
					<li>이번달 총 발전량</li>
					<li>
						<span>8.49</span> kWh
					</li>
				</ul>
				<ul>
					<li>올해 누적 발전량</li>
					<li>
						<span>15.90</span> MWh
					</li>
				</ul>
				<ul>
					<li>이번달 운영 시간</li>
					<li>
						<span>3.69</span> Hrs
					</li>
				</ul>
			</div>

			<div id="">
				<!-- 월별 발전량 종합 그래프 -->
			</div>
		</div>
	</div>
</div>