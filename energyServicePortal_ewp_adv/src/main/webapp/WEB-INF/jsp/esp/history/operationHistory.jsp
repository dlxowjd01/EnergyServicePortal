<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	const debugMode = true;
	const apiURL = 'http://iderms.enertalk.com:8443';
	const configSite = '/config/sites';
	const configDevice = '/config/orgs/' + 'spower';
	const statusSummary = '/status/summary';
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

	let deviceList;
	let gridList;

	$(function () {
		siteList();

		setInitList('columnLi');
		setInitList('columnLi2');
		setInitList('columnLi3');

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
			deviceType();
		});

		$(document).on('click', ':checkbox[name="type"]', function(e) {
			if($(this).is(':checked')) {
				let extendText = '';
				if ($(':checkbox[name="type"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="type"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$('#deviceType button').html($(':checkbox[name="type"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
			} else {
				if($(':checkbox[name="type"]:checked').length == 0) {
					$('#deviceType button').html('선택해주세요.' + '<span class="caret"></span>')
				} else {
					let extendText = '';
					if ($(':checkbox[name="type"]:checked').length > 1) {
						extendText = '외 ' + Number($(':checkbox[name="type"]:checked').length - 1) + '개';
					}
					//첫 번째 값 + 외 몇개로 표기
					$('#deviceType button').html($(':checkbox[name="type"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
				}
			}
			device();
		});

		$(document).on('click', ':checkbox[name="device"]', function(e) {
			if($(this).is(':checked')) {
				let extendText = '';
				if ($(':checkbox[name="device"]:checked').length > 1) {
					extendText = '외 ' + Number($(':checkbox[name="device"]:checked').length - 1) + '개';
				}
				//첫 번째 값 + 외 몇개로 표기
				$('#devices button.btn-primary').html($(':checkbox[name="device"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
			} else {
				if($(':checkbox[name="device"]:checked').length == 0) {
					$('#deviceType button.btn-primary').html('선택해주세요.' + '<span class="caret"></span>')
				} else {
					let extendText = '';
					if ($(':checkbox[name="type"]:checked').length > 1) {
						extendText = '외 ' + Number($(':checkbox[name="device"]:checked').length - 1) + '개';
					}
					//첫 번째 값 + 외 몇개로 표기
					$('#devices button.btn-primary').html($(':checkbox[name="device"]:checked').eq(0).next('label').text() + extendText + '&nbsp;<span class="caret"></span>');
				}
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

		$(document).on('click', '[id^=chartDid] a', function() {
			let val = $(this).data('value');
			let sid = $(this).data('sid');
			let type = $(this).data('type');
			let idNum = $(this).parents('div.sa_select').prop('id').replace('chartDid', '');

			$(this).parents('ul').prev('button').data('value', val).data('sid', sid).data('type', type).empty().append($(this).html()).append('<span class="caret"></span>');


			$.map(featureProperties, function(value, key) {
				if (type == key) {
					$('#columnLi' + idNum).empty().prev().html('선택 <span class="caret"></span>');
					setMakeList(value, 'columnLi' + idNum, {"dataFunction": {"INDEX": getNumberIndex}}); //list생성
				}
			});

		});

		$(document).on('click', '#way a', function() {
			$(this).parents('ul').prev('button').data('value', $(this).data('value')).empty().append($(this).html()).append('<span class="caret"></span>');
		});

		$(':radio[name="analyze"]').on('change', function() {
			$('[id^="analyzeDiv"]').hide();
			$('[id^="analyzeTag"]').hide();
			if($(this).attr('id') == 'analyze1') {
				$('#analyzeDiv1').show();
				$('#analyzeTag1').show();
				$('#summation').show();
			} else {
				$('#analyzeDiv2').show();
				$('#analyzeTag2').show();
				$('#summation').hide();
			}

			if($('#hchart2').highcharts()) {
				$('#hchart2').highcharts().destroy();
			}

		});

		//헤더 클릭
		$('.his_tbl thead th').on('click', function (e) {
			e.preventDefault();
			var idx = $('.his_tbl thead th').index($(this))
				, order = $(this).data('order')
				, column = $(this).data('column');
			if (idx > 1) {
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
		$('#deviceType button').on('click', function (e) {
			if ($(':checkbox[name="site"]:checked').length <= 0) {
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
		$('#devices button.btn_type03').on('click', function (e) {
			let idx = $('#devices button.btn_type03').index($(this));

			if (idx == 0) {
				$('[id^="device_"]').prop('checked', true);
			} else {
				$('[id^="device_"]').prop('checked', false);
			}
		});


		$('#chartAdd').on('click', function() {

			if($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
				if($('#chartDid button').data('value') == '') {
					alert('추가 하시려는 설비명을 선택 해 주세요.');
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

				//기존항목이 존재한다면 중복체크
				if($('#way').prev('button').data('value') == 'l') {
					if($('#analyzeTag1 .tx_tit:eq(0) span').length > 0) {
						if(duplicateTag(0)) {
							return false;
						}
					}
				} else {
					if($('#analyzeTag1 .tx_tit:eq(1) span').length > 0) {
						if(duplicateTag(1)) {
							return false;
						}
					}
				}

				let $txt =$('#chartDid button').text() + ': ' + $(':radio[name="column"]:checked').next('label').text() + $(':radio[name="rdValue"]:checked').next('label').text()
				let $span = $('<span>').addClass('tag_type').append($txt).append('<button>')
				$span.data('deviceId', $('#chartDid button').data('value'));
				$span.data('sid', $('#chartDid button').data('sid'));
				$span.data('type', $('#chartDid button').data('type'));
				$span.data('key', $(':radio[name="column"]:checked').val())
				$span.data('key2', $(':radio[name="rdValue"]:checked').val());
				$span.find('button').append('닫기');

				if($('#way').prev('button').data('value') == 'l') {
					$('#analyzeTag1 .tx_tit').eq(0).append($span);
				} else {
					$('#analyzeTag1 .tx_tit').eq(1).append($span);
				}
			} else {
				if($('#chartDid2 button').data('value') == '') {
					alert('X축에 추가 하시려는 설비명을 선택 해 주세요.');
					return false;
				}

				if($(':radio[name="column2"]').is(':checked') == false) {
					alert('X축에 추가 하시려는 항목을 선택 해 주세요.');
					return false;
				}

				if($(':radio[name="rdValue2"]').is(':checked') == false) {
					alert('X축에 선택 해 주세요.');
					return false;
				}

				if($('#chartDid3 button').data('value') == '') {
					alert('Y축에 추가 하시려는 설비명을 선택 해 주세요.');
					return false;
				}

				if($(':radio[name="column3"]').is(':checked') == false) {
					alert('Y축에 추가 하시려는 항목을 선택 해 주세요.');
					return false;
				}

				if($(':radio[name="rdValue3"]').is(':checked') == false) {
					alert('Y축에 선택 해 주세요.');
					return false;
				}

				//기존항목이 존재한다면 중복체크
				if($('#analyzeTag2 > div.fl > span').length > 0) {
					if(duplicateTag(2)) {
						return false;
					}
				}

				let $txt =$('#chartDid2 button').text() + ': ' + $(':radio[name="column2"]:checked').next('label').text() + $(':radio[name="rdValue2"]:checked').next('label').text();
				let $txt2 =$('#chartDid3 button').text() + ': ' + $(':radio[name="column3"]:checked').next('label').text() + $(':radio[name="rdValue3"]:checked').next('label').text();
				let $span = $('<span>').addClass('tag_type').append($txt + '/' + $txt2).append('<button>')
				$span.data('deviceIdX', $('#chartDid2 button').data('value'));
				$span.data('keyX', $(':radio[name="column2"]:checked').val());
				$span.data('key2X', $(':radio[name="rdValue2"]:checked').val());

				$span.data('deviceIdY', $('#chartDid3 button').data('value'));
				$span.data('keyY', $(':radio[name="column3"]:checked').val());
				$span.data('key2Y', $(':radio[name="rdValue3"]:checked').val());

				$span.data('typeX', $('#chartDid2 button').data('type'));
				$span.data('typeY', $('#chartDid3 button').data('type'));

				$span.find('button').append('닫기');

				$('#analyzeTag2 > div.fl').append($span);
			}
		});

		//항목 삭제
		$(document).on('click', '.tag_type button', function() {
			$(this).parents('span.tag_type').remove();
		});

		$(':radio[name="summation"]').on('change', function() {
			$('#chartDraw').trigger('click');
		});

		$('#chartDraw').on('click', function() {
			let chartColor = ['#b0e9e8', '#26ccc8', '#009389', '#50b5ff', '#5269ef', '#274dea'];
			let chartSeries = new Array();
			let summation = $(':radio[name="summation"]:checked').val();
			let stackNum = 0;

			if($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
				if($('#analyzeTag1 span').length <= 0) {
					alert('한개이상 항목을 선택해 주세요.');
					return false;
				}

				let index = 0;
				let dupY = 1;

				$('#analyzeTag1 .tx_tit').eq(0).find('span').each(function() {
					let dataArr = new Array();

					let keyText = $(this).data('key');
					let keyText2 = $(this).data('key2');
					let deviceId = $(this).data('deviceId');
					let sid = $(this).data('sid');
					let type = $(this).data('type');

					let temp = {};
					let suffix = '';

					$.map(gridList, function(value, key) {
						if(type == key) {
							$.each(value, function(j, el) {
								if(el.did == deviceId) {
									dataArr.push({
										'x': el.timestamp,
										'y': parseFloat(eval('el.' + keyText2 + '.' + keyText))
									});
								}
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
						if(summation == 'siteAccrue' || summation == 'siteAverage') {
							if(chartSeries.length > 0) {
								let dupSeries = false;
								chartSeries.some(function(v, k) {
									if(v.sid == sid) {
										dupSeries = true;
										return stackNum = v.stack;
									}
								});

								if(!dupSeries) {
									stackNum++;
								}
							} else {
								stackNum++;
							}
						} else if(summation == 'deviceAccrue' || summation == 'deviceAverage') {
							if(chartSeries.length > 0) {
								let dupSeries = false;
								chartSeries.some(function(v, k) {
									if(v.dType == type) {
										dupSeries = true;
										return stackNum = v.stack;
									}
								});

								if(!dupSeries) {
									stackNum++;
								}
							} else {
								stackNum++;
							}
						} else {
							stackNum++;
						}

						temp = {
							name: $(this).text().replace('닫기', ''),
							type: 'column',
							stack: stackNum,
							sid: sid,
							dType: type,
							tooltip: {
								valueSuffix: suffix
							},
							color: chartColor[index],
							data: dataArr
						};
						index++;
					}

					chartSeries.push(temp);

					//양쪽이 동일할경우 체크
					$('#analyzeTag1 .tx_tit').eq(1).find('span').each(function() {
						let keyText_1 = $(this).data('key');
						if(keyText == keyText_1) {
							dupY = 0;
						}
					});
				});

				$('#analyzeTag1 .tx_tit').eq(1).find('span').each(function() {
					let dataArr = new Array();

					let keyText = $(this).data('key');
					let keyText2 = $(this).data('key2');
					let deviceId = $(this).data('deviceId');
					let sid = $(this).data('sid');
					let type = $(this).data('type');

					let temp = {};
					let suffix = '';
					$.map(gridList, function(value, key) {
						if(type == key) {
							$.each(value, function(j, el) {
								if(el.did == deviceId) {
									dataArr.push({
										'x': el.timestamp,
										'y': parseFloat(eval('el.' + keyText2 + '.' + keyText))
									});
								}
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
							sid: sid,
							dType: type,
							color: chartColor[index],
							tooltip: {
								valueSuffix: suffix
							},
							data: dataArr
						};
						index++;
					}

					chartSeries.push(temp);
				});
			} else {
				if($('#analyzeTag2 span').length <= 0) {
					alert('한개이상 항목을 선택해 주세요.');
					return false;
				}

				// //시간순으로 정렬을 해준다.
				// gridList.sort(function(a, b) {
				// 	return a['timestamp'] - b['timestamp'];
				// })

				let index = 0;
				let dupY = 1;
				$('#analyzeTag2 span').each(function() {
					let dataArr = new Array();

					let seriesName = $(this).text().replace(/\n(\s*)/gi, '').trim().replace('닫기', '');
					let keyTextX = $(this).data('keyX');
					let keyText2X = $(this).data('key2X');
					let deviceIdX = $(this).data('deviceIdX');

					let keyTextY = $(this).data('keyY');
					let keyText2Y = $(this).data('key2Y');
					let deviceIdY = $(this).data('deviceIdY');

					let typeX = $(this).data('typeX');
					let typeY = $(this).data('typeY');

					let temp = {};
					let suffix = '';

					$.map(gridList, function(value, key) {
						if(typeX == key) {
							$.each(value, function(j, el) {
								let timestamp = el.timestamp;
								dataArr.push([
									parseFloat(eval('el.' + keyText2X + '.' + keyTextX))
								]);

								$.map(gridList, function(value, key) {
									if (typeY == key) {
										$.each(value, function (j, el) {
											if (el.did == deviceIdY) {
												$.each(value, function (v, k) {
													if (timestamp == v.timestamp) {
														dataArr[dataArr.length - 1].push(parseFloat(eval('v.' + keyText2Y + '.' + keyTextY)))
													}
												});
											}
										});
									}
								});
							});
						}
					});



					temp = {
						name: seriesName,
						type: 'scatter',
						color: chartColor[index],
						tooltip: {
							valueSuffix: suffix
						},
						data: dataArr
					};
					index++;
					chartSeries.push(temp);
				});
			}

			chartDraw(chartSeries);
		});

		$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본

		$('.save_btn').on('click', function(e) {
			let excelName = '상태이력';
			let $val = $('#datatable').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {
					tableToExcel('datatable', excelName, e);
				}
			}
		});

		deviceProperties();
	});

	const getNumberIndex = function (index) {
		return index + 1;
	}

	let tableProperties = new Object();
	let featureProperties = new Object();
	const deviceProperties = function() {
		$.ajax({
			url: apiURL + '/config/view/device_properties',
			type: 'get',
			async: false,
			data: {
				version: '20200513'
			},
			success: function(result) {
				$.map(result, function(val, key) {
					let deviceName = key;
					let propList = val.properties;
					let tempTable = new Array();
					let tempFeature = new Array();

					$.map(propList, function(v, k) {
						if(v.analysis_table) {
							let tempObj = new Object();
							if(k == 'currentS') {
								tempObj['key'] = k;
								tempObj['value'] = v.name;
							} else {
								tempObj['key'] = k;
								tempObj['value'] = v.name.kr;
							}
							tempTable.push(tempObj);
						}

						if(v.analysis_feature) {
							let tempObj = new Object();
							if(k == 'currentS') {
								tempObj['key'] = k;
								tempObj['value'] = v.name;
							} else {
								tempObj['key'] = k;
								tempObj['value'] = v.name.kr;
							}
							tempFeature.push(tempObj);
						}
					});
					tableProperties[deviceName] = tempTable;
					featureProperties[deviceName] = tempFeature;
				});
			},
			dataType: 'json'
		});
	};

	//사업소 조회
	const siteList = function() {
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

	//선택한 SID에 해당하는 유형의 타입을 보여준다.
	const deviceType = function () {
		$('#deviceType button').empty().append('설비유형<span class="caret"></span>');

		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
				function(){
					return $(this).val();
				}
			)
		);

		if(siteArray.length > 0) {
			$.ajax({
				url : apiURL + configDevice,
				type : 'get',
				async : false,
				data : configDeviceData,
				success: function(result) {
					deviceList = result.devices;
					let deviceType = new Array();

					$('#deviceType ul').empty();

					let str = '';
					if(deviceList.length > 0) {
						$.each(siteArray, function(i, site) {
							// let siteId = site;
							$.each(deviceList, function(i, el) {
								if(el.sid == site) {
									if($.inArray(el.device_type, deviceType) === -1) {
										let deviceName = eval('deviceTemplate.' + el.device_type);
										str += `<li>
													<a href="#" data-value="${'${el.device_type}'}" tabindex="-1">
														<input type="checkbox" id="type_${'${i}'}" name="type" value="${'${el.device_type}'}">
														<label for="type_${'${i}'}"><span></span>${'${deviceName}'}</label>
													</a>
												</li>`
										deviceType.push(el.device_type)
									}
								}
							});
						});
						$('#deviceType ul').append(str);
					} else {
						let typeHtml = $('<li>').append('<a>').data('value', '').attr('href', '#').html('조회된 설비가 없습니다.');
						$('#type').append(typeHtml);
						$('#type').before('button').empty().append('설비유형').append('<span class="caret"></span>');
					}
				},
				dataType: 'json'
			});
		} else {
			$('#deviceType ul').empty();
		}
	};

	//설비타입 디바이스타입 설정한다.
	const device = function () {
		$('#devices button.btn-primary').empty().append('복수 선택').append('<span class="caret"></span>');

		const typeArray = $.makeArray($(':checkbox[name="type"]:checked').map(
				function(){
					return $(this).val();
				}
			)
		);

		if(typeArray.length > 0 && deviceList.length > 0) {
			$('#devices div.sec_li_bx').remove();

			//선택된 사이트를 기준으로 한다.
			$(':checkbox[name="site"]:checked').each(function () {
				let siteNm = $(this).next().text()
				  , siteId = $(this).val()
				  , siteGrp = $('<div>').addClass('sec_li_bx');

				siteGrp.append('<p>');
				siteGrp.find('p').addClass('tx_li_tit').text(siteNm);
				siteGrp.append('<ul>');

				$.each(deviceList, function(i, el) {
					if (el.sid == siteId) {
						$.each(typeArray, function(k, elm) {
							if(elm == el.device_type) {
								let str = `<li>
											<a href="#" data-value="${'${el.did}'}" tabindex="-1">
												<input type="checkbox" id="device_${'${i}'}" name="device" value="${'${el.did}'}" data-sid="${'${el.sid}'}" data-type="${'${el.device_type}'}">
												<label for="device_${'${i}'}"><span></span>${'${el.name}'}</label>
											</a>
										</li>`
								siteGrp.find('ul').append(str);
							}
						});
					}
				});

				$('#devices li.dropdown_cov').prepend(siteGrp);
			});
		}
	}

	const makeTableTemplate = function () {
		$('#datatable').empty();

		$(':checkbox[name="type"]:checked').each(function() {
			let chkVal = $(this).val();
			let targetTable = document.createElement('table');
			let thead = targetTable.createTHead();
			let tbody = targetTable.createTBody();
			let hRow = thead.insertRow();
			let bRow = tbody.insertRow();

			targetTable.setAttribute('class', 'his_tbl');
			tbody.setAttribute('id', chkVal+'_Table');

			console.log(chkVal);
			$.map(tableProperties, function(value, key) {
				if(chkVal == key) {
					$.each(value, function(idx, valObj) {
						let hCell = document.createElement("TH");
						hCell.innerHTML = valObj.value;
						hRow.appendChild(hCell);

						let bCell = bRow.insertCell();
						if (valObj.key == 'did') {
							bCell.innerHTML = '[dname]';
						} else {
							bCell.innerHTML = '[' + valObj.key + ']';
						}

					});

					let html = $('<div>').addClass('col-lg-12');
					$('<div>').addClass('indiv').appendTo(html);
					html.find('div.indiv').append(targetTable);
					$('#datatable').append(html);
					setInitList(chkVal+'_Table');
				}
			});
		});
	};

	const searchGrid = function () {

		if($(':checkbox[name="site"]:checked').length == 0) {
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

		let siteArray = new Array();
		let deviceArray = new Array();

		$(':checkbox[name="site"]:checked').each(function() {
			siteArray.push($(this).val());
		});

		$(':checkbox[name="device"]:checked').each(function() {
			deviceArray.push($(this).val());
		});

		makeTableTemplate();
		//설비유형이 여러개일경우 하나만 들어가서 여러번 호출한다.
// 		$(':checkbox[id^=type_]:checked').each(function() {
			let statusSummaryData = {
				sids: siteArray.join(','),
				dids: deviceArray.join(','),
				//deviceType: '',
				startTime: $('#datepicker1').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#datepicker2').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: $('#interval').prev('button').data('value'),
				formId: 'v2'
			}

			$.ajax({
				url : apiURL + statusSummary,
				type : 'get',
				async : false,
				data : statusSummaryData,
				success: function(result) {
					console.log(result);

					let chart = $('#hchart2').highcharts();
					if(chart) {
						chart.destroy();

						$('[id^=columnLi]').empty().prev().html('선택 <span class="caret"></span>');
					}

					$.map(result, function(value, key) {
						if($('#'+key+'_Table').length > 0) {
							$.each(value, function(idx, valObj) {
								value[idx].localtime = String (valObj.basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
								value[idx].timestamp = new Date(value[idx].localtime).getTime();
								$.map(valObj.mean, function(v, k) {
									valObj[k] = numberComma(v.toFixed(2));
								});
							});

							setMakeList(value, key + '_Table', {'dataFunction': {}}); //list생성

							$('#' + key + '_Table').find('td').each(function() {
								$(this).html($(this).html().replace(/ *\[[^)]*\] */g, ''));
							});
						}
					});

					gridList = result;
					setChartDid();
				},
				dataType: 'json'
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
			trHtml.append('<td>' + new Date(el.timestamp).format('yyyy.MM.dd HH:mm:ss') + '</td>');
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

	const setChartDid = function() {
		$('[id^=chartDid] ul').empty();
		$(':checkbox[name="device"]:checked').each(function() {
			let siteNm = $(this).parents('div.sec_li_bx').find('p.tx_li_tit').text().trim(); //사이트명
			let deviceNm = $(this).next().text().trim();
			let val = $(this).val();
			let sid = $(this).data('sid');
			let type = $(this).data('type');

			let str = `<li>
							<a href="#" data-value="${'${val}'}" data-sid="${'${sid}'}" data-type="${'${type}'}">
								${'${siteNm}_${deviceNm}'}
							</a>
						</li>`;
			$('[id^=chartDid] ul').append(str);
		});
	}

	//그래프 태그 중복체크
	const duplicateTag = function(i) {
		let dup = false;
		if(i == 2) {
			$('#analyzeTag2 span').each(function() {
				let spanDidX = $(this).data('deviceIdX');
				let spanColumnX = $(this).data('keyX');
				let spanRdValX = $(this).data('key2X');

				let spanDidY = $(this).data('deviceIdY');
				let spanColumnY = $(this).data('keyY');
				let spanRdValY = $(this).data('key2Y');

				if($('#chartDid2 button').data('value') == spanDidX && $(':radio[name="column2"]:checked').val() == spanColumnX && $(':radio[name="rdValue2"]:checked').val() == spanRdValX
					&& $('#chartDid3 button').data('value') == spanDidY && $(':radio[name="column3"]:checked').val() == spanColumnY && $(':radio[name="rdValue3"]:checked').val() == spanRdValY
				) {
					alert('중복된 항목이 존재합니다.');
					dup = true;
				}
			});
		} else {
			$('#analyzeTag1 .tx_tit:eq(' + i + ') span').each(function() {
				let spanDid = $(this).data('deviceId');
				let spanColumn = $(this).data('key');
				let spanRdVal = $(this).data('key2');

				if($('#chartDid button').data('value') == spanDid
						&& $(':radio[name="column"]:checked').val() == spanColumn
						&& $(':radio[name="rdValue"]:checked').val() == spanRdVal
				) {
					alert('중복된 항목이 존재합니다.');
					dup = true;
				}
			});
		}

		return dup;
	}

	const chartDraw = function(chartSeries) {
		let chart = $('#hchart2').highcharts();

		if(chart) {
			chart.destroy();
		}

		let option = {
			chart: {
				renderTo: 'hchart2',
				backgroundColor: 'transparent',
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
						color: 'var(--color3)',
						fontSize: '10px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -10, /* 그래프와의 거리 조정 */
					style: {
						color: 'var(--color3)',
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
						color: 'var(--color3)',
						fontSize: '10px'
					}
				},
				labels: {
					overflow: 'justify',
					x: 10, /* 그래프와의 거리 조정 */
					style: {
						color: 'var(--color3)',
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
					color: 'var(--color3)',
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
					if($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
						return this.points.reduce(function (s, point) {
							return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>' + point.series.name + ': ' + Number(point.y).toFixed(2) + point.series.userOptions.tooltip.valueSuffix;
						}, '<b>' + new Date(this.x).format('yyyy.MM.dd HH:mm:ss') + '</b>');
					} else {
						let tooltip = this.series.name + '<br/>'
						+ 'X:' + (this.x).toFixed(2) + '<br/> Y:' + (this.y).toFixed(2);
						return tooltip;
					}
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
				column: {
					stacking: 'normal'
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
		};

		chart = new Highcharts.Chart(option);
		chart.redraw();
	}
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
					<div class="sa_select fl" id="siteList">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">
								선택해주세요.<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu"></ul>
						</div>
					</div>
					<div class="fl">
						<span class="tx_tit">설비 타입</span>
						<div class="sa_select" id="deviceType">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">
									설비유형<span class="caret"></span>
								</button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu"></ul>
							</div>
						</div>
						<div class="sa_select" id="devices">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">
									복수 선택<span class="caret"></span>
								</button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
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
						<div class="clear">
							<div class="fl" id="analyzeDiv1">
								<div class="sa_select" id="chartDid">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown" style="width:220px;">
											설비명<span class="caret"></span>
										</button>
										<ul class="dropdown-menu">
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown" data-value="">
											선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu dropdown-menu-form rdo_type" role="menu" id="columnLi">
											<li>
												<a href="#" data-value="[key]" tabindex="-1">
													<input type="radio" id="column[INDEX]" name="column" value="[key]">
													<label for="column[INDEX]"><span></span>[value]</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown" data-vlue="mean">
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
													<input type="radio" id="rdValue3" name="rdValue" value="mean" checked>
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
							<div id="analyzeDiv2" style="display:none;" class="fl">
								<div class="fl">
									<span class="tx_tit">x축</span>
									<div class="sa_select" id="chartDid2">
										<div class="dropdown">
											<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown" style="width:220px;">
												설비명<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" >
											</ul>
										</div>
									</div>
									<div class="sa_select">
										<div class="dropdown">
											<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">
												선택<span class="caret"></span>
											</button>
											<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="columnLi2">
												<li>
													<a href="#" data-value="[key]" tabindex="-1">
														<input type="radio" id="column02_[INDEX]" name="column2" value="[key]">
														<label for="column02_[INDEX]"><span></span>[value]</label>
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
														<input type="radio" id="rdValue2_01" name="rdValue2" value="max">
														<label for="rdValue2_01"><span></span>최대</label>
													</a>
												</li>
												<li>
													<a href="#" data-value="option2" tabindex="-1">
														<input type="radio" id="rdValue2_02" name="rdValue2" value="min">
														<label for="rdValue2_02"><span></span>최소</label>
													</a>
												</li>
												<li>
													<a href="#" data-value="option2" tabindex="-1">
														<input type="radio" id="rdValue2_03" name="rdValue2" value="mean" checked>
														<label for="rdValue2_03"><span></span>평균</label>
													</a>
												</li>
											</ul>
										</div>
									</div>
								</div>

								<div class="fl">
									<span class="tx_tit">y축</span>
									<div class="sa_select" id="chartDid3">
										<div class="dropdown">
											<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown" style="width:220px;">
												설비명<span class="caret"></span>
											</button>
											<ul class="dropdown-menu">
											</ul>
										</div>
									</div>
									<div class="sa_select">
										<div class="dropdown">
											<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">
												선택<span class="caret"></span>
											</button>
											<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="columnLi3">
												<li>
													<a href="#" data-value="[key]" tabindex="-1">
														<input type="radio" id="column03_[INDEX]" name="column3" value="[key]">
														<label for="column03_[INDEX]"><span></span>[value]</label>
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
														<input type="radio" id="rdValue3_3" name="rdValue3" value="mean" checked>
														<label for="rdValue3_3"><span></span>평균</label>
													</a>
												</li>
											</ul>
										</div>
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
										<input type="radio" id="analyze2" name="analyze" value="상관 분석">
										<label for="analyze2"><span></span>상관 분석</label>
									</span>
								</div>

								<div class="sa_select" id="summation">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w6" type="button" data-toggle="dropdown" data-value="siteAccrue">
											선택안함<span class="caret"></span>
										</button>
										<ul class="dropdown-menu rdo_type">
											<li>
												<a href="#" data-value="option1" tabindex="-1">
													<input type="radio" id="summation1" name="summation" value="siteAccrue">
													<label for="summation1"><span></span>사이트별 누적</label>
												</a>
											</li>
<%--											<li>--%>
<%--												<a href="#" data-value="option2" tabindex="-1">--%>
<%--													<input type="radio" id="summation2" name="summation" value="siteAverage">--%>
<%--													<label for="summation2"><span></span>사이트별 평균</label>--%>
<%--												</a>--%>
<%--											</li>--%>
											<li>
												<a href="#" data-value="option3" tabindex="-1">
													<input type="radio" id="summation3" name="summation" value="deviceAccrue">
													<label for="summation3"><span></span>설비별 누적</label>
												</a>
											</li>
<%--											<li>--%>
<%--												<a href="#" data-value="option4" tabindex="-1">--%>
<%--													<input type="radio" id="summation4" name="summation" value="deviceAverage">--%>
<%--													<label for="summation4"><span></span>설비별 평균</label>--%>
<%--												</a>--%>
<%--											</li>--%>
											<li>
												<a href="#" data-value="option5" tabindex="-1">
													<input type="radio" id="summation5" name="summation" value="" checked>
													<label for="summation5"><span></span>선택안함</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>

						<br>

						<!-- 시계열 분석 -->
						<div class="tag_bx clear" id="analyzeTag1">
							<div class="fl">
								<span class="tx_tit">y-좌</span>
							</div>
							<div class="fl">
								<span class="tx_tit">y-우</span>
							</div>
						</div>

						<!-- 상관 분석 -->
						<div class="tag_bx clear" id="analyzeTag2">
							<div class="fl">
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

		<div class="row usage_chart_table" id="datatable">
			<div class="col-lg-12">
				<div class="indiv">
					<table class="his_tbl">
						<thead>
							<tr>
								<th data-column="siteNm">사업소</th>
								<th data-column="dname">설비명</th>
								<th data-column="timestamp"><button class="btn_align">시간</button></th>
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