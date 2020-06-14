<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script src="/js/custom/worker/worker.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		$(this).scrollTop(0);
		navAddClass("energy");
		changeSelTerm('day');
		getCollect_sch_condition('worker');
	});

	function searchData() {
		drawFinishYn = false;
		forIdx = 0;
		getCollect_sch_condition('worker'); // 검색조건 모으기
	}

	var usage_head_pc = []; // 표 영역 헤더
	var real_data_pc = []; // 한전 사용량 표 데이터
	var ess_data_pc = []; //  ess 사용량 표 데이터
	var pv_data_pc = []; //  pv 사용량 표 데이터
	var total_data_pc = []; //  사용량 합계 표 데이터
	function getDBData(formData) {
		usage_head_pc.length = 0;
		real_data_pc.length = 0;
		ess_data_pc.length = 0;
		pv_data_pc.length = 0;
		total_data_pc.length = 0;

		var seriesLength = myChart.series.length;
		for (var i = seriesLength - 1; i > -1; i--) {
			myChart.series[i].remove();
		}

		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getDERUsageList(formData);
		if ( !window.Worker ) {
			drawData(); // 차트 및 표 그리기
		}
	}

	var pastUsageList; // 한전 사용량
	var essUsageList; // ess 사용량
	var pvUsageList; // pv 사용량
	var totalUsageList; // 사용량 합계

	// 사용량 구성 조회
	function getDERUsageList(formData) {
		$.ajax({
			url: "/energy/getDERUsageList.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: formData,
			success: function (result) {
				// Worker 지원 유무 확인
				if ( !!window.Worker ) {
					startWorker(result, "derUsageList");
				} else {
					var kepcoUsageSheetList = result.kepcoUsageSheetList;
					var kepcoUsageChartList = result.kepcoUsageChartList;
					var essUsageListSheetList = result.essUsageListSheetList;
					var essUsageListChartList = result.essUsageListChartList;
					var pvUsageListSheetList = result.pvUsageListSheetList;
					var pvUsageListChartList = result.pvUsageListChartList;
					var loopCntSheetList = result.loopCntSheetList; // for문 loop list
					var loopCntChartList = result.loopCntChartList; // for문 loop list
					var periodd = $("#selPeriodVal").val(); // 데이터조회간격
					var SelTerm = $("#selTerm").val(); // 데이터 범위

					// 데이터 셋팅
					var dataSet = []; // chartData를 위한 변수
					var dataSet2 = []; // chartData를 위한 변수
					var dataSet3 = []; // chartData를 위한 변수
					var totalDataSet = 0; // 전체 누적합
					var totalDataSet2 = 0;
					var totalDataSet3 = 0;
					var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
					var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
					var dt_str_head = "";
					var dt_str = "";
					var dt_str2 = "";
					var dt_str3 = "";
					var dt_str4 = ""; // 사용량 합계
					var dt_str_totalVal = 0; // 테이블 라인별 누적합
					var dt_str2_totalVal = 0; // 테이블 라인별 누적합
					var dt_str3_totalVal = 0; // 테이블 라인별 누적합
					var dt_str4_totalVal = 0; // 테이블 라인별 누적합

					// 한전사용량, ess사용량, pv사용량 중 하나라도 데이터가 존재할 때
					// 표데이터 셋팅
					var start = new Date(schStartTime.getTime());
					var end = new Date(schEndTime.getTime());
					if (!(kepcoUsageSheetList == null && essUsageListSheetList == null && pvUsageListSheetList == null)) {
						var s = start;
						var e = end;
						setHms(s, e);
						if (periodd == 'month') {
							s.setDate(1);
							s.setHours(0);
							s.setMinutes(0);
							s.setSeconds(0);
						}
						for (var i = 0; i < loopCntSheetList.length; i++) {
							dt_str_head += "<th>" + convertDataTableHeaderDate(s, 2) + "</th>";

							var kepcoUsage = null;
							var essUsage = null;
							var pvUsage = null;
							var totalUsage = null;
							var reKepcoUsage = null;
							var reEssUsage = null;
							var rePvUsage = null;
							var reTotalUsage = null;
							for (var j = 0; j < loopCntSheetList.length; j++) {
								if (s.getTime() == setSheetDateUTC(loopCntSheetList[j].std_timestamp)) {
									if (kepcoUsageSheetList != null && kepcoUsageSheetList.length > 0 && kepcoUsageSheetList.length > i) { // 한전사용량
										kepcoUsage = String(kepcoUsageSheetList[i].usg_val);
										if (kepcoUsage == null || kepcoUsage == "" || kepcoUsage == "null") reKepcoUsage = null;
										else {
											var map = convertUnitFormat(kepcoUsage, "Wh", 5);
											reKepcoUsage = toFixedNum(map.get("formatNum"), 2);
											dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
											totalUsage = totalUsage + Number(kepcoUsage);
										}

									} else reKepcoUsage = null;

									if (essUsageListSheetList != null && essUsageListSheetList.length > 0 && essUsageListSheetList.length > i) { // ESS 사용량
										essUsage = String(essUsageListSheetList[i].usg_val);
										if (essUsage == null || essUsage == "" || essUsage == "null") reEssUsage = null;
										else {
											var map = convertUnitFormat(essUsage, "Wh", 5);
											reEssUsage = toFixedNum(map.get("formatNum"), 2);
											dt_str2_totalVal = dt_str2_totalVal + Number(map.get("formatNum"));
											totalUsage = totalUsage + Number(essUsage);
										}
									} else reEssUsage = null;

									if (pvUsageListSheetList != null && pvUsageListSheetList.length > 0 && pvUsageListSheetList.length > i) { // PV 사용량
										pvUsage = String(pvUsageListSheetList[i].gen_val);
										if (pvUsage == null || pvUsage == "" || pvUsage == "null") rePvUsage = null;
										else {
											var map = convertUnitFormat(pvUsage, "Wh", 5);
											rePvUsage = toFixedNum(map.get("formatNum"), 2);
											dt_str3_totalVal = dt_str3_totalVal + Number(map.get("formatNum"));
											totalUsage = totalUsage + Number(pvUsage);
										}
									} else rePvUsage = null;

									if (totalUsage == null || totalUsage == "" || totalUsage == "null") reTotalUsage = null;
									else {
										var map = convertUnitFormat(totalUsage, "Wh", 5);
										reTotalUsage = toFixedNum(map.get("formatNum"), 2);
										dt_str4_totalVal = dt_str4_totalVal + Number(map.get("formatNum"));
									}

									break;
								}
							}
							dt_str += "<td>" + numberComma( ((reKepcoUsage == null) ? "" : reKepcoUsage) ) + "</td>"; // 한전 사용량
							dt_str2 += "<td>" + numberComma( ((reEssUsage == null) ? "" : reEssUsage) ) + "</td>"; // ess 사용량
							dt_str3 += "<td>" + numberComma( ((rePvUsage == null) ? "" : rePvUsage) ) + "</td>"; // pv 사용량
							dt_str4 += "<td>" + numberComma( ((reTotalUsage == null) ? "" : reTotalUsage) ) + "</td>"; // 사용량 합계

							var tempDate; //timestamp 에 해당하는 날짜
							var lastCol = dt_col; // 마지막 컬럼
							if(SelTerm == "year" && periodd == "day") {
								tempDate = new Date(loopCntSheetList[i].std_timestamp);
								lastCol = (new Date(tempDate.getFullYear(), tempDate.getMonth() +1, 0)).getDate();
							}
							
							if (dt_col_cnt == lastCol) {
								
								if(SelTerm == "year" && periodd == "day") {
									var restCnt = dt_col - lastCol;
									if(restCnt > 0) {
										for(var j = 0; j < restCnt; j++) {
											dt_str_head += "<th></th>";
											dt_str += "<td></td>";
											dt_str2 += "<td></td>";
											dt_str3 += "<td></td>";
											dt_str4 += "<td></td>";
										}
									}
								}
								
								var final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
								dt_str += "<td>" + numberComma(toFixedNum(dt_str_totalVal, 2)) + "</td>";
								dt_str2 += "<td>" + numberComma(toFixedNum(dt_str2_totalVal, 2)) + "</td>";
								dt_str3 += "<td>" + numberComma(toFixedNum(dt_str3_totalVal, 2)) + "</td>";
								dt_str4 += "<td>" + numberComma(toFixedNum(dt_str4_totalVal, 2)) + "</td>";
								usage_head_pc[dt_row_cnt - 1] = final_dt_str_head;
								real_data_pc[dt_row_cnt - 1] = dt_str;
								ess_data_pc[dt_row_cnt - 1] = dt_str2;
								pv_data_pc[dt_row_cnt - 1] = dt_str3;
								total_data_pc[dt_row_cnt - 1] = dt_str4;
								dt_str_head = "";
								dt_str = "";
								dt_str2 = "";
								dt_str3 = "";
								dt_str4 = "";
								dt_row_cnt++;
								dt_col_cnt = 1;
								dt_str_totalVal = 0;
								dt_str2_totalVal = 0;
								dt_str3_totalVal = 0;
								dt_str4_totalVal = 0;
							} else {
								if ((i + 1) == loopCntSheetList.length) { // 조회한 목록이 라인을 다 못채울 때
									for (a = 0; a < (dt_col - dt_col_cnt); a++) {
										dt_str += "<td></td>";
										dt_str2 += "<td></td>";
										dt_str3 += "<td></td>";
										dt_str4 += "<td></td>";
									}
									var final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
									dt_str += "<td>" + numberComma(toFixedNum(dt_str_totalVal, 2)) + "</td>";
									dt_str2 += "<td>" + numberComma(toFixedNum(dt_str2_totalVal, 2)) + "</td>";
									dt_str3 += "<td>" + numberComma(toFixedNum(dt_str3_totalVal, 2)) + "</td>";
									dt_str4 += "<td>" + numberComma(toFixedNum(dt_str4_totalVal, 2)) + "</td>";
									usage_head_pc[dt_row_cnt - 1] = final_dt_str_head;
									real_data_pc[dt_row_cnt - 1] = dt_str;
									ess_data_pc[dt_row_cnt - 1] = dt_str2;
									pv_data_pc[dt_row_cnt - 1] = dt_str3;
									total_data_pc[dt_row_cnt - 1] = dt_str4;
									dt_str_head = "";
									dt_str = "";
									dt_str2 = "";
									dt_str3 = "";
									dt_str4 = "";
									dt_str_totalVal = 0;
									dt_str2_totalVal = 0;
									dt_str3_totalVal = 0;
									dt_str4_totalVal = 0;
								} else {
									dt_col_cnt++;
								}
							}

							s = incrementTime(s);

						}

					}

					// 한전사용량, ess사용량, pv사용량 중 하나라도 데이터가 존재할 때
					// 차트데이터 셋팅
					if (!(kepcoUsageChartList == null && essUsageListChartList == null && pvUsageListChartList == null)) {
						for (var i = 0; i < loopCntChartList.length; i++) {
							var kepcoUsage = null;
							var essUsage = null;
							var pvUsage = null;
							var reKepcoUsage = 0;
							var reEssUsage = 0;
							var rePvUsage = 0;

							if (kepcoUsageChartList != null && kepcoUsageChartList.length > 0 && kepcoUsageChartList.length > i) { // 한전사용량
								kepcoUsage = String(kepcoUsageChartList[i].usg_val);
								if (kepcoUsage == null || kepcoUsage == "" || kepcoUsage == "null") reKepcoUsage = null;
								else {
									var map = convertUnitFormat(kepcoUsage, "Wh", 5);
									reKepcoUsage = toFixedNum(map.get("formatNum"), 2);
									totalDataSet = totalDataSet + Number(kepcoUsage);
								}

							} else reKepcoUsage = null;

							if (essUsageListChartList != null && essUsageListChartList.length > 0 && essUsageListChartList.length > i) { // ESS 사용량
								essUsage = String(essUsageListChartList[i].usg_val);
								if (essUsage == null || essUsage == "" || essUsage == "null") reEssUsage = null;
								else {
									var map = convertUnitFormat(essUsage, "Wh", 5);
									reEssUsage = toFixedNum(map.get("formatNum"), 2);
									totalDataSet2 = totalDataSet2 + Number(essUsage);
								}
							} else reEssUsage = null;

							if (pvUsageListChartList != null && pvUsageListChartList.length > 0 && pvUsageListChartList.length > i) { // PV 사용량
								pvUsage = String(pvUsageListChartList[i].gen_val);
								if (pvUsage == null || pvUsage == "" || pvUsage == "null") rePvUsage = null;
								else {
									var map = convertUnitFormat(pvUsage, "Wh", 5);
									rePvUsage = toFixedNum(map.get("formatNum"), 2);
									totalDataSet3 = totalDataSet3 + Number(pvUsage);
								}
							} else rePvUsage = null;

							var chartEssUsage = null;
							var chartPvUsage = null;
							chartEssUsage = toFixedNum(reEssUsage, 2);
							chartPvUsage = toFixedNum(rePvUsage, 2);

							// 차트데이터 셋팅
							dataSet.push([setChartDateUTC(loopCntChartList[i].std_timestamp), reKepcoUsage]);
							dataSet2.push([setChartDateUTC(loopCntChartList[i].std_timestamp), chartEssUsage]);
							dataSet3.push([setChartDateUTC(loopCntChartList[i].std_timestamp), chartPvUsage]);

						}
						pastUsageList = dataSet;
						essUsageList = dataSet2;
						pvUsageList = dataSet3;

						if (kepcoUsageChartList != null && kepcoUsageChartList.length > 0) {
							myChart.addSeries({
								index: 3,
								fillOpacity: 0,
								name: '한전 사용량',
								color: '#438fd7',
								lineColor: '#438fd7', /* 한전 사용량 */
								data: pastUsageList
							}, false);

						}

						if (essUsageListChartList != null && essUsageListChartList.length > 0) {
							myChart.addSeries({
								index: 2,
								fillOpacity: 0.5,
								name: 'ESS 사용량',
								color: '#13af67', /* ESS 사용량 */
								data: essUsageList
							}, false);

						}

						if (pvUsageListChartList != null && pvUsageListChartList.length > 0) {
							myChart.addSeries({
								index: 1,
								fillOpacity: 0.5,
								name: 'PV 사용량',
								color: '#f75c4a', /* PV 사용량 */
								data: pvUsageList
							}, false);

						}

					}

					// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
					unit_format(String(totalDataSet), "usageTotal", "Wh");
					unit_format(String(totalDataSet2), "essUsageTotal", "Wh");
					unit_format(String(totalDataSet3), "pvUsageTotal", "Wh");

					var total = totalDataSet + totalDataSet2 + totalDataSet3;
					$("#kepcoPer").empty().append("한전 사용").append($("<span />").append(((totalDataSet == 0) ? 0 : ((totalDataSet / total) * 100).toFixed(2)) + "%"));
					$("#essPer").empty().append("ESS 사용").append($("<span />").append(((totalDataSet2 == 0) ? 0 : ((totalDataSet2 / total) * 100).toFixed(2)) + "%"));
					$("#pvPer").empty().append("PV 사용").append($("<span />").append(((totalDataSet3 == 0) ? 0 : ((totalDataSet3 / total) * 100).toFixed(2)) + "%"));
				}
			}
		});
	}

	// 차트 그리기
	function drawData_chart() {
		setTickInterval();

		myChart.redraw(); // 차트 데이터를 다시 그린다
	}

	// 표(테이블) 그리기
	var forIdx = 0;
	var drawFinishYn = false;
	function drawData_table() {
		$chart = $(".cusage_chart");
		var tbodyStr = '';
		var $targetDiv = $("#pc_use_dataDiv");
		if(forIdx == 0) $targetDiv.empty();
		if(drawFinishYn == false) {
			if (real_data_pc.length > 0) {
				$chart.find(".inchart-nodata").css("display", "none");
				$chart.find(".inchart").css("display", "");
				var loopCnt = 1;
				for (var i = forIdx; i < dt_row; i++) {
					tbodyStr += drawTable(i);

					if((i+1) == dt_row) drawFinishYn = true;
					forIdx++;
					if(loopCnt == 2) break;
					loopCnt++;
				}
				$targetDiv.append(tbodyStr);

			} else {
				$chart.find(".inchart-nodata").css("display", "");
				$chart.find(".inchart").css("display", "none");
				tbodyStr += '<div class="chart_table"><table class="pc_use"><thead><tr>';
				tbodyStr += '<th width="33%"></th><td width="34%">조회 결과가 없습니다.</td><th width="33%"></th>';
				tbodyStr += '</tr></thead></table></div>';
				
				$targetDiv.append(tbodyStr);
				drawFinishYn = true;
				forIdx = -1;
			}
		}

// 				$("#pc_use_dataDiv").html(tbodyStr);
	}

	function drawTable(i) {
		var tbodyStr = '';
		tbodyStr += '<div class="chart_table">';
		tbodyStr += '<table class="pc_use">';
		tbodyStr += '<thead>';
		tbodyStr += '<tr>';
		tbodyStr += usage_head_pc[i] + '<th>합계</th>';
		tbodyStr += '</tr>';
		tbodyStr += '</thead>';
		tbodyStr += '<tbody>';
		tbodyStr += '<tr>';
		tbodyStr += '<th><div class="ctit ct1"><span>한전 사용량 (kWh)</span></div></th>' + real_data_pc[i];
		tbodyStr += '</tr>';
		tbodyStr += '<tr>';
		tbodyStr += '<th><div class="ctit ct2"><span>ESS 사용량 (kWh)</span></div></th>' + ess_data_pc[i];
		tbodyStr += '</tr>';
		tbodyStr += '<tr>';
		tbodyStr += '<th><div class="ctit ct3"><span>PV 사용량 (kWh)</span></div></th>' + pv_data_pc[i];
		tbodyStr += '</tr>';
		tbodyStr += '<tr>';
		tbodyStr += '<th><div class="ctit"><span>사용량 합계 (kWh)</span></div></th>' + total_data_pc[i];
		tbodyStr += '</tr>';
		tbodyStr += '</tbody>';
		tbodyStr += '</table>';
		tbodyStr += '</div>';
		return tbodyStr;
	}
	
	function drawExcelTable() {
		var tbodyStr = '';
		for (var i = 0; i < dt_row; i++) {
			tbodyStr += drawTable(i);
		}
		$("#excel_dataDiv").html(tbodyStr);
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">사용량 구성</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-2">
		<div class="indiv fixed_height">
			<h2 class="ntit">사용량 구성 합계</h2>
			<ul class="chart_total">
				<li class="pk1">
					<div class="ctit pk1"><span>한전 사용량</span></div>
					<div class="cval" id="usageTotal"><span>0</span>kWh</div>
				</li>
				<li class="pk2">
					<div class="ctit pk2"><span>ESS 사용량</span></div>
					<div class="cval" id="essUsageTotal"><span>0</span>kWh</div>
				</li>
				<li class="pk3">
					<div class="ctit pk3"><span>PV 사용량</span></div>
					<div class="cval" id="pvUsageTotal"><span>0</span>kWh</div>
				</li>
			</ul>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="indiv cusage_chart">
			<c:set var="schGbn" value="energy" />
			<%@ include file="/decorators/include/searchRequirement.jsp"%>
			<div class="inchart-nodata" style="display: none;">
				<span>조회 결과가 없습니다.</span>
			</div>
			<div class="inchart">
				<div class="chart_type">
					<a href="#;" class="chart_change_line" style="display:none;">그래프변경</a>
				</div>
				<div id="chart2"></div>
				<script language="JavaScript">
					var myChart = Highcharts.chart('chart2', {
						chart: {
							marginLeft: 80,
							marginRight: 0,
							backgroundColor: 'transparent',
							type: 'area'
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
								formatter: function() {
									var label = this.axis.defaultLabelFormatter.call(this);
									if(this.axis.tickPositions.info.unitName =="hour") {
										this.dateTimeLabelFormat = '%H';
										label = this.axis.defaultLabelFormatter.call(this);
									} else if(this.axis.tickPositions.info.unitName =="minute") {
										this.dateTimeLabelFormat = '%H:%M';
										label = this.axis.defaultLabelFormatter.call(this);
									}
									return label;
								},
								align: 'center',
								style: {
									color: '#3d4250',
									fontSize: '18px'
								}
							},
							tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
							title: {
								text: null
							},
							/* 기준선 */
							plotLines: [{
								value: 9, /* 현재 */
								color: '#438fd7',
								width: 2,
								zIndex: 0,
								label: {
									text: ''
								}
							}]
							, crosshair: true // 08.22 이우람 추가
						},

						yAxis: {
							gridZIndex: 4, // 09.10 이우람 추가
							gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
							min: 0, /* 최소값 지정 */
							title: {
								text: '(kWh/time)',
								align: 'low',
								rotation: 0, /* 타이틀 기울기 */
								y: 45, /* 타이틀 위치 조정 */
								x: 5, /* 타이틀 위치 조정 */
								style: {
									color: '#3d4250',
									fontSize: '18px'
								}
							},
							labels: {
								overflow: 'justify',
								x: -20, /* 그래프와의 거리 조정 */
								style: {
									color: '#3d4250',
									fontSize: '18px'
								}
							}
						},

						/* 범례 */
						legend: {
							enabled: true,
							align: 'right',
							verticalAlign: 'top',
							x: -120,
							itemStyle: {
								color: '#3d4250',
								fontSize: '16px',
								fontWeight: 400
							},
							itemHoverStyle: {
								color: '' /* 마우스 오버시 색 */
							},
							symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
							symbolHeight: 8 /* 심볼 크기 */
						},

						/* 툴팁 */
						tooltip: {
							formatter: function () {
								return '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x))
									+ '<br/><span style="color:#438fd7">' + numberComma(this.y) + ' kWh</span>';
							}
						},

						/* 옵션 */
						plotOptions: {
							area: {
								stacking: 'normal',
							},
							series: {
								label: {
									connectorAllowed: false
								},
								marker: {
									enabled: false
								}, // 09.11 이우람 추가
								borderWidth: 0 /* 보더 0 */
							},
							line: {
								marker: {
									enabled: false /* 마커 안보이기 */
								}
							}
						},

						/* 출처 */
						credits: {
							enabled: false
						},

						/* 그래프 스타일 */
						series: [{
							name: 'PV 사용량',
							color: '#f75c4a' /* PV 사용량 */
						}, {
							name: 'ESS 사용량',
							color: '#13af67' /* ESS 사용량 */
						}, {
							name: '한전 사용량',
							color: '#438fd7' /* 한전 사용량 */
						}],

						/* 반응형 */
						responsive: {
							rules: [{
								condition: {
									maxWidth: 414 /* 차트 사이즈 */
								},
								chartOptions: {
									chart: {
										marginLeft: 60,
										marginTop: 80
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
											x: -10, /* 그래프와의 거리 조정 */
											style: {
												fontSize: '13px'
											}
										}
									},
									legend: {
										layout: 'horizontal',
										verticalAlign: 'bottom',
										align: 'center',
										x: 0,
										itemStyle: {
											fontSize: '13px'
										}
									}
								}
							}]
						}

					});

					/* 차트 변경 */
					$(function () {
						$('.chart_change_column').click(function () {
							$(this).hide();
							$('.chart_change_line').show();
							myChart.series[0].update({
								type: "column"
							});

						});
						$('.chart_change_line').click(function () {
							$(this).hide();
							$('.chart_change_column').show();
							myChart.series[0].update({
								type: "line"
							});

						});
					});
				</script>
			</div>	
		</div>
	</div>
</div>
<div class="row usage_chart_table">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="tbl_top clear">
				<h2 class="ntit fl">사용량 구성 도표</h2>
				<ul class="fr">
					<li><div class="hl_tot_per" id="kepcoPer">한전 사용 <span>0%</span></div></li>
					<li><div class="tot_per" id="essPer">ESS 사용 <span>0%</span></div></li>
					<li><div class="tot_per" id="pvPer">PV 사용 <span>0%</span></div></li>
					<!-- <li><a href="#;" class="save_btn" onclick="excelDownload('사용량구성', event);">데이터저장</a></li> -->
					<li><a href="#;" class="save_btn" onclick="exportExcel('사용량구성');">데이터저장</a></li>
					<li><a href="#;" class="fold_btn">표접기</a></li>
				</ul>
			</div>
			<div class="tbl_wrap">
				<div class="fold_div" id="pc_use_dataDiv">
				</div>
				<div class="fold_div" id="excel_dataDiv" style="display: none;">
				</div>
			</div>
		</div>
	</div>
</div>