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


		$("#addUserForm").on("submit", function(e){
			e.preventDefault();

			let option = {};
			let optionPwd = {};
			let userObj = {};

			let siteInfo = $("#selectedSiteList").find("li");
			let spcInfo = $("#selectedSpcList").find("li");


			if(!$("#addUserModal").hasClass("edit")) {
				// 1. add form
				userObj.login_id = $("#newId").val();
				userObj.name = $("#newFullName").val();
				userObj.password = $("#newUserPwd").val();
				userObj.role = Number($("#newAccLevel").prev().data("value"));

				if( !isEmpty( $("#newMobileNum").val() )){
					userObj.contact_phone = $("#newMobileNum").val();
				}
				if( !isEmpty( $("#newAffiliation").val()) ){
					userObj.team = $("#newAffiliation").val();
				}
				if( !isEmpty( $("#newEmailAddr").val() )){
					userObj.contact_email = $("#newEmailAddr").val();
				}
				if( !isEmpty( $("#newTaskList").prev().data("value") )){
					userObj.task = $("#newTaskList").prev().data("value");
				}
				if( !isEmpty( $("#newUseOpt").prev().data("value") )){
					userObj.valid_yn = $("#newUseOpt").prev().data("value");
				}
				if( !isEmpty( $("#newUserDesc").val()) ){
					userObj.description = JSON.stringify( $("#newUserDesc").val() );
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
						var table = $("#userTable").DataTable();

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
					let siteOption = {
						url: apiHost + '/config/user_sites?uid=' + userInfoId,
						type: 'post',
						dataType: 'json',
						contentType: "application/json",
						async: true
					}

					let spcOption = {
						url: apiHost + '/config/user_spcs?uid=' + userInfoId,
						type: 'post',
						dataType: 'json',
						contentType: "application/json",
						async: true
					}

					let promisesSite = [];
					let promisesSpc = [];

					if( siteInfo.length > 0 && spcInfo.length > 0 ){
						promisesSite.push(makeAjaxCall(siteOption));
						promisesSpc.push(makeAjaxCall(spcOption));
						$.ajax(option).done(function(json, textStatus, jqXHR) {
							$.each(siteInfo, function(index, element){
								let siteObj = {
									sid: $(element).data("sid"),
									role: Number($(element).data("role"))
								};
								siteOption.data = JSON.stringify(siteObj);
								makeAjaxCall(siteOption);
							});
							$.each(siteInfo, function(index, element){
								let siteObj = {
									sid: $(element).data("sid"),
									role: Number($(element).data("role"))
								};
								siteOption.data = JSON.stringify(siteObj);
								makeAjaxCall(siteOption);
							});
						});

					} else{
						if(siteInfo.length > 0) {
							$.ajax(option).done(function(json, textStatus, jqXHR) {
								$.each(siteInfo, function(index, element){
									let siteObj = {
										sid: $(element).data("sid"),
										role: Number($(element).data("role"))
									};
									siteOption.data = JSON.stringify(siteObj);
									makeAjaxCall(siteOption);
								});
							});
						}
						// $.ajax(siteOption).done(function (json, textStatus, jqXHR) {
						// 	console.log("success===", json)
						// }).fail(function (jqXHR, textStatus, errorThrown) {
						// 	let errorMsg = "에러코드:" + jqXHR.status + "\n" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown;
						// 	console.log("에러코드:" + jqXHR.status + "\n" + "메세지: " + jqXHR.responseText +"\n" + "에러: " + errorThrown)
						// 	return false;
						// });

						if(spcInfo.length > 0 ){
							$.ajax(option).done(function(json, textStatus, jqXHR) {
								$.each(spcInfo, function(index, element){
									let spcObj = {
										spcid: $(element).data("value"),
										role: Number($(element).data("role"))
									};
									spcOption.data = JSON.stringify(spcObj);
									makeAjaxCall(spcOption);
								});
							});
						}
					}
				}
			} else {
				// 2. edit form
				let td = $("#userTable").find("tbody tr.selected td");
				let uid = td.eq(0).find("input").data("id");
				let role = $("#newAccLevel").prev().data("value");
				let roleTitle = $("#newAccLevel").prev().data("name");
				let pwd = 'td.eq(7)';

				console.log("uid---", uid);

				if( !isEmpty(role) && ( roleTitle != td.eq(7).text() ) ) {
					userObj.role = Number($("#newAccLevel").prev().data("value"));
				}
				if( !isEmpty( $("#newMobileNum").val() )){
					userObj.contact_phone = $("#newMobileNum").val();
				}
				if( !isEmpty( $("#newAffiliation").val()) ){
					userObj.team = $("#newAffiliation").val();
				}
				if( !isEmpty( $("#newEmailAddr").val() )){
					userObj.contact_email = $("#newEmailAddr").val();
				}
				if( !isEmpty( $("#newTaskList").prev().data("value") )){
					userObj.task = $("#newTaskList").prev().data("value");
				}
				if( !isEmpty( $("#newUseOpt").prev().data("value") )){
					userObj.valid_yn = $("#newUseOpt").prev().data("value");
				}
				if( !isEmpty( $("#newUserDesc").val()) ){
					userObj.description = JSON.stringify( $("#newUserDesc").val() );
				}

				option = {
					url: apiHost + '/config/users/' + uid,
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
					// if pws && other val are present
					if( !isEmpty($("#newUserPwd").val()) && !isEmpty(userObj) ){
						pwd = $("#newUserPwd").val();
						optionPwd = {
							url: apiHost + '/config/users/' + uid + '/password2',
							type: 'patch',
							async: true,
							data: JSON.stringify(pwd),
							contentType: 'application/json; charset=UTF-8'
						}
						$.when($.ajax(optionPwd),$.ajax(option)).done(function (result1, result2) {
							console.log("result1===", result1)
							console.log("result2===", result2)
							$("#resultSuccessMsg").text("사용자 정보가 성공적으로 변경 되었습니다.").removeClass("hidden");
							$("#resultModal").modal("show");
							setTimeout(function(){
								$("#resultModal").modal("hide");
							}, 1000);
							// if(!isEmpty(result1[0].data) && !isEmpty(result2[0].data)){
							// }
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
				console.log("add", $(this))
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
				console.log("json--", json)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("jqXHR--", jqXHR)
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
			console.log("getUserList---")
			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];
				let affiliationList = [];

				data.map((item, index) => {
					let obj = {};

					obj.idx = index + 1;
					obj.user_id = item.login_id;

					if(!isEmpty(item.name)){
						obj.name = item.name;
					} else {
						obj.name = "-";
					}

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
						let d = new Date(item.createdAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&emsp;&emsp;' + new Date(item.createdAt).toLocaleTimeString();
						obj.created_at = d;
					} else {
						obj.created_at = "-";
					}

					if(!isEmpty(item.valid_yn)){
						if(item.valid_yn == "Y"){
							obj.valid_yn = "사용"
						} else {
							obj.valid_yn = "중자"
						}
					} else {
						obj.valid_yn = "-";
					}

					obj.uid = item.uid;

					newArr.push(obj);
				});

				var table = $('#userTable').DataTable({
					"aaData": newArr,
					// "responsive": true,
					"bDeferRender": true,
					"fixedHeader": true,
					"sScrollX": "100%",
					"sScrollXInner": "110%",
					"bScrollCollapse": true,
					// "lengthMenu": [[10, 30, 60, -1], [10, 30, 60, "전체"]],
					"aoColumns": [
						{
							"mData": null,
							"sTitle": "",
							"mData": "",
							"mRender": function ( data, type, row )  {
								return '<input type="checkbox" name="user_row" id="'+row.user_id+'" data-id="'+row.uid+'" class="hidden"><label for="' + row.user_id + '" class="hidden"></label>'
								// return '<a href="#"><input type="checkbox" name="user_row" id="'+row.user_id+'" data-id="'+row.uid+'" class="table-checkbox"><label for="' + row.user_id + '"></label></a>'
							},

							// "mData": function (data, type, dataToSet, td) {
							// 	$('#userTable tbody tr td:eq(' + td.col + ')', td.row).attr("data-id", row.uid);
							// 	return data.SupplementPredefinedQuantities[0].PredefinedQuantity;
							// },
							"className": "select-checkbox w20"
							// "className": "dt-body-center select-checkbox"
						},
						{
							"sTitle": "순번",
							"mData": null,
							"className": "no-sorting"
						},
						{
							"sTitle": "ID",
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
					"aoColumnDefs": [
						{
							"aTargets": [ 0 ],
							"bSortable": false,
						},
						{
							"aTargets": [ 1 ],
							"bSortable": false,
							"orderable": false
						},
					],
					// "columnDefs": [   ////define column 1
					// 	{
					// 		"searchable": false,
					// 		"orderable": true,
					// 		"targets": 1
					// 	},
					// ],
					"order": [[ 1, 'asc' ]],
					// "bFilter": false,
					"dom": 'tip',
					// "dom": '<"top"flB>rt<"bottom"ip><"clear">',
					// "searchPanes": {
					// },
					// "search": {
					// 	"smart": true
					// },
					// "searching": true,
					// "buttons": [
					// 	{
					// 		text: '추가',
					// 		className: "btn_type fr",
					// 		action: function (e, node, config){
					// 			updateModal("all");
					// 		}
					// 	}
					// ],
					"select": {
						// style: 'os',
						style: 'single',
						// selector: 'td:first-child > a',
						// selector: 'td:first-child > a',
						// items: 'cell',
						items: 'row'
					},
					initComplete: function(){
						let str = `
							<div id="btnGroup" class="right-end">
								<button type="button" disabled class="btn_type03 disabled" onclick="updateModal('edit')">선택 수정</button>
								<button type="button" disabled class="btn_type03 disabled" onclick="updateModal('delete')">선택 삭제</button>
							</div>
						`
						$("#userTable_wrapper").append($(str));
					},
					createRow: function (row, data, dataIndex){
						console.log("row===", row);
						 $(row).attr({
							'data-name': data.name,
							'data-role': data.user_role,
							'data-name': data.name,
						});

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
				});

				$("#newAffiliation").autocomplete({
					source : affiliationList,
					minLength: 1,
					autoFocus: true,
					classes: {
						'ui-autocomplete': 'highlight'
					},
					delay: 500
				});


				table.on( 'order.dt search.dt', function () {
					// console.log("this--- order", this)
					table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						cell.innerHTML = i+1;
						$(cell).data("id", i)
					});
				}).draw();

				$("#searchBox").on( 'keyup search input paste cut', function(){
					table.search( this.value ).draw();
					// $("#userTable").dataTable().search( $(this).val() );
				});
				$("#userList").find("li").on( 'click', function(){
					if(!isEmpty($(this).data("value"))){
						filterColumn("7", $(this).data("value"));
					} else {
						filterColumn("7", "");
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

		function filterColumn ( idx, val ) {
			$('#userTable').DataTable().column(idx).search(val).draw();
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
			callback(dropdown);
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
			let arr = [];
			let idx = $("#selectedSiteList").find("li").length + 1;

			let name = $("#siteOptList").prev().data("name");
			let siteVal = $("#siteOptList").prev().data("value");

			let accLevel = $("#siteAccOpt").prev().data("name");
			let accVal = $("#siteAccOpt").prev().data("value");

			if(isEmpty(name) || isEmpty(accLevel)) {
				$("#isSiteSelected").removeClass("hidden");
				setTimeout(function(){
					$("#isSiteSelected").addClass("hidden");
				}, 2000);
				return false;
			}
			console.log("list---", arr)
			if(arr.includes(name)) {
				$("#isSiteSelected").removeClass("hidden");
				return false;
			} else {
				arr.push(name);
				html = `
					<li data-sid="${'${siteVal}'}" data-role="${'${accVal}'}" data-site-name="${'${name}'}">
						${'${name}'}&emsp;&emsp;(&emsp;${'${accLevel}'}&emsp;)
						<button type="button" class="icon-delete" onclick="$(this).closest('li').remove();">삭제</button>
					</li>
				`;
				$("#selectedSiteList").append(html);
			}
		} else {
			let arr = [];
			let idx = $("#selectedSpcList").find("li").length + 1;

			let name = $("#spcOptList").prev().data("name");
			let spcVal = $("#spcOptList").prev().data("value");

			let accLevel = $("#spcAccOpt").prev().data("name");
			let accVal = $("#spcAccOpt").prev().data("value");

			if(isEmpty(name) || isEmpty(accLevel)) {
				$("#isSpcSelected").removeClass("hidden");
				setTimeout(function(){
					$("#isSpcSelected").addClass("hidden");
				}, 2000);
				return false;
			}

			if(arr.includes(name)) {
				$("#isSiteSelected").removeClass("hidden");
				return false;
			} else {
				arr.push(name);
				html = `
					<li data-spc-id="${'${spcVal}'}" data-role="${'${accVal}'}">
						${'${name}'}&emsp;(&emsp;${'${accLevel}'}&emsp;)
						<button type="button" class="icon-delete" onclick="$(this).closest('li').remove();">삭제</button>
					</li>
				`;
				$("#selectedSpcList").append(html);
			}
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
			if(option == "all"){
				if(id.parent().next().hasClass("hidden")) {
					id.parent().next().removeClass("hidden");
					id.parent().addClass("offset-width").removeClass("w-100");
				}
				titleAdd.removeClass("hidden").next().addClass("hidden");
				$('#newId').prop('disabled', false);
				$("#addUserModal").removeClass("edit").modal("show");
			} else {
				var tr = $("#userTable").find("tbody tr.selected");
				let td = tr.find("td");
				if(option == "edit") {
					let required = $("#addUserForm").find(".asterisk");
					$("#addUserBtn").prop("disabled", false).removeClass("disabled");

					required.addClass("no-symbol");
					titleAdd.addClass("hidden").next().removeClass("hidden");
					if(!id.parent().next().hasClass("hidden")) {
						id.parent().next().addClass("hidden");
						id.parent().removeClass("offset-width").addClass("w-100");
					}
					id.val(td.eq(2).text()).prop('disabled', true).addClass("disabled");
					$('#newFullName').val(td.eq(3).text())
					$("#newAccLevel").prev().html(td.eq(7).text() + '<span class="caret">');

					$("#addUserModal").addClass("edit").modal("show");
				}
				if(option == "delete") {
					let id = td.eq(0).find("input").data("id");

					console.log("uid---", id)
					let optDelete = {
						url: apiHost + "/config/users/" + id,
						type: 'delete',
						async: true,
						beforeSend: function (jqXHR, settings) {

						},
					}

					$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
						var newTable = $('#userTable').DataTable();

						$("#resultSuccessMsg").text("사용자가 삭제 되었습니다.").removeClass("hidden");
						$("#resultModal").modal("show");
						newTable.rows(tr).remove().draw(false);

						setTimeout(function(){
							$("#resultModal").modal("hide");
						}, 1000);

					}).fail(function (jqXHR, textStatus, errorThrown) {
						console.log("fail==", jqXHR)
					});

				}
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


<div class="modal fade stack" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 id="resultSuccessMsg" class="text-blue hidden">사용자가 성공적으로<br>추가 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">사용자 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
			</div>
		</div>
	</div>
</div>

<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h3 id="resultSuccessMsg" class="ntit semi-bold">사용자 삭제를 진행하시려면, 해당 아이디를 아래에 입력해 주세요.</h3>
			</div>
			<div class="modal-body">
			<div class="tx_inp_type"><input type="text" id="confirmUserId" name="confirm_user_id" placeholder="사용자 아이디 입력"/></div>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" id="closeBtn" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
				<button type="submit" id="warningConfirmBtn" class="btn_type">확인</button>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content user-modal-content">
			<div id="titleAdd" class="modal-header"><h1>사용자 추가<span class="required px-4 fr">*&emsp;필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사용자 정보 수정<span class="required-blue px-4 fr">*&emsp;변경하신 정보는 다음 로그인 부터 적용됩니다.</span></h1></div>
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
								<small class="hidden warning">사용자 ID를 입력해 주세요</small>
								<small class="hidden warning">5 ~ 15 글자를 입력해 주세요.</small>
								<small class="hidden warning">한글,특수 문자, 공백은 포함될 수 없습니다.</small>
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
									<button class="btn btn-primary dropdown-toggle asterisk" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
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
								<div class="tx_inp_type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력"></div>
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
									<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">선택<span class="caret"></span></button>
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
									<button type="button" class="btn btn-primary dropdown-toggle asterisk" data-toggle="dropdown">선택<span class="caret"></span></button>
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
												<button type="button" class="btn btn-primary dropdown-toggle asterisk" data-toggle="dropdown">선택<span class="caret"></span></button>
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
												<button type="button" class="btn btn-primary dropdown-toggle asterisk" data-toggle="dropdown">선택<span class="caret"></span></button>
												<ul id="siteAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">관리 권한</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회 권한</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('site')">추가</button>
										</div>
										<small id="isSiteSelected" class="warning hidden">추가하실 사이트의 옵션을 선택해 주세요.</small>
										<small id="isSiteSelected" class="warning hidden">동일한 사이트가 이미 추가 되었습니다.</small>
									</div>
									<div class="col-lg-4 col-sm-12"><h2 class="stit">추가 리스트</h2><ol id="selectedSiteList" class="selected-list"></ol></div>
								</div>
							</div>
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-8 col-sm-12">
										<div class="flex_start">
											<div class="dropdown w-50">
												<button type="button" class="btn btn-primary dropdown-toggle asterisk" data-toggle="dropdown">선택<span class="caret"></span></button>
												<ul id="spcOptList" class="dropdown-menu">
													<template>
														<li data-value="*spcId*" data-name="*spcName*"><a href="#" tabindex="-1">*spcName*</a></li>
													</template>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="btn btn-primary dropdown-toggle asterisk" data-toggle="dropdown">선택<span class="caret"></span></button>
												<ul id="spcAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">수정/조회</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('spc')">추가</button>
										</div>
										<small id="isSpcSelected" class="warning hidden">추가하실 spc 옵션을 선택해 주세요.</small>
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
				<button class="btn btn-primary dropdown-toggle" type="button"
					data-toggle="dropdown">선택<span class="caret"></span></button>
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
					<button class="btn btn-primary dropdown-toggle" type="button"
						data-toggle="dropdown">선택<span class="caret"></span></button>
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
			<!-- <div id="btnGroup">
				<button type="button" disabled class="btn_type03 disabled" onclick="updateModal('edit')">선택 수정</button>
				<button type="button" disabled class="btn_type03 disabled" onclick="updateModal('delete')">선택 삭제</button>
			</div> -->
			<table id="userTable" class="stripe nowrap">
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