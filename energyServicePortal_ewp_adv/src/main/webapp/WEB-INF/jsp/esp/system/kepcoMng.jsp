<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	$(document).ready(function () {
		navAddClass("setting");
		getDBData();
	});

	function getDBData() {
		getSiteSetDetailVal(); // 한전 계약 및 전력 관리 정보 조회
	}

	// 한전 계약 및 전력 관리 정보 조회
	function getSiteSetDetailVal() {
		$.ajax({
			url: "/system/getSiteSetDetail.json",
			type: 'post',
			async: false, // 동기로 처리해줌
//			data : formData,
			success: function (result) {
				var siteSetDetail = result.detail;

				if (siteSetDetail == null) {
					alert("조회 결과가 없습니다.");
					//		location.href = "/siteMain";
				} else {
					$("#custNum").val(siteSetDetail.cust_num);
					$("#useElecAddr").val(siteSetDetail.use_elec_addr);
					$("#meterNum").val(siteSetDetail.meter_num);
					$("#meterSf").val(siteSetDetail.meter_sf);
					getPlanType('', '', '', 1);
					getPlanType(siteSetDetail.plan_type, '', '', 2);
					getPlanType(siteSetDetail.plan_type, siteSetDetail.plan_type2, '', 3);
					$("#planType").val(siteSetDetail.plan_type);
					$("#planType2").val(siteSetDetail.plan_type2);
					$("#planType3").val(siteSetDetail.plan_type3);
					$("#contractPower").val(siteSetDetail.contract_power / 1000);
					$("#meterReadDay").val(siteSetDetail.meter_read_day);
					$("#chargeYearmd").val(siteSetDetail.charge_yearmd);
					var ymd = siteSetDetail.charge_yearmd;
					$("#datepicker10").val((ymd == "") ? "" : ymd.substring(0, 4) + "-" + ymd.substring(4, 6) + "-" + ymd.substring(6, 8));
					$("#chargePower").val(siteSetDetail.charge_power / 1000);
					//		$("#goalPower").val( siteSetDetail.goal_power/1000 );
					$("#reduceAmt").val(siteSetDetail.reduce_amt / 1000);
					$("#chargeRate").val(siteSetDetail.charge_rate);
					$("#siteSetIdx").val(siteSetDetail.site_set_idx);
					$("#siteId").val(siteSetDetail.site_id);

					$("#essProfitRatio").val(siteSetDetail.ess_profit_ratio);
					$("#drProfitRatio").val(siteSetDetail.dr_profit_ratio);
					$("#pvProfitRatio").val(siteSetDetail.pv_profit_ratio);
					$("#essBattery").val(siteSetDetail.ess_battery / 1000);
					$("#essPcs").val(siteSetDetail.ess_pcs / 1000);
					$("#meterClaimDay").val(siteSetDetail.meter_claim_day);
					$("#recRate").val(siteSetDetail.rec_rate);
					$("#smpRate").val(siteSetDetail.smp_rate);
					$("#recWeight").val(siteSetDetail.rec_weight);

					$("#recRateDate").val(siteSetDetail.rec_rate_date);
					var ymd2 = siteSetDetail.rec_rate_date;
					$("#datepicker11").val((ymd2 == "") ? "" : ymd2.substring(0, 4) + "-" + ymd2.substring(4, 6));
					$("#smpRateDate").val(siteSetDetail.smp_rate_date);
					var ymd3 = siteSetDetail.smp_rate_date;
					$("#datepicker12").val((ymd3 == "") ? "" : ymd3.substring(0, 4) + "-" + ymd3.substring(4, 6) + "-" + ymd3.substring(6, 8));

				}
			}
		});
	}

	$(function () {
		$(".confirm_btn").click(function () {
			if (confirm("저장하시겠습니까?")) {
				$dtpk1 = $("#datepicker10");
				$("#chargeYearmd").val(($dtpk1.val() == "") ? "" : new Date($dtpk1.val() + " 00:00:00").format("yyyyMMdd"));
				$dtpk2 = $("#datepicker11");
				$("#recRateDate").val(($dtpk2.val() == "") ? "" : new Date($dtpk2.val() + " 00:00:00").format("yyyyMMdd"));
				$dtpk3 = $("#datepicker12");
				$("#smpRateDate").val(($dtpk3.val() == "") ? "" : new Date($dtpk3.val() + " 00:00:00").format("yyyyMMdd"));
				var formData = $("#siteSetForm").serializeObject();
				updateSiteSet(formData);
			}
		});

		// 요금제구분1 선택 시
		$('#planType').change(function () {
			var planType = $(this).val();
			getPlanType(planType, '', '', 2); // 요금제구분2
		});

		// 요금제구분2 선택 시
		$('#planType2').change(function () {
			var planType2 = $(this).val();
			getPlanType($('#planType').val(), planType2, '', 3); // 요금제구분3
		});
	});


	function getPlanType(planType, planType2, planType3, gbn) {
		$.ajax({
			url: "/system/getPlanType.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: {
				planType: planType,
				planType2: planType2,
				planType3: planType3,
				gbn: gbn
			},
			success: function (result) {
				var list = result.list;

				if (gbn == 1) $siteIdSelBox = $("#siteSetForm").find("#planType");
				else if (gbn == 2) $siteIdSelBox = $("#siteSetForm").find("#planType2");
				else if (gbn == 3) $siteIdSelBox = $("#siteSetForm").find("#planType3");
				$siteIdSelBox.empty();
				$siteIdSelBox.append('<option value="">---선택---</option>');
				for (var i = 0; i < list.length; i++) {
					if (gbn == 1) $siteIdSelBox.append('<option value="' + list[i].plan_type + '">' + list[i].plan_type_name + '</option>');
					else if (gbn == 2) $siteIdSelBox.append('<option value="' + list[i].plan_type2 + '">' + list[i].plan_type_name2 + '</option>');
					else if (gbn == 3) $siteIdSelBox.append('<option value="' + list[i].plan_type3 + '">' + list[i].plan_type_name3 + '</option>');
				}

			}
		});
	}

	// 한전 계약 및 전력 관리 정보 수정
	function updateSiteSet(formData) {
	    $.ajax({
	        url: "/system/updateSiteSet.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if (resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
</script>
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">한전계약 및 요금 관리</h1>
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
													<span class="ml-20"><strong>구분2</strong></span>
													<select name="planType2" id="planType2" class="sel">
														<option value="">전력(갑) II</option>
													</select>
													<span class="ml-20"><strong>구분3</strong></span>
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
												<th></th>
												<td>
													
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
														<option value="30">말일</option>
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