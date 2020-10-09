<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:set var="oid" value="${userInfo.oid}"/> <%-- 메뉴 관리용 OID --%>
<c:set var="task" value="${userInfo.task}"/> <%-- 메뉴 관리용 Task --%>
<c:set var="userRole" value="${userInfo.role}"/> <%-- 메뉴 관리용 Role --%>

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
	});
</script>

<div id="sidebar" class="side-nav">
	<c:if test="${not empty userInfo}">
	<ul>
		<li class="smn1 menu-item">
			<a href="javascript:void(0);">대시보드</a>
			<div class="sub-layer">
				<ul>
					<li><a href="/dashboard/gmain.do">통합관리 대시보드</a></li>
				</ul>
			</div>
		</li>
		<li class="smn2 menu-item">
			<a href="javascript:void(0);">장치 관리</a>
			<div class="sub-layer">
				<ul>
					<li><a href="/device/deviceState.do">설비구성</a></li>
					<li><a href="/device/collectionState.do">RTU 관리</a></li>
					<li><a href="/device/certManageList.do">인증서 관리</a></li>
					<li><a href="/device/certApplication.do">인증서 신청</a></li>
				</ul>
			</div>
		</li>
		<li class="smn3 menu-item">
			<a href="javascript:void(0);">이력 관리</a>
			<div class="sub-layer">
				<ul>
					<li><a href="/history/operationHistory.do">상태이력</a></li>
					<li><a href="/energy/pvGen.do">발전이력</a></li>
					<li><a href="/history/alarmHistory.do">알람이력</a></li>
				</ul>
			</div>
		</li>
		<li class="smn8 menu-item">
			<a href="javascript:void(0);">설정</a>
			<div class="sub-layer">
				<ul>
					<c:if test="${userRole ne '2'}">
						<li><a href="/setting/userSetting.do">사용자 관리</a></li>
					</c:if>
					<li><a href="/setting/siteSetting.do">사이트 관리</a></li>
				</ul>
			</div>
		</li>
		<li class="smn9"><a href="/spc/notice.do">공지사항</a></li>
		<li class="smn10"><a href="/logout.do">로그아웃</a></li>
	</ul>
	</c:if>
</div>

<div id="mobileNav" class="mobile-nav">
	<div class="logo-wrapper">
		<h1 class="mobile-logo">
			<span class="mobile"></span>
		</h1>
		<a href="javascript:void(0);" class="mobile-nav-close"></a>
	</div>
	
	<div class="g_menu">
		<c:if test="${not empty userInfo}">
		<ul class="menu-list">
			<li class="gmn1 menu-item">
				<a href="javascript:void(0);">대시보드</a>
				<ul class="sub-menu-list">
					<li><a href="/dashboard/gmain.do">통합관리 대시보드</a></li>
				</ul>
			</li>
			<li class="gmn2 menu-item">
				<a href="javascript:void(0);">장치 관리</a>
				<div class="sub-menu-list">
					<ul>
						<li><a href="/device/deviceState.do">설비구성</a></li>
						<li><a href="/device/collectionState.do">RTU 관리</a></li>
						<li><a href="/device/certManageList.do">인증서 관리</a></li>
						<li><a href="/device/certApplication.do">인증서 신청</a></li>
					</ul>
				</div>
			</li>
			<li class="gmn3 menu-item">
				<a href="javascript:void(0);">이력 관리</a>
				<div class="sub-menu-list">
					<ul>
						<li><a href="/history/operationHistory.do">상태이력</a></li>
						<li><a href="/energy/pvGen.do">발전이력</a></li>
						<li><a href="/history/alarmHistory.do">알람이력</a></li>
					</ul>
				</div>
			</li>
			<li class="gmn8 menu-item">
				<a href="javascript:void(0);">설정</a>
				<div class="sub-menu-list">
					<ul>
						<c:if test="${userRole ne '2'}">
							<li><a href="/setting/userSetting.do">사용자 관리</a></li>
						</c:if>
						<li><a href="/setting/siteSetting.do">사이트 관리</a></li>
					</ul>
				</div>
			</li>

			<li class="gmn9"><a href="/spc/notice.do">공지사항</a></li>
			<li class="gmn10"><a href="/logout.do">로그아웃</a></li>
		</ul>
		</c:if>
	</div>
</div>