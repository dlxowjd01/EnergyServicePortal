<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="darkmode">
	<head>
	<%@ include file="/decorators/include/layouts/top.jsp"%>
	</head>
	<body>
		<div id="outerWrapper" class="outer-wrapper">
			<%@ include file="/decorators/include/layouts/header.jsp"%>
			<div class="page-wrapper">
				<%@ include file="/decorators/include/layouts/nav.jsp"%>
				<div id="innerBody" class="container-fluid">
					<decorator:body />
				</div>
				<%@ include file="/decorators/include/layouts/footer.jsp"%>
		</div>
	</div>
	<div id="mask"></div>
	<div id="loadingCircle" class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..." /></div>	
	</body>
</html>