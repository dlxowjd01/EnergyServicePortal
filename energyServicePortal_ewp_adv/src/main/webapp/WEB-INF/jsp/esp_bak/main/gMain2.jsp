<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
		<script type="text/javascript">
		var formData = null;
		var recycleYn = true;
		$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);

		$(function () {
			drowCharts();
			getGroupList(); // 구글주소표시를 위한 그룹목록 조회
// 			fn_cycle();
		});
		
		function fn_cycle() {
			if (recycleYn) {
// 				$('.loading').show();
			}
			
			formData = getGMainSchCollection();
			
			setTimeout(function () {
// 				$(".local_name").text(siteGrp_array[siteGrp_array_idx].get("siteGrpName"));
				
				getGMainAlarmList(formData); // 알람 조회
				getGMainSiteTotalDetail(formData); // 사이트 사용량 총합계 조회
				getGMainSiteList(1); // 사이트 목록 조회
				getGMainUsageList(formData, "today"); // 사용량 조회(금일)
				getGMainUsageList(formData, "month"); // 사용량 조회(월간)
				getGMainUsageList(formData, "year"); // 사용량 조회(연간)
				getGMainPVGenList(formData, "year"); // 발전량 조회(연간)
			}, 500);

			if (recycleYn) {
				setTimeout(function () {
// 					$('.loading').hide();
				}, 1000);
			}
			recycleYn = false;
		}

		function getGMainSchCollection() {
			//	$("#timeOffset").val( (new Date()).getTimezoneOffset() );
			$("#timeOffset").val(timeOffset);

			// 기간 필터
			var today = new Date();
			var startDay;
			var selTerm = $('#selTerm').val();
			if (selTerm == 'day') {
				// 오늘 날짜에 시간 정보만 000000
				startDay = today.format("yyyyMMdd") + "000000";
			} else if (selTerm == 'week') {
				var dt = findWeak(today);
				startDay = dt.format("yyyyMMdd") + "000000";
				//		startDay.setDate(findWeak(today).getYear() , findWeak(today).getMonth(), findWeak(today).getDay()	 );
				// 시간 정보 000000 한 다음에 findWeek에서 연월일 가져와서 설정
			} else if (selTerm == 'month') {
				// 이번달 1일 000000 부터
				var dt = new Date(today.getFullYear(), today.getMonth(), 1, 0, 0, 0);
				startDay = dt.format("yyyyMMddHHmmss");
			}

			queryStart = startDay;
			queryEnd = today.format("yyyyMMddHHmmss");

			$("#selTermFrom").val(queryStart);
			$("#selTermTo").val(queryEnd);
			
			
			var todayFrom = today.format("yyyyMMdd") + "000000";
			var todayTo = today.format("yyyyMMdd") + "235959";
			$("#todayFrom").val(todayFrom);
			$("#todayTo").val(todayTo);
			var monthFrom = new Date(today.getFullYear(), today.getMonth(), 1, 0, 0, 0);
			var monthTo = new Date(today.getFullYear(), today.getMonth(), (new Date(today.getFullYear(), today.getMonth(), 0)).getDate(), 23, 59, 59);
			var yearFrom = new Date(today.getFullYear(), 0, 1, 0, 0, 0);
			var yearTo = new Date(today.getFullYear(), 11, 31, 23, 59, 59);
			$("#monthFrom").val(monthFrom.format("yyyyMMddHHmmss"));
			$("#monthTo").val(monthTo.format("yyyyMMddHHmmss"));
			$("#yearFrom").val(yearFrom.format("yyyyMMddHHmmss"));
			$("#yearTo").val(yearTo.format("yyyyMMddHHmmss"));
			var lastYearMonthFrom = new Date(today.getFullYear()-1, today.getMonth(), 1, 0, 0, 0);
			var lastYearMonthTo = new Date(today.getFullYear()-1, today.getMonth(), (new Date(today.getFullYear(), today.getMonth(), 0)).getDate(), 23, 59, 59);
			var lastYearYearFrom = new Date(today.getFullYear()-1, 0, 1, 0, 0, 0);
			var lastYearYearTo = new Date(today.getFullYear()-1, 11, 31, 23, 59, 59);
			$("#lastYearMonthFrom").val(lastYearMonthFrom.format("yyyyMMddHHmmss"));
			$("#lastYearMonthTo").val(lastYearMonthTo.format("yyyyMMddHHmmss"));
			$("#lastYearYearFrom").val(lastYearYearFrom.format("yyyyMMddHHmmss"));
			$("#lastYearYearTo").val(lastYearYearTo.format("yyyyMMddHHmmss"));
			

			var frm = $("#schForm").serializeObject();
			console.log(frm);
			return frm;
		}

		// 군관리 알람 조회
		function getGMainAlarmList(formData) {
		    $.ajax({
		        url: "/main/getGMainAlarmList.json",
		        type: 'post',
		        async: true,
		        data: formData,
		        success: function (result) {
		        	var dvTpAlarmDetail = result.detail;
					var dvTpAlarmDetail2 = result.detail2;

					$("#todayTotalAlarmCnt").html(dvTpAlarmDetail.total_cnt);
					$("#todayAlarmCnt").html(dvTpAlarmDetail2.alert_cnt);
					$("#todayWarningCnt").html(dvTpAlarmDetail2.warning_cnt);
					if (dvTpAlarmDetail.notCfm_cnt == 0) {
						$(".no").find('span').hide();
					} else {
						$(".no").find('span').show();
						$(".no").empty().append('<span>' + dvTpAlarmDetail.notCfm_cnt + '</span>');
					}
		        }
		    });
		}
		

		// 실제 사용량 조회
		function getGMainUsageList(formData, flag) {
			if(flag == "year" || flag == "month") {
				formData['displayFlag'] = 'gMain';
				formData['yyyy'] = (new Date()).format("yyyy");
			}
			$.ajax({
				url: "/main/getGMainUsageList.json?flag="+flag,
				type: 'post',
// 				async: false, // 동기로 처리해줌
				async: true, 
				data: formData,
				success: function (result) {
					var list = result.list;
					var theadStr = "", tbodyStr = "", dataTable = "", map, map2, $chart = null, tdCnt=0;
					var today = new Date();
					var yyyy = today.format("yyyy");
					var MM = today.format("MM");
					
					if(flag == "today") {
						theadStr = '<tr><th>오늘</th><th>금일 사용량</th></tr>';
						dataTable = "peak_datatable";
						$chart = todayUsageChart;
						tdCnt = 24;
					}
					if(flag == "month") {
						theadStr = '<tr><th>월간</th><th>'+(yyyy-1)+'.'+MM+'</th><th>'+yyyy+'.'+MM+'</th></tr>';
						dataTable = "month_datatable";
						$chart = monthUsageChart;
						tdCnt = 30;
					}
					if(flag == "year") {
						theadStr = '<tr><th>연간</th><th>'+(yyyy-1)+'</th><th>'+yyyy+'</th></tr>';
						dataTable = "year_datatable";
						$chart = yearUsageChart;
						tdCnt = 12;
					}
					
					if(list != null && list.length > 0) {
						if(flag == "today") {
							for(var i=0; i<list.length; i++) {
								map = convertUnitFormat(list[i].usg_val, "Wh", 5);
								tbodyStr += '<tr>';
								tbodyStr += '<th>' + setChartDateUTC(list[i].std_timestamp) + '</th>';
								tbodyStr += '<td>' + toFixedNum(map.get("formatNum"), 2) + '</td>';
								tbodyStr += '</tr>';
							}
						} else {
							var list2 = result.list2;
							for(var i=0; i<list.length; i++) {
								map = convertUnitFormat(list[i].usg_val, "Wh", 5);
								tbodyStr += '<tr>';
								tbodyStr += '<th>' + setChartDateUTC(list[i].std_timestamp) + '</th>';
								if(list2 != null && list2.length > 0) {
									map2 = convertUnitFormat(list2[i].usg_val, "Wh", 5);
									tbodyStr += '<td>' + toFixedNum(map2.get("formatNum"), 2) + '</td>';
								} else {
									tbodyStr += '<td></td>';
								}
								tbodyStr += '<td>' + toFixedNum(map.get("formatNum"), 2) + '</td>';
								tbodyStr += '</tr>';
							}
						}
					} else {
						for(var i=0; i<tdCnt; i++) {
							tbodyStr += '<tr>';
							tbodyStr += '<th></th>';
							tbodyStr += '<td></td>';
							if(flag == "month" || flag == "year") {
								tbodyStr += '<td></td>';
							}
							tbodyStr += '</tr>';
						}
					}
					
					$('#'+dataTable).find('thead').empty().append(theadStr);
					$('#'+dataTable).find('tbody').empty().append(tbodyStr);
					mainSetTickInterval($chart, flag);
					$chart.update({data: {table: dataTable}});
				}
			});
		}

		// 발전량 조회
		function getGMainPVGenList(formData, flag) {
			if(flag == "year" || flag == "month") {
				formData['displayFlag'] = 'gMain';
				formData['yyyy'] = (new Date()).format("yyyy");
			}
			var pastUsageList;
			var usage = null;
			var reUsage = null;
			
			$.ajax({
				url: "/main/getGMainPVGenList.json?flag="+flag,
				type: 'post',
// 				async: false, // 동기로 처리해줌
				async: true,
				data: formData,
				success: function (result) {
					var list = result.list;
					var theadStr = "", tbodyStr = "", dataTable = "", map, map2, $chart = null, tdCnt=0;
					var today = new Date();
					var yyyy = today.format("yyyy");
					var MM = today.format("MM");
					
					if(flag == "year") {
						theadStr = '<tr><th>연간</th><th>누적발전량</th><th>예상발전량</th></tr>';
						dataTable = "power_year_datatable";
						$chart = yearGenChart;
						tdCnt = 12;
					}
					
					if(list != null && list.length > 0) {
						var list2 = result.list2;
						for(var i=0; i<list.length; i++) {
							map = convertUnitFormat(list[i].gen_val, "Wh", 5);
							tbodyStr += '<tr>';
							tbodyStr += '<th>' + setChartDateUTC(list[i].std_date) + '</th>';
							tbodyStr += '<td>' + toFixedNum(map.get("formatNum"), 2) + '</td>';
							if(list2 != null && list2.length > 0) {
								map2 = convertUnitFormat(list2[i].gen_val, "Wh", 5);
								tbodyStr += '<td>' + toFixedNum(map2.get("formatNum"), 2) + '</td>';
							} else {
								tbodyStr += '<td></td>';
							}
							tbodyStr += '</tr>';
						}
					} else {
						for(var i=0; i<tdCnt; i++) {
							tbodyStr += '<tr>';
							tbodyStr += '<th></th>';
							tbodyStr += '<td></td>';
							if(flag == "month" || flag == "year") {
								tbodyStr += '<td></td>';
							}
							tbodyStr += '</tr>';
						}
					}
					
					$('#'+dataTable).find('thead').empty().append(theadStr);
					$('#'+dataTable).find('tbody').empty().append(tbodyStr);
					mainSetTickInterval($chart, flag);
					$chart.update({data: {table: dataTable}});
				}
			});
		}
		
		function mainSetTickInterval($chart, flag) {
			if(flag == "today") {
				$chart.xAxis[0].options.tickInterval = 60 * 60 * 1000;
				$chart.xAxis[0].options.labels.style.fontSize = '16px';
				$chart.xAxis[0].options.endOnTick = false;
			}
			if(flag == "month") {
				$chart.xAxis[0].options.tickInterval = 24 * 60 * 60 * 1000;
				$chart.xAxis[0].options.labels.style.fontSize = '10px';
				$chart.xAxis[0].options.endOnTick = true;
			}
			if(flag == "year") {
				$chart.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;
				$chart.xAxis[0].options.labels.style.fontSize = '10px';
				$chart.xAxis[0].options.endOnTick = false;
			}
		}

		// 군관리 사이트 사용량 총합계 조회
		function getGMainSiteTotalDetail(formData) {
		    $.ajax({
		        url: "/main/getGMainSiteTotalDetail.json",
		        type: 'post',
// 		        async: false, // 동기로 처리해줌
		        async: true,
		        data: formData,
		        success: function (result) {
		        	var total = result.detail;

					if (total != null && total.usage != null) {
						var pre_usg = (total.pre_usg == null) ? 0 : total.pre_usg;
						var map = convertUnitFormat(pre_usg, "Wh");
						
						$('.detailPreUsage').text(numberComma(toFixedNum(map.get("formatNum"), 2)));
						$('.detailPreUsageUnit').text(map.get("unit"));

						var pre_gen = (total.pre_gen == null) ? 0 : total.pre_gen;
						var map2 = convertUnitFormat(pre_gen, "Wh");
						$('.detailPreGen').text(numberComma(toFixedNum(map2.get("formatNum"), 2)));
						$('.detailPreGenUnit').text(map2.get("unit"));
						
						var usage = (total.pre_gen == null) ? 0 : total.usage;
						var map3 = convertUnitFormat(usage, "Wh");
						$('.detailUsage').text(numberComma(toFixedNum(map3.get("formatNum"), 2)));
						$('.detailUsageUnit').text(map3.get("unit"));

						var gen = (total.pre_gen == null) ? 0 : total.gen;
						var map4 = convertUnitFormat(gen, "Wh");
						$('.detailGen').text(numberComma(toFixedNum(map4.get("formatNum"), 2)));
						$('.detailGenUnit').text(map4.get("unit"));

					} else {
						$('.detailPreUsage').text('0');
						$('.detailPreGen').text('0');
						$('.detailUsage').text('0');
						$('.detailGen').text('0');

						$('.detailPreUsageUnit').text('Wh');
						$('.detailPreGenUnit').text('Wh');
						$('.detailUsageUnit').text('Wh');
						$('.detailGenUnit').text('Wh');
					}
		        }
		    });
		}


		// 군관리 사이트 목록 조회
		function getGMainSiteList(selPageNum) {
		    formData['selPageNum'] = selPageNum;
		    $.ajax({
		        url: "/main/getGMainSiteList.json",
		        type: 'post',
// 		        async: false, // 동기로 처리해줌
				async : true,
		        data: formData,
		        success: function (result) {
		        	var siteList = result.list;

					var $tbody = $('#siteTbody');
					var tbodyStr = '';

					if (siteList != null && siteList.length > 0) {
						var imgSrc = '';
						var grpName = '';
						var pagingMap = result.pagingMap;

						for (var i = 0; i < siteList.length; i++) {
							var map = convertUnitFormat(siteList[i].usg, "Wh", 5);
							var map2 = convertUnitFormat(siteList[i].gen, "Wh", 5);

							tbodyStr += '<tr class="dbclickopen" onclick="activateSite(this, \'' + siteList[i].site_id + '\', \'' + siteList[i].site_grp_idx + '\')" ondblclick="goSiteMain(\'' + siteList[i].site_id + '\')">';
							tbodyStr += '<td>' + ((pagingMap.selPageNum - 1) * pagingMap.pageRowCnt + (i + 1)) + '</td>';
							tbodyStr += '<td><div class="">' + '<a style="cursor: pointer;">' + replaceSiteNm(siteList[i].site_name, "*") + '</a>' + '</div></td>';
// 							tbodyStr += '<td>' + siteList[i].alarm_cnt + '</td>';
							tbodyStr += '<td>' + numberComma(toFixedNum(map.get("formatNum"), 2)) + '</td>';
							tbodyStr += '<td>' + numberComma(toFixedNum(map2.get("formatNum"), 2)) + '</td>';
							tbodyStr += '</tr>';
						}

						makePageNums2(pagingMap, "GMainSite");
					} else {
						tbodyStr += '<tr><td colspan="4"><spring:message code="ewp.main.There_is_no_query_results" /></td></tr>';
						$('#GMainSitePaging').empty();
					}

					$tbody.html(tbodyStr);
		        }
		    });
		}

		// 사이트그룹 목록 클릭 시 활성화
		function activateSite(elmt, grpIdx) {
			$('.dbclickopen').removeClass('click');
			$(elmt).addClass('click');
		}

		// 사이트그룹 목록 더블클릭 시 그룹메인으로 이동
		function goSiteMain(site_id) {
			addParameterUrl('siteId', site_id);
		}

		function drowCharts() {
			drowGMainTodayUsageChart();
			drowGMainMonthUsageChart();
			drowGMainYearUsageChart();
			drowGMainYearGenChart();
		}

		function changeTerm(term) {
			recycleYn = true;
			$('#selTerm').val(term);
			fn_cycle();
		}
		</script>
		<script type="text/javascript">
		var siteGrp_array = [];
		function getGroupList(compIdx) {
			$.ajax({
				url : "/setting/getGroupPopupList.json",
				type : 'post',
				async : false, // 동기로 처리해줌
				data : {
					compIdx : compIdx
				},
				success: function(result) {
					var list = result.list;
					
					if(list != null && list.length > 0) {
						for(var i=0; i<list.length; i++) {
							var siteGrpMap = new _Map(); 
							siteGrpMap.put("siteGrpIdx", list[i].site_grp_idx);
							siteGrpMap.put("siteGrpName", list[i].site_grp_name);
							siteGrpMap.put("siteGrpAddr", list[i].site_grp_addr);
							siteGrp_array.push(siteGrpMap);
						}
					}
				}
			});
		}
		
		//사이트 목록(지도표시) 조회
		function getSitePopupList(siteGrpIdx) {
			$.ajax({
				url: "/setting/getSitePopupList.json",
				type: 'post',
				async: false, // 동기로 처리해줌
				data: {
					siteGrpIdx: siteGrpIdx
				},
				success: function (result) {
					var list = result.grpSiteList;
					if(list != null && list.length > 0) {
						for(var i=0; i<list.length; i++) {
							geocodeAddress(geocoder, map, list[i].site_addr, list[i].site_id, list[i].site_name, i);
						}
					}
				}
			});
		}
		
		function geocodeAddress(geocoder, resultsMap, siteAddr, siteId, siteName, i) {
			var address = siteAddr; // document.getElementById('address').value;
			geocoder.geocode({'address': address}, function(results, status) {
				if (status === 'OK') {
					resultsMap.setCenter(results[0].geometry.location);
					var marker = new google.maps.Marker({
						map: resultsMap,
						title: siteName,
						position: results[0].geometry.location
					});
// 					google.maps.event.addListener(marker, 'click', (function(marker, i) {
// 							return function() {
// 								$(".bx-stop").trigger('click');
// 							}
// 						})(marker, i));
				} else {
					map.setCenter({lat: 37.549012, lng: 126.988546});
					console.log('Geocode was not successful for the following reason: ' + status);
				}
			});
		}
		</script>

	<!-- 메인페이지용 스타일/스크립트 파일 -->
	<link type="text/css" href="../css/custom.css" rel="stylesheet">
	<!-- <script type="text/javascript" src="../js/jquery.bxslider.js"></script> -->
	<script type="text/javascript" src="../js/modules/rounded-corners.js"></script>
	<script type="text/javascript" src="../js/jquery.rwdImageMaps.min.js"></script>

				<form id="schForm" name="schForm">
					<input type="hidden" id="selTermFrom" name="selTermFrom"/>
					<input type="hidden" id="selTermTo" name="selTermTo"/>
					<input type="hidden" id="selTerm" name="selTerm" value="day"/>
					<input type="hidden" id="selPeriodVal" name="selPeriodVal" value="hour">
					<input type="hidden" id="siteGrpIdx" name="siteGrpIdx" value="${selViewSiteGrpIdx }">
					<input type="hidden" id="grpIdx" name="grpIdx" value=""/>
					<input type="hidden" id="timeOffset" name="timeOffset"/>
					<input type="hidden" id="todayFrom" name="todayFrom">
					<input type="hidden" id="todayTo" name="todayTo">
					<input type="hidden" id="monthFrom" name="monthFrom">
					<input type="hidden" id="monthTo" name="monthTo">
					<input type="hidden" id="yearFrom" name="yearFrom">
					<input type="hidden" id="yearTo" name="yearTo">
					<input type="hidden" id="lastYearMonthFrom" name="lastYearMonthFrom">
					<input type="hidden" id="lastYearMonthTo" name="lastYearMonthTo">
					<input type="hidden" id="lastYearYearFrom" name="lastYearYearFrom">
					<input type="hidden" id="lastYearYearTo" name="lastYearYearTo">
				</form>
				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_alarm">
									<div class="chart_top clear">
										<h2 class="ntit">알람</h2>
										<div class="fr today_alarm">
											<div class="total">금일발생 <span id="todayTotalAlarmCnt">0</span></div>
											<div class="no"><span style="display:none">0</span></div>
										</div>
									</div>
									<div class="alarm_stat mt20 clear">
										<div class="a_alert clear">
											<span>ALERT</span>
											<em id="todayAlarmCnt">0</em>
										</div>
										<div class="a_warning clear">
											<span>WARNING</span>
											<em id="todayWarningCnt">0</em>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_chart">
									<div class="chart_top clear">
										<h2 class="ntit">금일 사용량</h2>
									</div>
									<div class="inchart">
										<div id="gchart1" style="height:125px;"></div>
										<script language="JavaScript"> 
										var todayUsageChart = null;
// 										$(function () { 
										function drowGMainTodayUsageChart() {
											todayUsageChart = Highcharts.chart('gchart1', {
												data: {
													table: 'peak_datatable' /* 테이블에서 데이터 불러오기 */
												},

												chart: {
													marginTop:20,
													marginLeft:50,
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
													type: 'datetime', // 2019.10.30 이우람 추가
													dateTimeLabelFormats: { // 2019.10.30 이우람 추가
														millisecond: '%H:%M:%S.%L',
														second: '%H:%M:%S',
														minute: '%H:%M',
														hour: '%H',
														day: '%m.%d ',
														week: '%m.%e',
														month: '%y/%m',
														year: '%Y'
													},
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													plotLines: [{
									            color: '#515562',
									            width: 1
									        }],
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
													plotLines: [{
									            color: '#515562',
									            width: 1
									        }],
													min: 0, /* 최소값 지정 */
													title: {
														text: '(kWh)',
														align: 'low',
														rotation: 0, /* 타이틀 기울기 */
														y:25, /* 타이틀 위치 조정 */
														x:10,
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													labels: {
														overflow: 'justify',
														x:-10, /* 그래프와의 거리 조정 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													}
												},

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-33,
													itemStyle: {
														color: '#fff',
														fontSize: '12px',
														fontWeight: 400
													},
													itemHoverStyle: {
														color: '' /* 마우스 오버시 색 */
													},
													symbolPadding:3, /* 심볼 - 텍스트간 거리 */
													symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													formatter: function() {
														return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) + '<br/><span style="color:#6984ed">' + this.y + ' kWh</span>';
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
													name: '금일 사용량',
													color: '#6984ed', /* 최대 피크 전력 */
													type: 'column'
												}],

												/* 반응형 */
												responsive: {
													rules: [{
														condition: {
															minWidth: 842 /* 차트 사이즈 */
														},
														chartOptions: {
															chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															yAxis: {
																title: {
																	style: {
																		fontSize: '18px'
																	}
																},
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															legend: {
																itemStyle: {
																	fontSize: '18px'
																},
																symbolPadding:5,
																symbolHeight:10
															}
														}
													}]
												}

											});
										}
// 										});
										</script>
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="peak_datatable">
												<thead>
													<tr>
														<th>2018-08</th>
														<th>금일 사용량</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>
									<div class="chart_top clear">
										<h2 class="ntit">월간 사용량</h2>
									</div>
									<div class="inchart">
										<div id="gchart2" style="height:125px;"></div>
										<script language="JavaScript">
										var monthUsageChart = null;
// 										$(function () {
										function drowGMainMonthUsageChart() {
											monthUsageChart = Highcharts.chart('gchart2', {
												data: {
													table: 'month_datatable' /* 테이블에서 데이터 불러오기 */
												},

												chart: {
													marginTop:20,
													marginLeft:50,
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
													type: 'datetime', // 2019.10.30 이우람 추가
													dateTimeLabelFormats: { // 2019.10.30 이우람 추가
														millisecond: '%H:%M:%S.%L',
														second: '%H:%M:%S',
														minute: '%H:%M',
														hour: '%H',
														day: '%m.%d ',
														week: '%m.%e',
														month: '%y/%m',
														year: '%Y'
													},
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
													min: 0, /* 최소값 지정 */
													title: {
														text: '(kWh)',
														align: 'low',
														rotation: 0, /* 타이틀 기울기 */
														y:25, /* 타이틀 위치 조정 */
														x:10,
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													labels: {
														overflow: 'justify',
														x:-10, /* 그래프와의 거리 조정 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													}
												},

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-33,
													itemStyle: {
														color: '#fff',
														fontSize: '12px',
														fontWeight: 400
													},
													itemHoverStyle: {
														color: '' /* 마우스 오버시 색 */
													},
													symbolPadding:3, /* 심볼 - 텍스트간 거리 */
													symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													formatter: function() {
														return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) + '<br/><span style="color:#6984ed">' + this.y + ' kWh</span>';
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
											    	type: 'line',
											    	name: '작년',
											        color: '#84848f'
											    },{
											    	type: 'column',
											    	name: '올해',
											        color: '#6984ed'
											    }],

												/* 반응형 */
												responsive: {
													rules: [{
														condition: {
															minWidth: 842 /* 차트 사이즈 */
														},
														chartOptions: {
															chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															yAxis: {
																title: {
																	style: {
																		fontSize: '18px'
																	}
																},
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															legend: {
																itemStyle: {
																	fontSize: '18px'
																},
																symbolPadding:5,
																symbolHeight:10
															}
														}
													}]
												}

											});
										}
// 										});
										</script>
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="month_datatable">
												<thead>
													<tr>
														<th>월간</th>
														<th>2018.10</th>
														<th>2019.10</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>
									<div class="chart_top clear">
										<h2 class="ntit">연간 사용량</h2>
									</div>
									<div class="inchart">
										<div id="gchart3" style="height:125px;"></div>
										<script language="JavaScript"> 
										var yearUsageChart = null;
// 										$(function () { 
										function drowGMainYearUsageChart() {
											yearUsageChart = Highcharts.chart('gchart3', {
												data: {
													table: 'year_datatable' /* 테이블에서 데이터 불러오기 */
												},

												chart: {
													marginTop:20,
													marginLeft:50,
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
													type: 'datetime', // 2019.10.30 이우람 추가
													dateTimeLabelFormats: { // 2019.10.30 이우람 추가
														millisecond: '%H:%M:%S.%L',
														second: '%H:%M:%S',
														minute: '%H:%M',
														hour: '%H',
														day: '%m.%d ',
														week: '%m.%e',
														month: '%y/%m',
														year: '%Y'
													},
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
													min: 0, /* 최소값 지정 */
													title: {
														text: '(kWh)',
														align: 'low',
														rotation: 0, /* 타이틀 기울기 */
														y:25, /* 타이틀 위치 조정 */
														x:10,
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													labels: {
														overflow: 'justify',
														x:-10, /* 그래프와의 거리 조정 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													}
												},

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-33,
													itemStyle: {
														color: '#fff',
														fontSize: '12px',
														fontWeight: 400
													},
													itemHoverStyle: {
														color: '' /* 마우스 오버시 색 */
													},
													symbolPadding:3, /* 심볼 - 텍스트간 거리 */
													symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													formatter: function() {
														return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) + '<br/><span style="color:#6984ed">' + this.y + ' kWh</span>';
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
											    	type: 'line',
											    	name: '작년',
											        color: '#84848f'
											    },{
											    	type: 'column',
											    	name: '올해',
											        color: '#6984ed'
											    }],

												/* 반응형 */
												responsive: {
													rules: [{
														condition: {
															minWidth: 842 /* 차트 사이즈 */
														},
														chartOptions: {
															chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															yAxis: {
																title: {
																	style: {
																		fontSize: '18px'
																	}
																},
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															legend: {
																itemStyle: {
																	fontSize: '18px'
																},
																symbolPadding:5,
																symbolHeight:10
															}
														}
													}]
												}

											});
										}
// 										});
										</script>
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="year_datatable">
												<thead>
													<tr>
														<th>연간</th>
														<th>2018</th>
														<th>2019</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>
									<div class="chart_top clear">
										<h2 class="ntit">연간 발전량</h2>
									</div>
									<div class="inchart">
										<div id="gchart4" style="height:125px;"></div>
										<script language="JavaScript"> 
										var yearGenChart = null;
// 										$(function () { 
										function drowGMainYearGenChart() {
											yearGenChart = Highcharts.chart('gchart4', {
												data: {
													table: 'power_year_datatable' /* 테이블에서 데이터 불러오기 */
												},

												chart: {
													marginTop:20,
													marginLeft:50,
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
													type: 'datetime', // 2019.10.30 이우람 추가
													dateTimeLabelFormats: { // 2019.10.30 이우람 추가
														millisecond: '%H:%M:%S.%L',
														second: '%H:%M:%S',
														minute: '%H:%M',
														hour: '%H',
														day: '%m.%d ',
														week: '%m.%e',
														month: '%y/%m',
														year: '%Y'
													},
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													labels: {
														align: 'center',
														y:27, /* 그래프와 거리 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
													title: {
														text: null
													}
												},

												yAxis: {
													lineColor: '#515562', /* 눈금선색 */
													tickColor: '#515562',
													gridLineColor: '#515562',
													gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
													min: 0, /* 최소값 지정 */
													title: {
														text: '(kWh)',
														align: 'low',
														rotation: 0, /* 타이틀 기울기 */
														y:25, /* 타이틀 위치 조정 */
														x:10,
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													},
													labels: {
														overflow: 'justify',
														x:-10, /* 그래프와의 거리 조정 */
														style: {
															color: '#fff',
															fontSize: '12px'
														}
													}
												},

												/* 범례 */
												legend: {
													enabled: true,
													align:'right',
													verticalAlign:'top',
													x:18,
													y:-33,
													itemStyle: {
														color: '#fff',
														fontSize: '12px',
														fontWeight: 400
													},
													itemHoverStyle: {
														color: '' /* 마우스 오버시 색 */
													},
													symbolPadding:3, /* 심볼 - 텍스트간 거리 */
													symbolHeight:7 /* 심볼 크기 */
												},

												/* 툴팁 */
												tooltip: {
													formatter: function() {
														return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x)) + '<br/><span style="color:#6984ed">' + this.y + ' kWh</span>';
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
											    	type: 'column',
											    	name: '누적발전량',
											        color: '#6984ed' /* 누적 발전량 */
											    },{
											    	type: 'column',
											    	name: '예상발전량',
											        color: '#f75c4a' /* 예상 발전량 */
											    }],

												/* 반응형 */
												responsive: {
													rules: [{
														condition: {
															minWidth: 842 /* 차트 사이즈 */
														},
														chartOptions: {
															chart: {
																marginLeft:75
															},
															xAxis: {
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															yAxis: {
																title: {
																	style: {
																		fontSize: '18px'
																	}
																},
																labels: {
																	style: {
																		fontSize: '18px'
																	}
																}
															},
															legend: {
																itemStyle: {
																	fontSize: '18px'
																},
																symbolPadding:5,
																symbolHeight:10
															}
														}
													}]
												}

											});
										}
// 										});
										</script>
										<!-- 데이터 추출용 -->
										<div class="chart_table2" style="display:none;">			
											<table id="power_year_datatable">
												<thead>
													<tr>
														<th>연간</th>
														<th>누적발전량</th>
														<th>예상발전량</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">

								<!-- 지역별 사용량 //-->
								<div class="indiv gmain_map">
									<div class="chart_top clear">
										<h2 class="ntit">그룹</h2>
									</div>
									<div class="play_btn">
										<a href="#" class="gmain_btn gm_pause">고정</a>
										<a href="#" class="gmain_btn gm_play">로테이션</a>
									</div>
									<!-- 지도 슬라이드 -->
									<ul class="slide_map">
										<li>
											<div class="map_wrap" id="gMainMap">
												<!-- <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3163.905015323875!2d127.1457876512152!3d37.53373627970492!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x357cb0203aca6461%3A0x67f7fcc6e112590c!2z6ri464-Z7ZWc7IaU7IaU7YyM7YGs!5e0!3m2!1sko!2skr!4v1571636948271!5m2!1sko!2skr" width="100%" height="100%" frameborder="0" style="border:0;" allowfullscreen=""></iframe> -->
											</div>
										</li>
										<script type="text/javascript">
										var map = new google.maps.Map(document.getElementById('gMainMap'), {
										    zoom: 15,
										    mapTypeControl: false, //맵타입
										    streetViewControl: false, //스트리트뷰
										    fullscreenControl: false, //전체보기
										    center: {lat: 37.549012, lng: 126.988546} // center: new google.maps.LatLng(37.549012, 126.988546),
										  });
										var geocoder = new google.maps.Geocoder();
										var infowindow = new google.maps.InfoWindow();
										</script>
									</ul>
									<!-- 지도정보 -->
									<div class="local_info allmap">
										<h2 class="local_name"></h2>
										<div class="clear">
											<ul>
												<li><strong>사용량(예상)</strong> <span class="detailPreUsage">0</span> <em class="detailPreUsageUnit">kWh</em></li>
												<li><strong>발전량(예상)</strong> <span class="detailPreGen">0</span> <em class="detailPreGenUnit">kWh</em></li>
											</ul>
											<ul>
												<li><strong>사용량(누적)</strong> <span class="detailUsage">0</span> <em class="detailUsageUnit">kWh</em></li>
												<li><strong>발전량(누적)</strong> <span class="detailGen">0</span> <em class="detailGenUnit">kWh</em></li>
											</ul>
										</div>
									</div>
								</div>
								<!-- // 지역별 사용량 -->

							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_table">
									<div class="term_menu clear">
										<ul>
											<li class="on"><a href="javascript:changeTerm('day');">오늘</a></li>
											<li><a href="javascript:changeTerm('week');">이번주</a></li>
											<li><a href="javascript:changeTerm('month');">이번달</a></li>
										</ul>
										<ol>
											<li>
												<a href="/main/seoulMain.do" class="gmain_btn">서울시</a>
											</li>
											<li>
												<a href="#" class="gmain_btn on">사이트</a>
											</li>
										</ol>
									</div>
									<div class="gtbl_wrap">
										<table>
											<colgroup>
												<col width="80">
												<col>
												<col>
												<col width="120">
												<col width="120">
											</colgroup>
										    <thead>
										      <tr>
										      	<th>번호</th>
										        <th>사이트</th>
										        <!-- <th>알람건수</th> -->
										        <th>사용량(kWh)</th>
										        <th>발전량(kWh)</th>
										      </tr>
										    </thead>
										    <tbody id="siteTbody">
										    	<tr><td colspan="4">조회 결과가 없습니다.</td></tr>
										    </tbody>
										</table>
									</div>
									<div class="paging clear" id="GMainSitePaging">
										<a href="#;" class="prev">PREV</a>
										<span><strong>1</strong> / 3</span>
										<a href="#;" class="next">NEXT</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<script type="text/javascript">
					var monitoring_cycle_7sec = null; // 지도 변경 스레드ID
					var done = false; // 스레드 작동 여부
					var siteGrp_array_idx = 0; // 그룹 array 인덱스
					
					$(function () {
						$(".gmain_map .gm_play").bind("click", function(e){
							cycleStart();
				        });
						$(".gmain_map .gm_pause").bind("click", function(e){
							cycleStop();
				        });
						
						setTimeout(function () {
							var selGrp = '${selViewSiteGrpIdx }';
							if(selGrp != null && selGrp != "") {
								$.each(siteGrp_array, function (index, item) {
									if(selGrp == item.get("siteGrpIdx")) {
										siteGrp_array_idx = index;
										return;
									}
								});
							}
							
							rotation(selGrp);
							siteGrp_array_idx++;
// 							readData();
						}, 500);
					});

					function readData() {
						if (done) return;
						recycleYn = true;
						
						if(siteGrp_array_idx == siteGrp_array.length) {
							siteGrp_array_idx = 0;
						}
						
						rotation(siteGrp_array[siteGrp_array_idx].get("siteGrpIdx"));
						
						setTimeout(function () {
							siteGrp_array_idx++;
							monitoring_cycle_5sec = setTimeout(readData, 7000); /* 7초 간격 */
						}, 1000);
					}
					
					function rotation(siteGrpIdx) {
						$("#siteGrpIdx").val(siteGrpIdx);
						
						$(".local_name").text(siteGrp_array[siteGrp_array_idx].get("siteGrpName"));
						getSitePopupList(siteGrpIdx);
						
						fn_cycle();
					}
					
					function cycleStart() {
						console.log("cycleStart");
						done = false;
						readData();
					}
					
					function cycleStop() {
						console.log("cycleStop");
						done = true;
					}
				</script>