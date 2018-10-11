	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
	var peak_head_pc = new Array(); // 실제 사용량 표 데이터
	var peak_data_pc = new Array(); // 피크 전력 표 데이터
	var ctpPw_data_pc = new Array(); //  한전계약전력 표 데이터
	var cgtPw_data_pc = new Array(); //  요금적용전력 표 데이터
	function getDBData(formData) {
		peak_head_pc.length = 0; 
		peak_data_pc.length = 0; 
		ctpPw_data_pc.length = 0;
		cgtPw_data_pc.length = 0;
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getSiteSetDetail();
		getPeakRealList(formData); // 피크 전력 조회
//		getContractPowerList(formData); // 한전계약전력 조회
//		getChargePowerList(formData); // 요금적용전력 조회
		drawData(); // 차트 및 표 그리기
	}
	
	var contractPower;
	var chargePower;
	function callback_getSiteSetDetail(result) {
		var siteSetDetail = result.detail;
		contractPower = (siteSetDetail == null) ? null : siteSetDetail.contract_power;
		chargePower = (siteSetDetail == null) ? null : siteSetDetail.charge_power;
	}
	
	// 피크 전력
	var pastPeakList;
	function callback_getPeakRealList(result) {
		var peakList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var maxPeakVal = 0; // 최대피크
		var maxPeakTmstp; // 최대피크시간
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str2 = "";
		var dt_str3 = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		var dt_str3_totalVal = 0; // 테이블 라인별 누적합
		if(peakList.length > 0) {
			for(var i=0; i<peakList.length; i++) {
				var peakVal = String(peakList[i].peak_val);
				var rePeakVal = 0;
				var tm = new Date( convertDateUTC(peakList[i].std_timestamp) );
				
				if(peakVal == null || peakVal == "" || peakVal == "null") {
					rePeakVal = null;
				} else {
					if(peakVal.indexOf(".")>-1) rePeakVal = Math.round( Number(peakVal) );
					else rePeakVal = Number(peakVal);
					
					if(maxPeakVal < rePeakVal) {
						maxPeakVal = rePeakVal; // 최대 피크전력 구하기
						maxPeakTmstp = tm.format("yyyy-MM-dd HH:mm:ss");
					}
				}
				
				// 차트데이터 셋팅
				dataSet.push([ //peakList[i].std_timestamp
					setChartDateUTC(peakList[i].std_timestamp)
					, rePeakVal ]);
				dataSet2.push([ //Number(peakList[i].std_timestamp)
					setChartDateUTC(peakList[i].std_timestamp)
					, contractPower ]);
				dataSet3.push([ //Number(peakList[i].std_timestamp)
					setChartDateUTC(peakList[i].std_timestamp)
					, chargePower ]);
				
				// 표데이터 셋팅
				var headerDate2 = convertDataTableHeaderDate(tm, 2);
				dt_str_head += "<th>"+headerDate2+"</th>"
				if(peakVal == null || peakVal == "" || peakVal == "null") dt_str += "<td>"+" "+"</td>"; 
				else dt_str += "<td>"+ rePeakVal+"</td>";
				dt_str2 += "<td>"+ ( (contractPower == null) ? "" : contractPower    )+"</td>";
				dt_str3 += "<td>"+ ( (chargePower == null) ? "" : chargePower    )+"</td>";
				dt_str_totalVal = dt_str_totalVal+ rePeakVal;
				dt_str2_totalVal = dt_str2_totalVal+ contractPower;
				dt_str3_totalVal = dt_str3_totalVal+ chargePower;
				if(dt_col_cnt == dt_col) {
					var headerDate1 = convertDataTableHeaderDate(tm, 1);
					var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
					dt_str += "<td>"+dt_str_totalVal+"</td>";
					dt_str2 += "<td>"+dt_str2_totalVal+"</td>";
					dt_str3 += "<td>"+dt_str3_totalVal+"</td>";
					peak_head_pc[dt_row_cnt-1] = final_dt_str_head;
					peak_data_pc[dt_row_cnt-1] = dt_str;
					ctpPw_data_pc[dt_row_cnt-1] = dt_str2;
					cgtPw_data_pc[dt_row_cnt-1] = dt_str3;
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
					if((i+1) == peakList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str_head += "<th></th>";
							dt_str += "<td></td>";
							dt_str2 += "<td></td>";
							dt_str3 += "<td></td>";
						}
						var headerDate1 = convertDataTableHeaderDate(tm, 1);
						var final_dt_str_head = "<th>"+headerDate1+"</th>"+dt_str_head;
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						dt_str2 += "<td>"+dt_str2_totalVal+"</td>";
						dt_str3 += "<td>"+dt_str3_totalVal+"</td>";
						peak_head_pc[dt_row_cnt-1] = final_dt_str_head;
						peak_data_pc[dt_row_cnt-1] = dt_str;
						ctpPw_data_pc[dt_row_cnt-1] = dt_str2;
						cgtPw_data_pc[dt_row_cnt-1] = dt_str3;
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
			
		}
		pastPeakList = dataSet;
		contractPowerList = dataSet2;
		chargePowerList = dataSet3;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		// 피크의 경우 피크 최대 전력을 입력
		$(".pktime").empty().append( $("<span />").append(maxPeakTmstp) );
		unit_format(String( Math.round( Number(maxPeakVal) ) ), "pastPeakListTot", "kW");
		unit_format(String( Math.round( Number(contractPower) ) ), "contractPowerListTot", "kW");
		unit_format(String( Math.round( Number(chargePower) ) ), "chargePowerListTot", "kW");
	}
	
	// 한전계약전력
	var contractPowerList;
	function callback_getContractPowerList(result) {
		var peakList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		if(peakList.length > 0) {
			for(var i=0; i<peakList.length; i++) {
				var peakVal = String(peakList[i].peak_val);
				var rePeakVal = 0;
				if(peakVal == null || peakVal == "" || peakVal == "null") {
					rePeakVal = null;
				} else {
					if(peakVal.indexOf(".")>-1) rePeakVal = Math.round( Number(peakVal) );
					else rePeakVal = Number(peakVal);
					totUsage = totUsage+Number(peakVal);
					var a = peakVal.length;
					var c = totUsage.length;
					var b = 0;
				}
				
				var tm = new Date(peakList[i].std_timestamp);
				// 차트데이터 셋팅
				dataSet.push([
//				Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds()), 3000
					peakList[i].std_timestamp, rePeakVal
				]);
				
				// 표데이터 셋팅
				if(peakVal == null || peakVal == "" || peakVal == "null") dt_str += "<td>"+" "+"</td>"; 
				else dt_str += "<td>"+rePeakVal+"</td>";
				dt_str_totalVal = dt_str_totalVal+rePeakVal;
				if(dt_col_cnt == dt_col) {
					dt_str += "<td>"+dt_str_totalVal+"</td>";
					ctpPw_data_pc[dt_row_cnt-1] = dt_str;
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str = "";
					dt_str_totalVal = 0;
				} else {
					if(SelTerm == "day" && dt_col_cnt == peakList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str += "<td></td>";
						}
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						ctpPw_data_pc[dt_row_cnt-1] = dt_str;
						dt_str = "";
						dt_str_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
				}
				
			}
			
		}
		contractPowerList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "contractPowerListTot", "kW");
	}
	
	// 요금적용전력
	var chargePowerList;
	function callback_getChargePowerList(result) {
		var peakList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		if(peakList.length > 0) {
			for(var i=0; i<peakList.length; i++) {
				var peakVal = String(peakList[i].peak_val);
				var rePeakVal = 0;
				if(peakVal == null || peakVal == "" || peakVal == "null") {
					rePeakVal = null;
				} else {
					if(peakVal.indexOf(".")>-1) rePeakVal = Math.round( Number(peakVal) );
					else rePeakVal = Number(peakVal);
					totUsage = totUsage+Number(peakVal);
				}
				
				var tm = new Date(peakList[i].std_timestamp);
				// 차트데이터 셋팅
				dataSet.push([
//				Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds()), 2000
					peakList[i].std_timestamp, rePeakVal
				]);
				
				// 표데이터 셋팅
				if(peakVal == null || peakVal == "" || peakVal == "null") dt_str += "<td>"+" "+"</td>"; 
				else dt_str += "<td>"+rePeakVal+"</td>";
				dt_str_totalVal = dt_str_totalVal+rePeakVal;
				if(dt_col_cnt == dt_col) {
					dt_str += "<td>"+dt_str_totalVal+"</td>";
					cgtPw_data_pc[dt_row_cnt-1] = dt_str;
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str = "";
					dt_str_totalVal = 0;
				} else {
					if(SelTerm == "day" && dt_col_cnt == peakList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str += "<td></td>";
						}
						dt_str += "<td>"+dt_str_totalVal+"</td>";
						cgtPw_data_pc[dt_row_cnt-1] = dt_str;
						dt_str = "";
						dt_str_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
				}
				
			}
			
		}
		chargePowerList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "chargePowerListTot", "kW");
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '피크 전력',
			color: '#438fd7', /* 피크 전력 */
			type:'column',
			data: pastPeakList
		}, false);
		
		myChart.addSeries({
			name: '한전 계약 전력',
			color: '#13af67', /* 한전 계약 전력 */
			data: contractPowerList
		}, false);
		
		myChart.addSeries({
			name: '요금 적용 전력',
			color: '#f75c4a', /* 요금 적용 전력 */
			data: chargePowerList
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
		if(peak_data_pc.length < 1) {
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
										$("<thead/>").append( $("<tr/>").append( peak_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append( // 피크 전력
														'<th><div class="ctit pk1"><span>피크 전력</span></div></th>'+peak_data_pc[i]
												)
										).append(
												$("<tr/>").append( // 한진 계약 전력
														'<th><div class="ctit pk2"><span>한전 계약 전력</span></div></th>'+ ctpPw_data_pc[i] 
												)
										).append(
												$("<tr/>").append( // 요금 적용 전력
														'<th><div class="ctit pk3"><span>요금 적용 전력</span></th>'+ cgtPw_data_pc[i] 
												)
										)
								) 
						)
				);
				
			}
			
		}
	}
