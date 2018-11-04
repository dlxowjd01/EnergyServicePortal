
// 조회기간 선택
var SelTerm = "";
function changeSelTerm(gubun) {
	$("#selTerm").val(gubun);
	$("#sp_1min").show();
	$("#sp_15min").show();
	$("#sp_30min").show();
	$("#sp_1hour").show();
	$("#sp_1day").show();
	$("#sp_1month").show();
	
	$("#datepicker1, #datepicker2, #datepicker5").val("").attr("disabled", true);
	var $selTermBox = $("#selTermBox");
	var $selPeriod = $("#selPeriod");
	if(gubun == '15min') { // 15분(현재 안나옴)
		$selPeriod.empty().append("1분").append( $('<span class="caret" />') );
		$("#sp_15min").hide();
		$("#sp_30min").hide();
		$("#sp_1hour").hide();
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('1min');
	} else if(gubun == '30min') { // 30분
		$selPeriod.empty().append("15분").append( $('<span class="caret" />') );
		$("#sp_30min").hide();
		$("#sp_1hour").hide();
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('15min');
	} else if(gubun == 'hour') { // 1시간
		$selPeriod.empty().append("15분").append( $('<span class="caret" />') );
		$("#sp_1hour").hide();
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('15min');
	} else if(gubun == 'day') { // 오늘
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('hour');
	} else if(gubun == 'week') { // 1주
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('hour');
	} else if(gubun == 'month') { // 1달
		$selPeriod.empty().append("1일").append( $('<span class="caret" />') );
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('day');
	} else if(gubun == 'year') { // 1년
		$selPeriod.empty().append("1월").append( $('<span class="caret" />') );
		
		$("#selPeriodVal").val('month');
	} else if(gubun == 'other') { // 에너지모니터링 화면 전체의 기간설정검색
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		var d = new Date();
		$("#datepicker1, #datepicker2").attr("disabled", false).val( d.format("yyyy-MM-dd") );
		$("#selPeriodVal").val('hour');
	} else if(gubun == 'drday') { // 에너지모니터링 dr실적조회의 오늘날짜
		$("#selPeriodVal").val('hour');
	} else if(gubun == 'selectDay') { // 에너지모니터링 dr실적조회의 날짜검색
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		var d = new Date();
		$("#datepicker5").attr("disabled", false).val( d.format("yyyy-MM-dd") );
		$("#selPeriodVal").val('hour');
	}
	
	SelTerm = gubun;
}

// 데이터조회간격 선택
function changePeriod(param) {
	$("#selPeriodVal").val(param);
}

var btwnDt = 0;
var realTimeRefresh = null;
$(function () { 
	$("#datepicker1, #datepicker2").change(function () {
		$dt1 = $("#datepicker1");
		$dt2 = $("#datepicker2");
		
		if( ($dt1.val() != "" && $dt1.val() != null) && ($dt2.val() != "" && $dt2.val() != null) ) {
			if(new Date($dt1.val()).getTime() > new Date($dt2.val()).getTime()) {
				alert("시작일자가 종료일자보다 클 수 없습니다.");
				$(this).val("");
				return;
			}
			btwnDt = dateDiff($dt1.val(), $dt2.val());
//			console.log($dt1.val()+'는 '+$dt2.val()+'로 부터 ' + dateDiff($dt1.val(), $dt2.val()) + '일 전입니다.');
		}
		
	});
	
	$("#datepicker5").change(function () {
		$dt5 = $("#datepicker5");
		$("#selTermFrom").val( ($dt5.val() == "") ? "" : new Date( $dt5.val()+" 00:00:00" ).format("yyyyMMddHHmmss") );
		$("#selTermTo").val( ($dt5.val() == "") ? "" : new Date( $dt5.val()+" 23:59:59" ).format("yyyyMMddHHmmss") );
		$("#dtCnt").val(  dateDiff($dt5.val()+" 00:00:00", $dt5.val()+" 23:59:59")+1  );
		
	});
	
});

// 에너지모니터링 db조회 검색조건 모으기
var schStartTime;
var schEndTime;
function getCollect_sch_condition() {
	$dtpk1 = $("#datepicker1");
	$dtpk2 = $("#datepicker2");
	$dtpk3 = $("#datepicker3");
	$dtpk4 = $("#datepicker4");
	$dtpk5 = $("#datepicker5");
	$("#dtCnt").val("");
	
	var firstDay = new Date();
	var endDay = new Date();
//	var firstDay = new Date(2018, 7, 31, 13, 45, 37); // 2018-08-31 13:45:37
//	var endDay = new Date(2018, 7, 31, 13, 45, 37);
//	var firstDay = new Date(2018, 8, 23, 13, 45, 37);
//	var endDay = new Date(2018, 8, 23, 13, 45, 37);
	var startTime;
	var endTime;
	if(SelTerm == '15min') { // 15분(현재 안나옴)
		startTime = new Date(firstDay.setMinutes(firstDay.getMinutes() - 15));
		endTime = new Date();
	} else if(SelTerm == '30min') { // 30분
		startTime = new Date(firstDay.setMinutes(firstDay.getMinutes() - 30));
		endTime = new Date();
	} else if(SelTerm == 'hour') { // 1시간
		startTime = new Date(firstDay.setHours(firstDay.getHours() - 1));
		endTime = new Date();
	} else if(SelTerm == 'day') { // 오늘
		startTime = new Date(firstDay.setDate(firstDay.getDate() - 1));
		endTime = new Date();
	} else if(SelTerm == 'week') { // 1주
		startTime = new Date(firstDay.setDate(firstDay.getDate() - 7));
		endTime = new Date();
	} else if(SelTerm == 'month') { // 1달
		startTime = new Date(firstDay.setDate(firstDay.getDate()-30));
		endTime = new Date();
	} else if(SelTerm == 'year') { // 1년
		startTime = new Date(firstDay.setDate(firstDay.getDate()-365));
		endTime = new Date();
	} else if(SelTerm == 'other') { // 에너지모니터링 화면 전체의 기간설정검색
		startTime = new Date( $dtpk1.val()+" 00:00:00" );
		endTime = new Date( $dtpk2.val()+" 23:59:59" );
		$("#dtCnt").val(  dateDiff($dtpk1.val()+" 00:00:00", $dtpk2.val()+" 23:59:59")+1  );
	} else if(SelTerm == 'drday') { // 에너지모니터링 dr실적조회의 오늘날짜
		startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), 0, 0, 0);
		endTime = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), 23, 59, 59);
	} else if(SelTerm == 'selectDay') { // 에너지모니터링 dr실적조회의 날짜검색
		startTime = new Date( $dtpk5.val()+" 00:00:00" );
		endTime = new Date( $dtpk5.val()+" 23:59:59" );
		$("#dtCnt").val(  dateDiff($dtpk5.val()+" 00:00:00", $dtpk5.val()+" 23:59:59")+1  );
	} else if(SelTerm == "billSelectMM") { // 요금/수익 화면 전체의(PV수익조회 제외) 기간설정검색
		$("#selTermFrom").val( replaceAll($dtpk3.val(), "-", "") );
		$("#selTermTo").val( replaceAll($dtpk4.val(), "-", "") );
	} else if(SelTerm == "billSelectMM_pv") { // 요금/수익 PV 수익 조회 화면의 기간설정검색
		startTime = new Date( $dtpk3.val()+"-01 00:00:00" );
		var edDt = new Date( $dtpk4.val()+"-01 23:59:59" );
		endTime = new Date( edDt.getFullYear(), edDt.getMonth()+1, 0, 23, 59, 59 );
		$("#selTermFrom").val( firstDay.format("yyyyMMddHHmmss") );
		$("#selTermTo").val( endDay.format("yyyyMMddHHmmss") );
	}
	
	if(SelTerm != "billSelectMM") {
		schStartTime = new Date(startTime.getTime());
		schEndTime = new Date(endTime.getTime());
		
		var queryStart = new Date(startTime.setMinutes(startTime.getMinutes() + (new Date()).getTimezoneOffset()));
		var queryEnd = new Date(endTime.setMinutes(endTime.getMinutes() + (new Date()).getTimezoneOffset()));
		
		queryStart = (queryStart == "") ? "" : queryStart.format("yyyyMMddHHmmss");
		queryEnd = (queryEnd == "") ? "" : queryEnd.format("yyyyMMddHHmmss");
		$("#selTermFrom").val(queryStart);
		$("#selTermTo").val(queryEnd);
		
	}
	
	console.log("검색일자    "+$("#selTermFrom").val()+", "+$("#selTermTo").val());
	
	var formData = $("#schForm").serializeObject();
	console.log(formData);

	var today = new Date();
	getDBData(formData); // DB 데이터 조회(각 화면마다 존재)
	update_updtDataTime(today, "updtTime"); // 검색시간(차트 새로고침시간) 업데이트
}

// 데이터 뿌리기(highcharts, datatable)
function drawData() {
	drawData_chart(); // 차트 그리기
	drawData_table(); // 표(테이블) 그리기
}

//차트 새로고침시간 업데이트
function update_updtDataTime(now, id) {
	$("#"+id).empty().append(now.format("yyyy-MM-dd HH:mm:ss"));
}

// 차트에 대입할 날짜(x축) 세팅
function setChartDateUTC(_dateTimestamp) {
//	if(localYn == "Y") {
		var tm = new Date(_dateTimestamp);
		return new Date( Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds()) ).getTime();
//	} else if(localYn == "N") {
//		return _dateTimestamp;
//	}
	
}

function setHms(start, end) {
	start.setHours(0)
	start.setMinutes(0);
	start.setSeconds(0);
	start.setMilliseconds(0);
	end.setHours(23);
	end.setMinutes(59);
	end.setSeconds(59);
	end.setMilliseconds(999);
}

function incrementTime(_time) {
	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
	if(periodd == 'month') {
		_time.setDate(1);
		_time.setHours(0)
		_time.setMinutes(0);
		_time.setSeconds(0);
		
		_time = new Date(_time.setMonth( _time.getMonth()+1 ));
		return _time;
		
	} else {
		var loopSumCnt = calculateCnt();
		var plusMinute = 15*loopSumCnt;
		var __time = new Date(_time.setMinutes(  _time.getMinutes()+plusMinute    ));
		return __time;
		
	}
	
}

function calculateCnt() {
	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
	var cnt = 0;
	if(periodd == '15min') {
		cnt = 1;
	} else if(periodd == '30min') {
		cnt = 2;
	}  else if(periodd == 'hour') {
		cnt = 4;
	} else if(periodd == 'day') {
		cnt = 96;
	} else if(periodd == 'month') {
		cnt = 96*30;
	}
	
	return cnt;
}

// 표 영역의 헤더 날짜형식 변환
function convertDataTableHeaderDate(_convertDt, type) {
	var convertDt = _convertDt instanceof Date ? _convertDt : new Date(_convertDt);
	var headerDate = "";
	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
	
	if(type == 1) {
		if(SelTerm == '30min' || SelTerm == 'hour' || SelTerm == 'day') {
			headerDate = convertDt.format("yyyy-MM-dd");
			
		} else if(SelTerm === 'week') {
			if(periodd == 'day') headerDate = convertDt.format("yyyy-MM");
			else headerDate = convertDt.format("yyyy-MM-dd");
			
		} else if(SelTerm == 'month') {
			if(periodd == 'day') headerDate = convertDt.format("yyyy-MM");
			else headerDate = convertDt.format("yyyy-MM-dd");
			
		} else if(SelTerm == 'year') {
			if(periodd == 'day') headerDate = convertDt.format("yyyy")
			else if(periodd == 'month') {}
			else headerDate = convertDt.format("yyyy-MM-dd");
			
		} else if(SelTerm == "other") {
			headerDate = convertDt.format("yyyy-MM-dd");
		}
		
	} else if(type == 2) {
		if(SelTerm == '30min' || SelTerm == 'hour' || SelTerm == 'day') {
			headerDate = convertDt.format("HH:mm");
			
		} else if(SelTerm === 'week') {
			if(periodd == 'day') headerDate = convertDt.format("MM-dd");
			else headerDate = convertDt.format("HH:mm");
			
		} else if(SelTerm == 'month') {
			if(periodd == 'day') headerDate = convertDt.format("MM-dd");
			else headerDate = convertDt.format("HH:mm");
			
		} else if(SelTerm == 'year') {
			if(periodd == 'day') headerDate = convertDt.format("yyyy-MM-dd");
			else if(periodd == 'month') headerDate = convertDt.format("yyyy-MM")
			else headerDate = convertDt.format("HH:mm");
			
		} else if(SelTerm == "other") {
			headerDate = convertDt.format("HH:mm");
		}
		
	}
	
	return headerDate;
}

// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
function unit_format(usage, id, unitGbn) {
	var map = convertUnitFormat(usage, unitGbn, usage.length);
	var formatNum = map.get("formatNum");
	var unit = map.get("unit");
	
	formatNum = checkNumLen(formatNum);
	
	$("#"+id).empty().append( $("<span/>").append( numberComma( formatNum ) ) ).append(unit);
}

// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
function unit_format_bill(usage, id, unitGbn, billGbn) {
	var map = convertUnitFormat(usage, unitGbn, usage.length);
	var formatNum = map.get("formatNum");
	var unit = map.get("unit");
	
	$("#"+id).empty().append( $("<span/>").append( numberComma( formatNum ) ) ).append(unit);
}

// 차트 x축 틱 갯수 지정
var tickInterval = 60 * 60 * 1000;
function setTickInterval() {
	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
	
	myChart.xAxis[0].options.labels.style.fontSize = '16px';
	var startEndTickFlag = false;
	
	// 24 * 60 * 60 * 1000 = 1일
	// 7 * 24 * 60 * 60 * 1000 = 일주일
	if(SelTerm == 'hour') {
		tickInterval = 60 * 1000;//15 * 60 * 1000;
		myChart.xAxis[0].options.labels.style.fontSize = '12px';
		
	} else if(SelTerm == 'day') {
		if(periodd == '15min') {
			tickInterval = 15 * 60 * 1000;
			myChart.xAxis[0].options.labels.style.fontSize = '5px';
		} // 96
		else if(periodd == '30min') {
			tickInterval = 30 * 60 * 1000;
			myChart.xAxis[0].options.labels.style.fontSize = '10px';
		} // 48
		else if(periodd == 'hour') {
			tickInterval = 60 * 60 * 1000;
		}
		
	} else if(SelTerm === 'week') {
		tickInterval = 24 * 60 * 60 * 1000;
		startEndTickFlag = true;
		
	} else if(SelTerm == 'month') {
		tickInterval = 24 * 60 * 60 * 1000;
		myChart.xAxis[0].options.labels.style.fontSize = '14px';
		startEndTickFlag = true;
		
	} else if(SelTerm == 'year') {
		tickInterval = 30 * 24 * 3600 * 1000;
//		startEndTickFlag = true;
	} else if(SelTerm == "other") {
		
	}
	
	myChart.xAxis[0].options.tickInterval = tickInterval;
//	myChart.xAxis[0].options.startOnTick = startEndTickFlag;
//	myChart.xAxis[0].options.endOnTick = startEndTickFlag;
}

// 표 데이터 1행의 최대칸수 및 테이블갯수
var dt_col = 0; // 1행의 최대 칸 수
var dt_row = 0; // 테이블갯수
function setDataTableColRowCnt() {
	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
	var chk = $("#selTermFrom").val().substring(8,14);
	
	var col_cnt = 0;
	var row_cnt = 1;
	
	if(SelTerm == '30min') {
		col_cnt = 2;
		if(chk != "000000") row_cnt = row_cnt+1;
	} else if(SelTerm == 'hour') {
		if(periodd == '15min') {
			col_cnt = 4;
		} else if(periodd == '30min') {
			col_cnt = 2;
		}
		if(chk != "000000") row_cnt = row_cnt+1;
		
	} else if(SelTerm == 'day') {
		if(periodd == '15min') {
			col_cnt = 96;
		} else if(periodd == '30min') {
			col_cnt = 48;
		}  else if(periodd == 'hour') {
			col_cnt = 24;
		}
		if(chk != "000000") row_cnt = row_cnt+1;
		
	} else if(SelTerm === 'week') {
		if(periodd == '15min') {
			col_cnt = 96;
			row_cnt = 7;
		} else if(periodd == '30min') {
			col_cnt = 48;
			row_cnt = 7;
		}  else if(periodd == 'hour') {
			col_cnt = 24;
			row_cnt = 7;
		} else if(periodd == 'day') {
			col_cnt = 7;
			if(chk != "000000") col_cnt = col_cnt+1;
		}

		if(periodd != 'day') {
			if(chk != "000000") row_cnt = row_cnt+1;
		}
		
	} else if(SelTerm == 'month') {
		if(periodd == '15min') {
			col_cnt = 96;
			row_cnt = 30;
		} else if(periodd == '30min') {
			col_cnt = 48;
			row_cnt = 30;
		}  else if(periodd == 'hour') {
			col_cnt = 24;
			row_cnt = 30;
		} else if(periodd == 'day') {
			col_cnt = 30;
			if(chk != "000000") col_cnt = col_cnt+1;
		}
		
		if(periodd != 'day') {
			if(chk != "000000") row_cnt = row_cnt+1;
		}
		
	} else if(SelTerm == 'year') {
		if(periodd == '15min') {
			col_cnt = 96;
			row_cnt = 365;
		} else if(periodd == '30min') {
			col_cnt = 48;
			row_cnt = 365;
		}  else if(periodd == 'hour') {
			col_cnt = 24;
			row_cnt = 365;
		} else if(periodd == 'day') {
			col_cnt = 30;
			row_cnt = 12;
		} else if(periodd == 'month') {
			col_cnt = 12;
			if(chk != "000000") col_cnt = col_cnt+1;
		}

		if(periodd != 'month') {
			if(chk != "000000") row_cnt = row_cnt+1;
		}
		
	} else if(SelTerm == "other") {
		if(periodd == '15min') {
			col_cnt = 96;
		} else if(periodd == '30min') {
			col_cnt = 48;
		}  else if(periodd == 'hour') {
			col_cnt = 24;
		}
		row_cnt = $("#dtCnt").val();
	}
	
	dt_col = col_cnt;
	dt_row = row_cnt;
//	console.log("col : "+col_cnt+", row : "+row_cnt);
}

