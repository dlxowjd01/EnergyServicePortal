<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let today = new Date();
	const searchDid = '<c:out value="${param.did}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');

	const configDevice = '/config/orgs/' + oid;
	const statusSummary = '/status/summary';
	const configDeviceData = {
		includeUsers: false,
		includSites: false,
		includeDevices: true,
		includeBtus: false
	};

	let deviceList;
	let gridList;

	$(function () {
		$('.fromDate, .toDate').datepicker('setDate', new Date()); //기본값 세팅

		setInitList('siteULList'); //사업소 리스트
		setInitList('typeULList'); //디바이스 리스트
		siteMakeList();

		setInitList('columnLi'); //디바이스 유형 리스트
		setInitList('columnLi2'); //디바이스 유형
		setInitList('columnLi3'); //디바이스 유형

		setInitList('chartDidUl'); //차트 디바이스 선택
		setInitList('chartDidUl2'); //차트 디바이스 선택
		setInitList('chartDidUl3'); //차트 디바이스 선택

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
		$('.history-table thead th').on('click', function (e) {
			e.preventDefault();
			var idx = $('.history-table thead th').index($(this)),
				order = $(this).data('order'),
				column = $(this).data('column');
			if (idx > 1) {
				$('.history-table thead th button').removeClass('up').removeClass('down');
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
		$('#devices button.btn-type03').on('click', function (e) {
			let idx = $('#devices button.btn-type03').index($(this));

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
					if ($('#analyzeTag1 .tx-tit:eq(0) span').length > 0) {
						if (duplicateTag(0)) {
							return false;
						}
					}
				} else if ($('#way').find('button').data('value') == 'r') {
					if ($('#analyzeTag1 .tx-tit:eq(1) span').length > 0) {
						if (duplicateTag(1)) {
							return false;
						}
					}
				} else {
					alert('선택 해 주세요.');
					return false;
				}

				let $txt = $('#chartDid button').text() + ': ' + $(':radio[name="column"]:checked').next('label').text() + $(':radio[name="rdValue"]:checked').next('label').text()
				let $span = $('<span>').addClass('tag-type').append($txt).append('<button>')
				$span.data('deviceId', $('#chartDid button').data('value'));
				$span.data('sid', $('#chartDid button').data('sid'));
				$span.data('type', $('#chartDid button').data('type'));
				$span.data('key', $(':radio[name="column"]:checked').val())
				$span.data('key2', $(':radio[name="rdValue"]:checked').val());
				$span.find('button').html("&times;");

				if ($('#way').find('button').data('value') == 'l') {
					$('#analyzeTag1 .tx-tit').eq(0).append($span);
				} else {
					$('#analyzeTag1 .tx-tit').eq(1).append($span);
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
				let $span = $('<span>').addClass('tag-type').append($txt + '/' + $txt2).append('<button>')
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
		$(document).on('click', '.tag-type button', function () {
			$(this).parents('span.tag-type').remove();
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

				$('#analyzeTag1 .tx-tit').find('span').each(function () {
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

				$('#analyzeTag1 .tx-tit').eq(0).find('span').each(function () {
					let dataArr = new Array();

					let keyText = $(this).data('key');
					let keyText2 = $(this).data('key2');
					let deviceId = $(this).data('deviceId');
					let sid = $(this).data('sid');
					let type = $(this).data('type');

					let temp = {};
					let suffix = '';

					$.each(categories, function (i, elm) {
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

						dataArr.sort(function (a, b) {
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
					$('#analyzeTag1 .tx-tit').eq(1).find('span').each(function () {
						let keyText_1 = $(this).data('key');
						if (keyText == keyText_1) {
							dupY = 0;
						}
					});
				});

				$('#analyzeTag1 .tx-tit').eq(1).find('span').each(function () {
					let dataArr = new Array();

					let keyText = $(this).data('key');
					let keyText2 = $(this).data('key2');
					let deviceId = $(this).data('deviceId');
					let sid = $(this).data('sid');
					let type = $(this).data('type');

					let temp = {};
					let suffix = '';
					$.each(categories, function (i, elm) {
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

					dataArr.sort(function (a, b) {
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

				chartDraw(chartSeries, categories, show);
			} else {
				show = true;
				categories = new Array();
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
						let x = 0,
							y = 0;

						$.each(typeXArray, function (j, elx) {
							if (elx.time == el) {
								x = parseFloat(elx.data.toFixed(2));
							}
						});
						$.each(typeYArray, function (k, ely) {
							if (ely.time == el) {
								y = parseFloat(ely.data.toFixed(2));
							}
						});

						dataArr.push([x, y]);
						categories.push(parseFloat(x.toFixed(2)));
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
				chartDraw(chartSeries, null, show);
			}
		});

		$('.btn-save').on('click', function (e) {
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

		window.onload = function() {
			if (!isEmpty(searchDid)) {
				siteList.forEach(function(site) {
					let devices = site.devices;
					if (!isEmpty(devices)) {
						devices.forEach(function(device) {
							if(device.did == searchDid) {
								let choiceSid = device.sid,
									deviceTp = device.device_type;
								$(':checkbox[name="site"]').each(function() {
									if($(this).val() == choiceSid) {
										$(this).prop('checked', true);
										displayDropdown($('#siteList'));
										deviceType(deviceTp);
									}
								});
							}
						});
					}
				});
			}
		}
	});

	const getNumberIndex = function (index) {
		return index + 1;
	}

	let deviceTemplate = new Object();
	let tableProperties = new Object();
	let featureProperties = new Object();
	const deviceProperties = function () {
		$.ajax({
			url: apiHost + '/config/view/device_properties',
			type: 'get',
			async: false,
			data: {},
			success: function (result) {
				$.map(result, function (val, key) {
					let deviceName = key;
					let propList = val.properties;
					let tempTable = new Array();
					let tempFeature = new Array();
					let devicePropName = (langStatus == 'KO') ? val.name.kr : val.name.en;
					let siteLocaleName = (langStatus == 'KO') ? '사이트명' : 'siteName';

					deviceTemplate[deviceName] = devicePropName;


					tempTable.push({
						key: 'siteName',
						value: siteLocaleName
					});

					$.map(propList, function (v, k) {
						if (v.analysis_table) {
							let tempObj = new Object();
							let unit = (v.unit != null && v.unit != '') ? '(' + v.unit + ')' : '';
							let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;
							tempObj['key'] = k;
							tempObj['value'] = propName + unit;
							tempTable.push(tempObj);
						}

						if (v.analysis_feature) {
							let tempObj = new Object();
							let unit = (v.unit != null && v.unit != '') ? '(' + v.unit + ')' : '';
							let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;
							tempObj['key'] = k;
							tempObj['value'] = propName + unit;
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
		setMakeList(siteList, 'siteULList', {'dataFunction': {}});
	};

	//선택한 SID에 해당하는 유형의 타입을 보여준다.
	const deviceType = function (deviceTp) {
		$('#deviceType button').empty().append('설비유형<span class="caret"></span>');

		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		if (siteArray.length > 0) {
			$.ajax({
				url: apiHost + configDevice,
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
					});

					deviceType.sort(); //정렬
					$.each(deviceType, function (i, el) {
						deviceType[i] = {
							name: deviceTemplate[el],
							type: el
						}
					})

					setMakeList(deviceType, 'typeULList', {'dataFunction': {}});

					if (!isEmpty(deviceTp)) {
						$(':checkbox[name="type"]').each(function() {
							if($(this).val() == deviceTp) {
								$(this).prop('checked', true);
								displayDropdown($('#deviceType'));
								device();
							}
						});
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
		$('#devices .dropdown-toggle').text().replace(/<[^>]+>/g, '복수 선택');

		const typeArray = $.makeArray(
			$(':checkbox[name="type"]:checked').map(
				function () {
					return $(this).val();
				}
			)
		);

		if (typeArray.length > 0 && deviceList.length > 0) {
			$('#devices .dropdown-cov').empty();

			//선택된 사이트를 기준으로 한다.
			$(':checkbox[name="site"]:checked').each(function () {
				let siteNm = $(this).next().text(),
					siteId = $(this).val(),
					siteGrp = $('<li>').addClass('sec-li-box');

				siteGrp.append('<p>');
				siteGrp.find('p').addClass('tx-li-title').text(siteNm);
				siteGrp.append('<ul>');

				$.each(deviceList, function (i, el) {
					if (el.sid == siteId) {
						$.each(typeArray, function (k, elm) {
							if (elm == el.device_type) {
								let str = `<li>
								<a href="javascript:void(0);" data-value="${'${el.did}'}" tabindex="-1">
									<input type="checkbox" id="device_${'${el.did}'}" name="device" value="${'${el.did}'}" data-sid="${'${el.sid}'}" data-type="${'${el.device_type}'}">
									<label for="device_${'${el.did}'}">${'${el.name}'}</label>
								</a>
							</li>`
								siteGrp.find('ul').append(str);
							}
						});
					}
				});

				$('#devices .dropdown-cov').prepend(siteGrp);
			});
		}

		if (!isEmpty(searchDid)) {
			$(':checkbox[name="device"]').each(function() {
				if($(this).val() == searchDid) {
					$(this).prop('checked', true);
					displayDropdown($('#device'));
					$('#interval button').html('15분 <span class="caret"></span>').data('value', '15min');
					searchGrid();
				}
			});
		}
	}

	const setTypeList = function (obj) {
		let type = $('#' + obj + ' button').data('type');
		let idNum = '';
		if (obj.length > 8) {
			idNum = obj.slice(-1);
		}

		$('#' + 'columnLi' + idNum).prev().html($('#' + 'columnLi' + idNum).prev().data('name') + '<span class="caret"></span>');
		$.map(featureProperties, function (value, key) {
			if (type == key) {
				setMakeList(value, 'columnLi' + idNum, {
					"dataFunction": {
						"INDEX": getNumberIndex
					}
				}); //list생성
			}
		});
	}

	//선택된 디바이스 유형별로 테이블을 생성한다.
	const makeTableTemplateDevice = function () {
		$('#datatable').empty();

		$(':checkbox[name="type"]:checked').each(function () {
			let chkVal = $(this).val();
			let targetTable = document.createElement('table');
			let thead = targetTable.createTHead();
			let tbody = targetTable.createTBody();
			let hRow = thead.insertRow();
			let bRow = tbody.insertRow();

			targetTable.setAttribute('class', 'history-table');
			tbody.setAttribute('id', chkVal + '_Table');

			$.map(tableProperties, function (value, key) {
				if (chkVal == key) {
					$.each(value, function (idx, valObj) {
						let hCell = document.createElement("TH");
						hCell.innerHTML = valObj.value;

						if (idx == 0) { hCell.setAttribute('class', 'hidden'); }
						hRow.appendChild(hCell);

						let bCell = bRow.insertCell();
						if (idx == 0) { bCell.setAttribute('class', 'hidden'); }
						if (valObj.key == 'did') {
							bCell.innerHTML = '[dname]';
						} else {
							bCell.innerHTML = '[' + valObj.key + ']';
						}

					});
					$('#datatable').append(targetTable);
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

		makeTableTemplateDevice();

		$('[id^="chartDid"]').each(function () {
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
			url: apiHost + statusSummary,
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

							const did = value[idx].did;
							siteList.forEach(site => {
								const devices = site.devices,
									siteName = site.name;
								if (!isEmpty(devices)) {
									devices.forEach(device => {
										if (device.did === did) {
											value[idx]['siteName'] = siteName;
										}
									});
								}
							});

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
			let siteNm = $(this).parents('li.sec-li-box').find('p.tx-li-title').text().trim(); //사이트명
			let deviceNm = $(this).next().text().trim();

			chartDid.push({
				val: $(this).val(),
				sid: $(this).data('sid'),
				type: $(this).data('type'),
				siteDevice: siteNm + '_' + deviceNm
			});
		});

		setMakeList(chartDid, 'chartDidUl', {
			'dataFunction': {}
		});
		setMakeList(chartDid, 'chartDidUl2', {
			'dataFunction': {}
		});
		setMakeList(chartDid, 'chartDidUl3', {
			'dataFunction': {}
		});
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

				if ($('#chartDid2 button').data('value') == spanDidX && $(':radio[name="column2"]:checked').val() == spanColumnX && $(':radio[name="rdValue2"]:checked').val() == spanRdValX &&
					$('#chartDid3 button').data('value') == spanDidY && $(':radio[name="column3"]:checked').val() == spanColumnY && $(':radio[name="rdValue3"]:checked').val() == spanRdValY
				) {
					alert('중복된 항목이 존재합니다.');
					dup = true;
				}
			});
		} else {
			$('#analyzeTag1 .tx-tit:eq(' + i + ') span').each(function () {
				let spanDid = $(this).data('deviceId');
				let spanColumn = $(this).data('key');
				let spanRdVal = $(this).data('key2');

				if ($('#chartDid button').data('value') == spanDid &&
					$(':radio[name="column"]:checked').val() == spanColumn &&
					$(':radio[name="rdValue"]:checked').val() == spanRdVal
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
					enabled: false
				}
			},
			title: {
				text: null
			},
			xAxis: {
				labels: {
					align: 'center',
					style: {
						color: 'var(--white)',
						fontSize: '8px'
					},
					enabled: show,
				},
				categories: categories,
				tickInterval: 1,
				title: {
					text: null
				},
				crosshair: true
			},
			yAxis: [{
				gridLineWidth: 1,
				title: {
					text: '',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 5,
					style: {
						color: 'var(--white)',
						fontSize: '10px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -10,
					style: {
						color: 'var(--white)',
						fontSize: '10px'
					}
				}
			}, {
				gridLineWidth: 1,
				title: {
					text: '',
					align: 'low',
					rotation: 0,
					y: 25,
					x: -5,
					style: {
						color: 'var(--white)',
						fontSize: '10px'
					}
				},
				labels: {
					overflow: 'justify',
					x: 10,
					style: {
						color: 'var(--white)',
						fontSize: '10px'
					}
				},
				alignTicks: false,
				opposite: true
			}],
			legend: {
				enabled: true,
				align: 'right',
				verticalAlign: 'top',
				x: 10,
				itemStyle: {
					color: 'var(--white)',
					fontSize: '14px',
					fontWeight: 400
				},
				itemHoverStyle: {
					color: ''
				},
				symbolPadding: 3,
				symbolHeight: 8
			},
			/* 툴팁 */
			tooltip: {
				formatter: function () {
					if ($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
						return this.points.reduce(function (s, point) {
							return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + Number(point.y).toFixed(2) + point.series.userOptions.tooltip.valueSuffix;
						}, '<b>' + new Date(this.x).format('yyyy.MM.dd HH:mm:ss') + '</b>');
					} else {
						let tooltip = this.series.name + '<br/>' +
							'X:' + (this.x).toFixed(2) + '<br/> Y:' + (this.y).toFixed(2);
						return tooltip;
					}
				},
				shared: true,
				borderColor: 'none',
				backgroundColor: 'var(--bg-color)',
				padding: 16,
				style: {
					color: 'var(--white87)',
					lineHeight: '18px'
				}
			},
			plotOptions: {
				series: {
					label: {
						connectorAllowed: false
					},
					borderWidth: 0
				},
				column: {
					stacking: 'normal'
				},
				line: {
					marker: {
						enabled: false
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
		if (val != undefined) {
			if (interval == '1min' || interval == '15min' || interval == 'hour') {
				date = new Date(val).format('yyyy-MM-dd HH:mm:ss');
			} else if (interval == 'day' || interval == 'week') {
				date = new Date(val).format('yyyy-MM-dd');
			} else {
				date = new Date(val).format('yyyy-MM-dd');
			}
		}
		return date;
	}
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">상태 이력</h1>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<form id="operationSearchForm">
			<div class="dropdown sa-select" id="siteList">
				<button type="button" class="dropdown-toggle w1" data-toggle="dropdown" data-name="사업소 선택">사업소 선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk-type" role="menu" id="siteULList">
					<li data-value="[sid]">
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
							<label for="site_[INDEX]">[name]</label>
						</a>
					</li>
				</ul>
			</div>

			<div id="searchDetail" class="search-expand sa-select">
				<button type="button" class="btn clear-btn" data-target="#searchDropdown" data-name="상세 검색" onclick="$('#searchDetail').toggleClass('open')">상세 검색<span class="caret"></span></button>
				<div id="searchDropdown" class="dropdown-menu search-dropdown">
					<h2 class="tx-tit"><fmt:message key="statushistory.1.devicetype" /></h2>
					<div class="flex-start">
						<div class="dropdown" id="deviceType"><!--
						--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="설비유형 선택">설비유형 선택<span class="caret"></span></button><!--
						--><ul class="dropdown-menu chk-type" role="menu" id="typeULList">
								<li data-value="[type]">
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="type_[INDEX]" value="[type]" name="type">
										<label for="type_[INDEX]">[name]</label>
									</a>
								</li>
							</ul><!--
					--></div>
						<div class="dropdown ml-16" id="devices"><!--
						--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="복수 선택"><fmt:message key="statushistory.1.multiple.select" /><span class="caret"></span></button><!--
						--><div class="dropdown-menu dropdown-menu-form chk-type"><!--
							 --><ul class="dropdown-cov clear"></ul>
								<div class="li-btn-box clear"><!--
								--><div class="fl"><!--
									--><button type="button" class="btn-type03"><fmt:message key="statushistory.1.selectall" /></button><!--
									--><button type="button" class="btn-type03"><fmt:message key="statushistory.1.clearall" /></button><!--
								--></div>
									<div class="fr"><button type="button" class="btn-type"><fmt:message key="statushistory.1.apply" /></button></div>
								</div>
							</div>
						</div>
					</div>

					<div class="flex-start2 mt20">
						<div class="sa-select">
							<h2 class="tx-tit"><fmt:message key="statushistory.1.timeframe" /></h2>
							<label for="fromDate" class="tx-tit sr-only">시작일</label>
							<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="" autocomplete="off">
						</div>
						<div class="">
							<h2 class="tx-tit"></h2>
							<label for="toDate" class="tx-tit sr-only">마지막일</label>
							<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off">
						</div>
						<div class="dropdown" id="interval">
							<h2 class="tx-tit">단위</h2>
							<button type="button" class="dropdown-toggle w3" data-toggle="dropdown" data-value="15min" data-name="15분">15분<span class="caret"></span></button>
							<ul class="dropdown-menu">
								<li data-value="1min"><a href="javascript:void(0);">1분</a></li>
								<li data-value="15min"><a href="javascript:void(0);">15분</a></li>
								<li data-value="hour"><a href="javascript:void(0);">1시간</a></li>
								<li data-value="day"><a href="javascript:void(0);">1일</a></li>
<%--								<li data-value="week"><a href="javascript:void(0);">1주</a></li>--%>
<%--								<li data-value="month"><a href="javascript:void(0);">1월</a></li>--%>
							</ul>
						</div>
					</div>
					
					<div class="btn-wrap-type05">
						<button type="button" class="btn-type03 w80" onclick="$('#searchDetail').removeClass('open')">취소</button><!--
					--><button type="button" class="btn-type w80 ml-12" onclick="$('#searchDetail').removeClass('open')">적용</button>
					</div>
				</div>
			</div>
		
			<button type="button" id="search" class="btn-type ml-6"><fmt:message key="statushistory.1.update" /></button>
			<a href="#;" class="btn-save fr">데이터저장</a>
		</form>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="indiv table-operation-wrapper">
			<div class="header-wrapper">
				<h2 class="fl sm-title"><fmt:message key="statushistory.2.selectdevice" /></h2>
<%--				<a href="javascript:void(0);" class="btn-type02 fr">분석 조건 저장</a>--%>
			</div>
			<div class="his_chart_top clear">
				<!-- 기본 항목 -->
				<div class="clear">
					<div class="fl mr-12" id="analyzeDiv1">
						<div class="sa-select pb-10">
							<div class="dropdown" id="chartDid">
								<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="설비명 선택">설비명 선택<span class="caret"></span></button>
								<ul class="dropdown-menu" id="chartDidUl"><li data-value="[val]" data-sid="[sid]" data-type="[type]"><a href="javascript:void(0);">[siteDevice]</a></li></ul>
							</div>
						</div>
						<div class="sa-select pb-10">
							<div class="dropdown">
								<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="설비속성 선택">설비속성 선택<span class="caret"></span></button>
								<ul class="dropdown-menu radio-type" role="menu" id="columnLi"><li data-value="[key]"><a href="javascript:void(0);" tabindex="-1"><input type="radio" id="column[INDEX]" name="column" value="[key]"><label for="column[INDEX]">[value]</label></a></li></ul>
							</div>
						</div>
						<div class="sa-select pb-10">
							<div class="dropdown">
								<button type="button" class="dropdown-toggle w4" data-toggle="dropdown" data-vlue="mean" data-name="평균"><fmt:message key="statushistory.2.average" /> <span class="caret"></span></button>
								<ul class="dropdown-menu radio-type" role="menu">
									<li data-value="max">
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="rdValue1" name="rdValue" value="max">
											<label for="rdValue1"><fmt:message key="statushistory.2.max" /></label>
										</a>
									</li>
									<li data-value="min">
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="rdValue2" name="rdValue" value="min">
											<label for="rdValue2"><fmt:message key="statushistory.2.min" /></label>
										</a>
									</li>
									<li data-value="avg">
										<a href="javascript:void(0);" tabindex="-1">
											<input type="radio" id="rdValue3" name="rdValue" value="mean" checked>
											<label for="rdValue3"><fmt:message key="statushistory.2.average" /></label>
										</a>
									</li>
								</ul>
							</div>
						</div>
						<div class="sa-select pb-10">
							<div class="dropdown" id="way">
								<button type="button" class="dropdown-toggle w5" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="l"><a href="javascript:void(0);"><fmt:message key="statushistory.2.y_left" /></a></li>
									<li data-value="r"><a href="javascript:void(0);"><fmt:message key="statushistory.2.y_right" /></a></li>
								</ul>
							</div>
						</div>
					</div>

					<div id="analyzeDiv2" style="display:none;">
						<div class="fl ml-12">
							<span class="tx-tit">x축</span>
							<div class="sa-select">
								<div class="dropdown" id="chartDid2">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="설비명 선택">설비명 선택<span class="caret"></span></button>
									<ul class="dropdown-menu" id="chartDidUl2">
										<li data-value="[val]" data-sid="[sid]" data-type="[type]"><a>[siteDevice]</a></li>
									</ul>
								</div>
							</div>
							<div class="sa-select">
								<div class="dropdown" id="columnDrop2">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="설비속성 선택">설비속성 선택<span class="caret"></span></button>
									<ul class="dropdown-menu chk-type" role="menu" id="columnLi2">
										<li data-value="[key]">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="column02_[INDEX]" name="column2" value="[key]">
												<label for="column02_[INDEX]">[value]</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="sa-select">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle w4" data-toggle="dropdown" data-value="mean" data-name="평균"><fmt:message key="statushistory.2.average" /><span class="caret"></span></button>
									<ul class="dropdown-menu radio-type " role="menu">
										<li data-value="max">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="rdValue2_01" name="rdValue2" value="max">
												<label for="rdValue2_01"><fmt:message key="statushistory.2.max" /></label>
											</a>
										</li>
										<li data-value="min">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="rdValue2_02" name="rdValue2" value="min">
												<label for="rdValue2_02"><fmt:message key="statushistory.2.min" /></label>
											</a>
										</li>
										<li data-value="mean">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="rdValue2_03" name="rdValue2" value="mean" checked>
												<label for="rdValue2_03"><fmt:message key="statushistory.2.average" /></label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="fl ml-16">
							<span class="tx-tit">y축</span>
							<div class="sa-select">
								<div class="dropdown" id="chartDid3">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="설비명 선택">
										설비명 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="chartDidUl3">
										<li data-value="[val]" data-sid="[sid]" data-type="[type]"><a href="javascript:void(0);">[siteDevice]</a></li>
									</ul>
								</div>
							</div>
							<div class="sa-select">
								<div class="dropdown" id="columnDrop3">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="설비속성 선택">설비속성 선택<span class="caret"></span></button>
									<ul class="dropdown-menu chk-type" role="menu" id="columnLi3">
										<li>
											<a href="javascript:void(0);" data-value="[key]" tabindex="-1">
												<input type="radio" id="column03_[INDEX]" name="column3" value="[key]">
												<label for="column03_[INDEX]">[value]</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="sa-select">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle w4" data-toggle="dropdown" data-value="mean" data-name="평균"><fmt:message key="statushistory.2.average" /><span class="caret"></span></button>
									<ul class="dropdown-menu radio-type" role="menu">
										<li data-value="max">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="rdValue3_1" name="rdValue3" value="max">
												<label for="rdValue3_1"><fmt:message key="statushistory.2.max" /></label>
											</a>
										</li>
										<li data-value="min">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="rdValue3_2" name="rdValue3" value="min">
												<label for="rdValue3_2"><fmt:message key="statushistory.2.min" /></label>
											</a>
										</li>
										<li data-value="mean">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="rdValue3_3" name="rdValue3" value="mean" checked>
												<label for="rdValue3_3"><fmt:message key="statushistory.2.average" /></label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>

					<!-- 버튼 -->
					<div class="fl">
						<button type="button" class="btn-type" id="chartAdd"><fmt:message key="statushistory.2.additem" /></button>
						<button type="button" class="btn-type" id="chartDraw"><fmt:message key="statushistory.2.create" /></button>
					</div>

					<!-- 우측 항목 -->
					<div class="fr history-input-box">
						<div class="radio-type history-radio-box">
							<span>
								<input type="radio" id="analyze1" name="analyze" value="시계열 분석" checked>
								<label for="analyze1"><fmt:message key="statushistory.2.time_series" /></label>
							</span>
							<span>
								<input type="radio" id="analyze2" name="analyze" value="상관 분석">
								<label for="analyze2"><fmt:message key="statushistory.2.correlation" /></label>
							</span>
						</div>

						<div class="sa-select">
							<div class="dropdown" id="summation">
								<button type="button" class="dropdown-toggle w6" data-toggle="dropdown" data-value="siteAccrue"><fmt:message key="statushistory.2.noselect" /><span class="caret"></span></button>
								<ul class="dropdown-menu radio-type">
									<li>
										<a href="javascript:void(0);" data-value="option1" tabindex="-1">
											<input type="radio" id="summation1" name="summation" value="siteAccrue">
											<label for="summation1"><fmt:message key="statushistory.2.plantsum" /></label>
										</a>
									</li>
									<%--											<li>--%>
									<%--												<a href="javascript:void(0);" data-value="option2" tabindex="-1">--%>
									<%--													<input type="radio" id="summation2" name="summation" value="siteAverage">--%>
									<%--													<label for="summation2">사이트별 평균</label>--%>
									<%--												</a>--%>
									<%--											</li>--%>
									<li>
										<a href="javascript:void(0);" data-value="option3" tabindex="-1">
											<input type="radio" id="summation3" name="summation" value="deviceAccrue">
											<label for="summation3"><fmt:message key="statushistory.2.devicesum" /></label>
										</a>
									</li>
									<%--											<li>--%>
									<%--												<a href="javascript:void(0);" data-value="option4" tabindex="-1">--%>
									<%--													<input type="radio" id="summation4" name="summation" value="deviceAverage">--%>
									<%--													<label for="summation4">설비별 평균</label>--%>
									<%--												</a>--%>
									<%--											</li>--%>
									<li>
										<a href="javascript:void(0);" data-value="option5" tabindex="-1">
											<input type="radio" id="summation5" name="summation" value="" checked>
											<label for="summation5"><fmt:message key="statushistory.2.noselect" /></label>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</div>

				</div>
				<br>
				<!-- 시계열 분석 -->
				<div class="tag-box clear" id="analyzeTag1">
					<div class="fl"><span class="tx-tit"><fmt:message key="statushistory.2.y_left" /></span></div>
					<div class="fl"><span class="tx-tit"><fmt:message key="statushistory.2.y_right" /></span></div>
				</div>
				<!-- 상관 분석 -->
				<div class="tag-box clear" id="analyzeTag2">
					<div class="fl"></div>
				</div>
			</div>
			<div class="inchart"><div id="hchart2"></div></div>
		</div>
		<div class="indiv table-operation-wrapper">
			<div class="usage-chart-table" id="datatable"></div>
		</div>
	</div>
</div>