<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		// let l = "${location}"
		// console.log("location---", l);
		let siteList = JSON.parse('${siteList}');

		if(role == 1){
			readWriteTable(siteList);
		} else {
			getUserSites(siteList);
		}

		getPropertyData();
		getVppDrData();

		// Validation
		$("#newSiteName").on('keydown', function() {
			$("#invalidSite").addClass("hidden");
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
			if( $(this).val().match(/[^\x00-\x80]/) ){
				$(this).val("");
			}
		});

		$("#newCoord").on('input', function(e) {
			var re = /^[0-9] + (?:\,[0-9]+)*$/;
			var isvalid = re.test($(this).value);
			if(isvalid == false){
				console.log("no match---")
			}
			// $(this).val($(this).val().replace(/\s/g, ''));
		});

		$("#updateSiteForm").on("change", function(){
			if(!$(this).is(".edit")){
				validateForm();
			}
		});

		// Dropdown Click event
		$("#newResList li").on("click", function(){
			console.log("newResList---",$("#newResList").prev().data("value"))
			setTimeout(function(){
				validateForm();
			}, 300);
		});

		$("#newCityList li").on("click", function(){
			console.log("newCityList---",$("#newCityList").prev().data("value"))
			setTimeout(function(){
				validateForm();
			}, 300);
		});

		// Modal event
		$("#addSiteModal").on("hide.bs.modal", function() {
			console.log("addSiteModal===", $(this));
			$(this).hasClass("edit") ? $(this).removeClass("edit") : null;
		});

		$("#deleteConfirmBtn").click(function(){
			let modalBody = $("#deleteConfirmModal .modal-body");

			let dTable = $("#siteTable").DataTable();
			let tr = $("#siteTable").find("tbody tr.selected");
			let sid = dTable.row(tr).data().sid;

			let optDelete = {
				url: apiHost + "/config/sites/" + sid,
				type: "delete",
				async: true,
			}
			modalBody.addClass("hidden");
			$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
				console.log("success==", json)
				$("#deleteSuccessMsg").text("사이트가 삭제 되었습니다.").removeClass("hidden");
				refreshSiteList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
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
			$(this).find(".modal-body").removeClass("hidden");
			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#confirmSite").val("");
		});

		$("#alarmDeleteConfirmBtn").click(function(){
			let modalBody = $("#alarmDeleteConfirmModal .modal-body");

			let dTable = $("#siteTable").DataTable();
			let tr = $("#siteTable").find("tbody tr.selected");
			let sid = dTable.row(tr).data().sid;

			let optDelete = {
				url: apiHost + "/config/sites/" + sid,
				type: "delete",
				async: true,
			}
			modalBody.addClass("hidden");
			$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
				console.log("success==", json)
				$("#deleteSuccessMsg").text("사이트가 삭제 되었습니다.").removeClass("hidden");
				refreshAlarmList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
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
			$(this).find(".modal-body").removeClass("hidden");
			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#confirmSite").val("");
		});

		$("#resultModal").on("hide.bs.modal", function() {
			$(this).find("h4").addClass("hidden");
		});

		// Form Submission
		$("#updateSiteForm").on("submit", function(e){
			e.preventDefault();

			let newSiteName = $("#newSiteName").val();
			let newResType = Number($("#newResList").prev().data("value"));
			let newCity = $("#newCityList").prev().data("value");

			let newSiteType = Number($("#newSiteType").prev().data("value"));
			let newSiteTypeName = $("#newSiteType").prev().data("name");

			let newEssList = Number($("#newEssList").prev().data("value"));
			let newStreetAddr= $("#newStreetAddr").val();
			let newCoord = $("#newCoord").val();
			let newSiteDetail = $("#newSiteDetail").val();
			// Utility
			let newUtilObj = {}
			let newUtilPlan = $("#newContractList").prev().data("value");
			let newVolRange = $("#newVoltList").prev().data("value");
			let newPeakDemand = Number($("#newPeakDemand").prev().data("value"));
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

			// 1. ADD a Site
			if(!$("#addSiteModal").hasClass("edit")) {
				siteObj.name = newSiteName;
				siteObj.location = newCity;
				siteObj.resource_type = newResType;

				if( !isEmpty(newSiteType)){
					siteObj.ess = newSiteType;
				}
				if( !isEmpty(newCoord) ){
					siteObj.latlng = newCoord;
				}

				siteObj.tz = "Asia/Seoul";

				if( !isEmpty(newStreetAddr)){
					siteObj.address = newStreetAddr;
				}
				if( !isEmpty(newSiteDetail)){
					siteObj.detail_info = newSiteDetail;
				}
				if( !isEmpty(newDrResId) ){
					siteObj.dr_group_id = newDrResId;
				}
				if( !isEmpty(newVppResId) ){
					siteObj.dr_group_id = newVppResId;
				}

				// Util JSON
				if( !isEmpty(newUtilPlan)){
					if(isEmpty(newVolRange)){
						newUtilObj.utility_plan_id = newUtilPlan;
					} else {
						newUtilObj.utility_plan_id = newUtilPlan + ',' + newVolRange;
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

				// Util JSON
				if( !isEmpty(newUtilPlan)){
					if(isEmpty(newVolRange)){
						newUtilObj.utility_plan_id = newUtilPlan;
					} else {
						newUtilObj.utility_plan_id = newUtilPlan + ',' + newVolRange;
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


		$("#addAlarmForm").on("submit", function(e){
			e.preventDefault();
			let arr = [];
			let tr = $("#alarmTable tbody tr");
			console.log("tr==", tr);
			$.each(tr, function(index, el){
				if(!tr.hasClass("disabled")){
					let obj = {};
					let dropdown = el.find(".dropdown-toggle");
					let input = el.find("input[type='text']");

					obj.device_type = dropdown.eq(0).data("value");
					obj.name = dropdown.eq(1).data("value");
					obj.level = dropdown.eq(2).data("value");
					obj.person = dropdown.eq(3).data("value");
					obj.phone = input.val();
				}

			});

		});

		// Get Ajax Data
		function getUserSites(){
			let option = {
				url: apiHost + "/auth/me",
				type: "get",
				async: true,
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				readOnlyTable(json.user_sites);
			}).fail(function(){
				return ;
			})
		}

		function refreshSiteList(){
			let option = {
				url: apiHost + "/auth/me/sites",
				type: "get",
				async: true,
			}
			$('#siteTable').DataTable().clear().destroy();
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				readWriteTable(json, updateModal);
			}).fail(function(){
				return;
			})
		}

		function readWriteTable(siteList, callback) {
			// console.log("siteList===", siteList);
			if(siteList) {
				let newArr = [];
				Promise.resolve(siteList.map((item, index) => {
					let rawDataOpt = {
						url: apiHost + "/status/raw/site",
						type: 'get',
						async: false,
						data:{
							sid: item.sid,
							formId: 'v2'
						}
					}

					$.ajax(rawDataOpt).done(function (json, textStatus, jqXHR) {
						if(isEmpty(item.ess) || item.ess == 0){
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
							item.siteType = "수요자원 (Demand)"
							item.powerSource = "부하"
						} else {
							item.siteType = "발전소 (Generation)"
							if(item.resource_type === 1){
								item.powerSource = "태양광"
							} else if(item.resource_type === 2){
								item.powerSource = "풍력"
							} else if(item.resource_type === 3){
								item.powerSource = "소수력"
							}
						}
						if(!isEmpty(item.dr_group_id)){
							item.drId = item.dr_group_id;
						} else {
							item.drId = "-"
						}

						if(!isEmpty(item.vpp_group_id)){
							item.vppId = item.vpp_group_id;
						} else {
							item.vppId = "-"
						}
						// console.log("rawDataOpt---", rawDataOpt);
					
						let deviceOpt = {
							url: apiHost + "/config/devices?"+'oid='+oid,
							type: 'get',
							async: false,
							data:{
								sid: item.sid
							}
						}
						$.when(makeAjaxCall(deviceOpt)).done(function(res) {
							if(!isEmpty(res)) {
								item.deviceAlarm = "1";
								item.alarmData = res;
							} else {
								item.deviceAlarm = "0";
								item.alarmData = "no-device";
							}
						});
						
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
						newArr.push(item);
					}).fail(function (jqXHR, textStatus, errorThrown) {
						console.log("error====", jqXHR);
						return;
					});
				})).then(() => {
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
						// "bAutoWidth": true,
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
						// "order": [[ 1, 'asc' ]],
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
						],
						"aoColumns": [
							{
								"sTitle": "",
								"mData": "null",
								// "mRender": function ( data, type, row, rowIndex )  {
									"mRender": function ( data, type, full, rowIndex )  {
						
									// console.log("DT_RowId---", full)
									return '<a class="chk_type" href="#"><input type="checkbox" id="' + rowIndex + '" name="table_checkbox"><label for="' + rowIndex + '"></label></a>'
								},
								"className": "dt-body-center no-sorting"
							},
							// {
							// 	"sTitle": "순번",
							// 	"mData": null,
							// 	"className": "dt-center idx no-sorting"
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
								"mData": "drId",
							},
							{
								"sTitle": "VPP 자원코드",
								"mData": "vppId",
							},
							{
								"sTitle": "알람 수신",
								"mData": "null",
								"mRender": function ( data, type, row )  {
									return '<button type="button" class="btn-type-sm btn_type03">알람</button>'
								},
							},
						],
						"dom": 'tip',
						"select": {
							style: 'single',
							// selector: 'tr',
							selector: 'td input[type="checkbox"], td:not(:last-of-type)',
						},
						initComplete: function(settings, json ){
							let str = `<div id="btnGroup" class="right-end"><!--
								--><button type="button" disabled class="btn_type03" onclick="updateModal('edit')">선택 수정</button><!--
								--><button type="button" disabled class="btn_type03" onclick="updateModal('delete')">선택 삭제</button><!--
							--></div>`;

							let addBtnStr = `<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>`;

							$("#siteTable_wrapper").append($(str)).prepend($(addBtnStr));
						},
						createdRow: function (row, data, dataIndex){
							// $(row).attr({
							// 	'data-sid': data.sid,
							// });
		
							if(data.deviceAlarm == "0"){
								// console.log("data---", newArr[dataIndex].alarmData );
								let btn = $(row).find(".btn-type-sm");
								btn.prop("disabled", true);
							}
						},
						// every time DataTables performs a draw
						drawCallback: function (settings) {
							selectRow(this);
							$('#siteTable_wrapper').addClass('mb-28');
						},
						// rowCallback: function ( row, data ) {
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
					}).columns.adjust().draw();

					if(callback) {
						callback();
					}

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

					// $("#siteTable").on( 'click', 'tr', function (e, dt, data, row) {
					// 	var id = siteTable.row( this ).id();
					// 	console.log("this--", id);
					// });

					siteTable.on( 'click', 'td .btn-type-sm', function () {
						let idx = siteTable.row($(this).parents().closest("tr")).index();
						let rowData = siteTable.row($(this).parents().closest("tr")).data().alarmData;

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
				});

			}
		}

// function addAlarmClickEvent(){

// }
		function readOnlyTable(siteList, callback) {
			if(siteList){
				let newArr = [];
				Promise.resolve(siteList.map((item, index) => {
					let found = userSite.findIndex( x => x.sid == item.sid);
					if(found > -1){
						// console.log("user---", userSite[found]);
						// console.log("item===", item);
						item.userInfo = {
							permission : ( userSite[found].role == 1) ? "수정/조회" : "조회",
							role: userSite[found].role,
							usid : userSite[found].usid,
							uid : userSite[found].uid
						}
						let rawDataOpt = {
							url: apiHost + "/status/raw/site",
							type: 'get',
							async: false,
							data:{
								sid: item.sid,
								formId: 'v2'
							}
						}
						$.ajax(rawDataOpt).done(function (json, textStatus, jqXHR) {
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

							if(isEmpty(item.ess) || item.ess == 0){
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
								item.siteType = "Demand"
								item.powerSource = "부하"
							} else {
								item.siteType = "Generation"
								if(item.resource_type === 1){
									item.powerSource = "태양광"
								} else if(item.resource_type === 2){
									item.powerSource = "풍력"
								} else if(item.resource_type === 3){
									item.powerSource = "소수력"
								}
							}
							if(!isEmpty(item.dr_group_id)){
								item.drId = item.dr_group_id;
							} else {
								item.drId = "-"
							}

							if(!isEmpty(item.vpp_group_id)){
								item.vppId = item.vpp_group_id;
							} else {
								item.vppId = "-"
							}

							newArr.push(item);
						}).fail(function (jqXHR, textStatus, errorThrown) {
							console.log("error====", jqXHR);
							return;
						});
					}
				})).then(function(){
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
						// "bAutoWidth": true,
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
						// "order": [[ 1, 'asc' ]],
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
						],
						"aoColumns": [
							{
								"sTitle": "순번",
								"mData": null,
								"className": "dt-center idx no-sorting"
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
								"mData": "drId",
							},
							{
								"sTitle": "VPP 자원코드",
								"mData": "vppId",
							},
							{
								"sTitle": "알람 수신",
								"mData":"null",
								"mRender": function ( data, type, row )  {
									return '<button type="button" class="btn-type-sm btn_type03">알람</button>'
								},
							},
						],
						"language": {
							"emptyTable": "조회된 데이터가 없습니다."
						},
						"dom": 'tip',
						"select": {
							style: 'single',
							// selector: 'td:first-child > a',
						},
						initComplete: function(){
							this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
								cell.innerHTML = i+1;
								$(cell).data("id", i);
							});
						},
						createdRow: function (row, data, dataIndex){
						},
						// every time DataTables performs a draw
						drawCallback: function () {
							selectRow(this);
						},
					}).columns.adjust().draw();
					

					siteTable.on( 'order.dt search.dt', function () {
						siteTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
							cell.innerHTML = i+1;
							$(cell).data("id", i)
						});
					}).draw();

					siteTable.on( 'column-sizing.dt', function ( e, settings ) {
						$(".dataTables_scrollHeadInner").css( "width", "100%" );
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
				});
			} else {
				drawEmptyTable($("#siteTable"))
			}
		}


		function drawEmptyTable(target){
			console.log("target---", target)
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
						"className": "dt-center idx no-sorting"
					},
					{
						"title": "사업소 유형",
						"data": "null",
					},
					{
						"title": "사업소 명",
						"data": "null"
					},
					{
						"title": "지역",
						"data": "null",
					},
					{
						"title": "발전 자원",
						"data": "null",
					},
					{
						"title": "발전 용량",
						"data": "null",
					},
					{
						"title": "ESS 용량 (PCS)",
						"data": "null",
					},
					{
						"title": "ESS 용량 (BMS)",
						"data": "null",
					},
					{
						"title": "DR 자원 코드",
						"data": "null",
					},
					{
						"title": "VPP 자원코드",
						"data": "null",
					},
					{
						"title": "알람 수신",
						"data": "null",
					},
				],
				"dom": 'tip',
				"language": {
					"emptyTable": "조회된 데이터가 없습니다."
				},
				initComplete: function(){
					console.log("this---", this)
					this.addClass("stripe")
				},
			});
		}

		function getPropertyData() {
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
			let str = ``;

			$.ajax(optionContract).done(function (json, textStatus, jqXHR) {
				const contractList = $("#newContractList");
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
					let v = '';
					if(!isEmpty(item[1].voltRange)){
						v = item[1].voltRange.replace(/,\s*$/, "")
					} else {
						v = item[1].voltRange
					}
					let id = item[1].planId.replace(/,\s*$/, "");
					let util = item[1].utilName.replace(/,\s*$/, "");

					cStr += `
						<li data-util-name="${'${util}'}" data-plan-id="${'${id}'}" data-vol-type="${'${v}'}" data-value="${'${item[0]}'}"><a href="#">${'${item[0]}'}</a></li>
					`;
				});
				contractList.append(cStr);

				contractList.find("li").on("click", function(){
					let val = $(this).data("value");
					let subOpt = $("#newVoltList");
					let btn = subOpt.prev();

					subOpt.empty().prev().data("value", "").html("선택<span class='caret'></span>");

					if(!isEmpty($(this).data("vol-type"))){
						let str = '';
						let idArr = [...$(this).data("plan-id").split(",")];
						let vArr = [...$(this).data("vol-type").split(",")];
						let utilArr = [...$(this).data("util-name").split(",")];

						if(btn.is(":disabled")){
							btn.prop("disabled", false)
						}
						for(let i=0, length = vArr.length; i<length; i++){
							str += `<li data-util-name="${'${utilArr[i]}'}" data-id="${'${idArr[i]}'}" data-value="${'${vArr[i]}'}"><a href="#">${'${vArr[i]}'}</a></li>`;
						}
						subOpt.append(str);
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
					// console.log("el===", el)
					resStr += `
						<li data-name-kr="${'${el.name.kr}'}" data-name="${'${el.name.en}'}" data-value="${'${el.code}'}"><a href="#">${'${el.name.kr}'}</a></li>
					`
				});

				$("#newResList").append(resStr);
				$("#resTypeList").append(resStr).prepend(allStr);

				$("#resTypeList li").on("click", function(){
					if(!isEmpty($(this).data("value"))){
						filterColumn( "#siteTable", "4", $(this).data("name-kr"));
					} else {
						filterColumn("#siteTable", "4", "");
					}
				});

				$.each(s, function(index, el){
					if(el.code == "gen"){
						siteStr += `
							<li data-name="${'${el.name.en}'}" data-value="1" class="on"><a href="#">${'${el.name.kr}'} (` + `${'${el.name.en}'}` + `)</a></li>
						`;
					} else if(el.code == "demand"){
						siteStr += `
							<li data-name="${'${el.name.en}'}" data-value="0" class="on"><a href="#">${'${el.name.kr}'} (` + `${'${el.name.en}'}` + `)</a></li>
						`;
					}

				});

				$("#newSiteType").append(siteStr);
				$("#siteType").append(siteStr).prepend(allStr);


				$("#newSiteType li").on("click", function() {
					let val = $(this).data("value");
					let items = $("#newResList").find("li");
					if(val == "0") {
						items.eq(0).removeClass("hidden").siblings().addClass("hidden");
					} else {
						items.eq(0).addClass("hidden").siblings().removeClass("hidden");
					}
				});

				$("#siteType li").on("click", function(){
					if(!isEmpty($(this).data("value"))){
						filterColumn( "#siteTable", "1", $(this).data("name"));
					} else {
						filterColumn("#siteTable", "1", "");
					}
				})
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("site_type Error:", jqXHR)
			});

			$("#countryList li").on("click", function(){
				if(!isEmpty($(this).data("id"))){
					filterColumn( "#siteTable", "3", $(this).data("id"));
				} else {
					filterColumn("#siteTable", "3", "");
				}
			});

			for(let i=0, length = 28; i<length; i++){
				str += `
					<li data-value="${'${i+1}'}"><a href="#">${'${i+1}'}</a></li>
				`;
			}
			str += `<li data-value="0"><a href="#">말일</a></li>`
			$("#newInspection").append($(str));
		}


		function getVppDrData() {
			let drOption = {
				url: apiHost + "/config/dr-groups?oid="+oid,
				type: 'get',
				async: true
			};

			let vppOption = {
				url: apiHost + "/config/vpp-groups?oid="+oid,
				type:'get',
				async: true
			}

			$.when($.ajax(drOption), $.ajax(vppOption)).done(function (result1, result2) {
				let newDrResIdList = $("#newDrResIdList");
				let newVppResIdList = $("#newVppResIdList");
				// 	$("#newDrResIdList").empty();
				// $("#newVppResIdList").empty();

				newDrResIdList.empty();
				newVppResIdList.empty();

				if(!isEmpty(result1[0])) {
					console.log("1---", result1[0])
					let str = '';
					$.each(result1[0], function(index, element) {
						if(!isEmpty(element.resourceId)) {
							str += '<li data-value="' + element.dgid + '"><a href="#" tabindex="-1">' + element.resourceId + '<span class="res-name">' + element.name +  '</a></span></li>'
						} else {
							str += '<li data-value="' + element.dgid + '"><a href="#" tabindex="-1"><span class="res-name">' + element.name +  '</span></a></li>'
						}
					});
					newDrResIdList.append(str);
					$("#newDrResIdList").append(str);

					$("#sectionDRInfo input").each(function(){
						$(this).prop('disabled', false);
					});
					$("#cblList").prev().prop("disabled", false);
				} else {
					newDrResIdList.prev().html("등록된 DR거래 자원 ID가 없습니다.<span class='caret'></span>").prop("disabled", true);
					$("#sectionDRInfo input").each(function(){
						$(this).prop('disabled', true);
					})
					$("#cblList").prev().prop("disabled", true);
				}


				if(!isEmpty(result2[0])) {
					let str = '';
					$("#newVppRevShare").prop('disabled', false);
					$.each(result2[0], function(index, element) {
						if(!isEmpty(element.resourceId)) {
							str += '<li data-value="' + element.vgid + '"><a href="#" tabindex="-1">' + element.resourceId + '<span class="res-name">' + element.name +  '</a></span></li>'
						} else {
							str += '<li data-value="' + element.vgid + '"><a href="#" tabindex="-1"><span class="res-name">' + element.name +  '</span></a></li>'
						}
					});

					newVppResIdList.append(str);
					$("#newVppResIdList").append(str);
				} else {
					newVppResIdList.prev().html("등록된 중개거래 자원 ID가 없습니다.<span class='caret'></span>").prop("disabled", true);
					$("#newVppRevShare").prop('disabled', true);
				}
			});
		
			let dropdown = $("#addSiteModal").find(".dropdown-menu");
			setDropdownValue(dropdown);
		}

		// let p = JSON.parse(sList);
		// console.log("p---", sList);
		// $.each(p, function(index, element){
		// 	console.log("elemet---", element)
		// });

		// var table = $('#siteTable').DataTable({
		// 	// "fixedHeader": true
		// });

		// new $.fn.dataTable.FixedHeader( table, {
		// 	alwaysCloneTop: true
		// });

	});


	function updateModal(option, callback){
		// RPS(Renewable Portfolio Standard), SMP(System Marginal Price), REC(Renewable Energy Certificate) => subsidies
		let titleAdd = $('#titleAdd');
		let newSiteName = $('#newSiteName');
		let required = $("#updateSiteForm").find(".asterisk");
		let addBtn = $("#addSiteBtn");

		if(isEmpty(option)) {
			let form = $("#updateSiteForm");
			let input = form.find("input");
			let dropdown = form.find(".dropdown-toggle");
			let warning = form.find(".warning");

			$("#validSite").addClass("hidden");
			$("#addSiteBtn").prop("disabled", true);
			$("#newResList li").removeClass("hidden");

			warning.addClass("hidden")
			input.val("");

			$.each(dropdown, function(index, element){
				$(this).html('선택' + '<span class="caret"></span>');
				$(this).data("value", "");
			});
		} else {
			// ADD MODAL!!!
			if(option == "add"){
				if(newSiteName.parent().next().hasClass("hidden")) {
					newSiteName.parent().next().removeClass("hidden");
					newSiteName.parent().addClass("offset-width").removeClass("w-100");
				}
				titleAdd.removeClass("hidden").next().addClass("hidden");
				required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
				addBtn.text("등록");
				$('#newSiteName').prop('disabled', false);
				$("#addSiteModal").removeClass("edit").modal("show");
			} else {
				let dTable = $("#siteTable").DataTable();
				let tr = $("#siteTable").find("tbody tr.selected");
				let td = tr.find("td");
				let sid = dTable.row(tr).data().sid;

				console.log("sid---", sid );

				$("#validSite").is(".hidden") ? null : $("#validSite").addClass("hidden");

				// EDIT MODAL!!!
				if(option == "edit") {
					let optSite = {
						url: apiHost + "/config/sites/" + sid,
						type: "patch",
						async: true,
						contentType: 'application/json; charset=UTF-8',
					}
					let t = $("siteTable").DataTable();

					addBtn.prop("disabled", false).text("수정");
					
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
					// 사업소 유형
					$('#newSiteType').prev().data({"name": td.eq(1).text(), "value" : td.eq(1).data("value") }).html(td.eq(1).text() + "<span class='caret'></span>");
					// 발전 자원
					$("#newResList").prev().data({"name": td.eq(4).text(), "value" : td.eq(4).data("value") }).html(td.eq(4).text() + "<span class='caret'></span>");

					// 발전 용량
					if( td.eq(5).text() != '-' ) {
						$('#newEmailAddr').val(td.eq(5).text())
					}
					// ESS (PCS)
					if( td.eq(6).text() != '0'){
						$('#newAffiliation').val(td.eq(6).text());
					}
					// ESS (BMS)
					if( td.eq(7).text() != '0'){
						$('#newAffiliation').val(td.eq(6).text());
					}
					// DR info
					if( td.eq(8).text() != '-') {
						$('#newInspection').prev().data("value", td.eq(9).text()).html(td.eq(9).text() + '<span class="caret">');
					} else {
						$('#newInspection').prev().data("value", "").html('선택<span class="caret">');
					}
					// VPP info
					if( td.eq(9).text() != '-' ) {
						$('#newContractList').prev().data("value", td.eq(9).text() ).html(td.eq(9).text() + '<span class="caret">');
					} else {
						$('#newContractList').prev().data("value", "").html('선택<span class="caret">');
					}
					$("#addSiteModal").addClass("edit").modal("show");
				}
				// DELETE MODAL!!!
				if(option == "delete") {
					let siteName = td.eq(2).text();
					$("#deleteSuccessMsg span").text(siteName);
					$("#deleteConfirmModal").modal("show");

					$("#confirmSite").on("keyup", function() {
						if($(this).val() != siteName) {
							return false
						} else {
							$("#deleteConfirmBtn").prop("disabled", false);
						}
					});
				}
			}
		}
	}


		// JSON.parse(dv.alarm_to);

			
		// smsUserCnt
		// dv.device_type
		// eviceProperties[dv.device_type].name.kr
		// dv.did
		// dv.name
		// user.level
		// levelTemplate[user.level]
		// user.uid
		// user.phone



	function getAlarmTable(alarmData, userData){
		let arr = [];
		let deviceList = [];
		// console.log("userData---", userData)
		Promise.resolve(alarmData.map( (x, index) => {
			let sendTo = x.alarm_to;
			// console.log("x==", x);
			if(!isEmpty(sendTo)){
				console.log("sendTo==", sendTo);
				let userList = sendTo.user_id;
				let	nonUserList = sendTo.non_user;

				if(!isEmpty(userList)){
					userList.map( x => {

					});
				}

				if(!isEmpty(nonUserList)){
					nonUserList.map( x => {

					});
				}
			} else {
				let obj = {};
				obj.index = index + 1;
				// device type
				if(isEmpty(x.device_type)){
					obj.device_type = "-";
				} else {
					obj.device_type = x.device_type;
					deviceList.push(x.device_type);
				}
				// device name
				if(isEmpty(x.name)){
					obj.name = "-";
				} else {
					obj.name = x.name;
				}
				// alarm level
				obj.level = 0;
				// contact person User Id
				obj.uid = "";
				// contact person phone number
				obj.phone = "";

				obj.createdAt = x.createdAt;
				obj.did = x.did;

				arr.push(obj);
			}
		})).then( () => {
			var alarmTable = $('#alarmTable').DataTable({
				"aaData": arr,
				"retrieve": true,
				// "fixedHeader": true,
				"bAutoWidth": true,
				// "ScrollX": true,
				// "sScrollX": "110%",
				// "sScrollXInner": "110%",
				// "sScrollY": false,
				// "scrollY": false,
				// "bScrollCollapse": false,
				"bSearchable" : true,
				"pageLength": 10,
				// "aoColumnDefs": [
				// {
				// 	"aTargets": [ 0 ],
				// 	"bSortable": false,
				// 	"orderable": false
				// },
				// 	{
				// 		"aTargets": [ 0, 1, 2, 3, 4, 5, 6 ],
				// 		"bSortable": false,
				// 		"orderable": false
				// 	},
				// ],
				"aoColumns": [
					// {
					// 	"sTitle": "순번",
					// 	"mData": "null",
					// 	"className": "dt-center idx no-sorting"
					// },
					{
						"sTitle": "설비타입",
						"mData": "null",
						"mRender": function ( data, type, row, rowIndex ) {
							let str1 = ``;
							let filteredDvcList = deviceList.filter((a, b) => deviceList.indexOf(a) === b);

							$.each(filteredDvcList, function(index, el){
								str1 += `
									<li data-value="${'${el}'}"><a href="#" tabindex="-1">${'${el}'}</a></li>
								`
							});
							let dropdown1 = `
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" disabled data-toggle="dropdown" data-value="${'${row.device_type}'}">${'${row.device_type}'}<span class="caret"></span></button>
									<ul id="aDvcList${'${row.index}'}" class="dropdown-menu">${'${ str1 }'}</ul>
								</div>
							`;
							return dropdown1;
						},
						"className": "no-sorting",
						"width": "18%"
					},
					{
						"sTitle": "설비명",
						"mData": "null",
						"mRender": function ( data, type, row, rowIndex ) {
							let str2 = ``;
							$.each(arr, function(index, el){
								str2 += `
									<li data-value="${'${el.name}'}"><a href="#" tabindex="-1">${'${el.name}'}</a></li>
								`
							});
							let dropdown2 = `
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" disabled data-toggle="dropdown" data-value="${'${row.name}'}">${'${row.name}'}<span class="caret"></span></button>
									<ul id="aDvcNameList${'${row.index}'}" class="dropdown-menu">${'${ str2 }'}</ul>
								</div>
							`;
							return dropdown2;
						},
						"className": "no-sorting",
						"width": "18%"
					},
					{
						"sTitle": "알람레벨",
						"mData": "null",
						"mRender": function ( data, type, row, rowIndex ) {
							let str3 = ``;
							let aLevelOpt = [
								{  name : "정보", val: 0 },
								{  name : "경고", val: 1 },
								{  name : "이상", val: 2 },
								{  name : "트립", val: 3 },
								{  name : "긴급", val: 4 },
								{  name : "알수 없음", val: 9 },
							];
					

							$.each(aLevelOpt, function(index, el){
								str3 += `
									<li data-name="${'${el.name}'}" data-value="${'${el.val}'}"><a href="#" tabindex="-1">${'${el.name}'}</a></li>
								`
							});

							let dropdown3 = `
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" disabled data-toggle="dropdown" data-value="${'${row.level}'}" data-name="${'${aLevelOpt[row.level].name}}'}">${'${aLevelOpt[row.level].name}'}<span class="caret"></span></button>
									<ul id="aDvcNameList${'${row.index}'}" class="dropdown-menu">${'${ str3 }'}</ul>
								</div>
							`;


							return dropdown3;
						},
						"className": "no-sorting",
						// "width": "18%"
					},
					{
						"sTitle": "담당자",
						"mData": "null",
						"mRender": function ( data, type, row, rowIndex ) {
							// console.log("row--", row);
							// console.log("row--", row);
							// console.log("uData--", userData[row.index]);

							let tempUid = "";
							let str4 = ``;

							$.each(userData, function(index, el){
								str4 += `
									<li data-name="${'${ el.name }'}" data-uid="${'${ el.uid }'}"><a href="#" tabindex="-1">${'${ el.name }'}</a></li>
								`
							});

							let dropdown4 = ``;
							let userName = userData[row.index].name;

							if(!isEmpty(userData[row.index].uid)) {
								tempUid = userData[row.index].uid;

								dropdown4 = `
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" disabled data-toggle="dropdown" data-value="${'${ tempUid }'}">${'${ userName }'}<span class="caret"></span></button>
										<ul id="aContactPersonList${'${ row.index }'}" class="dropdown-menu">${'${ str4 }'}</ul>
									</div>
								`;
							} else {
								tempUid = "";

								dropdown =4 `
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="${'${ userName }'}" data-value="${'${ tempUid }'}" >${'${ userName }'}<span class="caret"></span></button>
										<ul id="aContactPersonList${'${row.index}'}" class="dropdown-menu">${'${ str }'}</ul>
									</div>
								`;
							}

							return dropdown4;
						},
						"className": "no-sorting",
						// "width": "16%"
					},
					{
						"sTitle": "전화번호",
						"mData": "null",
						"mRender": function ( data, type, row, rowIndex ) {
							return `<div class="tx_inp_type disabled"><input type="text" id="aContactNum${'${row.index}'}" name="a_contact_num" disabled /></div>
							`;
						},
						"className": "no-sorting",
						// "width": "18%"
					},
					{
						"title": "",
						"mData": "null",
						"mRender": function ( data, type, row, rowIndex ) {
							return `<button type="button" class="icon-edit" onclick="enableAlarmInput($(this))">수정</button>`;
						},
						"className": "dt-body-center no-sorting",
						// "width": "6%"
					},
					{
						"sTitle": "",
						"mData": "null",
						"mRender": function ( data, type, row, row, rowIndex ) {
							return `<button type="button" class="icon-delete" onclick="enableAlarmInput($(this), 'delete')">삭제</button>`;
						},
						"className": "dt-body-center no-sorting",
						// "width": "6%"
					},
				],
				"dom": 'ti',
				initComplete: function(){
					// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
					// 	cell.innerHTML = i+1;
					// 	$(cell).data("id", i);
					// });
				},
				createdRow: function (row, data, dataIndex){
				},
				drawCallback: function(){
					this.api().columns().header().each ((el, i) => {
						if(i == 0){
							$(el).attr ('style', 'min-width: 12vw;');
						} else if(i < 2){
							$(el).attr ('style', 'min-width: 13vw;');
						} else if(i >= 2 && i < 5){
							$(el).attr ('style', 'min-width: 10vw;');
						} else {
							$(el).attr ('style', 'min-width: 5vw;');
						}
					});
				}
			
			}).columns.adjust().draw();
			
			$("#addAlarmModal").modal("show");
		});


		// non = false;
		// did = dv.did;
		// type = dv.device_type;
		// name = dv.name;
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
		// 			"mData": "null",
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
		// 			<button type="button" class="btn-text-blue ml-24" onclick="addAlarmRow()">추가</button>
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

	function addAlarmRow(){
		let table = $("#alarmTable");
		let row =	table.find("tbody tr:first-of-type");
		table.append(row);
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
			if( ($("#validSite:not('.hidden')").length > 0 ) && (!isEmpty($("#newCityList").prev().data("value"))) && (!isEmpty($("#newResList").prev().data("value"))) ){
				$("#addSiteBtn").prop("disabled", false);
				console.log("validated!!!!")
			} else {
				$("#addSiteBtn").prop("disabled", true);
				console.log("NOT validated!!!!")
			}
		} else {
			$("#addSiteBtn").prop("disabled", false);
		}

	}

	function selectRow(dataTable) {
		if ($(this).hasClass("selected")) {
			$(this).removeClass("selected");
		} else {
			dataTable.$("tr.selected").removeClass("selected");
			$(this).addClass("selected");
		}
	}

	function enableAlarmInput(self, option){
		let tr = self.parents().closest("tr");
		let input = tr.find("input[type='text']");
		let dropdown = tr.find(".dropdown-toggle");

		if(input.first().is(":disabled")) {
			// $.each(input, function(index, el){
			// 	$(this).prop("disabled", false);
			// });
			// $.each(dropdown, function(index, el){
			// 	$(this).prop("disabled", false);
			// });
			tr.removeClass("disabled");
			input.first().prop("disabled", false).parent().removeClass("disabled");
			dropdown.prop("disabled", false);
			flag = true;
		} else {
			tr.addClass("disabled");
			input.first().prop("disabled", true).parent().addClass("disabled");
			dropdown.prop("disabled", true);
		}
		if(option){
			let arr = [];
			$.each(tr, function(index, el){
				if(!tr.hasClass("disabled")){
					let obj = {};
					let dropdown = el.find(".dropdown-toggle");
					let input = el.find("input[type='text']");

					obj.device_type = dropdown.eq(0).data("value");
					obj.name = dropdown.eq(1).data("value");
					obj.level = dropdown.eq(2).data("value");
					obj.person = dropdown.eq(3).data("value");
					obj.phone = input.val();
				}

			});
		}

	}


</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">사업소 관리</h1>
	</div>
</div>

<c:set var="siteList" value="${siteHeaderList}"/> <!-- 사이트 별 -->

<div class="row">
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
				<ul id="countryList" class="dropdown-menu chk_type" role="menu">
					<li><a href="#">전체</a></li>
					<c:forEach var="country" items="${location}">
						<c:if test="${country.value.code eq 'kr'}">
							<c:forEach var="city" items="${country.value.locations}" varStatus="cityName">
								<li data-id="${city.value.code}" data-value="${city.value.name.kr}">
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
					<col style="width:6%">
					<col style="width:10%">
					<col style="width:16%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:7%">
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
				<h5 id="alarmDeleteSuccessMsg" class="ntit">알람 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="tx_inp_type"><input type="text" name="confirm_alarm" id="confirmAlarm" placeholder="장치명 이름 입력"/></div>
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
			<div class="modal-header flex_start"><h1>알람 추가</h1></div>
			<div class="modal-body mt10">
				<form id="addAlarmForm">
					<table id="alarmTable" class="no-stripe">
						<!-- <colgroup>
							<col style="width:12%">
							<col style="width:18%">
							<col style="width:18%">
							<col style="width:16%">
							<col style="width:16%">
							<col style="width:10%">
							<col style="width:10%">
						</colgroup> -->
						<thead></thead>
						<tbody></tbody>
					</table>
				</div>
				<div class="btn_wrap_type05"><!--
				--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" class="btn_type w80 ml-12">수정</button><!--
			--></div>
			</form>
		</div>
	</div>
</div>



<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog" aria-labelledby="addSiteModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-xl">
		<div class="modal-content site-modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1>사업소 추가<span class="required px-4 fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사업소 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form id="updateSiteForm" name="add_user_form">
						<section id="sectionSiteInfo">
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">사업소 명</span></div>
								<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex_start">
										<div class="tx_inp_type offset-73">
											<input type="text" name="new_site_name" id="newSiteName" placeholder="입력" minlength="2" maxlength="15">
										</div>
										<button type="button" class="btn_type fr" disabled onclick="checkSiteId($('#newSiteName').val())">중복 체크</button>
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
						</section>

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
											<ul id="newVoltList" class="dropdown-menu"></ul>
										</div>
									</div>
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
										<div class="dropdown">
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
									<div class="dropdown offset-width">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newDrResIdList" class="dropdown-menu"></ul>
									</div>
								</div>

								<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input_label">계약용량</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type offset-width">
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

						<section id="sectionTradeInfo">
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

						<div class="row">
							<div class="col-12">
								<div class="btn_wrap_type02">
									<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addSiteBtn" class="btn_type" disabled>등록</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>



