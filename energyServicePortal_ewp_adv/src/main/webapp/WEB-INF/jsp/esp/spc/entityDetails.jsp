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
						<td>S-power</td>
						<th>발전소명</th>
						<td>혜원솔라01</td>
					</tr>
					<tr>
						<th>주소</th>
						<td>강원도 고성군 간성읍 해상리 산 137-2</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="contract_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">운영 정보</h2>
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
						<td data-input="text" data-column="dept" >연구소</td>
						<th>담당자</th>
						<td data-input="text" data-column="manager" >박재균 010-4711-4415</td>
					</tr>
					<tr>
						<th>설치 용량</th>
						<td data-input="text" data-column="dept" >97.28 kW (계약)</td>
						<th>관리 운영 기간</th>
						<td data-input="text" data-column="dept" >2018-06-18 ~ 2020-12-31</td>
					</tr>
					<tr>
						<th>기상 관측 지점</th>
						<td data-input="text" data-column="dept" >38°23'36.2"N, 128°24'05.0"E</td>
						<th>하자 보증기간(전기)</th>
						<td data-input="text" data-column="dept" >2018-06-18</td>
					</tr>
					<tr>
						<th>사용 전 검사 완료일</th>
						<td data-input="text" data-column="dept" >2018-06-18</td>
						<th>하자 보증기간(토목)</th>
						<td data-input="text" data-column="dept" >-</td>
					</tr>
					<tr>
						<th>정기 검사</th>
						<td data-input="text" data-column="dept" >-</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>등기이사 소속 / 등기이사 명</th>
						<td data-input="text" data-column="dept" >에스파워 회장 / 홍성민</td>
						<th>등기 기간</th>
						<td data-input="text" data-column="dept" >-</td>
					</tr>
					<tr>
						<th>계약 단가</th>
						<td data-input="text" data-column="dept" >0 원</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setDataEditMode('contract_info');">수정</button>
				<button type="button" class="btn_type03">목록</button>
			</div>
		</div>
		<div class="indiv mt25" id="device_info">
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
						<td data-input="text" data-column="dept" >S-Energy / SM-300PC8</td>
						<th>설치 용량</th>
						<td data-input="text" data-column="dept" >100 kW / 2100 매</td>
					</tr>
					<tr>
						<th>모듈 설치 각도</th>
						<td data-input="text" data-column="dept" >32</td>
						<th>모듈 설치 방식</th>
						<td data-input="text" data-column="dept" >고정형</td>
					</tr>
					<tr>
						<th>인버터 제조사 / 모델</th>
						<td data-input="text" data-column="dept" >WILLIMGS / M10-100</td>
						<th>인버터 용량 / 대수</th>
						<td data-input="text" data-column="dept" >100 kW 1대</td>
					</tr>
					<tr>
						<th>접속반 제조사 / 모델</th>
						<td data-input="text" data-column="dept" >미래이엔아이 / MUX-COM</td>
						<th>접속반 채널 / 대수</th>
						<td data-input="text" data-column="dept" >16 Ch / 1대</td>
					</tr>
					<tr>
						<th>접속반 용량 / 통신방식</th>
						<td data-input="text" data-column="dept" >100 kW / 통신</td>
						<th>수배전반 제조사 / 모델</th>
						<td data-input="text" data-column="dept" >LS산전 / GIPAM-115FI</td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td data-input="text" data-column="dept" >그라운드</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setDataEditMode('device_info');">수정</button>
				<button type="button" class="btn_type03">목록</button>
			</div>
		</div>
		<div class="indiv mt25" id="finance_info">
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
						<td data-input="text" data-column="dept" >-</td>
						<th>관련 보험사</th>
						<td data-input="text" data-column="dept" >-</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setDataEditMode('finance_info');">수정</button>
				<button type="button" class="btn_type03">목록</button>
			</div>
		</div>
		<div class="indiv mt25" id="warranty_info">
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
						<td data-input="text" data-column="dept" >PR</td>
						<th>PR 보증치</th>
						<td data-input="text" data-column="dept" >75 %</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td data-input="text" data-column="dept" >3 h</td>
						<th>보증 감소율</th>
						<td data-input="text" data-column="dept" >연차별 0.5 %</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td data-input="text" data-column="dept" >145 원 /kW</td>
						<th>현재 적용 연차</th>
						<td data-input="text" data-column="dept" >3 년차</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td data-input="text" data-column="dept" >11,779 만원</td>
						<th>물가 반영 비율</th>
						<td data-input="text" data-column="dept" >100 %</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td data-input="text" data-column="dept" >무</td>
						<th>추가 보수 용량</th>
						<td data-input="text" data-column="dept" >0 kW 이상</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td data-input="text" data-column="dept" >0 %</td>
						<th>전력요금 종별</th>
						<td data-input="text" data-column="dept" >일반용(갑) kW</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setDataEditMode('warranty_info');">수정</button>
				<button type="button" class="btn_type03">목록</button>
			</div>
		</div>
		<div class="indiv mt25" id="coefficient_info">
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
						<td data-input="text" data-column="dept" >1.83 %</td>
						<th>PV modul modeling/params</th>
						<td data-input="text" data-column="dept" >2.00 %</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td data-input="text" data-column="dept" >98.5 % </td>
						<th>Soiling, mismatch</th>
						<td data-input="text" data-column="dept" >1 %</td>
					</tr>
					<tr>
						<th>Degradation estimation</th>
						<td data-input="text" data-column="dept" >1 %</td>
						<th>Resulting ann, Variability(sigma)</th>
						<td data-input="text" data-column="dept" >98 %</td>
					</tr>
					<tr>
						<th>System Degradation</th>
						<td data-input="text" data-column="dept" >0.5 %</td>
						<th>System Availability</th>
						<td data-input="text" data-column="dept" >99 %</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setDataEditMode('coefficient_info');">수정</button>
				<button type="button" class="btn_type03">목록</button>
			</div>
		</div>
		<div class="indiv mt25" id="contact_info">
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
						<td data-input="text" data-column="dept" >S-power</td>
						<th>회사 연락처</th>
						<td data-input="text" data-column="dept" >070-4339-7100</td>
					</tr>
					<tr>
						<th>전기안전 관리 대표자명</th>
						<td data-input="text" data-column="dept" >박재균 </td>
						<th>대표자 연락처</th>
						<td data-input="text" data-column="dept" >070-4339-7100</td>
					</tr>
					<tr>
						<th>전기안전 관리 담당자명</th>
						<td data-input="text" data-column="dept" >박재균</td>
						<th>담당자 연락처</th>
						<td data-input="text" data-column="dept" >010-4711-4415</td>
					</tr>
					<tr>
						<th>현장 잠금장치 비밀번호</th>
						<td data-input="text" data-column="dept" >-</td>
						<th>시공사</th>
						<td data-input="text" data-column="dept" >S-power</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setDataEditMode('contact_info');">수정</button>
				<button type="button" class="btn_type03">목록</button>
			</div>
		</div>
		<div class="indiv mt25" id="attachement_info">
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
						<td><div class="img_bx"><img src="../img/@sample02.png"></div></td>
						<td class="vbt"><button class="btn_file up">업로드</button></td>
					</tr>
					<tr>
						<th>수배전반</th>
						<td data-input="file" data-column="dept" ></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>케이블</th>
						<td data-input="file" data-column="dept" ></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>모듈</th>
						<td data-input="file" data-column="dept" ></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>인버터</th>
						<td><p class="tx_file">GCI2014-PS007-M10-100옥외형_제작사양서_V010_140922.pdf</p></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>결선도</th>
						<td><p class="tx_file">M10-100_계통도V020_150302.pdf</p></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>토목</th>
						<td data-input="file" data-column="dept" ></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>구조물</th>
						<td data-input="file" data-column="dept" ></td>
						<td><button class="btn_file up">업로드</button></td>
					</tr>
					<tr>
						<th>접속반</th>
						<td data-input="file" data-column="dept" ></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>기타설비</th>
						<td data-input="file" data-column="dept" ></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setDataEditMode('attachement_info');">수정</button>
				<button type="button" class="btn_type03">목록</button>
			</div>
		</div>
	</div>
</div>
</body>
</html>
