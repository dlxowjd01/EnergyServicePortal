<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	let today = new Date();
	let date = new Date();

	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';

	$(function () {
		// unCheckAll();
		pageInit();
		
		$('#addAlarmBtn').on('click', function () {
			let target = $(this).data("target");
			console.log("detail--", $("#detailInfoModal").attr("class"))
			$("#detailInfoModal").removeClass("active");

			modalPopInit();
		});

		$('#detailModalTrigger').on('click', function () {
			$("#spcAlarmModal").modal("hide");
		});

		// $('.modal').on('show.modal', function(event) {
		// 	console.log("show---", event)
		// });
		// $('.modal').on('hide.modal', function(event) {
		// 	console.log("hide---", event)
		// });


		// TO DO!!!!!
		// 사용자 === 사무수탁사 => show() : writeBtn
		// 사용자 === 자산운영사 => show() : requestBtn
		// 임시로 사무수탁사 버튼
		// oid === "" ? $("#requestBtn").text("출금요청서 신청") : $("#requestBtn").text("출금요청서 작성");

		//날짜 셀렉트박스 클릭 시
		$('.sch_sel_area ul li').on('click', function () {
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
		$('.btn_prev_mon').on('click', function () {
			const prevMonth = today.getMonth() - 1;
			today = new Date(today.getFullYear(), prevMonth, today.getDate());
			$('#modalTitle').text(prevMonth);
			$('#popoverModal').find("h2").text(prevMonth);
			buildCalendar();
		});

		//다음월
		$('.btn_next_mon').on('click', function () {
			const nextMonth = today.getMonth() + 1;
			today = new Date(today.getFullYear(), nextMonth, today.getDate());
			$('#modalTitle').text(nextMonth);
			buildCalendar();
		});

		//요번달
		$('.btn_type03.active').on('click', function () {
			today = new Date();
			buildCalendar();
		});

		$('#spcAlarmModal li').on('click', function () {
			let value = $(this).data('value');
			let buttonId = $(this).parents('div').prop('id');
			$(this).parents('div.dropdown').find('button').data('value', value);

			if (buttonId == 'repeat_yn') {
				if (value == 'Y') {
					$(this).parents('.flex_start3').addClass('short');
					$(this).parents('div.dropdown').siblings().removeClass('hidden');

					$('#repeat_end').addClass('sel').parent().removeClass('tx_inp_type').addClass('sel_calendar');
				} else {
					$(this).parents('.flex_start3').removeClass('short');
					$(this).parents('div.dropdown').siblings().addClass('hidden');

					$('#repeat_end').removeClass('sel').parent().removeClass('sel_calendar').addClass('tx_inp_type');
				}
				repeatEnd();
			} else if (buttonId == 'alarmSetup') {
				if ($('#alarmDate').hasClass('hasDatepicker')) {
					$('#alarmDate').datepicker('destroy').removeClass('hasDatepicker');
				}
				if (value != '직접 설정') {
					let jobDate = $('#job_date').datepicker('getDate');
					if (isEmpty($('#job_date').val())) {
						$('#alarmDate').val('');
					} else {
						jobDate.setDate(jobDate.getDate() - value);
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
					})
					$('#alarmDate').val('');
				}
			}
		});

		$('#repeat_interval, #repeat_unit').on('click change', function () {
			repeatEnd();
		});

		$('#repeat_interval, #repeat_unit').on('click change', function () {
			repeatEnd();
		});

		$('[name="siteName"]').autocomplete({
			source: function (request, response) {
				$.ajax({
					url: 'http://iderms.enertalk.com:8443/auth/me/sites',
					dataType: 'json',
					type: "get",
					success: function (data) {
						response(
							$.map(data, function (item) {
								let siteNm = $('[name="siteName"]').val();
								if (item.name.match(siteNm)) {
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
		
		$('body').click(function() {

		});

		$('#detailModalTrigger').on("click", function(){
			$("#detailInfoModal").toggleClass("active");
		});
		
		$('#confirmBtn').on("click", function(){
			$("#detailInfoModal").toggleClass("active");
		});
	});

	//기본세팅
	const pageInit = function () {
		let html = '';
		let year = today.getFullYear();
		let month = today.getMonth() + 1;

		$('#datepicker1').datepicker('setDate', 'today');
		$('#year > button').html(year + '년<span class="caret"></span>').data('value', year);
		$('#month > button').html(month + '월<span class="caret"></span>').data('value', month);

		for (let i = 0; i < 5; i++) {
			let bfYear = new Date(year - i, month + 1);
			let select = i == 0 ? 'on' : '';
			html += '<li data-value="' + bfYear.getFullYear() + '" class="' + select + '"><a href="#">' + bfYear.getFullYear() + '년 </a></li>';
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
		const thisMonth = doMonth.getMonth() + 1 + '월';

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

		$('.sch_btn .btn_type03:last-of-type').text(thisMonth);
		$('#modalTitle').text(thisMonth);
		$('#year > button').html(doMonth.getFullYear() + '년<span class="caret"></span>').data('value', doMonth.getFullYear());
		$('#month > button').html(doMonth.getMonth() + 1 + '월<span class="caret"></span>').data('value', doMonth.getMonth() + 1);

		maintenance('get');
	};

	const maintenance = function (action, jobId) {
		let option = {};
		if (action == 'post' || action == 'patch') {
			let data = setData();
			let jobText = jobId == undefined ? '' : '&jobId=' + jobId;
			let url = '';
			if (action == 'patch') {
				url = 'http://iderms.enertalk.com:8443/spcs/maintenance/' + jobId + '?oid=' + oid + jobText;
				delete data.site_id;
			} else {
				url = 'http://iderms.enertalk.com:8443/spcs/maintenance?oid=' + oid;
			}

			option = {
				url: url,
				dataType: 'json',
				type: action,
				contentType: "application/json",
				traditional: true,
				data: JSON.stringify(data)
			};
		} else if (action == 'get') {
			option = {
				url: 'http://iderms.enertalk.com:8443/spcs/maintenance',
				type: action,
				dataType: 'json',
				data: {
					oid: oid,
					like_yyyymm: $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2)
				}
			};

			if (jobId != undefined) {
				option.data.jobId = jobId;
			}
		} else {
			let jobText = jobId == undefined ? '' : '&jobId=' + jobId;
			option = {
				url: 'http://iderms.enertalk.com:8443/spcs/maintenance/' + jobId + '?oid=' + oid + jobText,
				type: action,
				data: {
					oid: oid,
					jobId: jobId
				}
			};
		}

		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if (action == 'get') {
				if (jobId != undefined) {
					modalPopInit(data.data);
				} else {
					checkCalendar(data.data);
				}
			} else {
				maintenance('get');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	};

	//등록&수정 용 데이터 세팅
	const setData = function () {
		let jsonData = {};
		let job_info = {};
		let job_info_Array = ['worker', 'note', 'description', 'alarmDate', 'alarmTime', 'alarmPhone', 'alarmSetup'];

		$('#popoverModal input, textarea').each(function () {
			if ($.inArray($(this).prop('name'), job_info_Array) > -1) {
				job_info[$(this).prop('name')] = String($(this).val());
			} else {
				if ($(this).prop('name') == 'job_date') {
					let jobDate = $(this).datepicker('getDate');
					jsonData[$(this).prop('name')] = jobDate.toISOString();
				} else if ($(this).prop('name').match('alarm')) {
					jsonData.job_info[$(this).prop('name')] = String($(this).val());
				} else if ($(this).prop('name') == 'repeat_end') {
					jsonData[$(this).prop('name')] = new Date($(this).val()).toISOString();
				} else {
					jsonData[$(this).prop('name')] = String($(this).val());
				}
			}
		});

		$('#popoverModal button.btn-primary').each(function () {
			if ($.inArray($(this).parent().prop('id'), job_info_Array) > -1) {
				job_info[$(this).parent().prop('id')] = String($(this).data('value'));
			} else {
				if ($(this).prop('id') == 'repeat_interval') {
					jsonData[$(this).parent().prop('id')] = Number($(this).data('value'));
				} else {
					jsonData[$(this).parent().prop('id')] = String($(this).data('value'));
				}
			}
		});

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
		let modalData = $('#detailInfoModal').find("ul.detail_list");
		$('#calendar td a').remove();
		modalData.empty();
		if (data.length > 0) {
			data.forEach(function (v, k) {
				let job_date = new Date(v.job_date).format('dd');
				let job_type = v.job_type;
				let sid = v.site_id;
				let job_info = JSON.parse(v.job_info);
				let tableStr = '<a href="javascript:maintenance(\'get\', \'' + v.id + '\');" data-jobid="' + v.id + '"><p class="bu t' + job_type + '">[' + job_info.siteName + ']' + job_Name(job_type) + '</p></a>';
				let modalStr = '<a href="javascript:maintenance(\'get\', \'' + v.id + '\');"><span class="bu t' + job_type + '">[ ' + job_info.siteName + ' ] ' + job_Name(job_type) + '</span><span class="fr btn_next"></span></a>';

				calendar.eq(Number(job_date) - 1).append(tableStr);
				modalData.append(
					'<li class="single_item" data-id="'+v.id+'">'
						+ modalStr
						+ '<br>'
						+ ''
					+'</li>'
				)
			});
			// TO DO!!!!!!!!!  show more btn
			// calendar.find("p.bu").each(function () {
			// 	$(this).on("mouseover click", function(){
			// 		$("#popoverModal").addClass("active");
			// 	}).on("mouseleave", function(){
			// 		$("#popoverModal").removeClass("active");
			// 	})
			// });
		}

	};

	const checkCalendarVisual = function () {
		const checkType = $.makeArray($(':checkbox[name="type"]:checked').map(
			function () {
				return $(this).val();
			}));

		$('#calendar td a p.bu').each(function () {
			let clsName = $(this).attr('class').replace('bu t', '').trim();
			let siteName = $(this).html().match(/\[(.*?)\]/)[1];
			if ($.inArray(clsName, checkType) > -1) {
				if ($('#searchName').val() == '') {
					$(this).parent().show();
				} else {
					if (siteName.match($('#searchName').val())) {
						$(this).parent().show();
					} else {
						$(this).parent().hide();
					}
				}
			} else {
				$(this).parent().hide();
			}
		});
	};

	const modalPopInit = function (data) {
		const modal = $('#registerModal');
		const title = modal.find('h2');
		const input = modal.find('input');
		const dropDown = modal.find('button.btn-primary');
		const repeat_wrapper = $('#repeat_yn').parents('.flex_start3');
		const repeat_cycle = $('#repeat_yn button');
		const addScheduleBtn = $('#addScheduleBtn');
		const deleteScheduleBtn = $('#deleteScheduleBtn');
		let modalData = $("#popoverModal").find("ul.detail_list");

		repeat_cycle.data('value', '');
		repeat_cycle.parents('div.dropdown').siblings().addClass('hidden');
		repeat_wrapper.removeClass("short");

		$('#repeat_end').removeClass('sel').parent().removeClass('sel_calendar').addClass('tx_inp_type');

		if (data == undefined) {
			modalData.empty();
			title.text('점검계획 등록');
			//팝업 오픈시 value 초기화
			input.each(function () {
				$(this).val('');
			});
			//팝업 오픈시 value 초기화

			dropDown.each(function () {
				$(this).data('value', '').html($(this).data('name') + '<span class="caret"></span>');
			});

			deleteScheduleBtn.addClass('hidden');
			addScheduleBtn.attr('onclick', 'maintenance(\'post\');').text('등록');
		} else {
			
			title.text('점검계획 수정');
			setJsonAutoMapping(data[0], 'registerModal');
			setJsonAutoMapping(JSON.parse(data[0].job_info), 'registerModal');

			let jobDate = new Date(data[0].job_date);
			$('#job_date').datepicker('setDate', jobDate);

			let repeatEnd = new Date(data[0].repeat_end);
			$('#repeat_end').val(repeatEnd.format('yyyy-MM-dd'));

			if ($('#repeat_yn button').data('value') == 'N') {
				$('#repeat_end').val('').datepicker('destroy').removeClass('sel');
				$('#repeat_end').parent().removeClass('sel_calendar').addClass('tx_inp_type');

				$('#repeat_yn').parents('.flex_start3').removeClass('short');
				$('#repeat_yn').siblings().addClass('hidden');

				$('#repeat_end').removeClass('sel').parent().removeClass('sel_calendar').addClass('tx_inp_type');
			} else {
				$('#repeat_yn').parents('.flex_start3').addClass('short');
				$('#repeat_yn').siblings().removeClass('hidden');

				$('#repeat_end').addClass('sel').parent().removeClass('tx_inp_type').addClass('sel_calendar');
				$('#repeat_end').datepicker({
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

			deleteScheduleBtn.removeClass('hidden').attr('onclick', 'maintenance(\'delete\', \'' + data[0].id + '\' );');
			addScheduleBtn.attr('onclick', 'maintenance(\'patch\', \'' + data[0].id + '\' );').text('수정');
		}

		modal.modal();

	}

	const job_Name = function (type) {
		let rtn = '';
		switch (type) {
			case '1':
				rtn = '정기점검'
				break;
			case '2':
				rtn = '구조물 안전진단'
				break;
			case '3':
				rtn = '소방점검'
				break;
			default:
				rtn = '등기이사 기간만료'
				break;
		}
		return rtn;
	};

	const repeatEnd = function (selectedDate) {

		if (selectedDate == undefined && $('#job_date').datepicker('getDate') != null) {
			selectedDate = $('#job_date').datepicker('getDate');
		} else if (selectedDate == undefined && $('#job_date').datepicker('getDate') == null) {
			return false;
		}

		if ($('#repeat_yn button').data('value') == '') {
			return false;
		}

		if ($('#repeat_yn button').data('value') == 'N') {
			$('#repeat_end').val(selectedDate);

			if ($('#alarmSetup button').data('value') != '' && $('#alarmSetup button').data('value') != '직접 설정') {
				selectedDate.setDate(selectedDate.getDate() - Number($('#alarmSetup button').data('value')));
				$('#alarmDate').val(selectedDate.format('yyyy-MM-dd'));
			}
		} else {
			let repeatVal = $('#repeat_interval').val();
			let repeatUnit = $('#repeat_unit button').data('value');
			if (selectedDate != null && selectedDate != '' && repeatVal != '' && repeatUnit != '') {
				let unit = 1;

				if (repeatUnit == 'year') {
					unit = '12';
				} else if (repeatUnit == 'half_year') {
					unit = '6';
				} else if (repeatUnit == 'quarter_year') {
					unit = '3';
				} else {
					unit = '1';
				}

				let selDate = new Date(selectedDate);
				if (repeatUnit != 'day_of_week') {
					let setDay = selDate.getDate()
					selDate.setMonth(selDate.getMonth() + (unit * repeatVal));
					if (setDay != selDate.getDate()) {
						alert('잘못된 날짜를 선택하셨습니다.');
						$('#job_date').val('');
						$('#repeat_end').val('');
						return false;
					}
				} else {
					selDate.setDate(selDate.getDate() + 7);
				}

				$('#repeat_end').val(selDate.format('yyyy-MM-dd'));


				if ($('#alarmSetup button').data('value') != '' && $('#alarmSetup button').data('value') != '직접 설정') {
					selDate.setDate(selDate.getDate() - Number($('#alarmSetup button').data('value')));
					$('#alarmDate').val(selDate.format('yyyy-MM-dd'));
				}
			}
		}

	}

	const afterDatePick = function() {
		repeatEnd();
	}
</script>


<div id="popoverModal" class="popover modal-content popover_modal">
	<div class="modal-header">
		<h2 class="popover_title"></h2>
	</div>
	<div class="modal-body">
		<ul class="detail_list">

		</ul>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">월간 입출금 일정</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-2 col-md-4 clear">
		<div class="sch_sel_area">
			<div class="sch_sel_item">
				<div class="dropdown" id="year">
					<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="#">2020</a></li>
						<li><a href="#">2019</a></li>
						<li><a href="#">2018</a></li>
					</ul>
				</div>
			</div>
			<div class="sch_sel_item">
				<div class="dropdown" id="month">
					<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
						<span class="caret"></span>
					</button>
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



<div class="modal alarm_modal fade" id="spcAlarmModal" tabindex="-1" role="form">
	<div class="modal-dialog spc_modal_lg" role="modal">
		<div class="modal-content spc_modal_content">
			<div class="modal-header">
				<h2>주요 일정 알림 등록</h2>
			</div>
			<div class="modal-body">
				<div class="container-fluid">
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">SPC 선택</span>
						</div>
						<div class="col-lg-10 col-md-10 col-sm-9 px-0 flex_start">
							<div class="tx_inp_type mr-12">
								<input type="text" id="siteName" name="siteName" placeholder="입력" class="required" autocomplete="off">
								<input type="hidden" id="site_id" name="site_id">
							</div>
							<button type="submit" class="btn_type">검색</button>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">알림 항목</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start px-0">
							<div class="dropdown placeholder" id="job_type">
								<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown" data-name="점검 계획 항목 선택"><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="1"><a href="javascript:void(0);">정기 점검</a></li>
									<li data-value="2"><a href="javascript:void(0);">구조물 안전진단</a></li>
									<li data-value="3"><a href="javascript:void(0);">소방점검</a></li>
									<li data-value="4"><a href="javascript:void(0);">등기이사 기간만료</a></li>
								</ul>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">알림 주기</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start3 px-0">
							<div class="dropdown" id="repeat_yn">
								<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown" data-name="점검 선택">점검 선택<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="Y"><a href="javascript:void(0);">정기 점검</a></li>
									<li data-value="N"><a href="javascript:void(0);">일시 점검</a></li>
								</ul>
							</div>
							<div class="tx_inp_type hidden">
								<input type="text" id="repeat_interval" name="repeat_interval" placeholder="입력" onkeydown="onlyNum(event);" maxlength="2" autocomplete="off">
							</div>
							<div class="dropdown hidden" id="repeat_unit">
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="주기">주기<span class="caret"></span></button>
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
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">기준 일자</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start px-0">
							<div class="sel_calendar">
								<input type="text" id="job_date" name="job_date" class="sel fromDate required w-100" value="" autocomplete="off" readonly>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">반복 종료일</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start px-0">
							<div class="tx_inp_type">
								<input type="text" id="repeat_end" name="repeat_end" class="required toDate w-100" placeholder="자동 계산" value="자동 계산" disabled readonly>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">공휴일 처리</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start px-0">
							<div class="dropdown placeholder" id="repeat_before_after_holiday">
								<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown" data-name="공휴일 처리 선택"><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="N"><a href="javascript:void(0);">처리 안함</a></li>
									<li data-value="B"><a href="javascript:void(0);">공휴일 직전 영업일</a></li>
									<li data-value="A"><a href="javascript:void(0);">공휴일 직후 영업일</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">내용</span>
						</div>
						<div class="col-lg-10 col-md-10 col-sm-9 flex_start px-0">
							<textarea class="textarea" id="description" name="description" placeholder="입력"></textarea>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">담당자</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start px-0">
							<div class="tx_inp_type">
								<input type="text" id="worker" name="worker" placeholder="입력" maxlength="10">
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">비고</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start px-0">
							<div class="tx_inp_type">
								<input type="text" id="note" name="note" placeholder="입력" maxlength="50">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">알림 설정</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start2 px-0">
							<div class="dropdown mr-12" id="alarmSetup">
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="일시"><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="1"><a href="javascript:void(0);">1일 전</a></li>
									<li data-value="3"><a href="javascript:void(0);">3일 전</a></li>
									<li data-value="7"><a href="javascript:void(0);">7일 전</a></li>
									<li data-value="직접 설정"><a href="javascript:void(0);">직접 설정</a></li>
								</ul>
							</div>
							<div class="sel_calendar">
								<input type="text" id="alarmDate" name="alarmDate" class="sel disabled" value="" autocomplete="off" readonly>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">알림 시간</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9 flex_start2 px-0">
							<div class="dropdown placeholder mr-12" id="alarmTime">
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="시간"><span class="caret"></span></button>
								<ul class="dropdown-menu">
									<c:forEach var="time" begin="0" end="23">
										<li data-value="${time}"><a href="javascript:void(0);">${time}시</a></li>
									</c:forEach>
								</ul>
							</div>
							<div class="tx_inp_type">
								<input type="text" id="alarmPhone" name="alarmPhone" placeholder="수신 번호" maxlength="12" onkeydown="onlyNum(event)">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12 end">
							<div class="btn_wrap_type02">
								<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
								<button type="button" id="addScheduleBtn" class="btn_type">등록</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-3 col-md-4 col-sm-12 sch_left">
		<div class="indiv">
			<div class="flex_wrapper">
				<h2 class="ntit">주요 일정</h2>
				<button type="button" data-toggle="modal" data-target="#spcAlarmModal" id="addAlarmBtn" class="btn btn_type03">알림 등록</button>
			</div>
			<div class="sch_inp_area">
				<div class="chk_type c1">
					<input type="checkbox" id="chk_op01" name="type" value="1" checked>
					<label for="chk_op01">출금 - 승인 완료</label>
				</div>
				<div class="chk_type c2">
					<input type="checkbox" id="chk_op02" name="type" value="2" checked>
					<label for="chk_op02">출금 - 승인 대기</label>
				</div>
				<div class="chk_type c3">
					<input type="checkbox" id="chk_op03" name="type" value="3" checked>
					<label for="chk_op03">입금</label>
				</div>
				<div class="chk_type c4">
					<input type="checkbox" id="chk_op04" name="type" value="4" checked>
					<label for="chk_op04">이자 지급일</label>
				</div>
				<div class="chk_type c5">
					<input type="checkbox" id="chk_op05" name="type" value="5" checked>
					<label for="chk_op05">보장발전시간 정산일</label>
				</div>
				<div class="chk_type c6">
					<input type="checkbox" id="chk_op06" name="type" value="6" checked>
					<label for="chk_op06">보험 갱신일</label>
				</div>
				<div class="chk_type c7">
					<input type="checkbox" id="chk_op07" name="type" value="7" checked>
					<label for="chk_op07">보험 납부일</label>
				</div>
				<div class="chk_type c8">
					<input type="checkbox" id="chk_op08" name="type" value="8" checked>
					<label for="chk_op08">임대료 지급일</label>
				</div>
				<div class="chk_type c9">
					<input type="checkbox" id="chk_op09" name="type" value="9" checked>
					<label for="chk_op09">대리기관수수료 지급일</label>
				</div>
				<div class="chk_type c10">
					<input type="checkbox" id="chk_op10" name="type" value="10" checked>
					<label for="chk_op10">대출상환 만기일</label>
				</div>
			</div>
			<div class="sch_inp_area">
				<h2 class="ntit">SPC</h2>
				<div class="tx_inp_type">
					<input type="text" id="searchName" name="searchName" placeholder="입력">
				</div>
			</div>
		</div>
	</div>
	<div class="col-lg-9 col-md-8 col-sm-12">
		<div class="indiv pd_type">
			<div class="schedule_area">
				<div class="sch_top_info clear">
					<div class="fl sch_btn">
						<button type="button" class="btn_type03 active">오늘</button>
						<button type="button" class="btn_prev_mon">prev</button>
						<button type="button" class="btn_next_mon">next</button>
						<button type="button" id="detailModalTrigger" class="btn_type03"></button>
					</div>
					<div class="dropdown_modal modal-dialog active" id="detailInfoModal">
						<div class="modal-content spc_detail_content">
							<div class="modal-header">
								<h2 id="modalTitle" class="fl"></h2>
								<a href="#" class="btn_type02 fr">상세보기</a>
							</div>
							<div class="modal-body">
								<ul class="detail_list"></ul>
							</div>
							<div class="btn_wrap_type05">
								<button type="button" id="confirmBtn" class="btn_type">확인</button>
							</div>
						</div>
					</div>
					<div class="btn_wrap_type02 btn_wrap_fixed">
						<a href="/spc/transactionHistory.do" class="btn btn_type03 mr-12" id="writeBtn">입출금 관리 내역</a><a
						href="/spc/withdrawReqStatus.do" class="btn btn_type" id="requestBtn">출금 요청서 검토</a>
					</div>
				</div>
				<div class="sch_btm_area">
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