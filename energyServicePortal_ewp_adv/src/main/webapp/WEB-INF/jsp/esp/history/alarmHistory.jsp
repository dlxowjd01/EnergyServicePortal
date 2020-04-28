<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">알람 이력</h1>
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
    <div class="indiv his_chart_top clear">
      <div class="fl">
        <span class="tx_tit">설비 유형</span>
        <div class="sa_select">
          <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">전체
              <span class="caret"></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
              <li class="dropdown_cov type">
                <div class="sec_li_bx">
                  <p class="tx_li_tit">사업소별</p>
                  <a href="#" tabindex="-1">
                    <input type="checkbox" id="type_1" value="INV_PV">
                    <label for="type_1"><span></span>태양광 인버터</label>
                  </a>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div class="fl">
        <span class="tx_tit">알람 타입</span>
        <div class="sa_select">
          <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">전체
              <span class="caret"></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
              <li>
                <a href="#" tabindex="-1">
                  <input type="checkbox" id="type_11" value="경고">
                  <label for="type_11"><span></span>경고</label>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div class="fl">
        <span class="tx_tit">조회 기간</span>
        <div class="sa_select">
          <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">15분
              <span class="caret"></span></button>
            <ul class="dropdown-menu" id="term">
              <li><a href="#" data-value="1">1일</a></li>
              <li class="on"><a href="#" data-value="15">1주</a></li>
              <li><a href="#" data-value="hour">1월</a></li>
              <li><a href="#" data-value="day">1년</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div class="fl">
        <span class="tx_tit">기간 설정</span>
        <div class="sel_calendar">
          <input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
          <em>-</em>
          <input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
        </div>
      </div>
      <div class="fl">
        <button type="button" id="search" class="btn_type">조회</button>
      </div>
    </div>
  </div>
</div>
<div class="row">
  <div class="col-lg-8">
    <div class="indiv">
      <div class="his_chart_top clear">
        <div class="clear">
          <h2 class="s_tit">알람 현황</h2>
        </div>
        <!-- 기본 항목 -->
        <div class="clear">
          <!-- 우측 항목 -->
          <div class="fr his_inp_bx">
            <div class="rdo_type his_rdo_bx">
							<span>
								<input type="radio" id="rdo03_1" name="rdo_btn22" value="시계열 분석" checked>
								<label for="rdo03_1"><span></span>설비 타입</label>
							</span>
              <span>
								<input type="radio" id="rdo03_2" name="rdo_btn22" value="상관 분석">
								<label for="rdo03_2"><span></span>알람 타입</label>
							</span>
            </div>
          </div>
        </div>
      </div>
      <br>
      <br>
      <div class="inchart">
        <div id="hchart2"></div>
        <script type="text/javascript">
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
  <div class="col-lg-4 chart_area">
    <div class="indiv">
      <!-- [D] 차트 개발 시, style 삭제해주세요 -->
      <div class="inchart" style="width:100%;height:200px;background:#ddd">
        차트영역
      </div>
      <!-- [D] 컬러별로 't1 ~ t9' 클래스 추가 -->
      <div class="chart_legend_area">
        <!-- [D] 두 줄 정렬일 때 ''col 클래스 추가 -->
        <ul class="chart_legend col">
          <li>
            <div><p class="bu t1">PCS</p><span class="value">8건</span></div>
          </li>
          <li>
            <div><p class="bu t2">접속반</p><span class="value">8건</span></div>
          </li>
          <li>
            <div><p class="bu t3">BMS</p><span class="value">8건</span></div>
          </li>
          <li>
            <div><p class="bu t4">환경센서</p><span class="value">8건</span></div>
          </li>
          <li>
            <div><p class="bu t5">태양광 인버터</p><span class="value">8건</span></div>
          </li>
          <li>
            <div><p class="bu t6">계량기</p><span class="value">8건</span></div>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="row usage_chart_table">
  <div class="col-lg-12">
    <div class="indiv">
      <div class="tbl_wrap_type">
        <div class="tbl_top clear">
          <h2 class="ntit fl">접속반</h2>
        </div>
        <table class="his_tbl">
          <thead>
            <tr>
              <th>
                <button class="btn_align up">장비 타입</button>
              </th>
              <th>
                <button class="btn_align up">장치명</button>
              </th>
              <th>
                <button class="btn_align up">장치 ID</button>
              </th>
              <th>
                <button class="btn_align up">알람 시간</button>
              </th>
              <th>
                <button class="btn_align up">알람 타입</button>
              </th>
              <th>
                <button class="btn_align down">알림 메시지</button>
              </th>
              <th>
                <button class="btn_align down">알림 상태</button>
              </th>
              <th>
                <button class="btn_align down">조치 상태</button>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>인버터#1</td>
              <td>사업소#1</td>
              <td>IVT001</td>
              <td>2020.02.20 15:00:00</td>
              <td>Connect</td>
              <td>Over Cell Voltage</td>
              <td>발생</td>
              <td>On Hold</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>사업소#1</td>
              <td>IVT001</td>
              <td>2020.02.20 15:00:00</td>
              <td>Connect</td>
              <td>Over Cell Voltage</td>
              <td>발생</td>
              <td>On Hold</td>
            </tr>
          </tbody>
        </table>
        <div class="tbl_top clear">
          <h2 class="ntit fl">환경센서</h2>
        </div>
        <table class="his_tbl">
          <thead>
            <tr>
              <th>
                <button class="btn_align up">장비 타입</button>
              </th>
              <th>
                <button class="btn_align up">장치명</button>
              </th>
              <th>
                <button class="btn_align up">장치 ID</button>
              </th>
              <th>
                <button class="btn_align up">알람 시간</button>
              </th>
              <th>
                <button class="btn_align up">알람 타입</button>
              </th>
              <th>
                <button class="btn_align down">알림 메시지</button>
              </th>
              <th>
                <button class="btn_align down">알림 상태</button>
              </th>
              <th>
                <button class="btn_align down">조치 상태</button>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>인버터#1</td>
              <td>사업소#1</td>
              <td>IVT001</td>
              <td>2020.02.20 15:00:00</td>
              <td>Connect</td>
              <td>Over Cell Voltage</td>
              <td>발생</td>
              <td>On Hold</td>
            </tr>
            <tr>
              <td>인버터#1</td>
              <td>사업소#1</td>
              <td>IVT001</td>
              <td>2020.02.20 15:00:00</td>
              <td>Connect</td>
              <td>Over Cell Voltage</td>
              <td>발생</td>
              <td>On Hold</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>