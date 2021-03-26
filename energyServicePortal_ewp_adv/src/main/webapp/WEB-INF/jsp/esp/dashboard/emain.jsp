<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	let deviceProp = new Object();
	let emainTable = null;

	$(function() {
		emainTable = $('#emainTable').DataTable({
			scrollX: true,
			scrollXInner: '800px',
			scrollY: '720px',
			scrollCollapse: true,
			paging: false,
			sortable: true,
			order: [[0, 'asc'], [1, 'asc'], [2, 'asc']],
			columns: [
				{
					title: '사이트명',
					data: 'siteName',
					className: 'dt-left'
				},
				{
					title: '설비 유형',
					data: 'device_type',
					className: 'dt-left'
				},
				{
					title: '디바이스',
					data: 'name',
					className: 'dt-left'
				},
				{
					title: '용량(kW)',
					data: 'capacity',
					render: function(data, type, full, rowIndex) {
						let f = d3.format(',.0f');
						if (!isEmpty(data)) {
							return f(data / 1000);
						} else {
							return '-';
						}
					},
					className: 'dt-center'
				},
				{
					title: '최종 수신 시간',
					data: 'lastTargetActivePowerReqDate',
					render: function(data, type, full, rowIndex) {
						if (!isEmpty(data)) {
							let d = new Date(data);
							return d.format('yyyy-MM-dd HH:mm')
						} else {
							return '-';
						}
					},
					className: 'dt-center'
				},
				{
					title: '최종 전송 시간',
					data: 'newest_sent_at',
					render: function(data, type, full, rowIndex) {
						if (!isEmpty(data)) {
							data = String(data).substr(0, 12);
							return data.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})/g, '$1-$2-$3 $4:$5')
						} else {
							return '-';
						}
					},
					className: 'dt-center'
				},
				{
					title: '금일 전송률(%)',
					data: 'success_rate_today',
					render: function(data, type, full, rowIndex) {
						let f = d3.format(',.2f');
						if (isEmpty(data)) {
							return '-';
						} else {
							return f(data * 100);
						}
					},
					className: 'dt-center'
				},
				{
					title: '기간내 전송률(%)',
					data: 'success_rate',
					render: function(data, type, full, rowIndex) {
						let f = d3.format(',.2f');
						if (isEmpty(data)) {
							return '-';
						} else {
							return f(data * 100);
						}
					},
					className: 'dt-center'
				},
				{
					title: '금일 최신 알람',
					data: 'message',
					render: function(data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return data;
						}
					},
					className: 'dt-center'
				}
			],
			language: {
				emptyTable: i18nManager.tr('gdash.the_data_you_have_queried_does_not_exist'),
				zeroRecords:  i18nManager.tr('gdash.your_search_has_not_returned_results'),
				infoEmpty: '',
				paginate: {
					previous: '',
					next: '',
				},
				info: '_PAGE_ - _PAGES_ ' + ' / <fmt:message key='table.totalCase.start' /> _TOTAL_ <fmt:message key='table.totalCase.end' />',
			},
			dom: 'tip',
		}).columns.adjust().draw();

		$('#fromDate').datepicker('setDate', -8);
		$('#toDate').datepicker('setDate', -1);

		setInitList('siteULList'); //사업소 리스트
		properties();
		searchDevices();
	});

	const rtnDropdown = ($selector) => {
		const selector = $('#' + $selector);

		if ($selector == 'siteList') {
			if (selector.find('input:checkbox:checked').length > 0) {
				deviceTypeList();
				dropDownInit($('#typeList'))
			} else {
				$('#typeULList').empty();
				emainTable.clear().draw();
			}
		} else {
			getDataList();
		}
	}

	const properties = () => {
		$.ajax({
			url: apiHost + '/config/view/device_properties',
			type: 'get',
			success: (data, textStatus, jqXHR) => {
				Object.entries(data).forEach(([key, val]) => {
					let devicePropName = (langStatus == 'KO') ? val.name.kr : val.name.en;

					deviceProp[key] ={
						name: devicePropName
					}
				});
			},
			error: (jqXHR, textStatus, errorThrown) => {
				console.error(textStatus);
			}
		});
	}

	//사업소 찾기
	const searchSite = keyword => {
		const result = siteList.filter(x => x.name.includes(keyword));
		siteMakeList(result);
	}

	//사업소 조회
	const siteMakeList = function (search = []) {
		let makeSite = search.length ? Array.from(search) : Array.from(siteList);
		makeSite.sortOn('name');
		makeSite = makeSite.filter(e => e.ESS === true);
		makeSite.unshift({ sid: 'all', name: '<fmt:message key="dropDown.all" />'});
		setMakeList(makeSite, 'siteULList', {'dataFunction': {}}); //list생성

		$('#siteULList').find('input[value="all"]').parent().after('<li class="btn-wrap-border-min"></li>');

		if (!$(`.dropdown-search`).length) {
			$(`#siteList`)
				.prepend(`<div class="dropdown-search"><input type="text" placeholder="<fmt:message key="dropdown.siteSearch" />" onKeyup="searchSite($(this).val())" ></div>`)
				.append(`<div class="btn-wrap-type03 btn-wrap-border dropdown-apply"><button type="button" class="btn-type mr-16"><fmt:message key="deviceState.apply" /></button></div>`);
		}

		deviceTypeList(true);
	};

	const searchDevices = () => {
		if (!isEmpty(siteList)) {
			let deviceAjax = new Array();
			siteList.forEach(site => {
				deviceAjax.push($.ajax({
					url: apiHost + '/config/devices',
					type: 'get',
					dataType: 'json',
					data: {
						sid: site.sid,
						formId: 'v2'
					}
				}));
			});

			Promise.all(deviceAjax).then(response => {
				if (!isEmpty(response)) {
					response.forEach(res => {
						if (!isEmpty(res)) {
							const siteIndex = siteList.findIndex(e => e.sid === res[0].sid);
							const essFind = res.find(e => /ESS/.test(e.device_type));
							if (essFind) {
								siteList[siteIndex]['ESS'] = true;
							} else {
								siteList[siteIndex]['ESS'] = false;
							}
							siteList[siteIndex]['devices'] = res;
						}
					});
				}
			}).finally(() => {
				siteMakeList();
			});
		}
	}

	//설비 유형
	const deviceTypeList = (firstLoad) => {
		let siteArray = new Array();
		let typeArray = new Array();

		$('#devices .dropdown-toggle').text().replace(/<[^>]+>/g, '<fmt:message key="operHistory.multiple" />');

		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => { if (check.value !== 'all') { siteArray.push(check.value); } });
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => { siteArray.push(checked.value); });
		}

		if (!isEmpty(siteArray)) {
			let deviceAjax = new Array();
			siteArray.forEach(site => {
				deviceAjax.push($.ajax({
					url: apiHost + '/config/devices',
					type: 'get',
					dataType: 'json',
					data: {
						sid: site,
						formId: 'v2'
					}
				}));
			});

			Promise.all(deviceAjax).then(response => {
				$('#typeULList').empty();
				if (!isEmpty(response)) {
					response.forEach(res => {
						res.forEach(devices => {
							if (!typeArray.includes(devices.device_type)) typeArray.push(devices.device_type);
						});
					});

					if (!isEmpty(typeArray)) {
						typeArray.forEach(type => {
							let typeName = deviceProp[type].name;
							let check = '';
							if (firstLoad && type === 'BMS_SYS') check = 'checked';

							$('#typeULList').append(`
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="device_${'${type}'}" value="${'${type}'}" name="deviceType" ${'${check}'}>
										<label for="device_${'${type}'}">${'${typeName}'}</label>
									</a>
								</li>
							`);
						});
					}
				}
			}).finally(() => {
				displayDropdown($('#typeList'))
				getDataList();
			});
		}
	}

	const afterDatePick = () => {
		getDataList();
	}

	/**
	 * 데이터 조회
	 */
	const getDataList = () => {
		let siteArray = new Array(), typeArray = new Array(), dataArray = new Array();

		if ($(':checkbox[name="site"]:checked').length > 0) {
			if ($(':checkbox[name="site"]:checked').val() === 'all') {
				document.querySelectorAll('[name="site"]').forEach(check => { if (check.value !== 'all') { siteArray.push({sid: check.value, name: check.nextElementSibling.textContent}); } });
			} else {
				document.querySelectorAll('[name="site"]:checked').forEach(checked => { siteArray.push({sid: checked.value, name: checked.nextElementSibling.textContent}); });
			}
		} else {
			document.querySelectorAll('[name="site"]').forEach(check => { if (check.value !== 'all') { siteArray.push({sid: check.value, name: check.nextElementSibling.textContent}); } });
		}

		document.querySelectorAll('[name="deviceType"]:checked').forEach(check => { typeArray.push(check.value) });

		if (!isEmpty(siteArray)) {
			$('#loadingCircleDashboard').show();
			let deviceAjax = new Array();

			siteArray.forEach(site => {
				deviceAjax.push($.ajax({
					url: apiHost + '/config/devices',
					type: 'get',
					data: {
						sid: site.sid,
						formId: 'v2'
					}
				}));

				deviceAjax.push($.ajax({
					url: apiHost + '/status/raw',
					type: 'get',
					data: {
						sids: site.sid,
					}
				}));

				deviceAjax.push($.ajax({
					url: apiHost + '/alarms',
					type: 'get',
					data: {
						sids: site.sid,
						startTime: $('#fromDate').datepicker('getDate').format('yyyyMMdd') + '000000',
						endTime: $('#toDate').datepicker('getDate').format('yyyyMMdd') + '235959',
						confirm: false
					}
				}));
			});

			Promise.all(deviceAjax).then(response => {
				if (!isEmpty(response)) {
					let devices = new Array();
					response.forEach(res => {
						if (Array.isArray(res)) {
							res.forEach(item => {
								const siteInfo = siteArray.find(e => e.sid === item.sid);
								const idx = dataArray.findIndex(e => e.did === item.did);

								item['siteName'] = siteInfo['name'];
								if (!isEmpty(item.alarm_id)) {
									if (idx > -1) {
										if (isEmpty(dataArray[idx].localtime) || dataArray[idx].localtime < item.localtime) {
											dataArray[idx]['localtime'] = item.localtime;
											dataArray[idx]['message'] = item.message;
										}
									} else {
										dataArray.push({
											did: item.did,
											localtime: item.localtime,
											message: item.message
										});
									}
								} else {
									if (idx > -1) {
										dataArray[idx] = Object.assign({}, dataArray[idx], item);
									} else {
										dataArray.push(item);
									}
								}
							});
						} else {
							Object.entries(res).forEach(([did, status]) => {
								const idx = dataArray.findIndex(e => e.did === did);
								if (!isEmpty(status.data) && !isEmpty(status.data[0].timestamp)) {
									if (idx > -1) {
										dataArray[idx].lastTargetActivePowerReqDate = status.data[0].timestamp;
									} else {
										dataArray.push({
											did: did,
											lastTargetActivePowerReqDate: status.data[0].timestamp
										});
									}
								} else {
									if (idx > -1) {
										dataArray[idx].lastTargetActivePowerReqDate = '-'
									} else {
										dataArray.push({
											did: did,
											lastTargetActivePowerReqDate: '-'
										});
									}
								}
							});
						}
					});
				}

				if (dataArray.length >0) { dataArray = dataArray.filter(e => typeArray.includes(e.device_type)); }

				//임시로 해당 장비들 조회 제회하도록 구성
				//if (dataArray.length) { dataArray = dataArray.filter(e => !['BMS_RACK', 'SENSOR_FLAME', 'SENSOR_TEMPHUMID', 'SENSOR_WEATHER'].includes(e.device_type)); }

				let devices = new Array();
				if (dataArray.length > 0) {
					deviceAjax = new Array();
					dataArray.forEach(data => {
						devices.push(data.did);
					});

					deviceAjax.push($.ajax({
						url: apiHost + '/get/kesco-success-rate',
						type: 'post',
						contentType: 'application/json',
						data: JSON.stringify({
							dids: devices.toString()
						})
					}));

					deviceAjax.push($.ajax({
						url: apiHost + '/get/kesco-success-rate',
						type: 'post',
						contentType: 'application/json',
						data: JSON.stringify({
							dids: devices.toString(),
							startDay: Number($('#fromDate').datepicker('getDate').format('yyyyMMdd')),
							endDay: Number($('#toDate').datepicker('getDate').format('yyyyMMdd')),
						}),
						timeout: 50000
					}));

					deviceAjax.push($.ajax({
						url: apiHost + '/get/kesco-history-newest',
						type: 'post',
						contentType: 'application/json',
						data: JSON.stringify({
							dids: devices.toString(),
							startDay: Number($('#fromDate').datepicker('getDate').format('yyyyMMdd')),
							endDay: Number($('#toDate').datepicker('getDate').format('yyyyMMdd')),
						}),
						timeout: 50000
					}));

					Promise.all(deviceAjax).then(response => {
						response.forEach((res, index) => {
							if (index === 0) {
								if (!isEmpty(res.data)) {
									(res.data).forEach(item => {
										const idx = dataArray.findIndex(e => e.did === item.did);
										if (idx > -1) {
											if (!isEmpty(item.success_rate)) {
												dataArray[idx].success_rate_today = item.success_rate;
											}
										}
									});
								}
							} else if (index === 1) {
								if (!isEmpty(res.data)) {
									(res.data).forEach(item => {
										const idx = dataArray.findIndex(e => e.did === item.did);
										if (idx > -1) {
											if (!isEmpty(item.success_rate)) {
												dataArray[idx].success_rate = item.success_rate;
											}
										}
									});
								}
							} else {
								if (!isEmpty(res)) {
									res.forEach(item => {
										const idx = dataArray.findIndex(e => e.did === item.did);
										if (idx > -1) {
											if (!isEmpty(item.newest_sent_at)) {
												dataArray[idx].newest_sent_at = item.newest_sent_at;
											}
										}
									});
								}
							}
						});

						emainTable.clear();
						emainTable.rows.add(dataArray).draw();
						$($.fn.dataTable.tables(true)).DataTable().columns.adjust();

						$('#loadingCircleDashboard').hide();
					});
				} else {
					emainTable.clear();
					emainTable.rows.add(dataArray).draw();
					$('#loadingCircleDashboard').hide();
				}

			}).catch(error => {
				console.error(error);
				$('#loadingCircleDashboard').hide();
			});
		}
	}
</script>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12">
		<h1 class="page-header fl">전기안전공사 정보 연계 대시보드</h1>
	</div>
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATABASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div id="propertyRow" class="row">
	<div class="col-12">
		<div class="fl">
			<div class="flex-group">
				<span class="tx-tit">사이트명</span>
				<div class="dropdown" id="siteList">
					<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="선택">
						<fmt:message key='siteSetting.all' /><span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type " role="menu" id="siteULList">
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site" checked>
								<label for="site_[INDEX]">[name]</label>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<div class="flex-group">
				<span class="inline-title">설비 유형</span>
				<div class="dropdown" id="typeList">
					<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="선택">
						<fmt:message key='siteSetting.select' /><span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type" role="menu" id="typeULList"></ul>
				</div>
			</div>
		</div>

		<div class="fr">
			<div class="flex-group duration" id="dateArea">
				<span class="tx-tit">전송률 계산 구간</span>
				<div class="sel-calendar dateField">
					<label for="fromDate" class="sr-only"><fmt:message key="pvGen.graph.date.start" /></label>
					<input type="text" id="fromDate" class="sel fromDate" value="" autocomplete="off" readonly>
					<em></em>
					<label for="toDate" class="sr-only"><fmt:message key="pvGen.graph.date.end" /></label>
					<input type="text" id="toDate" class="sel toDate" value="" autocomplete="off" readonly>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="emainTable" class="dashboard-table">
				<colgroup>
					<col style="width:12%"/>
					<col style="width:12%"/>
					<col style="width:16%"/>
					<col style="width:8%"/>
					<col style="width:12%"/>
					<col style="width:12%"/>
					<col style="width:8%"/>
					<col style="width:8%"/>
					<col style="width:12%"/>
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>