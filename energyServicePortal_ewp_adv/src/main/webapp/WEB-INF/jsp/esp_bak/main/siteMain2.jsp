<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="https://code.highcharts.com/5.0.14/highcharts-more.js"></script>
<script src="https://code.highcharts.com/5.0.14/modules/solid-gauge.js "></script>
<script src="https://code.highcharts.com/5.0.14/modules/exporting.js"></script>
<script src="https://code.highcharts.com/5.0.14/modules/export-data.js"></script>
<script	src="https://code.highcharts.com/5.0.14/modules/accessibility.js"></script>
<style type="text/css">
#deviceList {
	list-style: none;
	margin: 0;
	padding: 0;
}

#deviceList li {
	margin: 0 0 0 0;
	padding: 0 0 0 0;
	border: 0;
	float: left;
	color: white;
	width: 100px;
}

.highcharts-figure .chart-container {
	width: 150px;
	height: 100px;
	float: left;
}

.highcharts-figure, .highcharts-data-table table {
	width: 200px;
	margin: 0 auto;
}

.highcharts-data-table table {
	font-family: Verdana, sans-serif;
	border-collapse: collapse;
	border: 1px solid #EBEBEB;
	margin: 10px auto;
	text-align: center;
	width: 100%;
	max-width: 500px;
}

.highcharts-data-table caption {
	padding: 1em 0;
	font-size: 1.2em;
	color: #EEE;
}

.highcharts-data-table th {
	font-weight: 600;
	padding: 0.5em;
}

.highcharts-data-table td, .highcharts-data-table th,
	.highcharts-data-table caption {
	padding: 0.5em;
}

.highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even)
	{
	background: #f8f8f8;
}

.highcharts-data-table tr:hover {
	background: #f1f7ff;
}

@media ( max-width : 200px) {
	.highcharts-figure, .highcharts-data-table table {
		width: 100%;
	}
	.highcharts-figure .chart-container {
		width: 150px;
		float: left;
		margin: 0 auto;
	}
}

.device_color0 {
	background: skyblue;
}
.device_color1 {
	background: #13af67;
}
.device_color2 { 
	background: #f75c4a;
}

.deviceByType table th,.deviceByType table td {
	padding-left: 5%;
}

</style>
<script>
	//차트 모듈
	var myChart = function(title, div_id, chart_id, table_id, data_name_list, data_map_list, unit, count, line_type, yaxis_min) {
		this.chartTitle = title;
		this.date = new Date().format('yyyy-MM-dd hh:mm:ss');
		this.chart_id = chart_id;
		this.table_id = table_id;
		this.div_id = div_id;
		this.myseries = new Array();
		this.series_color = [ '#438fd7', '#13af67', '#f75c4a', '#84848f' ];
		this.line_type = line_type;
		this.yaxis_min = yaxis_min;

		this.makeData = function() {
			var str = '';
			str += '<div class="chart_top">';
			str += '<h2 class="ntit fl">' + this.chartTitle + '</h2>';
			str += '<div class="time fr">' + this.date + '</div>';
			str += '</div>';
			str += '<div class="inchart">';
			str += '<div id=' + '\'' + this.chart_id + '\'' + 'style="height:200px;"></div>';
			str += '	<div class="chart_table" style="display:none;">	';
			str += '		<table id=' + '\'' + this.table_id  + '\'' + '>';
			str += '			<thead>';
			str += '				<tr>';
			str += '					<th></th>';
			for (var i = 0; i < data_name_list.length; ++i) {
				str += '<th>' + data_name_list[i] + '</th>';
			}
			str += '				</tr>';
			str += '			</thead>';
			str += '			<tbody>';

			for (var i = 0; i < count; ++i) {
				str += '<tr>';
				str += '<th>' + (i + 1) + unit + '</th>';
				for (var j = 0; j < data_map_list.length; ++j) {
					var tempData = data_map_list.get((j + 1))[i];
					tempData = (typeof(tempData)=='undefined')?'':tempData;
					str += '<th>' + tempData + '</th>';
				}
				str += '</tr>';
			}
			str += '			</tbody>';
			str += '		</table>';
			str += '	</div>';
			str += '</div>';

			$('#'+div_id).html(str);
		};

		this.makeChart = function() {
			this.makeData();

			if (this.line_type == true) {
				for (var i = 0; i < data_name_list.length; ++i) {
					this.myseries.push({
						type : 'line',
						name : data_name_list[i],
						color : this.series_color[i % 4],
						dashStyle : 'Solid'
					});
				}
			} else {
				for (var i = 0; i < data_name_list.length; ++i) {
					if ((i % 2) === 1) {
						this.myseries.push({
							type : 'column',
							name : data_name_list[i],
							color : this.series_color[i % 4]
						});
					} else {
						this.myseries.push({
							type : 'line',
							name : data_name_list[i],
							color : this.series_color[i % 4],
							dashStyle : 'ShortDash'
						});
					}
				}
			}

			var chargeChart = Highcharts.chart(this.chart_id, {
				data : {
					table : this.table_id
				},

				chart : {
					height: 130,
					width: 300,
					marginLeft : 50,
					marginRight : 0,
					backgroundColor : 'transparent',
					type : 'column'
				},

				navigation : {
					buttonOptions : {
						enabled : false
					/* 메뉴 안보이기 */
					}
				},

				title : {
					text : ''
				},

				subtitle : {
					text : ''
				},

				xAxis : {
					labels : {
						align : 'center',
						y : 27, /* 그래프와 거리 */
						style : {
							color : '#fff',
							fontSize : '12px'
						}
					},
					tickInterval : 1, /* 눈금의 픽셀 간격 조정 */
					title : {
						text : null
					}
				},

				yAxis : {
					gridLineWidth : 1, /* 기준선 grid 안보이기/보이기 */
					min : this.yaxis_min,
					title : {
						text : '(kWh)',
						align : 'low',
						rotation : 0, /* 타이틀 기울기 */
						y : 25, /* 타이틀 위치 조정 */
						x : 10,
						style : {
							color : '#fff',
							fontSize : '12px'
						}
					},
					labels : {
						overflow : 'justify',
						x : -10, /* 그래프와의 거리 조정 */
						style : {
							color : '#fff',
							fontSize : '12px'
						}
					}
				},

				/* 범례 */
				legend : {
					enabled : true,
					align : 'right',
					verticalAlign : 'top',
					x : 18,
					y : -20,
					itemStyle : {
						color : '#fff',
						fontSize : '12px',
						fontWeight : 400
					},
					itemHoverStyle : {
						color : '' /* 마우스 오버시 색 */
					},
					symbolPadding : 3, /* 심볼 - 텍스트간 거리 */
					symbolHeight : 7
				/* 심볼 크기 */
				},

				/* 툴팁 */
				tooltip : {
					formatter : function() {
						return '<b>' + this.series.name + '</b><br/>' + this.x
								+ '<br/><span style="color:#438fd7">' + this.y
								+ ' kWh</span>';
					}
				},

				/* 옵션 */
				plotOptions : {
					series : {
						label : {
							connectorAllowed : true,
							allowPointSelect: true
						},
						marker: {
							symbol: 'circle',
							radius: 3,
		                    enabled: true
		                },
						borderWidth : 0
					/* 보더 0 */
					},
					line : {
						marker : {
							enabled : false
						/* 마커 안보이기 */
						}
					}
				},

				/* 출처 */
				credits : {
					enabled : false
				},

				/* 그래프 스타일 */
				series : this.myseries,

				/* 반응형 */
				responsive : {
					rules : [ {
						condition : {
							minWidth : 842
						/* 차트 사이즈 */
						},
						chartOptions : {
							chart : {
								marginLeft : 75
							},
							xAxis : {
								labels : {
									style : {
										fontSize : '18px'
									}
								}
							},
							yAxis : {
								title : {
									style : {
										fontSize : '18px'
									}
								},
								labels : {
									style : {
										fontSize : '18px'
									}
								}
							},
							legend : {
								itemStyle : {
									fontSize : '18px'
								},
								symbolPadding : 5,
								symbolHeight : 10
							}
						}
					}]
				}
			});
		}
	} 
	//게이지 그래프 옵션
	var gaugeOptions = {
			chart : {
				type : 'solidgauge',
				backgroundColor : null
			},
			title : null,

			pane : {
				center : ['50%'],
				size : '100%',
				startAngle : -90,
				endAngle : 90,
				background : {
					backgroundColor : Highcharts.defaultOptions.legend.backgroundColor
							|| '#EEE',
					borderColor : 'none',
					innerRadius : '60%',
					outerRadius : '100%',
					shape : 'arc'
				}
			},

			exporting : {
				enabled : false
			},

			tooltip : {
				enabled : false
			},

			// the value axis
			yAxis : {
				stops : [ [ 0.1, '#55BF3B' ], // green
				[ 0.5, '#DDDF0D' ], // yellow
				[ 0.9, '#DF5353' ] // red
				],
				lineWidth : 0,
				tickWidth : 0,
				minorTickInterval : null,
				tickAmount : 2,
				title : {
					y : -70
				},
				labels : {
					y : 16
				}
			},

			plotOptions : {
				solidgauge : {
					dataLabels : {
						y : 5,
						borderWidth : 0,
						useHTML : true
					}
				}
			}
		};
	
	
	
	
	// 모니터링 변수
	var monitoring_cycle_10sec = null;
	var monitoring_cycle_1min = null;
	var monitoring_cycle_15min = null;
	var formData = null;
	var lastGenData = [];
	var thisGenData = [];
	var inverterIdList = [];
	var inverterDataList = [];
	var ratioData = 0;
	
	$(document).ready(function() {
		navAddClass("siteMain");
		formData = getSiteMainSchCollection();
		getDeviceType(formData); //장치타입 가져오기
		getDataByType();
		getGenChartDataList(formData); //차트관련 데이터 조회
		draw_genChart(); //차트 그리기
		
		$("#cancelBtn, #cancelBtnX").on('click', function () { //닫기
			popupClose('weaDtlMng');
		});
	});
	
	//genchart
	function draw_genChart() {
		//발전량 차트
		var data_name_list1 = new Array('설비용량', '출력');
		var dataMap1 = new Map();
		dataMap1.put("1", lastGenData);
		dataMap1.put("2", thisGenData);
		//div_id, chart_id, table_id, data_name_list, data_map_list, unit, count, line_type, yaxis_min
		var c3 = new myChart('누적출력 추이', 'accum_chart', 'gen_chart3', 'gen_datatable3', data_name_list1, dataMap1, '월', 12, false, null);
		c3.makeChart();
		
		//발전량 차트
		var data_name_list1 = new Array('2019', '2020');
		var dataMap1 = new Map();
		dataMap1.put("1", lastGenData);
		dataMap1.put("2", thisGenData);
		//div_id, chart_id, table_id, data_name_list, data_map_list, unit, count, line_type, yaxis_min
		var c1 = new myChart('발전량 추이', 'gen_chart', 'gen_chart1',	'gen_datatable1', data_name_list1, dataMap1, '월', 12, false, 0);
		c1.makeChart();
		
		//이용률 차트
		var dataMap2 = new Map();
		for(var i = 0 ; i < inverterDataList.length ; i++) {
			dataMap2.put(i+1, inverterDataList[i]);
		} 
		//div_id, chart_id, table_id, data_name_list, data_map_list, unit, count, line_type, yaxis_min
		var c2 = new myChart('이용률', 'usage_chart', 'gen_chart2',	'gen_datatable2', inverterIdList, dataMap2, '월', 12, true, null);
		c2.makeChart();		

		//발전량 게이지 차트
		draw_genRatioChart();
		
	}
	
	//ratiochart
	function draw_genRatioChart() {

		var chartSpeed = Highcharts.chart('ratioChart', Highcharts.merge(gaugeOptions,	{
											yAxis : {
												min : 0,
												max : 100,
											},
											credits : {
												enabled : false
											},
											series : [ {
												name : 'Speed',
												data : [ratioData],
												dataLabels : {
													format : '<div style="text-align:center">'
															+ '<span style="font-size:25px; color:#eee;">{y}%</span><br/>'
															+ '</div>'
												},
												tooltip : {
													valueSuffix : '%'
												}
											} ]
										}));
	}
	
	function getSiteMainSchCollection() {
		$("#timeOffset").val(timeOffset);

		var firstDay = new Date();
		var endDay = new Date();
		var startTime;
		var endTime;
		startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(),
				firstDay.getDate(), 0, 0, 0);
		endTime = new Date(endDay.getFullYear(), endDay.getMonth(), endDay
				.getDate(), 23, 59, 59);

		var queryStart = new Date(startTime.getTime());
		var queryEnd = new Date(endTime.getTime());
		queryStart = (queryStart === "") ? "" : queryStart
				.format("yyyyMMddHHmmss");
		queryEnd = (queryEnd === "") ? "" : queryEnd.format("yyyyMMddHHmmss");
		$("#selTermFrom").val(queryStart);
		$("#selTermTo").val(queryEnd);

		var monthFrom = new Date(firstDay.getFullYear(), firstDay.getMonth(),
				1, 0, 0, 0);
		var monthTo = new Date(firstDay.getFullYear(), firstDay.getMonth(),
				(new Date(firstDay.getFullYear(), firstDay.getMonth(), 0))
						.getDate(), 23, 59, 59);
		var yearFrom = new Date(firstDay.getFullYear(), 0, 1, 0, 0, 0);
		var yearTo = new Date(firstDay.getFullYear(), 11, 31, 23, 59, 59);
		$("#monthFrom").val(monthFrom.format("yyyyMMddHHmmss"));
		$("#monthTo").val(monthTo.format("yyyyMMddHHmmss"));
		$("#yearFrom").val(yearFrom.format("yyyyMMddHHmmss"));
		$("#yearTo").val(yearTo.format("yyyyMMddHHmmss"));

		var frm = $("#schForm").serializeObject();
		return frm;
	}

	//발전량 조회
	function getGenChartDataList(formData) {
		$.ajax({
			url : "/main/getGenRealList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success : function(result) {
				var genRealList = result.genRealList;// 발전량 추이 데이터
				var idList = result.inverterIdList; // 인버터 아이디 리스트
				var dataList = result.inverterDataList; // 인버터 데이터 리스트
				var todayGenData = result.todayGenData; // 금일 발전량 게이지차트 데이터
				// 데이터 셋팅
				if (genRealList != null && genRealList.length > 0) {
					for (var i = 0; i < genRealList.length; i++) {
						var monthdate = String(genRealList[i].monthdate);
						var sum_daily_pwr = Number(genRealList[i].sum_daily_pwr);

						if ($("#selTermFrom").val().substr(0, 4) == monthdate.substr(0, 4)) {
							var tempMap = new Map();
							tempMap.put('')
							thisGenData.push(Number(sum_daily_pwr));
						} else {
							lastGenData.push(Number(sum_daily_pwr));
						}
					}
				}
				if (idList != null && idList.length > 0 && dataList != null && dataList.length > 0) {
					inverterIdList = idList;
					inverterDataList = dataList;
				}
				
				if(todayGenData != null) {
					ratioData = Number(todayGenData.ratio);
					
					var inv_temp = todayGenData.inv_temp;
					var inv_humi = todayGenData.inv_humi;
					var tot_power = todayGenData.tot_power;
					var now_pwr = todayGenData.now_pwr;
					var daily_pwr = todayGenData.daily_pwr;
					var ratioHtml = '';
					
					ratioHtml += '<ul>';
					ratioHtml += '	<li>총 설비용량<span>13MW(하드코딩)</span></li>';
					ratioHtml += '	<li>금일 발전량<span>'+ now_pwr +'kWh</span></li>';
					ratioHtml += '	<li>금일 Co2 저감량<span>13Co2(하드코딩)</span></li>';
					ratioHtml += '	<li>월간 발전량<span>'+tot_power+'kWh</span></li>';
					ratioHtml += '	<li>누적 발전량<span>'+tot_power+'MWh</span></li>';
					ratioHtml += '	<li>일계획 발전량<span>'+ daily_pwr +'MWh</span></li>';
					ratioHtml += '</ul>';
					
					$('#ratioData').html(ratioHtml);
					
					$('#nowTemper').html(inv_temp + '도');
					$('#nowHumid').html(inv_humi + '%');
					
				}
			},
			error : function(request, status, error) {
				console.log('error');
				error_getGenRealList(request, status, error);
			}
		});
	}

	function error_getGenRealList(request, status, error) {
		var $gen = $(".gen");
		$charge.find(".no-data").css("display", "");
		$charge.find(".inchart").css("display", "none");
		$charge.find(".chart_footer").css("display", "none");
	}

	function getDeviceType(formData) {
		$.ajax({
			url : "/main/getDeviceType.json",
			type : 'post',
			async : true,
			data : formData,
			success : function(result) {
				var typeList = result.typeList;
				if (typeList != null && typeList.length > 0 ) {
					
					$sel = $('#sel_deviceType');
					$sel.empty();
					$(typeList).each(function(){
						var option = '<option value='+this.device_type+'>'+this.device_type_name+'</option>';
						$sel.append(option);
					});
				}
				$('#deviceType').val($('#sel_deviceType').val());
			},
			complete : function() {
				getDeviceList(); //최초 장치타입 조회 후 리스트 조회 
			}
		});
	}

	// 장치목록 조회(메인화면)
	function getDeviceList() {
		
		var form = getSiteMainSchCollection();
		$.ajax({ 
			url : "/main/getDeviceList.json",
			type : 'post',
			data : form,
			success : function(result) {
				var deviceList = result.deviceList;

				var $alarm = $(".alarm");
				if (deviceList.length < 1 || deviceList == null) {
					$alarm.find(".no-data").css("display", "");
					$alarm.find(".device").css("display", "none");
				} else {
					$alarm.find(".no-data").css("display", "none");
					$alarm.find(".device").css("display", "");
				}

				if (deviceList != null && deviceList.length > 0) {
					
					$div = $('#deviceState');
					$div.empty();
					var tempHtml = '';

					var nrmlCnt = 0;
					var alrtCnt = 0;
					var wrnCnt = 0;
					var abnrmlList = [];
					
					$(deviceList).each(function() {
						
						var alarm_type = (this.alarm_type==null)?0:this.alarm_type;
						var alarm_act_yn = (this.alarm_act_yn==null)?'Y':this.alarm_act_yn;
						var deviceMark = '';

						if(alarm_act_yn == 'Y') {
							nrmlCnt++;
							deviceMark = '<div style="width:50px; height:50px; display:inline-block; margin: 5px;" class="device_color0"></div>';
						} else if(alarm_act_yn == 'N') {
							if(alarm_type == 1) {
								alrtCnt++;
								deviceMark = '<div style="width:50px; height:50px; display:inline-block; margin: 5px;" class="device_color1"></div>';
							} else {
								wrnCnt++;
								deviceMark = '<div style="width:50px; height:50px; display:inline-block; margin: 5px;" class="device_color2"></div>';
							}
							abnrmlList.push(this);
						}
						
						$div.append(deviceMark);
					});
					
					$('#nrmlCnt').text(nrmlCnt + '개');
					$('#alrtCnt').text(alrtCnt + '개');
					$('#wrnCnt').text(wrnCnt + '개');
						
				}

				$abnrmlContent = $('.abnrml-content');
				$abnrmlContent.empty();
				if(abnrmlList.length > 0) {
					
					var abHtml = '<ul>';
					$(abnrmlList).each(function(){
						abHtml += '	<li>'+ ' \''+this.device_id +'\' '+ this.alarm_msg +'   '+ new Date(this.std_date).format('MM/dd HH:mm:ss')  +'</li>';
					}); 
					abHtml += '</ul>';
					$abnrmlContent.html(abHtml);				
				} else {
					$abnrmlContent.html('No error device.');
				}
				
				
// 				update_updtDataTime(new Date(), "updtTimeDevice");
// 				update_updtDataTime(new Date(), "updtTimeDevice2");
			} 
		});
	}
	
	function changeType(deviceType) {
		$('#deviceType').val(deviceType);
		getDeviceList();
	}
	
	function getDataByType() {
		
		var form = getSiteMainSchCollection();
		$.ajax({ 
			url : "/main/getDataByType.json",
			type : 'post',
			data : form,
			success : function(result) {
				var databyTypeList = result.dataList;
				
				if(databyTypeList != null && databyTypeList.length > 0) {
					
					var cir_now_pwr = 0, cir_total_pwr = 0, cir_hertz = 0, cir_normal_cnt = 0, cir_abnormal_cnt = 0;
					
					$(databyTypeList).each(function(){
						var deviceType = (this.device_type == null)?'':this.device_type;
						if('i' == deviceType) {
							var invHtml = '';
							invHtml += '<table>';
							invHtml += '	<thead>';
							invHtml += '		<tr>';
							invHtml += '			<th>인버터 출력</th>';
							invHtml += '			<th>태양광 입력</th>';
							invHtml += '			<th>금일 발전량</th>';
							invHtml += '			<th>월간 발전량</th>';
							invHtml += '		</tr>';
							invHtml += '	</thead>';
							invHtml += '	<tbody>';
							invHtml += '		<tr>';
							invHtml += '			<td>'+this.inv_dc+'</td>';
							invHtml += '			<td>'+this.inv_ac+'</td>';
							invHtml += '			<td>'+this.inv_daily_pwr+'</td>';
							invHtml += '			<td>'+this.inv_tot_power+'</td>';
							invHtml += '		</tr>';
							invHtml += '	</tbody>';
							invHtml += '</table>';
							
							$('#tot_inv_tbl').empty();
							$('#tot_inv_tbl').html(invHtml);
							$('#tot_inv').show();
							
							$('#inv_nrml').text(this.normal_cnt +'개');
							$('#inv_abnrml').text(this.abnormal_cnt +'개');
							
						} else if('V' == deviceType || 'A' == deviceType) {
							cir_now_pwr += Number(this.cir_now_pwr);
							cir_total_pwr += Number(this.cir_total_pwr);
							cir_hertz +=  Number(this.cir_hertz);
							cir_normal_cnt += Number(this.normal_cnt);
							cir_abnormal_cnt += Number(this.abnormal_cnt);
							
						} else if('s' == deviceType) {
							var solHtml = '';
							solHtml += '<table>';
							solHtml += '	<thead>';
							solHtml += '		<tr>';
							solHtml += '			<th>평균 DCU 전압</th>';
							solHtml += '			<th>평균 DCU 전류</th>';
							solHtml += '			<th>평균 경사일사량</th>';
							solHtml += '			<th>평균 수평일사량</th>';
							solHtml += '		</tr>';
							solHtml += '	</thead>';
							solHtml += '	<tbody>';
							solHtml += '		<tr>';
							solHtml += '			<td>'+this.sol_tot_volt+'</td>';
							solHtml += '			<td>'+this.sol_tot_amp+'</td>';
							solHtml += '			<td>'+this.sol_insolation_pv+'</td>';
							solHtml += '			<td>'+this.sol_insolation_horz+'</td>';
							solHtml += '		</tr>';
							solHtml += '	</tbody>';
							solHtml += '</table>';
							
							$('#tot_sol_tbl').empty();
							$('#tot_sol_tbl').html(solHtml);
							$('#tot_sol').show();
							
							$('#sol_nrml').text(this.normal_cnt +'개');
							$('#sol_abnrml').text(this.abnormal_cnt +'개');
							
						} else if('W' == deviceType) {
							var weaHtml = '';
							weaHtml += '<table>';
							weaHtml += '	<thead>';
							weaHtml += '		<tr>';
							weaHtml += '			<th>온도</th>';
							weaHtml += '			<th>풍속</th>';
							weaHtml += '			<th>습도</th>';
							weaHtml += '			<th>강수량</th>';
							weaHtml += '			<th>경사일사량</th>';
							weaHtml += '			<th>수평일사량</th>';
							weaHtml += '		</tr>';
							weaHtml += '	</thead>';
							weaHtml += '	<tbody>';
							weaHtml += '		<tr>';
							weaHtml += '			<td>'+this.wea_temp_near+'</td>';
							weaHtml += '			<td>'+this.wea_wind_speed+'</td>';
							weaHtml += '			<td>'+this.wea_humidity+'</td>';
							weaHtml += '			<td>'+this.wea_rainfall+'</td>';
							weaHtml += '			<td>'+this.wea_Insolation_pv+'</td>';
							weaHtml += '			<td>'+this.wea_Insolation_horz+'</td>';
							weaHtml += '		</tr>';
							weaHtml += '	</tbody>';
							weaHtml += '</table>';
							
							$('#tot_wea_tbl').empty();
							$('#tot_wea_tbl').html(weaHtml);
							$('#tot_wea').show();
							
							$('#wea_nrml').text(this.normal_cnt +'개');
							$('#wea_abnrml').text(this.abnormal_cnt +'개');
							
						} else {
							console.log(this);
						}
					});
					
					//차단기는 타입이 두개로 나뉘기 떄문에 따로 처리
					var cirHtml = '';
					cirHtml += '<table>';
					cirHtml += '	<thead>';
					cirHtml += '		<tr>';
					cirHtml += '			<th>현재출력</th>';
					cirHtml += '			<th>누적 발전량</th>';
					cirHtml += '			<th>주파수</th>';
					cirHtml += '		</tr>';
					cirHtml += '	</thead>';
					cirHtml += '	<tbody>';
					cirHtml += '		<tr>';
					cirHtml += '			<td>'+Number(cir_now_pwr)+'</td>';
					cirHtml += '			<td>'+Number(cir_total_pwr)+'</td>';
					cirHtml += '			<td>'+Number(cir_hertz)+'</td>';
					cirHtml += '		</tr>';
					cirHtml += '	</tbody>';
					cirHtml += '</table>';
					
					$('#tot_cir_tbl').empty();
					$('#tot_cir_tbl').html(cirHtml);
					$('#tot_cir').show();

					$('#cir_nrml').text(Number(cir_normal_cnt) +'개');
					$('#cir_abnrml').text(Number(cir_abnormal_cnt) +'개');
					
				}
			}
		});
	}
	
	function weatherDetail() {
		var form = getSiteMainSchCollection();
		
		$.ajax({
	        url: "/getWeatherData.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: form,
	        success: function (result) {
	        	var shortFcstData = result.shortFcstData;
	        	$('#todayWeather').empty();
	        	
        		var dongneData = result.dongneData;
       			$('#weatherList').empty();
        		
       			$(shortFcstData).each(function(){
       				
        			var tempHtml = "";
        			var skyState = "";
        			if(this.SKY == 1) {
        				skyState = "맑음";
        			} else if(this.SKY == 3) {
        				skyState = "구름많음";
        			} else {
        				skyState = "흐림";
        			}
        			
        			var windDir = "";
        			if(this.VEC < 45) {
        				windDir = "N-NE";
        			} else if(this.VEC < 90) {
        				windDir = "NE-E";
        			} else if(this.VEC < 135) {
        				windDir = "E-SE";
        			} else if(this.VEC < 180) {
        				windDir = "SE-S";
        			} else if(this.VEC < 225) {
        				windDir = "S-SW";
        			} else if(this.VEC < 270) {
        				windDir = "SW-W";
        			} else if(this.VEC < 315) {
        				windDir = "W-NW";
        			} else if(this.VEC < 360) {
        				windDir = "NW-N";
        			}
        			
        			var rainState = "";
        			if(this.PTY == 0) {
        				rainState = "없음";
        			} else if(this.PTY == 1) {
        				rainState = "비";
        			} else if(this.PTY == 2) {
        				rainState = "비/눈";
        			} else if(this.PTY == 3) {
        				rainState = "눈";
        			} else {
        				rainState = "소나기";
        			}
        			
        			tempHtml += '<div>';
        			tempHtml += '	<ul>';
        			tempHtml += '		<li>'+this.date+'일'+this.time+'시'+'</li>';
        			tempHtml += '		<li> 온 도 :'+ this.T1H+' °C</li>';
        			tempHtml += '		<li> 습 도 :'+ this.REH+' %</li>';
        			tempHtml += '		<li>하늘상태 :'+ skyState +'</li>';
        			tempHtml += '		<li>강수형태 :'+ rainState+'</li>';
        			tempHtml += '		<li> 풍 향 :'+ windDir +'</li>';
        			tempHtml += '		<li> 풍 속 :'+ this.WSD+' m/s</li>';
        			tempHtml += '	</ul>';
        			tempHtml += '</div>';
        			
        			$('#todayWeather').append(tempHtml);
        		});
        			$('#todayWeather').append('<br/>');
       			
       			
       			$(dongneData).each(function(){
       				
        			var tempHtml = "";
        			var skyState = "";
        			if(this.SKY == 1) {
        				skyState = "맑음";
        			} else if(this.SKY == 3) {
        				skyState = "구름많음";
        			} else {
        				skyState = "흐림";
        			}
        			
        			var windDir = "";
        			if(this.VEC < 45) {
        				windDir = "N-NE";
        			} else if(this.VEC < 90) {
        				windDir = "NE-E";
        			} else if(this.VEC < 135) {
        				windDir = "E-SE";
        			} else if(this.VEC < 180) {
        				windDir = "SE-S";
        			} else if(this.VEC < 225) {
        				windDir = "S-SW";
        			} else if(this.VEC < 270) {
        				windDir = "SW-W";
        			} else if(this.VEC < 315) {
        				windDir = "W-NW";
        			} else if(this.VEC < 360) {
        				windDir = "NW-N";
        			}
        			
        			var rainState = "";
        			if(this.PTY == 0) {
        				rainState = "없음";
        			} else if(this.PTY == 1) {
        				rainState = "비";
        			} else if(this.PTY == 2) {
        				rainState = "비/눈";
        			} else if(this.PTY == 3) {
        				rainState = "눈";
        			} else {
        				rainState = "소나기";
        			}
        			
        			tempHtml += '<div>';
        			tempHtml += '	<ul>';
        			tempHtml += '		<li>'+this.date+'일'+this.time+'시'+'</li>';
        			tempHtml += '		<li> 온 도 :'+ this.T3H+' °C</li>';
        			tempHtml += '		<li> 습 도 :'+ this.REH+' %</li>';
        			tempHtml += '		<li>하늘상태 :'+ skyState +'</li>';
        			tempHtml += '		<li>강수형태 :'+ rainState+'</li>';
        			tempHtml += '		<li> 풍 향 :'+ windDir +'</li>';
        			tempHtml += '		<li> 풍 속 :'+ this.WSD+' m/s</li>';
        			tempHtml += '	</ul>';
        			tempHtml += '</div>';
        			
        			$('#weatherList').append(tempHtml);
        		});
        	}
		});
		popupOpen('weaDtlMng');
	}
	
</script>

<!-- 메인페이지용 스타일 파일 -->
<link href="../css/custom.css" rel="stylesheet">

<div id="container">
	<form id="schForm" name="schForm" action="">
		<input type="hidden" id="selTermFrom" name="selTermFrom">
		<input type="hidden" id="selTermTex" name="selTermTex">
		<input type="hidden" id="selTermTo" name="selTermTo">
		<input type="hidden" id="selTerm" name="selTerm" value="today">
		<input type="hidden" id="selPeriodVal" name="selPeriodVal" value="hour">
		<input type="hidden" id="siteId" name="siteId" value="${selViewSiteId }">
		<input type="hidden" id="selPageNum" name="selPageNum" value="">
		<input type="hidden" id="timeOffset" name="timeOffset">
		<input type="hidden" id="monthFrom" name="monthFrom">
		<input type="hidden" id="monthTo" name="monthTo">
		<input type="hidden" id="yearFrom" name="yearFrom">
		<input type="hidden" id="yearTo" name="yearTo">
		<input type="hidden" id="deviceType" name="deviceType" value="">
	</form>
	<div class="row">
		<div class="col-lg-4">
			<div class="row">
				<div class="col-sm-12">
					<div class="indiv alarm">
						<div class="device_alarm" style="height:100px; color:white;">
							<span>
								<div class="dropdown">
									<select id="sel_deviceType" onchange="changeType(this.value);">
									</select>
<!-- 									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false"><em id="selDeviceType">인버터</em> -->
<!-- 										<span class="caret"></span></button> -->
<!-- 									<ul class="dropdown-menu"> -->
<!-- 										<li class="on"><a href="javascript:void(0);" >인버터</a></li> -->
<!-- 										<li><a href="javascript:void(0);" >차단기</a></li> -->
<!-- 									</ul> -->
								</div>
							</span>
							<div class="device_normal" style="width: 33%; height:50px; float: left; background-color: skyblue; margin-left: 1px;text-align: center;" >
								<span>정상</span>
								<br/>
								<span id="nrmlCnt">0개</span>
							</div>
							<div class="device_alert" style="width: 33%; height:50px; float: left;background-color: #13af67; margin-left: 1px;text-align: center;">
								<span>정지</span>
								<br/>
								<span id="alrtCnt">0개</span>
							</div>
							<div class="device_warn" style="width: 33%; height:50px; float: left;background-color: #f75c4a; margin-left: 1px; text-align: center;">
								<span>고장</span>
								<br/>
								<span id="wrnCnt">0개</span>
							</div>
						</div>
						<div class="device_state">
							<div style="width:100%; height:200px; display:inline-block;">
								<div style="width:100%; height:95%; display:inline-block; background:#000052;" id="deviceState"></div>
							</div>
						</div>
						<!-- no-data { -->
						<div class="no-data" style="display: none;">
							<span><spring:message
									code="ewp.site.Cannot_alarm_information" /> <!-- 알람 정보를 가져올 수 없습니다. --></span>
						</div>
					</div>
					<div class="indiv smain_device" style="overflow-y: auto; max-height: 400px;">
						<div class="chart_top clear">
							<h2 class="ntit fl">
								장치유형별 현황
							</h2>
							<div class="time fr" id="updtTimeDevice">2018-08-12	11:41:26</div>
						</div>
						<!-- no-data { -->
						<div class="no-data" style="display: none;">
							<span><spring:message
									code="ewp.site.Cannot_usage_composition_information." /> <!-- 사용량 구성 정보를 가져올 수 없습니다. --></span>
						</div>
						<!-- } no-data -->
						<div class="deviceGroupList" style="width: 100%; height:350px; overflow: auto; color: white;">
							<div id="tot_inv" style="width: 100%; height:30%; background:#000052; margin-bottom: 5%; display: none;">
								<div class="grp_top" style="width: 100%; height:20%;">
									<div style="width: 20%; height:100%; float: left;">인버터</div>
									<div style="width: 40%; height:100%; float: right;"><span id="inv_nrml" style="width:15%; background-color:skyblue; ">23</span><span id="inv_abnrml" style="width:15%; padding-left: 5%; background-color:#f75c4a;">23</span></div>
								</div>
								<div id="tot_inv_tbl" class="deviceByType" style="width: 100%; height:80%; font-size: 85%;">
								</div>
							</div>
							<div id="tot_sol" style="width: 100%; height:30%; background:#000052; margin-bottom: 5%; display: none;">
								<div class="grp_top" style="width: 100%; height:20%;">
									<div style="width: 20%; height:100%; float: left;">접속반</div>
									<div style="width: 40%; height:100%; float: right;"><span id="sol_nrml" style="width:15%; background-color:skyblue;">23</span><span id="sol_abnrml" style="width:15%; padding-left: 5%; background-color:#f75c4a;">1</span></div>
								</div>
								<div id="tot_sol_tbl" class="deviceByType" style="width: 100%; height:80%; font-size: 85%;">
								</div>
							</div>
							<div id="tot_wea" style="width: 100%; height:30%; background:#000052; margin-bottom: 5%; display: none;">
								<div class="grp_top" style="width: 100%; height:20%;">
									<div style="width: 20%; height:100%; float: left;">기상반</div>
									<div style="width: 40%; height:100%; float: right;"><span id="wea_nrml" style="width:15%; background-color:skyblue;">23</span><span id="wea_abnrml" style="width:15%; padding-left: 5%; background-color:#f75c4a;">1</span></div>
								</div>
								<div id="tot_wea_tbl" class="deviceByType" style="width: 100%; height:80%; font-size: 85%;">
								</div>
							</div>
							<div id="tot_cir" style="width: 100%; height:30%; background:#000052; margin-bottom: 5%; display: none;">
								<div class="grp_top" style="width: 100%; height:20%;">
									<div style="width: 20%; height:100%; float: left;">차단기</div>
									<div style="width: 40%; height:100%; float: right;"><span id="cir_nrml" style="width:15%; background-color:skyblue;">23</span><span id="cir_abnrml" style="width:15%; padding-left: 5%; background-color:#f75c4a;">1</span></div>
								</div>
								<div id="tot_cir_tbl" class="deviceByType" style="width: 100%; height:80%; font-size: 85%;">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="row">
				<div class="col-sm-12" style="color:white;">
					<div class="indiv errorInfo" style="min-height: 105px;margin-bottom: 10px; max-height: 107px;">
						<div class="abnrml-top" style="height:20%;">
						<h4>설비 오류정보  <button onclick="javascript:void(0);" style="float: right; background-color: blue;">상세보기</button></h4>
						</div>
						<div class="abnrml-content" style="overflow: auto; width:100%; background:#000052;"></div>
					</div>
					<div class="indiv peak">
						<!-- no-data { -->
						<div class="no-data" style="display: none;">
							<span><spring:message
									code="ewp.site.Cannot_peak_demand_information" /> <!-- 피크전력현황 정보를 가져올 수 없습니다. --></span>
						</div>
						<!-- } no-data -->
						<div class="inchart" style="width:50%;float:left;">
							<figure class="highcharts-figure">
								<div id="ratioChart" style="height: 200px;"></div>
							</figure>
						</div>
						<div class="indata" style="width:50%; float:left; padding-top:30px;">
							<div id="ratioData">
								<ul>
									<li>총 설비용량<span>13MW</span></li>
									<li>금일 발전량<span>3903kWh</span></li>
									<li>금일 Co2 저감량<span>13Co2</span></li>
									<li>월간 발전량<span>284kWh</span></li>
									<li>누적 발전량<span>133MWh</span></li>
									<li>일계획 발전량<span>4000MWh</span></li>
								</ul>
							</div>
						</div>
						
<!-- 						<div id="proData" style="position:relative;"> -->
<!-- 							<div id="usagePro" style="width:100px; height:100px; float: left;"></div> -->
<!-- 							<div id="genPro" style="width:100px; height:100px; float: left;"></div> -->
<!-- 						</div> -->
						<div id="weatherData" style="position: absolute; bottom:20px; float:left;">현재온도: <span id="nowTemper" style="padding-right: 30px;"></span> 현재습도:<span id="nowHumid"></span><span><input type="button" style="padding-elft: 30px; background-color: cornflowerblue;" onclick="weatherDetail();" value="날씨 상세"></span></div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="indiv der">
						<div class="chart_top clear">
							<h2 class="ntit fl">
								<spring:message code="ewp.site.Device_status" />
								<!-- 장치현황 -->
								<a href="#;" onclick="location.href='/device/deviceGroup.do'"
									style="font-size: 12px;">[이동]</a>
							</h2>
							<div class="time fr" id="updtTimeDevice2">2018-08-12
								11:41:26</div>
						</div>
						<!-- no-data { -->
						<div class="no-data" style="display: none;">
							<span><spring:message
									code="ewp.site.Cannot_device_status_information" /> <!-- 장치현황 정보를 가져올 수 없습니다. --></span>
						</div>
						<!-- } no-data --> 
						<div class="device clear" id="allData">
							<div class="genFlowImg">
								<ul>
									<li><a href="javascript:void(0);"><img src="../img/icon_pv.png" style="position: absolute;margin-left: 75px;margin-top: 10px;"></a></li>
									<li><a href="javascript:void(0);"><img src="../img/icon_bms.png" style="position: absolute;margin-left: 75px;margin-top: 10px;"></a></li>
									<li><a href="javascript:void(0);"><img src="../img/icon_pcs.png" style="position: absolute;margin-left: 75px;margin-top: 10px;"></a></li>
									<li><a href="javascript:void(0);"><img src="../img/icon_ioe.png" style="position: absolute;margin-left: 75px;margin-top: 10px;"></a></li>
								</ul>
							</div>
							<div id="genAllData1" style="float: left; padding-left: 150px; color:white;" >
								
									<label>AC전류-r</label>
									<p id="ac_volt_r">123kW(하드코딩)</p>
									<br>
									<label>AC전류-s</label>
									<p id="ac_volt_s">123Vac(하드코딩)</p>
									<br>
									<label>AC전류-t</label>
									<p id="ac_volt_t">123A(하드코딩)</p>
							</div>
							<div id="genAllData2" style="float: left; padding-left: 150px; color:white;">
									<label>DC전력</label>
									<p id="pv_watt">123kW(하드코딩)</p>
									<br>
									<label>DC전압</label>
									<p id="pv_volt">123Vac(하드코딩)</p>
									<br>
									<label>DC전류</label>
									<p id="pv_curr">123A(하드코딩)</p>
									<br>
									<label>주파수</label>
									<p id="hertz">123Hz(하드코딩)</p>
							</div>
							<div id="genAllData3" style="float: left; padding-left: 150px; color:white;">
									<label>판매량</label>
									<p id="pv_panmae">413kWh(하드코딩)</p>
							</div>
							
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="row">
				<div class="col-sm-12">
					<div class="indiv gen">
						<div class="termToggle">
							<input type="button" value="월간" onclick="draw_genChart();"><!--  임시 -->
							<input type="button" value="연간" onclick="draw_genChart();"><!--  임시 -->
						</div>
						<div class="no-data" style="display: none;">
							<span><spring:message
									code="ewp.site.Cannot_revenue_information" /> <!-- 수익현황 정보를 가져올 수 없습니다. --></span>
						</div>
						<!-- } no-data -->
						<div class="inchart" style="height:30%">
							<div id="accum_chart" style="height: 150px;"></div>
						</div>
						<div class="inchart" style="height:30%">
							<div id="gen_chart" style="height: 150px;"></div>
						</div>
						<div class="inchart" style="height:30%">
							<div id="usage_chart" style="height: 150px;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
    <div id="layerbox" class="weaDtlMng" style="min-width:700px; max-height: 700px;overflow-y: auto;">
        <div class="stit">
        	<h2>날씨 상세정보</h2>        	
			<a href="#;" id="cancelBtnX">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="set_tbl dg_wrap" >
				<form id="weaDtlForm" name="weaDtlForm">
					<div id="weaDtlTbl">
						<div id="todayWeather" style="height:49%;"></div>
						<div id="weatherList" style="height:49%;"></div>
					</div>
				</form>
			</div>
		</div>
		<div class="btn_center">
<!-- 			<a href="#;" class="default_btn w80" id="confirmBtn">적용</a> -->
			<a href="#;" class="cancel_btn w80" id="cancelBtn">취소</a>
		</div>
    </div>