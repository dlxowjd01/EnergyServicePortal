<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="container-fluid">
	<div class="row header-wrapper">
		<div class="col-12">
			<h1 class="page-header fl">${siteName}</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime"></em>
				<span>DATA BASE TIME</span>
				<em class="dbTime"></em>
			</div>
		</div>
	</div>
	<div class="row content-wrapper">
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv smain_pv clear">
				<div class="chart_top clear">
					<h2 class="ntit">월별 발전량 종합</h2>
					<h1 class="stit">
						<fmt:parseDate var="startPrint" value="${startMonth }" pattern="yyyyMMddHHmmss"/>
						<fmt:parseDate var="endPrint" value="${startTime }" pattern="yyyyMMddHHmmss"/>

						<fmt:formatDate value="${startPrint}" pattern="yyyy.MM.dd"/>
						~
						<fmt:formatDate value="${endPrint}" pattern="yyyy.MM.dd"/>
					</h1>
				</div>
				<div class="chart_mid clear">
					<div class="box">
						<div class="line1">이번달 총 발전량</div>
						<div class="line2" id="monthEnergyValue"></div>
						<div class="line3" id="diffMonthEnergyValue"></div>
					</div>
					<div class="box">
						<div class="line1">올해 누적 발전량</div>
						<div class="line2" id="yearEnergyValue"></div>
						<div class="line3" id="diffYearEnergyValue"></div>
					</div>
					<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
					<div class="box type">
						<span class="tx_tit">그래프 옵션</span>
						<div class="sa_select">
							<div class="dropdown" id="chartType">
								<button type="button" class="dropdown-toggle w8" data-toggle="dropdown">
									PR<span class="caret"></span>
								</button>
								<ul class="dropdown-menu rdo_type" role="menu">
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t1" name="radio_t" value="1" checked>
											<label for="radio_t1">PR</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t2" name="radio_t" value="2">
											<label for="radio_t2">발전시간</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="radio_t3" name="radio_t" value="3">
											<label for="radio_t3">매전량</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					</c:if>
				</div>
				<div class="smain inchart">
					<div id="schart1"></div>
				</div>
			</div>
			<div class="indiv smain_cal">
				<div class="chart_top clear">
					<h2 class="ntit">이 달의 발전 달력</h2>
					<h1 class="stit">
						<fmt:parseDate var="sDate" value="${startDate}" pattern="yyyyMMddHHmmss"/>
						<fmt:parseDate var="eDate" value="${startTime}" pattern="yyyyMMddHHmmss"/>
						<fmt:formatDate var="sDt" pattern="yyyy-MM-dd" value="${sDate}"/>
						<fmt:formatDate var="eDt" pattern="yyyy-MM-dd" value="${eDate}"/>
						<em>${sDt} ~ ${eDt}</em>
					</h1>
				</div>
				<div class="calendar_wrap">
					<table class="calendar">
						<tr>
							<th>일</th>
							<th>월</th>
							<th>화</th>
							<th>수</th>
							<th>목</th>
							<th>금</th>
							<th>토</th>
						</tr>

						<c:forEach var="week" items="${calList}">
							<tr>
								<c:forEach var="day" items="${week }">
									<c:choose>
										<c:when test="${day ne 0 }">

											<td <c:if test="${nowDay eq day }">class="today"</c:if>>
												<div>
													<em class="calWeatherDay fl day">${day }</em>
													<em id="calWeatherValue_${day }" class="fr"></em>
												</div>
												<div>
													<div id="calWeatherIcon_${day }" class="wicon"></div>
												</div>
												<span id="calEnergyValue_${day }"></span>
											</td>

										</c:when>
										<c:otherwise>
											<td class="disabled">
											</td>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</tr>
						</c:forEach>

						<%--
							<i class="ico_weather w1"></i> 	1	- 맑음 o
							<i class="ico_weather w2"></i>   	- 바람 x
							<i class="ico_weather w3"></i>	20	- 안개 o
							<i class="ico_weather w4"></i>	7	- 흐림 o
							<i class="ico_weather w5"></i>	 	- 바람/비 x
							<i class="ico_weather w6"></i>	13	- 비또는눈 o
							<i class="ico_weather w7"></i>  	- 구름/바람/비 x
							<i class="ico_weather w8"></i>	11	- 눈 o
							<i class="ico_weather w9"></i>	17	- 천둥번개 o
							<i class="ico_weather w10"></i>	12 - 가끔눈 o
						--%>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv gmain_map smain_circle">
				<div class="chart_top clear">
					<h2 class="ntit">${siteName } <c:if test="${empty siteName }">사업소 현황</c:if></h2>
					<div class="btn_bx_type">
						<a href="javascript:void(0);" class="btn cancel_btn" id="cctv">CCTV 보기</a>
					</div>
				</div>
				<div class="chart_box">
					<div class="chart_info">
						<div class="ci_left">
							<div class="inchart">
								<div id="pie_chart" style="height:200px; width:230px"></div>
							</div>
						</div>
						<div class="ci_right">
							<div class="legend_wrap">
								<span class="bu1">태양광</span>
								<span class="bu4">미 사용량</span>
							</div>
							<ul>
								<c:choose>
									<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
										<li><strong>목표출력</strong> <span id="siteCapacity">-</span><em>kW</em></li>
										<li><strong>수신시간</strong> <span id="siteDcPower">-</span></li>
										<li><strong>송신시간</strong> <span id="siteAcPower">-</span></li>
									</c:when>
									<c:otherwise>
										<li><strong>총 설비용량</strong> <span id="siteCapacity">-</span><em>kW</em></li>
										<li><strong>실시간 DC입력</strong> <span id="siteDcPower">-</span><em>kW</em></li>
										<li><strong>실시간 AC출력</strong> <span id="siteAcPower">-</span><em>kW</em></li>
									</c:otherwise>
								</c:choose>

							</ul>
						</div>
					</div>
				</div>
				<div class="local_info smain s_center">
					<table>
						<c:choose>
							<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
						<thead>
						<tr>
							<th>설비 용량</th>
							<th>금일 누적 발전량</th>
							<th>전일 누적 발전량</th>
							<th>금일 발전 시간</th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td><em>&nbsp;&nbsp;kW</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;H</em></td>
						</tr>
						</tbody>
							</c:when>
							<c:otherwise>
						<thead>
						<tr>
							<th>PV 용량</th>
							<th>금일 누적 발전량</th>
							<th>금일 발전 예측량</th>
							<th>SMP 수익 예상</th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td><em>&nbsp;&nbsp;kW</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;kWh</em></td>
							<td><em>&nbsp;&nbsp;천원</em></td>
						</tr>
						</tbody>
							</c:otherwise>
						</c:choose>
					</table>
				</div>
			</div>
			<div class="indiv gmain_map smain_circle">
				<div class="chart_top clear">
					<h2 class="ntit">금일 발전현황</h2>
				</div>
				<div class="sa_wrap">
					<div class="inchart">
						<div id="schart2"></div>
					</div>
				</div>
			</div>
			<div class="indiv smain weather">
				<div class="chart_top clear">
					<h2 class="ntit">기상 정보</h2>
					<h1 class="stit">${nowTime }</h1>
				</div>
				<div class="weater_wrap clear">
					<div class="fl wt_table_wrap">
						<!-- 날씨관련 아이콘 클래스명 확인 -->
						<!-- https://fontawesome.com/icons?d=gallery&q=weather&m=free -->
						<dl class="wt_table">
							<dt>
								<span id="weekIcon"></span>
								<strong> - </strong>
								<em id="weekTemp"></em>
							</dt>
							<dd class="dd_tbl">
								<table>
									<tr>
										<th>오늘</th>
										<th>내일</th>
										<th>모레</th>
									</tr>
									<tr>
										<td><span id="weekIcon_1"></span></td>
										<td><span id="weekIcon_2"></span></td>
										<td><span id="weekIcon_3"></span></td>
									</tr>
									<tr>
										<td id="weekTemp_1"></td>
										<td id="weekTemp_2"></td>
										<td id="weekTemp_3"></td>
										<td id="weekTemp_4"></td>
										<td id="weekTemp_5"></td>
										<td id="weekTemp_6"></td>
										<td id="weekTemp_7"></td>
									</tr>
								</table>
							</dd>
						</dl>
					</div>
					<div class="fr wt_list_wrap">
						<ul class="list_type">
							<li><strong>풍향</strong> <span id="weekWindvelocity">-</span> &deg;</li>
							<li><strong>풍속</strong> <span id="weekWindspeed"></span></li>
							<li><strong>습도</strong> <span id="weekHum"></span></li>
							<%--								<li><strong>경사일사량</strong><span> - kWh/㎡․day</span></li>--%>
							<%--								<li><strong>수평일사량</strong><span> - kWh/㎡․day</span></li>--%>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-4 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv smain_alarm wrap_type">
				<div class="alarm_stat clear">
					<div class="a_alert"><span>금일 발생 오류</span><em>0</em></div>
					<div class="a_warning"><a href="javascript:void(0);" onclick="pageMove('', 'alarm');" class="btn cancel_btn">상세보기</a></div>
				</div>
				<div class="alarm_notice">
					<ul id="alarmNotice">
						<li>
							<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');" class="[level]">
								<span class="err_msg">[site_name] - [message]</span>
								<span class="err_time">[standardTime]</span>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<div class="indiv gmain_table smain wrap_type">
				<div class="gtbl_top clear">
					<div class="fl">
						<input type="text" class="input" name="keyword" value="" placeholder="키워드">
					</div>
					<div class="fr">
						<span class="tx_tit">설비 상태</span>
						<div class="sa_select">
							<div class="dropdown" id="statusDevice">
								<button type="button" class="dropdown-toggle w8" data-toggle="dropdown" data-name="선택">
									전체 <span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu">
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="0" checked>
											<label for="deviceStatus1">중지</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="1" checked>
											<label for="deviceStatus2">정상</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="deviceStatus3" name="deviceStatus" value="2" checked>
											<label for="deviceStatus3">트립</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				<ul class="type_list" id="typeList">
					<li class="[type]">
						<div class="chart_top clear">
							<h2 class="ntit">[name] (<span>0</span>)</h2>
							<div class="alert_icon fr">
								<span class="inv_normal">정상 (<span>0</span>)</span>
								<span class="inv_error">트립 (<span>0</span>)</span>
								<span class="inv_alert">중지 (<span>0</span>)</span>
							</div>
						</div>
						<div class="type_list_detail">
							<div class="tbl_type">
								[head]
							</div>
							<div class="gtbl_wrap type">
								<div class="intable">
									[body]
								</div>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		<%-- 키워드 검색 --%>
		$('input[name="keyword"]').on('keyup', function(e) {
			if (e.which == '13') {
				deviceInfoList();
			}
		});

		setInitList('alarmNotice'); //알람 공지 세팅
		setInitList('typeList'); //설비 리스트 세팅

		if (!isEmpty(siteList)) {
			siteList.forEach(site => {
				if (isEmpty(site.cctv)) {
					$('#cctv').addClass('hidden');
				} else {
					$('#cctv').attr('href', site.cctv);
				}
			});
		}

		deviceProperties();
		meteorological(); //기상정보
		nowEnergy();

		fn_cycle_1min();
		fn_cycle_15min();

		setInterval(() => fn_cycle_1min(), 60 * 1000);
		setInterval(() => fn_cycle_15min(), 15 * 60 * 1000);
	});

	const pollingTerm = 1000 * 60 * 15;
	const siteId = '${sid}';
	const siteList = JSON.parse('${siteList}');

	const apiEnergySite = '/energy/sites';
	const apiEnergyNowSite = '/energy/now/sites';
	const apiWeather = '/weather/site';
	const apiForecastingSite = '/energy/forecasting/sites';
	const apiStatusRawSite = '/status/raw/site';
	const apiStatusRaw = '/status/raw';
	const apiConfigDeivce = '​/config/devices';
	const apiDeviceProperties = '/config/view/device_properties';
	let first = true;

	const fn_cycle_1min = () => {
		getAlarmInfo(); //금일발생오류
		getTodayTotalDetail(); //현재 출력
		toDayGeneration(); //금일 발전현황

		if (!first) {
			deviceInfoList();
		}
	}

	const fn_cycle_15min = () => {
		chargeChartPoll(); //월별 발전량 종합
		getWCalendarEnergyData(); //이 달의 발전 달력
	}

	const rtnDropdown = ($selectId) => {
		if ($selectId == 'chartType') {
			chargeChartPoll();
		} else if ($selectId == 'statusDevice') {
			deviceInfoList();
		}
	}

	const nowEnergy = () => {
		let nowEnergyDay = {
			url: apiHost + apiEnergyNowSite,
				type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'day'
			}
		};

		let nowEnergyMonth = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'month'
			}
		};

		let nowEnergyYear = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'year'
			}
		}

		$.when($.ajax(nowEnergyMonth), $.ajax(nowEnergyYear))
		.done(function (nowEnergyMonthData, nowEnergyYearData) {
			if (nowEnergyYearData[1] == 'success') {
				if (!isEmpty(nowEnergyYearData[0].data[siteId]) && !isEmpty(nowEnergyYearData[0].data[siteId].energy)) {
					let yearData = nowEnergyYearData[0].data[siteId].energy;
					yearData = displayNumberFixedDecimal(yearData, 'Wh', 3, 2);

					$('#yearEnergyValue').html('<span class="pv">' + yearData[0] + '</span><em>' + yearData[1] + '</em>');
				} else {
					$('#yearEnergyValue').html('<span class="pv"> - </span><em></em>');
				}
			}

			if(nowEnergyMonthData[1] == 'success') {
				if (!isEmpty(nowEnergyMonthData[0].data[siteId]) && !isEmpty(nowEnergyMonthData[0].data[siteId].energy)) {
					let monthData = nowEnergyMonthData[0].data[siteId].energy;
					monthData = displayNumberFixedDecimal(monthData, 'Wh', 3, 2);

					$('#monthEnergyValue').html('<span class="pv">' + monthData[0] + '</span><em>' + monthData[1] + '</em>');
				} else {
					$('#monthEnergyValue').html('<span class="pv"> - </span><em></em>');
				}
			}

		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
			$("#errMsg").text("처리 중 오류가 발생했습니다.");
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			// alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}


	//설비 속성 템플릿
	const featureProperties = new Object();
	const featurePropertiesSub = new Object();
	const deviceProperties = () => {
		$.ajax({
			url: apiHost + apiDeviceProperties,
			type: 'get',
			dataType: 'json',
			data: {},
		}).done(function (data, textStatus, jqXHR) {
			$.map(data, function (val, key) {
				let deviceName = key;
				let propList = val.properties;
				let tempFeature = new Array();
				let tempFeature2 = new Array();

				$.map(propList, function (v, k) {
					if (v.dashboard_head) {
						let tempObj = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;

						tempObj['key'] = k;
						tempObj['value'] = propName;
						tempObj['suffix'] = unit;
						tempObj['reducer'] = v.dashboard_head_reducer;
						tempFeature.push(tempObj);

						featureProperties[deviceName] = {
							name: propName,
							prop: tempFeature
						};
					}

					if (v.dashboard_detail) {
						let tempObj2 = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;

						tempObj2['key'] = k;
						tempObj2['value'] = propName;
						tempObj2['suffix'] = unit;
						tempFeature2.push(tempObj2);

						featurePropertiesSub[deviceName] = {
							name: propName,
							prop: tempFeature2
						};
					}
				});
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			let r = JSON.parse(jqXHR.responseText);
			console.log("에러코드:" + jqXHR.status + "\n" + "메세지: " + r);
			$("#errMsg").text("처리 중 오류가 발생했습니다.");
			$("#errorModal").modal("show");
			setTimeout(function(){
				$("#errorModal").modal("hide");
			}, 2000);
			// alert('처리 중 오류가 발생했습니다.');
			return false;
		}).always(function(jqXHR, textStatus) {
			deviceInfoList();
			first = false;
		});
	};

	const deviceSearch = (dname, operation) => {
		let searchBoolean = true,
			keyoard = $('input[name="keyword"]').val().trim();

		const deviceStatusArray = $.makeArray(
			$(':checkbox[name="deviceStatus"]:checked').map(
				function () {
					return $(this).val();
				}
			)
		);

		if (keyoard != '') {
			if(dname.toUpperCase().match(keyoard.toUpperCase())) {
				if ($.inArray(String(operation), deviceStatusArray) >= 0) {
					searchBoolean = true;
				} else {
					searchBoolean = false;
				}
			} else {
				searchBoolean = false;
			}
		} else {
			if ($.inArray(String(operation), deviceStatusArray) >= 0) {
				searchBoolean = true;
			} else {
				searchBoolean = false;
			}
		}

		return searchBoolean;
	}

	const deviceInfoList = () => {
		let deviceArray = new Array();
		if (!isEmpty(siteList[0].devices)) {
			siteList[0].devices.forEach(el => {
				deviceArray.push(el.did);
			});
		}

		if(deviceArray.length > 0) {
			$.ajax({
				url: apiHost + apiStatusRaw,
				type: 'get',
				dataType: 'json',
				data: {
					dids: deviceArray.toString()
				}
			}).done(function (data, textStatus, jqXHR) {
				let deviceType = new Array();
				$.map(data, function(val, key) {
					if ($.inArray(val.device_type, deviceType) === -1) {
						if (val.device_type == 'SM_MANUAL') return false;
						deviceType.push(val.device_type);
					}
				});

				deviceType.sort();
				$.each(deviceType, function (i, el) {
					if (el == 'SM_MANUAL') return false;
					deviceType[i] = {
						name: featurePropertiesSub[el].name,
						type: el,
						head: featureProperties[el].prop,
						body: {
							type: el,
							prop: featurePropertiesSub[el].prop
						}
					}
				});

				setMakeList(deviceType, 'typeList', {'dataFunction': {'head': makeHeadTable, 'body': makeBodyTable}});

				$.each(deviceType, function (i, el) {
					let deviceType = el.type, operationNormal = 0,
						operationError = 0, operationAlert = 0,
						headerDataObject = new Object();
					if (el.type == 'SM_MANUAL') return false;
					setInitList('table_' + deviceType);

					let tableArray = new Array();

					$.map(data, function(val, key) {
						let dname = val.dname;
						if (val.device_type == deviceType) {
							let rowData = val.data;
							if(!isEmpty(rowData)) {
								let operation = rowData[0]['operation'];
								if(operation == '1') {
									operationNormal++;
								} else if(operation == '2') {
									operationError++;
								} else {
									operationAlert++;
								}

								rowData[0]['dname'] = dname;

								$.map(featureProperties, function(val, key) {
									let headerData = new Object();
									if(!isEmpty(headerDataObject[key])) {
										headerData = headerDataObject[key];
									}
									if (key == deviceType) {
										$.each(val.prop, function(i, el) {
											let value = rowData[0][el.key],
												tmpObj = new Object();
											if(isEmpty(headerData[el.key])) {
												tmpObj['reducer'] = el.reducer;
											} else {
												tmpObj = headerData[el.key];
											}

											if(isEmpty(value)) {
												value = '-';
											} else {
												if((el.suffix.match('W') || el.suffix.match('Wh')) && !el.suffix.match('W/㎡')) {
													value = Number(value);
												} else if(el.suffix.match('%') || el.suffix.match('℃') || el.suffix.match('W/㎡')) {
													value = Number(value);
												}
											}

											if(value == '-') {
												if(!isEmpty(headerData[el.key])) {
													tmpObj['cnt'] = Number(tmpObj['cnt']) + 1;
												} else {
													tmpObj['value'] = '-';
													tmpObj['cnt'] = 1;
												}
											} else {
												if(!isEmpty(headerData[el.key])) {
													tmpObj['value'] = Number(value) + Number(tmpObj['value']);
													tmpObj['cnt'] = Number(tmpObj['cnt']) + 1;
												} else {
													tmpObj['value'] = Number(value);
													tmpObj['cnt'] = 1;
												}

												tmpObj['suffix'] = el.suffix;
											}

											headerData[el.key] = tmpObj;
										});
										headerDataObject[key] = headerData;
									}
								});

								$.map(featurePropertiesSub, function(val, key) {
									if (key == deviceType) {
										$.each(val.prop, function(i, el) {
											let value = rowData[0][el.key];

											if(isEmpty(value)) {
												rowData[0][el.key] = '-';
											} else {
												if((el.suffix.match('W') || el.suffix.match('Wh')) && !el.suffix.match('W/㎡')) {
													let dummy = displayNumberFixedUnit(value, 'W', 'kW', 2);
													rowData[0][el.key] = dummy[0];
												} else if(el.suffix.match('%') || el.suffix.match('℃') || el.suffix.match('W/㎡')) {
													rowData[0][el.key] = value.toFixed(2);
												} else if(el.suffix.match('V')) {
													rowData[0][el.key] = value.toFixed(2);
												}
											}
										});
									}
								});

								if (deviceSearch(dname, operation)) {
									if(isEmpty(tableArray)) {
										let rowData = val.data;
										rowData[0]['dname'] = dname;
										tableArray = rowData;
									} else {
										let rowData = val.data;
										rowData[0]['dname'] = dname;
										tableArray = tableArray.concat(rowData);
									}
								}
							}
						}
					});

					$.map(headerDataObject, function(el, device) {
						let deviceType = device;

						$.map(el, function(element, key) {
							let textValue = element.value,
								suffix = element.suffix;
							if(textValue != '-') {
								if(element.reducer == 'avg') {
									textValue =  textValue / element.cnt;
								}

								textValue = displayNumberFixedDecimal(textValue, suffix, 3, 2);

								$('#typeList').find('.' + deviceType).find('.tbl_type td.' + key + ' span:nth-child(1)').html(textValue[0]);
								if(suffix == 'W' || suffix == 'Wh' || suffix == 'V' || suffix == 'A') {
									$('#typeList').find('.' + deviceType).find('.tbl_type td.' + key + ' span:nth-child(2)').html(textValue[1]);
								}
							} else {
								$('#typeList').find('.' + deviceType).find('.tbl_type td.' + key + ' span:nth-child(1)').html(textValue);
							}

						});
					});
					let deviceCnt = tableArray.length;
					$('#typeList').find('.' + deviceType).find('.ntit span').html(deviceCnt);
					$('#typeList').find('.' + deviceType).find('.alert_icon .inv_normal span').html(operationNormal);
					$('#typeList').find('.' + deviceType).find('.alert_icon .inv_error span').html(operationError);
					$('#typeList').find('.' + deviceType).find('.alert_icon .inv_alert span').html(operationAlert);
					setMakeList(tableArray, 'table_' + deviceType, {'dataFunction': {'operation': setOperation}});
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}
	}

	const setOperation = (operation) => {
		let rtnText = '';
		if (operation == '1') {
			rtnText = '정상';
		} else if (operation == '2') {
			rtnText = '트립';
		} else {
			rtnText = '중지';
		}

		return rtnText;
	}

	const makeHeadTable = (obj) => {
		let targetTable = document.createElement('table');
		let colgroup = document.createElement('colgroup');
		let colLength = obj.length;
		let colSize = (100 / colLength).toFixed(1);

		for(let i = 0; i < colLength; i++) {
			let col = document.createElement('col');
			col.setAttribute('style', 'width:' + colSize.toString() + '%');
			colgroup.appendChild(col);

		}
		targetTable.appendChild(colgroup);

		let thead = targetTable.createTHead();
		let tbody = targetTable.createTBody();
		let hRow = thead.insertRow();
		let bRow = tbody.insertRow();

		obj.forEach(el => {
			let headerCell = document.createElement('TH');
			headerCell.innerHTML = el.value;
			hRow.appendChild(headerCell);

			let bodyCell = bRow.insertCell();
			bodyCell.setAttribute('class', el.key);
			bodyCell.innerHTML = '<span>' + el.suffix + '</span>'
		});

		return targetTable.outerHTML;
	}

	const makeBodyTable = (obj) => {
		let targetTable = document.createElement('table');
		let colgroup = document.createElement('colgroup');
		let colLength = obj.prop.length;
		let colSize = (100 / colLength).toFixed(1);

		for(let i = 0; i < colLength; i++) {
			let col = document.createElement('col');
			col.setAttribute('style', 'width:' + colSize.toString() + '%');
			colgroup.appendChild(col);

		}
		targetTable.appendChild(colgroup);

		let thead = targetTable.createTHead();
		let tbody = targetTable.createTBody();
		tbody.setAttribute('id', 'table_' + obj.type);
		let hRow = thead.insertRow();
		let bRow = tbody.insertRow();
		bRow.setAttribute('data-value', '[operation]')
		let hCell;

		obj.prop.forEach(el => {
			makeTableCell(hRow, hCell, bRow, el.value, el.key);
		});

		return targetTable.outerHTML;
	}

	const chargeChartPoll = function () {
		const formData = getSiteMainSchCollection('year');//api에 맞게 수정 필요
		const monthFormData = getSiteMainSchCollection('month');//api에 맞게 수정 필요
		const beforeYearFormData = getSiteMainSchCollection('beforeYear');//api에 맞게 수정 필요

		const monthEnergy = {
			url: apiHost + apiEnergySite,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				displayType: 'dashboard',
				interval: 'month'
			}
		}

		const nowMonth = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			dataType: 'json',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'month'
			}
		}

		const beforeYear = {
			url: apiHost + apiEnergySite,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: beforeYearFormData.startTime,
				endTime: beforeYearFormData.endTime,
				interval: 'month'
			}
		}

		const weather = {
			url: apiHost + apiWeather,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		}

		if (oid.match('testkpx')) {
			$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear))
			.done(function (monthEnergyData, nowMonthData, beforeYearData) {
				let chargeChartItems1;
				let chargeChartItems2;

				if (monthEnergyData[1] == 'success') {
					let resultData = monthEnergyData[0].data[0];
					if (resultData.generation.items.length > 0) {
						chargeChartItems1 = resultData.generation.items;
						chargeChartItems1.forEach(el => {
							if (!isEmpty(el.money)) {
								el.money = Math.floor(el.money / 1000);
							}
						});

						if (nowMonthData[1] == 'success') {
							let resultNow = nowMonthData[0].data[siteId];
							chargeChartItems1.push({
								basetime: monthFormData.startTime,
								energy: resultNow.energy,
								money: Math.floor(resultNow.money / 1000)
							});
						}
					}
				}

				if (beforeYearData[1] == 'success') {
					let resultData = beforeYearData[0].data[0];
					chargeChartItems2 = resultData.generation.items
				}

				setChargeChartData(chargeChartItems1, chargeChartItems2);
			}).fail(function () {
				console.log('rejected');
			});
		} else {
			if ($(':radio[name="radio_t"]:checked').val() == 1) {
				$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear), $.ajax(weather))
				.done(function (monthEnergyData, nowMonthData, beforeYearData, weatherData) {
					let chargeChartItems1 = new Array();
					let chargeChartItems2 = new Array();
					let irradiationPoaArray = new Array();
					let capacity = 0;

					if (monthEnergyData[1] == 'success') {
						let resultData = monthEnergyData[0].data[0];
						if (resultData.generation.items.length > 0) {
							chargeChartItems1 = resultData.generation.items;
							chargeChartItems1.forEach(el => {
								if (!isEmpty(el.money)) {
									el.money = Math.floor(el.money / 1000);
								}
							});

							if (nowMonthData[1] == 'success') {
								let resultNow = nowMonthData[0].data[siteId];
								chargeChartItems1.push({
									basetime: monthFormData.startTime,
									energy: resultNow.energy,
									money: Math.floor(resultNow.money / 1000)
								});
							}
						}
					}

					if (beforeYearData[1] == 'success') {
						let resultData = beforeYearData[0].data[0];
						chargeChartItems2 = resultData.generation.items
					}

					if (weatherData[1] == 'success') {
						if(!isEmpty(weatherData[0])) {
							let standard = String(weatherData[0][0].basetime).substring(0, 6);
							let sumVal = 0;

							$.each(weatherData[0], function (i, el) {
								if (standard == String(el.basetime).substring(0, 6)) {
									sumVal += el.sensor_solar.irradiationPoa;
									if (i == (weatherData[0].length - 1)) {
										irradiationPoaArray.push({
											baseTime: standard,
											sumVal: sumVal
										});
									}
								} else {
									irradiationPoaArray.push({
										baseTime: standard,
										sumVal: sumVal
									});
									standard = String(el.basetime).substring(0, 6);
									sumVal = el.sensor_solar.irradiationPoa;
								}
							});
						}
					}

					setChargeChartData(chargeChartItems1, chargeChartItems2, irradiationPoaArray);
				}).fail(function () {
					console.log('rejected');
				});
			} else {
				$.when($.ajax(monthEnergy), $.ajax(nowMonth), $.ajax(beforeYear))
				.done(function (monthEnergyData, nowMonthData, beforeYearData) {
					let chargeChartItems1;
					let chargeChartItems2;

					if (monthEnergyData[1] == 'success') {
						let resultData = monthEnergyData[0].data[0];
						if (resultData.generation.items.length > 0) {
							chargeChartItems1 = resultData.generation.items;
							chargeChartItems1.forEach(el => {
								if (!isEmpty(el.money)) {
									el.money = Math.floor(el.money / 1000);
								}
							});

							if (nowMonthData[1] == 'success') {
								let resultNow = nowMonthData[0].data[siteId];
								chargeChartItems1.push({
									basetime: monthFormData.startTime,
									energy: resultNow.energy,
									money: Math.floor(resultNow.money / 1000)
								});
							}
						}
					}

					if (beforeYearData[1] == 'success') {
						let resultData = beforeYearData[0].data[0];
						chargeChartItems2 = resultData.generation.items
					}

					setChargeChartData(chargeChartItems1, chargeChartItems2);
				}).fail(function () {
					console.log('rejected');
				});
			}
		}
	}

	function setChargeChartData(chargeChartItems1, chargeChartItems2, irradiationPoaArray) {
		const toDate = new Date();
		const nowMonth = toDate.getMonth() + 1;

		let itemChartCapacity = 0;
		let totYearEnergy = 0;
		let totMonthEnergy = 0;
		let totBeforeYearEnergy = 0;
		let totBeforeMonthEnergy = 0;
		let energyData = [];
		let billingData = [];

		siteList.forEach(site => {
			if (site.devices != undefined) {
				site.devices.forEach(device => {
					itemChartCapacity += device.capacity;
				});
			}
		});

		itemChartCapacity = Number((itemChartCapacity / 1000).toFixed(1));

		for (let i = 0; i < 12; i++) {
			let matchMonth = false;
			if (!isEmpty(chargeChartItems1)) {
				for (let d = 0; d < chargeChartItems1.length; d++) {
					let dataMonth = parseInt(String(chargeChartItems1[d].basetime).substring(4, 6));
					if (i + 1 == dataMonth) {
						energyData[i] = [i, chargeChartItems1[d].energy / 1000];

						if (!oid.match('testkpx')) {
							if ($(':radio[name="radio_t"]:checked').val() == 1) {
								let energy = chargeChartItems1[d].energy / 1000;
								let irradiationPoaSum = 0;
								$.each(irradiationPoaArray, function (k, el) {
									if (el.baseTime.slice(-2) == dataMonth) {
										irradiationPoaSum = el.sumVal;
									}
								});

								let resultValue = 0;
								if (irradiationPoaSum > 0) {
									resultValue = parseFloat(((energy / itemChartCapacity / (irradiationPoaSum / 1000 * 24)) * 100).toFixed(2));
								}
								billingData[i] = [i, resultValue];
							} else if ($(':radio[name="radio_t"]:checked').val() == 2) { //발전량
								let today = new Date();
								let lastDate = new Date(today.getFullYear(), dataMonth, 0).format('dd');

								if (today.getMonth() == (Number(dataMonth) - 1)) {
									lastDate = today.getDate();
								}
								let energy = chargeChartItems1[d].energy / 1000;

								billingData[i] = [i, parseFloat(((energy / itemChartCapacity) / lastDate).toFixed(2))];
							} else { //매전량
								billingData[i] = [i, chargeChartItems1[d].money];
							}
						}

						totYearEnergy += chargeChartItems1[d].energy / 1000;
						if (i + 1 == nowMonth) {
							totMonthEnergy = chargeChartItems1[d].energy / 1000;
						}
						matchMonth = true;
					}
				}
			}

			if (!matchMonth) {
				energyData[i] = [i, null];
				billingData[i] = [i, null];
			}
		}

		for (var i = 0; i < 12; i++) {
			for (var d = 0; d < chargeChartItems2.length; d++) {
				var dataMonth = parseInt(("" + chargeChartItems2[d].basetime).substring(4, 6));
				if (i + 1 == dataMonth) {
					totBeforeYearEnergy += chargeChartItems2[d].energy / 1000;
					if (i + 1 == nowMonth) {
						totBeforeMonthEnergy = chargeChartItems2[d].energy / 1000;
					}
				}
			}
		}

		chargeChart.series[0].setData(energyData);
		if (!oid.match('testkpx')) {
			chargeChart.series[1].setData(billingData);

			let seriesName = '';
			let suffix = '';
			if ($(':radio[name="radio_t"]:checked').val() == 1) {
				seriesName = 'PR';
				suffix = '%';
			} else if ($(':radio[name="radio_t"]:checked').val() == 2) {
				seriesName = '발전시간';
				suffix = '시간';
			} else {
				seriesName = '매전량';
				suffix = '천원';
			}

			chargeChart.series[1].name = seriesName;
			chargeChart.series[1].tooltipOptions.valueSuffix = suffix;
			chargeChart.series[1].legendItem.element.firstElementChild.innerHTML = seriesName;
			chargeChart.yAxis[1].setTitle({
				text: suffix,
				align: 'low',
				rotation: 0, /* 타이틀 기울기 */
				y: 25, /* 타이틀 위치 조정 */
				x: -12,
				style: {
					color: '#ffffff',
					fontSize: '12px'
				}
			});
		}
	}

	const chargeChart = Highcharts.chart('schart1', {
		chart: {
			marginTop: 40,
			marginLeft: 50,
			marginRight: 50,
			height: 280,
			backgroundColor: 'transparent',
			zoomType: 'xy'
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
		xAxis: [{
			lineColor: '#515562', /* 눈금선색 */
			tickColor: '#515562',
			gridLineColor: '#515562',
			plotLines: [{
				color: '#515562',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27, /* 그래프와 거리 */
				style: {
					color: '#a4aebf',
					fontSize: '12px'
				}
			},
			tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
			title: {
				text: null
			},
			categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
			crosshair: true
		}],
		yAxis: [{ // Primary yAxis
			lineColor: '#515562', /* 눈금선색 */
			tickColor: '#515562',
			gridLineColor: '#515562',
			gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
			plotLines: [{
				color: '#515562',
				width: 1
			}],
			gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
			title: {
				text: 'kWh',
				align: 'low',
				rotation: 0, /* 타이틀 기울기 */
				y: 25, /* 타이틀 위치 조정 */
				x: 15,
				style: {
					color: '#ffffff',
					fontSize: '12px'
				}
			},
			labels: {
				formatter: function () {
					if (String(this.value).length  >= 7) {
						return numberComma(this.value / 1000000) + ' G';
					} else if (String(this.value).length  >= 5) {
						return numberComma(this.value / 1000) + ' M';
					} else {
						return this.value;
					}
				},
				style: {
					color: '#a4aebf',
					fontSize: '12px'
				}
			}
		},
	<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
		{ // Secondary yAxis
		lineColor: '#515562', /* 눈금선색 */
		tickColor: '#515562',
		gridLineColor: '#515562',
		gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
		plotLines: [{
			color: '#515562',
			width: 1
		}],
			gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
			title: {
				text: '천원',
				align: 'low',
				rotation: 0, /* 타이틀 기울기 */
				y: 25, /* 타이틀 위치 조정 */
				x: -12,
				style: {
					color: '#ffffff',
					fontSize: '12px'
				}
			},
			labels: {
				formatter: function () {
					if (String(this.value).length  >= 7) {
						return numberComma(this.value / 1000000) + ' G';
					} else if (String(this.value).length  >= 5) {
						return numberComma(this.value / 1000) + ' M';
					} else {
						return this.value;
					}
				},
				style: {
					color: '#a4aebf',
					fontSize: '12px'
				}
			},
			opposite: true
		}
	</c:if>
		],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + numberComma(point.y) + suffix;
				}, '<b>' + this.x + '</b>');
			},
			shared: true, /* 툴팁 공유 */
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)'
			}
		},
		/* 범례 */
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: -10,
			y: -10,
			itemStyle: {
				color: '#a4aebf',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: '' /* 마우스 오버시 색 */
			},
			symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
			symbolHeight: 7 /* 심볼 크기 */
		},
		/* 옵션 */
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: '#a4aebf',
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
		series: [{
			<c:choose>
				<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			name: '발전 실적',
				</c:when>
				<c:otherwise>
			name: 'PV발전량',
				</c:otherwise>
			</c:choose>
			type: 'column',
			color: '#26ccc8',
			data: [],
			tooltip: {
				valueSuffix: 'kWh'
			}

		},
	<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
		{
			name: 'PR',
			type: 'spline',
			color: 'var(--white60)',
			dashStyle: 'ShortDash',
			yAxis: 1,
			data: [],
			tooltip: {
				valueSuffix: '천원'
			}
		}
	</c:if>
		],
		/* 출처 */
		credits: {
			enabled: false
		},
		/* 반응형 */
		responsive: {
			rules: [{
				condition: {
					minWidth: 870 /* 차트 사이즈 */
				},
				chartOptions: {
					chart: {
						marginTop: 50,
						marginLeft: 75,
						marginRight: 75
					},
					xAxis: {
						labels: {
							style: {
								fontSize: '18px'
							}
						}
					},
					yAxis: [{
						title: {
							y: 30,
							x: 20,
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
						{
							title: {
								y: 30,
								x: -15,
								style: {
									fontSize: '18px'
								}
							},
							labels: {
								style: {
									fontSize: '18px'
								}
							}
						}],
					legend: {
						itemStyle: {
							fontSize: '18px'
						},
						symbolPadding: 5,
						symbolHeight: 10
					}
				}
			}]
		}
	});

	const getWCalendarEnergyData = () => {
		const formData = getSiteMainSchCollection('month');//api에 맞게 수정 필요

		const dailyEnergy = {
			url: apiHost + apiEnergySite,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		};

		const dailyWeather = {
			url: apiHost + apiWeather,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'day'
			}
		};

		$.when($.ajax(dailyEnergy), $.ajax(dailyWeather))
		.done(function (dailyEnergyData, dailyWeatherData) {
			let energyItems = dailyEnergyData[0].data[0].generation.items;
			let weatherItems = dailyWeatherData[0];
			let calendarDays = $('.calWeatherDay');

			for (let i = 1; i <= calendarDays.length; i++) {
				if (energyItems.length > 0) {
					energyItems.forEach(el => {
						let dataDay = parseInt(String(el.basetime).substring(6, 8));
						if (i == dataDay) {
							let energyText = displayNumberFixedDecimal(el.energy, 'Wh', 3, 1);
							$('#calEnergyValue_' + i).html('<strong>' + energyText[0] + '</strong><em>' + energyText[1] + '</em>');
						}
					});
				}

				if (weatherItems.length > 0) {
					weatherItems.forEach((el, index) => {
						let dataDay = parseInt(String(el.basetime).substring(6, 8));
						if (i == dataDay) {
							$('#calWeatherValue_' + i).text((el.temperature).toFixed(1) + '℃');

							let weatherIconClass = getWeatherIconClass(el.sky);
							$('#calWeatherIcon_' + i).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
						}
					});
				}
			}
		}).fail(function () {
			console.log('rejected');
		}).always(function () {
			getWCalendarNowEnergyData();
		});
	}

	const getWCalendarNowEnergyData = () => {
		$.ajax({
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			dataType: 'json',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'day'
			}
		}).done(function (data, textStatus, jqXHR) {
			const calDate = new Date();
			if (!isEmpty(data.data[siteId])) {
				const energyText = displayNumberFixedDecimal(data.data[siteId].energy, 'Wh', 3, 1);
				$('#calEnergyValue_' + (calDate.getDate())).html('<strong>' + energyText[0] + '</strong><em>' + energyText[1] + '</em>');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	/*
	 weather value 1 	> css w1
	 weather value 20	> css w3
	 weather value 7	> css w4
	 weather value 13	> css w6
	 weather value 11	> css w8
	 weather value 17	> css w9
	 weather value 12	> css w10
	*/
	const getWeatherIconClass = (weatherId) => {
		let weatherIconClass = 'w1';
		switch (weatherId) {
			case 1 :
				weatherIconClass = 'w1';
				break;
			case 7 :
				weatherIconClass = 'w4';
				break;
			case 11 :
				weatherIconClass = 'w8';
				break;
			case 12 :
				weatherIconClass = 'w10';
				break;
			case 13 :
				weatherIconClass = 'w6';
				break;
			case 17 :
				weatherIconClass = 'w9';
				break;
			case 20 :
				weatherIconClass = 'w3';
				break;
			default :
				weatherIconClass = 'w1';
				break;
		}
		return weatherIconClass
	}

	let toDayEnergy = 0;
	let toDayRaw = 0;
	const getTodayTotalDetail = function () {
		const formData = getSiteMainSchCollection('day');
		const formYesterData = getSiteMainSchCollection('yesterday');
		let capacity = 0;
		let urls = new Array();
		let deferreds = new Array();

		if(oid.match('testkpx')) {
			$('#centerTbody tr td:nth-child(1)').html('<em>&nbsp;&nbsp;kW</em>');
			$('#centerTbody tr td:nth-child(2)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(3)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(4)').html('<em>&nbsp;&nbsp;H</em>');
		} else {
			$('#centerTbody tr td:nth-child(1)').html('<em>&nbsp;&nbsp;kW</em>');
			$('#centerTbody tr td:nth-child(2)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(3)').html('<em>&nbsp;&nbsp;kWh</em>');
			$('#centerTbody tr td:nth-child(4)').html('<em>&nbsp;&nbsp;천원</em>');
		}

		if (oid.match('testkpx')) {
			let rtus = new Array();
			siteList.forEach(site => {
				if (!isEmpty(site.rtus)) {
					site.rtus.forEach(rtu => {
						rtus.push(rtu.rid);
					})
				}
			});

			urls.push({
				url: apiHost + apiEnergySite,
				type: 'GET',
				data: {
					sid: siteId,
					startTime: formData.startTime,
					endTime: formData.endTime,
					interval: 'hour'
				}
			});

			urls.push({
				url: apiHost + apiEnergySite,
				type: 'GET',
				data: {
					sid: siteId,
					startTime: formYesterData.startTime,
					endTime: formYesterData.endTime,
					interval: 'day'
				}
			});

			if (!isEmpty(rtus)) {
				urls.push({
					url: apiHost + '/control/command_history',
					type: 'GET',
					data: {
						oid: oid,
						rids: rtus.join(','),
						cmdTypes: 'kpx_targetPower',
						isRecent: true
					},
				});
			}
		} else {
			urls.push({
				url: apiHost + apiEnergyNowSite,
				type: 'GET',
				data: {
					sids: siteId,
					metering_type: 2,
					interval: 'day'
				}
			});

			urls.push({
				url: apiHost + apiForecastingSite,
				type: 'GET',
				data: {
					sid: siteId,
					startTime: formData.startTime,
					endTime: formData.endTime,
					interval: 'hour'
				}
			});
		}

		urls.push({
			url: apiHost + apiStatusRawSite,
			type: 'GET',
			data: {
				sid: siteId,
				formId: 'v2'
			}
		});

		//ajax 한번에 실행
		deferreds = new Array();
		urls.forEach(function (url) {
			let deferred = $.Deferred();
			deferreds.push(deferred);

			$.ajax(url).done(function (data) {
				data['url'] = url['url'];
				(function (deferred) {
					return deferred.resolve(data);
				})(deferred);
			}).fail(function (error) {
				console.log(error);
			});
		});

		$.when.apply($, deferreds).then(function () {
			let itemCapacity = null;
			let itemDcPower = null;
			let itemAcPower = null;
			let itemEfficiency = null;
			let targetActivePower = null;
			let itemEnergyDay = 0;
			let lastTargetActivePowerReqDate = '';
			let lastTargetActivePowerRecvDate = '';

			Object.entries(arguments).forEach(arg => {
				const data = arg[1];
				const url = data.url;

				if ((url).match(apiEnergySite)) {
					let nowEnergyDay = 0;
					let nowBillingDay = 0;
					if (!isEmpty(data.data)) {
						const rstData = data.data;
						rstData.forEach(rst => {
							const generation = rst.generation.items;
							if (!isEmpty(generation)) {
								generation.forEach(gen => {
									nowEnergyDay += gen.energy;
									nowBillingDay += gen.money;
								});
							}
						});
					}
					if ((data.start) == formYesterData.startTime) {
						$('#centerTbody tr td:nth-child(3) em').before(displayNumberFixedUnit(nowEnergyDay, 'Wh', 'kWh', 2)[0]);
						itemEnergyDay = nowEnergyDay;
					} else {
						$('#centerTbody tr td:nth-child(2) em').before(displayNumberFixedUnit(nowEnergyDay, 'Wh', 'kWh', 2)[0]);

						if (!oid.match('testkpx')) {
							$('#centerTbody tr td:nth-child(4) em').before(displayNumberFixedUnit(nowBillingDay, 'Wh', 'kWh', 2)[0]);
						}
					}

				} else if ((url).match(apiEnergyNowSite)) {
					let rstData = data.data[siteId];
					let nowEnergyDay = rstData.energy;
					let nowBillingDay = rstData.money;

					$('#centerTbody tr td:nth-child(2) em').before(displayNumberFixedUnit(nowEnergyDay, 'Wh', 'kWh', 2)[0]);
					$('#centerTbody tr td:nth-child(4) em').before(displayNumberFixedUnit(nowBillingDay, 'Wh', 'kWh', 2)[0]);
				} else if ((url).match(apiForecastingSite)) {
					let totDayForeEnergy = 0;

					if (!isEmpty(data.data)) {
						const rstData = data.data;
						rstData.forEach(rst => {
							const generation = rst.generation.items;
							if (!isEmpty(generation)) {
								generation.forEach(gen => {
									totDayForeEnergy += gen.energy;
								});
							}
						});
					}

					$('#centerTbody tr td:nth-child(3) em').before(displayNumberFixedUnit(totDayForeEnergy, 'Wh', 'kWh', 2)[0]);
				} else  if ((url).match('/control/command_history')) {
					if (!isEmpty(data.data)) {
						if (!isEmpty(lastTargetActivePowerReqDate)) {
							let statusDate = new Date(lastTargetActivePowerReqDate.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
							let hitoryDate = new Date(data.data[0].requested_at.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
							if (statusDate.getTime() < hitoryDate.getTime()) {
								lastTargetActivePowerReqDate = hitoryDate.format('yyyyMMddHHmmss');
								lastTargetActivePowerRecvDate = '-';

								const cmdBody = JSON.parse(data.data[0].cmd_body);
								targetActivePower = cmdBody.targetPower;
							}
						} else {
							lastTargetActivePowerReqDate = data.data[0].requested_at;
							lastTargetActivePowerRecvDate = '-'

							const cmdBody = JSON.parse(data.data[0].cmd_body);
							targetActivePower = cmdBody.targetPower;
						}
					}
				} else {
					if (!isEmpty(data)) {
						Object.entries(data).forEach(rawData => {
							const deviceType = rawData[0];
							const deviceData = rawData[1];

							if (!isEmpty(deviceData.timestamp) && ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < deviceData.timestamp))) {
								const dbTime = new Date(deviceData.timestamp);
								$('.dbTime').data('timestamp', deviceData.timestamp).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
							}

							if (oid.match('testkpx')) {
								if (deviceType.toLowerCase() === 'kpx_ems') {
									itemCapacity = deviceData.capacity;
									itemAcPower = deviceData.activePower;

									if (!isEmpty(lastTargetActivePowerReqDate)) {
										let hitoryDate = new Date(lastTargetActivePowerReqDate.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
										let statusDate = new Date(String(deviceData.lastTargetActivePowerReqDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'));
										if (statusDate.getTime() > hitoryDate.getTime()) {
											lastTargetActivePowerReqDate = String(deviceData.lastTargetActivePowerReqDate);
											lastTargetActivePowerRecvDate = String(deviceData.lastTargetActivePowerReqDate);
											targetActivePower = deviceData.targetActivePower;
										}
									} else {
										lastTargetActivePowerReqDate = String(deviceData.lastTargetActivePowerReqDate);
										lastTargetActivePowerRecvDate = String(deviceData.lastTargetActivePowerReqDate);
										targetActivePower = deviceData.targetActivePower;
									}
								}
							} else {
								if (!isEmpty(deviceData)) {
									Object.entries(deviceData).map(di => {
										const key = di[0];
										const value = di[1];

										if(key == 'capacity') {
											itemCapacity += value;
										} else if(key == 'dcPower') {
											itemDcPower += value;
										} else if(key == 'activePower') {
											itemAcPower += value;
										} else if(key == 'efficiency') {
											itemEfficiency += value;
										}
									});
								}
							}
						});
					}
				}
			});

			if (oid.match('testkpx')) {
				let genHour = isNaN(itemEnergyDay / itemCapacity) ? '-' : itemEnergyDay / itemCapacity;
				if (genHour === '-') {
					$('#centerTbody tr td:nth-child(4) em').before(genHour);
				} else {
					$('#centerTbody tr td:nth-child(4) em').before(genHour.toFixed(1));
				}

				$('#siteCapacity').text(displayNumberFixedUnit(targetActivePower, 'W', 'kW', 2)[0]);
				$('#siteAcPower').text(String(lastTargetActivePowerReqDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
				if (lastTargetActivePowerRecvDate != '-') {
					$('#siteDcPower').text(String(lastTargetActivePowerRecvDate).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
				}

				let usage = Math.floor((itemAcPower / targetActivePower) * 100);
				let other = 100 - usage;
				pieChart.series[0].data.forEach((e, idx) => {
					if (e.name === "태양광") {
						e.update({y: usage});
					} else if (e.name === "미사용량") {
						e.update({y: other});
					} else {
						e.update({y: 0});
					}
				});
				pieChart.redraw();
			} else {
				$('#siteCapacity').text(displayNumberFixedUnit(itemCapacity, 'W', 'kW', 1)[0]);
				$('#siteDcPower').text(displayNumberFixedUnit(itemDcPower, 'W', 'kW', 1)[0]);
				$('#siteAcPower').text(displayNumberFixedUnit(itemAcPower, 'W', 'kW', 1)[0]);

				let pie1Data = Math.round(itemEfficiency);
				let pie2Data = 100 - pie1Data;

				pieChart.series[0].setData([pie1Data, pie2Data]);
			}

			$('#centerTbody tr td:nth-child(1) em').before(displayNumberFixedUnit(itemCapacity, 'W', 'kW', 1)[0]);
			pieChart.setTitle({text: displayNumberFixedUnit(itemAcPower, 'W', 'kW', 1)[0] + 'kW'});
		});
	}

	var pieChart = Highcharts.chart('pie_chart', {
		chart: {
			marginTop: 0,
			marginLeft: 0,
			marginRight: 0,
			backgroundColor: 'transparent',
			zoomType: 'xy',
			plotBorderWidth: 0,
			plotShadow: false,
			height: 180
		},
		navigation: {
			buttonOptions: {
				enabled: false /* 메뉴 안보이기 */
			}
		},
		title: {
			text: '- Wh', // 총용량 표기
			align: 'center',
			verticalAlign: 'middle',
			y: 10,
			x: 0,
			style: {
				fontSize: '14px',
				color: 'var(--white60)'
			}
		},
		subtitle: {
			text: ''
		},
		credits: {
			enabled: false
		},
		tooltip: {
			shared: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)'
			},
			valueSuffix: ' kwh',
			pointFormat: '<b>{point.percentage:.0f}%</b>'
		},
		plotOptions: {
			pie: {
				dataLabels: {
					enabled: false,
					style: {
						fontWeight: 'bold',
						color: 'var(--white)'
					}
				},
				center: ['40%', '50%'],
				borderWidth: 0,
				size: '100%'
			}
		},
		series: [{
			type: 'pie',
			innerSize: '70%',
			name: '발전량',
			colorByPoint: true,
			data: [{
				color: '#9363FD',
				name: '태양광',
				dataLabels: {
					enabled: false
				},
				y: 60 //60% -- 아래로 총합 100%
			}, {
				color: '#878787',
				name: '미사용량',
				dataLabels: {
					enabled: false
				},
				y: 20 //20% 나머지
			}]
		}],
		responsive: { // 반응형
			rules: [{
				condition: {
					maxWidth: 768
				},
				chartOptions: {
					plotOptions: {
						pie: {
							center: ['50%', '50%']
						}
					}
				}
			}]
		}
	});


	//금일 발전 현
	const toDayGeneration = () => {
		const formData = getSiteMainSchCollection('day');
		const formYesterData = getSiteMainSchCollection('yesterday');

		let energyData1 = new Array(24).fill(0);
		let energyData2 = new Array(24).fill(0);

		let gen = {
			url: apiHost + apiEnergySite,
			type: 'get',
			data: {
				sid: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				interval: 'hour'
			}
		};

		let foreGen = new Object();
		if (oid.match('testkpx')) { //KPX 조회시에는 전일 데이터로 변경.
			foreGen = {
				url: apiHost + apiEnergySite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: formYesterData.startTime,
					endTime: formYesterData.endTime,
					interval: 'hour'
				}
			};
		} else {
			foreGen = {
				url: apiHost + apiForecastingSite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: formData.startTime,
					endTime: formData.endTime,
					interval: 'hour'
				}
			};
		}

		const nowMonth = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			dataType: 'json',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'month'
			}
		}

		let nowGen = {
			url: apiHost + apiEnergyNowSite,
			type: 'get',
			data: {
				sids: siteId,
				metering_type: '2',
				interval: 'hour'
			}
		};

		$.when($.ajax(gen), $.ajax(foreGen), $.ajax(nowGen))
		.done(function (genData, foreGenData, nowGenData) {
			if (genData[1] == 'success') {
				let data = genData[0].data[0];
				let dummyItem = data.generation.items;

				if (dummyItem.length > 0) {
					dummyItem.forEach(el => {
						let index = Number(String(el.basetime).substring(8, 10));
						energyData1[index] = el.energy;
					});
				}
			}

			if (foreGenData[1] == 'success') {
				let data = foreGenData[0].data[0].generation;

				if (!isEmpty(data) && data.items.length > 0) {
					data.items.forEach((el, index) => {
						energyData2[index] = el.energy;
					});
				}
			}

			if (nowGenData[1] == 'success') {
				let toDate = new Date();
				let hour = toDate.getHours();
				if(!isEmpty(nowGenData[0].data[siteId])) {
					energyData1[hour] = nowGenData[0].data[siteId].energy;
				}
			}

			energyData1.forEach((el, index) => {
				energyData1[index] = Number((el / 1000).toFixed(2));
			});

			energyData2.forEach((el, index) => {
				energyData2[index] = Number((el / 1000).toFixed(2));
			});

			saChart2.series[0].setData(energyData1);
			saChart2.series[1].setData(energyData2)
		}).fail(function () {
			console.log('rejected');
		});
	}

	const saChart2 = Highcharts.chart('schart2', {
		chart: {
			marginTop: 40,
			marginLeft: 50,
			marginRight: 0,
			height: 301,
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
			lineColor: '#515562', /* 눈금선색 */
			tickColor: '#515562',
			gridLineColor: '#515562',
			plotLines: [{
				color: '#515562',
				width: 1
			}],
			labels: {
				align: 'center',
				y: 27, /* 그래프와 거리 */
				style: {
					color: '#a4aebf',
					fontSize: '12px'
				}
			},
			tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
			title: {
				text: null
			},
			categories: [
				'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
				'13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'
			],
			crosshair: true
		},
		yAxis: {
			lineColor: '#515562', /* 눈금선색 */
			tickColor: '#515562',
			gridLineColor: '#515562',
			plotLines: [{
				color: '#515562',
				width: 1
			}],
			gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
			min: 0, /* 최소값 지정 하면 + 만 나옴 */
			title: {
				text: 'kWh',
				align: 'low',
				rotation: 0, /* 타이틀 기울기 */
				y: 25, /* 타이틀 위치 조정 */
				x: 10,
				style: {
					color: '#a4aebf',
					fontSize: '12px'
				}
			},
			labels: {
				overflow: 'justify',
				x: -10, /* 그래프와의 거리 조정 */
				style: {
					color: '#a4aebf',
					fontSize: '12px'
				}
			}
		},
		tooltip: {
			shared: true
		},
		/* 범례 */
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -10,
			itemStyle: {
				color: '#a4aebf',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: '' /* 마우스 오버시 색 */
			},
			symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
			symbolHeight: 7 /* 심볼 크기 */
		},
		/* 옵션 */
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: '#a4aebf',
				borderWidth: 0 /* 보더 0 */
			},
			line: {
				marker: {
					enabled: false /* 마커 안보이기 */
				}
			},
			column: {
				//stacking: 'normal' /*위로 쌓이는 막대  ,normal */
			}
		},
		/* 출처 */
		credits: {
			enabled: false
		},
		/* 그래프 스타일 */
		series: [{
			type: 'column',
			<c:choose>
				<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			name: '발전 실적',
				</c:when>
				<c:otherwise>
			name: 'PV발전량',
				</c:otherwise>
			</c:choose>
			color: '#26ccc8', /* PV발전량 */
			tooltip: {valueSuffix: 'kWh'},
			data: []
		}, {
			type: 'column',
			<c:choose>
				<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			name: '전일 발전량',
				</c:when>
				<c:otherwise>
			name: '발전 예측',
				</c:otherwise>
			</c:choose>

			color: '#878787', /* 발전 예측 */
			tooltip: {valueSuffix: 'kWh'},
			data: []
		}],
		/* 반응형 */
		responsive: {
			rules: [{
				condition: {
					minWidth: 870 /* 차트 사이즈 */
				},
				chartOptions: {
					chart: {
						marginLeft: 75
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
						symbolPadding: 5,
						symbolHeight: 10
					}
				}
			}]
		}
	});

	//기상정보 반복없음.
	const meteorological = () => {
		const fromDate = new Date();
		const toDate = new Date(fromDate.getFullYear(), fromDate.getMonth(), fromDate.getDate() + 3);

		const timeFromDate = new Date(fromDate.getFullYear(), fromDate.getMonth(), fromDate.getDate() - 2);
		const formData = getSiteMainSchCollection('day');

		let weekWeather = {
			url: apiHost + apiWeather,
			type: 'get',
			dataType: 'json',
			data: {
				sid: siteId,
				startTime: fromDate.format('yyyyMMdd') + '000000',
				endTime: toDate.format('yyyyMMdd') + '235959',
				interval: 'day'
			}
		}

		let weekWeatherTime = new Object();
		if (oid.match('testkpx')) {
			let did = '';
			siteList.forEach(site => {
				const devices = site.devices;
				if (!isEmpty(devices)) {
					devices.forEach(di => {
						const deviceType = di.device_type;
						if (deviceType === 'KPX_EMS') {
							did = di.did;
						}
					});
				}
			});

			let weekWeatherTime = {
				url: apiHost + apiWeather,
				type: 'get',
				dataType: 'json',
				data: {
					sid: siteId,
					startTime: timeFromDate.format('yyyyMMdd') + '000000',
					endTime: fromDate.format('yyyyMMdd') + '235959',
					interval: 'hour'
				}
			}

			let statusRaw = {
				url: apiHost + apiStatusRaw,
				type: 'get',
				dataType: 'json',
				data: {
					dids: did
				}
			}
			$.when($.ajax(weekWeather), $.ajax(weekWeatherTime), $.ajax(statusRaw))
			.done(function (weekWeatherData, weekWeatherTimeData, statusRawData) {
				if (weekWeatherData[1] == 'success') {
					let weekWeather = weekWeatherData[0];

					weekWeather.forEach((el, index) => {
						$('#weekTemp_' + (index + 1)).text((el.temperature).toFixed(1));
						let weatherIconClass = getWeatherIconClass(el.sky);
						$('#weekIcon_' + (index + 1)).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
					});
				}

				if (weekWeatherTimeData[1] == 'success') {
					let items = weekWeatherTimeData[0];
					if (items.length > 0) {
						let tempArray = new Array();
						$.each(items, function (i, el) {
							if (el.observed != undefined && el.observed) {
								tempArray.push(el);
							}
						});

						if (tempArray.length > 0) {
							let weatherIconClass = getWeatherIconClass(tempArray[tempArray.length - 1].sky);
							$('#weekTemp').text((tempArray[tempArray.length - 1].temperature).toFixed(1) + '℃');
							$('#weekIcon').html('<i class="ico_weather ' + weatherIconClass + '"></i>');
							$('#weekIcon').next('strong').html(' (' + siteList[0].location + ') ');
						}
					}
				}

				if (statusRawData[1] == 'success') {
					let items = statusRawData[0];
					if (!isEmpty(items)) {
						Object.entries(items).map(obj => {
							let deviceData = obj[1].data;

							deviceData.forEach(di => {
								let humidity = isEmpty(di.humidity) ? '-' : di.humidity;
								let windDirection = isEmpty(di.windDirection) ? '-' : di.windDirection;
								let windSpeed = isEmpty(di.windSpeed) ? '-' : di.windSpeed;
								let wind_velocity = isEmpty(di.wind_velocity) ? '-' : di.wind_velocity;
								let temperature = isEmpty(di.temperature) ? '-' : di.temperature;

								$('#weekTemp').text((temperature).toFixed(1) + '℃');
								$('#weekIcon').next('strong').html(' (' + siteList[0].location + ') ');
								$('#weekWindspeed').text((windSpeed).toFixed(1) + ' km/h');
								$('#weekWindvelocity').text(windDirection);
								$('#weekHum').text(humidity + ' %');

								$('.weather .stit').html(new Date(di.timestamp).format('yyyy-MM-dd HH:mm:ss'));
							});
						});
					}
				}
			}).fail(function () {
				console.log('rejected');
			});
		} else {
			let weekWeatherTime = {
				url: apiHost + apiWeather,
				type: 'get',
				dataType: 'json',
				data: {
					sid: siteId,
					startTime: timeFromDate.format('yyyyMMdd') + '000000',
					endTime: fromDate.format('yyyyMMdd') + '235959',
					interval: 'hour'
				}
			}

			$.when($.ajax(weekWeather), $.ajax(weekWeatherTime))
			.done(function (weekWeatherData, weekWeatherTimeData) {
				if (weekWeatherData[1] == 'success') {
					let weekWeather = weekWeatherData[0];

					weekWeather.forEach((el, index) => {
						$('#weekTemp_' + (index + 1)).text((el.temperature).toFixed(1));
						let weatherIconClass = getWeatherIconClass(el.sky);
						$('#weekIcon_' + (index + 1)).html('<i class="ico_weather ' + weatherIconClass + '"></i>');
					});
				}

				if (weekWeatherTimeData[1] == 'success') {
					let items = weekWeatherTimeData[0];
					if (items.length > 0) {
						let tempArray = new Array();
						$.each(items, function (i, el) {
							if (el.observed != undefined && el.observed) {
								tempArray.push(el);
							}
						});

						if (tempArray.length > 0) {
							let weatherIconClass = getWeatherIconClass(tempArray[tempArray.length - 1].sky);
							$('#weekTemp').text((tempArray[tempArray.length - 1].temperature).toFixed(1) + '℃');
							$('#weekIcon').html('<i class="ico_weather ' + weatherIconClass + '"></i>');
							$('#weekIcon').next('strong').html(' (' + siteList[0].location + ') ');
							$('#weekWindspeed').text((tempArray[tempArray.length - 1].wind_speed).toFixed(1) + ' km/h');
							$('#weekWindvelocity').text(tempArray[tempArray.length - 1].wind_velocity);
							$('#weekHum').text((tempArray[tempArray.length - 1].humidity).toFixed(1) + ' %');

							$('.weather .stit').html(String(tempArray[tempArray.length - 1].basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6'));
						}
					}
				}
			}).fail(function () {
				console.log('rejected');
			});
		}
	}

	//알람이력
	const getAlarmInfo = function () {
		const formData = getSiteMainSchCollection('day');
		let siteArray = new Array();

		$.ajax({
			url: apiHost + '/alarms',
			type: 'get',
			data: {
				sids: siteId,
				startTime: formData.startTime,
				endTime: formData.endTime,
				confirm: false
			},
		}).done(function (data, textStatus, jqXHR) {
			//localtime 오름차순 정렬
			data.sort((a, b) => {
				return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
			});

			//데이터 세팅
			let alarmList = new Array();
			data.forEach((element, index) => {
				if(element.level != 0) {
					let localTime = (element.localtime != null && element.localtime != '') ? String(element.localtime) : '';
					data[index].standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
					alarmList.push(element);
				}
			});

			$('.a_alert').find('em').text(alarmList.length);
			setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}}); //list생성
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		})
	}

	const levelClass = (level) => {
		let rtnClass = '';
		switch (level) {
			case 1 :
				rtnClass = 'warning';
				break;
			case 2 :
				rtnClass = 'critical';
				break;
			case 3 :
				rtnClass = 'shutoff';
				break;
			case 4 :
				rtnClass = 'urgent';
				break;
			case 0 :
				rtnClass = 'info';
				break;
			default :
				rtnClass = '';
		}

		return rtnClass;
	}

	const pageMove = (id, action) => {
		let $form = $('#linkSiteForm');

		id = id == '' ? siteId : id;
		let $inp = $('<input>').attr('type', 'hidden').attr('name', 'sid').val(id);

		$form.append($inp);
		if (action == 'alarm') {
			$form.attr('action', '/history/alarmHistory.do').submit();
		} else {
			$form.attr('action', '/dashboard/smain.do').submit();
		}
	}
</script>