	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
	var usage_head_pc = new Array(); // 표 영역 헤더
	var real_data_pc = new Array(); // 한전 사용량 표 데이터
	var ess_data_pc = new Array(); //  ess 사용량 표 데이터
	var pv_data_pc = new Array(); //  pv 사용량 표 데이터
	function getDBData(formData) {
		usage_head_pc.length = 0;
		real_data_pc.length = 0;
		ess_data_pc.length = 0;
		pv_data_pc.length = 0;
		
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getDERUsageList(formData);
		drawData(); // 차트 및 표 그리기
	}
	
	var pastUsageList; // 한전 사용량
	var essUsageList; // ess 사용량
	var pvUsageList; // pv 사용량 사용량
	function callback_getDERUsageList(result) {
		var kepcoUsageList = result.kepcoUsageList;
		var essUsgList = result.essUsageList;
		var pvUsgList = result.pvUsageList;
		var loopCntList = result.loopCntList; // for문 loop list
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totalDataSet = 0; // 전체 누적합
		var totalDataSet2 = 0;
		var totalDataSet3 = 0;
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str2 = "";
		var dt_str3 = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		var dt_str3_totalVal = 0; // 테이블 라인별 누적합
		
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
//							reKepcoUsage = Math.round( Number(kepcoUsage) );
							if(kepcoUsage.length < 7) reKepcoUsage = Number(     kepcoUsage     ); // 나중에 수정 요망
							else reKepcoUsage = Number(     kepcoUsage.substring( 0, kepcoUsage.length-6 )     );
							totalDataSet = totalDataSet+Number(kepcoUsage);
						}
						
					} else reKepcoUsage = null;
					if(essUsgList.length > 0) { // ESS 사용량
						essUsage = String(essUsgList[i].usg_val);
						if(essUsage == null || essUsage == "" || essUsage == "null") reEssUsage = null;
						else {
//							reEssUsage = Math.round( Number(essUsage) );
							if(essUsage.length < 7) reEssUsage = Number(     essUsage     ); // 나중에 수정 요망
							else reEssUsage = Number(     essUsage.substring( 0, essUsage.length-6 )     );
							totalDataSet2 = totalDataSet2+Number(essUsage);
						}
					} else reEssUsage = null;
					if(pvUsgList.length > 0) { // PV 사용량
						pvUsage = String(pvUsgList[i].usg_val);
						if(pvUsage == null || pvUsage == "" || pvUsage == "null") rePvUsage = null;
						else {
//							rePvUsage = Math.round( Number(pvUsage) );
							if(pvUsage.length < 7) rePvUsage = Number(     pvUsage     ); // 나중에 수정 요망
							else rePvUsage = Number(     pvUsage.substring( 0, pvUsage.length-6 )     );
							totalDataSet3 = totalDataSet3+Number(pvUsage);
						}
					} else rePvUsage = null;
					
					var tm = new Date( convertDateUTC(loopCntList[i].std_timestamp) );
					// 차트데이터 셋팅
					dataSet.push([ // Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
						setChartDateUTC(loopCntList[i].std_timestamp) , reKepcoUsage
					]);
					dataSet2.push([ // Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
						setChartDateUTC(loopCntList[i].std_timestamp) , reEssUsage
					]);
					dataSet3.push([ // Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
						setChartDateUTC(loopCntList[i].std_timestamp) , rePvUsage
					]);
					
					// 표데이터 셋팅
					var headerDate2 = convertDataTableHeaderDate(tm, 2);
					dt_str_head += "<th>"+headerDate2+"</th>"
//					if(kepcoUsage == null || kepcoUsage == "" || kepcoUsage == "null") dt_str += "<td>"+" "+"</td>"; 
//					else dt_str += "<td>"+reKepcoUsage+"</td>";
					dt_str += "<td>"+  ( (reKepcoUsage == null) ? "" : reKepcoUsage ) +"</td>"; // 총 발전량
					dt_str2 += "<td>"+ ( (reEssUsage == null) ? "" : reEssUsage    ) +"</td>"; // SMP 거래량
					dt_str3 += "<td>"+ ( (rePvUsage == null) ? "" : rePvUsage   ) +"</td>"; // SMP 수익
					
					dt_str_totalVal = dt_str_totalVal+reKepcoUsage;
					dt_str2_totalVal = dt_str2_totalVal+ reEssUsage;
					dt_str3_totalVal = dt_str3_totalVal+ rePvUsage;
					if(dt_col_cnt == dt_col) {
						var headerDate1 = convertDataTableHeaderDate(tm, 1);
						var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						dt_str2 += "<td>"+dt_str2_totalVal+"</td>";
						dt_str3 += "<td>"+dt_str3_totalVal+"</td>";
						usage_head_pc[dt_row_cnt-1] = final_dt_str_head;
						real_data_pc[dt_row_cnt-1] = dt_str;
						ess_data_pc[dt_row_cnt-1] = dt_str2;
						pv_data_pc[dt_row_cnt-1] = dt_str3;
						dt_row_cnt++;
						dt_col_cnt = 1;
						dt_str_head = "";
						dt_str = "";
						dt_str2 = "";
						dt_str3 = "";
						dt_str_totalVal = 0;
						dt_str2_totalVal = 0;
						dt_str3_totalVal = 0;
					} else {
//						if( (i+1) == kepcoUsageList.length ) { // 조회한 목록이 라인을 다 못채울 때
						if( (i+1) == loopCntList.length ) { // 조회한 목록이 라인을 다 못채울 때
							var headerDate1 = convertDataTableHeaderDate(tm, 1);
							var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
							for(a=0; a<(dt_col-dt_col_cnt); a++) {
								dt_str += "<td></td>";
								dt_str2 += "<td></td>";
								dt_str3 += "<td></td>";
							}
							dt_str += "<td>"+dt_str_totalVal+"</td>";
							dt_str2 += "<td>"+dt_str_totalVal+"</td>";
							dt_str3 += "<td>"+dt_str_totalVal+"</td>";
							usage_head_pc[dt_row_cnt-1] = final_dt_str_head;
							real_data_pc[dt_row_cnt-1] = dt_str;
							ess_data_pc[dt_row_cnt-1] = dt_str2;
							pv_data_pc[dt_row_cnt-1] = dt_str3;
							dt_str_head = "";
							dt_str = "";
							dt_str2 = "";
							dt_str3 = "";
							dt_str_totalVal = 0;
							dt_str2_totalVal = 0;
							dt_str3_totalVal = 0;
						} else {
							dt_col_cnt++;
						}
					}
					
				}
				pastUsageList = dataSet;
				essUsageList = dataSet2;
				pvUsageList = dataSet3;
				
				if(kepcoUsageList.length > 0) {
					myChart.addSeries({
						index:3,
						fillOpacity: 1,
						name: '실제 사용량',
						color: '#FFFFFF',
						lineColor: '#438fd7', /* 한전 사용량 */
						data: pastUsageList
					}, false);
					
				}
				
				if(essUsgList.length > 0) {
					myChart.addSeries({
						index: 2,
						fillOpacity: 0.5,
						name: 'ESS 사용량',
						color: '#13af67', /* ESS 사용량 */
						data: essUsageList
					}, false);
					
				}
				
				if(pvUsgList.length > 0) {
					myChart.addSeries({
						index: 1,
						fillOpacity: 0.5,
						name: 'PV 사용량',
						color: '#f75c4a', /* PV 사용량 */
						data: pvUsageList
					}, false);
					
				}
				
//			}
			
		}
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalDataSet), "usageTotal", "Wh");
		unit_format(String(totalDataSet2), "essUsageTotal", "Wh");
		unit_format(String(totalDataSet3), "pvUsageTotal", "Wh");
		
		var total = totalDataSet+totalDataSet2+totalDataSet3;
		$("#kepcoPer").empty().append("한전 사용").append( $("<span />").append( (  (totalDataSet/total)*100  ).toFixed(2)+"%" ) );
		$("#essPer").empty().append("ESS 사용").append( $("<span />").append( (  (totalDataSet2/total)*100  ).toFixed(2)+"%" ) );
		$("#pvPer").empty().append("PV 사용").append( $("<span />").append( (  (totalDataSet3/total)*100  ).toFixed(2)+"%" ) );
		
	}
	
	// 차트 그리기
	function drawData_chart() {
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
										$("<thead/>").append( $("<tr/>").append( usage_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append( // 한전 사용량
														'<th><div class="ctit ct1"><span>한전 사용량</span></div></th>'+real_data_pc[i]
												)
										).append(
												$("<tr/>").append( // ESS 사용량
														'<th><div class="ctit"><span>ESS 사용량</span></div></th>'+ ess_data_pc[i]
												)
										).append(
												$("<tr/>").append( // PV 사용량
														'<th><div class="ctit"><span>PV 사용량</span></div></th>'+ pv_data_pc[i]
												)
										)
								) 
						)
				);
				
			}
		}
	}
