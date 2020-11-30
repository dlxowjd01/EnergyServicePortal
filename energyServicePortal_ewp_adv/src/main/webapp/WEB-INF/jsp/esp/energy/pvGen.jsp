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
	<div class="col-lg-2 col-md-4 col-sm-6">
		<div class="indiv chart-pv">
			<h2 class="ntit"><fmt:message key="renewablesgen.2.solarenergy" /></h2>
			<div class="value-wrapper"></div>
		</div>
	</div>
	<div class="col-lg-10 col-md-8 col-sm-6">
		<div class="indiv chart-pv">
			<div class="flex-wrapper">
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
						<button type="button" class="btn-type" id="renderBtn"><fmt:message key="renewablesgen.3.update" /></button>
					</div>
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
	const sites = JSON.parse('${siteList}');
	let generationData = new Object()
		, standard = new Array()
		, interval = '';

	$(function() {
		makeSiteList();

		//전체 선택/전체 해제
		$('#deviceType button.btn-type03').on('click', function (e) {
			let idx = $('#deviceType button.btn-type03').index($(this));
			if (idx == 0) {
				$(':checkbox[name="device"]').prop('checked', true);
			} else {
				$(':checkbox[name="device"]').prop('checked', false);
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
	});

	//사업소 호출
	const makeSiteList = async () => {
		const siteList = document.querySelector('#siteList ul');
		while (siteList.firstChild) siteList.removeChild(siteList.firstChild);
		let liStr = ``;

		if (!isEmpty(sites)) {
			liStr += `<li>
						<a href="javascript:void(0);" data-value="all" tabindex="-1">
							<input type="checkbox" id="all" value="all" name="site">
							<label for="all"><fmt:message key='pvGen.all' /></label>
						</a>
					</li>`;
			liStr += `<li class="btn-wrap-border-min"></li>`;
			sites.forEach((site, index) => {
				liStr += `<li>
							<a href="javascript:void(0);" data-value="${'${site.sid}'}" tabindex="-1">
								<input type="checkbox" id="${'${site.sid}'}" value="${'${site.sid}'}" name="site">
								<label for="${'${site.sid}'}">${'${site.name}'}</label>
							</a>
						</li>`;
			});

			liStr += `<li class="btn-wrap-type03 btn-wrap-border"><button type="button" class="btn-type mr-16">적용</button></li>`;
			siteList.innerHTML = liStr;
		} else {
			siteList.innerHTML = `<li class="no-data"><fmt:message key='pvGen.cannotSelectSite' /></li>`;
		}
	};

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

		document.querySelector('#deviceType .selectDevices').innerHTML = '';

		if (!isEmpty(selectedSite)) {
			let deviceUrl = new Array();
			selectedSite.forEach(sid => {
				deviceUrl.push($.ajax({
					url: apiHost + '/config/devices/',
					type: 'GET',
					data: {
						oid: 'spower',
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

						deviceStr +=
							`   <li>
									<a href="javascript:void(0);" tabindex="-1">
										<input id="device_dashboard_${'${targetSite[\'sid\']}'}" name="device" type="checkbox" value="${'${targetSite[\'sid\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-name="${'${targetSite[\'name\']}'}_대시보드">
										<label for="${'${targetSite[\'sid\']}'}"><span></span><fmt:message key='pvGen.dashboard' /></label>
									</a>
								</li>
							`;

						deviceStr +=
							`   <li>
									<a href="javascript:void(0);" tabindex="-1">
										<input id="device_billing_${'${targetSite[\'sid\']}'}" name="device" type="checkbox" value="${'${targetSite[\'sid\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-name="${'${targetSite[\'name\']}'}_매전">
										<label for="${'${targetSite[\'sid\']}'}"><span></span><fmt:message key='pvGen.sales' /></label>
									</a>
								</li>
							`;

						deviceStr += `<li class="btn-wrap-border-min"></li>`;
						devices.sort((a, b) => {
							return a['name'] > b['name'] ? 1 : a['name'] < b['name'] ? -1 : 0;
						});
						devices.forEach(device => {
							if (device.dashboard || device.billing) {
								deviceStr +=
									`   <li>
											<a href="javascript:void(0);" tabindex="-1">
												<input id="${'${device[\'did\']}'}" name="device" type="checkbox" value="${'${device[\'did\']}'}" data-sid="${'${targetSite[\'sid\']}'}" data-name="${'${targetSite[\'name\']}'}_${'${device[\'name\']}'}">
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
			}).catch(error => {
				console.error(error);
				errorMsg(error);
			});
		}
	};

	function rtnDropdown($dropdownId) {
		if ($dropdownId === 'siteList') {
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
		const checkedDevices = new Array();

		document.querySelectorAll('input[name="device"]:checked').forEach(device => {
			const deviceId = device.getAttribute('id');
			if (deviceId.match('billing')) {
				billingSites.push(device.value);
			} else if (deviceId.match('dashboard')) {
				dashSites.push(device.value);
			} else {
				checkedDevices.push(device.value);
			}
		});

		const siteWarning = document.getElementById('siteList').nextElementSibling;
		if (document.querySelectorAll('input[name="site"]:checked').length <= 0) {
			siteWarning.classList.remove('hidden');
		} else {
			if (!siteWarning.className.match(/\bhidden\b/)) siteWarning.classList.add('hidden');
		}

		const deviceWarning = document.getElementById('deviceType').children[1].children[1];
		if (billingSites.length <= 0 && dashSites.length <= 0 && checkedDevices.length <= 0) {
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

		const promiseUrl = new Array();

		//매전량
		if (billingSites.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/energy/sites',
				type: 'GET',
				async: false,
				data: {
					sid: billingSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'billing',
					formId: 'v2'
				}
			}));
		}

		//대시보드
		if (dashSites.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/energy/sites',
				type: 'GET',
				async: false,
				data: {
					sid: dashSites.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval,
					displayType: 'dashboard',
					formId: 'v2'
				}
			}));
		}

		if (checkedDevices.length > 0) {
			promiseUrl.push($.ajax({
				url: apiHost + '/energy/devices',
				type: 'GET',
				async: false,
				data: {
					dids: checkedDevices.toString(),
					startTime: startTime,
					endTime: endTime,
					interval: interval
				}
			}));
		}

		Promise.all(promiseUrl).then(response => {
			generationData = new Object();
			if (!isEmpty(response)) {
				console.log(response);
				response.forEach((res, index) => {
					const database = res.data;
					Object.entries(database).forEach(([id, data]) => {
						document.querySelectorAll('input[name="device"]:checked').forEach(device => {
							if (billingSites.length > 0 && dashSites.length > 0) {
								if (device.value === id) {
									if (index === 0 && (device.getAttribute('id')).match('billing')) {
										data.name = device.dataset.name;
									} else if (index === 1 && (device.getAttribute('id')).match('dashboard')) {
										data.name = device.dataset.name;
									} else {
										console.log()
										data.name = device.dataset.name;
									}
									data.sid = device.dataset.sid;
									id += index === 0 ? '_billing' : index === 1 ?'_dashboard' : '';
								}
							} else {
								if (device.value === id) {
									data.name = device.dataset.name;
									data.sid = device.dataset.sid;
								}
							}
						});

						generationData[id] = data;
					});
				});
			}

			drawPage();
		}).catch(error => {
			console.error(error);
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
			const items = grid.data;

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

					th.innerHTML = (colLength > 2) ? (item.standard.substr(stdLength, colLength)).replace(/(\d{2})(\d{2})/, '$1:$2') : Number(item.standard);
					theadTr.appendChild(th);

					td.innerHTML = (item.timeValue !== '-') ? displayNumberFixedUnit(item.timeValue, 'Wh', 'kWh', 0)[0] : item.timeValue;
					tbodyTr.appendChild(td);

					totalSum += (item.timeValue !== '-') ? item.timeValue : 0;

					if ((items.length - 1) === index) {
						th = document.createElement('th');
						td = document.createElement('td');

						th.innerHTML = '<fmt:message key="pvGen.total" />';
						theadTr.appendChild(th);
						td.innerHTML = displayNumberFixedUnit(totalSum, 'Wh', 'kWh', 0)[0];
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

						td.innerHTML = displayNumberFixedUnit(item.timeValue, 'Wh', 'kWh', 0)[0];
						tbodyTr.appendChild(td);
					}

					td.innerHTML = (item.timeValue !== '-') ? displayNumberFixedUnit(item.timeValue, 'Wh', 'kWh', 0)[0] : item.timeValue;
					tbodyTr.appendChild(td);

					totalSum += (item.timeValue !== '-') ? item.timeValue : 0;

					if ((items.length - 1) === index) {
						td = document.createElement('td');

						td.innerHTML = displayNumberFixedUnit(totalSum, 'Wh', 'kWh', 0)[0];
						tbodyTr.appendChild(td);
					}
				});
				table.querySelector('tbody').appendChild(tbodyTr);
			}

			if ((gridData.length - 1) === index) {
				document.getElementById('table-desktop').appendChild(table);
			}
		});

		chartDataDraw(generationData, standard, interval);
	}

	/**
	 * 그리드 데이터 정제
	 *
	 * @returns {any[]}
	 */
	const gridDataMake = function () {
		let dataArr = new Array();

		Object.entries(generationData).forEach(([id, data], dataIdx) => {
			const items = data[0].items
				, stdLength = standard.length - 1;
			let deivceEnergy = new Array()
				, stdDate = '';

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
						dataArr.push({
							deviceId: id,
							deviceNm: data.name,
							color: 'color' + String(dataIdx + 1),
							std: stdDate,
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
							timeValue = item.energy;
						}
					});
				}

				deivceEnergy.push({
					standard: std,
					timeValue: timeValue
				});

				if (stdLength === index) {
					dataArr.push({
						deviceId: id,
						deviceNm: data.name,
						color: 'color' + String(dataIdx + 1),
						std: stdDate,
						data: deivceEnergy
					});
				}
			});
		})

		return dataArr;
	}

	/**
	 * 차트 데이터 정제
	 */
	const chartDataDraw = function () {
		let num = 0;
		let stack = 0;
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
		let chartStandard = new Array();

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
				const standard2 = makeStandard(interval, 'overlap');
				chartStandard = standard2;
				standard2.forEach((std, index) => {
					let timeValue = null;
					if (!isEmpty(items)) {
						items.forEach(item => {
							if (String(item.basetime).substr(8, 6) === std) {
								console.log(std, item.energy);
								timeValue += Math.round(item.energy / 1000) ;
							}
						});
					}

					totalSum += (timeValue === null) ? 0 : timeValue;
					deivceEnergy.push([std, timeValue]);
				});
			} else {
				chartStandard = standard;
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
								timeValue = Math.round(item.energy / 1000) ;
							}
						});
					}

					totalSum += (timeValue === null) ? 0 : timeValue;
					deivceEnergy.push([std, timeValue]);
				});
			}

			if (chartStyle === 'allSum') {
				stack = 0;
			} else {
				if (chartStyle === 'siteSum') {
					if (seriesData.length > 0) {
						seriesData.forEach((sData) => {
							if (sid === sData.sid) {
								dup = true;
								stack = sData.stack;
							}
						});

						if (!dup) {
							stack++;
						}
					} else {
						stack = 0;
					}
				} else {
					stack++;
				}
			}

			seriesData.push({
				name: name,
				type: 'column',
				stack: stack,
				sid: sid,
				tooltip: {
					valueSuffix: 'Wh',
				},
				total: totalSum,
				color: colorArr[num],
				data: deivceEnergy
			});

			num++;
		});

		chartDraw(chartStandard, seriesData);

		//발전량 합계
		document.querySelector('.value-wrapper').innerHTML = '';
		document.getElementById('pvTable').classList.remove('hidden');

		if (!isEmpty(seriesData)) {
			let totalArr = new Array();

			seriesData.forEach(data => {
				if (chartStyle === 'allSum') {
					if (totalArr.length > 0) {
						totalArr[0].totVal += data.total;
					} else {
						totalArr.push({
							name: '전체',
							totVal: data.total
						});
					}
				} else {
					if (chartStyle === 'siteSum') {
						let siteNm = (data.name).split('_');
						let sid = data.sid;
						let totVal = data.total;
						if (!isEmpty(totalArr)) {
							let dup = false;

							totalArr.forEach(element => {
								if (data.sid === element.sid) {
									dup = true;
									element.totVal += totVal;
								}
							})

							if (!dup) {
								totalArr.push({
									name: siteNm[0],
									sid: sid,
									totVal: totVal
								});
							}
						} else {
							totalArr.push({
								name: siteNm[0],
								sid: sid,
								totVal: totVal
							});
						}
					} else {
						totalArr.push({
							name: data.name,
							totVal: data.total
						});
					}
				}
			});

			if (!isEmpty(totalArr)) {
				let totalTemp = ``;
				totalArr.forEach(total => {
					totalTemp += `<h3 class="value-title">${'${total.name}'}</h3>
								<p class="value-num"><span class="num">${'${numberComma(total.totVal)}'}</span> kWh</p>`;
				});

				document.querySelector('.value-wrapper').innerHTML = totalTemp;
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
				marginLeft: 60,
				marginRight: 30,
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
			yAxis: {
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				min: 0,
				title: {
					text: '(kWh)',
					align: 'low',
					rotation: 0,
					y: 25,
					x: 5,
					style: {
						color: 'var(--grey)',
						fontSize: '10px'
					}
				},
				labels: {
					overflow: 'justify',
					x: -20,
					style: {
				
						color: 'var(--grey)',
						fontSize: '10px'
					}
				}
			},
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
				itemHoverStyle: {
					color: ''
				},
				symbolPadding: 0,
				symbolHeight: 7
			},
			tooltip: {
				formatter: function () {
					return this.points.reduce(function (s, point) {
						return s + '<br/> <span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + numberComma(point.y) + 'kWh';
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
			} else {
				date = val.substring(0, 4) + '-' + val.substring(4, 6) + '-' + val.substring(6, 8);
			}
		}

		return date;
	}
</script>
