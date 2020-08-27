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

	<link rel="stylesheet" href="/css/custom.css">
	<link rel="stylesheet" href="/css/custom-grid.min.css">
	<link rel="stylesheet" href="/css/custom-mquery.css">
	<link rel="stylesheet" type="text/css" media="all" href="/css/jquery-ui.css">
	<link rel="stylesheet" type="text/css" media="all" href="/css/wickedpicker.css">

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

	<script src="/js/custom/common.js"></script>

	<script src="/js/custom/utils.js"></script>
	<script src="/js/custom/numberFormat.js"></script>

	<script src="/js/html2canvas.js"></script>

	<!-- 화면 엑셀 다운로드용 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>

	<!-- timepicker -->
	<script type="text/javascript" src="/js/wickedpicker.js"></script>
	<script src="/js/data_tables/default.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/responsive.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/buttons.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/col_reorder.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/pdf_make.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/jszip.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/vfs_fonts_kr.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/select.js" type="text/javascript"></script>
	<script src="/js/data_tables/extensions/fixed_header.js" type="text/javascript"></script>

	<script>
		// role: 1: 시스템관리자, 2: 일반
		const role = '${sessionScope.userInfo.role}';
		// task : 0: 일반, 1:사무수탁, 2:자산운용, 3:출금관리 4:사업주
		const task = '${sessionScope.userInfo.task}';
		const oid = '${sessionScope.userInfo.oid}';
		const loginId = '${sessionScope.userInfo.login_id}';
		const userInfoId = '${sessionScope.userInfo.uid}';
		const loginName = '${sessionScope.userInfo.name}';
		const loginMail = '${sessionScope.userInfo.contact_email}';
		const contact_phone = '${sessionScope.userInfo.contact_phone}';
		const apiHost = '${sessionScope.apiHost}';
		const navCount = 10; //한 화면당 네비게이션 갯수
		let pagePerData = 15; //페이지당 게시글 갯수
		let page = 1; //현재 페이지
		var timeOffset = '${timeOffset}';
		var sessionUser = null;

		const changeFavicon = link => {
			let $favicon = document.querySelector('link[rel="icon"]') || document.createElement('link');
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
			<c:if test="${!fn:contains(pageContext.request.serverName, 'spower')}">
				changeFavicon('/resources/favicon_encored.ico');
			</c:if>

			$('#loadingCircle').hide();

			$(window).resize(function() {
				if ($(window).width() > 768) {
					$('#mask').hide();
					$('body').removeClass("sidenav-no-scroll");
					$('#mobileNav').hide();
				}
			});

		});

		//API 토큰 세팅
		$.ajaxSetup({
			headers: {'Authorization': 'Bearer <c:out value="${sessionScope.userInfo.token}" escapeXml="false" />'},
			"timeout": 30000
		});

		$(document).ajaxSuccess(function() {
			$('#loadingCircle').hide();
		});

		$(document).ajaxError(function(event, jqxhr, settings, thrownError) {
			$('#loadingCircle').hide();
			// test 용 주석 유지 (~ 9월 말까지)
			// let r = JSON.parse(jqxhr.responseText);
			// console.log("에러코드:" + jqxhr.status + "\n" + "메세지: " + r);
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
						$("#errMsg").text("세션 새로고침에 실패하였습니다.");
						$("#errorModal").modal("show");
						setTimeout(function(){
							$("#errorModal").modal("hide");
						}, 2000);
						// alert("세션 새로고침에 실패하였습니다.");
					}

				},
				error: function (request, status, error) {
					// alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
					let r = JSON.parse(jqxhr.responseText);
					console.log("에러코드:" + request.status + "\n" + "메세지: " + r);
					$("#errMsg").text("오류가 발생하였습니다. \n" + r);
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