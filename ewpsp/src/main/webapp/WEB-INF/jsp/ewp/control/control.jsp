<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
// 	var deviceGbn = "${deviceGbn }";
// 	$(document).ready(function() {
// 		// js파일에서는 동작을 안함
// 		$(".tab_menu").find("li").removeClass("active");
// 		$(".tab_menu").find("#tab_${deviceGbn }").addClass("active").trigger('click');
// 		getDBData(deviceGbn);
// 	});
</script>
<script src="../js/control/control.js" type="text/javascript"></script>
</head>
<body>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="control" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">상황관제</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv control clear">

							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="control" name="schGbn"/>
							</jsp:include>
							<div class="c_board">
								<ul>
									<li class="ioe">
										<div class="fl">
											IOE(건)
										</div>
										<div class="fr"><span id="ioeAlarmCnt">0</span></div>
									</li>
									<li class="pcs">
										<div class="fl">
											PCS(건)
										</div>
										<div class="fr"><span id="pcsAlarmCnt">0</span></div>
									</li>
									<li class="bms">
										<div class="fl">
											BMS(건)
										</div>
										<div class="fr"><span id="bmsAlarmCnt">0</span></div>
									</li>
									<li class="pv">
										<div class="fl">
											PV(건)
										</div>
										<div class="fr"><span id="pvAlarmCnt">0</span></div>
									</li>
									<li class="etc">
										<div class="fl">
											기타(건)
										</div>
										<div class="fr"><span id="etcAlarmCnt">0</span></div>
									</li>
								</ul>
							</div>
							<div class="c_tbl_wrap">
								<div class="a_alarm default_tbl">
									<h2>비상 알람 현황 (<span id="warnAlarmCnt">2</span>)</h2>
									<div class="tbl_box">
										<table>
											<colgroup>
												<col>
												<col>
												<col>
												<col>
												<col>
												<col>
												<col>
												<col>
											</colgroup>
											<thead>
												<tr>
													<th>장치타입</th>
													<th>장치명</th>
													<th>장치ID</th>
													<th>알람시간</th>
													<th>알람타입</th>
													<th>알람메세지</th>
													<th>알람상태</th>
													<th>조치여부</th>
												</tr>
											</thead>
											<tbody id="warnAlarmTbody">
												<tr>
													<td>BMS</td>
													<td>BMS_1</td>
													<td>12001</td>
													<td>2018.07.15 16:01:02</td>
													<td>FALU</td>
													<td>Over cell Voltage</td>
													<td>발생</td>
													<td>미조치</td>
												</tr>
												<tr>
													<td>BMS</td>
													<td>BMS_1</td>
													<td>12001</td>
													<td>2018.07.15 16:01:02</td>
													<td>FALU</td>
													<td>Over cell Voltage</td>
													<td>발생</td>
													<td>미조치</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="paging clear" id="WarningAlarmPaging">
										<a href="#;" class="prev">PREV</a>
										<span><strong>1</strong> / 3</span>
										<a href="#;" class="next">NEXT</a>
									</div>						
								</div>
								<div class="n_alarm default_tbl">
									<h2>주의 알람 현황 (<span id="alertAlarmCnt">3</span>)</h2>
									<div class="tbl_box">
										<table>
											<colgroup>
												<col>
												<col>
												<col>
												<col>
												<col>
												<col>
												<col>
												<col>
											</colgroup>
											<thead>
												<tr>
													<th>장치타입</th>
													<th>장치명</th>
													<th>장치ID</th>
													<th>알람시간</th>
													<th>알람타입</th>
													<th>알람메세지</th>
													<th>알람상태</th>
													<th>조치여부</th>
												</tr>
											</thead>
											<tbody id="alertAlarmTbody">
												<tr>
													<td>BMS</td>
													<td>BMS_1</td>
													<td>12001</td>
													<td>2018.07.15 16:01:02</td>
													<td>FALU</td>
													<td>Over cell Voltage</td>
													<td>발생</td>
													<td>미조치</td>
												</tr>
												<tr>
													<td>BMS</td>
													<td>BMS_1</td>
													<td>12001</td>
													<td>2018.07.15 16:01:02</td>
													<td>FALU</td>
													<td>Over cell Voltage</td>
													<td>발생</td>
													<td>미조치</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="paging clear" id="AlertAlarmPaging">
										<a href="#;" class="prev">PREV</a>
										<span><strong>1</strong> / 3</span>
										<a href="#;" class="next">NEXT</a>
									</div>						
								</div>
							</div>
							<div class="clear mt30">
								<a href="javascript:popupOpen('rpeople');" class="fr default_btn"><i class="glyphicon glyphicon-phone"></i> 알람전송 관리</a>
							</div>

						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




    <!-- ###### 알람전송 관리 Popup Start ###### -->
    <div id="layerbox" class="rpeople" style="min-width:600px;">
        <div class="stit">
        	<h2>알람전송 관리</h2>        	
			<a href="javascript:popupClose('rpeople');">닫기</a>
        </div>
		<div class="lbody mt30">
			<h2 class="ctit mt20">알람 수신자</h2>
			<div class="company_list mt10">				
				<table>
					<colgroup>
						<col width="50">
						<col>
						<col>
						<col width="50">
					</colgroup>
					<thead>
						<tr>
							<th>No</th>
							<th>이름</th>
							<th>연락처</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>2</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>3</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>4</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>1</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>2</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>3</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>4</td>
							<td>홍길동</td>
							<td>010-1234-1234</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
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
								<th><span>이름</span></th>
								<td>
									<select name="" id="" class="sel" style="width:100%;">
										<option value="">홍길동</option>
										<option value="">홍길동</option>
										<option value="">홍길동</option>
										<option value="">홍길동</option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span>연락처</span></th>
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
    </div>
    <!-- ###### Popup End ###### --> 


    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>






</body>
</html>