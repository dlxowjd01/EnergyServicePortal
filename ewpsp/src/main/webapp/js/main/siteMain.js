	// 모니터링 변수 : setInterval()를 변수에 저장하면 나중에 clearInterval()를 이용해 중지시킬 수 있다
	var monitoring_cycle_10sec = null;
	var monitoring_cycle_1min = null;
	var monitoring_cycle_15min = null;
	var formData = null;
	
	$(document).ready(function() {
		formData = getSiteMainSchCollection();
		
//		fn_cycle_10sec();
		fn_cycle_1min();
		fn_cycle_15min();
		
		realTime_monitoring_start();
		
	});
	
	
	// 자동 새로고침(실시간 모니터링)
	function realTime_monitoring_start() {
//		monitoring_cycle_10sec_start();
		monitoring_cycle_1min_start();
		monitoring_cycle_15min_start();
	}
	
	function monitoring_cycle_10sec_start() {
		if(monitoring_cycle_10sec == null) { // 1분 간격
			monitoring_cycle_10sec = setInterval(function(){
				fn_cycle_10sec();
			},5000); // 1000 = 1초, 5000 = 5초
		} else {
			alert("이미 모니터링이 실행중입니다.");
		}
	}
	
	function monitoring_cycle_1min_start() {
		if(monitoring_cycle_1min == null) { // 1분 간격
			monitoring_cycle_1min = setInterval(function(){
				fn_cycle_1min();
			},5000); // 1000 = 1초, 5000 = 5초
		} else {
			alert("이미 모니터링이 실행중입니다.");
		}
	}
	
	function monitoring_cycle_15min_start() {
		if(monitoring_cycle_15min == null) { // 15분 간격
			monitoring_cycle_15min = setInterval(function(){
				fn_cycle_15min();
			},10000); // 1000 = 1초, 10000 = 10초
		} else {
			alert("이미 모니터링이 실행중입니다.");
		}
	}
	
	function monitoring_cycle_10sec_end() {
		clearInterval(monitoring_cycle_10sec);
		monitoring_cycle_10sec = null;
	}
	
	function monitoring_cycle_1min_end() {
		clearInterval(monitoring_cycle_1min);
		monitoring_cycle_1min = null;
	}
	
	function monitoring_cycle_15min_end() {
		clearInterval(monitoring_cycle_15min);
		monitoring_cycle_15min = null;
	}
	
	function fn_cycle_10sec() {
		getAlarmList(formData);
	}
	
	function fn_cycle_1min() {
		getSiteSetDetail();
		getPeakRealList(formData); // 피크조회
//		getContractPowerList(formData); // 한전계약전력 조회
//		getChargePowerList(formData); // 요금적용전력 조회
		drawData_chart_peak();
		
		var today = new Date();
		update_updtDataTime(today, "updtTimePeak");
		chargePowerStrDisplayYn(today);
	}
	
	function fn_cycle_15min() {
		getRevenueList(formData); // 수익조회
		
		getDeviceList(formData); // 장치조회
		
		var today = new Date();
		update_updtDataTime(today, "updtTimeRevenue");
		update_updtDataTime(today, "updtTimeDevice");
	}
	
	function getSiteMainSchCollection() {
		var today = new Date();
//		firstDay = today.getFullYear()+(today.getMonth()+1)+today.getDate()+"000000";
//		endDay = today.getFullYear()+(today.getMonth()+1)+today.getDate()+"235959";
		var firstDay = '20180831000000';//new Date(2018, 7, 23, 0, 0, 0);
		var endDay = '20180831235959';//new Date(2018, 7, 23, 23, 59, 59);
		$("#selTermFrom").val(firstDay);
		$("#selTermTo").val(endDay);
//		console.log($("#selTermFrom").val()+", "+$("#selTermTo").val()+", "+$("#selTerm").val()+", "+$("#selPeriodVal").val());
		var formData = $("#schForm").serializeObject();
//		{
//				selTerm : "day",
//				selPeriodVal : "15min",
//				selTermFrom : firstDay,
//				selTermTo : endDay, 
//				siteId : "c64b328b"
//		};
//		console.log("formData : "+formData+", "+formData.siteId);
		return formData;
	}
	
	function callback_getAlarmList(result) {
		var alarmList = result.alarmList;
		var alarmTypeCntList = result.alarmTypeCntList;
		
		$("#todayTotalAlarmCnt").val(alarmTypeCntList.alert_cnt+alarmTypeCntList.warning_cnt);
		$("#todayAlarmCnt").val(alarmTypeCntList.alert_cnt);
		$("#todayWarninfCnt").val(alarmTypeCntList.warning_cnt);
		//   09.14 여기까지 하다가 중단
	}
	
	var contractPower;
	var chargePower;
	function callback_getSiteSetDetail(result) {
		var siteSetDetail = result.detail;
		contractPower = siteSetDetail.contract_power;
		chargePower = siteSetDetail.charge_power;
	}

	// 피크 전력
	var pastPeakList;
	function callback_getPeakRealList(result) {
		var peakList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totUsage = 0; // 전체 누적합
		if(peakList.length > 0) {
			for(var i=0; i<peakList.length; i++) {
				var peakVal = String(peakList[i].peak_val);
				var rePeakVal = 0;
				if(peakVal == null || peakVal == "" || peakVal == "null") {
					rePeakVal = null;
				} else {
					if(peakVal.indexOf(".")>-1) rePeakVal = Math.round( Number(peakVal) );
					else rePeakVal = Number(peakVal);
					totUsage = totUsage+Number(peakVal);
				}
				
//				var tm = new Date(peakList[i].std_timestamp);
				// 차트데이터 셋팅
				dataSet.push([
					Number(peakList[i].std_timestamp), totUsage
				]);
				dataSet2.push([
					Number(peakList[i].std_timestamp), contractPower
				]);
				dataSet3.push([
					Number(peakList[i].std_timestamp), chargePower
				]);
				
			}
			
		}
		pastPeakList = dataSet;
		contractPowerList = dataSet2;
		chargePowerList = dataSet3;
	}
	
	

	// 한전계약전력
	var contractPowerList;
	function callback_getContractPowerList(result) {
		var peakList = result.list;
		var dataSet = []; // chartData를 위한 변수
		for(var i=0; i<peakList.length; i++) {
			// 차트데이터 셋팅
			dataSet.push([ Number(peakList[i].std_timestamp), 40000 ]);
			
		}
		contractPowerList = dataSet;
	}
	
	// 요금적용전력
	var chargePowerList;
	function callback_getChargePowerList(result) {
		var peakList = result.list;
		var dataSet = []; // chartData를 위한 변수
		for(var i=0; i<peakList.length; i++) {
			dataSet.push([ peakList[i].std_timestamp, 30000 ]);
			
		}
		chargePowerList = dataSet;
	}

	// 차트 그리기
	function drawData_chart_peak() {
		if(pastPeakList.length < 1) {
			$(".peak").find(".no-data").css("display", "");
			$(".peak").find(".inchart").css("display", "none");
		} else {
			$(".peak").find(".no-data").css("display", "none");
			$(".peak").find(".inchart").css("display", "");
		}
		
		var seriesLength = peakChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				peakChart.series[i].remove();
		}
		
		peakChart.addSeries({
			name: '피크 전력',
			color: '#438fd7', /* 피크 전력 */
			type: 'column',
			data: pastPeakList
		}, false);
		
		peakChart.addSeries({
			name: '한전 계약 전력',
			color: '#13af67', /* 한전 계약 전력 */
			data: contractPowerList
		}, false);
		
		peakChart.addSeries({
			name: '요금 적용 전력',
			color: '#f75c4a', /* 요금 적용 전력 */
			data: chargePowerList
		}, false);
		
//		setTickInterval();
		peakChart.xAxis[0].options.tickInterval = 2 * 60 * 60 * 1000;
		peakChart.xAxis[0].options.labels.style.fontSize = '12px';
		
		peakChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	function chargePowerStrDisplayYn(today) {
		var holidayYn = chkHoliday(today); // 공휴일여부 체크(true:공휴일, false:평일or토요일)
		var chkSeason = checkSeason(today); // 1:봄, 2:여름, 3:가을, 4:겨울
		
		var chkHour = today.getHours();
		var timeTermStr = "";
		console.log("holidayYn : "+holidayYn+", "+chkSeason+", "+chkHour);
		if(!holidayYn) {
			if(chkSeason == 1 || chkSeason == 3) {
				// 중간부하시간대
				if( (chkHour>=9 && chkHour<=10) )  timeTermStr = "(09:00 ~ 10:00)"; 
				if( (chkHour>=12 && chkHour<=13) ) timeTermStr = "(12:00 ~ 13:00)";
				if( (chkHour>=17 && chkHour<=23) ) timeTermStr = "(17:00 ~ 23:00)";
				
				// 최대부하시간대
				if( (chkHour>=10 && chkHour<=12) ) timeTermStr = "(10:00 ~ 12:00)"; 
				if( (chkHour>=13 && chkHour<=17) ) timeTermStr = "(13:00 ~ 17:00)";
				
			} else if(chkSeason == 2) {
				// 중간부하시간대
				if( (chkHour>=9 && chkHour<=10) )  timeTermStr = "(09:00 ~ 10:00)"; 
				if( (chkHour>=12 && chkHour<=13) ) timeTermStr = "(12:00 ~ 13:00)";
				if( (chkHour>=17 && chkHour<=23) ) timeTermStr = "(17:00 ~ 23:00)";
				
				// 최대부하시간대
				if( (chkHour>=10 && chkHour<=12) ) timeTermStr = "(10:00 ~ 12:00)"; 
				if( (chkHour>=13 && chkHour<=17) ) timeTermStr = "(13:00 ~ 17:00)";
				
			} else if(chkSeason == 4) {
				// 중간부하시간대
				if( (chkHour>=9 && chkHour<=10) )  timeTermStr = "(09:00 ~ 10:00)"; 
				if( (chkHour>=12 && chkHour<=17) ) timeTermStr = "(12:00 ~ 17:00)";
				if( (chkHour>=20 && chkHour<=22) ) timeTermStr = "(20:00 ~ 22:00)";
				
				// 최대부하시간대
				if( (chkHour>=10 && chkHour<=12) ) timeTermStr = "(10:00 ~ 12:00)"; 
				if( (chkHour>=17 && chkHour<=20) ) timeTermStr = "(17:00 ~ 20:00)";
				if( (chkHour>=22 && chkHour<=23) ) timeTermStr = "(22:00 ~ 23:00)";
				
			}
		}
		console.log("timeTermStr : "+timeTermStr);
		
		$(".chart_notice").empty();
		if(timeTermStr != "") 
			$(".chart_notice").empty().append("지금은 <strong>요금적용전력</strong> 갱신구간 입니다. "+"<span>"+timeTermStr+"</span>");
	}
	
	function callback_getRevenueList(result) {
		var essRevenueList = result.essRevenueList;
		var pvRevenueList = result.pvRevenueList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totDataSet = 0;
		var totDataSet2 = 0;
		var totDataSet3 = 0;
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
//		console.log("pvRevenueList.length : "+pvRevenueList.length);
		if(pvRevenueList.length < 1) {
			
		} else {
			for(var i=0; i<pvRevenueList.length; i++) {
				var tm = new Date(pvRevenueList[i].std_timestamp);
				// 차트데이터 셋팅
				dataSet.push( [pvRevenueList[i].std_timestamp, pvRevenueList[i].tot_price] );
				dataSet2.push( [pvRevenueList[i].std_timestamp, pvRevenueList[i].smp_price] );
				dataSet3.push( [pvRevenueList[i].std_timestamp, pvRevenueList[i].rec_price] );
				totDataSet = totDataSet+Number(pvRevenueList[i].tot_price);
				totDataSet2 = totDataSet2+Number(String(pvRevenueList[i].smp_price));
				totDataSet3 = totDataSet3+Number(String(pvRevenueList[i].rec_price));
				
			}
			pvRevenueList1 = dataSet;
			pvRevenueList2 = dataSet2;
			pvRevenueList3 = dataSet3;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format(String(totDataSet), "pvRevenueTot1", "won");
			unit_format(String(totDataSet2), "pvRevenueTot2", "won");
			unit_format(String(totDataSet3), "pvRevenueTot3", "won");
		}
		
		
		
	}
	
	function callback_getDeviceList(result) {
		var deviceList = result.deviceList;
//		console.log("deviceList : "+deviceList);
		
		if(deviceList == null || deviceList.length < 1) {
			
		} else {
			$div = $("#deviceList");
			$div.empty();
			for(var i=0; i<8; i++) {
				if(i >= deviceList.length) {
					$div.append( $('<li />') );
				} else {
					var strHtml = "";
					if(deviceList[i].device_id == 1) strHtml = '<li class="ioe" />'; 
					else if(deviceList[i].device_id == 4) strHtml = '<li class="pcs" />'; 
					else if(deviceList[i].device_id == 5) strHtml = '<li class="bms" />'; 
					else if(deviceList[i].device_id == 6) strHtml = '<li class="pv" />';
					else strHtml = '<li class="ioe" />';
					$div.append(
							$(strHtml).append(
									$('<a href="#">')
							).append(
									$('<span class="dname" />').append( deviceList[i].device_name )
							).append(
									$('<span class="dmemo" />').append( "" )
							)
//							.append( $('<span class="dname" />').append(  deviceList[i].device_name ) )
//							).append( $('<span class="dmemo" />').append(  deviceList[i].device_name ) )
					);
					
				}
			}
			
		}
	}
	