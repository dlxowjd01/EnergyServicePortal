<%@ page language='java' contentType='text/html; charset=utf-8' pageEncoding='utf-8'%>
<%@ include file='/decorators/include/taglibs.jsp'%>
<script type="text/javascript">
	const pathName = location.pathname;
	const spcInfoArr = new Array();

	let transactionHistory = null;
	$(function() {
		transactionHistory = $('#transactionHistory').DataTable({
			autoWidth: true,
			fixedHeader: true,
			'table-layout': 'fixed',
			scrollY: '720px',
			scrollCollapse: true,
			sortable: true,
			paging: true,
			pageLength: 15,
			columns: [
				{
					title: 'SPC 명',
					data: 'spcName',
					className: 'dt-center no-sorting'
				},
				{
					title: '입출금 시간',
					data: 'accountDatetime',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return data.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
						}
					},
					className: 'dt-center no-sorting fixed'
				},
				{
					title: '입출금 구분',
					data: 'kind',
					render: function (data, type, full, rowIndex) {
						if (data === 0) {
							return '입금 + 출금';
						} else if (data === 1) {
							return '입금';
						} else if (data === 2) {
							return '출금';
						} else {
							return '-';
						}
					},
					className: 'dt-center'
				},
				{
					title: '조회 계좌 정보',
					data: 'accountInfo',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return data;
						}

					},
					className: 'dt-center'
				},
				{
					title: '금 액',
					data: 'amount',
					render: function (data, type, full, rowIndex) {
						return numberComma(data);
					},
					className: 'dt-right'
				},
				{
					title: '설명1',
					data: 'accountDesc1',
					className: 'dt-center'
				},
				{
					title: '설명2',
					data: 'accountDesc2',
					className: 'dt-center'
				},
				{
					title: '설명3',
					data: 'accountDesc3',
					className: 'dt-center'
				},
				{
					title: '설명4',
					data: 'accountDesc4',
					className: 'dt-center'
				}
			],
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

		$('#transactionForm').on('submit', function(e){
			e.preventDefault();
			let formArr = new Array()
			  , warning = $('.warning')
			  , selectedSpc = new Array();

			if ($(':checkbox[name="spcName"]:checked').val() === 'all') {
				document.querySelectorAll('[name="spcName"]').forEach(check => { if (check.value !== 'all') { selectedSpc.push(check.value); } });
			} else {
				document.querySelectorAll('[name="spcName"]:checked').forEach(checked => { selectedSpc.push(checked.value); });
			}

			const startDate = $('#fromDate').datepicker('getDate').format('yyyyMMdd');
			const endDate = $('#toDate').datepicker('getDate').format('yyyyMMdd');

			warning.addClass('hidden');
			formArr.push(selectedSpc.toString(), startDate, endDate, $('#transactionType').prev().data('value'));

			Object.entries(formArr).forEach((target, index) => {
				const tVal = target[1];
				if(isEmpty(tVal) ||  tVal === '선택') {
					warning.eq(index).removeClass('hidden');
				} else {
					warning.eq(index).addClass('hidden');
				}
			});

			if ($(':checkbox[name="spcName"]:checked').val() === 'all') {
				window.sessionStorage.setItem(pathName + '_spc', 'all'); //세션스토리지에 저장한다.
			} else {
				window.sessionStorage.setItem(pathName + '_spc', selectedSpc.toString()); //세션스토리지에 저장한다.s
			}
			window.sessionStorage.setItem(pathName + '_start', startDate); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_end', endDate); //세션스토리지에 저장한다.
			window.sessionStorage.setItem(pathName + '_type', $('#transactionType').prev().data('value')); //세션스토리지에 저장한다.
			if($('#transactionForm').find('.warning.hidden').length == formArr.length){
				getDataList(formArr);
			} else {
				return false;
			}
		});

		pageInit();
	});

	const rtnDropdown = ($selector) => {
		if (!isEmpty($selector)) {
			const dropdownValue = $('#' + $selector + ' button').data('value');
			if ($selector === 'dateTerm') {
				$('#toDate').datepicker('setDate', 'today')
				if (dropdownValue === 'daily') {
					$('#fromDate').datepicker('setDate', 'today');
				} else if (dropdownValue === 'monthly') {
					$('#fromDate').datepicker('setDate', '-30');
				} else if (dropdownValue === 'yearly') {
					$('#fromDate').datepicker('setDate', '-365');
				}
			}
		}
	}

	function pageInit () {
		$('#fromDate').datepicker('setDate', '-15');
		$('#toDate').datepicker('setDate', '+15');

		return new Promise((resolve, reject) => {
			const spcList = $('#spcList');
			const cloned = spcList.clone().html();

			$.ajax({
				url: apiHost + '/spcs?oid=' + oid,
				type: 'GET',
				success: (json, textStatus, jqXHR) => {
					spcList.empty();
					(json.data).sortOn('name');
					(json.data).unshift({ spc_id: 'all', name: '<fmt:message key="deviceState.all" />'});
					(json.data).forEach((item, index) => {
						let listItem = '';
						let spcObj = {
							spc_id: item.spc_id,
							spc_name: item.name
						}
						spcInfoArr.push(spcObj);

						if(isEmpty(item.name)){
							listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, "spc_no_name"+ index);
						} else {
							listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, item.name);
						}
						spcList.append($(listItem));
					});

					spcList.append(`<li class="btn-wrap-type03 btn-wrap-border"><button type="button" class="btn-type mr-16">적용</button></li>`);
					spcList.find('input[value="all"]').parent().after('<li class="btn-wrap-border-min"></li>');
					resolve();
				},
				error: (jqXHR, textStatus, errorThrown) => {
					throw new Error('SPC 조회에 실패했습니다.');
				}
			})
		}).then(() => {
			const spcList = window.sessionStorage.getItem(pathName + '_spc');
			const start = window.sessionStorage.getItem(pathName + '_start');
			const end = window.sessionStorage.getItem(pathName + '_end');
			const type = window.sessionStorage.getItem(pathName + '_type');

			if (!isEmpty(spcList)) {
				let spcArray = new Array();
				
				if (spcList.match(',')) {
					spcArray = spcList.split(',');
				} else {
					spcArray.push(spcList);
				}

				document.querySelectorAll('#spcList input').forEach(inp => {
					if (spcArray.includes(inp.dataset.value)) {
						inp.checked = true;
					} else {
						inp.checked = false;
					}
				});

				displayDropdown($('#spcList').parent('div'));
			}

			if (!isEmpty(start)) {
				const targetDate = new Date(start.replace(/(\d{4})(\d{2})(\d{2})/, '$1,$2,$3'));
				$('#fromDate').datepicker('setDate', targetDate);
			}

			if (!isEmpty(end)) {
				const targetDate = new Date(end.replace(/(\d{4})(\d{2})(\d{2})/, '$1,$2,$3'));
				$('#toDate').datepicker('setDate', targetDate);
			}

			const transType = ['전체', '입금', '출금'];
			if (isEmpty(type)) {
				types = 0;
			} else {
				if (isNaN(type)) {
					types = 0;
				} else {
					types = type;
				}
			}

			$('#transactionType').parent().find('.dropdown-toggle').data('value', types).html(transType[Number(types)] + '<span class="caret"></span>');
			$('#transactionForm').submit();
		}).catch(() => {
			alert('처리 중 오류가 발생했습니다.');
			return false;
		})
	}

	const getDataList = (searchOptArr) => {
		new Promise((resolve, reject) => {
			$.ajax({
				url: apiHost + '/spcs/transactions/real',
				type: 'GET',
				data: {
					oid: oid,
					spcIds: searchOptArr[0],
					startDay: searchOptArr[1],
					endDay: searchOptArr[2],
					kind: Number(searchOptArr[3])
				},
				success: (json, textStatus, jqXHR) => {
					$('#searchOption').removeClass('in');
					if (!isEmpty(json.data)) {
						resolve({
							newData: json.data,
							searchOptArr: searchOptArr
						});
					} else {
						reject('조회 내역이 없습니다.');
					}
				},
				error: (jqXHR, textStatus, errorThrown) => {
					console.error(textStatus);
					reject(new Error('조회중 오류가 발생했습니다.'));
				}
			});
		}).then(({newData, searchOptArr}) => {
			const refineList = new Array();
			newData.map(item => {
				const found = spcInfoArr.findIndex(x => x.spc_id === item.spc_id);

				let accountInfo = item.bank_name + ' ' + item.account_no;
				if (!isEmpty(item.account_owner)) {
					accountInfo += '(' +  item.account_owner + ')'
				}

				refineList.push({
					spcId: item.spc_id,
					spcName: spcInfoArr[found].spc_name,
					accountDatetime: item.account_datetime,
					accountInfo: accountInfo,
					kind: item.kind,
					amount: item.amount,
					accountDesc1: isEmpty(item.account_desc1) ? '-' : item.account_desc1,
					accountDesc2: isEmpty(item.account_desc2) ? '-' : item.account_desc2,
					accountDesc3: isEmpty(item.account_desc3) ? '-' : item.account_desc3,
					accountDesc4: isEmpty(item.account_desc4) ? '-' : item.account_desc4,
				});
			});

			transactionHistory.clear();
			transactionHistory.rows.add(refineList).draw();
			$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
		}).catch(error => {
			transactionHistory.clear().draw();
			errorMsg(error);
		});
	}

	/**
	 * 입출금 내역 갱신
	 */
	$(document).on('click', '#refresh', function () {
		let selectedSpc = new Array();
		document.querySelectorAll('#spcList input:checked').forEach(inp => {
			selectedSpc.push(inp.dataset.value);
		});

		if (selectedSpc.length > 0) {
			$('#loadingCircle').show();

			$.ajax({
				url: apiHost + '/spcs/transactions/real/refresh',
				type: 'GET',
				data: {
					oid: oid,
					spc_ids: selectedSpc.toString()
				},
				timeout: 300000
			}).done(function(data, textStatus, jqXHR) {
				if (!isEmpty(data) && !isEmpty(data.data)) {
					console.log(data);
					return false;
					$('#transactionForm').submit();
				}
			}).fail(function(jqXHR, textStatus, errorThrown) {
				console.error(textStatus);
				errorMsg('입출금 내역 갱신에 실패했습니다.');
				return false;
			})
		} else {
			errorMsg('선택된 SPC가 없습니다.');
			return false;
		}
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
	<!-- <button type="submit" id="forwardDetailBtn" class="hidden"></button> -->
</form>

<form id="reqDetailForm" class="" action="/spc/withdrawReqStatusDetail.do" method="post">
	<input type="hidden" id="reqDetailSpcId" name="req_detail_spc_id" value=''/>
	<input type="hidden" id="reqDetailSpcName" name="req_detail_spc_name" value=''/>
	<input type="hidden" id="reqDetailReqId" name="req_detail_req_id" value=''/>
	<input type="hidden" id="reqDetailAccountInfo" name="req_detail_acc_info" value=''/>
	<input type="hidden" id="reqDetailStatus" name="req_detail_status" value=''/>
	<input type="hidden" id="reqDetailStatusVal" name="req_detail_status_val" value=''/>
	<!-- <button type="submit" id="forwardDetailBtn" class="hidden"></button> -->
</form>

<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content collect-modal-content">
			<div class="modal-header">
				<h4 lass="modal-title">조회된 데이터가 없습니다.</h4>
			</div>
			<div class="modal-footer">
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="submit" id="confirmBtn" class="btn-type">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">입출금 관리 내역</h1>
	</div>
</div>

<div class="row spc-search-bar header-wrapper">
	<div class="col-11"><!--
	--><form id="transactionForm"><!--
		--><span class="tx-tit">SPC 선택</span><!--
		--><div class="sa-select">
				<div class="dropdown">
					<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="선택" data-value="">전체<span class="caret"></span></button>
					<ul id="spcList" class="dropdown-menu chk-type" role="menu">
						<li data-value="*spcId*"><!--
						--><a href="javascript:void(0);" tabindex="-1"><!--
							--><input type="checkbox" id="*spcName*" value="*spcId*" data-value="*spcId*" name="spcName" checked><!--
							--><label for="*spcName*">*spcName*</label><!--
						--></a><!--
					--></li><!--
				--></ul>
					<small class="hidden warning">선택해 주세요.</small>
				</div>
			</div><!--
		--><div class="dropdown">
				<button type="button" id="collapseBtn" class="dropdown-toggle clear-btn ml-24" data-toggle="collapse" data-target="#searchOption">상세 조건<span class="caret"></span></button>
				<ul id="searchOption" class="collapse dropdown-menu unused">
					<li class=""><!--
					--><h2 class="compare-title">입출금 조회 기간</h2>
						<div class="row align-group3">
							<div id="dateTerm" class="dropdown">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-target="#dateTerm" data-name="선택" value="">선택<span class="caret"></span></button>
								<ul id="unitOpt" class="dropdown-menu dropdown-offset" role="menu">
									<li data-value="yearly"><a href="javascript:void(0)" tabindex="-1">년</a></li>
									<li data-value="monthly"><a href="javascript:void(0)" tabindex="-1">월</a></li>
									<li data-value="daily"><a href="javascript:void(0)" tabindex="-1">일</a></li>
								</ul>
							</div><!--
						--><div class="dropdown">
								<input type="text" id="fromDate" name="fromDate" class="sel fromDate w-100" value="" autocomplete="off" placeholder="시작">
								<small class="hidden warning">선택해 주세요.</small>
							</div><!--
						--><div class="dropdown">
								<input type="text" id="toDate" name="toDate" class="sel toDate w-100" value="" autocomplete="off" placeholder="종료">
								<small class="hidden warning">선택해 주세요.</small>
							</div>
						</div><!--
				--></li><!--
				--><li class="">
						<div class="row align-group3">
							<div class="box-align dropdown">
								<h2 class="compare-title">입출금 구분</h2>
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" value="" data-value="0">전체<span class="caret"></span></button>
								<ul id="transactionType" class="dropdown-menu dropdown-offset" role="menu">
									<li data-value="0"><a href="javascript:void(0)" tabindex="-1">전체</a></li>
									<li data-value="1"><a href="javascript:void(0)" tabindex="-1">입금</a></li>
									<li data-value="2"><a href="javascript:void(0)" tabindex="-1">출금</a></li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
						</div>
					</li>
					<li class="btn-wrap-type03 btn-wrap-border">
						<button type="button" data-toggle="collapse" data-target="#searchOption" class="btn-type03" id="closeDropdown">취소</button>
						<button type="submit" class="btn-type ml-6">검색</button>
					</li>
				</ul>
			</div>
		</form>
	</div>
	<div class="col-1">
		<button type="button" id="refresh" class="btn-type03">입출금 내역 갱신</button>
	</div>
</div>

<div class="row spc-transaction">
	<div class="col-12">
		<div class="indiv">
			<table id="transactionHistory">
				<colgroup>
					<col style="width:14%"> <!-- SPC명 -->
					<col style="width:12%"> <!-- 최종 업데이트 -->
					<col style="width:14%"> <!-- 입출금 구분 -->
					<col style="width:14%"> <!-- 조회 계좌 정보 -->
					<col style="width:14%"> <!-- 금액 -->
					<col style="width:8%"> <!-- 설명1 -->
					<col style="width:8%"> <!-- 설명2 -->
					<col style="width:8%"> <!-- 설명3 -->
					<col style="width:8%"> <!-- 설명4 -->
				</colgroup>
			</table>
		</div>
	</div>
</div>
