<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<!-- <script src="../js/energy/usage.js" type="text/javascript"></script> -->
</head>
<body>

	<!-- 메인페이지용 스타일/스크립트 파일 -->
	<link type="text/css" href="../css/main.css" rel="stylesheet">
	<script type="text/javascript" src="../js/modules/rounded-corners.js"></script>
	<script type="text/javascript" src="../js/jquery.rwdImageMaps.min.js"></script>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="main" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_alarm">
									<div class="chart_top clear">
										<h2 class="ntit">알람</h2>
										<div class="fr today_alarm">
											<div class="total">금일발생 <span>614</span></div>
											<div class="no"><span>2</span></div>
										</div>
									</div>
									<div class="alarm_stat mt20 clear">
										<div class="a_alert clear">
											<span>ALERT</span><br/>
											<em>128</em>
										</div>
										<div class="a_warning clear">
											<span>WARNING</span><br/>
											<em>486</em>
										</div>
									</div>
									<div class="alarm_notice">
										<h2>최근 알람</h2>
										<ul>
											<li>
												<a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망. 메시지가 길면 절삭처리 됩니다. 메시지가 길면 절삭처리 됩니다.</a>
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
								<div class="indiv gmain_chart">
									<ul class="gtab_menu">
										<li class="active"><a href="#;">사용</a></li>
										<li><a href="#;">충•방전</a></li>
										<li><a href="#;">발전</a></li>
										<li><a href="#;">수익</a></li>									
									</ul>
									<div class="tblDisplay">
										<!-- 사용 -->
										<div>
											<div class="gchart_top clear">
												<h2>사용량 순위</h2>
												<ul>
													<li>AM 10:00 기준</li>
													<li><span class="bul1">누적 - 0.00 kWh</span></li>
													<li><span class="bul2">예상 - 0.00 kWh</span></li>
												</ul>
											</div>
											<div class="inchart">
												<div id="gchart1" style="height:333px;"></div>
												<script language="JavaScript"> 
												$(function () { 
													var peakChart = Highcharts.chart('gchart1', {
														data: {
													        table: 'gdatatable1' /* 테이블에서 데이터 불러오기 */
													    },

														chart: {
															marginTop:30,
															marginRight:0,
															backgroundColor: 'transparent',
															type: 'bar'
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
																align: 'left',
																reserveSpace: true,
																style: {
																	color: '#8e95a1',
																	fontSize: '14px'
																}
															},
															title: {
																text: null
															}
														},

														yAxis: {
															gridLineWidth: 0, /* 기준선 grid 안보이기/보이기 */
														    min: 0, /* 최소값 지정 */
														    title: {
														    	text: '',
														        style: {
														            color: '#fff',
														            fontSize: '12px'
														        }
														    },
														    labels: {
														        overflow: 'justify',
														        x:-10, /* 그래프와의 거리 조정 */
														        style: {
														            color: '#fff',
														            fontSize: '12px'
														        }
														    }
														},									    

														/* 범례 */
														legend: {
															enabled: false,
															align:'right',
															verticalAlign:'top',
															x:18,
															y:-20,										
															itemStyle: {
														        color: '#fff',
														        fontSize: '12px',
														        fontWeight: 400
														    },
														    itemHoverStyle: {
														        color: '' /* 마우스 오버시 색 */
														    },
														    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
														    symbolHeight:7 /* 심볼 크기 */
														},

														/* 툴팁 */
														tooltip: {
															    valueSuffix: ' kwh'
														},

														/* 옵션 */
														plotOptions: {
													        series: {
													            label: {
													                connectorAllowed: true
													            },
													            borderWidth: 0, /* 보더 0 */
													            borderRadiusTopLeft: '50%', /* 막대 모서리 둥글게 효과 */
        														borderRadiusTopRight: '50%', /* 막대 모서리 둥글게 효과 */
        														pointWidth: 5, /* 막대 두께 */
        														pointPadding: 0.3 /* 막대 사이 간격 */
													        },
													        bar: {
													            dataLabels: {
													                enabled: true,
													                inside: true, /* 막대 안으로 라벨 수치 넣기 */
													                format: '{y} kWh', /* 단위 넣기 */
													                style: {
													                    color: '#ffffff',
														                fontSize: '11px',
														                fontWeight: 400
													                }
													            }
													        }
													    },

														/* 출처 */
														credits: {
															enabled: false
														},

														/* 그래프 스타일 */
													    series: [{
													        color: '#74b9fa' /* 누적 */
													    },{
													        color: '#6d7f9b' /* 예상 */
													    }],

													    /* 반응형 */
													    responsive: {
													        rules: [{
													            condition: {
													                maxWidth: 414 /* 차트 사이즈 */									                
													            },
													            chartOptions: {
																	xAxis: {
																		labels: {
																	        style: {
																	            fontSize: '12px'
																	        }
																		}
																	}
													            }
													        }],
													        rules: [{
													            condition: {
													                minWidth: 842 /* 차트 사이즈 */									                
													            },
													            chartOptions: {
																	xAxis: {
																		labels: {
																	        style: {
																	            fontSize: '18px'
																	        }
																		}
																	},
																	yAxis: {
																		labels: {
																	        style: {
																	            fontSize: '18px'
																	        }
																		}
																	},
																	plotOptions: {
																        series: {
			        														pointWidth: 8
																        },
																        bar: {
																            dataLabels: {
																                style: {
																	                fontSize: '15px'
																                }
																            }
																        }
																    }
													            }
													        }]
													    }

													});
												});
												</script>
											</div>
											<!-- 데이터 추출용 테이블 -->
											<div class="hidden_table" style="display:none">
												<table id="gdatatable1">
												    <thead>
												        <tr>
												            <th></th>
												            <th>누적</th>
												            <th>예상</th>
												        </tr>
												    </thead>
												    <tbody>
												        <tr>
												            <th>한국제지</th>
												            <td>50</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>문수경기장</th>
												            <td>90</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>태광석유화학</th>
												            <td>70</td>
												            <td>90</td>
												        </tr>
												        <tr>
												            <th>한국제지</th>
												            <td>30</td>
												            <td>40</td>
												        </tr>
												        <tr>
												            <th>문수경기장</th>
												            <td>100</td>
												            <td>92</td>
												        </tr>
												    </tbody>
												</table>
											</div>											
											<div class="paging clear">
												<a href="#;" class="prev">PREV</a>
												<span><strong>1</strong> / 3</span>
												<a href="#;" class="next">NEXT</a>
											</div>
										</div>
										<!-- 충•방전 -->
										<div>
											충•방전
										</div>
										<!-- 발전 -->
										<div>
											발전
										</div>
										<!-- 수익 -->
										<div>
											수익
										</div>
									</div>
								</div>
							</div>
						</div>				
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">

								<!-- 그룹별 사용량 //-->
								<div class="indiv gmain_group">
									<div class="chart_top clear">
										<h2 class="ntit">그룹별사용량</h2>
									</div>
									<div class="group_wrap">
										<img src="" alt="그룹이미지" />
									</div>
									<!-- 그룹별 정보 -->
									<div class="group_info">
										<h2 class="group_name">그룹명</h2>
										<div class="clear">
											<ul>
												<li><strong>사용량</strong> <span>564</span> <em>MWh</em></li>
												<li><strong>발전량</strong> <span>328</span> <em>MWh</em></li>
											</ul>
											<ul>
												<li><strong>충•방전량</strong> <span>183</span> <em>MWh</em></li>
												<li><strong>수익</strong> <span>99,000</span> <em>won</em></li>
											</ul>
										</div>
									</div>
								</div>
								<!-- //그룹별 사용량 -->

							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_table">
									<div class="term_menu clear">
										<ul>
											<li class="on"><a href="#;">오늘</a></li>
											<li><a href="#;">이번주</a></li>
											<li><a href="#;">이번달</a></li>
										</ul>
										<ol>
											<li>
												<div class="dropdown">
												  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">지역별
												  <span class="caret"></span></button>
												  <ul class="dropdown-menu">
												    <li class="on"><a href="#">지역별</a></li>
												    <li><a href="#">그룹별</a></li>
												  </ul>
												</div>
											</li>
											<li>
												<div class="dropdown">
												  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체지역
												  <span class="caret"></span></button>
												  <ul class="dropdown-menu">
												    <li class="on"><a href="#">전체지역</a></li>
												    <li><a href="#;">서울</a></li>
												    <li><a href="#;">경기</a></li>
												    <li><a href="#;">인천</a></li>
												    <li><a href="#;">강원</a></li>
												    <li><a href="#;">충북</a></li>
												    <li><a href="#;">충남</a></li>
												    <li><a href="#;">대전</a></li>
												    <li><a href="#;">경북</a></li>
												    <li><a href="#;">대구</a></li>
												    <li><a href="#;">경남</a></li>
												    <li><a href="#;">울산</a></li>
												    <li><a href="#;">부산</a></li>
												    <li><a href="#;">울릉도</a></li>
												    <li><a href="#;">전북</a></li>
												    <li><a href="#;">광주</a></li>
												    <li><a href="#;">전남</a></li>
												    <li><a href="#;">제주</a></li>
												  </ul>
												</div>
											</li>
										</ol>
									</div>
									<div class="gtbl_wrap">
										<table>
											<colgroup>
												<col width="50">
												<col>
												<col>
												<col>
												<col>
												<col>
												<col width="70">
											</colgroup>
										    <thead>
										      <tr>
										      	<th>번호</th>
										        <th>업체명</th>
										        <th>장치현황</th>
										        <th>사용</th>
										        <th>충•방전</th>
										        <th>발전</th>
										        <th>수익</th>
										      </tr>
										    </thead>
										    <tbody>
										      <tr class="dbclickopen">
										        <td>1</td>
										        <td>
										        	<div class="cname"><a href="../main/smain.html">롯데정밀화학Z</a></div>
										        </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>2</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">한국프랜지</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>3</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">제일화성</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>4</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">한국제지</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>5</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">문수경기장</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3 on">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>6</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">태광석유화학</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3 on">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td align="left">7</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">SNF KOREA</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										        <td>8</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">롯데정밀화학</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3 on">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>9</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">한국프랜지</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>10</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">제일화성</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										    </tbody>
										</table>
									</div>
									<div class="paging clear">
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
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>


<script type="text/javascript">
/* 이미지맵 처리 */
$(document).ready(function(e) {
    $('img[usemap]').rwdImageMaps();
});

/* 지역별 상세지도/정보 표시 */
function local_detail(lname) {
	$("#local_detail").attr("src","../img/local_map_"+lname+"_detail.png");
    if(lname == "Seoul") {$(".detailmap .local_name").text("서울");}
    if(lname == "Gyeonggi") {$(".detailmap .local_name").text("경기");}
    if(lname == "Incheon") {$(".detailmap .local_name").text("인천");}
    if(lname == "Gangwon") {$(".detailmap .local_name").text("강원");}
    if(lname == "Chungbuk") {$(".detailmap .local_name").text("충북");}
    if(lname == "Daejeon") {$(".detailmap .local_name").text("대전");}
    if(lname == "Chungnam") {$(".detailmap .local_name").text("충남");}
    if(lname == "Kyungbuk") {$(".detailmap .local_name").text("경북");}
    if(lname == "Daegu") {$(".detailmap .local_name").text("대구");}
    if(lname == "Ulsan") {$(".detailmap .local_name").text("울산");}
    if(lname == "Ulleungdo") {$(".detailmap .local_name").text("울릉도");}
    if(lname == "Gyeongnam") {$(".detailmap .local_name").text("경남");}
    if(lname == "Busan") {$(".detailmap .local_name").text("부산");}
    if(lname == "Jeonbuk") {$(".detailmap .local_name").text("전북");}
    if(lname == "Gwangju") {$(".detailmap .local_name").text("광주");}
    if(lname == "Jeonnam") {$(".detailmap .local_name").text("전남");}	
    if(lname == "Jeju") {$(".detailmap .local_name").text("제주");}
}

/* 상세지도/정보 보기 */
$(function() {
	$("#local_map_all").click(function(){
		$(".map_wrap").hide();
		$(".allmap").hide();
		$(".map_wrap_detail").show();
		$(".detailmap").show();
		$(".all_map_view").show();
	});
});	

/* 전체지도/정보 보기 */
$(function() {
	$(".all_map_view").click(function(){
		$(this).hide();
		$(".map_wrap").show();
		$(".allmap").show();
		$(".map_wrap_detail").hide();
		$(".detailmap").hide();		
	});
});	

/* 20초마다 지도/정보 변경 */
var done = false;
var area_idx = 0;
var area_array = [ "Seoul", "Gyeonggi", "Incheon", "Gangwon", "Chungbuk", "Daejeon", "Chungnam", "Kyungbuk", "Daegu", "Ulsan", "Ulleungdo", "Gyeongnam", "Busan", "Jeonbuk", "Gwangju", "Jeonnam", "Jeju" ];

function readArea() {
   console.log("readArea");
   if (done) return;
   if(area_idx == area_array.length) {area_idx = 0;}

   /* 전체지도/정보 변경 */
   $("#local").attr("src","../img/local_map_"+area_array[area_idx]+".png");
    if(area_array[area_idx] == "Seoul") {$(".allmap .local_name").text("서울");}
    if(area_array[area_idx] == "Gyeonggi") {$(".allmap .local_name").text("경기");}
    if(area_array[area_idx] == "Incheon") {$(".allmap .local_name").text("인천");}
    if(area_array[area_idx] == "Gangwon") {$(".allmap .local_name").text("강원");}
    if(area_array[area_idx] == "Chungbuk") {$(".allmap .local_name").text("충북");}
    if(area_array[area_idx] == "Daejeon") {$(".allmap .local_name").text("대전");}
    if(area_array[area_idx] == "Chungnam") {$(".allmap .local_name").text("충남");}
    if(area_array[area_idx] == "Kyungbuk") {$(".allmap .local_name").text("경북");}
    if(area_array[area_idx] == "Daegu") {$(".allmap .local_name").text("대구");}
    if(area_array[area_idx] == "Ulsan") {$(".allmap .local_name").text("울산");}
    if(area_array[area_idx] == "Ulleungdo") {$(".allmap .local_name").text("울릉도");}
    if(area_array[area_idx] == "Gyeongnam") {$(".allmap .local_name").text("경남");}
    if(area_array[area_idx] == "Busan") {$(".allmap .local_name").text("부산");}
    if(area_array[area_idx] == "Jeonbuk") {$(".allmap .local_name").text("전북");}
    if(area_array[area_idx] == "Gwangju") {$(".allmap .local_name").text("광주");}
    if(area_array[area_idx] == "Jeonnam") {$(".allmap .local_name").text("전남");}	
    if(area_array[area_idx] == "Jeju") {$(".allmap .local_name").text("제주");}

   /* 상세지도/정보 변경 */
   local_detail(area_array[area_idx]);

   area_idx++;
   setTimeout(readArea, 3000); /* 3초 간격 */
}
readArea();


</script>


<!-- 레이어 팝업 배경 -->
<div id="mask"></div>



</body>
</html>