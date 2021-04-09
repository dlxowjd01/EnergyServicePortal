<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row content-wrapper hidden">
	<div class="col-12">
		<div class="indiv">
			<table id="gmainTable" class="dashboard-table" >
				<colgroup>
					<col style="width: 5%">  <!-- 순번 -->
					<col style="width: 18%"> <!-- 발전소 명 -->
					<col style="width: 8%">  <!-- 발전용량(kW) -->
					<col style="width: 10%">  <!-- 인버터 가동 상태 -->
					<col style="width: 8%">  <!-- 통신 상태 -->
					<col style="width: 15%"> <!-- 경고 알람 -->
					<col style="width: 8%">  <!-- 금일 발전시간 (Hrs) -->
					<col style="width: 8%">  <!-- 금일 누적발전량(kWh) -->
					<col style="width: 8%">  <!-- 현재 날씨 -->
					<col style="width: 8%">  <!-- 전일 발전 시간(Hrs) -->
					<col style="width: 8%">  <!-- 전일 발전량(kWh) -->
					<col style="width: 8%">  <!-- 전일 날씨 -->
					<col style="width: 8%">  <!-- 월간 발전량(MWh) -->
					<col style="width: 8%">  <!-- 전년 동월 발전량(MWh) -->
					<col style="width: 8%">  <!-- 전년 동월 대비 발전 비율(%) -->
				</colgroup>
				<thead>
					<!-- <tr>
						<th class="row-2" rowspan="2"></th>
						<th class="row-2" rowspan="2"></th>
						<th class="row-2" rowspan="2"></th>
						<th class="row-2" rowspan="2"></th>
						<th class="row-2" rowspan="2"></th>
						<th class="row-2" rowspan="2"></th>
						<th class="col-3" rowspan="1" colspan="3"></th>
						<th class="col-3" rowspan="1" colspan="3"></th>
						<th class="col-3" rowspan="1" colspan="3"></th>
					</tr>
					<tr>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
						<th rowspan="1"></th>
					</tr> -->
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
	let gmainTable = null;
	let yester = new Date();
	yester.setDate(yester.getDate() - 1);

	let lastMonth = new Date();
	lastMonth.setDate(0);

	let lastDay = 0;
	lastDay = lastMonth.getDate();

	$(function () {
		gmainTable = $('#gmainTable').DataTable({
			autoWidth: true,
			'table-layout': 'fixed',
			scrollX: true,
			scrollY: '720px',
			scrollCollapse: true,
			paging: false,
			order: [[ 1, 'asc' ]],
			sortable: true,
			orderCellsTop: true,
			columns: [
				{
					title: i18nManager.tr("dashboard.table.1"), // 순번
					data: null,
					render: function (data, type, full, rowIndex) {
						return rowIndex.row + 1;
					},
					className: 'dt-center no-sorting fixed',
				},
				{
					title: i18nManager.tr("dashboard.table.2"), // 발전소 명
					data: 'siteName',
					render: function (data, type, full, rowIndex) {
						return '<a href="javascript:pageMove(\'' + full['sid'] + '\', \'siteMain\'), \'self\'">' + data + '</a>' +
								'<button onclick="pageMove(\'' + full['sid'] + '\', \'siteMain\', \'blank\')" class="icon-open"></button>';
					},
					className: 'dt-head-left dt-body-left',
				},
				{
					title: i18nManager.tr("dashboard.table.3"), // 발전용량
					data: 'capacity',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.4"), // 인버터 가동상태
					data: 'invCount',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.status"), // 통신상태
					data: 'comStatus',
					render: function (data, type, full, rowIndex) {
						return `<span class="status-button ${'${data[0]}'}">${'${data[1]}'}</span>`;
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.5"), // 경고 알람
					data: 'deviceFault',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-center',
				},
				
				{
					title: i18nManager.tr("dashboard.table.nowTime"), // 금일 발전시간 | (신규) [금일 발전량 / 용량]
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['nowEnergy_origin']) || isEmpty(full['capacity_origin'])) {
							return '-'
						} else {
							const nowEnergy = isEmpty(full['nowEnergy_origin']) ? 0 : full['nowEnergy_origin'];
							const capacity = isEmpty(full['capacity_origin']) ? 0 : full['capacity_origin'];
							if (nowEnergy > 0 && capacity > 0) {
								const displayData =(Math.round(nowEnergy/capacity * 10) / 10);
								return `<a href="javascript:void(0);" onclick="goPvGen('${'${today.format(\'yyyyMMdd\')}'}', 'hour', 'time', '${'${full[\'sid\']}'}')">${'${displayData}'}</a>`;
							} else {
								return '-'
							}
						}
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.6"), // 금일 발전량
					data: 'nowEnergy',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${today.format(\'yyyyMMdd\')}'}', 'hour', '', '${'${full[\'sid\']}'}')">${'${data}'}</a>`;
						}
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.7"), // 현재 날씨
					data: 'toDaySky',
					render: function (data, type, full, rowIndex) {
						if (data != null && data === '-') {
							return '-';
						} else {
							const weather = getWeatherIconClass(data);
							return '<i class="ico-weather ' + weather + '"></i>';
						}
					},
					sortable: false,
					className: 'dt-center',
				},

				{
					title: i18nManager.tr("dashboard.table.10"), // 전일 발전시간
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['yesterEnergy_origin']) || isEmpty(full['capacity_origin'])) {
							return '-'
						} else {
							const yesterEnergy = isEmpty(full['yesterEnergy_origin']) ? 0 : full['yesterEnergy_origin'];
							const capacity = isEmpty(full['capacity_origin']) ? 0 : full['capacity_origin'];
							if (yesterEnergy > 0 && capacity > 0) {
								const displayData = (Math.round(yesterEnergy/capacity * 10) / 10);
								return `<a href="javascript:void(0);" onclick="goPvGen('${'${yester.format(\'yyyyMMdd\')}'}', 'hour', 'time', '${'${full[\'sid\']}'}')">${'${displayData}'}</a>`;
							} else {
								return '-';
							}
						}
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.8"), // 전일 발전량
					data: 'yesterEnergy',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-'
						} else {
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${yester.format(\'yyyyMMdd\')}'}', 'hour', '', '${'${full[\'sid\']}'}')">${'${data}'}</a>`;
						}
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.9"), // 전일 날씨
					data: 'yesterDaySky',
					render: function (data, type, full, rowIndex) {
						if (data != null && data === '-') {
							return '-';
						} else {
							const weather = getWeatherIconClass(data);
							return '<i class="ico-weather ' + weather + '"></i>';
						}
					},
					sortable: false,
					className: 'dt-center',
				},

				{
					title: i18nManager.tr("dashboard.table.14"), // 지난달 발전시간
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['lastMonthGen']) || isEmpty(full['capacity_origin'])) {
						 	return '-'
						} else {
							const lastMonthEnergy = isEmpty(full['lastMonthGen_origin']) ? 0 : full['lastMonthGen_origin'];
							const capacity = isEmpty(full['capacity_origin']) ? 0 : full['capacity_origin'];
							if (lastMonthEnergy > 0 && capacity > 0) {
								const displayData = Math.round(lastMonthEnergy/capacity * 10) / 10
								return `<a href="javascript:void(0);" onclick="goPvGen('${'${lastMonth.format(\'yyyyMM\')}'}', 'day', 'time', '${'${full[\'sid\']}'}')">${'${displayData}'}</a>`;
							} else {
								return '-';
							}
						}
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.15"), // 지난달 발전량
					data: 'lastMonthGen',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${lastMonth.format(\'yyyyMM\')}'}', 'day', '', '${'${full[\'sid\']}'}')">${'${data}'}</a>`;
						}
					},
					className: 'dt-center',
				},
				{
					title: i18nManager.tr("dashboard.table.16"), // 지난달 일 평균 발전시간
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['lastMonthGen']) || isEmpty(full['capacity_origin'])) {
							return '-'
						} else {
							const lastMonthEnergy = isEmpty(full['lastMonthGen_origin']) ? 0 : full['lastMonthGen_origin'];
							const capacity = isEmpty(full['capacity_origin']) ? 0 : full['capacity_origin'];
							if (lastMonthEnergy > 0 && capacity > 0) {
								const displayData = Math.round(((lastMonthEnergy/capacity) / lastDay) * 10) / 10
								return `<a href="javascript:void(0);" onclick="goPvGen('${'${lastMonth.format(\'yyyyMM\')}'}', 'day', 'time', '${'${full[\'sid\']}'}')">${'${displayData}'}</a>`;
							} else {
								return '-';
							}
						}
					},
					className: 'dt-center',
				},
			],
			// columnDefs: [
			// 	{ name: "today", orderData: [6, 7, 8], targets: 0 },
			// 	{ name: "yesterday", orderData: [9, 10, 11], targets: 1 },
			// 	{ name: "lastMonth", orderData: [12, 13, 14], targets: 2 },
			// ],
			language: {
				emptyTable: i18nManager.tr("gdash.the_data_you_have_queried_does_not_exist"),
				zeroRecords:  i18nManager.tr("gdash.your_search_has_not_returned_results"),
				infoEmpty: "",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / <fmt:message key='table.totalCase.start' /> _TOTAL_ <fmt:message key='table.totalCase.end' />",
			},
			dom: 'tip',
		}).columns.adjust().draw();
	});

	/**
	 * 테이블 대시 보드 데이터 처리
	 *
	 * @param table
	 */
	const getDashboardTable = (table) => {
		const dayFormData = getSiteMainSchCollection('day');
		const yesterDayFormData = getSiteMainSchCollection('yesterday');
		const beforeMonthFormData = getSiteMainSchCollection('beforeMonth');

		let tableData = new Array();
		let urls = new Array();
		let siteArray = new Array();
		
		siteList.forEach(site => {
			siteArray.push(site.sid);
			tableData.push({
				sid: site.sid,
				capacity: (!isEmpty(site.capacities) && !isEmpty(site.capacities.gen)) ? numberComma(Math.round(site.capacities.gen / 1000)) : '-',
				capacity_origin: site.capacities.gen,
				siteName: site.name
			});
		});

		let siteArray_temp = siteArray;
		if (isEmpty(sgid)) siteArray = 'all';

		//오늘 발전 0
		if (siteArray.length > 0) {
			urls.push($.ajax({
				url: apiHost + '/get/energy/now/sites',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sids: siteArray.toString(),
					metering_type: '2',
					interval: 'day'
				})
			}));

			//어제 발전 1
			urls.push($.ajax({
				url: apiHost + '/get/energy/sites',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sid: siteArray.toString(),
					startTime: Number(yesterDayFormData.startTime),
					endTime: Number(yesterDayFormData.endTime),
					interval: 'day',
					displayType: 'dashboard',
					formId: 'v2'
				})
			}));

			//작년 동월 발전 2
			urls.push($.ajax({
				url: apiHost + '/get/energy/sites',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sid: siteArray.toString(),
					startTime: Number(beforeMonthFormData.startTime),
					endTime: Number(beforeMonthFormData.endTime),
					interval: 'month',
					displayType: 'dashboard',
					formId: 'v2'
				})
			}));

			//알람 이력 3
			urls.push($.ajax({
				url: apiHost + '/get/alarms',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sids: siteArray.toString(),
					startTime: Number(dayFormData.startTime),
					endTime: Number(dayFormData.endTime),
					confirm: false
				})
			}));

			//기상 정보 오늘 4
			urls.push($.ajax({
				url: apiHost + '/get/weather/site',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sid: siteArray.toString(),
					interval: 'hour',
					startTime: Number(yesterDayFormData.startTime),
					endTime: Number(dayFormData.endTime),
					formId: 'v2'
				})
			}));

			//기상 정보 어제 5
			urls.push($.ajax({
				url: apiHost + '/get/weather/site',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sid: siteArray.toString(),
					interval: 'day',
					startTime: Number(yesterDayFormData.startTime),
					endTime: Number(yesterDayFormData.endTime),
					formId: 'v2'
				})
			}));

			// 통신 상태 6
			urls.push($.ajax({
				url: apiHost + '/get/status/health',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sids: siteArray_temp.join(','),
					startTime: getTime(1, false)
				}),
			}));

			//사이트정보 7
			urls.push($.ajax({
				url: apiHost + '/get/status/raw/sites',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					sids: siteArray.toString(),
					displayType: 'dashboard',
					operation: 'active'
				})
			}));
		}

		document.getElementById('loadingCircleDashboard').style.display =  '';

		new Promise((resolve, reject) => {
			resolve(Promise.all(urls));
		}).then(response => {
			response.forEach((resData, index) => {
				if (index === 0) {
					tableData.forEach((site, index) => {
						let targetData = resData.data[site.sid];
						if (isEmpty(targetData)) {
							tableData[index]['nowEnergy'] = '-';
						} else {
							tableData[index]['nowEnergy_origin'] = targetData.energy;
							tableData[index]['nowEnergy'] = !isNaN(targetData.energy) ? displayNumberFixedUnit(targetData.energy, 'W', 'kW', 0)[0] : '-';
						}
					});
				} else if (index === 1) {
					tableData.forEach((site, index) => {
						let targetData = resData.data[site.sid];
						if (!isEmpty(targetData)) {
							const items = targetData[0]['items'];
							if (!isEmpty(items)) {
								let genEnergy = items.map(el => el['energy']).reduce( function add(sum, currValue) { return sum + currValue; });
								tableData[index]['yesterEnergy_origin'] = genEnergy;
								tableData[index]['yesterEnergy'] = !isNaN(genEnergy) ? displayNumberFixedUnit(genEnergy, 'W', 'kW', 0)[0] : '-';
							}
						}
					});
				} else if (index === 2) {
					tableData.forEach((site, index) => {
						let targetData = resData.data[site.sid];
						if (!isEmpty(targetData)) {
							const items = targetData[0]['items'];
							if (!isEmpty(items)) {
								let genEnergy = items.map(el => el['energy']).reduce( function add(sum, currValue) { return sum + currValue; });
								tableData[index]['lastMonthGen_origin'] = genEnergy;
								tableData[index]['lastMonthGen'] = !isNaN(genEnergy) ? displayNumberFixedUnit(genEnergy, 'W', 'kW', 0)[0] : '-';
							}
						}
					});
				} else if (index === 3) {
					resData.sort((a, b) => {
						return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
					});

					tableData.forEach((site, index) => {
						const alarm = resData.find(e => site['sid'] == e.sid);
						if (!isEmpty(alarm)) {
							tableData[index]['deviceFault'] = alarm['message'];
						}
					});
				} else if (index === 4) {
					const weatherData = resData['data'];
					if (!isEmpty(weatherData)) {
						tableData.forEach((site, index) => {
							const datas = weatherData[site.sid]['items'];
							if (isEmpty(datas)) {
								tableData[index]['toDaySky'] = '-';
							} else {
								datas.sort((a, b) => {
									return a.basetime > b.basetime ? -1 : a.basetime < b.basetime ? 1 : 0;
								});
								const curruntWeather = datas.find(item => item['observed'] === true);
								if (isEmpty(curruntWeather)) {
									tableData[index]['toDaySky'] = '';
								} else {
									tableData[index]['toDaySky'] = curruntWeather['sky'];
								}
							}
						});
					}
				} else if (index === 5) {
					const weatherData = resData['data'];
					if (!isEmpty(weatherData)) {
						tableData.forEach((site, index) => {
							const datas = weatherData[site.sid]['items'];
							if (isEmpty(datas)) {
								tableData[index]['yesterDaySky'] = '-';
							} else {
								tableData[index]['yesterDaySky'] = datas[0]['sky'];
							}
						});
					}
				} else if (index === 6) {
					const sites = resData['sites'];


					tableData.forEach((site, index) => {
						const comStatus = sites.find(x => site.sid === x.sid);
						
						if (!isEmpty(comStatus.rtus)) {
							const operation = comStatus.rtus.find(e => e.operation === 1);
							if (!isEmpty(operation)) {
								tableData[index]['comStatus'] = ["normal", "<fmt:message key='button.normal' />"];
							} else {
								tableData[index]['comStatus'] = ["error", "<fmt:message key='button.error' />"];
							}
						} else {
							tableData[index]['comStatus'] = ["error", "<fmt:message key='button.error' />"];
						}

						const targetSite = siteList.find(x => x.sid === site.sid)
						if (targetSite.rtus) {
							if (targetSite.rtus.find(x => x.rtu_type === 2)) {
								tableData[index]['comStatus'] = ["NA", "N/A"];
							}
						}
					});
				} else {
					tableData.forEach((site, index) => {
						Object.entries(resData).forEach(([tSid, tData]) => {
							if (site.sid === tSid) {
								let totalCount = 0, runCount = 0, stopCount = 0;
								Object.entries(tData).forEach(([deviceType, deviceData]) => {
									if (!isEmpty(deviceData) && deviceType.match('INV')) {
										if (!isEmpty(deviceData.devices)) {
											deviceData.devices.forEach(db => {
												totalCount++;
												if (db.operation == 1) {
													runCount++;
												} else {
													stopCount++;
												}
											});
										}

										if ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < deviceData['timestamp'])) {
											const dbTime = new Date(deviceData['timestamp']);
											$('.dbTime').data('timestamp', deviceData['timestamp']).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
										}
									}
								});

								if (totalCount == 0) {
									tableData[index]['invCount'] = '-';
								} else {
									if (totalCount != stopCount) {
										tableData[index]['invCount'] = 'RUN (' + runCount + '/' + stopCount + '/' + totalCount + ')';
									} else {
										tableData[index]['invCount'] = 'INV (' + runCount + '/' + stopCount + '/' + totalCount + ')';;
									}
								}
							}
						});
					});
				}
			});

			// console.log(gmainTable)
			gmainTable.clear();
			gmainTable.rows.add(tableData);
			$($.fn.dataTable.tables(true)).DataTable().columns.adjust().draw();
		}).catch(error => {
			$('#errMsg').html('처리 중 오류가 발생했습니다.<br/>에러 메세지:' + error);
			$('#errorModal').modal('show');
			console.log(error)
			setTimeout(function(){
				$('#errorModal').modal('hide');
				// location.reload();
			}, 2000);
		}).finally(() => {
			document.getElementById('loadingCircleDashboard').style.display =  'none';
		});
	}
</script>
