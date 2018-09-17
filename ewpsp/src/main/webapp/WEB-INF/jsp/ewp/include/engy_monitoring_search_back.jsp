<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <title>Insert title here</title> -->
</head>
<body>
		<h2 class="stit">${param.subTitle }<!-- 오늘의 사용량 --></h2>
		<div class="t_date ff_opens" id="updtTime">2018-07-13 22:30</div>
		<div class="term clear">
			<div class="dropdown">
			  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selTermBox">1일(오늘)
			  <span class="caret"></span></button>
			  <ul class="dropdown-menu">
			    <!-- <li class="on"><a href="#" onclick="changeSelTerm('15min'); getUsageRealtime();">15분</a></li> -->
			    <li><a href="#" onclick="changeSelTerm('hour'); getUsageRealtime();">1시간</a></li>
			    <li><a href="#" onclick="changeSelTerm('day'); getUsageRealtime();">1일(오늘)</a></li>
			    <li><a href="#" onclick="changeSelTerm('week'); getUsageRealtime();">1주</a></li>
			    <li><a href="#" onclick="changeSelTerm('month'); getUsageRealtime();">1월</a></li>
			    <li><a href="#" onclick="changeSelTerm('year'); getUsageRealtime();">1년</a></li>
			  </ul>
			  <input type="hidden" id="selTermFrom" name="selTermFrom">
			  <input type="hidden" id="selTermTo" name="selTermTo">
			  <input type="hidden" id="selTerm" name="selTerm">
			</div>
			<div class="dropdown">
			  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selPeriod">1시간
			  <span class="caret"></span></button>
			  <ul class="dropdown-menu">
			    <!-- <li class="on" id="sp_1min"><a href="#" onclick="changePeriod('1min'); getUsageRealtime();">1분</a></li> -->
			    <li id="sp_15min" onclick="changePeriod('15min'); getUsageRealtime();"><a href="#">15분</a></li>
			    <li id="sp_30min" onclick="changePeriod('30min'); getUsageRealtime();"><a href="#">30분</a></li>
			    <li id="sp_1hour" onclick="changePeriod('hour'); getUsageRealtime();"><a href="#">1시간</a></li>
			    <li id="sp_1day" onclick="changePeriod('day'); getUsageRealtime();"><a href="#">1일</a></li>
			    <li id="sp_1month" onclick="changePeriod('month'); getUsageRealtime();"><a href="#">1월</a></li>
			  </ul>
			  <input type="hidden" id="selPeriodVal" name="selPeriodVal">
			</div>
		</div>
		<div class="sel_calendar">
			<span>기간설정</span>
			<input type="text" id="datepicker1" value="">
			<span>~</span>
			<input type="text" id="datepicker2" value="">
		</div>
		<div class="goback"><a href="../sub/sub_02.html">돌아가기</a></div>	
</body>
</html>