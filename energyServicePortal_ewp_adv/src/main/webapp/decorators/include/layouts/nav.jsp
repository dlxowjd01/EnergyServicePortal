<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:set var="oid" value="${userInfo.oid}"/> <%-- 메뉴 관리용 OID --%>
<c:set var="task" value="${userInfo.task}"/> <%-- 메뉴 관리용 Task --%>
<c:set var="userRole" value="${userInfo.role}"/> <%-- 메뉴 관리용 Role --%>
<c:set var="loginId" value="${userInfo.login_id}"/> <%-- 메뉴 관리용 Role --%>

<script type="text/javascript">
	$(function () {
		const sideBar = $("#sidebar"),
			menuItem = sideBar.find("li"),
			menuItemLink = menuItem.find("a"),
			upperMenu = sideBar.find("li.menu-item"),
			logOutBtn = sideBar.find(".smn10 a"),
			mobileLogOutBtn = $("#mobileNav .gmn10 a"),
			subMenu = upperMenu.find("li"),
			subMenuLink = subMenu.find("a"),
			mobileMenu = $("#mobileNav").find(".menu-item"),
			path = $(location).attr("pathname");

		subMenuLink.each(function (index, el) {
			if ($(this).attr("href") === path) {
				$(this).parents(".menu-item").addClass("active").siblings().removeClass("active");
			}
		});

		subMenuLink.on("click", function(e){
			let current = window.location.pathname;
			let link = $(this).attr("href");

			if (current == link) {
				$(this).on('click', false);
				e.preventDefault();
			}
		});

		window.onload = function (e) {
			let reloading = sessionStorage.getItem("reloading");
			if (path.includes("dashboard")) {
				upperMenu.first().addClass("active");
			}
			if (reloading) {
				sessionStorage.removeItem("reloading");
			}
		}

		upperMenu.click(function (e) {
			menuItem.not(this).removeClass("on");
			$(this).toggleClass("on");
		});

		sideBar.mouseleave(function () {
			menuItem.removeClass('on');
		});

		logOutBtn.on("click", function () {
			deleteCookie("switch", "/");
			deleteCookie("sMainView", "/");
		});

		mobileLogOutBtn.on("click", function () {
			deleteCookie("switch", "/");
			deleteCookie("sMainView", "/");
		});

		mobileMenu.click(function (e) {
			mobileMenu.not(this).removeClass("on");
			$(this).toggleClass('on');
		});

		$( window ).resize(function() {
			if($( window ).width()>768){
				if( $('#mask').css('display') == 'block'){
					$('#mask').hide();
					$('body').removeClass("sidenav-no-scroll");
				}
				$("#mobileNav").hide();
			}
		});

		if($( window ).width()>768){
			if( $('#mask').css('display') == 'none'){
				$('#mask').hide();
				$('body').removeClass("sidenav-no-scroll");
			}
			$("#mobileNav").hide();
		}

		$('#mobileNavBtn').click(function(){
			$('#mask').fadeTo("slow", 0.8);
			$('body').addClass("sidenav-no-scroll");
			$('#mobileNav').show(10);
		});

		$("#mobileNav").find('.mobile-nav-close').click(function(){
			$('#mask').hide();
			$('body').removeClass("sidenav-no-scroll");
			$('#mobileNav').hide();
		});


		$('#sidebar:after').css('display', 'none') ? menuItemLink.removeClass('on') : null;

		// document.getElementsByTagName('body')[0].onscroll = function() {
		// 	console.log("scrolling");
		// 	$("#sidebar").css({ "top" : "100px;"})
		// };
	});
</script>

<c:choose>
	<c:when test="${fn:contains(pageContext.request.serverName, 'local') or fn:contains(pageContext.request.serverName, 'test')}">
		<div id="sidebar" class="side-nav">
			<ul>
				<li class="smn1 menu-item">
					<a href="javascript:void(0);">대시보드</a>
					<div class="sub-layer">
						<ul>
							<li><a href="/dashboard/gmain.do">통합관리</a></li>
						</ul>
					</div>
				</li>

<%--				<li class="smn2 menu-item">--%>
<%--					<a href="javascript:void(0);">발전소 대시보드</a>--%>
<%--					<div class="sub-layer">--%>
<%--						<ul>--%>
<%--							<li><a href="/dashboard/smain.do">태양광</a></li>--%>
<%--							<li><a href="javascript:void(0);">풍력</a></li>--%>
<%--							<li><a href="javascript:void(0);">ESS</a></li>--%>
<%--							<li><a href="/dashboard/fcmain.do">연료전지</a></li>--%>
<%--							<li><a href="javascript:void(0);">계통 대시보드</a></li>--%>
<%--							<li><a href="javascript:void(0);">인버터 대시보드</a></li>--%>
<%--							<li><a href="javascript:void(0);">태양광 대시보드</a></li>--%>
<%--							<li><a href="javascript:void(0);">구역별 대시보드</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--				</li>--%>

				<li class="smn3 menu-item">
					<a href="javascript:void(0);">설비관리</a>
					<div class="sub-layer">
						<ul>
							<c:if test="${userRole eq 1}">
								<li><a href="javascript:void(0);">설비 대시보드</a></li>
							</c:if>
							<li><a href="/device/deviceState.do">설비구성</a></li>
							<li><a href="/device/collectionState.do">통신이력</a></li>
							<li><a href="/history/alarmHistory.do">알람이력</a></li>
						</ul>
					</div>
				</li>

				<li class="smn4 menu-item">
					<a href="javascript:void(0);">발전이력</a>
					<div class="sub-layer">
						<ul>
							<li><a href="/energy/pvGen.do">태양광</a></li>
							<c:if test="${userRole eq 1}">
							<li><a href="javascript:void(0);">풍력</a></li>
							<li><a href="javascript:void(0);">ESS</a></li>
							<li><a href="javascript:void(0);">연료전지</a></li>
							</c:if>
						</ul>
					</div>
				</li>

				<li class="smn5 menu-item">
					<a href="javascript:void(0);">예측/분석</a>
					<div class="sub-layer">
						<ul>
							<c:if test="${userRole eq 1}">
							<li><a href="javascript:void(0);">예측분석 대시보드</a></li>
							</c:if>
							<li><a href="/diagnosis/generation.do">예측분석</a></li>
							<li><a href="/diagnosis/abnormallyAnalysis.do">이상분석</a></li>
							<li><a href="/history/operationHistory.do">교차분석</a></li>
						</ul>
					</div>
				</li>

				<li class="smn6 menu-item">
					<a href="javascript:void(0);">보고서</a>
					<div class="sub-layer">
						<ul>
							<li><a href="/spc/spcDashboard.do">원가관리 대시보드</a></li>
							<li><a href="/report/costManagementReport.do">원가관리</a></li>
							<li><a href="/report/yieldReport.do">발전수익</a></li>
						</ul>
					</div>
				</li>

				<li class="smn7 menu-item">
					<a href="javascript:void(0);">SPC</a>
					<div class="sub-layer">
						<ul>
							<li><a href="/spc/entityInformation.do">기본정보</a></li>
							<li><a href="/spc/balanceSheet.do">금융정보</a></li>
							<li><a href="/spc/transactionCalendar.do">입출금</a></li>
							<li><a href="/spc/supplementaryDocuments.do">이관자료</a></li>
						</ul>
					</div>
				</li>


				<li class="smn6 menu-item">
					<a href="javascript:void(0);">작업관리</a>
					<div class="sub-layer">
						<ul>
							<li><a href="/spc/maintenanceSchedule.do">점검계획</a></li>
							<c:if test="${userRole eq 1}">
							<li><a href="javascript:void(0);">작업내역</a></li>
							</c:if>
							<li><a href="/report/maintenanceReport.do">작업보고서</a></li>
						</ul>
					</div>
				</li>

				<li class="smn6 menu-item">
					<a href="javascript:void(0);">예측제도</a>
					<div class="sub-layer">
						<ul>
							<li><a href="/dashboard/VPPmain.do">예측제도 대시보드</a></li>
							<c:if test="${userRole eq 1}">
							<li><a href="javascript:void(0);">예측입찰</a></li>
							<li><a href="javascript:void(0);">수익이력</a></li>
							<li><a href="javascript:void(0);">자원정보</a></li>
							</c:if>
						</ul>
					</div>
				</li>
				<li class="smn9">
					<a href="/spc/notice.do">공지사항</a>
				</li>
				<li class="smn10">
					<a href="/logout.do">로그아웃</a>
				</li>
			</ul>
		</div>
		<div id="mobileNav" class="mobile-nav">
			<div class="logo-wrapper">
				<h1 class="mobile-logo" onclick="location='/'">
					<c:choose>
						<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
							<span class="spower mobile"></span>
						</c:when>
						<c:otherwise>
							<span class="mobile"></span>
						</c:otherwise>
					</c:choose>
				</h1>
				<a href="javascript:void(0);" class="mobile-nav-close"></a>
			</div>
			<div class="g-menu">
				<ul class="menu-list">
					<li class="gmn1 menu-item">
						<a href="javascript:void(0);">대시보드</a>
						<ul class="sub-menu-list">
							<li><a href="/dashboard/gmain.do">통합관리</a></li>
						</ul>
					</li>

					<c:if test="${userRole eq 1}">
					<li class="smn2 menu-item">
						<a href="javascript:void(0);">발전소 대시보드</a>
						<div class="sub-layer">
							<ul>
								<li><a href="/dashboard/smain.do">태양광</a></li>
								<li><a href="javascript:void(0);">풍력</a></li>
								<li><a href="javascript:void(0);">ESS</a></li>
								<li><a href="/dashboard/fcmain.do">연료전지</a></li>
								<li><a href="javascript:void(0);">계통 대시보드</a></li>
								<li><a href="javascript:void(0);">인버터 대시보드</a></li>
								<li><a href="javascript:void(0);">태양광 대시보드</a></li>
								<li><a href="javascript:void(0);">구역별 대시보드</a></li>
							</ul>
						</div>
					</li>
					</c:if>


					<li class="gmn3 menu-item">
						<a href="javascript:void(0);">설비관리</a>
						<ul class="sub-menu-list">
							<c:if test="${userRole eq 1}">
								<li><a href="javascript:void(0);">설비 대시보드</a></li>
							</c:if>
							<li><a href="/device/deviceState.do">설비구성</a></li>
							<li><a href="/device/collectionState.do">통신이력</a></li>
							<li><a href="/history/alarmHistory.do">알람이력</a></li>
						</ul>
					</li>

					<li class="gmn4 menu-item">
						<a href="javascript:void(0);">발전이력</a>
						<ul class="sub-menu-list">
							<li><a href="/energy/pvGen.do">태양광</a></li>
							<c:if test="${userRole eq 1}">
								<li><a href="javascript:void(0);">풍력</a></li>
								<li><a href="javascript:void(0);">ESS</a></li>
								<li><a href="javascript:void(0);">연료전지</a></li>
							</c:if>
						</ul>
					</li>

					<li class="gmn5 menu-item">
						<a href="javascript:void(0);">예측/분석</a>
						<ul class="sub-menu-list">
							<c:if test="${userRole eq 1}">
								<li><a href="javascript:void(0);">예측분석 대시보드</a></li>
							</c:if>
							<li><a href="/diagnosis/generation.do">예측분석</a></li>
							<li><a href="/diagnosis/abnormallyAnalysis.do">이상분석</a></li>
							<li><a href="/history/operationHistory.do">교차분석</a></li>
						</ul>
					</li>

					<li class="gmn6 menu-item">
						<a href="javascript:void(0);">보고서</a>
						<ul class="sub-menu-list">
							<li><a href="/spc/spcDashboard.do">원가관리 대시보드</a></li>
							<li><a href="/report/costManagementReport.do">원가관리</a></li>
							<li><a href="/report/yieldReport.do">발전수익</a></li>
						</ul>
					</li>

					<li class="gmn7 menu-item">
						<a href="javascript:void(0);">SPC</a>
						<ul class="sub-menu-list">
							<li><a href="/spc/entityInformation.do">기본정보</a></li>
							<li><a href="/spc/balanceSheet.do">금융정보</a></li>
							<li><a href="/spc/transactionCalendar.do">입출금</a></li>
							<li><a href="/spc/supplementaryDocuments.do">이관자료</a></li>
						</ul>
					</li>


					<li class="gmn6 menu-item">
						<a href="javascript:void(0);">작업관리</a>
						<ul class="sub-menu-list">
							<li><a href="/spc/maintenanceSchedule.do">점검계획</a></li>
							<c:if test="${userRole eq 1}">
								<li><a href="javascript:void(0);">작업내역</a></li>
							</c:if>
							<li><a href="/report/maintenanceReport.do">작업보고서</a></li>
						</ul>
					</li>

					<li class="gmn6 menu-item">
						<a href="javascript:void(0);">예측제도</a>
						<ul class="sub-menu-list">
							<li><a href="/dashboard/VPPmain.do">예측제도 대시보드</a></li>
							<c:if test="${userRole eq 1}">
								<li><a href="javascript:void(0);">예측입찰</a></li>
								<li><a href="javascript:void(0);">수익이력</a></li>
								<li><a href="javascript:void(0);">자원정보</a></li>
							</c:if>
						</ul>
					</li>
					<li class="gmn9">
						<a href="/spc/notice.do">공지사항</a>
					</li>
					<li class="gmn10">
						<a href="/logout.do">로그아웃</a>
					</li>`
				</ul>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<div id="sidebar" class="side-nav">
			<ul>
				<c:set var="denyCondition" value="${oid}.${loginId}"/>
				<c:forEach var="menu" items="${menuList}" varStatus="status">
					<c:set var="menuMap" value="${menu.value}"/>
					<c:set var="allow" value="${menuMap.access.allow}"/>
					<c:set var="deny" value="${menuMap.access.deny}"/>
					<c:if test="${deny ne null or !fn:contains(deny, oid)}">
						<c:if test="${menuMap.parent eq null
						and (((allow.task eq null or fn:contains(allow.task, task)) and (allow.role eq null or fn:contains(allow.role, userRole)))
							and ((deny.task eq null or !fn:contains(deny.task, task)) and (deny.role eq null or !fn:contains(deny.role, userRole))) or userRole eq '1')
						and ((allow.oid eq null or fn:contains(allow.oid, oid)) and (deny.oid eq null or !fn:contains(deny.oid, oid)))
						and (deny.uid eq null or !fn:contains(deny.uid, denyCondition))
			}">
							<c:set var="thisCode" value="${menuMap.code}"/>
							<c:choose>
								<c:when test="${cookieLang eq 'KO'}">
									<c:set var="menuName" value="${menuMap.name.kr}"/>
								</c:when>
								<c:otherwise>
									<c:set var="menuName" value="${menuMap.name.en}"/>
								</c:otherwise>
							</c:choose>

							<c:choose>
								<c:when test="${menuMap.valign ne null and menuMap.valign eq 'bottom'}">
									<li class="${menuMap.icon_class}">
										<a href="/${menuMap.href}">${menuName}</a>
									</li>
								</c:when>
								<c:otherwise>
									<li class="${menuMap.icon_class} menu-item">
										<a href="javascript:void(0);">${menuName}</a>
										<div class="sub-layer">
											<ul>
												<c:forEach var="subMenu" items="${menuList}">
													<c:set var="subMenuMap" value="${subMenu.value}"/>
													<c:set var="subAllow" value="${subMenuMap.access.allow}"/>
													<c:set var="subDeny" value="${subMenuMap.access.deny}"/>
													<c:if test="${subDeny ne null or !fn:contains(subDeny, oid)}">
														<c:if test="${subMenuMap.parent ne null
														and thisCode eq subMenuMap.parent
														and (((subAllow.task eq null or fn:contains(subAllow.task, task)) and (subAllow.role eq null or fn:contains(subAllow.role, userRole)))
															and ((subDeny.task eq null or !fn:contains(subDeny.task, task)) and (subDeny.role eq null or !fn:contains(subDeny.role, userRole))) or userRole eq '1')
														and ((subAllow.oid eq null or fn:contains(subAllow.oid, oid)) and (subDeny.oid eq null or !fn:contains(subDeny.oid, oid)))
														and (subDeny.uid eq null or !fn:contains(subDeny.uid, denyCondition))
											}">
															<c:choose>
																<c:when test="${cookieLang eq 'KO'}">
																	<c:set var="subMenuName" value="${subMenuMap.name.kr}"/>
																</c:when>
																<c:otherwise>
																	<c:set var="subMenuName" value="${subMenuMap.name.en}"/>
																</c:otherwise>
															</c:choose>

															<li><a href="/${subMenuMap.href}">${subMenuName}</a></li>
														</c:if>
													</c:if>
												</c:forEach>
											</ul>
										</div>
									</li>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:if>
				</c:forEach>
			</ul>
		</div>
		<div id="mobileNav" class="mobile-nav">
			<div class="logo-wrapper">
				<h1 class="mobile-logo" onclick="location='/'">
					<c:choose>
						<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
							<span class="spower mobile"></span>
						</c:when>
						<c:otherwise>
							<span class="mobile"></span>
						</c:otherwise>
					</c:choose>
				</h1>
				<a href="javascript:void(0);" class="mobile-nav-close"></a>
			</div>
			<div class="g-menu">
				<ul class="menu-list">
					<c:forEach var="menu" items="${menuList}" varStatus="status">
						<c:set var="menuMap" value="${menu.value}"/>
						<c:set var="allow" value="${menuMap.access.allow}"/>
						<c:set var="deny" value="${menuMap.access.deny}"/>
						<c:if test="${deny ne null or !fn:contains(deny, oid)}">
							<c:if test="${menuMap.parent eq null
								and (((allow.task eq null or fn:contains(allow.task, task)) and (allow.role eq null or fn:contains(allow.role, userRole)))
									and ((deny.task eq null or !fn:contains(deny.task, task)) and (deny.role eq null or !fn:contains(deny.role, userRole))) or userRole eq '1')
								and ((allow.oid eq null or fn:contains(allow.oid, oid)) and (deny.oid eq null or !fn:contains(deny.oid, oid)))
								and (deny.uid eq null or !fn:contains(deny.uid, denyCondition))
					}">
								<c:set var="thisCode" value="${menuMap.code}"/>
								<c:choose>
									<c:when test="${cookieLang eq 'KO'}">
										<c:set var="menuName" value="${menuMap.name.kr}"/>
									</c:when>
									<c:otherwise>
										<c:set var="menuName" value="${menuMap.name.en}"/>
									</c:otherwise>
								</c:choose>

								<c:choose>
									<c:when test="${menuMap.valign ne null and menuMap.valign eq 'bottom'}">
										<li class="${fn:replace(menuMap.icon_class, 'smn', 'gmn')}">
											<a href="/${menuMap.href}">${menuName}</a>
										</li>
									</c:when>
									<c:otherwise>
										<li class="${fn:replace(menuMap.icon_class, 'smn', 'gmn')} menu-item">
											<c:choose>
												<c:when test="${menuMap.href ne null and !empty menuMap.href}">
													<a href="${menuMap.href}">${menuName}</a>
												</c:when>
												<c:otherwise>
													<a href="javascript:void(0);">${menuName}</a>
												</c:otherwise>
											</c:choose>
											<ul class="sub-menu-list">
												<c:forEach var="subMenu" items="${menuList}">
													<c:set var="subMenuMap" value="${subMenu.value}"/>
													<c:set var="subAllow" value="${subMenuMap.access.allow}"/>
													<c:set var="subDeny" value="${subMenuMap.access.deny}"/>
													<c:if test="${subDeny ne null or !fn:contains(subDeny, oid)}">
														<c:if test="${subMenuMap.parent ne null
														and thisCode eq subMenuMap.parent
														and (((subAllow.task eq null or fn:contains(subAllow.task, task)) and (subAllow.role eq null or fn:contains(subAllow.role, userRole)))
															and ((subDeny.task eq null or !fn:contains(subDeny.task, task)) and (subDeny.role eq null or !fn:contains(subDeny.role, userRole))) or userRole eq '1')
														and ((subAllow.oid eq null or fn:contains(subAllow.oid, oid)) and (subDeny.oid eq null or !fn:contains(subDeny.oid, oid)))
														and (subDeny.uid eq null or !fn:contains(subDeny.uid, denyCondition))
												}">
															<c:choose>
																<c:when test="${cookieLang eq 'KO'}">
																	<c:set var="subMenuName" value="${subMenuMap.name.kr}"/>
																</c:when>
																<c:otherwise>
																	<c:set var="subMenuName" value="${subMenuMap.name.en}"/>
																</c:otherwise>
															</c:choose>

															<li><a href="/${subMenuMap.href}">${subMenuName}</a> </li>
														</c:if>
													</c:if>
												</c:forEach>
											</ul>
										</li>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
	</c:otherwise>
</c:choose>
