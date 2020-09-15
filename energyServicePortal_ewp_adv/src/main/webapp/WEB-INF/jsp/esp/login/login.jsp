<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cookieLang" value="${fn:toUpperCase(cookie['lang'].value)}"/>
<c:if test="${cookieLang eq null or empty cookieLang}">
	<c:set var="cookieLang" value="KO"/>
</c:if>

<fmt:setLocale value="${cookieLang}"/>
<fmt:setBundle basename="kr.co.esp.message.com.message-common" />

<!DOCTYPE html>
<html lang="${cookieLang}" class="darkmode">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
	<c:choose>
		<c:when test="${pageContext.request.serverName eq 'spower.iderms.ai'}">
			<title>S-POWER iDERMS</title>
		</c:when>
		<c:otherwise>
			<title>Encored iDERMS</title>
		</c:otherwise>
	</c:choose>

	<link rel="stylesheet" href="/css/bootstrap.min.css">
	<link rel="stylesheet" href="/css/custom-grid.min.css">
	<link rel="stylesheet" href="/css/custom-login.css">

	<script src="/js/jquery.min.js"></script>
	<script src="/js/bootstrap.min.js"></script>
	<script src="/js/jquery-ui-1.12.1.min.js"></script>
</head>
<body>
	<div class="container-fluid login">
		<nav class="clear">
			<c:choose>
				<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
					<div class="nav-brand spower"><a href="#">Spower</a></div>
				</c:when>
				<c:otherwise>
					<div class="nav-brand"><a href="#">Encored</a></div>
				</c:otherwise>
			</c:choose>
			<%@ include file="/decorators/include/selectLang.jsp" %>
		</nav>
		<form action="/loginUser.do" method="post" name="loginForm" id="loginForm" class="login-form">
			<input type="hidden" id="language" name="language" value="${cookieLang}"/>
			<div class="inner-wrapper">
				<c:choose>
					<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
						<img src="../img/logo_login_spower.svg" alt="login modal spower logo" class="login-logo center"/>
					</c:when>
					<c:otherwise>
						<img src="../img/logo_iderms.svg" alt="login modal iderms logo" class="login-logo center"/>
					</c:otherwise>
				</c:choose>
				<div class="input-field"><input type="text" id="loginUserId" name="login_id" class="clear-input" placeholder=<fmt:message key="ewp.login.ID"/>></div>
				<div class="input-field"><input type="password" id="loginUserPw" name="password" class="clear-input" placeholder=<fmt:message key="ewp.login.Password"/>><button type="button" class="clear-btn" onclick="showPwd( 'loginUserPw', this)">show</button></div>
				<div class="input-field no-border"><a class="chk_type"><input type="checkbox" id="saveLogin" name="save_login"><label for="saveLogin">로그인 유지</label></a></div>

				<div class="btn-wrapper">
					<input type="submit" id="loginBtn" name="login" value="<fmt:message key="ewp.login.Signin" />">
					<p class="center">회원 가입 및 회원 정보 문의<strong class="bold">070-4949-5500</strong></p>
				</div>

				<%-- KPX(전력 거래소 사용시 하단 내용 숨김) --%>
				<c:if test="${defaultOid ne 'testkpx'}">
				<div class="desc">
					<div class="row center">
						<div class="col-6">
							<h3 class="mb-10">카카오톡 문의</h3>
							<a href="http://pf.kakao.com/_YDihK" target="_blank"><strong class="link-bold">아이덤스</strong> 채널&amp;친구 추가</a>
						</div>
						<div class="col-6 divider">
							<h3 class="mb-10">데모 요청 이메일</h3>
							<a href="javascript:void(0)" class="link-bold">esolution@encoredtech.com</a>
							<!-- <a href="#" target="_blank" class="link-bold">esolution@encoredtech.com</a> -->
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<p class="center copy-right">COPYRIGHT © 2019-2020 Encored Technologies, Inc. All rights reserved.</p>
						</div>
					</div>
				</div>
				</c:if>
			</div>
		
		</form>
	</div>

	<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-sm">
			<div class="modal-content collection_modal_content">
				<div class="modal-body">
					<h2 id="warningMsg" class="warning"></h2>
				</div>
			</div>
		</div>
	</div>

	<c:if test="${not empty msg}">
		<script type="text/javascript">
			let message = '${msg}'
			$("#warningMsg").text(message);
			$("#warningModal").modal("show");
			setTimeout(function(){
				$("#warningModal").modal("hide");
			}, 1800);
		</script>
	</c:if>

	<script type="text/javascript">
		$(document).ready(function () {

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

			<c:if test="${!fn:contains(pageContext.request.serverName, 'spower')}">
			changeFavicon('/resources/favicon_encored.ico');
			</c:if>

			$("#loginUserId").val("");
			$("#loginUserPw").val("");

			$("#loginBtn").prop("disabled", true);

			$("#loginUserId").bind("change keypress", function(){
				if(!isEmpty($("#loginUserPw").val())){
					$("#loginBtn").prop("disabled", false);
				}
			});

			$("#loginUserPw").bind("change keypress", function(){
				if(!isEmpty($("#loginUserId").val())){
					$("#loginBtn").prop("disabled", false);
				}
			});

		})

		// TO KEEP!!! (signUP)
		// function checkLogin(self){
			// let id = document.getElementById('loginUserId');
			// let pwd = document.getElementById('loginUserPw');
			// let modal = $("#warningModal");

			// if (isEmpty(id.value) ) {
			// 	let msg = '<fmt:message key="ewp.login.Singup_ID" />'
			// 	$("#warningMsg").text(msg);
			// 	modal.modal("show");
			// 	setTimeout(function(){
			// 		modal.modal("hide");
			// 	}, 1800);
			// 	id.focus();
			// 	loading.hide();
			// 	return false;
			// }
			// if ( isEmpty(pwd.value) ) {
			// 	let msg = '<fmt:message key="ewp.login.Singup_PW" />'
			// 	$("#warningMsg").text(msg);
			// 	modal.modal("show");
			// 	setTimeout(function(){
			// 		modal.modal("hide");
			// 	}, 1800);

			// 	pwd.focus();
			// 	loading.hide();
			// 	return false;
			// }

		// 	return true;
		// }

		function isEmpty (value) {
			if (value === "" || value === null || value === undefined || (value !== null && typeof value === "object" && !Object.keys(value).length)) {
				return true;
			} else {
				return false;
			}
		}

		function addParameterUrl(v) {
			document.cookie = 'lang' + '=' + v + '; path=/';

			const f = document.loginForm;
			document.getElementById('language').value = v;
			f.method = "post";
			f.action = "/login.do";
			f.submit();
		}

		function showPwd(inputId, btn) {
			var target = document.getElementById(inputId);
			if (target.type === "password") {
				target.type = "text";
				btn.classList.add("eye-close");
			} else {
				target.type = "password";
				btn.classList.remove("eye-close");
			}
		}
	</script>
</body>
</html>
