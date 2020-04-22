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
    <title>Title</title>
  </head>
  <body>
    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">발전량 누적 실적</h1>
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
				<span class="tx_tit">유형</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">전체
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
							<li><a href="#">전체</a></li>
							<li><a href="#">년간보고서</a></li>
							<li><a href="#">분기보고서</a></li>
							<li><a href="#">월간보고서</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="fl">
				<span class="tx_tit">발간월</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">2020년
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
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">전체
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
							<li><a href="#">전체</a></li>
							<li><a href="#">1월</a></li>
							<li><a href="#">2월</a></li>
							<li><a href="#">3월</a></li>
							<li><a href="#">4월</a></li>
							<li><a href="#">5월</a></li>
							<li><a href="#">6월</a></li>
							<li><a href="#">7월</a></li>
							<li><a href="#">8월</a></li>
							<li><a href="#">9월</a></li>
							<li><a href="#">10월</a></li>
							<li><a href="#">11월</a></li>
							<li><a href="#">12월</a></li>
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
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="spc_tbl align_type">			
					<table class="chk_type">
						<thead>
							<tr>
								<th>순번</th>
								<th>보고서 구분</th>
								<th>발전소명</th>
								<th>보고서 유형</th>
								<th>발간월</th>
								<th>다운로드</th>
								<th>보고서 확정</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1</td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라</a></td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라 01</a></td>
								<td>월간보고서</td>
								<td>2020-01</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37&month=2020-01'" ><button class="tx_file">EXCEL</button></td>
								<td>2020-03-01</td>
							</tr>
							<tr>
								<td>2</td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라</a></td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라 02</a></td>
								<td>월간보고서</td>
								<td>2020-01</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=0c7c90c6-9505-4f77-b42d-500c2879c689&month=2020-01'"><button class="tx_file">EXCEL</button></td>
								<td>2020-03-01</td>
							</tr>
							<tr>
								<td>3</td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라</a></td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라 01</a></td>
								<td>월간보고서</td>
								<td>2020-02</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37&month=2020-02'"><button class="tx_file">EXCEL</button></td>
								<td>2020-04-01</td>
							</tr>
							<tr>
								<td>4</td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라</a></td>
								<td><a href="/report/yieldReportDetails.do" class="tbl_link">혜원 솔라 02</a></td>
								<td>월간보고서</td>
								<td>2020-02</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=0c7c90c6-9505-4f77-b42d-500c2879c689&month=2020-02'"><button class="tx_file">EXCEL</button></td>
								<td>2020-04-01</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
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
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
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
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
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
								<td></td>
								<td></td>
							</tr>
						</tbody>
					</table>	
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
