<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
						<h1 class="page-header">회사/그룹/사이트 관리</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv">
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
											<!-- <tr>
												<td>1</td>
												<td>제일화성</td>
												<td>10037202</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr>
											<tr>
												<td>2</td>
												<td>롯데 정밀 화학</td>
												<td>10037203</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr>
											<tr>
												<td>3</td>
												<td>문수경기장</td>
												<td>10037204</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr> -->
										</tbody>
									</table>
								</div>	
								<div class="paging clear" id="CmpyPaging">
									<a href="#;" class="prev">PREV</a>
									<span><strong>1</strong> / 3</span>
									<a href="#;" class="next">NEXT</a>
								</div>	
							</div>								
							<div class="section" id="grpDiv">
								<div class="set_top clear">
									<h2 class="ntit fl">그룹 현황</h2>
									<ul class="fr">
										<!-- <li><a href="javascript:popupOpen('dgroup');" class="default_btn"><i class="glyphicon glyphicon-th-list"></i> 그룹 관리</a></li> -->
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
											<!-- <tr>
												<td>1</td>
												<td>제일화성_1</td>
												<td>200372021</td>
												<td>제일화성</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr>
											<tr>
												<td>2</td>
												<td>제일화성_2</td>
												<td>200372021</td>
												<td>제일화성</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr>
											<tr>
												<td>3</td>
												<td>제일화성_3</td>
												<td>200372021</td>
												<td>제일화성</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr> -->
										</tbody>
									</table>
								</div>	
								<div class="paging clear" id="GroupPaging">
									<a href="#;" class="prev">PREV</a>
									<span><strong>1</strong> / 3</span>
									<a href="#;" class="next">NEXT</a>
								</div>	
							</div>								
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
											<!-- <tr>
												<td>1</td>
												<td>제일화성</td>
												<td>10037202</td>
												<td>그룹_1</td>
												<td></td>
												<td>PCS_1 PCS_2 BMS_1 BMS_2</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr>
											<tr>
												<td>2</td>
												<td>제일화성</td>
												<td>10037202</td>
												<td>그룹_1</td>
												<td></td>
												<td>PCS_3 PCS_4 BMS_3 BMS_4</td>
												<td>
													<a href="#;" class="default_btn">수정</a>
													<a href="#;" class="cancel_btn">삭제</a>
												</td>
											</tr> -->
										</tbody>
									</table>
								</div>	
								<div class="paging clear" id="SitePaging">
									<a href="#;" class="prev">PREV</a>
									<span><strong>1</strong> / 3</span>
									<a href="#;" class="next">NEXT</a>
								</div>	
							</div>				
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
			<a href="javascript:popupClose('dcompany');">닫기</a>
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
							<td><input type="text" name="compName" id="compName" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>회사ID</span></th>
							<td><input type="text" name="compId" id="compId" class="input" style="width:100%"></td>
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
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selGrpBox">롯데 정밀 화학
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				        <li class="on"><a href="#">롯데 정밀 화학</a></li>
				        <li><a href="#">....</a></li>
				        <li><a href="#">....</a></li>
				        <li><a href="#">....</a></li>
				    </ul>
				</div>
				<a href="#;" class="default_btn fr" id="insertGrpFormBtn"><i class="glyphicon glyphicon-plus"></i> 그룹 추가하기</a>
			</div>
			<div class="group_wrap clear">
				<form id="editSiteInSiteGrpForm" name="editSiteInSiteGrpForm">
				<!-- <input type="hidden" id="selSiteId" name="selSiteId"> -->
				<input type="hidden" id="selSiteGrpIdx" name="selSiteGrpIdx">
				<input type="hidden" id="nowSiteIds" name="nowSiteIds">
				<input type="hidden" id="newSiteIds" name="newSiteIds">
				<div class="inside_site fl">
					<h2 class="ntit">그룹 내 사이트</h2>
					<div class="inbox">
						<ul class="multi_select">
							<!-- <li><a href="#;">롯데_Site_01</a></li>
							<li><a href="#;">롯데_Site_02</a></li>
							<li><a href="#;">롯데_Site_03</a></li> -->
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
							<!-- <li><a href="#;">롯데_Site_01</a></li>
							<li><a href="#;">롯데_Site_02</a></li>
							<li><a href="#;">롯데_Site_03</a></li>
							<li><a href="#;">롯데_Site_04</a></li>
							<li><a href="#;">롯데_Site_05</a></li>
							<li><a href="#;">롯데_Site_06</a></li>
							<li><a href="#;">롯데_Site_07</a></li>
							<li><a href="#;">롯데_Site_08</a></li>
							<li><a href="#;">롯데_Site_09</a></li> -->
						</ul>
					</div>
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmSiteInSiteGrpBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelSiteInSiteGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->    

    <!-- ###### 그룹 추가하기 Popup Start ###### -->
    <div id="layerbox" class="dgroup_add" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 그룹 등록</h2>        	
			<!-- <a href="javascript:popupClose('dgroup_add');">닫기</a> -->
			<a href="javascript:popupColseChk();">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="groupForm" name="groupForm">
				<input type="hidden" name="siteGrpIdx" id="siteGrpIdx" class="input" value="">
				<input type="hidden" name="userIdx" id="userIdx" class="input" value="1">
				<table>
					<colgroup>
						<col width="100">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>그룹명</span></th>
							<td><input type="text" name="siteGrpName" id="siteGrpName" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>그룹ID</span></th>
							<td><input type="text" name="siteGrpId" id="siteGrpId" class="input" style="width:100%"></td>
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
			<a href="javascript:popupClose('dsite');">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="siteForm" name="siteForm">
				<input type="hidden" name="userIdx" id="userIdx" class="input" value="1">
				<table>
					<colgroup>
						<col width="200">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>사이트명</span></th>
							<td><input type="text" name="siteName" id="siteName" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>사이트ID</span></th>
							<td><input type="text" name="siteId" id="siteId" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>그룹</span></th>
							<td>
								<select name="siteGrpIdx" id="siteGrpIdx" class="sel" style="width:100%">
									
								</select>
							</td>
						</tr>
						<tr>
							<th><span>Local EMS 주소</span></th>
							<td><input type="text" name="localEmsAddr" id="localEmsAddr" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>Local EMS 암호키</span></th>
							<td><input type="text" name="localEmsKey" id="localEmsKey" class="input" style="width:100%"></td>
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

 

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>



    
</body>
</html>