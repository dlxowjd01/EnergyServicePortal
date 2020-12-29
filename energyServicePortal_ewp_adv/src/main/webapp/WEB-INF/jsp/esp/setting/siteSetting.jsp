<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/weather_station_info.js"></script>
<script type="text/javascript">
	var deviceNameList = [];
	var alarmDataList = [];
	var deleteAlarmList = [];
	// const translate = {
	// 	contract1 : {
	// 		"주택용(저압)" : "1",
	// 		"주택용(고압)" : "2",
	// 		"일반용(갑)I" : "3",
	// 		"일반용(갑)II" : "4",
	// 		"일반용(을)" : "5",
	// 		"교육용(갑)" : "6",
	// 		"교육용(을)" : "7",
	// 		"산업용(갑)I" : "8",
	// 		"산업용(갑)II" : "9",
	// 		"산업용(을)" : "",
	// 		"임시(갑)" : "",
	// 		"임시(을)" : "",
	// 		"가로등(을)" : "",
	// 		"심야전력(갑)" : "",
	// 		"농사용(갑)" : "",
	// 		"농사용(을)" : "",
	// 		"심야전력(을)I" : "",
	// 		"심야전력(을)II" : "",
	// 	},
	// 	contract2 : {
	// 		"저압전력" : "",
	// 		"고압전력" : "",
	// 		"고압A" : "",
	// 		"고압B" : "",
	// 		"고압A:선택 I" : "",
	// 		"고압A:선택 II" : "",
	// 		"고압A:선택 III" : "",
	// 		"고압B:선택 I" : "",
	// 		"고압B:선택 II" : "",
	// 		"고압B:선택 III" : "",
	// 		"고압C:선택 I" : "",
	// 		"고압C:선택 II" : "",
	// 		"고압C:선택 III" : "",
	// 	}
	// }

	$(function () {
		let optionList = [
			{
				url: apiHost + "/config/sites?oid=" + oid + "&addCapacity=true&includeDevices=true",
				type: "get",
				async: true,
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
				},
			},
			{
				url: apiHost + "/auth/me/groups?includeSites=false&includeDevices=false",
				type: 'get',
				async: true
			},
			{
				url: apiHost + "/auth/me/sites?addCapacity=true",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/auth/me",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/config/view/device_properties?oid=" + oid,
				type: 'get',
				async: true
			},
		];

		initModal();

		if(role == 1){
			Promise.all([ makeAjaxCall(optionList[0]), makeAjaxCall(optionList[1]), makeAjaxCall(optionList[4]) ]).then( res => {
				deviceNameList = res[2];
				adminTable(res[0], res[1]);
			});
		} else {
			Promise.all([ makeAjaxCall(optionList[2]), makeAjaxCall(optionList[1]), makeAjaxCall(optionList[4]) , makeAjaxCall(optionList[3]) ]).then( res => {
				nonAdminTable( res[0], res[1], res[3].user_sites );
			});
		}

		// Validations
		$("#newSiteName").on("keydown", function(e) {;
			$("#invalidSite").addClass("hidden");
			validateForm();
		});

		$("#newSiteName").on("keyup", function() {
			let warning = $("#validSite").parent().find(".warning");
			let val = $(this).val();

			if(val.trim().match(/[.!#$%&'*+/=?^`{|}~]/g, "") ) {
				warning.eq(2).removeClass("hidden");
			} else {
				warning.eq(2).addClass("hidden");
			}

			if(val.length <= 1 || val.length > 30) {
				warning.eq(1).removeClass("hidden");
			} else {
				warning.eq(1).addClass("hidden");
			}

			if( warning.not(".hidden").index() == -1 ){
				$("#newSiteName").parent().next().prop("disabled", false);
			} else {
				$("#newSiteName").parent().next().prop("disabled", true);
			}
		});

		$("#newPriceModelList li").on("click", function() {
			let val = $(this).data("value");
			if(val == "fixed") {
				$("#newPrice").parent().removeClass("hidden");
			} else {
				$("#newPrice").parent().addClass("hidden");
			}
		});

		$("#newCoord").on("keyup", function(e) {
			// 	var re = /^[0-9] + (?:\,[0-9]+)*$/;
			if( $(this).val().match(/[^\x00-\x80]/) ){
				$(this).val("");
			}
		});

		$("#newDrVol").on("input", function() {
			let val = $(this).val();
			if(isNaN(val)){
				val = val.replace(/[^0-9\.\,]/g,'');
				if(val.split('.').length>2) 
					val =val.replace(/\.+$/,"");
			}
			$(this).val(val); 
		});

		$("#updateSiteForm").on("change", function(){
			if(!$(this).is(".edit")){
				validateForm();
			}
		});

		// Dropdown Click event
		$("#newResList li").on("click", function(){
			setTimeout(function(){
				validateForm();
			}, 300);
		});

		$("#newEssList li").on("click", function(){
			let val = $(this).data("value");
			$("#newEssList").prev().data("value", val);

			// if(val == "0"){
			// 	$("#newSiteType").prev().data({"value": "", "name" : ""}).prop("disabled", true).contents().get(0).nodeValue = "해당 사항 없음";
			// 	$("#newResList li").removeClass("hidden");
			// } else {
			// 	$("#newSiteType").prev().prop("disabled", false);
			// }
			
			// else {
			// 	$("#newSiteType").prev().prop("disabled", false).contents().get(0).nodeValue = "<fmt:message key="dropDown.select" />";
			// }
		});

		$("#newCityList li").on("click", function(){
			setTimeout(function(){
				validateForm();
			}, 600);
		});

		// Modal event
		$("#addSiteModal").on("hide.bs.modal", function() {
			$(this).hasClass("edit") ? $(this).removeClass("edit") : null;
			initModal();
		});

		$("#deleteConfirmBtn").click(function(){
			let dTable = $("#siteTable").DataTable();
			let tr = $("#siteTable").find("tbody tr.selected");
			let td = tr.find("td");
			let sid = dTable.row(tr).data().sid;
			let modalBody = $("#deleteConfirmModal .modal-body");

			if(td.eq(2).text() != $("#confirmSite").val()) return false;

			let optDelete = {
				url: apiHost + "/config/sites/" + sid,
				type: "delete",
				async: true,
			}

			$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("<fmt:message key='siteSetting.alert.1' />").removeClass("hidden");
				dTable.row(tr).remove().draw();
				// refreshSiteList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1000);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("<fmt:message key='siteSetting.alert.2' />\n<fmt:message key='siteSetting.alert.3' />").removeClass("hidden");
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
				console.log("fail==", jqXHR)
			});
		});

		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			$("#deleteSuccessMsg").html("<h5 id='deleteSuccessMsg' class='ntit'><fmt:message key='siteSetting.alert.4' /><br><span class='text-blue'></span>&ensp;<fmt:message key='siteSetting.alert.5' /></h5>");
			$("#confirmSite").val("");
			$("#deleteConfirmBtn").prop("disabled", true);
			setTimeout(function(){
				$(this).find(".modal-body").removeClass("hidden");
			}, 1600);
		});

		$("#addAlarmModal").on("hide.bs.modal", function() {
			$("#alarmTable").DataTable().clear().destroy();
		});
		// Site Form Submission !!!!!!!!!!!!!!!!!!!!!!!
		$("#updateSiteForm").on("submit", function(e){
			e.preventDefault();

			let newSiteName = $("#newSiteName").val();
			let newSiteType = Number($("#newSiteType").prev().data("value"));
			let newResTypeName = $("#newResList").prev().data("name");
			let newResType = Number($("#newResList").prev().data("value"));

			let newEss = Number($("#newEssList").prev().data("value"));
			let newCity = $("#newCityList").prev().data("value");

			let newSiteTypeName = $("#newSiteType").prev().data("name");
			let newStreetAddr= $("#newStreetAddr").val();
			let newCoord = $("#newCoord").val();
			let newSiteDetail = $("#newSiteDetail").val();

			// Utility
			let newUtilObj = {}
			let newUtilPlanId = 0;
			let newUtilPlanName = $("#newContractList").prev().data("value");
			let newVoltName = "";

			if( $("#newContractList").prev().data("vol-type") == null ) {
				newUtilPlanId = Number($("#newContractList").prev().data("plan-id"));
			} else {
				newUtilPlanId = Number($("#newVoltTypeList").prev().data("id"));
				newVoltName = $("#newVoltTypeList").prev().data("value");
			}

			let newPeakDemand = "";
			
			if(!isEmpty($("#newPeakDemand").val())){
				if ($("#newPeakDemand").val().indexOf(',') > -1) {
					newPeakDemand = ( parseFloat($("#newPeakDemand").val().replace(/,/g, "")) * 1000 );
				} else {
					newPeakDemand = ( parseFloat($("#newPeakDemand").val()) * 1000 );
				}
			}

			let newDrCharge = "";

			if(!isEmpty($("#newDrCharge").val())){
				if ($("#newDrCharge").val().indexOf(',') > -1) {
					newDrCharge = ( parseFloat($("#newDrCharge").val().replace(/,/g, "")) * 1000 );
				} else {
					newDrCharge = ( parseFloat($("#newDrCharge").val()) * 1000 );
				}
			}
			
			let newInspection = Number($("#newInspection").prev().data("value"));
			let newKepcoId = $("#newKepcoId").val();
			let newISmartId = $("#newISmartId").val();
			let newISmartPwd = $("#newISmartPwd").val();

			// Power Market
			let newPowerMarketObj = {}
			let newPowerModel = $("#newPriceModelList").prev().data("value");
			let newPrice = Number($("#newPrice").val());

			// DR
			// let newDrObj = {}
			// let newDrResId = $("#newDrResIdList").prev().data("value");
			// let newDrVol = "";
			// if ($("#newDrVol").val().indexOf(',') > -1) {
			// 	newDrVol = parseFloat($("#newDrVol").val().replace(/,/g, "")) * 1000;
			// } else {
			// 	newDrVol = $("#newDrVol").val();
			// }

			let newCblMethod = $("#newCblList").prev().data("value");
			let newDrRevShare = $("#newDrRevShare").val();

			// VPP
			let newVppObj = {}
			let newVppResId = $("#newVppResIdList").val();
			let newVppRevShare = $("#newVppRevShare").val();

			// AJAX callOption && FormData Obj
			let option = {};
			let siteObj = {};

			let newStationId, kpxGenId, kpxEmsId, kpxTransvol, gridX, gridY;

			newStationId = $('#station_id').val();
			gridX = $('#gridX').val();
			gridY = $('#gridY').val();

			if (oid.match('testkpx')) {
				kpxGenId = $('#kpx_genid').val();
				kpxEmsId = $('#kpx_emsid').val();
				kpxTransvol = $('#kpx_transvol').val();
			}

			// 1. ADD site info
			if(!$("#addSiteModal").hasClass("edit")) {
				let resultSuccessText = "<fmt:message key='siteSetting.alert.6' />";
				let resultFailText = "<fmt:message key='siteSetting.alert.7' /><br>";

				siteObj.name = newSiteName;
				siteObj.location = newCity;
				siteObj.resource_type = newResType;

				if( isEmpty(newEss) ){
					siteObj.ess = newEss;
				}

				// if( !isEmpty(newSiteType) ){
				// 	siteObj.ess = newSiteType;
				// }
				if( !isEmpty(newCoord) ){
					siteObj.latlng = newCoord;
				}

				siteObj.tz = "Asia/Seoul";

				if( !isEmpty(newStreetAddr) ){
					siteObj.address = newStreetAddr;
				}
				if( !isEmpty(newSiteDetail) ){
					siteObj.detail_info = newSiteDetail;
				}
				// if( !isEmpty(newDrResId) ){
				// 	siteObj.dr_group_id = newDrResId;
				// }
				if( !isEmpty(newVppResId) ){
					siteObj.vpp_group_id = newVppResId;
				}
				if ( !isEmpty(newStationId) ) {
					siteObj.station_id = Number(newStationId);
				}

				if ( !isEmpty(gridX) ) {
					siteObj.grid_x = Number(gridX);
				}

				if ( !isEmpty(gridY) ) {
					siteObj.grid_y = Number(gridY);
				}

				if (oid.match('testkpx')) {
					if ( !isEmpty(kpxGenId) ) {
						siteObj.kpx_genid = kpxGenId;
					}
					if ( !isEmpty(kpxEmsId) ) {
						siteObj.kpx_emsid = kpxEmsId;
					}
					if ( !isEmpty(kpxTransvol) ) {
						siteObj.kpx_transvol = kpxTransvol;
					}
				}

				// Util JSON
				if( !isEmpty(newUtilPlanId) ){
					newUtilObj.utility_plan_id = newUtilPlanId;
					newUtilObj.utility_plan_name = newUtilPlanName;
					if( !isEmpty(newVoltName)){
						newUtilObj.volt_name = newVoltName;
					}
				}
				if( !isEmpty(newPeakDemand) ){
					newUtilObj.peak_demand = newPeakDemand;
				}
				if( !isEmpty(newPeakDemand) ){
					newUtilObj.demand_charge = newDrCharge;
				}
				if( !isEmpty(newInspection) ){
					newUtilObj.metering_day = newInspection;
				}
				if( !isEmpty(newKepcoId) ){
					newUtilObj.kepco_id = newKepcoId;
				}
				if( !isEmpty(newISmartId) ){
					newUtilObj.ismart_id = newISmartId;
				}
				if( !isEmpty(newISmartPwd) ){
					newUtilObj.ismart_pass = newISmartPwd;
				}
				if( !isEmpty(newUtilObj) ){
					siteObj.utility = JSON.stringify(newUtilObj);
				}

				// Power Market JSON
				if( !isEmpty(newPowerModel) ){
					newPowerMarketObj.price_type = newPowerModel;
					if( !isEmpty(newPrice) ){
						newPowerMarketObj.price = newPrice;
					}
				}
				if( !isEmpty(newPowerMarketObj) ){
					siteObj.power_market = JSON.stringify(newPowerMarketObj);
				}

				// DR JSON
				// if( !isEmpty(newDrVol) ){
				// 	newDrObj.contract_capacity = newDrVol;
				// }
				// if( !isEmpty(newCblMethod) ){
				// 	newDrObj.cbl_method = newCblMethod;
				// }
				// if( !isEmpty(newDrRevShare) ){
				// 	newDrObj.cbl_method = newDrRevShare;
				// }
				// if( !isEmpty(newDrObj) ){
				// 	siteObj.dr_info = JSON.stringify(newDrObj);
				// }

				// VPP JSON

				if( !isEmpty(newVppRevShare) && newVppRevShare != "-"){
					newVppObj.profile_share = newVppRevShare;
				}
				if( !isEmpty(newVppObj) ){
					siteObj.vpp_info = JSON.stringify(newVppObj);
				}

				option = {
					url: apiHost + '/config/sites?oid=' + oid,
					type: 'post',
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(siteObj)
				}

				$.ajax(option).done(function (json, textStatus, jqXHR) {
					showAjaxResultModal("ajaxResultModal", "addSiteModal", "1", resultSuccessText);
					refreshSiteList();
				}).fail(function (jqXHR, textStatus, errorThrown) {
					let errorMsg = resultFailText + "<fmt:message key='siteSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='siteSetting.msg' />: " + jqXHR.responseText;
					showAjaxResultModal("ajaxResultModal", "addSiteModal", "0", errorMsg);
				});

			} else {
				// 2. EDIT site info
				let resultSuccessText = "<fmt:message key='siteSetting.alert.8' />";
				let resultFailText = "<fmt:message key='siteSetting.alert.9' />.<br>";

				let dTable = $("#siteTable").DataTable();
				let tr = $("#siteTable").find("tbody tr.selected");
				let td = tr.find("td");
				let sid = dTable.row(tr).data().sid;

				let siteEditObj = {};

				if( !isEmpty(newSiteName) && ( td.eq(2).text() != newSiteName ) ){
					siteEditObj.name = newSiteName;
				}
				// if( !isEmpty(newSiteType) && ( td.eq(1).text() != newSiteTypeName ) ){
				// 	siteEditObj.ess = newSiteType;
				// }
				if( !isEmpty(newResType) && ( td.eq(4).text() != newResTypeName ) ){
					siteEditObj.resource_type = newResType;
				}
				if( !isEmpty(newCoord) ){
					siteEditObj.latlng = newCoord;
				}

				if (!isEmpty(newEss)) {
					siteEditObj.ess = newEss;
				}

				// if( !isEmpty(systemLocale)){
				// 	siteObj.tz = "systemLocale";
				// }

				if (!isEmpty(newCity)) {
					siteEditObj.location = newCity;
				}

				if( !isEmpty(newStreetAddr)){
					siteEditObj.address = newStreetAddr;
				}
				if( !isEmpty(newSiteDetail)){
					siteEditObj.detail_info = newSiteDetail;
				}
				// if( !isEmpty(newDrResId) && td.eq(8).text() != newDrResId ){
				// 	siteEditObj.dr_group_id = newDrResId;
				// }
				if( !isEmpty(newVppResId) && td.eq(9).text() != newVppResId ){
					siteEditObj.vpp_group_id = newVppResId;
				}
				if ( !isEmpty(newStationId) ) {
					siteEditObj.station_id = Number(newStationId);
				}

				if ( !isEmpty(gridX) ) {
					siteEditObj.grid_x = Number(gridX);
				}

				if ( !isEmpty(gridY) ) {
					siteEditObj.grid_y = Number(gridY);
				}

				if (oid.match('testkpx')) {
					if ( !isEmpty(kpxGenId) ) {
						siteEditObj.kpx_genid = kpxGenId;
					}
					if ( !isEmpty(kpxEmsId) ) {
						siteEditObj.kpx_emsid = kpxEmsId;
					}
					if ( !isEmpty(kpxTransvol) ) {
						siteEditObj.kpx_transvol = kpxTransvol;
					}
				}
				// Util JSON
				if( !isEmpty(newUtilPlanId) ){
					newUtilObj.utility_plan_id = newUtilPlanId;
					newUtilObj.utility_plan_name = newUtilPlanName;
					if( !isEmpty(newVoltName) ){
						newUtilObj.volt_name = newVoltName;
					}
				}

				if( !isEmpty(newPeakDemand) ){
					newUtilObj.peak_demand = newPeakDemand;
				}
				if( !isEmpty(newPeakDemand) ){
					newUtilObj.demand_charge = newDrCharge;
				}
				if( !isEmpty(newInspection) ){
					newUtilObj.metering_day = newInspection;
				}
				if( !isEmpty(newKepcoId) ){
					newUtilObj.kepco_id = newKepcoId;
				}
				if( !isEmpty(newISmartId) ){
					newUtilObj.ismart_id = newISmartId;
				}
				if( !isEmpty(newISmartPwd) ){
					newUtilObj.ismart_pass = newISmartPwd;
				}
				if( !isEmpty(newUtilObj) ){
					siteEditObj.utility = JSON.stringify(newUtilObj);
				}

				// Power Market JSON
				if( !isEmpty(newPowerModel) ){
					newPowerMarketObj.price_type = newPowerModel;
					if( !isEmpty(newPrice) ){
						newPowerMarketObj.price = newPrice;
					}
				}
				if( !isEmpty(newPowerMarketObj) ){
					siteEditObj.power_market = JSON.stringify(newPowerMarketObj);
				}

				// DR JSON
				// if( !isEmpty(newDrVol) ){
				// 	newDrObj.contract_capacity = newDrVol;
				// }
				// if( !isEmpty(newCblMethod) ){
				// 	newDrObj.cbl_method = newCblMethod;
				// }
				// if( !isEmpty(newDrRevShare) ){
				// 	newDrObj.cbl_method = newDrRevShare;
				// }
				// if( !isEmpty(newDrObj) ){
				// 	siteEditObj.dr_info = JSON.stringify(newDrObj);
				// }

				// VPP JSON

				if( !isEmpty(newVppRevShare) ){
					newVppObj.profile_share = newVppRevShare;
				}
				if( !isEmpty(newVppObj) ){
					siteEditObj.vpp_info = JSON.stringify(newVppObj);
				}

				// console.log('siteEditObj===', siteEditObj)
				option = {
					url: apiHost + "/config/sites/" + sid,
					type: 'patch',
					async: true,
					data: JSON.stringify(siteEditObj),
					contentType: 'application/json; charset=UTF-8',
				}

				$.ajax(option).done(function (json, textStatus, jqXHR) {
					showAjaxResultModal("ajaxResultModal", "addSiteModal", "1", resultSuccessText);
					refreshSiteList();
				}).fail(function (jqXHR, textStatus, errorThrown) {
					let errorMsg = resultFailText + "<fmt:message key='siteSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='siteSetting.msg' />: " + jqXHR.responseText;
					showAjaxResultModal("ajaxResultModal", "addSiteModal", "0", errorMsg);
				});

			}
		});

		// Alarm Form Submission !!!!!!!!!!!!!!!!!!!!!!
		$("#updateAlarmForm").on("submit", function(e){
			e.preventDefault();
			let resultSuccessText = "<fmt:message key='siteSetting.alert.10' />";
			let resultFailText = "<fmt:message key='siteSetting.alert.11' /><br>";

			let aTable = $("#alarmTable").DataTable();
			let tr = $("#alarmTable tbody tr:not(.hidden)");

			let urlPrefix = apiHost + "/config/devices/";
			let deviceOpt = {
				type: 'patch',
				async: true,
				contentType: 'application/json; charset=UTF-8',
			};
			var dvcArr = [];		
			let ajaxPromises = [];
			let deletePromises = [];

			// A. [DELETE] existing alarm data
			if(deleteAlarmList.length>0){
				let obj = {...deviceOpt};

				deleteAlarmList.forEach(function(item, index){
					obj.url = apiHost + "/config/devices/" + item.deviceId;
					obj.data = JSON.stringify({ alarm_to : null });
					deletePromises.push(makeAjaxCall(obj));
				});
				Promise.all(deletePromises).then(res => {
					console.log("existing alarm info successfully deleted ====>", res);
				}).catch( err => {
					console.log("cannot delete existing alarm info", err);
				});
			}

			// B-1. [Loop through] newly edited/added alarm data && [PUSH] to [dvcArr]
			for(let i=0, arrLength = tr.length; i < arrLength; i++){
				let td = tr.eq(i).find("td"); 
				let secondTd = td.eq(1); 
				let dvcNameDropdown = secondTd.find(".dropdown-toggle");
		
				if(!isEmpty(dvcNameDropdown)){
					for(let j=0, arrLength = dvcNameDropdown.length; j < arrLength; j++){
						let selectedDvcArr = dvcNameDropdown.eq(j).next().find("input[type='checkbox']:checked");

						if(!dvcNameDropdown.eq(j).is(":disabled") && selectedDvcArr.length >0 ){ 
							let alarmToObj = {};
							let alarmLvl = td.eq(2).find(".dropdown-toggle").eq(j);
							let userGroup = td.eq(3).find(".user-group").eq(j);
							let phoneGroup = td.eq(4).find(".phone-group").eq(j);
							let alarmLvlArr = [];
							let nonUserArr = [];
							let registeredUserArr = [];

							let selectedLevel = alarmLvl.next().find("input[type='checkbox']:checked");
							let selectedUser = userGroup.find(".dropdown-menu input[type='checkbox']:checked");
							
							let nonUserObj = {};

							let nonUserEl = userGroup.find(".text-input-type[data-user-type='non-user']");
							let prevNonUserNameStr = !isEmpty(nonUserEl.data("name-list")) ? String(nonUserEl.data("name-list")) : null;
							let prevNonUserPhoneStr = !isEmpty(nonUserEl.data("phone-list")) ? String(nonUserEl.data("phone-list")) : null;
							let newNonUserName = nonUserEl.find("input").val();

							let newNonUserPhone = phoneGroup.find(".text-input-type[data-user-type='non-user'] input").val();

							$.each(selectedLevel, function(){
								alarmLvlArr.push(Number($(this).val()));
							});

							// 1. user (alarm_to)
							if(selectedUser.length > 0 ){
								selectedUser.each(function(index, el){
									let userObj = {};
									userObj.uid = $(this).val();
									userObj.level = alarmLvlArr;
									registeredUserArr.push(userObj);
								});
							}

							// 2. previously added non_user (alarm_to)
							if(!isEmpty(prevNonUserNameStr) || !isEmpty(prevNonUserPhoneStr)) {
								console.log("prevNonUserNameStr===", prevNonUserNameStr);
								console.log("prevNonUserPhoneStr===", prevNonUserPhoneStr);

								let tempNameArr = [];
								let tempPhoneArr = [];

								if(!isEmpty(prevNonUserNameStr)){
									if(prevNonUserNameStr.includes(",")){
										tempNameArr = prevNonUserNameStr.split(",");
									} else {
										tempNameArr = [prevNonUserNameStr];
									}
								}

								if(!isEmpty(prevNonUserPhoneStr)) {
								// if(prevNonUserPhoneStr !== 'undefined'){
									if(prevNonUserPhoneStr.includes(",")){
										tempPhoneArr = prevNonUserPhoneStr.split(",");
									} else {
										tempPhoneArr = [prevNonUserPhoneStr];
									}
								}

								if(tempNameArr.length>0 || tempPhoneArr.length>0){
									console.log("tempNameArr===", tempNameArr);
									console.log("tempPhoneArr===", tempPhoneArr);

									let maxLength = (tempNameArr.length > tempPhoneArr.length) ? tempNameArr.length : tempPhoneArr.length; 
									for(let i = 0; i < maxLength; i++){
										nonUserObj.name = tempNameArr[i];
										nonUserObj.phone = tempPhoneArr[i];
										nonUserObj.level = alarmLvlArr;
										nonUserArr.push(nonUserObj);
									}
								}
								if( !isEmpty(newNonUserName) && !isEmpty(newNonUserPhone) ) {
									nonUserObj.name = newNonUserName;
									nonUserObj.phone = newNonUserPhone;
									nonUserObj.level = alarmLvlArr;
									nonUserArr.push(nonUserObj);
								} else {
									if(!isEmpty(newNonUserName)){
										nonUserObj.name = newNonUserName;
										nonUserObj.level = alarmLvlArr;
										nonUserArr.push(nonUserObj);
									}
									if(!isEmpty(newNonUserPhone) ){
										nonUserObj.phone = newNonUserPhone;
										nonUserObj.level = alarmLvlArr;
										nonUserArr.push(nonUserObj);
									}
								}
								
							} else {
								if( !isEmpty(newNonUserName) && !isEmpty(newNonUserPhone) ) {
									nonUserObj.name = newNonUserName;
									nonUserObj.phone = newNonUserPhone;
									nonUserObj.level = alarmLvlArr;
									nonUserArr.push(nonUserObj);
								} else {
									if(!isEmpty(newNonUserName)){
										nonUserObj.name = newNonUserName;
										nonUserObj.level = alarmLvlArr;
										nonUserArr.push(nonUserObj);
									}
									if(!isEmpty(newNonUserPhone) ){
										nonUserObj.phone = newNonUserPhone;
										nonUserObj.level = alarmLvlArr;
										nonUserArr.push(nonUserObj);
									}
								}
							}

							// [Loop] selected devices
							$.each(selectedDvcArr, function(index, el){
								let checkedId = $(el).val();
								if(dvcArr.length>0){
									let found = dvcArr.findIndex( x =>  x.deviceId == checkedId);
									if(found > -1){
										// if Both non_user && user
										if(nonUserArr.length>0 && registeredUserArr.length>0){
											let valArr1 = [];
											let valArr2 = [];
											// user of checked device
											if(!isEmpty(dvcArr[found].alarm_to.user)){
												let prevArr = dvcArr[found].alarm_to.user;
												valArr1 = [...prevArr, ...registeredUserArr];
												// let tempArr = getUnique(valArr1, 'uid', 'level');
												// console.log("user unique uid====", tempArr);
											} else {
												valArr1.push(...registeredUserArr);
											}
											// non_user of checked device
											if(!isEmpty(dvcArr[found].alarm_to.non_user)){
												let prevArr = dvcArr[found].alarm_to.non_user;
												let tempArr = [...prevArr, ...nonUserArr];
												let filtered = tempArr.filter((v,i,a) => a.findIndex( t => t.phone === v.phone) === i );

												filtered.map((v,i,a) => {
													let obj = {};
													tempArr.map( t => {
														if(t.phone == v.phone){
															obj.phone = v.phone;
															obj.name = v.name;
															obj.level = [...new Set([...v.level, ...t.level])];
															return obj;
														}
													});
													return valArr2.push(obj);
												});
											} else {
												valArr2.push(...nonUserArr);
											}

											if(!isEmpty(dvcArr[found].deviceId)){
												dvcArr[found].alarm_to.push({ user: valArr1, non_user: valArr2 })
											} else {
												dvcArr[found] = {
													deviceId: checkedId,
													alarm_to: { non_user: valArr2 }
												}
											}
											// dvcArr[found] = {
											// 	deviceId: checkedId,
											// 	alarm_to: {
											// 		user: valArr1,
											// 		non_user: valArr2
											// 	}
											// }
										} else {
											if(nonUserArr.length>0){
												let valArr = [];
												if(!isEmpty(dvcArr[found].alarm_to.non_user)){
													let prevArr = dvcArr[found].alarm_to.non_user;
													let tempArr = [...prevArr, ...nonUserArr];
													let filtered = tempArr.filter((v,i,a) => a.findIndex( t => t.phone === v.phone) === i );

													filtered.map((v,i,a) => {
														let obj = {};
														tempArr.map( t => {
															if(t.phone == v.phone){
																obj.phone = v.phone;
																obj.name = v.name;
																obj.level = [...new Set([...v.level, ...t.level])];
																return obj;
															}
														});
														return valArr.push(obj);
													});
												} else {
													valArr.push(...nonUserArr);
												}

												// console.log("valArr===", valArr);
												if(!isEmpty(dvcArr[found].deviceId)){
													dvcArr[found].alarm_to.non_user = valArr;
												} else {
													dvcArr[found] = {
														deviceId: checkedId,
														alarm_to: { non_user: [...valArr] }
													}
												}
											}
											if(registeredUserArr.length>0){
												let valArr = [];
												if(!isEmpty(dvcArr[found].alarm_to.user)){
													let prevArr = dvcArr[found].alarm_to.user;
													valArr = [...prevArr, ...registeredUserArr];
												} else {
													valArr.push(...registeredUserArr);
												}
												if(!isEmpty(dvcArr[found].deviceId)){
													dvcArr[found].alarm_to.user = valArr;
												} else {
													dvcArr[found] = {
														deviceId: checkedId,
														alarm_to: { user: valArr }
													}
												}
												// dvcArr[found] = {
												// 	deviceId: checkedId,
												// 	alarm_to: {
												// 		user: valArr
												// 	}
												// }
											}
										}
									} else {
										if(nonUserArr.length>0 && registeredUserArr.length>0){
											let obj = {
												deviceId: checkedId,
												alarm_to: { user: registeredUserArr, non_user: nonUserArr }
											}
											dvcArr.push(obj);
										} else {
										// if selected deviceId is not in the dvcArr
											console.log("nonUserArr===", nonUserArr);

											if(nonUserArr.length>0){
												let obj = {
													deviceId: checkedId,
													alarm_to: { non_user: nonUserArr }
												}
												dvcArr.push(obj);
											}

											if(registeredUserArr.length>0){
												let obj = {
													deviceId: checkedId,
													alarm_to: { user: registeredUserArr }
												}
												dvcArr.push(obj);
											}
										}
									}								
								} else {
									console.log("nonUserArr===", nonUserArr);
									let obj = {};
									if(nonUserArr.length>0 && registeredUserArr.length>0) {
										obj.deviceId = $(el).val();
										obj.alarm_to = {
											non_user: nonUserArr,
											user: registeredUserArr
										}
									} else {
										if(nonUserArr.length>0){
											obj.deviceId = $(el).val();
											obj.alarm_to = { non_user: [...nonUserArr] }
										}
										if(registeredUserArr.length>0){
											obj.deviceId = checkedId;
											obj.alarm_to = { user: registeredUserArr }	
										}
									}
									dvcArr.push(obj);
									// console.log("checkedId===", checkedId);
									// console.log("nonUserArr===", nonUserArr);
								}
							});
						}
					}
				}
			}

			if(dvcArr.length>0){
			// B-2. [JSON stringify] newly edited/added alarm data
				dvcArr.forEach(function(item, index){
					deviceOpt.url = urlPrefix + item.deviceId;
					deviceOpt.data = JSON.stringify({ alarm_to: JSON.stringify(item.alarm_to) });
					ajaxPromises.push(makeAjaxCall(deviceOpt));
					// console.log("deviceOpt===", deviceOpt);
				});
				// B-3. [RESULT] CLOSE Alarm modal & refresh data
				Promise.all(ajaxPromises).then(res => {
					showAjaxResultModal("ajaxResultModal", "addAlarmModal", "1", resultSuccessText);
					$("#siteTable").DataTable().clear().destroy();
					$("#alarmTable").DataTable().clear().destroy();
					setTimeout(function(){
						refreshSiteList();
					}, 200);
				}).catch( err => {
					console.log("cannot delete existing alarm info", err);
					let errorMsg = resultFailText + "<fmt:message key='siteSetting.errorMsg' />:" + err;
					showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
				});
			} else {
			// C. [[RESULT] CLOSE Alarm modal & refresh data
				showAjaxResultModal("ajaxResultModal", "addAlarmModal", "1", resultSuccessText);
				$("#siteTable").DataTable().clear().destroy();
				$("#alarmTable").DataTable().clear().destroy();
				setTimeout(function(){
					refreshSiteList();
				}, 200);
			}
		});


	});

	
	function refreshSiteList(){
		let optionList = [
			{
				url: apiHost + "/config/sites?oid=" + oid + "&addCapacity=true&includeDevices=true",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/auth/me/groups?includeSites=false&includeDevices=false",
				type: 'get',
				async: true
			},
			{
				url: apiHost + "/auth/me/sites?addCapacity=true",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/auth/me",
				type: "get",
				async: true,
			},
		];

		if(role == 1){
			Promise.all([ makeAjaxCall(optionList[0]), makeAjaxCall(optionList[1]) ]).then( res => {
				adminTable(res[0], res[1], initModal);
			});
		} else {
			Promise.all([ makeAjaxCall(optionList[2]), makeAjaxCall(optionList[1]) ]).then( res => {
				nonAdminTable( res[0], res[1], res[2].user_sites, initModal);
			});
		}

	}

	function adminTable(siteData, vppNameData, callback) {
		if(isEmpty(callback)) {
			getPropertyData();
			getVppDrData(vppNameData);
		} else {
			callback();
		}

		if(siteData) {
			const newArr = siteData.map((item, index) => {
				$("#loadingCircle").show();
				if(isEmpty(item.ess) || item.ess === 0){
					item.ess == "-"
				} else {
					if(item.ess === 1){
						item.ess = "DemandESS"
					} else if(item.ess === 2){
						item.ess = "GenerationESS"
					}
				}

				if(item.resource_type === 0) {
					// Demand && ESS : pair
					item.siteType = "<fmt:message key='siteSetting.needsResource' />"
					item.powerSource = "<fmt:message key='siteSetting.burden' />"
				} else {
					if(isEmpty(item.resource_type)){
						item.siteType = "-"
					} else {
						item.siteType = "<fmt:message key='siteSetting.plant' />"
						if(item.resource_type === 1){
							item.powerSource = "<fmt:message key='siteSetting.solar' />"
						} else if(item.resource_type === 2){
							item.powerSource = "<fmt:message key='siteSetting.windPower' />"
						} else if(item.resource_type === 3){
							item.powerSource = "<fmt:message key='siteSetting.smallHydro' />"
						}
					}
				}

				// Match name with dr_group_id
				if(!isEmpty(item.dr_group_id)){
					let found = vppNameData.dr_group.findIndex( x => x.dgid == item.dr_group_id);
					if(found > -1){
						item.drName = vppNameData.dr_group[found].name;
					}
				} else {
					item.drName = "-"
				}

				// Match name with vpp_group_id
				if(!isEmpty(item.vpp_group_id)){
					let found = vppNameData.vpp_group.findIndex( x => x.vgid == item.vpp_group_id);
					if(found > -1){
						item.vppName = vppNameData.vpp_group[found].name;
					}
				} else {
					item.vppName = "-"
				}
				item.updatedAt = new Date(item.updatedAt).format('yyyy-MM-dd HH:mm:ss');
				return item
			});

			// console.log("response===", response)
			// 1. 사업소 유형
			// 2. 사업소명
			// 3. 지역
			// 4. 발전원 => 0: MicroGrid, 1: photovoltaic, 2: wind, 3: SmallHydro (hydroelectric power for local community)
			// 5. 발전 용량
			// 6. ESS 용량 (PCS)
			// 7. ESS 용량 (BMS)
			// 8. DR 자원 코드 => 이름
			// 9. Vpp 자원 코드 ( virtual power plant )  => 이름
			// 10. 수정/조회 권한
			// 11. 알람 설정
			var siteTable = $('#siteTable').DataTable({
				"aaData": newArr,
				"destroy": true,
				// "retrieve": true,
				"table-layout": "fixed",
				"fixedHeader": true,
				// "bAutoWidth": true,
				"bSearchable" : true,
				// "scrollX": true,
				// "sScrollX": "100%",
				// "sScrollXInner": "100%",
				"sScrollY": true,
				"scrollY": "720px",
				"bScrollCollapse": true,
				"pageLength": 100,
				// "bFilter": false, disabling this option will prevent table.search()
				"aaSorting": [[ 0, 'asc' ]],
				"bSortable": true,
				"order": [[ 1, 'asc' ]],
				"aoColumnDefs": [
					{
						"aTargets": [ 0 ],
						"bSortable": false,
						"orderable": false
					},
					{
						"aTargets": [ 1 ],
						"createdCell":  function (td, cellData, rowData, row, col) {
							// if(row.siteType == "Demand"){
							// 	$(td).attr('data-value', 0); 
							// } else {
							// 	$(td).attr('data-value', 1); 
							// }
								// console.log("td===", td)
							if(rowData.resType == "Demand"){
								$(td).attr('data-value', 0);
							} else {
								$(td).attr('data-value', 1);
							}
							// rowData.deviceTypeKr = rowData.device_type_kr;
						}
					},
					{
						"aTargets": [ 4 ],
						"createdCell":  function (td, cellData, rowData, row, col) {
							if(rowData.powerSource == "<fmt:message key='siteSetting.burden' />"){
								$(td).attr('data-value', 0);
							} else if(rowData.powerSource == "<fmt:message key='siteSetting.solar' />"){
								$(td).attr('data-value', 1);
							} else if(rowData.powerSource == "<fmt:message key='siteSetting.windPower' />"){
								$(td).attr('data-value', 2);
							} else if(rowData.powerSource == "<fmt:message key='siteSetting.smallHydro' />"){
								$(td).attr('data-value', 3);
							}
						}
					},
					// {
					// 	"aTargets": [ 10 ],
					// 	"createdCell":  function (td, cellData, rowData, row, col) {
					// 		console.log('rowData---', rowData.deviceAlarm)
					// 	}
					// },
				],
				"aoColumns": [
					{
						"sTitle": "",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							return '<a class="chk-type" href="#"><input type="checkbox" id="' + rowIndex.row + '" name="table_checkbox"><label for="' + rowIndex.row + '"></label></a>'
						},
						"className": "dt-body-center no-sorting"
					},
					// {
					// 	"sTitle": "순번",
					// 	"mData": null,
					// 	"className": "dt-center no-sorting"
					// },
					{
						"sTitle": "<fmt:message key='siteSetting.site.type' />",
						"mData": "siteType",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.site.name' />",
						"mData": "name"
					},
					{
						"sTitle": "<fmt:message key='siteSetting.location' />",
						"mData": "location",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.resource' />",
						"mData": "powerSource",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.capacity' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let val = displayNumberFixedDecimal(full.capacities.gen, 'W', 3, 2);
							return (data.capacities.gen != 0) ? (val[0] + ' ' + val[1]) : "0"
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.ESSPCS.capacity' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let val = displayNumberFixedDecimal(full.capacities.bat_pcs, 'W', 3, 2);
							return (full.capacities.bat_pcs != 0) ? (val[0] + ' ' + val[1]) : "0"
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.ESSBMS.capacity' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let val = displayNumberFixedDecimal(full.capacities.bat_bms, 'W', 3, 2);
							return (full.capacities.bat_bms != 0) ? (val[0] + ' ' + val[1]) : "0"
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.DR.resourceID' />",
						"mData": "drName",
						visible: false
					},
					{
						"sTitle": "<fmt:message key='siteSetting.VPP.resourceID' />",
						"mData": "vppName",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.alarm.receive' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							// return '<button type="button" class="btn-type-sm btn-type03">알람</button>'
							if(!isEmpty(full.devices) && full.devices.length>0){
								return "<button type='button' class='btn-type-sm btn-type03'><fmt:message key='siteSetting.alarm' /></button>"
							} else {
								return "<button type='button' class='btn-type-sm btn-type03' disabled><fmt:message key='siteSetting.alarm' /></button>"
							}
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.update.date' />",
						"mData": "updatedAt",
					},
				],
				"dom": 'tip',
				"select": {
					style: 'single',
					// selector: 'td input[type="checkbox"], tr'
					selector: 'td input[type="checkbox"], td:not(:nth-of-type(11))'
				},
				"language": {
					"paginate": {
						"previous": "",
						"next": "",
					},
					"info": "_PAGE_ - _PAGES_ " + " / <fmt:message key='table.totalCase.start' /> _TOTAL_ <fmt:message key='table.totalCase.end' />",
					"select": {
						"rows": {
							_: "",
							1: ""
						}
					}
				},
				initComplete: function(settings, json ){
					let str = `<div id="btnGroup" class="right-end"><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')"><fmt:message key='siteSetting.updateSelected' /></button><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')"><fmt:message key='siteSetting.deleteSelected' /></button><!--
					--></div>`;

					let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')"><fmt:message key='siteSetting.add' /></button>`;
					$("#siteTable_wrapper").append($(str)).prepend($(addBtnStr));
					if(oid.match("testkpx")){
						let colGroup = $("#siteTable").find("colgroup col");
						this.api().columns([8,9]).visible( false );
						colGroup.eq(8).addClass("hidden");
						colGroup.eq(9).addClass("hidden");
					}
					this.api().columns().header().each ((el, i) => {
						if(i == 0){
							$(el).attr ('style', 'min-width: 50px');
						}
					});
				},
				// every time DataTables performs a draw
				drawCallback: function (settings) {
					$('#siteTable_wrapper').addClass('mb-28');
				}
			}).on("select", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn-type03");
				btn.each(function(index, element){
					if($(this).is(":disabled")){
						$(this).prop("disabled", false);
					}
				});
				siteTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
				// console.log("dt---", siteTable[ type ]( indexes ).nodes())
			}).on("deselect", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn-type03");
				btn.each(function(index, element){
					if(!$(this).is(":disabled")){
						$(this).prop("disabled", true);
					}
				});
				siteTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
				// console.log("dt---", siteTable[ type ]( indexes ).nodes())
			}).columns.adjust().draw();
			// siteTable.on( 'order.dt search.dt', function () {
			// 	siteTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
			// 		cell.innerHTML = i+1;
			// 		$(cell).data("id", i)
			// 	});
			// }).draw();

			$('#siteTable').find("input:checkbox").on('click', function() {
				var $box = $(this);
				if ($box.is(":checked")) {
					var group = "input:checkbox[name='" + $box.attr("name") + "']";
					$(group).prop("checked", false);
					$box.prop("checked", true);
				} else {
					$box.prop("checked", false);
				}
			});
			
			siteTable.on( 'column-sizing.dt', function ( e, settings ) {
				$(".dataTables_scrollHeadInner").css( "width", "100%" );
			});

			$('#siteTable').on( 'click', 'td .btn-type-sm', function () {
				$("#loadingCircle2").show();

				let dTable = $('#siteTable').DataTable();
				let tr = $(this).parents().closest("tr");
				let idx = dTable.row(tr).index();
				let rowData = dTable.row(tr).data();
				let userOpt = {
					url: apiHost + "/config/users",
					type: 'get',
					async: true,
					data : {
						oid: oid,
					}
				}

				makeAjaxCall(userOpt).then(res => {
					if(!isEmpty(rowData.devices) && rowData.devices.length>0){
						let dvcInfo = rowData.devices;
						dvcInfo.sortOn("name");
						getAlarmData(dvcInfo, res);
					}
				});
			});

			new $.fn.dataTable.Buttons( siteTable, {
				name: 'commands',
				"buttons": [
					{
						extend: 'excelHtml5',
						className: "btn-save",
						text: "<fmt:message key='siteSetting.excelDownload' />",
						filename: "<fmt:message key='siteSetting.site.manage' />" + new Date().format('yyyyMMddHHmmss'),
						// exportOptions: {
						// 	modifier: {
						// 		page: 'current'
						// 	}
						// },
						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
							$('row:first c', sheet).attr( 's', '42' );
							var sheet = xlsx.xl.worksheets['sheet1.xml'];

							// 아래 부터는 customization 할 수 있는 부분
							// var lastCol = sheet.getElementsByTagName('col').length - 1;
							// var colRange = createCellPos( lastCol ) + '1';
							// //Has to be done this way to avoid creation of unwanted namespace atributes.
							// var afSerializer = new XMLSerializer();
							// var xmlString = afSerializer.serializeToString(sheet);
							// var parser = new DOMParser();
							// var xmlDoc = parser.parseFromString(xmlString,'text/xml');
							// var xlsxFilter = xmlDoc.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main','autoFilter');
							// var filterAttr = xmlDoc.createAttribute('ref');
							// filterAttr.value = 'A1:' + colRange;
							// xlsxFilter.setAttributeNode(filterAttr);
							// sheet.getElementsByTagName('worksheet')[0].appendChild(xlsxFilter);
						}
					},
				],
			});

			siteTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");

			$("#siteType").find("li").on( 'click', function(){
				if(!isEmpty($(this).data("name"))){
					filterColumn("1", $(this).data("value"));
					let tr = $("#siteTable").find("tbody tr.selected");
					let btn = $("#btnGroup").find(".btn-type03");
					if(tr.length <= 0){		
						btn.each(function(index, element){
							$(this).prop("disabled", true);
						});
					} else {
						btn.each(function(index, element){
							$(this).prop("disabled", false);
						});
					}
				} else {
					filterColumn("1", "");
				}
			});
			$("#siteSearchBox").on( 'keyup search input paste cut', function(){
				siteTable.columns(2).search( this.value ).draw();
			});

			getVppDrData(vppNameData);

			if(!$('#loadingCircle').is(":hidden")){
				$("#loadingCircle").hide();
			}
		}
	}

	function nonAdminTable(mySites, vppNameData, userSites, callback) {
		if(!callback) {
			getPropertyData();
			getVppDrData(vppNameData);
		} else {
			callback();
		}

		const newArr = mySites.map((item, index) => {
			let found = userSites.findIndex( x => x.sid === item.sid);

			if(found > -1){
				$("#loadingCircle").show();
				item.role = userSites[found].role;

				if(!isEmpty(item.location)){
					item.location = item.location;
				} else {
					item.location = "-";
				}

				if(isEmpty(item.ess) || item.ess === 0){
					item.ess == "-"
				} else {
					if(item.ess === 1){
						item.ess = "DemandESS"
					} else if(item.ess === 2){
						item.ess = "GenerationESS"
					}
				}

				if(isEmpty(item.resource_type)){
					item.siteType = "-"
				} else {

					if(item.resource_type == 0) {
						// Demand && ESS : pair
						item.siteType = "<fmt:message key='siteSetting.needsResource' />"
						item.powerSource = "<fmt:message key='siteSetting.burden' />"
					} else {
						item.siteType = "<fmt:message key='siteSetting.plant' />"
						if(item.resource_type === 1){
							item.powerSource = "<fmt:message key='siteSetting.solar' />"
						} else if(item.resource_type === 2){
							item.powerSource = "<fmt:message key='siteSetting.windPower' />"
						} else if(item.resource_type === 3){
							item.powerSource = "<fmt:message key='siteSetting.smallHydro' />"
						}
					}
				}
				// Match name with dr_group_id
				if(!isEmpty(item.dr_group_id)){
					let found = vppNameData.dr_group.findIndex( x => x.dgid == item.dr_group_id);
					if(found > -1){
						item.drName = vppNameData.dr_group[found].name;
					}
				} else {
					item.drName = "-"
				}

				// Match name with vpp_group_id
				if(!isEmpty(item.vpp_group_id)){
					let found = vppNameData.vpp_group.findIndex( x => x.vgid == item.vpp_group_id);
					if(found > -1){
						item.vppName = vppNameData.vpp_group[found].name;
					}
				} else {
					item.vppName = "-"
				}

				// if(!isEmpty(matchedData.dr_group_id)){
				// 	item.drId = item.dr_group_id;
				// } else {
				// 	item.drId = "-"
				// }

				// if(!isEmpty(matchedData.vpp_group_id)){
				// 	item.vppId = item.vpp_group_id;
				// } else {
				// 	item.vppId = "-"
				// }

				item.updatedAt = new Date(item.updatedAt).format('yyyy-MM-dd') + '&ensp;' + new Date(item.updatedAt).toLocaleTimeString();
				return item;
			} else {
				return [];
			}
		});

		if(newArr.length === 0 ){
			drawEmptyTable($("#siteTable"));
		} else {
			// 1. 사업소 유형
			// 2. 사업소명
			// 3. 지역
			// 4. 발전원 => 0: MicroGrid, 1: photovoltaic, 2: wind, 3: SmallHydro (hydroelectric power for local community)
			// 5. 발전 용량
			// 6. ESS 용량 (PCS)
			// 7. ESS 용량(BMS)
			// 8. DR 자원 코드 => 이름
			// 9. Vpp 자원 코드 ( virtual power plant ) => 이름
			// 10. 수정/조회 권한
			// 11. 알람 설정
			var siteReadOnlyTable = $('#siteTable').DataTable({
				"aaData": newArr,
				"table-layout": "fixed",
				"fixedHeader": true,
				// "autoWidth": true,
				// "bAutoWidth": true,
				"bSearchable" : true,
				"sScrollY": true,
				"scrollY": "720px",
				"bScrollCollapse": true,
				"pageLength": 100,
				"aaSorting": [[ 0, 'asc' ]],
				"bSortable": true,
				"order": [[ 1, 'asc' ]],
				// "bFilter": false, disabling this option will prevent table.search()
	
				"aoColumnDefs": [
					{
						"aTargets": [ 0 ],
						"bSortable": false,
						"orderable": false
					},
				],
				"aoColumns": [
					{
						"sTitle": "",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							return '<a class="chk-type" href="#"><input type="checkbox" id="' + rowIndex.row + '" name="table_checkbox"><label for="' + rowIndex.row + '"></label></a>'
						},
						"className": "dt-body-center no-sorting"
					},
					// {
					// 	"sTitle": "순번",
					// 	"mData": null,
					// 	"mRender": function ( data, type, full, rowIndex )  {
					// 		return rowIndex.row + 1;
					// 	},
					// 	"className": "dt-center no-sorting"
					// },
					{
						"sTitle": "<fmt:message key='siteSetting.site.type' />",
						"mData": "siteType",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.site.name' />",
						"mData": "name"
					},
					{
						"sTitle": "<fmt:message key='siteSetting.location' />",
						"mData": "location",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.resource' />",
						"mData": "powerSource",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.capacity' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let val = displayNumberFixedDecimal(full.capacities.gen, 'W', 3, 2);
							return (data.capacities.gen != 0) ? (val[0] + ' ' + val[1]) : "0"
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.ESSPCS.capacity' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let val = displayNumberFixedDecimal(full.capacities.bat_pcs, 'W', 3, 2);
							return (full.capacities.bat_pcs != 0) ? (val[0] + ' ' + val[1]) : "0"
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.ESSBMS.capacity' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let val = displayNumberFixedDecimal(full.capacities.bat_bms, 'W', 3, 2);
							return (full.capacities.bat_bms != 0) ? (val[0] + ' ' + val[1]) : "0"
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.DR.resourceID' />",
						"mData": "drName",
						visible: false
					},
					{
						"sTitle": "<fmt:message key='siteSetting.VPP.resourceID' />",
						"mData": "vppName",
					},
					{
						"sTitle": "<fmt:message key='siteSetting.alarm.setting' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							return ''
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.update.date' />",
						"mData": "updatedAt",
					},
				],
				"language": {
					"emptyTable": "<fmt:message key='siteSetting.noData' />",
					"zeroRecords":  "<fmt:message key='siteSetting.noSearchData' />",
					"infoEmpty": "",
					"paginate": {
						// "previous": "",
						// "next": ""
						"sPrevious": "",
						"sNext": ""
					},
				},
				"dom": 'tip',
				"select": {
					style: 'single',
					// selector: 'td:first-child > a',
					selector: 'td input[type="checkbox"], tr'
					// selector: 'td input[type="checkbox"], td:not(:nth-of-type(11))'
				},
				initComplete: function(settings, json ){	
					let str = `<div id="btnGroup" class="right-end2"><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')"><fmt:message key='siteSetting.updateSelected' /></button><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')"><fmt:message key='siteSetting.deleteSelected' /></button><!--
					--></div>`;
					$("#siteTable_wrapper").append($(str)).addClass('mb-28');

					let colGroup = $("#siteTable").find("colgroup col");
					if(oid.match("testkpx")){
						this.api().columns(9).visible( false );
						colGroup.eq(9).addClass("hidden");
					}

					this.api().columns(10).visible( false );
					colGroup.eq(10).addClass("hidden");

					this.api().columns().header().each ((el, i) => {
						if(i == 0){
							$(el).attr ('style', 'min-width: 50px');
						}
					});
				},
			}).on("select", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn-type03");
				let role = null;
				if(!isEmpty(siteReadOnlyTable.row( indexes ).data())){
					role = siteReadOnlyTable.row( indexes ).data().role;
				}

				if(role === 1){
					btn.each(function(index, element){
						if($(this).is(":disabled")){
							$(this).prop("disabled", false);
						}
					});
				} else {	
					btn.each(function(index, element){
						if(index == 0){
							if($(this).is(":disabled")){
								$(this).prop("disabled", false);
							}
						} else {
							$(this).prop("disabled", true);
						}

					});
				}

				siteReadOnlyTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
				// console.log("dt---", siteReadOnlyTable[ type ]( indexes ).nodes())
			}).on("deselect", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn-type03");
				let role = null;

				if(!isEmpty(siteReadOnlyTable.row( indexes ).data())){
					role = siteReadOnlyTable.row( indexes ).data().role;
				}

				btn.each(function(index, element){
					if(!$(this).is(":disabled")){
						$(this).prop("disabled", true);
					}
				});
				if(role === 1){
					btn.each(function(index, element){
						if(!$(this).is(":disabled")){
							$(this).prop("disabled", true);
						}
					});
				} else {	
					btn.each(function(index, element){
						if(index == 0){
							if(!$(this).is(":disabled")){
								$(this).prop("disabled", true);
							}
						}
					});
				}
				siteReadOnlyTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
				// console.log("dt---", siteReadOnlyTable[ type ]( indexes ).nodes())
			}).columns.adjust();

			if(!$('#loadingCircle').is(":hidden")){
				$("#loadingCircle").hide();
			}
			
			$('#siteTable').find("input:checkbox").on('click', function() {
				var $box = $(this);
				if ($box.is(":checked")) {
					var group = "input:checkbox[name='" + $box.attr("name") + "']";
					$(group).prop("checked", false);
					$box.prop("checked", true);
				} else {
					$box.prop("checked", false);
				}
			});
			
			$("#siteType").find("li").on( 'click', function(){
				if(!isEmpty($(this).data("name"))){
					filterColumn("1", $(this).data("value"));
				} else {
					filterColumn("1", "");
				}
			});
			
			$("#siteSearchBox").on( 'keyup search input paste cut', function(){
				console.log()
				siteReadOnlyTable.columns(2).search( this.value ).draw();
			});
		}
	}

	function drawEmptyTable(target){
		var t = target.DataTable({
			"table-layout": "fixed",
			"columnDefs": [
				{
					"searchable": false, 
					"orderable": false,
					"targets": 0
				},
			],
			"columns": [
				{
					"title": "<fmt:message key='siteSetting.index' />",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"title": "<fmt:message key='siteSetting.site.type' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='siteSetting.site.name' />",
					"data": null
				},
				{
					"title": "<fmt:message key='siteSetting.location' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='siteSetting.resource' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='siteSetting.capacity' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='siteSetting.ESSPCS.capacity' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='siteSetting.ESSBMS.capacity' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='siteSetting.DR.resourceID' />",
					"data": null,
					visible: false
				},
				{
					"title": "<fmt:message key='siteSetting.VPP.resourceID' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='siteSetting.alarm.receive' />",
					"data": null,
				},
			],
			"dom": 'tip',
			"language": {
				"emptyTable": "<fmt:message key='siteSetting.noData' />",
				"zeroRecords":  "<fmt:message key='siteSetting.noSearchData' />",
				"infoEmpty": "",
				"paginate": {
					// "previous": "",
					// "next": ""
					"sPrevious": "",
					"sNext": ""
				},
			},
			initComplete: function(){
				this.addClass("no-stripe");
				if(oid.match("testkpx")){
					let colGroup = $("#siteTable").find("colgroup col");
					this.api().columns([8,9]).visible( false );
					colGroup.eq(8).addClass("hidden");
					colGroup.eq(9).addClass("hidden");
				}
			},
		});
	}

	function getPropertyData(option) {
		let checkBox = $("#propertyRow").find("input[type='checkbox']");
		let optionContract = {
			url: apiHost + "/bills/plans?country=kr",
			type: "get",
			async: true
		}
		let selectOpt = {
			url: apiHost + "/config/view/properties2?types=site_type,resource",
			type: 'get',
			async: true,
			beforeSend: function (jqXHR, settings) {
				$('#loadingCircle').show();
			},
		}
		
		checkBox.prop("checked", false);

		$.ajax(optionContract).done(function (json, textStatus, jqXHR) {
			const newContractList = $("#newContractList");
			const cArr = json.data.reduce((acc, val, index, array) => {
				let key = val["planName"];
				let vKey = val["voltageType"];
				let planId = String(val["id"]);
				let utilName = val["utilityName"];

				if (!acc[key]) {
					acc[key] = {};
					acc[key].planId = '';
					acc[key].voltRange = '';
					acc[key].utilName = '';
					// acc[key].dataArr = [];
				}
				acc[key].planName = key;

				if(!isEmpty(vKey)){
					acc[key].voltRange += ( vKey + "," );
				} else {
					acc[key].voltRange = vKey
				}

				if(!isEmpty(planId)){
					acc[key].planId += ( planId + "," );
				} else {
					acc[key].planId = planId
				}

				if(!isEmpty(utilName)){
					acc[key].utilName += ( utilName + "," );
				} else {
					acc[key].utilName = utilName
				}
				return acc
			}, {});

			let cStr = '';
			Object.entries(cArr).forEach((item, index, arr) => {
				let vStr = '';
				let opt = '';
				if(!isEmpty(item[1].voltRange)){
					vStr = item[1].voltRange.replace(/,\s*$/, "");
				} else {
					vStr = item[1].voltRange;
				}
				let id = item[1].planId.replace(/,\s*$/, "");
				let util = item[1].utilName.replace(/,\s*$/, "");

				let itemName = item[0];

				cStr += `
					<li data-util-name="${'${util}'}" data-plan-id="${'${id}'}" data-vol-type="${'${vStr}'}" data-value="${'${item[0]}'}"><a href="#">${'${itemName}'}</a></li>
				`;
			});
			// if(option){
			// 	newContractList.empty();
			// }
			newContractList.append(cStr);

			newContractList.find("li").on("click", function(){
				let val = $(this).data("value");
				let planId = $(this).data("plan-id");
				let voltType = $(this).data("vol-type");
				let subOpt = $("#newVoltTypeList");
				let btn = subOpt.prev();
				let idArr = [];
				let vArr = [];
				let utilArr = [];

				console.log("voltType====", voltType);
				if(!isEmpty(voltType)){
					newContractList.prev().data({ "plan-id": planId, "vol-type": voltType });
				} else {
					newContractList.prev().data("plan-id", planId);
				}
				$("#newVoltWarning").addClass("hidden");

				subOpt.empty().prev().data("value", "").contents().get(0).nodeValue = "<fmt:message key='dropDown.select' />";
				
				if(!isEmpty($(this).data("vol-type"))){
					let str = '';
					idArr = [...$(this).data("plan-id").split(",")];
					vArr = [...$(this).data("vol-type").split(",")];
					utilArr = [...$(this).data("util-name").split(",")];

					if(btn.is(":disabled")){
						btn.prop("disabled", false)
					}
					for(let i=0, length = vArr.length; i<length; i++){
						let itemName = vArr[i];

						str += `<li data-util-name="${'${utilArr[i]}'}" data-id="${'${idArr[i]}'}" data-value="${'${vArr[i]}'}"><a href="#">${'${itemName}'}</a></li>`;
					}
					subOpt.append(str);
					subOpt.find("li").click(function(){

						setTimeout(function(){
							validateForm();
						}, 600);
					});
				} else {
					btn.contents().get(0).nodeValue = "<fmt:message key='siteSetting.select' />";
					if(btn.not(":disabled")){
						btn.prop("disabled", true);
					}
				}
			});

		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.log("siteInfo/spcInfo Ajax Error:", jqXHR)
		});

		$.ajax(selectOpt).done(function (json, textStatus, jqXHR) {
			let r = json.resource;
			let s = json.site_type;
			let resStr = '';
			let siteStr = '';
			let allStr = "<li><a href='#'><fmt:message key='siteSetting.all' /></a></li>";

			$.each(r, function(index, el){
				let name = langStatus === "EN" ? `${'${el.name.en}'}` : `${'${el.name.kr}'}`;

				resStr += `
					<li data-name="${'${name}'}" data-value="${'${el.code}'}"><a href="#">${'${name}'}</a></li>
				`
			});

			// if(option){
			// 	$("#newResList").empty();
			// 	$("#resTypeList").empty();
			// 	$("#newSiteType").empty();
			// 	$("#siteType").empty();
			// }
			$("#newResList").append(resStr);
			$("#resTypeList").append(resStr).prepend(allStr);

			let dropdown = $("#propertyRow").find(".dropdown-menu");
			setDropdownValue(dropdown);
			
			
			$("#newResList li").on("click", function() {
				setTimeout(function(){
					validateForm();
				}, 300);
			});
			// $("#newResList li").on("click", function() {
			// 	let val = $(this).data("value");
			// 	let newRes = $("#newResList");
			// 	let newSiteType = $("#newSiteType");
			// 	let items = newSiteType.find("li");

			// 	items.removeClass("hidden");

			// 	if(val == "0") {
			// 		let target = items.eq(0);
			// 		newSiteType.prev().data({ "name" : target.data("name"), "value":  target.data("value") }).contents().get(0).nodeValue = target.data("name");
			// 	} else {
			// 		let target = items.eq(1);
			// 		newSiteType.prev().data({ "name" : target.data("name"), "value": target.data("value") }).contents().get(0).nodeValue = target.data("name");
			// 	}
			// });

			$("#resTypeList li").on("click", function(){
				if(!isEmpty($(this).data("value"))){
					filterColumn( "#siteTable", "4", $(this).data("name"));
					let tr = $("#siteTable").find("tbody tr.selected");
					let btn = $("#btnGroup").find(".btn-type03");
					if(tr.length <= 0){		
						btn.each(function(index, element){
							$(this).prop("disabled", true);
						});
					} else {
						btn.each(function(index, element){
							$(this).prop("disabled", false);
						});
					}
				} else {
					filterColumn("#siteTable", "4", "");
				}
			});

			$.each(s, function(index, el){
				let name = langStatus === "EN" ? `${'${el.name.en}'}` : `${'${el.name.kr}'}`;
				if(el.code == "gen"){
					siteStr += `
						<li data-name="${'${name}'}" data-value="1"><a href="#">${'${name}'}</a></li>
					`;
				} else if(el.code == "demand"){
					siteStr += `
						<li data-name="${'${name}'}" data-value="0"><a href="#">${'${name}'}</a></li>
					`;
				}
			});


			allStr += siteStr;	
			$("#siteType").append(allStr);

			siteStr += `
				<li><a href="#"><fmt:message key='siteSetting.noCase' /></a></li>
			`;
			$("#newSiteType").append(siteStr);



			$("#newSiteType li").on("click", function() {
				let val = $(this).data("value");
				let newRes = $("#newResList");
				let items = newRes.find("li");

				newRes.prev().data({ "name" : "", "value": "" }).contents().get(0).nodeValue = "<fmt:message key='siteSetting.select' />";
				if(val == "0") {
					items.eq(0).removeClass("hidden").siblings().addClass("hidden");
				} else if(val == "1"){
					items.eq(0).addClass("hidden").siblings().removeClass("hidden");
				} else {
					items.removeClass("hidden");
				}
			});

			$("#siteType li").on("click", function(){
				if(!isEmpty($(this).data("value"))){
					filterColumn( "#siteTable", "1", $(this).data("name"));
				} else {
					filterColumn("#siteTable", "1", "");
				}
			});

		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.log("site_type Error:", jqXHR)
		});

		// $("#countryList").on("change", 'input[type=checkbox]', function(){

		$("#countryList li").on("click", function(){
			let val = $(this).data("id");
			let joined = "";
			let selected = [];
			let checked = $("#countryList").find("input:checked");

			if(!isEmpty(val)){
				checked.each(function(index, el){
					selected.push($(this).attr("id"));
				});

				if(!$(this).find("input").is(":checked")){
					selected.push(val);
					if(selected.length>1){
						selected = selected.join("|");
					}
					filterColumn("#siteTable", "3", selected, "multi");
					let tr = $("#siteTable").find("tbody tr.selected");
					let btn = $("#btnGroup").find(".btn-type03");
					if(tr.length <= 0){
						btn.each(function(index, element){
							$(this).prop("disabled", true);
						});
					} else {
						btn.each(function(index, element){
							$(this).prop("disabled", false);
						});
					}
				} else {
					selected.splice(selected.indexOf(val), 1);
					joined = selected.join("|");
					filterColumn("#siteTable", "3", joined, "multi");
					let tr = $("#siteTable").find("tbody tr.selected");
					let btn = $("#btnGroup").find(".btn-type03");
					if(tr.length <= 0){
						btn.each(function(index, element){
							$(this).prop("disabled", true);
						});
					} else {
						btn.each(function(index, element){
							$(this).prop("disabled", false);
						});
					}
				}
			} else {
				filterColumn("#siteTable", "3", "");
				checked.prop("checked", false);
			}
		});

		// $("#countryList input[type=checkbox]").change(function() { 
		// 	console.log("something is checked on the page")
		// });

		// $("#countryList li input").on("change", function(){
		// 	console.log("on change----")
		// });
		let inspStr = ``
		for(let i=0, length = 28; i<length; i++){
			inspStr += `
				<li data-value="${'${i+1}'}"><a href="#">${'${i+1}'}</a></li>
			`;
		}
		inspStr += `<li data-value="0"><a href="#"><fmt:message key='siteSetting.lastDay' /></a></li>`

		if(option){
			$("#newInspection").empty();
		}
		$("#newInspection").append($(inspStr));
	}

	function getVppDrData(res) {
		let newDrResIdList = $("#newDrResIdList");
		let newVppResIdList = $("#newVppResIdList");
		// modal DR info!!!

		// if(!isEmpty(res.dr_group)){
		// 	newDrResIdList.empty();
		// 	let strDr = '';
		// 	$.each(res.dr_group, function(index, el){
		// 		strDr += '<li data-value="' + el.dgid + '" data-dr-res-id="' + el.resourceId + '"><a href="#" tabindex="-1">' +  el.name + '</a></li>'
		// 	});

		// 	$("#newVppRevShare").prop('disabled', false).val("-");

		// 	newDrResIdList.append(strDr);
		// 	$("#sectionDRInfo input").each(function(){
		// 		$(this).prop('disabled', false);
		// 	});
		// 	$("#newCblList").prev().prop("disabled", false);
		// } else {
		// 	newDrResIdList.prev().prop("disabled", true).contents().get(0).nodeValue = "등록된 DR거래 자원 ID가 없습니다.";
		// 	$("#sectionDRInfo input").each(function(){
		// 		$(this).prop('disabled', true).val("-");
		// 	})
		// 	$("#newCblList").prev().prop("disabled", true).contents().get(0).nodeValue = "-"";
		// }

		// modal VPP info!!!
		if(!isEmpty(res.vpp_group)){
			newVppResIdList.empty();
			let strVpp = '';
			$.each(res.vpp_group, function(index, el){
				strVpp += '<li data-value="' + el.vgid + '" data-vpp-res-id="' + el.resourceId + '"><a href="#" tabindex="-1">' + el.name + '</a></li>'
			});
			// dropdown
			newVppResIdList.append(strVpp);
		} else {
			newVppResIdList.prev().prop('disabled', true).contents().get(0).nodeValue = "<fmt:message key='siteSetting.alert.12' />";
			$("#newVppRevShare").prop('disabled', true).val("-");
		}
		let propertyDropdown = $("#propertyRow").find(".dropdown-menu");
		let dropdown = $("#updateSiteForm").find(".dropdown-menu");
		setDropdownValue(propertyDropdown);
		setDropdownValue(dropdown);
	}

	function initModal(){
		let form = $("#updateSiteForm");
		let input = form.find("input:not(#newSiteName)");
		let dropdownBtn = form.find(".dropdown-toggle");
		let warning = form.find(".warning");

		$("#siteSearchBox").val("");		
		$("#validSite").addClass("hidden");
		$("#newSiteName").val("").prop("disabled", false).parent().removeClass("disabled").next().prop("disabled", true);
		
		$("#addSiteBtn").prop("disabled", true).removeClass("hidden");

		$("#newResList li").removeClass("hidden");
		$("#newSiteType").prev().prop("disabled", false);
		$("#newSiteDetail").val("").prop("disabled", false);
		$("#confirmSite").val("");

		warning.addClass("hidden");
		input.each(function(){
			$(this).val("").prop("disabled", false).parent().removeClass("disabled");
		});

		$.each(dropdownBtn, function(index, element){
			$(this).data({ "value": "", "vol-type": "", "plan-id" : "" }).html('<fmt:message key="dropDown.select" />' + '<span class="caret"></span>').prop("disabled", false);
			$(this).next().find("li").removeClass("hidden");
		});
		// console.log("initModal----")
	}

	function updateModal(option, callback){
		// RPS(Renewable Portfolio Standard), SMP(System Marginal Price), REC(Renewable Energy Certificate) => subsidies
		let titleAdd = $('#titleAdd');
		let newSiteName = $('#newSiteName');
		let form = $("#updateSiteForm");
		let required = form.find(".asterisk");
		let addBtn = $("#addSiteBtn");

		// ADD MODAL!!!
		if(option == "add"){
			initModal();
			if(newSiteName.parent().next().hasClass("hidden")) {
				newSiteName.parent().next().removeClass("hidden");
				newSiteName.parent().addClass("offset-width").removeClass("w-100");
			}
			titleAdd.removeClass("hidden").next().addClass("hidden");
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			addBtn.text("<fmt:message key='modal.add' />");
			newSiteName.prop('disabled', false).parent().removeClass("disabled");
			$("#newVoltTypeList").prev().prop("disabled", true).data("value", "").contents().get(0).nodeValue = "<fmt:message key='siteSetting.select' />";
			$("#addSiteModal").removeClass("edit").modal("show");
		} else {
			let dTable = $("#siteTable").DataTable();
			let tr = $("#siteTable").find("tbody tr.selected");
			let td = tr.find("td");
			let rowData = dTable.row(tr).data();

			$("#validSite").is(".hidden") ? null : $("#validSite").addClass("hidden");

			// EDIT MODAL!!!
			if(option == "edit") {
				if(!isEmpty(rowData.role) && rowData.role != 1){
					let input = form.find("input");
					let dropdownBtn = form.find(".dropdown-toggle");

					input.each(function(){
						$(this).prop("disabled", true).parent().addClass("disabled");
					});

					$.each(dropdownBtn, function(index, element){
						$(this).prop("disabled", true);
					});
					// 추가 정보
					$('#newSiteDetail').val(rowData.detail_info).prop("disabled", true);

					addBtn.addClass("hidden");

				} else {
					// 추가 정보
					$('#newSiteDetail').val(rowData.detail_info).prop("disabled", false);
					addBtn.prop("disabled", false).text("<fmt:message key='siteSetting.update' />").removeClass("hidden");
				}

				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");

				if(!newSiteName.parent().next().hasClass("hidden")) {
					newSiteName.parent().next().addClass("hidden");
					newSiteName.parent().removeClass("offset-width").addClass("w-100");
				}
				// 사업소 명
				newSiteName.val( td.eq(2).text() ).prop("disabled", true).parent().addClass("disabled");
				// 지역
				let city = td.eq(3).text();
				$('#newCityList li').each(function() {
					if (city === $(this).data('value')) {
						let cityText = $(this).find('a').contents().get(0).nodeValue.trim();
						let cityValue = $(this).data('value');
						$('#newCityList').prev().data({'name': cityText, 'value': cityValue}).contents().get(0).nodeValue = cityText;
					}
				});

				//$('#newCityList').prev().data({"name": td.eq(3).text(), "value" : td.eq(3).data("value") }).contents().get(0).nodeValue = td.eq(3).text();
				// Address
				if( !isEmpty(rowData.address)) {
					$('#newStreetAddr').val(rowData.address);
				}
				// 사업소 유형
				$('#newSiteType').prev().data({"name": td.eq(1).text(), "value" : td.eq(1).data("value") }).contents().get(0).nodeValue = td.eq(1).text();
				// 발전원
				$("#newResList").prev().data({"name": td.eq(4).text(), "value" : td.eq(4).data("value") }).contents().get(0).nodeValue = td.eq(4).text();
				// ESS 유무
				if( isEmpty(rowData.ess) || rowData.ess === 0 ) {
					$('#newEssList').prev().data("value", "0").contents().get(0).nodeValue = "<fmt:message key='siteSetting.N' />";
				} else {
					if (rowData.ess === '-') {
						$('#newEssList').prev().data("value", "0").contents().get(0).nodeValue = "<fmt:message key='siteSetting.N' />";
					} else {
						$('#newEssList').prev().data("value", "1").contents().get(0).nodeValue = "<fmt:message key='siteSetting.Y' />";
					}
				}
				// 위경도
				if( !isEmpty(rowData.latlng)) {
					$('#newCoord').val(rowData.latlng);
				}
				$('#station_id').val(rowData.station_id);

				$('#gridX').val(rowData.grid_x);
				$('#gridY').val(rowData.grid_y);
				// kpx
				if (oid.match('testkpx')) {
					$('#kpx_genid').val(rowData.kpx_genid);
					$('#kpx_emsid').val(rowData.kpx_emsid);
					$('#kpx_transvol').val(rowData.kpx_transvol);
				}
				// Utility info
				if( !isEmpty(rowData.utility)) {
					Promise.resolve(JSON.parse(rowData.utility)).then( util => {
						let sectionPowerMarketInfo = $("#sectionPowerMarketInfo");
						let newPeakDemand = $("#newPeakDemand");
						let newDrCharge = $("#newDrCharge");
						let utilPlanName = util.utility_plan_name;

						if(!isEmpty(util.utility_plan_id)){
							$("#newContractList").prev().data({"plan-id": util.utility_plan_id, "value": utilPlanName }).html(utilPlanName + '<span class="caret"></span>');
						} else {
							$("#newContractList").prev().html('<fmt:message key="dropDown.select" /><span class="caret"></span>');
						}

						if(isEmpty(rowData.role)) {
							sectionPowerMarketInfo.find(".dropdown-toggle:not(.optional)").each(function(index, el){
								$(this).prop("disabled", false);
							});
							sectionPowerMarketInfo.find("input[type='text'][type='password']").each(function(index, el){
								$(this).prop("disabled", false).parent().removeClass("disabled");
							});
						}

						if(!isEmpty(util.volt_name) ){
							// console.log("util.volt_name==", util.volt_name);
							$("#newVoltTypeList").prev().data({"id": util.utility_plan_id, "data-value" : util.volt_name }).html( util.volt_name + '<span class="caret"></span>');
						} else {
							$("#newVoltTypeList").prev().prop("disabled", true).html("<fmt:message key='siteSetting.select' /><span class='caret'></span>");
						}

						if(!isEmpty(util.peak_demand) ){
							formatUnit(newPeakDemand, String(util.peak_demand / 1000));
						}

						if(!isEmpty(util.demand_charge) ){
							formatUnit(newDrCharge, String(util.demand_charge / 1000));
						}

						if(util.metering_day == 0){
							$("#newInspection").prev().data("value", String(util.metering_day)).html( "<fmt:message key='siteSetting.lastDay' /><span class='caret'></span>");
						} else {
							$("#newInspection").prev().data("value", String(util.metering_day)).html( String(util.metering_day) + '<span class="caret"></span>');
						}

						$("#newKepcoId").val(util.kepco_id);
						$("#newISmartId").val(util.ismart_id);
						$("#newISmartPwd").val(util.ismart_pass);
					});

				}

				// PowerMarket??? (tariff?) info
				if( !isEmpty(rowData.power_market)) {
					let priceModel = JSON.parse(rowData.power_market);
					// console.log("priceModel===", priceModel)
					if(priceModel.price_type == "SMP_mean") {
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( "<fmt:message key='siteSetting.SMP.avg' />" + '<span class="caret"></span>');
					} else if(priceModel.price_type == "fixed") {
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( "<fmt:message key='siteSetting.truePrice' />" + '<span class="caret"></span>');
					} else {
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( priceModel.price_type + '<span class="caret"></span>');
					}
					$("#newPrice").val(priceModel.price).html( priceModel.price + '<span class="caret"></span>');
				}

				// DR info
// 				let sectionDRInfo = $("#sectionDRInfo");
// 				let sectionDrDropdown = sectionDRInfo.find(".dropdown-toggle");
// 				let sectionDrInput = sectionDRInfo.find("input[type='text']");
//				let newDrVol = $("#newDrVol");
// 				if( !isEmpty(rowData.dr_group_id)) {
// 					$("#newDrResIdList").prev().data("value", rowData.dr_group_id).contents().get(0).nodeValue = rowData.drName;
// 					sectionDrDropdown.each(function(item, index){
// 						$(this).prop("disabled", false);
// 					});

// 					setTimeout(function(){
// 						sectionDrInput.prop('disabled', false)
// 					}, 400);
// ;
// 					if(!isEmpty(rowData.dr_info)){
// 						let dr = JSON.parse(rowData.dr_info);
// 						// console.log("dr===", dr);

						// if(!isEmpty(dr.contract_capacity) ){
						// 	formatUnit(newDrVol, String(dr.contract_capacity / 1000));
						// }

// 						if( !isEmpty(dr.cbl_method)) {
// 							$("#newCblList").prev().contents().get(0).nodeValue = dr.cbl_method;
// 						}
// 						if( !isEmpty(dr.profile_share)) {
// 							$("#newDrRevShare").val(dr.profile_share);
// 						}
// 					}
// 				} else {
// 					console.log("no dr grou id---")
// 					sectionDrDropdown.each(function(item, index){
// 						$(this).prop("disabled", true).contents().get(0).nodeValue = "<fmt:message key="dropDown.select" />";
// 					});
// 					sectionDrInput.each(function(item, index){
// 						$(this).prop("disabled", true).val("");
// 					});
// 				}

				// VPP info
				let sectionVppInfo = $("#sectionVppInfo");
				let sectionVppDropdown = sectionVppInfo.find(".dropdown-toggle");
				let sectionVppInput = sectionVppInfo.find("input[type='text']");

				if( !isEmpty(rowData.vpp_group_id)) {
					$("#newVppResIdList").prev().data("value", rowData.vpp_group_id).contents().get(0).nodeValue = rowData.vppName;
					sectionVppDropdown.each(function(item, index){
						$(this).prop("disabled", false);
					});
					sectionVppInput.each(function(item, index){
						$(this).prop("disabled", false).parent().removeClass("disabled");
					});
					if( !isEmpty(rowData.vpp_info)) {
						let vpp = JSON.parse(rowData.vpp_info);

						if( !isEmpty(rowData.profile_share) && rowData.profile_share != "-" ) {
							$("#newVppRevShare").val(vpp.profile_share);
						}
					}
				} else {
					sectionVppDropdown.each(function(item, index){
						$(this).prop("disabled", true).contents().get(0).nodeValue = "<fmt:message key='siteSetting.select' />";
					});
					sectionVppInput.each(function(item, index){
						$(this).prop("disabled", true).val("").parent().addClass("disabled");
					});
				}

				if( td.eq(9).text() != '-' ) {
					$('#newVppResIdList').prev().data("value", td.eq(9).text() ).contents().get(0).nodeValue = td.eq(9).text();
				} else {
					$('#newVppResIdList').prev().data("value", "").html("<fmt:message key='siteSetting.select' /><span class='caret'></span>");
				}
				$("#addSiteModal").addClass("edit").modal("show");
			}
			// DELETE MODAL!!!
			if(option == "delete") {
				let siteName = td.eq(2).text();
				let modal = $("#deleteConfirmModal");
				let deleteBtn = $("#deleteConfirmBtn");
				let confirmSiteId = $("#confirmSite");

				$("#deleteSuccessMsg span").text(siteName);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmSiteId.on("input", function() {
					if($(this).val() !== siteName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmSiteId.on("keyup", function() {
					if($(this).val() !== siteName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});
			}
		}

	}

	function checkSiteId(userInput){
		if(isEmpty(userInput)) return false;
		
		$("#validSite").addClass("hidden").parent().find(".warning").addClass("hidden");
		let id = userInput.toString();

		let siteList = '${siteList}';
		siteList = JSON.parse(siteList);
		if(!isEmpty(siteList)) {
			// console.log("siteList==", siteList)
			if(siteList.some(x => x.name == id)){
				$("#invalidSite").removeClass("hidden");
				// console.log("match==")
			} else {
				$("#validSite").removeClass("hidden");
				// console.log("no match==")
			}
		} else {
			$("#validSite").removeClass("hidden");
		}
		validateForm();

	}

	function validateForm(){
		if(!$("#addSiteModal").hasClass('edit')){
			let voltType = $("#newContractList").prev().data("vol-type");
			let subVoltType = $("#newVoltTypeList").prev().data("value");
			let newCityList = $("#newCityList").prev().data("value");
			let newResList = $("#newResList").prev().data("value")
			let validSite = $("#validSite:not('.hidden')").length;
			if(!isEmpty(voltType)){
				if( !isEmpty(subVoltType) && validSite > 0 && !isEmpty(newCityList) && !isEmpty(newResList) ){
					$("#addSiteBtn").prop("disabled", false);
				} else {
					if(isEmpty(subVoltType)){
						$("#newVoltWarning").removeClass("hidden");
					}
					$("#addSiteBtn").prop("disabled", true);
				}
			} else {
				$("#newVoltWarning").addClass("hidden");
				if( validSite > 0 && !isEmpty(newCityList) && !isEmpty(newResList) ){
					$("#addSiteBtn").prop("disabled", false);
				} else {
					$("#addSiteBtn").prop("disabled", true);
				}
			}
		} else {
			$("#addSiteBtn").prop("disabled", false);
		}

	}

	function showSubgroup (self){
		let tr = $(self).parents().closest("tr");
		let td = tr.find("td");
		let dataIdx = $(self).parent().prev().data("index");
		let typeName = $(self).data("value");

		let target = td.eq(1).find(".dropdown-toggle[data-index='" + dataIdx + "']");
		let menuItem = target.next().find("li");
		
		menuItem.addClass("hidden");
		menuItem.each(function(index, item){
			let val = $(this).data("parent");
			if(val == typeName){
				target.prop("disabled", false).data("value", "").contents().get(0).nodeValue = "<fmt:message key='siteSetting.select' />";
				$(this).removeClass("hidden");
			}
		});
	
	}

	function getAlarmData(alarmData, userData){
		const uniqDvcType = groupBy(alarmData, "device_type");
		const uniqDvcName = Object.values(groupBy(alarmData, "name"));

		alarmDataList = uniqDvcType;
		deleteAlarmList = [];

		let dvcNameStr = ``;
		let dvcTypeStr = ``;
		let alarmLvlStr = ``;
		let userNameStr = ``;

		// console.log("alarmData---", alarmData);
		// console.log("uniqDvcType---", uniqDvcType);
		// console.log("uniqDvcName---", uniqDvcName);
		// console.log("userData---", userData);
		// console.log("entries---", entries);
		// return false;
		const promises = alarmData.map( async item => {
			// global var deviceNameList => kr device_type_name
			if ($.inArray(item.device_type, alarmData) === -1) {
				for (let property in deviceNameList) {
					if(property == item.device_type){
						item.device_type_label = deviceNameList[property].name.kr;
						break;
					}
				}
			}

			if(!isEmpty(item.alarm_to)){
				try {
					let response = await JSON.parse(item.alarm_to);
					if( !isEmpty(response.user) && response.user.length > 0 && !isEmpty(response.non_user) && response.non_user.length > 0 ) {
						// console.log("both====", response);
						item.alarmToUser = response;
						item.userGroup = "both";
					} else {
						if( !isEmpty(response.user) && response.user.length > 0 ){
							// console.log("user====", response);
							item.alarmToUser = response;
							item.userGroup = "user";
						}
						if( !isEmpty(response.non_user) && response.non_user.length > 0 ){
							// console.log("non_user====", response);
							item.alarmToUser = response;
							item.userGroup = "non_user";
						}
					}
				} catch (exception) {
					console.error(`getAlarmData() : failed to JSON.parse() ====> (${exception})`);
				}
			} else {
				return item.alarmToUser = null;
			}

		});

		Promise.all(promises).then( () => {
			let entries = Object.entries(uniqDvcType);
			entries.forEach(function(item, index){
				dvcTypeStr += `<li data-did="${'${ item[1][0].did }'}" data-value="${'${ item[1][0].device_type }'}">
					<a href="#">${'${ item[1][0].device_type_label }'}</a>
				</li>`;
			});

			uniqDvcName.forEach(function(item, index){
				dvcNameStr += `<li class="hidden" data-parent="${'${ item[0].device_type }'}">
					<a class="chk-type" href="#">
						<input type="checkbox" name="${'${ item[0].name }'}" value="${'${ item[0].did }'}" data-device-type="${'${ item[0].device_type }'}">
						<label>${'${ item[0].name }'}</label>
					</a>
				</li>`;
			});

			const alarmLvlArr = [
				{  name : "<fmt:message key='siteSetting.info' />", val: 0 },
				{  name : "<fmt:message key='siteSetting.warn' />", val: 1 },
				{  name : "<fmt:message key='siteSetting.error' />", val: 2 },
				{  name : "<fmt:message key='siteSetting.trip' />", val: 3 },
				{  name : "<fmt:message key='siteSetting.emergency' />", val: 4 },
				{  name : "<fmt:message key='siteSetting.undefined' />", val: 9 },
			];

			alarmLvlArr.forEach(function(item, index){
				alarmLvlStr += `<li><a class="chk-type" href="#">
					<input type="checkbox" name="aDvcLevel${'${ item.val }'}" value="${'${ item.val }'}" />
					<label>${'${ item.name }'}</label>
				</a></li>`;
			});

			if(!isEmpty(userData)){
				userData.forEach(function(item, index){
					let nameId = `${'${ item.name }'}` + ` / ` + `${'${ item.login_id }'}`;
					let phoneNum = "";
					item.contact_phone ? (phoneNum = item.contact_phone) : null;

					userNameStr += `<li onclick="showPhoneNum(this)"><a class="chk-type" href="#">
						<input type="checkbox" 
							data-id="${'${ item.login_id }'}${'${ index }'}"
							name="aDvcContactPerson${'${ index }'}" 
							value="${'${ item.uid }'}"
							data-uid="${'${ item.uid }'}" 
							data-name="${'${ item.name }'}"
							data-contact-num="${'${ phoneNum }'}" />
						<label>${'${ nameId }'}</label>
					</a></li>`;
				});	
			}

			var alarmTable = $('#alarmTable').DataTable({
				"aaData": entries,
				"destroy": true,
				// "retrieve": true,
				"table-layout": "fixed",
				"fixedHeader": true,
				// "autoWidth": true,
				// "bAutoWidth": true,
				"ordering": false,
				"bSortable": false,
				"bSearchable" : true,
				// "scrollX": true,
				// "sScrollX": "100%",
				// "sScrollXInner": "100%",
				"sScrollY": true,	
				"scrollY": "60vh",
				"pageLength": 4,
				"bPaginate": true,
				// "sPaginationType": "custom",
				"bLengthChange": false,
				// "bInfo": false,
				// "bScrollCollapse": true,
				"bSearchable" : true,
				"dom": 'tp',
				"aoColumnDefs": [
					{
						"aTargets": [ 1 ],
						"createdCell": function (td, cellData, rowData, row, col) {

							let dropdown1 = $(td).find(".dropdown-menu");
							$.each(dropdown1, function(index, element){
								for(let i = 0, arrLength = cellData[1].length; i < arrLength; i++ ){
									let input = dropdown1.eq(i).find("input[type='checkbox']");
									let currentCell = cellData[1][i];
									let dvcType = currentCell.device_type;
									let name = currentCell.name;

									$.each(input, function(idx, checkbox){
										let parent = $(checkbox).parents().closest("li");
										if($(checkbox).data("device-type") == dvcType){
											parent.removeClass("hidden");
										} else {
											if(!parent.hasClass("hidden")){
												parent.addClass("hidden");
											}
										}
										if($(checkbox).attr("name") == name){
											$(checkbox).prop("checked", true);
										} else {
											$(checkbox).prop("checked", false);
										}
									});
								}
							});
						}
					},
					{
						"aTargets": [ 2, 3 ],
						"createdCell": function (td, cellData, rowData, row, col) {
							// 알람 레벨
							let dropdown2;
							let dropdown3;
							let nonUserName;
							let phoneGroup;

							if(col==2){
								dropdown2 = $(td).find(".dropdown-menu");
							} else if(col==3){
								dropdown3 = $(td).find(".dropdown-menu");
								nonUserName = $(td).find(".text-input-type[data-user-type='non-user']");
							}

							for(let i = 0, arrLength = cellData[1].length; i < arrLength; i++ ){
								if (!isEmpty(cellData[1][i].alarmToUser)) {
									let currentCell = cellData[1][i];
									if (!isEmpty(currentCell.alarmToUser.user)) {
										let checkbox2;
										let checkboxArr2;
										let checkbox3;
										let checkboxArr3;
										let userList = currentCell.alarmToUser.user;

										if(col==2){
											checkbox2 = dropdown2.eq(i).find("input[type='checkbox']");
											checkboxArr2 = checkbox2.toArray();
										} else if(col==3){
											checkbox3 = dropdown3.eq(i).find("input[type='checkbox']");
											checkboxArr3 = checkbox3.toArray();
										}
										// console.log("checkboxArr===", checkboxArr);
										
										$.each(userList, function(index, singleUser){
											if(col==2){
												// console.log("singleUser===", singleUser)
												$.each(singleUser.level, function(index, item){
													let found = checkboxArr2.findIndex( x => $(x).val() == item );
													if( found > -1 ){
														$(checkboxArr2[found]).prop("checked", true);
													}
												});
											} else if(col==3){
												let checkbox3 = dropdown3.eq(i).find("input[type='checkbox']");
												let checkboxArr3 = checkbox3.toArray();
												let found = checkboxArr3.findIndex(x => $(x).val() == singleUser.uid);
												if( found > -1 ){
													$(checkboxArr3[found]).prop("checked", true);
												}
											}
										});			
									}

									if (!isEmpty(currentCell.alarmToUser.non_user)) {
										let checkbox2;
										let checkboxArr2;
										let nonUserList = currentCell.alarmToUser.non_user;

										if(col==2){
											checkbox2 = dropdown2.eq(i).find("input[type='checkbox']");
											checkboxArr2 = checkbox2.toArray();
										}

										$.each(nonUserList, function(index, el){
											if(col==2){
												$.each(el.level, function(index, item){
													let found = checkboxArr2.findIndex( x => $(x).val() == item );
													if( found > -1 ){
														$(checkboxArr2[found]).prop("checked", true);
													}
												});
											} else if(col==3){
												let parentEl = nonUserName.eq(i);
												let userNameInput = parentEl.find("input");
												let nameVal = userNameInput.data("value");
												
												if( !isEmpty(nameVal)){
													userNameInput.attr("placeholder", nameVal);
												}
											}
										});
									}
								}
								
							}
						}
					},
				],
				"aoColumns": [
					{
						"sTitle": "<fmt:message key='siteSetting.device.type' />",
						// "className": "no-sorting",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex ) {
							let val1 = data[1];
							let dropdown1 = ``;

							$.each(val1, function(index, el){
								let newIdx = String(rowIndex.row+index)
								dropdown1 += `<div class="dropdown">
										<button type="button" class="dropdown-toggle device-type" 
											data-index="${'${index}'}"
											data-toggle="dropdown" 
											data-did="${'${ el.did }'}" data-value="${'${ el.device_type }'}" disabled>
											${'${ el.device_type_label }'}<span class="caret"></span></button>
										<ul id="aDvcTypeList${'${ newIdx }'}" class="dropdown-menu chk-type" role="menu">${'${ dvcTypeStr }'}</ul>
									</div>`;
							});
							return dropdown1;
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.device.name' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex ) {
							let val2 = data[1];
							let dropdown2 = ``;

							$.each(val2, function(index, el){
								let totalLength = el.length;
								let newIdx = String(rowIndex.row+index)
								let displayText = "";
								(totalLength >=2) ? (displayText = (el.name + " <fmt:message key='dropdown.etc' /> +" + String(totalLength-1)) ) : (displayText = el.name)

								dropdown2 += `<div class="dropdown">
										<button type="button" class="dropdown-toggle" 
											data-function="concat"
											data-toggle="dropdown" 
											data-index="${'${index}'}"
											data-did="${'${ el.did }'}" 
											data-value="${'${ el.name }'}" 
											data-name="<fmt:message key="dropDown.select" />" disabled>${'${ displayText }'}
											<span class="caret"></span></button>
										<ul id="aDvcNameList${'${ newIdx }'}" class="dropdown-menu chk-type" role="menu">${'${ dvcNameStr }'}</ul>
									</div>`;
							});
							return dropdown2;
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.alarm.level' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex ) {
							let val3 = data[1];
							let dropdown3 = ``;

							$.each(val3, function(index, el){
								let newIdx = String(rowIndex.row+index);

								if(isEmpty(el.userGroup)){
									dropdown3 += `<div class="dropdown">
											<button type="button" class="dropdown-toggle" 
												data-function="concat"
												data-index="${'${index}'}"
												data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />" disabled><fmt:message key="dropDown.select" />
												<span class="caret"></span>
											</button>
											<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu chk-type" role="menu">${'${ alarmLvlStr }'}</ul>
										</div>`;
								} else {
									let joinedVal = "";
									let displayText = "";
									let alarmArr = [];

									if(el.userGroup === "both"){
									// USER && NON USER
										let length1 = el.alarmToUser.user.length;
										let length2 = el.alarmToUser.non_user.length;

										if(length1 === length2 && length1 >0){
											for(let i=0, arrLength = length1; i<arrLength; i++ ){
												if(!isEmpty(el.alarmToUser.user[i].level)){
													if(i==0){
														let found = alarmLvlArr.findIndex( x => x.val == el.alarmToUser.user[i].level[0]);
														if(found > -1){
															displayText = alarmLvlArr[found].name;
														}
													}
													alarmArr = [...el.alarmToUser.user[i].level];
												}
												if(!isEmpty(el.alarmToUser.non_user[i].level)){
													alarmArr = [...el.alarmToUser.non_user[i].level];
												}
											}

											alarmArr = [...new Set([...alarmArr])];
											joinedVal = alarmArr.toString();

											if(alarmArr.length >=2){
												displayText = displayText + " <fmt:message key='dropdown.etc' /> +" + String(alarmArr.length-1);
											}
											
										} else {
											for(let i=0, arrLength = length1; i<arrLength; i++ ){
												if(!isEmpty(el.alarmToUser.user[i].level)){
													if(i==0){
														let found = alarmLvlArr.findIndex( x => x.val == el.alarmToUser.user[i].level[0]);
														if(found > -1){
															displayText = alarmLvlArr[found].name;
														}
													}
													alarmArr = [...el.alarmToUser.user[i].level];
												}
											}

											for(let i=0, arrLength = length2; i<arrLength; i++ ){
												if(!isEmpty(el.alarmToUser.non_user[i].level)){
													alarmArr = [...el.alarmToUser.non_user[i].level];
												}
											}

											alarmArr = [...new Set([...alarmArr])];
											joinedVal = alarmArr.toString();

											if(alarmArr.length >=2){
												displayText = displayText + " <fmt:message key='dropdown.etc' /> +" + String(alarmArr.length-1);
											}
											
										}
										// console.log("alarmArr==", alarmArr, joinedVal);
									} else {
									// either USER || NON USER
										if(el.userGroup === "user"){
											let length1 = el.alarmToUser.user.length;

											if(length1 > 0 ){
												for(let i=0, arrLength = length1; i<arrLength; i++ ){
													if(!isEmpty(el.alarmToUser.user[i].level)){
														if(i==0){
															let found = alarmLvlArr.findIndex( x => x.val == el.alarmToUser.user[i].level[0]);
															if(found > -1){
																displayText = alarmLvlArr[found].name;
															}
														}
														alarmArr = [...el.alarmToUser.user[i].level];
													}
												}
											}
											alarmArr = [...new Set([...alarmArr])];
											joinedVal = alarmArr.toString();

											if(alarmArr.length >=2){
												displayText = displayText + " <fmt:message key='dropdown.etc' /> +" + String(alarmArr.length-1);
											}

										} else if(el.userGroup === "non_user"){
											let length2 = el.alarmToUser.non_user.length;

											if(length2 > 0 ){
												for(let i=0, arrLength = length2; i<arrLength; i++ ){
													if(!isEmpty(el.alarmToUser.non_user[i].level)){
														if(i==0){
															let found = alarmLvlArr.findIndex( x => x.val == el.alarmToUser.non_user[i].level[0]);
															if(found > -1){
																displayText = alarmLvlArr[found].name;
															}
														}
														alarmArr = [...el.alarmToUser.non_user[i].level];
													}
												}

												alarmArr = [...new Set([...alarmArr])];
												joinedVal = alarmArr.toString();

												if(alarmArr.length >=2){
													displayText = displayText + " <fmt:message key='dropdown.etc' /> +" + String(alarmArr.length-1);
												}

											}
										
										}
									}

									if(displayText == "") {
										dropdown3 += `<div class="dropdown">
											<button type="button" class="dropdown-toggle" 
												data-function="concat"
												data-index="${'${index}'}"
												data-toggle="dropdown" 
												data-name="<fmt:message key="dropDown.select" />" disabled><fmt:message key='siteSetting.select' />
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu chk-type" role="menu">${'${ alarmLvlStr }'}</ul>
										</div>`;
									} else {
										dropdown3 += `<div class="dropdown" data-function="concat">
											<button type="button" class="dropdown-toggle" 
												data-function="concat"
												data-index="${'${index}'}"
												data-toggle="dropdown"
												data-name="<fmt:message key="dropDown.select" />" disabled>${'${ displayText }'}
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu chk-type" role="menu">${'${ alarmLvlStr }'}</ul>
										</div>`;
									}
								}
							
							});
							
							return dropdown3;
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.manager' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex ) {
							const val4 = data[1];
							let dropdown4 = ``;

							$.each(val4, function(index, el){
								let newIdx = String(rowIndex.row+index);
								if(isEmpty(el.userGroup)){
									dropdown4 += `<div class="user-group" data-index="${'${index}'}">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" 
												data-function="concat"
												data-child-id="aDvcPhoneUser${'${ newIdx }'}"
												data-toggle="dropdown"
												data-name="<fmt:message key="dropDown.select" />" disabled><fmt:message key='siteSetting.select' />
												<span class="caret"></span>
											</button>
											<ul id="aDvcUserList${'${ newIdx }'}" class="dropdown-menu chk-type" role="menu">${'${ userNameStr }'}</ul>
										</div>
										<div class="text-input-type disabled" 
											data-child-id="aDvcPhoneNonUser${'${ newIdx }'}"
											data-user-type="non-user">
											<input type="text" name="aDvcNonUserList${'${ newIdx }'}" placeholder="<fmt:message key='siteSetting.input.self' />" disabled />
										</div>
									</div>`;
								} else {
									let joinedVal = "";
									let displayText = "";
									let displayText1 = "";
									let textNonUserName = "";
									let textNonUserPhone = "";
									let nonUserNameStr = "";
									let nonUserNumStr = "";

									let userArr = [];
									let nonUserArr = [];
									let nonUserNumberArr = [];
									let mergedNonUserArr = [];

									if(el.userGroup === "both"){
									// USER && NON USER
										let length1 = el.alarmToUser.user.length;
										let length2 = el.alarmToUser.non_user.length;
							
										if(length1 === length2 && length1 >0){
											for(let i=0, arrLength = length1; i<arrLength; i++ ){
												if(!isEmpty(el.alarmToUser.user[i].uid)){
													if(isEmpty(displayText)){
														let found = userData.findIndex( x => x.uid == el.alarmToUser.user[i].uid);
														if(found > -1){
															displayText = userData[found].name;
															// console.log("userData[found]11===", userData[found])
															if(!isEmpty(userData[found].contact_phone)){
																displayText1 = userData[found].contact_phone;
															}
														}
													}
													userArr.push(el.alarmToUser.user[i].uid);
												}
												if(!isEmpty(el.alarmToUser.non_user[i].name)){
													// console.log("name====", el.alarmToUser.non_user[i].name);
													if(isEmpty(textNonUserName)){
														textNonUserName = el.alarmToUser.non_user[i].name;
													}
													if(!isEmpty(el.alarmToUser.non_user[i].phone)){
														nonUserNumberArr.push(el.alarmToUser.non_user[i].phone);
													} else {
														nonUserNumberArr.push("");
													}
													nonUserArr.push(el.alarmToUser.non_user[i].name);	
												} else {
													// nonUser without name
													if(!isEmpty(el.alarmToUser.non_user[i].phone)){
														nonUserNumberArr.push(el.alarmToUser.non_user[i].phone);
													} else {
														nonUserNumberArr.push("");
													}
													nonUserArr.push("");
												}
											}
										} else {
											for(let i=0, arrLength = length1; i<arrLength; i++ ){
												if(!isEmpty(el.alarmToUser.user[i].uid) && isEmpty(displayText)){
													let found = userData.findIndex( x => x.uid == el.alarmToUser.user[i].uid);
													if(found > -1){
														displayText = userData[found].name;
														// console.log("userData[found]22===", userData[found])
														if(!isEmpty(userData[found].contact_phone)){
															displayText1 = userData[found].contact_phone;
														}
													}
													userArr.push(el.alarmToUser.user[i].uid);
												}
											}

											for(let i=0, arrLength = length2; i<arrLength; i++ ){
												if(!isEmpty(el.alarmToUser.non_user[i].name)){
													if(isEmpty(textNonUserName)){
														textNonUserName = el.alarmToUser.non_user[i].name;
													}
													if(!isEmpty(el.alarmToUser.non_user[i].phone)){
														nonUserNumberArr.push(el.alarmToUser.non_user[i].phone);
													} else {
														nonUserNumberArr.push("");
													}
													nonUserArr.push(el.alarmToUser.non_user[i].name);
												} else {
													// nonUser without name
													if(!isEmpty(el.alarmToUser.non_user[i].phone)){
														nonUserNumberArr.push(el.alarmToUser.non_user[i].phone);
													} else {
														nonUserNumberArr.push("");
													}
													nonUserArr.push("");
												}
											}
										}
									
										userArr = [...new Set([...userArr])];
										// in case of empty value, DO NOT NEW SET
										nonUserArr = [...nonUserArr];
										nonUserNumberArr = [...nonUserNumberArr];

										console.log("nonUserArr===", nonUserArr);
										console.log("nonUserNumberArr===", nonUserNumberArr);

										joinedVal = userArr.toString();

										let tempNonUserNum = !isEmpty(nonUserNumberArr[0]) ? nonUserNumberArr[0] : ""; 
										let totalLength1 = userArr.length;
										let nonUserNameLength = nonUserArr.length;
										let nonUserPhoneLength = nonUserNumberArr.length;

										if(totalLength1 >=2){
											displayText = !isEmpty(displayText) ? (displayText + " <fmt:message key='dropdown.etc' /> +" + String(totalLength1-1) ) : "";
											displayText1 = !isEmpty(displayText1) ? (displayText1 + " <fmt:message key='dropdown.etc' /> +" + String(totalLength1-1) ) : "";
										}

										if(nonUserNameLength >=2){
											textNonUserName = !isEmpty(textNonUserName) ? (textNonUserName + " <fmt:message key='dropdown.etc' /> +" + String(nonUserNameLength-1) ) : "";
										} else {
											textNonUserName = !isEmpty(textNonUserName) ? textNonUserName : "";
										}

										if(nonUserPhoneLength >=2){		
											textNonUserPhone = !isEmpty(tempNonUserNum) ? (tempNonUserNum + " <fmt:message key='dropdown.etc' /> +" + String(nonUserPhoneLength-1) ) : "";
										} else {
											textNonUserPhone = tempNonUserNum;
										}

										nonUserNameStr = [...new Set([...nonUserArr])].toString();
										nonUserNumStr = [...new Set([...nonUserNumberArr])].toString();
										
									} else {
									// either USER || NON USER
										if(el.userGroup === "user"){
											let length1 = el.alarmToUser.user.length;

											if(length1 > 0){
												for(let i=0, arrLength = length1; i<arrLength; i++ ){
													if(!isEmpty(el.alarmToUser.user[i].uid)){
														if(i==0){
															let found = userData.findIndex( x => x.uid == el.alarmToUser.user[i].uid);
															if(found > -1){
																displayText = userData[found].name;
																// console.log("userData[found]3434===", userData[found])
																if(!isEmpty(userData[found].contact_phone)){
																	displayText1 = userData[found].contact_phone;
																} else {
																	displayText1 = "<fmt:message key='siteSetting.noNum' />";
																}
															}
														}
														userArr.push(el.alarmToUser.user[i].uid);
													}
												}

												userArr = [...new Set([...userArr])];
												joinedVal = userArr.toString();

												let totalLength1 = userArr.length;
												// console.log("displayText===", displayText);
												// console.log("totalLength1===", totalLength1);
												
												if(totalLength1 >=2){
													displayText = displayText + " <fmt:message key='dropdown.etc' /> +" + String(totalLength1-1);
													displayText1 = displayText1 + " <fmt:message key='dropdown.etc' /> +" + String(totalLength1-1);
												}
											}
										} else if(el.userGroup === "non_user"){
											let length2 = el.alarmToUser.non_user.length;

											if(length2 > 0 ){
												for(let i=0, arrLength = length2; i<arrLength; i++ ){
													if(!isEmpty(el.alarmToUser.non_user[i].name)){
														if(isEmpty(textNonUserName)){
															textNonUserName = el.alarmToUser.non_user[i].name;
														}
														if(!isEmpty(el.alarmToUser.non_user[i].phone)){
															nonUserNumberArr.push(el.alarmToUser.non_user[i].phone);
														}
														nonUserArr.push(el.alarmToUser.non_user[i].name);
													} else {
														// nonUser does NOT have name
														if(!isEmpty(el.alarmToUser.non_user[i].phone)){
															nonUserArr.push("");
															nonUserNumberArr.push(el.alarmToUser.non_user[i].phone);
														}
													}		
												}

												nonUserArr = [...nonUserArr];
												nonUserNumberArr = [...nonUserNumberArr];

												// console.log("only nonUserArr===", nonUserArr);
												// console.log("only nonUserNumberArr===", nonUserNumberArr);
												// console.log("only non user textNonUserName===", textNonUserName);
												// console.log("only non user textNonUserPhone===", textNonUserPhone);
												
												let tempNonUserNum = !isEmpty(nonUserNumberArr[0]) ? nonUserNumberArr[0] : ""; 
												let nonUserNameLength = nonUserArr.length;
												let nonUserPhoneLength = nonUserNumberArr.length;
												
												if(nonUserNameLength >=2){
													textNonUserName = !isEmpty(textNonUserName) ? (textNonUserName + " <fmt:message key='dropdown.etc' /> +" + String(nonUserNameLength-1) ) : "";
												} else {
													textNonUserName = !isEmpty(textNonUserName) ? textNonUserName : "";
												}

												if(nonUserPhoneLength >=2){		
													textNonUserPhone = !isEmpty(tempNonUserNum) ? (tempNonUserNum + " <fmt:message key='dropdown.etc' /> +" + String(nonUserPhoneLength-1) ) : "";
												} else {
													textNonUserPhone = tempNonUserNum;
												}

												nonUserNameStr = [...new Set([...nonUserArr])].toString();
												nonUserNumStr = [...new Set([...nonUserNumberArr])].toString();

											}
										
										}
									}

									dropdown4 += `<div class="user-group" data-index="${'${index}'}">`
									
									if(displayText == "") {
										dropdown4 += `<div class="dropdown">
												<button type="button" class="dropdown-toggle" 
													data-function="concat"
													data-toggle="dropdown"
													data-child-id="aDvcPhoneUser${'${ newIdx }'}"
													data-name="<fmt:message key="dropDown.select" />" disabled><fmt:message key='siteSetting.select' />
													<span class="caret"></span>
												</button>
												<ul class="dropdown-menu chk-type" role="menu">${'${ userNameStr }'}</ul>
											</div>`;
									} else {
										dropdown4 += `<div class="dropdown">
											<button type="button" class="dropdown-toggle" 
												data-function="concat"
												data-toggle="dropdown"
												data-uid="${'${ joinedVal }'}" 
												data-phone="${'${ displayText1 }'}" 
												data-child-id="aDvcPhoneUser${'${ newIdx }'}"
												data-name="<fmt:message key="dropDown.select" />" disabled>${'${ displayText }'}
												<span class="caret"></span>
											</button>
											<ul id="aDvcUserList${'${ newIdx }'}" class="dropdown-menu chk-type" role="menu">${'${ userNameStr }'}</ul>
										</div>`;
									}
								
									if(isEmpty(textNonUserName) && isEmpty(textNonUserPhone)) {
										dropdown4 += `<div class="text-input-type disabled" 
											data-child-id="aDvcPhoneNonUser${'${ newIdx }'}"
											data-user-type="non-user">
											<input type="text" name="aDvcNonUserList${'${ newIdx }'}" placeholder="<fmt:message key='siteSetting.input.self' />" disabled />
										</div>`;
									} else {
										dropdown4 += `<div class="text-input-type disabled" 
											data-child-id="aDvcPhoneNonUser${'${ newIdx }'}"
											data-name-list="${'${ nonUserNameStr }'}"
											data-phone-list="${'${ nonUserNumStr }'}"
											data-phone="${'${ textNonUserPhone }'}"
											data-user-type="non-user">
											<input type="text" name="aDvcNonUserList${'${ newIdx }'}" data-value="${'${ textNonUserName }'}" disabled />
										</div>`;
									}
									dropdown4 += `</div>`;

								}
							
							});
							return dropdown4;
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.phone' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex ) {
							let dropdown5 = ``;
							let totalLength = 0;
							let displayText = '';

							$.each(data[1], function(index, el){
								let newIdx = String(rowIndex.row+index);
								dropdown5 += `<div class="phone-group" data-index="${'${index}'}">
									<div class="text-input-type disabled" 
										data-user-type="user">
										<input type="text" 
											name="aDvcPhoneUser${'${ newIdx }'}" 
											id="aDvcPhoneUser${'${ newIdx }'}" 
											data-parent-id="aDvcUserList${'${ newIdx }'}"
											value="" disabled />
									</div>
									<div class="text-input-type disabled" 
										data-user-type="non-user">
										<input type="text" 
											placeholder="<fmt:message key='siteSetting.input.self' />"
											data-parent-id="aDvcNonUserList${'${ newIdx }'}"
											name="aDvcPhoneNonUser${'${ newIdx }'}" 
											id="aDvcPhoneNonUser${'${ newIdx }'}" 
											value="" disabled />
									</div>
								</div>`;
							});
							return dropdown5;
						},
					},
					{
						"sTitle": "<fmt:message key='siteSetting.add.update.delete' />",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex ) {
							let dropdown6 = ``;
							$.each(data[1], function(index, el){
								dropdown6 += `<div class="flex-start">
									<button type="button" class="icon-add" data-index="${'${index}'}" onclick="updateAlarmTable($(this), 'add' )"><fmt:message key='siteSetting.add' /></button>
									<button type="button" class="icon-edit" data-index="${'${index}'}" onclick="updateAlarmTable($(this), 'edit')"><fmt:message key='siteSetting.update' /></button>
									<button type="button" class="icon-delete" data-index="${'${index}'}" onclick="updateAlarmTable($(this), 'delete')"><fmt:message key='siteSetting.delete' /></button>
								</div>`;
							});
							return dropdown6;
						},
						"className": "dt-body-center no-sorting",
					},
				],
				"language": {
					"paginate": {
						"previous": "",
						"next": "",
						// "sPrevious": "",
						// "sNext": ""
					},
				},
				initComplete: function(){
					this.api().columns().header().each ((el, i) => {
						if(i == 0){
							$(el).attr ('style', 'min-width: 140px; text-indent: 40px;');
						} else if(i == 1){
							$(el).attr ('style', 'min-width: 150px; text-indent: 10px;');
						} else if(i == 2){
							$(el).attr ('style', 'min-width: 150px; text-indent: 10px;');
						} else if(i == 3){
							$(el).attr ('style', 'min-width: 170px; text-indent: 10px;');
						} else if(i == 4){
							$(el).attr ('style', 'min-width: 170px; text-indent: 20px;');
						} else if(i == 5){
							$(el).attr ('style', 'min-width: 150px; text-indent: 40px;');
						}
					});
					let str = `<div id="btnGroup" class="right-end2"><!--
								--><button type="button" class="btn-type03 w-80px" data-dismiss="modal" aria-label="Close"><fmt:message key='siteSetting.cancel' /></button><!--
								--><button type="submit" class="btn-type w-80px ml-12"><fmt:message key='siteSetting.ok' /></button><!--
							--></div>`;
					$('#alarmTable_wrapper').append($(str));
					// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
					// 	cell.innerHTML = i+1;
					// 	$(cell).data("id", i);
					// });
					// this.api().column(5).visible( false );
				},
				rowCallback: function(row, data) {
					let length = 0;
					if(!isEmpty(data.alarmToUser)){
						if( userGroup == "user"){
							length += data.alarmToUser.user.length;
						} else if(userGroup == "non_user" ){
							length += data.alarmToUser.non_user.length;
						} else if(userGroup == "both" ){
							length += data.alarmToUser.user.length + data.alarmToUser.non_user.length;
						}
					}	
			
					if(length <= 1 ){
						$(row).addClass('single');
					}
				},
				drawCallback: function(settings){
					let userGroup = $("#alarmTable tbody").find(".user-group");

					for(let i=0, arrLength = userGroup.length; i<arrLength; i ++){
						let userNameBtn = userGroup.eq(i).find(".dropdown-toggle");
						let userNameInput = userGroup.eq(i).find(".text-input-type");

						userNameBtn.each(function(index, el){
							if(!isEmpty($(this).data("phone"))){
								let childId = "#" + $(this).data("child-id");
								$(childId).val($(this).data("phone"));
							}
						});
						userNameInput.each(function(index, el){
							if(!isEmpty($(this).data("phone")) || !isEmpty($(this).data("phone-list"))){
								let childId = "#" + $(this).data("child-id");
								let tempVal = "";

								if(!isEmpty($(this).data("phone-list"))){
									let val = String($(this).data("phone-list"));
									let newVal = "";
									if(val.includes(",")){
										let tempVal = val.split(",");
										newVal = tempVal[0] != "" ? tempVal[0] : tempVal[1];
									} else {
										newVal=val;
									}
									$(childId).attr({ "data-value": newVal, "placeholder": newVal });
								}			
							}
						});
					}
					$('#alarmTable_wrapper').addClass('fixed-width');
				},
				// fnInfoCallback: function( oSettings, iStart, iEnd, iMax, iTotal, sPre ) {
				// 	let td = $("#alarmTable tbody").find("td:first-child .dropdown");
				// 	let length = td.toArray().length;
				// 	let info = $("#alarmTable").DataTable().page.info();
				
				// 	console.log("info===", info);
				// 	// console.log("info.page===", info.page);
				// 	console.log("length===", length);
				// 	return (info.page+1) + " - " + length + " / 총 " + entriesLength +  " 개"  

				// 	// return iStart +" to "+ iEnd;
				// }
			}).columns.adjust();

			setTimeout(function(){
				$("#loadingCircle2").hide();
				$("#addAlarmModal").modal("show");
			}, 400)

		});
			

	}

	function updateAlarmTable(self, option){
		let dataIdx = self.data("index");
		let tr = self.parents().closest("tr");
		let td = tr.find("td");

		let dTable = $("#alarmTable").DataTable();	
		let rowData = dTable.row(tr).data();	
		let btnSiblings = $(self).parent(".flex-start").siblings();

		if(option == "add"){
			let copy = tr.clone(true);
			copy.find("td").each(function(index, el){
				if(index<=2){
					$(this).find(".dropdown:not(:last-of-type)").remove();
					$(this).find(".dropdown-toggle").html("<fmt:message key='siteSetting.select' /><span class='caret'></span>").attr({"data-index": dataIdx, "data-value": ""});
					$(this).find("input[type='checkbox']").prop("checked", false);
					if(index === 0 || index === 2){
						if(index === 0) {
							$(this).find(".dropdown-menu li").attr("onclick", "showSubgroup(this)");
						}
						$(this).find(".dropdown-toggle").prop("disabled", false);
					}
				} else {
					if(index<=4){
						if(index===3){
							$(this).find(".user-group:not(:last-of-type)").remove();
							$(this).find(".user-group").attr("data-index", dataIdx);
							$(this).find("input[type='checkbox']").prop("checked", false);
							$(this).find(".dropdown-toggle").prop("disabled", false).html("<fmt:message key='siteSetting.select' /><span class='caret'></span>").attr({"data-index": dataIdx, "data-value": ""});
							$(this).find("input[type='text']").prop("disabled", false).attr("placeholder", "").val("").parent().removeClass("disabled");
						}  else if(index===4){
							$(this).find(".phone-group:not(:last-of-type)").remove();
							$(this).find(".phone-group").attr("data-index", dataIdx);
							$(this).find(".text-input-type:nth-of-type(1) input[type='text']").val("");
							$(this).find(".text-input-type:nth-of-type(2) input[type='text']").prop("disabled", false).attr("placeholder", "").val("").parent().removeClass("disabled");
						}
						
					} else {
						$(this).find(".flex-start:not(:last-of-type)").remove();
						$(this).find(".flex-start .icon-add").attr("data-index", dataIdx);
						$(this).find(".flex-start .icon-edit").attr("data-index", dataIdx).prop("disabled", true);
						$(this).find(".flex-start .icon-delete").attr("data-index", dataIdx).attr("onclick", "updateAlarmTable($(this), 'delete')");
					}
				}
			});

			let idAttr = copy.find('[id^="aDvc"]');
			let childIdAttr = copy.find('[data-child-id^="aDvc"]');
			let parentIdAttr = copy.find('[data-parent-id^="aDvc"]');
			let nameAttr = copy.find('[name^="aDvc"]');

			idAttr.each(function(index, el){
				let oldId = $(this).attr("id");
				let num = (Number(oldId.match(/\d+/)[0]) + 1 );
				let newId = oldId + '_' + String(num);
				$(this).attr("id", newId);
			});

			nameAttr.each(function(index, el){
				let oldName = $(this).attr("name");
				let num = (Number(oldName.match(/\d+/)[0]) + 1 );
				let newName = oldName + '_' + String(num);
				$(this).attr("name", newName);
			});

			childIdAttr.each(function(index, el){
				let oldName = $(this).data("child-id");
				let num = ( Number(oldName.match(/\d+/)[0]) + 1 );
				let newName = oldName + '_' + String(num);
				$(this).attr("data-child-id", newName);
			});

			parentIdAttr.each(function(index, el){
				let oldName = $(this).data("parent-id");
				let num = (Number(oldName.match(/\d+/)[0]) + 1 );
				let newName = oldName + '_' + String(num);
				$(this).attr("data-parent-id", newName);
			});

			$("#alarmTable tbody").append(copy);

		} else {
			if(option == "edit"){
				td.each(function(index, el){
					let dropdown = $(this).find(".dropdown-toggle").eq(dataIdx);
					if(index>=1 && index<3){
						if(dropdown.is(":disabled")) {
							dropdown.prop("disabled", false);
						} else {
							dropdown.prop("disabled", true);
						}
					} else if(index===3){
						let nonUserGroup = $(this).find(".user-group").eq(dataIdx);
						let nameInput = nonUserGroup.find("input[type='text']");

						if(nameInput.first().is(":disabled")) {
							dropdown.prop("disabled", false);
							nameInput.each(function(index, el){
								$(el).prop("disabled", false).parent().removeClass("disabled");
							});
						} else {
							dropdown.prop("disabled", true);
							nameInput.each(function(index, el){
								$(el).prop("disabled", true).parent().addClass("disabled");
							});
						}
					} else if(index===4){
						let prevNameInput = td.eq(index-1).find(".user-group").eq(dataIdx);
						let nameInput = prevNameInput.find("input[type='text']");
						let nonUserPhoneGroup = $(this).find(".phone-group").eq(dataIdx);
						let phoneInput = nonUserPhoneGroup.find(".text-input-type[data-user-type='non-user']");
						if(nameInput.first().is(":disabled")) {
							phoneInput.addClass("disabled").find("input").prop("disabled", true);
						} else {
							phoneInput.removeClass("disabled").find("input").prop("disabled", false);
						}
					}
				});
			}

			if(option == "delete"){
				let didMatchArr = Object.values(alarmDataList);

				didMatchArr.forEach( (item, index) => {
					let targetDropdown = td.eq(1).find(".dropdown-toggle[data-index='" + dataIdx + "']");
					let targetDid = targetDropdown.data("did");

					let found = item.findIndex( x => x.did === targetDid );
					if(found > -1){
						if(!isEmpty(item[found].alarm_to)){
							deleteAlarmList.push({ deviceId: targetDid, alarm_to : item[found].alarmToUser });
						}
						
					}
				});

				if(tr.siblings().length == 0) {					
				// ONLY single row is present
					if(btnSiblings.length == 0){
						tr.eq(btnSiblings.length).addClass("hidden");
					} else {
						td.each(function(index, el){
							if(index >= 0 && index <= 2){
								let dropdown = $(el).find(".dropdown-toggle[data-index='" + dataIdx + "']");
								dropdown.parent().remove();
							} else if(index === 3){
								let dropdown = $(el).find(".dropdown-toggle[data-index='" + dataIdx + "']");
								dropdown.parent().remove();
								$(el).find(".user-group[data-index='" + dataIdx + "']").remove();
							} else if(index === 4){
								$(el).find(".phone-group[data-index='" + dataIdx + "']").remove();
							} else if(index === 5){
								$(self).parent().remove();
							}
						});							
					}
				} else {
					// Multiple rows are present
					if(btnSiblings.length == 0){
						tr.eq(btnSiblings.length).remove();
					} else {
						td.each(function(index, el){
							let dropdown = $(el).find(".dropdown-toggle[data-index='" + dataIdx + "']");
							if(index >= 0 && index <= 2){
								dropdown.parent().remove();
							} else if(index === 3){
								dropdown.parent().remove();
								$(el).find(".user-group[data-index='" + dataIdx + "']").remove();
							} else if(index === 4){
								$(el).find(".phone-group[data-index='" + dataIdx + "']").remove();
							} else if(index === 5){
								$(self).parent().remove();
							}
						});
					}
				}
			}
		}

	}

	function insertRowCopy(){
		let tr = $("#alarmTable tbody tr");

		if(tr.hasClass("hidden")){
			tr.removeClass("hidden");
		} else {
			let copy = tr.last().clone(true);
			let temTd = copy.find("td");

			temTd.each(function(index, el){
				let tempIdx;
				if(index === 0){
					tempIdx = $(this).find(".dropdown-toggle").data("index") + 1;
				}

				if(index <= 2){
					$(this).find(".dropdown:not(:first-of-type)").remove();
					$(this).find(".dropdown-toggle").html("<fmt:message key='siteSetting.select' /><span class='caret'></span>").attr({"data-value": "", "data-index": tempIdx});
					$(this).find("input[type='checkbox']").prop("checked", false);
					if(index === 0 || index === 2){
						if(index === 0) {
							$(this).find(".dropdown-menu li").attr("onclick", "showSubgroup(this)");
						}
						$(this).find(".dropdown-toggle").prop("disabled", false);					
					}
				} else {
					if(index<=4){
						if(index===3){
							$(this).find(".user-group:not(:first-of-type)").remove();
							$(this).find("input[type='checkbox']").prop("checked", false);
							$(this).find(".dropdown-toggle").prop("disabled", false).html('<fmt:message key="dropDown.select" /><span class="caret"></span>').attr({"data-value": "", "data-index": tempIdx});
							$(this).find("input[type='text']").prop("disabled", false).attr("placeholder", "").val("").parent().removeClass("disabled");
						} else if(index===4){
							$(this).find(".phone-group:not(:first-of-type)").remove();
							$(this).find(".text-input-type:nth-of-type(1) input[type='text']").val("");
							$(this).find(".text-input-type:nth-of-type(2) input[type='text']").attr("placeholder", "").prop("disabled", false).val("").parent().removeClass("disabled");
						}
					} else {
						$(this).find(".flex-start:not(:first-of-type)").remove();
						$(this).find(".icon-add").attr({"data-value": "", "data-index": tempIdx});
						$(this).find(".icon-edit").prop("disabled", true).attr({"data-value": "", "data-index": tempIdx});
						$(this).find(".icon-delete").attr({"data-index": tempIdx});
					}	
				}
			});

			let idAttr = copy.find('[id^="aDvc"]');
			let nameAttr = copy.find('[name^="aDvc"]');
			let childIdAttr = copy.find('[data-child-id^="aDvc"]');
			let parentIdAttr = copy.find('[data-parent-id^="aDvc"]');

			idAttr.each(function(index, el){
				let oldId = $(this).attr("id");
				let num = (Number(oldId.match(/\d+/)[0]) + 1 );
				let newId = oldId + String(num);
				// let num = Number(oldId.match(/\d+/)[0]) + 1;
				// let text = oldId.match(/[^\d]+/) + String(num);
				$(this).attr("id", newId);
			});

			nameAttr.each(function(index, el){
				let oldName = $(this).attr("name");
				let num = (Number(oldName.match(/\d+/)[0]) + 1 );
				let newName = oldName + String(num);

				$(this).attr("name", newName);

			});

			childIdAttr.each(function(index, el){
				let oldName = $(this).data("child-id");
				let num = (Number(oldName.match(/\d+/)[0]) + 1 );
				let newName = oldName + '_' + String(num);
				$(this).attr("data-child-id", newName);
			});

			parentIdAttr.each(function(index, el){
				let oldName = $(this).data("parent-id");
				let num = (Number(oldName.match(/\d+/)[0]) + 1 );
				let newName = oldName + '_' + String(num);
				$(this).attr("data-parent-id", newName);
			});
			
			$("#alarmTable tbody").append(copy);
		}	

	}

	function showPhoneNum(self){
		setTimeout(function(){
			let td = $(self).parents().closest("tr").find("td");
			let checked = $(self).parent().find("input[type='checkbox']:checked");
			let val = $(self).find("input[type='checkbox']").data("contact-num");
			let dataIdx = $(self).parents().closest(".user-group").data("index");
			let phoneGroup = td.find(".phone-group[data-index='" + dataIdx + "']");
			let target = phoneGroup.find(".text-input-type[data-user-type='user'] input");

			if(checked.length >= 1) {
				if(isEmpty($(target).val()) || (checked.length === 1) ){
					$(target).val(val);
				} else {
					let tempVal = $(target).val();
					let newVal = tempVal.split("<fmt:message key='dropdown.etc' />");
					$(target).val(newVal[0].trim() + " <fmt:message key='dropdown.etc' /> " + String(checked.length-1));
				}
			} else {
				$(target).val("");
			}
		}, 200);
	}


	function truncateNonDigit (evt, self, option){
		let val = $(self).val();
		if(option) {
			$(self).val(val.replace(/[^0-9\.]/g,''));
		} else {
			$(self).val(val.replace(/[^0-9\.\,]/g,''));
		}
	}

	function formatUnit(self, data){
		let val = "";
		if(isEmpty(data)){
			val = $(self).val();
			if(typeof val == "number"){
				val = String(val);
			}
		} else {
			val = data;
			if(typeof val == "number"){
				val = String(val);
			}
		}
		if(!isEmpty(val)){
			if(val.indexOf('.') > -1){
				let temp = val.split(".");
				if (temp[0].length >= 5) {
					if(temp[0].indexOf(',') > -1){
						temp[0] = temp[0].replace(/,/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					// temp[0] = temp[0].replace(/(\d)(?=(\d{3})+$)/g, '$1,');
					} else {
						temp[0] = temp[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}

				}
				if (temp[1] && temp[1].length > 3) {
					temp[1] = temp[1].replace(/(\d)(?=(\d{3})+$)/g, '');
				}
				temp = temp.join('.');
				$(self).val(temp);
			} else {
				if (val.length >= 5) {
					if(val.indexOf(',') > -1){
						val = val.replace(/,/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					} else {
						val = val.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
					$(self).val(val);
				}
			}
		}
	}

	function formatRatio(self) {
		let val = $(self).val();
		if(val.indexOf('.') > -1){
			let temp = val.split(".");
			if(Number(temp[0]) > 100 ) {
				$(self).val("100");
			}
		} else {
			if(Number(val) > 100 ) {
				$(self).val("100");
			}
		}
	}

	function weatherGridCalculator() {
		const newCoord = $('#newCoord').val();
		$("#latLongWarning").addClass('hidden');
		if (!isEmpty(newCoord)) {
			if (newCoord.match(',')) {
				const thisValArr = newCoord.split(',');
				let stationId = cloesed_aws_point(thisValArr[0], thisValArr[1]);
				let grid = dfs_xy_conv('toXY', thisValArr[0], thisValArr[1]);

				if (!isEmpty(stationId)) {
					$('#station_id').val(stationId);
				}

				if (!isEmpty(grid.x) && !isEmpty(grid.y)) {
					$('#gridX').val(grid.x);
					$('#gridY').val(grid.y);
				}
			} else {
				$("#latLongWarning").removeClass('hidden');
			}
		} else {
			$("#latLongWarning").removeClass('hidden');
		}
	}
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header"><fmt:message key='siteSetting.site.manage' /></h1>
	</div>
</div>

<c:set var="siteList" value="${siteHeaderList}"/>

<div id="propertyRow" class="row">
	<div class="col-10">
		<div class="flex-group">
			<span class="tx-tit"><fmt:message key='siteSetting.site.type' /></span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown"><fmt:message key='siteSetting.all' /><span class="caret"></span></button>
					<ul id="siteType" class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="inline-title"><fmt:message key='siteSetting.location' /></span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
				<ul id="countryList" class="dropdown-menu chk-type" role="menu">
					<li><a href="#"><fmt:message key='siteSetting.all' /></a></li>
					<c:forEach var="country" items="${location}">
						<c:if test="${country.value.code eq 'kr'}">
							<c:forEach var="city" items="${country.value.locations}" varStatus="cityName">
								<li data-id="${city.value.code}" data-value="${city.value.name.kr}">
									<!-- <a href="#" tabindex="-1"><c:out value="${city.value.code}"></c:out> -->
									<a href="#" tabindex="-1">
										<input type="checkbox" name="${city.value.name.en}" id="${city.value.code}" value="${city.value.name.kr}">
										<label for="${city.value.code}" class="on"><c:out value="${city.value.code}"></c:out></label>
									</a>
								</li>
							</c:forEach>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="tx-tit"><fmt:message key='siteSetting.resource' /></span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
				<ul id="resTypeList" class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="tx-tit"><fmt:message key='siteSetting.site.name' /></span>
			<div class="flex-start">
				<div class="text-input-type">
					<input type="text" id="siteSearchBox" name="site_search_box" placeholder="<fmt:message key='siteSetting.input' />">
				</div>
			</div>
		</div>
	</div>
	<div class="col-2">
		<div id="exportBtnGroup" class="fr"></div>
		<!-- <button type="button" class="btn-save ml-16 fr" onclick="$(this).prev().toggleClass('hidden')">데이터 다운로드</button>--> 
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="siteTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:12%">
					<col style="width:16%">
					<col style="width:5%">
					<col style="width:6%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:12%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>

<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="deleteConfirmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit"><fmt:message key='siteSetting.errorTxt.1' /><br><span class="text-blue"></span>&ensp;<fmt:message key='siteSetting.errorTxt.2' /></h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" name="confirm_site" id="confirmSite" placeholder="<fmt:message key='siteSetting.input.sitename' />"/></div>
			</div>
			<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w-80px" data-dismiss="modal" aria-label="Close"><fmt:message key='siteSetting.cancel' /></button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn-type w-80px ml-12" disabled><fmt:message key='siteSetting.ok' /></button><!--
			--></div>
		</div>
	</div>
</div>


<div class="modal fade stack" id="alarmDeleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="alarmDeleteConfirmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="alarmDeleteSuccessMsg" class="ntit"><fmt:message key='siteSetting.errorTxt.3' /><br><span class="text-blue"></span>&ensp;<fmt:message key='siteSetting.errorTxt.4' /></h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" name="confirm_alarm" id="confirmAlarm" placeholder="<fmt:message key='siteSetting.input.devicename' />"/></div>
			</div>
			<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w-80px" data-dismiss="modal" aria-label="Close"><fmt:message key='siteSetting.cancel' /></button><!--
				--><button type="submit" id="alarmDeleteConfirmBtn" class="btn-type w-80px ml-12" disabled><fmt:message key='siteSetting.ok' /></button><!--
			--></div>
		</div>
	</div>
</div>



<div class="modal fade" id="addAlarmModal" tabindex="-1" role="dialog" aria-labelledby="addAlarmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-xl">
		<div class="modal-content alarm-modal-content">
			<div class="modal-header flex-start">
				<fmt:message key='siteSetting.alarmSetting' /><button type="button" class="btn-add ml-24" onclick="insertRowCopy()"><fmt:message key='siteSetting.addRow' /></button><!--
				--><small id="duplicatedGroup" class="warning hidden"><fmt:message key='siteSetting.errorTxt.5' /></small><!--
				--><small id="noIdWarning" class="warning hidden"><fmt:message key='siteSetting.errorTxt.6' /></small><!--
			--></div>
			<div class="modal-body mt-10">
				<form name="add_alarm_form" id="updateAlarmForm">
					<table id="alarmTable" class="no-stripe w-100">
						<colgroup>
							<col style="width:14%">
							<col style="width:16%">
							<col style="width:16%">
							<col style="width:20%">
							<col style="width:20%">
							<col style="width:14%">
						</colgroup>
						<thead></thead>
						<tbody></tbody>
					</table>
				</form>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog" aria-labelledby="addSiteModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-custom-xl">
		<div class="modal-content site-modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1><fmt:message key='siteSetting.add.site' /><span class="required fr"><fmt:message key='siteSetting.required' /></span></h1></div>
			<div id="titleEdit" class="modal-header"><h1><fmt:message key='siteSetting.update.site' /></h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_site_form" id="updateSiteForm" class="setting-form" autocomplete="off">
						<section id="sectionSiteInfo">
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label asterisk"><fmt:message key='siteSetting.site.name' /></span></div>
								<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex-start">
										<div class="text-input-type offset-73">
											<input type="text" name="new_site_name" id="newSiteName" placeholder="<fmt:message key='siteSetting.input' />" minlength="2" maxlength="30">
										</div>
										<button type="button" class="btn-type fr" onclick="checkSiteId($('#newSiteName').val().trim())" disabled><fmt:message key='siteSetting.checkOverlap' /></button>
									</div>
									<small class="hidden warning"><fmt:message key='siteSetting.errorTxt.7' /></small>
									<small class="hidden warning"><fmt:message key='siteSetting.errorTxt.8' /></small>
									<small class="hidden warning"><fmt:message key='siteSetting.errorTxt.9' /></small>
									<small id="invalidSite" class="hidden warning"><fmt:message key='siteSetting.errorTxt.10' /></small>
									<small id="validSite" class="text-blue text-sm hidden"><fmt:message key='siteSetting.errorTxt.11' /></small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.site.type' /></span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
										<ul id="newSiteType" class="dropdown-menu"></ul>
									</div>
									<small class="hidden warning"><fmt:message key='siteSetting.errorTxt.12' /></small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label asterisk"><fmt:message key='siteSetting.power' /></span></div>
								<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
										<ul id="newResList" class="dropdown-menu"></ul>
									</div>
									<small class="hidden warning"><fmt:message key='siteSetting.errorTxt.13' /></small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.isESS' /></span></div>
								<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
										<ul id="newEssList" class="dropdown-menu">
											<li data-value="1"><a href="#"><fmt:message key='siteSetting.isESS.Y' /></a></li>
											<li data-value="0"><a href="#"><fmt:message key='siteSetting.isESS.N' /></a></li>
										</ul>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label asterisk"><fmt:message key='siteSetting.site.location' /></span></div>
								<div class="col-xl-6 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex-start">
										<div class="dropdown w-55">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
											<ul id="newCityList" class="dropdown-menu">
												<c:forEach var="country" items="${location}">
													<c:forEach var="city" items="${country.value.locations}" varStatus="cityName">
														<li data-value="${city.value.code}">
															<a href="#" tabindex="-1">
																<c:choose>
																	<c:when test="${cookieLang eq 'KO'}">
																		${city.value.name.kr}
																	</c:when>
																	<c:otherwise>
																		${city.value.name.en}
																	</c:otherwise>
																</c:choose>
															</a>
														</li>
													</c:forEach>
												</c:forEach>
											</ul>
										</div>
										<div class="text-input-type w-100"><input type="text" name="new_street_addr" id="newStreetAddr" placeholder="<fmt:message key='siteSetting.input' />" minlength="3" maxlength="28"></div>
									</div>
									<small class="hidden warning"><fmt:message key='siteSetting.errorTxt.14' /></small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.latNlon' /></span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="text-input-type"><input type="text" name="new_coord" id="newCoord" placeholder="<fmt:message key='siteSetting.example' />) 35.9078, 127.7669" minlength="3" maxlength="28"></div>
									<small id="latLongWarning" class="hidden warning"><fmt:message key='siteSetting.errorTxt.15' /></small>
								</div>
								<div class="col-xl-2 col-lg-12 col-md-12 col-sm-12 pl-0">
									<button type="button" class="btn-type w-100" onclick="weatherGridCalculator();"><fmt:message key='siteSetting.calcGrid' /></button>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.extendInfo' /></span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<textarea name="new_site_desc" id="newSiteDetail" class="textarea" placeholder="<fmt:message key='siteSetting.input' />"></textarea>
								</div>
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.observerNum' /></span></div>
								<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="text-input-type">
										<input type="text" name="station_id" id="station_id" placeholder="<fmt:message key='siteSetting.input' />" minlength="1" maxlength="15">
									</div>
								</div>
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.grid' /> </span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="text-input-type">
										<input type="text" name="gridX" id="gridX" placeholder="<fmt:message key='siteSetting.input.gridX' />" minlength="1" maxlength="4" onkeydown="onlyNum(event)">
									</div>
									<div class="text-input-type mt-5">
										<input type="text" name="gridY" id="gridY" placeholder="<fmt:message key='siteSetting.input.gridY' />" minlength="1" maxlength="4" onkeydown="onlyNum(event)">
									</div>
								</div>
							</div>

							<c:if test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.generatorCode' /></span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="text" name="kpx_genid" id="kpx_genid" placeholder="<fmt:message key='siteSetting.input' />" minlength="2" maxlength="15">
											</div>
										</div>
									</div>
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.volt' /></span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="text" name="kpx_transvol" id="kpx_transvol" placeholder="<fmt:message key='siteSetting.input' />" minlength="2" maxlength="15">
											</div>
										</div>
									</div>
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.EMScode' /></span></div>
									<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="text" name="kpx_emsid" id="kpx_emsid" placeholder="<fmt:message key='siteSetting.input' />" minlength="2" maxlength="100">
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</section>

						<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
							<section id="sectionPowerMarketInfo">
								<h2 class="stit"><fmt:message key='siteSetting.powerBuyInfo' /></h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.contractType' /></span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
												<ul id="newContractList" class="dropdown-menu"></ul>
											</div>
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle optional" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />" disabled><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
												<ul id="newVoltTypeList" class="dropdown-menu"></ul>
											</div>
										</div>
										<small id="newVoltWarning" class="hidden warning"><fmt:message key='siteSetting.errorTxt.16' /></small>
									</div>
									
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.contractPower' /></span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_peak_demand" id="newPeakDemand" class="pr-36" oninput="truncateNonDigit(event, this)" onkeyup="formatUnit(this)" placeholder="<fmt:message key='siteSetting.input' />" maxlength="10"><span class="unit">kW</span></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label offset-top"><fmt:message key='siteSetting.applyPay' /><br><fmt:message key='siteSetting.power' /></span></div>
									<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_dr_charge" id="newDrCharge" class="pr-36" oninput="truncateNonDigit(event, this)" onkeyup="formatUnit(this)" placeholder="<fmt:message key='siteSetting.input' />" maxlength="10"><span class="unit">kW</span></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.meterReadingDate' /></span></div>
									<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
											<ul id="newInspection" class="dropdown-menu"></ul>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label offset-top"><fmt:message key='siteSetting.gkswjs' /><br><fmt:message key='siteSetting.customerNumber' /></span></div>
									<div class="col-xl-3 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_kepco_id" id="newKepcoId" placeholder="<fmt:message key='siteSetting.input' />" maxlength="18"></div>
									</div>

									<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input-label offset-top">iSMART<br><fmt:message key='siteSetting.id' /></span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_smart_id" id="newISmartId" placeholder="<fmt:message key='siteSetting.input' />" maxlength="18"></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label offset-top">iSMART<br><fmt:message key='siteSetting.password' /></span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><!--
										--><input type="password" name="new_smart_pwd" id="newISmartPwd" placeholder="<fmt:message key='siteSetting.input' />" maxlength="18" autocomplete>
										<%--
											<button type="button" class="pwd-icon" onclick="showPwd('newISmartPwd', this)">show</button>
										--%>
									</div>
									</div>
								</div>
							</section>
							<section id="sectionPowerMarketInfo">
								<h2 class="stit"><fmt:message key='siteSetting.meterInfo' /></h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.normalPrice' /></span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
												<ul id="newPriceModelList" class="dropdown-menu">
													<li data-name="고정가" data-value="fixed"><a href="#"><fmt:message key='siteSetting.truePrice' /></a></li>
													<li data-name="SMP평균" data-value="SMP_mean"><a href="#"><fmt:message key='siteSetting.SMP.avg' /></a></li>
													<li data-name="SMP" data-value="SMP"><a href="#"><fmt:message key='siteSetting.SMP' /></a></li>
												</ul>
											</div>
											<div class="text-input-type hidden"><input type="text" name="Price" id="newPrice" oninput="truncateNonDigit(event, this)" placeholder="<fmt:message key='siteSetting.input' />" maxlength="8"></div>
										</div>
									</div>
								</div>
							</section>

							<!-- <section id="sectionDRInfo">
								<h2 class="stit">DR 거래 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">자원 ID</span></div>
									<div class="col-xl-3 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key="dropDown.select" /><span class="caret"></span></button>
											<ul id="newDrResIdList" class="dropdown-menu"></ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input-label">계약용량</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type">
											<input type="text" name="new_dr_vol" id="newDrVol" class="pr-36" oninput="truncateNonDigit(event, this)" onkeyup="formatUnit(this)" placeholder="<fmt:message key='siteSetting.input' />" maxlength="10"><span class="unit">kW</span>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">CBL 계산식</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key="dropDown.select" /><span class="caret"></span></button>
											<ul id="newCblList" class="dropdown-menu">
												<li data-value="max45"><a href="#">max45</a></li>
												<li data-value="mid68"><a href="#">mid68</a></li>
											</ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">수익 분배율</span></div>
									<div class="col-xl-1 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_dr_rev_share" id="newDrRevShare" class="pr-36" oninput="truncateNonDigit(event, this, 'percentage')" onkeyup="formatRatio(this)" placeholder="<fmt:message key='siteSetting.input' />" maxlength="5"><span class="unit">%</span></div>
									</div>
								</div>
							</section> -->

							<section id="sectionVppInfo">
								<h2 class="stit"><fmt:message key='siteSetting.deal.info' /></h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.resourceID' /></span></div>
									<div class="col-xl-3 col-lg-3 col-sm-4 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="dropDown.select" />"><fmt:message key='siteSetting.select' /><span class="caret"></span></button>
											<ul id="newVppResIdList" class="dropdown-menu"></ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-1 col-sm-2"><span class="input-label"><fmt:message key='siteSetting.revenue.share' /></span></div>
									<div class="col-xl-2 col-lg-2 col-sm-4 pl-0">
										<div class="text-input-type"><input type="text" name="vpp_rev_share" id="newVppRevShare" class="pr-36" oninput="truncateNonDigit(event, this, 'percentage')" onkeyup="formatRatio(this)" placeholder="<fmt:message key='siteSetting.input' />" maxlength="5"><span class="unit">%</span></div>
									</div>
								</div>
							</section>
						</c:if>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key='siteSetting.cancel' /></button>
									<button type="submit" id="addSiteBtn" class="btn-type" disabled><fmt:message key='siteSetting.add' /></button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
