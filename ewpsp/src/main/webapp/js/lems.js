// Local EMS 연계

function goLEMSPage(userId, userPw, redirectUrl) {
	$.post('https://13.125.50.136/lems/sso/login', {
		userId: userId,
		userPw: userPw,
		redirectUrl: redirectUrl
	}, function(result) {
		console.log(result);
	});
}

function changeEMSUserSession() {
	getUserInfo(changeEMSUser);
}

function changeEMSUserDB(userIdx) {
	$.ajax({
		url : "/getUserDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			userIdx : userIdx
		},
		success: function(result) {
			changeEMSUser(result);
		}
	});
}

function changeEMSUser(userInfo) {
	console.log(JSON.stringify(userInfo));
	$.post('https://13.125.50.136/lems/sso/user/sync', userInfo,
		function(result) {
			console.log(result);
		}
	);
}