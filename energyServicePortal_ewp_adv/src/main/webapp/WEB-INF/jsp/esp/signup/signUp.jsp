<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">

	var spcDeleteList = [];
	var siteDeleteList = [];

	$(function () {
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

		$("#newFullName").on('input', function(evt) {
			if( $(this).val().match(/['.,!#$%&"*+/=?^`{|}~;:<>]+$/)){
				console.log("matched===");
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

		$("#signUpForm").on("change", function(e){
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
			let val = $("#newAccLevel").prev().data("value");
			if(val == 2) {
				$("#siteAccOpt").prev().data({"value": 2, "name": "조화"}).prop("disabled", true).html("조회 권한<span class='caret'></span>");
				$("#spcAccOpt").prev().data({"value": 2, "name": "조화"}).prop("disabled", true).html("조회 권한<span class='caret'></span>");
			} else {
				$("#siteAccOpt").prev().prop("disabled", false).html("선택<span class='caret'></span>");
				$("#spcAccOpt").prev().prop("disabled", false).html("선택<span class='caret'></span>");
			}
			if($("#addUserModal").hasClass("edit")){
				if( !isEmpty($(this).data("value")) && validateEditForm() == 1) {
					$("#addUserBtn").prop("disabled", false);
				}
			} else {
				if( !isEmpty($(this).data("value")) && validateAddForm() == 1) {
					$("#addUserBtn").prop("disabled", false);
				}
			}
		});

		// Modal event
		$("#addUserModal").on("hide.bs.modal", function(){
			$(this).hasClass("edit") ? $(this).removeClass("edit") : null;

			initModal();
			$("#selectedSiteList").empty();
			$("#selectedSpcList").empty();
			$("#validId").addClass("hidden");
		});

			$("#resultModal").on("hide.bs.modal", function() {
			// console.log("resultModal closed===");
			$(this).find("h4").addClass("hidden");
		});

		// Form Submission
		$("#signUpForm").on("submit", function(e){
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
			let newAffiliation = $("#newAffiliation").val();
			let newEmailAddr =$("#newEmailAddr").val();
			let newTaskList = $("#newTaskList").prev().data("value");
			let newTaskName = $("#newTaskList").prev().data("name");
			let newUseOpt = $("#newUseOpt").prev().data("value");
			let newUswOptName = $("#newUseOpt").prev().data("name");

			let newUserDesc = $("#newUserDesc").val();

			let siteItemList = $("#selectedSiteList").find("li");
			let spcItemList = $("#selectedSpcList").find("li");

			// 1. Add user info
			if(!$("#addUserModal").hasClass("edit")) {
				userObj.login_id = newId;
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
						$("#addUserModal").modal("hide");
						$("#resultSuccessMsg").text("사용자가 추가 되었습니다.").removeClass("hidden");
						$("#resultBtn").parent().addClass("hidden");
						$("#resultModal").modal("show");
						refreshUserList();
						setTimeout(function(){
							$("#resultModal").modal("hide");
						}, 1600);
					}).fail(function (jqXHR, textStatus, errorThrown) {
						$("#addUserModal").modal("hide");
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
								multiPromises.push(Promise.resolve(makeAjaxCall(siteOption)));
							});

							$.each(spcItemList, function(index, element){
								let spcObj = {
									spcid: $(element).data("spc-id"),
									role: Number($(element).data("role"))
								};
								// console.log("opcObj===", spcObj)
								spcOption.data = JSON.stringify(spcObj);
								multiPromises.push(Promise.resolve(makeAjaxCall(spcOption)));
							});

							Promise.all(multiPromises).then(res => {
								console.log("altogether---", res);
								$("#addUserModal").modal("hide");
								$("#resultSuccessMsg").text("SPC, 사이트 정보 모두 추가 되었습니다.").removeClass("hidden");
								$("#resultBtn").parent().addClass("hidden");
								$("#resultModal").modal("show");
								refreshUserList();
								setTimeout(function(){
									$("#resultModal").modal("show");
								}, 1300);
							});

						} else {
							if(siteItemList.length > 0) {
								var sitePromises = [];
								$.each(siteItemList, function(index, element){
									siteObj.sid = $(element).data("sid");
									siteObj.role = Number($(element).data("role"));
									siteOption.data = JSON.stringify(siteObj);
									sitePromises.push(Promise.resolve(makeAjaxCall(siteOption)));
								});
								Promise.all(sitePromises).then(res => {
									console.log("res---", res);
									$("#addUserModal").modal("hide");
									$("#resultSuccessMsg").text("사이트 정보가 추가 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									refreshUserList();
									setTimeout(function(){
										$("#resultModal").modal("show");
									}, 1300);
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
									spcPromises.push(Promise.resolve(makeAjaxCall(spcOption)));
								});
								Promise.all(spcPromises).then(res => {
									// console.log("res---", res);
									$("#addUserModal").modal("hide");
									$("#resultSuccessMsg").text("SPC 정보가 추가 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									refreshUserList();
									setTimeout(function(){
										$("#resultModal").modal("show");
									}, 1300);
								});
							}
						}
					}).fail(function (jqXHR, textStatus, errorThrown) {
						let r = JSON.parse(jqXHR.responseText);
						console.log("에러코드:" + jqXHR.status + "\n" + "메세지: " + r);
						return false;
					});
				}
			} else {
			// 2. Edit existing user info
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

				console.log("prevDesc===", prevDesc)

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
				if( !isEmpty(newTaskList) && !isEmpty(newTaskList) && ( newTaskName != td.eq(7).text() ) ) {
					editUserObj.task = newTaskList;
				}

				if( !isEmpty(newUseOpt) && (newUswOptName != td.eq(9).text() ) ) {
					console.log("newUseOpt===", newUseOpt, "newUswOptName===", newUswOptName)
					editUserObj.valid_yn = newUseOpt;
				}

				if( !isEmpty(prevDesc) ) {
					if( newUserDesc.replace("\t", "") != prevDesc.replace("\t", "") ) {
						editUserObj.description = newUserDesc;
					}
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
					$("#resultFailureMsg").text("변경하실 사용자, 사이트, SPC 정보를 입력해 주세요").removeClass("hidden");
					$("#resultBtn").parent().addClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						$("#resultModal").modal("show");
					}, 1800);
				} else {
					if( (flagIndex < 0) ){
						// if pwd && editUserObj values are present but no userSpc && userSite info
						if( !isEmpty($("#newUserPwd").val()) && !isEmpty(editUserObj) ){
							$.when($.ajax(optionPwd),$.ajax(option)).done(function (result1, result2) {
								console.log("editUserObj===", editUserObj, "newUser Pwd====", $("#newUserPwd").val() )
								console.log("result1===", result1, "result2====", result2)
								$("#addUserModal").modal("hide");
								$("#resultSuccessMsg").text("사용자 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
								$("#resultBtn").parent().addClass("hidden");
								$("#resultModal").modal("show");
								refreshUserList();
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1200);
							}).fail(function (jqXHR, textStatus, errorThrown) {
								console.log("result1===", jqXHR);
								$("#addUserModal").modal("hide");
								$("#resultFailureMsg").text("사용자 정보 변경에 실패하였습니다. 다시 시도해 주세요.").removeClass("hidden");
								$("#resultBtn").parent().removeClass("hidden");
								$("#resultModal").modal("show");
								setTimeout(function(){
									$("#resultModal").modal("hide");
								}, 1200);
								return false;
							});

						} else {
							// if either pwd && editUserObj values are present (YES), but (NO) userSpc && userSite info
							if( !isEmpty($("#newUserPwd").val()) ){
								console.log("optionPwd===", optionPwd)
								$.ajax(optionPwd).done(function (json, textStatus, jqXHR) {
									console.log("only password has been changed=====", optionPwd);
									$("#addUserModal").modal("hide");
									$("#resultSuccessMsg").multiline("사용자 정보가\n성공적으로 변경 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									refreshUserList();
									setTimeout(function(){
										$("#resultModal").modal("hide");
									}, 1200);
									console.log("newUserPwd edit success===", json)
								}).fail(function (jqXHR, textStatus, errorThrown) {
									let errorMsg = "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown;
									$("#addUserModal").modal("hide");
									$("#resultFailureMsg").multiline(errorMsg).removeClass("hidden");
									$("#resultBtn").parent().removeClass("hidden");
									$("#resultModal").modal("show");
									console.log("newUserPwd edit error===", errorMsg);
									return false;
								});
							}

							if( !isEmpty(editUserObj) ){
								console.log("editUserObj===", editUserObj)
								$.ajax(option).done(function (json, textStatus, jqXHR) {
									$("#addUserModal").modal("hide");
									$("#resultSuccessMsg").multiline("사용자 정보가\n성공적으로 변경 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									refreshUserList();
									setTimeout(function(){
										$("#resultModal").modal("hide");
									}, 1200);
								}).fail(function (jqXHR, textStatus, errorThrown) {
									let errorMsg = "에러코드:" + jqXHR.status + "\n" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown;
									$("#addUserModal").modal("hide");
									$("#resultFailureMsg").text(errorMsg).removeClass("hidden");
									$("#resultBtn").parent().removeClass("hidden");
									$("#resultModal").modal("show");
									console.log("editUserObj EDIT FAIL===", errorMsg);
									return false;
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
						// console.log("nestedPromises===", nestedPromises)

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
										console.log("res---", res);
										$("#addUserModal").modal("hide");
										$("#resultSuccessMsg").text("사용자 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
										$("#resultBtn").parent().addClass("hidden");
										$("#resultModal").modal("show");
										refreshUserList();
										setTimeout(function(){
											$("#resultModal").modal("hide");
										}, 1500);
									});
								}
							}).fail(function (jqXHR, textStatus, errorThrown) {
								console.log("result1===", jqXHR);
								$("#addUserModal").modal("hide");
								$("#resultFailureMsg").text("사용자 정보 변경에 실패하였습니다. 다시 시도해 주세요.").removeClass("hidden");
								$("#resultBtn").parent().removeClass("hidden");
								$("#resultModal").modal("show");
								return false;
							});

						} else {
							// only flagArr is present
							if( isEmpty(editUserObj) && isEmpty($("#newUserPwd").val())) {
								// console.log("only flagArr is present---");
								if(nestedPromises.length>0){
									Promise.all(nestedPromises).then(res => {
										console.log("res---", res);
										$("#addUserModal").modal("hide");
										$("#resultSuccessMsg").text("사이트/SPC 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
										$("#resultBtn").parent().addClass("hidden");
										$("#resultModal").modal("show");
										refreshUserList();
										setTimeout(function(){
											$("#resultModal").modal("hide");
										}, 1500);
									});
								}
							} else {
								if( !isEmpty($("#newUserPwd").val()) ){
									$.ajax(optionPwd).done(function (json, textStatus, jqXHR) {
										if(nestedPromises.length>0){
											Promise.all(nestedPromises).then(res => {
												$("#addUserModal").modal("hide");
												$("#resultSuccessMsg").text("사용자 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
												$("#resultBtn").parent().addClass("hidden");
												$("#resultModal").modal("show");
												refreshUserList();
												setTimeout(function(){
													$("#resultModal").modal("hide");
												}, 1500);
											});
										} else {
											$("#addUserModal").modal("hide");
											$("#resultSuccessMsg").text("사용자 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
											$("#resultBtn").parent().addClass("hidden");
											$("#resultModal").modal("show");
											setTimeout(function(){
												$("#resultModal").modal("hide");
											}, 1500);
										}
									
									}).fail(function (jqXHR, textStatus, errorThrown) {
										let errorMsg = "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown;
										$("#resultFailureMsg").multiline(errorMsg).removeClass("hidden");
										$("#resultBtn").parent().removeClass("hidden");
										$("#resultModal").modal("show");

										console.log('newUserPwd===', errorMsg)
										return false;
									});
								}
								if( !isEmpty(editUserObj) ){
									// console.log("editUserObj only + nestedPromises")
									$.ajax(option).done(function (json, textStatus, jqXHR) {
										if(nestedPromises.length>0){
											Promise.all(nestedPromises).then(res => {
												$("#addUserModal").modal("hide");
												$("#resultSuccessMsg").text("사용자 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
												$("#resultBtn").parent().addClass("hidden");
												$("#resultModal").modal("show");
												refreshUserList();
												setTimeout(function(){
													$("#resultModal").modal("hide");
												}, 1500);
											});
										}
									}).fail(function (jqXHR, textStatus, errorThrown) {
										let errorMsg = "에러코드:" + jqXHR.status + "\n" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown;
										$("#addUserModal").modal("hide");
										$("#resultFailureMsg").text(errorMsg).removeClass("hidden");
										$("#resultBtn").parent().removeClass("hidden");
										$("#resultModal").modal("show");
										console.log("user Obj available===", errorMsg);
										return false;
									});
								}
							}

						}

					}

				}
			}
		});


		// Table Row Select event
		// $('#userTable tbody').on('click', 'tr', function () {
		// 	if ( $(this).hasClass('selected') ) {
		// 		$(this).removeClass('selected');
		// 	}
		// 	else {
		// 		$('#userTable tr.selected').removeClass('selected');
		// 		$(this).addClass('selected');
		// 	}
		// });


	});

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
		let form = $("#signUpForm");
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

		$.each(dropdown, function(index, element){
			$(this).html('선택' + '<span class="caret"></span>');
			$(this).data("value", "");
		});

	}

	function validateAddForm(){
		if( !$("#validId").hasClass("hidden") && ( $("#signUpForm .tick:not('.checked')").index() == -1 ) && ( $(".warning:not(.hidden)").index() == -1 ) && ( !isEmpty($("#newFullName").val() ) ) && ( !isEmpty($("#newAccLevel").prev().data("value")) )){
			$("#addUserBtn").prop("disabled", false);
			return 1;
		}
	}

	function validateEditForm(){
		if(!isEmpty($("#newUserPwd").val())) {
			if( ($("#signUpForm .tick:not('.checked')").index() == -1) && ($(".warning:not(.hidden)").index() == -1) ) {
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
		password.length >= 8 ? $("#eightCharLong").addClass("checked") : $("#eightCharLong").removeClass("checked");

		for (var i = 0; i < rules.length; i++) {
			if( new RegExp(rules[i].Pattern).test(password) ) {
				$("#" + rules[i].Target).addClass("checked")
			} else {
				$("#" + rules[i].Target).removeClass("checked")
			}
		}
	}


	// function cloneSpcRow(){
	// 	let clone = $("#spcRow .flex-start:first-of-type").clone();
	// 	let length = $("#spcRow .flex-start").length;
	// 	let ul = $(clone).find(".dropdown-menu");
	// 	let id = $(ul).attr("id");

	// 	$.each(ul, function(index, element){
	// 		$(this).attr("id", id.replace(/(\d+)/, length));
	// 	});
	// 	$(clone).find(".btn-close").removeClass("hidden");

	// 	$("#spcRow").append($(clone));
	// }


	// function onlyOne(self) {
	// 	var checkboxes = document.getElementsByName('user_row');
	// 	tr.addClass("selected");
	// 	tr.siblings().removeClass("selected");

	// 	checkboxes.forEach((item, index) => {
	// 		if (item !== self) {
	// 			item.checked = false;
	// 		}
	// 	});
	// }

</script>



<div class="modal fade stack" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 id="resultSuccessMsg" class="text-blue hidden">사용자가 성공적으로<br>추가 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">사용자 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
			</div>
			<div class="btn-wrap-type05"><!--
			--><button type="button" id="resultBtn" class="btn-type03" data-dismiss="modal" aria-label="Close">확인</button><!--
		--></div>
		</div>
	</div>
</div>


<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content user-modal-content">
			<div id="titleAdd" class="modal-header"><h1>사용자 추가<span class="required fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사용자 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_user_form" id="signUpForm" class="setting-form">
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label asterisk">ID</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="flex-start">
									<div class="text-input-type offset-width">
										<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
									</div>
									<button type="button" class="btn-type fr" onclick="checkId($('#newId').val())" disabled>중복 체크</button>
								</div>
								<small class="hidden warning">사용자 아이디를 입력해 주세요</small>
								<small class="hidden warning">5~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">한글, 특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidId" class="hidden warning">동일한 아이디가 존재합니다.</small>
								<small id="validId" class="text-blue text-sm hidden">사용 가능한 아이디 입니다.</small>
							</div>

							<div class="col-lg-2 col-sm-3"><span class="input-label offset asterisk">비밀번호</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><!--
									--><input type="password" id="newUserPwd" name="new_pwd" placeholder="입력" minlength="6" maxlength="32">
									<%--
										<button type="button" class="pwd-icon" onclick="showPwd('newUserPwd', this)">show</button>
									--%>
									</div>
								<div class="flex-start warning-wrapper">
									<small id="hasLet" class="tick">영문</small>
									<small id="hasNum" class="tick">숫자</small>
									<small id="eightCharLong" class="tick">8자리 이상</small>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label asterisk">이름</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newFullName" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
								<small class="hidden warning">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset asterisk">권한 등급</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<li data-value="1" data-name="시스템 관리자"><a href="#">시스템 관리자</a></li>
										<li data-value="2" data-name="일반 사용자"><a href="#">일반 사용자</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">휴대폰</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력" maxlength="13"></div>
								<small id="isValidNewMobileNum" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset">소속</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newAffiliation" name="new_affiliation" placeholder="입력">
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">이메일</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="입력"></div>
								<small class="hidden warning">올바른 이메일 형식을 입력해 주세요.</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset">업무 구분</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newTaskList" class="dropdown-menu">
										<li data-name="일반" data-value="0"><a href="#">일반</a></li>
										<li data-name="사무수탁사" data-value="1"><a href="#">사무 수탁사</a></li>
										<li data-name="자산운용사" data-value="2"><a href="#">자산 운용사</a></li>
										<li data-name="출금관리자" data-value="3"><a href="#">출금 관리자</a></li>
										<li data-name="사업주" data-value="4"><a href="#">사업주</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">사용 여부</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newUseOpt" class="dropdown-menu">
										<li data-name="사용" data-value="Y"><a href="#">Y</a></li>
										<li data-name="중지" data-value="N"><a href="#">N</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">설명</span></div>
							<div class="col-lg-10 col-sm-9">
								<textarea name="new_user_desc" id="newUserDesc" class="textarea w-100" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<ul class="nav nav-tabs">
									<li class="active w-50"><a data-toggle="tab" href="#siteTab">사업소</a></li>
									<li class="w-50"><a data-toggle="tab" href="#spcTab">SPC</a></li>
								</ul>
							</div>
						</div>

						<div class="tab-content">
							<div id="siteTab" class="tab-pane fade in active">
								<div class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex-start">
											<div class="dropdown w-40">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="siteOptList" class="dropdown-menu">
													<c:if test="${fn:length(siteList) > 1}">
														<c:forEach var="site" items="${siteList}">
															<c:if test="${site.name != '직접입력'}">
																<li data-name="${site.name}" data-value="${site.sid}"><a href="#" tabindex="-1">${site.name}</a></li>
															</c:if>
														</c:forEach>
													</c:if>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="siteAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">관리 권한</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회 권한</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('site')">추가</button>
										</div>
										<small id="isSiteEmpty" class="warning hidden">추가하실 사이트의 옵션을 선택해 주세요.</small>
										<small id="isSiteSelected" class="warning hidden">동일한 사이트가 이미 추가 되었습니다.</small>
									</div>
									<div class="col-lg-5 col-md-5 col-sm-12"><h2 class="stit hidden">추가 리스트</h2><ol id="selectedSiteList" class="selected-list"></ol></div>
								</div>
							</div>
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex-start">
											<div class="dropdown w-40">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="spcOptList" class="dropdown-menu">
													<template>
														<li data-value="*spcId*" data-name="*spcName*"><a href="#" tabindex="-1">*spcName*</a></li>
													</template>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="spcAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">수정/조회</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('spc')">추가</button>
										</div>
										<small id="isSpcEmpty" class="warning hidden">추가하실 SPC 옵션을 선택해 주세요.</small>
										<small id="isSpcSelected" class="warning hidden">동일한 SPC가 이미 추가 되었습니다.</small>
									</div>
									<div class="col-lg-5 col-md-5 col-sm-12"><h2 class="stit hidden">추가 리스트</h2><ul id="selectedSpcList" class="selected-list"></ul></div>

								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addUserBtn" class="btn-type" disabled>등록</button>
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
		<h1 class="page-header">사용자 관리 설정</h1>
	</div>
</div>


<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content user-modal-content">
			<div id="titleAdd" class="modal-header"><h1>사용자 추가<span class="required fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사용자 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_user_form" id="signUpForm" class="setting-form">
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label asterisk">ID</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="flex-start">
									<div class="text-input-type offset-width">
										<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
									</div>
									<button type="button" class="btn-type fr" onclick="checkId($('#newId').val())" disabled>중복 체크</button>
								</div>
								<small class="hidden warning">사용자 아이디를 입력해 주세요</small>
								<small class="hidden warning">5~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">한글, 특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidId" class="hidden warning">동일한 아이디가 존재합니다.</small>
								<small id="validId" class="text-blue text-sm hidden">사용 가능한 아이디 입니다.</small>
							</div>

							<div class="col-lg-2 col-sm-3"><span class="input-label offset asterisk">비밀번호</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><!--
									--><input type="password" id="newUserPwd" name="new_pwd" placeholder="입력" minlength="6" maxlength="32">
									<%--
										<button type="button" class="pwd-icon" onclick="showPwd('newUserPwd', this)">show</button>
									--%>
								</div>
								<div class="flex-start warning-wrapper">
									<small id="hasLet" class="tick">영문</small>
									<small id="hasNum" class="tick">숫자</small>
									<small id="eightCharLong" class="tick">8자리 이상</small>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label asterisk">이름</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newFullName" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
								<small class="hidden warning">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset asterisk">권한 등급</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<li data-value="1" data-name="시스템 관리자"><a href="#">시스템 관리자</a></li>
										<li data-value="2" data-name="일반 사용자"><a href="#">일반 사용자</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">휴대폰</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력" maxlength="13"></div>
								<small id="isValidNewMobileNum" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset">소속</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newAffiliation" name="new_affiliation" placeholder="입력">
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">이메일</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="text-input-type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="입력"></div>
								<small class="hidden warning">올바른 이메일 형식을 입력해 주세요.</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input-label offset">업무 구분</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newTaskList" class="dropdown-menu">
										<li data-name="일반" data-value="0"><a href="#">일반</a></li>
										<li data-name="사무수탁사" data-value="1"><a href="#">사무 수탁사</a></li>
										<li data-name="자산운용사" data-value="2"><a href="#">자산 운용사</a></li>
										<li data-name="출금관리자" data-value="3"><a href="#">출금 관리자</a></li>
										<li data-name="사업주" data-value="4"><a href="#">사업주</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">사용 여부</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newUseOpt" class="dropdown-menu">
										<li data-name="사용" data-value="Y"><a href="#">Y</a></li>
										<li data-name="중지" data-value="N"><a href="#">N</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input-label">설명</span></div>
							<div class="col-lg-10 col-sm-9">
								<textarea name="new_user_desc" id="newUserDesc" class="textarea w-100" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<ul class="nav nav-tabs">
									<li class="active w-50"><a data-toggle="tab" href="#siteTab">사업소</a></li>
									<li class="w-50"><a data-toggle="tab" href="#spcTab">SPC</a></li>
								</ul>
							</div>
						</div>

						<div class="tab-content">
							<div id="siteTab" class="tab-pane fade in active">
								<div class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex-start">
											<div class="dropdown w-40">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="siteOptList" class="dropdown-menu">
													<c:if test="${fn:length(siteList) > 1}">
														<c:forEach var="site" items="${siteList}">
															<c:if test="${site.name != '직접입력'}">
																<li data-name="${site.name}" data-value="${site.sid}"><a href="#" tabindex="-1">${site.name}</a></li>
															</c:if>
														</c:forEach>
													</c:if>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="siteAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">관리 권한</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회 권한</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('site')">추가</button>
										</div>
										<small id="isSiteEmpty" class="warning hidden">추가하실 사이트의 옵션을 선택해 주세요.</small>
										<small id="isSiteSelected" class="warning hidden">동일한 사이트가 이미 추가 되었습니다.</small>
									</div>
									<div class="col-lg-5 col-md-5 col-sm-12"><h2 class="stit hidden">추가 리스트</h2><ol id="selectedSiteList" class="selected-list"></ol></div>
								</div>
							</div>
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex-start">
											<div class="dropdown w-40">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="spcOptList" class="dropdown-menu">
													<template>
														<li data-value="*spcId*" data-name="*spcName*"><a href="#" tabindex="-1">*spcName*</a></li>
													</template>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="spcAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">수정/조회</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('spc')">추가</button>
										</div>
										<small id="isSpcEmpty" class="warning hidden">추가하실 SPC 옵션을 선택해 주세요.</small>
										<small id="isSpcSelected" class="warning hidden">동일한 SPC가 이미 추가 되었습니다.</small>
									</div>
									<div class="col-lg-5 col-md-5 col-sm-12"><h2 class="stit hidden">추가 리스트</h2><ul id="selectedSpcList" class="selected-list"></ul></div>

								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addUserBtn" class="btn-type" disabled>등록</button>
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
