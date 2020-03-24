<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/decorators/include/layout/top.jsp"%>
</head>
<body>

	<div id="wrapper">
		<%@ include file="/decorators/include/layout/nav.jsp"%>
		<div id="page-wrapper">
			<%@ include file="/decorators/include/layout/header.jsp"%>
			<div id="container">
				<decorator:body />
			</div>
			<%@ include file="/decorators/include/layout/footer.jsp"%>
		</div>
	</div>

<!-- 레이어 팝업 배경 -->
<div id="mask"></div>
<div class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..." /></div>

</body>
</html>