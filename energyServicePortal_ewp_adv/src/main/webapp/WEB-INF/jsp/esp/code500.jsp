<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>error</title>

<script language="javascript">
function fncGoAfterErrorPage(){
    history.back(-2);
}
</script>
</head>
<body>

	<div style="width: 100%; margin: 50px auto 50px; text-align: center;">

		<!-- <p style="font-size: 18px; color: #000; margin-bottom: 10px; "><img src="<c:url value='/img/logo_encored_wh' />" width="379" height="57" /></p>
		 -->
		<h1 style="color:rgba(255,255,255,0.97); font-size: 56px; text-align: center; line-height: 64px;">500 Error</h1>
		<h2 style="color:rgba(255,255,255,0.97); font-size: 24px; text-align: center; line-height: 32px; margin-bottom: 48px;">서버 응답에 실패 했습니다.<br /></h2>
		<a href="javascript:fncGoAfterErrorPage();" style="padding: 10px 36px; background-color: #1d98e9; color: rgba(255,255,255, 0.87); border-radius: 2px; border-width:0">이전 페이지</a>
	</div>

</body>
</html>