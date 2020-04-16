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
		<div class="row">
		  <div class="indiv his_chart_top clear">
			<div class="sa_select fl">
			  <div class="dropdown">
				<button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">사업소#1
				  <span class="caret"></span></button>
				<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
				    <li class="on">
						<a href="#" data-value="option1" tabindex="-1"> 
							<input type="checkbox" id="deviceStatus1" value="전체" checked>
							<label for="deviceStatus1"><span></span>전체</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option2" tabindex="-1">
							<input type="checkbox" id="deviceStatus2" value="사업소#1" checked>
							<label for="deviceStatus2"><span></span>사업소#1</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option3" tabindex="-1">
							<input type="checkbox" id="deviceStatus3" value="사업소#2">
							<label for="deviceStatus3"><span></span>사업소#2</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option4" tabindex="-1">
							<input type="checkbox" id="deviceStatus4" value="사업소#3">
							<label for="deviceStatus4"><span></span>사업소#3</label>
						</a>
					</li>
				</ul>
			  </div>
			</div>
			<div class="fl">
			  <span class="tx_tit">설비 타입</span>
			  <div class="sa_select">
				<div class="dropdown">
				  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
					<span class="caret"></span></button>
				  <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
					<li>
						<a href="#" data-value="option1" tabindex="-1">
							<input type="checkbox" id="sel2_1" value="인버터">
							<label for="sel2_1"><span></span>인버터</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option2" tabindex="-1">
							<input type="checkbox" id="sel2_2" value="접속반" checked>
							<label for="sel2_2"><span></span>접속반</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option3" tabindex="-1">
							<input type="checkbox" id="sel2_3" value="차단기">
							<label for="sel2_3"><span></span>차단기</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option4" tabindex="-1">
							<input type="checkbox" id="sel2_4" value="계량기" checked>
							<label for="sel2_4"><span></span>계량기</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option5" tabindex="-1">
							<input type="checkbox" id="sel2_5" value="기상센서">
							<label for="sel2_5"><span></span>기상센서</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option6" tabindex="-1">
							<input type="checkbox" id="sel2_6" value="기상청 기상정보">
							<label for="sel2_6"><span></span>기상청 기상정보</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option7" tabindex="-1">
							<input type="checkbox" id="sel2_7" value="한전 iSmart">
							<label for="sel2_7"><span></span>한전 iSmart</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option8" tabindex="-1">
							<input type="checkbox" id="sel2_8" value="KPX계량포털">
							<label for="sel2_8"><span></span>KPX계량포털</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option9" tabindex="-1">
							<input type="checkbox" id="sel2_9" value="CCTV">
							<label for="sel2_9"><span></span>CCTV</label>
						</a>
					</li>
				  </ul>
				</div>
			  </div>
			   <div class="sa_select">
				<div class="dropdown">
				  <button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">복수 선택
					<span class="caret"></span></button>
					<ul class="dropdown-menu dropdown-menu-form chk_type">
						<li class="dropdown_cov clear">
							<div class="sec_li_bx">
								<p class="tx_li_tit">사업소#1</p>
								<ul>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op01" value="인버터#1">
											<label for="chk_op01"><span></span>인버터#1</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op02" value="인버터#2">
											<label for="chk_op02"><span></span>인버터#2</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op03" value="인버터#3">
											<label for="chk_op03"><span></span>인버터#3</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op04" value="인버터#4">
											<label for="chk_op04"><span></span>인버터#4</label>
										</a>
									</li>
								<ul>
							</div>
							<div class="sec_li_bx">
								<p class="tx_li_tit">사업소#2</p>
								<ul>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op011" value="인버터#1">
											<label for="chk_op011"><span></span>인버터#1</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op022" value="인버터#2">
											<label for="chk_op022"><span></span>인버터#2</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op033" value="인버터#3">
											<label for="chk_op033"><span></span>인버터#3</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op044" value="인버터#4">
											<label for="chk_op044"><span></span>인버터#4</label>
										</a>
									</li>
								<ul>
							</div>
							<div class="li_btn_bx clear">
								<div class="fl">
									<button type="submit" class="btn_type03">모두 선택</button>
									<button type="submit" class="btn_type03">모두 해제</button>
								</div>
								<div class="fr"><button type="submit" class="btn_type">적용</button></div>
							</div>
						</li>
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
			  <div class="sa_select">
				<div class="dropdown">
				  <button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">15분
					<span class="caret"></span></button>
				  <ul class="dropdown-menu">
					<li class="on"><a href="#">15분</a></li>
					<li><a href="#">30분</a></li>
					<li><a href="#">1시간</a></li>
					<li><a href="#">1일</a></li>
					<li><a href="#">1월</a></li>
				  </ul>
				</div>
			  </div>
			</div>
			<div class="fl"><button type="submit" class="btn_type">조회</button></div>
			<div class="fr">
			  <a href="#;" class="save_btn">데이터저장</a>
			</div>
		  </div>
		</div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
		<div class="row">
		<div class="indiv">
			<div class="his_chart_top clear">
				<div class="clear">
					<h2 class="fl s_tit">분석 기준 설비 선택</h2>
					<a href="#" class="btn_type02 fr">분석 조건 저장</a>
				</div>
				<!-- 기본 항목 -->
				<div class="clear">
					<div class="fl">
					  <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">사이트명
							<span class="caret"></span></button>
						  <ul class="dropdown-menu">
							<li class="on"><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
						  </ul>
						</div>
					  </div>
					  <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
							<span class="caret"></span></button>
							<ul class="dropdown-menu dropdown-menu-form rdo_type" role="menu">
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="radio" id="rdo01" name="rdo_btn" value="DC 전압">
										<label for="rdo01"><span></span>DC 전압</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option2" tabindex="-1">
										<input type="radio" id="rdo02" name="rdo_btn" value="DC 전류">
										<label for="rdo02"><span></span>DC 전류</label>
									</a>
								</li>
							</ul>
						</div>
					  </div>
					   <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">최대
							<span class="caret"></span></button>
							<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="radio" id="rdo01_1" name="rdo_btn2" value="최대">
										<label for="rdo01_1"><span></span>최대</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option2" tabindex="-1">
										<input type="radio" id="rdo01_2" name="rdo_btn2" value="최소">
										<label for="rdo01_2"><span></span>최소</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option2" tabindex="-1">
										<input type="radio" id="rdo01_3" name="rdo_btn2" value="평균">
										<label for="rdo01_3"><span></span>평균</label>
									</a>
								</li>
							</ul>
						</div>
					  </div>
					   <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">y-좌
							<span class="caret"></span></button>
						  <ul class="dropdown-menu">
							<li class="on"><a href="#">y-좌</a></li>
							<li><a href="#">y-우</a></li>
						  </ul>
						</div>
					  </div>
					</div>
					
					<!-- 버튼 -->
					<div class="fl">
					  <button type="submit" class="btn_type">그래프 항목 추가</button>
					  <button type="submit" class="btn_type">그래프 그리기</button>
					</div>
					
					<!-- 우측 항목 -->
					<div class="fr his_inp_bx">
						<div class="rdo_type his_rdo_bx">
							<span>
								<input type="radio" id="rdo03_1" name="rdo_btn22" value="시계열 분석">
								<label for="rdo03_1"><span></span>시계열 분석</label>
							</span>
							<span>
								<input type="radio" id="rdo03_2" name="rdo_btn22" value="상권 분석">
								<label for="rdo03_2"><span></span>상권 분석</label>
							</span>
						</div>
						
						<div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w6" type="button" data-toggle="dropdown">사이트별 누적
								<span class="caret"></span></button>
								<ul class="dropdown-menu rdo_type">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="radio" id="rdo04_1" name="rdo_btn33" value="사이트별 누적">
											<label for="rdo04_1"><span></span>사이트별 누적</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo04_2" name="rdo_btn33" value="사이트별 평균">
											<label for="rdo04_2"><span></span>사이트별 평균</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option3" tabindex="-1">
											<input type="radio" id="rdo04_3" name="rdo_btn33" value="설비별 누적">
											<label for="rdo04_3"><span></span>설비별 누적</label>
										</a>
									</li>
								</ul>
							</div>
					  </div>
					</div>
				</div>
				
				<br>
				<!-- x축 y축 -->
				<div class="clear">
					<div class="fl">
						<span class="tx_tit">x축</span>
						<div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
								<span class="caret"></span></button>
							  <ul class="dropdown-menu">
								<li class="on"><a href="#">인버터#1</a></li>
								<li><a href="#">인버터#2</a></li>
								<li><a href="#">인버터#3</a></li>
								<li><a href="#">인버터#4</a></li>
								<li><a href="#">인버터#5</a></li>
							  </ul>
							</div>
						  </div>
						  <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
								<span class="caret"></span></button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chktype11" value="DC 전압">
											<label for="chktype11"><span></span>DC 전압</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="checkbox" id="chktype12" value="DC 전류">
											<label for="chktype12"><span></span>DC 전류</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option3" tabindex="-1">
											<input type="checkbox" id="chktype13" value="DC 전력">
											<label for="chktype13"><span></span>DC 전력</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option4" tabindex="-1">
											<input type="checkbox" id="chktype14" value="금일 발전량">
											<label for="chktype14"><span></span>금일 발전량</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
						   <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">평균
								<span class="caret"></span></button>
								<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="radio" id="rdo04_1" name="rdo_btn5" value="최대">
											<label for="rdo04_1"><span></span>최대</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo04_2" name="rdo_btn5" value="최소">
											<label for="rdo04_2"><span></span>최소</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo04_3" name="rdo_btn5" value="평균">
											<label for="rdo04_3"><span></span>평균</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
					</div>
					
					<div class="fl">
						<span class="tx_tit">y축</span>
						<div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
								<span class="caret"></span></button>
							  <ul class="dropdown-menu">
								<li class="on"><a href="#">인버터#1</a></li>
								<li><a href="#">인버터#2</a></li>
								<li><a href="#">인버터#3</a></li>
								<li><a href="#">인버터#4</a></li>
								<li><a href="#">인버터#5</a></li>
							  </ul>
							</div>
						  </div>
						  <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
								<span class="caret"></span></button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chktype21" value="DC 전압">
											<label for="chktype21"><span></span>DC 전압</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="checkbox" id="chktype22" value="DC 전류">
											<label for="chktype22"><span></span>DC 전류</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option3" tabindex="-1">
											<input type="checkbox" id="chktype23" value="DC 전력">
											<label for="chktype23"><span></span>DC 전력</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option4" tabindex="-1">
											<input type="checkbox" id="chktype24" value="금일 발전량">
											<label for="chktype24"><span></span>금일 발전량</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
						   <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">평균
								<span class="caret"></span></button>
								<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="radio" id="rdo05_1" name="rdo_btn6" value="최대">
											<label for="rdo05_1"><span></span>최대</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo05_2" name="rdo_btn6" value="최소">
											<label for="rdo05_2"><span></span>최소</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo05_3" name="rdo_btn6" value="평균">
											<label for="rdo05_3"><span></span>평균</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
					</div>
					
					<!-- 버튼 -->
					<div class="fl">
					  <button type="submit" class="btn_type">그래프 항목 추가</button>
					  <button type="submit" class="btn_type">그래프 그리기</button>
					</div>
					
					<!-- 우측 항목 -->
					<div class="fr his_inp_bx">
						<div class="rdo_type his_rdo_bx">
							<span>
								<input type="radio" id="rdo06_1" name="rdo_btn32" value="시계열 분석">
								<label for="rdo06_1"><span></span>시계열 분석</label>
							</span>
							<span>
								<input type="radio" id="rdo06_2" name="rdo_btn32" value="상권 분석">
								<label for="rdo06_2"><span></span>상권 분석</label>
							</span>
						</div>
					</div>
				</div>
				
				<!-- x,y축 태그 -->
				<div class="tag_bx clear">
					<div class="fl">
						<span class="tx_tit">y-좌</span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
					</div>
					<div class="fl">
						<span class="tx_tit">y-우</span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
					</div>
				</div>
			</div>
			<br>
			<br>
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
	</div>
    
  <div class="row usage_chart_table">
    <div class="col-lg-12">
      <div class="indiv">
        <table class="his_tbl">
          <thead>
            <tr>
				<!-- 
					위 화살표 : up 클래스 추가
					아래 화살표 : down 클래스 추가
				-->
				<th><button class="btn_align down">설비명</button></th>
				<th><button class="btn_align down">설비ID</button></th>
				<th><button class="btn_align down">사업소</button></th>
				<th><button class="btn_align down">상태</button></th>
				<th><button class="btn_align up">DC전압</button></th>
				<th><button class="btn_align up">DC전류</button></th>
				<th><button class="btn_align up">DC전력</button></th>
				<th><button class="btn_align up">현재출력</button></th>
				<th><button class="btn_align up">금일발전량</button></th>
				<th><button class="btn_align up">누적발전량</button></th>
				<th><button class="btn_align up">AC전압R</button></th>
				<th><button class="btn_align up">AC전압S</button></th>
				<th><button class="btn_align up">AC전압T</button></th>
				<th><button class="btn_align up">역률</button></th>
				<th><button class="btn_align up">주파수</button></th>
				<th><button class="btn_align up">온도</button></th>
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