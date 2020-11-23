<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<meta name="format-detection" content="telephone=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
<c:choose>
	<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
		<title>S-POWER iDERMS</title>
	</c:when>
	<c:when test="${fn:contains(pageContext.request.serverName, 'wpsolar')}">
		<title>WpSolar iDERMS</title>
	</c:when>
	<c:otherwise>
		<title>Encored iDERMS</title>
	</c:otherwise>
</c:choose>

<link type="text/css" rel="stylesheet" href="/css/bootstrap.min.css">

<link type="text/css" rel="stylesheet" href="/css/custom.css">
<link type="text/css" rel="stylesheet" href="/css/custom-grid.min.css">
<link type="text/css" rel="stylesheet" href="/css/custom-mquery.css">
<link type="text/css" rel="stylesheet" href="/css/jquery-ui.css" media="all" >
<link type="text/css" rel="stylesheet" href="/css/wickedpicker.css" media="all">

<link type="text/css" rel="stylesheet" href="/css/data_tables/default.css"/>
<!--[if lt IE 9]>
<script type="text/javascript" src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script type="text/javascript" src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->

<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery.blockUI.js"></script>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/jquery-ui-1.12.1.min.js"></script>
<script type="text/javascript" src="/js/bootstrap.min.js"></script>


<script type="text/javascript">
	const currentPath = window.location.pathname;

	/*
		### pages with DataTable plugins ###

		1. /dashboard/gmain.do => dashboardTableView ONLY
		2. /dashboard/dmain.do

		3. /device/certManageDetail.do
		4. /device/certManageList.do

		5. TO DO!!! /diagnosis/abnormallyAnalysis.do (NOT IN USE ATM)
		6. TO DO!!! /diagnosis/generation.do (NOT IN USE ATM)

		7. TO DO!!! /history/operationHistory.do  (NOT IN USE ATM)

		8. /report/maintenanceReport.do
		9. /report/yieldReport.do

		10. /spc/balanceSheet.do
		11. /spc/entityInformation.do
		12. /spc/supplementaryDocuments.do
		13. /spc/transactionHistory.do

		14. /spc/withdrawReqStatus.do
		15. /spc/notice.do
		
		16. /setting/alarmSetting.do
		17. /setting/batchSetting.do
		18. /setting/comCodeSetting.do
		19. /setting/userSetting.do
		20. /setting/siteSetting.do
		21. /setting/groupSetting.do
	*/
	
	let excludeMenu = [
		'/dashboard/gmain.do',
		'/dashboard/smain.do',
		'/dashboard/jmain.do',
		'/dashboard/dmain.do',
		'/diagnosis/generation.do',
		'/diagnosis/abnormallyAnalysis.do',
		'/energy/pvGen.do',
		'/history/operationHistory.do'
	];
	let excludeOption = [
		'/report/maintenanceReport.do',
		'/setting/alarmSetting.do',
	];
	
	let isInExcludeList = excludeMenu.some( x => x == currentPath);
	let pluginOption = excludeOption.some( x => x == currentPath);

	if (isInExcludeList == false ) {
		console.log("isInExcludeList == false");
		let importList = [];

		if(pluginOption == false){
			importList = ['/js/data_tables/include_basic.min.js'];
		} else {
			importList = ['/js/data_tables/include_all.min.js'];
		}
		console.log("importList==", importList)

		loadScripts(importList, () => {
			console.log('1-A ===> Scripts loaded');
		});


	} else {
		if(currentPath == excludeMenu[0]){
			loadScripts([
				'/js/data_tables/include_dashboard.min.js'
			], () => {
				console.log('Gmain Scripts loaded');
			});
		}
	}

	function loadScript (url, callback) {
		let script = document.createElement('script');
		script.type = 'text/javascript';
		script.src = url;
		script.onreadystatechange = callback;
		script.onload = callback;
		// console.log("script==", script)
		document.head.appendChild(script);
		console.log('script=====', script);
	}
	function loadScripts (urls, callback) {
		let loadedCount = 0;
		let multiCallback = () => {
			loadedCount++;
			if (loadedCount >= urls.length) {
				callback.call(this, arguments);
			}
		};
		for (let url of urls) {
			loadScript(url, multiCallback);
		}
	}

</script>


<!-- high-stock -->
<script type="text/javascript" src="/js/highstock.js"></script>
<script type="text/javascript" src="/js/modules/variwide.js"></script>
<script type="text/javascript" src="/js/modules/data.js"></script>

<!-- <script type="text/javascript" src="/js/modules/highstock-exporting.js"></script> -->
<script type="text/javascript" src="/js/modules/exporting.js"></script>
<script type="text/javascript" src="/js/modules/export-data.js"></script>
<script type="text/javascript" src="/js/common.js"></script>

<script type="text/javascript" src="/js/custom/utils.js"></script>
<script type="text/javascript" src="/js/custom/numberFormat.js"></script>

<script type="text/javascript" src='/js/commonDropdown.js'></script>

<script type="text/javascript" src="/js/html2canvas.js"></script>

<!-- 화면 엑셀 다운로드용 -->
<script type="text/javascript" src="/js/sheetJs/xlsx.full.min.js"></script>
<script type="text/javascript" src="/js/fileSaver/FileSaver.min.js"></script>

<!-- timepicker -->
<script type="text/javascript" src="/js/wickedpicker.js"></script>

<script type="text/javascript">
	// role => 1: 시스템관리자, 2: 일반
	const role = '${sessionScope.userInfo.role}';
	// task => 0: 일반, 1:사무수탁, 2:자산운용, 3:출금관리, 4:사업주
	const task = '${sessionScope.userInfo.task}';
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const userInfoId = '${sessionScope.userInfo.uid}';
	const loginName = '${sessionScope.userInfo.name}';
	const loginMail = '${sessionScope.userInfo.contact_email}';
	const contact_phone = '${sessionScope.userInfo.contact_phone}';
	const apiHost = '${apiHost}';
	const activateSPC = '${activateSPC}';
	const navCount = 10; //한 화면당 네비게이션 갯수
	let pagePerData = 15; //페이지당 게시글 갯수
	let page = 1; //현재 페이지
	var timeOffset = '${timeOffset}';
	var sessionUser = null;

	const changeFavicon = link => {
		let $favicon = document.querySelector('link[rel="icon"]');
		if ($favicon !== null) {
			$favicon.href = link
		} else {
			$favicon = document.createElement("link")
			$favicon.rel = "icon"
			$favicon.href = link
			document.head.appendChild($favicon)
		}
	};

	$(document).ready(function () {

		<c:choose>
			<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
		changeFavicon('/resources/favicon.ico');
			</c:when>
			<c:when test="${fn:contains(pageContext.request.serverName, 'wpsolar')}">
		changeFavicon('/resources/favicon_wpsolar.ico');
			</c:when>
			<c:otherwise>
		changeFavicon('/resources/favicon_encored.ico');
			</c:otherwise>
		</c:choose>


		if(!$('#loadingCircle').is(":hidden")){
			$('#loadingCircle').hide();
		}
		if(!$('#loadingCircle2').is(":hidden")){
			$('#loadingCircle2').hide();
		}
	});

	//API 토큰 세팅
	$.ajaxSetup({
		headers: {'Authorization': 'Bearer <c:out value="${sessionScope.userInfo.token}" escapeXml="false" />'},
		"timeout": 30000,
	});

	$(document).ajaxSuccess(function() {
		if(!$('#loadingCircle').is(":hidden")){
			$('#loadingCircle').hide();
		}
	});

	$(document).ajaxError(function(event, jqxhr, settings, thrownError) {
		if(!$('#loadingCircle').is(":hidden")){
			$('#loadingCircle').hide();
		}
	});

	$(".nav-brand a").each(function(index, element) {
		// console.log("window.href===", window.location.pathname)
		if (currentPath == excludeMenu[0]) {
			$(this).on('click', false);
		}
	});

	
	function formatErrorMessage(jqXHR, exception) {
		if (jqXHR.status === 0) {
			return ('Not connected.\nPlease verify your network connection.');
		} else if (jqXHR.status == 404) {
			return ('The requested page not found. [404]');
		} else if (jqXHR.status == 500) {
			return ('Internal Server Error [500].');
		} else if (exception === 'parsererror') {
			return ('Requested JSON parse failed.');
		} else if (exception === 'timeout') {
			return ('Time out error.');
		} else if (exception === 'abort') {
			return ('Ajax request aborted.');
		} else {
			return ('Uncaught Error.\n' + jqXHR.responseText);
		}
	}

	function sessionRefresh() {
		$.ajax({
			url: "/openapi/loginUser.json",
			type: 'post',
			async: true,
			data: {
				userId: sessionUser.user_id,
				userPw: sessionUser.user_pw
			},
			success: function (result) {
				if (result == -1) {
					$("#errMsg").html("세션 새로고침에 실패하였습니다.");
					$("#errorModal").modal("show");
					setTimeout(function(){
						$("#errorModal").modal("hide");
					}, 2000);
					// alert("세션 새로고침에 실패하였습니다.");
				}

			},
			error: function (request, status, error) {
				console.log("에러코드:" + request.status + "\n" + "에러: " + errorThrown);
				$("#errMsg").html("오류가 발생하였습니다.<br/>" + "에러: " + errorThrown);
				$("#errorModal").modal("show");
				setTimeout(function(){
					$("#errorModal").modal("hide");
				}, 2000);
			}
		});
	}
	// 세션 userInfo 조회
	function getUserInfo(fn) {
		$.ajax({
			url: "/getUserInfo.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			success: function (result) {
				fn(result);
			}
		});
	}
	function setSession(result) {
		sessionUser = result;
	}

	//날짜포멧 변경
	Date.prototype.format = function (f) {
		if (!this.valueOf()) return " ";

		var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
		var d = this;

		return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
			switch ($1) {
				case "yyyy":
					return d.getFullYear();
				case "yy":
					return (d.getFullYear() % 1000).zf(2);
				case "MM":
					return (d.getMonth() + 1).zf(2);
				case "dd":
					return d.getDate().zf(2);
				case "E":
					return weekName[d.getDay()];
				case "HH":
					return d.getHours().zf(2);
				case "hh":
					return ((h = d.getHours() % 12) ? h : 12).zf(2);
				case "HH":
					return (d.getHours()).zf(2);
				case "mm":
					return d.getMinutes().zf(2);
				case "ss":
					return d.getSeconds().zf(2);
				case "a/p":
					return d.getHours() < 12 ? '<spring:message code="ewp.utils.am" />' : '<spring:message code="ewp.utils.pm" />';
				default:
					return $1;
			}
		});
	};

	String.prototype.string = function (len) {
		var s = '', i = 0;
		while (i++ < len) {
			s += this;
		}
		return s;
	};
	String.prototype.zf = function (len) {
		return "0".string(len - this.length) + this;
	};
	Number.prototype.zf = function (len) {
		return this.toString().zf(len);
	};
</script>