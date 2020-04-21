<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header fl">수집 현황</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2018-07-27 17:01:02</em>
			  </div>
		</div>
		<div class="header_drop_area col-lg-2">
			<div class="dropdown">
			  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">사업소#1,사업소#2
				<span class="caret"></span></button>
			  <ul class="dropdown-menu dropdown-menu-form chk_type">
				<li class="dropdown_cov clear">
				  <div class="sec_li_bx">
					<p class="tx_li_tit">사업소 별</p>
					<ul>
					  <li>
						<a href="#" data-value="option1" tabindex="-1">
						  <input type="checkbox" id="chk_op1" value="사업소#1">
						  <label for="chk_op01"><span></span>사업소#1</label>
						</a>
					  </li>
					  <li>
						<a href="#" data-value="option1" tabindex="-1">
						  <input type="checkbox" id="chk_op2" value="사업소#2">
						  <label for="chk_op02"><span></span>사업소#2</label>
						</a>
					  </li>
					  <li>
						<a href="#" data-value="option1" tabindex="-1">
						  <input type="checkbox" id="chk_op3" value="사업소#3">
						  <label for="chk_op03"><span></span>사업소#3</label>
						</a>
					  </li>
					  <li>
						<a href="#" data-value="option1" tabindex="-1">
						  <input type="checkbox" id="chk_op4" value="사업소#4">
						  <label for="chk_op04"><span></span>사업소#4</label>
						</a>
					  </li>
					  <ul>
				  </div>
				</li>
			  </ul>
			</div>
		</div>
		<div class="col-lg-10">
			<div class="collect_btn">
				<a href="#" class="btn_type02">로그 저장</a>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-5">
			<div class="indiv">
				<div class="tbl_wrap_type collect_wrap">
					<div class="tbl_top clear">
						<h2 class="ntit fl">접속반</h2>
					</div>
					<table class="his_tbl">
						<thead>
							<tr>
								<th>사이트 ID</th>
								<th>RTU ID</th>
								<th>RTU 시리얼 번호</th>
								<th>등록 일자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
						</tbody>
					</table>
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
		<div class="col-lg-7">
			<div class="indiv">
				<div class="tbl_wrap_type collect_wrap">
					<div class="tbl_top clear">
						<h2 class="ntit fl">Local EMS</h2>
					</div>
					<table class="his_tbl">
						<thead>
							<tr>
								<th>사이트 ID</th>
								<th>로컬 EMS ID</th>
								<th>로컬 EMS 주소</th>
								<th>로컬 EMS 암호키</th>
								<th>등록 일자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>S09234875</td>
								<td>2020-10-10</td>
							</tr>
						</tbody>
					</table>
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
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="tbl_wrap_type collect_wrap">
					<div class="tbl_top clear">
						<h2 class="ntit fl">데이터 수집 로그</h2>
					</div>
					<table class="his_tbl">
						<colgroup>
						<col style="width:10%">
						<col style="width:10%">
						<col style="width:10%">
						<col style="width:12%">
						<col style="width:12%">
						<col style="width:10%">
						<col>
						</colgroup>
						<thead>
							<tr>
								<th>사이트 ID</th>
								<th>수집 타입 ID</th>
								<th>수집기 ID</th>
								<th>송신 시간</th>
								<th>수신 시간</th>
								<th>상태</th>
								<th>수신 데이터</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020.02.20 15:00:00</td>
								<td>2020.02.20 15:00:00</td>
								<td>STOP</td>
								<td class="ellipsis">AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020.02.20 15:00:00</td>
								<td>2020.02.20 15:00:00</td>
								<td>STOP</td>
								<td class="ellipsis">AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020.02.20 15:00:00</td>
								<td>2020.02.20 15:00:00</td>
								<td>STOP</td>
								<td class="ellipsis">AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020.02.20 15:00:00</td>
								<td>2020.02.20 15:00:00</td>
								<td>STOP</td>
								<td class="ellipsis">AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020.02.20 15:00:00</td>
								<td>2020.02.20 15:00:00</td>
								<td>STOP</td>
								<td class="ellipsis">AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase</td>
							</tr>
							<tr>
								<td>N123</td>
								<td>1234</td>
								<td>S09234875</td>
								<td>2020.02.20 15:00:00</td>
								<td>2020.02.20 15:00:00</td>
								<td>STOP</td>
								<td class="ellipsis">AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase AC over current R-phase</td>
							</tr>
						</tbody>
					</table>
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
	</div>