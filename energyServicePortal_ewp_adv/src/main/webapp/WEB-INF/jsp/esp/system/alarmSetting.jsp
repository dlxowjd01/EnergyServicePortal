<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		getDeviceList();
		function getDeviceList () {
			let option = {
				url: apiHost + "/alarms/code_sets?",
				type: "get",
				async: true,
				data: {
					includeCodes : true
				},
				beforeSend: function (jqXHR, settings) {
					$('.loading').show();
				},
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];

				$.each(data, function (item, index) {
					let deviceType = '';
					console.log("item--", item);
					if(!isEmpty(item.device_type)){
						deviceType = item.device_type;
					} else {
						deviceType = '';
					}
				});
				// Promise.all(json.map( (x, index) => {
				// 	newArr.push(obj);
				// }));

				// $('#example').dataTable({
				// 	"aaData": newArr,
				// 	// "fixedHeader": true,
				// 	"scrollX": false,
				// 	"scrollY": "400px",
				// 	// columnDefs: [ {
				// 	// 	orderable: true,
				// 		// className: 'select-checkbox',
				// 		// targets:   0
				// 	// }],
				// 	// order: [[ 1, 'asc' ]],
				// 	// colReorder: {
				// 	// 	realtime: false
				// 	// },
				// 	"lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
				// 	"aoColumns": [
				// 		{
				// 			"sTitle": "",
				// 			"mData": "",
				// 			"mRender": function ( data, type, row )  {
				// 				return '<a class="chk_type" href="javascript:void(0); onclick=""><input type="checkbox" id="' + row.idx + '" name="' + row.sid + '"><label for="' + row.idx + '"></label></a>'
				// 			},
				// 			"className": "dt-body-center"
				// 		},
				// 		{
				// 			"sTitle": "사업소 타입",
				// 			"mData": "siteType",
						
				// 		},
				// 		{
				// 			"sTitle": "사업소명",
				// 			"mData": "name"
				// 		},
				// 		{
				// 			"sTitle": "지역",
				// 			"mData":"location",
				// 		},
				// 		{
				// 			"sTitle": "발전원",
				// 			"mData":"powerSource",
				// 		},
				// 		{
				// 			"sTitle": "발전 용량",
				// 			"mData":"genVol",
				// 		},
				// 		{
				// 			"sTitle": "ESS 용량 (PCS)",
				// 			"mData":"pscVol",
				// 		},
				// 		{
				// 			"sTitle": "ESS 용량 (BMS)",
				// 			"mData":"bmsVol",
				// 		},
				// 		{
				// 			"sTitle": "DR 자원 코드",
				// 			"mData":"drId",
				// 		},
				// 		{
				// 			"sTitle": "VPP 자원코드",
				// 			"mData":"vppId",
				// 		},
				// 		{
				// 			"sTitle": "알람 수신",
				// 			"mData":"alarmState",
				// 		},
				// 	],
				// 	dom: 'Bfltip',
				// 	// dom: 'Bfrtip',
				// 	buttons: [
				// 		{
				// 			extend: 'copyHtml5',
				// 			className: "btn_type03",
				// 			text: '데이터 복사',
				// 		},
				// 		{
				// 			extend: 'print',
				// 			text: '전체 인쇄',
				// 			className: "btn_type03",
				// 			exportOptions: {
				// 				modifier: {
				// 					selected: null
				// 				}
				// 			}
				// 		},
				// 		{
				// 			extend: 'print',
				// 			className: "btn_type03",
				// 			text: '선택 인쇄'
				// 		},
				// 		{
				// 			extend: 'excelHtml5',
				// 			className: "btn_type03",
				// 			text: 'Excel'
				// 		},
				// 		{
				// 			extend: 'csvHtml5',
				// 			className: "btn_type03",
				// 			text: 'CSV'
				// 		},
				// 		{
				// 			extend: 'pdfHtml5',
				// 			className: "btn_type03",
				// 			text: 'PDF',
				// 		},
				// 		{
				// 			text: '추가',
				// 			className: "btn_type fr",
				// 			action: function (e, node, config){
				// 				console.log("node===", node, "e---", e, "config===", config)
				// 				$('#addSiteModal').modal('show');
				// 			}
				// 		}
				// 	],
				// 	select: {
				// 		style: 'os',
				// 		items: 'cell'
				// 	},
				// 	// select: true,
				// 	// select: {
				// 	// 	style:    'os',
				// 	// 	selector: 'td:first-child'
				// 	// },
				// 	rowCallback: function ( row, data ) {
				// 		// console.log("row-selected--", row)
				// 		// $('input.editor-active', row).prop( 'checked', data.active == 1 );
				// 	}
				// });

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
	});

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">알람 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="flex_group">
			<span class="tx_tit">설비 타입</span>
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button"
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
		</div>
		<div class="flex_group">
			<span class="tx_tit">제조사</span>
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu">
				</ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">모델명</span>
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button"
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
			<span class="tx_tit">펌웨어 버전</span>
			<div class="flex_start">
				<div class="tx_inp_type">
					<input type="text" id="key_word" placeholder="입력">
				</div>
				<button type="button" class="btn_type ml-16" onclick="getDataList();">검색</button>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
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
