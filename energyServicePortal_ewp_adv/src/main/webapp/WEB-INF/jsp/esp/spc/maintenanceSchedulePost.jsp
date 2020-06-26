<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script src="/js/commonDropdown.js"></script>
<script>
	$(function() {
	});
</script>

    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">SPC 점검계획</h1>
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
			<div class="indiv">
				<button type="button" class="btn_type fr">등록</button>
				<div class="regist_ver">
					<table>
						<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
						</colgroup>
						<tr>
							<th>발전소 선택</th>
							<td colspan="3">
								<div class="tx_btn_area type">
									<div class="tx_inp_type">
										<input type="text" placeholder="입력">
									</div>
									<button type="submit" class="btn_type">검색</button>
								</div>
							</td>
						</tr>
						<tr>
							<th>점검 구분</th>
							<td>
								<div class="dropdown">
								  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" style="width:55%">점검 계획 항목 선택
								  <span class="caret"></span></button>
								  <ul class="dropdown-menu">
									<li class="on"><a href="#">점검 계획 항목</a></li>
									<li><a href="#">점검 계획 항목</a></li>
									<li><a href="#">점검 계획 항목</a></li>
									<li><a href="#">점검 계획 항목</a></li>
								  </ul>
								</div>
							</td>
							<th>점검 주기</th>
							<td>
								<div class="rdo_type">
									<input type="radio" id="radio_op01" name="radio_op" value="정기 점검">
									<label for="radio_op01">정기 점검</label>
								</div>
								<div class="rdo_type">
									<input type="radio" id="radio_op02" name="radio_op" value="일시 점검">
									<label for="radio_op02">일시 점검</label>
								</div>
							</td>
						</tr>
						<tr>
							<th>내용</th>
							<td colspan="3">
								<div class="tx_inp_type" style="width:100%">
									<input type="text" placeholder="입력">
								</div>
							</td>
						</tr>
						<tr>
							<th>기준 일자</th>
							<td>
								<div class="sel_calendar">
								  <input type="text" id="datepicker1" class="sel" value="" autocomplete="off" style="width:55%">
								</div>
							</td>
							<th>다음 검사 일자</th>
							<td></td>
						</tr>
						<tr>
							<th>작업자</th>
							<td>
								<div class="tx_inp_type" style="width:55%">
									<input type="text" placeholder="입력">
								</div>
							</td>
							<th>비고</th>
							<td>
								<div class="tx_inp_type" style="width:100%">
									<input type="text" placeholder="입력">
								</div>
							</td>
						</tr>
					</table>	
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">목록</button>
				</div>
			</div>
		</div>
	</div>
