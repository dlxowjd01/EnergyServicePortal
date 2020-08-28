<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:set var="oid" value="${userInfo.oid}"/> <%-- 메뉴 관리용 OID --%>
<c:set var="task" value="${userInfo.task}"/> <%-- 메뉴 관리용 Task --%>

<script type="text/javascript">
	$(function () {
		const sideBar = $("#sidebar"),
			menuItem = sideBar.find("li"),
			menuItemLink = menuItem.find("a"),
			upperMenu = sideBar.find("li.menu-item"),
			subMenu = upperMenu.find("li"),
			subMenuLink = subMenu.find("a"),
			mobileMenu = $("#mobileNav").find(".menu-item"),
			path = $(location).attr("pathname");

		subMenuLink.each(function (e) {
			if ($(this).attr("href") === path) {
				$(this).parents(".menu-item").addClass("active").siblings().removeClass("active");
			}
		});

		subMenuLink.on("click", function(event){
			let current = window.location.pathname;
			let link = $(this).attr("href");

			if (current == link) {
				$(this).on('click', false);
				event.preventDefault();
			} else {
				$(this).on('click', true);
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

		mobileMenu.click(function (e) {
			mobileMenu.not(this).removeClass("on");
			$(this).toggleClass('on');
		});

		if ($(window).width() > 768) {
			$('#mobileNav').hide();
		}

		$('#mobileNavBtn').click(function(){
			$('#mask').fadeTo("slow", 0.8);
			$('body').addClass("sidenav-no-scroll");
			$('#mobileNav').show(10);
		});

		$("#mobileNav").find('.category_close').click(function(){
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

<div id="sidebar" class="side-nav">
	<c:if test="${not empty userInfo}">
	<ul>
		<li class="smn1 menu-item">
			<a href="javascript:void(0);">대시보드</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/dashboard/gmain.do">통합관리 대시보드</a></li>
					<c:if test="${oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx'}">
						<li><a href="/dashboard/jmain.do">중개거래 대시보드</a></li>
					</c:if>
				</ul>
			</div>
		</li>
		<li class="smn2 menu-item">
			<a href="javascript:void(0);">설비 현황</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/device/deviceState.do">설비구성</a></li>
					<li><a href="/device/collectionState.do">수집현황</a></li>
					<c:if test="${oid eq 'encored' or oid eq 'kpx'}">
					<li><a href="/device/certManageList.do">기기인증서 관리</a></li>
					<li><a href="/device/certApplication.do">기기인증서 신청</a></li>
					</c:if>
				</ul>
			</div>
		</li>
		<li class="smn3 menu-item">
			<a href="javascript:void(0);">설비 이력</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/history/operationHistory.do">상태이력</a></li>
					<li><a href="/history/alarmHistory.do">알람이력</a></li>
				</ul>
			</div>
		</li>
		<li class="smn4 menu-item">
			<a href="javascript:void(0);">자원 분석</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/energy/pvGen.do">발전이력</a></li>
				</ul>
			</div>
		</li>
		<c:if test="${oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx'}">
		<li class="smn5 menu-item">
			<a href="javascript:void(0);">예측/진단</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/diagnosis/generation.do">발전예측</a></li>
					<li><a href="/diagnosis/abnormallyAnalysis.do">이상분석</a></li>
				</ul>
			</div>
		</li>
		</c:if>

		<c:if test="${oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx'}">
		<li class="smn6 menu-item">
			<a href="javascript:void(0);">보고서</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/report/yieldReport.do">수익보고서</a></li>
					<li><a href="/report/maintenanceReport.do">작업보고서</a></li>
				</ul>
			</div>
		</li>
		</c:if>

		<c:if test="${(oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx') or (oid eq 'trust' and task ne 3) or (oid eq 'sundream' and task ne 3)}">
		<li class="smn7 menu-item">
			<a href="javascript:void(0);">SPC관리</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/spc/entityInformation.do">기본정보</a></li>
					<li><a href="/spc/balanceSheet.do">금융관리</a></li>
					<li><a href="/spc/transactionCalendar.do">입출금 관리</a></li>
					<li><a href="/spc/maintenanceSchedule.do">점검계획</a></li>
					<li><a href="/spc/supplementaryDocuments.do">이관자료</a></li>

				</ul>
			</div>
		</li>
		</c:if>

		<c:if test="${oid eq 'encored' or oid eq 'kpx'}">
		<li class="smn8 menu-item">
			<a href="javascript:void(0);">설정</a>
			<div class="sub_layer">
				<ul>
					<li><a href="/setting/siteSetting.do">사업소 관리</a></li>
					<li><a href="/setting/groupSetting.do">그룹 관리</a></li>
					<li><a href="/setting/alarmSetting.do">알람 설정</a></li>
					<c:if test="${role ne '2'}">
					<li><a href="/setting/userSetting.do">사용자 관리</a></li>
					</c:if>
					<li><a href="/setting/comCodeSetting.do">공통 코드 관리</a></li>
					<li><a href="/setting/batchSetting.do">배치 관리</a></li>
				</ul>
			</div>
		</li>
		</c:if>
		
		<li class="smn9"><a href="/spc/notice.do">공지사항</a></li>
		<li class="smn10"><a href="/logout.do">로그아웃</a></li>
	</ul>
	</c:if>
</div>

<div id="mobileNav" class="mobile-nav">
	<div class="logo-wrapper">
		<h1 class="mobile-logo">
			<c:choose>
				<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
					<span class="spower mobile"></span>
				</c:when>
				<c:otherwise>
					<span class="mobile"></span>
				</c:otherwise>
			</c:choose>
		</h1>
		<a href="javascript:void(0);" class="category_close"><img src="/img/gnb_close.png" width="17" alt="닫기"></a>
	</div>
	
	<div class="g_menu">
		<ul class="menu-list">
			<li class="gmn1 menu-item">
				<a href="javascript:void(0);">대시보드</a>
				<ul class="sub-menu-list">
					<li><a href="/dashboard/gmain.do">통합관리 대시보드</a></li>
					<%--<li>--%>
					<%--  <a href="javascript:void(0);">사업소 대시보드</a>--%>
					<%--  <div>--%>
					<%--    <p><a href="/dashboard/smain.do">신재생발전 대시보드</a></p>--%>
					<%--    <p><a href="/dashboard/emain.do">피크저감ESS 대시보드</a></p>--%>
					<%--    <p><a href="/dashboard/dmain.do">신재생발전+신재생 연계 ESS</a></p>--%>
					<%--  </div>--%>
					<%--</li>--%>
					<c:if test="${oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx'}">
					<li><a href="/dashboard/jmain.do">중개거래 대시보드</a></li>
					</c:if>
					<!-- <li><a href="">수요자원 대시보드</a></li> -->
				</ul>
			</li>
			<li class="gmn2 menu-item">
				<a href="javascript:void(0);">설비현황</a>
				<ul class="sub-menu-list">
					<li><a href="/device/deviceState.do">설비구성</a></li>
					<li><a href="/device/collectionState.do">수집현황</a></li>
					<c:if test="${oid eq 'encored' or oid eq 'kpx'}">
					<li><a href="/device/certManageList.do">기기인증서 관리</a></li>
					<li><a href="/device/certApplication.do">기기인증서 신청</a></li>
					</c:if>
				</ul>
			</li>
			<li class="gmn3 menu-item">
				<a href="javascript:void(0);">설비 이력</a>
				<ul class="sub-menu-list">
					<li><a href="/history/operationHistory.do">상태이력</a></li>
					<li><a href="/history/alarmHistory.do">알람이력</a></li>
				</ul>
			</li>
			<li class="gmn4 menu-item">
				<a href="javascript:void(0);">자원분석</a>
				<ul class="sub-menu-list">
					<li><a href="/energy/pvGen.do">발전이력</a></li>
				</ul>
			</li>
			<c:if test="${oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx'}">
			<li class="gmn5 menu-item">
				<a href="javascript:void(0);">예측/진단</a>
				<ul class="sub-menu-list">
					<li><a href="/diagnosis/generation.do">발전예측</a></li>
					<li><a href="/diagnosis/abnormallyAnalysis.do">이상분석</a></li>
				</ul>
			</li>
			</c:if>
			<c:if test="${oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx'}">
			<li class="gmn6 menu-item">
				<a href="javascript:void(0);">보고서</a>
				<ul class="sub-menu-list">
					<li><a href="/report/yieldReport.do">수익보고서</a></li>
					<li><a href="/report/maintenanceReport.do">작업보고서</a></li>
				</ul>
			</li>
			</c:if>

			<c:if test="${(oid ne 'trust' and oid ne 'sundream' and oid ne 'kpx') or (oid eq 'trust' and task ne 3) or (oid eq 'sundream' and task ne 3)}">
			<li class="gmn7 menu-item">
				<a href="javascript:void(0);">SPC관리</a>
				<ul class="sub-menu-list">
					<li><a href="/spc/entityInformation.do">기본정보</a></li>
					<li><a href="/spc/balanceSheet.do">원가관리</a></li>
					<li><a href="/spc/transactionCalendar.do">입출금 관리</a></li>
					<li><a href="/spc/maintenanceSchedule.do">점검계획</a></li>
					<li><a href="/spc/supplementaryDocuments.do">이관자료</a></li>
				</ul>
			</li>
			</c:if>
			<c:if test="${oid eq 'encored' or oid eq 'kpx'}">
			<li class="gmn8 menu-item">
				<a href="javascript:void(0);">설정</a>
				<ul class="sub-menu-list">
					<li><a href="/setting/siteSetting.do">사업소 관리</a></li>
					<li><a href="/setting/groupSetting.do">그룹 관리</a></li>
					<li><a href="/setting/alarmSetting.do">알람 설정</a></li>
					<c:if test="${role ne '2'}">
					<li><a href="/setting/userSetting.do">사용자 관리</a></li>
					</c:if>
					<li><a href="/setting/comCodeSetting.do">공통 코드 관리</a></li>
					<li><a href="/setting/batchSetting.do">배치 관리</a></li>
				</ul>
			</li>
			</c:if>

			<li class="gmn9"><a href="/spc/notice.do">공지사항</a></li>
			<li class="gmn10"><a href="/logout.do">로그아웃</a></li>
		</ul>
	</div>
</div>