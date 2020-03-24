<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	$(document).ready(function () {
		navAddClass("alarm");
		changeSelTerm('day');
		settingSelTerm();
		getDBData();
	});

	$(function () {
		$("#searchBtn").click(function () {
			settingSelTerm();
			getDBData();
		});

		$("#smsSendMngBtn").click(function () {
			getSmsAddresseeList(); // 알람 수신자 목록 조회
			getInsertAddresseeNameList(); // 알람 수신자 등록가능 이름 목록 조회

			popupOpen('rpeople');
		});

		$('#selAddresseeName').change(function () {
			var addressee = $(this).val();
			if (addressee == "etc") {
				$('#addresseeName').show();
				$('#addresseeName').val("");
			} else {
				$('#addresseeName').hide();
				$('#addresseeName').val(addressee);
			}
		});

		$("#insertSmsBtn").click(function () {
			var addressee = $('#addresseeName').val();
			if (addressee == "" || addressee == null) {
				alert("이름을 입력해주세요");
				return;
			}

			if ($('#mobile').val() == "" || $('#mobile').val() == null) {
				alert("연락처를 입력해주세요");
				return;
			}

			if (confirm("저장하시겠습니까?")) {
				var formData = $("#insertSmsForm").serializeObject();
				insertAddressee(formData);
			}
		});

		$("#cancelSmsSendMngBtnX").click(function () {
			popupClose('rpeople');

			$('#insertSmsForm').each(function () {
				this.reset();
			});

			$('#addresseeName').val("");
			$('#addresseeName').hide();
			$("#smsSendMngTbody").empty().append('<tr><td colspan="4">조회 결과가 없습니다.</td><tr>');

		});

		$("#updateAlarmBtn").click(function () {
			if (confirm("저장하시겠습니까?")) {
				var formData = $("#updtAlarmForm").serializeObject();
				updateAlarm(formData);
			}

		});

	});

	function getDBData() {
		getDeviceAlarmCnt(); // 장치구분별 알람건수
		getWarningAlarmList(1); // 비상 알람 목록 조회
		getAlertAlarmList(1); // 주의 알람 목록 조회

	}

	// 장치구분별 알람건수
	function getDeviceAlarmCnt() {
		var formData = $("#schForm").serializeObject();

		$.ajax({
			url: "/alarm/getDeviceAlarmCnt.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				var dvTpAlarmDetail = result.detail;

				if (dvTpAlarmDetail != null) {
					$("#ioeAlarmCnt").empty().append(dvTpAlarmDetail.ioe_cnt);
					$("#pcsAlarmCnt").empty().append(dvTpAlarmDetail.pcs_cnt);
					$("#bmsAlarmCnt").empty().append(dvTpAlarmDetail.bms_cnt);
					$("#pvAlarmCnt").empty().append(dvTpAlarmDetail.pv_cnt);
					$("#etcAlarmCnt").empty().append(dvTpAlarmDetail.etc_cnt);
				}
			}
		});
	}

	// 비상 알람 목록 조회
	var selPageNumWarnAlarm = 1;

	function getWarningAlarmList(selPageNum) {
		$("#selPageNum").val(selPageNum);
		selPageNumWarnAlarm = selPageNum;
		var formData = $("#schForm").serializeObject();

		$.ajax({
			url: "/alarm/getWarningAlarmList.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				var warnAlarmList = result.list;

				$tbody = $("#warnAlarmTbody");
				$tbody.empty();
				if (warnAlarmList == null || warnAlarmList.length < 1) {
					$tbody.append('<tr><td colspan="8">조회 결과가 없습니다.</td></tr>');
					$('#WarningAlarmPaging').empty();
				} else {
					for (var i = 0; i < warnAlarmList.length; i++) {
						var tm = new Date(convertDateUTC(warnAlarmList[i].std_date));
						var strHtml = "";
						var alarmActTxt = "";
						var alarmActClass = "";
						if (warnAlarmList[i].alarm_act_yn == "N") {
							alarmActTxt = "미조치";
							alarmActClass = "cancel_btn";
						} else {
							alarmActTxt = "조치";
							alarmActClass = "default_btn";
						}
						strHtml += '<a href="#;" onclick="updateAlarmActForm(\'' + warnAlarmList[i].device_name;
						strHtml += '\', \'' + ((warnAlarmList[i].alarm_msg == null) ? '' : warnAlarmList[i].alarm_msg);
						strHtml += '\', \'' + warnAlarmList[i].alarm_act_yn;
						strHtml += '\', \'' + ((warnAlarmList[i].alarm_note == null) ? '' : warnAlarmList[i].alarm_note);
						strHtml += '\', \'' + warnAlarmList[i].alarm_idx;
						strHtml += '\');" class="w80 ' + alarmActClass + '">' + alarmActTxt + '</a>';

						$tbody.append(
							$('<tr />').append($('<td />').append(warnAlarmList[i].device_type_nm) // 장치타입
							).append($('<td />').append(warnAlarmList[i].device_name) // 장치명
							).append($('<td />').append(warnAlarmList[i].device_id) // 장치ID
							).append($('<td />').append(tm.format("yyyy-MM-dd HH:mm:ss")) // 알람시간
							).append($('<td />').append(warnAlarmList[i].alarm_msg) // 알람메세지
							).append( // 조치여부
								$('<td />').append(strHtml)
							).append( // 조치내용
								$('<td class="ellipsis mxw200" />').append(warnAlarmList[i].alarm_note)
							)
						);
					}

					var pagingMap = result.pagingMap;
					makePageNums2(pagingMap, "WarningAlarm");

					$("#warnAlarmCnt").empty().append(pagingMap.listCnt);
				}
			}
		});
	}

	// 주의 알람 목록 조회
	var selPageNumAlertAlarm = 1;

	function getAlertAlarmList(selPageNum) {
		$("#selPageNum").val(selPageNum);
		selPageNumAlertAlarm = selPageNum;
		var formData = $("#schForm").serializeObject();

		$.ajax({
			url: "/alarm/getAlertAlarmList.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				var alertAlarmList = result.list;

				$tbody = $("#alertAlarmTbody");
				$tbody.empty();
				if (alertAlarmList == null || alertAlarmList.length < 1) {
					$tbody.append('<tr><td colspan="8">조회 결과가 없습니다.</td><tr>');
					$('#AlertAlarmPaging').empty();
				} else {
					for (var i = 0; i < alertAlarmList.length; i++) {
						var tm = new Date(convertDateUTC(alertAlarmList[i].std_date));
						var strHtml = "";
						var alarmActTxt = "";
						var alarmActClass = "";
						if (alertAlarmList[i].alarm_act_yn == "N") {
							alarmActTxt = "미조치";
							alarmActClass = "cancel_btn";
						} else {
							alarmActTxt = "조치";
							alarmActClass = "default_btn";
						}
						strHtml += '<a href="#;" onclick="updateAlarmActForm(\'' + alertAlarmList[i].device_name;
						strHtml += '\', \'' + ((alertAlarmList[i].alarm_msg == null) ? '' : alertAlarmList[i].alarm_msg);
						strHtml += '\', \'' + alertAlarmList[i].alarm_act_yn;
						strHtml += '\', \'' + ((alertAlarmList[i].alarm_note == null) ? '' : alertAlarmList[i].alarm_note);
						strHtml += '\', \'' + alertAlarmList[i].alarm_idx;
						strHtml += '\');" class="w80 ' + alarmActClass + '">' + alarmActTxt + '</a>';

						$tbody.append(
							$('<tr />').append($('<td />').append(alertAlarmList[i].device_type_nm) // 장치타입
							).append($('<td />').append(alertAlarmList[i].device_name) // 장치명
							).append($('<td />').append(alertAlarmList[i].device_id) // 장치ID
							).append($('<td />').append(tm.format("yyyy-MM-dd HH:mm:ss")) // 알람시간
							).append($('<td />').append(alertAlarmList[i].alarm_msg) // 알람메세지
								//					).append( $('<td />').append( alarmCfmYn ) // 알람상태(뭘 의미하는거지??)
							).append( // 조치여부
								$('<td />').append(strHtml)
							).append( // 조치내용
								$('<td class="ellipsis mxw200" />').append(alertAlarmList[i].alarm_note)
							)
						);
					}

					var pagingMap = result.pagingMap;
					makePageNums2(pagingMap, "AlertAlarm");

					$("#alertAlarmCnt").empty().append(pagingMap.listCnt);
				}
			}
		});
	}

	// 알람 수신자 목록 조회
	function getSmsAddresseeList() {
		$.ajax({
			url: "/alarm/getSmsAddresseeList.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			//		data : {
			//			selPageNum : ""
			//		},
			success: function (result) {
				var addresseeList = result.list;

				$tbody = $("#smsSendMngTbody");
				$tbody.empty();
				if (addresseeList == null || addresseeList.length < 1) {
					$tbody.append('<tr><td colspan="4">조회 결과가 없습니다.</td><tr>');
				} else {
					for (var i = 0; i < addresseeList.length; i++) {
						$tbody.append(
							$('<tr />').append(
								$("<td />").append((i + 1))
							).append($("<td />").append(addresseeList[i].addressee_name)
							).append(
								$("<td />").append(addresseeList[i].mobile)
							).append(
								$("<td />").append('<a href="#;" onclick="deleteAddresseeYn(\'' + addresseeList[i].sms_user_idx + '\');"><i class="glyphicon glyphicon-remove"></i></a>')
							)
						);
					}

				}
			}
		});

	}

	// 알람 수신자 등록가능 이름 목록 조회
	function getInsertAddresseeNameList() {
		$.ajax({
			url: "/alarm/getInsertAddresseeNameList.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			success: function (result) {
				var list = result.list;

				$selectBox = $("#selAddresseeName");
				$selectBox.empty();
				$selectBox.append('<option value="">---이름선택---</option>');
				for (var i = 0; i < list.length; i++) {
					var name = (list[i].psn_name == null || list[i].psn_name == "") ? "" : list[i].psn_name;
					$selectBox.append('<option value="' + name + '">' + name + '</option>');
				}
				$selectBox.append('<option value="etc">직접입력</option>');

			}
		});

		$("#selAddresseeName option:eq(0)").prop("selected", true);

	}

	function insertAddressee(formData) {
		$.ajax({
			url: "/alarm/insertAddressee.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				var resultCnt = result.resultCnt;
				if (resultCnt > 0) {
					alert("저장되었습니다.");

					$('#addresseeName').val("");
					$('#addresseeName').hide();
					getSmsAddresseeList(); // 알람 수신자 목록 조회
					getInsertAddresseeNameList(); // 알람 수신자 등록가능 이름 목록 조회

					$("#mobile").val("");

				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n 관리자에게 문의하세요.");
			}
		});
	}

	function deleteAddresseeYn(smsUserIdx) {
		if (confirm("삭제하시겠습니까?")) {
			$.ajax({
				url: "/alarm/deleteAddressee.json",
				type: 'post',
				async: false, // 동기로 처리해줌
				data: {
					smsUserIdx: smsUserIdx
				},
				success: function (result) {
					var resultCnt = result.resultCnt;
					if (resultCnt > 0) {
						alert("삭제되었습니다.");

						$('#addresseeName').val("");
						$('#addresseeName').hide();
						getSmsAddresseeList(); // 알람 수신자 목록 조회
						getInsertAddresseeNameList(); // 알람 수신자 등록가능 이름 목록 조회

						$("#mobile").val("");

					} else {
						alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
					}
				},
				error: function (request, status, error) {
					alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
				}
			});
		}
	}

	function updateAlarmActForm(deviceName, alarmMsg, alarmActYn, alarmNote, alarmIdx) {
		$("#alarmIdx").val(alarmIdx);
		$("#updtAlarmDvId").text(deviceName + " : " + alarmMsg);
		$("#alarmActYn").val(alarmActYn);
		$("#alarmNote").val(alarmNote);

		popupOpen('rmanage');
	}

	function updateAlarm(formData) {
		$.ajax({
			url: "/alarm/updateAlarm.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				var resultCnt = result.resultCnt;
				if (resultCnt > 0) {
					alert("저장되었습니다.");

					popupClose('rmanage');
					getWarningAlarmList(selPageNumWarnAlarm);
					getAlertAlarmList(selPageNumAlertAlarm);

				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			}
		});
	}
</script>
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">상황관제(알람)</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv control clear">

							<c:set var="schGbn" value="alarm" />
							<%@ include file="/decorators/include/searchRequirement.jsp"%>
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
												<tr>
													<td colspan="8">조회된 데이터가 없습니다.</td>
												<tr>
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
												<tr>
													<td colspan="8">조회된 데이터가 없습니다.</td>
												<tr>
											</tbody>
										</table>
									</div>
									<div class="paging clear" id="AlertAlarmPaging">
									</div>
								</div>
							</div>
							<div class="clear mt30">
								<a href="javascript:popupOpen('rpeople');" class="fr default_btn" id="smsSendMngBtn"><i class="glyphicon glyphicon-phone"></i> 알람전송 관리</a>
							</div>

						</div>
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
										<select name="selAddresseeName" id="selAddresseeName" class="sel"
												style="width:100%;">
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