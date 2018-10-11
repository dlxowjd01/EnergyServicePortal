<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
			<footer class="clear">
				<div class="ft_menu fl">
					<a href="#;" class="serviceBtn">서비스 소개</a>
					<a href="/faq">자주하는 질문</a>
				</div>
				<div class="copyright fr">
					&copy; 2018 Encored Technologies, Inc.
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
	





    <!-- ###### 통합 명세서 Popup Start ###### -->
    <div id="layerbox" class="totaldprint clear" style="margin:250px 0 50px;">
    	<div class="lbutton fl">
			<a href="#;" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="#;" class="lbtn_print"><span>인쇄</span></a>
		</div>  
        <div class="ltit fr">
			<a href="javascript:popupClose('totaldprint');" class="lclose">닫기</a>
        </div>
		<div class="lbody mt30">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;">
						(종합)에너지절감 솔루션 제공 전기요금 절감 수익 배분 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : 고객Site_1</td>
					<td height="30" align="right" style="font-size:12px;">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
						이번 달 청구 금액은 <strong style="color:#438fd7">37,938,260</strong>원 입니다
						<p style="padding-top:10px;font-size:12px;font-weight:normal;">(수익배분기간 : 2018-01-01 ~ 2018-12-31)</p>
					</td>
				</tr>
			</table>

			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%;">
					<h2>1. 전기요금 내역</h2>
					<table class="tbl" style="margin-top:10px;">
						<colgroup>
							<col width="50%">
							<col>
						</colgroup>
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
							<tr>
								<th>&nbsp;</th>
								<td align="right">&nbsp;</td>
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
				<div class="fr" style="width:49%;">
					<h2>2. 에너지 절감 솔루션 수익 분배 청구 내역 </h2>
					<table class="tbl" style="margin-top:10px;">
						<thead>
							<tr>
								<th>구분</th>
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
			</div>
			<div class="clear" style="margin-top:20px;">
				<div class="fl" style="width:49%;">
					<h2>3. DR (수요반응) 수익 배분 청구 내역</h2>
					<table class="tbl" style="margin-top:10px;">
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
				</div>
				<div class="fr" style="width:49%;">
					<h2>4. PV 발전 수익 배분 청구 내역</h2>
					<table class="tbl" style="margin-top:10px;">
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
								<th>①REC 수익</th>
								<td align="right">12,775,000</td>
							</tr>
							<tr>
								<th>②SMP 수익</th>
								<td align="right">10,220,000</td>
							</tr>
							<tr>
								<th>③총 수익</th>
								<td align="right">22,995,000</td>
							</tr>
							<tr>
								<th>고객 정산 금액</th>
								<td align="right"></td>
							</tr>
							<tr>
								<th>④수익배분 계</th>
								<td align="right">4,599,000</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">459,906</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">-6</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>청구금액</th>
								<td align="right">5,058,900</td>
							</tr>
						</tfoot>
					</table>					
				</div>
			</div>
			<div class="clear" style="margin-top:20px;">
				<h2>5. 납입 정보</h2>
				<table class="tbl" style="margin-top:10px;">
					<colgroup>
						<col>
						<col width="25%">
					</colgroup>
					<tbody>
						<tr>
							<th>
								총 청구 금액<br/>
								(전기요금 + 에너지 절감 수익 배분 + DR 수익 배분 + PV 발전 수익 배분)
							</th>
							<td align="right"><span style="font-weight:bold;">37,938,260</span></td>
						</tr>
					</tbody>
				</table>
			</div>

		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>
