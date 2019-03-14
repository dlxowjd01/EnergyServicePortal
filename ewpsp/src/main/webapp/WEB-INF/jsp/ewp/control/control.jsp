<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<%-- <jsp:include page="../include/sub_static.jsp" /> --%>
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
									<h2>비상 알람 현황 (<span id="warnAlarmCnt">0</span>)</h2>
									<div class="tbl_box">
										<table>
											<colgroup>
												<col>
												<col>
												<col>
												<col>
												<col>
												<!-- <col> -->
												<col>
												<col>
											</colgroup>
											<thead>
												<tr>
													<th>장치타입</th>
													<th>장치명</th>
													<th>장치ID</th>
													<th>알람시간</th>													
													<th>알람메세지</th>
													<!-- <th>알람상태</th> -->
													<th>조치여부</th>
													<th>조치내용</th>
												</tr>
											</thead>
											<tbody id="warnAlarmTbody">
												<tr><td colspan="8">조회된 데이터가 없습니다.</td><tr>
											</tbody>
										</table>
									</div>
									<div class="paging clear" id="WarningAlarmPaging">
									</div>						
								</div>
								<div class="n_alarm default_tbl">
									<h2>주의 알람 현황 (<span id="alertAlarmCnt">0</span>)</h2>
									<div class="tbl_box">
										<table>
											<colgroup>
												<col>
												<col>
												<col>
												<col>
												<col>
												<!-- <col> -->
												<col>
												<col>
											</colgroup>
											<thead>
												<tr>
													<th>장치타입</th>
													<th>장치명</th>
													<th>장치ID</th>
													<th>알람시간</th>
													<th>알람메세지</th>
													<!-- <th>알람상태</th> -->
													<th>조치여부</th>
													<th>조치내용</th>
												</tr>
											</thead>
											<tbody id="alertAlarmTbody">
												<tr><td colspan="8">조회된 데이터가 없습니다.</td><tr>
											</tbody>
										</table>
									</div>
									<div class="paging clear" id="AlertAlarmPaging">
									</div>						
								</div>
							</div>
							<div class="clear mt30">
								<a href="javascript:popupOpen('rpeople');" class="fr default_btn" id="smsSendMngBtn"><i class="glyphicon glyphicon-phone"></i> 알람전송 관리</a>
								<!-- <a href="javascript:alarmTest;" class="fr default_btn" id="smsSendMngBtn"><i class="glyphicon glyphicon-phone"></i> 알람전송 테스트</a> -->
							</div>

						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>


    <!-- ###### 조치여부/내용 관리 Popup Start ###### -->
    <div id="layerbox" class="rmanage" style="min-width:600px;">
        <div class="stit">
        	<h2>조치여부/내용 관리</h2>        	
			<a href="javascript:popupClose('rmanage');">닫기</a>
        </div>
		<div class="lbody mt30">
			<h2 class="ctit" id="updtAlarmDvId">BMS_1(12001)<!-- 장치명(장치ID) --></h2>
			<div class="set_tbl mt10 clear">				
				<form id="updtAlarmForm" name="updtAlarmForm">
				<div class="fl" style="width:calc(100% - 120px);">
				<input type="hidden" id="alarmIdx" name="alarmIdx">
					<table>
						<colgroup>
							<col width="100">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>조치여부</span></th>
								<td>
									<select name="alarmActYn" id="alarmActYn" class="sel" style="width:100%;">
										<option value="Y">조치</option>
										<option value="N">미조치</option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span>조치내용</span></th>
								<td><input type="text" id="alarmNote" name="alarmNote" class="input" style="width:100%"></td>
							</tr>
						</tbody>			
					</table>
				</div>
				</form>
				<div class="fr">
					<input type="button" value="적용하기" class="submit" id="updateAlarmBtn">
				</div>
			</div>

		</div>
    </div>
    <!-- ###### Popup End ###### --> 

    <!-- ###### 알람전송 관리 Popup Start ###### -->
    <div id="layerbox" class="rpeople" style="min-width:600px;">
        <div class="stit">
        	<h2>알람전송 관리</h2>        	
			<a href="#;" id="cancelSmsSendMngBtnX">닫기</a>
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
					<tbody id="smsSendMngTbody">
						<tr>
							<td colspan="4">사이트를 선택해주세요</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="set_tbl mt10 clear">
				<div class="fl" style="width:calc(100% - 120px);">
					<form id="insertSmsForm" name="insertSmsForm">
					<table>
						<colgroup>
							<col width="150">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>이름</span></th>
								<td>
									<select name="selAddresseeName" id="selAddresseeName" class="sel" style="width:100%;">
										<option value="">--선택--</option>
										<option value="홍길동">홍길동</option>
										<option value="김철수">김철수</option>
										<option value="이영희">이영희</option>
										<option value="가나다">가나다</option>
										<option value="etc">직접입력</option>
									</select><br>
									<input type="text" id="addresseeName" name="addresseeName" class="input" style="width:100%; display: none;">
								</td>
							</tr>
							<tr>
								<th><span>연락처</span></th>
								<td><input type="text" id="mobile" name="mobile" class="input" style="width:100%" placeholder="'-'를 제외한 연락처 입력" maxlength="11" onkeydown="onlyNum(event);"></td>
							</tr>
						</tbody>			
					</table>
					</form>
				</div>
				<div class="fr">
					<input type="button" value="추가하기" class="submit" id="insertSmsBtn">
				</div>
			</div>

		</div>
    </div>
    <!-- ###### Popup End ###### --> 








</body>
</html>