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
			<h2 class="title">총 설비용량</h2>
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
							<span></span> %
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
<%--		<div>--%>
<%--			<div class="title-area">--%>
<%--				<h2 class="title actived">--%>
<%--					항목별 지출--%>
<%--				</h2>--%>
<%--				<h2 class="title">--%>
<%--					용량대비 지출/관리운영비 추이--%>
<%--				</h2>--%>
<%--				<span></span>--%>
<%--			</div>--%>
<%--			<ul class="interval-selector">--%>
<%--				<li class="actived">월별</li>--%>
<%--				<li>연도별</li>--%>
<%--			</ul>--%>
<%--		</div>--%>
		<h2 class="title">
			용량대비 지출/관리운영비 추이
			<span></span>
		</h2>

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
		{ name: '임대료', column: ['지출_정보_임대료'], color: 'var(--turquoise)', chartColor:'var(--light-urple)'},
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
		spcDetail.eq(0).find('span').eq(1).html(numberComma(expend));

		spcDetail.eq(1).find('span').eq(0).html(rank + '위');
		if (isFinite(expendW)) spcDetail.eq(1).find('span').eq(1).html(numberComma(expendW));
		else spcDetail.eq(1).find('span').eq(1).html('-');

		spcDetail.eq(2).find('span').eq(0).html(rank + '위');
		if (isFinite(prepare)) spcDetail.eq(2).find('span').eq(1).html(prepare);
		else spcDetail.eq(2).find('span').eq(1).html('-');

		spcDetail.eq(3).find('span').eq(0).html(rank + '위');
		if (isFinite(management)) spcDetail.eq(3).find('span').eq(1).html(numberComma(management));
		else spcDetail.eq(3).find('span').eq(1).html('-');

		if (isEmpty(lastMonth) || lastMonth === 0 || !isFinite(lastMonth)) {
			spcDetail.eq(4).find('span').eq(0).removeAttr('class').addClass('normal').html('변동없음');
			spcDetail.eq(4).find('div').eq(1).html('<div><img src="/img/spcDashboard/flat.svg" alt="변동없음" /><p class="number-unit"> <span>-</span> </p></div>');
		} else if (lastMonth > 0){
			spcDetail.eq(4).find('span').eq(0).removeAttr('class').addClass('increase').html('증가');
			spcDetail.eq(4).find('div').eq(1).html('<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>' + lastMonth.toFixed(2) + '</span> %</p></div>');
		} else {
			spcDetail.eq(4).find('span').eq(0).removeAttr('class').addClass('decrease').html('감소');
			spcDetail.eq(4).find('div').eq(1).html('<div><img src="/img/spcDashboard/down.svg" alt="증가" /><p class="number-unit"> <span>' + (lastMonth * -1).toFixed(2) + '</span> %</p></div>');
		}

		if (isEmpty(lastYear) || lastYear === 0 || !isFinite(lastYear)) {
			spcDetail.eq(5).find('span').eq(0).removeAttr('class').addClass('normal').html('변동없음');
			spcDetail.eq(5).find('div').eq(1).html('<div><img src="/img/spcDashboard/flat.svg" alt="변동없음" /><p class="number-unit"> <span>-</span> </p></div>');
		} else if (lastYear > 0){
			spcDetail.eq(5).find('span').eq(0).removeAttr('class').addClass('increase').html('증가');
			spcDetail.eq(5).find('div').eq(1).html('<div><img src="/img/spcDashboard/up.svg" alt="증가" /><p class="number-unit"> <span>' + lastYear.toFixed(2) + '</span> %</p></div>');
		} else {
			spcDetail.eq(5).find('span').eq(0).removeAttr('class').addClass('decrease').html('감소');
			spcDetail.eq(5).find('div').eq(1).html('<div><img src="/img/spcDashboard/down.svg" alt="증가" /><p class="number-unit"> <span>' + (lastYear * -1).toFixed(2) + '</span> %</p></div>');
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
								template = `<img src="/img/spcDashboard/up.svg" alt="증가" /> ${'${data.toFixed(2)}'}`;
							} else if (data < 0) {
								template = `<img src="/img/spcDashboard/down.svg" alt="감소" />  ${'${(data * -1).toFixed(2)}'}`;
							} else {
								template = `<img src="/img/spcDashboard/flat.svg" alt="변동없음" /> ${'${data.toFixed(2)}'}`;
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
								template = `<img src="/img/spcDashboard/up.svg" alt="증가" /> ${'${data.toFixed(2)}'}`;
							} else if (data < 0) {
								template = `<img src="/img/spcDashboard/down.svg" alt="감소" />  ${'${(data * -1).toFixed(2)}'}`;
							} else {
								template = `<img src="/img/spcDashboard/flat.svg" alt="변동없음" /> ${'${data.toFixed(2)}'}`;
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
				targetRange.forEach((range, index) => {
					if (index === 5) {
						if (range['min'] > targetData) {
							if ($('.spcDashboard-filter > div').eq(range['index']).hasClass('actived')) {
								targetBoolean = true;
							}
						}
					} else {
						if (range['min'] < targetData && range['max'] >= targetData) {
							if ($('.spcDashboard-filter > div').eq(range['index']).hasClass('actived')) {
								targetBoolean = true;
							}
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
		const lastMonthMin = new Date();lastMonthMin.setMonth(lastMonthMin.getMonth() - 2); lastMonthMin.setDate(1); //이전달 기준
		const lastMonthMax = new Date(); lastMonthMax.setMonth(lastMonthMax.getMonth() - 1); lastMonthMax.setDate(0); //이전달 기준

		//작년 값 기준
		const lastYearMin = new Date(currentMonthMin.getFullYear() - 1, currentMonthMin.getMonth(), 1);
		const lastYearMax = new Date(currentMonthMax.getFullYear() - 1, currentMonthMax.getMonth() + 1, 0);

		const currentMonth = new Date().getMonth();

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

		targetApi.push($.ajax({
			url: apiHost + '/auth/me/sites',
			type: 'GET'
		}));

		new Promise ((resolve, reject) => {
			resolve(Promise.all(targetApi));
		}).then(response => {
			let haveSite = new Array();
			if (isEmpty(response[2])) {
				throw new Error('조회가능한 사이트가 없습니다. 사용자 관리 설정을 확인해주세요.');
			} else {
				haveSite = [...response[2].map(el => el['sid'])]
			}

			const tableData = new Array();

			let capacityList = new Array(12).fill(0);
			let contractUnitPriceList = new Array(12).fill(0);
			let insuranceCostList = new Array(12).fill(0);
			let repairMaintenanceCostList = new Array(12).fill(0);
			let expenditureInfo = new Array(12);

			let lastYearContractUnitPrice, lastYearInsuranceInfo, lastYearRepair;
			let lastMonthContractUnitPrice, lastMonthInsuranceInfo, lastMonthRepair;
			response.forEach((resData, index) => {
				const targetData = resData['data'];
				if (index === 0) {
					targetData.forEach(rowData => {
						const spcGens = rowData['spcGens'];

						if (!isEmpty(spcGens)) {
							spcGens.forEach(spcGen => {

								if (!haveSite.includes(spcGen['gen_id'])) return false;

								let contractUnitPrice = '', expenditure = '', insuranceCost = '';
								let contractUnitPriceCurrent = '', insuranceCostCurrent = '';
								let contractUnitPriceLastMonth = '', insuranceCostLastMonth = '';
								let contractUnitPriceLastYear = '', insuranceCostLastYear = '';

								let expenditureCurrent, expenditureLastMonth, expenditureLastYear;

								//관리 운영 정보: 관리운영비 총액(계약 단가 총합)
								if (!isEmpty(spcGen['maintenance_info'])) {
									const maintenanceInfo = JSON.parse(spcGen['maintenance_info'])
										, fromTime = isEmpty(maintenanceInfo['관리_운영_기간_from']) ? null : new Date(maintenanceInfo['관리_운영_기간_from'])
										, toTime = isEmpty(maintenanceInfo['관리_운영_기간_to']) ? null : new Date(maintenanceInfo['관리_운영_기간_to']);

									if (fromTime != null && toTime !== null) {
										//작년 동일달 계약 단가 합산
										//관리 운영 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
										if (fromTime.getTime() <= lastYearMax.getTime() && toTime.getTime() >= lastYearMin.getTime()) {
											let daily = 1;
											if (toTime.getFullYear() === lastYearMax.getFullYear() && toTime.getMonth() === lastYearMax.getMonth()) daily = toTime.getDate() / lastYearMax.getDate();
											if (!isEmpty(maintenanceInfo['계약_단가'])) {
												if (isEmpty(lastYearContractUnitPrice)) {
													lastYearContractUnitPrice = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
													contractUnitPriceLastYear = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
												} else {
													lastYearContractUnitPrice += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
													contractUnitPriceLastYear += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
												}
											}

											if (!isEmpty(spcGen['spend_info'])) {
												const spendInfo = JSON.parse(spcGen['spend_info']);
												//종합 지출 총계
												Object.entries(spendInfo).forEach(([key, data]) => {
													const expenditureIndex = expenditureTemplate.findIndex(e => e['column'].includes(key));
													if (expenditureIndex > -1 && !isEmpty(data)) {
														if (isEmpty(expenditureLastYear)) {
															expenditureLastYear = new Array(12).fill(0);
															expenditureLastYear[expenditureIndex] += Number(data.replace(/[^0-9]/g, '')) * daily;
														} else {
															expenditureLastYear[expenditureIndex] += Number(data.replace(/[^0-9]/g, '')) * daily;
														}
													}
												});
											}
										}

										//이전달 계약 단가 합산
										//관리 운영 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
										if (fromTime.getTime() <= lastMonthMax.getTime() && toTime.getTime() >= lastMonthMin.getTime()) {
											let daily = 1;
											if (toTime.getFullYear() === lastMonthMax.getFullYear() && toTime.getMonth() === lastMonthMax.getMonth()) daily = toTime.getDate() / lastMonthMax.getDate();

											if (!isEmpty(maintenanceInfo['계약_단가'])) {
												if (isEmpty(lastMonthContractUnitPrice)) {
													lastMonthContractUnitPrice = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
													contractUnitPriceLastMonth = Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
												} else {
													lastMonthContractUnitPrice += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
													contractUnitPriceLastMonth += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
												}
											}

											if (!isEmpty(spcGen['spend_info'])) {
												const spendInfo = JSON.parse(spcGen['spend_info']);
												Object.entries(spendInfo).forEach(([key, data]) => {
													const expenditureIndex = expenditureTemplate.findIndex(e => e['column'].includes(key));
													if (expenditureIndex > -1 && !isEmpty(data)) {
														if (isEmpty(expenditureLastMonth)) {
															expenditureLastMonth = new Array(12).fill(0);
															expenditureLastMonth[expenditureIndex] += Number(data.replace(/[^0-9]/g, '')) * daily;
														} else {
															expenditureLastMonth[expenditureIndex] += Number(data.replace(/[^0-9]/g, '')) * daily;
														}
													}
												});
											}
										}

										for (let i = 0; i < currentMonth; i++) {
											const spendInfo = JSON.parse(spcGen['spend_info']);
											const standardMin = new Date(currentMonthMin.getFullYear(), i, 1), standardMax = new Date(currentMonthMin.getFullYear(), i + 1, 0);
											//관리 운영 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
											if (fromTime.getTime() <= standardMax.getTime() && toTime.getTime() >= standardMin.getTime()) {
												let daily = 1;
												if (toTime.getFullYear() === standardMax.getFullYear() && toTime.getMonth() === standardMax.getMonth()) daily = toTime.getDate() / standardMax.getDate();

												if (!isEmpty(maintenanceInfo['계약_단가'])) {
													contractUnitPriceList[i] += Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
													if (i <= currentMonthMax.getMonth()) {
														contractUnitPrice = Number(contractUnitPrice) + Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
														if (i === currentMonthMax.getMonth()) {
															contractUnitPriceCurrent = Number(contractUnitPriceCurrent) + Number(maintenanceInfo['계약_단가'].replace(/[^0-9]/g, '')) * daily;
														}
													}
												}

												if (!isEmpty(spcGen['spend_info'])) {
													const spendInfo = JSON.parse(spcGen['spend_info']);
													//종합 지출 총계
													Object.entries(spendInfo).forEach(([key, data]) => {
														const expenditureIndex = expenditureTemplate.findIndex(e => e['column'].includes(key));
														if (expenditureIndex > -1 && !isEmpty(data)) {
															if (isEmpty(expenditureInfo[i])) {
																expenditureInfo[i] = new Array(12).fill(0);
																expenditureInfo[i][expenditureIndex] += Number(data.replace(/[^0-9]/g, '')) * daily;
															} else {
																expenditureInfo[i][expenditureIndex] += Number(data.replace(/[^0-9]/g, '')) * daily;
															}
														}
													});

													if (i < currentMonth) {
														const spendInfo = JSON.parse(spcGen['spend_info']);
														expenditure = Number(spendInfo['지출_총계'].replace(/[^0-9]/g, '')) * daily;

														if (i === currentMonth) {
															expenditureCurrent = expenditureInfo[i];
														}
													}
												}

												if (!isEmpty(maintenanceInfo['설치_용량'])) {
													capacityList[i] += Number(maintenanceInfo['설치_용량'].replace(/[^0-9]/g, ''));
												}
											}
										}
									}
								}

								if (!isEmpty(spcGen['addlist_insurance_info'])) {
									const insuranceInfo = JSON.parse(spcGen['addlist_insurance_info'])
										, targetArray = new Array();
									Object.entries(insuranceInfo).forEach(([key, value]) => {
										const targetIndex = key.replace(/[^0-9]/g, '');
										if (!targetArray.includes(targetIndex)) targetArray.push(targetIndex);
									});

									targetArray.forEach(target => {
										const fromTime = isEmpty(insuranceInfo['보험_기간_from' + target]) ? null : new Date(insuranceInfo['보험_기간_from' + target])
											, toTime = isEmpty(insuranceInfo['보험_기간_to' + target]) ? null : new Date(insuranceInfo['보험_기간_to' + target]);

										let totalInsurance = 0;
										Object.entries(insuranceInfo).forEach(([insuranceKey, insuranceData]) => {
											if (insuranceKey === '이행보증보험료' + target || insuranceKey === '보험료' + target) {
												totalInsurance += Number(String(insuranceData).replace(/[^0-9]/g, ''));
											}
										});

										if (fromTime != null && toTime !== null) {
											//작년 동일달 보험료 총계 합산
											//보험 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
											if (fromTime.getTime() <= lastYearMax.getTime() && toTime.getTime() >= lastYearMin.getTime()) {
												let daily = 1;
												if (toTime.getFullYear() === lastYearMax.getFullYear() && toTime.getMonth() === lastYearMax.getMonth()) daily = toTime.getDate() / lastYearMax.getDate();

												if (!isEmpty(totalInsurance)) {
													if (isEmpty(lastYearInsuranceInfo)) {
														lastYearInsuranceInfo = totalInsurance * daily;
														insuranceCostLastYear = totalInsurance * daily;
													} else {
														lastYearInsuranceInfo += totalInsurance * daily;
														insuranceCostLastYear += totalInsurance * daily;
													}
												}
											}

											//이전달 동일달 보험료 총계 합산
											//보험 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
											if (fromTime.getTime() <= lastMonthMax.getTime() && toTime.getTime() >= lastMonthMin.getTime()) {
												let daily = 1;
												if (toTime.getFullYear() === lastMonthMax.getFullYear() && toTime.getMonth() === lastMonthMax.getMonth()) daily = toTime.getDate() / lastMonthMax.getDate();

												if (!isEmpty(totalInsurance)) {
													if (isEmpty(lastMonthInsuranceInfo)) {
														lastMonthInsuranceInfo = totalInsurance * daily;
														insuranceCostLastMonth = totalInsurance * daily;
													} else {
														lastMonthInsuranceInfo += totalInsurance * daily;
														insuranceCostLastMonth += totalInsurance * daily;
													}
												}
											}

											for (let i = 0; i < currentMonth; i++) {
												const standardMin = new Date(currentMonthMin.getFullYear(), i, 1), standardMax = new Date(currentMonthMin.getFullYear(), i + 1, 0);
												//보험 기간의 시작일이 해당월이거나 그전이면서 종료일이 해당월이거나 그이후일경우
												if (fromTime.getTime() <= standardMax.getTime() && toTime.getTime() >= standardMin.getTime()) {
													let daily = 1;
													if (toTime.getFullYear() === standardMax.getFullYear() && toTime.getMonth() === standardMax.getMonth()) daily = toTime.getDate() / standardMax.getDate();

													if (!isEmpty(totalInsurance)) {
														insuranceCostList[i] += totalInsurance * daily;
														if (i <= currentMonthMax.getMonth()) {
															insuranceCost = Number(insuranceCost) + (totalInsurance * daily);
															if (i === currentMonthMax.getMonth()) insuranceCostCurrent = Number(insuranceCostCurrent) + (totalInsurance * daily);
														}
													}
												}
											}
										}
									});
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
									expenditureCurrent: expenditureCurrent,
									expenditureLastMonth: expenditureLastMonth,
									expenditureLastYear: expenditureLastYear,
									month: new Date().getMonth(),
								});
							});
						}
					});
				} else if (index === 1) {
					targetData.forEach(rowData => {
						if (!isEmpty(rowData['work_info'])) {
							const workInfo = JSON.parse(rowData['work_info'])
								, repairMaintenanceInfo = JSON.parse(rowData['repair_maintenance_info'])
								, writeTime = isEmpty(workInfo['작성_일자']) ? null : new Date(workInfo['작성_일자'])
								, tableIndex = tableData.findIndex(e => e.id === rowData.site_id);

							if (!isEmpty(repairMaintenanceInfo) && writeTime != null && tableIndex > -1) {
								const repairMaintenanceCost = repairMaintenanceInfo['총_수선_유지비'].replace(/[^0-9]/g, '');
								if (writeTime.getTime() <= lastYearMax.getTime() && writeTime.getTime() >= lastYearMin.getTime()) {
									if (isEmpty(tableData[tableIndex]['lastYearRepair'])) {
										tableData[tableIndex]['lastYearRepair'] = Number(repairMaintenanceCost);
										lastYearRepair = Number(repairMaintenanceCost);
									} else {
										tableData[tableIndex]['lastYearRepair'] += Number(repairMaintenanceCost);
										lastYearRepair += Number(repairMaintenanceCost);
									}
								}

								if (writeTime.getTime() <= lastMonthMax.getTime() && writeTime.getTime() >= lastMonthMin.getTime()) {
									if (isEmpty(tableData[tableIndex]['lastMonthRepair'])) {
										tableData[tableIndex]['lastMonthRepair'] = Number(repairMaintenanceCost);
										lastMonthRepair = Number(repairMaintenanceCost);
									} else {
										tableData[tableIndex]['lastMonthRepair'] += Number(repairMaintenanceCost);
										lastMonthRepair += Number(repairMaintenanceCost);
									}
								}

								for (let i = 0; i < currentMonth; i++) {
									const standardMin = new Date(currentMonthMin.getFullYear(), i, 1)
										, standardMax = new Date(currentMonthMin.getFullYear(), i + 1, 0);

									if (writeTime.getTime() <= standardMax.getTime() && writeTime.getTime() >= standardMin.getTime()) {
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

			return {capacityList, contractUnitPriceList, insuranceCostList, repairMaintenanceCostList, expenditureInfo, lastYearContractUnitPrice, lastYearInsuranceInfo, lastYearRepair, tableData};
		}).then(({capacityList, contractUnitPriceList, insuranceCostList, repairMaintenanceCostList, expenditureInfo, lastYearContractUnitPrice, lastYearInsuranceInfo, lastYearRepair, tableData}) => {
			const lastMonth = new Date(); lastMonth.setDate(0);
			const currentMonth = new Date().getMonth();
			let f1 = d3.format(',.1f');
			let f0 = d3.format(',.0f');

			//발전 현황 (설비 용량)
			const refineCapacity = displayNumberFixedDecimal(capacityList[currentMonth - 1], 'kW', 3, 2);
			document.querySelector('.spcDashboard1-1 div:nth-child(1) .number-unit').innerHTML = '<span>' + refineCapacity[0] + '</span>' + refineCapacity[1];

			//올해 이익금
			let expenditure = 0;
			let expenditureSum = new Array(12).fill(0);
			expenditureInfo.forEach((expend, index) => {
				if (index < currentMonth) {
					expenditure += expend.reduce( function add(sum, currValue) {
						return sum + currValue;
					});
				}

				expend.forEach((data, dataIdx) => {
					expenditureSum[dataIdx] += data;
				});
			});

			insuranceCostList.forEach((insurance, index) => { if (index < currentMonth) { expenditure += insurance; expenditureSum[0] += insurance } });
			repairMaintenanceCostList.forEach((repair, index) => { if (index < currentMonth) { expenditure += repair; expenditureSum[11] += repair } });

			let contractUnitPrice = 0;
			contractUnitPriceList.forEach((contract, index) => { if (index < currentMonth) { contractUnitPrice += contract; } });

			const profit = contractUnitPrice - expenditure;
			document.querySelector('.spcDashboard1-2 div:nth-child(1) p.number-unit span').innerHTML = f0(profit);
			// //올해 수입 총계
			document.querySelector('.spcDashboard1-2 div:nth-child(2) ul:nth-child(1) li:nth-child(2) span').innerHTML = f0(contractUnitPrice);
			// //올해 지출 총계
			document.querySelector('.spcDashboard1-2 div:nth-child(2) ul:nth-child(2) li:nth-child(2) span').innerHTML = f0(expenditure);
			// //올해 이익률
			const margin = (profit / contractUnitPrice) * 100;
			if (isFinite(margin)) {
				document.querySelector('.spcDashboard1-1 div:nth-child(2) p.number-unit span').innerHTML = f1(margin);
			} else {
				document.querySelector('.spcDashboard1-1 div:nth-child(2) p.number-unit span').innerHTML = '-';
			}

			//종합 지출 총계
			document.querySelector('.spcDashboard2-1 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard2-2 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard2-3 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard3-1 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');
			document.querySelector('.spcDashboard3-2 h2.title span').innerHTML = lastMonth.getFullYear() + '.01.01 ~ ' + lastMonth.format('yyyy.MM.dd');

			//오른쪽 상단 처리
			const rankExpend = rank(expenditureSum);
			expenditureSum.forEach((expend, index) => {
				let target = $('#spcCategory li').eq(index);
				let capacityValue = capacityList[currentMonth];
				if (currentMonth !== 0) { capacityValue += Number(capacityList[currentMonth - 1]); }

				let contractUnitPrice = contractUnitPriceList.reduce( function add(sum, currValue) { return sum + currValue; });

				target.data('rank', rankExpend[index]);
				target.data('expend', Math.round(expend / 100) / 100);
				target.data('expendW', Math.round((expend / (capacityValue / 1000)) / 100) / 100);
				target.data('prepare', Math.round((expend / expenditure) * 100));
				target.data('management', Math.round((expend / contractUnitPrice) * 10000) / 100);


				if (index === 0 || index === 11) {
					let current, lastMonth, lastYear;
					if (index === 0) {
						current = tableData.map(el => el['insuranceCostCurrent']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastMonth = tableData.map(el => el['insuranceCostLastMonth']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastYear = tableData.map(el => el['insuranceCostLastYear']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); });
					} else {
						current = tableData.map(el => isEmpty(el['currentRepair']) ? 0 : el['currentRepair']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastMonth = tableData.map(el => isEmpty(el['lastMonthRepair']) ? 0 : el['lastMonthRepair']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); }),
						lastYear = tableData.map(el => isEmpty(el['lastYearRepair']) ? 0 : el['lastYearRepair']).reduce(function add(sum, currValue) { return Number(sum) + Number(currValue); });
					}

					if (!isEmpty(lastMonth)) target.data('lastMonth', Math.round(((current - lastMonth) / lastMonth) * 10000) / 100);
					else target.data('lastMonth', '');

					if (!isEmpty(lastYear)) target.data('lastYear', Math.round(((current - lastYear) / lastYear) * 10000) / 100);
					else target.data('lastYear', '');
				} else {
					let current = 0, lastMonth = 0, lastYear = 0;
					tableData.forEach(data => {
						if (!isEmpty(data['expenditureCurrent']) && !isEmpty(data['expenditureCurrent'][index])) current += Number(data['expenditureCurrent'][index])
						if (!isEmpty(data['expenditureLastMonth']) && !isEmpty(data['expenditureLastMonth'][index])) lastMonth += Number(data['expenditureLastMonth'][index])
						if (!isEmpty(data['expenditureLastYear']) && !isEmpty(data['expenditureLastYear'][index])) lastYear += Number(data['expenditureLastYear'][index])
					});

					if (!isEmpty(lastMonth)) target.data('lastMonth', Math.round(((current - lastMonth) / lastMonth) * 10000) / 100);
					else target.data('lastMonth', '');

					if (!isEmpty(lastYear)) target.data('lastYear', Math.round(((current - lastYear) / lastYear) * 10000) / 100);
					else target.data('lastYear', '');
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
				let chartValue = Math.round((expenditureSum[index] / expenditure) * 100);
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

			$('#spcCategory li').eq(maxIndex).data('prepare', max - (chartValueTotal - 100))

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
			chartSeries.data = expenditureSum;
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
						let totalExpenditure = expenditureInfo[i].reduce( function add(sum, currValue) { return sum + currValue; });
						chartArray[i] += Math.floor((insuranceCostList[i] + totalExpenditure + repairMaintenanceCostList[i]) / 10000);
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
							chartArray[index] = capacity / 1000;
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

			//발전소 수입/지출 현황
			tableData.forEach(data => {
				const month = new Date().getMonth();
				let contractUnitPrice = isEmpty(data['contractUnitPrice']) ? '' : data['contractUnitPrice']
					, contractUnitPriceCurrent = isEmpty(data['contractUnitPriceCurrent']) ? '' : data['contractUnitPriceCurrent']
					, contractUnitPriceLastMonth = isEmpty(data['contractUnitPriceLastMonth']) ? '' : data['contractUnitPriceLastMonth']
					, contractUnitPriceLastYear = isEmpty(data['contractUnitPriceLastYear']) ? '' : data['contractUnitPriceLastYear']
					, expenditure = (isEmpty(data['expenditure']) || data['expenditure'] === '-') ? '' : data['expenditure']
					, expenditureCurrent = (isEmpty(data['expenditureCurrent']) || data['expenditureCurrent'] === '-') ? '' : data['expenditureCurrent'].reduce( function add(sum, currValue) { return sum + currValue; })
					, expenditureLastMonth = (isEmpty(data['expenditureLastMonth']) || data['expenditureLastMonth'] === '-') ? '' : data['expenditureLastMonth'].reduce( function add(sum, currValue) { return sum + currValue; })
					, expenditureLastYear = (isEmpty(data['expenditureLastYear']) || data['expenditureLastYear'] === '-') ? '' : data['expenditureLastYear'].reduce( function add(sum, currValue) { return sum + currValue; })
					, insuranceCost = isEmpty(data['insuranceCost']) ? '' : data['insuranceCost']
					, insuranceCostCurrent = isEmpty(data['insuranceCostCurrent']) ? '' : data['insuranceCostCurrent']
					, insuranceCostLastMonth = isEmpty(data['insuranceCostLastMonth']) ? '' : data['insuranceCostLastMonth']
					, insuranceCostLastYear = isEmpty(data['insuranceCostLastYear']) ? '' : data['insuranceCostLastYear']
					, repairMaintenanceCost = isEmpty(data['repairMaintenanceCost']) ? '' : data['repairMaintenanceCost']
					, currentRepair = isEmpty(data['currentRepair']) ? '' : data['currentRepair']
					, lastMonthRepair = isEmpty(data['lastMonthRepair']) ? '' : data['lastMonthRepair']
					, lastYearRepair = isEmpty(data['lastYearRepair']) ? '' : data['lastYearRepair']
					, expenditureSum = (Number(expenditure) * month) + Number(insuranceCost) + Number(repairMaintenanceCost)
					, lastMonthexpEnditureSum = Number(expenditureLastMonth) + Number(insuranceCostLastMonth) + Number(lastMonthRepair)  //이전달 지출
					, lastYearMonthexpEnditureSum = Number(expenditureLastYear) + Number(insuranceCostLastYear) + Number(lastYearRepair) //작년 마지막달과 동일달 지출
					, currentMonthexpEnditureSum = Number(expenditureCurrent) + Number(insuranceCostCurrent) + Number(currentRepair)  //마지막달 지출
					, yield = Math.floor(((Number(contractUnitPrice) - Number(expenditureSum)) / Number(contractUnitPrice)) * 100)
					, lastMonthYield = Math.floor(((Number(contractUnitPriceLastMonth) - Number(lastMonthexpEnditureSum)) / Number(contractUnitPriceLastMonth)) * 10000) / 100
					, lastYearYield = Math.floor(((Number(contractUnitPriceLastYear) - Number(lastYearMonthexpEnditureSum)) / Number(contractUnitPriceLastYear)) * 10000) / 100
					, currentYield = Math.floor(((Number(contractUnitPriceCurrent) - Number(currentMonthexpEnditureSum)) / Number(contractUnitPriceCurrent)) * 10000) / 100;

				if (!isEmpty(expenditure) || !isEmpty(insuranceCost) || !isEmpty(repairMaintenanceCost)) {
					data['expenditureSum'] = expenditureSum;
				} else {
					data['expenditureSum'] = '';
				}

				if (!isFinite(currentYield) && !isFinite(lastMonthYield)) {
					data['lastMonthYield'] = '';
				} else {
					if (!isFinite(currentYield)) currentYield = 0;
					if (!isFinite(lastMonthYield)) lastMonthYield = 0;
					data['lastMonthYield'] = currentYield - lastMonthYield;
				}

				if (!isFinite(currentYield) && !isFinite(lastYearYield)) {
					data['lastYearYield'] = '';
				} else {
					if (!isFinite(currentYield)) currentYield = 0;
					if (!isFinite(lastYearYield)) lastYearYield = 0;
					data['lastYearYield'] = currentYield - lastYearYield;
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

			//MW당 항목별 지출금액
			seriesLength = expenditureCapacityChart.series.length;
			for (let i = seriesLength - 1; i > -1; i--) {
				expenditureCapacityChart.series[i].remove();
			}

			let capacityValue = capacityList[currentMonth];
			if (currentMonth !== 0) { capacityValue += Number(capacityList[currentMonth - 1]); }

			expenditureSum.forEach((expenditure, idx) => {
				expenditureSum[idx] = Math.round((expenditure / (capacityValue / 1000)) / 100) / 100 ;
			});

			chartSeries = new Object();
			chartSeries.name = '지출';
			chartSeries.type = 'column';
			chartSeries.color = 'var(--turquoise)';
			chartSeries.data = expenditureSum;
			chartSeries.tooltip = {valueSuffix: '원'}
			expenditureCapacityChart.addSeries(chartSeries, false);
			expenditureCapacityChart.update({ xAxis: { categories: expenditureCategory } });
			expenditureCapacityChart.redraw();
		}).catch(error => {
			console.error('Func spcList', error);
			errorMsg(error);
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
		chart: {
			type: 'treemap',
			backgroundColor: 'transparent',
			layoutAlgorithm: 'squarified',
		},
		title: { text: '' },
		subtitle: { text: '' },
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
			width: 156,
			itemMarginTop: 3,
			itemMarginBottom: 4,
			labelFormatter: function () {
				const dx = 160 - getWidth(this.name+this.value+"%");
				
				return `<div class="box-graph-label"> <p>${'${this.name}'}</p> <p dx="${'${dx}'}">${'${this.value}'}%</p> </div>`;
			}
		},
		tooltip: {
			// minWidth: "200px",
			// padding: "16px",
			// background: "#0c0c0c",
			// borderRadius: "4px",
			// opacity: "0.8",
			// boxShadow: "0px 4px 7px 1px rgba(0, 0, 0, 0.5)",
			// display: "flex",
			// alignItems: "center",
			// justifyContent: "space-between",
			// color: "var(--white87)",
			// fontSize: "12px",
			formatter() {
				return `<div class="treemap-tooltip"><div><div class="color-circle" style="background: ${'${this.color}'};"></div>${'${this.key}'}</div> <p>${'${this.point.value}'}%</p></div>`
			}
		},
		series: [{
			showInLegend: true,
			legendType: 'point',
			data: []
		}],
		plotOptions: {
			series: {
				dataLabels: {
					enabled: true,
					style: {
						color: 'var(--black)',
						fontSize: '10px',
						fontWeight: 400,
						textOutline: 0,
						textAlign: 'left',
					},
					align: 'left',
					verticalAlign: 'top'
				}
			}
		}
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
				text: '(만원)',
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
		}, {
			gridLineWidth: 0,
			title: {
				text: '(MW)',
				align: 'low',
				rotation: 0,
				y: 30,
				x: 20,
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
						let val = displayNumberFixedUnit(point.y, '원', '만원', 1, 'round')
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
				text: '(만원)',
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
					return s + '<br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + point.y + '만원';
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

	const getWidth = (txt) => {
		const $target = $("<span class='getWidthSpan' style='font-size: 12px;'>"+txt+"</span>").appendTo("body");

		const width = $target.width() + 21;

		$(".getWidthSpan").remove();

		return width;
	}
</script>
