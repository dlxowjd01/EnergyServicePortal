<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="darkmode">
<head>
	<script type="text/javascript">
		const langStatus = '${cookieLang}';
	</script>
	<page:applyDecorator name="top"/>
</head>
<body>
<div id="outerWrapper" class="outer-wrapper">
	<page:applyDecorator name="header"/>
	<div class="page-wrapper">
		<c:choose>
			<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				<%@ include file="/decorators/include/layouts/nav-kpx.jsp" %>
			</c:when>
			<c:otherwise>
				<%@ include file="/decorators/include/layouts/nav.jsp" %>
			</c:otherwise>
		</c:choose>
		<div id="innerBody" class="container-fluid">
			<decorator:body/>
		</div>
		<page:applyDecorator name="footer"/>
	</div>
</div>

<!-- 레이어 팝업 배경 -->
<div id="mask"></div>
<div id="loadingCircle" class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div>

</body>
</html>