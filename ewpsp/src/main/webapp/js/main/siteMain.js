	// 모니터링 변수 : setInterval()를 변수에 저장하면 나중에 clearInterval()를 이용해 중지시킬 수 있다
	var monitoring_cycle_10sec = null;
	var monitoring_cycle_1min = null;
	var monitoring_cycle_15min = null;
	var formData = null;
	
	$(document).ready(function() {
		formData = getSiteMainSchCollection();
		
		fn_cycle_10sec();
		fn_cycle_1min();
		fn_cycle_15min();
		
		realTime_monitoring_start();
		
	});
	
	
	// 자동 새로고침(실시간 모니터링)
	function realTime_monitoring_start() {
		monitoring_cycle_10sec_start();
		monitoring_cycle_1min_start();
		monitoring_cycle_15min_start();
	}
	
	function monitoring_cycle_10sec_start() {
		if(monitoring_cycle_10sec == null) { // 10초 간격
			monitoring_cycle_10sec = setInterval(function(){
				fn_cycle_10sec();
			}, (1000*10)); // 1000 = 1초, 5000 = 5초
		} else {
			alert("이미 모니터링이 실행중입니다.");
		}
	}
	
	function monitoring_cycle_1min_start() {
		if(monitoring_cycle_1min == null) { // 1분 간격
			monitoring_cycle_1min = setInterval(function(){
				fn_cycle_1min();
			}, (1000*60)); // 1000 = 1초, 5000 = 5초
		} else {
			alert("이미 모니터링이 실행중입니다.");
		}
	}
	
	function monitoring_cycle_15min_start() {
		if(monitoring_cycle_15min == null) { // 15분 간격
			monitoring_cycle_15min = setInterval(function(){
				fn_cycle_15min();
			}, (1000*60*15)); // 1000 = 1초, 10000 = 10초
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
		getAlarmList(formData); // 알람 조회
	}
	
	function fn_cycle_1min() {
		getSiteSetDetail();
		getPeakRealList(formData); // 피크전력현황 조회
//		getContractPowerList(formData); // 한전계약전력 조회
//		getChargePowerList(formData); // 요금적용전력 조회
		drawData_chart_peak();
		
		var today = new Date();
		update_updtDataTime(today, "updtTimePeak");
		chargePowerStrDisplayYn(today);
	}
	
	function fn_cycle_15min() {
		getDERUsageList(formData); // 사용량구성 조회
		
		getDeviceList(formData); // 장치현황 조회
		
		getRevenueList(formData); // 수익현황 조회
		
		var today = new Date();
		update_updtDataTime(today, "updtTimeRevenue");
		update_updtDataTime(today, "updtTimeDevice");
	}
	
	function getSiteMainSchCollection() {
		var today = new Date();
		firstDay = today.format("yyyyMMdd")+"000000";
		endDay = today.format("yyyyMMdd")+"235959";
//		var firstDay = '20180831000000';//new Date(2018, 7, 23, 0, 0, 0);
//		var endDay = '20180831235959';//new Date(2018, 7, 23, 23, 59, 59);
		$("#selTermFrom").val(firstDay);
		$("#selTermTo").val(endDay);
//		
		var formData = $("#schForm").serializeObject();
//		{
//				selTerm : "day",
//				selPeriodVal : "15min",
//				selTermFrom : firstDay,
//				selTermTo : endDay, 
//				siteId : "c64b328b"
//		};
		
		return formData;
	}
	
	function callback_getAlarmList(result) {
		var dvTpAlarmDetail = result.detail;
		var alarmList = result.alarmList;
		
		$("#todayTotalAlarmCnt").val(dvTpAlarmDetail.total_cnt);
		$("#todayAlarmCnt").val(dvTpAlarmDetail.alert_cnt);
		$("#todayWarninfCnt").val(dvTpAlarmDetail.warning_cnt);
		if(dvTpAlarmDetail.notCfm_cnt == 0) {
			$(".no").find('span').hide();
		} else {
			$(".no").find('span').show();
			$(".no").empty().append( '<span>'+dvTpAlarmDetail.notCfm_cnt+'</span>');
		}
		
		$div = $(".alarm_notice");
		$div.find("ul").empty();
		if(alarmList == null || alarmList.length < 1) {
			$div.find("ul").append( $('<li />').append( $('<a href="#;" />').append("조회된 데이터가 없습니다.") ) );
		} else {
			for(var i=0; i<alarmList.length; i++) {
				var tm = new Date( convertDateUTC(alarmList[i].std_date) );
				
				$div.find("ul").append( 
						$('<li />').append( $('<a href="#;" />').append("조회된 데이터가 없습니다.") 
						).append( $('<span />').append( tm.format("yyyy-MM-dd HH:mm:ss") ) ) 
				);
				
			}
			
		}
		
	}

	var pastUsageList; // 한전 사용량
	var essUsageList; // ess 사용량
	var pvUsageList; // pv 사용량 사용량
	function callback_getDERUsageList(result) {
		var kepcoUsageList = result.kepcoUsageList;
		var essUsgList = result.essUsageList;
		var pvUsgList = result.pvUsageList;
		var loopCntList = result.loopCntList; // for문 loop list
//		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0;
		var totalDataSet3 = 0;
		var nowUsage = 0;
		
		if( kepcoUsageList.length < 1 && essUsgList.length <1 && pvUsgList.length < 1 ) {
			$(".der").find(".no-data").css("display", "");
			$(".der").find(".inchart").css("display", "none");
		} else {
			$(".der").find(".no-data").css("display", "none");
			$(".der").find(".inchart").css("display", "");
		}
		
		var seriesLength = derChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
			derChart.series[i].remove();
		}
		
		// 한전사용량, ess사용량, pv사용량 중 하나라도 데이터가 존재할 때
		if( !( kepcoUsageList.length < 1 && essUsgList.length <1 && pvUsgList.length < 1 ) ) {
//			if(usageList.length > 0) {
				for(var i=0; i<loopCntList.length; i++) {
					var kepcoUsage = null;
					var essUsage = null;
					var pvUsage = null;
					var reKepcoUsage = 0;
					var reEssUsage = 0;
					var rePvUsage = 0;
					
					if(kepcoUsageList.length > 0) { // 한전사용량
						kepcoUsage = String(kepcoUsageList[i].usg_val);
						if(kepcoUsage == null || kepcoUsage == "" || kepcoUsage == "null") reKepcoUsage = null;
						else {
							if(kepcoUsage.length < 7) reKepcoUsage = Number(     kepcoUsage     ); // 나중에 수정 요망
							else reKepcoUsage = Number(     kepcoUsage.substring( 0, kepcoUsage.length-6 )     );
							totalDataSet = totalDataSet+Number(kepcoUsage);
						}
						
					} else reKepcoUsage = null;
					
					if(essUsgList.length > 0) { // ESS 사용량
						essUsage = String(essUsgList[i].usg_val);
						if(essUsage == null || essUsage == "" || essUsage == "null") reEssUsage = null;
						else {
							if(essUsage.length < 7) reEssUsage = Number(     essUsage     ); // 나중에 수정 요망
							else reEssUsage = Number(     essUsage.substring( 0, essUsage.length-6 )     );
							totalDataSet2 = totalDataSet2+Number(essUsage);
						}
					} else reEssUsage = null;
					
					if(pvUsgList.length > 0) { // PV 사용량
						pvUsage = String(pvUsgList[i].usg_val);
						if(pvUsage == null || pvUsage == "" || pvUsage == "null") rePvUsage = null;
						else {
							if(pvUsage.length < 7) rePvUsage = Number(     pvUsage     ); // 나중에 수정 요망
							else rePvUsage = Number(     pvUsage.substring( 0, pvUsage.length-6 )     );
							totalDataSet3 = totalDataSet3+Number(pvUsage);
						}
					} else rePvUsage = null;
					
					var tm = new Date( convertDateUTC(loopCntList[i].std_timestamp) );
					// 차트데이터 셋팅
					dataSet.push([setChartDateUTC(loopCntList[i].std_timestamp) , reKepcoUsage]);
					dataSet2.push([setChartDateUTC(loopCntList[i].std_timestamp) , reEssUsage]);
					dataSet3.push([setChartDateUTC(loopCntList[i].std_timestamp) , rePvUsage]);
					
					if( (i+1) == loopCntList.length ) {
						if(reKepcoUsage != null) {
							nowUsage = reKepcoUsage;
						}
					}
					
				}
				pastUsageList = dataSet;
				essUsageList = dataSet2;
				pvUsageList = dataSet3;
				
				if(kepcoUsageList.length > 0) {
					derChart.addSeries({
						index:3,
						fillOpacity: 1,
						name: '실제 사용량',
						color: '#3d4250',
						lineColor: '#438fd7', /* 한전 사용량 */
						data: pastUsageList
					}, false);
					
				}
				
				if(essUsgList.length > 0) {
					derChart.addSeries({
						index: 2,
						fillOpacity: 0.5,
						name: 'ESS 사용량',
						color: '#13af67', /* ESS 사용량 */
						data: essUsageList
					}, false);
					
				}
				
				if(pvUsgList.length > 0) {
					derChart.addSeries({
						index: 1,
						fillOpacity: 0.5,
						name: 'PV 사용량',
						color: '#f75c4a', /* PV 사용량 */
						data: pvUsageList
					}, false);
					
				}
				
//			}
			
		}
		
		derChart.xAxis[0].options.tickInterval = 2 * 60 * 60 * 1000;
		derChart.xAxis[0].options.labels.style.fontSize = '12px';
		
		derChart.redraw(); // 차트 데이터를 다시 그린다
		
		var total = totalDataSet+totalDataSet2+totalDataSet3;
		$("#nowUsage").empty().append(nowUsage+"kWh");
		console.log("(totalDataSet/total)*100 : "+(totalDataSet/total));
		$("#kepcoPer").empty().append( ( (totalDataSet == 0) ? 0 : ( (totalDataSet/total)*100 ).toFixed(2) )+"%" );
		$("#essPer").empty().append( ( (totalDataSet2 == 0) ? 0 : ( (totalDataSet2/total)*100 ).toFixed(2) )+"%" );
		$("#pvPer").empty().append( ( (totalDataSet3 == 0) ? 0 : ( (totalDataSet3/total)*100 ).toFixed(2) )+"%" );
		
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
	var contractPowerList;
	var chargePowerList;
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
				dataSet.push([Number(peakList[i].std_timestamp), totUsage]);
				dataSet2.push([Number(peakList[i].std_timestamp), contractPower]);
				dataSet3.push([Number(peakList[i].std_timestamp), chargePower]);
				
			}
			
		}
		pastPeakList = dataSet;
		contractPowerList = dataSet2;
		chargePowerList = dataSet3;
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
		
		if(deviceList == null || deviceList.length < 1) {
			
		} else {
			$div = $("#deviceList");
			$div.empty();
			for(var i=0; i<8; i++) {
				if(i >= deviceList.length) {
					$div.append( $('<li />') );
				} else {
					var strHtml = "";
					if(deviceList[i].device_type == 4) strHtml = '<li class="ioe" />'; 
					else if(deviceList[i].device_type == 1) strHtml = '<li class="pcs" />'; 
					else if(deviceList[i].device_type == 2) strHtml = '<li class="bms" />'; 
					else if(deviceList[i].device_type == 3) strHtml = '<li class="pv" />';
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
	