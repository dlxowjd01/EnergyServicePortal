<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row content-wrapper hidden">
	<div class="col-12">
		<div class="indiv">
			<table id="gmainTable" style="table-layout: fixed; width:100%;">
				<colgroup>
					<col style="width:5%">
					<col style="width:10%">
					<col style="width:7%">
					<col style="width:13%">
					<col style="width:14%">
					<col style="width:7%">
					<col style="width:6%">
					<col style="width:7%">
					<col style="width:4%">
					<col style="width:5%">
					<col style="width:7%">
					<col style="width:7%">
					<col style="width:7%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
	let gmainTable = null;
	$(function () {
		gmainTable = $('#gmainTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			"table-layout": "fixed",
			scrollY: '720px',
			scrollCollapse: true,
			paging: false,
			order: [[ 1, 'asc' ]],
			sortable: true,
			columns: [
				{
					title: i18nManager.tr("dashboard.table.1"),
					data: null,
					render: function (data, type, full, rowIndex) {
						return rowIndex.row + 1;
					},
					className: 'dt-center no-sorting fixed'
				},
				{
					title: i18nManager.tr("dashboard.table.2"),
					data: 'siteName',
					render: function (data, type, full, rowIndex) {
						return '<a href="javascript:pageMove(\'' + full['sid'] + '\', \'siteMain\'), \'self\'">' + data + '</a>' +
								'<button onclick="pageMove(\'' + full['sid'] + '\', \'siteMain\', \'blank\')" class="icon-open"></button>';
					},
					className: 'dt-head-left dt-body-left'
				},
				{
					title: i18nManager.tr("dashboard.table.3"),
					data: 'capacity',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.4"),
					data: 'invCount',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.5"),
					data: 'deviceFault',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.6"),
					data: 'nowEnergy',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.7"),
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
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.8"),
					data: 'yesterEnergy',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.10"),
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['yesterEnergy']) || isEmpty(full['capacity'])) {
							return '-'
						} else {
							const yesterEnergy = Number(String(full['yesterEnergy']).replace(/[^\d]/g, ''));
							const capacity = Number(String(full['capacity']).replace(/[^\d]/g, ''));

							return (capacity === 0) ? "0" : (Math.round(yesterEnergy/capacity * 10) / 10);
						}
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.9"),
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
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.11"),
					data: 'monthGen',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return numberComma(data);
						}
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.12"),
					data: 'beforeYearGen',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.13"),
					data: 'proportion',
					render: function (data, type, full, rowIndex) {
						return data;
					},
					className: 'dt-head-right dt-body-right'
				},
			],
			language: {
				emptyTable: i18nManager.tr("gdash.the_data_you_have_queried_does_not_exist"),
				zeroRecords:  i18nManager.tr("gdash.your_search_has_not_returned_results"),
				infoEmpty: "",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / 총 _TOTAL_ 개",
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
		const monthFormData = getSiteMainSchCollection('month');
		const beforeMonthFormData = getSiteMainSchCollection('beforeMonth');
		const yearFormData = getSiteMainSchCollection('beforeYearSameMonth');

		let tableData = new Array();
		let urls = new Array();
		let deferreds = new Array();
		let siteArray = new Array();
		
		siteList.forEach(site => {

			//사이트정보
			urls.push({
				url: apiHost + '/status/raw/site',
				type: 'get',
				data: {
					sid: site.sid,
					formId: 'v2'
				}
			});

			siteArray.push(site.sid);
			tableData.push({
				sid: site.sid,
				capacity: site.capacities.gen ? numberComma(Math.round(site.capacities.gen / 1000)): "-",
				siteName: site.name
			});
		});

		if (isEmpty(sgid)) siteArray = 'all';

		//오늘 발전
		if (siteArray.length > 0) {
			urls.push({
				url: apiHost + '/energy/now/sites',
				type: 'get',
				data: {
					sids: siteArray.toString(),
					metering_type: 2,
					interval: 'day'
				}
			});

			urls.push({
				url: apiHost + '/energy/now/sites',
				type: 'get',
				data: {
					sids: siteArray.toString(),
					metering_type: 2,
					interval: 'month'
				}
			});

			//어제 발전
			urls.push({
				url: apiHost + '/energy/sites?interval=day',
				type: 'get',
				data: {
					sid: siteArray.toString(),
					startTime: yesterDayFormData.startTime,
					endTime: yesterDayFormData.endTime,
					formId: 'v2'
				}
			});

			//작년 동월 발전
			urls.push({
				url: apiHost + '/energy/sites?interval=month',
				type: 'get',
				data: {
					sid: siteArray.toString(),
					startTime: yearFormData.startTime,
					endTime: yearFormData.endTime,
					formId: 'v2'
				}
			});

			//알람 이력
			urls.push({
				url: apiHost + '/alarms',
				type: 'GET',
				data: {
					sids: siteArray.toString(),
					startTime: dayFormData.startTime,
					endTime: dayFormData.endTime,
					confirm: false
				}
			});

			//기상 정보 오늘
			urls.push({
				url: apiHost + '/weather/site',
				type: 'get',
				data: {
					sid: siteArray.toString(),
					interval: 'hour',
					startTime: yesterDayFormData.startTime,
					endTime: dayFormData.endTime,
					formId: 'v2'
				}
			});

			//기상 정보 어제
			urls.push({
				url: apiHost + '/weather/site',
				type: 'get',
				data: {
					sid: siteArray.toString(),
					interval: 'day',
					startTime: yesterDayFormData.startTime,
					endTime: yesterDayFormData.endTime,
					formId: 'v2'
				}
			});
		}

		document.getElementById('loadingCircleDashboard').style.display =  '';
		//ajax 한번에 실행
		deferreds = new Array();
		urls.forEach(function (url) {
			let deferred = $.Deferred();
			deferreds.push(deferred);

			$.ajax(url).done(function (data) {
				data['url'] = url['url'];
				(function (deferred) {
					return deferred.resolve(data);
				})(deferred);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				document.getElementById('loadingCircleDashboard').style.display =  'none';
				let errMsg = "처리 중 오류가 발생했습니다.<br/>에러 메세지:" + errorThrown;
				let r = formatErrorMessage(jqXHR, errorThrown);
				console.log("error===", r);
				$("#errMsg").html(errMsg);
				$("#errorModal").modal("show");
				setTimeout(function(){
					$("#errorModal").modal("hide");
				}, 2000);
				return false;
			});
		});

		$.when.apply($, deferreds).then(function () {
			Object.entries(arguments).forEach(arg => {
				const result = arg[1];
				if (!isEmpty(result)) {
					const targetUrl = result.url;
					if (targetUrl.match('/status/raw/site')) {
						let totalCount = 0;
						let runCount = 0;
						let stopCount = 0;
						let capacity = 0;
						let targetSid = '';
						let deviceFault = '';
						Object.entries(result).forEach(detail => {
							const deviceType = detail[0]
								, deviceData = detail[1];
							if (deviceType !== 'url' && deviceType.match('INV')) {
								targetSid = deviceData.sid;
								// capacity += deviceData.capacity;
			
								if (!isEmpty(deviceData.faultDesc)) {
									deviceFault = deviceData.dname;
									Object.entries(deviceData.faultDesc).forEach(fault => {
										deviceFault += '[' + deviceData.fault[0] + ']';
									});
								}

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

						tableData.forEach((site, index) => {

							if (site.sid === targetSid) {
								if (totalCount == 0) {
									tableData[index]['invCount'] = '-';
								} else {
									if (totalCount != stopCount) {
										tableData[index]['invCount'] = 'RUN (' + runCount + '/' + stopCount + '/' + totalCount + ')';
									} else {
										tableData[index]['invCount'] = 'INV (' + runCount + '/' + stopCount + '/' + totalCount + ')';;
									}
								}
								//tableData[index]['deviceFault'] = deviceFault;
							}
						});
					} else if (targetUrl.match('/energy/now/sites')) {
						tableData.forEach((site, index) => {
							let targetData = result.data[site.sid];
							if (result.interval === 'month') {
								if (isEmpty(targetData) || isEmpty(targetData.energy)) {
									tableData[index]['monthGen'] = '-';
								} else {
									tableData[index]['monthGen'] = !isNaN(targetData.energy) ? displayNumberFixedUnit(targetData.energy, 'W', 'MW', 2)[0] : '-';
								}
							} else {
								if (isEmpty(targetData)) {
									tableData[index]['nowEnergy'] = '-';
								} else {
									tableData[index]['nowEnergy'] = !isNaN(targetData.energy) ? displayNumberFixedUnit(targetData.energy, 'W', 'kW', 0)[0] : '-';
								}
							}
						});
					} else if (targetUrl.match('/weather/site')) {
						const weatherData = result['data'];
						if (result['interval'] === 'hour') { //오늘 날씨
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
						} else { //어제 날씨
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
						}
					} else if (targetUrl.match('/energy/sites')) {
						const interval = targetUrl.match('day');
						tableData.forEach((site, index) => {
							if (!isEmpty(result['data']) && !isEmpty(result['data'][site.sid])) {
								const siteEnergyItem = result['data'][site.sid];
								siteEnergyItem.forEach(siteEnergy => {
									const items = siteEnergy['items'];
									if (!isEmpty(items)) {
										let genEnergy = 0;
										items.map(e => genEnergy += e['energy']);
										if (interval) {
											tableData[index]['yesterEnergy'] = !isNaN(genEnergy) ? displayNumberFixedUnit(genEnergy, 'W', 'kW', 0)[0] : '-';
										} else {
											tableData[index]['beforeYearGen'] = !isNaN(genEnergy) ? displayNumberFixedUnit(genEnergy, 'W', 'kW', 0)[0] : '-';
										}
									}
								});
							}
						});
					} else if (targetUrl.match('/alarms')) {
						result.sort((a, b) => {
							return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
						});

						tableData.forEach((site, index) => {
							const alarm = result.find(e => site['sid'] == e.sid);
							if (!isEmpty(alarm)) {
								tableData[index]['deviceFault'] = alarm['message'];
							}
						});
					}
				}
			});

			tableData.forEach((data, index) => {
				if (isEmpty(data.beforeYearGen) || isEmpty(data.monthGen) ) {
					tableData[index]['proportion'] = '-'
				} else {
					tableData[index]['proportion'] = ((data.monthGen / data.beforeYearGen) * 100).toFixed(2);
				}
			});

			gmainTable.clear();
			gmainTable.rows.add(tableData).draw();
			$($.fn.dataTable.tables(true)).DataTable().columns.adjust();

			document.getElementById('loadingCircleDashboard').style.display =  'none';
		});
	}
</script>