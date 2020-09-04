<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		// let s = JSON.parse('${siteList}');
		// console.log("siteList---", s);
		let optionList = [
			{
				url: apiHost + "/auth/me/groups?includeSites=true&includeDevices=false",
				type: 'get',
				async: true
			},
			{
				url: apiHost + "/auth/me",
				type: "get",
				async: true,
			},
			{
				url: apiHost + "/config/sites?oid=" + oid,
				type: "get",
				async: true,
				data: {
					filter: JSON.stringify(
						{ "order": [ "updatedAt DESC" ] }
						// { "order": [ "name ASC", "updatedAt DESC" ] }
					),
				}
			},

			// {
			// 	url: apiHost + "/auth/me",
			// 	type: "get",
			// 	async: true,
			// },
		];

		// 	Promise.all([ Promise.resolve(returnAjaxRes(optionList[0])), Promise.resolve(returnAjaxRes(optionList[1])) ]).then( res => {
		Promise.resolve(returnAjaxRes(optionList[0])).then( res => {
			console.log("res=---", res)
			let flat = [];
			flat = [...res.dr_group, ...res.vpp_group, ...res.tag_group];
			console.log("flat---", isEmpty(flat))
			// console.log("flat---", flat);
			if(isEmpty(flat)) {
				drawEmptyTable($("#groupTable"));
			} else {
				if(role == 1){
					readWriteTable(flat);
				} else {
					readOnlyTable(res);
				}
			}

		});

		function readWriteTable(groupData, callback) {
			if(!callback) {
				// getPropertyData();
				// getVppDrData(vppNameData);
			} else {
				callback();
			}
			if(groupData) {
				// 1. 그룹 유형
				// 2. 그룹 명
				// 3. 사업소
				// 4. 최종 작업자
				// 5. 비고
				// 6. 업데이트 날짜

				var groupTable = $('#groupTable').DataTable({
					"aaData": groupData,
					"table-layout": "fixed",
					"fixedHeader": true,
					"bAutoWidth": true,
					"bSearchable" : true,
					// "ScrollX": true,
					// "sScrollX": "110%",
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
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								return '<a class="chk_type" href="#"><input type="checkbox" id="' + rowIndex + '" name="table_checkbox"><label for="' + rowIndex + '"></label></a>'
							},
							"className": "dt-body-center no-sorting"
						},
						// {
						// 	"sTitle": "순번",
						// 	"mData": null,
						// 	"className": "dt-center no-sorting"
						// },
						{
							"sTitle": "그룹 유형",
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								let groupType = "";
								if(full.dgid){
									return groupType = "DR 그룹";
								} else if(full.vgid){
									return groupType = "VPP 그룹";
								} else if(full.sgid){
									return groupType = "사업소 그룹";
								}
							}
						},
						{
							"sTitle": "그룹 명",
							"mData": "name"
						},
						{
							"sTitle": "사업소",
							"mData":  null,
							"mRender": function ( data, type, full, rowIndex )  {
								// console.log("full===", full)
								if(!isEmpty(full.sites)){
									let siteName = "";
									// let siteArr = [];
									$.each(full.sites, function(index, el){
										// console.log("el===", el);
										// siteArr.push(el.name);
										siteName += el.name + ", ";
									});
									// console.log("siteName===", siteName);
									// console.log("siteArr===", siteArr);
									// siteName = [].concat(...siteArr);
									// return siteName;
									return siteName = siteName.replace(/,\s*$/, "");
								} else {
									return siteName = "-";
								}

							}
						},
						{
							"sTitle": "최종작업자",
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								let updatedBy = "";
								if(!isEmpty(full.updatedBy)){
									updatedBy = full.updatedBy;
								} else {
									updatedBy = "-";
								}
								return updatedBy;
								
							}
						},
						{
							"sTitle": "업데이트 일자",
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								let date = "";
								if(!isEmpty(full.updatedAt)){
									date = new Date(full.updatedAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&ensp;' + new Date(full.updatedAt).toLocaleTimeString();
								} else {
									date = "-";
								}
								return date;
							}
						},
						{
							"sTitle": "비고",
							"mData": null,
							"mRender": function ( data, type, full, rowIndex )  {
								let desc = "";
								if(!isEmpty(full.description)){
									updatedBy = full.description;
								} else {
									desc = "-";
								}
								return desc;
							}
						}
					],
					"dom": 'tip',
					"select": {
						style: 'single',
						// selector: 'tr',
						selector: 'td input[type="checkbox"], tr',
						// selector: 'td input[type="checkbox"], td:not(:last-of-type)',
					},
					initComplete: function(settings, json ){
						let str = `<div id="btnGroup" class="right-end"><!--
							--><button type="button" disabled class="btn_type03" onclick="updateModal('edit')">선택 수정</button><!--
							--><button type="button" disabled class="btn_type03" onclick="updateModal('delete')">선택 삭제</button><!--
						--></div>`;

						let addBtnStr = `<button type="button" class="btn_type fr mb-20" onclick="updateModal('add')">추가</button>`;

						$("#groupTable_wrapper").append($(str)).prepend($(addBtnStr));
					},
					// every time DataTables performs a draw
					drawCallback: function (settings) {
						$('#groupTable_wrapper').addClass('mb-28');
					},
					// rowCallback: function ( row, data ) {
					// 	// console.log("data---", data.alarmFlag);
					// }
				}).on("select", function(e, dt, type, indexes) {
					let btn = $("#btnGroup").find(".btn_type03");
					btn.each(function(index, element){
						if($(this).is(":disabled")){
							$(this).prop("disabled", false);
						}
					});
					groupTable.rows( indexes ).nodes().to$().find("input").prop("checked", true);
					// console.log("dt---", groupTable[ type ]( indexes ).nodes())
				}).on("deselect", function(e, dt, type, indexes) {
					let btn = $("#btnGroup").find(".btn_type03");
					btn.each(function(index, element){
						if(!$(this).is(":disabled")){
							$(this).prop("disabled", true);
						}
					});
					groupTable.rows( indexes ).nodes().to$().find("input").prop("checked", false);
					// console.log("dt---", groupTable[ type ]( indexes ).nodes())
				}).columns.adjust();
				// groupTable.on( 'order.dt search.dt', function () {
				// 	groupTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
				// 		cell.innerHTML = i+1;
				// 		$(cell).data("id", i)
				// 	});
				// }).draw();

				$('#groupTable').find("input:checkbox").on('click', function() {
					var $box = $(this);
					if ($box.is(":checked")) {
						var group = "input:checkbox[name='" + $box.attr("name") + "']";
						$(group).prop("checked", false);
						$box.prop("checked", true);
					} else {
						$box.prop("checked", false);
					}
				});
				
				groupTable.on( 'column-sizing.dt', function ( e, settings ) {
					$(".dataTables_scrollHeadInner").css( "width", "100%" );
				});

				new $.fn.dataTable.Buttons( groupTable, {
					name: 'commands',
					"buttons": [
						{
							extend: 'excelHtml5',
							className: "save_btn",
							text: '엑셀 다운로드',
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
						// {
						// 	extend: 'csvHtml5',
						// 	className: "btn_type03",
						// 	text: 'CSV'
						// },
						// {
						// 	extend: 'pdfHtml5',
						// 	className: "btn_type03",
						// 	text: 'PDF',
						// },
					],
				});

				groupTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup");
				// groupTable.container().addClass( 'fit' );

				// groupTable.buttons( 0, null ).containers().prependTo("#exportBtnGroup").addClass("hidden inline");

				$("#groupSearchBox").on( 'keyup search input paste cut', function(){
					groupTable.columns(2).search( this.value ).draw();
				});

			}
		}

		function readOnlyTable(groupData) {
			// 1. 그룹 유형
			// 2. 그룹 명
			// 3. 사업소
			// 4. 최종 작업자
			// 5. 비고
			// 6. 업데이트 날짜
			var groupReadOnlyTable = $('#groupTable').DataTable({
				"aaData": newArr,
				"table-layout": "fixed",
				"fixedHeader": true,
				"bAutoWidth": true,
				"bSearchable" : true,
				"sScrollY": true,
				"scrollY": "720px",
				"bScrollCollapse": true,
				"pageLength": 100,
				"aaSorting": [[ 0, 'asc' ]],
				// "bFilter": false, disabling this option will prevent table.search()
	
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
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							return '<a class="chk_type" href="#"><input type="checkbox" id="' + rowIndex + '" name="table_checkbox"><label for="' + rowIndex + '"></label></a>'
						},
						"className": "dt-body-center no-sorting"
					},
					// {
					// 	"sTitle": "순번",
					// 	"mData": null,
					// 	"className": "dt-center no-sorting"
					// },
					{
						"sTitle": "그룹 유형",
						"mData": null,
						"mRender": function ( data, type, full, rowIndex )  {
							let groupType = "";
							if(full){
								groupType = "";
							} else {
								groupType = "";
							}

							return groupType
						},
					},
					{
						"sTitle": "그룹 명",
						"mData": "name"
					},
					{
						"sTitle": "사업소",
						"mData": "location",
					},
					{
						"sTitle": "최종작업자",
						"mData": "powerSource",
					},
					{
						"sTitle": "업데이트 일자",
						"mData": "pcsCapacity",
					},
					{
						"sTitle": "비고",
						"mData": "genCapacity",
					}
				],
				"language": {
					"emptyTable": "조회된 데이터가 없습니다.",
					"zeroRecords":  "검색된 결과가 없습니다."
				},
				"dom": 'tip',
				// "select": {
				// 	style: 'single',
				// selector: 'td:first-child > a',
				// },
				initComplete: function(){
					this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
						cell.innerHTML = i+1;
						$(cell).data("id", i);
					});
				},
			}).columns.adjust().draw();
			
			$("#groupSearchBox").on( 'keyup search input paste cut', function(){
				siteReadOnlyTable.columns(2).search( this.value ).draw();
			});
		}

		function drawEmptyTable(target){
			var t = target.DataTable({
				"table-layout": "fixed",
				"columnDefs": [
					{
						"searchable": false,
						"orderable": false,
						// { targets: [0, 1], visible: true},
						// { targets: '_all', visible: false },
						"targets": "_all"
					},
				],
				"columns": [
					{
						"title": "순번",
						"data": null,
						"className": "dt-center no-sorting",
					},
					{
						"title": "그룹 유형",
						"data": null,
						"className": "dt-center no-sorting"
					},
					{
						"title": "그룹 명",
						"data": null,
						"className": "dt-center no-sorting"
					},
					{
						"title": "사업소",
						"data": null,
						"className": "dt-center no-sorting"
					},
					{
						"title": "최종작업자",
						"data": null,
						"className": "dt-center no-sorting"
					},
					{
						"title": "업데이트 일자",
						"data": null,
						"className": "dt-center no-sorting"
					},
					{
						"sTitle": "비고",
						"mData": "genCapacity",
						"className": "dt-center no-sorting"
					},
				],
				"dom": 'tip',
				"language": {
					"emptyTable": "조회된 데이터가 없습니다.",
					"zeroRecords":  "검색된 결과가 없습니다."
				},
				initComplete: function(){
					this.addClass("stripe")
				},
			});
		}

	});


	function initModal(){
		let form = $("#updateGroupForm");
		let input = form.find("input");
		let dropdownBtn = form.find(".dropdown-toggle");
		let warning = form.find(".warning");

		$("#validGroup").addClass("hidden");
		$("#newGroupName").parent().next().prop("disabled", true);
		
		$("#addGroupBtn").prop("disabled", true);
		warning.addClass("hidden");

		input.each(function(){
			$(this).val("");
		});

		$.each(dropdownBtn, function(index, element){
			$(this).html('선택' + '<span class="caret"></span>');
			$(this).data({ "value": "", "vol-type": "", "plan-id" : "" });
			$(this).next().find("li").removeClass("hidden");
		});
		// console.log("initModal----")
	}

	function updateModal(option, callback){
		// RPS(Renewable Portfolio Standard), SMP(System Marginal Price), REC(Renewable Energy Certificate) => subsidies
		let titleAdd = $('#titleAdd');
		let newSiteName = $('#newSiteName');
		let form = $("#updateSiteForm");
		let required = form.find(".asterisk");
		let addBtn = $("#addSiteBtn");

		// ADD MODAL!!!
		if(option == "add"){
			initModal();
			if(newSiteName.parent().next().hasClass("hidden")) {
				newSiteName.parent().next().removeClass("hidden");
				newSiteName.parent().addClass("offset-width").removeClass("w-100");
			}
			titleAdd.removeClass("hidden").next().addClass("hidden");
			required.hasClass("no-symbol") ? required.removeClass("no-symbol") : null;
			addBtn.text("추가");
			$('#newSiteName').prop('disabled', false);
			$("#newVoltTypeList").prev().prop("disabled", true).data("value", "").html("선택<span class='caret'></span>");
			$("#addGroupModal").removeClass("edit").modal("show");
		} else {
			let dTable = $("#groupTable").DataTable();
			let tr = $("#groupTable").find("tbody tr.selected");
			let td = tr.find("td");
			let rowData = dTable.row(tr).data();

			$("#validSite").is(".hidden") ? null : $("#validSite").addClass("hidden");

			// EDIT MODAL!!!
			if(option == "edit") {
				addBtn.prop("disabled", false).text("수정");

				titleAdd.addClass("hidden").next().removeClass("hidden");
				required.hasClass("no-symbol") ? null : required.addClass("no-symbol");

				if(!newSiteName.parent().next().hasClass("hidden")) {
					newSiteName.parent().next().addClass("hidden");
					newSiteName.parent().removeClass("offset-width").addClass("w-100");
				}
				// 사업소 명
				newSiteName.val( td.eq(2).text() );
				// 지역
				$('#newCityList').prev().data({"name": td.eq(3).text(), "value" : td.eq(3).data("value") }).html(td.eq(3).text() + "<span class='caret'></span>");
				// Address
				if( !isEmpty(rowData.address)) {
					$('#newStreetAddr').val(rowData.address);
				}
				// 사업소 유형
				$('#newSiteType').prev().data({"name": td.eq(1).text(), "value" : td.eq(1).data("value") }).html(td.eq(1).text() + "<span class='caret'></span>");
				// 발전원
				$("#newResList").prev().data({"name": td.eq(4).text(), "value" : td.eq(4).data("value") }).html(td.eq(4).text() + "<span class='caret'></span>");
				// ESS 유무
				// console.log("es===", rowData.ess)
				if( isEmpty(rowData.ess)) {
					$('#newEssList').prev().data("value", "0").html("무<span class='caret'></span>");
				} else {
					$('#newEssList').prev().data("value", rowData.ess).html("유<span class='caret'></span>");
				}
				// 위경도
				if( !isEmpty(rowData.latlng)) {
					$('#newCoord').val(rowData.latlng);
				}
				// 추가 정보
				$('#newSiteDetail').val(rowData.detail_info);
				// 발전 용량

				// Utility info
				if( !isEmpty(rowData.utility)) {
					Promise.resolve(JSON.parse(rowData.utility)).then( util => {
						let utilPlanName = util.utility_plan_name;
						// console.log("util==", util);

						$("#newContractList").prev().data({"plan-id": util.utility_plan_id, "value": utilPlanName }).html(utilPlanName + '<span class="caret"></span>');
						$("#newVoltTypeList").prev().prop("disabled", false);
						if(!isEmpty(util.volt_name) ){
							// console.log("util.volt_name==", util.volt_name);
							$("#newVoltTypeList").prev().data({"id": util.utility_plan_id, "data-value" : util.volt_name }).html( util.volt_name + '<span class="caret"></span>');
						} else {

							$("#newVoltTypeList").prev().prop("disabled", true).html('선택<span class="caret"></span>');
						}

						$("#newPeakDemand").val(util.peak_demand);
						$("#newDrCharge").val(util.demand_charge);

						if(util.metering_day == 0){
							$("#newInspection").prev().data("value", String(util.metering_day)).html( '말일<span class="caret"></span>');
						} else {
							$("#newInspection").prev().data("value", String(util.metering_day)).html( String(util.metering_day) + '<span class="caret"></span>');
						}

						$("#newKepcoId").val(util.kepco_id);
						$("#newISmartId").val(util.ismart_id);
						$("#newISmartPwd").val(util.ismart_pass);
					});

				}

				// PowerMarket??? (tariff?) info
				if( !isEmpty(rowData.power_market)) {
					let priceModel = JSON.parse(rowData.power_market);
					// console.log("priceModel===", priceModel)
					if(priceModel.price_type == "SMP_mean") {
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( "SMP평균" + '<span class="caret"></span>');
					} else if(priceModel.price_type == "fixed") {
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( "고정가" + '<span class="caret"></span>');
					} else {
						$("#newPriceModelList").prev().data("value", priceModel.price_type).html( priceModel.price_type + '<span class="caret"></span>');
					}
					$("#newPrice").val(priceModel.price).html( priceModel.price + '<span class="caret"></span>');
				}
				// DR info
				let sectionDRInfo = $("#sectionDRInfo");
				let sectionDrDropdown = sectionDRInfo.find(".dropdown-toggle");
				let sectionDrInput = sectionDRInfo.find("input");

				if( !isEmpty(rowData.dr_group_id)) {
					$("#newDrResIdList").prev().data("value", rowData.dr_group_id).html(rowData.drName + "<span class='caret'></span>");
					sectionDrDropdown.each(function(item, index){
						// console.log("index---", index)
						$(this).prop("disabled", false);
					});
					sectionDrInput.each(function(item, index){
						$(this).prop("disabled", false);
					});
					if(!isEmpty(rowData.dr_info)){
						let dr = JSON.parse(rowData.dr_info);
						// console.log("dr===", dr);
						if( !isEmpty(dr.contract_capacity)) {
							$("#drVol").val(dr.contract_capacity);
						}
						if( !isEmpty(dr.cbl_method)) {
							$("#cblList").prev().html(dr.cbl_method + "<span class='caret'></span>");
						}
						if( !isEmpty(dr.profile_share)) {
							$("#newDrRevShare").val(dr.profile_share);
						}
					}
				} else {
					sectionDrDropdown.each(function(item, index){
						$(this).prop("disabled", true).html("선택<span class='caret'></span>");
					});
					sectionDrInput.each(function(item, index){
						$(this).prop("disabled", true).val("");
					});
				}

				// VPP info
				let sectionVppInfo = $("#sectionVppInfo");
				let sectionVppDropdown = sectionVppInfo.find(".dropdown-toggle");
				let sectionVppInput = sectionDRInfo.find("input");

				if( !isEmpty(rowData.vpp_group_id)) {
					$("#newVppResIdList").prev().data("value", rowData.vpp_group_id).html(rowData.vppName + "<span class='caret'></span>");
					sectionVppDropdown.each(function(item, index){
						$(this).prop("disabled", false);
					});
					sectionVppInput.each(function(item, index){
						$(this).prop("disabled", false);
					});
					if( !isEmpty(rowData.vpp_info)) {
						let vpp = JSON.parse(rowData.vpp_info);
						// console.log("vpp===", vpp);

						if( !isEmpty(rowData.vpp_info)) {
							console.log("vpp profile_share NOT empty")
							$("#newVppRevShare").val(vpp.profile_share);
						}
					}
				} else {
					sectionVppDropdown.each(function(item, index){
						$(this).prop("disabled", true).html("선택<span class='caret'></span>");
					});
					sectionVppInput.each(function(item, index){
						$(this).prop("disabled", true).val("");
					});
				}

				if( td.eq(9).text() != '-' ) {
					$('#newVppResIdList').prev().data("value", td.eq(9).text() ).html(td.eq(9).text() + '<span class="caret"></span>');
				} else {
					$('#newVppResIdList').prev().data("value", "").html('선택<span class="caret"></span>');
				}


				$("#addGroupModal").addClass("edit").modal("show");
			}
			// DELETE MODAL!!!
			if(option == "delete") {
				let siteName = td.eq(2).text();
				let modal = $("#deleteConfirmModal");
				let deleteBtn = $("#deleteConfirmBtn");
				let confirmSiteId = $("#confirmSite");

				$("#deleteSuccessMsg span").text(siteName);
				modal.find(".modal-body").removeClass("hidden");
				modal.modal("show");

				confirmSiteId.on("input", function() {
					if($(this).val() !== siteName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});

				confirmSiteId.on("keyup", function() {
					if($(this).val() !== siteName) {
						deleteBtn.prop("disabled", true);
						return false
					} else {
						deleteBtn.prop("disabled", false);
					}
				});
			}
		}

	}


</script>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">그룹 관리 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="flex_group">
			<span class="tx_tit">그룹 유형</span>
			<div class="dropdown">
				<button type="button" class="dropdown-toggle"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu" id="siteList">
					<li><a href="#">전체</a></li>
					<li data-name="" data-value=""><a href="#">사업소 그룹</a></li>
					<li data-name="" data-value=""><a href="#">VPP 그룹</a></li>
					<li data-name="" data-value=""><a href="#">DR 그룹</a></li>
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<div class="tx_inp_type">
				<input type="text" id="groupSearchBox" name="group_search_box" placeholder="키워드 검색">
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="groupTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:9%">
					<col style="width:12%">
					<col style="width:20%">
					<col style="width:18%">
					<col style="width:18%">
					<col style="width:18%">		
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
				<h4 id="resultSuccessMsg" class="text-blue hidden">그룹 추가가 성공적으로<br>완료 되었습니다.</h4>
				<h4 id="resultFailureMsg" class="warning-text hidden">그룹 추가에 실패하였습니다.<br>다시 시도해 주세요.</h4>
			</div>
			<div class="btn_wrap_type05"><!--
			--><button type="button" id="resultBtn" class="btn_type03" data-dismiss="modal" aria-label="Close">확인</button><!--
		--></div>
		</div>
	</div>
</div>


<div class="modal fade stack" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="resultModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 id="deleteSuccessMsg" class="ntit">그룹 삭제를 계속 진행 하시려면,<br><span class="text-blue"></span>&ensp;를 입력해 주세요.</h5>
			</div>
			<div class="modal-body">
				<div class="tx_inp_type"><input type="text" name="confirm_site" id="confirmSite" placeholder="사이트 이름 입력"/></div>
			</div>
			<div class="btn_wrap_type05"><!--
				--><button type="button" class="btn_type03 w80" data-dismiss="modal" aria-label="Close">취소</button><!--
				--><button type="submit" id="deleteConfirmBtn" class="btn_type w80 ml-12" disabled>확인</button><!--
			--></div>
		</div>
	</div>
</div>


<c:set var="siteList" value="${siteHeaderList}"/>

<div class="modal fade" id="addGroupModal" tabindex="-1" role="dialog" aria-labelledby="addGroupModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-lg">
		<div class="modal-content group-modal-content">
			<div id="titleAdd" class="modal-header mb-10"><h1>그룹 추가<span class="required px-4 fr">필수 입력 항목</span></h1></div>
			<div id="titleEdit" class="modal-header"><h1>사업소 정보 수정</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form id="updateSiteForm" name="add_user_form">
						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">그룹 유형</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-10">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newSiteType" class="dropdown-menu">
										<li data-name="" data-value=""><a href="#">전체</a></li>
										<li><a href="#">사업소 그룹</a></li>
										<li><a href="#">VPP 그룹</a></li>
					 					<li><a href="#">DR 그룹</a></li>
									</ul>
								</div>
								<small class="hidden warning">그룹 유형을 선택해 주세요</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-2"><span class="input_label">거래 ID</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-10">
								<div class="tx_inp_type"><input type="text" id="newTradeId" name="new_trade_id" /></div>
								<small class="hidden warning">거래 아이디를 입력해 주세요.</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">그룹 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-10">
								<div class="flex_start">
									<div class="tx_inp_type offset-73">
										<input type="text" name="new_site_name" id="newSiteName" placeholder="입력" minlength="2" maxlength="15">
									</div>
									<button type="button" class="btn_type fr" onclick="checkSiteId($('#newSiteName').val())" disabled>중복 체크</button>
								</div>
								<small class="hidden warning">추가하실 사이트를 입력해 주세요</small>
								<small class="hidden warning">2~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidSite" class="hidden warning">이미 등록되어 있는 그룹 입니다.</small>
								<small id="validSite" class="text-blue text-sm hidden">추가 가능한 그룹 입니다.</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-2 hidden"><span class="input_label">그룹 공유</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-10 hidden">
								<div class="flex_start">

								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-2"><span class="input_label asterisk">사업소 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-10">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newSiteList" class="dropdown-menu">
										<!-- <c:forEach var="site" items="${siteList}" varStatus="siteName">
											<li data-id="${site.name}" data-value="${site.name}">
												<a href="#" tabindex="-1"><c:out value="${site.name}"></c:out>
													<input type="checkbox" name="${site.name}" id="${site.name}" value="${site.name}">
													<label for="${site.name}" class="on"><c:out value="${}"></c:out></label>
												</a>
											</li>
										</c:forEach> -->
									</ul>
								</div>
								<small class="hidden warning">사업소를 선택해 주세요</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-2"><span class="input_label">추가 정보</span></div>
							<div class="col-xl-10 col-lg-10 col-md-10 col-sm-10">
								<textarea name="new_site_desc" id="newSiteDetail" class="textarea" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn_wrap_type02">
									<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addSiteBtn" class="btn_type" disabled>추가</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
