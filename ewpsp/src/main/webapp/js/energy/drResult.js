	$(document).ready(function() {
		changeSelTerm('drday'); // 화면 첫 로딩 시 검색조건 셋팅
		getCollect_sch_condition(); // 검색조건 모으기

		// 실시간 갱신
		$("#check1").click(function () {
			var flag = $("#check1").prop("checked") ;
			if(flag) {
				changeSelTerm('drday');
//				realTimeRefreshFn();
				getCollect_sch_condition();
				
				if(realTimeRefresh == null) { // 1분 간격
					realTimeRefresh = setInterval(function(){
//						realTimeRefreshFn();
						getCollect_sch_condition();
					},1000*10); // 1000 = 1초, 5000 = 5초
				} else {
					alert("이미 실시간 자동갱신이 실행중입니다.");
				}
				
			} else {
				clearInterval(realTimeRefresh);
				realTimeRefresh = null;
			}
			
		});
	});
	
	// 검색버튼 클릭
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
		}
		
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
	// 실시간 갱신 체크박스
	function realTimeRefreshFn() {
		var firstDay = new Date();
		var endDay = new Date();
		var startTime;
		var endTime;
		if(SelTerm == 'drday') { // 에너지모니터링 dr실적조회의 오늘날짜
			startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), 0, 0, 0);
			endTime = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), 23, 59, 59);
		} else if(SelTerm == 'selectDay') { // 에너지모니터링 dr실적조회의 날짜검색
			startTime = new Date( $dtpk5.val()+" 00:00:00" );
			endTime = new Date( $dtpk5.val()+" 23:59:59" );
			$("#dtCnt").val(  dateDiff($dtpk5.val()+" 00:00:00", $dtpk5.val()+" 23:59:59")+1  );
		}
		schStartTime = new Date(startTime.getTime());
		schEndTime = new Date(endTime.getTime());
		
		var queryStart = new Date(startTime.setMinutes(startTime.getMinutes() + (new Date()).getTimezoneOffset()));
		var queryEnd = new Date(endTime.setMinutes(endTime.getMinutes() + (new Date()).getTimezoneOffset()));
		
		queryStart = (queryStart == "") ? "" : queryStart.format("yyyyMMddHHmmss");
		queryEnd = (queryEnd == "") ? "" : queryEnd.format("yyyyMMddHHmmss");
		$("#selTermFrom").val(queryStart);
		$("#selTermTo").val(queryEnd);
		
		var formData = $("#schForm").serializeObject();
		
		searchDRApi(formData);
	}
	
	function searchDRApi(formData) {
		$.ajax({
			url : "/searchDRApi",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var today = new Date();
				update_updtDataTime(today, "updtTime"); // 검색시간(차트 새로고침시간) 업데이트
				
				refreshChartData(result);
				drawData_chart();
				refreshSheetData(result);
			}
		});
		
	}
	
	var real_data_pc = new Array(); // 실제 사용량 표 데이터
	function getDBData(formData) {
		real_data_pc.length = 0;
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getCblAmt();
		getUsageRealList(formData); // 실제사용량 조회
		drawData_chart();
		getDRResultList(formData);
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

	// 검색결과 그래프 데이터
	var pastUsageList;
	var timeSlotCblAmtList;
	var timeSlotGoalPowerList;
	function callback_getUsageRealList(result) {
		var chartList = result.chartList;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수(기준부하)
		var dataSet3 = []; // chartData를 위한 변수(목표사용량)
		var totUsage = 0; // 전체 누적합
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
				var hour = new Date(chartList[i].std_timestamp).getHours();
				if( hour>=$("#cblAmtHourFrom").val() && hour<=$("#cblAmtHourTo").val() ) {
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
		unit_format(String(totUsage), "pastUseTot", "mWh");
	}
	
	// 검색결과 표 데이터
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
	

	// 실시간 갱신 그래프 데이터
	function refreshChartData(result) {
		var chartList = result.chartList;
		var cbl = result.cbl;
		if(cbl != null) {
			getSiteSetDetail();
			cblAmt = cbl.cbl;
			goalPower = cblAmt-contractPower;
		}
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var dataSet2 = []; // chartData를 위한 변수(기준부하)
		var dataSet3 = []; // chartData를 위한 변수(목표사용량)
		var totUsage = 0; // 전체 누적합
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
				
				if(cbl != null) {
					var tm = new Date( setChartDateUTC(chartList[i].std_timestamp) );
					var hour = new Date(chartList[i].std_timestamp).getHours();
					if( hour>=$("#cblAmtHourFrom").val() && hour<=$("#cblAmtHourTo").val() ) {
						dataSet2.push([ setChartDateUTC(chartList[i].std_timestamp), cblAmt ]);
						dataSet3.push([ setChartDateUTC(chartList[i].std_timestamp), goalPower ]);
					}
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
		unit_format(String(totUsage), "pastUseTot", "mWh");
	}
	
	// 실시간 갱신 표 데이터
	function refreshSheetData(result) {
		var drList = result.drResultList;
		var siteSet = result.siteSet;
		var totalReduceAmt = 0; // 전체 누적합
		
		$tbody = $("#drResultTbody");
		$tbody.empty();
		if(drList == null || drList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
		} else {
			for(var i=0; i<drList.length; i++) {
				var drStartDate = new Date( drList[i].request.start );
				var drEndDate = new Date( drList[i].request.end );
				$tbody.append(
						$('<tr />').append( $("<td />").append( drStartDate.format("yyyy-MM-dd") ) // 감축일
						).append( $("<td />").append( drStartDate.format("HH:mm")+" ~ "+drEndDate.format("HH:mm") ) // 감축시간대
						).append( $("<td />").append( drList[i].actualAmount ) // 사용량
						).append( $("<td />").append( drList[i].cblAmount ) // 고객기준부하
						).append( $("<td />").append( drList[i].cblAmount-goalPower ) // 계약용량
						).append( $("<td />").append( goalPower ) // 목표사용량
						).append( $("<td />").append( drList[i].cblAmount - drList[i].actualAmount ) // 감축량
						).append( $("<td />").append( (drList[i].cblAmount - drList[i].actualAmount)/(drList[i].cblAmount-goalPower) ) // 이행률
						)
				);
				console.log("drList[i].reduce_amt : "+drList[i].reduce_amt);
				totalReduceAmt = totalReduceAmt+Number( drList[i].cblAmount - drList[i].actualAmount );
			}
			
		}
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalReduceAmt), "totalReduceAmt", "Wh");
		
	}
