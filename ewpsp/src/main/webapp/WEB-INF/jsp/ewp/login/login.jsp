<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<script src="../js/login/login.js" type="text/javascript"></script>
</head>
<body>

	<style>
	/* 로그인 페이지용 스타일 */
	body {background:none;}
	#page-wrapper {margin:0; padding:0;}
	#page-wrapper > nav {margin:0; height:80px; padding:0 32px; overflow:hidden;}
	#page-wrapper > footer {margin:0; height:80px; padding:32px 32px;}
	#page-wrapper .login {
		position:relative;
		margin:0;
		min-height:800px;
		background:url('../img/login_bg.jpg') repeat center bottom;
		background-size:cover;
	}
	.loginForm {
		position:absolute; top:50%; left:50%; transform:translate(-50%, -50%);
		width:520px;
		padding:0;
		background-color:rgba(255, 255, 255, 0.08);
		-webkit-box-shadow: 0px 5px 18px 0px rgba(0,0,0,0.27);
		-moz-box-shadow: 0px 5px 18px 0px rgba(0,0,0,0.27);
		box-shadow: 0px 5px 18px 0px rgba(0,0,0,0.27);
	}
	.lf_body {padding:60px; background:#fff;}
	.lftit {padding-top:110px; background:url('../img/login_people.png') no-repeat center 0;}
	.lftit h1 {font-size:34px; line-height:1; font-family:'Roboto', sans-serif; color:#222; text-align:center; font-weight:500;}
	.lf_body .lfinp {border:0; border-bottom:solid 1px #333; width:100%; height:50px; line-height:50px;}
	.lf_body input:focus {border:0; border-bottom:solid 1px #333; outline-style:none;}
	.lf_body .findpassBtn {
		display:inline-block; padding-right:30px; background:url('../img/login_arr.gif') no-repeat right center;
		font-size:14px; color:#777;
	}
	.lf_bottom {font-size:0; width:100%; display:table;}
	.lf_bottom > * {
		display:inline-block; width:50%; border:0; outline-style:none; height:60px; 
		font-size:18px; color:#fff; font-weight:bold; text-align:center; vertical-align:top;
	}
	.lf_bottom > *:hover {color:#fff;}
	.lf_bottom > a {background:#555; line-height:60px;}
	.lf_bottom > input {background:#438fd7 ; line-height:55px;}

	/* 반응형 미디어 쿼리 */
	@media all and (max-width:768px) {
		#page-wrapper .login {padding:0 10px; min-height:650px;}
		#page-wrapper .login .loginForm {position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); width:95%;}
	}
	</style>
	<div id="wrapper">
		<div id="page-wrapper">
			<nav class="clear">
				<div class="nav_brand"><a href="#;">EWP</a></div>
			</nav>
			<div id="container" class="login">

				<div class="loginForm">
					<form id="loginForm" name="loginForm" action="/loginUser" method="post">
						<div class="lf_body">
							<div class="lftit">
				                <h1>LOGIN</h1>
				            </div>
						    <div class="mt10"><input type="text" name="userId" class="lfinp" placeholder="아이디"></div>
						  	<div class="mt15"><input type="password" name="userPw" class="lfinp" placeholder="비밀번호"></div>
						    <div class="mt30"><a href="#" class="findpassBtn">비밀번호 찾기</a></div>
						</div>
						<div class="lf_bottom">
							<a href="#;" class="joinBtn">회원가입</a>
							<input type="submit" name="login" value="로그인">
						</div>
					</form>
				</div>

			</div>
			<footer class="clear">
				<div class="ft_menu fl">
					<a href="#;" class="serviceBtn">서비스 소개</a>
					<a href="../service/faq.html">자주하는 질문</a>
				</div>
				<div class="copyright fr">
					&copy; 2018 Encored Technologies, Inc.
				</div>
			</footer>
		</div>
	</div>




	
	<!-- 로그인 modal // -->
	<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="loginModal" aria-hidden="true">
        <div class="modal-dialog">
			<div class="loginmodal-container">
				<div class="modal-header" style="padding:0 0 15px;">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h1>LOGIN</h1>
	            </div>
			    <form>
			  	    <input type="text" name="userId" placeholder="아이디">
			  	    <input type="password" name="userPw" placeholder="비밀번호">
			  	    <input type="submit" name="login" class="login loginmodal-submit" value="Login">
			    </form>
				
			    <div class="login-help">
				    <a href="#;" class="joinBtn">Register</a> - <a href="#" class="findpassBtn">Forgot Password</a>
			    </div>
			</div>
		</div>
	</div>
	<script>
	$(function(){   
		$(".joinBtn").click(function(){
			$("#loginModal").modal("hide");
			$("#joinModal").modal("show");
		});	 
		$(".findpassBtn").click(function(){
			$("#loginModal").modal("hide");
			$("#findpassModal").modal("show");
		});	 
	});
	</script>
	<!-- 로그인 modal // -->


	<!-- 비번찾기 modal // -->
	<div class="modal fade" id="findpassModal" tabindex="-1" role="dialog" aria-labelledby="findpassModal" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
			<div class="loginmodal-container">
				<div class="modal-header" style="padding:0 0 15px; margin:0 0 15px">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h1>FIND</h1>
	            </div>
			    <form>
			  	    <input type="text" name="user" placeholder="아이디">
			  	    <input type="text" name="name" placeholder="이름">
			  	    <input type="submit" name="findpass" class="login loginmodal-submit" value="Find Password">
			    </form>
			</div>
		</div>
	</div>
	<!-- 비번찾기 modal // -->	


	<!-- 회원가입 step01 //////////////////// 동의부분 -->
	<div class="modal fade" id="joinModal" tabindex="-1" role="dialog" aria-labelledby="joinModal" aria-hidden="true">
	    <div class="modal-dialog modal-md">
	        <!-- Modal content-->
	        <div class="modal-content">
	            <div class="modal-header" style="padding:25px 30px;">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h4><i class="glyphicon glyphicon-user"></i> JOIN</h4>
	            </div>
	            <div class="modal-body" style="padding:20px 30px;">
					
					<div id="joinStep01" class="rowBox joinBox joinStep01" style="display:;">			
						
						<div class="unit">
							<div class="unit_tit clear">
								<span class="sTit">한국 동서발전 서비스 포털 이용약관</span>

								<div class="etcText fr mt5">
									<span class="checkbox">
										<input type="checkbox" id="checkbox01" class="styled" name="" />
										<label for="checkbox01">동의합니다</label>
									</span>
								</div>
							</div>
							<div class="unit_cont mt5">
								<div class="termBox">							
									제1조 개인정보 처리목적<br><br>
									NICE신용정보는 다음의 목적을 위하여 개인정보를 처리합니다. 처리한 개인정보는 다음의 목적 외의 용도로는 사용되지 않으며 이용 목적이 변경되는 경우에는 개인정보보호법에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.<br>
									가. 채권추심, 신용조사 등 고객 자산관리 업무 수행<br>
									나. 고객센터 업무 수행<br>
									다. 서류 수령 대행업무 수행<br>
									라. 그 밖의 고객이 위탁하는 업무 수행<br>제2조 개인정보의 처리 및 보유 기간<br><br>
										NICE신용정보는 법령에 따른 개인정보 보유?이용기간 <br>
										또는 정보 주체로부터 개인정보를 수집시에 동의 받은 개인정보 보유?이용기간 내에서만 개인정보를 처리?보유하고 정해진 기간 경과 시 즉시 폐기합니다.<br>
										구체적인 개인정보 처리 및 보유기간은 다음과 같습니다.<br>
									가. 신용정보 업무처리에 관한 기록 : 3년<br>
									나. 의뢰 또는 계약철회 등에 관한 기록 : 5년<br>
									다. 이용자의 불만 또는 분쟁처리에 관한 기록 : 3년	
								</div>

								
							</div>
						</div>

						<div class="unit mt5">
							<div class="unit_tit clear">
								<span class="sTit">개인정보 수집, 제공 및 활용 동의</span>

								<div class="etcText fr mt5">
									<span class="checkbox">
										<input type="checkbox" id="checkbox02" class="styled" name="" />
										<label for="checkbox02">동의합니다</label>
									</span>
								</div>
							</div>
							<div class="unit_cont mt5">
								<div class="termBox">
									제1조 개인정보 처리목적<br><br>
									NICE신용정보는 다음의 목적을 위하여 개인정보를 처리합니다. 처리한 개인정보는 다음의 목적 외의 용도로는 사용되지 않으며 이용 목적이 변경되는 경우에는 개인정보보호법에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.<br>
									가. 채권추심, 신용조사 등 고객 자산관리 업무 수행<br>
									나. 고객센터 업무 수행<br>
									다. 서류 수령 대행업무 수행<br>
									라. 그 밖의 고객이 위탁하는 업무 수행<br>제2조 개인정보의 처리 및 보유 기간<br><br>
										NICE신용정보는 법령에 따른 개인정보 보유?이용기간 <br>
										또는 정보 주체로부터 개인정보를 수집시에 동의 받은 개인정보 보유?이용기간 내에서만 개인정보를 처리?보유하고 정해진 기간 경과 시 즉시 폐기합니다.<br>
										구체적인 개인정보 처리 및 보유기간은 다음과 같습니다.<br>
									가. 신용정보 업무처리에 관한 기록 : 3년<br>
									나. 의뢰 또는 계약철회 등에 관한 기록 : 5년<br>
									다. 이용자의 불만 또는 분쟁처리에 관한 기록 : 3년	
								</div>
							</div>
						</div>

					</div>
					
	            </div>
	            <div class="modal-footer">
	            	<div style="padding:5px 0;text-align:center;"><button type="submit" class="joinnextBtn default_btn w80" data-dismiss="modal">다음</button></div>	                
	            </div>
	        </div>
	    </div>
	</div>
	<script>
	$(function(){ 
		$(".joinnextBtn").click(function(){
			$("#joinModal").modal("hide");
			$("#join2Modal").modal("show");
		});	  
	});
	</script>
	<!-- //회원가입 step01 // 동의부분 -->


	<!-- 회원가입 step02 //////////////////// 정보입력 -->
	<div class="modal fade" id="join2Modal" tabindex="-1" role="dialog" aria-labelledby="join2Modal" aria-hidden="true">
	    <div class="modal-dialog modal-md">
	        <!-- Modal content-->
	        <div class="modal-content">
	            <div class="modal-header" style="padding:25px 30px;">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h4><i class="glyphicon glyphicon-user"></i> JOIN</h4>
	            </div>
	            <div class="modal-body" style="padding:20px 30px;">
					
					<div id="joinStep02" class="rowBox joinBox joinStep02">			
						
						<div class="unit clear">
							<div class="unit_tit">
								<span class="sTit">정보입력</span>
							</div>
							<div class="unit_cont lineBox">
								<table class="tableStyle formStyle left">
									<colgroup>
										<col style="width:20%;">
										<col style="width:*;">
									</colgroup>
									<tbody>
										<tr>
											<th>이메일 주소</th>
											<td>
												<div class="inputGroup">
													<input type="text" id="input05" class="inp fl" style="width:40%;" />
													<span class="inline center fl" style="width:5%;" >@</span>
													<select class="inp fl" style="width:33%;">
														<option>=선택=</option>
														<option>naver.com</option>
														<option>daum.net</option>
														<option>nate.com</option>
														<option>직접입력</option>
													<select>	
													<span class="inline center fl" style="width:2%;" >&nbsp;</span>
													<button type="button" class="btnstyle middle white fl" style="width:20%; white-space:nowrap; vertical-align:top; overflow:hidden;">중복검색</button>										
												</div>
												<span class="helpCont">email을 입력하세요</span>
											</td>
										</tr>
										<tr>
											<th>비밀번호</th>
											<td>
												<input type="text" id="input02" class="inp" style="width:100%;" />
												<span class="helpCont">비밀번호를 입력하세요</span>
											</td>
										</tr>
										<tr>
											<th>비밀번호확인</th>
											<td>
												<input type="text" id="input03" class="inp" style="width:100%;" />
												<span class="helpCont">비밀번호를 입력하세요</span>
											</td>
										</tr>
										<tr>
											<th>이름</th>
											<td>
												<input type="text" id="input04" class="inp" style="width:100%;" />
												<span class="helpCont">이름을 입력하세요</span>
											</td>
										</tr>										
										<tr>
											<th>연락처</th>
											<td>
												<div class="inputGroup">
													<input type="text" id="input06" class="inp fl" style="width:30%;" />
													<span class="inline center fl"  style="width:5%;">-</span>
													<input type="text" id="input07" class="inp fl" style="width:30%;" />
													<span class="inline center fl"  style="width:5%;">-</span>
													<input type="text" id="input08" class="inp fl" style="width:30%;" />
												</div>
												<span class="helpCont">숫자를 입력해 주세요</span>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

					</div>

					
	            </div>
	            <div class="modal-footer">
	            	<div style="padding:5px 0;text-align:center;">
	            		<button type="button" class="cancel_btn w80" data-dismiss="modal">취소</button>
	            		<button type="submit" class="join2nextBtn default_btn w80" data-dismiss="modal">확인</button>
	            	</div>	                
	            </div>
	        </div>
	    </div>
	</div>
	<script>
	$(function(){ 
		$(".join2nextBtn").click(function(){
			$("#join2Modal").modal("hide");
			$("#join3Modal").modal("show");
		});	  
	});
	</script>	
	<!-- //회원가입 step02 // 정보입력 -->	


	<!-- 회원가입 step03 //////////////////// 가입완료 -->
	<div class="modal fade" id="join3Modal" tabindex="-1" role="dialog" aria-labelledby="join3Modal" aria-hidden="true">
	    <div class="modal-dialog modal-md">
	        <!-- Modal content-->
	        <div class="modal-content">
	            <div class="modal-header" style="padding:25px 30px;">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h4><i class="glyphicon glyphicon-user"></i> JOIN</h4>
	            </div>
	            <div class="modal-body" style="padding:20px 30px;">
					
					<div id="joinStep03" class="rowBox joinBox joinStep03">			
						
						<div class="joinEndText">
							<strong>"축하합니다"</strong>
							회원가입이 완료되었습니다.
						</div>

					</div>
					
	            </div>
	            <div class="modal-footer">
	            	<div style="padding:5px 0;text-align:center;">
	            		<a href="../main/login.html" class="default_btn w80">로그인</a>
	            	</div>	                
	            </div>
	        </div>
	    </div>
	</div>
	<!-- //회원가입 step03 // 가입완료 -->	




	<!-- 서비스 소개 //////////////////// -->
	<div class="modal fade" id="serviceModal" tabindex="-1" role="dialog" aria-labelledby="serviceModal" aria-hidden="true">
	    <div class="modal-dialog modal-lg">
	        <!-- Modal content-->
	        <div class="modal-content" style="max-width:800px;">
	            <div class="modal-header" style="padding:25px 30px;">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h4>서비스 소개</h4>
	            </div>
	            <div class="modal-body" style="padding:20px 30px;">
					
					<div id="svCompany" class="joinBox svCompany">			
						
						<!-- 동서발전 서비스 ? -->
						<div class="sec">							
							<h2 class="sTit">1. 한국 동서발전 서비스?</h2>
							<div class="sec_cont">
								<p><strong>전력의 생산/변환/소비 등에 대한 모니터링이 가능한 통합관리 시스템</strong></p>
								<div class="mt5"><img src="../img/service_img.jpg" alt=""></div>
								<p class="mt5">
									IoT 기기와 연계한 각각의 고객 사이트와 전체 사이트의 실시간, 과거의 사용량과 미래의 예측량을 모니터링 하고 충/방전량, ESS 서비스를 통한 실적 및 수익 정보를 조회할 수 있는 서비스 포털 서비스입니다.
								</p>
							</div>
						</div>

						<!-- 주요 서비스 -->
						<div class="sec mt30">							
							<h2 class="sTit">2. 주요 서비스</h2>
							<div class="sec_cont clear">
								<div class="fl"><img src="../img/service_main1.png" alt=""></div>
								<div class="fr">
									<p><strong>에너지 현황 (대시보드)</strong></p>
									<p class="mt5 tint">※ 군관리 Main– 고객사 전체, 고객사 그룹 별 현황 대시보드 화면</p>
									<p class="mt5 tint">※ 사이트 Main – 각 사이트 별 현황 대시보드 화면 </p>
									<p class="mt5 tint">※ 전력관리 설정 – 한전계약 및 전력관리 정보를 설정</p>	
								</div>							
							</div>

							<div class="sec_cont clear mt20">
								<div class="fl"><img src="../img/service_main2.gif" alt=""></div>
								<div class="fr">
									<p><strong>모니터링</strong></p>
									<p class="mt5 tint">※ 에너지 모니터링 – 전력 사용량 현황, 피크 전력 현황, 충/방전 현황, PV 발전량 현황, DR실적 현황, 사용량 구성(DER)</p>
									<p class="mt5 tint">※ 장치 모니터링 – IOE 통신상태, PCS 운전상태, BMS 운전상태, PV 발전상태 </p>
									<p class="mt5 tint">※ 알람 정보 확인 – 각 장치 별 알람 정보를 확인하고 처리상태를 점검</p>
								</div>
							</div>

							<div class="sec_cont clear mt20">
								<div class="fl"><img src="../img/service_main3.png" alt=""></div>
								<div class="fr">
									<p><strong>수익정보 확인</strong></p>
									<p class="mt5 tint">※ 요금 조회 – 각 항목 별 한전 요금 상세 조회</p>
									<p class="mt5 tint">※ 수익 조회 – ESS 수익 조회, DR 수익 조회, PV 수익 조회</p>
									<p class="mt5 tint">※ 명세서 확인 – 에너지 절감 수익 배분 청구 명세서 확인 및 출력</p>
								</div>
							</div>
						</div>						

					</div>
					
	            </div>
	        </div>
	    </div>
	</div>
	<script>
	$(function(){ 
		$(".serviceBtn").click(function(){
			$("#serviceModal").modal("show");
		});	  
	});
	</script>
	<!-- //서비스 소개 -->





</body>
</html>