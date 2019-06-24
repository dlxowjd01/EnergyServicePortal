<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <jsp:include page="../include/common_static.jsp"/>
        <script type="text/javascript">
            var realTimeRefresh = null;
            var nextDrRefreshTime = null;
            $(document).ready(function () {
                getSiteSetDetail();
                cblSet();
                $(".real_time").find('span').empty();

                // 화면 첫 로딩 시 검색조건 셋팅
                changeSelTerm('drday');
                cblTimeSetiing();
                getCollect_sch_condition(); // 검색조건 모으기

                // 실시간 갱신
                $("#check1").change(function () {
                    if ($("#check1").is(":checked")) {
                        $("#selTermBox").empty().append("1일(오늘)").append($('<span class="caret" />'));
                        changeSelTerm('drday');
                        $("#selPeriod").empty().append("5분").append($('<span class="caret" />'));
                        $("#selPeriodVal").val('5min');

                        $('.loading').show();
                        $(".real_time").find('span').empty().show();
                        nextRefreshTimeSet();
                        setTimeout(function () {
                            realTimeRefreshFn();
                            searchDisableChange(true);
                            myChart.yAxis[0].setTitle({text: "(kW)"});
                        }, 1000);
                        setTimeout(function () {
                            $('.loading').hide();
                        }, 1000);

                        if (realTimeRefresh == null) { // 1분 간격
                            realTimeRefresh = setInterval(function () {
                                $('.loading').show();
                                clearInterval(nextDrRefreshTime);
                                nextDrRefreshTime = null;
                                nextRefreshTimeSet();
                                setTimeout(function () {
                                    realTimeRefreshFn();
                                }, 1000);
                                var today = new Date();
                                update_updtDataTime(today, "updtTime"); // 검색시간(차트 새로고침시간) 업데이트
                                setTimeout(function () {
                                    $('.loading').hide();
                                }, 1000);
                            }, 1000 * 60 * 5); // 1000 = 1초, 5000 = 5초
                        } else {
                            alert("이미 실시간 자동갱신이 실행중입니다.");
                        }

                    } else {
                        $("#selPeriod").empty().append("15분").append($('<span class="caret" />'));
                        $("#selPeriodVal").val('15min');
                        clearInterval(realTimeRefresh);
                        realTimeRefresh = null;
                        clearInterval(nextDrRefreshTime);
                        nextDrRefreshTime = null;
                        $(".real_time").find('span').empty();
                        searchDisableChange(false);

                        $("#searchBtn").trigger('click');
                    }
                });
            });

            function nextRefreshTimeSet() {
                var nextTime = new Date();

                var nextTimeVal = new Date(nextTime.setMinutes(nextTime.getMinutes() + 5));
                if (nextDrRefreshTime == null) {
                    nextDrRefreshTime = setInterval(function () {
                        remain(nextTimeVal);
                    }, 1000);
                } else {

                }
            }

            // 남은 시간 카운터
            function remain(nextTimeVal) {
                var now = new Date();
                var gap = Math.round((nextTimeVal.getTime() - now.getTime()) / 1000);

                var D = Math.floor(gap / 86400);
                var H = Math.floor((gap - D * 86400) / 3600 % 3600);
                var M = Math.floor((gap - H * 3600) / 60 % 60);
                if ((String(M)).length === 1) M = "0" + M;
                var S = Math.floor((gap - M * 60) % 60);
                if ((String(S)).length === 1) S = "0" + S;

                $(".real_time").find('span').empty().html(M + ':' + S);
                if (M === 0 && S === 0) {
                    //		nextTime = new Date();
                    clearInterval(nextDrRefreshTime);
                    nextDrRefreshTime = null;
                }
            }

            function cblSet() {
                var now = new Date();
                var hour = now.getHours();
                $("#cblAmtHourFrom").val(hour);
                $("#cblAmtHourTo").val(hour + 2);
            }

            // 기준부하시간 설정
            function cblTimeSetiing() {
                var cblAmtHourFrom = $("#cblAmtHourFrom").val();
                var cblAmtHourTo = $("#cblAmtHourTo").val();

                var firstDay = new Date();
                var endDay = new Date();
                var startTime;
                var endTime;
                if (SelTerm === 'drday') { // 에너지모니터링 dr실적조회의 오늘날짜
                    startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), cblAmtHourFrom, 0, 0);
                    endTime = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), cblAmtHourTo, 0, 0);
                } else if (SelTerm === 'selectDay') { // 에너지모니터링 dr실적조회의 날짜검색
                    startTime = new Date($dtpk5.val() + " " + cblAmtHourFrom + ":00:00");
                    endTime = new Date($dtpk5.val() + " " + cblAmtHourTo + ":00:00");
                }

                //	var queryStart = new Date(startTime.setMinutes(startTime.getMinutes() + (new Date()).getTimezoneOffset()));
                //	var queryEnd = new Date(endTime.setMinutes(endTime.getMinutes() + (new Date()).getTimezoneOffset()));
                var queryStart = new Date(startTime.getTime());
                var queryEnd = new Date(endTime.getTime());

                queryStart = (!queryStart instanceof Date) ? "" : queryStart.format("yyyyMMddHHmmss");
                queryEnd = (!queryEnd instanceof Date) ? "" : queryEnd.format("yyyyMMddHHmmss");

                $("#cblAmtFrom").val(queryStart);
                $("#cblAmtTo").val(queryEnd);
            }

            // 검색버튼 클릭
            function searchData() {
                var cblAmtHourFrom = $("#cblAmtHourFrom").val();
                var cblAmtHourTo = $("#cblAmtHourTo").val();
                var cblAmtGapTime = Number(cblAmtHourTo) - Number(cblAmtHourFrom);

                if (cblAmtGapTime < 0) {
                    alert("조회할수 없는 시간대입니다.");
                    return;
                } else if (cblAmtGapTime > 4) {
                    alert("최대 4시간까지 조회 가능합니다.");
                    return;
                }

                cblTimeSetiing();
                getCollect_sch_condition(); // 검색조건 모으기
                myChart.yAxis[0].setTitle({text: "(kWh)"});
            }

            var real_data_pc = []; // 실제 사용량 표 데이터
            function getDBData(formData) {
                real_data_pc.length = 0;
                getCbl(formData);
                getUsageRealList(formData); // 실제사용량 조회
                drawData_chart();
                getDRResultList(formData);
            }

            // 실시간 갱신 체크박스
            function realTimeRefreshFn() {
                var firstDay = new Date();
                var endDay = new Date();
                var startTime;
                var endTime;

                startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), 0, 0, 0);
                endTime = new Date();
                schStartTime = new Date(startTime.getTime());
                schEndTime = new Date(endTime.getTime());

                //	var queryStart = new Date(startTime.setMinutes(startTime.getMinutes() + (new Date()).getTimezoneOffset()));
                //	var queryEnd = new Date(endTime.setMinutes(endTime.getMinutes() + (new Date()).getTimezoneOffset()));
                var queryStart = new Date(startTime.getTime());
                var queryEnd = new Date(endTime.getTime());

                queryStart = (!queryStart instanceof Date) ? "" : queryStart.format("yyyyMMddHHmmss");
                queryEnd = (!queryEnd instanceof Date) ? "" : queryEnd.format("yyyyMMddHHmmss");
                $("#selTermFrom").val(queryStart);
                $("#selTermTo").val(queryEnd);

                cblSet();
                cblTimeSetiing();

                var formData = $("#schForm").serializeObject();
                console.log("실시간  ", formData);

                searchDRApi(formData);
            }

            function searchDRApi(formData) {
                $.ajax({
                    url: "/searchDRApi",
                    type: 'post',
                    async: false, // 동기로 처리해줌
                    data: formData,
                    success: function (result) {
                        var today = new Date();
                        update_updtDataTime(today, "updtTime"); // 검색시간(차트 새로고침시간) 업데이트

                        refreshChartData(result);
                        drawData_chart();
                        refreshSheetData(result);
                    }
                });

            }

            function searchDisableChange(flag) {
                $("#selTermBox").prop("disabled", flag);
                $("#selPeriod").prop("disabled", flag);
                $("#datepicker5").prop("disabled", flag);
                $("#cblAmtHourFrom").prop("readonly", flag);
                $("#cblAmtHourTo").prop("readonly", flag);
                $("#searchBtn").prop("disabled", flag);
            }

            var dbCblList;

            function getCbl(formData) {
                $.ajax({
                    url: "/getCbl",
                    type: 'post',
                    async: false, // 동기로 처리해줌
                    data: formData,
                    success: function (result) {
                        var cblList = result.list;
                        dbCblList = cblList;
                    }
                });
            }


            // 검색결과 그래프 데이터
            var pastUsageList;
            var timeSlotCblAmtList1;
            var timeSlotCblAmtList2;
            var timeSlotCblAmtList3;
            var timeSlotCblAmtList4;
            var timeSlotGoalPowerList1;
            var timeSlotGoalPowerList2;
            var timeSlotGoalPowerList3;
            var timeSlotGoalPowerList4;

            function callback_getUsageRealList(result) {
                var chartList = result.chartList;

                // 데이터 셋팅
                var dataSet = []; // chartData를 위한 변수
                var dataSet2_1 = []; // chartData를 위한 변수(기준부하 12시이전)
                var dataSet2_2 = []; // chartData를 위한 변수(기준부하 13시이후)
                var dataSet2_3 = []; // chartData를 위한 변수(기준부하 13시이후)
                var dataSet2_4 = []; // chartData를 위한 변수(기준부하 13시이후)
                var dataSet3_1 = []; // chartData를 위한 변수(목표사용량 12시이전)
                var dataSet3_2 = []; // chartData를 위한 변수(목표사용량 13시이후)
                var dataSet3_3 = []; // chartData를 위한 변수(목표사용량 13시이후)
                var dataSet3_4 = []; // chartData를 위한 변수(목표사용량 13시이후)
                var totalUsage = 0; // 전체 누적합
                var totalGoalPower = 0; // 전체 누적합
                var totalCbl = 0; // 전체 누적합
                var $dr_chart = $(".dr_chart");
                if (chartList != null && chartList.length > 0) {
                    $dr_chart.find(".inchart-nodata").css("display", "none");
                    $dr_chart.find(".inchart").css("display", "");
                    for (var i = 0; i < chartList.length; i++) {
                        var usage = String(chartList[i].usg_val);
                        var reUsage = 0;
                        if ( isEmpty(usage) || usage === "null") {
                            reUsage = null;
                        } else {
                            var usageMap = convertUnitFormat(usage * 4, "Wh", 5);
                            reUsage = toFixedNum(usageMap.get("formatNum"), 2);
                            totalUsage = totalUsage + Number(usage);
                        }

                        // 차트데이터 셋팅
                        dataSet.push([setChartDateUTC(chartList[i].std_timestamp), reUsage]);

                    }

                    if (dbCblList != null) {
                        for (var i = 0; i < dbCblList.length; i++) {
                            var hour = new Date(setSheetDateUTC(dbCblList[i].start_timestamp)).getHours();

                            if (hour !== 12) {
                                var next = dbCblList[i].start_timestamp + (1000 * 3600);
                                var cblMap = convertUnitFormat(dbCblList[i].cbl, "Wh", 5);
                                var cbl = Math.round(Number(cblMap.get("formatNum")));
                                var reReduceAmt = (reduceAmt / 1000) / 4;

                                if (i === 0) {
                                    dataSet2_1.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl]);
                                    dataSet3_1.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl - reReduceAmt]);
                                    dataSet2_1.push([setChartDateUTC(next), cbl]);
                                    dataSet3_1.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    totalGoalPower = cbl - reReduceAmt;
                                    totalCbl = cbl;
                                } else if (i === 1) {
                                    if (i + 1 !== dbCblList.length) {
                                        dataSet2_2.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl]);
                                        dataSet3_2.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl - reReduceAmt]);
                                        dataSet2_2.push([setChartDateUTC(next), cbl]);
                                        dataSet3_2.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    }
                                } else if (i === 2) {
                                    if (i + 1 !== dbCblList.length) {
                                        dataSet2_3.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl]);
                                        dataSet3_3.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl - reReduceAmt]);
                                        dataSet2_3.push([setChartDateUTC(next), cbl]);
                                        dataSet3_3.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    }
                                } else if (i === 3) {
                                    if (i + 1 !== dbCblList.length) {
                                        dataSet2_4.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl]);
                                        dataSet3_4.push([setChartDateUTC(dbCblList[i].start_timestamp), cbl - reReduceAmt]);
                                        dataSet2_4.push([setChartDateUTC(next), cbl]);
                                        dataSet3_4.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    }
                                }
                            }

                        }
                    }

                } else {
                    $dr_chart .find(".inchart-nodata").css("display", "");
                    $dr_chart .find(".inchart").css("display", "none");
                }
                pastUsageList = dataSet;
                timeSlotCblAmtList1 = dataSet2_1;
                timeSlotCblAmtList2 = dataSet2_2;
                timeSlotCblAmtList3 = dataSet2_3;
                timeSlotCblAmtList4 = dataSet2_4;
                timeSlotGoalPowerList1 = dataSet3_1;
                timeSlotGoalPowerList2 = dataSet3_2;
                timeSlotGoalPowerList3 = dataSet3_3;
                timeSlotGoalPowerList4 = dataSet3_4;

                myChart.tooltip.options.formatter = function () {
                    return '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x))
                        + '<br/><span style="color:#438fd7">' + this.y + ' kWh</span>';
                };

                // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                unit_format(String(totalUsage), "pastUseTot", "Wh");
                $("#" + "totalCbl").empty().append($("<span/>").append(numberComma(checkNumLen(totalCbl)))).append("kWh");
                $("#" + "totalGoalPower").empty().append($("<span/>").append(numberComma(checkNumLen(totalGoalPower)))).append("kWh");
            }

            // 검색결과 표 데이터
            function callback_getDRResultList(result) {
                var drList = result.list;
                var totalReduceAmt = 0; // 전체 누적합

                $tbody = $("#drResultTbody");
                var tbodyStr = '';
                if (drList != null && drList.length > 0) {
                    for (var i = 0; i < drList.length; i++) {
                        var drStartDate = setSheetDateUTC(drList[i].start_timestamp);
                        var drEndDate = setSheetDateUTC(drList[i].end_timestamp);
                        tbodyStr += '<tr>';
                        tbodyStr += '<td>' + drStartDate.format("yyyy-MM-dd") + '</td>';
                        tbodyStr += '<td>' + drStartDate.format("HH:mm") + " ~ " + drEndDate.format("HH:mm") + '</td>';
                        tbodyStr += '<td>' + drList[i].act_amt + '</td>';
                        tbodyStr += '<td>' + drList[i].cbl_amt + '</td>';
                        tbodyStr += '<td>' + drList[i].cbl_power + '</td>';
                        tbodyStr += '<td>' + drList[i].goal_power + '</td>';
                        tbodyStr += '<td>' + drList[i].reduce_amt + '</td>';
                        tbodyStr += '<td>' + drList[i].fulfill_per + '</td>';
                        tbodyStr += '</tr>';

                        totalReduceAmt = totalReduceAmt + Number(String(drList[i].reduce_amt));
                    }

                } else {
                    tbodyStr += '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>';
                }

                $tbody.html(tbodyStr);

                // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                unit_format(String(totalReduceAmt), "totalReduceAmt", "Wh");

            }

            // 차트 그리기
            function drawData_chart() {
                var seriesLength = myChart.series.length;
                for (var i = seriesLength - 1; i > -1; i--) {
                    myChart.series[i].remove();
                }

                myChart.addSeries({
                    name: '실제 사용량',
                    color: '#438fd7',
                    data: pastUsageList
                }, false);

                if (timeSlotCblAmtList1 != null && timeSlotCblAmtList1.length > 0) {
                    myChart.addSeries({
                        name: '기준부하',
                        color: '#f75c4a',
                        data: timeSlotCblAmtList1
                    }, false);
                }

                if (timeSlotCblAmtList2 != null && timeSlotCblAmtList2.length > 0) {
                    var linkedTo;
                    if (timeSlotCblAmtList1 != null && timeSlotCblAmtList1.length > 0) {
                        linkedTo = ':previous';
                    } else {
                        linkedTo = undefined;
                    }
                    myChart.addSeries({
                        name: '기준부하',
                        color: '#f75c4a',
                        linkedTo: linkedTo, // 전의 series와 하나로 연결한다
                        data: timeSlotCblAmtList2
                    }, false);

                }

                if (timeSlotCblAmtList3 != null && timeSlotCblAmtList3.length > 0) {
                    var linkedTo;
                    if ((timeSlotCblAmtList1 != null && timeSlotCblAmtList1.length > 0) ||
                        (timeSlotCblAmtList2 != null && timeSlotCblAmtList2.length > 0)) {
                        linkedTo = ':previous';
                    } else {
                        linkedTo = undefined;
                    }
                    myChart.addSeries({
                        name: '기준부하',
                        color: '#f75c4a',
                        linkedTo: linkedTo, // 전의 series와 하나로 연결한다
                        data: timeSlotCblAmtList3
                    }, false);

                }

                if (timeSlotCblAmtList4 != null && timeSlotCblAmtList4.length > 0) {
                    var linkedTo;
                    if ((timeSlotCblAmtList1 != null && timeSlotCblAmtList1.length > 0) ||
                        (timeSlotCblAmtList2 != null && timeSlotCblAmtList2.length > 0) ||
                        (timeSlotCblAmtList3 != null && timeSlotCblAmtList3.length > 0)) {
                        linkedTo = ':previous';
                    } else {
                        linkedTo = undefined;
                    }
                    myChart.addSeries({
                        name: '기준부하',
                        color: '#f75c4a',
                        linkedTo: linkedTo, // 전의 series와 하나로 연결한다
                        data: timeSlotCblAmtList4
                    }, false);

                }

                if (timeSlotGoalPowerList1 != null && timeSlotGoalPowerList1.length > 0) {
                    myChart.addSeries({
                        name: '목표사용량',
                        color: '#13af67',
                        type: 'area',
                        fillOpacity: 0.1,
                        data: timeSlotGoalPowerList1
                    }, false);
                }

                if (timeSlotGoalPowerList2 != null && timeSlotGoalPowerList2.length > 0) {
                    var linkedTo;
                    if (timeSlotCblAmtList1 != null && timeSlotCblAmtList1.length > 0) {
                        linkedTo = ':previous';
                    } else {
                        linkedTo = undefined;
                    }
                    myChart.addSeries({
                        name: '목표사용량',
                        color: '#13af67',
                        type: 'area',
                        fillOpacity: 0.1,
                        linkedTo: linkedTo, // 전의 series와 하나로 연결한다
                        data: timeSlotGoalPowerList2
                    }, false);
                }

                if (timeSlotGoalPowerList3 != null && timeSlotGoalPowerList3.length > 0) {
                    var linkedTo;
                    if ((timeSlotGoalPowerList1 != null && timeSlotGoalPowerList1.length > 0) ||
                        (timeSlotGoalPowerList2 != null && timeSlotGoalPowerList2.length > 0)) {
                        linkedTo = ':previous';
                    } else {
                        linkedTo = undefined;
                    }
                    myChart.addSeries({
                        name: '목표사용량',
                        color: '#13af67',
                        type: 'area',
                        fillOpacity: 0.1,
                        linkedTo: linkedTo, // 전의 series와 하나로 연결한다
                        data: timeSlotGoalPowerList3
                    }, false);
                }

                if (timeSlotGoalPowerList4 != null && timeSlotGoalPowerList4.length > 0) {
                    var linkedTo;
                    if ((timeSlotGoalPowerList1 != null && timeSlotGoalPowerList1.length > 0) ||
                        (timeSlotGoalPowerList2 != null && timeSlotGoalPowerList2.length > 0) ||
                        (timeSlotGoalPowerList3 != null && timeSlotGoalPowerList3.length > 0)) {
                        linkedTo = ':previous';
                    } else {
                        linkedTo = undefined;
                    }
                    myChart.addSeries({
                        name: '목표사용량',
                        color: '#13af67',
                        type: 'area',
                        fillOpacity: 0.1,
                        linkedTo: linkedTo, // 전의 series와 하나로 연결한다
                        data: timeSlotGoalPowerList4
                    }, false);
                }

                setTickInterval();

                myChart.redraw(); // 차트 데이터를 다시 그린다
            }


            // 실시간 갱신 그래프 데이터
            function refreshChartData(result) {
                var chartList = result.chartList;
                var cblList = result.cblList;

                // 데이터 셋팅
                var dataSet = []; // chartData를 위한 변수
                var dataSet2_1 = []; // chartData를 위한 변수(기준부하 12시이전)
                var dataSet2_2 = []; // chartData를 위한 변수(기준부하 13시이후)
                var dataSet2_3 = []; // chartData를 위한 변수(기준부하 13시이후)
                var dataSet2_4 = []; // chartData를 위한 변수(기준부하 13시이후)
                var dataSet3_1 = []; // chartData를 위한 변수(목표사용량 12시이전)
                var dataSet3_2 = []; // chartData를 위한 변수(목표사용량 13시이후)
                var dataSet3_3 = []; // chartData를 위한 변수(목표사용량 13시이후)
                var dataSet3_4 = []; // chartData를 위한 변수(목표사용량 13시이후)
                var totalUsage = 0; // 전체 누적합
                var totalGoalPower = 0; // 전체 누적합
                var totalCbl = 0; // 전체 누적합
                var $dr_chart = $(".dr_chart");
                if (chartList != null && chartList.length > 0) {
                    $dr_chart.find(".inchart-nodata").css("display", "none");
                    $dr_chart.find(".inchart").css("display", "");
                    for (var i = 0; i < chartList.length; i++) {
                        var usage = String(chartList[i].usg_val);
                        var reUsage = 0;
                        if ( isEmpty(usage) || usage === "null") {
                            reUsage = null;
                        } else {
                            var usageMap = convertUnitFormat(usage * 12, "mW", 8);
                            reUsage = toFixedNum(usageMap.get("formatNum"), 2);
                            totalUsage = totalUsage + Number(usage);
                        }

                        // 차트데이터 셋팅
                        dataSet.push([setChartDateUTC(chartList[i].std_timestamp), reUsage]);

                    }

                    if (cblList != null) {
                        for (var i = 0; i < cblList.length; i++) {
                            var hour = new Date(setSheetDateUTC(cblList[i].start)).getHours();

                            if (hour !== 12) {
                                var next = cblList[i].start + (1000 * 3600);
                                var cblMap = convertUnitFormat(cblList[i].cbl, "mWh", 8);
                                var cbl = Math.round(Number(cblMap.get("formatNum")));
                                var reReduceAmt = (reduceAmt / 1000) / 4;

                                if (i === 0) {
                                    dataSet2_1.push([setChartDateUTC(cblList[i].start), cbl]);
                                    dataSet3_1.push([setChartDateUTC(cblList[i].start), cbl - reReduceAmt]);
                                    dataSet2_1.push([setChartDateUTC(next), cbl]);
                                    dataSet3_1.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    totalGoalPower = cbl - reReduceAmt;
                                    totalCbl = cbl;
                                } else if (i === 1) {
                                    if (i + 1 !== cblList.length) {
                                        dataSet2_2.push([setChartDateUTC(cblList[i].start), cbl]);
                                        dataSet3_2.push([setChartDateUTC(cblList[i].start), cbl - reReduceAmt]);
                                        dataSet2_2.push([setChartDateUTC(next), cbl]);
                                        dataSet3_2.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    }
                                } else if (i === 2) {
                                    if (i + 1 !== cblList.length) {
                                        dataSet2_3.push([setChartDateUTC(cblList[i].start), cbl]);
                                        dataSet3_3.push([setChartDateUTC(cblList[i].start), cbl - reReduceAmt]);
                                        dataSet2_3.push([setChartDateUTC(next), cbl]);
                                        dataSet3_3.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    }
                                } else if (i === 3) {
                                    if (i + 1 !== cblList.length) {
                                        dataSet2_4.push([setChartDateUTC(cblList[i].start), cbl]);
                                        dataSet3_4.push([setChartDateUTC(cblList[i].start), cbl - reReduceAmt]);
                                        dataSet2_4.push([setChartDateUTC(next), cbl]);
                                        dataSet3_4.push([setChartDateUTC(next), cbl - reReduceAmt]);
                                    }
                                }
                            }
                        }
                    }

                } else {
                    $dr_chart.find(".inchart-nodata").css("display", "");
                    $dr_chart.find(".inchart").css("display", "none");
                }
                pastUsageList = dataSet;
                timeSlotCblAmtList1 = dataSet2_1;
                timeSlotCblAmtList2 = dataSet2_2;
                timeSlotCblAmtList3 = dataSet2_3;
                timeSlotCblAmtList4 = dataSet2_4;
                timeSlotGoalPowerList1 = dataSet3_1;
                timeSlotGoalPowerList2 = dataSet3_2;
                timeSlotGoalPowerList3 = dataSet3_3;
                timeSlotGoalPowerList4 = dataSet3_4;

                myChart.tooltip.options.formatter = function () {
                    return '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S ', new Date(this.x))
                        + '<br/><span style="color:#438fd7">' + this.y + ' kW</span>';
                };

                // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                unit_format(String(totalUsage), "pastUseTot", "mW");
                $("#" + "totalGoalPower").empty().append($("<span/>").append(numberComma(totalGoalPower))).append("kW");
                $("#" + "totalCbl").empty().append($("<span/>").append(numberComma(totalCbl))).append("kW");
            }

            // 실시간 갱신 표 데이터
            function refreshSheetData(result) {
                var drList = result.drResultList;
                var totalReduceAmt = 0; // 전체 누적합

                $tbody = $("#drResultTbody");
                $tbody.empty();
                var tbodyStr = '';
                if (drList != null && drList.length > 0) {
                    for (var i = 0; i < drList.length; i++) {
                        var drStartDate = setSheetDateUTC(drList[i].request.start);
                        var drEndDate = setSheetDateUTC(drList[i].request.end);
                        tbodyStr += '<tr>';
                        tbodyStr += '<td>' + drStartDate.format("yyyy-MM-dd") + '</td>';
                        tbodyStr += '<td>' + drStartDate.format("HH:mm") + " ~ " + drEndDate.format("HH:mm") + '</td>';
                        tbodyStr += '<td>' + drList[i].actualAmount / 1000 + '</td>'; // 사용량
                        tbodyStr += '<td>' + drList[i].cblAmount / 1000 + '</td>'; // 고객기준부하
                        tbodyStr += '<td>' + (drList[i].cblAmount - goalPower) / 1000 + '</td>'; // 계약용량
                        tbodyStr += '<td>' + goalPower / 1000 + '</td>'; // 목표사용량
                        tbodyStr += '<td>' + (drList[i].cblAmount - drList[i].actualAmount) / 1000 + '</td>'; // 감축량
                        tbodyStr += '<td>' + (drList[i].cblAmount - drList[i].actualAmount) / (drList[i].cblAmount - goalPower) + '</td>'; // 이행률
                        tbodyStr += '</tr>';

                        totalReduceAmt = totalReduceAmt + Number(drList[i].cblAmount - drList[i].actualAmount);
                    }

                } else {
                    tbodyStr += '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>';
                }

                $tbody.html(tbodyStr);

                // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
                unit_format(String(totalReduceAmt), "totalReduceAmt", "Wh");

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
                            <h1 class="page-header">DR 실적 현황</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-2 use_total">
                            <div class="indiv">
                                <h2 class="ntit">DR 실적 합계</h2>
                                <ul class="chart_total">
                                    <li class="ct1">
                                        <div class="ctit ct1"><span>실제 사용량</span></div>
                                        <div class="cval" id="pastUseTot"><span>0</span>kWh</div>
                                    </li>
                                    <li class="ct3">
                                        <div class="ctit ct3"><span>기준부하</span></div>
                                        <div class="cval" id="totalCbl"><span>0</span>kWh</div>
                                    </li>
                                    <li class="ct2">
                                        <div class="ctit ct2"><span>목표 사용량</span></div>
                                        <div class="cval" id="totalGoalPower"><span>0</span>kWh</div>
                                    </li>
                                    <!-- <li>
                                        <div class="ctit"><span>감축량</span></div>
                                        <div class="cval" id="totalReduceAmt"><span>0</span>kWh</div>
                                    </li> -->
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-10">
                            <div class="indiv dr_chart">
                                <jsp:include page="../include/engy_monitoring_search.jsp">
                                    <jsp:param value="energy_drResult" name="schGbn"/>
                                </jsp:include>
                                <div class="inchart-nodata" style="display: none;">
                                    <span>조회 결과가 없습니다.</span>
                                </div>
                                <div class="inchart">
                                    <div id="chart2"></div>
                                    <script language="JavaScript">
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
// 										    min: 0, /* 최소값 지정 */
                                                title: {
                                                    text: '(kWh)',
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
                                                x: 0,
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
                                                name: '실제 사용량',
                                                color: '#438fd7' /* 실제 사용량 */
                                            }, {
                                                name: '기준부하',
                                                color: '#f75c4a',
                                            }, {
                                                name: '목표사용량',
                                                type: 'area',
                                                color: '#13af67' /* 목표 사용량 */
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
                    <div class="row dr_chart_table">
                        <div class="col-lg-12">
                            <div class="indiv">
                                <div class="tbl_top clear">
                                    <h2 class="ntit fl">DR 실적 도표</h2>
                                    <ul class="fr">
                                        <li><a href="#;" class="save_btn"
                                               onclick="excelDownload('DR실적', event, 'drResult');">데이터저장</a></li>
                                    </ul>
                                </div>
                                <div class="tbl_wrap">
                                    <div class="fold_div" id="pc_use_dataDiv">
                                        <!-- PC 버전용 테이블 -->
                                        <div class="chart_table">
                                            <table class="dr_use">
                                                <thead>
                                                    <tr>
                                                        <th>감축일</th>
                                                        <th>감축시간대</th>
                                                        <th>사용량(kWh)</th>
                                                        <th>고객기준부하(kWh)</th>
                                                        <th>계약용량(kWh)</th>
                                                        <th>목표사용량(kWh)</th>
                                                        <th>감축량(kWh)</th>
                                                        <th>이행률(%)</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="drResultTbody">
                                                    <tr>
                                                        <td colspan="8">조회된 데이터가 없습니다.</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
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