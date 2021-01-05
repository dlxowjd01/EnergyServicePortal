<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	let today = new Date();
	let date = new Date();
	let spcPairArr = [];

	document.addEventListener('DOMContentLoaded', () => {
		const spcList = document.querySelector('#spcList li');
		while (spcList.firstChild) spcList.removeChild(spcList.firstChild);

		pageInit();

		<%-- 날짜 셀렉트 박스 --%>
		const searchDate = document.querySelectorAll('.search-select-wrapper ul li');
		[].forEach.call(searchDate, (target) => {
			target.addEventListener('click', (e) => {
				let targetDate = e.currentTarget;
				let thisVal = targetDate.dataset.value;
				let thisId = targetDate.closest('div.dropdown').getAttribute('id');

				if (thisId === 'year') {
					today = new Date(Number(thisVal), today.getMonth(), today.getDate());
				} else {
					today = new Date(today.getFullYear(), thisVal - 1, today.getDate());
				}

				buildCalendar();
			});
		});

		<%-- 전월 이동 --%>
		const prevMonth = document.querySelector('.btn-prev-month');
		prevMonth.addEventListener('click', changeMonth, false);

		<%-- 익월 이동 --%>
		const nextMonth = document.querySelector('.btn-next-month');
		nextMonth.addEventListener('click', changeMonth, false);

		<%-- 금월 이동 --%>
		const nowMonth = document.querySelector('.btn-type03.active');
		nowMonth.addEventListener('click', changeMonth, false);

		<%-- 반복 기간 --%>
		const repeatInterval = document.querySelectorAll('#repeat_interval, #repeat_unit');
		[].forEach.call(repeatInterval, (target) => {
			target.addEventListener('click change', repeatEnd, false);
		});

		<%-- 입출금 상태 && 주요일정 선택 --%>
		const typeInput = document.querySelectorAll('input[name="type"]');
		[].forEach.call(typeInput, (target) => {
			target.addEventListener('change', searchCalendar, false);
		});

		<%-- 검색어 입력 --%>
		const searchInput = document.getElementById('searchName');
		searchInput.addEventListener('keyup', searchCalendar, false);

		<%-- 모달팝업 열기 --%>
		const modalPopBtn = document.getElementById('addAlarmBtn');
		modalPopBtn.addEventListener('click', function() { modalPopInit() }, false);

		<%-- 확인버튼 클릭 --%>
		const confirmBtn = document.getElementById('confirmBtn');
		confirmBtn.addEventListener('click', () => {
			document.getElementById('detailInfoModal').classList.remove('active');
		}, false);

		 <%-- 더보기 레이어 확인 클릭 --%>
		const etcBtn = document.getElementById('dateEtcBtn');
		etcBtn.addEventListener('click', () => {
			document.getElementById('dateEtcModal').classList.remove('active');
		}, false);
	});

	<%-- 월별 이동 --%>
	const changeMonth = (e) => {
		const target = e.currentTarget
			, targetClass = target.getAttribute('class');
		let symbol = '';

		if (targetClass === 'btn-prev-month') symbol = '-';
		else if (targetClass === 'btn-next-month') symbol = '+';
		else symbol = '';

		if (isEmpty(symbol)) {
			today = new Date();
		} else {
			today = new Date(today.getFullYear(), eval('today.getMonth() ' + symbol + ' 1'), today.getDate());
		}

		buildCalendar();
	}

	/**
	 * 페이지 초기화
	 */
	const pageInit = function () {
		<%-- task 1: 사무수탁사  2: 자산 운용사  3: 사업주  ||  role 1: encored  2: spc clients --%>
		if(task === '2' && task === '3') {
			document.getElementById('requestBtn').remove();
		} else if( task === '4') {
			document.getElementById('requestBtnReview').remove();
			document.getElementById('requestBtn').remove();
		}

		let html = '';
		let year = today.getFullYear();
		let month = today.getMonth() + 1;

		let yearDropdown = document.getElementById('year');
		let monthDropdown = document.getElementById('month');

		yearDropdown.querySelector('button').innerHTML = year + '년<span class="caret"></span>';
		yearDropdown.querySelector('button').dataset.value = String(year);
		monthDropdown.querySelector('button').innerHTML = month + '년<span class="caret"></span>';
		monthDropdown.querySelector('button').dataset.value = String(month);

		for (let i = 0; i < 5; i++) {
			let bfYear = new Date(year - i, month + 1);
			let select = i === 0 ? 'on' : '';
			html += '<li data-value="' + bfYear.getFullYear() + '" class="' + select + '"><a href="#">' + bfYear.getFullYear() + '년 </a></li>';
		}

		const yearList = yearDropdown.querySelector('li');
		while (yearList.firstChild) yearList.removeChild(yearList.firstChild);
		yearDropdown.querySelector('ul').innerHTML = html;

		getSpcList();
	};

	/**
	 * spc 리스트 조회
	 */
	const getSpcList = () => {
		new Promise(resolve =>  {
			$.ajax({
				url: apiHost + '/spcs?oid=' + oid + '&includeGens=true',
				type: 'GET',
				beforeSend: function(){
					document.getElementById('loadingCircle').display = 'block';
				},
				success: function (json) {
					let data = json.data;
					if (!isEmpty(data)) { resolve(data); }
					else { new Error('SPC 조회 내역이 없습니다.') }
				},
				error: function(request, status, error) {
					console.error(status);
					new Error('SPC 조회 중 오류가 발생했습니다.');
				}
			});
		}).then(data => {
			let liStr = ``;
			data.forEach(x => {
				let spcInfo = JSON.parse(x.spc_info)
					, spcId = x.spc_id
					, spcName = !isEmpty(x.name) ? x.name : !isEmpty(spcInfo.name) ? spcInfo.name : !isEmpty(spcInfo.spcName) ? spcInfo.spcName : 'no_name';

				spcPairArr.push({
					spcId: spcId,
					spcName: spcName
				});
				liStr += `<li data-name="${'${spcName}'}" data-value="${'${spcId}'}"><a href="javascript:void(0);" tabindex="-1">${'${spcName}'}</a></li>`;
			});

			document.getElementById('spcList').innerHTML = liStr;
			buildCalendar();
		}).catch(error => {
			console.error(error);
		});
	}

	// calendar frame ONLY (no data)
	const buildCalendar = function () { //현재 달 달력 만들기
		let doMonth = new Date(today.getFullYear(), today.getMonth(), 1);
		let lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0);
		let calendar = document.getElementById('calendar');

		while (calendar.rows.length > 1) {
			calendar.deleteRow(calendar.rows.length - 1);
		}

		let row = calendar.insertRow();
		let cell = null;
		let cnt = 0;
		const thisMonth = doMonth.getMonth() + 1 + '월';

		for (let i = 0; i < doMonth.getDay(); i++) {
			cell = row.insertCell();
			cnt = cnt + 1;
		}

		for (let i = 1; i <= lastDate.getDate(); i++) {
			cell = row.insertCell();
			cell.innerHTML = `<h2 class="date" data-day="` + doMonth.format('yyyyMM') + i + '">' + i + '</h2><ul class="alarm-list"></ul>';
			cnt = cnt + 1;

			if (cnt % 7 === 0) {
				row = calendar.insertRow();
			}
			/* today */
			if (today.getFullYear() === date.getFullYear() &&
				today.getMonth() === date.getMonth() &&
				i === date.getDate()) {
				cell.setAttribute('class', 'today');
			}
		}

		document.getElementById('detailModalTrigger').textContent = thisMonth;
		document.getElementById('modalTitle').textContent = thisMonth;

		document.querySelector('#year > button').innerHTML = doMonth.getFullYear() + '년<span class="caret"></span>';
		document.querySelector('#year > button').dataset.value = String(doMonth.getFullYear());
		document.querySelector('#month > button').innerHTML = doMonth.getMonth() + 1 + '월<span class="caret"></span>';
		document.querySelector('#month > button').dataset.value = String(doMonth.getMonth() + 1);

		maintenance('GET');
	};

	const maintenance = function (action, jobId) {
		if (action === 'GET') {
			const apiUrls = new Array();
			let maintenanceObject = new Object();
			let yyyy = document.querySelector('#year > button').dataset.value;
			let mm = ('0' + document.querySelector('#month > button').dataset.value).slice(-2);
			let spcId = '';

			if(!isEmpty(spcPairArr)){
				if(typeof spcPairArr === 'number' ){
					spcId = spcPairArr;
				} else if (spcPairArr.length) {
					spcId = spcPairArr.map(x => x.spcId).join();
				} else {
					spcId = spcPairArr.spcId;
				}
			}

			maintenanceObject = {
				oid: oid,
				type: 'money',
				like_yyyymm: yyyy + mm
			}

			if (!isEmpty(jobId)) {
				maintenanceObject['jobId'] = jobId
			}

			apiUrls.push($.ajax({
				url: apiHost + '/spcs/maintenance',
				type: 'GET',
				data: maintenanceObject
			}));

			apiUrls.push($.ajax({
				url: apiHost + '/spcs/transactions',
				type: 'GET',
				data: {
					oid: oid,
					spcIds: spcId,
					startDay: yyyy + mm + '01',
					endDay: yyyy + mm + new Date(yyyy, mm, 0).getDate()
				}
			}));

			if (!isEmpty(jobId)) {
				option.data.jobId = jobId;
			}

			Promise.all(apiUrls).then(response => {
				let rtnArray = new Array();
				response.forEach((res, index) => {
					let database = res.data;
					if (!isEmpty(database)) {
						database.forEach(data => {
							if (index === 0) {
								rtnArray.push({
									date: new Date(data.job_date).format('yyyyMMdd'),
									job_type: data.job_type,
									spc_id: data.spc_id,
									id: data.id,
									modal_data: data
								});
							} else {
								let status = data.status === 9 ? 13 : data.status;
								rtnArray.push({
									date: data.withdraw_day,
									spc_id: data.spc_id,
									status: status
								});
							}
						});
					}
				});

				if (!isEmpty(rtnArray)) {
					rtnArray = groupBy(rtnArray, 'date');
				}

				fillCalender(rtnArray);
			}).catch(error => {
				console.error(error);
				showWarningModal('fail');
			});
		} else {
			let option;
			if (action == 'POST' || action == 'PATCH') {
				let data = setData();
				if (isEmpty(data['spc_id'])) {
					alert('SPC 선택은 필수 값입니다.');
					return false;
				}

				if (isEmpty(data['job_type'])) {
					alert('알림 항목은 필수 값입니다.');
					return false;
				}

				if (isEmpty(data['job_date'])) {
					alert('기준 일자는 필수 값입니다.');
					return false;
				}

				if (isEmpty(data['repeat_yn'])) {
					alert('점검 주기는 필수 값입니다.');
					return false;
				} else {
					if (data['repeat_yn'] == 'Y') {
						if (isEmpty(data['repeat_interval'])) {
							alert('정기 점검은 반복 기간은 필수 값입니다.');
							return false;
						}

						if (isEmpty(data['repeat_unit'])) {
							alert('정기 점검 반복 주기는 필수 값입니다.');
							return false;
						}

						if (isEmpty(data['repeat_end'])) {
							alert('정기 점검 반복 종료일 은 필수 값입니다.');
							return false;
						}
					}
				}

				let job_info = JSON.parse(data['job_info']);
				if (!isEmpty(job_info['alarmSetup'])) {

					if (isEmpty(job_info['alarmDate'])) {
						alert('알람 설정시 알람 일자는 필수 값입니다.');
						return false;
					}

					if (isEmpty(job_info['alarmTime'])) {
						alert('알람 설정시 알람 시간은 필수 값입니다.');
						return false;
					}

					if (isEmpty(job_info['alarmPhone'])) {
						alert('알람 설정시 알람 수신번호는 필수 값입니다.');
						return false;
					}
				}

				let url = '';
				data.spc_id = Number(data.spc_id);

				if (action == 'PATCH') {
					let jobText = jobId == undefined ? '' : '&jobId=' + jobId;
					delete data.spc_id;
					delete data.type;
					option = {
						url: apiHost + '/spcs/maintenance/'  + jobId + '?oid=' + oid,
						dataType: 'json',
						type: action,
						contentType: "application/json",
						traditional: true,
						data: JSON.stringify(data),
						beforeSend: function() {
							$('#loadingCircle').show();
						},
					};
					// url = apiHost + '/spcs/bankbook/' + jobId + '?oid=' + oid + jobText;
				} else {
					// POST req
					option = {
						url: apiHost + '/spcs/maintenance?oid=' + oid,
						dataType: 'json',
						type: action,
						contentType: "application/json",
						traditional: true,
						data: JSON.stringify(data)
					};
				}
			} else {
				// DELETE req
				if (!confirm('삭제 하시겠습니까?')) {
					return false;
				}
				if (action == 'DELETE') {
					let jobText = jobId == undefined ? '' : '&jobId=' + jobId;
					option = {
						url: apiHost + '/spcs/maintenance/' + jobId + '?oid=' + oid,
						type: action,
						data: {
							oid: oid,
							jobId: jobId,
						}
					};
				}
			}

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				$("#spcAlarmModal").modal("hide");
				document.location.reload(true);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				showWarningModal("fail");
				console.errer("jqXHR===", jqXHR)
				return false;
			});
		}
	};

	/**
	 * 달력안에 일정 세팅
	 *
	 * @param data - 주요 일정 && 입출금 일정
	 */
	const fillCalender = (data, type) => {
		const calendar = document.querySelectorAll('#calendar .alarm-list');
		const modalData = document.querySelector('#detailInfoModal .alarm-list');
		const alarmList = document.querySelectorAll('ul.alarm-list');

		//초기화
		alarmList.forEach(alarm => {
			while (alarm.hasChildNodes()) { alarm.removeChild(alarm.firstChild); }
		});

		const checkType = [].map.call(document.querySelectorAll('[name="type"]:checked'), (chk) => { return Number(chk.value) });

		const searchName = document.getElementById('searchName').value.trim()
			, regExp = new RegExp(searchName, 'i');

		let modalStr = ``;
		Object.entries(data).forEach(([date, items]) => {
			const calendarDate = Number(date.slice(-2)) - 1;
			let tableStr = ``
			  , showCount = 0
			  , transactionCount = 0
			  , first = true;

			items.forEach(item => { if(isEmpty(item.job_type)) { transactionCount++; } });
			items.forEach((item, index) => {
				let spcName = '', hiddenClass = '';

				//SPC_NAME
				spcPairArr.some(x => { if(x.spcId === item.spc_id) { spcName = x.spcName; } });
				if (isEmpty(spcName)) spcName = 'spc_no_name';

				//업무 구분
				const jobType = !isEmpty(item.job_type) ? Number(item.job_type) : item.status;
				const jobName = !isEmpty(item.job_type) ? job_name(item.job_type) : status_name(item.status);

				//왼쪽 검색조건 적용
				if (!checkType.includes(jobType)) {
					hiddenClass = 'hidden';
				} else {
					if (!isEmpty(searchName)) {
						if (regExp.test(jobName) || regExp.test(spcName)) {
							hiddenClass = '';
							showCount++;
						} else {
							hiddenClass = 'hidden';
						}
					} else {
						hiddenClass = '';
						showCount++;
					}
				}
				if (showCount > 2) { hiddenClass = 'hidden'; }

				if (!isEmpty(item.job_type)) {
					tableStr += `<li data-jobId="${'${item.id}'}" data-id="${'${item.spc_id}'}" data-name="${'${spcName}'}" class="link bu t${'${jobType}'} ${'${hiddenClass}'}">[${'${spcName}'}] ${'${jobName}'}</li>`;
					modalStr += `<li class="link alarm-item ${'${hiddenClass}'}" data-id="${'${item.id}'}">
									<span data-jobId="${'${item.id}'}" data-id="${'${item.spc_id}'}" data-name="${'${spcName}'}" class="bu t${'${jobType}'}">[${'${spcName}'}] ${'${jobName}'}</span>
									<span class="fr btn-next"></span>
									<br>
								</li>`;
				} else {
					const bulletIdx = statusCode(jobType);
					tableStr += `<li data-id="${'${item.spc_id}'}" data-name="${'${spcName}'}" data-value="${'${jobType}'}" class="bu t${'${bulletIdx}'} ${'${hiddenClass}'}">[${'${spcName}'}] ${'${jobName}'}</li>`;

					if (first) {
						first = false;
						let suffix = '';
						if (transactionCount > 1) { suffix = (transactionCount - 1) + ' 외'; }
						modalStr += `<li class="alarm-item link ${'${hiddenClass}'}">
										<span data-id="${'${item.spc_id}'}" data-name="${'${spcName}'}" data-value="${'${jobType}'}" class="bu t${'${bulletIdx}'}">
											[${'${spcName}'}] ${'${jobName}'} ${'${suffix}'}
										</span>
										<span class="fr btn-next"></span><br/>
									</li>`;
					}
				}
			});

			if ((showCount - 2) > 0) {
				tableStr += `<li>
								<button type="button" class="btn-type06" id="dateModal${'${calendarDate}'}">
									${'${showCount - 2}'} 개 더보기
								</button>
							</li>`;
			}

			calendar[calendarDate].innerHTML = tableStr;

			const dateEtc = document.getElementById('dateModal' + calendarDate);
			if (dateEtc !== null) {
				dateEtc.addEventListener('click', () =>{ dateModal(date, items); }, false);
			}
		});

		modalData.innerHTML = modalStr;

		const calendarLi = document.querySelectorAll('#calendar .alarm-list li.link');
		[].forEach.call(calendarLi, (target) => {
			target.addEventListener('click', (e) => {
				let targetDate = e.currentTarget;
				let jobid = targetDate.dataset.jobid;

				if (isEmpty(jobid)) {
					modalPopInit();
				} else {
					let spcObj = new Object;
					spcObj.spcId = targetDate.dataset.id;
					spcObj.spcName = targetDate.dataset.name;
					const jobId = targetDate.dataset.jobid;

					modalPopInit(data, spcObj, jobId);
				}
			});
		});
	}

	/**
	 * 트랜잭션 리스트에서 나온 값으로
	 * 블릿인덱스 설정
	 */
	const statusCode = (status) => {
		let bulletIdx;
		if(status === 1) {
			bulletIdx = '2';
		} else if(status === 2) {
			bulletIdx = '3';
		} else if(status === 3) {
			bulletIdx = '1';
		} else if(status === 4) {
			bulletIdx = '4';
		} else if(status === 5) {
			bulletIdx = '5';
		} else if(status === 13) {
			bulletIdx = '13';
		}

		return bulletIdx;
	}


	/**
	 * 일자별 더보기 함수
	 */
	const dateModal = (date, items) => {
		const calendarDate = (date.slice(-4)).replace(/(\d{2})(\d{2})/, '$1월 $2일')
			, etcModal = document.getElementById('dateEtcModal')
			, modalData = document.querySelector('#dateEtcModal .alarm-list')
			, regExp = new RegExp(searchName, 'i');
		let modalStr = ``;
		let checkType = new Array();
		document.querySelectorAll('[name="type"]:checked').forEach(checkbox => {
			checkType.push(checkbox.value);
		});

		document.getElementById('dateEtcTitle').innerText = calendarDate;

		items.forEach(item => {
			let spcName = ''
			  , hiddenClass = '';
			if (!isEmpty(spcPairArr)) {
				spcPairArr.some(x => { if(x.spcId === item.spc_id) { spcName = x.spcName; } });
			}

			if (isEmpty(spcName)) spcName = 'spc_no_name';

			if (!isEmpty(item.job_type)) {
				const jobName = job_name(item.job_type);
				if (!checkType.includes(item.job_type)) {
					hiddenClass = 'hidden';
				} else {
					if (!isEmpty(searchName) && (regExp.test(searchName) || regExp.test(jobName))
					) {
						hiddenClass = 'hidden';
					}
				}

				modalStr += `<li class="link alarm-item ${'${hiddenClass}'}" data-id="${'${item.id}'}">
								<span data-jobId="${'${item.id}'}" data-id="${'${item.spc_id}'}" data-name="${'${spcName}'}" class="bu t${'${item.job_type}'}">[${'${spcName}'}] ${'${jobName}'}</span>
								<span class="fr btn-next"></span>
								<br>
							</li>`;
			} else {
				const status = item.status
					, statusName = status_name(item.status);

				let bulletIdx;
				if(status === 1) {
					bulletIdx = '2';
				} else if(status === 2) {
					bulletIdx = '3';
				} else if(status === 3) {
					bulletIdx = '1';
				} else if(status === 4) {
					bulletIdx = '4';
				} else if(status === 5) {
					bulletIdx = '5';
				} else if(status === 6) {
					bulletIdx = '6';
				} else {
					bulletIdx = '13';
				}

				if (!checkType.includes(bulletIdx)) {
					hiddenClass = 'hidden';
				} else {
					if (!isEmpty(searchName) && (regExp.test(searchName) || regExp.test(jobName))
					) {
						hiddenClass = 'hidden';
					}
				}

				modalStr += `<li class="alarm-item link ${'${hiddenClass}'}">
								<span data-id="${'${item.spc_id}'}" data-name="${'${spcName}'}" data-value="${'${status}'}" class="bu t${'${bulletIdx}'}">
									[${'${spcName}'}] ${'${statusName}'}
								</span>
								<span class="fr btn-next"></span><br/>
							</li>`;
			}
		});

		modalData.innerHTML = modalStr;
		etcModal.classList.add('active');
		if (document.getElementById('detailInfoModal').classList.contains('active')) {
			document.getElementById('detailInfoModal').classList.remove('active');
		}

	}

	const modalPopInit = function (data, spcNameList, jobId) {
		const modal = $('#spcAlarmModal');
		const modalForm = $('#spcAlarmForm');
		const title = modal.find('h2');
		const input = modal.find('input');
		const dropDown = modal.find('.dropdown-toggle');
		const repeat_wrapper = $('#repeat_yn').parents('.flex-start3');
		const repeat_cycle = $('#repeat_yn button');
		const postScheduleBtn = $('#postScheduleBtn');
		const deleteScheduleBtn = $('#deleteScheduleBtn');
		const warning = $('#spcAlarmModal').find('.warning');
		// let modalData = $("#popoverModal").find("ul.alarm-list");
		var spcIdArr = spcNameList;
		repeat_cycle.data('value', '');
		repeat_cycle.parents('div.dropdown').siblings().addClass('hidden');
		repeat_wrapper.removeClass("short");


		$('#repeat_end').removeClass('sel').parent().removeClass('sel-calendar').addClass('text-input-type');
		warning.addClass('hidden');

		if (data == undefined) {
			unCheckAll(modalForm);
			//팝업 오픈시 value 초기화
			input.each(function () {
				$(this).val('');
			});
			//팝업 오픈시 value 초기화
			dropDown.each(function () {
				$(this).data('value', '').html($(this).data('name') + '<span class="caret"></span>');
			});

			$('#alarmPhone').val(contact_phone);
			$("#spcList").removeClass('hidden').prev().html("선택" + '<span class="caret"></span>').data({"value": "", "name" : "" });
			deleteScheduleBtn.addClass('hidden');
			postScheduleBtn.text('등록');

			postScheduleBtn.off('click');
			postScheduleBtn.on("click", function(){
				maintenance('POST');
			});
		} else {
			let targetDate;
			Object.entries(data).forEach(([date, items]) => {
				items.forEach(item => {
					if (item.id === Number(jobId)) {
						targetDate = item;
					}
				});
			});

			title.text('주요 일정 알림 수정');
			const jobInfo = JSON.parse(targetDate.modal_data.job_info);
			setJsonAutoMapping(targetDate.modal_data, 'spcAlarmModal', 'dropdown');
			setJsonAutoMapping(jobInfo, 'spcAlarmModal');

			if (jobInfo['alarmSetup'] == '') {
				if ($('#alarmDate').hasClass('hasDatepicker')) {
					$('#alarmDate').datepicker('destroy').removeClass('hasDatepicker').addClass('disabled').removeAttr('placeholder').val('');
				}
			} else if (jobInfo['alarmSetup'] == '직접 설정') {
				$('#alarmDate').datepicker({
					showOn: "both",
					buttonImageOnly: true,
					dateFormat: 'yy-mm-dd',
					beforeShow: function () {
						let minDate = $('#job_date').datepicker('getDate');
						if (minDate != '') {
							$('#alarmDate').datepicker('option', 'minDate', minDate);
						}

						let maxDate = $('#repeat_end').datepicker('getDate');
						if (maxDate != '') {
							$('#alarmDate').datepicker('option', 'maxDate', maxDate);
						}
					}
				}).removeClass('disabled').attr('placeholder', '직접선택');
			} else {
				if ($('#alarmDate').hasClass('hasDatepicker')) {
					$('#alarmDate').datepicker('destroy').removeClass('hasDatepicker').addClass('disabled').removeAttr('placeholder');
				}
			}

			$("#spcList").addClass("hidden").prev().data({"value": spcNameList.spcId, "name" : spcNameList.spcName }).text(spcNameList.spcName);

			let jobDate = new Date(targetDate.job_date);
			$('#job_date').datepicker('setDate', jobDate);

			let repeatEnd = new Date(targetDate.repeat_end);
			$('#repeat_end').val(repeatEnd.format('yyyy-MM-dd'));

			if ($('#repeat_yn button').data('value') == 'N') {
				$('#repeat_end').val('').datepicker('destroy').removeClass('sel');
				$('#repeat_end').parent().removeClass('sel-calendar').addClass('text-input-type');

				$('#repeat_yn').parents('.flex-start3').removeClass('short');
				$('#repeat_yn').siblings().addClass('hidden');

				$('#repeat_end').removeClass('sel').parent().removeClass('sel-calendar').addClass('text-input-type');
			} else {
				$('#repeat_yn').parents('.flex-start3').addClass('short');
				$('#repeat_yn').siblings().removeClass('hidden');

				$('#repeat_end').addClass('sel').parent().removeClass('text-input-type').addClass('sel-calendar');
				$('#repeat_end').removeClass('hasDatepicker').datepicker({
					showOn: 'both',
					buttonImageOnly: true,
					dateFormat: 'yy-mm-dd',
					beforeShow: function () {
						let fromDate = $(this).closest('.dateField').find('.fromDate').datepicker('getDate');
						if (fromDate != '') {
							$(this).datepicker('option', 'minDate', fromDate.format('yyyy-MM-dd'));
						}
					},
					onClose: function (selected) {
						$(this).closest('.dateField').find('.fromDate').datepicker('option', 'maxDate', selected);
					}
				});
			}

			deleteScheduleBtn.removeClass('hidden');
			deleteScheduleBtn.off('click');
			deleteScheduleBtn.on("click", function(e){
				maintenance('DELETE', targetDate.id);
			});
			postScheduleBtn.text('수정');

			postScheduleBtn.off('click');
			postScheduleBtn.on("click", function(){
				maintenance('PATCH', targetDate.id);
			});
		}
		modal.modal("show");
		if($("#detailInfoModal").hasClass("active")) {
			$("#detailInfoModal").removeClass("active");
		}
	}

	<%--// 등록 & 수정 용 데이터 세팅--%>
	const setData = function () {
		let jsonData = {};
		let job_info = {};
		let job_info_Array = ['spcName', 'worker', 'note', 'description', 'alarmDate', 'alarmTime', 'alarmPhone', 'alarmSetup'];
		let warning = $('#spcAlarmModal').find('.warning');

		$('#spcAlarmModal input, textarea').each(function (index, element) {
			if ($.inArray($(this).prop('name'), job_info_Array) > -1) {
				job_info[$(this).prop('name')] = String($(this).val());
				if ($(this).prop('name') == 'worker'){
					$(this).val() != '' ? $(this).parent().find('.warning').addClass('hidden') : $(this).parent().find('.warning').removeClass('hidden');
				}
			} else {
				// repeat_end
				if ($(this).hasClass('hasDatepicker')) {
					let pickedDate = $(this).datepicker('getDate');
					if (pickedDate != null) {
						jsonData[$(this).prop('name')] = pickedDate.toISOString();
					} else {
						$(this).val() != '' ? $(this).parent().find('.warning').addClass('hidden') : $(this).parent().find('.warning').removeClass('hidden');
					}
				} else {
					jsonData[$(this).prop('name')] = $(this).val();
					// console.log("this===", $(this).prop("name"))
				}
			}
		});

		$('#spcAlarmModal .dropdown-toggle').each(function () {
			if ($.inArray($(this).parent().prop('id'), job_info_Array) > -1) {
				job_info[$(this).parent().prop('id')] = String($(this).data('value'));
			} else {
				// console.log("this---", $(this), "val---", $(this).data("value"))
				if($(this).parent().is("#repeat_yn")){
					jsonData[$(this).parent().prop('id')] = String($(this).data('value'));
					// console.log("this---", $(this), "val---", $(this).data("value"))
				} else {
					jsonData[$(this).parent().prop('id')] = String($(this).data('value'));
				}
			}
		});
		//일시점검일 경우 종료일은 점검 기준일자와 동일하다.
		if ($('#repeat_yn button').data('value') == 'N') {
			jsonData['repeat_end'] = jsonData['job_date'];
		}
		// if($(this).prop('name') == 'worker') {
		// 		$(this).val() != '' ? $(this).parent().find('.warning').addClass('hidden') : $(this).parent().find('.warning').removeClass('hidden');
		// 	}

		jsonData.job_info = JSON.stringify(job_info);
		jsonData.repeat_interval = Number(jsonData.repeat_interval);
		jsonData.updated_by = loginId;
		jsonData.type = "money";

		return jsonData;
	};

	/**
	 * 달력 검색
	 */
	const searchCalendar = function () {
		const checkType = [].map.call(document.querySelectorAll('[name="type"]:checked'), (chk) => { return Number(chk.value) })
			, searchName = document.getElementById('searchName').value.trim()
			, regExp = new RegExp(searchName, 'i')
			, etcModal = document.getElementById('dateEtcModal');

		if (etcModal.classList.contains('active')) {
			etcModal.classList.remove('active');
		}

		//요약 팝업
		document.querySelectorAll('#detailInfoModal .alarm-item.link').forEach(bullet => {
			const bulletIndex = Number(bullet.firstElementChild.className.replace(/[^0-9]/g, '').trim())
				, spcName = bullet.firstElementChild.innerHTML;

			if (!checkType.includes(bulletIndex)) {
				bullet.classList.add('hidden');
			} else {
				if (!isEmpty(searchName)) {
					if (regExp.test(spcName)) {
						bullet.classList.remove('hidden');
					} else {
						bullet.classList.add('hidden');
					}
				} else {
					bullet.classList.remove('hidden');
				}
			}
		});

		//달력 표기
		document.querySelectorAll('#calendar td .alarm-list').forEach(date => {
			const bulletList = date.querySelectorAll('.bu');
			let showCount = 0;

			bulletList.forEach(bullet => {
				const bulletIndex = Number(bullet.className.replace(/[^0-9]/g, '').trim())
					, spcName = bullet.innerHTML;

				if (!checkType.includes(bulletIndex)) {
					bullet.classList.add('hidden');
				} else {
					if (!isEmpty(searchName)) {
						if (regExp.test(spcName)) {
							if (showCount < 2) {
								bullet.classList.remove('hidden');
							} else {
								bullet.classList.add('hidden');
							}
							showCount++;
						} else {
							bullet.classList.add('hidden');
						}
					} else {
						if (showCount < 2) {
							bullet.classList.remove('hidden');
						} else {
							bullet.classList.add('hidden');
						}
						showCount++;
					}
				}
			});

			if (bulletList.length > 0) {
				const etcButton = date.querySelector('[id^="dateModal"]');
				if (showCount > 2) {
					etcButton.classList.remove('hidden');
					etcButton.innerHTML = (showCount - 2) + ' 개 더보기';
				} else {
					if (etcButton !== null) {
						etcButton.classList.add('hidden');
					}
				}
			}
		});

	};

	const status_name = function (type) {
		let rtn = '';

		switch (type) {
			case 0: rtn = '출금 - 반송'
				break;
			case 1: rtn = '출금 - 승인 대기'
				break;
			case 2: rtn = '출금 - 승인 중'
				break;
			case 3: rtn = '출금 - 승인 완료'
				break;
			case 4: rtn = '출금 - 가승인'
				break;
			case 5: rtn = '출금 - 최종 승인'
				break;
			case 6: rtn = '입금'
				break;
			case 13: rtn = '출금 - 임시 저장'
				break;
			default: rtn = ''
				break;
		}
		return rtn;
	};

	const job_name = function (type) {
		let rtn = '';
		switch (type) {
			// case '1': rtn = '출금-승인완료'
			// 	break;
			// case '2': rtn = '출금-승인대기'
			// 	break;
			// case '3': rtn = '출금-승인중'
			// 	break;
			// case '4': rtn = '입금'
				// break;
			case '6': rtn = '이자 지급일'
				break;
			case '7': rtn = '보장발전시간 정산일'
				break;
			case '8': rtn = '보험 갱신일'
				break;
			case '9': rtn = '보험 납부일'
				break;
			case '10': rtn = '임대료 지급일'
				break;
			case '11': rtn = '대리기관수수료 지급일'
				break;
			case '12': rtn = '대출상환 만기일'
				break;
			default: rtn = ''
				break;
		}
		return rtn;
	};

	const repeatEnd = function (selectedDate) {
		if (selectedDate == undefined && $('#job_date').datepicker('getDate') != null) {
			selectedDate = $('#job_date').datepicker('getDate');
		}

		if ($('#repeat_yn button').data('value') == '') {
			return false;
		} else if ($('#repeat_yn button').data('value') == 'N') {
			$('#repeat_end').val('').datepicker('destroy').removeClass('sel');
			$('#repeat_end').parent().removeClass('sel-calendar').addClass('text-input-type');
		} else {
			$('#repeat_end').removeClass('hasDatepicker').datepicker({
				showOn: 'both',
				buttonImageOnly: true,
				dateFormat: 'yy-mm-dd',
				beforeShow: function () {
					let fromDate = $(this).closest('.dateField').find('.fromDate').datepicker('getDate');
					if (fromDate != null) {
						$(this).datepicker('option', 'minDate', fromDate.format('yyyy-MM-dd'));
					}
				},
				onClose: function (selected) {
					$(this).closest('.dateField').find('.fromDate').datepicker('option', 'maxDate', selected);
				}
			});
			$('#repeat_end').addClass('sel').parent().removeClass('text-input-type').addClass('sel-calendar');
		}

		if ($('#alarmSetup button').data('value') == '') {
			$('#alarmDate').val('');
		} else {
			if ($('#alarmSetup button').data('value') != '직접 설정') {
				if (typeof selectedDate === 'string') {
					let dummyDate = selectedDate.split('-');
					selectedDate = new Date(Number(dummyDate[0]), Number(dummyDate[1]), Number(dummyDate[2]));
				}

				selectedDate.setDate(selectedDate.getDate() - Number($('#alarmSetup button').data('value')));
				$('#alarmDate').val(selectedDate.format('yyyy-MM-dd'));
			}
		}
	}

	const rtnDropdown = function (buttonId) {
		var obj = $('#' + buttonId),
			val = obj.find('button').data('value');
		if (buttonId == 'repeat_yn') {
			if (val == 'Y') {
				obj.parents('.flex-start3').addClass('short');
				obj.siblings().removeClass('hidden');
				obj.next('.text-input-type').find('input').val('');
				$('#repeat_end').addClass('sel').parent().removeClass('text-input-type').addClass('sel-calendar');
			} else {
				obj.parents('.flex-start3').removeClass('short');
				obj.siblings().addClass('hidden');
				obj.next('.text-input-type').find('input').val(0);
				$('#repeat_end').removeClass('sel').parent().removeClass('sel-calendar').addClass('text-input-type');
			}
			dropDownInit($('#repeat_unit'));
			repeatEnd();
		} else if (buttonId == 'alarmSetup') {
			if ($('#alarmDate').hasClass('hasDatepicker')) {
				$('#alarmDate').datepicker('destroy').removeClass('hasDatepicker').addClass('disabled').removeAttr('placeholder');
			}

			if (val === '') {
				$('#alarmDate').val('');
			} else {
				if (val != '직접 설정') {
					let jobDate = $('#job_date').datepicker('getDate');
					if (jobDate == null) {
						$('#alarmDate').val('');
					} else {
						jobDate.setDate(jobDate.getDate() - val);
						$('#alarmDate').val(jobDate.format('yyyy-MM-dd'));
					}
				} else {
					$('#alarmDate').datepicker({
						showOn: "both",
						buttonImageOnly: true,
						dateFormat: 'yy-mm-dd',
						beforeShow: function () {
							let minDate = $('#job_date').datepicker('getDate');
							if (minDate != '') {
								$('#alarmDate').datepicker('option', 'minDate', minDate);
							}

							let maxDate = $('#repeat_end').datepicker('getDate');
							if (maxDate != '') {
								$('#alarmDate').datepicker('option', 'maxDate', maxDate);
							}
						}
					}).removeClass('disabled').attr('placeholder', '직접선택');
					$('#alarmDate').val('');
				}
			}
		}
	}

	const afterDatePick = function (inputName) {
		if(inputName == 'job_date') {
			rtnDropdown('alarmSetup');
		} else {
			repeatEnd();
		}
	}

	function showWarningModal(action){
		if($("#detailInfoModal").hasClass("active")){
			$("#detailInfoModal").removeClass("active");
		};
		// console.log("action===", action)
		if(action=="confirm"){
			$("#warningModal .modal-title").text("정말 삭제 하시겠습니까?");
			$("#warningModal").modal("show");
		} else if(action=="nodata"){
			$("#warningModal .modal-title").text("데이터가 없습니다.");
			$("#warningModal").modal("show");
		} else if(action == "fail"){
			$("#warningModal .modal-title").text("처리 중 오류가 발생했습니다.");
			$("#warningModal").modal("show");
		}
	}
</script>


<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content collect-modal-content">
			<div class="modal-header">
				<h4 lass="modal-title"></h4>
			</div>
			<div class="modal-footer">
				<div class="btn-wrap-type02">
					<button type="button" id="closeBtn" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="submit" id="warningConfirmBtn" class="btn-type">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="popoverModal" class="popover modal-content popover-modal">
	<div class="modal-header">
		<h2 class="popover_title"></h2>
	</div>
	<div class="modal-body"><ul class="alarm-list"></ul></div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">월간 입출금 일정</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-2 col-md-4 clear">
		<div class="search-select-wrapper">
			<div class="search-select-item">
				<div class="dropdown" id="year">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
					<ul class="dropdown-menu">
						<li><a href="#">2020</a></li>
						<li><a href="#">2019</a></li>
						<li><a href="#">2018</a></li>
					</ul>
				</div>
			</div>
			<div class="search-select-item">
				<div class="dropdown" id="month">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
					<ul class="dropdown-menu">
						<li data-value="1"><a href="#">1월</a></li>
						<li data-value="2"><a href="#">2월</a></li>
						<li data-value="3"><a href="#">3월</a></li>
						<li data-value="4"><a href="#">4월</a></li>
						<li data-value="5"><a href="#">5월</a></li>
						<li data-value="6"><a href="#">6월</a></li>
						<li data-value="7"><a href="#">7월</a></li>
						<li data-value="8"><a href="#">8월</a></li>
						<li data-value="9"><a href="#">9월</a></li>
						<li data-value="10"><a href="#">10월</a></li>
						<li data-value="11"><a href="#">11월</a></li>
						<li data-value="12"><a href="#">12월</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>



<div class="modal fade alarm-modal" id="spcAlarmModal" tabindex="-1" role="form">
	<div class="modal-dialog spc-modal-lg no-flex">
		<div class="modal-content spc-modal-content">
			<form id="spcAlarmForm">
				<div class="modal-header">
					<h2>주요 일정 알림 등록<span class="required fr">필수 입력 항목</span></h2>
				</div>
				<div class="modal-body">
					<div class="container-fluid">
						<div class="row">
							<div class="col-lg-2 col-md-2 col-sm-12"><span class="input-label">SPC 선택</span></div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start">
								<div id="spc_id" class="dropdown"><!--
								--><button type="button" name="spcName" class="dropdown-toggle" data-toggle="dropdown" data-name="선택" data-value="">선택<span class="caret"></span></button><!--
								--><ul id="spcList" class="dropdown-menu unused center" role="menu"><li data-name="*spcName*" data-value="*spcId*"><a href="javascript:void(0);" tabindex="-1">*spcName*</a></li></ul><!--
								--><small class="hidden warning">SPC를 선택해 주세요.</small>
								</div>

								<!-- <div class="text-input-type mr-12">
									<input type="text" id="spcName" name="spcName" value="" placeholder="입력" class="required" autocomplete="off">
									<input type="hidden" id="spc_id" name="spc_id">
									<small class="hidden warning">SPC를 선택해 주세요</small>
								</div> -->
								<!-- <button type="button" class="btn-type">검색</button> -->
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label asterisk">알림 항목</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start">
								<div class="dropdown placeholder" id="job_type">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="6"><a href="javascript:void(0);">이자 지급일</a></li>
										<li data-value="7"><a href="javascript:void(0);">보장발전시간 정산일</a></li>
										<li data-value="8"><a href="javascript:void(0);">보험 갱신일</a></li>
										<li data-value="9"><a href="javascript:void(0);">보험 납부일</a></li>
										<li data-value="10"><a href="javascript:void(0);">임대료 지급일</a></li>
										<li data-value="11"><a href="javascript:void(0);">대리기관 수수료 지급일</a></li>
										<li data-value="12"><a href="javascript:void(0);">대출상환 만기일</a></li>
<!--
										<li data-value="1"><a href="javascript:void(0);">출금-승인 완료</a></li>
										<li data-value="2"><a href="javascript:void(0);">출금-승인중</a></li>
										<li data-value="3"><a href="javascript:void(0);">입급</a></li>
										<li data-value="4"><a href="javascript:void(0);">입급</a></li>
-->
									</ul>
									<small class="hidden warning">항목을 선택해 주세요</small>
								</div>
							</div>
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label asterisk">알림 주기</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start3">
								<div id="repeat_yn" class="dropdown w-100">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="Y"><a href="javascript:void(0);">정기 알림</a></li>
										<li data-value="N"><a href="javascript:void(0);">일시 알림</a></li>
									</ul>
								</div>
								<div class="text-input-type ml-12 hidden">
									<input type="text" id="repeat_interval" name="repeat_interval" placeholder="입력" onkeydown="onlyNum(event);" maxlength="2" autocomplete="off">
								</div>
								<div class="dropdown hidden" id="repeat_unit">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="주기">주기<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="year"><a href="javascript:void(0);">년</a></li>
										<li data-value="half_year"><a href="javascript:void(0);">반기</a></li>
										<li data-value="quarter_year"><a href="javascript:void(0);">분기</a></li>
										<li data-value="month"><a href="javascript:void(0);">월</a></li>
										<li data-value="day_of_week"><a href="javascript:void(0);">주</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div class="row dateField">
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label asterisk">기준 일자</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start">
								<div class="sel-calendar">
									<input type="text" id="job_date" name="job_date" class="sel fromDate required" value="" autocomplete="off" readonly placeholder="기준 일자">
									<small class="hidden warning">기준일을 선택해 주세요</small>
								</div>
							</div>
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label">반복 종료일</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start">
								<div class="text-input-type w-100">
									<input type="text" id="repeat_end" name="repeat_end" class="required toDate w-100" placeholder="반복 종료일" value="" readonly>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label asterisk">공휴일 처리</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start">
								<div class="dropdown placeholder" id="repeat_before_after_holiday">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="N"><a href="javascript:void(0);">처리 안함</a></li>
										<li data-value="B"><a href="javascript:void(0);">공휴일 직전 영업일</a></li>
										<li data-value="A"><a href="javascript:void(0);">공휴일 직후 영업일</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label">내용</span>
							</div>
							<div class="col-lg-10 col-md-10 col-sm-12 flex-start">
								<textarea id="description" class="textarea" name="description" placeholder="입력"></textarea>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label">담당자</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start">
								<div class="text-input-type">
									<input type="text" id="worker" name="worker" placeholder="입력" maxlength="10">
									<small class="hidden warning">담당자를 선택해 주세요</small>
								</div>
							</div>
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label">비고</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start">
								<div class="text-input-type w-100">
									<input type="text" id="note" name="note" placeholder="입력" maxlength="50">
								</div>
							</div>
						</div>
						<div class="row end">
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label">알림 설정</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start2">
								<div class="dropdown mr-12" id="alarmSetup">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="알림 없음">알림 없음<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value=""><a href="javascript:void(0);">알림 없음</a></li>
										<li data-value="1"><a href="javascript:void(0);">1일 전</a></li>
										<li data-value="3"><a href="javascript:void(0);">3일 전</a></li>
										<li data-value="7"><a href="javascript:void(0);">7일 전</a></li>
										<li data-value="직접 설정"><a href="javascript:void(0);">직접 설정</a></li>
									</ul>
								</div>
								<div class="sel-calendar">
									<input type="text" id="alarmDate" name="alarmDate" class="sel disabled" value="" autocomplete="off" readonly>
								</div>
							</div>
							<div class="col-lg-2 col-md-2 col-sm-12">
								<span class="input-label">알림 시간</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-12 flex-start2">
								<div class="dropdown placeholder mr-12" id="alarmTime">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="시간"><span class="caret"></span></button>
									<ul class="dropdown-menu">
										<c:forEach var="time" begin="0" end="23">
											<li data-value="${time}"><a href="javascript:void(0);">${time}시</a></li>
										</c:forEach>
									</ul>
								</div>
								<div class="text-input-type">
									<input type="text" id="alarmPhone" name="alarmPhone" placeholder="수신 번호" maxlength="12" onkeydown="onlyNum(event)">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" id="deleteScheduleBtn" class="btn-type04 fl hidden">삭제</button>
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="button" id="postScheduleBtn" class="btn-type">등록</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-3 col-md-4 col-sm-12 search-left">
		<div class="indiv">
			<div class="flex-wrapper">
				<h2 class="ntit">입출금 상태</h2>
			</div>
			<div class="search-input-wrapper narrow">
				<div class="chk-type c1">
					<input type="checkbox" id="chk_op01" name="type" value="1" checked>
					<label for="chk_op01">출금 - 승인 완료</label>
				</div>
				<div class="chk-type c2">
					<input type="checkbox" id="chk_op02" name="type" value="2" checked>
					<label for="chk_op02">출금 - 승인 대기</label>
				</div>
				<div class="chk-type c3">
					<input type="checkbox" id="chk_op03" name="type" value="3" checked>
					<label for="chk_op03">출금 - 승인 중</label>
				</div>
				<div class="chk-type c4">
					<input type="checkbox" id="chk_op04" name="type" value="4" checked>
					<label for="chk_op04">출금 - 가승인</label>
				</div>
				<div class="chk-type c5">
					<input type="checkbox" id="chk_op05" name="type" value="5" checked>
					<label for="chk_op05">출금 - 최종승인</label>
				</div>
				<div class="chk-type c13">
					<input type="checkbox" id="chk_op13" name="type" value="13" checked>
					<label for="chk_op13">출금 - 임시저장</label>
				</div>

				<div class="flex-wrapper mt-40">
					<h2 class="ntit">주요 일정</h2>
					<button type="button" id="addAlarmBtn" class="btn-add">알림 등록</button>
				</div>

				<div class="chk-type c6">
					<input type="checkbox" id="chk_op06" name="type" value="6" checked>
					<label for="chk_op06">이자 지급일</label>
				</div>
				<div class="chk-type c7">
					<input type="checkbox" id="chk_op07" name="type" value="7" checked>
					<label for="chk_op07">보장발전시간 정산일</label>
				</div>
				<div class="chk-type c8">
					<input type="checkbox" id="chk_op08" name="type" value="8" checked>
					<label for="chk_op08">보험 갱신일</label>
				</div>
				<div class="chk-type c9">
					<input type="checkbox" id="chk_op09" name="type" value="9" checked>
					<label for="chk_op09">보험 납부일</label>
				</div>
				<div class="chk-type c10">
					<input type="checkbox" id="chk_op10" name="type" value="10" checked>
					<label for="chk_op10">임대료 지급일</label>
				</div>
				<div class="chk-type c11">
					<input type="checkbox" id="chk_op11" name="type" value="11" checked>
					<label for="chk_op11">대리기관수수료 지급일</label>
				</div>
				<div class="chk-type c12">
					<input type="checkbox" id="chk_op12" name="type" value="12" checked>
					<label for="chk_op12">대출상환 만기일</label>
				</div>
			</div>
			<div class="search-input-wrapper flex-wrapper">
				<h2 class="ntit">SPC</h2>
				<span class="desc">spc 이름을 입력해 주세요.</span>
			</div>
			<div class="text-input-type"><input type="text" id="searchName" name="searchName" placeholder="입력"></div>
		</div>
	</div>
	<div class="col-lg-9 col-md-8 col-sm-12">
		<div class="indiv indiv-type">
			<div class="schedule_area">
				<div class="search-top-info clear">
					<div class="fl search-btn"><!--
					--><button type="button" class="btn-type03 active">오늘</button><!--
					--><button type="button" class="btn-prev-month">prev</button><!--
					--><button type="button" class="btn-next-month">next</button><!--
					--><button type="button" id="detailModalTrigger" class="btn-type03" onclick="$('#detailInfoModal').toggleClass('active'); if ($('#dateEtcModal').hasClass('active')) { $('#dateEtcModal').removeClass('active'); }"></button><!--
				--></div>
					<div id="detailInfoModal" class="dropdown-modal modal-dialog calendar-modal">
						<div class="modal-content spc-detail-content">
							<div class="modal-header">
								<h2 id="modalTitle" class="fl"></h2>
								<!-- <a href="#" class="btn-type02 fr">상세보기</a> -->
							</div>
							<div class="modal-body">
								<ul class="alarm-list"></ul>
							</div>
							<div class="btn-wrap-type05">
								<button type="button" id="confirmBtn" class="btn-type" data-dismiss="modal" data-target="#detailInfoModal">확인</button>
							</div>
						</div>
					</div>
					<div id="dateEtcModal" class="dropdown-modal modal-dialog calendar-modal">
						<div class="modal-content spc-detail-content">
							<div class="modal-header">
								<h2 id="dateEtcTitle" class="fl"></h2>
								<!-- <a href="#" class="btn-type02 fr">상세보기</a> -->
							</div>
							<div class="modal-body">
								<ul class="alarm-list"></ul>
							</div>
							<div class="btn-wrap-type05">
								<button type="button" id="dateEtcBtn" class="btn-type" data-dismiss="modal" data-target="#dateEtcModal">확인</button>
							</div>
						</div>
					</div>
					<div class="btn-wrap-type02 btn-wrap-fixed"><!--
					--><a href="/spc/transactionHistory.do" class="btn btn-type03 mr-12" id="writeBtn">입출금 관리 내역</a><!--
					--><a href="/spc/withdrawReqWrite.do" class="btn btn-type" id="requestBtn">출금 요청서 신청</a><!--
					--><a href="/spc/withdrawReqStatus.do" class="btn btn-type" id="requestBtnReview">출금 요청서 목록</a><!--
					--></div>
				</div>
				<div class="search-bottom-wrapper">
					<table id="calendar">
						<thead>
							<tr>
								<th>일</th>
								<th>월</th>
								<th>화</th>
								<th>수</th>
								<th>목</th>
								<th>금</th>
								<th>토</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>