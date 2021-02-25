<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<c:if test="${dashboardMap eq 'google'}">
	<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
	<script type="text/javascript" src="https://maps.google.com/maps/api/js?key=AIzaSyAgEDjSwQWd_Q9RF_owO8WkMtf-6lmVSpc"></script>
</c:if>

<link type="text/css" rel="stylesheet" href="/css/vppDashboard.css">


<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header"></div>
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATABASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div class="row content-wrapper" id="vppDashboardContent">
	<div class="col-xl-4 col-md-12 col-sm-12">

		<div id="vpp-1-1">
			<div class="indiv">
				<h2 class="ntit">금일 총 전력 거래량</h2>
				<p><span>100.00</span> <span>MWh</span></p>
				<div>
					<div class="vpp-infobox">
						<p>금일 주요자원 거래량</p>
						<p>100.05 MWh</p>
					</div>
					<div class="vpp-infobox">
						<p>금일 보조자원 거래량</p>
						<p>100.05 MWh</p>
					</div>
				</div>
			</div>
			<div class="indiv">
				<h2 class="ntit">금일 총 수익</h2>
				<p><span>100.00</span> <span>만원</span></p>
				<div>
					<div class="vpp-infobox">
						<p>금일 주요자원 거래량</p>
						<p>100.05 MWh</p>
					</div>
					<div class="vpp-infobox">
						<p>금일 보조자원 거래량</p>
						<p>100.05 MWh</p>
					</div>
				</div>
			</div>
		</div>

		<div class="indiv" id="vpp-1-2">
			<div>
				<h2>전력거래량 예측</h2>
				<div>
					<!-- 그래프 -->
				</div>
			</div>
			<div>

			</div>
		</div>

		<div class="indiv" id="vpp-1-3">
			<div class="flex">
				<h2 class="actived">보조자원 예측</h2>
				<h2>충/방전 현황</h2>
			</div>
			<div>
				<!-- 그래프 -->
			</div>
		</div>

		<div class="indiv" id="vpp-1-4">
			<div>
				<h2>수익 현황</h2>
				<div> 
					<!-- 그래프 -->
				</div>
			</div>
			<div>
				<div>
					<h3>SMP 수익</h3>
					<div class="vpp-infobox">
						<p>당월</p>
						<p>3000.8 만원</p>
					</div>
					<div class="vpp-infobox">
						<p>당월</p>
						<p>3000.8 만원</p>
					</div>
				</div>
				<div>
					<h3>SMP 수익</h3>
					<div class="vpp-infobox">
						<p>당월</p>
						<p>3000.8 만원</p>
					</div>
					<div class="vpp-infobox">
						<p>당월</p>
						<p>3000.8 만원</p>
					</div>
				</div>
			</div>
		</div>

	</div>

	<div class="col-xl-4 col-md-12 col-sm-12">

		<div class="indiv" id="vpp-2-1">
			<h2>자원 현황</h2>
			<div>
				<div>
					<div class="vpp-infobox">
						<p>주요 자원</p>
					</div>
					<div>
						<div class="actived">
							<img src="" alt="태양광" />
							<p>태양광</p>
						</div>
						<div>
							<img src="" alt="풍력" />
							<p>풍력</p>
						</div>
					</div>
				</div>
				<div>
					<div class="vpp-infobox">
						<p>보조 자원</p>
					</div>
					<div>
						<div class="actived">
							<div>
								<img src="" alt="태양광" />
								<p>ESS</p>
							</div>
							<img src="" alt="통신" />
						</div>
						<div>
							<div>
								<img src="" alt="풍력" />
								<p>연료전지</p>
							</div>
							<img src="" alt="통신" />
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="indiv" id="vpp-2-2">
			<div>
				<h2>발전 현황</h2>
				<div class="sa-select">
					<div class="dropdown" id="locationList">
						<button type="button" class="dropdown-toggle w8" data-toggle="dropdown" data-name="지역"><fmt:message key='gmain.all' /><span class="caret"></span></button>
						<ul class="dropdown-menu chk-type" role="menu" id="locationULList">
							<li data-value="[loc]">
								<a href="javascript:void(0);" tabindex="-1">
									<input type="checkbox" id="location[index]" name="location" value="[loc]" checked>
									<label for="location[index]">[loc]</label>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div id="map">

			</div>
			<div>
				<p>사이트 현황</p>
				<p><img src="" alt="" /> 자동 재생</p>
			</div>
			<table>
				<colgroup>
					<col>
					<col>
					<col>
					<col>
					<col>
				</colgroup>
				<thead>
					<tr>
						<th>지역</th>
						<th>사이트명</th>
						<th>자원이용</th>
						<th>상태</th>
						<th>통신</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>강릉</td>
						<td>강릉삼복태양광발전소</td>
						<td>
							<img src="" alt="" class="actived">
							<img src="" alt="" class="actived">
							<img src="" alt="" class="actived">
							<img src="" alt="" class="">
						</td>
						<td> <span>정상</span> </td>
						<td> <span>정상</span> </td>
					</tr>
					<tr class="vpp-fold-menu">
						<td colspan="5">
							<div>
								<div>
									<img src="" alt=""> 
									<div>
										<ul>
											<li>일사량</li>
											<li>61 kWh/m.day</li>
										</ul>
										<div>
											<ul>
												<li>온도</li>
												<li>23%</li>
											</ul>
											<ul>
												<li>온도</li>
												<li>23%</li>
											</ul>
										</div>
									</div>
								</div>

								<div>
									<div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>91.12kW</p>
										</div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>91.12kW</p>
										</div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>91.12kW</p>
										</div>
									</div>
									<div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>91.12kW</p>
										</div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>91.12kW</p>
										</div>
										<div class="vpp-infobox">
											<p>발전소 용량</p>
											<p>91.12kW</p>
										</div>
									</div>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

	</div>

	<div class="col-xl-4 col-md-12 col-sm-12">
		<div class="indiv" id="vpp-3-1">
			<div class="vpp-infobox">
				<p>총 예측 사이트</p>
				<p>94 <span>개소</span></p>
			</div>
			<div class="vpp-infobox">
				<p>총 예측 사이트</p>
				<p>94 <span>개소</span></p>
			</div>
			<div class="vpp-infobox">
				<p>총 예측 사이트</p>
				<p>94 <span>개소</span></p>
			</div>
		</div>
		<div class="indiv" id="vpp-3-2">
			<h2>주간 예측오차율</h2>
			<div>
				<div>
					<div>42</div>
					<p>6%</p>
				</div>
				<div>
					<div>32</div>
					<p>8%</p>
				</div>
				<div>
					<div>15</div>
					<p>10%</p>
				</div>
				<div>
					<div>4</div>
					<p>20%</p>
				</div>
				<div>
					<div>1</div>
					<p>예측 오차</p>
				</div>
			</div>

			<p>(출력/예측/발전 단위: kWh, 오차 단위: %)</p>

			<!-- dataTable -->
			<div id="vpp-3-2-dataTable">
				
			</div>
		</div>
	</div>
</div>