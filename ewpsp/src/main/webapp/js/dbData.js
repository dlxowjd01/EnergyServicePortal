
//================================================================================================
//====================================db(API data)조회 start========================================
//================================================================================================

// 실제 사용량 조회
function getUsageRealList(formData) {
	$.ajax({
		url : "/getUsageRealList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("실제 사용량 조회");
			callback_getUsageRealList(result);
   		}
	});
}

// 예측 사용량 조회
function getUsageFutureList(formData) {
	$.ajax({
		url : "/getUsageFutureList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("예측 사용량 조회");
			callback_getUsageFutureList(result);
		}
	});
}

// 피크 전력 조회
function getPeakRealList(formData) {
	$.ajax({
		url : "/getPeakRealList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("피크 전력 조회");
			callback_getPeakRealList(result);
		}
	});
}

// 한전계약전력 조회
function getContractPowerList(formData) {
	$.ajax({
		url : "/getContractPowerList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("한전계약전력 조회");
			callback_getContractPowerList(result);
		}
	});
}

// 요금적용전력 조회
function getChargePowerList(formData) {
	$.ajax({
		url : "/getChargePowerList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("요금적용전력 조회");
			callback_getChargePowerList(result);
		}
	});
}

// ess 충방전량 조회
function getESSChargeRealList(formData) {
	$.ajax({
		url : "/getESSChargeRealList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("ess 충방전량 조회");
			callback_getESSChargeRealList(result);
		}
	});
}

// ess 예측 충방전량 조회
function getESSChargeFutureList(formData) {
	$.ajax({
		url : "/getESSChargeFutureList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("ess 예측 충방전량 조회");
			callback_getESSChargeFutureList(result);
		}
	});
}

// PV 실제 발전량 조회
function getPVGenRealList(formData) {
	$.ajax({
		url : "/getPVGenRealList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("PV 실제 발전량 조회");
			callback_getPVGenRealList(result);
		}
	});
}

// PV 예측 발전량 조회
function getPVGenFutureList(formData) {
	$.ajax({
		url : "/getPVGenFutureList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("PV 예측 발전량 조회");
			callback_getPVGenFutureList(result);
		}
	});
}

// DR 실적 조회
function getDRResultList(formData) {
	$.ajax({
		url : "/getDRResultList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("DR 실적 조회");
			callback_getDRResultList(result);
		}
	});
}

// ess 사용량 조회
function getESSUsageList(formData) {
	$.ajax({
		url : "/getESSUsageList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("ess 사용량 조회");
			callback_getESSUsageList(result);
		}
	});
}

// pv 사용량 조회
function getPVUsageList(formData) {
	$.ajax({
		url : "/getPVUsageList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("pv 사용량 조회");
			callback_getPVUsageList(result);
		}
	});
}

//// pv 사용량 조회
//function getPVUsageList(formData) {
//	$.ajax({
//		url : "/getPVUsageList",
//		type : 'post',
//		async : false, // 동기로 처리해줌
//		data : formData,
//		success: function(result) {
//			console.log("pv 사용량 조회");
//			callback_getPVUsageList(result);
//		}
//	});
//}

// 사용량 구성 조회
function getDERUsageList(formData) {
	$.ajax({
		url : "/getDERUsageList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("사용량 구성 조회");
			callback_getDERUsageList(result);
		}
	});
}





// 장치목록 조회(IOE)
function getDeviceIOEList(selPageNum) {
	$.ajax({
		url : "/getDeviceIOEList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
		success: function(result) {
			console.log("장치목록 조회(IOE)");
			callback_getDeviceIOEList(result);
		}
	});
}

// 장치 상세 조회(IOE)
function getDeviceIOEDetail(deviceIoeIdx) {
	$.ajax({
		url : "/getDeviceIOEDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			deviceIoeIdx : deviceIoeIdx
		},
		success: function(result) {
			console.log("장치 상세 조회(IOE)");
			callback_getDeviceIOEDetail(result);
		}
	});
}

// 장치목록 조회(PCS)
function getDevicePCSList(selPageNum) {
	$.ajax({
		url : "/getDevicePCSList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
		success: function(result) {
			console.log("장치목록 조회(PCS)");
			callback_getDevicePCSList(result);
		}
	});
}

//장치 상세 조회(PCS)
function getDevicePCSDetail(devicePcsIdx) {
	$.ajax({
		url : "/getDevicePCSDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			devicePcsIdx : devicePcsIdx
		},
		success: function(result) {
			console.log("장치 상세 조회(PCS)");
			callback_getDevicePCSDetail(result);
		}
	});
}

// 장치목록 조회(BMS)
function getDeviceBMSList(selPageNum) {
	$.ajax({
		url : "/getDeviceBMSList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
		success: function(result) {
			console.log("장치목록 조회(BMS)");
			callback_getDeviceBMSList(result);
		}
	});
}

//장치 상세 조회(BMS)
function getDeviceBMSDetail(deviceBmsIdx) {
	$.ajax({
		url : "/getDeviceBMSDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			deviceBmsIdx : deviceBmsIdx
		},
		success: function(result) {
			console.log("장치 상세 조회(BMS)");
			callback_getDeviceBMSDetail(result);
		}
	});
}

// 장치목록 조회(PV)
function getDevicePVList(selPageNum) {
	$.ajax({
		url : "/getDevicePVList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
		success: function(result) {
			console.log("장치목록 조회(PV)");
			callback_getDevicePVList(result);
		}
	});
}

//장치 상세 조회(PV)
function getDevicePVDetail(devicePvIdx) {
	$.ajax({
		url : "/getDevicePVDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			devicePvIdx : devicePvIdx
		},
		success: function(result) {
			console.log("장치 상세 조회(PV)");
			callback_getDevicePVDetail(result);
		}
	});
}

// 장치목록 조회(메인화면)
function getDeviceList(formData) {
	$.ajax({
		url : "/getDeviceList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("장치목록 조회");
			callback_getDeviceList(result);
		}
	});
}

// 장치그룹목록 조회
function getDeviceGroupList() {
	$.ajax({
		url : "/getDeviceGroupList",
		type : 'post',
		async : false, // 동기로 처리해줌
//		data : formData,
		success: function(result) {
			console.log("장치목록 조회");
			callback_getDeviceGroupList(result);
		}
	});
}

// 장치그룹내 장치목록 조회
function getDvInDeviceGroupList(deviceGrpIdx) {
	$.ajax({
		url : "/getDvInDeviceGroupList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			deviceGrpIdx : deviceGrpIdx
		},
		success: function(result) {
			console.log("장치목록 조회");
			callback_getDvInDeviceGroupList(result);
		}
	});
}

// 장지 등록
function insertDevice(formData) {
	$.ajax({
		url : "/insertDevice",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("장지 등록");
			callback_insertDevice(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}





// 알람 조회
function getAlarmList(formData) {
	$.ajax({
		url : "/getAlarmList",
//		url : "/getKepcoBillList_test",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("알람 조회");
			callback_getAlarmList(result);
		}
	});
}





// 한전 요금 조회
function getKepcoBillList(formData) {
	$.ajax({
		url : "/getKepcoBillList",
//		url : "/getKepcoBillList_test",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("한전 요금 조회");
			callback_getKepcoBillList(result);
		}
	});
}

// ESS 수익 조회
function getESSRevenueList(formData) {
	$.ajax({
		url : "/getESSRevenueList",
//		url : "/getESSRevenueList_test",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("ESS 수익 조회");
			callback_getESSRevenueList(result);
		}
	});
}

// PV 수익 조회
function getPVRevenueList(formData) {
	$.ajax({
		url : "/getPVRevenueList",
//		url : "/getPVRevenueList_test",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			console.log("PV 수익 조회");
			callback_getPVRevenueList(result);
		}
	});
}

// 수익 조회(메인화면)
function getRevenueList(formData) {
	$.ajax({
		url : "/getRevenueList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getRevenueList(result);
		}
	});
}





// 한전 계약 및 전력관리 정보 조회
function getSiteSetDetail() {
	$.ajax({
		url : "/getSiteSetDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
//		data : formData,
		success: function(result) {
			callback_getSiteSetDetail(result);
		}
	});
}

// 한전 계약 및 전력관리 정보 수정
function updateSiteSet(formData) {
	$.ajax({
		url : "/updateSiteSet",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_updateSiteSet(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 회사 목록 조회
function getCmpyList() {
	$.ajax({
		url : "/getCmpyList",
		type : 'post',
		async : false, // 동기로 처리해줌
//		data : formData,
		success: function(result) {
			callback_getCmpyList(result);
		}
	});
}

// 그룹 목록 조회
function getGroupList(selPageNum) {
	$.ajax({
		url : "/getGroupList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
		success: function(result) {
			callback_getGroupList(result);
		}
	});
}

// 사이트 목록 조회
function getSiteList(selPageNum) {
	$.ajax({
		url : "/getSiteList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
		success: function(result) {
			callback_getSiteList(result);
		}
	});
}

//그룹 목록(팝업) 조회
function getGroupPopupList() {
	$.ajax({
		url : "/getGroupPopupList",
		type : 'post',
		async : false, // 동기로 처리해줌
//		data : {
//			selPageNum : selPageNum
//		},
		success: function(result) {
			callback_getGroupPopupList(result);
		}
	});
}

//사이트 목록(팝업) 조회
function getSitePopupList(siteGrpIdx) {
	$.ajax({
		url : "/getSitePopupList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteGrpIdx : siteGrpIdx
		},
		success: function(result) {
			callback_getSitePopupList(result);
		}
	});
}

//그룹 한건 조회
function getGroupDetail(siteGrpIdx) {
	$.ajax({
		url : "/getGroupDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteGrpIdx : siteGrpIdx
		},
		success: function(result) {
			callback_getGroupDetail(result);
		}
	});
}

//사이트 한건 조회
function getSiteDetail(siteId) {
	$.ajax({
		url : "/getSiteDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteId : siteId
		},
		success: function(result) {
			callback_getSiteDetail(result);
		}
	});
}

// 그룹 등록
function insertGroup(formData) {
	$.ajax({
		url : "/insertGroup",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_insertGroup(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 사이트 등록
function insertSite(formData) {
	$.ajax({
		url : "/insertSite",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_insertSite(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 그룹 수정
function updateGroup(formData) {
	$.ajax({
		url : "/updateGroup",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_updateGroup(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 사이트 수정
function updateSite(formData) {
	$.ajax({
		url : "/updateSite",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_updateSite(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 그룹 삭제
function deleteGroup(siteGrpIdx) {
	$.ajax({
		url : "/deleteGroup",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteGrpIdx : siteGrpIdx
		},
		success: function(result) {
			callback_deleteGroup(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 사이트 삭제
function deleteSite(siteId) {
	$.ajax({
		url : "/deleteSite",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteId : siteId
		},
		success: function(result) {
			callback_deleteSite(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 사용자 목록 조회
function getUserList(selPageNum) {
	$.ajax({
		url : "/getUserList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
		success: function(result) {
			callback_getUserList(result);
		}
	});
}

// 사용자 한건 조회
function getUserDetail(userIdx) {
	$.ajax({
		url : "/getUserDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			userIdx : userIdx
		},
		success: function(result) {
			callback_getUserDetail(result);
		}
	});
}

// 사용자 등록
function insertUser(formData) {
	$.ajax({
		url : "/insertUser",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_insertUser(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 사용자 수정
function updateUser(formData) {
	$.ajax({
		url : "/updateUser",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_updateUser(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 사용자 삭제
function deleteUser(userIdx) {
	$.ajax({
		url : "/deleteUser",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			userIdx : userIdx
		},
		success: function(result) {
			callback_deleteUser(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

//================================================================================================
//====================================db(API data)조회 end==========================================
//================================================================================================
