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
			<h2 class="title">금일 발전현황</h2>

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
					<h2 class="subtitle">연료 유입</h2>
					<div class="smainV2-status-block">
						<ul>
							<li>
								<img src="/img/smainV2/gas.svg" alt="GAS" />
								<span>GAS</span>
							</li>
							<li>507 Nm3/hr</li>
						</ul>
					</div>
				</div>
				<div class="arrow"></div>
				<div class="smainV2-status-right">
					<div class="smainV2-status-block">
						<ul>
							<li>
								<img src="/img/smainV2/electricity.svg" alt="전력" />
								<span>전력</span>
							</li>
							<li>303.7 kW</li>
						</ul>
					</div>
					<div class="arrow"></div>
					<div>
						<img src="/img/smainV2/fuelcell.svg" alt="연료전지" />
						<div>
							<h2>연료전지</h2>
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
					</div>
					<div class="arrow"></div>
					<div class="smainV2-status-block">
						<ul>
							<li>
								<img src="/img/smainV2/hotwater.svg" alt="온수" />
								<span>온수</span>
							</li>
							<li>60 °C</li>
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
				<div class="alarm-alert"><span><fmt:message key="gdash.6.today_alerts"/></span><em>0</em></div>
				<div class="alarm-warning"><a href="javascript:void(0);" onclick="pageMove('all', 'alarm');" class="btn btn-cancel"><fmt:message key="gdash.6.details"/></a></div>
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
			<h2 class="title">월별 발전량 종합</h2>

		</div>
	</div>
</div>