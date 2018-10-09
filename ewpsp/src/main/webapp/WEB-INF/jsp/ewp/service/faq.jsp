<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<!-- <script src="../js/setup/kepcoMngSet.js" type="text/javascript"></script> -->
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
									<input type="text" id="search" name="search" placeholder="궁금하신 점을 검색해 보세요.">
									<input type="image" src="../img/search.png">
								</div>
							</div>
							<div class="faq_table mt30">
								<div class="cate">
									<a href="#;" class="on">전체</a>
									<c:forEach var="item" items="${faqCateList}">
									<a href="#;" onclick="changeFAQCate(this, '${item.faq_cate_idx}')">${item.faq_cate_name}</a>
									</c:forEach>
								</div>
								<ul class="faq_list mt15">
									<c:forEach var="item" items="${faqList}">
									<li>
										<a href="#;" class="question">
											<span class="gubun">${item.faq_cate_name }</span>
											<span class="sbj">
												${item.question }
											</span>
										</a>
										<div class="answer">
								            ${item.answer }
											<div class="edit_btn mt15 fr">
												<c:if test="${not empty userInfo and (userInfo.auth_type eq '1' or  userInfo.auth_type eq '2')}">
												<a href="#;"><i class="glyphicon glyphicon-edit"></i></a>
												<a href="#;"><i class="glyphicon glyphicon-remove"></i></a>
												</c:if>
											</div>
								        </div>
									</li>
									</c:forEach>
								</ul>
							</div>
							<c:if test="${not empty userInfo and (userInfo.auth_type eq '1' or  userInfo.auth_type eq '2')}">
							<div class="faq_bottom mt30 clear">
								<a href="javascript:popupOpen('faqedit');" class="default_btn fr"><i class="glyphicon glyphicon-plus"></i> 글쓰기</a>
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
				<table>
					<colgroup>
						<col width="100">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>카테고리</span></th>
							<td class="clear">
								<select name="faqCateName" id="faqCateName" class="sel">
									<option value="">선택</option>
									<c:forEach var="item" items="${faqCateList}">
									<option value="${item.faq_cate_idx}">${item.faq_cate_name }</option>
									</c:forEach>
								</select>
								<a href="javascript:popupOpen('category_edit');" class="default_btn fr"><i class="glyphicon glyphicon-edit"></i> 카테고리 편집</a>
							</td>
						</tr>
						<tr>
							<th><span>질문</span></th>
							<td><input type="text" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>답변</span></th>
							<td>
								<textarea name="" id="" style="width:100%" class="textarea" rows="10"></textarea>
							</td>
						</tr>
					</tbody>			
				</table>
			</div>
		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80">확인</a>
			<a href="#;" class="cancel_btn w80">취소</a>
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
					<tbody>
						<tr>
							<td>1</td>
							<td>서비스관련</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>2</td>
							<td>기타</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>3</td>
							<td>로그인/회원</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>4</td>
							<td>오류관련</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="set_tbl mt10 clear">
				<div class="fl" style="width:calc(100% - 120px);">
					<table>
						<colgroup>
							<col width="120">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>카테고리명</span></th>
								<td><input type="text" class="input" style="width:100%"></td>
							</tr>
						</tbody>			
					</table>
				</div>
				<div class="fr">
					<input type="submit" value="추가하기" class="submit">
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80">확인</a>
			<a href="#;" class="cancel_btn w80">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### --> 


    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>





</body>
</html>