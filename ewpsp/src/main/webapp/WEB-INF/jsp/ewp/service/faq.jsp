<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/service/faq.js" type="text/javascript"></script>
</head>
<body>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="setup" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">자주하는 질문</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv faq">
							<div class="search_box">
								<div class="infield">
									<form id="schForm" name="schForm">
										<input type="text" id="search" name="search" placeholder="궁금하신 점을 검색해 보세요.">
										<input type="image" src="../img/search.png" onclick="getDBData(); return false;">
									</form>
								</div>
							</div>
							<div class="faq_table mt30">
								<div class="cate" id="cateList">
									<a href="#;" onclick="changeFAQCate(this, '')" class="on">전체</a>
									<c:forEach var="item" items="${faqCateList}">
									<a href="#;" onclick="changeFAQCate(this, '${item.faq_cate_idx}')">${item.faq_cate_name}</a>
									</c:forEach>
								</div>
								<ul class="faq_list mt15" id="faqList">
<!--
									<li>
										<a href="#;" class="question">
											<span class="gubun">로그인/회원</span>
											<span class="sbj">
												본인 확인제를 관리, 감독하는 기관은 어디인가요?
											</span>
										</a>
										<div class="answer">
								            본인 확인제를 관리, 감독하는 기관은<br/>
											정보통신부에서 게시판 이용자의 본인확인제에 대한 전반적인 사항에 대해 관리 및 감독을 수행합니다.
											<div class="edit_btn mt15 fr">
												<a href="#;"><i class="glyphicon glyphicon-edit"></i></a>
												<a href="#;"><i class="glyphicon glyphicon-remove"></i></a>
											</div>
								        </div>
									</li>
-->
								</ul>
							</div>
							<c:if test="${not empty userInfo and userInfo.auth_type eq '1'}">
							<div class="faq_bottom mt30 clear">
								<a href="#;" class="default_btn fr" id="insertFAQFormBtn"><i class="glyphicon glyphicon-plus"></i> 글쓰기</a>
							</div>
							</c:if>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




    <!-- ###### 게시물 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="faqedit" style="min-width:600px;">
        <div class="stit">
        	<h2>자주하는 질문 등록</h2>        	
			<a href="javascript:popupClose('faqedit');">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="set_tbl">
				<form id="faqForm" name="faqForm">
				<input type="hidden" id="faqIdx" name="faqIdx" />
				<table>
					<colgroup>
						<col width="100">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>카테고리</span></th>
							<td class="clear">
								<select name="faqCateIdx" id="faqCateIdx" class="sel">
									<option value="">선택</option>
								</select>
								<a href="#;" class="default_btn fr" id="insertFAQCateFormBtn"><i class="glyphicon glyphicon-edit"></i> 카테고리 편집</a>
							</td>
						</tr>
						<tr>
							<th><span>질문</span></th>
							<td><input type="text" id="question" name="question" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>답변</span></th>
							<td>
								<textarea id="answer" name="answer" style="width:100%" class="textarea" rows="10"></textarea>
							</td>
						</tr>
					</tbody>			
				</table>
				</form>
			</div>
		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmFAQBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelFAQBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->


    <!-- ###### 카테고리 편집 Popup Start ###### -->
    <div id="layerbox" class="category_edit" style="min-width:400px;">
        <div class="stit">
        	<h2>카테고리 편집</h2>        	
			<a href="javascript:popupClose('category_edit');">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="company_list mt10">				
				<table>
					<colgroup>
						<col width="50">
						<col>
						<col width="50">
					</colgroup>
					<thead>
						<tr>
							<th>No</th>
							<th>카테고리명</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody id="faqCateTBody">
<!--
						<tr>
							<td>1</td>
							<td>서비스관련</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
-->
					</tbody>
				</table>
			</div>
			<div class="set_tbl mt10 clear">
				<form id="faqCateForm" name="faqCateForm">
				<input type="hidden" id="faqCateIdx" name="faqCateIdx" />
				<div class="fl" style="width:calc(100% - 120px);">
					<table>
						<colgroup>
							<col width="120">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>카테고리명</span></th>
								<td><input type="text" id="faqCateName" name="faqCateName" class="input" style="width:100%"></td>
							</tr>
						</tbody>			
					</table>
				</div>
				<div class="fr">
					<input type="submit" id="confirmFAQCateBtn" value="추가하기" class="submit" onclick="return false">
				</div>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<!-- <a href="#;" class="default_btn w80" id="cancelFAQCateBtn">확인</a> -->
			<a href="#;" class="cancel_btn w80" id="cancelFAQCateBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### --> 


    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>





</body>
</html>