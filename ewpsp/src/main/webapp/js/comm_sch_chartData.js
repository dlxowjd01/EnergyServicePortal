
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
	var today = new Date();
	var firstDay = new Date();
	var endDay = new Date();
//	var firstDay = new Date(2018, 7, 31, 0, 0, 0);
//	var endDay = new Date(2018, 7, 31, 23, 59, 59);
//	console.log("시작전 : "+firstDay+", "+endDay);
	if(gubun == '15min') { // 15분(현재 안나옴)
		firstDay = new Date(firstDay.setMinutes(firstDay.getMinutes() - 14));// new Date().setHours(firstDay.getMinutes()-1);
//		endDay = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds());
		$selTermBox.empty().append("15분").append( $('<span class="caret" />') );
		$selPeriod.empty().append("1분").append( $('<span class="caret" />') );
		$("#sp_15min").hide();
		$("#sp_30min").hide();
		$("#sp_1hour").hide();
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('1min');
	} else if(gubun == '30min') { // 30분
		firstDay = new Date(firstDay.setMinutes(firstDay.getMinutes() - 29));// new Date().setHours(firstDay.getHours()-1);
//		endDay = new Date(endDay.setMinutes(endDay.getMinutes() - 1));
//		endDay = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds());
		$selTermBox.empty().append("30분").append( $('<span class="caret" />') );
		$selPeriod.empty().append("15분").append( $('<span class="caret" />') );
		$("#sp_30min").hide();
		$("#sp_1hour").hide();
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('15min');
	} else if(gubun == 'hour') { // 1시간
//		firstDay = new Date(firstDay.setHours(firstDay.getHours() - 1));// new Date().setHours(firstDay.getHours()-1);
		firstDay = new Date(firstDay.setMinutes(firstDay.getMinutes() - 59));// new Date().setHours(firstDay.getHours()-1);
//		endDay = new Date(endDay.setMinutes(endDay.getMinutes() - 1));
//		endDay = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds());
		
		$selTermBox.empty().append("1시간").append( $('<span class="caret" />') );
		$selPeriod.empty().append("15분").append( $('<span class="caret" />') );
		$("#sp_1hour").hide();
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('15min');
	} else if(gubun == 'day') { // 오늘
		firstDay = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), 0, 0, 0);
		endDay = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), 23, 59, 59);
		
		$selTermBox.empty().append("1일(오늘)").append( $('<span class="caret" />') );
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('hour');
	} else if(gubun == 'week') { // 1주
		firstDay = new Date(firstDay.setDate(firstDay.getDate() - 6));
//		endDay = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), endDay.getHours(), endDay.getMinutes(), endDay.getSeconds());
		
		$selTermBox.empty().append("1주").append( $('<span class="caret" />') );
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('hour');
	} else if(gubun == 'month') { // 1달
		firstDay.setMonth(firstDay.getMonth()-1);
		firstDay = new Date(firstDay.setDate(firstDay.getDate()+1));
//		endDay = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds());
		
		$selTermBox.empty().append("1월").append( $('<span class="caret" />') );
		$selPeriod.empty().append("1일").append( $('<span class="caret" />') );
		$("#sp_1month").hide();
		
		$("#selPeriodVal").val('day');
	} else if(gubun == 'year') { // 1년
		firstDay.setYear(firstDay.getFullYear()-1);
		firstDay = new Date(firstDay.setDate(firstDay.getDate()+1));
//		endDay = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds());
		
		$selTermBox.empty().append("1년").append( $('<span class="caret" />') );
		$selPeriod.empty().append("1월").append( $('<span class="caret" />') );
		$("#sp_1min").hide();
		$("#sp_15min").hide();
		$("#sp_30min").hide();
		$("#sp_1hour").hide();
		$("#sp_1day").hide();
		
		$("#selPeriodVal").val('month');
	} else if(gubun == 'other') { // 에너지모니터링 화면 전체의 기간설정검색
		$selTermBox.empty().append("기간설정").append( $('<span class="caret" />') );
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		$("#sp_1day").hide();
		$("#sp_1month").hide();
		firstDay = "";
		endDay = "";
		var d = new Date();
		$("#datepicker1, #datepicker2").attr("disabled", false).val( d.format("yyyy-MM-dd") );
	} else if(gubun == 'selectDay') { // 에너지모니터링 dr실적조회의 날짜검색
		$selTermBox.empty().append("1일(날짜선택)").append( $('<span class="caret" />') );
		$selPeriod.empty().append("1시간").append( $('<span class="caret" />') );
		firstDay = "";
		endDay = "";
		var d = new Date();
		$("#datepicker5").attr("disabled", false).val( d.format("yyyy-MM-dd") );
	}
	
	firstDay = (firstDay == "") ? "" : firstDay.format("yyyyMMddHHmmss");
	endDay = (endDay == "") ? "" : endDay.format("yyyyMMddHHmmss");
//	console.log("firstDay : "+firstDay+", endDay : "+endDay);

	$("#selTermFrom").val(firstDay);
	$("#selTermTo").val(endDay);
	SelTerm = gubun;
}

// 데이터조회간격 선택
function changePeriod(param) {
	$("#selPeriodVal").val(param);
	if(param == '1min') {
		$("#selPeriod").empty().append("1분").append( $('<span class="caret" />') );
	} else if(param == '15min') {
		$("#selPeriod").empty().append("15분").append( $('<span class="caret" />') );
	} else if(param == '30min') {
		$("#selPeriod").empty().append("30분").append( $('<span class="caret" />') );
	} else if(param == 'hour') {
		$("#selPeriod").empty().append("1시간").append( $('<span class="caret" />') );
	} else if(param == 'day') {
		$("#selPeriod").empty().append("1일").append( $('<span class="caret" />') );
	} else if(param == 'month') {
		$("#selPeriod").empty().append("1월").append( $('<span class="caret" />') );
	}
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
	
	$("#check1").click(function () {
		var flag = $("#check1").prop("checked") ;
//		console.log("flag : "+flag);
		if(flag) {
			changeSelTerm('day');
			getCollect_sch_condition();
			
			if(realTimeRefresh == null) { // 1분 간격
				realTimeRefresh = setInterval(function(){
					changeSelTerm('day');
					getCollect_sch_condition();
				},5000); // 1000 = 1초, 5000 = 5초
			} else {
				alert("이미 실시간 자동갱신이 실행중입니다.");
			}
			
		} else {
			clearInterval(realTimeRefresh);
			realTimeRefresh = null;
		}
		
	});
});

//db조회 검색조건 모으기
function getCollect_sch_condition() {
//	var period = $("#selPeriodVal").val(); // 데이터조회간격
//	var siteId = $("#site-ids").val(); // 조회할 사이트 id
//	var start = $("#selTermFrom").val(); // 검색시작일시(selectbox)
//	var end = $("#selTermTo").val(); // 검색종료일시(selectbox)
//	var dtpk_from = $("#datepicker1").val(); // 검색시작일(input)
//	var dtpk_to = $("#datepicker2").val(); // 검색종료일(input)
	
	$dtpk1 = $("#datepicker1");
	$dtpk2 = $("#datepicker2");
	$dtpk3 = $("#datepicker3");
	$dtpk4 = $("#datepicker4");
	$dtpk5 = $("#datepicker5");
	$("#dtCnt").val("");
	if(SelTerm == "other") {
		$("#selTermFrom").val( ($dtpk1.val() == "") ? "" : new Date( $dtpk1.val()+" 00:00:00" ).format("yyyyMMddHHmmss") );
		$("#selTermTo").val( ($dtpk2.val() == "") ? "" : new Date( $dtpk2.val()+" 23:59:59" ).format("yyyyMMddHHmmss") );
		$("#dtCnt").val(  dateDiff($dtpk1.val()+" 00:00:00", $dtpk2.val()+" 23:59:59")+1  );
	} else if(SelTerm == "selectDay") { // dr실적 날짜선택
		$("#selTermFrom").val( ($dtpk5.val() == "") ? "" : new Date( $dtpk5.val()+" 00:00:00" ).format("yyyyMMddHHmmss") );
		$("#selTermTo").val( ($dtpk5.val() == "") ? "" : new Date( $dtpk5.val()+" 23:59:59" ).format("yyyyMMddHHmmss") );
		$("#dtCnt").val(  dateDiff($dtpk5.val()+" 00:00:00", $dtpk5.val()+" 23:59:59")+1  );
		
	} else if(SelTerm == "billSelectMM") { // 요금/수익 화면 전체의 기간설정검색
		$("#selTermFrom").val( replaceAll($dtpk3.val(), "-", "") );
		$("#selTermTo").val( replaceAll($dtpk4.val(), "-", "") );
	}
//	if(dtcnt == 1) $("#selTerm").val("day");
//	else if(dtcnt >= 7 && dtcnt <=31) $("#selTerm").val("month");
//	else if(dtcnt > 31) $("#selTerm").val("year");
//	
	var formData = $("#schForm").serializeObject();
//	formValidationChk();

	var today = new Date();
	getDBData(formData); // DB 데이터 조회(각 화면마다 존재)
	update_updtDataTime(today, "updtTime"); // 검색시간(차트 새로고침시간) 업데이트
}

//폼 유효성 체크
function formValidationChk(formData) {
//	if() {
//		
//	}
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
	if(localYn == "Y") {
		var tm = new Date(_dateTimestamp);
		return Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds());
	} else if(localYn == "N") {
		return _dateTimestamp;
	}
	
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
			headerDate = convertDt.format("yyyy")
			
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
	var format_usage;
	var unit;
	
	if(unitGbn == "won") {
		format_usage = numberComma( usage );
		unit = "won";
	} else if(unitGbn == "Wh") {
		if(usage.length > 9) {
			format_usage = numberComma( usage.substring( 0, usage.length-9 ) );
			unit = "MWh";
		} else if(usage.length > 6) {
			format_usage = numberComma( usage.substring( 0, usage.length-6 ) );
			unit = "kWh";
		} else if(usage.length > 3) {
			format_usage = numberComma( usage.substring( 0, usage.length-3 ) );
			unit = "Wh";
		} else {
			format_usage = numberComma( usage );
			unit = "mWh";
		} 
	} else if(unitGbn == "kW"){
		if(usage.length > 9) {
			format_usage = numberComma( usage.substring( 0, usage.length-9 ) );
			unit = "TW";
		} else if(usage.length > 6) {
			format_usage = numberComma( usage.substring( 0, usage.length-6 ) );
			unit = "GW";
		} else if(usage.length > 3) {
			format_usage = numberComma( usage.substring( 0, usage.length-3 ) );
			unit = "MW";
		} else {
			format_usage = numberComma( usage );
			unit = "kW";
		}
	}
	if(format_usage == "NaN") format_usage = "0"
		
	$("#"+id).empty().append( $("<span/>").append(format_usage) ).append(unit);
}

// 차트 x축 틱 갯수 지정
var tickInterval = 60 * 60 * 1000;
function setTickInterval() {
	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
	
	myChart.xAxis[0].options.labels.style.fontSize = '16px';
	
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
		
	} else if(SelTerm == 'month') {
		tickInterval = 24 * 60 * 60 * 1000;
		myChart.xAxis[0].options.labels.style.fontSize = '14px';
		
	} else if(SelTerm == 'year') {
		tickInterval = 30 * 24 * 3600 * 1000;
	} else if(SelTerm == "other") {
		
	}
	
	myChart.xAxis[0].options.tickInterval = tickInterval;
}

// 표 데이터 1행의 최대칸수 및 테이블갯수
var dt_col = 0; // 1행의 최대 칸 수
var dt_row = 0; // 테이블갯수
function setDataTableColRowCnt() {
	var periodd = $("#selPeriodVal").val(); // 데이터조회간격
	
	var col_cnt = 0;
	var row_cnt = 1;
	
	if(SelTerm == '30min') {
		col_cnt = 2;
	} else if(SelTerm == 'hour') {
		if(periodd == '15min') {
			col_cnt = 4;
		} else if(periodd == '30min') {
			col_cnt = 2;
		}
		
	} else if(SelTerm == 'day') {
		if(periodd == '15min') {
			col_cnt = 96;
		} else if(periodd == '30min') {
			col_cnt = 48;
		}  else if(periodd == 'hour') {
			col_cnt = 24;
		}
		
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
		}
	} else if(SelTerm == "other") {
		col_cnt = 24;
		row_cnt = $("#dtCnt").val();
	}
	dt_col = col_cnt;
	dt_row = row_cnt;
//	console.log("col : "+col_cnt+", row : "+row_cnt);
}

