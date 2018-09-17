<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	var deviceGbn = "${deviceGbn }";
// 	$(document).ready(function() {
// 		// js파일에서는 동작을 안함
// 		$(".tab_menu").find("li").removeClass("active");
// 		$(".tab_menu").find("#tab_${deviceGbn }").addClass("active").trigger('click');
// 		getDBData(deviceGbn);
// 	});
</script>
<!-- <script src="../js/device/deviceMonitoring.js" type="text/javascript"></script> -->
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
							<div class="chart_top clear">
								<h2 class="ntit fl">알림현황</h2>
								<div class="dropdown fl">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">1일(오늘)
									<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li class="on"><a href="#">1일(오늘)</a></li>
										<li><a href="#">1주(이번주)</a></li>
										<li><a href="#">1월(이번달)</a></li>
										<li><a href="#">1년(올해)</a></li>
									</ul>
								</div>	
								<div class="sel_calendar fr">
									<input type="text" id="datepicker1" class="sel" value="">
									<span>-</span>
									<input type="text" id="datepicker2" class="sel" value="">
									<button type="submit">조회</button>
								</div>						
							</div>
							<div class="c_board">
								<ul>
									<li class="ioe">
										<div class="fl">
											IOE(건)
										</div>
										<div class="fr"><span>0</span></div>
									</li>
									<li class="pcs">
										<div class="fl">
											PCS(건)
										</div>
										<div class="fr"><span>1</span></div>
									</li>
									<li class="bms">
										<div class="fl">
											BMS(건)
										</div>
										<div class="fr"><span>1</span></div>
									</li>
									<li class="pv">
										<div class="fl">
											PV(건)
										</div>
										<div class="fr"><span>0</span></div>
									</li>
									<li class="etc">
										<div class="fl">
											기타(건)
										</div>
										<div class="fr"><span>0</span></div>
									</li>
								</ul>
							</div>
							<div class="c_tbl_wrap">
								<div class="a_alarm default_tbl">
									<h2>비상 알람 현황 (<span>2</span>)</h2>
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
											<tbody>
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
								</div>
								<div class="n_alarm default_tbl">
									<h2>주의 알람 현황 (<span>3</span>)</h2>
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
											<tbody>
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
								</div>
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
			<a href="javascript:popupClose('ddevice');">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<table>
					<colgroup>
						<col width="200">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>배치사이트</span></th>
							<td>
								<select name="" id="" class="sel" style="width:100%">
									
								</select>
							</td>
						</tr>
						<tr>
							<th><span>장치명</span></th>
							<td><input type="text" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>장치ID</span></th>
							<td><input type="text" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>장치타입</span></th>
							<td>
								<select name="" id="" class="sel" style="width:100%">
									
								</select>
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

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>





</body>
</html>