<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <jsp:include page="../include/common_static.jsp"/>
        <jsp:include page="../include/sub_static.jsp"/>
        <!-- <script src="../js/main/siteMain.js" type="text/javascript"></script> -->
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
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="indiv income">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">월별 수입 종합</h2>
                                            <div class="time fr">2018-08-12 11:41:26</div>
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
                                                      text: '(won)',
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
                                                      return '<b>' + this.series.name + '</b><br/>' + this.x + '<br/><span style="color:#438fd7">' + this.y + ' won</span>';
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
                                                    color: '#438fd7' /* REC 수익 */
                                                  }, {
                                                    color: '#f75c4a' /* SMP 수익 */
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
                                                            <th>REC 수익</th>
                                                            <th>SMP 수익</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <th>1</th>
                                                            <td>500</td>
                                                            <td>400</td>
                                                        </tr>
                                                        <tr>
                                                            <th>2</th>
                                                            <td>300</td>
                                                            <td>500</td>
                                                        </tr>
                                                        <tr>
                                                            <th>3</th>
                                                            <td>200</td>
                                                            <td>550</td>
                                                        </tr>
                                                        <tr>
                                                            <th>4</th>
                                                            <td>400</td>
                                                            <td>540</td>
                                                        </tr>
                                                        <tr>
                                                            <th>5</th>
                                                            <td>300</td>
                                                            <td>550</td>
                                                        </tr>
                                                        <tr>
                                                            <th>6</th>
                                                            <td>500</td>
                                                            <td>520</td>
                                                        </tr>
                                                        <tr>
                                                            <th>7</th>
                                                            <td>400</td>
                                                            <td>530</td>
                                                        </tr>
                                                        <tr>
                                                            <th>8</th>
                                                            <td>300</td>
                                                            <td>750</td>
                                                        </tr>
                                                        <tr>
                                                            <th>9</th>
                                                            <td>450</td>
                                                            <td>800</td>
                                                        </tr>
                                                        <tr>
                                                            <th>10</th>
                                                            <td>0</td>
                                                            <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>11</th>
                                                            <td>0</td>
                                                            <td>0</td>
                                                        </tr>
                                                        <tr>
                                                            <th>12</th>
                                                            <td>0</td>
                                                            <td>0</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="chart_footer">
                                            <ul class="clear">
                                                <li>이번달 총 REC 수익: <span>1,000</span> 원 <i
                                                        class="glyphicon glyphicon-triangle-top" style="color:#f75c4a">(90)</i>
                                                </li>
                                                <li>이번달 총 SMP 수익: <span>500,000</span> 원 <i
                                                        class="glyphicon glyphicon-triangle-bottom"
                                                        style="color:#438fd7">(60)</i></li>
                                                <li>이번달 총 수익: <span>1,500</span> 원 <i
                                                        class="glyphicon glyphicon-triangle-bottom"
                                                        style="color:#438fd7">(150)</i></li>
                                                <li>올해 누적 수익: <span>15,121,231</span> 원 <i
                                                        class="glyphicon glyphicon-triangle-top" style="color:#f75c4a">(12,405)</i>
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
                                            <h2 class="ntit fl">REC 종합</h2>
                                            <div class="time fr">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="pie_chart">
                                            <div id="REC_pie" style="height:260px;"></div>
                                            <script language="JavaScript">
                                              $(function () {
                                                var REC_pie = Highcharts.chart('REC_pie', {
                                                  chart: {
                                                    plotBackgroundColor: null,
                                                    plotBorderWidth: null,
                                                    plotShadow: false,
                                                    type: 'pie',
                                                    backgroundColor: 'transparent',
                                                  },
                                                  title: {
                                                    text: ''
                                                  },
                                                  tooltip: {
                                                    pointFormat: '<b>{point.percentage:.1f} %</b>'
                                                  },
                                                  navigation: {
                                                    buttonOptions: {
                                                      enabled: false /* 메뉴 안보이기 */
                                                    }
                                                  },
                                                  plotOptions: {
                                                    pie: {
                                                      allowPointSelect: true,
                                                      cursor: 'pointer',
                                                      dataLabels: {
                                                        enabled: true,
                                                        color: '#F0F0F3',
                                                        format: '{point.percentage:.1f} %',
                                                        distance: -50,
                                                      },
                                                      showInLegend: true
                                                    },
                                                    candlestick: {
                                                      lineColor: 'white'
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
                                                  credits: {
                                                    enabled: false
                                                  },
                                                  series: [{
                                                    name: 'Brands',
                                                    colorByPoint: true,
                                                    data: [{
                                                      name: '정산받은 REC',
                                                      y: 70,
                                                      color: '#438fd7',
                                                    }, {
                                                      name: '보유 REC',
                                                      y: 20,
                                                      color: '#f75c4a'
                                                    }, {
                                                      name: '발급 가능 REC',
                                                      y: 10,
                                                      color: '#FBBC04'
                                                    },],
                                                  }]
                                                });
                                              })
                                            </script>
                                            <div class="chart_footer">
                                                <ul class="clear">
                                                    <li>보유 REC: <span>100</span> 개</li>
                                                    <li>발급 가능 REC: <span>50</span> 개</li>
                                                    <li>총 정산된 REC: <span>500</span> 개</li>
                                                    <li>총 정산 금액: <span>25,000,000</span> 원</li>
                                                </ul>
                                            </div>
                                        </div>
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
                                            <div class="time fr">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="chart_header">
                                            <ul class="clear">
                                                <li>누적 발전량: <span>400kWh</span> </li>
                                                <li>SMP 수익: <span>40,000 개</span></li>
                                                <li>REC: <span>0.4 개</span> </li>
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
                                                        return this.value/1000 + 'k';
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
                                                    data: [
                                                      null, null, null, null, null, 6, 11, 32, 110, 235,
                                                      369, 640, 1005, 1436, 2063, 3057, 4618, 6444, 9822, 15468,
                                                      20434, 24126, 27387, 29459, 31056, 31982, 32040, 31233, 29224, 27342,
                                                      26662, 26956, 27912, 28999, 28965, 27826, 25579, 25722, 24826, 24605,
                                                      24304, 23464, 23708, 24099, 24357, 24237, 24401, 24344, 23586, 22380,
                                                      21004, 17287, 14747, 13076, 12555, 12144, 11009, 10950, 10871, 10824,
                                                      10577, 10527, 10475, 10421, 10358, 10295, 10104, 9914, 9620, 9326,
                                                      5113, 5113, 4954, 4804, 4761, 4717, 4368, 4018
                                                    ],
                                                    color: '#438fd7',
                                                  }, {
                                                    name: '실제',
                                                    data: [null, null, null, null, null, null, null, null, null, null,
                                                      5, 25, 50, 120, 150, 200, 426, 660, 869, 1060,
                                                      1605, 2471, 3322, 4238, 5221, 6129, 7089, 8339, 9399, 10538,
                                                      11643, 13092, 14478, 15915, 17385, 19055, 21205, 23044, 25393, 27935,
                                                      30062, 32049, 33952, 35804, 37431, 39197, 45000, 43000, 41000, 39000,
                                                      37000, 35000, 33000, 31000, 29000, 27000, 25000, 24000, 23000, 22000,
                                                      21000, 20000, 19000, 18000, 18000, 17000, 16000, 15537, 14162, 12787,
                                                      12600, 11400, 5500, 4512, 4502, 4502, 4500, 4500
                                                    ],
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
                                            <div class="time fr">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="chart_header">
                                            <ul class="clear">
                                                <li>현재: <span>80 원</span> </li>
                                                <li>평균: <span>78 원</span></li>
                                                <li>최고: <span>110 원</span> </li>
                                                <li>최저: <span>62 원</span> </li>
                                            </ul>
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
                                                    min: 0, /* 최소값 지정 */
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
                                                    name: 'SMP',
                                                    data: [
                                                      66, 43, 88, 99, 72, 63, 55, 77, 120, 101,
                                                      46, 23, 68, 79, 52, 43, 35, 57, 100, 81,
                                                    ],
                                                    color: '#FBBC04',
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
                                            <div class="time fr">2018-08-12 11:41:26</div>
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
                                                    rangeSelector: {
                                                      selected: 1
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
                                                    yAxis: {
                                                      gridLineColor: '#707073',
                                                      labels: {
                                                        x: 10,
                                                        style: {
                                                          color: '#E0E0E3'
                                                        }
                                                      },
                                                      lineColor: '#707073',
                                                      minorGridLineColor: '#505053',
                                                      tickColor: '#707073',
                                                      tickWidth: 1,
                                                      title: {
                                                        style: {
                                                          color: '#A0A0A3'
                                                        }
                                                      }
                                                    },
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
                                                        fillColor: '#505053'
                                                      },
                                                      candlestick: {
                                                        lineColor: '#fff',
                                                        color: '#f75c4a',
                                                        upColor: 'green'
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
                                                      type: 'candlestick',
                                                      name: '거래량',
                                                      data: data,
                                                      dataGrouping: {
                                                        units: [
                                                          [
                                                            'week', // unit name
                                                            [1] // allowed multiples
                                                          ], [
                                                            'month',
                                                            [1, 2, 3, 4, 6]
                                                          ]
                                                        ]
                                                      },
                                                      color: '#f75c4a'
                                                    }, {
                                                      type: 'line',
                                                      name: '실거래가',
                                                      data: data,
                                                      dataGrouping: {
                                                        units: [
                                                          [
                                                            'week', // unit name
                                                            [1] // allowed multiples
                                                          ], [
                                                            'month',
                                                            [1, 2, 3, 4, 6]
                                                          ]
                                                        ]
                                                      },
                                                      color: '#438fd7'
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
                                    <div class="indiv">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">알람</h2>
                                            <div class="fr today_alarm">
                                                <!-- <div class="total">금일발생 <span>614</span></div>
                                                <div class="no"><span>2</span></div> -->
                                            </div>
                                        </div>
                                        <!-- no-data { -->
                                        <%--                                        <div class="no-data">--%>
                                        <%--                                            <span>알람 정보를 가져올 수 없습니다.</span>--%>
                                        <%--                                        </div>--%>
                                        <!-- } no-data -->
                                        <div class="alarm_stat mt10 clear">
                                            <div class="a_alert clear">
                                                <span>ALERT</span> <em>128</em>
                                            </div>
                                            <div class="a_warning clear">
                                                <span>WARNING</span> <em>486</em>
                                            </div>
                                        </div>
                                        <div class="alarm_notice">
                                            <h2>최근 알람</h2>
                                            <ul>
                                                <li>
                                                    <a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망. 메시지가 길면 절삭처리 됩니다. 메시지가 길면
                                                        절삭처리 됩니다.</a>
                                                    <span>2018-08-12 11:41:26</span>
                                                </li>
                                                <li>
                                                    <a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망.</a>
                                                    <span>2018-08-12 11:41:26</span>
                                                </li>
                                                <li>
                                                    <a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망.</a>
                                                    <span>2018-08-12 11:41:26</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="col-sm-12 indiv">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">현재 발전 현황</h2>
                                            <div class="time fr">2018-08-12 11:41:26</div>
                                        </div>
                                        <div class="col-sm-12 gen">
                                            <div class="col-sm-6 left">
                                                <div id="container-speed" class="chart-container"
                                                ></div>
                                                <script language="JavaScript">
                                                  $(function () {
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
                                                          distance: -20,
                                                          style: {
                                                            color: '#fff'
                                                          }
                                                        }
                                                      },

                                                      plotOptions: {
                                                        solidgauge: {
                                                          dataLabels: {
                                                            y: 40,
                                                            borderWidth: 0,
                                                            useHTML: false,
                                                            style: {
                                                              color: '#fff'
                                                            }
                                                          }
                                                        }
                                                      },


                                                    };

                                                    // The speed gauge
                                                    var chartSpeed = Highcharts.chart('container-speed', Highcharts.merge(gaugeOptions, {
                                                      yAxis: {
                                                        min: 0,
                                                        max: 200,
                                                        x: 0,
                                                        title: {
                                                          text: 'Total'
                                                        }
                                                      },

                                                      credits: {
                                                        enabled: false
                                                      },

                                                      series: [{
                                                        name: 'Speed',
                                                        data: [80],
                                                        dataLabels: {
                                                          format:
                                                            '<div style="text-align:center">' +
                                                            '<span style="font-size:25px">{y}</span><br/>' +
                                                            '<span style="font-size:12px;">kW/h</span>' +
                                                            '</div>'
                                                        },
                                                        tooltip: {
                                                          valueSuffix: ' kW/h'
                                                        }
                                                      }]

                                                    }));

                                                    //Bring life to the dials
                                                    setInterval(function () {
                                                      // Speed
                                                      var point,
                                                        newVal,
                                                        inc;

                                                      if (chartSpeed) {
                                                        point = chartSpeed.series[0].points[0];
                                                        inc = Math.round((Math.random() - 0.5) * 100);
                                                        newVal = point.y + inc;

                                                        if (newVal < 0 || newVal > 200) {
                                                          newVal = point.y - inc;
                                                        }

                                                        point.update(newVal);
                                                      }
                                                    }, 2000);

                                                  });
                                                </script>
                                            </div>
                                            <div class="col-sm-6 right">
                                                <div class="col-sm-6">
                                                    <div id="container-speed1" class="chart-container"></div>
                                                    <script language="JavaScript">
                                                      $(function () {
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
                                                              y: -30,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            },
                                                            labels: {
                                                              y: 16,
                                                              distance: -3,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            }
                                                          },

                                                          plotOptions: {
                                                            solidgauge: {
                                                              dataLabels: {
                                                                y: 40,
                                                                borderWidth: 0,
                                                                useHTML: false,
                                                                style: {
                                                                  color: '#fff'
                                                                }
                                                              }
                                                            }
                                                          }
                                                        };

                                                        // The speed gauge
                                                        var chartSpeed = Highcharts.chart('container-speed1', Highcharts.merge(gaugeOptions, {
                                                            yAxis: {
                                                              min: 0,
                                                              max: 200,
                                                              x: 0,
                                                              title: {
                                                                text: 'IVT 1'
                                                              }
                                                            },

                                                            credits: {
                                                              enabled: false
                                                            },

                                                            series: [{
                                                              name: 'Speed',
                                                              data: [80],
                                                              dataLabels: {
                                                                format:
                                                                  '<div style="text-align:center;">' +
                                                                  '<span style="font-size:14px;">{y}</span><br/>' +
                                                                  '<span style="font-size:8px;">km/h</span>' +
                                                                  '</div>'
                                                              },
                                                              tooltip:
                                                                {
                                                                  valueSuffix: ' km/h'
                                                                }
                                                            }]

                                                          }))
                                                        ;

                                                        // Bring life to the dials
                                                        setInterval(function () {
                                                          // Speed
                                                          var point,
                                                            newVal,
                                                            inc;

                                                          if (chartSpeed) {
                                                            point = chartSpeed.series[0].points[0];
                                                            inc = Math.round((Math.random() - 0.5) * 100);
                                                            newVal = point.y + inc;

                                                            if (newVal < 0 || newVal > 200) {
                                                              newVal = point.y - inc;
                                                            }

                                                            point.update(newVal);
                                                          }
                                                        }, 2000);

                                                      });
                                                    </script>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div id="container-speed2" class="chart-container"></div>
                                                    <script language="JavaScript">
                                                      $(function () {
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
                                                              y: -30,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            },
                                                            labels: {
                                                              y: 16,
                                                              distance: -3,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            }
                                                          },

                                                          plotOptions: {
                                                            solidgauge: {
                                                              dataLabels: {
                                                                y: 40,
                                                                borderWidth: 0,
                                                                useHTML: false,
                                                                style: {
                                                                  color: '#fff'
                                                                }
                                                              }
                                                            }
                                                          }
                                                        };

                                                        // The speed gauge
                                                        var chartSpeed = Highcharts.chart('container-speed2', Highcharts.merge(gaugeOptions, {
                                                            yAxis: {
                                                              min: 0,
                                                              max: 200,
                                                              x: 0,
                                                              title: {
                                                                text: 'IVT 2'
                                                              }
                                                            },

                                                            credits: {
                                                              enabled: false
                                                            },

                                                            series: [{
                                                              name: 'Speed',
                                                              data: [80],
                                                              dataLabels: {
                                                                format:
                                                                  '<div style="text-align:center;">' +
                                                                  '<span style="font-size:14px;">{y}</span><br/>' +
                                                                  '<span style="font-size:8px;">km/h</span>' +
                                                                  '</div>'
                                                              },
                                                              tooltip:
                                                                {
                                                                  valueSuffix: ' km/h'
                                                                }
                                                            }]

                                                          }))
                                                        ;

                                                        // Bring life to the dials
                                                        setInterval(function () {
                                                          // Speed
                                                          var point,
                                                            newVal,
                                                            inc;

                                                          if (chartSpeed) {
                                                            point = chartSpeed.series[0].points[0];
                                                            inc = Math.round((Math.random() - 0.5) * 100);
                                                            newVal = point.y + inc;

                                                            if (newVal < 0 || newVal > 200) {
                                                              newVal = point.y - inc;
                                                            }

                                                            point.update(newVal);
                                                          }
                                                        }, 2000);

                                                      });
                                                    </script>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div id="container-speed3" class="chart-container"></div>
                                                    <script language="JavaScript">
                                                      $(function () {
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
                                                              y: -30,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            },
                                                            labels: {
                                                              y: 16,
                                                              distance: -3,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            }
                                                          },

                                                          plotOptions: {
                                                            solidgauge: {
                                                              dataLabels: {
                                                                y: 40,
                                                                borderWidth: 0,
                                                                useHTML: false,
                                                                style: {
                                                                  color: '#fff'
                                                                }
                                                              }
                                                            }
                                                          }
                                                        };

                                                        // The speed gauge
                                                        var chartSpeed = Highcharts.chart('container-speed3', Highcharts.merge(gaugeOptions, {
                                                            yAxis: {
                                                              min: 0,
                                                              max: 200,
                                                              x: 0,
                                                              title: {
                                                                text: 'IVT 3'
                                                              }
                                                            },

                                                            credits: {
                                                              enabled: false
                                                            },

                                                            series: [{
                                                              name: 'Speed',
                                                              data: [80],
                                                              dataLabels: {
                                                                format:
                                                                  '<div style="text-align:center;">' +
                                                                  '<span style="font-size:14px;">{y}</span><br/>' +
                                                                  '<span style="font-size:8px;">km/h</span>' +
                                                                  '</div>'
                                                              },
                                                              tooltip:
                                                                {
                                                                  valueSuffix: ' km/h'
                                                                }
                                                            }]

                                                          }))
                                                        ;

                                                        // Bring life to the dials
                                                        setInterval(function () {
                                                          // Speed
                                                          var point,
                                                            newVal,
                                                            inc;

                                                          if (chartSpeed) {
                                                            point = chartSpeed.series[0].points[0];
                                                            inc = Math.round((Math.random() - 0.5) * 100);
                                                            newVal = point.y + inc;

                                                            if (newVal < 0 || newVal > 200) {
                                                              newVal = point.y - inc;
                                                            }

                                                            point.update(newVal);
                                                          }
                                                        }, 2000);

                                                      });
                                                    </script>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div id="container-speed4" class="chart-container"></div>
                                                    <script language="JavaScript">
                                                      $(function () {
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
                                                              y: -30,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            },
                                                            labels: {
                                                              y: 16,
                                                              distance: -3,
                                                              style: {
                                                                color: '#fff'
                                                              }
                                                            }
                                                          },

                                                          plotOptions: {
                                                            solidgauge: {
                                                              dataLabels: {
                                                                y: 40,
                                                                borderWidth: 0,
                                                                useHTML: false,
                                                                style: {
                                                                  color: '#fff'
                                                                }
                                                              }
                                                            }
                                                          }
                                                        };

                                                        // The speed gauge
                                                        var chartSpeed = Highcharts.chart('container-speed4', Highcharts.merge(gaugeOptions, {
                                                            yAxis: {
                                                              min: 0,
                                                              max: 200,
                                                              x: 0,
                                                              title: {
                                                                text: 'IVT 4'
                                                              }
                                                            },

                                                            credits: {
                                                              enabled: false
                                                            },

                                                            series: [{
                                                              name: 'Speed',
                                                              data: [80],
                                                              dataLabels: {
                                                                format:
                                                                  '<div style="text-align:center;">' +
                                                                  '<span style="font-size:14px;">{y}</span><br/>' +
                                                                  '<span style="font-size:8px;">km/h</span>' +
                                                                  '</div>'
                                                              },
                                                              tooltip:
                                                                {
                                                                  valueSuffix: ' km/h'
                                                                }
                                                            }]

                                                          }))
                                                        ;

                                                        // Bring life to the dials
                                                        setInterval(function () {
                                                          // Speed
                                                          var point,
                                                            newVal,
                                                            inc;

                                                          if (chartSpeed) {
                                                            point = chartSpeed.series[0].points[0];
                                                            inc = Math.round((Math.random() - 0.5) * 100);
                                                            newVal = point.y + inc;

                                                            if (newVal < 0 || newVal > 200) {
                                                              newVal = point.y - inc;
                                                            }

                                                            point.update(newVal);
                                                          }
                                                        }, 2000);

                                                      });
                                                    </script>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="paging clear">
                                            <a href="#;" class="prev">PREV</a>
                                            <span><strong>1</strong> / 3</span>
                                            <a href="#;" class="next">NEXT</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="col-sm-12 indiv">
                                        <div class="chart_top clear">
                                            <h2 class="ntit fl">날씨</h2>
                                            <div class="time fr">2018-08-12 11:41:26</div>
                                            <div class="fr today_alarm">
                                                <!-- <div class="total">금일발생 <span>614</span></div>
                                                <div class="no"><span>2</span></div> -->
                                            </div>
                                        </div>
                                        <div class="weather_box"
                                             style="text-align: center; margin-top: 20px; line-height:50px; vertical-align: middle;">
                                            <div class="day"
                                                 style="width:13%; vertical-align: top; display: inline-block; text-align: center">
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">Sun</span>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <i class="wi wi-night-sleet"
                                                       style="font-size: 30px; color:#fff"></i>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">4.2 H</span>
                                                </div>
                                            </div>
                                            <div class="day"
                                                 style="width:13%; vertical-align: top; display: inline-block; text-align: center">
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">Mon</span>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <i class="wi wi-day-sunny"
                                                       style="font-size: 30px; color:#fff"></i>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">3.5 H</span>
                                                </div>
                                            </div>
                                            <div class="day"
                                                 style="width:13%; vertical-align: top; display: inline-block; text-align: center">
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">Tue</span>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <i class="wi wi-day-rain-mix"
                                                       style="font-size: 30px; color:#fff"></i>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">3.4 H</span>
                                                </div>
                                            </div>
                                            <div class="day"
                                                 style="width:13%; vertical-align: top; display: inline-block; text-align: center">
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">Wed</span>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <i class="wi wi-day-sunny-overcast"
                                                       style="font-size: 30px; color:#fff"></i>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">1.7 H</span>
                                                </div>
                                            </div>
                                            <div class="day"
                                                 style="width:13%; vertical-align: top; display: inline-block; text-align: center">
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">Thu</span>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <i class="wi wi-day-showers"
                                                       style="font-size: 30px; color:#fff"></i>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">2.2 H</span>
                                                </div>
                                            </div>
                                            <div class="day"
                                                 style="width:13%; vertical-align: top; display: inline-block; text-align: center">
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">Fri</span>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <i class="wi wi-day-cloudy-gusts"
                                                       style="font-size: 30px; color:#fff"></i>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">3.3 H</span>
                                                </div>
                                            </div>
                                            <div class="day"
                                                 style="width:13%; display: inline-block; text-align: center">
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">Sat</span>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <i class="wi wi-day-fog"
                                                       style="font-size: 30px; color:#fff"></i>
                                                </div>
                                                <div style="margin-bottom: 20px;">
                                                    <span style="color:#fff; text-align:center;">4.4 H</span>
                                                </div>
                                            </div>
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