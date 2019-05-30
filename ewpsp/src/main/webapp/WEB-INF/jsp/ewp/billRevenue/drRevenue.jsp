<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <jsp:include page="../include/common_static.jsp"/>
        <jsp:include page="../include/sub_static.jsp"/>
        <script type="text/javascript">
            $(document).ready(function () {
                var firstDay = new Date();
                var endDay = new Date();
                var agoDay = new Date();
                var texDay = new Date();

                texDay.setYear(texDay.getFullYear());
                texDay = new Date(texDay.setMonth(firstDay.getMonth() - 1));

                agoDay.setYear(agoDay.getFullYear());
                agoDay = new Date(agoDay.setMonth(firstDay.getMonth() - 5));
                firstDay.setYear(firstDay.getFullYear() - 1);
                firstDay = new Date(firstDay.setMonth(firstDay.getMonth() + 1));

                $("#selTermTex").val(texDay.format("yyyyMM"));
                $("#selTermAgo").val(agoDay.format("yyyyMM"));
                $("#selTermFrom").val(firstDay.format("yyyyMM"));
                $("#selTermTo").val(endDay.format("yyyyMM"));
                $("#datepicker3").val(firstDay.format("yyyy-MM"));
                $("#datepicker4").val(endDay.format("yyyy-MM"));
                SelTerm = "billSelectMM";
                $("#selTerm").val(SelTerm);

                var formData = $("#schForm").serializeObject();
                getSiteSetDetail();
                getDBData(formData);

                $("#selTermFrom").val(agoDay.format("yyyyMM"));
                formData = $("#schForm").serializeObject();
                getDRRevenueTexList(formData);
            });

            $(function () {
                $("#drRevenueTex").click(function () {
                    if (sheetList.length > 0) {

                        popupOpen('dprint');
                    } else {
                        alert("조회할 명세서 내역이 없습니다.");
                    }
                });

            });

            function searchData() {
                getCollect_sch_condition(); // 검색조건 모으기
            }

            var drRevenue_head_pc = []; //  표 데이터(헤더)
            var drRevenue_data_pc = []; //  표 데이터
            var drRevenue_data_pc2 = []; //  표 데이터
            var drRevenue_data_pc3 = []; //  표 데이터
            var drRevenue_data_pc4 = []; //  표 데이터
            var drRevenue_data_pc5 = []; //  표 데이터
            var drRevenue_data_pc6 = []; //  표 데이터
            var drRevenue_data_pc7 = []; //  표 데이터
            var drRevenue_data_pc8 = []; //  표 데이터
            var drRevenue_data_pc9 = []; //  표 데이터
            var drRevenue_data_pc10 = []; //  표 데이터
            function getDBData(formData) {
                drRevenue_head_pc.length = 0;
                drRevenue_data_pc.length = 0;
                drRevenue_data_pc2.length = 0;
                drRevenue_data_pc3.length = 0;
                drRevenue_data_pc4.length = 0;
                drRevenue_data_pc5.length = 0;
                drRevenue_data_pc6.length = 0;
                drRevenue_data_pc7.length = 0;
                drRevenue_data_pc8.length = 0;
                drRevenue_data_pc9.length = 0;
                drRevenue_data_pc10.length = 0;
                drRevenueList1 = null;
                drRevenueList2 = null;
                getDRRevenueList(formData); // DR 수익 조회
                drawData(); // 차트 및 표 그리기
            }


            var texDataSet1 = [];
            var texDataSet2 = [];
            var DRRevenueTex1;
            var DRRevenueTex2;

            var sheetList = "";

            function callback_getDRRevenueTexList(result) {

                sheetList = result.sheetList;
                var chartList = result.chartList;
                var start = $("#selTermFrom").val();
                var end = $("#selTermTo").val();
                var texStr = "";
                var texFootStr = "";
                var saveStr = "";
                var saveFootStr = "";
                var beneAreaStr = "";
                var infoAreaStr = "";
                // 데이터 셋팅
                var dataSet1 = []; // chartData를 위한 변수
                var dataSet2 = []; // chartData를 위한 변수
                var totDataSet1 = 0;
                var totDataSet2 = 0;

                // 표데이터 셋팅
                if (sheetList.length > 0) {
                    for (var i = 0; i < sheetList.length; i++) {
                        var yyyyMM = sheetList[i].std_yearm;
                        var reductCntHour = String(sheetList[i].reduct_cnt_hour);
                        var reductCap = String(sheetList[i].reduct_cap);
                        var reductAmt = String(sheetList[i].reduct_amt);
                        var reductCapPer = String(sheetList[i].reduct_cap_per);
                        var capAmt = sheetList[i].cap_amt;
                        var reductRewardAmt = sheetList[i].reduct_reward_amt;
                        var totalRewardAmt = String(sheetList[i].total_reward_amt);
                        var csmRewardAmt = String(sheetList[i].csm_reward_amt);
                        var ewpRewardAmt = String(sheetList[i].ewp_reward_amt);
                        var profitRatio = drProfitRatio; //sheetList[i].profit_ratio      ;
                        var addRate = 0.1;

                        var total = capAmt + reductRewardAmt;
                        var beneDiv = Math.round(total * profitRatio / 100);
                        var addPrice = Math.round(beneDiv * addRate);
                        var beneDivTotal = beneDiv + addPrice;

                        var delLastWon = Math.floor((beneDivTotal / 10)) * 10 - beneDivTotal;

                        var texPrice = beneDivTotal + delLastWon;

                        var reReductCntHour = 0;
                        var reReductCap = 0;
                        var reReductAmt = 0;
                        var reReductCapPer = 0;
                        var reCapAmt = 0;
                        var reReductRewardAmt = 0;
                        var reTotalRewardAmt = 0;
                        var reCsmRewardAmt = 0;
                        var reEwpRewardAmt = 0;
                        var reProfitRatio = 0;

                        if (isEqVal(totalRewardAmt, "null")) reTotalRewardAmt = null;
                        else reTotalRewardAmt = Math.round(Number(totalRewardAmt));
                        if (isEqVal(csmRewardAmt, "null")) reCsmRewardAmt = null;
                        else reCsmRewardAmt = Math.round(Number(csmRewardAmt));
                        if (isEqVal(ewpRewardAmt, "null")) reEwpRewardAmt = null;

                        $("#texBill").text("DR (수요반응) 수익 배분 청구서 (’" + yyyyMM.substring(2, 4) + "년" + yyyyMM.substring(4, 6) + "월)");
                        $("#texDay").text("청구일 : " + yyyyMM.substring(0, 4) + "-" + yyyyMM.substring(4, 6) + "-" + meterClaimDay);
                        $(".dp_total").text(numberComma(texPrice));
                        // 표데이터 셋팅

                        texStr += "<tr>";
                        texStr += "<th>용량 정산금</th>";
                        texStr += "<td align='right'>" + numberComma(capAmt) + "</td>";
                        texStr += "</tr>";
                        texStr += "<tr>";
                        texStr += "<th>감축 정산금</th>";
                        texStr += "<td align='right'>" + numberComma(reductRewardAmt) + "</td>";
                        texStr += "</tr>";
                        texStr += "<tr>";
                        texStr += "<th>총 정산금액</th>";
                        texStr += "<td align='right'>" + numberComma(total) + "</td>";
                        texStr += "</tr>";
                        //			texStr += "<tr>";
                        //			texStr += "<th>고객 정산 금액</th>";
                        //			texStr += "<td align='right'>"+numberComma(Math.round(reCsmRewardAmt))+"</td>";
                        //			texStr += "</tr>";
                        texStr += "<tr>";
                        texStr += "<th>①수익배분 계</th>";
                        texStr += "<td align='right'>" + numberComma(beneDiv) + "</td>";
                        texStr += "</tr>";
                        texStr += "<tr>";
                        texStr += "<th>부가가치세</th>";
                        texStr += "<td align='right'>" + numberComma(addPrice) + "</td>";
                        texStr += "</tr>";
                        texStr += "<tr>";
                        texStr += "<th>원단위절사</th>";
                        texStr += "<td align='right'>" + delLastWon + "</td>";
                        texStr += "</tr>";
                        texStr += "<tr>";
                        texStr += "<th>&nbsp</th>";
                        texStr += "<td align='right'>&nbsp</td>";
                        texStr += "</tr>";
                        texFootStr += "<tr>";
                        texFootStr += "<th>청구금액</th>";
                        texFootStr += "<td align='right'>" + numberComma(texPrice) + "</td>";
                        texFootStr += "</tr>";


                        saveStr += "<tr>";
                        saveStr += "<th>감축횟수-시간 (회-시간)</th>";
                        saveStr += "<td align='right'>" + reductCntHour + "</td>";
                        saveStr += "</tr>";
                        saveStr += "<tr>";
                        saveStr += "<th>감축 이행 용량 (kWh)</th>";
                        saveStr += "<td align='right'>" + numberComma(reductCap) + "</td>";
                        saveStr += "</tr>";
                        saveStr += "<tr>";
                        saveStr += "<th>감축 인정 용량 (kWh)</th>";
                        saveStr += "<td align='right'>" + numberComma(reductAmt) + "</td>";
                        saveStr += "</tr>";
                        saveStr += "<tr>";
                        saveStr += "<th>감축 이행율 (%)</th>";
                        saveStr += "<td align='right'>" + numberComma(reductCapPer) + "</td>";
                        saveStr += "</tr>";
                        saveStr += "<tr>";
                        saveStr += "<th>수익 배분 (%)</th>";
                        saveStr += "<td align='right'>" + profitRatio + "</td>";
                        saveStr += "</tr>";

                        beneAreaStr += "<tr>";
                        beneAreaStr += "<th>①수익배분 계</th>";
                        beneAreaStr += "<td align='right'>총 정산금액 x 수익배분(" + profitRatio + ")</td>";
                        beneAreaStr += "</tr>";


                        infoAreaStr += "<tr>";
                        infoAreaStr += "<th>은행명</th>";
                        infoAreaStr += "<td>우리은행</td>";
                        infoAreaStr += "</tr>";
                        infoAreaStr += "<tr>";
                        infoAreaStr += "<th>계좌번호</th>";
                        infoAreaStr += "<td>1005 – 802 - 498030</td>";
                        infoAreaStr += "</tr>";
                        infoAreaStr += "<tr>";
                        infoAreaStr += "<th>예금주</th>";
                        infoAreaStr += "<td>한국동서발전㈜</td>";
                        infoAreaStr += "</tr>";
                        infoAreaStr += "<tr>";
                        infoAreaStr += "<th>납입금액</th>";
                        infoAreaStr += "<td>" + numberComma(texPrice) + "원</td>";
                        infoAreaStr += "</tr>";
                        infoAreaStr += "<tr>";
                        infoAreaStr += "<th>납기일</th>";
                        var drRvClaimDay = yyyyMM.substring(0, 4) + "-" + yyyyMM.substring(4, 6) + "-" + meterClaimDay + " 00:00:00";
                        var drRvClaimDate = new Date(drRvClaimDay);
                        var paymentDate = new Date(drRvClaimDate.setDate(drRvClaimDate.getDate() + 10));
                        infoAreaStr += "<td>" + paymentDate.format("yyyy-MM-dd") + "</td>";
                        infoAreaStr += "</tr>";


                        $(".texArea").find("tbody").html(texStr);
                        $(".texArea").find("tfoot").html(texFootStr);
                        $(".saveArea").find("tbody").html(saveStr);
                        $(".beneArea").find("tbody").html(beneAreaStr);
                        $(".infoArea").find("tbody").html(infoAreaStr);

                    }
                }


                //}

                // 차트데이터 셋팅
                if (chartList != null && chartList.length > 0) {
                    for (var i = 0; i < chartList.length; i++) {
                        var yyyyMM = chartList[i].std_yearm;

                        // 차트데이터 셋팅
                        texDataSet1.push([Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6) - 1, 1), chartList[i].total_reward_amt]);
                        texDataSet2.push([Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6) - 1, 1), chartList[i].csm_reward_amt]);

                    }
                    // 차트데이터 셋팅
                    DRRevenueTex1 = texDataSet1;
                    DRRevenueTex2 = texDataSet2;
                    texDrawData_chart();

                }
            }

            // 명세서 차트 그리기
            function texDrawData_chart() {
                var seriesLength = myChart1.series.length;

                for (var i = seriesLength - 1; i > -1; i--) {
                    myChart1.series[i].remove();
                }

                myChart1.addSeries({
                    name: '총 정산금액',
                    color: '#438fd7', /* 총 정산금액 */
                    data: DRRevenueTex1
                }, false);

                myChart1.addSeries({
                    name: '고객 할인금액',
                    color: '#13af67', /* 고객 할인금액 */
                    data: DRRevenueTex2
                }, false);


                //	setTickInterval();
                myChart1.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;

                myChart1.redraw(); // 차트 데이터를 다시 그린다
            }


            // DR 수익 조회
            var drRevenueList1;
            var drRevenueList2;

            function callback_getDRRevenueList(result) {
                var sheetList = result.sheetList;
                var chartList = result.chartList;
                var start = $("#selTermFrom").val();
                var end = $("#selTermTo").val();
                var sheetStartDt = start.substring(0, 4) + "01";
                var sheetEndDt = end.substring(0, 4) + "12";

                // 데이터 셋팅
                var dataSet = []; // chartData를 위한 변수
                var dataSet2 = []; // chartData를 위한 변수
                var totDataSet = 0;
                var totDataSet2 = 0;
                var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
                var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
                dt_row = (Number(end.substring(0, 4)) - Number(start.substring(0, 4))) + 1;
                var dt_str_head = "";
                var dt_str = "";
                var dt_str2 = "";
                var dt_str3 = "";
                var dt_str4 = "";
                var dt_str5 = "";
                var dt_str6 = "";
                var dt_str7 = "";
                var dt_str8 = "";
                var dt_str9 = "";
                var dt_str10 = "";
                var dt_str_totalVal = 0; // 테이블 라인별 누적합
                var dt_str2_totalVal = 0; // 테이블 라인별 누적합
                var dt_str3_totalVal = 0; // 테이블 라인별 누적합
                var dt_str4_totalVal = 0; // 테이블 라인별 누적합
                var dt_str5_totalVal = 0; // 테이블 라인별 누적합
                var dt_str6_totalVal = 0; // 테이블 라인별 누적합
                var dt_str7_totalVal = 0; // 테이블 라인별 누적합
                var dt_str8_totalVal = 0; // 테이블 라인별 누적합
                var dt_str9_totalVal = 0; // 테이블 라인별 누적합
                var dt_str10_totalVal = 0; // 테이블 라인별 누적합
                var reProfitRatio_cnt = 0; // 라인별 수익비율 더한 횟수

                // 표데이터 셋팅
                if (sheetList != null && sheetList.length > 0) {
                    for (var i = 0; i < sheetList.length; i++) {
                        var yyyyMM = sheetList[i].std_yearm;
                        var reductCntHour = String(sheetList[i].reduct_cnt_hour);
                        var reductCap = String(sheetList[i].reduct_cap);
                        var reductAmt = String(sheetList[i].reduct_amt);
                        var reductCapPer = String(sheetList[i].reduct_cap_per);
                        var capAmt = String(sheetList[i].cap_amt);
                        var reductRewardAmt = String(sheetList[i].reduct_reward_amt);
                        var totalRewardAmt = String(sheetList[i].total_reward_amt);
                        var csmRewardAmt = String(sheetList[i].csm_reward_amt);
                        var ewpRewardAmt = String(sheetList[i].ewp_reward_amt);
                        var profitRatio = String(sheetList[i].profit_ratio);
                        var reReductCntHour = 0;
                        var reReductCap = 0;
                        var reReductAmt = 0;
                        var reReductCapPer = 0;
                        var reCapAmt = 0;
                        var reReductRewardAmt = 0;
                        var reTotalRewardAmt = 0;
                        var reCsmRewardAmt = 0;
                        var reEwpRewardAmt = 0;
                        var reProfitRatio = 0;

                        if (isEqVal(reductCntHour, "null")) reReductCntHour = null;
                        else reReductCntHour = Math.round(Number(reductCntHour));
                        if (isEqVal(reductCap, "null")) reReductCap = null;
                        else reReductCap = Math.round(Number(reductCap));
                        if (isEqVal(reductAmt, "null")) reReductAmt = null;
                        else reReductAmt = Math.round(Number(reductAmt));
                        if (isEqVal(reductCapPer, "null")) reReductCapPer = null;
                        else reReductCapPer = Math.round(Number(reductCapPer));
                        if (isEqVal(capAmt, "null")) reCapAmt = null;
                        else reCapAmt = Math.round(Number(capAmt));
                        if (isEqVal(reductRewardAmt, "null")) reReductRewardAmt = null;
                        else reReductRewardAmt = Math.round(Number(reductRewardAmt));
                        if (isEqVal(totalRewardAmt, "null")) reTotalRewardAmt = null;
                        else reTotalRewardAmt = Math.round(Number(totalRewardAmt));
                        if (isEqVal(csmRewardAmt, "null")) reCsmRewardAmt = null;
                        else reCsmRewardAmt = Math.round(Number(csmRewardAmt));
                        if (isEqVal(ewpRewardAmt, "null")) reEwpRewardAmt = null;
                        else reEwpRewardAmt = Math.round(Number(ewpRewardAmt));
                        if (isEqVal(profitRatio, "null")) reProfitRatio = null;
                        else {
                            reProfitRatio = Math.round(Number(profitRatio));
                            reProfitRatio_cnt = reProfitRatio_cnt + 1;
                        }

                        // 표데이터 셋팅
                        dt_str_head += "<th>" + yyyyMM.substring(0, 4) + "-" + yyyyMM.substring(4, 6) + "</th>";
                        dt_str += "<td>" + ((reReductCntHour == null) ? "" : reReductCntHour) + "</td>"; // 감축 횟수-시간 (회-hr)
                        dt_str2 += "<td>" + ((reReductCap == null) ? "" : reReductCap) + "</td>"; // 감축이행용량 (kWh)
                        dt_str3 += "<td>" + ((reReductAmt == null) ? "" : reReductAmt) + "</td>"; // 감축인정용량 (kWh)
                        dt_str4 += "<td>" + ((reReductCapPer == null) ? "" : reReductCapPer) + "</td>"; // 감축이행율 (%)
                        dt_str5 += "<td>" + ((reCapAmt == null) ? "" : reCapAmt) + "</td>"; // 용량정산금 (won)
                        dt_str6 += "<td>" + ((reReductRewardAmt == null) ? "" : reReductRewardAmt) + "</td>"; // 감축정산금 (won)
                        dt_str7 += "<td>" + ((reTotalRewardAmt == null) ? "" : reTotalRewardAmt) + "</td>"; // 총 정산금액
                        dt_str8 += "<td>" + ((reCsmRewardAmt == null) ? "" : reCsmRewardAmt) + "</td>"; // 고객 할인금액
                        dt_str9 += "<td>" + ((reEwpRewardAmt == null) ? "" : reEwpRewardAmt) + "</td>"; // EWP 정산금액 (won)
                        dt_str10 += "<td>" + ((reProfitRatio == null) ? "" : reProfitRatio) + "</td>"; // 수익비율 (%)
                        dt_str_totalVal = dt_str_totalVal + reReductCntHour;
                        dt_str2_totalVal = dt_str2_totalVal + reReductCap;
                        dt_str3_totalVal = dt_str3_totalVal + reReductAmt;
                        dt_str4_totalVal = dt_str4_totalVal + reReductCapPer;
                        dt_str5_totalVal = dt_str5_totalVal + reCapAmt;
                        dt_str6_totalVal = dt_str6_totalVal + reReductRewardAmt;
                        dt_str7_totalVal = dt_str7_totalVal + reTotalRewardAmt;
                        dt_str8_totalVal = dt_str8_totalVal + reCsmRewardAmt;
                        dt_str9_totalVal = dt_str9_totalVal + reEwpRewardAmt;
                        dt_str10_totalVal = dt_str10_totalVal + reProfitRatio;
                        if (dt_col_cnt == 12) {
                            dt_str += "<td>" + dt_str_totalVal + "</td>";
                            dt_str2 += "<td>" + dt_str2_totalVal + "</td>";
                            dt_str3 += "<td>" + dt_str3_totalVal + "</td>";
                            dt_str4 += "<td>" + dt_str4_totalVal + "</td>";
                            dt_str5 += "<td>" + dt_str5_totalVal + "</td>";
                            dt_str6 += "<td>" + dt_str6_totalVal + "</td>";
                            dt_str7 += "<td>" + dt_str7_totalVal + "</td>";
                            dt_str8 += "<td>" + dt_str8_totalVal + "</td>";
                            dt_str9 += "<td>" + dt_str9_totalVal + "</td>";
                            dt_str10 += "<td>" + ((reProfitRatio_cnt == 0) ? 0 : Math.round(dt_str10_totalVal / reProfitRatio_cnt)) + "</td>";
                            drRevenue_head_pc[dt_row_cnt - 1] = dt_str_head;
                            drRevenue_data_pc[dt_row_cnt - 1] = dt_str;
                            drRevenue_data_pc2[dt_row_cnt - 1] = dt_str2;
                            drRevenue_data_pc3[dt_row_cnt - 1] = dt_str3;
                            drRevenue_data_pc4[dt_row_cnt - 1] = dt_str4;
                            drRevenue_data_pc5[dt_row_cnt - 1] = dt_str5;
                            drRevenue_data_pc6[dt_row_cnt - 1] = dt_str6;
                            drRevenue_data_pc7[dt_row_cnt - 1] = dt_str7;
                            drRevenue_data_pc8[dt_row_cnt - 1] = dt_str8;
                            drRevenue_data_pc9[dt_row_cnt - 1] = dt_str9;
                            drRevenue_data_pc10[dt_row_cnt - 1] = dt_str10;
                            dt_row_cnt++;
                            dt_col_cnt = 1;
                            dt_str_head = "";
                            dt_str = "";
                            dt_str2 = "";
                            dt_str3 = "";
                            dt_str4 = "";
                            dt_str5 = "";
                            dt_str6 = "";
                            dt_str7 = "";
                            dt_str8 = "";
                            dt_str9 = "";
                            dt_str10 = "";
                            dt_str_totalVal = 0;
                            dt_str2_totalVal = 0;
                            dt_str3_totalVal = 0;
                            dt_str4_totalVal = 0;
                            dt_str5_totalVal = 0;
                            dt_str6_totalVal = 0;
                            dt_str7_totalVal = 0;
                            dt_str8_totalVal = 0;
                            dt_str9_totalVal = 0;
                            dt_str10_totalVal = 0;
                            reProfitRatio_cnt = 0;
                        } else {
                            if ((i + 1) == sheetList.length) { // 조회한 목록이 라인을 다 못채울 때
                                //					var headerDate1 = convertDataTableHeaderDate(tm, 1);
                                var final_dt_str_head = dt_str_head;
                                for (a = 0; a < (12 - dt_col_cnt); a++) {
                                    dt_str_head += "<th></th>";
                                    dt_str += "<td></td>";
                                    dt_str2 += "<td></td>";
                                    dt_str3 += "<td></td>";
                                    dt_str4 += "<td></td>";
                                    dt_str5 += "<td></td>";
                                    dt_str6 += "<td></td>";
                                    dt_str7 += "<td></td>";
                                    dt_str8 += "<td></td>";
                                    dt_str9 += "<td></td>";
                                    dt_str10 += "<td></td>";
                                }
                                dt_str += "<td>" + dt_str_totalVal + "</td>";
                                dt_str2 += "<td>" + dt_str2_totalVal + "</td>";
                                dt_str3 += "<td>" + dt_str3_totalVal + "</td>";
                                dt_str4 += "<td>" + dt_str4_totalVal + "</td>";
                                dt_str5 += "<td>" + dt_str5_totalVal + "</td>";
                                dt_str6 += "<td>" + dt_str6_totalVal + "</td>";
                                dt_str7 += "<td>" + dt_str7_totalVal + "</td>";
                                dt_str8 += "<td>" + dt_str8_totalVal + "</td>";
                                dt_str9 += "<td>" + dt_str9_totalVal + "</td>";
                                dt_str10 += "<td>" + ((reProfitRatio_cnt == 0) ? 0 : Math.round(dt_str10_totalVal / reProfitRatio_cnt)) + "</td>";
                                drRevenue_head_pc[dt_row_cnt - 1] = dt_str_head;
                                drRevenue_data_pc[dt_row_cnt - 1] = dt_str;
                                drRevenue_data_pc2[dt_row_cnt - 1] = dt_str2;
                                drRevenue_data_pc3[dt_row_cnt - 1] = dt_str3;
                                drRevenue_data_pc4[dt_row_cnt - 1] = dt_str4;
                                drRevenue_data_pc5[dt_row_cnt - 1] = dt_str5;
                                drRevenue_data_pc6[dt_row_cnt - 1] = dt_str6;
                                drRevenue_data_pc7[dt_row_cnt - 1] = dt_str7;
                                drRevenue_data_pc8[dt_row_cnt - 1] = dt_str8;
                                drRevenue_data_pc9[dt_row_cnt - 1] = dt_str9;
                                drRevenue_data_pc10[dt_row_cnt - 1] = dt_str10;
                                dt_row_cnt++;
                                dt_col_cnt = 1;
                                dt_str_head = "";
                                dt_str = "";
                                dt_str2 = "";
                                dt_str3 = "";
                                dt_str4 = "";
                                dt_str5 = "";
                                dt_str6 = "";
                                dt_str7 = "";
                                dt_str8 = "";
                                dt_str9 = "";
                                dt_str10 = "";
                                dt_str_totalVal = 0;
                                dt_str2_totalVal = 0;
                                dt_str3_totalVal = 0;
                                dt_str4_totalVal = 0;
                                dt_str5_totalVal = 0;
                                dt_str6_totalVal = 0;
                                dt_str7_totalVal = 0;
                                dt_str8_totalVal = 0;
                                dt_str9_totalVal = 0;
                                dt_str10_totalVal = 0;
                                reProfitRatio_cnt = 0;
                            } else {
                                dt_col_cnt++;
                            }

                        }

                    }

                }

                // 차트데이터 셋팅
                if (chartList != null && chartList.length > 0) {
                    for (var i = 0; i < chartList.length; i++) {
                        var yyyyMM = chartList[i].std_yearm;
                        var totalRewardAmt = String(chartList[i].total_reward_amt);
                        var csmRewardAmt = String(chartList[i].csm_reward_amt);

                        if (!isEqVal(totalRewardAmt, "null")) totDataSet = totDataSet + Number(chartList[i].total_reward_amt);
                        if (!isEqVal(csmRewardAmt, "null")) totDataSet2 = totDataSet2 + Number(String(chartList[i].csm_reward_amt));

                        // 차트데이터 셋팅
                        dataSet.push([Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6) - 1, 1), chartList[i].total_reward_amt]);
                        dataSet2.push([Date.UTC(yyyyMM.substring(0, 4), yyyyMM.substring(4, 6) - 1, 1), chartList[i].csm_reward_amt]);

                    }
                    drRevenueList1 = dataSet;
                    drRevenueList2 = dataSet2;

                    // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                    unit_format_bill(String(totDataSet), "drRevenueTot1", "won", "dr");
                    unit_format_bill(String(totDataSet2), "drRevenueTot2", "won", "dr");
                }

            }

            // 차트 그리기
            function drawData_chart() {
                var seriesLength = myChart.series.length;
                for (var i = seriesLength - 1; i > -1; i--) {
                    myChart.series[i].remove();
                }

                myChart.addSeries({
                    name: '총 정산금액',
                    color: '#438fd7', /* 총 정산금액 */
                    data: drRevenueList1
                }, false);

                myChart.addSeries({
                    name: '고객 할인금액',
                    color: '#84848f', /* 고객 할인금액 */
                    data: drRevenueList2
                }, false);

                //	setTickInterval();
                myChart.xAxis[0].options.tickInterval = 30 * 24 * 3600 * 1000;

                myChart.redraw(); // 차트 데이터를 다시 그린다
            }

            // 표(테이블) 그리기
            function drawData_table() {
                var $chart = $(".income_dr_chart");
                var tbodyStr = '';
                if (drRevenue_data_pc.length > 0) {
                    $chart.find(".inchart-nodata").css("display", "none");
                    $chart.find(".inchart").css("display", "");
                    for (var i = 0; i < dt_row; i++) {
                        tbodyStr += '<div class="chart_table">';
                        tbodyStr += '<table class="pc_use">';
                        tbodyStr += '<thead>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th></th>' + drRevenue_head_pc[i] + '<th>합계/평균(%)</th>';
                        tbodyStr += '</tr>';
                        tbodyStr += '</thead>';
                        tbodyStr += '<tbody>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>감축 횟수-시간 (회-hr)</span></div></th>' + drRevenue_data_pc[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>감축이행용량 (kWh)</span></div></th>' + drRevenue_data_pc2[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>감축인정용량 (kWh)</span></div></th>' + drRevenue_data_pc3[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>감축이행율 (%)</span></div></th>' + drRevenue_data_pc4[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>용량정산금 (won)</span></div></th>' + drRevenue_data_pc5[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>감축정산금 (won)</span></div></th>' + drRevenue_data_pc6[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit ct1"><span>총 정산금액 (won)</span></div></th>' + drRevenue_data_pc7[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit"><span>고객 할인금액 (won)</span></div></th>' + drRevenue_data_pc8[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>EWP 정산금액 (won)</span></div></th>' + drRevenue_data_pc9[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit wht"><span>수익비율 (%)</span></div></th>' + drRevenue_data_pc10[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '</tbody>';
                        tbodyStr += '</table>';
                        tbodyStr += '</div>';
                    }

                } else {
                    $chart.find(".inchart-nodata").css("display", "");
                    $chart.find(".inchart").css("display", "none");
                    tbodyStr += '<div class="chart_table">';
                    tbodyStr += '<table class="pc_use">';
                    tbodyStr += '<thead>';
                    tbodyStr += '<tr>' + '<th width="33%"></th>' + '<td width="34%">조회 결과가 없습니다.</td>' + '<th width="33%"></th>' + '</tr>';
                    tbodyStr += '</thead>';
                    tbodyStr += '</table>';
                    tbodyStr += '</div>';
                }

                $("#pc_use_dataDiv").html(tbodyStr);
            }
        </script>
    </head>
    <body>

        <div id="wrapper">
            <jsp:include page="../include/layout/sidebar.jsp">
                <jsp:param value="billRevenue" name="linkGbn"/>
            </jsp:include>
            <div id="page-wrapper">
                <jsp:include page="../include/layout/header.jsp"/>
                <div id="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header">DR 수익 조회</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-2 use_total">
                            <div class="indiv">
                                <h2 class="ntit">DR 수익 합계</h2>
                                <ul class="chart_total">
                                    <li class="ct1">
                                        <div class="ctit ct1"><span>총 정산금액</span></div>
                                        <div class="cval" id="drRevenueTot1"><span>0</span>won</div>
                                    </li>
                                    <li>
                                        <div class="ctit"><span>고객 할인금액</span></div>
                                        <div class="cval" id="drRevenueTot2"><span>0</span>won</div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-10">
                            <div class="indiv income_dr_chart">
                                <jsp:include page="../include/engy_monitoring_search.jsp">
                                    <jsp:param value="billRevenue" name="schGbn"/>
                                </jsp:include>
                                <div class="inchart-nodata" style="display: none;">
                                    <span>조회 결과가 없습니다.</span>
                                </div>
                                <div class="inchart">
                                    <div id="chart2"></div>
                                    <script language="JavaScript">
                                        // 								$(function () {
                                        var myChart = Highcharts.chart('chart2', {
// 										data: {
// 									        table: 'datatable' /* 테이블에서 데이터 불러오기 */
// 									    },

                                            chart: {
                                                marginLeft: 80,
                                                marginRight: 0,
                                                backgroundColor: 'transparent',
                                                type: 'column'
                                            },

                                            navigation: {
                                                buttonOptions: {
                                                    enabled: false /* 메뉴 안보이기 */
                                                }
                                            },

                                            title: {
                                                text: ''
                                            },

                                            subtitle: {
                                                text: ''
                                            },

                                            xAxis: {
                                                type: 'datetime', // 08.20 이우람 추가
                                                dateTimeLabelFormats: { // 08.20 이우람 추가
                                                    millisecond: '%H:%M:%S.%L',
                                                    second: '%H:%M:%S',
                                                    minute: '%H:%M',
                                                    hour: '%H',
                                                    day: '%m.%d ',
                                                    week: '%m.%e',
                                                    month: '%y/%m',
                                                    year: '%Y'
                                                },
                                                labels: {
                                                    align: 'center',
                                                    style: {
                                                        color: '#3d4250',
                                                        fontSize: '18px'
                                                    }
                                                },
                                                tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                                                title: {
                                                    text: null
                                                }
                                            },

                                            yAxis: {
                                                gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                                                title: {
                                                    text: 'won',
                                                    align: 'low',
                                                    rotation: 0, /* 타이틀 기울기 */
                                                    y: 25, /* 타이틀 위치 조정 */
                                                    x: 5, /* 타이틀 위치 조정 */
                                                    style: {
                                                        color: '#3d4250',
                                                        fontSize: '18px'
                                                    }
                                                },
                                                labels: {
                                                    overflow: 'justify',
                                                    x: -20, /* 그래프와의 거리 조정 */
                                                    style: {
                                                        color: '#3d4250',
                                                        fontSize: '14px'
                                                    }
                                                }
                                            },

                                            /* 범례 */
                                            legend: {
                                                enabled: true,
                                                align: 'right',
                                                verticalAlign: 'top',
                                                itemStyle: {
                                                    color: '#3d4250',
                                                    fontSize: '16px',
                                                    fontWeight: 400
                                                },
                                                itemHoverStyle: {
                                                    color: '' /* 마우스 오버시 색 */
                                                },
                                                symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
                                                symbolHeight: 8 /* 심볼 크기 */
                                            },

                                            /* 툴팁 */
                                            tooltip: {
                                                formatter: function () {
                                                    return '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m ', new Date(this.x)) +
                                                        '월<br/><span style="color:#438fd7">' + this.y + ' won</span>';
                                                }
                                            },

                                            /* 옵션 */
                                            plotOptions: {
                                                series: {
                                                    label: {
                                                        connectorAllowed: false
                                                    },
                                                    borderWidth: 0 /* 보더 0 */
                                                },
                                                line: {
                                                    marker: {
                                                        enabled: false /* 마커 안보이기 */
                                                    }
                                                },
                                                column: {
                                                    stacking: '' /*위로 쌓이는 막대  ,normal */
                                                }
                                            },

                                            /* 출처 */
                                            credits: {
                                                enabled: false
                                            },

                                            /* 그래프 스타일 */
                                            series: [{
                                                name: '총 정산금액',
                                                color: '#438fd7' /* 총 정산금액 */
                                            }, {
                                                name: '고객 할인금액',
                                                color: '#84848f' /* 고객 할인금액 */
                                            }],

                                            /* 반응형 */
                                            responsive: {
                                                rules: [{
                                                    condition: {
                                                        maxWidth: 414 /* 차트 사이즈 */
                                                    },
                                                    chartOptions: {
                                                        chart: {
                                                            marginLeft: 80,
                                                            marginTop: 30
                                                        },
                                                        xAxis: {
                                                            labels: {
                                                                style: {
                                                                    fontSize: '13px'
                                                                }
                                                            }
                                                        },
                                                        yAxis: {
                                                            title: {
                                                                style: {
                                                                    fontSize: '13px'
                                                                }
                                                            },
                                                            labels: {
                                                                x: -10, /* 그래프와의 거리 조정 */
                                                                style: {
                                                                    fontSize: '13px'
                                                                }
                                                            }
                                                        },
                                                        legend: {
                                                            layout: 'horizontal',
                                                            verticalAlign: 'bottom',
                                                            align: 'center',
                                                            x: 0,
                                                            itemStyle: {
                                                                fontSize: '13px'
                                                            }
                                                        }
                                                    }
                                                }]
                                            }

                                        });
                                        // 								});
                                    </script>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row income_dr_table">
                        <div class="col-lg-12">
                            <div class="indiv">
                                <div class="tbl_top clear">
                                    <h2 class="ntit fl">DR 수익 도표</h2>
                                    <ul class="fr">
                                        <li><a href="#;" class="save_btn" onclick="excelDownload('DR수익조회', event);">데이터저장</a>
                                        </li>
                                        <li><a href="#" class="default_btn" id="drRevenueTex">명세서 확인하기</a></li>
                                        <li><a href="#;" class="fold_btn">표접기</a></li>
                                    </ul>
                                </div>
                                <div class="tbl_wrap">
                                    <div class="fold_div" id="pc_use_dataDiv">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="../include/layout/footer.jsp"/>
            </div>
        </div>


        <!-- ###### 명세서 확인 및 출력 Popup Start ###### -->
        <script type="text/javascript">
            $(function () {
                $(".default_btn").on('click', function () {
                    $(".lbutton").show();
                });

                $(".lbtn_pdf").on('click', function () {
                    $(".lbutton").hide();
                    setTimeout(function () {
                        $(".lbutton").show();
                    }, 1000);
                });

                $('.lbtn_print').on('click', function () {
                    $('#layerbox').css("left", "0px");
                    $('#layerbox').css("top", "-300px");
                    $(".lbutton").hide();
                    $('#layerbox').printThis({});
                    setTimeout(function () {
                        $(".lbutton").show();
                    }, 1000);
                });
            });
        </script>
        <div id="layerbox" class="dprint clear drRevenueStatement" style="margin-top:250px;width:880px;">
            <div class="lbutton fl">
                <a href="javascript:getPdfDownload();" class="lbtn_pdf"><span>PDF로 저장</span></a>
                <a href="#" id="drRevenueBtnPrint" class="lbtn_print"><span>인쇄</span></a>
            </div>
            <div class="ltit fr">
                <a href="javascript:popupClose('dprint');">닫기</a>
            </div>
            <div class="lbody mt30" id="printArea">

                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2"
                            style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;"
                            id="texBill">
                            DR (수요반응) 수익 배분 청구서 (’18년 5월)
                        </td>
                    </tr>
                    <tr>
                        <td height="30" align="left" style="font-size:12px;">고객명 : ${selViewSite.site_name }</td>
                        <td height="30" align="right" style="font-size:12px;" id="texDay">청구일 : 2018-07-20</td>
                    </tr>
                    <tr>
                        <td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
                            이번 달 청구 금액은 <span class="dp_total">220,000</span>원 입니다
                            <p style="padding-top:10px;font-size:12px;font-weight:normal;">
                                <!-- (수익배분기간 : 2018-01-01 ~ 2018-12-31) --></p>
                        </td>
                    </tr>
                </table>

                <div class="clear" style="margin-top:20px;">
                    <div class="fl" style="width:49%;">
                        <h2>1. 청구내역</h2>
                        <table class="tbl texArea" style="margin-top:10px;">
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
                            <tbody>
                                <tr>
                                    <th>용량 정산금</th>
                                    <td align="right">900,000</td>
                                </tr>
                                <tr>
                                    <th>감축 정산금</th>
                                    <td align="right">100,000</td>
                                </tr>
                                <tr>
                                    <th>총 정산금액</th>
                                    <td align="right">1,000,000</td>
                                </tr>
                                <!-- <tr>
                                    <th>고객 정산 금액</th>
                                    <td align="right">800,000</td>
                                </tr> -->
                                <tr>
                                    <th>①수익배분 계</th>
                                    <td align="right">200,000</td>
                                </tr>
                                <tr>
                                    <th>부가가치세</th>
                                    <td align="right">20,006</td>
                                </tr>
                                <tr>
                                    <th>원단위절사</th>
                                    <td align="right">-6</td>
                                </tr>
                                <tr>
                                    <th>&nbsp;</th>
                                    <td>&nbsp;</td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th>청구금액</th>
                                    <td align="right">220,000</td>
                                </tr>
                            </tfoot>
                        </table>

                        <h2 style="margin-top:20px">3. 수익분배 계산 내역</h2>
                        <table class="tbl beneArea" style="margin-top:10px;">
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>계산 내역</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>①수익배분 계</th>
                                    <td>총 정산금액 x 수익배분(0.2)</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="fr" style="width:49%;">
                        <h2>2. 감축 정보</h2>
                        <table class="tbl saveArea" style="margin-top:10px;">
                            <colgroup>
                                <col width="50%">
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>내용</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>감축횟수-시간 (회-시간)</th>
                                    <td>1-2</td>
                                </tr>
                                <tr>
                                    <th>감축 이행 용량 (kWh)</th>
                                    <td>200</td>
                                </tr>
                                <tr>
                                    <th>감축 인정 용량 (kWh)</th>
                                    <td>16</td>
                                </tr>
                                <tr>
                                    <th>감축 이행율 (%)</th>
                                    <td>80</td>
                                </tr>
                                <tr>
                                    <th>수익 배분 (%)</th>
                                    <td>20</td>
                                </tr>
                            </tbody>
                        </table>

                        <h2 style="margin-top:20px;">4. 납입처</h2>
                        <table class="tbl infoArea" style="margin-top:10px;">
                            <tbody>
                                <tr>
                                    <th>은행명</th>
                                    <td>우리은행</td>
                                </tr>
                                <tr>
                                    <th>계좌번호</th>
                                    <td>1005 – 802 - 498030</td>
                                </tr>
                                <tr>
                                    <th>예금주</th>
                                    <td>한국동서발전㈜</td>
                                </tr>
                                <tr>
                                    <th>납입금액</th>
                                    <td>30,439,360</td>
                                </tr>
                                <tr>
                                    <th>납기일</th>
                                    <td>2018-06-24</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>


                <h2 style="margin-top:20px">5. 최근 6개월 수익 내역</h2>
                <div class="inchart">
                    <div id="ly_chart_dr" style="max-width:800px;height:250px;"></div>
                    <script language="JavaScript">
                        // 			$(function () {
                        var myChart1 = Highcharts.chart('ly_chart_dr', {
                            // 					data: {
                            // 				        table: 'ly_datatable_dr' /* 테이블에서 데이터 불러오기 */
                            // 				    },

                            chart: {
                                marginLeft: 80,
                                marginRight: 0,
                                backgroundColor: 'transparent',
                                type: 'column'
                            },

                            navigation: {
                                buttonOptions: {
                                    enabled: false /* 메뉴 안보이기 */
                                }
                            },

                            title: {
                                text: ''
                            },

                            subtitle: {
                                text: ''
                            },

                            xAxis: {
                                type: 'datetime', // 08.20 이우람 추가
                                dateTimeLabelFormats: { // 08.20 이우람 추가
                                    millisecond: '%H:%M:%S.%L',
                                    second: '%H:%M:%S',
                                    minute: '%H:%M',
                                    hour: '%H',
                                    day: '%m.%d ',
                                    week: '%m.%e',
                                    month: '%y/%m',
                                    year: '%Y'
                                },
                                labels: {
                                    align: 'center',
                                    style: {
                                        color: '#3d4250',
                                        fontSize: '13px'
                                    }
                                },
                                tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                                title: {
                                    text: null
                                }
                            },

                            yAxis: {
                                gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                                title: {
                                    text: 'won',
                                    align: 'low',
                                    rotation: 0, /* 타이틀 기울기 */
                                    y: 25, /* 타이틀 위치 조정 */
                                    x: 25, /* 타이틀 위치 조정 */
                                    style: {
                                        color: '#3d4250',
                                        fontSize: '13px'
                                    }
                                },
                                labels: {
                                    overflow: 'justify',
                                    x: -20, /* 그래프와의 거리 조정 */
                                    style: {
                                        color: '#3d4250',
                                        fontSize: '13px'
                                    }
                                }
                            },

                            /* 범례 */
                            legend: {
                                enabled: true,
                                align: 'right',
                                verticalAlign: 'top',
                                itemStyle: {
                                    color: '#3d4250',
                                    fontSize: '13px',
                                    fontWeight: 400
                                },
                                itemHoverStyle: {
                                    color: '' /* 마우스 오버시 색 */
                                },
                                symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
                                symbolHeight: 8 /* 심볼 크기 */
                            },

                            /* 툴팁 */
                            tooltip: {
                                formatter: function () {
                                    return '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m ', new Date(this.x))
                                        + '월<br/><span style="color:#438fd7">' + this.y + ' won</span>';
                                }
                            },

                            /* 옵션 */
                            plotOptions: {
                                series: {
                                    label: {
                                        connectorAllowed: false
                                    },
                                    borderWidth: 0 /* 보더 0 */
                                },
                                line: {
                                    marker: {
                                        enabled: false /* 마커 안보이기 */
                                    }
                                },
                                column: {
                                    stacking: '' /*위로 쌓이는 막대  ,normal */
                                }
                            },

                            /* 출처 */
                            credits: {
                                enabled: false
                            },

                            /* 그래프 스타일 */
                            series: [{
                                color: '#438fd7' /* 총 정산금액 */
                            }, {
                                color: '#84848f' /* 고객 할인금액 */
                            }],

                            /* 반응형 */
                            responsive: {
                                rules: [{
                                    condition: {
                                        maxWidth: 414 /* 차트 사이즈 */
                                    },
                                    chartOptions: {
                                        chart: {
                                            marginLeft: 80,
                                            marginTop: 30
                                        },
                                        xAxis: {
                                            labels: {
                                                style: {
                                                    fontSize: '13px'
                                                }
                                            }
                                        },
                                        yAxis: {
                                            title: {
                                                style: {
                                                    fontSize: '13px'
                                                }
                                            },
                                            labels: {
                                                x: -10, /* 그래프와의 거리 조정 */
                                                style: {
                                                    fontSize: '13px'
                                                }
                                            }
                                        },
                                        legend: {
                                            layout: 'horizontal',
                                            verticalAlign: 'bottom',
                                            align: 'center',
                                            x: 0,
                                            itemStyle: {
                                                fontSize: '13px'
                                            }
                                        }
                                    }
                                }]
                            }

                        });
                        // 			});
                    </script>
                </div>
                <!-- 데이터 추출용 -->
                <div class="lychart_table" style="display:none;">
                    <table id="ly_datatable_dr">
                        <thead>
                            <tr>
                                <th>2018-08</th>
                                <th>총 정산금액</th>
                                <th>고객 할인금액</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>1월</th>
                                <td>1000000</td>
                                <td>800000</td>
                            </tr>
                            <tr>
                                <th>2월</th>
                                <td>1000000</td>
                                <td>800000</td>
                            </tr>
                            <tr>
                                <th>3월</th>
                                <td>1000000</td>
                                <td>800000</td>
                            </tr>
                            <tr>
                                <th>4월</th>
                                <td>1000000</td>
                                <td>800000</td>
                            </tr>
                            <tr>
                                <th>5월</th>
                                <td>1000000</td>
                                <td>800000</td>
                            </tr>
                            <tr>
                                <th>6월</th>
                                <td></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- ###### Popup End ###### -->


    </body>
</html>