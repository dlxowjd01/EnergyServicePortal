<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">

	var spcDeleteList = [];
	var siteDeleteList = [];

	$(function () {
		// let sL = JSON.parse('${siteList}');
		// console.log("sL---", sL);

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
			if ($(this).data('value') == '1') {
				if ($('.nav-tabs > li').eq(0).find('a').attr('href') == '#siteTab') {
					$('.nav-tabs > li').eq(0).addClass('hidden').removeClass('active').siblings().addClass('active');
				}

				$('#siteTab').removeClass('active').siblings().addClass('active in');
			} else {
				$('.nav-tabs > li').eq(0).removeClass('hidden');
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
				$("#deleteSuccessMsg").text("사용자가 삭제 되었습니다.").removeClass("hidden");
				refreshUserList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("fail==", jqXHR);
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("사용자 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
			});
		});

		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#confirmUserId").val("");
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
									console.log("element====", element)
									siteObj.sid = $(element).data("sid");
									siteObj.role = Number($(element).data("role"));
									siteOption.data = JSON.stringify(siteObj);
									sitePromises.push(Promise.resolve(makeAjaxCall(siteOption)));
								});
								Promise.all(sitePromises).then(res => {
									$("#addUserModal").modal("hide");
									$("#resultSuccessMsg").text("사이트 정보가 추가 되었습니다.").removeClass("hidden");
									$("#resultBtn").parent().addClass("hidden");
									$("#resultModal").modal("show");
									refreshUserList();
									setTimeout(function(){
										$("#resultModal").modal("hide");
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
										$("#resultModal").modal("hide");
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
					$("#resultFailureMsg").text("변경하실 사용자, 사이트, SPC 정보를 입력해 주세요").removeClass("hidden");
					$("#resultBtn").parent().addClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						$("#resultModal").modal("hide");
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
						obj.user_role = "시스템 관리자"
					} else {
						obj.user_role = "일반 사용자"
					}

					if(item.task == 0){
						obj.user_task = "일반"
					} else if(item.task == 1){
						obj.user_task = "사무 수탁사"
					} else if(item.task == 2){
						obj.user_task = "자산 운용사"
					} else if(item.task == 3){
						obj.user_task = "출금 관리자"
					} else if(item.task == 4){
						obj.user_task = "사업주"
					}

					if(!isEmpty(item.createdAt)){
						let d = new Date(item.createdAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(item.createdAt).toLocaleTimeString();
						obj.created_at = d;
					} else {
						obj.created_at = "-";
					}

					if(!isEmpty(item.valid_yn)){
						if(item.valid_yn == "Y"){
							obj.valid_yn = "사용"
						} else {
							obj.valid_yn = "중지"
						}
					} else {
						obj.valid_yn = "-";
					}

					if(!isEmpty(item.description)){
						obj.desc = item.description;
					}
					obj.uid = item.uid;
					obj.idx = index + 1;
					newArr.push(obj);
					// console.log("uid---", item.uid)
				})).then( () => {
					if(!callback) {
						var userTable = $('#userTable').DataTable({
							"aaData": newArr,
							// "bDeferRender": true,
							"fixedHeader": true,
							"table-layout": "fixed",
							// "bStateSave": true,
							// "bStateDuration": 60 * 60 * 24,
							"bAutoWidth": true,					
							"bSearchable" : true,
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
							],
							"aoColumns": [
								{
									"sTitle": "",
									"mData": "null",
									"mRender": function ( data, type, full, rowIndex )  {
										return '<a class="chk_type" href="#"><input type="checkbox" id="' + rowIndex.row + '" name="table_checkbox"><label for="' + rowIndex.row + '"></label></a>'
									},
									"className": "dt-body-center no-sorting"
								},
								{
									"sTitle": "ID",
									// "mData": null,
									// "mRender": function ( data, type, row )  {
									// 	return '<span id="'+row.user_id+'" data-id="'+row.uid+'">' + row.user_id + '</span>'
									// 	// return '<a href="#"><input type="checkbox" name="user_row" id="'+row.user_id+'" data-id="'+row.uid+'" class="table-checkbox"><label for="' + row.user_id + '"></label></a>'
									// },
									"mData": "user_id"
								},
								{
									"sTitle": "이름",
									"mData": "name",
								},
								{
									"sTitle": "휴대폰",
									"mData": "contact_phone",
								},
								{
									"sTitle": "이메일",
									"mData": "contact_email",
								},
								{
									"sTitle": "소속",
									"mData": "team",
								},
								{
									"sTitle": "권한 등급",
									"mData": "user_role",
									"className": "acc-level"
								},
								{
									"sTitle": "업무 구분",
									"mData": "user_task",
								},
								{
									"sTitle": "등록일자",
									"mData": "created_at",
								},
								{
									"sTitle": "사용 여부",
									"mData": "valid_yn",
								},
							],
							"dom": 'tip',
							"select": {
								style: 'single',
								selector: 'td input[type="checkbox"], tr'
							},
							initComplete: function(){
								let str = `
									<div id="btnGroup" class="right-end"><!--
										--><button type="button" disabled class="btn_type03" onclick="updateModal('edit')">선택 수정</button><!--
										--><button type="button" disabled class="btn_type03" onclick="updateModal('delete')">선택 삭제</button><!--
								--></div>
								`;
								let addBtnStr = `
									<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>
								`;
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
							let btn = $("#btnGroup").find(".btn_type03");
							btn.each(function(index, element){
								if($(this).is(":disabled")){
									$(this).prop("disabled", false);
								}
							});
							userTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
							// console.log("dt---", userTable[ type ]( indexes ).nodes())
						}).on("deselect", function(e, dt, type, indexes) {
							let btn = $("#btnGroup").find(".btn_type03");
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
										return '<a class="chk_type" href="#"><input type="checkbox" id="' + row.idx + '" name="table_checkbox"><label for="' + row.idx + '"></label></a>'
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
									// "mData": null,
									// "mRender": function ( data, type, row )  {
									// 	return '<span id="'+row.user_id+'" data-id="'+row.uid+'">' + row.user_id + '</span>'
									// 	// return '<a href="#"><input type="checkbox" name="user_row" id="'+row.user_id+'" data-id="'+row.uid+'" class="table-checkbox"><label for="' + row.user_id + '"></label></a>'
									// },
									"mData": "user_id"
								},
								{
									"sTitle": "이름",
									"mData": "name",
								},
								{
									"sTitle": "휴대폰",
									"mData": "contact_phone",
								},
								{
									"sTitle": "이메일",
									"mData": "contact_email",
								},
								{
									"sTitle": "소속",
									"mData": "team",
								},
								{
									"sTitle": "권한 등급",
									"mData": "user_role",
									"className": "acc-level"
								},
								{
									"sTitle": "업무 구분",
									"mData": "user_task",
								},
								{
									"sTitle": "등록일자",
									"mData": "created_at",
								},
								{
									"sTitle": "사용 여부",
									"mData": "valid_yn",
								},
							],

							"dom": 'tip',
							"select": {
								style: 'single',
								selector: 'td input[type="checkbox"], tr',
							},
							initComplete: function(){
								let str = `
									<div id="btnGroup" class="right-end"><!--
										--><button type="button" disabled class="btn_type03" onclick="updateModal('edit')">선택 수정</button><!--
										--><button type="button" disabled class="btn_type03" onclick="updateModal('delete')">선택 삭제</button><!--
								--></div>
								`;
								let addBtnStr = `
									<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>
								`;
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
							let btn = $("#btnGroup").find(".btn_type03");
							btn.each(function(index, element){
								if($(this).is(":disabled")){
									$(this).prop("disabled", false);
								}
							});
							userTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
						}).on("deselect", function(e, dt, type, indexes) {
							let btn = $("#btnGroup").find(".btn_type03");
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

					new $.fn.dataTable.Buttons( userTable, {
						name: 'commands',
						"buttons": [
							{
								extend: 'excelHtml5',
								className: "save_btn",
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

					userTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
					
					$("#newAffiliation").autocomplete({
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
					
					$("#userList").find("li").on( 'click', function(){
						if(!isEmpty($(this).data("value"))){
							filterColumn( "#userTable", "6", $(this).data("value"));
						} else {
							filterColumn("#userTable", "6", "");
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
					"title": "이름",
					"data": null,
				},
				{
					"title": "휴대폰",
					"data": null
				},
				{
					"title": "이메일",
					"data": null,
				},
				{
					"title": "소속",
					"data": null,
				},
				{
					"title": "권한 등급",
					"data": null,
				},
				{
					"title": "업무 구분",
					"data": null,
				},
				{
					"title": "등록일",
					"data": null,
				},
				{
					"title": "사용 여부",
					"data": null,
				}
			],
			"dom": 'tip',
			"language": {
				"emptyTable": "조회된 데이터가 없습니다.",
				"zeroRecords":  "검색된 결과가 없습니다."
			},
			initComplete: function(){
				this.addClass("no-stripe");
				let addBtnStr = `
					<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>
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

		$.each(dropdown, function(index, element){
			$(this).html('선택' + '<span class="caret"></span>');
			$(this).data("value", "");
		});

	}

	function updateModal(option){
		let addBtn  = $("#addUserBtn");
		let titleAdd = $('#titleAdd');
		let id = $('#newId');
		let accLevBtn = $('#newAccLevel').prev();
		let newTaskBtn =$('#newTaskList').prev();
		let required = $("#updateUserForm").find(".asterisk");

		$('.nav-tabs > li').eq(0).removeClass('hidden').addClass('active').siblings().removeClass('active');
		$('div.tab-content > div.tab-pane').eq(0).addClass('active in').siblings().removeClass('active in');

		id.parent().next().prop("disabled", true);
		// ADD !!!!!
		if(option == 'add'){
			initModal();
			if(id.parent().next().hasClass("hidden")) {
				id.parent().next().removeClass("hidden");
				id.parent().addClass("offset-width").removeClass("w-100");
			}
			titleAdd.removeClass("hidden").next().addClass("hidden");
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			addBtn.prop("disabled", true).text("등록");
			$('#newId').prop('disabled', false);
			$("#addUserModal").removeClass("edit").modal("show");
		} else {
			let dTable = $("#userTable").DataTable();
			let tr = $("#userTable").find("tbody tr.selected");
			let td = tr.find("td");
			let uid = dTable.row(tr).data().uid;
			let prevDesc = dTable.row(tr).data().desc;

			// EDIT!!!!!
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

				addBtn.prop("disabled", false).text("수정");

				$.when($.ajax(optSite), $.ajax(optSpc)).done(function (result1, result2) {
					let siteData = result1[0].data;
					console.log("siteData===", siteData);

					if(siteData.length > 0){

						let siteOptList = $("#siteOptList li").toArray();
						let siteStr = ``;

						console.log("siteOptList===", siteOptList);
						$.each(siteData, function( index, item ) {
							siteOptList.some( x => {
								if($(x).data("value") === item.sid) {
									// console.log("item---", item.sid)
									let name = $(x).data("name");
									let role = "";
									if(item.role == 1){
										role = "관리 권한";
									} else {
										role = "조회 권한";
									}

									siteStr += `
									<li class="delete" data-sid="${'${item.sid}'}" data-role="${'${item.role}'}" data-site-name="${'${name}'}">${'${name}'}&nbsp;(&nbsp;${'${role}'}&nbsp;)
										<button type="button" class="icon-delete text-btn" onclick="removeList( $(this).closest('li'), $(this) )">삭제 예정</button>
									</li>
									`;
									siteDeleteList.push(item.usid);
								}
							});
						});

						console.log("siteDeleteList===", siteDeleteList)
						$("#selectedSiteList").append(siteStr).prev().html("수정 리스트&emsp;<span class='fr'>(&nbsp;<strong class='text-orange'>삭제 예정</strong>&ensp;선택 시, 등록된 기존 정보 삭제)</span>").removeClass("hidden");
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
									item.role == "1" ? role = "관리 권한" : role = "조회 권한";

									spcStr += `
										<li class="delete" data-spc-id="${'${item.spcid}'}" data-role="${'${item.role}'}" data-spc-name="${'${name}'}">${'${name}'}&nbsp;(&nbsp;${'${role}'}&nbsp;)
											<button type="button" class="icon-delete text-btn" onclick="removeList( $(this).closest('li'), $(this) )">삭제 예정</button>
										</li>
									`;
									spcDeleteList.push(item.uspcid);
								}
							});
						});
						$("#selectedSpcList").append(spcStr).prev().html("수정 리스트&emsp;<span class='fr'>(&nbsp;<strong class='text-orange'>삭제 예정</strong>&ensp;선택 시, 등록된 기존 정보 삭제)</span>").removeClass("hidden");;
					}

					let val = $("#newAccLevel").prev().data("value");
					$("#siteAccOpt").prev().prop("disabled", false).html("선택<span class='caret'></span>");
					$("#spcAccOpt").prev().prop("disabled", false).html("선택<span class='caret'></span>");
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
				if(td.eq(6).text() == "시스템 관리자"){
					accLevBtn.data( { "name" : accName, "value" : "1"}).html(accName+ '<span class="caret">');
					if ($('.nav-tabs > li').eq(0).find('a').attr('href') == '#siteTab') {
						$('.nav-tabs > li').eq(0).addClass('hidden').removeClass('active').siblings().addClass('active');
					}

					$('#siteTab').removeClass('active').siblings().addClass('active in');
				} else if(td.eq(6).text() == "일반 사용자"){
					accLevBtn.data( { "name" : accName, "value" : "2"}).html(accName + '<span class="caret">');
				}

				if( !isEmpty(td.eq(3).text() ) && td.eq(3).text() != "-" ){
					$('#newMobileNum').val(td.eq(3).text())
				}

				if( !isEmpty(td.eq(4).text()) && td.eq(4).text() != "-"){
					$('#newEmailAddr').val(td.eq(4).text())
				}

				if( !isEmpty(td.eq(5).text()) && td.eq(5).text() != "-" ){
					$('#newAffiliation').val(td.eq(5).text())
				}

				if(!isEmpty(td.eq(7).text())){
					let textVal = td.eq(7).text()
					if(textVal == "일반"){
						newTaskBtn.data( { "name" : textVal, "value" : "0"}).html(textVal + '<span class="caret">');
					} else if(textVal == "사무 수탁사"){
						newTaskBtn.data( { "name" : textVal, "value" : "1"}).html(textVal + '<span class="caret">');
					} else if(textVal == "자산 운용사"){
						newTaskBtn.prev().data( { "name" : textVal, "value" : "2"}).html(textVal + '<span class="caret">');
					} else if(textVal == "사업주"){
						newTaskBtn.prev().data( { "name" : textVal, "value" : "3"}).html(textVal + '<span class="caret">');
					}
				}

				if(!isEmpty(td.eq(9).text())){
					let textVal = td.eq(9).text()
					if(textVal == "사용"){
						$('#newUseOpt').prev().data({ "name" : textVal,  "value": "Y" }).html( "Y" + '<span class="caret">');
					} else if(textVal == "중지") {
						$('#newUseOpt').prev().data({ "name" : textVal, "value":  "N" }).html("N" + '<span class="caret">');
					}
				}

				if(!isEmpty(prevDesc)){
					$('#newUserDesc').val(prevDesc);
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
					--><button type="button" class="icon-delete" onclick="removeList( $(this).closest('li') )">삭제</button><!--
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
				--><button type="button" class="icon-delete" onclick="removeList( $(this).closest('li') )">삭제</button><!--
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
		password.length >= 6 ? $("#sixCharLong").addClass("checked") : $("#sixCharLong").removeClass("checked");

		for (var i = 0; i < rules.length; i++) {
			if( new RegExp(rules[i].Pattern).test(password) ) {
				$("#" + rules[i].Target).addClass("checked")
			} else {
				$("#" + rules[i].Target).removeClass("checked")
			}
		}
	}


	// function cloneSpcRow(){
	// 	let clone = $("#spcRow .flex_start:first-of-type").clone();
	// 	let length = $("#spcRow .flex_start").length;
	// 	let ul = $(clone).find(".dropdown-menu");
	// 	let id = $(ul).attr("id");

	// 	$.each(ul, function(index, element){
	// 		$(this).attr("id", id.replace(/(\d+)/, length));
	// 	});
	// 	$(clone).find(".btn_close").removeClass("hidden");

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

<c:set var="siteList" value="${siteHeaderList}"/> <!-- 사이트 별 -->

<div class="modal fade stack" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 id="resultSuccessMsg" class="text-blue hidden">사용자가 성공적으로<br>추가 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">사용자 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
			</div>
			<div class="btn_wrap_type05"><!--
			--><button type="button" id="resultBtn" class="btn_type03" data-dismiss="modal" aria-label="Close">확인</button><!--
		--></div>
		</div>
	</div>
</div>

<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="deleteConfirmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="tx_inp_type"><input type="text" id="confirmUserId" name="confirm_user_id" placeholder="사용자 아이디 입력"/></div>
				</div>
				<div class="btn_wrap_type05"><!--
				--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="button" id="deleteConfirmBtn" class="btn_type w80 ml-12" disabled>확인</button><!--
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
					<form name="add_user_form" id="updateUserForm" class="setting-form">
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label asterisk">ID</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="flex_start">
									<div class="tx_inp_type offset-width">
										<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
									</div>
									<button type="button" class="btn_type fr" onclick="checkId($('#newId').val())" disabled>중복 체크</button>
								</div>
								<small class="hidden warning">사용자 아이디를 입력해 주세요</small>
								<small class="hidden warning">5~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">한글, 특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidId" class="hidden warning">동일한 아이디가 존재합니다.</small>
								<small id="validId" class="text-blue text-sm hidden">사용 가능한 아이디 입니다.</small>
							</div>

							<div class="col-lg-2 col-sm-3"><span class="input_label offset asterisk">비밀번호</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><!--
									--><input type="password" id="newUserPwd" name="new_pwd" placeholder="입력" minlength="6" maxlength="32"><!--
									--><button type="button" class="pwd-icon" onclick="showPwd('newUserPwd', this)">show</button><!--
								--></div>
								<div class="flex_start warning-wrapper">
									<small id="hasLet" class="tick">영문</small>
									<small id="hasNum" class="tick">숫자</small>
									<small id="sixCharLong" class="tick">6자리 이상</small>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label asterisk">이름</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newFullName" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
								<small class="hidden warning">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset asterisk">권한 등급</span></div>
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
							<div class="col-lg-2 col-sm-3"><span class="input_label">휴대폰</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력" maxlength="13"></div>
								<small id="isValidNewMobileNum" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset">소속</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newAffiliation" name="new_affiliation" placeholder="입력">
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">이메일</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="입력"></div>
								<small class="hidden warning">올바른 이메일 형식을 입력해 주세요.</small>
							</div>
							<c:if test="${activateSPC eq true}">
							<div class="col-lg-2 col-sm-3"><span class="input_label offset">업무 구분</span></div>
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
							</c:if>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">사용 여부</span></div>
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
							<div class="col-lg-2 col-sm-3"><span class="input_label">설명</span></div>
							<div class="col-lg-10 col-sm-9">
								<textarea name="new_user_desc" id="newUserDesc" class="textarea w-100" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<ul class="nav nav-tabs">
									<li class="active w-50"><a data-toggle="tab" href="#siteTab">사업소</a></li>
									<c:if test="${activateSPC eq true}">
									<li class="w-50"><a data-toggle="tab" href="#spcTab">SPC</a></li>
									</c:if>
								</ul>
							</div>
						</div>

						<div class="tab-content">
							<div id="siteTab" class="tab-pane fade in active">
								<div class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex_start">
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
													<li data-value="1" data-name="관리 권한"><a href="#">관리 권한</a></li>
													<li data-value="2" data-name="조회 권한"><a href="#">조회 권한</a></li>
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
							<c:if test="${activateSPC eq true}">
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-7 col-md-7 col-sm-12">
										<div class="flex_start">
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
													<li data-value="1" data-name="관리 권한"><a href="#">관리 권한</a></li>
													<li data-value="2" data-name="조회 권한"><a href="#">조회 권한</a></li>
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
							</c:if>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn_wrap_type02">
									<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addUserBtn" class="btn_type" disabled>등록</button>
									<!-- <button type="submit" id="addUserBtn" class="btn_type">확인</button> -->
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


<div class="row">
	<div class="col-10">
		<div class="flex_group">
			<span class="tx_tit">사용자 유형</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
				<ul class="dropdown-menu" id="userList">
					<li data-value=""><a href="#" tabindex="-1">전체</a></li>
					<li data-value="관리자"><a href="#" tabindex="-1">시스템 관리자</a></li>
					<li data-value="사용자"><a href="#" tabindex="-1">일반 사용자</a></li>
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<div class="tx_inp_type">
				<input type="search" id="searchBox" aria-controls="userTable" placeholder="키워드 검색">
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
			<!-- <div class="flex_group">
				<div class="dropdown">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
					<ul class="dropdown-menu" id="pageLengthList">
						<li data-value=""><a href="#" tabindex="-1">전체</a></li>
						<li data-value="10"><a href="#" tabindex="-1">10</a></li>
						<li data-value="30"><a href="#" tabindex="-1">30</a></li>
						<li data-value="50"><a href="#" tabindex="-1">50</a></li>
					</ul>
				</div>
				<span class="tx_tit pl-16">개 씩 보기&ensp;</span>
			</div> -->
			<table id="userTable">
				<colgroup>
					<col style="width:6%">
					<col style="width:10%">
					<col style="width:16%">
					<col style="width:9%">
					<col style="width:15%">
					<col style="width:9%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:14%">
					<col style="width:5%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
				<!-- <tfoot>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tfoot> -->
			</table>
		</div>
	</div>
</div>