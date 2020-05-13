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
		<div class="col-lg-12 clear inp_align">
			<div class="fl">
				<span class="tx_tit">기준</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">2020년
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
							<li><a href="#">전체</a></li>
							<li><a href="#">2020년</a></li>
							<li><a href="#">2019년</a></li>
							<li><a href="#">2018년</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="fl">
				<div class="tx_inp_type">
					<input type="text" placeholder="입력">
				</div>
			</div>
			<div class="fl">
				<button type="submit" class="btn_type">검색</button>
			</div>
			<div class="fr">
				<a href="#;" class="save_btn">CVS 다운로드</a>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type" onclick="location.href='/spc/balanceSheetPost.do'">신규 등록</button>
				</div>
				<div class="spc_tbl align_type">			
					<table class="chk_type">
						<thead>
							<tr>
								<th>
									<input type="checkbox" id="chk_op01" value="순번">
									<label for="chk_op01"><span></span>순번</label>
								</th>
								<th><button class="btn_align down">SPC명</button></th>
								<th><button class="btn_align down">발전소 명</button></th>
								<th><button class="btn_align down">기준년월</button></th>
								<th class="right"><button class="btn_align down">용량(kW)</button></th>
								<th class="right"><button class="btn_align down">현금유입(원)</button></th>
								<th class="right"><button class="btn_align down">현금유출(원)</button></th>
								<th class="right"><button class="btn_align down">기말 현금흐름(원)</button></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<input type="checkbox" id="chk_op02" value="1">
									<label for="chk_op02"><span></span>1</label>
								</td>
								<td>S-power</td>
								<td><a href="/spc/entityDetailsBySite.do" class="tbl_link">혜원솔라01</a></td>
								<td>2020-04</td>
								<td class="right">97.28</td>
								<td class="right">900,000</td>
								<td class="right">4,875,000</td>
								<td class="right">5,362,500</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" id="chk_op03" value="1">
									<label for="chk_op03"><span></span>2</label>
								</td>
								<td>S-power</td>
								<td><a href="/spc/entityDetailsBySite.do" class="tbl_link">혜원솔라02</a></td>
								<td>2020-04</td>
								<td class="right">97.28</td>
								<td class="right">900,000</td>
								<td class="right">4,875,000</td>
								<td class="right">5,362,500</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
								<td class="right"></td>
							</tr>
						</tbody>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" onclick="location.href='/spc/balanceSheetEdit.do'">선택 수정</button>
					<button type="button" class="btn_type03">선택 삭제</button>
				</div>
				<div class="paging_wrap">
					<a href="#;" class="btn_prev">prev</a>
					<strong>1</strong>
					<a href="#;" class="btn_next">next</a>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
