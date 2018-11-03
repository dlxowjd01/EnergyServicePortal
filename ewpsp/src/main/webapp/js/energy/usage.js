	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
	var usage_head_pc = new Array(); // 실제 사용량 표 데이터
	var real_data_pc = new Array(); // 실제 사용량 표 데이터
	var feture_data_pc = new Array(); //  예측 사용량 표 데이터
	function getDBData(formData) {
		usage_head_pc.length = 0;
		real_data_pc.length = 0;
		feture_data_pc.length = 0;
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getUsageRealList(formData); // 실제사용량 조회
		getUsageFutureList(formData); // 예측사용량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// 실제 사용량
	var pastUsageList;
	function callback_getUsageRealList(result) {
		var sheetList = result.sheetList;
		var chartList = result.chartList;
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totalUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		
		// 표데이터 셋팅
		var start = new Date(schStartTime.getTime());
		var end = new Date(schEndTime.getTime());
		if(sheetList != null && sheetList.length > 0) {
			var s = start;
			var e = end;
			setHms(s, e);
			if(periodd == 'month') {
				s.setDate(1);
				s.setHours(0)
				s.setMinutes(0);
				s.setSeconds(0);
			}
			for(var i=0; i<sheetList.length; i++) {
				dt_str_head += "<th>"+convertDataTableHeaderDate(s, 2)+"</th>";
				
				var reUsage = null;
				for(var j=0; j<sheetList.length; j++) {
					if(s.getTime() == new Date(sheetList[j].std_timestamp).getTime()) {
						var usage = String(sheetList[j].usg_val);
						if(usage == null || usage == "" || usage == "null") {
							reUsage = null;
						} else {
							var map = convertUnitFormat(usage, "mWh", 8);
							reUsage = Number( map.get("formatNum") );
							dt_str_totalVal = dt_str_totalVal+reUsage;
						}
						
						break;
					}
				}
				dt_str += "<td>"+  ( (reUsage == null) ? "" : reUsage ) +"</td>";
				
				if(dt_col_cnt == dt_col) {
					var final_dt_str_head = "<th>"+convertDataTableHeaderDate(s, 1)+"</th>"+dt_str_head;
					dt_str += "<td>"+dt_str_totalVal+"</td>";
					usage_head_pc[dt_row_cnt-1] = final_dt_str_head;
					real_data_pc[dt_row_cnt-1] = dt_str;
					dt_str_head = "";
					dt_str = "";
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_totalVal = 0;
				} else {
					if((i+1) == sheetList.length) { // 루프 다 돌고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str_head += "<th></th>";
							dt_str += "<td></td>";
						}
						var final_dt_str_head = "<th>"+convertDataTableHeaderDate(s, 1)+"</th>"+dt_str_head;
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						usage_head_pc[dt_row_cnt-1] = final_dt_str_head;
						real_data_pc[dt_row_cnt-1] = dt_str;
						dt_str_head = "";
						dt_str = "";
//						dt_row_cnt++;
//						dt_col_cnt = 1;
						dt_str_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
				}
				
				s = incrementTime(s);
				
			}
			
		}
		
		// 차트데이터 셋팅
		if(chartList != null && chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var usage = String(chartList[i].usg_val);
				var reUsage = 0;
				if(usage == null || usage == "" || usage == "null") {
					reUsage = null;
				} else {
					var map = convertUnitFormat(usage, "mWh", 8);
					reUsage = Number( map.get("formatNum") );
					totalUsage = totalUsage+Number(usage);
				}
				
//				var tm = new Date( convertDateUTC(chartList[i].std_timestamp) );
				dataSet.push([ setChartDateUTC(chartList[i].std_timestamp), reUsage ]);
				
			}
			
		}
		pastUsageList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalUsage), "pastUseTot", "mWh");
	}
	
	// 예측 사용량
	var fetureUsageList;
	function callback_getUsageFutureList(result) {
		var sheetList = result.sheetList;
		var chartList = result.chartList;
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totalUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		
		// 표데이터 셋팅
		var start = new Date(schStartTime.getTime());
		var end = new Date(schEndTime.getTime());
		if(sheetList != null && sheetList.length > 0) {
			var s = start;
			var e = end;
			setHms(s, e);
			if(periodd == 'month') {
				s.setDate(1);
				s.setHours(0)
				s.setMinutes(0);
				s.setSeconds(0);
			}
			for(var i=0; i<sheetList.length; i++) {

				var reUsage = null;
				for(var j=0; j<sheetList.length; j++) {
					if(s.getTime() == new Date(sheetList[j].std_timestamp).getTime()) {
						var usage = String(sheetList[j].pre_usg_val);
						if(usage == null || usage == "" || usage == "null") {
							reUsage = null;
						} else {
							var map = convertUnitFormat(usage, "mWh", 8);
							reUsage = Number( map.get("formatNum") );
							dt_str_totalVal = dt_str_totalVal+reUsage;
						}
						
						break;
					}
				}
				dt_str += "<td>"+  ( (reUsage == null) ? "" : reUsage ) +"</td>";
				
				if(dt_col_cnt == dt_col) {
					dt_str += "<td>"+dt_str_totalVal+"</td>";
					feture_data_pc[dt_row_cnt-1] = dt_str;
					dt_str = "";
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_totalVal = 0;
				} else {
					if((i+1) == sheetList.length) { // 루프 다 돌고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str += "<td></td>";
						}
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						feture_data_pc[dt_row_cnt-1] = dt_str;
//						dt_str_head = "";
						dt_str = "";
//						dt_row_cnt++;
//						dt_col_cnt = 1;
						dt_str_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
				}
				
				s = incrementTime(s);
				
			}
			
		}
		
		// 차트데이터 셋팅
		if(chartList != null && chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var usage = String(chartList[i].pre_usg_val);
				var reUsage = 0;
				if(usage == null || usage == "" || usage == "null") {
					reUsage = null;
				} else {
					var map = convertUnitFormat(usage, "mWh", 8);
					reUsage = Number( map.get("formatNum") );
					totalUsage = totalUsage+Number(usage);
				}
				
				// 차트데이터 셋팅
				dataSet.push([ setChartDateUTC(chartList[i].std_timestamp), reUsage ]);
				
			}
			
		}
		fetureUsageList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalUsage), "futureUseTot", "mWh");
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '실제 사용량',
			color: '#438fd7',
			data: pastUsageList
		}, false);
		
		myChart.addSeries({
			name: '예측 사용량',
			color: '#84848f',
			dashStyle: 'ShortDash',
			data: fetureUsageList
		}, false);
		
		setTickInterval();
		myChart.redraw(); // 차트 데이터를 다시 그린다
		
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다
		$div = $("#pc_use_dataDiv");
		$div.empty(); // 초기화
		if(real_data_pc.length < 1) {
			$(".usage_chart").find(".inchart-nodata").css("display", "");
			$(".usage_chart").find(".inchart").css("display", "none");
			$div.prepend(
					$('<div class="chart_table" />').append( // pc_use_dataTable
							$('<table class="pc_use" />').append(
									$("<thead/>").append( $("<tr/>").append(  
											"<th width='33%'></th><td width='34%'>조회 결과가 없습니다.</td><th width='33%'></th>" ) 
									) // thead
							)
					)
			);
			
		} else {
			$(".usage_chart").find(".inchart-nodata").css("display", "none");
			$(".usage_chart").find(".inchart").css("display", "");
			for(var i=dt_row-1; i>-1; i--) {
				$div.prepend(
						$('<div class="chart_table" />').append(
								$('<table class="pc_use" />').append(
										$("<thead/>").append( $("<tr/>").append( usage_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append( // 실제 사용량
														'<th><div class="ctit ct1"><span>실제 사용량</span></div></th>'+real_data_pc[i]
												)
										).append(
												$("<tr/>").append( // 예측 사용량
														'<th><div class="ctit"><span>예측 사용량</span></div></th>'+ feture_data_pc[i]
												)
										)
								) 
						)
				);
				
			}
		}
	}
	

//	function excelDownload() {
//		var col_kor = "";
//		col_kor = "사이트id|날짜|사용량";
//		console.log("aa");
//		var formData = $("#schForm").serialize();
//		
//		// 엑셀 다운로드
//		$.download('/excelDownload',
//				formData
////				"aa="+$("#aa").val()
//				+"&COL_NM="+col_kor
//				,'post' );
//	}


