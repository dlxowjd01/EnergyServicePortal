<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/05/12
  Time: 15:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">

</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">원가관리 등록</h1>
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
		<div class="indiv bal_edit bal_post">
			<div class="spc_st_top">
				<div class="spc_bal_post">
					<table id="interestTable">
						<colgroup>
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col style="width:9.5%">
							<col>
						</colgroup>
						<thead>
						<tr>
							<th rowspan="2">차입금 / 이자</th>
							<th rowspan="2">원금(원)</th>
							<th colspan="3">기간</th>
							<th colspan="3">상환방식</th>
							<th>이자(%)</th>
						</tr>
						<tr>
							<th class="border">시행일</th>
							<th>만기일</th>
							<th>대출기간 (m)</th>
							<th class="border">만기일시</th>
							<th>원금균등</th>
							<th>원리금균등</th>
							<th>이자율 (연)</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td></td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="" name="" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="date1" class="sel datepicker" value="" autocomplete="off" readonly
									       placeholder="선택">
								</div>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="date2" class="sel datepicker" value="" autocomplete="off" readonly
									       placeholder="선택">
								</div>
							</td>
							<td>자동 계산</td>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk_bal01" value="1">
									<label for="chk_bal01"><span></span></label>
								</div>
							</td>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk_bal02" value="1">
									<label for="chk_bal02"><span></span></label>
								</div>
							</td>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk_bal03" value="1">
									<label for="chk_bal03"><span></span></label>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						</tbody>
					</table>
					<div class="btn_wrap_type">
						<a href="#" class="btn_add" onclick="addRowTable('interestTable'); return false;">추가</a>
					</div>
				</div>

				<div class="spc_bal_post">
					<table id="service_chargeTable">
						<colgroup>
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
							<th rowspan="2">대리기관/<br>관리운영 수수료</th>
							<th rowspan="2">종류</th>
							<th colspan="2">계약방식</th>
							<th colspan="3">월정액</th>
							<th colspan="4">매출(수익)연동</th>
						</tr>
						<tr>
							<th class="border">월정액</th>
							<th>매출(수익)연동</th>
							<th class="border">공급가액(원)</th>
							<th>부가세</th>
							<th>합계</th>
							<th class="border">적용(%)</th>
							<th>공급가액(원)</th>
							<th>부가세</th>
							<th>합계</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td></td>
							<td>
								<div class="sa_select">
									<div class="dropdown">
										<button class="btn btn-primary dropdown-toggle" type="button"
										        data-toggle="dropdown">2020년
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu" id="type">
											<li><a href="#">대리기관 수수료</a></li>
											<li><a href="#">관리운영 수수료</a></li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk_bal1_01" value="1">
									<label for="chk_bal1_01"><span></span></label>
								</div>
							</td>
							<td>
								<div class="chk_type">
									<input type="checkbox" id="chk_bal1_01" value="1">
									<label for="chk_bal1_01"><span></span></label>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<td>자동 계산</td>
							<td>자동 계산</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<td>자동 계산</td>
							<td>자동 계산</td>
						</tr>
						</tbody>
					</table>
					<div class="btn_wrap_type">
						<a href="#" class="btn_add" onclick="addRowTable('service_chargeTable'); return false;">추가</a>
					</div>
				</div>

				<div class="spc_bal_post">
					<table id="rentTable">
						<colgroup>
							<col style="width:25%">
							<col style="width:25%">
							<col style="width:25%">
							<col style="width:25%">
						</colgroup>
						<thead>
						<tr>
							<th>임차료</th>
							<th>공급가액</th>
							<th>부가세</th>
							<th>합계</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td></td>
							<td>
								<div class="tx_inp_type">
									<input type="text" placeholder="직접 입력">
								</div>
							</td>
							<td>자동 계산</td>
							<td>자동 계산</td>
						</tr>
						</tbody>
					</table>
					<div class="btn_wrap_type">
						<a href="#" class="btn_add" onclick="addRowTable('rentTable'); return false;">추가</a>
					</div>
				</div>
			</div>
			<div class="clear">
				<div class="fl">
					<span class="tx_tit">기준</span>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">
								2020년
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu" id="type">
								<li><a href="#;">2020년</a></li>
								<li><a href="#;">2019년</a></li>
								<li><a href="#;">2018년</a></li>
							</ul>
						</div>
					</div>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">
								2020년
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu chk_type" role="menu" id="type">
								<li><a href="#;">05년</a></li>
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
						<td>234,000</td>
						<th>REC 매매대금</th>
						<td>234,000</td>
					</tr>
					<tr>
						<th>차임금 상환(A)</th>
						<td>자동 계산</td>
						<th>차임금 상환(B)</th>
						<td>자동 계산</td>
					</tr>
					<tr>
						<th>이자 비용(A)</th>
						<td>자동 계산</td>
						<th>이자 비용(B)</th>
						<td>자동 계산</td>
					</tr>
					<tr>
						<th>대리기관 수수료</th>
						<td>234,000</td>
						<th>관리 운영 수수료</th>
						<td>자동 계산</td>
					</tr>
					<tr>
						<th>법인세</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" value="132,000">
							</div>
						</td>
						<th>부가세</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>임대료</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" placeholder="직접 입력">
							</div>
						</td>
						<th>기타 비용</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" placeholder="직접 입력">
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
								<input type="text" placeholder="직접 입력">
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