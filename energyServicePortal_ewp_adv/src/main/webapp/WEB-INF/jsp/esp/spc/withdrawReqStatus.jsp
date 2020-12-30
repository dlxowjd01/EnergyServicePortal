<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	const pathName = location.pathname;
	const spcArr = new Array();

	let withdrawReqStatus = null;
	$(function() {
		withdrawReqStatus = $('#withdrawReqStatus').DataTable({
			autoWidth: true,
			fixedHeader: true,
			"table-layout": "fixed",
			scrollY: '720px',
			scrollCollapse: true,
			sortable: true,
			paging: true,
			pageLength: 15,
			columns: [
				{
					title: '',
					data: null,
					mRender: function ( data, type, full, rowIndex ) {
						return `<input type="checkbox" id="check${'${rowIndex.row}'}" name="table_checkbox" value="${'${rowIndex.row}'}">
								<label for="check${'${rowIndex.row}'}"></label>`;
					},
					className: 'dt-center no-sorting'
				},
				{
					title: '출금 일자',
					data: 'withdrawDay',
					className: 'dt-center no-sorting fixed'
				},
				{
					title: 'SPC 명',
					data: 'spcName',
					className: 'dt-head-center dt-body-center'
				},
				{
					title: '금 액',
					data: 'totalAmount',
					render: function (data, type, full, rowIndex) {
						return numberComma(data);
					},
					className: 'dt-head-center dt-body-right'
				},
				{
					title: '입출금 구분',
					data: null,
					render: function (data, type, full, rowIndex) {
						const toAccount = full['toAccount'];

						if (isEmpty(toAccount)) {
							return '-';
						} else {
							if (toAccount.length > 1) {
								return '출금 ' + (toAccount.length) + '건';
							} else {
								return '출금';
							}
						}
					},
					className: 'dt-center'
				},
				{
					title: '용도 구분',
					data: null,
					render: function (data, type, full, rowIndex) {
						const toAccount = full['toAccount'];
						const purposeArray = new Array();
						const purposeTemplate = [
							{label: '출금', value: ['관리 운영비', '사무 수탁비', '부채 상환', '대수선비', '배당금 적립', '일반 지출', 'DSRA 적립', '기타', '운영계좌', '공사비', '임대료', '대납금']},
							{label: '입금', value: ['REC 수익', 'SMP 수익', 'DSRA 적립', '기타', '유보 계좌', '운영 계좌']},
						];
						toAccount.forEach(acc => { purposeArray.push(acc.purpose); });

						if (purposeArray.length === 0) {
							return '-';
						} else if (purposeArray.length === 1) {
							return purposeTemplate[0].value[purposeArray[0]];
						} else {
							return purposeTemplate[0].value[purposeArray[0]] + ' 외 +' + (purposeArray.length - 1) + '건';
						}
					},
					className: 'dt-center'
				},
				{
					title: '요청/수정일',
					data: 'requestedAt',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							const date = new Date(data.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'))
							return date.format('yyyy-MM-dd HH:mm:ss');
						}
					},
					className: 'dt-center'
				},
				{
					title: '요청자',
					data: 'requestedBy',
					className: 'dt-center'
				},
				{
					title: '상태',
					data: 'status',
					render: function (data, type, full, rowIndex) {
						let statusButton = `<button class="${'${full.statusClass}'} clear-btn" onclick="goToDetail(\'${'${rowIndex.row}'}\')">${'${data}'}</button>`;
						if (task !== '2') {
							if (!isEmpty(full['statusVal']) && full['statusVal'] === 0) {
								statusButton += `<a href="javascript:void(0);" onclick="deleteRow(\'${'${rowIndex.row}'}\')" class="icon-delete"></a>`;
							} else if (!isEmpty(full['statusVal']) && full['statusVal'] === 1) {
								statusButton += `<a href="javascript:void(0);" onclick="goToEdit(\'${'${rowIndex.row}'}\')" class="icon-edit"></a>
												<a href="javascript:void(0);" onclick="deleteRow(\'${'${rowIndex.row}'}\')" class="icon-delete"></a>`;
							}
						}
						return statusButton;
					},
					className: 'dt-center'
				},
				{
					title: '승인자',
					data: 'statusChangedBy',
					className: 'dt-center'
				},
				{
					title: '승인일',
					data: 'statusChangedAt',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							const date = new Date(data.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$3/$2/$1 $4:$5:$6'))
							return date.format('yyyy-MM-dd HH:mm:ss');
						}
					},
					className: 'dt-center'
				}
			],
			rowGroup: {
				startRender: null,
				endRender: function(rows, group) {
					let sumTot = rows.data().pluck('totalAmount').reduce(function (a,b){
						return a + b;
					});

					sumTot = numberComma(sumTot);
					return $('<tr/>')
						.append('<td/>')
						.append('<td/>')
						.append('<td class="dt-center">합계</td>')
						.append('<td class="dt-right">' + sumTot + '</td>')
						.append('<td colspan="6"></td>');
				}
			},
			language: {
				emptyTable: '조회된 데이터가 없습니다.',
				zeroRecords: '검색된 결과가 없습니다.',
				infoEmpty: "",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / 총 _TOTAL_ 개",
			},
			dom: 'tip',
		}).columns.adjust().draw();

		$('#searchForm').on('submit', function(e) {
			e.preventDefault();
			let searchOpt = new Object();
			let status = new Array();

			document.querySelectorAll('input[name="review_status"]:checked').forEach(chk => {
				status.push(chk.value);
			});

			searchOpt.status = status;

			if (!isEmpty(document.getElementById('keyword').value.trim())) {
				searchOpt.keyword = new RegExp(document.getElementById('keyword').value.trim(), 'i');
			}

			if (!isEmpty(document.getElementById('withdrawDay').value.trim())) {
				searchOpt.withdrawDay = document.getElementById('withdrawDay').value.trim();
			}

			if (!isEmpty(status)) {
				window.sessionStorage.setItem(pathName + '_status', status.toString()); //세션스토리지에 저장한다.
			}
			window.sessionStorage.setItem(pathName + '_keyword', document.getElementById('keyword').value.trim()); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_withdrawDay', document.getElementById('withdrawDay').value.trim()); //세션스토리지에 저장한다.

			if (isEmpty(searchOpt.status) && isEmpty(searchOpt.keyword)) {
				getDataList(null);
			} else {
				getDataList(searchOpt);
			}
		});

		pageInit();
	});

	function pageInit() {
		if (task !== '3') { $('#approvalBtn').remove(); }

		return new Promise((resolve, reject) => {
			$.ajax({
				url: apiHost + '/spcs?oid=' + oid,
				type: 'GET',
				success: (json, textStatus, jqXHR) => {
					json.data.forEach(item => {
						spcArr.push({
							spc_id: item['spc_id'],
							spc_name: item['name']
						});
					});

					resolve(spcArr);
				},
				error: (jqXHR, textStatus, errorThrown) => {
					console.error(textStatus);
					new Error('SPC정보 조회중 오류가 발생했습니다.');
				}
			})
		}).then(spcArr => {
			const status = window.sessionStorage.getItem(pathName + '_status');
			const keyword = window.sessionStorage.getItem(pathName + '_keyword');
			const withdrawDay = window.sessionStorage.getItem(pathName + '_withdrawDay');

			if (!isEmpty(status)) {
				if (status.match(',')) {
					const statusArray = status.split(',');
					document.querySelectorAll('[name="review_status"]').forEach(chk => {
						if (statusArray.includes(chk.value)) {
							chk.checked = true;
						}
					});
				} else {
					document.querySelectorAll('[name="review_status"]').forEach(chk => {
						if (chk.value === status) {
							chk.checked = true;
						}
					});
				}
			} else {
				document.querySelectorAll('[name="review_status"]').forEach(chk => {
					chk.checked = true;
				});
			}
			displayDropdown($('#reqStatus'));

			if (!isEmpty(keyword)) {
				document.getElementById('keyword').value = keyword;
			}

			if (!isEmpty(withdrawDay)) {
				document.getElementById('withdrawDay').value = withdrawDay;
			}

			$('#searchForm').submit();
		}).catch(error => {
			errorMsg(error);
		});
	}

	const getDataList = (searchOpt) => {
		Promise.all([$.ajax({
			url: apiHost + '/spcs/transactions',
			type: 'GET',
			data: {
				'oid' : oid
			}
		})]).then(response => {
			response.forEach(res => {
				if (!isEmpty(res) && !isEmpty(res['data'])) {
					let refineList = new Array();
					res['data'].map(item => {
						const found = spcArr.findIndex(x => x.spc_id === item.spc_id);
						const to_account = JSON.parse(item.to_account);

						let statusVal = ''
						  , statusClass = '';
						switch (item.status) {
							case 0:
								statusVal = '반송';
								statusClass = 'text-link';
								break;
							case 1:
								statusVal = '검토 대기';
								statusClass = 'text-link';
								break;
							case 2:
								statusVal = '검토 중';
								statusClass = 'text-link';
								break;
							case 3:
								statusVal = '승인 완료';
								statusClass = 'text-blue';
								break;
							case 4:
								statusVal = '출금 가승인';
								statusClass = 'text-link';
								break;
							case 5:
								statusVal = '출금 최종승인';
								statusClass = 'text-blue';
								break;
							default:
								statusVal = '';
								statusClass = 'text-link';
						}

						refineList.push({
							transactionSpcId: item.spc_id,
							spcName: spcArr[found].spc_name,
							transactionReqId: item.request_id,
							bankName: item.withdraw_bank,
							accNum: item.withdraw_account_no,
							withdrawDay: item.withdraw_day.substring(0, 4) + '-' + item.withdraw_day.substring(4, 6) + '-' + item.withdraw_day.substring(6, 8),
							status: statusVal,
							statusVal: item.status,
							statusClass: statusClass,
							totalAmount: item.total_amount,
							requestedAt: item.requested_at,
							statusChangedAt: item.status_changed_at,
							transferAgent: item.transfer_agent,
							requestedBy: item.requested_by,
							statusChangedBy: item.status_changed_by,
							toAccount: to_account
						});
					});

					if (!isEmpty(searchOpt)) {
						refineList = refineList.filter(rowData => {
							if ((searchOpt.status).includes(String(rowData.statusVal))
								&& (rowData.spcName).match(searchOpt.keyword)
								&& (!isEmpty(searchOpt.withdrawDay)
									&& (rowData.withdrawDay != null
										&& rowData.withdrawDay.replace(/[^0-9]/g, '') === searchOpt.withdrawDay.replace(/[^0-9]/g, ''))
									 || isEmpty(searchOpt.withdrawDay))) {
								return true;
							}
						});
					}

					withdrawReqStatus.clear();
					withdrawReqStatus.rows.add(refineList).draw();
					$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
				} else {
					throw Error('조회된 내역이 없습니다.');
				}
			});
		}).catch(error => {
			withdrawReqStatus.clear().draw();
			errorMsg(error);
		});
	}

	const goToDetail = (rowIndex) => {
		const rowData = withdrawReqStatus.row(rowIndex).data()
			, status = rowData.status
			, statusVal = rowData.statusVal
			, spcId = rowData.transactionSpcId
			, spcName = rowData.spcName
			, reqId = rowData.transactionReqId
			, accNum = rowData.accNum
			, accInfo = rowData.bankName + ' ' + accNum;

		if(statusVal === 1 && task === '2'){
			document.getElementById('reqDetailStatus').value = '검토 중';
			document.getElementById('reqDetailStatusVal').value = 2;

			updateStatus(2, reqId);
		} else {
			document.getElementById('reqDetailStatus').value = status;
			document.getElementById('reqDetailStatusVal').value = statusVal;
		}

		document.getElementById('reqDetailSpcId').value = spcId;
		document.getElementById('reqDetailSpcName').value = spcName;
		document.getElementById('reqDetailReqId').value = reqId;
		document.getElementById('reqDetailAccountInfo').value = accInfo;

		submit({spcId, accNum});
		// [자산 운용사]
		// "반송" : 0, "검토 중" : "2", "승인완료": "3"	 => /spc/withdrawReqStatusDetail.do
		// "검토 대기" : 1" 						  => /spc/withdrawReqEdit.do
	}

	const updateStatus = (newStatus, id) => {
		$.ajax({
			url: apiHost + '/spcs/transactions/' + id + '?oid=' + oid,
			type: 'patch',
			async: false,
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify({
				status: Number(newStatus),
				status_changed_by: loginName,
				status_changed_at: new Date()
			})
		}).done(function (json, textStatus, jqXHR) {
			// console.log("success---", json)
		}).fail(function (jqXHR, textStatus, errorThrown) {
			errorMsg()
			return false;
		});
	}

	const submit = ({spcId, accNum}) => {
		new Promise(resolve => {
			$.ajax({
				url: apiHost + '/spcs/' + spcId + '?oid=' + oid + '&includeGens=true',
				type: 'GET',
				success: (json, textStatus, jqXHR) => {
					if (!isEmpty(json) && !isEmpty(json.data)) {
						resolve(json);
					} else {
						new Error('SPC 정보 조회 내역이 없습니다.');
					}
				},
				error: (jqXHR, textStatus, errorThrown) => {
					console.error(textStatus);
					new Error('SPC 정보 조회 중 오류가 발생했습니다.');
				}
			})
		}).then(json => {
			(json.data).forEach(data => {
				const spcGens = data.spcGens
					, promiseItem = new Array();

				if (isEmpty(spcGens)) {
					new Error('SPC 정보 조회 내역이 없습니다.');
				} else {
					spcGens.forEach(element => {
						promiseItem.push(Promise.resolve(JSON.parse(element.finance_info)));
					});

					Promise.all(promiseItem).then(res => {
						res.map(x => {
							Object.entries(x).map(item => {
								const accHolder = '예금주';
								if (typeof accNum === 'number') {
									accNum = String(accNum);
								} else {
									accNum = accNum.replace(/[^0-9]/g, '');
								}

								if (typeof item[1] === 'string') {
									const itmeAcc = item[1].replace(/[^0-9]/g, '');

									if (itmeAcc === accNum) {
										let txt = item[0]
										  , newTxt = txt.replace(/계좌_번호/g, '');

										document.getElementById('reqDetailAccHolder').value = '  (' + x[accHolder + newTxt] + ')';
										setTimeout(function () {
											document.getElementById('reqDetailForm').submit();
										}, 300);
									}
								}
							});
						});
					}).catch(error => {
						errorMsg(error);
					});
				}
			});
		}).catch(error => {
			errorMsg(error);
		});
	}

	$(document).on('click', '#approvalBtn', function(e) {
		e.preventDefault();
		let agree = true;
		let checkedList = new Array();

		const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
		if (checkedArray.length <= 0) {
			errorMsg('하나이상의 항목을 선택해 주세요.');
		} else {
			checkedArray.forEach(checkBox => {
				const index = checkBox.value
					, rowData = withdrawReqStatus.row(index).data()
					, statusValue = rowData.statusVal
					, withdrawDay = rowData.withdrawDay
					, spcName = rowData.spcName
					, totalAmount = rowData.totalAmount;

				checkedList.push({
					statusValue: statusValue,
					withdrawDay: withdrawDay,
					spcName: spcName,
					totalAmount: totalAmount
				});

				if (statusValue !== 4) {
					agree = false;
				}
			});

			if (agree === false) {
				errorMsg('출금 가승인 항목만 선택해 주세요.');
			} else {
				$('#approvalModal .modal-body .row').empty();

				checkedList.forEach(el => {
					let temp = `<div class="col-12">${'${el.withdrawDay}'} ${'${el.spcName}'} ${'${el.totalAmount}'}</div>`
					$('#approvalModal .modal-body .row').append(temp);
				});

				$('#approvalModal .modal-header h2').text('다음 ' + checkedList.length + '건의 출금을 최종승인 합니다.');
				$('#approvalModal').modal('show');
			}
		}
	});

	$(document).on('click', '#approvalBtn', function(e) {
		e.preventDefault();

		let finalArray = new Array();
		const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
		if (checkedArray.length <= 0) {
			errorMsg('하나이상의 항목을 선택해 주세요.');
		} else {
			checkedArray.forEach(checkBox => {
				const index = checkBox.value
					, rowData = withdrawReqStatus.row(index).data()
					, statusValue = rowData.statusVal
					, reqId = rowData.transactionReqId;

				if (statusValue === 4) {
					updateStatus('5', reqId);
					finalArray.push(reqId);
				}
			});

			$.ajax({
				url: apiHost + '/spcs/transactions/data_send?oid=' + oid,
				type: 'post',
				async: false,
				dataType: 'json',
				contentType: "application/json",
				data: JSON.stringify({
					reqIds: finalArray
				})
			}).done(function (json, textStatus, jqXHR) {
				$('#approvalModal').modal('hide');

				let searchOpt = {};
				let status= [];
				document.querySelectorAll('input[name="review_status"]:checked').forEach(chk => {
					status.push(chk.value);
				});

				searchOpt.status = status;
				searchOpt.keyword = $("#keyword").val().trim().toLowerCase();

				if (!isEmpty(status)) {
					window.sessionStorage.setItem(pathName + '_status', status.toString()); //세션스토리지에 저장한다.
				}
				window.sessionStorage.setItem(pathName + '_keyword', $("#keyword").val()); //세션스토리지에 저장한다.

				if (isEmpty(searchOpt.status) && isEmpty(searchOpt.keyword)) {
					getDataList(1, null);
				} else {
					getDataList(1, searchOpt);
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				if (textStatus !== 'canceled') {
					finalArray.forEach(reqId => {
						updateStatus('4', reqId);
					});
				}
			});
		}
	});

	function goToEdit(rowIndex) {
		const rowData = withdrawReqStatus.row(rowIndex).data()
			, spcId = rowData.transactionSpcId
			, spcName = rowData.spcName
			, reqId = rowData.transactionReqId;

		document.getElementById('reqEditSpcId').value = spcId;
		document.getElementById('reqEditSpcName').value = spcName;
		document.getElementById('reqEditReqId').value = reqId;
		document.getElementById('reqEditForm').submit();
	}


	function deleteRow(rowIndex) {
		const rowData = withdrawReqStatus.row(rowIndex).data();

		let modal = $('#comDeleteModal')
		  , deleteBtn = $('#comDeleteBtn')
		  , confirmTitle = $('#confirmTitle')
		  , reqId = rowData.transactionReqId;

		$('#comDeleteSuccessMsg span').text('삭제').data('reqId', reqId);
		modal.find('.modal-body').removeClass('hidden');
		modal.modal('show').data('reqId', reqId);

		confirmTitle.on('input keyp', function() {
			if($(this).val() !== '삭제') {
				deleteBtn.prop('disabled', true);
				return false
			} else {
				deleteBtn.prop('disabled', false);
			}
		});
	}

	/**
	 * 삭제 처리
	 */
	$(document).on('click', '#comDeleteBtn', function() {
		const reqId = $('#comDeleteModal').data('reqId');
		$('#comDeleteModal').modal('hide').removeData('reqId');
		$('#confirmTitle').val('');

		$.ajax({
			url: apiHost + '/spcs/transactions/' + reqId + '?oid=' + oid,
			type: 'DELETE',
			async: true
		}).done(function (json, textStatus, jqXHR) {
			document.getElementById('searchForm').submit();
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(textStatus);
			errorMsg('처리중 오류가 발생했습니다.');
			return false;
		});
	});

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

<form id="reqEditForm" class="" action="/spc/withdrawReqEdit.do" method="post">
	<input type="hidden" id="reqEditSpcId" name="req_edit_spc_id" value=''/>
	<input type="hidden" id="reqEditSpcName" name="req_edit_spc_name" value=''/>
	<input type="hidden" id="reqEditReqId" name="req_edit_req_id" value=''/>
</form>

<form id="reqDetailForm" method="post" action="/spc/withdrawReqStatusDetail.do">
	<input type="hidden" id="reqDetailSpcId" name="req_detail_spc_id" value=''/>
	<input type="hidden" id="reqDetailSpcName" name="req_detail_spc_name" value=''/>
	<input type="hidden" id="reqDetailReqId" name="req_detail_req_id" value=''/>
	<input type="hidden" id="reqDetailAccHolder" name="req_detail_acc_holder" value=''/>
	<input type="hidden" id="reqDetailAccountInfo" name="req_detail_acc_info" value=''/>
	<input type="hidden" id="reqDetailStatus" name="req_detail_status" value=''/>
	<input type="hidden" id="reqDetailStatusVal" name="req_detail_status_val" value=''/>
</form>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 목록</h1>
	</div>
</div>

<form id="searchForm" name="search_form">
	<div class="row spc-search-bar">
		<div class="col-11">
			<div class="sa-select"><!--
			--><span class="tx-tit">검토 상태</span><!--
			--><div id="reqStatus" class="dropdown"><!--
				--><button type="button" class="dropdown-toggle unused" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button><!--
				--><ul class="dropdown-menu chk-type" role="menu"><!--
					--><li data-value="2" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="wait" name="review_status" value="2"><label for="wait">검토 중</label></a></li><!--
					--><li data-value="1" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="inProgress" name="review_status" value="1"><label for="inProgress">검토 대기</label></a></li><!--
					--><li data-value="3" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="complete" name="review_status" value="3"><label for="complete">승인 완료</label></a></li><!--
					--><li data-value="4" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="provisional" name="review_status" value="4"><label for="provisional">출금 가승인</label></a></li><!--
					--><li data-value="5" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="finalApproval" name="review_status" value="5"><label for="finalApproval">출금 최종승인</label></a></li><!--
					--><li data-value="0" tabindex="-1"><a href="javascript:void(0);"><input type="checkbox" id="reject" name="review_status" value="0"><label for="reject">반송</label></a></li><!--
					--><li class="btn-wrap-type03 btn-wrap-border"><button type="button" class="btn-type mr-16">적용</button></li><!--
				--></ul>
				</div>
			</div>
			<div class="sa-select"><!--
			--><span class="tx-tit">출금일자</span>
				<div class="text-input-type mr-16"><input type="text" id="withdrawDay" name="withdrawDay" class="datepicker" autocomplete="off"></div>
			</div><!--
		--> <div class="sa-select">
				<div class="text-input-type mr-16"><input type="text" id="keyword" placeholder="입력"></div>
				<button type="submit" class="btn-type">검색</button>
			</div>
		</div>
		<div class="col-1">
			<button type="button" id="approvalBtn" class="btn-type">출금 최종승인</button>
		</div>
	</div>
</form>
<div class="row content-wrapper">
	<div class="col-lg-12">
		<div class="indiv spc-transaction">
			<table id="withdrawReqStatus" class="chk-type">
				<colgroup>
					<col style="width:4%"> <!-- 체크박스 -->
					<col style="width:8%"> <!-- 출금일자 -->
					<col style="width:12%"> <!-- SPC 명 -->
					<col style="width:10%"> <!-- 금 액 -->
					<col style="width:8%"> <!-- 입출금 구분 -->
					<col style="width:10%"> <!-- 용도 구분 -->
					<col style="width:12%"> <!-- 요청/수정일 -->
					<col style="width:8%"> <!-- 요청자 -->
					<col style="width:8%"> <!-- 상태 -->
					<col style="width:8%"> <!-- 승인자 -->
					<col style="width:12%"> <!-- 승인일 -->
				</colgroup>
			</table>
		</div>
	</div>
</div>

<div class="modal fade in" id="approvalModal" role="dialog">
	<div class="modal-dialog modal-lg">
		<div class="modal-content device_modal_content">
			<div class="modal-header stit">
				<h2></h2>
			</div>
			<div class="modal-body">
				<div class="row">
				</div>
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type" id="finalApprovalBtn">확인</button>
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
				</div>
			</div>
		</div>
	</div>
</div>
