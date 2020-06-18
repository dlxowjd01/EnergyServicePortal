<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
		unCheckAll();
	});


</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 검토</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row spc_search_bar">
	<div class="col-12">
		<span class="tx_tit">검토 상태</span><div class="sa_select mr-16">
			<div id="reqStatus" class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">전체 <span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu">
					<li class="chk_group" tabindex="-1" data-value="0">
						<input type="checkbox" id="statusAll" value="0">
						<label for="statusAll"><span></span>전체</label>
					</li>
					<li class="chk_group" tabindex="-1" data-value="1">
						<!-- <a class="chk_group" href="javascript:void(0);" tabindex="-1" data-value="1"> -->
							<input type="checkbox" id="statusOnWait" value="1">
							<label for="statusOnWait"><span></span>검토 대기</label>
						<!-- </a> -->
					</li>
					<li class="chk_group" tabindex="-1" data-value="2">
						<a class="chk_group" href="javascript:void(0);" tabindex="-1" data-value="2">
							<input type="checkbox" id="statusInProgress" value="2">
							<label for="statusInProgress"><span></span>검토 중</label>
						</a>
					</li>
					<li class="chk_group" tabindex="-1" data-value="3">
						<!-- <a class="chk_group" href="javascript:void(0);" tabindex="-1" data-value="3"> -->
							<input type="checkbox" id="statusComplete" value="3">
							<label for="statusComplete"><span></span>승인 완료</label>
						<!-- </a> -->
					</li>
				</ul>
			</div>
		</div>
		<form id="spc_form" class="tx_btn_area">
			<div class="tx_inp_type">
				<input type="text" id="key_word" placeholder="입력">
			</div>
			<button type="button" class="btn_type">검색</button>
		</form>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv no_border spc_bal_post">
			<div class="btn_wrap_type01">
				<button type="button" class="btn_type">선택 인쇄</button>
			</div>
			<table class="sort_table table_footer">
				<colgroup>
					<col style="width:6%">
					<col style="width:9%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:14%">
					<col style="width:10%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:14%">
					<col>
				</colgroup>
				<thead>
				<tr>
					<th></th>
					<th>
						<button class="btn_align down">출금 일자</button>
					</th>
					<th>
						<button class="btn_align down">SPC 명</button>
					</th>
					<th>
						<button class="btn_align down">금액</button>
					</th>
					<th>
						<button class="btn_align down">요청/수정일</button>
					</th>
					<th>
						<button class="btn_align down">사무 수탁사</button>
					</th>
					<th>
						<button class="btn_align down">담당자</button>
					</th>
					<th>
						<button class="btn_align down">상태</button>
					</th>

					<th>
						<button class="btn_align down">승인자</button>
					</th>
					<th>
						<button class="btn_align down">승인일</button>
					</th>
				</tr>
				</thead>
				<tbody id="spcStatusTable">
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-01-03</td>
						<td>SPC1</td>
						<td>200,000,000</td>
						<td>2020-01-19 16:43</td>
						<td>MSI</td>
						<td>이종목</td>
						<td>승인완료</td>
						<td>이효섭</td>
						<td>2020-01-20 12:43</td>
					</tr>
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-01-04</td>
						<td>SPC2</td>
						<td>500,000,000</td>
						<td>2020-01-19 12:43</td>
						<td>TRUST</td>
						<td>홍길동</td>
						<td>승인완료</td>
						<td>김길중</td>
						<td>2020-01-23 12:43</td>
					</tr>
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-01-18</td>
						<td>SPC3</td>
						<td>500,000,000</td>
						<td>2020-01-21 12:43</td>
						<td>MSI</td>
						<td>김현희</td>
						<td>승인완료</td>
						<td>김길중</td>
						<td>2020-01-22 12:43</td>
					</tr>
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-02-02</td>
						<td>SPC4</td>
						<td>500,000,000</td>
						<td>2020-02-12 12:43</td>
						<td>MSI</td>
						<td>최철호</td>
						<td>승인완료</td>
						<td>이효섭</td>
						<td>2020-02-13 12:43</td>
					</tr>
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-02-08</td>
						<td>SPC5</td>
						<td>500,000,000</td>
						<td>2020-06-09 12:43</td>
						<td>TRUST</td>
						<td>나희연</td>
						<td><a href="/spc/withdrawReqDetail.do" class="tbl_link" >검토중</a></td>
						<td>-</td>
						<td>-</td>
					</tr>
					<tr>
						<td><a class="chk_type select_row">
							<input type="checkbox" id="chk02" name="chk02">
							<label for="chk02"><span></span></label>
						</a></td>
						<td>2020-05-08</td>
						<td>SPC6</td>
						<td>500,000,000</td>
						<td>2020-05-21 12:43</td>
						<td>MSI</td>
						<td>김민국</td>
						<td><a href="/spc/withdrawReqDetail.do" class="tbl_link" >검토중</a></td>
						<td>-</td>
						<td>-</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td></td>
						<td>합계</td>
						<td></td>
						<td>100,000,000</td>
						<td colspan="6"></td>
					</tr>
				</tfoot>
			</table>
			<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
		</div>
	</div>
</div>
