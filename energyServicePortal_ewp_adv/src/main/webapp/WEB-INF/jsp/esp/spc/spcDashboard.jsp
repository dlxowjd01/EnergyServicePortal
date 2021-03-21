<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<link type="text/css" rel="stylesheet" href="/css/spcDashboard.css" />
<script type="text/javascript" src="/js/modules/treemap.js"></script>
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header"></div>
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
		</div>
	</div>
</div>

<div class="row content-wrapper" id="spcDashboardContent">
	<div class="indiv spcDashboard1-1">
		<div>
			<h2 class="title">발전 현황</h2>
			<p class="number-unit"><span></span> </p>
		</div>
		<div>
			<h2 class="title">올해 이익률</h2>
			<p class="number-unit"><span></span> %</p>
		</div>
	</div>

	<div class="indiv spcDashboard1-2">
		<div>
			<h2 class="title">올해 이익금</h2>
			<p class="number-unit"><span></span> 원</p>
		</div>
		<div>
			<ul>
				<li>올해 수입총계</li>
				<li><span></span> 원</li>
			</ul>
			<ul>
				<li>올해 지출총계</li>
				<li><span></span> 원</li>
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
			<div class="spcDetail">
				<span class="blue">-위</span>
				<div>
					<p>지출 총계</p>
					<div>
						<p class="number-unit">
							<span></span> 만원
						</p>
					</div>
				</div>
			</div>
			<div class="spcDetail">
				<span class="blue">-위</span>
				<div>
					<p>1MW 당</p>
					<div>
						<p class="number-unit">
							<span></span> 만원
						</p>
					</div>
				</div>
			</div>
			<div class="spcDetail">
				<span class="blue">-위</span>
				<div>
					<p>지출대비 비율</p>
					<div>
						<p class="number-unit">
							<span></span> %
						</p>
					</div>
				</div>
			</div>
			<div class="spcDetail">
				<span class="blue">-위</span>
				<div>
					<p>관리운영대비 비율</p>
					<div>
						<p class="number-unit">
							<span></span> 만원
						</p>
					</div>
				</div>
			</div>
			<div class="spcDetail">
				<span class="normal">변동없음</span>
				<div>
					<p>전월 대비</p>
					<div>
						<p class="number-unit">
							<span></span> %
						</p>
					</div>
				</div>
			</div>
			<div class="spcDetail">
				<span class="normal">변동없음</span>
				<div>
					<p>전년 대비</p>
					<div>
						<p class="number-unit">
							<span></span> %
						</p>
					</div>
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
				<div></div>
				<p>
					<span>100%</span>
					<span>80%</span>
				</p>
			</div>
			<div class="actived">
				<div></div>
				<p>60%</p>
			</div>
			<div class="actived">
				<div></div>
				<p>40%</p>
			</div>
			<div class="actived">
				<div></div>
				<p>20%</p>
			</div>
			<div class="actived">
				<div></div>
				<p>0%</p>
			</div>
			<div class="actived">
				<div></div>
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
<%--				<h2 class="title actived">--%>
<%--					항목별 지출--%>
<%--				</h2>--%>
				<h2 class="title">
					용량대비 지출/관리운영비 추이
				</h2>
				<span></span>
			</div>
<%--			<ul class="interval-selector">--%>
<%--				<li class="actived">월별</li>--%>
<%--				<li>연도별</li>--%>
<%--			</ul>--%>
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

<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	const expenditureTemplate = [
		{ name: '보험료', column: [], color: 'var(--turquoise)', chartColor:'var(--robin-s-egg-blue)'},
		{ name: '세금과 공과', column: ['지방세', '종합부동산세', '세금과공과_기타'], color: 'var(--turquoise)', chartColor:'var(--tealish)'},
		{ name: '기장료', column: ['기장료'], color: 'var(--turquoise)', chartColor:'var(--teal)'},
		{ name: '등기용역수수료', column: ['등기용역수수료'], color: 'var(--turquoise)', chartColor:'var(--soft-blue-two)'},
		{ name: '회계감사수수료', column: ['회계감사수수료'], color: 'var(--turquoise)', chartColor:'var(--lightish-blue)'},
		{ name: '지급수수료', column: ['REC수수료', '재위탁수수료', '정기검사', '지급수수료_기타'], color: 'var(--turquoise)', chartColor:'var(--azul)'},
		{ name: '경비용역료', column: ['경비용역료'], color: 'var(--turquoise)', chartColor:'var(--soft-blue)'},
		{ name: '임대료', column: ['임대료'], color: 'var(--turquoise)', chartColor:'var(--light-urple)'},
		{ name: '전력비', column: ['전력비'], color: 'var(--turquoise)', chartColor:'var(--dark-lilac)'},
		{ name: '통신비', column: ['통신비'], color: 'var(--turquoise)', chartColor:'var(--apple-green)'},
		{ name: '전기안전관리대행수수료', column: ['전기안전관리대행수수료'], color: 'var(--turquoise)', chartColor:'var(--bluish-green)'},
		{ name: '수선유지비', column: [], color: 'var(--turquoise)', chartColor:'var(--ocean-green)'},
	];
	const seriesArray = [
		{name: '지출', type: 'column', color: 'var(--soft-blue-two)', suffix: '만원'},
		{name: '관리운영비', type: 'column', color: 'var(--lightish-blue)', suffix: '만원'},
		{name: '용량', type: 'spline', color: 'var(--white)', suffix: 'MW'},
	];
	const targetRange = [
		{min: 80, max: 100, index: 0},
		{min: 60, max: 80, index: 1},
		{min: 40, max: 60, index: 2},
		{min: 20, max: 40, index: 3},
		{min: 0, max: 20, index: 4},
		{min: -100, max: 0, index: 5},
	];

	let spcTable = null;

	const summary = (rank, expend, expendW, prepare, management, lastMonth, lastYear) => {
		const spcDetail = $('#spcCategory').next().find('div.spcDetail');
		spcDetail.eq(0).find('span').eq(0).html(rank + '위');
		spcDetail.eq(0).find('span').eq(1).html(expend);

		spcDetail.eq(1).find('span').eq(0).html(rank + '위');
		spcDetail.eq(1).find('span').eq(1).html(expendW);

		spcDetail.eq(2).find('span').eq(0).html(rank + '위');
		spcDetail.eq(2).find('span').eq(1).html(prepare);

		spcDetail.eq(3).find('span').eq(0).html(rank + '위');
		spcDetail.eq(3).find('span').eq(1).html(management);

		if (isEmpty(lastMonth) || lastMonth === 0 || !isFinite(lastMonth)) {
			spcDetail.eq(4).find('span').eq(0).removeAttr('class').addClass('normal').html('변동없음');
			spcDetail.eq(4).find('div').eq(1).html('<div><p class="number-unit"> <span>-</span> </p></div>');
		} else if (lastMonth > 0){
			spcDetail.eq(4).find('span').eq(0).removeAttr('class').addClass('increase').html('증가');
			spcDetail.eq(4).find('div').eq(1).html('<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>' + lastMonth + '</span> </p></div>');
		} else {
			spcDetail.eq(4).find('span').eq(0).removeAttr('class').addClass('decrease').html('감소');
			spcDetail.eq(4).find('div').eq(1).html('<div><img src="/img/spcDashboard/flat.svg" alt="감소" /><p class="number-unit"> <span>' + (lastMonth * -1) + '</span> </p></div>');
		}

		if (isEmpty(lastYear) || lastYear === 0 || !isFinite(lastYear)) {
			spcDetail.eq(5).find('span').eq(0).removeAttr('class').addClass('normal').html('변동없음');
			spcDetail.eq(5).find('div').eq(1).html('<div><p class="number-unit"> <span>-</span> </p></div>');
		} else if (lastYear > 0){
			spcDetail.eq(5).find('span').eq(0).removeAttr('class').addClass('increase').html('증가');
			spcDetail.eq(5).find('div').eq(1).html('<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>' + lastYear + '</span> </p></div>');
		} else {
			spcDetail.eq(5).find('span').eq(0).removeAttr('class').addClass('decrease').html('감소');
			spcDetail.eq(5).find('div').eq(1).html('<div><img src="/img/spcDashboard/flat.svg" alt="감소" /><p class="number-unit"> <span>' + (lastYear * -1) + '</span> </p></div>');
		}
	}
	$(function() {
		spcList();

		// 기본 상호작용
		$('#spcCategory > li').on('click', function(e) {
			const index = $('#spcCategory > li').index(this)
				, data = $(this).data();

			summary(data.rank, data.expend, data.expendW, data.prepare, data.management, data.lastMonth, data.lastYear);
			$(this).addClass('actived').siblings().removeClass('actived');
		});

		$('.spcDashboard-filter > div').on('click', function(e) {
			$(this).toggleClass('actived');
			spcTable.draw();
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

		//기능 후에 다시 적용
		// $('.spcDashboard3-1 > .title-area > .title').on('click', function(e) {
		// 	$('.spcDashboard3-1 > .title-area > .title').removeClass('actived');
		// 	$(this).addClass('actived');
		// });
		//
		// $('.interval-selector > li').on('click', function(e) {
		// 	$('.interval-selector > li').removeClass('actived');
		// 	$(this).addClass('actived');
		// });

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
					data: 'expenditureSum',
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
					title: '이익률<br/>(%)',
					data: 'yield',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data) || data === '-') {
							return '-';
						} else {
							return data;
						}
					},
					className: 'dt-right'
				},
				{
					title: '전월<br/>(%)',
					data: 'lastMonthYield',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data) || data === '-') {
							return '-';
						} else {
							let template = ``;
							if (data > 0) {
								template = `<img src="/img/spcDashboard/up.svg" alt="증가" /> ${'${data}'}`;
							} else if (data < 0) {
								template = `<img src="/img/spcDashboard/flat.svg" alt="감소" />  ${'${data * -1}'}`;
							} else {
								template = `${'${data}'}`;
							}

							return template;
						}
					},
					className: 'dt-right'
				},
				{
					title: '전년<br/>(%)',
					data: 'lastYearYield',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data) || data === '-') {
							return '-';
						} else {
							let template = ``;
							if (data > 0) {
								template = `<img src="/img/spcDashboard/up.svg" alt="증가" /> ${'${data}'}`;
							} else if (data < 0) {
								template = `<img src="/img/spcDashboard/flat.svg" alt="감소" />  ${'${data * -1}'}`;
							} else {
								template = `${'${data}'}`;
							}

							return template;
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

		$.fn.dataTable.ext.search.push (
			function(settings, data, dataIndex) {
				const targetData = data[3] === '-' ? 1 : Number(data[3]);

				let targetBoolean = false;
				targetRange.forEach(range => {
					if (range['min'] < targetData && range['max'] >= targetData) {
						if ($('.spcDashboard-filter > div').eq(range['index']).hasClass('actived')) {
							targetBoolean = true;
						}
					}
				});

				return targetBoolean;
			}
		)
	});

	const spcList = () => {
		//마지막 달
		const currentMonthMin = new Date(); currentMonthMin.setMonth(currentMonthMin.getMonth() - 1); currentMonthMin.setDate(1); //이번달 기준
		const currentMonthMax = new Date(); currentMonthMax.setDate(0); //이번달 기준

		//마지막 달의 이전달
		const lastMonthMin = new Date(); lastMonthMin.setMonth(lastMonthMin.getMonth() - 1); lastMonthMin.setDate(1); //이전달 기준
		const lastMonthMax = new Date(); lastMonthMax.setDate(0); //이전달 기준

		//작년 값 기준
		const lastYearMin = new Date(); lastYearMin.setFullYear(lastYearMin.getFullYear() - 1); lastYearMin.setMonth(lastYearMin.getMonth() - 1); lastYearMin.setDate(1);
		const lastYearMax = new Date(); lastYearMax.setFullYear(lastYearMax.getFullYear() - 1); lastYearMax.setMonth(lastYearMax.getMonth()); lastYearMax.setDate(0);

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
			const tableData = new Array();

			let totalExpenditure = 0;
			let capacityList = new Array(12).fill(0);
			let contractUnitPriceList = new Array(12).fill(0);
			let insuranceCostList = new Array(12).fill(0);
			let repairMaintenanceCostList = new Array(12).fill(0);
			let expenditureInfo = new Array(12).fill(0);

			let lastYearContractUnitPrice, lastYearInsuranceInfo, lastYearRepair;
			let lastMonthContractUnitPrice, lastMonthInsuranceInfo, lastMonthRepair;
			response.forEach((resData, index) => {
				const targetData = resData['data'];
				if (index === 0) {
					targetData.forEach(rowData => {
						const spcGens = rowData['spcGens'];

						if (!isEmpty(spcGens)) {
							spcGens.forEach(spcGen => {
								let contractUnitPrice = '', expenditure = '', insuranceCost = '';
								let contractUnitPriceCurrent = '', insuranceCostCurrent = '';
								let contractUnitPriceLastMonth = '', insuranceCostLastMonth = '';
								let contractUnitPriceLastYear = '', insuranceCostLastYear = '';

								//관리 운영 정보: 관리운영비 총액(계약 단가 총합)
								if (!isEmpty(spcGen['maintenance_info'])) {
									const maintenanceInfo = JSON.parse(spcGen['maintenance_info'])
										, fromTime = isEmpty(maintenanceInfo['관리_운영_기간_from']) ? null : new Date(maintenanceInfo['관리_운영_기간_from'])
										, toTime = isEmpty(maintenanceInfo['관리_운영_기간_to']) ? null : new Date(maintenanceInfo['관리_운영_기간_to']);

									if (fromTime != null && toTime !== null) {
										//작년 동일달 계약 단가 합산
										//관리 운영 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
										if (fromTime.getTime() <= lastYearMax.getTime() && toTime.getTime() >= lastYearMin.getTime()) {
											if (!isEmpty(maintenanceInfo['계약_단가'])) {
												if (isEmpty(lastYearContractUnitPrice)) {
													lastYearContractUnitPrice = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
													contractUnitPriceLastYear = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
												} else {
													lastYearContractUnitPrice += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
													contractUnitPriceLastYear += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
												}
											}
										}

										//이전달 계약 단가 합산
										//관리 운영 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
										if (fromTime.getTime() <= lastMonthMax.getTime() && toTime.getTime() >= lastMonthMin.getTime()) {
											if (!isEmpty(maintenanceInfo['계약_단가'])) {
												if (isEmpty(lastMonthContractUnitPrice)) {
													lastMonthContractUnitPrice = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
													contractUnitPriceLastMonth = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
												} else {
													lastMonthContractUnitPrice += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
													contractUnitPriceLastMonth += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
												}
											}
										}

										for (let i = 0; i < 12; i++) {
											const standardMin = new Date(currentMonthMin.getFullYear(), i, 1), standardMax = new Date(currentMonthMin.getFullYear(), i + 1, 0);
											//관리 운영 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
											if (fromTime.getTime() <= standardMax.getTime() && toTime.getTime() >= standardMin.getTime()) {
												if (!isEmpty(maintenanceInfo['계약_단가'])) {
													contractUnitPriceList[i] += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
													if (i <= currentMonthMax.getMonth()) {
														contractUnitPrice = Number(contractUnitPrice) + Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
														if (i === currentMonthMax.getMonth()) contractUnitPriceCurrent = Number(contractUnitPriceCurrent) + Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, ''));
													}
												}

												if (!isEmpty(maintenanceInfo['설치_용량'])) {
													capacityList[i] += Number(maintenanceInfo['설치_용량'].replace(/[^0-9]/g, ''));
												}
											}
										}
									}
								}

								if (!isEmpty(spcGen['spend_info'])) {
									const spendInfo = JSON.parse(spcGen['spend_info']);
									expenditure = spendInfo['지출_총계'].replace(/[^0-9]/g, '');

									if (!isEmpty(spendInfo['지출_총계'])) {
										expenditure = Number(expenditure);
										totalExpenditure += expenditure;
									} else {
										expenditure = '-';
									}

									//종합 지출 총계
									Object.entries(spendInfo).forEach(([key, data]) => {
										const expenditureIndex = expenditureTemplate.findIndex(e => e['column'].includes(key));
										if (expenditureIndex > -1 && !isEmpty(data)) {
											expenditureInfo[expenditureIndex] += Number(data.replace(/[^0-9]/g, ''));
										}
									});
								}

								if (!isEmpty(spcGen['addlist_insurance_info'])) {
									const insuranceInfo = JSON.parse(spcGen['addlist_insurance_info'])
										, fromTime = isEmpty(insuranceInfo['보험_기간_from0']) ? null : new Date(insuranceInfo['보험_기간_from0'])
										, toTime = isEmpty(insuranceInfo['보험_기간_to0']) ? null : new Date(insuranceInfo['보험_기간_to0']);

									if (fromTime != null && toTime !== null) {
										//작년 동일달 보험료 총계 합산
										//보험 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
										if (fromTime.getTime() <= lastYearMax.getTime() && toTime.getTime() >= lastYearMin.getTime()) {
											if (!isEmpty(insuranceInfo['보험료_총계0'])) {
												if (isEmpty(lastYearInsuranceInfo)) {
													lastYearInsuranceInfo = Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
													insuranceCostLastYear = Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
												} else {
													lastYearInsuranceInfo += Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
													insuranceCostLastYear += Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
												}
											}
										}

										//이전달 동일달 보험료 총계 합산
										//보험 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
										if (fromTime.getTime() <= lastMonthMax.getTime() && toTime.getTime() >= lastMonthMin.getTime()) {
											if (!isEmpty(insuranceInfo['보험료_총계0'])) {
												if (isEmpty(lastMonthInsuranceInfo)) {
													lastMonthInsuranceInfo = Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
													contractUnitPriceLastMonth = Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
												} else {
													lastMonthInsuranceInfo += Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
													contractUnitPriceLastMonth += Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
												}
											}
										}

										for (let i = 0; i < 12; i++) {
											const standardMin = new Date(currentMonthMin.getFullYear(), i, 1), standardMax = new Date(currentMonthMin.getFullYear(), i + 1, 0);
											//보험 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
											if (fromTime.getTime() <= standardMax.getTime() && toTime.getTime() >= standardMin.getTime()) {
												if (!isEmpty(insuranceInfo['보험료_총계0'])) {
													insuranceCostList[i] += Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
													if (i <= currentMonthMax.getMonth()) {
														insuranceCost = Number(insuranceCost) + Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
														if (i === currentMonthMax.getMonth()) insuranceCostCurrent = Number(insuranceCostCurrent) + Number(insuranceInfo['보험료_총계0'].replace(/[^0-9]/g, ''));
													}
												}
											}
										}
									}
								}

								tableData.push({
									id: spcGen.gen_id,
									name: spcGen.name,
									contractUnitPrice: contractUnitPrice,
									contractUnitPriceCurrent: contractUnitPriceCurrent,
									contractUnitPriceLastMonth: contractUnitPriceLastMonth,
									contractUnitPriceLastYear: contractUnitPriceLastYear,
									insuranceCost: insuranceCost,
									insuranceCostCurrent: insuranceCostCurrent,
									insuranceCostLastMonth: insuranceCostLastMonth,
									insuranceCostLastYear: insuranceCostLastYear,
									expenditure: expenditure,
									month: new Date().getMonth(),
								});
							});
						}
					});
				} else {
					targetData.forEach(rowData => {
						const workInfo = JSON.parse(rowData['work_info'])
							, repairMaintenanceInfo = JSON.parse(rowData['repair_maintenance_info'])
							, fromTime = workInfo['출장_시기_from'] ? null : new Date(workInfo['출장_시기_from'])
							, toTime = workInfo['출장_시기_to'] ? null : new Date(workInfo['출장_시기_to'])
							, tableIndex = tableData.findIndex(e => e.id === rowData.site_id);

						if (!isEmpty(repairMaintenanceInfo) && !isEmpty(fromTime) && !isEmpty(toTime) && tableIndex > -1) {
							if (fromTime.getTime() <= lastYearMax.getTime() && toTime.getTime() >= lastYearMin.getTime()) {
								if (isEmpty(tableData[tableIndex]['lastYearRepair'])) {
									tableData[tableIndex]['lastYearRepair'] = Number(repairMaintenanceCost);
									lastYearRepair = Number(repairMaintenanceCost);
								} else {
									tableData[tableIndex]['lastYearRepair'] += Number(repairMaintenanceCost);
									lastYearRepair += Number(repairMaintenanceCost);
								}
							}

							if (fromTime.getTime() <= lastMonthMax.getTime() && toTime.getTime() >= lastMonthMin.getTime()) {
								if (isEmpty(tableData[tableIndex]['lastMonthRepair'])) {
									tableData[tableIndex]['lastMonthRepair'] = Number(repairMaintenanceCost);
									lastMonthRepair = Number(repairMaintenanceCost);
								} else {
									tableData[tableIndex]['lastMonthRepair'] += Number(repairMaintenanceCost);
									lastMonthRepair += Number(repairMaintenanceCost);
								}
							}

							for (let i = 0; i < 12; i++) {
								const standardMin = new Date(currentMonthMin.getFullYear(), i, 1)
									, standardMax = new Date(currentMonthMin.getFullYear(), i + 1, 0);

								if (!isEmpty(repairMaintenanceInfo['총_수선_유지비'])) {
									const repairMaintenanceCost = repairMaintenanceInfo['총_수선_유지비'].replace(/[^0-9]/g, '');
									if (fromTime.getTime() <= standardMax.getTime() && toTime.getTime() >= standardMin.getTime()) {
										repairMaintenanceCostList[i] += Number(repairMaintenanceCost);
										if (isEmpty(tableData[tableIndex]['repairMaintenanceCost'])) {
											tableData[tableIndex]['repairMaintenanceCost'] = Number(repairMaintenanceCost);
											if (currentMonthMax.getMonth() === i) {
												tableData[tableIndex]['currentRepair'] = Number(repairMaintenanceCost);
											} else if (currentMonthMax.getMonth() - 1 === i) {
												tableData[tableIndex]['lastMonthRepair'] = Number(repairMaintenanceCost);
											}
										} else {
											tableData[tableIndex]['repairMaintenanceCost'] += Number(repairMaintenanceCost);
											if (currentMonthMax.getMonth() === i) {
												tableData[tableIndex]['currentRepair'] += Number(repairMaintenanceCost);
											} else if (currentMonthMax.getMonth() - 1 === i) {
												tableData[tableIndex]['lastMonthRepair'] += Number(repairMaintenanceCost);
											}
										}
									}
								}
							}
						}
					});
				}
			});

			insuranceCostList.forEach((cost, index) => {
				if (index <= currentMonthMax.getMonth()) {
					expenditureInfo[0] += cost
				}
			});

			repairMaintenanceCostList.forEach((repair, index) => {
				if (index <= currentMonthMax.getMonth()) {
					expenditureInfo[11] += repair
				}
			});

			return {capacityList, contractUnitPriceList, insuranceCostList, repairMaintenanceCostList, expenditureInfo, lastYearContractUnitPrice, lastYearInsuranceInfo, lastYearRepair, tableData};
		}).then(({capacityList, contractUnitPriceList, insuranceCostList, repairMaintenanceCostList, expenditureInfo, lastYearContractUnitPrice, lastYearInsuranceInfo, lastYearRepair, tableData}) => {
			const lastMonth = new Date(); lastMonth.setDate(0);
			const currentMonth = new Date().getMonth();

			//발전 현황 (설비 용량)
			const refineCapacity = displayNumberFixedDecimal(capacityList[currentMonth], 'kW', 3, 2);
			document.querySelector('.spcDashboard1-1 div:nth-child(1) .number-unit').innerHTML = '<span>' + refineCapacity[0] + '</span>' + refineCapacity[1];

			//올해 이익금
			const expenditureDup = expenditureInfo.slice();
			expenditureDup.forEach((expend, index) => { if (index !== 0 && index !== 11) { expenditureDup[index] = expend * currentMonth; } });

			const expenditure = expenditureDup.reduce( function add(sum, currValue) { return Number(sum) + Number(currValue); });
			const totalExpenditure = expenditure;
			const profit = (contractUnitPriceList[currentMonth] * currentMonth) - totalExpenditure;
			document.querySelector('.spcDashboard1-2 div:nth-child(1) p.number-unit span').innerHTML = numberComma(profit);
			//올해 수입 총계
			document.querySelector('.spcDashboard1-2 div:nth-child(2) ul:nth-child(1) li:nth-child(2) span').innerHTML = numberComma(contractUnitPriceList[currentMonth] * currentMonth);
			//올해 지출 총계
			document.querySelector('.spcDashboard1-2 div:nth-child(2) ul:nth-child(2) li:nth-child(2) span').innerHTML = numberComma(totalExpenditure);
			//올해 이익률
			document.querySelector('.spcDashboard1-1 div:nth-child(2) p.number-unit span').innerHTML = Math.floor((profit / (contractUnitPriceList[currentMonth] * currentMonth)) * 100);

			//종합 지출 총계
			document.querySelector('.spcDashboard2-1 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard2-2 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard2-3 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard3-1 div.title-area span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard3-2 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');

			const rankExpend = rank(expenditureInfo);
			expenditureInfo.forEach((expend, index) => {
				let target = $('#spcCategory li').eq(index);

				target.data('rank', rankExpend[index]);
				target.data('expend', numberComma(Math.floor(expend / 10000)));
				target.data('expendW', numberComma(Math.floor((expend /(capacityList[currentMonth] / 1000000)) / 10000)));
				target.data('prepare', numberComma(Math.floor((expend / totalExpenditure) * 100)));
				target.data('management', numberComma(Math.floor((expend / contractUnitPriceList[currentMonth]) * 100)));

				if (index === 0 || index === 11) {
					let current, lastMonth, lastYear;
					if (index === 0) {
						current = tableData.map(el => el['insuranceCostCurrent']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastMonth = tableData.map(el => el['insuranceCostLastMonth']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastYear = tableData.map(el => el['insuranceCostLastYear']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); });
					} else {
						current = tableData.map(el => el['currentRepair']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastMonth = tableData.map(el => el['lastMonthRepair']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastYear = tableData.map(el => el['lastYearRepair']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); });
					}

					if (!isEmpty(lastMonth)) target.data('lastMonth', ((current - lastMonth) / lastMonth) * 100);
					else target.data('lastMonth', '');

					if (!isEmpty(lastYear)) target.data('lastYear', ((current - lastYear) / lastYear) * 100);
					else target.data('lastYear', '');
				} else {
					target.data('lastMonth', '');
					target.data('lastYear', '');
				}

				if (index === 0) {
					summary(target.data('rank'), target.data('expend'), target.data('expendW'), target.data('prepare'), target.data('management'), target.data('lastMonth'), target.data('lastYear'));
				}
			});

			//평균 지출 비용
			let seriesLength = expenditureTreeChart.series.length;
			for (let i = seriesLength - 1; i > -1; i--) { expenditureTreeChart.series[i].remove(); }
			let chartSeries = new Object();
			chartSeries.showInLegend = true;
			chartSeries.legendType = 'point';

			let treeData = new Array();
			let chartValueTotal = 0;
			expenditureTemplate.forEach((temp, index) => {
				let chartValue = Math.round((expenditureDup[index] / totalExpenditure) * 100);
				if (!isFinite(chartValue)) chartValue = 0;
				chartValueTotal += chartValue;

				treeData.push({
					name: temp['name'],
					value: chartValue,
					color: temp['chartColor'],
				})
			});

			const max = treeData.reduce( function (previous, current) {
				if (isNaN(previous)) return previous['value'] > current['value'] ? previous['value']:current['value'];
				else return previous > current['value'] ? previous:current['value'];
			});

			const maxIndex = treeData.findIndex(e => e['value'] === max);
			treeData[maxIndex]['value'] = max - (chartValueTotal - 100);
			chartSeries.data = treeData;

			expenditureTreeChart.addSeries(chartSeries, false);
			expenditureTreeChart.redraw();
			//평균 지출 비용

			//종합 지출 총계
			seriesLength = expenditureChart.series.length;
			for (let i = seriesLength - 1; i > -1; i--) { expenditureChart.series[i].remove(); }

			const expenditureCategory = new Array();
			expenditureTemplate.forEach((el, index) => {
				expenditureCategory.push(el['name']);
			});

			chartSeries = new Object();
			chartSeries.name = '지출액';
			chartSeries.color = 'var(--turquoise)';
			chartSeries.data = expenditureDup;
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
			//종합 지출 총계

			//용량대비 지출 / 관리운영비 추이
			seriesLength = expenditureTransitionChart.series.length;
			for (let i = seriesLength - 1; i > -1; i--) {
				expenditureTransitionChart.series[i].remove();
			}

			seriesArray.forEach((el, index) => {
				let chartSeries = new Object();
				chartSeries.name = el.name;
				chartSeries.type = el.type;
				chartSeries.color = el.color;

				if (index === 0) {
					const chartArray = new Array(12).fill(0);
					for (let i = 0; i < currentMonth; i++) {
						chartArray[i] += Math.floor((insuranceCostList[i] + repairMaintenanceCostList[i]) / 10000);
					}
					//chartSeries.showInLegend = false;
					chartSeries.data = chartArray;
					chartSeries.stack = 0;
				} else if (index === 1) {
					//chartSeries.showInLegend = false;
					const chartArray = contractUnitPriceList.slice()
					chartArray.forEach((price, index) => {
						if (index < currentMonth) {
							chartArray[index] = Math.floor(price / 10000);
						} else {
							chartArray[index] = null;
						}
					});

					chartSeries.stack = 1;
					chartSeries.data = chartArray;
				} else if (index === 2) {
					chartSeries.dashStyle = 'ShortDash';
					chartSeries.yAxis = 1;

					const chartArray = capacityList.slice();
					chartArray.forEach((capacity, index) => {
						if (index < currentMonth) {
							chartArray[index] = Math.floor(capacity / 1000000);
						} else {
							chartArray[index] = null;
						}
					});

					chartSeries.data = chartArray;
				}
				chartSeries.tooltip = {valueSuffix: (/원/.test(el.suffix)) ? '만원' : el.suffix}
				expenditureTransitionChart.addSeries(chartSeries, false);
			});
			expenditureTransitionChart.redraw();

			//MW당 항목별 지출금액
			seriesLength = expenditureCapacityChart.series.length;
			for (let i = seriesLength - 1; i > -1; i--) {
				expenditureCapacityChart.series[i].remove();
			}

			expenditureInfo.forEach((expenditure, idx) => {
				expenditureInfo[idx] = Math.round((expenditure / (capacityList[currentMonth] / 1000000)) * 100) / 100 ;
			});

			chartSeries = new Object();
			chartSeries.name = '지출';
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
			tableData.forEach(data => {
				const month = new Date().getMonth();
				const contractUnitPrice = isEmpty(data['contractUnitPrice']) ? '' : data['contractUnitPrice']
					, contractUnitPriceCurrent = isEmpty(data['contractUnitPriceCurrent']) ? '' : data['contractUnitPriceCurrent']
					, contractUnitPriceLastMonth = isEmpty(data['contractUnitPriceLastMonth']) ? '' : data['contractUnitPriceLastMonth']
					, contractUnitPriceLastYear = isEmpty(data['contractUnitPriceLastYear']) ? '' : data['contractUnitPriceLastYear']
					, expenditure = (isEmpty(data['expenditure']) || data['expenditure'] === '-') ? '' : data['expenditure']
					, insuranceCost = isEmpty(data['insuranceCost']) ? '' : data['insuranceCost']
					, insuranceCostCurrent = isEmpty(data['insuranceCostCurrent']) ? '' : data['insuranceCostCurrent']
					, insuranceCostLastMonth = isEmpty(data['insuranceCostLastMonth']) ? '' : data['insuranceCostLastMonth']
					, insuranceCostLastYear = isEmpty(data['insuranceCostLastYear']) ? '' : data['insuranceCostLastYear']
					, repairMaintenanceCost = isEmpty(data['repairMaintenanceCost']) ? '' : data['repairMaintenanceCost']
					, currentRepair = isEmpty(data['currentRepair']) ? '' : data['currentRepair']
					, lastMonthRepair = isEmpty(data['lastMonthRepair']) ? '' : data['lastMonthRepair']
					, lastYearRepair = isEmpty(data['lastYearRepair']) ? '' : data['lastYearRepair']
					, expenditureSum = (Number(expenditure) * month) + Number(insuranceCost) + Number(repairMaintenanceCost)
					, lastMonthexpEnditureSum = Number(expenditure) + Number(insuranceCostLastMonth) + Number(lastMonthRepair)  //이전달 지출
					, lastYearMonthexpEnditureSum = Number(expenditure) + Number(insuranceCostCurrent) + Number(lastYearRepair) //작년 마지막달과 동일달 지출
					, currentMonthexpEnditureSum = Number(expenditure) + Number(insuranceCostLastYear) + Number(currentRepair)  //마지막달 지출
					, yield = Math.floor(((Number(contractUnitPrice) - Number(expenditureSum)) / Number(contractUnitPrice)) * 100)
					, lastMonthYield = Math.floor(((Number(contractUnitPriceLastMonth) - Number(lastMonthexpEnditureSum)) / Number(contractUnitPriceLastMonth)) * 100)
					, lastYearYield = Math.floor(((Number(contractUnitPriceLastYear) - Number(lastYearMonthexpEnditureSum)) / Number(contractUnitPriceLastYear)) * 100)
					, currentYield = Math.floor(((Number(contractUnitPriceCurrent) - Number(currentMonthexpEnditureSum)) / Number(contractUnitPriceCurrent)) * 100);

				if (!isEmpty(expenditure) || !isEmpty(insuranceCost) || !isEmpty(repairMaintenanceCost)) {
					data['expenditureSum'] = expenditureSum;
				} else {
					data['expenditureSum'] = '';
				}

				if (isFinite(currentYield) && isFinite(lastMonthYield)) {
					data['lastMonthYield'] = currentYield - lastMonthYield;
				} else {
					data['lastMonthYield'] = '';
				}

				if (isFinite(currentYield) && isFinite(lastYearYield)) {
					data['lastYearYield'] = currentYield - lastYearYield;
				} else {
					data['lastYearYield'] = '';
				}

				if (isFinite(yield)) {
					data['yield'] = yield;
				} else {
					data['yield'] = '';
				}
			});

			let yieldArray = [0, 0, 0, 0, 0, 0];
			tableData.forEach(data =>{
				if (data.yield >= 80) {
					yieldArray[0]++;
				} else if (data.yield < 80 && data.yield >= 60) {
					yieldArray[1]++;
				} else if (data.yield < 60 && data.yield >= 40) {
					yieldArray[2]++;
				} else if (data.yield < 40 && data.yield >= 20) {
					yieldArray[3]++;
				} else if (data.yield < 20 && data.yield >= 0) {
					yieldArray[4]++;
				} else if (data.yield < 0) {
					yieldArray[5]++;
				}
			});

			$('.spcDashboard2-3 > .spcDashboard-filter > div').each(function() {
				const index = $('.spcDashboard2-3 > .spcDashboard-filter > div').index(this);
				$(this).find('div').html(yieldArray[index]);
			});

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

	const expenditureTreeChart = Highcharts.chart('graph1', {
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		// legend: {
		// 	enabled: true,
		// 	align: 'right',
		// 	verticalAlign: 'top',
		// 	x: 5,
		// 	y: -15,
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
			},
			itemHoverStyle: {
				color: ''
			},
		// 	symbolPadding: 0,
		// 	symbolHeight: 7
		// },
		legend: {
			layout: 'vertical',
			align: 'right',
			verticalAlign: 'middle',
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
			},
			itemHoverStyle: {
				color: ''
			},
			labelFormatter: function () {
				return `<div class="clear"><div class="fl">${'${this.name}'}</div> <div class="fr">${'${this.value}'} %</div></div>`;
			}
		},
		chart: {
			type: 'treemap',
			backgroundColor: 'transparent',
			layoutAlgorithm: 'squarified',
		},
		series: [{
			showInLegend: true,
			legendType: 'point',
			data: []
		}],
	});

	const expenditureTransitionChart = Highcharts.chart('graph3', {
		chart: {
			marginTop: 40,
			marginLeft: 50,
			marginRight: 50,
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
			gridLineColor: 'var(--white25)',
			type: 'datetime',
			dateTimeLabelFormats: {
				millisecond: '%H:%M:%S.%L',
				second: '%H:%M:%S',
				minute: '%H:%M',
				hour: '%H',
				day: '%m.%d ',
				week: '%m.%e',
				month: '%m',
				year: '%Y'
			},
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickWidth: 1,
			tickColor: 'var(--grey)',
			tickInterval: 1,
			title: {
				text: null
			},
			categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
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
				text: 'kWh',
				align: 'low',
				rotation: 0,
				y: 25,
				x: 15,
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-28px, 0px)'
				}
			},
			labels: {
				formatter: function () {
					const suffix = this.chart.yAxis[0].userOptions.title.text;
					const yAxisValue = displayNumberFixedUnit(this.value, 'kWh', suffix, 1);
					return yAxisValue[0];
				},
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			showEmpty: false
		}, {
			gridLineWidth: 0,
			title: {
				text: i18nManager.tr("gmain.1000won"),
				align: 'low',
				rotation: 0,
				y: 25,
				x: 0,
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-30px, 0px)'
				}
			},
			labels: {
				formatter: function () {
					return  numberComma(this.value);
				},
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-10px, 0px)'
				}
			},
			opposite: true,
			showEmpty: false
		}],
		tooltip: {
			hideDelay: 1,
			formatter: function () {
				return this.points.reduce(function (s, point) {
					if(point.y !== 0) {
						let suffix = point.series.userOptions.tooltip.valueSuffix;
						return s + ' <br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + numberComma(Math.round(point.y)) + ' ' + suffix;
					} else {
						return s
					}
				}, '<span style="display:flex;"><b>' + this.x + '월</b></span>');
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
		legend: {
			enabled: true,
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
					legendItemClick: function () {
						var visibility = this.visible ? 'visible' : 'hidden';
						this.legendItem.styles.color == 'var(--white60)'
						// var visibility = this.visible ? 'visible' : 'hidden';
					}
				},
				events: {
					click: function (event) {
						const x = event.point.category;
						goPvGen(x, 'hour');
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

	const rank = (arr) => {
		// Create a temporary array to keep metadata
		// regarding each entry of the original array
		const tmpArr = arr.map(v => ({
			value: v,
			rank: 1,
		}));

		// Get rid of douplicate values
		const unique = new Set(arr);

		// Loops through the set
		for (let a of unique) {
			for (let b of tmpArr) {
				// increment the order of an element if a larger element is pressent
				if (b.value < a) {
					b.rank += 1;
				}
			}
		}

		// Strip out the unnecessary metadata
		return tmpArr.map(v => v.rank);
	};
</script>
