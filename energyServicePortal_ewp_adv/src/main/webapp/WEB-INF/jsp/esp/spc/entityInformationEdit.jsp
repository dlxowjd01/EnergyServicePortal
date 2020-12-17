<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	const countryList = new Array();
	const sidoList = new Array();

	$(function () {
		fnLocation();

		$("#unitPriceList").on("click", "li", unitPriceListChange);

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

		setInitList("fileList01");
		setInitList("fileList02");
		setInitList("fileList03");
		setInitList("fileList04");
		setInitList("fileList05");
		setInitList("fileList06");
		setInitList("fileList07");
		setInitList("fileList08");
		setInitList("fileList09");
		setInitList("fileList10");

		initProcess();
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

	const autoValArr = ['#관리_운영비', '#대수선비', '#사무_수탁비', '#임대료'];
	$(document).on('keyup', '#전체_용량, #관리_운영비, #대수선비, #사무_수탁비, #임대료', function() {
		financeAuto();
	});

	const financeAuto = () => {
		autoValArr.forEach(autoId => {
			let autoVal = $(autoId).val() / $('#전체_용량').val();
			if (isNaN(autoVal) || !isFinite(autoVal)) {
				$(autoId).parent().next().find('.auto_price').text('');
			} else {
				$(autoId).parent().next().find('.auto_price').text(numberComma(autoVal.toFixed(2)));
			}
		});
	}

	$(document).on('keyup', '[id^="이행보증보험료"], [id^="보험료"]', function() {
		const thisIdx = $(this).prop('id').replace(/[^0-9]/g, '')
				, implementation = $('#이행보증보험료' + thisIdx).val().trim().replace(/[^0-9]/g, '')
				, guarantee = $('#보험료' + thisIdx).val().trim().replace(/[^0-9]/g, '');

		if (!isEmpty(implementation) && !isEmpty(guarantee)) {
			$('#보험료_총계' + thisIdx).val(numberComma(Number(implementation) + Number(guarantee)));
			$('#이행보증보험료' + thisIdx).val(numberComma(implementation))
			$('#보험료' + thisIdx).val(numberComma(guarantee))
		} else if (!isEmpty(implementation)) {
			$('#보험료_총계' + thisIdx).val(numberComma(implementation));
			$('#이행보증보험료' + thisIdx).val(numberComma(implementation))
		} else if (!isEmpty(guarantee)) {
			$('#보험료_총계' + thisIdx).val(numberComma(guarantee));
			$('#보험료' + thisIdx).val(numberComma(guarantee))
		} else {
			$('#보험료_총계' + thisIdx).val('');
		}
	});

	$(document).on('keyup', '#spendInfo input', function() {
		let totalAmt = 0;
		$('#spendInfo input').each(function() {
			const thisId = $(this).prop('id')
					, thisVal = ($(this).val().trim()).replace(/[^0-9]/g, '');
			if (thisId !== '지출_총계') {
				totalAmt += Number(thisVal);
				$(this).val(numberComma(thisVal));
			}
		});
		$('#지출_총계').val(numberComma(totalAmt));
	});

	function initProcess(){
		getSpcAndGenData(); //저장되어있는 spc정보조회
		setComboBoxData();
	}

	function setComboBoxData() {
		setInitList("spcCountryList");
		setMakeList(countryList, "spcCountryList", {"dataFunction": {}});

		setInitList("countryList");
		setMakeList(countryList, "countryList", {"dataFunction": {}});

		setInitList("spcSidoList");
		setMakeList(sidoList, "spcSidoList", {"dataFunction": {}});

		setInitList("sidoList");
		setMakeList(sidoList, "sidoList", {"dataFunction": {}});
	}

	function getAttachFileDisplay(attachement_info){
		var spcId = '${param.spc_id}',
			genId = '${param.gen_id}',
			oid = '${param.oid}';

		var	addFileList01 = [],addFileList02 = [],addFileList03 = [],addFileList04 = [],addFileList05 = [],
			addFileList06 = [],addFileList07 = [],addFileList08 = [],addFileList09 = [],addFileList10 = [];

		for(var i = 0, count = attachement_info.length; i < count; i++){
			if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_01') {
				addFileList01.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_02') {
				addFileList02.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_03') {
				addFileList03.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_04') {
				addFileList04.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_05') {
				addFileList05.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_06') {
				addFileList06.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_07') {
				addFileList07.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_08') {
				addFileList08.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_09') {
				addFileList09.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == 'spc_file_10') {
				addFileList10.push(attachement_info[i]);
			}
		}

		setMakeList(addFileList01, 'fileList01', {'dataFunction' : {}});
		setMakeList(addFileList02, 'fileList02', {'dataFunction' : {}});
		setMakeList(addFileList03, 'fileList03', {'dataFunction' : {}});
		setMakeList(addFileList04, 'fileList04', {'dataFunction' : {}});
		setMakeList(addFileList05, 'fileList05', {'dataFunction' : {}});
		setMakeList(addFileList06, 'fileList06', {'dataFunction' : {}});
		setMakeList(addFileList07, 'fileList07', {'dataFunction' : {}});
		setMakeList(addFileList08, 'fileList08', {'dataFunction' : {}});
		setMakeList(addFileList09, 'fileList09', {'dataFunction' : {}});
		setMakeList(addFileList10, 'fileList10', {'dataFunction' : {}});
	}

	function setRemoveFileList(fileId, idx){
		var jsonList =  $('#'+fileId).data('gridJsonData');

		jsonList.splice(idx, 1);
		setMakeList(jsonList, fileId, {'dataFunction' : {}});
	}

	function addList(addId){
		var $selecter = $('#' + addId);
		$selecter.append($selecter.data('form'));
		if(addId.indexOf('addFileList') > -1){
			if($selecter.find('input').length >1){
				for(let i = 0; i < $selecter.find('input').length; i++){
					let nowName = $selecter.find('input').eq(i).attr('name');
					$selecter.find('input').eq(i).attr('name', nowName + '_'+ i);
				}
			}
		}
	}

	function removeList(obj, type) {
		if (isEmpty(type)) {
			if ($(obj).parent().parent().find('.group-type').length > 1) {
				$(obj).parent().remove();
			}
		} else {
			if ($(obj).parents('.entity').find('.group-type').length > 1) {
				let index = $(obj).parents('.entity').find('.group-type').index($(obj).parent().parent());
				$(obj).parents('tr').find('.entity').eq(0).find('.group-type').eq(index).remove();
				$(obj).parent().parent().remove();
			}
		}
	}

	function setAddListParam(addId){
		var param = [],
			$selecter = $('#' + addId),
			rowInputCount = $selecter.data('count'),
			allInputCount = $selecter.find('input[type="text"]').length;

		for(var i = 0, count = allInputCount / rowInputCount; i < count; i++){
			var rowData = {};
			for(var j = i*rowInputCount; j < i * rowInputCount + rowInputCount; j++){
				var $input = $selecter.find('input[type="text"]').eq(j);
				rowData[$input.attr('name')] = $input.val();
			}
			param.push(rowData);
		}

		return param;
	}

	function getAddListDisplay(addId, jsonData){
		var $selecter = $('#' + addId),
			rowInputCount = $selecter.data('count');

		for(var i = 0 , count = jsonData.length; i < count; i++){
			var rowData = jsonData[i];
			for(var key in rowData){
				$('input[name="'+ key +'"]').eq(i).val(rowData[key]);
			}

			if(i != count -1 ){
				addList(addId);	//행추가
			}
		}
	}

	function unitPriceListChange(){
		var txt = $(this).find('a').text(),
			idx = $('#unitPriceList').find('li').index(this);

		$('#기준_단가').val(txt);
	}

	function setDropDownValue(id, data){
		var $selecter = $('#' + id);
		$selecter.find('li').each(function(){
			if($(this).text() == data){
				$selecter.parents('.dropdown').find('button').html(data + '<span class="caret"></span>').data('value', data);
				return false;
			}
		});
	}

	function getGenData() {
		var genId = "${param.gen_id}";

		$.ajax({
			url: apiHost + "/config/sites/" + genId,
			type: "get",
			async: false,
			data: {},
			success: function (json) {
				$("#genName").val(json.name);
				// $("#countryValue").text("대한민국");
				// $("#sidoValue").text(json.location);
				// $("#address").text(json.address)
			},
			error: function (request, status, error) {}
		});
	}

	function getSpcAndGenData(){
		var spcId = '${param.spc_id}',
			genId = '${param.gen_id}';

		$.ajax({
			url: apiHost + '/spcs/'+ spcId,
			type: 'get',
			async: true,
			data: {'oid': oid},
			success: function (json) {
				if(json.data.length > 0){
					setJsonAutoMapping(json.data[0], 'basicInfo');
					const spc_info = JSON.parse(json.data[0].spc_info);
					if (!isEmpty(spc_info)) {
						const fileList = spc_info['SPC_법인_인감'];
						if(fileList.length > 0) {
							fileList.forEach((file, index) => {
								if (index > 0) {
									addRow('addList_registered_seal');
								}
								const seal = file['SPC_법인_인감_유형'];
								if (!isEmpty(seal)) {
									$('#spcSeal' + index + ' button').html(seal.replace(/\_/g, ' ') + '<span class="caret"></span>').data('value', seal);
								}

								$('#basicInfo input[type="file"]').eq(index).data('file', file);
								let listItem = `<button type='button' class='btn-close icon-trash' onclick='deleteFile($(this), "front")'></button>`;
								//$('#basicInfo input[type="file"]').eq(index).parent().find(".upload-text").next('.file_del_btn').remove();
								$('#basicInfo input[type="file"]').eq(index).parent().find(".upload-text").html(file['originalname']).after(listItem);
							});
						}
						if (spc_info.spcCountry == 'kr') {
							spc_info.spcCountry = '대한민국';
						}
						setJsonAutoMapping(spc_info, 'basicInfo');

						if (spc_info['spcSealSelected'] != undefined) {
							$(':radio[name="SPC_법인_인감_대표"]:input[value="' + spc_info["spcSealSelected"] + '"]').prop('checked', true);
						}
					}
				}
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});

		$.ajax({
			url: apiHost + '/spcs/'+ spcId + '/gens/' + genId,
			type: 'get',
			async: true,
			data: {'oid': oid},
			success: function (json) {
				if (json.data.length > 0) {
					//기본정보
					const address = JSON.parse(json.data[0].address);
					const maintenance_info = JSON.parse(json.data[0].maintenance_info);
					const account_info = JSON.parse(json.data[0].account_info);
					const finance_info = JSON.parse(json.data[0].finance_info);
					const contract_info = JSON.parse(json.data[0].contract_info);
					const addlist_insurance_info = JSON.parse(json.data[0].addlist_insurance_info);
					const spend_info = JSON.parse(json.data[0].spend_info);
					const device_info = JSON.parse(json.data[0].device_info);
					const warranty_info = JSON.parse(json.data[0].warranty_info);
					const coefficient_info = JSON.parse(json.data[0].coefficient_info);
					const associated_info = JSON.parse(json.data[0].associated_info);

					if (!isEmpty(address)) {
						setJsonAutoMapping(address, 'addressInfo');

						if (isEmpty(address['genName'])) {
							getGenData();
						}
					} else {
						getGenData();
					}

					let repeatNumber= new Array();
					$.map(maintenance_info, function(val, key) {
						if (key.match('등기이사_명')) {
							const tmp = Number(key.replace('등기이사_명', ''));
							if (tmp > 0) {
								repeatNumber.push(tmp);
							}
						}
					});
					repeatNumber.sort(); // index 기준으로 순서대로 생성하기위해서 정렬
					repeatNumber.forEach(function(index) {
						addRow('addList_affiliation', 'class', index);
						addRow('addList_affiliation2', 'class', index);
					});
					setJsonAutoMapping(maintenance_info, 'maintenanceInfo');

					if (maintenance_info != null) {
						$('[name^="등기이사_소속_"]').each(function() {
							let thisName = $(this).attr('name'),
								thisIdx = thisName.replace(/[^0-9]/g, '');

							if (maintenance_info[thisName] != undefined && maintenance_info[thisName].length > 0) {
								if (typeof maintenance_info[thisName] === 'string') {
									$('[name=' + thisName + ']').each(function() {
										if ($(this).val() == maintenance_info[thisName]) {
											$(this).prop('checked', true);
										}
									});
									displayDropdown($('#등기이사_소속' + thisIdx));
								} else {
									maintenance_info[thisName].forEach(belong => {
										$('[name=' + thisName + ']').each(function() {
											if ($(this).val() == belong) {
												$(this).prop('checked', true);
											}
										});
									});
									displayDropdown($('#등기이사_소속' + thisIdx));
								}
							}
						});

						if (maintenance_info['관리_계약_구분'] != undefined && maintenance_info['관리_계약_구분'].length > 0) {
							if (typeof maintenance_info['관리_계약_구분'] === 'string') {
								$('[name="관리_계약_구분"]').each(function() {
									if ($(this).val() == maintenance_info['관리_계약_구분']) {
										$(this).prop('checked', true);
									}
								});
							} else {
								maintenance_info['관리_계약_구분'].forEach(belong => {
									$('[name="관리_계약_구분"]').each(function() {
										if ($(this).val() == belong) {
											$(this).prop('checked', true);
										}
									});
								});
							}

							displayDropdown($('#관리_계약_구분'));
						}
					}
					//기본정보

					setJsonAutoMapping(account_info, 'accountInfo'); //계정 정보

					//금융정보
					const financeRepeatItem = [
						{name: '이자_지급일', id: 'addList_interest_pay_date', next: ''},
						{name: '보장발전시간_정산일', id: 'addList_payroll_date', next: ''},
						{name: '대리기관_수수료_지급일', id: 'addList_commission_payment', next: ''},
						{name: '입출금_구분', id: 'addList_account_holder', next: 'next'},
						{name: '공인인증서_등록', id: 'addList_certificate_registration', next: 'next'},
						{name: '임대료_지급일', id: 'addList_rental_deduction', next: 'next'},
					];

					setMakeTag(financeRepeatItem, finance_info, 'financeInfo'); //금융태그 생성
					if (finance_info['공인인증서'] === undefined && finance_info['SPC_법인_인감'] != null) {
						finance_info['공인인증서'] = finance_info['SPC_법인_인감'];
					}

					if(!isEmpty(finance_info['공인인증서']) && finance_info['공인인증서'].length > 0) {
						finance_info['공인인증서'].forEach((file, index) => {
							const fileInputList = document.querySelectorAll('#financeInfo input[type="file"]');
							let dataId = file['fieldname'].replace('공인인증서_등록_이미지', '공인인증서');
							let dataText = dataId.split('_');
							let dupIdx = Number(dataText[0].replace('공인인증서', ''));

							if (dupIdx > 0 && (dupIdx + 1) > fileInputList.length) {
								addRow('addList_certificate_registration', 'class');
								addRow('addList_certificate_registration2', 'class');
							}

							let use = '';
							if (isEmpty(file['용도'])) {
								if (!isEmpty(finance_info['용도 선택' + dupIdx])) {
									finance_info['공인인증서'][dupIdx]['용도'] = finance_info['용도 선택' + dupIdx];
									use = file['용도'];
								} else if (!isEmpty(finance_info['용도' + index])) {
									finance_info['공인인증서'][dupIdx]['용도'] = finance_info['용도' + dupIdx];
									use = file['용도'];
								}
							} else {
								use = file['용도'];
							}

							if (!isEmpty(use)) {
								$('#용도' + index + ' button').html(use.replace(/\_/g, ' ') + '<span class="caret"></span>').data('value', use);
							}

							let fileList = $('#financeInfo input[type="file"]').eq(dupIdx).parent().find('.file_list');
							if (fileList.find('li').length == 1) {
								if (fileList.find('li').eq(0).text() == '등록 파일 이름') {
									fileList.empty();
								}
							}

							let dataFile = $('#financeInfo input[type="file"]').eq(dupIdx).data('file');
							if (!isEmpty(dataFile)) {
								dataFile.push(file);
								$('#financeInfo input[type="file"]').eq(dupIdx).data('file', dataFile);
							} else {
								dataFile = new Array();
								dataFile.push(file);
								$('#financeInfo input[type="file"]').eq(dupIdx).data('file', dataFile);
							}

							let originalName = file['originalname'];
							let listItem = `<li class='upload-text existing' data-id="${'${dataId}'}">
												${'${originalName}'}
												<button type='button' class='btn-close icon-trash' onclick='deleteFile($(this))'></button>
											</li>`;
							fileList.append(listItem);
						});
					}

					Object.entries(finance_info).map(obj => {
						if (obj[0].match('은행_직접입력') && !isEmpty(obj[1])) {
							const idx = obj[0].replace(/[^0-9]/g, '');
							finance_info['은행_리스트' + idx] = '직접입력';
							$('#' + obj[0]).parent().removeClass('hidden');
						}
					});
					setJsonAutoMapping(finance_info, 'financeInfo');
					setJsonAutoMapping(contract_info, 'contractInfo'); //반복없음

					const insuranceRepeatItem = [
						{name: '보험구분', id: 'insuranceInfoToggle', next: ''}
					];
					setMakeTag(insuranceRepeatItem, addlist_insurance_info, 'insuranceInfo'); //금융태그 생성
					setJsonAutoMapping(addlist_insurance_info, 'insuranceInfo'); //보험정보 전체 반복

					const deviceRepeatItem = [
						{name: '모듈_제조사', id: 'addList_module_info', next: ''},
						{name: '모듈_설치_각도', id: 'addList_module_angle', next: ''},
						{name: '인버터_제조사', id: 'addList_inverter', next: ''},
						{name: '접속반_제조사', id: 'addList_manufacturer', next: ''},
						{name: '인버터_용량', id: 'addList_inverter_vol', next: ''},
						{name: '접속반_채널', id: 'addList_connection', next: ''},
						{name: '수배전반_제조사', id: 'addList_switch_gear', next: ''},
					];
					setMakeTag(deviceRepeatItem, device_info);
					setJsonAutoMapping(device_info, 'deviceInfo'); //설비정보
					if (device_info['설치_타입'] != undefined && device_info['설치_타입'].length > 0) {
						if (typeof device_info['설치_타입'] === 'string') {
							$('[name="설치_타입"]').each(function() {
								if ($(this).val() == device_info['설치_타입']) {
									$(this).prop('checked', true);
								}
							});
						} else {
							$('[name="설치_타입"]').each(function() {
								if ($.inArray($(this).val(), device_info['설치_타입']) >= 0) {
									$(this).prop('checked', true);
								}
							});
						}
					}

					if (device_info['모듈_설치_방식'] != undefined && device_info['모듈_설치_방식'].length > 0) {
						if (typeof device_info['모듈_설치_방식'] === 'string') {
							$('[name="모듈_설치_방식"]').each(function() {
								if ($(this).val() == device_info['모듈_설치_방식']) {
									$(this).prop('checked', true);
								}
							});
						} else {
							$('[name="모듈_설치_방식"]').each(function() {
								if ($.inArray($(this).val(), device_info['모듈_설치_방식']) >= 0) {
									$(this).prop('checked', true);
								}
							});
						}
					}

					setJsonAutoMapping(spend_info, 'spendInfo'); //보증정보
					setJsonAutoMapping(warranty_info, 'warrantyInfo'); //보증정보
					setJsonAutoMapping(coefficient_info, 'coefficientInfo'); //환경변수
					setJsonAutoMapping(associated_info, 'associatedInfo'); //관련정보

					getAttachFileDisplay(JSON.parse(json.data[0].attachement_info)); //첨부파일

					addDatePicker();

					$('[id^=보험_시작일]').each(function() {
						afterDatePick($(this).attr('name'));
					});

					afterDatePick('인출_가능_기한');

					sumUnpaid();
					financeAuto();
				} else {
					alert('등록된 데이터가 없습니다.');
				}
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}


	function setMakeTag(repeatItem, infoMap, targetId) {
		var $selecter = $('#' + targetId);
		repeatItem.forEach(function(el) {
			var repeatNumber= new Array();

			$.map(infoMap, function(val, key) {
				if (key.match(el.name)) {
					const tmp = Number(key.replace(el.name, ''));
					if (tmp > 0 && $selecter.find('#' + key).length == 0) {
						if ($.inArray(tmp, repeatNumber) === -1) repeatNumber.push(tmp);
					}
				}
			});

			if (!isEmpty(repeatNumber)) {
				repeatNumber.sort(); // index 기준으로 순서대로 생성하기위해서 정렬
				repeatNumber.forEach(function(index) {
					addRow(el.id, el.next, index);
				});
			}
		});

		if(targetId == "financeInfo"){
			setTimeout(function(){
				setDefaultAccList();
			}, 300);
		}
	}

	function setDefaultAccList() {
		$('.account-type').each(function(){
			let btn = $(this).find(".dropdown-toggle");
			let accBtn = $(this).next().find(".dropdown-toggle");
			let accList = $(this).next().find('ul');
			let accListItem = $(this).next().find('ul li[data-group]');
			accListItem.addClass("hidden");

			if(btn.text() == "입금"){
				accListItem.not('[data-group="출금"]').removeClass("hidden");
			} else if(btn.text() == "출금") {
				accListItem.not('[data-group="입금"]').removeClass("hidden");
			} else {
				accListItem.addClass("hidden");
				if (accList.find('li[data-default]').length == 0) {
					let str = '<li data-default="select" data-value="select"><a href="#">입출금 구분을 선택해 주세요.</a></li>'
					accList.append(str)
				}
			}
		});
	}

	function setSaveData(){
		sendSpcPatchPost();
	}

	function sendSpcPatchPost(){
		var spcId = '${param.spc_id}',
			spc_info = setAreaParamData('basicInfo', 'dropdown');

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
				let totalFiles = new Array();
				let resultFiles = result.files;

				//추가
				$('#basicForm').find('input[type="file"]').each(function () {
					if (!isEmpty($(this).data('file'))) {
						let targetFile = $(this).data('file');
						let button = $(this).parents('div.group-type').find('.dropdown').find('button').data('value');
						targetFile['SPC_법인_인감_유형'] = button;
						totalFiles = totalFiles.concat(targetFile);
					}
				});

				//신규
				resultFiles.forEach(function (el) {
					let fieldname = el.fieldname;
					$('#basicForm').find('input[type="file"]').each(function () {
						if (fieldname == $(this).attr('name')) {
							let button = $(this).parents('div.group-type').find('.dropdown').find('button').data('value');
							el['SPC_법인_인감_유형'] = button;
						}
					});
				});

				spc_info['SPC_법인_인감'] = totalFiles.concat(resultFiles);
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});

		if ($(':radio[name="SPC_법인_인감_대표"]:checked').val() != undefined) {
			spc_info['spcSealSelected'] = $(':radio[name="SPC_법인_인감_대표"]:checked').val();
		}

		$.ajax({
			url: apiHost + '/spcs/'+ spcId + '?oid='+oid,
			type: 'patch',
			dataType: 'json',
			async: true,
			contentType: 'application/json',
			data: JSON.stringify({
				name: $('#name').val(),
				spc_info: JSON.stringify(spc_info),
				updated_by: loginId
			}),
			success: function (json) {
				sendSpcAttchFilePost();
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function sendSpcAttchFilePost(){
		let spcId = '${param.spc_id}',
			genId = '${param.gen_id}';

		let existFileList = $('#fileList01').data('gridJsonData')
							.concat($('#fileList02').data('gridJsonData'))
							.concat($('#fileList03').data('gridJsonData'))
							.concat($('#fileList04').data('gridJsonData'))
							.concat($('#fileList05').data('gridJsonData'))
							.concat($('#fileList06').data('gridJsonData'))
							.concat($('#fileList07').data('gridJsonData'))
							.concat($('#fileList08').data('gridJsonData'))
							.concat($('#fileList09').data('gridJsonData'))
							.concat($('#fileList10').data('gridJsonData'));

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

		sendSpcGenPatchPost(existFileList);
	}

	function loopFile(target, index, fileList) {
		if (fileList[index] != undefined) {
			if (target.textContent.trim() != fileList[index].name) {
				fileList.splice(index, 1);
				loopFile(target, index, fileList);
			}
		}
	}

	function sendSpcGenPatchPost(files){
		var spcId = '${param.spc_id}',
			genId = '${param.gen_id}';

		var address_info = setAreaParamData('addressInfo', 'dropdown'),
			maintenance_info = setAreaParamData('maintenanceInfo', 'dropdown'),
			account_info = setAreaParamData('accountInfo'),
			finance_info = setAreaParamData('financeInfo', 'dropdown'),
			contract_info = setAreaParamData('contractInfo'),
			addlist_insurance_info = setAreaParamData('insuranceInfo'),
			spend_info = setAreaParamData('spendInfo'),
			device_info = setAreaParamData('deviceInfo'),
			warranty_info = setAreaParamData('warrantyInfo', 'dropdown'),
			coefficient_info = setAreaParamData('coefficientInfo'),
			associated_info = setAreaParamData('associatedInfo'),
			attachement_info = files;

		let certificationFiles = new Array();
		//추가
		$('#financeInfo').find('input[type="file"]').each(function () {
			if (!isEmpty($(this).data('file'))) {
				let targetFile = $(this).data('file');
				let use = $(this).parents('div.group-type').find('button').data('value');
				targetFile.forEach((file, idx) => {
					targetFile[idx]['용도'] = use;
				});

				certificationFiles = certificationFiles.concat(targetFile);
			}
		});

		$('#financeInfo').find('input[type="file"]').each(function () {
			const liList =$(this).parent().find('.file_list li:not(.existing)');
			let fileList = Array.from($(this)[0].files);

			liList.each(function(index, target) {
				loopFile(target, index, fileList);
			});

			if (fileList.length > 0) {
				let formData = new FormData($('#fileUploadForm')[0]),
					filedName = $(this).attr('name') + '_' + genUuid();
				fileList.forEach(function(file, index) {
					formData.append(filedName + index, file);
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
									let button = $(this).parents('div.group-type').find('.dropdown').find('button').data('value');
									el['용도'] = button;
								}
							});
						});
						certificationFiles = certificationFiles.concat(resultFiles);
					},
					error: function (request, status, error) {
						alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
					}
				});
			}
		});
		finance_info['공인인증서'] = certificationFiles;

		Object.entries(finance_info).map(obj => {
			if (obj[0].match('은행_리스트') && obj[1] == '직접입력') {
				const idx = obj[0].replace(/[^0-9]/g, ''),
					bnkName = finance_info['은행_직접입력' + idx];
				finance_info[obj[0]] = bnkName;
			}
		});

		$.ajax({
			url: apiHost + '/spcs/' + spcId +'/gens/' + genId + '?oid=' + oid,
			type: 'patch',
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
				spend_info: JSON.stringify(spend_info),
				account_info: JSON.stringify(account_info),
				updated_by: loginId,
				del_yn: 'N'
			}),
			success: function (json) {
				alert('수정되었습니다.');
				goNowPage(spcId, genId);
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
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
		var idx = thisName.replace(/[^0-9]/g, '');
		if (thisName.match('보험_시작일')) {
			var open = $('#' + thisName).datepicker('getDate'),
				close = $('#보험_종료일' + idx).datepicker('getDate'),
				expiry = $('#보험_만기일' + idx).datepicker('getDate');

			//보험 종료일 차이 구하기
			if (close != null && open != null) {
				var diff = dateDiff(close, open, 'day');
				$('#보험_종료일' + idx).parent().next('span').html(diff + '일 남음');
				$('#보험_종료일_차이' + idx).val(diff + '일 남음');
			}

			//보험 만료일 차이 구하기
			if (expiry != null && open != null) {
				var diff = dateDiff(expiry, open, 'day');
				$('#보험_만기일' + idx).parent().next('span').html(diff + '일 남음');
				$('#보험_만기일_차이' + idx).val(diff + '일 남음');
			}
		} else if (thisName.match('보험_종료일')) {
			var close = $('#' + thisName).datepicker('getDate'),
				open = $('#보험_시작일' + idx).datepicker('getDate');

			//보험 종료일 차이 구하기
			if (close != null && open != null) {
				var diff = dateDiff(close, open, 'day');
				$('#' + thisName).parent().next('span').html(diff + '일 남음');
				$('#보험_종료일_차이' + idx).val(diff + '일 남음');
			}
		} else if (thisName.match('보험_만기일')) {
			var expiry = $('#' + thisName).datepicker('getDate'),
				open = $('#보험_시작일' + idx).datepicker('getDate');

			//보험 종료일 차이 구하기
			if (expiry != null && open != null) {
				var diff = dateDiff(expiry, open, 'day');
				$('#' + thisName).parent().next('span').html(diff + '일 남음');
				$('#보험_만기일_차이' + idx).val(diff + '일 남음');
			}
		}
		// else if (thisName == '인출_가능_기한') {
		// 	if (!isEmpty($('#인출_가능_기한').text().trim())) {
		// 		var close = $('#인출_가능_기한').val().trim().split('-')
		// 		close = new Date(close[0], close[1], close[2]);
		// 		let diff = dateDiff(close, new Date(), 'day');
		//
		// 		$('#인출_가능_남은일').html(Math.floor(diff) + '일&nbsp;&nbsp;남음');
		// 	}
		// } else if (thisName == '공사_계약_정보_약정일') {
		// 	let close = $('#' + thisName).datepicker('getDate');
		// 	close.setFullYear(close.getFullYear() + 1);
		// 	let diff = dateDiff(close, new Date(), 'day')
		//
		// 	$('#인출_가능_기한').val(close.format('yyyy-MM-dd'));
		// 	$('#인출_가능_남은일').html(Math.floor(diff) + '일&nbsp;&nbsp;남음');
		// }
	}

	const sumUnpaid = () => {
		const contractPay = Number($('#도급_계약서_공사_계약_금액').val().replace(/[^0-9]/g, '')),
			agreementPay = Number($('#약정_금액').val().replace(/[^0-9]/g, '')),
			paymentsFirst = Number($('#지급금액_1차').val().replace(/[^0-9]/g, '')),
			paymentsSecond = Number($('#지급금액_2차').val().replace(/[^0-9]/g, '')),
			paymentsThird = Number($('#지급금액_3차').val().replace(/[^0-9]/g, ''));

		const sumUnPaidPay = contractPay + agreementPay - paymentsFirst - paymentsSecond - paymentsThird;

		if (contractPay == 0 && agreementPay == 0 && paymentsFirst == 0 && paymentsSecond == 0 && paymentsThird == 0) {
			$('#미지급_금액').text('자동 계산');
		} else {
			$('#미지급_금액').text(numberComma(sumUnPaidPay));
		}
	}

	function rtnDropdown($dropdownId) {
		if ($dropdownId.match('은행_리스트')) {
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

	function goNowPage(spcId, genId){
		location.href = '/spc/entityDetails.do?spc_id=' + spcId + '&gen_id=' + genId + '&oid=' + oid;
	}

	function goMoveList(){
		location.href = '/spc/entityInformation.do';
	}

</script>

<!-- Modal (처리 중 모달)-->
<div id="sendSpcPostModal" class="modal fade" role="dialog">
	<div class="modal-dialog history-alarm">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-title">
				<h2 class="ly_tit" style="text-align: center;">처리중...</h2>
			</div>
		</div>
	</div>
</div>

<div class="row entity-header">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 수정</h1>
	</div>
</div>

<form id="upload" name="upload" method="multipart/form-data"></form>

<div class="row entity-wrapper post panel-group" id="accordion">
	<div class="col-12">
		<div class="indiv panel panel-default" id="basicInfo">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">기본 정보</h2>
				<a role="button" href="#basicInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a>
			</div>
			<div id="basicInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
							<td class="group-type">
								<div class="text-input-type edit disabled">
									<label for="name" class="sr-only">SPC명 입력</label>
									<input type="text" id="name" name="name" placeholder="SPC명 입력" readonly>
									<input type="hidden" id="spcId" name="spcId" readonly>
								</div>
							</td>
							<th><label for="대표자">대표자</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="대표자" name="대표자" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="사업자등록번호">사업자등록번호</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="사업자등록번호" name="사업자등록번호" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="법인등록번호">법인등록번호</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="법인등록번호" name="법인등록번호" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>주소</th>
							<td class="group-type">
								<div class="dropdown placeholder edit" id="spcCountry">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown">
										국가 선택<span class="caret"></span>
									</button>
									<ul id="spcCountryList" class="dropdown-menu" role="menu">
										<li data-value="[value]">
											<a href="javascript:void(0);">[value]</a>
										</li>
									</ul>
								</div>
								<div class="dropdown placeholder edit mr-12" id="spcSido">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown">
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
								<div class="text-input-type edit">
									<input type="text" id="spcAddress" name="spcAddress" placeholder="상세 주소">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="사업명">사업명</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="사업명" name="사업명" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="펀드명">펀드명</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="펀드명" name="펀드명" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="금융사">금융사</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="금융사" name="금융사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="금융사_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="금융사_담당자(연락처)" name="금융사_담당자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="금융사_대리기관">금융사 대리기관</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="금융사_대리기관" name="금융사_대리기관" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="금융사_대리기관_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="금융사_대리기관_담당자(연락처)" name="금융사_대리기관_담당자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="시공사">시공사</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="시공사" name="시공사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="시공사_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="시공사_담당자(연락처)" name="시공사_담당자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="사무수탁사">사무수탁사</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="사무수탁사" name="사무수탁사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="사무수탁사_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="사무수탁사_담당자(연락처)" name="사무수탁사_담당자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="관리_운영사">관리 운영사</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="관리_운영사" name="관리_운영사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="발전_관리자(연락처)">발전 관리자(연락처)</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="발전_관리자(연락처)" name="발전_관리자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th></th>
							<td></td>
							<th><label for="사업_관리자(연락처)">사업 관리자(연락처)</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="사업_관리자(연락처)" name="사업_관리자(연락처)" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th class="group-type">SPC 법인 인감
								<a href="javascript:addRow('addList_registered_seal');" class="btn-add fr">추가</a>
							</th>
							<td id="addList_registered_seal" class="entity">
								<div class="group-type">
									<div class="dropdown placeholder edit" id="spcSeal[index]">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="인감 선택">인감 선택<span class="caret"></span></button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="사용_인감">
												<a href="#">사용 인감</a>
											</li>
											<li data-value="법인_인감">
												<a href="#">법인 인감</a>
											</li>
										</ul>
									</div>
									<div class="fixed-height">
										<input type="file" id="SPC_법인_인감_파일[index]" class="hidden" name="SPC_법인_인감_파일" accept=".jpg, .png, .pdf">
										<label for="SPC_법인_인감_파일[index]" class="btn file-upload">파일 선택</label>
										<span class="upload-text ml-16"></span>
										<span class="radio-type">
											<input type="radio" id="SPC_법인_인감_대표[index]" name="SPC_법인_인감_대표" value="[index]">
											<label for="SPC_법인_인감_대표[index]">대표 인감</label>
										</span>
										<button type="button" class="btn-close fixed-height hidden mt-0" onclick="$(this).parents().closest('.group-type').remove()"></button>
									</div>
								</div>
							</td>
							<th></th>
							<td>
								<div class="fixed-height"></div>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="btn-wrap-type02"><!--
			--><button type="button" class="btn-type03" onclick="goMoveList();">목록</button><!--
			--><button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button><!--
			--></div>
		</div>

		<div class="indiv panel panel-default" id="addressInfo">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">발전소 정보</h2>
				<a role="button" href="#addressInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a>
			</div>
			<div id="addressInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="genName">발전소명</label></th>
						<td>
							<div class="text-input-type edit disabled">
								<input type="text" id="genName" name="genName" placeholder="발전소명 입력" readonly>
							</div>
						</td>
						<th></th>
						<td>
							<div class="fixed-height"></div>
						</td>
					</tr>
					<tr>
						<th>발전소 주소</th>
						<td class="group-type">
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
						<th><label for="발전소_상세주소">발전소 상세 주소</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="발전소_상세주소" name="발전소_상세주소" placeholder="상세 주소">
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02"><!--
			--><button type="button" class="btn-type03" onclick="goMoveList();">목록</button><!--
			--><button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button><!--
			--></div>
		</div>

		<div class="indiv panel panel-default" id="maintenanceInfo">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">관리 운영 정보</h2>
				<a href="#maintenanceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a>
			</div>
			<div id="maintenanceInfoToggle" class="spc-table-row st-edit panel-collapse collapse in">
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
								<div class="group-type">
									<div class="text-input-type edit unit t1">
										<input type="text" id="설치_용량" name="설치_용량" placeholder="설치용량">
										<span>kW</span>
									</div>
									<div class="text-input-type edit">
										<input type="text" id="설치_용량_기타" name="설치_용량_기타" placeholder="태양광">
									</div>
								</div>
							</fieldset>
						</td>
						<th>관리 운영 기간</th>
						<td>
							<fieldset class="sel-calendar edit twin clear dateField">
								<legend class="sr-only">관리 운영 기간</legend>
								<input type="text" id="관리_운영_기간_from" name="관리_운영_기간_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="관리_운영_기간_to" name="관리_운영_기간_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="기상_관측_지점">기상 관측 지점</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="기상_관측_지점" name="기상_관측_지점" placeholder="직접 입력">
							</div>
						</td>
						<th>하자 보증기간(전기)</th>
						<td>
							<fieldset class="sel-calendar edit twin clear dateField">
								<legend class="sr-only">하자 보증기간(전기)</legend>
								<input type="text" id="하자_보증기간(전기)_from" name="하자_보증기간(전기)_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="하자_보증기간(전기)_to" name="하자_보증기간(전기)_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="사용_전_검사_완료일">사용 전 검사 완료일</label></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="사용_전_검사_완료일" name="사용_전_검사_완료일" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th>하자 보증기간(토목)</th>
						<td>
							<fieldset class="sel-calendar edit twin clear dateField">
								<legend class="sr-only">하자 보증기간(토목)</legend>
								<input type="text" id="하자_보증기간(토목)_from" name="하자_보증기간(토목)_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="하자_보증기간(토목)_to" name="하자_보증기간(토목)_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
					</tr>

					<tr>
						<th>
							<span class="">등기이사 소속</span>
							<a href="javascript:addRow('addList_affiliation', 'class');addRow('addList_affiliation2', 'class');" class="btn-add fr">추가</a>
						</th>
						<td class="addList_affiliation entity">
							<div class="group-type">
								<div class="dropdown placeholder edit" id="등기이사_소속[index]">
									<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown">
										소속 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk-type" role="menu">
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="등기이사_소속0_[index]" value="사내_이사" name="등기이사_소속_[index]">
												<label for="등기이사_소속0_[index]">사내 이사</label>
											</a>
										</li>
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="등기이사_소속1_[index]" value="사외_이사" name="등기이사_소속_[index]">
												<label for="등기이사_소속1_[index]">사외 이사</label>
											</a>
										</li>
										<li>
											<a href="#" tabindex="-1">
												<input type="checkbox" id="등기이사_소속2_[index]" value="대표_이사" name="등기이사_소속_[index]">
												<label for="등기이사_소속2_[index]">대표 이사</label>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="등기이사_소속3_[index]" value="감사" name="등기이사_소속_[index]">
												<label for="등기이사_소속3_[index]">감사</label>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="등기이사_소속4_[index]" value="기타비상무이사" name="등기이사_소속_[index]">
												<label for="등기이사_소속4_[index]">기타비상무이사</label>
											</a>
										</li>
									</ul>
								</div>
								<div class="text-input-type edit">
									<label for="등기이사_명[index]" class="sr-only"></label>
									<input type="text" id="등기이사_명[index]" name="등기이사_명[index]" placeholder="이름 직접 입력">
								</div>
							</div>
						</td>
						<th>등기 기간</th>
						<td class="addList_affiliation2 entity">
							<div class="group-type flex-start">
								<fieldset class="sel-calendar edit twin clear dateField">
									<legend class="sr-only">등기 기간</legend>
									<input type="text" id="등기_기간_from[index]" name="등기_기간_from[index]" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
									<input type="text" id="등기_기간_to[index]" name="등기_기간_to[index]" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
								</fieldset>

								<div class="fr fixed-height mt-5 mr-12">
									<button type="button" class="btn-close hidden" onclick="removeList(this, 'dual')"></button>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="계약_단가">계약 단가</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="계약_단가" name="계약_단가" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<th>상업 운전 개시일</th>
						<td>
							<fieldset class="sel-calendar edit twin clear dateField">
								<legend class="sr-only">상업 운전 개시일</legend>
								<input type="text" id="상업_운전_개시일" name="상업_운전_개시일" class="sel toDate" value="" autocomplete="off" placeholder="상업 운전 개시일" readonly>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="부지소유">부지 소유 / 임대 구분</label></th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="부지 소유 혹은 임대 구분"></legend>
								<div class="radio-group">
									<input type="radio" id="부지소유" name="부지소유/임대구분" value="부지소유">
									<label for="부지소유">소유</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="임대구분" name="부지소유/임대구분" value="임대구분">
									<label for="임대구분">임대</label>
								</div>
							</fieldset>
						</td>
						<th>개발행위필증 교부 여부</th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="개발행위필증 교부 여부"></legend>
								<div class="radio-group">
									<input type="radio" id="개발행위필증_교부" name="개발행위필증_교부_여부" value="교부">
									<label for="개발행위필증_교부">교부함</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="개발행위필증_미교부" name="개발행위필증_교부_여부" value="미교부">
									<label for="개발행위필증_미교부">해당 없음</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>지상권 및 지상권부근저당 설정 여부</th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="지상권 및 지상권부근저당 설정 여부"></legend>
								<div class="radio-group">
									<input type="radio" id="지상권" name="지상권설정여부" value="지상권">
									<label for="지상권">지상권</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="지상권부근저당" name="지상권설정여부" value="지상권부근저당">
									<label for="지상권부근저당">지상관부근저당</label>
								</div>
							</fieldset>
						</td>
						<th>동산담보표지판 설정 여부</th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="동산담보표지판 설정 여부"></legend>
								<div class="radio-group">
									<input type="radio" id="동산담보표지판_설정" name="동산담보표지판_설정_여부" value="동산담보표지판_설정">
									<label for="동산담보표지판_설정">설정함</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="동산담보표지판_미설정" name="동산담보표지판_설정_여부" value="동산담보표지판_미설정">
									<label for="동산담보표지판_미설정">해당 없음</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>자가부지공장근저당 목록 설정 여부</th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="자가부지공장근저당 목록 설정 여부"></legend>
								<div class="radio-group">
									<input type="radio" id="자가부지공장근저당_설정" name="자가부지공장근저당" value="자가부지공장근저당_설정">
									<label for="자가부지공장근저당_설정">설정함</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="자가부지공장근저당_미설정" name="자가부지공장근저당" value="자가부지공장근저당_미설정">
									<label for="자가부지공장근저당_미설정">해당 없음</label>
								</div>
							</fieldset>
						</td>
						<th>권리증 보유 현황</th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="부지 소유 혹은 임대 구분"></legend>
								<div class="radio-group">
									<input type="radio" id="권리증_보유_현황_사무위탁사" name="권리증_보유_현황" value="권리증_보유_현황_사무위탁사">
									<label for="권리증_보유_현황_사무위탁사">사무위탁사</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="권리증_보유_현황_자산운영사" name="권리증_보유_현황" value="권리증_보유_현황_자산운영사">
									<label for="권리증_보유_현황_자산운영사">자산운영사</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>운영 여부</th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="운영 여부"></legend>
								<div class="radio-group">
									<input type="radio" id="운영_여부_운영중" name="운영_여부" value="운영_여부_운영중">
									<label for="운영_여부_운영중">운영중</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="운영_여부_운영예정" name="운영_여부" value="운영_여부_운영예정">
									<label for="운영_여부_운영예정">운영 예정</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="운영_여부_해지" name="운영_여부" value="운영_여부_해지">
									<label for="운영_여부_해지">해지</label>
								</div>
							</fieldset>
						</td>
						<th>관리 계약 구분</th>
						<td>
							<div class="dropdown placeholder edit mr-12 w-300px" id="관리_계약_구분">
								<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown">
									선택<span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk-type" role="menu">
									<li>
										<a href="#" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_전체" value="전체" name="관리_계약_구분">
											<label for="관리_계약_구분_전체">전체</label>
										</a>
									</li>
									<li>
										<a href="#" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_종합" value="종합" name="관리_계약_구분">
											<label for="관리_계약_구분_종합">종합</label>
										</a>
									</li>
									<li>
										<a href="#" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_일반관리" value="일반관리" name="관리_계약_구분">
											<label for="관리_계약_구분_일반관리">일반관리</label>
										</a>
									</li>
									<li>
										<a href="#" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_사무수탁" value="사무수탁" name="관리_계약_구분">
											<label for="관리_계약_구분_사무수탁">사무수탁</label>
										</a>
									</li>
									<li>
										<a href="#" tabindex="-1">
											<input type="checkbox" id="관리_계약_구분_보험" value="보험" name="관리_계약_구분">
											<label for="관리_계약_구분_보험">보험</label>
										</a>
									</li>
									<li>
										<a href="#" tabindex="-1">
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
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="accountInfo">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">계정 정보</h2>
				<a role="button" href="#accountInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a>
			</div>
			<div id="accountInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
							<div class="text-input-type edit">
								<input type="text" id="RPS_시스템_ID" name="RPS_시스템_ID" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="RPS_시스템_PW">PW</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="password" id="RPS_시스템_PW" name="RPS_시스템_PW" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="전력_거래소_ID">전력 거래소 ID</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="전력_거래소_ID" name="전력_거래소_ID" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="전력_거래소_PW">PW</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="password" id="전력_거래소_PW" name="전력_거래소_PW" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="REC_발전사_ID">REC 발전사 ID</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="REC_발전사_ID" name="REC_발전사_ID" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="발전사명">발전사명</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="발전사명" name="발전사명" placeholder="직접 입력">
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="financeInfo">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">금융 정보</h2>
				<a role="button" href="#financeInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a>
			</div>
			<div id="financeInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
								<div class="text-input-type edit">
									<input type="text" id="관련_금융사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="금융사_대표자">대표자</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="금융사_대표자" name="금융사_대표자" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="계약_체결일">계약 체결일</label></th>
							<td>
								<div class="sel-calendar edit">
									<input type="text" id="계약_체결일" name="계약_체결일" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</td>
							<th><label for="대출_약정액">대출 약정액</label></th>
							<td>
								<div class="text-input-type edit unit t1">
									<input type="text" id="대출_약정액" class="right" name="대출_약정액">
									<span>원</span>
								</div>
							</td>
						</tr>
						<tr>
							<th class="group-type"><label for="상환_만기일">상환 만기일</label></th>
							<td>
								<div class="sel-calendar edit">
									<input type="text" id="상환_만기일" class="sel datepicker" name="상환_만기일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</td>
							<th class="group-type">
								<label for="이자_지급일0">이자 지급일</label>
								<a href="javascript:addRow('addList_interest_pay_date');" class="btn-add fr">추가</a>
							</th>
							<td id="addList_interest_pay_date" class="entity">
								<div class="group-type flex-start">
									<div class="sel-calendar edit">
										<input type="text" id="이자_지급일[index]" class="sel datepicker" name="이자_지급일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									</div>
									<button type="button" class="btn-close hidden fr" onclick="removeList(this)"></button>
								</div>
							</td>
						</tr>
						<tr>
							<th class="group-type">
								<label for="보장발전시간_정산일0">보장발전시간 정산일</label>
								<a href="javascript:addRow('addList_payroll_date');" class="btn-add fr">추가</a>
							</th>
							<td id="addList_payroll_date" class="entity">
								<div class="group-type flex-start">
									<div class="sel-calendar edit">
										<input type="text" id="보장발전시간_정산일[index]" class="sel datepicker" name="보장발전시간_정산일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									</div>
									<button type="button" class="btn-close hidden fr" onclick="removeList(this)"></button>
								</div>
							</td>
							<th>
								<label for="대리기관_수수료_지급일0">대리기관 수수료 지급일</label>
								<a href="javascript:addRow('addList_commission_payment');" class="btn-add fr">추가</a>
							</th>
							<td id="addList_commission_payment" class="entity">
								<div class="group-type flex-start">
									<div class="sel-calendar edit">
										<input type="text" id="대리기관_수수료_지급일[index]" class="sel datepicker" name="대리기관_수수료_지급일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									</div>
									<button type="button" class="btn-close hidden fr" onclick="removeList(this)"></button>
								</div>
							</td>
						</tr>
						<tr class="addList_account_holder entity">
							<th>
								<div class="fixed-height">은행 계좌</div>
								<a href="javascript:addRow('addList_account_holder', 'next'); setDefaultAccList();" class="btn-add fr mt-offset-10">추가</a>
								<div class="fixed-height"><label for="예금주[index]">예금주</label></div>
								<div class="fixed-height"><label for="빠른조회_비밀번호[index]">빠른조회_비밀번호</label></div>
							</th>
							<td>
								<div class="fixed-height group-type short">
									<div class="account-type dropdown placeholder edit" id="입출금_구분[index]"><!--
										--><button type="button" class="dropdown-toggle" data-toggle="dropdown">입출금 구분<span class="caret"></span></button><!--
										--><ul class="dropdown-menu" role="menu"><!--
											--><li data-value="입금"><a href="#">입금</a></li><!--
											--><li data-value="출금"><a href="#">출금</a></li><!--
										--></ul><!--
								--></div>
									<div class="dropdown placeholder edit" id="계좌구분[index]"><!--
									--><button type="button" class="dropdown-toggle" data-toggle="dropdown">계좌구분<span class="caret"></span></button><!--
									--><ul id="계좌구분리스트[index]" class="dropdown-menu" role="menu"><!--
										--><li data-default="select" data-value="select"><a href="#">입출금 구분을 선택해 주세요.</a></li><!--
										--><li data-group="입금" data-value="관리운영비"><a href="#">관리 운영비</a></li><!--
										--><li data-group="입금" data-value="사무수탁비"><a href="#">사무 수탁비</a></li><!--
										--><li data-group="입금" data-value="공사비"><a href="#">공사비</a></li><!--
										--><li data-group="입금" data-value="임대료"><a href="#">임대료</a></li><!--
										--><li data-group="입금" data-value="대납금"><a href="#">대납금</a></li><!--
										--><li data-group="입금" data-value="부채상환"><a href="#">부채 상환</a></li><!--
										--><li data-group="입금" data-value="대수선비"><a href="#">대수선비</a></li><!--
										--><li data-group="입금" data-value="배당금적립"><a href="#">배당금 적립</a></li><!--
										--><li data-group="입금" data-value="일반지출"><a href="#">일반 지출</a></li><!--
										--><li data-group="입금" data-value="DSRA적립"><a href="#">DSRA 적립</a></li><!--
										--><li data-group="입금" data-value="운영계좌"><a href="#">운영계좌</a></li><!--
										--><li data-group="입금" data-value="기타"><a href="#">기타</a></li><!--

										--><li data-group="출금" data-value="관리운영비"><a href="#">관리 운영비</a></li><!--
										--><li data-group="출금" data-value="사무수탁비"><a href="#">사무 수탁비</a></li><!--
										--><li data-group="출금" data-value="공사비"><a href="#">공사비</a></li><!--
										--><li data-group="출금" data-value="임대료"><a href="#">임대료</a></li><!--
										--><li data-group="출금" data-value="대납금"><a href="#">대납금</a></li><!--
										--><li data-group="출금" data-value="부채상환"><a href="#">부채 상환</a></li><!--
										--><li data-group="출금" data-value="대수선비"><a href="#">대수선비</a></li><!--
										--><li data-group="출금" data-value="배당금적립"><a href="#">배당금 적립</a></li><!--
										--><li data-group="출금" data-value="일반지출"><a href="#">일반 지출</a></li><!--
										--><li data-group="출금" data-value="REC수익"><a href="#">REC 수익</a></li><!--
										--><li data-group="출금" data-value="SMP수익"><a href="#">SMP 수익</a></li><!--
										--><li data-group="출금" data-value="DSRA적립"><a href="#">DSRA 적립</a></li><!--
										--><li data-group="출금" data-value="운영계좌"><a href="#">운영계좌</a></li><!--
										--><li data-group="출금" data-value="유보계좌"><a href="#">유보계좌</a></li><!--
										--><li data-group="출금" data-value="기타"><a href="#">기타</a></li><!--
									--></ul><!--
								--></div>
									<div class="dropdown placeholder edit" id="은행_리스트[index]"><!--
									--><button type="button" class="dropdown-toggle" data-toggle="dropdown">은행 리스트<span class="caret"></span></button><!--
									--><ul class="dropdown-menu" role="menu"><!--
										--><li data-id="0020" data-value="우리"><a href="#">우리</a></li><!--
										--><li data-id="0004" data-value="국민"><a href="#">국민</a></li><!--
										--><li data-id="0003" data-value="기업"><a href="#">기업</a></li><!--
										--><li data-id="0011" data-value="농협"><a href="#">농협</a></li><!--
										--><li data-id="0088" data-value="신한"><a href="#">신한</a></li><!--
										--><li data-id="0081" data-value="KEB하나"><a href="#">KEB하나</a></li><!--
										--><li data-id="0027" data-value="씨티"><a href="#">한국씨티</a></li><!--
										--><li data-id="0023" data-value="SC"><a href="#">SC제일</a></li><!--
										--><li data-id="0039" data-value="경남"><a href="#">경남</a></li><!--
										--><li data-id="0034" data-value="광주"><a href="#">광주</a></li><!--
										--><li data-id="0031" data-value="대구"><a href="#">대구</a></li><!--
										--><li data-id="0032" data-value="부산"><a href="#">부산</a></li><!--
										--><li data-id="0002" data-value="산업"><a href="#">산업</a></li><!--
										--><li data-id="0045" data-value="새마을금고"><a href="#">새마을금고</a></li><!--
										--><li data-id="0007" data-value="수협"><a href="#">수협</a></li><!--
										--><li data-id="0048" data-value="신협"><a href="#">신협</a></li><!--
										--><li data-id="0071" data-value="우체국"><a href="#">우체국</a></li><!--
										--><li data-id="0037" data-value="전북"><a href="#">전북</a></li><!--
										--><li data-id="0035" data-value="제주"><a href="#">제주</a></li><!--
										--><li data-id="0089" data-value="K뱅크"><a href="#">K뱅크</a></li><!--
										--><li data-id="1001" data-value="상호저축"><a href="#">상호저축</a></li><!--
										--><li data-id="0000" data-value="직접입력"><a href="#">직접입력</a></li><!--
									--></ul><!--
								--></div>
								</div>
								<div class="fixed-height">
									<div class="group-type">
										<div class="text-input-type edit unit t1">
											<input type="text" id="예금주[index]" name="예금주[index]" placeholder="직접 입력">
										</div>
										<div class="text-input-type edit hidden">
											<input type="text" id="은행_직접입력[index]" name="은행_직접입력[index]" placeholder="직접 입력">
										</div>
									</div>
								</div>
								<div class="text-input-type edit">
									<input type="text" id="빠른조회_비밀번호[index]" name="빠른조회_비밀번호[index]" placeholder="직접 입력">
								</div>
							</td>
							<th>
								<div class="fixed-height"><label for="계좌_번호[index]">계좌 번호</label></div>
								<div class="fixed-height"><label for="계좌개설_은행(지점)[index]">계좌개설 은행(지점)</label></div>
							</th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="계좌_번호[index]" name="계좌_번호[index]" placeholder="직접 입력">
								</div>
								<button type="button" class="btn-close hidden mr-12 fr" onclick="$(this).parents().closest('tr').remove()"></button>
								<div class="text-input-type edit">
									<input type="text" id="계좌개설_은행(지점)[index]" name="계좌개설_은행(지점)[index]" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="빠른조회_비밀번호">빠른조회 비밀번호</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="빠른조회_비밀번호" name="빠른조회_비밀번호" placeholder="직접 입력">
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th class="group-type">
								공인인증서 등록 <a href="javascript:addRow('addList_certificate_registration', 'class'); addRow('addList_certificate_registration2', 'class');" class="btn-add fr">추가</a>
							</th>
							<td class="addList_certificate_registration entity">
								<div class="group-type flex-start">
									<div id="용도[index]" class="dropdown placeholder edit mxw-100px">
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
										<label for="공인인증서_등록_이미지[index]" class="btn file-upload">파일 선택</label>
										<ul class="file_list ml-16">
											<li>등록 파일 이름</li>
										</ul>
									</div>
								</div>
							</td>
							<th><label for="인증서_비밀번호[index]">인증서 비밀번호</label></th>
							<td class="addList_certificate_registration2 entity">
								<div class="group-type flex-start">
									<div class="text-input-type edit w-300px">
										<input type="password" id="인증서_비밀번호[index]" name="인증서_비밀번호[index]" placeholder="비밀번호를 입력해 주세요.">
									</div>
									<div class="fr fixed-height mt-5 mr-12">
										<button type="button" class="btn-close hidden" onclick="removeList(this, 'dual')"></button>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="DSRA_적립_요구금액">DSRA 적립 요구금액</label></th>
							<td>
								<div class="text-input-type edit">
									<input type="text" id="DSRA_적립_요구금액" name="DSRA_적립_요구금액" placeholder="직접 입력">
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>
								<div class="fixed-height">고정 금액</div>
								<div class="fixed-height"><label for="전체_용량">전체 용량</label></div>
								<div class="fixed-height"><label for="관리_운영비">관리 운영비</label></div>
								<div class="fixed-height"><label for="대수선비">대수선비</label></div>
								<div class="fixed-height"><label for="사무_수탁비">사무 수탁비</label></div>
								<div class="fixed-height"><label for="임대료">임대료</label></div>
								<div class="fixed-height"><label for="SMP">SMP</label></div>
								<div class="fixed-height"><label for="REC">REC</label></div>
							</th>
							<td class="align-top">
								<div class="fixed-height"></div>
								<div class="flex-start">
									<div class="text-input-type edit unit t1 mr-30">
										<input type="text" id="전체_용량" class="right" name="전체_용량" placeholder="">
										<span>MW</span>
									</div>
								</div>
								<div class="flex-start">
									<div class="text-input-type edit unit t1 mr-30">
										<input type="text" id="관리_운영비" class="right" name="관리_운영비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed-height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="flex-start">
									<div class="text-input-type edit unit t1 mr-30">
										<input type="text" id="대수선비" class="right" name="대수선비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed-height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="flex-start">
									<div class="text-input-type edit unit t1 mr-30">
										<input type="text" id="사무_수탁비" class="right" name="사무_수탁비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed-height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="flex-start">
									<div class="text-input-type edit unit t1 mr-30">
										<input type="text" id="임대료" class="right" name="임대료" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed-height"><span class="auto_price mr-6"></span>원/MW</span>
								</div>
								<div class="group-type">
									<div class="dropdown placeholder edit" id="SMP">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
											선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="고정가"><a href="#">고정가</a></li>
											<li data-value="월_가중_평균"><a href="#">월 가중 평균</a></li>
											<li data-value="실시간"><a href="#">실시간</a></li>
										</ul>
									</div>
									<div class="text-input-type edit unit t1">
										<input type="text" id="SMP원" class="right" name="SMP원" placeholder="">
										<span>원</span>
									</div>
								</div>
								<div class="group-type">
									<div class="dropdown placeholder edit" id="REC">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
											고정가<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li data-value="고정가"><a href="#">고정가</a></li>
											<li data-value="SMP+REC"><a href="#">SMP + REC</a></li>
											<li data-value="월별_추후_산정"><a href="#">월별 추후 산정</a></li>
										</ul>
									</div>
									<div class="text-input-type edit unit t1">
										<input type="text" id="REC원" class="right" name="REC원" placeholder="">
										<span>원</span>
									</div>
								</div>
							</td>
							<th class="align-top">
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="fixed-height flex-wrap-center">
									<label for="임대료_지급일0">임대료 지급일</label>
									<a role="button" href="javascript:addRow('addList_rental_deduction', 'next');" class="btn-add fr">추가</a>
								</div>
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
							</th>
							<td class="align-top">
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="fixed-height"></div>
								<div class="sel-calendar group-type edit addList_rental_deduction entity">
									<input type="text" id="임대료_지급일[index]" class="sel datepicker" name="임대료_지급일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
									<button type="button" class="btn-close hidden" onclick="removeList(this)"></button>
								</div>
								<div class="fixed-height"></div>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="contractInfo">
			<div class="table-top panel-heading"><h2 class="ntit mt-25">시공 계약 정보</h2><a role="button" href="#contractInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a></div>
			<div id="contractInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
							<div class="text-input-type edit">
								<input type="text" id="공사_계약_정보_시공사" name="공사_계약_정보_시공사" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="공사_계약_정보_약정일">약정일</label></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="공사_계약_정보_약정일" class="sel datepicker" name="공사_계약_정보_약정일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="도급_계약서_공사_계약_금액">(도급 계약서) 공사 계약 금액</label></th>
						<td>
							<div class="text-input-type edit unit t1 mr-30">
								<input type="text" id="도급_계약서_공사_계약_금액" name="도급_계약서_공사_계약_금액" placeholder="직접 입력">
								<span>원</span>
							</div>
						</td>
						<th><label for="약정_금액">약정 금액</label></th>
						<td>
							<div class="text-input-type edit unit t1 mr-30">
								<input type="text" id="약정_금액" name="약정_금액" placeholder="직접 입력">
								<span>원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="도급_계약서_사용전_검사일">(도급 계약서) 사용전 검사일</label></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="도급_계약서_사용전_검사일" class="sel datepicker" name="도급_계약서_사용전_검사일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th><label for="실제_사용전_검사일자">(실제) 사용전 검사일자</label></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="실제_사용전_검사일자" class="sel datepicker" name="실제_사용전_검사일자" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="도급_계약서_준공일">(도급 계약서) 준공일</label></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="도급_계약서_준공일" class="sel datepicker" name="도급_계약서_준공일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th><label for="실제_준공일">(실제) 준공일</label></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="실제_준공일" class="sel datepicker" name="실제_준공일" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="인출_가능_기한">인출 가능 기한</label></th>
						<td class="flex-start">
							<div class="sel-calendar edit">
								<input type="text" id="인출_가능_기한" class="sel" name="인출_가능_기한" value="" autocomplete="off" placeholder="자동 입력" readonly>
							</div>
							<span class="fixed-height" id="인출_가능_남은일"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>
							<div class="fixed-height">지급 약정</div>
							<div class="fixed-height"><label for="계약서_명시_인출일_1차">계약서 명시 인출일</label><span class="fr fixed-height">1차</span></div>
							<div class="fixed-height"><span class="fr fixed-height">2차</span></div>
							<div class="fixed-height"><span class="fr fixed-height">3차</span></div>
							<div class="fixed-height"><label for="지급금액_1차">지급금액</label><span class="fr fixed-height">1차</span></div>
							<div class="fixed-height"><span class="fr fixed-height">2차</span></div>
							<div class="fixed-height"><span class="fr fixed-height">3차</span></div>
							<div class="fixed-height">미지급액</div>
						</th>
						<td>
							<div class="fixed-height"></div>
							<div class="flex-start">
								<div class="sel-calendar edit">
									<input type="text" id="계약서_명시_인출일_1차" class="sel datepicker" name="계약서_명시_인출일_1차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex-start">

								<div class="sel-calendar edit">
									<input type="text" id="계약서_명시_인출일_2차" class="sel datepicker" name="계약서_명시_인출일_2차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex-start">
								<div class="sel-calendar edit">
									<input type="text" id="계약서_명시_인출일_3차" class="sel datepicker" name="계약서_명시_인출일_3차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex-start">
								<div class="text-input-type edit">
									<input type="text" id="지급금액_1차" name="지급금액_1차" placeholder="직접 입력">
								</div>
							</div>
							<div class="flex-start">
								<div class="text-input-type edit">
									<input type="text" id="지급금액_2차" name="지급금액_2차" placeholder="직접 입력">
								</div>
							</div>
							<div class="flex-start">
								<div class="text-input-type edit">
									<input type="text" id="지급금액_3차" name="지급금액_3차" placeholder="직접 입력">
								</div>
							</div>
							<div class="fixed-height w-300px">
								<span class="text" id="미지급_금액">자동 계산</span>
								<span class="fr">원</span>
							</div>
						</td>
						<th class="align-top">
							<div class="fixed-height"></div>
							<div class="fixed-height">
								<label for="실_지급일_1차">실 지급일</label><span class="fr fixed-height">1차</span>
							</div>
							<div class="fixed-height"><span class="fr fixed-height">2차</span></div>
							<div class="fixed-height"><span class="fr fixed-height">3차</span></div>
						</th>
						<td class="align-top">
							<div class="fixed-height"></div>
							<div class="flex-start">
								<div class="sel-calendar edit">
									<input type="text" id="실_지급일_1차" class="sel datepicker" name="실_지급일_1차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex-start">
								<div class="sel-calendar edit">
									<input type="text" id="실_지급일_2차" class="sel datepicker" name="실_지급일_2차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
							<div class="flex-start">
								<div class="sel-calendar edit">
									<input type="text" id="실_지급일_3차" class="sel datepicker" name="실_지급일_3차" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="insuranceInfo">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">보험 정보<a role="button" href="javascript:addRow('insuranceInfoToggle');" class="btn-add ml-24">추가</a></h2>
				<a role="button" href="#insuranceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a>
			</div>
			<div id="insuranceInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
							<fieldset class="radio-type flex-start">
								<legend sr-only="보험 정보"></legend>
								<div class="radio-group">
									<input type="radio" id="보험구분_조립_보험[index]" name="보험구분[index]" value="조립보험">
									<label for="보험구분_조립_보험[index]">조립 보험</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="보험구분_CMI[index]" name="보험구분[index]" value="CMI">
									<label for="보험구분_CMI[index]">CMI</label>
								</div>
								<div class="radio-group">
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
							<div class="text-input-type edit">
								<input type="text" id="보험사[index]" name="보험사[index]" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="보험_중개사[index]">보험 중개사</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="보험_중개사[index]" name="보험_중개사[index]" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="보험_기간_from[index]">보험 기간</label></th>
						<td class="group-type">
							<legend class="sr-only">보험 기간</legend>
							<fieldset class="sel-calendar edit twin clear dateField">
								<input type="text" id="보험_기간_from[index]" class="sel fromDate" name="보험_기간_from[index]" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="보험_기간_to[index]" class="sel toDate" name="보험_기간_to[index]" value="" autocomplete="off" placeholder="종료일" readonly>
							</fieldset>
						</td>
						<th><label for="보험료[index]">보험료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="보험료[index]" name="보험료[index]" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="자가부담금[index]">자가부담금</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="자가부담금[index]" name="자가부담금[index]" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="보험가액[index]">보험가액</label></th>
						<td>
							<div class="text-input-type edit">
								<input type="text" id="보험가액[index]" name="보험가액[index]" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr class="dateField">
						<th><label for="보험_시작일[index]">시작일</label></th>
						<td>
							<div class="sel-calendar edit">
								<input type="text" id="보험_시작일[index]" class="sel fromDate" name="보험_시작일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
						</td>
						<th><label for="보험_종료일[index]">종료일</label></th>
						<td class="flex-start">
							<div class="sel-calendar edit mr-24">
								<input type="text" id="보험_종료일[index]" class="sel toDate" name="보험_종료일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								<input type="hidden" id="보험_종료일_차이[index]" name="보험_종료일_차이[index]" value="">
							</div>
							<span class="fixed-height"></span>
						</td>
					</tr>
					<tr>
						<th><label for="이행보증보험료[index]">이행보증보험료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="이행보증보험료[index]" name="이행보증보험료[index]" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<th><label for="보험_만기일[index]">만기일</label></th>
						<td class="flex-start">
							<div class="sel-calendar edit mr-24">
								<input type="text" id="보험_만기일[index]" class="sel toDate" name="보험_만기일[index]" value="" autocomplete="off" placeholder="날짜 선택" readonly>
								<input type="hidden" id="보험_만기일_차이[index]" name="보험_만기일_차이[index]" value="">
							</div>
							<span class="fixed-height"></span>
						</td>
					</tr>
					<tr>
						<th><label for="보험료_총계[index]">보험료 총계</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="보험료_총계[index]" name="보험료_총계[index]" placeholder="자동 완성" readonly>
								<span>원/월</span>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="deviceInfo">
			<div class="table-top panel-heading"><h2 class="ntit mt-25">설비 정보</h2><a role="button" href="#deviceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a></div>
			<div id="deviceInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>모듈 제조사 / 모델<a href="javascript:addRow('addList_module_info');" class="btn-add fr">추가</a></th>
						<td id="addList_module_info" class="entity">
							<div class="group-type">
								<div class="text-input-type edit">
									<label class="sr-only">모듈 제조사</label>
									<input type="text" id="모듈_제조사[index]" name="모듈_제조사[index]" placeholder="제조사">
								</div>
								<div class="text-input-type edit">
									<label class="sr-only">모듈 제조사 모델</label>
									<input type="text" id="모듈_제조사_모델[index]" name="모듈_제조사_모델[index]" placeholder="모델">
								</div>
								<button type="button" class="btn-close fixed-height hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>설치 용량</th>
						<td class="group-type">
							<div class="text-input-type edit unit t1">
								<label class="sr-only">설치 용량 (KW)</label>
								<input type="text" id="설치_용량_KW"><span>kW</span>
							</div>
							<div class="text-input-type edit unit t1">
								<label class="sr-only">설치 용량(매)</label>
								<input type="text" id="설치_용량(매)"><span>매</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>
							<label for="모듈_설치_각도">모듈 설치 각도</label>
							<a href="javascript:addRow('addList_module_angle');" class="btn-add fr">추가</a>
						</th>
						<td id="addList_module_angle" class="entity">
							<div class="text-input-type edit unit t1 fl">
								<input type="text" id="모듈_설치_각도[index]" name="모듈_설치_각도[index]">&ensp;&deg;
								<button type="button" class="btn-close hidden" onclick="$(this).parent().remove()"></button>
							</div>
						</td>
						<th>모듈 설치 방식</th>
						<td>
							<fieldset class="chk-type align-type">
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
						<th>인버터 제조사 / 모델<a href="javascript:addRow('addList_inverter');" class="btn-add fr">추가</a></th>
						<td id="addList_inverter" class="entity">
							<div class="flex-start">
								<fieldset class="group-type">
									<legend sr-only="인버터 제조사/모델"></legend>
									<div class="text-input-type edit">
										<input type="text" id="인버터_제조사[index]" name="인버터_제조사[index]" placeholder="제조사">
									</div>
									<div class="text-input-type edit">
										<input type="text" id="인버터_제조사_모델[index]" name="인버터_제조사_모델[index]" placeholder="모델">
									</div>
								</fieldset>
								<button type="button" class="btn-close hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>인버터 용량 / 대수<a href="javascript:addRow('addList_inverter_vol');" class="btn-add fr">추가</a></th>
						<td id="addList_inverter_vol" class="entity">
							<fieldset class="group-type">
								<legend sr-only="인버터 용량 / 대수"></legend>
								<div class="text-input-type edit unit t1">
									<input type="text" id="인버터_용량[index]" name="인버터_용량[index]"><span>kW</span>
								</div>
								<div class="text-input-type edit unit t1">
									<input type="text" id="인버터_용량_대수[index]" name="인버터_용량_대수[index]"><span>대</span>
									<!-- <button type="button" class="btn-close fixed-height hidden" onclick="$(this).parents('.group-type').remove();">삭제</button> -->
								</div>
								<button type="button" class="btn-close fixed-height hidden" onclick="$(this).parents('.group-type').remove();">삭제</button>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="접속반_제조사0">접속반 제조사 / 모델</label><a href="javascript:addRow('addList_manufacturer');" class="btn-add fr">추가</a></th>
						<td id="addList_manufacturer" class="entity">
							<div class="flex-start group-type">
								<div class="text-input-type edit">
									<input type="text" placeholder="제조사" id="접속반_제조사[index]" name="접속반_제조사[index]">
								</div>
								<div class="text-input-type edit">
									<input type="text" placeholder="모델" id="접속반_제조사_모델[index]" name="접속반_제조사_모델[index]">
								</div>
								<button type="button" class="btn-close fixed-height hidden mt-0" onclick="removeList(this);"></button>
							</div>
						</td>
						<th>접속반 채널 / 대수<a href="javascript:addRow('addList_connection');" class="btn-add fr">추가</a></th>
						<td id="addList_connection" class="entity">
							<div class="group-type">
								<div class="text-input-type edit unit t1">
									<input type="text" id="접속반_채널[index]" name="접속반_채널[index]"><span>Ch</span>
								</div>
								<div class="text-input-type edit unit t1">
									<input type="text" id="접속반_채널_대수[index]" name="접속반_채널_대수[index]"><span>대</span>
								</div>
								<button type="button" class="btn-close fixed-height hidden" onclick="removeList(this);"></button>
							</div>
						</td>
					</tr>
					<tr>
						<th>접속반 용량 / 통신방식</th>
						<td class="group-type">
							<div class="text-input-type edit unit t1">
								<input type="text" id="접속반_용량" name="접속반_용량">
								<span>kW</span>
							</div>
							<fieldset class="radio-type flex-start2">
								<legend sr-only="통신 방식"></legend>

								<div class="radio-group">
									<input type="radio" id="통신방식_통신" name="통신방식" value="통신">
									<label for="통신방식_통신">통신</label>
								</div>

								<div class="radio-group">
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
							<div class="chk-type align-type">
								<fieldset class="flex-start3">
									<legend sr-only="설치 타입"></legend>
									<input type="checkbox" id="설치_타입_그라운드" name="설치_타입" value="그라운드">
									<label class="custom-checkbox" for="설치_타입_그라운드">그라운드</label>
									<input type="checkbox" id="설치_타입_루프탑" name="설치_타입" value="루프탑">
									<label class="custom-checkbox" for="설치_타입_루프탑">루프탑</label>
									<input type="checkbox" id="설치_타입_수상" name="설치_타입" value="수상">
									<label class="custom-checkbox" for="설치_타입_수상">수상</label>
								</fieldset>
							</div>
						</td>
						<th>수배전반 제조사 / 모델<a href="javascript:addRow('addList_switch_gear');" class="btn-add fr">추가</a></th>
						<td id="addList_switch_gear" class="entity">
							<div class="group-type">
								<div class="text-input-type edit">
									<input type="text" id="수배전반_제조사[index]" name="수배전반_제조사[index]" placeholder="제조사">
								</div>
								<div class="text-input-type edit">
									<input type="text" id="수배전반_모델[index]" name="수배전반_모델[index]" placeholder="모델">
								</div>
								<button type="button" class="btn-close fixed-height hidden" onclick="removeList(this);"></button>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="warrantyInfo">
			<div class="table-top panel-heading"><h2 class="ntit mt-25">보증 정보</h2><a role="button" href="#warrantyInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a></div>
			<div id="warrantyInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
							<fieldset class="radio-type flex-start3">
								<legend sr-only="보증 방식"></legend>
								<div class="radio-group">
									<input type="radio" id="보증_방식_PR" name="보증_방식" value="PR">
									<label for="보증_방식_PR">PR</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="보증_방식_발전_시간" name="보증_방식" value="발전 시간">
									<label for="보증_방식_발전_시간">발전 시간</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="보증_방식_PR_+_발전_시간" name="보증_방식" value="PR + 발전시간">
									<label for="보증_방식_PR_+_발전_시간">PR + 발전 시간</label>
								</div>
							</fieldset>
						</td>
						<th>PR 보증치</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="PR_보증치" name="PR_보증치"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="발전시간_보증치" name="발전시간_보증치"><span>h</span></div>
						</td>
						<th>보증 감소율</th>
						<td>
							<div class="text-input-type edit unit t2"><input type="text" id="보증_감소율" name="보증_감소율"><span>년차별 %</span></div>
						</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td class="group-type">
							<div class="dropdown placeholder edit" id="기준_단가">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown">기준 단가 선택<span class="caret"></span></button>
								<ul class="dropdown-menu" role="menu">
									<li data-value=""><a href="#">기준 단가 선택</a></li>
									<li data-value="FIT 단가"><a href="#">FIT 단가</a></li>
									<li data-value="시장정산실적"><a href="#">시장정산실적</a></li>
								</ul>
							</div>
							<div class="text-input-type edit unit t2">
								<input type="text" id="기준_단가_원" name="기준_단가_원"><span>원 / kW</span></div>
						</td>
						<th>현재 적용 연차</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="현재_적용_연차" name="현재_적용_연차"><span>년차</span></div>
						</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="년간_관리_운영비" name="년간_관리_운영비"><span>만원</span></div>
						</td>
						<th>물가 반영 비율</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="물가_반영_비율" name="물가_반영_비율"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td>
							<fieldset class="radio-type flex-start">
								<legend sr-only="추가 보수"></legend>
								<div class="radio-group">
									<input type="radio" id="추가_보수_유" name="추가_보수" value="유">
									<label for="추가_보수_유">유</label>
								</div>
								<div class="radio-group">
									<input type="radio" id="추가_보수_무" name="추가_보수" value="무">
									<label for="추가_보수_무">무</label>
								</div>
							</fieldset>
						</td>
						<th>추가 보수 용량</th>
						<td>
							<div class="text-input-type edit unit t2"><input type="text" id="추가_보수_용량" name="추가_보수_용량"><span>kW 이상</span></div>
						</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="추가_보수_백분율" name="추가_보수_백분율"><span>%</span></div>
						</td>
						<th>전력요금 종별</th>
						<td class="group-type">
							<div class="text-input-type edit">
								<input type="text" id="전력요금_종별_요금제" placeholder="요금제">
							</div>
							<div class="text-input-type edit unit t2"><input type="text" id="전력요금_종별_계약전력" name="전력요금_종별_계약전력" placeholder="계약 전력"><span>kW</span></div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="spendInfo">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">지출 정보</h2>
				<a role="button" href="#spendInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse-arrow"></a>
			</div>
			<div id="spendInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:7%">
						<col style="width:8%">
						<col style="width:35%">
						<col style="width:50%">
					</colgroup>
					<tr>
						<th rowspan="3">세금과 공과</th>
						<th class="pl-28"><label for="지방세">지방세</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="지방세" name="지방세" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th><label for="종합부동산세">종합부동산세</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="종합부동산세" name="종합부동산세" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th><label for="세금과공과_기타">기타</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="세금과공과_기타" name="세금과공과_기타" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="기장료">기장료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="기장료" name="기장료" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="등기용역수수료">등기용역수수료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="등기용역수수료" name="등기용역수수료" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="회계감사수수료">회계감사수수료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="회계감사수수료" name="회계감사수수료" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th rowspan="4">지급수수료</th>
						<th class="pl-28"><label for="REC수수료">REC수수료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="REC수수료" name="REC수수료" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th><label for="재위탁수수료">재위탁수수료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="재위탁수수료" name="재위탁수수료" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th><label for="정기검사">정기검사</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="정기검사" name="정기검사" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th><label for="지급수수료_기타">기타</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="지급수수료_기타" name="지급수수료_기타" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="경비용역료">경비용역료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="경비용역료" name="경비용역료" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="전력비">전력비</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="전력비" name="전력비" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="통신비">통신비</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="통신비" name="통신비" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="전기안전관리대행수수료">전기안전관리대행수수료</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="전기안전관리대행수수료" name="전기안전관리대행수수료" placeholder="직접 입력">
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
					<tr>
						<th colspan="2"><label for="지출_총계">지출 총계</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="지출_총계" name="지출_총계" placeholder="자동 입력" readonly>
								<span>원/월</span>
							</div>
						</td>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>


		<div class="indiv panel panel-default" id="coefficientInfo">
			<div class="table-top panel-heading"><h2 class="ntit mt-25">환경 변수</h2><a href="#coefficientInfoToggle" data-toggle="collapse" class="collapse-arrow"></a></div>
			<div id="coefficientInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
							<div class="text-input-type edit unit t1"><input type="text" id="annual" name="annual"><span>%</span></div>
						</td>
						<th>PV modul modeling/params</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="pv_modul" name="pv_modul"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="inverter" name="inverter"><span>%</span></div>
						</td>
						<th>Soiling, mismatch</th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="soiling" name="soiling"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th><label for="degradationEstimation">Degradation estimation</label></th>
						<td>
							<div class="text-input-type edit unit t1"><input type="text" id="degradationEstimation" name="degradation_estimation"><span>%</span></div>
						</td>
						<th><label for="degradationEstimation">Resulting ann, Variability(sigma)</label></th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="resulting_ann" name="resulting_ann"><span>%</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>System Degradation</th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="system_degradation" name="system_degradation"><span>%</span>
							</div>
						</td>
						<th>System Availability</th>
						<td>
							<div class="text-input-type edit unit t1">
								<input type="text" id="system_availability" name="system_availability"><span>%</span>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv panel panel-default" id="associatedInfo">
			<div class="table-top panel-heading"><h2 class="ntit mt-25">관련 정보</h2><a href="#associatedInfoToggle" data-toggle="collapse" class="collapse-arrow"></a></div>
			<div id="associatedInfoToggle" class="spc-table-row st-edit panel-collapse collapse in" role="tabpanel">
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
							<div class="text-input-type edit"><input type="text" id="전기안전_관리_회사명" name="전기안전_관리_회사명" placeholder="직접 입력"></div>
						</td>
						<th><label for="회사_연락처"></label>회사 연락처</th>
						<td>
							<div class="text-input-type edit"><input type="text" id="회사_연락처" name="회사_연락처" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="전기안전_관리_대표자명">전기안전 관리 대표자명</label></th>
						<td>
							<div class="text-input-type edit"><input type="text" id="전기안전_관리_대표자명" name="전기안전_관리_대표자명" placeholder="직접 입력"></div>
						</td>
						<th>대표자 연락처</th>
						<td>
							<div class="text-input-type edit"><input type="text" id="대표자_연락처" name="대표자 연락처" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="전기안전_관리_담당자명">전기안전 관리 담당자명</label></th>
						<td>
							<div class="text-input-type edit"><input type="text" id="전기안전_관리_담당자명" name="전기안전_관리_담당자명" placeholder="직접 입력"></div>
						</td>
						<th><label for="담당자_연락처">담당자 연락처</label></th>
						<td>
							<div class="text-input-type edit"><input type="text" id="담당자_연락처" name="담당자_연락처" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="현장_잠금장치_비밀번호">현장 잠금장치 비밀번호</label></th>
						<td>
							<div class="text-input-type edit"><input type="text" id="현장_잠금장치_비밀번호" name="현장_잠금장치_비밀번호" placeholder="직접 입력"></div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn-wrap-type02">
				<button type="button" class="btn-type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn-type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>
		<!-- TO 개발자님 : 아래 파일 선택은 multi-select 로 파일 업로드 -->
		<div class="indiv panel panel-default attachment">
			<div class="table-top panel-heading">
				<h2 class="ntit mt-25">첨부 파일</h2>
				<a href="#attachementInfoToggle" data-toggle="collapse" class="collapse-arrow"></a>
			</div>
			<form id="attachement_info" name="attachement_info" class="mt-25">
				<div id="attachementInfoToggle" class="spc-table-row st-edit panel-collapse collapse in">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:55%">
							<col style="width:30%">
							<col>
						</colgroup>
						<tr>
							<th>현장 사진</th>
							<td class="flex-start-td">
								<div id="fileList01">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList01', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_01" class="hidden" name="spc_file_01" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_01" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList02">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList02', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_02" class="hidden" name="spc_file_02" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_02" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList03">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList03', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_03" class="hidden" name="spc_file_03" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_03" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList04">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList04', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_04" class="hidden" name="spc_file_04" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_04" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList05">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList05', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_05" class="hidden" name="spc_file_05" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_05" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList06">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList06', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_06" class="hidden" name="spc_file_06" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_06" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList07">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList07', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_07" class="hidden" name="spc_file_07" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_07" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList08">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList08', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_08" class="hidden" name="spc_file_08" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_08" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList09">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList09', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_09" class="hidden" name="spc_file_09" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_09" class="btn file-upload">파일 선택</label>
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
							<td class="flex-start-td">
								<div id="fileList10">
									<p class="text-file">
										<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="icon-trash" onclick="setRemoveFileList('fileList10', [INDEX]);"></button>
									</p>
								</div>

								<input type="file" id="spc_file_10" class="hidden" name="spc_file_10" accept=".gif, .jpg, .png" multiple="">
								<label for="spc_file_10" class="btn file-upload">파일 선택</label>
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

		<div class="btn-wrap-type-r"><!--
		--><a href="/spc/entityInformation.do" class="btn btn-type03">목록</a><!--
		--><button type="submit" class="btn-type big" onclick="setSaveData();">수정</button><!--
	--></div>
	</div>
</div>