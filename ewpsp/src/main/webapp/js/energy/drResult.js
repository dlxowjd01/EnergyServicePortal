	$(document).ready(function() {
		changeSelTerm('drday'); // 화면 첫 로딩 시 검색조건 셋팅
		getCollect_sch_condition(); // 검색조건 모으기

		$("#check1").click(function () {
			var flag = $("#check1").prop("checked") ;
			if(flag) {
				changeSelTerm('drday');
				getCollect_sch_condition();
				
				if(realTimeRefresh == null) { // 1분 간격
					realTimeRefresh = setInterval(function(){
						changeSelTerm('day');
						getCollect_sch_condition();
					},5000); // 1000 = 1초, 5000 = 5초
				} else {
					alert("이미 실시간 자동갱신이 실행중입니다.");
				}
				
			} else {
				clearInterval(realTimeRefresh);
				realTimeRefresh = null;
			}
			
		});
	});
	
	function searchData() {
		var cblAmtHourFrom = $("#cblAmtHourFrom").val();
		var cblAmtHourTo = $("#cblAmtHourTo").val();
		var cblAmtGapTime = Number(cblAmtHourTo)-Number(cblAmtHourFrom);
		
		if( cblAmtGapTime < 0) {
			alert("조회할수 없는 시간대입니다.");
			return;
		} else if( cblAmtGapTime > 3) {
			alert("최대 4시간까지 조회 가능합니다.");
			return;
		} else {
			
		}
		
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
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
		var sheetList = result.sheetList;
		var chartList = result.chartList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수(기준부하)
		var dataSet3 = []; // chartData를 위한 변수(목표사용량)
		var totUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totVal = 0; // 테이블 라인별 누적합
		if(chartList != null && chartList.length > 0) {
			$(".dr_chart").find(".inchart-nodata").css("display", "none");
			$(".dr_chart").find(".inchart").css("display", "");
			for(var i=0; i<chartList.length; i++) {
				var usage = String(chartList[i].usg_val);
				var reUsage = 0;
				if(usage == null || usage == "" || usage == "null") {
					reUsage = null;
				} else {
					var map = convertUnitFormat(usage, "mWh", 8);
					reUsage = Math.round( Number(map.get("formatNum")) );
					totUsage = totUsage+Number(usage);
				}
				
//				var tm = new Date( convertDateUTC(chartList[i].std_timestamp) );
				// 차트데이터 셋팅
				dataSet.push([ setChartDateUTC(chartList[i].std_timestamp), reUsage ]);
				
				var tm = new Date( setChartDateUTC(chartList[i].std_timestamp) );
				if( tm.getHours()>=$("#cblAmtHourFrom").val() && tm.getHours()<=$("#cblAmtHourTo").val() ) {
					dataSet2.push([ setChartDateUTC(chartList[i].std_timestamp), cblAmt ]);
					dataSet3.push([ setChartDateUTC(chartList[i].std_timestamp), goalPower ]);
				}
				
			}
			
		} else {
			$(".dr_chart").find(".inchart-nodata").css("display", "");
			$(".dr_chart").find(".inchart").css("display", "none");
		}
		pastUsageList = dataSet;
		timeSlotCblAmtList = dataSet2;
		timeSlotGoalPowerList = dataSet3;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)		
		unit_format(String(totUsage), "pastUseTot", "Wh");
	}
	
	// 표 데이터
	function callback_getDRResultList(result) {
		var drList = result.list;
		var totalReduceAmt = 0; // 전체 누적합
		
		$tbody = $("#drResultTbody");
		$tbody.empty();
		if(drList == null || drList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
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
	
	
