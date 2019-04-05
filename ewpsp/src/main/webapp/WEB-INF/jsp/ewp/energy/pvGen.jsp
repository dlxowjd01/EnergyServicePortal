<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<script type="text/javascript">
	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
	function searchData() {
		getCollect_sch_condition(); // 검색조건 모으기
	}
	
	var pv_head_pc = new Array(); // 실제 사용량 표 데이터
	var real_data_pc = new Array(); // 실제 발전량 표 데이터
	var feture_data_pc = new Array(); //  예측 발전량 표 데이터
	function getDBData(formData) {
		pv_head_pc.length = 0;
		real_data_pc.length = 0;
		feture_data_pc.length = 0;
		setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
		getPVGenRealList(formData); // 실제 발전량 조회
		getPVGenFutureList(formData); // 예측 발전량 조회
		drawData(); // 차트 및 표 그리기
	}
	
	// PV 실제 발전량
	var pastPVGenList;
	function callback_getPVGenRealList(result) {
		var sheetList = result.sheetList;
		var chartList = result.chartList;
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totalUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str_head = "";
		var dt_str = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		
		// 표데이터 셋팅
		var start = new Date(schStartTime.getTime());
		var end = new Date(schEndTime.getTime());
		if(sheetList != null && sheetList.length > 0) {
			var s = start;
			var e = end;
			setHms(s, e);
			if(periodd == 'month') {
				s.setDate(1);
				s.setHours(0)
				s.setMinutes(0);
				s.setSeconds(0);
			}
			for(var i=0; i<sheetList.length; i++) {
				dt_str_head += "<th>"+convertDataTableHeaderDate(s, 2)+"</th>";
				
				var reUsage = null;
				for(var j=0; j<sheetList.length; j++) {
					if(s.getTime() == setSheetDateUTC(sheetList[j].std_date)) {
						var usage = String(sheetList[j].gen_val);
						if(usage == null || usage == "" || usage == "null") {
							reUsage = null;
						} else {
// 							var map = convertUnitFormat(usage, "kWh", 1);
							var map = convertUnitFormat(usage, "mWh", 8);
							reUsage = toFixedNum(map.get("formatNum"), 2);
							dt_str_totalVal = dt_str_totalVal+Number(map.get("formatNum"));
						}
						
						break;
					}
				}
				dt_str += "<td>"+  ( (reUsage == null) ? "" : reUsage ) +"</td>";
				
				
				if(dt_col_cnt == dt_col) {
					var final_dt_str_head = "<th>"+convertDataTableHeaderDate(s, 1)+"</th>"+dt_str_head;
					dt_str += "<td>"+toFixedNum(dt_str_totalVal, 2)+"</td>";
					pv_head_pc[dt_row_cnt-1] = final_dt_str_head;
					real_data_pc[dt_row_cnt-1] = dt_str;
					dt_str_head = "";
					dt_str = "";
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_totalVal = 0;
				} else {
					if((i+1) == sheetList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str_head += "<th></th>";
							dt_str += "<td></td>";
						}
						var final_dt_str_head = "<th>"+convertDataTableHeaderDate(s, 1)+"</th>"+dt_str_head;
						dt_str += "<td>"+toFixedNum(dt_str_totalVal, 2)+"</td>";
						pv_head_pc[dt_row_cnt-1] = final_dt_str_head;
						real_data_pc[dt_row_cnt-1] = dt_str;
						dt_str_head = "";
						dt_str = "";
	//					dt_row_cnt++;
	//					dt_col_cnt = 1;
						dt_str_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
				}
				
				s = incrementTime(s);
				
			}
			
		}
		
		// 차트데이터 셋팅
		if(chartList != null && chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var usage = String(chartList[i].gen_val);
				var reUsage = 0;
				if(usage == null || usage == "" || usage == "null") {
					reUsage = null;
				} else {
// 					var map = convertUnitFormat(usage, "kWh", 1);
					var map = convertUnitFormat(usage, "mWh", 8);
					reUsage = toFixedNum(map.get("formatNum"), 2);
					totalUsage = totalUsage+Number(usage);
				}
				
				// 차트데이터 셋팅
				dataSet.push([ setChartDateUTC(chartList[i].std_date), reUsage ]);
				
				
			}
			
		}
		pastPVGenList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalUsage), "pastPvGenTot", "kWh");
	}
	
	// PV 예측 발전량
	var feturePVGenList;
	function callback_getPVGenFutureList(result) {
		var sheetList = result.sheetList;
		var chartList = result.chartList;
		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
		
		// 데이터 셋팅
		var dataSet = []; // chartData를 위한 변수
		var totalUsage = 0; // 전체 누적합
		var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
		var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
		var dt_str = "";
		var dt_str_totalVal = 0; // 테이블 라인별 누적합
		
		// 표데이터 셋팅
		var start = new Date(schStartTime.getTime());
		var end = new Date(schEndTime.getTime());
		if(sheetList != null && sheetList.length > 0) {
			var s = start;
			var e = end;
			setHms(s, e);
			if(periodd == 'month') {
				s.setDate(1);
				s.setHours(0)
				s.setMinutes(0);
				s.setSeconds(0);
			}
			for(var i=0; i<sheetList.length; i++) {
				
				var reUsage = null;
				for(var j=0; j<sheetList.length; j++) {
					if(s.getTime() == setSheetDateUTC(sheetList[j].std_date)) {
						var usage = String(sheetList[j].gen_val);
						if(usage == null || usage == "" || usage == "null") {
							reUsage = null;
						} else {
// 							var map = convertUnitFormat(usage, "kWh", 1);
							var map = convertUnitFormat(usage, "mWh", 8);
							reUsage = toFixedNum(map.get("formatNum"), 2);
							dt_str_totalVal = dt_str_totalVal+Number(map.get("formatNum"));
						}
						
						break;
					}
				}
				dt_str += "<td>"+  ( (reUsage == null) ? "" : reUsage ) +"</td>";
				
				
				if(dt_col_cnt == dt_col) {
					dt_str += "<td>"+toFixedNum(dt_str_totalVal, 2)+"</td>";
					feture_data_pc[dt_row_cnt-1] = dt_str;
					dt_str_head = "";
					dt_str = "";
					dt_row_cnt++;
					dt_col_cnt = 1;
					dt_str_totalVal = 0;
				} else {
					if((i+1) == sheetList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
						for(a=0; a<(dt_col-dt_col_cnt); a++) {
							dt_str += "<td></td>";
						}
						dt_str += "<td>"+toFixedNum(dt_str_totalVal, 2)+"</td>";
						feture_data_pc[dt_row_cnt-1] = dt_str;
						dt_str_head = "";
						dt_str = "";
	//					dt_row_cnt++;
	//					dt_col_cnt = 1;
						dt_str_totalVal = 0;
					} else {
						dt_col_cnt++;
					}
				}
				
				s = incrementTime(s);
				
			}
			
		}
		
		// 차트데이터 셋팅
		if(chartList != null && chartList.length > 0) {
			for(var i=0; i<chartList.length; i++) {
				var usage = String(chartList[i].gen_val);
				var reUsage = 0;
				if(usage == null || usage == "" || usage == "null") {
					reUsage = null;
				} else {
// 					var map = convertUnitFormat(usage, "kWh", 1);
					var map = convertUnitFormat(usage, "mWh", 8);
					reUsage = toFixedNum(map.get("formatNum"), 2);
					totalUsage = totalUsage+Number(usage);
				}
				// 차트데이터 셋팅
				dataSet.push([ setChartDateUTC(chartList[i].std_date), reUsage ]);
				
			}
			
		}
		feturePVGenList = dataSet;
		
		// 총 합계(사용량, 발전량, 충전량, 방전량 등등)
		unit_format(String(totalUsage), "feturePvGenTot", "kWh");
	}
	
	// 차트 그리기
	function drawData_chart() {
		var seriesLength = myChart.series.length;
		for(var i = seriesLength - 1; i > -1; i--) {
				myChart.series[i].remove();
		}
		
		myChart.addSeries({
			name: '실제 발전량',
			color: '#438fd7', /* 실제 발전량 */
			type:'column',
			data: pastPVGenList
		}, false);
		
		myChart.addSeries({
			name: '예측 발전량',
			color: '#13af67', /* 예측 발전량 */
			dashStyle: 'ShortDash',
			data: feturePVGenList
		}, false);
		
		setTickInterval();
		
		myChart.redraw(); // 차트 데이터를 다시 그린다
	}
	
	// 표(테이블) 그리기
	function drawData_table() {
		$chart = $(".pv_chart");
		var tbodyStr = '';
		if(real_data_pc.length > 0) {
			$chart.find(".inchart-nodata").css("display", "none");
			$chart.find(".inchart").css("display", "");
			for(var i=0; i<dt_row; i++) {
				tbodyStr += '<div class="chart_table">';
				tbodyStr += '<table class="pc_use">';
				tbodyStr += '<thead>';
				tbodyStr += '<tr>';
				tbodyStr += pv_head_pc[i]+'<th>합계</th>';
				tbodyStr += '</tr>';
				tbodyStr += '</thead>';
				tbodyStr += '<tbody>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit pv1"><span>실제 발전량 (kWh)</span></div></th>'+real_data_pc[i];
				tbodyStr += '</tr>';
				tbodyStr += '<tr>';
				tbodyStr += '<th><div class="ctit pv2"><span>예측 발전량 (kWh)</span></div></th>'+ feture_data_pc[i];
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
			tbodyStr += '<tr>';
			tbodyStr += '<th width="33%"></th>';
			tbodyStr += '<td width="34%">조회 결과가 없습니다.</td>';
			tbodyStr += '<th width="33%"></th>';
			tbodyStr += '</tr>';
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
			<jsp:param value="energy" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">PV 발전량 조회</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">PV 발전량 합계</h2>
							<ul class="chart_total">
								<li class="pv1">
									<div class="ctit pv1"><span>실제 발전량</span></div>
									<div class="cval" id="pastPvGenTot"><span>0</span>kWh</div>
								</li>
								<li class="pv2">
									<div class="ctit pv2"><span>예측 발전량</span></div>
									<div class="cval" id="feturePvGenTot"><span>0</span>kWh</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv pv_chart">
							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="energy" name="schGbn"/>
							</jsp:include>
							<div class="inchart-nodata" style="display: none;">
								<span>조회 결과가 없습니다.</span>
							</div>
							<div class="inchart">
								<div class="chart_type">
									<a href="#;" class="chart_change_column" style="display:none;">그래프변경</a>
									<a href="#;" class="chart_change_line">그래프변경</a>
								</div>
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
											type: 'line'
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
// 											tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
											title: {
												text: null
											},
											/* 기준선 */
											plotLines: [{
									            value: 15, /* 현재 */
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
											gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										    min: 0, /* 최소값 지정 */
										    title: {
										    	text: '(kWh)',
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
										            fontSize: '18px'
										        }
										    }
										},									    

										/* 범례 */
										legend: {
											enabled: true,
											align:'right',
											verticalAlign:'top',
											x:-120,										
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
									                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) 
									                	+ '<br/><span style="color:#438fd7">' + this.y + ' kWh</span>';
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
											}
									    },

										/* 출처 */
										credits: {
											enabled: false
										},

										/* 그래프 스타일 */
									    series: [{
									        color: '#438fd7', /* 실제 발전량 */
									        type:'column'
									    }, {
									    	color: '#84848f', /* 예측 발전량 */
									        dashStyle: 'ShortDash'
									    }],

									    /* 반응형 */
									    responsive: {
									        rules: [{
									            condition: {
									                maxWidth: 414 /* 차트 사이즈 */									                
									            },
									            chartOptions: {
									            	chart: {
									            		marginLeft:60,
														marginTop:80
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

// 									},
// 									/* 차트 변경 */
// 							        function (myChart) {
// 							            $('.chart_change_column').click(function () {
// 							                $(this).hide();
// 							                $('.chart_change_line').show();
// 							                myChart.series[0].update({
// 							                    type: "column"
// 							                });

// 							            });
// 							            $('.chart_change_line').click(function () {
// 							            	$(this).hide();
// 							            	$('.chart_change_column').show();
// 							                myChart.series[0].update({
// 							                    type: "line"
// 							                });

// 							            });
							        });
// 								});

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
				<div class="row pv_chart_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">PV 발전량 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn" onclick="excelDownload('PV발전량', event);">데이터저장</a></li>
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

</body>
</html>