<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
  var selViewSiteName = "";
  $(function () {
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
</script>
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
  <div class="nav_brand"><a href="#;">Encored</a></div>
  <!-- input/dropdown //-->
  <div class="all-menu">
    <a href="#">구분</a>
    <form name="menuform" action="" method="post">
      <div class="menu-group">
			<ul>
			  <li>
				<dl>
				  <dt>사업소 분석</dt>
				  <dd>
					<a href="#">사업소별</a>
					<ul>
					  <li><a href="">전체</a></a></li>
					  <li><a href="/dashboard/smain.do?sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37">혜원솔라 01</a></li>
					  <li><a href="/dashboard/smain.do?sid=0c7c90c6-9505-4f77-b42d-500c2879c689">혜원솔라 02</a></li>
					</ul>
				  </dd>
				</dl>
			  </li>
			  <li>
				<dl>
				  <dt></dt>
				  <dd>
					<a href="#">그룹별</a>
					<ul>
					  <li>
						<a href="">그룹#1</a>
						<ul>
						  <li><a href="/dashboard/smain.do">사업소#1</a></li>
						</ul>
					  </li>
					  <li>
						<a href="#">그룹#2</a>
						<ul>
						  <li><a href="/dashboard/smain.do">사업소#1</a></li>
						  <li><a href="/dashboard/smain.do">사업소#2</a></li>
						</ul>
					  </li>
					 </ul>
				  </dd>
				</dl>
			  </li>
			 </ul>
			 <ul>
			  <li>
				<dl>
				  <dt>에너지 거래</dt>
				  <dd>
					<a href="#">중개거래</a>
					<ul>
					  <li><a href="/dashboard/smain.do">자원이름 #1</a></li>
					  <li><a href="/dashboard/smain.do">자원이름 #2</a></li>
					</ul>
				  </dd>
				</dl>
			  </li>
			  <li>
				<dl>
				  <dt></dt>
				  <dd>
					<a href="#">DR 거래</a>
					<ul>
					  <li><a href="/dashboard/smain.do">자원이름 #1</a></li>
					  <li><a href="/dashboard/smain.do">자원이름 #2</a></li>
					</ul>
				  </dd>
				</dl>
			  </li>
			 </ul>
			 <ul>
			  <li>
				<dl>
				  <dt>지역 및 유형 선택</dt>
				  <dd>
					<a href="#">지역 별</a>
					<ul>
					  <li><a href="/dashboard/smain.do">서울특별시</a></li>
					  <li><a href="/dashboard/smain.do">부산광역시</a></li>
					  <li><a href="/dashboard/smain.do">대구광역시</a></li>
					  <li><a href="/dashboard/smain.do">인천광역시</a></li>
					  <li><a href="/dashboard/smain.do">광주광역시</a></li>
					  <li><a href="/dashboard/smain.do">울산광역시</a></li>
					  <li><a href="/dashboard/smain.do">경기도</a></li>
					  <li><a href="/dashboard/smain.do">강원도</a></li>
					  <li><a href="/dashboard/smain.do">충청북도</a></li>
					  <li><a href="/dashboard/smain.do">충청남도</a></li>
					  <li><a href="/dashboard/smain.do">전라북도</a></li>
					  <li><a href="/dashboard/smain.do">전라남도</a></li>
					  <li><a href="/dashboard/smain.do">경상북도</a></li>
					  <li><a href="/dashboard/smain.do">경상남도</a></li>
					  <li><a href="/dashboard/smain.do">제주도</a></li>
					</ul>
				  </dd>
				</dl>
			  </li>
			  <li>
				<dl>
				  <dt></dt>
				  <dd>
					<a href="#">유형 별</a>
					<ul>
					  <li><a href="/dashboard/smain.do">태양광</a></li>
					  <li><a href="/dashboard/smain.do">풍력</a></li>
					  <li><a href="/dashboard/smain.do">소수력</a></li>
					  <li><a href="/dashboard/smain.do">신재생 연계 ESS</a></li>
					</ul>
				  </dd>
				</dl>
			  </li>
			 </ul>
			 <div class="menu_btm_bx">
				<button type="button" class="btn_type03">초기화</button>
				<button type="button" class="btn_type">적용</button>
			 </div>
<%--          <li>--%>
<%--            <dl>--%>
<%--              <dt>에너지 거래</dt>--%>
<%--              <dd>--%>
<%--                <a href="#">중개거래</a>--%>
<%--                <ul>--%>
<%--                  <li><a href="/dashboard/jmain.do">자원이름#1</a></li>--%>
<%--                  <li><a href="">자원이름#2</a></li>--%>
<%--                  <li><a href="">자원이름#3</a></li>--%>
<%--                </ul>--%>
<%--              </dd>--%>
<%--            </dl>--%>
<%--          </li>--%>
          <!-- <li>
    <dl>
      <dt></dt>
      <dd>
                <a href="#">DR거래</a>
                <ul>
                  <li><a href="">자원이름#1</a></li>
                  <li><a href="">자원이름#2</a></li>
                </ul>
      </dd>
    </dl>
          </li>	 -->
<%--          <li class="lo-type lo">--%>
<%--            <dl>--%>
<%--              <dt>지역 및 유형 선택</dt>--%>
<%--              <dd>--%>
<%--                <a href="#">지역별</a>--%>
<%--                <ul>--%>
<%--                  <li><input type="checkbox" name="location" id="lo2"><label for="lo2">서울특별시</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo3"><label for="lo3">부산광역시</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo4"><label for="lo4">대구광역시</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo5"><label for="lo5">인천광역시</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo6"><label for="lo6">광주광역시</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo7"><label for="lo7">울산광역시</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo8"><label for="lo8">경기도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo9"><label for="lo9">강원도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo10"><label for="lo10">충청북도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo11"><label for="lo11">충청남도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo12"><label for="lo12">전라북도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo13"><label for="lo13">전라남도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo14"><label for="lo14">경상북도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo15"><label for="lo15">경상남도</label></li>--%>
<%--                  <li><input type="checkbox" name="location" id="lo16"><label for="lo16">제주도</label></li>--%>
<%--                </ul>--%>
<%--              </dd>--%>
<%--            </dl>--%>
<%--          </li>--%>
<%--          <li class="lo-type type">--%>
<%--            <dl>--%>
<%--              <dt></dt>--%>
<%--              <dd>--%>
<%--                <a href="#">유형별</a>--%>
<%--                <ul>--%>
<%--                  <li><input type="checkbox" name="type" id="tp2"><label for="tp2">태양광</label></li>--%>
<%--                  <li><input type="checkbox" name="type" id="tp3"><label for="tp3">풍력</label></li>--%>
<%--                  <li><input type="checkbox" name="type" id="tp4"><label for="tp4">소수력</label></li>--%>
<%--                  <li><input type="checkbox" name="type" id="tp5"><label for="tp5">신재생 연계 ESS</label></li>--%>
<%--                  <li><input type="checkbox" name="type" id="tp6"><label for="tp6">피크저감 ESS</label></li>--%>
<%--                </ul>--%>
<%--              </dd>--%>
<%--            </dl>--%>
<%--          </li>--%>
        </ul>
<%--        <div class="btn-group">--%>
<%--          <button type="reset" class="reset-btn">초기화</button>--%>
<%--          <button type="submit" class="apply-btn" disabled>적용</button>--%>
<%--        </div>--%>
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
          <input type="radio" name="balance" value="light" id="light" class="switcher__input switcher__input--light"
                 checked="" onClick="userTheme('light');">
          <label for="light" class="switcher__label">Light</label>
          <input type="radio" name="balance" value="dark" id="dark" class="switcher__input switcher__input--dark"
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
                        <input type="password" id="modUserPw" name="userPw" class="inp" style="width:100%;"/>
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
                          <input type="text" id="modEmail1" class="inp fl" style="width:30%;" maxlength="25"/>
                          <span class="inline center fl" style="width:5%;">@</span>
                          <input type="text" id="modEmail3" class="inp fl"
                                 style="width:27%; margin-right:10px;" maxlength="25" />
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
                          <input type="text" id="modMobile1" class="inp fl" style="width:30%;" maxlength="3"/>
                          <span class="inline center fl" style="width:5%;">-</span>
                          <input type="text" id="modMobile2" class="inp fl" style="width:30%;" maxlength="4"/>
                          <span class="inline center fl" style="width:5%;">-</span>
                          <input type="text" id="modMobile3" class="inp fl" style="width:30%;" maxlength="4"/>
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
            <button type="submit" class="default_btn w80" data-dismiss="modal" id="modifyUserBtn">확인</button>
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