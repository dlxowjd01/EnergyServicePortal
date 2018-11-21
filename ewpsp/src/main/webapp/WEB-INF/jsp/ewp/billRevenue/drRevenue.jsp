<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="/js/printThis.js" type="text/javascript"></script>
<script src="../js/billRevenue/drRevenue.js" type="text/javascript"></script>
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
						<h1 class="page-header">DR 수익 조회</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">DR 수익 합계</h2>
							<ul class="chart_total">
								<li class="ct1">
									<div class="ctit ct1"><span>총 정산금액</span></div>
									<div class="cval" id="drRevenueTot1"><span>0</span>won</div>
								</li>
								<li>
									<div class="ctit"><span>고객 할인금액</span></div>
									<div class="cval" id="drRevenueTot2"><span>0</span>won</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv income_dr_chart">
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
									                return  '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%Y-%m ', new Date(this.x)) + 
									                	'월<br/><span style="color:#438fd7">' + this.y + ' won</span>';
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
									        color: '#438fd7' /* 총 정산금액 */
									    },{
									        color: '#84848f' /* 고객 할인금액 */
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
				<div class="row income_dr_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">DR 수익 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn" onclick="excelDownload('DR수익조회', event);">데이터저장</a></li>
									<li><a href="javascript:popupOpen('dprint');" class="default_btn">명세서 확인하기</a></li>
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
    <div id="layerbox" class="dprint clear drRevenueStatement" style="margin-top:250px;width:880px;">
    	<div class="lbutton fl">
			<a href="javascript:getPdfDownload();" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="javascript:commonPrint();" id="drRevenueBtnPrint" class="lbtn_print"><span>인쇄</span></a>
		</div>
        <div class="ltit fr">      	
			<a href="javascript:popupClose('dprint');">닫기</a>
        </div>
		<div class="lbody mt30" id = "printArea">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;" id="texBill">
						DR (수요반응) 수익 배분 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : ${selViewSite.site_name }</td>
					<td height="30" align="right" style="font-size:12px;" id ="texDay">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
						이번 달 청구 금액은 <span class="dp_total">220,000</span>원 입니다
						<p style="padding-top:10px;font-size:12px;font-weight:normal;">(수익배분기간 : 2018-01-01 ~ 2018-12-31)</p>
					</td>
				</tr>
			</table>

			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%;">
					<h2>1. 청구내역</h2>
					<table class="tbl texArea" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>금액</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>용량 정산금</th>
								<td align="right">900,000</td>
							</tr>
							<tr>
								<th>감축 정산금</th>
								<td align="right">100,000</td>
							</tr>
							<tr>
								<th>총 정산금액</th>
								<td align="right">1,000,000</td>
							</tr>
							<tr>
								<th>고객 정산 금액</th>
								<td align="right">800,000</td>
							</tr>
							<tr>
								<th>①수익배분 계</th>
								<td align="right">200,000</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">20,006</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">-6</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>청구금액</th>
								<td align="right">220,000</td>
							</tr>
						</tfoot>
					</table>

					<h2 style="margin-top:20px">3. 수익분배 계산 내역</h2>
					<table class="tbl beneArea" style="margin-top:10px;">
						<thead>
							<tr>
								<th>구분</th>
								<th>계산 내역</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>①수익배분 계</th>
								<td>총 정산금액 x 수익배분(0.2)</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="fr" style="width:49%;">
					<h2>2. 감축 정보</h2>
					<table class="tbl saveArea" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>감축횟수-시간 (회-시간)</th>
								<td>1-2</td>
							</tr>
							<tr>
								<th>감축 이행 용량 (kWh)</th>
								<td>200</td>
							</tr>
							<tr>
								<th>감축 인정 용량 (kWh)</th>
								<td>16</td>
							</tr>
							<tr>
								<th>감축 이행율 (%)</th>
								<td>80</td>
							</tr>
							<tr>
								<th>수익 배분 (%)</th>
								<td>20</td>
							</tr>
						</tbody>
					</table>

					<h2 style="margin-top:20px;">4. 납입처</h2>
					<table class="tbl infoArea" style="margin-top:10px;">
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

		
			<h2 style="margin-top:20px">5. 최근 6개월 수익 내역</h2>
			<div class="inchart">
				<div id="ly_chart_dr" style="max-width:800px;height:250px;"></div>
				<script language="JavaScript"> 
	// 			$(function () { 
					var myChart1 = Highcharts.chart('ly_chart_dr', {
	// 					data: {
	// 				        table: 'ly_datatable_dr' /* 테이블에서 데이터 불러오기 */
	// 				    },
	
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
									fontSize: '13px'
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
						        x:25, /* 타이틀 위치 조정 */
						        style: {
						            color: '#3d4250',
						            fontSize: '13px'
						        }
						    },
						    labels: {
						        overflow: 'justify',
						        x:-20, /* 그래프와의 거리 조정 */
						        style: {
						            color: '#3d4250',
						            fontSize: '13px'
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
						        fontSize: '13px',
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
					        color: '#438fd7' /* 총 정산금액 */
					    },{
					        color: '#84848f' /* 고객 할인금액 */
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
	// 			});
				</script>
			</div>
			<!-- 데이터 추출용 -->
			<div class="lychart_table" style="display:none;">			
				<table id="ly_datatable_dr">
				    <thead>
				        <tr>
				            <th>2018-08</th>
				            <th>총 정산금액</th>
				            <th>고객 할인금액	</th>
				        </tr>
				    </thead>
				    <tbody>
				        <tr>
				            <th>1월</th>
				            <td>1000000</td>
				            <td>800000</td>
				        </tr>
				        <tr>
				            <th>2월</th>
				            <td>1000000</td>
				            <td>800000</td>
				        </tr>
				        <tr>
				            <th>3월</th>
				            <td>1000000</td>
				            <td>800000</td>
				        </tr>
				        <tr>
				            <th>4월</th>
				            <td>1000000</td>
				            <td>800000</td>
				        </tr>
				        <tr>
				            <th>5월</th>
				            <td>1000000</td>
				            <td>800000</td>
				        </tr>
				        <tr>
				            <th>6월</th>
				            <td></td>
				            <td></td>
				        </tr>
				    </tbody>
				</table>			
			</div>
		</div>
    </div>
    <!-- ###### Popup End ###### -->




    
</body>
</html>