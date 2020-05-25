<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let today = new Date();
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	let repeat_type_method = 'post';
	let repeatCoastNumber = new Object();

	$(function () {
		$(document).on('keyup keypress keydown', 'input[type="text"]', function () {
			let text = $(this).val().replace(/[^-0-9.]/gi, '');
			if (isNaN(text)) {
				$(this).val('');
			} else {
				$(this).val(text);
			}
		});

		// 유형 선택
		$(document).on('click change', ':radio[name^="contract_"]', function () {
			let idx = $(':radio[name^="contract_"][value=' + $(this).val() + ']').index($(this));
			if ($(this).is(':checked')) {
				$(':radio[name=' + $(this).prop('name') + ']').prop('checked', false);
				$(this).prop('checked', true);

				if ($(this).val() == '1') {
					$('#service_chargeTable tbody tr').eq(idx).find('input[type="text"]').prop('readonly', true).val('');
					$('[name^="grossPerMonth_"]').eq(idx).prop('readonly', false).val('');
				} else {
					$('#service_chargeTable tbody tr').eq(idx).find('input[type="text"]').prop('readonly', true).val('');
					$('[name^="salesSupply_"]').eq(idx).prop('readonly', false).val('');
					$('[name^="salesRate_"]').eq(idx).prop('readonly', false).val('');
				}
			} else {
				$('#service_chargeTable tbody tr').eq(idx).find('input[type="text"]').prop('readonly', true).val('');
			}
		});

		$(document).on('click', '.dropdown li', function (e) {
			e.preventDefault();
			if($(this).hasClass('disabled')) {
				return false;
			}

			let dataValue = $(this).data('value');
			let dataText = $(this).text();
			let id = $(this).parents('.dropdown').prop('id');

			$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);

			if (id == 'spc') {
				callAjax({
					url: 'http://iderms.enertalk.com:8443/spcs/' + dataValue,
					type: 'get',
					data: {
						oid: oid,
						includeGens: true
					}
				}, setSpcGen);
			} else if (id == 'spcGen') {
				// 사이트 정보 조회
				let sid = $('#spcGen button').data('value');
				if (sid == undefined || sid == '') {
					return;
				}

				callAjax({
					url: 'http://iderms.enertalk.com:8443/spcs/' + $('#spc button').data('value') + '/balance/repeat_cost',
					type: 'get',
					data: {
						oid: oid,
						site_id: $('#spcGen button').data('value')
					}
				}, setRepestCost);

				selAbleMonth();
			} else if(id == 'year' || id == 'month') {
				if(id == 'year') {
					selAbleMonth();
				}

				payment();
			}
		});

		//차입금/이자
		$(document).on('propertychange change keyup paste input', '[name^="principal_"], [name^="interestRate_"], :radio[name^="repayType"]', function () {
			let inpName = $(this).prop('id').split('_');
			let idx = $('[id^="' + inpName[0] + '_"]').index(this);
			let loan = $('[name^="principal_"]').eq(idx).val().replace(/[^0-9.-]/g, '') //원금
			let payBalance = loan; //잔금
			let loan_gumri = $('[name^="interestRate_"]').eq(idx).val().replace(/[^0-9.-]/g, '') //금리
			let loan_type = $('#interestTable tbody tr').eq(idx).find(':radio[name^="repayType"]:checked').val();//대출유형
			let loan_period = $('[name^="period_"]').eq(idx).val(); //기간
			let loan_term = 0;
			let total_iza = 0;		//총이자
			let iza = 0;            //이자
			let org_loan = 0;	    //납입원금
			let repayment = 0;	    //상환금
			let org_loan_tot = 0;	//납입원금 누계
			let standard = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2);

			if (loan_type != undefined && loan != '' && loan_period != '' && loan_gumri != '') {
				loan_gumri = loan_gumri / 100;
				for (let i = 0; i < loan_period; i++) {
					let startDate = $('.fromDate').eq(0).datepicker('getDate');
					let loanDate = new Date(startDate.getFullYear(), startDate.getMonth() + i, startDate.getDate());
					iza = CalculateUtil.getIza(loan_type, i, loan, loan_gumri, payBalance);
					total_iza += iza;

					if (loan_type == '3') {
						repayment = CalculateUtil.getRepayment(loan_type, org_loan, iza, loan_gumri, loan_period, loan_term, loan, i);
						if (i >= loan_term) {	//거치기간 후부터 계산
							org_loan = CalculateUtil.getOrgLoan(loan_type, i, loan_period, loan, loan_term, repayment, iza);
						}
					} else {
						if (i >= loan_term) {	//거치기간 후부터 계산
							org_loan = CalculateUtil.getOrgLoan(loan_type, i, loan_period, loan, loan_term, repayment, iza);
						}
						repayment = CalculateUtil.getRepayment(loan_type, org_loan, iza, loan_gumri, loan_period, loan_term, loan, i);
					}
					org_loan_tot = org_loan_tot + org_loan;
					payBalance = loan - org_loan_tot;

					if (loanDate.format('yyyyMM') == standard) {
						$('[name^="loan"]').eq(idx).val(numberComma(Math.round(org_loan)));
						$('[name^="interestCost"]').eq(idx).val(Math.round(iza));
					}
				}
			}
			balanceSum();
		});

		//대리기관/관리운영 수수료 - 월정액
		$(document).on('propertychange change keyup paste input', '[name^="grossPerMonth_"]', function () {
			let inpName = $(this).prop('name').split('_');
			let idx = $('[name^="' + inpName[0] + '_"]').index(this);
			let grossPerMonth = $('[name^="grossPerMonth_"]').eq(idx).val().replace(/[^0-9.-]/g, '')

			if (grossPerMonth != '' && grossPerMonth > 0) {
				let surtax = Math.round(grossPerMonth * 0.1);
				let supplySum = Math.round(grossPerMonth * 1.1);

				$('[name^="grossPerMonth_"]').eq(idx).val(numberComma(grossPerMonth));
				$('[name^="grossPerMonthSurtax_"]').eq(idx).val(numberComma(surtax));
				$('[name^="grossPerMonthSumtax_"]').eq(idx).val(numberComma(supplySum));

				if (idx == 0) {
					$('[name^="conversionCharge"]').eq(0).val(numberComma(supplySum));
				} else {
					$('[name^="managementCharge"]').eq(0).val(numberComma(supplySum));
				}

			} else {
				$('[name^="grossPerMonthSurtax_"]').eq(idx).val('');
				$('[name^="grossPerMonthSumtax_"]').eq(idx).val('');

				if (idx == 0) {
					$('[name^="conversionCharge"]').eq(0).val('');
				} else {
					$('[name^="managementCharge"]').eq(0).val('');
				}
			}
			balanceSum();
		});

		//대리기관/관리운영 수수료 - 매출(수익)연동
		$(document).on('propertychange change keyup paste input', '[name^="salesRate_"], [name^="salesSupply_"]', function () {
			let inpName = $(this).prop('name').split('_');
			let idx = $('[name^="' + inpName[0] + '_"]').index(this);
			let salesRate = $('[name^="salesRate_"]').eq(idx).val().replace(/[^0-9.-]/g, '')
			let salesSupply = $('[name^="salesSupply_"]').eq(idx).val().replace(/[^0-9.-]/g, '')

			if (salesRate != '' && salesSupply != '' && salesSupply > 0) {
				let surtax = Math.round((salesSupply * salesRate) * 0.1);
				let supplySum = Math.round((salesSupply * salesRate) * 1.1);
				$('[name^="salesSupply_"]').eq(idx).val(numberComma(salesSupply));
				$('[name^="salesSupplySurtax_"]').eq(idx).val(numberComma(surtax));
				$('[name^="salesSupplySumtax_"]').eq(idx).val(numberComma(supplySum));

				if (idx == 0) {
					$('[name^="conversionCharge"]').eq(0).val(numberComma(supplySum));
				} else {
					$('[name^="managementCharge"]').eq(0).val(numberComma(supplySum));
				}
			} else {
				$('[name^="salesSupplySurtax_"]').eq(idx).val('');
				$('[name^="salesSupplySumtax_"]').eq(idx).val('');

				if (idx == 0) {
					$('[name^="conversionCharge"]').eq(0).val('');
				} else {
					$('[name^="managementCharge"]').eq(0).val('');
				}
			}
			balanceSum();
		});

		//수수료
		$(document).on('propertychange change keyup paste input', '[name^="supply_"]', function () {
			let idx = $('[name^="supply_"]').index(this);
			let thisVal = $(this).val().replace(/[^0-9.-]/g, '')

			if (thisVal != '' && thisVal > 0) {
				let surtax = Math.round(thisVal * 0.1);
				let supplySum = Math.round(thisVal * 1.1);

				$(this).val(numberComma(thisVal));
				$('[name^="surtax_"]').eq(idx).val(numberComma(surtax));
				$('[name^="supplySum_"]').eq(idx).val(numberComma(supplySum));
			}

			let sum = 0;
			$('[name^="supplySum_"]').each(function () {
				sum += Number($(this).val().replace(/[^0-9.]/g, ''));
			});

			if (sum > 0) {
				$('#rental').val(numberComma(Math.round(sum)));
			} else {
				$('#rental').val('');
			}
			balanceSum();
		});

		//수기 입력
		$('#noteDown').on('click', function () {
			if ($(this).is(':checked')) {
				$('#balanceTable').find('input[placeholder="자동 입력"]').prop('readonly', false).parent().removeClass('read').addClass('edit');
			} else {
				$('#balanceTable').find('input[placeholder="자동 입력"]').prop('readonly', true).parent().removeClass('edit').addClass('read');
			}
		});

		//현근유입 합계
		$(document).on('propertychange change keyup paste input', '#balanceTable input', function () {
			if (!$('#noteDown').is(':checked')) {
				balanceSum();
			}
		});

		$('input[type="file"]').on('change', function() {
			let uuid = genUuid();
			let thisId = $(this).prop('id');

			$(this).clone().appendTo('#upload');
			$('#upload').find('input').attr('name', uuid).attr('id', uuid);

			callAjax({
				type: 'post',
				enctype: 'multipart/form-data',
				url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
				data: new FormData($('#upload')[0]),
				processData: false,
				contentType: false,
				cache: false,
				timeout: 600000
			}, setUploadAfter, thisId);
		});

		$('button.btn_clse').on('click', function() {
			setDefaultFile($(this));
		});

		pageInit();
	});

	//합계
	const balanceSum = function () {
		let inflowArray = ['siteBilling', 'siteMoney'];
		let outflowArray = ['loan', 'interestCost', 'conversionCharge', 'managementCharge', 'corporateTax', 'additionalTax', 'rental', 'expense'];
		let inflow = 0, outflow = 0, endOfTerm = 0, endOfTermFlow = 0;

		$('#balanceTable input').each(function () {
			let thisVal = $(this).val() == '' ? 0 : $(this).val().replace(/[^0-9.-]/g, '')
			let propName = $(this).prop('name');

			inflowArray.forEach(function (v) {
				if (propName.match(v)) {
					inflow += Number(thisVal);
				}
			});

			outflowArray.forEach(function (v) {
				if (propName.match(v)) {
					outflow += Number(thisVal);
				}
			})
		});

		endOfTerm = inflow - outflow;
		endOfTermFlow = inflow - outflow;

		$('#inflowOfCash').val(numberComma(inflow));
		$('#outflowOfCash').val(numberComma(outflow));
		$('#endOfTerm').val(numberComma(endOfTerm));
		$('#endOfTermFlow').val(numberComma(endOfTermFlow));
	};

	const rowAppend = function () {
		let objTable = $('#interestTable');

		/* datepicker 사용시에만 할수있게 따로 처리 필요 */
		objTable.find('.fromDate').removeClass('hasDatepicker').datepicker({
			showOn: "both",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function (selectedDate) {
				let selDate = new Date(selectedDate);
				selDate = new Date(selDate.getFullYear(), selDate.getMonth() + 1, selDate.getDate());
				$(this).parents('tr').find('.toDate').datepicker('option', 'minDate', selDate);

				let diff = getDiff($(this).parents('tr').find('.toDate').datepicker('getDate'), $(this).datepicker('getDate'));
				$(this).parents('tr').find('[id^="period_"]').val(diff);
			}
		}); //row추가시 datepicker적용

		objTable.find('.toDate').removeClass('hasDatepicker').datepicker({
			showOn: "both",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function (selectedDate) {
				let selDate = new Date(selectedDate);
				selDate = new Date(selDate.getFullYear(), selDate.getMonth() - 1, selDate.getDate());
				$(this).parents('tr').find('.fromDate').datepicker('option', 'maxDate', selectedDate);

				let diff = getDiff($(this).datepicker('getDate'), $(this).parents('tr').find('.fromDate').datepicker('getDate'));
				$(this).parents('tr').find('[id^="period_"]').val(diff);
			}
		}); //row추가시 datepicker적용
		/* datepicker 사용시에만 할수있게 따로 처리 필요 */

		if (objTable.find('tbody tr').length > 1) {
			objTable.find('tbody tr').each(function (i) {
				let num = i + 1;
				$(this).find('td').eq(0).html(String.fromCharCode(num + 64));
			});

			let insertIndex = $('#balanceTable tr').index($('.service_chargeTr:first'));
			let targetIndex = $('#balanceTable tr').index($('.interestTr:first'));

			let balanceTable = document.getElementById('balanceTable');
			let row = balanceTable.insertRow(insertIndex);
			let rowClone = balanceTable.rows[targetIndex];

			copyAttribute(rowClone, row);

			for (let i = 0; i < balanceTable.rows[targetIndex].cells.length; i++) {
				let cellClone = rowClone.cells[i];
				let cell = row.insertCell();
				cell.innerHTML = cellClone.innerHTML;
				copyAttribute(cellClone, attributeVary(cell, $('.interestTr').length));
			}

			$('.interestTr').each(function (i) {
				if (i > 0) {
					let num = i + 1;
					$(this).find('td').eq(2).html('이자 비용(' + String.fromCharCode(num + 64) + ')');
					$(this).find('td').eq(0).html('차임금 상환(' + String.fromCharCode(num + 64) + ')');
				}
			});
		}
	}

	const pageInit = function () {
		let year = today.getFullYear();
		let month = today.getMonth() + 1;

		$('#year > button').html(year + '년<span class="caret"></span>').data('value', year);
		$('#month > button').html(month + '월<span class="caret"></span>').data('value', month);

		callAjax({
			url: 'http://iderms.enertalk.com:8443/spcs',
			type: 'get',
			data: {
				oid: oid
			}
		}, setSpc);

		rowAppend();
	}

	const callAjax = function (option, callBack, param) {
		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if (typeof callBack == 'function') {
				if(param != undefined) {
					callBack.call(this, data, param);
				} else {
					callBack.call(this, data);
				}
			} else if (typeof callBack == 'string') {
				eval(callBack + '("' + param + '")');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	const setSpc = function (data) {
		let spcList = data.data;
		let html = '';

		for (let i in spcList) {
			let temp = spcList[i];
			html += '<li data-value="' + temp.spc_id + '"><a href="javascript:void(0);">' + temp.name + '</a></li>';
		}

		$('#spc ul').empty().append(html);
	}

	const setSpcGen = function (data) {
		let siteList = data.data[0].spcGens;
		let html = '';

		$('#spcGen button').html('선택 <span class="caret"></span>').data('value', ''); //초기화

		for (let i in siteList) {
			let temp = siteList[i];
			html += '<li data-value="' + temp.gen_id + '"><a href="javascript:void(0);">' + temp.name + '</a></li>';
		}

		$('#spcGen ul').empty().append(html);
	}
	//두기간 사이 차이 구하기.
	const getDiff = function (eDate, sDate) {
		if (eDate != null && sDate != null) {
			if (eDate.format('yyyyMMdd').substring(0, 4) == sDate.format('yyyyMMdd').substring(0, 4)) {
				return (eDate.format('yyyyMMdd').substring(4, 6) * 1 - sDate.format('yyyyMMdd').substring(4, 6) * 1) + 1;
			} else {
				return Math.round((eDate - sDate) / (1000 * 60 * 60 * 24 * 365 / 12));
			}
		}
	}

	const setSitesNowMoney = function (data) {
		let siteList = data.data;

		$.each(siteList, function (i, el) {
			$('#siteBilling').val(numberComma(el.money));
			balanceSum();
		});
	}

	const setSitesMoney = function (data) {
		let generation = data.data[0].generation.items;
		if (generation.length > 0) {
			$('#siteBilling').val(numberComma(generation[0].money));
			balanceSum();
		} else {
			$('#siteBilling').val('');
			balanceSum();
		}
	}

	//목록
	const list = function () {
		location.href = '/spc/balanceSheet.do';
	}

	//등록
	const register = function (param) {
		let standard = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2);
		let rtnArray = new Array();
		let rtnObj = new Object();
		let option = {};
		let nextParam = '';
		let emptyValue = false;

		if (param == 'interest') {
			nextParam = 'service_charge';
		} else if (param == 'service_charge') {
			nextParam = 'rent';
		} else if (param == 'rent') {
			nextParam = 'balance';
		} else if (param == 'balance') {
			nextParam = 'last';
		} else if (param == 'last') {
			nextParam = '';
		}

		if (param == 'interest' || param == 'service_charge' || param == 'rent') {
			$('#' + param + 'Table tbody tr').each(function () {
				let temp = new Object();
				if ($(this).find('input[type="radio"]:checked').length > 0) {
					temp[$(this).find('input[type="radio"]:checked').prop('name')] = $(this).find('input[type="radio"]:checked').val();
				}
				$(this).find('input[type="text"]').each(function () {
					if ($(this).val() == '' && $(this).prop('readonly') == false) {
						emptyValue = true;
					}
					temp[$(this).prop('name')] = $(this).val();
				});

				rtnArray.push(temp);
			});

			//항목이 미완성이면 굳이 저장하지 않는다.
			if (emptyValue == true) {
				register(nextParam);
				return false;
			}

			let methodType = 'post';
			let queryId = '';
			let data = new Object();
			data.site_id = $('#spcGen button').data('value');
			data.repeat_type = param;
			data.repeat_info = JSON.stringify(rtnArray);
			data.updated_by = loginId;
			if (repeat_type_method == 'patch' && repeatCoastNumber[param] != undefined) {
				queryId = '&id=' + repeatCoastNumber[param];
				methodType = repeat_type_method;
			}

			option = {
				url: 'http://iderms.enertalk.com:8443/spcs/' + $('#spc button').data('value') + '/balance/repeat_cost?oid=' + oid + queryId,
				type: methodType,
				dataType: 'json',
				contentType: "application/json",
				traditional: true,
				data: JSON.stringify(data)
			}
		} else if (param == 'balance') {
			$('#balanceTable input[type="text"]').each(function () {
				if ($(this).val() == '') {
					emptyValue = true;
				}
				rtnObj[$(this).prop('name')] = $(this).val();
			});

			//항목이 미완성이면 오류.
			if (emptyValue == true) {
				alert('월별 원가관리 항목에 빈값이 존재합니다.');
				return false;
			}

			//첨부파일
			$('#balanceTable input[type="hidden"]').each(function () {
				rtnObj[$(this).prop('name')] = $(this).val().replace(/[^0-9.]/g, '');
			});

			let data = new Object();
			data.balance_info = JSON.stringify(rtnObj);
			data.updated_by = loginId;

			option = {
				url: 'http://iderms.enertalk.com:8443/spcs/' + $('#spc button').data('value') + '/balance/month?oid=' + oid + '&site_id=' + $('#spcGen button').data('value') + '&yyyymm=' + standard,
				type: 'post',
				dataType: 'json',
				contentType: "application/json",
				traditional: true,
				data: JSON.stringify(data)
			};
		} else {
			checkAfterSave();
			return false;
		}

		callAjax(option, 'register', nextParam);
	}

	const checkAfterSave = function () {
		let option = {
			url: 'http://iderms.enertalk.com:8443/spcs/' + $('#spc button').data('value') + '/balance/year?oid=' + oid + '&site_id=' + $('#spcGen button').data('value') + '&yyyy=' + $('#year button').data('value'),
			type: 'get',
			dataType: 'json',
			contentType: "application/json",
			traditional: true
		};

		callAjax(option, checkAfterSaveCallBack);
	}

	const checkAfterSaveCallBack = function (data) {
		if (data.data.length > 0) {
			alert('저장이 완료 되었습니다.');
			list();
			return false;
		} else {
			let aJaxdata = new Object();
			aJaxdata.start_yyyymm = standard;
			aJaxdata.cash_in = Number($('#inflowOfCash').val().replace(/[^0-9.]/g, ''));
			aJaxdata.cash_out = Number($('#outflowOfCash').val().replace(/[^0-9.]/g, ''));
			aJaxdata.balance = Number($('#endOfTerm').val().replace(/[^0-9.]/g, ''));
			aJaxdata.updated_by = loginId

			let option = {
				url: 'http://iderms.enertalk.com:8443/spcs/' + $('#spc button').data('value') + '/balance/year?oid=' + oid + '&site_id=' + $('#spcGen button').data('value') + '&yyyy=' + $('#year button').data('value'),
				type: 'post',
				dataType: 'json',
				contentType: "application/json",
				traditional: true,
				data: JSON.stringify(aJaxdata)
			};

			callAjax(option, saveAfter);
		}
	}

	const saveAfter = function () {
		alert('저장이 완료 되었습니다.');
		list();
		return false;
	}

	const CalculateUtil = {
		/*
		 *	이자 계산
		*/
		getIza: function (loan_type, i, loan, loan_gumri, payBalance) {	//이자
			var iza_amt = 0
			if (loan_type == "1") {					//원금만기일시상환
				//$I$8*$J$26/12
				iza_amt = loan * loan_gumri / 12;
			} else if (loan_type == "2") {				//원금균등상환
				if (i == 0) {
					//$I$8*$J$26/12
					iza_amt = loan * loan_gumri / 12;
				} else {
					//N28*$J$26/12
					iza_amt = payBalance * loan_gumri / 12;
				}
			} else if (loan_type == "3") {				//원리금균등상환
				if (i == 0) {
					//$I$8*$J$26/12
					iza_amt = loan * loan_gumri / 12;
				} else {
					//N28*$J$26/12
					iza_amt = payBalance * loan_gumri / 12;
				}
			}
			return iza_amt;
		},
		/*
		 *	납입원금 계산
		*/
		getOrgLoan: function (loan_type, i, loan_period, loan, loan_term, repayment, iza) {
			var org_loan = 0;
			if (loan_type == "1") {					//원금만기일시상환
				if (i == (loan_period - 1)) {	//마지막라인인경우
					org_loan = loan;
				}
			} else if (loan_type == "2") {				//원금균등상환
				//$I$8/($I$11-$I$14)
				org_loan = loan / (loan_period - loan_term);
			} else if (loan_type == "3") {				//원리금균등상환
				org_loan = repayment - iza;
			}
			return org_loan;
		},
		/*
		 *	상환금 계산
		*/
		getRepayment: function (loan_type, org_loan, iza, loan_gumri, loan_period, loan_term, loan, i) {
			var repayment = 0;
			if (loan_type == "1") {					//원금만기일시상환
				repayment = org_loan + iza;
			} else if (loan_type == "2") {				//원금균등상환
				repayment = org_loan + iza;
			} else if (loan_type == "3") {				//원리금균등상환
				if (i >= loan_term) {	//거치기간 후부터 계산
					repayment = (loan * loan_gumri / 12) * (Math.pow((1 + loan_gumri / 12), (loan_period - loan_term)));
					repayment = repayment / (Math.pow((1 + loan_gumri / 12), (loan_period - loan_term)) - 1);
				} else {
					repayment = org_loan + iza;
				}
			}
			return repayment;
		}
	};

	const setRepestCost = function (data) {
		let dataList = data.data;

		$('#interestTable tbody tr:not(:eq(0))').remove();
		$('#rentTable tbody tr:not(:eq(0))').remove();
		$('tr.interestTr:not(:eq(0))').remove();
		$('#interestTable input, #rentTable input, #service_chargeTable input').each(function() {
			if($(this).prop('type') == 'text') {
				$(this).val('');
			} else if($(this).prop('type') == 'radio') {
				$(this).prop('checked', false);
			}
		});

		if (dataList.length > 0) {
			$.each(dataList, function (k, v) {
				let repeatType = v.repeat_type, num = JSON.parse(v.repeat_info).length;
				repeatCoastNumber[repeatType] = v.id;
				if (repeatType != 'service_charge') {

					for (let i = 1; i < num; i++) {
						addRowTable(repeatType + 'Table');
					}
				}

				setJsonAutoMapping(JSON.parse(v.repeat_info), repeatType + 'Table');
			});

			repeat_type_method = 'patch';
			setAutoComplete();
		} else {
			repeat_type_method = 'post';
		}
	}

	const setAutoComplete = function () {

		$('#interestTable tbody tr').each(function (index) {
			let loan = $(this).find('[name^="principal_"]').val().replace(/[^0-9.-]/g, '');
			let payBalance = loan; //잔금
			let loan_gumri = $(this).find('[name^="interestRate_"]').val().replace(/[^0-9.-]/g, '') //금리
			let loan_type = $(this).find(':radio[name^="repayType"]:checked').val();//대출유형
			let loan_period = $(this).find('[name^="period_"]').val(); //기간
			let loan_term = 0;
			let total_iza = 0;		//총이자
			let iza = 0;	        //이자
			let org_loan = 0;	    //납입원금
			let repayment = 0;	    //상환금
			let org_loan_tot = 0;	//납입원금 누계
			let standard = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2);

			if (loan_type != undefined && loan != '' && loan_period != '' && loan_gumri != '') {
				loan_gumri = loan_gumri / 100;
				for (let i = 0; i < loan_period; i++) {
					let startDate = $(this).find('.fromDate').datepicker('getDate');
					let loanDate = new Date(startDate.getFullYear(), startDate.getMonth() + i, startDate.getDate());
					iza = CalculateUtil.getIza(loan_type, i, loan, loan_gumri, payBalance);
					total_iza += iza;

					if (loan_type == '3') {
						repayment = CalculateUtil.getRepayment(loan_type, org_loan, iza, loan_gumri, loan_period, loan_term, loan, i);
						if (i >= loan_term) {	//거치기간 후부터 계산
							org_loan = CalculateUtil.getOrgLoan(loan_type, i, loan_period, loan, loan_term, repayment, iza);
						}
					} else {
						if (i >= loan_term) {	//거치기간 후부터 계산
							org_loan = CalculateUtil.getOrgLoan(loan_type, i, loan_period, loan, loan_term, repayment, iza);
						}
						repayment = CalculateUtil.getRepayment(loan_type, org_loan, iza, loan_gumri, loan_period, loan_term, loan, i);
					}
					org_loan_tot = org_loan_tot + org_loan;
					payBalance = loan - org_loan_tot;

					if (loanDate.format('yyyyMM') == standard) {
						$('[name^="loan"]').eq(index).val(numberComma(Math.round(org_loan)));
						$('[name^="interestCost"]').eq(index).val(Math.round(iza));
					}
				}
			}
		});

		$('#service_chargeTable tbody tr').each(function (index) {

			if ($(this).find('[name^="contract_"]:checked').val() == '1') {
				let grossPerMonth = $(this).find('[name^="grossPerMonth_"]').prop('readonly', false).val().replace(/[^0-9.-]/g, '');

				if (grossPerMonth != '' && grossPerMonth > 0) {
					let surtax = Math.round(grossPerMonth * 0.1);
					let supplySum = Math.round(grossPerMonth * 1.1);

					$(this).find('[name^="grossPerMonth_"]').val(numberComma(grossPerMonth));
					$(this).find('[name^="grossPerMonthSurtax_"]').val(numberComma(surtax));
					$(this).find('[name^="grossPerMonthSumtax_"]').val(numberComma(supplySum));

					if (index == 0) {
						$('[name^="conversionCharge"]').eq(0).val(numberComma(supplySum));
					} else {
						$('[name^="managementCharge"]').eq(0).val(numberComma(supplySum));
					}

				} else {
					$(this).find('[name^="grossPerMonthSurtax_"]').val('');
					$(this).find('[name^="grossPerMonthSumtax_"]').val('');

					if (index == 0) {
						$('[name^="conversionCharge"]').eq(0).val('');
					} else {
						$('[name^="managementCharge"]').eq(0).val('');
					}
				}
			} else if ($(this).find('[name^="contract_"]:checked').val() == '2') {
				let salesRate = $(this).find('[name^="salesRate_"]').val().replace(/[^0-9.-]/g, '')
				let salesSupply = $(this).find('[name^="salesSupply_"]').val().replace(/[^0-9.-]/g, '')

				if (salesRate != '' && salesSupply != '' && salesSupply > 0) {
					let surtax = Math.round((salesSupply * salesRate) * 0.1);
					let supplySum = Math.round((salesSupply * salesRate) * 1.1);
					$(this).find('[name^="salesSupply_"]').val(numberComma(salesSupply));
					$(this).find('[name^="salesSupplySurtax_"]').val(numberComma(surtax));
					$(this).find('[name^="salesSupplySumtax_"]').val(numberComma(supplySum));

					if (index == 0) {
						$('[name^="conversionCharge"]').eq(0).val(numberComma(supplySum));
					} else {
						$('[name^="managementCharge"]').eq(0).val(numberComma(supplySum));
					}
				} else {
					$(this).find('[name^="salesSupplySurtax_"]').val('');
					$(this).find('[name^="salesSupplySumtax_"]').val('');

					if (index == 0) {
						$('[name^="conversionCharge"]').eq(0).val('');
					} else {
						$('[name^="managementCharge"]').eq(0).val('');
					}
				}
			}
		});


		$('#rentTable tbody tr').each(function (index) {
			let thisVal = $(this).find('[name^="supply_"]').val().replace(/[^0-9.-]/g, '');

			if (thisVal != '' && thisVal > 0) {
				let surtax = Math.round(thisVal * 0.1);
				let supplySum = Math.round(thisVal * 1.1);

				$(this).find('[name^="supply_"]').val(numberComma(thisVal));
				$(this).find('[name^="surtax_"]').val(numberComma(surtax));
				$(this).find('[name^="supplySum_"]').val(numberComma(supplySum));
			}

			let sum = 0;
			$('[name^="supplySum_"]').each(function () {
				sum += Number($(this).val().replace(/[^0-9.]/g, ''));
			});

			if (sum > 0) {
				$('#rental').val(numberComma(Math.round(sum)));
			} else {
				$('#rental').val('');
			}
		});
		balanceSum();
	}

	const setUploadAfter = function(data, propName) {
		if(data.files.length > 0) {
			let prop = $('#'+propName);
			prop.parents('tr').find('label').hide();
			prop.parents('tr').find('.btn_clse').show();


			let linkUrl = 'http://iderms.enertalk.com:8443/files/download/'+data.files[0].fieldname+'?oid='+oid + '&orgFilename' + data.files[0].originalname;
			let linkTag = $('<a>').prop('href', linkUrl).html(data.files[0].originalname);
			let pTag = $('<p>').addClass('tx_file').append(linkTag);
			let inpOgin = $('<input>').prop('type', 'hidden').prop('id', propName + '_originalname').prop('name', propName + '_originalname').val(data.files[0].originalname);
			let inpField = $('<input>').prop('type', 'hidden').prop('id', propName + '_fieldname').prop('name', propName + '_fieldname').val(data.files[0].fieldname);
			prop.parent().append(pTag).append(inpOgin).append(inpField);
		}
	}

	const setDefaultFile = function(obj) {
		let tr = obj.parents('tr.th_span');
		tr.find('p.tx_file').remove();
		tr.find('label').show();
		tr.find('button.btn_clse').hide();

		tr.find('input[name$="_originalname"]').val('');
		tr.find('input[name$="_fieldname"]').val('');
	}

	const selAbleMonth = function() {
		let sid = $('#spcGen button').data('value');
		if (sid == undefined || sid == '') {
			return;
		}

		callAjax({
			url: 'http://iderms.enertalk.com:8443/spcs/' + $('#spc button').data('value') + '/balance/month',
			type: 'get',
			data: {
				oid: oid,
				site_id: sid,
				yyyymm: $('#year button').data('value') + '__'
			}
		}, setAbleMonth);
	}

	const setAbleMonth = function(data) {

		$('#month li').removeClass('disabled');

		data.data.forEach(function(val) {
			let month = val.balance_yyyymm.slice(-2);

			$('#month li').each(function() {
				if($(this).data('value') == month) {
					$(this).addClass('disabled');
				}
			});
		});

		if($('#month li:not(.disabled)').length > 0) {
			let buttonText = $('#month li:not(.disabled):eq(0)').text() + ' <span class="caret"></span>';
			let buttonData = $('#month li:not(.disabled):eq(0)').data('value');
			$('#month button').html(buttonText).data('value', buttonData);

			payment();
		} else {
			$('#month button').html('선택 <span class="caret"></span>').data('value', '');
		}
	}

	const payment = function() {
		let sid = $('#spcGen button').data('value');
		if (sid == undefined || sid == '') {
			return;
		}

		let standard = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2);
		let todayYYYMM = today.format('yyyyMM');
		if (standard == todayYYYMM) { //요번달이면 now 조회
			callAjax({
				url: 'http://iderms.enertalk.com:8443/energy/now/sites',
				type: 'get',
				data: {
					sids: sid,
					metering_type: ' ',
					interval: 'month'
				}
			}, setSitesNowMoney);
		} else {
			callAjax({
				url: 'http://iderms.enertalk.com:8443/energy/sites',
				type: 'get',
				data: {
					sid: sid,
					startTime: standard + '01000000',
					endTime: standard + '31000000',
					interval: 'month',
					displayType: 'billing'
				}
			}, setSitesMoney);
		}
	}
</script>
<!-- 파일 업로드 폼 -->
<form id="upload" name="upload" method="multipart/form-data">
</form>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">원가관리 등록</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv bal_edit bal_post">
			<div class="spc_st_top">
				<div class="spc_bal_post">
					<table>
						<colgroup>
							<col style="width:50%">
							<col style="width:50%">
						</colgroup>
						<thead>
						<tr>
							<th>SPC 명</th>
							<th>발전소 명</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="spc">
										<button class="btn btn-primary dropdown-toggle" type="button"
										        data-toggle="dropdown">선택
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="spcGen">
										<button class="btn btn-primary dropdown-toggle" type="button"
										        data-toggle="dropdown">선택
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
										</ul>
									</div>
								</div>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="spc_bal_post">
					<table id="interestTable">
						<colgroup>
							<col style="width:48px">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col>
						</colgroup>
						<thead>
						<tr>
							<th rowspan="2"></th>
							<th rowspan="2">차입금 / 이자</th>
							<th rowspan="2">원금(원)</th>
							<th colspan="3">기간</th>
							<th colspan="3">상환방식</th>
							<th>이자(%)</th>
						</tr>
						<tr>
							<th class="border">시행일</th>
							<th>만기일</th>
							<th>대출기간 (m)</th>
							<th class="border">만기일시</th>
							<th>원금균등</th>
							<th>원리금균등</th>
							<th>이자율 (연)</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk01">
									<label for="chk01"><span></span></label>
								</div>
							</td>
							<td>A</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="principal_1" name="principal_1" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="enforce_1" name="enforce_1" class="sel fromDate" value=""
									       autocomplete="off"
									       readonly
									       placeholder="선택">
								</div>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="expiry_1" name="expiry_1" class="sel toDate" value=""
									       autocomplete="off"
									       readonly
									       placeholder="선택">
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="period_1" name="period_1" placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="rdo_type">
									<input type="radio" id="repayType01_1" name="repayType_1" value="1">
									<label for="repayType01_1"><span></span></label>
								</div>
							</td>
							<td>
								<div class="rdo_type">
									<input type="radio" id="repayType02_1" name="repayType_1" value="2">
									<label for="repayType02_1"><span></span></label>
								</div>
							</td>
							<td>
								<div class="rdo_type">
									<input type="radio" id="repayType03_1" name="repayType_1" value="3">
									<label for="repayType03_1"><span></span></label>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="interestRate_1" name="interestRate_1" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						</tbody>
					</table>
					<div class="btn_wrap_type">
						<a href="#;" class="btn_type07">선택 삭제</a>
						<a href="javascript:void(0);" class="btn_add"
						   onclick="addRowTable('interestTable'); return false;">추가</a>
					</div>
				</div>

				<div class="spc_bal_post">
					<table id="service_chargeTable">
						<colgroup>
							<col style="width:48px">
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
						</colgroup>
						<thead>
						<tr>
							<th rowspan="2"></th>
							<th rowspan="2">대리기관/<br>관리운영 수수료</th>
							<th rowspan="2">종류</th>
							<th colspan="2">계약방식</th>
							<th colspan="3">월정액</th>
							<th colspan="4">매출(수익)연동</th>
						</tr>
						<tr>
							<th class="border">월정액</th>
							<th>매출(수익)연동</th>
							<th class="border">공급가액(원)</th>
							<th>부가세</th>
							<th>합계</th>
							<th class="border">적용(%)</th>
							<th>공급가액(원)</th>
							<th>부가세</th>
							<th>합계</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk02">
									<label for="chk02"><span></span></label>
								</div>
							</td>
							<td>A</td>
							<td>
								<%--								<div class="sa_select">--%>
								<%--									<div class="dropdown" id="commission_1">--%>
								<%--										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">--%>
								<%--											선택<span class="caret"></span>--%>
								<%--										</button>--%>
								<%--										<ul class="dropdown-menu chk_type" role="menu">--%>
								<%--											<li><a href="javascript:void(0);">대리기관 수수료</a></li>--%>
								<%--											<li><a href="javascript:void(0);">관리운영 수수료</a></li>--%>
								<%--										</ul>--%>
								<%--									</div>--%>
								<%--								</div>--%>
								대리기관 수수료
							</td>
							<td>
								<div class="rdo_type">
									<input type="radio" id="chk_bal01_1" name="contract_1" value="1">
									<label for="chk_bal01_1"><span></span></label>
								</div>
							</td>
							<td>
								<div class="rdo_type">
									<input type="radio" id="chk_bal02_1" name="contract_1" value="2">
									<label for="chk_bal02_1"><span></span></label>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="grossPerMonth_1" name="grossPerMonth_1" placeholder="직접 입력"
									       readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="grossPerMonthSurtax_1" name="grossPerMonthSurtax_1"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="grossPerMonthSumtax_1" name="grossPerMonthSumtax_1"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesRate_1" name="salesRate_1" placeholder="직접 입력" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesSupply_1" name="salesSupply_1" placeholder="직접 입력"
									       readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesSupplySurtax_1" name="salesSupplySurtax_1"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesSupplySumtax_1" name="salesSupplySumtax_1"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk03">
									<label for="chk03"><span></span></label>
								</div>
							</td>
							<td>A</td>
							<td>
								<%--								<div class="sa_select">--%>
								<%--									<div class="dropdown" id="commission_2">--%>
								<%--										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">--%>
								<%--											선택<span class="caret"></span>--%>
								<%--										</button>--%>
								<%--										<ul class="dropdown-menu chk_type" role="menu">--%>
								<%--											<li><a href="javascript:void(0);">대리기관 수수료</a></li>--%>
								<%--											<li><a href="javascript:void(0);">관리운영 수수료</a></li>--%>
								<%--										</ul>--%>
								<%--									</div>--%>
								<%--								</div>--%>
								관리운영 수수료
							</td>
							<td>
								<div class="rdo_type">
									<input type="radio" id="chk_bal01_2" name="contract_2" value="1">
									<label for="chk_bal01_2"><span></span></label>
								</div>
							</td>
							<td>
								<div class="rdo_type">
									<input type="radio" id="chk_bal02_2" name="contract_2" value="2">
									<label for="chk_bal02_2"><span></span></label>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="grossPerMonth_2" name="grossPerMonth_2" placeholder="직접 입력"
									       readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="grossPerMonthSurtax_2" name="grossPerMonthSurtax_2"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="grossPerMonthSumtax_2" name="grossPerMonthSumtax_2"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesRate_2" name="salesRate_2" placeholder="직접 입력" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesSupply_2" name="salesSupply_2" placeholder="직접 입력"
									       readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesSupplySurtax_2" name="salesSupplySurtax_2"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="salesSupplySumtax_2" name="salesSupplySumtax_2"
									       placeholder="자동 계산" readonly>
								</div>
							</td>
						</tr>
						</tbody>
					</table>
					<%--					<div class="btn_wrap_type">--%>
					<%--						<a href="javascript:void(0);" class="btn_add" onclick="addRowTable('service_chargeTable'); return false;">추가</a>--%>
					<%--					</div>--%>
				</div>

				<div class="spc_bal_post">
					<table id="rentTable">
						<colgroup>
							<col style="width:48px">
							<col style="width:24%">
							<col style="width:24%">
							<col style="width:24%">
							<col>
						</colgroup>
						<thead>
						<tr>
							<th></th>
							<th>임대료</th>
							<th>공급가액</th>
							<th>부가세</th>
							<th>합계</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk04">
									<label for="chk04"><span></span></label>
								</div>
							</td>
							<td></td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="supply_1" name="supply_1" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="surtax_1" name="surtax_1" placeholder="자동 계산" readonly>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="supplySum_1" name="supplySum_1" placeholder="자동 계산" readonly>
								</div>
							</td>
						</tr>
						</tbody>
					</table>
					<div class="btn_wrap_type">
						<a href="#;" class="btn_type07">선택 삭제</a>
						<a href="javascript:void(0);" class="btn_add" onclick="addRowTable('rentTable'); return false;">추가</a>
					</div>
				</div>
			</div>
			<div class="clear">
				<div class="fl">
					<span class="tx_tit">기준</span>
					<div class="sa_select">
						<div class="dropdown" id="year">
							<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">
								2020년
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu">
								<li data-value="2020"><a href="javascript:void(0);">2020년</a></li>
								<li data-value="2019"><a href="javascript:void(0);">2019년</a></li>
								<li data-value="2018"><a href="javascript:void(0);">2018년</a></li>
							</ul>
						</div>
					</div>
					<div class="sa_select">
						<div class="dropdown" id="month">
							<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu" role="menu">
								<li data-value="1"><a class="dropdown-item" href="javascript:void(0);">1월</a></li>
								<li data-value="2"><a class="dropdown-item" href="javascript:void(0);">2월</a></li>
								<li data-value="3"><a class="dropdown-item" href="javascript:void(0);">3월</a></li>
								<li data-value="4"><a class="dropdown-item" href="javascript:void(0);">4월</a></li>
								<li data-value="5"><a class="dropdown-item" href="javascript:void(0);">5월</a></li>
								<li data-value="6"><a class="dropdown-item" href="javascript:void(0);">6월</a></li>
								<li data-value="7"><a class="dropdown-item" href="javascript:void(0);">7월</a></li>
								<li data-value="8"><a class="dropdown-item" href="javascript:void(0);">8월</a></li>
								<li data-value="9"><a class="dropdown-item" href="javascript:void(0);">9월</a></li>
								<li data-value="10"><a class="dropdown-item" href="javascript:void(0);">10월</a></li>
								<li data-value="11"><a class="dropdown-item" href="javascript:void(0);">11월</a></li>
								<li data-value="12"><a class="dropdown-item" href="javascript:void(0);">12월</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="fr">
					<p class="tx_type fl">단위:원</p>
					<div class="chk_type fl">
						<input type="checkbox" id="noteDown" name="noteDown" value="1">
						<label for="noteDown"><span></span>수기입력 활성화</label>
					</div>
				</div>
			</div>
			<div class="spc_tbl_row st_edit">
				<table id="balanceTable">
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>전력 판매 대금</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="siteBilling" name="siteBilling" value="" placeholder="자동 입력"
								       readonly>
							</div>
						</td>
						<th>REC 매매대금</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="siteMoney" name="siteMoney" value="" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr class="interestTr">
						<th>차임금 상환(A)</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="loan_1" name="loan_1" value="" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>이자 비용(A)</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="interestCost_1" name="interestCost_1" value=""
								       placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr class="service_chargeTr">
						<th>대리기관 수수료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="conversionCharge_1" name="conversionCharge_1" value=""
								       placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>관리 운영 수수료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="managementCharge_1" name="managementCharge_1" value=""
								       placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th>법인세</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="corporateTax" name="corporateTax" value="" placeholder="직접 입력">
							</div>
						</td>
						<th>부가세</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="additionalTax" name="additionalTax" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>임대료</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="rental" name="rental" placeholder="자동 계산" readonly>
							</div>
						</td>
						<th>기타 비용</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="expense" name="expense" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>현금 유입 합계</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="inflowOfCash" name="inflowOfCash" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>현금 유출 합계</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="outflowOfCash" name="outflowOfCash" placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th>기말 현금</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="endOfTerm" name="endOfTerm" placeholder="자동 입력" readonly>
							</div>
						</td>
						<th>기말 현금흐름</th>
						<td>
							<div class="tx_inp_type read">
								<input type="text" id="endOfTermFlow" name="endOfTermFlow" placeholder="자동 입력" readonly>
							</div>
						</td>
					</tr>
					<tr class="th_span">
						<th>손익 계산서 <label for="income" class="btn_add fr">추가</label></th>
						<td colspan="2">
							<input type="file" id="income" name="income" class="uploadBtn" style="display:none;">
						</td>
						<td><button class="btn_clse" style="display:none;">삭제</button></td>
					</tr>
					<tr class="th_span">
						<th>세무 조정 계산<label for="taxAdjustment" class="btn_add fr">추가</label></th>
						<td colspan="2">
							<input type="file" id="taxAdjustment" name="taxAdjustment" class="uploadBtn" style="display:none;">
						</td>
						<td><button class="btn_clse" style="display:none;">삭제</button></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="list();">목록</button>
				<button type="button" class="btn_type" onclick="register('interest');">등록</button>
			</div>
		</div>
	</div>
</div>