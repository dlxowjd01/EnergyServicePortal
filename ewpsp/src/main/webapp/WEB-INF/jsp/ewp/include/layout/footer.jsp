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
	





    <!-- ###### 통합 명세서 Popup Start ###### -->
    <script type="text/javascript">
        $(function(){
        	
        	$(".lbtn_pdf").on('click',function(){
            	$(".lbutton").hide();
            	setTimeout(function () {
            		$(".lbutton").show();
            	},1000);
            });
            
            $('#btnPrintTot').on('click', function(){
            	$('#layerboxTot').css("left", "0px");
                $('#layerboxTot').css("top", "-200px");
                $(".lbutton").hide();
            	$('#layerboxTot').printThis({
	        	});
            	setTimeout(function () {
            		$(".lbutton").show();
            	},1000);
            });
        });
    </script>
    <div id="layerboxTot" class="totaldprint clear" style="margin:250px 0 50px;width:880px;">
    	<div class="lbutton fl">
			<a href="javascript:getPdfTotDownload()" class="lbtn_pdf"><span>PDF로 저장</span></a>
			<a href="#;" id="btnPrintTot" class="btnPrintTot"><span>인쇄</span></a>
		</div>  
        <div class="ltit fr">
			<a href="javascript:popupClose('totaldprint');" class="lclose">닫기</a>
        </div>
		<div class="lbody mt30">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" style="border:solid 1px #111;text-align:center;padding:15px;font-size:20px;font-weight:600;" id="texTotBill">
						(종합)에너지절감 솔루션 제공 전기요금 절감 수익 배분 청구서 (’18년 5월)
					</td>
				</tr>
				<tr>
					<td height="30" align="left" style="font-size:12px;">고객명 : ${selViewSite.site_name }</td>
					<td height="30" align="right" style="font-size:12px;" id="texTotDay">청구일 : 2018-07-20</td>
				</tr>
				<tr>
					<td colspan="2" height="60" align="right" style="font-size:16px;font-weight:600;">
						이번 달 청구 금액은 <strong style="color:#438fd7" class="total_tex">37,938,260</strong>원 입니다
						<p style="padding-top:10px;font-size:12px;font-weight:normal;"><!-- (수익배분기간 : 2018-01-01 ~ 2018-12-31) --></p>
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
						<tbody id = "kepco">
							<tr>
								<th>기본요금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전력량요금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전기요금계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전력기금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>당월요금계</th>
								<td align="right">0</td>
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
						<tfoot id = "kepcoFoot">
							<tr>
								<th>청구금액</th>
								<td align="right">0</td>
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
						<tbody id = "ESS">
							<tr>
								<th>기본 요금 절감(피크저감)</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>전려량 요금 절감(계시별)</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>ESS 충전 요금 할인</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>ESS 전용 요금 할인</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>총   계</th>
								<td align="right">0</td>
								<td align="right">0</td>
							</tr>
							<tr>
								<th colspan="2">수익배분 계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th colspan="2">부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th colspan="2">원단위절사</th>
								<td align="right">0</td>
							</tr>
						</tbody>
						<tfoot id = "ESSFoot">
							<tr>
								<th colspan="2">청구금액</th>
								<td align="right">0</td>
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
						<tbody id = "DR">
							<tr>
								<th>용량 정산금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>감축 정산금</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>총 정산금액</th>
								<td align="right">0</td>
							</tr>
							<!-- <tr>
								<th>고객 정산 금액</th>
								<td align="right">0</td>
							</tr> -->
							<tr>
								<th>①수익배분 계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">0</td>
							</tr>
						</tbody>
						<tfoot id = "DRFoot">
							<tr>
								<th>청구금액</th>
								<td align="right">0</td>
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
						<tbody id = "PV">
							<tr>
								<th>①REC 수익</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>②SMP 수익</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>③총 수익</th>
								<td align="right">0</td>
							</tr>
							<!-- <tr>
								<th>고객 정산 금액</th>
								<td align="right"></td>
							</tr> -->
							<tr>
								<th>④수익배분 계</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>부가가치세</th>
								<td align="right">0</td>
							</tr>
							<tr>
								<th>원단위절사</th>
								<td align="right">0</td>
							</tr>
						</tbody>
						<tfoot id = "PVFoot">
							<tr>
								<th>청구금액</th>
								<td align="right">0</td>
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
							<td align="right"><span style="font-weight:bold;" class="total_tex">0</span></td>
						</tr>
					</tbody>
				</table>
			</div>

		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>
	<div class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..." /></div>



	<!-- 정보수정 // -->
	<div class="modal fade" id="modifyModal" tabindex="-1" role="dialog" aria-labelledby="modifyModal" aria-hidden="true">
	    <div class="modal-dialog modal-md">
	        <!-- Modal content-->
	        <div class="modal-content">
	            <div class="modal-header" style="padding:25px 30px;">
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	                <h4><i class="glyphicon glyphicon-user"></i> MODIFY</h4>
	            </div>
	            <form id="modifyUserForm" name="modifyUserForm">
	            <input type="hidden" id="modUserIdx" name="userIdx" />
	            <input type="hidden" id="modPsnEmail" name="psnEmail" />
	            <input type="hidden" id="modPsnMobile" name="psnMobile" />
	            <div class="modal-body" style="padding:20px 30px;">
					
					<div class="rowBox joinBox">			
						
						<div class="unit clear">
							<div class="unit_tit">
								<span class="sTit">사용자 정보</span>
							</div>
							<div class="unit_cont lineBox">
								<table class="tableStyle formStyle left">
									<colgroup>
										<col style="width:20%;">
										<col style="width:*;">
									</colgroup>
									<tbody>
										<tr>
											<th>아이디</th>
											<td align="left" id="modUserId">
											</td>
										</tr>
										<tr>
											<th>이름</th>
											<td align="left" id="modPsnName">
											</td>
										</tr>										
										<tr>
											<th>비밀번호</th>
											<td>
												<input type="password" id="modUserPw" name="userPw" class="inp" style="width:100%;" />
												<span class="helpCont">비밀번호를 입력하세요</span>
											</td>
										</tr>
										<tr>
											<th>비밀번호확인</th>
											<td>
												<input type="password" id="modUserPw2" class="inp" style="width:100%;" />
												<span class="helpCont">비밀번호확인이 일치하지 않습니다</span>
											</td>
										</tr>
										
										<tr>
											<th>이메일 주소</th>
											<td>
												<div class="inputGroup">
													<input type="text" id="modEmail1" class="inp fl" style="width:30%;" maxlength="25" />
													<span class="inline center fl" style="width:5%;" >@</span>
													<input type="text" id="modEmail3" class="inp fl" style="width:27%; margin-right:10px; maxlength="25" />
													<select id="modEmail2" class="inp fl" style="width:35%;">
														<option value="">=선택=</option>
														<option value="naver.com">naver.com</option>
														<option value="hanmail.net">hanmail.net</option>
														<option value="nate.com">nate.com</option>
														<option value="gmail.com">gmail.com</option>
														<option value="manual" selected="selected">직접입력</option>
													<select>								
												</div>
												<span class="helpCont">email을 입력하세요</span>
											</td>
										</tr>										
										<tr>
											<th>휴대폰 번호</th>
											<td>
												<div class="inputGroup">
													<input type="text" id="modMobile1" class="inp fl" style="width:30%;" maxlength="3" />
													<span class="inline center fl"  style="width:5%;">-</span>
													<input type="text" id="modMobile2" class="inp fl" style="width:30%;" maxlength="4" />
													<span class="inline center fl"  style="width:5%;">-</span>
													<input type="text" id="modMobile3" class="inp fl" style="width:30%;" maxlength="4" />
												</div>
												<span class="helpCont">휴대폰번호를 입력해 주세요</span>
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
	            	<div style="padding:5px 20px;text-align:center;">
	            		<button type="button" class="memberout_btn w80 fl" id="removeUserBtn">탈퇴</button>
	            		<button type="button" class="cancel_btn w80" data-dismiss="modal">취소</button>
	            		<button type="submit" class="default_btn w80" data-dismiss="modal" id="modifyUserBtn">확인</button>
	            	</div>	                
	            </div>
	            </form>
	        </div>
	    </div>
	</div>
	<script>
	$(function(){ 
		$(".myinfo").click(function(){
			getUserInfo(setModifyUserInfo);
			$("#modifyModal").modal("show");
		});	  
	});

	// 정보 수정, 탈퇴 시작 (적당한 js파일로 옮겨 주세요.)
	$(function() {
		$("#modifyUserBtn").click(function(){
			checkModify();
			return false;
		});

		$("#removeUserBtn").click(function(){
			if (confirm("탈퇴하시겠습니까?\n탈퇴하면 복구할 수 없습니다.")) {
				removeUser();
			}
		});

		$('#modEmail2').change(function() {
			var val = $(this).val();
			if (val == 'manual') {
				$('#modEmail1').css('width', '30%');
				$('#modEmail3').show();
			} else {
				$('#modEmail1').css('width', '60%');
				$('#modEmail3').hide();
			}
		});
	});

	function setModifyUserInfo(result) {
		$('#modUserIdx').val(result.user_idx);
		$('#modUserId').text(result.user_id);
		$('#modPsnName').text(result.psn_name);

		$('#modUserPw').val('');
		$('#modUserPw2').val('');

		var email = result.psn_email;
		if (email != null && email.indexOf('@') != -1) {
			var emails = email.split('@');
			$('#modEmail1').val(emails[0]);
			$('#modEmail3').val(emails[1]);
		}

		var mobile = result.psn_mobile;
		if (mobile != null && mobile.indexOf('-') != -1) {
			var mobiles = mobile.split('-');
			$('#modMobile1').val(mobiles[0]);
			$('#modMobile2').val(mobiles[1]);
			$('#modMobile3').val(mobiles[2]);
		}

		$('.helpCont').hide();
	}

	function checkModify() {
		if ($('#modUserPw').val() != $('#modUserPw2').val()) {
			$('.helpCont').hide();
			$('#modUserPw2').parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		if ($('#modEmail1').val() == '' || $('#modEmail2').val() == '') {
			$('.helpCont').hide();
			$('#modEmail1').parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		if ($('#modEmail2').val() == 'manual' && $('#modEmail3').val() == '') {
			$('.helpCont').hide();
			$('#modEmail1').parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		if ($('#modMobile1').val() == '' || $('#modMobile2').val() == '' || $('#modMobile3').val() == '') {
			$('.helpCont').hide();
			$('#modMobile1').parents('td').children('.helpCont:eq(0)').show();
			return;
		}
		if (isNaN($('#modMobile1').val()) || isNaN($('#modMobile2').val()) || isNaN($('#modMobile3').val())) {
			$('.helpCont').hide();
			$('#modMobile1').parents('td').children('.helpCont:eq(1)').show();
			return;
		}

		$('.helpCont').hide();

		if (confirm("수정하시겠습니까?")) {
			if ($('#modEmail2').val() != 'manual') {
				$('#modPsnEmail').val($('#modEmail1').val() + '@' + $('#modEmail2').val());
			} else {
				$('#modPsnEmail').val($('#modEmail1').val() + '@' + $('#modEmail3').val());
			}
			$('#modPsnMobile').val($('#modMobile1').val() + '-' + $('#modMobile2').val() + '-' + $('#modMobile3').val());

			modifyUser();
		}
	}

	function modifyUser() {
		var formData = $("#modifyUserForm").serializeObject();
		$.ajax({
			url : "/modifyUser",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultCnt = result.resultCnt;
				if(resultCnt > 0) {
					alert('사용자 정보가 수정되었습니다.');

					// Local EMS 회원 연계
					changeEMSUserDB($("#modUserIdx").val());

					$("#modifyModal").modal("hide");
				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			}
		});
	}

	function removeUser() {
		var formData = $("#modifyUserForm").serializeObject();
		$.ajax({
			url : "/removeUser",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultCnt = result.resultCnt;
				if(resultCnt > 0) {
					alert('탈퇴처리 되었습니다.');

					// Local EMS 회원 연계
					changeEMSUserDB($("#modUserIdx").val());

					location.href = '/login';
				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			}
		});
	}
	</script>	
	<!-- //정보수정 -->



