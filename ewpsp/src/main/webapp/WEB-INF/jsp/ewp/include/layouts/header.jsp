<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
  var selViewSiteName = "";

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
      if (pathName == "/main") {
        if (paramName == "siteId") {
          newPathName = "/siteMain";
        }
      }
    }

    return newPathName + "?" + newParamUrl;
  }
</script>
<nav class="clear">
  <button type="button" class="category">카테고리</button>
  <div class="nav_brand"><a href="/">ENCORED</a></div>
  <!-- input/dropdown //-->
  <div class="site form-group">
    <div class="input-group">
      <c:if test="${empty selViewSite.site_name}"><input type="text" value="" autocomplete="off" class="form-control"
                                                         id="selSiteBox" name="selSiteBox" placeholder="전체">
      </c:if>
      <c:if test="${not empty selViewSite.site_name}"><input type="text" value="" autocomplete="off"
                                                             class="form-control" id="selSiteBox" name="selSiteBox"
                                                             placeholder="${selViewSite.site_name}">
      </c:if>
      <div class="input-group-btn bs-dropdown-to-select-group">
        <button type="button" class="btn btn-default dropdown-toggle as-is bs-dropdown-to-select"
                data-toggle="dropdown">
          <span data-bind="bs-drp-sel-label">&nbsp;&nbsp;&nbsp;</span>
          <input type="hidden" name="selected_value" data-bind="bs-drp-sel-value" value="">
          <span class="caret"></span>
        </button>
        <ul class="dropdown-menu" role="menu" style="" id="userGroupList">
          <c:forEach var="userGroup" items="${userGroupList}" varStatus="i">
            <li data-value="${userGroup.site_grp_idx}">
              <a href="#;" class="groupLink">${userGroup.site_grp_name}</a>
              <ul>
                <c:set var="siteExist" value="false"/>
                <c:forEach var="userSite" items="${userSiteList}" varStatus="j">
                  <c:if test="${userSite.site_grp_idx eq userGroup.site_grp_idx}">
                    <li data-value="${userSite.site_id}"><a href="javascript:addParameterUrl('siteId',
                    '${userSite.site_id}')">${userSite.site_name}</a></li>
                    <c:if test="${not siteExist}">
                      <c:set var="siteExist" value="true"/>
                    </c:if>
                  </c:if>
                </c:forEach>
                <c:if test="${not siteExist}">
                  <li data-value="0"><a href="#;">사이트 없음</a></li>
                </c:if>
              </ul>
            </li>
          </c:forEach>
        </ul>
      </div>
    </div>
  </div><!--// input/dropdown -->
  <%--
                  <div class="site dropdown">
                      <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selSiteBox">
                          군관리: ${fn:length(userSiteList)} Sites<span class="caret"></span>
                      </button>
                      <ul class="dropdown-menu">
                          <li class="on"><a href="/siteMain?siteId=${item.site_id }">군관리: ${fn:length(userSiteList)} Sites</a></li>
                          <c:forEach var="item" items="${userSiteList }">
                              <li><a href="/siteMain?siteId=${item.site_id }">${item.site_name }</a></li>
                              <c:if test="${item.site_id eq selViewSiteId }">
                                  <script>
                                  selViewSiteName = "${item.site_name }";
                                  </script>
                              </c:if>
                          </c:forEach>
                          <!-- <li data-value="1">
                              <a href="#">그룹1</a>
                              <ul>
                                  <li data-value="1-1"><a href="#">사이트1</a></li>
                                  <li data-value="1-2"><a href="#">사이트2</a></li>
                                  <li data-value="1-3"><a href="#">사이트3</a></li>
                              </ul>
                          </li>
                          <li data-value="2">
                              <a href="#">그룹2</a>
                              <ul>
                                  <li data-value="2-1"><a href="#">사이트1</a></li>
                                  <li data-value="2-2"><a href="#">사이트2</a></li>
                                  <li data-value="2-3"><a href="#">사이트3</a></li>
                              </ul>
                          </li>
                          <li data-value="3">
                              <a href="#">그룹3</a>
                              <ul>
                                  <li data-value="3-1"><a href="#">사이트1</a></li>
                                  <li data-value="3-2"><a href="#">사이트2</a></li>
                                  <li data-value="3-3"><a href="#">사이트3</a></li>
                              </ul>
                          </li> -->
                      </ul>
                  </div>
  --%>
  <ul class="nav_right">
    <li>
      <span>CURRENT TIME</span> <em id="currTime">${nowTime}<!-- 2018-07-27 17:10:05 --></em>
    </li>
    <li class="member clear">
      <div class="fl"><img src="../img/m_member_pic.png" alt=""></div>
      <div class="fr">
        <span class="myinfo">
        <c:choose>
          <c:when test="${not empty userInfo and not empty userInfo.psn_name}">${userInfo.psn_name}</c:when>
          <c:when test="${not empty userInfo and empty userInfo.psn_name}">${userInfo.user_id}</c:when>
          <c:otherwise>Not logined</c:otherwise>
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
  </ul>
</nav>

<script type="text/javascript">
  $(function () {
    refreshCurrTime();

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
    // console.log(data);

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
        location.href = '/siteMain?siteId=' + ui.item.value;
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

  // 현재 시간 갱신
  function refreshCurrTime() {
    var currEm = $('#currTime');
    var now = new Date();
    currEm.text(now.format('yyyy-MM-dd HH:mm:ss'));
    setTimeout(refreshCurrTime, 1000); // 매초 갱신
  }

  //PV 대시보드 로고 변경
  if (window.location.pathname === "/pvMain") {
    $('.nav_brand').removeClass("ewp");
  }
</script>
