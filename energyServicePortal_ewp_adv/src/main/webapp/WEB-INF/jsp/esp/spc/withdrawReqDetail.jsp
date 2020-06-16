<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
	});
	$(document).on('keyup', '#key_word', function(e) {
		if (e.keyCode == 13) {
			getDataList(page);
		}
	})

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
<div class="row">
	<div class="col-xl-8 col-lg-7 col-md-6 col-sm-12">
		<div class="indiv spc_detail">
			<h2 class="ntit">출금 요청서</h2>
			
			<div class="flex_start">
				<h2 class="tx_tit">SPC 명</h2>
				<span class="tx_tit">SPC2</span>
			</div>
			<div class="flex_start">
				<h2 class="tx_tit">출금 계좌 번호</h2>
				<span class="tx_tit">신한 225-558-999341</span>
			</div>

			<div class="chart_table mt30">
				<table class="pc_use">
					<thead>
						<tr>
							<th>출금일자</th>
							<th>구분</th>
							<th>요청 금랙</th>
							<th>계좌번호</th>
							<th>비교</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>2020-05-08</td>
							<td>관리 운영비</td>
							<td>계좌 구분</td>
							<td>200,000,000 </td>
							<td>신한 225-558-999341</td>
						</tr>
						<tr>
							<td>2020-05-08</td>
							<td>관리 운영비</td>
							<td>계좌 구분</td>
							<td>200,000,000 </td>
							<td>신한 225-558-999341</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td>합계</td>
							<td colspan="4">100,000,000</td>
						</tr>
					</tfoot>
				</table>
			</div>

		</div>
	</div>
	<div class="col-xl-4 col-lg-5 col-md-6 col-sm-12">
		<div class="indiv spc_detail">
			<h2 class="ntit">증빙 서류</h2>
			
			<div class="flex_wrapper border">
				<a href="#" class="btn_type02">거래 내역서.pdf</a>
				<a href="#" class="save_btn"></a>
			</div>
			
			<div class="flex_wrapper">
				<h2 class="heading">출금 요청서 + 증빙</h2>
				<div class="fr">
					<button type="button" class="btn_type03">인쇄</button><button 
						type="button" class="btn_type ml-12">다운로드</button>
				</div>
			</div>
			<div class="flex_wrapper border mt20">
				<h2 class="heading">출금 요청서</h2>
				<div class="fr">
					<button type="button" class="btn_type03">인쇄</button><button 
					type="button" class="btn_type ml-16">다운로드</button>
				</div>
			</div>
			<div class="flex_wrapper border">
				<textarea class="textarea w-100"></textarea>
			</div>

			<h2 class="heading">메모</h2>
			<div class="textarea_container mt20">
				<button type="button" class="btn_type03 fixed_btn">저장</button>
				<textarea class="textarea w-100"></textarea>
			</div>

			<div class="btn_group mt20">
				<button type="button" class="btn_type03 w80">반송</button><button
					type="button" class="btn_type ml-16">승인</button>
			</div>
		</div>
	</div>
</div>
