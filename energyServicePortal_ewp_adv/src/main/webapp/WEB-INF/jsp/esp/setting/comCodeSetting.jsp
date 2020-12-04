<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	$(function () {
		getPropertyData();
		$("#fileInput").on('change', function (e) {
			let t = $(this).val();
			if (isEmpty(t)) {return false;}
			let labelText = 'File : ' + t.substr(12, t.length);
			let listItem =  labelText + '<button type="button" class="icon-trash" onclick="deleteFile($(this))"></button>';
			$(this).parent().find(".upload-text").html(listItem);

			let fileReader = new FileReader();
			let selectedFile = e.target.files[0];

			fileReader.onload = function(event) {
				let data = event.target.result;
				let workbook = XLSX.read(data, {
					type: "binary"
				});
				let arr = [];
				workbook.SheetNames.forEach(sheet => {
					let rowObject = XLSX.utils.sheet_to_row_object_array(
						workbook.Sheets[sheet]
					);
					rowObject.forEach((item, index) => {
						// item.key이름 별로 값을 
						let obj = {}
						// obj.key = item.key;
						arr.push(obj);
						// console.log(item);
					});
					// console.log(rowObject);
				});
			};
			fileReader.readAsBinaryString(selectedFile);
		});
	});

	function getPropertyData(callbackOption) {
		let option = {
			// url: apiHost + "/common/code?oid=" + oid + "&includeCodes=true",
			url: apiHost + "/common/code?oid=" + oid,
			type: 'get',
			async: true,
		}
		makeAjaxCall(option, callbackOption ).then(res => {
			let lang = $("html").attr("lang");
			let str = ``;

			if(!isEmpty(res.data) && res.data.length > 0){
				console.log("res111===", res);
				res.data.forEach((item, index, arr) => {
					// dvcCategory : 디바이스 상위 카테고리
					let dvcCategory = (lang == "en") ? item.name.en :  item.name.kr;
					let dvcNameStr = ``;

					/* // dvcList: 카테고리 하위 디바이스 리스트
					let dvcList; 아직 미정(api update 후 적용)
					dvcList.forEach((item, index) => {
						dvcNameStr += `
						<a href="#collapseOne" role="button" class="">${'${  }'}</a>
						`
					});
					*/


				// 데이터가 있을경우 panel body안에 넣기
				// <div class="panel-body">
				// 		<div class="flex-start">
				// 			<a href="#" role="button" class="stit" onclick="getComCodeData(this)">test content</a>
				// 		</div>
				// </div>
					str += `
						<div class="panel panel-default">
							<div class="panel-heading active" role="tab" id="heading_${'${ index + 1 }'}">
								<h4 class="panel-title">
									${'${ dvcCategory }'}
									<a href="#collapseOne" role="button" data-toggle="collapse" data-parent="#panelGroup" aria-expanded="true" aria-controls="collapseOne" class="panel-fold"></a>
								</h4>
							</div>
							<div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby=id="heading_${'${ index + 1 }'}">
								<div class="panel-body">

								</div>
							</div>
						</div>
					`;

				});
				$("#panelGroup").append(str);
			} else {
				// 데이터가 없을 경우
				str = `
					<div class="panel panel-default">
						<div class="panel-heading no-data active">
							<h4 class="panel-title">디바이스 정보가 없습니다.</h4>
						</div>
					</div>
				`;
				$("#panelGroup").append(str);
			}
			// if(!isEmpty(callbackOption)) {

			// }
		});

	}

	function getComCodeData(self){
		let type = $(self).data("code-type");
		let codes = $(self).data("code");
		let perPageNum = 30;

		// 실제 값이 어떻게 오는 지 보고 구현 할 것!!!! 기존에 있는 코드 바탕으로 대강 형태만 잡아놓았음.
		var comCodeTable = $("#comCodeTable").DataTable({
			"destroy": true,
			"table-layout": "fixed",
			"scrollY": "720px",
			"scrollCollapse": true,
			"paging": true,
			"pageLength": perPageNum,
			"processing": true,
			"serverSide": true,
			"ordering": false,
			"ajax": {
				type: 'GET',
				url: apiHost + "/common/detail?oid=" + oid,
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
				},
				data: function(d) {
					let param = {};
					param.types = type;
					param.codes = codes;
					param.page = (d.start / perPageNum) + 1;
					param.limit = perPageNum;

					return param;
				},
				contentType: "application/json; charset=utf-8",
				dataFilter: function (json) {
					// let failText = "데이터를 가져 오는 데 실패 하였습니다.";
					json = JSON.parse(json);
					return JSON.stringify({
						// "draw": 1,
						"recordsTotal": json.count,
						"recordsFiltered": json.count,
						"data": json.log,
						"length": perPageNum,
						// "error": failText
					});
				}
			},
			"columns": [
				{
					"title": "",
					"data": null,
					"render": function ( data, type, full, rowIndex ) {
						return '<a class="chk-type" href="javascript:void(0); onclick=""><input type="checkbox" id="' + full.code + '" name="' + full.code + '"><label for="' + full.code + '"></label></a>'
					},
					"className": "dt-body-center"
				},
				{
					"title": "순번",
					"data": "",
					"render": function ( data, type, full, rowIndex ) {
						return rowIndex.settings._iDisplayStart + rowIndex.row + 1;
					},
					"className": "dt-body-center"
				},
				{
					"title": "분류 코드",
					"data": "",
					"render": function ( data, type, full, rowIndex ) {
						// return full.type;
						return "";
					} 
				},
				{
					"title": "코드 ID",
					"data": "",
					"render": function ( data, type, full, rowIndex ) {
						// return full.code.code;
						return "";
					},
				},
				{
					"title": "코드명",
					"data":"",
					"render": function ( data, type, full, rowIndex ) {
						return ($("html").attr("lang") == "en") ? full.name.en : full.name.kr;
						return "";
					}
				},
				{
					"title": "등록 사용자",
					"data": registed_by,
				},
				{
					"title": "등록 날짜",
					"data":"",
					"render": function ( data, type, full, rowIndex ) {
						// return full.registed_at.format("yyyy-MM-dd");
						return "";
					}
				},
				{
					"title": "설명",
					"data": description,
				},
				{
					"title": "사용 여부",
					"data":"",
					"render": function ( data, type, full, rowIndex ) {
						let str9 = '';
						// if( full.use_yn == true ){
						// 	str9 = `<button type="button" class="btn-type04" onclick='agreeToUse(this, "Y")'>사용</button>`
						// } else {
						// 	str9 = `<button type="button" class="btn-type03" onclick='agreeToUse(this, "N")'>해제</button>`
						// }
						return str9;
					}
				},
			],
			"dom": 'tip',
			"language": {
				"paginate": {
				 	"previous": "",
				 	"next": "",
				},
				"info": "_PAGE_ - _PAGES_ " + " / 총 _TOTAL_ 개",
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
				let addBtnStr = `<button type="button" class="btn-type fr mb-20" onclick="updateModal('add')">추가</button>`;
				this.api().columns().header().each ((el, i) => {
					if(i == 0){
						$(el).attr ('style', 'min-width: 50px');
					}
				});
				let str = `<div id="btnGroup" class="right-end"><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('edit')">선택 수정</button><!--
						--><button type="button" disabled class="btn-type03" onclick="updateModal('delete')">선택 삭제</button><!--
					--></div>`;
				$('#comCodeTable_wrapper').append($(str));
			},
			// every time DataTables performs a draw
			drawCallback: function (settings) {
				$('#comCodeTable_wrapper').addClass('my-20');
			}
		}).on("select", function(e, dt, type, indexes) {
			let btn = $("#btnGroup").find(".btn-type03");
			btn.each(function(index, element){
				if($(this).is(":disabled")){
					$(this).prop("disabled", false);
				}
			});
			comCodeTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
			// console.log("dt---", scheduleTable[ type ]( indexes ).nodes())
		}).on("deselect", function(e, dt, type, indexes) {
			let btn = $("#btnGroup").find(".btn-type03");
			btn.each(function(index, element){
				if(!$(this).is(":disabled")){
					$(this).prop("disabled", true);
				}
			});
			comCodeTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
			// console.log("dt---", scheduleTable[ type ]( indexes ).nodes())
		}).columns.adjust().draw();

	}


	function updateModal(option, callback){
		let modal = $("#addComCodeModal");
		let titleAdd = $('#titleAdd');
		let form = $("#updateComCodeForm");
		let codeClassification = $('#codeClassification').prev().data("value");
		let required = form.find(".asterisk");

		// ADD MODAL!!!
		if(option == "add"){
			initModal();
			$("#addComCodeModal").removeClass("edit").modal("show");
		} else {
			let dTable = $("#comCodeTable").DataTable();
			let tr = $("#comCodeTable").find("tbody tr.selected");
			let td = tr.find("td");
			let rowData = dTable.row(tr).data();


			// EDIT MODAL!!!
			if(option == "edit") {
				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");

				$("#addComCodeModal").addClass("edit").modal("show");
			}
			// DELETE MODAL!!!
			if(option == "delete") {
				let codeId = td.eq(3).text();
				let modal = $("#deleteConfirmModal");
				let deleteBtn = $("#deleteConfirmBtn");
				let confirmCodeId = $("#confirmCode");

				$("#deleteSuccessMsg span").text(codeId);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmCodeId.on("input", function() {
					if($(this).val() !== codeId) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmCodeId.on("keyup", function() {
					if($(this).val() !== codeId) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});
			}
		}

	}

	function initModal(){
		let form = $("#updateComCodeForm");
		let input = form.find("input");
		let dropdownBtn = form.find(".dropdown-toggle");
		let warning = form.find(".warning");
		let selectedFile = form.find(".file_list ul");

		$("#addComCodeBtn").prop("disabled", true);
		$("#comCodeDesc").val("");

		warning.addClass("hidden");
		input.each(function(){
			if($(this).is(":checked")){
				$(this).prop("checked", false);
			}
			$(this).val("").prop("disabled", false).parent().removeClass("disabled");
		});

		$.each(dropdownBtn, function(index, element){
			$(this).data({ "value": "", "vol-type": "", "plan-id" : "" }).html('선택' + '<span class="caret"></span>').prop("disabled", false);
			$(this).next().find("li").removeClass("hidden");
		});
		selectedFile.empty();
		// console.log("initModal----")
	}


</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">공통 코드 관리</h1>
	</div>
</div>

<div class="row">
	<div class="col-3">
		<div class="panel-group" id="panelGroup" role="tablist" aria-multiselectable="true"></div>
	</div>
	<div class="col-9">
		<div class="indiv">
			<h2 class="tx-tit"></h2>
			<table id="comCodeTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:12%">
					<col style="width:16%">
					<col style="width:5%">
					<col style="width:6%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:12%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>


<div class="modal fade" id="comCodeModal" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg">
		<div class="comcode-modal-content modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1>공통 코드 추가<span class="required fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>공통 코드 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="comcode_form" id="updateComCodeForm" class="setting-form" autocomplete="off">
						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label asterisk">분류 코드</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="codeClassification" class="dropdown-menu"></ul>
								</div>
								<small class="hidden warning">분류 코드를 선택해 주세요.</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40"><span class="input-label">사용 여부</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<a href="#" class="chk-type" tabindex="-1">
									<input type="checkbox" id="optionToUse">
									<label for="optionToUse"></label>
								</a>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label asterisk">코드 ID</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="flex-start">
									<div class="text-input-type w-100">
										<input type="text" name="comcode_id" id="comCodeId" placeholder="입력" minlength="2" maxlength="15">
									</div>
								</div>
								<small class="hidden warning">추가하실 코드 ID를 입력해 주세요.</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40"><span class="input-label asterisk">코드 ID명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="text-input-type"><input type="text" name="comcode_name" id="comCodeName" placeholder="입력"/></div>
								<small class="hidden warning">추가하실 코드 ID명을 입력해 주세요.</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label">설명</span></div>
							<div class="col-xl-10 col-lg-10 col-md-10 col-sm-10">
								<textarea name="comcode_desc" id="comCodeDesc" class="textarea" placeholder="입력"></textarea>
							</div>
						</div>

						<!-- 기획 추가 확인 common.js on.change function 확인 할 것 -->
						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label">타이틀 미정</span></div>
							<div class="col-xl-10 col-lg-10 col-md-10 col-sm-12">
								<div class="flex-start mt-8">
									<input type="file" name="file" id="fileInput" class="btn-upload stand-alone hidden" data-parse="true" accept=".xls, .xlsx">
									<label for="fileInput" class="btn file-upload">파일 선택</label>
									<span class="upload-text ml-16"></span>
								</div>
							</div>	
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addComcodeBtn" class="btn-type" disabled>확인</button>
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
				<h5 id="deleteSuccessMsg" class="ntit">공통코드 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="text-input-type"><input type="text" name="confirm_code" id="confirmCode" placeholder="사이트 이름 입력"/></div>
			</div>
			<div class="btn-wrap-type05"><!--
				--><button type="button" class="btn-type03 w-80px" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn-type w-80px ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>

