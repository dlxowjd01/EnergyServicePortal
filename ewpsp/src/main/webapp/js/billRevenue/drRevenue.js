	$(document).ready(function() {
		var firstDay = new Date();
		var endDay = new Date();
		var agoDay = new Date();
		var texDay = new Date();
		
		texDay.setYear(texDay.getFullYear());
		texDay = new Date(texDay.setMonth(firstDay.getMonth()-1));
		
		agoDay.setYear(agoDay.getFullYear());
		agoDay = new Date(agoDay.setMonth(firstDay.getMonth()-5));
		firstDay.setYear(firstDay.getFullYear()-1);
		firstDay = new Date(firstDay.setMonth(firstDay.getMonth()+1));
		
		$("#selTermTex").val( texDay.format("yyyyMM") );
		$("#selTermAgo").val( agoDay.format("yyyyMM") );
		$("#selTermFrom").val( firstDay.format("yyyyMM") );
		$("#selTermTo").val( endDay.format("yyyyMM") );
		$("#datepicker3").val( firstDay.format("yyyy-MM") );
		$("#datepicker4").val( endDay.format("yyyy-MM") );
		SelTerm = "billSelectMM";
		$("#selTerm").val(SelTerm);
		
		var formData = $("#schForm").serializeObject();
		getDBData(formData);
		
		$("#selTermFrom").val( agoDay.format("yyyyMM") );
		formData = $("#schForm").serializeObject();
		getDRRevenueTexList(formData);
	});
	
	$( function () {
		$("#drRevenueTex").click(function(){
			if(sheetList.length > 0){
				
				popupOpen('dprint')
			}else{
				alert("조회할 명세서 내역이 없습니다.");
			}
		});
	
	});
	
	function searchData() {
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
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
	
	
	var texDataSet1 = [];
	var texDataSet2 = [];
	var DRRevenueTex1;
	var DRRevenueTex2;
	
	var sheetList="";
	function callback_getDRRevenueTexList(result){
		
		sheetList = result.sheetList;
		var chartList = result.chartList;
		var start = $("#selTermFrom").val();
		var end = $("#selTermTo").val();
		var texStr = "";
		var texFootStr = "";
		var saveStr = "";
		var saveFootStr = "";
		var beneAreaStr = "";
		var infoAreaStr = "";
		// 데이터 셋팅
		var dataSet1 = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수
		var totDataSet1 = 0;
		var totDataSet2 = 0;
		
		// 표데이터 셋팅
		if(sheetList.length > 0) {
			for(var i=0; i<sheetList.length; i++) {
				var yyyyMM = sheetList[i].std_yearm;
				var reductCntHour  = String(sheetList[i].reduct_cnt_hour)   ;
				var reductCap  = String(sheetList[i].reduct_cap)   ;
				var reductAmt  = String(sheetList[i].reduct_amt);
				var reductCapPer  = String(sheetList[i].reduct_cap_per);
				var capAmt  = sheetList[i].cap_amt;
				var reductRewardAmt  = sheetList[i].reduct_reward_amt   ;
				var totalRewardAmt  = String(sheetList[i].total_reward_amt)   ;
				var csmRewardAmt  = String(sheetList[i].csm_reward_amt)   ;
				var ewpRewardAmt  = String(sheetList[i].ewp_reward_amt)   ;
				var profitRatio  =sheetList[i].profit_ratio      ;
				var addRate = 0.1;
				
				var total = capAmt+reductRewardAmt;
				var beneDiv =Math.round(total*profitRatio/100);
				var addPrice = Math.round(beneDiv*addRate);
				var beneDivTotal =beneDiv+addPrice;
				
				var delLastWon = Math.floor((beneDivTotal/10))*10-beneDivTotal;
				
				var texPrice = beneDivTotal+delLastWon;
				
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
				
				if(totalRewardAmt == null || totalRewardAmt == "" || totalRewardAmt == "null") reTotalRewardAmt = null;
				else {
					reTotalRewardAmt = Math.round( Number(totalRewardAmt) );
				}
				if(csmRewardAmt == null || csmRewardAmt == "" || csmRewardAmt == "null") reCsmRewardAmt = null;
				else {
					reCsmRewardAmt = Math.round( Number(csmRewardAmt) );
				}
				if(ewpRewardAmt == null || ewpRewardAmt == "" || ewpRewardAmt == "null") reEwpRewardAmt = null;

				$("#texBill").text("DR (수요반응) 수익 배분 청구서 (’"+yyyyMM.substring(2,4)+"년"+yyyyMM.substring(4,6)+"월)");
				$("#texDay").text("청구일 : "+yyyyMM.substring(0,4)+"-"+yyyyMM.substring(4,6)+"-"+"20");
				$(".dp_total").text(numberComma(texPrice));
				// 표데이터 셋팅
				
				texStr += "<tr>";
				texStr += "<th>용량 정산금</th>";
				texStr += "<td align='right'>"+numberComma(capAmt)+"</td>";
				texStr += "<tr>";
				texStr += "<tr>";
				texStr += "<th>감축 정산금</th>";
				texStr += "<td align='right'>"+numberComma(reductRewardAmt)+"</td>";
				texStr += "<tr>";
				texStr += "<tr>";
				texStr += "<th>총 정산금액</th>";
				texStr += "<td align='right'>"+numberComma(total)+"</td>";
				texStr += "<tr>";
				texStr += "<tr>";
				texStr += "<th>고객 정산 금액</th>";
				texStr += "<td align='right'>"+numberComma(Math.round(reCsmRewardAmt))+"</td>";
				texStr += "<tr>";
				texStr += "<tr>";
				texStr += "<th>①수익배분 계</th>";
				texStr += "<td align='right'>"+numberComma(beneDiv)+"</td>";
				texStr += "<tr>";
				texStr += "<tr>";
				texStr += "<th>부가가치세</th>";
				texStr += "<td align='right'>"+numberComma(addPrice)+"</td>";
				texStr += "<tr>";
				texStr += "<tr>";
				texStr += "<th>원단위절사</th>";
				texStr += "<td align='right'>"+delLastWon+"</td>";
				texStr += "<tr>";
				texFootStr += "<tr>";
				texFootStr += "<th>청구금액</th>";
				texFootStr += "<td align='right'>"+numberComma(texPrice)+"</td>";
				texFootStr += "</tr>";

				 
				saveStr += "<tr>";
				saveStr += "<th>감축횟수-시간 (회-시간)</th>";
				saveStr += "<td align='right'>"+reductCntHour+"</td>";
				saveStr += "</tr>";
				saveStr += "<tr>";
				saveStr += "<th>감축 이행 용량 (kWh)</th>";
				saveStr += "<td align='right'>"+numberComma(reductCap)+"</td>";
				saveStr += "</tr>";
				saveStr += "<tr>";
				saveStr += "<th>감축 인정 용량 (kWh)</th>";
				saveStr += "<td align='right'>"+numberComma(reductAmt)+"</td>";
				saveStr += "</tr>";
				saveStr += "<tr>";
				saveStr += "<th>감축 이행율 (%)</th>";
				saveStr += "<td align='right'>"+numberComma(reReductCapPer)+"</td>";
				saveStr += "</tr>";
				saveStr += "<tr>";
				saveStr += "<th>수익 배분 (%)</th>";
				saveStr += "<td align='right'>"+profitRatio+"</td>";
				saveStr += "</tr>";
				
				beneAreaStr += "<tr>";
				beneAreaStr += "<th>①수익배분 계</th>";
				beneAreaStr += "<td align='right'>총 정산금액 x 수익배분("+profitRatio+")</td>";
				beneAreaStr += "</tr>";
				
				
				infoAreaStr +="<tr>";
				infoAreaStr +="<th>은행명</th>";
				infoAreaStr +="<td>우리은행</td>";
				infoAreaStr +="</tr>";
				infoAreaStr +="<tr>";
				infoAreaStr +="<th>계좌번호</th>";
				infoAreaStr +="<td>1005 – 802 - 498030</td>";
				infoAreaStr +="</tr>";
				infoAreaStr +="<tr>";
				infoAreaStr +="<th>예금주</th>";
				infoAreaStr +="<td>한국동서발전㈜</td>";
				infoAreaStr +="</tr>";
				infoAreaStr +="<tr>";
				infoAreaStr +="<th>납입금액</th>";
				infoAreaStr +="<td>"+numberComma(texPrice)+"원</td>";
				infoAreaStr +="</tr>";
				infoAreaStr +="<tr>";
				infoAreaStr +="<th>납기일</th>";
				infoAreaStr +="<td>"+yyyyMM.substring(0,4)+"-"+yyyyMM.substring(4,6)+"-20</td>";
				infoAreaStr +="</tr>";
				
				
				$(".texArea").find("tbody").html(texStr);
				$(".texArea").find("tfoot").html(texFootStr);
				$(".saveArea").find("tbody").html(saveStr);
				$(".beneArea").find("tbody").html(beneAreaStr);
				$(".infoArea").find("tbody").html(infoAreaStr);
			
			} 
		}
			
			
		//}
		
		// 차트데이터 셋팅
		if(chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var yyyyMM = chartList[i].std_yearm;
				var reductCntHour  = String(chartList[i].reduct_cnt_hour)   ;
				var reductCap  = String(chartList[i].reduct_cap)   ;
				var reductAmt  = String(chartList[i].reduct_amt);
				var reductCapPer  = String(chartList[i].reduct_cap_per);
				var capAmt  = String(chartList[i].cap_amt);
				var reductRewardAmt  = String(chartList[i].reduct_reward_amt)   ;
				var totalRewardAmt  = String(chartList[i].total_reward_amt)   ;
				var csmRewardAmt  = String(chartList[i].csm_reward_amt)   ;
				var ewpRewardAmt  = String(chartList[i].ewp_reward_amt)   ;
				var profitRatio  = String(chartList[i].profit_ratio)      ;
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
				
				/*if(reductCntHour == null || reductCntHour == "" || reductCntHour == "null") reReductCntHour = null;
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
					totDataSet = totDataSet+Number(chartList[i].total_reward_amt);
				}
				if(csmRewardAmt == null || csmRewardAmt == "" || csmRewardAmt == "null") reCsmRewardAmt = null;
				else {
					reCsmRewardAmt = Math.round( Number(csmRewardAmt) );
					totDataSet2 = totDataSet2+Number(String(chartList[i].csm_reward_amt));
				}
				if(ewpRewardAmt == null || ewpRewardAmt == "" || ewpRewardAmt == "null") reEwpRewardAmt = null;
				else reEwpRewardAmt = Math.round( Number(ewpRewardAmt) );
				if(profitRatio == null || profitRatio == "" || profitRatio == "null") reProfitRatio = null;
				else reProfitRatio = Math.round( Number(profitRatio) );*/
				
				// 차트데이터 셋팅
				texDataSet1.push( [Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].total_reward_amt] );
				texDataSet2.push( [Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].csm_reward_amt] );
				
			}
				// 차트데이터 셋팅
			DRRevenueTex1 = texDataSet1;
			DRRevenueTex2 = texDataSet2;
			texDrawData_chart();
		
		}
	}
	
	// 명세서 차트 그리기
	function texDrawData_chart() {
		var seriesLength = myChart1.series.length;
		
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart1.series[i].remove();
		}
		
		myChart1.addSeries({
			name: '총 정산금액',
			color: '#438fd7', /* 기본요금 */
			data: DRRevenueTex1
		}, false);
		
		myChart1.addSeries({
			name: '고객할인금액',
			color: '#13af67', /* 사용요금(역률 적용) */
			data: DRRevenueTex2
		}, false);
		
		
//		setTickInterval();
		myChart1.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart1.redraw(); // 차트 데이터를 다시 그린다
	}
	
	
	// DR 수익 조회
	var drRevenueList1;
	var drRevenueList2;
	function callback_getDRRevenueList(result) {
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
		
		// 표데이터 셋팅
		if(sheetList != null && sheetList.length > 0) {
			for(var i=0; i<sheetList.length; i++) {
				var yyyyMM = sheetList[i].std_yearm;
				var reductCntHour  = String(sheetList[i].reduct_cnt_hour)   ;
				var reductCap  = String(sheetList[i].reduct_cap)   ;
				var reductAmt  = String(sheetList[i].reduct_amt);
				var reductCapPer  = String(sheetList[i].reduct_cap_per);
				var capAmt  = String(sheetList[i].cap_amt);
				var reductRewardAmt  = String(sheetList[i].reduct_reward_amt)   ;
				var totalRewardAmt  = String(sheetList[i].total_reward_amt)   ;
				var csmRewardAmt  = String(sheetList[i].csm_reward_amt)   ;
				var ewpRewardAmt  = String(sheetList[i].ewp_reward_amt)   ;
				var profitRatio  = String(sheetList[i].profit_ratio)      ;
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
//					totDataSet = totDataSet+Number(sheetList[i].total_reward_amt);
				}
				if(csmRewardAmt == null || csmRewardAmt == "" || csmRewardAmt == "null") reCsmRewardAmt = null;
				else {
					reCsmRewardAmt = Math.round( Number(csmRewardAmt) );
//					totDataSet2 = totDataSet2+Number(String(sheetList[i].csm_reward_amt));
				}
				if(ewpRewardAmt == null || ewpRewardAmt == "" || ewpRewardAmt == "null") reEwpRewardAmt = null;
				else reEwpRewardAmt = Math.round( Number(ewpRewardAmt) );
				if(profitRatio == null || profitRatio == "" || profitRatio == "null") reProfitRatio = null;
				else reProfitRatio = Math.round( Number(profitRatio) );

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
			
		}
		
		// 차트데이터 셋팅
		if(chartList != null && chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var yyyyMM = chartList[i].std_yearm;
				var reductCntHour  = String(chartList[i].reduct_cnt_hour)   ;
				var reductCap  = String(chartList[i].reduct_cap)   ;
				var reductAmt  = String(chartList[i].reduct_amt);
				var reductCapPer  = String(chartList[i].reduct_cap_per);
				var capAmt  = String(chartList[i].cap_amt);
				var reductRewardAmt  = String(chartList[i].reduct_reward_amt)   ;
				var totalRewardAmt  = String(chartList[i].total_reward_amt)   ;
				var csmRewardAmt  = String(chartList[i].csm_reward_amt)   ;
				var ewpRewardAmt  = String(chartList[i].ewp_reward_amt)   ;
				var profitRatio  = String(chartList[i].profit_ratio)      ;
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
					totDataSet = totDataSet+Number(chartList[i].total_reward_amt);
				}
				if(csmRewardAmt == null || csmRewardAmt == "" || csmRewardAmt == "null") reCsmRewardAmt = null;
				else {
					reCsmRewardAmt = Math.round( Number(csmRewardAmt) );
					totDataSet2 = totDataSet2+Number(String(chartList[i].csm_reward_amt));
				}
				if(ewpRewardAmt == null || ewpRewardAmt == "" || ewpRewardAmt == "null") reEwpRewardAmt = null;
				else reEwpRewardAmt = Math.round( Number(ewpRewardAmt) );
				if(profitRatio == null || profitRatio == "" || profitRatio == "null") reProfitRatio = null;
				else reProfitRatio = Math.round( Number(profitRatio) );
				
				// 차트데이터 셋팅
				dataSet.push( [Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].total_reward_amt] );
				dataSet2.push( [Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].csm_reward_amt] );
				
			}
			drRevenueList1 = dataSet;
			drRevenueList2 = dataSet2;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format_bill(String(totDataSet), "drRevenueTot1", "won", "dr");
			unit_format_bill(String(totDataSet2), "drRevenueTot2", "won", "dr");
		}
		
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '총 정산금액',
			color: '#438fd7', /* 총 정산금액 */
			data: drRevenueList1
		}, false);
		
		myChart.addSeries({
			name: '고객 할인금액',
			color: '#84848f', /* 고객 할인금액 */
			data: drRevenueList2
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
		if(drRevenue_data_pc.length < 1) {
			$(".income_dr_chart").find(".inchart-nodata").css("display", "");
			$(".income_dr_chart").find(".inchart").css("display", "none");
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
			$(".income_dr_chart").find(".inchart-nodata").css("display", "none");
			$(".income_dr_chart").find(".inchart").css("display", "");
			for(var i=dt_row-1; i>-1; i--) {
				$div.prepend(
						$('<div class="chart_table" />').append(
								$('<table class="pc_use" />').append(
										$("<thead/>").append( $("<tr/>").append( "<th></th>"+drRevenue_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>감축 횟수-시간 (회-hr)</span></div></th>'+ drRevenue_data_pc[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>감축이행용량 (kWh)</span></div></th>'+ drRevenue_data_pc2[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>감축인정용량 (kWh)</span></div></th>'+ drRevenue_data_pc3[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>감축이행율 (%)</span></div></th>'+ drRevenue_data_pc4[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>용량정산금 (won)</span></div></th>'+ drRevenue_data_pc5[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>감축정산금 (won)</span></div></th>'+ drRevenue_data_pc6[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit ct1"><span>총 정산금액 (won)</span></div></th>'+ drRevenue_data_pc7[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit"><span>고객 할인금액 (won)</span></div></th>'+ drRevenue_data_pc8[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>EWP 정산금액 (won)</span></div></th>'+ drRevenue_data_pc9[i] 
												)
										).append(
												$("<tr/>").append(
														'<th><div class="ctit wht"><span>수익비율 (%)</span></div></th>'+drRevenue_data_pc10[i]
												)
										)
								) 
						)
				);
				
			}
		}
		
	}