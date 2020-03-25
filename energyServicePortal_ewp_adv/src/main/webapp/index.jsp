<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>한국동서발전(주)</title>
	<script type="text/javascript">
		// location.href = '/hptest';
		<c:choose>
			<c:when test="${empty userInfo}">
				location.href = '/login.do';
			</c:when>
			<c:when test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2'}">
				location.href = '/main/gMain.do';
			</c:when>
			<c:otherwise>
				location.href = '/main/siteMain.do?siteId=${userInfo.site_id}';
			</c:otherwise>
		</c:choose>
	</script>
</head>
<body>
</body>
</html>