<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	$(function() {
		const compareArea = $("#siteList").next().find(".compare_area");
		const dropdownArea = compareArea.find(".dropdown");
		const compareSelectBox = compareArea.children().find(".dropdown-toggle.bgN");
		const modalCompare = compareSelectBox.next("ul");
		// const innerSelectBox = selectModal.find("btn.dropdown-toggle");
		const addRuleBtn = modalCompare.find("comp_btn_wrap .btn_type");

		compareSelectBox.on("click", function(){
			// modalCompare.toggleClass("toggled");
			dropdownArea.toggleClass("open");
		});

		// compareSelectBox.on("click", function(){
		// 	dropdown.removeClass("open");
		// })
	});
</script>

<%--
<html>
  <head>
    <title>Abnormally Analysis</title>
  </head>
  <body>
--%>
    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">이상 분석</h1>
		</div>
	</div>
	<div class="row">
		<div id="siteList" class="header_drop_area col-lg-2">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
					선택해주세요.<span class="caret"></span>
				</button>
				<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
			</div>
		</div>
		<div class="col-lg-10">
			<div class="compare_area">
				<div class="dropdown">
					<button class="btn btn-primary dropdown-toggle bgN" type="button">
						비교하기<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk_type">
						<li>
							<div class="compare_bx">
								<div class="bx_row aN2">
									<div class="bx_align">
										<p class="comp_tit type">검증 설비</p>
										<ul class="comp_ul">
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														설비 유형<span class="caret"></span>
													</button>
													<!-- 라디오 타입 -->
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op01" name="rdo_op01">
																<label for="rdo_op01"><span></span>인버터</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op02" name="rdo_op01">
																<label for="rdo_op02"><span></span>인버터2</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														설비 명<span class="caret"></span>
													</button>
													<!-- 체크박스 타입 -->
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op03" name="rdo_op02">
																<label for="rdo_op03"><span></span>인버터</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op04" name="rdo_op02">
																<label for="rdo_op04"><span></span>인버터2</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														설비 속성<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op05" name="rdo_op03">
																<label for="rdo_op05"><span></span>DC 전압</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op06" name="rdo_op03">
																<label for="rdo_op06"><span></span>DC 전류</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op07" name="rdo_op03">
																<label for="rdo_op07"><span></span>DC 전력</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op08" name="rdo_op03">
																<label for="rdo_op08"><span></span>현재 출력</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op09" name="rdo_op03">
																<label for="rdo_op09"><span></span>금일 발전량</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op10" name="rdo_op03">
																<label for="rdo_op10"><span></span>누적 발전량</label>
															</span><span class="comp_inp">
																<input type="radio" id="rdo_op11" name="rdo_op03">
																<label for="rdo_op11"><span></span>AC 전압 R</label>
															</span><span class="comp_inp">
																<input type="radio" id="rdo_op12" name="rdo_op03">
																<label for="rdo_op12"><span></span>AC 전압 S</label>
															</span><span class="comp_inp">
																<input type="radio" id="rdo_op13" name="rdo_op03">
																<label for="rdo_op13"><span></span>AC 전압 T</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op14" name="rdo_op03">
																<label for="rdo_op14"><span></span>역률</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
										</ul>
									</div>
									<div class="bx_align">
										<p class="comp_tit type">비교 설비</p>
										<ul class="comp_ul">
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														설비 유형<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op15" name="rdo_op04">
																<label for="rdo_op15"><span></span>인버터</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op16" name="rdo_op04">
																<label for="rdo_op16"><span></span>접속반</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op17" name="rdo_op04">
																<label for="rdo_op17"><span></span>차단기</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op18" name="rdo_op04">
																<label for="rdo_op18"><span></span>계량기</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op19" name="rdo_op04">
																<label for="rdo_op19"><span></span>기상센서</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op20" name="rdo_op04">
																<label for="rdo_op20"><span></span>기상청 기상정보</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op21" name="rdo_op04">
																<label for="rdo_op21"><span></span>한전 iSmart</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op22" name="rdo_op04">
																<label for="rdo_op22"><span></span>KPX 계량포털</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op23" name="rdo_op04">
																<label for="rdo_op23"><span></span>CCTV</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														설비 명<span class="caret"></span>
													</button>
													<ul class="dropdown-menu chk_type">
														<li>
															<span class="comp_inp">
																<input type="checkbox" id="chk_type01">
																<label for="chk_type01"><span></span>접속반#1</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="chk_type02" >
																<label for="chk_type02"><span></span>접속반#2</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="chk_type03" >
																<label for="chk_type03"><span></span>접속반#3</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="chk_type04" >
																<label for="chk_type04"><span></span>접속반#4</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="chk_type05" >
																<label for="chk_type05"><span></span>접속반#5</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														설비 속성<span class="caret"></span>
													</button>
													<ul class="dropdown-menu chk_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op24" name="rdo_op05">
																<label for="rdo_op24"><span></span>인버터</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op25" name="rdo_op05">
																<label for="rdo_op26"><span></span>인버터</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														계산식<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op27" name="rdo_op06">
																<label for="rdo_op27"><span></span>평균</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op28" name="rdo_op06">
																<label for="rdo_op28"><span></span>예측</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
										</ul>
									</div>
								</div>
								
								<p class="comp_tit type2">제외값</p>
								<div class="bx_row aN3">
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														기준<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op29" name="rdo_op07">
																<label for="rdo_op29"><span></span>이상</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op30" name="rdo_op07">
																<label for="rdo_op30"><span></span>이하</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
										</ul>
									</div>
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														단위<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op31" name="rdo_op08">
																<label for="rdo_op31"><span></span>%</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op32" name="rdo_op08">
																<label for="rdo_op32"><span></span>절대값</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
										</ul>
									</div>
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="tx_inp_type">
													<input type="text" placeholder="기준 값">
												</div>
											</li>
										</ul>
									</div>
								</div>
								
								<p class="comp_tit type2">비교 방법</p>
								<div class="bx_row aN3">
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														비교식<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op33" name="rdo_op09">
																<label for="rdo_op33"><span></span>POINT</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op34" name="rdo_op09">
																<label for="rdo_op34"><span></span>CUSUM</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
										</ul>
									</div>
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														비교 기준<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<span class="comp_inp">
																<input type="radio" id="rdo_op35" name="rdo_op10">
																<label for="rdo_op35"><span></span>절대값</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op36" name="rdo_op10">
																<label for="rdo_op36"><span></span>상대값(%)</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op37" name="rdo_op10">
																<label for="rdo_op37"><span></span>abs(절대값)</label>
															</span>
															<span class="comp_inp">
																<input type="radio" id="rdo_op38" name="rdo_op10">
																<label for="rdo_op38"><span></span>abs(상대값) %</label>
															</span>
														</li>
													</ul>
												</div>
											</li>
										</ul>
									</div>
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="tx_inp_type">
													<input type="text" placeholder="허용치">
												</div>
											</li>
										</ul>
									</div>
								</div>
								
								<p class="comp_tit type2">비교 기간</p>
								<div class="bx_row aN2">
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="sel_calendar">
													<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" placeholder="시작">
												</div>
											</li>
										</ul>
									</div>
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="sel_calendar">
													<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" placeholder="종료">
												</div>
											</li>
										</ul>
									</div>
								</div>
								
								<p class="comp_tit type2">시간 단위</p>
								<div class="bx_row aN2">
									<div class="bx_align">
										<ul class="comp_ul">
											<li>
												<div class="dropdown placeholder">
													<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
														단위<span class="caret"></span>
													</button>
													<ul class="dropdown-menu rdo_type">
														<li>
															<a href="#;">1시간</a>
															<a href="#;">1일</a>
															<a href="#;">1주</a>
															<a href="#;">1월</a>
														</li>
													</ul>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
							<div class="comp_btn_wrap">
								<button type="submit" class="btn_type">규칙 등록</button>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	</div>
	<div class="row">
		<div class="col-lg-2 use_total">
			<div class="indiv">
				<h2 class="ntit">이상 비교</h2>
				<div class="value_area">
					<h3 class="value_tit2">검증 설비</h3>
					<h3 class="value_tit">평균</h3>
					<p class="value_num">
					</p>
				</div>
				<div class="value_area">
					<h3 class="value_tit2">비교 설비</h3>
					<h3 class="value_tit">편차</h3>
					<p class="value_num">
					</p>
				</div>
			</div>
		</div>
		<div class="col-lg-10">
			<div class="indiv usage_chart pv_chart">
				<div class="inchart">
					<div id="chart2"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="row pv_chart_table">
		<div class="col-lg-12">
			<div class="indiv clear">
				<div class="tbl_save_bx">
					<a href="#" class="save_btn">데이터저장</a>
				</div>
				<div class="tbl_top clear">
					<ul class="fr">
						<li><a href="#" class="fold_btn">표접기</a></li>
					</ul>
				</div>
				<div class="tbl_wrap">
					<div class="fold_div" id="pc_use">
					</div>
				</div>
			</div>
		</div>
	</div>

<%--
  </body>
</html>
--%>