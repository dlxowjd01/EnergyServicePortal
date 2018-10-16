<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
</script>
<script src="../js/device/deviceGroup.js" type="text/javascript"></script>
</head>
<body>

	<!-- 장치 모니터링 현황용 스크립트 -->
    <script src="../js/jquery.bxslider.js" type="text/javascript"></script>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="device" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">장치 그룹 현황</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv device_group clear">
							<div class="dg_top clear">
								<h2 class="ntit fl">${selViewSite.site_name }</h2>
								<div class="clear fr">
									<ul class="fl">
										<li><a href="#;" class="default_btn" id="grpMngFormBtn"><i class="glyphicon glyphicon-th-list"></i> 장치그룹관리</a></li>
									</ul>
								</div>
							</div>
							<div class="dg_wrap">
							</div>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




    <!-- ###### 신규장치 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="ddevice" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 장치 등록</h2>        	
			<a href="#;" id="cancelDeviceBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="insertDeviceForm" name="insertDeviceForm">
				<input type="hidden" name="deviceGrpIdx" id="deviceGrpIdx" class="input" value="">
				<table>
					<colgroup>
						<col width="200">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>사이트</span></th>
							<td>
								<select name="siteId" id="siteId" class="sel" style="width:100%">
									
								</select>
							</td>
						</tr>
						<tr>
							<th><span>장치명</span></th>
							<td><input type="text" id="deviceName" name="deviceName" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>장치ID</span></th>
							<td><input type="text" id="deviceId" name="deviceId" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>장치타입</span></th>
							<td>
								<select name="deviceType" id="deviceType" class="sel" style="width:100%">
									<option value="1">PCS</option>
									<option value="2">BMS</option>
									<option value="3">PV</option>
									<option value="4">부하측정기기</option>
									<option value="5">PV모니터링기기</option>
									<option value="6">ESS모니터링기기</option>
								</select>
							</td>
						</tr>
					</tbody>			
				</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmDeviceBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelDeviceBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->  

    <!-- ###### 장치그룹관리 Popup Start ###### -->
    <div id="layerbox" class="dgdevice" style="min-width:800px;">
        <div class="stit">
        	<h2>장치 그룹 추가/제거</h2>        	
			<a href="#;" id="cancelDvInDbGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="dgset_top clear">
				<h2 class="ntit fl">사이트</h2>
				<div class="dropdown fl" id="insideSite">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">사이트 선택
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
				<h2 class="ntit fl">장치 그룹</h2>
				<div class="dropdown fl" id="insideDeviceGrp">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">장치그룹 선택
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
				<a href="#;" class="default_btn fr" id="editDvGrpFormBtn"><i class="glyphicon glyphicon-edit"></i> 장치그룹편집</a>
			</div>
			<div class="group_wrap clear">
				<form id="editDvInDvGrpForm" name="editDvInDvGrpForm">
				<input type="hidden" id="selSiteId" name="selSiteId">
				<input type="hidden" id="selDvGrpIdx" name="selDvGrpIdx">
				<input type="hidden" id="nowDeviceIds" name="nowDeviceIds">
				<input type="hidden" id="newDeviceIds" name="newDeviceIds">
				<div class="inside_site fl">
					<h2 class="ntit">그룹에 포함된 장치</h2>
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
					<h2 class="ntit">사이트 내 장치</h2>
					<div class="inbox">
						<ul class="multi_select">
						</ul>
					</div>
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmDvInDbGrpBtn">적용</a>
			<a href="#;" class="cancel_btn w80" id="cancelDvInDbGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->  

    <!-- ###### 장치그룹편집 Popup Start ###### -->
    <div id="layerbox" class="dgdevice_edit" style="min-width:600px;">
        <div class="stit">
        	<h2>장치 그룹 편집</h2>        	
			<a href="#;" id="cancelDvGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="clear">
				<h2 class="ntit fl">사이트</h2>
				<div class="dropdown fl ml20" id="insideSite2">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">사이트 선택
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
			</div>
			<h2 class="ctit mt20">전체 장치그룹</h2>
			<form id="editDvGrpForm" name="editDvGrpForm">
			<input type="hidden" id="selectSiteId" name="selectSiteId">
			<input type="hidden" id="nowDvGrpIds" name="nowDvGrpIds">
			<input type="hidden" id="newDvGrpIds" name="newDvGrpIds">
			<input type="hidden" id="newDvGrpNms" name="newDvGrpNms">
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
							<th>장치그룹명</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody id="dvGrpTbody">
						<tr>
							<td colspan="3">사이트를 선택해주세요</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="set_tbl mt10 clear">
				<div class="fl" style="width:calc(100% - 120px);">
					<table>
						<colgroup>
							<col width="150">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>장치그룹명</span></th>
								<td><input type="text" id="deviceGrpName" name="deviceGrpName" class="input" style="width:100%"></td>
							</tr>
						</tbody>			
					</table>
				</div>
				<div class="fr">
					<input type="button" id="addDvGrpTbodyBtn" value="추가하기" class="submit">
				</div>
			</div>
			</form>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmDvGrpBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelDvGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### --> 


    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>





</body>
</html>