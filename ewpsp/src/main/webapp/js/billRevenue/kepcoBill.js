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
		texDay = new Date(texDay.setMonth(firstDay.getMonth()-2));
		$("#selTermTex").val(texDay.format('yyyyMM'));
		$("#selTermTo").val( endDay.format("yyyyMM") );
		$("#selTermFrom").val( agoDay.format("yyyyMM") );
		formData = $("#schForm").serializeObject();
		getSiteSetDetail(formData);
		getKepcoTexBillList(formData);
	});
	
	var custNum = "";		//고객번호
	var meterNum = "";		//계량기 번호
	var meterSf = "";		//계량기 배수
	var profitRatio = "";		//수익배분 비율
	var meterReadDay = "";		//검침일
	var contractPower = "";		//계약전력
	var planType = "";
	var planType2 = "";
	var planType3 = "";
	
	
	/*function callback_getSiteSetDetail(result){
		
		var site = result.detail;
		custNum = site.cust_num;		//고객번호
		meterNum = site.meter_num;		//계량기 번호
		meterSf = site.meter_sf;		//계량기 배수
		profitRatio = site.profit_ratio;		//수익배분 비율
		meterReadDay = site.meter_read_day;		//검침일
		contractPower = site.contract_power;		//계약전력
		planType = site.plan_type;		//구분1
		planType2 = site.plan_type2;		//구분2
		planType3 = site.plan_type3;		//구분3
		baseRate = 0;
		
		if(planType == "general"){
			if(planType2 == "A1"){
				if(planType3 == "low_voltage_A"){
					baseRate = 6160;
				}else if(planType3 == "high_voltage_A_option1"){
					baseRate = 7170;
				}else if(planType3 == "high_voltage_A_option2"){
					baseRate = 8230;
				}else if(planType3 == "high_voltage_B_option1"){
					baseRate = 7170;
				}else if(planType3 == "high_voltage_B_option2"){
					baseRate = 8230;
				}
			}else if(planType2 == "A2"){
				if(planType3 == "high_voltage_A_option1"){
					baseRate = 7170;
				}else if(planType3 == "high_voltage_A_option2"){
					baseRate = 8230;
				}else if(planType3 == "high_voltage_B_option1"){
					baseRate = 7170;
				}else if(planType3 == "high_voltage_B_option2"){
					baseRate = 8230;
				}
				
			}else if(planType2 =="B"){
				if(planType3 == "high_voltage_A_option1"){
					baseRate = 7220;
				}else if(planType3 == "high_voltage_A_option2"){
					baseRate = 8320;
				}else if(planType3 == "high_voltage_A_option3"){
					baseRate = 9810;
				}else if(planType3 == "high_voltage_B_option1"){
					baseRate = 6630;
				}else if(planType3 == "high_voltage_B_option2"){
					baseRate = 7380;
				}else if(planType3 == "high_voltage_B_option3"){
					baseRate = 8190;
				}else if(planType3 == "high_voltage_C_option1"){
					baseRate = 6590;
				}else if(planType3 == "high_voltage_C_option2"){
					baseRate = 7520;
				}else if(planType3 == "high_voltage_C_option3"){
					baseRate = 8090;
				}
				
			}
			
		}else if(planType == "industrial"){
			if(planType2 == "A1"){
				if(planType3 == "low_voltage_A"){
					baseRate = 5550;
				}else if(planType3 == "high_voltage_A_option1"){
					baseRate = 6490;
				}else if(planType3 == "high_voltage_A_option2"){
					baseRate = 7470;
				}else if(planType3 == "high_voltage_B_option1"){
					baseRate = 6000;
				}else if(planType3 == "high_voltage_B_option2"){
					baseRate = 6900;
				}
			}else if(planType2 == "A2"){
				if(planType3 == "high_voltage_A_option1"){
					baseRate = 6490;
				}else if(planType3 == "high_voltage_A_option2"){
					baseRate = 7470;
				}else if(planType3 == "high_voltage_B_option1"){
					baseRate = 6000;
				}else if(planType3 == "high_voltage_B_option2"){
					baseRate = 6900;
				}
			}else if(planType2 =="B"){
				if(planType3 == "high_voltage_A_option1"){
					baseRate = 7220;
				}else if(planType3 == "high_voltage_A_option2"){
					baseRate = 8320;
				}else if(planType3 == "high_voltage_A_option3"){
					baseRate = 9810;
				}else if(planType3 == "high_voltage_B_option1"){
					baseRate = 6630;
				}else if(planType3 == "high_voltage_B_option2"){
					baseRate = 7380;
				}else if(planType3 == "high_voltage_B_option3"){
					baseRate = 8190;
				}else if(planType3 == "high_voltage_C_option1"){
					baseRate = 6590;
				}else if(planType3 == "high_voltage_C_option2"){
					baseRate = 7520;
				}else if(planType3 == "high_voltage_C_option3"){
					baseRate = 8090;
				}
			
			}
		
		}
	}*/

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
//		var formData = $("#schForm").serializeObject();
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
	
	function callback_getKepcoTexBillList(result) {
		var texList = result.texList;
		var chartList = result.chartList;
		var yyyyMM = texList[0].bill_yearm;
		var tatalTex = texList[0].tot_elec_rate+texList[0].val_add_tax+texList[0].elec_fund;
		var texStr = "";
		var texFoodStr = "";
		var customerStr = "";
		var texInfoStr = "";
		var datatable = "";
		var str11 = "";
		
		if(texList.length > 0){
			var delLastWon = Math.floor(tatalTex/10)*10-tatalTex;
			$("#texArea").find("tbody").empty();
			$("#texArea").find("tfoot").empty();
			
			$("#texBill").text("전기 요금 청구서 ("+yyyyMM.substring(2,4)+"년"+yyyyMM.substring(4,6)+"월)");
			$("#texDay").text("청구일 : "+yyyyMM.substring(0,4)+"-"+yyyyMM.substring(4,6)+"-"+"20");
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
			texInfoStr +="<td>"+yyyyMM.substring(0, 4)+"년"+yyyyMM.substring(4, 6)+"월"+meterReadDay+"일</td>";
			texInfoStr +="</tr>";
			
			
			customerStr +="<tr>";
			customerStr +="<th>고객번호</th>";
			customerStr +="<td>"+custNum+"</td>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>주소</th>";
			customerStr +="<td>울산광역시 울주군 온산읍 원산로 40</td>";
			customerStr +="</tr>";
			customerStr +="</tr>";
			customerStr +="<tr>";
			customerStr +="<th>전기사용 계약종별</th>";
			customerStr +="<td>산업용(을) 고압B 선택 III</td>";
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
		
//		setTickInterval();
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
					totUsage = totUsage+Number(sheetList[i].base_rate);
				}
				if(pwrFactorRate == null || pwrFactorRate == "" || pwrFactorRate == "null") rePwrFactorRate = null;
				else rePwrFactorRate = Math.round( Number(pwrFactorRate) );
				if(consumeRate == null || consumeRate == "" || consumeRate == "null") reConsumeRate = null;
				else {
					reConsumeRate = Math.round( Number(consumeRate) );
					totUsage2 = totUsage2+Number(String(sheetList[i].consume_rate));
				}
				if(totElecRate == null || totElecRate == "" || totElecRate == "null") reTotElecRate = null;
				else reTotElecRate = Math.round( Number(totElecRate) );
				if(elecFund == null || elecFund == "" || elecFund == "null") reElecFund = null;
				else {
					reElecFund = Math.round( Number(elecFund) );
					totUsage3 = totUsage3+Number(String(sheetList[i].elec_fund));
				}
				if(valAddTax == null || valAddTax == "" || valAddTax == "null") reValAddTax = null;
				else {
					reValAddTax = Math.round( Number(valAddTax) );
					totUsage4 = totUsage4+Number(String(sheetList[i].val_add_tax));
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