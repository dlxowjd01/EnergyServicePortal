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
				<%--
					<p class="center"><!--
					--><a href="#" onclick="openUserModal('signUpModal')">회원 가입</a><!--
					--><a href="#" onclick="openUserModal('findIdModal')">아이디 찾기</a><!--
					--><a href="#" onclick="openUserModal('findPwdModal')">비밀번호 찾기</a><!--
					--></p>
				--%>
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

	<div class="modal fade" id="signUpModal" tabindex="-1" role="dialog" aria-labelledby="signUpModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-md">
			<div class="modal-content user-modal-content">
				<div class="modal-header"><h2>회원 가입</h2></div>
				<div class="modal-body">
					<div class="container-fluid">
						<form name="sign_up_form" id="signUpForm" class="user-form">
							<section id="userInfo">
								<div class="row">
									<div class="col-3"><span class="input_label asterisk">아이디</span></div>
									<div class="col-9">
										<div class="flex_start">
											<div class="tx_inp_type offset-width">
												<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
											</div>
											<button type="button" class="btn_type03 fr" onclick="checkId($('#newId').val())" disabled>중복 확인</button>
										</div>
										<small class="hidden warning-text">사용자 아이디를 입력해 주세요</small>
										<small class="hidden warning-text">5~15 글자를 입력해 주세요.</small>
										<small class="hidden warning-text">한글, 특수 문자는 포함될 수 없습니다.</small>
										<small id="invalidId" class="hidden warning-text">동일한 아이디가 존재합니다.</small>
										<small id="validId" class="text-blue text-sm hidden">사용 가능한 아이디 입니다.</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input_label asterisk">비밀번호</span></div>
									<div class="col-9">
										<div class="tx_inp_type"><!--
											--><input type="password" id="newUserPwd" name="new_pwd" placeholder="입력" minlength="6" maxlength="32"><!--
											--><button type="button" class="clear-btn" onclick="showPwd('newUserPwd', this)">show</button><!--
										--></div>
										<div class="flex_start warning-wrapper">
											<small id="hasLetter" class="tick">영문</small>
											<small id="hasNumber" class="tick">숫자</small>
											<small id="isSixCharLong" class="tick">6자리 이상</small>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input_label asterisk">비밀번호 확인</span></div>
									<div class="col-9">
										<div class="tx_inp_type"><!--
											--><input type="password" id="confirmNewPwd" name="confirm_new_pwd" placeholder="입력" minlength="6" maxlength="32"><!--
										--></div>
										<div class="flex_start warning-wrapper">
											<small id="pwdMatched" class="warning-text hidden">비밀번호가 일치하지 않습니다.</small>
										</div>
									</div>
								</div>

		
								<div class="row">
									<div class="col-3"><span class="input_label asterisk">이름</span></div>
									<div class="col-9">
										<div class="tx_inp_type"><input type="text" id="newFullName" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
										<small class="hidden warning-text">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input_label asterisk">이메일 주소</span></div>
									<div class="col-9">
										<div class="flex_start">
											<div class="tx_inp_type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="입력" minlength="3" maxlength="28"></div>
											<div class="dropdown w-174">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newEmailHost" class="dropdown-menu"></ul>
											</div>										
										</div>
										<div class="flex_start">
											<small class="hidden warning-text">올바른 이메일 형식을 입력해 주세요.</small>
										</div>
									</div>
								</div>
		
								<div class="row">
									<div class="col-3"><span class="input_label">휴대폰 번호</span></div>
									<div class="col-9">
										<div class="flex_start">
											<div class="dropdown w-134">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newMobilePrefix" class="dropdown-menu"></ul>
											</div>
											<div class="tx_inp_type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력" maxlength="13"></div>
											<button type="button" class="btn_type fr">인증</button>
										</div>
										<div class="flex_start">
											<small id="isValidNumC" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input_label">인증 번호</span></div>
									<div class="col-9">
										<div class="flex_start">
											<div class="tx_inp_type w-100"><input type="text" id="code" name="code" placeholder="입력"></div>
											<span class="desc-text"></span>
										</div>
									</div>
								</div>
							</section>

							<section id="termsCondition">
								<div class="row">
									<div class="col-12">
										<h3 class="input_label">이용 약관</h3>
										<textarea name="new_terms" id="newTerms" class="textarea">

										</textarea>
										<div class="input-field no-border right"><a class="chk_type"><input type="checkbox" id="termsInput" name="terms_input"><label for="termsInput"></label></a></div>
									</div>
								</div>

								<div class="row">
									<div class="col-12">
										<h3 class="input_label">개인 정보 수집 및 제공 동의</h3>
										<textarea name="new_consent" id="newConsent" class="textarea"></textarea>
										<div class="input-field no-border right"><a class="chk_type"><input type="checkbox" id="consentInput" name="consent_input"><label for="consentInput"></label></a></div>
									</div>
								</div>
							</section>

							<div class="row">
								<div class="col-12">
									<div class="btn_wrap_type02"><!--
									--><button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="submit" id="signUpBtn" class="btn_type" disabled>등록</button><!--
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
							<div class="row">
								<div class="col-3"><span class="input_label asterisk">이름</span></div>
								<div class="col-9">
									<div class="tx_inp_type"><input type="text" id="findIdlName" name="find_id_name" placeholder="입력" minlength="3" maxlength="28"></div>
									<small class="hidden warning-text">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
								</div>
							</div>

							<div class="row">
								<div class="col-3"><span class="input_label asterisk">이동 통신사</span></div>
								<div class="col-9">
									<div class="rdo_type flex_start">
										<div class="radio-group">
											<input type="radio" id="carrierSk1" name="carrier_opt1" data-value="sk1" data-option-val="false">
											<label for="carrierSk1">SKT</label>
										</div>
										<div class="radio-group">
											<input type="radio" id="carrierKt1" name="carrier_opt1" data-value="kt1" data-option-val="false">
											<label for="carrierKt1">KT</label>
										</div>
										<div class="radio-group">
											<input type="radio" id="carrierLg1" name="carrier_opt1" data-value="lg1" data-option-val="false">
											<label for="carrierLg1">LG U+</label>
										</div>
									</div>
									<div class="flex_start">
										<small class="hidden warning-text">이동 통신사를 선택해 주세요.</small>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-3"><span class="input_label">휴대폰 번호</span></div>
								<div class="col-9">
									<div class="flex_start">
										<div class="dropdown w-90">
											<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="findIdMobilePrefix" class="dropdown-menu"></ul>
										</div>
										<div class="tx_inp_type offset-176"><input type="text" id="findIdMobileNum" name="find_id_mobil_num" placeholder="입력" maxlength="13"></div>
										<button type="button" class="btn_type fr">인증</button>
									</div>
									<div class="flex_start">
										<small id="isValidNumA" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-3"><span class="input_label">인증 번호</span></div>
								<div class="col-9">
									<div class="tx_inp_type"><input type="text" id="findIdCode" name="find_id_code" placeholder="입력">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-12">
									<div class="btn_wrap_type02"><!--
									--><button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="submit" id="findIdBtn" class="btn_type" disabled>등록</button><!--
									--></div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>


	<div class="modal fade" id="findPwdModal" tabindex="-1" role="dialog" aria-labelledby="findPwdModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-md">
			<div class="modal-content user-modal-content">
				<div class="modal-header"><h2>비밀번호 찾기</h2></div>
				<div class="modal-body">
					<div class="container-fluid">
						<form name="find_pwd_form" id="findPwdForm" class="user-form">

							<div class="row">
								<div class="col-3"><span class="input_label asterisk">이름</span></div>
								<div class="col-9">
									<div class="tx_inp_type"><input type="text" id="findPwdFullName" name="find_pwd_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
									<small class="hidden warning-text">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
								</div>
							</div>

							<div class="row">
								<div class="col-3"><span class="input_label asterisk">ID</span></div>
								<div class="col-9">
									<div class="tx_inp_type"><input type="text" id="findPwdId" name="find_pwd_id" placeholder="입력" minlength="3" maxlength="28"></div>
									<small class="hidden warning-text">ID를 입력해 주세요</small>
								</div>
							</div>

							<div class="row">
								<div class="col-3"><span class="input_label asterisk">이동 통신사</span></div>
								<div class="col-9">
									<div class="rdo_type flex_start">
										<div class="radio-group">
											<input type="radio" id="carrierSk2" name="carrier_opt2" data-value="sk" data-option-val="true">
											<label for="carrierSk2">SKT</label>
										</div>
										<div class="radio-group">
											<input type="radio" id="carrierKt2" name="carrier_opt2" data-value="kt" data-option-val="false">
											<label for="carrierKt2">KT</label>
										</div>
										<div class="radio-group">
											<input type="radio" id="carrierLg2" name="carrier_opt2" data-value="lg" data-option-val="false">
											<label for="carrierLg2">LG U+</label>
										</div>
									</div>
									<div class="flex_start">
										<small class="hidden warning-text">이동 통신사를 선택해 주세요.</small>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-3"><span class="input_label">휴대폰 번호</span></div>
								<div class="col-9">
									<div class="flex_start">
										<div class="dropdown w-90">
											<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="findPwdMobilePrefix" class="dropdown-menu"></ul>
										</div>
										<div class="tx_inp_type offset-176"><input type="text" id="findPwdMobileNum" name="find_pwd_mobil_num" placeholder="입력" maxlength="13"></div>
										<button type="button" class="btn_type fr">인증</button>
									</div>
									<div class="flex_start">
										<small id="isValidNumB" class="warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-3"><span class="input_label">인증 번호</span></div>
								<div class="col-9">
									<div class="tx_inp_type"><input type="text" id="findPwdCode" name="find_pwd_code" placeholder="입력">
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-12">
									<div class="btn_wrap_type02"><!--
									--><button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="submit" id="findPwdBtn" class="btn_type" disabled>등록</button><!--
									--></div>
								</div>
							</div>
						</form>
					</div>
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

			$("#signUpForm").on("submit", function(e){
				e.preventDefault();

			});

			// Modal event
			$("#signUpModal").on("hide.bs.modal", function(){
				initModal(this);
			});

			$("#findIdModal").on("hide.bs.modal", function(){
				initModal(this);
			});

			$("#findPwdModal").on("hide.bs.modal", function(){
				initModal(this);
			});
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

		function openUserModal(option) {
			let modal = "#" + option;
			$(modal).modal("show");
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
				// Pattern: "[!@@#$%^&*]",
				// Target: "Symbols"
				// }
			];

			let password = $(this).val();
			password.length >= 6 ? $("#isSixCharLong").addClass("checked") : $("#isSixCharLong").removeClass("checked");

			for (var i = 0; i < rules.length; i++) {
				if( new RegExp(rules[i].Pattern).test(password) ) {
					$("#" + rules[i].Target).addClass("checked")
				} else {
					$("#" + rules[i].Target).removeClass("checked")
				}
			}

		}

		function initModal(self) {
			let txtInput = $(self).find("input[type='text']");
			let btn = $(self).find(".btn_wrap_type02 button");
			txtInput.val("");
			btn.prop("disabled", false);

			if($(self).is('#signUpModal')){
				let checkBox = $(self).find("input[type='checkbox']");
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
				console.log(jqXHR)
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

	</script>
</body>
</html>
