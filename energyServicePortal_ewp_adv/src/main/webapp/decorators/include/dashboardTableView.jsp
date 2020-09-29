<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<%--<style type="text/css">--%>
<%--	.dataTable {table-layout: fixed}--%>
<%--</style>--%>
<div class="row content-wrapper hidden">
	<div class="col-12">
		<div class="indiv">
			<table id="gmainTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:12%">
					<col style="width:6%">
					<col style="width:13%">
					<col style="width:12%">
					<col style="width:7%">
					<col style="width:5%">
					<col style="width:7%">
					<col style="width:5%">
					<col style="width:7%">
					<col style="width:7%">
					<col style="width:7%">
					<col style="width:7%">
				</colgroup>
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
			scrollY: '720px',
			scrollCollapse: true,
			paging: false,
			order: [[ 1, 'asc' ]],
			sortable: true,
			columns: [
				{
					title: '순번',
					data: null,
					render: function ( data, type, full, rowIndex ) {
						return rowIndex.row + 1;
					},
					width: '5%',
					className: 'dt-center no-sorting'
				},
				{
					title: '발전소 명',
					data: 'siteName',
					width: '12%',
					className: 'dt-body-left dt-head-center'
				},
				{
					title: '발전용량 (kWh)',
					data: 'capacity',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					width: '6%',
					className: 'dt-body-right dt-head-center'
				},
				{
					title: '인버터 가동 상태',
					data: 'invCount',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					width: '13%',
					className: 'dt-body-center dt-head-center'
				},
				{
					title: '경고 알람',
					data: 'deviceFault',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					width: '12%',
					className: 'dt-body-center dt-head-center'
				},
				{
					title: '현재 발전량(kW)',
					data: 'nowEnergy',
					render: function (data, type, full, rowIndex) {
						if (data == '-') {
							return data;
						} else {
							return data[0];
						}
					},
					width: '7%',
					className: 'dt-body-right dt-head-center'
				},
				{
					title: "현재 날씨",
					data: 'toDaySky',
					render: function (data, type, full, rowIndex) {
						const weather = getWeatherIconClass(data);
						return '<i class="ico_weather ' + weather + '"></i>';
					},
					width: '5%',
					className: 'dt-body-center dt-head-center'
				},
				{
					title: '전일 발전',
					data: 'yesterEnergy',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					width: '7%',
					className: 'dt-body-right dt-head-center'
				},
				{
					title: '전일 날씨',
					data: 'yesterDaySky',
					render: function (data, type, full, rowIndex) {
						const weather = getWeatherIconClass(data);
						return '<i class="ico_weather ' + weather + '"></i>';
					},
					width: '5%',
					className: 'dt-body-center dt-head-center'
				},
				{
					title: '월간 발전량(MWh)',
					data: 'monthGen',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					width: '7%',
					className: 'dt-body-right dt-head-center'
				},
				{
					title: '전년 동월 발전량(MWh)',
					data: 'beforeYearGen',
					render: function (data, type, full, rowIndex) {
						return isEmpty(data) ? '-' : data;
					},
					width: '7%',
					className: 'dt-body-right dt-head-center'
				},
				{
					title: '전년 동월 대비 발전 비율(%)',
					data: 'proportion',
					render: function (data, type, full, rowIndex) {
						return data;
					},
					width: '7%',
					className: 'dt-body-right dt-head-center'
				},
			],
			"language": {
				"emptyTable": "조회된 데이터가 없습니다.",
				"zeroRecords":  "검색된 결과가 없습니다."
			},
			dom: 'tip'
		}).columns.adjust();

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

			//기상 정보 오늘
			urls.push({
				url: apiHost + '/weather/site?sid=' + site.sid + '&interval=hour',
				type: 'get',
				data: {
					startTime: yesterDayFormData.startTime,
					endTime: dayFormData.endTime,
				}
			});

			//기상 정보 어제
			urls.push({
				url: apiHost + '/weather/site?sid=' + site.sid + '&interval=day',
				type: 'get',
				data: {
					startTime: yesterDayFormData.startTime,
					endTime: yesterDayFormData.endTime,
				}
			});

			//어제 발전
			urls.push({
				url: apiHost + '/energy/sites?sid=' + site.sid,
				type: 'get',
				data: {
					startTime: yesterDayFormData.startTime,
					endTime: yesterDayFormData.endTime,
					interval: 'day'
				}
			});

			//작년 동월 발전
			urls.push({
				url: apiHost + '/energy/sites?sid=' + site.sid,
				type: 'get',
				data: {
					startTime: yearFormData.startTime,
					endTime: yearFormData.endTime,
					interval: 'month'
				}
			});

			siteArray.push(site.sid);
			tableData.push({
				sid: site.sid,
				siteName: site.name
			});
		});

		//오늘 발전
		if (siteArray.length > 0) {
			urls.push({
				url: apiHost + '/energy/now/sites',
				type: 'get',
				data: {
					sids: siteArray.join(','),
					metering_type: 2,
					interval: 'day'
				}
			});

			urls.push({
				url: apiHost + '/energy/now/sites',
				type: 'get',
				data: {
					sids: siteArray.join(','),
					metering_type: 2,
					interval: 'month'
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
			}).fail(function (error) {
				console.log(error);

				document.getElementById('loadingCircleDashboard').style.display =  'none';
				$('#errMsg').text("처리 중 오류가 발생했습니다.");
				$('#errorModal').modal('show');
				setTimeout(function(){
					$('#errorModal').modal('hide');
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
								capacity += deviceData.capacity;
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

								tableData[index]['capacity'] = (capacity / 1000).toFixed(2);
								tableData[index]['deviceFault'] = deviceFault;
							}
						});
					} else if (targetUrl.match('/energy/now/sites')) {
						tableData.forEach((site, index) => {
							let targetData = result.data[site.sid];
							if (result.interval === 'month') {
								if (isEmpty(targetData) || isEmpty(targetData.energy)) {
									tableData[index]['monthGen'] = '-';
								} else {
									tableData[index]['monthGen'] = targetData.energy > 0 ? displayNumberFixedUnit(targetData.energy, 'W', 'kW', 2)[0] : (targetData.energy / 1000).toFixed(2);
								}
							} else {
								if (isEmpty(targetData)) {
									tableData[index]['nowEnergy'] = '-';
								} else {
									tableData[index]['nowEnergy'] = targetData.energy > 0 ? displayNumberFixedUnit(targetData.energy, 'W', 'kW', 2) : (targetData.energy / 1000).toFixed(2);
								}
							}
						});
					} else if (targetUrl.match('/weather/site')) {
						if (result.length > 0) {
							tableData.forEach((site, index) => {
								if (targetUrl.match(site.sid)) {
									if (targetUrl.match('day')) { //전일
										tableData[index]['yesterDaySky'] = result[0].sky;
									} else { //당일
										result.reverse();
										result.forEach(rst => {
											if (rst.observed) {
												tableData[index]['toDaySky'] = rst.sky;
												return false;
											}
										});
									}
								}
							});
						}
					} else if (targetUrl.match('/energy/sites')) {
						const interval = result.interval;
						const genData = result.data[0].generation.items;
						tableData.forEach((site, index) => {
							if (targetUrl.match(site.sid)) {
								if (interval === 'day') { //어제 발전
									if (!isEmpty(genData) && genData.length > 0) {
										tableData[index]['yesterEnergy'] = (genData[0].energy / 1000).toFixed(2);
									}
								} else {
									if (!isEmpty(genData) && genData.length > 0) {
										tableData[index]['beforeYearGen'] = (genData[0].energy / 1000000).toFixed(2);
									}
								}
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