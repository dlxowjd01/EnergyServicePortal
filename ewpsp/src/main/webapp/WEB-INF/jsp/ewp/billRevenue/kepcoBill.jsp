<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/billRevenue/kepcoBill.js" type="text/javascript"></script>
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
						<h1 class="page-header">한전 요금 조회</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-2 use_total">
						<div class="indiv">
							<h2 class="ntit">한전 요금 합계</h2>
							<ul class="chart_total">
								<li class="ctt1">
									<div class="ctit ctt1"><span>기본요금</span></div>
									<div class="cval" id="kepcoBillTot1"><span>0</span>won</div>
								</li>
								<li class="ctt2">
									<div class="ctit ctt2"><span>사용요금(역률적용)</span></div>
									<div class="cval" id="kepcoBillTot2"><span>0</span>won</div>
								</li>
								<li class="ctt3">
									<div class="ctit ctt3"><span>전력산업기반기금</span></div>
									<div class="cval" id="kepcoBillTot3"><span>0</span>won</div>
								</li>
								<li class="ctt4">
									<div class="ctit ctt4"><span>부가세</span></div>
									<div class="cval" id="kepcoBillTot4"><span>0</span>won</div>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-lg-10">
						<div class="indiv income_kt_chart">
							<jsp:include page="../include/engy_monitoring_search.jsp">
								<jsp:param value="billRevenue" name="schGbn"/>
							</jsp:include>
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
									                return  '<b>' + this.series.name + '</b><br/>' + this.x + '월<br/><span style="color:#438fd7">' + this.y + ' won</span>';
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
									        color: '#438fd7' /* 기본요금 */
									    },{
									        color: '#13af67' /* 사용요금(역률 적용) */
									    },{
									        color: '#f75c4a' /* 전력산업기반기금 */
									    },{
									        color: '#84848f' /* 부가세 */
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
				<div class="row income_kt_chart_table">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="tbl_top clear">
								<h2 class="ntit fl">한전 요금 도표</h2>
								<ul class="fr">
									<li><a href="#;" class="save_btn" onclick="excelDownload('한전요금조회', event);">데이터저장</a></li>
									<li><a href="javascript:popupOpen('dprint');" class="default_btn">명세서 확인하기</a></li>
									<li><a href="#;" class="fold_btn">표접기</a></li>
								</ul>
							</div>
							<div class="tbl_wrap">
								<div class="fold_div" id="pc_use_dataDiv">
									<!-- PC 버전용 테이블 -->
									<div class="chart_table">			
										<table class="pc_use" id="pc_use_dataTable">
											<thead>
												<tr>
													<th>2018-08</th>
													<th>1월</th>
													<th>2월</th>
													<th>3월</th>
													<th>4월</th>
													<th>5월</th>
													<th>6월</th>
													<th>7월</th>
													<th>8월</th>
													<th>9월</th>
													<th>10월</th>
													<th>11월</th>
													<th>12월</th>
													<th>합계</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<th><div class="ctit ctt1"><span>기본요금</span></div></th>
													<td>6,847,360</td>
													<td>6,847,360</td>
													<td>6,847,360</td>
													<td>6,847,360</td>
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
													<th><div class="ctit wht"><span>역률</span></div></th>
													<td>1,202,618</td>
													<td>1,202,618</td>
													<td>1,202,618</td>
													<td>1,202,618</td>
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
													<th><div class="ctit ctt2"><span>사용요금</span></div></th>
													<td>35,233,601</td>
													<td>35,233,601</td>
													<td>35,233,601</td>
													<td>35,233,601</td>
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
													<th><div class="ctit wht"><span>전기요금합계</span></div></th>
													<td>1,202,618</td>
													<td>1,202,618</td>
													<td>1,202,618</td>
													<td>1,202,618</td>
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
													<th><div class="ctit ctt3"><span>전력산업기반기금</span></div></th>
													<td>1,554,960</td>
													<td>1,554,960</td>
													<td>1,554,960</td>
													<td>1,554,960</td>
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
													<th><div class="ctit ctt4"><span>부가세</span></div></th>
													<td>4,202,618</td>
													<td>4,202,618</td>
													<td>4,202,618</td>
													<td>4,202,618</td>
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
													<th><div class="ctit wht"><span>청구요금</span></div></th>
													<td>1,202,618</td>
													<td>1,202,618</td>
													<td>1,202,618</td>
													<td>1,202,618</td>
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
											</tbody>
										</table>	
									</div>
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
    <div id="layerbox" class="dprint clear" style="margin-top:350px;">
    	<div class="lbutton fl">
			<a href="#;" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="#;" class="lbtn_print"><span>인쇄</span></a>
		</div>
        <div class="ltit fr">      	
			<a href="javascript:popupClose('dprint');">닫기</a>
        </div>
		<div class="lbody mt30">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;">
						전기 요금 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : 고객Site_1</td>
					<td height="30" align="right" style="font-size:12px;">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="40" align="right" style="font-size:16px;font-weight:600;">이번 달 청구 금액은 <strong style="color:#438fd7">2,220,000</strong>원 입니다</td>
				</tr>
			</table>
			<table class="tbl" style="margin-top:10px;">
				<tbody>
					<tr>
						<th>전기사용장소</th>
						<td>울산광역시 울주군 온산읍 원산로 40</td>
					</tr>
					<tr>
						<th>고객번호</th>
						<td>10 0000 0001</td>
					</tr>
					<tr>
						<th>청구금액</th>
						<td>2,220,000원</td>
					</tr>
					<tr>
						<th>납기일</th>
						<td>2018년 08월 15일</td>
					</tr>
					<tr>
						<th>고객전용지정계좌<br/>(예금주 : 한국전력공사)</th>
						<td>
							<table class="noline">
								<tr>
									<td>우리은행</td>
									<td>100-100000-10-100</td>
									<td>신한은행</td>
									<td>100-100000-10-100</td>
								</tr>
								<tr>
									<td>국민은행</td>
									<td>100-100000-10-100</td>
									<td>농협</td>
									<td>100-100000-10-100</td>
								</tr>
								<tr>
									<td>하나은행</td>
									<td>100-100000-10-100</td>
									<td>기업은행</td>
									<td>100-100000-10-100</td>
								</tr>
								<tr>
									<td>외환은행</td>
									<td>100-100000-10-100</td>
									<td>우 체 국</td>
									<td>100-100000-10-100</td>
								</tr>
								<tr>
									<td>씨티은행</td>
									<td>100-100000-10-100</td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
			<p style="font-size:12px;padding:10px 0;">※ 위 계좌번호는 고객님께서 입금할 수 있는 전용 지정계좌입니다. (끝자리 원단위 입금불가)</p>
			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%">
					<h2>청구금액</h2>
					<table class="tbl e_bill" style="margin-top:10px">
						<tbody>
							<tr>
								<th>기본요금</th>
								<td align="right">10,000</td>
							</tr>
							<tr>
								<th>전력량요금</th>
								<td align="right">2,000,000</td>
							</tr>
							<tr>
								<th>전기요금계</th>
								<td align="right">2,010,000</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">200,000</td>
							</tr>
							<tr>
								<th>전력기금</th>
								<td align="right">10,006</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">-6</td>
							</tr>
							<tr>
								<th>당월요금계</th>
								<td align="right">2,220,000</td>
							</tr>
							<tr>
								<th>미납요금</th>
								<td align="right">0</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>청구금액</th>
								<td align="right">2,220,000</td>
							</tr>
						</tfoot>
					</table>
				</div>
				<div class="fr" style="width:49%">
					<h2>고객사항</h2>
					<table class="tbl" style="margin-top:10px">
						<colgroup>
							<col width="40%"><col>
						</colgroup>
						<tbody>
							<tr>
								<th>전기사용 계약종별</th>
								<td>산업용(을) 고압B 선택 III</td>
							</tr>
							<tr>
								<th>주거구분</th>
								<td>비주거용</td>
							</tr>
							<tr>
								<th>정기검침일</th>
								<td>25</td>
							</tr>
							<tr>
								<th>계량기번호</th>
								<td>XXX001122</td>
							</tr>
							<tr>
								<th>계량기배수</th>
								<td>1</td>
							</tr>
							<tr>
								<th>계약전력</th>
								<td>3</td>
							</tr>
							<tr>
								<th>가구수</th>
								<td>1</td>
							</tr>
						</tbody>
					</table>
					<h2 style="margin-top:10px">미납내역</h2>
					<table class="tbl" style="margin-top:9px">
						<colgroup>
							<col width="40%"><col>
						</colgroup>							
						<tbody>
							<tr>
								<th>미납월</th>
								<th>금액</th>
							</tr>
							<tr>
								<td></td>
								<td>미납요금 없음</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<h2 style="margin-top:20px">최근 6개월 청구 내역</h2>
			<div class="inchart">
				<div id="ly_chart_hj" style="max-width:800px;height:300px"></div>
				<script language="JavaScript"> 
				$(function () { 
					var myChart = Highcharts.chart('ly_chart_hj', {
						data: {
					        table: 'ly_datatable_hj' /* 테이블에서 데이터 불러오기 */
					    },

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
						        x:5, /* 타이틀 위치 조정 */
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
					                return  '<b>' + this.series.name + '</b><br/>' + this.x + '월<br/><span style="color:#438fd7">' + this.y + ' won</span>';
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
					        color: '#438fd7' /* 기본요금 */
					    },{
					        color: '#13af67' /* 사용요금(역률 적용) */
					    },{
					        color: '#f75c4a' /* 전력산업기반기금 */
					    },{
					        color: '#84848f' /* 부가세 */
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
				});
				</script>
			</div>
			<!-- 데이터 추출용 -->
			<div class="lychart_table" style="display:none;">			
				<table id="ly_datatable_hj">
				    <thead>
				        <tr>
				            <th>2018-08</th>
				            <th>기본요금</th>
				            <th>사용요금(역률적용)</th>
				            <th>전력산업기반기금</th>
				            <th>부가세</th>
				        </tr>
				    </thead>
				    <tbody>
				        <tr>
				            <th>1월</th>
				            <td>6847360</td>
				            <td>35233601</td>
				            <td>1554960</td>
				            <td>4202618</td>
				        </tr>
				        <tr>
				            <th>2월</th>
				            <td>6847360</td>
				            <td>35233601</td>
				            <td>1554960</td>
				            <td>4202618</td>
				        </tr>
				        <tr>
				            <th>3월</th>
				            <td>6847360</td>
				            <td>35233601</td>
				            <td>1554960</td>
				            <td>4202618</td>
				        </tr>
				        <tr>
				            <th>4월</th>
				            <td>6847360</td>
				            <td>35233601</td>
				            <td>1554960</td>
				            <td>4202618</td>
				        </tr>
				        <tr>
				            <th>5월</th>
				            <td>6847360</td>
				            <td>35233601</td>
				            <td>1554960</td>
				            <td>4202618</td>
				        </tr>
				        <tr>
				            <th>6월</th>
				            <td>6847360</td>
				            <td>35233601</td>
				            <td>1554960</td>
				            <td>4202618</td>
				        </tr>
				    </tbody>
				</table>			
			</div>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>





</body>
</html>