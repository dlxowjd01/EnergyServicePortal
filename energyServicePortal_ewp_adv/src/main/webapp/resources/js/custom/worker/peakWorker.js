this.onmessage = function(e){
    init(e.data.config);
  switch(e.data.command){
    case 'peakList':
        peakListListUI(e.data.data);
        postMessage({
            command: 'peakList',
            peak_head_pc: peak_head_pc,
            peak_data_pc: peak_data_pc,
            ctpPw_data_pc: ctpPw_data_pc,
            cgtPw_data_pc: cgtPw_data_pc,
            contractPowerList: contractPowerList,
            chargePowerList: chargePowerList,
            pastPeakList: pastPeakList,
            maxPeakVal: maxPeakVal,
            maxPeakTmstp: maxPeakTmstp
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
var contractPower;
var chargePower;
function init(config){
    periodd = config.periodd;
    schStartTime = config.schStartTime;
    schEndTime = config.schEndTime;
    SelTerm = config.SelTerm;
    dt_col = config.dt_col;
    timeOffset = config.timeOffset;
    
    peak_head_pc.length = 0;
    peak_data_pc.length = 0;
    ctpPw_data_pc.length = 0;
    cgtPw_data_pc.length = 0;
    contractPower = config.contractPower;
    chargePower = config.chargePower
}

var peak_head_pc = []; // 실제 사용량 표 데이터
var peak_data_pc = []; // 피크 전력 표 데이터
var ctpPw_data_pc = []; //  한전계약전력 표 데이터
var cgtPw_data_pc = []; //  요금적용전력 표 데이터

// 한전계약전력
var contractPowerList;
// 요금적용전력
var chargePowerList;
// 피크 전력
var pastPeakList;

var peakVal = null;
var rePeakVal = null;
var maxPeakVal = 0; // 최대피크
var maxPeakTmstp; // 최대피크시간
function peakListListUI(result) {
    var sheetList = result.sheetList;
    var chartList = result.chartList;

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
    var dt_str_totalVal = 0; // 테이블 라인별 누적합
    var final_dt_str_head = "";

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

            rePeakVal = null;
            peakVal = String(sheetList[i].peak_val);
            if ( isEmpty(peakVal) || peakVal === "null") {
                rePeakVal = null;
            } else {
                peakVal = peakVal / 1000;
                rePeakVal = toFixedNum(peakVal, 2);
            }

            dt_str += "<td>" + (( isEmpty(rePeakVal) ) ? "" : rePeakVal) + "</td>";
            dt_str2 += "<td>" + (( isEmpty(contractPower) ) ? "" : contractPower / 1000) + "</td>";
            dt_str3 += "<td>" + (( isEmpty(chargePower) ) ? "" : chargePower / 1000) + "</td>";
            if (dt_str_totalVal < rePeakVal) {
                dt_str_totalVal = rePeakVal; // 최대 피크전력 구하기
            }

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
            				dt_str2 += "<td></td>";
                            dt_str3 += "<td></td>";
            			}
            		}
            	}
            	
                final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                dt_str += "<td>" + numberComma(toFixedNum(dt_str_totalVal, 2)) + "</td>";
                dt_str2 += "<td>" + "-" + "</td>";
                dt_str3 += "<td>" + "-" + "</td>";
                peak_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                peak_data_pc[dt_row_cnt - 1] = dt_str;
                ctpPw_data_pc[dt_row_cnt - 1] = dt_str2;
                cgtPw_data_pc[dt_row_cnt - 1] = dt_str3;
                dt_str_head = "";
                dt_str = "";
                dt_str2 = "";
                dt_str3 = "";
                dt_row_cnt++;
                dt_col_cnt = 1;
                dt_str_totalVal = 0;
                final_dt_str_head = "";
            } else {
                if ((i + 1) === sheetList.length) { // 루프 다 돌고 조회한 목록이 라인을 다 못채울 때
                    for (a = 0; a < (dt_col - dt_col_cnt); a++) {
                        dt_str_head += "<th></th>";
                        dt_str += "<td></td>";
                        dt_str2 += "<td></td>";
                        dt_str3 += "<td></td>";
                    }
                    final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                    dt_str += "<td>" + dt_str_totalVal + "</td>";
                    dt_str2 += "<td>" + "-" + "</td>";
                    dt_str3 += "<td>" + "-" + "</td>";
                    peak_head_pc[dt_row_cnt - 1] = final_dt_str_head;
                    peak_data_pc[dt_row_cnt - 1] = dt_str;
                    ctpPw_data_pc[dt_row_cnt - 1] = dt_str2;
                    cgtPw_data_pc[dt_row_cnt - 1] = dt_str3;
                    dt_str_head = "";
                    dt_str = "";
                    dt_str2 = "";
                    dt_str3 = "";
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
            peakVal = String(chartList[i].peak_val);
            rePeakVal = 0;
            var tm = new Date(setSheetDateUTC(chartList[i].std_timestamp));

            if ( isEmpty(peakVal) || peakVal === "null") {
                rePeakVal = null;
            } else {
                peakVal = peakVal / 1000;
                rePeakVal = toFixedNum(peakVal, 2);

                if (maxPeakVal < rePeakVal) {
                    maxPeakVal = rePeakVal; // 최대 피크전력 구하기
                    maxPeakTmstp = tm.format("yyyy-MM-dd HH:mm:ss");
                }
            }

            // 차트데이터 셋팅
            dataSet.push([setChartDateUTC(chartList[i].std_timestamp), rePeakVal]);
            dataSet2.push([setChartDateUTC(chartList[i].std_timestamp), contractPower / 1000]);
            dataSet3.push([setChartDateUTC(chartList[i].std_timestamp), chargePower / 1000]);
        }
    }
    pastPeakList = dataSet;
    contractPowerList = dataSet2;
    chargePowerList = dataSet3;

}



importScripts('/js/custom/worker/subWorker.js')