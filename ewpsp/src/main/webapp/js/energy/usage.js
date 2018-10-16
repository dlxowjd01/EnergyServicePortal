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
		var usageList = result.list;
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str_totVal = 0; // 테이블 라인별 누적합
		if(usageList != null && usageList.length > 0) {
			for(var i=0; i<usageList.length; i++) {
				var usage = String(usageList[i].usg_val);
				var substr_usage = 0;
				if(usage == null || usage == "" || usage == "null") {
					substr_usage = null;
				} else {
					if(usage.length < 7) substr_usage = Number(     usage     ); // 나중에 수정 요망
					else substr_usage = Number(     usage.substring( 0, usage.length-6 )     );
					totUsage = totUsage+Number(usage);
				}
				
				var tm = new Date( convertDateUTC(usageList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push([ //Number(usageList[i].std_timestamp)
//					Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
					setChartDateUTC(usageList[i].std_timestamp)
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
					usage_head_pc[dt_row_cnt-1] = final_dt_str_head;
					real_data_pc[dt_row_cnt-1] = dt_str;
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_head = "";
					dt_str = "";
					dt_str_totVal = 0;
				} else {
					if( (i+1) == usageList.length ) { // 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str_head += "<th></th>";
							dt_str += "<td></td>";
						}
						var headerDate1 = convertDataTableHeaderDate(tm, 1);
						var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
						dt_str += "<td>"+dt_str_totVal+"</td>";
						usage_head_pc[dt_row_cnt-1] = final_dt_str_head;
						real_data_pc[dt_row_cnt-1] = dt_str;
						dt_str_head = "";
						dt_str = "";
						dt_str_totVal = 0;
					} else {
						dt_col_cnt++;
					}
				}
				
			}
			
		}
		pastUsageList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "pastUseTot", "Wh");
	}
	
	// 예측 사용량
	var fetureUsageList;
	function callback_getUsageFutureList(result) {
		var usageList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totVal = 0; // 테이블 라인별 누적합
		if(usageList != null && usageList.length > 0) {
			for(var i=0; i<usageList.length; i++) {
				var usage = String(usageList[i].pre_usg_val);
				var substr_usage = 0;
				if(usage == null || usage == "" || usage == "null") {
					substr_usage = null;
				} else {
					if(usage.length < 7) substr_usage = Number(     usage     );
					else substr_usage = Number(     usage.substring( 0, usage.length-6 )     );
					totUsage = totUsage+Number(usage);
				}
				
				var tm = new Date( convertDateUTC(usageList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push([ //Number(usageList[i].std_timestamp)
//					Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
					setChartDateUTC(usageList[i].std_timestamp)
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
					if( (i+1) == usageList.length ) { // 조회한 목록이 라인을 다 못채울 때
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
			
		}
		fetureUsageList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "futureUseTot", "Wh");
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
		
//		if(pastUsageList.length == 0 && fetureUsageList.length == 0) {
//			$(".usage_chart").find("#inchart_nodata").css("display", "");
//			$(".usage_chart").find("#inchart_data").css("display", "none");
//		} else {
//			$(".usage_chart").find("#inchart_nodata").css("display", "none");
//			$(".usage_chart").find("#inchart_data").css("display", "");
//		}
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다
		$div = $("#pc_use_dataDiv");
		$div.empty(); // 초기화
		if(real_data_pc.length < 1) {
			$div.prepend(
					$('<div class="chart_table" />').append( // pc_use_dataTable
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


