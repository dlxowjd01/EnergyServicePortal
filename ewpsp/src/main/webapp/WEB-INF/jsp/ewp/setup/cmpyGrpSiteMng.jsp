<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/setup/cmpyGrpSiteMng.js" type="text/javascript"></script>
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
						<h1 class="page-header">그룹/사이트 관리</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv">
							<c:if test="${userInfo.auth_type eq '1'}">
							<div class="section" id="cmpyDiv">
								<div class="set_top clear">
									<h2 class="ntit fl">회사 현황</h2>
									<ul class="fr">
										<li><a href="#;" class="default_btn" id="insertCmpyFormBtn"><i class="glyphicon glyphicon-plus"></i> 회사 등록</a></li>
									</ul>								
								</div>
								<div class="s_table">
									<table>
										<colgroup>
											<col width="80">
											<col width="150">
											<col>
											<col width="150">
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>회사명</th>
												<th>회사ID</th>
												<th>관리</th>
											</tr>
										</thead>
										<tbody id="cmpyTbody">
											<tr>
												<td colspan="4">조회된 데이터가 없습니다.</td>
											</tr>
										</tbody>
									</table>
								</div>	
								<div class="paging clear" id="CmpyPaging">
								</div>	
							</div>								
							</c:if>
							<c:if test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2'}">
							<div class="section" id="grpDiv">
								<div class="set_top clear">
									<h2 class="ntit fl">그룹 현황</h2>
									<ul class="fr">
										<li><a href="#;" class="default_btn" id="grpMngFormBtn"><i class="glyphicon glyphicon-th-list"></i> 그룹 관리</a></li>
									</ul>								
								</div>
								<div class="s_table">
									<table>
										<colgroup>
											<col width="80">
											<col width="150">
											<col width="150">
											<col>
											<col width="150">
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>그룹명</th>
												<th>그룹ID</th>
												<th>고객사</th>
												<th>관리</th>
											</tr>
										</thead>
										<tbody id="grpTbody">
											<tr>
												<td colspan="5">조회된 데이터가 없습니다.</td>
											</tr>
										</tbody>
									</table>
								</div>	
								<div class="paging clear" id="GroupPaging">
								</div>	
							</div>								
							</c:if>
							<c:if test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2' or userInfo.auth_type eq '3'}">
							<div class="section" id="siteDiv">
								<div class="set_top clear">
									<h2 class="ntit fl">사이트 현황</h2>
									<ul class="fr">
										<li><a href="#;" class="default_btn" id="insertSiteFormBtn"><i class="glyphicon glyphicon-plus"></i> 사이트 등록</a></li>
									</ul>								
								</div>
								<div class="s_table">
									<table>
										<colgroup>
											<col width="80">
											<col width="150">
											<col width="150">
											<col width="150">
											<col>
											<col>
											<col width="150">
										</colgroup>
										<thead>
											<tr>
												<th>NO</th>
												<th>사이트명</th>
												<th>사이트ID</th>
												<th>그룹</th>
												<th>Local EMS 주소</th>
												<th>등록장치</th>
												<th>관리</th>
											</tr>
										</thead>
										<tbody id="siteTbody">
											<tr>
												<td colspan="7">조회된 데이터가 없습니다.</td>
											</tr>
										</tbody>
									</table>
								</div>	
								<div class="paging clear" id="SitePaging">
								</div>	
							</div>				
							</c:if>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>


    <!-- ###### 회사 관리 Popup Start ###### -->
    <div id="layerbox" class="dcompany" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 회사 등록</h2>        	
			<a href="#;" id="cancelCmpyBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl clear">
				<form id="cmpyForm" name="cmpyForm">
				<input type="hidden" name="compIdx" id="compIdx" class="input" value="">
				<table>
					<colgroup>
						<col width="100">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>회사명</span></th>
							<td><input type="text" name="compName" id="compName" class="input" style="width:100%" maxlength="20"></td>
						</tr>
						<tr>
							<th><span>회사ID</span></th>
							<td><input type="text" name="compId" id="compId" class="input" style="width:100%" maxlength="50"></td>
						</tr>
					</tbody>			
				</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmCmpyBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelCmpyBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- ###### 그룹관리 Popup Start ###### -->
    <div id="layerbox" class="dgroup" style="min-width:800px;">
        <div class="stit">
        	<h2>그룹 관리</h2>        	
			<a href="#;" id="cancelSiteInSiteGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="dgrp_top clear">
				<h2 class="ntit fl">그룹명</h2>
				<div class="dropdown fl" id="grpSelectBox">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selGrpBox">---그룹선택---
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
				<a href="#;" class="default_btn fr" id="insertGrpFormBtn"><i class="glyphicon glyphicon-plus"></i> 그룹 추가하기</a>
			</div>
			<div class="group_wrap clear">
				<form id="editSiteInSiteGrpForm" name="editSiteInSiteGrpForm">
				<!-- <input type="hidden" id="selSiteId" name="selSiteId"> -->
				<input type="hidden" id="selSiteGrpIdx1" name="selSiteGrpIdx1">
				<input type="hidden" id="nowSiteIds" name="nowSiteIds">
				<input type="hidden" id="newSiteIds" name="newSiteIds">
				<div class="inside_site fl">
					<h2 class="ntit">그룹 내 사이트</h2>
					<div class="inbox">
						<ul class="multi_select">
						</ul>
					</div>
				</div>
				</form>
				<div class="cross_btn fl">
					<div><a href="#;" id="moveLeft"><img src="../img/btn_cross_left.png" alt="<"></a></div>
					<div><a href="#;" id="moveRight"><img src="../img/btn_cross_right.png" alt=">"></a></div>
				</div>
				<div class="all_site fl">
					<h2 class="ntit">전체 사이트</h2>
					<div class="inbox">
						<ul class="multi_select">
						</ul>
					</div>
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="applySiteInSiteGrpBtn">적용</a>
			<a href="#;" class="default_btn w80" id="confirmSiteInSiteGrpBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelSiteInSiteGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->    

    <!-- ###### 그룹 추가하기 Popup Start ###### -->
    <div id="layerbox" class="dgroup_add" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 그룹 등록</h2>        	
			<a href="#;" id="cancelGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="groupForm" name="groupForm" method="post" enctype="multipart/form-data">
				<input type="hidden" name="siteGrpIdx" id="siteGrpIdx" class="input" value="">
				<input type="hidden" name="userIdx1" id="userIdx1" class="input" value="">
				<input type="hidden" name="fileChangeYn" id="fileChangeYn" class="input" value="N">
				<table>
					<colgroup>
						<col width="100">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>회사</span></th>
							<td>
								<select name="selCompIdx1" id="selCompIdx1" class="sel" style="width:100%">
								</select>
							</td>
						</tr>
						<tr>
							<th><span>그룹명</span></th>
							<td><input type="text" name="siteGrpName" id="siteGrpName" class="input" style="width:100%" maxlength="50" ></td>
						</tr>
						<tr>
							<th><span>그룹ID</span></th>
							<td><input type="text" name="siteGrpId" id="siteGrpId" class="input" style="width:100%" maxlength="20" ></td>
						</tr>
						<tr>
							<th><span>그룹 이미지</span></th>
							<td><input type="file" id="siteGrpImg" name="siteGrpImg">
								<!-- <span class="control-fileupload">
						            <label for="file" id="fileNameTag">Choose a file :</label>
						            <input type="file" id="siteGrpImg" name="siteGrpImg">
						        </span> -->
							</td>
						</tr>
					</tbody>			
				</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmGrpBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->      

    <!-- ###### 신규사이트 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="dsite" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 사이트 등록</h2>        	
			<a href="#;" id="cancelSiteBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="siteForm" name="siteForm">
				<input type="hidden" name="userIdx2" id="userIdx2" class="input" value="">
				<table>
					<colgroup>
						<col width="200">
						<col>
					</colgroup>
					<tbody>
						</tr>
						<tr>
							<th><span>사이트명</span></th>
							<td><input type="text" name="siteName" id="siteName" class="input" style="width:100%" maxlength="50"></td>
						</tr>
						<tr>
							<th><span>사이트ID</span></th>
							<td><input type="text" name="siteId" id="siteId" class="input" style="width:100%" maxlength="20"></td>
						</tr>
						<tr>
							<th><span>회사</span></th>
							<td>
								<select name="selCompIdx2" id="selCompIdx2" class="sel" style="width:100%" onchange="changeCmpy();">
								</select>
							</td>
						<tr>
							<th><span>지역</span></th>
							<td>
								<select name="areaType" id="areaType" class="sel" style="width:100%">
									<option value="">---지역선택---</option>
									<option value="01">서울</option>
									<option value="02">부산</option>
									<option value="03">대구</option>
									<option value="04">인천</option>
									<option value="05">광주</option>
									<option value="06">대전</option>
									<option value="07">울산</option>
									<option value="08">세종</option>
									<option value="09">경기</option>
									<option value="10">강원</option>
									<option value="11">충북</option>
									<option value="12">충남</option>
									<option value="13">전북</option>
									<option value="14">전남</option>
									<option value="15">경북</option>
									<option value="16">경남</option>
									<option value="17">제주</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span>그룹</span></th>
							<td>
								<select name="selSiteGrpIdx2" id="selSiteGrpIdx2" class="sel" style="width:100%">
								</select>
							</td>
						</tr>
						<tr>
							<th><span>Local EMS 주소</span></th>
							<td><input type="text" name="localEmsAddr" id="localEmsAddr" class="input" style="width:100%" maxlength="50"></td>
						</tr>
						<tr>
							<th><span>Local EMS 암호키</span></th>
							<td><input type="text" name="localEmsKey" id="localEmsKey" class="input" style="width:100%" maxlength="50"></td>
						</tr>
						<tr>
							<th><span>Local EMS 버전</span></th>
							<td>
								<select name="localEmsApiVer" id="localEmsApiVer" class="sel" style="width:100%">
									<option value="1.0">v1.0</option>
									<option value="1.1">v1.1</option>
									<option value="1.2">v1.2</option>
								</select>
							</td>
						</tr>
					</tbody>			
				</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmSiteBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelSiteBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

 




    
</body>
</html>