<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {

		// let l = "${location}"
		// console.log("location---", l);
		// let siteList = JSON.parse('${siteList}');
		// console.log("siteList---", siteList);

		getSiteList(oid);
		getAjaxList();
		getVppDrData();

		var alarmTable = $('#alarmTable').DataTable({
			// "fixedHeader": true,
			// "table-layout": "fixed",
			"scrollX": false,
			"scrollY": true,
			"scrollXInner": "110%",
			"scrollCollapse": true,
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
				},
				{
					"title": "설비타입",
					"render": function ( data, type, row ) {
						return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type" placeholder=""/></div>';
					},
				},
				{
					"title": "설비명",
					"render": function ( data, type, row ) {
						return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type" placeholder=""/></div>';
					},
				},
				{
					"title": "알람레벨",
					"render": function ( data, type, row ) {
						return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type" placeholder=""/></div>';
					},
				},
				{
					"title": "담당자",
					"render": function ( data, type, row ) {
						return '<div class="tx_inp_type"><input type="text" id="deviceType" name="device_type" placeholder=""/></div>';
					},
				},
				{
					"title": "",
					"className": ""
				},
				{
					"title": "",
					"className": "",
				},
			],

			"dom": 'ti',
			"select": {
				style: 'single',
				items: 'row'
			},
			"order": [[ 1, 'asc' ]],
			initComplete: function(){
				let str = `
					<button type="button" class="btn-text-blue ml-24" onclick="addAlarmRow()">추가</button>
				`
				$("#addAlarmModal").find(".modal-header").append($(str));

				this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
					cell.innerHTML = i+1;
					$(cell).data("id", i);
				});

				// this.api().columns().header().each ((el, i) => {
				// 	if(i === 0 ){
				// 		$ (el).attr ('style', 'min-width: 160px;');
				// 	}
				// });
			},
		});

		alarmTable.on( 'order.dt search.dt', function () {
			alarmTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
				cell.innerHTML = i+1;
			} );
		}).draw();

		$("#newSiteName").on('keydown', function() {
			$(this).val($(this).val().replace(/\s/g, ''));
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
				$("#newSiteName").parent().next().prop("disabled", false).removeClass("disabled");
			} else {
				$("#newSiteName").parent().next().prop("disabled", true).addClass("disabled");
			}

		});

		$("#newSiteType").find("li").on("click", function() {
			let val = $(this).data("value");
			let items = $("#newResList").find("li");
			if(val == "0") {
				$("#newResList").find().show();
				items.eq(0).siblings().addClass("hidden");
			} else {
				items.eq(0).addClass("hidden").siblings().removeClass("hidden");
			}
		});

		$("#newPriceModelList").find("li").on("click", function() {
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

		$("#addSiteModal").on("hide.bs.modal", function() {
			console.log("this===", $(this).hasClass("edit"))
			if($(this).hasClass("edit")){
				$(this).removeClass("edit");
			}
			initModal();
		});

		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			console.log("deleteConfirmModal closed===");
			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">사이트 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#confirmSite").val("");
		});


		$("#resultModal").on("hide.bs.modal", function() {
			console.log("resultModal closed===");
			document.location.reload();
			$("#resultFailureMsg").addClass("hidden");
			$("#resultSuccessMsg").addClass("hidden");
		});


		$("#updateSiteForm").on("submit", function(e){
			e.preventDefault();

			let newSiteName = $("#newSiteName").val();
			let newResType = Number($("#newUserPwd").prev().data("value"));
			let newCity = $("#newCityList").prev().data("value");

			let newSiteType = Number($("#newSiteType").prev().data("value"));
			let newSiteTypeName = $("#newSiteType").prev().data("name");

			let newEssList = Number($("#newEssList").prev().data("value"));
			let newStreetAddr= $("#newStreetAddr").val();
			let newCoord = [...$("#newCoord").val()];
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

			// AJAX && FormData Obj
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
					siteObj.utility = JSON.stringify(newUserDesc);
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
					newVppObj.revenue_share = newVppRevShare;
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

					setTimeout(function(){
						$("#resultBtn").trigger("click");
					}, 1600);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					$("#resultFailureMsg").removeClass("hidden");
					$("#resultBtn").parent().removeClass("hidden");
					$("#resultModal").modal("show");
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});

			} else {
				let tr = $("#siteTable").find("tbody tr.selected");
				let td = tr.find("td");
				let sid = tr.data("sid");
				let siteEditObj = {};

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
					siteEditObj.utility = JSON.stringify(newUserDesc);
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
					newVppObj.revenue_share = newVppRevShare;
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

					setTimeout(function(){
						$("#resultBtn").trigger("click");
					}, 1600);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					$("#resultFailureMsg").removeClass("hidden");
					$("#resultBtn").parent().removeClass("hidden");
					$("#resultModal").modal("show");
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});

			}
		});


		$("#updateSiteForm").on("change", function(e){
			console.log("changing===")
			if(!$("#addSiteModal").hasClass("edit")){
				if(validateAddForm() == 1) {
					$("#addUserBtn").prop("disabled", false).removeClass("disabled");
				} else {
					$("#addUserBtn").prop("disabled", true).addClass("disabled");
				}
			} else {
				if(validateEditForm() == 1) {
					$("#addUserBtn").prop("disabled", false).removeClass("disabled");
				} else {
					$("#addUserBtn").prop("disabled", true).addClass("disabled");
				}
			}

		});

		function getSiteList(siteId) {
			let option = {
				url: apiHost + "/config/sites",
				// url: apiHost + "/config/sites/" + sid,
				type: "get",
				async: true,
				data: {
					oid: siteId,
					filter: {
						"limit": 2000,
					}
				},
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
				},
			}

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];
				// 1. 사업소 유형
				// 2. 사업소명
				// 3. 지역
				// 4. 발전원 => 0: MicroGrid, 1: photovoltaic, 2: wind, 3: SmallHydro (hydroelectric power for local community)
				// 5. 발전 용량
				// 6. ESS 용량 (PCS)
				// 7. ESS 용량(BMS)
				// 8. DR 자원 코드
				// 9. Vpp 자원 코드 ( virtual power plant )
				// 10. 알람 설정


				Promise.all(json.map((x, index) => {
					// console.log("x===", x)
					var obj = {};
					let statusOption = {
						url: apiHost + "/status/raw/site",
						type: 'get',
						async: false,
						data:{
							sid: x.sid,
					    	formId: 'v2'
					    }
					}


					$.ajax(statusOption).done(function (json, textStatus, jqXHR) {
						// console.log("json===", json)

						if(!isEmpty(x.ess)){
							obj.essVol = x.ess
							// if(x.ess === 0) {
							// 	obj.ess = "-"
							// } else if(x.ess === 1){
							// 	obj.ess = "DemandESS"
							// } else if(x.ess === 2){
							// 	obj.ess = "GenerationESS"
							// }
						} else {
							obj.essVol = "-"
						}
						if(!isEmpty(json.INV_PV) && ( Object.keys("genCapacity").length === 0 ) ) {
							console.log("json==", json.INV_PV)
							obj.genCapacity = json.INV_PV.capacity;
						} else {
							obj.genCapacity = 0;
						}
						if(!isEmpty(json.PCS_ESS) && ( Object.keys("pcsCapacity").length === 0 ) ) {
							obj.pcsCapacity = json.PCS_ESS.capacity;
						} else {
							obj.pcsCapacity = 0;
						}
						if(!isEmpty(json.BMS_SYS) && ( Object.keys("bmsCapacity").length === 0 ) ) {
							console.log("bms", json.BMS_SYS)
							obj.bmsCapacity = json.BMS_SYS.capacity;
						} else {
							obj.bmsCapacity = 0;
						}

						obj.sid = x.sid;
						obj.idx = index;
						obj.name = x.name;
						obj.location = x.location;

						// if(x.site_type === 0) {
						// 	obj.siteType = "Demand"
						// } else {
						// 	obj.siteType = "Demand"
						// }
						if(x.resource_type === 0) {
							obj.siteType = "Demand"
							obj.powerSource = "ESS"
						} else {
							obj.siteType = "Generation"
							if(x.resource_type === 1){
								obj.powerSource = "태양광"
							} else if(x.resource_type === 2){
								obj.powerSource = "풍력"
							} else if(x.resource_type === 3){
								obj.powerSource = "소수력"
							}
						}
						if(x.dr_group_id){
							obj.drId = x.dr_group_id;
						} else {
							obj.drId = "-"
						}

						if(x.vpp_group_id){
							obj.vppId = x.vpp_group_id;
						} else {
							obj.vppId = "-"
						}

						newArr.push(obj);
					});
					return newArr
				})).then(function(result){
					// console.log("result--", result)
					var siteTable = $('#siteTable').DataTable({
						"aaData": newArr,
						"table-layout": "fixed",
						"fixedHeader": true,
						// "autoWidth": true,
						// "bAutoWidth": true,
						"bSearchable" : true,
						// "sScrollX": "110%",
						// "sScrollXInner": "110%",
						"sScrollY": true,
						// "sScrollY": false,
						"bScrollCollapse": true,
						"scrollY": "500px",
						"paging": false,

						// "bFilter": false, disabling this option will prevent table.search()
						"aaSorting": [[ 0, 'asc' ]],
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
									return '<button type="button" class="btn-type-sm btn_type03" onclick="addAlarm()">추가</button>'
								},
							},
						],
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
									if(rowData.powerSource == "ESS"){
										$(td).attr('data-value', 0);
									} else if(rowData.powerSource == "태양광"){
										$(td).attr('data-value', 1);
									} else if(rowData.powerSource == "풍력"){
										$(td).attr('data-value', 2);
									} else if(rowData.powerSource == "소수력"){
										$(td).attr('data-value', 3);
									}
								}
							}
						],
						"dom": 'tip',
						"select": {
							style: 'single',
							// selector: 'td:first-child > a',
							items: 'row'
						},
						// "buttons": [
					// 	{
					// 		text: '추가',
					// 		className: "btn_type fr",
					// 		action: function (e, node, config){
					// 			updateModal("all");
					// 		}
					// 	}
					// ],
						initComplete: function(){
							let str = `
								<div id="btnGroup" class="right-end"><!--
									--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('edit')">선택 수정</button><!--
									--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('delete')">선택 삭제</button><!--
							--></div>
							`
							$("#siteTable_wrapper").append($(str));
							this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
								cell.innerHTML = i+1;
								$(cell).data("id", i);
								// $(cell).attr ('style', 'min-width: 160px;');
							});
						},
						createdRow: function (row, data, dataIndex){
							// console.log("row===", row);
							$(row).attr({
								'data-sid': data.sid,
							});
						},
						// every time DataTables performs a draw
						drawCallback: function () {
							selectRow(this);
							$('#siteTable_wrapper').addClass('mb-28');
						},
						// rowCallback: function ( row, data ) {
							// console.log("row-selected--", row)
							// $('input.editor-active', row).prop( 'checked', data.active == 1 );
						// }
					}).on("select", function(e, dt, type, indexes) {
						let btn = $("#btnGroup").find(".btn_type03");
						btn.each(function(index, element){
							if($(this).is(":disabled")){
								$(this).prop("disabled", false).removeClass("disabled");
							}
						});
						// table.rows( indexes ).nodes().to$().siblings().find("input").prop("checked", false);
						// table.rows( indexes ).nodes().to$().find("input").prop("checked", true);
						// let self = table[ type ]( indexes ).nodes().to$().find('input');
						// console.log("dt---", table[ type ]( indexes ).nodes())
					}).on("deselect", function(e, dt, type, indexes) {
						let btn = $("#btnGroup").find(".btn_type03");
						btn.each(function(index, element){
							if(!$(this).is(":disabled")){
								$(this).prop("disabled", true).addClass("disabled");
							}
						});
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
							// {
							// 	extend: 'copyHtml5',
							// 	className: "btn_type03",
							// 	text: '선택 복사',
							// },
							// {
							// 	extend: 'print',
							// 	text: '전체 인쇄',
							// 	className: "btn_type03",
							// 	exportOptions: {
							// 		modifier: {
							// 			selected: null
							// 		}
							// 	}
							// },
							// {
							// 	extend: 'print',
							// 	className: "btn_type03",
							// 	text: '선택 인쇄'
							// },
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

					$("#pageLengthList").find("li").on( 'click', function(){
						console.log("page clicking---")
						if(!isEmpty($(this).data("value"))){
							let val = Number($(this).data("value"));
							siteTable.page.len(val).draw();
						} else {
							siteTable.page.len( -1 ).draw();
						}
					});

				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("error====", jqXHR);
				return false;
			});
		}

		function filterColumn ( id, idx, val ) {
			$(id).DataTable().column(idx).search(val).draw();
		}

		function getUniqueListBy(arr, key) {
			return [...new Map(arr.map(item => [item[key], item] )).values()]
		}

		function getAjaxList() {
			let optionContract = {
				url: apiHost + "/bills/plans?country=kr",
				type: "get",
				async: true
			}

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

				// let groupByVol = getUniqueListBy(json.data, "voltageType");

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

						if(btn.hasClass("disabled")){
							btn.removeClass("disabled")
						}
						for(let i=0, length = vArr.length; i<length; i++){
							str += `<li data-util-name="${'${utilArr[i]}'}" data-id="${'${idArr[i]}'}" data-value="${'${vArr[i]}'}"><a href="#">${'${vArr[i]}'}</a></li>`;
						}
						subOpt.append(str);
					} else {
						btn.html("<span class='caret'></span>")
						if(!btn.hasClass("disabled")){
							btn.addClass("disabled");
						}
					}
				});

			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("siteInfo/spcInfo Ajax Error:", jqXHR)
			});


			let selectOpt = {
				url: apiHost + "/config/view/properties?types=site_type,resource",
				type: 'get',
				async: true
			}


			$.ajax(selectOpt).done(function (json, textStatus, jqXHR) {
				let r = json.resource;
				let s = json.site_type;
				let resStr = '';
				let siteStr = '';
				let allStr = '<li><a href="#">전체</a></li>';
				$.each(r, function(index, el){
					resStr += `
						<li data-name-kr="${'${el.name.kr}'}" data-name-en="${'${el.name.en}'}" data-value="${'${el.code}'}"><a href="#">${'${el.name.kr}'}</a></li>
					`
				});
				$("#resTypeList").append(resStr).prepend(allStr);

				$("#resTypeList li").on("click", function(){
					if(!isEmpty($(this).data("value"))){
						filterColumn( "#siteTable", "4", $(this).data("name-kr"));
					} else {
						filterColumn("#siteTable", "4", "");
					}
				});

				$.each(s, function(index, el){
					if(el.code == "demand"){
						siteStr += `
							<li data-name="Demand" data-value="2"><a href="#">수요(` + `${'${el.name.en}'}` + ` )</a></li>
						`;
					} else if(el.code == "gen"){
						siteStr += `
							<li data-name="Generation" data-value="1" class="on"><a href="#">발전(` + `${'${el.name.en}'}` + ` )</a></li>
						`;
					}
				});
				$("#siteType").append(siteStr).prepend(allStr);

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
			})
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
				} else {
					newDrResIdList.prev().html("등록된 자원 ID가 없습니다.<span class='caret'></span>").addClass("disabled");
					// console.log("1 array empty")
				}


				if(!isEmpty(result2[0])) {
					console.log("1---", result1[1])
					let str = '';
					$.each(result2[0], function(index, element) {
						// console.log("2---", element)
						if(!isEmpty(element.resourceId)) {
							str += '<li data-value="' + element.vgid + '"><a href="#" tabindex="-1">' + element.resourceId + '<span class="res-name">' + element.name +  '</a></span></li>'
						} else {
							str += '<li data-value="' + element.vgid + '"><a href="#" tabindex="-1"><span class="res-name">' + element.name +  '</span></a></li>'
						}
					});

					newVppResIdList.append(str);
					$("#newVppResIdList").append(str);
				} else {
					newVppResIdList.prev().html("등록 ID가 없습니다.<span class='caret'></span>").addClass("disabled");
					// console.log("2 array empty")
				}
			});
		
			let dropdown = $("#addSiteModal").find(".dropdown-toggle");
			setDropdownValue(dropdown);
		}

		function selectRow(dataTable) {
			if ($(this).hasClass("selected")) {
				$(this).removeClass("selected");
			} else {
				dataTable.$("tr.selected").removeClass("selected");
				$(this).addClass("selected");
			}
		}

		function makeAjaxCall(option, callback){
			console.log("option--", option)
			return $.ajax(option).done(function (json, textStatus, jqXHR) {
				console.log("makeAjaxCall json--", json)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("siteInfo/spcInfo Ajax Error:", jqXHR.responseJSON.error.message)
				return false;
			});
		}

		function validateAddForm(){
			if( ($("#validSite:not('.hidden')").length > 0 ) && ($(".warning:not('.hidden')").index() == -1) && (!isEmpty($("#newCityList").prev().data("value"))) && (!isEmpty($("#newResList").prev().data("value"))) ){
				return 1;
			}
		}

		function validateEditForm(){
			console.log("validate---")
			if( ( $(".warning:not('.hidden')").index() == -1 ) && $("#validSite:not('.hidden')").length > 0 ) {
				return 1;
			}
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

	function initModal() {
		let form = $("#updateSiteForm");
		let input = form.find("input");
		let dropdown = form.find(".dropdown-toggle");
		let warning = form.find(".warning");

		$("#validSite").addClass("hidden");
		$("#addSiteBtn").prop("disabled", true).addClass("disabled");
		$("#newResList li").removeClass("hidden");

		warning.addClass("hidden")
		input.val("");

		$.each(dropdown, function(index, element){
			$(this).html('선택' + '<span class="caret"></span>');
			$(this).data("value", "");
		});
	}

	function updateModal(option){
		// RPS(Renewable Portfolio Standard), SMP(System Marginal Price), REC(Renewable Energy Certificate) => subsidies
		let titleAdd = $('#titleAdd');
		let newSiteName = $('#newSiteName');
		let required = $("#updateSiteForm").find(".asterisk");
		let addBtn = $("#addSiteBtn");

		// ADD !!!
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
			let tr = $("#siteTable").find("tbody tr.selected");
			let td = tr.find("td");
			let sid = tr.data("sid");
			$("#validSite").is(".hidden") ? null : $("#validSite").addClass("hidden");

			// console.log("selected===", tr.data())

			// EDIT !!!
			if(option == "edit") {
				let optSite = {
					url: apiHost + "/config/sites/" + sid,
					type: "patch",
					async: true,
					contentType: 'application/json; charset=UTF-8',
				}

				addBtn.prop("disabled", false).removeClass("disabled").text("수정");
				
				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");

				if(!newSiteName.parent().next().hasClass("hidden")) {
					newSiteName.parent().next().addClass("hidden");
					newSiteName.parent().removeClass("offset-width").addClass("w-100");
				}
				newSiteName.val(td.eq(2).text()).prop('disabled', true).addClass("disabled");

				$('#newSiteType').prev().data({"name": td.eq(1).text(), "value" : td.eq(1).data("value") }).html(td.eq(1).text() + "<span class='caret'></span>");

				$("#newResList").prev().data({"name": td.eq(4).text(), "value" : td.eq(4).data("value") }).html(td.eq(4).text() + "<span class='caret'></span>");


				if(!isEmpty(td.eq(5))){
					$('#newEmailAddr').val(td.eq(5).text())
				}
				if(!isEmpty(td.eq(6))){
					$('#newAffiliation').val(td.eq(6).text())
				}
				if(!isEmpty(td.eq(8))){
					$('#newInspection').prev().data("value", td.eq(8).text()).html(td.eq(8).text(), '<span class="caret">');
				}
				if(!isEmpty(td.eq(9))){
					$('#newContractList').prev().data("value", td.eq(9).text()).html(td.eq(9).text(), '<span class="caret">');
				}
				$("#addSiteModal").addClass("edit").modal("show");
			}
			// DELETE MODAL!!!
			if(option == "delete") {
				let siteName = td.eq(2).text();
				$("#deleteSuccessMsg span").text(siteName);
				$("#deleteConfirmModal").modal("show");

				$("#confirmSite").on('input', function() {
					$(this).val($(this).val().replace(/\s/g, ''));
				});

				$("#confirmSite").on("keyup", function() {
					if($(this).val() != siteName) {
						return false
					} else {
						$("#warningConfirmBtn").prop("disabled", false).removeClass("disabled");
						$("#warningConfirmBtn").on("click", function(){
							let optDelete = {
								url: apiHost + "/config/users/" + sid,
								type: "delete",
								async: true,
							}

							$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
								var newTable = $('#siteTable').DataTable();
								$("#deleteSuccessMsg").text("사이트가 삭제 되었습니다.").removeClass("hidden");
								setTimeout(function(){
									document.location.reload();
								}, 1200);

							}).fail(function (jqXHR, textStatus, errorThrown) {
								$("#deleteSuccessMsg").text("사이트 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
								setTimeout(function(){
									document.location.reload();
								}, 1200);
								console.log("fail==", jqXHR)
							});
						});
					}
				});

				

			}
		}

	}

	function addAlarm(option){
		$("#addAlarmModal").modal("show");
	}

	function addAlarmRow(){
		let table = $("#alarmTable");
		let row =	table.find("tbody tr:first-of-type");
		table.append(row);
	}

	function showPwd(self) {
		var x = document.getElementById("newISmartPwd");
		if (x.type === "password") {
			x.type = "text";
			self.classList.add("close");
		} else {
			x.type = "password";
			self.classList.remove("close");
		}
	}

	function checkSiteId(userInput){
		if(isEmpty(userInput)) return false;
		
		$("#validSite").addClass("hidden").parent().find(".warning").addClass("hidden");
		let id = userInput.toString();

		let siteList = '${siteList}';
		siteList = JSON.parse(siteList);
		console.log("console==", siteList)
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
										<label for="${city.value.code}" class="on"><c:out value="${city.value.name.kr}"></c:out></label>
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
			<div class="flex_group">
				<div class="dropdown">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown">선택<span class="caret"></span></button>
					<ul class="dropdown-menu" id="pageLengthList">
						<li data-value=""><a href="#" tabindex="-1">전체</a></li>
						<li data-value="10"><a href="#" tabindex="-1">10</a></li>
						<li data-value="30"><a href="#" tabindex="-1">30</a></li>
						<li data-value="50"><a href="#" tabindex="-1">50</a></li>
					</ul>
				</div>
				<span class="tx_tit pl-16">개 씩 보기&ensp;</span>
			</div>
			<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>
			
			<table id="siteTable">
				<colgroup>
					<col style="width:6%">
					<col style="width:10%">
					<col style="width:16%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:14%">
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
			--><button type="button" id="resultBtn" class="btn_type03" data-dismiss="modal" onclick="$('#addSiteModal').modal('hide')" aria-label="Close">확인</button><!--
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
				--><button type="submit" id="warningConfirmBtn" class="btn_type w80 ml-12 disabled" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>


<div class="modal fade" id="addAlarmModal" tabindex="-1" role="dialog" aria-labelledby="addAlarmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md">
		<div class="modal-content site-modal-content">
			<div class="modal-header flex_start"><h1>알람 추가</h1></div>
			<div class="modal-body mt10">
				<div class="container-fluid">
					<table id="alarmTable" class="w-100">
						<!-- <colgroup>
							<col style="width:6%">
							<col style="width:14%">
							<col style="width:14%">
							<col style="width:14%">
							<col style="width:14%">
							<col style="width:14%">
							<col style="width:12%">
							<col style="width:12%">
						</colgroup> -->
						<!-- <thead>
							<tr>
								<td>순번</td>
								<td>설비타입</td>
								<td>설비명</td>
								<td>알람레벨</td>
								<td>담당자</td>
								<td></td>
								<td></td>
							</tr>
						</thead> -->
						<tbody></tbody>
					</table>
				</div>
			</div>
			<div class="btn_wrap_type05"><!--
			--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
			--><button type="submit" id="warningConfirmBtn" class="btn_type w80 ml-12 disabled" disabled>확인</button><!--
		--></div>
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
										<button type="button" class="btn_type disabled fr" disabled onclick="checkSiteId($('#newSiteName').val())">중복 체크</button>
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
										<ul id="newSiteType" class="dropdown-menu">
											<li data-value="0" data-name="Demand"><a href="#">수요(Demand)</a></li>
											<li data-value="1" data-name="Generation"><a href="#">발전(Generation)</a></li>
										</ul>
									</div>
									<small class="hidden warning">사업소 유형을 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">발전원</span></div>
								<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newResList" class="dropdown-menu">
											<li data-value="0" data-name="ESS"><a href="#">ESS</a></li>
											<li data-value="1" data-name="태양광"><a href="#">태양광</a></li>
											<li data-value="2" data-name="풍력"><a href="#">풍력</a></li>
										</ul>
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
															<li data-id="${city.value.code}" data-value="${city.value.name.kr}">
																<a href="#" tabindex="-1"><c:out value="${city.value.name.kr}"></c:out></a>
															</li>
														</c:forEach>
													</c:if>
												</c:forEach>
											</ul>
										</div>
										<div class="tx_inp_type w-55"><input type="text" name="new_street_addr" id="newStreetAddr" placeholder="입력" minlength="3" maxlength="28"></div>
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
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">계약종 별</span></div>
								<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex_start">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newContractList" class="dropdown-menu"></ul>
										</div>
										<div class="dropdown w-100">
											<button type="button" class="dropdown-toggle disabled" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="newVoltList" class="dropdown-menu"></ul>
										</div>
									</div>
								</div>
								
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">계약 전력</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" name="new_peak_demand" id="newPeakDemand" class="pr-36" placeholder="입력" minlength="3" maxlength="28"><span class="unit">kW</span></div>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">요금 적용<br>전력</span></div>
								<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" name="new_dr_charge" id="newDrCharge" class="pr-36" placeholder="입력" minlength="3" maxlength="28"><span class="unit">kW</span></div>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">검침일</span></div>
								<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newInspection" class="dropdown-menu">
											<li data-value="1"><a href="#">1일</a></li>
											<li data-value="5"><a href="#">5일</a></li>
											<li data-value="10"><a href="#">10 일</a></li>
											<li data-value="15"><a href="#">15일</a></li>
											<li data-value="20"><a href="#">20일</a></li>
											<li data-value="0"><a href="#">말일</a></li>
										</ul>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">한전<br>고객번호</span></div>
								<div class="col-xl-3 col-lg-3 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" name="new_kepco_id" id="newKepcoId" placeholder="입력" minlength="3" maxlength="28"></div>
								</div>

								<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input_label offset-top">iSMART<br>아이디</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" name="new_smart_id" id="newISmartId" placeholder="입력" minlength="3" maxlength="28"></div>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">iSMART<br>비밀번호</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><!--
									--><input type="password" name="new_smart_pwd" id="newISmartPwd" placeholder="입력" minlength="3" maxlength="28"><!--
									--><button type="button" class="pwd-icon" onclick="showPwd(this)">show</button><!--
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
									<button type="submit" id="addSiteBtn" class="btn_type disabled" disabled>등록</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>



