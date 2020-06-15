<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const apiURL = 'http://iderms.enertalk.com:8443';
	const siteList = JSON.parse('${siteList}');
	let deviceList;

	const configDevice = '/config/orgs/' + oid;
	const statusRawDid = '/status/raw?dids=';
	const statusSummary = '/status/summary';
	const energyDevice = '/energy/devices';
	const forecast = '/energy/forecasting/devices';
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

	$(function () {
		const compareArea = $('#siteList').next().find('.compare_area');
		const dropdownArea = compareArea.find('.dropdown');
		const compareSelectBox = compareArea.children().find('.dropdown-toggle.bgN');
		const modalCompare = compareSelectBox.next('ul');
		// const innerSelectBox = selectModal.find("btn.dropdown-toggle");
		const confirmBtn = modalCompare.find('comp_btn_wrap button');

		compareSelectBox.on('click', function () {
			dropdownArea.toggleClass("open");
		});

		confirmBtn.on('click', function () {
			dropdownArea.removeClass('open');
		});

		setInitList('siteULList'); //사업소 리스트 초기화
		setInitList('typeULList'); //검증설비 - 설비유형 리스트 초기화
		setInitList('compareTypeULList'); //검증설비 - 설비유형 리스트 초기화
		siteMakeList(); //사업소 리스트 그리기

		setInitList('deviceName'); //검증설비 - 설비유형 리스트 초기화
		setInitList('compareDeviceName'); //검증설비 - 설비유형 리스트 초기화

		setInitList('deviceAttribute'); //검증설비 - 설비유형 리스트 초기화
		setInitList('compareDeviceAttribute'); //검증설비 - 설비유형 리스트 초기화

		$('.fromDate, .toDate').datepicker('setDate', new Date()); //기본값 세팅

		deviceProperties(); //설비속성 템플릿 만들기

		//확인 클릭시
		$('#renderBtn').on('click', function () {
			searchGrid();
		});

		$('.save_btn').on('click', function (e) {
			let excelName = '이상분석';
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
	});

	const rtnDropdown = ($selectId) => {
		if ($selectId == 'selectSiteList') {
			deviceType();

			//사이트 변경시 선택 초기화
			$('.offset_dropdown button.btn-primary').each(function () {
				let divObj = $(this).parent(),
					divId = divObj.attr('id');
				if (divId == 'interval') {
					$(this).data('value', 'hour').html('1시간 <span class="caret"></span>');
				} else {
					dropDownInit(divObj);
				}
			});

			$('#reference').val('');
			$('#normality_threshold_upper').val('');
			$('#normality_threshold_lower').val('');

			$('.fromDate, .toDate').datepicker('setDate', new Date()); //기본값 세팅

		} else if ($selectId == 'typeList' || $selectId == 'compareTypeList') {
			deviceName($selectId); //설비명
		} else if ($selectId == 'deviceList' || $selectId == 'compareDeviceList') {
			setTypeList($selectId); //설비속성
		} else if ($selectId == 'attrList' || $selectId == 'compareAttrList') {
			//attrSelect($selectId);
		}
	}

	//사업소 조회
	const siteMakeList = () => {
		setMakeList(siteList, 'siteULList', {'dataFunction': {}}); //list생성
	};

	// 추후에도 쓸일 없다면 삭제 요망. 2020.06.12
	// const attrSelect = (obj) => {
	// 	let value = obj.find('input').val();
	// 	if (value == 'metering' || value == 'forecasting') {
	// 		$('#interval button').html('1달 <span class="caret"></span>').data('value', 'month');
	// 		$('#interval li').each(function () {
	// 			if ($(this).data('value') != 'month') {
	// 				$(this).addClass('disabled');
	// 			}
	// 		});
	// 	} else {
	// 		$('#interval li').each(function () {
	// 			$(this).removeClass('disabled');
	// 		});
	// 	}
	// }

	//설비유형 리스트 그리기
	const deviceType = () => {
		let deviceType = new Array();
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
				data: configDeviceData
			}).done(function (data, textStatus, jqXHR) {
				deviceList = data.devices;
				deviceList.forEach(el => {
					if ($.inArray(el.sid, siteArray) >= 0) {
						if ($.inArray(el.device_type, deviceType) === -1) {
							deviceType.push(el.device_type);
						}
					}
				});

				deviceType.sort(); //정렬

				deviceType.forEach((el, idx) => {
					deviceType[idx] = {
						name: deviceTemplate[el],
						type: el
					}
				});

				setMakeList(deviceType, 'typeULList', {'dataFunction': {}});
				setMakeList(deviceType, 'compareTypeULList', {'dataFunction': {}});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		} else {
			setMakeList(deviceType, 'typeULList', {'dataFunction': {}});
			setMakeList(deviceType, 'compareTypeULList', {'dataFunction': {}});
		}
	};

	//설비명 그리기
	const deviceName = ($selectId) => {
		let objType,
			targetId = 'deviceName',
			deviceNameArr = new Array();

		if ($selectId.match('comp')) {
			dropDownInit($('#compareDeviceList'));
			dropDownInit($('#compareAttrList'));

			objType = $(':radio[name="compareType"]:checked').val();
			targetId = 'compareDeviceName';
		} else {
			dropDownInit($('#deviceList'));
			dropDownInit($('#attrList'));

			objType = $(':radio[name="type"]:checked').val();
			targetId = 'deviceName';
		}

		if (deviceList.length > 0) {
			//선택된 사이트를 기준으로 한다.
			$(':checkbox[name="site"]:checked').each(function () {
				let siteNm = $(this).next().text(),
					siteId = $(this).val();

				deviceList.forEach(el => {
					if (el.sid == siteId) {
						if (objType == el.device_type) {
							let metering = false;
							if (el.metering_type > 0) {
								metering = true;
							}

							deviceNameArr.push({
								siteName: siteNm,
								name: el.name,
								did: el.did,
								forcasting: el.forecasting,
								metering: metering,
								type: el.device_type,
							});
						}
					}
				});
			});
		}

		setMakeList(deviceNameArr, targetId, {'dataFunction': {}});
	}

	//설비 속성 템플릿
	const featureProperties = new Object();
	const deviceProperties = () => {
		$.ajax({
			url: apiURL + '/config/view/device_properties',
			type: 'get',
			data: {},
			success: function (result) {
				$.map(result, function (val, key) {
					let deviceName = key;
					let propList = val.properties;
					let tempFeature = new Array();

					$.map(propList, function (v, k) {
						if (v.abnormality_feature) {
							let tempObj = new Object();
							let unit = (v.unit != null && v.unit != '') ? '(' + v.unit + ')' : '';
							tempObj['key'] = k;
							tempObj['value'] = v.name.kr + unit;
							tempObj['suffix'] = unit;
							tempFeature.push(tempObj);
						}
					});
					featureProperties[deviceName] = tempFeature;
				});
			},
			dataType: 'json'
		});
	};

	// 설비속성 그리기
	const setTypeList = ($selectId) => {
		let typeArray = new Array(),
			targetId = 'deviceAttribute',
			thisForecast = true,
			thisMetering = true, obj;

		if ($selectId.match('comp')) {
			dropDownInit($('#compareAttrList'));
			obj = $(':radio[name="compareType"]:checked');
			targetId = 'compareDeviceAttribute';

			const type = $(':checkbox[name="compDevice"]:checked');
			if(type.length > 0) {
				type.each(function() {
					if(!Boolean($(this).data('forcasting'))) {
						thisForecast = false;
					}

					if(!Boolean($(this).data('metering'))) {
						thisMetering = false
					}
				});
			} else {
				return; //설비 선택 전부 해제시에는 다음동작없음
			}
		} else {
			dropDownInit($('#attrList'));
			obj = $(':radio[name="type"]:checked');
			targetId = 'deviceAttribute';

			const type = $(':radio[name="deviceNm"]:checked');
			thisForecast = Boolean(type.data('forcasting'));
			thisMetering = Boolean(type.data('metering'));
		}

		$.map(featureProperties, function (value, key) {
			if (obj.val() == key) {
				typeArray = Array.from(value);
			}
		});

		if (thisMetering) {
			typeArray.push({
				key: 'metering',
				value: '계량값',
				suffix: 'W'
			});
		}

		if (thisForecast) {
			typeArray.push({
				key: 'forecasting',
				value: '예측계량값',
				suffix: 'W'
			});
		}

		setMakeList(typeArray, targetId, {'dataFunction': {}});
	}

	//조회
	const searchGrid = () => {

		verifyBoolean = false;
		compareBoolean = false;
		verifyList = new Array();
		compareList = new Array();

		let siteArray = new Array();
		let deviceArray = new Array();
		let compDeviceArray = new Array();

		// 사이트
		$(':checkbox[name="site"]:checked').each(function () {
			siteArray.push($(this).val());
		});

		// 검증설비
		$(':radio[name="deviceNm"]:checked').each(function () {
			deviceArray.push($(this).val());
		});

		// 비교설비
		$(':checkbox[name="compDevice"]:checked').each(function () {
			compDeviceArray.push($(this).val());
		});
		let interval = $('#interval').find('button').data('value');

		if (siteArray.length <= 0) {
			alert('사이트를 선택 해 주세요.');
			return false;
		}

		if ($(':radio[name="type"]:checked').length <= 0) {
			alert('검증성비 유형을 선택 해 주세요.');
			return false;
		}

		if ($(':radio[name="compareType"]:checked').length <= 0) {
			alert('비교성비 유형을 선택 해 주세요.');
			return false;
		}

		if (deviceArray.length <= 0) {
			alert('검증설비를 선택 해 주세요.');
			return false;
		}

		if (compDeviceArray.length <= 0) {
			alert('비교설비를 선택 해 주세요.');
			return false;
		}

		if ($(':radio[name="attr"]:checked').length <= 0) {
			alert('검증성비 속성을 선택 해 주세요.');
			return false;
		}

		if ($(':radio[name="compAttr"]:checked').length <= 0) {
			alert('비교성비 속성을 선택 해 주세요.');
			return false;
		}

		if ($(':radio[name="benchmark"]:checked').length > 0 || $(':radio[name="unit"]:checked').length > 0 || $('[name="reference"]').val() != '') {
			if ($(':radio[name="benchmark"]:checked').length <= 0) {
				alert('제외 값의 기준을 선택 해 주세요.');
				return false;
			}

			if ($(':radio[name="unit"]:checked').length <= 0) {
				alert('제외 값의 단위를 선택 해 주세요.');
				return false;
			}

			if (isEmpty($('[name="reference"]').val())) {
				alert('제외 값의 기준 값을 선택 해 주세요.');
				return false;
			}
		}

		if (document.querySelector('[name="compare_formula"]:checked') != null || document.querySelector('[name="compare_criterion"]:checked') != null
			|| !isEmpty(document.querySelector('[name="normality_threshold_lower"]').value) || !isEmpty(document.querySelector('[name="normality_threshold_upper"]').value)) {
			if (document.querySelector('[name="compare_formula"]:checked') == null) {
				alert('비교방법의 비교식을 선택 해 주세요.');
				return false;
			}

			if (document.querySelector('[name="compare_criterion"]:checked') == null) {
				alert('비교방법의 비교 기준을 선택 해 주세요.');
				return false;
			}

			if (isEmpty(document.querySelector('[name="normality_threshold_upper"]').value)) {
				alert('비교방법의 상한 허용치를 선택 해 주세요.');
				return false;
			}

			if (isEmpty(document.querySelector('[name="normality_threshold_lower"]').value)) {
				alert('비교방법의 하한 허용치를 선택 해 주세요.');
				return false;
			}
		}

		$('#siteList').next().find('.compare_area').find('.dropdown').removeClass('open');

		let standard = makeStandard(interval);
		makeTableTemplate(standard, interval);

		//검증 설비 사용량
		if ($(':radio[name="attr"]:checked').val() == 'metering') {
			// 검증설비 그리기
			let statusSummaryData = {
				dids: deviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: interval
			};

			$.ajax({
				url: apiURL + energyDevice,
				type: 'get',
				data: statusSummaryData,
			}).done(function (data, textStatus, jqXHR) {
				gridDataMake(data, 'verify', standard);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		} else if ($(':radio[name="attr"]:checked').val() == 'forecasting') {
			// 검증설비 그리기
			let statusSummaryData = {
				dids: deviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: interval
			};

			$.ajax({
				url: apiURL + forecast,
				type: 'get',
				data: statusSummaryData,
			}).done(function (data, textStatus, jqXHR) {
				gridDataMake(data, 'verify', standard);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		} else {
			// 검증설비 그리기
			let statusSummaryData = {
				sids: siteArray.join(','),
				dids: deviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: interval,
				formId: 'v2'
			};

			$.ajax({
				url: apiURL + statusSummary,
				type: 'get',
				data: statusSummaryData,
			}).done(function (data, textStatus, jqXHR) {
				gridDataMake(data, 'verify', standard);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		//비교 설비
		let option = new Object();
		if ($(':radio[name="compAttr"]:checked').val() == 'metering') {
			let statusSummaryData = {
				dids: compDeviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: interval
			};

			option = {
				url: apiURL + energyDevice,
				type: 'get',
				data: statusSummaryData
			}

			$.ajax(option).done(function (data, textStatus, jqXHR) {
				gridDataMake(data, 'compare', standard);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		} else if ($(':radio[name="compAttr"]:checked').val() == 'forecasting') {
			let statusSummaryData = {
				dids: compDeviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: interval
			};

			option = {
				url: apiURL + forecast,
				type: 'get',
				data: statusSummaryData
			}

			$.ajax(option).done(function (data, textStatus, jqXHR) {
				gridDataMake(data, 'compare', standard);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		} else {
			let statusSummaryData = {
				sids: siteArray.join(','),
				dids: compDeviceArray.join(','),
				startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
				endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
				interval: interval,
				formId: 'v2'
			};

			option = {
				url: apiURL + statusSummary,
				type: 'get',
				data: statusSummaryData,
			}

			$.ajax(option).done(function (data, textStatus, jqXHR) {
				gridDataMake(data, 'compare', standard);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}
	}

	let verifyBoolean = false;
	let compareBoolean = false;
	let verifyList = new Array();
	let compareList = new Array();
	const gridDataMake = (result, type, standard) => {
		let interval = $('#interval').find('button').data('value');
		let verifyTotal = 0;
		let compareTotal = 0;
		let verifyObj = new Object();
		let compareObj = new Object();

		verifyObj['name'] = '검증 설비';
		verifyObj['color'] = 1;

		compareObj['name'] = '비교 설비';
		compareObj['color'] = 2;

		if (type == 'verify') {
			if ($(':radio[name="attr"]:checked').val() == 'metering' || $(':radio[name="attr"]:checked').val() == 'forecasting') {
				if (!isEmpty(result.data)) {
					verifyList = result.data[$(':radio[name="deviceNm"]:checked').val()][0].items;
				}
			} else {
				verifyList = result[$(':radio[name="type"]:checked').val()];
			}

			verifyBoolean = true;
		} else {
			if ($(':radio[name="compAttr"]:checked').val() == 'metering' || $(':radio[name="compAttr"]:checked').val() == 'forecasting') {
				$(':checkbox[name="compDevice"]:checked').each(function () {
					if (!isEmpty(result.data)) {
						compareList = compareList.concat(result.data[$(this).val()][0].items);
					}
				});
			} else {
				compareList = result[$(':radio[name="compareType"]:checked').val()];
			}

			compareBoolean = true;
		}

		// 두 값이 다 들어오면.
		if (verifyBoolean && compareBoolean) {
			let tableData = new Array();
			standard.forEach((stnd, j) => {
				if (interval == 'day') {
					stnd += '000000';
				} else if (interval == 'month') {
					stnd += '01000000';
				}

				//검증 장비
				if (verifyList.length > 0) {
					verifyList.forEach(el => {
						if (stnd == el.basetime) {
							if ($(':radio[name="attr"]:checked').val() == 'metering' || $(':radio[name="attr"]:checked').val() == 'forecasting') {
								verifyObj[stnd] = Number(el.energy) / 1000;
							} else {
								verifyObj[stnd] = eval('el.mean.' + $('[name="attr"]:checked').val()) / 1000;
							}
						}
					});
				}

				//비교 장비
				if (compareList.length > 0) {
					compareList.forEach(el => {
						if (stnd == el.basetime) {
							if (compareObj[stnd] == undefined) {
								if ($(':radio[name="compAttr"]:checked').val() == 'metering' || $(':radio[name="compAttr"]:checked').val() == 'forecasting') {
									compareObj[stnd] = Number(el.energy) / 1000;
								} else {
									compareObj[stnd] = Number(eval('el.mean.' + $('[name="compAttr"]:checked').val())) / 1000;
								}
							} else {
								if ($(':radio[name="compAttr"]:checked').val() == 'metering' || $(':radio[name="compAttr"]:checked').val() == 'forecasting') {
									compareObj[stnd] += Number(el.energy) / 1000;
									compareObj[stnd] = compareObj[stnd] / $(':checkbox[name="compDevice"]:checked').length;
								} else {
									compareObj[stnd] += Number(eval('el.mean.' + $('[name="compAttr"]:checked').val())) / 1000;
									compareObj[stnd] = (compareObj[stnd] / $(':checkbox[name="compDevice"]:checked').length);
								}
							}
						}
					});
				}

				if (verifyObj[stnd] == undefined || compareObj[stnd] == '-') {
					verifyObj[stnd] = '-';
				} else {
					verifyObj[stnd] = benchmarkProcess(verifyObj[stnd], 'verify');
					if (verifyObj[stnd] == '-') {
						compareObj[stnd] = '-';
					}
				}

				if (compareObj[stnd] == undefined || compareObj[stnd] == '-') {
					compareObj[stnd] = '-';
				} else {
					compareObj[stnd] = benchmarkProcess(compareObj[stnd], 'compare');
					if (compareObj[stnd] == '-') {
						verifyObj[stnd] = '-';
					}
				}

				//합계 만들기
				verifyTotal += verifyObj[stnd] == '-' ? 0 : parseFloat(verifyObj[stnd]);
				compareTotal += compareObj[stnd] == '-' ? 0 : parseFloat(compareObj[stnd]);
			});

			if (verifyList.length > 0) {
				verifyTotal = (Number(verifyTotal) / verifyList.length).toFixed(2);
			}

			if (verifyList.length > 0) {
				compareTotal = (Number(compareTotal) / compareList.length).toFixed(2);
			}

			if (verifyList.length > 0) {
				$('.value_area').eq(0).find('p.value_num').eq(0).text(verifyTotal);
				if (compareList.length > 0) {
					$('.value_area').eq(0).find('p.value_num').eq(1).text((Number(verifyTotal) - Number(compareTotal)).toFixed(2));
				} else {
					$('.value_area').eq(0).find('p.value_num').eq(1).text(verifyTotal);
				}
			} else {
				$('.value_area').eq(0).find('p.value_num').eq(0).text('-');
				if (compareList.length > 0) {
					$('.value_area').eq(0).find('p.value_num').eq(1).text((0 - Number(compareTotal)).toFixed(2));
				} else {
					$('.value_area').eq(0).find('p.value_num').eq(1).text('-');
				}
			}
			if (compareList.length > 0) {
				$('.value_area').eq(1).find('p.value_num').eq(0).text(compareTotal);
				if (verifyList.length > 0) {
					$('.value_area').eq(1).find('p.value_num').eq(1).text((Number(compareTotal) - Number(verifyTotal)).toFixed(2));
				} else {
					$('.value_area').eq(1).find('p.value_num').eq(1).text(compareTotal);
				}
			} else {
				$('.value_area').eq(1).find('p.value_num').eq(0).text('-');
				if (verifyList.length > 0) {
					$('.value_area').eq(1).find('p.value_num').eq(1).text((0 - Number(verifyTotal)).toFixed(2));
				} else {
					$('.value_area').eq(1).find('p.value_num').eq(1).text('-');
				}
			}

			tableData.push(verifyObj); //
			tableData.push(compareObj); //
			$('[id^="table_"]').each(function () {
				setMakeList(tableData, $(this).prop('id'), {'dataFunction': {}});
			});


			if (document.querySelector('[name="compare_formula"]:checked') != null
				&& document.querySelector('[name="compare_criterion"]:checked') != null
				&& !isEmpty(document.querySelector('[name="normality_threshold_lower"]').value)
				&& !isEmpty(document.querySelector('[name="normality_threshold_upper"]').value)) {

				chartMakeData(tableData, standard);
			}
		}
	}

	const benchmarkProcess = (data, type) => {
		const benchmark = $(':radio[name="benchmark"]:checked').val();
		const unit = $(':radio[name="unit"]:checked').val();
		const reference = $('[name="reference"]').val();

		let compDeviceArray = new Array();
		// 비교설비
		$(':checkbox[name="compDevice"]:checked').each(function () {
			compDeviceArray.push($(this).val());
		});

		if (benchmark == undefined) {
			return data.toFixed(2);
		} else {
			if (unit == 'relative') { //상대
				let capacity = 0;
				if (type == 'verify') { //검증
					deviceList.forEach(el => {
						if (el.did == $(':radio[name="deviceNm"]:checked').val()) {
							capacity += Number(el.capacity);
						}
					});
				} else { //비교
					deviceList.forEach(el => {
						if ($.inArray(el.did, compDeviceArray) >= 0) {
							capacity += el.capacity;
						}
					});
				}

				data = data == '-' ? 0 : data;
				let benchmarkValue = (data / (capacity /1000)) * 100;

				if (benchmark == 'up') {
					if (benchmarkValue >= Number(reference)) {
						return '-';
					} else {
						return data.toFixed(2);
					}
				} else {
					if (benchmarkValue <= Number(reference)) {
						return '-';
					} else {
						return data.toFixed(2);
					}
				}
			} else { //절대
				if (benchmark == 'up') {
					if (data >= Number(reference)) {
						return '-';
					} else {
						return data.toFixed(2);
					}
				} else {
					if (data <= Number(reference)) {
						return '-';
					} else {
						return data.toFixed(2);
					}
				}
			}
		}
	}

	const chartMakeData = (tableData, standard) => {
		let seriesData = new Array();
		let refineData = new Array();
		let interval = $('#interval').find('button').data('value');
		let colorArr = ['#5269ef', '#50b5ff', '#26ccc8', '#009389', '#878787'];

		standard.forEach(stand => {
			if (interval == 'day') {
				stand += '000000';
			} else if (interval == 'month') {
				stand += '01000000';
			}

			let verification = eval('tableData[0][' + stand + ']') == '-' ? null : eval('tableData[0][' + stand + ']');
			let compare = eval('tableData[1][' + stand + ']') == '-' ? null : eval('tableData[1][' + stand + ']');

			if (verification != null && typeof (verification) == 'string') {
				verification = parseFloat(verification);
			}

			if (compare != null && typeof (compare) == 'string') {
				compare = parseFloat(compare);
			}

			refineData.push([
				verification, compare
			]);
		});

		let compareFormula = document.querySelector('[name="compare_formula"]:checked').value; //비교식
		let compareCriterion = document.querySelector('[name="compare_criterion"]:checked').value; //비교기준
		let thresholdUpper = document.querySelector('[name="normality_threshold_upper"]').value; //허용치 상한
		let thresholdLower = document.querySelector('[name="normality_threshold_lower"]').value; //허용치 하한

		let dataCode = {
			compare_formula: compareFormula,
			compare_criterion: compareCriterion,
			normality_threshold_upper: Number(thresholdUpper),
			normality_threshold_lower: Number(thresholdLower),
			dt: refineData
		};

		$.ajax({
			url: apiURL + '/energy/normality',
			type: 'post',
			data: JSON.stringify(dataCode),
			dataType: 'json',
			contentType: 'application/json'
		}).done(function (data, textStatus, jqXHR) {
			let seriesArray = new Array();
			if (data.status == 'success') {
				let dataArray = data.data;
				dataArray.forEach((el, index) => {
					let colorOption = '',
						colorBoolean = Boolean(el[3]);
					if (colorBoolean) {
						colorOption = '#26ccc8';
					} else {
						colorOption = '#878787';
					}
					seriesArray.push({
						y: parseFloat(el[2]),
						color: colorOption
					});
				});

				seriesData.push({
					name: '',
					colorByPoint: true,
					data: seriesArray,
					tooltip: {
						valueSuffix: ''
					},
				});

				chartDraw(seriesData, standard);
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});

		//
	}

	/**
	 * 차트 그리기
	 *
	 * @param standard
	 * @param seriesData
	 */
	const chartDraw = function (seriesData, standard) {
		let chart = $('#chart_analysis').highcharts();
		if (chart) {
			chart.destroy();
		}

		let option = {
			chart: {
				renderTo: 'chart_analysis',
				marginLeft: 60,
				marginRight: 20,
				type: 'column',
				backgroundColor: 'transparent',
				height: 470
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
					text: '',
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
				enabled: false,
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
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span> 비교 결과 : ' + Number(point.y).toFixed(2) + point.series.userOptions.tooltip.valueSuffix;
					}, '<b>' + dateFormat(this.x) + '</b>');
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


<div class="row">
	<div class="col-12">
		<h1 class="page-header">이상 분석</h1>
	</div>
</div>
<div class="row">
	<div id="siteList" class="header_drop_area col-lg-2 col-md-4 col-sm-3">
		<div class="dropdown" id="selectSiteList">
			<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택해주세요.">
				선택해주세요.<span class="caret"></span>
			</button>
			<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="siteULList">
				<li data-value="[sid]">
					<a href="javascript:void(0);" tabindex="-1">
						<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
						<label for="site_[INDEX]"><span></span>[name]</label>
					</a>
				</li>
			</ul>
		</div>
	</div>
	<div class="col-lg-10 col-md-8 col-sm-9">
		<div class="compare_area">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle bgN" type="button">
					비교하기<span class="caret"></span>
				</button>
				<ul class="dropdown-menu unused chk_type offset_dropdown">
					<li>
						<div class="compare_bx">
							<div class="bx_row aN2">
								<div class="bx_align">
									<p class="comp_tit type">검증 설비</p>
									<ul class="comp_ul">
										<li>
											<div class="dropdown placeholder" id="typeList">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="설비 유형">
													설비 유형 <span class="caret"></span>
												</button>
												<!-- 라디오 타입 -->
												<ul class="dropdown-menu rdo_type" role="menu" id="typeULList">
													<li data-type="[type]">
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="type_[INDEX]" value="[type]" name="type">
																<label for="type_[INDEX]"><span></span>[name]</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
										<li>
											<div class="dropdown placeholder" id="deviceList">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="설비 명">
													설비 명 <span class="caret"></span>
												</button>
												<!-- 체크박스 타입 -->
												<ul class="dropdown-menu rdo_type" id="deviceName">
													<li data-type="[type]">
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="deviceNm_[INDEX]" name="deviceNm" value="[did]" data-forcasting="[forcasting]" data-metering="[metering]">
																<label for="deviceNm_[INDEX]"><span></span>[siteName] - [name]</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
										<li>
											<div class="dropdown placeholder" id="attrList">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="설비 속성">
													설비 속성 <span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type" role="menu" id="deviceAttribute">
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="attr_[INDEX]" value="[key]" name="attr" data-suffix="[suffix]">
																<label for="attr_[INDEX]"><span></span>[value]</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
									</ul>
								</div>
								<div class="bx_align">
									<p class="comp_tit type">비교 설비</p>
									<ul class="comp_ul">
										<li>
											<div class="dropdown placeholder" id="compareTypeList">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="설비 유형">
													설비 유형 <span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type" role="menu" id="compareTypeULList">
													<li data-type="[type]">
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="compareType_[INDEX]" value="[type]" name="compareType">
																<label for="compareType_[INDEX]"><span></span>[name]</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
										<li>
											<div class="dropdown placeholder" id="compareDeviceList">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="설비 명">
													설비 명 <span class="caret"></span>
												</button>
												<ul class="dropdown-menu chk_type" id="compareDeviceName">
													<li data-type="[type]">
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="checkbox" id="compDeviceNm_[INDEX]" name="compDevice" value="[did]" data-forcasting="[forcasting]" data-metering="[metering]">
																<label for="compDeviceNm_[INDEX]"><span></span>[siteName] - [name]</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
										<li>
											<div class="dropdown placeholder" id="compareAttrList">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="설비 속성">
													설비 속성 <span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type" role="menu" id="compareDeviceAttribute">
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="comp_attr_[INDEX]" value="[key]" name="compAttr" data-suffix="[suffix]">
																<label for="comp_attr_[INDEX]"><span></span>[value]</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
									</ul>
								</div>
							</div>

							<p class="comp_tit type2">제외값</p>
							<div class="bx_row aN3">
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="dropdown placeholder">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="기준">
													기준<span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type">
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="benchmark0" name="benchmark" value="up">
																<label for="benchmark0"><span></span>이상</label>
															</span>
														</a>
													</li>
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="benchmark1" name="benchmark" value="down">
																<label for="benchmark1"><span></span>이하</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
									</ul>
								</div>
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="dropdown placeholder">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="단위">
													단위<span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type">
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="unit0" name="unit" value="relative">
																<label for="unit0"><span></span>%</label>
															</span>
														</a>
													</li>
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="unit1" name="unit" value="absolute">
																<label for="unit1"><span></span>절대값</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
									</ul>
								</div>
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="tx_inp_type">
												<input type="text" id="reference" name="reference" value="" placeholder="기준 값" autocomplete="off" onkeydown="onlyDecimal(event);">
											</div>
										</li>
									</ul>
								</div>
							</div>

							<p class="comp_tit type2">비교 방법</p>
							<div class="bx_row aN2">
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="dropdown placeholder">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="비교식">
													비교식<span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type">
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="comparison0" name="compare_formula" value="point">
																<label for="comparison0"><span></span>POINT</label>
															</span>
														</a>
													</li>
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="comparison1" name="compare_formula" value="cusum">
																<label for="comparison1"><span></span>CUSUM</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
									</ul>
								</div>
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="dropdown placeholder">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="비교 기준">
													비교 기준 <span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type">
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="compare_criterion0" name="compare_criterion" value="absolute">
																<label for="compare_criterion0"><span></span>절대값</label>
															</span>
														</a>
													</li>
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="compare_criterion1" name="compare_criterion" value="relative">
																<label for="compare_criterion1"><span></span>상대값(%)</label>
															</span>
														</a>
													</li>
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="compare_criterion2" name="compare_criterion" value="abs_of_absolute">
																<label for="compare_criterion2"><span></span>abs(절대값)</label>
															</span>
														</a>
													</li>
													<li>
														<a href="javascript:void(0);" tabindex="-1">
															<span class="comp_inp">
																<input type="radio" id="compare_criterion3" name="compare_criterion" value="abs_of_relative">
																<label for="compare_criterion3"><span></span>abs(상대값) %</label>
															</span>
														</a>
													</li>
												</ul>
											</div>
										</li>
									</ul>
								</div>
							</div>
							<div class="bx_row aN2">
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="tx_inp_type">
												<input type="text" id="normality_threshold_lower" name="normality_threshold_lower" value="" placeholder="하한 허용치" autocomplete="off" onkeydown="onlyDecimal(event);">
											</div>
										</li>
									</ul>
								</div>
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="tx_inp_type">
												<input type="text" id="normality_threshold_upper" name="normality_threshold_upper" value="" placeholder="상한 허용치" autocomplete="off" onkeydown="onlyDecimal(event);">
											</div>
										</li>
									</ul>
								</div>
							</div>
							<p class="comp_tit type2">비교 기간</p>
							<div class="bx_row aN2 dateField">
								<div class="sel_calendar">
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="" autocomplete="off" placeholder="시작">
											</li>
										</ul>
									</div>
								</div>
								<div class="sel_calendar">
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<input type="text" id="toDate" name="toDate" class="sel toDate" value="" autocomplete="off" placeholder="종료">
											</li>
										</ul>
									</div>
								</div>
							</div>
							<p class="comp_tit type2">시간 단위</p>
							<div class="bx_row aN2">
								<div class="bx_align">
									<ul class="comp_ul">
										<li>
											<div class="dropdown placeholder" id="interval">
												<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-value="hour" data-name="1시간">
													1시간 <span class="caret"></span>
												</button>
												<ul class="dropdown-menu rdo_type">
													<li data-value="15min"><a href="javascript:void(0);">15분</a></li>
													<li data-value="hour"><a href="javascript:void(0);">1시간</a></li>
													<li data-value="day"><a href="javascript:void(0);">1일</a></li>
													<li data-value="month"><a href="javascript:void(0);">1월</a></li>
												</ul>
											</div>
										</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="comp_btn_wrap">
							<button type="button" class="btn_type" id="renderBtn">확인</button>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-2 col-md-4 col-sm-3">
		<div class="indiv analysis_chart">
			<h2 class="ntit">이상 비교</h2>
			<div class="value_area">
				<h3 class="value_tit2">검증 설비</h3>
				<h3 class="value_tit">평균</h3>
				<p class="value_num"></p>
				<h3 class="value_tit">편차</h3>
				<p class="value_num"></p>
			</div>
			<div class="value_area">
				<h3 class="value_tit2">비교 설비</h3>
				<h3 class="value_tit">평균</h3>
				<p class="value_num"></p>
				<h3 class="value_tit">편차</h3>
				<p class="value_num"></p>
			</div>
		</div>
	</div>
	<div class="col-lg-10 col-md-8 col-sm-9">
		<div class="indiv analysis_chart">
			<div id="chart_analysis"></div>
		</div>
	</div>
</div>
<div class="row pv_chart_table">
	<div class="col-lg-12">
		<div class="indiv clear">
			<div class="tbl_save_bx">
				<a href="javascript:void(0);" class="save_btn">데이터저장</a>
			</div>
			<div class="tbl_top clear">
				<ul class="fr">
					<li><a href="javascript:void(0);" class="fold_btn">표접기</a></li>
				</ul>
			</div>
			<div class="tbl_wrap" id="datatable">
				<div class="fold_div" id="pc_use">
				</div>
			</div>
		</div>
	</div>
</div>