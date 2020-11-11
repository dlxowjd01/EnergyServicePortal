<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="container-fluid">
	<div class="row header-wrapper">
		<div class="col-12">
			<h1 class="page-header fl">${siteName}</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime"></em>
				<span>DATA BASE TIME</span>
				<em class="dbTime"></em>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-xl-7 col-lg-12 col-md-12 col-sm-12">
			<div class="indiv dmain-table">
				<div class="table-top clear">
					<div class="fl">
						<div class="dropdown" id="productType">
							<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown" data-name="상품 구분">
								상품 구분<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk-type" role="menu">
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType0" name="productType" value="1" checked>
										<label for="productType0">전체</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType1" name="productType" value="2">
										<label for="productType1">표준 DR</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType2" name="productType" value="3">
										<label for="productType2">중소 DR</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType3" name="productType" value="3">
										<label for="productType3">UFR DR</label>
									</a>
								</li>
							</ul>
						</div>
					</div>

					<div class="fl">
						<div class="dropdown" id="metropolitanArea">
							<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown" data-name="지역">
								지역<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk-type" role="menu">
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="metropolitanArea0" name="metropolitanArea" value="1" checked>
										<label for="metropolitanArea0">수도권</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="metropolitanArea1" name="metropolitanArea" value="2">
										<label for="metropolitanArea1">비수도권</label>
									</a>
								</li>
							</ul>
						</div>
					</div>

					<div class="fl">
						<div class="dropdown" id="communicationStatus">
							<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown" data-name="통신상태">
								통신상태<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk-type" role="menu">
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="communicationStatus0" name="communicationStatus" value="1" checked>
										<label for="communicationStatus0">전체</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="communicationStatus1" name="communicationStatus" value="2">
										<label for="communicationStatus1">정상</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="communicationStatus2" name="communicationStatus" value="3">
										<label for="communicationStatus2">오류</label>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="fl">
						<input type="text" class="input" id="keyword" name="keyword" value="" placeholder="키워드">
					</div>
				</div>
				<table id="drTable" class="chk-type">
					<colgroup>
						<col style="width:4%">
						<col style="width:8%">
						<col style="width:16%">
						<col style="width:16%">
						<col style="width:16%">
						<col style="width:8%">
						<col style="width:8%">
						<col style="width:8%">
						<col style="width:8%">
						<col style="width:8%">
					</colgroup>
				</table>
			</div>
		</div>

		<div class="col-xl-5 col-lg-12 col-md-12 col-sm-12">
			<div class="indiv gmain-alarm" data-alarm="">
				<div class="alarm-status clear">
					<div class="alarm-alert">
						<span>주요 알림</span>
						<em>0</em>
					</div>
				</div>
				<div class="alarm-notice">
					<ul id="alarmNotice"></ul>
				</div>
			</div>
			<div class="indiv dmain-chart">
				<h2 class="ntit">사용량 현황</h2>
				<div class="btn-group btn-group-toggle" data-toggle="buttons">
					<label class="btn btn-secondary active">
						<input type="radio" name="consumptionOptions" id="consumptionOptions1" checked> 실시간
					</label>
					<label class="btn btn-secondary">
						<input type="radio" name="consumptionOptions" id="consumptionOptions2"> 월간 현황
					</label>
				</div>
				<div>
					<div id="todayConsumption"></div>
					<div id="beforeConsumption" style="height:100px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	let drTable = null;

	$(function() {
		drTable = $('#drTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			'table-layout': 'fixed',
			scrollY: '720px',
			scrollCollapse: true,
			sortable: true,
			paging: true,
			pageLength: 50,
			columns: [
				{
					sTitle: '',
					mData: null,
					mRender: function ( data, type, full, rowIndex ) {
						return '<input type="checkbox" id="check' + rowIndex.row + '" name="table_checkbox" data-spcid="' + full['spc_id'] + '" data-genid="' + full['gen_id'] + '"><label for="check' + rowIndex.row + '"></label>';
					},
					className: 'dt-center no-sorting'
				},
				{
					title: '상품 구분',
					data: null,
					render: function (data, type, full, rowIndex) {
						return '-';
					},
					className: 'dt-center no-sorting fixed'
				},
				{
					title: '자원명',
					data: 'drName',
					className: 'dt-left'
				},
				{
					title: '사이트명',
					data: 'siteName',
					className: 'dt-left'
				},
				{
					title: '통신 상태',
					data: 'communicationTime',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '오류';
						} else {
							const date = new Date(data)
							let toDay = new Date();
							toDay.setMinutes(toDay.getMinutes() - 10);

							if (date.getTime() >= toDay.getTime()) {
								return '정상';
							} else {
								return '오류';
							}
						}
					},
					className: 'dt-center'
				},
				{
					title: '통신 성공률',
					data: null,
					render: function (data, type, full, rowIndex) {
						return '-';
					},
					className: 'dt-center'
				},
				{
					title: '최근 통신시간',
					data: 'communicationTime',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							const date = new Date(data);
							return date.format('yyyy-MM-dd') + '<br/>' + date.format('HH:mm:ss');
						}
					},
					className: 'dt-center'
				},
				{
					title: '순시 전력량<br/>(kW)',
					data: 'activePower',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return numberComma(Math.round(data / 10) / 100);
						}
					},
					className: 'dt-right'
				},
				{
					title: '작전 15분<br/>사용량(kWh)',
					data: 'consumption',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return numberComma(Math.round(data / 10) / 100);
						}
					},
					className: 'dt-right'
				},
				{
					title: '현재 시각 기준<br/>CBL(kW)',
					data: 'cblData',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return numberComma(Math.round(data / 10) / 100);
						}
					},
					className: 'dt-right'
				}
			],
			select: {
				style: 'single',
				selector: 'td:first-child > :checkbox, tr'
			},
			language: {
				emptyTable: '조회된 데이터가 없습니다.',
				zeroRecords: '검색된 결과가 없습니다.'
			},
			dom: 'tip',
		}).on('select', function(e, dt, type, indexes) {
			drTable.rows(indexes).nodes().to$().find("input[type='checkbox']").prop("checked", true);
			const selectedData = drTable.row(indexes).data();
			alarmInfoList(selectedData.sid);
			detailDraw(selectedData.sid, selectedData.dids);
		}).on('deselect', function(e, dt, type, indexes) {
			drTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
			detailDestroy();
		}).columns.adjust().draw();

		$(':radio[name="consumptionOptions"]').on('change', function() {
			const selectedData = drTable.row('.selected').data();
			if (!isEmpty(selectedData)) {
				detailDraw(selectedData.drName, selectedData.sid, selectedData.dids);
			}
		});

		$('#keyword').on('keyup', function (e) {
			if (e.keyCode === 13) {
				getDataList();
			}
		});

		getDataList();
	});

	/**
	 * dr리스트 조회
	 */
	const getDataList = () => {
		new Promise((resolve, reject) => {
			$.ajax({
				url: apiHost + '/config/dr-groups',
				type: 'GET',
				data: {
					oid: oid,
					likeName: $('#keyword').val(),
					includeSites: true,
					includeDevices: true
				},
				success: (result) => {
					if (isEmpty(result)) {
						reject('조회 된 내역이 없습니다.');
					} else {
						resolve(result);
					}
				},
				error: (error) => {
					console.error(error);
					throw new Error('조회에 실패했습니다.');
				}
			})
		}).then(resultList => {
			const refineList = new Array();
			resultList.forEach(drGrp => {
				if (!isEmpty(drGrp.sites)) {
					(drGrp.sites).forEach(site => {
						const devices = site.devices
							, dids = new Array();
						if (!isEmpty(devices)) devices.map(e => dids.push(e.did));

						refineList.push({
							dgid: drGrp.dgid,
							drName: drGrp.name,
							sid: site.sid,
							siteName: site.name,
							dids: dids,
							communicationTime: '',
							cblData: '',
							activePower: '',
							consumption: ''
						});
					});
				}
			});

			return refineList;
		}).then(refineList => {
			const searchInfo = new Array()
				, today = new Date();

			let dids = new Array()
			  , sids = new Array();
			refineList.forEach(refine => {
				sids.push(refine.sid);
				dids = dids.concat(refine.dids);
			});

			searchInfo.push($.ajax({
				url: apiHost + '/status/raw',
				type: 'GET',
				data: {
					dids: dids.toString()
				}
			}));

			searchInfo.push($.ajax({
				url: apiHost + '/energy/now/devices',
				type: 'GET',
				data: {
					dids: dids.toString(),
					metering_type: 1,
					interval: '15min'
				}
			}));

			searchInfo.push($.ajax({
				url: apiHost + '/cbl/sites',
				type: 'GET',
				data: {
					sids: sids.toString(),
					method: 'max4/5',
					interval: 'hour',
					startTime: today.format('yyyyMMdd') + '000000',
					endTime: today.format('yyyyMMdd') + '235959'
				}
			}));

			return Promise.all(searchInfo).then(response => {
				response.forEach((apiData, index) => {
					if (index === 0) {
						Object.entries(apiData).forEach(([did, data]) => {
							if (!isEmpty(data.data)) {
								const siteIndex = refineList.findIndex(e => e.dids.includes(did));

								if (isEmpty(refineList[siteIndex].activePower)) {
									refineList[siteIndex].activePower = data.data[0].activePower;
								} else {
									refineList[siteIndex].activePower += data.data[0].activePower;
								}

								if (isEmpty(refineList[siteIndex].communicationTime)) {
									refineList[siteIndex].communicationTime = data.data[0].createdAt;
								} else {
									if (new Date(refineList[siteIndex].communicationTime).getTime() < new Date(data.data[0].createdAt).getTime()) {
										refineList[siteIndex].communicationTime = data.data[0].createdAt;
									}
								}
							}
						});
					} else if (index === 1) {
						if (!isEmpty(apiData) && !isEmpty(apiData.data)) {
							Object.entries(apiData.data).forEach(([did, data]) => {
								if (!isEmpty(data)) {
									const siteIndex = refineList.findIndex(e => e.dids.includes(did));
									if (isEmpty(refineList[siteIndex].consumption)) {
										refineList[siteIndex].consumption = data.energy;
									} else {
										refineList[siteIndex].consumption += data.energy;
									}
								}
							});
						}
					} else {
						if (!isEmpty(apiData) && !isEmpty(apiData.data)) {
							Object.entries(apiData.data).forEach(([sid, data]) => {
								const siteIndex = refineList.findIndex(e => sid.match(e.sid))
									, cblData = data[0].items.find(e => String(e.basetime) === today.format('yyyyMMddHH') + '0000');

								if (!isEmpty(cblData)) {
									refineList[siteIndex].cblData = cblData.cbl;
								}
							});
						}
					}
				});

				return refineList;
			});
		}).then(refineList => {
			drTable.clear();
			drTable.rows.add(refineList).draw();
			$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
		}).catch(error => {
			drTable.clear().draw();
			errorMsg(error);
		});
	}

	const detailDestroy = () => {
		let consumptionChartLength = todayConsumption.series.length;
		if(consumptionChartLength > 0){
			for(let i = consumptionChartLength -1; i > -1; i--) {
				todayConsumption.series[i].remove();
			}
		}

		let beforeConsumptionLength = beforeConsumption.series.length;
		if(beforeConsumptionLength > 0){
			for(let i = beforeConsumptionLength -1; i > -1; i--) {
				beforeConsumption.series[i].remove();
			}
		}

		let alarmEl = $('.indiv[data-alarm]');
		alarmEl.attr('data-alarm', '');
		alarmEl.find('em').text('');
		$('#alarmNotice').empty().append(`<li class="no-data">조회된 내역이 없습니다.</li>`);
	}

	/**
	 * CBL알람리스트
	 */
	const detailDraw = (sid, dids) => {
		let today = new Date();
		let beforeDate = new Date();
		let promiseUrl = new Array();
		let minutes = today.getMinutes();
		let time = minutes / 5;
		let remainder = minutes % 5

		promiseUrl.push($.ajax({
			url: apiHost + '/cbl/sites',
			type: 'GET',
			data: {
				sids: sid,
				method: 'max4/5',
				interval: 'hour',
				startTime: today.format('yyyyMMdd') + '080000',
				endTime: today.format('yyyyMMdd') + '205959'
			}
		}));

		promiseUrl.push($.ajax({
			url: apiHost + '/energy/devices',
			type: 'GET',
			data: {
				dids: dids.toString(),
				startTime: today.format('yyyyMMdd') + '080000',
				endTime: today.format('yyyyMMdd') + '205959',
				interval: 'hour'
			}
		}));

		if (today.getHours() > 8 && 20 > today.getHours()) {
			for (let i = 0; i < time; i++) {
				promiseUrl.push($.ajax({
					url: apiHost + '/energy/devices',
					type: 'GET',
					data: {
						dids: dids.toString(),
						startTime: today.format('yyyyMMddHH') + ('0' + String(i * 5) + '00').slice(-4),
						endTime: today.format('yyyyMMddHH') + ('0' + String((i + 1) * 5) + '00').slice(-4),
						interval: '5min'
					}
				}));
			}

			if (remainder > 0) {
				promiseUrl.push($.ajax({
					url: apiHost + '/status/raw',
					type: 'GET',
					data: {
						dids: dids.toString()
					}
				}));
			}
		}

		if ($('#consumptionOptions2').is(':checked')) {
			beforeDate.setDate(today.getDate() - 30);
			promiseUrl.push($.ajax({
				url: apiHost + '/energy/devices',
				type: 'GET',
				data: {
					dids: dids.toString(),
					startTime: beforeDate.format('yyyyMMdd') + '000000',
					endTime: today.format('yyyyMMdd') + '235959',
					interval: 'day'
				}
			}));
		} else {}

		Promise.all(promiseUrl).then(response => {
			const categories = new Array()
				, beforeCategories = new Array()
				, cbl = new Array()
				, usage = new Array()
				, beforeUsage = new Array();
			response.forEach((res, index) => {
				const apiData = res.data;

				if (res.interval === 'hour') {
					Object.entries(apiData).forEach(([sid, data]) => {
						const items = data[0].items;
						if (!isEmpty(items)) {
							items.forEach(item => {
								if (res.method === undefined) {
									usage.push(Math.round(item.energy / 10) / 100);
								} else {
									categories.push(String(item.basetime).substr(8, 2));
									cbl.push(Math.round(item.cbl / 10) / 100);
								}
							})
						}
					});
				} else if (res.interval === 'day') {
					Object.entries(apiData).forEach(([sid, data]) => {
						const items = data[0].items;
						if (!isEmpty(items)) {
							items.forEach(item => {
								beforeCategories.push(String(item.basetime).substr(4, 4));
								beforeUsage.push(Math.round(item.energy / 10) / 100);
							})
						}
					});
				} else {

				}
			});

			let consumptionChartLength = todayConsumption.series.length;
			if(consumptionChartLength > 0){
				for(let i = consumptionChartLength -1; i > -1; i--) {
					todayConsumption.series[i].remove();
				}
			}

			//사용량 라인
			todayConsumption.addSeries({
				name: '사용량',
				type: 'spline',
				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: usage,
			});

			//CBL 라인
			todayConsumption.addSeries({
				name: 'CBL',
				type: 'spline',
				color: 'var(--sandy-brown)',
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: cbl,
			});

			todayConsumption.xAxis[0].update({
				categories: categories
			});

			todayConsumption.yAxis[0].update({
				title:{
					text: 'kWh'
				}
			});

			todayConsumption.redraw();

			if ($('#consumptionOptions2').is(':checked')) {
				beforeConsumption.addSeries({
					name: '사용량',
					type: 'spline',
					color: 'var(--turquoise)',
					tooltip: {
						valueSuffix: 'kWh',
					},
					data: beforeUsage,
				});

				beforeConsumption.xAxis[0].update({
					categories: beforeCategories
				});

				beforeConsumption.redraw();

				$('#beforeConsumption').removeClass('hidden');
			} else {
				$('#beforeConsumption').addClass('hidden');
				let beforeConsumptionLength = beforeConsumption.series.length;
				if(beforeConsumptionLength > 0){
					for(let i = beforeConsumptionLength -1; i > -1; i--) {
						beforeConsumption.series[i].remove();
					}
				}
			}
		}).catch(error => {
			errorMsg(error);
		});
	}

	/**
	 * 알람 이력 리스트 생성
	 *
	 * @returns {Promise<void>}
	 */
	const alarmInfoList = async (sid) => {
		let today = new Date();
		$('#alarmNotice').empty();
		//알람 이력
		$.ajax({
			url: apiHost + '/alarms',
			type: 'GET',
			data: {
				sids: sid,
				startTime: today.format('yyyyMMdd') + '000000',
				endTime: today.format('yyyyMMdd') + '235959',
				confirm: false
			},
			success: (result) => {
				if (!isEmpty(result)) {
					//localtime 오름차순 정렬
					result.sort((a, b) => {
						return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
					});

					let alarmList = new Array();
					let alarmColor = "";
					let alarmEl = $('.indiv[data-alarm]');

					result.forEach(alarm => {
						if(alarm.level !== 0) {
							let localTime = (alarm.localtime != null && alarm.localtime != '') ? String(alarm.localtime) : '';
							alarm.standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
							alarmList.push(alarm);
						}
					});

					if(alarmList.length>0){
						if( alarmList.findIndex(x => x.level == 4) > -1){
							alarmColor = 'urgent';
						} else {
							if( alarmList.findIndex(x => x.level == 3) > -1 ){
								alarmColor = 'shutoff';
							} else {
								if( alarmList.findIndex(x => x.level == 2) > -1 ){
									alarmColor = 'critical';
								} else {
									if( alarmList.findIndex(x => x.level == 1) > -1 ){
										alarmColor = 'warning';
									} else {
										if( alarmList.findIndex(x => x.level == 0) > -1 ){
											alarmColor = 'info';
										} else {
											alarmColor = '';
										}
									}
								}
							}
						}
					} else {
						alarmColor = '';
					}

					alarmEl.attr('data-alarm', alarmColor);
					alarmEl.find('em').text(alarmList.length);

					let liStr = ``;
					alarmList.forEach(alarm => {
						liStr += `<li>
									<a href="javascript:void(0);" onclick="pageMove(\'${'${alarm.sid}'}\', \'alarm\');" class="levelClass(\'${'${alarm.level}'}\')">
										<span class="err-msg">${'${alarm.site_name}'} - ${'${alarm.message}'}</span>
										<span class="err-time">${'${alarm.standardTime}'}</span>
									</a>
								</li>`;
					});

					$('#alarmNotice').append(liStr);
				} else {
					let alarmEl = $('.indiv[data-alarm]');
					alarmEl.attr('data-alarm', '');
					alarmEl.find('em').text('');
					$('#alarmNotice').append(`<li class="no-data">조회된 내역이 없습니다.</li>`);
				}
			},
			error: (jqXHR, textStatus, errorThrown) => {
				console.error(textStatus);
				let alarmEl = $('.indiv[data-alarm]');
				alarmEl.attr('data-alarm', '');
				alarmEl.find('em').text('');
				$('#alarmNotice').append(`<li class="no-data">조회된 내역이 없습니다.</li>`);
				errorMsg('조회 중 오류가 발생했습니다.');
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

	const pageMove = (id, action) => {
		let $form = $('#linkSiteForm');
		let $inp = $('<input>').attr('type', 'hidden').attr('name', 'sid').val(id);

		$form.append($inp);
		if (action == 'alarm') {
			$form.attr('action', '/history/alarmHistory.do').submit();
		} else {
			$form.attr('action', '/dashboard/smain.do').submit();
		}
	}

	/**
	 * 에러 처리
	 *
	 * @param msg
	 */
	const errorMsg = msg => {
		$("#errMsg").text(msg);
		$("#errorModal").modal("show");
		setTimeout(function(){
			$("#errorModal").modal("hide");
		}, 1800);
	}

	const todayConsumption = Highcharts.chart('todayConsumption', {
		chart: {
			marginTop: 60,
			marginLeft: 65,
			marginRight: 65,
			marginBottom: 50,
			spacingLeft: 0,
			backgroundColor: 'transparent',
			zoomType: 'x',
		},
		lang: {
			noData: '조회된 데이터가 없습니다.'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		rangeSelector: {
			enabled: false,
		},
		scrollbar: {
			enabled: false,
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				// !!!!!!!!!!!!!!!!IMPORTANT
				borderColor: 'var(--grey)',
				borderWidth: 0,
				showInLegend: true
			},
			borderColor: 'var(--grey)',
			borderWidth: 0,
			marker: {
				lineWidth: 1
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [
			{
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				tickInterval: 1,
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				labels: {
					align: 'center',
					y: 27,
					// formatter: function () {
					// 	let temp = date31List[this.value];
					// 	let newVal = temp.substring(0,2) + "/" + temp.substring(2,4);
					// 	return newVal;
					// },
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				title: { text: null },
			}
		],
		yAxis: [
			{
				opposite: true,
				min: 0,
				gridLineWidth: 0,
				plotLines: [
					{
						color: 'var(--grey)',
						width: 1
					}
				],
				title: {
					text: 'kWh',
					x: -13,
					y: 30,
					align: 'low',
					rotation: 0,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				// offset: 0,
				labels: {
					overflow: 'justify',
					align: 'left',
					style: {
						color: 'var(--grey)',
						fontSize: '12px',
					},
				},
			}
		],
		tooltip: {
			shared: true,
			useHTML: true,
			split: false,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)',
			},
			formatter: function () {
				return this.points.reduce(function (s, point) {
					if(point.y !== 0){
						let suffix = point.series.userOptions.tooltip.valueSuffix;
						return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + numberComma(Math.round(point.y)) + ' ' + suffix;
					} else {
						return s
					}
				}, '<span style="display:flex;"><b>' + this.x + ' 시</b></span>');
			},
		},
		legend: {
			enabled: false,
			align: 'right',
			verticalAlign: 'top',
			x: -55,
			y: 0,
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		credits: {
			enabled: false
		},
	});

	const beforeConsumption = Highcharts.chart('beforeConsumption', {
		chart: {
			marginLeft: 65,
			marginRight: 65,
			spacingLeft: 0,
			backgroundColor: 'transparent',
			zoomType: 'xy',
		},
		lang: {
			noData: '조회된 데이터가 없습니다.'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				// !!!!!!!!!!!!!!!!IMPORTANT
				borderColor: 'var(--grey)',
				borderWidth: 0,
				showInLegend: true,
				marker: {
					enabled: false
				}
			},
			borderColor: 'var(--grey)',
			borderWidth: 0,
			marker: {
				lineWidth: 1
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [
			{
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				tickInterval: 1,
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				labels: {
					align: 'center',
					y: 27,
					formatter: function () {
						return String(this.value).replace(/(\d{2})(\d{2})/g, '$1-$2');
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				title: { text: null },
			}
		],
		yAxis: [
			{
				gridLineWidth: 0,
				labels: {
					enabled: false
				},
				title: {
					text: null
				},
				min: 0.6,
				showFirstLabel: false
			}
		],
		tooltip: {
			shared: true,
			useHTML: true,
			split: false,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)',
			},
			formatter: function () {
				return this.points.reduce(function (s, point) {
					if(point.y !== 0){
						let suffix = point.series.userOptions.tooltip.valueSuffix;
						return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + numberComma(Math.round(point.y)) + ' ' + suffix;
					} else {
						return s
					}
				}, '<span style="display:flex;"><b>' + String(this.x).replace(/(\d{2})(\d{2})/g, '$1-$2') + '</b></span>');
			}
		},
		legend: {
			enabled: false,
			align: 'right',
			verticalAlign: 'top',
			x: -55,
			y: 0,
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		credits: {
			enabled: false
		},
	});
</script>