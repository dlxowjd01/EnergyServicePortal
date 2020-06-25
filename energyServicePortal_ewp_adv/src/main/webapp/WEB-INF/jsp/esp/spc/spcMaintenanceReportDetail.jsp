<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">출장/조치 보고서</h1>
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
			<div class="right">
				<a href="#;" class="save_btn">PDF 다운로드</a>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="tbl_top">
					<h2 class="ntit mt25">출장 이력</h2>
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
							<th>출장시기</th>
							<td>2020-01-22 ~ 2020-01-23</td>
							<th>출장 장소</th>
							<td>OCI서울태양광발전수_암사 아리수 정수센터</td>
						</tr>
						<tr>
							<th>작성 일자</th>
							<td>2019-12-17</td>
							<th>출장 목적</th>
							<td>접속함 열화상 측정 , 인버터 설비 점검</td>
						</tr>
						<tr>
							<th>소속 부서</th>
							<td>기술지원팀</td>
							<th>출장자</th>
							<td>박재균 차장, 김세준 사원</td>
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
					<h2 class="ntit mt25">처리 내역</h2>
				</div>
				<div class="spc_tbl_row">			
					<table>
						<colgroup>
						<col style="width:10%">
						<col>
						</colgroup>
						<tr>
							<th>시스템 개요</th>
							<td>OCI 서울 태양광발전소 암사아리수 정수센터 정기점검 진행의 件</td>
						</tr>
						<tr>
							<th>현장 점검</th>
							<td><div class="img_bx"><img src="../img/@sample.jpg"><img src="../img/@sample.jpg"></div></td>
						</tr>
						<tr>
							<th>특이사항</th>
							<td>(1) 접속함 열화상 점검 진행 _ 양호<br>(2) 인버터 내부 열화상 점검 _ 양호</td>
						</tr>
						<tr>
							<th>향후 진행예정 업무</th>
							<td>발전소 각 기자재 정비 및 정밀검토 진행</td>
						</tr>
						<tr>
							<th>담당자 의견</th>
							<td>수배전반 기자재 바닥의 부분의 콘크리트 포장의 일부가 소손되어 추가적인 보수공사 진행이 필요함.</td>
						</tr>
						<tr>
							<th>첨부 파일</th>
							<td><span class="tx_file">암사정수장 수배전반 사진_JPG (17.8 KB)</span> / download - 1회</td>
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
