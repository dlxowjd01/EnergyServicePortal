<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">상세 조회</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<form>
			<div class="indiv spc-detail">
				<div class="certType">
					<div class="spc_tbl_row st_edit">
						<table>
							<colgroup>
								<col style="width:15%">
								<col style="width:35%">
								<col style="width:15%">
								<col style="width:35%">
							</colgroup>
							<tbody>
							<tr>
								<th><h2 class="tx_tit">신청일</h2></th>
								<td>
									2020-05-20
								</td>
								<th><h2 class="tx_tit">기기등록</h2></th>
								<td>
									20건
								</td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">유효기간</h2></th>
								<td>
									5년
								</td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">발급정책</h2></th>
								<td>테스트발급정책</td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">제조사명</h2></th>
								<td>테스트제조사</td>
								<th><h2 class="tx_tit">폐기</h2></th>
								<td>20건</td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">제품모델명</h2></th>
								<td>테스트모델</td>
								<th></th>
								<td></td>
							</tr>
							</tbody>
						</table>
					</div>
					<div class="flex_wrapper mb-20 mt30">
						<h2 class="ntit">기기인증서 리스트</h2>
					</div>
					<div class="spc_tbl align_type">
						<table class="chk_type">
							<colgroup>
								<col style="width:15%">
								<col style="width:25%">
								<col style="width:15%">
								<col style="width:25%">
								<col/>
							</colgroup>
							<thead>
							<tr>
								<th>번호</th>
								<th>MAC 주소</th>
								<th>시리얼번호 (SN)</th>
								<th>상태 변경일</th>
								<th>상태</th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<td>
									1
								</td>
								<td>00-00-00-00-00-01</td>
								<td></td>
								<td>2020-08-11</td>
								<td>발급</td>
							</tr>
							<tr>
								<td>
									2
								</td>
								<td>00-00-00-00-00-02</td>
								<td></td>
								<td>2020-08-11</td>
								<td>발급</td>
							</tr>
							<tr>
								<td>
									3
								</td>
								<td>00-00-00-00-00-03</td>
								<td></td>
								<td>2020-08-11</td>
								<td>발급</td>
							</tr>
							</tbody>
						</table>
					</div>
					<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
				</div>
			</div>
		</form>
	</div>
	<div class="btn_wrap_type_right">
		<button type="button" class="btn_type03">목록</button>
	</div>
</div>