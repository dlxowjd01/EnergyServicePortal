$(function() {
	var joinForm = $('#joinForm');

	$('#duplicateBtn').click(function() {
		checkUserId(joinForm);
	});

	joinForm.find('#email2').change(function() {
		var val = $(this).val();
		if (val == 'manual') {
			joinForm.find('#email2').hide();
			joinForm.find('#email3').show();
		}
	});

	test(); // 개발 테스트용 (운영에는 절대로 있으면 안됨)
});

function test() {
	$("#joinModal").find('input').prop('checked', true);

	var joinForm = $('#joinForm');
	joinForm.find('#userId').val('greatman');
	joinForm.find('#userPw').val('1234');
	joinForm.find('#userPw2').val('1234');
	joinForm.find('#psnName').val('한재종');
	joinForm.find('#email1').val('gtman5');
	joinForm.find('#email2').val('gmail.com');
	joinForm.find('#email3').val('gmail.com');
	joinForm.find('#mobile1').val('010');
	joinForm.find('#mobile2').val('8255');
	joinForm.find('#mobile3').val('7095');
}

function checkLogin(formElmt) {
	var form = $(formElmt);
	var userId = form.find('input[name=userId]');
	var userPw = form.find('input[name=userPw]');

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

function checkAgree() {
	if (!$('input[name=agree01]').prop('checked')) {
		alert('한국 동서발전 서비스 포털 이용약관에 동의해야 합니다.');
		$('input[name=agree01]').focus();
		return false;
	}
	if (!$('input[name=agree02]').prop('checked')) {
		alert('개인정보 수집, 제공 및 활용 약관에 동의해야 합니다.');
		$('input[name=agree02]').focus();
		return false;
	}

	return true;
}

function checkJoin() {
	var form = $('#joinForm');

	if (form.find('#userId').val() == '') {
		$('.helpCont').hide();
		form.find('#userId').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (form.find('#userPw').val() == '') {
		$('.helpCont').hide();
		form.find('#userPw').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (form.find('#userPw2').val() == '') {
		$('.helpCont').hide();
		form.find('#userPw2').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (form.find('#userPw').val() != form.find('#userPw2').val()) {
		$('.helpCont').hide();
		form.find('#userPw2').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (form.find('#psnName').val() == '') {
		$('.helpCont').hide();
		form.find('#psnName').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (form.find('#email1').val() == '' || form.find('#email2').val() == '') {
		$('.helpCont').hide();
		form.find('#email1').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (form.find('#email2').val() == 'manual' && form.find('#email3').val() == '') {
		$('.helpCont').hide();
		form.find('#email1').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (form.find('#mobile1').val() == '' || form.find('#mobile2').val() == '' || form.find('#mobile3').val() == '') {
		$('.helpCont').hide();
		form.find('#mobile1').parents('td').children('.helpCont:eq(0)').show();
		return;
	}
	if (isNaN(form.find('#mobile1').val()) || isNaN(form.find('#mobile2').val()) || isNaN(form.find('#mobile3').val())) {
		$('.helpCont').hide();
		form.find('#mobile1').parents('td').children('.helpCont:eq(1)').show();
		return;
	}

	$('.helpCont').hide();

	if (confirm("가입하시겠습니까?")) {
		if (form.find('#email2').val() != 'manual') {
			form.find('#psnEmail').val(form.find('#email1').val() + '@' + form.find('#email2').val());
		} else {
			form.find('#psnEmail').val(form.find('#email1').val() + '@' + form.find('#email3').val());
		}
		form.find('#psnMobile').val(form.find('#mobile1').val() + '-' + form.find('#mobile2').val() + '-' + form.find('#mobile3').val());

		checkUserId(form, join);
	}
}

// 아이디 중복 체크
function checkUserId(form, fn) {
	$.ajax({
		url : "/checkUserId",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			userId : form.find('#userId').val()
		},
		success: function(result) {
			var userDetail = result.detail;
			if (userDetail == null) {
				if (fn != null) {
					fn();
				} else {
					alert(form.find('#userId').val() + ' 아이디는 사용가능 합니다.');
				}
			} else {
				alert(form.find('#userId').val() + ' 아이디는 중복됩니다.\n다른 아이디를 사용하세요.');
//				form.find('#userId').val('');
			}
		}
	});
}

function join() {
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


