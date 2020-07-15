<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script src="/js/commonDropdown.js"></script>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	const countryList = [{'value': '대한민국'}];
	const sidoList = [
		{'value': '서울'}, {'value': '부산'}, {'value': '대구'}, {'value': '인천'}, {'value': '광주'},
		{'value': '울산'}, {'value': '세종'}, {'value': '경기'}, {'value': '강원'}, {'value': '충북'}, {'value': '충남'},
		{'value': '전북'}, {'value': '전남'}, {'value': '경북'}, {'value': '경남'}, {'value': '제주'}
	];

	$(function () {
		initProcess();
		$("#unitPriceList").on("click", "li", unitPriceListChange);

		setInitList('SPC_법인_인감');

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
	});

	$(document).on('click', '.dropdown li', function () {
		var dataValue = $(this).data('value'),
			dataText = $(this).text();
		$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);
	});

	function initProcess(){
		getSpcAndGenData(); //저장되어있는 spc정보조회
		setComboBoxData();
	}

	function setComboBoxData() {
		setInitList("countryList");
		setMakeList(countryList, "countryList", {"dataFunction": {}});

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

	function removeList(obj){
		if( $(obj).parent().parent().find('.group_type').length > 1){
			$(obj).parent().remove();
		};
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

	function getSpcAndGenData(){
		var spcId = '${param.spc_id}',
			genId = '${param.gen_id}';

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/spcs/'+ spcId,
			type: 'get',
			async: true,
			data: {'oid': oid},
			success: function (json) {
				if(json.data.length > 0){
					setJsonAutoMapping(json.data[0], 'basicInfo');
					const spc_info = JSON.parse(json.data[0].spc_info);
					if (!isEmpty(spc_info)) {
						setJsonAutoMapping(spc_info, 'basicInfo');
						const fileList = spc_info['SPC_법인_인감'];

						if(fileList.length > 0) {
							setMakeList(fileList, 'SPC_법인_인감', {'dataFunction': {}});
						} else {
							setMakeList(new Array(), 'SPC_법인_인감', {'dataFunction': {}});
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
			url: 'http://iderms.enertalk.com:8443/config/sites/'+ genId,
			type: 'get',
			async: true,
			data: {},
			success: function (json) {
				$('#genName').text(json.name);

				$('#country').html('대한민국 <span class="caret"></span>' )
				$('#countryValue').text('대한민국');

				$('#sidoValue').text(json.location);
				$('#sido').html(json.location +  '<span class="caret"></span>');

				$('#address').text(json.address)
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/spcs/'+ spcId + '/gens/' + genId,
			type: 'get',
			async: true,
			data: {'oid': oid},
			success: function (json) {
				if (json.data.length > 0) {
					//기본정보
					const maintenance_info = JSON.parse(json.data[0].maintenance_info);
					const account_info = JSON.parse(json.data[0].account_info);
					const finance_info = JSON.parse(json.data[0].finance_info);
					const contract_info = JSON.parse(json.data[0].contract_info);
					const addlist_insurance_info = JSON.parse(json.data[0].addlist_insurance_info);
					const device_info = JSON.parse(json.data[0].device_info);
					const warranty_info = JSON.parse(json.data[0].warranty_info);
					const coefficient_info = JSON.parse(json.data[0].coefficient_info);
					const associated_info = JSON.parse(json.data[0].associated_info);

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
						if (maintenance_info['관리_계약_구분'] != undefined && maintenance_info['관리_계약_구분'].length > 0) {
							if (typeof maintenance_info['관리_계약_구분'] === 'string') {
								$('#maintenanceInfo #관리_계약_구분').html(maintenance_info['관리_계약_구분']);
							} else {
								$('#maintenanceInfo #관리_계약_구분').html(maintenance_info['관리_계약_구분'].join(','));
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
					setJsonAutoMapping(finance_info, 'financeInfo');

					setJsonAutoMapping(contract_info, 'contractInfo'); //반복없음

					const insuranceRepeatItem = [
						{name: '보험구분', id: 'insuranceInfoToggle', next: ''}
					];
					setMakeTag(insuranceRepeatItem, addlist_insurance_info, 'insuranceInfo'); //금융태그 생성
					setJsonAutoMapping(addlist_insurance_info, 'insuranceInfo'); //보험정보 전체 반복

					const deviceRepeatItem = [
						{name: '모듈_제조사/모델', id: 'addList_module_info', next: ''},
						{name: '모듈_설치_각도', id: 'addList_module_angle', next: ''},
						{name: '인버터_제조사/모델', id: 'addList_inverter', next: ''},
						{name: '접속반_제조사/모델', id: 'addList_manufacturer', next: 'next'},
						{name: '인버터_용량/대수', id: 'addList_inverter_vol', next: 'next'},
						{name: '접속반_채널/대수', id: 'addList_connection', next: 'next'},
						{name: '접속반_채널/대수', id: 'addList_switch_gear', next: 'next'},
					];
					setMakeTag(deviceRepeatItem, device_info);
					setJsonAutoMapping(device_info, 'deviceInfo'); //설비정보

					setJsonAutoMapping(warranty_info, 'warrantyInfo'); //보증정보
					setJsonAutoMapping(coefficient_info, 'coefficientInfo'); //환경변수
					setJsonAutoMapping(associated_info, 'associatedInfo'); //관련정보

					getAttachFileDisplay(JSON.parse(json.data[0].attachement_info)); //첨부파일

					addDatePicker();

					$('[id^=보험_시작일]').each(function() {
						afterDatePick($(this).attr('name'));
					});

					sumUnpaid();
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
	}

	function setSaveData(){
		sendSpcPatchPost();
	}

	function sendSpcPatchPost(){
		var spcId = '${param.spc_id}',
			spc_info = setAreaParamData('basicInfo');

		$('#basicForm').find('input[type="file"]').each(function () {
			$(this).attr('name', this.name + '_' + genUuid());
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid=' + oid,
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

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/spcs/'+ spcId + '?oid='+oid,
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
		var spcId = '${param.spc_id}',
			genId = '${param.gen_id}';

		$('#attachement_info').find('input[type=file]').each(function(){
			$(this).attr('name', this.name + '_' + spcId +'_' + genId);
		});

		$.ajax({
			type: 'patch',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
			data: new FormData($('#attachement_info')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			success: function (result) {
				var existFileList =
					$('#fileList01').data('gridJsonData')
					.concat($('#fileList02').data('gridJsonData'))
					.concat($('#fileList03').data('gridJsonData'))
					.concat($('#fileList04').data('gridJsonData'))
					.concat($('#fileList05').data('gridJsonData'))
					.concat($('#fileList06').data('gridJsonData'))
					.concat($('#fileList07').data('gridJsonData'))
					.concat($('#fileList08').data('gridJsonData'))
					.concat($('#fileList09').data('gridJsonData'))
					.concat($('#fileList10').data('gridJsonData'));

				sendSpcGenPatchPost(existFileList.concat(result.files));
			},
			error: function (request, status, error) {
				alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
			}
		});
	}

	function sendSpcGenPatchPost(files){
		var spcId = '${param.spc_id}',
			genId = '${param.gen_id}';

		var maintenance_info = setAreaParamData('maintenanceInfo'),
			account_info = setAreaParamData('accountInfo'),
			finance_info = setAreaParamData('financeInfo', 'dropdown'),
			contract_info = setAreaParamData('contractInfo'),
			addlist_insurance_info = setAreaParamData('insuranceInfo'),
			device_info = setAreaParamData('deviceInfo'),
			warranty_info = setAreaParamData('warrantyInfo', 'dropdown'),
			coefficient_info = setAreaParamData('coefficientInfo'),
			associated_info = setAreaParamData('associatedInfo'),
			attachement_info = files;

		$('#financeInfo').find('input[type="file"]').each(function () {
			$(this).attr('name', this.name + '_' + genUuid());
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid=' + oid,
			data: new FormData($('#financeForm')[0]),
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
						if (fieldname == $(this).attr('name')) {
							let button = $(this).parents('div.group_type').find('.dropdown').find('button').data('value');
							el['용도 선택'] = button;
						}
					});

				});

				finance_info['SPC_법인_인감'] = resultFiles;
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});

		$.ajax({
			url: 'http://iderms.enertalk.com:8443/spcs/' + spcId +'/gens/' + genId + '?oid=' + oid,
			type: 'patch',
			async: true,
			contentType: 'application/json',
			data: JSON.stringify({
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
			dateFormat: 'yy-mm-dd'
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

	function goNowPage(spcId, genId){
		location.href = '/spc/entityDetails.do?spc_id=' + spcId + '&gen_id=' + genId + '&oid=' + oid;
	}

	function goMoveList(){
		location.href = '/spc/entityInformation.do';
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
		<h1 class="page-header">SPC 수정</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
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
								<div class="tx_inp_type edit disabled">
									<label for="name" class="sr-only">SPC명 입력</label>
									<input type="text" id="name" name="name" placeholder="SPC명 입력" readonly>
									<input type="hidden" id="spcId" name="spcId" readonly>
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
							<th><label for="genName">발전소명</label></th>
							<td class="group_type">
								<div class="tx_inp_type edit disabled">
									<input type="text" id="genName" name="genName" placeholder="발전소명 입력" readonly>
									<input type="hidden" id="genId" name="genId">
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
								<div class="dropdown placeholder edit">
									<button id="country" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
										국가 선택<span class="caret"></span>
									</button>
									<ul id="countryList" class="dropdown-menu" role="menu">
										<li data-value="대한민국">
											<a href="javascript:void(0);">대한민국</a>
										</li>
										<li data-value="일본">
											<a href="javascript:void(0);">일본</a>
										</li>
									</ul>
								</div>
								<div class="dropdown placeholder edit mr-12">
									<button id="sido" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
										시/도 선택<span class="caret"></span>
									</button>
									<ul id="sidoList" class="dropdown-menu" role="menu">
										<li data-value="[value]">
											<a href="javascript:void(0);">[value]</a>
										</li>
									</ul>
								</div>
							</td>
							<th><label for="address">상세 주소</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="hidden" id="countryValue" value="">
									<input type="hidden" id="sidoValue" value="">
									<input type="text" id="address" name="minor_address" placeholder="상세 주소">
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
							<th><label for="사무위탁사">사무위탁사</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="사무위탁사" name="사무위탁사" placeholder="직접 입력">
								</div>
							</td>
							<th><label for="사무위탁사_담당자(연락처)">담당자(연락처)</label></th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" id="사무위탁사_담당자(연락처)" name="사무위탁사_담당자(연락처)" placeholder="직접 입력">
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
								<div id="SPC_법인_인감" class="hide-no-data">
									<p class="tx_file"><!--
									--><a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[SPC_법인_인감_유형] - [originalname]</a><!--
									--><button type="button" class="btn_type07" onclick="setRemoveFileList('fileList01', [INDEX]);"></button><!--
								--></p>
								</div>
								<div class="group_type">
									<div class="dropdown placeholder edit" id="spcSeal[index]">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">인감 선택<span class="caret"></span></button>
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
										<button class="btn_close hidden fixed_height mt-0" onclick="$(this).parents().closest('.group_type').remove()"></button>
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
			<div class="btn_wrap_type02"><!--
			--><button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
			--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button><!--
			--></div>
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
									<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
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
								<input type="text" id="상업 운전 개시일_from" name="상업 운전 개시일_from" class="sel fromDate" value="" autocomplete="off" placeholder="시작일" readonly>
								<input type="text" id="상업 운전 개시일_to" name="상업 운전 개시일_to" class="sel toDate" value="" autocomplete="off" placeholder="종료일" readonly>
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
						<th>통산담보표지판 설정 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="통신담보표지판 설정 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="통신담보표지판_설정" name="통신담보표지판_설정_여부" value="통신담보표지판_설정">
									<label for="통신담보표지판_설정">설정함</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="통신담보표지판_미설정" name="통신담보표지판_설정_여부" value="통신담보표지판_미설정">
									<label for="통신담보표지판_미설정">해당 없음</label>
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
								<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
							<th></th>
							<td></td>
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
									<div class="dropdown placeholder edit" id="입출금_구분[index]"><!--
										--><button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">입출금 구분<span class="caret"></span></button><!--
										--><ul class="dropdown-menu" role="menu"><!--
											--><li data-value="입금"><a href="javascript:void(0);">입금</a></li><!--
											--><li data-value="출금"><a href="javascript:void(0);">출금</a></li><!--
										--></ul><!--
									--></div>
									<div class="dropdown placeholder edit" id="계좌구분[index]"><!--
									--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">계좌구분<span class="caret"></span></button><!--
									--><ul class="dropdown-menu" role="menu"><!--
										--><li data-value="유보계좌"><a href="javascript:void(0);">유보계좌</a></li><!--
										--><li data-value="부채상환"><a href="javascript:void(0);">부채상환</a></li><!--
										--><li data-value="대수선비"><a href="javascript:void(0);">대수선비</a></li><!--
										--><li data-value="배당금 적립"><a href="javascript:void(0);">배당금 적립</a></li><!--
										--><li data-value="지출"><a href="javascript:void(0);">지출</a></li><!--
										--><li data-value="기타"><a href="javascript:void(0);">기타</a></li><!--
									--></ul><!--
								--></div>
									<div class="dropdown placeholder edit" id="은행_리스트[index]"><!--
										--><button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">은행 리스트<span class="caret"></span></button><!--
										--><ul class="dropdown-menu" role="menu"><!--
											--><li data-value="신한"><a href="javascript:void(0);">신한</a></li><!--
											--><li data-value="기업"><a href="javascript:void(0);">기업</a></li><!--
										--></ul><!--
									--></div>
								</div>
								<div class="fixed_height">
									<div class="tx_inp_type edit"><input type="text" id="예금주[index]" name="예금주[index]" placeholder="직접 입력"></div>
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
								<button class="btn_close hidden mr-12 fr" onclick="$(this).parents().closest('tr').remove()"></button>
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
									<div class="dropdown placeholder edit" id="용도 선택[index]">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
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
									<div class="fixed_height">
										<input type="file" id="공인인증서_등록_이미지[index]" class="hidden" name="공인인증서_등록_이미지[index]" accept=".der, .cer, .crt, .pfx">
										<label for="공인인증서_등록_이미지[index]" class="btn file_upload">파일 선택</label>
										<span class="upload_text ml-16">등록 파일 이름</span>
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
									<span class="fixed_height"><span class="auto_price"></span>원/MW</span>
								</div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="대수선비" class="right" name="대수선비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed_height"><span class="auto_price"></span>원/MW</span>
								</div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="사무_수탁비" class="right" name="사무_수탁비" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed_height"><span class="auto_price"></span>원/MW</span>
								</div>
								<div class="flex_start">
									<div class="tx_inp_type edit unit t1 mr-30">
										<input type="text" id="임대료" class="right" name="임대료" placeholder="">
										<span>원</span>
									</div>
									<span class="fixed_height"><span class="auto_price"></span>원/MW</span>
								</div>
								<div class="group_type">
									<div class="dropdown placeholder edit" id="SMP">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
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
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
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
									<button class="btn_close hidden" onclick="removeList(this)"></button>
								</div>
								<div class="fixed_height"></div>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
								<input type="text" id="도급_계약서_공사_계약_금액" name="도급_계약서_공사_계약_금액" placeholder="직접 입력">
								<span>원</span>
							</div>
						</td>
						<th><label for="약정_금액">약정 금액</label></th>
						<td>
							<div class="tx_inp_type edit unit t1 mr-30">
								<input type="text" id="약정_금액" name="약정_금액" placeholder="직접 입력">
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
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="인출_가능_기한" class="sel datepicker" name="인출_가능_기한" value="" autocomplete="off" placeholder="날짜 선택" readonly>
							</div>
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
									<input type="text" id="지급금액_1차" name="지급금액_1차" placeholder="직접 입력">
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" id="지급금액_2차" name="지급금액_2차" placeholder="직접 입력">
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" id="지급금액_3차" name="지급금액_3차" placeholder="직접 입력">
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
							<span class="fixed_height">XX일 남음</span>
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
							<span class="fixed_height">XX일 남음</span>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
									<input type="text" id="모듈_제조사[index]" name="모듈_제조사" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<label class="sr-only">모듈 제조사 모델</label>
									<input type="text" name="모듈_제조사_모델[index]" placeholder="모델">
								</div>
								<button type="button" class="btn_close fixed_height hidden" onclick="removeList(this);">삭제</button>
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
								<button type="button" class="btn_close hidden" onclick="$(this).parent().remove()"></button>
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
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
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
									<!-- <button type="button" class="btn_close fixed_height hidden" onclick="$(this).parents('.group_type').remove();">삭제</button> -->
								</div>
								<button type="button" class="btn_close fixed_height hidden" onclick="$(this).parents('.group_type').remove();">삭제</button>
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
								<button type="button" class="btn_close fixed_height hidden mt-0" onclick="removeList(this);"></button>
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
								<button type="button" class="btn_close fixed_height hidden" onclick="removeList(this);"></button>
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
									<input type="text" id="수배전반_제조사" name="수배전반_제조사" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" id="수배전반_모델" name="수배전반_모델" placeholder="모델">
								</div>
								<button type="button" class="btn_close fixed_height hidden" onclick="removeList(this);"></button>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">기준 단가 선택<span class="caret"></span></button>
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
				<button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
								<div id="fileList01">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList01', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList02">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList02', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList03">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList03', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList04">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList04', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList05">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList05', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList06">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList06', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList07">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList07', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList08">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList08', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList09">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList09', [INDEX]);"></button>
									</p>
								</div>

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
								<div id="fileList10">
									<p class="tx_file">
										<a href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
										<button type="button" class="btn_type07" onclick="setRemoveFileList('fileList10', [INDEX]);"></button>
									</p>
								</div>

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

		<div class="btn_wrap_type_right"><!--
		--><a href="/spc/entityInformation.do" class="btn btn_type03">목록</a><!--
		--><button type="submit" class="btn_type big" onclick="setSaveData();">수정</button><!--
	--></div>
	</div>
</div>