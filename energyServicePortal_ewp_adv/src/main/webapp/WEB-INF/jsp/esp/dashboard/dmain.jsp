<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="container-fluid">
	<div class="row header-wrapper">
		<div class="col-12">
			<h1 class="page-header fl">${siteName}</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime"></em>
				<span>DATA BASE TIME</span>
				<em class="dbTime"></em>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-xl-6 col-lg-12 col-md-12 col-sm-12">
			<div class="indiv smain-table">
				<div class="table-top clear">
					<div class="fl">
						<div class="dropdown" id="productType">
							<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown">
								상품 구분<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk-type" role="menu">
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType0" name="productType" value="1" checked>
										<label for="productType0">전체</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType1" name="productType" value="2">
										<label for="productType1">표준 DR</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType2" name="productType" value="3">
										<label for="productType2">중소 DR</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="productType3" name="productType" value="3">
										<label for="productType3">UFR DR</label>
									</a>
								</li>
							</ul>
						</div>
					</div>

					<div class="fl">
						<div class="dropdown" id="metropolitanArea">
							<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown">
								지역<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk-type" role="menu">
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="metropolitanArea0" name="metropolitanArea" value="1" checked>
										<label for="metropolitanArea0">수도권</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="metropolitanArea1" name="metropolitanArea" value="2">
										<label for="metropolitanArea1">비수도권</label>
									</a>
								</li>
							</ul>
						</div>
					</div>

					<div class="fl">
						<div class="dropdown" id="communicationStatus">
							<button type="button" class="dropdown-toggle w8 no-close" data-toggle="dropdown">
								통신상태<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk-type" role="menu">
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="communicationStatus0" name="communicationStatus" value="1" checked>
										<label for="communicationStatus0">전체</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="communicationStatus1" name="communicationStatus" value="2">
										<label for="communicationStatus1">정상</label>
									</a>
								</li>
								<li>
									<a href="javascript:void(0);" tabindex="-1">
										<input type="checkbox" id="communicationStatus2" name="communicationStatus" value="3">
										<label for="communicationStatus2">오류</label>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="fl">
						<input type="text" class="input" name="keyword" value="" placeholder="키워드">
					</div>
				</div>
			</div>
		</div>

		<div class="col-xl-6 col-lg-12 col-md-12 col-sm-12">
			<div class="indiv smain-alarm" data-alarm="">
				<div class="alarm-status clear">
					<div class="alarm-alert"><span>주요 알림</span><em>0</em></div>
					<div class="alarm-warning"><a href="javascript:void(0);" onclick="pageMove('', 'alarm');" class="btn btn-cancel">상세보기</a></div>
				</div>
				<div class="alarm-notice">
					<ul id="alarmNotice">
<%--						<li>--%>
<%--							<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');" class="[level]">--%>
<%--								<span class="err-msg">[site_name] - [message]</span>--%>
<%--								<span class="err-time">[standardTime]</span>--%>
<%--							</a>--%>
<%--						</li>--%>
					</ul>
				</div>
			</div>
			<div class="indiv smain-circle">
				<div class="chart-top">
					<h2 class="ntit">사용량 현황</h2>
				</div>
				<div class="search-wrap">
					<div class="inchart">
						<div id="hourlyChart"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>