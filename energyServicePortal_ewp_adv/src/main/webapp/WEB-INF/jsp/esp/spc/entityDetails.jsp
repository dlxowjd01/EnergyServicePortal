<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript">
	const spcId = "${param.spc_id}";
	const genId = "${param.gen_id}";

	$(function () {
		init();
		getDataSpcBasic();
		getDataSpcGen();
	});

	function init() {

		$.ajax({
			url: apiHost + '/config/user_spcs?oid=' + oid,
			type: 'get',
			async: false,
			data: {user_ids: userInfoId}
		}).done(function (data, textStatus, jqXHR) {
			const result = data.data;
			let acceptList = new Array();

			result.forEach(spc => {
				if (spc.role == '1') {
					acceptList.push(spc.spcid);
				}
			});

			if (acceptList.length > 0) {
				if (!acceptList.includes(Number(spcId))) {
					$('#modifyButton').remove();
				}
			} else {
				$('#modifyButton').remove();
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});


		setInitList('SPC_법인_인감');
		setInitList('공인인증서');

		//등기이사 소속 반복처리
		initRow('addList_affiliation', 'class');
		addRow('addList_affiliation', 'class');

		//등기이사 소속 반복처리
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

		setInitList("addFileList01");
		setInitList("addFileList02");
		setInitList("addFileList03");
		setInitList("addFileList04");
		setInitList("addFileList05");
		setInitList("addFileList06");
		setInitList("addFileList07");
		setInitList("addFileList08");
		setInitList("addFileList09");
		setInitList("addFileList10");
	}

	function getAttachFileDisplay(attachement_info) {
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}",
			oid = "${param.oid}";

		var addFileList01 = [], addFileList02 = [], addFileList03 = [], addFileList04 = [], addFileList05 = [],
			addFileList06 = [], addFileList07 = [], addFileList08 = [], addFileList09 = [], addFileList10 = [];

		for (var i = 0, count = attachement_info.length; i < count; i++) {
			if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_01") {
				addFileList01.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_02") {
				addFileList02.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_03") {
				addFileList03.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_04") {
				addFileList04.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_05") {
				addFileList05.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_06") {
				addFileList06.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_07") {
				addFileList07.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_08") {
				addFileList08.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_09") {
				addFileList09.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_10") {
				addFileList10.push(attachement_info[i]);
			}
		}

		setMakeList(addFileList01, "addFileList01", { "dataFunction": {} });
		setMakeList(addFileList02, "addFileList02", { "dataFunction": {} });
		setMakeList(addFileList03, "addFileList03", { "dataFunction": {} });
		setMakeList(addFileList04, "addFileList04", { "dataFunction": {} });
		setMakeList(addFileList05, "addFileList05", { "dataFunction": {} });
		setMakeList(addFileList06, "addFileList06", { "dataFunction": {} });
		setMakeList(addFileList07, "addFileList07", { "dataFunction": {} });
		setMakeList(addFileList08, "addFileList08", { "dataFunction": {} });
		setMakeList(addFileList09, "addFileList09", { "dataFunction": {} });
		setMakeList(addFileList10, "addFileList10", { "dataFunction": {} });
		
		let noData = $('#attachement_info .spc_tbl_row .no-data').parent().next().children();
		for(let i in noData){
			noData.hide();
		}
	}

	function getDataSpcBasic() {
		var spcId = "${param.spc_id}",
			oid = "${param.oid}";

		$.ajax({
			url: apiHost + '/spcs/' + spcId,
			type: 'get',
			async: false,
			data: { oid: oid },
			success: function (json) {
				if (json.data.length > 0) {
					setJsonAutoMapping(json.data[0], 'basicInfo');
					if (!isEmpty(json.data[0].spc_info)) {
						const spc_info = JSON.parse(json.data[0].spc_info);
						if (!isEmpty(spc_info)) {
							setJsonAutoMapping(spc_info, 'basicInfo');
							const fileList = spc_info['SPC_법인_인감'];
							let spcSealSelected = '';
							if (spc_info['spcSealSelected'] != undefined) {
								spcSealSelected = spc_info['spcSealSelected'];
							}

							if (fileList.length > 0) {
								fileList.forEach((file, idx) => {
									if (spcSealSelected != '' && idx == spcSealSelected) {
										fileList[idx]['SPC_법인_인감_대표'] = '대표 인감';
									} else {
										fileList[idx]['SPC_법인_인감_대표'] = '';
									}

									if (isEmpty(file['SPC_법인_인감_유형'])) {
										fileList[idx]['SPC_법인_인감_유형'] = '';
									}
								});
							}

							setMakeList(fileList, 'SPC_법인_인감', {'dataFunction': {}});
						}
					}
				} else {
					alert('등록된 데이터가 없습니다.');
				}
			},
			error: function (request, status, error) {
				alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
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
				$("#genName").text(json.name);
				// $("#countryValue").text("대한민국");
				// $("#sidoValue").text(json.location);
				// $("#address").text(json.address)
			},
			error: function (request, status, error) {}
		});
	}

	function getDataSpcGen() {
		var spcId = '${param.spc_id}',
			genId = '${param.gen_id}',
			oid = '${param.oid}';

		$.ajax({
			url: apiHost + '/spcs/' + spcId + '/gens/' + genId,
			type: 'get',
			async: false,
			data: { 'oid': oid },
			success: function (json) {
				if (json.data.length > 0) {
					//기본정보
					const objArray = ['address', 'maintenance_info', 'account_info', 'finance_info', 'contract_info'
						, 'addlist_insurance_info', 'device_info', 'warranty_info', 'coefficient_info', 'associated_info'];
					const address = JSON.parse(json.data[0].address);
					const maintenance_info = JSON.parse(json.data[0].maintenance_info);
					const account_info = JSON.parse(json.data[0].account_info);
					const finance_info = JSON.parse(json.data[0].finance_info);
					const contract_info = JSON.parse(json.data[0].contract_info);
					const addlist_insurance_info = JSON.parse(json.data[0].addlist_insurance_info);
					const device_info = JSON.parse(json.data[0].device_info);
					const warranty_info = JSON.parse(json.data[0].warranty_info);
					const coefficient_info = JSON.parse(json.data[0].coefficient_info);
					const associated_info = JSON.parse(json.data[0].associated_info);

					objArray.forEach(objName => {
						let target = eval(objName);
						if (!isEmpty(target)) {
							Object.entries(target).map((obj) => {
								if (obj[0].match('동산담보표지판')) {
									target[obj[0]] = obj[1].replace('동산담보표지판_', '').trim();
								} else if (obj[0].match('자가부지공장근저당')) {
									target[obj[0]] = obj[1].replace('자가부지공장근저당_', '').trim();
								} else if (obj[0].match('권리증_보유_현황')) {
									target[obj[0]] = obj[1].replace('권리증_보유_현황_', '').trim();
								} else if (obj[0].match('운영_여부')) {
									target[obj[0]] = obj[1].replace('운영_여부_', '').trim();
								} else if (obj[0].match('관리_계약_구분')) {
									if (obj[1].length > 0) {
										obj[1].forEach((targetObj, idx) => {
											obj[1][idx] = targetObj.replace('관리_계약_구분_', '').trim();
										});
									}
									target[obj[0]] = obj[1];
								} else if (obj[0] == 'SMP' || obj[0] == 'REC') {
									target[obj[0]] = obj[1].replace(/\_/g, ' ');
								} else {
									if (!obj[0].match('계좌_번호') && !obj[0].match('비밀번호') && !obj[0].match('연락처')) {
										if (isNumberic(obj[1])) {
											target[obj[0]] = numberComma(obj[1]);
										}
									}
								}
							});
						}
					});

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
						if (maintenance_info['관리_계약_구분'] != undefined && maintenance_info['관리_계약_구분'].length > 0) {
							if (typeof maintenance_info['관리_계약_구분'] === 'string') {
								$('#maintenanceInfo #관리_계약_구분').html(maintenance_info['관리_계약_구분']);
							} else {
								$('#maintenanceInfo #관리_계약_구분').html(maintenance_info['관리_계약_구분'].join(','));
							}
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
						finance_info['공인인증서'].forEach((target, index) => {
							if (isEmpty(target['용도'])) {
								if (!isEmpty(finance_info['용도 선택' + index])) {
									finance_info['공인인증서'][index]['용도'] = finance_info['용도 선택' + index];
								} else if (!isEmpty(finance_info['용도' + index])) {
									finance_info['공인인증서'][index]['용도'] = finance_info['용도' + index];
								}
							}
						});
						setMakeList(finance_info['공인인증서'], '공인인증서', {'dataFunction': {}});
					} else {
						setMakeList(new Array(), '공인인증서', {'dataFunction': {}});
					}
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
					setMakeTag(deviceRepeatItem, device_info, 'deviceInfo');
					setJsonAutoMapping(device_info, 'deviceInfo'); //설비정보

					if (device_info['설치_타입'] != undefined && device_info['설치_타입'].length > 0) {
						if (typeof device_info['설치_타입'] === 'string') {
							$('#설치_타입').text(device_info['설치_타입']);
						} else {
							$('#설치_타입').text(device_info['설치_타입'].join(','));
						}

					}

					if (device_info['모듈_설치_방식'] != undefined && device_info['모듈_설치_방식'].length > 0) {
						if (typeof device_info['모듈_설치_방식'] === 'string') {
							$('#모듈_설치_방식').text(device_info['모듈_설치_방식']);
						} else {
							$('#모듈_설치_방식').text(device_info['모듈_설치_방식'].join(','));
						}
					}


					setJsonAutoMapping(warranty_info, 'warrantyInfo'); //보증정보
					setJsonAutoMapping(coefficient_info, 'coefficientInfo'); //환경변수
					setJsonAutoMapping(associated_info, 'associatedInfo'); //관련정보

					getAttachFileDisplay(JSON.parse(json.data[0].attachement_info)); //첨부파일

					// var device_info = JSON.parse(json.data[0].device_info);
					// setMakeList(device_info["addList01"], "addList01", { "dataFunction": {} });
					// setMakeList(device_info["addList02"], "addList02", { "dataFunction": {} });
					// setMakeList(device_info["addList03"], "addList03", { "dataFunction": {} });
					// setMakeList(device_info["addList04"], "addList04", { "dataFunction": {} });
					// setMakeList(device_info["addList05"], "addList05", { "dataFunction": {} });
					// setMakeList(device_info["addList06"], "addList06", { "dataFunction": {} });
					// setMakeList(device_info["addList07"], "addList07", { "dataFunction": {} });

					$('[id^=보험_시작일]').each(function() {
						afterDatePick($(this).attr('id'));
					});

					afterDatePick('인출_가능_기한');

					sumUnpaid();
					financeAuto();

				} else {
					alert('등록된 데이터가 없습니다.');
				}
			},
			error: function (request, status, error) {
				alert('오류가 발생하였습니다. \n관리자에게 문의하세요.');
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

	function goMoveList() {
		location.href = "/spc/entityInformation.do";
	}

	function setCheckedDataEdit() {
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}";

		location.href = '/spc/entityInformationEdit.do?spc_id=' + spcId + "&gen_id=" + genId;
	}

	function afterDatePick(thisName) {
		var idx = thisName.replace(/[^0-9]/g, '');
		if (thisName.match('보험_시작일')) {
			var open = $('#' + thisName).text().trim().split('-'),
				close = $('#보험_종료일' + idx).text().trim().split('-'),
				expiry = $('#보험_만기일' + idx).text().trim().split('-');

			open = new Date(open[0], open[1], open[2]),
			close = new Date(close[0], close[1], close[2]),
			expiry = new Date(expiry[0], expiry[1], expiry[2])

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
		} else if (thisName == '인출_가능_기한') {
			if (!isEmpty($('#인출_가능_기한').text().trim())) {
				var close = $('#인출_가능_기한').text().trim().split('-')
				close = new Date(close[0], close[1], close[2]);
				let diff = dateDiff(close, new Date(), 'day');

				$('#인출_가능_남은일').html(Math.floor(diff) + '일&nbsp;&nbsp;남음');
			}
		}
	}

	const sumUnpaid = () => {
		const contractPay = Number($('#도급_계약서_공사_계약_금액').text().replace(/[^0-9]/g, '')),
			agreementPay = Number($('#약정_금액').text().replace(/[^0-9]/g, '')),
			paymentsFirst = Number($('#지급금액_1차').text().replace(/[^0-9]/g, '')),
			paymentsSecond = Number($('#지급금액_2차').text().replace(/[^0-9]/g, '')),
			paymentsThird = Number($('#지급금액_3차').text().replace(/[^0-9]/g, ''));

		const sumUnPaidPay = contractPay + agreementPay - paymentsFirst - paymentsSecond - paymentsThird;
		$('#미지급_금액').text(numberComma(sumUnPaidPay));
	}

	function getExcelDown() {
		let genName = $('#genName').text();
		let excelName = 'spc_' + genName + '_';

		var excelHtml = '';
		excelHtml += $('#basicInfo h2').html();
		excelHtml += $('#basicInfo #basicInfoToggle').html();
		excelHtml += $('#addressInfo h2').html();
		excelHtml += $('#addressInfo #addressInfoToggle').html();
		excelHtml += $('#maintenanceInfo h2').html();
		excelHtml += $('#maintenanceInfo #maintenanceInfoToggle').html();
		excelHtml += $('#accountInfo h2').html();
		excelHtml += $('#accountInfo #accountInfoToggle').html();
		excelHtml += $('#financeInfo h2').html();
		excelHtml += $('#financeInfo #financeInfoToggle').html();
		excelHtml += $('#contractInfo h2').html();
		excelHtml += $('#contractInfo #contractInfoToggle').html();
		excelHtml += $('#insuranceInfo h2').html();
		excelHtml += $('#insuranceInfo #insuranceInfoToggle').html();
		excelHtml += $('#deviceInfo h2').html();
		excelHtml += $('#deviceInfo #deviceInfoToggle').html();
		excelHtml += $('#warrantyInfo h2').html();
		excelHtml += $('#warrantyInfo #warrantyInfoToggle').html();
		excelHtml += $('#coefficientInfo h2').html();
		excelHtml += $('#coefficientInfo #coefficientInfoToggle').html();
		excelHtml += $('#associatedInfo h2').html();
		excelHtml += $('#associatedInfo #associatedInfoToggle').html();
		excelHtml += $('.attachment h2').html();
		excelHtml += $('#attachement_info #attachementInfoToggle').html();

		$('#excelList').html(excelHtml);

		if (confirm('엑셀로 저장하시겠습니까?')) {
			tableToExcel('excelList', excelName);
		}
	}

	const autoValArr = ['#관리_운영비', '#대수선비', '#사무_수탁비', '#임대료'];
	const financeAuto = () => {
		autoValArr.forEach(autoId => {
			const totalVal = $('#전체_용량').text().replace(/[^0-9 \-\+]/g, '');
			const targetVal = $(autoId).text().replace(/[^0-9 \-\+]/g, '');
			let autoVal = Number(targetVal) / Number(totalVal);
			if (isNaN(autoVal) || !isFinite(autoVal)) {
				$(autoId).parent().next().find('.auto_price').text('');
			} else {
				$(autoId).parent().next().find('.auto_price').text(numberComma(autoVal.toFixed(2)));
			}
		});
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 기본 정보</h1>
	</div>
</div>
<div class="row entity_wrap post panel-group" id="accordion">
	<div class="col-12">
		<div class="indiv panel panel-default" id="basicInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">기본 정보</h2>
				<a role="button" href="#basicInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="basicInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>SPC명</th>
						<td id="name"></td>
						<th><label for="대표자">대표자</label></th>
						<td id="대표자">
						</td>
					</tr>
					<tr>
						<th>사업자등록번호</th>
						<td id="사업자등록번호"></td>
						<th>법인등록번호</th>
						<td id="법인등록번호"></td>
					</tr>
					<tr>
						<th>SPC 주소</th>
						<td>
							<span id="spcCountry"></span>
							<span id="spcSido"></span>
							<span id="spcAddress"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>사업명</th>
						<td id="사업명"></td>
						<th>펀드명</th>
						<td id="펀드명"></td>
					</tr>
					<tr>
						<th>금융사</th>
						<td id="금융사"></td>
						<th>담당자(연락처)</th>
						<td id="금융사_담당자(연락처)"></td>
					</tr>
					<tr>
						<th>시공사</th>
						<td id="시공사"></td>
						<th>담당자(연락처)</th>
						<td id="시공사_담당자(연락처)"></td>
					</tr>
					<tr>
						<th>사무수탁사</th>
						<td id="사무수탁사"></td>
						<th>담당자(연락처)</th>
						<td id="사무수탁사_담당자(연락처)"></td>
					</tr>
					<tr>
						<th>관리 운영사</th>
						<td id="관리_운영사">
						</td>
						<th>발전 관리자(연락처)</th>
						<td id="발전_관리자(연락처)"></td>
					</tr>
					<tr>
						<th></th>
						<td></td>
						<th>사업 관리자(연락처)</th>
						<td id="사업_관리자(연락처)"></td>
					</tr>
					<tr>
						<th class="group_type">SPC 법인 인감</th>
						<td id="SPC_법인_인감">
							<p>
								<span class="offset-label">[SPC_법인_인감_대표]</span>
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]" class="tx_file">[SPC_법인_인감_유형] - [originalname]</a>
							</p>
						</td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
				</table>
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
						<td class="group_type" id="genName"></td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td>
							<span id="발전소_국가"></span>
							<span id="발전소_시도"></span>
							<span id="발전소_상세주소"></span>
						</td>
						<th></th>
						<td></td>
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
							<span id="설치_용량"></span>
							<span id="설치_용량_기타"></span>
						</td>
						<th>관리 운영 기간</th>
						<td><span id="관리_운영_기간_from"></span> ~ <span id="관리_운영_기간_to"></span></td>
					</tr>
					<tr>
						<th>기상 관측 지점</th>
						<td id="기상_관측_지점"></td>
						<th>하자 보증기간(전기)</th>
						<td>
							<span id="하자_보증기간(전기)_from"></span>
							<span id="하자_보증기간(전기)_to"></span>
						</td>
					</tr>
					<tr>
						<th>사용 전 검사 완료일</th>
						<td id="사용_전_검사_완료일"></td>
						<th>하자 보증기간(토목)</th>
						<td>
							<span id="하자_보증기간(토목)_from"></span>
							<span id="하자_보증기간(토목)_to"></span>
						</td>
					</tr>

					<tr>
						<th>등기이사 소속</th>
						<td class="addList_affiliation entity">
							<div class="group_type flex_start fixed_height">
								<span id="등기이사_소속_[index]"></span>
								<span id="등기이사_명[index]" class="ml-6"></span>
							</div>
						</td>
						<th>등기 기간</th>
						<td class="addList_affiliation2 entity">
							<div class="group_type flex_start fixed_height">
								<span id="등기_기간_from[index]"></span> ~ <span id="등기_기간_to[index]"></span>&nbsp;&nbsp;&nbsp;&nbsp;
								<span id="등기_이사_만료_알림[index]"></span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="계약_단가">계약 단가</label></th>
						<td>
							<div class="flex_start fixed_height">
								<span id="계약_단가"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
						<th>상업 운전 개시일</th>
						<td>
							<span id="상업_운전_개시일"></span></span>
						</td>
					</tr>
					<tr>
						<th>부지 소유 / 임대 구분</th>
						<td id="부지소유/임대구분"></td>
						<th>개발행위필증 교부 여부</th>
						<td id="개발행위필증_교부_여부"></td>
					</tr>
					<tr>
						<th>지상권 및 지상권부근저당 설정 여부</th>
						<td id="지상권설정여부"></td>
						<th>동산담보표지판 설정 여부</th>
						<td id="동산담보표지판_설정_여부"></td>
					</tr>
					<tr>
						<th>자가부지공장근저당 목록 설정 여부</th>
						<td id="자가부지공장근저당"></td>
						<th>권리증 보유 현황</th>
						<td id="권리증_보유_현황"></td>
					</tr>
					<tr>
						<th>운영 여부</th>
						<td id="운영_여부"></td>
						<th>관리 계약 구분</th>
						<td id="관리_계약_구분"></td>
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
						<th>RPS 시스템 ID</th>
						<td id="RPS_시스템_ID"></td>
						<th>PW</th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
					<tr>
						<th>전력 거래소 ID</th>
						<td id="전력_거래소_ID"></td>
						<th>PW</th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
					<tr>
						<th>REC 발전사 ID</th>
						<td id="REC_발전사_ID"></td>
						<th>발전사명</th>
						<td id="발전사명"></td>
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
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>금융사(자금 운영 기관)</th>
						<td id="관련_금융사"></td>
						<th>대표자</th>
						<td id="금융사_대표자"></td>
					</tr>
					<tr>
						<th>계약 체결일</th>
						<td id="계약_체결일"></td>
						<th>대출 약정액</th>
						<td>
							<div class="flex_start fixed_height">
								<span id="대출_약정액"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th class="group_type">상환 만기일</th>
						<td id="상환_만기일"></td>
						<th class="group_type">이자 지급일</th>
						<td id="addList_interest_pay_date" class="entity">
							<div class="group_type flex_start">
								<span id="이자_지급일[index]"></span>
							</div>
						</td>
					</tr>
					<tr>
						<th class="group_type">보장발전시간 정산일</th>
						<td id="addList_payroll_date" class="entity">
							<div class="group_type flex_start fixed_height">
								<span id="보장발전시간_정산일[index]"></span>
							</div>
						</td>
						<th>대리기관 수수료 지급일</th>
						<td id="addList_commission_payment" class="entity">
							<div class="group_type flex_start fixed_height">
								<span id="대리기관_수수료_지급일[index]"></span>
							</div>
						</td>
					</tr>
					<tr class="addList_account_holder entity">
						<th>
							<div class="fixed_height">은행 계좌</div>
							<div class="fixed_height">예금주</div>
						</th>
						<td>
							<div class="fixed_height group_type short">
								<span id="입출금_구분[index]"></span>
								<span id="계좌구분[index]"></span>
								<span id="은행_리스트[index]"></span>
							</div>
							<div class="fixed_height">
								<span id="예금주[index]"></span>
							</div>
						</td>
						<th>
							<div class="fixed_height">계좌 번호</div>
							<div class="fixed_height">계좌개설 은행(지점)</div>
						</th>
						<td>
							<div class="fixed_height">
								<span id="계좌_번호[index]"></span>
							</div>
							<div class="fixed_height">
								<span id="계좌개설_은행(지점)[index]"></span>
							</div>
						</td>
					</tr>
					<tr>
						<th>빠른조회 비밀번호</th>
						<td id="빠른조회_비밀번호"></td>
						<th></th>
						<td></td>
					</tr>
					<tr class="addList_certificate_registration entity">
						<th class="group_type">공인인증서 등록</th>
						<td id="공인인증서">
							<div class="flex_start fixed_height">
								<p class="tx_file">
									[용도] - [originalname]
								</p>
							</div>
						</td>
						<th>인증서 비밀번호</th>
						<td class="flex_start fixed_height">
							<span id="인증서_비밀번호[index]"></span>
						</td>
					</tr>
					<tr>
						<th>DSRA 적립 요구금액</th>
						<td>
							<div class="flex_start fixed_height">
								<span id="DSRA_적립_요구금액"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>
							<div class="fixed_height">고정 금액</div>
							<div class="fixed_height">전체 용량</div>
							<div class="fixed_height">관리 운영비</div>
							<div class="fixed_height">대수선비</div>
							<div class="fixed_height">사무 수탁비</div>
							<div class="fixed_height">임대료</div>
							<div class="fixed_height">SMP</div>
							<div class="fixed_height">REC</div>
						</th>
						<td class="align_top">
							<div class="flex_start fixed_height"></div>
							<div class="flex_start fixed_height">
								<span id="전체_용량"></span>
								<span class="ml-6">MW</span>
							</div>
							<div class="flex_start">
								<div class="fixed_height mr-30">
									<span id="관리_운영비"></span>
									<span class="ml-6">원</span>
								</div>
								<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
							</div>
							<div class="flex_start">
								<div class="fixed_height mr-30">
									<span id="대수선비"></span>
									<span class="ml-6">원</span>
								</div>
								<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
							</div>
							<div class="flex_start">
								<div class="fixed_height mr-30">
									<span id="사무_수탁비"></span>
									<span class="ml-6">원</span>
								</div>
								<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
							</div>
							<div class="flex_start">
								<div class="fixed_height mr-30">
									<span id="임대료"></span>
									<span class="ml-6">원</span>
								</div>
								<span class="fixed_height"><span class="auto_price mr-6"></span>원/MW</span>
							</div>
							<div class="group_type">
								<div class="fixed_height">
									<span id="SMP"></span>
									<span id="SMP원" class="ml-6"></span>
									<span class="ml-6">원</span>
								</div>
							</div>
							<div class="group_type">
								<div class="fixed_height">
									<span id="REC"></span>
									<span id="REC원" class="ml-6"></span>
									<span class="ml-6">원</span>
								</div>
							</div>
						</td>
						<th class="align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height flex_wrap_center">임대료 지급일</div>
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
								<div  class="fixed_height">
									<span id="임대료_지급일[index]"></span>
								</div>
							</div>
							<div class="fixed_height"></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="contractInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">시공 계약 정보</h2>
				<a role="button" href="#contractInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="contractInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>시공사</th>
						<td id="공사_계약_정보_시공사"></td>
						<th>약정일</th>
						<td id="공사_계약_정보_약정일"></td>
					</tr>
					<tr>
						<th>(도급 계약서) 공사 계약 금액</th>
						<td>
							<div>
								<span id="도급_계약서_공사_계약_금액"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
						<th>약정 금액</th>
						<td>
							<div>
								<span id="약정_금액"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>(도급 계약서) 사용전 검사일</th>
						<td id="도급_계약서_사용전_검사일"></td>
						<th>(실제) 사용전 검사일자</th>
						<td id="실제_사용전_검사일자"></td>
					</tr>
					<tr>
						<th>(도급 계약서) 준공일</th>
						<td id="도급_계약서_준공일"></td>
						<th>(실제) 준공일</th>
						<td id="실제_준공일"></td>
					</tr>
					<tr>
						<th>인출 가능 기한</th>
						<td>
							<span id="인출_가능_기한"></span>
							<span class="fixed_height" id="인출_가능_남은일"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>
							<div class="fixed_height">지급 약정</div>
							<div class="fixed_height">계약서 명시 인출일<span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
							<div class="fixed_height">지급금액<span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
							<div class="fixed_height">
								미지급액
							</div>
						</th>
						<td>
							<div class="flex_start fixed_height"></div>
							<div class="flex_start">
								<span class="fixed_height" id="계약서_명시_인출일_1차"></span>
							</div>
							<div class="flex_start">
								<span class="fixed_height" id="계약서_명시_인출일_2차"></span>
							</div>
							<div class="flex_start">
								<span class="fixed_height" id="계약서_명시_인출일_3차"></span>
							</div>
							<div class="flex_start">
								<div class="fixed_height">
									<span id="지급금액_1차"></span>
									<span class="ml-6">원</span>
								</div>
							</div>
							<div class="flex_start">
								<span class="fixed_height">
									<div class="fixed_height">
										<span id="지급금액_2차"></span>
										<span class="ml-6">원</span>
									</div>
								</span>
							</div>
							<div class="flex_start">
								<span class="fixed_height">
									<div class="fixed_height">
										<span id="지급금액_3차"></span>
										<span class="ml-6">원</span>
									</div>
								</span>
							</div>
							<div class="fixed_height w300">
								<span class="text" id="미지급_금액">자동 계산</span>
								<span class="fr">원</span>
							</div>
						</td>
						<th class="align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height">실 지급일<span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
						</th>
						<td class="align_top">
							<div class="fixed_height"></div>
							<div class="flex_start">
								<span class="fixed_height" id="실_지급일_1차"></span>
							</div>
							<div class="flex_start">
								<span class="fixed_height" id="실_지급일_2차"></span>
							</div>
							<div class="flex_start">
								<span class="fixed_height" id="실_지급일_3차"></span>
							</div>
						</td>
						<th class="align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
						</th>
						<td class="align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="insuranceInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">보험 정보</h2>
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
						<td id="보험구분[index]"></td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>보험사</th>
						<td id="보험사[index]"></td>
						<th>보험 중개사</th>
						<td id="보험_중개사[index]"></td>
					</tr>
					<tr>
						<th>보험 기간</th>
						<td class="group_type">
							<span id="보험_기간_from[index]"></span> ~ <span id="보험_기간_to[index]"></span>
						</td>
						<th>보험료</th>
						<td>
							<div>
								<span id="보험료[index]"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>자가부담금</th>
						<td>
							<div>
								<span id="자가부담금[index]"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
						<th>보험가액</th>
						<td>
							<div>
								<span id="보험가액[index]"></span>
								<span class="ml-6">원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>시작일</th>
						<td id="보험_시작일[index]"></td>
						<th>종료일</th>
						<td class="flex_start">
							<span id="보험_종료일[index]"></span>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="fixed_height" id="보험_종료일_차이[index]"></span>
						</td>
					</tr>
					<tr>
						<th></th>
						<td></td>
						<th>만기일</th>
						<td class="flex_start">
							<span id="보험_만기일[index]"></span>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="fixed_height" id="보험_만기일_차이[index]"></span>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="deviceInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">설비 정보</h2>
				<a role="button" href="#deviceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
			<div id="deviceInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>모듈 제조사 / 모델</th>
						<td id="addList_module_info" class="entity">
							<div class="flex_start fixed_height">
								<span id="모듈_제조사[index]" class="mr-30"></span>
								<span id="모듈_제조사_모델[index]"></span>
							</div>
						</td>
						<th>설치 용량</th>
						<td class="flex_start fixed_height">
							<span id="설치_용량_KW"></span>
							<span class="ml-6">kW</span>
							<span id="설치_용량(매)"class="ml-30"></span>
							<span class="ml-6">매</span>
						</td>
					</tr>
					<tr>
						<th>모듈 설치 각도</th>
						<td id="addList_module_angle" class="entity">
							<div class="flex_start fixed_height">
								<span id="모듈_설치_각도[index]"></span><span class="ml-6">°</span>
							</div>
						</td>
						<th>모듈 설치 방식</th>
						<td>
							<span id="모듈_설치_방식"></span>
						</td>
					</tr>
					<tr>
						<th>인버터 제조사 / 모델</th>
						<td id="addList_inverter" class="entity">
							<div class="flex_start fixed_height">
								<span id="인버터_제조사[index]"></span>
								<span id="인버터_제조사_모델[index]" class="ml-30"></span>
							</div>
						</td>
						<th>인버터 용량 / 대수</th>
						<td id="addList_inverter_vol" class="entity">
							<div class="flex_start fixed_height">
								<span id="인버터_용량[index]"></span><span class="ml-6">kW</span>
								<span id="인버터_용량_대수[index]" class="ml-30"></span><span class="ml-6">대</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>접속반 제조사 / 모델</th>
						<td id="addList_manufacturer" class="entity">
							<div class="flex_start fixed_height">
								<span id="접속반_제조사[index]"></span>
								<span id="접속반_제조사_모델[index]"></span>
							</div>
						</td>
						<th>접속반 채널 / 대수</th>
						<td id="addList_connection" class="entity">
							<div class="flex_start fixed_height">
								<span id="접속반_채널[index]"></span><span class="ml-6">Ch</span>
								<span id="접속반_채널_대수[index]" class="ml-30"></span><span class="ml-6">대</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>접속반 용량 / 통신방식</th>
						<td class="flex_start fixed_height">
							<span id="접속반_용량"></span><span class="ml-6">kW</span>
							<span id="통신방식" class="ml-6"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td id="설치_타입"></td>
						<th>수배전반 제조사 / 모델</th>
						<td id="addList_switch_gear" class="entity">
							<div class="flex_start fixed_height">
								<span id="수배전반_제조사[index]"></span>
								<span id="수배전반_모델[index]" class="ml-30"></span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="warrantyInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">보증 정보</h2>
				<a role="button" href="#warrantyInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a>
			</div>
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
						<td id="보증_방식"></td>
						<th>PR 보증치</th>
						<td>
							<span id="PR_보증치"></span><span class="ml-6">%</span>
						</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td>
							<span id="발전시간_보증치"></span><span class="ml-6">h</span>
						</td>
						<th>보증 감소율</th>
						<td>
							<span id="보증_감소율"></span><span class="ml-6">년차별 %</span>
						</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td class="group_type">
							<span id="기준_단가"></span>
							<span id="기준_단가_원"></span><span class="ml-6">원 / kW</span>
						</td>
						<th>현재 적용 연차</th>
						<td>
							<span id="현재_적용_연차"></span><span class="ml-6">년차</span>
						</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td>
							<span id="년간_관리_운영비"></span><span class="ml-6">만원</span>
						</td>
						<th>물가 반영 비율</th>
						<td>
							<span id="물가_반영_비율"></span><span class="ml-6">%</span>
						</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td id="추가_보수"></td>
						<th>추가 보수 용량</th>
						<td>
							<span id="추가_보수_용량"></span><span class="ml-6">kW 이상</span>
						</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td>
							<span id="추가_보수_백분율"></span><span class="ml-6">%</span>
						</td>
						<th>전력요금 종별</th>
						<td class="group_type">
							<span id="전력요금_종별_요금제"></span>
							<span id="전력요금_종별_계약전력"></span><span class="ml-6">kW</span>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="coefficientInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">환경 변수</h2>
				<a href="#coefficientInfoToggle" data-toggle="collapse" class="collapse_arrow"></a>
			</div>
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
							<span id="annual"></span><span class="ml-6">%</span>
						</td>
						<th>PV modul modeling/params</th>
						<td>
							<span id="pv_modul"></span><span class="ml-6">%</span>
						</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td>
							<span id="inverter"></span><span class="ml-6">%</span>
						</td>
						<th>Soiling, mismatch</th>
						<td>
							<span id="soiling"></span><span class="ml-6">%</span>
						</td>
					</tr>
					<tr>
						<th>Degradation estimation</th>
						<td>
							<span id="degradationEstimation"></span><span class="ml-6">%</span>
						</td>
						<th>Resulting ann, Variability(sigma)</th>
						<td>
							<span id="resulting_ann"></span><span class="ml-6">%</span>
						</td>
					</tr>
					<tr>
						<th>System Degradation</th>
						<td>
							<span id="system_degradation"></span><span class="ml-6">%</span>
						</td>
						<th>System Availability</th>
						<td>
							<span id="system_availability"></span><span class="ml-6">%</span>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="associatedInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">관련 정보</h2>
				<a href="#associatedInfoToggle" data-toggle="collapse" class="collapse_arrow"></a>
			</div>
			<div id="associatedInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>전기안전 관리 회사명</th>
						<td>
							<span id="전기안전_관리_회사명"></span>
						</td>
						<th>회사 연락처</th>
						<td>
							<span id="회사_연락처"></span>
						</td>
					</tr>
					<tr>
						<th>전기안전 관리 대표자명</th>
						<td>
							<span id="전기안전_관리_대표자명"></span>
						</td>
						<th>대표자 연락처</th>
						<td>
							<span id="대표자_연락처"></span>
						</td>
					</tr>
					<tr>
						<th>전기안전 관리 담당자명</th>
						<td>
							<span id="전기안전_관리_담당자명"></span>
						</td>
						<th>담당자 연락처</th>
						<td>
							<span id="담당자_연락처"></span>
						</td>
					</tr>
					<tr>
						<th>현장 잠금장치 비밀번호</th>
						<td>
							<span id="현장_잠금장치_비밀번호"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>

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
						<col style="width:20%">
						<col>
					</colgroup>
					<tr>
						<th>현장 사진</th>
						<td id="addFileList01">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>수배전반</th>
						<td id="addFileList02">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>케이블</th>
						<td id="addFileList03">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>모듈</th>
						<td id="addFileList04">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>인버터</th>
						<td id="addFileList05">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>결선도</th>
						<td id="addFileList06">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>토목</th>
						<td id="addFileList07">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>구조물</th>
						<td id="addFileList08">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>접속반</th>
						<td id="addFileList09">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>기타설비</th>
						<td id="addFileList10">
							<p class="tx_file">
								<a href="${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
							<button type="button" class="btn_file down" onclick="location.href='${apiHost}/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]'"></button>
						</td>
						<td></td>
					</tr>
				</table>
				</div>
			</form>
		</div>

		<div class="btn_wrap_type_right"><!--
			--><button type="button" class="btn_type03" onclick="getExcelDown();">엑셀 다운로드</button><!--
			--><button type="button" id="modifyButton" class="btn_type03" onclick="setCheckedDataEdit();">수정</button><!--
			--><button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
		--></div>
		<div id="excelList" style="display:none;">
		</div>
	</div>
</div>