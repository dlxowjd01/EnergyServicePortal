<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>iDERMS</title>
	<script type="text/javascript">
		<c:choose>
			<c:when test="${empty sessionScope.userInfo}">
				location.href = '/login.do';
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${sessionScope.userInfo.first_page ne null and not empty sessionScope.userInfo.first_page}">
						location.href = '/' + '${sessionScope.userInfo.first_page}';
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${sessionScope.userInfo.task eq 1 or sessionScope.userInfo.task eq 2}">
						location.href = '/spc/transactionCalendar.do';
							</c:when>
							<c:otherwise>
						location.href = '/dashboard/gmain.do';
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</script>
</head>
<body>
</body>
</html>