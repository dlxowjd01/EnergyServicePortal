<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
			<nav class="clear">
				<button type="button" class="category">카테고리</button>
				<div class="nav_brand"><a href="#;">EWP</a></div>
				<div class="site dropdown">
					<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
						군관리: ${fn:length(userSiteList)} Sites<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li class="on"><a href="/siteMain?siteId=${item.site_id }">군관리: ${fn:length(userSiteList)} Sites</a></li>
						<c:forEach var="item" items="${userSiteList }">
							<li><a href="/siteMain?siteId=${item.site_id }">${item.site_name }</a></li>
						</c:forEach>
					</ul>
				</div>
				<ul class="nav_right">
					<li>
						<span>CURRENT TIME</span> <em id="currTime">${nowTime}<!-- 2018-07-27 17:10:05 --></em>
					</li>
					<li>
						<span>DATA BASE TIME</span> <em id="dataTime">${nowTime}<!-- 2018-07-27 17:01:02 --></em>
					</li>
					<li class="member clear">
						<div class="fl"><img src="../img/member_pic.jpg" alt=""></div>
						<div class="fr">
							<span>
								<c:choose>
									<c:when test="${not empty userInfo and not empty userInfo.co_name}">${userInfo.co_name}</c:when>
									<c:otherwise>Not logined</c:otherwise>
								</c:choose>
							</span><br/>
							<c:choose>
								<c:when test="${empty userInfo}">No Permission</c:when>
								<c:when test="${userInfo.auth_type eq '1'}">Portal Administrator</c:when>
								<c:when test="${userInfo.auth_type eq '2'}">Group Administrator</c:when>
								<c:when test="${userInfo.auth_type eq '3'}">Site Administrator</c:when>
								<c:when test="${userInfo.auth_type eq '4'}">Site User</c:when>
								<c:otherwise>No Permission</c:otherwise>
							</c:choose>
						</div>
					</li>
				</ul>
			</nav>

<script type="text/javascript">
$(function() {
	// 매초 갱신
	setInterval(refreshCurrTime, 1000);
	refreshDataTime();
});

// 현재 시간 갱신
function refreshCurrTime() {
	var currEm = $('#currTime');
	var now = new Date();
	currEm.text(now.format('yyyy-MM-dd HH:mm:ss'));
}

// 데이터 조회 시간 갱신
function refreshDataTime() {
	var dataEm = $('#dataTime');
	var now = new Date();
	dataEm.text(now.format('yyyy-MM-dd HH:mm:ss'));
}
</script>
