<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/weather_station_info.js"></script>
<script type="text/javascript">
	let deviceNameList = [];

	$(function () {
		let optionList = [
			{
				url: apiHost + "/config/sites?oid=" + oid,
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/auth/me/groups?includeSites=false&includeDevices=false",
				type: 'get',
				async: true
			},
			{
				url: apiHost + "/auth/me/sites",
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
			Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])), Promise.resolve(returnAjaxRes(optionList[4])) ]).then( res => {
				deviceNameList = res[2];
				adminTable(res[0], res[1]);
			});
		} else {
			Promise.all( [ Promise.resolve(returnAjaxRes(optionList[2])), Promise.resolve(returnAjaxRes(optionList[1])), Promise.resolve(returnAjaxRes(optionList[4]) ) , Promise.resolve(returnAjaxRes(optionList[3]))] ).then( res => {
				deviceNameList = res[3];
				nonAdminTable( res[0], res[1], res[2].user_sites );
			});
		}

		// Validations
		$("#newSiteName").on("keydown", function() {
			$("#invalidSite").addClass("hidden");
			validateForm();
		});

		$("#newSiteName").on("keyup", function() {
			let warning = $("#validSite").parent().find(".warning");

			$("#validSite").addClass("hidden")

			if( $(this).val().trim().match(/^[.!#$%&'*+/=?^`{|}~]/) ) {
				warning.eq(2).removeClass("hidden");
			} else {
				warning.eq(2).addClass("hidden");
			}

			if( $(this).val().trim().length <= 1 || $(this).val().trim().length > 15) {
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
			// 	$("#newSiteType").prev().data({"value": "", "name" : ""}).html("해당 사항 없음<span class='caret'></span>").prop("disabled", true);
			// 	$("#newResList li").removeClass("hidden");
			// } else {
			// 	$("#newSiteType").prev().prop("disabled", false);
			// }
			
			// else {
			// 	$("#newSiteType").prev().html("선택<span class='caret'></span>").prop("disabled", false);
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
			let sid = dTable.row(tr).data().sid;
			let modalBody = $("#deleteConfirmModal .modal-body");

			let optDelete = {
				url: apiHost + "/config/sites/" + sid,
				type: "delete",
				async: true,
			}

			$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("사이트가 삭제 되었습니다.").removeClass("hidden");
				dTable.row(tr).remove().draw();
				// refreshSiteList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1000);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("사이트 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
				console.log("fail==", jqXHR)
			});
		});

		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#confirmSite").val("");
			$("#deleteConfirmBtn").prop("disabled", true);
			setTimeout(function(){
				$(this).find(".modal-body").removeClass("hidden");
			}, 1600);
		});

		$("#addAlarmModal").on("hide.bs.modal", function() {
			$("#alarmTable").DataTable().destroy();
			initAlarmTable();
		});

		$("#resultModal").on("hide.bs.modal", function() {
			$(this).find("h4").addClass("hidden");
		});

		// Form Submission !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
					$("#addSiteModal").modal("hide");
					$("#resultSuccessMsg").text("사이트가 추가 되었습니다.").removeClass("hidden");
					$("#resultBtn").parent().addClass("hidden");
					$("#resultModal").modal("show");
					refreshSiteList();
					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 1600);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					$("#addSiteModal").modal("hide");
					$("#resultFailureMsg").removeClass("hidden");
					$("#resultBtn").parent().removeClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 1600);
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});

			} else {
				// 2. EDIT site info
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
					$("#addSiteModal").modal("hide");
					$("#resultSuccessMsg").text("사이트 정보가 변경 되었습니다.").removeClass("hidden");
					$("#resultBtn").parent().addClass("hidden");
					$("#resultModal").modal("show");
					refreshSiteList();

					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 1600);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					$("#resultFailureMsg").removeClass("hidden");
					$("#resultBtn").parent().removeClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 1600);
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});

			}
		});

		$("#updateAlarmForm").on("submit", function(e){
			e.preventDefault();
			let aTable = $("#alarmTable").DataTable();
			let ajaxPromises = [];
			let tr = $("#alarmTable tbody tr:not(.hidden)");

			$.each(tr, function(index, el){
				let td = $(this).find("td");
				let did = td.eq(0).find(".dropdown-toggle").data("did");
				let alarmLvl = td.eq(2).find(".dropdown-toggle");
				let contactName = td.eq(3).find(".dropdown-toggle");
				// let contactInput = td.eq(3).find(".dropdown + .text-input-type");
				let contactNum = td.eq(4).find(".text-input-type");
				let nonUserArr = [];
				let registeredUserArr = [];
				let alarmToObj = {};

				let deviceOpt = {
					url: apiHost + "/config/devices/" + did,
					type: 'patch',
					async: true,
					contentType: 'application/json; charset=UTF-8',
				};
				for(let i=0, length = alarmLvl.length; i<length; i++){
					// if(!$(editItems[i]).is(":disabled")){
					if( (!alarmLvl.eq(i).is(":disabled") ) && !isEmpty(did) ){
						let levelArr = [];
						let contactNameArr = [];
						let contactNumArr = [];
						let selectedLevel = alarmLvl.eq(i).parent().find("input:checked");
						let selectedContactName = contactName.eq(i).parent().find("input:checked");

						$.each(selectedLevel, function(){
							levelArr.push(Number($(this).val()));
						});

						if( !contactNum.eq(i).hasClass("disabled") ){
							let nonUserObj = {};
							nonUserObj.level = levelArr;
							nonUserObj.name = contactName.eq(i).parent().next().find("input[type='text']").val();
							nonUserObj.phone = contactNum.eq(i).children().val();
							nonUserArr.push(nonUserObj);
						} else {
							$.each(selectedContactName, function(){
								let userObj = {};
								userObj.uid = $(this).val();
								userObj.level = levelArr;
								registeredUserArr.push(userObj);
							});
						}
					}

				}

				if(!isEmpty(nonUserArr) && !isEmpty(registeredUserArr)) {
					alarmToObj = {
						non_user: nonUserArr,
						user: registeredUserArr
					}
				} else {
					if(!isEmpty(nonUserArr)){
						alarmToObj = {
							non_user: nonUserArr
						}
					}
					if(!isEmpty(registeredUserArr)){
						alarmToObj = {
							user: registeredUserArr
						}
					}
				}
	
				let newObj = {
					alarm_to: JSON.stringify(alarmToObj)
				}
				deviceOpt.data = JSON.stringify(newObj);
				console.log("alarmToObj===", alarmToObj)
				ajaxPromises.push(makeAjaxCall(deviceOpt));
			});

			Promise.all(ajaxPromises).then(res => {
				$("#addAlarmModal").modal("hide");
				$("#resultSuccessMsg").text("알람 설정이 완료 되었습니다.").removeClass("hidden");
				$("#resultBtn").parent().addClass("hidden");
				$("#resultModal").modal("show");

				$("#siteTable").DataTable().destroy();
				$("#alarmTable").DataTable().destroy();

				setTimeout(function(){
					refreshSiteList();
				}, 200);

				setTimeout(function(){
					$("#resultModal").modal("hide");
				}, 1600);
			});
		});
		
	});

	function refreshSiteList(){
		let optionList = [
			{
				url: apiHost + "/config/sites?oid=" + oid,
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/auth/me/groups?includeSites=false&includeDevices=false",
				type: 'get',
				async: true
			},
			{
				url: apiHost + "/auth/me/sites",
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
			Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])) ]).then( res => {
				// Promise.resolve(returnAjaxRes(optionList[0])).then( res => {
				adminTable(res[0], res[1], initModal);
			});
		} else {
			Promise.all([ Promise.resolve(returnAjaxRes(optionList[2])), Promise.resolve(returnAjaxRes(optionList[1])) ]).then( res => {
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
			let newArr = [];
			let essDvcArr = ["KPX_EMS", "INV_PV", "PCS_ESS", "BMS_SYS"];
			let newName = '';
			// deviceNameList
			// Promise.resolve(siteData.map((item, index) => {
			siteData.map((item, index) => {
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
					item.siteType = "수요자원"
					item.powerSource = "부하"
				} else {
					if(isEmpty(item.resource_type)){
						item.siteType = "-"
					} else {
						item.siteType = "발전소"
						if(item.resource_type === 1){
							item.powerSource = "태양광"
						} else if(item.resource_type === 2){
							item.powerSource = "풍력"
						} else if(item.resource_type === 3){
							item.powerSource = "소수력"
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
				
				// console.log("sid-===", item.sid);
				let deviceOpt = {
					url: apiHost + "/config/devices?"+'oid='+oid,
					type: 'get',
					async: false,
					data:{
						sid: item.sid
					}
				}

				$.ajax(deviceOpt).done(function (json, textStatus, jqXHR) {
					if(json.length > 0 ){
						// let alarmArr = [];
						let genCapacity = 0;
						let pcsCapacity = 0;
						let bmsCapacity = 0;

						let found = json.findIndex( x => x.alarm_to);

						if( found > - 1) {
							item.alarmFlag = true;
							item.alarmLength = found;
						} else {
							alarmFlag = false;
						}

						item.alarmInfo = json;
						$.each(json, function( index, el ){
							let hasDevType = essDvcArr.some( x => x.includes(el.device_type));

							if(hasDevType == true){
								if( (el.device_type == "INV_PV") || (el.device_type == "KPX_EMS") ) {
									genCapacity += el.capacity;
								}
								if( el.device_type == "PCS_ESS" ) {
									pcsCapacity += el.capacity;
								}
								if( el.device_type == "BMS_SYS" ) {
									bmsCapacity += el.capacity;
								}
							} else {
								genCapacity = 0;
								pcsCapacity = 0;
								bmsCapacity = 0;
							}
						});

						genCapacity = displayNumberFixedDecimal(genCapacity, 'W', 3, 2, "noComma");
						item.genCapacity = genCapacity[0] + " " + genCapacity[1];
					
						pcsCapacity = displayNumberFixedDecimal(pcsCapacity, 'W', 3, 2, "noComma");
						item.pcsCapacity = pcsCapacity[0] + " " + pcsCapacity[1];
						
						bmsCapacity = displayNumberFixedDecimal(bmsCapacity, 'W', 3, 2, "noComma");
						item.bmsCapacity = bmsCapacity[0] + " " + bmsCapacity[1];

					} else {
						item.genCapacity = "-";
						item.pcsCapacity = "-";
						item.bmsCapacity = "-";
					}
					item.updatedAt = new Date(item.updatedAt).format('yyyy-MM-dd HH:mm:ss');
					newArr.push(item);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.log("deviceOpt error===", jqXHR);
					return false;
				});
			});
			// })).then( res => {
				// console.log("m===", newArr[14].alarmData)
				// console.log("response===", response)
				// 1. 사업소 유형
				// 2. 사업소명
				// 3. 지역
				// 4. 발전원 => 0: MicroGrid, 1: photovoltaic, 2: wind, 3: SmallHydro (hydroelectric power for local community)
				// 5. 발전 용량
				// 6. ESS 용량 (PCS)
				// 7. ESS 용량(BMS)
				// 8. DR 자원 코드 => 이름
				// 9. Vpp 자원 코드 ( virtual power plant )  => 이름
				// 10. 수정/조회 권한
				// 11. 알람 설정

				var siteTable = $('#siteTable').DataTable({
					"aaData": newArr,
					"destroy": true,
					"table-layout": "fixed",
					"fixedHeader": true,
					"bAutoWidth": true,
					"bSearchable" : true,
					// "scrollX": true,
					// "sScrollX": "100%",
					// "sScrollXInner": "110%",
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
								if(rowData.powerSource == "부하"){
									$(td).attr('data-value', 0);
								} else if(rowData.powerSource == "태양광"){
									$(td).attr('data-value', 1);
								} else if(rowData.powerSource == "풍력"){
									$(td).attr('data-value', 2);
								} else if(rowData.powerSource == "소수력"){
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
							"sTitle": "사업소 유형",
							"mData": "siteType",
						},
						{
							"sTitle": "사업소 명",
							"mData": "name"
						},
						{
							"sTitle": "지역",
							"mData": "location",
						},
						{
							"sTitle": "발전 자원",
							"mData": "powerSource",
						},
						{
							"sTitle": "발전 용량",
							"mData": "genCapacity",
						},
						{
							"sTitle": "ESS 용량 (PCS)",
							"mData": "pcsCapacity",
						},
						{
							"sTitle": "ESS 용량 (BMS)",
							"mData": "bmsCapacity",
						},
						{
							"sTitle": "DR 자원 ID",
							"mData": "drName",
							visible: false
						},
						{
							"sTitle": "VPP 자원 ID",
							"mData": "vppName",
						},
						{
							"sTitle": "알람 수신",
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								// return '<button type="button" class="btn-type-sm btn-type03">알람</button>'
								if(!isEmpty(data.alarmInfo)){
									return '<button type="button" class="btn-type-sm btn-type03">알람</button>'
								} else {
									return '<button type="button" disabled class="btn-type-sm btn-type03">알람</button>'
								}
							},
						},
						{
							"sTitle": "업데이트 일자",
							"mData": "updatedAt",
						},
					],
					"dom": 'tip',
					"select": {
						style: 'single',
						// selector: 'td input[type="checkbox"], tr'
						selector: 'td input[type="checkbox"], td:not(:nth-of-type(11))'
					},
					initComplete: function(settings, json ){
						let str = `<div id="btnGroup" class="right-end"><!--
							--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')">선택 수정</button><!--
							--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')">선택 삭제</button><!--
						--></div>`;

						let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')">추가</button>`;
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

				// siteTable.rows( function ( idx, data, node ) {
				// 	console.log("sid===", data.sid)
				// }).data();

				$('#siteTable').on( 'click', 'td .btn-type-sm', function () {
					let dTable = $('#siteTable').DataTable();
					let tr = $(this).parents().closest("tr");
					let idx = dTable.row(tr).index();

					// if(!isEmpty(siteTable.row(tr).data().alarmData)){
						let rowData = dTable.row(tr).data().alarmInfo;
						let dvcNameKr = dTable.row(tr).data().device_type_kr;
						let userOpt = {
							url: apiHost + "/config/users",
							type: 'get',
							async: false,
							data : {
								oid: oid,
							}
						}
						Promise.resolve(makeAjaxCall(userOpt)).then(res => {
							getAlarmTable(dvcNameKr, rowData, res);
						});
					// }
				});

				new $.fn.dataTable.Buttons( siteTable, {
					name: 'commands',
					"buttons": [
						{
							extend: 'excelHtml5',
							className: "btn-save",
							text: '엑셀 다운로드',
							filename: '사용자관리_' + new Date().format('yyyyMMddHHmmss'),
							// exportOptions: {
							// 	modifier: {
							// 		page: 'current'
							// 	}
							// },
							customize: function( xlsx ) {
								var sheet = xlsx.xl.worksheets['sheet1.xml'];
								$('row:first c', sheet).attr( 's', '42' );
								var sheet = xlsx.xl.worksheets['sheet1.xml'];
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
						// {
						// 	extend: 'csvHtml5',
						// 	className: "btn-type03",
						// 	text: 'CSV'
						// },
						// {
						// 	extend: 'pdfHtml5',
						// 	className: "btn-type03",
						// 	text: 'PDF',
						// },
					],
				});

				siteTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
				// siteTable.container().addClass( 'fit' );

				// siteTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup").addClass("hidden inline");

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

			// });
		}
	}

	function nonAdminTable(mySites, vppNameData, userSites, callback) {
		if(!callback) {
			getPropertyData();
			getVppDrData(vppNameData);
		} else {
			callback();
		}
		let newArr = [];
		let essDvcArr = ["KPX_EMS", "INV_PV", "PCS_ESS", "BMS_SYS"];

		// Promise.resolve(mySites.map((item, index) => {
		mySites.map((item, index) => {
			let found = userSites.findIndex( x => x.sid === item.sid);

			if(found > -1){
				// let matchedData = item;
				let deviceOpt = {
					url: apiHost + "/config/devices?"+'oid='+oid,
					type: 'get',
					async: false,
					data:{
						sid: item.sid
					}
				}

				$("#loadingCircle").show();

				$.ajax(deviceOpt).done(function (json, textStatus, jqXHR) {
					if(json.length > 0 ){
						// let alarmArr = [];
						let genCapacity = 0;
						let pcsCapacity = 0;
						let bmsCapacity = 0;

						$.each(json, function( index, el ){
							let hasDevType = essDvcArr.some( x => x.includes(el.device_type));

							if(hasDevType == true){
								if( (el.device_type == "INV_PV") || (el.device_type == "KPX_EMS") ) {
									genCapacity += el.capacity;
								}
								if( el.device_type == "PCS_ESS" ) {
									pcsCapacity += el.capacity;
								}
								if( el.device_type == "BMS_SYS" ) {
									bmsCapacity += el.capacity;
								}
							} else {
								genCapacity = 0;
								pcsCapacity = 0;
								bmsCapacity = 0;
							}
						});

						genCapacity = displayNumberFixedDecimal(genCapacity, 'W', 3, 2, "noComma");
						item.genCapacity = genCapacity[0] + " " + genCapacity[1];
					
						pcsCapacity = displayNumberFixedDecimal(pcsCapacity, 'W', 3, 2, "noComma");
						item.pcsCapacity = pcsCapacity[0] + " " + pcsCapacity[1];
						
						bmsCapacity = displayNumberFixedDecimal(bmsCapacity, 'W', 3, 2, "noComma");
						item.bmsCapacity = bmsCapacity[0] + " " + bmsCapacity[1];
					} else {
						item.genCapacity = "-";
						item.pcsCapacity = "-";
						item.bmsCapacity = "-";
					}

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

					console.log("item.resource_type===", item.resource_type)
					if(isEmpty(item.resource_type)){
						item.siteType = "-"
					} else {

						if(item.resource_type == 0) {
							// Demand && ESS : pair
							item.siteType = "수요자원"
							item.powerSource = "부하"
						} else {
							item.siteType = "발전소"
							if(item.resource_type === 1){
								item.powerSource = "태양광"
							} else if(item.resource_type === 2){
								item.powerSource = "풍력"
							} else if(item.resource_type === 3){
								item.powerSource = "소수력"
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

					item.updatedAt = new Date(item.updatedAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(item.updatedAt).toLocaleTimeString();
					newArr.push(item);

				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.log("error====", jqXHR);
					return false;
				});

			} else {
				newArr = [];
			}
		});
		// })).then( res => {
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
					"bAutoWidth": true,
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
						// {
						// 	"sTitle": "순번",
						// 	"mData": null,
						// 	"className": "dt-center no-sorting"
						// },
						{
							"sTitle": "",
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								return '<a class="chk-type" href="#"><input type="checkbox" id="' + rowIndex.row + '" name="table_checkbox"><label for="' + rowIndex.row + '"></label></a>'
							},
							"className": "dt-body-center no-sorting"
						},
						{
							"sTitle": "사업소 유형",
							"mData": "siteType",
						},
						{
							"sTitle": "사업소 명",
							"mData": "name"
						},
						{
							"sTitle": "지역",
							"mData": "location",
						},
						{
							"sTitle": "발전 자원",
							"mData": "powerSource",
						},
						{
							"sTitle": "발전 용량",
							"mData": "genCapacity",
						},
						{
							"sTitle": "ESS 용량 (PCS)",
							"mData": "pcsCapacity",
						},
						{
							"sTitle": "ESS 용량 (BMS)",
							"mData": "bmsCapacity",
						},
						{
							"sTitle": "DR 자원 ID",
							"mData": "drName",
							visible: false
						},
						{
							"sTitle": "VPP 자원 ID",
							"mData": "vppName",
						},
						{
							"sTitle": "업데이트 일자",
							"mData": "updatedAt",
						},
					],
					"language": {
						"emptyTable": "조회된 데이터가 없습니다.",
						"zeroRecords":  "검색된 결과가 없습니다."
					},
					"dom": 'tip',
					"select": {
						style: 'single',
						// selector: 'td:first-child > a',
						selector: 'td input[type="checkbox"], tr'
						// selector: 'td input[type="checkbox"], td:not(:nth-of-type(11))'
					},
					initComplete: function(settings, json ){
						// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						// 	cell.innerHTML = i+1;
						// 	$(cell).data("id", i);
						// });		
						let str = `<div id="btnGroup" class="right-end"><!--
							--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')">선택 수정</button><!--
							--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')">선택 삭제</button><!--
						--></div>`;
						$("#siteTable_wrapper").append($(str));

						// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						// 	cell.innerHTML = i+1;
						// 	$(cell).data("id", i);
						// });
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
					drawCallback: function (settings) {
						$('#siteTable_wrapper').addClass('mb-28');
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
		// });
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
					"title": "순번",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"title": "사업소 유형",
					"data": null,
				},
				{
					"title": "사업소 명",
					"data": null
				},
				{
					"title": "지역",
					"data": null,
				},
				{
					"title": "발전 자원",
					"data": null,
				},
				{
					"title": "발전 용량",
					"data": null,
				},
				{
					"title": "ESS 용량 (PCS)",
					"data": null,
				},
				{
					"title": "ESS 용량 (BMS)",
					"data": null,
				},
				{
					"title": "DR 자원 ID",
					"data": null,
					visible: false
				},
				{
					"title": "VPP 자원 ID",
					"data": null,
				},
				{
					"title": "알람 수신",
					"data": null,
				},
			],
			"dom": 'tip',
			"language": {
				"emptyTable": "조회된 데이터가 없습니다.",
				"zeroRecords":  "검색된 결과가 없습니다."
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
			url: apiHost + "/config/view/properties?types=site_type,resource",
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

				cStr += `
					<li data-util-name="${'${util}'}" data-plan-id="${'${id}'}" data-vol-type="${'${vStr}'}" data-value="${'${item[0]}'}"><a href="#">${'${item[0]}'}</a></li>
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

				newContractList.prev().data({ "plan-id": planId, "vol-type": voltType });
				subOpt.empty().prev().data("value", "").html("선택<span class='caret'></span>");

				if(!isEmpty($(this).data("vol-type"))){
					let str = '';
					idArr = [...$(this).data("plan-id").split(",")];
					vArr = [...$(this).data("vol-type").split(",")];
					utilArr = [...$(this).data("util-name").split(",")];
					$("#newVoltWarning").removeClass("hidden");
					if(btn.is(":disabled")){
						btn.prop("disabled", false)
					}
					for(let i=0, length = vArr.length; i<length; i++){
						str += `<li data-util-name="${'${utilArr[i]}'}" data-id="${'${idArr[i]}'}" data-value="${'${vArr[i]}'}"><a href="#">${'${vArr[i]}'}</a></li>`;
					}
					subOpt.append(str);
					setTimeout(function(){
						validateForm();
					}, 600);
					subOpt.find("li").click(function(){
						$("#newVoltWarning").addClass("hidden");
						setTimeout(function(){
							validateForm();
						}, 600);
					});
				} else {
					btn.html("<span class='caret'></span>")
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
			let allStr = '<li><a href="#">전체</a></li>';

			$.each(r, function(index, el){
				let name = `${'${el.name.kr}'}`;
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
			// 		newSiteType.prev().data({ "name" : target.data("name"), "value":  target.data("value") }).html(target.data("name") + "<span class='caret'></span>");
			// 	} else {
			// 		let target = items.eq(1);
			// 		newSiteType.prev().data({ "name" : target.data("name"), "value": target.data("value") }).html(target.data("name") + "<span class='caret'></span>");
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
				let name = `${'${el.name.kr}'}`;
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
				<li><a href="#">해당 사항 없음</a></li>
			`;
			$("#newSiteType").append(siteStr);



			$("#newSiteType li").on("click", function() {
				let val = $(this).data("value");
				let newRes = $("#newResList");
				let items = newRes.find("li");

				newRes.prev().data({ "name" : "", "value": "" }).html("선택<span class='caret'></span>");
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
		inspStr += `<li data-value="0"><a href="#">말일</a></li>`

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
		// 	newDrResIdList.prev().prop("disabled", true).html("등록된 DR거래 자원 ID가 없습니다.<span class='caret'></span>");
		// 	$("#sectionDRInfo input").each(function(){
		// 		$(this).prop('disabled', true).val("-");
		// 	})
		// 	$("#newCblList").prev().prop("disabled", true).html("-<span class='caret'></span>");
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
			newVppResIdList.prev().prop('disabled', true).html("등록된 중개거래 자원 ID가 없습니다.<span class='caret'></span>");
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
			$(this).data({ "value": "", "vol-type": "", "plan-id" : "" }).html('선택' + '<span class="caret"></span>').prop("disabled", false);
			$(this).next().find("li").removeClass("hidden");
		});
		// console.log("initModal----")
	}
	
	function initAlarmTable(){
		let checkBox = $("#alarmTable").find("input[type='checkbox']");
		checkBox.prop("checked", false);
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
			addBtn.text("추가");
			newSiteName.prop('disabled', false).parent().removeClass("disabled");
			$("#newVoltTypeList").prev().prop("disabled", true).data("value", "").html("선택<span class='caret'></span>");
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
					addBtn.prop("disabled", false).text("수정").removeClass("hidden");
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
				$('#newCityList').prev().data({"name": td.eq(3).text(), "value" : td.eq(3).data("value") }).html(td.eq(3).text() + "<span class='caret'></span>");
				// Address
				if( !isEmpty(rowData.address)) {
					$('#newStreetAddr').val(rowData.address);
				}
				// 사업소 유형
				$('#newSiteType').prev().data({"name": td.eq(1).text(), "value" : td.eq(1).data("value") }).html(td.eq(1).text() + "<span class='caret'></span>");
				// 발전원
				$("#newResList").prev().data({"name": td.eq(4).text(), "value" : td.eq(4).data("value") }).html(td.eq(4).text() + "<span class='caret'></span>");
				// ESS 유무
				if( isEmpty(rowData.ess) || rowData.ess === 0 ) {
					$('#newEssList').prev().data("value", "0").html("무<span class='caret'></span>");
				} else {
					if (rowData.ess === '-') {
						$('#newEssList').prev().data("value", "0").html("무<span class='caret'></span>");
					} else {
						$('#newEssList').prev().data("value", "1").html("유<span class='caret'></span>");
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
							$("#newContractList").prev().html('선택<span class="caret"></span>');
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
							$("#newVoltTypeList").prev().prop("disabled", true).html('선택<span class="caret"></span>');
						}

						if(!isEmpty(util.peak_demand) ){
							formatUnit(newPeakDemand, String(util.peak_demand / 1000));
						}

						if(!isEmpty(util.demand_charge) ){
							formatUnit(newDrCharge, String(util.demand_charge / 1000));
						}

						if(util.metering_day == 0){
							$("#newInspection").prev().data("value", String(util.metering_day)).html( '말일<span class="caret"></span>');
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
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( "SMP평균" + '<span class="caret"></span>');
					} else if(priceModel.price_type == "fixed") {
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( "고정가" + '<span class="caret"></span>');
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
// 					$("#newDrResIdList").prev().data("value", rowData.dr_group_id).html(rowData.drName + "<span class='caret'></span>");
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
// 							$("#newCblList").prev().html(dr.cbl_method + "<span class='caret'></span>");
// 						}
// 						if( !isEmpty(dr.profile_share)) {
// 							$("#newDrRevShare").val(dr.profile_share);
// 						}
// 					}
// 				} else {
// 					console.log("no dr grou id---")
// 					sectionDrDropdown.each(function(item, index){
// 						$(this).prop("disabled", true).html("선택<span class='caret'></span>");
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
					$("#newVppResIdList").prev().data("value", rowData.vpp_group_id).html(rowData.vppName + "<span class='caret'></span>");
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
						$(this).prop("disabled", true).html("선택<span class='caret'></span>");
					});
					sectionVppInput.each(function(item, index){
						$(this).prop("disabled", true).val("").parent().addClass("disabled");
					});
				}

				if( td.eq(9).text() != '-' ) {
					$('#newVppResIdList').prev().data("value", td.eq(9).text() ).html(td.eq(9).text() + '<span class="caret"></span>');
				} else {
					$('#newVppResIdList').prev().data("value", "").html('선택<span class="caret"></span>');
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
			if(!isEmpty($("#newContractList").prev().data("vol-type"))){
				if( ( !isEmpty($("#newVoltTypeList").prev().data("value")) ) &&  ($("#validSite:not('.hidden')").length > 0 ) && (!isEmpty($("#newCityList").prev().data("value"))) && (!isEmpty($("#newResList").prev().data("value"))) ){
					$("#addSiteBtn").prop("disabled", false);
				} else {
					$("#newVoltWarning").removeClass("hidden");
					$("#addSiteBtn").prop("disabled", true);
				}
			} else {
				if( ($("#validSite:not('.hidden')").length > 0 ) && (!isEmpty($("#newCityList").prev().data("value"))) && (!isEmpty($("#newResList").prev().data("value"))) ){
					$("#addSiteBtn").prop("disabled", false);
				} else {
					$("#addSiteBtn").prop("disabled", true);
				}
			}
		} else {
			$("#addSiteBtn").prop("disabled", false);
		}

	}

	// function selectRow(dataTable) {
	// 	if ($(this).hasClass("selected")) {
	// 		$(this).removeClass("selected");
	// 	} else {
	// 		dataTable.$("tr.selected").removeClass("selected");
	// 		$(this).addClass("selected");
	// 	}
	// }


	function showSubgroup (self){
		let target = $(self).parent().prev();
		let upperGroup = $("#alarmTable .device-type").not(parent).toArray();
		let tr = $(self).parents().closest("tr");
		let subGroup = $(self).data("subgroup");
		let menuItem = tr.find("td:nth-of-type(2) .dropdown-menu li");
		menuItem.removeClass("hidden");

		let found = upperGroup.findIndex( x => $(x).text() == target.text() );
		if(found > -1) {	
			$("#duplicatedGroup").removeClass("hidden");
			setTimeout(function(){
				target.data({"value": "", "did" : "" }).html('선택<span class="caret"></span>');
				$("#duplicatedGroup").addClass("hidden");
			}, 1600);
		}
		// $.each(menuItem, function(index, el){
		if (subGroup.indexOf(',') > -1) {
			let searchArr = [...subGroup.split(",")];
			let val = menuItem.data("value");
			let arr = [];
			menuItem.addClass("hidden");
			console.log("searchArr===", searchArr)
			$.each(menuItem, function(index, el){
				let found = searchArr.findIndex ( x => x == $(this).data("value"));
				if(found > -1){
					$(this).removeClass("hidden");
					arr.push($(this).data("value"))
				}
			});
		} else {
			$.each(menuItem, function(index, el){
				if(subGroup == $(this).data("value")){
					$(this).removeClass("hidden").siblings().addClass("hidden");
				}
			});
		}
	}

	function groupBy (objectArray, property) {
		return objectArray.reduce(function (acc, obj) {
			var key = obj[property];
			if (!acc[key]) {
				acc[key] = [];
			}
			acc[key].push(obj);
			return acc;
		}, {});
	}

	function removeDuplicates(data, key) {
		return [ ...new Map( data.map(x => [key(x), x]) ).values() ];
	};

	//  using object mutation
	// const uniqByProp = prop => arr =>
	// 	Object.values(
	// 		arr.reduce(
	// 			(acc, item) => (
	// 				item && item[prop] && (acc[item[prop]] = item), acc
	// 			), // using object mutation (faster)
	// 		{}
	// 	)
	// );

	// const subGroup = copy.filter((v,i,a)=> a.findIndex(t=>(t.name === v.name))===i);


	function addNewInput(self){
		// let almTable = $("#alarmTable").DataTable();
		// let col = almTable.column(5);
		// col.visible( ! col.visible() );
		let parent = $(self).parent().parent();
		let num = $(self).parent().attr("id").match(/\d+/)[0];
		let input = parent.next();
		let alarmLvl = $(self).parents().closest("tr").find("td:nth-of-type(3) .dropdown");
		let phone = $(self).parents().closest("tr").find("td:nth-of-type(5) input[type='text']");
		let btnGroup = $(self).parents().closest("tr").find("td:nth-of-type(6) .flex-start");

		$(self).siblings().find("input:checked").prop("checked", false);
		input.toggleClass("hidden");

		$.each(phone, function(index, el){
			if($(this).attr("name").match(/\d+/)[0] == num){
				$(this).prop("disabled", false).val("").parent().removeClass("disabled").addClass("mb-52");
				alarmLvl.eq(index).addClass("mb-52");
				btnGroup.eq(index).addClass("mb-52");
			}
		});

	}

	function removeNewInput(self){
		let parent = $(self).parent().parent().next();
		let num = $(self).parent().attr("id").match(/\d+/)[0];
		let alarmLvl = $(self).parents().closest("tr").find("td:nth-of-type(3) .dropdown");

		let phone = $(self).parents().closest("tr").find("td:nth-of-type(5) input[type='text']");
		let btnGroup = $(self).parents().closest("tr").find("td:nth-of-type(6) .flex-start");

		$(self).siblings().removeClass("hidden");
		parent.addClass("hidden");

		$.each(phone, function(index, el){
			if($(this).attr("name").match(/\d+/)[0] == num){
				let displayText = "";
				let matchedNum = $(self).find("input[type='checkbox']").data("contact-num");
				let selected = $(self).parent().text();

				if(selected != "선택"){
					if($(self).siblings().find("input:checked").length>0){
						if(isEmpty(matchedNum)){
							displayText = "번호 없음" + " 외 " + String($(self).siblings().find("input:checked").length) + "개";
						} else {
							displayText = matchedNum + " 외 " + String($(self).siblings().find("input:checked").length) + "개";
						}
					} else {
						displayText = matchedNum;
					}
				} else {
					displayText = "";
				}

				$(this).prop("disabled", true).val(displayText).parent().addClass("disabled").removeClass("mb-52");
				alarmLvl.eq(index).removeClass("mb-52");
				btnGroup.eq(index).removeClass("mb-52");
			}
		});

	}
	
	function getAlarmTable(dvcNameData, alarmData, userData){
		let alarmList = [];
		let userType = "";
		// let newUserList = [];
		// let newNonUserList = [];
		// console.log("alarmData---", alarmData)
			// Promise.resolve(alarmData.alarmInfo.map((x, index) => {
			Promise.resolve(alarmData.map((x, index) => {
				if(!isEmpty(x.alarm_to)){
					Promise.resolve(JSON.parse(x.alarm_to)).then( res => {
						x.alarmToUser = res;
						alarmList.push(x);
					});
				}
			})).then( () => {
				let newDevType = [...new Map(alarmList.map(x => [x.device_type, x])).values()];
				let subGroup = [...new Map(alarmList.map(x => [x.name, x])).values()];
				// console.log("newDevType====", newDevType);
				// console.log("subGroup====", subGroup);

				// return false;
				if(alarmList.length > 0) {
					var alarmTable = $('#alarmTable').DataTable({
						"aaData": alarmList,
						"destroy": true,
						// "table-layout": "fixed",
						"fixedHeader": true,
						"bAutoWidth": true,
						"bSortable": true,
						"bSearchable" : true,
						// "retrieve": true,
						"scrollX": true,
						"sScrollXInner": "100%",
						"sScrollY": true,	
						"scrollY": "40vh",
						// "scrollCollapse": false,
						"pageLength": 4,
						// "scrollY": "400px",
						// "bScrollCollapse": true,
						"bSearchable" : true,
						"dom": 'tip',
						"aoColumnDefs": [
							// {
							// 	"aTargets": [ 0 ],
							// 	"bSortable": false,
							// 	"orderable": false
							// },
							// {
							// 	"aTargets": [ 0, 1, 2, 3, 4, 5, 6 ],
							// 	"bSortable": false,
							// 	"orderable": false
							// },

							{
								"aTargets": [ 2 ],
								"createdCell": function (td, cellData, rowData, row, col) {
									let dropdown = $(td).find(".dropdown");

									$.each(dropdown, function(index, el){
										let selected = $(this).find(".dropdown-toggle").data("value");
										let input = $(this).find("input[type='checkbox']");

										$.each(input, function(idx, checkbox){
											if(!isEmpty(selected) && selected.length > 1){
												let selectedVal = selected.split(",");
												let found = selectedVal.findIndex( x => x == $(this).val() );
												if(found > -1){
													$(this).prop("checked", true);
												}
											} else {						
												if(selected == $(this).val()){
													$(this).prop("checked", true);
												}
											}
										});
									});
								}
							},
							{
								"aTargets": [ 3 ],
								"createdCell": function (td, cellData, rowData, row, col) {
									// console.log("rowData11---", rowData);

									if (!isEmpty(rowData.alarmToUser)) {
										let dropdown = $(td).find(".dropdown");
										let val = dropdown.find(".dropdown-toggle").data("value");

										$.each(dropdown, function(index, el){
											let target = $(this).next().find("input[type='checkbox']");

											if(!isEmpty(target) && target.length > 0){
												let targetArr = target.toArray();
												// console.log("$(this).text()====", $(this).text())
												let found = targetArr.findIndex( x => ( $(x).data("name") == $(this).text() ) );
												if( found > -1 ){
													$(target[found]).prop("checked", true);
												}
											}
										});
									}
								}
							},
							{
								"aTargets": [ 4 ],
								"createdCell": function (td, cellData, rowData, row, col) {
									let input = $(td).find("input");
									if (!isEmpty(rowData.alarmToUser)) {
										$.each(input, function(index, el){
											$(this).val($(this).attr("value"));
										});
									}
								}
							},
						],
						"aoColumns": [
							{
								"sTitle": "설비타입",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str1 = ``;
									let devName = '';

									subGroup.forEach((item, index) => {
										if(item.device_type === data.device_type){
											devName += item.name + ","
										}
									});

									devName = devName.replace(/,\s*$/, "");
									let deviceNameKr = '';
									for (var property in deviceNameList) {
										if(property == data.device_type){
											deviceNameKr = deviceNameList[property].name.kr;
											break;
										}
									}

									newDevType.forEach((item, index) => {
										str1 += `
											<li onclick="setDropdownInput(this)" data-subgroup="${'${ devName }'}" data-did="${'${ item.did }'}" data-value="${'${ item.device_type }'}"><a href="#" tabindex="-1">${'${ deviceNameKr }'}</a></li>
										`
									});

									let dropdown1 = `
										<div class="dropdown">
											<button type="button" class="dropdown-toggle device-type" data-toggle="dropdown" data-did="${'${ data.did }'}" data-value="${'${ data.device_type }'}" disabled>${'${ deviceNameKr }'}<span class="caret"></span></button>
											<ul id="aDvcTypeList${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str1 }'}</ul>
										</div>
									`;

									return dropdown1;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "설비명",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {	
									let str2 = ``;
						
									subGroup.forEach((item, index, arr) => {
										str2 += `
											<li data-device-type="${'${ item.device_type }'}" data-did="${'${ item.did }'}" data-value="${'${ item.name }'}"><a href="#" tabindex="-1">${'${ item.name }'}</a></li>
										`
									});

									let subDropdown = `
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ row.name }'}" disabled>${'${ row.name }'}<span class="caret"></span></button>
											<ul id="aDvcNameList${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str2 }'}</ul>
										</div>
									`;
									return subDropdown;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "알람레벨",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str3 = ``;
									let dropdown3 = ``;
									let aLevelOpt = [
										{  name : "정보", val: 0 },
										{  name : "경고", val: 1 },
										{  name : "이상", val: 2 },
										{  name : "트립", val: 3 },
										{  name : "긴급", val: 4 },
										{  name : "미정", val: 9 },
									];


									$.each(aLevelOpt, function(index, el){
										str3 += `
											<li>
												<a class="chk-type" href="#">
													<input type="checkbox" data-id="aDvcLevel${'${ el.val }'}" name="aDvcLevel${'${ el.val }'}" value="${'${ el.val }'}" />
													<label>${'${ el.name }'}</label>
												</a>
											</li>
										`
									});

									if( isEmpty(data.alarmToUser.non_user) && isEmpty(data.alarmToUser.user) ) {
										dropdown3 = `
											<div class="dropdown">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" disabled>선택<span class="caret"></span></button>
												<ul id="aDvcAlarmList${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str3 }'}</ul>
											</div>
										`
									} else {
										if(!isEmpty(data.alarmToUser.user) && data.alarmToUser.user.length > 0){
											let registeredUser = data.alarmToUser.user;
											let joinedVal = "";

											$.each(registeredUser, function(index, el){
												let levText = "";
												let levVal = "";
												let newIdx = String(rowIndex.row + index);

												if(!isEmpty(el.level)){
													let val;
													joinedVal = el.level.join(",");

													if(el.level.length > 1){
														val = el.level[0];
														levText = aLevelOpt[val].name + ' 외 ' + String(el.level.length - 1) + "개";
													} else if(el.level.length == 1) {
														joinedVal = el.level[0];
														levText = aLevelOpt[joinedVal].name;
													} else if(el.level.length < 0) {
														joinedVal = "";
														levText = "선택";
													}

													dropdown3 += `
														<div class="dropdown">
															<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ joinedVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
															<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
														</div>
													`
												}
											});
										}
										
										if(!isEmpty(data.alarmToUser.non_user) && data.alarmToUser.non_user.length > 0){
											let nonUser = data.alarmToUser.non_user;
											let joinedVal = "";
											
											$.each(nonUser, function(index, el){
												let levText = "";
												let levVal = "";
												let newIdx = String(rowIndex.row + "Non" + index);

												if(!isEmpty(el.level)){
													let val;
													joinedVal = el.level.join(",");

													if(el.level.length > 1){
														val = el.level[0];
														levText = aLevelOpt[val].name + ' 외 ' + String(el.level.length - 1) + "개";
													} else if(el.level.length == 1) {
														joinedVal = el.level[0];
														levText = aLevelOpt[joinedVal].name;
													} else if(el.level.length < 0) {
														joinedVal = "";
														levText = "선택";
													}

													// if(!isEmpty(el.level)){
													// 	val = el.level[0];
													// 	levText = aLevelOpt[val].name + ' 외 ' + String(el.level.length - 1) + "개";
													// } else {
													// 	joinedVal = ""
													// 	levText = "선택";
													// }


													dropdown3 += `
														<div class="dropdown">
															<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ joinedVal }'}" data-name="선택" disabled>${'${ levText }'}<span class="caret"></span></button>
															<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
														</div>
													`
												} else {
													dropdown3 += `
														<div class="dropdown">
															<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ aLevelOpt[5].val }'}" data-name="선택" disabled>${'${ aLevelOpt[5].name }'}<span class="caret"></span></button>
															<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
														</div>
													`
												}
											});																		
										}
									}

									return dropdown3;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "담당자 (이름 / ID)",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str4 = ``;
									let dropdown4 = ``;
									let userIdx = '';

									if( isEmpty(data.alarmToUser.non_user) && isEmpty(data.alarmToUser.user) ) {
										str4 += `
											<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
										`;
										$.each(userData, function(idx, el){
											let nameId = `${'${ el.name }'}` + ` / ` + `${'${ el.login_id }'}`;
											let phoneNum = "";
											el.contact_phone ? phoneNum = el.contact_phone : "";

											str4 += `
												<li onclick='removeNewInput(this)'>
													<a class="chk-type" href="#">
														<input type="checkbox" data-id="${'${ el.login_id }'}${'${ rowIndex.row }'}" name="aDvcContactPerson${'${ rowIndex.row }'}" value="${'${ el.uid }'}" data-uid="${'${ el.uid }'}" data-name="${'${ el.name }'}" data-contact-num="${'${ phoneNum }'}" />
														<label>${'${ nameId }'}</label>
													</a>
												</li>
											`;
										});
										
										dropdown4 = `
											<div class="dropdown" data-user-type="non-user" data-user-index="${'${ rowIndex.row }'}">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" disabled>선택<span class="caret"></span></button>
												<ul id="aDvcContactListNonUser${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str4 }'}</ul>
											</div>
											<div class="text-input-type ml-0 hidden"><input type="text" name="aDvcContactNonUser${'${ rowIndex.row }'}" /></div>
										`
									} else {
										if(!isEmpty(data.alarmToUser.non_user) && data.alarmToUser.non_user.length > 0){
											let nonUser = data.alarmToUser.non_user;
											
											nonUser.forEach((item, index) => {
												let displayName = item.name;

												console.log("displayName==", item)
												newIdx = String(rowIndex.row + index);

												str4 += `
													<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
												`;
												$.each(userData, function(idx, el){
													let nameId = `${'${ el.name }'}` + ` / ` + `${'${ el.login_id }'}`;
													let phoneNum = "";
													el.contact_phone ? phoneNum = el.contact_phone : "";

													str4 += `
														<li onclick='removeNewInput(this)'>
															<a class="chk-type" href="#">
																<input type="checkbox" data-id="${'${ el.login_id }'}${'${ newIdx }'}" name="aDvcContactPerson${'${ newIdx }'}" value="${'${ el.uid }'}" data-uid="${'${ el.uid }'}" data-name="${'${ el.name }'}" data-contact-num="${'${ phoneNum }'}" />
																<label>${'${ nameId }'}</label>
															</a>
														</li>
													`;
												});

												dropdown4 += `
													<div class="dropdown" data-user-type="non-user" data-user-index="${'${ newIdx }'}">
														<button type="button" class="dropdown-toggle" data-value="${'${ displayName }'}" data-toggle="dropdown" data-name="선택" disabled>${'${ displayName }'}<span class="caret"></span></button>
														<ul id="aDvcContactListNonUser${'${ newIdx }'}" class="dropdown-menu">${'${ str4 }'}</ul>
													</div>
													<div class="text-input-type ml-0 hidden"><input type="text" name="aDvcContactNonUser${'${ newIdx }'}" /></div>
												`;

											});
										}

										if(!isEmpty(data.alarmToUser.user) && data.alarmToUser.user.length > 0){
											let registeredUser = data.alarmToUser.user;

											registeredUser.forEach((item, index) => {
												let newIdx = String(rowIndex.row + index);
												let displayName = "";

												str4 += `
													<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
												`
												$.each(userData, function(idx, el){
													let nameId = `${'${ el.name }'}` + `(` + `${'${ el.login_id }'}` + `)`;
													let phoneNum = "";
													if(el.uid == item.uid){
														displayName = el.name
													}
													
													el.contact_phone ? phoneNum = el.contact_phone : "";

													str4 += `
														<li onclick='removeNewInput(this)'>
															<a class="chk-type" href="#">
																<input type="checkbox" data-id="${'${ el.login_id }'}${'${ newIdx }'}" name="aDvcContactPerson${'${ newIdx }'}" value="${'${ el.uid }'}" data-name="${'${ el.name }'}" data-contact-num="${'${ phoneNum }'}" />
																<label>${'${ nameId }'}</label>
															</a>
														</li>
													`
												});
												dropdown4 += `
													<div class="dropdown" data-user-type="user" data-user-index="${'${ newIdx }'}">
														<button type="button" class="dropdown-toggle" data-value="${'${ item.uid }'}" data-toggle="dropdown" data-name="" disabled>${'${ displayName }'}<span class="caret"></span></button>
														<ul id="aDvcContactList${'${ newIdx }'}" class="dropdown-menu">${'${ str4 }'}</ul>
													</div>
													<div class="text-input-type ml-0 hidden"><input type="text" name="aDvcContact${'${ newIdx }'}" id="aDvcContact${'${ newIdx }'}" /></div>
												`;

											});
										}
									}
									return dropdown4;
								},
								// "className": "no-sorting",
								// "width": "16%"
							},
							{
								"sTitle": "전화번호",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str5 = ``;

									if( isEmpty(data.alarmToUser.non_user) && isEmpty(data.alarmToUser.user) ) {
										str5 += `<div class="text-input-type disabled" data-user-type="user"><input type="text" name="aDvcPhone${'${ rowIndex.row }'}" value="" disabled /></div>`;
									} else {
										if(!isEmpty(data.alarmToUser.non_user) && data.alarmToUser.non_user.length > 0){
											let nonUser = data.alarmToUser.non_user;
											nonUser.forEach((item, index) => {
												let newIdx = String(rowIndex.row + index);
												let displayName = item.name;
												let phoneNum = "";
												item.phone ? (phoneNum = item.phone) : ( phoneNum = "" );

												str5 += `<div class="text-input-type disabled" data-user-type="non-user"><input type="text" name="aDvcPhoneNonUser${'${ newIdx }'}" value="${'${ phoneNum }'}" disabled /></div>`;
											});
										}

										if(!isEmpty(data.alarmToUser.user) && data.alarmToUser.user.length > 0){
											
											let registeredUser = data.alarmToUser.user;

											registeredUser.forEach((item, index) => {
												let newIdx = String(rowIndex.row + index);
												let displayName = item.name;
												let phoneNum = "";
												let found = userData.findIndex(x => x.uid == item.uid);

												if(found > -1){
													if(!isEmpty(userData[found].contact_phone)){
														phoneNum = userData[found].contact_phone; 
													}
												}
												str5 += `<div class="text-input-type disabled" data-user-type="user"><input type="text" name="aDvcPhone${'${ newIdx }'}" value="${'${ phoneNum }'}" disabled /></div>`;
											});
										}
									}

									return str5;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "추가 / 수정 / 삭제",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let deleteStr = ``;
									let length = 0;

									if( isEmpty(data.alarmToUser.non_user) && isEmpty(data.alarmToUser.user) ) {
										deleteStr = `
											<div class="flex-start">
												<button type="button" class="icon-add" data-index="${'${rowIndex.row}'}" onclick="updateAlarmTable($(this), 'add' )">추가</button>
												<button type="button" class="icon-edit" data-index="${'${rowIndex.row}'}" onclick="updateAlarmTable($(this), 'edit')">수정</button>
												<button type="button" class="icon-delete" data-index="${'${rowIndex.row}'}" onclick="updateAlarmTable($(this), 'delete')">삭제</button>
											</div>
										`;
									} else {
										if(!isEmpty(data.alarmToUser.user)){
											length += data.alarmToUser.user.length;
										} 
										if(!isEmpty(data.alarmToUser.non_user)){
											length += data.alarmToUser.non_user.length;
										}
										for(let i = 0, arrLength = length; i < arrLength; i++ ){
											deleteStr += `
												<div class="flex-start">
													<button type="button" class="icon-add" data-index="${'${i}'}" onclick="updateAlarmTable($(this), 'add' )">추가</button>
													<button type="button" class="icon-edit" data-index="${'${i}'}" onclick="updateAlarmTable($(this), 'edit')">수정</button>
													<button type="button" class="icon-delete" data-index="${'${i}'}" onclick="updateAlarmTable($(this), 'delete')">삭제</button>
												</div>
											`;
										}
									}

									return deleteStr;
								},
								"className": "dt-body-center no-sorting",
							},
						],
						initComplete: function(){
							this.api().columns().header().each ((el, i) => {
								if(i == 0){
									$(el).attr ('style', 'min-width: 16%;');
								} else if(i == 1){
									$(el).attr ('style', 'min-width: 20%;');
								} else if(i == 2){
									$(el).attr ('style', 'min-width: 12%;');
								} else if(i == 3){
									$(el).attr ('style', 'min-width: 20%;');
								} else if(i == 4){
									$(el).attr ('style', 'min-width: 20%;');
								}
							});
							// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
							// 	cell.innerHTML = i+1;
							// 	$(cell).data("id", i);
							// });
							// this.api().column(5).visible( false );
						},
						rowCallback: function(row, data) {
							let length = 0;
							if(!isEmpty(data.alarmToUser) && !isEmpty(data.alarmToUser.user)){
								length += data.alarmToUser.user.length;
							}
							if(!isEmpty(data.alarmToUser) && !isEmpty(data.alarmToUser.non_user)){
								length += data.alarmToUser.non_user.length;
							}
							if(length === 1 ){
								$(row).addClass('single');
							}
						},
						drawCallback: function(){
							$('#alarmTable_wrapper').addClass('fixed-width');
							$('#alarmTable').css("width", "100%");
						}
					}).columns.adjust();					
				} else {
					let newDevType = [...new Map(alarmData.map(x => [x.device_type, x])).values()];
					let subGroup = [...new Map(alarmData.map(x => [x.name, x])).values()];

					var alarmTable = $('#alarmTable').DataTable({
						"aaData": newDevType,
						"destroy": true,
						// "table-layout": "fixed",
						"fixedHeader": true,
						"bAutoWidth": true,
						"bSortable": true,
						"bSearchable" : true,
						// "retrieve": true,
						"scrollX": true,
						"sScrollXInner": "100%",
						"sScrollY": true,	
						"scrollY": "40vh",
						"pageLength": 4,
						"bSearchable" : true,
						"dom": 'tip',
						"aoColumns": [
							{
								"sTitle": "설비타입",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str1 = ``;
									let devName = '';

									subGroup.forEach((item, index, arr) => {
										if(item.name === data.name){
											devName += item.name + ","
										}
									});

									devName = devName.replace(/,\s*$/, "");
									let deviceNameKr = '';
									for (var property in deviceNameList) {
										if(property == data.device_type){
											deviceNameKr = deviceNameList[property].name.kr;
											break;
										}
									}
									newDevType.forEach((item, index) => {
										str1 += `
											<li onclick="setDropdownInput(this)" data-subgroup="${'${ devName }'}" data-did="${'${ item.did }'}" data-value="${'${ item.device_type }'}"><a href="#" tabindex="-1">${'${ deviceNameKr }'}</a></li>
										`
									});

									let dropdown1 = `
										<div class="dropdown">
											<button type="button" class="dropdown-toggle device-type" data-toggle="dropdown" data-did="${'${ data.did }'}" data-value="${'${ data.device_type }'}">선택<span class="caret"></span></button>
											<ul id="aDvcTypeList${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str1 }'}</ul>
										</div>
									`;

									return dropdown1;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "설비명",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {	
									let str2 = ``;

									subGroup.forEach((item, index) => {
										str2 += `
											<li data-device-type="${'${ item.device_type }'}" data-did="${'${ item.did }'}" data-value="${'${ item.name }'}"><a href="#" tabindex="-1">${'${ item.name }'}</a></li>
										`
									});

									let subDropdown = `
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown">선택<span class="caret"></span></button>
											<ul id="aDvcNameList${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str2 }'}</ul>
										</div>
									`;
									return subDropdown;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "알람레벨",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str3 = ``;
									let dropdown3 = ``;
									let aLevelOpt = [
										{  name : "정보", val: 0 },
										{  name : "경고", val: 1 },
										{  name : "이상", val: 2 },
										{  name : "트립", val: 3 },
										{  name : "긴급", val: 4 },
										{  name : "미정", val: 9 },
									];

									// $.each(aLevelOpt, function(index, el){
									// 	str3 += `
									// 		<li data-name="${'${ el.name }'}" data-value="${'${ el.val }'}"><a href="#" tabindex="-1">${'${ el.name }'}</a></li>
									// 	`
									// });

									$.each(aLevelOpt, function(index, el){
										str3 += `
											<li>
												<a class="chk-type" href="#">
													<input type="checkbox" data-id="aDvcLevel${'${ el.val }'}" name="aDvcLevel${'${ el.val }'}" value="${'${ el.val }'}" />
													<label>${'${ el.name }'}</label>
												</a>
											</li>
										`
									});

									dropdown3 = `
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="" data-name="선택">선택<span class="caret"></span></button>
											<ul id="aDvcAlarmList${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str3 }'}</ul>
										</div>
									`;
									return dropdown3;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "담당자 (이름 / ID)",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str4 = ``;
									let dropdown4 = ``;
									let userIdx = '';

									str4 += `
										<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
									`;
									$.each(userData, function(idx, el){
										newIdx = String(rowIndex.row + idx);

										let nameId = `${'${ el.name }'}` + ` / ` + `${'${ el.login_id }'}`;
										let phoneNum = "";
										
										el.contact_phone ? phoneNum = el.contact_phone : "";

										str4 += `
											<li onclick='removeNewInput(this)'>
												<a class="chk-type" href="#">
													<input type="checkbox" data-id="${'${ el.login_id }'}${'${ newIdx }'}" name="aDvcContactPerson${'${ newIdx }'}" data-uid="${'${ el.uid }'}" value="${'${ el.uid }'}" data-name="${'${ el.name }'}" data-contact-num="${'${ phoneNum }'}" />
													<label>${'${ nameId }'}</label>
												</a>
											</li>
										`;
									});

									dropdown4 = `
										<div class="dropdown" data-user-type="non-user" data-user-index="${'${ rowIndex.row }'}">
											<button type="button" class="dropdown-toggle" data-value="" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="aDvcContactListNonUser${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str4 }'}</ul>
										</div>
										<div class="text-input-type ml-0 hidden"><input type="text" name="aDvcContactNonUser${'${ rowIndex.row }'}" /></div>
									`;

									return dropdown4;
								},
								// "className": "no-sorting",
								// "width": "16%"
							},
							{
								"sTitle": "전화번호",
								"mData": null,
								"mRender": function ( data, type, row, rowIndex ) {
									let str5 = ``;
									
									str5 = `<div class="text-input-type" data-user-type="non-user"><input type="text" name="aDvcPhoneNonUser${'${ rowIndex.row }'}" value="" /></div>`;

									return str5;
								},
								// "className": "no-sorting",
							},
							{
								"sTitle": "추가 / 수정 / 삭제",
								"mData": null,
								"mRender": function ( data, type, row, row, rowIndex ) {
									let deleteStr = ``;
									let i = 0;

									deleteStr = `
										<div class="flex-start">
											<button type="button" class="icon-add" data-index="${'${i}'}" onclick="updateAlarmTable($(this), 'add')">추가</button>
											<button type="button" class="icon-edit" disabled data-index="${'${i}'}" onclick="updateAlarmTable($(this), 'edit')">수정</button>
											<button type="button" class="icon-delete" data-index="${'${i}'}" onclick="updateAlarmTable($(this), 'delete')">삭제</button>
										</div>
									`;

									return deleteStr;
								},
								"className": "dt-body-center no-sorting",
							},
						],
						initComplete: function(){
							this.api().columns().header().each ((el, i) => {
								if(i == 0){
									$(el).attr ('style', 'min-width: 16%;');
								} else if(i == 1){
									$(el).attr ('style', 'min-width: 20%;');
								} else if(i == 2){
									$(el).attr ('style', 'min-width: 12%;');
								} else if(i == 3){
									$(el).attr ('style', 'min-width: 20%;');
								} else if(i == 4){
									$(el).attr ('style', 'min-width: 20%;');
								}
							});
							// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
							// 	cell.innerHTML = i+1;
							// 	$(cell).data("id", i);
							// });
							// this.api().column(5).visible( false );
						},
						rowCallback: function(row, data) {
							let length = 0;

							if(!isEmpty(data.alarmToUser) && !isEmpty(data.alarmToUser.user)){
								length += data.alarmToUser.user.length;
							}
							if(!isEmpty(data.alarmToUser) && !isEmpty(data.alarmToUser.non_user)){
								length += data.alarmToUser.non_user.length;
							}

							if(length === 1 ){
								$(row).addClass('single');
							}
						},
						drawCallback: function(){
							$('#alarmTable_wrapper').addClass('fixed-width');
							$('#alarmTable').css("width", "100%");

							// this.api().columns().header().each ((el, i) => {
							// 	if(i == 0){
							// 		$(el).attr ('style', 'width: 4%;');
							// 	}
							// 	if(i == 5){
							// 		$(el).attr ('style', 'min-width: 180px;');
							// 	}
							// });
						}
					}).columns.adjust();
				}
			$("#addAlarmModal").modal("show");

		});

	}

	function updateAlarmTable(self, option){

		let tr = self.parents().closest("tr");
		let td = tr.find("td");
		let dTable = $("#alarmTable").DataTable();	
		let rowData = dTable.row(tr).data();	
		let dataIdx = self.data("index");
		
		let directInput = tr.find("td:nth-of-type(4) input[type='text']").eq(dataIdx);
		let input = tr.find("td:nth-of-type(5) input[type='text']").eq(dataIdx);

		if(option == "add"){
			let copy = tr.clone();
			let idAttr = copy.find('[id^="aDvc"]');
			let nameAttr = copy.find('[name^="aDvc"]');
			
			copy.find("td:nth-of-type(1)").empty();
			copy.find("td:nth-of-type(2)").empty();

			copy.find("td:nth-of-type(3) .dropdown:not(:last-of-type)").remove();
			copy.find("td:nth-of-type(4) div:lt(-2)").remove();
			copy.find("td:nth-of-type(5) .text-input-type:not(:last-of-type)").remove();
			copy.find("td:nth-of-type(6) .flex-start:not(:last-of-type)").remove();

			copy.find("input[type='checkbox']").prop("checked", false);
			copy.find("td .dropdown-toggle").prop("disabled", false).html('선택<span class="caret"></span>');
			copy.find("input[type='checkbox']").prop("checked", false);
			copy.find("td input[type='text']").prop("disabled", false).val("").parent().removeClass("disabled");
			
			let tempIdx = tr.find("td:nth-of-type(6) .flex-start:last-of-type .icon-edit").data("index") + 1;

			copy.find("td:nth-of-type(4) .dropdown").attr("data-user-index", tempIdx);
			copy.find("td:nth-of-type(6) .icon-add").attr("data-index", tempIdx);
			copy.find("td:nth-of-type(6) .icon-edit").attr("data-index", tempIdx ).prop("disabled", true);
			copy.find("td:nth-of-type(6) .icon-delete").attr("data-index", tempIdx ).attr("onclick", "removeInnerTd(this)");
	
			$.each(idAttr, function(index, el){
				let oldId = $(this).attr("id");
				let num = (Number(oldId.match(/\d+/)[0]) + 999 );
				let newId = oldId + String(num);

				$(this).attr("id", newId);
			});

			$.each(nameAttr, function(index, el){
				let oldName = $(this).attr("name");
				let num = (Number(oldName.match(/\d+/)[0]) + 999 );
				let newName = oldName + String(num);

				$(this).attr("name", newName);

			});
			let newTd = copy.find("td");

			td.eq(2).append(newTd.eq(2).children());
			td.eq(3).append(newTd.eq(3).children());
			td.eq(4).append(newTd.eq(4).children());
			td.eq(5).append(newTd.eq(5).children());
		}

		if(option == "edit"){
			$.each(td, function(index, el){
				if(index >= 2) {
					if(index <= 3){
						let target = $(this).find(".dropdown-toggle").eq(dataIdx);
						if(target.is(":disabled")) {
							target.prop("disabled", false);
							if(!directInput.hasClass("hidden")){
								directInput.prop("disabled", false).parent().removeClass("disabled");
							}
							if(index == 3){
								input.prop("disabled", false).parent().removeClass("disabled");
							}
						} else {
							target.prop("disabled", true);
							directInput.prop("disabled", true).parent().addClass("disabled");
							if(index == 3){
								input.prop("disabled", true).parent().addClass("disabled");
							}
						}
					}
				}
			});
		}

		if(option == "delete"){
			console.log("deleteAlarm==", tr.siblings() ) ;

			if(tr.siblings().length == 0) {
				if($(self).parent().siblings().length === 0){
					tr.addClass("hidden");
				} else {
					$.each(td, function(index, el){
						if(index >= 2) {
							if(index <= 3){
								let target = $(this).find(".dropdown-toggle").eq(dataIdx);
								target.parent().remove();
								directInput.parent().remove();
								if(index == 3){
									input.parent().remove();
								}
							}
							if(index == 5){
								$(self).parent().remove();
							}
						}
					});
				}
			} else {
				if($(self).parent().siblings().length === 0){
					tr.remove();
				} else {
					$.each(td, function(index, el){
						if(index >= 2) {
							if(index <= 3){
								let target = $(this).find(".dropdown-toggle").eq(dataIdx);
								target.parent().remove();
								directInput.parent().remove();
								if(index == 3){
									input.parent().remove();
								}
							}
							if(index == 5){
								$(self).parent().remove();
							}
						}
					});
				}
			}

			// let alarmName = rowData.name + "/" + tr.find("td:nth-of-type(3) .dropdown-toggle").eq(dataIdx).text();
			// let modal = $("#alarmDeleteConfirmModal");
			// let confirmAlarmName = $("#confirmAlarm");
			// let deleteBtn = $("#alarmDeleteConfirmBtn");

			// let userType = tr.find("td:nth-of-type(4) .dropdown").eq(dataIdx);
			// let userIdx = userType.data("user-index");
			// let newAlarmTo = rowData.alarmToUser;
			
			// $("#alarmDeleteSuccessMsg span").text(alarmName);
			// modal.find(".modal-body").removeClass("hidden");
			// modal.modal("show");

			// confirmAlarmName.on("input", function() {
			// 	if($(this).val() !== alarmName) {
			// 		deleteBtn.prop("disabled", true);
			// 		return false
			// 	} else {
			// 		deleteBtn.prop("disabled", false);
			// 	}
			// });

			// confirmAlarmName.on("keyup", function() {
			// 	if($(this).val() !== alarmName) {
			// 		deleteBtn.prop("disabled", true);
			// 		return false
			// 	} else {
			// 		deleteBtn.prop("disabled", false);
			// 	}
			// });

			// if( userType.data("user-type") == "non-user"){
			// 	newAlarmTo.non_user.splice(userIdx, 1);
			// } else {
			// 	newAlarmTo.user.splice(userIdx, 1);
			// }

			// $("#alarmDeleteConfirmBtn").click(function(){
			// 	if(confirmAlarmName != alarmName) return false;

			// 	$.ajax(deviceOpt).done(function (json, textStatus, jqXHR) {
			// 		$("#alarmDeleteSuccessMsg").text("해당 알람 정보가 삭제 되었습니다.").removeClass("hidden");
			// 		refreshSiteList();
			// 		setTimeout(function(){
			// 			modal.modal("hide");
			// 		}, 1500);
			// 	}).fail(function (jqXHR, textStatus, errorThrown) {
			// 		modal.find(".modal-body").addClass("hidden");
			// 		$("#alarmDeleteSuccessMsg").text("해당 알람 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
			// 		setTimeout(function(){
			// 			modal.modal("hide");
			// 		}, 1500);
			// 		console.log("fail==", jqXHR)
			// 	});
			// });

		}

			// $.ajax(deviceOpt).done(function (json, textStatus, jqXHR) {
			// 	$("#deleteSuccessMsg").text("선택하신 알람 정보가 삭제 되었습니다.").removeClass("hidden");
			// 	refreshAlarmList();
			// 	setTimeout(function(){
			// 		$("#deleteConfirmModal").modal("hide");
			// 	}, 1500);
			// }).fail(function (jqXHR, textStatus, errorThrown) {
			// 	modalBody.addClass("hidden");
			// 	$("#deleteSuccessMsg").text("사이트 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
			// 	setTimeout(function(){
			// 		$("#deleteConfirmModal").modal("hide");
			// 	}, 1500);
			// 	console.log("fail==", jqXHR)
			// });
	
			// did
			// localtime
			// code

			// let arr = [];
			// $.each(tr, function(index, el){

			// 	let obj = {};
			// 	let dropdown = el.find(".dropdown-toggle");
			// 	let input = el.find("input[type='text']");

			// 	obj.device_type = dropdown.eq(0).data("value");
			// 	obj.name = dropdown.eq(1).data("value");
			// 	obj.level = dropdown.eq(2).data("value");
			// 	obj.person = dropdown.eq(3).data("value");
			// 	obj.phone = input.val();

			// });


	}

	function insertRowCopy(){
		let aTable = $("#alarmTable").DataTable();
		let copy = $("#alarmTable tbody tr:last-of-type").clone();
		let idAttr = copy.find('[id^="aDvc"]');
		let nameAttr = copy.find('[name^="aDvc"]');

		if(copy.hasClass("hidden")){
			$("#alarmTable tbody").empty();
			copy.removeClass("hidden");
		}

		if(!copy.hasClass("single")){
			copy.find("td .dropdown:not(:first-of-type)").remove();
			copy.find("td:nth-of-type(4) .text-input-type:not(:nth-of-type(2))").remove();
			copy.find("td:nth-of-type(5) .text-input-type:not(:first-of-type)").remove();
			copy.find("td .flex-start:not(:first-of-type)").remove();
		}
		
		copy.find("td:nth-of-type(1) .dropdown-menu li").attr( "onclick", "showSubgroup(this)");
		copy.find("td:nth-of-type(2) .dropdown-menu li").removeClass( "hidden");
		copy.find("td .dropdown-toggle").prop("disabled", false).html('선택<span class="caret"></span>').attr("data-value", "");
		copy.find("input[type='checkbox']").prop("checked", false);
		copy.find("td input[type='text']").prop("disabled", false).val("").parent().removeClass("disabled");
		copy.find("td:nth-of-type(6) .icon-edit").prop("disabled", true);
		copy.find("td:nth-of-type(6) .icon-delete").attr( "onclick", "$(this).parents().closest('tr').remove()");

		$.each(idAttr, function(index, el){
			let oldId = $(this).attr("id");
			let num = (Number(oldId.match(/\d+/)[0]) + 9999 );
			let newId = oldId + String(num);
			// let num = Number(oldId.match(/\d+/)[0]) + 1;
			// let text = oldId.match(/[^\d]+/) + String(num);

			$(this).attr("id", newId);
		});

		$.each(nameAttr, function(index, el){
			let oldName = $(this).attr("name");
			let num = (Number(oldName.match(/\d+/)[0]) + 9999 );
			let newName = oldName + String(num);

			$(this).attr("name", newName);

		});

		// aTable.rows().add(copy).draw(false);

		$("#alarmTable tbody").append(copy);

	}

	function removeInnerTd(self){
		let td = $(self).parents().closest("tr").find("td");
		$.each(td, function(index, el){
			if(index>=2){
				if(index != 3){
					$(this).find(".dropdown:last-of-type").remove();
					$(this).find(".text-input-type:last-of-type").remove();
				}

				if(index == 3){
					$(this).find("div:gt(-3)").remove();
				}

				if(index == 5){
					$(this).find(".flex-start:last-of-type").remove();
				}
			}
		});
	}

	function setDropdownInput(self){
		$(self).parent().prev().data("did", $(self).data("did"));
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
		$("#latLongWarnig").addClass('hidden');
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
				$("#latLongWarnig").removeClass('hidden');
			}
		} else {
			$("#latLongWarnig").removeClass('hidden');
		}
	}
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">사업소 관리</h1>
	</div>
</div>

<c:set var="siteList" value="${siteHeaderList}"/>

<div id="propertyRow" class="row">
	<div class="col-10">
		<div class="flex-group">
			<span class="tx-tit">사업소 유형</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul id="siteType" class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="inline-title">지역</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
				<ul id="countryList" class="dropdown-menu chk-type" role="menu">
					<li><a href="#">전체</a></li>
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
			<span class="tx-tit">발전 자원</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul id="resTypeList" class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="tx-tit">사업소 명</span>
			<div class="flex-start">
				<div class="text-input-type">
					<input type="text" id="siteSearchBox" name="site_search_box" placeholder="입력">
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
			<!-- <tfoot></tfoot> -->
			</table>
		</div>
	</div>
</div>


<div class="modal fade stack" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 id="resultSuccessMsg" class="text-blue hidden">사용자가 성공적으로<br>추가 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">사업소 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
			</div>
			<div class="btn-wrap-type05"><!--
			--><button type="button" id="resultBtn" class="btn-type03" data-dismiss="modal" aria-label="Close">확인</button><!--
		--></div>
		</div>
	</div>
</div>


<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="deleteConfirmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit">사이트 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" name="confirm_site" id="confirmSite" placeholder="사이트 이름 입력"/></div>
			</div>
			<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn-type w80 ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>


<div class="modal fade stack" id="alarmDeleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="alarmDeleteConfirmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="alarmDeleteSuccessMsg" class="ntit">알람 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;을 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" name="confirm_alarm" id="confirmAlarm" placeholder="장치명 입력"/></div>
			</div>
			<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="alarmDeleteConfirmBtn" class="btn-type w80 ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>



<div class="modal fade" id="addAlarmModal" tabindex="-1" role="dialog" aria-labelledby="addAlarmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-xl">
		<div class="modal-content site-modal-content">
			<div class="modal-header flex-start">
				알람 설정<button type="button" class="btn-add ml-24" onclick="insertRowCopy()">열 추가</button><!--
				--><small id="duplicatedGroup" class="warning hidden">해당 설비는 이미 선택 되었습니다.</small><!--
				--><small id="noIdWarning" class="warning hidden">중복되지 않는 설비 타입/ 설비명은 필수입니다.</small><!--
			--></div>
			<div class="modal-body mt10">
				<form name="add_alarm_form" id="updateAlarmForm">
					<table id="alarmTable" class="no-stripe">
						<!-- <colgroup>
							<col style="width:14%">
							<col style="width:20%">
							<col style="width:12%">
							<col style="width:20%">
							<col style="width:20%">
							<col style="width:14%">
						</colgroup> -->
						<thead></thead>
						<tbody></tbody>
					</table>
					<div class="btn-wrap-type05"><!--
					--><button type="button" class="btn-type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
					--><button type="submit" class="btn-type w80 ml-12">추가</button><!--
				--></div>
				</form>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog" aria-labelledby="addSiteModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-custom-xl">
		<div class="modal-content site-modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1>사업소 추가<span class="required fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사업소 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_site_form" id="updateSiteForm" class="setting-form">
						<section id="sectionSiteInfo">
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label asterisk">사업소 명</span></div>
								<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex-start">
										<div class="text-input-type offset-73">
											<input type="text" name="new_site_name" id="newSiteName" placeholder="입력" minlength="2" maxlength="15">
										</div>
										<button type="button" class="btn-type fr" onclick="checkSiteId($('#newSiteName').val().trim())" disabled>중복 체크</button>
									</div>
									<small class="hidden warning">추가하실 사이트를 입력해 주세요</small>
									<small class="hidden warning">2~15 글자를 입력해 주세요.</small>
									<small class="hidden warning">특수 문자는 포함될 수 없습니다.</small>
									<small id="invalidSite" class="hidden warning">이미 등록되어 있는 사이트 입니다.</small>
									<small id="validSite" class="text-blue text-sm hidden">추가 가능한 사이트 입니다.</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">사업소 유형</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newSiteType" class="dropdown-menu"></ul>
									</div>
									<small class="hidden warning">사업소 유형을 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label asterisk">발전원</span></div>
								<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newResList" class="dropdown-menu"></ul>
									</div>
									<small class="hidden warning">발전원 옵션을 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">ESS 유무</span></div>
								<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newEssList" class="dropdown-menu">
											<li data-value="1"><a href="#">유</a></li>
											<li data-value="0"><a href="#">무</a></li>
										</ul>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label asterisk">사업소재지</span></div>
								<div class="col-xl-6 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex-start">
										<div class="dropdown w-55">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newCityList" class="dropdown-menu">
												<c:forEach var="country" items="${location}">
													<c:if test="${country.value.code eq 'kr'}">
														<c:forEach var="city" items="${country.value.locations}" varStatus="cityName">
															<li data-value="${city.value.code}">
																<a href="#" tabindex="-1"><c:out value="${city.value.code}"></c:out></a>
															</li>
														</c:forEach>
													</c:if>
												</c:forEach>
											</ul>
										</div>
										<div class="text-input-type w-100"><input type="text" name="new_street_addr" id="newStreetAddr" placeholder="입력" minlength="3" maxlength="28"></div>
									</div>
									<small class="hidden warning">사업소재지를 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">위경도</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="text-input-type"><input type="text" name="new_coord" id="newCoord" placeholder="예) 35.9078, 127.7669" minlength="3" maxlength="28"></div>
									<small id="latLongWarnig" class="hidden warning">위경도 데이터를 다시 확인해 주세요.</small>
								</div>
								<div class="col-xl-2 col-lg-12 col-md-12 col-sm-12 pl-0">
									<button type="button" class="btn-type w-100" onclick="weatherGridCalculator();">기상그리드 계산</button>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">추가 정보</span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<textarea name="new_site_desc" id="newSiteDetail" class="textarea" placeholder="입력"></textarea>
								</div>
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">관측소 번호</span></div>
								<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="text-input-type">
										<input type="text" name="station_id" id="station_id" placeholder="입력" minlength="1" maxlength="15">
									</div>
								</div>
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">기상 그리드 </span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="text-input-type">
										<input type="text" name="gridX" id="gridX" placeholder="X값 입력" minlength="1" maxlength="4" onkeydown="onlyNum(event)">
									</div>
									<div class="text-input-type mt5">
										<input type="text" name="gridY" id="gridY" placeholder="Y값 입력" minlength="1" maxlength="4" onkeydown="onlyNum(event)">
									</div>
								</div>
							</div>

							<c:if test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">발전기 코드</span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="text" name="kpx_genid" id="kpx_genid" placeholder="입력" minlength="2" maxlength="15">
											</div>
										</div>
									</div>
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">모선 전압</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="text" name="kpx_transvol" id="kpx_transvol" placeholder="입력" minlength="2" maxlength="15">
											</div>
										</div>
									</div>
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">EMS 코드</span></div>
									<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="text-input-type">
												<input type="text" name="kpx_emsid" id="kpx_emsid" placeholder="입력" minlength="2" maxlength="100">
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</section>

						<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
							<section id="sectionPowerMarketInfo">
								<h2 class="stit">전력 구매 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">계약 종별</span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newContractList" class="dropdown-menu"></ul>
											</div>
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle optional" data-toggle="dropdown" data-name="선택" disabled>선택<span class="caret"></span></button>
												<ul id="newVoltTypeList" class="dropdown-menu"></ul>
											</div>
										</div>
										<small id="newVoltWarning" class="hidden warning">계약종별 상세 옵션을 선택해 주세요.</small>
									</div>
									
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">계약 전력</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_peak_demand" id="newPeakDemand" class="pr-36" oninput="truncateNonDigit(event, this)" onkeyup="formatUnit(this)" placeholder="입력" maxlength="10"><span class="unit">kW</span></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label offset-top">요금 적용<br>전력</span></div>
									<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_dr_charge" id="newDrCharge" class="pr-36" oninput="truncateNonDigit(event, this)" onkeyup="formatUnit(this)" placeholder="입력" maxlength="10"><span class="unit">kW</span></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">검침일</span></div>
									<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newInspection" class="dropdown-menu"></ul>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label offset-top">한전<br>고객번호</span></div>
									<div class="col-xl-3 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_kepco_id" id="newKepcoId" placeholder="입력" maxlength="18"></div>
									</div>

									<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input-label offset-top">iSMART<br>아이디</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_smart_id" id="newISmartId" placeholder="입력" maxlength="18"></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label offset-top">iSMART<br>비밀번호</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><!--
										--><input type="password" name="new_smart_pwd" id="newISmartPwd" placeholder="입력" maxlength="18" autocomplete>
										<%--
											<button type="button" class="pwd-icon" onclick="showPwd('newISmartPwd', this)">show</button>
										--%>
									</div>
									</div>
								</div>
							</section>
							<section id="sectionPowerMarketInfo">
								<h2 class="stit">매전 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">정상 단가</span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex-start">
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newPriceModelList" class="dropdown-menu">
													<li data-name="고정가" data-value="fixed"><a href="#">고정가</a></li>
													<li data-name="SMP평균" data-value="SMP_mean"><a href="#">SMP평균</a></li>
													<li data-name="SMP" data-value="SMP"><a href="#">SMP</a></li>
												</ul>
											</div>
											<div class="text-input-type hidden"><input type="text" name="Price" id="newPrice" oninput="truncateNonDigit(event, this)" placeholder="입력" maxlength="8"></div>
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
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newDrResIdList" class="dropdown-menu"></ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input-label">계약용량</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type">
											<input type="text" name="new_dr_vol" id="newDrVol" class="pr-36" oninput="truncateNonDigit(event, this)" onkeyup="formatUnit(this)" placeholder="입력" maxlength="10"><span class="unit">kW</span>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">CBL 계산식</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newCblList" class="dropdown-menu">
												<li data-value="max45"><a href="#">max45</a></li>
												<li data-value="mid68"><a href="#">mid68</a></li>
											</ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label">수익 분배율</span></div>
									<div class="col-xl-1 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="text-input-type"><input type="text" name="new_dr_rev_share" id="newDrRevShare" class="pr-36" oninput="truncateNonDigit(event, this, 'percentage')" onkeyup="formatRatio(this)" placeholder="입력" maxlength="5"><span class="unit">%</span></div>
									</div>
								</div>
							</section> -->

							<section id="sectionVppInfo">
								<h2 class="stit">중개 거래 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-sm-2"><span class="input-label">자원 ID</span></div>
									<div class="col-xl-3 col-lg-3 col-sm-4 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newVppResIdList" class="dropdown-menu"></ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-1 col-sm-2"><span class="input-label">수익 분배율</span></div>
									<div class="col-xl-2 col-lg-2 col-sm-4 pl-0">
										<div class="text-input-type"><input type="text" name="vpp_rev_share" id="newVppRevShare" class="pr-36" oninput="truncateNonDigit(event, this, 'percentage')" onkeyup="formatRatio(this)" placeholder="입력" maxlength="5"><span class="unit">%</span></div>
									</div>
								</div>
							</section>
						</c:if>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addSiteBtn" class="btn-type" disabled>추가</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
