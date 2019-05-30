    <%@ page language="java" contentType="text/html; charset=UTF-8"
             pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
        <c:if test="${not empty userInfo}">
            <!-- PC용 언어 선택 -->
            <div class="lang dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button"
            data-toggle="dropdown">${sessionScope.sessionLangNm }
            <span class="caret"></span></button>
            <ul class="dropdown-menu">
            <li><a href="javascript:addParameterUrl('lang', 'ko');">KO</a></li>
            <li><a href="javascript:addParameterUrl('lang', 'en');">EN</a></li>
            </ul>
            </div>
            <ul>
            <c:choose>
                <c:when test="${not empty userInfo and empty selViewSiteId}">
                    <li class="smn1"><a id="smainLink" href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');">
                    <spring:message code="ewp.menu.Main"/><!-- 메인 --></a></li>
                    <li class="smn2"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.View_energy_information"/><!-- 에너지<br/> 정보조회 --></a></li>
                    <li class="smn3"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.Device_monitoring"/><!-- 장치<br/> 모니터링 --></a></li>
                    <li class="smn4"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.Control_management"/><!-- 상황관제 --></a></li>
                    <li class="smn5"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.Bill_Revenue"/><!-- 요금/수익 --></a></li>
                </c:when>
                <c:otherwise>
                    <li class="smn1"><a href="/siteMain?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Main"/>
                    <!-- 메인 --></a></li>
                    <li class="smn2">
                    <a href="/usage?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_energy_information"/>
                    <!-- 에너지<br/>정보조회 --></a>
                    <div class="sub_layer">
                    <ul>
                    <li><a href="/usage?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Energy_usage_status"/>
                    <!-- 사용량 현황 --></a></li>
                    <li><a href="/peak?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Peak_demand_status"/>
                    <!-- 피크전력 현황 --></a></li>
                    <li><a href="/essCharge?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.View_ESS_charge_discharge"/><!-- ESS 충•방전량 조회 --></a></li>
                    <li><a href="/pvGen?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.View_PV_power_generation"/><!-- PV 발전량 조회 --></a></li>
                    <li><a href="/drResult?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_DR_results"/>
                    <!-- DR 실적 조회 --></a></li>
                    <li><a href="/derUsage?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Usage_composition"/>
                    <!-- 사용량 구성 --></a></li>
                    </ul>
                    </div>
                    </li>
                    <li class="smn3">
                    <a href="/deviceMonitoring?deviceGbn=IOE&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.Device_monitoring"/><!-- 장치<br/>모니터링 --></a>
                    <div class="sub_layer">
                    <ul>
                    <li><a href="/deviceMonitoring?deviceGbn=IOE&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.IOE_communication_status"/><!-- IOE 통신상태 --></a></li>
                    <li><a href="/deviceMonitoring?deviceGbn=PCS&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.PCS_operation_status"/><!-- PCS 통신상태 --></a></li>
                    <li><a href="/deviceMonitoring?deviceGbn=BMS&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.BMS_operation_status"/><!-- BMS 통신상태 --></a></li>
                    <li><a href="/deviceMonitoring?deviceGbn=PV&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.PV_operation_status"/><!-- PV 통신상태 --></a></li>
                    <li><a href="/deviceGroup?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.Device_group_status"/><!-- 장치 그룹 현황 --></a></li>
                    </ul>
                    </div>
                    </li>
                    <li class="smn4"><a href="/control?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.Control_management"/><!-- 상황관제 --></a></li>
                    <li class="smn5">
                    <a href="/kepcoBill?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Bill_Revenue"/><!--
                    요금/수익 --></a>
                    <div class="sub_layer">
                    <ul>
                    <li><a href="/kepcoBill?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_KEPCO_bill"/>
                    <!-- 한전 요금 조회 --></a></li>
                    <li><a href="/essRevenue?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.View_ESS_revenue"/><!-- ESS 수익 조회 --></a></li>
                    <li><a href="/drRevenue?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_DR_revenue"/>
                    <!-- DR 수익 조회 --></a></li>
                    <li><a href="/pvRevenue?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_PV_revenue"/>
                    <!-- PV 수익 조회 --></a></li>
                    <li><a href="javascript:totalBill('${selViewSiteId }');"><spring:message
                        code="ewp.menu.Consolidated_statement"/><!-- 통합 명세서 --></a></li>
                    </ul>
                    </div>
                    </li>
                </c:otherwise>
            </c:choose>
            </ul>
            <ol>
            <c:if test="${userInfo.auth_type ne '5'}">
                <c:if test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2' or userInfo.auth_type eq '3'}">
                    <li class="smn6"><a href="/main?siteId=${selViewSiteId }">군관리<br/>메인</a></li>
                </c:if>
                <li class="smn7">
                <a href="#;"><spring:message code="ewp.menu.Settings"/><!-- 설정 --></a>
                <div class="sub_layer">
                <ul>
                <c:choose>
                    <c:when test="${not empty userInfo and empty selViewSiteId}">
                        <li><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                            code="ewp.menu.KEPCO_management"/><!-- 한전관리설정 --></a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="/kepcoMngSet?siteId=${selViewSiteId }"><spring:message
                            code="ewp.menu.KEPCO_management"/><!-- 한전관리설정 --></a></li>
                    </c:otherwise>
                </c:choose>
                <c:if test="${userInfo.auth_type ne '4'}">
                    <li><a href="/cmpyGrpSiteMng?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.Group_site_management"/><!-- 그룹/사이트 관리 --></a></li>
                </c:if>
                <li><a href="/userMng?siteId=${selViewSiteId }"><spring:message code="ewp.menu.User_management"/><!--
                사용자관리 --></a></li>
                </ul>
                </div>
                </li>
            </c:if>
            <li class="smn8"><a href="/logout" class="LoginBtn">로그아웃</a></li>
            </ol>
        </c:if>
        </div>
        <!-- 모바일용 카테고리 { -->
        <div id="gnb">
        <div class="g_top">
        <div class="w100">
        <h1 class="g_logo"><a href="#;"><img src="../img/main_logo_ewp.png" class="로고"></a></h1>
        <a href="#;" class="category_close"><img src="../img/gnb_close.png" width="17" alt="닫기"></a>
        </div>
        </div>
        <div class="g_menu w100">
        <c:if test="${not empty userInfo}">
            <!-- 모바일용 언어 선택 -->
            <div class="lang dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button"
            data-toggle="dropdown">${sessionScope.sessionLangNm }
            <span class="caret"></span></button>
            <ul class="dropdown-menu">
            <li><a href="javascript:addParameterUrl('lang', 'ko');">KO</a></li>
            <li><a href="javascript:addParameterUrl('lang', 'en');">EN</a></li>
            </ul>
            </div>
            <ul>
            <c:choose>
                <c:when test="${not empty userInfo and empty selViewSiteId}">
                    <li class="gmn1"><a id="smainLink" href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');">
                    <spring:message code="ewp.menu.Main"/><!-- 메인 --></a></li>
                    <li class="gmn2"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.View_energy_information"/><!-- 에너지 정보조회 --></a></li>
                    <li class="gmn3"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.Device_monitoring"/><!-- 장치 모니터링 --></a></li>
                    <li class="gmn4"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.Control_management"/><!-- 상황관제 --></a></li>
                    <li class="gmn5"><a href="javascript:alert('선택된 사이트가 없습니다.\n사이트를 선택해 주세요.');"><spring:message
                        code="ewp.menu.Bill_Revenue"/><!-- 요금/수익 --></a></li>
                </c:when>
                <c:otherwise>
                    <li class="gmn1"><a href="/siteMain?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Main"/>
                    <!-- 메인 --></a></li>
                    <li class="gmn2"><a href="#;"><spring:message code="ewp.menu.View_energy_information"/><!-- 에너지 정보조회
                    --></a>
                    <ul>
                    <li><a href="/usage?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Energy_usage_status"/>
                    <!-- 사용량 현황 --></a></li>
                    <li><a href="/peak?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Peak_demand_status"/>
                    <!-- 피크전력 현황 --></a></li>
                    <li><a href="/essCharge?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.View_ESS_charge_discharge"/><!-- ESS 충•방전량 조회 --></a></li>
                    <li><a href="/pvGen?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.View_PV_power_generation"/><!-- PV 발전량 조회 --></a></li>
                    <li><a href="/drResult?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_DR_results"/>
                    <!-- DR 실적 조회 --></a></li>
                    <li><a href="/derUsage?siteId=${selViewSiteId }"><spring:message code="ewp.menu.Usage_composition"/>
                    <!-- 사용량 구성 --></a></li>
                    </ul>
                    </li>
                    <li class="gmn3"><a href="#"><spring:message code="ewp.menu.Device_monitoring"/><!-- 장치 모니터링 --></a>
                    <ul>
                    <li><a href="/deviceMonitoring?deviceGbn=IOE&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.IOE_communication_status"/><!-- IOE 통신상태 --></a></li>
                    <li><a href="/deviceMonitoring?deviceGbn=IOE&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.PCS_operation_status"/><!-- PCS 통신상태 --></a></li>
                    <li><a href="/deviceMonitoring?deviceGbn=IOE&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.BMS_operation_status"/><!-- BMS 통신상태 --></a></li>
                    <li><a href="/deviceMonitoring?deviceGbn=IOE&siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.PV_operation_status"/><!-- PV 통신상태 --></a></li>
                    <li><a href="/deviceGroup?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.Device_group_status"/><!-- 장치 그룹 현황 --></a></li>
                    </ul>
                    </li>
                    <li class="gmn4"><a href="/control?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.Control_management"/><!-- 상황관제 --></a></li>
                    <li class="gmn5"><a href="#"><spring:message code="ewp.menu.Bill_Revenue"/><!-- 요금/수익 --></a>
                    <ul>
                    <li><a href="/kepcoBill?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_KEPCO_bill"/>
                    <!-- 한전 요금 조회 --></a></li>
                    <li><a href="/essRevenue?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.View_ESS_revenue"/><!-- ESS 수익 조회 --></a></li>
                    <li><a href="/drRevenue?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_DR_revenue"/>
                    <!-- DR 수익 조회 --></a></li>
                    <li><a href="/pvRevenue?siteId=${selViewSiteId }"><spring:message code="ewp.menu.View_PV_revenue"/>
                    <!-- PV 수익 조회 --></a></li>
                    </ul>
                    </li>
                </c:otherwise>
            </c:choose>
            </ul>
            <ol>
            <c:if test="${userInfo.auth_type ne '5'}">
                <c:if test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2' or userInfo.auth_type eq '3'}">
                    <li class="gmn6"><a href="/main?siteId=${selViewSiteId }">군관리 메인</a></li>
                </c:if>
                <li class="gmn7"><a href="/cmpyGrpSiteMng?siteId=${selViewSiteId }"><spring:message
                    code="ewp.menu.Settings"/><!-- 설정 --></a>
                <ul>
                <li><a href="/kepcoMngSet?siteId=${selViewSiteId }"><spring:message code="ewp.menu.KEPCO_management"/>
                <!-- 한전관리설정 --></a></li>
                <c:if test="${userInfo.auth_type ne '4'}">
                    <li><a href="/cmpyGrpSiteMng?siteId=${selViewSiteId }"><spring:message
                        code="ewp.menu.Group_site_management"/><!-- 그룹/사이트 관리 --></a></li>
                </c:if>
                <li><a href="/userMng?siteId=${selViewSiteId }"><spring:message code="ewp.menu.User_management"/><!--
                사용자관리 --></a></li>
                </ul>
                </li>
            </c:if>
            <li class="gmn8"><a href="/logout">로그아웃</a></li>
            </ol>
        </c:if>
        </div>
        </div>
        <!-- } 모바일용 카테고리 -->
