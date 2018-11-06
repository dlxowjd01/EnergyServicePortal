<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
	<meta name="format-detection" content="telephone=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
	<title>동서발전 Service Portal</title>
	<link href="../css/bootstrap.css" rel="stylesheet">
	<link href="../css/font-awesome.min.css" rel="stylesheet">
	<link href="../css/custom.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/jquery-ui.css" type="text/css" media="all"> <!-- datapicker용 -->	
	<!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->	
    <script src="../js/jquery.min.js"></script>
    <script src="../js/jquery-ui.js"></script>
    <script src="../js/jquery-ui-1.12.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script src="../js/highcharts.js"></script>
    <!-- 하이차트 데이타 추출용 -->
    <script src="../js/modules/data.js"></script>
    <script src="../js/modules/exporting.js"></script>
    <script src="../js/modules/export-data.js"></script>  
    <!-- //하이타트 데이타 추출용 -->
    <script src="../js/sectionDisplay.js"></script> <!-- 텝메뉴 용 -->
    <!-- 인쇄 미리보기용 -->
    <script src="../js/printPreview.js"></script>    
    <script src="../js/common.js"></script>
<script src="../js/comm_sch_chartData.js" type="text/javascript"></script>
<script src="../js/utils.js"></script>
<script src="../js/dbData.js" type="text/javascript"></script>
<script src="../js/lems.js" type="text/javascript"></script>
<script src="../js/jquery.form.min.js"></script>
<script src="../js/moment.js"></script>
<script src="../js/moment-timezone.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		setTimeZoneInCookie();
	});
	
    function setTimeZoneInCookie() {
        var _myDate = new Date();
        var _offset = _myDate.getTimezoneOffset();
        document.cookie = "TIMEZONE_COOKIE=" + _offset; //Cookie name with value
    }
</script>

