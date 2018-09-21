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
			$("#ioeAlarmCnt").empty().append( dvTpAlarmDetail.cnt_ioe );
			$("#pcsAlarmCnt").empty().append( dvTpAlarmDetail.cnt_pcs );
			$("#bmsAlarmCnt").empty().append( dvTpAlarmDetail.cnt_bms );
			$("#pvAlarmCnt").empty().append( dvTpAlarmDetail.cnt_pv );
			$("#etcAlarmCnt").empty().append( dvTpAlarmDetail.cnt_etc );
			
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
			$tbody.append( '<tr><td colspan="8">조회된 데이터가 없습니다.</td><tr>' );
			$('#WarningAlarmPaging').empty();
		} else {
			for(var i=0; i<warnAlarmList.length; i++) {
				var device_stat = (warnAlarmList[i].device_stat == 1) ? "connect" : "disconnect";
				$tbody.append(
						$('<tr />').append( $("<td />").append( warnAlarmList[i].device_type ) // 장치타입
						).append( $("<td />").append( warnAlarmList[i].device_type ) // 장치명
						).append( $("<td />").append( warnAlarmList[i].device_id ) // 장치ID
						).append( $("<td />").append( warnAlarmList[i].std_date ) // 알람시간
						).append( $("<td />").append( warnAlarmList[i].alarm_type ) // 알람타입
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
				var device_stat = (alertAlarmList[i].device_stat == 1) ? "connect" : "disconnect";
				$tbody.append(
						$('<tr />').append( $("<td />").append( alertAlarmList[i].device_type ) // 장치타입
						).append( $("<td />").append( alertAlarmList[i].device_type ) // 장치명
						).append( $("<td />").append( alertAlarmList[i].device_id ) // 장치ID
						).append( $("<td />").append( alertAlarmList[i].std_date ) // 알람시간
						).append( $("<td />").append( alertAlarmList[i].alarm_type ) // 알람타입
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
	
	
