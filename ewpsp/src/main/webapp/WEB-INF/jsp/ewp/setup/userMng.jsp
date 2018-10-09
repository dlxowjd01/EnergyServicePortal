<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/setup/userMng.js" type="text/javascript"></script>
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
						<h1 class="page-header">사용자 관리 설정</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="set_top clear">
								<a href="#;" class="adduser_btn fr" id="insertFormBtn"><i class="glyphicon glyphicon-user"></i> 사용자 추가하기</a>
							</div>
							<div class="s_table">
								<table>
									<colgroup>
										<col width="150">
										<col width="100">
										<col width="150">
										<col width="150">
										<col>
										<col width="150">
										<col width="150">
									</colgroup>
									<thead>
										<tr>
											<th>ID</th>
											<th>권한등급</th>
											<th>회사</th>
											<th>그룹</th>
											<th>설명</th>
											<th>등록일자</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody id="userTbody">
										<tr>
											<td colspan="7">조회된 데이터가 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>	
							<div class="paging clear" id="UserPaging">
							</div>						
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




    <!-- ###### 사용자 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="duser" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 사용자 등록</h2>        	
			<a href="javascript:popupClose('duser');">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="userForm" name="userForm">
				<input type="hidden" name="mainUserYn" id="mainUserYn" class="input" value="N">
				<input type="hidden" name="mainUserIdx" id="mainUserIdx" class="input" value="1">
				<input type="hidden" name="userIdx" id="userIdx" class="input" value="">
				<table>
					<colgroup>
						<col width="150">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>사용자ID</span></th>
							<td><input type="text" name="userId" id="userId" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>회사</span></th>
							<td>
								<select name="coIdx" id="coIdx" class="sel" style="width:100%">
									
								</select>
							</td>
						</tr>
						<tr>
							<th><span>그룹</span></th>
							<td>
								<select name="siteGrpIdx" id="siteGrpIdx" class="sel" style="width:100%">
									
								</select>
							</td>
						</tr>
						<tr>
							<th><span>사이트</span></th>
							<td>
								<select name="siteId" id="siteId" class="sel" style="width:100%">
									<option value=""></option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span>권한</span></th>
							<td>
								<select name="authType" id="authType" class="sel" style="width:100%">
									<option value="1">서비스 포털 관리자</option>
									<option value="2">고객사 관리자</option>
									<option value="3">그룹 관리자</option>
									<option value="4">사이트 관리자</option>
									<option value="5">사이트 이용자</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span>설명</span></th>
							<td>
								<textarea name="note" id="note" style="width:100%" class="textarea" rows="10"></textarea>
							</td>
						</tr>
					</tbody>			
				</table>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>



    
</body>
</html>