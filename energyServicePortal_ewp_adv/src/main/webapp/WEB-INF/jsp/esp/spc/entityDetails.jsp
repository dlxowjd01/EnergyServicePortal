<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 15:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">SPC 기본 정보</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2018-07-27 17:01:02</em>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>SPC명</th>
							<td>암사정수장</td>
							<th>발전소명</th>
							<td>OCI서울</td>
						</tr>
						<tr>
							<th>주소</th>
							<td>서울 강동구 아리수로 131 (암사동)</td>
							<th></th>
							<td></td>
						</tr>
					</table>	
				</div>
			</div>
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">데이터 수집 로그</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>담당부서</th>
							<td>운영팀</td>
							<th>담당자</th>
							<td>홍길동 010-1234-1234</td>
						</tr>
						<tr>
							<th>관리 운영 기간</th>
							<td>2013-03-30 ~ 2015-03-30</td>
							<th>설치 음량</th>
							<td>2499kW (계약)</td>
						</tr>
						<tr>
							<th>기상 관측 지점</th>
							<td>2013-03-30 ~ 2015-03-30</td>
							<th>하자 보증기간 (전기)</th>
							<td>108</td>
						</tr>
						<tr>
							<th>사용 전 검사 완료일</th>
							<td>2013-03-30 ~ 2015-03-30</td>
							<th>하자 보증기간 (토목)</th>
							<td>2013-07-31</td>
						</tr>
						<tr>
							<th>정기 검사</th>
							<td>1 주기 (07-31)</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>등기이사 소속 / 등기이사 명</th>
							<td>에스파워 홍길동</td>
							<th>등기 기간</th>
							<td>2013-07-31</td>
						</tr>
						<tr>
							<th>계약 단가</th>
							<td>1 주기 (07-31)</td>
							<th></th>
							<td></td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">설비 정보</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>모듈 제조사 / 모델</th>
							<td>S-Energy / SM-300PC8</td>
							<th>설치 용량</th>
							<td>2,499.00 kW / 10,200 매</td>
						</tr>
						<tr>
							<th>모듈 설치 각도</th>
							<td>30︒</td>
							<th>모듈 설치 방식</th>
							<td>고정형</td>
						</tr>
						<tr>
							<th>인버터 제조사 / 모델</th>
							<td>현대중공업 / HPC-500HL-K1</td>
							<th>인버터 용량 / 대수</th>
							<td>500 kW / 5 대</td>
						</tr>
						<tr>
							<th>접속반 제조사 / 모델</th>
							<td>미래이엔아이 / MUX-COM</td>
							<th>접속반 채널 / 대수</th>
							<td>16 Ch / 3대</td>
						</tr>
						<tr>
							<th>접속반 용량 / 통신방식</th>
							<td>100 kW / 통신</td>
							<th>수배전반 제조사 / 모델</th>
							<td>LS산전 / GIPAM-115FI</td>
						</tr>
						<tr>
							<th>설치 타입</th>
							<td>루프탑</td>
							<th></th>
							<td></td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">금융 정보</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>관련 금융사</th>
							<td>흥국자산운용</td>
							<th>관련보험사</th>
							<td></td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">보증 정보</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>보증 방식</th>
							<td>PR</td>
							<th>PR 보증치</th>
							<td>74.00 %</td>
						</tr>
						<tr>
							<th>발전시간 보증치</th>
							<td>0 h</td>
							<th>보증 감소율</th>
							<td>연차별 0.5 %</td>
						</tr>
						<tr>
							<th>기준 단가</th>
							<td>145 원 /kW</td>
							<th>현재 적용 연차</th>
							<td>6 년차</td>
						</tr>
						<tr>
							<th>년간 관리 운영비 (1년차)</th>
							<td>11,789 만원</td>
							<th>접속반 채널 / 대수</th>
							<td>100 %</td>
						</tr>
						<tr>
							<th>추가 보수</th>
							<td>무</td>
							<th>추가 보수 용량</th>
							<td>0 kW 이상</td>
						</tr>
						<tr>
							<th>추가 보수 백분율</th>
							<td>0 %</td>
							<th>전력요금 종별</th>
							<td>일반용(갑) kW</td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">환경 변수</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>Annual Variability</th>
							<td>1.83 %</td>
							<th>PV modul modeling/params</th>
							<td>2.00 %</td>
						</tr>
						<tr>
							<th>Inverter efficiency</th>
							<td>98.50 % </td>
							<th>Soiling, mismatch</th>
							<td>1.00 %</td>
						</tr>
						<tr>
							<th>Degradation estimation</th>
							<td>1.00 %</td>
							<th>Resulting ann, Variability(sigma)</th>
							<td>98.55 %</td>
						</tr>
						<tr>
							<th>System Degradation</th>
							<td>0.50 %</td>
							<th>System Availability</th>
							<td>99.00 %</td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">관련 정보</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>전기안전 관리 회사명</th>
							<td>(주)썬텍 엔지니어링</td>
							<th>회사 연락처</th>
							<td>010-3630-0104</td>
						</tr>
						<tr>
							<th>전기안전 관리 대표자명</th>
							<td>정용선 </td>
							<th>대표자 연락처</th>
							<td>010-9153-9515</td>
						</tr>
						<tr>
							<th>전기안전 관리 담당자명</th>
							<td>양승환</td>
							<th>담당자 연락처</th>
							<td>담당자 연락처</td>
						</tr>
						<tr>
							<th>현장 잠금장치 비밀번호</th>
							<td>1234</td>
							<th>시공사</th>
							<td>현대 중공업</td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">첨부 파일</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:10%">
						<col style="width:20%">
						<col>
						</colgroup>
						<tr>
							<th>현장 사진</th>
							<td><div class="img_bx"><img src="../img/@sample.jpg"></div></td>
							<td class="vbt"><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>수배전반</th>
							<td><p class="tx_file">암사 아리수 정수센터 수배전반 외형도.xlxs</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>케이블</th>
							<td><p class="tx_file">암사 아리수 정수센터 케이블 설비도.xlxs</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>모듈</th>
							<td><p class="tx_file">암사 아리수 정수센터 모듈패치 평명도.xlxs</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>인버터</th>
							<td><p class="tx_file">암사 아리수 정수센터 인버터 외함 외형도.xlxs</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>결선도</th>
							<td><p class="tx_file">암사 아리수 정수센터 전기결선도.xlxs</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>토목</th>
							<td><p class="tx_file">암사 아리수 정수센터 토목.xlxs</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>구조물</th>
							<td></td>
							<td><button class="btn_file up">업로드</button></td>
						</tr>
						<tr>
							<th>접속반</th>
							<td><p class="tx_file">암사 아리수 정수센터 접속함 상세도.xlxs</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
						<tr>
							<th>기타설비</th>
							<td><p class="tx_file">MODBUS protocol GIPAM-115Fl MAP(110708).pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
