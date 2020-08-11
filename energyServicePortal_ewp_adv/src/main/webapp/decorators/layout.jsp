<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="darkmode">
<head>
<%@ include file="/decorators/include/layouts/top.jsp"%>
</head>
<body class="dark">
	<div class="outer-wrapper">
		<%@ include file="/decorators/include/layouts/header.jsp"%>
		<div class="page-wrapper">
			<%@ include file="/decorators/include/layouts/nav.jsp"%>
			<div id="innerBody" class="container-fluid">
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
<script>
	// document.getElementsByTagName('html')[0].classList['add']('darkmode');
</script>