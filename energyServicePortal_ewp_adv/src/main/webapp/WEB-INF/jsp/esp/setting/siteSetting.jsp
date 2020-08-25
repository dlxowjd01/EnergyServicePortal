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



		$("#newSiteName").on('keydown', function() {
			$(this).val($(this).val().replace(/\s/g, ''));
			$("#invalidSite").addClass("hidden");
		});

		$("#newSiteName").on('keyup', function() {
			let warning = $("#validSite").parent().find(".warning");

			$("#validId").addClass("hidden")

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

		$("#newSmartPwd").on('input', validatePassword);

		$("#newSiteTypeList").find("li").on("click", function() {
			let val = $(this).data("value");
			let items = $("#newResourceList").find("li");

			setDropdownValue($("#newSiteTypeList"));

			if(val == 0) {
				$("#newResourceList").find().show();
				items.eq(0).siblings().addClass("hidden");
			} else {
				items.eq(0).addClass("hidden").siblings().removeClass("hidden");
			}
		});

		$("#addSiteModal").on("hide.bs.modal", function() {
			console.log("this===", $(this).hasClass("edit"))
			if($(this).hasClass("edit")){
				$(this).removeClass("edit");
			}
			initModal();
		});

		$("#updateSiteForm").on("submit", function(e){
			e.preventDefault();

			let option = {};
			let optionPwd = {};
			let userObj = {};

			let newSiteName = $("#newSiteName").val();
			let newFullName = $("#newFullName").val();
			let newPwd = $("#newUserPwd").val();
			let newAccVal = Number($("#newAccLevel").prev().data("value"));
			let newAccName =$("#newAccLevel").prev().data("name");

			let newPhoneNum = $("#newMobileNum").val();
			let newAffiliation = $("#newAffiliation").val();
			let newEmailAddr =$("#newEmailAddr").val();
			let newTaskList = $("#newTaskList").prev().data("value");
			let newUseOpt = $("#newUseOpt").prev().data("value");
			let newUserDesc = $("#newUserDesc").val();

			let siteInfo = $("#selectedSiteList").find("li");
			let spcInfo = $("#selectedSpcList").find("li");

			// 1. ADD a USER
			if(!$("#addSiteModal").hasClass("edit")) {
				userObj.login_id = newSiteName;
				userObj.name = newFullName;
				userObj.password = newPwd;
				userObj.role = newAccVal;

				if( !isEmpty(newPhoneNum)){
					userObj.contact_phone = newPhoneNum;
				}
				if( !isEmpty(newAffiliation) ){
					userObj.team = newAffiliation;
				}
				if( !isEmpty(newEmailAddr)){
					userObj.contact_email = newEmailAddr;
				}
				if( !isEmpty(newTaskList)){
					userObj.task = newTaskList;
				}
				if( !isEmpty(newUseOpt)){
					userObj.valid_yn = newUseOpt;
				}
				if( !isEmpty(newUserDesc) ){
					userObj.description = JSON.stringify(newUserDesc);
				}

				option = {
					url: apiHost + '/config/users?oid=' + oid,
					type: 'post',
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(userObj)
				}

				if( siteInfo.length <= 0 && spcInfo.length <= 0 ){
					$.ajax(option).done(function (json, textStatus, jqXHR) {
						$("#addSiteModal").modal("hide");
						$("#resultSuccessMsg").text("사용자가 추가 되었습니다.").removeClass("hidden");
						$("#resultModal").modal("show");
						// let table = $("#siteTable").DataTable();

						// table.row.add({

						// });
						setTimeout(function(){
							$("#resultModal").modal("hide");
							// location.reload();
						}, 1600);
					}).fail(function (jqXHR, textStatus, errorThrown) {
						$("#failMsg2").removeClass("hidden");
						$("#resultModal").modal("show");
						setTimeout(function(){
							$("#resultModal").modal("hide");
						}, 1600);
						console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
						return false;
					});
				} else {
					let siteObj = {};
					let spcObj = {};

					$.ajax(option).done(function (json, textStatus, jqXHR) {
						let newUid = json.uid;

						let siteOption = {
							url: apiHost + '/config/user_sites?uid=' + newUid,
							type: 'post',
							dataType: 'json',
							contentType: "application/json",
							async: true
						}
						let spcOption = {
							url: apiHost + '/config/user_spcs?uid=' + newUid,
							type: 'post',
							dataType: 'json',
							contentType: "application/json",
							async: true
						}
						if(siteInfo.length > 0) {
							var sitePromises = [];
							$.each(siteInfo, function(index, element){
								siteObj.sid = $(element).data("sid");
								siteObj.role = Number($(element).data("role"));
								siteOption.data = JSON.stringify(siteObj);
								sitePromises.push(Promise.resolve(makeAjaxCall(siteOption)));
							});
							Promise.all(sitePromises).then(res => {
								console.log("res---", res);
							});
						}
						if(spcInfo.length > 0 ){
							var spcPromises = [];
							$.each(spcInfo, function(index, element){
								let spcObj = {
									spcid: $(element).data("value"),
									role: Number($(element).data("role"))
								};
								spcOption.data = JSON.stringify(spcObj);
								sitePromises.push(Promise.resolve(makeAjaxCall(spcOption)));
							});
							Promise.all(spcPromises).then(res => {
								console.log("res---", res);
							});
						}

					}).fail(function (jqXHR, textStatus, errorThrown) {
						let r = JSON.parse(jqXHR.responseText);
						console.log("에러코드:" + jqXHR.status + "\n" + "메세지: " + r);
						return false;
					});
				}
			} else {
			// 2. Edit existing user info
				let tr = $("#siteTable").find("tbody tr.selected");
				let td = tr.find("td");

				let newUid = tr.data("uid");
				let role = $("#newAccLevel").prev().data("value");
				let roleTitle = $("#newAccLevel").prev().data("name");
				let pwd = '';

				if( !isEmpty(newFullName) && ( newFullName != td.eq(2).text() ) ) {
					userObj.name = newFullName;
				}
				if( !isEmpty(newAccVal) && ( newAccName != td.eq(6).text() ) ) {
					userObj.role = newAccVal;
				}

				if( !isEmpty(newPhoneNum) && ( newPhoneNum != td.eq(3).text() ) ) {
					userObj.contact_phone = newPhoneNum;
				}
				if( !isEmpty(newEmailAddr) && ( newEmailAddr != td.eq(4).text() ) ) {
					userObj.contact_email = newEmailAddr;
				}
				if( !isEmpty(newAffiliation) && ( newAffiliation != td.eq(5).text() ) ) {
					userObj.team = newAffiliation;
				}
				if( !isEmpty(newTaskList) && ( newTaskList != td.eq(7).text() ) ) {
					userObj.task = newTaskList;
				}
				if( !isEmpty(newPhoneNum) && ( newPhoneNum != td.eq(8).text() ) ) {
					userObj.valid_yn = newPhoneNum;
				}
				if( !isEmpty(newUserDesc)) {
					userObj.description = JSON.stringify(newUserDesc);
				}

				option = {
					url: apiHost + '/config/users/' + newUid,
					type: 'patch',
					beforeSend: function (jqXHR, settings) {
						$("#loadingCircle").show();
					},
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(userObj)
				}

				if( isEmpty($("#newUserPwd").val()) && isEmpty(userObj) ) {
					// if no changes have been made
					$("#resultFailureMsg").text("변경하실 정보를 입력해 주세요").removeClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 5000);
					return false;
				} else {
					// if pwd && other values are present
					if( !isEmpty($("#newUserPwd").val()) && !isEmpty(userObj) ){
						pwd = $("#newUserPwd").val();
						optionPwd = {
							url: apiHost + '/config/users/' + newUid + '/password2',
							type: 'patch',
							async: true,
							data: JSON.stringify(pwd),
							contentType: 'application/json; charset=UTF-8'
						}
						$.when($.ajax(optionPwd),$.ajax(option)).done(function (result1, result2) {
							if(siteInfo.length<=0 && spcInfo<=0){
								$("#resultSuccessMsg").text("사용자 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
								$("#resultModal").modal("show");
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1000);
							}
							if(siteInfo.length > 0) {
								$.each(siteInfo, function(index, element){
									siteObj.sid = $(element).data("sid");
									siteObj.role = Number($(element).data("role"));
									siteOption.data = JSON.stringify(siteObj);
									makeAjaxCall(siteOption);
								});
							}
							if(spcInfo.length > 0 ){
								$.each(spcInfo, function(index, element){
									let spcObj = {
										spcid: $(element).data("value"),
										role: Number($(element).data("role"))
									};
									spcOption.data = JSON.stringify(spcObj);
									makeAjaxCall(spcOption);
								});
							}
						}).fail(function (jqXHR, textStatus, errorThrown) {
							console.log("result1===", jqXHR)
							$("#resultFailureMsg").text("사용자 정보 변경에 실패하였습니다. 다시 시도해 주세요.").removeClass("hidden");
							$("#resultModal").modal("show");
							setTimeout(function(){
								$("#resultModal").modal("hide");
							}, 1000);
							return false;
						});
					} else {
						if( ! ( isEmpty($("#newUserPwd").val()) ) ){
							console.log("pwd exist===", $("#newUserPwd").val() )
							$.ajax(optionPwd).done(function (json, textStatus, jqXHR) {
								$("#resultSuccessMsg").multiline("사용자 정보가\n성공적으로 변경 되었습니다.").removeClass("hidden");
								$("#resultModal").modal("show");
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1800);
							}).fail(function (jqXHR, textStatus, errorThrown) {
								let errorMsg = "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown;
								$("#resultFailureMsg").multiline(errorMsg).removeClass("hidden");
								$("#resultModal").modal("show");
								console.log('erro===', errorMsg)
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1800);
								return false;
							});
						}
						if( !isEmpty(userObj) ){
							console.log("pwd DOESNOT exist===", $("#newUserPwd").val() )
							$.ajax(option).done(function (json, textStatus, jqXHR) {
								$("#resultSuccessMsg").multiline("사용자 정보가\n성공적으로 변경 되었습니다.").removeClass("hidden");
								$("#resultModal").modal("show");
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1800);
							}).fail(function (jqXHR, textStatus, errorThrown) {
								let errorMsg = "에러코드:" + jqXHR.status + "\n" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown;
								$("#resultFailureMsg").text(errorMsg).removeClass("hidden");
								$("#resultModal").modal("show");
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1800);
								return false;
							});
						}
					}
				}
			}
		});


		$("#updateSiteForm").on("change", function(e){
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

		function validatePassword() {
			const rules = [
				{
					Pattern: "[a-zA-Z]",
					Target: "hasLet"
				},
				{
					Pattern: "[0-9]",
					Target: "hasNum"
				},
			];

			let password = $(this).val();
			password.length >= 6 ? $("#sixCharLong").addClass("checked") : $("#sixCharLong").removeClass("checked");

			for (var i = 0; i < rules.length; i++) {
				if( new RegExp(rules[i].Pattern).test(password) ) {
					$("#" + rules[i].Target).addClass("checked")
				} else {
					$("#" + rules[i].Target).removeClass("checked")
				}
			}
		}


		function getSiteList(siteId) {
			let option = {
				url: apiHost + "/config/sites",
				// url: apiHost + "/config/sites/" + sid,
				type: "get",
				async: false,
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
							obj.resType = "Demand"
							obj.powerSource = "ESS"
						} else {
							obj.resType = "Generation"
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
						// "autoWidth": true,
						"bAutoWidth": true,
						"bSearchable" : true,
						"sScrollX": "110%",
						"sScrollXInner": "110%",
						"sScrollY": false,
						"bScrollCollapse": true,
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
								"mData": "resType",
							},
							{
								"sTitle": "사업소명",
								"mData": "name"
							},
							{
								"sTitle": "지역",
								"mData": "location",
							},
							{
								"sTitle": "발전원",
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


					$("#siteTypeList").find("li").on( 'click', function(){
						if(!isEmpty($(this).data("name"))){
							filterColumn("1", $(this).data("value"));
						} else {
							filterColumn("1", "");
						}
					});
					$("#siteSearchBox").on( 'keyup search input paste cut', function(){
						siteTable.search( this.value ).draw();
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

				return false;
			});
		}

		function getAjaxList() {
			const contractList = $("#contractTypeList");	
			let arr = [
				{
					id: 1,
					country: "KR",
					utilityName: "KEPCO",
					planName: "주택용(저압)",
					voltageType: null
				},
				{
					id: 2,
					country: "KR",
					utilityName: "KEPCO",
					planName: "주택용(고압)",
					voltageType: null
				},
				{
					id: 3,
					country: "KR",
					utilityName: "KEPCO",
					planName: "일반용(갑)I",
					voltageType: [ "저압전력", "고압A:선택 I", "고압A:선택 II", "고압B:선택 I", "고압B:선택 II" ]
				},
				{
					id: 4,
					country: "KR",
					utilityName: "KEPCO",
					planName: "일반용(갑)II",
					voltageType: [ "고압A:선택 I", "고압A:선택 II", "고압B:선택 I", "고압B:선택 II" ]
				},
				{
					id: 5,
					country: "KR",
					utilityName: "KEPCO",
					planName: "일반용(을)",
					voltageType: [ "고압A:선택 I", "고압A:선택 II", "고압A:선택 III", "고압B:선택 I", "고압B:선택 II", "고압B:선택 III", "고압C:선택 I", "고압C:선택 II", "고압C:선택 III" ]
				},
				{
					id: 6,
					country: "KR",
					utilityName: "KEPCO",
					planName: "교육용(갑)",
					voltageType: [ "저압전력", "고압A:선택 I", "고압A:선택 II", "고압B:선택 I", "고압B:선택 II" ]
				},
				{
					id: 7,
					country: "KR",
					utilityName: "KEPCO",
					planName: "교육용(을)",
					voltageType: [ "고압A:선택 I", "고압A:선택 II", "고압B:선택 I", "고압B:선택 II" ]
				},
				{
					id: 8,
					country: "KR",
					utilityName: "KEPCO",
					planName: "산업용(갑)I",
					voltageType: [ "저압전력", "고압A:선택 I", "고압A:선택 II", "고압B:선택 I", "고압B:선택 II" ]
				},
				{
					id: 9,
					country: "KR",
					utilityName: "KEPCO",
					planName: "산업용(갑)II",
					voltageType: [ "고압A:선택 I", "고압A:선택 II", "고압B:선택 I", "고압B:선택 II" ]
				},
				{
					id: 10,
					country: "KR",
					utilityName: "KEPCO",
					planName: "산업용(을)",
					voltageType: [ "고압A:선택 I", "고압A:선택 II", "고압A:선택 III", "고압B:선택 I", "고압B:선택 II", "고압B:선택 III", "고압C:선택 I", "고압C:선택 II", "고압C:선택 III" ]
				},
				{
					id: 11,
					country: "KR",
					utilityName: "KEPCO",
					planName: "임시(갑)",
					voltageType: null
				},
				{
					id: 12,
					country: "KR",
					utilityName: "KEPCO",
					planName: "임시(을)",
					voltageType: [ "저압전력", "고압A:선택 I", "고압A:선택 II", "고압B:선택 I", "고압B:선택 II" ]
				},
				{
					id: 13,
					country: "KR",
					utilityName: "KEPCO",
					planName: "가로등(을)",
					voltageType: null
				},
				{
					id: 14,
					country: "KR",
					utilityName: "KEPCO",
					planName: "심야전력(갑)",
					voltageType: null
				},
				{
					id: 15,
					country: "KR",
					utilityName: "KEPCO",
					planName: "농사용(갑)",
					voltageType: [ "저압전력", "고압전력" ]
				},
				{
					id: 16,
					country: "KR",
					utilityName: "KEPCO",
					planName: "농사용(을)",
					voltageType: [ "저압전력", "고압A", "고압B", "고압B" ]
				},
				{
					id: 17,
					country: "KR",
					utilityName: "KEPCO",
					planName: "심야전력(갑)",
					voltageType: null
				},
				{
					id: 18,
					country: "KR",
					utilityName: "KEPCO",
					planName: "심야전력(을)I",
					voltageType: null
				},
				{
					id: 19,
					country: "KR",
					utilityName: "KEPCO",
					planName: "심야전력(을)II",
					voltageType: null
				},
				{
					id: 20,
					country: "KR",
					utilityName: "KEPCO",
					planName: "미정",
					voltageType: null
				}
			];
			let str = '';

			$.each(arr, function(index, element) {
				str += `
					<li data-id="${'${element.id}'}" data-vol-type="${'${element.voltageType}'}" data-value="${'${element.planName}'}"><a href="#">${'${element.planName}'}</a></li>
				`
			});
			contractList.append(str);

			contractList.find("li").on("click", function(){
				let val = $(this).data("value");
				let subOpt = $("#contractSubList");
				let btn = subOpt.prev();

				subOpt.empty().prev().data("value", "").html("선택<span class='caret'></span>");

				if(!isEmpty($(this).data("vol-type"))){
					let str = '';
					let subValArr = [...$(this).data("vol-type").split(",")];
					if(btn.hasClass("disabled")){
						btn.removeClass("disabled")
					}
					$.each(subValArr, function(index, element){
						str += '<li data-value="element"><a href="#">' + element + '</a></li>';
					});
					subOpt.append(str);
				} else {
					btn.html("<span class='caret'></span>")
					if(!btn.hasClass("disabled")){
						btn.addClass("disabled");
					}
				}
			});

			let optionList = [
				{
					url: apiHost + "/config/dr-groups"+'?oid=' + oid,
					type: 'get',
					async: false,
				},
				{
					url: apiHost + "/config/vpp-groups/"+'?oid=' + oid,
					type: 'get',
					async: false,
				}
			];

			$.when($.ajax(optionList[0]), $.ajax(optionList[1])).done(function (result1, result2) {
				let drList = $("#drResList");
				let vppResList = $("#vppResList");
				// 	$("#drResList").empty();
				// $("#vppResList").empty();

				drList.empty();
				vppResList.empty();

				if(!isEmpty(result1[0])) {
					// console.log("1---", result1[0])
					let str = '';
					$.each(result1[0], function(index, element) {	
						if(!isEmpty(element.resourceId)) {
							str += '<li data-value="' + element.dgid + '"><a href="#" tabindex="-1">' + element.resourceId + '<span class="res-name">' + element.name +  '</a></span></li>'
						} else {
							str += '<li data-value="' + element.dgid + '"><a href="#" tabindex="-1"><span class="res-name">' + element.name +  '</span></a></li>'
						}
					});

					drList.append(str);
					// $("#drResList").append(str);
				} else {
					drList.prev().html("등록된 자원 ID가 없습니다.<span class='caret'></span>").addClass("disabled");
					// console.log("array empty")
				}

				if(!isEmpty(result2[0])) {
					// console.log("1---", result2[0])
					let str = '';
					$.each(result2[0], function(index, element) {
						// console.log("2---", element)
						if(!isEmpty(element.resourceId)) {
							str += '<li data-value="' + element.vgid + '"><a href="#" tabindex="-1">' + element.resourceId + '<span class="res-name">' + element.name +  '</a></span></li>'
						} else {
							str += '<li data-value="' + element.vgid + '"><a href="#" tabindex="-1"><span class="res-name">' + element.name +  '</span></a></li>'
						}
					});

					vppResList.append(str);
					// $("#vppResList").append(str);
				} else {
					vppResList.prev().html("등록 ID가 없습니다.<span class='caret'></span>").addClass("disabled");
					// console.log("array empty")
				}
			});
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
			return $.ajax(option).done(function (json, textStatus, jqXHR) {
				console.log("makeAjaxCall json--", json)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("siteInfo/spcInfo Ajax Error:", jqXHR.responseJSON.error.message)
				return false;
			});
		}

		function validateAddForm(){
			if( ( $("#validId:not('.hidden')").length >= 0 ) && ( $("#updateSiteForm .tick:not('.checked')").index() == -1 ) && ( $(".warning:not(.hidden)").index() == -1 ) && ( !isEmpty($("#newFullName").val() ) ) && ( !isEmpty($("#siteTypeList").prev().data("value")) )){
				return 1;
			}
		}

		function validateEditForm(){
			if(!isEmpty($("#newUserPwd").val())) {
				console.log("newUserPwd NOT empty===" )
				if( ($("#updateSiteForm .tick:not('.checked')").index() == -1) && ($(".warning:not(.hidden)").index() == -1) ) {
					return 1;
				}
			} else {
				if( $(".warning:not(.hidden)").index() == -1 ) {
					return 1;
				}
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
		let tick = form.find(".tick");
		let warning = form.find(".warning");

		$("#validId").addClass("hidden");
		$("#addSiteBtn").prop("disabled", true).addClass("disabled");

		warning.addClass("hidden")
		tick.removeClass("checked");
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

		if(option == "all"){
			if(newSiteName.parent().next().hasClass("hidden")) {
				newSiteName.parent().next().removeClass("hidden");
				newSiteName.parent().addClass("offset-width").removeClass("w-100");
			}
			titleAdd.removeClass("hidden").next().addClass("hidden");
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			$('#newSiteName').prop('disabled', false);
			$("#addSiteModal").removeClass("edit").modal("show");
		} else {
			var tr = $("#siteTable").find("tbody tr.selected");
			let td = tr.find("td");
			if(option == "edit") {
				$("#addSiteBtn").prop("disabled", false).removeClass("disabled");
				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");
				if(!newSiteName.parent().next().hasClass("hidden")) {
					newSiteName.parent().next().addClass("hidden");
					newSiteName.parent().removeClass("offset-width").addClass("w-100");
				}
				newSiteName.val(td.eq(2).text()).prop('disabled', true).addClass("disabled");

				$('#newSiteTypeList').prev().data({"name": td.eq(1).text(), "value" : td.eq(1).data("value") }).html(td.eq(1).text() + "<span class='caret'></span>");

				$("#newResourceList").prev().data({"name": td.eq(4).text(), "value" : td.eq(4).data("value") }).html(td.eq(4).text() + "<span class='caret'></span>");

				if(!isEmpty(td.eq(4))){
					$('#newMobileNum').val(td.eq(4).text())
				}
				if(!isEmpty(td.eq(5))){
					$('#newEmailAddr').val(td.eq(5).text())
				}
				if(!isEmpty(td.eq(6))){
					$('#newAffiliation').val(td.eq(6).text())
				}
				if(!isEmpty(td.eq(8))){
					$('#newTaskList').prev().data("value", td.eq(8).text()).html(td.eq(8).text(), '<span class="caret">');
				}
				if(!isEmpty(td.eq(9))){
					$('#contractTypeList').prev().data("value", td.eq(9).text()).html(td.eq(9).text(), '<span class="caret">');
				}
				$("#addSiteModal").addClass("edit").modal("show");
			}
			if(option == "delete") {
				let td = $("#siteTable").find("tbody tr.selected td");
				let id = td.eq(0).find("input").data("id");
				let userId = $("#siteTable").find("tbody tr.selected td:nth-of-type(3)").text();
				$("#deleteSuccessMsg span").text(userId);
				$("#deleteConfirmModal").modal("show");

				$("#confirmUserId").on('input', function() {
					$(this).val($(this).val().replace(/\s/g, ''));
				});

				$("#confirmUserId").on("keyup", function() {
					if($(this).val() != userId) {
						return false
					} else {
						$("#warningConfirmBtn").prop("disabled", false).removeClass("disabled");
						$("#warningConfirmBtn").on("click", function(){
							let optDelete = {
								url: apiHost + "/config/users/" + id,
								type: 'delete',
								async: true,
								beforeSend: function (jqXHR, settings) {

								},
							}

							$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
								var newTable = $('#siteTable').DataTable();

								$("#deleteSuccessMsg").text("사용자가 삭제 되었습니다.").removeClass("hidden");
								newTable.rows(tr).remove().draw(false);
								setTimeout(function(){
									$("#deleteConfirmModal").modal("hide");
								}, 1200);

							}).fail(function (jqXHR, textStatus, errorThrown) {
								console.log("fail==", jqXHR)
							});
						});
					}
				});

				

			}
		}

	}

	function showPwd(self) {
		var x = document.getElementById("newSmartPwd");
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

		console.log("id===", id );

		if(!isEmpty(siteList)) {
			if(siteList.some(x => x.name == id)){
				$("#invalidSite").removeClass("hidden");
				console.log("match==")
			} else {
				$("#validSite").removeClass("hidden");
				console.log("no match==")
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
					<ul id="siteTypeList" class="dropdown-menu">
						<li data-name="Demand" data-value="0"><a href="#">수요(Demand)</a></li>
						<li data-name="Generation" data-value="1"><a href="#">발전(Generation)</a></li>
					</ul>
			</div>

			<%--
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu" id="siteList">
					<li>
						<a href="#" tabindex="-1">
							<input type="checkbox" name="allSites" id="allSites" value="all">
							<label for="allSites">전체</label>
						</a>
					</li>
					<c:if test="${fn:length(siteList) > 0}">
						<c:forEach var="site" items="${siteList}">
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" name="${site.name}" id="${site.sid}" value="${site.index}">
									<label for="${site.sid}">${site.name}</label>
								</a>
							</li>
						</c:forEach>
					</c:if>
				</ul>
			</div>
			--%>
		</div>
		<div class="flex_group">
			<span class="inline-title">지역</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu">
					<li><a href="#">전체</a></li>
					<c:set var="systemLoc" value="${sessionScope.systemLoc}"/>
					<c:forEach var="country" items="${location}">
						<c:if test="${fn:length(systemLoc) > 0} && ${country.value.code eq 'kr'}">
							<c:forEach var="city" items="${country.value.locations}" varStatus="cityName">
								<li>
									<a href="#" tabindex="-1">
										<input type="checkbox" name="" id="${city.value.code}" value="${city.value.name.kr}">
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
				<ul class="dropdown-menu">
					<li data-value="solar" class="on"><a href="#">태양광</a></li>
					<li data-value="wind"><a href="#">풍력</a></li>
					<li data-value="wind"><a href="#">소수력</a></li>
					<li data-value="wind"><a href="#">부하</a></li>
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">발전소명</span>
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
			<button type="button" class="btn_type fr mb-20" onclick="updateModal('all')">추가</button>
			
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
			<div class="tx_inp_type"><input type="text" id="confirmUserId" name="confirm_user_id" placeholder="사용자 아이디 입력"/></div>
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
			<!-- <div class="modal-body"> -->
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

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">사업소 유형</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newSiteTypeList" class="dropdown-menu">
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
										<ul id="newResourceList" class="dropdown-menu">
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
										<ul id="" class="dropdown-menu">
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
										<div class="dropdown w-42">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="" class="dropdown-menu"></ul>
										</div>
										<div class="tx_inp_type w-54"><input type="text" name="new_full_name" id="" placeholder="입력" minlength="3" maxlength="28"></div>
									</div>
									<small class="hidden warning">사업소재지를 선택해 주세요</small>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">위경도</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" id="" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">추가 정보</span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<textarea name="new_site_desc" id="newSiteDesc" class="textarea" placeholder="입력"></textarea>
								</div>
							</div>
						</section>

						<section id="sectionPowerBillInfo">
							<h2 class="stit">전력 구매 정보</h2>
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">계약종 별</span></div>
								<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex_start">
										<div class="dropdown w-42">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="contractTypeList" class="dropdown-menu"></ul>
										</div>
										<div class="dropdown w-54">
											<button type="button" class="dropdown-toggle disabled" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="contractSubList" class="dropdown-menu"></ul>
										</div>
									</div>
								</div>
								
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">계약 전력</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" name="new_power_rate" id="newPowerRate" class="pr-36" placeholder="입력" minlength="3" maxlength="28"><span class="unit">kW</span></div>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">요금 적용<br>전력</span></div>
								<div class="col-xl-2 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" name="" id="" class="pr-36" placeholder="입력" minlength="3" maxlength="28"><span class="unit">kW</span></div>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">검침일</span></div>
								<div class="col-xl-1 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
										<ul id="newTaskList" class="dropdown-menu">
											<li data-value="1"><a href="#">1일</a></li>
											<li data-value="5"><a href="#">5일</a></li>
											<li data-value="10"><a href="#">10 일</a></li>
											<li data-value="15"><a href="#">15일</a></li>
											<li data-value="20"><a href="#">20일</a></li>
											<li data-value="end"><a href="#">말일</a></li>
										</ul>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">한전<br>고객번호</span></div>
								<div class="col-xl-3 col-lg-3 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" id="newCustomerNum" name="new_customer_num" placeholder="입력" minlength="3" maxlength="28"></div>
								</div>

								<div class="col-xl-1 col-lg-1 col-md-2 col-sm-2"><span class="input_label offset-top">iSMART<br>아이디</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><input type="text" id="newSmartId" name="new_smart_id" placeholder="입력" minlength="3" maxlength="28"></div>
								</div>

								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label offset-top">iSMART<br>비밀번호</span></div>
								<div class="col-xl-2 col-lg-2 col-md-4 col-sm-10 pl-0">
									<div class="tx_inp_type"><!--
									--><input type="password" id="newSmartPwd" name="new_smart_pwd" placeholder="입력" minlength="3" maxlength="28"><!--
									--><button type="button" class="pwd-icon" onclick="showPwd(this)">show</button><!--
								--></div>
									<div class="flex_start warning-wrapper">
										<small id="hasLet" class="tick">영문</small>
										<small id="hasNum" class="tick">숫자</small>
										<small id="sixCharLong" class="tick">6자리 이상</small>
									</div>
								</div>
							</div>
						</section>

						<section id="sectionTariffInfo">
							<h2 class="stit">매전 정보</h2>
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input_label">정상 단가</span></div>
								<div class="col-xl-3 col-lg-6 col-md-4 col-sm-10 pl-0">
									<div class="flex_start">
										<div class="dropdown">
											<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
											<ul id="tariffList" class="dropdown-menu">
												<li data-value="fixed"><a href="#">고정가</a></li>
												<li data-value="SMP_mean"><a href="#">SMP평균</a></li>
												<li data-value="SMP"><a href="#">SMP</a></li>
											</ul>
										</div>
										<div class="tx_inp_type"><input type="text" id="tariffCharge" name="tariff_charge" placeholder="입력" maxlength="8"></div>
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
										<ul id="drResList" class="dropdown-menu"></ul>
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
									<div class="tx_inp_type"><input type="text" name="dr_rev_share" id="drRevShare" class="pr-36" placeholder="입력" maxlength="3"><span class="unit">%</span></div>
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
										<ul id="vppResList" class="dropdown-menu"></ul>
									</div>
								</div>

								<div class="col-xl-1 col-lg-2 col-sm-2"><span class="input_label">수익 분배율</span></div>
								<div class="col-xl-2 col-lg-2 col-sm-4 pl-0">
									<div class="tx_inp_type">
										<input type="text" name="vpp_rev_share" id="vppRevShare" class="pr-36" placeholder="입력" maxlength="3"><span class="unit">%</span>
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
