<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script type="text/javascript">
	var defList = [];
	$(function () {
		let d = new Date();
		let yesterday = new Date(d.getFullYear(), d.getMonth(), d.getDate()-1);
		let currentTime = new Date().format('HH:mm');
		let yesterdayTime = new Date(Date.now() - 86400 * 1000);
		let script = '/js/data_tables/include_all.min.js'

		$('#fromDate').datepicker().datepicker("setDate", 'today');
		$('#toDate').datepicker().datepicker("setDate", 'today');

		$('#timepicker1').wickedpicker({
			now: "00:00", twentyFour: true
		});

		$('#timepicker2').wickedpicker({
			now: currentTime, twentyFour: true
		});
		$('#fromDate').on("change", function(){
			let fromDateVal = $('#fromDate').datepicker('getDate').getTime();
			let endDateVal = $('#toDate').datepicker('getDate').getTime();

			if( (fromDateVal - endDateVal) > 0){
				$('#isInvalidPeriod').removeClass("hidden");
				$('#fromDate').datepicker('setDate', 'today');
				setTimeout(function(){
					$('#isInvalidPeriod').addClass("hidden");
				}, 1800);
			}
		});
		
		initDetails();
		getData("firstTime");

		// $("#updateScheduleForm .digit").on("keyup", function(evt, limit){
		// 	let value = $(this).val();
		// 	if( value.match(/[^\x00-\x80]/) ){
		// 		$(this).val("");
		// 	}
			
		// });

		$(document).on("change", ".digit:not('#scheduleCycle')", function(evt) {
			this.value = this.value.replace(/,/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		});

		$("#updateScheduleForm").on("change", function(evt, limit){
			let scheduleList = $("#scheduleList");
			let warning = scheduleList.parents().closest(".dropdown").next();
			if( isEmpty(scheduleList.prev().data("value") )){
				warning.removeClass("hidden");
			} else {
				warning.addClass("hidden");
				setTimeout(function(){
					validateForm();
				}, 300);
			}
		});

		$("#updateScheduleForm .digit").on("input", function(evt, limit){
			let value = $(this).val();
			if(!$(this).is("#scheduleCycle")){
				$(this).val(value.replace(/\s/g, ''));
				if(value.match(/[^\x00-\x80]/) || value.match(/[^0-9]/) ){
					$(this).val( value.replace(/[^0-9]/g, "") );
				}
			} else {
				if(value.match(/[^\x00-\x80]/) || value.match(/[^0-9,\-\*\s]/) ){
					$(this).val( value.replace(/[^0-9,\-\*\s]/g, "") );
				}
			}
		});
		
		$("#deleteConfirmBtn").click(function(){
			let dTable = $("#scheduleTable").DataTable();
			let tr = $("#scheduleTable").find("tbody tr.selected");
			let rowData = dTable.row(tr).data();
			let modalBody = $("#deleteConfirmModal .modal-body");

			if($("#confirmSchedule").val() !== tr.find("td").eq(2).text() ) return false;

			let optDelete = {
				url: apiHost + "/batch-job-submit-rules/"+ rowData.id,
				type: "delete",
				async: true,
			}

			$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("배치 스케줄이 삭제 되었습니다.").removeClass("hidden");
				dTable.row(tr).remove().draw();
				// refreshSiteList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1000);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("배치 스케줄 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
				console.log("fail==", jqXHR)
			});
		});

		$("#deleteConfirmBtn").click(function(){
			let dTable = $("#scheduleTable").DataTable();
			let tr = $("#scheduleTable").find("tbody tr.selected");
			let rowData = dTable.row(tr).data();
			let modalBody = $("#deleteConfirmModal .modal-body");

			if($("#confirmSchedule").val() !== tr.find("td").eq(2).text() ) return false;

			let optDelete = {
				url: apiHost + "/batch-job-submit-rules/"+ rowData.id,
				type: "delete",
				async: true,
			}

			$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("배치 스케줄이 삭제 되었습니다.").removeClass("hidden");
				dTable.row(tr).remove().draw();
				// refreshSiteList();
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1000);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				modalBody.addClass("hidden");
				$("#deleteSuccessMsg").text("배치 스케줄 삭제에 실패하였습니다.\n다시 시도해 주세요.").removeClass("hidden");
				setTimeout(function(){
					$("#deleteConfirmModal").modal("hide");
				}, 1500);
				console.log("fail==", jqXHR)
			});
		});

		$("#deleteConfirmModal").on("hide.bs.modal", function() {
			$("#deleteSuccessMsg").html('<h5 id="deleteSuccessMsg" class="ntit">배치 스케줄 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>');
			$("#confirmSchedule").val("");
			$("#deleteConfirmBtn").prop("disabled", true);
			setTimeout(function(){
				$(this).find(".modal-body").removeClass("hidden");
			}, 1600);
		});
	});

	function getData(option, input){
		let optionList = [
			{
				url: apiHost + "/batch-job-definitions",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/batch-job-submit-rules?includeBatchJobDefinition=true&limit=50",
				// url: apiHost + "/batch-job-submit-rules?limit=100",
				type: "get",
				async: true,
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
				}
			}
		];
	
		if(option === "log") {
		// 1. table row is selected && user has clicked a search button
			getLogData(input, defList);
		} else {
			if(option == "firstTime" || option == "schedule"){
			// 2. first Time rendering
				Promise.all([ makeAjaxCall(optionList[0]), makeAjaxCall(optionList[1]) ]).then(res => {
					let definitionData = res[0];
					let submitRulesData = res[1];
					let str = '';
					defList = definitionData;

					getSubmitRulesData(submitRulesData);
					definitionData.forEach((item, index) => {
						/*
							[Batch Job Definition] === [Batch Schedule Definition] ???
							item.id => definition id
							item.name => definition name
						*/

						let found = submitRulesData.findIndex( x => x.definition_id === item.id);
						if(found > -1){
							if(!isEmpty(option)){		
								str += '<li data-value="' + item.id + '" data-schedule-name="' + submitRulesData[found].batchJobDefinition.name 
								+ '" data-definition-id="' + submitRulesData[found].definition_id + '"><a href="#">' + submitRulesData[found].batchJobDefinition.name + '</a></li>'
							}
						} else {
							// console.log("NO matching definition_id from submit rules data====", item)
							// str += '<li data-value="' + item.id + '" data-definition-id="" data-schedule-name="' + item.name + '"><a href="#">' + item.name + '</a></li>'
						}
					});

					$("#scheduleList").append(str);
					$("#scheduleList li").on("click", function(){
						let val = $(this).data("value");
						let definitionId = $(this).data("definition-id");

						$("#scheduleList").prev().data({ "value": val, "definition-id": definitionId });
						let found = defList.findIndex( x => x.id === val);
						if(found > -1) {
							let data = defList[found];
							$("#taskName").val(data.name);
							$('input[name="option_hold"][value="' + data.is_valid + '"]').prop( "checked", true);
							$("#argumentParam").val(data.arg_format.replaceAll("\\s+$", ""));
							$('input[name="option_hold"][value="' + data.option_distributed + '"]').prop( "checked", true);
							$("#cpuVol").val(data.cpu);
							$("#gpuVol").val(data.gpu);
							$("#ramVol").val( String(data.mem).replace(/\B(?=(\d{3})+(?!\d))/g, "," ) ) ;

						}
						let warning = $("#scheduleList").parents().closest(".dropdown").next();
						if( !warning.hasClass("hidden")){
							warning.addClass("hidden");
						}
						setTimeout(function(){
							validateForm();
						}, 200);
					});

				});
			} else {
				// 3. refresh rendering after form submission => NO update on Schedule dropdown list
				$.ajax(optionList[1]).done(function (json, textStatus, jqXHR) {
					$('#scheduleTable').DataTable().destroy();
					getSubmitRulesData(json);
					let target = $('#scheduleList').prev().text();
					let td = $('#scheduleTable tbody td:nth-of-type(3)');

					td.each(function(index, el){
						if($(el).text().startsWith(target)){
							let closestTr = $(el).parents().closest("tr");
							closestTr.addClass("selected").find("input[type='checkbox']").prop("checked", true);

						}
					})
					// getLogData(definitionData);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.log("fail==", jqXHR)
				});
			}
		}

	}

	// function getSubmitRulesData(definitionData, submitRulesData) {
	function getSubmitRulesData(submitRulesData) {
		// console.log("submitRulesData===", submitRulesData);
	
		var scheduleTable = $('#scheduleTable').DataTable({
			"aaData": submitRulesData,
			"destroy": true,
			"table-layout": "fixed",
			"fixedHeader": true,
			"bAutoWidth": true,
			"bSearchable" : true,
			// "scrollX": true,
			// "sScrollX": "100%",
			// "sScrollXInner": "110%",
			"sScrollY": true,
			"scrollY": "530px",
			"bScrollCollapse": true,
			"pageLength": 20,
			// "bFilter": false, disabling this option will prevent table.search()
			"aaSorting": [[ 0, 'asc' ]],
			"bSortable": true,
			"order": [[ 1, 'asc' ]],
			"aoColumnDefs": [
				{
					"aTargets": [ 0 ],
					"bSortable": false,
					"orderable": false
				},
			],
			"aoColumns": [
				{
					"sTitle": "",
					"mData": "",
					"mRender": function ( data, type, full, rowIndex ) {
						return '<a class="chk-type" href="#" onclick="return false"><input type="checkbox" id="' +
							full.id + '" name="' + full.id + '"><label for="' + full.id + '"></label></a>'
					},
					"className": "dt-body-center"
				},
				{
					"sTitle": "순번",
					"mData": "",
					"mRender": function ( data, type, full, rowIndex ) {
						return rowIndex.row + 1
					},
					"className": "dt-body-center"
				},
				{
					"sTitle": "스케줄 명",
					"mData": "",
					"mRender": function ( data, type, full, rowIndex ) {
						if(!isEmpty(full.batchJobDefinition)){
							return full.batchJobDefinition.name + ' (id: ' + full.batchJobDefinition.id + ')';
						} else {
							return "힝목 에러(삭제 필요)";
						}
					},
				},
				{
					"sTitle": "작업명",
					"mData": "name"
				},
				{
					"sTitle": "실행 주기",
					"mData":"schedule",
				},
				{
					"sTitle": "등록자",
					"mData":"created_by",
				},
				{
					"sTitle": "등록일자",
					"mData":"",
					"mRender": function ( data, type, full, rowIndex ) {
						return new Date(full.created_at).format('yyyy-MM-dd') + '&ensp;' + new Date(full.created_at).format('HH:mm:ss')
					},
				},
			],
			"dom": 'tip',
			"language": {
				"paginate": {
					"previous": "",
					"next": "",
				},
				"info": "_PAGE_ - _PAGES_ " + " / 총 _PAGES_ 개",
				"select": {
					"rows": {
						_: "",
						1: ""
					}
				}
			},
			"select": {
				style: 'single',
				selector: 'td:not(:first-child)'
			},
			initComplete: function(settings, json ){
				let addBtnStr = `
				<div class="flex-wrapper mt-15 mb-28">
					<h2 class="ntit">배치 스케줄</h2>
					<button type="button" class="btn-type" onclick="updateInfo('add')">신규 등록</button>
				</div>
				`;
				$("#scheduleTable_wrapper").prepend($(addBtnStr));
				this.api().columns().header().each ((el, i) => {
					if(i == 0){
						$(el).attr ('style', 'min-width: 50px');
					}
				});
			},
			// every time DataTables performs a draw
			drawCallback: function (settings) {
				$('#scheduleTable_wrapper').addClass('mb-10');
			}
		}).on("select", function(e, dt, type, indexes) {
			let btn = $("#btnGroup").find("button");
			let btnLink = $("#btnGroup").find("a");
			btn.each(function(index, element){
				if(index === 1){
					$(this).prop("disabled", false).contents().get(0).nodeValue = "수정";
					btnLink.prop("disabled", false).removeClass("disabled");
				}
				if($(this).is(":disabled")){
					$(this).prop("disabled", false);
				}
			});
			scheduleTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);

			updateInfo('edit');
			// $("#getLogBtn").prop("disabled", false);
			// console.log("dt---", scheduleTable[ type ]( indexes ).nodes())
		}).on("deselect", function(e, dt, type, indexes) {		
			let btn = $("#btnGroup").find(".btn-type03");
			let btnLink = $("#btnGroup").find("a");
			btn.each(function(index, element){
				if(index === 1){
					btnLink.prop("disabled", true).addClass("disabled");
				}
				if(!$(this).is(":disabled")){
					$(this).prop("disabled", true);
				}
			});

			scheduleTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
			// $("#getLogBtn").prop("disabled", true);
			// console.log("dt---", scheduleTable[ type ]( indexes ).nodes())
		}).columns.adjust().draw();

		$('#scheduleTable').find("input:checkbox").on('click', function() {
			var $box = $(this);
			if ($box.is(":checked")) {
				var group = "input:checkbox[name='" + $box.attr("name") + "']";
				$(group).prop("checked", false);
				$box.prop("checked", true);
			} else {
				$box.prop("checked", false);
			}
		});
	}

	function getLogData(dateElement, definitionData){
		let newStartDate = '';
		let newStartTime = '';
		let newEndDate = '';
		let newEndTime = '';

		let dTable = $("#scheduleTable").DataTable();
		let tr = $("#scheduleTable").find("tbody tr.selected");
		let rowData;
		let submitRulesId;


		dateElement.each(function(index, el){
			if(index === 0){
				if(!isEmpty($(this).val())){
					newStartDate = $(this).val().replaceAll("-", "");
				}
			} else if(index === 1){
				if(!isEmpty($(this).val())){
					newStartTime = $(this).wickedpicker('time').replace(/[^0-9]/g, '') + '00';
				}
			} else if(index === 2){
				if(!isEmpty($(this).val())){
					newEndDate = $(this).val().replaceAll("-", "");
				}
			} else if(index === 3){
				if(!isEmpty($(this).val())){
					newEndTime = $(this).wickedpicker('time').replace(/[^0-9]/g, '') + '00';
				}
			}
		});

		let option = {
			url: apiHost + "/batch-job-logs",
			type: "get",
			async: true,
			data: {
				startDate: newStartDate,
				startHHMMSS: newStartTime,
				endDate: newEndDate,
				endHHMMSS: newEndTime,
				limit: isEmpty(dateElement) ? 10 : 50,
			},
			beforeSend: function (jqXHR, settings) {
				$('#loadingCircle').show();
			}
		}


		if(tr.length > 0) {
			rowData = dTable.row(tr).data();
			submitRulesId = Number(rowData.id);
			option.data.submit_rule_id = submitRulesId;
		}

		$.ajax(option).done(function (json, textStatus, jqXHR) {
			var logTable = $('#logTable').DataTable({
				"aaData": json.log,
				"destroy": true,
				// "table-layout": "fixed",
				// "autoWidth": true,
				// "bAutoWidth": true,
				"bSearchable" : true,
				// "scrollX": true,
				// "sScrollX": "100%",
				// "sScrollXInner": "110%",
				"sScrollY": true,
				"scrollY": "720px",
				"bScrollCollapse": true,
				"pageLength": 100,
				// "bFilter": false, disabling this option will prevent table.search()
				"aaSorting": [[ 0, 'asc' ]],
				"bSortable": true,
				"order": [[ 1, 'asc' ]],
				"aoColumnDefs": [
					{
						"aTargets": [ 0 ],
						"bSortable": false,
						"orderable": false
					},
				],
				"aoColumns": [
					{
						"sTitle": "",
						"mData": "",
						"mRender": function ( data, type, full, rowIndex ) {
							return '<a class="chk-type" href="javascript:void(0); onclick=""><input type="checkbox" id="' + full.job_id + '" name="' + full.job_id + '"><label for="' + full.job_id + '"></label></a>'
						},
						"className": "dt-body-center"
					},
					{
						"sTitle": "순번",
						"mData": "",
						"mRender": function ( data, type, full, rowIndex ) {
							return rowIndex.row + 1
						},
						"className": "dt-body-center"
					},
					// {
					// 	"sTitle": "작업명",
					// 	"mData": "",
					// 	"mRender": function ( data, type, full, rowIndex ) {
					// 		return full.name;
					// 	},
					// 	"className": "dt-body-center"
					// },
					{
						"sTitle": "작업자",
						"mData": "",
						"mRender": function ( data, type, full, rowIndex ) {
							let personOnDuty = '';			
							let found = definitionData.findIndex( x => x.id === full.definition_id);

							if(found > -1){
								let scheduleName = definitionData[found].name;
								personOnDuty = scheduleName + ' (id: ' + full.definition_id + ')';
							} else {
								personOnDuty = 'id: ' + full.definition_id;
							}
							return personOnDuty;
						} 
					},
					{
						"sTitle": "실행시간",
						"mData": "",
						"mRender": function ( data, type, full, rowIndex ) {
							let temp = new Date(full.started_at).format('yyyy-MM-dd HH:mm:ss');
							return temp;
						},
					},
					{
						"sTitle": "결과",
						"mData":"",
						"mRender": function ( data, type, full, rowIndex ) {
							let result = '';
							if( full.was_successful == true ){
								result = "성공"
							} else {
								result = "실패"
							}
							return result;
						}
					},
					{
						"sTitle": "실행 명령어",
						"mData":"",
						"mRender": function ( data, type, full, rowIndex ) {
							let str1 = '';
							if( full.executed_command.length > 50 ){
								let trimmed1 = full.executed_command.substring(0, 51) + ' ...'
								str1 = `
									<div class="flex-start">${'${ trimmed1 }'}&ensp;
										<a href="#" role="button" data-toggle="popover" data-placement="bottom" rel="popover" onclick='return false' onmouseover="updateInfo('detail', null, this)" class="text-link">more</a>
										<button type="button" class="text-link" onclick='copyText(this, "executed_command")'>복사</button>
									</div>`
							} else {
								str1 = full.executed_command;
							}
							return str1;
						}
					},
					{
						"sTitle": "로그",
						"mData":"",
						"mRender": function ( data, type, full, rowIndex ) {
							let str2 = '';
							if( full.stdout.length > 50 ){
								let trimmed2 = full.stdout.substring(0, 51) + ' ...'
								str2 = `
									<div class="flex-start">${'${ trimmed2 }'}&ensp;
										<a href="#" role="button" data-toggle="popover" data-placement="bottom" rel="popover" onclick='return false' onmouseover="updateInfo('detail', null, this)" class="text-link">more</a>
										<button type="button" class="text-link" onclick='downloadLog(event, this, "stdout")'>다운로드</button>
									</div>`
							} else {
								str2 = full.stdout;
							}
							return str2;
						}
					},
				],
				"dom": 'tip',
				"language": {
					"paginate": {
						"previous": "",
						"next": "",
					},
					"info": "_PAGE_ - _PAGES_ " + " / 총 _PAGES_ 개",
					"select": {
						"rows": {
							_: "",
							1: ""
						}
					}
				},
				"select": {
					style: 'single',
					selector: 'td input[type="checkbox"], td:not(:nth-child(6))'
				},
				initComplete: function(settings, json ){
					let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateInfo('add')">로그 저장</button>`;
					this.api().columns().header().each ((el, i) => {
						if(i == 0){
							$(el).attr ('style', 'min-width: 50px');
						}
					});
				},
				// every time DataTables performs a draw
				drawCallback: function (settings) {
					$('#logTable_wrapper').addClass('my-20');
				}
			}).on("select", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn-type03");
				btn.each(function(index, element){
					if($(this).is(":disabled")){
						$(this).prop("disabled", false);
					}
				});
				logTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
				// console.log("dt---", scheduleTable[ type ]( indexes ).nodes())
			}).on("deselect", function(e, dt, type, indexes) {
				let btn = $("#btnGroup").find(".btn-type03");
				btn.each(function(index, element){
					if(!$(this).is(":disabled")){
						$(this).prop("disabled", true);
					}
				});
				logTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
				// console.log("dt---", scheduleTable[ type ]( indexes ).nodes())
			}).columns.adjust().draw();

			new $.fn.dataTable.Buttons( logTable, {
				name: 'commands',
				"buttons": [
					{
						extend: 'excelHtml5',
						className: "btn-save",
						text: '엑셀 다운로드',
						filename: '사용자관리_' + new Date().format('yyyyMMddHHmmss'),

						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
							$('row:first c', sheet).attr( 's', '42' );
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
						}
					},
				],
			});

			logTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");

			$('#logTable').parent().on('scroll', function() {
				console.log("scrolling===")
				let popOver = $(".popover");
				popOver.popover('hide');
			});
			
			$('#logTable').find("input:checkbox").on('click', function() {
				var $box = $(this);
				if ($box.is(":checked")) {
					var group = "input:checkbox[name='" + $box.attr("name") + "']";
					$(group).prop("checked", false);
					$box.prop("checked", true);
				} else {
					$box.prop("checked", false);
				}
			});
			
			logTable.on( 'column-sizing.dt', function ( e, settings ) {
				$(".dataTables_scrollHeadInner").css( "width", "100%" );
			});

		}).fail(function (jqXHR, textStatus, errorThrown) {
			let resultFailText = "로그데이터를 가져 오는 데, 실패하였습니다.";
			let errorMsg = resultFailText + "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText;
			showAjaxResultModal("ajaxResultModal", null, null, errorMsg);
			return false;
		});
		// }).fail(function (jqXHR, textStatus, errorThrown) {
		// 	let resultFailText = "해당 스케쥴 queue 데이터 호출에 실패하였습니다.";
		// 	let errorMsg = resultFailText + "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText;
		// 	showAjaxResultModal("ajaxResultModal", null, null, errorMsg);
		// 	return false;
		// });
	}

	function initDetails(){
		let form = $("#updateScheduleForm");
		let input = form.find("input[type='text']");
		let radio = form.find("input[type='radio']");
		let dropdownBtn = form.find(".dropdown-toggle");
		let warning = form.find(".warning");

		$("#updateScheduleForm").removeClass("now");
		$("#addScheduleBtn").prop("disabled", true).removeClass("hidden");
		$("#argumentParam").val("");

		warning.addClass("hidden");

		input.each(function(){
			if($(this).val() == "0" && !$(this).is(":checked")){
				$(this).prop("checked", true);
			}
			$(this).val("").prop("disabled", false).parent().removeClass("disabled");
		});

		radio.each(function(){
			if($(this).val() == "0" && !$(this).is(":checked")){
				$(this).prop("checked", true);
			} else {
				$(this).prop("checked", true);
			}
		});

		$.each(dropdownBtn, function(index, element){
			$(this).data({ "value": "", "vol-type": "", "plan-id" : "" }).html('선택' + '<span class="caret"></span>').prop("disabled", false);
			$(this).next().find("li").removeClass("hidden");
		});
	}
	
	function updateInfo(option, callback, popOverLink){
		let form = $("#updateScheduleForm");
		let required = form.find(".asterisk");
		let addBtn = $("#addScheduleBtn");
		let tr = $("#scheduleTable").find("tbody tr.selected");
		
		if(option == "add"){
		// ADD MODAL!!!
			form.hasClass("edit") ? form.removeClass("edit") : null;
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			addBtn.text("추가");
			addBtn.prev().prop("disabled", true);
			addBtn.parent().prev().prop("disabled", true).addClass("disabled");
			
			tr.find("input:checked").prop("checked", false);
			tr.removeClass("selected");
			initDetails();
		} else {
			let dTable = $("#scheduleTable").DataTable();
			
			let td = tr.find("td");
			let rowData = dTable.row(tr).data();

			if(option == "edit") {
			// EDIT MODAL!!!
				let input = form.find("input");
				let dropdownBtn = form.find(".dropdown-toggle");

				$("#scheduleList").prev().data({ "value": rowData.id, "definition-id": rowData.definition_id }).contents().get(0).nodeValue = rowData.batchJobDefinition.name;
				$("#taskName").val(rowData.name);
				$("#scheduleCycle").val(rowData.schedule);
				if(!isEmpty(rowData.batchJobDefinition.cpu)){
					$("#cpuVol").val(rowData.batchJobDefinition.cpu);
				}
				if(!isEmpty(rowData.batchJobDefinition.mem)){
					$("#ramVol").val(rowData.batchJobDefinition.mem);
				}
				if(!isEmpty(rowData.batchJobDefinition.gpu)){
					$("#gpuVol").val(rowData.batchJobDefinition.gpu);
				}
				if(rowData.batchJobDefinition.is_distribution_needed === 1){
					$("#isDistributed").prop("checked", true);
				} else {
					$("#notDistributed").prop("checked", true);
				}

				if(rowData.batchJobDefinition.is_valid === 1){
					$("#toProceed").prop("checked", true);
				} else {
					$("#onHold").prop("checked", true);
				}
				if(!isEmpty(rowData.args)){
					$("#argumentParam").val(rowData.args);
				}
				addBtn.prop("disabled", false).text("수정");

				$("#updateScheduleForm").addClass("edit");
			}
			
			if(option == "detail") {
				let logTable = $("#logTable").DataTable();
				// PopOver content setup
				let popOverRow = $(popOverLink).parents().closest("tr");
				let cell = $(popOverLink).parents().closest("td");
				let popOverData = logTable.row(popOverRow).data();
				let content = '';

				if(cell.index() == 5){
					content = '<div class="word-wrap">' + popOverData.executed_command + '</div>';
				} else if(cell.index() == 6){
					content = '<div class="word-wrap">' + popOverData.stdout + '</div>';
				}

				var popWindow = $(popOverLink).popover({
					container: "body",
					placement : 'bottom',
					html: 'true',
					trigger: "manual",
					// "focus", "manual", "focus", "hover"
					animation: false,
					title: '',
					content: content
				}).on("mouseover", function () {
					var _this = this;
					$(this).popover("show");
					$(this).siblings(".popover").on("mouseleave", function () {
						if ($(".popover:visible").length > 1) {
							$(_this).popover('hide');
						}
					});
				}).on("mouseleave", function(){
					var _this = this;
					setTimeout(function() {
						if ($(".popover:visible").length > 1) {
							$(".popover").not(_this).popover('hide');
						}
						if($("#logTable").find("tbody tr.selected").length > 0){
							$(".popover").popover('hide');
						}
					}, 200);
				});

				popWindow.popover("show");
			}

			// DELETE MODAL!!!
			if(option == "delete") {
				let scheduleName = td.eq(2).text();
				let modal = $("#deleteConfirmModal");
				let deleteBtn = $("#deleteConfirmBtn");
				let confirmSchedule = $("#confirmSchedule");

				$("#deleteSuccessMsg span").text(scheduleName);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmSchedule.on("input", function() {
					if($(this).val() !== scheduleName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmSchedule.on("keyup", function() {
					if($(this).val() !== scheduleName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});
			}
		}

	}

	function validateForm(){
		if($("#updateScheduleForm").hasClass('edit')){
			$("#addSiteBtn").prop("disabled", false);
		} else {
			let warning = $("#updateScheduleForm").find(".warning");
			// console.log("scheduleName===", $("#taskName").val() )
			// console.log("scheduleCycle===", $("#scheduleCycle").val() )
			// console.log("warning===", warning.length )
			// console.log("not hidden===", warning.not(".hidden").length );

			if(!isEmpty($("#taskName").val()) && !isEmpty($("#scheduleCycle").val()) && warning.not(".hidden").length === 0 ){
				$("#addScheduleBtn").prop("disabled", false);
			} else {
				$("#addScheduleBtn").prop("disabled", true);
			}

		}
	}

	function submitSchedule(event, self) {
		event.preventDefault();

		let elAttr = !isEmpty(self) ? $(elAttr).is("a") : null;
		let newScheduleCycle = $("#scheduleCycle").val().replaceAll("\\s+$", "");
		let newOptionDistributed = $("input[name='option_distributed']:checked").val();
		let newOptionHold = Number($("input[name='option_hold']:checked").val());
		let newArgumentParam = $("#argumentParam").val().replace(/\t+/g,'');
		let newCpuVol = Number($("#cpuVol").val().replaceAll(",", ""));
		let newRamVol = Number($("#ramVol").val().replaceAll(",", ""));
		let newGpuVol = Number($("#gpuVol").val().replaceAll(",", ""));
		let submitRulesId = $("#scheduleList").prev().data("value");
		let obj = {};

		obj.definition_id = $("#scheduleList").prev().data("definition-id");
		obj.name = $("#taskName").val();

		if(!$("#updateScheduleForm").hasClass("edit")) {
		// 1. ADD!!!
			let resultSuccessText = "배치 스케줄 추가 성공 하였습니다.";
			let resultFailText = "배치 스케줄 추가 실패 하였습니다.<br>다시 시도해 주세요.";

			obj.schedule = newScheduleCycle;

			if(!isEmpty(newArgumentParam)){
				obj.args = newArgumentParam;
			}
			if(!isEmpty(newOptionHold)){
				obj.is_valid = newOptionHold;
			}
			obj.created_by = loginId + ":" + loginName;

			if(elAttr == true) {
			// 1-A. ADD to a Queue
				if(isEmpty(obj.definition_id) || submitRulesId) {
					$("#isRequiredMissing").removeClass("hidden");
					setTimeout(function(){
						$("#isRequiredMissing").addClass("hidden");
					}, 1500);
					return false;
				}

				// let queObj = {
				// 	definition_id: obj.definition_id,
				// 	submit_rule_id: submitRulesId
				// };

				// if( !isEmpty(newOptionDistributed)){
				// 	queObj.is_distribution_needed = newOptionDistributed;
				// }
				// if(!isEmpty(newCpuVol)){
				// 	queObj.batchJobDefinition = {
				// 		cpu: newCpuVol
				// 	}
				// }
				// if(!isEmpty(newRamVol)){
				// 	queObj.batchJobDefinition = {
				// 		mem: newRamVol
				// 	}
				// }
				// if(!isEmpty(newGpuVol)){
				// 	queObj.batchJobDefinition = {
				// 		gpu: newGpuVol
				// 	}
				// }

				// let queObj = {
				// 	id: 0,
				// 	definition_id: 0,
				// 	submit_rule_id: 0,
				// 	was_manual_submit: 0,
				// 	command: "string",
				// 	server_group_id: 0,
				// 	priority: "2",
				// 	cpu: "80",
				// 	mem: "200",
				// 	gpu: "80",
				// 	created_at": 0,
				// 	created_by": "string",
				// 	processed_at": 0,
				// 	processed_by": "string",
				// 	was_successful": 0
				// }
				
				// "definition_id": 0,
				// "submit_rule_id": 0,
				// "was_manual_submit": 0,
				// "command": "string",
				// "server_group_id": 0,
				// "priority": "2",
				// "cpu": "80",
				// "mem": "200",
				// "gpu": "80",
				// "created_by": "string",
				// "processed_at": 0,
				// "processed_by": "string"

				// let queueOpt = {
				// 	url: apiHost + "/batch-job-queues",
				// 	type: "post",
				// 	// type: "patch",
				// 	async: true,
				// 	dataType: 'json',
				// 	contentType: "application/json",
				// 	data: JSON.stringify(queObj)
				// }

				
				// console.log("queObj---", queObj);
				// console.log("obj---", obj);
				// $.ajax(queueOpt).done(function (json, textStatus, jqXHR) {
				// 	showAjaxResultModal("ajaxResultModal", null, "1", resultSuccessText, 1600);
				// 	getData("refresh");
				// }).fail(function (jqXHR, textStatus, errorThrown) {
				// 	let errorMsg = resultFailText + "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText;
				// 	showAjaxResultModal("ajaxResultModal", null, "0", errorMsg);
				// });		

			} else {
			// 1-B. ADD schedule info
				let scheduleOption = {
					url: apiHost + "/batch-job-submit-rules",
					type: "post",
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(obj)
				}

				console.log("ADD schedule obj---", obj);
				$.ajax(scheduleOption).done(function (json, textStatus, jqXHR) {
					showAjaxResultModal("ajaxResultModal", null, "1", resultSuccessText, 1600);
					getData("schedule");
				}).fail(function (jqXHR, textStatus, errorThrown) {
					let errorMsg = resultFailText + "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText;
					showAjaxResultModal("ajaxResultModal", null, "0", errorMsg);
				});					
			}
		} else {
		// 2. EDIT!!!
			let resultSuccessText = "배치 스케줄 수정에 성공 하였습니다.";
			let resultFailText = "배치 스케줄 수정에 실패 하였습니다.<br>다시 시도해 주세요.";

			let dTable = $("#scheduleTable").DataTable();
			let tr = $("#scheduleTable").find("tbody tr.selected");
			let rowData = dTable.row(tr).data();

			if(elAttr == true) {
			// 2-A. Add to a BATCH QUEUE: RUN NOW
				if(isEmpty(obj.definition_id) || isEmpty(submitRulesId)) {
					$("#isRequiredMissing").removeClass("hidden");
					setTimeout(function(){
						$("#isRequiredMissing").addClass("hidden");
					}, 1500);
					return false;
				}

				let queObj = {
					definition_id: obj.definition_id,
					submit_rule_id: submitRulesId,
					was_manual_submit: 1,
					command: rowData.batchJobDefinition.command,
					server_group_id: rowData.batchJobDefinition.server_group_id,
					priority: rowData.priority
				};

				if(!isEmpty(newCpuVol)){
					queObj.cpu = newCpuVol;
				} else {
					$("#hasCpu").parent().removeClass("hidden");
					setTimeout(function(){
						$("#hasCpu").parent().addClass("hidden");
					}, 1200);
					return false;
				}

				if(!isEmpty(newRamVol)){
					queObj.mem = newRamVol;
				} else {
					$("#hasRam").parent().removeClass("hidden");
					setTimeout(function(){
						$("#hasRam").parent().addClass("hidden");
					}, 1200);
					return false;
				}

				if(!isEmpty(newGpuVol)){
					queObj.gpu = newGpuVol;
				} else {
					$("#hasGpu").parent().removeClass("hidden");
					setTimeout(function(){
						$("#hasGpu").parent().addClass("hidden");
					}, 1200);
					return false;
				}

				let queueOpt = {
					url: apiHost + "/batch-job-queues",
					type: "post",
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(queObj)
				}

				$.ajax(queueOpt).done(function (json, textStatus, jqXHR) {
					showAjaxResultModal("ajaxResultModal", null, "1", resultSuccessText, 1600);
					getData("refresh");
				}).fail(function (jqXHR, textStatus, errorThrown) {
					let errorMsg = resultFailText + "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText;
					showAjaxResultModal("ajaxResultModal", null, "0", errorMsg);
				});	
			} else {
			// 2-B. Edit schedule info
				if(isEmpty(submitRulesId)) return false;
				
				if(rowData.batchJobDefinition.is_distribution_needed != newOptionDistributed ) {
					obj.batchJobDefinition = {
						is_distribution_needed: newOptionDistributed
					}
				}
				
				if(rowData.args != newArgumentParam){
					obj.args = newArgumentParam;
				}
				if(rowData.schedule != newScheduleCycle){
					obj.schedule = newScheduleCycle;
				}
				
				let scheduleOption = {
					url: apiHost + "/batch-job-submit-rules/" + submitRulesId,
					type: "patch",
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(obj)
				}

				$.ajax(scheduleOption).done(function (json, textStatus, jqXHR) {
					showAjaxResultModal("ajaxResultModal", null, "1", resultSuccessText, 1600);
					getData("refresh");
				}).fail(function (jqXHR, textStatus, errorThrown) {
					let errorMsg = resultFailText + "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText;
					showAjaxResultModal("ajaxResultModal", null, "0", errorMsg);
				});

			}
		}
	};

	function copyText(self, key){
		let dTable = $("#logTable").DataTable();
		let tr = $(self).parents().closest('tr');
		let rowData;
		if(key === "executed_command"){
			rowData = dTable.row(tr).data().executed_command;
		} else {
			rowData = dTable.row(tr).data().stdout;
		}
		const el = document.createElement('textarea');
		el.value = rowData;
		document.body.appendChild(el);
		el.select();
		document.execCommand('copy');
		document.body.removeChild(el);
	}

	function downloadLog(e, self, key){
		let dTable = $("#logTable").DataTable();
		let tr = $(self).parents().closest('tr');
		let rowData = dTable.row(tr).data();
		let jobId = rowData.job_id;

		if(isEmpty(jobId)) {
			let errorMsg = "해당 스케줄의 아이디가 존재하지 않습니다. 다른 스케줄로 시도해 주세요.";
			showAjaxResultModal("ajaxResultModal", null, null, errorMsg);
			return false;
		} else {

			// $(self).attr("href", link);
			let option = {
				url: apiHost + "/batch-job-logs/" + jobId + "/stdout",
				type: "get",
				beforeSend: function (jqXHR, settings) {
					$("#loadingCircle").show();
				},
				xhrFields: {
					responseType: 'blob'
				},
				async: true,
			};

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				let td = tr.find("td");
				let jobName = td.eq(2).text().split("(")[0];
				let tempDate = td.eq(3).text().split(/\b(\s)/);
				let tempYymmdd = tempDate[0].replaceAll("-", "");
				let tempHhmmdd = tempDate[2].replaceAll(":", "");
				let filename = jobName.trim() + "_" + tempYymmdd + "_" + tempHhmmdd;

				let blob = new Blob([json], {
					type: "text/plain;charset=utf-8"
				});
				saveAs(blob, filename);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				let resultFailText = "다운로드에 실패하였습니다."
				let errorMsg = resultFailText + "에러코드:" + jqXHR.status + "<br>" + "메세지: " + jqXHR.responseText;
				showAjaxResultModal("ajaxResultModal", null, null, errorMsg);
				console.log("fail==", jqXHR)
			});		
		}
	}
	

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">배치 관리</h1>
	</div>
</div>

<div class="row">
	<div class="col-xl-7 col-lg-7 col-md-6 col-sm-12">
		<div class="indiv schedule-content">
			<table id="scheduleTable">
				<colgroup>
					<col style="width:4%">
					<col style="width:8%">
					<col style="width:18%">
					<col style="width:18%">
					<col style="width:16%">
					<col style="width:18%">
					<col style="width:18%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
	<div class="col-xl-5 col-lg-5 col-md-6 col-sm-12">
		<div class="indiv schedule-content">
			<div class="row mt-15 mb-28">
				<div class="col-12">
					<h2 class="ntit">스케줄 상세 정보<span class="required fr">필수 입력 항목</span></h2>
				</div>
			</div>
			<form name="update_schedule_form" id="updateScheduleForm" class="setting-form" autocomplete="off">
				<div class="row">
					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label asterisk">스케줄 명</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="dropdown w-90">
							<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
							<ul id="scheduleList" class="dropdown-menu"></ul>
						</div>
						<small class="hidden warning">추가하실 스케줄 명을 선택해 주세요.</small>
					</div>
					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label asterisk">작업 명</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="text-input-type">
							<input type="text" name="schedule_name" id="taskName" placeholder="입력">
						</div>
						<small class="hidden warning">작업 명을 입력해 주새요.</small>
					</div>
				</div>

				<div class="row">
					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label asterisk">실행 주기</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="text-input-type w-90">
							<input type="text" name="schedule_cycle" id="scheduleCycle" class="digit" placeholder="입력" minlength="1" maxlength="12">
						</div>
					</div>
					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">임시중단 여부</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="flex-start">
							<div class="radio-type">
								<input type="radio" name="option_hold" id="toProceed" value="1" checked>
								<label for="toProceed">진행</label>
							</div>
							<div class="radio-type ml-30">
								<input type="radio" name="option_hold" id="onHold" value="0">
								<label for="onHold">중단</label>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">실행 파라미터</span></div>
					<div class="col-xl-10 col-lg-10 col-md-8 col-sm-7">
						<textarea name="argument_param" id="argumentParam" class="textarea" placeholder="입력"></textarea>
					</div>
				</div>

				<div class="row border">
					<div class="col-12">
						<h3 class="stit">추가/수정 시에는 반영 되지 않습니다.</h3>
					</div>
				</div>

				<div class="row">
					<div class="col-xl-2 col-lg-2 col-md-3 col-sm-5"><span class="input-label">CPU 요구사항</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="text-input-type unit">
							<input type="text" name="cpu_vol" id="cpuVol" class="digit" placeholder="입력" minlength="2" maxlength="9">
							<span>&#37;</span>
						</div>
						<div class="flex-start mt-12 hidden">
							<small id="hasCpu" class="warning-text">즉시 실행 시, cpu 용량은 필수 값 입니다.</small>
						</div>
					</div>

					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">메모리 요구사항</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="text-input-type unit">
							<input type="text" name="disk_vol" id="ramVol" class="digit" placeholder="입력" maxlength="9">
							<span>MB</span>
						</div>
						<div class="flex-start mt-12 hidden">
							<small id="hasRam" class="warning-text">즉시 실행 시, 메모리는 필수 값 입니다.</small>
						</div>
					</div>

					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">GPU 요구사항</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="text-input-type unit">
							<input type="text" name="gpu_vol" id="gpuVol" class="digit" placeholder="입력" maxlength="9">
							<span>&#37;</span>
						</div>
						<div class="flex-start mt-12 hidden">
							<small id="hasGpu" class="warning-text">즉시 실행 시, gpu 용량은 필수 값 입니다.</small>
						</div>
					</div>
				</div>
		
				<div class="row">
					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">작업 분배기</span></div>
					<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
						<div class="flex-start">
							<div class="radio-type fixed-height">
								<input type="radio" name="option_distributed" id="isDistributed" value="1">
								<label for="isDistributed">예</label>
							</div>
							<div class="radio-type fixed-height">
								<input type="radio" name="option_distributed" id="notDistributed" value="0" checked>
								<label for="notDistributed">아니오</label>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5 py-0"></div>
					<div class="col-xl-10 col-lg-10 col-md-8 col-sm-7 py-0">
						<textarea name="getter_query" id="getterQuery" class="textarea" placeholder="입력"></textarea>
					</div>
				</div>

				<div class="row">
					<div class="col-12">
						<small id="isRequiredMissing" class="warning-text hidden">필수 항목 값 입력은 필수 입니다.</small>
					</div>
				</div>
				
				<div class="row pt-20">
					<div class="col-12">
						<div id="btnGroup" class="flex-wrapper">
							<a href="#" class="btn-type04 text-blue disabled" onclick="submitSchedule(event, this)"  disabled>즉시 실행</a>
							<div class="btn-wrap-type02"><!--
							--><button type="button" class="btn-type03" onclick="updateInfo('delete')" disabled>삭제</button><!--
							--><button type="button" id="addScheduleBtn" class="btn-type" onclick="submitSchedule(event)" disabled>추가</button><!--
						--></div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	
</div>

<div class="row">
	<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12">
		<div class="indiv">
			<div class="flex-group">
				<span class="tx-tit">기간 설정</span>
				<div class="sel-calendar">
					<input type="text" name="fromDate" id="fromDate" class="sel fromDate" value="" autocomplete="off"><img class="ui-datepicker-trigger" src="" alt="..." title="...">
					<em></em>
					<input type="text" id="timepicker1" name="timepicker1" class="sel timepicker hasWickedpicker" onkeypress="return false;" aria-showingpicker="false" tabindex="0">
					<em></em>
					<input type="text" name="toDate" id="toDate" class="sel toDate" value="" autocomplete="off"><img class="ui-datepicker-trigger" src="" alt="..." title="...">
					<em></em>
					<input type="text" id="timepicker2" name="timepicker2" class="sel timepicker hasWickedpicker" onkeypress="return false;" aria-showingpicker="false" tabindex="0">
				</div>
				<button type="button" id="getLogBtn" class="btn-type ml-16" onclick="getData('log', $(this).prev().find('input'));">검색</button>
			</div>
			<div class="flex-start mt-8">
				<small id="isInvalidPeriod" class="warning-text hidden">검색 시작 일자는 종료일과 동일하거나 이전날짜로 선택해 주세요.</small>
			</div>
			<div id="exportBtnGroup" class="fr"></div>

			<table id="logTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:6%">
					<!-- <col style="width:8%"> -->
					<col style="width:12%">
					<col style="width:12%">
					<col style="width:5%">
					<!-- <col style="width:26%">
					<col style="width:26%"> -->
					<col style="width:30%">
					<col style="width:30%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>

<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="deleteConfirmModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit">배치 스케줄 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" name="confirm_schedule" id="confirmSchedule" placeholder="사이트 이름 입력"/></div>
			</div>
			<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w-80px" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn-type w-80px ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>