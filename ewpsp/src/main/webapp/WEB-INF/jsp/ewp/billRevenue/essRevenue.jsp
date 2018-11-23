<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="/js/printThis.js" type="text/javascript"></script>
<script src="../js/billRevenue/essRevenue.js" type="text/javascript"></script>
</head>
<body>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="billRevenue" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">ESS 수익 조회</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">ESS 수익 합계</h2>
							<ul class="chart_total">
								<li class="ct1">
									<div class="ctit ct1"><span>고객 정산금액</span></div>
									<div class="cval" id="essRevenueTot1"><span>0</span>won</div>
								</li>
								<li>
									<div class="ctit"><span>실적 할인금액</span></div>
									<div class="cval" id="essRevenueTot2"><span>0</span>won</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv income_ess_chart">
							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="billRevenue" name="schGbn"/>
							</jsp:include>
							<div class="inchart-nodata" style="display: none;">
								<span>조회 결과가 없습니다.</span>
							</div>
							<div class="inchart">
								<div id="chart2"></div>
								<script language="JavaScript"> 
// 								$(function () { 
									var myChart = Highcharts.chart('chart2', {
// 										data: {
// 									        table: 'datatable' /* 테이블에서 데이터 불러오기 */
// 									    },

										chart: {
											marginLeft:80,
											marginRight:0,
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
												}
										},

										yAxis: {
											gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
										    title: {
										    	text: 'won',
										    	align: 'low',
										    	rotation: 0, /* 타이틀 기울기 */
										        y:25, /* 타이틀 위치 조정 */
										        x:5, /* 타이틀 위치 조정 */
										        style: {
										            color: '#3d4250',
										            fontSize: '18px'
										        }
										    },
										    labels: {
										        overflow: 'justify',
										        x:-20, /* 그래프와의 거리 조정 */
										        style: {
										            color: '#3d4250',
										            fontSize: '14px'
										        }
										    }
										},	

									    /* 범례 */
										legend: {
											enabled: true,
											align:'right',
											verticalAlign:'top',									
											itemStyle: {
										        color: '#3d4250',
										        fontSize: '16px',
										        fontWeight: 400
										    },
										    itemHoverStyle: {
										        color: '' /* 마우스 오버시 색 */
										    },
										    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
										    symbolHeight:8 /* 심볼 크기 */
										},

										/* 툴팁 */
										tooltip: {
											    formatter: function() {
									                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m ', new Date(this.x)) 
									                	+ '월<br/><span style="color:#438fd7">' + this.y + ' won</span>';
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
												  stacking: '' /*위로 쌓이는 막대  ,normal */
											}
									    },

									    /* 출처 */
									    credits: {
											enabled: false
										},

									    /* 그래프 스타일 */
									    series: [{
									        color: '#438fd7' /* 고객 정산금액 */
									    },{
									        color: '#84848f' /* 실적 할인금액 */
									    }],

									    /* 반응형 */
									    responsive: {
									        rules: [{
									            condition: {
									                maxWidth: 414 /* 차트 사이즈 */									                
									            },
									            chartOptions: {
									            	chart: {
									            		marginLeft:80,
									            		marginTop:30
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
															x:-10, /* 그래프와의 거리 조정 */
													        style: {
													            fontSize: '13px'
													        }
														}
													},
									                legend: {									                    
									                    layout: 'horizontal',
									                    verticalAlign: 'bottom',
									                    align:'center',
									                    x:0,
									                    itemStyle: {
												        	fontSize: '13px'
												    	}
									                }
									            }
									        }]
									    }

									});
// 								});
								</script>
							</div>	
						</div>
					</div>
				</div>
				<div class="row income_ess_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">ESS 수익 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn" onclick="excelDownload('ESS수익조회', event);">데이터저장</a></li>
									<li><a href="#" class="default_btn"  id="ESSRevenueTex">명세서 확인하기</a></li>
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
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




    <!-- ###### 명세서 확인 및 출력 Popup Start ###### -->
    <script type="text/javascript">
        $(function(){
            $(".default_btn").on('click',function(){
            	 $(".lbutton").show();
            });
            
            $(".lbtn_pdf").on('click',function(){
            	$(".lbutton").hide();
            });
            
            $('.lbtn_print').on('click', function(){
            	$('#layerbox').css("left", "0px");
                $('#layerbox').css("top", "-300px");
                $(".lbutton").hide();
            	$('#layerbox').printThis({
	        	});
            });
        });
    </script>
     <div id="layerbox" class="dprint clear essRevenueStatement" style="margin-top:300px;width:880px;">
    	<div class="lbutton fl">
			<a href="javascript:getPdfDownload();" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="javascript:commonPrint();" id="essRevenueBtnPrint" class="lbtn_print"><span>인쇄</span></a>
		</div>
        <div class="ltit fr">      	
			<a href="javascript:popupClose('dprint');">닫기</a>
        </div>
		<div class="lbody mt30" id="printArea">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;" id="texBill">
						에너지절감 솔루션 제공 전기요금 절감 수익 배분 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : ${selViewSite.site_name }</td>
					<td height="30" align="right" style="font-size:12px;" id ="texDay">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
						이번 달 청구 금액은 <span class="dp_total">30,439,360</span>원 입니다
						<p style="padding-top:10px;font-size:12px;font-weight:normal;">(수익배분기간 : 2018-01-01 ~ 2018-12-31)</p>
					</td>
				</tr>
			</table>

			<div class="clear" style="margin-top:20px">
				<div class="fl" style="width:49%;">
					<h2>1. 청구금액</h2>
					<table class="tbl texArea" style="margin-top:10px">
						<thead>
							<tr>
								<th>구 분</th>
								<th>절감금액</th>
								<th>수익배분</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>①기본 요금 절감(피크저감)</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>②전려량 요금 절감(계시별)</th>
								<td align="right">3,188076</td>
								<td align="right">2,869,268</td>
							</tr>
							<tr>
								<th>③ESS 충전 요금 할인</th>
								<td align="right">2,227,088</td>
								<td align="right">2,004,379</td>
							</tr>
							<tr>
								<th>④ESS 전용 요금 할인</th>
								<td align="right">25,311,670</td>
								<td align="right">22,798,503</td>
							</tr>
							<tr>
								<th>총   계</th>
								<td align="right">30,746,834</td>
								<td align="right">27,672,151</td>
							</tr>
							<tr>
								<th colspan="2">수익배분 계</th>
								<td align="right">27,672,151</td>
							</tr>
							<tr>
								<th colspan="2">부가가치세</th>
								<td align="right">2,767,215</td>
							</tr>
							<tr>
								<th colspan="2">원단위절사</th>
								<td align="right">-6</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th colspan="2">청구금액</th>
								<td align="right">30,439,360</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div class="fr" style="width:49%;">
					<h2>2. ESS 충방전량 및 전력량 요금 절감내역</h2>
					<table class="tbl texSaveArea" style="margin-top:10px">
						<thead>
							<tr>
								<th colspan="2">ESS</th>
								<th>사용량</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th rowspan="4">충전</th>
								<th>경부하</th>
								<td align="right">81,728</td>
								<td align="right">4,454,176</td>
							</tr>
							<tr>
								<th>중간부하</th>
								<td align="right">1,008</td>
								<td align="right">77,515</td>
							</tr>
							<tr>
								<th>최대부하</th>
								<td align="right">41</td>
								<td align="right">4,395</td>
							</tr>
							<tr>
								<th>계</th>
								<td align="right">82,777</td>
								<td align="right">4,536,086</td>
							</tr>
							<tr>
								<th rowspan="4">방전</th>
								<th>경부하</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>중간부하</th>
								<td align="right">9,847</td>
								<td align="right">757,234</td>
							</tr>
							<tr>
								<th>최대부하</th>
								<td align="right">64,990</td>
								<td align="right">6,966,928</td>
							</tr>
							<tr>
								<th>계</th>
								<td align="right">74,837</td>
								<td align="right">7,724,162</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th colspan="3" style="font-size:12px;">②충방전 전력량요금 절감금액)(방전 – 충전금액)</th>
								<td align="right">3,188,076</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>

			<h2 style="margin-top:20px">3. ESS 피크저감, 충전, 전용 요금 할인 계산 내역</h2>
			<table class="tbl calcArea" style="margin-top:10px">
				<thead>
					<tr>
						<th>구 분</th>
						<th>금액</th>
						<th>계산 내역</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>①기본 요금 절감(피크저감)</th>
						<td align="right">0</td>
						<td>ESS 피크저감 효과가 전기요금에 반영되는 시점부터 적용</td>
					</tr>
					<tr>
						<th>③ESS 충전 요금 할인</th>
						<td align="right">2,227,088</td>
						<td>(81,728 kW x 0.5 x 54.5 원 x 1) </td>
					</tr>
					<tr>
						<th>④ESS 방전 요금 할인</th>
						<td align="right">25,331,670</td>
						<td>Min[(40,527 kW x 8,190 원), (((64,990 kW – 41 kW) / (21 일 x 3)) x 3 x 1 x 8,190 원)] </td>
					</tr>
				</tbody>
			</table>
			<p style="font-size:12px;padding:10px 0;">※ ESS 충전, 전용 요금 할인은 당월 계량지침 및 고지서 기준 준용 산출(평균 사용량 계산은 소수점 첫째 자리 사사오입 적용)</p>

			<h2 style="margin-top:10px">4. 고객 사항</h2>
			<div class="clear" style="margin-top:10px">
				<div class="fl" style="width:42%;">
					<table class="tbl typeArea">							
						<tbody>
							<tr>
								<th>전기사용 계약종별</th>
								<td>산엽용(을) 고압B 선택 III</td>
							</tr>
							<tr>
								<th>기본요금</th>
								<td>8,190</td>
							</tr>							
						</tbody>
					</table>
				</div>
				<div class="fr" style="width:56%;">
					<table class="tbl">
						<tbody>
							<tr>
								<th>ESS 구축 용량</th>
								<td>ESS Battery : 3.6 MWh, PCS : 1.5 MW</td>
							</tr>
							<tr>
								<th>할인금액 차등비율(가중치)</th>
								<td>1</td>
							</tr>							
						</tbody>
					</table>
				</div>
			</div>
			
			<div class="clear" style="margin-top:20px">
				<div class="fl" style="width:56%">
					<h2>5. 전기요금 절감효과</h2>
					<div class="inchart">
						<div id="ly_chart_ess" style="max-width:445px;height:169px"></div>
						<script language="JavaScript"> 
						//$(function () { 
							Highcharts.setOptions({
						        lang: {
						            decimalPoint: '.',
						            thousandsSep: ','
						        }
						    });
							var myChart1 = Highcharts.chart('ly_chart_ess', {
							    chart: {
							    	marginTop:0,
									marginBottom:10,
							        plotBackgroundColor: null,
							        plotBorderWidth: null,
							        plotShadow: false,
							        backgroundColor: 'transparent',
							        type: 'pie'
							    },
							    navigation: {
									buttonOptions: {
									  enabled: false /* 메뉴 안보이기 */
									  }
								},
							    title: {
							        text: ''
							    },
							    tooltip: {
							        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
							    },
							    plotOptions: {
							        pie: {
							            allowPointSelect: true,
							            cursor: 'pointer',
							            dataLabels: {
							                enabled: true,
							                format: '<b>{point.name}</b> : {point.y:,.0f} <br/> {point.percentage:.1f} %',
							                style: {
							                    color: '#3d4250'
							                }
							            }
							        }
							    },
							    credits: {
									enabled: false
								},
							   /*  series: [{
							        name: '전기요금 절감효과',
							        colorByPoint: true,
							        data: [{
							            name: '②',
							            y: 3188076
							        }, {
							            name: '③',
							            y: 2227088
							        }, {
							            name: '④',
							            y: 25331670
							        }]
							    }] */
							});
						//});
						</script>						
					</div>
				</div>
				<div class="fr" style="width:42%">
					<h2>6. 납입처</h2>
					<table class="tbl infoArea" style="margin-top:10px;">
						<colgroup>
							<col width="40%">
							<col width="60%">
						</colgroup>
						<tbody>
							<tr>
								<th>은행명</th>
								<td>우리은행</td>
							</tr>
							<tr>
								<th>계좌번호</th>
								<td>1005 – 802 - 498030</td>
							</tr>
							<tr>
								<th>예금주</th>
								<td>한국동서발전㈜</td>
							</tr>
							<tr>
								<th>납입금액</th>
								<td>30,439,360</td>
							</tr>
							<tr>
								<th>납기일</th>
								<td>2018-06-24</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

		</div>
    </div>
    <!-- ###### Popup End ###### -->





    
</body>
</html>