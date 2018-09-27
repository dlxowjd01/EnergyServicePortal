	$(document).ready(function() {
		var firstDay = new Date();
		var endDay = new Date();
		firstDay.setYear(firstDay.getFullYear()-1);
		firstDay = new Date(firstDay.setMonth(firstDay.getMonth()+1));
		$("#selTermFrom").val( firstDay.format("yyyyMM") );
		$("#selTermTo").val( endDay.format("yyyyMM") );
		$("#datepicker3").val( firstDay.format("yyyy-MM") );
		$("#datepicker4").val( endDay.format("yyyy-MM") );
		SelTerm = "billSelectMM";
		$("#selTerm").val(SelTerm);
		
		var formData = $("#schForm").serializeObject();
		getDBData(formData);
	});
	
	var drRevenue_head_pc = new Array(); //  표 데이터(헤더)
	var drRevenue_data_pc = new Array(); //  표 데이터
	var drRevenue_data_pc2 = new Array(); //  표 데이터
	var drRevenue_data_pc3 = new Array(); //  표 데이터
	var drRevenue_data_pc4 = new Array(); //  표 데이터
	var drRevenue_data_pc5 = new Array(); //  표 데이터
	var drRevenue_data_pc6 = new Array(); //  표 데이터
	var drRevenue_data_pc7 = new Array(); //  표 데이터
	var drRevenue_data_pc8 = new Array(); //  표 데이터
	var drRevenue_data_pc9 = new Array(); //  표 데이터
	var drRevenue_data_pc10 = new Array(); //  표 데이터
	function getDBData(formData) {
		drRevenue_head_pc.length = 0;
		drRevenue_data_pc.length = 0;
		drRevenue_data_pc2.length = 0;
		drRevenue_data_pc3.length = 0;
		drRevenue_data_pc4.length = 0;
		drRevenue_data_pc5.length = 0;
		drRevenue_data_pc6.length = 0;
		drRevenue_data_pc7.length = 0;
		drRevenue_data_pc8.length = 0;
		drRevenue_data_pc9.length = 0;
		drRevenue_data_pc10.length = 0;
		drRevenueList1 = null;
		drRevenueList2 = null;
		getDRRevenueList(formData); // DR 수익 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// DR 수익 조회
	var drRevenueList1;
	var drRevenueList2;
	function callback_getDRRevenueList(result) {
		var drRevenueList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var totDataSet = 0;
		var totDataSet2 = 0;
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str2 = "";
		var dt_str3 = "";
		var dt_str4 = "";
		var dt_str5 = "";
		var dt_str6 = "";
		var dt_str7 = "";
		var dt_str8 = "";
		var dt_str9 = "";
		var dt_str10 = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		var dt_str3_totalVal = 0; // 테이블 라인별 누적합
		var dt_str4_totalVal = 0; // 테이블 라인별 누적합
		var dt_str5_totalVal = 0; // 테이블 라인별 누적합
		var dt_str6_totalVal = 0; // 테이블 라인별 누적합
		var dt_str7_totalVal = 0; // 테이블 라인별 누적합
		var dt_str8_totalVal = 0; // 테이블 라인별 누적합
		var dt_str9_totalVal = 0; // 테이블 라인별 누적합
		var dt_str10_totalVal = 0; // 테이블 라인별 누적합
		
		if(drRevenueList.length > 0) {
			for(var i=0; i<drRevenueList.length; i++) {
				var yyyyMM = drRevenueList[i].std_yearm;
				var reductCntHour  = String(drRevenueList[i].reduct_cnt_hour)   ;
				var reductCap  = String(drRevenueList[i].reduct_cap)   ;
				var reductAmt  = String(drRevenueList[i].reduct_amt);
				var reductCapPer  = String(drRevenueList[i].reduct_cap_per);
				var capAmt  = String(drRevenueList[i].cap_amt);
				var reductRewardAmt  = String(drRevenueList[i].reduct_reward_amt)   ;
				var totalRewardAmt  = String(drRevenueList[i].total_reward_amt)   ;
				var csmRewardAmt  = String(drRevenueList[i].csm_reward_amt)   ;
				var ewpRewardAmt  = String(drRevenueList[i].ewp_reward_amt)   ;
				var profitRatio  = String(drRevenueList[i].profit_ratio)      ;
				var reReductCntHour = 0;
				var reReductCap = 0;
				var reReductAmt = 0;
				var reReductCapPer = 0;
				var reCapAmt = 0;
				var reReductRewardAmt = 0;
				var reTotalRewardAmt = 0;
				var reCsmRewardAmt = 0;
				var reEwpRewardAmt = 0;
				var reProfitRatio = 0;
				
				if(reductCntHour == null || reductCntHour == "" || reductCntHour == "null") reReductCntHour = null;
				else reReductCntHour = Math.round( Number(reductCntHour) );
				if(reductCap == null || reductCap == "" || reductCap == "null") reReductCap = null;
				else reReductCap = Math.round( Number(reductCap) );
				if(reductAmt == null || reductAmt == "" || reductAmt == "null") reReductAmt = null;
				else reReductAmt = Math.round( Number(reductAmt) );
				if(reductCapPer == null || reductCapPer == "" || reductCapPer == "null") reReductCapPer = null;
				else reReductCapPer = Math.round( Number(reductCapPer) );
				if(capAmt == null || capAmt == "" || capAmt == "null") reCapAmt = null;
				else reCapAmt = Math.round( Number(capAmt) );
				if(reductRewardAmt == null || reductRewardAmt == "" || reductRewardAmt == "null") reReductRewardAmt = null;
				else reReductRewardAmt = Math.round( Number(reductRewardAmt) );
				if(totalRewardAmt == null || totalRewardAmt == "" || totalRewardAmt == "null") reTotalRewardAmt = null;
				else {
					reTotalRewardAmt = Math.round( Number(totalRewardAmt) );
					totDataSet = totDataSet+Number(drRevenueList[i].total_reward_amt);
				}
				if(csmRewardAmt == null || csmRewardAmt == "" || csmRewardAmt == "null") reCsmRewardAmt = null;
				else {
					reCsmRewardAmt = Math.round( Number(csmRewardAmt) );
					totDataSet2 = totDataSet2+Number(String(drRevenueList[i].csm_reward_amt));
				}
				if(ewpRewardAmt == null || ewpRewardAmt == "" || ewpRewardAmt == "null") reEwpRewardAmt = null;
				else reEwpRewardAmt = Math.round( Number(ewpRewardAmt) );
				if(profitRatio == null || profitRatio == "" || profitRatio == "null") reProfitRatio = null;
				else reProfitRatio = Math.round( Number(profitRatio) );
				
				// 차트데이터 셋팅
				dataSet.push( [Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), drRevenueList[i].total_reward_amt] );
				dataSet2.push( [Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), drRevenueList[i].csm_reward_amt] );

				// 표데이터 셋팅
				dt_str_head += "<th>"+yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"</th>"
				dt_str +=   "<td>"+ ( (reReductCntHour == null) ? "" : reReductCntHour    ) +"</td>"; // 감축 횟수-시간 (회-hr)
				dt_str2 +=   "<td>"+ ( (reReductCap == null) ? "" : reReductCap    ) +"</td>"; // 감축이행용량 (kWh)
				dt_str3 +=  "<td>"+ ( (reReductAmt == null) ? "" : reReductAmt    ) +"</td>"; // 감축인정용량 (kWh)
				dt_str4 +=  "<td>"+ ( (reReductCapPer == null) ? "" : reReductCapPer    ) +"</td>"; // 감축이행율 (%)
				dt_str5 +=  "<td>"+ ( (reCapAmt == null) ? "" : reCapAmt    ) +"</td>"; // 용량정산금 (won)
				dt_str6 +=  "<td>"+ ( (reReductRewardAmt == null) ? "" : reReductRewardAmt    ) +"</td>"; // 감축정산금 (won)
				dt_str7 +=  "<td>"+ ( (reTotalRewardAmt == null) ? "" : reTotalRewardAmt    ) +"</td>"; // 총 정산금액
				dt_str8 +=  "<td>"+ ( (reCsmRewardAmt == null) ? "" : reCsmRewardAmt    ) +"</td>"; // 고객 할인금액
				dt_str9 += "<td>"+ ( (reEwpRewardAmt == null) ? "" : reEwpRewardAmt    ) +"</td>"; // EWP 정산금액 (won)
				dt_str10 +=  "<td>"+ ( (reProfitRatio == null) ? "" : reProfitRatio    ) +"</td>"; // 수익비율 (%)
				dt_str_totalVal = dt_str_totalVal+ reReductCntHour;
				dt_str2_totalVal = dt_str2_totalVal+ reReductCap;
				dt_str3_totalVal = dt_str3_totalVal+ reReductAmt;
				dt_str4_totalVal = dt_str4_totalVal+ reReductCapPer;
				dt_str5_totalVal = dt_str5_totalVal+ reCapAmt;
				dt_str6_totalVal = dt_str6_totalVal+ reReductRewardAmt;
				dt_str7_totalVal = dt_str7_totalVal+ reTotalRewardAmt;
				dt_str8_totalVal = dt_str8_totalVal+ reCsmRewardAmt;
				dt_str9_totalVal = dt_str9_totalVal+ reEwpRewardAmt;
				dt_str10_totalVal = dt_str10_totalVal+ reProfitRatio;
				if(dt_col_cnt == 12) {
					dt_str +=   "<td>"+ dt_str_totalVal  +"</td>"; 
					dt_str2 +=  "<td>"+ dt_str2_totalVal  +"</td>";
					dt_str3 +=  "<td>"+ dt_str3_totalVal  +"</td>";
					dt_str4 +=  "<td>"+ dt_str4_totalVal  +"</td>";
					dt_str5 +=  "<td>"+ dt_str5_totalVal  +"</td>";
					dt_str6 +=  "<td>"+ dt_str6_totalVal  +"</td>";
					dt_str7 +=  "<td>"+ dt_str7_totalVal  +"</td>";
					dt_str8 +=  "<td>"+ dt_str8_totalVal  +"</td>";
					dt_str9 +=  "<td>"+ dt_str9_totalVal  +"</td>";
					dt_str10 += "<td>"+ dt_str10_totalVal +"</td>";
					drRevenue_head_pc[dt_row_cnt-1] = dt_str_head;
					drRevenue_data_pc[dt_row_cnt-1] = dt_str;
					drRevenue_data_pc2[dt_row_cnt-1] = dt_str2;
					drRevenue_data_pc3[dt_row_cnt-1] = dt_str3;
					drRevenue_data_pc4[dt_row_cnt-1] = dt_str4;
					drRevenue_data_pc5[dt_row_cnt-1] = dt_str5;
					drRevenue_data_pc6[dt_row_cnt-1] = dt_str6;
					drRevenue_data_pc7[dt_row_cnt-1] = dt_str7;
					drRevenue_data_pc8[dt_row_cnt-1] = dt_str8;
					drRevenue_data_pc9[dt_row_cnt-1] = dt_str9;
					drRevenue_data_pc10[dt_row_cnt-1] = dt_str10;
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str = "";
					dt_str2 = "";
					dt_str3 = "";
					dt_str4 = "";
					dt_str5 = "";
					dt_str6 = "";
					dt_str7 = "";
					dt_str8 = "";
					dt_str9 = "";
					dt_str10 = "";
					dt_str_totalVal = 0; 
					dt_str2_totalVal = 0; 
					dt_str3_totalVal = 0; 
					dt_str4_totalVal = 0; 
					dt_str5_totalVal = 0; 
					dt_str6_totalVal = 0; 
					dt_str7_totalVal = 0; 
					dt_str8_totalVal = 0; 
					dt_str9_totalVal = 0; 
					dt_str10_totalVal = 0;
				} else {
					if( (i+1) == drRevenueList.length ) { // 조회한 목록이 라인을 다 못채울 때
//						var headerDate1 = convertDataTableHeaderDate(tm, 1);
						var final_dt_str_head = dt_str_head;
						for(a=0; a<(12-dt_col_cnt); a++) {
							dt_str_head += "<th></th>";
							dt_str += "<td></td>";
							dt_str2 += "<td></td>";
							dt_str3 += "<td></td>";
							dt_str4 += "<td></td>";
							dt_str5 += "<td></td>";
							dt_str6 += "<td></td>";
							dt_str7 += "<td></td>";
							dt_str8 += "<td></td>";
							dt_str9 += "<td></td>";
							dt_str10 += "<td></td>";
						}
						dt_str +=   "<td>"+ dt_str_totalVal  +"</td>"; 
						dt_str2 +=  "<td>"+ dt_str2_totalVal  +"</td>";
						dt_str3 +=  "<td>"+ dt_str3_totalVal  +"</td>";
						dt_str4 +=  "<td>"+ dt_str4_totalVal  +"</td>";
						dt_str5 +=  "<td>"+ dt_str5_totalVal  +"</td>";
						dt_str6 +=  "<td>"+ dt_str6_totalVal  +"</td>";
						dt_str7 +=  "<td>"+ dt_str7_totalVal  +"</td>";
						dt_str8 +=  "<td>"+ dt_str8_totalVal  +"</td>";
						dt_str9 +=  "<td>"+ dt_str9_totalVal  +"</td>";
						dt_str10 += "<td>"+ dt_str10_totalVal +"</td>";
						drRevenue_head_pc[dt_row_cnt-1] = dt_str_head;
						drRevenue_data_pc[dt_row_cnt-1] = dt_str;
						drRevenue_data_pc2[dt_row_cnt-1] = dt_str2;
						drRevenue_data_pc3[dt_row_cnt-1] = dt_str3;
						drRevenue_data_pc4[dt_row_cnt-1] = dt_str4;
						drRevenue_data_pc5[dt_row_cnt-1] = dt_str5;
						drRevenue_data_pc6[dt_row_cnt-1] = dt_str6;
						drRevenue_data_pc7[dt_row_cnt-1] = dt_str7;
						drRevenue_data_pc8[dt_row_cnt-1] = dt_str8;
						drRevenue_data_pc9[dt_row_cnt-1] = dt_str9;
						drRevenue_data_pc10[dt_row_cnt-1] = dt_str10;
						dt_row_cnt++;
						dt_col_cnt = 1;
						dt_str = "";
						dt_str2 = "";
						dt_str3 = "";
						dt_str4 = "";
						dt_str5 = "";
						dt_str6 = "";
						dt_str7 = "";
						dt_str8 = "";
						dt_str9 = "";
						dt_str10 = "";
						dt_str_totalVal = 0; 
						dt_str2_totalVal = 0; 
						dt_str3_totalVal = 0; 
						dt_str4_totalVal = 0; 
						dt_str5_totalVal = 0; 
						dt_str6_totalVal = 0; 
						dt_str7_totalVal = 0; 
						dt_str8_totalVal = 0; 
						dt_str9_totalVal = 0; 
						dt_str10_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
					
				}
				
			}
			drRevenueList1 = dataSet;
			drRevenueList2 = dataSet2;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format(String(totDataSet), "drRevenueTot1", "won");
			unit_format(String(totDataSet2), "drRevenueTot2", "won");
		}
		
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '고객 정산금액',
			color: '#438fd7', /* 총 정산금액 */
			data: drRevenueList1
		}, false);
		
		myChart.addSeries({
			name: '실적 할인금액',
			color: '#84848f', /* 고객 할인금액 */
			data: drRevenueList2
		}, false);
		
//		setTickInterval();
		myChart.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다
		$table = $("#pc_use_dataTable");
		$table.empty().append(
				$("<thead/>").append( $("<tr/>").append( "<th></th>"+drRevenue_head_pc[0]+"<th>합계</th>" ) ) // thead
		);
		if(drRevenue_data_pc.length < 1) {
			$table.append(
					$("<tbody/>").append( // tbody
							$("<tr/>").append( // 기본요금
									'<th colspan="14">조회된 데이터가 없습니다.</th>'
							)
					)
			);
		} else {
			$table.append(
					$("<tbody/>").append( // tbody
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>감축 횟수-시간 (회-hr)</span></div></th>'+ drRevenue_data_pc[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>감축이행용량 (kWh)</span></div></th>'+ drRevenue_data_pc2[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>감축인정용량 (kWh)</span></div></th>'+ drRevenue_data_pc3[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>감축이행율 (%)</span></div></th>'+ drRevenue_data_pc4[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>용량정산금 (won)</span></div></th>'+ drRevenue_data_pc5[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>감축정산금 (won)</span></div></th>'+ drRevenue_data_pc6[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit ct1"><span>총 정산금액</span></div></th>'+ drRevenue_data_pc7[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit"><span>고객 할인금액</span></div></th>'+ drRevenue_data_pc8[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>EWP 정산금액 (won)</span></div></th>'+ drRevenue_data_pc9[0] 
							)
					).append(
							$("<tr/>").append(
									'<th><div class="ctit wht"><span>수익비율 (%)</span></div></th>'+drRevenue_data_pc10[0]
							)
					)
			);
		}
		
	}
