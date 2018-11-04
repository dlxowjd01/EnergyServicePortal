	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
	function searchData() {
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
	var pv_head_pc = new Array(); // 실제 사용량 표 데이터
	var real_data_pc = new Array(); // 실제 발전량 표 데이터
	var feture_data_pc = new Array(); //  예측 발전량 표 데이터
	function getDBData(formData) {
		pv_head_pc.length = 0;
		real_data_pc.length = 0;
		feture_data_pc.length = 0;
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getPVGenRealList(formData); // 실제 발전량 조회
		getPVGenFutureList(formData); // 예측 발전량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// PV 실제 발전량
	var pastPVGenList;
	function callback_getPVGenRealList(result) {
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
					if(s.getTime() == new Date(sheetList[j].std_date).getTime()) {
						var usage = String(sheetList[j].gen_val);
						if(usage == null || usage == "" || usage == "null") {
							reUsage = null;
						} else {
							var map = convertUnitFormat(usage, "kWh", 1);
							reUsage = Math.round( Number(map.get("formatNum")) );
							dt_str_totalVal = dt_str_totalVal+reUsage;
						}
						
						break;
					}
				}
				dt_str += "<td>"+  ( (reUsage == null) ? "" : reUsage ) +"</td>";
				
				
				if(dt_col_cnt == dt_col) {
					var final_dt_str_head = "<th>"+convertDataTableHeaderDate(s, 1)+"</th>"+dt_str_head;
					dt_str += "<td>"+dt_str_totalVal+"</td>";
					pv_head_pc[dt_row_cnt-1] = final_dt_str_head;
					real_data_pc[dt_row_cnt-1] = dt_str;
					dt_str_head = "";
					dt_str = "";
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_totalVal = 0;
				} else {
					if((i+1) == sheetList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str_head += "<th></th>";
							dt_str += "<td></td>";
						}
						var final_dt_str_head = "<th>"+convertDataTableHeaderDate(s, 1)+"</th>"+dt_str_head;
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						pv_head_pc[dt_row_cnt-1] = final_dt_str_head;
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
				var usage = String(chartList[i].gen_val);
				var reUsage = 0;
				if(usage == null || usage == "" || usage == "null") {
					reUsage = null;
				} else {
					var map = convertUnitFormat(usage, "kWh", 1);
					reUsage = Math.round( Number(map.get("formatNum")) );
					totalUsage = totalUsage+Number(usage);
				}
				
				var tm = new Date(chartList[i].std_date);
				// 차트데이터 셋팅
				dataSet.push([ setChartDateUTC(chartList[i].std_date), reUsage ]);
				
				
			}
			
		}
		pastPVGenList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalUsage), "pastPvGenTot", "kWh");
	}
	
	// PV 예측 발전량
	var feturePVGenList;
	function callback_getPVGenFutureList(result) {
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
					if(s.getTime() == new Date(sheetList[j].std_date).getTime()) {
						var usage = String(sheetList[j].gen_val);
						if(usage == null || usage == "" || usage == "null") {
							reUsage = null;
						} else {
							var map = convertUnitFormat(usage, "kWh", 1);
							reUsage = Math.round( Number(map.get("formatNum")) );
							dt_str_totalVal = dt_str_totalVal+reUsage;
						}
						
						break;
					}
				}
				dt_str += "<td>"+  ( (reUsage == null) ? "" : reUsage ) +"</td>";
				
				
				if(dt_col_cnt == dt_col) {
					dt_str += "<td>"+dt_str_totalVal+"</td>";
					feture_data_pc[dt_row_cnt-1] = dt_str;
					dt_str_head = "";
					dt_str = "";
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_totalVal = 0;
				} else {
					if((i+1) == sheetList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str += "<td></td>";
						}
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						feture_data_pc[dt_row_cnt-1] = dt_str;
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
				var usage = String(chartList[i].gen_val);
				var reUsage = 0;
				if(usage == null || usage == "" || usage == "null") {
					reUsage = null;
				} else {
					var map = convertUnitFormat(usage, "kWh", 1);
					reUsage = Math.round( Number(map.get("formatNum")) );
					totalUsage = totalUsage+Number(usage);
				}
				var tm = new Date(chartList[i].std_date);
				// 차트데이터 셋팅
				dataSet.push([ setChartDateUTC(chartList[i].std_date), reUsage ]);
				
			}
			
		}
		feturePVGenList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalUsage), "feturePvGenTot", "kWh");
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '실제 발전량',
			color: '#438fd7', /* 실제 발전량 */
			type:'column',
			data: pastPVGenList
		}, false);
		
		myChart.addSeries({
			name: '예측 발전량',
			color: '#13af67', /* 예측 발전량 */
			dashStyle: 'ShortDash',
			data: feturePVGenList
		}, false);
		
		setTickInterval();
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다..(내일해내일)
		$div = $("#pc_use_dataDiv");
		$div.empty(); // 초기화
		if(real_data_pc.length < 1) {
			$(".pv_chart").find(".inchart-nodata").css("display", "");
			$(".pv_chart").find(".inchart").css("display", "none");
			$div.prepend(
					$('<div class="chart_table" />').append(
							$('<table class="pc_use" />').append(
									$("<thead/>").append( $("<tr/>").append(  
											"<th width='33%'></th><td width='34%'>조회 결과가 없습니다.</td><th width='33%'></th>" ) 
									) // thead
							)
					)
			);
		} else {
			$(".pv_chart").find(".inchart-nodata").css("display", "none");
			$(".pv_chart").find(".inchart").css("display", "");
			for(var i=dt_row-1; i>-1; i--) {
				$div.prepend(
						$('<div class="chart_table" />').append(
								$('<table class="pc_use" />').append(
										$("<thead/>").append( $("<tr/>").append( pv_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append( // 실제 사용량
														'<th><div class="ctit pv1"><span>실제 발전량</span></div></th>'+real_data_pc[i]
												)
										).append(
												$("<tr/>").append( // 예측 사용량
														'<th><div class="ctit pv2"><span>예측 발전량</span></div></th>'+ feture_data_pc[i] 
												)
										)
								) 
						)
				);
				
			}
		}
		
	}
