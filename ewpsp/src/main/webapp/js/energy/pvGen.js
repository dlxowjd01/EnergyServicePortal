	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
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
		var pvGenList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str_totVal = 0; // 테이블 라인별 누적합
		for(var i=0; i<pvGenList.length; i++) {
			var usage = String(pvGenList[i].gen_val);
			var substr_usage = 0;
			if(usage == null || usage == "" || usage == "null") {
				substr_usage = null;
			} else {
				if(usage.length < 7) substr_usage = Number(     usage     ); // 나중에 수정 요망
				else substr_usage = Number(     usage.substring( 0, usage.length-6 )     );
				totUsage = totUsage+Number(usage);
			}
			
			var tm = new Date(pvGenList[i].std_date);
			// 차트데이터 셋팅
			dataSet.push([ //Number(pvGenList[i].std_date)
				Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
				, substr_usage
			]);
			
			// 표데이터 셋팅
			var headerDate2 = convertDataTableHeaderDate(tm, 2);
			dt_str_head += "<th>"+headerDate2+"</th>"
			if(usage == null || usage == "" || usage == "null") dt_str += "<td>"+" "+"</td>"; 
			else dt_str += "<td>"+substr_usage+"</td>";
			dt_str_totVal = dt_str_totVal+substr_usage;
			if(dt_col_cnt == dt_col) {
				var headerDate1 = convertDataTableHeaderDate(tm, 1);
				var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
				dt_str += "<td>"+dt_str_totVal+"</td>";
				pv_head_pc[dt_row_cnt-1] = final_dt_str_head;
				real_data_pc[dt_row_cnt-1] = dt_str;
				dt_row_cnt++;
				dt_col_cnt = 1;
				dt_str_head = "";
				dt_str = "";
				dt_str_totVal = 0;
			} else {
				if(SelTerm == "day" && dt_col_cnt == pvGenList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
					var headerDate1 = convertDataTableHeaderDate(tm, 1);
					var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
					for(a=0; a<(dt_col-dt_col_cnt); a++) {
						dt_str += "<td></td>";
					}
					dt_str += "<td>"+dt_str_totVal+"</td>";
					pv_head_pc[dt_row_cnt-1] = final_dt_str_head;
					real_data_pc[dt_row_cnt-1] = dt_str;
					dt_str_head = "";
					dt_str = "";
					dt_str_totVal = 0;
				} else {
					dt_col_cnt++;
				}
			}
			
		}
		pastPVGenList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "pastPvGenTot", "Wh");
	}
	
	// PV 예측 발전량
	var feturePVGenList;
	function callback_getPVGenFutureList(result) {
		var pvGenList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totVal = 0; // 테이블 라인별 누적합
		for(var i=0; i<pvGenList.length; i++) {
			var usage = String(pvGenList[i].gen_val);
			var substr_usage = 0;
			var substr_usage = 0;
			if(usage == null || usage == "" || usage == "null") {
				substr_usage = null;
			} else {
				if(usage.length < 7) substr_usage = Number(     usage     ); // 나중에 수정 요망
				else substr_usage = Number(     usage.substring( 0, usage.length-6 )     );
				totUsage = totUsage+Number(usage);
			}
			var tm = new Date(pvGenList[i].std_date);
			// 차트데이터 셋팅
			dataSet.push([ //Number(pvGenList[i].std_date)
				Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
//				pvGenList[i].std_timestamp, substr_usage
				, substr_usage
			]);
			
			// 표데이터 셋팅
			if(usage == null || usage == "" || usage == "null") dt_str += "<td>"+" "+"</td>"; 
			else dt_str += "<td>"+substr_usage+"</td>";
			dt_str_totVal = dt_str_totVal+substr_usage;
			if(dt_col_cnt == dt_col) {
				dt_str += "<td>"+dt_str_totVal+"</td>";
				feture_data_pc[dt_row_cnt-1] = dt_str;
				dt_row_cnt++;
				dt_col_cnt = 1;
				dt_str = "";
				dt_str_totVal = 0;
			} else {
				if(SelTerm == "day" && dt_col_cnt == pvGenList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
					for(a=0; a<(dt_col-dt_col_cnt); a++) {
						dt_str += "<td></td>";
					}
					dt_str += "<td>"+dt_str_totVal+"</td>";
					feture_data_pc[dt_row_cnt-1] = dt_str;
					dt_str = "";
					dt_str_totVal = 0;
				} else {
					dt_col_cnt++;
				}
			}
			
		}
		feturePVGenList = dataSet;
//		feture_data_pc[dt_row_cnt-1] = dt_str;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "feturePvGenTot", "Wh");
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
