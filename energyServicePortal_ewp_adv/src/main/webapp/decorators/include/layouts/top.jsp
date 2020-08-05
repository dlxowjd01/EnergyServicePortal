<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
	<meta name="format-detection" content="telephone=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
	<c:choose>
		<c:when test="${pageContext.request.serverName eq 'spower.iderms.ai' or pageContext.request.serverName eq '13.114.199.169' or pageContext.request.serverName eq 'localhost'}">
			<title>S-POWER iDERMS</title>
		</c:when>
		<c:otherwise>
			<title>Encored iDERMS</title>
		</c:otherwise>
	</c:choose>
	
	<link rel="stylesheet" href="/css/bootstrap.min.css">
	<%--
	<link rel="stylesheet" href="/css/font-awesome.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
	<link href="https://fonts.googleapis.com/css?family=Nanum+Gothic:400" rel="stylesheet">
	--%>

	<link rel="stylesheet" href="/css/custom.css">
	<link rel="stylesheet" href="/css/custom-grid.min.css">
	<link rel="stylesheet" href="/css/custom-mquery.css">
	<link rel="stylesheet" type="text/css" media="all" href="/css/jquery-ui.css">
	<link rel="stylesheet" type="text/css" media="all" href="/css/wickedpicker.css">
	<!-- dataTables (work in progress) -->
	<link rel="stylesheet" type="text/css" href="/css/data_tables/default.css"/>
<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
		<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	<![endif]-->
	<script src="/js/jquery.min.js"></script>
	<script src="/js/jquery.blockUI.js"></script>
	<script src="/js/jquery-ui.js"></script>
	<script src="/js/jquery-ui-1.12.1.min.js"></script>
	<script src="/js/bootstrap.min.js"></script>
	<!-- high-chart -->
	<script src="/js/highcharts.js"></script>
	<script src="/js/modules/variwide.js"></script>
	<script src="/js/modules/data.js"></script>
	<script src="/js/modules/exporting.js"></script>
	<script src="/js/modules/export-data.js"></script>  
	<!-- 텝메뉴 용 -->
	<script src="/js/sectionDisplay.js"></script>
	<script src="/js/common.js"></script>

	<%--
	<script src="/js/jquery.bxslider.js" type="text/javascript"></script>
	<c:set var="timeOffset"><spring:eval expression="@local.getProperty('server.offset')" /></c:set>
	--%>
	<script src="/js/custom/common.js"></script>
	<!-- START: 현재 안씀 - 확인 필요 -->
	<!-- <script src="/js/custom/lems.js"></script>
	<script src="/js/custom/searchRequirement.js"></script> -->
	<!-- END -->
	<script src="/js/custom/utils.js"></script>
	<script src="/js/custom/numberFormat.js"></script>

	<script src="/js/html2canvas.js"></script>
	<!-- START: 현재 안씀 - 확인 필요 -->
	<!-- <script src="/js/jspdf.min.js"></script> -->
	<!-- END -->
	<!-- print preview -->
	<!-- <script src="/js/printPreview.js"></script> -->
	<!-- <script src="/js/printThis.js"></script> -->

	<!-- 다크 모드 지원 -->
	<!-- <script src="/js/custom/theme.js"></script> -->
	<!-- 화면 엑셀 다운로드용 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>

	<!-- timepicker -->
	<script type="text/javascript" src="/js/wickedpicker.js"></script>
	<script src="/js/data_tables/default.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/buttons.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/col_reorder.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/pdf_make.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/vfs_fonts_kr.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/select.js" type="text/javascript"></script>

	<script>
		// role: 1: 시스템관리자, 2: 일반
		const role = '${userInfo.role}';
		// task : 0: 일반, 1:사무수탁, 2:자산운용, 3:사업주
		const task = '${userInfo.task}';
		const oid = '${userInfo.oid}';
		const loginId = '${userInfo.login_id}';
		const loginName = '${sessionScope.userInfo.name}';
		const loginMail = '${sessionScope.userInfo.contact_email}';
		const contact_phone = '${sessionScope.userInfo.contact_phone}';


		let pagePerData = 15; //페이지당 게시글 갯수
		const navCount = 10; //한 화면당 네비게이션 갯수
		let page = 1; //현재 페이지

		const apiHost = '${sessionScope.apiHost}';

		//API 토큰 세팅
		$.ajaxSetup({
			headers: {'Authorization': 'Bearer <c:out value="${sessionScope.userInfo.token}" escapeXml="false" />'}
		});

		var timeOffset = '${timeOffset}';
		$(document).ready(function () {
			<c:if test="${!fn:contains(pageContext.request.serverName, 'spower')}">
				changeFavicon('/img/logo-only.ico');
			</c:if>

			<%--sessionUser = JSON.stringify(${userInfo});--%>
			// getUserInfo(setSession);
			// var authType = sessionUser.auth_type;
			// if (authType == '1') {
			// 	sessionRefresh();
			// 	setInterval(function () {
			// 		sessionRefresh();
			// 	}, 1000 * 60 * 50); // 1000 = 1초, 1000*60 = 1분
			// }
			$('.loading').hide();
		});

		const changeFavicon = link => {
			let $favicon = document.querySelector('link[rel="icon"]')
			// If a <link rel="icon"> element already exists,
			// change its href to the given link.
			if ($favicon !== null) {
				$favicon.href = link
				// Otherwise, create a new element and append it to <head>.
			} else {
				$favicon = document.createElement("link")
				$favicon.rel = "icon"
				$favicon.href = link
				document.head.appendChild($favicon)
			}
		};

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
						alert("세션 새로고침에 실패하였습니다.");
					}

				},
				error: function (request, status, error) {
//		 			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
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
	 
		var sessionUser = null;
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