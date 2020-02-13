<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <jsp:include page="../include/common_static.jsp"/>
        <jsp:include page="../include/sub_static.jsp"/>
        <script src="../js/worker/worker.js" type="text/javascript"></script>
        <script type="text/javascript">
          let monitoring_cycle_10sec = null;
          let monitoring_cycle_1min = null;
          let monitoring_cycle_15min = null;
          let monitoring_cycle_1day = null;
          let formData = null;

          $(document).ready(() => {
            formData = getSiteMainSchCollection();

            fn_cycle_10sec();
            fn_cycle_1min();
            fn_cycle_15min();
            fn_cycle_1day();

            realTime_monitoring_start();

          });

          // 자동 새로고침(실시간 모니터링)
          const realTime_monitoring_start = () => {
            monitoring_cycle_10sec_start();
            monitoring_cycle_1min_start();
            monitoring_cycle_15min_start();
            monitoring_cycle_1day_start();
          };

          const monitoring_cycle_10sec_start = () => {
            if (monitoring_cycle_10sec == null) {
              monitoring_cycle_10sec = setInterval(() => {
                fn_cycle_10sec();
              }, 1000);
            } else {
              alert("10초 간격 모니터링이 이미 실행중입니다.");
            }
          };

          const monitoring_cycle_1min_start = () => {
            if (monitoring_cycle_1min == null) {
              monitoring_cycle_1min = setInterval(() => {
                fn_cycle_1min();
              }, 1000 * 60);
            } else {
              alert("1분 간격 모니터링이 이미 실행중입니다.");
            }
          };

          const monitoring_cycle_15min_start = () => {
            if (monitoring_cycle_15min == null) {
              monitoring_cycle_15min = setInterval(() => {
                fn_cycle_15min();
              }, 1000 * 60 * 15);
            } else {
              alert("15분 간격 모니터링이 이미 실행중입니다.");
            }
          };

          const monitoring_cycle_1day_start = () => {
            if (monitoring_cycle_1day == null) {
              monitoring_cycle_1day = setInterval(() => {
                fn_cycle_1day();
              }, 1000 * 60 * 60 * 24);
            } else {
              alert("1일 간격 모니터링이 이미 실행중입니다.")
            }
          };

          const monitoring_cycle_10sec_end = () => {
            clearInterval(monitoring_cycle_10sec);
            monitoring_cycle_10sec = null;
          };

          const monitoring_cycle_1min_end = () => {
            clearInterval(monitoring_cycle_1min);
            monitoring_cycle_1min = null;
          };

          const monitoring_cycle_15min_end = () => {
            clearInterval(monitoring_cycle_15min);
            monitoring_cycle_15min = null;
          };

          const monitoring_cycle_1day_end = () => {
            clearInterval(monitoring_cycle_1day);
            monitoring_cycle_1day = null;
          };

          const fn_cycle_10sec = () => {
            getPVAlarmList(formData);
          };

          const fn_cycle_1min = () => {
          };

          const fn_cycle_15min = () => {
            $(".updateTimePV").empty().append(new Date().format("yyyy-MM-dd HH:mm:ss"));
            // PV 발전량 조회
            getPVGenRealList(formData);
            // PV 예측 발전량 조회
            getPVGenFutureList(formData);
            // 오늘 PV 발전량 조회
            getPVGenRealListForToday(formData);
            // 이번 달 PV 발전량 조회
            getPVGenRealListForThisMonth(formData);
            // 이번 달 PV 발전량 일별 조회
            getPVGenRealListForThisMonthDaily(formData);
            // 지난 달 PV 발전량 조회
            getPVGenRealListForLastMonth(formData);
            // 올해 PV 발전량 조회
            getPVGenRealListForThisYear(formData);
            // 올해 PV 월별 발전량 조회
            getPVGenRealListForThisYearMonthly(formData);
            // 작년 PV 발전량 조회
            getPVGenRealListForLastYear(formData);
            // 장비별 최근 PV 발전량 리스트 조회
            getPVGenRealLatestListOfDevices(formData);
            // REC 현물 시장 현재 데이터 조회
            // getCurrentRECMarketPrice();
            // REC 발급 내역 데이터 조회
            getSiteRECIssued(formData);
            // REC 판매 내역 데이터 조회
            getSiteRECBook(formData);
            // 이번 달 미정산 REC 조회
            getIssuedRECInThisMonth(formData);
            // 오늘 정산 REC, 정산 금액 조회
            getSoldRECInThisDay(formData);
            // 이번 달 정산 REC, 정산 금액 조회
            getSoldRECInThisMonth(formData);
            // 직전 달 정산 REC, 정산 금액 조회
            getSoldRECInLastMonth(formData);
            // 올해 정산 REC, 정산 금액 조회
            getSoldRECInThisYear(formData);
            // 작년 정산 REC, 정산 금액 조회
            getSoldRECInLastYear(formData);
            // 올해 정산 REC, 정산 금액 월별 조회
            getSoldRECInThisYearMonthly(formData);
            // 오늘의 거래량 조회
            getTradingVolumeByDay(formData);
            // 오늘의 거래 가격 조회
            getTransactionPriceByDay(formData);
            // SMP 오늘의 시장가 조회
            getFixedSMPMarketPrice();
          };

          const fn_cycle_1day = () => {
            // PV 예측 날씨 데이터 조회
            getWeatherIconMonthly(formData);
          };

          const getSiteMainSchCollection = () => {
            $("#timeOffset").val(timeOffset);

            var firstDay = new Date();
            var endDay = new Date();
            var startTime;
            var endTime;
            startTime = new Date(firstDay.getFullYear(), firstDay.getMonth(), firstDay.getDate(), 0, 0, 0);
            endTime = new Date(endDay.getFullYear(), endDay.getMonth(), endDay.getDate(), 23, 59, 59);

            var queryStart = new Date(startTime.getTime());
            var queryEnd = new Date(endTime.getTime());
            queryStart = (queryStart === "") ? "" : queryStart.format("yyyyMMddHHmmss");
            queryEnd = (queryEnd === "") ? "" : queryEnd.format("yyyyMMddHHmmss");
            $("#selTermFrom").val(queryStart);
            $("#selTermTo").val(queryEnd);

            var monthFrom = new Date(firstDay.getFullYear(), firstDay.getMonth(), 1, 0, 0, 0);
            var monthTo = new Date(firstDay.getFullYear(), firstDay.getMonth(), (new Date(firstDay.getFullYear(), firstDay.getMonth(), 0)).getDate(), 23, 59, 59);
            var yearFrom = new Date(firstDay.getFullYear(), 0, 1, 0, 0, 0);
            var yearTo = new Date(firstDay.getFullYear(), 11, 31, 23, 59, 59);
            $("#monthFrom").val(monthFrom.format("yyyyMMddHHmmss"));
            $("#monthTo").val(monthTo.format("yyyyMMddHHmmss"));
            $("#yearFrom").val(yearFrom.format("yyyyMMddHHmmss"));
            $("#yearTo").val(yearTo.format("yyyyMMddHHmmss"));

            var frm = $("#schForm").serializeObject();
            return frm;
          };

          //PV 실제 발전량
          let pastPVGenList;
          let usage = null;
          let reUsage = null;
          let totalUsage = null;

          function callback_getPVGenRealList(result) {
            // Worker 지원 유무 확인
            // if (!!window.Worker) {
            //   startWorker(result, "pastPvGenList");
            // } else {
            const chartList = result.chartList;
            const periodd = $("#selPeriodVal").val(); // 데이터조회간격

            // 데이터 셋팅
            let dataSet = []; // chartData를 위한 변수
            let totalGen = 0; // 전체 누적합
            let map = null;

            // 차트데이터 셋팅
            if (chartList != null && chartList.length > 0) {
              for (let i = 0; i < chartList.length; i++) {
                usage = String(chartList[i].gen_val);
                reUsage = 0;
                if (isEmpty(usage) || usage === "null") {
                  reUsage = null;
                } else {
                  map = convertUnitFormat(usage, "Wh", 5);
                  reUsage = toFixedNum(map.get("formatNum"), 2);
                  totalUsage = totalUsage + Number(usage);
                }
                // 차트데이터 셋팅
                dataSet.push([setChartDateUTC(chartList[i].std_date), reUsage]);
              }
            }
            pastPVGenList = dataSet.map(e => {
              return e[1];
            });
            // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
            unit_format(String(totalUsage), "pastPvGenTot", "Wh");
            // }

          }

          // PV 예측 발전량
          let pred_PVGenList;
          let pred_usage = null;
          let pred_reUsage = null;
          let pred_totalUsage = null;

          function callback_getPVGenFutureList(result) {
            // // Worker 지원 유무 확인
            // if ( !!window.Worker ) {
            //   startWorker(result, "predictPvGenList");
            // } else {
            const chartList = result.chartList;
            const periodd = $("#selPeriodVal").val(); // 데이터조회간격
            // 데이터 셋팅
            let dataSet = []; // chartData를 위한 변수

            // 차트데이터 셋팅
            if (chartList != null && chartList.length > 0) {
              for (let i = 0; i < chartList.length; i++) {
                pred_usage = String(chartList[i].gen_val);
                pred_reUsage = 0;
                if (isEmpty(pred_usage) || pred_usage === "null") {
                  pred_reUsage = null;
                } else {
                  map = convertUnitFormat(pred_usage, "Wh", 5);
                  pred_reUsage = toFixedNum(map.get("formatNum"), 2);
                  pred_totalUsage = pred_totalUsage + Number(pred_usage);
                }
                // 차트데이터 셋팅
                dataSet.push([setChartDateUTC(chartList[i].std_date), pred_reUsage]);
              }
            }
            pred_PVGenList = dataSet.map(e => {
              return e[1];
            });
            // 총 합계(사용량, 발전량, 충전량, 방전량 등등)
            unit_format(String(pred_totalUsage), "feturePvGenTot", "Wh");
            // }
          }

          function callback_getPVGenRealListForToday(result) {
            $('#pv_gen_in_today').html(result + " kWh");
          }

          let PVGenRealListForThisMonth;

          function callback_getPVGenRealListForThisMonth(result) {
            PVGenRealListForThisMonth = result;
            $('#sum_pv_gen_for_this_month').html(result.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
          }

          function callback_getPVGenRealListForThisMonthDaily(result) {
            result.map(e => {
              $(`#${'${e.std_date}'}>div>div>span`).html(`${'${e.gen_val}'}`);
            })
          }

          let PVGenRealListForLastMonth;

          function callback_getPVGenRealListForLastMonth(result) {
            PVGenRealListForLastMonth = result;
          }

          let PVGenRealListForThisYear;

          function callback_getPVGenRealListForThisYear(result) {
            PVGenRealListForThisYear = result;
            $('#sum_pv_gen_for_this_year').html(result.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
          }

          function callback_getPVGenRealListForThisYearMonthly(result) {
            result.map((e, idx) => {
              $(`#income_datatable > tbody > tr:nth-child(${'${idx+1}'}) > td:nth-child(${'${idx+2}'})`).html(e.gen_val);
            })
          }

          let PVGenRealListForLastYear;

          function callback_getPVGenRealListForLastYear(result) {
            PVGenRealListForLastYear = result;
            changePVGen();
          }

          let PVGenRealLatestListOfDevices;

          function changePage(currentPageNum, pageRowCnt, deviceList) {

            const devices = JSON.parse(deviceList);
            const stringifiedDeviceList = JSON.stringify(deviceList);
            let totalPageCnt = Math.floor(devices.length / pageRowCnt) + 1;

            const $paging = $('#pvMain_device_paging');
            $paging.empty();

            if (currentPageNum > 1) {
              $("#selPageNum").val(currentPageNum - 1);
              $paging.append($('<a href=\'javascript:changePage(' + (currentPageNum - 1) + ',' + pageRowCnt + ',' + stringifiedDeviceList + ')\' class="prev" />').append("PREV"));
            } else {
              $paging.append($('<a href="#" class="prev" />').append("PREV"));
            }

            $paging.append(
              $('<span />').append($("<strong />").append(currentPageNum)).append(" / " + totalPageCnt)
            );

            if (currentPageNum < totalPageCnt) {
              $("#selPageNum").val(currentPageNum + 1);
              $paging.append($('<a href=\'javascript:changePage(' + (currentPageNum + 1) + ',' + pageRowCnt + ',' + stringifiedDeviceList + ')\' class="next" />').append("NEXT"));
            } else {
              $paging.append($('<a href="#" class="next" />').append("NEXT"));
            }

            devices.map((e, idx) => {
              if (idx >= (pageRowCnt * (currentPageNum - 1)) && idx < pageRowCnt * currentPageNum) {
                $(`#container-speed${'${idx}'}`).css("display", "block");
              } else {
                $(`#container-speed${'${idx}'}`).css("display", "none");
              }
              $(`#container-speed${'${idx}'}`).closest('.col-sm-4').css("min-height", "0");
            })
          };

          function callback_getPVGenRealLatestListOfDevices(result) {
            let deviceList = result;
            const pvMain_deviceList = $('.pvMain_deviceList');
            pvMain_deviceList.empty();

            deviceList.map((e, idx) => {
              const id = `container-speed${'${idx}'}`;
              pvMain_deviceList.append(`<div class="col-sm-4">
                                                <figure class="highcharts-figure">
                                                    <div id=${'${id}'} class="chart-container" style="display:none;"
                                                    ></div>
                                                </figure>
                                            </div>`
              );
              var gaugeOptions = {
                chart: {
                  type: 'solidgauge',
                  backgroundColor: 'transparent'
                },
                title: null,
                pane: {
                  center: ['50%', '85%'],
                  size: '100%',
                  startAngle: -90,
                  endAngle: 90,
                  background: {
                    backgroundColor:
                      Highcharts.defaultOptions.legend.backgroundColor || '#EEE',
                    innerRadius: '60%',
                    outerRadius: '100%',
                    shape: 'arc'
                  }
                },
                exporting: {
                  enabled: false
                },
                tooltip: {
                  enabled: false
                },
                // the value axis
                yAxis: {
                  stops: [
                    [0.1, '#13af67'], // green
                    [0.5, '#FBBC04'], // yellow
                    [0.9, '#f75c4a'] // red
                  ],
                  lineWidth: 0,
                  tickWidth: 0,
                  minorTickInterval: null,
                  tickAmount: 2,
                  title: {
                    y: -70,
                    style: {
                      fontSize: 20,
                      color: '#fff'
                    }
                  },
                  labels: {
                    y: 16,
                    distance: -6,
                    style: {
                      color: '#fff'
                    }
                  }
                },
                plotOptions: {
                  solidgauge: {
                    dataLabels: {
                      y: 20,
                      borderWidth: 0,
                      useHTML: false,
                      style: {
                        color: '#fff',
                        textAlign: 'center',
                      }
                    }
                  }
                },
              };
              // The speed gauge
              var chartSpeed = Highcharts.chart(`container-speed${'${idx}'}`, Highcharts.merge(gaugeOptions, {
                yAxis: {
                  min: 0,
                  max: 20,
                  x: 0,
                  title: {
                    text: `IVT ${'${e.device_id}'}`
                  }
                },
                credits: {
                  enabled: false
                },
                series: [{
                  name: 'Speed',
                  data: [e.gen_val],
                  dataLabels: {
                    format:
                      '<div style="text-align:center">' +
                      '<span class="gauge-data-label-num" style="font-size:14px; display:inline-block;">{y}</span><br/>' +
                      '<span class="gauge-data-label-text" style="font-size:8px; display:inline-block;">kW</span>' +
                      '</div>',
                    style: {textOutline: 'none'}
                  },
                  tooltip: {
                    valueSuffix: ' kW'
                  }
                }]
              }));
            });

            let pageRowCnt = 3;
            let $currentPageNum = Number($('#selPageNum').val());
            const deviceListString = JSON.stringify(deviceList);

            changePage($currentPageNum, pageRowCnt, deviceListString);

          }

          function callback_getDeviceList(result) {
            const deviceList = result.deviceList;
            const $pvMain_device = $(".pvMain_device");
            if (deviceList.length < 1) {
              $pvMain_device.find(".no-device").css("display", "");
              $pvMain_device.find(".gen").css("display", "none");
              $pvMain_device.find(".paging").css("display", "none");
            } else {
              $pvMain_device.find(".no-device").css("display", "none");
              $pvMain_device.find(".gen").css("display", "");
              $pvMain_device.find(".paging").css("display", "");
            }
          }

          let fixedSMPMarketPriceListOfMainland = [];
          let fixedSMPMarketPriceListOfJeju = [];

          function callback_getFixedSMPMarketPrice(result) {
            if (result[0] != null && result[1] != null) {
              result.filter(e => {
                for (const [key, value] of Object.entries(e)) {
                  if (key === 'KPX_SMP') {
                    fixedSMPMarketPriceListOfMainland = value.map(e => e.price);
                    const currentSMP = Math.floor(value[new Date().getHours()].price);
                    $(".mainland .currentSMP").html(Math.floor(currentSMP) + '원');
                    const highestSMP = Math.max(...fixedSMPMarketPriceListOfMainland);
                    $(".mainland .highestSMP").html(Math.floor(highestSMP) + '원');
                    const lowestSMP = Math.min(...fixedSMPMarketPriceListOfMainland);
                    $(".mainland .lowestSMP").html(Math.floor(lowestSMP) + '원');
                    const averageSMP = fixedSMPMarketPriceListOfMainland.reduce((a, b) => a + b, 0) / fixedSMPMarketPriceListOfMainland.length;
                    $(".mainland .averageSMP").html(Math.floor(averageSMP) + '원');
                  } else if (key === 'KPX_SMP_JEJU') {
                    const currentSMP = Math.floor(value[new Date().getHours()].price);
                    $(".jeju .currentSMP").html(Math.floor(currentSMP) + '원');
                    fixedSMPMarketPriceListOfJeju = value.map(e => e.price);
                    const highestSMP = Math.max(...fixedSMPMarketPriceListOfJeju);
                    $(".jeju .highestSMP").html(Math.floor(highestSMP) + '원');
                    const lowestSMP = Math.min(...fixedSMPMarketPriceListOfJeju);
                    $(".jeju .lowestSMP").html(Math.floor(lowestSMP) + '원');
                    const averageSMP = fixedSMPMarketPriceListOfJeju.reduce((a, b) => a + b, 0) / fixedSMPMarketPriceListOfJeju.length;
                    $(".jeju .averageSMP").html(Math.floor(averageSMP) + '원');
                  }
                }
              })
            }
          }

          let currentRECMarketPriceList = {};

          function callback_getCurrentRECMarketPrice(result) {
            currentRECMarketPriceList = result;
          }

          function callback_getSiteRECIssued(result) {
          }

          function callback_getSiteRECBook(result) {
            let sell_rec_num = 0;
            result[${selViewSiteId}].map(e => {
              sell_rec_num += e.sell_rec_num;
            });
            $('#sell_rec_num').html(sell_rec_num);
            let sell_rec_value = 0;
            result[${selViewSiteId}].map(e => {
              sell_rec_value += e.sell_rec_value;
            });
            const sell_rec_value_with_comma = sell_rec_value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            $('#sell_rec_value').html(sell_rec_value_with_comma);
          }

          let issuedRECInThisMonth;

          function callback_getIssuedRECInThisMonth(result) {
            $('#not_sell_rec_num').html(result);
            issuedRECInThisMonth = result;
          }

          let sellRecNumInThisDay;
          let sellRecValueInThisDay;

          function callback_getSoldRECInThisDay(result) {
            result.map(e => {
              if (e) {
                sellRecNumInThisMonth = e.sell_rec_num;
                sellRecValueInThisMonth = e.sell_rec_value;
              }
            });
          }

          let sellRecNumInThisMonth;
          let sellRecValueInThisMonth;

          function callback_getSoldRECInThisMonth(result) {
            result.map(e => {
              if (e) {
                sellRecNumInThisMonth = e.sell_rec_num;
                sellRecValueInThisMonth = e.sell_rec_value;
              }
            });
          }

          let sellRecNumInLastMonth;
          let sellRecValueInLastMonth;

          function callback_getSoldRECInLastMonth(result) {
            result.map(e => {
              sellRecNumInLastMonth = e.sell_rec_num;
              sellRecValueInLastMonth = e.sell_rec_value;
            });
          }

          let sellRecNumInThisYear;
          let sellRecValueInThisYear;

          function callback_getSoldRECInThisYear(result) {
            result.map(e => {
              sellRecNumInThisYear = e.sell_rec_num;
              sellRecValueInThisYear = e.sell_rec_value;
            });
          }

          let sellRecNumInLastYear;
          let sellRecValueInLastYear;

          function callback_getSoldRECInLastYear(result) {
            result.map(e => {
              sellRecNumInLastYear = e.sell_rec_num;
              sellRecValueInLastYear = e.sell_rec_value;
            });
          }

          function callback_getSoldRECInThisYearMonthly(result) {
          }

          let tradingVolumeByDay = [];

          function callback_getTradingVolumeByDay(result) {
            if (tradingVolumeByDay) {
              tradingVolumeByDay = [];
            }
            result.map(e => {
              tradingVolumeByDay = [...tradingVolumeByDay, Object.values(e)];
            });
          }

          let transactionPriceByDay = [];

          function callback_getTransactionPriceByDay(result) {
            if (transactionPriceByDay) {
              transactionPriceByDay = [];
            }
            result.map(e => {
              transactionPriceByDay = [...transactionPriceByDay, Object.values(e)];
            });
          }

          function callback_getPVAlarmList(result) {
            var dvTpAlarmDetail = result.detail;
            var dvTpAlarmDetail2 = result.detail2;
            var alarmList = result.alarmList;

            $("#todayTotalAlarmCnt").html(dvTpAlarmDetail.total_cnt);
            $("#todayAlarmCnt").html(dvTpAlarmDetail2.alert_cnt);
            $("#todayWarninfCnt").html(dvTpAlarmDetail2.warning_cnt);
            if (dvTpAlarmDetail.notCfm_cnt === 0) {
              $(".no").find('span').hide();
            } else {
              var $no = $(".no");
              $no.find('span').show();
              $no.empty().append('<span>' + dvTpAlarmDetail.notCfm_cnt + '</span>');
            }

            var str = "";
            if (alarmList == null || alarmList.length < 1) {
              str += '<li>';
              str += '	<a href="#;"><spring:message code="ewp.main.There_is_no_query_results" /></a>';
              str += '</li>';
            } else {
              for (var i = 0; i < alarmList.length; i++) {
                var tm = new Date(convertDateUTC(alarmList[i].std_date));
                str += '<li>';
                str += '	<a href="#;">' + alarmList[i].alarm_msg + '</a>';
                str += '	<span>' + tm.format("yyyy-MM-dd HH:mm:ss") + '</span>';
                str += '</li>';
              }
              $(".alarm_notice").find("ul").html(str);
            }

          }

          function callback_getWeatherInfo(result) {
            let skycons = new Skycons({"color": "white"});
            const current_date = new Date();
            const cday = current_date.getDay();
            const days = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
            result.map((e, idx) => {
              skycons.add(`${'${days[idx]}'}`, Skycons[`${'${e.icon.toUpperCase().replace(/-/g,"_")}'}`]);
              if (idx === cday) {
                $(`#${'${days[idx]}'}_generated_hour`).closest('.day').addClass('today');
              }
            });
            // start icon animation!
            skycons.play();
          }

          function callback_getWeatherIconMonthly(result) {
            let skycons = new Skycons({"color": "white"});
            result.map(e => {
              skycons.add(`${'${e.time}icon'}`, Skycons[`${'${e.icon.toUpperCase().replace(/-/g,"_")}'}`]);
            })
            skycons.play();
          }

          function callback_getGeneratedHour(result) {
            const days = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
            result.map((e, idx) => {
              if (e) {
                $(`#${'${days[idx]}'}_generated_hour`).html(e.generated_hour + ' H');
              }
            })
          }

          function changeEarnings() {
            $('#sum_earnings_for_this_month').html((sellRecValueInThisMonth + SMPEarningsForThisMonth).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
            $('#sum_earnings_for_this_year').html((sellRecValueInThisYear + SMPEarningsForThisYear).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
            //지난 달과 이번 달의 REC 수익 격차
            if ((sellRecValueInLastMonth - sellRecValueInThisMonth) > 0) {
              $('#REC_earnings_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-bottom');
              $('#REC_earnings_increase_for_this_month').html('(' + (Math.abs(sellRecValueInLastMonth - sellRecValueInThisMonth)).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            } else {
              $('#REC_earnings_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-top');
              $('#REC_earnings_increase_for_this_month').html('(' + (Math.abs(sellRecValueInLastMonth - sellRecValueInThisMonth)).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            }
            //지난 달과 이번 달의 SMP 수익 격차
            if ((SMPEarningsForLastMonth - SMPEarningsForThisMonth) > 0) {
              $('#SMP_earnings_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-bottom');
              $('#SMP_earnings_increase_for_this_month').html('(' + (Math.abs(SMPEarningsForLastMonth - SMPEarningsForThisMonth)).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            } else {
              $('#SMP_earnings_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-top');
              $('#SMP_earnings_increase_for_this_month').html('(' + (Math.abs(SMPEarningsForLastMonth - SMPEarningsForThisMonth)).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            }
            //지난 달과 이번 달의 총 수익 격차
            if ((sellRecValueInLastMonth + SMPEarningsForLastMonth) - (sellRecValueInThisMonth + SMPEarningsForThisMonth) > 0) {
              $('#sum_earnings_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-bottom');
              $('#sum_earnings_increase_for_this_month').html('(' + (Math.abs((sellRecValueInLastMonth + SMPEarningsForLastMonth) - (sellRecValueInThisMonth + SMPEarningsForThisMonth))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            } else {
              $('#sum_earnings_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-top');
              $('#sum_earnings_increase_for_this_month').html('(' + (Math.abs((sellRecValueInLastMonth + SMPEarningsForLastMonth) - (sellRecValueInThisMonth + SMPEarningsForThisMonth))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            }
            //작년과 올해의 수익 격차
            if (((sellRecValueInLastYear + SMPEarningsForLastYear) - (sellRecValueInThisYear + SMPEarningsForThisYear)) > 0) {
              $('#sum_earnings_increase_for_this_year').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-bottom');
              $('#sum_earnings_increase_for_this_year').html('(' + (Math.abs((sellRecValueInLastYear + SMPEarningsForLastYear) - (sellRecValueInThisYear + SMPEarningsForThisYear))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            } else {
              $('#sum_earnings_increase_for_this_year').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-top');
              $('#sum_earnings_increase_for_this_year').html('(' + (Math.abs((sellRecValueInLastYear + SMPEarningsForLastYear) - (sellRecValueInThisYear + SMPEarningsForThisYear))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            }
          }

          function changePVGen() {
            //지난 달과 이번 달의 총 발전량 격차
            if ((PVGenRealListForLastMonth - PVGenRealListForThisMonth) > 0) {
              $('#sum_pv_gen_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-bottom');
              $('#sum_pv_gen_increase_for_this_month').html('(' + (Math.abs((PVGenRealListForLastMonth - PVGenRealListForThisMonth))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            } else {
              $('#sum_pv_gen_increase_for_this_month').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-top');
              $('#sum_pv_gen_increase_for_this_month').html('(' + (Math.abs((PVGenRealListForLastMonth - PVGenRealListForThisMonth))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            }
            //작년과 올해의 발전량 격차
            if ((PVGenRealListForLastYear - PVGenRealListForThisYear) > 0) {
              $('#sum_pv_gen_increase_for_this_year').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-bottom');
              $('#sum_pv_gen_increase_for_this_year').html('(' + (Math.abs((PVGenRealListForLastYear - PVGenRealListForThisYear))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            } else {
              $('#sum_pv_gen_increase_for_this_year').removeClass('glyphicon-triangle-top').removeClass('glyphicon-triangle-bottom').addClass('glyphicon-triangle-top');
              $('#sum_pv_gen_increase_for_this_year').html('(' + (Math.abs((PVGenRealListForLastYear - PVGenRealListForThisYear))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ')');
            }
          }
        </script>
    </head>
    <body>

        <!-- 메인페이지용 스타일 파일 -->
        <link href="../css/main.css" rel="stylesheet">

        <div id="wrapper">
            <jsp:include page="../include/layout/sidebar.jsp">
                <jsp:param value="siteMain" name="linkGbn"/>
            </jsp:include>
            <div id="page-wrapper">
                <jsp:include page="../include/layout/header.jsp"/>
                <div id="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header">KTS빌딩 9층</h1>
                        </div>
                    </div>
                    <form id="schForm" name="schForm" action="">
                        <input type="hidden" id="selTermFrom" name="selTermFrom">
                        <input type="hidden" id="selTermTex" name="selTermTex">
                        <input type="hidden" id="selTermTo" name="selTermTo">
                        <input type="hidden" id="selTerm" name="selTerm" value="today">
                        <input type="hidden" id="selPeriodVal" name="selPeriodVal" value="hour">
                        <input type="hidden" id="siteId" name="siteId" value="${selViewSiteId}">
                      <input type="hidden" id="selPageNum" name="selPageNum" value="1">
                        <input type="hidden" id="timeOffset" name="timeOffset">
                        <input type="hidden" id="monthFrom" name="monthFrom">
                        <input type="hidden" id="monthTo" name="monthTo">
                        <input type="hidden" id="yearFrom" name="yearFrom">
                        <input type="hidden" id="yearTo" name="yearTo">
                    </form>
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="indiv income">
                                        <div class="chart_top clear">
                                          <h2 class="ntit fl">월별 PV 발전량 종합</h2>
                                          <div class="time fr updateTimePV">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="inchart">
                                            <div id="income_chart" style="height:332px;"></div>
                                            <script language="JavaScript">
                                              $(function () {
                                                var incomeChart = Highcharts.chart('income_chart', {
                                                  data: {
                                                    table: 'income_datatable' /* 테이블에서 데이터 불러오기 */
                                                  },

                                                  chart: {
                                                    marginTop: 50,
                                                    marginLeft: 50,
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
                                                    labels: {
                                                      align: 'center',
                                                      y: 27, /* 그래프와 거리 */
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      }
                                                    },
                                                    tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                                                    title: {
                                                      text: null
                                                    }
                                                  },

                                                  yAxis: {
                                                    gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                                                    min: 0, /* 최소값 지정 */
                                                    title: {
                                                      text: '(kWh)',
                                                      align: 'low',
                                                      rotation: 0, /* 타이틀 기울기 */
                                                      y: 25, /* 타이틀 위치 조정 */
                                                      x: 5,
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      }
                                                    },
                                                    labels: {
                                                      overflow: 'justify',
                                                      x: -10, /* 그래프와의 거리 조정 */
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      }
                                                    }
                                                  },

                                                  /* 범례 */
                                                  legend: {
                                                    enabled: true,
                                                    align: 'right',
                                                    verticalAlign: 'top',
                                                    x: 18,
                                                    y: 0,
                                                    itemStyle: {
                                                      color: '#fff',
                                                      fontSize: '12px',
                                                      fontWeight: 400
                                                    },
                                                    itemHoverStyle: {
                                                      color: '' /* 마우스 오버시 색 */
                                                    },
                                                    symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
                                                    symbolHeight: 7 /* 심볼 크기 */
                                                  },

                                                  /* 툴팁 */
                                                  tooltip: {
                                                    formatter: function () {
                                                      return '<b>' + this.series.name + '</b><br/>' + this.x + '월' + '<br/><span style="color:#438fd7">' + this.y + ' kWh</span>';
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
                                                      stacking: 'normal' /*위로 쌓이는 막대  ,normal */
                                                    }
                                                  },

                                                  /* 출처 */
                                                  credits: {
                                                    enabled: false
                                                  },

                                                  /* 그래프 스타일 */
                                                  series: [{
                                                    color: '#ED7217' /* 발전량 */
                                                  }]

                                                });
                                              });
                                            </script>
                                            <!-- 데이터 추출용 -->
                                            <div class="chart_table2" style="display:none;">
                                                <table id="income_datatable">
                                                    <thead>
                                                        <tr>
                                                            <th></th>
                                                          <th>PV 발전량</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <th>1</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>2</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>3</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>4</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>5</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>6</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>7</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>8</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>9</th>
                                                          <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>10</th>
                                                            <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>11</th>
                                                            <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>12</th>
                                                            <td>0</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="chart_footer">
                                            <ul class="clear">
                                              <li>이번달 총 발전량: <span id="sum_pv_gen_for_this_month">1,500</span> kWh
                                                <i
                                                    class="glyphicon glyphicon-triangle-bottom"
                                                    id="sum_pv_gen_increase_for_this_month"
                                                    style="color:#438fd7">(150)</i></li>
                                              <li>올해 누적 발전량: <span id="sum_pv_gen_for_this_year">15,121,231</span>
                                                kWh
                                                <i
                                                    class="glyphicon glyphicon-triangle-top"
                                                    id="sum_pv_gen_increase_for_this_year"
                                                    style="color:#f75c4a">(12,405)</i>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                          <div class="row">
                            <div class="col-sm-12">
                              <div class="indiv">
                                <div class="chart_top clear">
                                  <h2 class="ntit fl">이 달의 발전 달력</h2>
                                  <div class="time fr updateTimePV">2018-08-12 11:41:26</div>
                                </div>
                                <div id="PVGenCalendar" class="calendar" style="height:450px;"></div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="indiv">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">오늘의 태양광 사업</h2>
                                          <div class="time fr updateTimePV">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="chart_header">
                                            <ul class="clear">
                                              <li>누적 발전량: <span id="pv_gen_in_today">0 kWh</span></li>
                                              <li>SMP 수익: <span id="SMP_earnings_in_today">0 원</span></li>
                                              <li>REC: <span id="REC_earnings_in_today">0 개</span></li>
                                            </ul>
                                        </div>
                                        <div class="area_chart">
                                            <div id="PV_today" style="height:180px;"></div>
                                            <script language="JavaScript">
                                              $(function () {
                                                var PV_today = Highcharts.chart('PV_today', {
                                                  chart: {
                                                    type: 'area',
                                                    backgroundColor: 'transparent'
                                                  },
                                                  accessibility: {
                                                    description: ''
                                                  },
                                                  title: {
                                                    text: ''
                                                  },
                                                  subtitle: {
                                                    text: ''
                                                  },
                                                  navigation: {
                                                    buttonOptions: {
                                                      enabled: false /* 메뉴 안보이기 */
                                                    }
                                                  },
                                                  legend: {
                                                    enabled: true,
                                                    align: 'right',
                                                    verticalAlign: 'top',
                                                    x: 0,
                                                    y: 0,
                                                    itemStyle: {
                                                      color: '#fff',
                                                      fontSize: '12px',
                                                      fontWeight: 400
                                                    },
                                                    itemHoverStyle: {
                                                      color: '' /* 마우스 오버시 색 */
                                                    },
                                                    symbolPadding: 5, /* 심볼 - 텍스트간 거리 */
                                                    symbolHeight: 7 /* 심볼 크기 */
                                                  },
                                                  xAxis: {
                                                    labels: {
                                                      align: 'center',
                                                      y: 30, /* 그래프와 거리 */
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      }
                                                    },
                                                    tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                                                    title: {
                                                      text: null
                                                    },
                                                    allowDecimals: false,
                                                    // labels: {
                                                    //   formatter: function () {
                                                    //     return this.value; // clean, unformatted number for year
                                                    //   }
                                                    // },
                                                    // accessibility: {
                                                    //   rangeDescription: ''
                                                    // }
                                                  },
                                                  yAxis: {
                                                    gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                                                    min: 0, /* 최소값 지정 */
                                                    title: {
                                                      text: '(kW)',
                                                      align: 'low',
                                                      rotation: 0, /* 타이틀 기울기 */
                                                      y: 30, /* 타이틀 위치 조정 */
                                                      x: 5,
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      }
                                                    },
                                                    labels: {
                                                      overflow: 'justify',
                                                      x: -5, /* 그래프와의 거리 조정 */
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      },
                                                      formatter: function () {
                                                        return this.value;
                                                      }
                                                    }
                                                  },
                                                  tooltip: {
                                                    pointFormat: '{series.name} had stockpiled <b>{point.y:,.0f}</b><br/>warheads in {point.x}'
                                                  },
                                                  credits: {
                                                    enabled: false
                                                  },
                                                  plotOptions: {
                                                    area: {
                                                      marker: {
                                                        enabled: false,
                                                        symbol: 'circle',
                                                        radius: 2,
                                                        states: {
                                                          hover: {
                                                            enabled: true
                                                          }
                                                        }
                                                      }
                                                    },
                                                    series: {
                                                      pointStart: 1,
                                                    }
                                                  },
                                                  series: [{
                                                    name: '예상',
                                                    data: pred_PVGenList,
                                                    color: '#438fd7',
                                                  }, {
                                                    name: '실제',
                                                    data: pastPVGenList,
                                                    color: '#f75c4a'
                                                  }]
                                                });
                                              })
                                            </script>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="indiv">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">오늘의 가격정보 (SMP)</h2>
                                          <div class="time fr updateTimePV">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="chart_header">
                                            <div class="mainland_container">
                                                <span>육지</span>
                                                <ul class="clear mainland">
                                                    <li>현재: <span class="currentSMP">80 원</span></li>
                                                    <li>평균: <span class="averageSMP">78 원</span></li>
                                                    <li>최고: <span class="highestSMP">110 원</span></li>
                                                    <li>최저: <span class="lowestSMP">62 원</span></li>
                                                </ul>
                                            </div>
                                            <div class="jeju_container">
                                                <span>제주</span>
                                                <ul class="clear jeju">
                                                    <li>현재: <span class="currentSMP">80 원</span></li>
                                                    <li>평균: <span class="averageSMP">78 원</span></li>
                                                    <li>최고: <span class="highestSMP">110 원</span></li>
                                                    <li>최저: <span class="lowestSMP">62 원</span></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="line_chart">
                                            <div id="PV_todaySMP" style="height:180px;"></div>
                                            <script language="JavaScript">
                                              $(function () {
                                                var PV_todaySMP = Highcharts.chart('PV_todaySMP', {
                                                  chart: {
                                                    type: 'line',
                                                    backgroundColor: 'transparent'
                                                  },
                                                  accessibility: {
                                                    description: ''
                                                  },
                                                  title: {
                                                    text: ''
                                                  },
                                                  subtitle: {
                                                    text: ''
                                                  },
                                                  navigation: {
                                                    buttonOptions: {
                                                      enabled: false /* 메뉴 안보이기 */
                                                    }
                                                  },
                                                  legend: {
                                                    enabled: true,
                                                    align: 'right',
                                                    verticalAlign: 'top',
                                                    x: 0,
                                                    y: 0,
                                                    itemStyle: {
                                                      color: '#fff',
                                                      fontSize: '12px',
                                                      fontWeight: 400
                                                    },
                                                    itemHoverStyle: {
                                                      color: '' /* 마우스 오버시 색 */
                                                    },
                                                    symbolPadding: 0, /* 심볼 - 텍스트간 거리 */
                                                    symbolHeight: 7 /* 심볼 크기 */
                                                  },
                                                  xAxis: {
                                                    labels: {
                                                      align: 'center',
                                                      y: 30, /* 그래프와 거리 */
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      }
                                                    },
                                                    tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                                                    title: {
                                                      text: null
                                                    },
                                                    allowDecimals: false,
                                                    // labels: {
                                                    //   formatter: function () {
                                                    //     return this.value; // clean, unformatted number for year
                                                    //   }
                                                    // },
                                                    // accessibility: {
                                                    //   rangeDescription: ''
                                                    // }
                                                  },
                                                  yAxis: {
                                                    gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                                                    min: 50, /* 최소값 지정 */
                                                    title: {
                                                      text: '(원)',
                                                      align: 'low',
                                                      rotation: 0, /* 타이틀 기울기 */
                                                      y: 30, /* 타이틀 위치 조정 */
                                                      x: 5,
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      }
                                                    },
                                                    labels: {
                                                      overflow: 'justify',
                                                      x: -5, /* 그래프와의 거리 조정 */
                                                      style: {
                                                        color: '#fff',
                                                        fontSize: '12px'
                                                      },
                                                      formatter: function () {
                                                        return this.value;
                                                      }
                                                    }
                                                  },
                                                  tooltip: {
                                                    pointFormat: '{series.name} had stockpiled <b>{point.y:,.0f}</b><br/>warheads in {point.x}'
                                                  },
                                                  credits: {
                                                    enabled: false
                                                  },
                                                  plotOptions: {
                                                    series: {
                                                      pointStart: 1,
                                                      events: {
                                                        legendItemClick: () => false
                                                      }
                                                    }
                                                  },
                                                  series: [{
                                                    name: '육지',
                                                    data: fixedSMPMarketPriceListOfMainland,
                                                    color: '#FBBC04',
                                                  }, {
                                                    name: '제주',
                                                    data: fixedSMPMarketPriceListOfJeju,
                                                    color: '#13af67',
                                                  }]
                                                });
                                              })
                                            </script>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="indiv">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">REC 시장 현황</h2>
                                            <div class="market fl">폐장</div>
                                            <div class="market active fl">개장</div>
                                          <div class="time fr updateTimePV">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="line_chart">
                                            <div id="PV_market_status" style="height:400px;"></div>
                                            <script language="JavaScript">
                                              $(function () {
                                                var PV_todaySMP = Highcharts.getJSON('js/PV_market_status_dummy.json', function (data) {
                                                  // create the chart
                                                  Highcharts.stockChart('PV_market_status', {
                                                    chart: {
                                                      backgroundColor: 'transparent',
                                                      style: {
                                                        fontFamily: '\'Unica One\', sans-serif'
                                                      },
                                                      plotBorderColor: '#606063'
                                                    },
                                                    title: {
                                                      text: ''
                                                    },
                                                    xAxis: {
                                                      gridLineColor: '#707073',
                                                      labels: {
                                                        style: {
                                                          color: '#E0E0E3'
                                                        }
                                                      },
                                                      lineColor: '#707073',
                                                      minorGridLineColor: '#505053',
                                                      tickColor: '#707073',
                                                      title: {
                                                        style: {
                                                          color: '#A0A0A3'
                                                        }
                                                      }
                                                    },
                                                    yAxis: [{ //left y axis
                                                      opposite: false,
                                                      min: 0,
                                                      gridLineColor: '#707073',
                                                      labels: {
                                                        align: 'left',
                                                        x: 0,
                                                        y: 0,
                                                        style: {
                                                          color: '#E0E0E3'
                                                        }
                                                      },
                                                      lineColor: '#707073',
                                                      minorGridLineColor: '#505053',
                                                      tickColor: '#707073',
                                                      tickWidth: 1,
                                                      title: {
                                                        text: "Trading volume",
                                                        style: {
                                                          color: '#A0A0A3'
                                                        }
                                                      }
                                                    }, { // right y axis
                                                      linkedTo: 0,
                                                      gridLineWidth: 0,
                                                      opposite: true,
                                                      gridLineColor: '#707073',
                                                      labels: {
                                                        align: 'right',
                                                        x: 0,
                                                        y: 0,
                                                        style: {
                                                          color: '#E0E0E3'
                                                        }
                                                      },
                                                      lineColor: '#707073',
                                                      minorGridLineColor: '#505053',
                                                      tickColor: '#707073',
                                                      tickWidth: 1,
                                                      title: {
                                                        text: "Transaction price",
                                                        style: {
                                                          color: '#A0A0A3'
                                                        }
                                                      }
                                                    }],
                                                    plotOptions: {
                                                      series: {
                                                        dataLabels: {
                                                          color: '#F0F0F3',
                                                          style: {
                                                            fontSize: '13px'
                                                          }
                                                        },
                                                        marker: {
                                                          lineColor: '#333'
                                                        }
                                                      },
                                                      boxplot: {
                                                        fillColor: '#505053',
                                                      },
                                                      candlestick: {
                                                        lineColor: '#fff',
                                                        color: '#f75c4a',
                                                        upColor: 'green',
                                                      },
                                                      errorbar: {
                                                        color: '#fff'
                                                      }
                                                    },
                                                    legend: {
                                                      enabled: true,
                                                      align: 'right',
                                                      verticalAlign: 'top',
                                                      x: 0,
                                                      y: 0,
                                                      itemStyle: {
                                                        color: '#E0E0E3',
                                                        fontSize: '12px',
                                                        fontWeight: 400
                                                      },
                                                      itemHoverStyle: {
                                                        color: '#FFF' /* 마우스 오버시 색 */
                                                      },
                                                      itemHiddenStyle: {
                                                        color: '#606063'
                                                      },
                                                      title: {
                                                        style: {
                                                          color: '#C0C0C0'
                                                        }
                                                      },
                                                      symbolPadding: 5, /* 심볼 - 텍스트간 거리 */
                                                      symbolHeight: 7 /* 심볼 크기 */
                                                    },
                                                    navigation: {
                                                      buttonOptions: {
                                                        enabled: false /* 메뉴 안보이기 */
                                                      }
                                                    },
                                                    credits: {
                                                      enabled: false
                                                    },
                                                    labels: {
                                                      style: {
                                                        color: '#707073'
                                                      }
                                                    },
                                                    drilldown: {
                                                      activeAxisLabelStyle: {
                                                        color: '#F0F0F3'
                                                      },
                                                      activeDataLabelStyle: {
                                                        color: '#F0F0F3'
                                                      }
                                                    },
                                                    // scroll charts
                                                    rangeSelector: {
                                                      selected: 1,
                                                      enabled: false,
                                                      buttonTheme: {
                                                        fill: '#505053',
                                                        stroke: '#000000',
                                                        style: {
                                                          color: '#CCC'
                                                        },
                                                        states: {
                                                          hover: {
                                                            fill: '#707073',
                                                            stroke: '#000000',
                                                            style: {
                                                              color: 'white'
                                                            }
                                                          },
                                                          select: {
                                                            fill: '#333',
                                                            stroke: '#000000',
                                                            style: {
                                                              color: 'white'
                                                            }
                                                          }
                                                        }
                                                      },
                                                      inputBoxBorderColor: '#505053',
                                                      inputStyle: {
                                                        backgroundColor: '#333',
                                                        color: 'silver'
                                                      },
                                                      labelStyle: {
                                                        color: 'silver'
                                                      }
                                                    },
                                                    navigator: {
                                                      enabled: false,
                                                      handles: {
                                                        backgroundColor: '#666',
                                                        borderColor: '#AAA'
                                                      },
                                                      outlineColor: '#CCC',
                                                      maskFill: 'rgba(255,255,255,0.1)',
                                                      series: {
                                                        color: '#7798BF',
                                                        lineColor: '#A6C7ED'
                                                      },
                                                      xAxis: {
                                                        gridLineColor: '#505053'
                                                      }
                                                    },
                                                    scrollbar: {
                                                      barBackgroundColor: '#808083',
                                                      barBorderColor: '#808083',
                                                      buttonArrowColor: '#CCC',
                                                      buttonBackgroundColor: '#606063',
                                                      buttonBorderColor: '#606063',
                                                      rifleColor: '#FFF',
                                                      trackBackgroundColor: '#404043',
                                                      trackBorderColor: '#404043'
                                                    },
                                                    series: [{
                                                      type: 'line',
                                                      name: '거래량',
                                                      data: tradingVolumeByDay,
                                                      dataGrouping: {
                                                        units: [
                                                          [
                                                            'hour', // unit name
                                                            [1] // allowed multiples
                                                          ],
                                                          // [
                                                          //   'week',
                                                          //   [1,2,3,4,6]
                                                          // ]
                                                          // [
                                                          //   'month',
                                                          //   [1,2,3,4,6]
                                                          // ]
                                                        ]
                                                      },
                                                      color: '#438fd7'
                                                    }, {
                                                      type: 'candlestick',
                                                      name: '실거래가',
                                                      data: transactionPriceByDay,
                                                      dataGrouping: {
                                                        units: [
                                                          [
                                                            'hour', // unit name
                                                            [1] // allowed multiples
                                                          ],
                                                          // [
                                                          //   'week',
                                                          //   [1,2,3,4,6]
                                                          // ]
                                                          // [
                                                          //   'month',
                                                          //   [1,2,3,4,6]
                                                          // ]
                                                        ]
                                                      },
                                                      color: '#f75c4a'
                                                    }]
                                                  });
                                                });
                                              })
                                            </script>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="indiv alarm">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl" ondblclick="location.href='/control'"
                                                style="cursor: pointer;">
                                                <spring:message code="ewp.main.Alarm" /><!-- 알람 --></h2>
                                            <div class="fr today_alarm">
                                                <div class="total">
                                                    <spring:message code="ewp.main.Occurence_today" /><!-- 금일발생 -->
                                                    <span id="todayTotalAlarmCnt">0</span></div>
                                                <div class="no"><span style="display: none;">0</span></div>
                                            </div>
                                        </div>
                                        <!-- no-data { -->
                                        <div class="no-data" style="display: none;">
                                            <span><spring:message code="ewp.site.Cannot_alarm_information" /><!-- 알람 정보를 가져올 수 없습니다. --></span>
                                        </div>
                                        <!-- } no-data -->
                                        <div class="alarm_stat mt10 clear">
                                            <div class="a_alert clear">
                                                <span>ALERT</span> <em id="todayAlarmCnt">0</em>
                                            </div>
                                            <div class="a_warning clear">
                                                <span>WARNING</span> <em id="todayWarninfCnt">0</em>
                                            </div>
                                        </div>
                                        <div class="alarm_notice">
                                            <h2><spring:message code="ewp.main.Recent_alarms" /><!-- 최근 알람 --></h2>
                                            <ul>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                  <div class="col-sm-12 indiv pvMain_device">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">현재 발전 현황</h2>
                                          <div class="time fr updateTimePV">2018-08-12 11:41:26</div>
                                        </div>
                                    <!-- no-data { -->
                                    <div class="col-sm-12 no-device" style="display: none;">
                                      <div>
                                        <image src="../img/icon_nodata.png"></image>
                                      </div>
                                      <span><spring:message code="ewp.site.Cannot_device_status_information" /><!-- 발전현황 정보를 가져올 수 없습니다. --></span>
                                    </div>
                                    <!-- } no-data -->
                                    <div class="col-sm-12 pvMain_deviceList">
                                    </div>
                                    <div class="paging clear" id="pvMain_device_paging">
                                            <a href="#;" class="prev">PREV</a>
                                            <span><strong>1</strong> / 3</span>
                                            <a href="#;" class="next">NEXT</a>
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
  <script type="text/javascript">
    (function makePVCalendar() {
      //https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Date
      const today = new Date();
      const setCalendarData = (year, month) => {
        let calHtml = "";
        //getMonth(): Get the month as a number (0-11)
        //0부터 시작하므로 현재 달에서 -1한 값이 Date 객체의 현재 달
        const setDate = new Date(year, month - 1, 1);
        //getDate(): Get the day as a number (1-31)
        const firstDay = setDate.getDate();
        //getDay(): Get the weekday as a number (0-6)
        const firstDayName = setDate.getDay();
        //new Date(today.getFullYear(), today.getMonth(), 0); => 지난달 마지막 날
        //new Date(today.getFullYear(), today.getMonth(), 1); => 이번달 1일
        //+1로 다음 달을 넣고, day에 0을 넣으면 현재 달의 마지막 날짜가 나옴.
        const lastDay = new Date(
          today.getFullYear(),
          today.getMonth() + 1,
          0
        ).getDate();
        //현재 달을 넣고, day에 0을 넣으면 이전 달의 마지막 날짜가 나옴.
        const prevLastDay = new Date(
          today.getFullYear(),
          today.getMonth(),
          0
        ).getDate();

        let startDayCount = 1;
        let lastDayCount = 1;

        //1~6주차
        for (let i = 0; i < 6; i++) {
          //일요일~월요일
          for (let j = 0; j < 7; j++) {
            // i == 0: 1주차일 때
            // j == firstDayName: 이번 달 시작 요일일 때
            if (i == 0 && j == firstDayName) {
              //일요일일 때, 토요일일 때, 나머지 요일 일 때
              if (j == 0) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day horizontalGutter'><span class='calendar__dayNum'>" +
                  startDayCount +
                  "</span><canvas class='calendar__weatherIcon' id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount++) +
                  "icon" +
                  "'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              } else if (j == 6) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day'><span class='calendar__dayNum'>" +
                  startDayCount +
                  "</span><canvas class='calendar__weatherIcon' id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount++) +
                  "icon" +
                  "'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              } else {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day horizontalGutter'><span class='calendar__dayNum'>" +
                  startDayCount +
                  "</span><canvas class='calendar__weatherIcon' id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount++) +
                  "icon" +
                  "'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              }
              // i == 0: 1주차일 때
              // j < firstDayName: 이번 달 시작 요일 이전 일 때
            } else if (i == 0 && j < firstDayName) {
              //일요일일 때, 토요일일 때, 나머지 요일 일 때
              if (j == 0) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(0) +
                  "' class='calendar__day horizontalGutter op3'><span class='calendar__dayNum'>" +
                  (prevLastDay - (firstDayName - 1) + j) +
                  "</span></div>";
              } else if (j == 6) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(0) +
                  "' class='calendar__day op3'><span class='calendar__dayNum'>" +
                  (prevLastDay - (firstDayName - 1) + j) +
                  "</span></div>";
              } else {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(0) +
                  "' class='calendar__day horizontalGutter op3'><span class='calendar__dayNum'>" +
                  (prevLastDay - (firstDayName - 1) + j) +
                  "</span></div>";
              }
              // i == 0: 1주차일 때
              // j > firstDayName: 이번 달 시작 요일 이후 일 때
            } else if (i == 0 && j > firstDayName) {
              //일요일일 때, 토요일일 때, 나머지 요일 일 때
              if (j == 0) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day horizontalGutter'><span class='calendar__dayNum'>" +
                  startDayCount++ +
                  "</span><canvas class='calendar__weatherIcon'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              } else if (j == 6) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day'><span class='calendar__dayNum'>" +
                  startDayCount++ +
                  "</span><canvas class='calendar__weatherIcon'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              } else {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day horizontalGutter'><span class='calendar__dayNum'>" +
                  startDayCount++ +
                  "</span><canvas class='calendar__weatherIcon'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              }
              // startDayCount > lastDay: 이번 달의 마지막 날 이후일 때
            } else if (startDayCount > lastDay) {
              //일요일일 때, 토요일일 때, 나머지 요일 일 때
              if (j == 0) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(0) +
                  "' class='calendar__day horizontalGutter verticalGutter op3'><span class='calendar__dayNum'>" +
                  lastDayCount++ +
                  "</span></div>";
              } else if (j == 6) {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(0) +
                  "' class='calendar__day verticalGutter op3'><span class='calendar__dayNum'>" +
                  lastDayCount++ +
                  "</span></div>";
              } else {
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(0) +
                  "' class='calendar__day horizontalGutter verticalGutter op3'><span class='calendar__dayNum'>" +
                  lastDayCount++ +
                  "</span></div>";
              }
            }
            // startDayCount <= lastDay: 이번 달의 마지막 날이거나 이전일 때
            if (i > 0 && startDayCount <= lastDay) {
              //일요일일 때, 토요일일 때, 나머지 요일 일 때
              if (j == 0) {
                //일요일
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day horizontalGutter verticalGutter'><span class='calendar__dayNum'>" +
                  startDayCount +
                  "</span><canvas id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount++) +
                  "icon" +
                  "' class='calendar__weatherIcon'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              } else if (j == 6) {
                //토요일
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day verticalGutter'><span class='calendar__dayNum'>" +
                  startDayCount +
                  "</span><canvas id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount++) +
                  "icon" +
                  "' class='calendar__weatherIcon'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              } else {
                //월~금
                calHtml +=
                  "<div id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount) +
                  "' class='calendar__day horizontalGutter verticalGutter'><span class='calendar__dayNum'>" +
                  startDayCount +
                  "</span><canvas id='" +
                  year +
                  month +
                  setFixDayCount(startDayCount++) +
                  "icon" +
                  "' class='calendar__weatherIcon'></canvas><div class='calendar__gen'><div class='calendar__genValue'><span class='calendar__genText'>0  </span> kWh</div></div></div>";
              }
            }
          }
        }
        //캘린더에 내용 붙임
        document
          .querySelector("#PVGenCalendar")
          .insertAdjacentHTML("beforeend", calHtml);
      };

      const setFixDayCount = number => {
        //캘린더 하루마다 아이디를 만들어주기 위해 사용
        let fixNum = "";
        if (number < 10) {
          fixNum = "0" + number;
        } else {
          fixNum = number;
        }
        return fixNum;
      };

      if (today.getMonth() + 1 < 10) {
        setCalendarData(today.getFullYear(), "0" + (today.getMonth() + 1));
      } else {
        setCalendarData(today.getFullYear(), "" + (today.getMonth() + 1));
      }
    })();
  </script>
</html>