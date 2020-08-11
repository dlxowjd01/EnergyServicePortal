<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">기기인증서 관리</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12 clear inp_align">
		<div class="fl">
			<span class="tx_tit">신청 기간</span>
			<div class="sel_calendar">
				<input type="text" id="write_date_from" class="sel fromDate" value="" autocomplete="off">
				<input type="text" id="write_date_to" class="sel toDate" value="" autocomplete="off">
			</div>
		</div>
		<div class="fl">
			<span class="tx_tit">기기 고유정보</span>
			<div class="sa_select">
				<div class="dropdown">
					<button id="report_type" class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown" data-value="">
						MAC 주소 <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li data-value="">
							<a href="javascript:void(0);">MAC 주소</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<div class="tx_inp_type">
				<input type="text" id="key_word" placeholder="입력">
			</div>
		</div>
		<div class="fl">
			<button type="submit" class="btn_type">검색</button>
		</div>
		<div class="fr">
			<a href="javascript:void(0);" class="save_btn">CVS 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv supplementary_docs">
			<div class="spc_tbl align_type left">
				<table class="sort_table chk_type">
					<colgroup>
						<col style="width:8%">
						<col style="width:12%">
						<col style="width:20%">
						<col style="width:15%">
						<col style="width:20%">
						<col style="width:15%">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>신청일</th>
							<th>제품모델명</th>
							<th>기기수량</th>
							<th>담당자명</th>
							<th>상태</th>
							<th>보기</th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>1</td>
							<td>2020-08-10</td>
							<td>테스트 모델</td>
							<td>30</td>
							<td>RA 관리자</td>
							<td>
								발급(1건)
								폐지(1건)
							</td>
							<td>
								<button type="button" class="btn_type big" onclick="location.href='/device/certManageDetail.do'">상세</button>
							</td>
						</tr>
						<tr>
							<td>2</td>
							<td>2020-08-11</td>
							<td>테스트 모델</td>
							<td>30</td>
							<td>RA 관리자</td>
							<td>
								발급(1건)
								폐지(1건)
							</td>
							<td>
								<button type="button" class="btn_type big" onclick="location.href='/device/certManageDetail.do'">상세</button>
							</td>
						</tr>
						<tr>
							<td>3</td>
							<td>2020-08-09</td>
							<td>테스트 모델</td>
							<td>30</td>
							<td>RA 관리자</td>
							<td>
								발급(1건)
								폐지(1건)
							</td>
							<td>
								<button type="button" class="btn_type big" onclick="location.href='/device/certManageDetail.do'">상세</button>
							</td>
						</tr>
						<tr>
							<td>4</td>
							<td>2020-08-01</td>
							<td>테스트 모델</td>
							<td>30</td>
							<td>RA 관리자</td>
							<td>
								발급(1건)
								폐지(1건)
							</td>
							<td>
								<button type="button" class="btn_type big" onclick="location.href='/device/certManageDetail.do'">상세</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
		</div>
	</div>
</div>