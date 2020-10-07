<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
							<form id="schForm" name="schForm">
								<div class="chart-top clear">
									<c:choose>
										<c:when test="${schGbn eq 'alarm' }"><!-- 상황관제 -->
											<h2 class="ntit fl">알림현황</h2>
												<div class="dropdown fl">
												  <button type="button" class="dropdown-toggle" data-toggle="dropdown" id="selTermBox">1일
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
											<div class="sel-calendar fr">
												<input type="text" id="datepicker1" class="sel" value="">
												<span>-</span>
												<input type="text" id="datepicker2" class="sel" value="">
												<button type="button" id="searchBtn">조회</button>
											</div>
										</c:when>
										<c:otherwise><!-- 그 외 -->
											<h2 class="ntit fl">${selViewSite.site_name }</h2>
											<div class="term fl clear">
												<c:choose>
													<c:when test="${schGbn eq 'energy_drResult' }"> <!-- DR 실적 조회 -->
														<div class="dropdown fl">
														  <button type="button" class="dropdown-toggle" data-toggle="dropdown" id="selTermBox">1일(오늘)
														  <span class="caret"></span></button>
														  <ul class="dropdown-menu">
														    <li class="on"><a href="#" onclick="changeSelTerm('drday');">1일(오늘)</a></li>
														    <li><a href="#" onclick="changeSelTerm('selectDay');">1일(날짜선택)</a>
														  </ul>
														</div>
														<div class="dropdown fl">
														  <button type="button" class="dropdown-toggle" data-toggle="dropdown" id="selPeriod">15분
														  <span class="caret"></span></button>
														  <ul class="dropdown-menu">
														    <li class="on" id="sp_15min"><a href="#" onclick="changePeriod('15min');">15분</a></li>
														    <li id="sp_1hour"><a href="#" onclick="changePeriod('hour');">1시간</a></li>
														  </ul>
														</div>
														<div class="date-today fl">
															<span>날짜선택</span>
															<input type="text" id="datepicker5" name="datepicker5" class="sel" value="">
															<!-- <input type="text" id="datepicker1" name="datepicker1" class="sel" value=""> -->
														</div>
														<div class="search-option fl">
															<span>기준부하 시간설정</span>
															<input type="text" class="input" id="cblAmtHourFrom" name="cblAmtHourFrom" maxlength="2" value="10"
																   style="width:60px;" onkeydown="onlyNum(event);">
															<span> ~ </span>
															<input type="text" class="input" id="cblAmtHourTo" name="cblAmtHourTo" maxlength="2" value="14"
																   style="width:60px;" onkeydown="onlyNum(event);">
															<input type="hidden" id="cblAmtFrom" name="cblAmtFrom">
															<input type="hidden" id="cblAmtTo" name="cblAmtTo">
															<button type="button" id="searchBtn" onclick="searchData();">조회</button>
														</div>
														<div class="checkbox fl">
															<input id="check1" type="checkbox" class="styled">
															<label for="check1">실시간 자동 갱신</label>
														</div>
														<div class="real-time fl"><span>00:00</span></div>
														<div class="meter fl">
															<span class="fl">계량값</span>
															<div class="dropdown fl">
																<button type="button" class="dropdown-toggle" data-toggle="dropdown">전체
																<span class="caret"></span></button>
																<ul class="dropdown-menu">
																  <li class="on"><a href="#">전체</a></li>
																  <li><a href="#">계량#1</a></li>
																  <li><a href="#">계량#2</a></li>
																  <li><a href="#">계량#3</a></li>
																</ul>
															</div>
														</div>								
													</c:when>
													<c:otherwise>
													<c:if test="${schGbn eq 'energy' }">
														<script>
														$(window).scroll(function() { if ($(window).scrollTop() == $(document).height() - $(window).height()) { drawData_table(); } });
														</script>
														<div class="dropdown fl">
														  <button type="button" class="dropdown-toggle" data-toggle="dropdown" id="selTermBox">1일
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
														  <button type="button" class="dropdown-toggle" data-toggle="dropdown" id="selPeriod">1시간
														  <span class="caret"></span></button>
														  <ul class="dropdown-menu">
														    <li class="on" id="sp_15min"><a href="#" onclick="changePeriod('15min');">15분</a></li>
														    <li id="sp_30min"><a href="#" onclick="changePeriod('30min');">30분</a></li>
														    <li id="sp_1hour"><a href="#" onclick="changePeriod('hour');">1시간</a></li>
														    <li id="sp_1day"><a href="#" onclick="changePeriod('day');">1일</a></li>
														    <li id="sp_1month"><a href="#" onclick="changePeriod('month');">1월</a>
														  </ul>
														</div>
														<div class="sel-calendar fl">
															<span>기간설정</span>
															<input type="text" id="datepicker1" name="datepicker1" class="sel" value="">
															<span>-</span>
															<input type="text" id="datepicker2" name="datepicker2" class="sel" value="">
															<button type="button" id="searchBtn" onclick="searchData();">조회</button>
														</div>
														<div class="meter fl">
															<span class="fl">계량값</span>
															<div class="dropdown fl">
																<button type="button" class="dropdown-toggle" data-toggle="dropdown">전체
																<span class="caret"></span></button>
																<ul class="dropdown-menu">
																  <li class="on"><a href="#">전체</a></li>
																  <li><a href="#">계량#1</a></li>
																  <li><a href="#">계량#2</a></li>
																  <li><a href="#">계량#3</a></li>
																</ul>
															</div>
														</div>								
													</c:if>
													<c:if test="${schGbn eq 'billRevenue' }">
														<div class="sel-calendar fl">
															<span>기간설정</span>
															<input type="text" id="datepicker3" name="datepicker3" class="sel" value="">
															<span>-</span>
															<input type="text" id="datepicker4" name="datepicker4" class="sel" value="">
															<button type="button" id="searchBtn" onclick="searchData();">조회</button>
														</div>
													</c:if>
													</c:otherwise>
												</c:choose>
											</div>
											<div class="time fr" id="updtTime">2018-08-12 11:41:26</div>
										</c:otherwise>
									</c:choose>
								</div>
								
								<input type="hidden" id="siteId" name="siteId" value="${selViewSiteId }">
								<input type="hidden" id="dtCnt" name="dtCnt">
								
								<input type="hidden" id="selTermTex" name="selTermTex">
								<input type="hidden" id="selTermAgo" name="selTermAgo">
								<input type="hidden" id="selTermFrom" name="selTermFrom">
								<input type="hidden" id="selTermTo" name="selTermTo">
								<input type="hidden" id="selTerm" name="selTerm">
								<input type="hidden" id="selPeriodVal" name="selPeriodVal">
								<input type="hidden" id="selPageNum" name="selPageNum">
								<input type="hidden" id="timeOffset" name="timeOffset">
							</form>