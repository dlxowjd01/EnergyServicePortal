<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<%
String hostname = request.getServerName();
String oid = "encored";
if( "spower.iderms.ai".equals(hostname) )
        oid="spower";
else if( "13.114.199.169".equals(hostname) )
        oid="spower";

%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>iDERMS</title>
	<script type="text/javascript">
		// location.href = '/hptest';
		<c:choose>
			<c:when test="${empty userInfo}">
				location.href = '/login.do?oid=<% out.print(oid); %>';
			</c:when>
			<c:otherwise>
				location.href = '/dashboard/gmain.do?oid=<% out.print(oid); %>';
			</c:otherwise>
		</c:choose>
	</script>
</head>
<body>
</body>
</html>