let apiDatas = new Object();
let yearData = getSiteMainSchCollection('year');
let monthData = getSiteMainSchCollection('month');
let yesterData = getSiteMainSchCollection('yesterday');
let yester2Data = getSiteMainSchCollection('beforeTwo');
let dayData = getSiteMainSchCollection('day');
let minIntervalCount = 0;
let siteListTable = null;

const resourceTemplate = new Object()
const chartColorArray = ['var(--circle-charge)', 'var(--grey)', 'var(--circle-solar-power)', 'var(--white)'];

//대시보드 먼슬리 && 데일리 차트 시리증 설정.
const seriesArray = [
	{name: '충전', type: 'column', color: 'var(--circle-charge)', data: 'chargeList', suffix: 'kWh'},
	{name: '방전', type: 'column', color: 'var(--grey)', data: 'dischargeList', suffix: 'kWh'},
	{name: '태양광', type: 'column', color: 'var(--circle-solar-power)', data: 'pvList', suffix: 'kWh'},
	{name: '정산금', type: 'spline', color: 'var(--white)', data: 'payList', suffix: '천원'},
];

// 특수문자 정규식 변수(공백 미포함)
const replaceChar = /[~!@\#$%^&*\()\-=+_'\;<>\/.\`:\"\\,\[\]?|{}]/gi;
// 완성형 아닌 한글 정규식
const replaceNotFullKorean = /[ㄱ-ㅎㅏ-ㅣ]/gi;

/**
 * 그룹 & 중개거래 대시보드targetUrl
 * 공통 이벤트 처리
 */
$(document).ready(function () {
	// 모든 table 헤더에 클릭 이벤트를 설정한다.
	var tables = document.getElementsByTagName("table");
	for (var i = 0; i < tables.length; ++i) {
		var headers = tables[i].getElementsByTagName("th");
		for (var j = 0; j < headers.length; ++j) {
			// 지역 유효범위에 생성할 중첩 함수
			(function (table, n) {
				headers[j].onclick = function () {
					let sort = 'down';
					if (this.getElementsByTagName('button')[0].classList.length == 1) {
						this.getElementsByTagName('button')[0].classList.add('down');
						sort = 'down';
					} else {
						if (this.getElementsByTagName('button')[0].classList[1] == 'up') {
							this.getElementsByTagName('button')[0].classList.replace('up', 'down');
							sort = 'down';
						} else {
							this.getElementsByTagName('button')[0].classList.replace('down', 'up');
							sort = 'up';
						}
					}

					for (var k = 0; k < headers.length; k++) {
						if (n != k) {
							headers[k].getElementsByTagName('button')[0].classList.remove('up');
							headers[k].getElementsByTagName('button')[0].classList.remove('down');
						}
					}
					SortTable(table, n, sort)
				};
			}(tables[i], j));
		}
	}

	//검색어 입력 제어 이벤트
	$("#searchName").on('focusout', function() {
		var x = $(this).val();
		if (x.length > 0) {
			if (x.match(replaceChar) || x.match(replaceNotFullKorean)) {
				x = x.replace(replaceChar, '').replace(replaceNotFullKorean, '');
			}
			$(this).val(x);
		}
	}).on('keyup', function() {
		$(this).val($(this).val().replace(replaceChar, ''));
	});

	siteListTable = $('#siteList').DataTable({
		autoWidth: true,
		fixedHeader: true,
		scrollY: '550px',
		scrollCollapse: true,
		sortable: true,
		pageLength: -1,
		retrieve: true,
		order: [[8, 'asc']],
		rowGroup: {
			startRender: function (rows, group) {
				//발전 용량
				let capacitySum = rows.data().pluck('capacity').reduce(function (a, b) {
					return a + Number(String(b).replace(/[^\d]/g, ''));
				}, 0);
				capacitySum = $.fn.dataTable.render.number(',', '.', 0, '').display(capacitySum);

				//현재 출력
				let activePowerSum = rows.data().pluck('activePower').reduce(function (a, b) {
					return a + Number(String(b).replace(/[^\d]/g, ''));
				}, 0);
				activePowerSum = $.fn.dataTable.render.number(',', '.', 0, '').display(activePowerSum);

				//출력 제어
				let targetActivePowerSum = rows.data().pluck('targetActivePower').reduce(function (a, b) {
					return a + Number(String(b).replace(/[^\d]/g, ''));
				}, 0);
				targetActivePowerSum = $.fn.dataTable.render.number(',', '.', 0, '').display(targetActivePowerSum);

				return $('<tr/>')
				.append('<td class="dt-center">' + group + '</td>')
				.append('<td class="dt-center">' + rows.count() + '</td>')
				.append('<td/>')
				.append('<td/>')
				.append('<td class="dt-right">' + capacitySum + '</td>')
				.append('<td class="dt-right">' + activePowerSum + '</td>')
				.append('<td class="dt-right">' + targetActivePowerSum + '</td>')
				.append('<td/>');
			},
			endRender: null,
			dataSrc: 'resourceName'
		},
		columns: [
			{
				title: '지역',
				data: 'location',
				render: function ( data, type, full, rowIndex ) {
					return isEmpty(data) ? '-' : data;
				},
				width: '10%',
				className: 'dt-center no-sorting'
			},
			{
				title: '발전소',
				data: 'name',
				width: '15%',
				className: 'dt-body-left dt-head-center'
			},
			{
				title: '송신',
				data: 'lastTargetActivePowerReqDate',
				render: function (data, type, full, rowIndex) {
					if (isEmpty(data) || data === '-') {
						return '<span class="status status_err" title="에러">에러</span>';
					} else {
						return '<span class="status status_drv" title="확인 중">확인 중</span>';
					}
				},
				width: '10%',
				className: 'dt-center'
			},
			{
				title: '수신',
				data: 'lastTargetActivePowerRecvDate',
				render: function (data, type, full, rowIndex) {
					if (isEmpty(data) || data === '-') {
						return '<span class="status status_err" title="에러">에러</span>';
					} else {
						const recvDate = new Date(String(data).replace(/[^0-9]/g,'').replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$2/$3/$1 $4:$5:$6'));
						let diffTime = Math.floor(((new Date() - recvDate) / 1000) / 60 / 60 % 24);
						if (diffTime >= 1) {
							return '<span class="status status_err" title="에러">에러</span>';
						} else {
							return '<span class="status status_drv" title="확인 중">확인 중</span>';
						}

					}
				},
				width: '10%',
				className: 'dt-center'
			},
			{
				title: '발전용량',
				data: 'capacity',
				render: function (data, type, full, rowIndex) {
					return isEmpty(data) ? '-' : data;
				},
				width: '10%',
				className: 'dt-right'
			},
			{
				title: '현재출력',
				data: 'activePower',
				render: function (data, type, full, rowIndex) {
					return isEmpty(data) ? '-' : data;
				},
				width: '10%',
				className: 'dt-right'
			},
			{
				title: "출력제어",
				data: 'targetActivePower',
				render: function (data, type, full, rowIndex) {
					return isEmpty(data) ? '-' : data;
				},
				width: '10%',
				className: 'dt-right'
			},
			{
				title: '최근 오류 내용',
				data: 'faultDesc',
				render: function (data, type, full, rowIndex) {
					return isEmpty(data) ? '-' : data;
				},
				width: '25%',
				className: 'dt-center'
			},
			{
				title: '발전유형',
				data: 'resourceName',
				visible: false
			}
		],
		language: {
			emptyTable: '조회된 데이터가 없습니다.',
			zeroRecords:  '검색된 결과가 없습니다.'
		},
		dom: 'tip',
		drawCallback: function (settings) {
			console.log(settings);
		}
	}).columns.adjust();

	$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
});

/**
 * 페이지 초기 진입시
 * 필요한 데이터를 모두 조회한다.
 */
const firstAjax = () => {
	setInitList('alarmNotice'); //알람 공지 세팅
	setInitList('resourceULList'); //발전형
	setInitList('locationULList'); //위치

	yearData = getSiteMainSchCollection('year');
	monthData = getSiteMainSchCollection('month');
	yesterData = getSiteMainSchCollection('yesterday');
	yester2Data = getSiteMainSchCollection('beforeTwo');
	dayData = getSiteMainSchCollection('day');

	const siteSids = new Array();
	const rtuIds = new Array();

	let urls = new Array();
	let ess = false;

	const locationArray = new Array();
	const resourceTypeArray = new Array();

	siteList.forEach(site => {
		const rtus = site.rtus;
		siteSids.push(site.sid);

		//RTU 아이디를 수집한다.
		if (!isEmpty(rtus)) {
			rtus.forEach(rtu => {
				rtuIds.push(rtu.rid);
			});
		}

		urls.push({
			url: apiHost + '/config/view/properties',
			type: 'get',
			async: false,
			data: {
				types: 'resource'
			}
		});

		//1년 에너지 데이터
		urls.push({
			url: apiHost + '/energy/sites?interval=month',
			type: 'GET',
			data: {
				sid: site.sid,
				startTime: yearData.startTime,
				endTime: yearData.endTime,
				displayType: 'dashboard'
			}
		});

		//1달 에너지 데이터
		urls.push({
			url: apiHost + '/energy/sites?interval=day&startTime=' + monthData.startTime + '&endTime=' +monthData.endTime,
			type: 'GET',
			data: {
				sid: site.sid,
				displayType: 'dashboard'
			}
		});

		//어제 에너지 데이터
		urls.push({
			url: apiHost + '/energy/sites?interval=day&startTime=' + yesterData.startTime + '&endTime=' +yesterData.endTime,
			type: 'GET',
			data: {
				sid: site.sid,
				displayType: 'dashboard'
			}
		});

		//어제 에너지 데이터
		urls.push({
			url: apiHost + '/energy/sites?interval=day&startTime=' + yester2Data.startTime + '&endTime=' +yester2Data.endTime,
			type: 'GET',
			data: {
				sid: site.sid,
				displayType: 'dashboard'
			}
		});

		urls.push({
			url: apiHost + '/status/raw/site',
			type: 'GET',
			data: {
				sid: site.sid,
				formId: 'v2'
			}
		});

		urls.push({
			url: apiHost + '/weather/site?sid=' + site.sid,
			type: 'get',
			data: {
				startTime: dayData.startTime,
				endTime: dayData.endTime,
				interval: 'hour'
			}
		});

		if (site.devices != null) {
			const devices = site.devices;
			devices.forEach(device => {
				if ((device.device_type.toUpperCase()).match('ESS')) {
					ess = true;
				}
			});
		}
	});

	//현재 발전량
	urls.push({
		url: apiHost + '/energy/now/sites?interval=month',
		type: 'GET',
		data: {
			sids: siteSids.toString(),
			metering_type: 2
		}
	});

	//현재 발전량
	urls.push({
		url: apiHost + '/energy/now/sites?interval=day',
		type: 'GET',
		data: {
			sids: siteSids.toString(),
			metering_type: 2
		}
	});

	if (rtuIds.length > 0) {
		urls.push({
			url: apiHost + '/control/command_history',
			type: 'GET',
			data: {
				oid: oid,
				rids: rtuIds.toString(),
				cmdTypes: 'kpx_targetPower',
				isRecent: true
			},
		})
	}


	//알람 이력
	urls.push({
		url: apiHost + '/alarms',
		type: 'GET',
		data: {
			sids: siteSids.toString(),
			startTime: dayData.startTime,
			endTime: dayData.endTime,
			confirm: false
		}
	});

	if (!ess) {
		$('#statusSiteList').find('.ESS').remove();
	}
	//setInitList('siteList'); //사이트 리스트

	apiDatas = new Object();
	ajaxData(urls);
}

/**
 * 1분마다 갱신할 API 데이터
 */
const minAjax = () => {
	yearData = getSiteMainSchCollection('year');
	monthData = getSiteMainSchCollection('month');
	yesterData = getSiteMainSchCollection('yesterday');
	yester2Data = getSiteMainSchCollection('beforeTwo');
	dayData = getSiteMainSchCollection('day');

	const siteSids = new Array();
	let urls = new Array();

	siteList.forEach(site => {
		siteSids.push(site.sid);

		urls.push({
			url: apiHost + '/energy/now/sites',
			type: 'GET',
			data: {
				sids: site.sid,
				metering_type: 2,
				interval: 'day'
			}
		});

		urls.push({
			url: apiHost + '/status/raw/site',
			type: 'GET',
			data: {
				sid: site.sid,
				formId: 'v2'
			}
		});
	});

	//알람 이력
	urls.push({
		url: apiHost + '/alarms',
		type: 'GET',
		data: {
			sids: siteSids.toString(),
			startTime: dayData.startTime,
			endTime: dayData.endTime,
			confirm: false
		},
	});

	delete apiDatas[apiHost + '/energy/now/sites'];
	delete apiDatas[apiHost + '/status/raw/site'];
	delete apiDatas[apiHost + '/alarms'];

	ajaxData(urls, 'min');
}

/**
 * ajaxReturn Data 처리
 *
 * @param urls
 * @param target min:1분단위, hour:1시간단위
 */
const ajaxData = (urls, target) => {
	document.getElementById('loadingCircleDashboard').style.display =  '';
	let deferreds = new Array();

	//ajax 한번에 실행
	urls.forEach(function (url) {
		let deferred = $.Deferred();
		deferreds.push(deferred);

		$.ajax(url).done(function (data) {
			data['url'] = url['url'];
			(function (deferred) {
				return deferred.resolve(data);
			})(deferred);
		}).fail(function (error) {
			console.error(error);

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
				let targetUrl = result.url; //API_URL
				let siteId = '';

				delete result['url'];
				if ((!targetUrl.match('/weather/site') && isEmpty(apiDatas[targetUrl])) || (targetUrl.match('/weather/site') && isEmpty(apiDatas[apiHost + '/weather/site']))) {
					if (targetUrl.match('/status/raw/site') || targetUrl.match('/weather/site')) {
						if (targetUrl.match('/status/raw/site')) {
							Object.entries(result).forEach(rtn => {
								if (rtn[0] !== 'url') {
									const data = rtn[1];
									if (!isEmpty(data.sid)) {
										siteId = data.sid;
									}
								}
							});
						} else {
							const weatherApi = apiHost + '/weather/site';
							siteId = targetUrl.replace(weatherApi + '?sid=', '');
							targetUrl = weatherApi;
						}

						apiDatas[targetUrl] = new Object();
						apiDatas[targetUrl][siteId] = result;
					} else {
						apiDatas[targetUrl] = result;
					}
				} else if (targetUrl.match('/config/view/properties')) {
					Object.entries(result.resource).map(obj => {
						if (langStatus == 'KO') {
							resourceTemplate[obj[1].code] = obj[1].name.kr;
						} else {
							resourceTemplate[obj[1].code] = obj[1].name.en;
						}
					});
				} else {
					if (targetUrl.match('/energy/sites')) {
						let rtnData = apiDatas[targetUrl].data;
						(result.data).forEach(rtn => {
							rtnData.push(rtn);
						});
						apiDatas[targetUrl].data = rtnData;
					} else if (targetUrl.match('/status/raw/site') || targetUrl.match('/weather/site')) {
						if (targetUrl.match('/status/raw/site')) {
							Object.entries(result).forEach(rtn => {
								if (rtn[0] !== 'url') {
									const data = rtn[1];
									if (!isEmpty(data.sid)) {
										siteId = data.sid;
									}
								}
							});
						} else {
							const weatherApi = apiHost + '/weather/site';
							siteId = targetUrl.replace(weatherApi + '?sid=', '');
							targetUrl = weatherApi;
						}

						if (!isEmpty(siteId)) {
							apiDatas[targetUrl][siteId] = result;
						}
					} else {
						let rtnData = apiDatas[targetUrl].data;
						if (Array.isArray(rtnData) && Array.isArray(rtnData)) {
							(result.data).forEach(rtn => {
								rtnData.push(rtn);
							});
							apiDatas[targetUrl].data = rtnData;
						} else {
							let nArray = new Array();
							nArray.push(result);
							apiDatas[targetUrl] = nArray;
						}
					}
				}
			}
		});

		if (target === 'min') {
			getTodayTotalDetail();
			alarmInfoList();
		} else {
			const locationArray = new Array();
			const resourceTypeArray = new Array();
			siteList.forEach(site => {
				if (isEmpty(locationArray.find(location => location['loc'] === site.location))) {
					locationArray.push({
						loc: site.location
					});
				}

				if (isEmpty(resourceTypeArray.find(resource => resource['resourceCode'] === site.resource_type))) {
					resourceTypeArray.push({
						resourceCode: site.resource_type,
						resourceName: resourceTemplate[site.resource_type]
					});
				}
			});

			setMakeList(locationArray, 'locationULList', {'dataFunction': {}}); //list생성
			setMakeList(resourceTypeArray, 'resourceULList', {'dataFunction': {}}); //list생성

			monthlyChartDraw();
			dailyChartDraw();
			typeSiteDraw();
			getTodayTotalDetail();
			alarmInfoList();
			searchSite();
		}

		document.getElementById('loadingCircleDashboard').style.display =  'none';
	});
}

/**
 * 월간 차트
 * 조회기간 1년
 *
 * @returns {Promise<void | boolean>}
 */
const monthlyChartDraw = async () => {
	const targetApi = [apiHost + '/energy/sites?interval=month', apiHost + '/energy/now/sites?interval=month'];

	$(`.gmain_chart1 span.term`).text(today.getFullYear() + '.1.1 ~ ' + today.getFullYear() + '.' + (Number(today.getMonth()) + 1) + '.' + today.getDate());
	return new Promise(resolve => {
		const pvList = new Object()
			, sumObj = new Object();

		targetApi.forEach((targetUrl, index) => {
			const apiData = apiDatas[targetUrl];
			if (index === 0) {
				if (!isEmpty(apiData)) {
					const siteEnergyData = apiData['data'];
					if (!isEmpty(siteEnergyData)) {
						siteEnergyData.forEach(siteEnergy => {
							const siteData = siteList.find(site => site.sid === siteEnergy.sid)
								, generation = siteEnergy['generation'];

							if (!isEmpty(generation)) { //태양광
								const items = generation.items;
								items.forEach(item => {
									if (!isEmpty(item['energy'])) {
										const index = Number(String(item['basetime']).slice(4, 6)) - 1;

										if (isEmpty(pvList[siteData['resource_type']])) {
											pvList[siteData['resource_type']] = new Array(12).fill(0);
											sumObj[siteData['resource_type']] = 0;
										}

										pvList[siteData['resource_type']][index] += Math.floor(item['energy']);
										sumObj[siteData['resource_type']] += Math.floor(item['energy']);
									}
								});
							}
						});
					}
				}
			} else {
				if (!isEmpty(apiData)) {
					const siteNowEnergyData = apiData['data'];
					Object.entries(siteNowEnergyData).forEach(([siteKey, nowEnergy]) => {
						if (!isEmpty(nowEnergy['energy'])) {
							const siteData = siteList.find(site => site.sid === siteKey)
								, index = Number(String(nowEnergy['start']).slice(4, 6)) - 1;

							if (isEmpty(pvList[siteData['resource_type']])) {
								pvList[siteData['resource_type']] = new Array(12).fill(0);
								sumObj[siteData['resource_type']] = 0;
							}

							pvList[siteData['resource_type']][index] += Math.floor(nowEnergy['energy']);
							sumObj[siteData['resource_type']] += Math.floor(nowEnergy['energy']);
						}
					});
				}
			}
		});

		const resolveData = {
			pvList: pvList,
			sumObj: sumObj
		}
		resolve(resolveData);
	}).then(resolveData => {
		const pvList = resolveData['pvList']
			, sumObj = resolveData['sumObj'];

		let maxValue = 0;
		Object.entries(pvList).forEach(([type, dataArray]) => {
			dataArray.forEach(data => {
				if (data > maxValue) {
					maxValue = data;
				}
			});
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'Wh', 3, 2);
		const rtnUnit = refineMaxValue[1];
		Object.entries(pvList).forEach(([type, dataArray]) => {
			dataArray.forEach((data, index) => {
				const refineValue = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
				pvList[type][index] = (refineValue[0] == '-' || refineValue[0] == 0) ? 0 : Number((refineValue[0]).replace(/[^0-9]/g, ''));
			});
		});

		let str = '';
		let seriesLength = monthlyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			monthlyChart.series[i].remove();
		}

		Object.entries(resourceTemplate).forEach(([code, txt]) => {
			if (!isEmpty(pvList[code])) {
				let chartSeries = new Object();
				chartSeries['name'] = txt;
				chartSeries['type'] = 'column';
				chartSeries['color'] = chartColorArray[code];
				chartSeries['data'] = pvList[code];
				chartSeries['tooltip'] = {valueSuffix: 'kWh'}
				monthlyChart.addSeries(chartSeries, false);
			}

			if (!isEmpty(sumObj[code])) {
				const refineValue = displayNumberFixedDecimal(sumObj[code], 'Wh', 3, 2);
				str += '<li class="pv">' + txt + ' : ' + refineValue.join(' ') + '</li>';
			}
		});

		monthlyChart.yAxis[0].setTitle({
			text: rtnUnit,
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: 15,
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		});
		monthlyChart.redraw();

		$('#monthlySum').append(str);

	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

/**
 * 일별차트 데이터 가공
 *
 * @returns {Promise<void | boolean>}
 */
const dailyChartDraw = async () => {
	const targetApi = [apiHost + '/energy/sites?interval=day&startTime=' + monthData.startTime + '&endTime=' + monthData.endTime, apiHost + '/energy/now/sites?interval=day'];
	const lastDay = new Date(today.getFullYear(), today.getMonth() + 2, 0);

	const categories = new Array();
	for (let i = 1; i <= lastDay.getDate(); i++) {
		categories.push(String(i));
	}

	$(`.gmain_chart2 span.term`).text(today.format('yyyy.MM') + '.1 ~ ' + today.format('yyyy.MM') + '.' + today.getDate());

	return new Promise(resolve => {
		const pvList = new Object()
			, sumObj = new Object();

		targetApi.forEach((targetUrl, index) => {
			const apiData = apiDatas[targetUrl];
			if (index === 0) {
				if (!isEmpty(apiData)) {
					const siteEnergyData = apiData['data'];
					if (!isEmpty(siteEnergyData)) {
						siteEnergyData.forEach(siteEnergy => {
							const siteId = siteEnergy['sid']
								, siteData = siteList.find(site => site.sid === siteId)
								, generation = siteEnergy['generation'];

							if (!isEmpty(generation)) { //태양광
								const items = generation.items;
								items.forEach(item => {
									const index = Number(String(item['basetime']).slice(6, 8)) - 1;

									if (isEmpty(pvList[siteData['resource_type']])) {
										pvList[siteData['resource_type']] = new Array(lastDay.getDate()).fill(0);
										sumObj[siteData['resource_type']] = 0;
									}

									pvList[siteData['resource_type']][index] += Math.floor(item['energy']);
									sumObj[siteData['resource_type']] += Math.floor(item['energy']);
								});
							}
						});
					}
				}
			} else {
				if (!isEmpty(apiData)) {
					const siteNowEnergyData = apiData['data'];
					Object.entries(siteNowEnergyData).forEach(([siteKey, nowEnergy]) => {
						const siteData = siteList.find(site => site.sid === siteKey)
							, index = Number(String(nowEnergy['start']).slice(6, 8)) - 1;

						if (!isEmpty(nowEnergy['energy'])) {
							if (isEmpty(pvList[siteData['resource_type']])) {
								pvList[siteData['resource_type']] = new Array(lastDay.getDate()).fill(0);
								sumObj[siteData['resource_type']] = 0;
							}

							pvList[siteData['resource_type']][index] += Math.floor(nowEnergy['energy']);
							sumObj[siteData['resource_type']] += Math.floor(nowEnergy['energy']);
						}
					});
				}
			}
		});

		const resolveData = {
			pvList: pvList,
			sumObj: sumObj
		}
		resolve(resolveData);
	}).then(resolveData => {
		const pvList = resolveData['pvList']
			, sumObj = resolveData['sumObj'];

		let maxValue = 0;
		Object.entries(pvList).forEach(([type, dataArray]) => {
			dataArray.forEach(data => {
				if (data > maxValue) {
					maxValue = data;
				}
			});
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'Wh', 3, 2);
		const rtnUnit = refineMaxValue[1];
		Object.entries(pvList).forEach(([type, dataArray]) => {
			dataArray.forEach((data, index) => {
				const refineValue = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
				pvList[type][index] = (refineValue[0] == '-' || refineValue[0] == 0) ? 0 : Number((refineValue[0]).replace(/[^0-9]/g, ''));
			});
		});

		let str = '';
		let seriesLength = dailyChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			dailyChart.series[i].remove();
		}

		Object.entries(resourceTemplate).forEach(([code, txt]) => {
			if (!isEmpty(pvList[code])) {
				let chartSeries = new Object();
				chartSeries['name'] = txt;
				chartSeries['type'] = 'column';
				chartSeries['color'] = chartColorArray[code];
				chartSeries['data'] = pvList[code];
				chartSeries['tooltip'] = {valueSuffix: 'kWh'}
				dailyChart.addSeries(chartSeries, false);

				if (!isEmpty(sumObj[code])) {
					if (!isEmpty(sumObj[code])) {
						const refineValue = displayNumberFixedDecimal(sumObj[code], 'Wh', 3, 2);
						str += '<li class="pv">' + txt + ' : ' + refineValue.join(' ') + '</li>';
					}
				}
			}
		});
		dailyChart.xAxis[0].setCategories(categories);
		dailyChart.yAxis[0].setTitle({
			text: rtnUnit,
			align: 'low',
			rotation: 0, /* 타이틀 기울기 */
			y: 25, /* 타이틀 위치 조정 */
			x: 15,
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		});
		dailyChart.redraw(); // 차트 데이터를 다시 그린다
		$('#dailySum').append(str);
	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

const typeSiteDraw = async () => {
	const targetApi = [apiHost + '/energy/sites?interval=day&startTime=' + yesterData.startTime + '&endTime=' +yesterData.endTime, apiHost + '/energy/sites?interval=day&startTime=' + yester2Data.startTime + '&endTime=' +yester2Data.endTime];
	let categories = new Array();

	$(`.gmain_chart3 span.term`).text(today.getFullYear() + '.' + (Number(today.getMonth()) + 1) + '.' + today.getDate());

	return new Promise((resolve, reject) => {
		const siteGenArray = new Array(siteList.length).fill(0);
		const siteForeGenArray = new Array(siteList.length).fill(0);

		targetApi.forEach((targetApiUrl, index) => {
			const apiData = apiDatas[targetApiUrl];
			if (!isEmpty(apiData)) {
				const energyData = apiData['data'];

				energyData.forEach(energySiteData => {
					const generation = energySiteData['generation']
						, siteId = energySiteData['sid'];

					if (isEmpty(siteGenArray[siteId])) {
						siteGenArray[siteId] = 0;
						siteForeGenArray[siteId] = 0;
					}

					if (!isEmpty(generation.items)) {
						(generation.items).forEach(items => {
							const energy = items['energy'];

							if (!isEmpty(energy)) {
								if (index === 0) {
									siteGenArray[siteId] += energy;
								} else {
									siteForeGenArray[siteId] += energy;
								}
							}
						});
					}
				});
			}
		});

		const resolveData = {
			siteGenArray: siteGenArray,
			siteForeGenArray: siteForeGenArray
		}
		resolve(resolveData);
	}).then(resolveData => {
		const siteGenArray = resolveData['siteGenArray']
			, siteForeGenArray = resolveData['siteForeGenArray']
			, categories = new Array();

		let maxValue = 0;
		Object.entries(siteGenArray).forEach(([siteId, data]) => {
			if (data > maxValue) {
				maxValue = data;
			}
		});

		Object.entries(siteForeGenArray).forEach(([siteId, data]) => {
			if (data > maxValue) {
				maxValue = data;
			}
		});

		const refineMaxValue = displayNumberFixedDecimal(maxValue, 'Wh', 3, 2);
		const rtnUnit = refineMaxValue[1];
		Object.entries(siteGenArray).forEach(([siteId, data]) => {
			const refineValue = displayNumberFixedUnit(data, 'Wh', 'kWh', 2);
			siteGenArray[siteId] = (refineValue[0] == '-' || refineValue[0] == 0) ? 0 : Number((refineValue[0]).replace(/[^0-9 \.]/, ''));
			maxValue = data;
		});

		Object.entries(siteForeGenArray).forEach(([siteId, data]) => {
			const refineValue = displayNumberFixedUnit(data, 'Wh', 'kWh', 2);
			siteForeGenArray[siteId] = (refineValue[0] == '-' || refineValue[0] == 0) ? 0 : Number((refineValue[0]).replace(/[^0-9 \.]/, ''));
			maxValue = data;
		});

		let tempGenArray = new Array()
		  , tempForeArray = new Array();

		siteList.forEach(site => {
			const sid = site.sid
				, siteName = site.name
				, siteGen = isEmpty(siteGenArray[sid]) ? 0 : siteGenArray[sid]
				, siteForeGen = isEmpty(siteForeGenArray[sid]) ? 0 : siteForeGenArray[sid];

			tempGenArray.push(siteGen);
			tempForeArray.push(siteForeGen);
			categories.push(siteName);
		});

		let seriesLength = typeSiteCurrent.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			typeSiteCurrent.series[i].remove();
		}

		typeSiteCurrent.addSeries({
			name: '전일 발전',
			color: 'var(--turquoise)',
			data: tempGenArray,
			tooltip: {
				valueSuffix: rtnUnit
			}
		});

		typeSiteCurrent.addSeries({
			name: '그제 발전',
			color: 'var(--grey)',
			data: tempForeArray,
			tooltip: {
				valueSuffix: rtnUnit
			}
		});
		typeSiteCurrent.xAxis[0].setCategories(categories);
		typeSiteCurrent.yAxis[0].setTitle({
			text: rtnUnit,
			style: {
				color: 'var(--white60)',
				fontSize: '12px'
			}
		});
		typeSiteCurrent.redraw(); // 차트 데이터를 다시 그린다

		let str = '';
		let genSum = 0;
		let genForecastSum = 0;

		if(!isEmpty(tempGenArray)){
			genSum = tempGenArray.reduce((acc, val) => { return acc + val } , 0);
			str += '<li class="charge">전일 발전 : ' + displayNumberFixedDecimal(genSum, 'kWh', 3, 2).join(' ') + '</li>';
		}

		if(!isEmpty(tempForeArray)){
			genForecastSum = tempForeArray.reduce((acc, val) => { return acc + val } , 0);
			str += '<li class="discharge">그제 발전 : ' + displayNumberFixedDecimal(genForecastSum, 'kWh', 3, 2).join(' ') + '</li>';
		}

		$("#yesterdaySum").append(str);

	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

/**
 * 현재출력 데이터 정제
 *
 * @returns {Promise<unknown>}
 */
const getTodayTotalDetail = async function () {
	const targetApi = [apiHost + '/status/raw/site', apiHost + '/energy/now/sites'];
	const resourceByStatus = document.querySelectorAll('#centerTbody tr td');
	const targetArea = document.querySelectorAll('.gmain_chart4 .chart_box .chart_info .ci_right ul li');

	resourceByStatus.forEach((td, index) => {
		if (index !== 0 && index !== 3){
			td.innerHTML = ' - ';
		}
	});

	targetArea.forEach(target => {
		target.querySelector('span').innerHTML = '';
	});

	return new Promise((resolve, reject) => {
		const rawStatus = new Object();
		targetApi.forEach((apiUrl, index) => {
			if (!isEmpty(apiDatas[apiUrl])) {
				if (index === 0) {
					Object.entries(apiDatas[apiUrl]).forEach(([apiKey, apiData]) => {
						if (isEmpty(apiKey)) return false;
						const siteData = siteList.find(site => site.sid === apiKey);
						let acPowerSum = 0
							, capacitySum = 0
							, targetActivePowerSum = 0;
						Object.entries(apiData).forEach(([deviceType, deviceData]) => {
							if (deviceType === 'KPX_EMS') {
								if (!isEmpty(deviceData['activePower'])) acPowerSum += deviceData['activePower'];
								if (!isEmpty(deviceData['capacity'])) capacitySum += deviceData['capacity'];
								if (!isEmpty(deviceData['targetActivePower'])) targetActivePowerSum += deviceData['targetActivePower'];

								if ($('.dbTime').data('timestamp') === undefined || ($('.dbTime').data('timestamp') != undefined && Number($('.dbTime').data('timestamp')) < deviceData['timestamp'])) {
									const dbTime = new Date(deviceData['timestamp']);
									$('.dbTime').data('timestamp', deviceData['timestamp']).text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
								}
							}
						});

						if (isEmpty(rawStatus[siteData['resource_type']])) {
							rawStatus[siteData['resource_type']] = {
								activePower: acPowerSum,
								capacity: capacitySum,
								targetActivePower: targetActivePowerSum,
								siteCount: 1
							}
						} else {
							rawStatus[siteData['resource_type']]['activePower'] += acPowerSum;
							rawStatus[siteData['resource_type']]['capacity'] += capacitySum;
							rawStatus[siteData['resource_type']]['targetActivePower'] += targetActivePowerSum;
							rawStatus[siteData['resource_type']]['siteCount'] += 1;
						}
					});
				}
			}
		});

		resolve(rawStatus);
	}).then(rawStatus => {
		let deviceArray = new Array()
		  , acPower = 0
		  , capacitySum = 0;

		let tempSolarA = 0;
		let tempWindA = 0;

		Object.entries(rawStatus).forEach(([resourceType, resourceData]) => {
			capacitySum += resourceData['capacity']
		});

		Object.entries(rawStatus).forEach(([resourceType, resourceData]) => {
			let aPower = resourceData['activePower']
			  , capacity = resourceData['capacity']
			  , tPower = resourceData['targetActivePower']
			  , siteCount = resourceData['siteCount'];

			let prevVal1 = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text().replace(/[^0-9]/g, ''));
			$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(1) span').text(numberComma(Math.floor(prevVal1 += (aPower / 1000))));

			let prevVal2 = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text().replace(/[^0-9]/g, ''));
			$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(2) span').text(numberComma(Math.floor(prevVal2 += (tPower / 1000))));

			let prevVal3 = Number($('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(3) span').text().replace(/[^0-9]/g, ''));
			$('.gmain_chart4 .chart_box .chart_info .ci_right ul li:nth-child(3) span').text(numberComma(Math.floor(prevVal3 += (capacity / 1000))));

			acPower += aPower;

			if (resourceType == 1) {
				tempSolarA =+ resourceData['activePower'];
				deviceArray.push({
					color: 'var(--circle-solar-power)',
					name: resourceTemplate[resourceType],
					dataLabels: {
						enabled: false
					},
					y: Math.floor((tempSolarA / capacitySum) * 100)
				});

				$('#centerTbody tr:eq(0) td:nth-child(4)').html('태양광'); //구분
				$('#centerTbody tr:eq(0) td:nth-child(5)').html(siteCount + '<em>&nbsp;&nbsp;개소</em>'); //사업소
				$('#centerTbody tr:eq(0) td:nth-child(6)').html(numberComma(Math.floor((capacity / 1000)) + '<em>&nbsp;&nbsp;kW</em>')); //설비용량
			} else if (resourceType == 2) {
				tempWindA =+ resourceData['activePower'];

				deviceArray.push({
					color: 'var(--summer-sky)',
					name: resourceTemplate[resourceType],
					dataLabels: {
						enabled: false
					},
					y: Math.floor((tempWindA / capacitySum) * 100)
				});

				$('#centerTbody tr:eq(0) td:nth-child(1)').html('풍력'); //구분
				$('#centerTbody tr:eq(0) td:nth-child(2)').html(siteCount + '<em>&nbsp;&nbsp;개소</em>'); //사업소
				$('#centerTbody tr:eq(0) td:nth-child(3)').html(numberComma(Math.floor((capacity / 1000)) + '<em>&nbsp;&nbsp;kW</em>')); //설비용량
			}
		});

		pieChart.setTitle({text: Math.floor(acPower / 1000) + 'kW'});
		const usage = Math.floor((acPower / capacitySum) * 100);
		const other = 100 - usage;
		
		deviceArray.push({
			color: 'var(--grey)',
			name: '미사용량',
			dataLabels: {
				enabled: false
			},
			y: other
		});

		let seriesData = {
			type: 'pie',
			innerSize: '70%',
			name: '발전량',
			colorByPoint: true,
			data: deviceArray
		};

		let seriesLength = pieChart.series.length;
		for (let i = seriesLength - 1; i > -1; i--) {
			pieChart.series[i].remove();
		}

		pieChart.addSeries(seriesData, false);
		pieChart.redraw();
	}).catch((error) => {
		console.error('처리 중 오류 발생');
		console.error(error);
		return false;
	});
}

/**
 * 알람 이력 리스트 생성
 *
 * @returns {Promise<void>}
 */
const alarmInfoList = async () => {
	const targetApi = [apiHost + '/alarms'];

	Object.entries(apiDatas).forEach(rst => {
		const apiUrl = rst[0]
			, apiDatas = rst[1];

		if (targetApi.includes(apiUrl)) {
			if (!isEmpty(apiDatas)) {
				//localtime 오름차순 정렬
				apiDatas.sort((a, b) => {
					return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
				});

				let alarmList = new Array();
				apiDatas.forEach(alarm => {
					if(alarm.level !== 0) {
						let localTime = (alarm.localtime != null && alarm.localtime != '') ? String(alarm.localtime) : '';
						alarm.standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
						alarmList.push(alarm);
					}
				});

				$('.a_alert').find('em').text(alarmList.length);
				setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}}); //list생성
			}
		}
	});
}

/**
 * 알람 이력 레벨 클래스
 * 리스트 작성시 level별 클래스 지정
 *
 * @param level
 * @returns {string}
 */
const levelClass = (level) => {
	let rtnClass = '';
	switch (level) {
		case 1 :
			rtnClass = 'warning';
			break;
		case 2 :
			rtnClass = 'critical';
			break;
		case 3 :
			rtnClass = 'shutoff';
			break;
		case 4 :
			rtnClass = 'urgent';
			break;
		case 0 :
			rtnClass = 'info';
			break;
		default :
			rtnClass = '';
	}

	return rtnClass;
}

/**
 * 사이트명 && 작동상태로 검색 기능 작동
 */
const searchSite = async function () {
	const targetApi = [apiHost + '/alarms', apiHost + '/control/command_history'];
	/* 검색 조건 */
	const searchName = document.getElementById('searchName').value.trim();
	const rowCount = Number($('#rowCount button').data('value'));
	const deviceStatus = new Array(); //상태 선택
	const resourceTypes = new Array(); //리소스 선택
	const locations = new Array(); //지역 선택
	document.querySelectorAll('[name="deviceStatus"]:checked').forEach(chk => {
		deviceStatus.push(chk.value);
	});
	document.querySelectorAll('[name="resourceType"]:checked').forEach(chk => {
		resourceTypes.push(chk.value);
	});
	document.querySelectorAll('[name="location"]:checked').forEach(chk => {
		locations.push(chk.value);
	});
	/* 검색 조건 */

	return new Promise((resolve, reject) => {
		const refineList = new Array();
		siteList.forEach(site => {
			const siteId = site.sid;
			let operation = new Array()
				, capacity = '-'
				, activePower = '-'
				, reactivePower = '-'
				, essActivePower = '-'
				, maxActivePower = '-'
				, targetActivePower = '-'
				, lastTargetActivePowerReqDate = '-'
				, lastTargetActivePowerRecvDate = '-'
				, faultDesc = '';
			Object.entries(apiDatas).forEach(api => {
				const apiUrl = api[0]
					, apiDatas = api[1];

				if ((apiHost + '/status/raw/site') === apiUrl && !isEmpty(apiDatas[siteId])) {
					const rawDevices = apiDatas[siteId];
					Object.entries(rawDevices).forEach(device => {
						const deviceType = device[0]
							, deviceData = device[1];

						if (!isEmpty(deviceData)) {
							//대상은 INV 인버터 타입 대상
							if (deviceType.match('KPX_EMS')) {
								operation.push(deviceData['operation']);
								capacity = (capacity != '-') ? capacity + deviceData['capacity'] : deviceData['capacity'];
								activePower = (activePower != '-') ? activePower + deviceData['activePower'] : deviceData['activePower'];
								reactivePower = (reactivePower != '-') ? reactivePower + deviceData['reactivePower'] : deviceData['reactivePower'];
								maxActivePower = (maxActivePower != '-') ? maxActivePower + deviceData['maxActivePower'] : deviceData['maxActivePower'];
								targetActivePower = (targetActivePower != '-') ? targetActivePower + deviceData['targetActivePower'] : deviceData['targetActivePower'];

								const essDActivePower = (isEmpty(deviceData['essDActivePower'])) ? 0 : deviceData['essDActivePower'];
								const essCActivePower = (isEmpty(deviceData['essCActivePower'])) ? 0 : deviceData['essCActivePower'];
								const targetDevice_EssActivePower = essDActivePower - essCActivePower;
								essActivePower = (essActivePower != '-') ? essActivePower + targetDevice_EssActivePower : targetDevice_EssActivePower;

								lastTargetActivePowerReqDate = isEmpty(deviceData['lastTargetActivePowerReqDate']) ? '-' : String(deviceData['lastTargetActivePowerReqDate']).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
								lastTargetActivePowerRecvDate = isEmpty(deviceData['lastTargetActivePowerRecvDate']) ? '-' : String(deviceData['lastTargetActivePowerRecvDate']).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
								faultDesc = deviceData['deviceFault']
							}
						}
					});
				}
			});

			// 인버터 설비 정보가 없을경우
			// 정지로 판단한다.
			let targetOperation = false;
			let targetLocation = false;
			let targetResource = false;
			let searchSite = false;
			if (!isEmpty(operation)) {
				const searchOperation = operation.some(target => {
					return deviceStatus.includes(String(target));
				});

				if (searchOperation) {
					targetOperation = true;
				}
			} else {
				if (deviceStatus.length == 2) { //전체 선택이면 operation 없는 디바이스도 표시
					targetOperation = true;
				} else {
					targetOperation = false;
				}
			}

			if (!isEmpty(site['location'])) {
				if (locations.includes(String(site['location']))) {
					targetLocation = true;
				} else {
					targetLocation = false;
				}
			} else {
				if (locations.length === document.querySelectorAll('[name="location"]').length) {
					targetLocation = true;
				} else {
					targetLocation = false;
				}
			}

			if (!isEmpty(site['resource_type'])) {
				if (resourceTypes.includes(String(site['resource_type']))) {
					targetResource = true;
				} else {
					targetResource = false;
				}
			} else {
				if (resourceTypes.length === document.querySelectorAll('[name="resourceType"]').length) {
					targetResource = true;
				} else {
					targetResource = false;
				}
			}

			if (!isEmpty(searchName)) {
				const searchPattern = new RegExp(searchName, 'i'); //ignoreCase 대소문자 구분X
				if (searchPattern.test(site.name)) {
					searchSite = true;
				}
			} else {
				searchSite = true;
			}

			if (targetOperation && searchSite && targetLocation && targetResource) {
				site['capacity'] = isNaN(capacity) ? '-' : displayNumberFixedUnit(capacity, 'Wh', 'kWh', 0)[0];
				site['activePower'] = isNaN(activePower) ? '-' : displayNumberFixedUnit(activePower, 'Wh', 'kWh', 0)[0];
				site['reactivePower'] = isNaN(reactivePower) ? '-' :  displayNumberFixedUnit(reactivePower, 'Wh', 'kWh', 0)[0];
				site['essActivePower'] = isNaN(essActivePower) ? '-' :  displayNumberFixedUnit(essActivePower, 'Wh', 'kWh', 0)[0];
				site['maxActivePower'] = isNaN(maxActivePower) ? '-' :  displayNumberFixedUnit(maxActivePower, 'Wh', 'kWh', 0)[0];
				site['targetActivePower'] = isNaN(targetActivePower) ? '-' :   displayNumberFixedUnit(targetActivePower, 'Wh', 'kWh', 0)[0];
				site['lastTargetActivePowerReqDate'] = lastTargetActivePowerReqDate;
				site['lastTargetActivePowerRecvDate'] = lastTargetActivePowerRecvDate;
				site['operation'] = operation; //사이트 상태 정보.
				site['faultDesc'] = faultDesc; //사이트 상태 정보.
				refineList.push(site);
			}
		});

		resolve(refineList);
	}).then(refineList => {
		if (!isEmpty(refineList)) {
			refineList.forEach((site, index) => {
				const siteId = site.sid;
				refineList[index].resourceName = resourceTemplate[site.resource_type];
				targetApi.forEach((target, targetIdx) => {
					const apiData = apiDatas[target];
					if (targetIdx === 0) {
						let alarmWarning = 0
							, alarmError = 0;

						if (!isEmpty(apiData)) {
							apiData.forEach(alarm => {
								if (siteId === alarm.sid) {
									if (alarm.level == 0 || alarm.level == 1 || alarm.level == 9) {
										alarmWarning++;
									} else {
										alarmError++;
									}
								}
							});
						}

						refineList[index]['alarmWarning'] = alarmWarning;
						refineList[index]['alarmError'] = alarmError;
						refineList[index]['alarmTotal'] = alarmError + alarmWarning;
					} else {
						if (!isEmpty(apiData)) {
							const commandHistory = apiData.data;
							const rtuIds = new Array();
							if (!isEmpty(commandHistory)) {
								if (!isEmpty(site.rtus)) {
									(site.rtus).forEach(rtu => { rtuIds.push(rtu.rid) });

									commandHistory.forEach(command => {
										if (rtuIds.includes(command.rid)) {
											if (site['lastTargetActivePowerReqDate'] === '-') {
												refineList[index]['lastTargetActivePowerReqDate'] = new Date(String(command.requested_at).replace(/[^0-9]/g,'').replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$2/$3/$1 $4:$5:$6')).format('yyyy-MM-dd HH:mm:ss');
												refineList[index]['lastTargetActivePowerRecvDate'] = '-'

												const cmdBody = JSON.parse(command.cmd_body);
												refineList[index]['targetActivePower'] = isEmpty(cmdBody['targetPower']) ? '-' : displayNumberFixedUnit(Number(cmdBody['targetPower']), 'Wh', 'kWh', 2)[0];

												let diffTime = Math.floor(((new Date() - hitoryDate) / 1000) / 60 / 60 % 24);
												if (diffTime >= 1) {
													refineList[index]['status'] = '에러';
													refineList[index]['statusClass'] = 'status_err';
												}
											} else {
												let statusDate = new Date((site['lastTargetActivePowerRecvDate'].replace(/[^0-9]/g,'')).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$2/$3/$1 $4:$5:$6'));
												let hitoryDate = new Date(String(command.requested_at).replace(/[^0-9]/g,'').replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$2/$3/$1 $4:$5:$6'));
												if (statusDate.getTime() < hitoryDate.getTime()) {
													refineList[index]['lastTargetActivePowerReqDate'] = hitoryDate.format('yyyy-MM-dd HH:mm:ss');
													refineList[index]['lastTargetActivePowerRecvDate'] = '-'

													const cmdBody = JSON.parse(command.cmd_body);
													refineList[index]['targetActivePower'] = isEmpty(cmdBody['targetPower']) ? '-' : displayNumberFixedUnit(Number(cmdBody['targetPower']), 'Wh', 'kWh', 2)[0];

													let diffTime = Math.floor(((new Date() - hitoryDate) / 1000) / 60 / 60 % 24);
													if (diffTime >= 1) {
														refineList[index]['status'] = '에러';
														refineList[index]['statusClass'] = 'status_err';
													}
												}
											}
										}
									});
								}
							}
						}
					}
				});
			});
		}

		siteListTable.clear();
		siteListTable.page.len(rowCount);
		siteListTable.rows.add(refineList).draw();
		//$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
	}).catch(error => {
		console.error(error);

		$('#errMsg').text(error);
		$('#errorModal').modal('show');
		setTimeout(function(){
			$('#errorModal').modal('hide');
		}, 2000);
		return false;
	});
}

/**
 * 사이트 리소스 아이콘 세팅
 *
 * @param resourceType
 * @returns {string}
 */
const resourceIcon = (resourceType) => {
	let rtnClass = 'solar';
	switch(resourceType) {
		case 1: rtnClass = 'solar'; break;
		case 2: rtnClass = 'wind'; break;
		case 3: rtnClass = 'water'; break;
		default: rtnClass = 'solar';
	}

	return rtnClass;
}

const setUnit = (capacity) => {
	return displayNumberFixedUnit(capacity, 'W', 'kW', 0)[0];
}

/**
 * 테이블 정렬 처리
 *
 * @param table
 * @param n
 * @param sort
 * @constructor
 */
function SortTable(table, n, sort) {
	// table 에 tbody tag 가 반드시 존재한다고 가정한다.
	let tbody = table.tBodies[0];
	let rows = tbody.querySelectorAll('tr.dbclickopen');
	let rows2 = tbody.querySelectorAll('tr.detail_info');
	rows = Array.prototype.slice.call(rows, 0);
	rows.sort(function (row1, row2) {
		var cell1 = row1.getElementsByTagName("td")[n];
		var cell2 = row2.getElementsByTagName("td")[n];
		var value1 = cell1.textContent || cell1.innerText;
		var value2 = cell2.textContent || cell2.innerText;

		value1 = value1 == '-' ? '0' : String(value1).replace(/^\s+|\s+$/g, "");;
		value2 = value2 == '-' ? '0' : String(value2).replace(/^\s+|\s+$/g, "");;

		if (isNumberic(value1)) {
			value1 = Number(value1.replace(/[^0-9]/g, ''));
		}

		if (isNumberic(value2)) {
			value2 = Number(value2.replace(/[^0-9]/g, ''));
		}

		if (sort == 'up') {
			if (value1 < value2) return -1;
			if (value1 > value2) return 1;
		} else {
			if (value1 < value2) return 1;
			if (value1 > value2) return -1;
		}

		return 0;
	});


	// 정렬된 배열로 row 를 다시 저장한다. 문서에 이미 존재하는 node 는 삽입하면 해당 node 는 자동으로 제거되고 새 위치에 저장된다.
	for (let i = 0; i < rows.length; ++i) {
		let flag = rows[i].classList[1];
		tbody.appendChild(rows[i]);

		for (let j = 0; j < rows2.length; j++) {
			if (rows2[j].classList.contains(flag)) {
				tbody.appendChild(rows2[j]);
			}
		}
	}
}

/**
 * 날씨 아이콘
 *
 * @param weatherId
 * @returns {string}
 */
const getWeatherIconClass = (weatherId) => {
	let weatherIconClass = 'w1';
	switch (weatherId) {
		case 1 :
			weatherIconClass = 'w1';
			break;
		case 7 :
			weatherIconClass = 'w4';
			break;
		case 11 :
			weatherIconClass = 'w8';
			break;
		case 12 :
			weatherIconClass = 'w10';
			break;
		case 13 :
			weatherIconClass = 'w6';
			break;
		case 17 :
			weatherIconClass = 'w9';
			break;
		case 20 :
			weatherIconClass = 'w3';
			break;
		default :
			weatherIconClass = 'w1';
			break;
	}
	return weatherIconClass
}