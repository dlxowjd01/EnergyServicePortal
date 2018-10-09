<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	var deviceGbn = "${deviceGbn }";
	$(document).ready(function() {
		// js파일에서는 동작을 안함
		$(".tab_menu").find("li").removeClass("active");
		$(".tab_menu").find("#tab_${deviceGbn }").addClass("active").trigger('click');
		getDBData(deviceGbn);
	});
</script>
<script src="../js/device/deviceMonitoring.js" type="text/javascript"></script>
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
										<!-- <li><a href="#;" class="save_btn">데이터저장</a></li> -->
										<li><a href="#;" class="save_btn" onclick="deviceExcelDownload('장치모니터링', event, 'device');">데이터저장</a></li>
									</ul>
								</div>
							</div>
							<div class="table_info">
								<ul class="tblDisplay">
									<li>
										<div class="default_tbl" id="deviceIOEDiv">
											<table>
												<colgroup>
													<col width="100"><col><col><col><col><col><col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Site ID</th>
														<th>Device Name</th>
														<th>Device ID</th>
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
											<a href="#;" class="prev">PREV</a>
											<span><strong>1</strong> / 3</span>
											<a href="#;" class="next">NEXT</a>
										</div>	
									</li>
									<li>
										<div class="default_tbl" id="devicePCSDiv">
											<table>
												<colgroup>
													<col width="100"><col><col><col><col><col><col><col><col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Site ID</th>
														<th>Device Name</th>
														<th>Device ID</th>
														<th>PCS Status</th>
														<th>C/D Status</th>
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
											<a href="#;" class="prev">PREV</a>
											<span><strong>1</strong> / 3</span>
											<a href="#;" class="next">NEXT</a>
										</div>	
									</li>
									<li>
										<div class="default_tbl" id="deviceBMSDiv">
											<table>
												<colgroup>
													<col width="100"><col><col><col><col><col><col><col><col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Site ID</th>
														<th>Device Name</th>
														<th>Device ID</th>
														<th>BMS Status</th>
														<th>C/D Status</th>
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
											<a href="#;" class="prev">PREV</a>
											<span><strong>1</strong> / 3</span>
											<a href="#;" class="next">NEXT</a>
										</div>	
									</li>
									<li>
										<div class="default_tbl" id="devicePVDiv">
											<table>
												<colgroup>
													<col width="100"><col><col><col><col><col><col><col><col width="100">
												</colgroup>
												<thead>
													<tr>
														<th>No.</th>
														<th>Site ID</th>
														<th>Device Name</th>
														<th>Device ID</th>
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
											<a href="#;" class="prev">PREV</a>
											<span><strong>1</strong> / 3</span>
											<a href="#;" class="next">NEXT</a>
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




    <!-- ###### 상세보기 Popup Start ###### -->
    <!-- IOE -->
    <div id="layerbox" class="dview dview_ioe">
        <div class="ltit">
        	<h2>
        		<span class="ioe"></span>
        		IOE_1
        		<p>2018-08-12 11:41:26</p>
        	</h2>        	
			<a href="javascript:popupClose('dview_ioe');">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd>41331</dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>별관_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd>제일화성</dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd>10037202</dd>
        	</dl>
        </div>
        <div class="lbody">
	        <div class="lstat mt20">
	        	<div class="dt">연결상태</div>
	        	<div class="dd"><span class="run">Connected</span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
					랙 전압 불균형이 감지되었습니다. 신속한 처리를 해주시길 바랍니다.
	        	</div>
	        </div>
        </div>
    </div>

    <!-- PCS -->
    <div id="layerbox" class="dview dview_pcs">
        <div class="ltit">
        	<h2>
        		<span class="pcs"></span>
        		PCS_1
        		<p>2018-08-12 11:41:26</p>
        	</h2>        	
			<a href="javascript:popupClose('dview_pcs');">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd>41331</dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>별관_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd>제일화성</dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd>10037202</dd>
        	</dl>
        </div>
        <div class="lbody">
	        <div class="lstat mt20">
	        	<div class="dt">운전상태</div>
	        	<div class="dd"><span class="run">Run</span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
					랙 전압 불균형이 감지되었습니다. 신속한 처리를 해주시길 바랍니다.
	        	</div>
	        </div>	        
	        <h2 class="tbl_tit">AC 출력</h2>
	        <div class="ltbl">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>전압(V)</th>
	        				<th>전력(kW)</th>
	        				<th>주파수(Hz)</th>
	        				<th>전류(A)</th>
	        				<th>역률(PF)</th>
	        				<th>전력설정치(kWh)</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td>366.2</td>
	        				<td>59.7</td>
	        				<td>59.7</td>
	        				<td>1.1</td>
	        				<td>1.0</td>
	        				<td>486.0</td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
	        <h2 class="tbl_tit">DC 출력</h2>
	        <div class="ltbl">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>전압(V)</th>
	        				<th>전력(kW)</th>
	        				<th>주파수(Hz)</th>
	        				<th>전류(A)</th>
	        				<th>역률(PF)</th>
	        				<th>전력설정치(kWh)</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td>366.2</td>
	        				<td>59.7</td>
	        				<td>59.7</td>
	        				<td>1.1</td>
	        				<td>1.0</td>
	        				<td>486.0</td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
	    </div>
    </div>

    <!-- BMS -->
    <div id="layerbox" class="dview dview_bms">
        <div class="ltit">
        	<h2>
        		<span class="bms"></span>
        		BMS_1
        		<p>2018-08-12 11:41:26</p>
        	</h2>        	
			<a href="javascript:popupClose('dview_bms');">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd>41331</dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>별관_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd>제일화성</dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd>10037202</dd>
        	</dl>
        </div>
        <div class="lbody">
	        <div class="lstat mt20">
	        	<div class="dt">운전상태</div>
	        	<div class="dd"><span class="run">Run</span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
					랙 전압 불균형이 감지되었습니다. 신속한 처리를 해주시길 바랍니다.
	        	</div>
	        </div>		        
	        <h2 class="tbl_tit">충/방전 상태: <span style="color:#438fd7;font-weight:normal;">충전중</span></h2>
	        <div class="ltbl">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>SOC(%)</th>
	        				<th>SOC 최대(kWh)</th>
	        				<th>SOH(%)</th>
	        				<th>SOC 현재(kWh)</th>
	        				<th>SOC 최소(kWh)</th>
	        				<th>출력 전압(V)</th>
	        				<th>출력 전류(V)</th>
	        				<th>Dod(%)</th>
	        				<th>C-rate(C)</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td>80.0</td>
	        				<td>90.0</td>
	        				<td>59.7</td>
	        				<td>50.0</td>
	        				<td>10.0</td>
	        				<td>384.0</td>
	        				<td>1.6</td>
	        				<td>80.0</td>
	        				<td>33.0</td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
        </div>
    </div>  

    <!-- PV -->
    <div id="layerbox" class="dview dview_pv">
        <div class="ltit">
        	<h2>
        		<span class="bms"></span>
        		PV_1
        		<p>2018-08-12 11:41:26</p>
        	</h2>        	
			<a href="javascript:popupClose('dview_pv');">닫기</a>
        </div>
        <div class="ltop">
        	<dl>
        		<dt>Device ID</dt>
				<dd>41331</dd>
        	</dl>
        	<dl>
        		<dt>Device Group</dt>
				<dd>별관_1</dd>
        	</dl>
        	<dl>
        		<dt>Site Name</dt>
				<dd>제일화성</dd>
        	</dl>
        	<dl>
        		<dt>Site ID</dt>
				<dd>10037202</dd>
        	</dl>
        </div>
        <div class="lbody">
	        <div class="lstat mt20">
	        	<div class="dt">PV 상태</div>
	        	<div class="dd"><span class="run">Run</span></div>
	        </div>
	        <div class="lstat">
	        	<div class="dt">알람 메시지</div>
	        	<div class="dd">
					랙 전압 불균형이 감지되었습니다. 신속한 처리를 해주시길 바랍니다.
	        	</div>
	        </div>		        
	        <div class="ltbl mt30">        	
	        	<table>
	        		<thead>
	        			<tr>
	        				<th>온도</th>
	        				<th>오늘 예측 발전량</th>
	        				<th>수평 일사량</th>
	        				<th>오늘 누적 발전량</th>
	        				<th>경사 일사량</th>
	        			</tr>
	        		</thead>
	        		<tbody>
	        			<tr>
	        				<td>51℃</td>
	        				<td>600 kWh</td>
	        				<td>251 W/m²</td>
	        				<td>580 kWh</td>
	        				<td>206 W/m²</td>
	        			</tr>
	        		</tbody>
	        	</table>
	        </div>
        </div>
    </div>       
    <!-- ###### Popup End ###### -->

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>





</body>
</html>