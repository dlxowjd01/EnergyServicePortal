<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="darkmode">
<head>
	<!-- high-stock -->
	<script type="text/javascript" src="/js/highcharts.js"></script>
	<script type="text/javascript">
		const langStatus = '${cookieLang}';
		const certApiHost = '${certApiHost}';
	</script>
	<page:applyDecorator name="top"/>
</head>
<body>
<div id="outerWrapper" class="outer-wrapper">
	<page:applyDecorator name="header"/>
	<div class="page-wrapper">
		<page:applyDecorator name="nav"/>

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