<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="col-lg-12">
  <div class="row">
    <div class="col-lg-12">
      <h1 class="page-header">운전 이력</h1>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="indiv his_chart_top clear">
        <div class="sa_select fl">
          <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">사업소#1
              <span class="caret"></span></button>
            <ul class="dropdown-menu">
              <li class="on"><a href="#">전체</a></li>
              <li><a href="#">사업소#1</a></li>
              <li><a href="#">사업소#2</a></li>
              <li><a href="#">사업소#3</a></li>
            </ul>
          </div>
        </div>
        <div class="fl">
          <span>설비타입</span>
          <div class="sa_select">
            <div class="dropdown">
              <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">인버터
                <span class="caret"></span></button>
              <ul class="dropdown-menu">
                <li class="on"><a href="#">전체</a></li>
                <li><a href="">인버터</a></li>
                <li><a href="">접속반</a></li>
                <li><a href="">차단기</a></li>
                <li><a href="">계량기</a></li>
                <li><a href="">기상센서</a></li>
                <li><a href="">기상청 기상정보</a></li>
                <li><a href="">한전 iSmart</a></li>
                <li><a href="">KPX계량포털</a></li>
                <li><a href="">CCTV</a></li>
              </ul>
            </div>
          </div>
        </div>
        <div class="fl">
          <div class="sa_select">
            <div class="dropdown">
              <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">조회설비선택
                <span class="caret"></span></button>
              <ul class="dropdown-menu dropdown-menu-form" role="menu">
                <li><a href="#" data-value="option1" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#1</a></li>
                <li><a href="#" data-value="option2" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#2</a></li>
                <li><a href="#" data-value="option3" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#3</a></li>
                <li><a href="#" data-value="option4" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#4</a></li>
                <li><a href="#" data-value="option5" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#5</a></li>
                <li><a href="#" data-value="option6" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#6</a></li>
                <li><a href="#" data-value="option7" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#7</a></li>
                <li><a href="#" data-value="option8" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#8</a></li>
                <li><a href="#" data-value="option9" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#9</a></li>
                <li><a href="#" data-value="option10" tabIndex="-1"><input type="checkbox"/>&nbsp;인버터#10</a></li>
              </ul>
            </div>
          </div>
        </div>
        <div class="fl">
          <span>조회기간</span>
          <div class="sa_select">
            <div class="dropdown">
              <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">15분
                <span class="caret"></span></button>
              <ul class="dropdown-menu">
                <li class="on"><a href="#">15분</a></li>
                <li><a href="#">1시간</a></li>
                <li><a href="#">1일</a></li>
                <li><a href="#">1주</a></li>
                <li><a href="#">1월</a></li>
              </ul>
            </div>
          </div>
        </div>
        <div class="sel_calendar fl">
          <input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
          <em>-</em>
          <input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
          <button type="submit">조회</button>
        </div>
        <div class="fr">
          <a href="#;" class="save_btn">데이터저장</a>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-8">
      <div class="indiv">
        <div class="chart_top">
          <h2 class="ntit">항목별 이력</h2>
        </div>
        <div class="inchart">
          <div id="hchart2"></div>
          <script language="JavaScript">
            $(function () {
              var myChart = Highcharts.chart('hchart2', {
                data: {
                  table: 'datatable' /* 테이블에서 데이터 불러오기 */
                },
                
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
                  labels: {
                    align: 'center',
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  },
                  tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                  title: {
                    text: null
                  },
                  crosshair: true /* 포커스 선 */
                },
                
                yAxis: {
                  gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                  min: 0, /* 최소값 지정 */
                  title: {
                    text: '(kWh)',
                    align: 'low',
                    rotation: 0, /* 타이틀 기울기 */
                    y: 25, /* 타이틀 위치 조정 */
                    x: 5, /* 타이틀 위치 조정 */
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  },
                  labels: {
                    overflow: 'justify',
                    x: -20, /* 그래프와의 거리 조정 */
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  }
                },
                
                /* 범례 */
                legend: {
                  enabled: true,
                  align: 'right',
                  verticalAlign: 'top',
                  x: 10,
                  itemStyle: {
                    color: '#3d4250',
                    fontSize: '14px',
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
                  shared: true /* 툴팁 공유 */
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
                    stacking: 'normal'
                  }
                },
                
                /* 출처 */
                credits: {
                  enabled: false
                },
                
                /* 그래프 스타일 */
                series: [{
                  name: '인버터#1 금일발전량',
                  type: 'column',
                  stack: 'male',
                  color: '#6b41ba',
                  tooltip: {
                    valueSuffix: 'kWh'
                  }
                }, {
                  name: '인버터#7 금일발전량',
                  type: 'column',
                  stack: 'male',
                  color: '#7571f9',
                  tooltip: {
                    valueSuffix: 'kWh'
                  }
                }
                  , {
                    name: '인버터#11 금일발전량',
                    type: 'column',
                    stack: 'male',
                    color: '#abb4fa',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }
                  , {
                    name: '인버터#1 누적발전량',
                    type: 'column',
                    stack: 'female',
                    color: '#007bff',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }, {
                    name: '인버터#7 누적발전량',
                    type: 'column',
                    stack: 'female',
                    color: '#3485db',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }
                  , {
                    name: '인버터#11 누적발전량',
                    type: 'column',
                    stack: 'female',
                    color: '#73a2d5',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }]
                
              });
            });
          </script>
        </div>
        <!-- 데이터 추출용 -->
        <div class="chart_table2" style="display:none;">
          <table id="datatable">
            <thead>
              <tr>
                <th>2018-08</th>
                <th>인버터#1 금일발전량</th>
                <th>인버터#7 금일발전량</th>
                <th>인버터#11 금일발전량</th>
                <th>인버터#1 누적발전량</th>
                <th>인버터#7 누적발전량</th>
                <th>인버터#11 누적발전량</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th>1</th>
                <td>300</td>
                <td>400</td>
                <td>300</td>
                <td>200</td>
                <td>150</td>
                <td>300</td>
              </tr>
              <tr>
                <th>2</th>
                <td>300</td>
                <td>300</td>
                <td>300</td>
                <td>200</td>
                <td>200</td>
                <td>150</td>
              </tr>
              <tr>
                <th>3</th>
                <td>540</td>
                <td>350</td>
                <td>300</td>
                <td>250</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>4</th>
                <td>240</td>
                <td>320</td>
                <td>300</td>
                <td>250</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>5</th>
                <td>550</td>
                <td>480</td>
                <td>300</td>
                <td>200</td>
                <td>250</td>
                <td>210</td>
              </tr>
              <tr>
                <th>6</th>
                <td>310</td>
                <td>260</td>
                <td>300</td>
                <td>200</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>7</th>
                <td>200</td>
                <td>300</td>
                <td>350</td>
                <td>200</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>8</th>
                <td>340</td>
                <td>200</td>
                <td>350</td>
                <td>200</td>
                <td>200</td>
                <td>200</td>
              </tr>
              <tr>
                <th>9</th>
                <td>200</td>
                <td>300</td>
                <td>200</td>
                <td>300</td>
                <td>150</td>
                <td>300</td>
              </tr>
              <tr>
                <th>10</th>
                <td>250</td>
                <td>250</td>
                <td>350</td>
                <td>250</td>
                <td>250</td>
                <td>250</td>
              </tr>
              <tr>
                <th>11</th>
                <td>350</td>
                <td>240</td>
                <td>550</td>
                <td>350</td>
                <td>450</td>
                <td>550</td>
              </tr>
              <tr>
                <th>12</th>
                <td>350</td>
                <td>340</td>
                <td>250</td>
                <td>350</td>
                <td>250</td>
                <td>250</td>
              </tr>
              <tr>
                <th>13</th>
                <td>250</td>
                <td>200</td>
                <td>250</td>
                <td>250</td>
                <td>200</td>
                <td>250</td>
              </tr>
              <tr>
                <th>14</th>
                <td>320</td>
                <td>230</td>
                <td>330</td>
                <td>360</td>
                <td>350</td>
                <td>300</td>
              </tr>
              <tr>
                <th>15</th>
                <td>150</td>
                <td>300</td>
                <td>200</td>
                <td>150</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>16</th>
                <td>150</td>
                <td>200</td>
                <td>300</td>
                <td>250</td>
                <td>200</td>
                <td>100</td>
              </tr>
              <tr>
                <th>17</th>
                <td>320</td>
                <td>250</td>
                <td>310</td>
                <td>220</td>
                <td>440</td>
                <td>330</td>
              </tr>
              <tr>
                <th>18</th>
                <td>350</td>
                <td>200</td>
                <td>150</td>
                <td>250</td>
                <td>200</td>
                <td>10</td>
              </tr>
              <tr>
                <th>19</th>
                <td>150</td>
                <td>230</td>
                <td>200</td>
                <td>150</td>
                <td>280</td>
                <td>260</td>
              </tr>
              <tr>
                <th>20</th>
                <td>330</td>
                <td>220</td>
                <td>150</td>
                <td>350</td>
                <td>150</td>
                <td>250</td>
              </tr>
              <tr>
                <th>21</th>
                <td>150</td>
                <td>420</td>
                <td>230</td>
                <td>240</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>22</th>
                <td>150</td>
                <td>220</td>
                <td>250</td>
                <td>350</td>
                <td>330</td>
                <td>220</td>
              </tr>
              <tr>
                <th>23</th>
                <td>150</td>
                <td>200</td>
                <td>200</td>
                <td>300</td>
                <td>350</td>
                <td>300</td>
              </tr>
              <tr>
                <th>24</th>
                <td>250</td>
                <td>200</td>
                <td>350</td>
                <td>250</td>
                <td>350</td>
                <td>250</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="indiv hchart_aside">
        <div class="chart_top clear">
          <h2 class="ntit fl">항목 이력 분포</h2>
          <div class="ml10 fr">
            <div class="sa_select">
              <div class="dropdown">
                <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">DC전력
                  <span class="caret"></span></button>
                <ul class="dropdown-menu">
                  <!--<li><a href="#">금일발전량</a></li>-->
                  <li><a href="#">누적발전량</a></li>
                  <li><a href="#">역률</a></li>
                  <li><a href="#">주파수</a></li>
                  <li><a href="#">온도</a></li>
                  <li><a href="#">DC전압</a></li>
                  <li><a href="#">DC전류</a></li>
                  <li><a href="#">DC전력</a></li>
                  <li><a href="#">현재출력</a></li>
                  <li><a href="#">AC전압R</a></li>
                  <li><a href="#">AC전압S</a></li>
                  <li><a href="#">AC전압T</a></li>
                </ul>
              </div>
            </div>
          </div>
          <div class="fr">
            <div class="sa_select">
              <div class="dropdown">
                <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">금일발전량
                  <span class="caret"></span></button>
                <ul class="dropdown-menu">
                  <li><a href="#">금일발전량</a></li>
                  <li><a href="#">누적발전량</a></li>
                  <li><a href="#">역률</a></li>
                  <li><a href="#">주파수</a></li>
                  <li><a href="#">온도</a></li>
                  <li><a href="#">DC전압</a></li>
                  <li><a href="#">DC전류</a></li>
                  <!--<li><a href="#">DC전력</a></li>-->
                  <li><a href="#">현재출력</a></li>
                  <li><a href="#">AC전압R</a></li>
                  <li><a href="#">AC전압S</a></li>
                  <li><a href="#">AC전압T</a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div class="inchart">
          <div id="hchart3"></div>
          <script language="JavaScript">
            $(function () {
              var myChart3 = Highcharts.chart('hchart3', {
                data: {
                  table: 'datatable3' /* 테이블에서 데이터 불러오기 */
                },
                
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
                  labels: {
                    align: 'center',
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  },
                  tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                  title: {
                    text: 'DC전력값',
                    y: 0, /* 타이틀 위치 조정 */
                    x: 0 /* 타이틀 위치 조정 */
                  },
                  crosshair: true /* 포커스 선 */
                },
                
                yAxis: {
                  gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                  min: 0, /* 최소값 지정 */
                  title: {
                    text: '금일발전량',
                    align: 'middle',
                    rotation: 90, /* 타이틀 기울기 */
                    y: 0, /* 타이틀 위치 조정 */
                    x: 0, /* 타이틀 위치 조정 */
                    style: {
                      color: '#3d4250',
                      fontSize: '12px'
                    }
                  },
                  labels: {
                    overflow: 'justify',
                    x: -20, /* 그래프와의 거리 조정 */
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  }
                },
                
                /* 범례 */
                legend: {
                  enabled: true,
                  align: 'right',
                  verticalAlign: 'top',
                  x: 10,
                  itemStyle: {
                    color: '#3d4250',
                    fontSize: '14px',
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
                  shared: true /* 툴팁 공유 */
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
                    stacking: 'normal'
                  }
                },
                
                /* 출처 */
                credits: {
                  enabled: false
                },
                
                /* 그래프 스타일 */
                series: [{
                  name: '인버터#1',
                  type: 'spline',
                  color: '#00bbe0',
                  tooltip: {
                    valueSuffix: 'kWh'
                  }
                }, {
                  name: '인버터#7',
                  type: 'spline',
                  color: '#7571f9',
                  tooltip: {
                    valueSuffix: 'kWh'
                  }
                }, {
                  name: '인버터#11',
                  type: 'spline',
                  color: '#007bff',
                  tooltip: {
                    valueSuffix: 'kWh'
                  }
                }]
                
              });
            });
          </script>
        </div>
        <!-- 데이터 추출용 -->
        <div class="chart_table2" style="display:none;">
          <table id="datatable3">
            <thead>
              <tr>
                <th>DC전력값</th>
                <th>인버터#1</th>
                <th>인버터#7</th>
                <th>인버터#11</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th>100</th>
                <td>10</td>
                <td>80</td>
                <td>30</td>
              </tr>
              <tr>
                <th>200</th>
                <td>70</td>
                <td>60</td>
                <td>50</td>
              </tr>
              <tr>
                <th>300</th>
                <td>60</td>
                <td>20</td>
                <td>40</td>
              </tr>
              <tr>
                <th>400</th>
                <td>70</td>
                <td>20</td>
                <td>40</td>
              </tr>
              <tr>
                <th>500</th>
                <td>50</td>
                <td>20</td>
                <td>20</td>
              </tr>
              <tr>
                <th>600</th>
                <td>30</td>
                <td>20</td>
                <td>50</td>
              </tr>
              <tr>
                <th>700</th>
                <td>60</td>
                <td>40</td>
                <td>20</td>
              </tr>
              <tr>
                <th>800</th>
                <td>60</td>
                <td>50</td>
                <td>20</td>
              </tr>
              <tr>
                <th>900</th>
                <td>15</td>
                <td>20</td>
                <td>70</td>
              </tr>
              <tr>
                <th>1000</th>
                <td>55</td>
                <td>20</td>
                <td>35</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  <div class="row usage_chart_table">
    <div class="col-lg-12">
      <div class="indiv">
        <table class="his_tbl">
          <thead>
            <tr>
              <th>설비명</th>
              <th>설비ID</th>
              <th>사업소</th>
              <th>상태</th>
              <th><input type="checkbox" name="" id="hchk1" class="his_chk"><label for="hchk1">DC전압</label></th>
              <th><input type="checkbox" name="" id="hchk2" class="his_chk"><label for="hchk2">DC전류</label></th>
              <th><input type="checkbox" name="" id="hchk3" class="his_chk"><label for="hchk3">DC전력</label></th>
              <th><input type="checkbox" name="" id="hchk4" class="his_chk"><label for="hchk4">현재출력</label></th>
              <th><input type="checkbox" name="" id="hchk5" class="his_chk" checked><label for="hchk5">금일발전량</label>
              </th>
              <th><input type="checkbox" name="" id="hchk6" class="his_chk" checked><label for="hchk6">누적발전량</label>
              </th>
              <th><input type="checkbox" name="" id="hchk7" class="his_chk"><label for="hchk7">AC전압R</label></th>
              <th><input type="checkbox" name="" id="hchk8" class="his_chk"><label for="hchk8">AC전압S</label></th>
              <th><input type="checkbox" name="" id="hchk9" class="his_chk"><label for="hchk9">AC전압T</label></th>
              <th><input type="checkbox" name="" id="hchk10" class="his_chk"><label for="hchk10">역률</label></th>
              <th><input type="checkbox" name="" id="hchk11" class="his_chk"><label for="hchk11">주파수</label></th>
              <th><input type="checkbox" name="" id="hchk12" class="his_chk"><label for="hchk12">온도</label></th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>IVT001</td>
              <td>사업소#1</td>
              <td>Connect</td>
              <td>20</td>
              <td>10</td>
              <td>20</td>
              <td>20</td>
              <td>180</td>
              <td>400</td>
              <td>20</td>
              <td>20</td>
              <td>20</td>
              <td>1</td>
              <td>62</td>
              <td>35</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>