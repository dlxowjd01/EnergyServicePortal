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

            var peak_head_pc = []; // 실제 사용량 표 데이터
            var peak_data_pc = []; // 피크 전력 표 데이터
            var ctpPw_data_pc = []; //  한전계약전력 표 데이터
            var cgtPw_data_pc = []; //  요금적용전력 표 데이터
            function getDBData(formData) {
                peak_head_pc.length = 0;
                peak_data_pc.length = 0;
                ctpPw_data_pc.length = 0;
                cgtPw_data_pc.length = 0;
                setDataTableColRowCnt(); // 1행의 최대 칸 수 및 테이블갯수
                getSiteSetDetail();
                getPeakRealList(formData); // 피크 전력 조회
                if ( !window.Worker ) {
                    drawData(); // 차트 및 표 그리기
                }
            }

            // 한전계약전력
            var contractPowerList;
            // 요금적용전력
            var chargePowerList;
            // 피크 전력
            var pastPeakList;

            var peakVal = null;
            var rePeakVal = null;
            function callback_getPeakRealList(result) {
                // Worker 지원 유무 확인
                if ( !!window.Worker ) {
                    startWorker(result, "peakList");
                } else {
                    var sheetList = result.sheetList;
                    var chartList = result.chartList;
                    var periodd = $("#selPeriodVal").val(); // 데이터조회간격

                    // 데이터 셋팅
                    var dataSet = []; // chartData를 위한 변수
                    var dataSet2 = []; // chartData를 위한 변수
                    var dataSet3 = []; // chartData를 위한 변수
                    var maxPeakVal = 0; // 최대피크
                    var maxPeakTmstp; // 최대피크시간
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

                            if (dt_col_cnt === dt_col) {
                                final_dt_str_head = "<th>" + convertDataTableHeaderDate(s, 1) + "</th>" + dt_str_head;
                                dt_str += "<td>" + toFixedNum(dt_str_totalVal, 2) + "</td>";
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

                    // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                    // 피크의 경우 피크 최대 전력을 입력
                    $(".pktime").empty().append($("<span />").append(maxPeakTmstp));
                    unit_format(String(Math.round(Number(maxPeakVal))), "pastPeakListTot", "kW");
                    unit_format(String(Math.round(Number(contractPower))), "contractPowerListTot", "W");
                    unit_format(String(Math.round(Number(chargePower))), "chargePowerListTot", "W");
                }

            }

            // 차트 그리기
            function drawData_chart() {
                var seriesLength = myChart.series.length;
                for (var i = seriesLength - 1; i > -1; i--) {
                    myChart.series[i].remove();
                }

                myChart.addSeries({
                    name: '피크 전력',
                    color: '#438fd7', /* 피크 전력 */
                    type: 'column',
                    data: pastPeakList
                }, false);

                myChart.addSeries({
                    name: '한전 계약 전력',
                    color: '#13af67', /* 한전 계약 전력 */
                    data: contractPowerList
                }, false);

                myChart.addSeries({
                    name: '요금 적용 전력',
                    color: '#f75c4a', /* 요금 적용 전력 */
                    data: chargePowerList
                }, false);

                setTickInterval();
                myChart.redraw(); // 차트 데이터를 다시 그린다
            }

            // 표(테이블) 그리기
            function drawData_table() {
                var $chart = $(".peak_chart");
                var tbodyStr = '';
                if (peak_data_pc.length > 0) {
                    $chart.find(".inchart-nodata").css("display", "none");
                    $chart.find(".inchart").css("display", "");
                    for (var i = 0; i < dt_row; i++) {
                        tbodyStr += '<div class="chart_table">';
                        tbodyStr += '<table class="pc_use">';
                        tbodyStr += '<thead>';
                        tbodyStr += '<tr>';
                        tbodyStr += peak_head_pc[i] + '<th>최대피크</th>';
                        tbodyStr += '</tr>';
                        tbodyStr += '</thead>';
                        tbodyStr += '<tbody>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit pk1"><span>피크 전력 (kW)</span></div></th>' + peak_data_pc[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit pk2"><span>한전 계약 전력 (kW)</span></div></th>' + ctpPw_data_pc[i];
                        tbodyStr += '</tr>';
                        tbodyStr += '<tr>';
                        tbodyStr += '<th><div class="ctit pk3"><span>요금 적용 전력 (kW)</span></th>' + cgtPw_data_pc[i];
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
            }
        </script>
    </head>
    <body>

        <div id="wrapper">
            <jsp:include page="../include/layout/sidebar.jsp">
                <jsp:param value="energy" name="linkGbn"/>
            </jsp:include>
            <div id="page-wrapper">
                <jsp:include page="../include/layout/header.jsp"/>
                <div id="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header">피크 전력 현황</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-2 use_total">
                            <div class="indiv">
                                <h2 class="ntit">
                                    피크 전력
                                </h2>
                                <ul class="chart_total">
                                    <li class="pk1">
                                        <div class="ctit pk1"><span>최대 피크 전력</span></div>
                                        <div class="pktime"><span>2018-08-12 11:41:26</span></div>
                                        <div class="cval" id="pastPeakListTot"><span>0</span>kW</div>
                                    </li>
                                    <li class="pk2">
                                        <div class="ctit pk2"><span>한전 계약 전력</span></div>
                                        <div class="cval" id="contractPowerListTot"><span>0</span>kW</div>
                                    </li>
                                    <li class="pk3">
                                        <div class="ctit pk3"><span>요금 적용 전력</span></div>
                                        <div class="cval" id="chargePowerListTot"><span>0</span>kW</div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-10">
                            <div class="indiv peak_chart">
                                <jsp:include page="../include/engy_monitoring_search.jsp">
                                    <jsp:param value="energy" name="schGbn"/>
                                </jsp:include>
                                <div class="inchart-nodata" style="display: none;">
                                    <span>조회 결과가 없습니다.</span>
                                </div>
                                <div class="inchart">
                                    <div id="chart2"></div>
                                    <script language="JavaScript" type="text/javascript">
                                        var myChart = Highcharts.chart('chart2', {
                                            chart: {
                                                marginLeft: 80,
                                                marginRight: 0,
                                                backgroundColor: 'transparent',
                                                type: 'line'
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
                                                    value: 9, /* 현재 */
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
                                                min: 0, /* 최소값 지정 */
                                                title: {
                                                    text: '(kW)',
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
                                                        fontSize: '18px'
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
                                                    return '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x))
                                                        + '<br/><span style="color:#438fd7">' + this.y + ' kW</span>';
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
                                                name: '피크 전력',
                                                color: '#438fd7', /* 최대 피크 전력 */
                                                type: 'column'
                                            }, {
                                                name: '한진 계약 전력',
                                                color: '#13af67' /* 한진 계약 전력 */
                                            }, {
                                                name: '요금 적용 전력',
                                                color: '#f75c4a' /* 요금 적용 전력 */
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
                                    </script>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row peak_chart_table">
                        <div class="col-lg-12">
                            <div class="indiv">
                                <div class="tbl_top clear">
                                    <h2 class="ntit fl">피크 전력 도표</h2>
                                    <ul class="fr">
                                        <li><a href="#;" class="save_btn"
                                               onclick="excelDownload('피크전력', event);">데이터저장</a></li>
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

    </body>
</html>