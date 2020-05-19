<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/21
  Time: 15:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
	<!-- Modal -->
	<div id="myModal" class="modal fade" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="ly_wrap">
					<h2 class="ly_tit">수익보고서 신규</h2>
					<div class="spc_tbl02_row">
						<table>
							<colgroup>
								<col style="width:157px">
								<col style="width:365px">
								<col style="width:156px">
								<col style="width:364px">
							</colgroup>
							<tr>
								<th>SPC</th>
								<td>
									<div class="dropdown placeholder fl" id="alarmSetup">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
										<ul class="dropdown-menu">
											<li><a href="#">SPC 1</a></li>
											<li><a href="#">SPC 2</a></li>
										</ul>
									</div>
								</td>
								<th>발전소</th>
								<td>
									<div class="dropdown placeholder fl" id="alarmSetup">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
										<ul class="dropdown-menu">
											<li><a href="#">선택 안함</a></li>
											<li><a href="#">발전소 1</a></li>
										</ul>
									</div>
								</td>
							</tr>
							<tr>
								<th>보고서 유형</th>
								<td>
									<div class="dropdown placeholder fl" id="alarmSetup">
										<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
										<ul class="dropdown-menu">
											<li><a href="#">월간 실적</a></li>
											<li><a href="#">분기 실적</a></li>
											<li><a href="#">년간 실적</a></li>
											<li><a href="#">수익 보고서</a></li>
										</ul>
									</div>
								</td>
								<th>적용 기간</th>
								<td>
									<div class="sel_calendar fl" style="width:160px">
										<input type="text" id="alarmDate" name="alarmDate" value="" class="sel" autocomplete="off" readonly="" placeholder="날짜 선택">
									</div>
									<div class="sel_calendar fl ml" style="width:160px">
										<input type="text" id="alarmDate2" name="alarmDate" value="" class="sel" autocomplete="off" readonly="" placeholder="날짜 선택">
									</div>
								</td>
							</tr>
							<tr>
								<th colspan="4">적용 변수<a href="#" class="btn_add ml">추가</a></th>
							</tr>
						</table>
					</div>
				</div>
				<div class="yield_ly_bt">
					<ul class="yield_list">
						<li>
							<div class="dropdown placeholder fl" id="alarmSetup">
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li><a href="#">수익 배분율</a></li>
									<li><a href="#">REC 단가</a></li>
									<li><a href="#">추가 예정</a></li>
								</ul>
							</div>
							<div class="tx_inp_type fl">
								<input type="text" id="worker" name="worker" placeholder="입력">
							</div>
							<button class="btn_type07">삭제</button>
						</li>
						<li>
							<div class="dropdown placeholder fl" id="alarmSetup">
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">선택<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li><a href="#">수익 배분율</a></li>
									<li><a href="#">REC 단가</a></li>
									<li><a href="#">추가 예정</a></li>
								</ul>
							</div>
							<div class="tx_inp_type fl">
								<input type="text" id="worker" name="worker" placeholder="입력">
							</div>
							<button class="btn_type07">삭제</button>
						</li>
					</ul>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal">취소</button>
					<button type="button" class="btn_type">생성</button>
				</div>
			</div>
		</div>
	</div>
    <div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">수익 보고서</h1>
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
				<span class="tx_tit">유형</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">전체
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
							<li><a href="#">전체</a></li>
							<li><a href="#">년간보고서</a></li>
							<li><a href="#">분기보고서</a></li>
							<li><a href="#">월간보고서</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="fl">
				<span class="tx_tit">적용 시작 월</span>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">2020년
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
							<li><a href="#">전체</a></li>
							<li><a href="#">2020년</a></li>
							<li><a href="#">2019년</a></li>
							<li><a href="#">2018년</a></li>
						</ul>
					</div>
				</div>
				<div class="sa_select">
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">전체
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
							<li><a href="#">전체</a></li>
							<li><a href="#">1월</a></li>
							<li><a href="#">2월</a></li>
							<li><a href="#">3월</a></li>
							<li><a href="#">4월</a></li>
							<li><a href="#">5월</a></li>
							<li><a href="#">6월</a></li>
							<li><a href="#">7월</a></li>
							<li><a href="#">8월</a></li>
							<li><a href="#">9월</a></li>
							<li><a href="#">10월</a></li>
							<li><a href="#">11월</a></li>
							<li><a href="#">12월</a></li>
						</ul>
					</div>
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
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03">선택 삭제</button>
					<button type="button" class="btn_type" data-toggle="modal" data-target="#myModal">신규 생성</button>
				</div>
				<div class="spc_tbl align_type">			
					<table class="chk_type">
						<thead>
							<tr>
								<th>
									<input type="checkbox" id="chk_header" value="순번" onclick="setCheckedAll(this, 'rowCheck');">
									<label for="chk_header"><span></span>순번</label>
								</th>
								<th>SPC명</th>
								<th>발전소명</th>
								<th>보고서 유형</th>
								<th>적용기간</th>
								<th>다운로드</th>
								<th>보고서 생성 시간</th>
								<th>발행자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<input type="checkbox" id="chk_op1" name="rowCheck" value="">
									<label for="chk_op1"><span></span>1</label>
								</td>
								<td>SPC명</td>
								<td>혜원 솔라 01</td>
								<td>월간보고서</td>
								<td>2020-03-01 ~ 2020-04-30</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37&month=2020-01'" ><button class="tx_file">EXCEL</button></td>
								<td>2020-03-01 14:21</td>
								<td>발행 아이디</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" id="chk_op2" name="rowCheck" value="">
									<label for="chk_op2"><span></span>2</label>
								</td>
								<td>SPC명</td>
								<td>혜원 솔라 02</td>
								<td>월간보고서</td>
								<td>2020-03-01 ~ 2020-04-30</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=0c7c90c6-9505-4f77-b42d-500c2879c689&month=2020-01'"><button class="tx_file">EXCEL</button></td>
								<td>2020-03-01 14:21</td>
								<td>발행 아이디</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" id="chk_op3" name="rowCheck" value="">
									<label for="chk_op3"><span></span>3</label>
								</td>
								<td>SPC명</td>
								<td>혜원 솔라 01</td>
								<td>월간보고서</td>
								<td>2020-03-01 ~ 2020-04-30</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=fa313b15-1fe1-41e3-b592-5a739e3d9b37&month=2020-02'"><button class="tx_file">EXCEL</button></td>
								<td>2020-03-01 14:21</td>
								<td>발행 아이디</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" id="chk_op4" name="rowCheck" value="">
									<label for="chk_op4"><span></span>4</label>
								</td>
								<td>SPC명</td>
								<td>혜원 솔라 02</td>
								<td>월간보고서</td>
								<td>2020-03-01 ~ 2020-04-30</td>
								<td onClick="location.href='http://iderms.enertalk.com:8443/report/site?reportNo=1&sid=0c7c90c6-9505-4f77-b42d-500c2879c689&month=2020-02'"><button class="tx_file">EXCEL</button></td>
								<td>2020-03-01 14:21</td>
								<td>발행 아이디</td>
							</tr>
							<tr>
								<td></td>
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
								<td></td>
							</tr>
						</tbody>
					</table>	
				</div>
				<div class="paging_wrap">
					<a href="#;" class="btn_prev">prev</a>
					<strong>1</strong>
					<a href="#;" class="btn_next">next</a>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
