<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	$(document).ready(function() {
		var firstDay = new Date();
		var endDay = new Date();
		var agoDay = new Date();
		var texDay = new Date();
		
		agoDay.setYear(agoDay.getFullYear());
		agoDay = new Date(agoDay.setMonth(firstDay.getMonth()-5));
		firstDay.setYear(firstDay.getFullYear()-1);
		firstDay = new Date(firstDay.setMonth(firstDay.getMonth()+1));
		$("#selTermAgo").val( agoDay.format("yyyyMM") );
		$("#selTermFrom").val( firstDay.format("yyyyMM") );
		$("#selTermTo").val( endDay.format("yyyyMM") );
		$("#datepicker3").val( firstDay.format("yyyy-MM") );
		$("#datepicker4").val( endDay.format("yyyy-MM") );
		SelTerm = "billSelectMM";
		$("#selTerm").val(SelTerm);
		
		var formData = $("#schForm").serializeObject();
		getDBData(formData);
		
		texDay.setYear(texDay.getFullYear());
		texDay = new Date(texDay.setMonth(texDay.getMonth()-1));
		$("#selTermTex").val(texDay.format('yyyyMM'));
		$("#selTermTo").val( endDay.format("yyyyMM") );
		$("#selTermFrom").val( agoDay.format("yyyyMM") );
		formData = $("#schForm").serializeObject();
		getSiteSetDetail(formData);
		getKepcoTexBillList(formData);
	});
	
	
	$( function () {
		$("#kepcoBillTex").click(function(){
			if(texList.length > 0){
				
				popupOpen('dprint')
			}else{
				alert("조회할 명세서 내역이 없습니다.");
			}
		});
	
	});
	function searchData() {
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
	var kepcoBill_head_pc = new Array(); //  표 데이터(헤더)
	var kepcoBill_data_pc = new Array(); //  표 데이터
	var kepcoBill_data_pc2 = new Array(); //  표 데이터
	var kepcoBill_data_pc3 = new Array(); //  표 데이터
	var kepcoBill_data_pc4 = new Array(); //  표 데이터
	var kepcoBill_data_pc5 = new Array(); //  표 데이터
	var kepcoBill_data_pc6 = new Array(); //  표 데이터
	var kepcoBill_data_pc7 = new Array(); //  표 데이터
	function getDBData(formData) {
		kepcoBill_head_pc.length = 0;
		kepcoBill_data_pc.length = 0;
		kepcoBill_data_pc2.length = 0;
		kepcoBill_data_pc3.length = 0;
		kepcoBill_data_pc4.length = 0;
		kepcoBill_data_pc5.length = 0;
		kepcoBill_data_pc6.length = 0;
		kepcoBill_data_pc7.length = 0;
		kepcoBillList1 = null;
		kepcoBillList2 = null;
		kepcoBillList3 = null;
		kepcoBillList4 = null;
	//	var formData = $("#schForm").serializeObject();
		getKepcoBillList(formData); // 실제사용량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	var texDataSet1 = [];
	var texDataSet2 = [];
	var texDataSet3 = [];
	var texDataSet4 = [];
	var kepcoTexBillList1;
	var kepcoTexBillList2;
	var kepcoTexBillList3;
	var kepcoTexBillList4;
	
	var texList = "";
	function callback_getKepcoTexBillList(result) {
		texList = result.texList;
		var chartList = result.chartList;
		
		var texStr = "";
		var texFoodStr = "";
		var customerStr = "";
		var texInfoStr = "";
		var datatable = "";
		var str11 = "";
		
		if(texList.length > 0){
			
			var chartList = result.chartList;
			var yyyyMM = texList[0].bill_yearm;
			var totalTex = texList[0].tot_elec_rate+texList[0].val_add_tax+texList[0].elec_fund;
			var texStr = "";
			var texFoodStr = "";
			var customerStr = "";
			var texInfoStr = "";
			var datatable = "";
			var str11 = "";
			var delLastWon = Math.floor(totalTex/10)*10-totalTex;
			
			if(meterReadDay >= 28 && yyyyMM.substring(4,6) == 02){
				meterReadDay=28;
			}
			$("#texArea").find("tbody").empty();
			$("#texArea").find("tfoot").empty();
			
			$("#texBill").text("전기 요금 청구서 ("+yyyyMM.substring(2,4)+"년"+yyyyMM.substring(4,6)+"월)");
			$("#texDay").text("청구일 : "+yyyyMM.substring(0,4)+"-"+yyyyMM.substring(4,6)+"-"+meterClaimDay);
			$(".dp_total").text(numberComma(Math.floor(texList[0].tot_amt_bill/10)*10));
			texStr +="<tr>";
			texStr +="<th>기본요금</th>";
			texStr +="<td>"+numberComma(texList[0].base_rate)+"원</td>";
			texStr +="</tr>";
			texStr +="<tr>";
			texStr +="<th>전력량요금</th>";
			texStr +="<td>"+numberComma(texList[0].consume_rate)+"원</td>";
			texStr +="</tr>";
			texStr +="<tr>";
			texStr +="<th>전기요금계</th>";
			texStr +="<td>"+numberComma(texList[0].tot_elec_rate)+"원</td>";
			texStr +="</tr>";
			texStr +="<tr>";
			texStr +="<th>부가가치세</th>";
			texStr +="<td>"+numberComma(texList[0].val_add_tax)+"원</td>";
			texStr +="</tr>";
			texStr +="<tr>";
			texStr +="<th>전력기금</th>";
			texStr +="<td>"+numberComma(texList[0].elec_fund)+"원</td>";
			texStr +="</tr>";
			texStr +="<tr>";
			texStr +="<th>원단위절사</th>";
			texStr +="<td>"+delLastWon+"원</td>";
			texStr +="</tr>";
			texStr +="<tr>";
			texStr +="<tr>";
			texStr +="<th>당월요금계</th>";
			texStr +="<td>"+numberComma(Math.floor(texList[0].tot_amt_bill/10)*10)+"원</td>";
			texStr +="</tr>";
			
			
			
			texFoodStr +="<tr>";
			texFoodStr +="<th>청구금액</th>";
			texFoodStr +="<td>"+numberComma(Math.floor(texList[0].tot_amt_bill/10)*10)+"원</td>";
			texFoodStr +="</tr>";
			
			texInfoStr +="<tr>";
			texInfoStr +="<th>계좌번호</th>";
			texInfoStr +="<td>1005-802-498030</td>";
			texInfoStr +="</tr>";
			texInfoStr +="<tr>";
			texInfoStr +="<th>예금주</th>";
			texInfoStr +="<td>한국동서발전(주)</td>";
			texInfoStr +="</tr>";
			texInfoStr +="<tr>";
			texInfoStr +="<th>납입금액</th>";
			texInfoStr +="<td>"+numberComma(Math.floor(texList[0].tot_amt_bill/10)*10)+"원</td>";
			texInfoStr +="</tr>";
			texInfoStr +="<tr>";
			texInfoStr +="<th>납기일</th>";
			var kepcoBillClaimDay = yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"-"+meterClaimDay+" 00:00:00";
			var kepcoBillClaimDate = new Date(kepcoBillClaimDay);
			var paymentDate = new Date(kepcoBillClaimDate.setDate(kepcoBillClaimDate.getDate() + 10));
			texInfoStr +="<td>"+paymentDate.format("yyyy년 MM월 dd일")+"</td>";
			texInfoStr +="</tr>";
			
			
			customerStr +="<tr>";
			customerStr +="<th>고객번호</th>";
			customerStr +="<td>"+custNum+"</td>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>주소</th>";
			customerStr +="<td>"+useElecAddr+"</td>";
			customerStr +="</tr>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>전기사용 계약종별</th>";
			customerStr +="<td>"+planTypeName+"</td>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>정기검침일</th>";
			customerStr +="<td>"+yyyyMM.substring(0, 4)+"년"+yyyyMM.substring(4, 6)+"월"+meterReadDay+"일</td>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>계량기번호</th>";
			customerStr +="<td>"+meterNum+"</td>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>계량기배수</th>";
			customerStr +="<td>"+meterSf+"</td>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>계약전력</th>";
			customerStr +="<td>"+contractPower+"</td>";
			customerStr +="</tr>";
	
			$("#texArea").find("tbody").html(texStr);
			$("#texArea").find("tfoot").html(texFoodStr);
			$(".texInfo").find("tbody").html(texInfoStr);
			$(".customerInfo").find("tbody").html(customerStr);
			
		} 
		if(chartList.length > 0) {
			//$("#ly_datatable_hj").find("tbody").empty();
		
			for(var i=0; i<chartList.length; i++) {
				var yyyyMM = chartList[i].bill_yearm;
				var baseRate = String(chartList[i].base_rate);
				var pwrFactorRate   = String(chartList[i].pwr_factor_rate);
				var consumeRate  = String(chartList[i].consume_rate);
				var totElecRate   = String(chartList[i].tot_elec_rate);
				var elecFund  = String(chartList[i].elec_fund);
				var valAddTax  = String(chartList[i].val_add_tax);
				var totAmtBill  = String(chartList[i].tot_amt_bill);
				var chartListStr = ""; 
				var reBaseRate = 0; 
				var rePwrFactorRate = 0; 
				var reConsumeRate = 0; 
				var reTotElecRate = 0; 
				var reElecFund = 0; 
				var reValAddTax = 0; 
				var reTotAmtBill = 0;
				
				
	        /*
	        	chartListStr += "<tr>";
	        	chartListStr += "<th>"+yyyyMM+"</th>";
	        	chartListStr += "<td>"+baseRate+"</td>";
	        	chartListStr += "<td>"+consumeRate+"</td>";
	        	chartListStr += "<td>"+elecFund+"</td>";
	        	chartListStr += "<td>"+valAddTax+"</td>";
	        	chartListStr += "</tr>";
				
	        	$("#ly_datatable_hj").find("tbody").append(chartListStr)*/
				// 차트데이터 셋팅
				texDataSet1.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].base_rate] );
				texDataSet2.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].consume_rate] ); // 역률적용된 사용요금은 다시 확인해야함
				texDataSet3.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].elec_fund] );
				texDataSet4.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].val_add_tax] );
				
			}
			kepcoTexBillList1 = texDataSet1;
			kepcoTexBillList2 = texDataSet2;
			kepcoTexBillList3 = texDataSet3;
			kepcoTexBillList4 = texDataSet4;
				
		}else{
			$(".income_kt_chart").find(".inchart-nodata").css("display", "");
			$(".income_kt_chart").find(".inchart").css("display", "none");
		}
		
		texDrawData_chart();
		
	}
	
	// 명세서 차트 그리기
	function texDrawData_chart() {
		var seriesLength = myChart1.series.length;
		
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart1.series[i].remove();
		}
		
		myChart1.addSeries({
			name: '기본요금',
			color: '#438fd7', /* 기본요금 */
			data: kepcoTexBillList1
		}, false);
		
		myChart1.addSeries({
			name: '사용요금(역률 적용)',
			color: '#13af67', /* 사용요금(역률 적용) */
			data: kepcoTexBillList2
		}, false);
		
		myChart1.addSeries({
			name: '전력산업기반기금',
			color: '#f75c4a', /* 전력산업기반기금 */
			data: kepcoTexBillList3
		}, false);
		
		myChart1.addSeries({
			name: '부가세',
			color: '#84848f', /* 부가세 */
			data: kepcoTexBillList4
		}, false);
		
	//	setTickInterval();
		myChart1.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart1.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 한전 요금 조회
	var kepcoBillList1;
	var kepcoBillList2;
	var kepcoBillList3;
	var kepcoBillList4;
	function callback_getKepcoBillList(result) {
		var sheetList = result.sheetList;
		var chartList = result.chartList;
		var start = $("#selTermFrom").val();
		var end = $("#selTermTo").val();
		var sheetStartDt = start.substring(0, 4)+"01";
		var sheetEndDt = end.substring(0, 4)+"12";
		
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
		dt_row = (Number(end.substring(0, 4))-Number(start.substring(0, 4)) )+1;
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
		
		// 표데이터 셋팅
		if(sheetList != null && sheetList.length > 0) {
			for(var i=0; i<sheetList.length; i++) {
				var yyyyMM = sheetList[i].bill_yearm;
				var baseRate = String(sheetList[i].base_rate);
				var pwrFactorRate   = String(sheetList[i].pwr_factor_rate);
				var consumeRate  = String(sheetList[i].consume_rate);
				var totElecRate   = String(sheetList[i].tot_elec_rate);
				var elecFund  = String(sheetList[i].elec_fund);
				var valAddTax  = String(sheetList[i].val_add_tax);
				var totAmtBill  = String(sheetList[i].tot_amt_bill);
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
	//				totUsage = totUsage+Number(sheetList[i].base_rate);
				}
				if(pwrFactorRate == null || pwrFactorRate == "" || pwrFactorRate == "null") rePwrFactorRate = null;
				else rePwrFactorRate = Math.round( Number(pwrFactorRate) );
				if(consumeRate == null || consumeRate == "" || consumeRate == "null") reConsumeRate = null;
				else {
					reConsumeRate = Math.round( Number(consumeRate) );
	//				totUsage2 = totUsage2+Number(String(sheetList[i].consume_rate));
				}
				if(totElecRate == null || totElecRate == "" || totElecRate == "null") reTotElecRate = null;
				else reTotElecRate = Math.round( Number(totElecRate) );
				if(elecFund == null || elecFund == "" || elecFund == "null") reElecFund = null;
				else {
					reElecFund = Math.round( Number(elecFund) );
	//				totUsage3 = totUsage3+Number(String(sheetList[i].elec_fund));
				}
				if(valAddTax == null || valAddTax == "" || valAddTax == "null") reValAddTax = null;
				else {
					reValAddTax = Math.round( Number(valAddTax) );
	//				totUsage4 = totUsage4+Number(String(sheetList[i].val_add_tax));
				}
				if(totAmtBill == null || totAmtBill == "" || totAmtBill == "null") reTotAmtBill = null;
				else reTotAmtBill = Math.round( Number(totAmtBill) );
	
				// 표데이터 셋팅
				dt_str_head += "<th>"+yyyyMM.substring(0, 4)+"-"+yyyyMM.substring(4, 6)+"</th>";
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
					if( (i+1) == sheetList.length ) { // 조회한 목록이 라인을 다 못채울 때
	//					var headerDate1 = convertDataTableHeaderDate(tm, 1);
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
					
				}
				
			}
			
		}
		
		// 차트데이터 셋팅
		if(chartList != null && chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var yyyyMM = chartList[i].bill_yearm;
				var baseRate = String(chartList[i].base_rate);
				var pwrFactorRate   = String(chartList[i].pwr_factor_rate);
				var consumeRate  = String(chartList[i].consume_rate);
				var totElecRate   = String(chartList[i].tot_elec_rate);
				var elecFund  = String(chartList[i].elec_fund);
				var valAddTax  = String(chartList[i].val_add_tax);
				var totAmtBill  = String(chartList[i].tot_amt_bill);
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
					totUsage = totUsage+Number(chartList[i].base_rate);
				}
				if(pwrFactorRate == null || pwrFactorRate == "" || pwrFactorRate == "null") rePwrFactorRate = null;
				else rePwrFactorRate = Math.round( Number(pwrFactorRate) );
				if(consumeRate == null || consumeRate == "" || consumeRate == "null") reConsumeRate = null;
				else {
					reConsumeRate = Math.round( Number(consumeRate) );
					totUsage2 = totUsage2+Number(String(chartList[i].consume_rate));
				}
				if(totElecRate == null || totElecRate == "" || totElecRate == "null") reTotElecRate = null;
				else reTotElecRate = Math.round( Number(totElecRate) );
				if(elecFund == null || elecFund == "" || elecFund == "null") reElecFund = null;
				else {
					reElecFund = Math.round( Number(elecFund) );
					totUsage3 = totUsage3+Number(String(chartList[i].elec_fund));
				}
				if(valAddTax == null || valAddTax == "" || valAddTax == "null") reValAddTax = null;
				else {
					reValAddTax = Math.round( Number(valAddTax) );
					totUsage4 = totUsage4+Number(String(chartList[i].val_add_tax));
				}
				if(totAmtBill == null || totAmtBill == "" || totAmtBill == "null") reTotAmtBill = null;
				else reTotAmtBill = Math.round( Number(totAmtBill) );
				
				// 차트데이터 셋팅
				dataSet.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].base_rate] );
				dataSet2.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].consume_rate] ); // 역률적용된 사용요금은 다시 확인해야함
				dataSet3.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].elec_fund] );
				dataSet4.push( [ Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6)-1, 1), chartList[i].val_add_tax] );
				
			}
			kepcoBillList1 = dataSet;
			kepcoBillList2 = dataSet2;
			kepcoBillList3 = dataSet3;
			kepcoBillList4 = dataSet4;
			
			// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
			unit_format_bill(String(totUsage), "kepcoBillTot1", "won", "kepco");
			unit_format_bill(String(totUsage2), "kepcoBillTot2", "won", "kepco");
			unit_format_bill(String(totUsage3), "kepcoBillTot3", "won", "kepco");
			unit_format_bill(String(totUsage4), "kepcoBillTot4", "won", "kepco");
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
		
	//	setTickInterval();
		myChart.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다
		$div = $("#pc_use_dataDiv");
		$div.empty(); // 초기화
		if(kepcoBill_data_pc.length < 1) {
			$(".income_kt_chart").find(".inchart-nodata").css("display", "");
			$(".income_kt_chart").find(".inchart").css("display", "none");
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
			$(".income_kt_chart").find(".inchart-nodata").css("display", "none");
			$(".income_kt_chart").find(".inchart").css("display", "");
			for(var i=dt_row-1; i>-1; i--) {
				$div.prepend(
						$('<div class="chart_table" />').append(
								$('<table class="pc_use" />').append(
										$("<thead/>").append( $("<tr/>").append( "<th></th>"+kepcoBill_head_pc[i]+"<th>합계</th>" ) ) // thead
								).append(
										$("<tbody/>").append( // tbody
												$("<tr/>").append( // 기본요금
														'<th><div class="ctit ctt1"><span>기본요금 (won)</span></div></th>'+kepcoBill_data_pc[i]
												)
										).append(
												$("<tr/>").append( // 역률
														'<th><div class="ctit wht"><span>역률 (won)</span></div></th>'+ kepcoBill_data_pc2[i] 
												)
										).append(
												$("<tr/>").append( // 사용요금
														'<th><div class="ctit ctt2"><span>사용요금 (won)</span></div></th>'+ kepcoBill_data_pc3[i] 
												)
										).append(
												$("<tr/>").append( // 전기요금합계
														'<th><div class="ctit wht"><span>전기요금합계 (won)</span></div></th>'+ kepcoBill_data_pc4[i] 
												)
										).append(
												$("<tr/>").append( // 전력산업기반기금
														'<th><div class="ctit ctt3"><span>전력산업기반기금 (won)</span></div></th>'+ kepcoBill_data_pc5[i] 
												)
										).append(
												$("<tr/>").append( // 부가세
														'<th><div class="ctit ctt4"><span>부가세 (won)</span></div></th>'+ kepcoBill_data_pc6[i] 
												)
										).append(
												$("<tr/>").append( // 청구요금
														'<th><div class="ctit wht"><span>청구요금 (won)</span></div></th>'+ kepcoBill_data_pc7[i] 
												)
										)
								) 
						)
				);
				
			}
		}
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
						<h1 class="page-header">한전 요금 조회</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">한전 요금 합계</h2>
							<ul class="chart_total">
								<li class="ctt1">
									<div class="ctit ctt1"><span>기본요금</span></div>
									<div class="cval" id="kepcoBillTot1"><span>0</span>won</div>
								</li>
								<li class="ctt2">
									<div class="ctit ctt2"><span>사용요금(역률적용)</span></div>
									<div class="cval" id="kepcoBillTot2"><span>0</span>won</div>
								</li>
								<li class="ctt3">
									<div class="ctit ctt3"><span>전력산업기반기금</span></div>
									<div class="cval" id="kepcoBillTot3"><span>0</span>won</div>
								</li>
								<li class="ctt4">
									<div class="ctit ctt4"><span>부가세</span></div>
									<div class="cval" id="kepcoBillTot4"><span>0</span>won</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv income_kt_chart">
							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="billRevenue" name="schGbn"/>
							</jsp:include>
							<div class="inchart-nodata" style="display: none;">
								<span>조회 결과가 없습니다.</span>
							</div>
							<div class="inchart">
								<div id="chart2"></div>
								<script language="JavaScript"> 
// 								function commonPrint(){
// 									$("#printArea").printThis();
// 								}
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
									        },
											labels: {
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
												  stacking: 'normal' /*위로 쌓이는 막대  ,normal */
											}
									    },

									    /* 출처 */
									    credits: {
											enabled: false
										},

									    /* 그래프 스타일 */
									    series: [{
									        color: '#438fd7' /* 기본요금 */
									    },{
									        color: '#13af67' /* 사용요금(역률 적용) */
									    },{
									        color: '#f75c4a' /* 전력산업기반기금 */
									    },{
									        color: '#84848f' /* 부가세 */
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
				<div class="row income_kt_chart_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">한전 요금 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn" onclick="excelDownload('한전요금조회', event);">데이터저장</a></li>
									<li><a href="#" class="default_btn" id = "kepcoBillTex">명세서 확인하기</a></li>
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
                $('#layerbox').css("top", "-300px");
                $(".lbutton").hide();
            	$('#layerbox').printThis({
	        	});
            	setTimeout(function () {
            		$(".lbutton").show();
            	},1000);
            });
        });
    </script>
    <div id="layerbox" class="dprint clear kepcoBillStatement" style="margin-top:350px;width:880px;">
    	<div class="lbutton fl">
			<a href="javascript:getPdfDownload();" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="#"  class="lbtn_print"><span>인쇄</span></a>
		</div>
        <div class="ltit fr">      	
			<a href="javascript:popupClose('dprint');">닫기</a>
        </div>
			<div class="lbody mt30 " >
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;" id= "texBill">
							전기 요금 청구서 (’18년 5월)
					  	</td>
					</tr>
					<tr>
						<td height="30" align="left" style="font-size:12px;">고객명 : ${selViewSite.site_name }</td>
						<td height="30" align="right" style="font-size:12px;" id = "texDay">청구일 : 2018-07-20</td>
					</tr>
					<tr>
						<td colspan="2" height="40" align="right" style="font-size:16px;font-weight:600;">이번 달 청구 금액은 <span class="dp_total">2,220,000</span>원 입니다</td>
					</tr>
				</table>
				<h2 class="mt20">청구 상세내역</h2>
				<table class="tbl"  id="texArea" style="margin-top:10px">
					<colgroup>
						<col width="30%">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th>기본요금</th>
							<td align="right">10,000</td>
						</tr>
						<tr>
							<th>전력량요금</th>
							<td align="right">2,000,000</td>
						</tr>
						<tr>
							<th>전기요금계</th>
							<td align="right">2,010,000</td>
						</tr>
						<tr>
							<th>부가가치세</th>
							<td align="right">200,000</td>
						</tr>
						<tr>
							<th>전력기금</th>
							<td align="right">10,006</td>
						</tr>
						<tr>
							<th>원단위절사</th>
							<td align="right">-6</td>
						</tr>
						<tr>
							<th>당월요금계</th>
							<td align="right">2,220,000</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<th>청구금액</th>
							<td align="right">2,220,000</td>
						</tr>
					</tfoot>
				</table>
				<div class="clear" style="margin-top:20px;">
					<div class="fl" style="width:39%">
						<h2>납입 정보</h2>
						<table class="tbl texInfo" style="margin-top:10px">
							<tbody>
								<tr>
									<th>은행명</th>
									<td>우리은행</td>
								</tr>
								<tr>
									<th>계좌번호</th>
									<td>1005-802-498030</td>
								</tr>
								<tr>
									<th>예금주</th>
									<td>한국동서발전(주)</td>
								</tr>
								<tr>
									<th>납입금액</th>
									<td>2,220,000원</td>
								</tr>
								<tr>
									<th>납기일</th>
									<td>2018년 08월 15일</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="fr" style="width:59%">
						<h2>고객 사항</h2>
						<table class="tbl customerInfo" style="margin-top:10px">
							<colgroup>
								<col width="40%"><col>
							</colgroup>
							<tbody>
								<tr>
									<th>고객번호</th>
									<td>10 0000 0001</td>
								</tr>
								<tr>
									<th>주소</th>
									<td>울산광역시 울주군 온산읍 원산로 40</td>
								</tr>
								<tr>
									<th>전기사용 계약종별</th>
									<td>산업용(을) 고압B 선택 III</td>
								</tr>
								
								<tr>
									<th>정기검침일</th>
									<td>25</td>
								</tr>
								<tr>
									<th>계량기번호</th>
									<td>XXX001122</td>
								</tr>
								<tr>
									<th>계량기배수</th>
									<td>1</td>
								</tr>
								<tr>
									<th>계약전력</th>
									<td>3</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<h2 style="margin-top:20px">최근 6개월 청구 내역</h2>
				<div class="inchart">
					<div id="ly_chart_hj" style="max-width:800px;height:250px"></div>
					<script language="JavaScript"> 
	// 				$(function () { 
						var myChart1 = Highcharts.chart('ly_chart_hj', {
	//  						data: {
	//  					        table: 'ly_datatable_hj' /* 테이블에서 데이터 불러오기 */
	//  					    },
	
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
						        },
								labels: {
									align: 'center',
									style: {
										color: '#3d4250',
										fontSize: '13px'
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
							            fontSize: '13px'
							        }
							    },
							    labels: {
							        overflow: 'justify',
							        x:-20, /* 그래프와의 거리 조정 */
							        style: {
							            color: '#3d4250',
							            fontSize: '13px'
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
							        fontSize: '13px',
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
						        color: '#438fd7' /* 기본요금 */
						    },{
						        color: '#13af67' /* 사용요금(역률 적용) */
						    },{
						        color: '#f75c4a' /* 전력산업기반기금 */
						    },{
						        color: '#84848f' /* 부가세 */
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
					//});
					</script>
				</div>
				<!-- 데이터 추출용 -->
				<div class="lychart_table" style="display:none;">			
					<table id="ly_datatable_hj">
					    <thead>
					        <tr>
					            <th>2018-08</th>
					            <th>기본요금</th>
					            <th>사용요금(역률적용)</th>
					            <th>전력산업기반기금</th>
					            <th>부가세</th>
					        </tr>
					    </thead>
					    <tbody>
					        <tr>
					            <th>1월</th>
					            <td>6847360</td>
					            <td>35233601</td>
					            <td>1554960</td>
					            <td>4202618</td>
					        </tr>
					        <tr>
					            <th>2월</th>
					            <td>6847360</td>
					            <td>35233601</td>
					            <td>1554960</td>
					            <td>4202618</td>
					        </tr>
					        <tr>
					            <th>3월</th>
					            <td>6847360</td>
					            <td>35233601</td>
					            <td>1554960</td>
					            <td>4202618</td>
					        </tr>
					        <tr>
					            <th>4월</th>
					            <td>6847360</td>
					            <td>35233601</td>
					            <td>1554960</td>
					            <td>4202618</td>
					        </tr>
					        <tr>
					            <th>5월</th>
					            <td>6847360</td>
					            <td>35233601</td>
					            <td>1554960</td>
					            <td>4202618</td>
					        </tr>
					        <tr>
					            <th>6월</th>
					            <td>6847360</td>
					            <td>35233601</td>
					            <td>1554960</td>
					            <td>4202618</td>
					        </tr>
					    </tbody>
					</table>			
				</div>
			</div>
    </div>
    <!-- ###### Popup End ###### -->






</body>
</html>