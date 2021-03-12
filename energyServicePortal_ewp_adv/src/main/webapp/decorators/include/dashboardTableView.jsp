<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row content-wrapper hidden">
	<div class="col-12">
		<div class="indiv">
			<table id="gmainTable" class="dashboard-table" >
				<colgroup>
					<col style="width:4%">  <!-- 순번 -->
					<col style="width:14%"> <!-- 발전소 명 -->
					<col style="width:9%">  <!-- 발전용량(kW) -->
					<col style="width:8%">  <!-- 인버터 가동 상태 -->
					<col style="width:5%">  <!-- 통신 상태 -->
					<col style="width:11%"> <!-- 경고 알람 -->
					<col style="width:7%">  <!-- 금일 발전시간 (Hrs) -->
					<col style="width:7%">  <!-- 금일 누적발전량(kWh) -->
					<col style="width:7%">  <!-- 현재 날씨 -->
					<col style="width:7%">  <!-- 전일 발전 시간(Hrs) -->
					<col style="width:7%">  <!-- 전일 발전량(kWh) -->
					<col style="width:7%">  <!-- 전일 날씨 -->
					<col style="width:7%">  <!-- 월간 발전량(MWh) -->
					<col style="width:7%">  <!-- 전년 동월 발전량(MWh) -->
					<col style="width:7%">  <!-- 전년 동월 대비 발전 비율(%) -->
				</colgroup>
				<thead></thead>
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
			"table-layout": "fixed",
			scrollX: true,
			scrollY: '720px',
			scrollCollapse: true,
			paging: false,
			order: [[ 1, 'asc' ]],
			sortable: true,
			columns: [
				{
					title: i18nManager.tr("dashboard.table.1"), // 순번
					data: null,
					render: function (data, type, full, rowIndex) {
						return rowIndex.row + 1;
					},
					className: 'dt-center no-sorting fixed'
				},
				{
					title: i18nManager.tr("dashboard.table.2"), // 발전소 명
					data: 'siteName',
					render: function (data, type, full, rowIndex) {
						return '<a href="javascript:pageMove(\'' + full['sid'] + '\', \'siteMain\'), \'self\'">' + data + '</a>' +
								'<button onclick="pageMove(\'' + full['sid'] + '\', \'siteMain\', \'blank\')" class="icon-open"></button>';
					},
					className: 'dt-head-left dt-body-left'
				},
				{
					title: i18nManager.tr("dashboard.table.3"), // 발전용량
					data: 'capacity',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.4"), // 인버터 가동상태
					data: 'invCount',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.status"), // 통신상태
					data: 'comStatus',
					render: function (data, type, full, rowIndex) {
						return `<span class="status-button ${'${data[0]}'}">${'${data[1]}'}</span>`;
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.5"), // 경고 알람
					data: 'deviceFault',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.nowTime"), // 금일 발전시간 | (신규) [금일 발전량 / 용량]
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['nowEnergy']) || isEmpty(full['capacity'])) {
							return '-'
						} else {
							const nowEnergy = Number(String(full['nowEnergy']).replace(/[^\d]/g, ''));
							const capacity = Number(String(full['capacity']).replace(/[^\d]/g, ''));
							const displayData = (capacity === 0) ? '0' : (Math.round(nowEnergy/capacity * 10) / 10)
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${today.format(\'yyyyMMdd\')}'}', 'hour', 'time')">${'${displayData}'}</a>`;
						}
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.6"), // 현재 발전량
					data: 'nowEnergy',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${today.format(\'yyyyMMdd\')}'}', 'hour')">${'${data}'}</a>`;
						}
					},
					className: 'dt-head-right dt-body-right'
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
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.10"), // 전일 발전시간
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['yesterEnergy']) || isEmpty(full['capacity'])) {
							return '-'
						} else {
							const yesterEnergy = Number(String(full['yesterEnergy']).replace(/[^\d]/g, ''));
							const capacity = Number(String(full['capacity']).replace(/[^\d]/g, ''));
							const displayData = (capacity === 0) ? '0' : (Math.round(yesterEnergy/capacity * 10) / 10)
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${yester.format(\'yyyyMMdd\')}'}', 'hour', 'time')">${'${displayData}'}</a>`;
						}
					},
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.8"), // 전일 발전량
					data: 'yesterEnergy',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-'
						} else {
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${yester.format(\'yyyyMMdd\')}'}', 'hour')">${'${data}'}</a>`;
						}
					},
					className: 'dt-head-right dt-body-right'
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
					className: 'dt-center'
				},
				{
					title: i18nManager.tr("dashboard.table.14"), // 지난달 발전시간
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['lastMonthGen']) || isEmpty(full['capacity'])) {
						 	return '-'
						} else {
							const lastMonthEnergy = Number(String(full['lastMonthGen']).replace(/[^\d]/g, ''));
							const capacity = Number(String(full['capacity']).replace(/[^\d]/g, ''));
							const displayData = (capacity === 0) ? '0' : (Math.round(lastMonthEnergy/capacity * 10) / 10)
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${lastMonth.format(\'yyyyMM\')}'}', 'day', 'time')">${'${displayData}'}</a>`;
						}
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.15"), // 지난달 발전량
					data: 'lastMonthGen',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${lastMonth.format(\'yyyyMM\')}'}', 'day')">${'${data}'}</a>`;
						}
					},
					className: 'dt-head-right dt-body-right'
				},
				{
					title: i18nManager.tr("dashboard.table.16"), // 지난달 일 평균 발전시간
					data: null,
					render: function (data, type, full, rowIndex) {
						if (isEmpty(full['lastMonthGen']) || isEmpty(full['capacity'])) {
							return '-'
						} else {
							const lastMonthEnergy = Number(String(full['lastMonthGen']).replace(/[^\d]/g, ''));
							const capacity = Number(String(full['capacity']).replace(/[^\d]/g, ''));
							const displayData = (capacity === 0) ? '0' : Math.round(((lastMonthEnergy/capacity) / lastDay) * 10) / 10;
							return `<a href="javascript:void(0);" onclick="goPvGen('${'${lastMonth.format(\'yyyyMM\')}'}', 'day', 'time')">${'${displayData}'}</a>`;
						}
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
				capacity: (!isEmpty(site.capacities) && !isEmpty(site.capacities.gen)) ? numberComma(Math.round(site.capacities.gen / 1000)) : '-',
				siteName: site.name
			});
		});

		let siteArray_temp = siteArray;

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

			//어제 발전
			urls.push({
				url: apiHost + '/energy/sites?interval=day',
				type: 'get',
				data: {
					sid: siteArray.toString(),
					startTime: yesterDayFormData.startTime,
					endTime: yesterDayFormData.endTime,
					displayType: 'dashboard',
					formId: 'v2'
				}
			});

			//작년 동월 발전
			urls.push({
				url: apiHost + '/energy/sites?interval=month',
				type: 'get',
				data: {
					sid: siteArray.toString(),
					startTime: beforeMonthFormData.startTime,
					endTime: beforeMonthFormData.endTime,
					displayType: 'dashboard',
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

			// 통신 상태
			
			urls.push({
				url: apiHost + "/get/status/health",
				type: "post",
				dataType: 'json',
				contentType: "application/json",
				data: JSON.stringify({
					sids: siteArray_temp.join(","),
					startTime: getTime(1, false)
				}),
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
				console.log("error===", r, url);
				$("#errMsg").html(errMsg);
				$("#errorModal").modal("show");
				setTimeout(function(){
					$("#errorModal").modal("hide");
					location.reload();
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
							if (isEmpty(targetData)) {
								tableData[index]['nowEnergy'] = '-';
							} else {
								tableData[index]['nowEnergy'] = !isNaN(targetData.energy) ? displayNumberFixedUnit(targetData.energy, 'W', 'kW', 0)[0] : '-';
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
											tableData[index]['lastMonthGen'] = !isNaN(genEnergy) ? displayNumberFixedUnit(genEnergy, 'W', 'kW', 0)[0] : '-';
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
					} else if (targetUrl.match('/get/status/health')) {
						tableData.forEach((site, index) => {
							const comStatus = result.sites.find(x => site.sid === x.sid);
							tableData[index]['comStatus'] = ["error", "이상"];
							if (!isEmpty(comStatus.rtus) && comStatus.rtus.length > 0) {
								tableData[index]['comStatus'] = ["normal", "정상"];
							}
						});
					}
				}
			});

			gmainTable.clear();
			gmainTable.rows.add(tableData).draw();
			$($.fn.dataTable.tables(true)).DataTable().columns.adjust();

			document.getElementById('loadingCircleDashboard').style.display =  'none';
		});
	}
</script>
