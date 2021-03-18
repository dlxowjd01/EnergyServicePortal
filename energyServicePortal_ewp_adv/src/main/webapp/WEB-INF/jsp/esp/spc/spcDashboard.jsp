<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<link type="text/css" rel="stylesheet" href="/css/spcDashboard.css" />
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header"></div>
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATABASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div class="row content-wrapper" id="spcDashboardContent">
	<div class="indiv spcDashboard1-1">
		<div>
			<h2 class="title">발전 현황</h2>
			<p class="number-unit"><span>55.7</span> MW</p>
		</div>
		<div>
			<h2 class="title">올해 이익률</h2>
			<p class="number-unit"><span>34</span> %</p>
		</div>
	</div>

	<div class="indiv spcDashboard1-2">
		<div>
			<h2 class="title">올해 이익금</h2>
			<p class="number-unit"><span>300,000,000</span> 원</p>
		</div>
		<div>
			<ul>
				<li>올해 수입총계</li>
				<li><span>450,000,000</span> 원</li>
			</ul>
			<ul>
				<li>올해 지출총계</li>
				<li><span>150,000,000</span> 원</li>
			</ul>
		</div>
	</div>

	<div class="indiv spcDashboard1-3">
		<ul id="spcCategory">
			<li class="actived">보험료</li>
			<li>세금과 공과</li>
			<li>기장료</li>
			<li>등기용익수수료</li>
			<li>회계감사수수료</li>
			<li>지급수수료</li>
			<li>경비용역료</li>
			<li>임대료</li>
			<li>전력비</li>
			<li>통신비</li>
			<li>전기안전관리수수료</li>
			<li>수선유지비</li>
		</ul>
		<div>
			<div>
				<span class="blue">8위</span>
				<div>
					<p>지출 총계</p>
					<div><p class="number-unit"><span>500</span> 만원</p></div>
				</div>
			</div>
			<div>
				<span class="increase">증가</span>
				<div>
					<p>1MW 당</p>
					<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>+8.34</span> %</p></div>
				</div>
			</div>
			<div>
				<span class="increase">증가</span>
				<div>
					<p>지출대비 비율</p>
					<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>+8.34</span> %</p></div>
				</div>
			</div>
			<div>
				<span class="increase">증가</span>
				<div>
					<p>관리운영대비 비율</p>
					<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>+8.34</span> %</p></div>
				</div>
			</div>
			<div>
				<span class="increase">증가</span>
				<div>
					<p>전월 대비</p>
					<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>+8.34</span> %</p></div>
				</div>
			</div>
			<div>
				<span class="decrease">감소</span>
				<div>
					<p>전년 대비</p>
					<div><img src="/img/spcDashboard/down.svg" alt="증가" /><p class="number-unit"> <span>-8.34</span> %</p></div>
				</div>
			</div>
		</div>
	</div>

	<div class="indiv spcDashboard2-1">
		<h2 class="title">
			평균 지출 비율
			<span></span>
		</h2>
		<div id="graph1"> 
			<!-- 그래프 -->
		</div>
	</div>
	
	<div class="indiv spcDashboard2-2">
		<h2 class="title">
			종합 지출 총계
			<span></span>
		</h2>
		<div id="graph2">
			<!-- 그래프 -->
		</div>
	</div>

	<div class="indiv spcDashboard2-3">
		<h2 class="title">
			발전소 이익률
			<span></span>
		</h2>
		<div class="spcDashboard-filter">
			<div class="actived">
				<div>42</div>
				<p>
					<span>100%</span>
					<span>80%</span>
				</p>
			</div>
			<div class="actived">
				<div>32</div>
				<p>60%</p>
			</div>
			<div class="actived">
				<div>15</div>
				<p>40%</p>
			</div>
			<div class="actived">
				<div>4</div>
				<p>20%</p>
			</div>
			<div class="actived">
				<div>1</div>
				<p>0%</p>
			</div>
			<div class="actived">
				<div>1</div>
				<p>마이너스</p>
			</div>
		</div>

		<h3>발전소 수입/지출 현황</h3>
		
		<div class="spcDashboard-table">
			<table id="spcTable" class="chk-type spcDashboard">
				<colgroup>
					<col style="width:20%">
					<col style="width:16%">
					<col style="width:16%">
					<col style="width:16%">
					<col style="width:16%">
					<col style="width:16%">
				</colgroup>
			</table>
		</div>
	</div>

	<div class="indiv spcDashboard3-1">
		<div>
			<div class="title-area">
				<h2 class="title actived">
					항목별 지출
				</h2>
				<h2 class="title">
					용량대비 지출/관리운영비 추이
				</h2>
				<span></span>
			</div>
			<ul class="interval-selector">
				<li class="actived">월별</li>
				<li>연도별</li>
			</ul>
		</div>
		<div id="graph3">
			<!-- 그래프 -->
		</div>
	</div>

	<div class="indiv spcDashboard3-2">
		<h2 class="title">
			MW당 항목별 지출금액
			<span></span>
		</h2>
		<div class="spcDashboard3-2-graph-wrap">
			<button class="direction-button prev hidden"> <img src="/img/spcDashboard/pre.svg" alt=""> </button>
			<div id="graph4">
				<!-- 그래프 -->
			</div>
			<button class="direction-button next"> <img src="/img/spcDashboard/next.svg" alt=""> </button>
		</div>
	</div>
</div>

<script>
	// 기본 상호작용
	$("#spcCategory > li").on("click", function(e) {
		$("#spcCategory > li").removeClass("actived");

		$(this).addClass("actived");
	});

	$(".spcDashboard3-1 > .title-area > .title").on("click", function(e) {
		$(".spcDashboard3-1 > .title-area > .title").removeClass("actived");

		$(this).addClass("actived");
	});

	$(".interval-selector > li").on("click", function(e) {
		$(".interval-selector > li").removeClass("actived");

		$(this).addClass("actived");
	});
</script>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	const expenditureTemplate = [
		{ name: '보험료', column: [], color: 'var(--turquoise)'},
		{ name: '세금과 공과', column: ['지방세', '종합부동산세', '세금과공과_기타'], color: 'var(--turquoise)'},
		{ name: '기장료', column: ['기장료'], color: 'var(--turquoise)'},
		{ name: '등기용역수수료', column: ['등기용역수수료'], color: 'var(--turquoise)'},
		{ name: '회계감사수수료', column: ['회계감사수수료'], color: 'var(--turquoise)'},
		{ name: '지급수수료', column: ['REC수수료', '재위탁수수료', '정기검사', '지급수수료_기타'], color: 'var(--turquoise)'},
		{ name: '경비용역료', column: ['경비용역료'], color: 'var(--turquoise)'},
		{ name: '임대료', column: ['임대료'], color: 'var(--turquoise)'},
		{ name: '전력비', column: ['전력비'], color: 'var(--turquoise)'},
		{ name: '통신비', column: ['통신비'], color: 'var(--turquoise)'},
		{ name: '전기안전관리대행수수료', column: ['전기안전관리대행수수료'], color: 'var(--turquoise)'},
		{ name: '수선유지비', column: [], color: 'var(--turquoise)'},
	];
	let spcTable = null;

	$(function() {
		spcList();

		$('.spcDashboard-filter > div').on('click', function(e) {
			$(this).toggleClass('actived');

			spcTable.columns(3).search(this.value).draw();
		});

		$("#dashboardTableSearch > input").on( 'keyup search input paste cut', function(e) {
			spcTable.search(this.value).draw();
		});

		$('.direction-button.prev').on('click', function() {
			let max = expenditureCapacityChart.xAxis[0].min - 1, min = max - 4;
			if (max === 4) { $('.direction-button.prev').addClass('hidden'); }
			else { $('.direction-button.next').removeClass('hidden'); }
			expenditureCapacityChart.update({
				xAxis: {
					min: max - 4,
					max: max
				}
			});
		});

		$('.direction-button.next').on('click', function() {
			let min = expenditureCapacityChart.xAxis[0].max + 1, max = min + 4;
			if (min === 10) { $('.direction-button.next').addClass('hidden'); max = 11; }
			else { $('.direction-button.prev').removeClass('hidden'); }
			expenditureCapacityChart.update({
				xAxis: {
					min: min,
					max: max
				}
			});
		});

		spcTable = $('#spcTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			scrollX: true,
			scrollY: '600px',
			scrollCollapse: true,
			sortable: true,
			paging: false,
			columns: [
				{
					title: '사이트 명',
					data: 'name',
					className: 'dt-head-center dt-body-left'
				},
				{
					title: '수입<br/>(만원)',
					data: 'contractUnitPrice',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data) || data === '-') {
							return '-';
						} else {
							const temp = displayNumberFixedUnit(data, '원', '만원', 0);
							return temp[0];
						}
					},
					className: 'dt-right'
				},
				{
					title: '지출<br/>(만원)',
					data: null,
					render: function (data, type, full, rowIndex) {
						const expenditure = full['expenditure'] === '-' ? 0 : full['expenditure']
							, insuranceCost = full['insuranceCost'] === '-' ? 0 : full['insuranceCost']
							, repairMaintenanceCost = isEmpty(full['repairMaintenanceCost']) ? 0 : full['repairMaintenanceCost']
							, temp = (Number(expenditure) + Number(insuranceCost) + Number(repairMaintenanceCost)) * full['month'];

						if (!isNaN(temp) && temp > 0) {
							const tempData = displayNumberFixedUnit(temp, '원', '만원', 0);
							return tempData[0];
						} else {
							return '-';
						}
					},
					className: 'dt-right'
				},
				{
					title: '수익률<br/>(%)',
					data: null,
					render: function (data, type, full, rowIndex) {
						const contractUnitPrice = full['contractUnitPrice'] === '-' ? 0 : full['contractUnitPrice']
							, expenditure = full['expenditure'] === '-' ? 0 : full['expenditure']
							, insuranceCost = full['insuranceCost'] === '-' ? 0 : full['insuranceCost']
							, repairMaintenanceCost = isEmpty(full['repairMaintenanceCost']) ? 0 : full['repairMaintenanceCost']
							, temp = Math.floor(((contractUnitPrice - ((expenditure - insuranceCost - repairMaintenanceCost) * full['month'])) / contractUnitPrice) * 100);

						if (contractUnitPrice > 0) {
							return temp;
						} else {
							return '-';
						}
					},
					className: 'dt-right'
				},
				{
					title: '전월<br/>(%)',
					data: null,
					render: function (data, type, full, rowIndex) {
						const contractUnitPrice = full['contractUnitPrice'] === '-' ? 0 : full['contractUnitPrice']
							, expenditure = full['expenditure'] === '-' ? 0 : full['expenditure']
							, temp = Math.floor(((contractUnitPrice - expenditure) / contractUnitPrice) * 100);

						if (contractUnitPrice > 0) {
							return temp;
						} else {
							return '-';
						}
					},
					className: 'dt-right'
				},
				{
					title: '전년<br/>(%)',
					data: null,
					render: function (data, type, full, rowIndex) {
						const contractUnitPrice = full['contractUnitPrice'] === '-' ? 0 : full['contractUnitPrice']
							, expenditure = full['expenditure'] === '-' ? 0 : full['expenditure']
							, temp = Math.floor(((contractUnitPrice - expenditure) / contractUnitPrice) * 100);

						if (contractUnitPrice > 0) {
							return temp;
						} else {
							return '-';
						}
					},
					className: 'dt-right'
				}
			],
			language: {
				emptyTable: '조회된 데이터가 없습니다.',
				zeroRecords:  '검색된 결과가 없습니다.',
				infoEmpty: '',
				paginate: {
					previous: '',
					next: '',
				},
				info: '_PAGE_ - _PAGES_ ' + ' / 총 _TOTAL_ 개',
			},
			dom: 'tip',
		}).columns.adjust().draw();
	});

	const spcList = () => {
		const targetApi = new Array();
		targetApi.push($.ajax({
			url: apiHost + '/spcs',
			type: 'GET',
			data: {
				oid: oid,
				includeGens: true
			}
		}));

		targetApi.push($.ajax({
			url: apiHost + '/reports/remote_work',
			type: 'GET',
			data: { oid: oid }
		}));

		new Promise ((resolve, reject) => {
			resolve(Promise.all(targetApi));
		}).then(response => {
			const currentMonth = new Date(); currentMonth.setDate(1);
			const tableData = new Array();

			let spcAllCapacity = 0;
			let contractUnitPraiceAll = 0;
			let totalExpenditure = 0;
			let totalInsuranceCost = 0;
			let totalRepairMaintenanceCost = 0;
			let expenditureInfo = new Array(12).fill(0);
			response.forEach((resData, index) => {
				const targetData = resData['data'];
				if (index === 0) {
					targetData.forEach(rowData => {
						const spcGens = rowData['spcGens'];

						if (!isEmpty(spcGens)) {
							spcGens.forEach(spcGen => {
								let contractUnitPrice = '', expenditure = '', insuranceCost = '';

								if (!isEmpty(spcGen['maintenance_info'])) {
									const maintenanceInfo = JSON.parse(spcGen['maintenance_info'])
										, spcCapacity = maintenanceInfo['설치_용량'].replace(/[^0-9]/g, '');
									contractUnitPrice = maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '');
									if (!isEmpty(spcCapacity)) { spcAllCapacity += Number(spcCapacity); }
									if (!isEmpty(maintenanceInfo['계약_단가'])) {
										contractUnitPrice = Number(contractUnitPrice);
										contractUnitPraiceAll += contractUnitPrice * currentMonth.getMonth();
									} else {
										contractUnitPrice = '-';
									}
								}

								if (!isEmpty(spcGen['spend_info'])) {
									const spendInfo = JSON.parse(spcGen['spend_info']);
									expenditure = spendInfo['지출_총계'].replace(/[^0-9]/g, '');

									if (!isEmpty(spendInfo['지출_총계'])) {
										expenditure = Number(expenditure);
										totalExpenditure += expenditure  * currentMonth.getMonth();
									} else {
										expenditure = '-';
									}

									//종합 지출 총계
									Object.entries(spendInfo).forEach(([key, data]) => {
										const expenditureIndex = expenditureTemplate.findIndex(e => e['column'].includes(key));
										if (expenditureIndex > -1 && !isEmpty(data)) {
											expenditureInfo[expenditureIndex] += (Number(data.replace(/[^0-9]/g, '')) * currentMonth.getMonth());
										}
									});
								}

								if (!isEmpty(spcGen['insurance_info'])) {
									const insuranceInfo = JSON.parse(spcGen['insurance_info']);
									insuranceCost = insuranceInfo['보험료_총계'].replace(/[^0-9]/g, '');
									if (!isEmpty(insuranceInfo['보험료_총계'])) {
										insuranceCost = Number(insuranceCost);
										totalInsuranceCost += insuranceCost * currentMonth.getMonth();
									} else {
										insuranceCost = '-';
									}
								}

								tableData.push({
									id: spcGen.gen_id,
									name: spcGen.name,
									contractUnitPrice: contractUnitPrice,
									expenditure: expenditure,
									insuranceCost: insuranceCost,
									month: currentMonth.getMonth(),
								});
							});
						}
					});
				} else {
					targetData.forEach(rowData => {
						const workInfo = JSON.parse(rowData['work_info'])
							, toDate = new Date(workInfo['출장_시기_to']);
						if (!isEmpty(workInfo['출장_시기_to']) && (toDate.getFullYear() === currentMonth.getFullYear()) && (toDate.getTime() < currentMonth.getTime())) {
							const repairMaintenanceInfo = JSON.parse(rowData['repair_maintenance_info'])
								, tableIndex = tableData.findIndex(e => e.id === rowData.site_id);

							if (repairMaintenanceInfo !== null && !isEmpty(repairMaintenanceInfo['총_수선_유지비'])) {
								const repairMaintenanceCost = repairMaintenanceInfo['총_수선_유지비'].replace(/[^0-9]/g, '');
								totalRepairMaintenanceCost += Number(repairMaintenanceCost);

								if (tableIndex > -1) {
									if (toDate.getMonth() === (currentMonth.getMonth() - 1)) {
										//전월
										if (isEmpty(tableData[tableIndex]['lastMonthRepair'])) {
											tableData[tableIndex]['lastMonthRepair'] = Number(repairMaintenanceCost);
										} else {
											tableData[tableIndex]['lastMonthRepair'] += Number(repairMaintenanceCost);
										}
									}

									//전월 제외한 올해 합산
									if (isEmpty(tableData[tableIndex]['repairMaintenanceCost'])) {
										tableData[tableIndex]['repairMaintenanceCost'] = Number(repairMaintenanceCost);
									} else {
										tableData[tableIndex]['repairMaintenanceCost'] += Number(repairMaintenanceCost);
									}
								}
							}
						} else if (!isEmpty(workInfo['출장_시기_to']) && (toDate.getFullYear() === (currentMonth.getFullYear() - 1))) {
							const repairMaintenanceInfo = JSON.parse(rowData['repair_maintenance_info'])
								, tableIndex = tableData.findIndex(e => e.id === rowData.site_id);

							if (repairMaintenanceInfo !== null && !isEmpty(repairMaintenanceInfo['총_수선_유지비'])) {
								const repairMaintenanceCost = repairMaintenanceInfo['총_수선_유지비'].replace(/[^0-9]/g, '');

								if (tableIndex > -1) {
									if (isEmpty(tableData[tableIndex]['lastYearRepair'])) {
										tableData[tableIndex]['lastYearRepair'] = Number(repairMaintenanceCost);
									} else {
										tableData[tableIndex]['lastYearRepair'] += Number(repairMaintenanceCost);
									}
								}
							}
						}
					});
				}
			});

			expenditureInfo[0] = totalExpenditure; //보험료
			expenditureInfo[11] += Number(totalRepairMaintenanceCost); //수선유지비
			totalExpenditure = totalExpenditure + totalInsuranceCost + totalRepairMaintenanceCost;
			return {spcAllCapacity, contractUnitPraiceAll, totalExpenditure, expenditureInfo, tableData};
		}).then(({spcAllCapacity, contractUnitPraiceAll, totalExpenditure, expenditureInfo, tableData}) => {
			const lastMonth = new Date(); lastMonth.setDate(0);

			//발전 현황 (설비 용량)
			if (!isEmpty(spcAllCapacity)) {
				const refineCapacity = displayNumberFixedDecimal(spcAllCapacity, 'kW', 3, 2);
				document.querySelector('.spcDashboard1-1 div:nth-child(1) .number-unit').innerHTML = '<span>' + refineCapacity[0] + '</span>' + refineCapacity[1];
			} else {
				document.querySelector('.spcDashboard1-1 div:nth-child(1) .number-unit').innerHTML = '없음';
			}

			//올해 이익금
			const profit = contractUnitPraiceAll - totalExpenditure;
			document.querySelector('.spcDashboard1-2 div:nth-child(1) p.number-unit span').innerHTML = numberComma(profit);
			//올해 수입 총계
			document.querySelector('.spcDashboard1-2 div:nth-child(2) ul:nth-child(1) li:nth-child(2) span').innerHTML = numberComma(contractUnitPraiceAll);
			//올해 지출 총계
			document.querySelector('.spcDashboard1-2 div:nth-child(2) ul:nth-child(2) li:nth-child(2) span').innerHTML = numberComma(totalExpenditure);

			//올해 이익률
			document.querySelector('.spcDashboard1-1 div:nth-child(2) p.number-unit span').innerHTML = Math.floor((profit / contractUnitPraiceAll) * 100);

			//종합 지출 총계
			document.querySelector('.spcDashboard2-1 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard2-2 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard2-3 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard3-1 div.title-area span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard3-2 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');

			let seriesLength = expenditureChart.series.length;
			for (let i = seriesLength - 1; i > -1; i--) {
				expenditureChart.series[i].remove();
			}

			const expenditureCategory = new Array();
			expenditureTemplate.forEach((el, index) => {
				expenditureCategory.push(el['name']);
			});

			let chartSeries = new Object();
			chartSeries.name = '지출액';
			chartSeries.color = 'var(--turquoise)';
			chartSeries.data = expenditureInfo;
			chartSeries.pointWidth = 9;
			chartSeries.pointPadding = 0.25;
			chartSeries.tooltip = {valueSuffix: '원'}
			expenditureChart.addSeries(chartSeries, false);

			expenditureChart.update({
				xAxis: {
					categories: expenditureCategory,
				},
				yAxis: [{
					text: '원',
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				}],
				plotOptions: {
					pointPadding: 0.1,
				},
			});
			expenditureChart.redraw();


			seriesLength = expenditureCapacityChart.series.length;
			for (let i = seriesLength - 1; i > -1; i--) {
				expenditureCapacityChart.series[i].remove();
			}

			expenditureInfo.forEach((expenditure, idx) => {
				expenditureInfo[idx] = Math.round((expenditure / spcAllCapacity) * 100) / 100 ;
			});

			chartSeries = new Object();
			chartSeries.name = '지출액';
			chartSeries.type = 'column';
			chartSeries.color = 'var(--turquoise)';
			chartSeries.data = expenditureInfo;
			chartSeries.tooltip = {valueSuffix: '원'}
			expenditureCapacityChart.addSeries(chartSeries, false);

			expenditureCapacityChart.update({
				xAxis: {
					categories: expenditureCategory,
				}
			});
			expenditureCapacityChart.redraw();

			//발전소 수입/지출 현황
			spcTable.clear();
			spcTable.rows.add(tableData).draw();
		}).catch(error => {
			console.error('Func spcList', error);
			errorMsg('오류가 발생햇습니다.');
		});
	}

	/**
	 * 에러 처리
	 *
	 * @param msg
	 */
	const errorMsg = msg => {
		$('#errMsg').text(msg);
		$('#errorModal').modal('show');
		setTimeout(function(){
			$('#errorModal').modal('hide');
		}, 1800);
	}

	const expenditureChart = Highcharts.chart('graph2', {
		chart: {
			renderTo: 'graph2',
			height: 340,
			backgroundColor: 'transparent',
			type: 'bar',
		},
		navigation: {
			buttonOptions: { enabled: false }
		},
		title: { text: '' },
		subtitle: { text: '' },
		xAxis: {
			min: 0,
			lineColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			labels: {
				align: 'left',
				overflow: 'justify',
				reserveSpace: true,
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					lineHeight: '24px'
				}
			},
			categories: null,
			title: {
				text: ''
			},
			showEmpty: false
		},
		yAxis: {
			y: 28,
			lineColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 0
			}],
			gridLineWidth: 0,
			min: 0,
			title: {
				text: '(만원)',
				x: -200,
				y: -20,
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-25px, 0px)'
				}
			},
			labels: {
				formatter: function () {
					const yAxisValue = displayNumberFixedUnit(this.value, '원', '만원', 0);
					return yAxisValue[0];
				},
				overflow: 'justify',
				x: -10,
				y: 28,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			}
		},
		legend: {
			enabled: false,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -15,
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					if (point.y > 10000) {
						let val = displayNumberFixedUnit(point.y, '원', '만원', 0, 'round')
						return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + val.join(' ');
					} else {
						return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + point.y + '원';
					}
				}, '<span style="display:flex;"><b>' + this.x + '</b></span>');
			},
			shared: true,
			useHTML: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white87)',
			}
		},
		plotOptions: {
			series: {
				enabled: true,
				label: {
					connectorAllowed: true
				},
				borderWidth: 0,
				borderColor: 'transparent'
			},
			bar: {
				dataLabels: {
					enabled: true,
					// inside: true,
					style: {
						color: 'var(--white87)',
						fontSize: '9px',
						fontWeight: 400,
						textOutline: 0,
						textAlign: 'right',
						textShadow: true,
					},
					formatter: function () {
						let val = displayNumberFixedUnit(this.y, '원', '원', 0, 'round');
						return val.join(' ');
					}
				},
			},
		},
		credits: {
			enabled: false
		}
	});

	const expenditureCapacityChart = Highcharts.chart('graph4', {
		chart: {
			marginLeft: 60,
			marginRight: 10,
			backgroundColor: 'transparent',
			zoomType: 'xy'
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
			tickWidth: 1,
			tickColor: 'var(--grey)',
			tickInterval: 1,
			gridLineColor: 'var(--white25)',
			labels: {
				align: 'center',
				y: 30,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				},
				rotate: 0
			},
			tickInterval: 1,
			title: {
				text: null
			},
			min: 0,
			max: 4,
			scrollbar: {
				enabled: false
			},
			crosshair: true
		}],
		yAxis: [{
			lineColor: 'var(--grey)',
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			gridLineWidth: 1,
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			title: {
				text: '(원)',
				align: 'low',
				rotation: 0,
				y: 30,
				x: 40,
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-28px, 0px)'
				}
			},
			labels: {
				formatter: function () {
					if (this.value < 10000) {
						return this.value
					} else {
						const yAxisValue = displayNumberFixedUnit(this.value, '원', '만원', 0);
						return yAxisValue[0];
					}
				},
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			showEmpty: false
		}],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					if (point.y > 10000) {
						let val = displayNumberFixedUnit(point.y, '원', '만원', 0, 'round')
						return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + val.join(' ');
					} else {
						return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + point.y + '원';
					}
				}, '<span style="display:flex;"><b>' + this.x + '</b></span>');
			},
			shared: true,
			useHTML: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white87)',
				fontSize: '12px'
			}
		},
		legend: {
			enabled: false,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -15,
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 0,
			symbolHeight: 7
		},

		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderWidth: 0,
				events: {
					click: function (event) {
						const x = event.point.category;
						goPvGen(x, 'day');
					}
				}
			},
			line: {
				marker: {
					enabled: false
				}
			},
			column: {
				stacking: 'normal'
			}
		},
		series: [],
		credits: {
			enabled: false
		}
	});
</script>
