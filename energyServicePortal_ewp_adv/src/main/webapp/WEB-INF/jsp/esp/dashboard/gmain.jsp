<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<%@ include file="/decorators/include/dashboardSchForm.jsp" %>
<!-- 메인페이지용 스타일/스크립트 파일 -->
<script type="text/javascript" src="/js/modules/rounded-corners.js"></script>
<script type="text/javascript" src="/js/jquery.rwdImageMaps.min.js"></script>
<script type="text/javascript"
        src="http://maps.google.com/maps/api/js?key=AIzaSyAyGrAQC_675C34l2ZJ5JgEqeEV3gLuY9I"></script>
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">${siteName}</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv gmain_chart gmain_chart1">
			<div class="chart_top clear">
				<h2 class="ntit">월간</h2>
				<span class="term"></span>
			</div>
			<%--					<div class="no-data">--%>
			<%--						<span>올해 발전량 정보를 가져올 수 없습니다.</span>--%>
			<%--					</div>--%>
			<div class="inchart">
				<div id="monthlyChart"></div>
			</div>
		</div>

		<div class="indiv gmain_chart gmain_chart2">
			<div class="chart_top clear">
				<h2 class="ntit">일간</h2>
				<span class="term"></span>
			</div>
			<div class="inchart">
				<div id="dailyChart"></div>
			</div>
		</div>

		<div class="indiv gmain_chart gmain_chart3">
			<div class="chart_top clear">
				<h2 class="ntit">전일</h2>
				<span class="term"></span>
			</div>
			<%--					<ul class="gtab_menu">--%>
			<%--						<li class="active"><a href="#;">사업소별 현황</a></li>--%>
			<%--						<li><a href="#;">유형별 발전 현황</a></li>--%>
			<%--					</ul>--%>
			<div class="tblDisplay">
				<div>
					<!-- 사업소별 현황 -->
					<div class="inchart">
						<div id="typeSiteCurrent"></div>
					</div>
					<!-- 데이터 추출용 테이블 -->
					<div class="hidden_table" style="display:none">
						<table id="gdatatable3">
							<thead>
							<tr>
								<th></th>
								<th>전일발전</th>
								<th>전일예측</th>
							</tr>
							</thead>
							<tbody id="siteGenTbody">
							</tbody>
						</table>
					</div>
				</div>
				<div>
					<!-- 유형별 발전 현황 -->
					<div class="sa_chart type-table">
						<div class="inchart type-left">
							<div id="gchart4"></div>
						</div>
						<div class="type-right">
							<dl class="sun">
								<dt><span>태양광</span></dt>
								<dd>
									<p><strong>가동설비</strong> <span>13</span><em>기</em></p>
									<p><strong>용량</strong> <span>13</span><em>MW</em></p>
									<p><strong>전일발전량</strong> <span>3,500</span><em>kWH</em></p>
								</dd>
							</dl>
						</div>
					</div>
					<!-- 데이터 추출용 테이블 -->
					<div class="hidden_table" style="display:none">
						<table id="gdatatable4">
							<thead>
							<tr>
								<th></th>
								<th>전일발전량</th>
								<th>예측발전량</th>
							</tr>
							</thead>
							<tbody id="typeGenTbody">
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="col-xl-8 col-md-12 col-sm-12">
		<div class="gmain_row1">
			<div class="indiv gmain_map gmain_chart gmain_chart4">
				<div class="chart_top clear">
					<h2 class="ntit">현재 출력</h2>
				</div>
				<div class="chart_box">
					<div class="chart_info">
						<div class="ci_left">
							<div class="inchart">
								<div id="pie_chart"></div>
							</div>
						</div>
						<div class="ci_right">
							<div class="legend_wrap">
								<span class="bu1">태양광</span>
								<span class="bu4">미 사용량</span>
							</div>
							<ul>
								<li><strong>금일 누적발전량</strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
								<li><strong>금일 예측발전량</strong> <span> 0 </span><em>&nbsp;&nbsp;kWh</em></li>
								<li><strong>금일 충/방전</strong> <span> - </span><em>&nbsp;&nbsp;Wh</em> /
									<span> - </span><em>&nbsp;&nbsp;Wh</em></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="local_info s_center">
					<table>
						<thead>
						<tr>
							<th>총 사업소</th>
							<th>총 설비</th>
							<th>총 설비용량</th>
							<th>금일 CO2저감량</th>
							<th>금일 누적수익</th>
						</tr>
						</thead>
						<tbody id="centerTbody">
						<tr>
							<td><span></span><em>&nbsp;&nbsp;개소</em></td>
							<td><span></span><em>&nbsp;&nbsp;대</em></td>
							<td><span></span><em>&nbsp;&nbsp;kW</em></td>
							<td><span></span><em>&nbsp;&nbsp;kg</em></td>
							<td><span></span><em>&nbsp;&nbsp;천원</em></td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="indiv gmain_alarm wrap_type">
				<div class="alarm_stat clear">
					<div class="a_alert clear">
						<span>금일 발생 오류</span>
						<em>0</em>
					</div>
					<div class="a_warning clear">
						<a href="javascript:void(0);" onclick="pageMove('all', 'alarm');" class="btn cancel_btn">상세보기</a>
					</div>
				</div>
				<div class="alarm_notice">
					<ul id="alarmNotice">
						<li>
							<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');">
								<span class="err_msg">[site_name] - [message]</span>
								<span class="err_time">[standardTime]</span>
							</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="gmain_row2">
			<div class="indiv gmain_table">
				<div class="gmain_map2">
					<div class="map_wrap" id="gMainMap"></div>
				</div>
				<div class="gmain_map2_content">
					<div class="gtbl_top clear">
						<div class="input_group1">
							<input type="text" class="input" id="searchName" name="searchName" value="" placeholder="사업소 검색">
							<button type="button" onclick="searchSite();">적용</button>
						</div>
						<div class="input_group2">
							<span class="tx_tit">설비 상태</span>
							<div class="sa_select">
								<div class="dropdown" id="deviceStatus">
									<button class="btn btn-primary dropdown-toggle w8" type="button"
											data-toggle="dropdown" data-name="설비 상태">
										전체<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk_type" role="menu">
										<li data-value="0">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="deviceStatus1" name="deviceStatus" value="0" checked>
												<label for="deviceStatus1"><span></span>중지</label>
											</a>
										</li>
										<li data-value="1">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="deviceStatus2" name="deviceStatus" value="1" checked>
												<label for="deviceStatus2"><span></span>정상</label>
											</a>
										</li>
										<li data-value="2">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="deviceStatus3" name="deviceStatus" value="2" checked>
												<label for="deviceStatus3"><span></span>트립</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
					<div class="gtbl_wrap">
						<div class="intable">
							<table>
								<caption>(단위: kWh)</caption>
								<thead>
								<tr>
									<th>
										<button class="btn_align">상태</button>
									</th>
									<th>
										<button class="btn_align">오류</button>
									</th>
									<th>
										<button class="btn_align">경고</button>
									</th>
									<th>
										<button class="btn_align">사업소</button>
									</th>
									<th>
										<button class="btn_align">설비용량</button>
									</th>
									<th>
										<button class="btn_align">금일예측</button>
									</th>
									<th>
										<button class="btn_align">금일누적</button>
									</th>
									<th>
										<button class="btn_align">금일충전</button>
									</th>
									<th>
										<button class="btn_align">금일방전</button>
									</th>
								</tr>
								</thead>
								<tbody id="siteList">
									<!-- [D] 상태별 배경 : 't1' or 't2' 클래스 추가 -->
									<tr class="dbclickopen flag[INDEX]">
										<td class="first_td">
											<%--<span class="status status_err" title="통신이상">통신이상</span>--%>
											<span class="status status_drv" title="[status]">[status]</span>
											<span class="st_bar"></span>
										</td>
										<td>[alarmError]</td>
										<td>[alarmWarning]</td>
										<td class="left">[name]</td>
										<td class="right">[capacity]</td>
										<td class="right">[forecast]</td>
										<td class="right">[accumulate]</td>
										<td>-</td>
										<td>-</td>
									</tr>
									<tr class="detail_info list[INDEX] flag[INDEX]">
										<td colspan="9">
											<div class="di_wrap">
												<div class="di_wrap_in">
													<div class="di_top_sec">
														<span class="ico solar"></span>
														<div class="tx_area clear">
															<div class="fl">
																<span class="tx">일사량</span>
																<span class="tx2">[irradiationPoa] W/㎡</span>
															</div>
															<div class="fr">
																<span class="tx2">온도 [temperature]</span>
																<span class="tx2">습도 [humidity]</span>
															</div>
														</div>
													</div>
													<div class="di_btm_sec clear">
														<div class="sec_bx left">
															<div class="bx_in">
																<div class="bx_top">
																	<div class="inchart" id="type_chart[INDEX]"></div>
																</div>
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit">설비 출력 (kW)</span>
																		<span class="di_li_tx">[activePower]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">금일 누적발전 (kWh)</span>
																		<span class="di_li_tx">[accumulate]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">금일 예측발전 (kWh)</span>
																		<span class="di_li_tx">[forecast]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">전일 총발전량 (kWh)</span>
																		<span class="di_li_tx">[beforeDay]</span>
																	</li>
																</ul>
															</div>
														</div>
														<div class="sec_bx right">
															<div class="bx_in">
																<div class="bx_top">
																	<div class="bx_top_inner"></div>
																</div>
																<ul class="di_list">
																	<li>
																		<span class="di_li_tit">총 설비용량 (kW)</span>
																		<span class="di_li_tx">[capacity]</span>
																	</li>
																	<li>
																		<span class="di_li_tit">총 인버터수량 (EA)</span>
																		<span class="di_li_tx">[inverterCount]</span>
																	</li>
																</ul>
																<div class="di_tx_bx">
																	<a href="javascript:void(0);"
																		onclick="pageMove('[sid]', 'alarm')">
																		<p class="tx">최근 미처리 오류 :
																			<span>[alarmTotal] 건</span></p>
																	</a>
																	<%--<p class="tx">2020-02-10 12:00:01 데이터 disconnected</p>--%>
																	<%--<p class="tx">2020-02-09 11:41:26 인버터#1 이상 감지</p>--%>
																</div>
															</div>
														</div>
													</div>
													<div class="btn_bx clear">
														<a href="javascript:void(0);" onclick="pageMove('[sid]', 'siteMain')" class="btn_type02 fr">대시 보드 보기 <span class="ico_arrow"></span></a>
													</div>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript" src="/js/dashboard.js"></script>
<script type="text/javascript">
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');
	const sgid = '<c:out value="${sgid}" escapeXml="false" />';
	const today = new Date();

	let makerArray = new Array(siteList.length).fill(new Object());

	let map = new google.maps.Map(document.getElementById('gMainMap'), {
		mapTypeId: 'satellite',
		zoom: 7.3,
		mapTypeControl: false, //맵타입
		streetViewControl: false, //스트리트뷰
		fullscreenControl: false, //전체보기
		center: {lat: 36.549012, lng: 127.788546} // center: new google.maps.LatLng(37.549012, 126.988546),
	});
	let geocoder = new google.maps.Geocoder();
	let infowindow = new google.maps.InfoWindow();

	$(function () {
		setInitList('alarmNotice'); //알람 공지 세팅
		setInitList('siteList'); //사이트 리스트

		fn_cycle_1hour();
		fn_cycle_1min();
		setInterval(() => fn_cycle_1hour(), 60 * 60 * 1000);
		setInterval(() => fn_cycle_1min(), 60 * 1000);
	});

	function fn_cycle_1hour() {
		getYearGenData();
		getDailyGenData();
		getGenDataBySiteYesterday();
		searchSiteList();

		const now = new Date();
		$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
	}

	function fn_cycle_1min() {
		getTodayTotalDetail();
		getAlarmInfo();

		const now = new Date();
		$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
	}

	const geocodeAddress = (siteAddr, siteId, siteName, i) => {
		var address = siteAddr;
		geocoder.geocode({'address': address}, function (results, status) {
			if (status === 'OK') {
				makerArray[i] = (
					new google.maps.Marker({
						map: map,
						title: siteName,
						position: results[0].geometry.location,
						title: siteName
					})
				);

				var infowindow = new google.maps.InfoWindow({
					content: siteName
				});
				infowindow.open(map, makerArray[i]);

				google.maps.event.addListener(makerArray[i], 'click', (function (makerArray, i) {
					return function () {
						infowindow.open(map, makerArray[i]);
						var num = i + 1;
						var str = 'list' + num;
						list_detail_open(str);
					}
				})(makerArray, i));
			} else {
				map.setCenter({lat: 37.549012, lng: 126.988546});
			}
		});
	}

	const smoothZoom = (map, max, cnt, zoom) => {
		if (zoom) {
			if (cnt == 18) {
				return false;
			}

			if (cnt >= max) {
				return;
			} else {
				z = google.maps.event.addListener(map, 'zoom_changed', function (event) {
					google.maps.event.removeListener(z);
					smoothZoom(map, max, cnt + 1, true);
				});
				setTimeout(function () {
					map.setZoom(cnt)
				}, 80); // 80ms is what I found to work well on my system -- it might not work well on all systems
			}
		} else {
			if (cnt == 6) {
				return false;
			}

			if (cnt <= max) {
				return;
			} else {
				z = google.maps.event.addListener(map, 'zoom_changed', function (event) {
					google.maps.event.removeListener(z);
					smoothZoom(map, max, cnt - 1, false);
				});
				setTimeout(function () {
					map.setZoom(cnt)
				}, 80); // 80ms is what I found to work well on my system -- it might not work well on all systems
			}
		}
	}

	const rtnDropdown = () => {
		searchSite();
	}

	const pageMove = (id, action) => {
		let $form = $('#linkSiteForm');
		let $inp = $('<input>').attr('type', 'hidden').attr('name', 'sid').val(id);

		$form.append($inp);
		if (action == 'alarm') {
			$form.attr('action', '/history/alarmHistory.do').submit();
		} else {
			$form.attr('action', '/dashboard/smain.do').submit();
		}
	}
</script>