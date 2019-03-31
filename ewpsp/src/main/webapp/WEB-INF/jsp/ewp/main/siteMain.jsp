<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	// 모니터링 변수 : setInterval()를 변수에 저장하면 나중에 clearInterval()를 이용해 중지시킬 수 있다
	var monitoring_cycle_10sec = null;
	var monitoring_cycle_1min = null;
	var monitoring_cycle_15min = null;
	var formData = null;
	
	$(document).ready(function() {
		$("#selPageNum").val(1);
		formData = getSiteMainSchCollection();
		
	//	var myTimer = setTimeout(function(){
			fn_cycle_10sec();
			fn_cycle_1min();
			fn_cycle_15min();
	//	}, (1000));
		
	//	clearTimeout(myTimer);
	
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
			}, (1000)); // 1000 = 1초, 5000 = 5초
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
		chargePowerStrDisplayYn(new Date());
		getPeak(formData);
		update_updtDataTime(new Date(), "updtTimePeak");
	}
	
	function fn_cycle_15min() {
		getDeviceList(1); // 장치현황 조회
		getESSChargeRealList(formData); // 실제충방전량 조회
		getESSChargeFutureList(formData); // 예측충방전량 조회
		drawData_chart_charge(); // 충방전량 차트그리기
		update_updtDataTime(new Date(), "updtTimeESS");
		getESSChargeSum(formData); // ess 충방전량 합계 조회
		getSoc(formData); // soc 잔량 조회
		getDERUsageList(formData); // 사용량구성 조회
		getRevenueList(formData); // 수익현황 조회
	}
	
	function getSiteMainSchCollection() {
	//	$("#timeOffset").val( (new Date()).getTimezoneOffset() );
		$("#timeOffset").val( timeOffset );
		
		var firstDay = new Date();
		var endDay = new Date();
		var startTime;
		var endTime;
		startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), 0, 0, 0);
		endTime = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), 23, 59, 59);
		
	//	var queryStart = new Date(startTime.setMinutes(startTime.getMinutes() + (new Date()).getTimezoneOffset()));
	//	var queryEnd = new Date(endTime.setMinutes(endTime.getMinutes() + (new Date()).getTimezoneOffset()));
		var queryStart = new Date(startTime.getTime());
		var queryEnd = new Date(endTime.getTime());
		queryStart = (queryStart == "") ? "" : queryStart.format("yyyyMMddHHmmss");
		queryEnd = (queryEnd == "") ? "" : queryEnd.format("yyyyMMddHHmmss");
		$("#selTermFrom").val(queryStart);
		$("#selTermTo").val(queryEnd);
		
		var monthFrom = new Date(firstDay.getFullYear(), firstDay.getMonth(), 1, 0, 0, 0);
		var monthTo = new Date(firstDay.getFullYear(), firstDay.getMonth(), (new Date(firstDay.getFullYear(), firstDay.getMonth(), 0)).getDate(), 23, 59, 59);
		var yearFrom = new Date(firstDay.getFullYear(), 0, 1, 0, 0, 0);
		var yearTo = new Date(firstDay.getFullYear(), 11, 31, 23, 59, 59);
		$("#monthFrom").val(monthFrom.format("yyyyMMddHHmmss"));
		$("#monthTo").val(monthTo.format("yyyyMMddHHmmss"));
		$("#yearFrom").val(yearFrom.format("yyyyMMddHHmmss"));
		$("#yearTo").val(yearTo.format("yyyyMMddHHmmss"));
		
		var formData = $("#schForm").serializeObject();
		return formData;
	}
	
	function callback_getAlarmList(result) {
		var dvTpAlarmDetail = result.detail;
		var dvTpAlarmDetail2 = result.detail2;
		var alarmList = result.alarmList;
		
		$("#todayTotalAlarmCnt").html(dvTpAlarmDetail.total_cnt);
		$("#todayAlarmCnt").html(dvTpAlarmDetail2.alert_cnt);
		$("#todayWarninfCnt").html(dvTpAlarmDetail2.warning_cnt);
		if(dvTpAlarmDetail.notCfm_cnt == 0) {
			$(".no").find('span').hide();
		} else {
			$(".no").find('span').show();
			$(".no").empty().append( '<span>'+dvTpAlarmDetail.notCfm_cnt+'</span>');
		}
		
		var str = "";
		if(alarmList == null || alarmList.length < 1) {
			str += '<li>';
			str += '	<a href="#;">조회 결과가 없습니다.</a>';
			str += '</li>';
		} else {
			for(var i=0; i<alarmList.length; i++) {
				var tm = new Date( convertDateUTC(alarmList[i].std_date) );
				str += '<li>';
				str += '	<a href="#;">'+alarmList[i].alarm_msg+'</a>';
				str += '	<span>'+tm.format("yyyy-MM-dd HH:mm:ss")+'</span>';
				str += '</li>';
			}
			$(".alarm_notice").find("ul").html(str);
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
					reChgVal = toFixedNum(chgVal, 2);
					totalDataSet = totalDataSet+reChgVal;
				}
				if(dischgVal == null || dischgVal == "" || dischgVal == "null") reDischgVal = null;
				else {
					reDischgVal   = toFixedNum(dischgVal, 2);
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
					reChgVal = toFixedNum(chgVal, 2);
					totalDataSet = totalDataSet+reChgVal;
				}
				if(dischgVal == null || dischgVal == "" || dischgVal == "null") reDischgVal = null;
				else {
					reDischgVal   = toFixedNum(dischgVal, 2);
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
		
	//	setTickInterval();
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
				
				$("#todayCrg").empty().append( numberComma(Math.abs(toFixedNum(todaySum.chg_val_sum, 2)))+" kWh" );
				$("#todayDiscrg").empty().append( numberComma(Math.abs(toFixedNum(todaySum.dischg_val_sum, 2)))+" kWh" );
				$("#todayRevenue").empty().append( numberComma(Math.abs(toFixedNum(todaySum.ess_revenue_sum, 2))) );
				$("#monthCrg").empty().append( numberComma(Math.abs(toFixedNum(monthSum.chg_val_sum, 2)))+" kWh" );
				$("#monthDiscrg").empty().append( numberComma(Math.abs(toFixedNum(monthSum.dischg_val_sum, 2)))+" kWh" );
				$("#monthRevenue").empty().append( numberComma(Math.abs(toFixedNum(monthSum.ess_revenue_sum, 2))) );
				$("#yearCrg").empty().append( numberComma(Math.abs(toFixedNum(yearSum.chg_val_sum, 2)))+" kWh" );
				$("#yearDiscrg").empty().append( numberComma(Math.abs(toFixedNum(yearSum.dischg_val_sum, 2)))+" kWh" );
				$("#yearRevenue").empty().append( numberComma(Math.abs(toFixedNum(yearSum.ess_revenue_sum, 2))) );
				
				var chgValSum = Number(todaySum.chg_val_sum);
				var dischgValSum = Number(todaySum.dischg_val_sum);
				
				var chgPer = 0;
				var chgVal = numberComma(Math.abs(toFixedNum(todaySum.chg_val_sum, 2)));
				var dischgPer = 0;
				var dischgVal = numberComma(Math.abs(toFixedNum(todaySum.dischg_val_sum, 2)));
				
				if(Math.abs(totalFetureChg) > 0) {
					chgPer = Math.abs(numOfTotal_per(totalFetureChg, chgValSum));
				} else {
					chgPer = 100;
				}
				if(Math.abs(totalFetureDischg) > 0) {
					dischgPer = Math.abs(numOfTotal_per(totalFetureDischg, dischgValSum));
				} else {
					dischgPer = 100;
				}
				
				$("#socTodayCrg").empty().append( numberComma(chgVal) ).append(' <em>kWh</em>');
				$("#socTodayDiscrg").empty().append( numberComma(dischgVal) ).append(' <em>kWh</em>');
				if(chgPer > 0) $(".today_charge").find("span").css("width", chgPer+"%");
				if(dischgPer > 0) $(".today_discharge").find("span").css("width", dischgPer+"%");
				
			}
		});
	}
	
	function getSoc(formData) {
		$.ajax({
			url : "/getSoc",
			type : 'post',
	//		async : false, // 동기로 처리해줌
			async : true,
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
				
				update_updtDataTime(new Date(), "updtTimeSOC");
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
	//		if(loopCntChartList.length > 0) {
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
							var map = convertUnitFormat(kepcoUsage, "mWh", 8);
							reKepcoUsage = toFixedNum(map.get("formatNum"), 2);
							totalDataSet = totalDataSet+Number(kepcoUsage);
						}
						
					} else reKepcoUsage = null;
					
					if(essUsageListChartList != null && essUsageListChartList.length > 0 && essUsageListChartList.length > i) { // ESS 사용량
						essUsage = String(essUsageListChartList[i].usg_val);
						if(essUsage == null || essUsage == "" || essUsage == "null") reEssUsage = null;
						else {
							var map = convertUnitFormat(essUsage, "kWh", 1);
							reEssUsage = toFixedNum(map.get("formatNum"), 2);
							totalDataSet2 = totalDataSet2+Number(essUsage);
						}
					} else reEssUsage = null;
					
					if(pvUsageListChartList != null && pvUsageListChartList.length > 0 && pvUsageListChartList.length > i) { // PV 사용량
						pvUsage = String(pvUsageListChartList[i].gen_val);
						if(pvUsage == null || pvUsage == "" || pvUsage == "null") rePvUsage = null;
						else {
							var map = convertUnitFormat(pvUsage, "kWh", 1);
							rePvUsage = toFixedNum(map.get("formatNum"), 2);
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
				
				if( kepcoUsageChartList !=null && kepcoUsageChartList.length > 0) {
					derChart.addSeries({
						index:3,
						fillOpacity: 0,
						name: '한전 사용량',
						color: '#438fd7',
						lineColor: '#438fd7', /* 한전 사용량 */
						data: pastUsageList
					}, false);
					
				}
				
				if( essUsageListChartList != null && essUsageListChartList.length > 0) {
					derChart.addSeries({
						index: 2,
						fillOpacity: 0.5,
						name: 'ESS 사용량',
						color: '#13af67', /* ESS 사용량 */
						data: essUsageList
					}, false);
					
				}
				
				if( pvUsageListChartList !=null && pvUsageListChartList.length > 0) {
					derChart.addSeries({
						index: 1,
						fillOpacity: 0.5,
						name: 'PV 사용량',
						color: '#f75c4a', /* PV 사용량 */
						data: pvUsageList
					}, false);
					
				}
				
	//		}
			
		}
		
		derChart.xAxis[0].options.tickInterval = /*24 **/ 60 * 60 * 1000;
		derChart.xAxis[0].options.labels.style.fontSize = '12px';
		
		derChart.redraw(); // 차트 데이터를 다시 그린다
		
		var total = totalDataSet+totalDataSet2+totalDataSet3;
		$("#nowUsage").empty().append(nowUsage+"kWh");
		
		$("#kepcoPer").empty().append( ( (totalDataSet == 0) ? 0 : ( (totalDataSet/total)*100 ).toFixed(2) )+"%" );
		$("#essPer").empty().append( ( (totalDataSet2 == 0) ? 0 : ( (totalDataSet2/total)*100 ).toFixed(2) )+"%" );
		$("#pvPer").empty().append( ( (totalDataSet3 == 0) ? 0 : ( (totalDataSet3/total)*100 ).toFixed(2) )+"%" );
		
		update_updtDataTime(new Date(), "updtTimeDER");
	}
	
	var peakDataSet = []; // chartData를 위한 변수
	var contractPowerDataSet = []; // chartData를 위한 변수
	var chargePowerDataSet = []; // chartData를 위한 변수
	function getPeak(formData) {
		$.ajax({
			url : "/getPeak",
			type : 'post',
	//		async : false, // 동기로 처리해줌
			async : true,
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
					contractPowerDataSet = [];
					chargePowerDataSet = [];
					for(var i=0; i<15; i++) {
						peakDataSet.push([ Date.UTC(dt.getFullYear(), dt.getMonth(), dt.getDate(), dt.getHours(), dt.getMinutes(), dt.getSeconds()), null]);
						contractPowerDataSet.push([ Date.UTC(dt.getFullYear(), dt.getMonth(), dt.getDate(), dt.getHours(), dt.getMinutes(), dt.getSeconds()), contractPower]);
						chargePowerDataSet.push([ Date.UTC(dt.getFullYear(), dt.getMonth(), dt.getDate(), dt.getHours(), dt.getMinutes(), dt.getSeconds()), chargePower]);
						dt = new Date(dt.setMinutes(dt.getMinutes() + 1));
					}
				}
				var map = convertUnitFormat((totalUsage*4), "mWh", 8);
				var formatNum = map.get("formatNum");
				var unit = map.get("unit");
				
				peakDataSet.push([ Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate(), dt2.getHours(), dt2.getMinutes(), dt2.getSeconds()), toFixedNum(formatNum, 2)]);
				
				if(totalUsage == 0 || totalUsage == null) {
					$(".peak").find(".no-data").css("display", "");
					$(".peak").find(".inchart").css("display", "none");
					$(".peak").find(".chart_notice").css("display", "none");
				} else {
					$(".peak").find(".no-data").css("display", "none");
					$(".peak").find(".inchart").css("display", "");
					$(".peak").find(".chart_notice").css("display", "");
				}
				drawData_chart_peak(); // 피크전력현황 차트그리기
			}
		});
		
	}
	
	//var contractPower;
	//var chargePower;
	//function callback_getSiteSetDetail(result) {
	//	var siteSetDetail = result.detail;
	//	contractPower = siteSetDetail.contract_power;
	//	chargePower = siteSetDetail.charge_power;
	//}
	
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
		
		peakChart.addSeries({
			name: '최대 피크 전력',
			color: '#438fd7', /* 최대 피크 전력 */
			type: 'column',
			data: peakDataSet
		}, false);
		
		if(chargePowerDisplayYn == "Y") {
			peakChart.addSeries({
				name: '한전 계약 전력',
				color: '#13af67', /* 한전 계약 전력 */
				data: contractPowerDataSet
			}, false);
			
			peakChart.addSeries({
				name: '요금 적용 전력',
				color: '#f75c4a', /* 요금 적용 전력 */
				data: chargePowerDataSet
			}, false);
		}
		
		peakChart.xAxis[0].options.tickInterval = 60 * 1000;
		peakChart.xAxis[0].options.labels.style.fontSize = '12px';
		
		peakChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	var chargePowerDisplayYn = "";
	function chargePowerStrDisplayYn(today) {
		$(".chart_notice").html("<strong>요금적용전력</strong> 제외시간 "+"<span>"+"(23:00 ~ 09:00)"+"</span>");
	//	var holidayYn = chkHoliday(today); // 공휴일여부 체크(true:공휴일, false:평일or토요일)
	//	var chkSeason = checkSeason(today); // 1:봄, 2:여름, 3:가을, 4:겨울
	//	chargePowerDisplayYn = "Y";
	//	
	//	var chkHour = today.getHours();
	//	var timeTermStr = "";
	//	
	//	if(!holidayYn) {
	//		if(chkSeason == 1 || chkSeason == 3) {
	//			// 중간부하시간대
	//			if( (chkHour>=9 && chkHour<10) )  timeTermStr = "(09:00 ~ 10:00)"; 
	//			if( (chkHour>=12 && chkHour<13) ) timeTermStr = "(12:00 ~ 13:00)";
	//			if( (chkHour>=17 && chkHour<23) ) timeTermStr = "(17:00 ~ 23:00)";
	//			
	//			// 최대부하시간대
	//			if( (chkHour>=10 && chkHour<12) ) timeTermStr = "(10:00 ~ 12:00)"; 
	//			if( (chkHour>=13 && chkHour<17) ) timeTermStr = "(13:00 ~ 17:00)";
	//			
	//			if( (chkHour>=23 || chkHour<9) ) chargePowerDisplayYn = "N";
	//			
	//		} else if(chkSeason == 2) {
	//			// 중간부하시간대
	//			if( (chkHour>=9 && chkHour<10) )  timeTermStr = "(09:00 ~ 10:00)"; 
	//			if( (chkHour>=12 && chkHour<13) ) timeTermStr = "(12:00 ~ 13:00)";
	//			if( (chkHour>=17 && chkHour<23) ) timeTermStr = "(17:00 ~ 23:00)";
	//			
	//			// 최대부하시간대
	//			if( (chkHour>=10 && chkHour<12) ) timeTermStr = "(10:00 ~ 12:00)"; 
	//			if( (chkHour>=13 && chkHour<17) ) timeTermStr = "(13:00 ~ 17:00)";
	//			
	//			if( (chkHour>=23 || chkHour<9) ) chargePowerDisplayYn = "N";
	//			
	//		} else if(chkSeason == 4) {
	//			// 중간부하시간대
	//			if( (chkHour>=9 && chkHour<10) )  timeTermStr = "(09:00 ~ 10:00)"; 
	//			if( (chkHour>=12 && chkHour<17) ) timeTermStr = "(12:00 ~ 17:00)";
	//			if( (chkHour>=20 && chkHour<22) ) timeTermStr = "(20:00 ~ 22:00)";
	//			
	//			// 최대부하시간대
	//			if( (chkHour>=10 && chkHour<12) ) timeTermStr = "(10:00 ~ 12:00)"; 
	//			if( (chkHour>=17 && chkHour<20) ) timeTermStr = "(17:00 ~ 20:00)";
	//			if( (chkHour>=22 && chkHour<23) ) timeTermStr = "(22:00 ~ 23:00)";
	//			
	//			if( (chkHour>=23 || chkHour<9) ) chargePowerDisplayYn = "N";
	//			
	//		}
	//	}
	//	
	//	$(".chart_notice").empty();
	////	if(timeTermStr != "") 
	////		$(".chart_notice").append("지금은 <strong>요금적용전력</strong> 갱신구간 입니다. "+"<span>"+timeTermStr+"</span>");
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
	//	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0;
		var totalDataSet3 = 0;
		var nowUsage = 0;
		
	//	if( essRvList == null && pvRvList == null && drRvList == null ) {
		if( loopCntList == null ) {
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
		if( !(loopCntList == null) ) {
	//	if( !( essRvList == null && pvRvList == null && drRvList == null ) ) {
			if(loopCntList != null && loopCntList.length > 0) {
				for(var i=0; i<loopCntList.length; i++) {
					var essRevenue = null;
					var pvRevenue = null;
					var drRevenue = null;
					var reEssRevenue = 0;
					var rePvRevenue = 0;
					var reDrRevenue = 0;
					
					if(essRvList != null && essRvList.length > 0 && essRvList.length > i) { // ess 수익
	//					essRevenue = String(essRvList[i].ess_incen);
						var essRevenue1 = ( String(essRvList[i].ess_chg_incen) == null ) ? null : String(essRvList[i].ess_chg_incen);
						var essRevenue2 = ( String(essRvList[i].ess_dischg_incen) == null ) ? null : String(essRvList[i].ess_dischg_incen);
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
	////					yyyyMM = loopCntList[i].bill_yearm;
	////					stdDt = Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1);
	//					yyyyMM = loopCntList[i].svcSdate;
	//					stdDt = Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, yyyyMM.substring(6, 8));
						stdDt = loopCntList[i].svc_stimestamp;
					} else if(loopGbn == "pv") {
						stdDt = loopCntList[i].std_timestamp;
					} else if(loopGbn == "dr") {
						yyyyMM = loopCntList[i].reduct_sdate;
						stdDt = Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, yyyyMM.substring(6, 8));
					}
					
					var tm = new Date( convertDateUTC(loopCntList[i].std_timestamp) );
					// 차트데이터 셋팅
					if(essRvList != null && essRvList.length > 0 && essRvList.length > i) dataSet.push([setChartDateUTC(stdDt) , reEssRevenue]);
					if(pvRvList != null && pvRvList.length > 0 && pvRvList.length > i) dataSet2.push([setChartDateUTC(stdDt) , rePvRevenue]);
					if(drRvList != null && drRvList.length > 0 && drRvList.length > i) dataSet3.push([setChartDateUTC(stdDt) , reDrRevenue]);
					
					if( (i+1) == loopCntList.length ) {
						if(reEssRevenue != null) {
							nowUsage = reEssRevenue;
						}
					}
					
				}
				essRevenueList = dataSet;
				pvRevenueList = dataSet2;
				drRevenueList = dataSet3;
				
				if(essRvList != null && essRvList.length > 0) {
					incomeChart.addSeries({
						name: 'ESS 수익',
						color: '#438fd7', /* ESS 수익 */
						data: essRevenueList
					}, false);
					
				}
				
				if(pvRvList != null && pvRvList.length > 0) {
					incomeChart.addSeries({
						name: 'PV 수익',
						color: '#13af67', /* PV 수익 */
						data: pvRevenueList
					}, false);
					
				}
				
				if(drRvList != null && drRvList.length > 0) {
					incomeChart.addSeries({
						name: 'DR 수익',
						color: '#f75c4a', /* DR 수익 */
						data: drRevenueList
					}, false);
					
				}
				
			}
			
		}
		
		incomeChart.xAxis[0].options.tickInterval = 24 * 60 * 60 * 1000;
		incomeChart.xAxis[0].options.labels.style.fontSize = '6px';
		
		incomeChart.redraw(); // 차트 데이터를 다시 그린다
		
		var total = totalDataSet+totalDataSet2+totalDataSet3;
		$("#totalRv").empty().append(numberComma(total)+" won");
		
		update_updtDataTime(new Date(), "updtTimeRevenue");
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
	//					memo = Number(deviceList[i].ac_power)+Number(deviceList[i].dc_power);
						memo = Number(deviceList[i].apiPower);
					} else if(deviceList[i].device_type == 2) {
						strHtml = '<li class="bms" />';
	//					memo = (deviceList[i].sys_soc == null || deviceList[i].sys_soc == "" || deviceList[i].sys_soc == "null") ? "" : deviceList[i].sys_soc+" %";
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
		
		update_updtDataTime(new Date(), "updtTimeDevice");
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
</script>
<script src="../js/device/deviceDetailPopup.js" type="text/javascript"></script>
</head>
<body>

	<!-- 메인페이지용 스타일 파일 -->
	<link href="../css/main.css" rel="stylesheet">

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="siteMain" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">${selViewSite.site_name }</h1>
					</div>
				</div>
				<form id="schForm" name="schForm">
				<input type="hidden" id="selTermFrom" name="selTermFrom">
				<input type="hidden" id="selTermTex" name="selTermTex">
				<input type="hidden" id="selTermTo" name="selTermTo">
				<input type="hidden" id="selTerm" name="selTerm" value="today">
				<input type="hidden" id="selPeriodVal" name="selPeriodVal" value="hour">
				<input type="hidden" id="siteId" name="siteId" value="${selViewSiteId }">
				<input type="hidden" id="selPageNum" name="selPageNum" value="">
				<input type="hidden" id="timeOffset" name="timeOffset">
				<input type="hidden" id="monthFrom" name="monthFrom">
				<input type="hidden" id="monthTo" name="monthTo">
				<input type="hidden" id="yearFrom" name="yearFrom">
				<input type="hidden" id="yearTo" name="yearTo">
				</form>
				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv alarm">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/control'" style="cursor: pointer;">알람</h2>
										<div class="fr today_alarm">
											<div class="total">금일발생 <span id="todayTotalAlarmCnt">0</span></div>
											<div class="no"><span style="display: none;">0</span></div>
										</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>알람 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->
									<div class="alarm_stat mt10 clear">
										<div class="a_alert clear">
											<span>ALERT</span> <em id="todayAlarmCnt">0</em>
										</div>
										<div class="a_warning clear">
											<span>WARNING</span> <em id="todayWarninfCnt">0</em>
										</div>
									</div>
									<div class="alarm_notice">
										<h2>최근 알람</h2>
										<ul>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_soc">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/essCharge'" style="cursor: pointer;">SOC (잔량)</h2>
										<div class="time fr" id="updtTimeSOC">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>SOC 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->
									<div class="soc mt15 clear">
										<div class="batt_wrap fl">
											<div class="battery"><span>잔량</span></div>
											<div class="battery_per"></div>
										</div>
										<div class="charge_dis fr">
											<dl>
												<dt>오늘 충전량 <span id="socTodayCrg">0<em>kWh</em></span></dt>
												<dd>
													<div class="today_charge"><span style="width:0%;">충전량</span></div>
												</dd>
											</dl>
											<dl>
												<dt>오늘 방전량 <span id="socTodayDiscrg">0<em>kWh</em></span> </dt>
												<dd>
													<div class="today_discharge"><span style="width:0%;">방전량</span></div>
												</dd>
											</dl>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv der">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/derUsage'" style="cursor: pointer;">사용량 구성 (DER)</h2>
										<div class="time fr" id="updtTimeDER">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>사용량 구성 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->	
									<div class="inchart">
										<div id="der_chart" style="height:220px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var derChart = Highcharts.chart('der_chart', {
// 												data: {
// 											        table: 'der_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
													backgroundColor: 'transparent',
													type: 'area'
												},

												navigation: {
													buttonOptions: {
													  enabled: false /* 메뉴 안보이기 */
													  }
												},

											    title: {
											        text: ''
											    },

											    subtitle: {
											        text: ''
											    },

												xAxis: {
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
// 													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
													, endOnTick: true // 11.09 이우람 추가
												},

												yAxis: {
													gridZIndex: 4, // 09.10 이우람 추가
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    min: 0, /* 최소값 지정 */
												    title: {
												    	text: '(kWh)',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
												        fontSize: '12px',
												        fontWeight: 400
												    },
												    itemHoverStyle: {
												        color: '' /* 마우스 오버시 색 */
												    },
												    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
												    symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' kwh</span>';
											            }
												},

												/* 옵션 */
												plotOptions: {
													area: {
											            stacking: 'normal',
													},
											        series: {
											            label: {
											                connectorAllowed: false
											            },
											            marker: {
															enabled: false
														}, // 09.11 이우람 추가
											            borderWidth: 0 /* 보더 0 */
											        },
											        line: {
													    marker: {
													         enabled: false /* 마커 안보이기 */
													    }
													}
											    },

												/* 출처 */
												credits: {
													enabled: false
												},

												/* 그래프 스타일 */
											    series: [{
											    	name: 'PV 사용량',
											        color: '#f75c4a' /* PV 사용량 */
											    },{
											    	name: 'ESS 사용량',
											        color: '#13af67' /* ESS 사용량 */
											    },{
											    	name: '한전 사용량',
											    	color: '#438fd7' /* 한전 사용량 */
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
												        },
												        chartOptions: {
												        	chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															yAxis: {
																title: {
															        style: {
															            fontSize: '18px'
															        }
															    },
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															legend: {									
																itemStyle: {
															        fontSize: '18px'
															    },
															    symbolPadding:5,
															    symbolHeight:10
															}
												        }
												    }]
												}

											});
// 										});
										</script>
									</div>
									<div class="chart_footer">
										<ul class="clear">
											<li>현재 사용량 <span id="nowUsage">0kWh</span></li>
											<li>한전 <span id="kepcoPer">0%</span></li>
											<li>ESS <span id="essPer">0%</span></li>
											<li>PV <span id="pvPer">0%</span></li>
										</ul>
									</div>
								</div>
							</div>
						</div>				
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv peak">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/peak'" style="cursor: pointer;">피크전력현황</h2>
										<div class="time fr" id="updtTimePeak">2018-08-12 11:41:26</div>
									</div>
									<!-- <div class="chart_notice">지금은 <strong>요금적용전력</strong> 갱신구간 입니다. <span>(08:00 ~ 12:00)</span></div> -->
									<div class="chart_notice"><strong>요금적용전력</strong> 제외시간 <span>(23:00 ~ 09:00)</span></div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>피크전력현황 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->									
									<div class="inchart">
										<div id="peak_chart" style="height:250px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var peakChart = Highcharts.chart('peak_chart', {
// 												data: {
// 											        table: 'peak_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
													backgroundColor: 'transparent',
													type: 'line'
												},

												navigation: {
													buttonOptions: {
													  enabled: false /* 메뉴 안보이기 */
													  }
												},

											    title: {
											        text: ''
											    },

											    subtitle: {
											        text: ''
											    },

												xAxis: {
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    min: 0, /* 최소값 지정 */
												    title: {
												    	text: '(kW)',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
												        fontSize: '12px',
												        fontWeight: 400
												    },
												    itemHoverStyle: {
												        color: '' /* 마우스 오버시 색 */
												    },
												    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
												    symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' kW</span>';
											            }
												},

												/* 옵션 */
												plotOptions: {
											        series: {
											            label: {
											                connectorAllowed: false
											            },
											            borderWidth: 0 /* 보더 0 */
											        },
											        line: {
													    marker: {
													         enabled: false /* 마커 안보이기 */
													    }
													}
											    },

												/* 출처 */
												credits: {
													enabled: false
												},

												/* 그래프 스타일 */
											    series: [{
											        name: '최대 피크 전력',
											    	color: '#438fd7', /* 최대 피크 전력 */
											        type: 'column'
//											    },{
//											    	name: '한전 계약 전력',
//											    	color: '#13af67' /* 한전 계약 전력 */
//											    },{
//											    	name: '요금 적용 전력',
//											    	color: '#f75c4a' /* 요금 적용 전력 */
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
												        },
												        chartOptions: {
												        	chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															yAxis: {
																title: {
															        style: {
															            fontSize: '18px'
															        }
															    },
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															legend: {									
																itemStyle: {
															        fontSize: '18px'
															    },
															    symbolPadding:5,
															    symbolHeight:10
															}
												        }
												    }]
												}

											});
// 										});
										</script>
									</div>									
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv smain_device">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/deviceMonitoring?deviceGbn=IOE'" style="cursor: pointer;">장치현황</h2>
										<div class="time fr" id="updtTimeDevice">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>장치현황 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->	
									<ul class="device clear" id="deviceList">
									</ul>
									<div class="paging clear" id="DevicePaging">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv income">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/essRevenue'" style="cursor: pointer;">수익현황</h2>
										<div class="time fr" id="updtTimeRevenue">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display: none;">
										<span>수익현황 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->										
									<div class="inchart">
										<div id="income_chart" style="height:252px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var incomeChart = Highcharts.chart('income_chart', {
// 												data: {
// 											        table: 'income_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
													backgroundColor: 'transparent',
													type: 'column'
												},

												navigation: {
													buttonOptions: {
													  enabled: false /* 메뉴 안보이기 */
													  }
												},

											    title: {
											        text: ''
											    },

											    subtitle: {
											        text: ''
											    },

												xAxis: {
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    min: 0, /* 최소값 지정 */
												    title: {
												    	text: 'won',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
												        fontSize: '12px',
												        fontWeight: 400
												    },
												    itemHoverStyle: {
												        color: '' /* 마우스 오버시 색 */
												    },
												    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
												    symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' won</span>';
											            }
												},

												/* 옵션 */
												plotOptions: {
											        series: {
											            label: {
											                connectorAllowed: false
											            },
											            borderWidth: 0 /* 보더 0 */
											        },
											        line: {
													    marker: {
													         enabled: false /* 마커 안보이기 */
													    }
													},
													column: {
														  stacking: 'normal' /*위로 쌓이는 막대  ,normal */
													}
											    },

												/* 출처 */
												credits: {
													enabled: false
												},

												/* 그래프 스타일 */
											    series: [{
											    	name: 'ESS 수익',
											    	color: '#438fd7' /* ESS 수익 */
											    },{
											    	name: 'DR 수익',
											        color: '#13af67' /* DR 수익 */
											    },{
											    	name: 'PV 수익',
											        color: '#f75c4a' /* PV 수익 */
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
												        },
												        chartOptions: {
												        	chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															yAxis: {
																title: {
															        style: {
															            fontSize: '18px'
															        }
															    },
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															legend: {									
																itemStyle: {
															        fontSize: '18px'
															    },
															    symbolPadding:5,
															    symbolHeight:10
															}
												        }
												    }]
												}

											});
// 										});
										</script>
									</div>
									<div class="chart_footer">
										<ul class="clear">
											<li>전체수익 <span id="totalRv">0 won</span></li>
										</ul>
									</div>									
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv charge">
									<div class="chart_top clear">
										<h2 class="ntit fl" ondblclick="javascript:location.href='/essCharge'" style="cursor: pointer;">충/방전량</h2>
										<div class="time fr" id="updtTimeESS">2018-08-12 11:41:26</div>
									</div>
									<!-- no-data { -->
									<div class="no-data" style="display:none;">
										<span>충/방전량 정보를 가져올 수 없습니다.</span>
									</div>
									<!-- } no-data -->								
									<div class="inchart">
										<div id="charge_chart" style="height:226px;"></div>
										<script language="JavaScript"> 
// 										$(function () { 
											var chargeChart = Highcharts.chart('charge_chart', {
// 												data: {
// 											        table: 'charge_datatable' /* 테이블에서 데이터 불러오기 */
// 											    },

												chart: {
													marginTop:50,
													marginLeft:50,
													marginRight:0,
													backgroundColor: 'transparent',
													type: 'column'
												},

												navigation: {
													buttonOptions: {
													  enabled: false /* 메뉴 안보이기 */
													  }
												},

											    title: {
											        text: ''
											    },

											    subtitle: {
											        text: ''
											    },

												xAxis: {
													type: 'datetime', // 08.20 이우람 추가
													dateTimeLabelFormats: { // 08.20 이우람 추가
														millisecond: '%H:%M:%S.%L',
													    second: '%H:%M:%S',
											            minute: '%H:%M',
											            hour: '%H',
											            day: '%m.%d ',
											            week: '%m.%e',
											            month: '%y/%m',
											            year: '%Y'
											        },
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
												    title: {
												    	text: '(kWh)',
												    	align: 'low',
												    	rotation: 0, /* 타이틀 기울기 */
												        y:25, /* 타이틀 위치 조정 */
												        x:10,
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    },
												    labels: {
												        overflow: 'justify',
												        x:-10, /* 그래프와의 거리 조정 */
												        style: {
												            color: '#fff',
												            fontSize: '12px'
												        }
												    }
												},									    

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-20,										
													itemStyle: {
												        color: '#fff',
												        fontSize: '12px',
												        fontWeight: 400
												    },
												    itemHoverStyle: {
												        color: '' /* 마우스 오버시 색 */
												    },
												    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
												    symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													    formatter: function() {
											                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
											                	+ '<br/><span style="color:#438fd7">' + this.y + ' kWh</span>';
											            }
												},

												/* 옵션 */
												plotOptions: {
											        series: {
											            label: {
											                connectorAllowed: false
											            },
											            borderWidth: 0 /* 보더 0 */
											        },
											        line: {
													    marker: {
													         enabled: false /* 마커 안보이기 */
													    }
													}
											    },

												/* 출처 */
												credits: {
													enabled: false
												},

												/* 그래프 스타일 */
											    series: [{
											    	type: 'column',
											        name: '충전량',
											        color: '#438fd7'
											    },{
											    	type: 'line',
											        name: '충전 계획',
											        color: '#13af67',
											        dashStyle: 'ShortDash'
											    },{
											    	type: 'column',
											        name: '방전량',
											        color: '#f75c4a'
											    },{
											    	type: 'line',
											        name: '방전 계획',
											        color: '#84848f',
											        dashStyle: 'ShortDash'
											    }],

											    /* 반응형 */
												responsive: {
												    rules: [{
												        condition: {
												            minWidth: 842 /* 차트 사이즈 */									                
												        },
												        chartOptions: {
												        	chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															yAxis: {
																title: {
															        style: {
															            fontSize: '18px'
															        }
															    },
																labels: {
															        style: {
															            fontSize: '18px'
															        }
																}
															},
															legend: {									
																itemStyle: {
															        fontSize: '18px'
															    },
															    symbolPadding:5,
															    symbolHeight:10
															}
												        }
												    }]
												}

											});
// 										});
										</script>
									</div>
									<div class="chart_footer">
										<div class="chart_table">
											<table class="main_use">
												<thead>
													<tr>
														<th>충/방전량</th>
														<th>충전량</th>
														<th>방전량</th>
														<th>수익</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<th>TODAY</th>
														<td id="todayCrg">0 kWh</td>
														<td id="todayDiscrg">0 kWh</td>
														<td id="todayRevenue">0</td>
													</tr>
													<tr>
														<th>THIS MONTH</th>
														<td id="monthCrg">0 MWh</td>
														<td id="monthDiscrg">0 MWh</td>
														<td id="monthRevenue">0</td>
													</tr>
													<tr>
														<th>THIS YEAR</th>
														<td id="yearCrg">0 MWh</td>
														<td id="yearDiscrg">0 MWh</td>
														<td id="yearRevenue">0</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>									
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>


<jsp:include page="../include/popup/deviceDetailPopup.jsp" />
<%-- <jsp:include page="../include/popup/serviceInfo.jsp" /> --%>



</body>
</html>