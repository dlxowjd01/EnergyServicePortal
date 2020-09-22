<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<form id="schForm" name="schForm">
  <input type="hidden" id="startTime" name="startTime"/>
  <input type="hidden" id="endTime" name="endTime"/>
  <input type="hidden" id="selTerm" name="selTerm" value="day"/>
  <input type="hidden" id="timeOffset" name="timeOffset"/>
  <input type="hidden" id="siteId" name="siteId"/>
  <input type="hidden" id="renewTypeCode" name="essTypeCode"/>
  <input type="hidden" id="period" name="period"/>
</form>
<script type="text/javascript">
  function getSiteMainSchCollection(termType) { //api에 맞게 수정필요
    //	$("#timeOffset").val( (new Date()).getTimezoneOffset() );
    $("#timeOffset").val(timeOffset);
    
    // 기간 필터
    const today = new Date();
    let startDate, endDate, lastDay = "";
    if(termType === 'hour'){
      startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), 0, 0);
      endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), 59, 59);
      $("#selTerm").val("hour");
    } else if (termType === 'day') {
      // 오늘 00시 ~ 오늘 23시 59분
      // 데이터가 비어도 오늘 치는 다 나오므로 괜찮을 듯.
      startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0);
      endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 23, 59, 59);
      $("#selTerm").val("day");
    } else if( termType === 'yesterday'){
      startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()-1, 0, 0, 0);
      endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()-1, 23, 59, 59);
      $("#selTerm").val("day");
    } else if( termType === 'beforeTwo'){
      startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()-2, 0, 0, 0);
      endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()-2, 23, 59, 59);
      $("#selTerm").val("day");
    } else if (termType === 'week') {
      // 시간 정보 000000 한 다음에 findWeek에서 연월일 가져와서 설정
      const weekSub = (today.getDay() === 0) ? 6 : today.getDay() - 1;
      const weekPls = (today.getDay() === 0) ? 0 : 7 - today.getDay();
      startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() - weekSub);
      endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + weekPls, 23, 59, 59);
      $("#selTerm").val("week");
    } else if (termType === 'month') {
      // 이번달 1일 000000 부터
      startDate = new Date(today.getFullYear(), today.getMonth(), 1);
      lastDay = (new Date(today.getFullYear(), today.getMonth() + 1, 0)).getDate();
      endDate = new Date(today.getFullYear(), today.getMonth(), lastDay, 23, 59, 59);
      $("#selTerm").val("month");
    } else if (termType === 'beforeMonth') {
      // 이번달 1일 000000 부터
      startDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
      lastDay = (new Date(today.getFullYear(), today.getMonth(), 0)).getDate();
      endDate = new Date(today.getFullYear(), today.getMonth() - 1, lastDay, 23, 59, 59);
      $("#selTerm").val("beforeMonth");
    } else if (termType === 'year') {
      // 이번년 1일 000000 부터
      startDate = new Date(today.getFullYear(), 0, 1);
      endDate = new Date(today.getFullYear(), 11, 31, 23, 59, 59);
      $("#selTerm").val("year");
    } else if (termType === 'beforeYear') {
      // 이번년 1일 000000 부터
      startDate = new Date(today.getFullYear() - 1, 0, 1);
      endDate = new Date(today.getFullYear() - 1, 11, 31, 23, 59, 59);
      $("#selTerm").val("beforeYear");
    } else if (termType === 'beforeYearSameMonth') {
      // 이번년 1일 000000 부터
      startDate = new Date(today.getFullYear() - 1, today.getMonth(), 1);
      endDate = new Date(today.getFullYear() - 1, today.getMonth(), 31, 23, 59, 59);
      $("#selTerm").val("beforeYearSameMonth");
    }
    
    startDate = startDate.format("yyyyMMddHHmmss");
    endDate = endDate.format("yyyyMMddHHmmss");
    
    $("#startTime").val(startDate);
    $("#endTime").val(endDate);
    
    return $("#schForm").serializeObject();
  }
</script>