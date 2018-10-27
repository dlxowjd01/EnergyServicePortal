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
		$tbody.empty();
		if(ioeList == null || ioeList.length < 1) {
			$tbody.append( '<tr><td colspan="6">조회 결과가 없습니다.</td><tr>' );
			$('#DeviceIOEPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<ioeList.length; i++) {
				var tm = new Date( convertDateUTC(ioeList[i].upload_timestamp) );
				$tbody.append(
						$('<tr />').append( $("<td />").append( ioeList[i].rnum )
						).append( $("<td />").append( ioeList[i].device_name )
						).append( $("<td />").append( ioeList[i].device_id )
						).append( $("<td />").append( ioeList[i].device_type_nm )
						).append( $("<td />").append( ioeList[i].device_stat_name )
						).append( $("<td />").append( tm.format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDeviceIOEDetail(\''+ioeList[i].site_id+"\', \'"+ioeList[i].device_id+"\', \'"+ioeList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DeviceIOE");
			
			excelCnt = ioeList.length;
			selectDeviceGbn = "IOE";
			
		}
		
	}
	
	// 장치 상세 조회(IOE)
	function callback_getDeviceIOEDetail(result) {
		var ioeDetail = result.detail;
		
		if(ioeDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			$(".dview_ioe").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="ioe" />') ).append( ioeDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="javascript:popupClose(\'dview_ioe\');">닫기</a>' )
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
											$('<tr />').append( $("<td />").append(  (ioeDetail.voltage == "" || ioeDetail.voltage == null) ? "-" : ioeDetail.voltage  ) 
											).append( $("<td />").append(  (ioeDetail.activePower == "" || ioeDetail.activePower == null) ? "-" : ioeDetail.activePower  ) 
											).append( $("<td />").append(  (ioeDetail.energy == "" || ioeDetail.energy == null) ? "-" : ioeDetail.energy  ) 
											).append( $("<td />").append(  (ioeDetail.energyReactive == "" || ioeDetail.energyReactive == null) ? "-" : ioeDetail.energyReactive  ) 
											)  
									)
							)
					)
			);
			
			popupOpen('dview_ioe');
		}
		
	}
	
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
				var tm = new Date( convertDateUTC(pcsList[i].std_date) );
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pcs\')" />').append( $("<td />").append( pcsList[i].rnum )
						).append( $('<td />').append( pcsList[i].device_name )
						).append( $('<td />').append( pcsList[i].device_id )
						).append( $('<td />').append( pcsList[i].device_type_nm )
						).append( $('<td />').append( pcsList[i].device_stat_name )
						).append( $('<td class="ellipsis mxw400" />').append( pcsList[i].alarm_msg )
						).append( $('<td />').append( tm.format("yyyy-MM-dd HH:mm:ss") )
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

	// 장치 상세 조회(PCS)
	function callback_getDevicePCSDetail(result) {
		var pcsDetail = result.detail;
		
		if(pcsDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			$(".dview_pcs").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="pcs" />') ).append( pcsDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="javascript:popupClose(\'dview_pcs\');">닫기</a>' )
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
									$('<div class="dd" />').append( $('<span class="run" />').append( ((pcsDetail.device_stat == 1) ? "connect" : "disconnect") ) )
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
													$('<tr />').append( $("<td />").append(  (pcsDetail.ac_voltage == "" || pcsDetail.ac_voltage == null) ? "-" : pcsDetail.ac_voltage  ) 
													).append( $("<td />").append(  (pcsDetail.ac_power == "" || pcsDetail.ac_power == null) ? "-" : pcsDetail.ac_power  )
													).append( $("<td />").append(  (pcsDetail.ac_freq == "" || pcsDetail.ac_freq == null) ? "-" : pcsDetail.ac_freq  )
													).append( $("<td />").append(  (pcsDetail.ac_current == "" || pcsDetail.ac_current == null) ? "-" : pcsDetail.ac_current  )
													).append( $("<td />").append(  (pcsDetail.ac_pf == "" || pcsDetail.ac_pf == null) ? "-" : pcsDetail.ac_pf  )
													).append( $("<td />").append(  (pcsDetail.ac_set_power == "" || pcsDetail.ac_set_power == null) ? "-" : pcsDetail.ac_set_power  )
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
													$('<tr />').append( $("<td />").append(pcsDetail.dc_voltage) 
													).append( $("<td />").append(  (pcsDetail.dc_power == "" || pcsDetail.dc_power == null) ? "-" : pcsDetail.dc_power  )
													).append( $("<td />").append(  (pcsDetail.pcs_status_nm == "" || pcsDetail.pcs_status_nm == null) ? "-" : pcsDetail.pcs_status_nm  )
													).append( $("<td />").append(  (pcsDetail.pcs_command_nm == "" || pcsDetail.pcs_command_nm == null) ? "-" : pcsDetail.pcs_command_nm  )
													).append( $("<td />").append(  (pcsDetail.today_c_energy == "" || pcsDetail.today_c_energy == null) ? "-" : pcsDetail.today_c_energy  )
													).append( $("<td />").append(  (pcsDetail.today_d_energy == "" || pcsDetail.today_d_energy == null) ? "-" : pcsDetail.today_d_energy  )
													)  
											)
									)
							)
					)
			);
			
			popupOpen('dview_pcs');
		}
		
	}
	
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
				var tm = new Date( convertDateUTC(bmsList[i].std_date) );
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/bat\')" />').append( $("<td />").append( bmsList[i].rnum )
						).append( $('<td />').append( bmsList[i].device_name )
						).append( $('<td />').append( bmsList[i].device_id )
						).append( $('<td />').append( bmsList[i].device_type_nm )
						).append( $('<td />').append( bmsList[i].device_stat_name )
						).append( $('<td class="ellipsis mxw400" />').append( bmsList[i].alarm_msg )
						).append( $('<td />').append( tm.format("yyyy-MM-dd HH:mm:ss") )
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

	// 장치 상세 조회(BMS)
	function callback_getDeviceBMSDetail(result) {
		var bmsDetail = result.detail;
		
		if(bmsDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			$(".dview_bms").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="bms" />') ).append( bmsDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="javascript:popupClose(\'dview_bms\');">닫기</a>' )
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
									$('<div class="dd" />').append( $('<span class="run" />').append( ((bmsDetail.device_stat == 1) ? "connect" : "disconnect") ) )
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
													$('<tr />').append( $("<td />").append(bmsDetail.sys_soc) // soc
													).append( $("<td />").append(  (bmsDetail.sys_soh == "" || bmsDetail.sys_soh == null) ? "-" : bmsDetail.sys_soh  ) // soh
													).append( $("<td />").append(  (bmsDetail.curr_soc == "" || bmsDetail.curr_soc == null) ? "-" : bmsDetail.curr_soc  ) // soc 현재
													).append( $("<td />").append(  (bmsDetail.sys_voltage == "" || bmsDetail.sys_voltage == null) ? "-" : bmsDetail.sys_voltage  ) // 출력전압
													).append( $("<td />").append(  (bmsDetail.sys_current == "" || bmsDetail.sys_current == null) ? "-" : bmsDetail.sys_current  ) // 출력전류
													).append( $("<td />").append(  (bmsDetail.dod == "" || bmsDetail.dod == null) ? "-" : bmsDetail.dod  ) // dod
													)  
											)
									)
							)
					)
			);
			
			popupOpen('dview_bms');
		}
		
	}
	
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
				var tm = new Date( convertDateUTC(pvList[i].std_date) );
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pv\')" />').append( $("<td />").append( pvList[i].rnum )
						).append( $('<td />').append( pvList[i].device_name )
						).append( $('<td />').append( pvList[i].device_id )
						).append( $('<td />').append( pvList[i].device_type_nm )
						).append( $('<td />').append( pvList[i].device_stat_name )
						).append( $('<td />').append( pvList[i].temp )
						).append( $('<td class="ellipsis mxw400" />').append( pvList[i].alarm_msg )
						).append( $('<td />').append( tm.format("yyyy-MM-dd HH:mm:ss") )
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

	// 장치 상세 조회(PV)
	function callback_getDevicePVDetail(result) {
		var pvDetail = result.detail;
		
		if(pvDetail == null) {
			alert("조회 결과가 없습니다.");
		} else {
			$(".dview_pv").empty().append(
					$('<div class="ltit" />').append(
							$('<h2 />').append( $('<span class="bms" />') ).append( pvDetail.device_name ).append(
									$('<p />').append( (new Date()).format("yyyy-MM-dd HH:mm:ss") )	
							).append( '<a href="javascript:popupClose(\'dview_pv\');">닫기</a>' )
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
									$('<div class="dd" />').append( $('<span class="run" />').append( ((pvDetail.device_stat == 1) ? "connect" : "disconnect") ) )
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
													$('<tr />').append( $("<td />").append(  (pvDetail.temp == "" || pvDetail.temp == null) ? "-" : pvDetail.temp+"℃"  ) 
													).append( $("<td />").append("-"/*+"kWh"*/) 
													).append( $("<td />").append("-"/*+"kWh"*/) 
													).append( $("<td />").append(  (pvDetail.tot_power == "" || pvDetail.tot_power == null) ? "-" : pvDetail.tot_power+"kWh"  )
													)  
											)
									)
							)
					)
			);
			
			popupOpen('dview_pv');
		}
		
	}
	
