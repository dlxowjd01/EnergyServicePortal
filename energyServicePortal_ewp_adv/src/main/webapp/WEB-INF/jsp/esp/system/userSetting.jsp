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
					$('.loading').show();
				},
			},
			{
				url: apiHost + "/spcs?oid=" + oid + "&includeGens=false",
				type: "get",
				async: true,
			}
		];

		getUserList(optionList[0]);

		clearInput();

		getSpcList(optionList[1], copySpcList, setDropdownValue);

		$("#newId").on('keyup keydown', function() {
			$(this).val($(this).val().replace(/\s/g, ''));
		});

		$("#newId").on('keyup keydown', function() {
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
				// console.log("val---", $(this).val().length)
				if($(this).val().length >= 10) {
					$("#isValidMobileNum").addClass("hidden");
					$("#updateProfileBtn").prop("disabled", false);
					$("#updateProfileBtn").removeClass("disabled");
				} else {
					$("#isValidMobileNum").removeClass("hidden");
				}

			}
		});

		$("#mobileNum").on('keypress', function(evt) {
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


		$("#userTable").on("click", "input[type='checkbox']", function(e, dt, type, indexes ){
			let tr = $(this).closest("tr");
			$(this).closest("tr").addClass("selected");
		});

		$("#addUserForm").on("submit", function(e){
			e.preventDefault();

			let userObj = {};

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

			let userOption = {
				url: apiHost + '/config/users?oid=' + oid,
				type: 'post',
				beforeSend: function (jqXHR, settings) {
					$('.loading').show();
				},
				async: true,
				dataType: 'json',
				contentType: "application/json",
				data: JSON.stringify(userObj)
			}

			let siteInfo = $("#selectedSiteList").find("li");
			let spcInfo = $("#selectedSpcList").find("li");

			$.ajax(userOption).done(function (json, textStatus, jqXHR) {
				$("#addUserSuccessMsg").removeClass("hidden");
				$("#resultModal").modal("show");
				setTimeout(function(){
					$("#resultModal").modal("hide");
				}, 3000);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				$("#addUserFailureMsg").removeClass("hidden");
				$("#resultModal").modal("show");
				setTimeout(function(){
					$("#resultModal").modal("hide");
				}, 3000);
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});

			if( siteInfo.length > 0 || spcInfo.length > 0 ){

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

				if(siteInfo.length > 0) {
					$.each(siteInfo, function(index, element){
						let siteObj = {
							sid: $(element).data("sid"),
							role: Number($(element).data("role"))
						};

						siteOption.data = JSON.stringify(siteObj);

						// makeAjaxCall(siteOption);
						console.log("siteOption===", siteOption)

						$.ajax(siteOption).done(function (json, textStatus, jqXHR) {
							console.log("success===", json)
						}).fail(function (jqXHR, textStatus, errorThrown) {
							console.log("fail===", jqXHR)
							return false;
						});
					}).promise().done(function(){
						console.log("ajax call done===");
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
					}).promise().done(function(){
						console.log("ajax call done===")
					});
				}


			}

		});

		$('#newAccLevel').find("li").on("click", function(){
			if( !isEmpty($(this).data("value")) && validateForm() == 1) {
				$("#addUserBtn").prop("disabled", false).removeClass("disabled");
			}
		});

		$('#addUserForm').on("change", function(e){
			if(validateForm() == 1) {
				$("#addUserBtn").prop("disabled", false).removeClass("disabled");
			} else {
				$("#addUserBtn").prop("disabled", true).addClass("disabled");
			}
		});

		function makeAjaxCall(option){
			return $.ajax(option).fail(function (jqXHR, textStatus, errorThrown) {
				return false;
			});
		}

		function validateForm(){
			if( ( $("#validId:not('.hidden')").length >= 0 ) && ( $("#addUserForm .tick:not('.checked')").index() == -1 ) && ( $(".warning:not(.hidden)").index() == -1 ) && ( !isEmpty($("#newFullName").val() ) ) && ( !isEmpty($("#newAccLevel").prev().data("value")) )){
				return 1;
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


		function resetModal() {
			let pwdInput = $("#addUserForm").find("input");
			let profileInput = $("#profileForm").find("input");
			let tick = $(".tick");

			tick.each(function(){
				if($(this).is(".checked")){
					$(this).removeClass("checked");
				}
			});
			$("#updateUserInfoModal").modal("hide");
		}

		function getUserList(opt) {
			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];
				// console.log("data---", data);

				data.map((item, index)=> {
					// console.log("item---", item);
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
					} else {
						obj.team = "-";
					}

					if(item.role == 1){
						obj.user_role = "조직 관리자"
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
					newArr.push(obj);
				});

				var table = $('#userTable').dataTable({
					aaData: newArr,
					// "fixedHeader": true,
					scrollX: false,
					scrollY: "400px",
					lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
					aoColumns: [
						{
							"sTitle": "",
							"mData": "",
							"mRender": function ( data, type, row )  {
								// onclick="onlyOne(this.children[0]);"
								// select-checkbox
								return '<a href="#" class="" onclick="onlyOne(this.children[0]);"><input type="checkbox" name="user_row" id="' + row.idx + '" class="select-checkbox"><label for="' + row.idx + '"></label></a>'

								// return '<a href="javascript:void(0);" class="chk_type"><input type="checkbox" name="user_row" id="' + row.idx + '" class="select-checkbox" onclick="onlyOne(this);"><label for="' + row.idx + '"></label></a>'
							},
							"className": "dt-body-center"
						},
						{
							"sTitle": "순번",
							"mData": "idx",
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
					dom: 'Bfltip',
					// dom: 'Bfrtip',
					buttons: [
						{
							text: '추가',
							className: "btn_type fr",
							attr:  {
								"data-toggle": "modal",
								"data-target": "#addUserModal",
								"data-backdrop": "static",
								"data-keyboard": "false"
							},
							// action: function (e, node, config){
							// 	$('#addUserModal').modal('show');
							// }
						}
					],
					select: {
						// style: 'os',
						style: 'single',
						selector: 'td:first-child',
						// items: 'cell',
						// items: 'row'
					},
					drawCallback: function () {
						$('#userTable_wrapper').addClass('mb-28');
					},
					initComplete: function(){
						let str = `
							<div class="dt-buttons">
								<button type="button" class="btn_type03" onclick="openEditModal('edit')">선택 수정</button>
								<button type='button' class='btn_type03' onclick='deleteUser()'>선택 삭제</button>
							</div>
						`
						$("#userTable_wrapper").append($(str));
					},
					rowCallback: function ( row, data ) {
						// console.log("data--", data)
						// row.find("input[type='checkbox']").prop( 'checked', true );
						// $('input[type="checkbox"]', row).prop('checked', data.active == 1 );
					}
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
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

			let dropdown = $("#addUserForm").find(".dropdown ul");
			callback(dropdown);
		}


		function clearInput(){
			let input = $("#addUserForm").find("input");
			let dropdown = $("#addUserForm").find(".dropdown-toggle");

			$.each(input, function(index, element){
				$(this).val("");
			});

			$.each(dropdown, function(index, element){
				$(this).html('선택' + '<span class="caret"></span>');
				$(this).data("value", "");
			});

		}


	});



	function openEditModal(option){
		$('#titleEdit').addClass("hidden");
		$('#titleEdit').removeClass("hidden");
		$('#addUserModal').modal('show', {
			backdrop: 'static', keyboard: false
		});
	}

	function deleteUser(row){
		console.log("deleteuser===")
	}

	function onlyOne(checkbox) {
		var checkboxes = document.getElementsByName('user_row');
		var table = $("#userTable");

		checkboxes.forEach((item, index) => {
			if (item !== checkbox) {
				item.checked = false;
			} else {
				let tr = $(checkbox).closest("tr");
				// console.log("tr---", tr);
				// tr.addClass("selected");
				// tr.siblings().removeClass("selected");
			}
		});
	}


	function addToList(type) {
		let html = ``;
		if(type == 'site') {
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

			html = `
				<li data-sid="${'${siteVal}'}" data-role="${'${accVal}'}">
					${'${name}'}&emsp;&emsp;(&emsp;${'${accLevel}'}&emsp;)
					<button type="button" class="icon-delete" onclick="removeList($(this).closest('li'));">삭제</button>
				</li>
			`;
			$("#selectedSiteList").append(html);
		} else {
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

			html = `
				<li data-spc-id="${'${spcVal}'}" data-role="${'${accVal}'}" class="flex_wrap_center">
					<h3 class="stit">${'${name}'}&emsp;(&emsp;${'${accLevel}'}&emsp;)</h3>
					<button type="button" class="icon-delete" onclick="removeList($(this).closest('li'));">삭제</button>
				</li>
			`;
			$("#selectedSpcList").append(html);
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

	function checkId(userInput){
		if(isEmpty(userInput)) return false;
		let id = userInput.toString();
		let checkIdOpt = {
			url: apiHost + "/config/users/exist?oid=" + oid + '&login_id=' + id,
			type: "get",
			beforeSend: function (jqXHR, settings) {
				$('.loading').show();
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
				}, 3000);
			}
			return false;
		});
	}

	function removeList(row){
		row.remove();
	}

		// table.on( 'deselect', function ( e, dt, type, indexes ) {
		// 	console.log("deselect===");
		// 	table[ type ]( indexes ).nodes().to$().removeClass( 'custom-selected' );
		// });

</script>

<c:set var="siteList" value="${siteHeaderList}"/> <!-- 사이트 별 -->

<div class="modal fade stack" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header center semi-bold">
				<h3 id="addUserSuccessMsg" class="text-blue center semi-bold hidden">사용자 추가에 성공했습니다.</h3>
				<h3 id="addUserFailureMsg" class="hidden">사용자 추가에 실패하였습니다. 다시 시도해 주세요.</h3>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content user-modal-content">
			<div class="modal-header"><h1><span id="titleAdd">사용자 추가</span><span id="titleEdit hidden">사용자 정보 변경/삭제</span><span class="require-field px-4 fr">*&emsp;필수 입력 항목</span></h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form id="addUserForm" name="add_user_form">
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label required">ID</span></div>
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

							<div class="col-lg-2 col-sm-3"><span class="input_label offset required">비밀번호</span></div>
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
							<div class="col-lg-2 col-sm-3"><span class="input_label required">이름</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newFullName" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
								<small class="hidden warning">영문/한글 조합의 (3~28글자의) 이름을 입력해 주세요</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset required">권한 등급</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<li data-value="1"><a href="#">시스템 관리자</a></li>
										<li data-value="2"><a href="#">일반 사용자</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">휴대폰</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력"></div>
							</div>
							<small class="hidden warning">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
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
									<button type="button" class="btn btn-primary dropdown-toggle required" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul id="newUseOpt" class="dropdown-menu">
										<li data-value="y"><a href="#">Y</a></li>
										<li data-value="n"><a href="#">N</a></li>
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
												<button type="button" class="btn btn-primary dropdown-toggle required" data-toggle="dropdown">선택<span class="caret"></span></button>
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
												<button type="button" class="btn btn-primary dropdown-toggle required" data-toggle="dropdown">선택<span class="caret"></span></button>
												<ul id="siteAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">관리 권한</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회 권한</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('site')">추가</button>
										</div>
										<small id="isSiteSelected" class="warning hidden">추가하실 사이트의 옵션을 선택해 주세요.</small>
									</div>
									<div class="col-lg-4 col-sm-12"><h2 class="stit">추가 리스트</h2><ol id="selectedSiteList" class="selected-list"></ol></div>
								</div>
							</div>
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-8 col-sm-12">
										<div class="flex_start">
											<div class="dropdown w-50">
												<button type="button" class="btn btn-primary dropdown-toggle required" data-toggle="dropdown">선택<span class="caret"></span></button>
												<ul id="spcOptList" class="dropdown-menu">
													<template>
														<li data-value="*spcId*" data-name="*spcName*"><a href="#" tabindex="-1">*spcName*</a></li>
													</template>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="btn btn-primary dropdown-toggle required" data-toggle="dropdown">선택<span class="caret"></span></button>
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
					<li><a href="#" tabindex="-1">전체</a></li>
					<li><a href="#" tabindex="-1">관리자</a></li>
					<li><a href="#" tabindex="-1">일반 사용자</a></li>
				</ul>
			</div>
		</div>

		<div class="flex_group">
			<div class="flex_start">
				<div class="tx_inp_type">
					<input type="text" id="key_word" placeholder="입력">
				</div>
				<button type="button" class="btn_type ml-16" onclick="getDataList();">검색</button>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="userTable" class="stripe">
				<thead></thead>
				<tbody>
				</tbody>
				<tfoot>
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
				</tfoot>
			</table>
		</div>
	</div>
</div>