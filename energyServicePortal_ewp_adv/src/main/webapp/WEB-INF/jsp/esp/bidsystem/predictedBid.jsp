<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<link type="text/css" rel="stylesheet" href="/css/predictionBid.css"/>
<div class="modal fade" id="bidResult" tabindex="-1" role="dialog" aria-labelledby="bidResult" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content">
			<h2>입찰 설정</h2>
			<div>
				<div id="">
					<!-- DataTables -->
				</div>
			</div>
			<div class="modal-footer">
				<div>
					<button class="btn-type03">엑셀 다운로드</button>
				</div>
				<div>
					<button class="btn-type03">취소</button>
					<button class="btn-type">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="bidSettingModal" tabindex="-1" role="dialog" aria-labelledby="bidSettingModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content">
			<h2>입찰 설정</h2>
			<!-- !!! Modal Form !!! -->
			<form>
				<div class="modal-items">
					<div class="row">
						<div><span class="input-label"><span>입찰 모드</span></span></div>
						<div class="input-list">
							<div class="radio-type">
								<input type="radio" id="manualMode" name="mode" value="M">
								<label for="manualMode">수동입찰 모드</label>
							</div>
							<div class="radio-type">
								<input type="radio" id="autoMode" name="mode" value="A">
								<label for="autoMode">혼합입찰 모드(자동+수동)</label>
							</div>
						</div>
					</div>
					<div class="row">
						<div>
							<span class="input-label"><span>입찰 전송 주소</span></span>
							<a href="javascript:void(0);" class="btn-add fr">추가</a>
						</div>
						<div class="input-list">
							<div>
								<input type="email" name="email_to" placeholder="이메일 입력">
								<button type="button" class="btn-type03">수정</button>
							</div>
						</div>
					</div>
					<div class="row">
						<div>
							<span class="input-label"><span>입찰 시간</span></span>
							<a href="javascript:void(0);" class="btn-add fr">추가</a>
						</div>
						<div class="input-list">
							<div>
								<input type="text" name="bid_time" class="sel timepicker"/>
								<button type="button" class="btn-type03">수정</button>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="button" class="btn-type" id="settingSave">저장</button>
				</div>
			</form>
		</div>
	</div>
</div>

<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header">
		<h1 class="page-header">예측입찰</h1>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-xl-12 col-md-12 col-sm-12">
		<div class="indiv" id="predictionBid">
			<div class="predictionBid-header">
				<div class="title-area" id="switchView">
					<h2 class="title" data-view="todayList">금일입찰</h2>
					<h2 class="title" data-view="historyList">입찰내역</h2>
<%--					<h2 class="title newBadge" data-view="historyList">입찰내역</h2>--%>
				</div>
				<div>
					<button type="button" class="btn-type04" id="bidSetting">입찰 설정</button>
					<button type="button" class="btn-type" id="bidNow">즉시입찰</button>
				</div>
			</div>
			<div class="mt-15">
				<span class="tx-tit">VPP 그룹</span>
				<div class="sa-select">
					<div class="dropdown" id="vpp_id">
						<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown" data-name="선택" data-value="${vgid}">${siteName}<span class="caret"></span></button>
						<ul class="dropdown-menu chk-type" role="menu">
							<c:forEach var="vpp" items="${vpp_group}">
								<li data-value="${vpp.vgid}">
									<a href="javascript:void(0);" tabindex="-1">
										${vpp.name}
									</a>
								</li>
							</c:forEach>
						</ul>
					</div>
				</div>
			</div>
			<div class="predictionBid-items">
				<ul class="actived">
					<li>1회 입찰</li>
					<li>2021-01-01 11:11:11</li>
				</ul>
<%--				<ul>--%>
<%--					<li>2회 입찰</li>--%>
<%--					<li>2021-01-01 11:11:11</li>--%>
<%--				</ul>--%>
<%--				<ul>--%>
<%--					<li>3회 입찰</li>--%>
<%--					<li>2021-01-01 11:11:11</li>--%>
<%--				</ul>--%>
			</div>
			<div class="predictionBid-content">
				<div class="predictionBid-toolbar">
					<img src="/img/predictionBid/refresh.svg" alt="refresh">
				</div>
				<div class="content" id="todayList">
					<div>
						<table id="todayTable" class="predicted-table">
							<thead>
							<tr>
								<th rowspan="2" style="vertical-align: middle">순번</th>
								<th rowspan="2" style="vertical-align: middle">회원사명</th>
								<th rowspan="2" style="vertical-align: middle">자원명</th>
								<th colspan="8">발전기 구분</th>
								<th colspan="24">예측 발전량(kWh)</th>
							</tr>
							<tr>
								<th>발전기명</th>
								<th>CBP발전기번호</th>
								<th>중개시장자원코드</th>
								<th>발전원</th>
								<th>지역구분</th>
								<th>설비용량(kW)</th>
								<th>적용거래일</th>
								<th>차수</th>
								<th>1</th>
								<th>2</th>
								<th>3</th>
								<th>4</th>
								<th>5</th>
								<th>6</th>
								<th>7</th>
								<th>8</th>
								<th>9</th>
								<th>10</th>
								<th>11</th>
								<th>12</th>
								<th>13</th>
								<th>14</th>
								<th>15</th>
								<th>16</th>
								<th>17</th>
								<th>18</th>
								<th>19</th>
								<th>20</th>
								<th>21</th>
								<th>22</th>
								<th>23</th>
								<th>24</th>
							</tr>
							</thead>
						</table>
					</div>
				</div>
				<div class="content" id="historyList">
					<div class="extracter">
						<div>
							<p>기간</p>
							<div class="dropdown-wrapper">
								<div class="dropdown" id="period">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="기간" aria-expanded="false" data-value="today">
										오늘<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-value="today" class="on"><a href="#">오늘</a></li>
										<li data-value="week"><a href="#">이번 주</a></li>
										<li data-value="month"><a href="#">이번 달</a></li>
										<li data-value="setup"><a href="#">직접 선택</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div>
							<p>날짜 입력</p>
							<div class="sel-calendar fl">
								<input type="text" id="fromDate" name="fromDate" class="sel fromDate" value="">
								<input type="text" id="toDate" name="toDate" class="sel toDate" value="">
							</div>
						</div>
						<button class="btn-type">추출</button>
					</div>
					<div>
						<table id="bidTable">
							<thead>
							<tr>
								<th>
									<input type="checkbox" id="" name="" />
								</th>
								<th>순번</th>
								<th>회원사명</th>
								<th>자원명</th>
								<th>발전기 수</th>
								<th>입찰날짜</th>
								<th>입찰일시</th>
								<th>입찰모드</th>
								<th>입찰인</th>
								<th>입찰결과</th>
							</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
			<div class="predictionBid-footer">
				<div id="excelDown">
<%--					<button type="button" class="btn-type03">엑셀 다운로드</button>--%>
				</div>
				<div>
					<button type="button" class="btn-type03" id="modifyTable">수정</button>
					<button type="button" class="btn-type" id="saveTable">저장</button>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	// Document.ready
	$(() => {
		App.init();
	});

	const App = {
		view: '#todayList',

		todayTable: null, //금일입찰 테이블

		bidTable: null, //입찰내역 테이블

		vpp_id: '${vgid}',

		init() {
			App.todayTable = $('#todayTable').DataTable({
				authWidth: true,
				scrollX: true,
				scrollCollapse: true,
				// fixedColumns: {
				// 	leftColumns: 3,
				// },
				columns: [
					{
						data: null,
						render: function (data, type, full, rowIndex) {
							return rowIndex.row + 1;
						},
						className: 'dt-center no-sorting no-edit',
					},
					{
						data: 'orgName',
						className: 'dt-left no-edit',
					},
					{
						data: 'vppName',
						// width: 150,
						className: 'dt-left no-edit',
					},
					{
						data: 'siteName',
						// width: 200,
						className: 'dt-left no-edit',
					},
					{
						data: 'gen_code',
						// width: 200,
						className: 'dt-center no-edit',
					},
					{
						data: 'vpp_resource_code',
						// width: 200,
						className: 'dt-left no-edit',
					},
					{
						data: 'resourceTypeName',
						// width: 120,
						className: 'dt-left no-edit',
					},
					{
						data: 'location',
						// width: 120,
						className: 'dt-left no-edit',
					},
					{
						data: 'capacity',
						className: 'dt-left',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'W', 'kW', 0);
								return temp[0];
							}
						}
					},
					{
						data: 'tradeDay',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								return data.replace(/(\d{4})(\d{2})(\d{2})/g, '$1.$2.$3')
							}
						}
					},
					{
						data: 'part',
						// width: 120,
						className: 'dt-left no-edit',
					},
					{
						data: '1',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '2',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '3',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '4',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '5',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '6',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '7',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '8',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '9',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '10',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '11',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '12',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '13',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '14',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '15',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '16',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '17',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '18',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '19',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '20',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '21',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '22',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '23',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					},
					{
						data: '24',
						className: 'dt-left no-edit',
						render: function (data, type, full, rowIndex) {
							if (isEmpty(data) || data === '-') {
								return '-';
							} else {
								const temp = displayNumberFixedUnit(data, 'Wh', 'kWh', 0);
								return temp[0];
							}
						}
					}
				],
				language: {
					emptyTable: i18nManager.tr('gdash.the_data_you_have_queried_does_not_exist'),
					zeroRecords: i18nManager.tr('gdash.your_search_has_not_returned_results'),
					infoEmpty: '',
					paginate: {
						previous: '',
						next: '',
					},
					info: '_PAGE_ - _PAGES_ ' + ' / <fmt:message key="table.totalCase.start" /> _TOTAL_ <fmt:message key="table.totalCase.end" />',
				},
				dom: 'tip',
			});

			new $.fn.dataTable.Buttons(App.todayTable, {
				name: 'commands',
				buttons: [
					{
						extend: 'excel',
						text: '엑셀다운로드',
						className: 'btn-save',
						title: '',
						messageTop: ' ',
						filename: '입찰예측'
					}
				]
			});

			App.todayTable.buttons( 0, null ).containers().appendTo("#excelDown");


			App.bidTable = $('#bidTable').DataTable({
				//rautoWidth: true,
				scrollX: true,
				// scrollY: '720px',
				scrollCollapse: true,
				paging: false,
				sortable: true,
				orderCellsTop: true,
				language: {
					emptyTable: i18nManager.tr('gdash.the_data_you_have_queried_does_not_exist'),
					zeroRecords: i18nManager.tr('gdash.your_search_has_not_returned_results'),
					infoEmpty: '',
					paginate: {
						previous: '',
						next: '',
					},
					info: '_PAGE_ - _PAGES_ ' + ' / <fmt:message key="table.totalCase.start" /> _TOTAL_ <fmt:message key="table.totalCase.end" />',
				},
				dom: 'tip',
			});

			App.event();
			$('#switchView > h2:first-child').trigger('click');

			const targetApi = new Array();
			targetApi.push(
				$.ajax({
					url: apiHost + '/predic-sys/bid/forecast',
					type: 'GET',
					data: {
						oid,
						vpp_id: App.vpp_id,
						trade_day: new Date().format('yyyyMMdd')
					}
				})
			);

			targetApi.push(
				$.ajax({
					url: apiHost + '/predic-sys/bid/history',
					type: 'GET',
					data: {
						oid,
						vpp_id: App.vpp_id,
						trade_day: new Date().format('yyyyMMdd')
					}
				})
			);

			new Promise(resolve => {
				resolve(Promise.all(targetApi));
			}).then(response => {
				if (!isEmpty(response)) {
					response.forEach((rspn, index) => {
						if (index === 0) {
							if (!isEmpty(rspn)) {
								const refinedList = new Array();
								rspn.forEach(vppData => {
									if (!isEmpty(vppData['sites'])) {
										const siteData = vppData['sites'];
										siteData.forEach(site => {
											let rowData = new Object();

											rowData = {
												oid: vppData['oid'],
												orgName: vppData['orgName'],
												vgid: vppData['vgid'],
												vppName: vppData['vppName'],
												sid: site['sid'],
												siteName: site['siteName'],
												gen_code: site['gen_code'],
												vpp_resource_code: site['vpp_resource_code'],
												resourceTypeName: site['resourceTypeName'],
												resourceType: site['resourceType'],
												location: site['location'],
												capacity: site['capacity']
											};

											if (!isEmpty(site['energy'])) {
												const energy = site['energy']
													, items = energy['items'];
												rowData['tradeDay'] = energy['tradeDay'];
												rowData['part'] = energy['part'];

												if (!isEmpty(items)) {
													items.forEach((item, index) => {
														rowData[index + 1 + ''] = String(item);
													});
												} else {
													for (let i = 1; i <= 24; i++) { rowData[i + ''] = '-'; }
												}
											} else {
												rowData['tradeDay'] = '';
												rowData['part'] = '';
												for (let i = 1; i <= 24; i++) { rowData[i + ''] = '-'; }
											}

											Object.entries(rowData).forEach(([key, data]) => {
												if (data === undefined || data === null) { rowData[key] = '-'; }
											});

											refinedList.push(rowData);
										});
									}
								});

								App.todayTable.clear();
								App.todayTable.rows.add(refinedList).draw();
							}
						} else {
							console.log(index, rspn);
						}
					});
				}
			}).catch(error => {
				console.error(error);
				return false;
			})
		},

		event(events, handler) {
			$(document).on('click', '#switchView > h2', switchView); //탭이동
			$(document).on('click', '#bidSetting', bidSettingInit); //입찰세팅 팝업(Init)
			$(document).on('click', '#bidSettingModal .btn-add', addItem); //입찰세팅 팝업 항목추가
			$(document).on('click', '#bidSettingModal .input-list img', removeItem); //입찰세팅 팝업 항목삭제
			$(document).on('click', '#settingSave', bidSettingSave); //입찰세팅 저장
			$(document).on('click', '#bidSettingModal .input-list .btn-type03', bidSettingSave); //입찰세팅 저장
			$(document).on('click', '#bidNow', bidNow); //즉시입찰 팝업 항목삭제
			$(document).on('click', '#modifyTable', editActive)
			$(document).on('click', '#todayTable tbody td:not(.no-edit)', function() { App.todayTable.bubble(this); });
		}
	}

	//탭이동
	function switchView () {
		$('#switchView > h2').removeClass('actived');
		$(this).addClass('actived');

		App.view = '#' + $(this).data('view');

		$('.predictionBid-content > .content').fadeOut(500);
		$(App.view).fadeIn(500);

		if ($(this).data('view') === 'todayList' && $(this).hasClass('actived')) {
			$('#manualMode').prop('disabled', false);
		} else {
			$('#manualMode').prop('disabled', true);
		}
	}

	//즉시 입찰
	function bidNow () {
		const todayTime = new Date()
			, nowTime = todayTime.getHours();
		let part = 1; //차수

		if (nowTime > 10 && nowTime <= 17) {
			todayTime.setDate(todayTime.getDate() + 1);
			part = 2;
		} else {
			if (nowTime > 10) {
				todayTime.setDate(todayTime.getDate() + 1);
				part = 2;
			} else {
				part = 1;
			}
		}

		$.ajax({
			url: apiHost + '/predic-sys/bid/send?oid=' + oid + '&vpp_id=' + App.vpp_id + '&trade_day=' + todayTime.format('yyyyMMdd') + '&part=' + part + '&revision=1',
			type: 'POST',
			contentType: 'application/json'
		}).done((data, textStatus, xhr) => {
			alert('즉시 입찰이 완료되었습니다. (아직 내용이 안들어옴)');
			$('#switchView > h2:eq(1)').addClass('newBadge');
			return false;
		}).fail((xhr, textStatus, errorThrown) => {
			console.error(textStatus, errorThrown);
		});
	}

	//입찰세팅 팝업 (Init)
	function bidSettingInit () {

		if ($('#switchView h2.actived').data('view') === 'todayList') {
			$('#manualMode').prop('disabled', false);
		} else {
			$('#manualMode').prop('disabled', true);
		}

		$(':radio[name="mode"]').prop('checked', false); //입찰모드 초기화

		$('#bidSettingModal .input-list div:first-child:not(.radio-type)').siblings().remove(); //첫번째 항목만 남긴다.
		$('#bidSettingModal .input-list div:first-child input[type="text"]').val(''); //input 초기화

		// wickedpicker가 초기화가 불가능하므로 지워버리고 새로 만든다.
		if ($('.timepicker').hasClass('hasWickedpicker')) {
			$('[name="bid_time"]').parent().empty().append(`
				<input type="text" name="bid_time" class="sel timepicker"/>
				<button type="button" class="btn-type03">수정</button>
			`);
		}

		$('.wickedpicker').css('z-index', 200);
		$('#settingSave').data('method', 'POST');

		$.ajax({
			url: apiHost + '/predic-sys/bid/setting',
			type: 'GET',
			data: {
				oid: oid,
				vpp_id: App.vpp_id
			}
		}).done((data, textStatus, xhr) => {
			if (!isEmpty(data)) {
				const targetData = data[0];
				$(':radio[name="mode"][value="' + targetData['mode'] + '"]').prop('checked', true); //모드 세팅
				const emailTo = targetData['email_to'];
				if (!isEmpty(emailTo)) {
					try {
						const targetEmail = emailTo.split(',');
						for (let i = 0; i < targetEmail.length; i++) {
							if (i !== 0) {
								const email = $('[name="email_to"]:first-child').parent().clone()
									, targetList = $('[name="email_to"]:first-child').parents('.input-list');
								targetList.append(`<div>${'${email.html()}'}<img src="/img/predictionBid/delete.svg" alt="delete"></div>`);
								$('[name="email_to"]:eq(' + i + ')').val(targetEmail[i]);
							} else {
								$('[name="email_to"]:eq(0)').val(targetEmail[i]);
							}
						}
					} catch (e) {
						$('[name="email_to"]').val('');
					}
				}

				const time = targetData['bid_time'];
				if (!isEmpty(time)) {
					try {
						const targetTime = time.split(',');
						for (let i = 0; i < targetTime.length; i++) {
							const refinedTime = targetTime[i].substr(0, 2) + ' : ' + targetTime[i].substr(2, 2);
							if (i !== 0) {
								const bidTime = $('[name="bid_time"]:first-child').parent().clone()
									, targetList = $('[name="bid_time"]:first-child').parents('.input-list');
								bidTime.find('input').removeClass('hasWickedpicker');
								targetList.append(`<div>${'${bidTime.html()}'}<img src="/img/predictionBid/delete.svg" alt="delete"></div>`);
							}

							$('[name="bid_time"]:eq(' + i + ')').wickedpicker({now: refinedTime, twentyFour: true});
						}
					} catch (e) {
						$('[name="bid_time"]').val('');
					}
				} else {
					$('[name="bid_time"]').wickedpicker({twentyFour: true});
				}

				$('#settingSave').data('method', 'PATCH');
			}
		}).fail((xhr, textStatus, errorThrown) => {
			console.error(textStatus, errorThrown);
		});

		$('#bidSettingModal').modal('show');
	}

	//입찰세팅 팝업에서 항목추가
	function addItem () {
		const target = $(this).parent().next()
			, origin = target.find('div:first-child').clone();

		origin.find('input').removeClass('hasWickedpicker');
		target.append(`<div>${'${origin.html()}'}<img src="/img/predictionBid/delete.svg" alt="delete"></div>`);

		if (target.find('input').hasClass('timepicker')) {
			target.find('input').wickedpicker({twentyFour: true});
		}
	}

	//입찰세팅 팝업에서 항목삭제
	function removeItem () { $(this).parent().remove(); }

	//입찰세팅 팝업 저장
	function bidSettingSave () {
		const reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;

		let methodType = $('#settingSave').data('method');
		let emailTo = new Array();
		let emailBoolean = true;

		let time = new Array();
		let timeBoolean = true;

		if (isEmpty($(':radio[name="mode"]:checked').val())) {
			alert('모드 선택은 필수입니다.');
			return false;
		}

		$('[name="email_to"]').each(function() {
			if (isEmpty($(this).val()) || !reg_email.test($(this).val())) { emailBoolean = false; }
			else { emailTo.push($(this).val()); }
		});
		if (!emailBoolean) { alert('이메일이 잘못된 형식입니다.'); return false; }

		$('[name="bid_time"]').each(function() {
			if (!isEmpty($(this).val())) {
				time.push($(this).wickedpicker('time').replace(/[^0-9]/g, ''));
			} else {
				timeBoolean = false;
			}
		});

		let apiData = new Object();
		let apiURL = apiHost + '/predic-sys/bid/setting';
		if ($('#settingSave').data('method') === 'PATCH') { //수정
			apiURL = apiHost + '/predic-sys/bid/setting?oid=' + oid + '&vpp_id=' + App.vpp_id;
			apiData = JSON.stringify({
				mode: $(':radio[name="mode"]:checked').val(),
				is_on: 0,
				email_to: emailTo.toString(),
				bid_time: time.toString()
			});
		} else { //등록
			apiURL = apiHost + '/predic-sys/bid/setting';
			apiData = JSON.stringify({
				oid: oid,
				vpp_id: App.vpp_id,
				mode: $(':radio[name="mode"]:checked').val(),
				is_on: 0,
				email_to: emailTo.toString(),
				bid_time: time.toString()
			});
		}

		$.ajax({
			url: apiURL,
			type: methodType,
			contentType: 'application/json',
			data: apiData
		}).done((data, textStatus, xhr) => {
			alert('저장 되었습니다.');
			$('#bidSettingModal').modal('hide');
			return false;
		}).fail((xhr, textStatus, errorThrown) => {
			console.error(textStatus, errorThrown);
		});
	}

	//수정 활성화
	function editActive () {
		$('#todayTable tbody tr').each(function () {
			const td = $(this).find('td');
			for (let i = 11; i < td.length; i++) {
				td[i].classList.remove('no-edit')
			}
		});
	}
</script>