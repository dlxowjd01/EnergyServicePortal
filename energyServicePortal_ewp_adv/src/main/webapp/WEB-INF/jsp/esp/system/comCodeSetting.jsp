<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		let sList = "${location}"

		// getSites(oid);

		function getSites (siteId) {
			let option = {
				url: apiHost + "/config/sites",
				type: "get",
				async: true,
				data: {
					oid: siteId,
					filter: { 
						"limit": 200,
						"fields": {

						},
					}
				},
				beforeSend: function (jqXHR, settings) {
					$('.loading').show();
				},
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];

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

				$('#example').dataTable({
					"aaData": newArr,
					// "fixedHeader": true,
					"scrollX": false,
					"scrollY": "400px",
					// columnDefs: [ {
					// 	orderable: true,
						// className: 'select-checkbox',
						// targets:   0
					// }],
					// order: [[ 1, 'asc' ]],
					// colReorder: {
					// 	realtime: false
					// },
					"lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
					// "columns": [
					// 	{
					// 		"data":  "",
					// 		render: function ( data, type, row ) {
					// 			// console.log("data--", row, "type===", type)
					// 			return '<a class="chk_type" href="javascript:void(0); onclick=""><input type="checkbox" id="' + row.idx + '" name="' + row.sid + '"><label for="' + row.idx + '"></label></a>'
					// 		},
					// 		className: "dt-body-center"
					// 	},
					// 	{ "data": "siteType" },
					// 	{ "data": "name"},
					// 	{ "data": "location"},
					// 	{ "data": "powerSource" },
					// 	{ "data": "genVol" },
					// 	{ "data": "pscVol" },
					// 	{ "data": "bmsVol" },
					// 	{ "data": "drId" },
					// 	{ "data": "vppId"},
					// 	{ "data": "alarmState" },
					// ],

					"aoColumns": [
						{
							"sTitle": "",
							"mData": "",
							"mRender": function ( data, type, row )  {
								// console.log('row==', row)
								return '<a class="chk_type" href="javascript:void(0); onclick=""><input type="checkbox" id="' + row.idx + '" name="' + row.sid + '"><label for="' + row.idx + '"></label></a>'
							},
							"className": "dt-body-center"
						},
						{
							"sTitle": "그룹 타입",
							"mData": "siteType",
						
						},
						{
							"sTitle": "그룹명",
							"mData": "name"
						},
						{
							"sTitle": "사업소",
							"mData":"location",
						},
						{
							"sTitle": "최종 작업자",
							"mData":"powerSource",
						},
						{
							"sTitle": "비고",
							"mData":"genVol",
						}
					],
					dom: 'Bfltip',
					// dom: 'Bfrtip',
					buttons: [
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
						{
							text: '추가',
							className: "btn_type fr",
							action: function (e, node, config){
								console.log("node===", node, "e---", e, "config===", config)
								$('#addUserModal').modal('show');
							}
						}
					],
					select: {
						style: 'os',
						items: 'cell'
					},
					// select: true,
					// select: {
					// 	style:    'os',
					// 	selector: 'td:first-child'
					// },
					rowCallback: function ( row, data ) {
						// console.log("row-selected--", row)
						// $('input.editor-active', row).prop( 'checked', data.active == 1 );
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

		// let p = JSON.parse(sList);
		// console.log("p---", sList);
		// $.each(p, function(index, element){
		// 	console.log("elemet---", element)
		// });

		// var table = $('#example').DataTable({
		// 	// "fixedHeader": true
		// });

		// new $.fn.dataTable.FixedHeader( table, {
		// 	alwaysCloneTop: true
		// });

	});

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">공통 코드 관리 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-3">
		<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
			<div class="panel panel-default">
			  	<div class="panel-heading active" role="tab" id="headingOne">
					<h4 class="panel-heading">
				  		<a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne" class="panel-fold"></a>
					</h4>
			  	</div>
			  	<div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
					<div class="panel-body">

					</div>
			  	</div>
			</div>
		  </div>
	</div>
	<div class="col-9">
		<div class="indiv">
			<h2 class="tx_tit"></h2>
			<table id="example" class="stripe">
				<thead></thead>
				<tbody>
				</tbody>
				<tfoot>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tfoot>
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
