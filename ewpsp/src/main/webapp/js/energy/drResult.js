	$(document).ready(function() {
		changeSelTerm('day'); // 화면 첫 로딩 시 검색조건 셋팅
		getCollect_sch_condition(); // 검색조건 모으기
		
	});
	
	var real_data_pc = new Array(); // 실제 사용량 표 데이터
	function getDBData(formData) {
		real_data_pc.length = 0;
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getCblAmt();
		getUsageRealList(formData); // 실제사용량 조회
		drawData_chart();
		getDRResultList(formData);
//		drawData(); // 차트 및 표 그리기
	}
	
	var cblAmt; // 기준부하
	var goalPower; // 목표사용량=기준부하-계약용량(한전계약전력)
	var contractPower;
	function getCblAmt() {
		getSiteSetDetail();
		cblAmt = 18000;
		goalPower = cblAmt-contractPower;
	}
	
	function callback_getSiteSetDetail(result) {
		var siteSetDetail = result.detail;
		contractPower = siteSetDetail.contract_power;
//		chargePower = siteSetDetail.charge_power;
	}

	// 실제 사용량
	var pastUsageList;
	var timeSlotCblAmtList;
	var timeSlotGoalPowerList;
	function callback_getUsageRealList(result) {
		var usageList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수(기준부하)
		var dataSet3 = []; // chartData를 위한 변수(목표사용량)
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totVal = 0; // 테이블 라인별 누적합
		if(usageList.length > 0) {
			for(var i=0; i<usageList.length; i++) {
				var usage = String(usageList[i].usg_val);
				var substr_usage = 0;
				if(usage == null || usage == "" || usage == "null") {
					substr_usage = null;
				} else {
					if(usage.length < 7) substr_usage = Number(     usage     ); // 나중에 수정 요망
					else substr_usage = Number(     usage.substring( 0, usage.length-6 )     );
					totUsage = totUsage+Number(usage);
				}
				
				var tm = new Date( convertDateUTC(usageList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push([ //Number(usageList[i].std_timestamp)
//					Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
					setChartDateUTC(usageList[i].std_timestamp)
					, substr_usage
				]);
				
				if( tm.getHours()>=$("#cblAmtHourFrom").val() && tm.getHours()<=$("#cblAmtHourTo").val() ) {
					dataSet2.push([ //Number(usageList[i].std_timestamp)
//						Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
						setChartDateUTC(usageList[i].std_timestamp)
						, cblAmt
					]);
					dataSet3.push([ //Number(usageList[i].std_timestamp)
//						Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds())
						setChartDateUTC(usageList[i].std_timestamp)
						, goalPower
						]);
				}
				
			}
			
		}
		pastUsageList = dataSet;
		timeSlotCblAmtList = dataSet2;
		timeSlotGoalPowerList = dataSet3;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "pastUseTot", "Wh");
	}
	
	function callback_getDRResultList(result) {
		var drList = result.list;
		var totalReduceAmt = 0; // 전체 누적합
		
		$tbody = $("#drResultTbody");
		$tbody.empty();
		if(drList == null || drList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회된 데이터가 없습니다.</td><tr>' );
		} else {
			for(var i=0; i<drList.length; i++) {
				var drStartDate = new Date( convertDateUTC(drList[i].start_timestamp) );
				var drEndDate = new Date( convertDateUTC(drList[i].end_timestamp) );
				$tbody.append(
						$('<tr />').append( $("<td />").append( drStartDate.format("yyyy-MM-dd") ) // 감축일
						).append( $("<td />").append( drStartDate.format("HH:mm")+" ~ "+drEndDate.format("HH:mm") ) // 감축시간대
						).append( $("<td />").append( drList[i].act_amt ) // 사용량
						).append( $("<td />").append( drList[i].cbl_amt ) // 고객기준부하
						).append( $("<td />").append( drList[i].cbl_power ) // 계약용량
						).append( $("<td />").append( drList[i].goal_power ) // 목표사용량
						).append( $("<td />").append( drList[i].reduce_amt ) // 감축량
						).append( $("<td />").append( drList[i].fulfill_per ) // 이행률
						)
				);
				console.log("drList[i].reduce_amt : "+drList[i].reduce_amt);
				totalReduceAmt = totalReduceAmt+Number( String(drList[i].reduce_amt) );
			}
			console.log("totalReduceAmt : "+totalReduceAmt);
			
		}

		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalReduceAmt), "totalReduceAmt", "Wh");
		
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '실제 사용량',
			color: '#438fd7',
			data: pastUsageList
		}, false);
		
		myChart.addSeries({
			name: '기준부하',
			color: '#438fd7',
			data: timeSlotCblAmtList
		}, false);
		
		myChart.addSeries({
			name: '목표사용량',
			color: '#438fd7',
			type: 'area',
			fillOpacity: 0.3,
			data: timeSlotGoalPowerList
		}, false);
		
		setTickInterval();
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	
