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
	
	var kepcoBill_head_pc = new Array(); //  표 데이터(헤더)
	var kepcoBill_data_pc = new Array(); //  표 데이터
	var kepcoBill_data_pc2 = new Array(); //  표 데이터
	var kepcoBill_data_pc3 = new Array(); //  표 데이터
	var kepcoBill_data_pc4 = new Array(); //  표 데이터
	var kepcoBill_data_pc5 = new Array(); //  표 데이터
	var kepcoBill_data_pc6 = new Array(); //  표 데이터
	var kepcoBill_data_pc7 = new Array(); //  표 데이터
	function getDBData(formData) {
		kepcoBill_head_pc.length =  0;
		kepcoBill_data_pc.length =  0;
		kepcoBill_data_pc2.length = 0;
		kepcoBill_data_pc3.length = 0;
		kepcoBill_data_pc4.length = 0;
		kepcoBill_data_pc5.length = 0;
		kepcoBill_data_pc6.length = 0;
		kepcoBill_data_pc7.length = 0;
//		var formData = $("#schForm").serializeObject();
		getKepcoBillList(formData); // 실제사용량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// 한전 요금 조회
	var kepcoBillList1;
	var kepcoBillList2;
	var kepcoBillList3;
	var kepcoBillList4;
	function callback_getKepcoBillList(result) {
		var kepcoBillList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var dataSet4 = []; // chartData를 위한 변수
		var totUsage = 0;
		var totUsage2 = 0;
		var totUsage3 = 0;
		var totUsage4 = 0;
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
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		var dt_str3_totalVal = 0; // 테이블 라인별 누적합
		var dt_str4_totalVal = 0; // 테이블 라인별 누적합
		var dt_str5_totalVal = 0; // 테이블 라인별 누적합
		var dt_str6_totalVal = 0; // 테이블 라인별 누적합
		var dt_str7_totalVal = 0; // 테이블 라인별 누적합
		
		if(kepcoBillList.length < 1) {
			
		} else {
			for(var i=0; i<kepcoBillList.length; i++) {
				var yyyyMM = kepcoBillList[i].bill_yearm;
				var baseRate = String(kepcoBillList[i].base_rate);
				var pwrFactorRate   = String(kepcoBillList[i].pwr_factor_rate);
				var consumeRate  = String(kepcoBillList[i].consume_rate);
				var totElecRate   = String(kepcoBillList[i].tot_elec_rate);
				var elecFund  = String(kepcoBillList[i].elec_fund);
				var valAddTax  = String(kepcoBillList[i].val_add_tax);
				var totAmtBill  = String(kepcoBillList[i].tot_amt_bill);
				var reBaseRate = 0; 
				var rePwrFactorRate = 0; 
				var reConsumeRate = 0; 
				var reTotElecRate = 0; 
				var reElecFund = 0; 
				var reValAddTax = 0; 
				var reTotAmtBill = 0; 
				
				if(baseRate == null || baseRate == "" || baseRate == "null") reBaseRate = null;
				else {
					reBaseRate = Math.round( Number(baseRate) );
					totUsage = totUsage+Number(kepcoBillList[i].base_rate);
				}
				if(pwrFactorRate == null || pwrFactorRate == "" || pwrFactorRate == "null") rePwrFactorRate = null;
				else rePwrFactorRate = Math.round( Number(pwrFactorRate) );
				if(consumeRate == null || consumeRate == "" || consumeRate == "null") reConsumeRate = null;
				else {
					reConsumeRate = Math.round( Number(consumeRate) );
					totUsage2 = totUsage2+Number(String(kepcoBillList[i].consume_rate));
				}
				if(totElecRate == null || totElecRate == "" || totElecRate == "null") reTotElecRate = null;
				else reTotElecRate = Math.round( Number(totElecRate) );
				if(elecFund == null || elecFund == "" || elecFund == "null") reElecFund = null;
				else {
					reElecFund = Math.round( Number(elecFund) );
					totUsage3 = totUsage3+Number(String(kepcoBillList[i].elec_fund));
				}
				if(valAddTax == null || valAddTax == "" || valAddTax == "null") reValAddTax = null;
				else {
					reValAddTax = Math.round( Number(valAddTax) );
					totUsage4 = totUsage4+Number(String(kepcoBillList[i].val_add_tax));
				}
				if(totAmtBill == null || totAmtBill == "" || totAmtBill == "null") reTotAmtBill = null;
				else reTotAmtBill = Math.round( Number(totAmtBill) );
				
				// 차트데이터 셋팅
				dataSet.push( [//kepcoBillList[i].bill_yearm,
					Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1),
					kepcoBillList[i].base_rate] );
				dataSet2.push( [//kepcoBillList[i].bill_yearm, 
					Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1),
					kepcoBillList[i].consume_rate] ); // 역률적용된 사용요금은 다시 확인해야함
				dataSet3.push( [//kepcoBillList[i].bill_yearm, 
					Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1),
					kepcoBillList[i].elec_fund] );
				dataSet4.push( [//kepcoBillList[i].bill_yearm, 
					Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1),
					kepcoBillList[i].val_add_tax] );

				// 표데이터 셋팅
				dt_str_head += "<th>"+yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"</th>"
				dt_str += "<td>"+  ( (reBaseRate == null) ? "" : reBaseRate    ) +"</td>"; // 기본요금(기본요금)
				dt_str2 += "<td>"+ ( (rePwrFactorRate == null) ? "" : rePwrFactorRate    ) +"</td>"; // 역률(역률요금)
				dt_str3 += "<td>"+ ( (reConsumeRate == null) ? "" : reConsumeRate    ) +"</td>"; // 사용요금(전력량요금)
				dt_str4 += "<td>"+ ( (reTotElecRate == null) ? "" : reTotElecRate    ) +"</td>"; // 전기요금합계(전기요금계)
				dt_str5 += "<td>"+ ( (reElecFund == null) ? "" : reElecFund    ) +"</td>"; // 전력기금(전력산업기반기금)
				dt_str6 += "<td>"+ ( (reValAddTax == null) ? "" : reValAddTax    ) +"</td>"; // 부가세(부가가치세)
				dt_str7 += "<td>"+ ( (reTotAmtBill == null) ? "" : reTotAmtBill    ) +"</td>"; // 청구금액(당월요금계)
				dt_str_totalVal = dt_str_totalVal+ reBaseRate;
				dt_str2_totalVal = dt_str2_totalVal+ rePwrFactorRate;
				dt_str3_totalVal = dt_str3_totalVal+ reConsumeRate;
				dt_str4_totalVal = dt_str4_totalVal+ reTotElecRate;
				dt_str5_totalVal = dt_str5_totalVal+ reElecFund;
				dt_str6_totalVal = dt_str6_totalVal+ reValAddTax;
				dt_str7_totalVal = dt_str7_totalVal+ reTotAmtBill;
				if(dt_col_cnt == 12) {
					dt_str += "<td>"+  dt_str_totalVal  +"</td>"; // 기본요금(기본요금)
					dt_str2 += "<td>"+ dt_str2_totalVal +"</td>"; // 역률(역률요금)
					dt_str3 += "<td>"+ dt_str3_totalVal +"</td>"; // 사용요금(전력량요금)
					dt_str4 += "<td>"+ dt_str4_totalVal +"</td>"; // 전기요금합계(전기요금계)
					dt_str5 += "<td>"+ dt_str5_totalVal +"</td>"; // 전력기금(전력산업기반기금)
					dt_str6 += "<td>"+ dt_str6_totalVal +"</td>"; // 부가세(부가가치세)
					dt_str7 += "<td>"+ dt_str7_totalVal +"</td>"; // 청구금액(당월요금계)
					kepcoBill_head_pc[dt_row_cnt-1] = dt_str_head;
					kepcoBill_data_pc[dt_row_cnt-1] = dt_str;
					kepcoBill_data_pc2[dt_row_cnt-1] = dt_str2;
					kepcoBill_data_pc3[dt_row_cnt-1] = dt_str3;
					kepcoBill_data_pc4[dt_row_cnt-1] = dt_str4;
					kepcoBill_data_pc5[dt_row_cnt-1] = dt_str5;
					kepcoBill_data_pc6[dt_row_cnt-1] = dt_str6;
					kepcoBill_data_pc7[dt_row_cnt-1] = dt_str7;
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_head = "";
					dt_str  = ""; 
					dt_str2 = ""; 
					dt_str3 = ""; 
					dt_str4 = ""; 
					dt_str5 = ""; 
					dt_str6 = ""; 
					dt_str7 = ""; 
					dt_str_totalVal =  0;
					dt_str2_totalVal = 0;
					dt_str3_totalVal = 0;
					dt_str4_totalVal = 0;
					dt_str5_totalVal = 0;
					dt_str6_totalVal = 0;
					dt_str7_totalVal = 0;
				} else {
					if( (i+1) == kepcoBillList.length ) { // 조회한 목록이 라인을 다 못채울 때
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
						}
						dt_str += "<td>"+  dt_str_totalVal  +"</td>"; // 기본요금(기본요금)
						dt_str2 += "<td>"+ dt_str2_totalVal +"</td>"; // 역률(역률요금)
						dt_str3 += "<td>"+ dt_str3_totalVal +"</td>"; // 사용요금(전력량요금)
						dt_str4 += "<td>"+ dt_str4_totalVal +"</td>"; // 전기요금합계(전기요금계)
						dt_str5 += "<td>"+ dt_str5_totalVal +"</td>"; // 전력기금(전력산업기반기금)
						dt_str6 += "<td>"+ dt_str6_totalVal +"</td>"; // 부가세(부가가치세)
						dt_str7 += "<td>"+ dt_str7_totalVal +"</td>"; // 청구금액(당월요금계)
						kepcoBill_head_pc[dt_row_cnt-1] = dt_str_head;
						kepcoBill_data_pc[dt_row_cnt-1] = dt_str;
						kepcoBill_data_pc2[dt_row_cnt-1] = dt_str2;
						kepcoBill_data_pc3[dt_row_cnt-1] = dt_str3;
						kepcoBill_data_pc4[dt_row_cnt-1] = dt_str4;
						kepcoBill_data_pc5[dt_row_cnt-1] = dt_str5;
						kepcoBill_data_pc6[dt_row_cnt-1] = dt_str6;
						kepcoBill_data_pc7[dt_row_cnt-1] = dt_str7;
						dt_row_cnt++;
						dt_col_cnt = 1;
						dt_str_head = "";
						dt_str  = ""; 
						dt_str2 = ""; 
						dt_str3 = ""; 
						dt_str4 = ""; 
						dt_str5 = ""; 
						dt_str6 = ""; 
						dt_str7 = ""; 
						dt_str_totalVal =  0;
						dt_str2_totalVal = 0;
						dt_str3_totalVal = 0;
						dt_str4_totalVal = 0;
						dt_str5_totalVal = 0;
						dt_str6_totalVal = 0;
						dt_str7_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
//					dt_col_cnt++;
				}
				
			}
			kepcoBillList1 = dataSet;
			kepcoBillList2 = dataSet2;
			kepcoBillList3 = dataSet3;
			kepcoBillList4 = dataSet4;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format(String(totUsage), "kepcoBillTot1", "won");
			unit_format(String(totUsage2), "kepcoBillTot2", "won");
			unit_format(String(totUsage3), "kepcoBillTot3", "won");
			unit_format(String(totUsage4), "kepcoBillTot4", "won");
		}
		
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '기본요금',
			color: '#438fd7', /* 기본요금 */
			data: kepcoBillList1
		}, false);
		
		myChart.addSeries({
			name: '사용요금(역률 적용)',
			color: '#13af67', /* 사용요금(역률 적용) */
			data: kepcoBillList2
		}, false);
		
		myChart.addSeries({
			name: '전력산업기반기금',
			color: '#f75c4a', /* 전력산업기반기금 */
			data: kepcoBillList3
		}, false);
		
		myChart.addSeries({
			name: '부가세',
			color: '#84848f', /* 부가세 */
			data: kepcoBillList4
		}, false);
		
//		setTickInterval();
		myChart.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다..(내일해내일)
		$table = $("#pc_use_dataTable");
		$table.empty().append(
				$("<thead/>").append( $("<tr/>").append( "<th></th>"+kepcoBill_head_pc[0]+"<th>합계</th>" ) ) // thead
		);
		if(kepcoBill_data_pc.length < 1) {
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
							$("<tr/>").append( // 기본요금
									'<th><div class="ctit ctt1"><span>기본요금</span></div></th>'+kepcoBill_data_pc[0]
							)
					).append(
							$("<tr/>").append( // 역률
									'<th><div class="ctit wht"><span>역률</span></div></th>'+ kepcoBill_data_pc2[0] 
							)
					).append(
							$("<tr/>").append( // 사용요금
									'<th><div class="ctit ctt2"><span>사용요금</span></div></th>'+ kepcoBill_data_pc3[0] 
							)
					).append(
							$("<tr/>").append( // 전기요금합계
									'<th><div class="ctit wht"><span>전기요금합계</span></div></th>'+ kepcoBill_data_pc4[0] 
							)
					).append(
							$("<tr/>").append( // 전력산업기반기금
									'<th><div class="ctit ctt3"><span>전력산업기반기금</span></div></th>'+ kepcoBill_data_pc5[0] 
							)
					).append(
							$("<tr/>").append( // 부가세
									'<th><div class="ctit ctt4"><span>부가세</span></div></th>'+ kepcoBill_data_pc6[0] 
							)
					).append(
							$("<tr/>").append( // 청구요금
									'<th><div class="ctit wht"><span>청구요금</span></div></th>'+ kepcoBill_data_pc7[0] 
							)
					)
			);
		}
		
	}
