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
	
	var essRevenue_head_pc = new Array(); //  표 데이터(헤더)
	var essRevenue_data_pc = new Array(); //  표 데이터
	var essRevenue_data_pc2 = new Array(); //  표 데이터
	var essRevenue_data_pc3 = new Array(); //  표 데이터
	var essRevenue_data_pc4 = new Array(); //  표 데이터
	var essRevenue_data_pc5 = new Array(); //  표 데이터
	var essRevenue_data_pc6 = new Array(); //  표 데이터
	var essRevenue_data_pc7 = new Array(); //  표 데이터
	var essRevenue_data_pc8 = new Array(); //  표 데이터
	var essRevenue_data_pc9 = new Array(); //  표 데이터
	var essRevenue_data_pc10 = new Array(); //  표 데이터
	var essRevenue_data_pc11 = new Array(); //  표 데이터
	var essRevenue_data_pc12 = new Array(); //  표 데이터
	function getDBData(formData) {
		getESSRevenueList(formData); // 실제사용량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// ESS 수익 조회
	var essRevenueList1;
	var essRevenueList2;
	function callback_getESSRevenueList(result) {
		var essRevenueList = result.list;
		
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
		var dt_str11 = "";
		var dt_str12 = "";
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
		var dt_str11_totalVal = 0; // 테이블 라인별 누적합
		var dt_str12_totalVal = 0; // 테이블 라인별 누적합
		
		if(essRevenueList.length < 1) {
			
		} else {
			for(var i=0; i<essRevenueList.length; i++) {
				var yyyyMM = essRevenueList[i].bill_yearm;
				var essBdayInMonth  = String(essRevenueList[i].ess_bdayIn_month)   ;
				var essDischgOffPeak  = String(essRevenueList[i].ess_dischg_off_peak);
				var essDischgMidPeak  = String(essRevenueList[i].ess_dischg_mid_peak);
				var essDischgMaxPeak  = String(essRevenueList[i].ess_dischg_max_peak);
				var essChgOffPeak  = String(essRevenueList[i].ess_chg_off_peak)   ;
				var essChgMidPeak  = String(essRevenueList[i].ess_chg_mid_peak)   ;
				var essChgMaxPeak  = String(essRevenueList[i].ess_chg_max_peak)   ;
				var preEssIncen  = String(essRevenueList[i].pre_ess_incen)      ;
				var essIncen  = String(essRevenueList[i].ess_incen)          ;
				var peakRate  = String(essRevenueList[i].peak_rate)          ;
				var ewpPeakRate  = String(essRevenueList[i].ewp_peak_rate)      ;
				var ratePer  = String(essRevenueList[i].rate_per)           ;
				var reEssBdayInMonth  = 0;
				var reEssDischgOffPeak  = 0;
				var reEssDischgMidPeak  = 0;
				var reEssDischgMaxPeak  = 0;
				var reEssChgOffPeak  = 0;
				var reEssChgMidPeak  = 0;
				var reEssChgMaxPeak  = 0;
				var rePreEssIncen  = 0;
				var reEssIncen  = 0;
				var rePeakRate  = 0;
				var reEwpPeakRate  = 0;
				var reRatePer  = 0;
				
				if(essBdayInMonth == null || essBdayInMonth == "" || essBdayInMonth == "null") reEssBdayInMonth = null;
				else reEssBdayInMonth = Math.round( Number(essBdayInMonth) );
				if(essDischgOffPeak == null || essDischgOffPeak == "" || essDischgOffPeak == "null") reEssDischgOffPeak = null;
				else reEssDischgOffPeak = Math.round( Number(essDischgOffPeak) );
				if(essDischgMidPeak == null || essDischgMidPeak == "" || essDischgMidPeak == "null") reEssDischgMidPeak = null;
				else reEssDischgMidPeak = Math.round( Number(essDischgMidPeak) );
				if(essDischgMaxPeak == null || essDischgMaxPeak == "" || essDischgMaxPeak == "null") reEssDischgMaxPeak = null;
				else reEssDischgMaxPeak = Math.round( Number(essDischgMaxPeak) );
				if(essChgOffPeak == null || essChgOffPeak == "" || essChgOffPeak == "null") reEssChgOffPeak = null;
				else reEssChgOffPeak = Math.round( Number(essChgOffPeak) );
				if(essChgMidPeak == null || essChgMidPeak == "" || essChgMidPeak == "null") reEssChgMidPeak = null;
				else reEssChgMidPeak = Math.round( Number(essChgMidPeak) );
				if(essChgMaxPeak == null || essChgMaxPeak == "" || essChgMaxPeak == "null") reEssChgMaxPeak = null;
				else reEssChgMaxPeak = Math.round( Number(essChgMaxPeak) );
				if(preEssIncen == null || preEssIncen == "" || preEssIncen == "null") rePreEssIncen = null;
				else rePreEssIncen = Math.round( Number(preEssIncen) );
				if(essIncen == null || essIncen == "" || essIncen == "null") reEssIncen = null;
				else {
					reEssIncen = Math.round( Number(essIncen) );
					totDataSet2 = totDataSet2+Number(String(essRevenueList[i].ess_incen));
				}
				if(peakRate == null || peakRate == "" || peakRate == "null") rePeakRate = null;
				else {
					rePeakRate = Math.round( Number(peakRate) );
					totDataSet = totDataSet+Number(essRevenueList[i].peak_rate);
				}
				if(ewpPeakRate == null || ewpPeakRate == "" || ewpPeakRate == "null") reEwpPeakRate = null;
				else reEwpPeakRate = Math.round( Number(ewpPeakRate) );
				if(ratePer == null || ratePer == "" || ratePer == "null") reRatePer = null;
				else reRatePer = Math.round( Number(ratePer) );
				
				// 차트데이터 셋팅
				dataSet.push( [//essRevenueList[i].bill_yearm, 
					Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1),
					essRevenueList[i].peak_rate] );
				dataSet2.push( [//essRevenueList[i].bill_yearm, 
					Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1),
					essRevenueList[i].ess_incen] );

				// 표데이터 셋팅
				dt_str_head += "<th>"+yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"</th>"
				dt_str +=   "<td>"+ ( (reEssBdayInMonth == null) ? "" : reEssBdayInMonth    ) +"</td>"; // 평일일수
				dt_str2 +=  "<td>"+ ( (reEssDischgOffPeak == null) ? "" : reEssDischgOffPeak    ) +"</td>"; // 경부하충전량
				dt_str3 +=  "<td>"+ ( (reEssDischgMidPeak == null) ? "" : reEssDischgMidPeak    ) +"</td>"; // 중간부하충전량
				dt_str4 +=  "<td>"+ ( (reEssDischgMaxPeak == null) ? "" : reEssDischgMaxPeak    ) +"</td>"; // 최대부하충전량
				dt_str5 +=  "<td>"+ ( (reEssChgOffPeak == null) ? "" : reEssChgOffPeak    ) +"</td>"; // 경부하방전량
				dt_str6 +=  "<td>"+ ( (reEssChgMidPeak == null) ? "" : reEssChgMidPeak    ) +"</td>"; // 중간부하방전량
				dt_str7 +=  "<td>"+ ( (reEssChgMaxPeak == null) ? "" : reEssChgMaxPeak    ) +"</td>"; // 최대부하방전량
				dt_str8 +=  "<td>"+ ( (rePreEssIncen == null) ? "" : rePreEssIncen    ) +"</td>"; // 예상 할인금액
				dt_str9 +=  "<td>"+ ( (reEssIncen == null) ? "" : reEssIncen    ) +"</td>"; // 실적 할인금액
				dt_str10 += "<td>"+ ( (rePeakRate == null) ? "" : rePeakRate    ) +"</td>"; // 고객 정산금액
				dt_str11 += "<td>"+ ( (reEwpPeakRate == null) ? "" : reEwpPeakRate    ) +"</td>"; // EWP 정산금액 
				dt_str12 += "<td>"+ ( (reRatePer == null) ? "" : reRatePer    ) +"</td>"; // 정산비율
				dt_str_totalVal = dt_str_totalVal+ reEssBdayInMonth;
				dt_str2_totalVal = dt_str2_totalVal+ reEssDischgOffPeak;
				dt_str3_totalVal = dt_str3_totalVal+ reEssDischgMidPeak;
				dt_str4_totalVal = dt_str4_totalVal+ reEssDischgMaxPeak;
				dt_str5_totalVal = dt_str5_totalVal+ reEssChgOffPeak;
				dt_str6_totalVal = dt_str6_totalVal+ reEssChgMidPeak;
				dt_str7_totalVal = dt_str7_totalVal+ reEssChgMaxPeak;
				dt_str8_totalVal = dt_str8_totalVal+ rePreEssIncen;
				dt_str9_totalVal = dt_str9_totalVal+ reEssIncen;
				dt_str10_totalVal = dt_str10_totalVal+ rePeakRate;
				dt_str11_totalVal = dt_str11_totalVal+ reEwpPeakRate;
				dt_str12_totalVal = dt_str12_totalVal+ reRatePer;
				if(dt_col_cnt == 12) {
					dt_str +=   "<td>"+ dt_str_totalVal  +"</td>"; // 평일일수
					dt_str2 +=  "<td>"+ dt_str2_totalVal  +"</td>"; // 경부하충전량
					dt_str3 +=  "<td>"+ dt_str3_totalVal  +"</td>"; // 중간부하충전량
					dt_str4 +=  "<td>"+ dt_str4_totalVal  +"</td>"; // 최대부하충전량
					dt_str5 +=  "<td>"+ dt_str5_totalVal  +"</td>"; // 경부하방전량
					dt_str6 +=  "<td>"+ dt_str6_totalVal  +"</td>"; // 중간부하방전량
					dt_str7 +=  "<td>"+ dt_str7_totalVal  +"</td>"; // 최대부하방전량
					dt_str8 +=  "<td>"+ dt_str8_totalVal  +"</td>"; // 예상 할인금액
					dt_str9 +=  "<td>"+ dt_str9_totalVal  +"</td>"; // 실적 할인금액
					dt_str10 += "<td>"+ dt_str10_totalVal +"</td>"; // 고객 정산금액
					dt_str11 += "<td>"+ dt_str11_totalVal +"</td>"; // EWP 정산금액 
					dt_str12 += "<td>"+ dt_str12_totalVal +"</td>"; // 정산비율
					essRevenue_head_pc[dt_row_cnt-1] = dt_str_head;
					essRevenue_data_pc[dt_row_cnt-1] = dt_str;
					essRevenue_data_pc2[dt_row_cnt-1] = dt_str2;
					essRevenue_data_pc3[dt_row_cnt-1] = dt_str3;
					essRevenue_data_pc4[dt_row_cnt-1] = dt_str4;
					essRevenue_data_pc5[dt_row_cnt-1] = dt_str5;
					essRevenue_data_pc6[dt_row_cnt-1] = dt_str6;
					essRevenue_data_pc7[dt_row_cnt-1] = dt_str7;
					essRevenue_data_pc8[dt_row_cnt-1] = dt_str8;
					essRevenue_data_pc9[dt_row_cnt-1] = dt_str9;
					essRevenue_data_pc10[dt_row_cnt-1] = dt_str10;
					essRevenue_data_pc11[dt_row_cnt-1] = dt_str11;
					essRevenue_data_pc12[dt_row_cnt-1] = dt_str12;
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
					dt_str11 = "";        
					dt_str12 = "";        
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
					dt_str11_totalVal = 0;
					dt_str12_totalVal = 0;
				} else {
					dt_col_cnt++;
				}
				
			}
			essRevenueList1 = dataSet;
			essRevenueList2 = dataSet2;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format(String(totDataSet), "essRevenueTot1", "won");
			unit_format(String(totDataSet2), "essRevenueTot2", "won");
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
			color: '#438fd7', /* 고객 정산금액 */
			data: essRevenueList1
		}, false);
		
		myChart.addSeries({
			name: '실적 할인금액',
			color: '#84848f', /* 실적 할인금액 */
			data: essRevenueList2
		}, false);
		
//		setTickInterval();
		myChart.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		
//		var thead_str = "<th>2018-08</th>";
//		for(var i=0; i<12; i++) {
//			thead_str += "<th>"+(i+1)+"월</th>";
//		}
//		thead_str +=  "<th>합계</th>";
		
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다..(내일해내일)
		$table = $("#pc_use_dataTable");
		$table.empty().append(
				$("<thead/>").append( $("<tr/>").append( "<th></th>"+essRevenue_head_pc[0]+"<th>합계</th>" ) ) // thead
		);
		if(essRevenue_data_pc.length < 1) {
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
							$("<tr/>").append( // 평일 일수 (d)
									'<th><div class="ctit wht"><span>평일 일수 (d)</span></div></th>'+ essRevenue_data_pc[0] 
							)
					).append(
							$("<tr/>").append( // 경부하충전량 (kWh)
									'<th><div class="ctit wht"><span>경부하충전량 (kWh)</span></div></th>'+ essRevenue_data_pc2[0] 
							)
					).append(
							$("<tr/>").append( // 중간부하충전량 (kWh)
									'<th><div class="ctit wht"><span>중간부하충전량 (kWh)</span></div></th>'+ essRevenue_data_pc3[0] 
							)
					).append(
							$("<tr/>").append( // 최대부하충전량 (kWh)
									'<th><div class="ctit wht"><span>최대부하충전량 (kWh)</span></div></th>'+ essRevenue_data_pc4[0] 
							)
					).append(
							$("<tr/>").append( // 경부하방전량 (kWh)
									'<th><div class="ctit wht"><span>경부하방전량 (kWh)</span></div></th>'+ essRevenue_data_pc5[0] 
							)
					).append(
							$("<tr/>").append( // 중간부하방전량 (kWh)
									'<th><div class="ctit wht"><span>중간부하방전량 (kWh)</span></div></th>'+ essRevenue_data_pc6[0] 
							)
					).append(
							$("<tr/>").append( // 최대부하방전량 (kWh)
									'<th><div class="ctit wht"><span>최대부하방전량 (kWh)</span></div></th>'+ essRevenue_data_pc7[0] 
							)
					).append(
							$("<tr/>").append( // 예상 할인금액 (won)
									'<th><div class="ctit wht"><span>예상 할인금액 (won)</span></div></th>'+ essRevenue_data_pc8[0] 
							)
					).append(
							$("<tr/>").append( // 실적 할인금액 (won)
									'<th><div class="ctit"><span>실적 할인금액 (won)</span></div></th>'+ essRevenue_data_pc9[0] 
							)
					).append(
							$("<tr/>").append( // 고객 정산금액 (won)
									'<th><div class="ctit ct1"><span>고객 정산금액 (won)</span></div></th>'+essRevenue_data_pc10[0]
							)
					).append(
							$("<tr/>").append( // EWP 정산금액 (won)
									'<th><div class="ctit wht"><span>EWP 정산금액 (won)</span></div></th>'+ essRevenue_data_pc11[0] 
							)
					).append(
							$("<tr/>").append( // 정산비율 (%)
									'<th><div class="ctit wht"><span>정산비율 (%)</span></div></th>'+ essRevenue_data_pc12[0] 
							)
					)
			);
		}
		
	}
