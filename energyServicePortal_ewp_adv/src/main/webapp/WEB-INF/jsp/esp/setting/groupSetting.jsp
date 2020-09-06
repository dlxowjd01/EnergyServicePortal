<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		// let s = JSON.parse('${siteList}');
		// console.log("siteList---", s);
		getGroupData();
		// dropdown event
		setDropdownValue($("#newGroupType"));
		setDropdownValue($("#groupList"));
		setDropdownValue($("#newGroupType"));

		$("#newGroupType li").on("click", function(){
			let groupType = $("#newGroupType");
			let val = $(this).data("value");
			let name = $(this).data("name");
			let newGroupWarning = groupType.prev().parent().next();
			let shareOpt = $("#shareOptGroup");
			let resId = $("#resIdWrapper");
			let newResId = $("#newResId");
			let radioWarning = shareOpt.find(".warning");
			let radioGroup = shareOpt.find('input[type=radio][name=share_option]');

			groupType.prev().data({ "value" : val, "name" : name });
			newGroupWarning.addClass("hidden");

			$("#validGroup").addClass("hidden");

			if(val === "tag_group"){
				shareOpt.removeClass("hidden").prev().removeClass("hidden");
				radioWarning.removeClass("hidden");
				resId.addClass("hidden").prev().addClass("hidden");
				newResId.val("");
			} else {
				shareOpt.addClass("hidden").prev().addClass("hidden");
				radioGroup.prop("checked", false);
				resId.removeClass("hidden").prev().removeClass("hidden");
			}
			if( !isEmpty($("#newGroupName").val()) ){
				$("#checkGroupBtn").prop("disabled", false);
			}		
			setTimeout(function(){
				validateForm();
			}, 200);
		});

		$("#shareOptGroup input[type=radio][name=share_option]").on("change", function(){
			$("#shareOptGroup").find(".warning").addClass("hidden");
			setTimeout(function(){
				validateForm();
			}, 200);
		});

		$("#groupList li").on( 'click', function(){
			if(!isEmpty($(this).data("name"))){
				filterColumn( "#groupTable", "1", $(this).data("name"));
			} else {
				filterColumn("#groupTable", "1", "");
			}
		});

		// Validations
		$("#newGroupName").on('input', function() {
			let newGroupType = $("#newGroupType");

			$("#invalidGroup").addClass("hidden");
			if(isEmpty(newGroupType.prev().data("value"))){
				newGroupType.parent().next().removeClass("hidden");
			} else {
				newGroupType.parent().next().addClass("hidden");
			}
			validateForm();
		});

		$("#newGroupName").on('keyup', function() {
			let warning = $("#validGroup").parent().find(".warning");

			$("#validGroup").addClass("hidden")

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

			if( warning.not(".hidden").index() == -1 && !isEmpty($("#newGroupType").prev().data("value")) ){
				$("#newGroupName").parent().next().prop("disabled", false);
			} else {
				$("#newGroupName").parent().next().prop("disabled", true);
			}
		});

		
		// Modal event
		$("#addGroupModal").on("hide.bs.modal", function(){
			$(this).hasClass("edit") ? $(this).removeClass("edit") : null;

			initModal();
			$("#validGroup").addClass("hidden");
		});
	
		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			setTimeout(function(){
				$(this).find(".modal-body").removeClass("hidden");
				$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
				$("#confirmGroup").val("");
				$("#deleteConfirmBtn").prop("disabled", true);
			}, 2000);
		});

		$("#resultModal").on("hide.bs.modal", function() {
			// console.log("resultModal closed===");
			$(this).find("h4").addClass("hidden");
		});

		// Form Submission
		$("#updateGroupForm").on("submit", function(e){
			e.preventDefault();

			let option = {};

			let obj = {};
			let newGrpType = $("#newGroupType").prev().data("value");
			let newGrpName = $("#newGroupName").val();
			let newResId = $("#newResId").val();
			let shareOption =  $("#shareOptGroup input[type=radio]:checked"); 
			let siteNameStr = $("#newSiteList").find("input:checked");
			let newGroupDetail = $("#newGroupDetail").val();
			let selectedSiteId = $("#newSiteList input:checked");
			let siteArr = [];

			// 1. Add group info
			if(!$("#addGroupModal").hasClass("edit")) {
				let option = {};
				obj.name = newGrpName;
				if(!isEmpty(newGroupDetail)){
					obj.description = newGroupDetail;
				}
				obj.updatedBy = loginId + "(" + loginName + ")";

				if(newGrpType === "tag_group"){
					if(shareOption.data("value") == "1"){
						obj.shared = true;
					} else {
						obj.shared = false;
					}
					option = {
						url:  apiHost + "/config/site_groups?uid=" + userInfoId,
						type: 'post',
						async: true,
						dataType: 'json',
						contentType: 'application/json; charset=UTF-8',
						data: JSON.stringify(obj)
					}

					$.each(selectedSiteId, function(index, el){
						siteArr.push($(this).data("value") );
					});

					Promise.resolve(returnAjaxRes(option)).then(res => {
						if(!isEmpty(res)){
							let siteObj = {
								sid: JSON.stringify(siteArr)
							};
							let sgid = res.sgid;
							let siteOpt = {
								url: apiHost + "/config/group_sites?sgid=" + sgid,
								type: 'post',
								async: true,
								data: JSON.stringify(siteObj),
								contentType: 'application/json; charset=UTF-8'
							};

							$.ajax(siteOpt).done(function (json, textStatus, jqXHR) {
								$("#addGroupModal").modal("hide");
								$("#resultSuccessMsg").text("그룹이 추가 되었습니다.").removeClass("hidden");
								$("#resultBtn").parent().addClass("hidden");
								$("#resultModal").modal("show");
								getGroupData(initModal);
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1600);
							}).fail(function (jqXHR, textStatus, errorThrown) {
								console.log("fail==", jqXHR);
							});
														
						}
					});
					
				} else if(newGrpType === "vpp_group"){
					if(!isEmpty(newResId)){
						obj.resourceId = newResId						
					}

					option = {
						url:  apiHost + "/config/vpp-groups?oid=" + oid,
						type: 'post',
						async: true,
						dataType: 'json',
						contentType: 'application/json; charset=UTF-8',
						data: JSON.stringify(obj)
					}

					Promise.resolve(returnAjaxRes(option)).then(res => {
						console.log('res===', res)
						let promises = [];
						let vgid = res.vgid;

					
						$.each(selectedSiteId, function(index, el){
							let sid = $(this).data("value");
							let siteObj = {
								vpp_group_id: vgid
							};
							let siteOpt = {
								url: apiHost + "/config/sites/" + sid,
								type: 'patch',
								async: true,
								data: JSON.stringify(siteObj),
							};
							promises.push(Promise.resolve(returnAjaxRes(siteOpt)));
						});
						return Promise.all(promises).then(finalRes => {
							console.log("finalRes---", finalRes)
						});
					});
					// option = {
					// 	url: apiHost + "/config/vpp-groups?oid=" + oid,
					// 	type: 'post',
					// 	async: true,
					// 	dataType: 'json',
					// 	contentType: "application/json",
					// 	data: JSON.stringify(obj)
					// }

				} else if(newGrpType === "dr_group"){
					obj.resourceId = newResId
					option.url =  apiHost + "/config/dr-groups?oid=" + oid;
					option.data = JSON.stringify(obj);

					// option = {
					// 	url: apiHost + "/config/dr-groups?oid=" + oid,
					// 	type: 'post',
					// 	async: true,
					// 	dataType: 'json',
					// 	contentType: "application/json",
					// 	data: JSON.stringify(obj)
					// }
				}
			} else {
				// 2. Edit existing user info
				let dTable = $("#userTable").DataTable();
				let tr = $("#userTable").find("tbody tr.selected");
				let td = tr.find("td");

				let rowData = dTable.row(tr).data();
			}


		});


		// WORK IN PROGRESS!!!!!!!!!!!!!!!
		$("#deleteConfirmBtn").click(function(){
			let dTable = $("#groupTable").DataTable();
			let tr = $("#groupTable").find("tbody tr.selected");
			let rowData = dTable.row(tr).data();
			let gsid = rowData.sid;
			let modalBody = $("#deleteConfirmModal .modal-body");
			let optDelete = {};
			let promises = [];
			console.log("rowData===", rowData)
			if(rowData.sgid){
				optDelete = {
					url: apiHost + "/config/group_sites/" + rowData.sgid,
					type: "delete",
					async: true,
				}
			} else if(rowData.vgid){
				optDelete = {
					url: apiHost + "/config/group_sites/" + rowData.vgid,
					type: "delete",
					async: true,
				} 
			} else if(rowData.dgid){
				optDelete = {
					url: apiHost + "/config/group_sites/" + rowData.dgid,
					type: "delete",
					async: true,
				}
			}

			Promise.resolve(returnAjaxRes(optDelete)).then( res => {
				console.log("res=-==", res)
			})
			$.each(rowData.sites, function(index, el){
				console.log("el===", el);
				// promises.push(Promise.resolve(returnAjaxRes(optDelete)))
			});

			// $.ajax(optDelete).done(function (json, textStatus, jqXHR) {
			// 	modalBody.addClass("hidden");
			// 	$("#deleteSuccessMsg").text("사이트가 삭제 되었습니다.").removeClass("hidden");
			// 	dTable.row(tr).remove().draw();
			// 	// refreshSiteList();
			// 	setTimeout(function(){
			// 		$("#deleteConfirmModal").modal("hide");
			// 	}, 1000);
			// }).fail(function (jqXHR, textStatus, errorThrown) {
			// 	modalBody.addClass("hidden");
			// 	$("#deleteSuccessMsg").text("사이트 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
			// 	setTimeout(function(){
			// 		$("#deleteConfirmModal").modal("hide");
			// 	}, 1500);
			// 	console.log("fail==", jqXHR)
			// });
		});


	});


	function getGroupData(callback){
		if(callback){
			callback();
			$('#groupTable').DataTable().clear().destroy();
		}
		let optionList = [
			{
				url: apiHost + "/auth/me/groups?includeSites=true&includeDevices=false",
				type: 'get',
				async: true
			},
			{
				url: apiHost + "/auth/me",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/config/sites?oid=" + oid,
				type: "get",
				async: true,
				data: {
					filter: JSON.stringify(
						{ "order": [ "updatedAt DESC" ] }
						// { "order": [ "name ASC", "updatedAt DESC" ] }
					),
				}
			}
		];

		// 	Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])) ]).then( res => {
		Promise.resolve(returnAjaxRes(optionList[0])).then( res => {
			let flat = [];
			flat = [...res.dr_group, ...res.vpp_group, ...res.tag_group];

			console.log("flat---", flat)
			if(isEmpty(flat)) {
				drawEmptyTable($("#groupTable"));
			} else {
				if(role == 1){
					adminTable(flat);		
				} else {
					nonAdminTable(flat);
				}
			}

			$("#checkGroupBtn").on("click", function(){
				let name = $("#newGroupName").val();
				let group = $("#newGroupType").prev().data("value");

				if(isEmpty(name)) return false;
				$("#validGroup").addClass("hidden").parent().find(".warning").addClass("hidden");

				if(group === "tag_group"){
					// console.log("tag_group===", res.tag_group )
					if(res.tag_group.some(x => x.name == name)){
						$("#invalidGroup").removeClass("hidden");
					} else {
						$("#validGroup").removeClass("hidden");
					}
				} else if(group === "vpp_group"){
					// console.log("vpp_group===", res.vpp_group )
					if(res.vpp_group.some(x => x.name == name)){
						$("#invalidGroup").removeClass("hidden");
					} else {
						$("#validGroup").removeClass("hidden");
					}

				} else if(group === "dr_group"){
					// console.log("dr_group===", res.dr_group )
					if(res.dr_group.some(x => x.name == name)){
						$("#invalidGroup").removeClass("hidden");
					} else {
						$("#validGroup").removeClass("hidden");
					}
				}
				validateForm();
			});
		

		});
	}
	
	function adminTable(groupData, callback) {
		if(callback){
			callback();
		}
		if(groupData) {
			// 1. 그룹 유형
			// 2. 그룹 명
			// 3. 사업소
			// 4. 최종 작업자
			// 5. 비고
			// 6. 업데이트 날짜
			var groupTable = $('#groupTable').DataTable({
				"aaData": groupData,
				"table-layout": "fixed",
				"fixedHeader": true,
				"bAutoWidth": true,
				"bSearchable" : true,
				"retrieve": true,
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
						"sTitle": "그룹 유형",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let groupType = "";
							if(full.dgid){
								return groupType = "DR 그룹";
							} else if(full.vgid){
								return groupType = "VPP 그룹";
							} else if(full.sgid){
								return groupType = "사업소 그룹";
							}
						}
					},
					{
						"sTitle": "그룹 명",
						"mData": "name"
					},
					{
						"sTitle": "사업소",
						"mData":  null,
						"mRender": function ( data, type, full, rowIndex )  {
							if(!isEmpty(full.sites)){
								let siteName = "";
								let length = full.sites.length-1;

								$.each(full.sites, function(index, el){
									if(length < 5){
										if(index < length){
											siteName += el.name + "," + '&ensp;';
										} else {
											siteName += el.name;
										}
									} else {
										if(index < 4){
											siteName += el.name + "," + '&ensp;';
										} else {
											if(index == 4){
												siteName += el.name;
											} else if(index >= 5) {
												siteName += " ..."
											}
										}
									}
								});
								// let nameLen =  byteLength(siteName);
								// console.log("byteLength===", byteLength(siteName));
								// if(nameLen > 70){
								// 	siteName.substring()
								// 	return siteName + '  <a href="#" onclick=updateModal("' + 'detail' + '"); class="text-link">more</a>'
								// } else {
								// 	return siteName;
								// }

								if(full.sites.length >= 5){
									return '<div class="flex_start">' + siteName + '...<a href="#" onclick=updateModal("' + 'detail' + '"); class="text-link">more</a></div>'
								} else {
									return siteName;
								}

							} else {
								return siteName = "-";
							}

						}
					},
					{
						"sTitle": "최종작업자",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let updatedBy = "";
							if(!isEmpty(full.updatedBy)){
								updatedBy = full.updatedBy;
							} else {
								updatedBy = "-";
							}
							return updatedBy;
							
						}
					},
					{
						"sTitle": "업데이트 일자",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let date = "";
							if(!isEmpty(full.updatedAt)){
								date = new Date(full.updatedAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(full.updatedAt).toLocaleTimeString();
							} else {
								date = "-";
							}
							return date;
						}
					},
					{
						"sTitle": "비고",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let desc = "";
							if(!isEmpty(full.description)){
								updatedBy = full.description;
							} else {
								desc = "-";
							}
							return desc;
						}
					}
				],
				"dom": 'tip',
				"select": {
					style: 'single',
					// selector: 'tr',
					selector: 'td input[type="checkbox"], tr',
					// selector: 'td input[type="checkbox"], td:not(:last-of-type)'
				},
				initComplete: function(settings, json ){
					// console.log("init settings---", settings)
					let str = `<div id="btnGroup" class="right-end"><!--
						--><button type="button" disabled class="btn_type03" onclick="updateModal('edit')">선택 수정</button><!--
						--><button type="button" disabled class="btn_type03" onclick="updateModal('delete')">선택 삭제</button><!--
					--></div>`;

					let addBtnStr = `<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>`;

					$("#groupTable_wrapper").append($(str)).prepend($(addBtnStr));
				},
				// every time DataTables performs a draw
				drawCallback: function (settings) {
					$('#groupTable_wrapper').addClass('mb-28');
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
				groupTable.rows( indexes ).nodes().to$().find("input").prop("checked", true);
				// console.log("dt---", groupTable[ type ]( indexes ).nodes())
			}).on("deselect", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn_type03");
				btn.each(function(index, element){
					if(!$(this).is(":disabled")){
						$(this).prop("disabled", true);
					}
				});
				groupTable.rows( indexes ).nodes().to$().find("input").prop("checked", false);
				// console.log("dt---", groupTable[ type ]( indexes ).nodes())
			}).columns.adjust();
			// groupTable.on( 'order.dt search.dt', function () {
			// 	groupTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
			// 		cell.innerHTML = i+1;
			// 		$(cell).data("id", i)
			// 	});
			// }).draw();

			$('#groupTable').find("input:checkbox").on('click', function() {
				var $box = $(this);
				if ($box.is(":checked")) {
					var group = "input:checkbox[name='" + $box.attr("name") + "']";
					$(group).prop("checked", false);
					$box.prop("checked", true);
				} else {
					$box.prop("checked", false);
				}
			});
			
			groupTable.on( 'column-sizing.dt', function ( e, settings ) {
				$(".dataTables_scrollHeadInner").css( "width", "100%" );
			});

			new $.fn.dataTable.Buttons( groupTable, {
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

			groupTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
			// groupTable.container().addClass( 'fit' );

			$("#groupSearchBox").on( 'keyup search input paste cut', function(){
				groupTable.search( this.value ).draw();
			});

		}
	}

	function nonAdminTable(groupData) {
		// 1. 그룹 유형
		// 2. 그룹 명
		// 3. 사업소
		// 4. 최종 작업자
		// 5. 비고
		// 6. 업데이트 날짜
		var groupTable = $('#groupTable').DataTable({
			"aaData": newArr,
			"table-layout": "fixed",
			"fixedHeader": true,
			"bAutoWidth": true,
			"bSearchable" : true,
			"retrieve": true,
			"sScrollY": true,
			"scrollY": "720px",
			"bScrollCollapse": true,
			"pageLength": 100,
			"aaSorting": [[ 0, 'asc' ]],
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
						return '<a class="chk_type" href="#"><input type="checkbox" id="' + rowIndex + '" name="table_checkbox"><label for="' + rowIndex + '"></label></a>'
					},
					"className": "dt-body-center no-sorting"
				},
				// {
				// 	"sTitle": "순번",
				// 	"mData": null,
				// 	"className": "dt-center no-sorting"
				// },
				{
					"sTitle": "그룹 유형",
					"mData": null,
					"mRender": function ( data, type, full, rowIndex )  {
						let groupType = "";
						if(full){
							groupType = "";
						} else {
							groupType = "";
						}

						return groupType
					},
				},
				{
					"sTitle": "그룹 명",
					"mData": "name"
				},
				{
					"sTitle": "사업소",
					"mData": "location",
				},
				{
					"sTitle": "최종작업자",
					"mData": "powerSource",
				},
				{
					"sTitle": "업데이트 일자",
					"mData": "pcsCapacity",
				},
				{
					"sTitle": "비고",
					"mData": "genCapacity",
				}
			],
			"language": {
				"emptyTable": "조회된 데이터가 없습니다.",
				"zeroRecords":  "검색된 결과가 없습니다."
			},
			"dom": 'tip',
			// "select": {
			// 	style: 'single',
			// selector: 'td:first-child > a',
			// },
			initComplete: function(){
				this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
					cell.innerHTML = i+1;
					$(cell).data("id", i);
				});
			},
		}).columns.adjust().draw();
		
		$("#groupSearchBox").on( 'keyup search input paste cut', function(){
			groupTable.columns(2).search( this.value ).draw();
		});
	}

	function drawEmptyTable(target){
		var t = target.DataTable({
			"table-layout": "fixed",
			"columnDefs": [
				{
					"searchable": false,
					"orderable": false,
					// { targets: [0, 1], visible: true},
					// { targets: '_all', visible: false },
					"targets": "_all"
				},
			],
			"columns": [
				{
					"title": "순번",
					"data": null,
					"className": "dt-center no-sorting",
				},
				{
					"title": "그룹 유형",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"title": "그룹 명",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"title": "사업소",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"title": "최종작업자",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"title": "업데이트 일자",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"sTitle": "비고",
					"mData": "genCapacity",
					"className": "dt-center no-sorting"
				},
			],
			"dom": 'tip',
			"language": {
				"emptyTable": "조회된 데이터가 없습니다.",
				"zeroRecords":  "검색된 결과가 없습니다."
			},
			initComplete: function(){
				this.addClass("no-stripe");
				if(role == 1){
					let addBtnStr = `<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>`;
					$("#groupTable_wrapper").prepend($(addBtnStr));
				}
			}
		});
	}


	function initModal(){
		let form = $("#updateGroupForm");
		let input = form.find("input");
		let dropdownBtn = form.find(".dropdown-toggle");
		let checkBox = form.find("input:checked");
		let warning = form.find(".warning");

		$("#validGroup").addClass("hidden");
		$("#newGroupName").parent().next().prop("disabled", true);
		$("#newGroupDetail").val("");
		$("#confirmGroup").val("");
		$("#shareOptGroup").addClass("hidden");
		$("#addGroupBtn").prop("disabled", true);
		$("#checkGroupBtn").prop("disabled", true); 	

		warning.addClass("hidden");

		input.each(function(){
			$(this).val("");
		});

		$.each(checkBox, function(index, element){
			$(this).prop("checked", false);
		});

		$.each(dropdownBtn, function(index, element){
			$(this).html('선택' + '<span class="caret"></span>');
			$(this).data({ "value": "", "vol-type": "", "plan-id" : "" });
			$(this).next().find("li").removeClass("hidden");
		});
		// console.log("initModal----")
	}

	function updateModal(option, callback){
		// RPS(Renewable Portfolio Standard), SMP(System Marginal Price), REC(Renewable Energy Certificate) => subsidies
		let titleAdd = $('#titleAdd');
		let newGroupType = $('#newGroupType');
		let newGroupName = $('#newGroupName');
		let form = $("#updateSiteForm");
		let required = form.find(".asterisk");
		let addBtn = $("#addGroupBtn");
		
		// ADD MODAL!!!
		if(option == "add"){
			initModal();
			if(newGroupName.parent().next().hasClass("hidden")) {
				newGroupName.parent().next().removeClass("hidden");
				newGroupName.parent().addClass("offset-width").removeClass("w-100");
			}
			titleAdd.removeClass("hidden").next().addClass("hidden");
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			addBtn.text("추가");
			$('#newGroupName').prop('disabled', false);
			$("#newVoltTypeList").prev().prop("disabled", true).data("value", "").html("선택<span class='caret'></span>");
			$("#addGroupModal").removeClass("edit").modal("show");
		} else {
			let dTable = $("#groupTable").DataTable();
			let tr = $("#groupTable").find("tbody tr.selected");
			let td = tr.find("td");
			let rowData = dTable.row(tr).data();

			$("#validGroup").is(".hidden") ? null : $("#validGroup").addClass("hidden");

			// EDIT MODAL!!!
			if(option == "edit") {
				console.log("edit modal opened===", rowData)
				addBtn.prop("disabled", false).text("수정");

				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");

				if(!newGroupName.parent().next().hasClass("hidden")) {
					newGroupName.parent().next().addClass("hidden");
					newGroupName.parent().removeClass("offset-width").addClass("w-100");
				}

				newGroupName.val( td.eq(2).text() );
				if(rowData.sgid){
					newGroupType.prev().data("value", "tag_group").html("사업소 그룹<span class='caret'></span>");
				} else if(rowData.vgid){
					newGroupType.prev().data("value", "vpp_group").html("VPP 그룹<span class='caret'></span>");
				} else if(rowData.dgid){
					newGroupType.prev().data("value", "dr_group").html("DR 그룹<span class='caret'></span>");
				}

				if(!isEmpty(td.eq(3).text())) {
					let newSiteList = $("#newSiteList");
					let siteItem = newSiteList.find("li");
					let checkBoxList = siteItem.toArray();

					let s = rowData.sites;
					let str = ``;

					$.each(s, function(index, el){ 

						let selected = checkBoxList.some( x => $(x).data("value") === el.sid );
						siteItem.find("input[data-value='" + el.sid + "']").prop("checked", true);
						str += `<li>${'${el.name}'}</li>`
						if(index === 0){
							newSiteList.prev().html(el.name + "&nbsp;외" + String(s.length-1) + "<span class='caret'></span>")
						}
					});
					$("#selectedSiteList").append(str);
				}

				$("#addGroupModal").addClass("edit").modal("show");
			}
			// DELETE MODAL!!!
			if(option == "delete") {
				let groupName = td.eq(2).text();
				let modal = $("#deleteConfirmModal");
				let deleteBtn = $("#deleteConfirmBtn");
				let confirmGroupName = $("#confirmGroup");

				$("#deleteSuccessMsg span").text(groupName);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmGroupName.on("input", function() {
					if($(this).val() !== groupName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmGroupName.on("keyup", function() {
					if($(this).val() !== groupName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});
			}
			
			if(option == "detail") {
				console.log("option---", tr)

			}
		
		}

	}

	function validateForm(){
		if(!$("#addGroupModal").hasClass('edit')){
			let grpType = $("#newGroupType").prev();
			let grpName = $("#newGroupName").val();
			let checkBtn = $("#checkGroupBtn");
			let submitBtn = $("#addGroupBtn");
			let radioGroup = $("#shareOptGroup input[type=radio][name=share_option]:checked");

			if(grpType === "tag_group") {
				if(!isEmpty(grpType.data("value")) &&  ($("#validGroup:not('.hidden')").length > 0 ) && radioGroup.length > 0 ){
					submitBtn.prop("disabled", false);
				} else {
					if(!isEmpty(grpType.data("value")) && !isEmpty(grpName)) {
						checkBtn.prop("disabled", false);
					} else {
						checkBtn.prop("disabled", true);
					}
					submitBtn.prop("disabled", true);
				}
			} else {
				if(!isEmpty(grpType.data("value")) &&  ($("#validGroup:not('.hidden')").length > 0 ) ){
					submitBtn.prop("disabled", false);
				} else {
					if(!isEmpty(grpType.data("value")) && !isEmpty(grpName)) {
						checkBtn.prop("disabled", false);
					} else {
						checkBtn.prop("disabled", true);
					}
					submitBtn.prop("disabled", true);
				}
			}
		} else {
			submitBtn.prop("disabled", false);
		}
	}

	function checkSiteId(userInput){
		if(isEmpty(userInput)) return false;
		
		$("#validGroup").addClass("hidden").parent().find(".warning").addClass("hidden");
		let name = userInput.toString();

		let groupList 
		if(!isEmpty(siteList)) {
			// console.log("siteList==", siteList)
			if(siteList.some(x => x.name == name)){
				$("#invalidGroup").removeClass("hidden");
				// console.log("match==")
			} else {
				$("#validGroup").removeClass("hidden");
				// console.log("no match==")
			}
		} else {
			$("#validGroup").removeClass("hidden");
		}
		validateForm();

	}

	// function lengthInUtf8Bytes(str) {
	// 	// Matches only the 10.. bytes that are non-initial characters in a multi-byte sequence.
	// 	var m = encodeURIComponent(str).match(/%[89ABab]/g);
	// 	return str.length + (m ? m.length : 0);
	// }

	function byteLength(str) {
		// returns the byte length of an utf8 string
		var s = str.length;
		for (var i=str.length-1; i>=0; i--) {
			var code = str.charCodeAt(i);
			if (code > 0x7f && code <= 0x7ff) s++;
			else if (code > 0x7ff && code <= 0xffff) s+=2;
			if (code >= 0xDC00 && code <= 0xDFFF) i--; //trail surrogate
		}
		return s;
	}


</script>

<c:set var="siteList" value="${siteHeaderList}"/>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">그룹 관리 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-10">
		<div class="flex_group">
			<span class="tx_tit">그룹 유형</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu" id="groupList">
					<li><a href="#">전체</a></li>
					<li data-name="사업소 그룹" data-value=""><a href="#">사업소 그룹</a></li>
					<li data-name="VPP 그룹" data-value=""><a href="#">VPP 그룹</a></li>
					<li data-name="DR 그룹" data-value=""><a href="#">DR 그룹</a></li>
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<div class="tx_inp_type">
				<input type="text" id="groupSearchBox" name="group_search_box" placeholder="키워드 검색">
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
			<table id="groupTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:9%">
					<col style="width:12%">
					<col style="width:20%">
					<col style="width:18%">
					<col style="width:18%">
					<col style="width:18%">		
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
				<h4 id="resultSuccessMsg" class="text-blue hidden">그룹 추가가 성공적으로<br>완료 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">그룹 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
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
				<h5 id="deleteSuccessMsg" class="ntit">그룹 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="tx_inp_type"><input type="text" name="confirm_group" id="confirmGroup" placeholder="사이트 이름 입력"/></div>
			</div>
			<div class="btn_wrap_type05"><!--
				--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn_type w80 ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>

<div class="modal fade" id="addGroupModal" tabindex="-1" role="dialog" aria-labelledby="addGroupModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-lg">
		<div class="modal-content group-modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1>그룹 추가<span class="required px-4 fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사업소 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_group_form" id="updateGroupForm" class="setting-form">
						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input_label asterisk">그룹 유형</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newGroupType" class="dropdown-menu">
										<li data-name="사업소 그룹" data-value="tag_group"><a href="#">사업소 그룹</a></li>
										<li data-name="VPP 그룹" data-value="vpp_group"><a href="#">VPP 그룹</a></li>
					 					<li data-name="DR 그룹" data-value="dr_group"><a href="#">DR 그룹</a></li>
									</ul>
								</div>
								<small class="hidden warning">그룹 유형을 선택해 주세요</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40 hidden"><span class="input_label">거래 ID</span></div>
							<div id="resIdWrapper" class="col-xl-4 col-lg-4 col-md-4 col-sm-12 hidden">
								<div class="tx_inp_type"><input type="text" id="newResId" name="new_res_id" /></div>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input_label asterisk">그룹 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="flex_start">
									<div class="tx_inp_type offset-width">
										<input type="text" name="new_group_name" id="newGroupName" placeholder="입력" minlength="2" maxlength="15">
									</div>
									<button type="button" id="checkGroupBtn" class="btn_type fr" disabled>중복 체크</button>
								</div>
								<small class="hidden warning">추가하실 그룹을 입력해 주세요</small>
								<small class="hidden warning">2~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidGroup" class="hidden warning">이미 등록되어 있는 그룹 입니다.</small>
								<small id="validGroup" class="text-blue text-sm hidden">추가 가능한 그룹 입니다.</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40 hidden"><span class="input_label asterisk">그룹 공유</span></div>
							<div id="shareOptGroup" class="col-xl-4 col-lg-4 col-md-4 col-sm-12 hidden">
								<div class="rdo_type flex_start">
									<div class="radio-group">
										<input type="radio" id="shareOpt1" name="share_option" data-value="1">
										<label for="shareOpt1">예</label>
									</div>
									<div class="radio-group">
										<input type="radio" id="shareOpt2" name="share_option" data-value="0">
										<label for="shareOpt2">아니오</label>
									</div>
								</div>
								<small class="hidden warning">그룹 공유 값을 선택해 주세요.</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input_label">사업소 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newSiteList" class="dropdown-menu chk_type">
										<c:forEach var="site" items="${siteList}" varStatus="siteName">
											<li data-id="${site.name}" data-value="${site.sid}">
												<a href="#" class="chk_type" tabindex="-1">
													<input type="checkbox" name="${site.name}" id="${site.name}" data-value="${site.sid}"/>
													<label for="${site.name}" class="on"><c:out value="${site.name}"></c:out></label>
												</a>
											</li>
										</c:forEach>
									</ul>
								</div>
								<!-- <small class="hidden warning">사업소를 선택해 주세요</small> -->
							</div>

							<div class="col-xl-6 col-lg-6 col-md-6 col-sm-12">
								<ul id="selectedSiteList" class="selected-list"></ul>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input_label">추가 정보</span></div>
							<div class="col-xl-10 col-lg-10 col-md-10 col-sm-12">
								<textarea name="new_site_desc" id="newGroupDetail" class="textarea" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn_wrap_type02">
									<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addGroupBtn" class="btn_type" disabled>추가</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
