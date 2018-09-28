	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
	var ess_head_pc = new Array(); // 실제 사용량 표 데이터
	var realChg_data_pc = new Array(); // 실제 충전량 표 데이터
	var realDischg_data_pc = new Array(); // 실제 방전량 표 데이터
	var fetureChg_data_pc = new Array(); //  예측 충전량 표 데이터
	var fetureDischg_data_pc = new Array(); //  예측 방전량 표 데이터
	function getDBData(formData) {
		 realChg_data_pc.length = 0;
		 fetureChg_data_pc.length = 0;
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getESSChargeRealList(formData); // 실제충방전량 조회
		getESSChargeFutureList(formData); // 예측충방전량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// 실제 충방전량 조회
	var pastChgList;
	var pastDischgList;
	function callback_getESSChargeRealList(result) {
		var resultListMap = result.resultListMap;
		
		var chgList = resultListMap.chgList;
		var dischgList = resultListMap.dischgList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str2 = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		if(chgList != null && chgList.length > 0) {
			for(var i=0; i<chgList.length; i++) {
				var chgVal = String(chgList[i].chg_val);
				var dischgVal   = String(dischgList[i].dischg_val);
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
				
				var tm = new Date( convertDateUTC(chgList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push( [setChartDateUTC(chgList[i].std_timestamp), reChgVal] );
				dataSet2.push( [setChartDateUTC(chgList[i].std_timestamp), reDischgVal] );

				// 표데이터 셋팅
				var headerDate2 = convertDataTableHeaderDate(tm, 2);
				dt_str_head += "<th>"+headerDate2+"</th>"
				dt_str += "<td>"+  ( (reChgVal == null) ? "" : reChgVal ) +"</td>"; // 충전량
				dt_str2 += "<td>"+ ( (reDischgVal == null) ? "" : reDischgVal    ) +"</td>"; // 방전량
				dt_str_totalVal = dt_str_totalVal+ reChgVal;
				dt_str2_totalVal = dt_str2_totalVal+ reDischgVal;
				if(dt_col_cnt == dt_col) {
					var headerDate1 = convertDataTableHeaderDate(tm, 1);
					var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
					dt_str += "<td>"+  dt_str_totalVal  +"</td>"; // 충전량
					dt_str2 += "<td>"+ dt_str2_totalVal +"</td>"; // 방전량
					ess_head_pc[dt_row_cnt-1] = final_dt_str_head;
					realChg_data_pc[dt_row_cnt-1] = dt_str;
					realDischg_data_pc[dt_row_cnt-1] = dt_str2;
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_head = "";
					dt_str  = ""; 
					dt_str2 = ""; 
					dt_str_totalVal =  0;
					dt_str2_totalVal = 0;
				} else {
					if(SelTerm == "day" && dt_col_cnt == chgList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						var headerDate1 = convertDataTableHeaderDate(tm, 1);
						var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str += "<td></td>";
							dt_str2 += "<td></td>";
						}
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						dt_str2 += "<td>"+dt_str2_totalVal+"</td>";
						ess_head_pc[dt_row_cnt-1] = final_dt_str_head;
						realChg_data_pc[dt_row_cnt-1] = dt_str;
						realDischg_data_pc[dt_row_cnt-1] = dt_str2;
						dt_str_head = "";
						dt_str = "";
						dt_str2 = "";
						dt_str_totalVal = 0;
						dt_str2_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
					
				}
				
			}
			
		}
		pastChgList = dataSet;
		pastDischgList = dataSet2;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalDataSet), "pastChgTot", "Wh");
		unit_format(String(totalDataSet2), "pastDischgTot", "Wh");
	}
	
	// 예측 충방전량
	var fetureChgList;
	var fetureDischgList;
	function callback_getESSChargeFutureList(result) {
		var resultListMap = result.resultListMap;
		
		var chgList = resultListMap.chgList;
		var dischgList = resultListMap.dischgList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
//		var dt_str_head = "";
		var dt_str = "";
		var dt_str2 = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		if(chgList != null && chgList.length > 0) {
			for(var i=0; i<chgList.length; i++) {
				var chgVal = String(chgList[i].chg_val);
				var dischgVal   = String(dischgList[i].dischg_val);
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
				
				var tm = new Date( convertDateUTC(chgList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push( [setChartDateUTC(chgList[i].std_timestamp), reChgVal] );
				dataSet2.push( [setChartDateUTC(chgList[i].std_timestamp), reDischgVal] );

				// 표데이터 셋팅
				var headerDate2 = convertDataTableHeaderDate(tm, 2);
//				dt_str_head += "<th>"+headerDate2+"</th>"
				dt_str += "<td>"+  ( (reChgVal == null) ? "" : reChgVal ) +"</td>"; // 충전량
				dt_str2 += "<td>"+ ( (reDischgVal == null) ? "" : reDischgVal    ) +"</td>"; // 방전량
				dt_str_totalVal = dt_str_totalVal+ reChgVal;
				dt_str2_totalVal = dt_str2_totalVal+ reDischgVal;
				if(dt_col_cnt == dt_col) {
//					var headerDate1 = convertDataTableHeaderDate(tm, 1);
//					var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
					dt_str += "<td>"+  dt_str_totalVal  +"</td>"; // 충전량
					dt_str2 += "<td>"+ dt_str2_totalVal +"</td>"; // 방전량
//					ess_head_pc[dt_row_cnt-1] = final_dt_str_head;
					fetureChg_data_pc[dt_row_cnt-1] = dt_str;
					fetureDischg_data_pc[dt_row_cnt-1] = dt_str2;
					dt_row_cnt++;
					dt_col_cnt = 1;
//					dt_str_head = "";
					dt_str  = ""; 
					dt_str2 = ""; 
					dt_str_totalVal =  0;
					dt_str2_totalVal = 0;
				} else {
					if(SelTerm == "day" && dt_col_cnt == chgList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
//						var headerDate1 = convertDataTableHeaderDate(tm, 1);
//						var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str += "<td></td>";
							dt_str2 += "<td></td>";
						}
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						dt_str2 += "<td>"+dt_str2_totalVal+"</td>";
//						ess_head_pc[dt_row_cnt-1] = final_dt_str_head;
						fetureChg_data_pc[dt_row_cnt-1] = dt_str;
						fetureDischg_data_pc[dt_row_cnt-1] = dt_str2;
//						dt_str_head = "";
						dt_str = "";
						dt_str2 = "";
						dt_str_totalVal = 0;
						dt_str2_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
					
				}
				
			}
			
		}
		fetureChgList = dataSet;
		fetureDischgList = dataSet2;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalDataSet), "fetureChgTot", "Wh");
		unit_format(String(totalDataSet2), "fetureDischgTot", "Wh");
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			type: 'column',
	        name: '충전량',
	        color: '#438fd7',
			data: pastChgList
		}, false);
		
		myChart.addSeries({
			type: 'line',
	        name: '충전 계획',
	        color: '#13af67',
	        dashStyle: 'ShortDash',
			data: pastDischgList
		}, false);
		
		myChart.addSeries({
			type: 'column',
	        name: '방전량',
	        color: '#f75c4a',
			data: fetureChgList
		}, false);
		
		myChart.addSeries({
			type: 'line',
	        name: '방전 계획',
	        color: '#84848f',
	        dashStyle: 'ShortDash',
			data: fetureDischgList
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
		if(realChg_data_pc.length < 1) {
			$div.prepend(
					$('<div class="chart_table" />').append(
							$('<table class="pc_use" />').append(
									$("<thead/>").append( $("<tr/>").append(  
											"<th width='33%'></th><td width='34%'>조회된 데이터가 없습니다</td><th width='33%'></th>" ) 
									) // thead
							)
					)
			);
		} else {
			for(var i=dt_row-1; i>-1; i--) {
				$div.prepend(
						$('<div class="chart_table" />').append(
								$('<table class="pc_use" />').append(
										$("<thead/>").append( $("<tr/>").append( ess_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append( // 실제 사용량
														'<th><div class="ctit es1"><span>충전량</span></div></th>'+realChg_data_pc[i]
												)
										).append(
												$("<tr/>").append( // 예측 사용량
														'<th><div class="ctit es2"><span>충전 계획</span></div></th>'+ realDischg_data_pc[i]
												)
										).append(
												$("<tr/>").append( // 예측 사용량
														'<th><div class="ctit es3"><span>방전량</span></th>'+ fetureChg_data_pc[i]
												)
										).append(
												$("<tr/>").append( // 예측 사용량
														'<th><div class="ctit es4"><span>방전 계획</span></th>'+ fetureDischg_data_pc[i]
												)
										)
								) 
						)
				);
				
			}
		}
	}
