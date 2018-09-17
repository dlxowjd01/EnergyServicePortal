	$(document).ready(function() {
//		changeSelTerm('day'); // 화면 첫 로딩 시 검색조건 셋팅
//		getCollect_sch_condition(); // 검색조건 모으기
		
		$('#chk_CblAmtGoalPower').click(function () {
			console.log("!!!");
			chk_CblAmtGoalPower();
		});
	});
	
	var real_data_pc = new Array();; // 실제 사용량 표 데이터
	function getDBData(period, siteId, start, end) {
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getUsageRealList(period, siteId, start, end); // 실제사용량 조회
		drawData(); // 차트 및 표 그리기
	}

	// 실제 사용량
	var pastUsageList;
	function callback_getUsageRealList(result) {
		var usageList = result.list;
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totUsage = 0;
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		for(var i=0; i<usageList.length; i++) {
			var usage = String(usageList[i].usg_val);
			var substr_usage = 0;
			if(usage.length < 7) substr_usage = Number(	 usage	 ); // 나중에 수정 요망
			else substr_usage = Number(	 usage.substring( 0, usage.length-6 )	 );
			var tm = new Date(usageList[i].std_timestamp);
			// 차트데이터 셋팅
			dataSet.push([
//				Date.UTC(tm.getFullYear(), tm.getMonth(), tm.getDate(), tm.getHours(), tm.getMinutes(), tm.getSeconds()), substr_usage
				usageList[i].std_timestamp, substr_usage
			]);
			totUsage = totUsage+Number(usage);

			// 표데이터 셋팅
			dt_str += "<td>"+substr_usage+"</td>";
			if(dt_col_cnt == dt_col) {
				real_data_pc[dt_row_cnt-1] = dt_str;
				dt_row_cnt++;
				dt_col_cnt = 1;
			}
			dt_col_cnt++;
			
		}
		pastUsageList = dataSet;
		real_data_pc[dt_row_cnt-1] = dt_str;
		console.log("real_data_pc[i] aaaaa : "+real_data_pc[dt_row_cnt-1]);
		
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totUsage), "pastUseTot");
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
		
		setTickInterval();
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		
		var thead_str = "<th>2018-08</th>";
		for(var i=0; i<dt_col; i++) {
			thead_str += "<th>"+(i+1)+"</th>";
		}
		thead_str +=  "<th>합계</th>";
		
		// pc버전 테이블
		// 조회기간에 따라 테이블이 여러개 나올 수 있으므로 for문으로 돌려야 한다..(내일해내일)
		$table = $("#pc_use_dataTable");
		$table.empty(); // 초기화
		$table.append(
				$("<thead/>").append( $("<tr/>").append( thead_str ) ) // thead
		);
		$table.append(
				$("<tbody/>").append( // tbody
						$("<tr/>").append( // 실제 사용량
								'<th><div class="ctit ct1"><span>실제 사용량</span></div></th>'+real_data_pc[0]+"<td></td>"
						)
				)
		);
	}
	

	// 기준부하 및 목표사용량
	var toggle = false;
	function chk_CblAmtGoalPower() {
		if(!toggle) { // 안보일 때
			var data1 = [
				[1534798800000, 80],
				[1534799700000, 81],
				[1534800600000, 84],
				[1534801500000, 86],
				[1534802400000, 91],
				[1534803300000, 85],
				[1534804200000, 83],
				[1534805100000, 80]
			];
			var data2 = [
				[1534798800000, 84],
				[1534799700000, 85],
				[1534800600000, 88],
				[1534801500000, 90],
				[1534802400000, 95],
				[1534803300000, 89],
				[1534804200000, 87],
				[1534805100000, 84]
			];
			
			myChart.addSeries({
				id: 'goal_power',
				name: '목표사용량',
				type: 'area',
				color: '#13af67', /* 계획 사용량 */
				data: data1
				, fillOpacity: 0.3
			});
			myChart.addSeries({
				id: 'cbl_amt',
				name: '기준부하',
				type: 'line',
				color: '#f75c4a', /* 어제 사용량 */
				data: data2
			});
		} else { // 보일 때
//			myChart.series[i].options.id // 이걸로 id조회 가능
			myChart.get('cbl_amt').remove();
			myChart.get('goal_power').remove();
		}
		
		toggle = !toggle;

	}


