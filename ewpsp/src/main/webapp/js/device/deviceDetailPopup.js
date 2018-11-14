	var deviceDetailRealTime = null;
	function realtimeStop() {
		clearInterval(deviceDetailRealTime);
		deviceDetailRealTime = null;
	}
	
	// 장치 상세 조회(IOE)
	function callback_getDeviceIOEDetail(result) {
		var ioeDetail = result.detail;
		
		if(ioeDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			drawIOEDetail(result);
			popupOpen('dview_ioe');
			
			if(deviceDetailRealTime == null) { // 10초 간격
				deviceDetailRealTime = setInterval(function(){
					getDvIOEDetailRealTime(siteId, deviceId, deviceType)
				}, (1000*10)); // 1000 = 1초, 5000 = 5초
			} else {
				alert("이미 모니터링이 실행중입니다.");
			}
		}
		
	}
	
	function getDvIOEDetailRealTime(siteId, deviceId, deviceType) {
		$.ajax({
			url : "/getDeviceIOEDetail",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				siteId : siteId,
				deviceId : deviceId,
				deviceType : deviceType
			},
			success: function(result) {
				drawIOEDetail(result);
			}
		});
	}
	
	function drawIOEDetail(result) {
		var ioeDetail = result.detail;
		
		if(ioeDetail != null) {
			$(".dview_ioe").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="ioe" />') ).append( ioeDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="#;" id="closeIOEDetailBtnX" onclick="stopRealTime(\'ioe\');">닫기</a>' )
					)
			).append(
					$('<div class="ltop" />').append(
							$('<dl />').append( $('<dt />').append("Device ID") ).append( $('<dd />').append(ioeDetail.device_id) )
					).append(
							$('<dl />').append( $('<dt />').append("Device Group") ).append( $('<dd />').append(ioeDetail.device_grp_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site Name") ).append( $('<dd />').append(ioeDetail.site_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site ID") ).append( $('<dd />').append(ioeDetail.site_id) )
					)
			).append(
					$('<div class="lbody" />').append(
							$('<div class="lstat mt20" />').append( $('<div class="dt" />').append("장치타입") ).append(
									$('<div class="dd" />').append( ioeDetail.device_type_nm )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("연결상태") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append( ((ioeDetail.device_stat == 1) ? "connect" : "disconnect") ) )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("알람 메시지") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append("") )
							)
					)
			).append(
					$('<div class="ltbl mt30" />').append(
							$('<table />').append(
									$("<thead />").append(
											$("<tr />").append( $("<th />").append("전압(v)") 
											).append( $("<th />").append("전력(kW)")
											).append( $("<th />").append("유효전력(kW)")
											).append( $("<th />").append("무효전력(kW)")
											)
									) 
							).append(
									$('<tbody />').append(
											$('<tr />').append( $("<td />").append(  (ioeDetail.voltage == "" || ioeDetail.voltage == null) ? "-" : Number(ioeDetail.voltage)/1000  ) 
											).append( $("<td />").append(  (ioeDetail.activePower == "" || ioeDetail.activePower == null) ? "-" : Number(ioeDetail.activePower)/(1000*1000)  ) 
											).append( $("<td />").append(  (ioeDetail.energy == "" || ioeDetail.energy == null) ? "-" : Number(ioeDetail.energy)/(1000*1000)  ) 
											).append( $("<td />").append(  (ioeDetail.energyReactive == "" || ioeDetail.energyReactive == null) ? "-" : ioeDetail.energyReactive  ) 
											)
									)
							)
					)
			);
			
		}
		
	}

	// 장치 상세 조회(PCS)
	function callback_getDevicePCSDetail(result) {
		var pcsDetail = result.detail;
		
		if(pcsDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			drawPCSDetail(result);
			popupOpen('dview_pcs');

			if(deviceDetailRealTime == null) { // 10초 간격
				deviceDetailRealTime = setInterval(function(){
					getDvPCSDetailRealTime(pcsDetail.site_id, pcsDetail.device_id, pcsDetail.device_type);
				}, (1000*10)); // 1000 = 1초, 5000 = 5초
			} else {
				alert("이미 모니터링이 실행중입니다.");
			}
		}
		
	}

	function getDvPCSDetailRealTime(siteId, deviceId, deviceType) {
		$.ajax({
			url : "/getDevicePCSDetail",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				siteId : siteId,
				deviceId : deviceId,
				deviceType : deviceType
			},
			success: function(result) {
				drawPCSDetail(result);
			}
		});
	}
	
	function drawPCSDetail(result) {
		var pcsDetail = result.detail;
		
		if(pcsDetail != null) {
			$(".dview_pcs").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="pcs" />') ).append( pcsDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="#;" id="closePCSDetailBtnX" onclick="stopRealTime(\'pcs\');">닫기</a>' )
					)
			).append(
					$('<div class="ltop" />').append(
							$('<dl />').append( $('<dt />').append("Device ID") ).append( $('<dd />').append(pcsDetail.device_id) )
					).append(
							$('<dl />').append( $('<dt />').append("Device Group") ).append( $('<dd />').append(pcsDetail.device_grp_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site Name") ).append( $('<dd />').append(pcsDetail.site_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site ID") ).append( $('<dd />').append(pcsDetail.site_id) )
					)
			).append(
					$('<div class="lbody" />').append(
							$('<div class="lstat mt20" />').append( $('<div class="dt" />').append("장치타입") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append(pcsDetail.device_type_nm) )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("운전상태") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append( pcsDetail.pcsStatusNm ) )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("알람 메시지") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append("") )
							)
					).append( $('<h2 class="tbl_tit" />').append( "AC 출력" ) ).append(
							$('<div class="ltbl" />').append(
									$('<table />').append(
											$("<thead />").append(
													$("<tr />").append( $("<th />").append("전압(V)") 
													).append( $("<th />").append("전력(kW)")
													).append( $("<th />").append("주파수(Hz)")
													).append( $("<th />").append("전류(A)")
													).append( $("<th />").append("역률(PF)")
													).append( $("<th />").append("전력설정치(kWh)")
													) 
											) 
									).append(
											$('<tbody />').append(
													$('<tr />').append( $("<td />").append(  (pcsDetail.acVoltage == "" || pcsDetail.acVoltage == null) ? "-" : pcsDetail.acVoltage  ) 
													).append( $("<td />").append(  (pcsDetail.acPower == "" || pcsDetail.acPower == null) ? "-" : pcsDetail.acPower  )
													).append( $("<td />").append(  (pcsDetail.acFreq == "" || pcsDetail.acFreq == null) ? "-" : pcsDetail.acFreq  )
													).append( $("<td />").append(  (pcsDetail.acCurrent == "" || pcsDetail.acCurrent == null) ? "-" : pcsDetail.acCurrent  )
													).append( $("<td />").append(  (pcsDetail.acPf == "" || pcsDetail.acPf == null) ? "-" : pcsDetail.acPf  )
													).append( $("<td />").append(  (pcsDetail.acSetPower == "" || pcsDetail.acSetPower == null) ? "-" : pcsDetail.acSetPower  )
													)
											)
									)
							)
					).append( $('<h2 class="tbl_tit" />').append( "DC 출력" ) ).append(
							$('<div class="ltbl" />').append(
									$('<table />').append(
											$("<thead />").append(
													$("<tr />").append( $("<th />").append("전압(V)") 
													).append( $("<th />").append("전류(A)")
													).append( $("<th />").append("운전상태")
													).append( $("<th />").append("운전모드")
													).append( $("<th />").append("충전량")
													).append( $("<th />").append("방전량")
													) 
											) 
									).append(
											$('<tbody />').append(
													$('<tr />').append( $("<td />").append(  (pcsDetail.dcVoltage == "" || pcsDetail.dcVoltage == null) ? "-" : pcsDetail.dcVoltage  ) 
													).append( $("<td />").append(  (pcsDetail.dcPower == "" || pcsDetail.dcPower == null) ? "-" : pcsDetail.dcPower  )
													).append( $("<td />").append(  (pcsDetail.pcsStatus == "" || pcsDetail.pcsStatus == null) ? "-" : pcsDetail.pcsStatus  )
													).append( $("<td />").append(  (pcsDetail.pcsCommand == "" || pcsDetail.pcsCommand == null) ? "-" : pcsDetail.pcsCommand  )
													).append( $("<td />").append(  (pcsDetail.todayCEnergy == "" || pcsDetail.todayCEnergy == null) ? "-" : pcsDetail.todayCEnergy  )
													).append( $("<td />").append(  (pcsDetail.todayDEnergy == "" || pcsDetail.todayDEnergy == null) ? "-" : pcsDetail.todayDEnergy  )
													)
											)
									)
							)
					)
			);
			
		}
		
	}

	// 장치 상세 조회(BMS)
	function callback_getDeviceBMSDetail(result) {
		var bmsDetail = result.detail;
		
		if(bmsDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			drawBMSDetail(result);
			popupOpen('dview_bms');

			if(deviceDetailRealTime == null) { // 10초 간격
				deviceDetailRealTime = setInterval(function(){
					getDvBMSDetailRealTime(bmsDetail.site_id, bmsDetail.device_id, bmsDetail.device_type);
				}, (1000*10)); // 1000 = 1초, 5000 = 5초
			} else {
				alert("이미 모니터링이 실행중입니다.");
			}
		}
		
	}

	function getDvBMSDetailRealTime(siteId, deviceId, deviceType) {
		$.ajax({
			url : "/getDeviceBMSDetail",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				siteId : siteId,
				deviceId : deviceId,
				deviceType : deviceType
			},
			success: function(result) {
				drawBMSDetail(result);
			}
		});
	}
	
	function drawBMSDetail(result) {
		var bmsDetail = result.detail;
		
		if(bmsDetail != null) {
			$(".dview_bms").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="bms" />') ).append( bmsDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="#;" id="closeBMSDetailBtnX" onclick="stopRealTime(\'bms\');">닫기</a>' )
					)
			).append(
					$('<div class="ltop" />').append(
							$('<dl />').append( $('<dt />').append("Device ID") ).append( $('<dd />').append(bmsDetail.device_id) )
					).append(
							$('<dl />').append( $('<dt />').append("Device Group") ).append( $('<dd />').append(bmsDetail.device_grp_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site Name") ).append( $('<dd />').append(bmsDetail.site_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site ID") ).append( $('<dd />').append(bmsDetail.site_id) )
					)
			).append(
					$('<div class="lbody" />').append(
							$('<div class="lstat mt20" />').append( $('<div class="dt" />').append("장치타입") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append(bmsDetail.device_type_nm) )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("운전상태") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append( bmsDetail.bmsStatusNm ) )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("알람 메시지") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append("") )
							)
					).append( 
							$('<h2 class="tbl_tit" />').append( "충/방전 상태: " ).append(
									$('<span style="color:#438fd7;font-weight:normal;" />').append("충전중")
							)
					).append(
							$('<div class="ltbl" />').append(
									$('<table />').append(
											$("<thead />").append(
													$("<tr />").append( $("<th />").append("SOC(%)") 
													).append( $("<th />").append("SOH(%)")
													).append( $("<th />").append("SOC 현재(kWh)")
													).append( $("<th />").append("출력 전압(V)")
													).append( $("<th />").append("출력 전류(V)")
													).append( $("<th />").append("Dod(%)")
													) 
											) 
									).append(
											$('<tbody />').append(
													$('<tr />').append( $("<td />").append(  (bmsDetail.sysSoc == "" || bmsDetail.sysSoc == null) ? "-" : bmsDetail.sysSoc  ) // soc
													).append( $("<td />").append(  (bmsDetail.sysSoh == "" || bmsDetail.sysSoh == null) ? "-" : bmsDetail.sysSoh  ) // soh
													).append( $("<td />").append(  (bmsDetail.currSoc == "" || bmsDetail.currSoc == null) ? "-" : bmsDetail.currSoc  ) // soc 현재
													).append( $("<td />").append(  (bmsDetail.sysVoltage == "" || bmsDetail.sysVoltage == null) ? "-" : bmsDetail.sysVoltage  ) // 출력전압
													).append( $("<td />").append(  (bmsDetail.sysCurrent == "" || bmsDetail.sysCurrent == null) ? "-" : bmsDetail.sysCurrent  ) // 출력전류
													).append( $("<td />").append(  (bmsDetail.dod == "" || bmsDetail.dod == null) ? "-" : bmsDetail.dod  ) // dod
													)
											)
									)
							)
					)
			);
			
		}
		
	}

	// 장치 상세 조회(PV)
	function callback_getDevicePVDetail(result) {
		var pvDetail = result.detail;
		
		if(pvDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			drawPVDetail(result);
			popupOpen('dview_pv');

			if(deviceDetailRealTime == null) { // 10초 간격
				deviceDetailRealTime = setInterval(function(){
					getDvPVDetailRealTime(pvDetail.site_id, pvDetail.device_id, pvDetail.device_type);
				}, (1000*10)); // 1000 = 1초, 5000 = 5초
			} else {
				alert("이미 모니터링이 실행중입니다.");
			}
		}
		
	}

	function getDvPVDetailRealTime(siteId, deviceId, deviceType) {
		$.ajax({
			url : "/getDevicePVDetail",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				siteId : siteId,
				deviceId : deviceId,
				deviceType : deviceType
			},
			success: function(result) {
				drawPVDetail(result);
			}
		});
	}
	
	function drawPVDetail(result) {
		var pvDetail = result.detail;
		
		if(pvDetail != null) {
			$(".dview_pv").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="bms" />') ).append( pvDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="#;" id="closePVDetailBtnX" onclick="stopRealTime(\'pv\');">닫기</a>' )
					)
			).append(
					$('<div class="ltop" />').append(
							$('<dl />').append( $('<dt />').append("Device ID") ).append( $('<dd />').append(pvDetail.device_id) )
					).append(
							$('<dl />').append( $('<dt />').append("Device Group") ).append( $('<dd />').append(pvDetail.device_grp_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site Name") ).append( $('<dd />').append(pvDetail.site_name) )
					).append(
							$('<dl />').append( $('<dt />').append("Site ID") ).append( $('<dd />').append(pvDetail.site_id) )
					)
			).append(
					$('<div class="lbody" />').append(
							$('<div class="lstat mt20" />').append( $('<div class="dt" />').append("장치타입") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append(pvDetail.device_type_nm) )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("PV 상태") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append( pvDetail.pvStatusNm ) )
							)
					).append(
							$('<div class="lstat" />').append( $('<div class="dt" />').append("알람 메시지") ).append(
									$('<div class="dd" />').append( $('<span class="run" />').append("") )
							)
					).append(
							$('<div class="ltbl mt30" />').append(
									$('<table />').append(
											$("<thead />").append(
													$("<tr />").append( $("<th />").append("온도") 
													).append( $("<th />").append("오늘 예측 발전량")
													).append( $("<th />").append("실제 발전량")
													).append( $("<th />").append("오늘 누적 발전량")
													) 
											) 
									).append(
											$('<tbody />').append(
													$('<tr />').append( $("<td />").append(  (pvDetail.temperature == "" || pvDetail.temperature == null) ? "-" : pvDetail.temperature+"℃"  ) 
													).append( $("<td />").append("-"/*+"kWh"*/) 
													).append( $("<td />").append("-"/*+"kWh"*/) 
													).append( $("<td />").append(  (pvDetail.totalPower == "" || pvDetail.totalPower == null) ? "-" : pvDetail.totalPower+"kWh"  )
													)
											)
									)
							)
					)
			);
			
		}
		
	}
	
	function stopRealTime(deviceGbn) {
		realtimeStop();
		if(deviceGbn == "ioe") {
			popupClose('dview_ioe');
		} else if(deviceGbn == "pcs") {
			popupClose('dview_pcs');
		} else if(deviceGbn == "bms") {
			popupClose('dview_bms');
		} else if(deviceGbn == "pv") {
			popupClose('dview_pv');
		}
	}
	