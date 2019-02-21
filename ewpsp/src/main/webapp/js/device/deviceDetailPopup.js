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
					getDvIOEDetailRealTime(ioeDetail.site_id, ioeDetail.device_id, ioeDetail.device_type)
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
			, error:function(request,status,error){
				alert("조회에 실패하였습니다. 관리자에게 문의하세요.");
			}
		});
	}
	
	function drawIOEDetail(result) {
		var ioeDetail = result.detail;
		
		var ioeStr = '';
		ioeStr += '<div class="ltit">';
		ioeStr += '<h2>';
		ioeStr += '<span class="ioe"></span>'+(  (ioeDetail.device_name == "" || ioeDetail.device_name == null) ? "-" : ioeDetail.device_name  );
		ioeStr += '<p>'+(new Date()).format("yyyy-MM-dd HH:mm:ss")+'</p>';
		ioeStr += '</h2>';
		ioeStr += '<a href="#;" id="closeIOEDetailBtnX" onclick="stopRealTime(\'ioe\');">닫기</a>';
		ioeStr += '</div>';
		ioeStr += '<div class="ltop">';
		ioeStr += '<dl>';
		ioeStr += '<dt>Device ID</dt>';
		ioeStr += '<dd>'+( (ioeDetail.device_id == "" || ioeDetail.device_id == null) ? "-" : ioeDetail.device_id )+'</dd>';
		ioeStr += '</dl>';
		ioeStr += '<dl>';
		ioeStr += '<dt>Device Group</dt>';
		ioeStr += '<dd>'+( (ioeDetail.device_grp_name == "" || ioeDetail.device_grp_name == null) ? "-" : ioeDetail.device_grp_name )+'</dd>';
		ioeStr += '</dl>';
		ioeStr += '<dl>';
		ioeStr += '<dt>Site Name</dt>';
		ioeStr += '<dd>'+( (ioeDetail.site_name == "" || ioeDetail.site_name == null) ? "-" : ioeDetail.site_name )+'</dd>';
		ioeStr += '</dl>';
		ioeStr += '<dl>';
		ioeStr += '<dt>Site ID</dt>';
		ioeStr += '<dd>'+( (ioeDetail.site_id == "" || ioeDetail.site_id == null) ? "-" : ioeDetail.site_id )+'</dd>';
		ioeStr += '</dl>';
		ioeStr += '</div>';
		ioeStr += '<div class="lbody">';
		ioeStr += '<div class="lstat mt20">';
		ioeStr += '<div class="dt">장치타입</div>';
		ioeStr += '<div class="dd">'+( (ioeDetail.device_type_nm == "" || ioeDetail.device_type_nm == null) ? "-" : ioeDetail.device_type_nm )+'</div>';
		ioeStr += '</div>';
		ioeStr += '<div class="lstat">';
		ioeStr += '<div class="dt">연결상태</div>';
		ioeStr += '<div class="dd"><span class="run">'+( (ioeDetail.device_stat == 1) ? "connect" : "disconnect" )+'</span></div>';
		ioeStr += '</div>';
		ioeStr += '<div class="lstat">';
		ioeStr += '<div class="dt">알람 메시지</div>';
		ioeStr += '<div class="dd">';
		ioeStr += '</div>';
		ioeStr += '</div>';   
		ioeStr += '<div class="ltbl mt30">';
		ioeStr += '<table>';
		ioeStr += '<thead>';
		ioeStr += '<tr>';
		ioeStr += '<th>전압(v)</th>';
		ioeStr += '<th>전력(kW)</th>';
		ioeStr += '<th>유효전력(kW)</th>';
		ioeStr += '<th>무효전력(kW)</th>';
		ioeStr += '</tr>';
		ioeStr += '</thead>';
		ioeStr += '<tbody>';
		ioeStr += '<tr>';
		ioeStr += '<td>'+( (ioeDetail.voltage == "" || ioeDetail.voltage == null) ? "-" : Number(ioeDetail.voltage)/1000 )+'</td>';
		ioeStr += '<td>'+( (ioeDetail.activePower == "" || ioeDetail.activePower == null) ? "-" : Number(ioeDetail.activePower)/(1000*1000) )+'</td>';
		ioeStr += '<td>'+( (ioeDetail.energy == "" || ioeDetail.energy == null) ? "-" : Number(ioeDetail.energy)/(1000*1000) )+'</td>';
		ioeStr += '<td>'+( (ioeDetail.energyReactive == "" || ioeDetail.energyReactive == null) ? "-" : ioeDetail.energyReactive )+'</td>';
		ioeStr += '</tr>';
		ioeStr += '</tbody>';
		ioeStr += '</table>';
		ioeStr += '</div>';
		ioeStr += '</div>';
			
		$(".dview_ioe").html(ioeStr);
		
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
		
		var pcsStr = '';
		pcsStr += '<div class="ltit">';
		pcsStr += '<h2>';
		pcsStr += '<span class="pcs"></span>'+(  (pcsDetail.device_name == "" || pcsDetail.device_name == null) ? "-" : pcsDetail.device_name  );
		pcsStr += '<p>'+(new Date()).format("yyyy-MM-dd HH:mm:ss")+'</p>';
		pcsStr += '</h2>';
		pcsStr += '<a href="#;" id="closePCSDetailBtnX" onclick="stopRealTime(\'pcs\');">닫기</a>';
		pcsStr += '</div>';
		pcsStr += '<div class="ltop">';
		pcsStr += '<dl>';
		pcsStr += '<dt>Device ID</dt>';
		pcsStr += '<dd>'+(  (pcsDetail.device_id == "" || pcsDetail.device_id == null) ? "-" : pcsDetail.device_id  )+'</dd>';
		pcsStr += '</dl>';
		pcsStr += '<dl>';
		pcsStr += '<dt>Device Group</dt>';
		pcsStr += '<dd>'+(  (pcsDetail.device_grp_name == "" || pcsDetail.device_grp_name == null) ? "-" : pcsDetail.device_grp_name  )+'</dd>';
		pcsStr += '</dl>';
		pcsStr += '<dl>';
		pcsStr += '<dt>Site Name</dt>';
		pcsStr += '<dd>'+(  (pcsDetail.site_name == "" || pcsDetail.site_name == null) ? "-" : pcsDetail.site_name  )+'</dd>';
		pcsStr += '</dl>';
		pcsStr += '<dl>';
		pcsStr += '<dt>Site ID</dt>';
		pcsStr += '<dd>'+(  (pcsDetail.site_id == "" || pcsDetail.site_id == null) ? "-" : pcsDetail.site_id  )+'</dd>';
		pcsStr += '</dl>';
		pcsStr += '</div>';
		pcsStr += '<div class="lbody">';
		pcsStr += '<div class="lstat mt20">';
		pcsStr += '<div class="dt">장치타입</div>';
		pcsStr += '<div class="dd">'+(  (pcsDetail.device_type_nm == "" || pcsDetail.device_type_nm == null) ? "-" : pcsDetail.device_type_nm  )+'</div>';
		pcsStr += '</div>';
		pcsStr += '<div class="lstat">';
		pcsStr += '<div class="dt">운전상태</div>';
		pcsStr += '<div class="dd"><span class="run">'+(  (pcsDetail.pcsStatusNm == "" || pcsDetail.pcsStatusNm == null) ? "-" : pcsDetail.pcsStatusNm  )+'</span></div>';
		pcsStr += '</div>';
		pcsStr += '<div class="lstat">';
		pcsStr += '<div class="dt">알람 메시지</div>';
		pcsStr += '<div class="dd"><span class="run">'+(  (pcsDetail.alarmMsg == "" || pcsDetail.alarmMsg == null) ? "-" : pcsDetail.alarmMsg  )+'</span></div>';
		pcsStr += '</div>';
		pcsStr += '</div>';
		pcsStr += '<h2 class="tbl_tit">AC 출력</h2>';
		pcsStr += '<div class="ltbl">';
		pcsStr += '<table>';
		pcsStr += '<thead>';
		pcsStr += '<tr>';
		pcsStr += '<th>전압(V)</th>';
		pcsStr += '<th>전력(kW)</th>';
		pcsStr += '<th>주파수(Hz)</th>';
		pcsStr += '<th>전류(A)</th>';
		pcsStr += '<th>역률(PF)</th>';
		pcsStr += '<th>전력설정치(kWh)</th>';
		pcsStr += '</tr>';
		pcsStr += '</thead>';
		pcsStr += '<tbody>';
		pcsStr += '<tr>';
		pcsStr += '<td>'+(  (pcsDetail.acVoltage == -1) ? "-" : pcsDetail.acVoltage  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.acPower == -1) ? "-" : pcsDetail.acPower  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.acFreq == -1) ? "-" : pcsDetail.acFreq  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.acCurrent == -1) ? "-" : pcsDetail.acCurrent  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.acPf == -1) ? "-" : pcsDetail.acPf  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.acSetPower == -1) ? "-" : pcsDetail.acSetPower  )+'</td>';
		pcsStr += '</tr>';
		pcsStr += '</tbody>';
		pcsStr += '</table>';
		pcsStr += '</div>';
		pcsStr += '<h2 class="tbl_tit">DC 출력</h2>';
		pcsStr += '<div class="ltbl">';
		pcsStr += '<table>';
		pcsStr += '<thead>';
		pcsStr += '<tr>';
		pcsStr += '<th>전압(V)</th>';
		pcsStr += '<th>전류(A)</th>';
		pcsStr += '<th>운전상태</th>';
		pcsStr += '<th>운전모드</th>';
		pcsStr += '<th>충전량</th>';
		pcsStr += '<th>방전량</th>';
		pcsStr += '</tr>';
		pcsStr += '</thead>';
		pcsStr += '<tbody>';
		pcsStr += '<tr>';
		pcsStr += '<td>'+(  (pcsDetail.dcVoltage == -1) ? "-" : pcsDetail.dcVoltage  ) +'</td>';
		pcsStr += '<td>'+(  (pcsDetail.dcPower == -1) ? "-" : pcsDetail.dcPower  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.pcsStatus == -1) ? "-" : pcsDetail.pcsStatus  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.pcsCommand == -1) ? "-" : pcsDetail.pcsCommand  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.todayCEnergy == -1) ? "-" : pcsDetail.todayCEnergy  )+'</td>';
		pcsStr += '<td>'+(  (pcsDetail.todayDEnergy == -1) ? "-" : pcsDetail.todayDEnergy  )+'</td>';
		pcsStr += '</tr>';
		pcsStr += '</tbody>';
		pcsStr += '</table>';
		pcsStr += '</div>';
		pcsStr += '</div>';
		
		$(".dview_pcs").html(pcsStr);
		
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
		
		var bmsStr = '';
		bmsStr += '<div class="ltit">';
		bmsStr += '<h2>';
		bmsStr += '<span class="bms"></span>'+(  (bmsDetail.device_name == "" || bmsDetail.device_name == null) ? "-" : bmsDetail.device_name  );
		bmsStr += '<p>'+(new Date()).format("yyyy-MM-dd HH:mm:ss")+'</p>';
		bmsStr += '</h2>';
		bmsStr += '<a href="#;" id="closeBMSDetailBtnX" onclick="stopRealTime(\'bms\');">닫기</a>';
		bmsStr += '</div>';
		bmsStr += '<div class="ltop">';
		bmsStr += '<dl>';
		bmsStr += '<dt>Device ID</dt>';
		bmsStr += '<dd>'+(  (bmsDetail.device_id == "" || bmsDetail.device_id == null) ? "-" : bmsDetail.device_id  )+'</dd>';
		bmsStr += '</dl>';
		bmsStr += '<dl>';
		bmsStr += '<dt>Device Group</dt>';
		bmsStr += '<dd>'+(  (bmsDetail.device_grp_name == "" || bmsDetail.device_grp_name == null) ? "-" : bmsDetail.device_grp_name  )+'</dd>';
		bmsStr += '</dl>';
		bmsStr += '<dl>';
		bmsStr += '<dt>Site Name</dt>';
		bmsStr += '<dd>'+(  (bmsDetail.site_name == "" || bmsDetail.site_name == null) ? "-" : bmsDetail.site_name  )+'</dd>';
		bmsStr += '</dl>';
		bmsStr += '<dl>';
		bmsStr += '<dt>Site ID</dt>';
		bmsStr += '<dd>'+(  (bmsDetail.site_id == "" || bmsDetail.site_id == null) ? "-" : bmsDetail.site_id  )+'</dd>';
		bmsStr += '</dl>';
		bmsStr += '</div>';
		bmsStr += '<div class="lbody">';
		bmsStr += '<div class="lstat mt20">';
		bmsStr += '<div class="dt">장치타입</div>';
		bmsStr += '<div class="dd">'+(  (bmsDetail.device_type_nm == "" || bmsDetail.device_type_nm == null) ? "-" : bmsDetail.device_type_nm  )+'</div>';
		bmsStr += '</div>';
		bmsStr += '<div class="lstat">';
		bmsStr += '<div class="dt">운전상태</div>';
		bmsStr += '<div class="dd"><span class="run">'+(  (bmsDetail.bmsStatusNm == "" || bmsDetail.bmsStatusNm == null) ? "-" : bmsDetail.bmsStatusNm  )+'</span></div>';
		bmsStr += '</div>';
		bmsStr += '<div class="lstat">';
		bmsStr += '<div class="dt">알람 메시지</div>';
		bmsStr += '<div class="dd"><span class="run">'+(  (bmsDetail.alarmMsg == "" || bmsDetail.alarmMsg == null) ? "-" : bmsDetail.alarmMsg  )+'</span></div>';
		bmsStr += '</div>';
		bmsStr += '</div>';
		bmsStr += '<h2 class="tbl_tit">충/방전 상태: <span style="color:#438fd7;font-weight:normal;"></span></h2>';
		bmsStr += '<div class="ltbl">';
		bmsStr += '<table>';
		bmsStr += '<thead>';
		bmsStr += '<tr>';
		bmsStr += '<th>SOC(%)</th>';
		bmsStr += '<th>SOH(%)</th>';
		bmsStr += '<th>SOC 현재(kWh)</th>';
		bmsStr += '<th>출력 전압(V)</th>';
		bmsStr += '<th>출력 전류(V)</th>';
		bmsStr += '<th>Dod(%)</th>';
		bmsStr += '</tr>';
		bmsStr += '</thead>';
		bmsStr += '<tbody>';
		bmsStr += '<tr>';
		bmsStr += '<td>'+(  (bmsDetail.sysSoc == -1) ? "-" : bmsDetail.sysSoc  )+'</td>';
		bmsStr += '<td>'+(  (bmsDetail.sysSoh == -1) ? "-" : bmsDetail.sysSoh  )+'</td>';
		bmsStr += '<td>'+(  (bmsDetail.currSoc == -1) ? "-" : bmsDetail.currSoc  )+'</td>';
		bmsStr += '<td>'+(  (bmsDetail.sysVoltage == -1) ? "-" : bmsDetail.sysVoltage  )+'</td>';
		bmsStr += '<td>'+(  (bmsDetail.sysCurrent == -1) ? "-" : bmsDetail.sysCurrent  )+'</td>';
		bmsStr += '<td>'+(  (bmsDetail.dod == -1) ? "-" : bmsDetail.dod  )+'</td>';
		bmsStr += '</tr>';
		bmsStr += '</tbody>';
		bmsStr += '</table>';
		bmsStr += '</div>';
		bmsStr += '</div>';
		
		$(".dview_bms").html(bmsStr);
		
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
		
		var pvStr = '';
		pvStr += '<div class="ltit">';
		pvStr += '<h2>';
		pvStr += '<span class="bms"></span>'+(  (pvDetail.device_name == "" || pvDetail.device_name == null) ? "-" : pvDetail.device_name  );
		pvStr += '<p>'+(new Date()).format("yyyy-MM-dd HH:mm:ss")+'</p>';
		pvStr += '</h2>';
		pvStr += '<a href="#;" id="closePVDetailBtnX" onclick="stopRealTime(\'pv\');">닫기</a>';
		pvStr += '</div>';
		pvStr += '<div class="ltop">';
		pvStr += '<dl>';
		pvStr += '<dt>Device ID</dt>';
		pvStr += '<dd>'+(  (pvDetail.device_id == "" || pvDetail.device_id == null) ? "-" : pvDetail.device_id  )+'</dd>';
		pvStr += '</dl>';
		pvStr += '<dl>';
		pvStr += '<dt>Device Group</dt>';
		pvStr += '<dd>'+(  (pvDetail.device_grp_name == "" || pvDetail.device_grp_name == null) ? "-" : pvDetail.device_grp_name  )+'</dd>';
		pvStr += '</dl>';
		pvStr += '<dl>';
		pvStr += '<dt>Site Name</dt>';
		pvStr += '<dd>'+(  (pvDetail.site_name == "" || pvDetail.site_name == null) ? "-" : pvDetail.site_name  )+'</dd>';
		pvStr += '</dl>';
		pvStr += '<dl>';
		pvStr += '<dt>Site ID</dt>';
		pvStr += '<dd>'+(  (pvDetail.site_id == "" || pvDetail.site_id == null) ? "-" : pvDetail.site_id  )+'</dd>';
		pvStr += '</dl>';
		pvStr += '</div>';
		pvStr += '<div class="lbody">';
		pvStr += '<div class="lstat mt20">';
		pvStr += '<div class="dt">장치타입</div>';
		pvStr += '<div class="dd">'+(  (pvDetail.device_type_nm == "" || pvDetail.device_type_nm == null) ? "-" : pvDetail.device_type_nm  )+'</div>';
		pvStr += '</div>';
		pvStr += '<div class="lstat">';
		pvStr += '<div class="dt">운전상태</div>';
		pvStr += '<div class="dd"><span class="run">'+(  (pvDetail.pvStatusNm == "" || pvDetail.pvStatusNm == null) ? "-" : pvDetail.pvStatusNm  )+'</span></div>';
		pvStr += '</div>';
		pvStr += '<div class="lstat">';
		pvStr += '<div class="dt">알람 메시지</div>';
		pvStr += '<div class="dd"><span class="run">'+(  (pvDetail.alarmMsg == "" || pvDetail.alarmMsg == null) ? "-" : pvDetail.alarmMsg  )+'</span></div>';
		pvStr += '</div>';
		pvStr += '</div>';
		pvStr += '<div class="ltbl mt30">';
		pvStr += '<table>';
		pvStr += '<thead>';
		pvStr += '<tr>';
		pvStr += '<th>온도</th>';
		pvStr += '<th>오늘 예측 발전량</th>';
		pvStr += '<th>실제 발전량</th>';
		pvStr += '<th>오늘 누적 발전량</th>';
		pvStr += '</tr>';
		pvStr += '</thead>';
		pvStr += '<tbody>';
		pvStr += '<tr>';
		pvStr += '<td>'+(  (pvDetail.temperature == -1) ? "-" : pvDetail.temperature+"℃"  )+'</td>';
		pvStr += '<td>'+'-'+'</td>';
		pvStr += '<td>'+(  (pvDetail.totalPower == -1) ? "-" : pvDetail.totalPower+"kWh"  )+'</td>';
		pvStr += '<td>'+(  (pvDetail.todayPower == -1) ? "-" : pvDetail.todayPower+"kWh"  )+'</td>';
		pvStr += '</tr>';
		pvStr += '</tbody>';
		pvStr += '</table>';
		pvStr += '</div>';
		pvStr += '</div>';
		
		$(".dview_pv").html(pvStr);
		
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
	