<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">

	var spcDeleteList = [];
	var siteDeleteList = [];

	$(function () {
		let copySpcList = $("#spcRow").find("template").clone().html();
		$("#spcRow").find("template").remove();

		let optionList = [
			{
				url: apiHost + "/config/users",
				type: "get",
				async: false,
				data: {
					uid: userInfoId,
					oid: oid,
					filter: JSON.stringify({
						'include': [{ 'relation': 'user_spcs' }, {  'relation': 'user_sites' }]
					})
				}
			},
			{
				url: apiHost + "/spcs?oid=" + oid + "&includeGens=false",
				type: "get",
				async: true,
			},
		];

		getCustomLevel();
		initModal();
		getUserList(optionList[0]);
		getSpcList(optionList[1], copySpcList, setDropdownValue);

		// Validation
		$("#newId").on('keydown', function() {
			$(this).val($(this).val().replace(/\s/g, ''));
		});

		$("#newId").on('input', function() {
			$("#validId").addClass("hidden");
		});

		$("#newId").on('keyup', function() {
			let warning = $("#newId").parents(".col-lg-4").find(".warning");

			if( $(this).val().match(/[^\x00-\x80]/) ){
				$(this).val("");
			}

			if( $(this).val().match(/[^\w-_]/) ) {
				warning.eq(2).removeClass("hidden");
			} else {
				warning.eq(2).addClass("hidden");
			}

			if( $(this).val().length <= 4 || $(this).val().length > 15) {
				warning.eq(1).removeClass("hidden");
			} else {
				warning.eq(1).addClass("hidden");
			}

			if( warning.not(".hidden").index() == -1 ){
				$("#newId").parent().next().prop("disabled", false);
			} else {
				$("#newId").parent().next().prop("disabled", true);
			}

		});

		$("#newUserPwd").on('input', validatePassword);

		$("#confirmNewUserPwd").keyup(function() {
			let password = $("#newUserPwd").val();
			password == $(this).val() ? $("#pwdUserMatched").addClass("hidden") : $("#pwdUserMatched").removeClass("hidden");
			let validated = $("#pwdUserMatched").hasClass("hidden");
		});

		$("#newFullName").on('input', function(evt) {
			if( $(this).val().match(/['.,!#$%&"*+/=?^`{|}~;:<>]+$/)){
				$(this).parent().next().removeClass("hidden");
				return false;
			} else {
				$(this).parent().next().addClass("hidden");
			}
		});

		$("#newFullName").on('keyup', function(evt) {
			if(!isEmpty($(this).val())){
				var kr = /[\u1100-\u11FF\u3130-\u318F\uA960-\uA97F\uAC00-\uD7AF\uD7B0-\uD7FF]/g
				let letters = /^[ a-zA-Z ]+$/
				// let kr2 =  /[\uac00-\ud7af]|[\u1100-\u11ff]|[\u3130-\u318f]|[\ua960-\ua97f]|[\ud7b0-\ud7ff]/g
				// let engKr = /[^a-zA-Z0-9\u3130-\u318F\uAC00-\uD7AF]/g

				// console.log("kr===", $(this).val().match(kr))
				// console.log("kr===", $(this).val().match(kr))
				// console.log("letters===", $(this).val().match(letters))

				if( $(this).val().match(kr) || $(this).val().match(letters)){
					$(this).parent().next().addClass("hidden");
				}
			} else {
				$(this).parent().next().removeClass("hidden");
			}
		});

		$("#newMobileNum").on('keyup', function(evt, limit) {
			if( $(this).val().match(/[^\x00-\x80]/) ){
				$(this).val("");
			}
			if(!isEmpty($(this).val())){
				if($(this).val().length >= 10) {
					$("#isValidNewMobileNum").addClass("hidden");
				} else {
					$("#isValidNewMobileNum").removeClass("hidden");
				}

			}
		});

		$("#newMobileNum").on('keypress', function(evt) {
			let val = $(this).val();
			if (evt.which < 48 || evt.which > 57) {
				return false;
			}
		});

		$("#newEmailAddr").on('input', function() {
			var input=$(this);
			var re = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
			var is_email=re.test(input.val());
			if(is_email){
				input.parent().next().addClass("hidden");
			}
			else{
				input.parent().next().removeClass("hidden");
			}
		});

		$("#updateUserForm").on("change", function(e){
			if(!$("#addUserModal").hasClass("edit")){
				if(validateAddForm() == 1) {
					$("#addUserBtn").prop("disabled", false);
				} else {
					$("#addUserBtn").prop("disabled", true);
				}
			} else {
				if(validateEditForm() == 1) {
					$("#addUserBtn").prop("disabled", false);
				} else {
					$("#addUserBtn").prop("disabled", true);
				}
			}
		});

		// Dropdown Click event
		$("#newAccLevel").find("li").on("click", function(){
			if ($(this).data('value') === 1) {
				$('#customLevelList').prev().prop('disabled', true).html("<fmt:message key='userSetting.select' />" + '<span class="caret"></span>').data("value", "");
				$('#newTaskList').prev().prop('disabled', true).html("<fmt:message key='userSetting.select' />" + '<span class="caret"></span>').data("value", "");

				if ($('.nav-tabs > li').eq(0).find('a').attr('href') == '#siteTab') {
					$('.nav-tabs > li').eq(0).addClass('hidden').removeClass('active').siblings().addClass('active');
				}

				$('#siteTab').removeClass('active').siblings().addClass('active in');
			} else {
				$('#customLevelList').prev().prop('disabled', false).html("<fmt:message key='userSetting.select' />" + '<span class="caret"></span>').data("value", "");
				$('#newTaskList').prev().prop('disabled', false).html("<fmt:message key='userSetting.select' />" + '<span class="caret"></span>').data("value", "");

				$('.nav-tabs > li').eq(0).removeClass('hidden');
			}
			// if ($(this).data('value') == '1') {
			// 	if ($('.nav-tabs > li').eq(0).find('a').attr('href') == '#siteTab') {
			// 		$('.nav-tabs > li').eq(0).addClass('hidden').removeClass('active').siblings().addClass('active');
			// 	}
			//
			// 	$('#siteTab').removeClass('active').siblings().addClass('active in');
			// } else {
			// 	$('.nav-tabs > li').eq(0).removeClass('hidden');
			// }
			//
			// if($("#addUserModal").hasClass("edit")){
			// 	if( !isEmpty($(this).data("value")) && validateEditForm() == 1) {
			// 		$("#addUserBtn").prop("disabled", false);
			// 	}
			// } else {
			// 	if( !isEmpty($(this).data("value")) && validateAddForm() == 1) {
			// 		$("#addUserBtn").prop("disabled", false);
			// 	}
			// }
		});

		// Modal event
		$("#addUserModal").on("hide.bs.modal", function(){
			$(this).hasClass("edit") ? $(this).removeClass("edit") : null;

			initModal();
			$("#selectedSiteList").empty();
			$("#selectedSpcList").empty();
			$("#validId").addClass("hidden");
		});

		$("#deleteConfirmBtn").click(function(){
			let dTable = $("#userTable").DataTable();
			let tr = $("#userTable").find("tbody tr.selected");
			let uid = dTable.row(tr).data().uid;
			let modalBody = $("#deleteConfirmModal .modal-body");
			
			let optDelete = {
				url: apiHost + "/config/users/" + uid,
				type: 'delete',
				async: true,
			}

			$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("<fmt:message key='userSetting.errorTxt.13' />").removeClass("hidden");
				refreshUserList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("fail==", jqXHR);
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("<fmt:message key='userSetting.errorTxt.14' />\n<fmt:message key='userSetting.errorTxt.15' />").removeClass("hidden");
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
			});
		});

		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			$("#deleteSuccessMsg").html("<h5 id='deleteSuccessMsg' class='ntit'><fmt:message key='userSetting.errorTxt.16' /><br><span class='text-blue'></span>&ensp;<fmt:message key='userSetting.errorTxt.17' /></h5>");
			$("#confirmUserId").val("");
			$("#deleteConfirmBtn").prop("disabled", true);
			setTimeout(function(){
				$(this).find(".modal-body").removeClass("hidden");
			}, 1500);
		});

		// Form Submission
		$("#updateUserForm").on("submit", function(e){
			e.preventDefault();

			let option = {};
			let optionPwd = {};
			let userObj = {};

			let newId = $("#newId").val();
			let newFullName = $("#newFullName").val();
			let newPwd = $("#newUserPwd").val();
			let newAccVal = Number($("#newAccLevel").prev().data("value"));
			let newAccName =$("#newAccLevel").prev().data("name");

			let newPhoneNum = $("#newMobileNum").val();
			let newAffiliation = $("#newTeam").val();
			let newEmailAddr =$("#newEmailAddr").val();
			let newTaskList = isEmpty($("#newTaskList").prev().data("value")) ? 0 : $("#newTaskList").prev().data("value");
			let newTaskName = $("#newTaskList").prev().data("name");

			let newUseOpt = $('#newUseOpt').is(':checked') ? 'Y' : 'N';
			let newUswOptName = $("#newUseOpt").prev().data("name");
			let newUserDesc = $("#newUserDesc").val();
			let department = $("#department").val();

			let siteItemList = $("#selectedSiteList").find("li");
			let spcItemList = $("#selectedSpcList").find("li");

			let customLevelYn = 'N'
			let customLevel = $('#customLevelList').prev().data('value');
			if (customLevel === 'N' || isEmpty(customLevel)) { customLevel = null; }
			else { customLevelYn = 'Y'; }

			let verify_level = $('#switchBtn').is(':checked') ? '1' : '0';

			if (verify_level === '1' && $("#newMobileNum").val() == '') {
				$('#isValidNewMobileNum').removeClass('hidden');
				return false;
			} else {
				$('#isValidNewMobileNum').addClass('hidden');
			}

			// 1. Add user info
			if(!$("#addUserModal").hasClass("edit")) {
				let resultSuccessText = "<fmt:message key='userSetting.errorTxt.18' />";
				let resultFailText = "<fmt:message key='userSetting.errorTxt.19' /><br>";

				userObj.login_id = newId;
				userObj.name = newFullName;
				userObj.password = newPwd;
				userObj.role = newAccVal;
				userObj.verify_level = Number(verify_level);
				userObj.custom_level_yn = customLevelYn;
				userObj.custom_level_id = customLevel;

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
					userObj.description = newUserDesc;
				}

				option = {
					url: apiHost + '/config/users?oid=' + oid,
					type: 'post',
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(userObj)
				}

				if( siteItemList.length <= 0 && spcItemList.length <= 0 ){
					$.ajax(option).done(function (json, textStatus, jqXHR) {
						refreshUserList();
						showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
					}).fail(function (jqXHR, textStatus, errorThrown) {
						let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
						showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
					});
				} else {
					let siteObj = {};

					$.ajax(option).done(function (json, textStatus, jqXHR) {
						let newUid = json.uid;
						let siteObj = {};

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

						if( (siteItemList.length > 0) && (spcItemList.length > 0 ) ) {

							var multiPromises = [];

							$.each(siteItemList, function(index, element){
								siteObj.sid = $(element).data("sid");
								siteObj.role = Number($(element).data("role"));
								siteOption.data = JSON.stringify(siteObj);
								multiPromises.push(makeAjaxCall(siteOption));
							});

							$.each(spcItemList, function(index, element){
								let spcObj = {
									spcid: $(element).data("spc-id"),
									role: Number($(element).data("role"))
								};
								// console.log("opcObj===", spcObj)
								spcOption.data = JSON.stringify(spcObj);
								multiPromises.push(makeAjaxCall(spcOption));
							});

							Promise.all(multiPromises).then(res => {
								refreshUserList();
								showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
							}).catch( err => {
								console.log("cannot edit site info", err);
								let errorMsg = resultFailText + "<fmt:message key='userSetting.erorrMsg' />:" + err;
								showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
							});
						} else {
							if(siteItemList.length > 0) {
								var sitePromises = [];
								$.each(siteItemList, function(index, element){
									// console.log("element====", element)
									siteObj.sid = $(element).data("sid");
									siteObj.role = Number($(element).data("role"));
									siteOption.data = JSON.stringify(siteObj);
									sitePromises.push(makeAjaxCall(siteOption));
								});
								Promise.all(sitePromises).then(res => {
									refreshUserList();
									showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
								}).catch( err => {
									console.log("cannot edit site info", err);
									let errorMsg = resultFailText + "<fmt:message key='userSetting.erorrMsg' />:" + err;
									showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
								});
							}

							if(spcItemList.length > 0 ){
								var spcPromises = [];
								$.each(spcItemList, function(index, element){
									let spcObj = {
										spcid: $(element).data("spc-id"),
										role: Number($(element).data("role"))
									};
									// console.log("opcObj===", spcObj)
									spcOption.data = JSON.stringify(spcObj);
									spcPromises.push(makeAjaxCall(spcOption));
								});
								Promise.all(spcPromises).then(res => {
									refreshUserList();
									showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
								}).catch( err => {
									console.log("cannot edit spc info ====> ", err);
									let errorMsg = resultFailText + "<fmt:message key='userSetting.erorrMsg' />:" + err;
									showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
								});
							}
						}
					}).fail(function (jqXHR, textStatus, errorThrown) {
						let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
						showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
					});
				}
			} else {
			// 2. Edit existing user info
				let resultSuccessText = "<fmt:message key='userSetting.errorTxt.20' />";
				let resultFailText = "<fmt:message key='userSetting.errorTxt.21' /><br>";
				let emptyMsg = "<fmt:message key='userSetting.errorTxt.22' />";

				let dTable = $("#userTable").DataTable();
				let tr = $("#userTable").find("tbody tr.selected");
				let td = tr.find("td");

				let newUid = dTable.row(tr).data().uid;
				let prevDesc = dTable.row(tr).data().desc;

				let role = $("#newAccLevel").prev().data("value");
				let roleTitle = $("#newAccLevel").prev().data("name");

				let siteDeleteItem = $("#selectedSiteList li.delete");
				let siteEditItem = $("#selectedSiteList li.new");

				let spcDeleteItem = $("#selectedSpcList li.delete");
				let spcEditItem = $("#selectedSpcList li.new");

				let flagArr = [ 0, 0, 0, 0 ];

				let pwd = { password : $("#newUserPwd").val() }
				let editUserObj = {};

				editUserObj.custom_level_yn = customLevelYn;
				editUserObj.custom_level_id = customLevel;

				if( !isEmpty(newFullName) && ( newFullName != td.eq(2).text() ) ) {
					editUserObj.name = newFullName;
				}
				if( !isEmpty(newAccVal) && ( newAccName != td.eq(6).text() ) ) {
					editUserObj.role = newAccVal;
				}
				if( !isEmpty(newPhoneNum) && ( newPhoneNum != td.eq(3).text() ) ) {
					editUserObj.contact_phone = newPhoneNum;
				}
				if( !isEmpty(newEmailAddr) && ( newEmailAddr != td.eq(4).text() ) ) {
					editUserObj.contact_email = newEmailAddr;
				}
				if( !isEmpty(newAffiliation) && ( newAffiliation != td.eq(5).text() ) ) {
					editUserObj.team = newAffiliation;
				}

				if (newAccVal == '1') {
					editUserObj.task = 0;
				} else {
					if( !isEmpty(newTaskList) && newTaskName != td.eq(8).text() ) {
						if (!$('#newTaskList').prev().prop('disabled')) {
							editUserObj.task = newTaskList;
						}
					}
				}

				if( !isEmpty(newUseOpt) && (newUswOptName != td.eq(10).text() ) ) {
					// console.log("newUseOpt===", newUseOpt, "newUswOptName===", newUswOptName);
					editUserObj.valid_yn = newUseOpt;
				}

				if( !isEmpty(verify_level) && (verify_level != td.eq(11).text() ) ) {
					editUserObj.verify_level = Number(verify_level);
				}

				if( !isEmpty(newUserDesc) ) {
					// if( newUserDesc.replace("\t", "") != prevDesc.replace("\t", "") ) {
						editUserObj.description = newUserDesc;
					// }
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
					data: JSON.stringify(editUserObj)
				}

				optionPwd = {
					url: apiHost + '/config/users/' + newUid + '/password2',
					type: 'patch',
					async: false,
					data: JSON.stringify(pwd),
					contentType: 'application/json; charset=UTF-8'
				}

				for(let i = 0, length = siteItemList; i < siteItemList.length; i++) {
					if($(siteItemList[i]).hasClass("active")){
							flagArr[0] = 1;
					} else if($(siteItemList[i]).hasClass("new")){
						if($(siteItemList[i])){
							flagArr[1] = 1;
						}
					}
				};

				for(let i = 0, length = spcItemList; i < spcItemList.length; i++) {
					if($(spcItemList[i]).hasClass("active")){
						if($(spcItemList[i]).hasClass("active")){
							flagArr[2] = 1;
						}
					} else {
						if($(spcItemList[i]).hasClass("new")){
							flagArr[3] = 1;
						}
					}
				};

				let flagIndex = flagArr.findIndex( x => x === 1);
				// console.log("flagArr--", flagArr)
				if( isEmpty($("#newUserPwd").val()) && isEmpty(editUserObj) && (flagIndex < 0) ) {
					// if no changes have been made
					let errorMsg = "<fmt:message key='userSetting.errorTxt.23' />";
					showAjaxResultModal("ajaxResultModal", null, null, errorMsg);
				} else {
					if( (flagIndex < 0) ){
						// if pwd && editUserObj values are present but no userSpc && userSite info
						if( !isEmpty($("#newUserPwd").val()) && !isEmpty(editUserObj) ){
							$.when($.ajax(optionPwd),$.ajax(option)).done(function (result1, result2) {
								// console.log("editUserObj===", editUserObj, "newUser Pwd====", $("#newUserPwd").val() )
								refreshUserList();
								showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
							}).fail(function (jqXHR, textStatus, errorThrown) {
								let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
								showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
							});
						} else {
							// if either pwd && editUserObj values are present (YES), but (NO) userSpc && userSite info
							if( !isEmpty($("#newUserPwd").val()) ){
								$.ajax(optionPwd).done(function (json, textStatus, jqXHR) {
									refreshUserList();
									showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
								}).fail(function (jqXHR, textStatus, errorThrown) {
									let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
									showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
								});
							}

							if( !isEmpty(editUserObj) ){
								// console.log("editUserObj===", editUserObj);
								$.ajax(option).done(function (json, textStatus, jqXHR) {
									refreshUserList();
									showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
								}).fail(function (jqXHR, textStatus, errorThrown) {
									let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
									showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
								});
							}
						}
					} else {
						let nestedPromises = [];
						if(flagArr[0] === 1) {
							for(let i = 0, length = siteDeleteItem; i < siteDeleteItem.length; i++) {
								if($(siteDeleteItem[i]).hasClass("active")){
									let deleteOption = {
										url: apiHost + '/config/user_sites/' + siteDeleteList[i],
										type: 'delete',
										async: true,
									}
									nestedPromises.push(makeAjaxCall(deleteOption));
								}
							}
						}

						if(flagArr[1] === 1) {
							for(let i = 0, length = siteEditItem; i < siteEditItem.length; i++) {
								let siteEditOption = {
									url: apiHost + '/config/user_sites?uid=' + newUid,
									type: 'post',
									dataType: 'json',
									contentType: "application/json",
									async: false
								}
								let siteEditObj = {}
								siteEditObj.sid = $(siteEditItem[i]).data("sid");
								siteEditObj.role = Number($(siteEditItem[i]).data("role"));
								siteEditOption.data = JSON.stringify(siteEditObj);

								nestedPromises.push(makeAjaxCall(siteEditOption));
							};
						}

						if(flagArr[2] === 1){
							for(let i = 0, length = spcDeleteItem; i < spcDeleteItem.length; i++) {
								if($(spcDeleteItem[i]).hasClass("active")){
									let deleteOption = {
										url: apiHost + '/config/user_spcs/' + spcDeleteList[i],
										type: 'delete',
										async: true,
									}
									nestedPromises.push(makeAjaxCall(deleteOption));
								}
							}
						}

						if(flagArr[3] == 1){
							for(let i = 0, length = spcEditItem; i < spcEditItem.length; i++) {
								let spcEditOption = {
									url: apiHost + '/config/user_spcs?uid=' + newUid,
									type: 'post',
									dataType: 'json',
									contentType: "application/json",
									async: true
								}
								let spcEditObj = {}
								spcEditObj.spcid = $(spcEditItem[i]).data("spc-id");
								spcEditObj.role = Number($(spcEditItem[i]).data("role"));
								spcEditOption.data = JSON.stringify(spcEditObj);

								nestedPromises.push(makeAjaxCall(spcEditOption));
							}
						}

						// if pwd && editUserObj are present
						if( !isEmpty($("#newUserPwd").val()) && !isEmpty(editUserObj) ){
							pwd = $("#newUserPwd").val();
							optionPwd = {
								url: apiHost + '/config/users/' + newUid + '/password2',
								type: 'patch',
								async: true,
								data: JSON.stringify(pwd),
								contentType: 'application/json; charset=UTF-8'
							}

							$.when($.ajax(optionPwd),$.ajax(option)).done(function (result1, result2) {
								if(nestedPromises.length>0){
									Promise.all(nestedPromises).then(res => {
										refreshUserList();
										showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
									}).catch( err => {
										console.log("cannot delete existing alarm info", err);
										let errorMsg = resultFailText + "<fmt:message key='userSetting.erorrMsg' />:" + err;
										showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
									});
								}
							}).fail(function (jqXHR, textStatus, errorThrown) {
								let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
								showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
							});
						} else {
							// only flagArr is present
							if( isEmpty(editUserObj) && isEmpty($("#newUserPwd").val())) {
								// console.log("only flagArr is present---");
								if(nestedPromises.length>0){
									Promise.all(nestedPromises).then(res => {
										refreshUserList();
										showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
									}).catch( err => {
										console.log("cannot delete existing alarm info", err);
										let errorMsg = resultFailText + "<fmt:message key='userSetting.errorMsg' />:" + err;
										showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
									});
								} else {
									showAjaxResultModal("ajaxResultModal", "addUserModal", "0", emptyMsg);
								}
							} else {
								if( !isEmpty($("#newUserPwd").val()) ){
									$.ajax(optionPwd).done(function (json, textStatus, jqXHR) {
										if(nestedPromises.length>0){
											Promise.all(nestedPromises).then(res => {
												refreshUserList();
												showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
											});
										} else {
											showAjaxResultModal("ajaxResultModal", "addUserModal", "0", emptyMsg);
										}
									}).fail(function (jqXHR, textStatus, errorThrown) {
										let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
										showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);	
									});
								}
								if( !isEmpty(editUserObj) ){
									// console.log("editUserObj only + nestedPromises")
									$.ajax(option).done(function (json, textStatus, jqXHR) {
										if(nestedPromises.length>0){
											Promise.all(nestedPromises).then(res => {
												refreshUserList();
												showAjaxResultModal("ajaxResultModal", "addUserModal", "1", resultSuccessText);
											});
										}
									}).fail(function (jqXHR, textStatus, errorThrown) {
										let errorMsg = resultFailText + "<fmt:message key='userSetting.errorCode' />:" + jqXHR.status + "<br>" + "<fmt:message key='userSetting.msg' />: " + jqXHR.responseText;
										showAjaxResultModal("ajaxResultModal", "addUserModal", "0", errorMsg);
									});
								}
							}

						}

					}

				}
			}
		});
	});

	$(document).on('click', '#customLevelList li', function() {
		if ($(this).data('value') === 'N') {
			$('#newTaskList').prev().prop('disabled', false);
			$('.tab-content').removeClass('hidden');
			$('.tab-content').prev().removeClass('hidden');
		} else {
			$('#newTaskList').prev().prop('disabled', true);
			$('.tab-content').addClass('hidden');
			$('.tab-content').prev().addClass('hidden');
			$('#newTaskList').prev().prop('disabled', true).html("<fmt:message key='userSetting.select' />" + '<span class="caret"></span>').data("value", "");
		}
	});

	const getCustomLevel = () => {
		$.ajax({
			url: apiHost + '/config/custom-level/',
			type: 'GET',
			async: false,
			data: { oid: oid }
		}).done((data, textStatus, jqXHR) => {
			let temp = ``;
			(data.data).forEach(custom => {
				temp += `<li data-value="${'${custom.level_id}'}" data-name="${'${custom.name}'}"><a href="#" tabindex="-1">${'${custom.name}'}</a></li>`;
			});

			$('#customLevelList').empty().append(temp).prepend(`<li data-value="N"><a href="#" tabindex="-1">업무구분</a></li>`);
			$('#userList').empty().append(temp).prepend('<li data-value=""><a href="#" tabindex="-1">전체</a></li>');
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
			errorMsg('처리중 오류가 발생했습니다.');
			return false;
		});
	}

	const rtnDropdown = (target) => {
		if (target === 'accLevel') {
			validateAddForm();
		}
	}

	// Get Ajax Data
	function getUserList(opt, callback) {
		$.ajax(opt).done(function (json, textStatus, jqXHR) {
			if(!isEmpty(json)){
				let data = json;
				let newArr = [];
				let affiliationList = [];

				Promise.resolve(data.map((item, index) => {
					let obj = {};

					obj.user_id = item.login_id;
					obj.name = item.name;

					if(!isEmpty(item.user_sites)){
						obj.userSiteList = "1";
					}
					
					if(!isEmpty(item.user_spcs)){
						obj.userSpcList = "1";
					}

					if(!isEmpty(item.contact_phone) && (item.contact_phone != "string") ){
						obj.contact_phone = item.contact_phone;
					} else {
						obj.contact_phone = "-";
					}

					if(!isEmpty(item.contact_email) && (item.contact_email != "string") ){
						obj.contact_email = item.contact_email;
					} else {
						obj.contact_email = "-";
					}

					if(!isEmpty(item.team) && (item.team != "string")){
						obj.team = item.team;
						affiliationList.push(item.team);
					} else {
						obj.team = "-";
					}

					if(item.role == 1){
						obj.user_role = "<fmt:message key='userSetting.auth.admin' />"
					} else {
						obj.user_role = "<fmt:message key='userSetting.auth.user' />"
					}

					if(item.task == 0){
						obj.user_task = "<fmt:message key='userSetting.workType.1' />"
					} else if(item.task == 1){
						obj.user_task = "<fmt:message key='userSetting.workType.2' />"
					} else if(item.task == 2){
						obj.user_task = "<fmt:message key='userSetting.workType.3' />"
					} else if(item.task == 3){
						obj.user_task = "<fmt:message key='userSetting.workType.4' />"
					} else if(item.task == 4){
						obj.user_task = "<fmt:message key='userSetting.workType.5' />"
					}

					obj.custom_level_yn = item.custom_level_yn;
					if (item.custom_level_yn === 'Y') {
						$('#userList li').each(function() {
							if ($(this).data('value') == item.custom_level_id) {
								obj.custom_level_name = $(this).data("name");
								obj.custom_level_id = $(this).data("value");
							}
						});
					} else {
						obj.custom_level_name = '';
						obj.custom_level_id = item.custom_level_id;
					}

					if(!isEmpty(item.createdAt)){
						let d = new Date(item.createdAt).format('yyyy-MM-dd') + " " + new Date(item.createdAt).toLocaleTimeString();
						if (langStatus === "EN") {
							let enDate = d.split(" ");
								enDate[1] = enDate[1] == "오전" ? "AM" : "PM";
								
							d = enDate.join(" ");
						}
						obj.created_at = d;
					} else {
						obj.created_at = "-";
					}

					if(!isEmpty(item.valid_yn)){
						if(item.valid_yn == "Y"){
							obj.valid_yn = "<fmt:message key='userSetting.isUse.Y' />"
						} else {
							obj.valid_yn = "<fmt:message key='userSetting.isUse.N' />"
						}
					} else {
						obj.valid_yn = "-";
					}

					if(!isEmpty(item.description)){
						obj.desc = item.description;
					}
					obj.uid = item.uid;
					obj.idx = index + 1;
					obj.verify_level = item.verify_level;
					newArr.push(obj);
					// console.log("uid---", item.uid)
				})).then( () => {
					if(!callback) {
						// $.fn.dataTable.ext.order.intl();
						var userTable = $('#userTable').DataTable({
							"aaData": newArr,
							// "bDeferRender": true,
							"fixedHeader": true,
							"table-layout": "fixed",
							// "bStateSave": true,
							// "bStateDuration": 60 * 60 * 24,
							"autoWidth": true,
							"bSearchable" : true,
							// "sScrollX": "110%",
							// "sScrollXInner": "110%",
							"sScrollY": true,
							"scrollY": "720px",
							"scrollX": true,
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
							],
							"aoColumns": [
								{
									"sTitle": "",
									"mData": "null",
									"mRender": function ( data, type, full, rowIndex )  {
										return '<a class="chk-type" href="#"><input type="checkbox" id="' + rowIndex.row + '" name="table_checkbox"><label for="' + rowIndex.row + '"></label></a>'
									},
									"className": "dt-body-center no-sorting"
								},
								{
									"sTitle": "ID",
									"mData": "user_id"
								},
								{
									"sTitle": "<fmt:message key='userSetting.name' />",
									"mData": "name",
								},
								{
									"sTitle": "<fmt:message key='userSetting.phone' />",
									"mData": "contact_phone",
								},
								{
									"sTitle": "<fmt:message key='userSetting.email' />",
									"mData": "contact_email",
								},
								{
									"sTitle": "<fmt:message key='userSetting.dep' />",
									"mData": "team",
								},
								{
									"sTitle": "<fmt:message key='userSetting.auth' />",
									"mData": "user_role",
									"className": "acc-level"
								},
								{
									"sTitle": "<fmt:message key='userSetting.customAuth' />",
									"mData": "custom_level_name",
									"mRender": function ( data, type, row ) {
										if (isEmpty(data)) {
											if (row.user_role === '일반 사용자') {
												return '업무 구분';
											} else {
												return '-';
											}
										} else {
											return data;
										}
									},
								},
								{
									"sTitle": "<fmt:message key='userSetting.workType' />",
									"mData": "user_task",
								},
								{
									"sTitle": "<fmt:message key='userSetting.registerDate.1' />",
									"mData": "created_at",
								},
								{
									"sTitle": "<fmt:message key='userSetting.isUse' />",
									"mData": "valid_yn",
								},
								{
									"sTitle": "<fmt:message key='userSetting.certification' />",
									"mData": "verify_level",
									visible: false,
								},
								{
									"sTitle": "커스텀 레벨 설정",
									"mData": "custom_level_yn",
									visible: false,
								}
							],
							"dom": 'tip',
							"language": {
								"emptyTable": "<fmt:message key='userSetting.noData' />",
								"zeroRecords":  "<fmt:message key='userSetting.noSearchData' />",
								"infoEmpty": "",
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
							"select": {
								style: 'single',
								selector: 'td input[type="checkbox"], tr'
							},
							initComplete: function(){
								let str = `
									<div id="btnGroup" class="right-end"><!--
										--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')"><fmt:message key='userSetting.updateSelected' /></button><!--
										--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')"><fmt:message key='userSetting.deleteSelected' /></button><!--
								--></div>
								`;

								let addBtnStr = ``;
								if (role === '1') {
									addBtnStr = `
										<button type="button" class="btn-type fr mb-20 ml-6" onclick="updateModal('add')"><fmt:message key='userSetting.add' /></button>
										<button type="button" class="btn-type fr mb-20" onclick="location.href='/setting/userGradeSetting.do'"><fmt:message key="button.setting" /></button>
									`;
								}
								$("#userTable_wrapper").append($(str)).prepend($(addBtnStr));

								// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
								// 	cell.innerHTML = i+1;
								// 	$(cell).data("id", i);
								// });

								// this.api().columns().header().each ((el, i) => {
								// 	if(i === 0 ){
								// 		$ (el).attr ('style', 'min-width: 160px;');
								// 	}
								// });
							},
							createdRow: function ( row, data, index ){
								$(row).attr({
									'data-role': data.user_role,
									'data-name': data.name
								});

								if(!isEmpty(data.userSiteList)){
									$(row).attr({
										'data-site-list': "1"
									});
								}
								if(!isEmpty(data.userSpcList)){
									$(row).attr({
										'data-spc-list': "1",
									});
								}
								// if ( data[5].replace(/[\$,]/g, '') * 1 > 150000 ) {
								// 	$('td', row).eq(5).addClass('highlight');
								// }
							},
							// every time DataTables performs a draw
							drawCallback: function () {
								$('#userTable_wrapper').addClass('mb-28');
							},
							// rowCallback: function ( row, data ) {
							// }
						// }).on( 'user-select', function ( e, dt, type, cell, originalEvent ) {
						// 	console.log("tra--", originalEvent.target.nodeName );
						}).on("select", function(e, dt, type, indexes) {
							let btn = $("#btnGroup").find(".btn-type03");
							btn.each(function(index, element){
								if($(this).is(":disabled")){
									$(this).prop("disabled", false);
								}
							});
							userTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
							// console.log("dt---", userTable[ type ]( indexes ).nodes())
						}).on("deselect", function(e, dt, type, indexes) {
							let btn = $("#btnGroup").find(".btn-type03");
							btn.each(function(index, element){
								if(!$(this).is(":disabled")){
									$(this).prop("disabled", true);
								}
							});
							userTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
						}).columns.adjust().draw();
						
						// }).columns.adjust().responsive.recalc();
					} else {
						$('#userTable').DataTable().clear().destroy();
						// $.fn.dataTable.ext.order.intl();
						var userTable = $('#userTable').DataTable({
							"aaData": newArr,
							"retrieve": true,
							"table-layout": "fixed",	
							"fixedHeader": true,
							// "bAutoWidth": true,
							"bSearchable" : true,
							// "bStateSave": true,
							// "bStateDuration": 60 * 60 * 24,
							// "ScrollX": true,
							// "sScrollX": true,
							// "sScrollXInner": "110%",
							"sScrollY": true,
							"scrollY": "560px",
							"scrollX": true,
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
							],
							"aoColumns": [
								{
									"sTitle": "",
									"mData": "null",
									"mRender": function ( data, type, row )  {
										return '<a class="chk-type" href="#"><input type="checkbox" id="' + row.idx + '" name="table_checkbox"><label for="' + row.idx + '"></label></a>'
									},
									"className": "dt-body-center no-sorting"
								},
								// {
								// 	"sTitle": "순번",
								// 	"mData": null,
								// 	"className": "dt-center idx"
								// 	// "className": "dt-center idx no-sorting"
								// },
								{
									"sTitle": "ID",
									"mData": "user_id"
								},
								{
									"sTitle": "<fmt:message key='userSetting.name' />",
									"mData": "name",
								},
								{
									"sTitle": "<fmt:message key='userSetting.phone' />",
									"mData": "contact_phone",
								},
								{
									"sTitle": "<fmt:message key='userSetting.email' />",
									"mData": "contact_email",
								},
								{
									"sTitle": "<fmt:message key='userSetting.dep' />",
									"mData": "team",
								},
								{
									"sTitle": "<fmt:message key='userSetting.auth' />",
									"mData": "user_role",
									"className": "acc-level"
								},
								{
									"sTitle": "<fmt:message key='userSetting.customAuth' />",
									"mData": "custom_level_name",
									"mRender": function ( data, type, row ) {
										if (isEmpty(data)) {
											if (row.user_role === '일반 사용자') {
												return '업무 구분';
											} else {
												return '-';
											}
										} else {
											return data;
										}
									},
								},
								{
									"sTitle": "<fmt:message key='userSetting.workType' />",
									"mData": "user_task",
								},
								{
									"sTitle": "<fmt:message key='userSetting.registerDate.1' />",
									"mData": "created_at",
								},
								{
									"sTitle": "<fmt:message key='userSetting.isUse' />",
									"mData": "valid_yn",
								},
								{
									"sTitle": "<fmt:message key='userSetting.certification' />",
									"mData": "verify_level",
									visible: false,
								},
								{
									"sTitle": "커스텀 레벨 설정",
									"mData": "custom_level_yn",
									visible: false,
								}
							],
							"dom": 'tip',
							"language": {
								"emptyTable": "<fmt:message key='userSetting.noData' />",
								"zeroRecords":  "<fmt:message key='userSetting.noSearchData' />",
								"infoEmpty": "",
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
							"select": {
								style: 'single',
								selector: 'td input[type="checkbox"], tr',
							},
							initComplete: function(){
								let str = `
									<div id="btnGroup" class="right-end"><!--
										--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')"><fmt:message key='userSetting.updateSelected' /></button><!--
										--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')"><fmt:message key='userSetting.deleteSelected' /></button><!--
								--></div>
								`;

								let addBtnStr = ``;
								if (role === '1') {
									addBtnStr = `
										<button type="button" class="btn-type fr mb-20 ml-6" onclick="updateModal('add')"><fmt:message key='userSetting.add' /></button>
										<button type="button" class="btn-type fr mb-20" onclick="location.href='/setting/userGradeSetting.do'"><fmt:message key="button.setting" /></button>
									`;
								}

								$("#userTable_wrapper").append($(str)).prepend($(addBtnStr));

								// this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
								// 	cell.innerHTML = i+1;
								// 	$(cell).data("id", i);
								// });

								// this.api().columns().header().each ((el, i) => {
								// 	if(i === 0 ){
								// 		$ (el).attr ('style', 'min-width: 160px;');
								// 	}
								// });
							},
							createdRow: function ( row, data, index ){
								$(row).attr({
									'data-role': data.user_role,
									'data-name': data.name
								});

								if(!isEmpty(data.userSiteList)){
									$(row).attr({
										'data-site-list': "1"
									});
								}
								if(!isEmpty(data.userSpcList)){
									$(row).attr({
										'data-spc-list': "1",
									});
								}
								// if ( data[5].replace(/[\$,]/g, '') * 1 > 150000 ) {
								// 	$('td', row).eq(5).addClass('highlight');
								// }
							},
							// every time DataTables performs a draw
							drawCallback: function () {
								$('#userTable_wrapper').addClass('mb-28');
							},
							// rowCallback: function ( row, data ) {
							// }
						// }).on( 'user-select', function ( e, dt, type, cell, originalEvent ) {
						// 	console.log("tra--", originalEvent.target.nodeName );
						}).on("select", function(e, dt, type, indexes) {
							let btn = $("#btnGroup").find(".btn-type03");
							btn.each(function(index, element){
								if($(this).is(":disabled")){
									$(this).prop("disabled", false);
								}
							});
							userTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
						}).on("deselect", function(e, dt, type, indexes) {
							let btn = $("#btnGroup").find(".btn-type03");
							btn.each(function(index, element){
								if(!$(this).is(":disabled")){
									$(this).prop("disabled", true);
								}
							});
							userTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
						}).columns.adjust().draw();
						// }).columns.adjust().responsive.recalc();
					}
					
					$('#userTable').find("input:checkbox").on('click', function() {
						var $box = $(this);
						if ($box.is(":checked")) {
							var group = "input:checkbox[name='" + $box.attr("name") + "']";
							$(group).prop("checked", false);
							$box.prop("checked", true);
						} else {
							$box.prop("checked", false);
						}
					});
					
					// userTable.on( 'order.dt search.dt', function(){
					// 	userTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
					// 		cell.innerHTML = i+1;
					// 	});
					// }).draw();

					userTable.on( 'column-sizing.dt', function ( e, settings ) {
						$(".dataTables_scrollHeadInner").css( "width", "100%" );
					});

					// new $.fn.dataTable.Buttons( userTable, {
					// 	name: 'commands',
					// 	"buttons": [
					// 		{
					// 			extend: 'excelHtml5',
					// 			className: "btn-save",
					// 			text: '엑셀 다운로드',
					// 			filename: '사용자관리_' + new Date().format('yyyyMMddHHmmss'),
					// 	],
					// });

					// userTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
					
					$("#newTeam").autocomplete({
						source : affiliationList,
						minLength: 1,
						autoFocus: true,
						classes: {
							'ui-autocomplete': 'highlight'
						},
						delay: 500
					});

					$("#searchBox").on( 'keyup search input paste cut', function(){
						userTable.search( this.value ).draw();
						// $("#userTable").dataTable().search( $(this).val() );
					});
					
					$("#userList").find("li").on('click', function() {
						if(!isEmpty($(this).data("value"))){
							$("#userTable").DataTable().column("8").search("\\b"+$(this).data("name")+"\\b", true, false).draw();

							let tr = $("#userTable").find("tbody tr.selected");
							let btn = $("#btnGroup").find(".btn-type03");
							if(tr.length <= 0) {
								btn.each(function(index, element) {
									$(this).prop("disabled", true);
								});
							} else {
								btn.each(function(index, element) {
									$(this).prop("disabled", false);
								});
							}
						} else {
							filterColumn("#userTable", "8", "");
						}
					});
					// $("#pageLengthList").find("li").on( 'click', function(){ 
					// 	if(!isEmpty($(this).data("value"))){
					// 		let val = Number($(this).data("value"));
					// 		userTable.page.len(val).draw();
					// 	} else {
					// 		userTable.page.len( -1 ).draw();
					// 	}
					// });
						
				})	
			} else {
				drawEmptyTable($("#userTable"))
			}
		
		}).fail(function (jqXHR, textStatus, errorThrown) {
			$("#userTable").DataTable().clear();
			return false;
		});
	}

	function getSpcList(opt, cloned, callback) {
		$.ajax(opt).done(function (json, textStatus, jqXHR) {
			let data = json.data;
			data.sortOn("name");

			data.map( x => {
				let str = '';
				str = cloned.replace(/\*spcId\*/g, x.spc_id)
					.replace(/\*spcName\*/g, x.name)
				$("#spcRow ul").first().append(str);
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			return false;
		});

		let dropdown = $("#updateUserForm").find(".dropdown ul");
		callback(dropdown);
	}

	function refreshUserList() {
		let option = {
			url: apiHost + "/config/users",
			type: "get",
			async: false,
			data: {
				uid: userInfoId,
				oid: oid,
				filter: JSON.stringify({
					'include': [{ 'relation': 'user_spcs' }, {  'relation': 'user_sites' }]
				})
			}
		}
		getUserList(option, "destroy");
		getCustomLevel();
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
					"title": "<fmt:message key='userSetting.index' />",
					"data": null,
					"className": "dt-center no-sorting"
				},
				{
					"title": "<fmt:message key='userSetting.name' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='userSetting.phone' />",
					"data": null
				},
				{
					"title": "<fmt:message key='userSetting.email' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='userSetting.team' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='userSetting.auth' />",
					"data": null,
				},
				{
					"sTitle": "<fmt:message key='userSetting.customAuth' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='userSetting.workType' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='userSetting.registerDate.2' />",
					"data": null,
				},
				{
					"title": "<fmt:message key='userSetting.isUse' />",
					"data": null,
				},
				{
					"sTitle": "<fmt:message key='userSetting.certification' />",
					"data": null,
					visible: false,
				},
				{
					"sTitle": "커스텀 레벨 설정",
					"data": null,
					visible: false,
				}
			],
			"dom": 'tip',
			"language": {
				"emptyTable": "<fmt:message key='userSetting.noData' />",
				"zeroRecords":  "<fmt:message key='userSetting.noSearchData' />",
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
				let addBtnStr = `
					<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')"><fmt:message key='userSetting.add' /></button>
				`;
				$("#userTable_wrapper").prepend($(addBtnStr));
			},
		});
	}


	function checkId(userInput){
		if(isEmpty(userInput)) return false;
		let id = userInput.toString();
		let checkIdOpt = {
			url: apiHost + "/config/users/exist?oid=" + oid + '&login_id=' + id,
			type: "get",
			beforeSend: function (jqXHR, settings) {
				$('#loadingCircle').show();
				$("#invalidId").addClass("hidden");
				$("#validId").addClass("hidden");
			},
		}
		$.ajax(checkIdOpt).done(function (json, textStatus, jqXHR) {
			$("#validId").removeClass("hidden");
			validateAddForm();
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.log(jqXHR)
			if(jqXHR.status == 409){
				console.log(jqXHR);
				$("#invalidId").removeClass("hidden");
				setTimeout(function(){
					$("#invalidId").addClass("hidden");
				}, 2000);
			}
			return false;
		});
	}

	function initModal(){
		let form = $("#updateUserForm");
		let input = form.find("input");
		let dropdown = form.find(".dropdown-toggle");
		let tick = form.find(".tick");
		let warning = form.find(".warning");
		let addBtn  = $("#addUserBtn");

		warning.addClass("hidden")
		tick.removeClass("checked");
		input.val("");
		addBtn.prop("disabled", true);
		siteDeleteList.length = 0;
		spcDeleteList.length = 0;
		$("#confirmUserId").val("");
		$("#newUserDesc").val("");


		$('.tab-content').addClass('hidden');
		$('.tab-content').prev().addClass('hidden');
		$.each(dropdown, function(index, element){
			$(this).html("<fmt:message key='userSetting.select' />" + '<span class="caret"></span>');
			$(this).data("value", "");
		});

	}

	function updateModal(option){
		let addBtn  = $("#addUserBtn");
		let titleAdd = $('#titleAdd');
		let id = $('#newId');
		let accLevBtn = $('#newAccLevel').prev();
		let customLevelBtn = $('#customLevelList').prev();
		let newTaskBtn =$('#newTaskList').prev();
		let required = $("#updateUserForm").find(".asterisk");

		$('.nav-tabs > li').eq(0).removeClass('hidden').addClass('active').siblings().removeClass('active');
		$('div.tab-content > div.tab-pane').eq(0).addClass('active in').siblings().removeClass('active in');

		id.parent().next().prop("disabled", true);
		// updateModal ADD !!!!!
		if(option == 'add') {
			initModal();
			if(id.parent().next().hasClass("hidden")) {
				id.parent().next().removeClass("hidden");
				id.parent().addClass("offset-width").removeClass("w-100");
			}
			titleAdd.removeClass("hidden").next().addClass("hidden");
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			addBtn.prop("disabled", true).text("<fmt:message key='userSetting.register' />");
			$('#newId').prop('disabled', false);
			$("#addUserModal").removeClass("edit").modal("show");
		} else {
			let dTable = $("#userTable").DataTable();
			let tr = $("#userTable").find("tbody tr.selected");
			let td = tr.find("td");
			let uid = dTable.row(tr).data().uid;
			let prevDesc = dTable.row(tr).data().desc;

			// updateModal EDIT!!!!!
			if(option == "edit") {
				let optSpc = {
					url: apiHost + "/config/user_spcs?oid=" + oid,
					type: "get",
					async: true,
					data: {
						user_ids: uid
					}
				}
				let optSite = {
					url: apiHost + "/config/user_sites?oid=" + oid,
					type: "get",
					async: true,
					data: {
						user_ids: uid
					}
				}

				addBtn.prop("disabled", false).text("<fmt:message key='userSetting.update' />");

				$.when($.ajax(optSite), $.ajax(optSpc)).done(function (result1, result2) {
					let siteData = result1[0].data;

					if(siteData.length > 0){
						let siteOptList = $("#siteOptList li").toArray();
						let siteStr = ``;

						siteData.sortOn("name");
						$.each(siteData, function( index, item ) {
							siteOptList.some( x => {
								if($(x).data("value") === item.sid) {
									let name = $(x).data("name");
									let role = "";
									if(item.role == 1){
										role = "<fmt:message key='userSetting.auth.manage' />";
									} else {
										role = "<fmt:message key='userSetting.auth.search' />";
									}

									siteStr += `
									<li class="delete" data-sid="${'${item.sid}'}" data-role="${'${item.role}'}" data-site-name="${'${name}'}">${'${name}'}&nbsp;(&nbsp;${'${role}'}&nbsp;)
										<button type="button" class="icon-delete text-btn" onclick="removeList( $(this).closest('li'), $(this) )"><fmt:message key='userSetting.toBeDelete' /></button>
									</li>
									`;
									siteDeleteList.push(item.usid);
								}
							});
						});

						$("#selectedSiteList").append(siteStr).prev().html("<fmt:message key='userSetting.updateList' />&emsp;<span class='fr'>(&nbsp;<strong class='text-orange'><fmt:message key='userSetting.toBeDelete' /></strong>&ensp;<fmt:message key='userSetting.deleteMsg' />)</span>").removeClass("hidden");
					}


					let spcData = result2[0].data;
					if(spcData.length > 0){
						let spcOptList = $("#spcOptList li").toArray();
						let spcStr = ``;

						$.each(spcData, function( index, item ) {
							spcOptList.some( x => {
								if($(x).data("value") === item.spcid) {
									let name = $(x).data("name");
									let role = '';
									item.role == "1" ? role = "<fmt:message key='userSetting.auth.manage' />" : role = "<fmt:message key='userSetting.auth.search' />";

									spcStr += `
										<li class="delete" data-spc-id="${'${item.spcid}'}" data-role="${'${item.role}'}" data-spc-name="${'${name}'}">${'${name}'}&nbsp;(&nbsp;${'${role}'}&nbsp;)
											<button type="button" class="icon-delete text-btn" onclick="removeList( $(this).closest('li'), $(this) )"><fmt:message key='userSetting.toBeDelete' /></button>
										</li>
									`;
									spcDeleteList.push(item.uspcid);
								}
							});
						});
						$("#selectedSpcList").append(spcStr).prev().html("<fmt:message key='userSetting.updateList' />&emsp;<span class='fr'>(&nbsp;<strong class='text-orange'><fmt:message key='userSetting.toBeDelete' /></strong>&ensp;<fmt:message key='userSetting.deleteMsg' />)</span>").removeClass("hidden");;
					}

					let val = $("#newAccLevel").prev().data("value");
					$("#siteAccOpt").prev().prop("disabled", false).contents().get(0).nodeValue = "<fmt:message key='userSetting.select' />";
					$("#spcAccOpt").prev().prop("disabled", false).contents().get(0).nodeValue = "<fmt:message key='userSetting.select' />";
				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.log("optSite error===", jqXHR)
					return false;
				});

				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");

				if(!id.parent().next().hasClass("hidden")) {
					id.parent().next().addClass("hidden");
					id.parent().removeClass("offset-width").addClass("w-100");
				}

				id.val(td.eq(1).text()).prop('disabled', true);

				$('#newFullName').val(td.eq(2).text());
				let accName = td.eq(6).text();
				if(td.eq(6).text() == "<fmt:message key='userSetting.auth.admin' />"){
					accLevBtn.data( { "name" : accName, "value" : "1"}).html(accName+ '<span class="caret">');
					if ($('.nav-tabs > li').eq(0).find('a').attr('href') == '#siteTab') {
						$('.nav-tabs > li').eq(0).addClass('hidden').removeClass('active').siblings().addClass('active');
					}

					$('#siteTab').removeClass('active').siblings().addClass('active in');

					customLevelBtn.prop('disabled', true);
					newTaskBtn.prop('disabled', true);
				} else if(td.eq(6).text() == "<fmt:message key='userSetting.auth.user' />"){
					accLevBtn.data( { "name" : accName, "value" : "2"}).html(accName + '<span class="caret">');

					customLevelBtn.prop('disabled', false);
					newTaskBtn.prop('disabled', false);
				}

				if( !isEmpty(td.eq(3).text() ) && td.eq(3).text() != "-" ){
					$('#newMobileNum').val(td.eq(3).text())
				}

				if( !isEmpty(td.eq(4).text()) && td.eq(4).text() != "-"){
					$('#newEmailAddr').val(td.eq(4).text())
				}

				if( !isEmpty(td.eq(5).text()) && td.eq(5).text() != "-" ){
					$('#newTeam').val(td.eq(5).text())
				}

				if( !isEmpty(td.eq(7).text()) && td.eq(7).text() != "-" ){
					let targetValue = '';
					customLevelBtn.next().find('li').each(function() {
						if ($(this).text() === td.eq(7).text()) {
							targetValue = $(this).data('value');
						}
					});

					newTaskBtn.prop('disabled', true);
					$('.tab-content').addClass('hidden');
					$('.tab-content').prev().addClass('hidden');
					customLevelBtn.prop('disabled', false).data( { "name" : td.eq(7).text(), "value" : targetValue}).html(td.eq(7).text() + '<span class="caret">');
				} else {
					if (!isEmpty(dTable.row('.selected').data().custom_level_yn)
						&& dTable.row('.selected').data().custom_level_yn === 'N'
						&& td.eq(6).text() !== "<fmt:message key='userSetting.auth.admin' />"
					) {
						newTaskBtn.prop('disabled', false);
						$('.tab-content').removeClass('hidden');
						$('.tab-content').prev().removeClass('hidden');
						customLevelBtn.prop('disabled', false).data( { "name" : '업무구분', "value" : 'N'}).html('업무구분 <span class="caret">');
					} else {
						newTaskBtn.prop('disabled', true);
						$('.tab-content').addClass('hidden');
						$('.tab-content').prev().addClass('hidden');
					}

				}

				if(!isEmpty(td.eq(8).text())){
					let textVal = td.eq(8).text();
					if(textVal == "<fmt:message key='userSetting.workType.1' />"){
						newTaskBtn.data( { "name" : textVal, "value" : "0"}).html(textVal + '<span class="caret">');
					} else if(textVal == "<fmt:message key='userSetting.workType.2' />"){
						newTaskBtn.data( { "name" : textVal, "value" : "1"}).html(textVal + '<span class="caret">');
					} else if(textVal == "<fmt:message key='userSetting.workType.3' />"){
						newTaskBtn.data( { "name" : textVal, "value" : "2"}).html(textVal + '<span class="caret">');
					} else if(textVal == "<fmt:message key='userSetting.workType.4' />"){
						newTaskBtn.data( { "name" : textVal, "value" : "3"}).html(textVal + '<span class="caret">');
					} else if(textVal == "<fmt:message key='userSetting.workType.5' />"){
						newTaskBtn.data( { "name" : textVal, "value" : "4"}).html(textVal + '<span class="caret">');
					}
				}

				if(!isEmpty(td.eq(10).text())){
					let textVal = td.eq(10).text()
					if(textVal == "<fmt:message key='userSetting.isUse.Y' />") {
						$('#newUseOpt').prop('checked', true);
					} else if(textVal == "<fmt:message key='userSetting.isUse.N' />") {
						$('#newUseOpt').prop('checked', false);
					}
				}

				if(!isEmpty(prevDesc)){
					$('#newUserDesc').val(prevDesc);
				}

				if (!isEmpty(dTable.row('.selected').data().verify_level)) {
					let textVal = dTable.row('.selected').data().verify_level;
					if (textVal === 1) {
						$('#switchBtn').prop('checked', true);
					} else {
						$('#switchBtn').prop('checked', false);
					}
				} else {
					$('#switchBtn').prop('checked', false);
				}

				$("#addUserModal").addClass("edit").modal("show");
			}
			// DELETE MODAL!!!
			if(option == "delete") {
				let tr = $("#userTable").find("tbody tr.selected");
				let userId = tr.find("td:nth-of-type(2)").text();
				let modal = $("#deleteConfirmModal");
				let deleteBtn = $("#deleteConfirmBtn");
				let confirmId = $("#confirmUserId");

				$("#deleteSuccessMsg span").text(userId);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmId.on('input', function() {
					$(this).val($(this).val().replace(/\s/g, ''));
				});

				confirmId.on("keyup", function() {
					if($(this).val() !== userId) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmId.on("input", function() {
					if($(this).val() !== userId) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});


			}
		}
	}

	function addToList(type) {
		let html = ``;
		if(type == 'site') {
			let name = $("#siteOptList").prev().data("name");
			let siteVal = $("#siteOptList").prev().data("value");

			let siteAccName = $("#siteAccOpt").prev().data("name");
			let accVal = $("#siteAccOpt").prev().data("value");

			let selectedList = $("#selectedSiteList").find("li");

			if(isEmpty(siteVal) || isEmpty(accVal)) {
				$("#isSiteEmpty").removeClass("hidden");
				setTimeout(function(){
					$("#isSiteEmpty").addClass("hidden");
				}, 1600);
				return false;
			} else {
				if(!isEmpty(selectedList)){
					let arr = [];

					if($("#selectedSiteList").prev().hasClass("hidden")){
						$("#selectedSiteList").prev().removeClass("hidden");
					}
					for(let i = 0, length = selectedList.length; i < length; i++) {
						let obj = {}
						obj.siteName = $(selectedList[i]).data("site-name");
						obj.siteId = $(selectedList[i]).data("sid");
						obj.role = $(selectedList[i]).data("role");
						arr.push(obj);
						if( $(selectedList[i]).data("site-name") == name){
							$("#isSiteSelected").removeClass("hidden");
							setTimeout(function(){
								$("#isSiteSelected").addClass("hidden");
							}, 1600);
							return false;
						}
					};
				}

				html = `
					<li class="new" data-sid="${'${siteVal}'}" data-role="${'${accVal}'}" data-site-name="${'${name}'}">${'${name}'}&nbsp;(&nbsp;${'${siteAccName}'}&nbsp;)<!--
					--><button type="button" class="icon-delete" onclick="removeList( $(this).closest('li') )"><fmt:message key='userSetting.delete' /></button><!--
				--></li>
				`;
				$("#selectedSiteList").append(html);
			}
		} else {
			let name = $("#spcOptList").prev().data("name");
			let spcVal = $("#spcOptList").prev().data("value");
			let spcAccName = $("#spcAccOpt").prev().data("name");
			let accVal = $("#spcAccOpt").prev().data("value");

			let selectedList = $("#selectedSpcList").find("li");

			if(isEmpty(spcVal) || isEmpty(accVal)) {
				$("#isSpcEmpty").removeClass("hidden");
				setTimeout(function(){
					$("#isSpcEmpty").addClass("hidden");
				}, 1600);
				return false;
			} else {
				if(!isEmpty(selectedList)){
					let arr = [];
					if($("#selectedSpcList").prev().hasClass("hidden")){
						$("#selectedSpcList").prev().removeClass("hidden");
					}
					for(let i = 0, length = selectedList.length; i < length; i++) {
						let obj = {}
						obj.spcName = $(selectedList[i]).data("spc-name");
						obj.spcId = $(selectedList[i]).data("spc-id");
						obj.role = $(selectedList[i]).data("role");
						arr.push(obj);
						if( $(selectedList[i]).data("spc-name") == name){
							$("#isSpcSelected").removeClass("hidden");
							setTimeout(function(){
								$("#isSpcSelected").addClass("hidden");
							}, 1600);
							return false;
						}
					};
				}
			}

			html = `
				<li class="new" data-spc-id="${'${spcVal}'}" data-role="${'${accVal}'}" data-spc-name="${'${name}'}">${'${name}'}&nbsp;(&nbsp;${'${spcAccName}'}&nbsp;)<!--
				--><button type="button" class="icon-delete" onclick="removeList( $(this).closest('li') )"><fmt:message key='userSetting.delete' /></button><!--
			--></li>
			`;
			$("#selectedSpcList").append(html);
		}
	}

	function removeList(toDelete, self) {
		let selectedList = $("#selectedSiteList");
		let item = selectedList.find("li");
		if(self){
			self.parent().toggleClass("active");
		} else {
			if(item.length == 1 ){
				selectedList.prev().addClass("hidden");
			}
			toDelete.remove();
		}
	}


	function validateAddForm(){
		if( !$("#validId").hasClass("hidden") && ( $("#updateUserForm .tick:not('.checked')").index() == -1 ) && ( $(".warning:not(.hidden)").index() == -1 ) && ( !isEmpty($("#newFullName").val() ) ) && ( !isEmpty($("#newAccLevel").prev().data("value")) )){
			$("#addUserBtn").prop("disabled", false);
			return 1;
		}
	}

	function validateEditForm(){
		if(!isEmpty($("#newUserPwd").val())) {
			if( ($("#updateUserForm .tick:not('.checked')").index() == -1) && ($(".warning:not(.hidden)").index() == -1) ) {
				return 1;
			}
		} else {
			if( $(".warning:not(.hidden)").index() == -1 ) {
				return 1;
			}
		}
	}

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
		password.length >= 8 ? $("#isEightCharLong").addClass("checked") : $("#isEightCharLong").removeClass("checked");

		for (var i = 0; i < rules.length; i++) {
			if( new RegExp(rules[i].Pattern).test(password) ) {
				$("#" + rules[i].Target).addClass("checked")
			} else {
				$("#" + rules[i].Target).removeClass("checked")
			}
		}
	}
</script>

<c:set var="siteList" value="${siteHeaderList}"/> <!-- 사이트 별 -->

<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="deleteConfirmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit"><fmt:message key='userSetting.deleteMsg1' /><br><span class="text-blue"></span>&ensp;<fmt:message key='userSetting.deleteMsg2' /></h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" id="confirmUserId" name="confirm_user_id" placeholder="<fmt:message key='userSetting.enterId' />"/></div>
				</div>
				<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w-80px" data-dismiss="modal" aria-label="Close"><fmt:message key='userSetting.cancel' /></button><!--
				--><button type="button" id="deleteConfirmBtn" class="btn-type w-80px ml-12" disabled><fmt:message key='userSetting.ok' /></button><!--
			--></div>
		</div>
	</div>
</div>

<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content user-modal-content">
			<div id="titleAdd" class="modal-header"><h1><fmt:message key='userSetting.addUser' /><span class="required fr"><fmt:message key='userSetting.required' /></span></h1></div>
			<div id="titleEdit" class="modal-header"><h1><fmt:message key='userSetting.updateInfo' /></h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_user_form" id="updateUserForm" class="setting-form" autocomplete="off">
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label"><span class="asterisk">ID</span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="flex-start">
									<div class="text-input-type offset-width">
										<input type="text" name="new_id" id="newId" placeholder="<fmt:message key='input.input' />" minlength="5" maxlength="15">
									</div>
									<button type="button" class="btn-type fr" onclick="checkId($('#newId').val())" disabled><fmt:message key='userSetting.checkOverlap' /></button>
								</div>
								<small class="hidden warning"><fmt:message key='userSetting.errorTxt.1' /></small>
								<small class="hidden warning"><fmt:message key='userSetting.errorTxt.2' /></small>
								<small class="hidden warning"><fmt:message key='userSetting.errorTxt.3' /></small>
								<small id="invalidId" class="hidden warning"><fmt:message key='userSetting.errorTxt.4' /></small>
								<small id="validId" class="text-blue text-sm hidden"><fmt:message key='userSetting.errorTxt.5' /></small>
							</div>

							<div class="col-lg-2 col-sm-3"><span class="input-label offset"><span class="asterisk"><fmt:message key='userSetting.password' /></span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type">
									<input type="password" id="newUserPwd" name="new_pwd" placeholder="<fmt:message key='userSetting.input' />" minlength="8" maxlength="32">
								</div>
								<div class="flex-start warning-wrapper">
									<small id="hasLet" class="tick"><fmt:message key='userSetting.eng' /></small>
									<small id="hasNum" class="tick"><fmt:message key='userSetting.num' /></small>
									<small id="isEightCharLong" class="tick"><fmt:message key='userSetting.minLength8' /></small>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label"><span class="asterisk"><fmt:message key='userSetting.name' /></span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newFullName" name="new_full_name" placeholder="<fmt:message key='userSetting.input' />" minlength="3" maxlength="28"></div>
								<small class="hidden warning"><fmt:message key='userSetting.errorTxt.6' /></small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset"><span class="asterisk"><fmt:message key='userSetting.password' /></span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type">
									<input type="password" id="confirmNewUserPwd" name="confirm_new_pwd" placeholder="<fmt:message key='userSetting.input' />" minlength="8" maxlength="32">
								</div>
								<div class="flex-start warning-wrapper">
									<small id="pwdUserMatched" class="warning hidden">비밀번호가 일치하지 않습니다.</small>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label"><span class="asterisk"><fmt:message key='userSetting.phone' /></span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="<fmt:message key='userSetting.input' />" maxlength="13"></div>
								<small id="isValidNewMobileNum" class=" warning hidden"><fmt:message key='userSetting.errorTxt.7' /></small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset"><span class="asterisk"><fmt:message key='userSetting.auth' /></span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div id="accLevel" class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<c:if test="${userInfo.role eq '1'}">
											<li data-value="1" data-name="시스템 관리자"><a href="#"><fmt:message key='userSetting.auth.admin' /></a></li>
										</c:if>
										<li data-value="2" data-name="일반 사용자"><a href="#"><fmt:message key='userSetting.auth.user' /></a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label"><span class="asterisk"><fmt:message key='userSetting.email' /></span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="<fmt:message key='input.input' />"></div>
								<small class="hidden warning"><fmt:message key='userSetting.errorTxt.8' /></small>
							</div>
							<c:if test="${activateSPC eq true}">
							<div class="col-lg-2 col-sm-3"><span class="input-label offset"><fmt:message key='userSetting.customAuth' /></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택" disabled="disabled"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
									<ul id="customLevelList" class="dropdown-menu"></ul>
								</div>
							</div>
							</c:if>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label"><fmt:message key='userSetting.isUse' /></span></div>
							<div class="col-lg-4 col-sm-9">
								<label class="switch switch-slide">
									<input type="checkbox" value="showTable" id="newUseOpt" class="switch-input">
									<span class="switch-label" data-on="Y" data-off="N"></span>
									<span class="switch-handle"></span>
								</label>
							</div>
							<c:if test="${activateSPC eq true}">
								<div class="col-lg-2 col-sm-3"><span class="input-label offset"><fmt:message key='userSetting.workType' /></span></div>
								<div class="col-lg-4 col-sm-9">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택" disabled="disabled"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
										<ul id="newTaskList" class="dropdown-menu">
											<li data-name="일반" data-value="0"><a href="#"><fmt:message key='userSetting.workType.1' /></a></li>
											<li data-name="사무수탁사" data-value="1"><a href="#"><fmt:message key='userSetting.workType.2' /></a></li>
											<li data-name="자산운용사" data-value="2"><a href="#"><fmt:message key='userSetting.workType.3' /></a></li>
											<li data-name="출금관리자" data-value="3"><a href="#"><fmt:message key='userSetting.workType.4' /></a></li>
											<li data-name="사업주" data-value="4"><a href="#"><fmt:message key='userSetting.workType.5' /></a></li>
										</ul>
									</div>
								</div>
							</c:if>
						</div>
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label"><fmt:message key='userSetting.certification' /></span></div>
							<div class="col-lg-4 col-sm-9">
								<label class="switch switch-slide">
									<input type="checkbox" value="showTable" id="switchBtn" class="switch-input">
									<span class="switch-label" data-on="Y" data-off="N"></span>
									<span class="switch-handle"></span>
								</label>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset"><span><fmt:message key='userSetting.dep' /></span></span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type">
									<input type="text" id="newTeam" name="team" placeholder="<fmt:message key='userSetting.input' />" >
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label"><fmt:message key='userSetting.info' /></span></div>
							<div class="col-lg-10 col-sm-9">
								<textarea name="new_user_desc" id="newUserDesc" class="textarea w-100" placeholder="<fmt:message key='userSetting.input' />"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<ul class="nav nav-tabs">
									<li class="active w-50"><a data-toggle="tab" href="#siteTab"><fmt:message key='userSetting.site' /></a></li>
									<c:if test="${activateSPC eq true}">
									<li class="w-50"><a data-toggle="tab" href="#spcTab"><fmt:message key='userSetting.spc' /></a></li>
									</c:if>
								</ul>
							</div>
						</div>

						<div class="tab-content">
							<div id="siteTab" class="tab-pane fade in active">
								<div class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex-start">
											<div class="dropdown w-40">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
												<ul id="siteOptList" class="dropdown-menu">
													<c:if test="${fn:length(siteList) > 0}">
														<c:forEach var="site" items="${siteList}">
															<c:if test="${site.name != '직접입력'}">
																<li data-name="${site.name}" data-value="${site.sid}"><a href="#" tabindex="-1">${site.name}</a></li>
															</c:if>
														</c:forEach>
													</c:if>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
												<ul id="siteAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="관리 권한"><a href="#"><fmt:message key='userSetting.auth.manage' /></a></li>
													<li data-value="2" data-name="조회 권한"><a href="#"><fmt:message key='userSetting.auth.search' /></a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('site')"><fmt:message key='userSetting.add' /></button>
										</div>
										<small id="isSiteEmpty" class="warning hidden"><fmt:message key='userSetting.errorTxt.9' /></small>
										<small id="isSiteSelected" class="warning hidden"><fmt:message key='userSetting.errorTxt.10' /></small>
									</div>
									<div class="col-lg-5 col-md-5 col-sm-12"><h2 class="stit hidden"><fmt:message key='userSetting.addList' /></h2><ol id="selectedSiteList" class="selected-list"></ol></div>
								</div>
							</div>
							<c:if test="${activateSPC eq true}">
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex-start">
											<div class="dropdown w-40">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
												<ul id="spcOptList" class="dropdown-menu">
													<template>
														<li data-value="*spcId*" data-name="*spcName*"><a href="#" tabindex="-1">*spcName*</a></li>
													</template>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
												<ul id="spcAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="관리 권한"><a href="#"><fmt:message key='userSetting.auth.manage' /></a></li>
													<li data-value="2" data-name="조회 권한"><a href="#"><fmt:message key='userSetting.auth.search' /></a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('spc')"><fmt:message key='userSetting.add' /></button>
										</div>
										<small id="isSpcEmpty" class="warning hidden"><fmt:message key='userSetting.erroTxt.11' /></small>
										<small id="isSpcSelected" class="warning hidden"><fmt:message key='userSetting.errorTxt.12' /></small>
									</div>
									<div class="col-lg-5 col-md-5 col-sm-12"><h2 class="stit hidden"><fmt:message key='userSetting.addList' /></h2><ul id="selectedSpcList" class="selected-list"></ul></div>

								</div>
							</div>
							</c:if>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key='userSetting.cancel' /></button>
									<button type="submit" id="addUserBtn" class="btn-type" disabled><fmt:message key='userSetting.register' /></button>
									<!-- <button type="submit" id="addUserBtn" class="btn-type">확인</button> -->
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header"><fmt:message key='userSetting.userManage' /></h1>
	</div>
</div>


<div class="row">
	<div class="col-12">
		<div class="flex-group">
			<span class="tx-tit"><fmt:message key='userSetting.userType' /></span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택"><fmt:message key='userSetting.select' /><span class="caret"></span></button>
				<ul class="dropdown-menu" id="userList">
					<li data-value=""><a href="#" tabindex="-1"><fmt:message key='userSetting.all' /></a></li>
					<li data-value="관리자"><a href="#" tabindex="-1"><fmt:message key='userSetting.auth.admin' /></a></li>
					<li data-value="사용자"><a href="#" tabindex="-1"><fmt:message key='userSetting.auth.user' /></a></li>
				</ul>
			</div>
		</div>
		<div class="flex-group userSetting-search">
			<div class="text-input-type">
				<input type="search" id="searchBox" aria-controls="userTable" placeholder="<fmt:message key='userSetting.keywordSearch' />">
			</div>
		</div>
	</div>
<!-- 
	<div class="col-2">
		<div id="exportBtnGroup" class="fr"></div>
		<button type="button" class="btn-save ml-16 fr" onclick="$(this).prev().toggleClass('hidden')">데이터 다운로드</button> 
	</div>
-->
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<!-- <div class="flex-group">
				<div class="dropdown">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
					<ul class="dropdown-menu" id="pageLengthList">
						<li data-value=""><a href="#" tabindex="-1">전체</a></li>
						<li data-value="10"><a href="#" tabindex="-1">10</a></li>
						<li data-value="30"><a href="#" tabindex="-1">30</a></li>
						<li data-value="50"><a href="#" tabindex="-1">50</a></li>
					</ul>
				</div>
				<span class="tx-tit pl-16">개 씩 보기&ensp;</span>
			</div> -->
			<table id="userTable">
				<colgroup>
					<col style="width:6%">
					<col style="width:10%">
					<col style="width:12%">
					<col style="width:9%">
					<col style="width:5%">
					<col style="width:9%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:5%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>