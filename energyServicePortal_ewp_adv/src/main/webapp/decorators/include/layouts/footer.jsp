<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
			<footer class="clear">
				<div class="ft_menu fl">
					<a href="#;" class="serviceBtn"><spring:message code="ewp.bot.Services"/></a>
					<a href="/board/faq.do"><spring:message code="ewp.bot.FAQ"/></a>
					<a href="/board/refer.do">자료실</a>
				</div>
				<div class="copyright fr">
					<!-- 인코어드는 주석처리된 소스 이용 -->
					<!-- &copy; 2018 Encored Technologies, Inc -->
					COPYRIGHT &copy; 2018 KOREA EAST-WEST POWER CO.,LTD (EWP). ALL RIGHTS RESERVED
				</div>
				<div class="copyright fr">
					Ver 1.1.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</div>
			</footer>
			



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
							<h2 class="sTit">1. 신재생에너지 서비스포털 서비스</h2>
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
	
	<%-- <%@ include file="/decorators/include/popup/totalBillPopup.jsp"%> --%><!-- 필요 시 주석 해제하여 사용 2020.03.17 -->