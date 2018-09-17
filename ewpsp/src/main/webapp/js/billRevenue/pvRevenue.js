	$(document).ready(function() {
		var firstDay = new Date();
		var endDay = new Date();
		firstDay = new Date(firstDay.getFullYear()-1, firstDay.getMonth()+1, 1, 0, 0, 0);
		endDay = new Date(endDay.getFullYear(), endDay.getMonth()+1, 0, 23, 59, 59);
//		$("#selTermFrom").val( firstDay.format("yyyyMMddHHmmss") );
//		$("#selTermTo").val( endDay.format("yyyyMMddHHmmss") );
		$("#selTermFrom").val( new Date( "2017-09-01"+" 00:00:00" ).format("yyyyMMddHHmmss") );
		$("#selTermTo").val( new Date( "2018-08-31"+" 23:59:59" ).format("yyyyMMddHHmmss") );
		
		getDBData();
	});
	
	var pvRevenue_head_pc = new Array(); //  표 데이터(헤더)
	var pvRevenue_data_pc = new Array(); //  표 데이터
	var pvRevenue_data_pc2 = new Array(); //  표 데이터
	var pvRevenue_data_pc3 = new Array(); //  표 데이터
	var pvRevenue_data_pc4 = new Array(); //  표 데이터
	var pvRevenue_data_pc5 = new Array(); //  표 데이터
	var pvRevenue_data_pc6 = new Array(); //  표 데이터
	function getDBData() {
		var formData = $("#schForm").serializeObject();
		getPVRevenueList(formData); // 실제사용량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// PV 수익 조회
	var pvRevenueList1;
	var pvRevenueList2;
	var pvRevenueList3;
	function callback_getPVRevenueList(result) {
		var pvRevenueList = result.list;
		var resultListMap = result.resultListMap;
		
		var netGenValList = resultListMap.netGenValList;
		var smpDealList =   resultListMap.smpDealList;
		var smpPriceList =  resultListMap.smpPriceList;
		var recDealList =   resultListMap.recDealList;
		var recPriceList =  resultListMap.recPriceList;
		var totPriceList =  resultListMap.totPriceList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totDataSet = 0;
		var totDataSet2 = 0;
		var totDataSet3 = 0;
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str2 = "";
		var dt_str3 = "";
		var dt_str4 = "";
		var dt_str5 = "";
		var dt_str6 = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		var dt_str3_totalVal = 0; // 테이블 라인별 누적합
		var dt_str4_totalVal = 0; // 테이블 라인별 누적합
		var dt_str5_totalVal = 0; // 테이블 라인별 누적합
		var dt_str6_totalVal = 0; // 테이블 라인별 누적합
		
		if(netGenValList.length < 1) {
			
		} else {
			for(var i=0; i<netGenValList.length; i++) {
				console.log("dddd  "+new Date(Number(netGenValList[i].std_timestamp)).format("yyyyMMddHHmmss"));
				var yyyyMM = new Date(Number(netGenValList[i].std_timestamp)).format("yyyyMM");
				var netGenVal = String(netGenValList[i].net_gen_val);
				var smpDeal   = String(smpDealList[i].smp_deal);
				var smpPrice  = String(smpPriceList[i].smp_price);
				var recDeal   = String(recDealList[i].rec_deal);
				var recPrice  = String(recPriceList[i].rec_price);
				var totPrice  = String(totPriceList[i].tot_price);
				var reNetGenVal = 0; 
				var reSmpDeal   = 0; 
				var reSmpPrice  = 0; 
				var reRecDeal   = 0; 
				var reRecPrice  = 0; 
				var reTotPrice  = 0; 
				
				if(netGenVal == null || netGenVal == "" || netGenVal == "null") reNetGenVal = null;
				else reNetGenVal = Math.round( Number(netGenVal) );
				if(smpDeal == null || smpDeal == "" || smpDeal == "null") reNetGenVal = null;
				else reSmpDeal   = Math.round( Number(smpDeal) );
				if(smpPrice == null || smpPrice == "" || smpPrice == "null") reSmpPrice = null;
				else {
					reSmpPrice  = Math.round( Number(smpPrice) );
					totDataSet2 = totDataSet2+reSmpPrice;
				}
				if(recDeal == null || recDeal == "" || recDeal == "null") reRecDeal = null;
				else reRecDeal   = Math.round( Number(recDeal) );
				if(recPrice == null || recPrice == "" || recPrice == "null") reRecPrice = null;
				else {
					reRecPrice  = Math.round( Number(recPrice) );
					totDataSet3 = totDataSet3+reRecPrice;
				}
				if(totPrice == null || totPrice == "" || totPrice == "null") reTotPrice = null;
				else {
					reTotPrice  = Math.round( Number(totPrice) );
					totDataSet = totDataSet+reTotPrice;
				}
				
				// 차트데이터 셋팅
				dataSet.push( [netGenValList[i].std_timestamp, reTotPrice] );
				dataSet2.push( [netGenValList[i].std_timestamp, reSmpPrice] );
				dataSet3.push( [netGenValList[i].std_timestamp, reRecPrice] );

				// 표데이터 셋팅
				dt_str_head += "<th>"+yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"</th>"
				dt_str += "<td>"+  ( (reNetGenVal == null) ? "" : reNetGenVal ) +"</td>"; // 총 발전량
				dt_str2 += "<td>"+ ( (reSmpPrice == null) ? "" : reSmpDeal    ) +"</td>"; // SMP 거래량
				dt_str3 += "<td>"+ ( (reSmpPrice == null) ? "" : reSmpPrice   ) +"</td>"; // SMP 수익
				dt_str4 += "<td>"+ ( (reRecDeal == null) ? "" : reRecDeal     ) +"</td>"; // REC 거래량
				dt_str5 += "<td>"+ ( (reRecPrice == null) ? "" : reRecPrice   ) +"</td>"; // REC 수익
				dt_str6 += "<td>"+ ( (reTotPrice == null) ? "" : reTotPrice   ) +"</td>"; //총 수익
				dt_str_totalVal = dt_str_totalVal+ reNetGenVal;
				dt_str2_totalVal = dt_str2_totalVal+ reSmpDeal;
				dt_str3_totalVal = dt_str3_totalVal+ reSmpPrice;
				dt_str4_totalVal = dt_str4_totalVal+ reRecDeal;
				dt_str5_totalVal = dt_str5_totalVal+ reRecPrice;
				dt_str6_totalVal = dt_str6_totalVal+ reTotPrice;
				if(dt_col_cnt == 12) {
					dt_str += "<td>"+  dt_str_totalVal  +"</td>"; // 총 발전량
					dt_str2 += "<td>"+ dt_str2_totalVal +"</td>"; // SMP 거래량
					dt_str3 += "<td>"+ dt_str3_totalVal +"</td>"; // SMP 수익
					dt_str4 += "<td>"+ dt_str4_totalVal +"</td>"; // REC 거래량
					dt_str5 += "<td>"+ dt_str5_totalVal +"</td>"; // REC 수익
					dt_str6 += "<td>"+ dt_str6_totalVal +"</td>"; //총 수익
					pvRevenue_head_pc[dt_row_cnt-1] = dt_str_head;
					pvRevenue_data_pc[dt_row_cnt-1] = dt_str;
					pvRevenue_data_pc2[dt_row_cnt-1] = dt_str2;
					pvRevenue_data_pc3[dt_row_cnt-1] = dt_str3;
					pvRevenue_data_pc4[dt_row_cnt-1] = dt_str4;
					pvRevenue_data_pc5[dt_row_cnt-1] = dt_str5;
					pvRevenue_data_pc6[dt_row_cnt-1] = dt_str6;
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str  = ""; 
					dt_str2 = ""; 
					dt_str3 = ""; 
					dt_str4 = ""; 
					dt_str5 = ""; 
					dt_str6 = ""; 
					dt_str_totalVal =  0;
					dt_str2_totalVal = 0;
					dt_str3_totalVal = 0;
					dt_str4_totalVal = 0;
					dt_str5_totalVal = 0;
					dt_str6_totalVal = 0;
				} else {
					dt_col_cnt++;
				}
				
			}
			pvRevenueList1 = dataSet;
			pvRevenueList2 = dataSet2;
			pvRevenueList3 = dataSet3;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format(String(totDataSet), "pvRevenueTot1", "won");
			unit_format(String(totDataSet2), "pvRevenueTot2", "won");
			unit_format(String(totDataSet3), "pvRevenueTot3", "won");
		}
		
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '총 수익',
			color: '#438fd7', /* 총 수익 */
			data: pvRevenueList1
		}, false);
		
		myChart.addSeries({
			name: 'SMP 수익',
			color: '#13af67', /* SMP 수익 */
			data: pvRevenueList2
		}, false);
		
		myChart.addSeries({
			name: 'REC 수익',
			color: '#f75c4a', /* REC 수익 */
			data: pvRevenueList3
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
				$("<thead/>").append( $("<tr/>").append( "<th></th>"+pvRevenue_head_pc[0]+"<th>합계</th>" ) ) // thead
		);
		if(pvRevenue_data_pc.length < 1) {
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
									'<th><div class="ctit wht"><span>총 발전량</span></div></th>'+ pvRevenue_data_pc[0] 
							)
					).append(
							$("<tr/>").append( // 경부하충전량 (kWh)
									'<th><div class="ctit wht"><span>SMP 거래량</span></div></th>'+ pvRevenue_data_pc2[0] 
							)
					).append(
							$("<tr/>").append( // 중간부하충전량 (kWh)
									'<th><div class="ctit pk2"><span>SMP 수익</span></div></th>'+ pvRevenue_data_pc3[0] 
							)
					).append(
							$("<tr/>").append( // 최대부하충전량 (kWh)
									'<th><div class="ctit wht"><span>REC 거래량</span></div></th>'+ pvRevenue_data_pc4[0] 
							)
					).append(
							$("<tr/>").append( // 경부하방전량 (kWh)
									'<th><div class="ctit pk3"><span>REC 수익</span></div></th>'+ pvRevenue_data_pc5[0] 
							)
					).append(
							$("<tr/>").append( // 경부하방전량 (kWh)
									'<th><div class="ctit pk1"><span>총 수익</span></div></th>'+ pvRevenue_data_pc6[0] 
							)
					)
			);
		}
		
	}
