<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let today = new Date();
	let date = new Date();

	$(function () {
		pageInit();

		//날짜 셀렉트박스 클릭 시
		$('.search-select-wrapper ul li').on('click', function () {
			var thisVal = $(this).data('value');
			var thisId = $(this).parent().parent().attr('id');
			
			if (thisId == 'year') {
				today = new Date(thisVal, today.getMonth(), today.getDate());
			} else {
				today = new Date(today.getFullYear(), thisVal - 1, today.getDate());
			}
			buildCalendar();
		});

		//전월
		$('.btn-prev-month').on('click', function () {
			today = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
			buildCalendar();
		});

		//다음월
		$('.btn-next-month').on('click', function () {
			today = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
			buildCalendar();
		});

		//요번달
		$('.btn-type03.active').on('click', function () {
			today = new Date();
			buildCalendar();
		});

		$('#register').on('click', function () {
			modalPopInit();
		});

		$('#repeat_interval, #repeat_unit').on('click change', function () {
			repeatEnd();
		});

		$('[name="siteName"]').autocomplete({
			source: function (request, response) {
				$.ajax({
					url: apiHost + '/auth/me/sites',
					dataType: 'json',
					type: "get",
					success: function (data) {
						response(
							$.map(data, function (item) {
								let siteNm = $('[name="siteName"]').val().toUpperCase();
								if ((item.name.toUpperCase()).match(siteNm)) {
									return {
										label: item.name,
										value: item.sid
									}
								}
							})
						);
					}
				});
			},
			minLength: 1,
			autoFocus: true,
			classes: {
				'ui-autocomplete': 'highlight'
			},
			select: function (evnet, ui) {
				evnet.preventDefault();
				$('[name="siteName"]').val(ui.item.label);
				$('[name="site_id"]').val(ui.item.value);
			},
			focus: function (evnet, ui) {
				evnet.preventDefault();
				$('[name="siteName"]').val(ui.item.label);
				$('[name="site_id"]').val(ui.item.value);
			},
			delay: 500
		});

		$(':checkbox[name="type"]').on('change', function () {
			checkCalendarVisual();
		});

		$('#searchName').on('keyup', function () {
			checkCalendarVisual();
		});
	});

	//기본세팅
	const monthArray = [
		'<fmt:message key="spc.schedule.month.1" />',
		'<fmt:message key="spc.schedule.month.2" />',
		'<fmt:message key="spc.schedule.month.3" />',
		'<fmt:message key="spc.schedule.month.4" />',
		'<fmt:message key="spc.schedule.month.5" />',
		'<fmt:message key="spc.schedule.month.6" />',
		'<fmt:message key="spc.schedule.month.7" />',
		'<fmt:message key="spc.schedule.month.8" />',
		'<fmt:message key="spc.schedule.month.9" />',
		'<fmt:message key="spc.schedule.month.10" />',
		'<fmt:message key="spc.schedule.month.11" />',
		'<fmt:message key="spc.schedule.month.12" />',
	]

	const pageInit = function () {
		let html = '';
		let year = today.getFullYear();
		let month = today.getMonth() + 1;

		$('#datepicker1').datepicker('setDate', 'today');
		$('#year > button').html(year + '<span class="caret"></span>').data('value', year);
		$('#month > button').html(monthArray[month - 1] + '<span class="caret"></span>').data('value', month);

		let bfYear = new Date(year + 1, month + 1);
		html += '<li data-value="' + bfYear.getFullYear() + '"><a href="javascript:void(0);">' + bfYear.getFullYear() + ' </a></li>';

		for (let i = 0; i < 5; i++) {
			let bfYear = new Date(year - i, month + 1);
			let select = i == 0 ? 'on' : '';
			html += '<li data-value="' + bfYear.getFullYear() + '" class="' + select + '"><a href="javascript:void(0);">' + bfYear.getFullYear() + ' </a></li>';
		}

		$('#year ul').empty().append(html);

		buildCalendar();
	};

	//달력 그리기
	const buildCalendar = function () { //현재 달 달력 만들기
		let doMonth = new Date(today.getFullYear(), today.getMonth(), 1);
		let lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0);
		let tbCalendar = document.getElementById('calendar');

		while (tbCalendar.rows.length > 1) {
			tbCalendar.deleteRow(tbCalendar.rows.length - 1);
		}

		let row = tbCalendar.insertRow();
		let cell = null;
		let cnt = 0;
		for (let i = 0; i < doMonth.getDay(); i++) {
			cell = row.insertCell();
			cnt = cnt + 1;
		}

		for (let i = 1; i <= lastDate.getDate(); i++) {
			cell = row.insertCell();
			cell.innerHTML = '<span class="date" data-day="' + doMonth.format('yyyyMM') + i + '">' + i;
			cnt = cnt + 1;

			if (cnt % 7 == 0) {
				row = calendar.insertRow();
			}
			/*오늘의 날짜에 노란색 칠하기*/
			if (today.getFullYear() == date.getFullYear() &&
				today.getMonth() == date.getMonth() &&
				i == date.getDate()) {
				cell.setAttribute('class', 'today');
			}
		}

		$('.search-btn > strong').html(monthArray[doMonth.getMonth()]);
		$('#year > button').html(doMonth.getFullYear() + '<span class="caret"></span>').data('value', doMonth.getFullYear());
		$('#month > button').html(monthArray[doMonth.getMonth()] + '<span class="caret"></span>').data('value', doMonth.getMonth() + 1);

		maintenance('get');
	};

	/**
	 * 등록/수정/삭제 처리
	 *
	 * @param action
	 * @param jobId
	 * @returns {boolean}
	 */
	const maintenance = function (action, jobId, cascade) {
		let option = {};
		if (action === 'post' || action === 'patch') {
			let data = setData();
			if (isEmpty(data['site_id'])) {
				alert('<fmt:message key="spc.schedule.alert.1" />');
				return false;
			}

			if (isEmpty(data['job_type'])) {
				alert('<fmt:message key="spc.schedule.alert.2" />');
				return false;
			}

			if (isEmpty(data['job_date'])) {
				alert('<fmt:message key="spc.schedule.alert.3" />');
				return false;
			}

			if (isEmpty(data['repeat_yn'])) {
				alert('<fmt:message key="spc.schedule.alert.4" />');
				return false;
			} else {
				if (data['repeat_yn'] == 'Y') {
					if (isEmpty(data['repeat_interval'])) {
						alert('<fmt:message key="spc.schedule.alert.5" />');
						return false;
					}

					if (isEmpty(data['repeat_unit'])) {
						alert('<fmt:message key="spc.schedule.alert.6" />');
						return false;
					}

					if (isEmpty(data['repeat_end'])) {
						alert('<fmt:message key="spc.schedule.alert.7" />');
						return false;
					}
				}
			}

			if (isEmpty(data['repeat_before_after_holiday'])) {
				alert('<fmt:message key="spc.schedule.alert.8" />');
				return false;
			}

			let job_info = JSON.parse(data['job_info']);
			if (!isEmpty(job_info['alarmSetup'])) {

				if (isEmpty(job_info['alarmDate'])) {
					alert('<fmt:message key="spc.schedule.alert.9" />');
					return false;
				}

				if (isEmpty(job_info['alarmTime'])) {
					alert('<fmt:message key="spc.schedule.alert.10" />');
					return false;
				}

				if (isEmpty(job_info['alarmPhone'])) {
					alert('<fmt:message key="spc.schedule.alert.11" />');
					return false;
				}
			}

			let jobText = jobId == undefined ? '' : '&jobId=' + jobId;
			let url = '';
			if (action === 'patch') {
				if (!confirm('<fmt:message key="spc.schedule.confirm.1" />')) {
					return false;
				}

				url = apiHost + '/spcs/maintenance/' + jobId + '?oid=' + oid + jobText;
				delete data.site_id;
			} else {
				url = apiHost + '/spcs/maintenance?oid=' + oid;
			}

			option = {
				url: url,
				dataType: 'json',
				type: action,
				contentType: "application/json",
				traditional: true,
				data: JSON.stringify(data)
			};
		} else if (action === 'get') {
			option = {
				url: apiHost + '/spcs/maintenance',
				type: action,
				dataType: 'json',
				data: {
					oid: oid,
					like_yyyymm: $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2)
				}
			};

			if (jobId !== undefined) {
				option.data.jobId = jobId;
			}
		} else {
			//다중 삭제 처리 하는 부분
			//cascade 0: 반복삭제안함, 1: 반복 전체 삭제, 2: 이후 반복만 삭제
			if (isEmpty(cascade)) {
				cascade = 0;
			} else {
				$('#confirmModal').modal('hide');
			}

			option = {
				url: apiHost + '/spcs/maintenance/' + jobId + '?oid=' + oid + '&cascade=' + cascade,
				type: action
			};
		}

		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if (action === 'get') {
				if (jobId !== undefined) {
					modalPopInit(data.data);
				} else {
					checkCalendar(data.data);
					checkCalendarVisual();
				}
			} else {
				maintenance('get');
				$('#registerModal').modal('hide');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			if (textStatus !== 'canceled') {
				alert('<fmt:message key="spc.schedule.alert.12" />');
				return false;
			}
		});
	};

	/**
	 * 삭제시에 반복 확인 체크
	 */
	const repeatConfirm = (jobId, repeatYN) => {
		let modal = $('#comDeleteModal');
		let deleteBtn = $('#comDeleteBtn');
		let confirmTitle = $('#confirmTitle');

		$('#comDeleteSuccessMsg span').text('삭제');
		modal.find('.modal-body').removeClass('hidden');
		modal.modal('show');

		confirmTitle.on('input keyp', function() {
			if($(this).val() !== '삭제') {
				deleteBtn.prop('disabled', true);
				return false
			} else {
				deleteBtn.prop('disabled', false).data('jobId', jobId).data('repeatYN', repeatYN);
			}
		});
	}

	$(document).on('click', '#comDeleteBtn', function() {
		const jobId = $(this).data('jobId')
			, repeatYN = $(this).data('repeatYN');

		$(this).removeClass('jobId');
		$(this).removeClass('repeatYN');

		$('#comDeleteModal').modal('hide');
		$('#confirmTitle').val('');

		if (repeatYN === 'Y') {
			let confirmBtn = $('#confirmModal button');
			confirmBtn.eq(0).attr('onclick', 'maintenance(\'delete\', \'' + jobId + '\', \'0\')');
			confirmBtn.eq(1).attr('onclick', 'maintenance(\'delete\', \'' + jobId + '\', \'1\')');
			$('#confirmModal').modal('show');
		} else {
			maintenance('delete', jobId);
		}
	});

	//등록&수정 용 데이터 세팅
	const setData = function () {
		let jsonData = {};
		let job_info = {};
		let job_info_Array = ['worker', 'note', 'description', 'alarmDate', 'alarmTime', 'alarmPhone', 'alarmSetup'];

		$('#registerModal input, textarea').each(function () {
			if ($.inArray($(this).prop('name'), job_info_Array) > -1) {
				job_info[$(this).prop('name')] = String($(this).val());
			} else {
				if ($(this).hasClass('hasDatepicker')) {
					let pickedDate = $(this).datepicker('getDate');
					if (pickedDate != null) {
						jsonData[$(this).prop('name')] = pickedDate.toISOString();
					}
				} else {
					jsonData[$(this).prop('name')] = $(this).val();
				}
			}
		});

		$('#registerModal .dropdown-toggle').each(function () {
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

		job_info.siteName = jsonData.siteName;
		jsonData.job_info = JSON.stringify(job_info);
		jsonData.repeat_interval = Number(jsonData.repeat_interval);
		jsonData.updated_by = loginId;
		delete jsonData.siteName;

		return jsonData;
	};

	//달력에 그린다.
	const checkCalendar = function (data) {
		let calendar = $('#calendar .date');
		$('#calendar td a').remove();

		const checkType = $.makeArray($(':checkbox[name="type"]:checked').map(
			function () {
				return $(this).val();
			}
		));
		const jobName = [
			'<fmt:message key="spc.schedule.type.1" />',
			'<fmt:message key="spc.schedule.type.2" />',
			'<fmt:message key="spc.schedule.type.3" />',
			'<fmt:message key="spc.schedule.type.4" />',
			'<fmt:message key="spc.schedule.type.5" />',
			'<fmt:message key="spc.schedule.type.6" />',
			'<fmt:message key="spc.schedule.type.7" />',
			'<fmt:message key="spc.schedule.type.8" />',
			'<fmt:message key="spc.schedule.type.9" />',
			'<fmt:message key="spc.schedule.type.10" />',
			'<fmt:message key="spc.schedule.type.11" />',
			'<fmt:message key="spc.schedule.type.12" />',
			'<fmt:message key="spc.schedule.type.13" />',
			'<fmt:message key="spc.schedule.type.14" />',
		];
		if (data.length > 0) {
			data.forEach(function (v, k) {
				let job_date = new Date(v.job_date).format('dd');
				let job_type = v.job_type;
				let sid = v.site_id;
				let job_info = JSON.parse(v.job_info);

				let visual = 'hidden';
				if ($.inArray(job_type, checkType) > -1) { visual = ''; }
				calendar.eq(Number(job_date) - 1).append(`<a href="javascript:maintenance('get', '${'${v.id}'}')" data-jobid="${'${v.id}'}" class="${'${visual}'}"><p class="bu t${'${job_type}'}" data-sitename="${'${job_info.siteName}'}">[${'${job_info.siteName}'}] ${'${jobName[Number(job_type) - 1]}'}</p></a>`);
			});
		}

	};

	const checkCalendarVisual = function () {
		const checkType = $.makeArray($(':checkbox[name="type"]:checked').map(
			function () {
				return $(this).val();
			}
		));

		$('#calendar td a p.bu').each(function () {
			let clsName = $(this).attr('class').replace('bu t', '').trim();
			let siteName = $(this).data('sitename');
			if ($.inArray(clsName, checkType) > -1) {
				if ($('#searchName').val() == '') {
					$(this).parent().removeClass('hidden');
				} else {
					if (siteName.match($('#searchName').val())) {
						$(this).parent().removeClass('hidden');
					} else {
						$(this).parent().addClass('hidden');
					}
				}
			} else {
				$(this).parent().addClass('hidden');;
			}
		});
	};

	const modalPopInit = function (data) {
		const modal = $('#registerModal');
		const title = modal.find('h2');
		const input = modal.find('input');
		const textarea = modal.find('textarea');
		const dropDown = modal.find('.dropdown-toggle');
		const repeat_wrapper = $('#repeat_yn').parents('.flex-start3');
		const repeat_cycle = $('#repeat_yn button');
		const addScheduleBtn = $('#addScheduleBtn');
		const deleteScheduleBtn = $('#deleteScheduleBtn');

		repeat_cycle.data('value', '');
		repeat_cycle.parents('div.dropdown').siblings().addClass('hidden');
		repeat_wrapper.removeClass("short");
		$('#repeat_end').val('').datepicker('destroy').removeClass('sel');
		$('#repeat_end').parent().removeClass('sel-calendar').addClass('text-input-type');

		if (data == undefined) {
			title.contents().get(0).nodeValue = '<fmt:message key="spc.schedule.register.title" />';
			//팝업 오픈시 value 초기화
			input.each(function () {
				$(this).val('');
			});
			//팝업 오픈시 value 초기화
			textarea.val('');

			dropDown.each(function () {
				$(this).data('value', '').html($(this).data('name') + '<span class="caret"></span>');
			});

			$('#alarmPhone').val(contact_phone);
			deleteScheduleBtn.addClass('hidden');
			addScheduleBtn.attr('onclick', 'maintenance(\'post\');').text('등록');
		} else {
			title.contents().get(0).nodeValue = '점검계획 수정';
			setJsonAutoMapping(data[0], 'registerModal');
			setJsonAutoMapping(JSON.parse(data[0].job_info), 'registerModal');

			let jobDate = new Date(data[0].job_date);
			$('#job_date').datepicker('setDate', jobDate);

			let repeatEnd = new Date(data[0].repeat_end);
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
						if (fromDate != null) {
							$(this).datepicker('option', 'minDate', fromDate.format('yyyy-MM-dd'));
						}
					},
					onClose: function (selected) {
						$(this).closest('.dateField').find('.fromDate').datepicker('option', 'maxDate', selected);
					}
				});
			}

			deleteScheduleBtn.removeClass('hidden').attr('onclick', 'repeatConfirm(\'' + data[0].id + '\', \'' + data[0].repeat_yn + '\');');
			addScheduleBtn.attr('onclick', 'maintenance(\'patch\', \'' + data[0].id + '\' );').text('수정');
		}

		modal.modal();
	}

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

		if (isEmpty($('#alarmSetup button').data('value'))) {
			$('#alarmDate').val('');
		} else if ($('#alarmSetup button').data('value') != '직접 설정') {
			selectedDate.setDate(selectedDate.getDate() - Number($('#alarmSetup button').data('value')));
			$('#alarmDate').val(selectedDate.format('yyyy-MM-dd'));
		}
	}

	const afterDatePick = function (inputName) {
		if(inputName == 'job_date') {
			rtnDropdown('alarmSetup');
		} else {
			repeatEnd();
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
</script>

<div class="modal fade" id="registerModal" tabindex="-1" role="form" aria-labelledby="myModalLabel">
	<div class="modal-dialog spc-modal-lg" role="modal">
		<div class="modal-content spc-modal-content full-width">
			<div class="modal-header">
				<h2><fmt:message key="spc.schedule.register.title" /><span class="required fr"><fmt:message key="required" /></span></h2>
			</div>
			<div class="modal-body">
				<div class="container-fluid">
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3"><span class="input-label asterisk"><fmt:message key="spc.schedule.register.plant" /></span></div>
						<div class="col-lg-5 col-md-5 col-sm-9 flex-start">
							<div class="text-input-type mr-12">
								<input type="text" id="siteName" name="siteName" placeholder="<fmt:message key='spc.schedule.register.input' />" class="required" autocomplete="off">
								<input type="hidden" id="site_id" name="site_id">
							</div>
							<button type="submit" class="btn-type"><fmt:message key="button.search" /></button>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label asterisk"><fmt:message key="spc.schedule.register.type" /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
							<div class="dropdown placeholder" id="job_type">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='button.select' />"><fmt:message key='button.select' /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="1"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.1" /></a></li>
									<li data-value="2"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.2" /></a></li>
									<li data-value="3"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.3" /></a></li>
									<li data-value="4"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.4" /></a></li>
									<li data-value="5"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.5" /></a></li>
									<li data-value="6"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.6" /></a></li>
									<li data-value="7"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.7" /></a></li>
									<li data-value="8"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.8" /></a></li>
									<li data-value="9"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.9" /></a></li>
									<li data-value="10"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.10" /></a></li>
									<li data-value="11"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.11" /></a></li>
									<li data-value="12"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.12" /></a></li>
									<li data-value="13"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.13" /></a></li>
									<li data-value="14"><a href="javascript:void(0);"><fmt:message key="spc.schedule.type.14" /></a></li>
								</ul>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label asterisk"><fmt:message key="spc.schedule.register.interval" /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start3">
							<div id="repeat_yn" class="dropdown w-100">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='button.select' />"><fmt:message key='button.select' /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="Y"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.interval.1" /></a></li>
									<li data-value="N"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.interval.2" /></a></li>
								</ul>
							</div>
							<div class="text-input-type ml-12 hidden">
								<input type="text" id="repeat_interval" name="repeat_interval" placeholder="<fmt:message key='spc.schedule.register.input' />" onkeydown="onlyNum(event);" maxlength="2" autocomplete="off">
							</div>
							<div class="dropdown hidden" id="repeat_unit">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='spc.schedule.register.interval.unit' />"><fmt:message key='spc.schedule.register.interval.unit' /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="year"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.interval.3" /></a></li>
									<li data-value="half_year"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.interval.4" /></a></li>
									<li data-value="quarter_year"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.interval.5" /></a></li>
									<li data-value="month"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.interval.6" /></a></li>
									<li data-value="day_of_week"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.interval.7" /></a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="row dateField">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label asterisk"><fmt:message key='spc.schedule.register.date' /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
							<div class="sel-calendar">
								<input type="text" id="job_date" name="job_date" class="sel fromDate w-100" placeholder="<fmt:message key='spc.schedule.register.date' />" value="" autocomplete="off" readonly>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label"><fmt:message key='spc.schedule.register.interval.end' /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
							<div class="text-input-type w-100">
								<input type="text" id="repeat_end" name="repeat_end" class="toDate" placeholder="<fmt:message key='spc.schedule.register.interval.end' />" value="" readonly>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label asterisk"><fmt:message key="spc.schedule.register.holiday" /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
							<div class="dropdown placeholder" id="repeat_before_after_holiday">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='button.select' />"><fmt:message key='button.select' /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="N"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.holiday" /></a></li>
									<li data-value="B"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.holiday" /></a></li>
									<li data-value="A"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.holiday" /></a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label"><fmt:message key="spc.schedule.register.content" /></span>
						</div>
						<div class="col-lg-10 col-md-10 col-sm-9 flex-start">
							<textarea class="textarea" id="description" name="description" placeholder="<fmt:message key='spc.schedule.register.input' />"></textarea>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label"><fmt:message key="spc.schedule.register.reporter" /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
							<div class="text-input-type">
								<input type="text" id="worker" name="worker" placeholder="<fmt:message key='spc.schedule.register.input' />" maxlength="10">
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label"><fmt:message key="spc.schedule.register.note" /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
							<div class="text-input-type w-100">
								<input type="text" id="note" name="note" placeholder="<fmt:message key='spc.schedule.register.input' />" maxlength="50">
							</div>
						</div>
					</div>
					<div class="row end">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label"><fmt:message key="spc.schedule.register.setAlarm" /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start2">
							<div class="dropdown mr-12" id="alarmSetup">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='spc.schedule.register.setAlarm.1' />"><fmt:message key="spc.schedule.register.setAlarm.1" /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value=""><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.setAlarm.1" /></a></li>
									<li data-value="1"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.setAlarm.2" /></a></li>
									<li data-value="3"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.setAlarm.3" /></a></li>
									<li data-value="7"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.setAlarm.4" /></a></li>
									<li data-value="직접 설정"><a href="javascript:void(0);"><fmt:message key="spc.schedule.register.setAlarm.5" /></a></li>
								</ul>
							</div>
							<div class="sel-calendar">
								<input type="text" id="alarmDate" name="alarmDate" class="sel disabled" value="" autocomplete="off" readonly>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input-label"><fmt:message key="spc.schedule.register.time" /></span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex-start2">
							<div class="dropdown placeholder mr-12" id="alarmTime">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='spc.schedule.register.time.1' />"><fmt:message key="spc.schedule.register.time.1" /><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="0"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.0' /></a></li>
									<li data-value="1"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.1' /></a></li>
									<li data-value="2"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.2' /></a></li>
									<li data-value="3"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.3' /></a></li>
									<li data-value="4"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.4' /></a></li>
									<li data-value="5"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.5' /></a></li>
									<li data-value="6"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.6' /></a></li>
									<li data-value="7"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.7' /></a></li>
									<li data-value="8"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.8' /></a></li>
									<li data-value="9"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.9' /></a></li>
									<li data-value="10"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.10' /></a></li>
									<li data-value="11"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.11' /></a></li>
									<li data-value="12"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.12' /></a></li>
									<li data-value="13"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.13' /></a></li>
									<li data-value="14"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.14' /></a></li>
									<li data-value="15"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.15' /></a></li>
									<li data-value="16"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.16' /></a></li>
									<li data-value="17"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.17' /></a></li>
									<li data-value="18"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.18' /></a></li>
									<li data-value="19"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.19' /></a></li>
									<li data-value="20"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.20' /></a></li>
									<li data-value="21"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.21' /></a></li>
									<li data-value="22"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.22' /></a></li>
									<li data-value="23"><a href="javascript:void(0);"><fmt:message key='spc.schedule.register.time.23' /></a></li>
								</ul>
							</div>
							<div class="text-input-type w-100">
								<input type="text" id="alarmPhone" name="alarmPhone" placeholder="<fmt:message key='spc.schedule.register.time.num' />" maxlength="12" onkeydown="onlyNum(event)">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12 end">
							<div class="btn-wrap-type02">
								<button type="button" id="deleteScheduleBtn" class="btn-type04 hidden"><fmt:message key="button.delete" /></button>
								<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key="button.cancel" /></button>
								<button type="button" id="addScheduleBtn" class="btn-type"><fmt:message key="button.register" /></button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header"><fmt:message key="spc.schedule.title" /></h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-2 clear">
		<div class="search-select-wrapper">
			<div class="search-select-item">
				<div class="dropdown" id="year">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown">
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="javascript:void(0);">2020</a></li>
						<li><a href="javascript:void(0);">2019</a></li>
						<li><a href="javascript:void(0);">2018</a></li>
					</ul>
				</div>
			</div>
			<div class="search-select-item">
				<div class="dropdown" id="month">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown">
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li data-value="1"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.1" /></a></li>
						<li data-value="2"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.2" /></a></li>
						<li data-value="3"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.3" /></a></li>
						<li data-value="4"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.4" /></a></li>
						<li data-value="5"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.5" /></a></li>
						<li data-value="6"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.6" /></a></li>
						<li data-value="7"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.7" /></a></li>
						<li data-value="8"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.8" /></a></li>
						<li data-value="9"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.9" /></a></li>
						<li data-value="10"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.10" /></a></li>
						<li data-value="11"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.11" /></a></li>
						<li data-value="12"><a href="javascript:void(0);"><fmt:message key="spc.schedule.month.12" /></a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-2 col-md-3 col-sm-4 search-left">
		<div class="indiv">
			<h2 class="ntit"><fmt:message key="spc.schedule.type" /></h2>
			<div class="search-input-wrapper">
				<div class="chk-type c1">
					<input type="checkbox" id="chk_op01" name="type" value="1" checked>
					<label for="chk_op01"><fmt:message key="spc.schedule.type.1" /></label>
				</div>
				<div class="chk-type c2">
					<input type="checkbox" id="chk_op02" name="type" value="2" checked>
					<label for="chk_op02"><fmt:message key="spc.schedule.type.2" /></label>
				</div>
				<div class="chk-type c3">
					<input type="checkbox" id="chk_op03" name="type" value="3" checked>
					<label for="chk_op03"><fmt:message key="spc.schedule.type.3" /></label>
				</div>
				<div class="chk-type c4">
					<input type="checkbox" id="chk_op04" name="type" value="4" checked>
					<label for="chk_op04"><fmt:message key="spc.schedule.type.4" /></label>
				</div>
				<div class="chk-type c5">
					<input type="checkbox" id="chk_op05" name="type" value="5" checked>
					<label for="chk_op05"><fmt:message key="spc.schedule.type.5" /></label>
				</div>
				<div class="chk-type c6">
					<input type="checkbox" id="chk_op06" name="type" value="6" checked>
					<label for="chk_op06"><fmt:message key="spc.schedule.type.6" /></label>
				</div>
				<div class="chk-type c7">
					<input type="checkbox" id="chk_op07" name="type" value="7" checked>
					<label for="chk_op07"><fmt:message key="spc.schedule.type.7" /></label>
				</div>
				<div class="chk-type c8">
					<input type="checkbox" id="chk_op08" name="type" value="8" checked>
					<label for="chk_op08"><fmt:message key="spc.schedule.type.8" /></label>
				</div>
				<div class="chk-type c9">
					<input type="checkbox" id="chk_op09" name="type" value="9" checked>
					<label for="chk_op09"><fmt:message key="spc.schedule.type.9" /></label>
				</div>
				<div class="chk-type c10">
					<input type="checkbox" id="chk_op10" name="type" value="10" checked>
					<label for="chk_op10"><fmt:message key="spc.schedule.type.10" /></label>
				</div>
				<div class="chk-type c11">
					<input type="checkbox" id="chk_op11" name="type" value="11" checked>
					<label for="chk_op11"><fmt:message key="spc.schedule.type.11" /></label>
				</div>
				<div class="chk-type c12">
					<input type="checkbox" id="chk_op12" name="type" value="12" checked>
					<label for="chk_op12"><fmt:message key="spc.schedule.type.12" /></label>
				</div>
				<div class="chk-type c13">
					<input type="checkbox" id="chk_op13" name="type" value="13" checked>
					<label for="chk_op13"><fmt:message key="spc.schedule.type.13" /></label>
				</div>
				<div class="chk-type c14">
					<input type="checkbox" id="chk_op14" name="type" value="14" checked>
					<label for="chk_op14"><fmt:message key="spc.schedule.type.14" /></label>
				</div>
			</div>

			<h2 class="ntit"><fmt:message key='spc.schedule.plant' /></h2>
			<div class="text-input-type">
				<input type="text" id="searchName" name="searchName" placeholder="<fmt:message key='spc.schedule.search' />">
			</div>
		</div>
	</div>
	<div class="col-lg-10 col-md-9 col-sm-8">
		<div class="indiv indiv-type">
			<div class="schedule_area">
				<div class="search-top-info clear">
					<div class="search-btn fl">
						<button type="button" class="btn-type03 active"><fmt:message key="spc.schedule.today" /></button>
						<button type="button" class="btn-prev-month">prev</button>
						<button type="button" class="btn-next-month">next</button>
						<strong></strong>
					</div>
					<a href="javascript:void(0);" class="btn-type fr" id="register"><fmt:message key="button.create" /></a>
					<!--<a href="/spc/maintenanceSchedulePost.do" class="btn-type fr">등록</a>-->
				</div>
				<div class="search-bottom-wrapper">
					<table id="calendar">
						<colgroup>
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col>
						</colgroup>
						<thead>
						<tr>
							<th><fmt:message key="spc.schedule.calendar.1" /></th>
							<th><fmt:message key="spc.schedule.calendar.2" /></th>
							<th><fmt:message key="spc.schedule.calendar.3" /></th>
							<th><fmt:message key="spc.schedule.calendar.4" /></th>
							<th><fmt:message key="spc.schedule.calendar.5" /></th>
							<th><fmt:message key="spc.schedule.calendar.6" /></th>
							<th><fmt:message key="spc.schedule.calendar.7" /></th>
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

<div class="modal stack" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="confirmModal" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content narrow">
			<div class="modal-body">
				<h2>다른 정기 점검 일정도 같이 수정하시겠습니까?</h2>
			</div>
			<div class="modal-footer">
				<div class="btn-wrap-type mb-0">
					<button type="button" class="btn-type03">한건 삭제</button>
					<button type="button" class="btn-type">모두 삭제</button>
				</div>
			</div>
		</div>
	</div>
</div>
