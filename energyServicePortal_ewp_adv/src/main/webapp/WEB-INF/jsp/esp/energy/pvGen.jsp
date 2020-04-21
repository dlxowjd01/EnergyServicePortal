<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">발전</h1>
	</div>
	<div id="siteList" class="header_drop_area col-lg-2">
		<div class="dropdown">
			<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
				선택해주세요.<span class="caret"></span>
			</button>
			<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-2 use_total">
		<div class="indiv">
			<h2 class="ntit">발전량 합계</h2>
			<div class="value_area">
				<h3 class="value_tit">실제 발전량</h3>
				<p class="value_num"><span class="num"></span>kwh</p>
			</div>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="indiv usage_chart pv_chart">
			<div class="chart_top clear">
				<div class="fl" id="deviceType">
					<span class="tx_tit">계량값</span>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">복수 선택
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type">
								<!--
									섹션(사업소)이 2개 일 때 : width:380px
									섹션(사업소)이 3개 일 때 : width:550px
									갯수가 하나씩 추가 될때마다 +170px 해주세요.
								-->
								<li class="dropdown_cov clear selectDevices" style="width:380px">
									<div class="li_btn_bx clear">
										<div class="fl">
											<button type="button" class="btn_type03">모두 선택</button>
											<button type="button" class="btn_type03">모두 해제</button>
										</div>
										<div class="fr">
											<button type="button" class="btn_type">적용</button>
										</div>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="fl">
					<span class="tx_tit">조회 기간</span>
					<div class="sa_select">
						<div class="dropdown" id="period">
							<button class="btn btn-primary dropdown-toggle w8 selectTerm" type="button" data-toggle="dropdown" data-value="today">
								오늘<span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li data-value="today" class="on"><a href="#">오늘</a></li>
								<li data-value="week"><a href="#">이번 주</a></li>
								<li data-value="month"><a href="#">이번 달</a></li>
								<li data-value="setup"><a href="#">기간 설정</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="fl" id="dateArea">
					<span class="tx_tit">기간 설정</span>
					<div class="sel_calendar">
						<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" readonly>
						<em></em>
						<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" readonly>
					</div>
				</div>
				<div class="fl" id="cycle">
					<span class="tx_tit">주기</span>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w3 interval" type="button" data-toggle="dropdown">
								기간<span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li class="on"><a href="#">15분</a></li>
<%--								<li><a href="#">30분</a></li>--%>
								<li><a href="#">1시간</a></li>
								<li><a href="#">1일</a></li>
								<li><a href="#">1월</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="fl">
					<button type="button" class="btn_type" id="renderBtn">조회</button>
				</div>
				<div class="fr">
					<span class="tx_tit">그래프 스타일</span>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
								개별 막대<span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li data-value="allSum"><a href="#">전체 합산</a></li>
								<li data-value="siteSum"><a href="#">사이트별 합산</a></li>
								<li data-value="each" class="on"><a href="#">개별 막대</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<p class="tx_time">2020-03-06 22:00:09</p>
			<br>
			<br>
			<br>
			<br>
			<div class="inchart">
				<div id="chart2"></div>
			</div>
		</div>
	</div>
</div>
<div class="row pv_chart_table" style="display:none;">
	<div class="col-lg-12">
		<div class="indiv clear">
			<div class="tbl_save_bx">
				<a href="#;" class="save_btn">데이터저장</a>
			</div>
			<div class="tbl_top clear">
				<h2 class="ntit fl">발전량 도표</h2>
				<ul class="fr">
					<li><a href="#;" class="fold_btn">표접기</a></li>
				</ul>
			</div>
			<div class="tbl_wrap">
				<div class="fold_div">
					<!-- PC 버전용 테이블 -->
					<div class="chart_table">
						<table class="pc_use">
							<thead>
								<tr>
									<th>2020-08-01</th>
									<th>01:00</th>
									<th>02:00</th>
									<th>03:00</th>
									<th>04:00</th>
									<th>05:00</th>
									<th>06:00</th>
									<th>07:00</th>
									<th>08:00</th>
									<th>09:00</th>
									<th>10:00</th>
									<th>11:00</th>
									<th>12:00</th>
									<th>13:00</th>
									<th>14:00</th>
									<th>15:00</th>
									<th>16:00</th>
									<th>17:00</th>
									<th>18:00</th>
									<th>19:00</th>
									<th>20:00</th>
									<th>21:00</th>
									<th>22:00</th>
									<th>23:00</th>
									<th>24:00</th>
									<th>합계</th>
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
<script type="text/javascript">
	$(function() {
		siteList(); //사이트 조회
		//사이트 선택시
		$(document).on('click', ':checkbox[name="site"]', function() {
			 if($(this).is(':checked')) {
				 let extendText = '';
				 if ($(':checkbox[name="site"]:checked').length > 1) {
					 extendText = '외 ' + Number($(':checkbox[name="site"]:checked').length - 1) + '개';
				 }
				 //첫 번째 값 + 외 몇개로 표기
				 $('#siteList button').html($(':checkbox[name="site"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
			 } else {
				if($(':checkbox[name="site"]:checked').length == 0) {
					$('#siteList button').html('선택해주세요.' + '<span class="caret"></span>')
				} else {
						let extendText = '';
						if ($(':checkbox[name="site"]:checked').length > 1) {
							extendText = '외 ' + Number($(':checkbox[name="site"]:checked').length - 1) + '개';
						}
						//첫 번째 값 + 외 몇개로 표기
						$('#siteList button').html($(':checkbox[name="site"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
				}
			 }
			device();
		});

		//전체 선택/전체 해제
		$('#deviceType button.btn_type03').on('click', function (e) {
			var idx = $('#deviceType button.btn_type03').index($(this));

			if (idx == 0) {
				$(':checkbox[name="device"]').prop('checked', true);
			} else {
				$(':checkbox[name="device"]').prop('checked', false);
			}
		});

		$('#renderBtn').on('click', function() {
			fetchGenData();
		});

		$('#period li').on('click', function() {
			if($(this).data('value') == 'setup') {
				$('#dateArea').show();
			} else {
				if($(this).data('value') == 'today') {//오늘
					// $('#cycle').
					$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
					$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
				} else if($(this).data('value') == 'week') {//이번주
					$('#datepicker1').datepicker('setDate', '-6'); //데이트 피커 기본
					$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
				} else { //이번달
					$('#datepicker1').datepicker('setDate', '-30'); //데이트 피커 기본
					$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
				}
				// $('#dateArea').hide();
			}
		});

		$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
	});

	//사업소 호출
	const siteList = function() {
		$.ajax({
			url:"http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data: { oid: "spower" },
			success: function(sites){
				//세션에 데이터 저장
				sessionStorage.setItem("sites", JSON.stringify(sites));
				$('#siteList>div>ul').empty();

				//사이트 리스트
				<!--$('#siteList button').text(`${'${sites[0].name}'} 외 ${'${sites.length-1}'} 개`);-->

				let grp = $('<p>').addClass('tx_li_tit').html('사업소별');

				let grpTemp = $('<li>').addClass('dropdown_cov clear').append('<div>');
				grpTemp.find('div').addClass('sec_li_bx').append(grp).append('<ul>');
				console.log(grpTemp.html());

				let str = ``;
				sites.forEach((site, index) => {
					str += `<li>
								<a href="#" data-value="${'${site.sid}'}" tabindex="-1">
									<input type="checkbox" id="${'${site.sid}'}" value="${'${site.sid}'}" name="site">
									<label for="${'${site.sid}'}"><span></span>${'${site.name}'}</label>
								</a>
							</li>`
				});

				grpTemp.find('ul').append(str);
				$('#siteList>div>ul').append(grpTemp);
			},
			error: function(error){
				console.error(error);
			}
		});
	};

	const device = function() {
		$('#deviceType button.btn-primary').empty().append('복수 선택').append('<span class="caret"></span>');

		if($(':checkbox[name="site"]:checked').length > 0) {
			var size = 380 + (Number($(':checkbox[name="site"]:checked').length - 2) * 170);
			if(size < 380) {
				size = 380;
			}
			$('#deviceType li.selectDevices').css('width', size);
			$('#deviceType div.sec_li_bx').remove();
			$(':checkbox[name="site"]:checked').each(function() {
				let sid = $(this).val()
					, sNm = $(this).next('label').text();

				$.ajax({
					url: 'http://iderms.enertalk.com:8443/config/devices/',
					type: 'get',
					async: false,
					data: {
						oid: 'spower',
						sid: sid
					},
					success: function(result) {
						let devices = result;
						if(devices.length > 0) {
							let siteGrp = $('<div>').addClass('sec_li_bx');
							siteGrp.append('<p>');
							siteGrp.find('p').addClass('tx_li_tit').text(sNm);
							siteGrp.append('<ul>');

							let chargeArr = new Array();
							let dashArr = new Array();
							let deviceType = ['SM', 'SM_ISMART', 'SM_KPX', 'SM_CRAWLING', 'SM_MANUAL', 'INV_PV', 'INV_WIND', 'PCS_ESS', 'BMS_SYS',
								'BMS_RACK', 'SENSOR_SOLAR', 'SENSOR_FLAME', 'SENSOR_TEMP_HUMIDITY', 'CCTV', 'COMBINER_BOX', 'CIRCUIT_BREAKER'];
							$.each(devices, function(i, el) {

								$.each(deviceType, function(j, tp) {
									if(tp == el.device_type && (el.dashboard||el.billing)) {
										let deviceHtml = $('<li>').append('<a>');
										deviceHtml.find('a').attr('href', '#').attr('tabindex', '-1');
										deviceHtml.find('a').append('<input id="' + el.did + '" name="device" type="checkbox" value="' + el.did + '" data-name="' + el.name + '">').append('<label>');
										deviceHtml.find('label').attr('for', el.did).append('<span>').append('&nbsp;' + el.name);
										siteGrp.find('ul').append(deviceHtml);
										if(el.dashboard) {
											chargeArr.push(el.did);
										}

										if(el.billing) {
											dashArr.push(el.did);
										}
									}
								});
							});

							$('#deviceType li.selectDevices').prepend(siteGrp);

							let deviceHtml1 = $('<li>').append('<a>');
							deviceHtml1.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml1.find('a').append('<input id="deivce_charge_' + sid + '" name="device" type="checkbox" value="' + chargeArr.join(',') + '" data-name="매전">').append('<label>');
							deviceHtml1.find('label').attr('for', 'deivce_charge' + sid).append('<span>').append('&nbsp;매전량');
							siteGrp.find('ul').prepend(deviceHtml1);

							let deviceHtml2 = $('<li>').append('<a>');
							deviceHtml2.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml2.find('a').append('<input id="device_dash' + sid + '" name="device" type="checkbox" value="' + dashArr.join(',') + '" data-name="대시보드">').append('<label>');
							deviceHtml2.find('label').attr('for', 'device_dash' + sid).append('<span>').append('&nbsp;대시보드');
							siteGrp.find('ul').prepend(deviceHtml2);

						}
					},
					dataType: "json"
				});
			});
		}
	};

	<%--//그래프 선택 조건 받기--%>
	function fetchGenData(){
		//사이트 별로 체크된 것 확인
		//체크된 사이트
		const checkedSites = $.makeArray($('input[name="site"]:checked').map(
				function(){
					return $(this).attr("id");
				}
			)
		);

		//체크된 디바이스
		const checkedDevices = $.makeArray($('input[name="device"]:checked').map(
				function(){
					return $(this).attr("id");
				}
			)
		);

		if(checkedSites.length == 0) {
			alert('사이트를 한개이상 선택해 주세요.');
			return false;
		}

		if(checkedDevices.length == 0) {
			alert('장비를 한개이상 선택해 주세요.');
			return false;
		}

		//조회 기간 확인
		const selectTerm = $('button.selectTerm').text();
		//기간 설정 확인
		const startTime = $('#datepicker1').val().replace(/-/g, '') + "000000";
		const endTime = $('#datepicker2').val().replace(/-/g, '') + "235959";
		//주기 확인
		let interval = '';
		switch ($('button.interval').text()) {
			case '15분':
				interval = '15min';
				break;
			case '30분':
				interval = '30min';
				break;
			case '1시간':
				interval = 'hour';
				break;
			case '1일':
				interval = 'day';
				break;
			case '1월':
				interval = 'month';
				break;
			default:
				interval = 'hour';
				break;
		}

		//API 호출
		$.ajax({
			url: "http://iderms.enertalk.com:8443/status/summary",
			type: "get",
			async: false,
			data: {
				sids: checkedSites.toString(),
				dids: checkedDevices.toString(),
				startTime: startTime,
				endTime: endTime,
				interval: interval
			},
			success: function(data) {
				console.log('data', data);
				$('table.pc_use tbody').empty();

				let sDate = $('#datepicker1').val().replace(/-/g, '');
				let eDate = $('#datepicker2').val().replace(/-/g, '');
				let dateArr = new Array();

				if(interval == 'day') {
					let diffMonth = getDiff(eDate, sDate, 'month');
					let diffDay = getDiff(eDate, sDate, 'day');
					if(diffMonth == 1) {
						for(let j = 0; j < diffDay; j++) {
							let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1 , Number(sDate.substring(6, 8)));
							sDateTime.setDate(sDateTime.getDate() + j);
							let toDate = sDateTime.format('yyyyMMdd');
							dateArr.push(toDate);
						}
					} else {
						for(let j = 0; j < diffMonth; j++) {
							let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1 , 1);
							sDateTime.setMonth(sDateTime.getMonth() + j);
							for(let k = 1; k <= 31; k++) {
								let toMonth = sDateTime.format('yyyyMM');
								if(k < 10) {
									dateArr.push(toMonth + '0' + k);
								} else {
									dateArr.push(toMonth + k);
								}
							}
						}
					}
					console.log(dateArr);
				} else if(interval == 'month') {
					if(eDate.substring(0, 4) != sDate.substring(0, 4)) {
						for(let r = Number(sDate.substring(0, 4)); r <= Number(eDate.substring(0, 4)); r++) {
							for(let j = 1; j <= 12; j++) {
								if(j < 10) {
									dateArr.push(r + '0' + j);
								} else {
									dateArr.push(r +  j);
								}
							}
						}
					} else {
						let diffMonth = getDiff(eDate, sDate, 'month');
						for(let j = 0; j < diffMonth; j++) {
							let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - j- 1 , 1);
							let toDate = sDateTime.format('yyyyMM');
							dateArr.push(toDate);
						}
					}
					console.log(dateArr);
				} else {
					let diffDay = getDiff(eDate, sDate, 'day');
					//diffDay 1보다 크면 시작일과 종료일이 다르다.
					for(let j = 0; j < diffDay; j++) {
						let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1 , Number(sDate.substring(6, 8)));
						sDateTime.setDate(sDateTime.getDate() + j);
						let toDate = sDateTime.format('yyyyMMdd');

						for(let i = 0; i <= 24; i++) {
							if(interval == '15min') { //15분
								if(String(i).length == 1) {
									dateArr.push(toDate + '0' + i +'0000');
									dateArr.push(toDate + '0' + i +'1500');
									dateArr.push(toDate + '0' + i +'3000');
									dateArr.push(toDate + '0' + i +'4500');
								} else {
									dateArr.push(toDate + i +'0000');
									dateArr.push(toDate + i +'1500');
									dateArr.push(toDate + i +'3000');
									dateArr.push(toDate + i +'4500');
								}
							} else if(interval == '30min') { //30분
								if(String(i).length == 1) {
									dateArr.push(toDate + '0' + i +'0000');
									dateArr.push(toDate + '0' + i +'3000');
								} else {
									dateArr.push(toDate + i +'0000');
									dateArr.push(toDate + i +'3000');
								}
							} else { //시간
								if(String(i).length == 1) {
									dateArr.push(toDate + '0' + i +'0000');
								} else {
									dateArr.push(toDate + i +'0000');
								}
							}
						}
						console.log(dateArr);
						console.log('toDate', toDate);
					}
				}

				let gridData = gridDataMake(dateArr, data, interval);
				let totalPower = 0;

				if(interval == '15min' || interval == 'hour') {
					let dateVal = '';
					let tr = $('<tr>');
					$('table.pc_use thead').empty();
					$.each(dateArr, function(i, el) {
						let th = $('<th>');
						if(dateVal == '') {
							dateVal = el.substring(0, 8);
							th.text(dateVal.substring(0, 4) + '-' + dateVal.substring(4, 6) + '-' + dateVal.substring(6, 8));
							tr.append(th);

							th = $('<th>');
							let time = el.substring(8, 10) + ':' + el.substring(10, 12);
							th.text(time);
							tr.append(th);
						} else if(dateVal != el.substring(0, 8) || dateArr.length == (i + 1)) {
							if(dateArr.length == (i + 1)) {
								let time = el.substring(8, 10) + ':' + el.substring(10, 12);
								th.text(time);
								tr.append(th);

								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == dateVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data));
												$dataTr.append($dataTd);
											});
											totalPower += Number(grid.data[grid.data.length - 1]);
											$('table.pc_use tbody').append($dataTr);
										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == dateVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											totalPower += Number(grid.data[grid.data.length - 1]);
											$('table.pc_use tbody').append($dataTr);
										}
									});
								}
								return false;
							} else {
								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == dateVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											totalPower += Number(grid.data[grid.data.length - 1]);
											$('table.pc_use tbody').append($dataTr);
										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == dateVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											totalPower += Number(grid.data[grid.data.length - 1]);
											$('table.pc_use tbody').append($dataTr);
										}
									});
								}

								tr = $('<tr>');
								th = $('<th>');
								dateVal = el.substring(0, 8);
								th.text(el.substring(0, 4) + '-' + el.substring(4, 6) + '-' + el.substring(6, 8));
								tr.append(th);

								th = $('<th>');
								let time = el.substring(8, 10) + ':' + el.substring(10, 12);
								th.text(time);
								tr.append(th);
							}
						} else {
							let time = el.substring(8, 10) + ':' + el.substring(10, 12);
							th.text(time);
							tr.append(th);
						}
					});
				} else if(interval == 'day') {
					let yearMonthVal = '';
					let tr = $('<tr>');
					$('table.pc_use thead').empty();
					$.each(dateArr, function(i, el) {
						let th = $('<th>');
						if(yearMonthVal == '') {
							yearMonthVal = el.substring(0, 6);
							th.text(yearMonthVal.substring(0, 4) + '-' + yearMonthVal.substring(4, 6));
							tr.append(th);

							th = $('<th>');
							let day = el.substring(6, 8);
							th.text(day);
							tr.append(th);
							if(dateArr.length == 1) {
								th.text(el.substring(6, 8));
								tr.append(th);

								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearMonthVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											totalPower += Number(grid.data[grid.data.length - 1]);
											$('table.pc_use tbody').append($dataTr);
										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearMonthVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);
										}
									});

								}
								return false;
							}
						} else if(yearMonthVal != el.substring(0, 6) || dateArr.length == (i + 1)) {
							if(dateArr.length == (i + 1)) {
								th.text(el.substring(6, 8));
								tr.append(th);

								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearMonthVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);
										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearMonthVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);
										}
									});
								}
							} else {
								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearMonthVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);
										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearMonthVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(numberComma(data))
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);
										}
									});
								}

								tr = $('<tr>');
								th = $('<th>');
								yearMonthVal = el.substring(0, 6);
								th.text(el.substring(0, 4) + '-' + el.substring(4, 6));
								tr.append(th);

								th = $('<th>');
								th.text(el.substring(6, 8));
								tr.append(th);
							}
						} else {
							th.text(el.substring(6, 8));
							tr.append(th);
						}
					});
				} else if(interval == 'month') {
					let yearVal = '';
					let tr = $('<tr>');
					$('table.pc_use thead').empty();
					$.each(dateArr, function(i, el) {
						yearVal = el.substring(0, 4);
						let th = $('<th>');
						if(yearVal) {
							yearVal = el.substring(0, 4);
							th.text(yearVal.substring(0, 4));
							tr.append(th);

							th = $('<th>');
							th.text(el.substring(4, 6));
							tr.append(th);
							if(dateArr.length == 1) {
								th.text(el.substring(4, 6));
								tr.append(th);

								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(data)
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);

										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(data)
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);

										}
									});
								}
								return false;
							}
						}  else if(yearVal != el.substring(0, 4) || dateArr.length == (i + 1)) {
							if(dateArr.length == (i + 1)) {
								th.text(el.substring(4, 6));
								tr.append(th);

								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(data)
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);

										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(data)
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);

										}
									});
								}
							} else {
								if($('table.pc_use thead tr').length == 0) {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use thead').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(data)
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);

										}
									});
								} else {
									th = $('<th>').html('합계');
									tr.append(th);
									$('table.pc_use tbody').append(tr);

									$.each(gridData, function(q, grid) {
										if(grid.std == yearVal) {
											$dataTr = $('<tr>').append('<td>' + grid.deviceNm + '</td>');
											$.each(grid.data, function(w, data) {
												$dataTd = $('<td>').html(data)
												$dataTr.append($dataTd);
											});
											$('table.pc_use tbody').append($dataTr);
											totalPower += Number(grid.data[grid.data.length - 1]);

										}
									});
								}

								tr = $('<tr>');
								th = $('<th>');
								yearVal = el.substring(0, 4);
								th.text(el.substring(0, 4));
								tr.append(th);

								th = $('<th>');
								th.text(el.substring(4, 6));
								tr.append(th);
							}
						} else {
							th.text(el.substring(4, 6));
							tr.append(th);
						}
					});
				}

				chartDraw(dateArr, data, interval);

				$('.value_num > span').text(numberComma(totalPower));
				$('table.pc_use').parents('.pv_chart_table').show();
				console.log(dateArr);
			},
			error: function(error){
				console.error(error);
			}
		})
	}

	//그리드 데이터 만들기
	function gridDataMake(standard, arr, type) {
		let dataArr = new Array();

		//일단 정렬
		arr.sort(function(a, b) {
			return a['localtime'] - b['localtime'];
		})

		$(':checkbox[name="device"]:checked').each(function() {
			let arrDevice = new Array();
			let deviceId = $(this).val();
			let deviceNm = $(this).data('name');
			let total = 0;
			let stdDate = '';
			$.each(standard, function(j, stnd) {
				let timeValue = '-';

				if(type == '15min' || type == 'hour') {
					if(stdDate == '') {
						stdDate = stnd.substring(0, 8);
					} else if(stdDate != '' && stdDate != stnd.substring(0, 8)) {
						arrDevice.push(total); //합계.

						let tempMap = {
							deviceId: deviceId,
							deviceNm: deviceNm,
							std: stdDate,
							data: arrDevice
						}

						dataArr.push(tempMap);

						stdDate = stnd.substring(0, 8);
						total = 0;
						arrDevice = new Array();
					}

					$.each(arr, function(i, el) {
						if(deviceId == el.did) {
							if(stnd == el.localtime) {
								timeValue = eval('el.totalGenPower');
								total += Number(timeValue);
							}
						}
					});
				} else if(type == 'day') {
					if(stdDate == '') {
						stdDate = stnd.substring(0, 6);
					} else if(stdDate != '' && stdDate != stnd.substring(0, 6)) {
						arrDevice.push(total); //합계.

						let tempMap = {
							deviceId: deviceId,
							deviceNm: deviceNm,
							std: stdDate,
							data: arrDevice
						}

						dataArr.push(tempMap);

						stdDate = stnd.substring(0, 6);
						total = 0;
						arrDevice = new Array();
					}

					$.each(arr, function(i, el) {
						if(deviceId == el.did) {
							if(stnd + '000000' == el.localtime) {
								timeValue = eval('el.totalGenPower');
								total += Number(timeValue);
							}
						}
					});
				} else {
					if(stdDate == '') {
						stdDate = stnd.substring(0, 4);
					} else if(stdDate != '' && stdDate != stnd.substring(0, 4)) {
						arrDevice.push(total); //합계.

						let tempMap = {
							deviceId: deviceId,
							deviceNm: deviceNm,
							std: stdDate,
							data: arrDevice
						}

						dataArr.push(tempMap);

						stdDate = stnd.substring(0, 4);
						total = 0;
						arrDevice = new Array();
					}

					$.each(arr, function(i, el) {
						if(deviceId == el.did) {
							if(el.localtime.match(stnd)) {
								timeValue = eval('el.totalGenPower');
								total += Number(timeValue);
							}
						}
					});
				}

				arrDevice.push(timeValue);
			});

			arrDevice.push(total); //합계.

			let tempMap = {
				deviceId: deviceId,
				deviceNm: deviceNm,
				std: stdDate,
				data: arrDevice
			}

			dataArr.push(tempMap);
		});

		console.log(dataArr);
		return dataArr;
	}

	//두기간 사이 차이 구하기.
	function getDiff(eDate, sDate, type) {
		eDate = new Date(eDate.substring(2, 4), eDate.substring(4, 6), eDate.substring(6, 8));
		sDate = new Date(sDate.substring(2, 4), sDate.substring(4, 6), sDate.substring(6, 8));
		if(type == 'day') {
			return (((((eDate - sDate)/1000)/60)/60)/24) + 1;
		} else if(type == 'month') {
			if(eDate.format('yyyyMMdd').substring(0,4) == sDate.format('yyyyMMdd').substring(0,4)) {
				return (eDate.format('yyyyMMdd').substring(4,6) * 1 - sDate.format('yyyyMMdd').substring(4,6) * 1) + 1;
			} else {
				return Math.round((eDate - sDate) / (1000*60*60*24*365/12)) + 1;
			}
		}
	}

	//차트
	function chartDraw(standard, arr, type) {
		let seriesData = new Array();

		if(arr.length > 0) {
			let dataArr = new Array();

			//일단 정렬
			arr.sort(function (a, b) {
				return a['localtime'] - b['localtime'];
			})

			$(':checkbox[name="device"]:checked').each(function (index) {
				let arrDevice = new Array();
				let deviceId = $(this).val();
				let deviceNm = $(this).data('name');
				let stdDate = '';

				$.each(standard, function (j, stnd) {
					let timeValue = '-';
					$.each(arr, function (i, el) {
						if (deviceId == el.did) {
							if (el.localtime.match(stnd)) {
								if(isNaN(eval('el.totalGenPower'))) {
									timeValue = parseInt(eval('el.totalGenPower'));
								} else {
									timeValue = eval('el.totalGenPower');
								}
							}
						}
					});
					arrDevice.push(timeValue);
				});

				$temp = {
					name: deviceNm,
					type: 'column',
					stack: index,
					tooltip: {
						valueSuffix: 'kW'
					},
					data: arrDevice
				};
				seriesData.push($temp);
			});
		}

		Highcharts.chart('chart2', {
			chart: {
				marginLeft: 80,
				marginRight: 0,
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
				labels: {
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
					value: 15, /* 현재 */
					color: '#438fd7',
					width: 2,
					zIndex: 0,
					label: {
						text: ''
					}
				}],
				crosshair: true /* 포커스 선 */
			},

			yAxis: {
				gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
				min: 0, /* 최소값 지정 */
				title: {
					text: '(kWh)',
					align: 'low',
					rotation: 0, /* 타이틀 기울기 */
					y: 25, /* 타이틀 위치 조정 */
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
				shared: true /* 툴팁 공유 */
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
			series: seriesData,

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
	}
</script>