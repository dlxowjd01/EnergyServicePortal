<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<link type="text/css" rel="stylesheet" href="/css/spcDashboard.css" />


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

<div class="row content-wrapper" id="spcDashboardContent">
	<div class="indiv spcDashboard1-1">
		<div>
			<h2 class="title">발전 현황</h2>
			<p class="number-unit"><span>55.7</span> MW</p>
		</div>
		<div>
			<h2 class="title">올해 이익률</h2>
			<p class="number-unit"><span>34</span> %</p>
		</div>
	</div>

	<div class="indiv spcDashboard1-2">
		<div>
			<h2 class="title">올해 이익금</h2>
			<p class="number-unit"><span>300,000,000</span> 원</p>
		</div>
		<div>
			<ul>
				<li>올해 수입총계</li>
				<li><span>450,000,000</span> 원</li>
			</ul>
			<ul>
				<li>올해 지출총계</li>
				<li><span>150,000,000</span> 원</li>
			</ul>
		</div>
	</div>

	<div class="indiv spcDashboard1-3">
		<ul id="spcCategory">
			<li class="actived">보험료</li>
			<li>세금과 공과</li>
			<li>기장료</li>
			<li>등기용익수수료</li>
			<li>회계감사수수료</li>
			<li>지급수수료</li>
			<li>경비용역료</li>
			<li>임대료</li>
			<li>전력비</li>
			<li>통신비</li>
			<li>전기안전관리수수료</li>
			<li>수선유지비</li>
		</ul>
		<div>
			<div>
				<span class="blue">8위</span>
				<div>
					<p>지출 총계</p>
					<div><p class="number-unit"><span>500</span> 만원</p></div>
				</div>
			</div>
			<div>
				<span class="increase">증가</span>
				<div>
					<p>전월 대비</p>
					<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>+8.34</span> %</p></div>
				</div>
			</div>
			<div>
				<span class="decrease">감소</span>
				<div>
					<p>전년 대비</p>
					<div><img src="/img/spcDashboard/down.svg" alt="증가" /><p class="number-unit"> <span>-8.34</span> %</p></div>
				</div>
			</div>
			<div>
				<span class="normal">일정</span>
				<div>
					<p>전년 대비</p>
					<div><img src="/img/spcDashboard/flat.svg" alt="증가" /> <p class="number-unit"><span>0</span> %</p></div>
				</div>
			</div>
		</div>
	</div>

	<div class="indiv spcDashboard2-1">
		<h2 class="title">평균 지출 비율</h2>
		<div id="graph1"> 
			<!-- 그래프 -->
		</div>
	</div>
	
	<div class="indiv spcDashboard2-2">
		<h2 class="title">
			종합 지출 총계
			<span>2021.01.01 ~ 2021.03.10</span>
		</h2>
		<div id="graph2">
			<!-- 그래프 -->
		</div>
	</div>

	<div class="indiv spcDashboard2-3">
		<h2 class="title">올해 발전소 수익률</h2>
		<div class="spcDashboard-filter">
			<div class="actived">
				<div>42</div>
				<p>
					<span>100%</span>
					<span>80%</span>
				</p>
			</div>
			<div class="actived">
				<div>32</div>
				<p>60%</p>
			</div>
			<div class="actived">
				<div>15</div>
				<p>40%</p>
			</div>
			<div class="actived">
				<div>4</div>
				<p>20%</p>
			</div>
			<div class="actived">
				<div>1</div>
				<p>0%</p>
			</div>
			<div class="actived">
				<div>1</div>
				<p>마이너스</p>
			</div>
		</div>

		<h3>발전소 수입/지출 현황</h3>
		
		<div class="spcDashboard-table" id=table1>
			<!-- dataTable -->
		</div>
	</div>

	<div class="indiv spcDashboard3-1">
		<div>
			<div class="title-area">
				<h2 class="title actived">항목별 지출</h2>
				<h2 class="title">용량대비 지출/관리운영비 추이</h2>
			</div>
			<ul class="interval-selector">
				<li class="actived">월별</li>
				<li>연도별</li>
			</ul>
		</div>
		<div id="graph3">
			<!-- 그래프 -->
		</div>
	</div>

	<div class="indiv spcDashboard3-2">
		<h2 class="title">MW당 항목별 지출금액</h2>
		<div class="spcDashboard3-2-graph-wrap">
			<button class="direction-button prev"> <img src="/img/spcDashboard/pre.svg" alt=""> </button>
			<div id="graph4">
				<!-- 그래프 -->
			</div>
			<button class="direction-button next"> <img src="/img/spcDashboard/next.svg" alt=""> </button>
		</div>
	</div>
</div>

<script>
	// 기본 상호작용
	$("#spcCategory > li").on("click", function(e) {
		$("#spcCategory > li").removeClass("actived");

		$(this).addClass("actived");
	});

	$(".spcDashboard-filter > div").on("click", function(e) {
		$(this).toggleClass("actived");
	});

	$(".spcDashboard3-1 > .title-area > .title").on("click", function(e) {
		$(".spcDashboard3-1 > .title-area > .title").removeClass("actived");

		$(this).addClass("actived");
	});

	$(".interval-selector > li").on("click", function(e) {
		$(".interval-selector > li").removeClass("actived");

		$(this).addClass("actived");
	});
</script>
