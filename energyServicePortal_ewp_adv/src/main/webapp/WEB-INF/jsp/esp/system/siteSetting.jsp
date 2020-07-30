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
					filter:
						{ "includeSites": true },
						// { "limit": 30 },
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
						obj.powerSource = "마이크로 그리드"
					} else if(x.resource_type === 1){
						obj.powerSource = "PV"
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
					columnDefs: [ {
						orderable: false,
						className: 'select-checkbox',
						targets:   0
					}],
					order: [[ 1, 'asc' ]],
					"columns": [
						{
							"data":  "",
							render: function ( data, type, row ) {
								// console.log("data--", row, "type===", type)
								return '<a class="chk_type" href="javascript:void(0);"><input type="checkbox" id="' + row.idx + '" name="' + row.sid + '"><label for="' + row.idx + '"></label></a>'
							},
							className: "dt-body-center"
						},
						{ "data": "siteType" },
						{ "data": "name"},
						{ "data": "location"},
						{ "data": "powerSource" },
						{ "data": "genVol" },
						{ "data": "pscVol" },
						{ "data": "bmsVol" },
						{ "data": "drId" },
						{ "data": "vppId"},
						{ "data": "alarmState" },
					],
					select: {
						style:    'os',
						selector: 'td:first-child'
					},
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
		<h1 class="page-header">사업소 관리</h1>
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
					<tr>
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
					</tr>
				</thead>
				<tbody>
				</tbody>
				<tfoot>
					<tr>
						<td></td>
						<td colspan="9"></td>
						<td></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</div>