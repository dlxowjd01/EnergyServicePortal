<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let today = new Date();
	const siteList = JSON.parse('${siteList}');
	let balanceTable = null;

	$(function () {
		balanceTable = $('#balanceTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			"table-layout": "fixed",
			scrollY: '720px',
			scrollX: true,
			scrollCollapse: true,
			sortable: true,
			paging: true,
			pageLength: 10,
			columns: [
				{
					sTitle: '',
					mData: null,
					mRender: function ( data, type, full, rowIndex ) {
						return '<input type="checkbox" id="check' + rowIndex.row + '" name="table_checkbox" data-spcId="' + full['spc_id'] + '" data-siteId="' + full['site_id'] + '" data-yyyymm="' + full['balance_yyyymm'] + '"><label for="check' + rowIndex.row + '"></label>';
					},
					className: 'dt-center no-sorting'
				},
				{
					title: '<fmt:message key="workreportmain.2.number" />',
					data: null,
					render: function (data, type, full, rowIndex) {
						return rowIndex.row + 1;
					},
					className: 'dt-center no-sorting fixed'
				},
				{
					title: 'SPC명',
					data: 'spc_name',
					render: function (data, type, full, rowIndex) {
						return '<a href="/spc/entityDetailsBySite.do?spc_id=' + full['spc_id'] + '&balance_yyyy=' + full['balance_yyyymm'] + '" class="table-link">' + data + '</a>';
					},
					className: 'dt-center'
				},
				{
					title: '발전소 명',
					data: 'name',
					render: function (data, type, full, rowIndex) {
						return '<a href="/spc/entityDetailsBySite.do?spc_id=' + full['spc_id'] + '&balance_yyyy=' + full['balance_yyyymm'] + '" class="table-link">' + data + '</a>';
					},
					className: 'dt-center'
				},
				{
					title: '기준년월',
					data: 'balance_yyyymm',
					className: 'dt-center'
				},
				{
					title: '현금유입(원)',
					data: 'inflowOfCash',
					className: 'dt-center'
				},
				{
					title: '현금유출(원)',
					data: 'outflowOfCash',
					className: 'dt-center'
				},
				{
					title: '기말 현금흐름(원)',
					data: 'endOfTermFlow',
					className: 'dt-center'
				}
			],
			select: {
				style: 'multi',
				selector: 'td:first-child > :checkbox, tr'
			},
			language: {
				emptyTable: "조회된 데이터가 없습니다.",
				zeroRecords:  "검색된 결과가 없습니다.",
				infoEmpty: "",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / 총 _TOTAL_ 개",
			},
			dom: 'tip',
		}).on('select', function(e, dt, type, indexes) {
			balanceTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
			$('#deleteBtn').attr('disabled', false);
		}).on('deselect', function(e, dt, type, indexes) {
			balanceTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);

			const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
			if (checkedArray.length > 0) {
				$('#deleteBtn').attr('disabled', false);
			} else {
				$('#deleteBtn').attr('disabled', true);
			}
		}).columns.adjust().draw();

		new $.fn.dataTable.Buttons(balanceTable, {
			name: 'commands',
			buttons: [
				{
					extend: 'excelHtml5',
					className: "btn-save",
					text: '<fmt:message key="workreportmain.1.dataExtracts" />',
					filename: 'SPC금융관리_' + new Date().format('yyyyMMddHHmmss'),
					customize: function( xlsx ) {
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
						$('row:first c', sheet).attr( 's', '42' );
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
					}
				}
			]
		});

		balanceTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
		getDataList();
		// setInitList("listData"); //리스트초기화
		// getDataList(page);
	});

	$(document).on('keyup', '#key_word', function (e) {
		if (e.keyCode == 13) {
			getDataList(page);
		}
	});

	function getDataList() {
		$.ajax({
			url: apiHost + '/spcs/balance/month',
			type: 'GET',
			data: {
				oid: oid,
				yyyymm: $('#year button').data('value') + '__'
			},
			success: function (result) {
				let refineList = new Array(),
					keyWord = $('#key_word').val().trim(),
					resultList = result.data;
				const keyWordPattern = new RegExp(keyWord, 'i'); //ignoreCase 대소문자 구분X

				if (!isEmpty(resultList)) {
					resultList.forEach(rowData => {
						if (!isEmpty(rowData['balance_info'])) {
							const balance_info = JSON.parse(rowData['balance_info']);

							rowData['balance_yyyymm'] = rowData['balance_yyyymm'].replace(/(\d{4})(\d{2})/, '$1-$2');
							if (!isEmpty(balance_info)) {
								rowData['inflowOfCash'] = numberComma(Math.round(balance_info['inflowOfCash'].replace(/[^0-9.]/g, '')));
								rowData['outflowOfCash'] = numberComma(Math.round(balance_info['outflowOfCash'].replace(/[^0-9.]/g, '')));
								rowData['endOfTermFlow'] = numberComma(Math.round(balance_info['endOfTermFlow'].replace(/[^0-9.]/g, '')));
							}

							const siteInfo = siteList.find(e => e.sid === rowData['site_id']);
							rowData['name'] = siteInfo.name;

							if (isEmpty(keyWord)) {
								refineList.push(rowData);
							} else {
								if (keyWordPattern.test(rowData['name']) || keyWordPattern.test(rowData['spc_name'])) {
									refineList.push(rowData);
								}
							}
						}
					});
				}

				balanceTable.clear();
				balanceTable.rows.add(refineList).draw();
			},
			error: function (request, status, error) {
				balanceTable.clear().draw();
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});

		$(document).on('click', '#comDeleteBtn', function() {
			$('#comDeleteModal').modal('hide');
			$('#confirmTitle').val('');

			const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
			const urls = new Array();
			const deferreds = new Array();

			checkedArray.forEach(chk => {
				const spcId = chk.dataset.spcid;
				const siteId = chk.dataset.siteid;
				const yyyymm = chk.dataset.yyyymm;

				if (!isEmpty(spcId) && !isEmpty(siteId) && !isEmpty(yyyymm)) {
					const locationUrl = '/spcs/' + spcId + '/balance/month?oid=' + oid + '&site_id=' + siteId + '&yyyymm=' + yyyymm.replace('-', '');
					urls.push({
						url: apiHost + locationUrl,
						type: 'delete',
						dataType: 'json',
					});
				}
			});

			//코드 삭제 START
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
				});
			});

			$.when.apply($, deferreds).then(function () {
				let totalDelete = 0;
				Object.entries(arguments).forEach(([dummy, resultData]) => {
					if (!isEmpty(resultData)) {
						if (resultData['status'] === 'success') {
							totalDelete += resultData['data']['count'];
						}
					}
				});

				errorMsg(totalDelete + '개를 삭제했습니다.');
				getDataList();
				$("#deleteBtn").prop('disabled', true);
			});
		});
	}

	function deleteRow() {
		let alarmMsg = '삭제';
		let modal = $("#comDeleteModal");

		$('#comDeleteSuccessMsg span').text(alarmMsg);
		modal.find('.modal-body').removeClass('hidden');
		modal.modal('show');

		$("#confirmTitle").on('input keyp', function() {
			if($(this).val() !== alarmMsg) {
				$("#comDeleteBtn").prop('disabled', true);
			} else {
				$("#comDeleteBtn").prop('disabled', false);
			}
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
</script>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">SPC 금융관리</h1>
	</div>
</div>
<div class="row">
	<div class="col-12 clear input-align">
		<div class="fl">
			<span class="tx-tit">기준</span>
			<div class="sa-select">
				<div class="dropdown" id="year">
					<button type="button" class="dropdown-toggle w8" data-toggle="dropdown"
						data-value="2020">
						2020년<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type" role="menu">
						<li data-value="2020"><a href="#">2020년</a></li>
						<li data-value="2019"><a href="#">2019년</a></li>
						<li data-value="2018"><a href="#">2018년</a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<div class="text-input-type">
				<input type="text" id="key_word" name="searchName" placeholder="입력">
			</div>
		</div>
		<div class="fl">
			<button type="button" class="btn-type" onclick="getDataList();">검색</button>
		</div>
		<div id="exportBtnGroup" class="fr"></div>
	</div>
</div>
<div class="row">
	<div class="col-12">
		<div class="indiv">
			<div class="btn-wrap-type01">
				<button type="button" class="btn-type" onclick="location.href='/spc/balanceSheetPost.do'">신규 등록</button>
			</div>
			<table id="balanceTable" class="chk-type">
				<colgroup>
					<col width="5%">
					<col width="5%">
					<col width="15%">
					<col width="15%">
					<col width="15%">
					<col width="15%">
					<col width="15%">
					<col width="15%">
				</colgroup>
			</table>
			<div class="btn-wrap-type02 mt-30">
				<button type="button" class="btn-type03" id="deleteBtn" onclick="deleteRow();" disabled="disabled">선택 삭제</button>
			</div>
		</div>
	</div>
</div>