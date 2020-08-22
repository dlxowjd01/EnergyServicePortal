<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {

		let sList = "${location}"
		// let siteList = JSON.parse('${siteList}');
		console.log("sList---", sList);

		// console.log("siteList---", siteList);


		getSiteList(oid);

		function getSiteList(siteId) {
			let option = {
				url: apiHost + "/config/sites",
				// url: apiHost + "/config/sites/" + sid,
				type: "get",
				async: false,
				data: {
					oid: siteId,
					filter: {
						"limit": 2000,
					}
				},
				beforeSend: function (jqXHR, settings) {
					$('#loadingCircle').show();
				},
			}

			$.ajax(option).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];
				// 1. 사업소 타입
				// 2. 사업소명
				// 3. 지역
				// 4. 발전원 => 0: MicroGrid, 1: photovoltaic, 2: wind, 3: SmallHydro (hydroelectric power for local community)
				// 5. 발전 용량
				// 6. ESS 용량 (PCS)
				// 7. ESS 용량(BMS)
				// 8. DR 자원 코드
				// 9. Vpp 자원 코드
				// 10. 알람 설정

				Promise.all(json.map((x, index) => {
					// console.log("x===", x)
					var obj = {};
					let statusOption = {
						url: apiHost + "/status/raw/site",
						type: 'get',
						async: false,
						data:{
							sid: x.sid,
					    	formId: 'v2'
					    }
					}
					$.ajax(statusOption).done(function (json, textStatus, jqXHR) {
						// console.log("json===", json)
						if(!isEmpty(x.ess)){
							obj.essVol = x.ess
							// if(x.ess === 0) {
							// 	obj.ess = "-"
							// } else if(x.ess === 1){
							// 	obj.ess = "DemandESS"
							// } else if(x.ess === 2){
							// 	obj.ess = "GenerationESS"
							// }
						} else {
							obj.essVol = "-"
						}


						if(!isEmpty(json.INV_PV) && ( Object.keys("genCapacity").length === 0 ) ) {
							console.log("json==", json.INV_PV)
							obj.genCapacity = json.INV_PV.capacity;
						} else {
							obj.genCapacity = 0;
						}
						if(!isEmpty(json.PCS_ESS) && ( Object.keys("pcsCapacity").length === 0 ) ) {
							obj.pcsCapacity = json.PCS_ESS.capacity;
						} else {
							obj.pcsCapacity = 0;
						}
						if(!isEmpty(json.BMS_SYS) && ( Object.keys("bmsCapacity").length === 0 ) ) {
							console.log("bms", json.BMS_SYS)
							obj.bmsCapacity = json.BMS_SYS.capacity;
						} else {
							obj.bmsCapacity = 0;
						}

						obj.sid = x.sid;
						obj.idx = index;
						obj.name = x.name;
						obj.location = x.location;

						if(x.resource_type === 0) {
							obj.resType = "Demand"
							obj.powerSource = "ESS"
						} else {
							obj.resType = "Generation"
							if(x.resource_type === 1){
								obj.powerSource = "태양광"
							} else if(x.resource_type === 2){
								obj.powerSource = "풍력"
							} else if(x.resource_type === 3){
								obj.powerSource = "소수력"
							}
						}
						if(x.dr_group_id){
							obj.drId = x.dr_group_id;
						} else {
							obj.drId = "-"
						}

						if(x.vpp_group_id){
							obj.vppId = x.vpp_group_id;
						} else {
							obj.vppId = "-"
						}

						newArr.push(obj);
					});
					return newArr
				})).then(function(result){
					// console.log("result--", result)
					var siteTable = $('#siteTable').DataTable({
						"aaData": newArr,
						"table-layout": "fixed",
						// "autoWidth": true,
						"bAutoWidth": true,
						"bSearchable" : true,
						"sScrollX": "110%",
						"sScrollXInner": "110%",
						"sScrollY": false,
						"bScrollCollapse": true,
						// "bFilter": false, disabling this option will prevent table.search()
						"aaSorting": [[ 0, 'asc' ]],
						"aoColumns": [
							{
								"sTitle": "순번",
								"mData": null,
								"className": "dt-center idx no-sorting"
							},
							{
								"sTitle": "사업소 유형",
								"mData": "resType",
							},
							{
								"sTitle": "사업소명",
								"mData": "name"
							},
							{
								"sTitle": "지역",
								"mData": "location",
							},
							{
								"sTitle": "발전원",
								"mData": "powerSource",
							},
							{
								"sTitle": "발전 용량",
								"mData": "genCapacity",
							},
							{
								"sTitle": "ESS 용량 (PCS)",
								"mData": "pcsCapacity",
							},
							{
								"sTitle": "ESS 용량 (BMS)",
								"mData": "bmsCapacity",
							},
							{
								"sTitle": "DR 자원 코드",
								"mData": "drId",
							},
							{
								"sTitle": "VPP 자원코드",
								"mData": "vppId",
							},
							{
								"sTitle": "알람 수신",
								"mData":"null",
								"mRender": function ( data, type, row )  {
									return '<button type="button" class="btn-type-sm btn_type03" onclick="addAlarm()">추가</button>'
								},
							},
						],
						"aoColumnDefs": [
							{
								"aTargets": [ 0 ],
								"bSortable": false,
								"orderable": false
							},
						],
						"dom": 'tip',
						"select": {
							style: 'single',
							// selector: 'td:first-child > a',
							items: 'row'
						},
						// "buttons": [
					// 	{
					// 		text: '추가',
					// 		className: "btn_type fr",
					// 		action: function (e, node, config){
					// 			updateModal("all");
					// 		}
					// 	}
					// ],
						initComplete: function(){
							let str = `
								<div id="btnGroup" class="right-end"><!--
									--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('edit')">선택 수정</button><!--
									--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('delete')">선택 삭제</button><!--
							--></div>
							`
							$("#siteTable_wrapper").append($(str));
							this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
								cell.innerHTML = i+1;
								$(cell).data("id", i);
							});
							// this.api().columns().header().each ((el, i) => {
							// 	if(i>1){
							// 		$ (el).attr ('style', 'min-width: 160px;');
							// 	}
							// });
						},
						createRow: function (row, data, dataIndex){
							console.log("row===", row);
							// $(row).attr({
							// 	'data-sid': data.sid,
							// });

						},
						// every time DataTables performs a draw
						drawCallback: function () {
							selectRow(this);
							$('#siteTable_wrapper').addClass('mb-28');
						},
						rowCallback: function ( row, data ) {
							// console.log("row-selected--", row)
							// $('input.editor-active', row).prop( 'checked', data.active == 1 );
						}
					}).on("select", function(e, dt, type, indexes) {
						let btn = $("#btnGroup").find(".btn_type03");
						btn.each(function(index, element){
							if($(this).is(":disabled")){
								$(this).prop("disabled", false).removeClass("disabled");
							}
						});
						// table.rows( indexes ).nodes().to$().siblings().find("input").prop("checked", false);
						// table.rows( indexes ).nodes().to$().find("input").prop("checked", true);
						// let self = table[ type ]( indexes ).nodes().to$().find('input');
						// console.log("dt---", table[ type ]( indexes ).nodes())
					}).on("deselect", function(e, dt, type, indexes) {
						let btn = $("#btnGroup").find(".btn_type03");
						btn.each(function(index, element){
							if(!$(this).is(":disabled")){
								$(this).prop("disabled", true).addClass("disabled");
							}
						});
					}).columns.adjust().draw();


					siteTable.on( 'order.dt search.dt', function () {
						siteTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
							cell.innerHTML = i+1;
							$(cell).data("id", i)
						});
					}).draw();

					siteTable.on( 'column-sizing.dt', function ( e, settings ) {
						$(".dataTables_scrollHeadInner").css( "width", "100%" );
					});

					new $.fn.dataTable.Buttons( siteTable, {
						name: 'commands',
						"buttons": [
							{
								extend: 'copyHtml5',
								className: "btn_type03",
								text: '선택 복사',
							},
							{
								extend: 'print',
								text: '전체 인쇄',
								className: "btn_type03",
								exportOptions: {
									modifier: {
										selected: null
									}
								}
							},
							{
								extend: 'print',
								className: "btn_type03",
								text: '선택 인쇄'
							},
							{
								extend: 'excelHtml5',
								className: "btn_type03",
								text: 'Excel'
							},
							{
								extend: 'csvHtml5',
								className: "btn_type03",
								text: 'CSV'
							},
							{
								extend: 'pdfHtml5',
								className: "btn_type03",
								text: 'PDF',
							},
						],
					});

					siteTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup").addClass("hidden inline");


					$("#siteTypeList").find("li").on( 'click', function(){
						if(!isEmpty($(this).data("name"))){
							filterColumn("1", $(this).data("value"));
						} else {
							filterColumn("1", "");
						}
					});
					$("#siteSearchBox").on( 'keyup search input paste cut', function(){
						siteTable.search( this.value ).draw();
					});

					$("#pageLengthList").find("li").on( 'click', function(){
						console.log("page clicking---")
						if(!isEmpty($(this).data("value"))){
							let val = Number($(this).data("value"));
							siteTable.page.len(val).draw();
						} else {
							siteTable.page.len( -1 ).draw();
						}
					});

				});


			}).fail(function (jqXHR, textStatus, errorThrown) {
				if(textStatus == "error"){
					if(jqXHR.statusText == "Unauthorized" || jqXHR.status == 401){
						$("#oldPwdErr").removeClass("hidden");
					}
					console.log("jqXHR==", jqXHR )
				}
				return false;
			});
		}

		function selectRow(dataTable) {
			if ($(this).hasClass("selected")) {
				$(this).removeClass("selected");
			} else {
				dataTable.$("tr.selected").removeClass("selected");
				$(this).addClass("selected");
			}
		}
		function makeAjaxCall(option, callback){
			return $.ajax(option).done(function (json, textStatus, jqXHR) {
				console.log("makeAjaxCall json--", json)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.log("siteInfo/spcInfo Ajax Error:", jqXHR.responseJSON.error.message)
				return false;
			});
		}

		function validateAddForm(){
			if( ( $("#validId:not('.hidden')").length >= 0 ) && ( $("#addUserForm .tick:not('.checked')").index() == -1 ) && ( $(".warning:not(.hidden)").index() == -1 ) && ( !isEmpty($("#newFullName").val() ) ) && ( !isEmpty($("#newAccLevel").prev().data("value")) )){
				return 1;
			}
		}

		function validateEditForm(){
			if(!isEmpty($("#newUserPwd").val())) {
				console.log("newUserPwd NOT empty===" )
				if( ($("#addUserForm .tick:not('.checked')").index() == -1) && ($(".warning:not(.hidden)").index() == -1) ) {
					return 1;
				}
			} else {
				if( $(".warning:not(.hidden)").index() == -1 ) {
					return 1;
				}
			}
		}


		function validatePassword() {
			const rules = [
				{
					Pattern: "[a-zA-Z]",
					Target: "hasLet"
				},
				{
					Pattern: "[0-9]",
					Target: "hasNum"
				},
			];

			let password = $(this).val();
			password.length >= 6 ? $("#sixCharLong").addClass("checked") : $("#sixCharLong").removeClass("checked");

			for (var i = 0; i < rules.length; i++) {
				if( new RegExp(rules[i].Pattern).test(password) ) {
					$("#" + rules[i].Target).addClass("checked")
				} else {
					$("#" + rules[i].Target).removeClass("checked")
				}
			}
		}
		// let p = JSON.parse(sList);
		// console.log("p---", sList);
		// $.each(p, function(index, element){
		// 	console.log("elemet---", element)
		// });

		// var table = $('#siteTable').DataTable({
		// 	// "fixedHeader": true
		// });

		// new $.fn.dataTable.FixedHeader( table, {
		// 	alwaysCloneTop: true
		// });

	});

	function updateModal(option){
		if(isEmpty(option)) {
			let form = $("#addUserForm");
			let input = form.find("input");
			let dropdown = form.find(".dropdown-toggle");
			let tick = form.find(".tick");
			let warning = form.find(".warning");

			$("#validId").addClass("hidden");
			warning.addClass("hidden")
			tick.removeClass("checked");
			input.val("");

			$.each(dropdown, function(index, element){
				$(this).html('선택' + '<span class="caret"></span>');
				$(this).data("value", "");
			});
		} else {
			let titleAdd = $('#titleAdd');
			let id = $('#newId');
			let required = $("#addUserForm").find(".asterisk");
			if(option == "all"){
				if(id.parent().next().hasClass("hidden")) {
					id.parent().next().removeClass("hidden");
					id.parent().addClass("offset-width").removeClass("w-100");
				}
				titleAdd.removeClass("hidden").next().addClass("hidden");
				required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
				$('#newId').prop('disabled', false);
				$("#addSiteModal").removeClass("edit").modal("show");
			} else {
				var tr = $("#userTable").find("tbody tr.selected");
				let td = tr.find("td");
				if(option == "edit") {
					$("#addUserBtn").prop("disabled", false).removeClass("disabled");
					titleAdd.addClass("hidden").next().removeClass("hidden");
					required.hasClass("no-symbol") ? null : required.addClass("no-symbol");
					if(!id.parent().next().hasClass("hidden")) {
						id.parent().next().addClass("hidden");
						id.parent().removeClass("offset-width").addClass("w-100");
					}
					id.val(td.eq(2).text()).prop('disabled', true).addClass("disabled");
					$('#newFullName').val(td.eq(3).text())
					$("#newAccLevel").prev().html(td.eq(7).text() + '<span class="caret">');
					if(!isEmpty(td.eq(4))){
						$('#newMobileNum').val(td.eq(4).text())
					}
					if(!isEmpty(td.eq(5))){
						$('#newEmailAddr').val(td.eq(5).text())
					}
					if(!isEmpty(td.eq(6))){
						$('#newAffiliation').val(td.eq(6).text())
					}
					if(!isEmpty(td.eq(8))){
						$('#newTaskList').prev().data("value", td.eq(8).text()).html(td.eq(8).text(), '<span class="caret">');
					}
					if(!isEmpty(td.eq(9))){
						$('#newUseOpt').prev().data("value", td.eq(9).text()).html(td.eq(9).text(), '<span class="caret">');
					}
					$("#addSiteModal").addClass("edit").modal("show");
				}
				if(option == "delete") {
					let td = $("#userTable").find("tbody tr.selected td");
					let id = td.eq(0).find("input").data("id");
					let userId = $("#userTable").find("tbody tr.selected td:nth-of-type(3)").text();
					$("#deleteSuccessMsg span").text(userId);
					$("#deleteConfirmModal").modal("show");

					$("#confirmUserId").on('input', function() {
						$(this).val($(this).val().replace(/\s/g, ''));
					});

					$("#confirmUserId").on("keyup", function() {
						if($(this).val() != userId) {
							return false
						} else {
							$("#warningConfirmBtn").prop("disabled", false).removeClass("disabled");
							$("#warningConfirmBtn").on("click", function(){
								let optDelete = {
									url: apiHost + "/config/users/" + id,
									type: 'delete',
									async: true,
									beforeSend: function (jqXHR, settings) {

									},
								}

								$.ajax(optDelete).done(function (json, textStatus, jqXHR) {
									var newTable = $('#userTable').DataTable();

									$("#deleteSuccessMsg").text("사용자가 삭제 되었습니다.").removeClass("hidden");
									newTable.rows(tr).remove().draw(false);
									setTimeout(function(){
										$("#deleteConfirmModal").modal("hide");
									}, 1200);

								}).fail(function (jqXHR, textStatus, errorThrown) {
									console.log("fail==", jqXHR)
								});
							});
						}
					});

					

				}
			}
		}
	}

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">사업소 관리</h1>
	</div>
</div>

<c:set var="siteList" value="${siteHeaderList}"/> <!-- 사이트 별 -->

<div class="row">
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="flex_group">
			<span class="tx_tit">사업소 유형</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul id="siteTypeList" class="dropdown-menu">
						<li data-name="Demand" data-value="0"><a href="#">수요(Demand)</a></li>
						<li data-name="Generation" data-value="1"><a href="#">발전(Generation)</a></li>
					</ul>
			</div>

			<%--
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu" id="siteList">
					<li>
						<a href="#" tabindex="-1">
							<input type="checkbox" name="allSites" id="allSites" value="all">
							<label for="allSites">전체</label>
						</a>
					</li>
					<c:if test="${fn:length(siteList) > 0}">
						<c:forEach var="site" items="${siteList}">
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" name="${site.name}" id="${site.sid}" value="${site.index}">
									<label for="${site.sid}">${site.name}</label>
								</a>
							</li>
						</c:forEach>
					</c:if>
				</ul>
			</div>
			--%>
		</div>
		<div class="flex_group">
			<span class="inline-title">지역</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu">
					<c:set var="systemLoc" value="${sessionScope.systemLoc}"/>
					<li><a href="#">전체</a></li>
					<c:forEach var="loc" items="${location}" varStatus="stat">
						<c:forEach var="country" items="${loc.value.locations}" varStatus="countryStat">
							<c:set var="choice" value="false" />
							<c:if test="${fn:length(systemLoc) > 0}">
								<c:forEach var="selLoc" items="${systemLoc}">
									<c:if test="${country.value.code eq selLoc}">
										<c:set var="choice" value="true" />
									</c:if>
								</c:forEach>
							</c:if>
							<li data-value="">
								<a href="#" tabindex="-1">
									<input type="checkbox" name="${country.value.name}" id="location_${countryStat.index}" value="${country.value.code}" <c:if test="${choice eq 'true'} && ${}">checked</c:if>>
									<label for="location_${countryStat.index}" <c:if test="${choice eq 'true'}">class="on"</c:if>>${country.value.name.kr}</label>
								</a>
							</li>
						</c:forEach>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">발전 자원</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu">
					<li data-value="solar" class="on"><a href="#">태양광</a></li>
					<li data-value="wind"><a href="#">풍력</a></li>
					<li data-value="wind"><a href="#">소수력</a></li>
					<li data-value="wind"><a href="#">부하</a></li>
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">발전소명</span>
			<div class="flex_start">
				<div class="tx_inp_type">
					<input type="text" id="siteSearchBox" name="site_search_box" placeholder="입력">
				</div>
			</div>
		</div>
	</div>
	<div class="col-lg-5 col-md-5 col-sm-12">
		<div id="exportBtnGroup" class="fr"><button type="button" class="save_btn ml-16 fr"
			onclick="$(this).prev().toggleClass('hidden')">데이터 다운로드</button></div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<div class="flex_group">
				<div class="dropdown">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown">선택<span class="caret"></span></button>
					<ul class="dropdown-menu" id="pageLengthList">
						<li data-value=""><a href="#" tabindex="-1">전체</a></li>
						<li data-value="10"><a href="#" tabindex="-1">10</a></li>
						<li data-value="30"><a href="#" tabindex="-1">30</a></li>
						<li data-value="50"><a href="#" tabindex="-1">50</a></li>
					</ul>
				</div>
				<span class="tx_tit pl-16">개 씩 보기&ensp;</span>
			</div>
			<button type="button" class="btn_type fr mb-20" onclick="updateModal('all')">추가</button>
			
			<table id="siteTable">
				<colgroup>
					<col style="width:6%">
					<col style="width:10%">
					<col style="width:16%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:14%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
				<!-- <tfoot></tfoot> -->
			</table>
		</div>
	</div>
</div>

<div class="modal fade stack" id="resultModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 id="resultSuccessMsg" class="text-blue hidden">사용자가 성공적으로<br>추가 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">사업소 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
			</div>
		</div>
	</div>
</div>

<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit">사용자 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
			<div class="tx_inp_type"><input type="text" id="confirmUserId" name="confirm_user_id" placeholder="사용자 아이디 입력"/></div>
			</div>
			<div class="btn_wrap_type05"><!--
				--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="warningConfirmBtn" class="btn_type w80 ml-12 disabled" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>


<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content user-modal-content">
			<div id="titleAdd" class="modal-header"><h1>사업소 추가<span class="required px-4 fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사업소 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form id="addUserForm" name="add_user_form">
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label asterisk">사업소 명</span></div>
							<div class="col-lg-4 col-sm-3">
								<div class="flex_start">
									<div class="tx_inp_type offset-width">
										<input type="text" name="new_id" id="newId" placeholder="입력" minlength="5" maxlength="15">
									</div>
									<button type="button" class="btn_type disabled fr" disabled onclick="checkId($('#newId').val())">중복 체크</button>
								</div>
								<small class="hidden warning">사용자 아이디를 입력해 주세요</small>
							</div>

							<div class="col-lg-2 col-sm-3"><span class="input_label offset asterisk">자원 유형</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<li data-value="1" data-name="Demand"><a href="#">수요(Demand)</a></li>
										<li data-value="2" data-name="Generation"><a href="#">발전(Generation)</a></li>
									</ul>
								</div>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset asterisk">발전원</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<li data-value="0" data-name="ess"><a href="#">ESS</a></li>
										<li data-value="1" data-name="pv"><a href="#">태양광</a></li>
										<li data-value="2" data-name="wind"><a href="#">풍력</a></li>
										<!-- <li data-value="2" data-name="smallhydro"><a href="#">소수력</a></li> -->
									</ul>
								</div>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset asterisk">ESS 유무</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<li data-value="1"><a href="#">유</a></li>
										<li data-value="0"><a href="#">무</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label asterisk">지역</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newFullName" name="new_full_name" placeholder="입력" minlength="3" maxlength="28"></div>
								<small class="hidden warning">영문/한글(3~28 글자) 조합의 이름을 입력해 주세요</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset asterisk">권한 등급</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newAccLevel" class="dropdown-menu">
										<li data-value="1" data-name="시스템 관리자"><a href="#">시스템 관리자</a></li>
										<li data-value="2" data-name="일반 사용자"><a href="#">일반 사용자</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">휴대폰</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newMobileNum" name="new_mobil_num" placeholder="입력" maxlength="13"></div>
								<small id="isValidNewMobileNum" class=" warning hidden">10자리 이상의 휴대폰 번호를 입력해 주세요.</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset">소속</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newAffiliation" name="new_affiliation" placeholder="입력">
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">이메일</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="tx_inp_type"><input type="text" id="newEmailAddr" name="new_email_addr" placeholder="입력"></div>
								<small class="hidden warning">올바른 이메일 형식을 입력해 주세요.</small>
							</div>
							<div class="col-lg-2 col-sm-3"><span class="input_label offset">업무 구분</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newTaskList" class="dropdown-menu">
										<li data-value="0"><a href="#">일반</a></li>
										<li data-value="1"><a href="#">사무 수탁사</a></li>
										<li data-value="2"><a href="#">자산 운용사</a></li>
										<li data-value="3"><a href="#">사업주</a></li>
									</ul>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">사용 여부</span></div>
							<div class="col-lg-4 col-sm-9">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newUseOpt" class="dropdown-menu">
										<li data-value="Y"><a href="#">Y</a></li>
										<li data-value="N"><a href="#">N</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-2 col-sm-3"><span class="input_label">설명</span></div>
							<div class="col-lg-10 col-sm-9">
								<textarea name="new_user_desc" id="newUserDesc" class="textarea w-100" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<ul class="nav nav-tabs">
									<li class="active w-50"><a data-toggle="tab" href="#siteTab">사업소</a></li>
									<li class="w-50"><a data-toggle="tab" href="#spcTab">SPC</a></li>
								</ul>
							</div>
						</div>

						<div class="tab-content">
							<div id="siteTab" class="tab-pane fade in active">
								<div class="row user-row">
									<div class="col-lg-8 col-sm-12">
										<div class="flex_start">
											<div class="dropdown w-50">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="siteOptList" class="dropdown-menu">
													<c:if test="${fn:length(siteList) > 1}">
														<c:forEach var="site" items="${siteList}">
															<c:if test="${site.name != '직접입력'}">
																<li data-name="${site.name}" data-value="${site.sid}"><a href="#" tabindex="-1">${site.name}</a></li>
															</c:if>
														</c:forEach>
													</c:if>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="siteAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">관리 권한</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회 권한</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('site')">추가</button>
										</div>
										<small id="isSiteEmpty" class="warning hidden">추가하실 사이트의 옵션을 선택해 주세요.</small>
										<small id="isSiteSelected" class="warning hidden">동일한 사이트가 이미 추가 되었습니다.</small>
									</div>
									<div class="col-lg-4 col-sm-12 px-0"><h2 class="stit hidden">추가 리스트</h2><ol id="selectedSiteList" class="selected-list"></ol></div>
								</div>
							</div>
							<div id="spcTab" class="tab-pane fade">
								<div id="spcRow" class="row user-row">
									<div class="col-lg-8 col-sm-12">
										<div class="flex_start">
											<div class="dropdown w-50">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="spcOptList" class="dropdown-menu">
													<template>
														<li data-value="*spcId*" data-name="*spcName*"><a href="#" tabindex="-1">*spcName*</a></li>
													</template>
												</ul>
											</div>
											<div class="dropdown ml-16 w-25">
												<button type="button" class="dropdown-toggle asterisk" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
												<ul id="spcAccOpt" class="dropdown-menu">
													<li data-value="1" data-name="수정/조회"><a href="#">수정/조회</a></li>
													<li data-value="2" data-name="조회"><a href="#">조회</a></li>
												</ul>
											</div>
											<button type="button" class="btn-add ml-16" onclick="addToList('spc')">추가</button>
										</div>
										<small id="isSpcEmpty" class="warning hidden">추가하실 SPC 옵션을 선택해 주세요.</small>
										<small id="isSpcSelected" class="warning hidden">동일한 SPC가 이미 추가 되었습니다.</small>
									</div>
									<div class="col-lg-4 col-sm-12"><h2 class="stit">추가 리스트</h2><ul id="selectedSpcList" class="selected-list"></ul></div>

								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn_wrap_type02">
									<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addUserBtn" class="btn_type disabled" disabled>등록</button>
									<!-- <button type="submit" id="addUserBtn" class="btn_type">확인</button> -->
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
