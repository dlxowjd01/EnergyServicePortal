<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	const countryList = new Array();
	const sidoList = new Array();
	let templateList = '', cnt = 0, sectionId = [];

	$(function () {
		setInitList('spcList');

		fnLocation();
		initProcess();
		cloneHtml();
		$('#spcList').on('click', 'li', spcListChange);
		$('#genList').on('click', 'li', genListChange);
		$('#unitPriceList').on('click', 'li', unitPriceListChange);
		$('#recCalcList').find('li a').on('click', function () {
			if ($(this).parent('li').data('value') == 3) {
				$('#recCalcVal').val('-        ')
			} else {

			}
		});

		$('.account-type').each(function(){
			$(this).next().find("li[data-default!='select']").addClass("hidden");
		});

		setInitList('genList');

		initRow('addList_registered_seal');
		addRow('addList_registered_seal');

		initRow('addList_affiliation', 'class');
		addRow('addList_affiliation', 'class');

		initRow('addList_affiliation2', 'class');
		addRow('addList_affiliation2', 'class');

		initRow('addList_payroll_date');
		addRow('addList_payroll_date');

		initRow('addList_commission_payment');
		addRow('addList_commission_payment');

		initRow('addList_interest_pay_date');
		addRow('addList_interest_pay_date');

		initRow('addList_certificate_registration', 'class');
		addRow('addList_certificate_registration', 'class');

		initRow('addList_certificate_registration2', 'class');
		addRow('addList_certificate_registration2', 'class');

		initRow('addList_account_holder', 'class');
		addRow('addList_account_holder', 'class');

		initRow('addList_rental_deduction', 'class');
		addRow('addList_rental_deduction', 'class');

		initRow('addList_module_info');
		addRow('addList_module_info');

		initRow('addList_module_angle');
		addRow('addList_module_angle');

		initRow('addList_inverter');
		addRow('addList_inverter');

		initRow('addList_inverter_vol');
		addRow('addList_inverter_vol');

		initRow('addList_manufacturer');
		addRow('addList_manufacturer');

		initRow('addList_connection');
		addRow('addList_connection');

		initRow('addList_switch_gear');
		addRow('addList_switch_gear');

		initRow('insuranceInfoToggle');
		addRow('insuranceInfoToggle', 'first');
	});

	const fnLocation = () => {
		$.ajax({
			url: apiHost + '/config/view/properties',
			type: 'get',
			async: false,
			data: {types: 'location'},
			success: function (json) {
				let rst = json.location;

				Object.entries(rst).forEach(country => {
					if (country[0] === 'kr') {
						//const lang = isEmpty($('html').attr('lang')) ? 'KO' : $('html').attr('lang');
						const locations = country[1].locations;
						const countryPropName = (langStatus == 'KO') ? country[1].name.kr : country[1].name.en;
						countryList.push({
							code: country[1].code,
							value: countryPropName
						});

						Object.entries(locations).forEach(loc => {
							const locPropName = (langStatus == 'KO') ? loc[1].name.kr : loc[1].name.en;
							sidoList.push({
								code: loc[1].code,
								value: locPropName
							});
						});
					}
				});
			},
			error: function (request, status, error) {}
		});
	}

	$(document).on('keyup', '#전체_용량, #관리_운영비, #대수선비, #사무_수탁비, #임대료', function() {
		financeAuto();
	});

	const autoValArr = ['#관리_운영비', '#대수선비', '#사무_수탁비', '#임대료'];
	const financeAuto = () => {
		autoValArr.forEach(autoId => {
			let autoVal = Number($(autoId).val()) / Number($('#전체_용량').val());
			if (isNaN(autoVal) || !isFinite(autoVal)) {
				$(autoId).parent().next().find('.auto_price').text('');
			} else {
				$(autoId).parent().next().find('.auto_price').text(numberComma(autoVal.toFixed(2)));
			}
		});
	}

	function cloneHtml() {
		templateList = $("#addList_insuranceInfo").find("template.copy_list").clone().html();
		$("#addList_insuranceInfo").find("template.copy_list").remove();

	}

	function initProcess() {
		initAddListHtml(); //추가 기능 관련 초기화
		setComboBoxData(); //시도 설정
		getSpcData();//SPC명 설정
	}

	function initAddListHtml() {
		$(".addList_account_holder").data("form", $(".addList_account_holder").html()).data("count", ($(".addList_account_holder").html().match(/input/g) || []).length);
		$(".addList_affiliation").data("form", $(".addList_affiliation").html()).data("count", ($(".addList_affiliation").html().match(/input/g) || []).length);
		$("#addList_registered_seal").data("form", $("#addList_registered_seal").html()).data("count", ($("#addList_registered_seal").html().match(/input/g) || []).length);


		// $("#addList_insuranceInfo").data("form", $("#addList_insuranceInfo").html()).data("count", ($("#addList_insuranceInfo").html().match(/input/g) || []).length);
		$("#addList_interest_pay_date").data("form", $("#addList_interest_pay_date").html()).data("count", ($("#addList_interest_pay_date").html().match(/input/g) || []).length);
		$("#addList_payroll_date").data("form", $("#addList_payroll_date").html()).data("count", ($("#addList_payroll_date").html().match(/input/g) || []).length);
		$("#addList_commission_payment").data("form", $("#addList_commission_payment").html()).data("count", ($("#addList_commission_payment").html().match(/input/g) || []).length);
		$(".addList_certificate_registration").data("form", $(".addList_certificate_registration").html()).data("count", ($(".addList_certificate_registration").html().match(/input/g) || []).length);

		$("#addList_module_info").data("form", $("#addList_module_info").html()).data("count", ($("#addList_module_info").html().match(/input/g) || []).length);
		$("#addList_module_angle").data("form", $("#addList_module_angle").html()).data("count", ($("#addList_module_angle").html().match(/input/g) || []).length);
		$("#addList_inverter").data("form", $("#addList_inverter").html()).data("count", ($("#addList_inverter").html().match(/input/g) || []).length);
		$("#addList_inverter_vol").data("form", $("#addList_inverter_vol").html()).data("count", ($("#addList_inverter_vol").html().match(/input/g) || []).length);
		$("#addList_manufacturer").data("form", $("#addList_manufacturer").html()).data("count", ($("#addList_manufacturer").html().match(/input/g) || []).length);
		$("#addList_connection").data("form", $("#addList_connection").html()).data("count", ($("#addList_connection").html().match(/input/g) || []).length);
		$("#addList_switch_gear").data("form", $("#addList_switch_gear").html()).data("count", ($("#addList_switch_gear").html().match(/input/g) || []).length);

		$(".addList_account_holder").data("form", $(".addList_account_holder").html());
		$(".addList_affiliation").data("form", $(".addList_affiliation").html());
		$("#addList_registered_seal").data("form", $("#addList_registered_seal").html());


		// $("#addList_insuranceInfo").data("form", $("#addList_insuranceInfo").html());
		$("#addList_interest_pay_date").data("form", $("#addList_interest_pay_date").html());
		$("#addList_payroll_date").data("form", $("#addList_payroll_date").html());
		$("#addList_commission_payment").data("form", $("#addList_commission_payment").html());
		$(".addList_certificate_registration").data("form", $(".addList_certificate_registration").html());

		$("#addList_module_info").data("form", $("#addList_module_info").html());
		$("#addList_module_angle").data("form", $("#addList_module_angle").html());
		$("#addList_inverter").data("form", $("#addList_inverter").html());
		$("#addList_inverter_vol").data("form", $("#addList_inverter_vol").html());
		$("#addList_manufacturer").data("form", $("#addList_manufacturer").html());
		$("#addList_connection").data("form", $("#addList_connection").html());
		$("#addList_switch_gear").data("form", $("#addList_switch_gear").html());
	}

	function removeList(obj, type) {
		if (isEmpty(type)) {
			if ($(obj).parent().parent().find('.group_type').length > 1) {
				$(obj).parent().remove();
			}
		} else {
			if ($(obj).parents('.entity').find('.group_type').length > 1) {
				var index = $(obj).parents('.entity').find('.group_type').index($(obj).parent().parent());
				$(obj).parents('tr').find('.entity').eq(0).find('.group_type').eq(index).remove();
				$(obj).parent().parent().remove();
			}
		}
	}

	function setDropDownValue(id, data) {
		// console.log("id===", id, "data===0", data)
		var $selector = $("#" + id);
		$selector.find("li").each(function () {
			if ($(this).text() == data) {
				$selector.parents('.dropdown').find('button').html(data + '<span class="caret"></span>').data('value', data);
				return false;
			}
		});
	}

	function spcListChange() {
		var txt = $(this).find('a').text(),
			idx = $('#spcList').find('li').index(this),
			jsonData = $('#spcList').data('gridJsonData')[idx],
			disabledInput = $('#name').parents('.tx_inp_type.edit');

		if (jsonData.spc_id == "") {
			$('#spcName').val('').prop('readonly', false);
			disabledInput.removeClass('disabled');
		} else {
			$('#spcName').val(jsonData['name']).prop('readonly', true);
			disabledInput.addClass('disabled');
		}
	}

	function genListChange() {
		var txt = $(this).find("a").text(),
			idx = $("#genList").find("li").index(this),
			jsonData = $("#genList").data("gridJsonData")[idx],
			disabledInput = $("#name").parents(".tx_inp_type.edit");

		disabledInput.addClass("disabled");
		$("#genName").val(jsonData.name);

		//$("#countryValue").val(jsonData["countryValue"]);
		//setDropDownValue("countryList", jsonData["countryValue"]);
		if (isEmpty(jsonData.address) && isEmpty(jsonData.location)) {
			$('#발전소_국가 button').html("국가 선택" + '<span class="caret"></span>');
			$('#발전소_시도 button').html('시/도 선택' + '<span class="caret"></span>');
			$("#발전소_상세주소").val('');
		} else {
			$('#발전소_국가 button').html("대한민국" + '<span class="caret"></span>').data('value', '대한민국');
			$('#발전소_시도 button').html(jsonData.location + '<span class="caret"></span>').data('value', jsonData.location);
			$("#발전소_상세주소").val(jsonData.address);
		}

		if (jsonData.gen_id == "" || $(this).data("value") == "") {
			$("#genName").prop("readonly", false).val('');
		} else {
			$("#genName").prop("readonly", true);
		}
	}

	// function countryListChange() {
	// 	var txt = $(this).find("a").text(),
	// 		idx = $("#countryList").find("li").index(this);
	//
	// 	if (txt != "대한민국") {
	// 		setMakeList([], "sidoList", {"dataFunction": {}});
	// 	} else {
	// 		setMakeList(sidoList, "sidoList", {"dataFunction": {}});
	// 	}
	//
	// 	$("#countryValue").val(txt);
	// }
	//
	// function sidoListChange() {
	// 	var txt = $(this).find("a").text(),
	// 		idx = $("#sidoList").find("li").index(this);
	//
	// 	$("#sidoValue").val(txt);
	// }

	function unitPriceListChange() {
		var txt = $(this).find("a").text(),
			idx = $("#unitPriceList").find("li").index(this);

		$("#기준_단가").val(txt);
	}

	function getSpcData() {
		const spcSearch = {
			url: apiHost + '/spcs',
			type: 'get',
			async: false,
			data: {oid: oid}
		}

		const spcAuthority = {
			url: apiHost + '/config/user_spcs?oid=' + oid,
			type: 'get',
			async: false,
			data: {user_ids: userInfoId}
		};

		if (role != 1) {
			$.when($.ajax(spcSearch), $.ajax(spcAuthority)).done(function(result1, result2) {
				if (result1[1] === 'success' && result2[1] === 'success') {
					const spcList = result1[0].data;
					const spcAuth = result2[0].data;
					let refineSpcList = new Array();

					if (!isEmpty(spcAuth) && !isEmpty(spcList)) {
						spcList.forEach(spc => {
							const spcListId = spc.spc_id;
							spcAuth.forEach(auth => {
								if (spcListId == auth.spcid) {
									if (auth.role == 1) {
										refineSpcList.push(spc);
									} else {
										return false;
									}
								}
							});
						});
					}

					refineSpcList.push({spc_id: '', name: '직접입력'});
					setMakeList(refineSpcList, 'spcList', {'dataFunction': {}});
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("optSite error===", jqXHR)
				return false;
			});
		} else {
			$.ajax(spcSearch).done(function (data, textStatus, jqXHR) {
				data.data.push({spc_id: '', name: '직접입력'});

				setMakeList(data.data, 'spcList', {'dataFunction': {}});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}
	}

	function getgenIdData() {
		if (role == 1) {
			$.ajax({
				url: apiHost + '/config/sites/',
				type: 'get',
				async: false,
				data: {oid: oid},
				success: function (json) {
					let spcGens = new Array();
					if (!isEmpty(json)) {
						spcGens = json;
					}

					spcGens.push({sid: '', name: '직접입력', location: '', address: ''});
					setMakeList(spcGens, 'genList', {'dataFunction': {}});

				},
				error: function (request, status, error) {

				}
			});
		} else {
			let spcGens = Array.from(siteList);
			spcGens.push({sid: '', name: '직접입력', location: '', address: ''});
			setMakeList(spcGens, 'genList', {'dataFunction': {}});
		}
	}

	function setComboBoxData() {
		setInitList('spcCountryList');
		setMakeList(countryList, 'spcCountryList', {'dataFunction': {}});

		setInitList('countryList');
		setMakeList(countryList, 'countryList', {'dataFunction': {}});

		setInitList("spcSidoList");
		setMakeList(sidoList, 'spcSidoList', {'dataFunction': {}});

		setInitList('sidoList');
		setMakeList(sidoList, 'sidoList', {'dataFunction': {}});
	}

	function setSaveData() {
		const spcId = $('#spcId button').data('value'),
			spcName = $('#spcName').val(),
			genId = $('#genId button').data('value'),
			genName = $('#genName').val();

		// if (isEmpty(spcId)) {
		// 	alert('SPC명을 선택하세요.');
		// 	return false;
		// }

		if (isEmpty(genId) && isEmpty(genName)) {
			alert('발전소를 선택하세요.');
			return false;
		}

		if (isEmpty(genId)) {
			if (isEmpty($('#발전소_시도 button').data('value')) || isEmpty($('#발전소_상세주소').val())) {
				alert('발전소 신규 입력시에는 주소가 필수 입니다.');
				return false;
			}

			let bError = false;
			$.ajax({
				url: apiHost + '/config/sites?oid=' + oid,
				type: 'post',
				dataType: 'json',
				async: false,
				contentType: 'application/json',
				data: JSON.stringify({
					name: $('#genName').val(),
					location: $('#발전소_시도 button').data('value'),
					address: $('#발전소_상세주소').val(),
					resource_type: 0
				}),
				success: function (json) {
					$('#genId button').data('value', json.sid);
				},
				error: function (request, status, error) {
					alert('처리 중 오류가 발생했습니다.');
					bError = true;
					return false;
				}
			});

			if (bError) {
				return false;
			}
		}

		$.ajax({
			url: apiHost + '/spcs',
			type: 'get',
			async: true,
			data: {'oid': oid, includeGens: true},
			success: function (result) {
				let checkCountSpc = 0, checkCountGen = 0;

				for (let i = 0, count = result.data.length; i < count; i++) {
					let rowData = result.data[i];
					let spcGensList = rowData.spcGens;

					if (rowData.name == spcName && spcId == '') {
						checkCountSpc++;
						break;
					}

					if (spcGensList !== undefined && spcGensList.length > 0) {
						for (let j = 0, jcount = spcGensList.length; j < jcount; j++) {
							if (genId == spcGensList[j].gen_id) {
								checkCountGen++;
								break;
							}
						}
					}
				}

				if (checkCountSpc > 0) {
					alert('중복되는 SPC명이 존재 합니다.');
					return false;
				}

				if (checkCountGen > 0) {
					alert('SPC에 등록된 발전소 입니다.');
					return false;
				}

				$('#sendSpcPostModal').modal(); // 처리중 모달띄우기

				//신규 spc 일떄..
				if (isEmpty(spcId)) {
					sendSpcPost('post');
				} else {
					sendSpcPost('patch');
				}
			},
			error: function (request, status, error) {
				alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
				return false;
			}
		});
	}

	function sendSpcPost(type) {
		const spc_info = setAreaParamData('basicInfo', 'dropdown'),
			genId = $('#genId button').data('value'),
			spcId = $('#spcId button').data('value');
		let ajaxUrl = '';

		if (type == 'post') {
			ajaxUrl = apiHost + '/spcs?oid=' + oid;
		} else {
			ajaxUrl = apiHost + '/spcs/' + spcId + '?oid=' + oid;
		}

		$('#basicForm').find('input[type="file"]').each(function () {
			$(this).attr('name', this.name + '_' + genUuid());
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: apiHost + '/files/upload?oid=' + oid,
			data: new FormData($('#basicForm')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			async: false,
			success: function (result) {
				let resultFiles = result.files;
				resultFiles.forEach(function (el) {
					let fieldname = el.fieldname;
					$('#basicForm').find('input[type="file"]').each(function () {
						if (fieldname == $(this).attr('name')) {
							let button = $(this).parents('div.group_type').find('.dropdown').find('button').data('value');
							el['SPC_법인_인감_유형'] = button;
						}
					});
				});

				spc_info['SPC_법인_인감'] = resultFiles;
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});

		if ($(':radio[name="SPC_법인_인감_대표"]:checked').val() != undefined) {
			spc_info['spcSealSelected'] = $(':radio[name="SPC_법인_인감_대표"]:checked').val();
		}

		$.ajax({
			url: ajaxUrl,
			type: type,
			dataType: 'json',
			async: true,
			contentType: 'application/json',
			data: JSON.stringify({
				name: $('#spcName').val(),
				spc_info: JSON.stringify(spc_info),
				updated_by: loginId
			}),
			success: function (json) {
				sendSpcAttchFilePost(json.data[0].spc_id);
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function sendSpcAttchFilePost(spcId) {
		var genId = $("#genId button").data('value');

		let existFileList = new Array();
		$('#attachement_info').find('input[type="file"]').each(function () {
			const liList =$(this).parent().find('.file_list li');
			let fileList = Array.from($(this)[0].files);

			liList.each(function(index, target) {
				loopFile(target, index, fileList);
			});

			if (fileList.length > 0) {
				let formData = new FormData($('#fileUploadForm')[0]),
					filedName = $(this).attr('name') + '_' + genUuid();
				fileList.forEach(function(file) {
					formData.append(filedName, file);
				});

				$.ajax({
					url: apiHost + '/files/upload?oid=' + oid,
					type: 'patch',
					enctype: 'multipart/form-data',
					data: formData,
					processData: false,
					contentType: false,
					cache: false,
					timeout: 600000,
					async: false,
					success: function (result) {
						existFileList = existFileList.concat(result.files);
					},
					error: function (request, status, error) {
						alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
					}
				});
			}
		});

		sendSpcGenPost(spcId, existFileList);
	}

	/**
	 *
	 * maintenanceInfo - 관리 운영 정보
	 * accountInfo - 계정 정보
	 * financeInfo - 금융 정보
	 * contractInfo - 계약 정보
	 * insuranceInfo - 보험 정보
	 * deviceInfo - 설비 정보
	 * warrantyInfo - 보증 정보
	 * coefficientInfo - 환경 정보
	 * associatedInfo - 관련 정보
	 * attachement_info - 첨부 파일
	 *
	 * @param spcId
	 * @param files
	 */
	function sendSpcGenPost(spcId, files) {
		var genId = $("#genId button").data("value");
		var address_info = setAreaParamData('addressInfo', 'dropdown'),
			maintenance_info = setAreaParamData('maintenanceInfo', 'dropdown'),
			account_info = setAreaParamData('accountInfo'),
			finance_info = setAreaParamData('financeInfo', 'dropdown'),
			contract_info = setAreaParamData('contractInfo'),
			addlist_insurance_info = setAreaParamData('insuranceInfo'),
			device_info = setAreaParamData('deviceInfo'),
			warranty_info = setAreaParamData('warrantyInfo', 'dropdown'),
			coefficient_info = setAreaParamData('coefficientInfo'),
			associated_info = setAreaParamData('associatedInfo'),
			attachement_info = files;

		let certificationFiles = new Array();
		$('#financeInfo').find('input[type="file"]').each(function () {
			const liList =$(this).parent().find('.file_list li:not(.existing)');
			let fileList = Array.from($(this)[0].files);

			liList.each(function(index, target) {
				loopFile(target, index, fileList);
			});

			if (fileList.length > 0) {
				let formData = new FormData($('#fileUploadForm')[0]),
					filedName = $(this).attr('name') + '_' + genUuid();
				fileList.forEach(function(file) {
					formData.append(filedName, file);
				});

				$.ajax({
					url: apiHost + '/files/upload?oid=' + oid,
					type: 'patch',
					enctype: 'multipart/form-data',
					data: formData,
					processData: false,
					contentType: false,
					cache: false,
					timeout: 600000,
					async: false,
					success: function (result) {
						let resultFiles = result.files;
						resultFiles.forEach(function (el) {
							let fieldname = el.fieldname;
							$('#financeInfo').find('input[type="file"]').each(function () {
								if (fieldname.match($(this).attr('name'))) {
									let button = $(this).parents('div.group_type').find('.dropdown').find('button').data('value');
									el['용도'] = button;
								}
							});
						});
						certificationFiles = certificationFiles.concat(resultFiles);
						finance_info['공인인증서'] = certificationFiles;
					},
					error: function (request, status, error) {
						alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
					}
				});
			}
		});

		Object.entries(finance_info).map(obj => {
			if (obj[0].match('은행_리스트') && obj[1] == '직접입력') {
				const idx = obj[0].replace(/[^0-9]/g, ''),
					bnkName = finance_info['은행_직접입력' + idx];
				finance_info[obj[0]] = bnkName;
			}
		});

		$.ajax({
			url: apiHost + '/spcs/' + spcId + '/gens?oid=' + oid + '&gen_id=' + genId,
			type: 'post',
			async: true,
			contentType: 'application/json',
			data: JSON.stringify({
				address: JSON.stringify(address_info),
				contract_info: JSON.stringify(contract_info),
				device_info: JSON.stringify(device_info),
				finance_info: JSON.stringify(finance_info),
				warranty_info: JSON.stringify(warranty_info),
				coefficient_info: JSON.stringify(coefficient_info),
				attachement_info: JSON.stringify(attachement_info),
				associated_info: JSON.stringify(associated_info),
				maintenance_info: JSON.stringify(maintenance_info),
				addlist_insurance_info: JSON.stringify(addlist_insurance_info),
				account_info: JSON.stringify(account_info),
				updated_by: loginId,
				del_yn: 'N'
			}),
			success: function (json) {
				alert("등록되었습니다.");
				goMoveList();
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function loopFile(target, index, fileList) {
		if (fileList[index] != undefined) {
			if (target.textContent.trim() != fileList[index].name) {
				fileList.splice(index, 1);
				loopFile(target, index, fileList);
			}
		}
	}

	function goMoveList() {
		location.href = "/spc/entityInformation.do";
	}

	function addDatePicker() {
		$(document).find('.fromDate').removeClass('hasDatepicker').datepicker({
			showOn: "both",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function (selectedDate) {
				$(this).closest('.dateField').find('.toDate').datepicker('option', 'minDate', selectedDate);

				if (typeof afterDatePick == 'function') {
					afterDatePick($(this).attr('name'));
				}
			}
		});

		$(document).find('.toDate').removeClass('hasDatepicker').datepicker({
			showOn: "both",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function (selectedDate) {
				$(this).closest('.dateField').find('.fromDate').datepicker('option', 'maxDate', selectedDate);

				if (typeof afterDatePick == 'function') {
					afterDatePick($(this).attr('name'));
				}
			}
		});

		$(document).find('.datepicker').removeClass('hasDatepicker').datepicker({
			showOn: "both",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function (selectedDate) {
				if (typeof afterDatePick == 'function') {
					afterDatePick($(this).attr('name'));
				}
			}
		});
	}

	function afterDatePick(thisName) {
		let idx = thisName.replace(/[^0-9]/g, '');
		if (thisName.match('보험_시작일')) {
			let open = $('#' + thisName).datepicker('getDate'),
				close = $('#보험_종료일' + idx).datepicker('getDate'),
				expiry = $('#보험_만기일' + idx).datepicker('getDate');

			//보험 종료일 차이 구하기
			if (close != null && open != null) {
				let diff = dateDiff(close, open, 'day');
				$('#보험_종료일' + idx).parent().next('span').html(diff + '일 남음');
				$('#보험_종료일_차이' + idx).val(diff + '일 남음');
			}

			//보험 만료일 차이 구하기
			if (expiry != null && open != null) {
				let diff = dateDiff(expiry, open, 'day');
				$('#보험_만기일' + idx).parent().next('span').html(diff + '일 남음');
				$('#보험_만기일_차이' + idx).val(diff + '일 남음');
			}
		} else if (thisName.match('보험_종료일')) {
			let close = $('#' + thisName).datepicker('getDate'),
				open = $('#보험_시작일' + idx).datepicker('getDate');

			//보험 종료일 차이 구하기
			if (close != null && open != null) {
				let diff = dateDiff(close, open, 'day');
				$('#' + thisName).parent().next('span').html(diff + '일 남음');
				$('#보험_종료일_차이' + idx).val(diff + '일 남음');
			}
		} else if (thisName.match('보험_만기일')) {
			let expiry = $('#' + thisName).datepicker('getDate'),
				open = $('#보험_시작일' + idx).datepicker('getDate');

			//보험 종료일 차이 구하기
			if (expiry != null && open != null) {
				let diff = dateDiff(expiry, open, 'day');
				$('#' + thisName).parent().next('span').html(diff + '일 남음');
				$('#보험_만기일_차이' + idx).val(diff + '일 남음');
			}
		}
		// else if (thisName == '공사_계약_정보_약정일') {
		// 	let close = $('#' + thisName).datepicker('getDate');
		// 		close.setFullYear(close.getFullYear() + 1);
		// 	let diff = dateDiff(close, new Date(), 'day')
		//
		// 	$('#인출_가능_기한').val(close.format('yyyy-MM-dd'));
		// 	$('#인출_가능_남은일').html(Math.floor(diff) + '&nbsp;&nbsp;남음');
		// }
	}

	const sumUnpaid = () => {
		const contractPay = Number($('#도급_계약서_공사_계약_금액').val().replace(/[^0-9]/g, '')),
			agreementPay = Number($('#약정_금액').val().replace(/[^0-9]/g, '')),
			paymentsFirst = Number($('#지급금액_1차').val().replace(/[^0-9]/g, '')),
			paymentsSecond = Number($('#지급금액_2차').val().replace(/[^0-9]/g, '')),
			paymentsThird = Number($('#지급금액_3차').val().replace(/[^0-9]/g, ''));

		const sumUnPaidPay = contractPay + agreementPay - paymentsFirst - paymentsSecond - paymentsThird;
		$('#미지급_금액').text(numberComma(sumUnPaidPay));
	}

	function rtnDropdown($dropdownId) {
		if($dropdownId == 'spcId') {
			getgenIdData();
		} else if ($dropdownId.match('은행_리스트')) {
			const target = $('#' + $dropdownId),
				targetInput = target.parents('td').find('[id^=은행_직접입력]');
			if (target.find('button').data('value') == '직접입력') {
				targetInput.parent().removeClass('hidden');
			} else {
				targetInput.parent().addClass('hidden');
				targetInput.val('');
			}
		} else if ($dropdownId.match('입출금_구분')) {
			const buttonIdx = $dropdownId.replace(/[^0-9]/g, ''),
				target = $('#계좌구분리스트' + buttonIdx);
			let item = target.find('li[data-group]');
			let accBtn = target.prev('.dropdown-toggle');
			accBtn.html('선택<span class="caret"></span>');
			item.addClass('hidden');

			target.find("li[data-default]").hide();

			if($('#' + $dropdownId + ' button').data('value')=='입금'){
				item.not('[data-group="출금"]').removeClass("hidden");
			} else {
				item.not('[data-group="입금"]').removeClass("hidden");
			}
		}
	}
</script>

<!-- Modal (처리 중 모달)-->
<div id="sendSpcPostModal" class="modal fade" role="dialog">
	<div class="modal-dialog his_alarm">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit" style="text-align: center;">처리중...</h2>
			</div>
		</div>
	</div>
</div>

<div class="row entity_wrap_header">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 신규 등록</h1>
	</div>
</div>

<form id="upload" name="upload" method="multipart/form-data"></form>

<div class="row entity_wrap post panel-group" id="accordion">
	<div class="col-12">
		<div class="indiv panel panel-default" id="basicInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">기본 정보</h2>
				<a role="button" href="#basicInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="basicInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<form id="basicForm" name="basicForm" class="mt-25">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>SPC명</th>
							<td class="group_type">
								<div class="dropdown placeholder edit" id="spcId">
									<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown">
										SPC<span class="caret"></span>
									</button>
									<ul id="spcList" class="dropdown-menu" role="menu">
										<li data-value="[spc_id]"><a href="javascript:void(0);">[name]</a></li>
									</ul>
								</div>
								<div class="tx_inp_type edit disabled">
									<label for="spcName" class="sr-only">SPC명 입력</label>
									<input type="text" id="spcName" name="spcName" placeholder="SPC명 입력" readonly>
								</div>
							</td>
							<th><label for="대표자">대표자</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="대표자" name="대표자" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="사업자등록번호">사업자등록번호</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="사업자등록번호" name="사업자등록번호" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="법인등록번호">법인등록번호</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="법인등록번호" name="법인등록번호" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>주소</th>
							<td class="group_type">
								<div class="dropdown placeholder edit" id="spcCountry">
									<button type="button" class="dropdown-toggle underline w-100" data-toggle="dropdown">
										국가 선택<span class="caret"></span>
									</button>
									<ul id="spcCountryList" class="dropdown-menu" role="menu">
										<li data-value="[value]">
											<a href="javascript:void(0);">[value]</a>
										</li>
									</ul>
								</div>
								<div class="dropdown placeholder edit mr-12" id="spcSido">
									<button type="button" class="dropdown-toggle underline w-100" data-toggle="dropdown">
										시/도 선택<span class="caret"></span>
									</button>
									<ul id="spcSidoList" class="dropdown-menu" role="menu">
										<li data-value="[code]">
											<a href="javascript:void(0);">[value]</a>
										</li>
									</ul>
								</div>
							</td>
							<th><label for="spcAddress">상세 주소</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="spcAddress" name="spcAddress" placeholder="상세 주소">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="사업명">사업명</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="사업명" name="사업명" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="펀드명">펀드명</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="펀드명" name="펀드명" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="금융사">금융사</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="금융사" name="금융사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="금융사_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="금융사_담당자(연락처)" name="금융사_담당자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="시공사">시공사</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="시공사" name="시공사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="시공사_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="시공사_담당자(연락처)" name="시공사_담당자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="사무수탁사">사무수탁사</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="사무수탁사" name="사무수탁사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="사무수탁사_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="사무수탁사_담당자(연락처)" name="사무수탁사_담당자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="관리_운영사">관리 운영사</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="관리_운영사" name="관리_운영사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="발전_관리자(연락처)">발전 관리자(연락처)</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="발전_관리자(연락처)" name="발전_관리자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th></th>
							<td></td>
							<th><label for="사업_관리자(연락처)">사업 관리자(연락처)</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="사업_관리자(연락처)" name="사업_관리자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th class="group_type">SPC 법인 인감
								<a href="javascript:addRow('addList_registered_seal');" class="btn_add fr">추가</a>
							</th>
							<td id="addList_registered_seal" class="entity">
								<div class="group_type">
									<div class="dropdown placeholder edit" id="spcSeal[index]">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown">
											인감 선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="사용_인감">
												<a href="javascript:void(0);">사용 인감</a>
											</li>
											<li data-value="법인_인감">
												<a href="javascript:void(0);">법인 인감</a>
											</li>
										</ul>
									</div>
									<div class="fixed_height">
										<input type="file" id="SPC_법인_인감_파일[index]" class="hidden" name="SPC_법인_인감_파일" accept=".jpg, .png, .pdf">
										<label for="SPC_법인_인감_파일[index]" class="btn file_upload">파일 선택</label>
										<span class="upload_text ml-16"></span>
										<span class="rdo_type">
											<input type="radio" id="SPC_법인_인감_대표[index]" name="SPC_법인_인감_대표" value="[index]">
											<label for="SPC_법인_인감_대표[index]">대표 인감</label>
										</span>
										<button type="button" class="btn_close fixed_height hidden mt-0" onclick="$(this).parents().closest('.group_type').remove()"></button>
									</div>
								</div>
							</td>
							<th></th>
							<td>
								<div class="fixed_height"></div>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>

		<div class="indiv panel panel-default" id="addressInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">발전소 정보</h2>
				<a role="button" href="#addressInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="addressInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="genName">발전소명</label></th>
						<td class="group_type">
							<div class="dropdown placeholder edit" id="genId">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="발전소명 선택">
									발전소명 선택<span class="caret"></span>
								</button>
								<ul id="genList" class="dropdown-menu" role="menu">
									<li data-value="[sid]">
										<a href="javascript:void(0);">[name]</a>
									</li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="genName" name="power_plant_name" placeholder="발전소명 입력">
							</div>
						</td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td class="group_type">
							<div class="dropdown placeholder edit" id="발전소_국가">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown">
									국가 선택<span class="caret"></span>
								</button>
								<ul id="countryList" class="dropdown-menu" role="menu">
									<li data-value="[value]">
										<a href="javascript:void(0);">[value]</a>
									</li>
								</ul>
							</div>
							<div class="dropdown placeholder edit mr-12" id="발전소_시도">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown">
									시/도 선택<span class="caret"></span>
								</button>
								<ul id="sidoList" class="dropdown-menu" role="menu">
									<li data-value="[code]">
										<a href="javascript:void(0);">[value]</a>
									</li>
								</ul>
							</div>
						</td>
						<th><label for="발전소_상세주소">상세 주소</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="발전소_상세주소" name="발전소_상세주소" placeholder="상세 주소">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="maintenanceInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">관리 운영 정보</h2>
				<a href="#maintenanceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="maintenanceInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>설치 용량</th>
						<td>
							<fieldset>
								<legend class="sr-only">설치 용량 및 설치 용량 기타</legend>
								<div class="group_type">
									<div class="tx_inp_type edit unit t1">
										<input type="text" id="설치_용량" name="설치_용량" placeholder="설치용량">
										<span>kW</span>
									</div>
									<div class="tx_inp_type edit">
										<input type="text" id="설치_용량_기타" name="설치_용량_기타" placeholder="태양광">
									</div>
								</div>
							</fieldset>
						</td>
						<th>관리 운영 기간</th>
						<td>
							<fieldset class="sel_calendar edit twin clear dateField">
								<legend class="sr-only">관리 운영 기간</legend>
								<input type="text" id="관리_운영_기간_from" name="관리_운영_기간_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="관리_운영_기간_to" name="관리_운영_기간_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="기상_관측_지점">기상 관측 지점</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="기상_관측_지점" name="기상_관측_지점" placeholder="직접 입력">
							</div>
						</td>
						<th>하자 보증기간(전기)</th>
						<td>
							<fieldset class="sel_calendar edit twin clear dateField">
								<legend class="sr-only">하자 보증기간(전기)</legend>
								<input type="text" id="하자_보증기간(전기)_from" name="하자_보증기간(전기)_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="하자_보증기간(전기)_to" name="하자_보증기간(전기)_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="사용_전_검사_완료일">사용 전 검사 완료일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="사용_전_검사_완료일" name="사용_전_검사_완료일" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th>하자 보증기간(토목)</th>
						<td>
							<fieldset class="sel_calendar edit twin clear dateField">
								<legend class="sr-only">하자 보증기간(토목)</legend>
								<input type="text" id="하자_보증기간(토목)_from" name="하자_보증기간(토목)_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="하자_보증기간(토목)_to" name="하자_보증기간(토목)_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
					</tr>

					<tr>
						<th>
							<span class="">등기이사 소속</span>
							<a href="javascript:addRow('addList_affiliation', 'class');addRow('addList_affiliation2', 'class');" class="btn_add fr">추가</a>
						</th>
						<td class="addList_affiliation entity">
							<div class="group_type">
								<div class="dropdown placeholder edit" id="등기이사_소속[index]">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown">
										소속 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk_type" role="menu">
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="등기이사_소속0_[index]" value="사내_이사" name="등기이사_소속_[index]">
												<label for="등기이사_소속0_[index]">사내 이사</label>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="등기이사_소속1_[index]" value="사외_이사" name="등기이사_소속_[index]">
												<label for="등기이사_소속1_[index]">사외 이사</label>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="등기이사_소속2_[index]" value="대표_이사" name="등기이사_소속_[index]">
												<label for="등기이사_소속2_[index]">대표 이사</label>
											</a>
										</li>
									</ul>
								</div>
								<div class="tx_inp_type edit">
									<label for="등기이사_명[index]" class="sr-only"></label>
									<input type="text" id="등기이사_명[index]" name="등기이사_명[index]" placeholder="이름 직접 입력">
								</div>
							</div>
						</td>
						<th>등기 기간</th>
						<td class="addList_affiliation2 entity">
							<div class="group_type flex_start">
								<fieldset class="sel_calendar edit twin clear dateField">
									<legend class="sr-only">등기 기간</legend>
									<input type="text" id="등기_기간_from[index]" name="등기_기간_from[index]" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
									<input type="text" id="등기_기간_to[index]" name="등기_기간_to[index]" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
								</fieldset>

								<div class="fr fixed_height mt5 mr-12">
									<button type="button" class="btn_close hidden" onclick="removeList(this, 'dual')"></button>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="계약_단가">계약 단가</label></th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="계약_단가" name="계약_단가" placeholder="직접 입력">
								<span>원</span>
							</div>
						</td>
						<th>상업 운전 개시일</th>
						<td>
							<fieldset class="sel_calendar edit twin clear dateField">
								<legend class="sr-only">상업 운전 개시일</legend>
								<input type="text" id="상업_운전_개시일" name="상업_운전_개시일" class="sel toDate" value="" autocomplete="off" placeholder="상업 운전 개시일" readonly>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="부지소유">부지 소유 / 임대 구분</label></th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="부지 소유 혹은 임대 구분"></legend>
								<div class="radio_group">
									<input type="radio" id="부지소유" name="부지소유/임대구분" value="부지소유">
									<label for="부지소유">소유</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="임대구분" name="부지소유/임대구분" value="임대구분">
									<label for="임대구분">임대</label>
								</div>
							</fieldset>
						</td>
						<th>개발행위필증 교부 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="개발행위필증 교부 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="개발행위필증_교부" name="개발행위필증_교부_여부" value="교부">
									<label for="개발행위필증_교부">교부함</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="개발행위필증_미교부" name="개발행위필증_교부_여부" value="미교부">
									<label for="개발행위필증_미교부">해당 없음</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>지상권 및 지상권부근저당 설정 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="지상권 및 지상권부근저당 설정 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="지상권" name="지상권설정여부" value="지상권">
									<label for="지상권">지상권</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="지상권부근저당" name="지상권설정여부" value="지상권부근저당">
									<label for="지상권부근저당">지상관부근저당</label>
								</div>
							</fieldset>
						</td>
						<th>동산담보표지판 설정 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="동산담보표지판 설정 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="동산담보표지판_설정" name="동산담보표지판_설정_여부" value="동산담보표지판_설정">
									<label for="동산담보표지판_설정">설정함</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="동산담보표지판_미설정" name="동산담보표지판_설정_여부" value="동산담보표지판_미설정">
									<label for="동산담보표지판_미설정">해당 없음</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>자가부지공장근저당 목록 설정 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="자가부지공장근저당 목록 설정 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="자가부지공장근저당_설정" name="자가부지공장근저당" value="자가부지공장근저당_설정">
									<label for="자가부지공장근저당_설정">설정함</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="자가부지공장근저당_미설정" name="자가부지공장근저당" value="자가부지공장근저당_미설정">
									<label for="자가부지공장근저당_미설정">해당 없음</label>
								</div>
							</fieldset>
						</td>
						<th>권리증 보유 현황</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="부지 소유 혹은 임대 구분"></legend>
								<div class="radio_group">
									<input type="radio" id="권리증_보유_현황_사무위탁사" name="권리증_보유_현황" value="권리증_보유_현황_사무위탁사">
									<label for="권리증_보유_현황_사무위탁사">사무위탁사</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="권리증_보유_현황_자산운영사" name="권리증_보유_현황" value="권리증_보유_현황_자산운영사">
									<label for="권리증_보유_현황_자산운영사">자산운영사</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>운영 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="운영 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="운영_여부_운영중" name="운영_여부" value="운영_여부_운영중">
									<label for="운영_여부_운영중">운영중</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="운영_여부_운영예정" name="운영_여부" value="운영_여부_운영예정">
									<label for="운영_여부_운영예정">운영 예정</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="운영_여부_해지" name="운영_여부" value="운영_여부_해지">
									<label for="운영_여부_해지">해지</label>
								</div>
							</fieldset>
						</td>
						<th>관리 계약 구분</th>
						<td>
							<div class="dropdown placeholder edit mr-12 w300" id="관리_계약_구분">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown">
									선택<span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu">
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_전체" value="전체" name="관리_계약_구분">
											<label for="관리_계약_구분_전체">전체</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_종합" value="종합" name="관리_계약_구분">
											<label for="관리_계약_구분_종합">종합</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_일반관리" value="일반관리" name="관리_계약_구분">
											<label for="관리_계약_구분_일반관리">일반관리</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_사무수탁" value="사무수탁" name="관리_계약_구분">
											<label for="관리_계약_구분_사무수탁">사무수탁</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_보험" value="보험" name="관리_계약_구분">
											<label for="관리_계약_구분_보험">보험</label>
										</a>
									</li>
									<li>
										<a href="javascript:void(0);" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_안전관리자" value="안전관리자" name="관리_계약_구분">
											<label for="관리_계약_구분_안전관리자">안전관리자</label>
										</a>
									</li>
								</ul>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="accountInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">계정 정보</h2>
				<a role="button" href="#accountInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="accountInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="RPS_시스템_ID">RPS 시스템 ID</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="RPS_시스템_ID" name="RPS_시스템_ID" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="RPS_시스템_PW">PW</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="password" id="RPS_시스템_PW" name="RPS_시스템_PW" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="전력_거래소_ID">전력 거래소 ID</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="전력_거래소_ID" name="전력_거래소_ID" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="전력_거래소_PW">PW</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="password" id="전력_거래소_PW" name="전력_거래소_PW" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="REC_발전사_ID">REC 발전사 ID</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="REC_발전사_ID" name="REC_발전사_ID" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="발전사명">발전사명</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="발전사명" name="발전사명" placeholder="직접 입력">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="financeInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">금융 정보</h2>
				<a role="button" href="#financeInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="financeInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<form id="financeForm" name="financeForm" class="mt-25">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th><label for="관련_금융사">금융사(자금 운영 기관)</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="관련_금융사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="금융사_대표자">대표자</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="금융사_대표자" name="금융사_대표자" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="계약_체결일">계약 체결일</label></th>
							<td>
								<div class="sel_calendar edit">
									<input type="text" id="계약_체결일" name="계약_체결일" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</td>
							<th><label for="대출_약정액">대출 약정액</label></th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text" id="대출_약정액" class="right" name="대출_약정액">
									<span>원</span>
								</div>
							</td>
						</tr>
						<tr>
							<th class="group_type"><label for="상환_만기일">상환 만기일</label></th>
							<td>
								<div class="sel_calendar edit">
									<input type="text" id="상환_만기일" class="sel datepicker" name="상환_만기일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</td>
							<th class="group_type">
								<label for="이자_지급일0">이자 지급일</label>
								<a href="javascript:addRow('addList_interest_pay_date');" class="btn_add fr">추가</a>
							</th>
							<td id="addList_interest_pay_date" class="entity">
								<div class="group_type flex_start">
									<div class="sel_calendar edit">
										<input type="text" id="이자_지급일[index]" class="sel datepicker" name="이자_지급일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									</div>
									<button type="button" class="btn_close hidden fr" onclick="removeList(this)"></button>
								</div>
							</td>
						</tr>
						<tr>
							<th class="group_type">
								<label for="보장발전시간_정산일0">보장발전시간 정산일</label>
								<a href="javascript:addRow('addList_payroll_date');" class="btn_add fr">추가</a>
							</th>
							<td id="addList_payroll_date" class="entity">
								<div class="group_type flex_start">
									<div class="sel_calendar edit">
										<input type="text" id="보장발전시간_정산일[index]" class="sel datepicker" name="보장발전시간_정산일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									</div>
									<button type="button" class="btn_close hidden fr" onclick="removeList(this)"></button>
								</div>
							</td>
							<th>
								<label for="대리기관_수수료_지급일0">대리기관 수수료 지급일</label>
								<a href="javascript:addRow('addList_commission_payment');" class="btn_add fr">추가</a>
							</th>
							<td id="addList_commission_payment" class="entity">
								<div class="group_type flex_start">
									<div class="sel_calendar edit">
										<input type="text" id="대리기관_수수료_지급일[index]" class="sel datepicker" name="대리기관_수수료_지급일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									</div>
									<button type="button" class="btn_close hidden fr" onclick="removeList(this)"></button>
								</div>
							</td>
						</tr>
						<tr class="addList_account_holder entity">
							<th>
								<div class="fixed_height">은행 계좌</div>
								<a href="javascript:addRow('addList_account_holder', 'next');" class="btn_add fr mt-offset-10">추가</a>
								<div class="fixed_height"><label for="예금주[index]">예금주</label></div>
							</th>
							<td>
								<div class="fixed_height group_type short">
									<div class="account-type dropdown placeholder edit" id="입출금_구분[index]">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown">
											입출금 구분<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="입금"><a href="javascript:void(0);">입금</a></li>
											<li data-value="출금"><a href="javascript:void(0);">출금</a></li>
										</ul>
									</div>
									<div class="dropdown placeholder edit" id="계좌구분[index]">
										<button type="button" class="dropdown-toggle accdropdown" data-toggle="dropdown">계좌구분<span class="caret"></span>
										</button><!--
									--><ul id="계좌구분리스트[index]" class="dropdown-menu" role="menu"><!--
										--><li data-default="select" data-value="select"><a href="javascript:void(0);">입출금 구분을 선택해 주세요.</a></li><!--
										--><li data-group="입금" data-value="관리운영비"><a href="javascript:void(0);">관리 운영비</a></li><!--
										--><li data-group="입금" data-value="사무수탁비"><a href="javascript:void(0);">사무 수탁비</a></li><!--
										--><li data-group="입금" data-value="부채상환"><a href="javascript:void(0);">부채 상환</a></li><!--
										--><li data-group="입금" data-value="공사비"><a href="javascript:void(0);">공사비</a></li><!--
										--><li data-group="입금" data-value="임대료"><a href="javascript:void(0);">임대료</a></li><!--
										--><li data-group="입금" data-value="대납금"><a href="javascript:void(0);">대납금</a></li><!--
										--><li data-group="입금" data-value="대수선비"><a href="javascript:void(0);">대수선비</a></li><!--
										--><li data-group="입금" data-value="배당금적립"><a href="javascript:void(0);">배당금 적립</a></li><!--
										--><li data-group="입금" data-value="일반지출"><a href="javascript:void(0);">일반 지출</a></li><!--
										--><li data-group="입금" data-value="DSRA적립"><a href="javascript:void(0);">DSRA 적립</a></li><!--
										--><li data-group="입금" data-value="운영계좌"><a href="javascript:void(0);">운영계좌</a></li><!--
										--><li data-group="입금" data-value="기타"><a href="javascript:void(0);">기타</a></li><!--

										--><li data-group="출금" data-value="관리운영비"><a href="javascript:void(0);">관리 운영비</a></li><!--
										--><li data-group="출금" data-value="사무수탁비"><a href="javascript:void(0);">사무 수탁비</a></li><!--
										--><li data-group="출금" data-value="공사비"><a href="javascript:void(0);">공사비</a></li><!--
										--><li data-group="출금" data-value="임대료"><a href="javascript:void(0);">임대료</a></li><!--
										--><li data-group="출금" data-value="대납금"><a href="javascript:void(0);">대납금</a></li><!--
										--><li data-group="출금" data-value="부채상환"><a href="javascript:void(0);">부채 상환</a></li><!--
										--><li data-group="출금" data-value="대수선비"><a href="javascript:void(0);">대수선비</a></li><!--
										--><li data-group="출금" data-value="배당금적립"><a href="javascript:void(0);">배당금 적립</a></li><!--
										--><li data-group="출금" data-value="일반지출"><a href="javascript:void(0);">일반 지출</a></li><!--
										--><li data-group="출금" data-value="REC수익"><a href="javascript:void(0);">REC 수익</a></li><!--
										--><li data-group="출금" data-value="SMP수익"><a href="javascript:void(0);">SMP 수익</a></li><!--
										--><li data-group="출금" data-value="DSRA적립"><a href="javascript:void(0);">DSRA 적립</a></li><!--
										--><li data-group="출금" data-value="운영계좌"><a href="javascript:void(0);">운영계좌</a></li><!--
										--><li data-group="출금" data-value="유보계좌"><a href="javascript:void(0);">유보계좌</a></li><!--
										--><li data-group="출금" data-value="기타"><a href="javascript:void(0);">기타</a></li><!--
									--></ul><!--
								--></div>
									<div class="dropdown placeholder edit" id="은행_리스트[index]">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown">
											은행 리스트<span class="caret"></span>
										</button><!--
									--><ul class="dropdown-menu" role="menu"><!--
										--><li data-id="0020" data-value="우리"><a href="javascript:void(0);">우리</a></li><!--
										--><li data-id="0004" data-value="국민"><a href="javascript:void(0);">국민</a></li><!--
										--><li data-id="0003" data-value="기업"><a href="javascript:void(0);">기업</a></li><!--
										--><li data-id="0011" data-value="농협"><a href="javascript:void(0);">농협</a></li><!--
										--><li data-id="0088" data-value="신한"><a href="javascript:void(0);">신한</a></li><!--
										--><li data-id="0081" data-value="KEB하나"><a href="javascript:void(0);">KEB하나</a></li><!--
										--><li data-id="0027" data-value="씨티"><a href="javascript:void(0);">한국씨티</a></li><!--
										--><li data-id="0023" data-value="SC"><a href="javascript:void(0);">SC제일</a></li><!--
										--><li data-id="0039" data-value="경남"><a href="javascript:void(0);">경남</a></li><!--
										--><li data-id="0034" data-value="광주"><a href="javascript:void(0);">광주</a></li><!--
										--><li data-id="0031" data-value="대구"><a href="javascript:void(0);">대구</a></li><!--
										--><li data-id="0032" data-value="부산"><a href="javascript:void(0);">부산</a></li><!--
										--><li data-id="0002" data-value="산업"><a href="javascript:void(0);">산업</a></li><!--
										--><li data-id="0045" data-value="새마을금고"><a href="javascript:void(0);">새마을금고</a></li><!--
										--><li data-id="0007" data-value="수협"><a href="javascript:void(0);">수협</a></li><!--
										--><li data-id="0048" data-value="신협"><a href="javascript:void(0);">신협</a></li><!--
										--><li data-id="0071" data-value="우체국"><a href="javascript:void(0);">우체국</a></li><!--
										--><li data-id="0037" data-value="전북"><a href="javascript:void(0);">전북</a></li><!--
										--><li data-id="0035" data-value="제주"><a href="javascript:void(0);">제주</a></li><!--
										--><li data-id="0089" data-value="K뱅크"><a href="javascript:void(0);">K뱅크</a></li><!--
										--><li data-id="1001" data-value="상호저축"><a href="javascript:void(0);">상호저축</a></li><!--
										--><li data-id="0000" data-value="직접입력"><a href="javascript:void(0);">직접입력</a></li><!--
									--></ul><!--
								--></div>
								</div>
								<div class="fixed_height">
									<div class="group_type">
										<div class="tx_inp_type edit unit t1">
											<input type="text" id="예금주[index]" name="예금주[index]" placeholder="직접 입력">
										</div>
										<div class="tx_inp_type edit hidden">
											<input type="text" id="은행_직접입력[index]" name="은행_직접입력[index]" placeholder="직접 입력">
										</div>
									</div>
								</div>
							</td>
							<th>
								<div class="fixed_height"><label for="계좌_번호[index]">계좌 번호</label></div>
								<div class="fixed_height"><label for="계좌개설_은행(지점)[index]">계좌개설 은행(지점)</label></div>
							</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="계좌_번호[index]" name="계좌_번호[index]" placeholder="직접 입력">
								</div>
								<button type="button" class="btn_close hidden mr-12 fr" onclick="$(this).parents().closest('tr').remove()"></button>
								<div class="tx_inp_type edit">
									<input type="text" id="계좌개설_은행(지점)[index]" name="계좌개설_은행(지점)[index]" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="빠른조회_비밀번호">빠른조회 비밀번호</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="빠른조회_비밀번호" name="빠른조회_비밀번호" placeholder="직접 입력">
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th class="group_type">
								공인인증서 등록 <a href="javascript:addRow('addList_certificate_registration', 'class'); addRow('addList_certificate_registration2', 'class');" class="btn_add fr">추가</a>
							</th>
							<td class="addList_certificate_registration entity">
								<div class="group_type flex_start">
									<div id="용도[index]" class="dropdown placeholder edit mxw100">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
											용도 선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="은행용">
												<a href="javascript:void(0);">은행용</a>
											</li>
											<li data-value="세금_계산서용">
												<a href="javascript:void(0);">세금 계산서용</a>
											</li>
										</ul>
									</div>
									<div class="flex-baseline mt10">
										<input type="file" id="공인인증서_등록_이미지[index]" class="hidden" name="공인인증서_등록_이미지[index]" accept=".der, .key" multiple>
										<label for="공인인증서_등록_이미지[index]" class="btn file_upload">파일 선택</label>
										<ul class="file_list ml-16">
											<li>등록 파일 이름</li>
										</ul>
									</div>
								</div>
							</td>
							<th><label for="인증서_비밀번호[index]">인증서 비밀번호</label></th>
							<td class="addList_certificate_registration2 entity">
								<div class="group_type flex_start">
									<div class="tx_inp_type edit">
										<input type="text" id="인증서_비밀번호[index]" name="인증서_비밀번호[index]" placeholder="비밀번호를 입력해 주세요.">
									</div>
									<div class="fr fixed_height mt5 mr-12">
										<button type="button" class="btn_close hidden" onclick="removeList(this, 'dual')"></button>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="DSRA_적립_요구금액">DSRA 적립 요구금액</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="DSRA_적립_요구금액" name="DSRA_적립_요구금액" placeholder="직접 입력">
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>
								<div class="fixed_height">고정 금액</div>
								<div class="fixed_height"><label for="전체_용량">전체 용량</label></div>
								<div class="fixed_height"><label for="관리_운영비">관리 운영비</label></div>
								<div class="fixed_height"><label for="대수선비">대수선비</label></div>
								<div class="fixed_height"><label for="사무_수탁비">사무 수탁비</label></div>
								<div class="fixed_height"><label for="임대료">임대료</label></div>
								<div class="fixed_height"><label for="SMP">SMP</label></div>
								<div class="fixed_height"><label for="REC">REC</label></div>
							</th>
							<td class="align_top">
								<div class="fixed_height"></div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="전체_용량" class="right" name="전체_용량" placeholder="">
										<span>MW</span>
									</div>
								</div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="관리_운영비" class="right" name="관리_운영비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="대수선비" class="right" name="대수선비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="사무_수탁비" class="right" name="사무_수탁비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="임대료" class="right" name="임대료" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="group_type">
									<div class="dropdown placeholder edit" id="SMP">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
											선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="고정가"><a href="javascript:void(0);">고정가</a></li>
											<li data-value="월_가중_평균"><a href="javascript:void(0);">월 가중 평균</a></li>
											<li data-value="실시간"><a href="javascript:void(0);">실시간</a></li>
										</ul>
									</div>
									<div class="tx_inp_type edit unit t1">
										<input type="text" id="SMP원" class="right" name="SMP원" placeholder="">
										<span>원</span>
									</div>

								</div>
								<div class="group_type">
									<div class="dropdown placeholder edit" id="REC">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
											고정가<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="고정가"><a href="javascript:void(0);">고정가</a></li>
											<li data-value="SMP+REC"><a href="javascript:void(0);">SMP + REC</a></li>
											<li data-value="월별_추후_산정"><a href="javascript:void(0);">월별 추후 산정</a></li>
										</ul>
									</div>
									<div class="tx_inp_type edit unit t1">
										<input type="text" id="REC원" class="right" name="REC원" placeholder="">
										<span>원</span>
									</div>
								</div>
							</td>
							<th class="align_top">
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="fixed_height flex_wrap_center">
									<label for="임대료_지급일0">임대료 지급일</label>
									<a role="button" href="javascript:addRow('addList_rental_deduction', 'next');" class="btn_add fr">추가</a>
								</div>
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
							</th>
							<td class="align_top">
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="fixed_height"></div>
								<div class="sel_calendar group_type edit addList_rental_deduction entity">
									<input type="text" id="임대료_지급일[index]" class="sel datepicker" name="임대료_지급일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									<button type="button" class="btn_close hidden" onclick="removeList(this)"></button>
								</div>
								<div class="fixed_height"></div>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>

		<div class="indiv panel panel-default" id="contractInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">시공 계약 정보</h2><a role="button" href="#contractInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="contractInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="공사_계약_정보_시공사">시공사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="공사_계약_정보_시공사" name="공사_계약_정보_시공사" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="공사_계약_정보_약정일">약정일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="공사_계약_정보_약정일" class="sel datepicker" name="공사_계약_정보_약정일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="도급_계약서_공사_계약_금액">(도급 계약서) 공사 계약 금액</label></th>
						<td>
							<div class="tx_inp_type edit unit t1 mr-30">
								<input type="text" id="도급_계약서_공사_계약_금액" name="도급_계약서_공사_계약_금액" placeholder="직접 입력" onkeyup="sumUnpaid();">
								<span>원</span>
							</div>
						</td>
						<th><label for="약정_금액">약정 금액</label></th>
						<td>
							<div class="tx_inp_type edit unit t1 mr-30">
								<input type="text" id="약정_금액" name="약정_금액" placeholder="직접 입력" onkeyup="sumUnpaid();">
								<span>원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="도급_계약서_사용전_검사일">(도급 계약서) 사용전 검사일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="도급_계약서_사용전_검사일" class="sel datepicker" name="도급_계약서_사용전_검사일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th><label for="실제_사용전_검사일자">(실제) 사용전 검사일자</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="실제_사용전_검사일자" class="sel datepicker" name="실제_사용전_검사일자" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="도급_계약서_준공일">(도급 계약서) 준공일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="도급_계약서_준공일" class="sel datepicker" name="도급_계약서_준공일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th><label for="실제_준공일">(실제) 준공일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="실제_준공일" class="sel datepicker" name="실제_준공일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="인출_가능_기한">인출 가능 기한</label></th>
						<td class="flex_start">
							<div class="sel_calendar edit">
								<input type="text" id="인출_가능_기한" class="sel" name="인출_가능_기한" value="" autocomplete="off" placeholder="자동 입력" readonly>
							</div>
							<span class="fixed_height" id="인출_가능_남은일"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>
							<div class="fixed_height">지급 약정</div>
							<div class="fixed_height"><label for="계약서_명시_인출일_1차">계약서 명시 인출일</label><span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
							<div class="fixed_height"><label for="지급금액_1차">지급금액</label><span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
							<div class="fixed_height">미지급액</div>
						</th>
						<td>
							<div class="fixed_height"></div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="계약서_명시_인출일_1차" class="sel datepicker" name="계약서_명시_인출일_1차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex_start">

								<div class="sel_calendar edit">
									<input type="text" id="계약서_명시_인출일_2차" class="sel datepicker" name="계약서_명시_인출일_2차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="계약서_명시_인출일_3차" class="sel datepicker" name="계약서_명시_인출일_3차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" id="지급금액_1차" name="지급금액_1차" placeholder="직접 입력" onkeyup="sumUnpaid();">
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" id="지급금액_2차" name="지급금액_2차" placeholder="직접 입력" onkeyup="sumUnpaid();">
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" id="지급금액_3차" name="지급금액_3차" placeholder="직접 입력" onkeyup="sumUnpaid();">
								</div>
							</div>
							<div class="fixed_height w300">
								<span class="text" id="미지급_금액">자동 계산</span>
								<span class="fr">원</span>
							</div>
						</td>
						<th class="align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height">
								<label for="실_지급일_1차">실 지급일</label><span class="fr fixed_height">1차</span>
							</div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
						</th>
						<td class="align_top">
							<div class="fixed_height"></div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="실_지급일_1차" class="sel datepicker" name="실_지급일_1차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="실_지급일_2차" class="sel datepicker" name="실_지급일_2차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="실_지급일_3차" class="sel datepicker" name="실_지급일_3차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="insuranceInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">보험 정보<a role="button" href="javascript:addRow('insuranceInfoToggle');" class="btn_add ml-24">추가</a></h2>
				<a role="button" href="#insuranceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="insuranceInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>보험 정보</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="보험 정보"></legend>
								<div class="radio_group">
									<input type="radio" id="보험구분_조립_보험[index]" name="보험구분[index]" value="조립보험">
									<label for="보험구분_조립_보험[index]">조립 보험</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="보험구분_CMI[index]" name="보험구분[index]" value="CMI">
									<label for="보험구분_CMI[index]">CMI</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="보험구분_CGL[index]" name="보험구분[index]" value="CGL">
									<label for="보험구분_CGL[index]">CGL</label>
								</div>
							</fieldset>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><label for="보험사[index]">보험사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="보험사[index]" name="보험사[index]" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="보험_중개사[index]">보험 중개사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="보험_중개사[index]" name="보험_중개사[index]" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="보험_기간_from[index]">보험 기간</label></th>
						<td class="group_type">
							<legend class="sr-only">보험 기간</legend>
							<fieldset class="sel_calendar edit twin clear dateField">
								<input type="text" id="보험_기간_from[index]" class="sel fromDate" name="보험_기간_from[index]" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="보험_기간_to[index]" class="sel toDate" name="보험_기간_to[index]" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
						<th><label for="보험료[index]">보험료</label></th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="보험료[index]" name="보험료[index]">
								<span>원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="자가부담금[index]">자가부담금</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="자가부담금[index]" name="자가부담금[index]" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="보험가액[index]">보험가액</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="보험가액[index]" name="보험가액[index]" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr class="dateField">
						<th><label for="보험_시작일[index]">시작일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="보험_시작일[index]" class="sel fromDate" name="보험_시작일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th><label for="보험_종료일[index]">종료일</label></th>
						<td class="flex_start">
							<div class="sel_calendar edit mr-24">
								<input type="text" id="보험_종료일[index]" class="sel toDate" name="보험_종료일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								<input type="hidden" id="보험_종료일_차이[index]" name="보험_종료일_차이[index]" value="">
							</div>
							<span class="fixed_height"></span>
						</td>
					</tr>
					<tr>
						<th></th>
						<td></td>
						<th><label for="보험_만기일[index]">만기일</label></th>
						<td class="flex_start">
							<div class="sel_calendar edit mr-24">
								<input type="text" id="보험_만기일[index]" class="sel toDate" name="보험_만기일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								<input type="hidden" id="보험_만기일_차이[index]" name="보험_만기일_차이[index]" value="">
							</div>
							<span class="fixed_height"></span>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="deviceInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">설비 정보</h2><a role="button" href="#deviceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="deviceInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>모듈 제조사 / 모델<a href="javascript:addRow('addList_module_info');" class="btn_add fr">추가</a></th>
						<td id="addList_module_info" class="entity">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<label class="sr-only">모듈 제조사</label>
									<input type="text" id="모듈_제조사[index]" name="모듈_제조사[index]" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<label class="sr-only">모듈 제조사 모델</label>
									<input type="text" id="모듈_제조사_모델[index]" name="모듈_제조사_모델[index]" placeholder="모델">
								</div>
								<button type="button" class="btn_close hidden fixed_height" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>설치 용량</th>
						<td class="group_type">
							<div class="tx_inp_type edit unit t1">
								<label class="sr-only">설치 용량 (KW)</label>
								<input type="text" id="설치_용량_KW"><span>kW</span>
							</div>
							<div class="tx_inp_type edit unit t1">
								<label class="sr-only">설치 용량(매)</label>
								<input type="text" id="설치_용량(매)"><span>매</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>
							<label for="모듈_설치_각도">모듈 설치 각도</label>
							<a href="javascript:addRow('addList_module_angle');" class="btn_add fr">추가</a>
						</th>
						<td id="addList_module_angle" class="entity">
							<div class="tx_inp_type edit unit t1 fl">
								<input type="text" id="모듈_설치_각도[index]" name="모듈_설치_각도[index]">&ensp;&deg;
								<button type="button" class="btn_close hidden" onclick="$(this).parent().remove()">삭제</button>
							</div>
						</td>
						<th>모듈 설치 방식</th>
						<td>
							<fieldset class="chk_type align_type">
								<legend sr-only="인버터 제조사/모델"></legend>
								<input type="checkbox" id="모듈_설치_방식_고정" name="모듈_설치_방식" value="고정 가변식">
								<label for="모듈_설치_방식_고정" class="mr-24">고정 가변식</label>
								<input type="checkbox" id="모듈_설치_방식_트래커" name="모듈_설치_방식" value="트래커">
								<label for="모듈_설치_방식_트래커" class="mr-24">트래커</label>
								<input type="checkbox" id="모듈_설치_방식_경사고정형" name="모듈_설치_방식" value="경사 고정형">
								<label for="모듈_설치_방식_경사고정형">경사 고정형</label>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>인버터 제조사 / 모델<a href="javascript:addRow('addList_inverter');" class="btn_add fr">추가</a></th>
						<td id="addList_inverter" class="entity">
							<div class="flex_start">
								<fieldset class="group_type">
									<legend sr-only="인버터 제조사/모델"></legend>
									<div class="tx_inp_type edit">
										<input type="text" id="인버터_제조사[index]" name="인버터_제조사[index]" placeholder="제조사">
									</div>
									<div class="tx_inp_type edit">
										<input type="text" id="인버터_제조사_모델[index]" name="인버터_제조사_모델[index]" placeholder="모델">
									</div>
								</fieldset>
								<button type="button" class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>인버터 용량 / 대수<a href="javascript:addRow('addList_inverter_vol');" class="btn_add fr">추가</a></th>
						<td id="addList_inverter_vol" class="entity">
							<fieldset class="group_type">
								<legend sr-only="인버터 용량 / 대수"></legend>
								<div class="tx_inp_type edit unit t1">
									<input type="text" id="인버터_용량[index]" name="인버터_용량[index]"><span>kW</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" id="인버터_용량_대수[index]" name="인버터_용량_대수[index]"><span>대</span>

									<button type="button" class="btn_close hidden" onclick="$(this).parents('.group_type').remove();">삭제</button>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="접속반_제조사0">접속반 제조사 / 모델</label><a href="javascript:addRow('addList_manufacturer');" class="btn_add fr">추가</a></th>
						<td id="addList_manufacturer" class="entity">
							<div class="flex_start group_type">
								<div class="tx_inp_type edit">
									<input type="text" placeholder="제조사" id="접속반_제조사[index]" name="접속반_제조사[index]">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="모델" id="접속반_제조사_모델[index]" name="접속반_제조사_모델[index]">
								</div>
								<button type="button" class="btn_close hidden fixed_height mt-0" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>접속반 채널 / 대수<a href="javascript:addRow('addList_connection');" class="btn_add fr">추가</a></th>
						<td id="addList_connection" class="entity">
							<div class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" id="접속반_채널[index]" name="접속반_채널[index]"><span>Ch</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" id="접속반_채널_대수[index]" name="접속반_채널_대수[index]"><span>대</span>
								</div>
								<button type="button" class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
					</tr>
					<tr>
						<th>접속반 용량 / 통신방식</th>
						<td class="group_type">
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="접속반_용량" name="접속반_용량">
								<span>kW</span>
							</div>
							<fieldset class="rdo_type flex_start2">
								<legend sr-only="통신 방식"></legend>

								<div class="radio_group">
									<input type="radio" id="통신방식_통신" name="통신방식" value="통신">
									<label for="통신방식_통신">통신</label>
								</div>

								<div class="radio_group">
									<input type="radio" id="통신방식_비통신" name="통신방식" value="비통신">
									<label for="통신방식_비통신">비통신</label>
								</div>
							</fieldset>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td>
							<div class="chk_type align_type">
								<fieldset class="flex_start3">
									<legend sr-only="설치 타입"></legend>
									<input type="checkbox" id="설치_타입_그라운드" name="설치_타입" value="그라운드">
									<label class="custom_checkbox" for="설치_타입_그라운드">그라운드</label>
									<input type="checkbox" id="설치_타입_루프탑" name="설치_타입" value="루프탑">
									<label class="custom_checkbox" for="설치_타입_루프탑">루프탑</label>
									<input type="checkbox" id="설치_타입_수상" name="설치_타입" value="수상">
									<label class="custom_checkbox" for="설치_타입_수상">수상</label>
								</fieldset>
							</div>
						</td>
						<th>수배전반 제조사 / 모델<a href="javascript:addRow('addList_switch_gear');" class="btn_add fr">추가</a></th>
						<td id="addList_switch_gear" class="entity">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" id="수배전반_제조사[index]" name="수배전반_제조사[index]" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" id="수배전반_모델[index]" name="수배전반_모델[index]" placeholder="모델">
								</div>
								<button type="button" class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="warrantyInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">보증 정보</h2><a role="button" href="#warrantyInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="warrantyInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>보증 방식</th>
						<td>
							<fieldset class="rdo_type flex_start3">
								<legend sr-only="보증 방식"></legend>
								<div class="radio_group">
									<input type="radio" id="보증_방식_PR" name="보증_방식" value="PR">
									<label for="보증_방식_PR">PR</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="보증_방식_발전_시간" name="보증_방식" value="발전 시간">
									<label for="보증_방식_발전_시간">발전 시간</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="보증_방식_PR_+_발전_시간" name="보증_방식" value="PR + 발전시간">
									<label for="보증_방식_PR_+_발전_시간">PR + 발전 시간</label>
								</div>
							</fieldset>
						</td>
						<th>PR 보증치</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="PR_보증치" name="PR_보증치"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="발전시간_보증치" name="발전시간_보증치"><span>h</span></div>
						</td>
						<th>보증 감소율</th>
						<td>
							<div class="tx_inp_type edit unit t2"><input type="text" id="보증_감소율" name="보증_감소율"><span>년차별 %</span></div>
						</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td class="group_type">
							<div class="dropdown placeholder edit" id="기준_단가">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown">기준 단가 선택<span class="caret"></span></button>
								<ul class="dropdown-menu" role="menu">
									<li data-value=""><a href="javascript:void(0);">기준 단가 선택</a></li>
									<li data-value="FIT 단가"><a href="javascript:void(0);">FIT 단가</a></li>
									<li data-value="시장정산실적"><a href="javascript:void(0);">시장정산실적</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit unit t2">
								<input type="text" id="기준_단가_원" name="기준_단가_원"><span>원 / kW</span></div>
						</td>
						<th>현재 적용 연차</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="현재_적용_연차" name="현재_적용_연차"><span>년차</span></div>
						</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="년간_관리_운영비" name="년간_관리_운영비"><span>만원</span></div>
						</td>
						<th>물가 반영 비율</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="물가_반영_비율" name="물가_반영_비율"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="추가 보수"></legend>
								<div class="radio_group">
									<input type="radio" id="추가_보수_유" name="추가_보수" value="유">
									<label for="추가_보수_유">유</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="추가_보수_무" name="추가_보수" value="무">
									<label for="추가_보수_무">무</label>
								</div>
							</fieldset>
						</td>
						<th>추가 보수 용량</th>
						<td>
							<div class="tx_inp_type edit unit t2"><input type="text" id="추가_보수_용량" name="추가_보수_용량"><span>kW 이상</span></div>
						</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="추가_보수_백분율" name="추가_보수_백분율"><span>%</span></div>
						</td>
						<th>전력요금 종별</th>
						<td class="group_type">
							<div class="tx_inp_type edit">
								<input type="text" id="전력요금_종별_요금제" placeholder="요금제">
							</div>
							<div class="tx_inp_type edit unit t2"><input type="text" id="전력요금_종별_계약전력" name="전력요금_종별_계약전력" placeholder="계약 전력"><span>kW</span></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="coefficientInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">환경 변수</h2><a href="#coefficientInfoToggle" data-toggle="collapse" class="collapse_arrow"></a></div>
			<div id="coefficientInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>Annual Variability</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="annual" name="annual"><span>%</span></div>
						</td>
						<th>PV modul modeling/params</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="pv_modul" name="pv_modul"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="inverter" name="inverter"><span>%</span></div>
						</td>
						<th>Soiling, mismatch</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="soiling" name="soiling"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th><label for="degradationEstimation">Degradation estimation</label></th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="degradationEstimation" name="degradation_estimation"><span>%</span></div>
						</td>
						<th><label for="degradationEstimation">Resulting ann, Variability(sigma)</label></th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="resulting_ann" name="resulting_ann"><span>%</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>System Degradation</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="system_degradation" name="system_degradation"><span>%</span>
							</div>
						</td>
						<th>System Availability</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="system_availability" name="system_availability"><span>%</span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="associatedInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">관련 정보</h2><a href="#associatedInfoToggle" data-toggle="collapse" class="collapse_arrow"></a></div>
			<div id="associatedInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="전기안전_관리_회사명">전기안전 관리 회사명</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="전기안전_관리_회사명" name="전기안전_관리_회사명" placeholder="직접 입력"></div>
						</td>
						<th><label for="회사_연락처"></label>회사 연락처</th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="회사_연락처" name="회사_연락처" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="전기안전_관리_대표자명">전기안전 관리 대표자명</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="전기안전_관리_대표자명" name="전기안전_관리_대표자명" placeholder="직접 입력"></div>
						</td>
						<th>대표자 연락처</th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="대표자_연락처" name="대표자 연락처" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="전기안전_관리_담당자명">전기안전 관리 담당자명</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="전기안전_관리_담당자명" name="전기안전_관리_담당자명" placeholder="직접 입력"></div>
						</td>
						<th><label for="담당자_연락처">담당자 연락처</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="담당자_연락처" name="담당자_연락처" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="현장_잠금장치_비밀번호">현장 잠금장치 비밀번호</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="현장_잠금장치_비밀번호" name="현장_잠금장치_비밀번호" placeholder="직접 입력"></div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<!-- TO 개발자님 : 아래 파일 선택은 multi-select 로 파일 업로드 -->
		<div class="indiv panel panel-default attachment">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">첨부 파일</h2>
				<a href="#attachementInfoToggle" data-toggle="collapse" class="collapse_arrow"></a>
			</div>
			<form id="attachement_info" name="attachement_info" class="mt-25">
				<div id="attachementInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:55%">
							<col style="width:30%">
							<col>
						</colgroup>
						<tr>
							<th>현장 사진</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_01" class="hidden" name="spc_file_01" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_01" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>수배전반</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_02" class="hidden" name="spc_file_02" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_02" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>케이블</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_03" class="hidden" name="spc_file_03" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_03" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>모듈</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_04" class="hidden" name="spc_file_04" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_04" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>인버터</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_05" class="hidden" name="spc_file_05" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_05" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>결선도</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_06" class="hidden" name="spc_file_06" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_06" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>토목</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_07" class="hidden" name="spc_file_07" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_07" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>구조물</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_08" class="hidden" name="spc_file_08" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_08" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>접속반</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_09" class="hidden" name="spc_file_09" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_09" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>기타설비</th>
							<td class="flex_start_td">
								<input type="file" id="spc_file_10" class="hidden" name="spc_file_10" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_10" class="btn file_upload">파일 선택</label>
								<div class="file_list ml-16">
									<ul>
										<li>No Files Selected</li>
									</ul>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
					</table>
				</div>
			</form>
		</div>

		<div class="btn_wrap_type_right">
			<a href="/spc/entityDetails.do" class="btn btn_type03">목록</a>
			<button type="button" class="btn_type big" onclick="setSaveData();">등록</button>
		</div>
	</div>
</div>
