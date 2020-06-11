<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>혜원솔라02 RTU 데이터 점검</title>
  </head>
  <body>
    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">출장/조치 보고서 </h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2020-04-13 17:01:02</em>
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
							<th>출장 시기</th>
							<td>2020-04-08 ~ 2020-04-10</td>
							<th>출장 장소</th>
							<td>혜원솔라 02</td>
						</tr>
						<tr>
							<th>작성 일자</th>
							<td>2020-04-10</td>
							<th>출장 목적</th>
							<td>RTU 데이터 점검</td>
						</tr>
						<tr>
							<th>소속 부서</th>
							<td>인코어드 엔지니어링팀</td>
							<th>출장자</th>
							<td>박준호</td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<a href="/report/maintenanceReportEdit.do">수정</a>
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
							<td>혜원솔라 02 RTU 데이터 점검진행 건</td>
						</tr>
						<tr>
							<th>현장 점검</th>
							<td><div class="img_bx"><img src="../img/reportSample03.png"><img src="../img/reportSample04.png"></div></td>
						</tr>
						<tr>
							<th>특이사항</th>
							<td>(1) RTU 데이터 통신 점검 양호</td>
						</tr>
						<tr>
							<th>향후 진행예정 업무</th>
							<td>RTU 장비 통신 상태 정기 점검 예정</td>
						</tr>
						<tr>
							<th>담당자 의견</th>
							<td>RTU 장비 통신 불량일 경우 라우터 교체 필요함</td>
						</tr>
						<tr>
							<th>첨부 파일</th>
							<td><span class="tx_file">혜원솔라 02 RTU 통신장비 라우터.jpg</span></td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<a href="/report/maintenanceReportEdit.do">수정</a>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
