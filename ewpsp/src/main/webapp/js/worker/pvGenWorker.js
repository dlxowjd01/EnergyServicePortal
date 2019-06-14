this.onmessage = function(e){
    init(e.data.config);
  switch(e.data.command){
    case 'pastPvGenList':
        pastPvGenListUI(e.data.data);
        postMessage({
            command: 'pastPvGenList',
            pv_head_pc: pv_head_pc,
            real_data_pc: real_data_pc,
            pastPVGenList: pastPVGenList,
            pastPvGenTotalVal: pastPvGenTotalVal
        });
      break;
   case 'predictPvGenList':
       predictPvGenListUI(e.data.data);
       postMessage({
           command: 'predictPvGenList',
           feture_data_pc: feture_data_pc,
           feturePVGenList: feturePVGenList,
           feturePvGenTotalVal: feturePvGenTotalVal
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

var pv_head_pc = []; // 실제 사용량 표 데이터
var real_data_pc = []; // 실제 발전량 표 데이터
var feture_data_pc = []; //  예측 발전량 표 데이터

// PV 실제 발전량
var pastPVGenList;
var usage = null;
var reUsage = null;
var pastPvGenTotalVal = 0; // 전체 누적합
function pastPvGenListUI(result) {
    var sheetList = result.sheetList;
    var chartList = result.chartList;

    // 데이터 셋팅
    var dataSet = []; // chartData를 위한 변수
    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
    var dt_str_head = "";
    var dt_str = "";
    var dt_str_totalVal = 0; // 테이블 라인별 누적합
    var final_dt_str_head = "";
    var map = null;

    // 표데이터 셋팅
    var start = new Date(schStartTime.getTime());
    var end = new Date(schEndTime.getTime());
    if (sheetList != null && sheetList.length > 0) {
        var s = start;
        var e = end;
        setHms(s, e);
        if (periodd === 'month') {
            s.setDate(1);
            s.setHours(0);
            s.setMinutes(0);
            s.setSeconds(0);
        }
        for (var i = 0; i < sheetList.length; i++) {
            dt_str_head += "<th>" + convertDataTableHeaderDate(s, 2) + "</th>";

            reUsage = null;
            usage = String(sheetList[i].gen_val);
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
            }

            dt_str += "<td>" + (( isEmpty(reUsage) ) ? "" : reUsage) + "</td>";

            if (dt_col_cnt === dt_col) {
                final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>";
                pv_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                real_data_pc[dt_row_cnt - 1] = dt_str;
                dt_str_head = "";
                dt_str = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
                final_dt_str_head = "";
            } else {
                if ((i + 1) === sheetList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str_head += "<th></th>";
                        dt_str += "<td></td>";
                    }
                    final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                    dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>";
                    pv_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                    real_data_pc[dt_row_cnt - 1] = dt_str;
                    dt_str_head = "";
                    dt_str = "";
                    dt_str_totalVal = 0;
                    final_dt_str_head = "";
                } else {
                    dt_col_cnt++;
                }
            }
            s = incrementTime(s);
        }
    }

    // 차트데이터 셋팅
    if (chartList != null && chartList.length > 0) {
        for (var i = 0; i < chartList.length; i++) {
            usage = String(chartList[i].gen_val);
            reUsage = 0;
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                pastPvGenTotalVal = pastPvGenTotalVal + Number(usage);
            }
            // 차트데이터 셋팅
            dataSet.push([setChartDateUTC(chartList[i].std_date), reUsage]);
        }
    }
    pastPVGenList = dataSet;

}

// PV 예측 발전량
var feturePVGenList;
var feturePvGenTotalVal = 0; // 전체 누적합
function predictPvGenListUI(result) {
    var sheetList = result.sheetList;
    var chartList = result.chartList;

    // 데이터 셋팅
    var dataSet = []; // chartData를 위한 변수
    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
    var dt_str = "";
    var dt_str_totalVal = 0; // 테이블 라인별 누적합
    var map = null;

    // 표데이터 셋팅
    var start = new Date(schStartTime.getTime());
    var end = new Date(schEndTime.getTime());
    if (sheetList != null && sheetList.length > 0) {
        var s = start;
        var e = end;
        setHms(s, e);
        if (periodd === 'month') {
            s.setDate(1);
            s.setHours(0);
            s.setMinutes(0);
            s.setSeconds(0);
        }
        for (var i = 0; i < sheetList.length; i++) {

            reUsage = null;
            usage = String(sheetList[i].gen_val);
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
            }

            dt_str += "<td>" + ((reUsage == null) ? "" : reUsage) + "</td>";

            if (dt_col_cnt === dt_col) {
                dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>";
                feture_data_pc[dt_row_cnt - 1] = dt_str;
                dt_str_head = "";
                dt_str = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
            } else {
                if ((i + 1) === sheetList.length) { // 오늘이고 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str += "<td></td>";
                    }
                    dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>";
                    feture_data_pc[dt_row_cnt - 1] = dt_str;
                    dt_str_head = "";
                    dt_str = "";
                    dt_str_totalVal = 0;
                } else {
                    dt_col_cnt++;
                }
            }
            s = incrementTime(s);
        }
    }

    // 차트데이터 셋팅
    if (chartList != null && chartList.length > 0) {
        for (var i = 0; i < chartList.length; i++) {
            var usage = String(chartList[i].gen_val);
            var reUsage = 0;
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                feturePvGenTotalVal = feturePvGenTotalVal + Number(usage);
            }
            // 차트데이터 셋팅
            dataSet.push([setChartDateUTC(chartList[i].std_date), reUsage]);
        }
    }
    feturePVGenList = dataSet;

}



importScripts('/js/worker/subWorker.js')