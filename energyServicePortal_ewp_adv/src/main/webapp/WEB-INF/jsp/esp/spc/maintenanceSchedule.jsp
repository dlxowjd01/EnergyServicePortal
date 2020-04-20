<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 15:54
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
			<h1 class="page-header">SPC 점검계획</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2018-07-27 17:01:02</em>
			</div>
		</div>
		<div class="col-lg-2 clear">
			<div class="sch_sel_area">
				<div class="sch_sel_item">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">2020년
						<span class="caret"></span></button>
						<ul class="dropdown-menu dropdown-menu-form">
							<li class="dropdown_cov clear">
								<div class="sec_li_bx">
									<ul>
										<li><a href="#">전체</a></li>
										<li><a href="#">2020</a></li>
										<li><a href="#">2019</a></li>
										<li><a href="#">2018</a></li>
									<ul>
								</div>
							</li>
						</ul>
					</div>
				</div>
				<div class="sch_sel_item">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">04월
						<span class="caret"></span></button>
						<ul class="dropdown-menu dropdown-menu-form">
							<li class="dropdown_cov clear">
								<div class="sec_li_bx">
									<ul>
										<li><a href="#">1월</a></li>
										<li><a href="#">2월</a></li>
										<li><a href="#">3월</a></li>
										<li><a href="#">4월</a></li>
									<ul>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-2 sch_left">
			<div class="indiv">
				<h2 class="ntit">점검 구분</h2>
				<div class="sch_inp_area">
					<div class="chk_type c1">
						<input type="checkbox" id="chk_op01" value="정기점검">
						<label for="chk_op01"><span></span>정기점검</label>
					</div>
					<div class="chk_type c2">
						<input type="checkbox" id="chk_op02" value="구조물 안전진단">
						<label for="chk_op02"><span></span>구조물 안전진단</label>
					</div>
					<div class="chk_type c3">
						<input type="checkbox" id="chk_op03" value="소방점검">
						<label for="chk_op03"><span></span>소방점검</label>
					</div>
					<div class="chk_type c4">
						<input type="checkbox" id="chk_op04" value="등기이사 기간만료">
						<label for="chk_op04"><span></span>등기이사 기간만료</label>
					</div>
				</div>
				
				<h2 class="ntit">발전소</h2>
				<div class="tx_inp_type">
					<input type="text" placeholder="입력">
				</div>
			</div>
		</div>
		<div class="col-lg-10">
			<div class="indiv pd_type">
				<div class="schedule_area">
					<div class="sch_top_info clear">
						<div class="sch_btn fl">
							<button class="btn_type03 active">오늘</button>
							<button class="btn_prev_mon">prev</button>
							<button class="btn_next_mon">next</button>
							<strong>4월</strong>
						</div>
						<button class="btn_type fr">등록</button>
					</div>
					<div class="sch_btm_area">
						<table>
							<colgroup>
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col>
							</colgroup>
							<thead>
								<tr>
									<th>일</th>
									<th>월</th>
									<th>화</th>
									<th>수</th>
									<th>목</th>
									<th>금</th>
									<th>토</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td></td>
									<td></td>
									<td></td>
									<td><span class="date">1</span></td>
									<td><span class="date">2</span></td>
									<td><span class="date">3</span></td>
									<td><span class="date">4</span></td>
								</tr>
								<tr>
									<td><span class="date">5</span></td>
									<td><span class="date">6</span></td>
									<td><span class="date">7</span></td>
									<td><span class="date">8</span></td>
									<td><span class="date">9</span></td>
									<td><span class="date">10</span></td>
									<td>
										<span class="date">11</span>
										<p class="bu t1">[OCI서울] 정기 점검</p>
									</td>
								</tr>
								<tr>
									<td><span class="date">12</span></td>
									<td><span class="date">13</span></td>
									<td><span class="date">14</span></td>
									<td><span class="date">15</span></td>
									<td><span class="date">16</span></td>
									<td><span class="date">17</span></td>
									<td><span class="date">18</span></td>
								</tr>
								<tr>
									<td class="today"><span class="date">19</span></td>
									<td><span class="date">20</span></td>
									<td><span class="date">21</span></td>
									<td><span class="date">22</span></td>
									<td>
										<span class="date">23</span>
										<p class="bu t4">[OCI서울] 등기이사 기간만료</p>
									</td>
									<td><span class="date">24</span></td>
									<td><span class="date">25</span></td>
								</tr>
								<tr>
									<td><span class="date">26</span></td>
									<td><span class="date">27</span></td>
									<td><span class="date">28</span></td>
									<td>
										<span class="date">29</span>
										<p class="bu t3">[OCI서울] 구조물</p>
									</td>
									<td>
										<span class="date">30</span>
										<p class="bu t4">[한영강재공업] 소방점검</p>
										<p class="bu t3">[OCI서울] 구조물 안전진단</p>
									</td>
									<td></td>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
