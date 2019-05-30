<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <script type="text/javascript">
            // location.href = '/hptest';
            <c:choose>
            <c:when test="${empty userInfo}">
            location.href = '/login';
            </c:when>
            <c:when test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2'}">
            location.href = '/main';
            </c:when>
            <c:otherwise>
            location.href = '/siteMain?siteId=${userInfo.site_id}';
            </c:otherwise>
            </c:choose>
        </script>
    </head>
    <body>
        <body>
        </body>
</html>
