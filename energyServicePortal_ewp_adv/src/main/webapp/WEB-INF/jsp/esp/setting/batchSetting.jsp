<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script type="text/javascript">
	
	$(function () {
		let d = new Date();
		let yesterday = new Date(d.getFullYear(), d.getMonth(), d.getDate()-1);
		let currentTime = new Date().format('HH:mm');
		let yesterdayTime = new Date(Date.now() - 86400 * 1000);


		$('#fromDate').datepicker().datepicker("setDate", yesterday);
		$('#toDate').datepicker().datepicker("setDate", new Date());

		$('#timepicker1').wickedpicker({
			'defaultTime': new Date(yesterday).format('HH:mm'),
			now: currentTime, twentyFour: true
		});

		$('#timepicker2').wickedpicker({
			now: currentTime, twentyFour: true
		});

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
		
		$("#runNowBtn").on("click", $("#addScheduleModal").addClass("now") );
		// Form Submission !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

		$("#addScheduleModal").on("hide.bs.modal", function() {
			$(this).hasClass("edit") ? $(this).removeClass("edit") : null;
			initModal();
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

		$("#resultModal").on("hide.bs.modal", function() {
			$(this).find("h4").addClass("hidden");
		});

	});

	function getData(option){
		let optionList = [
			{
				url: apiHost + "/batch-job-definitions",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/batch-job-submit-rules?includeBatchJobDefinition=true&limit=50",
				type: "get",
				async: true,
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
				}
			}
		];
	
		if(option == "schedule"){
			$.ajax(optionList[1]).done(function (json, textStatus, jqXHR) {
				$('#scheduleTable').DataTable().destroy();
				getScheduleData(null, json);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("fail==", jqXHR)
			});

		} else if(option === "log") {

		} else {
			Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])) ]).then(res => {
				let definitionData = res[0];
				let scheduleData = res[1];
				let str = '';

				getScheduleData(definitionData, scheduleData);
				getLogData(null, definitionData, scheduleData, option);

				definitionData.forEach((item, index) => {
					let found = scheduleData.findIndex( x => x.batchJobDefinition.id === item.id);
					if(found > -1){
						let scheduleName = scheduleData[found].name;
						let taskId = scheduleData[found].id;
						let taskName = scheduleData[found].name;
						
						if(!isEmpty(option)){		
							str += '<li data-value="' + item.id + '" data-task="' + taskName + '" data-task-id="' + taskId + '"><a href="#">' + item.name + '</a></li>'
						}
					} else {
						str += '<li data-value="' + item.id + '" data-task="" data-task-id=""><a href="#">' + item.name + '</a></li>'
					}
				});

				$("#scheduleList").append(str);
				$("#scheduleList li").on("click", function(){
					let val = $(this).data("value");
					$("#scheduleList").prev().data("value", val);

					let warning = $("#scheduleList").parents().closest(".dropdown").next();
					if( !warning.hasClass("hidden")){
						warning.addClass("hidden");
					}
					setTimeout(function(){
						validateForm();
					}, 200);
				});

			});
		}

	}

	function getScheduleData(definitionData, scheduleData) {

		var scheduleTable = $('#scheduleTable').DataTable({
			"aaData": scheduleData,
			"destroy": true,
			"table-layout": "fixed",
			"fixedHeader": true,
			"bAutoWidth": true,
			"bSearchable" : true,
			// "scrollX": true,
			// "sScrollX": "100%",
			// "sScrollXInner": "110%",
			"sScrollY": true,
			"scrollY": "720px",
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
						return '<a class="chk-type" href="#" onclick="return false"><input type="checkbox" id="' + full.id + '" name="' + full.id + '"><label for="' + full.id + '"></label></a>'
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
			"select": {
				style: 'single',
				selector: 'td:not(:first-child)'
			},
			initComplete: function(settings, json ){
				let str = `<div id="btnGroup" class="right-end"><!--
					--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')">선택 수정</button><!--
					--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')">선택 삭제</button><!--
				--></div>`;

				let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')">신규 등록</button>`;
				$("#scheduleTable_wrapper").append($(str)).prepend($(addBtnStr));
				this.api().columns().header().each ((el, i) => {
					if(i == 0){
						$(el).attr ('style', 'min-width: 50px');
					}
				});
			},
			// every time DataTables performs a draw
			drawCallback: function (settings) {
				$('#scheduleTable_wrapper').addClass('mb-28');
			}
		}).on("select", function(e, dt, type, indexes) {
			let btn = $("#btnGroup").find(".btn-type03");
			btn.each(function(index, element){
				if($(this).is(":disabled")){
					$(this).prop("disabled", false);
				}
			});
			scheduleTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
			// console.log("dt---", scheduleTable[ type ]( indexes ).nodes())
		}).on("deselect", function(e, dt, type, indexes) {		
			let btn = $("#btnGroup").find(".btn-type03");
			btn.each(function(index, element){
				if(!$(this).is(":disabled")){
					$(this).prop("disabled", true);
				}
			});
			scheduleTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
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

		showChildData(scheduleTable);

	}

	function getLogData(dateElement, definitionData, scheduleData, flag){
		let newStartDate = '';
		let newStartTime = '';
		let newEndDate = '';
		let newEndTime = '';
		let dropdownStr = '';

		if(isEmpty(dateElement)){
			let today = new Date();
			newStartDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()-1).format('yyyyMMdd');
			newStartTime = today.format('HHmmss');
			newEndDate = today.format('yyyyMMdd');
			newEndTime = today.format('HHmmss');
		} else {
			dateElement.each(function(index, el){
				if(index === 0){
					if(!isEmpty($(this).val())){
						newStartDate = $(this).val().replaceAll("-", "");
					}
				} else if(index === 1){
					if(!isEmpty($(this).val())){
						newStartTime = $(this).val().replaceAll(":", "");
					}
				} else if(index === 2){
					if(!isEmpty($(this).val())){
						newEndDate = $(this).val().replaceAll("-", "");
					}
				} else if(index === 3){
					if(!isEmpty($(this).val())){
						newEndTime = $(this).val().replaceAll(":", "");
					}
				}
			});
		}

		let option = {
			url: apiHost + "/batch-job-logs",
			type: "get",
			async: true,
			data: {
				startDate: newStartDate,
				startHHMMSS: newStartTime,
				endDate: newEndDate,
				endHHMMSS: newEndTime,
			}
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
								str1 = `<div class="flex-start">${'${ trimmed1 }'}&ensp;<a href="#" role="button" data-toggle="popover" data-placement="bottom" rel="popover" onclick='return false' onmouseover="updateModal('detail', null, this)" class="text-link">more</a></div>`
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
								str2 = `<div class="flex-start">${'${ trimmed2 }'}&ensp;<a href="#" role="button" data-toggle="popover" data-placement="bottom" rel="popover" onclick='return false' onmouseover="updateModal('detail', null, this)" class="text-link">more</a></div>`
							} else {
								str2 = full.stdout;
							}
							return str2;
						}
					},
				],
				"dom": 'tip',
				"select": {
					style: 'single',
					selector: 'td input[type="checkbox"], tr'
				},
				initComplete: function(settings, json ){
					let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')">로그 저장</button>`;
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
						// exportOptions: {
						// 	modifier: {
						// 		page: 'current'
						// 	}
						// },
						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
							$('row:first c', sheet).attr( 's', '42' );
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
							// var lastCol = sheet.getElementsByTagName('col').length - 1;
							// var colRange = createCellPos( lastCol ) + '1';
							// //Has to be done this way to avoid creation of unwanted namespace atributes.
							// var afSerializer = new XMLSerializer();
							// var xmlString = afSerializer.serializeToString(sheet);
							// var parser = new DOMParser();
							// var xmlDoc = parser.parseFromString(xmlString,'text/xml');
							// var xlsxFilter = xmlDoc.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main','autoFilter');
							// var filterAttr = xmlDoc.createAttribute('ref');
							// filterAttr.value = 'A1:' + colRange;
							// xlsxFilter.setAttributeNode(filterAttr);
							// sheet.getElementsByTagName('worksheet')[0].appendChild(xlsxFilter);

						}
					},
				],
			});

			logTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");


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
		});
	}

	function initModal(){
		let form = $("#updateScheduleForm");
		let input = form.find("input[type='text']");
		let radio = form.find("input[type='radio']");
		let dropdownBtn = form.find(".dropdown-toggle");
		let warning = form.find(".warning");

		$("#addScheduleModal").removeClass("now");
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
	
	function updateModal(option, callback, popOverLink){
		let titleAdd = $('#titleAdd');
		let form = $("#updateScheduleForm");
		let required = form.find(".asterisk");
		let addBtn = $("#addScheduleBtn");

		// ADD MODAL!!!
		if(option == "add"){
			initModal();
			titleAdd.removeClass("hidden").next().addClass("hidden");
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			addBtn.text("추가");

			$("#addScheduleModal").removeClass("edit").modal("show");
		} else {
			let dTable = $("#scheduleTable").DataTable();
			let tr = $("#scheduleTable").find("tbody tr.selected");
			let td = tr.find("td");
			let rowData = dTable.row(tr).data();

			// EDIT MODAL!!!
			if(option == "edit") {
				let input = form.find("input");
				let dropdownBtn = form.find(".dropdown-toggle");

				$("#scheduleList").prev().html(rowData.batchJobDefinition.name + '<span class="caret"></span>').data("value", rowData.definition_id);
				$("#taskName").val(rowData.name);
				$("#scheduleCycle").val(rowData.schedule);
				if(!isEmpty(rowData.batchJobDefinition.cpu)){
					$("#cpuVol").val(rowData.batchJobDefinition.cpu);
				}
				if(!isEmpty(rowData.batchJobDefinition.mem)){
					$("#diskVol").val(rowData.batchJobDefinition.mem);
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

				titleAdd.addClass("hidden").next().removeClass("hidden");
				addBtn.prop("disabled", false).text("수정");

				$("#addScheduleModal").addClass("edit").modal("show");
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
					}, 300);
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

	function format ( trData ) {
		console.log("trData---", trData);
		let isDistributed = trData.batchJobDefinition.is_distribution_needed;
		let isValid = '';
		(trData.is_valid == 0) ? (isValid = '중단') : (isValid = '진행');
		let cpuVol = trData.cpu;
		let diskVol = trData.mem;
		let gpuVol = trData.gpu;
		let argumentParam = trData.args;

		return  '<div class="ml-36 pl-40">' +
			'<div class="w-90 mb-10">작업분배기: ' + isDistributed + '   임시중단 여부: ' + isValid + '</div>' +
			'<div class="w-90 mb-10">CPU 요구사항: ' + cpuVol + '%   메모리 요구사항: ' + diskVol + 'MB   GPU 요구사항: ' + gpuVol + '%</div>' +
			'<div class="w-90">실행 파라미터: ' + argumentParam + '</div>' +
		'</div>'
	}

	function validateForm(){
		if($("#addScheduleModal").hasClass('edit')){
			$("#addSiteBtn").prop("disabled", false);
		} else {
			let warning = $("#addScheduleModal").find(".warning");
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

	function submitSchedule(e, runNow) {
		e.preventDefault();
		
		let newScheduleCycle = $("#scheduleCycle").val().replaceAll("\\s+$", "");
		let newOptionDistributed = $("input[name='option_distributed']:checked").val();
		let newOptionHold = Number($("input[name='option_hold']:checked").val());
		let newArgumentParam = $("#argumentParam").val().replace(/\t+/g,'');
		let newCpuVol = $("#cpuVol").val().replaceAll(",", "");
		let newDiskVol = $("#diskVol").val().replaceAll(",", "");
		let newGpuVol = $("#gpuVol").val().replaceAll(",", "");

		let obj = {};

		obj.definition_id = $("#scheduleList").prev().data("value");
		obj.name = $("#taskName").val();
		// console.log("now---", runNow);

		if(!$("#addScheduleModal").hasClass("edit")) {
			// 1. ADD schedule info
			obj.schedule = newScheduleCycle;

			if(!isEmpty(newArgumentParam)){
				obj.args = newArgumentParam;
			}
			if(!isEmpty(newOptionHold)){
				obj.is_valid = newOptionHold;
			}
			obj.created_by = loginId + ":" + loginName;

			if(!isEmpty(runNow)) {
				if( !isEmpty(newOptionDistributed)){
					obj.is_distribution_needed = newOptionDistributed;
				}
				if(!isEmpty(newCpuVol)){
					obj.batchJobDefinition = {
						cpu: newCpuVol
					}
				}
				if(!isEmpty(newDiskVol)){
					obj.batchJobDefinition = {
						mem: newDiskVol
					}
				}
				if(!isEmpty(newGpuVol)){
					obj.batchJobDefinition = {
						gpu: newGpuVol
					}
				}
			} else {
				let option = {
					url: apiHost + "/batch-job-submit-rules",
					type: "post",
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(obj)
				}

				console.log("obj---", obj);
				$.ajax(option).done(function (json, textStatus, jqXHR) {
					$("#addScheduleModal").modal("hide");
					$("#resultSuccessMsg").removeClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						getData("schedule");
						$("#resultModal").modal("hide");
					}, 1600);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					$("#addScheduleModal").modal("hide");
					$("#resultFailureMsg").text("배치 스케줄 추가에 실패했습니다. 다시 시도해 주세요.").removeClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 1600);
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});
									
			}
		} else {
			let dTable = $("#scheduleTable").DataTable();
			let tr = $("#scheduleTable").find("tbody tr.selected");
			let rowData = dTable.row(tr).data();
			let scheduleId = rowData.id;

			// 2. EDIT schedule info
			if(rowData.args != newArgumentParam){
				obj.args = newArgumentParam;
			}
			if(rowData.schedule != newScheduleCycle){
				obj.schedule = newScheduleCycle;
			}
			if(rowData.batchJobDefinition.is_distribution_needed != newOptionDistributed ) {
				obj.batchJobDefinition = {
					is_distribution_needed: newOptionDistributed
				}
			}

			if(!isEmpty(runNow)) {
				if( !isEmpty(newOptionDistributed)){
					obj.is_distribution_needed = newOptionDistributed;
				}
				if(!isEmpty(newCpuVol)){
					obj.batchJobDefinition = {
						cpu: newCpuVol
					}
				}
				if(!isEmpty(newDiskVol)){
					obj.batchJobDefinition = {
						mem: newDiskVol
					}
				}
				if(!isEmpty(newGpuVol)){
					obj.batchJobDefinition = {
						gpu: newGpuVol
					}
				}
			} else {		
				let option = {
					url: apiHost + "/batch-job-submit-rules/" + scheduleId,
					type: "patch",
					async: true,
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify(obj)
				}
				$.ajax(option).done(function (json, textStatus, jqXHR) {
					$("#addScheduleModal").modal("hide");
					$("#resultSuccessMsg").html("배치 스케줄 성공적으로 수정 되었습니다.").removeClass("hidden");
					$("#resultModal").modal("show");
					getData("schedule");
					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 1600);
				}).fail(function (jqXHR, textStatus, errorThrown) {
					$("#addScheduleModal").modal("hide");
					$("#resultFailureMsg").html("배치 스케줄 수정에 실패했습니다. <br>다시 시도해 주세요.").removeClass("hidden");
					$("#resultModal").modal("show");
					setTimeout(function(){
						$("#resultModal").modal("hide");
					}, 1600);
					console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
					return false;
				});
			}
		}
	};

	function showChildData(table){
		var scheduleTable = table;
		var detailRows = [];

		$("#scheduleTable tbody tr").on("click", function(){
			let tr = $(this).closest('tr');
			let siblings = tr.siblings();
			let selectedRow = table.row( tr );
			let idx = $.inArray( tr.attr('id'), detailRows );

			siblings.each(function(){
				scheduleTable.row($(this)).child.hide();
			});

			if ( selectedRow.child.isShown() ) {
				tr.removeClass( 'details' );
				selectedRow.child.hide();
				// Remove from the 'open' array
				detailRows.splice( idx, 1 );
			} else {
				tr.addClass( 'details' );
				selectedRow.child( format( selectedRow.data() ) ).show();
				// Add to the 'open' array
				if ( idx === -1 ) {
					detailRows.push( tr.attr('id') );
				}
			}
		});

		scheduleTable.on( 'draw', function () {
			$.each( detailRows, function ( i, id ) {
				$('#'+id+' td').trigger( 'click' );
			});
		});
	}

	function format ( trData ) {
		let isDistributed = trData.batchJobDefinition.is_distribution_needed;
		let isValid = '';
		(trData.is_valid == 0) ? (isValid = '중단') : (isValid = '진행');
		let cpuVol = trData.batchJobDefinition.cpu;
		let diskVol = displayNumberFixedDecimal(trData.batchJobDefinition.mem, "MB", null, "2")[0];
		let gpuVol = trData.batchJobDefinition.gpu;
		let argumentParam = trData.args;

		return  '<div class="ml-36 pl-40">' +
			'<div class="row mb-10">' +
				'<div class="col-12">' + 
					'작업분배기:' + '&ensp;' + isDistributed + '<span class="mr-24"></span>' +
					'임시중단 여부:' + '&ensp;' + isValid + '<span class="mr-56"></span>' +
					'CPU 요구사항:' + '&ensp;' + cpuVol + '%' + '<span class="mr-24"></span>' +
					'메모리 요구사항:' + '&ensp;' + diskVol + '&ensp;' + 'MB' + '<span class="mr-24"></span>' +
					'GPU 요구사항:' + '&ensp;' + gpuVol + '%' +
				'</div>' +
			'</div>' +
			'<div class="row">' +
				'<div class="col-12">실행 파라미터:' + '&ensp;' + argumentParam + '</div>' +
			'</div>' +
		'</div>'
	}

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">배치 관리 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12">
		<div class="indiv">
			<h2 class="ntit">배치 스케줄</h2>

			<table id="scheduleTable">
				<colgroup>
					<col style="width:4%">
					<col style="width:6%">
					<col style="width:18%">
					<col style="width:18%">
					<col style="width:18%">
					<col style="width:18%">
					<col style="width:18%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
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
				<button type="button" class="btn-type ml-16" onclick="getLogData($(this).prev().find('input'));">검색</button>
			</div>

			<div id="exportBtnGroup" class="fr"></div>

			<table id="logTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:6%">
					<col style="width:12%">
					<col style="width:12%">
					<col style="width:5%">
					<col style="width:30%">
					<col style="width:30%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>


<div class="modal fade" id="addScheduleModal" tabindex="-1" role="dialog" aria-labelledby="addScheduleModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md">
		<div class="modal-content schedule-modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1>배치 스케줄 추가<span class="required fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>배치 스케줄 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="update_schedule_form" id="updateScheduleForm" class="setting-form">
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
								<small class="hidden warning">실행 주기를 입력해 주세요.</small>
							</div>
							
							<div class="col-xl-2 col-lg-2 col-md-3 col-sm-5"><span class="input-label">CPU 요구사항</span></div>
							<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
								<div class="text-input-type unit">
									<input type="text" name="cpu_vol" id="cpuVol" class="digit" placeholder="입력" minlength="2" maxlength="9">
									<span>&#37;</span>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label asterisk">작업 분배기</span></div>
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
							
							<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">메모리 요구사항</span></div>
							<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
								<div class="text-input-type unit">
									<input type="text" name="disk_vol" id="diskVol" class="digit" placeholder="입력" maxlength="9">
									<span>MB</span>
								</div>
							</div>
						</div>

						<div class="row">
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

							<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">GPU 요구사항</span></div>
							<div class="col-xl-4 col-lg-4 col-md-8 col-sm-7">
								<div class="text-input-type unit">
									<input type="text" name="gpu_vol" id="gpuVol" class="digit" placeholder="입력" maxlength="9">
									<span>&#37;</span>
								</div>
								<small class="hidden warning"></small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-4 col-sm-5"><span class="input-label">실행 파라미터</span></div>
							<div class="col-xl-10 col-lg-10 col-md-8 col-sm-7">
								<textarea name="argument_param" id="argumentParam" class="textarea" placeholder="입력"></textarea>
							</div>
						</div>
						
						<div class="row">
							<div class="col-3">
								<button type="click" onclick="submitSchedule(event, 'now')" class="btn-type04 mt30">즉시 실행</button>
							</div>
							<div class="col-9">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="button" id="addScheduleBtn" class="btn-type" onclick="submitSchedule(event)" disabled>추가</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
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
				--><button type="button" class="btn-type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn-type w80 ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>

<div class="modal fade stack" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 id="resultSuccessMsg" class="text-blue hidden">배치 스케줄이 성공적으로<br>추가 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">배치 스케줄 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
			</div>
		</div>
	</div>
</div>
