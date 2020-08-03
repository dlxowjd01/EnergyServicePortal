<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="en" class="darkmode">
<head>
	<%@ include file="/decorators/include/layouts/top.jsp"%>
		<link href="/css/custom-login.css" rel="stylesheet">
		<script type="text/javascript">
			$(function () {
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
						console.log("not empty===")
						$("#loginBtn").prop("disabled", false);
					}
				});

				$("#loginUserPw").bind("change keypress", function(){
					if(!isEmpty($("#loginUserId").val())){
						console.log("not empty===")
						$("#loginBtn").prop("disabled", false);
					}
				});

				// // 아이디 찾기
				// $('#findAuthCodeBtn').click(function () {
				// 	if (!checkFind(false)) {
				// 		return;
				// 	}
				// 	getAuthCode();
				// });

				// $('#findBtn').click(function () {
				// 	if (!checkFind(true)) {
				// 		return false;
				// 	}
				// 	findUserId();
				// 	$("#findidModal").modal("hide");
				// 	return false;
				// });

				// // 비번 찾기
				// $('#findPwAuthCodeBtn').click(function () {
				// 	if (!checkFindPw(false)) {
				// 		return;
				// 	}
				// 	sendFindPwAuthCode();
				// });

				// $('#findPwBtn').click(function () {
				// 	if (!checkFindPw(true)) {
				// 		return false;
				// 	}
				// 	findUserPw();
				// 	$("#findpassModal").modal("hide");
				// 	return false;
				// });

				// // 회원 가입
				// $('#duplicateBtn').click(function () {
				// 	checkUserId();
				// });

				// $('#joinEmail2').change(function () {
				// 	var val = $(this).val();
				// 	if (val === 'manual') {
				// 		$('#joinEmail1').css('width', '30%');
				// 		$('#joinEmail3').show();
				// 	} else {
				// 		$('#joinEmail1').css('width', '60%');
				// 		$('#joinEmail3').hide();
				// 	}
				// });

				// $('#joinAuthCodeBtn').click(function () {
				// 	if( isEmpty($('#joinPsnName').val()) ) {
				// 		alert("이름을 입력하세요");
				// 		return;
				// 	}

				// 	if( isEmpty($('#joinMobile1').val()) || isEmpty($('#joinMobile2').val()) || isEmpty($('#joinMobile3').val()) ) {
				// 		alert('휴대폰번호를 입력해 주세요');
				// 		return;
				// 	}
				// 	sendJoinAuthCode();
				// });
			});

			function show_Language(v) {
				var f = document.loginForm;

				if (v === "english") {
					f.action = "/login.do?lang=en";
				} else {
					f.action = "/login.do?lang=ko";
				}

				f.method = "post";
				f.submit();
			}

			function checkLogin() {
				var $userId = $('#loginUserId');
				var $userPw = $('#loginUserPw');

				if ( isEmpty($userId.val()) ) {
					alert('<spring:message code="ewp.login.Singup_ID" />');
					$userId.focus();
					return false;
				}
				if ( isEmpty($userPw.val()) ) {
					alert('<spring:message code="ewp.login.Singup_PW" />');
					$userPw.focus();
					return false;
				}

				return true;
			}

			// function getAuthCode() {
			// 	var $frm = $("#findForm");
			// 	var formData = $frm.serializeObject();
			// 	var result = Math.floor(Math.random() * 1000000) + 100000;
			// 	if (result > 1000000) {
			// 		result = result - 100000;
			// 	}

			// 	authCode = result.toString();

			// 	formData = $frm.serializeObject();
			// 	formData.authCode = authCode;
			// 	console.log(formData);
			// 	$.ajax({
			// 		url: "/sendAuthCode.json",
			// 		type: 'post',
			// 		async: false, // 동기로 처리해줌
			// 		data: formData,
			// 		success: function (result) {
			// 			var resultCnt = result.resultCnt;
			// 			if ( isEmpty(resultCnt) ) {
			// 				alert('<spring:message code="ewp.error.default" />');
			// 			} else {
			// 				alert("인증번호가 발송되었습니다.");
			// 			}
			// 		}
			// 	});

			// }

			// var authCode = '';

			// function sendFindPwAuthCode() {
			// 	var $frm = $("#findPwForm");
			// 	var formData = $frm.serializeObject();
			// 	var result = Math.floor(Math.random() * 1000000) + 100000;
			// 	if (result > 1000000) {
			// 		result = result - 100000;
			// 	}

			// 	authCode = result.toString();

			// 	formData = $frm.serializeObject();
			// 	formData.authCode = authCode;
			// 	$.ajax({
			// 		//		url : "/sendFindPwAuthCode",
			// 		url: "/sendAuthCode.json",
			// 		type: 'post',
			// 		async: false, // 동기로 처리해줌
			// 		data: formData,
			// 		success: function (result) {
			// 			var resultCnt = result.resultCnt;
			// 			if ( isEmpty(resultCnt) ) {
			// 				alert('<spring:message code="ewp.error.default" />');
			// 			} else {
			// 				alert("인증번호가 발송되었습니다.");
			// 			}
			// 		}
			// 	});
			// }

			// function sendJoinAuthCode() {
			// 	var $frm = $("#joinForm");
			// 	var formData = $frm.serializeObject();
			// 	var result = Math.floor(Math.random() * 1000000) + 100000;
			// 	if (result > 1000000) {
			// 		result = result - 100000;
			// 	}

			// 	authCode = result.toString();

			// 	$('#joinPsnMobile').val($('#joinMobile1').val() + '-' + $('#joinMobile2').val() + '-' + $('#joinMobile3').val());

			// 	formData = $frm.serializeObject();
			// 	formData.authCode = authCode;
			// 	$.ajax({
			// 		url: "/sendAuthCode.json",
			// 		type: 'post',
			// 		async: false, // 동기로 처리해줌
			// 		data: formData,
			// 		success: function (result) {
			// 			var resultCnt = result.resultCnt;
			// 			if (resultCnt === 40) {
			// 				alert('문자가 발송되었습니다.');
			// 			} else {
			// 				alert('<spring:message code="ewp.error.default" />');
			// 			}
			// 		}
			// 	});
			// }

			// function checkFind(findFlag) {
			// 	if ( isEmpty($('#findPsnName').val()) ) {
			// 		alert('이름를 입력하세요');
			// 		$('#findPsnName').focus();
			// 		return false;
			// 	}
			// 	if ($('#findForm').find('[name=mobileType]:checked').length === 0) {
			// 		alert('통신사를 선택해 주세요');
			// 		$('#findForm').find('[name=mobileType]:eq(0)').focus();
			// 		return false;
			// 	}
			// 	var $findMobile1 = $('#findMobile1');
			// 	var $findMobile2 = $('#findMobile2');
			// 	var $findMobile3 = $('#findMobile3');
			// 	if ( isEmpty($findMobile1.val()) || isEmpty($findMobile2.val()) || isEmpty($findMobile3.val()) ) {
			// 		alert('휴대폰번호를 입력해 주세요');
			// 		$findMobile2.focus();
			// 		return false;
			// 	}
			// 	if (isNaN($findMobile2.val()) || isNaN($findMobile3.val())) {
			// 		alert('숫자를 입력해 주세요');
			// 		$findMobile2.focus();
			// 		return false;
			// 	}
			// 	if (findFlag && $('#findAuthCode').val() !== authCode) {
			// 		alert('인증코드를 맞게 입력하세요');
			// 		$('#findAuthCode').focus();
			// 		return;
			// 	}

			// 	$('#findPsnMobile').val($findMobile1.val() + '-' + $findMobile2.val() + '-' + $findMobile3.val());
			// 	return true;
			// }

			// function findUserId() {
			// 	var formData = $("#findForm").serializeObject();
			// 	$.ajax({
			// 		url: "/findUserId.json",
			// 		type: 'post',
			// 		async: false, // 동기로 처리해줌
			// 		data: formData,
			// 		success: function (result) {
			// 			var userDetail = result.detail;
			// 			if ( !isEmpty(userDetail) ) {
			// 				alert('귀하의 아이디는 ' + userDetail.user_id + ' 입니다.');
			// 			} else {
			// 				alert('일치하는 정보가 없습니다.');
			// 			}
			// 		}
			// 	});
			// }

			// function checkFindPw(findFlag) {
			// 	if ( isEmpty($('#findPwPsnName').val()) ) {
			// 		alert('이름를 입력하세요');
			// 		$('#findPwPsnName').focus();
			// 		return false;
			// 	}
			// 	if ($('#findPwForm').find('[name=mobileType]:checked').length === 0) {
			// 		alert('통신사를 선택해 주세요');
			// 		$('#findPwForm').find('[name=mobileType]:eq(0)').focus();
			// 		return false;
			// 	}
			// 	var $findPwMobile1 = $('#findPwMobile1');
			// 	var $findPwMobile2 = $('#findPwMobile2');
			// 	var $findPwMobile3 = $('#findPwMobile3');
			// 	if ( isEmpty($findPwMobile1.val()) || isEmpty($findPwMobile2.val()) || isEmpty($findPwMobile3.val()) ) {
			// 		alert('휴대폰번호를 입력해 주세요');
			// 		$findPwMobile2.focus();
			// 		return false;
			// 	}
			// 	if (isNaN($findPwMobile2.val()) || isNaN($findPwMobile3.val())) {
			// 		alert('숫자를 입력해 주세요');
			// 		$findPwMobile2.focus();
			// 		return false;
			// 	}
			// 	if (findFlag && isEmpty($('#findPwAuthCode').val()) ) {
			// 		alert('인증코드를 입력하세요');
			// 		$('#findPwAuthCode').focus();
			// 		return;
			// 	}
			// 	if (findFlag && $('#findPwAuthCode').val() !== authCode) {
			// 		alert('인증코드를 맞게 입력하세요');
			// 		$('#findPwAuthCode').focus();
			// 		return;
			// 	}

			// 	$('#findPwPsnMobile').val($findPwMobile1.val() + '-' + $findPwMobile2.val() + '-' + $findPwMobile3.val());
			// 	return true;
			// }

			// function findUserPw() {
			// 	var formData = $("#findPwForm").serializeObject();
			// 	$.ajax({
			// 		url: "/findUserPw.json",
			// 		type: 'post',
			// 		async: false, // 동기로 처리해줌
			// 		data: formData,
			// 		success: function (result) {
			// 			var userDetail = result.detail;
			// 			if ( !isEmpty(userDetail) ) {
			// 				alert("임시 비밀번호가 sms로 발송되었습니다.");
			// 			} else {
			// 				alert('일치하는 정보가 없습니다.');
			// 			}
			// 		}
			// 	});
			// }

			// function checkAgree() {
			// 	if (!$('#agree01').prop('checked')) {
			// 		alert('S-POWER iDERMS 서비스 이용약관에 동의해야 합니다.');
			// 		$('#agree01').focus();
			// 		return false;
			// 	}
			// 	if (!$('#agree02').prop('checked')) {
			// 		alert('개인정보 수집, 제공 및 활용 약관에 동의해야 합니다.');
			// 		$('#agree02').focus();
			// 		return false;
			// 	}

			// 	return true;
			// }

			// function emptyAlert(index) {
			// 	$('.helpCont').hide();
			// 	if ($(index).val() === '') {
			// 		$(index).parents('td').children('.helpCont:eq(0)').show();
			// 		return true;
			// 	}
			// }

			// function checkJoin() {
			// 	if (emptyAlert('#joinUserId')) {
			// 		return;
			// 	}
			// 	if (emptyAlert('#joinUserPw')) {
			// 		return;
			// 	}
			// 	if (emptyAlert('#joinUserPw2')) {
			// 		return;
			// 	}
			// 	var $joinUserPw = $('#joinUserPw');
			// 	var $joinUserPw2 = $('#joinUserPw2');
			// 	if ($joinUserPw.val() !== $joinUserPw2.val()) {
			// 		$('.helpCont').hide();
			// 		$joinUserPw2.parents('td').children('.helpCont:eq(0)').show();
			// 		return;
			// 	} else {
			// 		$('.helpCont').hide();
			// 	}
			// 	if (emptyAlert('#joinPsnName')) {
			// 		return;
			// 	}
			// 	var $joinEmail1 = $('#joinEmail1');
			// 	var $joinEmail2 = $('#joinEmail2');
			// 	var $joinEmail3 = $('#joinEmail3');
			// 	if ( isEmpty($joinEmail1.val()) || isEmpty($joinEmail2.val()) ) {
			// 		$('.helpCont').hide();
			// 		$joinEmail1.parents('td').children('.helpCont:eq(0)').show();
			// 		return;
			// 	} else {
			// 		$('.helpCont').hide();
			// 	}
			// 	if ($joinEmail2.val() === 'manual' && isEmpty($joinEmail3.val())) {
			// 		$('.helpCont').hide();
			// 		$joinEmail1.parents('td').children('.helpCont:eq(0)').show();
			// 		return;
			// 	} else {
			// 		$('.helpCont').hide();
			// 	}
			// 	var $joinMobile1 = $('#joinMobile1');
			// 	var $joinMobile2 = $('#joinMobile2');
			// 	var $joinMobile3 = $('#joinMobile3');
			// 	if ( isEmpty($joinMobile1.val()) || isEmpty($joinMobile2.val()) || isEmpty($joinMobile3.val()) ) {
			// 		$('.helpCont').hide();
			// 		$joinMobile1.parents('td').children('.helpCont:eq(0)').show();
			// 		return;
			// 	} else {
			// 		$('.helpCont').hide();
			// 	}
			// 	if (isNaN($joinMobile1.val()) || isNaN($joinMobile2.val()) || isNaN($joinMobile3.val())) {
			// 		$('.helpCont').hide();
			// 		$joinMobile1.parents('td').children('.helpCont:eq(1)').show();
			// 		return;
			// 	} else {
			// 		$('.helpCont').hide();
			// 	}
			// 	var $joinAuthCode = $('#joinAuthCode');
			// 	if ( isEmpty($joinAuthCode.val()) ) {
			// 		alert('인증코드를 입력하세요');
			// 		$joinAuthCode .focus();
			// 		return;
			// 	}
			// 	if ($joinAuthCode.val() !== authCode) {
			// 		alert('인증코드를 맞게 입력하세요');
			// 		$joinAuthCode .focus();
			// 		return;
			// 	}

			// 	$('.helpCont').hide();

			// 	if (confirm("가입하시겠습니까?")) {
			// 		if ($joinEmail2.val() !== 'manual') {
			// 			$('#joinPsnEmail').val($joinEmail1.val() + '@' + $joinEmail2.val());
			// 		} else {
			// 			$('#joinPsnEmail').val($joinEmail1.val() + '@' + $joinEmail3.val());
			// 		}
			// 		$('#joinPsnMobile').val($joinMobile1.val() + '-' + $joinMobile2.val() + '-' + $joinMobile3.val());

			// 		checkUserId(joinUser);
			// 	}
			// }

			// function join2next() {
			// 	$("#joinModal2").modal("hide");
			// 	$("#joinModal3").modal("show");
			// }
			// // 아이디 중복 체크
			// function checkUserId(fn) {
			// 	$.ajax({
			// 		url: "/checkUserId.json",
			// 		type: 'post',
			// 		async: false, // 동기로 처리해줌
			// 		data: {
			// 			userId: $('#joinUserId').val()
			// 		},
			// 		success: function (result) {
			// 			var userDetail = result.detail;
			// 			if ( isEmpty(userDetail) ) {
			// 				if ( !isEmpty(fn) ) {
			// 					fn();
			// 				} else {
			// 					alert($('#joinUserId').val() + ' 아이디는 사용가능 합니다.');
			// 				}
			// 			} else {
			// 				alert($('#joinUserId').val() + ' 아이디는 사용중입니다.\n다른 아이디를 사용하세요.');
			// 			}
			// 		}
			// 	});
			// }

			// function joinUser() {
			// 	var formData = $("#joinForm").serializeObject();
			// 	$.ajax({
			// 		url: "/joinUser.json",
			// 		type: 'post',
			// 		async: false, // 동기로 처리해줌
			// 		data: formData,
			// 		success: function (result) {
			// 			var resultCnt = result.resultCnt;
			// 			if (resultCnt > 0) {
			// 				join2next();
			// 			} else {
			// 				alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
			// 			}
			// 		}
			// 	});
			// }
		</script>
		<script type="text/javascript">
			<c:if test="${not empty msg}">
			alert('${msg}');
			</c:if>
		</script>
</head>
<body>
	<div class="outer-wrapper">
		<div class="login-wrapper">
			<nav class="clear">
				<c:choose>
					<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
						<div class="nav-brand spower"><a href="#">Spower</a></div>
					</c:when>
					<c:otherwise>
						<div class="nav-brand"><a href="#">Encored</a></div>
					</c:otherwise>
				</c:choose>
				<%--	
				<div class="nav_theme">
					<div class="switcher">
						<input type="radio" name="balance" value="light" id="light" class="switcher__input switcher__input--light" checked="" onClick="userTheme('light');">
						<label for="light" class="switcher__label">Light</label>
						<input type="radio" name="balance" value="dark" id="dark" class="switcher__input switcher__input--dark" onClick="userTheme('dark');">
						<label for="dark" class="switcher__label">Dark</label>
						<span class="switcher__toggle"></span>
					</div>
				</div>
				--%>
				<div class="lang login-lang dropdown">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">${sessionScope.sessionLangNm }
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				        <li><a href="javascript:show_Language('korea');">KO</a></li>
				        <li><a href="javascript:show_Language('english');">EN</a></li>
				    </ul>
				</div>
			</nav>
			<div class="login container-fluid">
				<div class="login-form">
					<form id="loginForm" name="loginForm" action="/loginUser.do" method="post" onsubmit="checkLogin(this);">
						<input type="hidden" id="language" name="language"/>
						<div class="lf-body">
							<c:choose>
								<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
									<img src="../img/logo_login_spower.svg" alt="login modal spower logo" class="login-logo center"/>
								</c:when>
								<c:otherwise>
									<img src="../img/logo_iderms.svg" alt="login modal iderms logo" class="login-logo center"/>
								</c:otherwise>
							</c:choose>
						    <div class="mt10"><input type="text" id="loginUserId" name="login_id" class="clear-input" placeholder=<spring:message code="ewp.login.ID"/>></div>
							<div class="mt15"><input type="password" id="loginUserPw" name="password" class="clear-input" placeholder=<spring:message code="ewp.login.Password"/>></div>
							<div class="mt15"><a class="chk_type"><input type="checkbox" id="saveLogin" name="save_login"><label for="saveLogin">로그인 유지</label></a></div>

							<div class="lf-btn-wrap">
								<%--
								<a href="#" class="joinBtn"><spring:message code="ewp.login.Singup"/></a> 
								--%>
								<input type="submit" id="loginBtn" name="login" value="<spring:message code="ewp.login.Signin" />">
								<p class="center">회원 가입 및 회원 정보 문의<strong class="bold">070-4949-5500</strong></p>
							</div>

							<div class="lf-desc">
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
						</div>
					
					</form>
				</div>

			</div>
		</div>
	</div>


	<%--						
	<div class="mt30">
		<a href="#" class="findidBtn arrbtn"><spring:message code="ewp.login.Forgot_account"/></a>
		<a href="#" class="findpassBtn arrbtn ml-30"><spring:message code="ewp.login.Forgot_password"/></a>
	</div>
	--%>
	<div class="modal fade" id="findidModal" tabindex="-1" role="dialog" aria-labelledby="findidModal" aria-hidden="true">
        <div class="modal-dialog modal-md">
			<div class="login-modal-content modal-content">
				<div class="modal-header">
	                
	                <h1>FIND ID</h1>
	            </div>
			    <form id="findForm" name="findForm">
			    <input type="hidden" id="findPsnMobile" name="psnMobile"/>
			    <div class="modal-body">
			  	    <div class="md-tbl">
			  	    	<table>
			  	    		<colgroup>
			  	    			<col width="100">
			  	    			<col>
			  	    		</colgroup>
			  	    		<tbody>
			  	    			<tr>
			  	    				<th>이름</th>
			  	    				<td><input type="text" name="psnName" id="findPsnName" class="w-100" placeholder=""></td>
			  	    			</tr>
			  	    			<tr>
			  	    				<th>이동통신사</th>
			  	    				<td>
			  	    					<div class="form-check">
			  	    						<label class="form-check-label">
										        <input type="radio" class="form-check-input" name="mobileType"> SKT
										    </label>
										    <label class="form-check-label">
										        <input type="radio" class="form-check-input" name="mobileType"> KTF
										    </label>
										    <label class="form-check-label">
										        <input type="radio" class="form-check-input" name="mobileType"> LG U+
										    </label>
										</div>
			  	    				</td>
			  	    			</tr>
			  	    			<tr>
			  	    				<th>휴대폰 번호</th>
			  	    				<td>
										<div class="flex_start3">
											<select id="findMobile1" class="inp">
												<option value="">선택</option>
												<option value="010">010</option>
												<option value="011">011</option>
												<option value="016">016</option>
												<option value="017">017</option>
												<option value="019">019</option>
											<select><!--
										--><input type="text" id="findMobile2" class="inp ml-6" maxlength="4"/><!--
										--><input type="text" id="findMobile3" class="inp" maxlength="4"/><!--
										--><button type="button" class="btn btn_type04" id="findAuthCodeBtn">인증번호 받기</button>	
										</div>
			  	    				</td>
			  	    			</tr>
			  	    			<tr>
			  	    				<th>인증번호</th>
			  	    				<td>
			  	    					<input type="text" id="findAuthCode" name="authCode" placeholder="">
			  	    				</td>
			  	    			</tr>
			  	    		</tbody>
			  	    	</table>
			  	    </div>
			  	    <div class="mt20"><input type="submit" name="findpass" class="login login-modal-submit" value="확인" id="findBtn"></div>
			  	</div>
			    </form>
			</div>
		</div>
	</div>

	<div class="modal fade" id="findpassModal" tabindex="-1" role="dialog" aria-labelledby="findpassModal" aria-hidden="true">
        <div class="modal-dialog">
			<div class="login-modal-content">
				<div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h1>FIND PASS</h1>
	            </div>
			    <form id="findPwForm" name="findPwForm">
			    <input type="hidden" id="findPwPsnMobile" name="psnMobile"/>
			    <div class="modal-body">
			  	    <div class="md-tbl">
			  	    	<table>
			  	    		<colgroup>
			  	    			<col width="100">
			  	    			<col>
			  	    		</colgroup>
			  	    		<tbody>
			  	    			<tr>
			  	    				<th>이름</th>
			  	    				<td><input type="text" id="findPwPsnName" name="psnName" placeholder="">
			  	    			</tr>
			  	    			<tr>
			  	    				<th>ID</th>
			  	    				<td><input type="text" id="findPwUserId" name="userId" placeholder=""></td>
			  	    			</tr>
			  	    			<tr>
			  	    				<th>이동통신사</th>
			  	    				<td>
			  	    					<div class="form-check">
			  	    						<label class="form-check-label">
										        <input type="radio" class="form-check-input" name="mobileType"> SKT
										    </label>
										    <label class="form-check-label">
										        <input type="radio" class="form-check-input" name="mobileType"> KT
										    </label>
										    <label class="form-check-label">
										        <input type="radio" class="form-check-input" name="mobileType"> LG U+
										    </label>
										</div>
			  	    				</td>
			  	    			</tr>
			  	    			<tr>
			  	    				<th>휴대폰번호</th>
			  	    				<td>
										<select id="findPwMobile1" class="inp">
											<option value="">선택</option>
											<option value="010">010</option>
											<option value="011">011</option>
											<option value="016">016</option>
											<option value="017">017</option>
											<option value="019">019</option>
										<select>
										<div class="flex_start">
											<input type="text" id="findPwMobile2" class="inp type02" maxlength="4"/>
											<input type="text" id="findPwMobile3" class="inp type02" maxlength="4"/>
											<button type="button" class="btn btn_type04" id="findPwAuthCodeBtn">인증번호 받기</button>	
										</div>
			  	</td>
			  	    			</tr>
			  	    			<tr>
			  	    				<th>인증번호</th>
			  	    				<td>
			  	    					<input type="text" id="findPwAuthCode" name="authCode" placeholder="">
			  	    				</td>
			  	    			</tr>
			  	    		</tbody>
			  	    	</table>
			  	    </div>
			  	    <div class="mt20"><input type="submit" name="findpass" class="login login-modal-submit" value="확인" id="findPwBtn"></div>
			  	</div>
			    </form>
			</div>
		</div>
	</div>

	<div class="modal fade" id="joinModal1" tabindex="-1" role="dialog" aria-labelledby="joinModal" aria-hidden="true">
	    <div class="join-dialog modal-dialog modal-md">
	        <div class="modal-content step1">
	            <div class="modal-header lftit"><h1>JOIN</h1></div>
	            <div class="modal-body">
					<div id="joinStep01" class="join-container">
						<div class="unit">
							<div class="unit-tit clear">
								<span class="sTit">S-POWER iDERMS 서비스 이용약관</span>

								<div class="etcText fr mt5">
									<span class="chk_type c12">
										<input type="checkbox" id="agree01" name="type" value="1" checked>
										<label for="agree01">동의합니다</label>
									</span>
								</div>
							</div>
							<div class="unit_cont mt5">
								<div class="termBox">
									서비스 이용 약관<br><br>

									제1장 총칙<br>
									<br>
									제 1 조 (목적)<br>
									본 약관은 S-POWER iDERMS 사이트가 제공하는 모든 서비스(이하 "서비스")의 이용조건 및 절차, 이용자와 서비스포털 사이트의 권리, 의무, 책임사항과 기타 필요한 사항을 규정함을 목적으로 합니다.<br>
									<br>
									제 2 조 (약관의 효력과 변경)<br>
									1. 본약관에 동의 하는 경우 서비스포털 서비스 제공 행위 및 사용 행위에 본 약관이 우선적으로 적용됩니다.<br>
									2. 서비스포털 서비스 약관을 개정할 경우, 적용일자 및 개정사유를 명시하여 현행 약관과 함께 홈페이지에 공지합니다. 변경된 약관은 서비스포털 서비스 내에 공지하고 공지와 동시에 그 효력이 발생되며 7일간 개정 내용 표시를 유지합니다.<br>
									<br>
									제 3 조 (약관 외 준칙)<br>
									1. 서비스포털 사이트는 필요한 경우 각 개별 서비스 내에서의 약관 또는 운영정책, 각 서비스 상의 안내, 공지사항을 두어 개별 운영 원칙을 정할 수 있으며, 그 밖에 약관과 서비스별 운영원칙에 명시되지 않은 사항은 관련 법령의 규정에 의합니다.<br>
									<br>
									제 4 조 (용어의 정의)<br>
									본 약관에서 사용하는 용어의 정의는 다음과 같습니다.<br>
									1. 이용자 : 본 약관에 따라 서비스포털 사이트가 제공하는 서비스를 받는 자.<br>
									<br>
									제 2 장 서비스 제공 및 이용<br>
									제 5 조 (이용자의 정보 보안)<br>
									1. 본인 개인정보 또는 타인의 개인정보를 무단 사용을 발견한 경우 즉시 서비스포털 사이트에 신고하여 개인정보 보호 관련 법령에 따라 안전하게 관리하여야 하며, 신고를 하지 않음으로 인한 피해와 모든 책임은 이용자 본인에게 있습니다.<br>
									2. 이용자는 서비스포털 사이트 서비스를 종료하는 경우 회원 탈퇴를 진행하여야 하며, 회원 탈퇴를 하지 아니함으로써 발생되는 손해 및 손실에 대하여 서비스포털 사이트는 책임을 부담하지 아니합니다.<br>
									제 6 조 (서비스의 중지)<br>
									1. 서비스포털 사이트는 이용자가 운영정책 혹은 해당 약관 내용에 위배되는 행동 또는 관련 법령을 위반한 자는 서비스 이용을 즉시 영구 정지 시키며 이러한 이용 제한에도 불구하고 해당 서비스 이용계약의 온전한 유지를 기대하기 어려운 경우엔 부득이 이용자와의 계약 해지를 할 수 있습니다. 계약 해지에 따른 피해가 발생 할 경우 서비스 포털 사이트는 책임을 부담하지 아니합니다.<br>
									제 7 조 (서비스의 변경 및 해지)<br>
									1. 서비스포털 사이트의 서비스를 통한 손익이나 얻은 자료로 인한 배포 혹은 손해가 발생하는 경우 귀사에서 책임을 지지 않으며, 이용자가 본 서비스를 이용하여 사용하는 정보, 자료, 신뢰도, 정확도 등과 같은 내용에 대하여 귀사는 책임을 지지 않습니다.<br>
									2. 서비스포털 사이트는 서비스 이용과 관련하여 이용자에게 발생한 손해 중 이용자의 고의, 과실에 의한 손해에 대하여 책임을 부담하지 아니합니다.<br>
									제 8 조 (게시물의 저작권)<br>
									1. 서비스포털 사이트는 자주하는 질문의 게시글에 대한 내용을 사전 통지 없이 편집 및 삭제 할 수 있는 권리를 보유하며, 운영원칙에 따라 사전 통지 없이 삭제할 수 있습니다.<br>
									제 3 장 의무 및 책임<br>
									제 9 조 (서비스포털 사이트의 의무)<br>
									1. 서비스포털 사이트는 원할한 서비스 제공을 위해 이용자가 동의한 목적과 범위 내에서만 개인정보를 수집, 이용가능하며, 개인정보 보호 관련 법령에 따라 안전하게 관리합니다. 이용자 승낙 없이 개인정보를 타인에게 누설, 배포하지 않습니다. 다만 법률의 특별한 규정, 법령상 의무준수를 위해 불가피한 경우에는 그러하지 아니합니다.<br>
									제 10 조 (이용자의 의무)<br>
									1. 이용자는 서비스포털 사이트의 사전 동의 없이 서비스를 이용한 영리 행위를 할 수 없으며, 적발시 약관에 의거한 법률 및 규정, 의무 준수에 따라 이용해지를 할 수 있습니다.<br>
									제 4 장 기타<br>
									제 11 조 (손해배상)<br>
									1. 서비스포털 사이트에서 제공되는 서비스와 관련하여 귀사의 고의 또는 과실로 인하여 손해를 입게 될 경우 관련 법령에 따라 손해를 배상 하지만 고의 또는 과실, 천재 지변, 예견이 불가능 하거나 특별한 사정으로 공지한 사항, 기타 징벌적 손해에 대해서는 관련 법령에 특별한 규정이 없는 한 책임을 부담하지 않습니다.<br>
									제 12 조 (면책조항)<br>
									1. 서비스포털 사이트는 이용자가 서비스에 담긴 정보를 사용하여 얻은 손익이나 손해에 대한 책임이 없습니다.<br>
									2. 서비스포털 사이트는 이용자간 또는 이용자와 제3자간에 서비스를 매개로 하여 물품거래 혹은 금전적 거래 등과 관련하여 어떠한 책임도 부담하지 아니하고, 회원이 서비스의 이용과 관련하여 기대하는 이익에 관하여 책임을 부담하지 않습니다.<br>
									제 13 조 (재판관할)<br>
									1. 본 약관 또는 서비스포털 서비스와 관련된 이용자와의 관계에는 대한믹국의 법령이 적용되며, 분쟁이 발생하는 경우 그 분쟁의 처리는 대한민국 ‘민사소송법’에서 정한 절차를 따릅니다.<br>
									<br>
									공지 일자 : 2019년 06월 01일<br>
									적용 일자 : 2019년 06월 01일<br>
									<br>
									서비스포털과 관련하여 궁금하신 사항이 있다면, 고객센터로(대표번호:070-5000-1999/ 평일09:00~18:00) 문의 주시기 바랍니다.<br>
									<br>
									<br>
									회원 가입<br>
									<br>
									이용약관(동서 발전)<br>
									<br>
									회원이용약관<br>
									1. 수집하는 개인정보의 항목<br>
									한국동서발전(주)는 서비스 제공을 위한 필수정보와 고객 맞춤서비스 제공을 위해 아래와 같은 개인정보를 수집하고 있습니다.<br>
									<br>
									수집항목<br>
									• 개인정보 : ID, 비밀번호, 이름, 생년월일, 전화번호, 이메일<br>
									• 업체정보 : 업체명, 업종, 주소, 사업자등록번호<br>
									• (사업신청 시) 추가수집정보 : 소속업체 전력사용정보(한전 ISmart ID, P/W)<br>
									개인정보의 수집 및 이용목적<br>
									수집된 정보는 이용자 여러분에게 보다 정확하고, 나은 서비스를 제공하기 위한 것이며 이용자와 웹사이트간의 원활한 의사소통을 위해 이용되어질 것입니다.<br>
									개인정보의 보유 및 이용기간<br>
									회원으로서 한국동서발전(주)에 제공하는 서비스를 이용하는 동안 한국동서발전(주)는 회원의 개인정보를 계속적으로 보유하며 서비스 제공 등을 위해 이용합니다.<br>
									다만, 회원 본인이 직접 삭제하거나 수정한 정보, 가입해지를 요청한 경우에는 재생할 수 없는 방법에 의하여 디스크에서 완전히 삭제하며 추후 열람이나 이용이 불가능한 상태로 처리됩니다.<br>
									일시적인 목적(이벤트 등)으로 입력 받은 개인정보는 그 목적이 달성된 이후에는 동일한 방법으로 사후 재생이 불가능한 상태로 처리됩니다.<br>
									한국동서발전(주)는 개인정보의 수집목적이 달성되면 파기하는 것을 원칙으로 합니다.<br>
									<br>
									동의를 거부할 권리 및 동의 거부에 따른 안내<br>
									귀하는 본 안내에 따른 개인정보 수집에 대하여 거부하실 수 있는 권리가 있습니다.<br>
									본 개인정보 수집에 대하여 거부하시는 경우 본 서비스를 이용하실 수 없습니다.
								</div>
							</div>
						</div>

						<div class="unit mt5">
							<div class="unit-tit clear">
								<span class="sTit">개인정보 수집, 제공 및 활용 동의</span>
								<div class="etcText fr mt5"><!--
								--><span class="chk_type c12"><!--
								--><input type="checkbox" id="agree02" name="type" value="1" checked><!--
								--><label for="agree02">동의합니다</label><!--
								--></span><!--
							--></div>
							</div>
							<div class="unit_cont mt5">
								<div class="termBox">
								</div>
							</div>
						</div>

					</div>
	            </div>
	            <div class="modal-footer">
	            	<button type="submit" class="joinnextBtn default_btn w80" data-dismiss="modal">다음</button>
	            </div>
			</div>
	    </div>
	</div>

	<div class="modal fade" id="joinModal2" tabindex="-1" role="dialog" aria-labelledby="joinModal" aria-hidden="true">
	    <div class="join-dialog modal-dialog modal-md">
			<div class="modal-content step2">
				<div class="modal-header lftit"><h1>JOIN</h1></div>
				<form id="joinForm" name="joinForm">
					<input type="hidden" id="joinPsnEmail" name="psnEmail"/>
					<input type="hidden" id="joinPsnMobile" name="psnMobile"/>
					<div class="modal-body">
						<div id="joinStep02" class="join-container">
							<div class="unit clear">
								<div class="unit-tit">
									<span class="sTit">정보입력</span>
								</div>
								<div class="unit_cont lineBox">
									<table class="tableStyle formStyle left">
										<colgroup>
											<col style="width:25%">
											<col style="width:75%">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th>아이디</th>
												<td class="flex_start">
													<input type="text" id="joinUserId" name="userId" class="inp" maxlength="20"/>
													<button type="button" class="btn btn_type03 ml-12" id="duplicateBtn">중복확인</button>	</div>
													<span class="helpCont">아이디를 입력하세요</span>
												</td>
											</tr>
											<tr>
												<th>비밀번호</th>
												<td class="flex_start">
													<input type="password" id="joinUserPw" name="userPw" class="inp" maxlength="100"/>
													<span class="helpCont">비밀번호를 입력하세요</span>
												</td>
											</tr>
											<tr>
												<th>비밀번호확인</th>
												<td class="flex_start">
													<input type="password" id="joinUserPw2" class="inp" maxlength="100"/>
													<span class="helpCont">비밀번호를 입력하세요</span>
												</td>
											</tr>
											<tr>
												<th>이름</th>
												<td class="flex_start">
													<input type="text" id="joinPsnName" name="psnName" class="inp"/>
													<span class="helpCont">이름을 입력하세요</span>
												</td>
											</tr>
											<tr>
												<th>이메일 주소</th>
												<td>
													<div class="flex_start3">
														<input type="text" id="joinEmail1" class="inp" maxlength="25"/>
														<span class="center">@</span>
														<input type="text" id="joinEmail3" class="inp ml-6" maxlength="25"/>
														<select id="joinEmail2" class="inp ml-6">
															<option value="">선택</option>
															<option value="naver.com">naver.com</option>
															<option value="hanmail.net">hanmail.net</option>
															<option value="nate.com">nate.com</option>
															<option value="gmail.com">gmail.com</option>
															<option value="manual">직접입력</option>
														<select>
									</div>
													<span class="helpCont">email을 입력하세요</span>
												</td>
											</tr>
											<tr>
												<th>휴대폰 번호</th>
												<td>
													<div class="flex_start3">
														<input type="text" id="joinMobile1" class="inp" maxlength="3"/>
														<input type="text" id="joinMobile2" class="inp" maxlength="4"/>
														<input type="text" id="joinMobile3" class="inp" maxlength="4"/>
														<button type="button" class="btn btn_type04" id="joinAuthCodeBtn">인증번호 받기</button>
													</div>
													<small class="helpCont">휴대폰번호를 입력해 주세요</small>
													<small class="helpCont">숫자를 입력해 주세요</small>
												</td>
											</tr>
											<tr>
												<th>인증번호</th>
												<td class="flex_start"><input type="text" name="authCode" id="joinAuthCode" class="inp" placeholder=""></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="cancel_btn w80" data-dismiss="modal" aria-label="Close">취소</button>
						<button type="submit" class="join2nextBtn default_btn w80">확인</button>
					</div>
				</form>
			</div>
	    </div>
	</div>

	<div class="modal fade" id="joinModal3" tabindex="-1" role="dialog" aria-labelledby="joinModal" aria-hidden="true">
	    <div class="join-dialog modal-dialog modal-md">
			<div class="modal-content step3">
	            <div class="modal-body">
					<div id="joinStep03" class="join-container">
						<div class="joinEndText">
							<strong>"축하합니다"</strong>
							회원가입이 완료되었습니다.
						</div>

					</div>
	            </div>
	            <div class="modal-footer">
	            	<a href="/login.do" class="default_btn w80">로그인</a>
				</div>
			</div>
	    </div>
	</div>

	<script>
			// window.__THEME_MODE = 'dark'
			// document.getElementsByTagName('html')[0].classList['add']('darkmode');
			// document.getElementsByTagName('html')[0].classList[window.__THEME_MODE === 'dark' ? 'add' : 'remove']('darkmode');

		$(function(){
			// Sign Up btn click
			$(".joinBtn").click(function(){
				$("#loginModal").modal("hide");
				$("#joinModal1").modal("show");
				$('input[type=checkbox]').prop('checked',false);
			});
			// Sign Up => step1
			$(".joinnextBtn").click(function () {
				if (!checkAgree()) {
					return false;
				} else {
					$("#joinModal1").modal("hide");
					$("#joinModal2").modal("show");
				}
			});
			// Sign Up => step2
			$(".join2nextBtn").click(function () {
				checkJoin();
				return false;
			});
			// FIND ID
			$(".findidBtn").click(function(){
				$("#loginModal").modal("hide");
				$("#findidModal").modal("show");
			});
			// FIND PASS
			$(".findpassBtn").click(function(){
			});
		});
	</script>

</body>
</html>