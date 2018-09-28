	$(document).ready(function() {
		changeSelTerm('day');
		
		$dtpk1 = $("#datepicker1");
		$dtpk2 = $("#datepicker2");
		$("#dtCnt").val("");
		if(SelTerm == "other") {
			$("#selTermFrom").val( ($dtpk1.val() == "") ? "" : new Date( $dtpk1.val()+" 00:00:00" ).format("yyyyMMddHHmmss") );
			$("#selTermTo").val( ($dtpk2.val() == "") ? "" : new Date( $dtpk2.val()+" 23:59:59" ).format("yyyyMMddHHmmss") );
			$("#dtCnt").val(  dateDiff($dtpk1.val()+" 00:00:00", $dtpk2.val()+" 23:59:59")+1  );
		}
		
		getDBData();
	});
	
	$( function () {
		$("#searchBtn").click(function(){
			$dtpk1 = $("#datepicker1");
			$dtpk2 = $("#datepicker2");
			$("#dtCnt").val("");
			if(SelTerm == "other") {
				$("#selTermFrom").val( ($dtpk1.val() == "") ? "" : new Date( $dtpk1.val()+" 00:00:00" ).format("yyyyMMddHHmmss") );
				$("#selTermTo").val( ($dtpk2.val() == "") ? "" : new Date( $dtpk2.val()+" 23:59:59" ).format("yyyyMMddHHmmss") );
				$("#dtCnt").val(  dateDiff($dtpk1.val()+" 00:00:00", $dtpk2.val()+" 23:59:59")+1  );
			}
			
			getDBData();
		});
		
		$("#smsSendMngBtn").click(function(){
			
			$.ajax({
				url : "/getSmsAddresseeList",
				type : 'post',
				async : false, // 동기로 처리해줌
//				data : {
//					selPageNum : ""
//				},
				success: function(result) {
					var addresseeList = result.list;
					
					$tbody = $("#smsSendMngTbody");
					$tbody.empty();
					if(addresseeList == null || addresseeList.length < 1) {
						$tbody.append( '<tr><td colspan="4">조회된 데이터가 없습니다.</td><tr>' );
					} else {
						for(var i=0; i<addresseeList.length; i++) {
							$tbody.append(
									$('<tr />').append(
											$("<td />").append( (i+1) )
									).append( $("<td />").append( addresseeList[i].addressee_name )
									).append(
											$("<td />").append( addresseeList[i].mobile )
									).append(
											$("<td />").append( '<a href="#;" onclick="deleteAddresseeYn(\''+addresseeList[i].sms_user_idx+'\');"><i class="glyphicon glyphicon-remove"></i></a>' )
									)
							);
						}
						
					}
				}
			});

			$("#selAddresseeName option:eq(0)").prop("selected", true);
			
			popupOpen('rpeople');
		});
		
		$('#selAddresseeName').change(function(){
			var addressee = $(this).val();
			if(addressee == "etc") {
				$('#addresseeName').show();
				$('#addresseeName').val("");
			} else {
				$('#addresseeName').hide();
				$('#addresseeName').val(addressee);
			}
		});

		$("#insertSmsBtn").click(function(){
			var addressee = $('#addresseeName').val();
			if(addressee == "" || addressee == null) {
				alert("이름을 입력해주세요");
				return ;
			}
			
			if($('#mobile').val() == "" || $('#mobile').val() == null) {
				alert("연락처를 입력해주세요");
				return ;
			}
			
			if(confirm("저장하시겠습니까?")) {
				var formData = $("#insertSmsForm").serializeObject();
				insertAddressee(formData);
			}
		});

		$("#cancelSmsSendMngBtnX").click(function(){
			popupClose('rpeople');
			
			$('#insertSmsForm').each(function() {
				this.reset();
			});
			
			$('#addresseeName').val("");
			$('#addresseeName').hide();
			$("#smsSendMngTbody").empty().append( '<tr><td colspan="4">조회된 데이터가 없습니다.</td><tr>' );
			
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
			url : "/getDeviceAlarmCnt",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				console.log("장치별 알람건수");
				callback_getDeviceAlarmCnt(result);
			}
		});
	}

	function callback_getDeviceAlarmCnt(result) {
		var dvTpAlarmDetail = result.detail;
		
		if(dvTpAlarmDetail != null) {
			$("#ioeAlarmCnt").empty().append( dvTpAlarmDetail.ioe_cnt );
			$("#pcsAlarmCnt").empty().append( dvTpAlarmDetail.pcs_cnt );
			$("#bmsAlarmCnt").empty().append( dvTpAlarmDetail.bms_cnt );
			$("#pvAlarmCnt").empty().append( dvTpAlarmDetail.pv_cnt );
			$("#etcAlarmCnt").empty().append( dvTpAlarmDetail.etc_cnt );
			
		}
		
	}
	
	// 비상 알람 목록 조회
	var selPageNumWarnAlarm = 1;
	function getWarningAlarmList(selPageNum) {
		$("#selPageNum").val(selPageNum);
		selPageNumWarnAlarm = selPageNum;
		var formData = $("#schForm").serializeObject();
		
		$.ajax({
			url : "/getWarningAlarmList",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				console.log("비상 알람 목록 조회");
				callback_getWarningAlarmList(result);
			}
		});
	}

	function callback_getWarningAlarmList(result) {
		var warnAlarmList = result.list;
		
		$tbody = $("#warnAlarmTbody");
		$tbody.empty();
		if(warnAlarmList == null || warnAlarmList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회된 데이터가 없습니다.</td></tr>' );
			$('#WarningAlarmPaging').empty();
		} else {
			for(var i=0; i<warnAlarmList.length; i++) {
				var alarm_type = (warnAlarmList[i].alarm_type == 1) ? "비상" : "주의";
				var tm = new Date( convertDateUTC(warnAlarmList[i].std_date) );
				$tbody.append(
						$('<tr />').append( $("<td />").append( warnAlarmList[i].device_type_nm ) // 장치타입
						).append( $("<td />").append( warnAlarmList[i].device_name ) // 장치명
						).append( $("<td />").append( warnAlarmList[i].device_id ) // 장치ID
						).append( $("<td />").append( tm.format("yyyy-MM-dd HH:mm:ss") ) // 알람시간
						).append( $("<td />").append( alarm_type ) // 알람타입
						).append( $("<td />").append( warnAlarmList[i].alarm_msg ) // 알람메세지
						).append( $("<td />").append( warnAlarmList[i].comp_id ) // 알람상태(뭘 의미하는거지??)
						).append( // 조치여부
								$("<td />").append(
//										'<a href="#;" onclick="updateCmpyForm(\''+warnAlarmList[i].comp_idx+'\');" class="default_btn">수정</a>'+
//										'<a href="#;" onclick="deleteCmpyYn(\''+warnAlarmList[i].comp_idx+'\');" class="cancel_btn">삭제</a>'
										'미조치'
								)
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "WarningAlarm");
			
			$("#warnAlarmCnt").empty().append(pagingMap.listCnt);
		}
		
	}
	
	// 주의 알람 목록 조회
	var selPageNumAlertAlarm = 1;
	function getAlertAlarmList(selPageNum) {
		$("#selPageNum").val(selPageNum);
		selPageNumAlertAlarm = selPageNum;
		var formData = $("#schForm").serializeObject();
		
		$.ajax({
			url : "/getAlertAlarmList",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				console.log("주의 알람 목록 조회");
				callback_getAlertAlarmList(result);
			}
		});
	}
	
	function callback_getAlertAlarmList(result) {
		var alertAlarmList = result.list;
		
		$tbody = $("#alertAlarmTbody");
		$tbody.empty();
		if(alertAlarmList == null || alertAlarmList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회된 데이터가 없습니다.</td><tr>' );
			$('#AlertAlarmPaging').empty();
		} else {
			for(var i=0; i<alertAlarmList.length; i++) {
				var alarm_type = (alertAlarmList[i].alarm_type == 1) ? "비상" : "주의";
				var tm = new Date( convertDateUTC(alertAlarmList[i].std_date) );
				$tbody.append(
						$('<tr />').append( $("<td />").append( alertAlarmList[i].device_type_nm ) // 장치타입
						).append( $("<td />").append( alertAlarmList[i].device_name ) // 장치명
						).append( $("<td />").append( alertAlarmList[i].device_id ) // 장치ID
						).append( $("<td />").append( tm.format("yyyy-MM-dd HH:mm:ss") ) // 알람시간
						).append( $("<td />").append( alarm_type ) // 알람타입
						).append( $("<td />").append( alertAlarmList[i].alarm_msg ) // 알람메세지
						).append( $("<td />").append( alertAlarmList[i].comp_id ) // 알람상태(뭘 의미하는거지??)
						).append( // 조치여부
								$("<td />").append(
//										'<a href="#;" onclick="updateCmpyForm(\''+alertAlarmList[i].comp_idx+'\');" class="default_btn">수정</a>'+
//										'<a href="#;" onclick="deleteCmpyYn(\''+alertAlarmList[i].comp_idx+'\');" class="cancel_btn">삭제</a>'
										'미조치'
								)
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "AlertAlarm");
			
			$("#alertAlarmCnt").empty().append(pagingMap.listCnt);
		}
		
		
	}

	function insertAddressee(formData) {
		$.ajax({
			url : "/insertAddressee",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultCnt = result.resultCnt;
				if(resultCnt > 0) {
					alert("저장되었습니다.");
					location.reload();
				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			}
		});
	}

	function deleteAddresseeYn(smsUserIdx) {
		if(confirm("삭제하시겠습니까?")) {
			$.ajax({
				url : "/deleteAddressee",
				type : 'post',
				async : false, // 동기로 처리해줌
				data : {
					smsUserIdx : smsUserIdx
				},
				success: function(result) {
					var resultCnt = result.resultCnt;
					if(resultCnt > 0) {
						alert("삭제되었습니다.");
						location.reload();
					} else {
						alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
					}
				},
				error:function(request,status,error){
					alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
				}
			});
		}
	}
	
