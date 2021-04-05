<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let today = new Date();
	const searchDid = '<c:out value="${param.did}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');

	const configDevice = '/config/orgs/' + oid;
	const statusSummary = '/get/status/summary';
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

		if($('#analyze1').is(':checked')){
			$('#analyzeDiv1').show();
			$('#analyzeTag1').show();
			$('#summation').show();

			$('#analyzeDiv2').hide();
			$('#analyzeTag2').hide();
		} else {
			$('#analyzeDiv2').show();
			$('#analyzeTag2').show();
			$('#summation').hide();

			$('#analyzeDiv1').hide();
			$('#analyzeTag1').hide();
		}

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

			displayDropdown($('#devices'));
		});

		$('#chartAdd').on('click', function () {

			if ($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
				if ($('#chartDid button').data('value') == '') {
					alert('<fmt:message key="operHistory.alert.1" />');
					return false;
				}

				if ($(':radio[name="column"]').is(':checked') == false) {
					alert('<fmt:message key="operHistory.alert.2" />');
					return false;
				}

				if ($(':radio[name="rdValue"]').is(':checked') == false) {
					alert('<fmt:message key="operHistory.alert.3" />');
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
					alert('<fmt:message key="operHistory.alert.3" />');
					return false;
				}

				let $txt = $('#chartDid button').text() + ': ' + $(':radio[name="column"]:checked').next('label').text() + $(':radio[name="rdValue"]:checked').next('label').text()
				let $span = $('<span class="tag-type">' + $txt + '<button>&times;</button></span>');
				$span.data('deviceId', $('#chartDid button').data('value'));
				$span.data('sid', $('#chartDid button').data('sid'));
				$span.data('type', $('#chartDid button').data('type'));
				$span.data('key', $(':radio[name="column"]:checked').val())
				$span.data('key2', $(':radio[name="rdValue"]:checked').val());

				if ($('#way').find('button').data('value') == 'l') {
					$('#analyzeTag1 .tx-tit').eq(0).append($span);
				} else {
					$('#analyzeTag1 .tx-tit').eq(1).append($span);
				}
			} else {
				if ($('#chartDid2 button').data('value') == '') {
					alert('<fmt:message key="operHistory.alert.4" />');
					return false;
				}

				if ($(':radio[name="column2"]').is(':checked') == false) {
					alert('<fmt:message key="operHistory.alert.5" />');
					return false;
				}

				if ($(':radio[name="rdValue2"]').is(':checked') == false) {
					alert('<fmt:message key="operHistory.alert.6" />');
					return false;
				}

				if ($('#chartDid3 button').data('value') == '') {
					alert('<fmt:message key="operHistory.alert.7" />');
					return false;
				}

				if ($(':radio[name="column3"]').is(':checked') == false) {
					alert('<fmt:message key="operHistory.alert.8" />');
					return false;
				}

				if ($(':radio[name="rdValue3"]').is(':checked') == false) {
					alert('<fmt:message key="operHistory.alert.9" />');
					return false;
				}

				//기존항목이 존재한다면 중복체크
				if ($('#analyzeTag2 > span').length > 0) {
					if (duplicateTag(2)) {
						return false;
					}
				}

				let $txt = $('#chartDid2 button').text() + ': ' + $(':radio[name="column2"]:checked').next('label').text() + $(':radio[name="rdValue2"]:checked').next('label').text();
				let $txt2 = $('#chartDid3 button').text() + ': ' + $(':radio[name="column3"]:checked').next('label').text() + $(':radio[name="rdValue3"]:checked').next('label').text();
				let $span = $('<span class="tag-type">' + $txt + '/' + $txt2 + '<button>&times;</button></span>');

				$span.data('deviceIdX', $('#chartDid2 button').data('value'));
				$span.data('keyX', $(':radio[name="column2"]:checked').val());
				$span.data('key2X', $(':radio[name="rdValue2"]:checked').val());

				$span.data('deviceIdY', $('#chartDid3 button').data('value'));
				$span.data('keyY', $(':radio[name="column3"]:checked').val());
				$span.data('key2Y', $(':radio[name="rdValue3"]:checked').val());

				$span.data('typeX', $('#chartDid2 button').data('type'));
				$span.data('typeY', $('#chartDid3 button').data('type'));
				$('#analyzeTag2').append($span);
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
			let chartColor = [
				"var(--powder-blue)",
				"var(--turquoise)",
				"var(--teal)",
				"var(--light-blue)",
				"var(--blueberry)",
				"var(--royal-blue)",
				"var(--blue-yonder)",
				"var(--circle-solar-power)",
				"var(--deep-lilac)",
				"var(--yellow-green)",
				"var(--green)",
				"var(--eucalyptus)",
				"var(--french-pass)",
				"var(--malibu)",
				"var(--vivid-blue)"
			];
			let categories = new Array();
			let chartSeries = new Array();
			let summation = $(':radio[name="summation"]:checked').val();
			let stackNum = 0;

			if ($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
				let timeCategory = new Array();
				show = true;
				if ($('#analyzeTag1 span').length <= 0) {
					alert('<fmt:message key="operHistory.alert.10" />');
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

				let tag1Left = $('#analyzeTag1 .tx-tit').eq(0).find('span');
				let tag1Right = $('#analyzeTag1 .tx-tit').eq(1).find('span');

				tag1Left.each(function (idx, element) {
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
							name: $(this).contents().get(0).nodeValue,
							type: 'column',
							stack: stackNum,
							sid: sid,
							dType: type,
							tooltip: {
								valueSuffix: setttingSuffix(keyText)
							},
							color: ( (tag1Left.length + tag1Right.length) === 1 ) ? chartColor[1] : chartColor[index],
							data: dataArr
						};
						
						index++;
					}

					chartSeries.push(temp);

					//양쪽이 동일할경우 체크
					tag1Right.each(function () {
						let keyText_1 = $(this).data('key');
						if (keyText == keyText_1) {
							dupY = 0;
						}
					});
				});

				tag1Right.each(function () {
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
							name: $(this).contents().get(0).nodeValue,
							type: 'spline',
							stack: index,
							yAxis: dupY,
							sid: sid,
							dType: type,
							color: ( (tag1Left.length + tag1Right.length) === 1 ) ? chartColor[1] : chartColor[index],
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
					alert('<fmt:message key="operHistory.alert.10" />');
					return false;
				}

				let tag2 = $('#analyzeTag2 span');

				tag2.each(function (index) {
					let dataArr = new Array();
					let seriesName = $(this).contents().get(0).nodeValue;
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

					if(tag2.length === 1){
						chartSeries.push({
							name: seriesName,
							type: 'scatter',
							color: chartColor[1],
							tooltip: {
								valueSuffix: suffix
							},
							data: dataArr
						});		
					} else {
						chartSeries.push({
							name: seriesName,
							type: 'scatter',
							color: chartColor[index],
							tooltip: {
								valueSuffix: suffix
							},
							data: dataArr
						});							
					}
				});
				chartDraw(chartSeries, null, show);
			}
		});

		$('.btn-save').on('click', function (e) {
			let excelName = '상태이력';
			let $val = $('#datatable').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('<fmt:message key="operHistory.alert.11" />');
			} else {
				if (confirm('<fmt:message key="operHistory.confirm.1" />')) {
					tableToExcel('datatable', excelName, e);
				}
			}
		});

		deviceProperties();

		window.onload = function() {
			if (!isEmpty(searchDid)) {
				$.ajax({
					url: apiHost + '/config/devices',
					type: 'get',
					data: {
						oid: oid,
					}
				}).done(function(data, textStatus, jqXHR) {
					const targetDevice = data.find(e => e.did === searchDid);
					$(':checkbox[name="site"]').each(function() {
						if($(this).val() == targetDevice.sid) {
							$(this).prop('checked', true);
							displayDropdown($('#siteList'));
							deviceType(targetDevice.device_type);
						}
					});
				}).fail(function(jqXHR, textStatus, errorThrown) {
					console.error(textStatus);
					return false;
				})
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


					tempTable.push(
						{
							key: 'siteName',
							value: siteLocaleName
						}
					);

					$.map(propList, function (v, k) {
						if (v.analysis_table) {
							let tempObj = new Object();
							let unit = (v.unit != null && v.unit != '') ? '(' + v.unit + ')' : '';
							let propName = (langStatus == 'KO') ? v.name.kr : toTitleCase(v.name.en);
							tempObj['key'] = k;
							tempObj['value'] = propName + unit;
							tempTable.push(tempObj);
						}

						if (v.analysis_feature) {
							let tempObj = new Object();
							let unit = (v.unit != null && v.unit != '') ? '(' + v.unit + ')' : '';
							let propName = (langStatus == 'KO') ? v.name.kr : toTitleCase(v.name.en);
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
	const siteMakeList = function (search = []) {
		const makeSite = search.length ? Array.from(search) : Array.from(siteList);
		makeSite.sortOn('name');
		makeSite.unshift({ sid: 'all', name: '<fmt:message key="dropDown.all" />'});
		setMakeList(makeSite, 'siteULList', {'dataFunction': {}}); //list생성
		
		$('#siteULList').find('input[value="all"]').parent().after('<li class="btn-wrap-border-min"></li>');

		if (!$(`.dropdown-search`).length) {
			$(`#siteList`)
				.prepend(`<div class="dropdown-search"><input type="text" placeholder="<fmt:message key="dropdown.siteSearch" />" onKeyup="searchSite($(this).val())" ></div>`)
				.append(`<div class="btn-wrap-type03 btn-wrap-border dropdown-apply"><button type="button" class="btn-type mr-16"><fmt:message key="deviceState.apply" /></button></div>`);
		}
	};

	const searchSite = keyword => {
		const result = siteList.filter(x => x.name.includes(keyword));

		siteMakeList(result);
	}

	//선택한 SID에 해당하는 유형의 타입을 보여준다.
	const deviceType = function (deviceTp) {
		$('#deviceType button').empty().append('<fmt:message key="operHistory.deviceType" /><span class="caret"></span>');
		$('#devices .dropdown-toggle').text().replace(/<[^>]+>/g, '<fmt:message key="operHistory.multiple" />');
		$('#devices .dropdown-cov').empty();

		let siteArray = new Array();
		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => {
				if (check.value !== 'all') {
					siteArray.push(check.value);
				}
			});
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				siteArray.push(checked.value);
			});
		}

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

					deviceType.sortOn('name');
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
		$('#devices .dropdown-toggle').text().replace(/<[^>]+>/g, '<fmt:message key="operHistory.multiple" />');
		$('#devices .dropdown-cov').empty();
		
		const typeArray = $.makeArray(
			$(':checkbox[name="type"]:checked').map(
				function () {
					return $(this).val();
				}
			)
		);

		if (typeArray.length > 0 && deviceList.length > 0) {

			//선택된 사이트를 기준으로 한다.
			let siteArray = new Array();
			if ($(':checkbox[name="site"]:checked').val() === 'all') {
				document.querySelectorAll('[name="site"]').forEach(check => {
					if (check.value !== 'all') {
						siteArray.push({
							siteId: check.value,
							siteNm: check.nextElementSibling.textContent
						});
					}
				});
			} else {
				document.querySelectorAll('[name="site"]:checked').forEach(checked => {
					siteArray.push({
						siteId: checked.value,
						siteNm: checked.nextElementSibling.textContent
					});
				});
			}

			siteArray.forEach(site => {
				let siteGrp = $('<li>').addClass('sec-li-box');

				siteGrp.append('<p>');
				siteGrp.find('p').addClass('tx-li-title').text(site.siteNm);
				siteGrp.append('<ul>');

				deviceList.sortOn('name');
				let deviceProp = new Array();
				$.each(deviceList, function (i, el) {
					if (el.sid == site.siteId) {
						$.each(typeArray, function (k, elm) {
							if (elm == el.device_type) {
								deviceProp.push(el);

								let targetSite = siteList.find(e => e.sid === el.sid);

								let str = `<li>
												<a href="javascript:void(0);" data-value="${'${el.did}'}" tabindex="-1">
													<input type="checkbox" id="device_${'${el.did}'}" name="device" value="${'${el.did}'}" data-sid="${'${el.sid}'}" data-type="${'${el.device_type}'}" data-sitename="${'${targetSite.name}'}">
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
		let columnList = new Array();
		let type = $('#' + obj + ' button').data('type');
		let idNum = '';
		if (obj.length > 8) {
			idNum = obj.slice(-1);
		}

		$('#' + 'columnLi' + idNum).prev().html($('#' + 'columnLi' + idNum).prev().data('name') + '<span class="caret"></span>');
		$.map(featureProperties, function (value, key) {
			if (type == key) {
				columnList = value;
			}
		});

		if (columnList.length === 0) {
			$('#' + 'columnLi' + idNum).empty().append(`<li class="no-data">선택 황목 없음</li>`);
		} else {
			setMakeList(columnList, 'columnLi' + idNum, {
				"dataFunction": {
					"INDEX": getNumberIndex
				}
			}); //list생성
		}
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

						// if (idx == 0) { hCell.setAttribute('class', 'hidden'); }
						hRow.appendChild(hCell);

						let bCell = bRow.insertCell();
						// if (idx == 0) { bCell.setAttribute('class', 'hidden'); }
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
			alert('<fmt:message key="operHistory.alert.12" />');
			return false;
		}

		if ($(':checkbox[name="type"]:checked').length == 0) {
			alert('<fmt:message key="operHistory.alert.13" />');
			return false;
		}

		if ($(':checkbox[name="device"]:checked').length == 0) {
			alert('<fmt:message key="operHistory.alert.14" />');
			return false;
		}

		let siteArray = new Array();
		let deviceArray = new Array();

		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => {
				if (check.value !== 'all') {
					siteArray.push(check.value);
				}
			});
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				siteArray.push(checked.value);
			});
		}

		$(':checkbox[name="device"]:checked').each(function () {
			deviceArray.push($(this).val());
		});

		makeTableTemplateDevice();

		$('[id^="chartDid"]').each(function () {
			$(this).find('button').html($(this).find('button').data('name') + '<span class="caret"></span>').data('value', '');
		});

		$('[id^="analyzeTag"] .tx-tit .tag-type').each(function () {
			$(this).remove();
		});


		$('#way button').html($('#way button').data('name') + '<span class="caret"></span>');

		let statusSummaryData = {
			sids: siteArray.join(','),
			dids: deviceArray.join(','),
			//deviceType: '',
			startTime: Number($('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000'),
			endTime: Number($('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959'),
			interval: $('#interval').find('button').data('value'),
			formId: 'v2'
		}

		$.ajax({
			url: apiHost + statusSummary,
			type: 'post',
			async: false,
			contentType: 'application/json',
			data: JSON.stringify(statusSummaryData),
			success: function (result) {
				let chart = $('#hchart2').highcharts();
				if (chart) {
					chart.destroy();

					$('[id^=columnLi]').empty().prev().html('<fmt:message key="operHistory.graphseeg" /> <span class="caret"></span>');
				}

				$.map(result, function (value, key) {
					if ($('#' + key + '_Table').length > 0) {
						if (isEmpty(value)) {
							$('#' + key + '_Table').parents('.history-table').hide();
						} else {
							$.each(value, function (idx, valObj) {
								value[idx].localtime = String(valObj.basetime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
								value[idx].timestamp = new Date(value[idx].localtime).getTime();

								const did = value[idx].did;
								$(':checkbox[name="device"]').each(function() {
									if ($(this).val() === did) {
										value[idx].siteName = $(this).data('sitename');
									}
								});

								$.map(valObj.mean, function (v, k) {
									if(typeof v == "number"){
										valObj[k] = numberComma(v.toFixed(2));
									}
								});
							});

							setMakeList(value, key + '_Table', {'dataFunction': {}}); //list생성
							$('#' + key + '_Table td').each(function () {
								$(this).html($(this).html().replace(/ *\[[^)]*\] */g, ''));
							});
							$('#' + key + '_Table').parents('.history-table').show();
						}
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
					alert('<fmt:message key="operHistory.alert.15" />');
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
					alert('<fmt:message key="operHistory.alert.15" />');
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
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				tickInterval: 1,
				labels: {
					align: 'center',
					style: {
						color: 'var(--grey)',
						fontSize: '8px'
					},
					enabled: true,
				},
				categories: categories,
				title: {
					text: null
				},
				crosshair: true
			},
			yAxis: [{
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
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
						color: 'var(--grey)',
						fontSize: '10px'
					}
				}
			}, {
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
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
						color: 'var(--grey)',
						fontSize: '10px'
					}
				},
				alignTicks: false,
				opposite: true
			}],
			legend: {
				enabled: true,
				align: 'right',
				alignColumns: true,
				verticalAlign: 'top',
				x: 10,
				itemStyle: {
					color: 'var(--white87)',
					fontSize: '14px',
					fontWeight: 400
				},
				itemHoverStyle: {
					color: ''
				},
				symbolPadding: 3,
				symbolHeight: 8
			},
			tooltip: {
				formatter: function () {
					if ($(':radio[name="analyze"]:checked').val() == '시계열 분석') {
						return this.points.reduce(function (s, point) {
							return s + '<br/><span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + numberComma(Number(point.y).toFixed(2)) + point.series.userOptions.tooltip.valueSuffix;
						}, '<span style="display:flex; margin-bottom:-10px;"><b>' + new Date(this.x).format('yyyy-MM-dd HH:mm:ss') + '</b></span>');
					} else {
						let tooltip = this.series.name + '<br/>' +
							'X:' + numberComma((this.x).toFixed(2)) + '<br/> Y:' + numberComma((this.y).toFixed(2));
						return tooltip;
					}
				},
				positioner: function(boxWidth, boxHeight, point) {
					let xPosition = (point.plotX - 250) < 0 ? 0 : point.plotX - 250;
					return {x: xPosition, y: point.plotY};
				},
				shared: true,
				useHTML: true,
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
			if (interval == '1min' || interval == '5min' || interval == '15min' || interval == 'hour') {
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
		<h1 class="page-header"><fmt:message key='operHistory.title' /></h1>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<form id="operationSearchForm">
			<div class="dropdown sa-select" id="siteList">
				<button type="button" class="dropdown-toggle w1 no-close" data-toggle="dropdown" data-name="<fmt:message key='operHistory.selectSite' />"><fmt:message key='operHistory.selectSite' /><span class="caret"></span></button>
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
				<button type="button" class="btn clear-btn" data-target="#searchDropdown" data-name="상세 검색" onclick="$('#searchDetail').toggleClass('open')"><fmt:message key='operHistory.detailSearch' /><span class="caret"></span></button>
				<div id="searchDropdown" class="dropdown-menu search-dropdown">
					<h2 class="tx-tit"><fmt:message key="statushistory.1.devicetype" /></h2>
					<div class="flex-start">
						<div class="dropdown" id="deviceType"><!--
						--><button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='operHistory.detailSearch.type' />"><fmt:message key='operHistory.detailSearch.type' /><span class="caret"></span></button><!--
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
						--><button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='statushistory.1.multiple.select' />"><fmt:message key="statushistory.1.multiple.select" /><span class="caret"></span></button><!--
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

					<div class="flex-start2 mt-20 dateField">
						<div>
							<h2 class="tx-tit"><fmt:message key="statushistory.1.timeframe" /></h2>
							<label for="fromDate" class="tx-tit sr-only"><fmt:message key='operHistory.detailSearch.start' /></label>
							<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="" autocomplete="off">
						</div>
						<div>
							<h2 class="tx-tit"></h2>
							<label for="toDate" class="tx-tit sr-only"><fmt:message key='operHistory.detailSearch.end' /></label>
							<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off">
						</div>
						<div id="interval">
							<h2 class="tx-tit"><fmt:message key='operHistory.detailSearch.unit' /></h2>
							<div class="dropdown">
								<button type="button" class="dropdown-toggle w3" data-toggle="dropdown" data-value="15min" data-name="<fmt:message key='operHistory.detailSearch.unit.15i' />"><fmt:message key='operHistory.detailSearch.unit.15i' /><span class="caret"></span></button>
								<ul class="dropdown-menu">
<%--									<li data-value="1min"><a href="javascript:void(0);"><fmt:message key='operHistory.detailSearch.unit.1i' /></a></li>--%>
									<li data-value="5min"><a href="javascript:void(0);"><fmt:message key='operHistory.detailSearch.unit.5i' /></a></li>
									<li data-value="15min"><a href="javascript:void(0);"><fmt:message key='operHistory.detailSearch.unit.15i' /></a></li>
									<li data-value="hour"><a href="javascript:void(0);"><fmt:message key='operHistory.detailSearch.unit.1h' /></a></li>
									<li data-value="day"><a href="javascript:void(0);"><fmt:message key='operHistory.detailSearch.unit.1d' /></a></li>
	<%--								<li data-value="week"><a href="javascript:void(0);"><fmt:message key='operHistory.detailSearch.unit.1w' /></a></li>--%>
	<%--								<li data-value="month"><a href="javascript:void(0);"><fmt:message key='operHistory.detailSearch.unit.1m' /></a></li>--%>
								</ul>
							</div>
						</div>
					</div>
					
					<div class="btn-wrap-type05">
						<button type="button" class="btn-type03 w-80px" onclick="$('#searchDetail').removeClass('open')"><fmt:message key='operHistory.detailSearch.cancle' /></button><!--
					--><button type="button" class="btn-type w-80px ml-12" onclick="$('#searchDetail').removeClass('open')"><fmt:message key='operHistory.detailSearch.apply' /></button>
					</div>
				</div>
			</div>
		
			<button type="button" id="search" class="btn-type ml-6"><fmt:message key="statushistory.1.update" /></button>
			<a href="#;" class="btn-save fr"><fmt:message key='operHistory.saveData' /></a>
		</form>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="indiv operation-history">
			<div class="row">
				<div class="col-12">
					<h2 class="sm-title"><fmt:message key="statushistory.2.selectdevice" /></h2>
					<%-- <a href="javascript:void(0);" class="btn-type02 fr"><fmt:message key='operHistory.saveCond' /></a> --%>
				</div>
			</div>
			
			<!-- 기본 항목 -->
			<div class="row chart-top">
				<div class="col-xl-9 col-lg-7 col-md-7 col-sm-12" id="operationFilter">
					<div id="analyzeDiv1" class="sa-select mb-10">
						<div class="sa-select mb-10">
							<div class="dropdown" id="chartDid">
								<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="<fmt:message key='operHistory.graph.name' />"><fmt:message key='operHistory.graph.name' /><span class="caret"></span></button>
								<ul class="dropdown-menu" id="chartDidUl"><li data-value="[val]" data-sid="[sid]" data-type="[type]"><a href="javascript:void(0);">[siteDevice]</a></li></ul>
							</div>
						</div>
						<div class="sa-select mb-10">
							<div class="dropdown">
								<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="<fmt:message key='operHistory.graph.type' />"><fmt:message key='operHistory.graph.type' /><span class="caret"></span></button>
								<ul class="dropdown-menu radio-type" role="menu" id="columnLi"><li data-value="[key]"><a href="javascript:void(0);" tabindex="-1"><input type="radio" id="column[INDEX]" name="column" value="[key]"><label for="column[INDEX]">[value]</label></a></li></ul>
							</div>
						</div>
						<div class="sa-select mb-10">
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
						<div class="sa-select mb-10">
							<div class="dropdown" id="way">
								<button type="button" class="dropdown-toggle w5" data-toggle="dropdown" data-name="<fmt:message key='operHistory.graphseeg' />"><fmt:message key='operHistory.graphseeg' /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="l"><a href="javascript:void(0);"><fmt:message key="statushistory.2.y_left" /></a></li>
									<li data-value="r"><a href="javascript:void(0);"><fmt:message key="statushistory.2.y_right" /></a></li>
								</ul>
							</div>
						</div>
					</div>

					<div id="analyzeDiv2" class="sa-select" style="display:none;">
						
						<div>
							<span class="tx-tit"><fmt:message key='operHistory.graph.gridX' /></span>
							<div class="sa-select mb-10">
								<div id="chartDid2" class="dropdown">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="<fmt:message key='operHistory.graph.name' />"><fmt:message key='operHistory.graph.name' /><span class="caret"></span></button>
									<ul class="dropdown-menu" id="chartDidUl2">
										<li data-value="[val]" data-sid="[sid]" data-type="[type]"><a>[siteDevice]</a></li>
									</ul>
								</div>
							</div>
							<div class="sa-select mb-10">
								<div id="columnDrop2" class="dropdown">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="<fmt:message key='operHistory.graph.type' />"><fmt:message key='operHistory.graph.type' /><span class="caret"></span></button>
									<ul id="columnLi2" class="dropdown-menu radio-type" role="menu">
										<li data-value="[key]">
											<a href="javascript:void(0);" tabindex="-1">
												<input type="radio" id="column02_[INDEX]" name="column2" value="[key]">
												<label for="column02_[INDEX]">[value]</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="sa-select mb-10">
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

						<div>
							<span class="tx-tit"><fmt:message key='operHistory.graph.gridY' /></span>
							<div class="sa-select mb-10">
								<div id="chartDid3" class="dropdown">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="<fmt:message key='operHistory.graph.name' />">
										<fmt:message key='operHistory.graph.name' /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="chartDidUl3">
										<li data-value="[val]" data-sid="[sid]" data-type="[type]"><a href="javascript:void(0);">[siteDevice]</a></li>
									</ul>
								</div>
							</div>
							<div class="sa-select mb-10">
								<div id="columnDrop3" class="dropdown">
									<button type="button" class="dropdown-toggle w2" data-toggle="dropdown" data-name="<fmt:message key='operHistory.graph.type' />"><fmt:message key='operHistory.graph.type' /><span class="caret"></span></button>
									<ul id="columnLi3" class="dropdown-menu radio-type" role="menu">
										<li>
											<a href="javascript:void(0);" data-value="[key]" tabindex="-1">
												<input type="radio" id="column03_[INDEX]" name="column3" value="[key]">
												<label for="column03_[INDEX]">[value]</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="sa-select mb-10">
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
					<div class="sa-select mb-10 operation-filter-button">
						<button type="button" class="btn-type" id="chartAdd"><fmt:message key="statushistory.2.additem" /></button>
						<button type="button" class="btn-type" id="chartDraw"><fmt:message key="statushistory.2.create" /></button>
					</div>
				</div>

				<div class="col-xl-3 col-lg-5 col-md-5 col-sm-12">
					<!-- 우측 항목 -->
					<div class="flex-end">
						<div class="radio-type">
							<input type="radio" id="analyze1" name="analyze" value="시계열 분석" checked>
							<label for="analyze1"><fmt:message key="statushistory.2.time_series" /></label>
						</div>
						<div class="radio-type">
							<input type="radio" id="analyze2" name="analyze" value="상관 분석">
							<label for="analyze2"><fmt:message key="statushistory.2.correlation" /></label>
						</div>

						<div id="summation" class="dropdown">
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
								<%--													<label for="summation2"><fmt:message key='operHistory.avg1' /></label>--%>
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
								<%--													<label for="summation4"><fmt:message key='operHistory.avg2' /></label>--%>
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

			<div class="row">
				<div class="col-12">
					<!-- 시계열 분석 -->
					<div id="analyzeTag1" class="tag-box">
						<h3 class="axis-label"><fmt:message key="statushistory.2.y_left" /></h3><!--
					--><p class="tx-tit"></p>
						<h3 class="axis-label"><fmt:message key="statushistory.2.y_right" /></h3><!--
					--><p class="tx-tit"></p><!--
				--></div>
					<!-- 상관 분석 -->
					<div id="analyzeTag2" class="tag-box" style="display:none;"></div>
				</div>
			</div>

			<div class="inchart">
				<div id="hchart2"></div>
			</div>
		</div>

		<div class="indiv operation-history">
			<div class="usage-chart-table" id="datatable"></div>
		</div>
	</div>
</div>