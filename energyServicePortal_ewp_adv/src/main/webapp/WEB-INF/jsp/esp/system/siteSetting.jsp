<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		let sList = "${location}"
		// let p = JSON.parse(sList);
		console.log("p---", sList);
		// $.each(p, function(index, element){
		// 	console.log("elemet---", element)
		// });

		var table = $('#example').DataTable({
			fixedHeader: true
		});

		$('#example tbody').on('click', 'tr', function () {
			var data = table.row( this ).data();
			alert( data[0]+  ' 열을 클릭 했습니다.' );
		});
	});

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">사이트 관리</h1>
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
						<th>Name</th>
						<th>Position</th>
						<th>Office</th>
						<th>Age</th>
						<th>Start date</th>
						<th>Salary</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
					<tr>
						<td>Tiger Nixon</td>
						<td>System Architect</td>
						<td>Edinburgh</td>
						<td>61</td>
						<td>2011/04/25</td>
						<td>$320,800</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<th>total</th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</div>