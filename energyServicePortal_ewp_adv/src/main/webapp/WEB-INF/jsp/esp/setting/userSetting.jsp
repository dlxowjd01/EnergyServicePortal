<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>

<script type="text/javascript">
	$(function () {
		// let sL = JSON.parse('${siteList}');
		// console.log("sL---", sL);

		let copySpcList = $("#spcRow").find("template").clone().html();
		$("#spcRow").find("template").remove();

		let optionList = [
			{
				url: apiHost + "/config/users/",
				type: "get",
				async: true,
				data: {
					uid: userInfoId,
					oid: oid
				},
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
				},
			},
			{
				url: apiHost + "/spcs?oid=" + oid + "&includeGens=false",
				type: "get",
				async: true,
			}
		];

		getUserList(optionList[0]);

		getSpcList(optionList[1], copySpcList, setDropdownValue);

		updateModal();


		$("#newId").on('keydown', function() {
			$(this).val($(this).val().replace(/\s/g, ''));
		});

		$("#newId").on('keyup', function() {
			let warning = $("#newId").parents(".col-lg-4").find(".warning");
			$("#validId").addClass("hidden")

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
				$("#newId").parent().next().prop("disabled", false).removeClass("disabled");
			} else {
				$("#newId").parent().next().prop("disabled", true).addClass("disabled");
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

		$("#addUserModal").on("hide.bs.modal", function() {
			console.log("this===", $(this).hasClass("edit"))
			if($(this).hasClass("edit")){
				$(this).removeClass("edit");
			}
			$("#selectedSiteList").empty();
			$("#selectedSpcList").empty();
			updateModal();
		});

		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			console.log("deleteConfirmModal===", $(this));

			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#confirmUserId").val("");
		});

		$("#addUserForm").on("submit", function(e){
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
			let newUseOpt = $("#newUseOpt").prev().data("value");
			let newUserDesc = $("#newUserDesc").val();

			let siteInfo = $("#selectedSiteList").find("li");
			let spcInfo = $("#selectedSpcList").find("li");

			// 1. ADD a USER
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
						$("#addUserModal").modal("hide");
						$("#resultSuccessMsg").text("사용자가 추가 되었습니다.").removeClass("hidden");
						$("#resultModal").modal("show");
						// let table = $("#userTable").DataTable();

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
						console.log("에러코드:" + jqXHR.status + "\n" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + thrownError);
						return false;
					});
				}
			} else {
			// 2. Edit existing user info
				let tr = $("#userTable").find("tbody tr.selected");
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


		$("#newAccLevel").find("li").on("click", function(){
			if($("#addUserModal").hasClass("edit")){
				if( !isEmpty($(this).data("value")) && validateEditForm() == 1) {
					$("#addUserBtn").prop("disabled", false).removeClass("disabled");
				}
			} else {
				if( !isEmpty($(this).data("value")) && validateAddForm() == 1) {
					$("#addUserBtn").prop("disabled", false).removeClass("disabled");
				}
			}

		});

		$("#addUserForm").on("change", function(e){
			if(!$("#addUserModal").hasClass("edit")){
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

		// $('#userTable tbody').on('click', 'tr', function () {
		// 	if ( $(this).hasClass('selected') ) {
		// 		$(this).removeClass('selected');
		// 	}
		// 	else {
		// 		$('#userTable tr.selected').removeClass('selected');
		// 		$(this).addClass('selected');
		// 	}
		// });

		function selectRow(dataTable) {
			if ($(this).hasClass("selected")) {
				$(this).removeClass("selected");
			} else {
				dataTable.$("tr.selected").removeClass("selected");
				$(this).addClass("selected");
			}
		}
		function makeAjaxCall(option){
			return $.ajax(option).done(function (json, textStatus, jqXHR) {
				console.log("makeAjaxCall json--", json)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("siteInfo/spcInfo Ajax Error:", jqXHR.responseJSON.error.message)
				return false;
			});
		}

		function validateAddForm(){
			if( ( $("#validId:not('.hidden')").length >= 0 ) && ( $("#addUserForm .tick:not('.checked')").index() == -1 ) && ( $(".warning:not(.hidden)").index() == -1 ) && ( !isEmpty($("#newFullName").val() ) ) && ( !isEmpty($("#newAccLevel").prev().data("value")) )){
				return 1;
			}
		}

		function validateEditForm(){
			if(!isEmpty($("#newUserPwd").val())) {
				console.log("newUserPwd NOT empty===" )
				if( ($("#addUserForm .tick:not('.checked')").index() == -1) && ($(".warning:not(.hidden)").index() == -1) ) {
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

		function getUserList(opt) {
			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];
				let affiliationList = [];

				data.map((item, index) => {
					let obj = {};

					obj.user_id = item.login_id;
					obj.name = item.name;

					if(!isEmpty(item.contact_phone)){
						obj.contact_phone = item.contact_phone;
					} else {
						obj.contact_phone = "-";
					}

					if(!isEmpty(item.contact_email)){
						obj.contact_email = item.contact_email;
					} else {
						obj.contact_email = "-";
					}

					if(!isEmpty(item.team)){
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
						let desc = "";
						if(typeof(item.description) === 'string' || item.description === ""){
							desc = item.description;
							obj.desc = desc;
							// console.log("desc===", desc)
						} else {
							return Promise.resolve(JSON.parse(item.description)).then(res => {
								// console.log("res==", res)
								desc = res;
							}).catch(function(error) {
								console.log(error);
								if(error){
									return false;
								}
							});
						}

						// obj.desc = JSON.parse(item.description);
					}
					obj.uid = item.uid;

					newArr.push(obj);
					// console.log("uid---", item.uid)
				});

				var table = $('#userTable').DataTable({
					"aaData": newArr,
					// "bDeferRender": true,
					// "fixedHeader": true,
					"table-layout": "fixed",
					// "bStateSave": true,
					"bSearchable" : true,
					// "autoWidth": true,
					"bAutoWidth": true,
					"sScrollX": "110%",
					"sScrollY": false,
					"sScrollXInner": "110%",
					"bScrollCollapse": true,
					// "bFilter": false, disabling this option will prevent table.search()
					"aaSorting": [[ 0, 'asc' ]],
					"order": [[ 1, 'asc' ]],
					"aoColumns": [
						{
							"sTitle": "순번",
							"mData": null,
							"className": "dt-center idx"
							// "className": "dt-center idx no-sorting"
						},
						{
							"sTitle": "ID",
							"mData": null,
							"mRender": function ( data, type, row )  {
								return '<span id="'+row.user_id+'" data-id="'+row.uid+'">' + row.user_id + '</span>'
								// return '<a href="#"><input type="checkbox" name="user_row" id="'+row.user_id+'" data-id="'+row.uid+'" class="table-checkbox"><label for="' + row.user_id + '"></label></a>'
							},
							// "mData": "user_id"
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
					"aoColumnDefs": [
						{
							"aTargets": [ 0 ],
							"bSortable": false,
							"orderable": false
						},
					],
					"dom": 'tip',
					"select": {
						style: 'single',
						items: 'row'
					},
					initComplete: function(){
						let str = `
							<div id="btnGroup" class="right-end"><!--
								--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('edit')">선택 수정</button><!--
								--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('delete')">선택 삭제</button><!--
						--></div>
						`
						$("#userTable_wrapper").append($(str));

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
					createdRow: function ( row, data, index ){
						if(!isEmpty(data.desc)){
							$(row).attr({
								'data-desc': data.desc
							});
						} else {
							// console.log("created row data===", data);
							$(row).attr({
								'data-uid': data.uid,
								'data-role': data.user_role,
								'data-name': data.name,
							});
						}
						// if ( data[5].replace(/[\$,]/g, '') * 1 > 150000 ) {
						// 	$('td', row).eq(5).addClass('highlight');
						// }
					},
					// every time DataTables performs a draw
					drawCallback: function () {
						selectRow(this);
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
					// table.rows( indexes ).nodes().to$().find("input").prop("checked", false);
					// let self = table[ type ]( indexes ).nodes().to$().find('input');
					// console.log("dt---", table[ type ]( indexes ).nodes())
				// }).on('change', 'input[type="checkbox"]', function(){
				// 	console.log("input checkbox===")
				}).columns.adjust().draw();
				// }).columns.adjust().responsive.recalc();

				$("#newAffiliation").autocomplete({
					source : affiliationList,
					minLength: 1,
					autoFocus: true,
					classes: {
						'ui-autocomplete': 'highlight'
					},
					delay: 500
				});

				table.on( 'order.dt search.dt', function(){
					console.log("order===")
					table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						cell.innerHTML = i+1;
					});
				}).draw();

				table.on( 'column-sizing.dt', function ( e, settings ) {
					$(".dataTables_scrollHeadInner").css( "width", "100%" );
				});

				$("#searchBox").on( 'keyup search input paste cut', function(){
					table.search( this.value ).draw();
					// $("#userTable").dataTable().search( $(this).val() );
				});
				$("#userList").find("li").on( 'click', function(){
					if(!isEmpty($(this).data("value"))){
						filterColumn( "#userTable", "6", $(this).data("value"));
					} else {
						filterColumn("#userTable", "6", "");
					}
				});
				$("#pageLengthList").find("li").on( 'click', function(){ 
					if(!isEmpty($(this).data("value"))){
						let val = Number($(this).data("value"));
						table.page.len(val).draw();
					} else {
						table.page.len( -1 ).draw();
					}
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				$("#userTable").DataTable().clear();
				return false;
			});
		}

		function filterColumn ( id, idx, val ) {
			$(id).DataTable().column(idx).search(val).draw();
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

			let dropdown = $("#addUserForm").find(".dropdown ul");
			// callback(dropdown);
		}
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

	function addToList(type) {
		let html = ``;
		if(type == 'site') {
			let name = $("#siteOptList").prev().data("name");
			let siteVal = $("#siteOptList").prev().data("value");
			let accLevel = $("#siteAccOpt").prev().data("name");
			let accVal = $("#siteAccOpt").prev().data("value");

			let selectedList = $("#selectedSiteList").find("li");

			if(isEmpty(name) || isEmpty(accLevel)) {
				$("#isSiteEmpty").removeClass("hidden");
				setTimeout(function(){
					$("#isSiteEmpty").addClass("hidden");
				}, 1600);
				return false;
			} else {
				if(!isEmpty(selectedList)){
					let arr = [];
					if(!$("#selectedSiteList").prev().hasClass("hidden")){
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
					<li data-sid="${'${siteVal}'}" data-role="${'${accVal}'}" data-site-name="${'${name}'}">
						${'${name}'}&emsp;&emsp;(&emsp;${'${accLevel}'}&emsp;)
						<button type="button" class="icon-delete" onclick="removeList( $(this).closest('li') )">삭제</button>
					</li>
				`;
				$("#selectedSiteList").append(html);
			}
		} else {
			let name = $("#spcOptList").prev().data("name");
			let spcVal = $("#spcOptList").prev().data("value");
			let accLevel = $("#spcAccOpt").prev().data("name");
			let accVal = $("#spcAccOpt").prev().data("value");

			let selectedList = $("#selectedSpcList").find("li");

			if(isEmpty(name) || isEmpty(accLevel)) {
				$("#isSpcEmpty").removeClass("hidden");
				setTimeout(function(){
					$("#isSpcEmpty").addClass("hidden");
				}, 1600);
				return false;
			} else {
				if(!isEmpty(selectedList)){
					let arr = [];
					if(!$("#selectedSpcList").prev().hasClass("hidden")){
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
				<li data-spc-id="${'${spcVal}'}" data-role="${'${accVal}'}" data-spc-name="${'${name}'}">
					${'${name}'}&emsp;(&emsp;${'${accLevel}'}&emsp;)
					<button type="button" class="icon-delete" onclick="removeList( $(this).closest('li') )">삭제</button>
				</li>
			`;
			$("#selectedSpcList").append(html);
		}
	}

	function updateModal(option){
		if(isEmpty(option)) {
			let form = $("#addUserForm");
			let input = form.find("input");
			let dropdown = form.find(".dropdown-toggle");
			let tick = form.find(".tick");
			let warning = form.find(".warning");

			$("#validId").addClass("hidden");
			warning.addClass("hidden")
			tick.removeClass("checked");
			input.val("");

			$.each(dropdown, function(index, element){
				$(this).html('선택' + '<span class="caret"></span>');
				$(this).data("value", "");
			});
		} else {
			let titleAdd = $('#titleAdd');
			let id = $('#newId');
			let required = $("#addUserForm").find(".asterisk");
			if(option == "all"){
				if(id.parent().next().hasClass("hidden")) {
					id.parent().next().removeClass("hidden");
					id.parent().addClass("offset-width").removeClass("w-100");
				}
				titleAdd.removeClass("hidden").next().addClass("hidden");
				required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
				$('#newId').prop('disabled', false);
				$("#addUserModal").removeClass("edit").modal("show");
			} else {
				var tr = $("#userTable").find("tbody tr.selected");
				let td = tr.find("td");
				if(option == "edit") {
					$("#addUserBtn").prop("disabled", false).removeClass("disabled");
					titleAdd.addClass("hidden").next().removeClass("hidden");
					required.hasClass("no-symbol") ? null : required.addClass("no-symbol");
					if(!id.parent().next().hasClass("hidden")) {
						id.parent().next().addClass("hidden");
						id.parent().removeClass("offset-width").addClass("w-100");
					}
					id.val(td.eq(1).text()).prop('disabled', true).addClass("disabled");
					$('#newFullName').val(td.eq(2).text())
					$("#newAccLevel").prev().html(td.eq(6).text() + '<span class="caret">');
					if(!isEmpty(td.eq(3))){
						$('#newMobileNum').val(td.eq(3).text())
					}
					if(!isEmpty(td.eq(4))){
						$('#newEmailAddr').val(td.eq(4).text())
					}
					if(!isEmpty(td.eq(5))){
						$('#newAffiliation').val(td.eq(5).text())
					}
					if(!isEmpty(td.eq(7))){
						$('#newTaskList').prev().data("value", td.eq(7).text()).html(td.eq(7).text(), '<span class="caret">');
					}
					if(!isEmpty(td.eq(9))){
						$('#newUseOpt').prev().data("value", td.eq(9).text()).html(td.eq(9).text(), '<span class="caret">');
					}
					$("#addUserModal").addClass("edit").modal("show");
				}
				if(option == "delete") {
					let tr = $("#userTable").find("tbody tr.selected td");
					let id = tr.data("uid");
					let userId = $("#userTable").find("tbody tr.selected td:nth-of-type(1)").text();
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
									var newTable = $('#userTable').DataTable();
									console.log("delete success==", json)
									// $("#deleteSuccessMsg").text("사용자가 삭제 되었습니다.").removeClass("hidden");
									// newTable.rows(tr).remove().draw();
									// setTimeout(function(){
									// 	$("#deleteConfirmModal").modal("hide");
									// }, 1200);

								}).fail(function (jqXHR, textStatus, errorThrown) {
									console.log("fail==", jqXHR)
								});
							});
						}
					});

				}
			}
		}
	}


	function removeList(self) {
		let selectedList = $("#selectedSiteList");
		let item = selectedList.find("li");
		console.log("item---", $(item).length);

		if(item.length == 1 ){
			selectedList.prev().addClass("hidden");
		}
		self.remove();
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
		</div>
	</div>
</div>

<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
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
				--><button type="submit" id="warningConfirmBtn" class="btn_type w80 ml-12 disabled" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>


<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content user-modal-content">
			<div id="titleAdd" class="modal-header"><h1>사용자 추가<span class="required px-4 fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사용자 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form id="addUserForm" name="add_user_form">
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label asterisk">ID</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="flex_start">
									<div class="tx_inp_type offset-width">
										<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
									</div>
									<button type="button" class="btn_type disabled fr" disabled onclick="checkId($('#newId').val())">중복 체크</button>
								</div>
								<small class="hidden warning">사용자 아이디를 입력해 주세요</small>
								<small class="hidden warning">5~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">한글, 특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidId" class="hidden warning">동일한 아이디가 존재합니다.</small>
								<small id="validId" class="text-blue text-sm hidden">사용 가능한 아이디 입니다.</small>
							</div>

							<div class="col-lg-2 col-sm-3"><span class="input_label offset asterisk">비밀번호</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="password" id="newUserPwd" name="new_pwd" placeholder="입력" minlength="6" maxlength="32"></div>
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
							<div class="col-lg-2 col-sm-3"><span class="input_label offset">업무 구분</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newTaskList" class="dropdown-menu">
										<li data-value="0"><a href="#">일반</a></li>
										<li data-value="1"><a href="#">사무 수탁사</a></li>
										<li data-value="2"><a href="#">자산 운용사</a></li>
										<li data-value="3"><a href="#">사업주</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">사용 여부</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newUseOpt" class="dropdown-menu">
										<li data-value="Y"><a href="#">Y</a></li>
										<li data-value="N"><a href="#">N</a></li>
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
									<li class="w-50"><a data-toggle="tab" href="#spcTab">SPC</a></li>
								</ul>
							</div>
						</div>

						<div class="tab-content">
							<div id="siteTab" class="tab-pane fade in active">
								<div class="row user-row">
									<div class="col-lg-8 col-sm-12">
										<div class="flex_start">
											<div class="dropdown w-50">
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
									<div class="col-lg-4 col-sm-12 px-0"><h2 class="stit hidden">추가 리스트</h2><ol id="selectedSiteList" class="selected-list"></ol></div>
								</div>
							</div>
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-8 col-sm-12">
										<div class="flex_start">
											<div class="dropdown w-50">
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
									<div class="col-lg-4 col-sm-12"><h2 class="stit">추가 리스트</h2><ul id="selectedSpcList" class="selected-list"></ul></div>

								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn_wrap_type02">
									<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addUserBtn" class="btn_type disabled" disabled>등록</button>
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
	<div class="col-12">
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
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<div class="flex_group">
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
			</div>
			<button type="button" class="btn_type fr mb-20" onclick="updateModal('all')">추가</button>
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