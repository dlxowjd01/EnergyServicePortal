<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	let today = new Date();
	let date = new Date();
	var spcPairArr = [];

	$(function () {
		// task 1: 사무수탁사  2: 자산 운용사  3: 사업주  ||  role 1: encored  2: spc clients
		if(task == 1) {
			$("#requestBtnReview").remove();
		} else if(task == 2 || task == 3) {
			$("#requestBtn").remove() 
		} else if( task == 4) {
			$("#requestBtnReview").remove();
			$("#requestBtn").remove();
		}
		const modalForm = $("#spcAlarmForm");
		const clone = $("#spcList").clone().html();
		$("#spcList").empty();

		getSpcList();

		pageInit();

		setTimeout(function(){
			maintenance(spcPairArr, 'get');
		}, 300);


		function getSpcList (){
			$.ajax({
				url: apiHost + '/spcs?oid=' + oid + '&includeGens=true',
				dataType: 'json',
				type: 'get',
				async: false,
				contentType: "application/json",
				beforeSend: function(){
					$('#loadingCircle').show();
				},
				success: function (json) {
					let data = json.data;
					var promise = [];
					var spcIdList = [];
					var gensInfoList = [];
					var spcNameArr = [];

					data.map(x => {
						spcIdList.push(x.spc_id);
						const spcInfo = JSON.parse(x.spc_info);
						if (isEmpty(spcInfo.spcName)) {
							spcInfo.spcName = x.name;
							promise.push(Promise.resolve(spcInfo));
						} else {
							promise.push(Promise.resolve(JSON.parse(x.spc_info)));
						}
					});
					// setTimeout(function(){
						Promise.all(promise).then(res => {
							var length = res.length;
							// console.log("length", length)
							res.map((n, i) => {
								let str = '';
								let obj = {};
								if(n.name) {
									obj.spcName = n.name;
								} else if(n.spcName) {
									obj.spcName = n.spcName;
								} else if(isEmpty(n.name) && isEmpty(n.spcName)) {
									obj.spcName = "no_name";
								}
								obj.spcId = spcIdList[i];
								spcPairArr.push(obj);
								str = clone.replace(/\*spcName\*/g, obj.spcName).replace(/\*spcId\*/g, spcIdList[i]);
								$("#spcList").append($(str));
							});
							setDropdownValue($("#spcList"));
						});

					// }, 300);
				},
				error: function(request, status, error) {
					console.log("error===", error)
				}
			});
		}

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
			maintenance(spcPairArr, 'get');
		});

		//전월
		$('.btn-prev-month').click(function () {
			let prevMonth = today.getMonth() - 1;
			today = new Date(today.getFullYear(), prevMonth, today.getDate());
			$('#modalTitle').text(prevMonth);
			$('#popoverModal').find("h2").text(prevMonth);
			buildCalendar();
			maintenance(spcPairArr, 'get');
			// return false;
		});

		//다음월
		$('.btn-next-month').click(function () {
			let nextMonth = today.getMonth() + 1;
			today = new Date(today.getFullYear(), nextMonth, today.getDate());
			$('#modalTitle').text(nextMonth);
			buildCalendar();
			maintenance(spcPairArr, 'get');
			// return false;
		});

		//요번달
		$('.btn-type03.active').click(function () {
			today = new Date();
			buildCalendar();
			maintenance(spcPairArr, 'get');
			// return false;
		});

		$('#repeat_interval, #repeat_unit').on('click change', function () {
			repeatEnd();
			// return false;
		});

		// $('#spcAlarmModal li').on('click', function () {
		// 	let value = $(this).data('value');
		// 	let buttonId = $(this).parents('div').prop('id');
		// 	$(this).parents('div.dropdown').find('button').data('value', value);

		// 	if (buttonId == 'repeat_yn') {
		// 		if (value == 'Y') {
		// 			$(this).parents('.flex-start3').addClass('short');
		// 			$(this).parents('div.dropdown').siblings().removeClass('hidden');

		// 			$('#repeat_end').addClass('sel').parent().removeClass('text-input-type').addClass('sel-calendar');
		// 		} else {
		// 			$(this).parents('.flex-start3').removeClass('short');
		// 			$(this).parents('div.dropdown').siblings().addClass('hidden');

		// 			$('#repeat_end').removeClass('sel').parent().removeClass('sel-calendar').addClass('text-input-type');
		// 		}
		// 		repeatEnd();
		// 	} else if (buttonId == 'alarmSetup') {
		// 		if ($('#alarmDate').hasClass('hasDatepicker')) {
		// 			$('#alarmDate').datepicker('destroy').removeClass('hasDatepicker');
		// 		}
		// 		if (value != '직접 설정') {
		// 			let jobDate = $('#job_date').datepicker('getDate');
		// 			if (isEmpty($('#job_date').val())) {
		// 				$('#alarmDate').val('');
		// 			} else {
		// 				jobDate.setDate(jobDate.getDate() - value);
		// 				$('#alarmDate').val(jobDate.format('yyyy-MM-dd'));
		// 			}
		// 		} else {
		// 			$('#alarmDate').datepicker({
		// 				showOn: "both",
		// 				buttonImageOnly: true,
		// 				dateFormat: 'yy-mm-dd',
		// 				beforeShow: function () {
		// 					let minDate = $('#job_date').datepicker('getDate');
		// 					if (minDate != '') {
		// 						$('#alarmDate').datepicker('option', 'minDate', minDate);
		// 					}

		// 					let maxDate = $('#repeat_end').datepicker('getDate');
		// 					if (maxDate != '') {
		// 						$('#alarmDate').datepicker('option', 'maxDate', maxDate);
		// 					}
		// 				}
		// 			})
		// 			$('#alarmDate').val('');
		// 		}
		// 	}
		// });

		$(':checkbox[name="type"]').on('change', function () {
			searchBySpcName();
		});

		$('#searchName').on('keyup', function () {
			searchBySpcName();
		});
		
		$('body').click(function() {

		});

		$('#confirmBtn').on("click", function(){
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

	// calendar frame ONLY (no data)
	const buildCalendar = function () { //현재 달 달력 만들기
		let doMonth = new Date(today.getFullYear(), today.getMonth(), 1);
		let lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0);
		let tbCalendar = document.getElementById('calendar');

		// const spcOpt = $("#spcList");
		// const spcClone = spcOpt.clone().html();
		// $("#spcList").empty();
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
			cell.innerHTML = '<h2 class="date" data-day="' + doMonth.format('yyyyMM') + i + '">' + i + '</h2><ul class="alarm-list"></ul>';
			cnt = cnt + 1;

			if (cnt % 7 == 0) {
				row = calendar.insertRow();
			}
			/* today */
			if (today.getFullYear() == date.getFullYear() &&
				today.getMonth() == date.getMonth() &&
				i == date.getDate()) {
				cell.setAttribute('class', 'today');
			}
		}

		$('.search-btn .btn-type03:last-of-type').text(thisMonth);
		$('#modalTitle').text(thisMonth);
		$('#year > button').html(doMonth.getFullYear() + '년<span class="caret"></span>').data('value', doMonth.getFullYear());
		$('#month > button').html(doMonth.getMonth() + 1 + '월<span class="caret"></span>').data('value', doMonth.getMonth() + 1);
	};

	const maintenance = function (spcNameArr, action, jobId) {
		var spcIdArr = spcNameArr;
		let option = {};

		if (action == 'get') {
			let optTransaction = {};
			let d = $('#year button').data('value') + ('0' + $('#month button').data('value')).slice(-2)
			let yyyy = d.slice(0, 4);
			let mm = d.slice(4, 7);
			let spcId = '';
			let endDay = '';

			if(!isEmpty(spcNameArr)){
				var spcNameList = spcNameArr;
				// console.log("spcName===", typeof spcNameArr)
				if(typeof spcNameArr == 'number' ){
					spcId = spcNameArr;
				} else if (spcNameArr.length) {
					spcId = spcNameArr.map(x => x.spcId).join();
				} else {
					spcId = spcNameArr.spcId;
				}
			}

			endDay = yyyy + mm + new Date(yyyy, mm, 0).getDate();
			startDay = yyyy + mm + '01';

			// GET req
			option = {
				url: apiHost + '/spcs/maintenance',
				type: 'get',
				dataType: 'json',
				data: {
					oid: oid,
					type: "money",
					like_yyyymm: yyyy + mm,
				},
				beforeSend: function () {
					$('#loadingCircle').show();
				},
				async: false
			};

			optTransaction = {
				url: apiHost + '/spcs/transactions',
				type: action,
				dataType: 'json',
				data: {
					'oid' : oid,
					'spcIds' : spcId,
					'startDay': startDay,
					'endDay' : endDay
				},
				async: false,
				beforeSend: function () {
					$('#loadingCircle').show();
				},
			};

			if (jobId != undefined) {
				option.data.jobId = jobId;
			}

			$.when($.ajax(option),$.ajax(optTransaction)).done(function (result1, result2) {
				var item1 = result1[0].data;
				var item2 = groupBy(result2[0].data, "withdraw_day");
				// console.log("item2===", item2)
				fillCalendar(item1, item2, spcNameList);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				showWarningModal("fail");
				return false;
			});

		} else {
			if (action == 'post' || action == 'patch') {
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

				if (action == 'patch') {
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
				if (action == 'delete') {
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
				// maintenance(spcPairArr, 'get');
			}).fail(function (jqXHR, textStatus, errorThrown) {
				showWarningModal("fail");
				console.log("jqXHR===", jqXHR)
				return false;
			});
		}
	};

	const fillCalendar = function (mData, tData, spcNameList) {
		var calendar = $('#calendar .alarm-list');
		var modalData = $('#detailInfoModal').find(".alarm-list");
		var spcList = spcNameList;
		calendar.empty();
		modalData.empty();

		const checkType = $.makeArray($(':checkbox[name="type"]:checked').map(function () {
				return $(this).val();
			}
		));
		const serachName = $('#searchName').val().trim().toLowerCase();

		if (mData.length > 0) {
			mData.forEach(function (v, k) {
				const filterArr = ["1", "2", "3", "4"];
				let job_date = new Date(v.job_date).format('dd');
				let job_type = v.job_type;
				let sid = v.spc_id;
				let job_info = '';
				let tableStr = '';
				let bulletStr = '';
				let hiddenClass = '';

				// console.log("jov_date===", job_date)
				// console.log("job_type===", job_type)
				return new Promise((resolve, reject) => {
					resolve(JSON.parse(v.job_info))
				}).then(result => {
					job_info = result;

					let spcName = '';
					if(spcList.length>0){
						spcList.some(x => {
							if(x.spcId === v.spc_id) {
								spcName = x.spcName;
							}
						});
					}

					if(isEmpty(spcName)){
						spcName = "spc_no_name";
					}

					if ($.inArray(job_type, checkType) === -1) {
						hiddenClass = 'hidden';
					} else {
						if (!isEmpty(serachName)) {
							if ((spcName.toLowerCase().match(serachName) || job_Name(job_type).match(serachName)) == null) {
								hiddenClass = 'hidden';
							}
						}
					}

					// console.log("job_type===", job_type);
					if (filterArr.indexOf(job_type) > -1){
						tableStr = '<li data-jobId="' + v.id + '" data-id="' + v.spc_id + '" data-name="' + spcName + '" class="link bu t' + job_type + ' ' + hiddenClass + '">[' + spcName + '] ' + job_Name(job_type) + '</li>';
					} else {
						tableStr = '<li data-jobId="' + v.id + '" data-id="' + v.spc_id + '" data-name="' + spcName + '" class="link bu t' + job_type + ' ' + hiddenClass + '">[' + spcName + '] ' + job_Name(job_type) + '</li>';
					}
					bulletStr = '<span data-jobId="' + v.id + '" data-id="' + v.spc_id + '" data-name="' + spcName + '" class="bu t' + job_type + '">[ ' + spcName + ' ] ' + job_Name(job_type) + '</span><span class="fr btn-next"></span>';
					calendar.eq(Number(job_date) - 1).append(tableStr);
					modalData.append(
						'<li class="link alarm-item ' + hiddenClass + '" data-id="'+v.id+'">'
						+ bulletStr
						+ '<br>'
						+ ''
						+'</li>'
					)
				}).catch(function(error) {
					if(error){
						return false;
					}
					console.log(error);
				});
			});
		}

		if (!isEmpty(tData)) {
			Object.entries(tData).map((item, index) => {
				// "반송" : 0,  "승인 대기" : 1", "승인 중" : "2", "승인완료": "3"
				let statusList = [
					{ id: 0, val: "출금 - 반송" },
					{ id: 1, val: "출금 - 승인 대기" },
					{ id: 2, val: "출금 - 승인 중" },
					{ id: 3, val: "출금 - 승인 완료" },
					{ id: 4, val: "출금 - 가승인" },
					{ id: 5, val: "출금 - 최종 승인" },
					{ id: 6, val: "입금" }
				];
				let tStr = ''
				let bStr = '';
				let firstStatus = item[1][0].status;
				let bulletIdx = '';
				let d = item[0].slice(-2);
				let spcName = '';
				let hiddenClass = '';

				// console.log("pair---", spcPair)
				spcList.some(x => {
					if(x.spcId == item[1][0].spc_id) {
						spcName = x.spcName;
					}
				});
				if(item[1][0].status == 1){
					bulletIdx = "2";
				} else if(item[1][0].status == 2){
					bulletIdx = "3";
				} else if(item[1][0].status == 3) {
					bulletIdx = "1";
				} else if(item[1][0].status == 4) {
					bulletIdx = "4";
				} else if(item[1][0].status == 5) {
					bulletIdx = "5";
				}
				if ($.inArray(bulletIdx, checkType) === -1) {
					hiddenClass = 'hidden';
				} else {
					if (!isEmpty(serachName)) {
						if ((spcName.toLowerCase().match(serachName) || (statusList[firstStatus].val).toLowerCase().match(serachName)) == null) {
							hiddenClass = 'hidden';
						}
					}
				}
				// console.log( 'item[1]===', item[1])
				//    item[1][0].spc_id
				if(firstStatus !=0){
					if(item[1].length>1){
						tStr = '<li data-id="' + item[1][0].spc_id + '" data-name="' + spcName + '" data-value="' + firstStatus + '" class="bu t' + bulletIdx + ' ' + hiddenClass + '">[' + spcName + '] ' + statusList[firstStatus].val + ' 외 + ' + (item[1].length - 1) + '건</li>';
						bStr = '<span data-id="' + item[1][0].spc_id + '" data-name="' + spcName + '" data-value="' + firstStatus + '" class="bu t' + bulletIdx + '">[' + spcName + '] ' + statusList[firstStatus].val + ' 외 + ' + (item[1].length - 1) + '건</span><span class="fr btn-next"></span>';
					} else {
						tStr = '<li data-id="' + item[1][0].spc_id + '" data-name="' + spcName + '" data-value="' + firstStatus + '" class="bu t' + bulletIdx + ' ' + hiddenClass + '">[' + spcName + '] ' + statusList[firstStatus].val + '</li>';
						bStr = '<span data-id="' + item[1][0].spc_id + '" data-name="' + spcName + '" data-value="' + firstStatus + '" class="bu t' + bulletIdx + '">[' + spcName + '] ' + statusList[firstStatus].val + '</span><span class="fr btn-next"></span>';
					}
					calendar.eq(Number(d) - 1).append(tStr);
					modalData.append(
						'<li class="alarm-item link ' + hiddenClass + '">'
						+ bStr
						+ '<br>'
						+ ''
						+'</li>'
					)
				}
				// console.log("calendar===", calendar.find("li"))
			});
		}

		$("#addAlarmBtn").on("click", function(){
			modalPopInit(undefined, spcNameList);
		});

		setTimeout(function(){
			calendar.find(".link").on("click", function(){
				var self = $(this);
				if(isEmpty(self.attr("data-jobId"))){
					// console.log("No jobId==", self.attr("data-jobId"))
					modalPopInit();
				} else {
					// console.log("YES jobId==", self.attr("data-jobId"))
					let spcObj = {};
					spcObj.spcId = self.data("id");
					spcObj.spcName = self.data("name");
					let jobId = self.data("jobid");

					modalPopInit(mData, spcObj, jobId);
					// $("#spcAlarmForm").find(".modal-header").text("주요 일정 알림 수정");
				}
				// if($("#detailInfoModal").hasClass("active")) {
				// 	$("#detailInfoModal").removeClass("active");
				// }
				// $("#spcAlarmModal").modal("show");
			});
		}, 300);

	};

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
				maintenance(spcIdArr, 'post');
			});
		} else {
			let targetDate;
			data.forEach(temp => {
				if (temp.id == jobId) {
					targetDate = temp;
				}
			});

			title.text('주요 일정 알림 수정');
			const jobInfo = JSON.parse(targetDate.job_info);
			setJsonAutoMapping(targetDate, 'spcAlarmModal', 'dropdown');
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

			// deleteScheduleBtn.removeClass('hidden').attr('onclick', 'maintenance(\'delete\', \'' + data[0].id + '\' );');
			deleteScheduleBtn.removeClass('hidden');

			deleteScheduleBtn.off('click');
			deleteScheduleBtn.on("click", function(e){
				// e.preventDefault();
				maintenance(spcNameList, 'delete', targetDate.id);
			});
			// $("#closeBtn").on("click", function(){ return false; })
			postScheduleBtn.text('수정');

			postScheduleBtn.off('click');
			postScheduleBtn.on("click", function(){
				// console.log("postScheduleBtn====")
				maintenance(spcNameList, 'patch', targetDate.id);
			});
			// postScheduleBtn.attr('onclick', 'maintenance(' + spcNameList + '\'patch\', \'' + data[0].id + '\' );').text('수정');
		}
		modal.modal("show");
		if($("#detailInfoModal").hasClass("active")) {
			$("#detailInfoModal").removeClass("active");
		}
	}

	// 등록 & 수정 용 데이터 세팅
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

	const searchBySpcName = function () {
		const checkType = $.makeArray($(':checkbox[name="type"]:checked').map(function () {
				return $(this).val();
			}
		));

		$('#detailInfoModal .alarm-item.link').each(function () {
			let targetSpan = $(this).find('span.bu');
			let clsName = targetSpan.attr('class').replace(/[^0-9]/g, '').trim();
			let spcName = targetSpan.html().match(/\[(.*?)\]/)[1].toLowerCase();
			if ($.inArray(clsName, checkType) > -1) {
				if ($('#searchName').val() == '') {
					$(this).removeClass('hidden');
				} else {
					if (spcName.match($('#searchName').val().toLowerCase())) {
						$(this).removeClass('hidden');
					} else {
						$(this).addClass('hidden');
					}
				}
			} else {
				$(this).addClass('hidden');
			}
		});


		$('#calendar td .bu').each(function () {
			let clsName = $(this).attr('class').replace(/[^0-9]/g, '').trim();
			let spcName = $(this).html().match(/\[(.*?)\]/)[1].toLowerCase();
			if ($.inArray(clsName, checkType) > -1) {
				if ($('#searchName').val() == '') {
					$(this).removeClass('hidden');
				} else {
					if (spcName.match($('#searchName').val().toLowerCase())) {
						$(this).removeClass('hidden');
					} else {
						$(this).addClass('hidden');
					}
				}
			} else {
				$(this).addClass('hidden');
			}
		});
	};

	const job_Name = function (type) {
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
			case 'default': rtn = ''
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

	// function beginningOfMonth(myDate){
	// 	let date = new Date(myDate);
	// 	date.setDate(1)
	// 	date.setHours(0);
	// 	date.setMinutes(0);
	// 	date.setSeconds(0);
	// 	return date.toLocaleString();
	// }

	// function endOfMonth(myDate){
	// 	let date = new Date(myDate);
	// 	date.setMonth(date.getMonth() +1)
	// 	date.setDate(0);
	// 	date.setHours(23);
	// 	date.setMinutes(59);
	// 	date.setSeconds(59);
	// 	return date.toLocaleString();
	// }

	// function getHostname (url) {
	// 	// use URL constructor and return hostname
	// 	const matches = url.match(/^https?\:\/\/([^\/?#]+)(?:[\/?#]|$)/i);
	// 	console.log("matches===", matches&&matches[1])
	// 	return matches && matches[1].split('.')[0];
	// 	// return new URL(url).hostname.split('.')[0];
	// }

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
							<div class="col-lg-2 col-md-2 col-sm-3"><span class="input-label">SPC 선택</span></div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
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
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label asterisk">알림 항목</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
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
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label asterisk">알림 주기</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start3">
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
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label asterisk">기준 일자</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
								<div class="sel-calendar">
									<input type="text" id="job_date" name="job_date" class="sel fromDate required w-100" value="" autocomplete="off" readonly placeholder="기준 일자">
									<small class="hidden warning">기준일을 선택해 주세요</small>
								</div>
							</div>
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label">반복 종료일</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
								<div class="text-input-type w-100">
									<input type="text" id="repeat_end" name="repeat_end" class="required toDate w-100" placeholder="반복 종료일" value="" readonly>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label asterisk">공휴일 처리</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
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
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label">내용</span>
							</div>
							<div class="col-lg-10 col-md-10 col-sm-9 flex-start">
								<textarea id="description" class="textarea" name="description" placeholder="입력"></textarea>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label">담당자</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
								<div class="text-input-type">
									<input type="text" id="worker" name="worker" placeholder="입력" maxlength="10">
									<small class="hidden warning">담당자를 선택해 주세요</small>
								</div>
							</div>
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label">비고</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start">
								<div class="text-input-type w-100">
									<input type="text" id="note" name="note" placeholder="입력" maxlength="50">
								</div>
							</div>
						</div>
						<div class="row end">
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label">알림 설정</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start2">
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
							<div class="col-lg-2 col-md-2 col-sm-3">
								<span class="input-label">알림 시간</span>
							</div>
							<div class="col-lg-4 col-md-4 col-sm-9 flex-start2">
								<div class="dropdown placeholder mr-12" id="alarmTime">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="시간"><span class="caret"></span></button>
									<ul class="dropdown-menu">
										<c:forEach var="time" begin="0" end="23">
											<li data-value="${time}"><a href="javascript:void(0);">${time}시</a></li>
										</c:forEach>
									</ul>
								</div>
								<div class="text-input-type w-100">
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

				<div class="flex-wrapper mt40">
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
					--><button type="button" id="detailModalTrigger" class="btn-type03" onclick="$('#detailInfoModal').toggleClass('active')"></button><!--
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