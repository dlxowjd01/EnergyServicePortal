
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
			callback_getPeakRealList(result);
		}
	});
}
//
//// 한전계약전력 조회
//function getContractPowerList(formData) {
//	$.ajax({
//		url : "/getContractPowerList",
//		type : 'post',
//		async : false, // 동기로 처리해줌
//		data : formData,
//		success: function(result) {
//			callback_getContractPowerList(result);
//		}
//	});
//}
//
//// 요금적용전력 조회
//function getChargePowerList(formData) {
//	$.ajax({
//		url : "/getChargePowerList",
//		type : 'post',
//		async : false, // 동기로 처리해줌
//		data : formData,
//		success: function(result) {
//			callback_getChargePowerList(result);
//		}
//	});
//}

// ess 충방전량 조회
function getESSChargeRealList(formData) {
	$.ajax({
		url : "/getESSChargeRealList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getESSChargeRealList(result);
		}, error:function(request,status,error){
			error_getESSChargeRealList(request, status, error);
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
			callback_getESSChargeFutureList(result);
		}, error:function(request,status,error){
			error_getESSChargeFutureList(request, status, error);
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
			callback_getDeviceIOEList(result);
		}
	});
}

// 장치 상세 조회(IOE)
function getDeviceIOEDetail(siteId, deviceId, deviceType) {
	$.ajax({
		url : "/getDeviceIOEDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteId : siteId,
			deviceId : deviceId,
			deviceType : deviceType
		},
		success: function(result) {
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
			callback_getDevicePCSList(result);
		}
	});
}

//장치 상세 조회(PCS)
function getDevicePCSDetail(siteId, deviceId, deviceType) {
	$.ajax({
		url : "/getDevicePCSDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteId : siteId,
			deviceId : deviceId,
			deviceType : deviceType
		},
		success: function(result) {
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
			callback_getDeviceBMSList(result);
		}
	});
}

//장치 상세 조회(BMS)
function getDeviceBMSDetail(siteId, deviceId, deviceType) {
	$.ajax({
		url : "/getDeviceBMSDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteId : siteId,
			deviceId : deviceId,
			deviceType : deviceType
		},
		success: function(result) {
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
			callback_getDevicePVList(result);
		}
	});
}

//장치 상세 조회(PV)
function getDevicePVDetail(siteId, deviceId, deviceType) {
	$.ajax({
		url : "/getDevicePVDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteId : siteId,
			deviceId : deviceId,
			deviceType : deviceType
		},
		success: function(result) {
			callback_getDevicePVDetail(result);
		}
	});
}

// 장치목록 조회(메인화면)
function getDeviceList(selPageNum) {
	$("#selPageNum").val(selPageNum);
	var form = getSiteMainSchCollection();
	$.ajax({
		url : "/getDeviceList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : form,
		success: function(result) {
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
//		data : {
//			siteId : siteId
//		},
		success: function(result) {
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
			callback_getDvInDeviceGroupList(result, deviceGrpIdx);
		}
	});
}

// 장치그룹내 장치목록(팝업) 조회
function getDvInDeviceGroupPopupList(siteId, deviceGrpIdx) {
	$.ajax({
		url : "/getDvInDeviceGroupPopupList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			siteId : siteId,
			deviceGrpIdx : deviceGrpIdx
		},
		success: function(result) {
			callback_getDvInDeviceGroupPopupList(result);
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
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getAlarmList(result);
		}
	});
}





// 한전 요금 조회
function getKepcoBillList(formData) {
	$.ajax({
		url : "/getKepcoBillList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getKepcoBillList(result);
		}
	});
}

//한전 명세서 조회
function getKepcoTexBillList(formData) {
	$.ajax({
		url : "/getKepcoTexBillList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getKepcoTexBillList(result);
		}
	});
}


// ESS 수익 조회
function getESSRevenueList(formData) {
	$.ajax({
		url : "/getESSRevenueList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getESSRevenueList(result);
		}
	});
}
//ESS 명세서 조회
function getESSRevenueTexList(formData) {
	$.ajax({
		url : "/getESSRevenueTexList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getESSRevenueTexList(result);
		}
	});
}

// DR 수익 조회
function getDRRevenueList(formData) {
	$.ajax({
		url : "/getDRRevenueList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getDRRevenueList(result);
		}
	});
}

//DR 명세서 조회
function getDRRevenueTexList(formData) {
	$.ajax({
		url : "/getDRRevenueTexList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getDRRevenueTexList(result);
		}
	});
}

// PV 수익 조회
function getPVRevenueTexList(formData) {
	$.ajax({
		url : "/getPVRevenueTexList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getPVRevenueTexList(result);
		}
	});
}

//PV 명세서 조회
function getPVRevenueList(formData) {
	$.ajax({
		url : "/getPVRevenueList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getPVRevenueList(result);
		}
	});
}

// 수익 조회(메인화면)
function getRevenueList(formData) {
	$.ajax({
		url : "/getRevenueList",
		type : 'post',
//		async : false, // 동기로 처리해줌
		async : true, // 동기로 처리해줌
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
function getCmpyList(selPageNum) {
	$.ajax({
		url : "/getCmpyList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			selPageNum : selPageNum
		},
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

//회사 목록(팝업) 조회
function getCmpyPopupList() {
	$.ajax({
		url : "/getCmpyPopupList",
		type : 'post',
		async : false, // 동기로 처리해줌
//		data : {
//			selPageNum : selPageNum
//		},
		success: function(result) {
			callback_getCmpyPopupList(result);
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

//회사 한건 조회
function getCmpyDetail(compIdx) {
	$.ajax({
		url : "/getCmpyDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			compIdx : compIdx
		},
		success: function(result) {
			callback_getCmpyDetail(result);
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

function getPlanTypeVal(planType, planType2, planType3) {
	$.ajax({
		url : "/getPlanTypeVal",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			planType : planType,
			planType2 : planType2,
			planType3 : planType3,
		},
		success: function(result) {
			callback_getPlanTypeVal(result);
			
		}
	});
}


// 회사 등록
function insertCmpy(formData) {
	$.ajax({
		url : "/insertCmpy",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_insertCmpy(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 그룹 등록
function insertGroup(formData) {
	var form = new FormData($("#groupForm")[0]);
	$.ajax({
		url : "/insertGroup",
		type : 'post',
		processData : false,
		contentType : false,
//		async : false, // 동기로 처리해줌
		data : form,
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

// 회사 수정
function updateCmpy(formData) {
	$.ajax({
		url : "/updateCmpy",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_updateCmpy(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// 그룹 수정
function updateGroup(formData) {
	var form = new FormData($("#groupForm")[0]);
	$.ajax({
		url : "/updateGroup",
		type : 'post',
		processData : false,
		contentType : false,
//		async : false, // 동기로 처리해줌
		data : form,
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

// 회사 삭제
function deleteCmpy(compIdx) {
	$.ajax({
		url : "/deleteCmpy",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			compIdx : compIdx
		},
		success: function(result) {
			callback_deleteCmpy(result);
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

// 마지막에 추가된 사용자 한건 조회
function getLastUserDetail(userId) {
	$.ajax({
		url : "/getLastUserDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			userId : userId
		},
		success: function(result) {
			callback_getLastUserDetail(result);
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

//===== 군관리메인 조회 begin (greatman) =====

// 군관리 알람 조회
function getGMainAlarmList(formData) {
	$.ajax({
		url : "/getGMainAlarmList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getGMainAlarmList(result);
		}
	});
}

// 군관리 사이트 사용량 순위 총합
function getGMainSiteRankingTotalDetail() {
	$.ajax({
		url : "/getGMainSiteRankingTotalDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getGMainSiteRankingTotalDetail(result);
		}
	});
}

//군관리 사이트 사용량 순위
function getGMainSiteRankingList(selPageNum) {
	formData['selPageNum'] = selPageNum;
	$.ajax({
		url : "/getGMainSiteRankingList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getGMainSiteRankingList(result);
		}
	});
}

// 군관리 사이트 사용량 총합계 조회
function getGMainSiteTotalDetail(formData) {
	$.ajax({
		url : "/getGMainSiteTotalDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getGMainSiteTotalDetail(result);
		}
	});
}

// 군관리메인 지역별 사이트 건수 목록 조회
function getGMainAreaSiteCntList(formData) {
	$.ajax({
		url : "/getGMainAreaSiteCntList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getGMainAreaSiteCntList(result);
		}
	});
}

// 군관리 사이트 목록 조회
function getGMainSiteList(selPageNum) {
	formData['selPageNum'] = selPageNum;
	$.ajax({
		url : "/getGMainSiteList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getGMainSiteList(result);
		}
	});
}

// 군관리 사이트그룹 목록 조회
function getGMainGroupList(formData) {
	$.ajax({
		url : "/getGMainGroupList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getGMainGroupList(result);
		}
	});
}

//===== 군관리메인 조회 end (greatman) =====

//===== FAQ 조회 begin (greatman) =====

// FAQ 목록 조회
function getFAQList(formData) {
	$.ajax({
		url : "/getFAQList",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_getFAQList(result);
		}
	});
}

// FAQ 카테고리 한건 조회
function getFAQCateDetail(faqCateIdx) {
	$.ajax({
		url : "/getFAQCateDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			faqCateIdx : faqCateIdx
		},
		success: function(result) {
			callback_getFAQCateDetail(result);
		}
	});
}

// FAQ 한건 조회
function getFAQDetail(faqIdx) {
	$.ajax({
		url : "/getFAQDetail",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			faqIdx : faqIdx
		},
		success: function(result) {
			callback_getFAQDetail(result);
		}
	});
}

// FAQ 카테고리 등록
function insertFAQCate(formData) {
	$.ajax({
		url : "/insertFAQCate",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_insertFAQCate(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// FAQ 등록
function insertFAQ(formData) {
	$.ajax({
		url : "/insertFAQ",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_insertFAQ(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// FAQ 카테고리 수정
function updateFAQCate(formData) {
	$.ajax({
		url : "/updateFAQCate",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_updateFAQCate(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// FAQ 수정
function updateFAQ(formData) {
	$.ajax({
		url : "/updateFAQ",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : formData,
		success: function(result) {
			callback_updateFAQ(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// FAQ 카테고리 삭제
function deleteFAQCate(faqCateIdx) {
	$.ajax({
		url : "/deleteFAQCate",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			faqCateIdx : faqCateIdx
		},
		success: function(result) {
			callback_deleteFAQCate(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

// FAQ 삭제
function deleteFAQ(faqIdx) {
	$.ajax({
		url : "/deleteFAQ",
		type : 'post',
		async : false, // 동기로 처리해줌
		data : {
			faqIdx : faqIdx
		},
		success: function(result) {
			callback_deleteFAQ(result);
		},
		error:function(request,status,error){
			alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
		}
	});
}

//===== FAQ 조회 end (greatman) =====

// 세션 userInfo 조회
function getUserInfo(fn) {
	$.ajax({
		url : "/getUserInfo",
		type : 'post',
		async : false, // 동기로 처리해줌
		success: function(result) {
			fn(result);
		}
	});
}

//$( document ).ajaxStart(function() {
//	showHideLoadingBar("show");
// });
//
//$( document ).ajaxStop(function() {
//	setTimeout($.unblockUI, 2000); 
// });
//================================================================================================
//====================================db(API data)조회 end==========================================
//================================================================================================
