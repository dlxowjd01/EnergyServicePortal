var texDay = new Date();

	$(document).ready(function() {
//		$("#timeOffset").val( (new Date()).getTimezoneOffset() );
		$("#timeOffset").val( timeOffset );
		
		var firstDay = new Date();
		var endDay = new Date();
		
		var stDay = new Date();
		var edDay = new Date();
		stDay = new Date(stDay.getFullYear(), stDay.getMonth()-1, 1, 0, 0, 0);
		edDay = new Date(stDay.getFullYear(), edDay.getMonth(), 0, 23, 59, 59);
		texDay.setYear(texDay.getFullYear());
		texDay = new Date(texDay.setMonth(firstDay.getMonth()-1));
		texDay = texDay.format("yyyyMM");
		
		firstDay = new Date(firstDay.getFullYear()-1, firstDay.getMonth()+1, 1, 0, 0, 0);
		endDay = new Date(endDay.getFullYear(), endDay.getMonth()+1, 0, 23, 59, 59);
		
//		var texChartStDay =new Date(stDay.setMinutes(stDay.getMinutes() + (new Date()).getTimezoneOffset()));
//		var texChartEdDay =new Date(edDay.setMinutes(edDay.getMinutes() + (new Date()).getTimezoneOffset()));
		var texChartStDay =new Date(stDay.getTime());
		var texChartEdDay =new Date(edDay.getTime());
		
		schStartTime = new Date(firstDay.getTime());
		schEndTime = new Date(endDay.getTime());
		
//		var queryStart = new Date(firstDay.setMinutes(firstDay.getMinutes() + (new Date()).getTimezoneOffset()));
//		var queryEnd = new Date(endDay.setMinutes(endDay.getMinutes() + (new Date()).getTimezoneOffset()));
		var queryStart = new Date(firstDay.getTime());
		var queryEnd = new Date(endDay.getTime());
		
		$("#selTermFrom").val( firstDay.format("yyyyMMddHHmmss") );
		$("#selTermTo").val( endDay.format("yyyyMMddHHmmss") );
		$("#datepicker3").val( firstDay.format("yyyy-MM") );
		$("#datepicker4").val( endDay.format("yyyy-MM") );
		
		SelTerm = "billSelectMM_pv";
		$("#selTerm").val(SelTerm);
		$("#selPeriodVal").val('month');
		
		var formData = $("#schForm").serializeObject();
		getDBData(formData);
		getSiteSetDetail(formData);
		
		
		$("#selTermFrom").val( stDay.format("yyyyMMddHHmmss") );
		$("#selTermTo").val( edDay.format("yyyyMMddHHmmss") );
		
		formData = $("#schForm").serializeObject();
		
		
		getPVRevenueTexList(formData);
		
	});
	
	$( function () {
		$("#pvRevenueTex").click(function(){
			if(netGenValSheetList != null && netGenValSheetList.length > 0){
				popupOpen('dprint')
			}else{
				alert("조회할 명세서 내역이 없습니다.");
			}
		});
	
	});
	

	function searchData() {
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
	var pvRevenue_head_pc = new Array(); //  표 데이터(헤더)
	var pvRevenue_data_pc = new Array(); //  표 데이터
	var pvRevenue_data_pc2 = new Array(); //  표 데이터
	var pvRevenue_data_pc3 = new Array(); //  표 데이터
	var pvRevenue_data_pc4 = new Array(); //  표 데이터
	var pvRevenue_data_pc5 = new Array(); //  표 데이터
	var pvRevenue_data_pc6 = new Array(); //  표 데이터
	function getDBData(formData) {
		pvRevenue_head_pc.length = 0;
		pvRevenue_data_pc.length = 0;
		pvRevenue_data_pc2.length = 0;
		pvRevenue_data_pc3.length = 0;
		pvRevenue_data_pc4.length = 0;
		pvRevenue_data_pc5.length = 0;
		pvRevenue_data_pc6.length = 0;
		pvRevenueList1 = null;
		pvRevenueList2 = null;
		pvRevenueList3 = null;
		
		
		getPVRevenueList(formData); // 실제사용량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	
	var texPvRevenueList1;
	var texPvRevenueList2;
	//pv 명세서
	var netGenValSheetList = "";
	function callback_getPVRevenueTexList(result) {
		
		
		netGenValSheetList = result.netGenValSheetList;
		var netGenValChartList = result.netGenValChartList;
	//	var smpDealSheetList   = result.smpDealSheetList  ;
		var smpDealChartList   = result.smpDealChartList  ;
		//var smpPriceSheetList  = result.smpPriceSheetList ;
		var smpPriceChartList  = result.smpPriceChartList ;
		//var recDealSheetList   = result.recDealSheetList  ;
		var recDealChartList   = result.recDealChartList  ;
		//var recPriceSheetList  = result.recPriceSheetList ;
		var recPriceChartList  = result.recPriceChartList ;
		//var totPriceSheetList  = result.totPriceSheetList ;
		var totPriceChartList  = result.totPriceChartList ;
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		var start = $("#selTermFrom").val();
		var end = $("#selTermTo").val();
		var addTex = 0;
		
		// 데이터 셋팅
		var texDataSet1 = []; // chartData를 위한 변수
		var texDataSet2 = []; // chartData를 위한 변수
		var totDataSet = 0;
		var totDataSet2 = 0;
		var totDataSet3 = 0;
		var textbodyStr = "";
		var texfootStr = "";
		var elecStr = "";
		var beneDivStr = "";
		var infoStr = "";
			
		
		var reNetGenVal = 0;
		var reSmpDeal   = 0;
		var reSmpPrice  = 0;
		var reRecDeal   = 0;
		var reRecPrice  = 0;
		var reTotPrice  = 0;
		
		if(netGenValSheetList != null && netGenValSheetList.length > 0) {
		reNetGenVal = netGenValChartList[0].net_gen_val;
		reSmpDeal   = smpDealChartList[0].smp_deal;
		reSmpPrice  = smpPriceChartList[0].smp_price;
		reRecDeal   = recDealChartList[0].rec_deal;
		reRecPrice  = recPriceChartList[0].rec_price;
		reTotPrice  = reRecPrice+reSmpPrice;
		
		totBeneVal = 0;
		delLastWon = 0;
		
		addTex = Math.round(reTotPrice*profitRatio/100*0.1);
		totBeneVal = (reTotPrice*profitRatio)/100+addTex;
		delLastWon = Math.floor(totBeneVal/10)*10-totBeneVal;
		$("#texBill").text("태양광 발전 수익 배분 청구서 (’"+texDay.substring(2,4)+"년"+texDay.substring(4,6)+"월)");
		$("#texDay").text("청구일 : "+texDay.substring(0,4)+"-"+texDay.substring(4,6)+"-"+"20");
		$(".dp_total").text(numberComma((totBeneVal+delLastWon)));
		
				/*dt_str += "<td>"+  ( (reNetGenVal == null) ? "" : reNetGenVal ) +"</td>"; // 총 발전량
				dt_str2 += "<td>"+ ( (reSmpPrice == null) ? "" : reSmpDeal    ) +"</td>"; // SMP 거래량
				dt_str3 += "<td>"+ ( (reSmpPrice == null) ? "" : reSmpPrice   ) +"</td>"; // SMP 수익
				dt_str4 += "<td>"+ ( (reRecDeal == null) ? "" : reRecDeal     ) +"</td>"; // REC 거래량
				dt_str5 += "<td>"+ ( (reRecPrice == null) ? "" : reRecPrice   ) +"</td>"; // REC 수익
				dt_str6 += "<td>"+ ( (reTotPrice == null) ? "" : reTotPrice   ) +"</td>"; //총 수익
*/	
			textbodyStr += "<tr>";
			textbodyStr += "<th>①REC 수익</th>";
			textbodyStr += "<td align='right'>"+numberComma(reRecPrice)+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>②SMP 수익</th>";
			textbodyStr += "<td align='right'>"+numberComma(reSmpPrice)+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>③총 수익</th>";
			textbodyStr += "<td align='right'>"+numberComma(reTotPrice)+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>④수익배분 계</th>";
			textbodyStr += "<td align='right'>"+numberComma((reTotPrice*profitRatio)/100)+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>부가가치세</th>";
			textbodyStr += "<td align='right'>"+numberComma(addTex)+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>원단위절사</th>";
			textbodyStr += "<td align='right'>"+delLastWon+"</td>";
			textbodyStr += "</tr>";
			
			texfootStr += "<tr>";
			texfootStr += "<th>청구금액</th>";
			texfootStr += "<td align='right'>"+(totBeneVal+delLastWon)+"</td>";
			texfootStr += "</tr>";
			
			elecStr += "<tr>";
			elecStr += "<th>총 발전</th>";
			elecStr += "<td align='right'>"+reNetGenVal+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>SMP 거래량</th>";
			elecStr += "<td align='right'>"+numberComma(reSmpDeal)+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>SMP 단가</th>";
			elecStr += "<td align='right'>"+numberComma(smpRate)+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>REC 거래량</th>";
			elecStr += "<td align='right'>"+numberComma(reRecDeal)+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>REC 단가</th>";
			elecStr += "<td align='right'>"+numberComma(recRate)+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>REC 가중치</th>";
			elecStr += "<td align='right'>"+recWeight+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>수익 배분</th>";
			elecStr += "<td align='right'>"+profitRatio+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			
			beneDivStr +="<tr>";
			beneDivStr +="<th>①REC 수익</th>";
			beneDivStr +="<td>REC 거래량 x REC 단가 ("+numberComma(reRecDeal)+" x "+numberComma(recRate)+")</td>";
			beneDivStr +="</tr>";
			beneDivStr +="<tr>";
			beneDivStr +="<th>②SMP 수익</th>";
			beneDivStr +="<td>연간발전량(kWh) x SMP단가 ("+numberComma(reSmpDeal)+" x "+numberComma(smpRate)+")</td>";
			beneDivStr +="</tr>";
			beneDivStr +="<tr>";
			beneDivStr +="<th>③총 수익</th>";
			beneDivStr +="<td>①REC 수익 + ②SMP 수익 ("+numberComma(reRecPrice)+" + "+numberComma(reSmpPrice)+")</td>";
			beneDivStr +="</tr>";
			beneDivStr +="<tr>";
			beneDivStr +="<th>④수익배분 계</th>";
			beneDivStr +="<td>③총 수익 x 수익 배분 ("+numberComma((totBeneVal+delLastWon))+" x "+profitRatio+"%)</td>";
			beneDivStr +="</tr>";
			
			
			infoStr +="<tr>";
			infoStr +="<th>은행명</th>";
			infoStr +="<td>우리은행</td>";
			infoStr +="</tr>";
			infoStr +="<tr>";
			infoStr +="<th>계좌번호</th>";
			infoStr +="<td>1005 – 802 - 498030</td>";
			infoStr +="</tr>";
			infoStr +="<tr>";
			infoStr +="<th>예금주</th>";
			infoStr +="<td>한국동서발전㈜</td>";
			infoStr +="</tr>";
			infoStr +="<tr>";
			infoStr +="<th>납입금액</th>";
			infoStr +="<td>"+numberComma((totBeneVal+delLastWon))+"</td>";
			infoStr +="</tr>";
			infoStr +="<tr>";
			infoStr +="<th>납기일</th>";
			infoStr +="<td>"+texDay.substring(0,4)+"-"+texDay.substring(4,6)+"-"+"20</td>";
			infoStr +="</tr>";
			
			
			
			$(".TexArea").find("tbody").html(textbodyStr);
			$(".TexArea").find("tfoot").html(texfootStr);
			$(".elecInfo").find("tbody").html(elecStr);
			$(".beneDiv").find("tbody").html(beneDivStr);
			$(".infoArea").find("tbody").html(infoStr);
				
			
			// 차트데이터 셋팅
			texDataSet1.push( [netGenValChartList[0].std_timestamp, reSmpPrice] );
			texDataSet2.push( [netGenValChartList[0].std_timestamp, reRecPrice] );
			
			texPvRevenueList1 = texDataSet1;
			texPvRevenueList2 = texDataSet2;
			
			drawTexData_chart();
		}
		
	}
	
	// 차트 그리기
	function drawTexData_chart() {
		var seriesLength = myChart1.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart1.series[i].remove();
		}
		
		
		myChart1.addSeries({
			name: 'SMP 수익',
			color: '#13af67', /* SMP 수익 */
			data: texPvRevenueList1
		}, false);
		
		myChart1.addSeries({
			name: 'REC 수익',
			color: '#f75c4a', /* REC 수익 */
			data: texPvRevenueList2
		}, false);
		
//		setTickInterval();
		myChart1.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart1.redraw(); // 차트 데이터를 다시 그린다
	}
	
				
				
		/*// 차트데이터 셋팅
		if(netGenValChartList != null && netGenValChartList.length > 0) {
			for(var i=0; i<netGenValChartList.length; i++) {
				var yyyyMM = new Date( convertDateUTC(netGenValChartList[i].std_timestamp) ).format("yyyyMM");
//				var netGenVal = String(netGenValChartList[i].net_gen_val);
//				var smpDeal   = String(smpDealChartList[i].smp_deal);
				var smpPrice  = String(smpPriceChartList[i].smp_price);
//				var recDeal   = String(recDealChartList[i].rec_deal);
				var recPrice  = String(recPriceChartList[i].rec_price);
				var totPrice  = String(totPriceChartList[i].tot_price);
//				var reNetGenVal = 0; 
//				var reSmpDeal   = 0; 
				var reSmpPrice  = 0; 
//				var reRecDeal   = 0; 
				var reRecPrice  = 0; 
				var reTotPrice  = 0; 
				
//				if(netGenVal == null || netGenVal == "" || netGenVal == "null") reNetGenVal = null;
//				else reNetGenVal = Math.round( Number(netGenVal) );
//				if(smpDeal == null || smpDeal == "" || smpDeal == "null") reSmpDeal = null;
//				else reSmpDeal   = Math.round( Number(smpDeal) );
				if(smpPrice == null || smpPrice == "" || smpPrice == "null") reSmpPrice = null;
				else {
					reSmpPrice  = Math.round( Number(smpPrice) );
					totDataSet2 = totDataSet2+reSmpPrice;
				}
//				if(recDeal == null || recDeal == "" || recDeal == "null") reRecDeal = null;
//				else reRecDeal   = Math.round( Number(recDeal) );
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
				dataSet.push( [netGenValChartList[i].std_timestamp, reTotPrice] );
				dataSet2.push( [netGenValChartList[i].std_timestamp, reSmpPrice] );
				dataSet3.push( [netGenValChartList[i].std_timestamp, reRecPrice] );
				
			}
			pvRevenueList1 = dataSet;
			pvRevenueList2 = dataSet2;
			pvRevenueList3 = dataSet3;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format_bill(String(totDataSet), "pvRevenueTot1", "won", "pv");
			unit_format_bill(String(totDataSet2), "pvRevenueTot2", "won", "pv");
			unit_format_bill(String(totDataSet3), "pvRevenueTot3", "won", "pv");*/
	
	
	// PV 수익 조회
	var pvRevenueList1;
	var pvRevenueList2;
	var pvRevenueList3;
	function callback_getPVRevenueList(result) {
		var netGenValSheetList = result.netGenValSheetList;
		var netGenValChartList = result.netGenValChartList;
		var smpDealSheetList   = result.smpDealSheetList  ;
		var smpDealChartList   = result.smpDealChartList  ;
		var smpPriceSheetList  = result.smpPriceSheetList ;
		var smpPriceChartList  = result.smpPriceChartList ;
		var recDealSheetList   = result.recDealSheetList  ;
		var recDealChartList   = result.recDealChartList  ;
		var recPriceSheetList  = result.recPriceSheetList ;
		var recPriceChartList  = result.recPriceChartList ;
		var totPriceSheetList  = result.totPriceSheetList ;
		var totPriceChartList  = result.totPriceChartList ;
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		var start = $("#selTermFrom").val();
		var end = $("#selTermTo").val();
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var dataSet3 = []; // chartData를 위한 변수
		var totDataSet = 0;
		var totDataSet2 = 0;
		var totDataSet3 = 0;
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
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		var dt_str2_totalVal = 0; // 테이블 라인별 누적합
		var dt_str3_totalVal = 0; // 테이블 라인별 누적합
		var dt_str4_totalVal = 0; // 테이블 라인별 누적합
		var dt_str5_totalVal = 0; // 테이블 라인별 누적합
		var dt_str6_totalVal = 0; // 테이블 라인별 누적합
		
		// 표데이터 셋팅
		var start = new Date(schStartTime.getTime());
		var end = new Date(schEndTime.getTime());
		console.log(start, end);
		if(netGenValSheetList != null && netGenValSheetList.length > 0) {
			var s = start;
			var e = end;
			setHms(s, e);
			if(periodd == 'month') {
				s.setMonth(0);
				s.setDate(1);
				s.setHours(0)
				s.setMinutes(0);
				s.setSeconds(0);
			}
			for(var i=0; i<netGenValSheetList.length; i++) {
				var yyyyMM = s.format("yyyyMM");
				dt_str_head += "<th>"+yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"</th>"
				
				var reNetGenVal = null;
				var reSmpDeal   = null;
				var reSmpPrice  = null;
				var reRecDeal   = null;
				var reRecPrice  = null;
				var reTotPrice  = null;
				for(var j=0; j<netGenValSheetList.length; j++) {
					if(s.getTime() == new Date(netGenValSheetList[j].std_timestamp).getTime()) {
						var netGenVal = String(netGenValSheetList[j].net_gen_val);
						var smpDeal   = String(smpDealSheetList[j].smp_deal);
						var smpPrice  = String(smpPriceSheetList[j].smp_price);
						var recDeal   = String(recDealSheetList[j].rec_deal);
						var recPrice  = String(recPriceSheetList[j].rec_price);
						var totPrice  = String(totPriceSheetList[j].tot_price);
						
						if(netGenVal == null || netGenVal == "" || netGenVal == "null") reNetGenVal = null;
						else {
							reNetGenVal = Math.round( Number(netGenVal) );
							dt_str_totalVal = dt_str_totalVal+ reNetGenVal;
						}
						if(smpDeal == null || smpDeal == "" || smpDeal == "null") reSmpDeal = null;
						else {
							reSmpDeal   = Math.round( Number(smpDeal) );
							dt_str2_totalVal = dt_str2_totalVal+ reSmpDeal;
						}
						if(smpPrice == null || smpPrice == "" || smpPrice == "null") reSmpPrice = null;
						else {
							reSmpPrice  = Math.round( Number(smpPrice) );
							dt_str3_totalVal = dt_str3_totalVal+ reSmpPrice;
						}
						if(recDeal == null || recDeal == "" || recDeal == "null") reRecDeal = null;
						else {
							reRecDeal   = Math.round( Number(recDeal) );
							dt_str4_totalVal = dt_str4_totalVal+ reRecDeal;
						}
						if(recPrice == null || recPrice == "" || recPrice == "null") reRecPrice = null;
						else {
							reRecPrice  = Math.round( Number(recPrice) );
							dt_str5_totalVal = dt_str5_totalVal+ reRecPrice;
						}
						if(totPrice == null || totPrice == "" || totPrice == "null") reTotPrice = null;
						else {
							reTotPrice  = Math.round( Number(totPrice) );
							dt_str6_totalVal = dt_str6_totalVal+ reTotPrice;
						}
						
						break;
					}
				}
				dt_str += "<td>"+  ( (reNetGenVal == null) ? "" : reNetGenVal ) +"</td>"; // 총 발전량
				dt_str2 += "<td>"+ ( (reSmpPrice == null) ? "" : reSmpDeal    ) +"</td>"; // SMP 거래량
				dt_str3 += "<td>"+ ( (reSmpPrice == null) ? "" : reSmpPrice   ) +"</td>"; // SMP 수익
				dt_str4 += "<td>"+ ( (reRecDeal == null) ? "" : reRecDeal     ) +"</td>"; // REC 거래량
				dt_str5 += "<td>"+ ( (reRecPrice == null) ? "" : reRecPrice   ) +"</td>"; // REC 수익
				dt_str6 += "<td>"+ ( (reTotPrice == null) ? "" : reTotPrice   ) +"</td>"; //총 수익
				
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
					dt_str  = ""; 
					dt_str2 = ""; 
					dt_str3 = ""; 
					dt_str4 = ""; 
					dt_str5 = ""; 
					dt_str6 = ""; 
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_head = 0;
					dt_str_totalVal =  0;
					dt_str2_totalVal = 0;
					dt_str3_totalVal = 0;
					dt_str4_totalVal = 0;
					dt_str5_totalVal = 0;
					dt_str6_totalVal = 0;
				} else {
					dt_col_cnt++;
				}

				s = incrementTime(s);
				
			}
			pvRevenueList1 = dataSet;
			pvRevenueList2 = dataSet2;
			pvRevenueList3 = dataSet3;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format(String(totDataSet), "pvRevenueTot1", "won");
			unit_format(String(totDataSet2), "pvRevenueTot2", "won");
			unit_format(String(totDataSet3), "pvRevenueTot3", "won");
		}
		
		// 차트데이터 셋팅
		if(netGenValChartList != null && netGenValChartList.length > 0) {
			for(var i=0; i<netGenValChartList.length; i++) {
				var yyyyMM = new Date( convertDateUTC(netGenValChartList[i].std_timestamp) ).format("yyyyMM");
//				var netGenVal = String(netGenValChartList[i].net_gen_val);
//				var smpDeal   = String(smpDealChartList[i].smp_deal);
				var smpPrice  = String(smpPriceChartList[i].smp_price);
//				var recDeal   = String(recDealChartList[i].rec_deal);
				var recPrice  = String(recPriceChartList[i].rec_price);
				var totPrice  = String(totPriceChartList[i].tot_price);
//				var reNetGenVal = 0; 
//				var reSmpDeal   = 0; 
				var reSmpPrice  = 0; 
//				var reRecDeal   = 0; 
				var reRecPrice  = 0; 
				var reTotPrice  = 0; 
				
//				if(netGenVal == null || netGenVal == "" || netGenVal == "null") reNetGenVal = null;
//				else reNetGenVal = Math.round( Number(netGenVal) );
//				if(smpDeal == null || smpDeal == "" || smpDeal == "null") reSmpDeal = null;
//				else reSmpDeal   = Math.round( Number(smpDeal) );
				if(smpPrice == null || smpPrice == "" || smpPrice == "null") reSmpPrice = null;
				else {
					reSmpPrice  = Math.round( Number(smpPrice) );
					totDataSet2 = totDataSet2+reSmpPrice;
				}
//				if(recDeal == null || recDeal == "" || recDeal == "null") reRecDeal = null;
//				else reRecDeal   = Math.round( Number(recDeal) );
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
				dataSet.push( [netGenValChartList[i].std_timestamp, reTotPrice] );
				dataSet2.push( [netGenValChartList[i].std_timestamp, reSmpPrice] );
				dataSet3.push( [netGenValChartList[i].std_timestamp, reRecPrice] );
				
			}
			pvRevenueList1 = dataSet;
			pvRevenueList2 = dataSet2;
			pvRevenueList3 = dataSet3;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format_bill(String(totDataSet), "pvRevenueTot1", "won", "pv");
			unit_format_bill(String(totDataSet2), "pvRevenueTot2", "won", "pv");
			unit_format_bill(String(totDataSet3), "pvRevenueTot3", "won", "pv");
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
		$div = $("#pc_use_dataDiv");
		$div.empty(); // 초기화
		if(pvRevenue_data_pc.length < 1) {
			$(".income_pv_chart").find(".inchart-nodata").css("display", "");
			$(".income_pv_chart").find(".inchart").css("display", "none");
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
			$(".income_pv_chart").find(".inchart-nodata").css("display", "none");
			$(".income_pv_chart").find(".inchart").css("display", "");
			for(var i=dt_row-1; i>-1; i--) {
				$div.prepend(
						$('<div class="chart_table" />').append(
								$('<table class="pc_use" />').append(
										$("<thead/>").append( $("<tr/>").append( "<th></th>"+pvRevenue_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>총 발전량 (kWh)</span></div></th>'+ pvRevenue_data_pc[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>SMP 거래량 (kWh)</span></div></th>'+ pvRevenue_data_pc2[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit pk2"><span>SMP 수익 (won)</span></div></th>'+ pvRevenue_data_pc3[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>REC 거래량 (kWh)</span></div></th>'+ pvRevenue_data_pc4[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit pk3"><span>REC 수익 (won)</span></div></th>'+ pvRevenue_data_pc5[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit pk1"><span>총 수익 (won)</span></div></th>'+ pvRevenue_data_pc6[i] 
												)
										)
								) 
						)
				);
				
			}
		}
		
	}
