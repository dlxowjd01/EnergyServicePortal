<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
$(document).ready(function() {
	var linkGbn = "${param.linkGbn }";
	$("#sidebar").find("ul").find("li").removeClass("on");
	if(linkGbn == "siteMain") $(".smn1").addClass("on"); 
	else if(linkGbn == "energy") $(".smn2").addClass("on"); 
	else if(linkGbn == "device") $(".smn3").addClass("on"); 
	else if(linkGbn == "control") $(".smn4").addClass("on"); 
	else if(linkGbn == "billRevenue") $(".smn5").addClass("on"); 
	else if(linkGbn == "setup") $(".smn7").addClass("on"); 
	else if(linkGbn == "main") $(".smn6").addClass("on"); 
});
</script>
		<div id="sidebar">
			<ul>
				<li class="smn1"><a href="/siteMain">메인</a></li>
				<li class="smn2">
					<a href="/usage">에너지<br/>정보조회</a>
					<div class="sub_layer">
						<ul>
							<li><a href="/usage">사용량 현황</a></li>
							<li><a href="/peak">피크전력 현황</a></li>
							<li><a href="/essCharge">ESS 충•방전량 조회</a></li>
							<li><a href="/pvGen">PV 발전량 조회</a></li>
							<li><a href="/drResult">DR 실적 조회</a></li>
							<li><a href="/derUsage">사용량 구성</a></li>
						</ul>
					</div>
				</li>
				<li class="smn3">
					<a href="/deviceMonitoring?deviceGbn=IOE">장치<br/>모니터링</a>
					<div class="sub_layer">
						<ul>
							<li><a href="/deviceMonitoring?deviceGbn=IOE">IOE 통신상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=PCS">PCS 통신상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=BMS">BMS 통신상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=PV">PV 통신상태</a></li>
							<li><a href="/deviceGroup">장치 그룹 현황</a></li>
						</ul>
					</div>
				</li>
				<li class="smn4"><a href="/control">상황관제</a></li>
				<li class="smn5">
					<a href="/kepcoBill">요금/수익</a>
					<div class="sub_layer">
						<ul>
							<li><a href="/kepcoBill">한전 요금 조회</a></li>
							<li><a href="/essRevenue">ESS 수익 조회</a></li>
							<li><a href="/drRevenue">DR 수익 조회</a></li>
							<li><a href="/pvRevenue">PV 수익 조회</a></li>
							<li><a href="javascript:popupOpen('totaldprint');">통합 명세서</a></li>
						</ul>
					</div>
				</li>
			</ul>
			<ol>
				<!-- <li class="smn6"><a href="/main">군관리<br/>메인</a></li> -->
				<li class="smn6"><a href="/main">군관리<br/>메인</a></li>
				<li class="smn7">
					<a href="#;">설정</a>
					<div class="sub_layer">
						<ul>
							<li><a href="/kepcoMngSet">한전관리설정</a></li>
							<li><a href="/cmpyGrpSiteMng">회사/그룹/사이트</a></li>
							<li><a href="/userMng">사용자관리</a></li>
						</ul>
					</div>
				</li>
				<li class="smn8"><a href="/logout" class="LoginBtn">로그아웃</a></li>
			</ol>
		</div>
		<!-- 모바일용 카테고리 { -->
		<div id="gnb">
			<div class="g_top">
				<div class="w100">
					<h1 class="g_logo"><a href="#;"><img src="../img/main_logo.png" class="로고"></a></h1>
					<a href="#;" class="category_close"><img src="../img/gnb_close.png" width="17" alt="닫기"></a>
				</div>				
			</div>
			<div class="g_menu w100">
				<ul>
					<li class="gmn1"><a href="/siteMain">메인</a></li>
					<li class="gmn2"><a href="#;">에너지 정보조회</a>
						<ul>
							<li><a href="/usage">사용량 현황</a></li>
							<li><a href="/peak">피크전력 현황</a></li>
							<li><a href="/essCharge">ESS 충•방전량 조회</a></li>
							<li><a href="/pvGen">PV 발전량 조회</a></li>
							<li><a href="/drResult">DR 실적 조회</a></li>
							<li><a href="/derUsage">사용량 구성</a></li>
						</ul>
					</li>
					<li class="gmn3"><a href="#">장치 모니터링</a>
						<ul>
							<li><a href="/deviceMonitoring?deviceGbn=IOE">IOE 통신상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=IOE">PCS 통신상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=IOE">BMS 통신상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=IOE">PV 통신상태</a></li>
							<!-- <li><a href="/deviceMonitoring?deviceGbn=PCS">PCS 운전상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=BMS">BMS 운전상태</a></li>
							<li><a href="/deviceMonitoring?deviceGbn=PV">PV 운전상태</a></li> -->
							<li><a href="/deviceGroup">장치 그룹 현황</a></li>
						</ul>
					</li>
					<li class="gmn4"><a href="/control">상황관제</a></li>
					<li class="gmn5"><a href="#">요금/수익</a>
						<ul>
							<li><a href="/kepcoBill">한전 요금 조회</a></li>
							<li><a href="/essRevenue">ESS 수익 조회</a></li>
							<li><a href="/drRevenue">DR 수익 조회</a></li>
							<li><a href="/pvRevenue">PV 수익 조회</a></li>
						</ul>
					</li>
				</ul>
				<ol>
					<li class="gmn6"><a href="/main">군관리 메인</a></li>
					<li class="gmn7"><a href="#;">설정</a>
						<ul>
							<li><a href="/kepcoMngSet">한전관리설정</a></li>
							<li><a href="/cmpyGrpSiteMng">회사/그룹/사이트</a></li>
							<li><a href="/userMng">사용자관리</a></li>
						</ul>
					</li>
					<li class="gmn8"><a href="/logout">로그아웃</a></li>
				</ol>
			</div>
		</div>
		<!-- } 모바일용 카테고리 -->		
