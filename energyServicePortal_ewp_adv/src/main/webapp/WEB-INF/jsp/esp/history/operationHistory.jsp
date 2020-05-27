<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	let today = new Date();
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');

	const apiURL = 'http://iderms.enertalk.com:8443';
	const configDevice = '/config/orgs/' + oid;
	const statusSummary = '/status/summary';
	const configDeviceData = {
		includeUsers: false,
		includSites: false,
		includeDevices: true,
		includeBtus: false
	};

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
		setInitList('siteULList'); //사업소 리스트
		setInitList('typeULList'); //디바이스 리스트
		siteMakeList();

		setInitList('columnLi'); //디바이스 유형 리스트
		setInitList('columnLi2'); //디바이스 유형
		setInitList('columnLi3'); //디바이스 유형

		setInitList('chartDidUl'); //차트 디바이스 선택
		setInitList('chartDidUl2'); //차트 디바이스 선택
		setInitList('chartDidUl3'); //차트 디바이스 선택

		$('.fromDate, .toDate').datepicker('setDate', new Date()); //기본값 세팅

		//검색
		$('#search').on('click', function () {
			searchGrid();
		});

		$(':radio[name="analyze"]').on('change', function () {
			$('[id^="analyzeDiv"]').hide();
			$('[id^="analyzeTag"]').hide();
			if ($(this).attr('id') == 'analyze1') {
				$('#analyzeDiv1').show();
				$('#analyzeTag1').show();
				$('#summation').show();
			} else {
				$('#analyzeDiv2').show();
				$('#analyzeTag2').show();
				$('#summation').hide();
			}

			if ($('#hchart2').highcharts()) {
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

				// tableGrid();
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

		$('#chartAdd').on('click', function () {

			if ($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
				if ($('#chartDid button').data('value') == '') {
					alert('추가 하시려는 설비명을 선택 해 주세요.');
					return false;
				}

				if ($(':radio[name="column"]').is(':checked') == false) {
					alert('추가 하시려는 항목을 선택 해 주세요.');
					return false;
				}

				if ($(':radio[name="rdValue"]').is(':checked') == false) {
					alert('선택 해 주세요.');
					return false;
				}

				//기존항목이 존재한다면 중복체크
				if ($('#way').find('button').data('value') == 'l') {
					if ($('#analyzeTag1 .tx_tit:eq(0) span').length > 0) {
						if (duplicateTag(0)) {
							return false;
						}
					}
				} else if ($('#way').find('button').data('value') == 'r') {
					if ($('#analyzeTag1 .tx_tit:eq(1) span').length > 0) {
						if (duplicateTag(1)) {
							return false;
						}
					}
				} else {
					alert('선택 해 주세요.');
					return false;
				}

				let $txt = $('#chartDid button').text() + ': ' + $(':radio[name="column"]:checked').next('label').text() + $(':radio[name="rdValue"]:checked').next('label').text()
				let $span = $('<span>').addClass('tag_type').append($txt).append('<button>')
				$span.data('deviceId', $('#chartDid button').data('value'));
				$span.data('sid', $('#chartDid button').data('sid'));
				$span.data('type', $('#chartDid button').data('type'));
				$span.data('key', $(':radio[name="column"]:checked').val())
				$span.data('key2', $(':radio[name="rdValue"]:checked').val());
				$span.find('button').append('닫기');

				if ($('#way').find('button').data('value') == 'l') {
					$('#analyzeTag1 .tx_tit').eq(0).append($span);
				} else {
					$('#analyzeTag1 .tx_tit').eq(1).append($span);
				}
			} else {
				if ($('#chartDid2 button').data('value') == '') {
					alert('X축에 추가 하시려는 설비명을 선택 해 주세요.');
					return false;
				}

				if ($(':radio[name="column2"]').is(':checked') == false) {
					alert('X축에 추가 하시려는 항목을 선택 해 주세요.');
					return false;
				}

				if ($(':radio[name="rdValue2"]').is(':checked') == false) {
					alert('X축에 선택 해 주세요.');
					return false;
				}

				if ($('#chartDid3 button').data('value') == '') {
					alert('Y축에 추가 하시려는 설비명을 선택 해 주세요.');
					return false;
				}

				if ($(':radio[name="column3"]').is(':checked') == false) {
					alert('Y축에 추가 하시려는 항목을 선택 해 주세요.');
					return false;
				}

				if ($(':radio[name="rdValue3"]').is(':checked') == false) {
					alert('Y축에 선택 해 주세요.');
					return false;
				}

				//기존항목이 존재한다면 중복체크
				if ($('#analyzeTag2 > div.fl > span').length > 0) {
					if (duplicateTag(2)) {
						return false;
					}
				}

				let $txt = $('#chartDid2 button').text() + ': ' + $(':radio[name="column2"]:checked').next('label').text() + $(':radio[name="rdValue2"]:checked').next('label').text();
				let $txt2 = $('#chartDid3 button').text() + ': ' + $(':radio[name="column3"]:checked').next('label').text() + $(':radio[name="rdValue3"]:checked').next('label').text();
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
		$(document).on('click', '.tag_type button', function () {
			$(this).parents('span.tag_type').remove();
		});

		$(':radio[name="summation"]').on('change', function () {
			$('#chartDraw').trigger('click');
		});

		$('#chartDraw').on('click', function () {
			let show = true;
			let chartColor = ['#b0e9e8', '#26ccc8', '#009389', '#50b5ff', '#5269ef', '#274dea'];
			let categories = new Array();
			let chartSeries = new Array();
			let summation = $(':radio[name="summation"]:checked').val();
			let stackNum = 0;

			if ($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
				let timeCategory = new Array();
				show = true;
				if ($('#analyzeTag1 span').length <= 0) {
					alert('한개이상 항목을 선택해 주세요.');
					return false;
				}

				let index = 0;
				let dupY = 1;

				$('#analyzeTag1 .tx_tit').find('span').each(function() {
					let deviceId = $(this).data('deviceId');
					let type = $(this).data('type');

					$.map(gridList, function (value, key) {
						if (type == key) {
							$.each(value, function (j, el) {
								if (el.did == deviceId) {
									timeCategory.push(new Date(el.timestamp).format('yyyy-MM-dd HH:mm'));
								}
							});
						}
					});
				});

				//시간 카테고리 합쳐서 중복 시간 제거
				$.each(timeCategory, function (i, el) {
					if ($.inArray(el, categories) === -1) categories.push(el);
				});

				categories.sort(); //시간 정렬


				$('#analyzeTag1 .tx_tit').eq(0).find('span').each(function () {
					let dataArr = new Array();

					let keyText = $(this).data('key');
					let keyText2 = $(this).data('key2');
					let deviceId = $(this).data('deviceId');
					let sid = $(this).data('sid');
					let type = $(this).data('type');

					let temp = {};
					let suffix = '';

					$.each(categories, function(i, elm) {
						$.map(gridList, function (value, key) {
							if (type == key) {
								let elmVal = 0;
								$.each(value, function (j, el) {
									if (el.did == deviceId && elm == new Date(el.timestamp).format('yyyy-MM-dd HH:mm')) {
										elmVal = parseFloat(eval('el.' + keyText2 + '.' + keyText));
									}
								});

								dataArr.push([elm, elmVal]);
							}
						});
					});


					if (dataArr.length > 0) {
						if (summation == 'siteAccrue' || summation == 'siteAverage') {
							if (chartSeries.length > 0) {
								let dupSeries = false;
								chartSeries.some(function (v, k) {
									if (v.sid == sid) {
										dupSeries = true;
										return stackNum = v.stack;
									}
								});

								if (!dupSeries) {
									stackNum++;
								}
							} else {
								stackNum++;
							}
						} else if (summation == 'deviceAccrue' || summation == 'deviceAverage') {
							if (chartSeries.length > 0) {
								let dupSeries = false;
								chartSeries.some(function (v, k) {
									if (v.dType == type) {
										dupSeries = true;
										return stackNum = v.stack;
									}
								});

								if (!dupSeries) {
									stackNum++;
								}
							} else {
								stackNum++;
							}
						} else {
							stackNum++;
						}

						dataArr.sort(function (a, b){
							return a[0] - b[0];
						});
						temp = {
							name: $(this).text().replace('닫기', ''),
							type: 'column',
							stack: stackNum,
							sid: sid,
							dType: type,
							tooltip: {
								valueSuffix: setttingSuffix(keyText)
							},
							color: chartColor[index],
							data: dataArr
						};
						index++;
					}

					chartSeries.push(temp);

					//양쪽이 동일할경우 체크
					$('#analyzeTag1 .tx_tit').eq(1).find('span').each(function () {
						let keyText_1 = $(this).data('key');
						if (keyText == keyText_1) {
							dupY = 0;
						}
					});
				});

				$('#analyzeTag1 .tx_tit').eq(1).find('span').each(function () {
					let dataArr = new Array();

					let keyText = $(this).data('key');
					let keyText2 = $(this).data('key2');
					let deviceId = $(this).data('deviceId');
					let sid = $(this).data('sid');
					let type = $(this).data('type');

					let temp = {};
					let suffix = '';
					$.each(categories, function(i, elm) {
						$.map(gridList, function (value, key) {
							if (type == key) {
								let elmVal = 0;
								$.each(value, function (j, el) {
									if (el.did == deviceId && elm == new Date(el.timestamp).format('yyyy-MM-dd HH:mm')) {
										elmVal = parseFloat(eval('el.' + keyText2 + '.' + keyText));
									}
								});

								dataArr.push([elm, elmVal]);
							}
						});
					});

					dataArr.sort(function (a, b){
						return a[0] - b[0];
					});

					if (dataArr.length > 0) {
						temp = {
							name: $(this).text().replace('닫기', ''),
							type: 'spline',
							stack: index,
							yAxis: dupY,
							sid: sid,
							dType: type,
							color: chartColor[index],
							tooltip: {
								valueSuffix: setttingSuffix(keyText)
							},
							data: dataArr
						};
						index++;
					}

					chartSeries.push(temp);
				});


			} else {
				show = false;
				if ($('#analyzeTag2 span').length <= 0) {
					alert('한개이상 항목을 선택해 주세요.');
					return false;
				}

				$('#analyzeTag2 span').each(function (index) {
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

					let suffix = '';

					let timeCategory = new Array();
					let timeCategoryX = new Array();
					let timeCategoryY = new Array();
					let typeXArray = new Array();
					let typeYArray = new Array();

					$.each(eval('gridList.' + typeX), function (j, el) {
						if (el.did == deviceIdX) {
							timeCategoryX.push(el.timestamp);
							typeXArray.push({
								time: el.timestamp,
								data: parseFloat(eval('el.' + keyText2X + '.' + keyTextX))
							});
						}
					});

					$.each(eval('gridList.' + typeY), function (j, el) {
						if (el.did == deviceIdY) {
							timeCategoryY.push(el.timestamp);
							typeYArray.push({
								time: el.timestamp,
								data: parseFloat(eval('el.' + keyText2Y + '.' + keyTextY))
							});
						}
					});

					//시간 카테고리 합쳐서 중복 시간 제거
					$.each(timeCategoryX.concat(timeCategoryY), function (i, el) {
						if ($.inArray(el, timeCategory) === -1) timeCategory.push(el);
					});

					timeCategory.sort(); //시간 정렬

					$.each(timeCategory, function (i, el) {
						let x = 0, y = 0;

						$.each(typeXArray, function (j, elx) {
							if (elx.time == el) {
								x = elx.data;
							}
						});
						$.each(typeYArray, function (k, ely) {
							if (ely.time == el) {
								y = ely.data;
							}
						});

						dataArr.push([x, y]);
					});

					chartSeries.push({
						name: seriesName,
						type: 'scatter',
						color: chartColor[index],
						tooltip: {
							valueSuffix: suffix
						},
						data: dataArr
					});
				});

				categories = new Array();
			}

			chartDraw(chartSeries, categories, show);
		});

		$('.save_btn').on('click', function (e) {
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
	const deviceProperties = function () {
		$.ajax({
			url: apiURL + '/config/view/device_properties',
			type: 'get',
			async: false,
			data: {
				version: '20200513'
			},
			success: function (result) {
				$.map(result, function (val, key) {
					let deviceName = key;
					let propList = val.properties;
					let tempTable = new Array();
					let tempFeature = new Array();

					$.map(propList, function (v, k) {
						if (v.analysis_table) {
							let tempObj = new Object();
							let unit = (v.unit != null && v.unit != '') ? '(' + v.unit + ')' : '';
							if (k == 'currentS') {
								tempObj['key'] = k;
								tempObj['value'] = v.name + unit;
							} else {
								tempObj['key'] = k;
								tempObj['value'] = v.name.kr + unit;
							}
							tempTable.push(tempObj);
						}

						if (v.analysis_feature) {
							let tempObj = new Object();
							let unit = (v.unit != null && v.unit != '') ? '(' + v.unit + ')' : '';
							if (k == 'currentS') {
								tempObj['key'] = k;
								tempObj['value'] = v.name + unit;
							} else {
								tempObj['key'] = k;
								tempObj['value'] = v.name.kr + unit;
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
	const siteMakeList = function () {
		setMakeList(siteList, 'siteULList', {'dataFunction': {}}); //list생성
	};

	//선택한 SID에 해당하는 유형의 타입을 보여준다.
	const deviceType = function () {
		$('#deviceType button').empty().append('설비유형<span class="caret"></span>');

		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			}
			)
		);

		if (siteArray.length > 0) {
			$.ajax({
				url: apiURL + configDevice,
				type: 'get',
				async: false,
				data: configDeviceData,
				success: function (result) {
					deviceList = result.devices;
					let deviceType = new Array();

					$.each(deviceList, function (i, el) {
						if ($.inArray(el.sid, siteArray) >= 0) {
							if ($.inArray(el.device_type, deviceType) === -1) {
								deviceType.push(el.device_type);
							}
						}
						;
					});

					deviceType.sort(); //정렬
					$.each(deviceType, function (i, el) {
						deviceType[i] = {
							name: deviceTemplate[el],
							type: el
						}
					})

					setMakeList(deviceType, 'typeULList', {'dataFunction': {}});
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

		const typeArray = $.makeArray(
			$(':checkbox[name="type"]:checked').map(
				function () {
					return $(this).val();
				}
			)
		);

		if (typeArray.length > 0 && deviceList.length > 0) {
			$('#devices div.sec_li_bx').remove();

			//선택된 사이트를 기준으로 한다.
			$(':checkbox[name="site"]:checked').each(function () {
				let siteNm = $(this).next().text()
					, siteId = $(this).val()
					, siteGrp = $('<div>').addClass('sec_li_bx');

				siteGrp.append('<p>');
				siteGrp.find('p').addClass('tx_li_tit').text(siteNm);
				siteGrp.append('<ul>');

				$.each(deviceList, function (i, el) {
					if (el.sid == siteId) {
						$.each(typeArray, function (k, elm) {
							if (elm == el.device_type) {
								let str = `<li>
											<a href="javascript:void(0);" data-value="${'${el.did}'}" tabindex="-1">
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

	const setTypeList = function (obj) {
		let type = $('#' + obj + ' button').data('type');
		let idNum = '';
		if (obj.length > 8) {
			idNum = obj.slice(-1);
		}

		$('#'+'columnLi' + idNum).prev().html($('#'+'columnLi' + idNum).prev().data('name') + '<span class="caret"></span>');
		$.map(featureProperties, function (value, key) {
			if (type == key) {
				setMakeList(value, 'columnLi' + idNum, {"dataFunction": {"INDEX": getNumberIndex}}); //list생성
			}
		});
	}

	//선택된 디바이스 유형별로 테이블을 생성한다.
	const makeTableTemplate = function () {
		$('#datatable').empty();

		$(':checkbox[name="type"]:checked').each(function () {
			let chkVal = $(this).val();
			let targetTable = document.createElement('table');
			let thead = targetTable.createTHead();
			let tbody = targetTable.createTBody();
			let hRow = thead.insertRow();
			let bRow = tbody.insertRow();

			targetTable.setAttribute('class', 'his_tbl');
			tbody.setAttribute('id', chkVal + '_Table');

			$.map(tableProperties, function (value, key) {
				if (chkVal == key) {
					$.each(value, function (idx, valObj) {
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
					setInitList(chkVal + '_Table');
				}
			});
		});
	};

	const searchGrid = function () {

		if ($(':checkbox[name="site"]:checked').length == 0) {
			alert('사이트를 한개이상 선택해 주세요.');
			return false;
		}

		if ($(':checkbox[name="type"]:checked').length == 0) {
			alert('설비타입을 한개이상 선택해 주세요.');
			return false;
		}

		if ($(':checkbox[name="device"]:checked').length == 0) {
			alert('설비를 한개이상 선택해 주세요.');
			return false;
		}

		let siteArray = new Array();
		let deviceArray = new Array();

		$(':checkbox[name="site"]:checked').each(function () {
			siteArray.push($(this).val());
		});

		$(':checkbox[name="device"]:checked').each(function () {
			deviceArray.push($(this).val());
		});

		makeTableTemplate();

		$('[id^="chartDid"]').each(function() {
			$(this).find('button').html($(this).find('button').data('name') + '<span class="caret"></span>').data('value', '');
		});

		$('#way button').html($('#way button').data('name') + '<span class="caret"></span>');

		let statusSummaryData = {
			sids: siteArray.join(','),
			dids: deviceArray.join(','),
			//deviceType: '',
			startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
			endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
			interval: $('#interval').find('button').data('value'),
			formId: 'v2'
		}

		$.ajax({
			url: apiURL + statusSummary,
			type: 'get',
			async: false,
			data: statusSummaryData,
			success: function (result) {
				let chart = $('#hchart2').highcharts();
				if (chart) {
					chart.destroy();

					$('[id^=columnLi]').empty().prev().html('선택 <span class="caret"></span>');
				}

				$.map(result, function (value, key) {
					if ($('#' + key + '_Table').length > 0) {
						$.each(value, function (idx, valObj) {
							value[idx].localtime = String(valObj.basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
							value[idx].timestamp = new Date(value[idx].localtime).getTime();
							$.map(valObj.mean, function (v, k) {
								valObj[k] = numberComma(v.toFixed(2));
							});
						});

						setMakeList(value, key + '_Table', {'dataFunction': {}}); //list생성

						$('#' + key + '_Table').find('td').each(function () {
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

	const setChartDid = function () {
		let chartDid = new Array();

		$(':checkbox[name="device"]:checked').each(function () {
			let siteNm = $(this).parents('div.sec_li_bx').find('p.tx_li_tit').text().trim(); //사이트명
			let deviceNm = $(this).next().text().trim();

			chartDid.push({
				val: $(this).val(),
				sid: $(this).data('sid'),
				type: $(this).data('type'),
				siteDevice: siteNm + '_' + deviceNm
			});
		});

		setMakeList(chartDid, 'chartDidUl', {'dataFunction': {}});
		setMakeList(chartDid, 'chartDidUl2', {'dataFunction': {}});
		setMakeList(chartDid, 'chartDidUl3', {'dataFunction': {}});
	}

	//그래프 태그 중복체크
	const duplicateTag = function (i) {
		let dup = false;
		if (i == 2) {
			$('#analyzeTag2 span').each(function () {
				let spanDidX = $(this).data('deviceIdX');
				let spanColumnX = $(this).data('keyX');
				let spanRdValX = $(this).data('key2X');

				let spanDidY = $(this).data('deviceIdY');
				let spanColumnY = $(this).data('keyY');
				let spanRdValY = $(this).data('key2Y');

				if ($('#chartDid2 button').data('value') == spanDidX && $(':radio[name="column2"]:checked').val() == spanColumnX && $(':radio[name="rdValue2"]:checked').val() == spanRdValX
					&& $('#chartDid3 button').data('value') == spanDidY && $(':radio[name="column3"]:checked').val() == spanColumnY && $(':radio[name="rdValue3"]:checked').val() == spanRdValY
				) {
					alert('중복된 항목이 존재합니다.');
					dup = true;
				}
			});
		} else {
			$('#analyzeTag1 .tx_tit:eq(' + i + ') span').each(function () {
				let spanDid = $(this).data('deviceId');
				let spanColumn = $(this).data('key');
				let spanRdVal = $(this).data('key2');

				if ($('#chartDid button').data('value') == spanDid
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

	const chartDraw = function (chartSeries, categories, show) {
		let chart = $('#hchart2').highcharts();

		if (chart) {
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
					align: 'center',
					style: {
						color: 'var(--color3)',
						fontSize: '8px'
					},
					enabled: show
				},
				categories: categories,
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
					if ($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
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


	const rtnDropdown = function ($selectId) {
		if ($selectId == 'siteList') {
			deviceType();
		} else if ($selectId == 'deviceType') {
			device();
		} else if ($selectId.match('chartDid')) {
			setTypeList($selectId);
		}
	}

	function dateFormat(val) {
		let date = '';
		let interval = $('#interval button').data('value');
		if(val != undefined) {
			if(interval == '1min' || interval == '15min' || interval == 'hour') {
				date = new Date(val).format('yyyy-MM-dd HH:mm:ss');
			} else if(interval == 'day' || interval == 'week') {
				date = new Date(val).format('yyyy-MM-dd');
			} else {
				date = new Date(val).format('yyyy-MM-dd');
			}
		}
		return date;
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
					<div class="sa_select fl">
						<div class="dropdown" id="siteList">
							<button type="button" class="btn btn-primary dropdown-toggle w1" data-toggle="dropdown"
							        data-name="사업소">
								선택해주세요.<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu" id="siteULList">
								<li data-value="[sid]">
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
										<label for="site_[INDEX]"><span></span>[name]</label>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="fl">
						<span class="tx_tit">설비 타입</span>
						<div class="sa_select">
							<div class="dropdown" id="deviceType">
								<button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown"
								        data-name="설비유형">
									설비유형<span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu" id="typeULList">
									<li data-value="[type]">
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="type_[INDEX]" value="[type]" name="type">
											<label for="type_[INDEX]"><span></span>[name]</label>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="sa_select">
							<div class="dropdown" id="devices">
								<button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown"
								        data-name="복수 선택">
									복수 선택<span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu">
									<li class="dropdown_cov clear">
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
					<div class="fl dateField">
						<span class="tx_tit">기간 설정</span>
						<div class="sel_calendar">
							<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value=""
							       autocomplete="off">
							<em>-</em>
							<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off">
						</div>
					</div>

					<div class="fl">
						<span>조회주기</span>
						<div class="sa_select">
							<div class="dropdown" id="interval">
								<button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown"
								        data-value="15min" data-name="15분">
									15분<span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li data-value="1min"><a href="javascript:void(0);">1분</a></li>
									<li data-value="15min"><a href="javascript:void(0);">15분</a></li>
									<li data-value="hour"><a href="javascript:void(0);">1시간</a></li>
									<li data-value="day"><a href="javascript:void(0);">1일</a></li>
									<li data-value="week"><a href="javascript:void(0);">1주</a></li>
									<li data-value="month"><a href="javascript:void(0);">1월</a></li>
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
							<a href="javascript:void(0);" class="btn_type02 fr">분석 조건 저장</a>
						</div>
						<!-- 기본 항목 -->
						<div class="clear">
							<div class="fl" id="analyzeDiv1">
								<div class="sa_select">
									<div class="dropdown" id="chartDid">
										<button class="btn btn-primary dropdown-toggle w2" type="button"
										        data-toggle="dropdown" style="width:220px;" data-name="설비명">
											설비명<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" id="chartDidUl">
											<li data-value="[val]" data-sid="[sid]" data-type="[type]">
												<a href="javascript:void(0);">
													[siteDevice]
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w2" type="button"
										        data-toggle="dropdown" data-name="선택">
											선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu rdo_type" role="menu" id="columnLi">
											<li data-value="[key]">
												<a href="javascript:void(0);" tabindex="-1">
													<input type="radio" id="column[INDEX]" name="column" value="[key]">
													<label for="column[INDEX]"><span></span>[value]</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle w4" type="button"
										        data-toggle="dropdown" data-vlue="mean" data-name="평균">
											평균 <span class="caret"></span>
										</button>
										<ul class="dropdown-menu rdo_type " role="menu">
											<li data-value="max">
												<a href="javascript:void(0);" tabindex="-1">
													<input type="radio" id="rdValue1" name="rdValue" value="max">
													<label for="rdValue1"><span></span>최대</label>
												</a>
											</li>
											<li data-value="min">
												<a href="javascript:void(0);" tabindex="-1">
													<input type="radio" id="rdValue2" name="rdValue" value="min">
													<label for="rdValue2"><span></span>최소</label>
												</a>
											</li>
											<li data-value="avg">
												<a href="javascript:void(0);" tabindex="-1">
													<input type="radio" id="rdValue3" name="rdValue" value="mean"
													       checked>
													<label for="rdValue3"><span></span>평균</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div class="sa_select">
									<div class="dropdown" id="way">
										<button class="btn btn-primary dropdown-toggle w5" type="button"
										        data-toggle="dropdown" data-name="선택">
											선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu">
											<li data-value="l"><a href="javascript:void(0);">y-좌</a></li>
											<li data-value="r"><a href="javascript:void(0);">y-우</a></li>
										</ul>
									</div>
								</div>
							</div>
							<div id="analyzeDiv2" style="display:none;" class="fl">
								<div class="fl">
									<span class="tx_tit">x축</span>
									<div class="sa_select">
										<div class="dropdown" id="chartDid2">
											<button class="btn btn-primary dropdown-toggle w2" type="button"
											        data-toggle="dropdown" style="width:220px;" data-name="설비명">
												설비명<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" id="chartDidUl2">
												<li data-value="[val]" data-sid="[sid]" data-type="[type]">
													<a href="javascript:void(0);">
														[siteDevice]
													</a>
												</li>
											</ul>
										</div>
									</div>
									<div class="sa_select">
										<div class="dropdown" id="columnDrop2">
											<button class="btn btn-primary dropdown-toggle w2" type="button"
											        data-toggle="dropdown" data-name="선택">
												선택<span class="caret"></span>
											</button>
											<ul class="dropdown-menu chk_type" role="menu"
											    id="columnLi2">
												<li data-value="[key]">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="radio" id="column02_[INDEX]" name="column2"
														       value="[key]">
														<label for="column02_[INDEX]"><span></span>[value]</label>
													</a>
												</li>
											</ul>
										</div>
									</div>
									<div class="sa_select">
										<div class="dropdown">
											<button class="btn btn-primary dropdown-toggle w4" type="button"
											        data-toggle="dropdown" data-value="mean" data-name="평균">
												평균<span class="caret"></span>
											</button>
											<ul class="dropdown-menu rdo_type " role="menu">
												<li data-value="max">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="radio" id="rdValue2_01" name="rdValue2"
														       value="max">
														<label for="rdValue2_01"><span></span>최대</label>
													</a>
												</li>
												<li data-value="min">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="radio" id="rdValue2_02" name="rdValue2"
														       value="min">
														<label for="rdValue2_02"><span></span>최소</label>
													</a>
												</li>
												<li data-value="mean">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="radio" id="rdValue2_03" name="rdValue2"
														       value="mean" checked>
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
										<div class="dropdown" id="chartDid3">
											<button class="btn btn-primary dropdown-toggle w2" type="button"
											        data-toggle="dropdown" style="width:220px;" data-name="설비명">
												설비명<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" id="chartDidUl3">
												<li data-value="[val]" data-sid="[sid]" data-type="[type]">
													<a href="javascript:void(0);">
														[siteDevice]
													</a>
												</li>
											</ul>
										</div>
									</div>
									<div class="sa_select">
										<div class="dropdown" id="columnDrop3">
											<button class="btn btn-primary dropdown-toggle w2" type="button"
											        data-toggle="dropdown" data-name="선택">
												선택<span class="caret"></span>
											</button>
											<ul class="dropdown-menu chk_type" role="menu"
											    id="columnLi3">
												<li>
													<a href="javascript:void(0);" data-value="[key]" tabindex="-1">
														<input type="radio" id="column03_[INDEX]" name="column3"
														       value="[key]">
														<label for="column03_[INDEX]"><span></span>[value]</label>
													</a>
												</li>
											</ul>
										</div>
									</div>
									<div class="sa_select">
										<div class="dropdown">
											<button class="btn btn-primary dropdown-toggle w4" type="button"
											        data-toggle="dropdown" data-value="mean" data-name="평균">
												평균<span class="caret"></span>
											</button>
											<ul class="dropdown-menu rdo_type" role="menu">
												<li data-value="max">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="radio" id="rdValue3_1" name="rdValue3" value="max">
														<label for="rdValue3_1"><span></span>최대</label>
													</a>
												</li>
												<li data-value="min">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="radio" id="rdValue3_2" name="rdValue3" value="min">
														<label for="rdValue3_2"><span></span>최소</label>
													</a>
												</li>
												<li data-value="mean">
													<a href="javascript:void(0);" tabindex="-1">
														<input type="radio" id="rdValue3_3" name="rdValue3" value="mean"
														       checked>
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

								<div class="sa_select">
									<div class="dropdown" id="summation">
										<button class="btn btn-primary dropdown-toggle w6" type="button"
										        data-toggle="dropdown" data-value="siteAccrue">
											선택안함<span class="caret"></span>
										</button>
										<ul class="dropdown-menu rdo_type">
											<li>
												<a href="javascript:void(0);" data-value="option1" tabindex="-1">
													<input type="radio" id="summation1" name="summation"
													       value="siteAccrue">
													<label for="summation1"><span></span>사이트별 누적</label>
												</a>
											</li>
											<%--											<li>--%>
											<%--												<a href="javascript:void(0);" data-value="option2" tabindex="-1">--%>
											<%--													<input type="radio" id="summation2" name="summation" value="siteAverage">--%>
											<%--													<label for="summation2"><span></span>사이트별 평균</label>--%>
											<%--												</a>--%>
											<%--											</li>--%>
											<li>
												<a href="javascript:void(0);" data-value="option3" tabindex="-1">
													<input type="radio" id="summation3" name="summation"
													       value="deviceAccrue">
													<label for="summation3"><span></span>설비별 누적</label>
												</a>
											</li>
											<%--											<li>--%>
											<%--												<a href="javascript:void(0);" data-value="option4" tabindex="-1">--%>
											<%--													<input type="radio" id="summation4" name="summation" value="deviceAverage">--%>
											<%--													<label for="summation4"><span></span>설비별 평균</label>--%>
											<%--												</a>--%>
											<%--											</li>--%>
											<li>
												<a href="javascript:void(0);" data-value="option5" tabindex="-1">
													<input type="radio" id="summation5" name="summation" value=""
													       checked>
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
		</div>
	</div>
</div>