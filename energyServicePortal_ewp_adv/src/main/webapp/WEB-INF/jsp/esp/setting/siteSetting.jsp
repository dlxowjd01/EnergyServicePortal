<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		let sList = "${location}"

		getSiteList(oid);

		function getSiteList(siteId) {
			let option = {
				url: apiHost + "/config/sites",
				type: "get",
				async: true,
				data: {
					oid: siteId,
					filter: {
						"limit": 200,
						"fields": {
							"sid": true,
							"oid": true,
							"name": true,
							"location": true,
							"resource_type": true,
							"ess": true,
							"vpp_group_id": true,
							"dr_group_id": true,
							"market_id": true,
							"station_id": true,
							"latlng": true,
							"tz": true,
							"address": true,
							"detail_info": true,
							// "utility": true,
							"dr_info": true,
							"vpp_info": true,
							"power_market": true,
							// "cctv_url": true,
							// "createdAt": true,
							// "updatedAt": true
						},
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

				Promise.all(json.map( (x, index) => {
					// console.log("x===", x)
					let obj = {};
					obj.sid = x.sid;
					obj.idx = index;
					obj.name = x.name;
					obj.location = x.location;
					obj.genVol = "TBA"
					obj.pscVol = "TBA"
					obj.bmsVol = "TBA"
					obj.alarmState = "TBA"

					if(x.resource_type === 0) {
						obj.powerSource = "부하"
					} else if(x.resource_type === 1){
						obj.powerSource = "태양광"
					} else if(x.resource_type === 2){
						obj.powerSource = "풍력"
					} else if(x.resource_type === 3){
						obj.powerSource = "소수력"
					}

					if(x.ess){
						if(x.ess === 0) {
							obj.siteType = "-"
						} else if(x.ess === 1){
							obj.siteType = "Demand"
						} else if(x.ess === 2){
							obj.siteType = "Generation"
						}
					} else {
						obj.siteType = "-"
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
					
				}));

				var table = $('#siteTable').DataTable({
					"aaData": newArr,
					// "bDeferRender": true,
					// "fixedHeader": true,
					"table-layout": "fixed",
					// "autoWidth": true,
					"bAutoWidth": true,
					"sScrollX": "110%",
					"sScrollXInner": "110%",
					"sScrollY": false,
					"bScrollCollapse": true,
					"bFilter": false,
					"aaSorting": [[ 0, 'asc' ]],
					// "order": [[ 1, 'asc' ]],
					"aoColumns": [
						{
							"sTitle": "순번",
							"mData": null,
							"className": "dt-center idx no-sorting"
						},
						{
							"sTitle": "사업소 타입",
							"mData": "siteType",
						},
						{
							"sTitle": "사업소명",
							"mData": "name"
						},
						{
							"sTitle": "지역",
							"mData":"location",
						},
						{
							"sTitle": "발전원",
							"mData":"powerSource",
						},
						{
							"sTitle": "발전 용량",
							"mData":"genVol",
						},
						{
							"sTitle": "ESS 용량 (PCS)",
							"mData":"pscVol",
						},
						{
							"sTitle": "ESS 용량 (BMS)",
							"mData":"bmsVol",
						},
						{
							"sTitle": "DR 자원 코드",
							"mData":"drId",
						},
						{
							"sTitle": "VPP 자원코드",
							"mData":"vppId",
						},
						{
							"sTitle": "알람 수신",
							"mData":"alarmState",
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
					// "buttons": [
					// 	{
					// 		extend: 'copyHtml5',
					// 		className: "btn_type03",
					// 		text: '데이터 복사',
					// 	},
					// 	{
					// 		extend: 'print',
					// 		text: '전체 인쇄',
					// 		className: "btn_type03",
					// 		exportOptions: {
					// 			modifier: {
					// 				selected: null
					// 			}
					// 		}
					// 	},
					// 	{
					// 		extend: 'print',
					// 		className: "btn_type03",
					// 		text: '선택 인쇄'
					// 	},
					// 	{
					// 		extend: 'excelHtml5',
					// 		className: "btn_type03",
					// 		text: 'Excel'
					// 	},
					// 	{
					// 		extend: 'csvHtml5',
					// 		className: "btn_type03",
					// 		text: 'CSV'
					// 	},
					// 	{
					// 		extend: 'pdfHtml5',
					// 		className: "btn_type03",
					// 		text: 'PDF',
					// 	},
					// ],
					
					"select": {
						// style: 'os',
						style: 'single',
						// selector: 'td:first-child > a',
						// selector: 'td:first-child > a',
						// items: 'cell',
						items: 'row'
					},
					initComplete: function(){
						let str = `
							<div id="btnGroup" class="right-end"><!--
								--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('edit')">선택 수정</button><!--
								--><button type="button" disabled class="btn_type03 disabled" onclick="updateModal('delete')">선택 삭제</button><!--
						--></div>
						`
						$("#siteTable_wrapper").append($(str));
						// this.api().columns().header().each ((el, i) => {
						// 	if(i>1){
						// 		$ (el).attr ('style', 'min-width: 160px;');
						// 	}
						// });
					},
					createRow: function (row, data, dataIndex){
						console.log("row===", row);
						 $(row).attr({
							'data-name': data.name,
							'data-role': data.user_role,
							'data-name': data.name,
						});

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
					// table.rows( indexes ).nodes().to$().find("input").prop("checked", false);
					// let self = table[ type ]( indexes ).nodes().to$().find('input');
					// console.log("dt---", table[ type ]( indexes ).nodes())
				// }).on('change', 'input[type="checkbox"]', function(){
				// 	console.log("input checkbox===")
				}).columns.adjust().responsive.recalc();
			

				// $("#newAffiliation").autocomplete({
				// 	source : affiliationList,
				// 	minLength: 1,
				// 	autoFocus: true,
				// 	classes: {
				// 		'ui-autocomplete': 'highlight'
				// 	},
				// 	delay: 500
				// });


				table.on( 'order.dt search.dt', function () {
					// console.log("this--- order", this)
					table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						cell.innerHTML = i+1;
						$(cell).data("id", i)
					});
				}).draw();

				
				$("#siteSearchBox").on( 'keyup search input paste cut', function(){
					table.search( this.value ).draw();
					// $("#userTable").dataTable().search( $(this).val() );
				});

				new $.fn.dataTable.Buttons( table, {
					name: 'commands',
					"buttons": [
						{
							extend: 'copyHtml5',
							className: "btn_type03",
							text: '데이터 복사',
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

					table.buttons( 0, null ).containers().appendTo("#exportBtnGroup");


				// $("#userList").find("li").on( 'click', function(){
				// 	if(!isEmpty($(this).data("value"))){
				// 		filterColumn("7", $(this).data("value"));
				// 	} else {
				// 		filterColumn("7", "");
				// 	}
				// });

				$("#pageLengthList").find("li").on( 'click', function(){ 
					if(!isEmpty($(this).data("value"))){
						let val = Number($(this).data("value"));
						table.page.len(val).draw();
					} else {
						table.page.len( -1 ).draw();
					}
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
		function makeAjaxCall(option){
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
	<div class="col-12">
		<div class="flex_group">
			<span class="tx_tit">사업소 유형</span>
			<div class="dropdown">
				<button class="dropdown-toggle" type="button"
					data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul id="siteTypeList" class="dropdown-menu">
						<li data-value="0"><a href="#">수요(Demand)</a></li>
						<li data-value="1"><a href="#">발전(Generation)</a></li>
					</ul>
			</div>

			<%--
			<div class="dropdown">
				<button class="dropdown-toggle" type="button"
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
				<button class="dropdown-toggle" type="button"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu">
					<c:set var="systemLoc" value="${sessionScope.systemLoc}"/>
					<c:forEach var="loc" items="${location}" varStatus="stat">
						<li><a href="#">${loc.value.name.kr}</a></li>
						<c:forEach var="country" items="${loc.value.locations}" varStatus="countryStat">
							<c:set var="choice" value="false" />
							<c:if test="${fn:length(systemLoc) > 0}">
								<c:forEach var="selLoc" items="${systemLoc}">
									<c:if test="${country.value.code eq selLoc}">
										<c:set var="choice" value="true" />
									</c:if>
								</c:forEach>
							</c:if>
							<li>
								<a href="#" tabindex="-1">
									<input type="checkbox" name="systemLoc" id="location_${countryStat.index}" value="${country.value.code}" <c:if test="${choice eq 'true'}">checked</c:if>>
									<label for="location_${countryStat.index}" <c:if test="${choice eq 'true'}">class="on"</c:if>>${country.value.code}</label>
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
				<button class="dropdown-toggle" type="button"
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
		<a href="#exportBtnGroup" data-toggle="collapse" class="btn-export fr">데이터 추출</a>
		<div id="exportBtnGroup" class="fr collapse"></div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<div class="flex_group">
				<div class="dropdown">
					<button class="dropdown-toggle" type="button"
						data-toggle="dropdown">선택<span class="caret"></span></button>
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
				<thead></thead>
				<tbody></tbody>
				<tfoot></tfoot>
			</table>
		</div>
	</div>
</div>

<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="setting-modal-content modal-content">
			<div class="modal-header"><h1>사업소 추가</h1></div>
			<div class="modal-body">
				
			</div>
		</div>
	</div>
</div>
