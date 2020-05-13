<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 16:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit">SPC 원가관리 등록/수정 이력</h2>
				<div class="spc_tbl ly_type">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col>
						</colgroup>
						<thead>
							<tr>
								<th>이름</th>
								<th>사용 아이디</th>
								<th>시작 시간</th>
								<th>종료 시간</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>김세준</td>
								<td>sj.kim@s-energy.com</td>
								<td>2020-05-04 16:15</td>
								<td>2020-05-04 16:15</td>
								<td>5월 SPC 원가 관리 정보 등록</td>
							</tr>
							<tr>
								<td>김세준</td>
								<td>sj.kim@s-energy.com</td>
								<td>2020-05-04 16:15</td>
								<td>2020-05-04 16:15</td>
								<td>5월 SPC 원가 관리 정보 수정</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type" data-dismiss="modal">확인</button>
			</div>
		</div>
	  </div>
	</div>

    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">SPC 원가관리</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2018-07-27 17:01:02</em>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="header_drop_area col-lg-2">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">사업소#1
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
					<li><a href="#">전체</a></li>
					<li><a href="#">2020</a></li>
					<li><a href="#">2019</a></li>
					<li><a href="#">2018</a></li>
				</ul>
			</div>
		</div>
		<div class="col-lg-10">
			<div class="right">
				<a href="#;" class="save_btn">다운로드</a>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv entity_site">
				<div class="btn_wrap_type">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">2020년
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
							<li><a href="#">전체</a></li>
							<li><a href="#">2020</a></li>
							<li><a href="#">2019</a></li>
							<li><a href="#">2018</a></li>
						</ul>
					</div>
				</div>
				<div class="spc_tbl align_type02">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>1월</th>
								<th>2월</th>
								<th>3월</th>
								<th>4월</th>
								<th>5월</th>
								<th>6월</th>
								<th>7월</th>
								<th>8월</th>
								<th>9월</th>
								<th>10월</th>
								<th>11월</th>
								<th>12월</th>
								<th>합계</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1. 현금유입</td>
								<td>1,150,000</td>
								<td>2,300,000</td>
								<td>1,700,000</td>
								<td>900,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">전략 판매 대금</td>
								<td>1,000,000</td>
								<td>2,000,000</td>
								<td>1,500,000</td>
								<td>800,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">REC 매매 대금</td>
								<td>150,000</td>
								<td>300,000</td>
								<td>20,000</td>
								<td>100,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td>2. 현금유출</td>
								<td>4,875,000</td>
								<td>4,875,000</td>
								<td>4,875,000</td>
								<td>4,875,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">차입금 상환(A)</td>
								<td>10,000</td>
								<td>10,000</td>
								<td>10,000</td>
								<td>10,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">차입금 상환(B)</td>
								<td>50,000</td>
								<td>50,000</td>
								<td>50,000</td>
								<td>50,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">이자 비용(A)</td>
								<td>5,000</td>
								<td>5,000</td>
								<td>5,000</td>
								<td>5,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">이자 비용(B)</td>
								<td>5,000</td>
								<td>5,000</td>
								<td>5,000</td>
								<td>5,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">대리 기관 수수료</td>
								<td>500</td>
								<td>500</td>
								<td>500</td>
								<td>500</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">관리 운영 수수료</td>
								<td>1,500</td>
								<td>1,500</td>
								<td>1,500</td>
								<td>1,500</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">법인세</td>
								<td>300,000</td>
								<td>300,000</td>
								<td>300,000</td>
								<td>300,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">부가세</td>
								<td>3,000</td>
								<td>3,000</td>
								<td>3,000</td>
								<td>3,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">임대료</td>
								<td>1,500,000</td>
								<td>1,500,000</td>
								<td>1,500,000</td>
								<td>1,500,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">기타비용</td>
								<td>3,000,000</td>
								<td>3,000,000</td>
								<td>3,000,000</td>
								<td>3,000,000</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td>3. 기말 현금 흐름</td>
								<td>10,000,000</td>
								<td>20,000,000</td>
								<td>10,000,000</td>
								<td>5,362,500</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
							<tr>
								<td class="sub_td">기말 현금</td>
								<td>490,000,000</td>
								<td>470,000,000</td>
								<td>460,000,000</td>
								<td>454,637,500</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
								<td>0</td>
							</tr>
						</tbody>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
					<button type="button" class="btn_type" data-toggle="modal" data-target="#myModal">이력확인</button>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
