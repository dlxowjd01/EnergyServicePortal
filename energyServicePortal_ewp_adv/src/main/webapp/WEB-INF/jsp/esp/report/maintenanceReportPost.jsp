<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/05/13
  Time: 14:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>작업 보고서 등록</title>
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
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv report_post">
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
							<td>
								<div class="sel_calendar edit twin clear">
									<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" placeholder="시작일">
									<input type="text" id="datepicker2" class="sel" value="" autocomplete="off" placeholder="종료일">
								</div>
							</td>
							<th>출장 장소</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>작성 일자</th>
							<td>
								<div class="sel_calendar edit">
									<input type="text" id="datepicker3" class="sel" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</td>
							<th>출장 목적</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>소속 부서</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<th>출장자</th>
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
			<div class="indiv mt25 report_post02">
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
							<td>
								<div class="txarea_inp_type">
									<textarea placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="vert_type">현장 점검<button class="btn_file up">업로드</button></th>
							<td>
								<div class="img_bx">
									<!--<img src="../img/reportSample01.png">
									<img src="../img/reportSample02.png">-->
								</div>
							</td>
						</tr>
						<tr>
							<th>특이사항</th>
							<td>
								<div class="txarea_inp_type">
									<textarea placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th>향후 진행예정 업무</th>
							<td>
								<div class="txarea_inp_type">
									<textarea placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th>담당자 의견</th>
							<td>
								<div class="txarea_inp_type">
									<textarea placeholder="내용 추가" rows="4"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th class="hei_type">첨부 파일<button class="btn_file up">업로드</button></th>
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
