this.onmessage = function(e){
    init(e.data.config);
  switch(e.data.command){
    case 'derUsageList':
        derUsageListUI(e.data.data);
        postMessage({
            command: 'derUsageList',
            usage_head_pc: usage_head_pc,
            real_data_pc: real_data_pc,
            ess_data_pc: ess_data_pc,
            pv_data_pc: pv_data_pc,
            total_data_pc: total_data_pc,
            pastUsageList: pastUsageList,
            essUsageList: essUsageList,
            pvUsageList: pvUsageList,
            kepcoTotalUsage: kepcoTotalUsage,
            essTotalUsage: essTotalUsage,
            pvTotalUsage: pvTotalUsage
        });
      break;
  }
};


var periodd;
var schStartTime;
var schEndTime;
var SelTerm;
var dt_col;
var timeOffset;
function init(config){
    periodd = config.periodd;
    schStartTime = config.schStartTime;
    schEndTime = config.schEndTime;
    SelTerm = config.SelTerm;
    dt_col = config.dt_col;
    timeOffset = config.timeOffset;
}

var usage_head_pc = []; // 표 영역 헤더
var real_data_pc = []; // 한전 사용량 표 데이터
var ess_data_pc = []; //  ess 사용량 표 데이터
var pv_data_pc = []; //  pv 사용량 표 데이터
var total_data_pc = []; //  사용량 합계 표 데이터

var pastUsageList; // 한전 사용량
var essUsageList; // ess 사용량
var pvUsageList; // pv 사용량
var kepcoUsage = null;
var essUsage = null;
var pvUsage = null;
var reKepcoUsage = null;
var reEssUsage = null;
var rePvUsage = null;
var kepcoTotalUsage = 0; // 전체 누적합
var essTotalUsage = 0;
var pvTotalUsage = 0;
function derUsageListUI(result) {
    var kepcoUsageSheetList = result.kepcoUsageSheetList;
    var kepcoUsageChartList = result.kepcoUsageChartList;
    var essUsageListSheetList = result.essUsageListSheetList;
    var essUsageListChartList = result.essUsageListChartList;
    var pvUsageListSheetList = result.pvUsageListSheetList;
    var pvUsageListChartList = result.pvUsageListChartList;
    var loopCntSheetList = result.loopCntSheetList; // for문 loop list
    var loopCntChartList = result.loopCntChartList; // for문 loop list

    // 데이터 셋팅
    var dataSet = []; // chartData를 위한 변수
    var dataSet2 = []; // chartData를 위한 변수
    var dataSet3 = []; // chartData를 위한 변수
    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
    var dt_str_head = "";
    var dt_str = "";
    var dt_str2 = "";
    var dt_str3 = "";
    var dt_str4 = ""; // 사용량 합계
    var dt_str_totalVal = 0; // 테이블 라인별 누적합
    var dt_str2_totalVal = 0; // 테이블 라인별 누적합
    var dt_str3_totalVal = 0; // 테이블 라인별 누적합
    var dt_str4_totalVal = 0; // 테이블 라인별 누적합
    var final_dt_str_head = "";
    var map = null;

    // 한전사용량, ess사용량, pv사용량 중 하나라도 데이터가 존재할 때
    // 표데이터 셋팅
    var start = new Date(schStartTime.getTime());
    var end = new Date(schEndTime.getTime());
    if (!(kepcoUsageSheetList == null && essUsageListSheetList == null && pvUsageListSheetList == null)) {
        var s = start;
        var e = end;
        setHms(s, e);
        if (periodd === 'month') {
            s.setDate(1);
            s.setHours(0);
            s.setMinutes(0);
            s.setSeconds(0);
        }
        for (var i = 0; i < loopCntSheetList.length; i++) {
            dt_str_head += "<th>" + convertDataTableHeaderDate(s, 2) + "</th>";

            kepcoUsage = null;
            essUsage = null;
            pvUsage = null;
            var totalUsage = null;
            reKepcoUsage = null;
            reEssUsage = null;
            rePvUsage = null;
            var reTotalUsage = null;
            if (kepcoUsageSheetList != null && kepcoUsageSheetList.length > 0 && kepcoUsageSheetList.length > i) { // 한전사용량
                kepcoUsage = String(kepcoUsageSheetList[i].usg_val);
                if ( isEmpty(kepcoUsage) || kepcoUsage === "null") reKepcoUsage = null;
                else {
                    map = convertUnitFormat(kepcoUsage, "Wh", 5);
                    reKepcoUsage = toFixedNum(map.get("formatNum"), 2);
                    dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
                    totalUsage = totalUsage + Number(kepcoUsage);
                }

            } else reKepcoUsage = null;

            if (essUsageListSheetList != null && essUsageListSheetList.length > 0 && essUsageListSheetList.length > i) { // ESS 사용량
                essUsage = String(essUsageListSheetList[i].usg_val);
                if ( isEmpty(essUsage) || essUsage === "null") reEssUsage = null;
                else {
                    map = convertUnitFormat(essUsage, "Wh", 5);
                    reEssUsage = toFixedNum(map.get("formatNum"), 2);
                    dt_str2_totalVal = dt_str2_totalVal + Number(map.get("formatNum"));
                    totalUsage = totalUsage + Number(essUsage);
                }
            } else reEssUsage = null;

            if (pvUsageListSheetList != null && pvUsageListSheetList.length > 0 && pvUsageListSheetList.length > i) { // PV 사용량
                pvUsage = String(pvUsageListSheetList[i].gen_val);
                if ( isEmpty(pvUsage) || pvUsage === "null") rePvUsage = null;
                else {
                    map = convertUnitFormat(pvUsage, "Wh", 5);
                    rePvUsage = toFixedNum(map.get("formatNum"), 2);
                    dt_str3_totalVal = dt_str3_totalVal + Number(map.get("formatNum"));
                    totalUsage = totalUsage + Number(pvUsage);
                }
            } else rePvUsage = null;

            if ( isEmpty(totalUsage) || totalUsage === "null") reTotalUsage = null;
            else {
                var totalMap = convertUnitFormat(totalUsage, "Wh", 5);
                reTotalUsage = toFixedNum(totalMap.get("formatNum"), 2);
                dt_str4_totalVal = dt_str4_totalVal + Number(totalMap.get("formatNum"));
            }

            dt_str += "<td>" + (( isEmpty(reKepcoUsage)) ? "" : reKepcoUsage) + "</td>"; // 한전 사용량
            dt_str2 += "<td>" + (( isEmpty(reEssUsage)) ? "" : reEssUsage) + "</td>"; // ess 사용량
            dt_str3 += "<td>" + (( isEmpty(rePvUsage)) ? "" : rePvUsage) + "</td>"; // pv 사용량
            dt_str4 += "<td>" + (( isEmpty(reTotalUsage)) ? "" : reTotalUsage) + "</td>"; // 사용량 합계

            if (dt_col_cnt === dt_col) {
                final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>";
                dt_str2 += "<td>" + toFixedNum(dt_str2_totalVal, 2) + "</td>";
                dt_str3 += "<td>" + toFixedNum(dt_str3_totalVal, 2) + "</td>";
                dt_str4 += "<td>" + toFixedNum(dt_str4_totalVal, 2) + "</td>";
                usage_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                real_data_pc[dt_row_cnt - 1] = dt_str;
                ess_data_pc[dt_row_cnt - 1] = dt_str2;
                pv_data_pc[dt_row_cnt - 1] = dt_str3;
                total_data_pc[dt_row_cnt - 1] = dt_str4;
                dt_str_head = "";
                dt_str = "";
                dt_str2 = "";
                dt_str3 = "";
                dt_str4 = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
                dt_str2_totalVal = 0;
                dt_str3_totalVal = 0;
                dt_str4_totalVal = 0;
                final_dt_str_head = "";
            } else {
                if ((i + 1) === loopCntSheetList.length) { // 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str += "<td></td>";
                        dt_str2 += "<td></td>";
                        dt_str3 += "<td></td>";
                        dt_str4 += "<td></td>";
                    }
                    final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                    dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>";
                    dt_str2 += "<td>" + toFixedNum(dt_str2_totalVal, 2) + "</td>";
                    dt_str3 += "<td>" + toFixedNum(dt_str3_totalVal, 2) + "</td>";
                    dt_str4 += "<td>" + toFixedNum(dt_str4_totalVal, 2) + "</td>";
                    usage_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                    real_data_pc[dt_row_cnt - 1] = dt_str;
                    ess_data_pc[dt_row_cnt - 1] = dt_str2;
                    pv_data_pc[dt_row_cnt - 1] = dt_str3;
                    total_data_pc[dt_row_cnt - 1] = dt_str4;
                    dt_str_head = "";
                    dt_str = "";
                    dt_str2 = "";
                    dt_str3 = "";
                    dt_str4 = "";
                    dt_str_totalVal = 0;
                    dt_str2_totalVal = 0;
                    dt_str3_totalVal = 0;
                    dt_str4_totalVal = 0;
                    final_dt_str_head = "";
                } else {
                    dt_col_cnt++;
                }
            }
            s = incrementTime(s);
        }
    }

    // 한전사용량, ess사용량, pv사용량 중 하나라도 데이터가 존재할 때
    // 차트데이터 셋팅
    if (!(kepcoUsageChartList == null && essUsageListChartList == null && pvUsageListChartList == null)) {
        for (var i = 0; i < loopCntChartList.length; i++) {
            kepcoUsage = null;
            essUsage = null;
            pvUsage = null;
            reKepcoUsage = 0;
            reEssUsage = 0;
            rePvUsage = 0;

            if (kepcoUsageChartList != null && kepcoUsageChartList.length > 0 && kepcoUsageChartList.length > i) { // 한전사용량
                kepcoUsage = String(kepcoUsageChartList[i].usg_val);
                if ( isEmpty(kepcoUsage) || kepcoUsage === "null") reKepcoUsage = null;
                else {
                    map = convertUnitFormat(kepcoUsage, "Wh", 5);
                    reKepcoUsage = toFixedNum(map.get("formatNum"), 2);
                    kepcoTotalUsage = kepcoTotalUsage + Number(kepcoUsage);
                }

            } else reKepcoUsage = null;

            if (essUsageListChartList != null && essUsageListChartList.length > 0 && essUsageListChartList.length > i) { // ESS 사용량
                essUsage = String(essUsageListChartList[i].usg_val);
                if ( isEmpty(essUsage)  || essUsage === "null") reEssUsage = null;
                else {
                    map = convertUnitFormat(essUsage, "Wh", 5);
                    reEssUsage = toFixedNum(map.get("formatNum"), 2);
                    essTotalUsage = essTotalUsage + Number(essUsage);
                }
            } else reEssUsage = null;

            if (pvUsageListChartList != null && pvUsageListChartList.length > 0 && pvUsageListChartList.length > i) { // PV 사용량
                pvUsage = String(pvUsageListChartList[i].gen_val);
                if ( isEmpty(pvUsage) || pvUsage === "null") rePvUsage = null;
                else {
                    map = convertUnitFormat(pvUsage, "Wh", 5);
                    rePvUsage = toFixedNum(map.get("formatNum"), 2);
                    pvTotalUsage = pvTotalUsage + Number(pvUsage);
                }
            } else rePvUsage = null;

            var chartEssUsage = null;
            var chartPvUsage = null;
            if (reKepcoUsage != null) {
                chartEssUsage = toFixedNum(reEssUsage, 2);
                chartPvUsage = toFixedNum(rePvUsage, 2);
            }
            // 차트데이터 셋팅
            dataSet.push([setChartDateUTC(loopCntChartList[i].std_timestamp), reKepcoUsage]);
            dataSet2.push([setChartDateUTC(loopCntChartList[i].std_timestamp), chartEssUsage]);
            dataSet3.push([setChartDateUTC(loopCntChartList[i].std_timestamp), chartPvUsage]);
        }
        pastUsageList = dataSet;
        essUsageList = dataSet2;
        pvUsageList = dataSet3;
    }

}



importScripts('/js/worker/subWorker.js')