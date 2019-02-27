// Local EMS 연계

var lemsUrl = null;
function goLEMSPage(redirectUrl) {
	lemsUrl = redirectUrl;
	getUserInfo(callback_goLEMSPage);
}

function callback_goLEMSPage(result) {
	getSiteDetail(dvSiteId);
//	var urlEnc = encodeURIComponent('https://13.125.50.136' + lemsUrl);
//	window.open('https://13.125.50.136/lems/sso/login?userId=' + result.user_id + '&userPw=' + result.user_pw + '&redirectUrl=' + urlEnc);
	var urlEnc = encodeURIComponent(localEmsAddr + lemsUrl);
	window.open(localEmsAddr+'/lems/sso/login?userId=' + result.user_id + '&userPw=' + result.user_pw + '&redirectUrl=' + urlEnc);
	lemsUrl = null;
}

var localEmsAddr = "";
function callback_getSiteDetail(result) {
	var siteDetail = result.detail;
	localEmsAddr = siteDetail.local_ems_addr;
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
//	console.log(JSON.stringify(userInfo));
	$.ajax({
		url: 'https://13.125.50.136/lems/sso/user/sync',
		type: 'post',
		contentType: 'application/json',
		dataType: 'json',
		headers: {
			Authorization: 'Basic bG9jYWwtZW1zOmxvY2FsLWVtcw=='
		},
		data: JSON.stringify(userInfo.detail),
		success: function(result) {
//			console.log(result.rslt);
			if (result == null || result.rslt != '1') {
				alert('Local EMS 연동에 오류가 발생했습니다.\n 관리자에게 문의하세요.');
			} else {
				console.log('Local EMS Ok.');
			}
		}
	});
}