<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title> -->
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
</head>
<body>

<jsp:include page="../include/layout/header.jsp" />




<div class="container-fluid">

	<div class="c_top clear" id="engy_monitoring_search">
		<jsp:include page="../include/engy_monitoring_search.jsp">
			<jsp:param value="ESS 충/방전량 조회" name="subTitle"/>
		</jsp:include>
	</div>

	<div class="c_chart">
		<div class="inchart">
			<div id="chart2"></div>		
			<script language="JavaScript"> 
			$(function () { 
				var myChart = Highcharts.chart('chart2', {
					data: {
				        table: 'datatable' /* 테이블에서 데이터 불러오기 */
				    },
					chart: {
						marginTop: 40,
						marginRight: 30,
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
							reserveSpace: true,
							style: {
								color: '#ffffff',
								fontSize: '16px'
							}
						},
						crosshair: true,
						tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
						title: {
							text: null
							},
						/* 기준선 */
						plotLines: [{
				                value: 21, /* 현재 */
				                color: '#56a1ea',
				                width: 2,
				                zIndex: 0,
				                label: {
				                     text: ''
				                }
				            }]
					},

					yAxis: {
						gridLineWidth: 1, /* 기준선 grid 안보이기 */
					    title: {
					        text: 'kwh',
					        align: 'low',
					        rotation: 0, /* 타이틀 기울기 */
					        y:25, /* 타이틀 위치 조정 */
					        x:15, /* 타이틀 위치 조정 */
					        style: {
					            color: '#ffffff',
					            fontSize: '16px'
					        }
					    },
					    labels: {
					        overflow: 'justify',
					        x:-10, /* 그래프와의 거리 조정 */
					        style: {
					            color: '#ffffff',
					            fontSize: '16px'
					        }
					    }
					},

				    /* 범례 */
							    legend: {
							    	itemStyle: {
							            color: '#ffffff',
							            fontSize: '16px',
							            fontWeight: 400
							        },
							        itemHoverStyle: {
							            color: '#ffffff' /* 마우스 오버시 색 */
							        },
							        symbolPadding:5, /* 심볼 - 텍스트간 거리 */
							        symbolHeight:10 /* 심볼 크기 */

							    },
					/* 툴팁 */
					tooltip: {
						    formatter: function() {
				                return  '<b>' + this.series.name + '</b><br/>' + this.x + '<br/><span style="color:#fd5c06">' + this.y + ' kwh</span>';
				            }
						},
				    plotOptions: {
				        series: {
				            label: {
				                connectorAllowed: false
				            },
				            borderWidth: 0 /* 보더 0 */
				        },
				        column: {
						            stacking: 'normal',
						            dataLabels: {
						                enabled: false, /* 막대 안 라벨 보이지 않기 */
						                inside: true, /* 막대 안으로 라벨 수치 넣기 */
						                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
						            }
						},
				        line: {
						        marker: {
						            enabled: false /* 마커 안보이기 */
						        }
						    }
				    },				    
				    credits: {
						enabled: false
					},
				    series: [{
				    	type: 'column',
				        name: '충전량',
				        color: '#56a1ea'
				    },{
				    	type: 'line',
				        name: '충전 계획',
				        color: '#f7a35c',
				        dashStyle: 'ShortDash'
				    },{
				    	type: 'column',
				        name: '방전량',
				        color: '#f15c80'
				    },{
				    	type: 'line',
				        name: '방전 계획',
				        color: '#83838e',
				        dashStyle: 'ShortDash'
				    }]

				});
			});
			</script>
		</div>

		<div class="tbl_wrap">
			<!-- PC 버전용 테이블  -->
			<div class="chart_table">			
				<table class="pc_use">
					<tbody>
						<tr>
							<th>충전량</th>
							<td>100</td>
							<td>150</td>
							<td>200</td>
							<td>300</td>
							<td>400</td>
							<td>500</td>
							<td>600</td>
							<td>700</td>
							<td>800</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td>50</td>
							<td>100</td>
							<td>300</td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>충전 계획</th>
							<td>100</td>
							<td>200</td>
							<td>400</td>
							<td>350</td>
							<td>450</td>
							<td>700</td>
							<td>400</td>
							<td>750</td>
							<td>900</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td>60</td>
							<td>120</td>
							<td>250</td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>방전량</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td>-900</td>
							<td>-800</td>
							<td>-700</td>
							<td>-500</td>
							<td>-400</td>
							<td>-300</td>
							<td>-200</td>
							<td>-100</td>
							<td>-50</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>방전 계획</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td>-800</td>
							<td>-820</td>
							<td>-600</td>
							<td>-550</td>
							<td>-700</td>
							<td>-400</td>
							<td>-220</td>
							<td>-150</td>
							<td>-100</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</tbody>
				</table>	
			</div>
			<!-- 모바일 버전용 테이블 (데이터 추출은 이곳에서) -->
			<div class="chart_table2" style="display:none;">			
				<table id="datatable" class="mobile_use mt10">
					<colgroup>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
				    <thead>
				        <tr>
				            <th>시간</th>
				            <th>충전량</th>
				            <th>충전 계획</th>
				            <th>방전량</th>
				            <th>방전 계획</th>
				        </tr>
				    </thead>
				    <tbody>
				        <tr>
				            <th>01</th>
				            <th>100</th>
				            <th>100</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>02</th>
				            <th>150</th>
				            <th>200</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>03</th>
				            <th>200</th>
				            <th>400</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>04</th>
				            <th>300</th>
				            <th>350</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>05</th>
				            <th>400</th>
				            <th>450</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>06</th>
				            <th>500</th>
				            <th>700</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>07</th>
				            <th>600</th>
				            <th>400</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>08</th>
				            <th>700</th>
				            <th>750</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>09</th>
				            <th>800</th>
				            <th>900</th>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>10</th>
				            <th></th>
				            <th></th>
				            <td>-900</td>
				            <td>-800</td>
				        </tr>
				        <tr>
				            <th>11</th>
				            <td></td>
				            <td></td>
				            <td>-800</td>
				            <td>-820</td>
				        </tr>
				        <tr>
				            <th>12</th>
				            <td></td>
				            <td></td>
				            <td>-700</td>
				            <td>-600</td>
				        </tr>
				        <tr>
				            <th>13</th>
				            <td></td>
				            <td></td>
				            <td>-500</td>
				            <td>-550</td>
				        </tr>
				        <tr>
				            <th>14</th>
				            <td></td>
				            <td></td>
				            <td>-400</td>
				            <td>-700</td>
				        </tr>
				        <tr>
				            <th>15</th>
				            <td></td>
				            <td></td>
				            <td>-300</td>
				            <td>-400</td>
				        </tr>
				        <tr>
				            <th>16</th>
				            <td></td>
				            <td></td>
				            <td>-200</td>
				            <td>-220</td>
				        </tr>
				        <tr>
				            <th>17</th>
				            <td></td>
				            <td></td>
				            <td>-100</td>
				            <td>-150</td>
				        </tr>
				        <tr>
				            <th>18</th>
				            <td></td>
				            <td></td>
				            <td>-50</td>
				            <td>-100</td>
				        </tr>
				        <tr>
				            <th>19</th>
				            <td>50</td>
				            <td>60</td>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>20</th>
				            <td>100</td>
				            <td>120</td>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>21</th>
				            <td>300</td>
				            <td>250</td>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>22</th>
				            <td></td>
				            <td></td>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>23</th>
				            <td></td>
				            <td></td>
				            <td></td>
				            <td></td>
				        </tr>
				        <tr>
				            <th>24</th>
				            <td></td>
				            <td></td>
				            <td></td>
				            <td></td>
				        </tr>
				    </tbody>
				</table>			
			</div>
		</div>
		<div class="fold_btn">
			<a href="#;" class="on">표 접기</a>
		</div>
		<div class="mt50 clear">
			<div class="chart_menu fl">
				<span><a href="#;"><img src="../img/data_save.png" alt=""> 데이터 저장하기</a></span>
			</div>
			<ul class="chart_total fr">
				<li>누적 충전량 <span><em>1,500</em> kwh</span></li>
				<li>누적 방전량 <span><em>800</em> kwh</span></li>
			</ul>
		</div>
	</div>

</div>



<script>
$(document).ready(function(){
	/* 표 접기/펼치기 */
    $('.fold_btn a').click(function(){
        $('.tbl_wrap').toggle();
        $(this).parent().toggleClass("on");
        if ($('.tbl_wrap').css('display') == 'none') {
            $(this).html('표 펼치기');
        } else {
            $(this).html('표 접기');
        }
    });
});
</script>



<jsp:include page="../include/layout/footer.jsp" />

</body>
</html>