<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %>

<c:set var="cookieLang" value="${fn:toUpperCase(cookie['lang'].value)}"/>
<c:if test="${cookieLang eq null or empty cookieLang}">
	<c:set var="cookieLang" value="KO"/>
</c:if>

<fmt:setLocale value="${cookieLang}"/>
<fmt:setBundle basename="kr.co.esp.message.com.message-common" />