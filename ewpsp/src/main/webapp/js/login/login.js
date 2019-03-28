$(function() {
	// 아이디 찾기
	$('#findAuthCodeBtn').click(function() {
		if (!checkFind(false)) {
			return;
		}
		getAuthCode();
	});

	$('#findBtn').click(function() {
		if (!checkFind(true)) {
			return false;
		}
		findUserId();
		$("#findidModal").modal("hide");
		return false;
	});

	// 비번 찾기
	$('#findPwAuthCodeBtn').click(function() {
		if (!checkFindPw(false)) {
			return;
		}
		sendFindPwAuthCode();
	});

	$('#findPwBtn').click(function() {
		if (!checkFindPw(true)) {
			return false;
		}
		findUserPw();
		$("#findpassModal").modal("hide");
		return false;
	});

	// 회원 가입
	$('#duplicateBtn').click(function() {
		checkUserId();
	});

	$('#joinEmail2').change(function() {
		var val = $(this).val();
		if (val == 'manual') {
			$('#joinEmail1').css('width', '30%');
			$('#joinEmail3').show();
		} else {
			$('#joinEmail1').css('width', '60%');
			$('#joinEmail3').hide();
		}
	});

	$('#joinAuthCodeBtn').click(function() {
		sendJoinAuthCode();
	});
});

function checkLogin() {
	var userId = $('#loginUserId');
	var userPw = $('#loginUserPw');

	if (userId.val() == '') {
		alert('아이디를 입력하세요.');
		userId.focus();
		return false;
	}
	if (userPw.val() == '') {
		alert('비밀번호를 입력하세요.');
		userPw.focus();
		return false;
	}

	return true;
}

function getAuthCode() {
	var formData = $("#findForm").serializeObject();
	var result = Math.floor(Math.random() * 1000000) + 100000;
	if (result > 1000000) {
		result = result - 100000;
	}

//	$('#findAuthCode').val(result.toString());
	authCode = result.toString();

	var formData = $("#findForm").serializeObject();
	formData.authCode = authCode;
	console.log(formData);
	$.ajax({
		url : "/sendAuthCode",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			var resultCnt = result.resultCnt;
			if (resultCnt == null) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			} else {
				alert("인증번호가 발송되었습니다.");
			}
		}
	});
	
}

var authCode = '';

function sendFindPwAuthCode() {
	var formData = $('#findPwForm').serializeObject();
	var result = Math.floor(Math.random() * 1000000) + 100000;
	if (result > 1000000) {
		result = result - 100000;
	}

	authCode = result.toString();

	var formData = $("#findPwForm").serializeObject();
	formData.authCode = authCode;
	$.ajax({
//		url : "/sendFindPwAuthCode",
		url : "/sendAuthCode",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			var resultCnt = result.resultCnt;
			if (resultCnt == null) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			} else {
				alert("인증번호가 발송되었습니다.");
			}
		}
	});
}

function sendJoinAuthCode() {
	var formData = $('#joinForm').serializeObject();
	var result = Math.floor(Math.random() * 1000000) + 100000;
	if (result > 1000000) {
		result = result - 100000;
	}

	authCode = result.toString();

	$('#joinPsnMobile').val($('#joinMobile1').val() + '-' + $('#joinMobile2').val() + '-' + $('#joinMobile3').val());

	var formData = $("#joinForm").serializeObject();
	formData.authCode = authCode;
	$.ajax({
//		url : "/sendJoinAuthCode",
		url : "/sendAuthCode",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			var resultCnt = result.resultCnt;
			if (resultCnt == null) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		}
	});
}

function checkFind(findFlag) {
	if ($('#findPsnName').val() == '') {
		alert('이름를 입력하세요');
		$('#findPsnName').focus();
		return false;
	}
	if ($('#findForm').find('[name=mobileType]:checked').length == 0) {
		alert('통신사를 선택해 주세요');
		$('#findForm').find('[name=mobileType]:eq(0)').focus();
		return false;
	}
	if ($('#findMobile1').val() == '' || $('#findMobile2').val() == '' || $('#findMobile3').val() == '') {
		alert('휴대폰번호를 입력해 주세요');
		$('#findMobile2').focus();
		return false;
	}
	if (isNaN($('#findMobile2').val()) || isNaN($('#findMobile3').val())) {
		alert('숫자를 입력해 주세요');
		$('#findMobile2').focus();
		return false;
	}
	if (findFlag && $('#findAuthCode').val() != authCode) {
		alert('인증코드를 맞게 입력하세요');
		$('#findAuthCode').focus();
		return;
	}

	$('#findPsnMobile').val($('#findMobile1').val() + '-' + $('#findMobile2').val() + '-' + $('#findMobile3').val());
	return true;
}

function findUserId() {
	var formData = $("#findForm").serializeObject();
	$.ajax({
		url : "/findUserId",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			var userDetail = result.detail;
			if (userDetail != null) {
				alert('귀하의 아이디는 ' + userDetail.user_id + ' 입니다.');
			} else {
				alert('일치하는 정보가 없습니다.');
			}
		}
	});
}

function checkFindPw(findFlag) {
	if ($('#findPwPsnName').val() == '') {
		alert('이름를 입력하세요');
		$('#findPwPsnName').focus();
		return false;
	}
	if ($('#findPwForm').find('[name=mobileType]:checked').length == 0) {
		alert('통신사를 선택해 주세요');
		$('#findPwForm').find('[name=mobileType]:eq(0)').focus();
		return false;
	}
	if ($('#findPwMobile1').val() == '' || $('#findPwMobile2').val() == '' || $('#findPwMobile3').val() == '') {
		alert('휴대폰번호를 입력해 주세요');
		$('#findPwMobile2').focus();
		return false;
	}
	if (isNaN($('#findPwMobile2').val()) || isNaN($('#findPwMobile3').val())) {
		alert('숫자를 입력해 주세요');
		$('#findPwMobile2').focus();
		return false;
	}
	if (findFlag && $('#findPwAuthCode').val() == '') {
		alert('인증코드를 입력하세요');
		$('#findPwAuthCode').focus();
		return;
	}
	if (findFlag && $('#findPwAuthCode').val() != authCode) {
		alert('인증코드를 맞게 입력하세요');
		$('#findPwAuthCode').focus();
		return;
	}

	$('#findPwPsnMobile').val($('#findPwMobile1').val() + '-' + $('#findPwMobile2').val() + '-' + $('#findPwMobile3').val());
	return true;
}

function findUserPw() {
	var formData = $("#findPwForm").serializeObject();
	$.ajax({
		url : "/findUserPw",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			var userDetail = result.detail;
			console.log(result);
			console.log(userDetail);
			if (userDetail != null) {
//				alert('귀하의 임시 비밀번호는 ' + userDetail.user_pw + ' 입니다.');
				alert("임시 비밀번호가 sms로 발송되었습니다.");
			} else {
				alert('일치하는 정보가 없습니다.');
			}
		}
	});
}

function checkAgree() {
	if (!$('#agree01').prop('checked')) {
		alert('한국 동서발전 서비스 포털 이용약관에 동의해야 합니다.');
		$('#agree01').focus();
		return false;
	}
	if (!$('#agree02').prop('checked')) {
		alert('개인정보 수집, 제공 및 활용 약관에 동의해야 합니다.');
		$('#agree02').focus();
		return false;
	}

	return true;
}

function checkJoin() {
	if ($('#joinUserId').val() == '') {
		$('.helpCont').hide();
		$('#joinUserId').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if ($('#joinUserPw').val() == '') {
		$('.helpCont').hide();
		$('#joinUserPw').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if ($('#joinUserPw2').val() == '') {
		$('.helpCont').hide();
		$('#joinUserPw2').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if ($('#joinUserPw').val() != $('#joinUserPw2').val()) {
		$('.helpCont').hide();
		$('#joinUserPw2').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if ($('#joinPsnName').val() == '') {
		$('.helpCont').hide();
		$('#joinPsnName').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if ($('#joinEmail1').val() == '' || $('#joinEmail2').val() == '') {
		$('.helpCont').hide();
		$('#joinEmail1').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if ($('#joinEmail2').val() == 'manual' && $('#joinEmail3').val() == '') {
		$('.helpCont').hide();
		$('#joinEmail1').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if ($('#joinMobile1').val() == '' || $('#joinMobile2').val() == '' || $('#joinMobile3').val() == '') {
		$('.helpCont').hide();
		$('#joinMobile1').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (isNaN($('#joinMobile1').val()) || isNaN($('#joinMobile2').val()) || isNaN($('#joinMobile3').val())) {
		$('.helpCont').hide();
		$('#joinMobile1').parents('td').children('.helpCont:eq(1)').show();
		return;
	}
	if ($('#joinAuthCode').val() == '') {
		alert('인증코드를 입력하세요');
		$('#joinAuthCode').focus();
		return;
	}
	if ($('#joinAuthCode').val() != authCode) {
		alert('인증코드를 맞게 입력하세요');
		$('#joinAuthCode').focus();
		return;
	}

	$('.helpCont').hide();

	if (confirm("가입하시겠습니까?")) {
		if ($('#joinEmail2').val() != 'manual') {
			$('#joinPsnEmail').val($('#joinEmail1').val() + '@' + $('#joinEmail2').val());
		} else {
			$('#joinPsnEmail').val($('#joinEmail1').val() + '@' + $('#joinEmail3').val());
		}
		$('#joinPsnMobile').val($('#joinMobile1').val() + '-' + $('#joinMobile2').val() + '-' + $('#joinMobile3').val());

		checkUserId(joinUser);
	}
}

// 아이디 중복 체크
function checkUserId(fn) {
	$.ajax({
		url : "/checkUserId",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			userId : $('#joinUserId').val()
		},
		success: function(result) {
			var userDetail = result.detail;
			if (userDetail == null) {
				if (fn != null) {
					fn();
				} else {
					alert($('#joinUserId').val() + ' 아이디는 사용가능 합니다.');
				}
			} else {
				alert($('#joinUserId').val() + ' 아이디는 사용중입니다.\n다른 아이디를 사용하세요.');
//				$('#joinUserId').val('');
			}
		}
	});
}

function joinUser() {
	var formData = $("#joinForm").serializeObject();
	$.ajax({
		url : "/joinUser",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			var resultCnt = result.resultCnt;
			if(resultCnt > 0) {
				join2next();
			} else {
				alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
			}
		}
	});
}
