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
							<form id="siteSetForm" name="siteSetForm">
							<div class="set_tbl">
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
												<input type="text" name="" id="" class="input" value="${selViewSite.site_name }" disabled="disabled">
											</td>
											<th><span>고객 번호</span></th>
											<td>
												<input type="text" name="custNum" id="custNum" class="input" value="" maxlength="20">
											</td>
										</tr>
										<tr>
											<th><span>전기사용 장소</span></th>
											<td colspan="3">
												<input type="text" name="useElecAddr" id="useElecAddr" class="input" style="width:100%" value="" maxlength="120">
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
												<input type="text" name="meterNum" id="meterNum" class="input" value="" maxlength="20">
											</td>
											<th><span>계량기 배수</span></th>
											<td>
												<input type="text" name="meterSf" id="meterSf" class="input" value="" maxlength="11" onkeydown="onlyNum(event);">
											</td>
										</tr>
										<tr>
											<th><span>계약 전력</span></th>
											<td>
												<input type="text" name="contractPower" id="contractPower" class="input" value="" maxlength="11" onkeydown="onlyNum(event);"> kW
											</td>
											<th><span>감축 용량</span></th>
											<td>
												<!-- <input type="text" name="goalPower" id="goalPower" class="input" value="" maxlength="11" onkeydown="onlyNum(event);"> kW -->
												<input type="text" name="reduceAmt" id="reduceAmt" class="input" value="" maxlength="11" onkeydown="onlyNum(event);"> kW
											</td>
										</tr>
										<tr>
											<th><span>요금적용 전력</span></th>
											<td>
												<!-- 달력 스크립트 -->
												<input type="text" id="datepicker10" class="sel" value="" style="width:130px;">
												<input type="hidden" id="chargeYearmd" name="chargeYearmd">
												<input type="text" name="chargePower" id="chargePower" class="input" maxlength="11" value=""> kW
											</td>
											<th><!-- <span>요금적용 전력대비</span> --></th>
											<td>
												<!-- <input type="text" name="chargeRate" id="chargeRate" class="input" value="" maxlength="2" onkeydown="onlyNum(event);"> % -->
											</td>
										</tr>
										<tr>
											<th><span>검침일</span></th>
											<td>
												<select name="meterReadDay" id="meterReadDay" class="sel">
													<option value="1">1일</option>
													<option value="2">2일</option>
													<option value="3">3일</option>
													<option value="4">4일</option>
													<option value="5">5일</option>
													<option value="6">6일</option>
													<option value="7">7일</option>
													<option value="8">8일</option>
													<option value="9">9일</option>
													<option value="10">10일</option>
													<option value="11">11일</option>
													<option value="12">12일</option>
													<option value="13">13일</option>
													<option value="14">14일</option>
													<option value="15">15일</option>
													<option value="16">16일</option>
													<option value="17">17일</option>
													<option value="18">18일</option>
													<option value="19">19일</option>
													<option value="20">20일</option>
													<option value="21">21일</option>
													<option value="22">22일</option>
													<option value="23">23일</option>
													<option value="24">24일</option>
													<option value="25">25일</option>
													<option value="26">26일</option>
													<option value="27">27일</option>
													<option value="28">28일</option>
													<option value="29">29일</option>
													<option value="30">30일</option>
												</select>
											</td>											
											<th><span>청구일</span></th>
											<td>
												<select name="meterClaimDay" id="meterClaimDay" class="sel">
													<option value="1">1일</option>
													<option value="5">5일</option>
													<option value="10">10일</option>
													<option value="15">15일</option>
													<option value="20">20일</option>
													<option value="25">25일</option>
													<option value="30">30일</option>
												</select>
											</td>
											<!-- <th><span>수익배분 비율</span></th>
											<td>
												<input type="text" name="profitRatio" id="profitRatio" class="input" value="" maxlength="2" onkeydown="onlyNum(event);"> %
											</td> -->
										</tr>
									</tbody>
								</table>				
							</div>
							<div class="set_top mt40 clear">
								<h2 class="ntit fl">ESS 구축 용량</h2>
							</div>
							<div class="set_tbl">
								<table>
									<colgroup>
										<col width="200">
										<col>
										<col width="200">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th><span>ESS Battery</span></th>
											<td>
												<input type="text" name="essBattery" id="essBattery" class="input" value=""> kWh
											</td>
											<th><span>PCS</span></th>
											<td>
												<input type="text" name="essPcs" id="essPcs" class="input" value=""> kW
											</td>
										</tr>
									</tbody>
								</table>				
							</div>
							<div class="set_top mt40 clear">
								<h2 class="ntit fl">PV 거래 단가</h2>
							</div>
							<div class="set_tbl">
								<table>
									<colgroup>
										<col width="200">
										<col>
										<col width="200">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th><span>REC 단가</span></th>
											<td>
												<!-- 달력 스크립트 -->
												<input type="text" id="datepicker11" class="sel" value="" style="width:130px;">
												<input type="hidden" id="recRateDate" name="recRateDate">
												<input type="text" name="recRate" id="recRate" class="input" value=""> 원/REC
											</td>
											<th><span>SMP 단가</span></th>
											<td>
												<!-- 달력 스크립트 -->
												<input type="text" id="datepicker12" class="sel" value="" style="width:130px;">
												<input type="hidden" id="smpRateDate" name="smpRateDate">
												<input type="text" name="smpRate" id="smpRate" class="input" value=""> 원/kWh
											</td>
										</tr>
										<tr>
											<th><span>REC 가중치</span></th>
											<td>
												<input type="text" name="recWeight" id="recWeight" class="input" value="" style="width:130px;">
											</td>
											<th></th>
											<td>
												
											</td>
										</tr>
									</tbody>
								</table>				
							</div>		
							<div class="set_top mt40 clear">
								<h2 class="ntit fl">수익배분</h2>
							</div>
							<div class="set_tbl">
								<table>
									<colgroup>
										<col width="200">
										<col>
										<col width="200">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th><span>ESS 수익배분 비율</span></th>
											<td>
												<input type="text" name="essProfitRatio" id="essProfitRatio" class="input" value="" style="width:130px;" maxlength="2" onkeydown="onlyNum(event);"> %
											</td>
											<th></th>
											<td>
												
											</td>
										</tr>
										<tr>
											<th><span>DR 수익배분 비율</span></th>
											<td>
												<input type="text" name="drProfitRatio" id="drProfitRatio" class="input" value="" style="width:130px;" maxlength="2" onkeydown="onlyNum(event);"> %
											</td>
											<th></th>
											<td>
												
											</td>
										</tr>
										<tr>
											<th><span>PV 수익배분 비율</span></th>
											<td>
												<input type="text" name="pvProfitRatio" id="pvProfitRatio" class="input" value="" style="width:130px;" maxlength="2" onkeydown="onlyNum(event);"> %
											</td>
											<th></th>
											<td>
												
											</td>
										</tr>
									</tbody>
								</table>				
							</div>																		
							</form>
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