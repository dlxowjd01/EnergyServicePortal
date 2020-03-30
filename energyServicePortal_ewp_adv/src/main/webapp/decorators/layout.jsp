<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/decorators/include/layouts/top.jsp"%>
</head>
<body>

	<div id="wrapper">
		<%@ include file="/decorators/include/layouts/header.jsp"%>
		<div id="page-wrapper">
			<%@ include file="/decorators/include/layouts/nav.jsp"%>
			<div id="container">
				<decorator:body />
			</div>
			<%@ include file="/decorators/include/layouts/footer.jsp"%>
		</div>
	</div>

<!-- 레이어 팝업 배경 -->
<div id="mask"></div>
<div class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..." /></div>

</body>
</html>