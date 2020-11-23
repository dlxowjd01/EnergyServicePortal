<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript">
	let spcEntityTable = null;
	$(function () {
		const spcFrom = document.querySelector('#searchBtn'); //검색 BUTTON
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

		/**
		 * 검색버튼 Event
		 */
		spcFrom.addEventListener('click', function (e) {
			getDataList();
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
					sTitle: '',
					mData: null,
					mRender: function ( data, type, full, rowIndex ) {
						return '<input type="checkbox" id="check' + rowIndex.row + '" name="table_checkbox" data-spcid="' + full['spc_id'] + '" data-genid="' + full['gen_id'] + '"><label for="check' + rowIndex.row + '"></label>';
					},
					className: 'dt-center no-sorting'
				},
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
					title: '연차',
					data: 'annual',
					render: function (data, type, full, rowIndex) {
						let suffix = ' 년차';
						if (data === '-') {
							suffix = '';
						}
						return data + suffix;
					},
					className: 'dt-center'
				},
				{
					title: '관리 운영기간',
					data: 'operation_period',
					className: 'dt-center'
				},
				{
					title: '보증',
					data: 'guarantee',
					className: 'dt-center'
				},
				{
					title: '보증 값',
					data: 'guaranteed_value',
					render: function (data, type, full, rowIndex) {
						let suffix = ' %';
						if (data === '-') {
							suffix = '';
						} else {
							if (full['guarantee'] === '발전 시간') {
								suffix = ' H';
							}
						}
						return numberComma(data) + suffix;
					},
					className: 'dt-right'
				},
				{
					title: '보증 실적',
					data: 'guaranteed_performance',
					render: function (data, type, full, rowIndex) {
						let suffix = ' %';

						if (isNaN(data) || data === Infinity) {
							data = '-'
						}

						if (data === '-') {
							suffix = '';
						} else {
							if (full['guarantee'] === '발전 시간') {
								suffix = ' H';
							}
						}
						return numberComma(data) + suffix;
					},
					className: 'dt-right'
				},
				{
					title: '보증 확률',
					data: 'guaranteed_probability',
					render: function (data, type, full, rowIndex) {
						let suffix = ' %';

						if (isNaN(data) || data === Infinity) {
							data = '-'
						}

						if (data === '-') {
							suffix = '';
						}
						return numberComma(data) + suffix;
					},
					className: 'dt-right'
				},
				{
					title: '감소율',
					data: 'reduction_rate',
					render: function (data, type, full, rowIndex) {
						let suffix = ' %';
						if (data === '-') {
							suffix = '';
						}
						return data + suffix;
					},
					className: 'dt-right'
				},
				{
					title: '-추가보수',
					data: 'additional_amount',
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
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / 총 _PAGES_ 개",
			},
			dom: 'tip',
		}).on('select', function(e, dt, type, indexes) {
			spcEntityTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
			$('#deleteBtn').attr('disabled', false);
		}).on('deselect', function(e, dt, type, indexes) {
			spcEntityTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);

			const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
			if (checkedArray.length > 0) {
				$('#deleteBtn').attr('disabled', false);
			} else {
				$('#deleteBtn').attr('disabled', true);
			}
		}).columns.adjust().draw();

		new $.fn.dataTable.Buttons(spcEntityTable, {
			name: 'commands',
			buttons: [
				{
					extend: 'excelHtml5',
					className: "btn-save",
					text: '엑셀 다운로드',
					filename: 'SPC기본정보_' + new Date().format('yyyyMMddHHmmss'),
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
	 * 리스트 검색 및 정제
	 */
	const getDataList = () => {
		new Promise(resolve => {
			$.ajax({
				url: apiHost + '/spcs',
				type: 'GET',
				data: {
					oid: oid,
					includeGens: true
				},
				success: (result) => {
					if (result['status'] === 'success') {
						const resultList = result['data'];
						if (isEmpty(resultList)) {
							throw new Error('조회된 내역이 없습니다.');
						} else {
							resolve(resultList);
						}
					} else {
						throw new Error('조회에 실패했습니다.');
					}
				},
				error: (error) => {
					console.error(error);
					throw new Error('조회에 실패했습니다.');
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

						let guaranteed_value = '-'; //보증값
						let guaranteed_performance = '-'; //보증실적
						let guaranteed_probability = '-'; //보증확률
						if (!isEmpty(warrantyInfo['보증_방식'])) {
							if (warrantyInfo['보증_방식'] === 'PR') {
								guaranteed_value = isEmpty(warrantyInfo['PR_보증치']) ? '-' : warrantyInfo['PR_보증치'];
								if (!isEmpty(warrantyInfo['보증_감소율']) && !isEmpty(warrantyInfo['현재_적용_연차'])) {
									guaranteed_value = Math.round((guaranteed_value * (1 - Number(warrantyInfo['보증_감소율'] / 100) ** (Number(warrantyInfo['현재_적용_연차']) - 1))) * 100) / 100;
								}

								if (!isEmpty(maintenanceInfo) && !isEmpty(maintenanceInfo['설치_용량'])) {
									let capacity = Number((maintenanceInfo['설치_용량']).replace(/[^\d]/g, '')) / 1000;
									let today = new Date();
									today.setDate(-1);

									let before = new Date();
									before.setDate(-1);
									before.setFullYear(before.getFullYear() - 1);

									let energy = energySearch(genId, before.format('yyyyMMdd') + '000000', today.format('yyyyMMdd') + '235959');
									let insolation = insolationSearch(genId, before.format('yyyyMMdd') + '000000', today.format('yyyyMMdd') + '235959');
									guaranteed_probability = Math.round(((energy / insolation / (capacity * 100) / Number(guaranteed_value)) * 100) * 100) / 100;

									if (!isEmpty(maintenanceInfo) && !isEmpty(maintenanceInfo['관리_운영_기간_from'])) {
										before = new Date(maintenanceInfo['관리_운영_기간_from']);
										let guaranteed_date = new Date(today.getFullYear(), before.getMonth(), 1);
										let energy = energySearch(genId, guaranteed_date.format('yyyyMMdd') + '000000', today.format('yyyyMMdd') + '235959');
										guaranteed_performance = Math.round((energy / insolation / (capacity * 100)) * 100) / 100;
									}
								}
							} else if (warrantyInfo['보증_방식'] === '발전 시간') {
								guaranteed_value = isEmpty(warrantyInfo['발전시간_보증치']) ? '-' : warrantyInfo['발전시간_보증치'];
								if (!isEmpty(warrantyInfo['보증_감소율']) && !isEmpty(warrantyInfo['현재_적용_연차'])) {
									guaranteed_value = Math.round((guaranteed_value * (1 - Number(warrantyInfo['보증_감소율'] / 100) ** (Number(warrantyInfo['현재_적용_연차']) - 1))) * 100) / 100;
								}

								if (!isEmpty(maintenanceInfo) && !isEmpty(maintenanceInfo['설치_용량'])) {
									let capacity = Number((maintenanceInfo['설치_용량']).replace(/[^\d]/g, '')) / 1000;
									let today = new Date();
									today.setDate(-1);

									let before = new Date();
									before.setFullYear(before.getFullYear() - 1);

									let energy = energySearch(genId, before.format('yyyyMMdd') + '000000', today.format('yyyyMMdd') + '000000');
									guaranteed_probability = Math.round(((energy / 365 / capacity / Number(guaranteed_value)) * 100) * 100) / 100;

									if (!isEmpty(maintenanceInfo) && !isEmpty(maintenanceInfo['관리_운영_기간_from'])) {
										before = new Date(maintenanceInfo['관리_운영_기간_from']);
										let guaranteed_date = new Date(today.getFullYear(), before.getMonth(), 1);
										let energy = energySearch(genId, guaranteed_date.format('yyyyMMdd') + '000000', today.format('yyyyMMdd') + '235959');
										let days = Math.round((today.getTime() - guaranteed_date.getTime()) / 1000 / 60 / 60 / 24) + 1;
										guaranteed_performance = Math.round((energy / days /capacity) * 100) / 100;
									}
								}
							} else {
								guaranteed_value = '-';
								guaranteed_performance = '-';
								guaranteed_probability = '-';
							}
						} else {
							guaranteed_value = '-';
						}

						refineList.push({
							spc_id: rowData['spc_id'],
							spc_name: rowData['name'],
							gen_id: genId,
							gen_name: genName,
							operation_period: termDate,
							annual: isEmpty(warrantyInfo['현재_적용_연차']) ? '-' : warrantyInfo['현재_적용_연차'],
							guarantee: isEmpty(warrantyInfo['보증_방식']) ? '-' : warrantyInfo['보증_방식'],
							guaranteed_value: guaranteed_value,
							guaranteed_performance: guaranteed_performance,
							guaranteed_probability: guaranteed_probability,
							reduction_rate: isEmpty(warrantyInfo['보증_감소율']) ? '-' : warrantyInfo['보증_감소율'],
							additional_amount: isEmpty(warrantyInfo['추가_보수']) ? '-' : warrantyInfo['추가_보수'],
							operation: maintenanceInfo['운영_여부'],
							contract: maintenanceInfo['관리_계약_구분'],
							warranty: warrantyInfo['보증_방식'],
						});
					});
				}
			});

			refineList.sort((a, b) => {
				return a['operation_period'] < b['operation_period'] ? 1 : a['operation_period'] > b['operation_period'] ? -1 : 0;
			});

			return refineList;
		}).then(refineList => {
			const operation_opt = Array.from(document.querySelectorAll('[name="operation_opt"]:checked')).map((checkbox) => checkbox.value)
				, warranty_opt = Array.from(document.querySelectorAll('[name="warranty_opt"]:checked')).map((checkbox) => checkbox.value)
				, contract_opt = Array.from(document.querySelectorAll('[name="contract_opt"]:checked')).map((checkbox) => checkbox.value)
				, key_word = new RegExp(document.getElementById('key_word').value, 'i');

			//필터
			refineList = refineList.filter(rowData => {
				const operation = isEmpty(rowData['operation']) ? '' : rowData['operation'].replace('운영_여부_', '')
					, contract = isEmpty(rowData['contract']) ? new Array() : rowData['contract']
					, warranty = rowData['warranty'];

				return (((!isEmpty(operation_opt) && operation_opt.includes(operation)) || isEmpty(operation_opt))
					&& ((!isEmpty(warranty_opt) && warranty_opt.includes(warranty)) || isEmpty(warranty_opt))
					&& ((!isEmpty(contract_opt) && !isEmpty(contract_opt.filter(opt => contract.includes(opt)))) || isEmpty(contract_opt))
					&& ((key_word.test(rowData['spc_name']) || key_word.test(rowData['gen_name']))));
			});

			spcEntityTable.clear();
			spcEntityTable.rows.add(refineList).draw();
		}).catch(error => {
			spcEntityTable.clear().draw();
			errorMsg(error);
		});
	}

	const energySearch = (sid, startTime, endTime) => {
		let resultValue = 0;
		$.ajax({
			url: apiHost + '/energy/sites',
			type: 'GET',
			async: false,
			data: {
				sid: sid,
				startTime: startTime,
				endTime: endTime,
				interval: 'month',
				displayType: 'dashboard',
				formId: 'v2'
			},
			success: (result) => {
				if (!isEmpty(result) && !isEmpty(result.data)) {
					Object.entries(result.data).forEach(([sid, data]) => {
						const items = data[0].items;
						if (!isEmpty(items)) {
							items.map(e => resultValue += e.energy);
						}
					});
				} else {
					resultValue = 0;
				}
			},
			error: (error) => {
				console.error(error);
				resultValue = 0;
			}
		});

		return Math.round(resultValue / 1000);
	}

	const insolationSearch = (sid, startTime, endTime) => {
		let resultValue = 0;
		$.ajax({
			url: apiHost + '/weather/site',
			type: 'GET',
			async: false,
			data: {
				sid: sid,
				startTime: startTime,
				endTime: endTime,
				interval: 'day',
				formId: 'v2'
			},
			success: (result) => {
				if (!isEmpty(result) && !isEmpty(result.data)) {
					Object.entries(result.data).forEach(([sid, data]) => {
						const items = data.items;
						if (!isEmpty(items)) {
							items.map(e => resultValue += e.sensor_solar.irradiationPoa);
						}
					});
				} else {
					resultValue = 0;
				}
			},
			error: (error) => {
				console.error(error);
				resultValue = 0;
			}
		});

		return Math.round(resultValue / 1000);
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

	/**
	 * 상세 페이지 이동
	 *
	 * @param spcId
	 * @param genId
	 */
	const moveModifyPage = (spcId, genId) => {
		location.href = '/spc/entityDetails.do?spc_id=' + spcId + '&gen_id=' + genId + '&oid=' + oid;
	}

	/**
	 * 선택한 SPC 기본정보 삭제
	 *
	 * @returns {Promise<boolean>}
	 */
	function setCheckedDataRemove() {
		const checkedArray = document.querySelectorAll('input[name="table_checkbox"]:checked')
			, count = checkedArray.length;

		if (count === 0) {
			errorMsg('삭제 할 목록을 선택하세요.');
		} else {
			new Promise(resolve => {
				if (role !== '1') {
					$.ajax({
						url: apiHost + '/config/user_spcs?oid=' + oid,
						type: 'get',
						async: false,
						data: {user_ids: userInfoId},
						success: (data) => {
							const result = data['data']
								, acceptList = new Array();

							result.forEach(spc => {
								if (spc.role == '1') { acceptList.push(spc.spcid);}
							});

							if (acceptList.length > 0) {
								resolve(acceptList);
							} else {
								throw Error('삭제 권한이 없습니다.');
							}
						}
					});
				} else {
					let acceptList = new Array();
					checkedArray.forEach(chk => {
						acceptList.push(chk['dataset']['spcid']);
					});
					resolve(acceptList);
				}
			}).then(acceptList => {
				let accept = true;
				checkedArray.forEach(checkbox => {
					const spcId = checkbox['dataset']['spcid'];

					if (!acceptList.includes(spcId)) {
						accept = false;
					}
				});

				if (!accept) {
					throw Error('삭제 권한이 없습니다.');
				}

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
			}).catch(error => {
				errorMsg(error);
			});
		}
	}

	$(document).on('click', '#comDeleteBtn', function() {
		$('#comDeleteModal').modal('hide');
		$('#confirmTitle').val('');

		const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
		const urls = new Array();
		const deferreds = new Array();

		checkedArray.forEach(chk => {
			const spcId = chk['dataset']['spcid'];
			const genId = chk['dataset']['genid'];

			if (!isEmpty(spcId) && !isEmpty(genId)) {
				const locationUrl = '/spcs/' + spcId + '/gens/' + genId + '?oid=' + oid;
				urls.push({
					url: apiHost + locationUrl,
					type: 'delete',
					dataType: 'json'
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
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">SPC 기본 정보</h1>
	</div>
</div>
<div class="row">
	<div class="col-12 clear input-align">
		<div class="fl">
			<div class="flex-start">
				<label for="operation_select" class="tx-tit">운영 여부</label>
				<div class="dropdown sa-select mr-16" id="operation_select">
					<button type="button" class="dropdown-toggle w7 no-close" data-toggle="dropdown" data-name="운영 여부 선택">
						운영 여부 선택<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type" role="menu" id="operationList">
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="operation_1" value="운영중" name="operation_opt">
								<label for="operation_1">운영중</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="operation_2" value="운영예정" name="operation_opt">
								<label for="operation_2">운영 예정</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="operation_3" value="해지" name="operation_opt">
								<label for="operation_3">해지</label>
							</a>
						</li>
					</ul>
				</div>

				<label for="warranty_select" class="tx-tit">보증 방식</label>
				<div class="dropdown sa-select mr-16" id="warranty_select">
					<button type="button" class="dropdown-toggle w7 no-close" data-toggle="dropdown" data-name="보증 방식 선택">
						보증 방식 선택<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type" role="menu" id="warrantyList">
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="warranty_1" value="PR" name="warranty_opt">
								<label for="warranty_1">PR</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="warranty_2" value="발전 시간" name="warranty_opt">
								<label for="warranty_2">발전 시간</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="warranty_3" value="PR + 발전시간" name="warranty_opt">
								<label for="warranty_3">PR + 발전시간</label>
							</a>
						</li>
					</ul>
				</div>

				<label for="contract_select" class="tx-tit">계약 구분</label>
				<div class="dropdown sa-select mr-24" id="contract_select">
					<button type="button" class="dropdown-toggle w7 no-close" data-toggle="dropdown" data-name="계약 구분 선택">
						계약 구분 선택<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type" role="menu" id="contractList">
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_1" value="종합" name="contract_opt">
								<label for="contract_1">종합</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_2" value="일반관리" name="contract_opt">
								<label for="contract_2">일반관리</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_3" value="사무수탁" name="contract_opt">
								<label for="contract_3">사무수탁</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_4" value="보험" name="contract_opt">
								<label for="contract_4">보험</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_5" value="안전관리자" name="contract_opt">
								<label for="contract_5">안전관리자</label>
							</a>
						</li>
					</ul>
				</div>

				<div class="text-input-type mr-12">
					<input type="text" id="key_word" name="key_word" placeholder="입력">
				</div>
				<button type="button" class="btn-type" id="searchBtn">검색</button>
			</div>
		</div>
		<div id="exportBtnGroup" class="fr"></div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn-wrap-type01">
				<button type="button" class="btn-type big" onclick="location.href='/spc/entityInformationPost.do'">신규 등록</button>
			</div>
			<table id="spcEntityTable" class="chk-type">
				<colgroup>
					<col style="width:4%">
					<col style="width:4%">
					<col style="width:12%">
					<col style="width:12%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
				</colgroup>
			</table>
			<div class="btn-wrap-type02 mt-30">
				<button type="button" class="btn-type03" id="deleteBtn" onclick="setCheckedDataRemove();" disabled>선택 삭제</button>
			</div>
		</div>
	</div>
</div>