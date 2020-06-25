<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
	
	});
</script>

	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">보고서</h1>
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
				<span class="tx_tit">보고서 구분</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">전체
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
			</div>
			<div class="fl">
				<span class="tx_tit">작성 일자</span>
				<div class="sel_calendar">
					<input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
					<em></em>
					<input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
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
				<div class="btn_wrap_type">
					<button type="button" class="btn_type">등록</button>
				</div>
				<div class="spc_tbl align_type">			
					<table class="chk_type">
						<thead>
							<tr>
								<th>
									<input type="checkbox" id="chk_op01" value="순번">
									<label for="chk_op01"><span></span>순번</label>
								</th>
								<th>보고서 구분</th>
								<th>문서번호</th>
								<th>보고서명</th>
								<th>작성자</th>
								<th>작성일자</th>
								<th>등록상태</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<input type="checkbox" id="chk_op02" value="1">
									<label for="chk_op02"><span></span>1</label>
								</td>
								<td>OCI 서울</td>
								<td>SPW-TR1912-18</td>
								<td><a href="/spc/entityDetailsBySite.do" class="tbl_link">OCI서울태양광 암사아리수 정수센터 시스템 Q.C 보고서</a></td>
								<td>인코어드</td>
								<td>2018-12-04</td>
								<td>임시저장</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" id="chk_op02" value="1">
									<label for="chk_op02"><span></span>1</label>
								</td>
								<td>OCI 서울</td>
								<td>SPW-TR1912-18</td>
								<td><a href="/spc/entityDetailsBySite.do" class="tbl_link">OCI서울태양광 암사아리수 정수센터 시스템 Q.C 보고서</a></td>
								<td>인코어드</td>
								<td>2018-12-04</td>
								<td>임시저장</td>
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
					<a href="#;">2</a>
					<a href="#;">3</a>
					<a href="#;" class="btn_next">next</a>
				</div>
			</div>
		</div>
	</div>
