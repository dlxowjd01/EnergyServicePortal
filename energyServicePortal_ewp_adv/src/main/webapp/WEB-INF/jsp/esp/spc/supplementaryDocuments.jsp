<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let spcEntityTable = null;

	$(function() {
		const keyWord = document.getElementById('key_word'); //검색명 INPUT

		/**
		 * 검색명 Event
		 */
		keyWord.addEventListener('keyup', (e) => {
			if (e.keyCode === 13) {
				getDataList();
			} else {
				const regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
				keyWord.value = (keyWord.value).replace(regExp, '');
			}
		});

		spcEntityTable = $('#spcEntityTable').DataTable({
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
					title: '순번',
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
						return '<a href="javascript:moveModifyPage(\'' + full['spc_id'] + '\', \'' + full['gen_id'] + '\')" class="table-link">' + data + '</a>';
					},
					className: 'dt-left'
				},
				{
					title: '발전소 명',
					data: 'gen_name',
					render: function (data, type, full, rowIndex) {
						return '<a href="javascript:moveModifyPage(\'' + full['spc_id'] + '\', \'' + full['gen_id'] + '\')" class="table-link">' + data + '</a>';
					},
					className: 'dt-left'
				},
				{
					title: '관리 운영기간',
					data: 'operation_period',
					className: 'dt-center'
				},
				{
					title: '이관자료',
					data: null,
					render: function (data, type, full, rowIndex) {
						const fileAll = full['file_count_all']
							, fileNow = full['file_count_now'];

						if (!isEmpty(fileAll) && !isEmpty(fileNow)) {
							return fileNow + '&nbsp;&nbsp;/&nbsp;&nbsp;' + fileAll;
						} else {
							return '-';
						}
					},
					className: 'dt-center'
				},
				{
					title: '첨부파일',
					data: null,
					render: function (data, type, full, rowIndex) {
						const fileNow = full['file_count_now'];

						if (!isEmpty(fileNow)) {
							return fileNow + '&nbsp;&nbsp;건';
						} else {
							return '-';
						}
					},
					className: 'dt-center'
				}
			],
			language: {
				emptyTable: "조회된 데이터가 없습니다.",
				zeroRecords:  "검색된 결과가 없습니다.",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / 총 _TOTAL_ 개",
			},
			dom: 'tip',
		}).columns.adjust().draw();

		new $.fn.dataTable.Buttons(spcEntityTable, {
			name: 'commands',
			buttons: [
				{
					extend: 'excelHtml5',
					className: "btn-save",
					text: '엑셀 다운로드',
					filename: 'SPC이관자료_' + new Date().format('yyyyMMddHHmmss'),
					customize: function( xlsx ) {
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
						$('row:first c', sheet).attr( 's', '42' );
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
					}
				}
			]
		});

		spcEntityTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
		getDataList();
	});

	/**
	 * 상세화면으로 이동
	 *
	 * @param spcId
	 * @param genId
	 */
	const moveModifyPage = (spcId, genId) => {
		location.href = '/spc/entityDetailsBySPC.do?spc_id=' + spcId + '&gen_id=' + genId + '&oid=' + oid;
	}

	const getDataList = () => {
		new Promise((resolve, reject) => {
			$.ajax({
				url: apiHost + '/spcs',
				type: 'GET',
				async: false,
				data: {
					oid: oid,
					includeGens: true
				},
				success: (result) => {
					if (result['status'] === 'success') {
						const resultList = result['data'];
						if (isEmpty(resultList)) {
							reject(new Error('조회된 내역이 없습니다.'));
						} else {
							resolve(resultList);
						}
					} else {
						reject(new Error('조회에 실패했습니다.'));
					}
				},
				error: (error) => {
					console.error(error);
					reject(new Error('조회에 실패했습니다.'));
				}
			});
		}).then(resultList => {
			//데이터화
			const refineList = new Array();
			resultList.forEach(rowData => {
				const spcGens = rowData['spcGens'];
				if (!isEmpty(spcGens)) {
					spcGens.forEach(spcGen => {
						const genId = spcGen['gen_id']
							, genName = spcGen['name']
							, maintenanceInfo = JSON.parse(spcGen['maintenance_info'])
							, warrantyInfo = JSON.parse(spcGen['warranty_info']);

						let termDate = '';
						if (!isEmpty(maintenanceInfo)) {
							const mainFrom = maintenanceInfo['관리_운영_기간_from']
								, mainTo = maintenanceInfo['관리_운영_기간_to'];
							if (!isEmpty(mainFrom) && !isEmpty(mainTo)) {
								termDate = new Date(mainFrom).format('yyyy-MM-dd') + ' ~ ' + new Date(mainTo).format('yyyy-MM-dd');
							} else {
								termDate = '-';
							}
						}

						refineList.push({
							spc_id: rowData['spc_id'],
							spc_name: rowData['name'],
							gen_id: genId,
							gen_name: genName,
							operation_period: termDate,
						});
					});
				}
			});

			refineList.sort((a, b) => {
				return a['operation_period'] < b['operation_period'] ? 1 : a['operation_period'] > b['operation_period'] ? -1 : 0;
			});

			return refineList;
		}).then(refineList => {
			return new Promise(resolve=> {
				const urls = new Array();
				const deferreds = new Array();
				refineList.forEach(rowData => {
					urls.push({
						url: apiHost + '/spcs/' + rowData['spc_id'] + '/gens/' + rowData['gen_id'] + '/supplement?oid=' + oid,
						type: 'GET',
						async: false,
						dataType: 'json'
					});
				});

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
					Object.entries(arguments).forEach(([dummy, resultData]) => {
						if (!isEmpty(resultData)) {
							const targetUrl = resultData['url']
								, urlSplit = targetUrl.split('/')
								, spcId = urlSplit[4]
								, detailFiles = resultData['data'];

							if (!isEmpty(detailFiles)) {
								const detail = detailFiles[0];
								const genId = detail['gen_id'];

								refineList.forEach((rowData, index) => {
									if (Number(spcId) === rowData['spc_id'] && genId === rowData['gen_id']) {
										refineList[index]['file_count_all'] = detail['file_count_all'];
										refineList[index]['file_count_now'] = detail['file_count_now'];
										refineList[index]['supplement_info'] = JSON.parse(detail['supplement_info']);
									}
								});
							}
						}
					});
					resolve(refineList);
				});
			});
		}).then(addFileList => {
			const keyWord = document.getElementById('key_word').value;
			const key_word = new RegExp(keyWord, 'gi');
			const supplementList = addFileList.filter(rowData => {
				if (((rowData['spc_name'].match(key_word) || rowData['gen_name'].match(key_word)))) {
					return true;
				} else {
					const supplementInfo = rowData['supplement_info'];
					if (!isEmpty(supplementInfo)) {
						let findFileName = false;
						Object.entries(supplementInfo).forEach(([keyName, data]) => {
							if (/originalName/.test(keyName) && !isEmpty(data) && data.match(key_word)) {
								findFileName = true;
							}
						});
						return findFileName;
					}
				}
			});

			spcEntityTable.clear();
			spcEntityTable.rows.add(supplementList).draw();
		}).catch(error => {
			spcEntityTable.clear().draw();
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
</script>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">SPC 이관자료</h1>
	</div>
</div>
<div class="row">
	<div class="col-12 clear input-align">
		<div class="fl">
			<div class="text-input-type mr-12">
				<input type="text" id="key_word" name="key_word" placeholder="입력">
			</div>
		</div>
		<div class="fl">
			<button type="button" class="btn-type" onclick="getDataList();">검색</button>
		</div>
		<div id="exportBtnGroup" class="fr"></div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<table id="spcEntityTable" class="chk-type">
				<colgroup>
					<col style="width:5%">
					<col style="width:25%">
					<col style="width:25%">
					<col style="width:18%">
					<col style="width:14%">
					<col style="width:13%">
					<col>
				</colgroup>
			</table>
			<div class="pagination-wrapper" id="paging">
			</div>
		</div>
	</div>
</div>