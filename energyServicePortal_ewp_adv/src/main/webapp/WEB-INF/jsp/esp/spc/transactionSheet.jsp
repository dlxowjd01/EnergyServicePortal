<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script type="text/javascript">
	let today = new Date();
	let date = new Date();
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';

	$(function () {
		pageInit();
		// TO DO!!!!!
		// 사용자 === 사무수탁사 => show() : writeBtn
		// 사용자 === 자산운영사 => show() : requestBtn
		// 임시로 사무수탁사 버튼
		// oid === "" ? $("#writeBtn").show() : $("#requestBtn").show();
		$("#requestBtn").hide();
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

		$('#register').on('click', function () {
			modalPopInit();
		});

		$('#popoverModal li').on('hover', function () {
			
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
		
		$('#detailModalTrigger').click(function(){
			$("#detailInfoModal").toggleClass("active");
		});
		$('#closeDetailModal').on("click", function(){
			console.log("close===");
			$("#detailInfoModal").removeClass("active");
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
				$('#popoverModal').modal('hide');
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
				let modalStr = '<a href="javascript:maintenance(\'get\', \'' + v.id + '\');"><p class="bu t' + job_type + '">[ ' + job_info.siteName + ' ] ' + job_Name(job_type) + '</p></a>';

				calendar.eq(Number(job_date) - 1).append(tableStr);
				modalData.append(
					'<li class="single_item" data-id="'+v.id+'">'
						+ modalStr
						+ '<br>'
						+ ''
					+'</li>'
				)
			});
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
		console.log=("data----", data)
		let modalData = $("#popoverModal").find("ul.detail_list");
		if (data == undefined) {
			modalData.empty();

		} else {
			setJsonAutoMapping(data[0], 'popoverModal');
			setJsonAutoMapping(JSON.parse(data[0].job_info), 'popoverModal');
		}

		$('#popoverModal').addClass("active");
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
</script>


<div id="popoverModal" class="popover modal-content popover_modal">
	<div class="modal-header">
		<h2 class="popover_title"></h2>
	</div>
	<div class="modal-body">
		<ul class="">

		</ul>
	</div>
</div>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">SPC 입출금 관리</h1>
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

<div class="row">
	<div class="col-lg-2 col-md-3 col-sm-4 sch_left">
		<div class="indiv">
			<h2 class="ntit">점검 구분</h2>
			<div class="sch_inp_area">
				<div class="chk_type c1">
					<input type="checkbox" id="chk_op01" name="type" value="1" checked>
					<label for="chk_op01"><span></span>출금 - 승인 완료</label>
				</div>
				<div class="chk_type c2">
					<input type="checkbox" id="chk_op02" name="type" value="2" checked>
					<label for="chk_op02"><span></span>출금 - 승인 대기</label>
				</div>
				<div class="chk_type c3">
					<input type="checkbox" id="chk_op03" name="type" value="3" checked>
					<label for="chk_op03"><span></span>입금</label>
				</div>
				<div class="chk_type c4">
					<input type="checkbox" id="chk_op04" name="type" value="4" checked>
					<label for="chk_op04"><span></span>이자 지급일</label>
				</div>
				<div class="chk_type c5">
					<input type="checkbox" id="chk_op05" name="type" value="5" checked>
					<label for="chk_op05"><span></span>보장발전시간 정산일</label>
				</div>
				<div class="chk_type c6">
					<input type="checkbox" id="chk_op06" name="type" value="6" checked>
					<label for="chk_op06"><span></span>보험 갱신일</label>
				</div>
				<div class="chk_type c7">
					<input type="checkbox" id="chk_op07" name="type" value="7" checked>
					<label for="chk_op07"><span></span>보험 납부일</label>
				</div>
				<div class="chk_type c8">
					<input type="checkbox" id="chk_op08" name="type" value="8" checked>
					<label for="chk_op08"><span></span>임대료 지급일</label>
				</div>
				<div class="chk_type c9">
					<input type="checkbox" id="chk_op09" name="type" value="9" checked>
					<label for="chk_op09"><span></span>대리기관수수료 지급일</label>
				</div>
				<div class="chk_type c10">
					<input type="checkbox" id="chk_op10" name="type" value="10" checked>
					<label for="chk_op10"><span></span>대출상환 만기일</label>
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
	<div class="col-lg-10 col-md-9 col-sm-8">
		<div class="indiv pd_type">
			<div class="schedule_area">
				<div class="sch_top_info clear">
					<div class="fl sch_btn">
						<button type="button" class="btn_type03 active">오늘</button>
						<button type="button" class="btn_prev_mon">prev</button>
						<button type="button" class="btn_next_mon">next</button>
						<button type="button" id="detailModalTrigger" class="btn_type03 active"></button>
					</div>
					<div class="dropdown_modal modal-dialog" id="detailInfoModal">
						<div class="modal-content spc_detail_content">
							<div class="modal-header">
								<h2 id="modalTitle" class="fl"></h2>
								<a href="#" class="btn_type02 fr">상세보기</a>
							</div>
							<div class="modal-body">
								<ul class="detail_list"></ul>
							</div>
						</div>
					</div>
					<div class="fr btn_wrap_type02">
						<a href="/spc/maintenanceSchedulePost.do" class="btn_type fr" id="writeBtn">출금 요청서 작성</a>
						<a href="/spc/maintenanceSchedulePost.do" class="btn_type fr" id="requestBtn">출금 요청서 신청</a>
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