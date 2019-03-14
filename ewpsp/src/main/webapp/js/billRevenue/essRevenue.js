	$(document).ready(function() {
		var firstDay = new Date();
		var endDay = new Date();
		var texDay = new Date()
		texDay.setYear(texDay.getFullYear());
		texDay = new Date(texDay.setMonth(texDay.getMonth()+1));
		firstDay.setYear(firstDay.getFullYear()-1);
		firstDay = new Date(firstDay.setMonth(firstDay.getMonth()+1));
		$("#selTermFrom").val( firstDay.format("yyyyMM") );
		$("#selTermTo").val( endDay.format("yyyyMM") );
		$("#datepicker3").val( firstDay.format("yyyy-MM") );
		$("#datepicker4").val( endDay.format("yyyy-MM") );
		$("#selTermTex").val(texDay.format('yyyyMM'));
		SelTerm = "billSelectMM";
		$("#selTerm").val(SelTerm);
		var formData = $("#schForm").serializeObject();
		
		
		getSiteSetDetail(formData);
		getESSRevenueTexList(formData); // 명세서 조회
		getDBData(formData);
	});
	
	$( function () {
		$("#ESSRevenueTex").click(function(){
//			if(texList.length > 0){
			if(totalEssRevenueAmt > 0){
				
				popupOpen('dprint')
			}else{
				alert("조회할 명세서 내역이 없습니다.");
			}
		});
	
	});
	

	function searchData() {
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
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
		essRevenue_head_pc.length = 0;
		essRevenue_data_pc.length = 0;
		essRevenue_data_pc2.length = 0; 
		essRevenue_data_pc3.length = 0; 
		essRevenue_data_pc4.length = 0; 
		essRevenue_data_pc5.length = 0; 
		essRevenue_data_pc6.length = 0; 
		essRevenue_data_pc7.length = 0; 
		essRevenue_data_pc8.length = 0; 
		essRevenue_data_pc9.length = 0; 
		essRevenue_data_pc10.length = 0;
		essRevenue_data_pc11.length = 0;
		essRevenue_data_pc12.length = 0;
		essRevenueList1 = null;
		essRevenueList2 = null;
		getESSRevenueList(formData); // 실제사용량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// ESS 수익 조회
	var essRevenueList1;
	var essRevenueList2;
	function callback_getESSRevenueList(result) {
		var sheetList = result.sheetList;
		var chartList = result.chartList;
		var start = $("#selTermFrom").val();
		var end = $("#selTermTo").val();
		var sheetStartDt = start.substring(0, 4)+"01";
		var sheetEndDt = end.substring(0, 4)+"12";
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var totDataSet = 0;
		var totDataSet2 = 0;
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		dt_row = (Number(end.substring(0, 4))-Number(start.substring(0, 4)) )+1;
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
		
		// 표데이터 셋팅
		if(sheetList != null && sheetList.length > 0) {
			for(var i=0; i<sheetList.length; i++) {
				var yyyyMM = sheetList[i].bill_yearm;
				var essBdayInMonth  = String(sheetList[i].bdayIn_month)   ;
				var essDischgOffPeak  = String(sheetList[i].ess_dischg_off_peak);
				var essDischgMidPeak  = String(sheetList[i].ess_dischg_mid_peak);
				var essDischgMaxPeak  = String(sheetList[i].ess_dischg_max_peak);
				var essChgOffPeak  = String(sheetList[i].ess_chg_off_peak)   ;
				var essChgMidPeak  = String(sheetList[i].ess_chg_mid_peak)   ;
				var essChgMaxPeak  = String(sheetList[i].ess_chg_max_peak)   ;
				var preEssIncen  = String(sheetList[i].pre_ess_incen)      ;
				var essIncen  = String(sheetList[i].ess_incen)          ;
				var peakRate  = String(sheetList[i].peak_rate)          ;
				var ewpPeakRate  = String(sheetList[i].ewp_peak_rate)      ;
				var ratePer  = String(sheetList[i].rate_per)           ;
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
//					totDataSet2 = totDataSet2+Number(String(sheetList[i].ess_incen));
				}
				if(peakRate == null || peakRate == "" || peakRate == "null") rePeakRate = null;
				else {
					rePeakRate = Math.round( Number(peakRate) );
//					totDataSet = totDataSet+Number(sheetList[i].peak_rate);
				}
				if(ewpPeakRate == null || ewpPeakRate == "" || ewpPeakRate == "null") reEwpPeakRate = null;
				else reEwpPeakRate = Math.round( Number(ewpPeakRate) );
				if(ratePer == null || ratePer == "" || ratePer == "null") reRatePer = null;
				else reRatePer = Math.round( Number(ratePer) );

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
					dt_str_head = "";
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
					if( (i+1) == sheetList.length ) { // 조회한 목록이 라인을 다 못채울 때
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
							dt_str11 += "<td></td>";
							dt_str12 += "<td></td>";
						}
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
						dt_str_head = "";
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
				
			}
			
		}
		
		
		if(chartList != null && chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var yyyyMM = chartList[i].bill_yearm;
				var essBdayInMonth  = String(chartList[i].bdayIn_month)   ;
				var essDischgOffPeak  = String(chartList[i].ess_dischg_off_peak);
				var essDischgMidPeak  = String(chartList[i].ess_dischg_mid_peak);
				var essDischgMaxPeak  = String(chartList[i].ess_dischg_max_peak);
				var essChgOffPeak  = String(chartList[i].ess_chg_off_peak)   ;
				var essChgMidPeak  = String(chartList[i].ess_chg_mid_peak)   ;
				var essChgMaxPeak  = String(chartList[i].ess_chg_max_peak)   ;
				var preEssIncen  = String(chartList[i].pre_ess_incen)      ;
				var essIncen  = String(chartList[i].ess_incen)          ;
				var peakRate  = String(chartList[i].peak_rate)          ;
				var ewpPeakRate  = String(chartList[i].ewp_peak_rate)      ;
				var ratePer  = String(chartList[i].rate_per)           ;
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
					totDataSet2 = totDataSet2+Number(String(chartList[i].ess_incen));
				}
				if(peakRate == null || peakRate == "" || peakRate == "null") rePeakRate = null;
				else {
					rePeakRate = Math.round( Number(peakRate) );
					totDataSet = totDataSet+Number(chartList[i].peak_rate);
				}
				if(ewpPeakRate == null || ewpPeakRate == "" || ewpPeakRate == "null") reEwpPeakRate = null;
				else reEwpPeakRate = Math.round( Number(ewpPeakRate) );
				if(ratePer == null || ratePer == "" || ratePer == "null") reRatePer = null;
				else reRatePer = Math.round( Number(ratePer) );
				
				// 차트데이터 셋팅
				dataSet.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].peak_rate ] );
				dataSet2.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].ess_incen ] );
				
			}
			essRevenueList1 = dataSet;
			essRevenueList2 = dataSet2;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format_bill(String(totDataSet), "essRevenueTot1", "won", "ess");
			unit_format_bill(String(totDataSet2), "essRevenueTot2", "won", "ess");
		}
		
	}
	
	var texDataSet1 = [];
	var texDataSet2 = [];
	var texDataSet3 = [];
	var essRevenueTexList1;
	var essRevenueTexList2;
	var essRevenueTexList3;
	var totalEssRevenueAmt = 0;
	
	var texList = "";
	function callback_getESSRevenueTexList(result){
		texList = result.texList;
		var energyChgBasicBill = "";
		var thisDay = new Date();
		thisDay = new Date(thisDay.setMonth(thisDay.getMonth()-1));
		thisMonth = parseInt(thisDay.format("MM"));
				
		if(thisMonth >=6 && thisMonth <=8){
			energyChgBasicBill = summerVal;
		}else if(thisMonth >=11 && thisMonth<=2){
			energyChgBasicBill = winterVal;
		}else{
			energyChgBasicBill = springFallVal;
		}
		
		if(texList.length > 0){
		var yyyyMM = texList[0].bill_yearm;
		var essBdayInMonth  = String(texList[0].ess_bdayIn_month)   ;
		var essDischgOffPeak  = String(texList[0].ess_dischg_off_peak);
		var essDischgMidPeak  = String(texList[0].ess_dischg_mid_peak);
		var essDischgMaxPeak  = String(texList[0].ess_dischg_max_peak);
		var essChgOffPeak  = String(texList[0].ess_chg_off_peak)   ;
		var essChgMidPeak  = String(texList[0].ess_chg_mid_peak)   ;
		var essChgMaxPeak  = String(texList[0].ess_chg_max_peak)   ;
		var preEssIncen  = String(texList[0].pre_ess_incen)      ;
		var essIncen  = String(texList[0].ess_incen)          ;
		var peakRate  = String(texList[0].peak_rate)          ;
		var ewpPeakRate  = String(texList[0].ewp_peak_rate)      ;
		var ratePer  = String(texList[0].rate_per)           ;
		var valAddTex = texList[0].val_add_tax				;
		var usg = texList[0].val_add_tax	;
		var demandChgReduct = Math.round(texList[0].demand_chg_reduct);	//기본요금절감금액
		var beneDivdemandChgReduct = Math.round((demandChgReduct*essProfitRatio)/100);	//기본요금절감금액
		var energyChgReduct = Math.round(texList[0].energy_chg_reduct);	//전력량 요금 절감(계시별)
		var beneDivenergyChgReduct = Math.round((energyChgReduct*essProfitRatio)/100);		//전력량 요금 절감(계시별) 수익배분
		var essChgIncen = Math.round(texList[0].ess_chg_incen);	//ESS 충전 요금 할인
		var beneDivessChgIncen = Math.round((essChgIncen*essProfitRatio)/100);		//ESS 충전 요금 할인 수익배분
		var essDischgIncen = Math.round(texList[0].ess_dischg_incen);	//ESS 방전 요금 할인
		var beneDivessDischgIncen = Math.round((essDischgIncen*essProfitRatio)/100);		//ESS 방전 요금 할인 수익배분
		var total = Math.round(energyChgReduct+essChgIncen+essDischgIncen);	//총계
		var beneDivTotal = Math.round((total*essProfitRatio)/100);	//수익배분 총계
		var addDivTotal = Math.round(beneDivTotal*1.1);
		var reEssBdayInMonth  = 0;
		var reEssDischgOffPeak  = 0;
		var reEssDischgMidPeak  = 0;
		var reEssDischgMaxPeak  = 0;
		var dischgOffCalc = 0
		var dischgMidCalc = 0
		var dischgMaxCalc = 0
		var reEssDischgOffPeakVal  = 0;
		var reEssDischgMidPeakVal  = 0;
		var reEssDischgMaxPeakVal  = 0;
		var chgOffCalc = 0;
		var chgMidCalc = 0;
		var chgMaxCalc = 0;
		var totDischgPeak = 0;
		var totDischgPeakVal = 0;
		var reEssChgOffPeak  = 0;
		var reEssChgMidPeak  = 0;
		var reEssChgMaxPeak  = 0;
		var reEssChgOffPeakVal  = 0;
		var reEssChgMidPeakVal  = 0;
		var reEssChgMaxPeakVal  = 0;
		var totChgPeak = 0;
		var totChgPeakVal1 =0;
		var totChgPeakVal2 =0;
		var rePreEssIncen  = 0;
		var reEssIncen  = 0;
		var rePeakRate  = 0;
		var reEwpPeakRate  = 0;
		var reRatePer  = 0;
		var elecNum = 0.5;
		
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
			//totDataSet2 = totDataSet2+Number(String(sheetList[i].ess_incen));
		}
		if(peakRate == null || peakRate == "" || peakRate == "null") rePeakRate = null;
		else {
			rePeakRate = Math.round( Number(peakRate) );
			//totDataSet = totDataSet+Number(sheetList[i].peak_rate);
		}
		if(ewpPeakRate == null || ewpPeakRate == "" || ewpPeakRate == "null") reEwpPeakRate = null;
		else reEwpPeakRate = Math.round( Number(ewpPeakRate) );
		if(essProfitRatio == null || essProfitRatio == "" || essProfitRatio == "null") reRatePer = null;
		else reRatePer = Math.round( Number(essProfitRatio) );
		
		/*var reEssDischgOffPeak  = 0;
		var reEssDischgMidPeak  = 0;
		var reEssDischgMaxPeak  = 0;
		var totDischgPeak = 0;
		var reEssChgOffPeak  = 0;
		var reEssChgMidPeak  = 0;
		var reEssChgMaxPeak  = 0;*/
		
		
		
		
		totDischgPeak = reEssDischgOffPeak+reEssDischgMidPeak+reEssDischgMaxPeak;
		totChgPeak =reEssChgOffPeak+ reEssChgMidPeak+reEssChgMaxPeak
		
		chgOffCalc = reEssChgOffPeak*elecNum*energyChgBasicBill*1;
		chgMidCalc = reEssChgMidPeak*elecNum*energyChgBasicBill*1;
		chgMaxCalc = reEssChgMaxPeak*elecNum*energyChgBasicBill*1;
		
		dischgOffCalc = reEssDischgOffPeak*elecNum*energyChgBasicBill*1;
		dischgMidCalc = reEssDischgMidPeak*elecNum*energyChgBasicBill*1;
		dischgMaxCalc = reEssDischgMaxPeak*elecNum*energyChgBasicBill*1;
		
		if(yyyyMM.substring(0,4) <2021){
			totChgPeakVal1 =(reEssChgMaxPeak-dischgMaxCalc)/(essBdayInMonth*3)*3*1*basicVal;
		} else {
			totChgPeakVal1 =(reEssChgMaxPeak-dischgMaxCalc)/(essBdayInMonth*3)*1*basicVal;
		}
		
		
		totChgPeakVal2 =usg*basicVal;
		
		
		
		totDischgPeakVal = dischgOffCalc+dischgMidCalc+dischgMaxCalc;
		totChgPeakVal = chgOffCalc+chgMidCalc+chgMaxCalc;
		var delLastWon = Math.floor(addDivTotal/10)*10-addDivTotal; // 원단위 절사
		
		var ESSBodyStr = "";
		var ESSFootStr = "";
		var ESSSaveAreaStr = "";
		var ESSSaveFootAreaStr = "";
		var ESSCalcAreaStr = "";
		var ESSTypeStr = "";
		var ESSInfoStr = "";
		
		/*$(".texArea").find("tbody").empty();
		$(".texArea").find("tfoot").empty();
		$(".texSaveArea").find("tbody").empty();
		$(".texSaveArea").find("tfoot").empty();
		$(".calcArea").find("tbody").empty();*/
		$("#texBill").text("에너지절감 솔루션 제공 전기요금 절감 수익 배분 청구서 (’"+yyyyMM.substring(2,4)+"년"+yyyyMM.substring(4,6)+"월)");
		$("#texDay").text("청구일 : "+yyyyMM.substring(0,4)+"-"+yyyyMM.substring(4,6)+"-"+meterClaimDay);
		$(".dp_total").text(numberComma(addDivTotal+delLastWon));
		totalEssRevenueAmt = addDivTotal+delLastWon;
		
		
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th>①기본 요금 절감(피크저감)</th>";
		ESSBodyStr += "<td align='right'>"+demandChgReduct+"</td>";
		ESSBodyStr += "<td align='right'>"+beneDivdemandChgReduct+"</td>";
		ESSBodyStr += "</tr>";
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th>②전력량 요금 절감(계시별)</th>";
		ESSBodyStr += "<td align='right'>"+numberComma(energyChgReduct)+"원</td>";
		ESSBodyStr += "<td align='right'>"+numberComma(beneDivenergyChgReduct)+"원</td>";
		ESSBodyStr += "</tr>";
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th>③ESS 충전 요금 할인</th>";
		ESSBodyStr += "<td align='right'>"+numberComma(essChgIncen)+"원</td>";
		ESSBodyStr += "<td align='right'>"+numberComma(beneDivessChgIncen)+"원</td>";
		ESSBodyStr += "</tr>";
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th>④ESS 전용 요금 할인</th>";
		ESSBodyStr += "<td align='right'>"+numberComma(essDischgIncen)+"원</td>";
		ESSBodyStr += "<td align='right'>"+numberComma(beneDivessDischgIncen)+"원</td>";
		ESSBodyStr += "</tr>";
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th>총   계</th>";
		ESSBodyStr += "<td align='right'>"+numberComma(total)+"원</td>";
		ESSBodyStr += "<td align='right'>"+numberComma(beneDivTotal)+"원</td>";
		ESSBodyStr += "</tr>";
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th colspan='2'>수익배분 계</th>";
		ESSBodyStr += "<td align='right'>"+numberComma(beneDivTotal)+"원</td>";
		ESSBodyStr += "</tr>";
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th colspan='2'>부가가치세</th>";
		ESSBodyStr += "<td align='right'>"+numberComma(Math.round(beneDivTotal/10))+"원</td>";
		ESSBodyStr += "</tr>";
		ESSBodyStr += "<tr>";
		ESSBodyStr += "<th colspan='2'>원단위절사</th>";
		ESSBodyStr += "<td align='right'>"+delLastWon+"</td>";
		ESSBodyStr += "</tr>";
		
		ESSFootStr += "<tr>";
		ESSFootStr += "<th colspan='2'>청구금액</th>";
		ESSFootStr += "<td align='right'>"+numberComma(addDivTotal+delLastWon)+"</td>";
		ESSFootStr += "</tr>";
			
		
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th rowspan='4'>충전</th>";
		ESSSaveAreaStr += "<th>경부하</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+ ( (reEssDischgOffPeak == null) ? "" : numberComma(reEssDischgOffPeak)    ) +"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(dischgOffCalc))+"</td>";
		ESSSaveAreaStr += "</tr>";
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th>중간부하</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+ ( (reEssDischgMidPeak == null) ? "" : numberComma(reEssDischgMidPeak)    ) +"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(dischgMidCalc))+"</td>";
		ESSSaveAreaStr += "</tr>";
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th>최대부하</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+ ( (reEssDischgMaxPeak == null) ? "" : numberComma(reEssDischgMaxPeak)    ) +"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(dischgMaxCalc))+"</td>";
		ESSSaveAreaStr += "</tr>";
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th>계</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(totDischgPeak))+"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(totDischgPeakVal))+"</td>";
		ESSSaveAreaStr += "</tr>";
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th rowspan='4'>방전</th>";
		ESSSaveAreaStr += "<th>경부하</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+ ( (reEssChgOffPeak == null) ? "" : numberComma(reEssChgOffPeak)    ) +"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(chgOffCalc))+"</td>";
		ESSSaveAreaStr += "</tr>";
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th>중간부하</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+ ( (reEssChgMidPeak == null) ? "" : numberComma(reEssChgMidPeak)    ) +"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(chgMidCalc))+"</td>";
		ESSSaveAreaStr += "</tr>";
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th>최대부하</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+ ( (reEssChgMaxPeak == null) ? "" : numberComma(reEssChgMaxPeak)    ) +"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(chgMaxCalc))+"</td>";
		ESSSaveAreaStr += "</tr>";
		ESSSaveAreaStr += "<tr>";
		ESSSaveAreaStr += "<th>계</th>";
		ESSSaveAreaStr += "<td aligh ='right'>"+totChgPeak+"</td>";
		ESSSaveAreaStr += "<td aligh ='right'>"+numberComma(Math.round(totChgPeakVal))+"</td>";
		ESSSaveAreaStr += "</tr>";
		

		
		
		
		ESSSaveFootAreaStr += "<tr>";
		ESSSaveFootAreaStr += "<th  colspan='3' style='font-size:12px;'>②충방전 전력량요금 절감금액)(방전 – 충전금액)</th>";
		ESSSaveFootAreaStr += "<td>"+numberComma(Math.round((totChgPeak-totDischgPeakVal)))+"</td>";
		ESSSaveFootAreaStr += "</tr>";
		
		ESSCalcAreaStr += "<tr>";
		ESSCalcAreaStr += "<th>①기본 요금 절감(피크저감)</th>";
		ESSCalcAreaStr += "<td aligh ='right'>0</td>";
		ESSCalcAreaStr += "<td>ESS 피크저감 효과가 전기요금에 반영되는 시점부터 적용</td>";
		ESSCalcAreaStr += "</tr>";
		ESSCalcAreaStr += "<tr>";
		ESSCalcAreaStr += "<th>③ESS 충전 요금 할인</th>";
		ESSCalcAreaStr += "<td aligh ='right'>"+numberComma(beneDivessChgIncen)+"</td>";
		ESSCalcAreaStr += "<td>("+numberComma(reEssDischgOffPeak)+" kW x 0.5 x"+energyChgBasicBill+"원x 1)</td>";
		ESSCalcAreaStr += "</tr>";
		ESSCalcAreaStr += "<tr>";
		ESSCalcAreaStr += "<th>④ESS 전용 요금 할인</th>";
		ESSCalcAreaStr += "<td aligh ='right'>"+( (totChgPeakVal1 < totChgPeakVal2) ? numberComma(Math.round(totChgPeakVal1)) : numberComma(Math.round(totChgPeakVal2))  ) +"</td>";
		ESSCalcAreaStr += "<td>Min[("+numberComma(usg)+" kW x "+numberComma(basicVal)+" 원), ((("+numberComma(reEssChgMaxPeak)+" kW – "+numberComma(dischgMaxCalc)+" kW) / ("+essBdayInMonth+" 일 x 3)) "+( (yyyyMM.substring(0,4) <2021) ? "x 3" : ""    )+" x 1 x "+numberComma(basicVal)+" 원)]</td>";
		ESSCalcAreaStr += "</tr>";
		ESSTypeStr += "<tr>";
		ESSTypeStr += "<th>전기사용 계약종별</th>";
		ESSTypeStr += "<td>"+planTypeName+"</td>";
		ESSTypeStr += "</tr>";
		ESSTypeStr += "<tr>";
		ESSTypeStr += "<th>기본요금</th>";
		ESSTypeStr += "<td>"+numberComma(basicVal)+"원</td>";
		ESSTypeStr += "</tr>";
		
		ESSInfoStr += "<tr>";
		ESSInfoStr += "<th>은행명</th>";
		ESSInfoStr += "<td>우리은행</td>";
		ESSInfoStr += "</tr>";
		ESSInfoStr += "<tr>";
		ESSInfoStr += "<th>계좌번호</th>";
		ESSInfoStr += "<td>1005 – 802 - 498030</td>";
		ESSInfoStr += "</tr>";
		ESSInfoStr += "<tr>";
		ESSInfoStr += "<th>예금주</th>";
		ESSInfoStr += "<td>한국동서발전㈜</td>";
		ESSInfoStr += "</tr>";
		ESSInfoStr += "<tr>";
		ESSInfoStr += "<th>납입금액</th>";
		ESSInfoStr += "<td>"+numberComma(addDivTotal+delLastWon)+"</td>";
		ESSInfoStr += "</tr>";
		ESSInfoStr += "<tr>";
		ESSInfoStr += "<th>납기일</th>";
		var essRvClaimDay = yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"-"+meterClaimDay+" 00:00:00";
		var essRvClaimDate = new Date(essRvClaimDay);
		var paymentDate = new Date(essRvClaimDate.setDate(essRvClaimDate.getDate() + 10));
		ESSInfoStr +="<td>"+paymentDate.format("yyyy-MM-dd")+"</td>";
		ESSInfoStr += "</tr>";
		
		
		
		$(".texArea").find("tbody").html(ESSBodyStr);
		$(".texArea").find("tfoot").html(ESSFootStr);
		$(".texSaveArea").find("tbody").html(ESSSaveAreaStr);
		$(".texSaveArea").find("tfoot").html(ESSSaveFootAreaStr);
		$(".calcArea").find("tbody").html(ESSCalcAreaStr);
		$(".typeArea").find("tbody").html(ESSTypeStr);
		$(".infoArea").find("tbody").html(ESSInfoStr);
		
		
		texDataSet1.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), reEssChgMaxPeak] );
		texDataSet2.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), reEssDischgMidPeak] );
		texDataSet3.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), reEssChgOffPeak] );
		
		

		essRevenueTexList1 = texDataSet1;
		essRevenueTexList2 = texDataSet2;
		essRevenueTexList3 = texDataSet3;

		
		texdRawData_chart();
		}
		
	}
	
	// 명세서 차트 그리기
	function texdRawData_chart() {
		var seriesLength = myChart1.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart1.series[i].remove();
		}
		
		myChart1.addSeries({
			name: '②충방전 전력량요금 절감금액',
			color: '#438fd7', /* 고객 정산금액 */
			data: essRevenueTexList1
		}, false);
		
		myChart1.addSeries({
			name: '③ESS 충전 요금 할인',
			color: '#84848f', /* 실적 할인금액 */
			data: essRevenueTexList2
		}, false);
		
		myChart1.addSeries({
			name: '④ESS 방전 요금 할인',
			color: '#3d4250', /* 실적 할인금액 */
			data: essRevenueTexList3
		}, false);
//		setTickInterval();
		myChart1.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart1.redraw(); // 차트 데이터를 다시 그린다
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
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다
		$div = $("#pc_use_dataDiv");
		$div.empty(); // 초기화
		if(essRevenue_data_pc.length < 1) {
			$(".income_ess_chart").find(".inchart-nodata").css("display", "");
			$(".income_ess_chart").find(".inchart").css("display", "none");
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
			$(".income_ess_chart").find(".inchart-nodata").css("display", "none");
			$(".income_ess_chart").find(".inchart").css("display", "");
			for(var i=dt_row-1; i>-1; i--) {
				$div.prepend(
						$('<div class="chart_table" />').append(
								$('<table class="pc_use" />').append(
										$("<thead/>").append( $("<tr/>").append( "<th></th>"+essRevenue_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append( // 평일 일수 (d)
														'<th><div class="ctit wht"><span>평일 일수 (d)</span></div></th>'+ essRevenue_data_pc[i] 
												)
										).append(
												$("<tr/>").append( // 경부하충전량 (kWh)
														'<th><div class="ctit wht"><span>경부하충전량 (kWh)</span></div></th>'+ essRevenue_data_pc2[i] 
												)
										).append(
												$("<tr/>").append( // 중간부하충전량 (kWh)
														'<th><div class="ctit wht"><span>중간부하충전량 (kWh)</span></div></th>'+ essRevenue_data_pc3[i] 
												)
										).append(
												$("<tr/>").append( // 최대부하충전량 (kWh)
														'<th><div class="ctit wht"><span>최대부하충전량 (kWh)</span></div></th>'+ essRevenue_data_pc4[i] 
												)
										).append(
												$("<tr/>").append( // 경부하방전량 (kWh)
														'<th><div class="ctit wht"><span>경부하방전량 (kWh)</span></div></th>'+ essRevenue_data_pc5[i] 
												)
										).append(
												$("<tr/>").append( // 중간부하방전량 (kWh)
														'<th><div class="ctit wht"><span>중간부하방전량 (kWh)</span></div></th>'+ essRevenue_data_pc6[i] 
												)
										).append(
												$("<tr/>").append( // 최대부하방전량 (kWh)
														'<th><div class="ctit wht"><span>최대부하방전량 (kWh)</span></div></th>'+ essRevenue_data_pc7[i] 
												)
//										).append(
//												$("<tr/>").append( // 예상 할인금액 (won)
//														'<th><div class="ctit wht"><span>예상 할인금액 (won)</span></div></th>'+ essRevenue_data_pc8[i] 
//												)
										).append(
												$("<tr/>").append( // 실적 할인금액 (won)
														'<th><div class="ctit"><span>실적 할인금액 (won)</span></div></th>'+ essRevenue_data_pc9[i] 
												)
										).append(
												$("<tr/>").append( // 고객 정산금액 (won)
														'<th><div class="ctit ct1"><span>고객 정산금액 (won)</span></div></th>'+essRevenue_data_pc10[i]
												)
										).append(
												$("<tr/>").append( // EWP 정산금액 (won)
														'<th><div class="ctit wht"><span>EWP 정산금액 (won)</span></div></th>'+ essRevenue_data_pc11[i] 
												)
										).append(
												$("<tr/>").append( // 정산비율 (%)
														'<th><div class="ctit wht"><span>정산비율 (%)</span></div></th>'+ essRevenue_data_pc12[i] 
												)
										)
								) 
						)
				);
				
			}
		}
		
	}