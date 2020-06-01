<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	var selViewSiteName = "";
	$(function () {
		// const navLogo = $(".nav_brand.spower");
		// navLogo.on("click", function(){
		// 	console.log("logo clicked===")
		// })
		refreshCurrTime();
	});

	function refreshCurrTime() {
		var currEm = $('.currTime');
		var now = new Date();
		currEm.text(now.format('yyyy-MM-dd HH:mm:ss'));
		setTimeout(refreshCurrTime, 1000); // 매초 갱신
	}

	function addParameterUrl(paramNm, paramVal) {
		var newUrl = changeParamUrl(window.location.href, paramNm, paramVal, window.location.pathname);
		location.href = newUrl;
	}

	function changeParamUrl(url, paramName, paramValue, pathName) {
		var urlArr = url.split("?");
		var newParamUrl = "";
		if (urlArr.length > 1) {
			var paramArr = urlArr[1].split("&");
			var separator = "";
			var ynFlag = false;
			for (var i in paramArr) {
				var compareParam = paramArr[i].split("=");
				if (compareParam[0].indexOf(paramName) > -1) {
					newParamUrl += separator + paramName + "=" + paramValue;
					ynFlag = true;
				} else {
					newParamUrl += separator + paramArr[i];
				}
				separator = "&";
			}

			if (!ynFlag) {
				newParamUrl += separator + paramName + "=" + paramValue;
			}
		} else {
			newParamUrl = paramName + "=" + paramValue;
		}

		var newPathName = pathName;
		if (pathName != null && pathName != "" && pathName != undefined) {
			if (pathName == "/main/gMain.do") {
				if (paramName == "siteId") {
					newPathName = "/main/siteMain.do";
				}
			}
		}

		return newPathName + "?" + newParamUrl;
	}

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
<form id="dashboardForm" name="dashboardForm" method="post">
</form>
<nav class="clear">
	<button type="button" class="category">카테고리</button>
	<!-- 모바일용 언어 선택 -->
	<div class="lang dropdown">
		<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">KO
			<span class="caret"></span></button>
		<ul class="dropdown-menu">
			<li><a href="#">KO</a></li>
			<li><a href="#">EN</a></li>
		</ul>
	</div>
	<c:choose>
		<c:when test="${pageContext.request.serverName eq 'spower.iderms.ai' or pageContext.request.serverName eq '13.114.199.169' or pageContext.request.serverName eq 'localhost'}">
			<div class="nav_brand spower"><a href="/dashboard/gmain.do">Spower</a></div>
		</c:when>
		<c:otherwise>
			<div class="nav_brand"><a href="#">Encored</a></div>
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
													<c:set var="groupSites" value="${group.group_sites}"/>
													<c:forEach var="groupSiteList" items="${groupSites}">
														<li>
															<c:forEach var="site" items="${siteList}">
																<c:if test="${groupSiteList.sid eq site.sid}">
																	<a href="javascript:void(0);" onclick="dashboardMove('site', 'sid', '${groupSiteList.sid}');">${site.name}</a>
																</c:if>
															</c:forEach>
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
						<c:if test="${fn:length(vppList) > 0}">
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
																<c:forEach var="site" items="${siteList}">
																	<c:if test="${groupSiteList.sid eq site.sid}">
																		<a href="javascript:void(0);" onclick="dashboardMove('site', 'sid', '${groupSiteList.sid}');">${site.name}</a>
																	</c:if>
																</c:forEach>
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
					<button type="button" class="btn_type03" id="systemInit">초기화</button>
					<button type="button" class="btn_type" id="systemApply">적용</button>
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
	</div><!--// input/dropdown -->
	<ul class="nav_right">
		<%--					<li>--%>
		<%--						<span>CURRENT TIME</span> <em id="currTime">${nowTime}</em>--%>
		<%--					</li>--%>
		<%--					<li>--%>
		<%--						<span>DATA BASE TIME</span> 2018-07-27 17:01:02--%>
		<%--					</li>--%>
		<li class="member clear">
			<div class="fl"><img src="../img/m_member_pic.png" alt=""></div>
			<div class="fr">
				<span class="myinfo">
					<c:choose>
						<c:when test="${not empty userInfo and not empty userInfo.psn_name}">${userInfo.psn_name}</c:when>
						<c:when test="${not empty userInfo and empty userInfo.psn_name}">${userInfo.user_id}</c:when>
					</c:choose>
				</span><br/>
				<c:choose>
					<c:when test="${empty userInfo}">No Permission</c:when>
					<c:when test="${userInfo.auth_type eq '1'}">Portal Administrator</c:when>
					<c:when test="${userInfo.auth_type eq '2'}">Customer Administrator</c:when>
					<c:when test="${userInfo.auth_type eq '3'}">Group Administrator</c:when>
					<c:when test="${userInfo.auth_type eq '4'}">Site Administrator</c:when>
					<c:when test="${userInfo.auth_type eq '5'}">Site User</c:when>
					<c:otherwise>No Permission</c:otherwise>
				</c:choose>
			</div>
		</li>
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
		<li>
			<!-- PC용 언어 선택 -->
			<%@ include file="/decorators/include/selectLang.jsp" %>
		</li>
	</ul>
</nav>
<script type="text/javascript">
	$(function () {
		var data = [];

		$('#userGroupList > li').each(function (idx, elmt) {
			var userGroupLi = $(elmt);
			var userSiteLiList = userGroupLi.find('li');
			for (var i = 0; i < userSiteLiList.length; i++) {
				var userSiteLi = $(userSiteLiList[i]);
				if (userSiteLi.data('value') == '0') {
					continue;
				}
				data.push({
					label: userSiteLi.text(),
					value: userSiteLi.data('value'),
					category: userGroupLi.children('.groupLink').text()
				});
			}
		});

		$.widget("custom.catcomplete", $.ui.autocomplete, {
			_create: function () {
				this._super();
				this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
			},
			_renderMenu: function (ul, items) {
				var that = this, currentCategory = "";
				ul.addClass('c_style');
				$.each(items, function (index, item) {
					var li;
					if (item.category != currentCategory) {
						ul.append("<li class='ui-autocomplete-category'>" + item.category + "</li>");
						currentCategory = item.category;
					}
					li = that._renderItemData(ul, item);
					if (item.category) {
						li.attr("aria-label", item.category + " : " + item.label);
					}
				});
			}
		});

		$('#selSiteBox').catcomplete({
			source: data,
			select: function (event, ui) {
				event.preventDefault();
				$('#selSiteBox').val(ui.item.label);
				location.href = '/main/siteMain.do?siteId=' + ui.item.value;
			},
			focus: function (event, ui) {
				event.preventDefault();
				$('#selSiteBox').val(ui.item.label);
			}
		});

		if (selViewSiteName != "") {
			$("#selSiteBox").val("군관리: " + selViewSiteName);
		}
	});
</script>
<!-- 정보수정 // -->
<div class="modal fade" id="modifyModal" tabindex="-1" role="dialog" aria-labelledby="modifyModal" aria-hidden="true">
	<div class="modal-dialog modal-md">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header" style="padding:25px 30px;">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4><i class="glyphicon glyphicon-user"></i> MODIFY</h4>
			</div>
			<form id="modifyUserForm" name="modifyUserForm">
				<input type="hidden" id="modUserIdx" name="userIdx"/>
				<input type="hidden" id="modPsnEmail" name="psnEmail"/>
				<input type="hidden" id="modPsnMobile" name="psnMobile"/>
				<div class="modal-body" style="padding:20px 30px;">
					<div class="rowBox joinBox">
						<div class="unit clear">
							<div class="unit_tit">
								<span class="sTit">사용자 정보</span>
							</div>
							<div class="unit_cont lineBox">
								<table class="tableStyle formStyle left">
									<colgroup>
										<col style="width:20%;">
										<col style="width:*;">
									</colgroup>
									<tbody>
									<tr>
										<th>아이디</th>
										<td align="left" id="modUserId">
											gildong
										</td>
									</tr>
									<tr>
										<th>이름</th>
										<td align="left" id="modPsnName">
											홍길동
										</td>
									</tr>
									<tr>
										<th>비밀번호</th>
										<td>
											<input type="password" id="modUserPw" name="userPw" class="inp"
											       style="width:100%;"/>
											<span class="helpCont">비밀번호를 입력하세요</span>
										</td>
									</tr>
									<tr>
										<th>비밀번호확인</th>
										<td>
											<input type="password" id="modUserPw2" class="inp" style="width:100%;"/>
											<span class="helpCont">비밀번호확인이 일치하지 않습니다</span>
										</td>
									</tr>
									<tr>
										<th>이메일 주소</th>
										<td>
											<div class="inputGroup">
												<input type="text" id="modEmail1" class="inp fl" style="width:30%;"
												       maxlength="25"/>
												<span class="inline center fl" style="width:5%;">@</span>
												<input type="text" id="modEmail3" class="inp fl"
												       style="width:27%; margin-right:10px;" maxlength="25"/>
												<select id="modEmail2" class="inp fl" style="width:35%;">
													<option value="">=선택=</option>
													<option value="naver.com">naver.com</option>
													<option value="hanmail.net">hanmail.net</option>
													<option value="nate.com">nate.com</option>
													<option value="gmail.com">gmail.com</option>
													<option value="manual" selected="selected">직접입력</option>
													<select>
											</div>
											<span class="helpCont">email을 입력하세요</span>
										</td>
									</tr>
									<tr>
										<th>휴대폰 번호</th>
										<td>
											<div class="inputGroup">
												<input type="text" id="modMobile1" class="inp fl" style="width:30%;"
												       maxlength="3"/>
												<span class="inline center fl" style="width:5%;">-</span>
												<input type="text" id="modMobile2" class="inp fl" style="width:30%;"
												       maxlength="4"/>
												<span class="inline center fl" style="width:5%;">-</span>
												<input type="text" id="modMobile3" class="inp fl" style="width:30%;"
												       maxlength="4"/>
											</div>
											<span class="helpCont">휴대폰번호를 입력해 주세요</span>
											<span class="helpCont">숫자를 입력해 주세요</span>
										</td>
									</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<div style="padding:5px 20px;text-align:right;">
						<button type="button" class="memberout_btn w80 fl" id="removeUserBtn">탈퇴</button>
						<button type="button" class="cancel_btn w80" data-dismiss="modal">취소</button>
						<button type="submit" class="default_btn w80" data-dismiss="modal" id="modifyUserBtn">확인
						</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<script>
	$(function () {
		$(".myinfo").click(function () {
			setModifyUserInfo(sessionUser);
			$("#modifyModal").modal("show");
		});
	});

	// 정보 수정, 탈퇴 시작 (적당한 js파일로 옮겨 주세요.)
	$(function () {
		$("#modifyUserBtn").click(function () {
			checkModify();
			return false;
		});

		$("#removeUserBtn").click(function () {
			if (confirm("탈퇴하시겠습니까?\n탈퇴하면 복구할 수 없습니다.")) {
				removeUser();
			}
		});

		$('#modEmail2').change(function () {
			var val = $(this).val();
			if (val === 'manual') {
				$('#modEmail1').css('width', '30%');
				$('#modEmail3').show();
			} else {
				$('#modEmail1').css('width', '60%');
				$('#modEmail3').hide();
			}
		});
	});

	function setModifyUserInfo(result) {
		$('#modUserIdx').val(result.user_idx);
		$('#modUserId').text(result.user_id);
		$('#modPsnName').text(result.psn_name);

		$('#modUserPw').val('');
		$('#modUserPw2').val('');

		var email = result.psn_email;
		if (email != null && email.indexOf('@') !== -1) {
			var emails = email.split('@');
			$('#modEmail1').val(emails[0]);
			$('#modEmail3').val(emails[1]);
		}

		var mobile = result.psn_mobile;
		if (mobile !== null && mobile.indexOf('-') !== -1) {
			var mobiles = mobile.split('-');
			$('#modMobile1').val(mobiles[0]);
			$('#modMobile2').val(mobiles[1]);
			$('#modMobile3').val(mobiles[2]);
		}

		$('.helpCont').hide();
	}

	function checkModify() {
		var $modUserPw2 = $('#modUserPw2');
		var $helpCont = $('.helpCont');
		if ($('#modUserPw').val() !== $modUserPw2.val()) {
			$helpCont.hide();
			$modUserPw2.parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		var $modEmail1 = $('#modEmail1');
		var $modEmail2 = $('#modEmail2');
		var $modEmail3 = $('#modEmail3');
		if ($modEmail1.val() === '' || $modEmail2.val() === '') {
			$helpCont.hide();
			$modEmail1.parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		if ($modEmail2.val() === 'manual' && $modEmail3.val() === '') {
			$helpCont.hide();
			$modEmail1.parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		var $modMobile1 = $('#modMobile1');
		var $modMobile2 = $('#modMobile2');
		var $modMobile3 = $('#modMobile3');
		if ($modMobile1.val() === '' || $modMobile2.val() === '' || $modMobile3.val() === '') {
			$helpCont.hide();
			$modMobile1.parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		if (isNaN($modMobile1.val()) || isNaN($modMobile2.val()) || isNaN($modMobile3.val())) {
			$helpCont.hide();
			$modMobile1.parents('td').children('.helpCont:eq(1)').show();
			return;
		}

		$helpCont.hide();

		if (confirm("수정하시겠습니까?")) {
			if ($modEmail2.val() !== 'manual') {
				$('#modPsnEmail').val($modEmail1.val() + '@' + $modEmail2.val());
			} else {
				$('#modPsnEmail').val($modEmail1.val() + '@' + $modEmail3.val());
			}
			$('#modPsnMobile').val($modMobile1.val() + '-' + $modMobile2.val() + '-' + $modMobile3.val());

			modifyUser();
		}
	}

	function modifyUser() {
		var formData = $("#modifyUserForm").serializeObject();
		$.ajax({
			url: "/modifyUser.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				var resultCnt = result.resultCnt;
				if (resultCnt > 0) {
					alert('사용자 정보가 수정되었습니다.');

					// Local EMS 회원 연계
					changeEMSUserDB($("#modUserIdx").val());

					$("#modifyModal").modal("hide");
					getUserInfo(setSession);
				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			}
		});
	}

	function removeUser() {
		var formData = $("#modifyUserForm").serializeObject();
		$.ajax({
			url: "/removeUser.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				var resultCnt = result.resultCnt;
				if (resultCnt > 0) {
					alert('탈퇴처리 되었습니다.');

					// Local EMS 회원 연계
					changeEMSUserDB($("#modUserIdx").val());

					location.href = '/login.do';
				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			}
		});
	}

	userTheme();
</script>
<!-- //정보수정 -->