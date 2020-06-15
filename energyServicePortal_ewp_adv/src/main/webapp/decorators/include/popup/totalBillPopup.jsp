<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script>
var totKepco = "";
var totESS = "";
var totDR = "";
var totPV = "";

function totalBill(siteId) {
	var appendForm = "";

	if ($("#schForm").length == 0) {
		appendForm += '<form id="schForm" name="schForm">';
		appendForm += '<input type="hidden" id="siteId" name="siteId" value ="' + siteId + '">';
		appendForm += '<input type="hidden" id="selTermTex" name="selTermTex">';
		appendForm += '<input type="hidden" id="selTermAgo" name="selTermAgo">';
		appendForm += '<input type="hidden" id="selTermFrom" name="selTermFrom">';
		appendForm += '<input type="hidden" id="selTermTo" name="selTermTo">';
		appendForm += '<input type="hidden" id="selTerm" name="selTerm">';
		appendForm += '</form>';

		$('body').append(appendForm);

	}

	var firstDay = new Date();
	var endDay = new Date();
	var agoDay = new Date();
	var texDay = new Date();
	var stDay = new Date();
	var edDay = new Date();

	stDay = new Date(stDay.getFullYear(), stDay.getMonth() - 1, 1, 0, 0, 0);
	edDay = new Date(stDay.getFullYear(), edDay.getMonth(), 0, 23, 59, 59);
	var texChartStDay = new Date(stDay.setMinutes(stDay.getMinutes() + (new Date()).getTimezoneOffset()));
	var texChartEdDay = new Date(edDay.setMinutes(edDay.getMinutes() + (new Date()).getTimezoneOffset()));


	firstDay.setYear(firstDay.getFullYear() - 1);
	firstDay = new Date(firstDay.setMonth(firstDay.getMonth() + 1));
	SelTerm = "billSelectMM_pv";
	$("#selTerm").val(SelTerm);


	texDay.setYear(texDay.getFullYear());
	texDay = new Date(texDay.setMonth(texDay.getMonth() - 1));
	$("#selTermTex").val(texDay.format('yyyyMM'));
	$("#selTermTo").val(endDay.format("yyyyMM"));
	$("#selTermFrom").val(agoDay.format("yyyyMM"));

	var formData = $("#schForm").serializeObject();
	getSiteSetDetail(formData);
	getKepcoTexBill(formData);
	getESSRevenueTex(formData);
	getDRRevenueTex(formData); // 명세서 조회

	$("#selTermFrom").val(stDay.format("yyyyMMddHHmmss"));
	$("#selTermTo").val(edDay.format("yyyyMMddHHmmss"));

	formData = $("#schForm").serializeObject();

	getPVRevenueTex(formData);

	var totTex = totKepco + totESS + totDR + totPV;
	var texBillday = texDay.format('yyyyMM');

	$("#texTotBill").text("(종합)에너지절감 솔루션 제공 전기요금 절감 수익 배분 청구서 (’" + texBillday.substring(2, 4) + "년" + texBillday.substring(4, 6) + "월)");
	$("#texTotDay").text("청구일 : " + texBillday.substring(0, 4) + "-" + texBillday.substring(4, 6) + "-" + "20");
	$(".total_tex").text(numberComma(totTex));

	$("#schForm").remove();

	popupOpen('totaldprint');

}


//통합 한전 명세서 조회
function getKepcoTexBill(formData) {
 $.ajax({
     url: "/billRevenue/getKepcoTexBill.json",
     type: 'post',
     async: false, // 동기로 처리해줌
     data: formData,
     success: function (result) {
    	 var texList = result.texList;
    		var kepcoStr = "";
    		var kepcoFootStr = "";

    		if (texList.length > 0) {

    			var chartList = result.chartList;
    			var yyyyMM = texList[0].bill_yearm;
    			var totalTex = texList[0].tot_elec_rate + texList[0].val_add_tax + texList[0].elec_fund;
//    				var texStr = "";
//    				var texFoodStr = "";
//    				var customerStr = "";
//    				var texInfoStr = "";
//    				var datatable = "";
    			var str11 = "";
    			var delLastWon = Math.floor(totalTex / 10) * 10 - totalTex;
    			totKepco = Math.floor(texList[0].tot_amt_bill / 10) * 10;
    			if (meterReadDay == 30 && yyyyMM.substring(4, 6) == 02) {
    				meterReadDay = 28;
    			}

    			kepcoStr += "<tr>";
    			kepcoStr += "<th>기본요금</th>";
    			kepcoStr += "<td align='right'>" + numberComma(texList[0].base_rate) + "원</td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>전력량요금</th>";
    			kepcoStr += "<td align='right'>" + numberComma(texList[0].consume_rate) + "원</td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>전기요금계</th>";
    			kepcoStr += "<td align='right'>" + numberComma(texList[0].tot_elec_rate) + "원</td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>부가가치세</th>";
    			kepcoStr += "<td align='right'>" + numberComma(texList[0].val_add_tax) + "원</td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>전력기금</th>";
    			kepcoStr += "<td align='right'>" + numberComma(texList[0].elec_fund) + "원</td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>원단위절사</th>";
    			kepcoStr += "<td align='right'>" + delLastWon + "원</td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>당월요금계</th>";
    			kepcoStr += "<td align='right'>" + numberComma(Math.floor(texList[0].tot_amt_bill / 10) * 10) + "원</td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>미납요금</th>";
    			kepcoStr += "<td align='right'></td>";
    			kepcoStr += "</tr>";
    			kepcoStr += "<tr>";
    			kepcoStr += "<th>&nbsp;</th>";
    			kepcoStr += "<td align='right'>&nbsp;</td>";
    			kepcoStr += "</tr>";

    			kepcoFootStr += "<tr>";
    			kepcoFootStr += "<th>청구금액</th>";
    			kepcoFootStr += "<td align='right'>" + numberComma(Math.floor(texList[0].tot_amt_bill / 10) * 10) + "</td>";
    			kepcoFootStr += "</tr>";

    			$("#kepco").html(kepcoStr);
    			$("#kepcoFoot").html(kepcoFootStr);

    		}
     }
 });
}

//통합 ESS수익 명세서 조회
function getESSRevenueTex(formData) {
 $.ajax({
     url: "/billRevenue/getESSRevenueTex.json",
     type: 'post',
     async: false, // 동기로 처리해줌
     data: formData,
     success: function (result) {
    	 var ESSStr = "";
    		var ESSFootStr = "";
    		texList = result.texList;
    		var energyChgBasicBill = "";
    		var thisDay = new Date();
    		thisDay = new Date(thisDay.setMonth(thisDay.getMonth() - 1));
    		thisMonth = parseInt(thisDay.format("MM"));

    		if (thisMonth >= 6 && thisMonth <= 8) {
    			energyChgBasicBill = summerVal;
    		} else if (thisMonth >= 11 && thisMonth <= 2) {
    			energyChgBasicBill = winterVal;
    		} else {
    			energyChgBasicBill = springFallVal;
    		}
    		if (texList.length > 0) {
    			var yyyyMM = texList[0].bill_yearm;
//    				var essBdayInMonth  = String(texList[0].ess_bdayIn_month)   ;
//    				var essDischgOffPeak  = String(texList[0].ess_dischg_off_peak);
//    				var essDischgMidPeak  = String(texList[0].ess_dischg_mid_peak);
//    				var essDischgMaxPeak  = String(texList[0].ess_dischg_max_peak);
//    				var essChgOffPeak  = String(texList[0].ess_chg_off_peak)   ;
//    				var essChgMidPeak  = String(texList[0].ess_chg_mid_peak)   ;
//    				var essChgMaxPeak  = String(texList[0].ess_chg_max_peak)   ;
//    				var preEssIncen  = String(texList[0].pre_ess_incen)	  ;
//    				var essIncen  = String(texList[0].ess_incen)		  ;
//    				var peakRate  = String(texList[0].peak_rate)		  ;
//    				var ewpPeakRate  = String(texList[0].ewp_peak_rate)	  ;
//    				var ratePer  = String(texList[0].rate_per)		   ;
//    				var valAddTex = texList[0].val_add_tax				;
//    				var usg = texList[0].val_add_tax	;
    			var energyChgReduct = Math.round(texList[0].energy_chg_reduct);	//전력량 요금 절감(계시별)
    			var beneDivenergyChgReduct = Math.round((energyChgReduct * essProfitRatio) / 100);		//전력량 요금 절감(계시별) 수익배분
    			var essChgIncen = Math.round(texList[0].ess_chg_incen);	//ESS 충전 요금 할인
    			var beneDivessChgIncen = Math.round((essChgIncen * essProfitRatio) / 100);		//ESS 충전 요금 할인 수익배분
    			var essDischgIncen = Math.round(texList[0].ess_dischg_incen);	//ESS 방전 요금 할인
    			var beneDivessDischgIncen = Math.round((essDischgIncen * essProfitRatio) / 100);		//ESS 방전 요금 할인 수익배분
    			var total = Math.round(energyChgReduct + essChgIncen + essDischgIncen);	//총계
    			var beneDivTotal = Math.round((total * essProfitRatio) / 100);	//수익배분 총계
    			var addDivTotal = Math.round(beneDivTotal * 1.1);


    			var delLastWon = Math.floor(addDivTotal / 10) * 10 - addDivTotal; // 원단위 절사
    			totESS = addDivTotal + delLastWon;

    			ESSStr += "<tr>";
    			ESSStr += "<th>기본 요금 절감(피크저감)</th>";
    			ESSStr += "<td align='right'>0원</td>";
    			ESSStr += "<td align='right'>0원</td>";
    			ESSStr += "</tr>";
    			ESSStr += "<tr>";
    			ESSStr += "<th>전려량 요금 절감(계시별)</th>";
    			ESSStr += "<td align='right'>" + numberComma(energyChgReduct) + "원</td>";
    			ESSStr += "<td align='right'>" + numberComma(beneDivenergyChgReduct) + "원</td>";
    			ESSStr += "</tr>";
    			ESSStr += "<tr>";
    			ESSStr += "<th>ESS 충전 요금 할인</th>";
    			ESSStr += "<td align='right'>" + numberComma(essChgIncen) + "원</td>";
    			ESSStr += "<td align='right'>" + numberComma(beneDivessChgIncen) + "원</td>";
    			ESSStr += "</tr>";
    			ESSStr += "<tr>";
    			ESSStr += "<th>ESS 전용 요금 할인</th>";
    			ESSStr += "<td align='right'>" + numberComma(essDischgIncen) + "원</td>";
    			ESSStr += "<td align='right'>" + numberComma(beneDivessDischgIncen) + "원</td>";
    			ESSStr += "</tr>";
    			ESSStr += "<tr>";
    			ESSStr += "<th>총   계</th>";
    			ESSStr += "<td align='right'>" + numberComma(total) + "원</td>";
    			ESSStr += "<td align='right'>" + numberComma(beneDivTotal) + "원</td>";
    			ESSStr += "</tr>";

    			ESSStr += "<tr>";
    			ESSStr += "<th colspan='2'>수익배분 계</th>";
    			ESSStr += "<td align='right'>" + numberComma(beneDivTotal) + "원</td>";
    			ESSStr += "</tr>";
    			ESSStr += "<tr>";
    			ESSStr += "<th colspan='2'>부가가치세</th>";
    			ESSStr += "<td align='right'>" + numberComma(Math.round(beneDivTotal / 10)) + "원</td>";
    			ESSStr += "</tr>";
    			ESSStr += "<tr>";
    			ESSStr += "<th colspan='2'>원단위절사</th>";
    			ESSStr += "<td align='right'>" + delLastWon + "원</td>";
    			ESSStr += "</tr>";

    			ESSFootStr += "<tr>";
    			ESSFootStr += "<th colspan='2'>청구금액</th>";
    			ESSFootStr += "<td align='right'>" + numberComma(addDivTotal + delLastWon) + "원</td>";
    			ESSFootStr += "</tr>";

    			$("#ESS").html(ESSStr);
    			$("#ESSFoot").html(ESSFootStr);

    		}
     }
 });
}

//통합 DR 명세서 조회
function getDRRevenueTex(formData) {
  $.ajax({
      url: "/billRevenue/getDRRevenueTex.json",
      type: 'post',
      async: false, // 동기로 처리해줌
      data: formData,
      success: function (result) {
    	  var sheetList = result.sheetList;
    		var start = $("#selTermFrom").val();
    		var end = $("#selTermTo").val();
    		// 데이터 셋팅

    		if (sheetList.length > 0) {
    			for (var i = 0; i < sheetList.length; i++) {
    				var yyyyMM = sheetList[i].std_yearm;
//    					var reductCntHour  = String(sheetList[i].reduct_cnt_hour)   ;
//    					var reductCap  = String(sheetList[i].reduct_cap)   ;
//    					var reductAmt  = String(sheetList[i].reduct_amt);
//    					var reductCapPer  = String(sheetList[i].reduct_cap_per);
    				var capAmt = sheetList[i].cap_amt;
    				var reductRewardAmt = sheetList[i].reduct_reward_amt;
//    					var totalRewardAmt  = String(sheetList[i].total_reward_amt)   ;
//    					var csmRewardAmt  = String(sheetList[i].csm_reward_amt)   ;
//    					var ewpRewardAmt  = String(sheetList[i].ewp_reward_amt)   ;
    				var profitRatio = drProfitRatio;//sheetList[i].profit_ratio	  ;
    				var addRate = 0.1;

    				var total = capAmt + reductRewardAmt;
    				var beneDiv = Math.round(total * profitRatio / 100);
    				var addPrice = Math.round(beneDiv * addRate);
    				var beneDivTotal = beneDiv + addPrice;

    				var delLastWon = Math.floor((beneDivTotal / 10)) * 10 - beneDivTotal;

    				var texPrice = beneDivTotal + delLastWon;
    				totDR = texPrice;
//    					var reCsmRewardAmt = 0;
//    					if(csmRewardAmt == null || csmRewardAmt == "" || csmRewardAmt == "null") reCsmRewardAmt = null;
//    					else {
//    						reCsmRewardAmt = Math.round( Number(csmRewardAmt) );
//    					}


    				DRStr += "<tr>";
    				DRStr += "<th>용량 정산금</th>";
    				DRStr += "<td align='right'>" + numberComma(capAmt) + "</td>";
    				DRStr += "</tr>";
    				DRStr += "<tr>";
    				DRStr += "<th>감축 정산금</th>";
    				DRStr += "<td align='right'>" + numberComma(reductRewardAmt) + "</td>";
    				DRStr += "</tr>";
    				DRStr += "<tr>";
    				DRStr += "<th>총 정산금액</th>";
    				DRStr += "<td align='right'>" + numberComma(total) + "</td>";
    				DRStr += "</tr>";
//    					DRStr += "<tr>";
//    					DRStr += "<th>고객 정산 금액</th>";
//    					DRStr += "<td align='right'>"+numberComma(Math.round(reCsmRewardAmt))+"</td>";
//    					DRStr += "</tr>";
    				DRStr += "<tr>";
    				DRStr += "<th>①수익배분 계</th>";
    				DRStr += "<td align='right'>" + numberComma(beneDiv) + "</td>";
    				DRStr += "</tr>";
    				DRStr += "<tr>";
    				DRStr += "<th>부가가치세</th>";
    				DRStr += "<td align='right'>" + numberComma(addPrice) + "</td>";
    				DRStr += "</tr>";
    				DRStr += "<tr>";
    				DRStr += "<th>원단위절사</th>";
    				DRStr += "<td align='right'>" + delLastWon + "</td>";
    				DRStr += "</tr>";

    				DRFootStr += "<tr>";
    				DRFootStr += "<th>청구금액</th>";
    				DRFootStr += "<td align='right'>" + numberComma(texPrice) + "</td>";
    				DRFootStr += "</tr>";

    				$("#DR").html(DRStr);
    				$("#DRFoot").html(DRFootStr);

    			}
    		}
      }
  });
}

//통합 PV 명세서 조회
function getPVRevenueTex(formData) {
  $.ajax({
      url: "/billRevenue/getPVRevenueTex.json",
      type: 'post',
      async: false, // 동기로 처리해줌
      data: formData,
      success: function (result) {
    	  var netGenValSheetList = result.netGenValSheetList;
    		var netGenValChartList = result.netGenValChartList;
    		var smpDealChartList = result.recDealChartList;
    		var smpPriceChartList = result.smpPriceChartList;
    		var recDealChartList = result.recDealChartList;
    		var recPriceChartList = result.recPriceChartList;
    		var totPriceChartList = result.totPriceChartList;
    		var periodd = $("#selPeriodVal").val(); // 데이터조회간격
    		var start = $("#selTermFrom").val();
    		var end = $("#selTermTo").val();
    		var addTex = 0;

    		// 데이터 셋팅

//    			var reNetGenVal = 0;
//    			var reSmpDeal   = 0;
    		var reSmpPrice = 0;
//    			var reRecDeal   = 0;
    		var reRecPrice = 0;
    		var reTotPrice = 0;

    		if (netGenValSheetList != null && netGenValSheetList.length > 0) {
//    			reNetGenVal = netGenValChartList[0].net_gen_val;
//    			reSmpDeal   = smpDealChartList[0].smp_deal;
    			reSmpPrice = smpPriceChartList[0].smp_price;
//    			reRecDeal   = recDealChartList[0].rec_deal;
    			reRecPrice = recPriceChartList[0].rec_price;
    			reTotPrice = reRecPrice + reSmpPrice;

    			totBeneVal = 0;
    			delLastWon = 0;

    			addTex = Math.round(reTotPrice * pvProfitRatio / 100 * 0.1);
    			totBeneVal = (reTotPrice * pvProfitRatio) / 100 + addTex;
    			delLastWon = Math.floor(totBeneVal / 10) * 10 - totBeneVal;
    			totPV = totBeneVal + delLastWon;
    			var PVStr = "";
    			var PVFootStr = "";

    			PVStr += "<tr>";
    			PVStr += "<th>①REC 수익</th>";
    			PVStr += "<td align='right'>" + numberComma(reRecPrice) + "</td>";
    			PVStr += "</tr>";
    			PVStr += "<tr>";
    			PVStr += "<th>②SMP 수익</th>";
    			PVStr += "<td align='right'>" + numberComma(reSmpPrice) + "</td>";
    			PVStr += "</tr>";
    			PVStr += "<tr>";
    			PVStr += "<th>③총 수익</th>";
    			PVStr += "<td align='right'>" + numberComma(reTotPrice) + "</td>";
    			PVStr += "</tr>";
    			PVStr += "<tr>";
    			PVStr += "<th>④수익배분 계</th>";
    			PVStr += "<td align='right'>" + numberComma((reTotPrice * pvProfitRatio) / 100) + "</td>";
    			PVStr += "</tr>";
    			PVStr += "<tr>";
    			PVStr += "<th>부가가치세</th>";
    			PVStr += "<td align='right'>" + numberComma(addTex) + "</td>";
    			PVStr += "</tr>";
    			PVStr += "<tr>";
    			PVStr += "<th>원단위절사</th>";
    			PVStr += "<td align='right'>" + delLastWon + "</td>";
    			PVStr += "</tr>";

    			PVFootStr += "<tr>";
    			PVFootStr += "<th>청구금액</th>";
    			PVFootStr += "<td align='right'>" + (totBeneVal + delLastWon) + "</td>";
    			PVFootStr += "</tr>";

    			$("#PV").html(PVStr);
    			$("#PVFoot").html(PVFootStr);
    		}
      }
  });
}
	
</script>



    <!-- ###### 통합 명세서 Popup Start ###### -->
    <script type="text/javascript">
		$(function(){
			$(".lbtn_pdf").on('click',function(){
			$(".lbutton").hide();
			setTimeout(function () {
				$(".lbutton").show();
				},1000);
			});
	
			$('#btnPrintTot').on('click', function(){
				var $layerboxTot = $('#layerboxTot');
				$layerboxTot.css("left", "0px");
				$layerboxTot.css("top", "-200px");
				$(".lbutton").hide();
				$layerboxTot.printThis({
				});
				setTimeout(function () {
					$(".lbutton").show();
				},1000);
			});
		});
    </script>
    <div id="layerboxTot" class="totaldprint clear" style="margin:250px 0 50px;width:880px;">
    	<div class="lbutton fl">
			<a href="javascript:getPdfTotDownload()" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="#;" id="btnPrintTot" class="btnPrintTot"><span>인쇄</span></a>
		</div>  
        <div class="ltit fr">
			<a href="javascript:popupClose('totaldprint');" class="lclose">닫기</a>
        </div>
		<div class="lbody mt30">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;" id="texTotBill">
						(종합)에너지절감 솔루션 제공 전기요금 절감 수익 배분 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : ${selViewSite.site_name }</td>
					<td height="30" align="right" style="font-size:12px;" id="texTotDay">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
						이번 달 청구 금액은 <strong style="color:#438fd7" class="total_tex">37,938,260</strong>원 입니다
						<p style="padding-top:10px;font-size:12px;font-weight:normal;"><!-- (수익배분기간 : 2018-01-01 ~ 2018-12-31) --></p>
					</td>
				</tr>
			</table>

			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%;">
					<h2>1. 전기요금 내역</h2>
					<table class="tbl" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<tbody id = "kepco">
							<tr>
								<th>기본요금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전력량요금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전기요금계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전력기금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>당월요금계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>미납요금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>&nbsp;</th>
								<td align="right">&nbsp;</td>
							</tr>
						</tbody>
						<tfoot id = "kepcoFoot">
							<tr>
								<th>청구금액</th>
								<td align="right">0</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div class="fr" style="width:49%;">
					<h2>2. 에너지 절감 솔루션 수익 분배 청구 내역 </h2>
					<table class="tbl" style="margin-top:10px;">
						<thead>
							<tr>
								<th>구분</th>
								<th>절감금액</th>
								<th>수익배분</th>
							</tr>
						</thead>
						<tbody id = "ESS">
							<tr>
								<th>기본 요금 절감(피크저감)</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전려량 요금 절감(계시별)</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>ESS 충전 요금 할인</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>ESS 전용 요금 할인</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>총   계</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th colspan="2">수익배분 계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th colspan="2">부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th colspan="2">원단위절사</th>
								<td align="right">0</td>
							</tr>
						</tbody>
						<tfoot id = "ESSFoot">
							<tr>
								<th colspan="2">청구금액</th>
								<td align="right">0</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%;">
					<h2>3. DR (수요반응) 수익 배분 청구 내역</h2>
					<table class="tbl" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody id = "DR">
							<tr>
								<th>용량 정산금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>감축 정산금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>총 정산금액</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>①수익배분 계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">0</td>
							</tr>
						</tbody>
						<tfoot id = "DRFoot">
							<tr>
								<th>청구금액</th>
								<td align="right">0</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div class="fr" style="width:49%;">
					<h2>4. PV 발전 수익 배분 청구 내역</h2>
					<table class="tbl" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody id = "PV">
							<tr>
								<th>①REC 수익</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>②SMP 수익</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>③총 수익</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>④수익배분 계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">0</td>
							</tr>
						</tbody>
						<tfoot id = "PVFoot">
							<tr>
								<th>청구금액</th>
								<td align="right">0</td>
							</tr>
						</tfoot>
					</table>					
				</div>
			</div>
			<div class="clear" style="margin-top:20px;">
				<h2>5. 납입 정보</h2>
				<table class="tbl" style="margin-top:10px;">
					<colgroup>
						<col>
						<col width="25%">
					</colgroup>
					<tbody>
						<tr>
							<th>
								총 청구 금액<br/>
								(전기요금 + 에너지 절감 수익 배분 + DR 수익 배분 + PV 발전 수익 배분)
							</th>
							<td align="right"><span style="font-weight:bold;" class="total_tex">0</span></td>
						</tr>
					</tbody>
				</table>
			</div>

		</div>
    </div>
    <!-- ###### Popup End ###### -->