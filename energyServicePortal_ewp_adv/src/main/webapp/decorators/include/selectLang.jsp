<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<div class="lang dropdown"><!--
--><button type="button" class="dropdown-toggle" data-toggle="dropdown">${sessionScope.sessionLangNm}<span class="caret"></span></button><!--
--><ul class="dropdown-menu"><!--
	--><li><a href="javascript:addParameterUrl('lang', 'ko');">KO</a></li><!--
	--><li><a href="javascript:addParameterUrl('lang', 'en');">EN</a></li><!--
--></ul>
</div>
