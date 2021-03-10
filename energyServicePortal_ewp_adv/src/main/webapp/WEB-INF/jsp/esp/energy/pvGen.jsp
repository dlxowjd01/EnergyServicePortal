<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header"><fmt:message key="pvGen.pageTitle" /></h1>
	</div>
</div>
<div class="row content-wrapper">
	<div class="col-lg-2 col-md-4 col-sm-6 dropdown-wrapper">
		<div class="dropdown" id="siteList">
			<button type="button" class="dropdown-toggle w-100 no-close" data-toggle="dropdown" data-name="<fmt:message key="renewablesgen.3.multipleselection" />"><fmt:message key="renewablesgen.1.select" /><span class="caret"></span></button>
			<ul class="dropdown-menu chk-type"></ul>
		</div>
		<small class="warning hidden"><fmt:message key="pvGen.siteSelectWarning" /></small>
	</div>
</div>
<div class="row">
	<div class="col-lg-2 col-md-4 col-sm-6 pvGen-right">
		<div class="indiv chart-pv scroll">
			<h2 class="ntit"><fmt:message key="pvGen.summary" /></h2>
			<div class="value-wrapper"></div>
			<h2 class="ntit hidden"><fmt:message key="pvGen.hoursummary" /></h2>
			<div class="value-wrapper hidden"></div>
			<h2 class="ntit hidden"><fmt:message key="pvGen.insolationsummary" /></h2>
			<div class="value-wrapper hidden"></div>
		</div>
	</div>
	<div class="col-lg-10 col-md-8 col-sm-6">
		<div class="indiv chart-pv">
			<div class="flex-wrapper pvGen-filter">
				<div class="chart-top">
					<div id="deviceType" class="flex-group">
						<span class="tx-tit"><fmt:message key="renewablesgen.3.measureddata" /></span>
						<div class="sa-select">
							<div class="dropdown">
								<button type="button" class="dropdown-toggle w7 no-close" data-toggle="dropdown" data-name="<fmt:message key="renewablesgen.3.multipleselection" />"><fmt:message key="renewablesgen.3.multipleselection" /><span class="caret"></span></button>
								<div class="dropdown-menu chk-type"><!--
								--><ul class="dropdown-cov clear selectDevices"></ul><!--
								 --><div class="li-btn-box clear">
										<div class="fl"><!--
										--><button type="button" class="btn-type03"><fmt:message key="pvGen.graph.mensuration.selectAll" /></button><!--
										--><button type="button" class="btn-type03"><fmt:message key="pvGen.graph.mensuration.deselectAll" /></button><!--
									--></div>
										<div class="fr"><button type="button" class="btn-type"><fmt:message key="pvGen.graph.mensuration.apply" /></button></div>
									</div>
								</div>
							</div>
							<small class="warning hidden"><fmt:message key="pvGen.graph.mensuration.warn" /></small>
						</div>
					</div>
					<div class="flex-group period">
						<span class="tx-tit"><fmt:message key="pvGen.graph.date" /></span>
						<div class="sa-select">
							<div class="dropdown" id="period">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="renewablesgen.3.today" />"><fmt:message key="renewablesgen.3.today" /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="today" class="on"><a href="#"><fmt:message key="renewablesgen.3.today" /></a></li>
									<li data-value="week"><a href="#"><fmt:message key="renewablesgen.3.thisweek" /></a></li>
									<li data-value="month"><a href="#"><fmt:message key="renewablesgen.3.thismonth" /></a></li>
									<li data-value="setup"><a href="#"><fmt:message key="pvGen.graph.date.select" /></a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="flex-group duration" id="dateArea">
						<span class="tx-tit"><fmt:message key="pvGen.graph.date.input" /></span>
						<div class="sel-calendar dateField">
							<label for="fromDate" class="sr-only"><fmt:message key="pvGen.graph.date.start" /></label>
							<input type="text" id="fromDate" class="sel fromDate" value="" autocomplete="off" readonly>
							<em></em>
							<label for="toDate" class="sr-only"><fmt:message key="pvGen.graph.date.end" /></label>
							<input type="text" id="toDate" class="sel toDate" value="" autocomplete="off" readonly>
						</div>
					</div>
					<div class="flex-group unit" id="cycle">
						<span class="tx-tit"><fmt:message key="pvGen.graph.unit" /></span>
						<div class="sa-select">
							<div class="dropdown" id="interval">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key="pvGen.graph.unit.select" />">
									<fmt:message key="pvGen.graph.unit.select" /> <span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li data-value="5min"><a href="#"><fmt:message key="renewablesgen.3.5min" /></a></li>
									<li data-value="15min"><a href="#"><fmt:message key="renewablesgen.3.15min" /></a></li>
									<li data-value="hour"><a href="#"><fmt:message key="renewablesgen.3.1hr" /></a></li>
									<li data-value="day"><a href="#"><fmt:message key="renewablesgen.3.1day" /></a></li>
									<li data-value="month"><a href="#"><fmt:message key="renewablesgen.3.1month" /></a></li>
								</ul>
							</div>
							<small class="warning hidden"><fmt:message key="pvGen.graph.unit.warn" /></small>
						</div>
					</div>
					<button type="button" class="btn-type" id="renderBtn"><fmt:message key="renewablesgen.3.update" /></button>
				</div>
				<div class="end"><!--
				--><span class="tx-tit"><fmt:message key="pvGen.graph.style" /></span><!--
				--><div class="sa-select">
						<div class="dropdown" id="chartStyle"><!--
							--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="each"><fmt:message key="renewablesgen.3.individualbar" /><span class="caret"></span></button><!--
						--><ul class="dropdown-menu"><!--
							--><li data-value="allSum"><a href="#"><fmt:message key="renewablesgen.3.sumtotal" /></a></li><!--
							--><li data-value="siteSum"><a href="#"><fmt:message key="renewablesgen.3.sumplant" /></a></li><!--
							--><li data-value="each" class="on"><a href="#"><fmt:message key="renewablesgen.3.individualbar" /></a></li><!--
						--></ul>
						</div>
					</div><!--
				--><div class="sa-select hidden">
						<div class="dropdown" id="chartStyle2"><!--
						--><button type="button" class="dropdown-toggle" data-toggle="dropdown" data-value="dayBy">
								<fmt:message key="pvGen.graph.style.dayBy" /><span class="caret"></span>
							</button><!--
						--><ul class="dropdown-menu"><!--
							--><li data-value="dayBy"><a href="#"><fmt:message key="pvGen.graph.style.dayBy" /></a></li><!--
							--><li data-value="overlap"><a href="#"><fmt:message key="pvGen.graph.style.overlap" /></a></li><!--
						--></ul>
						</div>
					</div>
				</div>
			</div>

			<div class="clear hidden">
				<h4 class="text-time"></h4>
				<div id="chart2" class="inchart"></div>
			</div>
		</div>
	</div>
</div>

<div id="pvTable" class="row chart-pv-table hidden">
	<div class="col-12">
		<div class="indiv chart-pv table-box">
			<div class="table-save-box"><a href="#;" class="btn-save"><fmt:message key="renewablesgen.4.dataextracts" /></a></div>
			<div class="table-top clear">
				<h2 class="ntit fl"><fmt:message key="renewablesgen.4.powergenerationchart" /></h2>
				<span class="fr"><a href="#;" class="btn-fold"><fmt:message key="pvGen.table.fold" /></a></span>
			</div>
			<div class="table-wrapper">
				<div class="fold-box">
					<div class="chart-table" id="table-desktop">
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	const sidparam = "${param.sid}";
	const sites = JSON.parse('${siteList}');
	const dashStandard = '${param.target}';
	const dashInterval = '${param.interval}';
	let generationData = new Object()
	  , summaryData = new Object()
	  , standard = new Array()
	  , interval = ''
	  , statusSummary = new Array();

	$(function() {
		makeSiteList();

		//전체 선택/전체 해제
		$('#deviceType button.btn-type03').on('click', function (e) {
			let idx = $('#deviceType button.btn-type03').index($(this));
			if (idx == 0) {
				$(':checkbox[name="device"]').prop('checked', true);

				document.querySelectorAll('#interval li').forEach(li => {
					if (li.dataset.value === 'day' || li.dataset.value === 'month') {
						li.classList.remove('disabled');
					} else {
						li.classList.add('disabled');
					}
				});
			} else {
				$(':checkbox[name="device"]').prop('checked', false);
				document.querySelectorAll('#interval li').forEach(li => {
					li.classList.add('disabled');
				});
			}

			displayDropdown($('#deviceType'));
		});

		$('#renderBtn').on('click', function () {
			searchGenData();
		});

		$('.btn-save').on('click', function (e) {
			let excelName = '발전이력';
			let $val = $('#table-desktop').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('<fmt:message key="pvGen.alert.1" />');
			} else {
				if (confirm('<fmt:message key="pvGen.confirm.1" />')) {
					tableToExcel('table-desktop', excelName, e);
				}
			}
		});

		$('#fromDate').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본

		if (sidparam) {
			$("#interval > ul > li:nth-child(3) > a").click();
			setTimeout(searchGenData, 500)
		}
	});

	//사업소 호출
	const makeSiteList = async (searchData = []) => {
		const siteList = document.querySelector('#siteList ul');
		while (siteList.firstChild) siteList.removeChild(siteList.firstChild);
		let liStr = ``;

		const list = searchData.length ? searchData : sites

		if (!isEmpty(list)) {
			liStr += `<li>
						<a href="javascript:void(0);" data-value="all" tabindex="-1">
							<input type="checkbox" id="all" value="all" name="site">
							<label for="all"><fmt:message key='pvGen.all' /></label>
						</a>
					</li>`;
			liStr += `<li class="btn-wrap-border-min"></li>`;
			list.forEach((site, index) => {
				liStr += `<li>
							<a href="javascript:void(0);" data-value="${'${site.sid}'}" tabindex="-1">
								<input type="checkbox" id="${'${site.sid}'}" value="${'${site.sid}'}" name="site">
								<label for="${'${site.sid}'}">${'${site.name}'}</label>
							</a>
						</li>`;
			});

			liStr += `<li class="btn-wrap-type03 btn-wrap-border dropdown-apply"><button type="button" class="btn-type mr-16"><fmt:message key="pvGen.apply" /></button></li>`;
			siteList.innerHTML = liStr;
		} else {
			siteList.innerHTML = `<li class="no-data"><fmt:message key='pvGen.cannotSelectSite' /></li>`;
		}

		if (!$(".dropdown-search").length) {
			$("#siteList")
				.prepend(`<div class="dropdown-search"><input type="text" placeholder="<fmt:message key="dropdown.siteSearch" />" onKeyup="searchSite($(this).val())" ></div>`)
				.append(`<div class="btn-wrap-type03 btn-wrap-border dropdown-apply"><button type="button" class="btn-type mr-16"><fmt:message key="deviceState.apply" /></button></div>`);

			if (sidparam) {
				$("#siteList ul li a[data-value="+sidparam+"] > label").click();
			}
		}

		if (!isEmpty(dashStandard) && !isEmpty(dashInterval)) {
			$(':checkbox[name="site"]').prop('checked', true);
			displayDropdown($('#siteList'));
			makeDeviceList();
		}
	};

	const searchSite = keyword => {
		const result = sites.filter(x => x.name.includes(keyword));
		makeSiteList(result);
	}

	const makeDeviceList = () => {
		let selectedSite = new Array();
		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => {
				if (check.value !== 'all') {
					selectedSite.push(check.value);
				}
			});
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				selectedSite.push(checked.value);
			});
		}

		document.querySelector('#deviceType button').innerHTML = '<fmt:message key="operHistory.multiple" /> <span class="caret"></span>';
		document.querySelector('#deviceType .selectDevices').innerHTML = '';

		if (!isEmpty(selectedSite)) {
			let deviceUrl = new Array();
			selectedSite.forEach(sid => {
				deviceUrl.push($.ajax({
					url: apiHost + '/config/devices/',
					type: 'GET',
					data: {
						oid: oid,
						sid: sid
					}
				}));
			});

			Promise.all(deviceUrl).then(response => {
				const deviceList = document.querySelector('#deviceType .selectDevices');

				let liStr = ``;
				response.forEach(devices => {
					let deviceStr = ``;
					if (!isEmpty(devices)) {
						let targetSite = sites.find(site => site['sid'] !== undefined && site['sid'] === devices[0]['sid']);
						let sensorSolar = devices.find(device => device['device_type'] === 'SENSOR_SOLAR');
						let solarDid = isEmpty(sensorSolar) ? '' : sensorSolar.did;

						deviceStr +=
							`   <li>
									<a href="javascript:void(0);" tabindex="-1">
										<input id="device_dashboard_${'${targetSite[\'sid\']}'}" name="device" type="checkbox" value="${'${targetSite[\'sid\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-sitename="${'${targetSite[\'name\']}'}" data-name="${'${targetSite[\'name\']}'}_<fmt:message key='pvGen.dashboard' />" data-type="dashboard">
										<label for="${'${targetSite[\'sid\']}'}"><span></span><fmt:message key='pvGen.dashboard' /></label>
									</a>
								</li>
							`;

						deviceStr +=
							`   <li>
									<a href="javascript:void(0);" tabindex="-1">
										<input id="device_billing_${'${targetSite[\'sid\']}'}" name="device" type="checkbox" value="${'${targetSite[\'sid\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-sitename="${'${targetSite[\'name\']}'}" data-name="${'${targetSite[\'name\']}'}_<fmt:message key='pvGen.sales' />" data-type="billing">
										<label for="${'${targetSite[\'sid\']}'}"><span></span><fmt:message key='pvGen.sales' /></label>
									</a>
								</li>
							`;

						deviceStr +=
							`   <li>
									<a href="javascript:void(0);" tabindex="-1">
										<input id="device_time_${'${targetSite[\'sid\']}'}" name="device" type="checkbox" value="${'${targetSite[\'sid\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-sitename="${'${targetSite[\'name\']}'}" data-name="${'${targetSite[\'name\']}'}_<fmt:message key='pvGen.devTime' />" data-type="time">
										<label for="${'${targetSite[\'sid\']}'}"><span></span><fmt:message key='pvGen.devTime' /></label>
									</a>
								</li>
							`;

						if (!isEmpty(sensorSolar)) {
							deviceStr +=
								`   <li>
									<a href="javascript:void(0);" tabindex="-1">
										<input id="${'${sensorSolar[\'did\']}'}" name="device" type="checkbox" value="${'${sensorSolar[\'did\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-sitename="${'${targetSite[\'name\']}'}" data-name="${'${targetSite[\'name\']}'}_${'${sensorSolar[\'name\']}'}" data-type="${'${sensorSolar[\'device_type\']}'}">
										<label for="${'${sensorSolar[\'did\']}'}"><span></span>${'${sensorSolar[\'name\']}'}</label>
									</a>
								</li>
							`;
						}

						deviceStr += `<li class="btn-wrap-border-min"></li>`;
						devices.sort((a, b) => {
							return a['name'] > b['name'] ? 1 : a['name'] < b['name'] ? -1 : 0;
						});
						devices.forEach(device => {
							if (((device.dashboard || device.billing) && device.metering_type === 2)) {
								deviceStr +=
									`   <li>
											<a href="javascript:void(0);" tabindex="-1">
												<input id="${'${device[\'did\']}'}" name="device" type="checkbox" value="${'${device[\'did\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-sitename="${'${targetSite[\'name\']}'}" data-name="${'${targetSite[\'name\']}'}_${'${device[\'name\']}'}" data-type="${'${device[\'device_type\']}'}">
												<label for="${'${device[\'did\']}'}"><span></span>${'${device[\'name\']}'}</label>
											</a>
										</li>
									`;
							}
						});

						liStr +=
							`   <li class="sec-li-box">
									<p class="tx-li-title">${'${targetSite[\'name\']}'}</p>
									<ul>${'${deviceStr}'}</ul>
								</li>
							`;
					}
				});

				deviceList.innerHTML = liStr;

				if (sidparam) {
					$("#deviceType > div > div > div > div > div.fl > button:nth-child(1)").click();
				}

				if (!isEmpty(dashStandard) && !isEmpty(dashInterval)) {
					$(':checkbox[name="device"]').each(function() {
						if(/dashboard/.test($(this).attr('id'))) {
							$(this).prop('checked', true);
						}
					});



					displayDropdown($('#deviceType'));
					if (dashInterval === 'hour') {
						$('#fromDate').val(dashStandard.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3'));
						$('#toDate').val(dashStandard.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3'));
						$('#interval button').data('value', 'hour').html('<fmt:message key="renewablesgen.3.1hr" />' + '<span class="caret"></sapn>');
					} else {
						const lastDay = new Date(dashStandard.substr(0, 4), dashStandard.substr(4), 0);
						$('#fromDate').val(dashStandard.replace(/(\d{4})(\d{2})/, '$1-$2') + '-01');
						$('#toDate').val(dashStandard.replace(/(\d{4})(\d{2})/, '$1-$2') + '-' + lastDay.getDate());
						$('#interval button').data('value', 'day').html('<fmt:message key="renewablesgen.3.1day" />' + '<span class="caret"></sapn>');
					}

					$('#chartStyle button').data('value', 'allSum').html('<fmt:message key="renewablesgen.3.sumtotal" /></a></li> <span class="caret"></span>');
					searchGenData();
				}
			}).catch(error => {
				console.error(error);
				errorMsg(error);
			});
		}
	};

	function rtnDropdown($dropdownId) {
		if ($dropdownId === '') {
			let genHour = false;
			document.querySelectorAll('[name="device"]:checked').forEach(device => {
				if (device.dataset.type === 'time') { genHour = true; }
			});

			if (genHour) {
				dropDownInit($('#interval'));

				document.querySelectorAll('#interval li').forEach(li => {
					if (li.dataset.value === 'day' || li.dataset.value === 'month') {
						li.classList.remove('disabled');
					} else {
						li.classList.add('disabled');
					}
				});
			} else {
				document.querySelectorAll('#interval li').forEach(li => {
					li.classList.remove('disabled');
				});
			}
		} else if ($dropdownId === 'siteList') {
			makeDeviceList();
		} else if ($dropdownId === 'period') {
			let period = $('#period button').data('value');
			if (period === 'today') { //오늘
				$('#fromDate').datepicker('setDate', 'today'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			} else if (period === 'week') { //이번주
				$('#fromDate').datepicker('setDate', '-6'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			} else { //이번달
				$('#fromDate').datepicker('setDate', '-30'); //데이트 피커 기본
				$('#toDate').datepicker('setDate', 'today'); //데이트 피커 기본
			}
		} else if ($dropdownId.match('chartStyle')) {
			statusDataDraw();
			chartDataDraw();
		}
	}

	/**
	 * 데이터 조회
	 *
	 * @returns {boolean}
	 */
	const searchGenData = () => {
		//기간 설정 확인
		let startTime = $('#fromDate').val().replace(/-/g, '') + "000000";
		let endTime = $('#toDate').val().replace(/-/g, '') + "235959";
		//주기 확인
		interval = $('#interval button').data('value');

		if (['5min', '15min', 'hour'].includes(interval)) {
			$('#chartStyle2').parent().removeClass('hidden');
		} else {
			$('#chartStyle2').parent().addClass('hidden');
			$('#chartStyle2 button').data('value', 'dayBy').html('<fmt:message key="pvGen.viewByDay" /> <span class="caret"></span>');
		}

		const billingSites = new Array();
		const dashSites = new Array();
		const timeSites = new Array();
		const checkedSites = new Array();
		const solarSites = new Array();
		const solarDevices = new Array();
		const checkedDevices = new Array();

		document.querySelectorAll('input[name="device"]:checked').forEach(device => {
			const deviceId = device.getAttribute('id');
			if (deviceId.match('billing')) {
				if (!checkedSites.includes(device.value)) checkedSites.push(device.value);
				billingSites.push(device.value);
			} else if (deviceId.match('dashboard')) {
				if (!checkedSites.includes(device.value)) checkedSites.push(device.value);
				dashSites.push(device.value);
			} else if (deviceId.match('time')) {
				if (!checkedSites.includes(device.value)) checkedSites.push(device.value);
				timeSites.push(device.value);
			} else {
				if (device.dataset.type === 'SENSOR_SOLAR') {
					if (!solarDevices.includes(device.value)) solarDevices.push(device.value);
					solarDevices.push(device.value);

					if (!solarDevices.includes(device.dataset.sid)) solarDevices.push(device.dataset.sid);
					solarSites.push(device.dataset.sid);
				} else {
					if (!checkedSites.includes(device.value)) checkedSites.push(device.value);
					checkedDevices.push(device.value);
				}
			}
		});

		const siteWarning = document.getElementById('siteList').nextElementSibling;
		if (document.querySelectorAll('input[name="site"]:checked').length <= 0) {
			siteWarning.classList.remove('hidden');
		} else {
			if (!siteWarning.className.match(/\bhidden\b/)) siteWarning.classList.add('hidden');
		}

		const deviceWarning = document.getElementById('deviceType').children[1].children[1];
		if (billingSites.length === 0 && dashSites.length === 0 && timeSites.length === 0 && checkedDevices.length === 0 && solarDevices.length === 0) {
			deviceWarning.classList.remove('hidden');
		} else {
			if (!deviceWarning.className.match(/\bhidden\b/)) deviceWarning.classList.add('hidden');
		}

		const intervalWarning = document.getElementById('interval').nextElementSibling;
		if (isEmpty($('#interval button').data('value'))) {
			intervalWarning.classList.remove('hidden');
		} else {
			if ($('#interval button').data('value') === 'month') startTime = startTime.substr(0, 6) + '01000000';
			if (!intervalWarning.className.match(/\bhidden\b/)) intervalWarning.classList.add('hidden');
		}

		if (document.querySelectorAll('.warning:not(.hidden)').length > 0) {
			return false;
		}

		document.querySelectorAll('.chart-pv .ntit')[0].classList.remove('hidden');
		document.querySelectorAll('.chart-pv .value-wrapper')[0].classList.remove('hidden');
		document.querySelectorAll('.chart-pv .value-wrapper')[0].innerHTML = '';
		document.querySelectorAll('.chart-pv .ntit')[1].classList.add('hidden');
		document.querySelectorAll('.chart-pv .value-wrapper')[1].classList.add('hidden');
		document.querySelectorAll('.chart-pv .value-wrapper')[1].innerHTML = '';
		document.querySelectorAll('.chart-pv .ntit')[2].classList.add('hidden');
		document.querySelectorAll('.chart-pv .value-wrapper')[2].classList.add('hidden');
		document.querySelectorAll('.chart-pv .value-wrapper')[2].innerHTML = '';

		const promiseUrl = new Array();

		//대시보드
		if (dashSites.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/get/energy/sites',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sid: dashSites.toString(),
					startTime: Number(startTime),
					endTime: Number(endTime),
					interval: interval,
					displayType: 'dashboard',
					formId: 'v2'
				})
			}));
		}

		//매전량
		if (billingSites.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/get/energy/sites',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sid: billingSites.toString(),
					startTime: Number(startTime),
					endTime: Number(endTime),
					interval: interval,
					displayType: 'billing',
					formId: 'v2'
				})
			}));
		}

		//대시보드
		if (timeSites.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/get/energy/sites',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sid: timeSites.toString(),
					startTime: Number(startTime),
					endTime: Number(endTime),
					interval: interval,
					displayType: 'dashboard',
					formId: 'v2'
				})
			}));
		}

		if (checkedDevices.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/get/energy/devices',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					dids: checkedDevices.toString(),
					startTime: Number(startTime),
					endTime: Number(endTime),
					interval: interval
				})
			}));
		}

		if (solarDevices.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/status/summary',
				type: 'GET',
				contentType: 'application/json',
				data: {
					sids: solarSites.toString(),
					dids: solarDevices.toString(),
					startTime: Number(startTime),
					endTime: Number(endTime),
					interval: interval,
					formId: 'v2'
				}
			}));
		}

		$('#loadingCircle').show();
		Promise.all(promiseUrl).then(response => {
			generationData = new Object();
			summaryData = new Object();
			if (!isEmpty(response)) {
				response.forEach((res, idx) => {
					const database = res.data;
					if (idx === (response.length - 1) && solarDevices.length > 0) {
						document.querySelectorAll('input[name="device"]:checked').forEach(device =>  {
							if (device.dataset.type === 'SENSOR_SOLAR') {
								const did = device.value;

								const tempItem = new Array();
								if (!isEmpty(res.SENSOR_SOLAR)) {
									res.SENSOR_SOLAR.forEach(r => {
										if (did === r.did) {
											tempItem.push({
												basetime: r.basetime,
												irradiationPoa: r.mean.irradiationPoa
											})
										}
									});
								}

								generationData[did] = {
									sid: device.dataset.sid,
									name: device.dataset.name,
									type: device.dataset.type,
									0: { items: tempItem }

								};
							}
						});
					} else {
						Object.entries(database).forEach(([id, data]) => {
							if (data.length > 1) data = new Array(data.find(x => x.metering_type === '2'));
							document.querySelectorAll('input[name="device"]:checked').forEach(device =>  {
								if (dashSites.length > 0 && idx === 0) {
									if (device.value === id && /dashboard/.test(device.id)) {
										data.name = device.dataset.name;
										data.sid = device.dataset.sid;
										data.type = 'dashboard';
										id += '_dashboard';
									}
								} else if ((dashSites.length === 0 && billingSites.length > 0 && idx === 0)
										|| (dashSites.length > 0 && billingSites.length > 0 && idx === 1)) {
									if (device.value === id && /billing/.test(device.id)) {
										data.name = device.dataset.name;
										data.sid = device.dataset.sid;
										data.type = 'billing';
										id += '_billing';
									}
								} else if ((dashSites.length === 0 && billingSites.length === 0 && timeSites.length > 0 && idx === 0)
									|| (dashSites.length === 0 && billingSites.length > 0 && timeSites.length > 0 && idx === 1)
									|| (dashSites.length > 0 && billingSites.length === 0 && timeSites.length > 0 && idx === 1)
									|| (dashSites.length > 0 && billingSites.length > 0 && timeSites.length > 0 && idx === 2)) {
									if (device.value === id && /time/.test(device.id)) {
										data.name = device.dataset.name;
										data.sid = device.dataset.sid;
										data.type = 'time';
										id += '_time';
									}
								} else {
									if (device.value === id && !/dashboard/.test(device.id)
										&& !/billing/.test(device.id) && !/time/.test(device.id)) {
										data.name = device.dataset.name;
										data.sid = device.dataset.sid;
										data.type = device.dataset.type;
									}
								}
							});

							generationData[id] = data;
						});
					}
				});
			}

			$('#loadingCircle').hide();
			drawPage();
		}).catch(error => {
			console.error(error);
			$('#loadingCircle').hide();
		});
	}

	/**
	 * 데이터 그리드 작성
	 */
	const drawPage = () => {
		document.getElementById('table-desktop').innerHTML = '';

		standard = makeStandard(interval);
		let gridData = gridDataMake();

		//기준일 && 이름 순으로 정렬
		gridData.sort(
			firstBy(function(a, b) {return Number(String(a['std']).replace(/[^0-9]/g, '')) - Number(String(b['std']).replace(/[^0-9]/g, ''));})
			.thenBy(function(a, b) {return String(b['deviceNm']) - String(a['deviceNm']);})
		);

		let stdLength = 8;
		let colLength = 4;
		if (interval === '5min' ||interval === '15min' || interval === 'hour') {
			stdLength = 8;
			colLength = 4;
		} else if (interval === 'day') {
			stdLength = 6;
			colLength = 2;
		} else {
			stdLength = 4;
			colLength = 2;
		}

		let std = '';
		let table = document.createElement('table');
		table.className = 'table-desktop';
		gridData.forEach((grid, index) => {
			const items = grid.data, deviceId = grid.deviceId;

			if (isEmpty(std) || std !== grid.std) {
				if (!isEmpty(std) && std !== grid.std) {
					document.getElementById('table-desktop').appendChild(table);

					table = document.createElement('table');
					table.className = 'table-desktop';
				}

				std = grid.std;

				let tHead = document.createElement('thead')
					, tBody = document.createElement('tbody')
					, theadTr = document.createElement('tr')
					, tbodyTr = document.createElement('tr')
					, span = document.createElement('span');

				span.classList = grid.color;

				let totalSum = 0;
				items.forEach((item, index) => {
					let th = document.createElement('th')
						, td = document.createElement('td')

					if (index === 0) {
						let standardDate = item.standard.substr(0, stdLength);

						th.innerHTML = (standardDate.length === 8) ? standardDate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3') : (standardDate.length === 6) ? standardDate.replace(/(\d{4})(\d{2})/, '$1-$2') : standardDate;
						theadTr.appendChild(th);

						span.innerHTML = grid.deviceNm
						td.className = 'bullet';
						td.appendChild(span);
						tbodyTr.appendChild(td);

						th = document.createElement('th');
						td = document.createElement('td');
					}

					th.innerHTML = (colLength > 2) ? (item.standard.substr(stdLength, colLength)).replace(/(\d{2})(\d{2})/, '$1:$2') : (item.standard.substr(stdLength, colLength));
					theadTr.appendChild(th);

					if (grid.type === 'time') {
						td.innerHTML = (item.timeValue !== '-') ? Math.round(item.timeValue * 100) / 100 : item.timeValue;
					} else if (grid.type === 'SENSOR_SOLAR') {
						td.innerHTML = (item.timeValue !== '-') ? Math.round((item.timeValue) * 100) / 100 : item.timeValue;
					} else {
						td.innerHTML = (item.timeValue !== '-') ? displayNumberFixedUnit(item.timeValue, 'Wh', 'kWh', 0)[0] : item.timeValue;
					}
					tbodyTr.appendChild(td);

					totalSum += (item.timeValue !== '-') ? item.timeValue : 0;

					if ((items.length - 1) === index) {
						th = document.createElement('th');
						td = document.createElement('td');

						th.innerHTML = '<fmt:message key="pvGen.total" />';
						theadTr.appendChild(th);

						if (grid.type === 'time') {
							td.innerHTML = Math.round(totalSum * 100) / 100;
						} else if (grid.type === 'SENSOR_SOLAR') {
							td.innerHTML = Math.round((totalSum) * 100) / 100;
						} else {
							td.innerHTML = displayNumberFixedUnit(totalSum, 'Wh', 'kWh', 0)[0];
						}

						tbodyTr.appendChild(td);
					}
				});

				tHead.appendChild(theadTr);
				tBody.appendChild(tbodyTr);

				table.appendChild(tHead);
				table.appendChild(tBody);
			} else {
				let tbodyTr = document.createElement('tr')
					, totalSum = 0
					, span = document.createElement('span');

				span.classList = grid.color;

				items.forEach((item, index) => {
					let td = document.createElement('td');

					if (index === 0) {
						span.innerHTML = grid.deviceNm
						td.className = 'bullet';
						td.appendChild(span);
						tbodyTr.appendChild(td);

						td = document.createElement('td');

						if (grid.type === 'time') {
							td.innerHTML = (item.timeValue !== '-') ? Math.round(item.timeValue * 100) / 100 : item.timeValue;
						} else if (grid.type === 'SENSOR_SOLAR') {
							td.innerHTML = (item.timeValue !== '-') ? Math.round((item.timeValue) * 100) / 100 : item.timeValue;
						} else {
							td.innerHTML = (item.timeValue !== '-') ? displayNumberFixedUnit(item.timeValue, 'Wh', 'kWh', 0)[0] : item.timeValue;
						}

						tbodyTr.appendChild(td);
					}

					if (grid.type === 'time') {
						td.innerHTML = (item.timeValue !== '-') ? Math.round(item.timeValue * 100) / 100 : item.timeValue;
					} else if (grid.type === 'SENSOR_SOLAR') {
						td.innerHTML = (item.timeValue !== '-') ? Math.round((item.timeValue) * 100) / 100 : item.timeValue;
					} else {
						td.innerHTML = (item.timeValue !== '-') ? displayNumberFixedUnit(item.timeValue, 'Wh', 'kWh', 0)[0] : item.timeValue;
					}
					tbodyTr.appendChild(td);

					totalSum += (item.timeValue !== '-') ? item.timeValue : 0;

					if ((items.length - 1) === index) {
						td = document.createElement('td');

						if (grid.type === 'time') {
							td.innerHTML = Math.round(totalSum * 100) / 100;
						} else if (grid.type === 'SENSOR_SOLAR') {
							td.innerHTML = Math.round((totalSum) * 100) / 100;
						} else {
							td.innerHTML = displayNumberFixedUnit(totalSum, 'Wh', 'kWh', 0)[0];
						}
						tbodyTr.appendChild(td);
					}
				});
				table.querySelector('tbody').appendChild(tbodyTr);
			}

			if ((gridData.length - 1) === index) {
				document.getElementById('table-desktop').appendChild(table);
			}
		});

		//statusDataDraw();
		chartDataDraw();
	}

	/**
	 * 그리드 데이터 정제
	 *
	 * @returns {any[]}
	 */
	const gridDataMake = function () {
		let dataArr = new Array();

		Object.entries(generationData).forEach(([id, data], dataIdx) => {
			const items = data[0].items, stdLength = standard.length - 1;
			let deivceEnergy = new Array(), stdDate = '';

			standard.forEach((std, index) => {
				let lastLength = 8;
				let suffix = '';
				if (interval === '5min' ||interval === '15min' || interval === 'hour') {
					lastLength = 8;
					suffix = '';
				} else if (interval === 'day') {
					lastLength = 6;
					suffix = '000000';
				} else {
					lastLength = 4;
					suffix = '01000000';
				}

				if (isEmpty(stdDate)) {
					stdDate = std.substr(0, lastLength);
				} else {
					if (stdDate !== std.substr(0, lastLength)) {
						const loop = Math.floor(dataIdx / 15);
						const colorIdx = dataIdx - (15 * loop);
						dataArr.push({
							deviceId: id,
							deviceNm: data.name,
							color: 'color' + String(colorIdx + 1),
							std: stdDate,
							type: data.type,
							data: deivceEnergy
						});

						stdDate = std.substring(0, lastLength);
						deivceEnergy = new Array();
					}
				}

				let timeValue = '-';
				if (!isEmpty(items)) {
					items.forEach(item => {
						if (String(item.basetime) === std + suffix) {
							if (data.type === 'time') {
								const site = sites.find(e => e.sid === id.replace('_time', ''))
									, siteCapacity = site.capacities.gen ? site.capacities.gen : 0;
								if (siteCapacity > 0 && item.energy > 0) {
									timeValue = item.energy / siteCapacity;
								} else {
									timeValue = '-';
								}
							} else if (data.type === 'SENSOR_SOLAR') {
								timeValue = item.irradiationPoa;
							} else {
								timeValue = item.energy;
							}
						}
					});
				}

				deivceEnergy.push({
					standard: std,
					timeValue: timeValue
				});

				if (stdLength === index) {
					const loop = Math.floor(dataIdx / 15);
					const colorIdx = dataIdx - (15 * loop);
					dataArr.push({
						deviceId: id,
						deviceNm: data.name,
						color: 'color' + String(colorIdx + 1),
						type: data.type,
						std: stdDate,
						data: deivceEnergy
					});
				}
			});
		});

		return dataArr;
	}

	/**
	 * 차트 데이터 정제
	 */ 
	const chartDataDraw = function () {
		let num = 0;
		let stack = 0;
		let yAxis = 0;
		let suffix = 'Wh';
		let chartType = 'column';
		let seriesData = new Array();
		let colorArr = [
			'var(--powder-blue)',
			'var(--turquoise)',
			'var(--teal)',
			'var(--light-blue)',
			'var(--blueberry)',
			'var(--royal-blue)',
			'var(--blue-yonder)',
			'var(--circle-solar-power)',
			'var(--deep-lilac)',
			'var(--yellow-green)',
			'var(--green)',
			'var(--eucalyptus)',
			'var(--french-pass)',
			'var(--malibu)',
			'var(--vivid-blue)',
		];
		let chartStandard = standard;

		const chartStyle = $('#chartStyle button').data('value'); //현재 선택된 스타일
		const chartStyle2 = $('#chartStyle2 button').data('value'); //현재 선택된 스타일

		Object.entries(generationData).forEach(([id, data]) => {
			const items = data[0].items
				, name = data.name
				, sid = data.sid;

			let deivceEnergy = new Array()
				, totalSum = 0
				, dup = false;

			if (['5min', '15min', 'hour'].includes(interval) && chartStyle2 === 'overlap') {
				chartStandard = makeStandard(interval, 'overlap');
				chartStandard.forEach((std, index) => {
					let timeValue = null;
					if (!isEmpty(items)) {
						items.forEach(item => {
							if (String(item.basetime).substr(8, 6) === std) {
								if (data.type === 'time') {
									const site = sites.find(e => e.sid === id.replace('_time', ''))
										, siteCapacity = site.capacities.gen ? site.capacities.gen : 0;
									timeValue = item.energy / siteCapacity;
									totalSum += timeValue;
								} else if (data.type === 'SENSOR_SOLAR') {
									timeValue += Math.round(item.irradiationPoa * 100) / 100 ;
									totalSum += (item.irradiationPoa === null) ? 0 : item.irradiationPoa;
								} else {
									timeValue += Math.round(item.energy / 1000) ;
									totalSum += (item.energy === null) ? 0 : item.energy;
								}
							}
						});
					}


					deivceEnergy.push([std, timeValue]);
				});
			} else {
				standard.forEach((std, index) => {
					let suffix = '';
					if (interval === '5min' ||interval === '15min' || interval === 'hour') {
						suffix = '';
					} else if (interval === 'day') {
						suffix = '000000';
					} else {
						suffix = '01000000';
					}

					let timeValue = null;
					if (!isEmpty(items)) {
						items.forEach(item => {
							if (String(item.basetime) === std + suffix) {
								if (data.type === 'time') {
									const site = sites.find(e => e.sid === id.replace('_time', ''))
										, siteCapacity = site.capacities.gen ? site.capacities.gen : 0;
									timeValue = item.energy / siteCapacity;
									totalSum += timeValue;
								} else if (data.type === 'SENSOR_SOLAR') {
									timeValue += Math.round(item.irradiationPoa * 100) / 100 ;
									totalSum += (item.irradiationPoa === null) ? 0 : item.irradiationPoa;
								} else {
									timeValue += Math.round(item.energy / 1000) ;
									totalSum += (item.energy === null) ? 0 : item.energy;
								}
							}
						});
					}

					deivceEnergy.push([std, timeValue]);
				});
			}

			if (chartStyle === 'allSum') {
				if (seriesData.length > 0) {
					const dataType = id.match('_billing') ? 'billing' : id.match('_time') ? 'time' : '';
					const findData = seriesData.find(e => e.dataType === dataType);

					if (isEmpty(findData)) {
						seriesData.forEach(data => {
							if (stack <= data.stack) stack = data.stack +1;
						});
					} else {
						stack = findData.stack;
					}
				}
			} else if (chartStyle === 'siteSum') {
				if (seriesData.length > 0) {
					const dataType = id.match('_billing') ? 'billing' : id.match('_time') ? 'time' : '';
					const findData = seriesData.find(e => e.sid === sid && e.dataType === dataType);

					if (isEmpty(findData)) {
						seriesData.forEach(data => {
							if (stack <= data.stack) stack = data.stack +1;
						});
					} else {
						stack = findData.stack;
					}
				} else {
					stack = 0;
				}
			} else {
				stack++;
			}

			if (data.type === 'time') {
				yAxis = 2;
				chartType = 'column';
				suffix = 'Wh';
			} else if (data.type === 'SENSOR_SOLAR') {
				yAxis = 1;
				chartType = 'ShortDash';
				suffix = 'W/m\xB2';
			} else {
				yAxis = 0;
				chartType = 'column';
				suffix = 'Wh';
			}

			seriesData.push({
				name: name,
				type: chartType,
				stack: stack,
				sid: sid,
				dataType: data.type,
				yAxis: yAxis,
				tooltip: {
					valueSuffix: suffix,
				},
				total: totalSum,
				color: colorArr[num],
				data: deivceEnergy
			});

			if (data.type === 'SENSOR_SOLAR') {
				delete seriesData[seriesData.length - 1].stack;
				delete seriesData[seriesData.length - 1].type;

				seriesData[seriesData.length - 1].dashStyle = 'ShortDash';
				seriesData[seriesData.length - 1].marker = {
					symbol: 'circle'
				}
			}


			if (num === 15) num = 0;
			num++;
		});

		seriesData = seriesData.concat(statusSummary);
		chartDraw(chartStandard, seriesData);

		//발전량 합계
		document.querySelector('.value-wrapper').innerHTML = '';
		document.getElementById('pvTable').classList.remove('hidden');

		if (!isEmpty(seriesData)) {
			let totalArr = new Array();

			seriesData.forEach(data => {
				if (chartStyle === 'allSum') {
					if (data.dataType === 'time') {
						let index = totalArr.findIndex(e => e.type === 'time');
						if (index > -1) {
							totalArr[index].totVal += data.total;
						} else {
							totalArr.push({
								name: '<fmt:message key="pvGen.hourall" />',
								type: 'time',
								totVal: data.total
							});
						}
					} else if (data.dataType === 'SENSOR_SOLAR') {
						let index = totalArr.findIndex(e => e.type === 'SENSOR_SOLAR');
						if (index > -1) {
							totalArr[index].totVal += data.total;
						} else {
							totalArr.push({
								name: '<fmt:message key="pvGen.hourall" />',
								type: 'SENSOR_SOLAR',
								totVal: data.total
							});
						}
					} else {
						let index = totalArr.findIndex(e => e.type === '');
						if (index > -1) {
							totalArr[index].totVal += data.total;
						} else {
							totalArr.push({
								name: '<fmt:message key="pvGen.all" />',
								type: '',
								totVal: data.total
							});
						}
					}
				} else if (chartStyle === 'siteSum') {
					const siteNm = (data.name).split('_')
						, sid = data.sid;

					if (data.dataType === 'time') {
						const index = totalArr.findIndex(e => e.sid === sid && e.type === 'time');
						if (index > -1) {
							totalArr[index].totVal += data.total;
						} else {
							totalArr.push({
								name: siteNm[0] + ' 발전시간',
								sid: sid,
								type: 'time',
								totVal: data.total
							});
						}
					} else if (data.dataType === 'SENSOR_SOLAR') {
						const index = totalArr.findIndex(e => e.sid === sid && e.type === 'SENSOR_SOLAR');
						if (index > -1) {
							totalArr[index].totVal += data.total;
						} else {
							totalArr.push({
								name: siteNm[0],
								sid: sid,
								type: 'time',
								totVal: data.total
							});
						}
					} else {
						const index = totalArr.findIndex(e => e.sid === sid && e.type === '');
						if (index > -1) {
							totalArr[index].totVal += data.total;
						} else {
							totalArr.push({
								name: siteNm[0],
								sid: sid,
								type: '',
								totVal: data.total
							});
						}
					}
				} else {
					totalArr.push({
						name: data.name,
						type: data.dataType,
						totVal: data.total
					});
				}
			});

			let totalTemp = ``;
			let totalTemp_time = ``;
			let totalTemp_insolation = ``;
			if (!isEmpty(totalArr)) {
				totalArr.forEach(total => {
					var totalValue = (!isNaN(total.totVal) && total.totVal != 0) ? Math.round(total.totVal * 100) / 100 : '-';
					if (total.type === 'time') {
						totalTemp_time += `<h3 class="value-title">${'${total.name}'}</h3>
								<p class="value-num"><span class="num">${'${numberComma(totalValue)}'}</span> hrs</p>`;
					} else if (total.type === 'SENSOR_SOLAR') {
						totalTemp_insolation += `<h3 class="value-title">${'${total.name}'}</h3>
								<p class="value-num"><span class="num">${'${numberComma(totalValue)}'}</span> W/m\xB2</p>`;
					} else {
						totalValue = totalValue === '-' ? '-' : Math.round(totalValue / 10) / 100;
						totalTemp += `<h3 class="value-title">${'${total.name}'}</h3>
								<p class="value-num"><span class="num">${'${numberComma(totalValue)}'}</span> kWh</p>`;
					}
				});
			}

			if (!isEmpty(totalTemp)) {
				document.querySelectorAll('.chart-pv .ntit')[0].classList.remove('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[0].classList.remove('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[0].innerHTML = totalTemp;
			} else {
				document.querySelectorAll('.chart-pv .ntit')[0].classList.add('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[0].classList.add('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[0].innerHTML = '';
			}

			if (!isEmpty(totalTemp_time)) {
				document.querySelectorAll('.chart-pv .ntit')[1].classList.remove('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[1].classList.remove('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[1].innerHTML = totalTemp_time;
			} else {
				document.querySelectorAll('.chart-pv .ntit')[1].classList.add('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[1].classList.add('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[1].innerHTML = '';
			}

			if (!isEmpty(totalTemp_insolation)) {
				document.querySelectorAll('.chart-pv .ntit')[2].classList.remove('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[2].classList.remove('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[2].innerHTML = totalTemp_insolation;
			} else {
				document.querySelectorAll('.chart-pv .ntit')[2].classList.add('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[2].classList.add('hidden');
				document.querySelectorAll('.chart-pv .value-wrapper')[2].innerHTML = '';
			}
		}
		document.querySelector('.text-time').innerHTML = (new Date()).format('yyyy-MM-dd HH:mm:ss');
	}

	const chartDraw = function (chartStandard, seriesData) {
		let chart = $('#chart2').highcharts();
		$('#chart2').parents().closest('.clear.hidden').removeClass('hidden');
		$('.indiv.chart-pv').addClass('fixed');

		if (chart) {
			chart.destroy();
		}

		let option = {
			chart: {
				renderTo: 'chart2',
				marginTop: 50,
				marginLeft: 80,
				marginRight: 60,
				backgroundColor: 'transparent',
			},
			navigation: {
				buttonOptions: {
					enabled: false
				}
			},
			title: {
				text: ''
			},
			subtitle: {
				text: ''
			},
			xAxis: [{
				lineColor: 'var(--grey)',
				labels: {
					align: 'center',
					style: {
						color: 'var(--grey)',
						fontSize: '8px'
					},
					y: 50,
					formatter: function () {
						return dateFormat(this.value);
					},
					enabled: true,
					rotation: -45
				},
				categories: chartStandard,
				title: {
					text: null
				},
				crosshair: true
			}],
			yAxis: [{
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				offset: -10,
				min: 0,
				title: {
					text: '(kWh)',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 20,
					style: {
						color: 'var(--grey)',
						fontSize: '10px'
					}
				},
				labels: {
					formatter: function () {
						return numberComma(this.value);
						//return  numberComma(this.value) + '<br/>/ ' + this.chart.yAxis[2].paddedTicks[]  ;
					},
					overflow: 'justify',
					x: -20,
					style: {
						color: 'var(--grey)',
						fontSize: '10px'
					}
				}
			}, {
				gridLineColor: 'var(--white25)',
				gridLineWidth: 0,
				title: {
					text: '(W/㎡)',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 20,
					style: {
						color: 'var(--grey)',
						fontSize: '10px',
						transform: 'translate(-30px, 0px)'
					}
				},
				labels: {
					formatter: function () {
						return  this.value;
					},
					style: {
						color: 'var(--grey)',
							fontSize: '10px'
					}
				},
				visible: true,
				opposite: true,
				showEmpty: false
			}, {
				gridLineColor: 'var(--white25)',
				gridLineWidth: 0,
				title: {
					text: '(hrs)',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 40,
					style: {
						color: 'var(--grey)',
						fontSize: '10px',
						transform: 'translate(-30px, 0px)'
					}
				},
				labels: {
					formatter: function () {
						return  this.value;
					},
					style: {
						color: 'var(--grey)',
						fontSize: '10px'
					}
				},
				offset: 35,
				visible: true,
				opposite: false,
				showEmpty: false
			}],
			legend: {
				enabled: true,
				align: 'right',
				verticalAlign: 'top',
				x: -10,
				y: -15,
				itemStyle: {
					color: 'var(--white87)',
					fontSize: '12px',
					fontWeight: 400
				},
				maxHeight: 40,
				itemHoverStyle: {
					color: ''
				},
				symbolPadding: 0,
				symbolHeight: 7
			},
			tooltip: {
				formatter: function () {
					return this.points.reduce(function (s, point) {
						if (/일사량/.test(point.series.name)) {
							return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + numberComma((point.y).toFixed(2)) + 'W/㎡';
						} else if(/발전시간/.test(point.series.name)) {
							return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + numberComma((point.y).toFixed(2)) + 'hrs';
						} else {
							return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + numberComma(point.y) + 'kWh';
						}

					}, '<b>' + dateFormat(this.points[0].point.name) + '</b>');
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
				}
			},
			credits: {
				enabled: false
			},
			series: seriesData,
		}

		chart = new Highcharts.Chart(option);
		chart.redraw();
	}

	const dateFormat = function (val) {
		const chartStyle2 = $('#chartStyle2 button').data('value'); //현재 선택된 스타일

		let date = '';

		if (!isEmpty(val)) {
			if (String(val).length === 4) {
				date = val.substring(0, 4)
			} else if (String(val).length === 6 && chartStyle2 === 'dayBy') {
				date = val.substring(0, 4) + '-' + val.substring(4, 6);
			} else if (String(val).length === 6 && chartStyle2 === 'overlap') {
				date = val.substring(0, 2) + ':' + val.substring(2, 4);
			} else if (String(val).length > 8) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8) + ' ' + val.substring(8, 10) + ':' + val.substring(10, 12);
			} else if (String(val).length === 8) {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8);
			}
		}

		return date;
	}
</script>
