// Local EMS 연계

var lemsUrl = null;
function goLEMSPage(redirectUrl) {
	lemsUrl = redirectUrl;
	getUserInfo(callback_goLEMSPage);
}

function callback_goLEMSPage(result) {
	var urlEnc = encodeURIComponent('https://13.125.50.136' + lemsUrl);
	window.open('https://13.125.50.136/lems/sso/login?userId=' + result.user_id + '&userPw=' + result.user_pw + '&redirectUrl=' + urlEnc);
	lemsUrl = null;
}

/* 아직 쓰는 곳 없음. */
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