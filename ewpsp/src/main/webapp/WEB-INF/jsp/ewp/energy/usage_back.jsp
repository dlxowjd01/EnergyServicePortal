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
<script type="text/javascript">
	$(document).ready(function() {
		changeSelTerm('day');
		getCollect_sch_condition();
	});
	
	function getDBData(period, siteId, start, end) {
		getUsageRealList(period, siteId, start, end); // 실제사용량 조회
		getUsageFutureList(period, siteId, start, end); // 예측사용량 조회
		drawData();
	}
	
	function callback_getUsageRealList(result) {
		console.log("!!!!1 : "+result);
		var usageList = result.list;
		console.log(usageList);
	}
	
	function collback_getUsageFutureList(result) {
		console.log("@@@@@@ : "+result);
		var usageList = result.list;
		console.log(usageList);
	}
	
	function drawData() {
		console.log("여기서 그래프랑 표 그려야지");
	}
</script>
<body>

<jsp:include page="../include/layout/header.jsp" />




<div class="container-fluid">

	<div class="c_top clear" id="engy_monitoring_search">
		<jsp:include page="../include/engy_monitoring_search.jsp">
			<jsp:param value="사용량 현황" name="subTitle"/>
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
						labels: {
							align: 'center',
				            reserveSpace: true,
							style: {
								color: '#ffffff',
								fontSize: '16px'
							}
						},
						tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
						title: {
							text: null
							},
						/* 기준선 */
						plotLines: [{
				                value: 6, /* 현재 */
				                color: '#56a1ea',
				                width: 2,
				                zIndex: 0,
				                label: {
				                     text: ''
				                }
				            }]
					},

					yAxis: {
						gridLineWidth: 0, /* 기준선 grid 안보이기 */
					    min: 0,
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
					    },
					    /*기준선 */
					    plotLines: [{
				            color: '#7b7b8f',
				            width: 1,
				            value: 500
				        }]
					},

				    /* 범례 */
							    legend: {
							    	enabled: true,
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
				        color: '#56a1ea'
				    }, {
				        color: '#83838e',
				        dashStyle: 'ShortDash'
				    }]

				},
				/* 차트 변경 */
		        function (myChart) {
		            $('.chart_change_column').click(function () {

		                $(this).hide();
		                $('.chart_change_line').show();
		                myChart.series[0].update({
		                    type: "column"
		                });

		            });
		            $('.chart_change_line').click(function () {
		            	$(this).hide();
		            	$('.chart_change_column').show();
		                myChart.series[0].update({
		                    type: "line"
		                });

		            });
		        });
			});
			</script>
		</div>
		<div class="tbl_wrap">
			<!-- PC 버전용 테이블 -->
			<div class="chart_table">			
				<table class="pc_use">
					<tbody>
						<tr>
							<th>오늘 사용량</th>
							<td>400</td>
							<td>500</td>
							<td>550</td>
							<td>540</td>
							<td>550</td>
							<td>750</td>
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
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>예측 사용량</th>
							<td>200</td>
							<td>400</td>
							<td>300</td>
							<td>650</td>
							<td>480</td>
							<td>700</td>
							<td>620</td>
							<td>200</td>
							<td>400</td>
							<td>300</td>
							<td>650</td>
							<td>480</td>
							<td>700</td>
							<td>620</td>
							<td>200</td>
							<td>400</td>
							<td>300</td>
							<td>650</td>
							<td>480</td>
							<td>700</td>
							<td>620</td>
							<td>650</td>
							<td>480</td>
							<td>700</td>
							<td>620</td>
						</tr>
					</tbody>
				</table>	
			</div>
			<!-- 모바일 버전용 테이블 (데이터 추출은 이곳에서) -->
			<div class="chart_table2" style="display:none;">			
				<table id="datatable" class="mobile_use mt10">
					<colgroup>
						<col width="30%">
						<col width="35%">
						<col width="35%">
					</colgroup>
				    <thead>
				        <tr>
				            <th>시간</th>
				            <th>오늘 사용량</th>
				            <th>예측 사용량</th>
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
				            <td>550</td>
				            <td>300</td>
				        </tr>
				        <tr>
				            <th>3</th>
				            <td>540</td>
				            <td>650</td>
				        </tr>
				        <tr>
				            <th>4</th>
				            <td>540</td>
				            <td>650</td>
				        </tr>
				        <tr>
				            <th>5</th>
				            <td>550</td>
				            <td>480</td>
				        </tr>
				        <tr>
				            <th>6</th>
				            <td>750</td>
				            <td>700</td>
				        </tr>
				        <tr>
				            <th>7</th>
				            <td></td>
				            <td>620</td>
				        </tr>
				        <tr>
				            <th>8</th>
				            <td></td>
				            <td>200</td>
				        </tr>
				        <tr>
				            <th>9</th>
				            <td></td>
				            <td>400</td>
				        </tr>
				        <tr>
				            <th>10</th>
				            <td></td>
				            <td>300</td>
				        </tr>
				        <tr>
				            <th>11</th>
				            <td></td>
				            <td>650</td>
				        </tr>
				        <tr>
				            <th>12</th>
				            <td></td>
				            <td>480</td>
				        </tr>
				        <tr>
				            <th>13</th>
				            <td></td>
				            <td>700</td>
				        </tr>
				        <tr>
				            <th>14</th>
				            <td></td>
				            <td>620</td>
				        </tr>
				        <tr>
				            <th>15</th>
				            <td></td>
				            <td>200</td>
				        </tr>
				        <tr>
				            <th>16</th>
				            <td></td>
				            <td>400</td>
				        </tr>
				        <tr>
				            <th>17</th>
				            <td></td>
				            <td>300</td>
				        </tr>
				        <tr>
				            <th>18</th>
				            <td></td>
				            <td>650</td>
				        </tr>
				        <tr>
				            <th>19</th>
				            <td></td>
				            <td>480</td>
				        </tr>
				        <tr>
				            <th>20</th>
				            <td></td>
				            <td>700</td>
				        </tr>
				        <tr>
				            <th>21</th>
				            <td></td>
				            <td>620</td>
				        </tr>
				        <tr>
				            <th>22</th>
				            <td></td>
				            <td>650</td>
				        </tr>
				        <tr>
				            <th>23</th>
				            <td></td>
				            <td>480</td>
				        </tr>
				        <tr>
				            <th>24</th>
				            <td></td>
				            <td>700</td>
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
				<span>
					<a href="#;" class="chart_change_column"><img src="../img/graph_change.png" alt=""> 그래프 변경하기</a>
					<a href="#;" class="chart_change_line" style="display:none;"><img src="../img/graph_change.png" alt=""> 그래프 변경하기</a>
				</span>
			</div>
			<ul class="chart_total fr">
				<li>예측 사용량 <span><em>800</em> kwh</span></li>
				<li>현재 사용량 <span><em>800</em> kwh</span></li>
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