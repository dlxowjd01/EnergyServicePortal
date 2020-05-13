<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 15:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	let today = new Date();
	let date = new Date();

	$(function() {
		pageInit();

		//전월
		$('.btn_prev_mon').on('click', function() {
			today = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
			buildCalendar();
		});

		//다음월
		$('.btn_next_mon').on('click', function() {
			today = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
			buildCalendar();
		});

		//요번달
		$('.btn_type03.active').on('click', function() {
			today = new Date();
			buildCalendar();
		});
	});

	//기본세팅
	const pageInit = function() {
		let html = '';
		let year = today.getFullYear();
		let month = today.getMonth() + 1;

		$('#datepicker1').datepicker('setDate', 'today');
		$('#year > button').html(year + '년<span class="caret"></span>').data('value', year);
		$('#month > button').html(month + '월<span class="caret"></span>').data('value', month);

		for(let i = 0; i < 5; i++) {
			let bfYear = new Date(year - i, month + 1);
			let select = i == 0 ? 'on' : '';
			html += '<li data-value="' + bfYear.getFullYear() + '" class="' + select + '"><a href="#">' + bfYear.getFullYear() + '년 </a></li>';
		}

		$('#year ul').empty().append(html);

		buildCalendar();
	}

	//달력 그리기
	const buildCalendar = function() {//현재 달 달력 만들기
		let doMonth = new Date(today.getFullYear(), today.getMonth(), 1);
		let lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0);
		let tbCalendar = document.getElementById('calendar');

		while (tbCalendar.rows.length > 1) {
			tbCalendar.deleteRow(tbCalendar.rows.length - 1);
		}

		let row = null;
		let cnt = 0;
		row = tbCalendar.insertRow();
		for(i = 0; i < doMonth.getDay(); i++) {
			cell = row.insertCell();
			cnt = cnt + 1;
		}

		for (i = 1; i <= lastDate.getDate(); i++) {
			cell = row.insertCell();
			cell.innerHTML = i;
			cnt = cnt + 1;
			if (cnt % 7 == 1) {
				cell.innerHTML = '<span class="date">' + i;
			}

			if (cnt%7 == 0) {
				cell.innerHTML = '<span class="date">' + i;
				row = calendar.insertRow();
			}
			/*오늘의 날짜에 노란색 칠하기*/
			if (today.getFullYear() == date.getFullYear()
				&& today.getMonth() == date.getMonth()
				&& i == date.getDate()) {
				cell.setAttribute('class', 'today');
			}
		}

		$('.sch_btn > strong').html(doMonth.getMonth() + 1 + '월');
		$('#year > button').html(doMonth.getFullYear() + '년<span class="caret"></span>').data('value', doMonth.getFullYear());
		$('#month > button').html(doMonth.getMonth() + 1 + '월<span class="caret"></span>').data('value', doMonth.getMonth() + 1);
	}
</script>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit">점검계획 등록</h2>
				<div class="spc_tbl02_row">
					<table>
						<colgroup>
							<col style="width:157px">
							<col style="width:365px">
							<col style="width:156px">
							<col style="width:346px">
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
								<div class="dropdown placeholder">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
										점검 계획 항목 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li><a href="#">정기 점검</a></li>
										<li><a href="#">구조물 안전진단</a></li>
										<li><a href="#">소방점검</a></li>
									</ul>
								</div>
							</td>
							<th>기준 일자</th>
							<td>
								<div class="sel_calendar">
									<input type="text" id="datepicker1" class="sel" value="" autocomplete="off" readonly placeholder="날짜 선택">
								</div>
							</td>
						</tr>
						<tr>
							<th>점검 반복 주기</th>
							<td>
								<div class="dropdown placeholder">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
										점검 반복 주기<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li class="on"><a href="#">반복 안함</a></li>
										<li><a href="#">매주 동일 요일</a></li>
										<li><a href="#">매월 동일 날짜</a></li>
										<li><a href="#">매년 동일 날짜</a></li>
									</ul>
								</div>
							</td>
							<th>공휴일 처리</th>
							<td>
								<div class="dropdown placeholder">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
										공휴일 처리 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li><a href="#">처리 안함</a></li>
										<li><a href="#">공휴일 직전 영업일</a></li>
										<li><a href="#">공휴일 직후 영업일</a></li>
									</ul>
								</div>
							</td>
						</tr>
						<tr>
							<th>내용</th>
							<td colspan="3">
								<div class="txarea_inp_type">
									<textarea placeholder="입력" rows="5"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th>작업자</th>
							<td>
								<div class="tx_inp_type">
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
						<tr>
							<th>알림 설정</th>
							<td>
								<div class="dropdown placeholder fl" id="alarmSetup" style="width:160px">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
										알림 일시 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-value="1"><a href="#">1일 전</a></li>
										<li data-value="3"><a href="#">3일 전</a></li>
										<li data-value="7"><a href="#">7일 전</a></li>
										<li data-value="직접 설정"><a href="#">직접 설정</a></li>
									</ul>
								</div>
							</td>
							<th>수신 번호</th>
							<td>
								<div class="clear">
									<div class="dropdown placeholder fl" style="width:160px">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
											알림 시간 선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu">
											<c:forEach var="time" begin="0" end="23">
												<li data-value="${time}"><a href="#">${time}시</a></li>
											</c:forEach>
										</ul>
									</div>
									<div class="tx_inp_type fr" style="width:160px">
										<input type="text" placeholder="수신 번호">
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" data-dismiss="modal">취소</button>
				<button type="button" class="btn_type">등록</button>
			</div>
		</div>
	</div>
</div>
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
	<div class="col-lg-2 clear">
		<div class="sch_sel_area">
			<div class="sch_sel_item">
				<div class="dropdown" id="year">
					<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="#">2020</a></li>
						<li><a href="#">2019</a></li>
						<li><a href="#">2018</a></li>
					</ul>
				</div>
			</div>
			<div class="sch_sel_item">
				<div class="dropdown" id="month">
					<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li data-value="1"><a href="#">1월</a></li>
						<li data-value="2"><a href="#">2월</a></li>
						<li data-value="3"><a href="#">3월</a></li>
						<li data-value="4"><a href="#">4월</a></li>
						<li data-value="5"><a href="#">5월</a></li>
						<li data-value="6"><a href="#">6월</a></li>
						<li data-value="7"><a href="#">7월</a></li>
						<li data-value="8"><a href="#">8월</a></li>
						<li data-value="9"><a href="#">9월</a></li>
						<li data-value="10"><a href="#">10월</a></li>
						<li data-value="11"><a href="#">11월</a></li>
						<li data-value="12"><a href="#">12월</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-2 sch_left">
		<div class="indiv">
			<h2 class="ntit">점검 구분</h2>
			<div class="sch_inp_area">
				<div class="chk_type c1">
					<input type="checkbox" id="chk_op01" value="정기점검" checked>
					<label for="chk_op01"><span></span>정기점검</label>
				</div>
				<div class="chk_type c2">
					<input type="checkbox" id="chk_op02" value="구조물 안전진단" checked>
					<label for="chk_op02"><span></span>구조물 안전진단</label>
				</div>
				<div class="chk_type c3">
					<input type="checkbox" id="chk_op03" value="소방점검" checked>
					<label for="chk_op03"><span></span>소방점검</label>
				</div>
				<div class="chk_type c4">
					<input type="checkbox" id="chk_op04" value="등기이사 기간만료" checked>
					<label for="chk_op04"><span></span>등기이사 기간만료</label>
				</div>
			</div>

			<h2 class="ntit">발전소</h2>
			<div class="tx_inp_type">
				<input type="text" placeholder="입력">
			</div>
		</div>
	</div>
	<div class="col-lg-10">
		<div class="indiv pd_type">
			<div class="schedule_area">
				<div class="sch_top_info clear">
					<div class="sch_btn fl">
						<button class="btn_type03 active">오늘</button>
						<button class="btn_prev_mon">prev</button>
						<button class="btn_next_mon">next</button>
						<strong></strong>
					</div>
					<a href="#" class="btn_type fr" data-toggle="modal" data-target="#myModal">등록</a>
					<!--<a href="/spc/maintenanceSchedulePost.do" class="btn_type fr">등록</a>-->
				</div>
				<div class="sch_btm_area">
					<table id="calendar">
						<colgroup>
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col>
						</colgroup>
						<thead>
						<tr>
							<th>일</th>
							<th>월</th>
							<th>화</th>
							<th>수</th>
							<th>목</th>
							<th>금</th>
							<th>토</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td><span class="date">1</span></td>
							<td><span class="date">2</span></td>
							<td><span class="date">3</span></td>
							<td><span class="date">4</span></td>
						</tr>
						<tr>
							<td><span class="date">5</span></td>
							<td><span class="date">6</span></td>
							<td><span class="date">7</span></td>
							<td><span class="date">8</span></td>
							<td><span class="date">9</span></td>
							<td><span class="date">10</span></td>
							<td>
								<span class="date">11</span>
								<p class="bu t1">[혜원 솔라 01] 정기 점검</p>
							</td>
						</tr>
						<tr>
							<td><span class="date">12</span></td>
							<td><span class="date">13</span></td>
							<td><span class="date">14</span></td>
							<td><span class="date">15</span></td>
							<td><span class="date">16</span></td>
							<td><span class="date">17</span></td>
							<td><span class="date">18</span></td>
						</tr>
						<tr>
							<td class="today"><span class="date">19</span></td>
							<td><span class="date">20</span></td>
							<td><span class="date">21</span></td>
							<td><span class="date">22</span></td>
							<td>
								<span class="date">23</span>
								<p class="bu t4">[혜원 솔라 02] 등기이사 기간만료</p>
							</td>
							<td><span class="date">24</span></td>
							<td><span class="date">25</span></td>
						</tr>
						<tr>
							<td><span class="date">26</span></td>
							<td><span class="date">27</span></td>
							<td><span class="date">28</span></td>
							<td>
								<span class="date">29</span>
								<p class="bu t3">[혜원 솔라 01] 구조물</p>
							</td>
							<td>
								<span class="date">30</span>
								<p class="bu t4">[혜원 솔라 01] 소방점검</p>
								<p class="bu t3">[혜원 솔라 02] 구조물 안전진단</p>
							</td>
							<td></td>
							<td></td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>