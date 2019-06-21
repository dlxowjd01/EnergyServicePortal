this.onmessage = function(e){
    init(e.data.config);
  switch(e.data.command){
    case 'pastEssChargeList':
        pastEssChargeListUI(e.data.data);
        postMessage({
            command: 'pastEssChargeList',
            ess_head_pc: ess_head_pc,
            realChg_data_pc: realChg_data_pc,
            realDischg_data_pc: realDischg_data_pc,
            pastChgList: pastChgList,
            pastDischgList: pastDischgList,
            pastEssChgTotalVal: pastEssChgTotalVal,
            pastEssDischgTotalVal: pastEssDischgTotalVal
        });
      break;
   case 'predictEssChargeList':
       predictEssChargeListUI(e.data.data);
       postMessage({
           command: 'predictEssChargeList',
           fetureChg_data_pc: fetureChg_data_pc,
           fetureDischg_data_pc: fetureDischg_data_pc,
           defaultData_pc: defaultData_pc,
           fetureChgList: fetureChgList,
           fetureDischgList: fetureDischgList,
           fetureEssChgTotalVal: fetureEssChgTotalVal,
           fetureEssDischgTotalVal: fetureEssDischgTotalVal
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

var ess_head_pc = []; // 실제 사용량 표 데이터
var realChg_data_pc = []; // 실제 충전량 표 데이터
var realDischg_data_pc = []; // 실제 방전량 표 데이터
var fetureChg_data_pc = []; //  예측 충전량 표 데이터
var fetureDischg_data_pc = []; //  예측 방전량 표 데이터
var defaultData_pc = "";

// 실제 충방전량 조회
var pastChgList;
var pastDischgList;
var chgVal = null;
var dischgVal = null;
var reChgVal = null;
var reDischgVal = null;
var pastEssChgTotalVal = 0; // 전체 누적합
var pastEssDischgTotalVal = 0; // 전체 누적합
function pastEssChargeListUI(result) {
    var resultListMap = result.resultListMap;
    var chgSheetList = result.chgSheetList;
    var chgChartList = result.chgChartList;
    var dischgSheetList = result.dischgSheetList;
    var dischgChartList = result.dischgChartList;

    // 데이터 셋팅
    var dataSet = []; // chartData를 위한 변수
    var dataSet2 = []; // chartData를 위한 변수
    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
    var dt_str_head = "";
    var dt_str = "";
    var dt_str2 = "";
    var dt_str_totalVal = 0; // 테이블 라인별 누적합
    var dt_str2_totalVal = 0; // 테이블 라인별 누적합
    var final_dt_str_head = "";
    var map = null;
    pastEssChgTotalVal = 0; // 전체 누적합
    pastEssDischgTotalVal = 0; // 전체 누적합

    // 표데이터 셋팅
    var start = new Date(schStartTime.getTime());
    var end = new Date(schEndTime.getTime());
    if (chgSheetList != null && chgSheetList.length > 0) {
        var s = start;
        var e = end;
        setHms(s, e);
        if (periodd === 'month') {
            s.setDate(1);
            s.setHours(0);
            s.setMinutes(0);
            s.setSeconds(0);
        }
        for (var i = 0; i < chgSheetList.length; i++) {
            dt_str_head += "<th>" + convertDataTableHeaderDate(s, 2) + "</th>";

            reChgVal = null;
            reDischgVal = null;
            chgVal = String(chgSheetList[i].chg_val);
            dischgVal = String(dischgSheetList[i].dischg_val);

            if ( isEmpty(chgVal) || chgVal === "null") {
                reChgVal = null;
            } else {
                map = convertUnitFormat(chgVal, "Wh", 5);
                reChgVal = toFixedNum(map.get("formatNum"), 2);
                dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
            }

            if ( isEmpty(dischgVal) || dischgVal === "null") {
                reDischgVal = null;
            } else {
                map = convertUnitFormat(dischgVal, "Wh", 5);
                reDischgVal = toFixedNum(map.get("formatNum"), 2);
                dt_str2_totalVal = dt_str2_totalVal + Number(map.get("formatNum"));
            }

            dt_str += "<td>" + (( isEmpty(reChgVal) ) ? "" : reChgVal) + "</td>"; // 충전량
            dt_str2 += "<td>" + (( isEmpty(reDischgVal) ) ? "" : reDischgVal) + "</td>"; // 방전량

            if (dt_col_cnt === dt_col) {
                final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>"; // 충전량
                dt_str2 += "<td>" + toFixedNum(dt_str2_totalVal, 2) + "</td>"; // 방전량
                ess_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                realChg_data_pc[dt_row_cnt - 1] = dt_str;
                realDischg_data_pc[dt_row_cnt - 1] = dt_str2;
                dt_str_head = "";
                dt_str = "";
                dt_str2 = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
                dt_str2_totalVal = 0;
                final_dt_str_head = "";
            } else {
                if ((i + 1) === chgSheetList.length) { // 루프 다 돌고 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str_head += "<th></th>";
                        dt_str += "<td></td>";
                        dt_str2 += "<td></td>";
                    }
                    final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                    dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>"; // 충전량
                    dt_str2 += "<td>" + toFixedNum(dt_str2_totalVal, 2) + "</td>"; // 방전량
                    ess_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                    realChg_data_pc[dt_row_cnt - 1] = dt_str;
                    realDischg_data_pc[dt_row_cnt - 1] = dt_str2;
                    dt_str_head = "";
                    dt_str = "";
                    dt_str2 = "";
                    dt_str_totalVal = 0;
                    dt_str2_totalVal = 0;
                    final_dt_str_head = "";
                } else {
                    dt_col_cnt++;
                }
            }
            s = incrementTime(s);
        }
    }

    // 차트데이터 셋팅
    if (chgChartList != null && chgChartList.length > 0) {
        for (var i = 0; i < chgChartList.length; i++) {
            chgVal = String(chgChartList[i].chg_val);
            dischgVal = String(dischgChartList[i].dischg_val);
            reChgVal = 0;
            reDischgVal = 0;

            if ( isEmpty(chgVal) || chgVal === "null") reChgVal = null;
            else {
                map = convertUnitFormat(chgVal, "Wh", 5);
                reChgVal = toFixedNum(map.get("formatNum"), 2);
                pastEssChgTotalVal = pastEssChgTotalVal + Number(chgVal);
            }
            if ( isEmpty(dischgVal) || dischgVal === "null") reDischgVal = null;
            else {
                map = convertUnitFormat(dischgVal, "Wh", 5);
                reDischgVal = toFixedNum(map.get("formatNum"), 2);
                pastEssDischgTotalVal = pastEssDischgTotalVal + Number(dischgVal);
            }
            // 차트데이터 셋팅
            dataSet.push([setChartDateUTC(chgChartList[i].std_timestamp), reChgVal]);
            dataSet2.push([setChartDateUTC(chgChartList[i].std_timestamp), reDischgVal]);
        }
    }
    pastChgList = dataSet;
    pastDischgList = dataSet2;

}

// 예측 충방전량
var fetureChgList;
var fetureDischgList;
var fetureEssChgTotalVal = 0; // 전체 누적합
var fetureEssDischgTotalVal = 0; // 전체 누적합
function predictEssChargeListUI(result) {
    var resultListMap = result.resultListMap;
    var chgSheetList = result.chgSheetList;
    var chgChartList = result.chgChartList;
    var dischgSheetList = result.dischgSheetList;
    var dischgChartList = result.dischgChartList;

    // 데이터 셋팅
    var dataSet = []; // chartData를 위한 변수
    var dataSet2 = []; // chartData를 위한 변수
    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
    var dt_str = "";
    var dt_str2 = "";
    var dt_str_totalVal = 0; // 테이블 라인별 누적합
    var dt_str2_totalVal = 0; // 테이블 라인별 누적합
    var map = null;
    fetureEssChgTotalVal = 0; // 전체 누적합
    fetureEssDischgTotalVal = 0; // 전체 누적합
    defaultData_pc = "";

    // 표데이터 셋팅
    var start = new Date(schStartTime.getTime());
    var end = new Date(schEndTime.getTime());
    if (chgSheetList != null && chgSheetList.length > 0) {
        var s = start;
        var e = end;
        setHms(s, e);
        if (periodd === 'month') {
            s.setDate(1);
            s.setHours(0);
            s.setMinutes(0);
            s.setSeconds(0);
        }
        for (var i = 0; i < chgSheetList.length; i++) {

            reChgVal = null;
            reDischgVal = null;
            chgVal = String(chgSheetList[i].chg_val);
            dischgVal = String(dischgSheetList[i].dischg_val);

            if ( isEmpty(chgVal) || chgVal === "null") {
                reChgVal = null;
            } else {
                map = convertUnitFormat(chgVal, "Wh", 5);
                reChgVal = toFixedNum(map.get("formatNum"), 2);
                dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
            }

            if ( isEmpty(dischgVal) || dischgVal === "null") {
                reDischgVal = null;
            } else {
                map = convertUnitFormat(dischgVal, "Wh", 5);
                reDischgVal = toFixedNum(map.get("formatNum"), 2);
                dt_str2_totalVal = dt_str2_totalVal + Number(map.get("formatNum"));
            }

            dt_str += "<td>" + (( isEmpty(reChgVal)) ? "" : reChgVal) + "</td>"; // 충전량
            dt_str2 += "<td>" + (( isEmpty(reDischgVal )) ? "" : reDischgVal) + "</td>"; // 방전량

            if (dt_col_cnt === dt_col) {
                dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>"; // 충전량
                dt_str2 += "<td>" + toFixedNum(dt_str2_totalVal, 2) + "</td>"; // 방전량
                fetureChg_data_pc[dt_row_cnt - 1] = dt_str;
                fetureDischg_data_pc[dt_row_cnt - 1] = dt_str2;
                dt_str = "";
                dt_str2 = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
                dt_str2_totalVal = 0;
            } else {
                if ((i + 1) === chgSheetList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str += "<td></td>";
                        dt_str2 += "<td></td>";
                    }
                    dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>"; // 충전량
                    dt_str2 += "<td>" + toFixedNum(dt_str2_totalVal, 2) + "</td>"; // 방전량
                    fetureChg_data_pc[dt_row_cnt - 1] = dt_str;
                    fetureDischg_data_pc[dt_row_cnt - 1] = dt_str2;
                    dt_str = "";
                    dt_str2 = "";
                    dt_str_totalVal = 0;
                    dt_str2_totalVal = 0;
                } else {
                    dt_col_cnt++;
                }
            }
            s = incrementTime(s);
        }
    } else {
        for (var i = 0; i < dt_col; i++) {
            defaultData_pc += "<td></td>";
        }
        defaultData_pc += "<td></td>";
    }

    // 차트데이터 셋팅
    if (chgChartList != null && chgChartList.length > 0) {
        for (var i = 0; i < chgChartList.length; i++) {
            chgVal = String(chgChartList[i].chg_val);
            dischgVal = String(dischgChartList[i].dischg_val);
            reChgVal = 0;
            reDischgVal = 0;
            if ( isEmpty(chgVal) || chgVal === "null") reChgVal = null;
            else {
                map = convertUnitFormat(chgVal, "Wh", 5);
                reChgVal = toFixedNum(map.get("formatNum"), 2);
                fetureEssChgTotalVal = fetureEssChgTotalVal + Number(chgVal);
            }
            if ( isEmpty(dischgVal) || dischgVal === "null") reDischgVal = null;
            else {
                map = convertUnitFormat(dischgVal, "Wh", 5);
                reDischgVal = toFixedNum(map.get("formatNum"), 2);
                fetureEssDischgTotalVal = fetureEssDischgTotalVal + Number(dischgVal);
            }
            // 차트데이터 셋팅
            dataSet.push([setChartDateUTC(chgChartList[i].std_timestamp), reChgVal]);
            dataSet2.push([setChartDateUTC(chgChartList[i].std_timestamp), reDischgVal]);
        }
    }
    fetureChgList = dataSet;
    fetureDischgList = dataSet2;

}



importScripts('/js/worker/subWorker.js')