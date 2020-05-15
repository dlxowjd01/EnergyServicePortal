<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/05/14
  Time: 15:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>SPC 기본 정보 수정</title>
  </head>
  <body>
     <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">SPC 기본 정보 수정</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2018-07-27 17:01:02</em>
			</div>
		</div>
	</div>
	<div class="row entity_wrap edit">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>SPC명</th>
							<td class="group_type03">
								<div class="dropdown edit">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">SPC
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" id="type">
										<li><a href="#;">SPC</a></li>
									</ul>
								</div>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="SPC명 입력">
								</div>
							</td>
							<th>발전소명</th>
							<td class="group_type03">
								<div class="dropdown edit">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">OCI 서울
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" id="type">
										<li><a href="#;">발전소1</a></li>
										<li><a href="#;">발전소2</a></li>
									</ul>
								</div>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="발전소명 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>주소</th>
							<td colspan="3" class="group_type03">
								<div class="dropdown placeholder edit">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">대한 민국
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" id="type">
										<li><a href="#;">대한민국</a></li>
									</ul>
								</div>
								<div class="dropdown placeholder edit">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">서울특별시
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" id="type">
										<li><a href="#;">서울특별시</a></li>
										<li><a href="#;">부산광역시</a></li>
									</ul>
								</div>
								<div class="tx_inp_type edit">
									<input type="text" value="서울 강동구 아리수로 131 (암사동)">
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
			<div class="indiv mt25" id="contract_info">
				<div class="tbl_top">
					<h2 class="ntit mt25">운영 정보</h2>
				</div>
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>담당부서</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="운영팀">
								</div>
							</td>
							<th>담당자</th>
							<td class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" value="홍길동">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" value="010-1234-5678">
								</div>
							</td>
						</tr>
						<tr>
							<th>설치 용량</th>
							<td class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="1234">
									<span>kW</span>
								</div>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="태양광,ESS">
								</div>
							</td>
							<th>관리 운영 기간</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>기상 관측 지점</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<th>하자 보증기간(전기)</th>
							<td>
								<div class="sel_calendar edit twin clear">
									<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" placeholder="시작일">
									<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" placeholder="종료일">
								</div>
							</td>
						</tr>
						<tr>
							<th>사용 전 검사 완료일</th>
							<td>
								<div class="sel_calendar edit">
									<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</td>
							<th>하자 보증기간(토목)</th>
							<td>
								<div class="sel_calendar edit twin clear">
									<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" placeholder="시작일">
									<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" placeholder="종료일">
								</div>
							</td>
						</tr>
						<tr>
							<th>정기 검사</th>
							<td class="group_type02">
								<div class="tx_inp_type edit">
									<input type="text" placeholder="주기">
								</div>
								<div class="sel_calendar edit twin clear fl">
									<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" placeholder="월 선택">
									<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" placeholder="일 선택">
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>등기이사 소속 / 등기이사 명</th>
							<td class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" placeholder="등기이사 소속">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="등기이사 명">
								</div>
							</td>
							<th>등기 기간</th>
							<td>
								<div class="sel_calendar edit twin clear fl">
									<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" placeholder="시작일">
									<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" placeholder="종료일">
								</div>
								<div class="chk_type align_type fl">
									<span>
										<input type="checkbox" id="chk_04_op01" name="chk_04_op01" checked>
										<label for="chk_04_op01"><span></span>등기이사 만료 알림</label>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>계약 단가</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>원</span>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
			<div class="indiv mt25" id="device_info">
				<div class="tbl_top">
					<h2 class="ntit mt25">설비 정보</h2>
				</div>
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>모듈 제조사 / 모델<a href="#" class="btn_add fr">추가</a></th>
							<td class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" value="S-Energy">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" value="SM-300PC8">
								</div>
							</td>
							<th>설치 용량</th>
							<td class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="2,499.00">
									<span>kW</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="10,200">
									<span>매</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>모듈 설치 각도<a href="#" class="btn_add fr">추가</a></th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="30">
									<span>︒</span>
								</div>
							</td>
							<th>모듈 설치 방식</th>
							<td>
								<div class="chk_type align_type">
									<span>
										<input type="checkbox" id="chk_op01" name="chk_op" checked>
										<label for="chk_op01"><span></span>고정 가변식</label>
									</span>
									<span>
										<input type="checkbox" id="chk_op02" name="chk_op" >
										<label for="chk_op02"><span></span>트래커</label>
									</span>
									<span>
										<input type="checkbox" id="chk_op03" name="chk_op">
										<label for="chk_op03"><span></span>경사 고정형</label>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>인버터 제조사 / 모델<a href="#" class="btn_add fr">추가</a></th>
							<td class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" value="현대중공업">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" value="HPC-500HL-K1">
								</div>
							</td>
							<th>인버터 용량 / 대수<a href="#" class="btn_add fr">추가</a></th>
							<td class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="500">
									<span>kW</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="5">
									<span>대</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>접속반 제조사 / 모델<a href="#" class="btn_add fr">추가</a></th>
							<td class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" value="미래이엔아이">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" value="MUX-COM">
								</div>
							</td>
							<th>접속반 채널 / 대수<a href="#" class="btn_add fr">추가</a></th>
							<td class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="15">
									<span>Ch</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="4">
									<span>대</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>접속반 용량 / 통신방식</th>
							<td class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" value="100">
									<span>kW</span>
								</div>
								<div class="rdo_type align_type">
									<span>
										<input type="radio" id="rdo_03_op01" name="rdo_op" checked>
										<label for="rdo_03_op01"><span></span>통신</label>
									</span>
									<span>
										<input type="radio" id="rdo_03_op02" name="rdo_op" >
										<label for="rdo_03_op02"><span></span>비통신</label>
									</span>
								</div>
							</td>
							<th>수배전반 제조사 / 모델<a href="#" class="btn_add fr">추가</a></th>
							<td class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" value="LS산전">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" value="GIPAM-115FI">
								</div>
							</td>
						</tr>
						<tr>
							<th>설치 타입</th>
							<td>
								<div class="chk_type align_type">
									<span>
										<input type="checkbox" id="chk_02_op01" name="chk_op2">
										<label for="chk_02_op01"><span></span>그라운드</label>
									</span>
									<span>
										<input type="checkbox" id="chk_02_op02" name="chk_op2" checked>
										<label for="chk_02_op02"><span></span>루프탑</label>
									</span>
									<span>
										<input type="checkbox" id="chk_02_op03" name="chk_op2">
										<label for="chk_02_op03"><span></span>수상</label>
									</span>
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
			<div class="indiv mt25" id="finance_info">
				<div class="tbl_top">
					<h2 class="ntit mt25">금융 정보</h2>
				</div>
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>관련 금융사</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="흥국자산운용">
								</div>
							</td>
							<th>관련 보험사</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
			<div class="indiv mt25" id="warranty_info">
				<div class="tbl_top">
					<h2 class="ntit mt25">보증 정보</h2>
				</div>
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>보증 방식</th>
							<td>
								<div class="rdo_type align_type">
									<span>
										<input type="radio" id="rdo_op01" name="rdo_op">
										<label for="rdo_op01"><span></span>PR</label>
									</span>
									<span>
										<input type="radio" id="rdo_op02" name="rdo_op" >
										<label for="rdo_op02"><span></span>발전 시간</label>
									</span>
									<span>
										<input type="radio" id="rdo_op03" name="rdo_op">
										<label for="rdo_op03"><span></span>PR + 발전 시간</label>
									</span>
								</div>
							</td>
							<th>PR 보증치</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>발전시간 보증치</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>h</span>
								</div>
							</td>
							<th>보증 감소율</th>
							<td>
								<div class="tx_inp_type edit unit t2">
									<input type="text">
									<span>년차별 %</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>기준 단가</th>
							<td class="group_type">
								<div class="dropdown placeholder edit">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">기준 단가 선택
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu" id="type">
										<li><a href="#;">기준 단가 선택</a></li>
									</ul>
								</div>
								<div class="tx_inp_type edit unit t2">
									<input type="text">
									<span>원 / kW</span>
								</div>
							</td>
							<th>현재 적용 연차</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>년차</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>년간 관리 운영비 (1년차)</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>만원</span>
								</div>
							</td>
							<th>물가 반영 비율</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>추가 보수</th>
							<td>
								<div class="rdo_type align_type">
									<span>
										<input type="radio" id="rdo_op2_01" name="rdo_op02">
										<label for="rdo_op2_01"><span></span>유</label>
									</span>
									<span>
										<input type="radio" id="rdo_op2_02" name="rdo_op02" >
										<label for="rdo_op2_02"><span></span>무</label>
									</span>
								</div>
							</td>
							<th>추가 보수 용량</th>
							<td>
								<div class="tx_inp_type edit unit t2">
									<input type="text">
									<span>kW 이상</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>추가 보수 백분율</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
							<th>전력요금 종별</th>
							<td class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" placeholder="요금제">
								</div>
								<div class="tx_inp_type edit unit t2">
									<input type="text" placeholder="계약 전력">
									<span>kW</span>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
			<div class="indiv mt25" id="coefficient_info">
				<div class="tbl_top">
					<h2 class="ntit mt25">환경 변수</h2>
				</div>
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>Annual Variability</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
							<th>PV modul modeling/params</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>Inverter efficiency</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
							<th>Soiling, mismatch</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>Degradation estimation</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
							<th>Resulting ann, Variability(sigma)</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>System Degradation</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
							<th>System Availability</th>
							<td>
								<div class="tx_inp_type edit unit t1">
									<input type="text">
									<span>%</span>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
			<div class="indiv mt25" id="contact_info">
				<div class="tbl_top">
					<h2 class="ntit mt25">관련 정보</h2>
				</div>
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tr>
							<th>전기안전 관리 회사명</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<th>회사 연락처</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>전기안전 관리 대표자명</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<th>대표자 연락처</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>전기안전 관리 담당자명</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<th>담당자 연락처</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>현장 잠금장치 비밀번호</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<th>시공사</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
			<div class="indiv mt25" id="attachement_info">
				<div class="tbl_top">
					<h2 class="ntit mt25">첨부 파일</h2>
				</div>
				<div class="spc_tbl_row">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:20%">
							<col>
						</colgroup>
						<tr>
							<th class="th_type">현장 사진<a href="#" class="btn_add fr">추가</a></th>
							<td>
								<div class="img_bx">
									<div class="img_group">
										<img src="../img/reportSample02.png">
										<button class="btn_img_clse">삭제</button>
									</div>
								</div>
							</td>
							<td></td>
						</tr>
						<tr>
							<th>수배전반<a href="#" class="btn_add fr">추가</a></th>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>케이블<a href="#" class="btn_add fr">추가</a></th>
							<td><p class="tx_file">M10-100_계통도V020_150302.pdf</p></td>
							<td><button class="btn_clse">삭제</button></td>
						</tr>
						<tr>
							<th>모듈<a href="#" class="btn_add fr">추가</a></th>
							<td><p class="tx_file">M10-100_계통도V020_150302.pdf</p></td>
							<td><button class="btn_clse">삭제</button></td>
						</tr>
						<tr>
							<th>인버터<a href="#" class="btn_add fr">추가</a></th>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>결선도<a href="#" class="btn_add fr">추가</a></th>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>토목<a href="#" class="btn_add fr">추가</a></th>
							<td><p class="tx_file">M10-100_계통도V020_150302.pdf</p></td>
							<td><button class="btn_clse">삭제</button></td>
						</tr>
						<tr>
							<th>구조물<a href="#" class="btn_add fr">추가</a></th>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>접속반<a href="#" class="btn_add fr">추가</a></th>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>기타설비<a href="#" class="btn_add fr">추가</a></th>
							<td></td>
							<td></td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type">등록</button>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
