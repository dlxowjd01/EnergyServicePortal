<%@ page language="java" contentType="text/html; charset=utf-8"
pageEncoding="utf-8"%> <%@ include file="/decorators/include/taglibs.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">발전 예측</h1>
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
	<div class="col-lg-3 col-md-4">
		<div class="indiv fixed_height">
			<h2 class="ntit">예측 요약</h2>
			<div class="value_area">
				<h3 class="value_tit">측정값</h3>
				<p class="value_num"></p>
			</div>
			<div class="value_area">
				<h3 class="value_tit">예측값</h3>
				<p class="value_num"></p>
			</div>
			<div class="value_area">
				<h3 class="value_tit">예측 오차 평균</h3>
				<p class="value_num"></p>
			</div>
			<div class="toggle_bx">
				<div class="tb_area clear">
					<p class="tb_tx fl">예측 오차 계산법</p>
					<button class="tb_fold_btn fr">펼치기</button>
				</div>
				<div class="tb_fold_div">
					<div class="dropdown" id="measure">
						<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown"
							data-value="NMAE">
							NMAE<span class="caret"></span>
						</button>
						<ul class="dropdown-menu">
							<li data-value="NMAE" class="on">
								<a href="#">NMAE</a>
							</li>
							<li data-value="MAPE"><a href="#">MAPE</a></li>
							<li data-value="RRMSE"><a href="#">RRMSE</a></li>
						</ul>
					</div>
					<p class="tb_tx">오차 계산 데이터 필터</p>
					<div class="dropdown mb-10" id="ignore_ref">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
							용량 대비 발전량 % 이상<span class="caret"></span>
						</button>
						<ul class="dropdown-menu">
							<li data-value="" class="on">
								<a href="#">모두</a>
							</li>
							<li data-value="capacity">
								<a href="#">용량 대비 발전량 % 이상</a>
							</li>
							<li data-value="observation">
								<a href="#">발전량 kWh 이상</a>
							</li>
						</ul>
					</div>
					<div class="flex_wrapper">
						<div class="tx_inp_type unit">
							<input type="number" name="ignore_tolerance1" />
							<span>%</span>
						</div>
						<div class="tx_inp_type unit t1">
							<input type="number" name="ignore_tolerance2" />
							<span>kWh</span>
						</div>
					</div>
					<button type="button" class="btn_type" id="application">
						적용
					</button>
				</div>
			</div>
		</div>
	</div>
	<div class="col-lg-9 col-md-8">
		<div class="indiv diagnosis_chart">
			<div class="chart_top clear">
				<div id="deviceType">
					<span class="tx_tit">계량값</span>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">
								복수 선택<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type">
								<li class="dropdown_cov clear selectDevices">
									<div class="li_btn_bx clear">
										<div class="fl">
											<button type="submit" class="btn_type03">모두 선택</button>
											<button type="submit" class="btn_type03">모두 해제</button>
										</div>
										<div class="end">
											<button type="submit" class="btn_type">적용</button>
										</div>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="inline_flex">
					<div class="period">
						<span class="tx_tit">기간</span>
						<div class="sa_select">
							<div class="dropdown" id="period">
								<button class="btn btn-primary dropdown-toggle" type="button"
									data-toggle="dropdown">오늘<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="today" class="on"><a href="#">오늘</a></li>
									<li data-value="week"><a href="#">이번 주</a></li>
									<li data-value="month"><a href="#">이번 달</a></li>
									<li data-value="setup"><a href="#">기간 설정</a></li>
								</ul>
							</div>
						</div>
					</div>

					<div class="duration" id="dateArea">
						<span class="tx_tit">기간 설정</span>
						<div class="sel_calendar">
							<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" readonly />
							<em></em>
							<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" readonly />
						</div>
					</div>

					<div class="unit" id="cycle">
						<span class="tx_tit">단위</span>
						<div class="sa_select">
							<div class="dropdown" id="interval">
								<button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown"
									data-value="15min">
									기간<span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li data-value="15min" class="on"><a href="#">15분</a></li>
									<li data-value="hour"><a href="#">1시간</a></li>
									<li data-value="day"><a href="#">1일</a></li>
									<li data-value="month"><a href="#">1월</a></li>
								</ul>
							</div>
						</div>
					</div>
					<button type="button" class="btn_type" id="renderBtn">조회</button>
				</div>
			</div>
			<div class="end">
				<a href="#" class="chart_change_column" id="changeChart">그래프</a>
			</div>

			<div class="inchart">
				<p class="tx_time">2020-03-06 22:00:09</p>
				<div id="chart2"></div>
			</div>
		</div>
	</div>
</div>


<div class="row pv_chart_table">
	<div class="col-lg-12">
		<div class="indiv clear">
			<div class="tbl_save_bx">
				<a href="#" class="save_btn">데이터저장</a>
			</div>
			<div class="tbl_top clear">
				<h2 class="ntit fl">예측 결과 도포</h2>
				<ul class="fr">
					<li><a href="#" class="fold_btn">표접기</a></li>
				</ul>
			</div>
			<div class="tbl_wrap">
				<div class="fold_div" id="pc_use"></div>
			</div>
		</div>
	</div>
</div>
<form name="form" method="post">
	<input type="hidden" name="observed" />
	<input type="hidden" name="forecasted" />
	<input type="hidden" name="sid" />
	<input type="hidden" name="did" />
	<input type="hidden" name="measure" />
	<input type="hidden" name="ignore_ref" />
	<input type="hidden" name="ignore_tolerance" />
	<input type="hidden" name="interval" />
</form>
<script type="text/javascript">
	let standard = new Array();
	let applicationData = {
		observed: null,
		observedType: 'column',
		forecasted: null,
		forecastedType: 'column'
	};

	$(function () {
		siteList(); //사이트 조회

		//사이트 선택시
		$(document).on('click', ':checkbox[name="site"]', function () {
			if ($(this).is(':checked')) {
				let extendText = '';
				if ($(':checkbox[name="site"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="site"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$('#siteList button').html($(':checkbox[name="site"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
			} else {
				if ($(':checkbox[name="site"]:checked').length == 0) {
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

		$('#renderBtn').on('click', function () {
			fetchGenData();
		});

		$('#period li').on('click', function () {
			if ($(this).data('value') == 'today') { //오늘
				$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
				$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
			} else if ($(this).data('value') == 'week') { //이번주
				$('#datepicker1').datepicker('setDate', '-6'); //데이트 피커 기본
				$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
			} else { //이번달
				$('#datepicker1').datepicker('setDate', '-30'); //데이트 피커 기본
				$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
			}
		});

		$('.tb_fold_btn').click(function () {
			var tbl_height = $(".tb_fold_div").height();
			$('.tb_fold_div').slideToggle();
			$(this).toggleClass("on");
			$(this).text($(this).text() == '내용접기' ? '펼치기' : '내용접기');
		});

		//몬가를 선택함.
		$('#measure li').on('click', function () {
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).html($(this).find('a').text() + '&nbsp;<span class="caret"></span>');
		});

		//몬가를 선택함.
		$('#interval li').on('click', function () {
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).html($(this).find('a').text() + '&nbsp;<span class="caret"></span>');
		});

		//몬가를 선택함.
		$('#ignore_ref li').on('click', function () {
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).html($(this).find('a').text() + '&nbsp;<span class="caret"></span>');
			if ($(this).data('value') == 'capacity') {
				$('input[name="ignore_tolerance1"]').prop('disabled', false);
				$('input[name="ignore_tolerance2"]').prop('disabled', true);
			} else if ($(this).data('value') == 'observation') {
				$('input[name="ignore_tolerance1"]').prop('disabled', true);
				$('input[name="ignore_tolerance2"]').prop('disabled', false);
			} else {
				$('input[name="ignore_tolerance1"]').prop('disabled', true);
				$('input[name="ignore_tolerance2"]').prop('disabled', true);
			}
		});

		$('#changeChart').on('click', function () {

			if (applicationData.type == '3') {
				applicationData.type = '1';
				applicationData.observedType = 'column';
				applicationData.forecastedType = 'column';
			} else if (applicationData.type == '2') {
				applicationData.type = '3';
				applicationData.observedType = 'spline';
				applicationData.forecastedType = 'spline';
			} else {
				applicationData.type = '2';
				applicationData.observedType = 'column';
				applicationData.forecastedType = 'spline';
			}

			chartMakeData();
		});

		$('.save_btn').on('click', function (e) {
			let excelName = '발전예측';
			let $val = $('#pc_use').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {
					tableToExcel('pc_use', excelName, e);
				}
			}
		});

		//올차범위 조회
		$('#application').on('click', function () {
			application();
		});

		$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
	});

	const application = function (stat) {

		const sites = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		//체크된 디바이스
		const checkedDevices = $.makeArray($('input[name="device"]:checked').map(
			function () {
				if (!$(this).attr('id').match('device')) {
					return $(this).attr('id');
				}
			}
		));

		if (stat == 'basic') {
			$('#measure li a').eq(0).addClass('on');
			$('#measure button').data('value', 'NMAE').html('NMAE &nbsp;<span class="caret"></span>');

			$('#ignore_ref li a').eq(1).addClass('on');
			$('#ignore_ref button').data('value', 'capacity').html('용량 대비 발전량 % 이상 &nbsp;<span class="caret"></span>');

			$('input[name="ignore_tolerance1"]').val('10');
			$('input[name="ignore_tolerance2"]').val('');
		}

		let ignore_ref = $('#ignore_ref button').data('value');
		let ignore_tolerance = null;
		if (ignore_ref == 'capacity') {
			ignore_tolerance = $('input[name="ignore_tolerance1"]').val();
		} else if (ignore_ref == 'observation') {
			ignore_tolerance = $('input[name="ignore_tolerance2"]').val();
		} else {
			ignore_ref = null;
			ignore_tolerance = null;
		}


		let data = {
			'observed': applicationData.observed,
			'forecasted': applicationData.forecasted,
			'sid': sites,
			'did': checkedDevices,
			'measure': $('#measure button').data('value'),
			'ignore_ref': ignore_ref,
			'ignore_tolerance': ignore_tolerance,
			'interval': $('#interval button').data('value')
		}

		$.ajax({
			url: "http://iderms.enertalk.com:8443/energy/forecasting/error_calculator",
			type: "post",
			async: false,
			contentType: "application/json",
			traditional: true,
			data: JSON.stringify(data),
			success: function (result) {
				if (result != null && result != '' && result.message == 'OK') {
					let calWat = result.value;
					if (calWat != null) {
						$('.value_num').eq(2).empty().append('<span class="num">' + calWat.toFixed(2) + '</span>%');
					}
				}
			},
			error: function (error) {
				console.error(error);
			}
		});
	};

	//사업소 호출
	const siteList = function () {
		$('#siteList > div > ul').empty();

		let str = '';
		let sites = JSON.parse('${siteList}');
		sites.forEach((site, index) => {
			str += `<li>
				<a href="#" data-value="${'${site.sid}'}" tabindex="-1">
					<input type="checkbox" id="${'${site.sid}'}" value="${'${site.sid}'}" name="site">
					<label for="${'${site.sid}'}"><span></span>${'${site.name}'}</label>
				</a>
			</li>`;
		});
		$('#siteList>div>ul').append(str);
	};

	const device = function () {
		$('#deviceType button.btn-primary').empty().append('복수 선택').append('<span class="caret"></span>');

		if ($(':checkbox[name="site"]:checked').length > 0) {
			var size = 380 + (Number($(':checkbox[name="site"]:checked').length - 2) * 170);
			if (size < 380) {
				size = 380;
			}
			$('#deviceType li.selectDevices').css('width', size);
			$('#deviceType div.sec_li_bx').remove();
			$(':checkbox[name="site"]:checked').each(function () {
				let sid = $(this).val(),
					sNm = $(this).next('label').text();

				$.ajax({
					url: 'http://iderms.enertalk.com:8443/config/devices/',
					type: 'get',
					async: false,
					data: {
						oid: 'spower',
						sid: sid
					},
					success: function (result) {
						let devices = result;
						if (devices.length > 0) {
							let siteGrp = $('<div>').addClass('sec_li_bx');
							siteGrp.append('<p>');
							siteGrp.find('p').addClass('tx_li_tit').text(sNm);
							siteGrp.append('<ul>');

							let chargeArr = new Array();
							let dashArr = new Array();
							let deviceType = ['SM', 'SM_ISMART', 'SM_KPX', 'SM_CRAWLING', 'SM_MANUAL', 'INV_PV', 'INV_WIND', 'PCS_ESS', 'BMS_SYS',
								'BMS_RACK', 'SENSOR_SOLAR', 'SENSOR_FLAME', 'SENSOR_TEMP_HUMIDITY', 'CCTV', 'COMBINER_BOX', 'CIRCUIT_BREAKER'
							];
							$.each(devices, function (i, el) {

								$.each(deviceType, function (j, tp) {
									if (tp == el.device_type && (el.dashboard || el.billing)) {
										let deviceHtml = $('<li>').append('<a>');
										deviceHtml.find('a').attr('href', '#').attr('tabindex', '-1');
										deviceHtml.find('a').append('<input id="' + el.did + '" name="device" type="checkbox" value="' + el.did + '" data-name="' + sNm + '_' + el.name + '">').append('<label>');
										deviceHtml.find('label').attr('for', el.did).append('<span>').append('&nbsp;' + el.name);
										siteGrp.find('ul').append(deviceHtml);
									}
								});
							});

							$('#deviceType li.selectDevices').prepend(siteGrp);

							let deviceHtml1 = $('<li>').append('<a>');
							deviceHtml1.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml1.find('a').append('<input id="device_billing_' + sid + '" name="device" type="checkbox" value="' + sid + '" data-name="' + sNm + '_매전">').append('<label>');
							deviceHtml1.find('label').attr('for', 'device_billing_' + sid).append('<span>').append('&nbsp;매전량');
							siteGrp.find('ul').prepend(deviceHtml1);

							let deviceHtml2 = $('<li>').append('<a>');
							deviceHtml2.find('a').attr('href', '#').attr('tabindex', '-1');
							deviceHtml2.find('a').append('<input id="device_dash_' + sid + '" name="device" type="checkbox" value="' + sid + '" data-name="' + sNm + '_대시보드">').append('<label>');
							deviceHtml2.find('label').attr('for', 'device_dash_' + sid).append('<span>').append('&nbsp;대시보드');
							siteGrp.find('ul').prepend(deviceHtml2);

						}
					},
					dataType: "json"
				});
			});
		}
	};

	function fetchGenData() {
		//기간 설정 확인
		const startTime = $('#datepicker1').val().replace(/-/g, '') + "000000";
		const endTime = $('#datepicker2').val().replace(/-/g, '') + "235959";
		//주기 확인
		let interval = $('#interval button').data('value');
		const billingSites = $.makeArray($(':checkbox[id^="device_billing_"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		const dashSites = $.makeArray($(':checkbox[id^="device_dash_"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		//체크된 디바이스
		const checkedDevices = $.makeArray($('input[name="device"]:checked').map(
			function () {
				if (!$(this).attr('id').match('device')) {
					return $(this).attr('id');
				}
			}
		));

		responseCnt = 0;
		accociation = new Map();

		//매전량
		if (billingSites.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/sites",
				type: "get",
				async: false,
				data: {
					sid: billingSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'billing',
					formId: 'v2'
				},
				success: function (data) {
					console.log(1);
					association(data, '1');
				},
				error: function (error) {
					console.error(error);
					console.log(1);
					association(null, '1');
				}
			})
		} else {
			console.log(1);
			association(null, '1');
		}

		//매전량 예측
		if (billingSites.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/forecasting/sites",
				type: "get",
				async: false,
				data: {
					sid: billingSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'billing',
					formId: 'v2'
				},
				success: function (data) {
					console.log(4);
					association(data, '4');
				},
				error: function (error) {
					console.error(error);
					console.log(4);
					association(null, '4');
				}
			})
		} else {
			console.log(4);
			association(null, '4');
		}

		//대시보드
		if (dashSites.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/sites",
				type: "get",
				async: false,
				data: {
					sid: dashSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'dashboard',
					formId: 'v2'
				},
				success: function (data) {
					console.log(2);
					association(data, '2');
				},
				error: function (error) {
					console.error(error);
					console.log(2);
					association(null, '2');
				}
			})
		} else {
			console.log(2);
			association(null, '2');
		}

		//대시보드
		if (dashSites.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/forecasting/sites",
				type: "get",
				async: false,
				data: {
					sid: dashSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'dashboard',
					formId: 'v2'
				},
				success: function (data) {
					console.log(5);
					association(data, '5');
				},
				error: function (error) {
					console.error(error);
					console.log(5);
					association(null, '5');
				}
			})
		} else {
			console.log(5);
			association(null, '5');
		}

		if (checkedDevices.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/devices",
				type: "get",
				async: false,
				data: {
					dids: checkedDevices.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval
				},
				success: function (data) {
					console.log(3);
					association(data, '3');
				},
				error: function (error) {
					console.error(error);
					console.log(3);
					association(null, '3');
				}
			});
		} else {
			console.log(3);
			association(null, '3');
		}

		if (checkedDevices.length > 0) {
			//API 호출
			$.ajax({
				url: "http://iderms.enertalk.com:8443/energy/forecasting/devices",
				type: "get",
				async: false,
				data: {
					dids: checkedDevices.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval
				},
				success: function (data) {
					console.log(6);
					association(data, '6');
				},
				error: function (error) {
					console.error(error);
					console.log(6);
					association(null, '6');
				}
			});
		} else {
			console.log(6);
			association(null, '6');
		}
	}

	let responseCnt = 0;
	let accociation = new Map();
	let dup = false;

	function association(map, key) {
		responseCnt++;
		if (map != null) {
			if (key == '1' || key == '2' || key == '3') { //실측
				let dummy = map.data;
				$.each(dummy, function (i, el) {
					if (accociation.get('actual') == undefined) {
						accociation.set('actual', el[0].items);
					} else {
						$.each(el[0].items, function (j, elj) {
							let dupData = false;
							let bt = elj.basetime;
							$.each(accociation.get('actual'), function (k, elk) {
								if (elk.basetime == bt) {
									console.log('1', elk.energy);
									elk.energy += elj.energy;
									console.log('2', elk.energy);
									elk.money += elj.money;
									dupData = true;
								}
							});
							if (!dupData) {
								accociation.get('actual').push(el);
							}
						});
					}
				});
			} else { //예측
				let dummy = map.data;
				$.each(dummy, function (i, el) {
					if (accociation.get('prediction') == undefined) {
						accociation.set('prediction', el[0].items);
					} else {
						$.each(el[0].items, function (j, elj) {
							let dupData = false;
							let bt = elj.basetime;
							$.each(accociation.get('prediction'), function (k, elk) {
								if (elk.basetime == bt) {
									elk.energy += elj.energy;
									elk.money += elj.money;
									dupData = true;
								}
							});
							if (!dupData) {
								accociation.get('prediction').push(el);
							}
						});
					}
				});
			}
		}

		if (responseCnt == 6) {
			if (!dup) {
				dup = true;
				drawPage();
			}
		}
	}

	function drawPage() {
		$('table.pc_use tbody').empty();

		standard = new Array();
		let sDate = $('#datepicker1').val().replace(/-/g, '');
		let eDate = $('#datepicker2').val().replace(/-/g, '');
		let interval = $('#interval button').data('value');

		if (interval == 'day') {
			let diffDay = getDiff(eDate, sDate, 'day');
			for (let j = 0; j < diffDay; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
				sDateTime.setDate(Number(sDateTime.getDate()) + j);
				let toDate = sDateTime.format('yyyyMMdd');
				standard.push(toDate);
			}
		} else if (interval == 'month') {
			let diffMonth = getDiff(eDate, sDate, 'month');
			for (let j = 0; j < diffMonth; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) + j - 1, 1);
				let toDate = sDateTime.format('yyyyMM');
				standard.push(toDate);
			}
		} else {
			let diffDay = getDiff(eDate, sDate, 'day');
			//diffDay 1보다 크면 시작일과 종료일이 다르다.
			for (let j = 0; j < diffDay; j++) {
				let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
				sDateTime.setDate(sDateTime.getDate() + j);
				let toDate = sDateTime.format('yyyyMMdd');

				for (let i = 0; i < 24; i++) {
					if (interval == '15min') { //15분
						if (String(i).length == 1) {
							standard.push(toDate + '0' + i + '0000');
							standard.push(toDate + '0' + i + '1500');
							standard.push(toDate + '0' + i + '3000');
							standard.push(toDate + '0' + i + '4500');
						} else {
							standard.push(toDate + i + '0000');
							standard.push(toDate + i + '1500');
							standard.push(toDate + i + '3000');
							standard.push(toDate + i + '4500');
						}
					} else if (interval == '30min') { //30분
						if (String(i).length == 1) {
							standard.push(toDate + '0' + i + '0000');
							standard.push(toDate + '0' + i + '3000');
						} else {
							standard.push(toDate + i + '0000');
							standard.push(toDate + i + '3000');
						}
					} else { //시간
						if (String(i).length == 1) {
							standard.push(toDate + '0' + i + '0000');
						} else {
							standard.push(toDate + i + '0000');
						}
					}
				}
			}
		}

		let gridData = gridDataMake(interval);

		let totalArr = new Array();
		if (interval == '15min' || interval == 'hour') {
			let dateVal = '';
			let tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
			let tr = $('<tr>');
			$('div.chart_table').remove();

			$.each(standard, function (i, el) {
				let th = $('<th>');
				if (dateVal == '') {
					dateVal = el.substring(0, 8);
					th.text(dateVal.substring(0, 4) + '-' + dateVal.substring(4, 6) + '-' + dateVal.substring(6, 8));
					tr.append(th);

					th = $('<th>');
					let time = el.substring(8, 10) + ':' + el.substring(10, 12);
					th.text(time);
					tr.append(th);
				} else if (dateVal != el.substring(0, 8) || standard.length == (i + 1)) {
					if (standard.length == (i + 1)) {
						let time = el.substring(8, 10) + ':' + el.substring(10, 12);
						th.text(time);
						tr.append(th);
					}

					th = $('<th>').html('합계');
					tr.append(th);

					tableTemp.find('table').append('<thead>');
					tableTemp.find('thead').append(tr);
					tableTemp.find('table').append('<tbody>');

					let color = 1;
					$.each(gridData, function (q, grid) {
						if (grid.std == dateVal) {
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								$dataTd.html(data);
								$dataTr.append($dataTd);
							});
							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold_div').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
					tr = $('<tr>');
					th = $('<th>');
					dateVal = el.substring(0, 8);
					th.text(el.substring(0, 4) + '-' + el.substring(4, 6) + '-' + el.substring(6, 8));
					tr.append(th);

					th = $('<th>');
					time = el.substring(8, 10) + ':' + el.substring(10, 12);
					th.text(time);
					tr.append(th);
				} else {

					let time = el.substring(8, 10) + ':' + el.substring(10, 12);
					th.text(time);
					tr.append(th);
				}
			});
		} else if (interval == 'day') {
			let dateVal = '';
			let tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
			let tr = $('<tr>');
			$('div.chart_table').remove();

			$.each(standard, function (i, el) {
				let th = $('<th>');
				if (dateVal == '') {
					dateVal = el.substring(0, 6);
					th.text(dateVal.substring(0, 4) + '-' + dateVal.substring(4, 6));
					tr.append(th);

					th = $('<th>');
					let time = el.substring(6, 8);
					th.text(time);
					tr.append(th);

					if (standard.length == (i + 1)) {
						th = $('<th>').html('합계');
						tr.append(th);

						tableTemp.find('table').append('<thead>');
						tableTemp.find('thead').append(tr);
						tableTemp.find('table').append('<tbody>');

						let color = 1;
						$.each(gridData, function (q, grid) {
							if (grid.std == dateVal) {
								let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									$dataTd.html(data);
									$dataTr.append($dataTd);
								});
								tableTemp.find('tbody').append($dataTr);
								color++;
							}
						});
						$('div.fold_div').append(tableTemp);
					}
				} else if (dateVal != el.substring(0, 6) || standard.length == (i + 1)) {
					if (standard.length == (i + 1)) {
						let time = el.substring(6, 8);
						th.text(time);
						tr.append(th);
					}

					th = $('<th>').html('합계');
					tr.append(th);

					tableTemp.find('table').append('<thead>');
					tableTemp.find('thead').append(tr);
					tableTemp.find('table').append('<tbody>');

					let color = 1;
					$.each(gridData, function (q, grid) {
						if (grid.std == dateVal) {
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								$dataTd.html(data);
								$dataTr.append($dataTd);
							});
							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold_div').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
					tr = $('<tr>');
					th = $('<th>');
					dateVal = el.substring(0, 6);
					th.text(el.substring(0, 4) + '-' + el.substring(4, 6));
					tr.append(th);

					th = $('<th>');
					time = el.substring(6, 8);
					th.text(time);
					tr.append(th);
				} else {
					let time = el.substring(6, 8);
					th.text(time);
					tr.append(th);
				}
			});
		} else if (interval == 'month') {
			let dateVal = '';
			let tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
			let tr = $('<tr>');
			$('div.chart_table').remove();

			$.each(standard, function (i, el) {
				let th = $('<th>');
				if (dateVal == '') {
					dateVal = el.substring(0, 4);
					th.text(dateVal.substring(0, 4));
					tr.append(th);

					th = $('<th>');
					let time = el.substring(4, 6);
					th.text(time);
					tr.append(th);

					if (standard.length == (i + 1)) {
						th = $('<th>').html('합계');
						tr.append(th);

						tableTemp.find('table').append('<thead>');
						tableTemp.find('thead').append(tr);
						tableTemp.find('table').append('<tbody>');

						let color = 1;
						$.each(gridData, function (q, grid) {
							if (grid.std == dateVal) {
								let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
								$.each(grid.data, function (w, data) {
									let $dataTd = $('<td>');
									$dataTd.html(data);
									$dataTr.append($dataTd);
								});
								tableTemp.find('tbody').append($dataTr);
								color++;
							}
						});
						$('div.fold_div').append(tableTemp);
					}
				} else if (dateVal != el.substring(0, 4) || standard.length == (i + 1)) {
					if (standard.length == (i + 1)) {
						let time = el.substring(4, 6);
						th.text(time);
						tr.append(th);
					}

					th = $('<th>').html('합계');
					tr.append(th);

					tableTemp.find('table').append('<thead>');
					tableTemp.find('thead').append(tr);
					tableTemp.find('table').append('<tbody>');

					let color = 1;
					$.each(gridData, function (q, grid) {
						if (grid.std == dateVal) {
							let $dataTr = $('<tr>').append('<td><span class="bu t' + color + '">' + grid.name + '</span></td>');
							$.each(grid.data, function (w, data) {
								let $dataTd = $('<td>');
								$dataTd.html(data);
								$dataTr.append($dataTd);
							});
							tableTemp.find('tbody').append($dataTr);
							color++;
						}
					});
					$('div.fold_div').append(tableTemp);

					//값 초기화.
					tableTemp = $('<div class="chart_table">').append('<table class="pc_use">');
					tr = $('<tr>');
					th = $('<th>');
					dateVal = el.substring(0, 4);
					th.text(el.substring(0, 4));
					tr.append(th);

					th = $('<th>');
					time = el.substring(4, 6);
					th.text(time);
					tr.append(th);
				} else {
					let time = el.substring(4, 6);
					th.text(time);
					tr.append(th);
				}
			});
		}

		chartMakeData(interval);
		dup = false;
	}

	//그리드 데이터 만들기
	function gridDataMake(type) {
		let dataArr = new Array();

		accociation.forEach(function (val, key) {
			if (val != undefined) {
				let arr = val;
				arr.sort(function (a, b) {
					return a['basetime'] - b['basetime'];
				});

				let arrDevice = new Array();
				let stdDate = '';
				let total = 0;
				$.each(standard, function (j, stnd) {
					let timeValue = '-';
					if (stdDate == '') {
						if (type == 'day') {
							stdDate = stnd.substring(0, 6);
						} else if (type == 'month') {
							stdDate = stnd.substring(0, 4);
						} else {
							stdDate = stnd.substring(0, 8);
						}
					} else if (stdDate != '' &&
						(((type == '15min' || type == 'hour') && stdDate != stnd.substring(0, 8)) ||
							(type == 'day' && stdDate != stnd.substring(0, 6)) ||
							(type == 'month' && stdDate != stnd.substring(0, 4))) ||
						standard.length == j + 1) {
						if (standard.length == j + 1) {
							$.each(arr, function (k, elk) {
								let basetime = String(elk.basetime);
								if (basetime.match(stnd)) {
									timeValue = displayNumberFixedUnit(elk.energy, 'Wh', 'kWh', 2);
									total += elk.energy;
								}
							});

							arrDevice.push(timeValue[0]);
						}
						let totalArr = displayNumberFixedUnit(total, 'Wh', 'kWh', 2);
						arrDevice.push(totalArr[0]); //합계.

						let dataName = '';
						if (key == 'actual') {
							dataName = '실측';
						} else {
							dataName = '예측';
						}

						dataArr.push({
							name: dataName,
							id: key,
							std: stdDate,
							data: arrDevice
						});

						if (type == 'day') {
							stdDate = stnd.substring(0, 6);
						} else if (type == 'month') {
							stdDate = stnd.substring(0, 4);
						} else {
							stdDate = stnd.substring(0, 8);
						}
						total = 0;
						arrDevice = new Array();
					}

					$.each(arr, function (k, elk) {
						let basetime = String(elk.basetime);
						if (basetime.match(stnd)) {
							timeValue = displayNumberFixedUnit(elk.energy, 'Wh', 'kWh', 2);
							total += elk.energy;
						}
					});

					arrDevice.push(timeValue[0]);
				});
			}
		});

		return dataArr;
	}

	//두기간 사이 차이 구하기.
	function getDiff(eDate, sDate, type) {
		eDate = new Date(eDate.substring(2, 4), eDate.substring(4, 6) - 1, eDate.substring(6, 8));
		sDate = new Date(sDate.substring(2, 4), sDate.substring(4, 6) - 1, sDate.substring(6, 8));
		if (type == 'day') {
			return (((((eDate - sDate) / 1000) / 60) / 60) / 24) + 1;
		} else if (type == 'month') {
			if (eDate.format('yyyyMMdd').substring(0, 4) == sDate.format('yyyyMMdd').substring(0, 4)) {
				return (eDate.format('yyyyMMdd').substring(4, 6) * 1 - sDate.format('yyyyMMdd').substring(4, 6) * 1) + 1;
			} else {
				return Math.round((eDate - sDate) / (1000 * 60 * 60 * 24 * 365 / 12)) + 1;
			}
		}
	}

	//차트
	const chartMakeData = function (type) {
		let seriesData = new Array();
		let num = 0;
		let colorArr = ['#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787'];

		accociation.forEach(function (val, key) {
			if (val != undefined) {
				let arr = val;
				arr.sort(function (a, b) {
					return a['basetime'] - b['basetime'];
				});

				let arrDevice = new Array();
				let dummy = new Array();
				let stdDate = '';
				let total = 0;
				$.each(standard, function (j, stnd) {
					let timeValue = null;
					if (stdDate == '') {
						stdDate = stnd.substring(0, 8);
					} else if (standard.length == j + 1) {
						$.each(arr, function (k, elk) {
							let basetime = String(elk.basetime);
							if (basetime.match(stnd)) {
								timeValue = elk.energy;
								total += elk.energy;
							}
						});
						arrDevice.push([
							stnd, timeValue
						]);

						let dataName = '';
						if (key == 'actual') {
							dataName = '실측';
							let $temp = {
								name: dataName,
								type: applicationData.observedType,
								stack: 0,
								tooltip: {
									valueSuffix: 'Wh'
								},
								color: colorArr[0],
								data: arrDevice
							};
							seriesData.push($temp);
							applicationData.observed = dummy;
							summary(total, 0);
						} else {
							dataName = '예측';
							let $temp = {
								name: dataName,
								type: applicationData.forecastedType,
								stack: 1,
								tooltip: {
									valueSuffix: 'Wh'
								},
								color: colorArr[1],
								data: arrDevice
							};
							seriesData.push($temp);
							applicationData.forecasted = dummy;
							summary(total, 1);
						}
						arrDevice = new Array();
					}

					$.each(arr, function (k, elk) {
						let basetime = String(elk.basetime);
						if (basetime.match(stnd)) {
							timeValue = elk.energy;
							total += elk.energy;
						}
					});

					if (timeValue == null || timeValue == '') {
						dummy.push(0);
					} else {
						dummy.push(timeValue);
					}

					arrDevice.push([
						stnd, timeValue
					]);
				});
			}
		});

		chartDraw(seriesData);

		application('basic');
	}

	/**
		* 차트 그리기
		*
		* @param standard
		* @param seriesData
		*/
	const chartDraw = function (seriesData) {
		let chart = $('#chart2').highcharts();
		if (chart) {
			chart.destroy();
		}

		let option = {
			chart: {
				renderTo: 'chart2',
				marginLeft: 60,
				marginRight: 20,
				backgroundColor: 'transparent',
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
						color: 'var(--color3)',
						fontSize: '8px'
					},
					y: 50,
					formatter: function () {
						return dateFormat(this.value);
					},
					enabled: true
				},
				categories: standard,
				tickInterval: 1,
				/* 눈금의 픽셀 간격 조정 */
				title: {
					text: null
				},
				crosshair: true /* 포커스 선 */
			},
			yAxis: {
				gridLineWidth: 1,
				/* 기준선 grid 안보이기/보이기 */
				min: 0,
				/* 최소값 지정 */
				title: {
					text: '(Wh)',
					align: 'low',
					rotation: 0,
					/* 타이틀 기울기 */
					y: 25,
					/* 타이틀 위치 조정 */
					x: 5,
					/* 타이틀 위치 조정 */
					style: {
						color: 'var(--color3)',
						fontSize: '18px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -20,
					/* 그래프와의 거리 조정 */
					style: {
						color: 'var(--color3)',
						fontSize: '10px'
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
					color: 'var(--color3)',
					fontSize: '10px',
					fontWeight: 400
				},
				itemHoverStyle: {
					color: '' /* 마우스 오버시 색 */
				},
				symbolPadding: 3,
				/* 심볼 - 텍스트간 거리 */
				symbolHeight: 8 /* 심볼 크기 */
			},
			/* 툴팁 */
			tooltip: {
				formatter: function () {
					return this.points.reduce(function (s, point) {
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + Number(point.y).toFixed(2) + point.series.userOptions.tooltip.valueSuffix;
					}, '<b>' + dateFormat(this.points[0].point.name) + '</b>');
				},
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
								x: -10,
								/* 그래프와의 거리 조정 */
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
		}

		chart = new Highcharts.Chart(option);
		chart.redraw();
	}

	function summary(total, type) {
		let loopCnt = 0;
		for (let k = 0; k < 4; k++) {
			if (String(Math.round(total)).length > 3) {
				total = total / 1000
				loopCnt++;
			}
		}

		let unit = 'Wh';
		if (loopCnt == 1) {
			unit = 'kWh';
		} else if (loopCnt == 2) {
			unit = 'MWh';
		} else if (loopCnt == 3) {
			unit = 'GWh';
		} else {
			unit = 'Wh';
		}

		$('.value_num').eq(type).empty().append('<span class="num">' + total.toFixed(2) + '</span>' + unit);
	}

	function dateFormat(val) {
		let date = '';
		if (val != undefined) {
			if (String(val).length == 4) {
				date = val.substring(0, 4)
			} else if (String(val).length == 6) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6);
			} else if (String(val).length > 8) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8) + ' ' + val.substring(8, 10) + ':' + val.substring(10, 12);
			} else {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8);
			}
		}
		return date;
	}
</script>