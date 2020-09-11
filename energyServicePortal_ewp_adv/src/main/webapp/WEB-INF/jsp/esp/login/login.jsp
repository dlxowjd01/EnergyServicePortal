<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<!DOCTYPE html>
<html lang="en" class="darkmode">
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
			<input type="hidden" id="language" name="language"/>
			<div class="inner-wrapper">
				<c:choose>
					<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
						<img src="../img/logo_login_spower.svg" alt="login modal spower logo" class="login-logo center"/>
					</c:when>
					<c:otherwise>
						<img src="../img/logo_iderms.svg" alt="login modal iderms logo" class="login-logo center"/>
					</c:otherwise>
				</c:choose>
				<div class="input-field"><input type="text" id="loginUserId" name="login_id" class="clear-input" placeholder=<spring:message code="ewp.login.ID"/>></div>
				<div class="input-field"><input type="password" id="loginUserPw" name="password" class="clear-input" placeholder=<spring:message code="ewp.login.Password"/>><button type="button" class="clear-btn" onclick="showPwd( 'loginUserPw', this)">show</button></div>
				<div class="input-field no-border"><a class="chk_type"><input type="checkbox" id="saveLogin" name="save_login"><label for="saveLogin">로그인 유지</label></a></div>

				<div class="btn-wrapper">
					<input type="submit" id="loginBtn" name="login" value="<spring:message code="ewp.login.Signin" />">
					<p class="center"><a href="#" onclick="openSignUpModal()">회원 가입</a> 및 회원 정보 문의<strong class="bold">070-4949-5500</strong></p>
				</div>

				<%-- KPX(전력 거래소 사용시 하단 내용 숨김) --%>
				<%-- global.properties에서 기본 OID 기준 --%>
				<fmt:message key="default.oid" var="defaultOid"/>
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
	<!-- <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true" data-keyboard="false" data-backdrop="static"></div> -->
	<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true">
		<div class="modal-dialog modal-md">
			<div class="modal-content user-modal-content">
				<div id="titleEdit" class="modal-header"><h2>회원 가입</h2></div>
				<div class="modal-body">
					<div class="container-fluid">
						<form name="add_user_form" id="signUpForm" class="setting-form">
							<section id="userInfo">
								<div class="row">
									<div class="col-3"><span class="input_label asterisk">ID</span></div>
									<div class="col-9">
										<div class="flex_start">
											<div class="tx_inp_type offset-width">
												<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
											</div>
											<button type="button" class="btn_type fr" onclick="checkId($('#newId').val())" disabled>중복 체크</button>
										</div>
										<small class="hidden warning">사용자 아이디를 입력해 주세요</small>
										<small class="hidden warning">5~15 글자를 입력해 주세요.</small>
										<small class="hidden warning">한글, 특수 문자는 포함될 수 없습니다.</small>
										<small id="invalidId" class="hidden warning">동일한 아이디가 존재합니다.</small>
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
											<small id="hasLet" class="tick">영문</small>
											<small id="hasNum" class="tick">숫자</small>
											<small id="sixCharLong" class="tick">6자리 이상</small>
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
										<small class="hidden warning">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input_label asterisk">이메일 주소</span></div>
									<div class="col-9">
										<div class="flex_start">
											<div class="tx_inp_type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="입력" minlength="3" maxlength="28"></div>
											<div class="dropdown">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newEmailHost" class="dropdown-menu"></ul>
											</div>										
										</div>
										<div class="flex_start">
											<small class="hidden warning">올바른 이메일 형식을 입력해 주세요.</small>
										</div>
									</div>
								</div>
		
								<div class="row">
									<div class="col-3"><span class="input_label">휴대폰</span></div>
									<div class="col-9">
										<div class="flex_start">
											<div class="dropdown">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newMobilePrefix" class="dropdown-menu"></ul>
											</div>
											<div class="tx_inp_type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력" maxlength="13"></div>
											<button type="button" class="btn_type fr">인증</button>
										</div>
										<div class="flex_start">
											<small id="isValidNewMobileNum" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-3"><span class="input_label">인증 번호</span></div>
									<div class="col-9">
										<div class="tx_inp_type"><input type="text" id="verificationCode" name="verification_code" placeholder="입력">
										</div>
									</div>
								</div>
							</section>

							<section id="termsCondition">
								<div class="row">
									<div class="col-12">
										<h3 class="input_label">이용 약관</h3>
										<textarea name="new_user_desc" id="newUserDesc" class="textarea w-100" placeholder="입력">

										</textarea>
										<div class="input-field no-border right"><a class="chk_type"><input type="checkbox" id="termsInput" name="terms_input"><label for="termsInput"></label></a></div>
									</div>
								</div>

								<div class="row">
									<div class="col-12">
										<h3 class="input_label">개인 정보 수집 및 제공 동의</h3>
										<textarea name="new_user_desc" id="newUserDesc" class="textarea w-100" placeholder="입력"></textarea>
										<div class="input-field no-border right"><a class="chk_type"><input type="checkbox" id="termsInput" name="terms_input"><label for="termsInput"></label></a></div>
									</div>
								</div>
							</section>

							<div class="row">
								<div class="col-12">
									<div class="btn_wrap_type02"><!--
									--><button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button><!--
										--><button type="submit" id="addUserBtn" class="btn_type" disabled>등록</button><!--
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

			var lan = location.search.substr(location.search.length - 2, 2);

			if ( isEmpty(lan) ) {
				$("#language").val("ko");
			} else {
				$("#language").val(lan);
			}

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
			// 	let msg = '<spring:message code="ewp.login.Singup_ID" />'
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
			// 	let msg = '<spring:message code="ewp.login.Singup_PW" />'
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
			var f = document.loginForm;

			if (v === "english") {
				f.action = "/login.do?lang=en";
			} else {
				f.action = "/login.do?lang=ko";
			}

			f.method = "post";
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

		function openSignUpModal() {
			$("#addUserModal").modal("show");
		}

	</script>
</body>
</html>
