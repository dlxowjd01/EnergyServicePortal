<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		// let l = '${location}'
		// console.log("location---", l);
		// let siteList = '${siteHeaderList}';
		// console.log("siteList---", siteList);

		let optionList = [
			{
				url: apiHost + "/config/sites?oid=" + oid,
				type: "get",
				async: true,
				// data: {
				// 	filter: JSON.stringify(
				// 		{ "order": [ "updatedAt DESC" ] }
				// 		// { "order": [ "name ASC", "updatedAt DESC" ] }
				// 	),
				// }
			},
			{
				url: apiHost + "/auth/me/groups?includeSites=false&includeDevices=false",
				type: 'get',
				async: true
			},
			{
				url: apiHost + "/auth/me",
				type: "get",
				async: true,
			}
			// {
			// 	url: apiHost + "/auth/me",
			// 	type: "get",
			// 	async: true,
			// },
		];

		initModal();

		if(role == 1){
			Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])) ]).then( res => {
			// Promise.resolve(returnAjaxRes(optionList[0])).then( res => {
				// console.log("res[0]===", res[0]);
				// console.log("res[1]===", res[1]);
				adminTable(res[0], res[1]);
			});
		} else {
			Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])), Promise.resolve(returnAjaxRes(optionList[2])) ]).then( res => {
			// Promise.resolve(returnAjaxRes(optionList[2])).then( res => {
				nonAdminTable( res[0], res[1], res[2].user_sites);
			});
		}

		
		// Validations
		$("#newSiteName").on('keydown', function() {
			$("#invalidSite").addClass("hidden");
			validateForm();
		});

		$("#newSiteName").on('keyup', function() {
			let warning = $("#validSite").parent().find(".warning");

			$("#validSite").addClass("hidden")

			if( $(this).val().match(/^[.!#$%&'*+/=?^`{|}~]/) ) {
				warning.eq(2).removeClass("hidden");
			} else {
				warning.eq(2).addClass("hidden");
			}

			if( $(this).val().length <= 1 || $(this).val().length > 15) {
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

		$("#newCoord").on('keyup', function(e) {
			// 	var re = /^[0-9] + (?:\,[0-9]+)*$/;
			if( $(this).val().match(/[^\x00-\x80]/) ){
				$(this).val("");
			}
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
			if(val == "0"){
				$("#newSiteType").prev().data({"value": "", "name" : ""}).html("해당 사항 없음<span class='caret'></span>").prop("disabled", true);
			} else {
				$("#newSiteType").prev().html("선택<span class='caret'></span>").prop("disabled", false);
			}
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
			$("#alarmTable").DataTable().clear().destroy();
		});

		$("#resultModal").on("hide.bs.modal", function() {
			$(this).find("h4").addClass("hidden");
		});

		// Form Submission !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		$("#updateSiteForm").on("submit", function(e){
			e.preventDefault();

			let newSiteName = $("#newSiteName").val();
			let newSiteType = Number($("#newSiteType").prev().data("value"));
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

			let newPeakDemand = Number($("#newPeakDemand").val());
			let newDrCharge = Number($("#newDrCharge").val());
			let newInspection = Number($("#newInspection").prev().data("value"));
			let newKepcoId = $("#newKepcoId").val();
			let newISmartId = $("#newISmartId").val();
			let newISmartPwd = $("#newISmartPwd").val();

			// Power Market
			let newPowerMarketObj = {}
			let newPowerModel = $("#newPriceModelList").prev().data("value");
			let newPrice = Number($("#newPrice").val());

			// DR
			let newDrObj = {}
			let newDrResId = $("#newDrResIdList").prev().data("value");
			let newDrVol = Number($("#drVol").val());
			let newCblMethod = $("#cblList").prev().data("value");
			let newDrRevShare = $("#newDrRevShare").val();

			// VPP
			let newVppObj = {}
			let newVppResId = $("#newVppResIdList").val();
			let newVppRevShare =$("#newVppRevShare").val();

			// AJAX callOption && FormData Obj
			let option = {};
			let siteObj = {};


			let newStationId, kpxGenId, kpxEmsId, kpxTransvol;
			if (oid.match('kpx')) {
				newStationId = $('#station_id').val();
				kpxGenId = $('#kpx_genid').val();
				kpxEmsId = $('#kpx_emsid').val();
				kpxTransvol = $('#kpx_transvol').val();
			}


			// 1. ADD site info
			if(!$("#addSiteModal").hasClass("edit")) {
				siteObj.name = newSiteName;
				siteObj.location = newCity;
				siteObj.resource_type = newResType;

				// if( isEmpty(newEss) ){
				// 	siteObj.ess = "0";
				// } else {
				// 	siteObj.ess = newEss;
				// }

				if( !isEmpty(newSiteType) ){
					siteObj.ess = newSiteType;
				}
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
				if( !isEmpty(newDrResId) ){
					siteObj.dr_group_id = newDrResId;
				}
				if( !isEmpty(newVppResId) ){
					siteObj.dr_group_id = newVppResId;
				}
				if (oid.match('kpx')) {
					if ( !isEmpty(newStationId) ) {
						siteObj.station_id = Number(newStationId);
					}
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
						console.log("newVoltName===", newVoltName)
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
				if( !isEmpty(newDrVol) ){
					newDrObj.contract_capacity = newDrVol;
				}
				if( !isEmpty(newCblMethod) ){
					newDrObj.cbl_method = newCblMethod;
				}
				if( !isEmpty(newDrRevShare) ){
					newDrObj.cbl_method = newDrRevShare;
				}
				if( !isEmpty(newDrObj) ){
					siteObj.dr_info = JSON.stringify(newDrObj);
				}

				// VPP JSON

				if( !isEmpty(newVppRevShare) ){
					newVppObj.profile_share = newVppRevShare;
				}
				if( !isEmpty(newVppObj) ){
					siteObj.vpp_info = JSON.stringify(newVppObj);
				}

				console.log("siteObj===", siteObj);

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

				if( !isEmpty(newSiteName) && td.eq(2).text() != newSiteName ){
					siteEditObj.name = newSiteName;
				}
				if( !isEmpty(newSiteType) && td.eq(1).text() != newSiteTypeName ){
					siteEditObj.ess = newSiteType;
				}
				if( !isEmpty(newCoord) ){
					siteEditObj.latlng = newCoord;
				}

				// if( !isEmpty(systemLocale)){
				// 	siteObj.tz = "systemLocale";
				// }

				if( !isEmpty(newStreetAddr)){
					siteEditObj.address = newStreetAddr;
				}
				if( !isEmpty(newSiteDetail)){
					siteEditObj.detail_info = newSiteDetail;
				}
				if( !isEmpty(newDrResId) && td.eq(8).text() != newDrResId ){
					siteEditObj.dr_group_id = newDrResId;
				}
				if( !isEmpty(newVppResId) && td.eq(9).text() != newVppResId ){
					siteEditObj.dr_group_id = newVppResId;
				}
				if (oid.match('kpx')) {
					if ( !isEmpty(newStationId) ) {
						siteEditObj.station_id = Number(newStationId);
					}
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
					console.log("newUtilPlanId===", newUtilPlanId)
					if( !isEmpty(newVoltName) ){
						console.log("newVoltName===", newVoltName)
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
				if( !isEmpty(newDrVol) ){
					newDrObj.contract_capacity = newDrVol;
				}
				if( !isEmpty(newCblMethod) ){
					newDrObj.cbl_method = newCblMethod;
				}
				if( !isEmpty(newDrRevShare) ){
					newDrObj.cbl_method = newDrRevShare;
				}
				if( !isEmpty(newDrObj) ){
					siteEditObj.dr_info = JSON.stringify(newDrObj);
				}

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
			console.log("submit---")
			e.preventDefault();
			let arr = [];
			let tr = $("#alarmTable tbody tr");
			$.each(tr, function(index, el){
				if(!tr.hasClass("disabled")){
					let obj = {};
					let dropdown = $(this).find(".dropdown-toggle");
					let input = $(this).find("input[type='text']");

					obj.device_type = dropdown.eq(0).data("value");
					obj.name = dropdown.eq(1).data("value");
					obj.level = dropdown.eq(2).data("value");
					obj.person = dropdown.eq(3).data("value");
					obj.phone = input.val();
				}

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
			// {
			// 	url: apiHost + "/auth/me/sites",
			// 	type: "get",
			// 	async: true,
			// },
		];

		$('#siteTable').DataTable().clear().destroy();
		Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])) ]).then( res => {
		// Promise.resolve(returnAjaxRes(optionList[0])).then( res => {
			adminTable(res[0], res[1], initModal);
		});
	}

	function adminTable(siteData, vppNameData, callback) {
		if(!callback) {
			getPropertyData();
			getVppDrData(vppNameData);
		} else {
			callback();
		}
		if(siteData) {
			// console.log("siteData---", siteData)
			let newArr = [];
			Promise.resolve(siteData.map((item, index) => {
			// siteData.forEach((item, index) => {
				let rawDataOpt = {
					url: apiHost + "/status/raw/site",
					type: 'get',
					async: false,
					data:{
						sid: item.sid,
						formId: 'v2'
					},
					beforeSend: function(){
						$("#loadingCircle").show();
					}
				}

				$.ajax(rawDataOpt).done(function (json, textStatus, jqXHR) {
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
						}
						if(item.resource_type === 1){
							item.powerSource = "태양광"
						} else if(item.resource_type === 2){
							item.powerSource = "풍력"
						} else if(item.resource_type === 3){
							item.powerSource = "소수력"
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
							let alarmArr = [];
							Promise.resolve(json.map( x => {
								if(!isEmpty(x.alarm_to)){
									alarmArr.push(x);
								}
							})).then( res => {
								item.alarmInfo = alarmArr;
								// console.log("item===", item)
							});
						}
					}).fail(function (jqXHR, textStatus, errorThrown) {
						console.log("deviceOpt error===", jqXHR)
						return false;
					});

					if(!isEmpty(json.INV_PV) ) {
						item.genCapacity = json.INV_PV.capacity;
					} else {
						item.genCapacity = 0;
					}
					if(!isEmpty(json.PCS_ESS) ) {
						item.pcsCapacity = json.PCS_ESS.capacity;
					} else {
						item.pcsCapacity = 0;
					}
					if(!isEmpty(json.BMS_SYS) ) {
						item.bmsCapacity = json.BMS_SYS.capacity;
					} else {
						item.bmsCapacity = 0;
					}
					item.updatedAt = new Date(item.updatedAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(item.updatedAt).toLocaleTimeString();
					// console.log("obj===", obj)
					newArr.push(item);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.log("error====", jqXHR);
					return;
				});

			})).then( res => {
				// console.log("newArr===", newArr);
				// console.log("m===", newArr[14].alarmData)
				// console.log("response===", response)
				// 1. 사업소 유형
				// 2. 사업소명
				// 3. 지역
				// 4. 발전원 => 0: MicroGrid, 1: photovoltaic, 2: wind, 3: SmallHydro (hydroelectric power for local community)
				// 5. 발전 용량
				// 6. ESS 용량 (PCS)
				// 7. ESS 용량(BMS)
				// 8. DR 자원 코드
				// 9. Vpp 자원 코드 ( virtual power plant )
				// 10. 수정/조회 권한
				// 11. 알람 설정

				var siteTable = $('#siteTable').DataTable({
					"aaData": newArr,
					"table-layout": "fixed",
					"fixedHeader": true,
					"bAutoWidth": true,
					"bSearchable" : true,
					// "ScrollX": true,
					// "sScrollX": "110%",
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
								return '<a class="chk_type" href="#"><input type="checkbox" id="' + rowIndex.row + '" name="table_checkbox"><label for="' + rowIndex.row + '"></label></a>'
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
							"sTitle": "DR 자원 코드",
							"mData": "drName",
						},
						{
							"sTitle": "VPP 자원코드",
							"mData": "vppName",
						},
						{
							"sTitle": "알람 수신",
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								if(!isEmpty(data.alarmInfo)){
									// console.log("data alarmInfo---", data);
									return '<button type="button" class="btn-type-sm btn_type03">알람</button>'
								} else {
									return '<button type="button" disabled class="btn-type-sm btn_type03">알람</button>'
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
							--><button type="button" disabled class="btn_type03" onclick="updateModal('edit')">선택 수정</button><!--
							--><button type="button" disabled class="btn_type03" onclick="updateModal('delete')">선택 삭제</button><!--
						--></div>`;

						let addBtnStr = `<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>`;
						$("#siteTable_wrapper").append($(str)).prepend($(addBtnStr));
						if(oid.match("kpx")){
							this.api().columns([8,9]).visible( false );
						}
					},
					// every time DataTables performs a draw
					drawCallback: function (settings) {
						$('#siteTable_wrapper').addClass('mb-28');
					},
					// rowCallback: function ( row, data ) {
					// 	// console.log("data---", data.alarmFlag);
					// }
				}).on("select", function(e, dt, type, indexes) {
					let btn = $("#btnGroup").find(".btn_type03");
					btn.each(function(index, element){
						if($(this).is(":disabled")){
							$(this).prop("disabled", false);
						}
					});
					siteTable.rows( indexes ).nodes().to$().find("input").prop("checked", true);
					// console.log("dt---", siteTable[ type ]( indexes ).nodes())
				}).on("deselect", function(e, dt, type, indexes) {
					let btn = $("#btnGroup").find(".btn_type03");
					btn.each(function(index, element){
						if(!$(this).is(":disabled")){
							$(this).prop("disabled", true);
						}
					});
					siteTable.rows( indexes ).nodes().to$().find("input").prop("checked", false);
					// console.log("dt---", siteTable[ type ]( indexes ).nodes())
				}).columns.adjust();
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

				siteTable.on( 'click', 'td .btn-type-sm', function () {
					let tr = $(this).parents().closest("tr");
					let idx = siteTable.row(tr).index();

					// if(!isEmpty(siteTable.row(tr).data().alarmData)){
						let rowData = siteTable.row(tr).data().alarmInfo;
						let userOpt = {
							url: apiHost + "/config/users",
							type: 'get',
							async: false,
							data : {
								oid: oid,
							}
						}
						Promise.resolve(makeAjaxCall(userOpt)).then(res => {
							getAlarmTable(rowData, res)
						});
					// }
				});

				new $.fn.dataTable.Buttons( siteTable, {
					name: 'commands',
					"buttons": [
						{
							extend: 'excelHtml5',
							className: "save_btn",
							text: '엑셀 다운로드',
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
						// 	className: "btn_type03",
						// 	text: 'CSV'
						// },
						// {
						// 	extend: 'pdfHtml5',
						// 	className: "btn_type03",
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
					} else {
						filterColumn("1", "");
					}
				});
				$("#siteSearchBox").on( 'keyup search input paste cut', function(){
					siteTable.columns(2).search( this.value ).draw();
				});

				getVppDrData(vppNameData);
				$("#loadingCircle").hide();

			});
		}
	}


	function nonAdminTable(allSites, vppNameData, userSite) {
		if(userSite){
			let newArr = [];
			Promise.resolve(allSites.map((item, index) => {
				let found = userSite.findIndex( x => x.sid == item.sid);

				let matchedData = allSites[found];

				if(found > -1){
					let rawDataOpt = {
						url: apiHost + "/status/raw/site",
						type: 'get',
						async: false,
						data:{
							sid: item.sid,
							formId: 'v2'
						},
						beforeSend: function(){
							$("#loadingCircle").show();
						}
					}

					$.ajax(rawDataOpt).done(function (json, textStatus, jqXHR) {
						$("#loadingCircle").show();
						if(!isEmpty(json.INV_PV) && ( Object.keys("genCapacity").length === 0 ) ) {
							item.genCapacity = json.INV_PV.capacity;
						} else {
							item.genCapacity = 0;
						}
						if(!isEmpty(json.PCS_ESS) && ( Object.keys("pcsCapacity").length === 0 ) ) {
							item.pcsCapacity = json.PCS_ESS.capacity;
						} else {
							item.pcsCapacity = 0;
						}
						if(!isEmpty(json.BMS_SYS) && ( Object.keys("bmsCapacity").length === 0 ) ) {
							item.bmsCapacity = json.BMS_SYS.capacity;
						} else {
							item.bmsCapacity = 0;
						}

						if(isEmpty(matchedData.ess)){
							item.ess == "-"
						} else {
							if(matchedData.ess == 1){
								item.ess = "DemandESS"
							} else if(matchedData.ess == 2){
								item.ess = "GenerationESS"
							}
						}

						item.name = matchedData.name;
						item.role = userSite[found].role;

						if(!isEmpty(matchedData.location)){
							item.location = matchedData.location;
						} else {
							item.location = "-";
						}

						if(matchedData.resource_type === 0) {
							// Demand && ESS : pair
							item.siteType = "수요자원"
							item.powerSource = "부하"
						} else {
							if(isEmpty(matchedData.resource_type)){
								item.siteType = "-"
							} else {
								item.siteType = "발전소"
							}
							if(matchedData.resource_type === 1){
								item.powerSource = "태양광"
							} else if(matchedData.resource_type === 2){
								item.powerSource = "풍력"
							} else if(matchedData.resource_type === 3){
								item.powerSource = "소수력"
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
						return;
					});
				}
			})).then(() => {
				// 1. 사업소 유형
				// 2. 사업소명
				// 3. 지역
				// 4. 발전원 => 0: MicroGrid, 1: photovoltaic, 2: wind, 3: SmallHydro (hydroelectric power for local community)
				// 5. 발전 용량
				// 6. ESS 용량 (PCS)
				// 7. ESS 용량(BMS)
				// 8. DR 자원 코드
				// 9. Vpp 자원 코드 ( virtual power plant )
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
								return '<a class="chk_type" href="#"><input type="checkbox" id="' + rowIndex.row + '" name="table_checkbox"><label for="' + rowIndex.row + '"></label></a>'
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
							"sTitle": "DR 자원 코드",
							"mData": "drName",
						},
						{
							"sTitle": "VPP 자원코드",
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
						// selector: 'td input[type="checkbox"], tr'
						selector: 'td input[type="checkbox"], td:not(:nth-of-type(11))'
					},
					initComplete: function(){
						// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						// 	cell.innerHTML = i+1;
						// 	$(cell).data("id", i);
						// });
						let str = `<div id="btnGroup" class="right-end"><!--
							--><button type="button" disabled class="btn_type03" onclick="updateModal('edit')">선택 수정</button><!--
							--><button type="button" disabled class="btn_type03" onclick="updateModal('delete')">선택 삭제</button><!--
						--></div>`;
						$("#siteTable_wrapper").append($(str));

						this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
							cell.innerHTML = i+1;
							$(cell).data("id", i);
						});
						if(oid.match("kpx")){
							this.api().columns([8,9]).visible( false );
						}
					},
					drawCallback: function (settings) {
						$('#siteTable_wrapper').addClass('mb-28');
					},
					// rowCallback: function ( row, data ) {
					// 	// readWrite
					// 	if(data.role == 1){
							
					// 	// readOnly
					// 	} else {

					// 	}
					// 	console.log("role---", data.role);

					// }
				}).on("select", function(e, dt, type, indexes) {
					let btn = $("#btnGroup").find(".btn_type03");
					btn.each(function(index, element){
						if($(this).is(":disabled")){
							$(this).prop("disabled", false);
						}
					});
					siteReadOnlyTable.rows( indexes ).nodes().to$().find("input").prop("checked", true);
					// console.log("dt---", siteReadOnlyTable[ type ]( indexes ).nodes())
				}).on("deselect", function(e, dt, type, indexes) {
					let btn = $("#btnGroup").find(".btn_type03");
					btn.each(function(index, element){
						if(!$(this).is(":disabled")){
							$(this).prop("disabled", true);
						}
					});
					siteReadOnlyTable.rows( indexes ).nodes().to$().find("input").prop("checked", false);
					// console.log("dt---", siteReadOnlyTable[ type ]( indexes ).nodes())
				}).columns.adjust();


				// if (siteReadOnlyTable.data().length != 0) {
				// 	siteReadOnlyTable.on('order.dt search.dt', function () {
				// 		siteReadOnlyTable.column(0, { search: 'applied', order: 'applied' }).nodes().each(function (cell, i) {
				// 			cell.innerHTML = i + 1;
				// 			siteReadOnlyTable.cell(cell).invalidate('dom');
				// 		});
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
				

				$("#siteType").find("li").on( 'click', function(){
					if(!isEmpty($(this).data("name"))){
						filterColumn("1", $(this).data("value"));
					} else {
						filterColumn("1", "");
					}
				});
				
				$("#siteSearchBox").on( 'keyup search input paste cut', function(){
					siteReadOnlyTable.columns(2).search( this.value ).draw();
				});
			
			});
		} else {
			// drawEmptyTable($("#siteTable"))
		}
		$("#loadingCircle").hide();
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
					"title": "DR 자원 코드",
					"data": null,
				},
				{
					"title": "VPP 자원코드",
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
				if(oid.match("kpx")){
					this.api().columns([8,9]).visible( false );
				}
			},
		});
	}

	function getPropertyData(option) {
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
					$("#newVoltWarning").removeClass("hidden");
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
					filterColumn( "#siteTable", "4", $(this).data("name-kr"));
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
			// filterColumn("#siteTable", "3", "");
			filterColumn("#siteTable", "3", "");

			if(!isEmpty($(this).data("id"))){
				filterColumn( "#siteTable", "3", $(this).data("id"));
			} else {
				filterColumn("#siteTable", "3", "");
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
		if(!isEmpty(res.dr_group)){
			newDrResIdList.empty();
			let strDr = '';
			$.each(res.dr_group, function(index, el){
				strDr += '<li data-value="' + el.dgid + '"><a href="#" tabindex="-1">' +  el.resourceId + '</a></li>'
			});

			$("#newVppRevShare").prop('disabled', false).val("-");

			newDrResIdList.append(strDr);
			$("#sectionDRInfo input").each(function(){
				$(this).prop('disabled', false);
			});
			$("#cblList").prev().prop("disabled", false);
		} else {
			newDrResIdList.prev().prop("disabled", true).html("등록된 DR거래 자원 ID가 없습니다.<span class='caret'></span>");
			$("#sectionDRInfo input").each(function(){
				$(this).prop('disabled', true).val("-");
			})
			$("#cblList").prev().prop("disabled", true).html("-<span class='caret'></span>");
		}

		// modal VPP info!!!
		if(!isEmpty(res.vpp_group)){
			newVppResIdList.empty();
			let strVpp = '';
			$.each(res.vpp_group, function(index, el){
				strVpp += '<li data-value="' + el.vgid + '"><a href="#" tabindex="-1">' + el.resourceId + '</a></li>'
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
		let input = form.find("input");
		let dropdownBtn = form.find(".dropdown-toggle");
		let warning = form.find(".warning");

		$("#validSite").addClass("hidden");
		$("#newSiteName").parent().next().prop("disabled", true);
		
		$("#addSiteBtn").prop("disabled", true).removeClass("hidden");

		$("#newResList li").removeClass("hidden");
		$("#newSiteType").prev().prop("disabled", false);
		$("#newSiteDetail").val("");
		$("#confirmSite").val("");

		warning.addClass("hidden");
		input.each(function(){
			$(this).val("").prop("disabled", false);
		});

		$.each(dropdownBtn, function(index, element){
			$(this).data({ "value": "", "vol-type": "", "plan-id" : "" }).html('선택' + '<span class="caret"></span>');
			$(this).next().find("li").removeClass("hidden");
			$(this).prop("disabled", false);
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
			addBtn.text("추가");
			$('#newSiteName').prop('disabled', false);
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
				if(!isEmpty(rowData.role) && rowData.role == 2){
					let input = form.find("input");
					let dropdownBtn = form.find(".dropdown-toggle");

					input.each(function(){
						$(this).prop("disabled", true);
					});

					$.each(dropdownBtn, function(index, element){
						$(this).prop("disabled", true);
					});
					
					addBtn.addClass("hidden");

				} else {
					addBtn.prop("disabled", false).text("수정").removeClass("hidden");
				}

				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");

				if(!newSiteName.parent().next().hasClass("hidden")) {
					newSiteName.parent().next().addClass("hidden");
					newSiteName.parent().removeClass("offset-width").addClass("w-100");
				}
				// 사업소 명
				newSiteName.val( td.eq(2).text() );
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
					$('#newEssList').prev().data("value", rowData.ess).html("유<span class='caret'></span>");
				}
				// 위경도
				if( !isEmpty(rowData.latlng)) {
					$('#newCoord').val(rowData.latlng);
				}
				// 추가 정보
				$('#newSiteDetail').val(rowData.detail_info);
				// kpx
				if (oid.match('kpx')) {
					$('#station_id').val(rowData.station_id);
					$('#kpx_genid').val(rowData.kpx_genid);
					$('#kpx_emsid').val(rowData.kpx_emsid);
					$('#kpx_transvol').val(rowData.kpx_transvol);
				}
				// Utility info
				if( !isEmpty(rowData.utility)) {
					Promise.resolve(JSON.parse(rowData.utility)).then( util => {
						let utilPlanName = util.utility_plan_name;
						// console.log("util==", util);
						$("#newContractList").prev().data({"plan-id": util.utility_plan_id, "value": utilPlanName }).html(utilPlanName + '<span class="caret"></span>');
					
						if(!isEmpty(rowData.role) && rowData.role == 2){
							$("#newVoltTypeList").prev().prop("disabled", true);
						} else {
							$("#newVoltTypeList").prev().prop("disabled", false);
						}

						if(!isEmpty(util.volt_name) ){
							// console.log("util.volt_name==", util.volt_name);
							$("#newVoltTypeList").prev().data({"id": util.utility_plan_id, "data-value" : util.volt_name }).html( util.volt_name + '<span class="caret"></span>');
						} else {
							$("#newVoltTypeList").prev().prop("disabled", true).html('선택<span class="caret"></span>');
						}

						$("#newPeakDemand").val(util.peak_demand);
						$("#newDrCharge").val(util.demand_charge);

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
				let sectionDRInfo = $("#sectionDRInfo");
				let sectionDrDropdown = sectionDRInfo.find(".dropdown-toggle");
				let sectionDrInput = sectionDRInfo.find("input");

				if( !isEmpty(rowData.dr_group_id)) {
					$("#newDrResIdList").prev().data("value", rowData.dr_group_id).html(rowData.drName + "<span class='caret'></span>");
					sectionDrDropdown.each(function(item, index){
						// console.log("index---", index)
						$(this).prop("disabled", false);
					});
					sectionDrInput.each(function(item, index){
						$(this).prop("disabled", false);
					});
					if(!isEmpty(rowData.dr_info)){
						let dr = JSON.parse(rowData.dr_info);
						// console.log("dr===", dr);
						if( !isEmpty(dr.contract_capacity)) {
							$("#drVol").val(dr.contract_capacity);
						}
						if( !isEmpty(dr.cbl_method)) {
							$("#cblList").prev().html(dr.cbl_method + "<span class='caret'></span>");
						}
						if( !isEmpty(dr.profile_share)) {
							$("#newDrRevShare").val(dr.profile_share);
						}
					}
				} else {
					sectionDrDropdown.each(function(item, index){
						$(this).prop("disabled", true).html("선택<span class='caret'></span>");
					});
					sectionDrInput.each(function(item, index){
						$(this).prop("disabled", true).val("");
					});
				}

				// VPP info
				let sectionVppInfo = $("#sectionVppInfo");
				let sectionVppDropdown = sectionVppInfo.find(".dropdown-toggle");
				let sectionVppInput = sectionDRInfo.find("input");

				if( !isEmpty(rowData.vpp_group_id)) {
					$("#newVppResIdList").prev().data("value", rowData.vpp_group_id).html(rowData.vppName + "<span class='caret'></span>");
					sectionVppDropdown.each(function(item, index){
						$(this).prop("disabled", false);
					});
					sectionVppInput.each(function(item, index){
						$(this).prop("disabled", false);
					});
					if( !isEmpty(rowData.vpp_info)) {
						let vpp = JSON.parse(rowData.vpp_info);
						// console.log("vpp===", vpp);

						if( !isEmpty(rowData.vpp_info)) {
							console.log("vpp profile_share NOT empty")
							$("#newVppRevShare").val(vpp.profile_share);
						}
					}
				} else {
					sectionVppDropdown.each(function(item, index){
						$(this).prop("disabled", true).html("선택<span class='caret'></span>");
					});
					sectionVppInput.each(function(item, index){
						$(this).prop("disabled", true).val("");
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

	function getAlarmTable(alarmData, userData){
		let arr = [];
		let userType = "";
		// let newUserList = [];
		// let newNonUserList = [];
		console.log("alarmData===", alarmData);

		Promise.resolve(alarmData.map((x, index) => {
			x.alarmToUser = JSON.parse(x.alarm_to);
			arr.push(x);

				// if(!isEmpty(x.alarm_to)){

				// if(!isEmpty(newUserList)){
				// 	newUserList.push(alarmTo.user);
				// }	
				// if(!isEmpty(newNonUserList)){
				// 	newNonUserList.push(alarmTo.non_user);
				// }
		
				// }
			})).then( () => {
				let newDevType = [...new Map(arr.map(x => [x.device_type, x])).values()];
				let subGroup = [...new Map(arr.map(x => [x.name, x])).values()];

				let alarmTable = $('#alarmTable').DataTable({
					"aaData": arr,
					"table-layout": "fixed",
					"fixedHeader": true,
					"bAutoWidth": true,
					"bSortable": true,
					"bSearchable" : true,
					// "retrieve": true,
					"scrollX": true,
					"sScrollXInner": "100%",
					"scrollY": "50vh",
					"scrollCollapse": false,
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
								let el = $(td).find(".dropdown");
								let lvlStr = $(td).find(".dropdown-toggle");

								$.each(el, function(index, chk){
									let selected = $(this).find(".dropdown-toggle").data("value");
									let input = $(this).find("input[type='checkbox']");
	
									$.each(input, function(idx, checkbox){
										if(selected.length > 1){
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
								if (!isEmpty(rowData.alarmToUser)) {
									// console.log("rowData---", rowData);
									// console.log("cellData---", cellData);
									let dropdown = $(td).find(".dropdown-toggle");
									$.each(dropdown, function(index, el){
										let target = $(this).next().find("input[type='checkbox']");
										if(!isEmpty(target) && target.length > 0){
											let targetArr = target.toArray();
											// console.log("$(this).text()====", $(this).text())
											let found = targetArr.findIndex( x => $(x).data("name") == $(this).text() );
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
								if (!isEmpty(rowData.alarmToUser)) {
									let input = $(td).find("input");
									$.each(input, function(index, el){
										$(this).val($(this).attr("value"));
									});
								}
							}
						},
					],
					"aoColumns": [
						// {
						// 	"sTitle": "순번",
						// 	"mData": null,
						// 	"className": "dt-center",
						// 	mRender: function ( data, type, full, rowIndex ) {
						// 		return rowIndex.row + 1;
						// 	},
						// },
						{
							"sTitle": "설비타입",
							"mData": null,
							"mRender": function ( data, type, row, rowIndex ) {
								let str1 = ``;
								let devName = '';

								subGroup.forEach((item, index, arr) => {
									// console.log("subGroup===", item);
									if(item.name === data.name){
										devName += item.name + ","
									}
								});
								devName = devName.replace(/,\s*$/, "");

								newDevType.forEach((item, index, arr) => {
									str1 += `
										<li onclick="showSubgroup(aDvcNameList${'${ rowIndex.row }'})" data-subgroup="${'${ devName }'}" data-did="${'${ item.did }'}" data-value="${'${ item.device_type }'}"><a href="#" tabindex="-1">${'${ item.device_type }'}</a></li>
									`
								});

								let dropdown1 = `
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ data.device_type }'}" disabled>${'${ data.device_type }'}<span class="caret"></span></button>
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
								let nonUser = data.alarmToUser.non_user;
								let registeredUser = data.alarmToUser.user;
								let str3 = ``;
								let dropdown3 = ``;
								let aLevelOpt = [
									{  name : "정보", val: 0 },
									{  name : "경고", val: 1 },
									{  name : "이상", val: 2 },
									{  name : "트립", val: 3 },
									{  name : "긴급", val: 4 },
									{  name : "알수 없음", val: 9 },
								];

								// $.each(aLevelOpt, function(index, el){
								// 	str3 += `
								// 		<li data-name="${'${ el.name }'}" data-value="${'${ el.val }'}"><a href="#" tabindex="-1">${'${ el.name }'}</a></li>
								// 	`
								// });

								$.each(aLevelOpt, function(index, el){
									str3 += `
										<li>
											<a class="chk_type" href="#">
												<input type="checkbox" id="aDvcLevel${'${ el.val }'}" name="aDvcLevel${'${ el.val }'}" value="${'${ el.val }'}" />
												<label for="aDvcLevel${'${ el.val }'}">${'${ el.name }'}</label>
											</a>
										</li>
									`
								});

								// console.log("row.level EMPTY====", data);
								if(!isEmpty(nonUser) && nonUser.length > 0){
									$.each(nonUser, function(index, el){
										let levText = "";
										let levVal = "";
										let newIdx = String(rowIndex.row + "Non" + index);

										if(!isEmpty(el.level)){
											// levVal = aLevelOpt[item].val;
											// levText = aLevelOpt[item].name;

											// dropdown3 += `
											// 	<div class="dropdown">
											// 		<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ levVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
											// 		<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
											// 	</div>
											// `

											// $.each(el.level, function(index, item){
											// 	levVal = aLevelOpt[item].val;
											// 	levText = aLevelOpt[item].name;

											// 	dropdown3 += `
											// 		<div class="dropdown">
											// 			<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ levVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
											// 			<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
											// 		</div>
											// 	`
											// });
										// } else {
											let val = el.level[0];
											let joinedVal = el.level.join(",");

											if(el.level.length> 1){
												levText = aLevelOpt[val].name + ' 외 ' + String(el.level.length - 1) + "개";
											} else {
												levText = aLevelOpt[val].name 
											}
											dropdown3 += `
												<div class="dropdown">
													<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ joinedVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
													<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
												</div>
											`
										} else {
											dropdown3 += `
												<div class="dropdown">
													<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ aLevelOpt[5].val }'}" data-name="${'${ aLevelOpt[5].name }'}" disabled>${'${ aLevelOpt[5].name }'}<span class="caret"></span></button>
													<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
												</div>
											`
										}
									});																		
								}

								if(!isEmpty(registeredUser) && registeredUser.length > 0){
									$.each(registeredUser, function(index, el){
										let levText = "";
										let levVal = "";
										let newIdx = String(rowIndex.row + index);

										if(!isEmpty(el.level)){
											// $.each(el.level, function(index, item){
											// 	levVal = aLevelOpt[item].val;
											// 	levText = aLevelOpt[item].name;

											// 	dropdown3 += `
											// 		<div class="dropdown">
											// 			<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ levVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
											// 			<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
											// 		</div>
											// 	`;
											// });
											let joinedVal = el.level.join(",");
											let val = el.level[0];

											if(el.level.length> 1){
												levText = aLevelOpt[val].name + ' 외 ' + String(el.level.length - 1) + "개";
											} else {
												levText = aLevelOpt[val].name 
											}
											dropdown3 += `
												<div class="dropdown">
													<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ joinedVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
													<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
												</div>
											`
										} else {
											dropdown3 += `
												<div class="dropdown">
													<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ aLevelOpt[5].val }'}" data-name="${'${ aLevelOpt[5].name }'}" disabled>${'${ aLevelOpt[5].name }'}<span class="caret"></span></button>
													<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
												</div>
											`;
										}

									});
								}

								return dropdown3;
							},
							// "className": "no-sorting",
						},
						{
							"sTitle": "담당자 이름(아이디)",
							"mData": null,
							"mRender": function ( data, type, row, rowIndex ) {
								let nonUser = data.alarmToUser.non_user;
								let registeredUser = data.alarmToUser.user;
								
								let str4 = ``;
								let dropdown4 = ``;
								let userIdx = '';

								if(!isEmpty(nonUser) && nonUser.length > 0){
									nonUser.forEach((item, index) => {
										let displayName = item.name;
										newIdx = String(rowIndex.row + index);

										str4 += `
											<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
										`;
										$.each(userData, function(idx, el){
											let nameId = `${'${ el.name }'}` + `(` + `${'${ el.login_id }'}` + `)`;
											str4 += `
												<li onclick='removeNewInput(this)'>
													<a class="chk_type" href="#">
														<input type="checkbox" id="${'${ el.login_id }'}${'${ newIdx }'}" name="aDvcContactPerson${'${ newIdx }'}" value="${'${ el.uid }'}" data-name="${'${ el.name }'}" />
														<label for="${'${ el.login_id }'}${'${ newIdx }'}">${'${ nameId }'}</label>
													</a>
												</li>
											`;
										});

										dropdown4 += `
											<div class="dropdown" data-user-type="non-user" data-user-index="${'${ index }'}">
												<button type="button" class="dropdown-toggle" data-value="${'${ displayName }'}" data-toggle="dropdown" disabled>${'${ displayName }'}<span class="caret"></span></button>
												<ul id="aDvcContactListNonUser${'${ newIdx }'}" class="dropdown-menu">${'${ str4 }'}</ul>
											</div>
											<div class="tx_inp_type ml-0 hidden"><input type="text" name="aDvcContactNonUser${'${ newIdx }'}" id="aDvcContactNonUser${'${ newIdx }'}" /></div>
										`;

									});
								}


								if(!isEmpty(registeredUser) && registeredUser.length > 0){
									registeredUser.forEach((item, index) => {
										newIdx = String(rowIndex.row + index);
										let displayName = item.uid;
										// console.log("registered--", item);
										str4 += `
											<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
										`
										$.each(userData, function(idx, el){
											let nameId = `${'${ el.name }'}` + `(` + `${'${ el.login_id }'}` + `)`;
											str4 += `
												<li onclick='removeNewInput(this)'>
													<a class="chk_type" href="#">
														<input type="checkbox" id="${'${ el.login_id }'}${'${ newIdx }'}" name="aDvcContactPerson${'${ newIdx }'}" value="${'${ el.uid }'}" data-name="${'${ el.name }'}"/>
														<label for="${'${ el.login_id }'}${'${ newIdx }'}">${'${ nameId }'}</label>
													</a>
												</li>
											`
										});
										dropdown4 += `
											<div class="dropdown" data-user-type="user" data-user-index="${'${ index }'}">
												<button type="button" class="dropdown-toggle" data-value="${'${ displayName }'}" data-toggle="dropdown" disabled>${'${ displayName }'}<span class="caret"></span></button>
												<ul id="aDvcContactList${'${ newIdx }'}" class="dropdown-menu">${'${ str4 }'}</ul>
											</div>
											<div class="tx_inp_type ml-0 hidden"><input type="text" name="aDvcContact${'${ newIdx }'}" id="aDvcContact${'${ newIdx }'}" /></div>
										`;
									});
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
								let nonUser = data.alarmToUser.non_user;
								let registeredUser = data.alarmToUser.user;

								if(!isEmpty(nonUser) && nonUser.length > 0){
									let nonUserId = data.alarmToUser.user_id;
					
									nonUser.forEach((item, index) => {
										let newIdx = String(rowIndex.row + index);
										let displayName = item.name;
										let phoneNum = "";
										item.phone ? phoneNum = item.phone : "";

										str5 += `<div class="tx_inp_type disabled" data-user-type="non-user"><input type="text" name="aDvcPhoneNonUser${'${ newIdx }'}" id="aDvcPhoneNonUser${'${ newIdx }'}" value="${'${ phoneNum }'}" disabled /></div>`;
									});
								}

								if(!isEmpty(registeredUser) && registeredUser.length > 0){
									registeredUser.forEach((item, index) => {
										let newIdx = String(rowIndex.row + index);
										let displayName = item.name;
										let phoneNum = "";
										item.phone ? phoneNum = item.phone : "";

										str5 += `<div class="tx_inp_type disabled" data-user-type="user"><input type="text" name="aDvcPhone${'${ newIdx }'}" id="aDvcPhone${'${ newIdx }'}" value="${'${ phoneNum }'}" disabled /></div>`;
									});
								}

								return str5;
							},
							// "className": "no-sorting",
						},
						{
							"title": "",
							"mData": null,
							"mRender": function ( data, type, row, rowIndex ) {
								let editStr = ``;
								let length = 0;

								if(!isEmpty(data.alarmToUser.user)){
									length += data.alarmToUser.user.length;
								}
								if(!isEmpty(data.alarmToUser.non_user)){
									length += data.alarmToUser.non_user.length;
								}

								for(let i = 0, arrLength = length; i < arrLength; i++ ){
									editStr += `<div class="flex_start"><button type="button" class="icon-edit" data-index="${'${i}'}" onclick="updateAlarmInfo($(this))">수정</button></div>`;
								}

								return editStr;
							},
							// "className": "dt-body-center no-sorting",
							"className": "dt-body-center",
						},
						{
							"sTitle": "",
							"mData": null,
							"mRender": function ( data, type, row, row, rowIndex ) {
								let deleteStr = ``;
								let length = 0;

								if(!isEmpty(data.alarmToUser.user)){
									length += data.alarmToUser.user.length;
								}
								if(!isEmpty(data.alarmToUser.non_user)){
									length += data.alarmToUser.non_user.length;
								}

								for(let i = 0, arrLength = length; i < arrLength; i++ ){
									deleteStr += `<div class="flex_start"><button type="button" class="icon-delete" data-index="${'${i}'}" onclick="updateAlarmInfo($(this), 'delete')">삭제</button></div>`;
								}

								return deleteStr;
							},
							// "className": "dt-body-center no-sorting",
							"className": "dt-body-center",
						},
					],
					initComplete: function(){
						// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						// 	cell.innerHTML = i+1;
						// 	$(cell).data("id", i);
						// });
						// this.api().column(5).visible( false );
					},
					rowCallback: function(row, data) {
						let length = 0;

						if(!isEmpty(data.alarmToUser.user)){
							length += data.alarmToUser.user.length;
						}
						if(!isEmpty(data.alarmToUser.non_user)){
							length += data.alarmToUser.non_user.length;
						}

						if(length === 1 ){
							$(row).addClass('single');
						}
					},
					drawCallback: function(){
						$('#alarmTable_wrapper').addClass('fixed-width');

						// this.api().columns().header().each ((el, i) => {
						// 	if(i == 0){
						// 		$(el).attr ('style', 'width: 4%;');
						// 	}
						// 	if(i == 5){
						// 		$(el).attr ('style', 'min-width: 180px;');
						// 	}
						// });
					}
				}).columns.adjust().responsive.recalc();
				
				
				// }).columns.adjust().draw();


				// new $.fn.dataTable.Buttons( alarmTable, {
				// 	name: 'commands',
				// 	"buttons": [
				// 		{
				// 		 extend: "selected",
				// 			className: "btn_type03",
				// 			text: 'Duplicate',
				// 			action: function ( e, dt, node, config ) {
				// 				let tr = $("#alarmTable .tbody tr:first-of-type");
				// 				alarmTable.rows().indexes(0).clone().addRow().draw( 'false' );
				// 			}
				// 		},
				// 		// {
				// 		// 	extend: 'remove',
				// 		// 	className: "btn_type03",
				// 		// 	text: 'editor',
				// 		// },
				// 	],
				// });

				// alarmTable.buttons( 0, null ).containers().appendTo("#addAlarmModal .modal-header");

				// alarmTable.on( 'column-sizing.dt', function ( e, settings ) {
				// 	$(".dataTables_scrollHeadInner").css( "width", "100%" );
				// });

				// let td = $('#alarmTable td:first-of-type');
				// console.log("td---", td)
				// td.each(function(){
				// 	td.find(".dropdown-menu li").on('click', function (e) {
				// 		console.log("this---", $(this))
				// 	});
				// });

				$("#addAlarmModal").modal("show");

			});
		

			// let alarmTable = $('#alarmTable').DataTable({
			// 	"aaData": arr,
			// 	"table-layout": "fixed",
			// 	"fixedHeader": true,
			// 	"bAutoWidth": true,
			// 	"bSortable": true,
			// 	"bSearchable" : true,
			// 	// "retrieve": true,
			// 	"scrollX": true,
			// 	"sScrollXInner": "100%",
			// 	"scrollY": "50vh",
			// 	"scrollCollapse": false,
			// 	"pageLength": 4,
			// 	// "scrollY": "400px",
			// 	// "bScrollCollapse": true,
			// 	"bSearchable" : true,
			// 	"dom": 'tip',
			// 	"aoColumnDefs": [
			// 		// {
			// 		// 	"aTargets": [ 0 ],
			// 		// 	"bSortable": false,
			// 		// 	"orderable": false
			// 		// },
			// 		// {
			// 		// 	"aTargets": [ 0, 1, 2, 3, 4, 5, 6 ],
			// 		// 	"bSortable": false,
			// 		// 	"orderable": false
			// 		// },
			// 		{
			// 			"aTargets": [ 4 ],
			// 			"createdCell": function (td, cellData, rowData, row, col) {
			// 				if (!isEmpty(rowData.alarmToUser)) {
			// 					// console.log("rowData---", rowData);
			// 					// console.log("cellData---", cellData);
								
			// 					let input = $(td).find("input");
			// 					$.each(input, function(index, el){
			// 						$(this).val($(this).attr("value"));
			// 					});
			// 				}
			// 			}
			// 		}
			// 	],
			// 	"aoColumns": [
			// 		// {
			// 		// 	"sTitle": "순번",
			// 		// 	"mData": null,
			// 		// 	"className": "dt-center",
			// 		// 	mRender: function ( data, type, full, rowIndex ) {
			// 		// 		return rowIndex.row + 1;
			// 		// 	},
			// 		// },
			// 		{
			// 			"sTitle": "설비타입",
			// 			"mData": null,
			// 			"mRender": function ( data, type, row, rowIndex ) {
			// 				let dropdown1 = `
			// 					<div class="dropdown">
			// 						<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ data.device_type }'}" disabled>${'${ data.device_type }'}<span class="caret"></span></button>
			// 						<ul id="aDvcTypeList${'${ rowIndex.row }'}" class="dropdown-menu">
			// 							<li onclick="showSubgroup(aDvcNameList${'${ rowIndex.row }'})" data-subgroup="${'${ data.name }'}" data-did="${'${ data.did }'}" data-value="${'${ data.device_type }'}">
			// 								<a href="#" tabindex="-1">${'${ data.device_type }'}</a>
			// 							</li>
			// 						</ul>
			// 					</div>
			// 				`;

			// 				return dropdown1;
			// 			},
			// 			// "className": "no-sorting",
			// 		},
			// 		{
			// 			"sTitle": "설비명",
			// 			"mData": null,
			// 			"mRender": function ( data, type, row, rowIndex ) {	
			// 				let subDropdown = `
			// 					<div class="dropdown">
			// 						<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ row.name }'}" disabled>${'${ row.name }'}<span class="caret"></span></button>
			// 						<ul id="aDvcNameList${'${ rowIndex.row }'}" class="dropdown-menu">
			// 							<li data-device-type="${'${ data.device_type }'}" data-did="${'${ data.did }'}" data-value="${'${ data.name }'}"><a href="#" tabindex="-1">${'${ data.name }'}</a></li>
			// 						</ul>
			// 					</div>
			// 				`;
			// 				return subDropdown;
			// 			},
			// 			// "className": "no-sorting",
			// 		},
			// 		{
			// 			"sTitle": "알람레벨",
			// 			"mData": null,
			// 			"mRender": function ( data, type, row, rowIndex ) {
			// 				let str3 = ``;
			// 				let dropdown3 = ``;
			// 				let aLevelOpt = [
			// 					{  name : "정보", val: 0 },
			// 					{  name : "경고", val: 1 },
			// 					{  name : "이상", val: 2 },
			// 					{  name : "트립", val: 3 },
			// 					{  name : "긴급", val: 4 },
			// 					{  name : "알수 없음", val: 9 },
			// 				];

			// 				$.each(aLevelOpt, function(index, el){
			// 					str3 += `
			// 						<li data-name="${'${ el.name }'}" data-value="${'${ el.val }'}"><a href="#" tabindex="-1">${'${ el.name }'}</a></li>
			// 					`
			// 				});

			// 				if(!isEmpty(row.level)){
			// 					dropdown3 = `
			// 						<div class="dropdown">
			// 							<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ row.level }'}" data-name="${'${ aLevelOpt[row.level].name} }'}" disabled>${'${ aLevelOpt[row.level].name }'}<span class="caret"></span></button>
			// 							<ul id="aDvcAlarmList${'${ rowIndex.row }'}" class="dropdown-menu">${'${ str3 }'}</ul>
			// 						</div>
			// 					`;
			// 				} else {
			// 					let nonUser = data.alarmToUser.non_user;
			// 					let registeredUser = data.alarmToUser.user;
			// 					// console.log("row.level EMPTY====", data);
			// 					if(!isEmpty(nonUser)){
			// 						$.each(nonUser, function(index, el){
			// 							let levText = "";
			// 							let levVal = "";
			// 							let newIdx = String(rowIndex.row + "Non" + index);

			// 							if(!isEmpty(el.level)){
			// 								$.each(el.level, function(index, item){
			// 									levVal = aLevelOpt[item].val;
			// 									levText = aLevelOpt[item].name;

			// 									dropdown3 += `
			// 										<div class="dropdown">
			// 											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ levVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
			// 											<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
			// 										</div>
			// 									`
			// 								});
			// 							}
			// 						});
			// 					}

			// 					if(!isEmpty(registeredUser)){
			// 						$.each(registeredUser, function(index, el){
			// 							let levText = "";
			// 							let levVal = "";
			// 							let newIdx = String(rowIndex.row + index);

			// 							if(!isEmpty(el.level)){
			// 								$.each(el.level, function(index, item){

			// 									levVal = aLevelOpt[item].val;
			// 									levText = aLevelOpt[item].name;
			// 									dropdown3 += `
			// 										<div class="dropdown">
			// 											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="${'${ levVal }'}" data-name="${'${ levText }'}" disabled>${'${ levText }'}<span class="caret"></span></button>
			// 											<ul id="aDvcAlarmList${'${ newIdx }'}" class="dropdown-menu">${'${ str3 }'}</ul>
			// 										</div>
			// 									`;
			// 								});
			// 							}
			// 						});
			// 					}

			// 				}
			// 				return dropdown3;
			// 			},
			// 			// "className": "no-sorting",
			// 		},
			// 		{
			// 			"sTitle": "담당자",
			// 			"mData": null,
			// 			"mRender": function ( data, type, row, rowIndex ) {
			// 				// console.log("userList---", newUserList);
			// 				// console.log("newNonUserList---", newNonUserList);
			// 				let str4 = ``;
			// 				let dropdown4 = ``;
			// 				let userIdx = '';

			// 				if(!isEmpty(data.alarmToUser.non_user)){
			// 					let nonUser = data.alarmToUser.non_user;

			// 					nonUser.forEach((item, index) => {
			// 						let displayName = item.name;
			// 						newIdx = String(rowIndex.row + index);

			// 						str4 += `
			// 							<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
			// 						`;
			// 						$.each(userData, function(idx, el){
			// 							let nameId = `${'${ el.name }'}` + `(` + `${'${ el.login_id }'}` + `)`;
			// 							str4 += `
			// 								<li onclick='removeNewInput(this)'>
			// 									<a class="chk_type" href="#">
			// 										<input type="checkbox" id="${'${ el.login_id }'}${'${ newIdx }'}" name="aDvcContactPerson${'${ newIdx }'}" value="${'${ el.uid }'}" />
			// 										<label for="${'${ el.login_id }'}${'${ newIdx }'}">${'${ nameId }'}</label>
			// 									</a>
			// 								</li>
			// 							`;
			// 						});

			// 						dropdown4 += `
			// 							<div class="dropdown" data-user-type="non-user" data-user-index="${'${ index }'}">
			// 								<button type="button" class="dropdown-toggle" data-value="${'${ item.name }'}" data-toggle="dropdown" disabled>${'${ displayName }'}<span class="caret"></span></button>
			// 								<ul id="aDvcContactListNonUser${'${ newIdx }'}" class="dropdown-menu">${'${ str4 }'}</ul>
			// 							</div>
			// 							<div class="tx_inp_type ml-0 hidden"><input type="text" name="aDvcContactNonUser${'${ newIdx }'}" id="aDvcContactNonUser${'${ newIdx }'}" /></div>
			// 						`;

			// 					});
			// 				}

			// 				if(!isEmpty(data.alarmToUser.user)){
			// 					let registeredUser = data.alarmToUser.user;

			// 					registeredUser.forEach((item, index) => {
			// 						newIdx = String(rowIndex.row + index);
			// 						let displayName = item.uid;
			// 						str4 += `
			// 							<li onclick='addNewInput(this)'><a href="#">직접 입력</a></li>
			// 						`
			// 						$.each(userData, function(idx, el){
			// 							let nameId = `${'${ el.name }'}` + `(` + `${'${ el.login_id }'}` + `)`;
			// 							str4 += `
			// 								<li onclick='removeNewInput(this)'>
			// 									<a class="chk_type" href="#">
			// 										<input type="checkbox" id="${'${ el.login_id }'}${'${ newIdx }'}" name="aDvcContactPerson${'${ newIdx }'}" value="${'${ el.uid }'}" />
			// 										<label for="${'${ el.login_id }'}${'${ newIdx }'}">${'${ nameId }'}</label>
			// 									</a>
			// 								</li>
			// 							`
			// 						});
			// 						dropdown4 += `
			// 							<div class="dropdown" data-user-type="user" data-user-index="${'${ index }'}">
			// 								<button type="button" class="dropdown-toggle" data-value="${'${ item.name }'}" data-toggle="dropdown" disabled>${'${ displayName }'}<span class="caret"></span></button>
			// 								<ul id="aDvcContactList${'${ newIdx }'}" class="dropdown-menu">${'${ str4 }'}</ul>
			// 							</div>
			// 							<div class="tx_inp_type ml-0 hidden"><input type="text" name="aDvcContact${'${ newIdx }'}" id="aDvcContact${'${ newIdx }'}" /></div>
			// 						`;
			// 					});
			// 				}

			// 				return dropdown4;
			// 			},
			// 			// "className": "no-sorting",
			// 			// "width": "16%"
			// 		},
			// 		{
			// 			"sTitle": "전화번호",
			// 			"mData": null,
			// 			"mRender": function ( data, type, row, rowIndex ) {
			// 				let str5 = ``;
			// 				let nonUser = data.alarmToUser.non_user;
			// 				let registeredUser = data.alarmToUser.user;

			// 				if(!isEmpty(nonUser)){
			// 					let nonUserId = data.alarmToUser.user_id;
				
			// 					nonUser.forEach((item, index) => {
			// 						let newIdx = String(rowIndex.row + index);
			// 						let displayName = item.name;
			// 						str5 += `<div class="tx_inp_type disabled" data-user-type="non-user"><input type="text" name="aDvcPhoneNonUser${'${ newIdx }'}" id="aDvcPhoneNonUser${'${ newIdx }'}" value="${'${ item.phone }'}" disabled /></div>`;
			// 					});
			// 				}

			// 				if(!isEmpty(registeredUser)){
			// 					registeredUser.forEach((item, index) => {
			// 						let newIdx = String(rowIndex.row + index);
			// 						let displayName = item.name;
			// 						str5 += `<div class="tx_inp_type disabled" data-user-type="user"><input type="text" name="aDvcPhone${'${ newIdx }'}" id="aDvcPhone${'${ newIdx }'}" value="${'${ item.phone }'}" disabled /></div>`;
			// 					});
			// 				}

			// 				return str5;
			// 			},
			// 			// "className": "no-sorting",
			// 		},
			// 		{
			// 			"title": "",
			// 			"mData": null,
			// 			"mRender": function ( data, type, row, rowIndex ) {
			// 				let editStr = ``;

			// 				if(!isEmpty(data.alarmToUser.non_user) && !isEmpty(data.alarmToUser.user)){
			// 					let length = data.alarmToUser.non_user.length + data.alarmToUser.user.length;
			// 					for(let i = 0, arrLength = length; i < arrLength; i++ ){
			// 						editStr += `<div class="flex_start"><button type="button" class="icon-edit" data-index="${'${i}'}" onclick="updateAlarmInfo($(this))">수정</button></div>`;
			// 					}
			// 				}

			// 				return editStr;
			// 			},
			// 			// "className": "dt-body-center no-sorting",
			// 			"className": "dt-body-center",
			// 		},
			// 		{
			// 			"sTitle": "",
			// 			"mData": null,
			// 			"mRender": function ( data, type, row, row, rowIndex ) {
			// 				let deleteStr = ``;

			// 				if(!isEmpty(data.alarmToUser.non_user) && !isEmpty(data.alarmToUser.user)){
			// 					let length = data.alarmToUser.non_user.length + data.alarmToUser.user.length;
			// 					for(let i = 0, arrLength = length; i < arrLength; i++ ){
			// 						deleteStr += `<div class="flex_start"><button type="button" class="icon-delete" data-index="${'${i}'}" onclick="updateAlarmInfo($(this), 'delete')">삭제</button></div>`;
			// 					}
			// 				}
			// 				return deleteStr;
			// 			},
			// 			// "className": "dt-body-center no-sorting",
			// 			"className": "dt-body-center",
			// 		},
			// 	],
			// 	initComplete: function(){
			// 		// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
			// 		// 	cell.innerHTML = i+1;
			// 		// 	$(cell).data("id", i);
			// 		// });
			// 		// this.api().column(5).visible( false );
			// 	},
			// 	rowCallback: function(row, data) {
			// 		// if(!isEmpty(data.alarmToUser.non_user) && !isEmpty(data.alarmToUser.user) ) {
			// 		// 	let length = data.alarmToUser.non_user.length + data.alarmToUser.user.length;
			// 		// 	if(length === 1 ){
			// 		// 		$(row).addClass('single');
			// 		// 	}
			// 		// }

			// 	},
			// 	drawCallback: function(){
			// 		$('#alarmTable_wrapper').addClass('fixed-width');

			// 		// this.api().columns().header().each ((el, i) => {
			// 		// 	if(i == 0){
			// 		// 		$(el).attr ('style', 'width: 4%;');
			// 		// 	}
			// 		// 	if(i == 5){
			// 		// 		$(el).attr ('style', 'min-width: 180px;');
			// 		// 	}
			// 		// });
			// 	}
			// }).columns.adjust().responsive.recalc();
			
			

		// level = userlist[i].level[j];
		// uid = userlist[i].uid;
		// phone = ((isEmpty(userlist[i].phone)) ? '-' : userlist[i].phone );
		// newUserList.push({non : non, did : did, type : type, name : name, level : level, uid : uid, phone : phone });
		// alarmTotalData.push({non : non, did : did, type : type, name : name, level : level, uid : uid, phone : phone });
		// var alarmTable = $('#alarmTable').DataTable({
		// 	"fixedHeader": true,
		// 	"table-layout": "fixed",
		// 	"retrieve": true,
		// 	// "scrollX": false,
		// 	"scrollY": "300px",
		// 	"order": [[ 1, 'asc' ]],
		// 	"aoColumnDefs": [
		// 		{
		// 			"aTargets": [ 0 ],
		// 			"bSortable": false,
		// 			"orderable": false
		// 		},
		// 	],
		// 	"aaData": data,
		// 	"aoColumns": [
		// 		{
		// 			"sTitle": "설비타입",
		// 			"mData": null,
		// 			"render": function ( data, type, row ) {
		// 				// BMS_RACK,
		// 				// BMS_SYS,
		// 				// CCTV,
		// 				// CIRCUIT_BREAKER,
		// 				// COMBINER_BOX,
		// 				// INV_PV, INV_WIND, 
		// 				// KPX_EMS,
		// 				// PCS_ESS,
		// 				// SENSOR_FLAME, SENSOR_SOLAR, SENSOR_TEMPHUMID, SENSOR_WEATHER,
		// 				// SM, SM_CRAWLING, SM_DR, SM_ISMART, SM_KPX, SM_MANUAL
		// 				return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type"/>' + data.device_type +'</div>';
		// 			},
		// 		},
		// 		{
		// 			"sTitle": "설비명",
		// 			"render": function ( data, type, row ) {
		// 				return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type" placeholder=""/></div>';
		// 			},
		// 		},
		// 		{
		// 			"sTitle": "알람레벨",
		// 			"render": function ( data, type, row ) {
		// 				return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type" placeholder=""/></div>';
		// 			},
		// 		},
		// 		{
		// 			"sTitle": "담당자",
		// 			"render": function ( data, type, row ) {
		// 				return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type" placeholder=""/></div>';
		// 			},
		// 		},
		// 		{
		// 			"sTitle": "",
		// 			"className": ""
		// 		},
		// 		{
		// 			"sTitle": "",
		// 			"className": "",
		// 		},
		// 	],
		// 	"fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
		// 		if (aiDisplay.length > 0) {
		// 			$('body').removeClass('no-record');
		// 		}
		// 		else {
		// 			$('body').addClass('no-record');
		// 		}
		// 	},
		// 	"dom": 'ti',
		// 	"select": {
		// 		style: 'single',
		// 	},
		// 	initComplete: function(){
		// 		let str = `
		// 			<button type="button" class="btn-text-blue ml-24" onclick="insertRowCopy()">추가</button>
		// 		`
		// 		$("#addAlarmModal").find(".modal-header").append($(str));

		// 		// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
		// 		// 	cell.innerHTML = i+1;
		// 		// 	$(cell).data("id", i);
		// 		// });
		// 	},
		// });

		// alarmTable.on( 'order.dt search.dt', function () {
		// 	alarmTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
		// 		cell.innerHTML = i+1;
		// 	} );
		// }).draw();
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

	function hideDropdown(target){
		let input = '#' + target;
		console.log("target====", target);
		// $(input).removeClass("hidden");


	}

	function showSubgroup (self){
		let subGroup = '#' + $(self).data("subgroup");

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
		let input = parent.next();
		let phone = $(self).parents().closest("tr").find("td:nth-of-type(5) input[type='text']");
		let num = $(self).parent().attr("id").match(/\d+/)[0];

		$(self).siblings().find("input:checked").prop("checked", false);
		input.toggleClass("hidden");

		$.each(phone, function(index, el){
			if($(this).attr("id").match(/\d+/)[0] == num){
				$(this).prop("disabled", false);
			}
		});

	}

	function removeNewInput(self){
		let parent = $(self).parent().parent().next();
		let phone = $(self).parents().closest("tr").find("td:nth-of-type(5) input[type='text']");
		let num = $(self).parent().attr("id").match(/\d+/)[0];

		$(self).siblings().removeClass("hidden");
		parent.addClass("hidden");
		$.each(phone, function(index, el){
			if($(this).attr("id").match(/\d+/)[0] == num){
				$(this).prop("disabled", true);
			}
		});

	}



	function updateAlarmInfo(self, option){		
		let tr = self.parents().closest("tr");
		let td = tr.find("td");
		let alarmTable = $("#alarmTable").DataTable();	
		let rowData = alarmTable.row(tr).data();	
		let dataIdx = self.data("index");
		
		let directInput = tr.find("td:nth-of-type(4) input[type='text']").eq(dataIdx);
		let input = tr.find("td:nth-of-type(5) input[type='text']").eq(dataIdx);

		$.each(td, function(index, el){
			if(index >= 2 && index <= 3){
				let target = $(this).find(".dropdown-toggle").eq(dataIdx);
				if(target.is(":disabled")) {
					target.prop("disabled", false);
					if(!directInput.hasClass("hidden")){
						directInput.prop("disabled", false).parent().removeClass("disabled");
					}
				} else {
					target.prop("disabled", true);
					if(!directInput.hasClass("hidden")){
						directInput.prop("disabled", false).parent().addClass("disabled");
					}
				}
			} else {
				let target = $(this).find(".dropdown-toggle");
				if(input.is(":disabled")) {
					target.prop("disabled", false);
				} else {
					target.prop("disabled", true);
				}
				if(index == 4) {
					if(input.is(":disabled")) {
						input.prop("disabled", false).parent().removeClass("disabled");
					} else {
						input.prop("disabled", true).parent().addClass("disabled");
					}
				}
			}

		});

		if(option){
			if(option == "delete"){
				console.log("deleteAlarm==");
				let alarmName = rowData.name + "/" + tr.find("td:nth-of-type(3) .dropdown-toggle").eq(dataIdx).text();
				let modal = $("#alarmDeleteConfirmModal");
				let confirmAlarmName = $("#confirmAlarm");
				let deleteBtn = $("#alarmDeleteConfirmBtn");

				let userType = tr.find("td:nth-of-type(4) .dropdown").eq(dataIdx);
				let userIdx = userType.data("user-index");
				let newAlarmTo = rowData.alarmToUser;
				
				$("#alarmDeleteSuccessMsg span").text(alarmName);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmAlarmName.on("input", function() {
					if($(this).val() !== alarmName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmAlarmName.on("keyup", function() {
					if($(this).val() !== alarmName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				if( userType.data("user-type") == "non-user"){
					newAlarmTo.non_user.splice(userIdx, 1);
				} else {
					newAlarmTo.user.splice(userIdx, 1);
				}

				let deviceOpt = {
					url: apiHost + "/config/devices/" + rowData.did,
					type: 'patch',
					async: true,
					data: JSON.stringify(newAlarmTo),
					contentType: 'application/json; charset=UTF-8',
				};
			

				$("#alarmDeleteConfirmBtn").click(function(){
					if(confirmAlarmName != alarmName) return false;

					$.ajax(deviceOpt).done(function (json, textStatus, jqXHR) {
						$("#alarmDeleteSuccessMsg").text("해당 알람 정보가 삭제 되었습니다.").removeClass("hidden");
						refreshSiteList();
						setTimeout(function(){
							modal.modal("hide");
						}, 1500);
					}).fail(function (jqXHR, textStatus, errorThrown) {
						modal.find(".modal-body").addClass("hidden");
						$("#alarmDeleteSuccessMsg").text("해당 알람 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
						setTimeout(function(){
							modal.modal("hide");
						}, 1500);
						console.log("fail==", jqXHR)
					});
				});


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
		
			console.log("rowData=====", rowData);
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

	}

	function insertRowCopy(){
		let aTable = $("#alarmTable").DataTable();
		let copy = $("#alarmTable tbody tr:last-of-type").clone();
		let idAttr = copy.find('[id^="aDvc"]');
		let nameAttr = copy.find('[name^="aDvc"]');

		if(!copy.hasClass("single")){
			copy.find("td .dropdown:not(:first-of-type)").remove();
			copy.find("td:nth-of-type(4) .tx_inp_type:not(:nth-of-type(2))").remove();
			copy.find("td:nth-of-type(5) .tx_inp_type:not(:first-of-type)").remove();
			copy.find("td .flex_start:not(:first-of-type)").remove();
		}

		copy.find("td .dropdown-toggle").prop("disabled", false).html('선택<span class="caret"></span>');
		copy.find("td input[type='text']").prop("disabled", false).val("").parent().removeClass("disabled");

		$.each(idAttr, function(index, el){
			let oldId = $(this).attr("id");
			let num = (Number(oldId.match(/\d+/)[0]) + 999 );
			let newId = oldId + String(num);
			// let num = Number(oldId.match(/\d+/)[0]) + 1;
			// let text = oldId.match(/[^\d]+/) + String(num);

			$(this).attr("id", newId);
		});

		$.each(nameAttr, function(index, el){
			let oldName = $(this).attr("name");
			let num = (Number(oldName.match(/\d+/)[0]) + 999 );
			let newName = oldName + String(num);

			$(this).attr("name", newName);

		});

		// aTable.rows().add(copy).draw(false);

		$("#alarmTable tbody").append(copy);

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
		<div class="flex_group">
			<span class="tx_tit">사업소 유형</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul id="siteType" class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="inline-title">지역</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul id="countryList" class="dropdown-menu unused chk_type" role="menu">
					<li><a href="#">전체</a></li>
					<c:forEach var="country" items="${location}">
						<c:if test="${country.value.code eq 'kr'}">
							<c:forEach var="city" items="${country.value.locations}" varStatus="cityName">
								<li data-id="${city.value.code}" data-value="${city.value.name.kr}">
									<a href="#" tabindex="-1"><c:out value="${city.value.code}"></c:out>
										<!-- <input type="checkbox" name="${city.value.name.en}" id="${city.value.code}" value="${city.value.name.kr}">
										<label for="${city.value.code}" class="on"><c:out value="${city.value.code}"></c:out></label> -->
									</a>
								</li>
							</c:forEach>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">발전 자원</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul id="resTypeList" class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">사업소 명</span>
			<div class="flex_start">
				<div class="tx_inp_type">
					<input type="text" id="siteSearchBox" name="site_search_box" placeholder="입력">
				</div>
			</div>
		</div>
	</div>
	<div class="col-2">
		<div id="exportBtnGroup" class="fr"></div>
		<!-- <button type="button" class="save_btn ml-16 fr" onclick="$(this).prev().toggleClass('hidden')">데이터 다운로드</button>--> 
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
					<col style="width:10%">
					<col style="width:14%">
					<!-- <col style="width:8%"> -->
					<!-- <col style="width:6%"> -->
					<!-- <col style="width:10%"> -->
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
			<div class="btn_wrap_type05"><!--
			--><button type="button" id="resultBtn" class="btn_type03" data-dismiss="modal" aria-label="Close">확인</button><!--
		--></div>
		</div>
	</div>
</div>


<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit">사이트 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="tx_inp_type"><input type="text" name="confirm_site" id="confirmSite" placeholder="사이트 이름 입력"/></div>
			</div>
			<div class="btn_wrap_type05"><!--
				--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn_type w80 ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>


<div class="modal fade stack" id="alarmDeleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="alarmDeleteSuccessMsg" class="ntit">알람 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;을 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="tx_inp_type"><input type="text" name="confirm_alarm" id="confirmAlarm" placeholder="장치명 입력"/></div>
			</div>
			<div class="btn_wrap_type05"><!--
				--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="alarmDeleteConfirmBtn" class="btn_type w80 ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>



<div class="modal fade" id="addAlarmModal" tabindex="-1" role="dialog" aria-labelledby="addAlarmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-xl">
		<div class="modal-content site-modal-content">
			<div class="modal-header flex_start"><h1>알람 등록/수정</h1><button type="button" class="btn-add ml-20" onclick="insertRowCopy()">추가</button></div>
			<div class="modal-body mt10">
				<form name="add_alarm_form" id="updateAlarmForm">
					<table id="alarmTable" class="no-stripe">
						<colgroup>
							<!-- <col style="width:4%"> -->
							<col style="width:18%">
							<col style="width:18%">
							<col style="width:6%">
							<col style="width:20%">
							<col style="width:22%">
							<col style="width:8%">
							<col style="width:8%">
						</colgroup>
						<thead></thead>
						<tbody></tbody>
					</table>
					<div class="btn_wrap_type05"><!--
					--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
					--><button type="submit" class="btn_type w80 ml-12">추가</button><!--
				--></div>
				</form>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog" aria-labelledby="addSiteModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-custom-xl">
		<div class="modal-content site-modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1>사업소 추가<span class="required px-4 fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사업소 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_site_form" id="updateSiteForm" class="setting-form">
						<section id="sectionSiteInfo">
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">사업소 명</span></div>
								<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex_start">
										<div class="tx_inp_type offset-73">
											<input type="text" name="new_site_name" id="newSiteName" placeholder="입력" minlength="2" maxlength="15">
										</div>
										<button type="button" class="btn_type fr" onclick="checkSiteId($('#newSiteName').val())" disabled>중복 체크</button>
									</div>
									<small class="hidden warning">추가하실 사이트를 입력해 주세요</small>
									<small class="hidden warning">2~15 글자를 입력해 주세요.</small>
									<small class="hidden warning">특수 문자는 포함될 수 없습니다.</small>
									<small id="invalidSite" class="hidden warning">이미 등록되어 있는 사이트 입니다.</small>
									<small id="validSite" class="text-blue text-sm hidden">추가 가능한 사이트 입니다.</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">사업소 유형</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newSiteType" class="dropdown-menu"></ul>
									</div>
									<small class="hidden warning">사업소 유형을 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">발전원</span></div>
								<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newResList" class="dropdown-menu"></ul>
									</div>
									<small class="hidden warning">발전원 옵션을 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">ESS 유무</span></div>
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
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">사업소재지</span></div>
								<div class="col-xl-6 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex_start">
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
										<div class="tx_inp_type w-100"><input type="text" name="new_street_addr" id="newStreetAddr" placeholder="입력" minlength="3" maxlength="28"></div>
									</div>
									<small class="hidden warning">사업소재지를 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">위경도</span></div>
								<div class="col-xl-4 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" name="new_coord" id="newCoord" placeholder="예) 35.9078, 127.7669" minlength="3" maxlength="28"></div>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">추가 정보</span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<textarea name="new_site_desc" id="newSiteDetail" class="textarea" placeholder="입력"></textarea>
								</div>
							</div>

							<c:if test="${fn:contains(sessionScope.userInfo.oid, 'kpx')}">
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">발전기 코드</span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex_start">
											<div class="tx_inp_type">
												<input type="text" name="kpx_genid" id="kpx_genid" placeholder="입력" minlength="2" maxlength="15">
											</div>
										</div>
									</div>
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">모선 전압</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="flex_start">
											<div class="tx_inp_type">
												<input type="text" name="kpx_transvol" id="kpx_transvol" placeholder="입력" minlength="2" maxlength="15">
											</div>
										</div>
									</div>
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">EMS 코드</span></div>
									<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex_start">
											<div class="tx_inp_type">
												<input type="text" name="kpx_emsid" id="kpx_emsid" placeholder="입력" minlength="2" maxlength="100">
											</div>
										</div>
									</div>
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">기상 그리드</span></div>
									<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="flex_start">
											<div class="tx_inp_type">
												<input type="text" name="station_id" id="station_id" placeholder="입력" minlength="1" maxlength="15">
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</section>

						<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
							<section id="sectionPowerBillInfo">
								<h2 class="stit">전력 구매 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">계약 종별</span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex_start">
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newContractList" class="dropdown-menu"></ul>
											</div>
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택" disabled>선택<span class="caret"></span></button>
												<ul id="newVoltTypeList" class="dropdown-menu"></ul>
											</div>
										</div>
										<small id="newVoltWarning" class="hidden warning">계약종별 상세 옵션을 선택해 주세요.</small>
									</div>
									
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">계약 전력</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="tx_inp_type"><input type="text" name="new_peak_demand" id="newPeakDemand" class="pr-36" placeholder="입력" maxlength="10"><span class="unit">kW</span></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">요금 적용<br>전력</span></div>
									<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="tx_inp_type"><input type="text" name="new_dr_charge" id="newDrCharge" class="pr-36" placeholder="입력" maxlength="10"><span class="unit">kW</span></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">검침일</span></div>
									<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newInspection" class="dropdown-menu"></ul>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">한전<br>고객번호</span></div>
									<div class="col-xl-3 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="tx_inp_type"><input type="text" name="new_kepco_id" id="newKepcoId" placeholder="입력" maxlength="18"></div>
									</div>

									<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input_label offset-top">iSMART<br>아이디</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="tx_inp_type"><input type="text" name="new_smart_id" id="newISmartId" placeholder="입력" maxlength="18"></div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">iSMART<br>비밀번호</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="tx_inp_type"><!--
										--><input type="password" name="new_smart_pwd" id="newISmartPwd" placeholder="입력" maxlength="18"><!--
										--><button type="button" class="pwd-icon" onclick="showPwd('newISmartPwd', this)">show</button><!--
									--></div>
									</div>
								</div>
							</section>
							<section id="sectionPowerMarketInfo">
								<h2 class="stit">매전 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">정상 단가</span></div>
									<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
										<div class="flex_start">
											<div class="dropdown w-100">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="newPriceModelList" class="dropdown-menu">
													<li data-name="고정가" data-value="fixed"><a href="#">고정가</a></li>
													<li data-name="SMP평균" data-value="SMP_mean"><a href="#">SMP평균</a></li>
													<li data-name="SMP" data-value="SMP"><a href="#">SMP</a></li>
												</ul>
											</div>
											<div class="tx_inp_type hidden"><input type="text" name="Price" id="newPrice" placeholder="입력" maxlength="8"></div>
										</div>
									</div>
								</div>
							</section>

							<section id="sectionDRInfo">
								<h2 class="stit">DR 거래 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">자원 ID</span></div>
									<div class="col-xl-3 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newDrResIdList" class="dropdown-menu"></ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input_label">계약용량</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="tx_inp_type">
											<input type="text" name="dr_vol" id="drVol" class="pr-36" placeholder="입력" maxlength="8"><span class="unit">kW</span>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">CBL 계산식</span></div>
									<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="cblList" class="dropdown-menu">
												<li data-value="max45"><a href="#">max45</a></li>
												<li data-value="mid68"><a href="#">mid68</a></li>
											</ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">수익 분배율</span></div>
									<div class="col-xl-1 col-lg-3 col-md-4 col-sm-10 pl-0">
										<div class="tx_inp_type"><input type="text" name="dr_rev_share" id="newDrRevShare" class="pr-36" placeholder="입력" maxlength="3"><span class="unit">%</span></div>
									</div>
								</div>
							</section>

							<section id="sectionVppInfo">
								<h2 class="stit">중개 거래 정보</h2>
								<div class="row">
									<div class="col-xl-1 col-lg-2 col-sm-2"><span class="input_label">자원 ID</span></div>
									<div class="col-xl-3 col-lg-3 col-sm-4 pl-0">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newVppResIdList" class="dropdown-menu"></ul>
										</div>
									</div>

									<div class="col-xl-1 col-lg-2 col-sm-2"><span class="input_label">수익 분배율</span></div>
									<div class="col-xl-2 col-lg-2 col-sm-4 pl-0">
										<div class="tx_inp_type">
											<input type="text" name="vpp_rev_share" id="newVppRevShare" class="pr-36" placeholder="입력" maxlength="3"><span class="unit">%</span>
										</div>
									</div>
								</div>
							</section>
						</c:if>

						<div class="row">
							<div class="col-12">
								<div class="btn_wrap_type02">
									<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addSiteBtn" class="btn_type" disabled>추가</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
