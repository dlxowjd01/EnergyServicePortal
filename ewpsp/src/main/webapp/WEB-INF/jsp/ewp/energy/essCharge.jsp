<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <jsp:include page="../include/common_static.jsp"/>
        <script src="../js/worker/worker.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                changeSelTerm('day');
                getCollect_sch_condition('worker');
            });

            function searchData() {
                getCollect_sch_condition('worker'); // 검색조건 모으기
            }

            var ess_head_pc = []; // 실제 사용량 표 데이터
            var realChg_data_pc = []; // 실제 충전량 표 데이터
            var realDischg_data_pc = []; // 실제 방전량 표 데이터
            var fetureChg_data_pc = []; //  예측 충전량 표 데이터
            var fetureDischg_data_pc = []; //  예측 방전량 표 데이터
            var defaultData_pc = "";

            function getDBData(formData) {
                realChg_data_pc.length = 0;
                realDischg_data_pc.length = 0;
                fetureChg_data_pc.length = 0;
                fetureDischg_data_pc.length = 0;
                setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
                getESSChargeRealList(formData); // 실제충방전량 조회
                getESSChargeFutureList(formData); // 예측충방전량 조회
                if ( !window.Worker ) {
                    drawData(); // 차트 및 표 그리기
                }
            }

            // 실제 충방전량 조회
            var pastChgList;
            var pastDischgList;
            var chgVal = null;
            var dischgVal = null;
            var reChgVal = null;
            var reDischgVal = null;
            function callback_getESSChargeRealList(result) {
                // Worker 지원 유무 확인
                if ( !!window.Worker ) {
                    startWorker(result, "pastEssChargeList");
                } else {
                    var resultListMap = result.resultListMap;
                    var chgSheetList = result.chgSheetList;
                    var chgChartList = result.chgChartList;
                    var dischgSheetList = result.dischgSheetList;
                    var dischgChartList = result.dischgChartList;
                    var periodd = $("#selPeriodVal").val(); // 데이터조회간격

                    // 데이터 셋팅
                    var dataSet = []; // chartData를 위한 변수
                    var dataSet2 = []; // chartData를 위한 변수
                    var totalDataSet = 0; // 전체 누적합
                    var totalDataSet2 = 0; // 전체 누적합
                    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
                    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
                    var dt_str_head = "";
                    var dt_str = "";
                    var dt_str2 = "";
                    var dt_str_totalVal = 0; // 테이블 라인별 누적합
                    var dt_str2_totalVal = 0; // 테이블 라인별 누적합
                    var final_dt_str_head = "";
                    var map = null;

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
                                totalDataSet = totalDataSet + Number(chgVal);
                            }
                            if ( isEmpty(dischgVal) || dischgVal === "null") reDischgVal = null;
                            else {
                                map = convertUnitFormat(dischgVal, "Wh", 5);
                                reDischgVal = toFixedNum(map.get("formatNum"), 2);
                                totalDataSet2 = totalDataSet2 + Number(dischgVal);
                            }
                            // 차트데이터 셋팅
                            dataSet.push([setChartDateUTC(chgChartList[i].std_timestamp), reChgVal]);
                            dataSet2.push([setChartDateUTC(chgChartList[i].std_timestamp), reDischgVal]);
                        }

                    }
                    pastChgList = dataSet;
                    pastDischgList = dataSet2;

                    // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                    unit_format(String(totalDataSet), "pastChgTot", "Wh");
                    unit_format(String(totalDataSet2), "pastDischgTot", "Wh");
                }

            }

            // 예측 충방전량
            var fetureChgList;
            var fetureDischgList;
            function callback_getESSChargeFutureList(result) {
                // Worker 지원 유무 확인
                if ( !!window.Worker ) {
                    startWorker(result, "predictEssChargeList");
                } else {
                    var resultListMap = result.resultListMap;
                    var chgSheetList = result.chgSheetList;
                    var chgChartList = result.chgChartList;
                    var dischgSheetList = result.dischgSheetList;
                    var dischgChartList = result.dischgChartList;
                    var periodd = $("#selPeriodVal").val(); // 데이터조회간격

                    // 데이터 셋팅
                    var dataSet = []; // chartData를 위한 변수
                    var dataSet2 = []; // chartData를 위한 변수
                    var totalDataSet = 0; // 전체 누적합
                    var totalDataSet2 = 0; // 전체 누적합
                    var dt_col_cnt = 1; // 1행의 최대 칸 수 체크를 위한 변수
                    var dt_row_cnt = 1; // 테이블갯수 체크를 위한 변수
                    var dt_str = "";
                    var dt_str2 = "";
                    var dt_str_totalVal = 0; // 테이블 라인별 누적합
                    var dt_str2_totalVal = 0; // 테이블 라인별 누적합
                    var map = null;

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
                                totalDataSet = totalDataSet + Number(chgVal);
                            }
                            if ( isEmpty(dischgVal) || dischgVal === "null") reDischgVal = null;
                            else {
                                map = convertUnitFormat(dischgVal, "Wh", 5);
                                reDischgVal = toFixedNum(map.get("formatNum"), 2);
                                totalDataSet2 = totalDataSet2 + Number(dischgVal);
                            }
                            // 차트데이터 셋팅
                            dataSet.push([setChartDateUTC(chgChartList[i].std_timestamp), reChgVal]);
                            dataSet2.push([setChartDateUTC(chgChartList[i].std_timestamp), reDischgVal]);
                        }
                    }
                    fetureChgList = dataSet;
                    fetureDischgList = dataSet2;

                    // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                    unit_format(String(totalDataSet), "fetureChgTot", "Wh");
                    unit_format(String(totalDataSet2), "fetureDischgTot", "Wh");
                }

            }

            // 차트 그리기
            function drawData_chart() {
                var seriesLength = myChart.series.length;
                for (var i = seriesLength - 1; i > -1; i--) {
                    myChart.series[i].remove();
                }

                myChart.addSeries({
                    type: 'column',
                    name: '충전량',
                    color: '#438fd7',
                    data: pastChgList
                }, false);

                myChart.addSeries({
                    type: 'line',
                    name: '충전 계획',
                    color: '#13af67',
                    dashStyle: 'ShortDash',
                    data: fetureChgList
                }, false);

                myChart.addSeries({
                    type: 'column',
                    name: '방전량',
                    color: '#f75c4a',
                    data: pastDischgList
                }, false);

                myChart.addSeries({
                    type: 'line',
                    name: '방전 계획',
                    color: '#84848f',
                    dashStyle: 'ShortDash',
                    data: fetureDischgList
                }, false);

                setTickInterval();

                myChart.redraw(); // 차트 데이터를 다시 그린다
            }

            // 표(테이블) 그리기
            function drawData_table() {
                var $chart = $(".ess_chart");
                var tbodyStr = '';

                if (realChg_data_pc.length > 0) {
                    $chart.find(".inchart-nodata").css("display", "none");
                    $chart.find(".inchart").css("display", "");
                    for (var i = 0; i < dt_row; i++) {
                        tbodyStr += '<div class="chart_table">';
                        tbodyStr += '<table class="pc_use">';
                        tbodyStr += '<thead>';
                        tbodyStr += '<tr>';
                        tbodyStr += ess_head_pc[i] + '<th>합계</th>';
                        tbodyStr += '</tr>';
                        tbodyStr += '</thead>';
                        tbodyStr += '<tbody>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit es1"><span>충전량 (kWh)</span></div></th>' + realChg_data_pc[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit es2"><span>충전 계획 (kWh)</span></div></th>' + ((fetureChg_data_pc[i] === undefined) ? defaultData_pc : fetureChg_data_pc[i]);
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit es3"><span>방전량 (kWh)</span></th>' + realDischg_data_pc[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit es4"><span>방전 계획 (kWh)</span></th>' + ((fetureDischg_data_pc[i] === undefined) ? defaultData_pc : fetureDischg_data_pc[i]);
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
                    tbodyStr += '<tr>';
                    tbodyStr += '<th width="33%"></th>';
                    tbodyStr += '<td width="34%">조회 결과가 없습니다.</td>';
                    tbodyStr += '<th width="33%"></th>';
                    tbodyStr += '</tr>';
                    tbodyStr += '</thead>';
                    tbodyStr += '</table>';
                    tbodyStr += '</div>';

                }

                $("#pc_use_dataDiv").html(tbodyStr);
                defaultData_pc = "";
            }
        </script>
    </head>
    <body>

        <div id="wrapper">
            <jsp:include page="../include/layouts/sidebar.jsp">
                <jsp:param value="energy" name="linkGbn"/>
            </jsp:include>
            <div id="page-wrapper">
                <jsp:include page="../include/layouts/header.jsp"/>
                <div id="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header">ESS 충•방전량 조회</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-2 use_total">
                            <div class="indiv">
                                <h2 class="ntit">충•방전량 합계</h2>
                                <ul class="chart_total">
                                    <li class="es1">
                                        <div class="ctit es1"><span>충전량</span></div>
                                        <div class="cval" id="pastChgTot"><span>0</span>kWh</div>
                                    </li>
                                    <li class="es2">
                                        <div class="ctit es2"><span>충전 계획</span></div>
                                        <div class="cval" id="fetureChgTot"><span>0</span>kWh</div>
                                    </li>
                                    <li class="es3">
                                        <div class="ctit es3"><span>방전량</span></div>
                                        <div class="cval" id="pastDischgTot"><span>0</span>kWh</div>
                                    </li>
                                    <li class="es4">
                                        <div class="ctit es4"><span>방전 계획</span></div>
                                        <div class="cval" id="fetureDischgTot"><span>0</span>kWh</div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-10">
                            <div class="indiv ess_chart">
                                <jsp:include page="../include/engy_monitoring_search.jsp">
                                    <jsp:param value="energy" name="schGbn"/>
                                </jsp:include>
                                <div class="inchart-nodata" style="display: none;">
                                    <span>조회 결과가 없습니다.</span>
                                </div>
                                <div class="inchart">
                                    <div class="chart_type">
                                        <a href="#;" class="chart_change_column">그래프변경</a>
                                        <a href="#;" class="chart_change_line" style="display:none;">그래프변경</a>
                                    </div>
                                    <div id="chart2"></div>
                                    <script language="JavaScript" type="text/javascript">
                                        var myChart = Highcharts.chart('chart2', {

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
                                                },
                                                /* 기준선 */
                                                plotLines: [{
                                                    value: 21, /* 현재 */
                                                    color: '#438fd7',
                                                    width: 2,
                                                    zIndex: 0,
                                                    label: {
                                                        text: ''
                                                    }
                                                }]
                                                , crosshair: true // 08.22 이우람 추가
                                            },

                                            yAxis: {
                                                gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                                                title: {
                                                    text: '(kWh)',
                                                    align: 'low',
                                                    rotation: 0, /* 타이틀 기울기 */
                                                    y: 25, /* 타이틀 위치 조정 */
                                                    x: 25, /* 타이틀 위치 조정 */
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
                                                        fontSize: '18px'
                                                    }
                                                }
                                            },

                                            /* 범례 */
                                            legend: {
                                                enabled: true,
                                                align: 'right',
                                                verticalAlign: 'top',
                                                x: -120,
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
                                                    return '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x))
                                                        + '<br/><span style="color:#438fd7">' + this.y + ' kWh</span>';
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
                                                }
                                            },

                                            /* 출처 */
                                            credits: {
                                                enabled: false
                                            },

                                            /* 그래프 스타일 */
                                            series: [{
                                                type: 'column',
                                                name: '충전량',
                                                color: '#438fd7'
                                            }, {
                                                type: 'line',
                                                name: '충전 계획',
                                                color: '#13af67',
                                                dashStyle: 'ShortDash'
                                            }, {
                                                type: 'column',
                                                name: '방전량',
                                                color: '#f75c4a'
                                            }, {
                                                type: 'line',
                                                name: '방전 계획',
                                                color: '#84848f',
                                                dashStyle: 'ShortDash'
                                            }],

                                            /* 반응형 */
                                            responsive: {
                                                rules: [{
                                                    condition: {
                                                        maxWidth: 414 /* 차트 사이즈 */
                                                    },
                                                    chartOptions: {
                                                        chart: {
                                                            marginLeft: 60,
                                                            marginTop: 80
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

                                        /* 차트 변경 */
                                        $(function () {
                                            $('.chart_change_column').click(function () {
                                                $(this).hide();
                                                $('.chart_change_line').show();
                                                myChart.series[1].update({
                                                    type: "column"
                                                });
                                                myChart.series[3].update({
                                                    type: "column"
                                                });

                                            });
                                            $('.chart_change_line').click(function () {
                                                $(this).hide();
                                                $('.chart_change_column').show();
                                                myChart.series[1].update({
                                                    type: "line"
                                                });
                                                myChart.series[3].update({
                                                    type: "line"
                                                });

                                            });
                                        });
                                    </script>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ess_chart_table">
                        <div class="col-lg-12">
                            <div class="indiv">
                                <div class="tbl_top clear">
                                    <h2 class="ntit fl">충•방전량 도표</h2>
                                    <ul class="fr">
                                        <li><a href="#;" class="save_btn" onclick="excelDownload('ESS충방전량', event);">데이터저장</a>
                                        </li>
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
                <jsp:include page="../include/layouts/footer.jsp"/>
            </div>
        </div>

    </body>

</html>
