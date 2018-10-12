<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/setup/kepcoMngSet.js" type="text/javascript"></script>
</head>
<body>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="setup" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">한전 계약 및 전력관리 정보</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="set_top clear">
								<h2 class="ntit fl">${selViewSite.site_name }</h2>
							</div>
							<div class="set_tbl">
								<form id="siteSetForm" name="siteSetForm">
								<input type="hidden" name="siteSetIdx" id="siteSetIdx" class="input" value="">
								<input type="hidden" name="siteId" id="siteId" class="input" value="">
								<table>
									<colgroup>
										<col width="200">
										<col>
										<col width="200">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th><span>건물 요금</span></th>
											<td colspan="3">
												<!-- <select name="chargeType" id="chargeType" class="sel"> -->
												<select name="planType" id="planType" class="sel">
													<!-- <option value="1">일반용(을) – 고압 A: 선택 II</option> -->
													<option value="industrial_B_high_voltage_A_option2">산업용 전력 (을) 고압A 선택II</option>
												</select>
											</td>
										</tr>
										<tr>
											<th><span>계약 전력</span></th>
											<td colspan="3">
												<input type="text" name="contractPower" id="contractPower" class="input" value=""> kW
											</td>
										</tr>
										<tr>
											<th><span>검침일</span></th>
											<td colspan="3">
												<select name="meterReadDay" id="meterReadDay" class="sel">
													<option value="1">1일</option>
													<option value="5">5일</option>
													<option value="10">10일</option>
													<option value="15">15일</option>
													<option value="20">20일</option>
													<option value="25">25일</option>
													<option value="30">30일</option>
												</select>
											</td>
										</tr>
										<tr>
											<th><span>요금적용 전력</span></th>
											<td colspan="3">
												<select name="chargeYearm" id="chargeYearm" class="sel">
													<option value="201804">2018년 04월</option>
													<option value="201805">2018년 05월</option>
													<option value="201806">2018년 06월</option>
													<option value="201807">2018년 07월</option>
													<option value="201808">2018년 08월</option>
												</select>
												<input type="text" name="chargePower" id="chargePower" class="input" value=""> kW
											</td>
										</tr>
										<tr>
											<th><span>목표 전력</span></th>
											<td colspan="3">
												<input type="text" name="goalPower" id="goalPower" class="input" value=""> kW
											</td>
										</tr>
										<tr>
											<th><span>요금적용 전력대비</span></th>
											<td style="padding-right:20px">
												<input type="text" name="chargeRate" id="chargeRate" class="input" value=""> %
											</td>
											<th><span>수익배분 비율</span></th>
											<td>
												<input type="text" name="profitRatio" id="profitRatio" class="input" value="90"> %
											</td>
										</tr>
									</tbody>
								</table>				
								</form>
							</div>
							<div class="btn_center">
								<a href="#;" class="confirm_btn">적용</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>



   
</body>
</html>