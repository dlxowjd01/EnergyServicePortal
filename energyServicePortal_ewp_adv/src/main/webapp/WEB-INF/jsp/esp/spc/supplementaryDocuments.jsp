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
			<h1 class="page-header">SPC 이관자료</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2018-07-27 17:01:02</em>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-3">
			<div class="tx_btn_area">
				<div class="tx_inp_type">
					<input type="text" placeholder="입력">
				</div>
				<button type="submit" class="btn_type">검색</button>
			</div>
		</div>
		<div class="col-lg-9">
			<div class="right">
				<a href="#;" class="save_btn">CVS 다운로드</a>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="spc_tbl align_type">
					<table class="chk_type mt30">
						<thead>
							<tr>
								<th>
									<input type="checkbox" id="chk_op01" value="순번">
									<label for="chk_op01"><span></span>순번</label>
								</th>
								<th><button class="btn_align up">SPC명</button></th>
								<th><button class="btn_align up">발전소 명</button></th>
								<th class="right"><button class="btn_align up">용량(kW)</button></th>
								<th><button class="btn_align down">관리 운영기간</button></th>
								<th class="right"><button class="btn_align up">이관자료</button></th>
								<th class="right"><button class="btn_align down">첨부파일</button></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<input type="checkbox" id="chk_op02" value="1">
									<label for="chk_op02"><span></span>1</label>
								</td>
								<td><a href="/spc/entityDetailsBySPC.do" class="tbl_link">OCI 서울</a></td>
								<td><a href="/spc/entityDetailsBySPC.do" class="tbl_link">암사 정수장</a></td>
								<td class="right">2,300.00 kW</td>
								<td>2013-09-03 ~ 2018-05-09</td>
								<td class="right">11 / 23</td>
								<td class="right">11건</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" id="chk_op03" value="1">
									<label for="chk_op03"><span></span>2</label>
								</td>
								<td><a href="/spc/entityDetailsBySPC.do" class="tbl_link">OCI 서울</a></td>
								<td><a href="/spc/entityDetailsBySPC.do" class="tbl_link">암사 정수장</a></td>
								<td class="right">120.00 kW</td>
								<td>2013-09-03 ~ 2018-05-09</td>
								<td class="right">11 / 23</td>
								<td class="right">11건</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
						</tbody>
					</table>	
				</div>
				<div class="paging_wrap">
					<a href="#;" class="btn_prev">prev</a>
					<strong>1</strong>
					<a href="#;">2</a>
					<a href="#;">3</a>
					<a href="#;" class="btn_next">next</a>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
