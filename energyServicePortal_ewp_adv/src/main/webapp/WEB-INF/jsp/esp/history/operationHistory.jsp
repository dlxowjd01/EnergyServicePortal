<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	const pollingTerm = 1000 * 60 * 15;
	const pollingTimeout = 5000;
	const debugMode = true;

	const apiURL = 'http://iderms.enertalk.com:8443';
	const configSite = '/config/sites';
	const configDevice = '/config/orgs/' + 'spower';
	const statusSummary = '/status/summary';
	const forecasting = '​/energy​/forecasting​/sites';

	const configSiteData = {
		oid: 'spower'
	};

	const configDeviceData = {
		includeUsers: false,
		includSites: false,
		includeDevices: true,
		includeBtus: false
	};

	const forecastingData = {
		dids: '',
		metering_type: '',
		interval: '',
		isDummy: true
	}

	const deviceTemplate = {
		'SM': '스마트미터',
		'SM_ISMART': '한전 아이스마트',
		'SM_KPX': '전력거래소 계량포털',
		'SM_CRAWLING': '데이터 수집기',
		'SM_MANUAL': '수기 입력',
		'INV_PV': '태양광 인버터',
		'INV_WIND': '풍력 인버터',
		'PCS_ESS': 'ESS PCS',
		'BMS_SYS': 'BMS 시스템',
		'BMS_RACK': 'BMS 랙',
		'SENSOR_SOLAR': '태양광 센서',
		'SENSOR_FRAME': '불꽃 센서',
		'SENSOR_TEMP_HUMIDITY': '온습도 센서',
		'CCTV': 'CCTV'
	};

	let devicesList;

	let gridList;


	//사업소 조회
	const place = function (result) {
		$.ajax({
			url: apiURL + configSite,
			type: 'get',
			async: false,
			data: configSiteData,
			success: function (result) {
				var data = result;
				if (debugMode) { console.log(data); }

				$('#place').empty();

				if (result.length > 0) {
					for (var i in result) {
						let placeHtml = $('<li>').append('<a>')
						placeHtml.find('a').attr('href', '#').attr('tabindex', '-1');
						placeHtml.find('a').append('<input id="sid_' + i + '" type="checkbox" name="sid" value="' + result[i].sid + '">').append('<label>');
						placeHtml.find('label').attr('for', 'sid_' + i).append('<span>').append('&nbsp;' + data[i].name);
						$('#place').append(placeHtml);
					}
				} else {
					let placeHtml = $('<li>').html('조회된 사업소가 없습니다');
					$('#place').append(placeHtml);
					$('#place').before('button').find('div.caret').prepend('선택해주세요.');
				}
			},
			dataType: "json"
		});
	};
	const initPage = function () {
		place();
	};

	//선택한 SID에 해당하는 유형의 타입을 보여준다.
	const deviceType = function () {
		$('#type').prev('button').empty().append('전체').append('<span class="caret"></span>');

		if($(':checkbox[name="sid"]:checked').length > 0) {
			$.ajax({
				url : apiURL + configDevice,
				type : 'get',
				async : false,
				data : configDeviceData,
				success: function(result) {
					devicesList = result.devices;
					var deviceType = new Array();
					var uniqueTypes = new Array();
					if(debugMode) {console.log(devicesList);}

					$('#type').empty();

					if(devicesList.length > 0) {
						$(':checkbox[name="sid"]:checked').each(function() {
							for(var i in devicesList) {
								if(devicesList[i].sid == $(this).val()) {
									deviceType.push(devicesList[i].device_type);
								}
							}
						})
						//어레이에 중복제거 후 셀렉트 작성
						$.each(deviceType, function(i, el) {
							if($.inArray(el, uniqueTypes) === -1) {
								uniqueTypes.push(el);

								let typeHtml = $('<li>').append('<a>');
								typeHtml.find('a').attr('href', '#').attr('tabindex', '-1');
								typeHtml.find('a').append('<input id="type_' + i + '" name="type" type="checkbox" value="' + el + '">').append('<label>');
								typeHtml.find('label').attr('for', 'type_' + i).append('<span>').append('&nbsp;' + eval('deviceTemplate.' + el));

								$('#type').append(typeHtml);
							}
						});
					}  else {
						let typeHtml = $('<li>').append('<a>').data('value', '').attr('href', '#').html('조회된 설비가 없습니다.');
						$('#type').append(typeHtml);
						$('#type').before('button').empty().append('전체').append('<span class="caret"></span>');
					}
				},
				dataType: "json"
			});
		}
	};

	//설비타입 디바이스타입 설정한다.
	const device = function () {
		$('#device').prev('button').empty().append('복수 선택').append('<span class="caret"></span>');

		if($(':checkbox[name="type"]:checked').length > 0) {
			if(devicesList.length > 0) {
				if (debugMode) { console.log(devicesList); }

				$('#device>li>div.sec_li_bx').remove();

				//선택된 사이트를 기준으로 한다.
				$(':checkbox[name="sid"]:checked').each(function () {
					var siteNm = $(this).next().text()
					  , siteId = $(this).val()
					  , siteGrp = $('<div>').addClass('sec_li_bx');

					siteGrp.append('<p>');
					siteGrp.find('p').addClass('tx_li_tit').text(siteNm);
					siteGrp.append('<ul>');

					$.each(devicesList, function(i, el) {
						if (el.sid == siteId) {
							$(':checkbox[name="type"]:checked').each(function() {
								if($(this).val() == el.device_type) {
									let deviceHtml = $('<li>').append('<a>');
									deviceHtml.find('a').attr('href', '#').attr('tabindex', '-1');
									deviceHtml.find('a').append('<input id="device_' + i + '" name="device" type="checkbox" value="' + el.did + '">').append('<label>');
									deviceHtml.find('label').attr('for', 'device_' + i).append('<span>').append('&nbsp;' + el.name);
									siteGrp.find('ul').append(deviceHtml);
								}
							});
						}
					});

					$('#device>li').prepend(siteGrp);
				});
			}
		}
	}

	var searchGrid = function () {

		if($(':checkbox[name="sid"]:checked').length == 0) {
			alert('사이트를 한개이상 선택해 주세요.');
			return false;
		}

		if($(':checkbox[name="type"]:checked').length == 0) {
			alert('설비타입을 한개이상 선택해 주세요.');
			return false;
		}

		if($(':checkbox[name="device"]:checked').length == 0) {
			alert('설비를 한개이상 선택해 주세요.');
			return false;
		}

		$('.his_tbl tbody').empty();

		let siteArray = new Array();
		let deviceArray = new Array();

		$(':checkbox[name="sid"]:checked').each(function() {
			siteArray.push($(this).val());
		});

		$(':checkbox[name="device"]:checked').each(function() {
			deviceArray.push($(this).val());
		});

		//설비유형이 여러개일경우 하나만 들어가서 여러번 호출한다.
// 		$(':checkbox[id^=type_]:checked').each(function() {
			let statusSummaryData = {
				sids: siteArray.join(','),
				dids: deviceArray.join(','),
				//deviceType: '',
				startTime: $('#datepicker1').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#datepicker2').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: $('#interval').prev('button').data('value')
			}

			$.ajax({
				url : apiURL + statusSummary,
				type : 'get',
				async : false,
				data : statusSummaryData,
				success: function(result) {
					var data = result;
					if(debugMode) {console.log(data);}
					if(data.length > 0) {
						$.each(data, function(i, el) {
							let trHtml = $('<tr>');
							//사이트명세팅
							let siteName = '-';
							$.each(devicesList, function(j, el2) {
								if(el2.did == el.did) {
									$(':checkbox[name="sid"]').each(function() {
										if($(this).val() == el2.sid) {
											// siteName = $(this).next().text();

											el.siteName = $(this).next().text();
											el.sid = el2.sid;
											el.device_type = el2.device_type;
										}
									});
								}
							});

							let temperature = '-';
							let voltageR = (el.acVoltageTR != null && el.acVoltageTR != '') ? el.acVoltageTR.toFixed(2) : '-';
							let voltageS = (el.acVoltageRS != null && el.acVoltageRS != '') ? el.acVoltageRS.toFixed(2) : '-';
							let voltageT = (el.acVoltageST != null && el.acVoltageST != '') ? el.acVoltageST.toFixed(2) : '-';
							let currentR = (el.acCurrentR != null && el.acCurrentR != '') ? el.acCurrentR.toFixed(2) : '-';
							let currentS = (el.acCurrentS != null && el.acCurrentS != '') ? el.acCurrentS.toFixed(2) : '-';
							let currentT = (el.acCurrentT != null && el.acCurrentT != '') ? el.acCurrentT.toFixed(2) : '-';
							let activePower = (el.acPower != null && el.acPower != '') ? el.acPower.toFixed(2) : '-';
							let dcVoltage = (el.dcVoltage != null && el.dcVoltage != '') ? el.dcVoltage.toFixed(2) : '-';
							let dcCurrent = (el.dcCurrent != null && el.dcCurrent != '') ? el.dcCurrent.toFixed(2) : '-';
							let dcPower = (el.dcPower != null && el.dcPower != '') ? el.dcPower.toFixed(2) : '-';
							let operation = el.operation;
							if(operation == '1') {
								operation = 'run';
							} else if(operation == '2') {
								operation = 'trip';
							} else {
								operation = 'stop';
							}

							trHtml.append('<td>' + el.siteName + '</td>');
							trHtml.append('<td>' + el.dname + '</td>');
							trHtml.append('<td>' + new Date(el.timestamp).format('yyyy.MM.dd hh:mm:ss') + '</td>');
							trHtml.append('<td>' + temperature + '</td>');// 현재없음.
							trHtml.append('<td>' + voltageR + '</td>');
							trHtml.append('<td>' + voltageS + '</td>');
							trHtml.append('<td>' + voltageT + '</td>');
							trHtml.append('<td>' + currentR + '</td>');
							trHtml.append('<td>' + currentS + '</td>');
							trHtml.append('<td>' + currentT + '</td>');
							trHtml.append('<td>' + activePower + '</td>');
							trHtml.append('<td>' + dcVoltage + '</td>');
							trHtml.append('<td>' + dcCurrent + '</td>');
							trHtml.append('<td>' + dcPower + '</td>');
							trHtml.append('<td>' + operation + '</td>');

							$('.his_tbl tbody').append(trHtml);
						});

						gridList = data;
					}
				},
				dataType: "json"
			});
// 		});
	};

	let tableGrid = function() {
		$('.his_tbl tbody').empty();

		$.each(gridList, function(i, el) {
			let trHtml = $('<tr>');

			let temperature = '-';
			let voltageR = (el.acVoltageTR != null && el.acVoltageTR != '') ? el.acVoltageTR.toFixed(2) : '-';
			let voltageS = (el.acVoltageRS != null && el.acVoltageRS != '') ? el.acVoltageRS.toFixed(2) : '-';
			let voltageT = (el.acVoltageST != null && el.acVoltageST != '') ? el.acVoltageST.toFixed(2) : '-';
			let currentR = (el.acCurrentR != null && el.acCurrentR != '') ? el.acCurrentR.toFixed(2) : '-';
			let currentS = (el.acCurrentS != null && el.acCurrentS != '') ? el.acCurrentS.toFixed(2) : '-';
			let currentT = (el.acCurrentT != null && el.acCurrentT != '') ? el.acCurrentT.toFixed(2) : '-';
			let activePower = (el.acPower != null && el.acPower != '') ? el.acPower.toFixed(2) : '-';
			let dcVoltage = (el.dcVoltage != null && el.dcVoltage != '') ? el.dcVoltage.toFixed(2) : '-';
			let dcCurrent = (el.dcCurrent != null && el.dcCurrent != '') ? el.dcCurrent.toFixed(2) : '-';
			let dcPower = (el.dcPower != null && el.dcPower != '') ? el.dcPower.toFixed(2) : '-';
			let operation = el.operation;
			if(operation == '1') {
				operation = 'run';
			} else if(operation == '2') {
				operation = 'trip';
			} else {
				operation = 'stop';
			}

			trHtml.append('<td>' + el.siteName + '</td>');
			trHtml.append('<td>' + el.dname + '</td>');
			trHtml.append('<td>' + new Date(el.timestamp).format('yyyy.MM.dd hh:mm:ss') + '</td>');
			trHtml.append('<td>' + temperature + '</td>');// 현재없음.
			trHtml.append('<td>' + voltageR + '</td>');
			trHtml.append('<td>' + voltageS + '</td>');
			trHtml.append('<td>' + voltageT + '</td>');
			trHtml.append('<td>' + currentR + '</td>');
			trHtml.append('<td>' + currentS + '</td>');
			trHtml.append('<td>' + currentT + '</td>');
			trHtml.append('<td>' + activePower + '</td>');
			trHtml.append('<td>' + dcVoltage + '</td>');
			trHtml.append('<td>' + dcCurrent + '</td>');
			trHtml.append('<td>' + dcPower + '</td>');
			trHtml.append('<td>' + operation + '</td>');

			$('.his_tbl tbody').append(trHtml);
		});
	};

	//그래프 태그 중복체크
	const duplicateTag = function(i) {
		var dup = false;
		$('.tag_bx .tx_tit:eq(' + i + ') span').each(function() {
			let spanDid = $(this).data('deviceId');
			let spanColumn = $(this).data('key');
			let spanRdVal = $(this).data('key2');

			if($('#chartDid').prev('button').data('value') == spanDid
				&& $(':radio[name="column"]:checked').val() == spanColumn
				&& $(':radio[name="rdValue"]:checked').val() == spanRdVal
			) {
				alert('중복된 항목이 존재합니다.');
				dup = true;
			}
		});
		return dup;
	}

	$(function () {
		initPage();

		//사업소 선택
		$(document).on('click', '#place a', function (e) {
			e.preventDefault();
			if ($(this).find('input').is(':checked') == true) {
				$(this).find('input').prop('checked', false);
			} else {
				// 				$(this).parents('ul').prev('button').empty().append($(this).find('label').text()).append('<span class="caret"></span>');
				$(this).find('input').prop('checked', true);
			}

			//총 체크한 갯수를 확인한다.
			if ($(':checkbox[name="sid"]:checked').length <= 0) {
				$(this).parents('ul').prev('button').empty().append('선택해주세요.').append('<span class="caret"></span>');
			} else {
				let extendText = '';
				if ($(':checkbox[name="sid"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="sid"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$(this).parents('ul').prev('button').empty().append($(':checkbox[name="sid"]:checked').eq(0).next('label').text() + '&nbsp;' + extendText).append('<span class="caret"></span>');
			}

			deviceType();
		});

		$(document).on('click', '#type a', function(e) {
			e.preventDefault();
			if ($(this).find('input').is(':checked') == true) {
				$(this).find('input').prop('checked', false);
			} else {
				//			  $(this).parents('ul').prev('button').empty().append($(this).find('label').text()).append('<span class="caret"></span>');
				$(this).find('input').prop('checked', true);
			}

			//총 체크한 갯수를 확인한다.
			if ($(':checkbox[name="type"]:checked').length <= 0) {
				$(this).parents('ul').prev('button').empty().append('선택해주세요.').append('<span class="caret"></span>');
			} else {
				let extendText = '';
				if ($(':checkbox[name="type"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="type"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$(this).parents('ul').prev('button').empty().append($(':checkbox[name="type"]:checked').eq(0).next('label').text() + '&nbsp;' + extendText).append('<span class="caret"></span>');
			}
			device();
		});

		$(document).on('click', '#device a, #device div.li_btn_bx button', function(e) {
			e.preventDefault();
			if ($(this).find('input').is(':checked') == true) {
				$(this).find('input').prop('checked', false);
			} else {
				//			$(this).parents('ul').prev('button').empty().append($(this).find('label').text()).append('<span class="caret"></span>');
				$(this).find('input').prop('checked', true);
			}

			//총 체크한 갯수를 확인한다.
			if ($(':checkbox[name="device"]:checked').length <= 0) {
				$(this).parents('ul').prev('button').empty().append('선택해주세요.').append('<span class="caret"></span>');
			} else {
				let extendText = '';
				if ($(':checkbox[name="device"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="device"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$(this).parents('ul').prev('button').empty().append($(':checkbox[name="device"]:checked').eq(0).next('label').text() + '&nbsp;' + extendText).append('<span class="caret"></span>');

				//차트 셀렉트 생성
				$('#chartDid').empty();
				$(':checkbox[name="device"]:checked').each(function() {
					$sNm = $(this).parents('div.sec_li_bx').find('p.tx_li_tit').text();
					$a = $('<a>').attr('href', '#').text($sNm + '_' +$(this).next().text().trim()).data('value', $(this).val());
					$li = $('<li>').append($a);
					$('#chartDid').append($li);
				});
			}
		});

		//기간 선택
		$(document).on('click', '#interval a', function (e) {
			e.preventDefault();
			if($(this).data('value') == '1') {
				$('')
			}
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).empty().append($(this).html()).append('<span class="caret"></span>');
		});

		//검색
		$('#search').on('click', function () {
			searchGrid();
		});

		$(document).on('click', '#chartDid a', function(e) {
			e.preventDefault();
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).empty().append($(this).html()).append('<span class="caret"></span>');
		});

		$(document).on('click', '#way a', function(e) {
			e.preventDefault();
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).empty().append($(this).html()).append('<span class="caret"></span>');
		});

		//헤더 클릭
		$('.his_tbl thead th').on('click', function (e) {
			e.preventDefault();
			var idx = $('.his_tbl thead th').index($(this))
				, order = $(this).data('order')
				, column = $(this).data('column');
			if (idx > 3 && idx < 16) {
				$('.his_tbl thead th button').removeClass('up').removeClass('down');
				if (order == undefined || order == null || order == '') {
					gridList.sort(function (a, b) {
						return a[column] - b[column];
					});
					$(this).data('order', 'up');
					$(this).find('button').addClass('up');
				} else if (order == 'up') {
					gridList.sort(function (a, b) {
						return b[column] - a[column];
					});
					$(this).data('order', 'down');
					$(this).find('button').addClass('down');
				} else {
					gridList.sort(function (a, b) {
						return a[column] - b[column];
					});
					$(this).data('order', 'up');
					$(this).find('button').addClass('up');
				}

				tableGrid();
			}
		});

		//사이트 선택전까지 클릭 방지
		$('#type').prev('button').on('click', function (e) {
			if ($(':checkbox[name="sid"]:checked').length <= 0) {
				e.stopPropagation();
			}
		});

		//사이트 선택전까지 클릭 방지
		$('#device').prev('button').on('click', function (e) {
			if ($(':checkbox[name="sid"]:checked').length <= 0 || $(':checkbox[name="type"]:checked').length <= 0) {
				e.stopPropagation();
			}
		});

		//분석 기준 설비 선택
		$('#chartDid').prev('button').on('click', function(e) {
			if ($(':checkbox[name="sid"]:checked').length <= 0 || $(':checkbox[name="type"]:checked').length <= 0) {
				e.stopPropagation();
			}
		});

		//전체 선택/전체 해제
		$('#device button.btn_type03').on('click', function (e) {
			var idx = $('#device button.btn_type03').index($(this));

			if (idx == 0) {
				$('[id^="device_"]').prop('checked', true);
			} else {
				$('[id^="device_"]').prop('checked', false);
			}
		});


		$('#chartAdd').on('click', function() {
			if($('#chartDid').prev('button').data('value') == '') {
				alert('추가 하시려는 사이트를 선택 해 주세요.');
				return false;
			}

			if($(':radio[name="column"]').is(':checked') == false) {
				alert('추가 하시려는 항목을 선택 해 주세요.');
				return false;
			}

			if($(':radio[name="rdValue"]').is(':checked') == false) {
				alert('선택 해 주세요.');
				return false;
			}

			$('#chartDid').prev('button').data('value');

			//기존항목이 존재한다면 중복체크
			if($('#way').prev('button').data('value') == 'l') {
				if($('.tag_bx .tx_tit:eq(0) span').length > 0) {
					if(duplicateTag(0)) {
						return false;
					}
				}
			} else {
				if($('.tag_bx .tx_tit:eq(1) span').length > 0) {
					if(duplicateTag(1)) {
						return false;
					}
				}
			}

			let $txt =$('#chartDid').prev('button').text() + ': ' + $(':radio[name="column"]:checked').next('label').text() + $(':radio[name="rdValue"]:checked').next('label').text()
			let $span = $('<span>').addClass('tag_type').append($txt).append('<button>')
			$span.data('deviceId', $('#chartDid').prev('button').data('value'))
			$span.data('key', $(':radio[name="column"]:checked').val())
			$span.data('key2', $(':radio[name="rdValue"]:checked').val());
			$span.find('button').append('닫기');

			if($('#way').prev('button').data('value') == 'l') {
				$('.tag_bx .tx_tit').eq(0).append($span);
			} else {
				$('.tag_bx .tx_tit').eq(1).append($span);
			}
		});

		//항목 삭제
		$(document).on('click', '.tag_type button', function() {
			$(this).parents('span.tag_type').remove();
		});

		$('#chartDraw').on('click', function() {

			if($('.tag_bx .tx_tit').find('span').length <= 0) {
				alert('한개이상 항목을 선택해 주세요.');
				return false;
			}

			let chartSeries = new Array();
			let deviceArray = new Array();
			//시간순으로 정렬을 해준다.
			gridList.sort(function(a, b) {
				return a['timestamp'] - b['timestamp'];
			})

			$(':checkbox[name="device"]').each(function() {
				deviceArray.push($(this).val());
			});

			let index = 0;
			let dupY = 1;
			$('.tag_bx .tx_tit').eq(0).find('span').each(function() {
				let dataArr = new Array();
				let keyText = $(this).data('key');
				let keyText2 = $(this).data('key2') != '' ? '_' + $(this).data('key2') : '';
				let deviceId = $(this).data('deviceId');
				let temp = {};
				let suffix = '';

				$.each(gridList, function(j, el) {
					if(el.did == deviceId) {
						dataArr.push({
							'x': el.timestamp,
							'y': eval('el.' + keyText + keyText2)
						});
					}
				});

				if(keyText.toLowerCase().match('voltage')) {
					suffix = 'V';
				} else if(keyText.toLowerCase().match('current')) {
					suffix = 'A';
				} else if(keyText.toLowerCase().match('power')) {
					suffix = 'W';
				} else {
					suffix = '';
				}
				if(dataArr.length > 0) {
					temp = {
						name: $(this).text().replace('닫기', ''),
						type: 'column',
						stack: index,
						tooltip: {
							valueSuffix: suffix
						},
						data: dataArr
					};
					index++;
					console.log(temp);
				}

				chartSeries.push(temp);

				//양쪽이 동일할경우 체크
				$('.tag_bx .tx_tit').eq(1).find('span').each(function() {
					let keyText_1 = $(this).data('key');
					if(keyText == keyText_1) {
						dupY = 0;
					}
				});
			});

			$('.tag_bx .tx_tit').eq(1).find('span').each(function() {
				let dataArr = new Array();
				let keyText = $(this).data('key');
				let keyText2 = $(this).data('key2') != '' ? '_' + $(this).data('key2') : '';
				let deviceId = $(this).data('deviceId');
				let temp = {};
				$.each(gridList, function (j, el) {
					if(el.did == deviceId) {
						dataArr.push({
							'x': el.timestamp,
							'y': eval('el.' + keyText + keyText2)
						});
					}
				});

				if(keyText.toLowerCase().match('voltage')) {
					suffix = 'V';
				} else if(keyText.toLowerCase().match('current')) {
					suffix = 'A';
				} else if(keyText.toLowerCase().match('power')) {
					suffix = 'W';
				} else {
					suffix = '';
				}


				if(dataArr.length > 0) {
					temp = {
						name: $(this).text().replace('닫기', ''),
						type: 'spline',
						stack: index,
						yAxis: dupY,
						tooltip: {
							valueSuffix: suffix
						},
						data: dataArr
					};
				}

				chartSeries.push(temp);
			});

			console.log(chartSeries);

			Highcharts.chart('hchart2', {
				chart: {
					backgroundColor: 'transparent',
					type: 'column'
				},
				navigation: {
					buttonOptions: {
						enabled: false /* 메뉴 안보이기 */
					}
				},
				title: {
					text: null
				},
				xAxis: {
					labels: {
						// align: 'center',
						// style: {
						// 	color: '#3d4250',
						// 	fontSize: '14px'
						// }
						enabled: false
					},
					tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
					title: {
						text: null
					},
					crosshair: true /* 포커스 선 */
				},
				yAxis: [{
					gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
					title: {
						text: '',
						align: 'low',
						rotation: 0, /* 타이틀 기울기 */
						y: 25, /* 타이틀 위치 조정 */
						x: 5, /* 타이틀 위치 조정 */
						style: {
							color: '#3d4250',
							fontSize: '10px'
						}
					},
					labels: {
						overflow: 'justify',
						x: -10, /* 그래프와의 거리 조정 */
						style: {
							color: '#3d4250',
							fontSize: '10px'
						}
					}
				}, {
					gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
					title: {
						text: '',
						align: 'low',
						rotation: 0, /* 타이틀 기울기 */
						y: 25, /* 타이틀 위치 조정 */
						x: -5, /* 타이틀 위치 조정 */
						style: {
							color: '#3d4250',
							fontSize: '10px'
						}
					},
					labels: {
						overflow: 'justify',
						x: 10, /* 그래프와의 거리 조정 */
						style: {
							color: '#3d4250',
							fontSize: '10px'
						}
					},
					alignTicks: false,
					opposite: true
				}],
				/* 범례 */
				legend: {
					enabled: true,
					align: 'right',
					verticalAlign: 'top',
					x: 10,
					itemStyle: {
						color: '#3d4250',
						fontSize: '14px',
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
						return this.points.reduce(function (s, point) {
							return s + '<br/>' + point.series.name + ': ' + Number(point.y).toFixed(2) + point.series.userOptions.tooltip.valueSuffix;
						}, '<b>' + new Date(this.x).format('yyyy.MM.dd hh:mm:ss') + '</b>');
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
					},
					column: {
						stacking: 'normal'
					}
				},
				/* 출처 */
				credits: {
					enabled: false
				},
				series: chartSeries
			});
		});

		$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
	});

</script>

<div class="col-lg-12">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">상태 이력</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="row">
				<div class="indiv his_chart_top clear">
					<div class="sa_select fl">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">선택해주세요.
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="place">
							</ul>
						</div>
					</div>
					<div class="fl">
						<span class="tx_tit">설비 타입</span>
						<div class="sa_select">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">전체
									<span class="caret"></span>
								</button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
									<li>
										<a href="#" tabindex="-1">
											<input type="checkbox" id="type_1" value="INV_PV">
											<label for="type_1"><span></span>태양광 인버터</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="sa_select">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">복수 선택
									<span class="caret"></span>
								</button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="device">
									<li class="dropdown_cov clear">

										<div class="li_btn_bx clear">
											<div class="fl">
												<button type="button" class="btn_type03">모두 선택</button>
												<button type="button" class="btn_type03">모두 해제</button>
											</div>
											<div class="fr"><button type="button" class="btn_type">적용</button></div>
										</div>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="fl">
						<span class="tx_tit">기간 설정</span>
						<div class="sel_calendar">
							<input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
							<em>-</em>
							<input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
						</div>
					</div>

					<div class="fl">
						<span>조회주기</span>
						<div class="sa_select">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown" data-value="15min">15분
									<span class="caret"></span></button>
								<ul class="dropdown-menu" id="interval">
									<li><a href="#" data-value="1min">1분</a></li>
									<li class="on"><a href="#" data-value="15min">15분</a></li>
									<li><a href="#" data-value="hour">1시간</a></li>
									<li><a href="#" data-value="day">1일</a></li>
									<li><a href="#" data-value="week">1주</a></li>
									<li><a href="#" data-value="month">1월</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="fl">
						<button type="button" id="search" class="btn_type">조회</button>
					</div>
					<div class="fr">
						<a href="#;" class="save_btn">데이터저장</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="row">
				<div class="indiv">
					<div class="his_chart_top clear">
						<div class="clear">
							<h2 class="fl s_tit">분석 기준 설비 선택</h2>
							<a href="#" class="btn_type02 fr">분석 조건 저장</a>
						</div>
						<!-- 기본 항목 -->
						<div class="clear" id="analyzeDiv1">
							<div class="fl">
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown" style="width:220px;">
											설비명<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" id="chartDid">
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown" data-value="acVoltageRS">
											AC 전압R<span class="caret"></span>
										</button>
										<ul class="dropdown-menu dropdown-menu-form rdo_type" role="menu">
											<li>
												<a href="#" data-value="acVoltageRS" tabindex="-1">
													<input type="radio" id="column01" name="column" value="acVoltageRS" checked>
													<label for="column01"><span></span>AC 전압R</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageST" tabindex="-1">
													<input type="radio" id="column02" name="column" value="acVoltageST">
													<label for="column02"><span></span>AC 전압S</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageST" tabindex="-1">
													<input type="radio" id="column03" name="column" value="acVoltageST">
													<label for="column03"><span></span>AC 전압T</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acCurrentR" tabindex="-1">
													<input type="radio" id="column04" name="column" value="acCurrentR">
													<label for="column04"><span></span>AC 전류R</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acCurrentS" tabindex="-1">
													<input type="radio" id="column05" name="column" value="acCurrentS">
													<label for="column05"><span></span>AC 전류S</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acCurrentT" tabindex="-1">
													<input type="radio" id="column06" name="column" value="acCurrentT">
													<label for="column06"><span></span>AC 전류T</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acPower" tabindex="-1">
													<input type="radio" id="column07" name="column" value="acPower">
													<label for="column07"><span></span>순시전력</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="dcVoltage" tabindex="-1">
													<input type="radio" id="column08" name="column" value="dcVoltage">
													<label for="column08"><span></span>DC 전압T</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="dcCurrent" tabindex="-1">
													<input type="radio" id="column09" name="column" value="dcCurrent">
													<label for="column09"><span></span>DC 전류</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="dcPower" tabindex="-1">
													<input type="radio" id="column10" name="column" value="dcPower">
													<label for="column10"><span></span>DC 전력</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="temperature" tabindex="-1">
													<input type="radio" id="column11" name="column" value="temperature">
													<label for="column11"><span></span>인번터 온도</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown" data-vlue="avg">
											평균<span class="caret"></span>
										</button>
										<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
											<li>
												<a href="#" data-value="max" tabindex="-1">
													<input type="radio" id="rdValue1" name="rdValue" value="max">
													<label for="rdValue1"><span></span>최대</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="min" tabindex="-1">
													<input type="radio" id="rdValue2" name="rdValue" value="min">
													<label for="rdValue2"><span></span>최소</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="avg" tabindex="-1">
													<input type="radio" id="rdValue3" name="rdValue" value="" checked>
													<label for="rdValue3"><span></span>평균</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown" data-value="l">y-좌
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" id="way">
											<li class="on"><a href="#" data-value="l">y-좌</a></li>
											<li><a href="#" data-value="r">y-우</a></li>
										</ul>
									</div>
								</div>
							</div>

							<!-- 버튼 -->
							<div class="fl">
								<button type="button" class="btn_type" id="chartAdd">그래프 항목 추가</button>
								<button type="button" class="btn_type" id="chartDraw">그래프 그리기</button>
							</div>

							<!-- 우측 항목 -->
							<div class="fr his_inp_bx">
								<div class="rdo_type his_rdo_bx">
									<span>
										<input type="radio" id="analyze1" name="analyze" value="시계열 분석" checked>
										<label for="analyze1"><span></span>시계열 분석</label>
									</span>
									<span>
										<input type="radio" id="analyze2" name="analyze" value="상관 분석" disabled>
										<label for="analyze2"><span></span>상관 분석</label>
									</span>
								</div>

								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w6" type="button" data-toggle="dropdown" data-value="siteAccrue">
											선택안함<span class="caret"></span>
										</button>
										<ul class="dropdown-menu rdo_type" id="standard">
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="radio" id="standard1" name="standard" value="siteAccrue">
													<label for="standard1"><span></span>사이트별 누적</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option2" tabindex="-1">
													<input type="radio" id="standard2" name="standard" value="siteAverage">
													<label for="standard2"><span></span>사이트별 평균</label>
												</a>
											</lili>
												<a href="#" data-value="option3" tabindex="-1">
													<input type="radio" id="standard3" name="standard" value="deviceAccrue">
													<label for="standard3"><span></span>설비별 누적</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option4" tabindex="-1">
													<input type="radio" id="standard4" name="standard" value="deviceAverage">
													<label for="standard4"><span></span>설비별 평균</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option5" tabindex="-1">
													<input type="radio" id="standard5" name="standard" value="" checked>
													<label for="standard5"><span></span>선택안함</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>

						<br>
						<!-- x축 y축 -->
						<div class="clear" style="display:none;" id="analyzeDiv2">
							<div class="fl">
								<span class="tx_tit">x축</span>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">
											설비명<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" id="chartDid2">
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">
											DC 전압<span class="caret"></span>
										</button>
										<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
											<li>
												<a href="#" data-value="dcVoltage" tabindex="-1">
													<input type="radio" id="column2_01" name="column2" value="dcVoltage" checked>
													<label for="column2_01"><span></span>DC 전압</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="dcCurrent" tabindex="-1">
													<input type="radio" id="column2_02" name="column2" value="dcCurrent">
													<label for="column2_02"><span></span>DC 전류</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="dcPower" tabindex="-1">
													<input type="radio" id="column2_03" name="column2" value="dcPower">
													<label for="column2_03"><span></span>DC 전류</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="now" tabindex="-1">
													<input type="radio" id="column2_04" name="column2" value="now">
													<label for="column2_04"><span></span>현재 출력</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="totalGenPower" tabindex="-1">
													<input type="radio" id="column2_05" name="column2" value="totalGenPower">
													<label for="column2_05"><span></span>누전발전량</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageTR" tabindex="-1">
													<input type="radio" id="column2_06" name="column2" value="acVoltageTR">
													<label for="column2_06"><span></span>AC 전압R</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageRS" tabindex="-1">
													<input type="radio" id="column2_07" name="column2" value="acVoltageRS">
													<label for="column2_07"><span></span>AC 전압S</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageST" tabindex="-1">
													<input type="radio" id="column2_08" name="column2" value="acVoltageST">
													<label for="column2_08"><span></span>AC 전압T</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="powerFactor" tabindex="-1">
													<input type="radio" id="column2_09" name="column2" value="powerFactor">
													<label for="column2_09"><span></span>역률</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">
											평균<span class="caret"></span>
										</button>
										<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="radio" id="rdValue2_01" name="rdValue2" value="최대">
													<label for="rdValue2_01"><span></span>최대</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option2" tabindex="-1">
													<input type="radio" id="rdValue2_02" name="rdValue2" value="최소">
													<label for="rdValue2_02"><span></span>최소</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option2" tabindex="-1">
													<input type="radio" id="rdValue2_03" name="rdValue2" value="평균">
													<label for="rdValue2_03"><span></span>평균</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>

							<div class="fl">
								<span class="tx_tit">y축</span>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">
											사이트명<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" id="chartDid3">
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">
											DC 전압<span class="caret"></span>
										</button>
										<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
											<li>
												<a href="#" data-value="dcVoltage" tabindex="-1">
													<input type="radio" id="column3_01" name="column3" value="dcVoltage" checked>
													<label for="column3_01"><span></span>DC 전압</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="dcCurrent" tabindex="-1">
													<input type="radio" id="column3_02" name="column3" value="dcCurrent">
													<label for="column3_02"><span></span>DC 전류</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="dcPower" tabindex="-1">
													<input type="radio" id="column3_03" name="column3" value="dcPower">
													<label for="column3_03"><span></span>DC 전류</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="now" tabindex="-1">
													<input type="radio" id="column3_04" name="column3" value="now">
													<label for="column3_04"><span></span>현재 출력</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="totalGenPower" tabindex="-1">
													<input type="radio" id="column3_05" name="column3" value="totalGenPower">
													<label for="column3_05"><span></span>누전발전량</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageTR" tabindex="-1">
													<input type="radio" id="column3_06" name="column3" value="acVoltageTR">
													<label for="column3_06"><span></span>AC 전압R</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageRS" tabindex="-1">
													<input type="radio" id="column3_07" name="column3" value="acVoltageRS">
													<label for="column3_07"><span></span>AC 전압S</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="acVoltageST" tabindex="-1">
													<input type="radio" id="column3_08" name="column3" value="acVoltageST">
													<label for="column3_08"><span></span>AC 전압T</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="powerFactor" tabindex="-1">
													<input type="radio" id="column3_09" name="column3" value="powerFactor">
													<label for="column3_09"><span></span>역률</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">
											평균<span class="caret"></span></button>
										<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="radio" id="rdValue3_1" name="rdValue3" value="max">
													<label for="rdValue3_1"><span></span>최대</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option2" tabindex="-1">
													<input type="radio" id="rdValue3_2" name="rdValue3" value="min">
													<label for="rdValue3_2"><span></span>최소</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option2" tabindex="-1">
													<input type="radio" id="rdValue3_3" name="rdValue3" value="" checked>
													<label for="rdValue3_3"><span></span>평균</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>

							<!-- 버튼 -->
							<div class="fl">
								<button type="button" class="btn_type">그래프 항목 추가</button>
								<button type="button" class="btn_type">그래프 그리기</button>
							</div>

							<!-- 우측 항목 -->
							<div class="fr his_inp_bx">
								<div class="rdo_type his_rdo_bx">
									<span>
										<input type="radio" id="rdo03_1" name="rdo_btn22" value="시계열 분석">
										<label for="rdo03_1"><span></span>시계열 분석</label>
									</span>
									<span>
										<input type="radio" id="rdo03_2" name="rdo_btn22" value="상관 분석" checked>
										<label for="rdo03_2"><span></span>상관 분석</label>
									</span>
								</div>

								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w6" type="button" data-toggle="dropdown">
											사이트별 누적<span class="caret"></span></button>
										<ul class="dropdown-menu rdo_type" id="standard2_0">
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="radio" id="standard1" name="standard2" value="siteAccrue" checked>
													<label for="standard21"><span></span>사이트별 누적</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option2" tabindex="-1">
													<input type="radio" id="standard22" name="standard2" value="siteAverage">
													<label for="standard22"><span></span>사이트별 평균</label>
												</a>
												</lili>
												<a href="#" data-value="option3" tabindex="-1">
													<input type="radio" id="standard23" name="standard2" value="deviceAccrue">
													<label for="standard23"><span></span>설비별 누적</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option4" tabindex="-1">
													<input type="radio" id="standard24" name="standard2" value="deviceAverage">
													<label for="standard24"><span></span>설비별 평균</label>
												</a>
											</li>
											<li>
												<a href="#" data-value="option5" tabindex="-1">
													<input type="radio" id="standard25" name="standard2" value="">
													<label for="standard25"><span></span>선택안함</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>

						<!-- x,y축 태그 -->
						<div class="tag_bx clear">
							<div class="fl">
								<span class="tx_tit">y-좌</span>
							</div>
							<div class="fl">
								<span class="tx_tit">y-우</span>
							</div>
						</div>
					</div>
					<br>
					<br>
					<div class="inchart">
						<div id="hchart2"></div>
					</div>
				</div>
			</div>
		</div>

		<div class="row usage_chart_table">
			<div class="col-lg-12">
				<div class="indiv">
					<table class="his_tbl" id="datatable">
						<thead>
							<tr>
								<th data-column="siteNm">사업소</th>
								<th data-column="dname">설비명</th>
								<th data-column="timestamp">시간</th>
								<th data-column="temperature"><button class="btn_align">온도</button></th>
								<th data-column="acVoltageTR"><button class="btn_align">전압R</button></th>
								<th data-column="acVoltageRS"><button class="btn_align">전압S</button></th>
								<th data-column="acVoltageST"><button class="btn_align">전압T</button></th>
								<th data-column="acCurrentR"><button class="btn_align">전류R</button></th>
								<th data-column="acCurrentS"><button class="btn_align">전류S</button></th>
								<th data-column="acCurrentT"><button class="btn_align">전류T</button></th>
								<th data-column="acPower"><button class="btn_align">순시전력</button></th>
								<th data-column="dcVoltage"><button class="btn_align">DC전압</button></th>
								<th data-column="dcCurrent"><button class="btn_align">DC전류</button></th>
								<th data-column="dcPower"><button class="btn_align">DC전력</button></th>
								<th data-column="operation"><button class="btn_align">설비상태</button></th>
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