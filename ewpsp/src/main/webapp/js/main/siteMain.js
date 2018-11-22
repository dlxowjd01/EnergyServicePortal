	// 모니터링 변수 : setInterval()를 변수에 저장하면 나중에 clearInterval()를 이용해 중지시킬 수 있다
	var monitoring_cycle_10sec = null;
	var monitoring_cycle_1min = null;
	var monitoring_cycle_15min = null;
	var formData = null;
	
	$(document).ready(function() {
		$("#selPageNum").val(1);
		formData = getSiteMainSchCollection();
		
		showHideLoadingBar('show');
//		var myTimer = setTimeout(function(){
			fn_cycle_10sec();
			fn_cycle_1min();
			fn_cycle_15min();
			showHideLoadingBar('hide');
//		}, (1000));
		
//		clearTimeout(myTimer);

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
		getPeak(formData);
//		getPeakRealList(formData); // 피크전력현황 조회
		drawData_chart_peak(); // 피크전력현황 차트그리기
		
		var today = new Date();
		update_updtDataTime(today, "updtTimePeak");
		chargePowerStrDisplayYn(today);
	}
	
	function fn_cycle_15min() {
		getESSChargeRealList(formData); // 실제충방전량 조회
		getESSChargeFutureList(formData); // 예측충방전량 조회
		drawData_chart_charge(); // 충방전량 차트그리기
		getESSChargeSum(formData); // ess 충방전량 합계 조회
		
		getSoc(formData); // soc 잔량 조회
		
		getDERUsageList(formData); // 사용량구성 조회
		
		getDeviceList(1); // 장치현황 조회
		
		getRevenueList(formData); // 수익현황 조회
		
		var today = new Date();
		update_updtDataTime(today, "updtTimeRevenue");
		update_updtDataTime(today, "updtTimeDevice");
	}
	
	function getSiteMainSchCollection() {
//		var today = new Date();
//		firstDay = today.format("yyyyMMdd")+"000000";
//		endDay = today.format("yyyyMMdd")+"235959";
////		var firstDay = '20180831000000';//new Date(2018, 7, 23, 0, 0, 0);
////		var endDay = '20180831235959';//new Date(2018, 7, 23, 23, 59, 59);
//		$("#selTermFrom").val(firstDay);
//		$("#selTermTo").val(endDay);
		var firstDay = new Date();
		var endDay = new Date();
		var startTime;
		var endTime;
		startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), 0, 0, 0);
		endTime = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), 23, 59, 59);
		
		var queryStart = new Date(startTime.setMinutes(startTime.getMinutes() + (new Date()).getTimezoneOffset()));
		var queryEnd = new Date(endTime.setMinutes(endTime.getMinutes() + (new Date()).getTimezoneOffset()));
		queryStart = (queryStart == "") ? "" : queryStart.format("yyyyMMddHHmmss");
		queryEnd = (queryEnd == "") ? "" : queryEnd.format("yyyyMMddHHmmss");
		$("#selTermFrom").val(queryStart);
		$("#selTermTo").val(queryEnd);
		
		var formData = $("#schForm").serializeObject();
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
			$div.find("ul").append( $('<li />').append( $('<a href="#;" />').append("조회 결과가 없습니다.") ) );
		} else {
			for(var i=0; i<alarmList.length; i++) {
				var tm = new Date( convertDateUTC(alarmList[i].std_date) );
				
				$div.find("ul").append( 
						$('<li />').append( $('<a href="#;" />').append("조회 결과가 없습니다.") 
						).append( $('<span />').append( tm.format("yyyy-MM-dd HH:mm:ss") ) ) 
				);
				
			}
			
		}
		
	}
	
	// 실제 충방전량 조회
	var pastChgList;
	var pastDischgList;
	function callback_getESSChargeRealList(result) {
		var resultListMap = result.resultListMap;
		
		var chgChartList = result.chgChartList;
		var dischgChartList = result.dischgChartList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0; // 전체 누적합
		if(chgChartList != null && chgChartList.length > 0) {
			for(var i=0; i<chgChartList.length; i++) {
				var chgVal = String(chgChartList[i].chg_val);
				var dischgVal   = String(dischgChartList[i].dischg_val);
				var reChgVal = 0; 
				var reDischgVal   = 0; 
				
				if(chgVal == null || chgVal == "" || chgVal == "null") reChgVal = null;
				else {
					reChgVal = Math.round( Number(chgVal) );
					totalDataSet = totalDataSet+reChgVal;
				}
				if(dischgVal == null || dischgVal == "" || dischgVal == "null") reDischgVal = null;
				else {
					reDischgVal   = Math.round( Number(dischgVal) );
					totalDataSet2 = totalDataSet2+reDischgVal;
				}
				
				var tm = new Date( convertDateUTC(chgChartList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push( [setChartDateUTC(chgChartList[i].std_timestamp), reChgVal] );
				dataSet2.push( [setChartDateUTC(chgChartList[i].std_timestamp), reDischgVal] );
				
			}
			
		}
		pastChgList = dataSet;
		pastDischgList = dataSet2;
		
	}
	
	// 예측 충방전량
	var fetureChgList;
	var fetureDischgList;
	var totalFetureChg;
	var totalFetureDischg;
	function callback_getESSChargeFutureList(result) {
		var resultListMap = result.resultListMap;
		
		var chgChartList = result.chgChartList;
		var dischgChartList = result.dischgChartList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0; // 전체 누적합
		if(chgChartList != null && chgChartList.length > 0) {
			for(var i=0; i<chgChartList.length; i++) {
				var chgVal = String(chgChartList[i].chg_val);
				var dischgVal   = String(dischgChartList[i].dischg_val);
				var reChgVal = 0; 
				var reDischgVal   = 0; 
				
				if(chgVal == null || chgVal == "" || chgVal == "null") reChgVal = null;
				else {
					reChgVal = Math.round( Number(chgVal) );
					totalDataSet = totalDataSet+reChgVal;
				}
				if(dischgVal == null || dischgVal == "" || dischgVal == "null") reDischgVal = null;
				else {
					reDischgVal   = Math.round( Number(dischgVal) );
					totalDataSet2 = totalDataSet2+reDischgVal;
				}
				
				var tm = new Date( convertDateUTC(chgChartList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push( [setChartDateUTC(chgChartList[i].std_timestamp), reChgVal] );
				dataSet2.push( [setChartDateUTC(chgChartList[i].std_timestamp), reDischgVal] );
				
			}
			
		}
		fetureChgList = dataSet;
		fetureDischgList = dataSet2;
		totalFetureChg = totalDataSet;
		totalFetureDischg = totalDataSet2;
		
	}
	
	function error_getESSChargeRealList(request, status, error) {
		$(".charge").find(".no-data").css("display", "");
		$(".charge").find(".inchart").css("display", "none");
		$(".charge").find(".chart_footer").css("display", "none");
	}
	
	function error_getESSChargeFutureList(request, status, error) {
		$(".charge").find(".no-data").css("display", "");
		$(".charge").find(".inchart").css("display", "none");
		$(".charge").find(".chart_footer").css("display", "none");
	}
	
	// 차트 그리기
	function drawData_chart_charge() {
		if( pastChgList.length < 1 && pastDischgList.length <1 && fetureChgList.length < 1 && fetureDischgList.length < 1 ) {
			$(".charge").find(".no-data").css("display", "");
			$(".charge").find(".inchart").css("display", "none");
			$(".charge").find(".chart_footer").css("display", "none");
		} else {
			$(".charge").find(".no-data").css("display", "none");
			$(".charge").find(".inchart").css("display", "");
			$(".charge").find(".chart_footer").css("display", "");
		}
		
		var seriesLength = chargeChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				chargeChart.series[i].remove();
		}
		
		chargeChart.addSeries({
			type: 'column',
	        name: '충전량',
	        color: '#438fd7',
			data: pastChgList
		}, false);
		
		chargeChart.addSeries({
			type: 'line',
	        name: '충전 계획',
	        color: '#13af67',
	        dashStyle: 'ShortDash',
			data: fetureChgList
		}, false);
		
		chargeChart.addSeries({
			type: 'column',
	        name: '방전량',
	        color: '#f75c4a',
			data: pastDischgList
		}, false);
		
		chargeChart.addSeries({
			type: 'line',
	        name: '방전 계획',
	        color: '#84848f',
	        dashStyle: 'ShortDash',
			data: fetureDischgList
		}, false);
		
//		setTickInterval();
		chargeChart.xAxis[0].options.tickInterval = /*24 **/ 60 * 60 * 1000;
		chargeChart.xAxis[0].options.labels.style.fontSize = '12px';
		
		chargeChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	function getESSChargeSum(formData) {
		$.ajax({
			url : "/getESSChargeSum",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultListMap = result.resultListMap;
				
				var todaySum = resultListMap.todaySum;
				var monthSum = resultListMap.monthSum;
				var yearSum = resultListMap.yearSum;
				
				$("#todayCrg").empty().append( numberComma(todaySum.chg_val_sum)+" kWh" );
				$("#todayDiscrg").empty().append( numberComma(todaySum.dischg_val_sum)+" kWh" );
				$("#todayRevenue").empty().append( numberComma(todaySum.ess_revenue_sum) );
				$("#monthCrg").empty().append( numberComma(monthSum.chg_val_sum)+" kWh" );
				$("#monthDiscrg").empty().append( numberComma(monthSum.dischg_val_sum)+" kWh" );
				$("#monthRevenue").empty().append( numberComma(monthSum.ess_revenue_sum) );
				$("#yearCrg").empty().append( numberComma(yearSum.chg_val_sum)+" kWh" );
				$("#yearDiscrg").empty().append( numberComma(yearSum.dischg_val_sum)+" kWh" );
				$("#yearRevenue").empty().append( numberComma(yearSum.ess_revenue_sum) );
				
				var chgValSum = Number(todaySum.chg_val_sum);
				var dischgValSum = Number(todaySum.dischg_val_sum);
				if(totalFetureChg == 0 && chgValSum == 0) {
					chgVal = 0;
				} else if(totalFetureChg == 0 && chgValSum > 0) {
					chgVal = 100;
				} else {
					chgVal = ((numOfTotal_per(totalFetureChg, chgValSum)) >= 100) ? 100 : numOfTotal_per(totalFetureChg, chgValSum);
				}
				if(totalFetureDischg == 0 && dischgValSum == 0) {
					dischgVal = 0;
				} else if(totalFetureDischg == 0 && dischgValSum > 0) {
					dischgVal = 100;
				} else {
					dischgVal = ((numOfTotal_per(totalFetureDischg, dischgValSum)) >= 100) ? 100 : numOfTotal_per(totalFetureDischg, dischgValSum);
				}
				
				$("#socTodayCrg").empty().append( numberComma(chgVal) ).append('<em>kWh</em>');
				$("#socTodayDiscrg").empty().append( numberComma(dischgVal) ).append('<em>kWh</em>');
				
			}
		});
	}
	
	function getSoc(formData) {
		$.ajax({
			url : "/getSoc",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var finalSoc = result.finalSoc;
				
				if(finalSoc == 0) {
					$(".smain_soc").find(".no-data").css("display", "");
					$(".smain_soc").find(".soc").css("display", "none");
				} else {
					$(".smain_soc").find(".no-data").css("display", "none");
					$(".smain_soc").find(".soc").css("display", "");
					$(".battery").find("span").css("width", finalSoc+"%");
					$(".battery_per").empty().append('<span>'+finalSoc+'<em>%</em></span>');
				}
				
	   		}
		});
		
	}
	
	var pastUsageList; // 한전 사용량
	var essUsageList; // ess 사용량
	var pvUsageList; // pv 사용량 사용량
	function callback_getDERUsageList(result) {
		var kepcoUsageChartList  = result.kepcoUsageChartList;
		var essUsageListChartList = result.essUsageListChartList;
		var pvUsageListChartList = result.pvUsageListChartList;
		var loopCntChartList = result.loopCntChartList; // for문 loop list
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0;
		var totalDataSet3 = 0;
		var nowUsage = 0;
		
		if( kepcoUsageChartList == null && essUsageListChartList == null && pvUsageListChartList == null ) {
			$(".der").find(".no-data").css("display", "");
			$(".der").find(".inchart").css("display", "none");
			$(".der").find(".chart_footer").css("display", "none");
		} else {
			$(".der").find(".no-data").css("display", "none");
			$(".der").find(".inchart").css("display", "");
			$(".der").find(".chart_footer").css("display", "");
		}
		
		var seriesLength = derChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
			derChart.series[i].remove();
		}
		
		// 한전사용량, ess사용량, pv사용량 중 하나라도 데이터가 존재할 때
		if( !( kepcoUsageChartList == null && essUsageListChartList == null && pvUsageListChartList == null ) ) {
//			if(loopCntChartList.length > 0) {
				for(var i=0; i<loopCntChartList.length; i++) {
					var kepcoUsage = null;
					var essUsage = null;
					var pvUsage = null;
					var reKepcoUsage = 0;
					var reEssUsage = 0;
					var rePvUsage = 0;
					
					if(kepcoUsageChartList != null && kepcoUsageChartList.length > 0 && kepcoUsageChartList.length > i) { // 한전사용량
						kepcoUsage = String(kepcoUsageChartList[i].usg_val);
						if(kepcoUsage == null || kepcoUsage == "" || kepcoUsage == "null") reKepcoUsage = null;
						else {
							if(kepcoUsage.length < 7) reKepcoUsage = Number(     kepcoUsage     ); // 나중에 수정 요망
							else reKepcoUsage = Number(     kepcoUsage.substring( 0, kepcoUsage.length-6 )     );
							totalDataSet = totalDataSet+Number(kepcoUsage);
						}
						
					} else reKepcoUsage = null;
					
					if(essUsageListChartList != null && essUsageListChartList.length > 0 && essUsageListChartList.length > i) { // ESS 사용량
						essUsage = String(essUsageListChartList[i].usg_val);
						if(essUsage == null || essUsage == "" || essUsage == "null") reEssUsage = null;
						else {
							if(essUsage.length < 7) reEssUsage = Number(     essUsage     ); // 나중에 수정 요망
							else reEssUsage = Number(     essUsage.substring( 0, essUsage.length-6 )     );
							totalDataSet2 = totalDataSet2+Number(essUsage);
						}
					} else reEssUsage = null;
					
					if(pvUsageListChartList != null && pvUsageListChartList.length > 0 && pvUsageListChartList.length > i) { // PV 사용량
						pvUsage = String(pvUsageListChartList[i].gen_val);
						if(pvUsage == null || pvUsage == "" || pvUsage == "null") rePvUsage = null;
						else {
							if(pvUsage.length < 7) rePvUsage = Number(     pvUsage     ); // 나중에 수정 요망
							else rePvUsage = Number(     pvUsage.substring( 0, pvUsage.length-6 )     );
							totalDataSet3 = totalDataSet3+Number(pvUsage);
						}
					} else rePvUsage = null;
					
					var chartEssUsage =null;
					var chartPvUsage = null;
					if(reKepcoUsage != null) {
						chartEssUsage = reKepcoUsage+rePvUsage+reEssUsage
						chartPvUsage = reKepcoUsage+rePvUsage
					}
					
					var tm = new Date( convertDateUTC(loopCntChartList[i].std_timestamp) );
					// 차트데이터 셋팅
					dataSet.push([setChartDateUTC(loopCntChartList[i].std_timestamp) , reKepcoUsage]);
					dataSet2.push([setChartDateUTC(loopCntChartList[i].std_timestamp) , chartEssUsage]);
					dataSet3.push([setChartDateUTC(loopCntChartList[i].std_timestamp) , chartPvUsage]);
					
					if( (i+1) == loopCntChartList.length ) {
						if(reKepcoUsage != null) {
							nowUsage = reKepcoUsage;
						}
					}
					
				}
				pastUsageList = dataSet;
				essUsageList = dataSet2;
				pvUsageList = dataSet3;
				
//				if(kepcoUsageChartList.length > 0) {
					derChart.addSeries({
						index:3,
						fillOpacity: 1,
						name: '한전 사용량',
						color: '#3d4250',
						lineColor: '#438fd7', /* 한전 사용량 */
						data: pastUsageList
					}, false);
					
//				}
				
//				if(essUsageListChartList.length > 0) {
					derChart.addSeries({
						index: 2,
						fillOpacity: 0.5,
						name: 'ESS 사용량',
						color: '#13af67', /* ESS 사용량 */
						data: essUsageList
					}, false);
					
//				}
				
//				if(pvUsageListChartList.length > 0) {
					derChart.addSeries({
						index: 1,
						fillOpacity: 0.5,
						name: 'PV 사용량',
						color: '#f75c4a', /* PV 사용량 */
						data: pvUsageList
					}, false);
					
//				}
				
//			}
			
		}
		
		derChart.xAxis[0].options.tickInterval = /*24 **/ 60 * 60 * 1000;
		derChart.xAxis[0].options.labels.style.fontSize = '12px';
		
		derChart.redraw(); // 차트 데이터를 다시 그린다
		
		var total = totalDataSet+totalDataSet2+totalDataSet3;
		$("#nowUsage").empty().append(nowUsage+"kWh");
		
		$("#kepcoPer").empty().append( ( (totalDataSet == 0) ? 0 : ( (totalDataSet/total)*100 ).toFixed(2) )+"%" );
		$("#essPer").empty().append( ( (totalDataSet2 == 0) ? 0 : ( (totalDataSet2/total)*100 ).toFixed(2) )+"%" );
		$("#pvPer").empty().append( ( (totalDataSet3 == 0) ? 0 : ( (totalDataSet3/total)*100 ).toFixed(2) )+"%" );
		
	}

	var peakDataSet = []; // chartData를 위한 변수
	function getPeak(formData) {
		$.ajax({
			url : "/getPeak",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var totalUsage = result.totalUsage;
				var stdDate = result.stdDate;
				var startDate = result.startDate;
				
				// 데이터 셋팅
				var dt = new Date(startDate);
				var dt2 = new Date(stdDate);
				if( peakDataSet.length == 0 || (dt2.getMinutes() == 0 || dt2.getMinutes() == 15 || dt2.getMinutes() == 30 || dt2.getMinutes() == 45) ) {
					peakDataSet = [];
					for(var i=0; i<15; i++) {
						peakDataSet.push([ Date.UTC(dt.getFullYear(), dt.getMonth(), dt.getDate(), dt.getHours(), dt.getMinutes(), dt.getSeconds()), null]);
						dt = new Date(dt.setMinutes(dt.getMinutes() + 1));
					}
				}
				var map = convertUnitFormat(totalUsage, "mWh", 8);
				var formatNum = map.get("formatNum");
				var unit = map.get("unit");
				
				peakDataSet.push([ Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate(), dt2.getHours(), dt2.getMinutes(), dt2.getSeconds()), formatNum]);
				
				if(totalUsage == 0 || totalUsage == null) {
					$(".peak").find(".no-data").css("display", "");
					$(".peak").find(".inchart").css("display", "none");
					$(".peak").find(".chart_notice").css("display", "none");
				} else {
					$(".peak").find(".no-data").css("display", "none");
					$(".peak").find(".inchart").css("display", "");
					$(".peak").find(".chart_notice").css("display", "");
				}
				
			}
		});
		
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
		if(peakDataSet.length < 1) {
			$(".peak").find(".no-data").css("display", "");
			$(".peak").find(".inchart").css("display", "none");
			$(".peak").find(".chart_notice").css("display", "none");
		} else {
			$(".peak").find(".no-data").css("display", "none");
			$(".peak").find(".inchart").css("display", "");
			$(".peak").find(".chart_notice").css("display", "");
		}
		
		var seriesLength = peakChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				peakChart.series[i].remove();
		}
		peakChart.yAxis[0].removePlotLine('contract-power');
		peakChart.yAxis[0].removePlotLine('charge-power');
		
		peakChart.addSeries({
			name: '최대 피크 전력',
			color: '#438fd7', /* 최대 피크 전력 */
			type: 'column',
			data: peakDataSet
		}, false);
		
		peakChart.yAxis[0].addPlotLine({
		          color: '#13af67',
		          width: 1, 
		          value: contractPower,
		          label: {
		            text: '한전 계약 전력',
		            style: {
	                    color: '13af67',
	                    fontWeight: 'bold'
	                },
	                zIndex: 4
		          }, id: 'contract-power'
		  });
		
		peakChart.yAxis[0].addPlotLine({
		          color: '#f75c4a',
		          width: 1, 
		          value: chargePower,
		          label: {
		            text: '요금 적용 전력',
		            style: {
	                    color: 'f75c4a',
	                    fontWeight: 'bold'
	                },
                    align: 'right',
                    x: -10,
	                zIndex: 4
		          }, id: 'charge-power'
		  });
		
		peakChart.xAxis[0].options.tickInterval = 60 * 1000;
		peakChart.xAxis[0].options.labels.style.fontSize = '12px';
		
		peakChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	function chargePowerStrDisplayYn(today) {
		var holidayYn = chkHoliday(today); // 공휴일여부 체크(true:공휴일, false:평일or토요일)
		var chkSeason = checkSeason(today); // 1:봄, 2:여름, 3:가을, 4:겨울
		
		var chkHour = today.getHours();
		var timeTermStr = "";
		
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
		
		$(".chart_notice").empty();
		if(timeTermStr != "") 
			$(".chart_notice").empty().append("지금은 <strong>요금적용전력</strong> 갱신구간 입니다. "+"<span>"+timeTermStr+"</span>");
	}
	
	var essRevenueList;
	var pvRevenueList;
	var drRevenueList;
	function callback_getRevenueList(result) {
		var essRvList = result.essRevenueList;
		var pvRvList = result.pvRevenueList;
		var drRvList = result.drRevenueList;
		var loopCntList = result.loopCntList; // for문 loop list
		var loopGbn = result.loopGbn; // for문 loop 구분
//		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0;
		var totalDataSet3 = 0;
		var nowUsage = 0;
		
		if( essRvList == null && pvRvList == null && drRvList == null ) {
			$(".income").find(".no-data").css("display", "");
			$(".income").find(".inchart").css("display", "none");
			$(".income").find(".chart_footer").css("display", "none");
		} else {
			$(".income").find(".no-data").css("display", "none");
			$(".income").find(".inchart").css("display", "");
			$(".income").find(".chart_footer").css("display", "");
		}
		
		var seriesLength = incomeChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
			incomeChart.series[i].remove();
		}
		
		// ess 수익, pv 수익, dr 수익 중 하나라도 데이터가 존재할 때
		if( !( essRvList == null && pvRvList == null && drRvList == null ) ) {
//			if(usageList.length > 0) {
				for(var i=0; i<loopCntList.length; i++) {
					var essRevenue = null;
					var pvRevenue = null;
					var drRevenue = null;
					var reEssRevenue = 0;
					var rePvRevenue = 0;
					var reDrRevenue = 0;
					
					if(essRvList != null && essRvList.length > 0 && essRvList.length > i) { // ess 수익
//						essRevenue = String(essRvList[i].ess_incen);
						var essRevenue1 = ( String(essRvList[i].ess_chg_incen) == null ) ? null : String(essRvList[i].essChgIncen);
						var essRevenue2 = ( String(essRvList[i].ess_dischg_incen) == null ) ? null : String(essRvList[i].essDischgIncen);
						if( (essRevenue1 == null || essRevenue1 == "" || essRevenue1 == "null") && 
								(essRevenue2 == null || essRevenue2 == "" || essRevenue2 == "null") ) reEssRevenue = null;
						else {
							var _essRevenue1 = ( essRevenue1 == null ) ? 0 : Number(essRevenue1);
							var _essRevenue2 = ( essRevenue2 == null ) ? 0 : Number(essRevenue2);
							reEssRevenue = _essRevenue1+_essRevenue2;
							totalDataSet = totalDataSet+(_essRevenue1+_essRevenue2);
						}
						
					} else reEssRevenue = null;
					
					if(pvRvList != null && pvRvList.length > 0 && pvRvList.length > i) { // pv 수익
						pvRevenue = String(pvRvList[i].tot_price);
						if(pvRevenue == null || pvRevenue == "" || pvRevenue == "null") rePvRevenue = null;
						else {
							rePvRevenue = Number(     pvRevenue     ); // 나중에 수정 요망
							totalDataSet2 = totalDataSet2+Number(pvRevenue);
						}
					} else rePvRevenue = null;
					
					if(drRvList != null && drRvList.length > 0 && drRvList.length > i) { // dr 수익
						drRevenue = String(drRvList[i].total_reward_amt);
						if(drRevenue == null || drRevenue == "" || drRevenue == "null") reDrRevenue = null;
						else {
							reDrRevenue = Number(     drRevenue     ); // 나중에 수정 요망
							totalDataSet3 = totalDataSet3+Number(drRevenue);
						}
					} else reDrRevenue = null;
					
					var stdDt = "";
					var yyyyMM = "";
					if(loopGbn == "ess") {
//						yyyyMM = loopCntList[i].bill_yearm;
//						stdDt = Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1);
						yyyyMM = loopCntList[i].svcSdate;
						stdDt = Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, yyyyMM.substring(6, 8));
					} else if(loopGbn == "pv") {
						stdDt = loopCntList[i].std_timestamp;
					} else if(loopGbn == "dr") {
						yyyyMM = loopCntList[i].reduct_sdate;
						stdDt = Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, yyyyMM.substring(6, 8));
					}
					
					var tm = new Date( convertDateUTC(loopCntList[i].std_timestamp) );
					// 차트데이터 셋팅
					dataSet.push([setChartDateUTC(stdDt) , reEssRevenue]);
					dataSet2.push([setChartDateUTC(stdDt) , rePvRevenue]);
					dataSet3.push([setChartDateUTC(stdDt) , reDrRevenue]);
					
					if( (i+1) == loopCntList.length ) {
						if(reEssRevenue != null) {
							nowUsage = reEssRevenue;
						}
					}
					
				}
				essRevenueList = dataSet;
				pvRevenueList = dataSet2;
				drRevenueList = dataSet3;
				
//				if(essRvList != null && essRvList.length > 0) {
					incomeChart.addSeries({
						name: 'ESS 수익',
						color: '#438fd7', /* ESS 수익 */
						data: essRevenueList
					}, false);
					
//				}
				
//				if(pvRvList != null && pvRvList.length > 0) {
					incomeChart.addSeries({
						name: 'PV 수익',
						color: '#13af67', /* PV 수익 */
						data: pvRevenueList
					}, false);
					
//				}
				
//				if(drRvList != null && drRvList.length > 0) {
					incomeChart.addSeries({
						name: 'DR 수익',
						color: '#f75c4a', /* DR 수익 */
						data: drRevenueList
					}, false);
					
//				}
				
//			}
			
		}
		
		incomeChart.xAxis[0].options.tickInterval = 24 * 60 * 60 * 1000;
		incomeChart.xAxis[0].options.labels.style.fontSize = '6px';
		
		incomeChart.redraw(); // 차트 데이터를 다시 그린다
		
		var total = totalDataSet+totalDataSet2+totalDataSet3;
		$("#totalRv").empty().append(numberComma(total)+" won");
		
	}
	
	function callback_getDeviceList(result) {
		var deviceList = result.deviceList;

		if( deviceList.length < 1 || deviceList == null ) {
			$(".smain_device").find(".no-data").css("display", "");
			$(".smain_device").find(".device").css("display", "none");
			$(".smain_device").find(".paging").css("display", "none");
		} else {
			$(".smain_device").find(".no-data").css("display", "none");
			$(".smain_device").find(".device").css("display", "");
			$(".smain_device").find(".paging").css("display", "");
		}
		
		if(deviceList != null && deviceList.length > 0) {
			$div = $("#deviceList");
			$div.empty();
			for(var i=0; i<8; i++) {
				if(i >= deviceList.length) {
					$div.append( $('<li />') );
				} else {
					var strHtml = "";
					var memo = "";
					if(deviceList[i].device_type == 4 || deviceList[i].device_type == 6 || deviceList[i].device_type == 7 || deviceList[i].device_type == 8) {
						strHtml = (deviceList[i].apiStatus == 1) ? '<li class="ioe" />' : '<li class="ioe alert" />'; 
						memo = (deviceList[i].apiStatus == 1) ? "connect" : "disconnect";
					} else if(deviceList[i].device_type == 1) {
						strHtml = '<li class="pcs" />'; 
//						memo = Number(deviceList[i].ac_power)+Number(deviceList[i].dc_power);
						memo = Number(deviceList[i].apiPower);
					} else if(deviceList[i].device_type == 2) {
						strHtml = '<li class="bms" />';
//						memo = (deviceList[i].sys_soc == null || deviceList[i].sys_soc == "" || deviceList[i].sys_soc == "null") ? "" : deviceList[i].sys_soc+" %";
						memo = (deviceList[i].apiSoc == null || deviceList[i].apiSoc == "" || deviceList[i].apiSoc == "null") ? "" : deviceList[i].apiSoc+" %";
					} else if(deviceList[i].device_type == 3 || deviceList[i].device_type == 5) {
						strHtml = '<li class="pv" />';
						memo = deviceList[i].apiTotPower;
					} else {
						strHtml = (deviceList[i].apiStatus == 1) ? '<li class="ioe" />' : '<li class="ioe alert" />'; 
						memo = (deviceList[i].apiStatus == 1) ? "connect" : "disconnect";
					}
					$div.append(
							$(strHtml).append( $('<a href="#;" ondblclick="getDeviceDetail(\''+deviceList[i].site_id+"\', \'"+deviceList[i].device_id+"\', \'"+deviceList[i].device_type+'\');">')
							).append( $('<span class="dname" />').append( deviceList[i].device_name )
							).append( $('<span class="dmemo" />').append( memo )
							)
					);
					
				}
			}

			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "Device");
			
		}
	}
	
	function getDeviceDetail(siteId, deviceId, deviceType) {
		if(deviceType == 4 || deviceType == 6 || deviceType == 7 || deviceType == 8) {
			getDeviceIOEDetail(siteId, deviceId, deviceType);
		} else if(deviceType == 1) {
			getDevicePCSDetail(siteId, deviceId, deviceType);
		} else if(deviceType == 2) {
			getDeviceBMSDetail(siteId, deviceId, deviceType);
		} else if(deviceType == 3 || deviceType == 5) {
			getDevicePVDetail(siteId, deviceId, deviceType)
		} else {
			getDeviceIOEDetail(siteId, deviceId, deviceType);
		}
	}
	