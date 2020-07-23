<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:set var="oid" value="${userInfo.oid}"/> <%-- 메뉴 관리용 OID --%>
<c:set var="task" value="${userInfo.task}"/> <%-- 메뉴 관리용 Task --%>

<script type="text/javascript">
	$(function () {
		// role: 1: 시스템관리자, 2: 일반
		// task : 0: 일반, 1:사무수탁, 2:자산운용, 3: 사업주
		
		// let userInfo = '${userInfo}'
		// console.log("userinf---", userInfo)

		let userId = '${userInfo.login_id}';
		let oid = '${userInfo.oid}';
		let role = '${userInfo.role}';
		let task = '${userInfo.task}';
		let fullName = '${userInfo.name}';
		let emailAddr = '${userInfo.contact_email}';
		let mobileNum = '${userInfo.contact_phone}';

		let accLevel = "";
		let taskCategory = "";
		role == 1 ? accLevel = "시스템관리자" : accLevel = "일반";

		if(task == 0){
			taskCategory = "일반"
		} else if(task == 1){
			taskCategory = "사무수탁"
		} else if(task == 2){
			taskCategory = "자산운용"
		} else if(task == 3){
			taskCategory = "사업주"
		}

		if(!isEmpty(userId)) {
			$("#userId").val(userId);
		}
		if(!isEmpty(oid)) {
			$("#affiliation").val(oid);
		}
		if(!isEmpty(accLevel)) {
			$("#accessLevel").val(accLevel);
		}
		if(!isEmpty(taskCategory)) {
			$("#taskCategory").val(taskCategory);
		}
		if(!isEmpty(fullName)) {
			$("#fullName").val(fullName);
		}
		if(!isEmpty(emailAddr)) {
			$("#taskCategory").val(emailAddr);
		}
		if(!isEmpty(mobileNum) && mobileNum != "string") {
			$("#mobileNum").val(mobileNum);
		}

		$("#newPwd").on('keyup', ValidatePassword);


		// $("#fullName").on('keyup', function(evt, limit) {
		// 	if(!isEmpty($(this).val())){
		// 		$("#updateProfileBtn").prop("disabled", false);
		// 		$("#updateProfileBtn").removeClass("disabled");
		// 	}
		// });

		
		$("#fullName").on('keyup', function(evt) {
			if(!isEmpty($(this).val())){
				var kr = /[\u1100-\u11FF\u3130-\u318F\uA960-\uA97F\uAC00-\uD7AF\uD7B0-\uD7FF]/g
				let letters = /^[a-zA-Z ]+$/
				let kr2 =  /[\uac00-\ud7af]|[\u1100-\u11ff]|[\u3130-\u318f]|[\ua960-\ua97f]|[\ud7b0-\ud7ff]/g
				let engKr = /[^a-zA-Z0-9\u3130-\u318F\uAC00-\uD7AF]/g

				// console.log("kr===", $(this).val().match(kr))
				// console.log("kr===", $(this).val().match(kr))
				console.log("letters===", $(this).val().match(letters))

				if( $(this).val().match(kr) || $(this).val().match(letters)){
					$("#isValidName").addClass("hidden");
				} else {
					$("#isValidName").removeClass("hidden");
				}
				$("#updateProfileBtn").prop("disabled", false);
				$("#updateProfileBtn").removeClass("disabled");
			}
		});

		$("#mobileNum").on('keyup', function(evt, limit) {
			if( $(this).val().match(/[^\x00-\x80]/) ){
				$(this).val("");
			}
			if(!isEmpty($(this).val())){
				$("#updateProfileBtn").prop("disabled", false);
				$("#updateProfileBtn").removeClass("disabled");
			}
		});
		$("#mobileNum").on('keypress', function(evt) {
			let val = $(this).val();
			if (evt.which < 48 || evt.which > 57) {
				return false;
			}
		});

		$("#emailAddr").on('keyup', function(evt, limit) {
			if(!isEmpty($(this).val())){
				console.log( validateEmail($(this).val())  )
				if(validateEmail($(this).val()) == false) {
					$("#isValidEmail").removeClass("hidden");
				} else {
					$("#isValidEmail").addClass("hidden");
					return false;
				}
				$("#updateProfileBtn").prop("disabled", false);
				$("#updateProfileBtn").removeClass("disabled");
			}
		});


		$("#confirmNewPwd").keyup(function() {
			let password = $("#newPwd").val();
			password == $(this).val() ? $("#pwdMatched").addClass("hidden") : $("#pwdMatched").removeClass("hidden");

			let validated = $("#pwdMatched").hasClass("hidden");
			if( $(".tick:not(.checked)").index() == -1 && validated){
				$("#updatePwdBtn").prop("disabled", false);
				$("#updatePwdBtn").removeClass("disabled");
			}
		});

		$("#pwdForm").on("submit", function(e){
			e.preventDefault();
			let uid = '${sessionScope.userInfo.uid}';
			let token = '${sessionScope.userInfo.token}';
			let value = {
				// oldPassword : $("#oldPwd").val(),
				// newPassword : $("#newPwd").val(),
				password : $("#newPwd").val()
			}

			let option = {
				url: 'https://iderms-api.iderms.ai/config/users/' + uid + '/password',
				dataType: 'json',
				type: 'patch',
				beforeSend: function (jqXHR, settings) {
					jqXHR.setRequestHeader('Authorization', 'Bearer ' + token);
				},
				async: false,
				contentType: "application/json",
				data: JSON.stringify(value)
			}
			// console.log("token===", token)
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				console.log("success===", json);
				$("#successMsg1").removeClass("hidden");
				setTimeout(function(){
					$("#successMsg1").addClass("hidden");
				}, 2000);

			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});
		});

		$("#profileForm").on("submit", function(e){
			e.preventDefault();
			let value = {};

			if(!isEmpty($("#fullName").val())) {
				value.name = $("#fullName").val();
			}
			if(!isEmpty($("#taskCategory").val())) {
				value.contact_email = $("#emailAddr").val();
			}
			if(!isEmpty($("#mobileNum").val())) {
				if($("#mobileNum").val().length >= 10){
					$("#isValidMobileNum").addClass("hidden");
					value.contact_phone = $("#mobileNum").val();
				} else {
					$("#isValidMobileNum").removeClass("hidden");
				}
			}

			let uid = '${sessionScope.userInfo.uid}';
			let token = '${sessionScope.userInfo.token}';
		
			let option = {
				url: 'https://iderms-api.iderms.ai/config/users/' + uid,
				dataType: 'json',
				type: 'patch',
				beforeSend: function (jqXHR, settings) {
					jqXHR.setRequestHeader('Authorization', 'Bearer ' + token);
				},
				async: false,
				contentType: "application/json",
				data: JSON.stringify(value)
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				console.log("success===", json);
				$("#successMsg2").removeClass("hidden");
				setTimeout(function(){
					$("#successMsg2").addClass("hidden");
				}, 2000);

			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
				return false;
			});
		});

		function validateName(name){
			let re = /\S+@\S+\.\S+/;
			// let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,

			return re.test(email);
		}

		function validateEmail(email){
			// let re = /\S+@\S+\.\S+/;
			let re = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
			// let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,

			return re.test(email);
		}

		function ValidatePassword() {
			const rules = [
				{
					Pattern: "[a-zA-Z]",
					Target: "hasLetter"
				},
				{
					Pattern: "[0-9]",
					Target: "hasNumber"
				},
				// {
				// Pattern: "[!@@#$%^&*]",
				// Target: "Symbols"
				// }
			];

			let password = $(this).val();
			password.length > 6 ? $("#isSixCharLong").addClass("checked") : $(".tick.min-length").removeClass("checked");

			for (var i = 0; i < rules.length; i++) {
				if( new RegExp(rules[i].Pattern).test(password) ) {
					$("#" + rules[i].Target).addClass("checked")
				} else {
					$("#" + rules[i].Target).removeClass("checked")
				}
			}

		}


	});


	function dashboardMove(type, key, value) {
		let inp = $('input').attr('type', 'hidden').attr('name', key).attr('value', value);
		if(type == 'group') {
			$('#dashboardForm').append(inp).attr('action', '/dashboard/gmain.do').submit();
		} else if(type == 'site') {
			$('#dashboardForm').append(inp).attr('action', '/dashboard/smain.do').submit();
		} else if(type == 'vpp') {
			$('#dashboardForm').append(inp).attr('action', '/dashboard/jmain.do').submit();
		} else {
			alert('아직 정의 되지않은 타입입니다.');
			return;
		}
	}

</script>

<form id="dashboardForm" name="dashboardForm" method="post"></form>

<nav class="clear">
	<button type="button" class="category">카테고리</button>
	<c:choose>
		<c:when test="${fn:contains(pageContext.request.serverName, 'spower')}">
			<div class="nav-brand spower"><a href="/dashboard/gmain.do">${sessionScope.userInfo.login_id}</a></div>
		</c:when>
		<c:otherwise>
			<div class="nav-brand"><a href="/dashboard/gmain.do">${sessionScope.userInfo.login_id}</a></div>
		</c:otherwise>
	</c:choose>

	<c:set var="siteList" value="${siteHeaderList}"/> <!-- 사이트 별 -->
	<c:set var="tagList" value="${tag_group}"/> <!-- 그룹 별 -->
	<c:set var="vppList" value="${vpp_group}"/> <!-- 중개거래 별 -->
	<c:set var="drList" value="${dr_group}"/> <!-- DR거래 별 -->

	<div class="all-menu">
		<a href="javascript:void(0);">구분</a>
		<form name="menuform" method="post">
			<div class="menu-group">
				<ul>
					<li>
						<dl>
							<dt>사업소 분석</dt>
							<dd>
								<a href="javascript:void(0);">사업소별</a>
								<ul>
									<li><a href="javascript:void(0);"  onclick="dashboardMove('group', '', '');">전체</a></li>
									<c:if test="${fn:length(siteList) > 0}">
										<c:forEach var="site" items="${siteList}">
											<li>
												<a href="javascript:void(0);" onclick="dashboardMove('site', 'sid', '${site.sid}');">${site.name}</a>
											</li>
										</c:forEach>
									</c:if>
								</ul>
							</dd>
						</dl>
					</li>
					<c:if test="${fn:length(tagList) > 0}">
						<li>
							<dl>
								<dt></dt>
								<dd>
									<a href="javascript:void(0);">그룹별</a>
									<ul>
										<c:forEach var="group" items="${tagList}">
											<li>
												<a href="javascript:void(0);" onclick="dashboardMove('group', 'sgid', '${group.sgid}');">${group.name}</a>
												<ul>
													<c:set var="groupSites" value="${group.sites}"/>
													<c:forEach var="groupSiteList" items="${groupSites}">
														<li>
															<a href="javascript:void(0);" onclick="dashboardMove('site', 'sid', '${groupSiteList.sid}');">${groupSiteList.name}</a>
														</li>
													</c:forEach>
												</ul>
											</li>
										</c:forEach>
									</ul>
								</dd>
							</dl>
						</li>
					</c:if>
				</ul>
				<c:if test="${fn:length(vppList) > 0 || fn:length(drList) > 0}">
					<ul>
						<c:if test="${oid ne 'trust' and fn:length(vppList) > 0}">
							<li>
								<dl>
									<dt>에너지 거래</dt>
									<dd>
										<a href="javascript:void(0);">중개거래</a>
										<ul>
											<c:forEach var="vpp" items="${vppList}">
												<li>
													<a href="javascript:void(0);" onclick="dashboardMove('vpp', 'vgid', '${vpp.vgid}');">${vpp.name}</a>
													<ul>
														<c:set var="groupSites" value="${vpp.sites}"/>
														<c:forEach var="groupSiteList" items="${groupSites}">
															<li>
																<a href="javascript:void(0);" onclick="dashboardMove('site', 'sid', '${groupSiteList.sid}');">${groupSiteList.name}</a>
															</li>
														</c:forEach>
													</ul>
												</li>
											</c:forEach>
										</ul>
									</dd>
								</dl>
							</li>
						</c:if>
						<c:if test="${fn:length(drList) > 0}">
							<li>
								<dl>
									<dt></dt>
									<dd>
										<a href="javascript:void(0);">DR 거래</a>
										<ul>
											<c:forEach var="dr" items="${drList}">
												<li><a href="#">${dr.name}</a></li>
											</c:forEach>
										</ul>
									</dd>
								</dl>
							</li>
						</c:if>
					</ul>
				</c:if>
				<ul>
					<li class="lo-type lo">
						<dl>
							<dt>지역 및 유형 선택</dt>
							<dd>
								<a href="javascript:void(0);">지역별</a>
								<ul>
									<c:set var="systemLoc" value="${sessionScope.systemLoc}"/>
									<c:forEach var="loc" items="${location}" varStatus="stat">
										<li>
											<a href="javascript:void(0);">${loc.value.name.kr}</a>
											<ul>
												<c:forEach var="country" items="${loc.value.locations}" varStatus="countryStat">
													<c:set var="choice" value="false" />
													<c:if test="${fn:length(systemLoc) > 0}">
														<c:forEach var="selLoc" items="${systemLoc}">
															<c:if test="${country.value.code eq selLoc}">
																<c:set var="choice" value="true" />
															</c:if>
														</c:forEach>
													</c:if>
													<li>
														<input type="checkbox" name="systemLoc" id="lo${countryStat.index}" value="${country.value.code}" <c:if test="${choice eq 'true'}">checked</c:if>>
														<label for="lo${countryStat.index}" <c:if test="${choice eq 'true'}">class="on"</c:if>>${country.value.name.kr}</label>
													</li>
												</c:forEach>
											</ul>
										</li>

									</c:forEach>
								</ul>
							</dd>
						</dl>
					</li>
					<li class="lo-type type">
						<dl>
							<dt></dt>
							<dd>
								<a href="javascript:void(0);">유형별</a>
								<ul>
									<c:set var="systemTp" value="${sessionScope.systemTp}"/>
									<c:forEach var="type" items="${resource}" varStatus="stat">
										<c:set var="choice" value="false" />
										<c:if test="${fn:length(systemTp) > 0}">
											<c:forEach var="selType" items="${systemTp}">
												<c:if test="${type.value.code eq selType}">
													<c:set var="choice" value="true" />
												</c:if>
											</c:forEach>
										</c:if>
										<li>
											<input type="checkbox" name="systemType" id="tp${stat.index}" value="${type.value.code}" <c:if test="${choice eq 'true'}">checked</c:if>>
											<label for="tp${stat.index}" <c:if test="${choice eq 'true'}">class="on"</c:if>>${type.value.name.kr}</label>
										</li>
									</c:forEach>
								</ul>
							</dd>
						</dl>
					</li>
				</ul>
				<div class="menu_btm_bx">
					<button type="button" class="btn_type03" id="systemInit">초기화</button><!--
					--><button type="button" class="btn_type ml-12" id="systemApply">적용</button>
				</div>
				<script type="text/javascript">
					$('#systemInit').on('click', function() {
						$(':checkbox[name="systemLoc"]').prop('checked', false);
						$(':checkbox[name="systemType"]').prop('checked', false);
						let sysInp = $('<input>').attr('type', 'hidden').attr('name', 'systemValue').val('system');
						$('form[name="menuform"]').append(sysInp).attr('action', '/dashboard/gmain.do').submit();
					});

					$('#systemApply').on('click', function() {
						let sysInp = $('<input>').attr('type', 'hidden').attr('name', 'systemValue').val('system');
						$('form[name="menuform"]').append(sysInp).attr('action', '/dashboard/gmain.do').submit();
					});
				</script>
				</ul>
			</div>
		</form>
	</div>
	<!--// input/dropdown -->
	<ul class="nav_right">
		<li class="member clear">
			<div class="fl"><img src="../img/m_member_pic.png" alt=""></div>
			<div class="fr">
				<button type="button" data-toggle="modal" data-target="#updateUserInfoModal" class="btn_type03">${sessionScope.userInfo.name}<span class="light">&emsp;${sessionScope.userInfo.login_id}</span></button>
			</div>
		</li>
		<%--	
		<li>
			<!-- 테마 선택 -->
			<div class="nav_theme">
				<div class="switcher">
					<input type="radio" name="balance" value="light" id="light"
					       class="switcher__input switcher__input--light"
					       checked="" onClick="userTheme('light');">
					<label for="light" class="switcher__label">Light</label>
					<input type="radio" name="balance" value="dark" id="dark"
					       class="switcher__input switcher__input--dark"
					       onClick="userTheme('dark');">
					<label for="dark" class="switcher__label">Dark</label>
					<span class="switcher__toggle"></span>
				</div>
			</div>
		</li>
		--%>
		<li><%@ include file="/decorators/include/selectLang.jsp" %></li>
	</ul>
</nav>

<div class="modal fade" id="updateUserInfoModal" tabindex="-1" role="dialog" aria-labelledby="updateUserInfoModal" aria-hidden="true">
	<div class="modal-dialog modal-md">
		<div class="modal-content">
			<div class="modal-header"><h2>개인정보 설정</h2></div>
				<input type="hidden" id="modUserIdx" name="userIdx"/>
				<input type="hidden" id="modPsnEmail" name="psnEmail"/>
				<input type="hidden" id="modPsnMobile" name="psnMobile"/>
				<div class="modal-body">
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="userId" class="input_label">아이디</label>
								<input type="text" name="user_id" id="userId" class="input tx_inp_type w-100" readonly="" autocomplete="off">
							</div>
							<div class="input-group inline-flex mt-0">
								<label for="affiliation" class="input_label">회사 이름</label>
								<input type="text" name="affiliation" id="affiliation" class="input tx_inp_type w-100" readonly="" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="accessLevel" class="input_label">권한 레벨</label>
								<input type="text" name="access_level" id="accessLevel" class="input tx_inp_type w-100" readonly="" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="taskCategory" class="input_label">업무 구분</label>
								<input type="text" name="task_category" id="taskCategory" class="input tx_inp_type w-100" readonly="" autocomplete="off">
							</div>
						</div>
					</div>
					<form id="pwdForm" name="pwd_form">
						<div class="row">
							<div class="col-12">
								<h3 class="sub-title mt15">비밀번호</h3>
								<div class="input-group inline-flex">
									<label for="oldPwd" class="input_label">기존 비밀번호</label>
									<input type="password" name="current_pwd" id="oldPwd" class="input tx_inp_type w-100" placeholder="입력" autocomplete="off">

								</div>
								<div class="input-group inline-flex">
									<label for="newPwd" class="input_label">변경 비밀번호</label>
									<input type="password" name="new_pwd" id="newPwd" class="input tx_inp_type w-100" placeholder="입력" autocomplete="off">
								</div>
								<div class="flex_start warning-wrapper">
									<small id="hasLetter" class="tick">영문</small>
									<small id="hasNumber" class="tick">숫자</small>
									<small id="isSixCharLong" class="tick">6자리 이상</small>
								</div>

								<div class="input-group inline-flex">
									<label for="confirmNewPwd" class="input_label">변경 비밀번호 확인</label>
									<input type="password" name="confirm_new_pwd" id="confirmNewPwd" class="input tx_inp_type w-100" placeholder="입력" autocomplete="off">
								</div>

								<div class="flex_start warning-wrapper">
									<small id="pwdMatched" class="warning-text hidden">비밀번호가 일치하지 않습니다.</small>
								</div>

								<div class="btn_wrap_type05">
									<small id="successMsg1" class="text-blue text-sm hidden">비밀번호가 성공적으로 변경 되었습니다.</small>
									<button type="submit" disabled id="updatePwdBtn" class="btn_type03 disabled">비밀번호 변경</button>
								</div>
							</div>
						</div>
					</form>
					<form id="profileForm" name="profile_form">
						<div class="row">
							<div class="col-12">
								<h3 class="sub-title">개인정보</h3>
								<div class="input-group inline-flex">
									<label for="fullName" class="input_label">이름</label>
									<input type="text" name="full_name" id="fullName" class="input tx_inp_type w-100" placeholder="입력" autocomplete="off">
								</div>

								<div class="flex_start warning-wrapper">
									<small id="isValidName" class="warning-text hidden">이름을 입력해 주세요.</small>
								</div>
								
								<div class="input-group inline-flex">
									<label for="emailAddr" class="input_label">이메일</label>
									<input type="text" name="email_addr" id="emailAddr" class="input tx_inp_type w-100" placeholder="입력" autocomplete="off">
								</div>
								<div class="flex_start warning-wrapper">
									<small id="isValidEmail" class="warning-text hidden">유효한 이메일 주소를 입력해 주세요.</small>
								</div>
								
								<div class="input-group inline-flex">
									<label for="mobileNum" class="input_label">휴대폰</label>
									<input type="text" name="mobile_num" id="mobileNum" class="input tx_inp_type w-100" placeholder="입력" autocomplete="off">
								</div>
								<div class="flex_start warning-wrapper">
									<small id="isValidMobileNum" class="warning-text hidden">휴대폰 번호를 입력해 주세요.</small>
								</div>
								
								<div class="btn_wrap_type">
									<small id="successMsg2" class="text-blue text-sm hidden">개인정보가 성공적으로 변경 되었습니다.</small>
									<button type="submit" id="updateProfileBtn" disabled class="btn_type03 disabled">개인정보 변경</button>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer border">
					<div class="btn_wrap_type02">
						<button type="button" class="btn_type" data-dismiss="modal" aria-label="Close">완료</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
