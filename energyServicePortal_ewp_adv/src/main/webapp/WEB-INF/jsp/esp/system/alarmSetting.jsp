<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		let sList = "${location}"

		getSites(oid);

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
					let token = '${sessionScope.userInfo.token}';
					jqXHR.setRequestHeader('Authorization', 'Bearer ' + token);
					$('.loading').show();
				},
			}
			$.ajax(option).done(function (json, textStatus, jqXHR) {
				$('.loading').hide();
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
								$('#addSiteModal').modal('show');
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
				$('.loading').hide();
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
		<h1 class="page-header">알람 메시지 관리</h1>
	</div>
</div>

<c:set var="siteList" value="${siteHeaderList}"/> <!-- 사이트 별 -->

<div class="row">
	<div class="col-12">
		<div class="flex_group">
			<span class="tx_tit">사업소</span>
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
			<span class="tx_tit">지역</span>
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button"
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
			<span class="tx_tit">발전소명</span>
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
				<thead>
					<!-- <tr>
						<th></th>
						<th>사업소 타입</th>
						<th>사업소명</th>
						<td>지역</th>
						<th>발전원</th>
						<th>발전 용량</th>
						<th>ESS 용량 (PCS)</th>
						<th>ESS 용량 (BMS)</th>
						<th>DR 자원 코드</th>
						<th>VPP 자원코드</th>
						<th>알람 설정</th>
					</tr> -->
				</thead>
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
