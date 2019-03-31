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
	
	var excelCnt = 0;
	var selectDeviceGbn = "";
	function getDBData(deviceGbn) {
		if(deviceGbn == "IOE") getDeviceIOEList(1); // 장치목록 조회(IOE)
		else if(deviceGbn == "PCS") getDevicePCSList(1); // 장치목록 조회(PCS)
		else if(deviceGbn == "BMS") getDeviceBMSList(1); // 장치목록 조회(BMS)
		else if(deviceGbn == "PV") getDevicePVList(1); // 장치목록 조회(PV)
		
		var today = new Date();
		update_updtDataTime(today); // 검색시간(차트 새로고침시간) 업데이트
	}
	
	// 장치목록 조회(IOE)
	function callback_getDeviceIOEList(result) {
		var ioeList = result.list;
		
		$tbody = $("#ioeTbody");
		var tbodyStr = '';
		if(ioeList != null && ioeList.length > 0) {
			for(var i=0; i<ioeList.length; i++) {
				tbodyStr += '<tr>';
				tbodyStr += '<td>'+ioeList[i].rnum+'</td>';
				tbodyStr += '<td>'+ioeList[i].device_name+'</td>';
				tbodyStr += '<td>'+ioeList[i].device_id+'</td>';
				tbodyStr += '<td>'+ioeList[i].device_type_nm+'</td>';
				tbodyStr += '<td>'+ioeList[i].device_stat_name+'</td>';
				tbodyStr += '<td>'+( (ioeList[i].upload_timestamp == null) ? '' : new Date( setSheetDateUTC(ioeList[i].upload_timestamp) ).format("yyyy-MM-dd HH:mm:ss") )+'</td>';
				tbodyStr += '<td>'+'<a href="#;" onclick="getDeviceIOEDetail(\''+ioeList[i].site_id+"\', \'"+ioeList[i].device_id+"\', \'"+ioeList[i].device_type+'\');" class="detail_view">상세보기</a>'+'</td>';
				tbodyStr += '</tr>';
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DeviceIOE");
			
			excelCnt = ioeList.length;
			selectDeviceGbn = "IOE";
			
		} else {
			tbodyStr += '<tr><td colspan="6">조회 결과가 없습니다.</td><tr>';
			$('#DeviceIOEPaging').empty();
			excelCnt = 0;
		}
		
		$("#ioeTbody").html(tbodyStr);
	}
//	function callback_getDeviceIOEList(result) {
//		var ioeList = result.list;
//		
//		$tbody = $("#ioeTbody");
//		$tbody.empty();
//		if(ioeList == null || ioeList.length < 1) {
//			$tbody.append( '<tr><td colspan="6">조회 결과가 없습니다.</td><tr>' );
//			$('#DeviceIOEPaging').empty();
//			excelCnt = 0;
//		} else {
//			for(var i=0; i<ioeList.length; i++) {
//				$tbody.append(
//						$('<tr />').append( $("<td />").append( ioeList[i].rnum )
//						).append( $("<td />").append( ioeList[i].device_name )
//						).append( $("<td />").append( ioeList[i].device_id )
//						).append( $("<td />").append( ioeList[i].device_type_nm )
//						).append( $("<td />").append( ioeList[i].device_stat_name )
//						).append( $("<td />").append( (ioeList[i].upload_timestamp == null) ? '' : new Date( setSheetDateUTC(ioeList[i].upload_timestamp) ).format("yyyy-MM-dd HH:mm:ss") )
//						).append(
//								$("<td />").append( '<a href="#;" onclick="getDeviceIOEDetail(\''+ioeList[i].site_id+"\', \'"+ioeList[i].device_id+"\', \'"+ioeList[i].device_type+'\');" class="detail_view">상세보기</a>' )
//						)
//				);
//			}
//			
//			var pagingMap = result.pagingMap;
//			makePageNums2(pagingMap, "DeviceIOE");
//			
//			excelCnt = ioeList.length;
//			selectDeviceGbn = "IOE";
//			
//		}
//		
//	}
	
	// 장치목록 조회(PCS)
	function callback_getDevicePCSList(result) {
		var pcsList = result.list;

		$tbody = $("#pcsTbody");
		$tbody.empty();
		if(pcsList == null || pcsList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
			$('#DevicePCSPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<pcsList.length; i++) {
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pcs\')" />').append( $("<td />").append( pcsList[i].rnum )
						).append( $('<td />').append( pcsList[i].device_name )
						).append( $('<td />').append( pcsList[i].device_id )
						).append( $('<td />').append( pcsList[i].device_type_nm )
						).append( $('<td />').append( pcsList[i].pcs_status_name )
						).append( $('<td class="ellipsis mxw400" />').append( pcsList[i].alarm_msg )
						).append( $('<td />').append( (pcsList[i].std_date == null) ? '' : new Date( setSheetDateUTC(pcsList[i].std_date) ).format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDevicePCSDetail(\''+pcsList[i].site_id+"\', \'"+pcsList[i].device_id+"\', \'"+pcsList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DevicePCS");
			
			excelCnt = pcsList.length;
			selectDeviceGbn = "PCS";
			
		}
		
	}
//	function callback_getDevicePCSList(result) {
//		var pcsList = result.list;
//		
//		$tbody = $("#pcsTbody");
//		$tbody.empty();
//		if(pcsList == null || pcsList.length < 1) {
//			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
//			$('#DevicePCSPaging').empty();
//			excelCnt = 0;
//		} else {
//			for(var i=0; i<pcsList.length; i++) {
//				$tbody.append(
//						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pcs\')" />').append( $("<td />").append( pcsList[i].rnum )
//						).append( $('<td />').append( pcsList[i].device_name )
//						).append( $('<td />').append( pcsList[i].device_id )
//						).append( $('<td />').append( pcsList[i].device_type_nm )
//						).append( $('<td />').append( pcsList[i].pcs_status_name )
//						).append( $('<td class="ellipsis mxw400" />').append( pcsList[i].alarm_msg )
//						).append( $('<td />').append( (pcsList[i].std_date == null) ? '' : new Date( setSheetDateUTC(pcsList[i].std_date) ).format("yyyy-MM-dd HH:mm:ss") )
//						).append(
//								$("<td />").append( '<a href="#;" onclick="getDevicePCSDetail(\''+pcsList[i].site_id+"\', \'"+pcsList[i].device_id+"\', \'"+pcsList[i].device_type+'\');" class="detail_view">상세보기</a>' )
//						)
//				);
//			}
//			
//			var pagingMap = result.pagingMap;
//			makePageNums2(pagingMap, "DevicePCS");
//			
//			excelCnt = pcsList.length;
//			selectDeviceGbn = "PCS";
//			
//		}
//		
//	}
	
	// 장치목록 조회(BMS)
	function callback_getDeviceBMSList(result) {
		var bmsList = result.list;
		
		$tbody = $("#bmsTbody");
		$tbody.empty();
		if(bmsList == null || bmsList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
			$('#DeviceBMSPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<bmsList.length; i++) {
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/bat\')" />').append( $("<td />").append( bmsList[i].rnum )
						).append( $('<td />').append( bmsList[i].device_name )
						).append( $('<td />').append( bmsList[i].device_id )
						).append( $('<td />').append( bmsList[i].device_type_nm )
						).append( $('<td />').append( bmsList[i].device_stat_name )
						).append( $('<td class="ellipsis mxw400" />').append( bmsList[i].alarm_msg )
						).append( $('<td />').append( (bmsList[i].std_date == null) ? '' : new Date( setSheetDateUTC(bmsList[i].std_date) ).format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDeviceBMSDetail(\''+bmsList[i].site_id+"\', \'"+bmsList[i].device_id+"\', \'"+bmsList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DeviceBMS");
			
			excelCnt = bmsList.length;
			selectDeviceGbn = "BMS";
			
		}
		
	}
//	function callback_getDeviceBMSList(result) {
//		var bmsList = result.list;
//		
//		$tbody = $("#bmsTbody");
//		$tbody.empty();
//		if(bmsList == null || bmsList.length < 1) {
//			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
//			$('#DeviceBMSPaging').empty();
//			excelCnt = 0;
//		} else {
//			for(var i=0; i<bmsList.length; i++) {
//				$tbody.append(
//						$('<tr ondblclick="goLEMSPage(\'/lems/setting/bat\')" />').append( $("<td />").append( bmsList[i].rnum )
//						).append( $('<td />').append( bmsList[i].device_name )
//						).append( $('<td />').append( bmsList[i].device_id )
//						).append( $('<td />').append( bmsList[i].device_type_nm )
//						).append( $('<td />').append( bmsList[i].device_stat_name )
//						).append( $('<td class="ellipsis mxw400" />').append( bmsList[i].alarm_msg )
//						).append( $('<td />').append( (bmsList[i].std_date == null) ? '' : new Date( setSheetDateUTC(bmsList[i].std_date) ).format("yyyy-MM-dd HH:mm:ss") )
//						).append(
//								$("<td />").append( '<a href="#;" onclick="getDeviceBMSDetail(\''+bmsList[i].site_id+"\', \'"+bmsList[i].device_id+"\', \'"+bmsList[i].device_type+'\');" class="detail_view">상세보기</a>' )
//						)
//				);
//			}
//			
//			var pagingMap = result.pagingMap;
//			makePageNums2(pagingMap, "DeviceBMS");
//			
//			excelCnt = bmsList.length;
//			selectDeviceGbn = "BMS";
//			
//		}
//		
//	}
	
	// 장치목록 조회(PV)
	function callback_getDevicePVList(result) {
		var pvList = result.list;
		
		$tbody = $("#pvTbody");
		$tbody.empty();
		if(pvList == null || pvList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
			$('#DevicePVPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<pvList.length; i++) {
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pv\')" />').append( $("<td />").append( pvList[i].rnum )
						).append( $('<td />').append( pvList[i].device_name )
						).append( $('<td />').append( pvList[i].device_id )
						).append( $('<td />').append( pvList[i].device_type_nm )
						).append( $('<td />').append( pvList[i].device_stat_name )
						).append( $('<td />').append( pvList[i].temp )
						).append( $('<td class="ellipsis mxw400" />').append( pvList[i].alarm_msg )
						).append( $('<td />').append( (pvList[i].std_date == null) ? '' : new Date( setSheetDateUTC(pvList[i].std_date) ).format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDevicePVDetail(\''+pvList[i].site_id+"\', \'"+pvList[i].device_id+"\', \'"+pvList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DevicePV");
			
			excelCnt = pvList.length;
			selectDeviceGbn = "PV";
			
		}
		
	}
//	function callback_getDevicePVList(result) {
//		var pvList = result.list;
//		
//		$tbody = $("#pvTbody");
//		$tbody.empty();
//		if(pvList == null || pvList.length < 1) {
//			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
//			$('#DevicePVPaging').empty();
//			excelCnt = 0;
//		} else {
//			for(var i=0; i<pvList.length; i++) {
//				$tbody.append(
//						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pv\')" />').append( $("<td />").append( pvList[i].rnum )
//						).append( $('<td />').append( pvList[i].device_name )
//						).append( $('<td />').append( pvList[i].device_id )
//						).append( $('<td />').append( pvList[i].device_type_nm )
//						).append( $('<td />').append( pvList[i].device_stat_name )
//						).append( $('<td />').append( pvList[i].temp )
//						).append( $('<td class="ellipsis mxw400" />').append( pvList[i].alarm_msg )
//						).append( $('<td />').append( (pvList[i].std_date == null) ? '' : new Date( setSheetDateUTC(pvList[i].std_date) ).format("yyyy-MM-dd HH:mm:ss") )
//						).append(
//								$("<td />").append( '<a href="#;" onclick="getDevicePVDetail(\''+pvList[i].site_id+"\', \'"+pvList[i].device_id+"\', \'"+pvList[i].device_type+'\');" class="detail_view">상세보기</a>' )
//						)
//				);
//			}
//			
//			var pagingMap = result.pagingMap;
//			makePageNums2(pagingMap, "DevicePV");
//			
//			excelCnt = pvList.length;
//			selectDeviceGbn = "PV";
//			
//		}
//		
//	}
	
</script>
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