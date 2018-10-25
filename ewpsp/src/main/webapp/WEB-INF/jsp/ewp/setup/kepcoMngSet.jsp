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
											<th><span>고객명</span></th>
											<td>
												<input type="text" class="input" value="테스트" disabled="disabled">
											</td>
											<th><span>고객 번호</span></th>
											<td>
												<input type="text" class="input" value="10-0000-000110">
											</td>
										</tr>
										<tr>
											<th><span>전기사용 장소</span></th>
											<td colspan="3">
												<input type="text" class="input" style="width:100%" value="울산광역시 울주군 원산로 40">
											</td>
										</tr>
										<tr>
											<th><span>계약 종별</span></th>
											<td colspan="3">
												<span><strong>구분1</strong></span>
												<select name="planType" id="planType" class="sel">
													<option value="">일반용</option>
												</select>
												<span class="ml20"><strong>구분2</strong></span>
												<select name="planType2" id="planType2" class="sel">
													<option value="">전력(갑) II</option>
												</select>
												<span class="ml20"><strong>구분3</strong></span>
												<select name="planType3" id="planType3" class="sel">
													<option value="">고압C 선택 III</option>
												</select>
											</td>
										</tr>
										<tr>
											<th><span>계량기 번호</span></th>
											<td>
												<input type="text" class="input" value="LG15 0123456">
											</td>
											<th><span>계량기 배수</span></th>
											<td>
												<input type="text" class="input" value="1">
											</td>
										</tr>
										<tr>
											<th><span>계약 전력</span></th>
											<td>
												<input type="text" name="contractPower" id="contractPower" class="input" value=""> kW
											</td>
											<th><span>목표 전력</span></th>
											<td>
												<input type="text" name="goalPower" id="goalPower" class="input" value=""> kW
											</td>
										</tr>
										<tr>
											<th><span>요금적용 전력</span></th>
											<td>
												<!-- 달력 스크립트 -->
												<input type="text" id="datepicker1" class="sel" value="" style="width:130px;">
												<input type="hidden" id="chargeYearmd" name="chargeYearmd">
												<input type="text" name="chargePower" id="chargePower" class="input" value=""> kW
											</td>
											<th><span>요금적용 전력대비</span></th>
											<td>
												<input type="text" name="chargeRate" id="chargeRate" class="input" value=""> %
											</td>
										</tr>
										<tr>
											<th><span>검침일</span></th>
											<td>
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