<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	var texDay = new Date();
	
	$(document).ready(function() {
	//	$("#timeOffset").val( (new Date()).getTimezoneOffset() );
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
		
	//	var texChartStDay =new Date(stDay.setMinutes(stDay.getMinutes() + (new Date()).getTimezoneOffset()));
	//	var texChartEdDay =new Date(edDay.setMinutes(edDay.getMinutes() + (new Date()).getTimezoneOffset()));
		var texChartStDay =new Date(stDay.getTime());
		var texChartEdDay =new Date(edDay.getTime());
		
		schStartTime = new Date(firstDay.getTime());
		schEndTime = new Date(endDay.getTime());
		
	//	var queryStart = new Date(firstDay.setMinutes(firstDay.getMinutes() + (new Date()).getTimezoneOffset()));
	//	var queryEnd = new Date(endDay.setMinutes(endDay.getMinutes() + (new Date()).getTimezoneOffset()));
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
		
		addTex = Math.round(reTotPrice*pvProfitRatio/100*0.1);
		totBeneVal = (reTotPrice*pvProfitRatio)/100+addTex;
		delLastWon = Math.floor(totBeneVal/10)*10-totBeneVal;
		$("#texBill").text("태양광 발전 수익 배분 청구서 (’"+texDay.substring(2,4)+"년"+texDay.substring(4,6)+"월)");
		$("#texDay").text("청구일 : "+texDay.substring(0,4)+"-"+texDay.substring(4,6)+"-"+meterClaimDay);
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
			textbodyStr += "<td align='right'>"+((reRecPrice == null) ? "" : numberComma(reRecPrice))+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>②SMP 수익</th>";
			textbodyStr += "<td align='right'>"+((reSmpPrice == null) ? "" : numberComma(reSmpPrice))+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>③총 수익</th>";
			textbodyStr += "<td align='right'>"+((reTotPrice == null) ? "" : numberComma(reTotPrice))+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>④수익배분 계</th>";
			textbodyStr += "<td align='right'>"+numberComma((reTotPrice*pvProfitRatio)/100)+"</td>";
			textbodyStr += "</tr>";
			textbodyStr += "<tr>";
			textbodyStr += "<th>부가가치세</th>";
			textbodyStr += "<td align='right'>"+((addTex == null) ? "" : numberComma(addTex))+"</td>";
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
			elecStr += "<td align='right'>"+((reNetGenVal == null) ? "" : reNetGenVal)+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>SMP 거래량</th>";
			elecStr += "<td align='right'>"+((reSmpDeal == null) ? "" : numberComma(reSmpDeal))+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>SMP 단가</th>";
			elecStr += "<td align='right'>"+smpRateDate.substring(0, 4)+"년 "+smpRateDate.substring(4, 6)+"월 "+smpRateDate.substring(6, 8)+"일 : "+((smpRate == null) ? "" : numberComma(smpRate))+"원/kWh</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>REC 거래량</th>";
			elecStr += "<td align='right'>"+((reRecDeal == null) ? "" : numberComma(reRecDeal))+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>REC 단가</th>";
			elecStr += "<td align='right'>"+recRateDate.substring(0, 4)+"년 "+recRateDate.substring(4, 6)+"월 : "+((recRate == null) ? "" : numberComma(recRate))+"원/REC</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>REC 가중치</th>";
			elecStr += "<td align='right'>"+recWeight+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			elecStr += "<th>수익 배분</th>";
			elecStr += "<td align='right'>"+pvProfitRatio+"</td>";
			elecStr += "</tr>";
			elecStr += "<tr>";
			
			beneDivStr +="<tr>";
			beneDivStr +="<th>①REC 수익</th>";
			beneDivStr +="<td>REC 거래량 x REC 단가 ("+((reRecDeal == null) ? "" : numberComma(reRecDeal))+" x "+((recRate == null) ? "" : numberComma(recRate))+")</td>";
			beneDivStr +="</tr>";
			beneDivStr +="<tr>";
			beneDivStr +="<th>②SMP 수익</th>";
			beneDivStr +="<td>연간발전량(kWh) x SMP단가 ("+((reSmpDeal == null) ? "" : numberComma(reSmpDeal))+" x "+((smpRate == null) ? "" : numberComma(smpRate))+")</td>";
			beneDivStr +="</tr>";
			beneDivStr +="<tr>";
			beneDivStr +="<th>③총 수익</th>";
			beneDivStr +="<td>①REC 수익 + ②SMP 수익 ("+((reRecPrice == null) ? "" : numberComma(reRecPrice))+" + "+((reSmpPrice == null) ? "" : numberComma(reSmpPrice))+")</td>";
			beneDivStr +="</tr>";
			beneDivStr +="<tr>";
			beneDivStr +="<th>④수익배분 계</th>";
			beneDivStr +="<td>③총 수익 x 수익 배분 ("+((totBeneVal+delLastWon == null) ? "" : numberComma((totBeneVal+delLastWon)))+" x "+pvProfitRatio+"%)</td>";
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
			var pvRvClaimDay = texDay.substring(0, 4)+"-"+texDay.substring(4, 6)+"-"+meterClaimDay+" 00:00:00";
			var pvRvClaimDate = new Date(pvRvClaimDay);
			var paymentDate = new Date(pvRvClaimDate.setDate(pvRvClaimDate.getDate() + 10));
			infoStr +="<td>"+paymentDate.format("yyyy-MM-dd")+"</td>";
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
		
	//	setTickInterval();
		myChart1.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart1.redraw(); // 차트 데이터를 다시 그린다
	}
	
				
				
		/*// 차트데이터 셋팅
		if(netGenValChartList != null && netGenValChartList.length > 0) {
			for(var i=0; i<netGenValChartList.length; i++) {
				var yyyyMM = new Date( convertDateUTC(netGenValChartList[i].std_timestamp) ).format("yyyyMM");
	//			var netGenVal = String(netGenValChartList[i].net_gen_val);
	//			var smpDeal   = String(smpDealChartList[i].smp_deal);
				var smpPrice  = String(smpPriceChartList[i].smp_price);
	//			var recDeal   = String(recDealChartList[i].rec_deal);
				var recPrice  = String(recPriceChartList[i].rec_price);
				var totPrice  = String(totPriceChartList[i].tot_price);
	//			var reNetGenVal = 0; 
	//			var reSmpDeal   = 0; 
				var reSmpPrice  = 0; 
	//			var reRecDeal   = 0; 
				var reRecPrice  = 0; 
				var reTotPrice  = 0; 
				
	//			if(netGenVal == null || netGenVal == "" || netGenVal == "null") reNetGenVal = null;
	//			else reNetGenVal = Math.round( Number(netGenVal) );
	//			if(smpDeal == null || smpDeal == "" || smpDeal == "null") reSmpDeal = null;
	//			else reSmpDeal   = Math.round( Number(smpDeal) );
				if(smpPrice == null || smpPrice == "" || smpPrice == "null") reSmpPrice = null;
				else {
					reSmpPrice  = Math.round( Number(smpPrice) );
					totDataSet2 = totDataSet2+reSmpPrice;
				}
	//			if(recDeal == null || recDeal == "" || recDeal == "null") reRecDeal = null;
	//			else reRecDeal   = Math.round( Number(recDeal) );
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
	//			var netGenVal = String(netGenValChartList[i].net_gen_val);
	//			var smpDeal   = String(smpDealChartList[i].smp_deal);
				var smpPrice  = String(smpPriceChartList[i].smp_price);
	//			var recDeal   = String(recDealChartList[i].rec_deal);
				var recPrice  = String(recPriceChartList[i].rec_price);
				var totPrice  = String(totPriceChartList[i].tot_price);
	//			var reNetGenVal = 0; 
	//			var reSmpDeal   = 0; 
				var reSmpPrice  = 0; 
	//			var reRecDeal   = 0; 
				var reRecPrice  = 0; 
				var reTotPrice  = 0; 
				
	//			if(netGenVal == null || netGenVal == "" || netGenVal == "null") reNetGenVal = null;
	//			else reNetGenVal = Math.round( Number(netGenVal) );
	//			if(smpDeal == null || smpDeal == "" || smpDeal == "null") reSmpDeal = null;
	//			else reSmpDeal   = Math.round( Number(smpDeal) );
				if(smpPrice == null || smpPrice == "" || smpPrice == "null") reSmpPrice = null;
				else {
					reSmpPrice  = Math.round( Number(smpPrice) );
					totDataSet2 = totDataSet2+reSmpPrice;
				}
	//			if(recDeal == null || recDeal == "" || recDeal == "null") reRecDeal = null;
	//			else reRecDeal   = Math.round( Number(recDeal) );
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
		
	//	setTickInterval();
		myChart.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		var $chart = $(".income_pv_chart");
		var tbodyStr = '';
		if(pvRevenue_data_pc.length > 0) {
			$chart.find(".inchart-nodata").css("display", "none");
			$chart.find(".inchart").css("display", "");
			for(var i=0; i<dt_row; i++) {
				tbodyStr += '<div class="chart_table">';
				tbodyStr += '<table class="pc_use">';
				tbodyStr += '<thead>';
				tbodyStr += '<tr>';
				tbodyStr += '<th></th>'+pvRevenue_head_pc[i]+'<th>합계</th>';
				tbodyStr += '</tr>';
				tbodyStr += '</thead>';
				tbodyStr += '<tbody>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit wht"><span>총 발전량 (kWh)</span></div></th>'+ pvRevenue_data_pc[i];
				tbodyStr += '</tr>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit wht"><span>SMP 거래량 (kWh)</span></div></th>'+ pvRevenue_data_pc2[i] ;
				tbodyStr += '</tr>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit pk2"><span>SMP 수익 (won)</span></div></th>'+ pvRevenue_data_pc3[i];
				tbodyStr += '</tr>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit wht"><span>REC 거래량 (kWh)</span></div></th>'+ pvRevenue_data_pc4[i];
				tbodyStr += '</tr>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit pk3"><span>REC 수익 (won)</span></div></th>'+ pvRevenue_data_pc5[i];
				tbodyStr += '</tr>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit pk1"><span>총 수익 (won)</span></div></th>'+ pvRevenue_data_pc6[i];
				tbodyStr += '</tr>';
				tbodyStr += '</tbody>';
				tbodyStr += '</table>';
				tbodyStr += '</div>';
			}
			
		} else {
			$chart.find(".inchart-nodata").css("display", "");
			$chart.find(".inchart").css("display", "none");
			tbodyStr += '<div class="chart_table">';
			tbodyStr += '<table class="pc_use">';
			tbodyStr += '<thead>';
			tbodyStr += '<tr>'+'<th width="33%"></th>'+'<td width="34%">조회 결과가 없습니다.</td>'+'<th width="33%"></th>'+'</tr>';
			tbodyStr += '</thead>';
			tbodyStr += '</table>';
			tbodyStr += '</div>';
		}
		
		$("#pc_use_dataDiv").html(tbodyStr);
	}
</script>
</head>
<body>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="billRevenue" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">PV 수익 조회</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">PV 수익 합계</h2>
							<ul class="chart_total">
								<li class="ctt1">
									<div class="ctit ctt1"><span>총 수익</span></div>
									<div class="cval" id="pvRevenueTot1"><span>0</span>won</div>
								</li>
								<li class="ctt2">
									<div class="ctit ctt2"><span>SMP 수익</span></div>
									<div class="cval" id="pvRevenueTot2"><span>0</span>won</div>
								</li>
								<li class="ctt3">
									<div class="ctit ctt3"><span>REC 수익</span></div>
									<div class="cval" id="pvRevenueTot3"><span>0</span>won</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv income_pv_chart">
							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="billRevenue" name="schGbn"/>
							</jsp:include>
							<div class="inchart-nodata" style="display: none;">
								<span>조회 결과가 없습니다.</span>
							</div>
							<div class="inchart">
								<div id="chart2"></div>
								<script language="JavaScript"> 
// 								$(function () { 
									var myChart = Highcharts.chart('chart2', {
// 										data: {
// 									        table: 'datatable' /* 테이블에서 데이터 불러오기 */
// 									    },

										chart: {
											marginLeft:80,
											marginRight:0,
											backgroundColor: 'transparent',
											type: 'column'
										},

										navigation: {
											buttonOptions: {
											  enabled: false /* 메뉴 안보이기 */
											  }
										},

									    title: {
									        text: ''
									    },

									    subtitle: {
									        text: ''
									    },
									    
										xAxis: {
											
											type: 'datetime', // 08.20 이우람 추가
											dateTimeLabelFormats: { // 08.20 이우람 추가
												millisecond: '%H:%M:%S.%L',
											    second: '%H:%M:%S',
									            minute: '%H:%M',
									            hour: '%H',
									            day: '%m.%d ',
									            week: '%m.%e',
									            month: '%y/%m',
									            year: '%Y'
									        },labels: {
												align: 'center',
												style: {
													color: '#3d4250',
													fontSize: '18px'
												}
											},
											tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
											title: {
												text: null
												}
										},

										yAxis: {
											gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										    title: {
										    	text: 'won',
										    	align: 'low',
										    	rotation: 0, /* 타이틀 기울기 */
										        y:25, /* 타이틀 위치 조정 */
										        x:5, /* 타이틀 위치 조정 */
										        style: {
										            color: '#3d4250',
										            fontSize: '18px'
										        }
										    },
										    labels: {
										        overflow: 'justify',
										        x:-20, /* 그래프와의 거리 조정 */
										        style: {
										            color: '#3d4250',
										            fontSize: '14px'
										        }
										    }
										},	

									    /* 범례 */
										legend: {
											enabled: true,
											align:'right',
											verticalAlign:'top',									
											itemStyle: {
										        color: '#3d4250',
										        fontSize: '16px',
										        fontWeight: 400
										    },
										    itemHoverStyle: {
										        color: '' /* 마우스 오버시 색 */
										    },
										    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
										    symbolHeight:8 /* 심볼 크기 */
										},

										/* 툴팁 */
										tooltip: {
											    formatter: function() {
									                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m ', new Date(this.x)) 
									                	+ '월<br/><span style="color:#438fd7">' + this.y + ' won</span>';
									            }
										},

										/* 옵션 */
										plotOptions: {
									        series: {
									            label: {
									                connectorAllowed: false
									            },
									            borderWidth: 0 /* 보더 0 */
									        },
									        line: {
											    marker: {
											         enabled: false /* 마커 안보이기 */
											    }
											},
											column: {
												  stacking: '' /*위로 쌓이는 막대  ,normal */
											}
									    },

									    /* 출처 */
									    credits: {
											enabled: false
										},

									    /* 그래프 스타일 */
									    series: [{
									    	name: '총 수익',
									    	color: '#438fd7' /* 총 수익 */
									    },{
									    	name: 'SMP 수익',
									    	color: '#13af67' /* SMP 수익 */
									    },{
									    	name: 'REC 수익',
									    	color: '#f75c4a' /* REC 수익 */
									    }],

									    /* 반응형 */
									    responsive: {
									        rules: [{
									            condition: {
									                maxWidth: 414 /* 차트 사이즈 */								                
									            },
									            chartOptions: {
									            	chart: {
									            		marginLeft:80,
									            		marginTop:30
													},
													xAxis: {
														labels: {
															style: {
													            fontSize: '13px'
													        }
														}
													},
													yAxis: {
														title: {
															style: {
													            fontSize: '13px'
													        }
														},
														labels: {
															x:-10, /* 그래프와의 거리 조정 */
													        style: {
													            fontSize: '13px'
													        }
														}
													},
									                legend: {									                    
									                    layout: 'horizontal',
									                    verticalAlign: 'bottom',
									                    align:'center',
									                    x:0,
									                    itemStyle: {
												        	fontSize: '13px'
												    	}
									                }
									            }
									        }]
									    }

									});
// 								});
								</script>
							</div>	
						</div>
					</div>
				</div>
				<div class="row income_pv_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">PV 수익 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn" onclick="excelDownload('PV수익조회', event);">데이터저장</a></li>
									<li><a href="#" class="default_btn" id="pvRevenueTex">명세서 확인하기</a></li>
									<li><a href="#;" class="fold_btn">표접기</a></li>
								</ul>
							</div>
							<div class="tbl_wrap">
								<div class="fold_div" id="pc_use_dataDiv">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




	<!-- ###### 명세서 확인 및 출력 Popup Start ###### -->
	<script type="text/javascript">
		$(function(){
			$(".default_btn").on('click',function(){
				$(".lbutton").show();
			});
			
			$(".lbtn_pdf").on('click',function(){
				$(".lbutton").hide();
				setTimeout(function () {
					$(".lbutton").show();
				},1000);
			});
			
			$('.lbtn_print').on('click', function(){
				$('#layerbox').css("left", "0px");
				$('#layerbox').css("top", "-200px");
				$(".lbutton").hide();
				$('#layerbox').printThis({
				});
				setTimeout(function () {
					$(".lbutton").show();
				},1000);
			});
		});
	</script>
	<div id="layerbox" class="dprint clear pvRevenueStatement" style="margin-top:200px;width:880px;">
		<div class="lbutton fl">
			<a href="javascript:getPdfDownload();" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="#" id="pvRevenueBtnPrint" class="lbtn_print"><span>인쇄</span></a>
		</div>
		<div class="ltit fr">      	
			<a href="javascript:popupClose('dprint');">닫기</a>
		</div>
		<div class="lbody mt30" id = "printArea">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;" id = "texBill">
						태양광 발전 수익 배분 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : ${selViewSite.site_name }</td>
					<td height="30" align="right" style="font-size:12px;" id = "texDay">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
						이번 달 청구 금액은 <span class="dp_total">5,058,900</span>원 입니다
						<p style="padding-top:10px;font-size:12px;font-weight:normal;"><!-- (수익배분기간 : 2018-01-01 ~ 2018-12-31) --></p>
					</td>
				</tr>
			</table>

			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%">
					<h2>1. 청구내역</h2>
					<table class="tbl TexArea" style="margin-top:10px;">
						<colgroup>
							<col width="50%"><col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>①REC 수익</th>
								<td align="right">12,775,000</td>
							</tr>
							<tr>
								<th>②SMP 수익</th>
								<td align="right">10,220,000</td>
							</tr>
							<tr>
								<th>③총 수익</th>
								<td align="right">22,995,000</td>
							</tr>
							<tr>
								<th>④수익배분 계</th>
								<td align="right">4,599,000</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">459,906</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">-6</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>청구금액</th>
								<td align="right">5,058,900</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div class="fr" style="width:49%">
					<h2>2. 발전 정보</h2>
					<table class="tbl elecInfo" style="margin-top:10px;">
						<colgroup>
							<col width="50%"><col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>총 발전량</th>
								<td>127,750 kWh</td>
							</tr>
							<tr>
								<th>SMP 거래량</th>
								<td>127,750 kWh</td>
							</tr>
							<tr>
								<th>SMP 단가</th>
								<td>80</td>
							</tr>
							<tr>
								<th>REC 거래량</th>
								<td>127.75 kWh</td>
							</tr>
							<tr>
								<th>REC 단가</th>
								<td>100,000</td>
							</tr>
							<tr>
								<th>REC 가중치</th>
								<td>1.0</td>
							</tr>
							<tr>
								<th>수익 배분 (%)</th>
								<td>20</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<h2 style="margin-top:20px;">3. 수익분배 계산 내역</h2>
			<table class="tbl beneDiv" style="margin-top:10px;">
				<colgroup>
					<col width="25%">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th>구분</th>
						<th>계산 내역</th>
					</tr>					
				</thead>
				<tbody>
					<tr>
						<th>①REC 수익</th>
						<td>REC 거래량 x REC 단가 (217.75 x 100,000)</td>
					</tr>
					<tr>
						<th>②SMP 수익</th>
						<td>연간발전량(kWh) x SMP단가 (127,750 x 80)</td>
					</tr>
					<tr>
						<th>③총 수익</th>
						<td>①REC 수익 + ②SMP 수익 (12,775,000 + 10,220,000)</td>
					</tr>
					<tr>
						<th>④수익배분 계</th>
						<td>③총 수익 x 수익 배분 (22,995,000 x 0.2)</td>
					</tr>
				</tbody>
			</table>

			<div class="clear" style="margin-top:20px">
				<div class="fl" style="width:56%">
					<h2>4. 수익구성</h2>
					<div class="inchart">
						<div id="ly_chart_pv" style="max-width:440px;height:168px"></div>
						<script language="JavaScript"> 
// 						$(function () { 
// 						    Highcharts.setOptions({
// 						        lang: {
// 						            decimalPoint: '.',
// 						            thousandsSep: ','
// 						        }
// 						    });
							var myChart1 = Highcharts.chart('ly_chart_pv', {
							    chart: {
							    	marginTop:0,
									marginBottom:0,
							        plotBackgroundColor: null,
							        plotBorderWidth: null,
							        plotShadow: false,
							        backgroundColor: 'transparent',
							        type: 'pie'
							    },
							    navigation: {
									buttonOptions: {
									  enabled: false /* 메뉴 안보이기 */
									  }
								},
							    title: {
							        text: ''
							    },
							    tooltip: {
							        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
							    },
							    plotOptions: {
							        pie: {
							            allowPointSelect: true,
							            cursor: 'pointer',
							            dataLabels: {
							                enabled: true,
							                format: '<b>{point.name}</b> <br/> {point.y:,.0f} <br/> {point.percentage:.1f} %',
							                style: {
							                    color: '#3d4250'
							                }
							            }
							        }
							    },
							    credits: {
									enabled: false
								},
// 							    series: [{
// 							        name: '수익구성',
// 							        colorByPoint: true,
// 							        data: [{
// 							            name: '① REC 수익',
// 							            y: 3188076
// 							        }, {
// 							            name: '② SMP 수익',
// 							            y: 2227088
// 							        }]
// 							    }]
							});
// 						});
						</script>						
					</div>
				</div>
				<div class="fr" style="width:42%">
					<h2>5. 납입처</h2>
					<table class="tbl infoArea" style="margin-top:10px;">
						<colgroup>
							<col width="40%">
							<col width="60%">
						</colgroup>
						<tbody>
							<tr>
								<th>은행명</th>
								<td>우리은행</td>
							<tr>
							<tr>
								<th>계좌번호</th>
								<td>1005 – 802 - 498030</td>
							</tr>
							<tr>
								<th>예금주</th>
								<td>한국동서발전㈜</td>
							</tr>
							<tr>
								<th>납입금액</th>
								<td>30,439,360</td>
							</tr>
							<tr>
								<th>납기일</th>
								<td>2018-06-24</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

		</div>
    </div>
    <!-- ###### Popup End ###### -->




    
</body>
</html>