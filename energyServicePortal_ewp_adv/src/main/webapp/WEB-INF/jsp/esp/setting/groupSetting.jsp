<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	$(function () {
		// let s = JSON.parse('${siteList}');
		// console.log("siteList---", s);
		initModal();
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
			let resIdWrapper = $("#resIdWrapper");
			let newResId = $("#newResId");
			let radioWarning = shareOpt.find(".warning");
			let radioGroup = shareOpt.find('input[type=radio][name=share_option]');

			groupType.prev().data({ "value" : val, "name" : name });
			newGroupWarning.addClass("hidden");

			$("#validGroup").addClass("hidden");

			if(val == "tag_group"){
				shareOpt.removeClass("hidden").prev().removeClass("hidden");
				if( !$("#shareOpt1").is(":checked") && !$("#shareOpt2").is(":checked") ) {
					radioWarning.removeClass("hidden");
				}
				resIdWrapper.addClass("hidden").prev().addClass("hidden");
				newResId.val("");
			} else {
				shareOpt.addClass("hidden").prev().addClass("hidden");
				radioGroup.prop("checked", false);
				resIdWrapper.removeClass("hidden").prev().removeClass("hidden");
				if(val == "vpp_group"){
					resIdWrapper.prev().find(".input-label").text("거래 ID");
				}
				// else {
					// resIdWrapper.prev().find(".input-label").text("자원 ID");
				// }
			}

			if( !isEmpty($("#newGroupName").val()) ){
				$("#checkGroupBtn").prop("disabled", false);
			}		
			validateForm();
		});

		$("#shareOptGroup input[type=radio][name=share_option]").on("change", function(){
			$("#shareOptGroup").find(".warning").addClass("hidden");
			validateForm();
		});

		$("#groupList li").on( 'click', function(){
			if(!isEmpty($(this).data("name"))){
				filterColumn( "#groupTable", "1", $(this).data("name"));
				let tr = $("#groupTable").find("tbody tr.selected");
				let btn = $("#btnGroup").find(".btn-type03");
				console.log("tr===", tr.length)
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
				filterColumn("#groupTable", "1", "");
			}
		});

		// Validations
		$("#newResId").on('input', function() {
			if($(this).val() == "") {
				$("#resIdWrapper").find(".warning").removeClass("hidden");
			} else {
				$("#resIdWrapper").find(".warning").addClass("hidden");
			}
		});

		$("#newResId").on('keyup', validateForm);	

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
			if($(this).hasClass("edit")){
				$(this).removeClass("edit");
			}
			$("#validGroup").addClass("hidden");
			initModal();
		});
	
		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			$("#confirmGroupName").val("");
			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">그룹 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#deleteConfirmBtn").prop("disabled", true);
			setTimeout(function(){
				$(this).find(".modal-body").removeClass("hidden");
			}, 1600);
		});

		$("#resultModal").on("hide.bs.modal", function() {
			// console.log("resultModal closed===");
			$(this).find("h4").addClass("hidden");
		});


		// Form Submission
		$("#updateGroupForm").on("submit", function(e){
			e.preventDefault();
			let obj = {};
			let newGroupType = $("#newGroupType").prev().data("value");
			let newGroupName = $("#newGroupName").val();
			let newResId = $("#newResId").val();
			let shareOption =  $("#shareOptGroup input[type=radio]:checked"); 
			let siteNameStr = $("#newSiteList").find("input:checked");
			let newGroupDesc = $("#newGroupDesc").val();
			let selectedSiteId = $("#newSiteList input:checked");
			let siteArr = [];

			// 1. Add group info
			if(!$("#addGroupModal").hasClass("edit")) {
				obj.name = newGroupName;
				if(!isEmpty(newGroupDesc)){
					obj.description = newGroupDesc;
				}
				obj.updatedBy = loginId + ":" + loginName;

				if(newGroupType == "tag_group"){
					if(shareOption.data("value") == "1"){
						obj.shared = true;
					} else {
						obj.shared = false;
					}
					let option = {
						url:  apiHost + "/config/site_groups?uid=" + userInfoId,
						type: 'post',
						async: true,
						dataType: 'json',
						contentType: 'application/json; charset=UTF-8',
						data: JSON.stringify(obj)
					}

					Promise.resolve(returnAjaxRes(option)).then(res => {
						if(!isEmpty(res)){
							$.each(selectedSiteId, function(index, el){
								siteArr.push($(this).data("value") );
							});
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
								$("#resultSuccessMsg").text("사이트 그룹이 추가 되었습니다.").removeClass("hidden");
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
				} else {
					obj.resourceId = newResId;
					if(newGroupType == "vpp_group"){
						let option = {
							url:  apiHost + "/config/vpp-groups?oid=" + oid,
							type: 'post',
							async: true,
							dataType: 'json',
							contentType: 'application/json; charset=UTF-8',
							data: JSON.stringify(obj)
						}

						Promise.resolve(returnAjaxRes(option)).then(res => {
							if(!isEmpty(res)){
								let promises = [];
								let vgid = res.vgid;
								if(selectedSiteId.length > 0){
									$.each(selectedSiteId, function(index, el){
										// console.log("el---", $(this).data("value"))
										let siteObj = {
											vpp_group_id: vgid
										};

										let siteOpt = {
											url: apiHost + "/config/sites/" + $(this).data("value"),
											type: 'patch',
											async: true,
											contentType: 'application/json; charset=UTF-8',
											data: JSON.stringify(siteObj),
										};
										promises.push(Promise.resolve(returnAjaxRes(siteOpt)));
									});
									return Promise.all(promises).then(finalRes => {
										$("#addGroupModal").modal("hide");
										$("#resultSuccessMsg").text("VPP(중개 거래) 그룹이 추가 되었습니다.").removeClass("hidden");
										$("#resultBtn").parent().addClass("hidden");
										$("#resultModal").modal("show");
										getGroupData(initModal);
										setTimeout(function(){
											$("#resultModal").modal("hide");
										}, 1600);
									});								
								}
							}
						});
					}
					
					// if (newGroupType == "dr_group"){
					// 	let option = {
					// 		url: apiHost + "/config/dr-groups?oid=" + oid,
					// 		type: 'post',
					// 		async: true,
					// 		dataType: 'json',
					// 		contentType: "application/json",
					// 		data: JSON.stringify(obj)
					// 	}

					// 	Promise.resolve(returnAjaxRes(option)).then(res => {
					// 		if(!isEmpty(res)){
					// 			let promises = [];
					// 			let dgid = res.dgid;
					// 			if(selectedSiteId.length > 0){
					// 				$.each(selectedSiteId, function(index, el){
					// 					let siteObj = {
					// 						dr_group_id: dgid
					// 					};

					// 					let siteOpt = {
					// 						url: apiHost + "/config/sites/" + $(this).data("value"),
					// 						type: 'patch',
					// 						async: true,
					// 						contentType: 'application/json; charset=UTF-8',
					// 						data: JSON.stringify(siteObj),
					// 					};
					// 					promises.push(Promise.resolve(returnAjaxRes(siteOpt)));
					// 				});
					// 				return Promise.all(promises).then(finalRes => {
					// 					$("#addGroupModal").modal("hide");
					// 					$("#resultSuccessMsg").text("DR 그룹이 추가 되었습니다.").removeClass("hidden");
					// 					$("#resultBtn").parent().addClass("hidden");
					// 					$("#resultModal").modal("show");
					// 					getGroupData(initModal);
					// 					setTimeout(function(){
					// 						$("#resultModal").modal("hide");
					// 					}, 1600);
					// 				});								
					// 			}
					// 		}
					// 	});
					// }	
				
				
				}
			// 2. Edit existing user info
			} else {
				let dTable = $("#groupTable").DataTable();
				let tr = $("#groupTable").find("tbody tr.selected");
				let td = tr.find("td");
				let rowData = dTable.row(tr).data();
			
				let updatedBy = "";

				if(!isEmpty(rowData.updatedBy)){
					updatedBy = rowData.updatedBy.split(":")[0];
				}
				if(newGroupName != td.eq(2).text() ){
					obj.name = newGroupName;
				}
				if(rowData.description != newGroupDesc){
					obj.description = newGroupDesc;
				}
				if( updatedBy != loginId ){
					obj.updatedBy = loginId + ":" + loginName;
				}

				if(newGroupType === "tag_group"){
					if(rowData.shared == true){
						$("#shareOpt2").is(":checked");
						obj.shared = false;
					} else if(rowData.shared == false){
						$("#shareOpt1").is(":checked");
						obj.shared = true;
					} else {
						obj.shared = false;
					}
					let editOptionList = [
						{
							url:  apiHost + "/config/site_groups/" + rowData.sgid,
							type: 'get',
							async: true
						},
						{
							url:  apiHost + "/config/site_groups/" + rowData.sgid,
							type: 'patch',
							async: true,
							dataType: 'json',
							contentType: 'application/json; charset=UTF-8',
							data: JSON.stringify(obj)
						}
					];

					Promise.all([ returnAjaxRes(editOptionList[0]), returnAjaxRes(editOptionList[1]) ]).then( res => {	
						if(!isEmpty(res[0].group_sites)){
							let deletePromises = [];
							let groupSites = res[0].group_sites;
							$.each(groupSites, function(index, el) {
								let gSidOption = {
									url:  apiHost + "/config/group_sites/" + el.gsid,
									type: 'delete',
									async: true,
								}
								deletePromises.push(Promise.resolve(returnAjaxRes(gSidOption)));
							});

							Promise.all(deletePromises).then(res => {
								console.log("delete promise done===", res);
								if(!isEmpty(siteNameStr)){
									let newSiteArr = [];
									$.each(siteNameStr, function(index, el){
										newSiteArr.push($(this).data("value"));
									});
									let siteObj = {
										sid: JSON.stringify(newSiteArr)
									};
									let siteOpt = {
										url: apiHost + "/config/group_sites?sgid=" + rowData.sgid,
										type: 'post',
										async: true,
										data: JSON.stringify(siteObj),
										contentType: 'application/json; charset=UTF-8'
									};
									Promise.resolve(returnAjaxRes(siteOpt)).then( finalRes => {
										console.log("finalRes===", finalRes);
										$("#addGroupModal").modal("hide");
										$("#resultSuccessMsg").text("그룹 정보가 수정 되었습니다.").removeClass("hidden");
										$("#resultBtn").parent().addClass("hidden");
										$("#resultModal").modal("show");
										getGroupData(initModal);
										setTimeout(function(){
											$("#resultModal").modal("hide");
										}, 1600);
									});

								} else {
									$("#addGroupModal").modal("hide");
									$("#resultSuccessMsg").text("그룹 정보가 수정 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									getGroupData(initModal);
									setTimeout(function(){
										$("#resultModal").modal("hide");
									}, 1600);
								}
							});
						} else {
							if(!isEmpty(siteNameStr)){
								let newSiteArr = [];
								$.each(siteNameStr, function(index, el){
									newSiteArr.push($(this).data("value"));
								});
								let siteObj = {
									sid: JSON.stringify(newSiteArr)
								};
								let siteOpt = {
									url: apiHost + "/config/group_sites?sgid=" + rowData.sgid,
									type: 'post',
									async: true,
									data: JSON.stringify(siteObj),
									contentType: 'application/json; charset=UTF-8'
								};
								Promise.resolve(returnAjaxRes(siteOpt)).then( finalRes => {
									console.log("finalRes===", finalRes);
									$("#addGroupModal").modal("hide");
									$("#resultSuccessMsg").text("그룹 정보가 수정 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									getGroupData(initModal);
									setTimeout(function(){
										$("#resultModal").modal("hide");
									}, 1600);
								});								
							} else {
								$("#addGroupModal").modal("hide");
								$("#resultSuccessMsg").text("그룹 정보가 수정 되었습니다.").removeClass("hidden");
								$("#resultBtn").parent().addClass("hidden");
								$("#resultModal").modal("show");
								getGroupData(initModal);
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1600);
							}
						}
					
					});
				} else {
					if(rowData.resourceId != newResId){
						obj.resourceId = newResId;
					}

					if(newGroupType === "vpp_group"){
						let editOption = {
							url:  apiHost + "/config/vpp-groups/" + rowData.vgid,
							type: 'patch',
							async: true,
							dataType: 'json',
							contentType: 'application/json; charset=UTF-8',
							data: JSON.stringify(obj)
						}

						Promise.resolve(returnAjaxRes(editOption)).then(res => {
							let sitePromises = [];
							$.each(rowData.sites, function(index, el){
								// newSiteArr.push($(this).data("value"));
								let emptyObj = {
									vpp_group_id : null
								}
								let option = {
									url: apiHost + "/config/sites/" + el.sid,
									type: 'patch',
									async: true,
									contentType: 'application/json; charset=UTF-8',
									data: JSON.stringify(emptyObj),
								}
								sitePromises.push(Promise.resolve(returnAjaxRes(option)));
							});

							Promise.all(sitePromises).then( res => {
								let newSitePromises = [];
								$.each(siteNameStr, function(index, el){
									// newSiteArr.push($(this).data("value"));
									let siteObj = {
										vpp_group_id: rowData.vgid
									}
									let option = {
										url: apiHost + "/config/sites/" + $(this).data("value"),
										type: 'patch',
										async: true,
										contentType: 'application/json; charset=UTF-8',
										data: JSON.stringify(siteObj),
									}
									newSitePromises.push(Promise.resolve(returnAjaxRes(option)));
								});
								Promise.all(newSitePromises).then( finalRes => {
									$("#addGroupModal").modal("hide");
									$("#resultSuccessMsg").text("그룹 정보가 수정 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									getGroupData(initModal);
									setTimeout(function(){
										$("#resultModal").modal("hide");
									}, 1600);
								});
							});
						});
					}
					
					// if(newGroupType === "dr_group"){
					// 	let editOption = {
					// 		url:  apiHost + "/config/dr-groups/" + rowData.dgid,
					// 		type: 'patch',
					// 		async: true,
					// 		dataType: 'json',
					// 		contentType: 'application/json; charset=UTF-8',
					// 		data: JSON.stringify(obj)
					// 	}

					// 	Promise.resolve(returnAjaxRes(editOption)).then(res => {
					// 		let sitePromises = [];
					// 		$.each(rowData.sites, function(index, el){
					// 			// newSiteArr.push($(this).data("value"));
					// 			let emptyObj = {
					// 				dr_group_id: null
					// 			}
					// 			let option = {
					// 				url: apiHost + "/config/sites/" + el.sid,
					// 				type: 'patch',
					// 				async: true,
					// 				contentType: 'application/json; charset=UTF-8',
					// 				data: JSON.stringify(emptyObj),
					// 			}
					// 			sitePromises.push(Promise.resolve(returnAjaxRes(option)));
					// 		});

					// 		Promise.all(sitePromises).then( res => {
					// 			let newSitePromises = [];
					// 			$.each(siteNameStr, function(index, el){
					// 				// newSiteArr.push($(this).data("value"));
					// 				let siteObj = {
					// 					dr_group_id: rowData.dgid
					// 				}
					// 				let option = {
					// 					url: apiHost + "/config/sites/" + $(this).data("value"),
					// 					type: 'patch',
					// 					async: true,
					// 					contentType: 'application/json; charset=UTF-8',
					// 					data: JSON.stringify(siteObj),
					// 				}
					// 				newSitePromises.push(Promise.resolve(returnAjaxRes(option)));
					// 			});
					// 			Promise.all(newSitePromises).then( finalRes => {
					// 				$("#addGroupModal").modal("hide");
					// 				$("#resultSuccessMsg").text("그룹 정보가 수정 되었습니다.").removeClass("hidden");
					// 				$("#resultBtn").parent().addClass("hidden");
					// 				$("#resultModal").modal("show");
					// 				getGroupData(initModal);
					// 				setTimeout(function(){
					// 					$("#resultModal").modal("hide");
					// 				}, 1600);
					// 			});
					// 		});
					// 	});


					// }
				
				
				}

			}

		});


		// WORK IN PROGRESS!!!!!!!!!!!!!!!
		$("#deleteConfirmBtn").click(function(){
			let dTable = $("#groupTable").DataTable();
			let tr = $("#groupTable").find("tbody tr.selected");
			let td = tr.find("td");
			let rowData = dTable.row(tr).data();
			let gsid = rowData.sid;
			let modalBody = $("#deleteConfirmModal .modal-body");
			let optDelete = {};

			if(	$("#confirmGroupName").val() != td.eq(2).text()) return false;

			if(rowData.sgid){
				optDelete = {
					// url: apiHost + "/config/group_sites/" + rowData.sgid,
					url: apiHost + "/config/site_groups/" + rowData.sgid,
					type: "delete",
					async: true,
				}
			} else if(rowData.vgid){
				optDelete = {
					url: apiHost + "/config/vpp-groups/" + rowData.vgid,
					type: "delete",
					async: true,
				} 
			} else if(rowData.dgid){
				optDelete = {
					url: apiHost + "/config/dr-groups/" + rowData.dgid,
					type: "delete",
					async: true,
				}
			}

			Promise.resolve(returnAjaxRes(optDelete)).then( res => {
				Promise.resolve(dTable.row(tr).remove().draw()).then( res => {
					modalBody.addClass("hidden");
					$("#deleteSuccessMsg").text("사이트가 삭제 되었습니다.").removeClass("hidden");
					// refreshSiteList();
					setTimeout(function(){
						$("#deleteConfirmModal").modal("hide");
					}, 1000);
				});

			});
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
			// flat = [...res.dr_group, ...res.vpp_group, ...res.tag_group];
			flat = [...res.vpp_group, ...res.tag_group];
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

				}
				
				// else if(group === "dr_group"){
				// 	// console.log("dr_group===", res.dr_group )
				// 	if(res.dr_group.some(x => x.name == name)){
				// 		$("#invalidGroup").removeClass("hidden");
				// 	} else {
				// 		$("#validGroup").removeClass("hidden");
				// 	}
				// }
				setTimeout(function(){
					validateForm();
				}, 200);

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
			// 5. 업데이트 날짜
			// 6. 비고
			var groupTable = $('#groupTable').DataTable({
				"aaData": groupData,
				"table-layout": "fixed",
				"fixedHeader": true,
				"autoWidth": true,
				"bAutoWidth": true,
				"bSearchable" : true,
				// "retrieve": true,
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
						"sTitle": "그룹 유형",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let groupType = "";
							// if(full.dgid){
							// 	return groupType = "DR 그룹";
							// } else if(full.vgid){
							// 	return groupType = "VPP 그룹";
							// } else if(full.sgid){
							// 	return groupType = "사업소 그룹";
							// }
							if(full.vgid){
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
								let length = full.sites.length;

								$.each(full.sites, function(index, el){
									if(length <= 3){
										if(index < (length-1) ){
											siteName += el.name + "," + '&ensp;';
										} else {
											siteName += el.name;
										}
									} else {
										if(index < 3 ){
											siteName += el.name + "," + '&ensp;';
										} else {
											if(index == 3) {
												siteName += el.name.slice(0, -3) + "..."
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

								if(full.sites.length > 3){
									// onmouseover="updateModal('detail', this)" 
									return `<div class="flex-start">${'${siteName}'}&ensp;<a href="#" role="button" data-toggle="popover" data- rel="popover" onmouseover="updateModal('detail', this)" class="text-link">more</a></div>`
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
								let str = full.updatedBy.split(":");
								updatedBy = str[0] + " (" + str[1] + ")";
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
							if(isEmpty(full.updatedAt)){
								if(!isEmpty(full.createdAt)){
									date = new Date(full.createdAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(full.createdAt).toLocaleTimeString();
								} else {
									date = "-";
								}
							} else {
								date = new Date(full.updatedAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(full.updatedAt).toLocaleTimeString();
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
								desc = full.description;
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
					selector: 'td input[type="checkbox"], tr',
					// selector: 'td input[type="checkbox"], td:not(:last-of-type)'
				},
				initComplete: function(settings, json ){
					// console.log("init settings---", settings)
					let str = `<div id="btnGroup" class="right-end"><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')">선택 수정</button><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')">선택 삭제</button><!--
					--></div>`;

					let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')">추가</button>`;

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
				let btn = $("#btnGroup").find(".btn-type03");
				btn.each(function(index, element){
					if($(this).is(":disabled")){
						$(this).prop("disabled", false);
					}
				});
				groupTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
				// console.log("dt---", groupTable[ type ]( indexes ).nodes())
			}).on("deselect", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn-type03");
				btn.each(function(index, element){
					if(!$(this).is(":disabled")){
						$(this).prop("disabled", true);
					}
				});
				groupTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
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
						className: "btn-save",
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
		// 5. 업데이트 날짜
		// 6. 비고
		var groupTable = $('#groupTable').DataTable({
			"aaData": groupData,
			"table-layout": "fixed",
			"fixedHeader": true,
			"bAutoWidth": true,
			"bSearchable" : true,
			// "retrieve": true,
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
						return '<a class="chk-type" href="#"><input type="checkbox" id="' + rowIndex + '" name="table_checkbox"><label for="' + rowIndex + '"></label></a>'
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
						// if(full.dgid){
						// 	return groupType = "DR 그룹";
						// } else if(full.vgid){
						// 	return groupType = "VPP 그룹";
						// } else if(full.sgid){
						// 	return groupType = "사업소 그룹";
						// }

						if (full.vgid){
							return groupType = "VPP 그룹";
						} else if(full.sgid){
							return groupType = "사업소 그룹";
						}
					},
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
							let length = full.sites.length;

							$.each(full.sites, function(index, el){
								if(length <= 3){
									if(index < (length-1) ){
										siteName += el.name + "," + '&ensp;';
									} else {
										siteName += el.name;
									}
								} else {
									if(index < 3 ){
										siteName += el.name + "," + '&ensp;';
									} else {
										if(index == 3) {
											siteName += el.name.slice(0, -3) + "..."
										}
									}
								}
							});
							if(full.sites.length > 3){
								return `<div class="flex-start">${'${siteName}'}&ensp;<a href="#" role="button" data-toggle="popover" data- rel="popover" onmouseover="updateModal('detail', this)" class="text-link">more</a></div>`
							} else {
								return siteName;
							}

						} else {
							return siteName = "-";
						}

					}
				},
				{
					"sTitle": "업데이트 일자",
					"mData": null,
					"mRender": function ( data, type, full, rowIndex )  {
						let date = "";
						if(isEmpty(full.updatedAt)){
							if(!isEmpty(full.createdAt)){
								date = new Date(full.createdAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(full.createdAt).toLocaleTimeString();
							} else {
								date = "-";
							}
						} else {
							date = new Date(full.updatedAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(full.updatedAt).toLocaleTimeString();
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
							desc = full.description;
						} else {
							desc = "-";
						}
						return desc;
					}
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
			// initComplete: function(){
			// 	this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
			// 		cell.innerHTML = i+1;
			// 		$(cell).data("id", i);
			// 	});
			// },
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
					let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')">추가</button>`;
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
		$("#newGroupDesc").val("");
		$("#confirmGroupName").val("");
		$("#shareOptGroup").addClass("hidden").prev().addClass("hidden");
		$("#shareOptGroup").addClass("hidden").prev().addClass("hidden");

		$("#addGroupBtn").prop("disabled", true);
		$("#checkGroupBtn").prop("disabled", true); 	

		warning.addClass("hidden");

		input.each(function(){
			$(this).val("");
		});

		$("#selectedSiteList").empty().prev().remove();

		$.each(checkBox, function(index, element){
			$(this).prop("checked", false);
		});

		$.each(dropdownBtn, function(index, element){
			$(this).prop("disabled", false).data({ "value": "", "vol-type": "", "plan-id" : "" }).html('선택' + '<span class="caret"></span>').next().find("li").removeClass("hidden");
		});
		// console.log("initModal----")
	}

	function updateModal(option, popOverLink){
		// RPS(Renewable Portfolio Standard), SMP(System Marginal Price), REC(Renewable Energy Certificate) => subsidies
		let titleAdd = $('#titleAdd');
		let form = $("#updateGroupForm");
		let required = form.find(".asterisk");
		let newGroupType = $('#newGroupType');
		let newGroupName = $('#newGroupName');
		let newGroupDesc = $("#newGroupDesc");
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
			let newSiteList = $("#newSiteList");
			let siteItem = newSiteList.find("li input[type='checkbox']");
			let resIdWrapper = $("#resIdWrapper");
			$("#validGroup").is(".hidden") ? null : $("#validGroup").addClass("hidden");

			if(option != "delete") {
				// EDIT MODAL!!!
				if(option == "edit") {
					let s = rowData.sites;
					let checkBoxList = siteItem.toArray();	
					let str = ``;
					let sharedStr = ``;
					let siteNameArr = [];
					let siteValArr = [];

					addBtn.prop("disabled", false).text("수정");
					titleAdd.addClass("hidden").next().removeClass("hidden");
					required.hasClass("no-symbol") ? null : required.addClass("no-symbol");
					if(rowData.description){
						newGroupDesc.val(rowData.description);
					}
					
					if(!newGroupName.parent().next().hasClass("hidden")) {
						newGroupName.parent().next().addClass("hidden");
						newGroupName.parent().removeClass("offset-width").addClass("w-100");
					}
					newGroupName.val( td.eq(2).text() );

					if(rowData.sgid){
						let sharedOpt = '';
						let shareOptGroup = $("#shareOptGroup");
						newGroupType.prev().data("value", "tag_group").html("사업소 그룹<span class='caret'></span>").prop("disabled", true);
						shareOptGroup.find(".warning").addClass("hidden");
						shareOptGroup.removeClass("hidden").prev().removeClass("hidden");
						resIdWrapper.addClass("hidden").prev().addClass("hidden");

						if(!isEmpty(td.eq(3).text())) {
							let checkBoxList = siteItem.toArray();

							if(rowData.shared == true){
								sharedOpt = "(공유)";
								$("#shareOpt1").prop("checked", true);
							} else {
								sharedOpt = "(미공유)";
								$("#shareOpt2").prop("checked", true);
							}
							sharedStr = `<span class="input-label list-label">등록된 사이트 리스트&ensp;${'${sharedOpt}'}</span>`;
					

							$.each(s, function(index, el){
								let found = checkBoxList.findIndex( x => $(x)[0].id == el.name );
								if(found > -1){
									$(checkBoxList[found]).prop("checked", true);
								}
								str += `<li data-name="${'${el.name}'}">${'${el.name}'}</li>`
								siteValArr.push(el.sid);
								siteNameArr.push(el.name);

								if(index === 0){
									if( s.length > 1) {
										newSiteList.prev().html(el.name + "&nbsp;외" + String(s.length-1) + "<span class='caret'></span>");
									} else {
										newSiteList.prev().html(el.name + "<span class='caret'></span>");
									}
									
								}
							});
							newSiteList.prev().data({ "value" : siteValArr.join(","), "name" : siteNameArr.join(",") })
							$("#selectedSiteList").append(str).parent().prepend(sharedStr);
						}
					} else {
						if(!isEmpty(rowData.resourceId)) {
							$("#newResId").val(rowData.resourceId);
						}
						if(!isEmpty(td.eq(3).text())) {
							$.each(s, function(index, el){
								let found = checkBoxList.findIndex( x => $(x)[0].id == el.name );
								if(found > -1){
									$(checkBoxList[found]).prop("checked", true);
								}
								str += `<li data-name="${'${el.name}'}">${'${el.name}'}</li>`
								siteValArr.push(el.sid);
								siteNameArr.push(el.name);

								if(index === 0){
									if( s.length > 1) {
										newSiteList.prev().html(el.name + "&nbsp;외" + String(s.length-1) + "<span class='caret'></span>");
									} else {
										newSiteList.prev().html(el.name + "<span class='caret'></span>");
									}
									
								}
							});
							newSiteList.prev().data({ "value" : siteValArr.join(","), "name" : siteNameArr.join(",") })
							$("#selectedSiteList").append(str).parent().prepend(sharedStr);
						}

						if (rowData.vgid){
							resIdWrapper.removeClass("hidden").prev().removeClass("hidden").find(".input-label").text("거래 ID");
							newGroupType.prev().data("value", "vpp_group").html("VPP 그룹<span class='caret'></span>").prop("disabled", true);

						}
						// else if(rowData.dgid){
						// 	resIdWrapper.removeClass("hidden").prev().removeClass("hidden").find(".input-label").text("자원 ID");
						// 	newGroupType.prev().data("value", "dr_group").html("DR 그룹<span class='caret'></span>").prop("disabled", true);
						
						// }
					}

					$("#addGroupModal").addClass("edit").modal("show");
				} else {
					// PopOver content setup
					let popOverRow = $(popOverLink).parents().closest("tr");
					let popOverRowData = dTable.row(popOverRow).data();
					let groupType = "";
					let groupName = td.eq(2).text();
					let checkBoxList = siteItem.toArray();
					let popOverSites = popOverRowData.sites;
					let desc = "";

					if(popOverRowData.sgid){
						groupType = "사업소 그룹";
					} else if(popOverRowData.vgid){
						groupType = "VPP 그룹";
					}
					
					// else if(popOverRowData.dgid){
					// 	groupType = "DR 그룹";
					// }
					let title = '';
					if(popOverRowData.shared == false){
						title = "사업소 상세 정보 (공유)"
					} else {
						title = "사업소 상세 정보 (미공유)"
					}
					let popOverStr = '';
					$.each(popOverSites, function(index, el){ 
						let selected = checkBoxList.some( x => $(x).data("value") === el.sid );
						popOverStr += '<li>' + el.name + '</li>';
					});
					let content = '<ul class="selected-list">' + popOverStr + '</ul>';
				
					// <h4 class="sm-title">그룹 유형 : ${'${groupType}'}</h4>
					// 	<h4 class="sm-title">그룹 명 : ${'${groupName}'}</h4>	
					// 	<h4 class="sm-title">사업소 명</h4>
					// <h4 class="sm-title">추가 정보 : ${'${popOverRowData.description}'}</h4>	

					// $(popOverLink).attr(template).popover('show');
					// $(popOverLink).popover('show');

					var popWindow = $(popOverLink).popover({
						container: "body",
						placement : 'right',
						html: 'true',
						trigger: "manual",
						// "focus", "manual", "focus", "hover"
						animation: false,
						title: title,
						content: content
					}).on("mouseover", function () {
						var _this = this;
						$(this).popover("show");
						$(this).siblings(".popover").on("mouseleave", function () {
							$(_this).popover('hide');
						});
					}).on("mouseleave", function(){
						var _this = this;
						setTimeout(function() {
							if (!$(".popover:hover").length) {
							$(_this).popover("hide");
							}
						}, 300);
					});

					popWindow.popover("show");

				}
			} else {
				// DELETE MODAL!!!
				let groupName = td.eq(2).text();
				let modal = $("#deleteConfirmModal");
				let deleteBtn = $("#deleteConfirmBtn");
				let confirmGroupName = $("#confirmGroupName");

				$("#deleteSuccessMsg span").text(groupName);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmGroupName.on("input", function() {
					if($(this).val() != groupName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmGroupName.on("keyup", function() {
					$(this).val().replace(/\s*$/,"");

					if($(this).val() != groupName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});
			}
		}
	}
	
	function validateForm(){
		let grpType = $("#newGroupType").prev();
		let grpName = $("#newGroupName").val();
		let newResId = $("#newResId").val();
		let checkBtn = $("#checkGroupBtn");
		let submitBtn = $("#addGroupBtn");
		let radioGroup = $("#shareOptGroup input[type=radio][name=share_option]:checked");

		if(!$("#addGroupModal").hasClass('edit')){
			if(grpType.data("value") === "tag_group") {
				if(!isEmpty(grpType.data("value")) && ( $("#validGroup:not('.hidden')").length > 0 ) && ( radioGroup.length > 0 ) ){
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
				if(!isEmpty(grpType.data("value")) && !isEmpty(newResId) && ($("#validGroup:not('.hidden')").length > 0 ) ){
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

	function navigationType(){

		var result;
		var p;

		if (window.performance.navigation) {
			result=window.performance.navigation;
			if (result==255){result=4} // 4 is my invention!
		}

		if (window.performance.getEntriesByType("navigation")){
		p=window.performance.getEntriesByType("navigation")[0].type;

		if (p=='navigate'){result=0}
		if (p=='reload'){result=1}
		if (p=='back_forward'){result=2}
		if (p=='prerender'){result=3} //3 is my invention!
		}
		return result;
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
		<div class="flex-group">
			<span class="tx-tit">그룹 유형</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk-type" role="menu" id="groupList">
					<li><a href="#">전체</a></li>
					<li data-name="사업소 그룹" data-value=""><a href="#">사업소 그룹</a></li>
					<li data-name="VPP 그룹" data-value=""><a href="#">VPP 그룹</a></li>
					<!-- <li data-name="DR 그룹" data-value=""><a href="#">DR 그룹</a></li> -->
				</ul>
			</div>
		</div>
		<div class="flex-group">
			<div class="text-input-type">
				<input type="text" id="groupSearchBox" name="group_search_box" placeholder="키워드 검색">
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
			<table id="groupTable">
				<colgroup>
					<col style="width:4%">
					<col style="width:9%">
					<col style="width:10%">	
					<col style="width:24%">
					<col style="width:16%">
					<col style="width:18%">
					<col style="width:17%">	
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
				<h5 id="deleteSuccessMsg" class="ntit">그룹 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" name="confirm_group" id="confirmGroupName" placeholder="사이트 이름 입력"/></div>
			</div>
			<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn-type w80 ml-12" disabled>확인</button><!--
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
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label asterisk">그룹 유형</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newGroupType" class="dropdown-menu">
										<li data-name="사업소 그룹" data-value="tag_group"><a href="#">사업소 그룹</a></li>
										<li data-name="VPP 그룹" data-value="vpp_group"><a href="#">VPP 그룹</a></li>
					 					<!-- <li data-name="DR 그룹" data-value="dr_group"><a href="#">DR 그룹</a></li> -->
									</ul>
								</div>
								<small class="hidden warning">그룹 유형을 선택해 주세요</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40 hidden"><span class="input-label asterisk">거래 ID</span></div>
							<div id="resIdWrapper" class="col-xl-4 col-lg-4 col-md-4 col-sm-12 hidden">
								<div class="text-input-type"><input type="text" id="newResId" name="new_res_id" /></div>
								<small class="hidden warning">거래 ID를 입력해 주세요.</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label asterisk">그룹 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="flex-start">
									<div class="text-input-type offset-width">
										<input type="text" name="new_group_name" id="newGroupName" placeholder="입력" minlength="2" maxlength="15">
									</div>
									<button type="button" id="checkGroupBtn" class="btn-type fr" disabled>중복 체크</button>
								</div>
								<small class="hidden warning">추가하실 그룹을 입력해 주세요</small>
								<small class="hidden warning">2~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidGroup" class="hidden warning">이미 등록되어 있는 그룹 입니다.</small>
								<small id="validGroup" class="text-blue text-sm hidden">추가 가능한 그룹 입니다.</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40 hidden"><span class="input-label asterisk">그룹 공유</span></div>
							<div id="shareOptGroup" class="col-xl-4 col-lg-4 col-md-4 col-sm-12 hidden">
								<div class="radio-type flex-start">
									<div class="radio-group">
										<input type="radio" id="shareOpt1" name="share_option" data-value="1" data-option-val="true">
										<label for="shareOpt1">예</label>
									</div>
									<div class="radio-group">
										<input type="radio" id="shareOpt2" name="share_option" data-value="0" data-option-val="false">
										<label for="shareOpt2">아니오</label>
									</div>
								</div>
								<small class="hidden warning">그룹 공유 값을 선택해 주세요.</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label">사업소 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newSiteList" class="dropdown-menu chk-type">
										<c:forEach var="site" items="${siteList}" varStatus="siteName">
											<li data-id="${site.name}" data-name="${site.name}" data-value="${site.sid}">
												<a href="#" class="chk-type" tabindex="-1">
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
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label">추가 정보</span></div>
							<div class="col-xl-10 col-lg-10 col-md-10 col-sm-12">
								<textarea name="new_site_desc" id="newGroupDesc" class="textarea" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addGroupBtn" class="btn-type" disabled>추가</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
