<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:set var="oid" value="${userInfo.oid}"/> <%-- 메뉴 관리용 OID --%>
<c:set var="task" value="${userInfo.task}"/> <%-- 메뉴 관리용 Task --%>
<script type="text/javascript">
	function gMainSelectSite(siteId) {
		$('#smainNavLink').attr('href', '/main/siteMain.do?siteId=' + siteId);
		$('#energyNavLink').attr('href', '/energy/usage.do?siteId=' + siteId);
		$('#usageNavLink').attr('href', '/energy/usage.do?siteId=' + siteId);
		$('#peakNavLink').attr('href', '/energy/peak.do?siteId=' + siteId);
		$('#essNavLink').attr('href', '/energy/essCharge.do?siteId=' + siteId);
		$('#pvNavLink').attr('href', '/energy/pvGen.do?siteId=' + siteId);
		$('#drResultNavLink').attr('href', '/energy/drResult.do?siteId=' + siteId);
		$('#derNavLink').attr('href', '/energy/derUsage.do?siteId=' + siteId);
		$('#deviceNavLink').attr('href', '/device/deviceMonitoring.do?deviceGbn=IOE&siteId=' + siteId);
		$('#IOENavLink').attr('href', '/device/deviceMonitoring.do?deviceGbn=IOE&siteId=' + siteId);
		$('#PCSNavLink').attr('href', '/device/deviceMonitoring.do?deviceGbn=IOE&siteId=' + siteId);
		$('#BMSNavLink').attr('href', '/device/deviceMonitoring.do?deviceGbn=IOE&siteId=' + siteId);
		$('#PVNavLink').attr('href', '/device/deviceMonitoring.do?deviceGbn=IOE&siteId=' + siteId);
		$('#DVgrpNavLink').attr('href', '/device/deviceGroup.do?siteId=' + siteId);
		$('#alarmNavLink').attr('href', '/alarm/alarmMng.do?siteId=' + siteId);
		$('#billNavLink').attr('href', '/billRevenue/kepcoBill.do?siteId=' + siteId);
		$('#kepcoNavLink').attr('href', '/billRevenue/kepcoBill.do?siteId=' + siteId);
		$('#essBillNavLink').attr('href', '/billRevenue/essRevenue.do?siteId=' + siteId);
		$('#drBillNavLink').attr('href', '/billRevenue/drRevenue.do?siteId=' + siteId);
		$('#pvBillNavLink').attr('href', '/billRevenue/pvRevenue.do?siteId=' + siteId);
		$('#totalBillNavLink').attr('href', 'javascript:totalBill(' + siteId + ');');
		$('#kepcoMngNavLink').attr('href', '/system/kepcoMng.do?siteId=' + siteId);
		$('#gmainAlarmLink').attr('onclick', "location.href='/alarm/alarmMng.do?siteId=" + siteId + "'");
	}

	function navAddClass(linkGbn) {
		// listItem.removeClass("on");
		switch (linkGbn) {
			case "siteMain": sideBar.find(".smn1").addClass("on"); break;
			case "energy": sideBar.find(".smn2").addClass("on"); break;
			case "device": $(".smn3").addClass("on"); break;
			case "alarm": $(".smn4").addClass("on"); break;
			case "billRevenue": $(".smn5").addClass("on"); break;
			case "setting": $(".smn7").addClass("on"); break;
			case "main": $(".smn0").addClass("on"); break;
			case "commonCode": $(".smn9").addClass("on"); break;
			case "notice": $(".smn10").addClass("on"); break;
		}
		// upperMenu.first().addClass("active");
	}

	function pleaseSelectSite() {
		alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');
	}

	$(function () {
		const sideBar = $("#sidebar"),
			menuItem = sideBar.find("li"),
			menuItemLink = menuItem.find("a"),
			upperMenu = sideBar.find("li.menu-item"),
			upperMenuLink = upperMenu.find("a"),
			subMenu = upperMenu.find("li"),
			subMenuLink = subMenu.find("a"),
			path = $(location).attr("pathname");

		subMenuLink.each(function (e) {
			if ($(this).attr("href") === path) {
				$(this).parents(".menu-item").addClass("active").siblings().removeClass("active");
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

		upperMenuLink.click(function (e) {
			$(this).parent("li").toggleClass('on');
		});

		sideBar.mouseleave(function () {
			menuItem.removeClass('on');
		});

		$('#sidebar:after').css('display', 'none') ? menuItemLink.removeClass('on') : null;
		// document.addEventListener('readystatechange', function(){
		//   console.log("ready state changed====")
		// });
		// if(typeof(Storage) !== 'undefined') {
		//   const origin = document.location.origin;
		//   const pathname = document.location.pathname;

		//   // Check if it changes here
		//   const storageOrigin = localStorage.getItem('origin');
		//   const storagePathname = localStorage.getItem('pathname');

		// upperMenu.each(function(e){
		//   if($(this).children('a[href="' + path + '"]')){
		//     console.log('found match====', $(this).children("a"))
		//   }
		// })
		// Check if storageOrigin and storagePathname are not null or undefined.
		// if (storageOrigin && storagePathname) {
		//   if (storageOrigin !== origin || storagePathname !== pathname) {
		//     console.log("storageOrigin !== origin")
		//     subMenuLink.each(function(e){
		//       if( $(this).attr("href") === path ){
		//         // console.log("found the match");
		//         $(this).parents(".menu-item").addClass("active").siblings().removeClass("active");
		//       }
		//     });
		//   } else {
		//     console.log("storageOrigin === origin")
		//     if(path.includes("dashboard")){
		//       upperMenu.first().css("border", "solid 1px red").addClass("active");
		//     }
		//   }
		// }
		// console.log("setItem origin=====")
		//   localStorage.setItem('origin', origin);
		//   localStorage.setItem('pathname', pathname);
		// } else {
		//   console.log('storage origin and path name are null')
		// }
		// (function(){
		// })();
	});
</script>

<div id="sidebar">
	<c:if test="${not empty userInfo}">
		<ul>
			<li class="smn1 menu-item">
				<a href="javascript:void(0);">대시보드</a>
				<div class="sub_layer">
					<ul>
						<li><a href="/dashboard/gmain.do">통합관리 대시보드</a></li>
						<c:if test="${oid ne 'trust' and oid ne 'sundream'}">
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

			<c:if test="${oid ne 'trust' and oid ne 'sundream'}">
			<li class="smn7 menu-item">
				<a href="javascript:void(0);">보고서</a>
				<div class="sub_layer">
					<ul>
						<li><a href="/report/yieldReport.do">수익보고서</a></li>
						<li><a href="/report/maintenanceReport.do">작업보고서</a></li>
					</ul>
				</div>
			</li>
			</c:if>

			<c:if test="${(oid ne 'trust' and oid ne 'sundream') or (oid eq 'trust' and task ne 3) or (oid eq 'sundream' and task ne 3)}">
			<li class="smn9 menu-item">
				<a href="javascript:void(0);">SPC관리</a>
				<div class="sub_layer">
					<ul>
						<li><a href="/spc/entityInformation.do">기본정보</a></li>
						<li><a href="/spc/balanceSheet.do">금융관리</a></li>
						<li><a href="/spc/transactionSheet.do">입출금 관리 (사무수탁사)</a></li>
						<li><a href="/spc/transactionSheet2.do">입출금 관리 (자산운용사)</a></li>
						<li><a href="/spc/maintenanceSchedule.do">점검계획</a></li>
						<li><a href="/spc/supplementaryDocuments.do">이관자료</a></li>

					</ul>
				</div>
			</li>
			<li class="smn6 menu-item">
				<a href="javascript:void(0);">설정</a>
				<div class="sub_layer">
					<ul>
						<li><a href="/system/basicInformation.do">기본정보</a></li>
						<li><a href="/system/userMng.do">사용자관리</a></li>
						<li><a href="/system/cmpyGrpSiteMng.do">사이트/그룹관리</a></li>
						<li><a href="/system/alarmManagement.do">알람관리</a></li>
						<li><a href="/system/systemCode.do">공통코드</a></li>
						<li><a href="/system/systemSetting.do">시스템설정</a></li>
					</ul>
				</div>
			</li>
		</ul>
		<ol>
			<li class="smn10"><a href="/spc/notice.do">공지사항</a></li>
			<li class="smn8"><a href="/logout.do">로그아웃</a></li>
		</ol>
	</c:if>
</div>
<!-- 모바일용 카테고리 { -->
<div id="gnb">
	<div class="g_top">
		<div class="w100">
			<h1 class="g_logo"><a href="javascript:void(0);"><img src="/img/s-power_logo_dark.png" class="로고"></a></h1>
			<a href="javascript:void(0);" class="category_close"><img src="/img/gnb_close.png" width="17" alt="닫기"></a>
		</div>
	</div>
	<div class="g_menu w100">
		<ul>
			<li class="gmn1">
				<a href="javascript:void(0);">대시보드</a>
				<ul>
					<li><a href="/dashboard/gmain.do">통합관리 대시보드</a></li>
					<%--<li>--%>
					<%--  <a href="javascript:void(0);">사업소 대시보드</a>--%>
					<%--  <div>--%>
					<%--    <p><a href="/dashboard/smain.do">신재생발전 대시보드</a></p>--%>
					<%--    <p><a href="/dashboard/emain.do">피크저감ESS 대시보드</a></p>--%>
					<%--    <p><a href="/dashboard/dmain.do">신재생발전+신재생 연계 ESS</a></p>--%>
					<%--  </div>--%>
					<%--</li>--%>
					<li><a href="/dashboard/jmain.do">중개거래 대시보드</a></li>
					<!-- <li><a href="">수요자원 대시보드</a></li> -->
				</ul>
			</li>
			<li class="gmn2">
				<a href="javascript:void(0);">설비현황</a>
				<ul>
					<li><a href="/device/deviceState.do">설비구성</a></li>
					<li><a href="/device/collectionState.do">수집현황</a></li>
				</ul>
			</li>
			<li class="gmn3">
				<a href="javascript:void(0);">설비 이력</a>
				<ul>
					<li><a href="/history/operationHistory.do">상태이력</a></li>
					<li><a href="/history/alarmHistory.do">알람이력</a></li>
				</ul>
			</li>
			<li class="gmn4">
				<a href="javascript:void(0);">자원분석</a>
				<ul>
					<li><a href="/energy/pvGen.do">발전이력</a></li>
					<%--<li><a href="/energy/essCharge.do">피크저감 ESS</a></li>--%>
					<!-- <li><a href="/energy/sub01.html">수요</a></li> -->
					<%--<li><a href="/energy/drResult.do">수요자원<!-- DR --></a></li>--%>
				</ul>
			</li>
			<li class="gmn5">
				<a href="javascript:void(0);">예측/진단</a>
				<ul>
					<li><a href="/diagnosis/generation.do">발전예측</a></li>
					<li><a href="/diagnosis/abnormallyAnalysis.do">이상분석</a></li>
				</ul>
			</li>
			<!--<li class="gmn8">
        <a href="javascript:void(0);">BOM관리</a>
        <ul>
          <li><a href="/bom/faultHistory.do">고장이력</a></li>
            <li><a href="/bom/replacement.do">변경이력</a></li>
            <li><a href="/bom/partManagement.do">부품관리</a></li>
        </ul>
      </li>-->
			<li class="gmn7">
				<a href="javascript:void(0);">보고서</a>
				<ul>
					<li><a href="/report/yieldReport.do">수익보고서</a></li>
					<li><a href="/report/maintenanceReport.do">작업보고서</a></li>
				</ul>
			</li>
			<li class="gmn9">
				<a href="javascript:void(0);">SPC관리</a>
				<ul>
					<li><a href="/spc/entityInformation.do">기본정보</a></li>
					<li><a href="/spc/balanceSheet.do">원가관리</a></li>
					<li><a href="/spc/transactionSheet.do">입출금 관리 (사무수탁사)</a></li>
					<li><a href="/spc/transactionSheet2.do">입출금 관리 (자산운용사)</a></li>
					<li><a href="/spc/maintenanceSchedule.do">점검계획</a></li>
					<li><a href="/spc/supplementaryDocuments.do">이관자료</a></li>
				</ul>
			</li>
			<li class="gmn6">
				<a href="javascript:void(0);">설정</a>
				<ul>
					<li><a href="/system/basicInformation.do">기본정보</a></li>
					<li><a href="/system/userMng.do">사용자관리</a></li>
					<li><a href="/system/cmpyGrpSiteMng.do">사이트/그룹관리</a></li>
					<li><a href="/system/alarmManagement.do">알람관리</a></li>
					<li><a href="/system/systemCode.do">공통코드</a></li>
					<li><a href="/system/systemSetting.do">시스템설정</a></li>
				</ul>
			</li>
		</ul>
		<ol>
			<li class="gmn10"><a href="/spc/notice.do">공지사항</a></li>
			<li class="gmn8"><a href="/logout.do">로그아웃</a></li>
		</ol>
	</div>
</div>