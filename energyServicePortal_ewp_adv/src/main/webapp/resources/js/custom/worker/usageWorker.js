this.onmessage = function(e){
    init(e.data.config);
  switch(e.data.command){
    case 'pastUsageList':
        pastUsageListUI(e.data.data);
        postMessage({
            command: 'pastUsageList',
            usage_head_pc: usage_head_pc,
            real_data_pc: real_data_pc,
            pastUsageList: pastUsageList,
            totalUsage: totalUsage
        });
      break;
   case 'predictUsageList':
       predictUsageListUI(e.data.data);
       postMessage({
           command: 'predictUsageList',
           feture_data_pc: feture_data_pc,
           defaultData_pc: defaultData_pc,
           fetureUsageList: fetureUsageList,
           fetureTotalUsage: fetureTotalUsage
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

    usage_head_pc.length = 0;
    real_data_pc.length = 0;
    feture_data_pc.length = 0;
    defaultData_pc = "";
}

var usage_head_pc = []; // 실제 사용량 표 데이터
var real_data_pc = []; // 실제 사용량 표 데이터
var feture_data_pc = []; //  예측 사용량 표 데이터
var defaultData_pc = "";

// 실제 사용량
var pastUsageList;
var usage = null;
var reUsage = null;
var totalUsage = 0; // 전체 누적합
function pastUsageListUI(result) {
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
    totalUsage = 0;

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

            usage = String(sheetList[i].usg_val);
            reUsage = null;
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
            }

            dt_str += "<td>" + numberComma( (( isEmpty(reUsage) ) ? "" : reUsage) ) + "</td>";

            var tempDate; //timestamp 에 해당하는 날짜
            var lastCol = dt_col; // 마지막 컬럼
            if(SelTerm == "year" && periodd == "day") {
            	tempDate = new Date(sheetList[i].std_timestamp);
            	lastCol = (new Date(tempDate.getFullYear(), tempDate.getMonth() +1, 0)).getDate();
            }
            
            if (dt_col_cnt === lastCol) {
            
            	if(SelTerm == "year" && periodd == "day") {
            		var restCnt = dt_col - lastCol;
            		if(restCnt > 0) {
            			for(var j = 0; j < restCnt; j++) {
            				dt_str_head += "<th></th>";
            				dt_str += "<td></td>";
            			}
            		}
            	}
            	
                final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                dt_str += "<td>" + numberComma(numberComma(toFixedNum(dt_str_totalVal, 2))) + "</td>";
                usage_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                real_data_pc[dt_row_cnt - 1] = dt_str;
                dt_str_head = "";
                dt_str = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
                final_dt_str_head = "";
            } else {
                if ((i + 1) === sheetList.length) { // 루프 다 돌고 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str_head += "<th></th>";
                        dt_str += "<td></td>";
                    }
                    final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                    dt_str += "<td>" + numberComma(numberComma(toFixedNum(dt_str_totalVal, 2))) + "</td>";
                    usage_head_pc[dt_row_cnt - 1] = final_dt_str_head;
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
            usage = String(chartList[i].usg_val);
            reUsage = 0;
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                totalUsage = totalUsage + Number(usage);
            }
            dataSet.push([setChartDateUTC(chartList[i].std_timestamp), reUsage]);
        }
    }
    pastUsageList = dataSet;

}


// 예측 사용량
var fetureUsageList;
var fetureTotalUsage = 0; // 전체 누적합
function predictUsageListUI(result) {
    var sheetList = result.sheetList;
    var chartList = result.chartList;

    // 데이터 셋팅
    var dataSet = []; // chartData를 위한 변수
    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
    var dt_str = "";
    var dt_str_totalVal = 0; // 테이블 라인별 누적합
    var map = null;
    fetureTotalUsage = 0;
    defaultData_pc = "";

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

            usage = String(sheetList[i].pre_usg_val);
            reUsage = null;
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                dt_str_totalVal = dt_str_totalVal + Number(map.get("formatNum"));
            }

            dt_str += "<td>" + numberComma( ((reUsage == null) ? "" : reUsage) ) + "</td>";

            var tempDate; //timestamp 에 해당하는 날짜
            var lastCol = dt_col; // 마지막 컬럼
            if(SelTerm == "year" && periodd == "day") {
            	tempDate = new Date(sheetList[i].std_timestamp);
            	lastCol = (new Date(tempDate.getFullYear(), tempDate.getMonth() +1, 0)).getDate();
            }
            
            if (dt_col_cnt === lastCol) {
            	
            	if(SelTerm == "year" && periodd == "day") {
            		var restCnt = dt_col - lastCol;
            		if(restCnt > 0) {
            			for(var j = 0; j < restCnt; j++) {
            				dt_str += "<td></td>";
            			}
            		}
            	}
            	
            	dt_str += "<td>" + numberComma(numberComma(toFixedNum(dt_str_totalVal, 2))) + "</td>";
                feture_data_pc[dt_row_cnt - 1] = dt_str;
                dt_str = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
            } else {
                if ((i + 1) === sheetList.length) { // 루프 다 돌고 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str += "<td></td>";
                    }
                    dt_str += "<td>" + numberComma(numberComma(toFixedNum(dt_str_totalVal, 2))) + "</td>";
                    feture_data_pc[dt_row_cnt - 1] = dt_str;
                    dt_str = "";
                    dt_str_totalVal = 0;
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
    if (chartList != null && chartList.length > 0) {
        for (var i = 0; i < chartList.length; i++) {
            usage = String(chartList[i].pre_usg_val);
            reUsage = 0;
            if ( isEmpty(usage) || usage === "null") {
                reUsage = null;
            } else {
                map = convertUnitFormat(usage, "Wh", 5);
                reUsage = toFixedNum(map.get("formatNum"), 2);
                fetureTotalUsage = fetureTotalUsage + Number(usage);
            }
            // 차트데이터 셋팅
            dataSet.push([setChartDateUTC(chartList[i].std_timestamp), reUsage]);
        }
    }
    fetureUsageList = dataSet;

}



importScripts('/js/custom/worker/subWorker.js')