<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/21
  Time: 15:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>혜원 솔라 01 RTU 설치 점검 QC 보고서</title>
  </head>
  <body>
    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">출장/조치 보고서 </h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2020-04-06 17:01:02</em>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div>
				<span class="tx_tit">보고서 구분</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w9" type="button" data-toggle="dropdown">출장/조치 보고서
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu chk_type" role="menu" id="type">
							<li><a href="#;">출장/조치 보고서</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--<div class="row">
		<div class="col-lg-12">
			<div class="right">
				<a href="#;" class="save_btn">PDF 다운로드</a>
			</div>
		</div>
	</div>-->
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
							<td>2020-04-01 ~ 2020-04-06</td>
							<th>출장 장소</th>
							<td>혜원솔라 01</td>
						</tr>
						<tr>
							<th>작성 일자</th>
							<td>2020.04.01</td>
							<th>출장 목적</th>
							<td>혜원솔라 1호기 RTU 설치공사 QC 점검</td>
						</tr>
						<tr>
							<th>소속 부서</th>
							<td>인코어드 엔지니어링팀</td>
							<th>출장자</th>
							<td>박준호, 이세용, 최상훈, 권종인</td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" onclick="location.href='/report/maintenanceReportEdit.do'">수정</button>
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
						<col style="width:15%">
						<col>
						</colgroup>
						<tr>
							<th>시스템 개요</th>
							<td>혜원솔라 1호기 RTU 설치공사 및 데이터 QC 점검 진행건</td>
						</tr>
						<tr>
							<th>현장 점검</th>
							<td><div class="img_bx"><img src="../img/reportSample01.png"><img src="../img/reportSample02.png"></div></td>
						</tr>
						<tr>
							<th>특이사항</th>
							<td>(1) RTU 설치공사 - 양호<br>(2) RTU 데이터 통신 상태 점검 - 양호</td>
						</tr>
						<tr>
							<th>향후 진행예정 업무</th>
							<td>데이터 정밀 검토 및 통신 상태 점검</td>
						</tr>
						<tr>
							<th>담당자 의견</th>
							<td>인버터 내에 RTU 정상 설치 완료 후 통신 상태 확인 DATA 수신 상태 양호함</td>
						</tr>
						<tr>
							<th>첨부 파일</th>
							<td><span class="tx_file">혜원솔라01 인버터 내부 및 RTU 사진.jpg <span class="tx_color">/ download - 1회</span></span></td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" onclick="location.href='/report/maintenanceReportEdit.do'">수정</button>
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
