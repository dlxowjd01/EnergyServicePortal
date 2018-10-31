<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
							<form id="schForm" name="schForm">
							<c:choose>
								<c:when test="${param.schGbn eq 'energy_drResult' }"> <!-- DR 실적 조회 -->
								<div class="chart_top clear">
									<h2 class="ntit fl">${selViewSite.site_name }</h2>
									<div class="term fl clear">
										<div class="dropdown fl">
										  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selTermBox">1일(날짜선택)
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu">
										    <li class="on"><a href="#" onclick="changeSelTerm('drday');">1일(오늘)</a></li>
										    <li><a href="#" onclick="changeSelTerm('selectDay');">1일(날짜선택)</a></li>
										  </ul>
										</div>
										<div class="dropdown fl">
										  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selPeriod">15분
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu">
										    <li class="on" id="sp_15min" onclick="changePeriod('15min');"><a href="#">15분</a></li>
										    <li id="sp_1hour" onclick="changePeriod('hour');"><a href="#">1시간</a></li>
										  </ul>
										</div>
									</div>
									<div class="today_date fl">
										<span>날짜선택</span>
										<input type="text" id="datepicker5" name="datepicker5" class="sel" value="">
										<!-- <input type="text" id="datepicker1" name="datepicker1" class="sel" value=""> -->
									</div>
									<div class="search_opt fl">
										<span>기준부하 시간설정</span>
										<input type="text" class="input" id="cblAmtHourFrom" name="cblAmtHourFrom" maxlength="2" value="10" style="width:60px;"> 
										<span> ~ </span>
										<input type="text" class="input" id="cblAmtHourTo" name="cblAmtHourTo" maxlength="2" value="14" style="width:60px;">
										<button type="button" id="searchBtn" onclick="getCollect_sch_condition();">조회</button>
									</div>
									<div class="checkbox fl">
					                    <input id="check1" type="checkbox" class="styled" >
					                    <label for="check1">실시간 자동 갱신</label>
					                </div>
									<div class="time fr" id="updtTime">2018-08-12 11:41:26</div>
								</div>
								</c:when>
								<c:when test="${param.schGbn eq 'control' }"><!-- 상황관제 -->
								<div class="chart_top clear">
									<h2 class="ntit fl">알림현황</h2>
									<div class="dropdown fl">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selTermBox">1일
										<span class="caret"></span></button>
										<ul class="dropdown-menu">
											<li class="on"><a href="#" onclick="changeSelTerm('30min'); ">30분</a></li>
											<li><a href="#" onclick="changeSelTerm('hour');">1시간</a></li>
											<li><a href="#" onclick="changeSelTerm('day');">1일</a></li>
											<li><a href="#" onclick="changeSelTerm('week');">1주</a></li>
											<li><a href="#" onclick="changeSelTerm('month');">1월</a></li>
											<li><a href="#" onclick="changeSelTerm('year');">1년</a></li>
											<li><a href="#" onclick="changeSelTerm('other');">기간설정</a></li>
										</ul>
									</div>	
									<div class="sel_calendar fr">
										<input type="text" id="datepicker1" class="sel" value="">
										<span>-</span>
										<input type="text" id="datepicker2" class="sel" value="">
										<button type="button" id="searchBtn">조회</button>
									</div>						
								</div>
								</c:when>
								<c:otherwise><!-- 그 외 -->
								<div class="chart_top clear">
									<h2 class="ntit fl">${selViewSite.site_name }</h2>
									<c:if test="${param.schGbn eq 'energy' }">
									<div class="term fl clear">
										<div class="dropdown fl">
										  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selTermBox">1일
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu">
										    <li class="on"><a href="#" onclick="changeSelTerm('30min'); ">30분</a></li>
										    <li><a href="#" onclick="changeSelTerm('hour');">1시간</a></li>
										    <li><a href="#" onclick="changeSelTerm('day');">1일</a></li>
										    <li><a href="#" onclick="changeSelTerm('week');">1주</a></li>
										    <li><a href="#" onclick="changeSelTerm('month');">1월</a></li>
										    <li><a href="#" onclick="changeSelTerm('year');">1년</a></li>
										    <li><a href="#" onclick="changeSelTerm('other');">기간설정</a></li>
										  </ul>
										</div>
										<div class="dropdown fl">
										  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selPeriod">1시간
										  <span class="caret"></span></button>
										  <ul class="dropdown-menu">
										    <li class="on" id="sp_15min" onclick="changePeriod('15min');"><a href="#">15분</a></li>
										    <li id="sp_30min" onclick="changePeriod('30min');"><a href="#">30분</a></li>
										    <li id="sp_1hour" onclick="changePeriod('hour');"><a href="#">1시간</a></li>
										    <li id="sp_1day" onclick="changePeriod('day');"><a href="#">1일</a></li>
										    <li id="sp_1month" onclick="changePeriod('month');"><a href="#">1월</a></li>
										  </ul>
										</div>
									</div>
									<div class="sel_calendar fl">
										<span>기간설정</span>
										<input type="text" id="datepicker1" name="datepicker1" class="sel" value="">
										<span>-</span>
										<input type="text" id="datepicker2" name="datepicker2" class="sel" value="">
										<button type="button" id="searchBtn" onclick="getCollect_sch_condition();">조회</button>
									</div>
									</c:if>
									<c:if test="${param.schGbn eq 'billRevenue' }">
									<div class="sel_calendar fl">
										<span>기간설정</span>
										<input type="text" id="datepicker3" name="datepicker3" class="sel" value="">
										<span>-</span>
										<input type="text" id="datepicker4" name="datepicker4" class="sel" value="">
										<button type="button" id="searchBtn" onclick="getCollect_sch_condition();">조회</button>
									</div>
									</c:if>
									<div class="time fr" id="updtTime">2018-08-12 11:41:26</div>
								</div>
								</c:otherwise>
							</c:choose>
							<input type="hidden" id="siteId" name="siteId" value="${selViewSiteId }">
							<input type="hidden" id="dtCnt" name="dtCnt">
							
							<input type="hidden" id="selTermFrom" name="selTermFrom">
							<input type="hidden" id="selTermTo" name="selTermTo">
							<input type="hidden" id="selTerm" name="selTerm">
							<input type="hidden" id="selPeriodVal" name="selPeriodVal">
							<input type="hidden" id="selPageNum" name="selPageNum">
							</form>
