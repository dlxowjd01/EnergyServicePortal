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
		<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
			<title>S-POWER iDERMS</title>
		</c:when>
		<c:when test="${fn:contains(pageContext.request.serverName, 'wpsolar')}">
			<title>Wpsolar iDERMS</title>
		</c:when>
		<c:otherwise>
			<title>Encored iDERMS</title>
		</c:otherwise>
	</c:choose>

	<link rel="stylesheet" href="/css/bootstrap.min.css">
	<link rel="stylesheet" href="/css/custom-grid.min.css">
	<link rel="stylesheet" href="/css/custom-login.min.css">

	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="/js/jquery-ui-1.12.1.min.js"></script>
	<script type="text/javascript" src="/js/commonDropdown.js"></script>

	<script type="text/javascript">
		const oid = '${oid}';
		const apiHost = '${apiHost}';
		const replaceChar = /[^0-9]/gi;
		const replaceNotFullKorean = /[ㄱ-ㅎㅏ-ㅣ0-9]/gi;
		const message = '${msg}';

		$(document).ready(function () {
			//핸드폰 번호
			$("#findIdMobileNum, #findIdCode, #findPwdMobileNum, #findPwdCode").on('focusout', function() {
				let x = $(this).val();
				if (x.length > 0) {
					if (x.match(replaceChar)) {
						x = x.replace(replaceChar, '');
					}
					$(this).val(x);
				}
			}).on('keyup', function() {
				$(this).val($(this).val().replace(replaceChar, ''));
			});

			//회원명 이름
			$('#findIdlName, #findPwdCode').on('focusout', function() {
				let x = $(this).val();
				if (x.length > 0) {
					if (x.match(replaceNotFullKorean)) {
						x = x.replace(replaceNotFullKorean, '');
					}
					$(this).val(x);
				}
			}).on('keyup', function() {
				$(this).val($(this).val().replace(replaceNotFullKorean, ''));
			});

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

			<c:choose>
				<c:when test="${fn:contains(pageContext.request.serverName, 'wpsolar')}">
					changeFavicon('/resources/favicon_wpsolar.ico');
				</c:when>
				<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
					changeFavicon('/resources/favicon.ico');
				</c:when>
				<c:otherwise>
					changeFavicon('/resources/favicon_encored.ico');
				</c:otherwise>
			</c:choose>

			$("#loginUserId").val("");
			$("#loginUserPw").val("");
			$("#loginBtn").prop("disabled", true);

			$("#loginUserId").bind("change keypress", function(){
				if(!isEmpty($("#loginUserPw").val())){
					$("#loginBtn").prop("disabled", false);
				}
			});
			$("#loginUserId").bind("change keyup", function(){
				$(this).val($(this).val().replace(/\s/g, ''));
			});

			$("#loginUserPw").bind("change keypress", function(){
				if(!isEmpty($("#loginUserId").val())){
					$("#loginBtn").prop("disabled", false);
				}
			});
			$("#loginUserPw").bind("change keyup", function(){
				$(this).val($(this).val().replace(/\s/g, ''));
			});

			// User input event
			$("#newId").on('keydown', function() {
				$(this).val($(this).val().replace(/\s/g, ''));
			});

			$("#newId").on('input', function() {
				$("#validId").addClass("hidden");
			});

			$("#newId").on('keyup', function() {
				let warning = $("#newId").parents().closest(".row").find(".warning");

				if( $(this).val().match(/[^\x00-\x80]/) ){
					$(this).val("");
				}

				if( $(this).val().match(/[^\w-_]/) ) {
					warning.eq(2).removeClass("hidden");
				} else {
					warning.eq(2).addClass("hidden");
				}

				if( $(this).val().length <= 4 || $(this).val().length > 15) {
					warning.eq(1).removeClass("hidden");
				} else {
					warning.eq(1).addClass("hidden");
				}

				if( warning.not(".hidden").index() == -1 ){
					$("#newId").parent().next().prop("disabled", false);
				} else {
					$("#newId").parent().next().prop("disabled", true);
				}
			});

			// validation
			$("#newUserPwd").on('keyup', validatePassword);

			$("#confirmNewPwd").keyup(function() {
				let password = $("#newUserPwd").val();
				password == $(this).val() ? $("#pwdMatched").addClass("hidden") : $("#pwdMatched").removeClass("hidden");
				let validated = $("#pwdMatched").hasClass("hidden");
				if( $(".tick:not(.checked)").index() == -1 && validated){

				}
			});

			$('#findPwdId, #newPwd, #verifyNewPwd, #rtuSecretKey').on('focusout keyup', function() {
				let validated = $('#newPwdMatched').hasClass('hidden');
				if(!isEmpty($('#findPwdId').val()) && !isEmpty($('#newPwd').val())
					&& !isEmpty($('#verifyNewPwd').val()) && !isEmpty($('#rtuSecretKey').val())
					&& $('#changePwdModal').find(".tick:not(.checked)").index() == -1 && validated) {
					$("#updatePwdBtn").removeClass("disabled");
					$("#updatePwdBtn").prop("disabled", false);
				} else {
					$("#updatePwdBtn").addClass("disabled");
					$("#updatePwdBtn").prop("disabled", true);
				}
			});

			//아이디 찾기
			$('#findIdName, #findIdSecret').on('focusout keyup', function() {
				if (!isEmpty($('#findIdName').val()) && !isEmpty($('#findIdSecret').val())) {
					$("#findIdBtn").removeClass("disabled").prop("disabled", false);
				} else {
					$("#findIdBtn").addClass("disabled").prop("disabled", true)
				}
			});

			//비밀번호 변경 팝업
			$('#updatePwdBtn').on('click', function(){
				$.ajax({
					url: apiHost + '/config/users/change_password',
					type: 'patch',
					dataType: 'json',
					contentType: 'application/json',
					data: JSON.stringify({
						oid: oid,
						login_id: $('#findPwdId').val(),
						verify_code: $('#rtuSecretKey').val(),
						new_password: $('#newPwd').val(),
					})
				}).done((json, textStatus, jqXHR) => {
					$('#changePwdModal').modal('hide');
					let showText = '';
					if (json.count == 1) {
						showText = '변경이 완료되었습니다.';
					} else {
						showText = '변경된 내역이 없습니다.';
					}
					alertMsg(showText);
				}).fail((jqXHR, textStatus, errorThrown) => {
					$('#changePwdModal').modal('hide');
					alertMsg(textStatus);
				});
			});

			//아이디 찾기
			$('#findIdBtn').on('click', function(){
				$.ajax({
					url: apiHost + '/config/users/find/login_id',
					type: 'get',
					data: {
						oid: oid,
						name: $('#findIdName').val(),
						verify_code: $('#findIdSecret').val()
					}
				}).done((json, textStatus, jqXHR) => {
					$('#findIdModal').modal('hide');
					let showText = '';
					if (json.length > 0) {
						if (json.length > 1) {
							showText = json.join('<br/>');
						} else {
							showText = json[0];
						}
					} else {
						showText = '검색 된 아이디가 없습니다.';
					}
					alertMsg(showText);
				}).fail((jqXHR, textStatus, errorThrown) => {
					$('#findIdModal').modal('hide');
					alertMsg(textStatus);
				});
			});

			$("#newPwd").on('keyup', function() {
				const rules = [
					{
						Pattern: "[a-zA-Z]",
						Target: "newPwdHasLetter"
					},
					{
						Pattern: "[0-9]",
						Target: "newPwdHasNumber"
					},
					// {
					// Pattern: "[!@@#$%^&*]",
					// Target: "newPwdHasSymbols"
					// }
				];

				let password = $(this).val();
				password.length >= 8 ? $("#newPwdIsEightCharLong").addClass("checked") : $("#newPwdIsEightCharLong").removeClass("checked");

				for (var i = 0; i < rules.length; i++) {
					if( new RegExp(rules[i].Pattern).test(password) ) {
						$("#" + rules[i].Target).addClass("checked")
					} else {
						$("#" + rules[i].Target).removeClass("checked")
					}
				}
			});

			$("#verifyNewPwd").keyup(function() {
				let password = $("#newPwd").val();
				password == $(this).val() ? $("#newPwdMatched").addClass("hidden") : $("#newPwdMatched").removeClass("hidden");
				let validated = $("#newPwdMatched").hasClass("hidden");
				if( $('#changePwdModal').find(".tick:not(.checked)").index() == -1 && validated) {
					$("#updatePwdBtn").removeClass("disabled");
					$("#updatePwdBtn").prop("disabled", false);
				}
			});

			$('#loginForm').on("submit", function(e) {
				e.preventDefault();

				if ($('#loginForm').find('.input-field').eq(2).hasClass('hidden')) {
					$.ajax({
						url: '/loginUser.do',
						type: 'post',
						async: false,
						data: $('#loginForm').serialize()
					}).done(function (json, textStatus, jqXHR) {
						if (isEmpty(json.rtnUrl)) {
							location.reload();
						} else {
							if (json.rtnUrl === 'verify') {
								$('#loginForm').find('.input-field').eq(2).removeClass('hidden');
							} else {
								location.href = json.rtnUrl;
							}
						}
					}).fail(function (jqXHR, textStatus, errorThrown) {
						console.error(textStatus);
					});
				} else {
					$.ajax({
						url: '/twoFactorAuth.do',
						type: 'post',
						async: false,
						data: $('#loginForm').serialize()
					}).done(function (json, textStatus, jqXHR) {
						if (isEmpty(json.rtnUrl)) {
							location.reload();
						} else {
							location.href = json.rtnUrl;
						}
					}).fail(function (jqXHR, textStatus, errorThrown) {
						console.error(textStatus);
					});
				}
			});

			// Modal event
			$("#signUpModal, #findIdModal, #changePwdModal").on("hide.bs.modal", function(){
				initModal(this);
			});

			<c:if test="${not empty msg}">
			alertMsg(message);
			</c:if>
		});

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

		// function showPwd(inputId, btn) {
		// 	var target = document.getElementById(inputId);
		// 	if (target.type === "password") {
		// 		target.type = "text";
		// 		btn.classList.add("eye-close");
		// 	} else {
		// 		target.type = "password";
		// 		btn.classList.remove("eye-close");
		// 	}
		// }

		function openUserModal(option) {
			const modal = $('#' + option);
			modal.modal("show");
		}

		function validatePassword() {
			const rules = [
				{
					Pattern: "[a-zA-Z]",
					Target: "hasLetter"
				},
				{
					Pattern: "[0-9]",
					Target: "hasNumber"
				},
				// {
				// 	Pattern: "[!@@#$%^&*]",
				// 	Target: "Symbols"
				// }
			];

			let password = $(this).val();
			password.length >= 8 ? $("#eightCharLong").addClass("checked") : $("#eightCharLong").removeClass("checked");

			for (let i = 0; i < rules.length; i++) {
				if( new RegExp(rules[i].Pattern).test(password) ) {
					$("#" + rules[i].Target).addClass("checked")
				} else {
					$("#" + rules[i].Target).removeClass("checked")
				}
			}

		}

		function initModal(self) {
			let txtInput = $(self).find("input:text");
			let txtInputPs = $(self).find("input:password");
			let radioInput = $(self).find("input:radio");
			let btn = $(self).find(".btn-wrap-type02 button");
			txtInput.val('');
			txtInputPs.val('');
			radioInput.prop("checked", false);
			btn.prop("disabled", false);

			if($(self).is('#signUpModal')){
				let checkBox = $(self).find("input:checkbox");
				let tick = $(self).find(".tick");
				let txtArea = $(self).find("textarea");
				txtArea.val("");
				checkBox.prop("checked", false);
				tick.each(function(){
					if($(this).is(".checked")){
						$(this).removeClass("checked");
					}
				});
			}
		}


		function checkId(userInput){
			if(isEmpty(userInput)) return false;
			let id = userInput.toString();
			let checkIdOpt = {
				// apiHost 직접 입력???
				url: apiHost + "/config/users/exist?oid=" + oid + '&login_id=' + id,
				type: "get",
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
					$("#invalidId").addClass("hidden");
					$("#validId").addClass("hidden");
				},
			}
			$.ajax(checkIdOpt).done(function (json, textStatus, jqXHR) {
				$("#validId").removeClass("hidden");
				validateForm();
			}).fail(function (jqXHR, textStatus, errorThrown) {
				if(jqXHR.status == 409){
					console.log(jqXHR);
					$("#invalidId").removeClass("hidden");
					setTimeout(function(){
						$("#invalidId").addClass("hidden");
					}, 2000);
				}
				return false;
			});
		}

		function validateForm(){
			if( !$("#validId").hasClass("hidden") && ( $("#updateUserForm .tick:not('.checked')").index() == -1 ) && ( $(".warning:not(.hidden)").index() == -1 ) && ( !isEmpty($("#newFullName").val() ) ) && ( !isEmpty($("#newEmailAddr").val()) )){
				$("#addUserBtn").prop("disabled", false);
				return 1;
			}
		}

		function alertMsg(showText) {
			$("#warningMsg").text(showText);
			$("#warningModal").modal("show");
			setTimeout(function(){
				$("#warningModal").modal("hide");
			}, 1800);
		}
	</script>
</head>
<body>
	<div class="container-fluid login">
		<nav class="clear">
			<c:choose>
				<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
					<div class="nav-brand spower"><a href="#">Spower</a></div>
				</c:when>
				<c:when test="${fn:contains(pageContext.request.serverName, 'wpsolar')}">
					<div class="nav-brand wpsolar"><a href="#">WpSolar</a></div>
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
					<c:when test="${fn:contains(pageContext.request.serverName, 'wpsolar')}">
						<img src="../img/logo_wpsolar.svg" alt="login modal wpsolar logo" class="login-logo center"/>
					</c:when>
					<c:otherwise>
						<img src="../img/logo_iderms.svg" alt="login modal iderms logo" class="login-logo center"/>
					</c:otherwise>
				</c:choose>
				<div class="input-field"><input type="text" id="loginUserId" name="login_id" class="clear-input" placeholder=<fmt:message key="ewp.login.ID"/>></div>
				<div class="input-field"><input type="password" id="loginUserPw" name="password" class="clear-input" placeholder=<fmt:message key="ewp.login.Password"/>>
<%--					<button type="button" class="clear-btn" onclick="showPwd( 'loginUserPw', this)">show</button>--%> <%-- 일부 브라우져 오작동으로 주석 --%>
				</div>
				<div class="input-field hidden"><input type="password" id="verify_code" name="verify_code" class="clear-input" placeholder="인증번호"></div>
				<div class="input-field no-border"><a class="chk-type"><input type="checkbox" id="saveLogin" name="save_login"><label for="saveLogin">로그인 유지</label></a></div>

				<div class="btn-wrapper">
					<input type="submit" id="loginBtn" name="login" value="<fmt:message key="ewp.login.Signin" />">
					<c:choose>
						<c:when test="${defaultOid eq 'testkpx'}">
							<p class="center"><!--
							--><a href="#" onclick="openUserModal('findIdModal'); return false;">아이디 찾기</a><!--
							--><a href="#" onclick="openUserModal('changePwdModal'); return false;">비밀번호 변경</a><!--
						--></p>
						</c:when>
						<c:otherwise>
<%--							<p class="center"><!----%>
<%--							--><a href="#" onclick="openUserModal('signUpModal'); return false;">회원 가입</a><!----%>
<%--							--><a href="#" onclick="openUserModal('findIdModal'); return false;">아이디 찾기</a><!----%>
<%--							--><a href="#" onclick="openUserModal('changePwdModal'); return false;">비밀번호 변경</a><!----%>
<%--						--></p>--%>
						</c:otherwise>
					</c:choose>

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
			<div class="modal-content collect-modal-content">
				<div class="modal-body">
					<h2 id="warningMsg" class="warning"></h2>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="signUpModal" tabindex="-1" role="dialog" aria-labelledby="signUpModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-md">
			<div class="modal-content user-modal-content">
				<div class="modal-header"><h2>회원 가입</h2></div>
				<div class="modal-body">
					<div class="container-fluid">
						<form name="sign_up_form" id="signUpForm" class="user-form">
							<section id="userInfo">
								<div class="row">
									<div class="col-3"><span class="input-label asterisk">아이디</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="text-input-type offset-width">
												<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
											</div>
											<button type="button" class="btn-type03 fr" onclick="checkId($('#newId').val())" disabled>중복 확인</button>
										</div>
										<small class="hidden warning-text">사용자 아이디를 입력해 주세요</small>
										<small class="hidden warning-text">5~15 글자를 입력해 주세요.</small>
										<small class="hidden warning-text">한글, 특수 문자는 포함될 수 없습니다.</small>
										<small id="invalidId" class="hidden warning-text">동일한 아이디가 존재합니다.</small>
										<small id="validId" class="text-blue text-sm hidden">사용 가능한 아이디 입니다.</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">비밀번호</span></div>
									<div class="col-9">
										<div class="text-input-type"><!--
											--><input type="password" id="newUserPwd" name="new_pwd" placeholder="입력" minlength="6" maxlength="32">
											<%--
												<button type="button" class="clear-btn" onclick="showPwd('newUserPwd', this)">show</button>
											--%>
										</div>
										<div class="flex-start warning-wrapper">
											<small id="hasLetter" class="tick">영문</small>
											<small id="hasNumber" class="tick">숫자</small>
											<small id="eightCharLong" class="tick">8자리 이상</small>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">비밀번호 확인</span></div>
									<div class="col-9">
										<div class="text-input-type"><!--
											--><input type="password" id="confirmNewPwd" name="confirm_new_pwd" placeholder="입력" minlength="6" maxlength="32"><!--
										--></div>
										<div class="flex-start warning-wrapper">
											<small id="pwdMatched" class="warning-text hidden">비밀번호가 일치하지 않습니다.</small>
										</div>
									</div>
								</div>

		
								<div class="row">
									<div class="col-3"><span class="input-label asterisk">이름</span></div>
									<div class="col-9">
										<div class="text-input-type"><input type="text" id="newFullName" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
										<small class="hidden warning-text">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">이메일 주소</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="text-input-type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="입력" minlength="3" maxlength="28"></div>
											<div class="dropdown w-174">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newEmailHost" class="dropdown-menu"></ul>
											</div>
										</div>
										<div class="flex-start">
											<small class="hidden warning-text">올바른 이메일 형식을 입력해 주세요.</small>
										</div>
									</div>
								</div>
		
								<div class="row">
									<div class="col-3"><span class="input-label">휴대폰 번호</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="dropdown w-134">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newMobilePrefix" class="dropdown-menu"></ul>
											</div>
											<div class="text-input-type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력" maxlength="13"></div>
											<button type="button" class="btn-type fr">인증</button>
										</div>
										<div class="flex-start">
											<small id="isValidNumC" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label">인증 번호</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="text-input-type w-100"><input type="text" id="code" name="code" placeholder="입력"></div>
											<span class="desc-text"></span>
										</div>
									</div>
								</div>
							</section>

							<section id="termsCondition">
								<div class="row">
									<div class="col-12">
										<h3 class="input-label">이용 약관</h3>
										<textarea name="new_terms" id="newTerms" class="textarea">

										</textarea>
										<div class="input-field no-border right"><a class="chk-type"><input type="checkbox" id="termsInput" name="terms_input"><label for="termsInput"></label></a></div>
									</div>
								</div>

								<div class="row">
									<div class="col-12">
										<h3 class="input-label">개인 정보 수집 및 제공 동의</h3>
										<textarea name="new_consent" id="newConsent" class="textarea"></textarea>
										<div class="input-field no-border right"><a class="chk-type"><input type="checkbox" id="consentInput" name="consent_input"><label for="consentInput"></label></a></div>
									</div>
								</div>
							</section>

							<div class="row">
								<div class="col-12">
									<div class="btn-wrap-type02"><!--
									--><button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="submit" id="signUpBtn" class="btn-type" disabled>등록</button><!--
									--></div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>


	<div class="modal fade" id="findIdModal" tabindex="-1" role="dialog" aria-labelledby="findIdModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-md">
			<div class="modal-content user-modal-content">
				<div class="modal-header"><h2>아이디 찾기</h2></div>
				<div class="modal-body">
					<div class="container-fluid">
						<form name="find_id_form" id="findIdForm" class="user-form">
							<c:choose>
								<c:when test="${defaultOid eq 'testkpx'}">
									<div class="row">
										<div class="col-3"><span class="input-label asterisk">이름</span></div>
										<div class="col-9">
											<div class="text-input-type"><input type="text" id="findIdName" name="find_id_name" placeholder="입력" minlength="3" maxlength="28" autocomplete="off"></div>
											<small class="hidden warning-text">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
										</div>
									</div>
									<div class="row">
										<div class="col-3"><span class="input-label asterisk">RTU 비밀키</span></div>
										<div class="col-9">
											<div class="text-input-type"><input type="text" id="findIdSecret" name="find_id_secret" placeholder="입력" minlength="3" maxlength="28" autocomplete="off"></div>
											<small class="hidden warning-text">RTU 비밀키를 입력해 주세요</small>
										</div>
									</div>
								</c:when>
								<c:otherwise>
									<div class="row">
										<div class="col-3"><span class="input-label asterisk">이름</span></div>
										<div class="col-9">
											<div class="text-input-type"><input type="text" id="findIdName" name="find_id_name" placeholder="입력" minlength="3" maxlength="28" autocomplete="off"></div>
											<small class="hidden warning-text">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
										</div>
									</div>

									<div class="row">
										<div class="col-3"><span class="input-label asterisk">이동 통신사</span></div>
										<div class="col-9">
											<div class="radio-type flex-start">
												<div class="radio-group">
													<input type="radio" id="carrierA" name="carrier_opt" data-value="sk">
													<label for="carrierA">SKT</label>
												</div>
												<div class="radio-group">
													<input type="radio" id="carrierB" name="carrier_opt" data-value="kt">
													<label for="carrierB">KT</label>
												</div>
												<div class="radio-group">
													<input type="radio" id="carrierC" name="carrier_opt" data-value="lg">
													<label for="carrierC">LG U+</label>
												</div>
											</div>
											<div class="flex-start">
												<small class="hidden warning-text">이동 통신사를 선택해 주세요.</small>
											</div>
										</div>
									</div>

									<div class="row">
										<div class="col-3"><span class="input-label">휴대폰 번호</span></div>
										<div class="col-9">
											<div class="flex-start">
												<div class="dropdown w-90" id="findIdMobilePrefix">
													<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
													<ul class="dropdown-menu">
														<li data-value="010"><a href="javascript:void(0);">010</a></li>
														<li data-value="011"><a href="javascript:void(0);">011</a></li>
														<li data-value="016"><a href="javascript:void(0);">016</a></li>
														<li data-value="017"><a href="javascript:void(0);">017</a></li>
														<li data-value="019"><a href="javascript:void(0);">019</a></li>
													</ul>
												</div>
												<div class="text-input-type offset-176"><input type="text" id="findIdMobileNum" name="find_id_mobil_num" placeholder="입력" maxlength="13"></div>
												<button type="button" class="btn-type fr">인증</button>
											</div>
											<div class="flex-start">
												<small id="isValidNumA" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
											</div>
										</div>
									</div>

									<div class="row">
										<div class="col-3"><span class="input-label">인증 번호</span></div>
										<div class="col-9">
											<div class="text-input-type"><input type="text" id="findIdCode" name="find_id_code" placeholder="입력">
											</div>
										</div>
									</div>
								</c:otherwise>
							</c:choose>
							<div class="row">
								<div class="col-12">
									<div class="btn-wrap-type02"><!--
									--><button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="button" id="findIdBtn" class="btn-type" disabled>찾기</button><!--
									--></div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>


	<div class="modal fade" id="changePwdModal" tabindex="-1" role="dialog" aria-labelledby="changePwdModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-md">
			<div class="modal-content user-modal-content">
				<div class="modal-header"><h2>비밀번호 변경</h2></div>
				<div class="modal-body">
					<div class="container-fluid">
						<form name="find_pwd_form" id="findPwdForm" class="user-form">
						<c:choose>
							<c:when test="${defaultOid eq 'testkpx'}">
								<div class="row">
									<div class="col-3"><span class="input-label asterisk">ID</span></div>
									<div class="col-9">
										<div class="text-input-type"><input type="text" id="findPwdId" name="find_pwd_id" placeholder="입력" minlength="3" maxlength="28" autocomplete="off"></div>
										<small class="hidden warning-text">ID를 입력해 주세요</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">RTU 비밀키</span></div>
									<div class="col-9">
										<div class="text-input-type"><input type="text" id="rtuSecretKey" name="rtuSecretKey" placeholder="입력" minlength="3" maxlength="28" autocomplete="off"></div>
										<small class="hidden warning-text">RTU 비밀키를 입력해 주세요</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">신규 비밀번호</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="password" id="newPwd" name="newPwd" placeholder="입력" minlength="8" maxlength="32" autocomplete="off">
												<div class="flex-start warning-wrapper">
													<small class="tick" id="newPwdHasLetter">영문</small>
													<small class="tick" id="newPwdHasNumber">숫자</small>
													<small class="tick" id="newPwdHasSymbol">특수문자</small>
													<small class="tick" id="newPwdIsEightCharLong">8자리 이상</small>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">신규 비밀번호 확인</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="password" id="verifyNewPwd" name="verifyNewPwd" placeholder="입력" minlength="8" maxlength="32" autocomplete="off">
												<div class="flex-start warning-wrapper">
													<small id="newPwdMatched" class="warning-text hidden">비밀번호가 일치하지 않습니다.</small>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-12">
										<div class="btn-wrap-type02"><!--
										--><button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="button" class="btn-type" id="updatePwdBtn" disabled>등록</button><!--
									--></div>
									</div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="row">
									<div class="col-3"><span class="input-label asterisk">이름</span></div>
									<div class="col-9">
										<div class="text-input-type"><input type="text" id="findPwdFullName" name="find_pwd_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
										<small class="hidden warning-text">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">ID</span></div>
									<div class="col-9">
										<div class="text-input-type"><input type="text" id="findPwdId" name="find_pwd_id" placeholder="입력" minlength="3" maxlength="28"></div>
										<small class="hidden warning-text">ID를 입력해 주세요</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label asterisk">이동 통신사</span></div>
									<div class="col-9">
										<div class="radio-type flex-start">
											<div class="radio-group">
												<input type="radio" id="carrierSk" name="carrier_opt2" data-value="sk">
												<label for="carrierSk">SKT</label>
											</div>
											<div class="radio-group">
												<input type="radio" id="carrierKt" name="carrier_opt2" data-value="kt">
												<label for="carrierKt">KT</label>
											</div>
											<div class="radio-group">
												<input type="radio" id="carrierLg" name="carrier_opt2" data-value="lg">
												<label for="carrierLg">LG U+</label>
											</div>
										</div>
										<div class="flex-start">
											<small class="hidden warning-text">이동 통신사를 선택해 주세요.</small>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label">휴대폰 번호</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="dropdown w-90" id="findPwdMobilePrefix">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul class="dropdown-menu">
													<li data-value="010"><a href="javascript:void(0);">010</a></li>
													<li data-value="011"><a href="javascript:void(0);">011</a></li>
													<li data-value="016"><a href="javascript:void(0);">016</a></li>
													<li data-value="017"><a href="javascript:void(0);">017</a></li>
													<li data-value="019"><a href="javascript:void(0);">019</a></li>
												</ul>
											</div>
											<div class="text-input-type offset-176"><input type="text" id="findPwdMobileNum" name="find_pwd_mobil_num" placeholder="입력" maxlength="13"></div>
											<button type="button" class="btn-type fr">인증</button>
										</div>
										<div class="flex-start">
											<small id="isValidNumB" class="warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input-label">인증 번호</span></div>
									<div class="col-9">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="text" id="findPwdCode" name="find_pwd_code" placeholder="입력" minlength="6" maxlength="6">
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-12">
										<div class="btn-wrap-type02"><!--
										--><button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="button" class="btn-type" id="updatePwdBtn" disabled>변경</button><!--
									--></div>
									</div>
								</div>
							</c:otherwise>
						</c:choose>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
