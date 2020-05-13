<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/05/12
  Time: 15:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>SPC 원가관리 수정</title>
  </head>
  <body>
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">SPC 원가관리 수정</h1>
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
			<div class="indiv bal_edit">
				<div class="clear">
					<div class="fl">
						<span class="tx_tit">기준</span>
						<div class="sa_select">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">2020년
									<span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu" id="type">
									<li><a href="#">2020년</a></li>
									<li><a href="#">2019년</a></li>
									<li><a href="#">2018년</a></li>
								</ul>
							</div>
						</div>
						<div class="sa_select">
							<div class="dropdown">
								<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">2020년
									<span class="caret"></span>
								</button>
								<ul class="dropdown-menu chk_type" role="menu" id="type">
									<li><a href="#">05년</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="fr">
						<p class="tx_type fl">단위:원</p>
						<div class="chk_type fl">
							<input type="checkbox" id="chk_op01" value="1">
							<label for="chk_op01"><span></span>수기입력 활성화</label>
						</div>
					</div>
				</div>
				<div class="spc_tbl_row st_edit">			
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>전력 판매 대금</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
							<th>REC 매매대금</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
						</tr>
						<tr>
							<th>차임금 상환(A)</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
							<th>차임금 상환(B)</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
						</tr>
						<tr>
							<th>이자 비용(A)</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
							<th>이자 비용(B)</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
						</tr>
						<tr>
							<th>대리기관 수수료</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
							<th>관리 운영 수수료</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
						</tr>
						<tr>
							<th>법인세</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" value="234,000">
								</div>
							</td>
							<th>부가세</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>임대료</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="입력">
								</div>
							</td>
							<th>기타 비용</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>현금 유입 합계</th>
							<td>자동 계산</td>
							<th>현금 유출 합계</th>
							<td>자동 계산</td>
						</tr>
						<tr>
							<th>기말 현금</th>
							<td>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="입력">
								</div>
							</td>
							<th>기말 현금흐름</th>
							<td>자동 계산</td>
						</tr>
						<tr class="th_span">
							<th>
								손익 계산서
								<a href="#" class="btn_add fr">추가</a>
							</th>
							<td colspan="3"></td>
						</tr>
						<tr class="th_span">
							<th>
								세무 조정 계산
								<a href="#" class="btn_add fr">추가</a>
							</th>
							<td colspan="3"></td>
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
