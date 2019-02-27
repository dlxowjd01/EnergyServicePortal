<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	var deviceGbn = "${deviceGbn }";
	var dvSiteId = "${selViewSiteId }";
	$(document).ready(function() {
		// js파일에서는 동작을 안함
		$(".tab_menu").find("li").removeClass("active");
		$(".tab_menu").find("#tab_${deviceGbn }").addClass("active").trigger('click');
		getDBData(deviceGbn);
	});
</script>
<script src="../js/device/deviceMonitoring.js" type="text/javascript"></script>
<script src="../js/device/deviceDetailPopup.js" type="text/javascript"></script>
</head>
<body>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="device" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">장치 모니터링 현황</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv page-device clear">
							<div class="chart_top clear">
								<h2 class="ntit fl">${selViewSite.site_name }</h2>
								<div class="time fr" id="updtTime">2018-08-12 11:41:26</div>
							</div>
							<div class="tbl_top mt20 clear">
								<div class="clear fr">
									<ul class="tab_menu fl">
										<li class="active" id="tab_IOE"><a href="javascript:getDeviceIOEList(1);">IOE</a></li>
										<li id="tab_PCS"><a href="javascript:getDevicePCSList(1);">PCS</a></li>
										<li id="tab_BMS"><a href="javascript:getDeviceBMSList(1);">BMS</a></li>
										<li id="tab_PV"><a href="javascript:getDevicePVList(1);">PV</a></li>									
									</ul>
									<ul class="button_area fl">
										<li><a href="#;" class="save_btn" onclick="deviceExcelDownload('장치모니터링', event, 'device');">데이터저장</a></li>
									</ul>
								</div>
							</div>
							<div class="table_info">
								<ul class="tblDisplay">
									<!-- IOE -->
									<li>
										<div class="default_tbl" id="deviceIOEDiv">
											<table>
												<colgroup>
													<col width="100">
													<col>
													<col>
													<col>
													<col>
													<col>
													<col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Device Name</th>
														<th>Device ID</th>
														<th>Device Type</th>
														<th>Status</th>
														<th>Status Time</th>
														<th>View</th>
													</tr>
												</thead>
												<tbody id="ioeTbody">
													<tr>
														<td colspan="6">조회된 데이터가 없습니다.</td>
													</tr>
												</tbody>
											</table>				
										</div>
										<div class="paging clear" id="DeviceIOEPaging">
										</div>	
									</li>
									<!-- PCS -->
									<li>
										<div class="default_tbl" id="devicePCSDiv">
											<table>
												<colgroup>
													<col width="100">
													<col>
													<col>
													<col>
													<col>
													<col>
													<col>
													<col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Device Name</th>
														<th>Device ID</th>
														<th>Device Type</th>
														<th>PCS Status</th>
														<th>PCS Message</th>
														<th>Status Time</th>
														<th>View</th>
													</tr>
												</thead>
												<tbody id="pcsTbody">
													<tr>
														<td colspan="8">조회된 데이터가 없습니다.</td>
													</tr>
												</tbody>
											</table>				
										</div>
										<div class="paging clear" id="DevicePCSPaging">
										</div>	
									</li>
									<!-- BMS -->
									<li>
										<div class="default_tbl" id="deviceBMSDiv">
											<table>
												<colgroup>
													<col width="100">
													<col>
													<col>
													<col>
													<col>
													<col>
													<col>
													<col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Device Name</th>
														<th>Device ID</th>
														<th>Device Type</th>
														<th>BMS Status</th>
														<th>BMS Message</th>
														<th>Status Time</th>
														<th>View</th>
													</tr>
												</thead>
												<tbody id="bmsTbody">
													<tr>
														<td colspan="8">조회된 데이터가 없습니다.</td>
													</tr>
												</tbody>
											</table>				
										</div>
										<div class="paging clear" id="DeviceBMSPaging">
										</div>	
									</li>
									<!-- PV -->
									<li>
										<div class="default_tbl" id="devicePVDiv">
											<table>
												<colgroup>
													<col width="100">
													<col>
													<col>
													<col>
													<col>
													<col>
													<col>
													<col>
													<col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Device Name</th>
														<th>Device ID</th>
														<th>Device Type</th>
														<th>PV Status</th>
														<th>Temperature</th>
														<th>PV Message</th>
														<th>Status Time</th>
														<th>View</th>
													</tr>
												</thead>
												<tbody id="pvTbody">
													<tr>
														<td colspan="8">조회된 데이터가 없습니다.</td>
													</tr>
												</tbody>
											</table>				
										</div>
										<div class="paging clear" id="DevicePVPaging">
										</div>	
									</li>
								</ul>
							</div>														
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




<jsp:include page="../include/popup/deviceDetailPopup.jsp" />






</body>
</html>