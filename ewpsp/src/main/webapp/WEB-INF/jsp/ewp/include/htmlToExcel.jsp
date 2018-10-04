<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
response.setHeader("Context-Type", "application/vnd.ms-excel");
response.setHeader("Context-Disposition", "attachment; filename=aaa.xls");
response.setHeader("Context-Description", "excel download");
// response.setHeader("Cache-Control", "private"); 
%>
${excelHtml }
