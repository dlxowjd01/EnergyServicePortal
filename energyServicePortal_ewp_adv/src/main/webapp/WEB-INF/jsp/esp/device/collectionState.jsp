<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
	<script src="/js/commonDropdown.js"></script>
	<div class="row">
		<div class="col-12">
			<h1 class="page-header fl">수집 현황</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2020-04-23 14:01:02</em>
			  </div>
		</div>
		<div class="col-12">
			<div class="dropdown fl">
				<button id="siteSummary" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu dropdown-menu-form chk_type">
					<li class="dropdown_cov clear">
						<div class="sec_li_bx">
							<p class="tx_li_tit">사업소 별</p>
							<ul id="siteList">
							</ul>
						</div>
					</li>
				</ul>
			</div>
			<div class="collect_btn fr">
				<a href="#" class="btn_type02">로그 저장</a>
			</div>
		</div>
	</div>

	<div class="modal fade" id="registerModal" role="dialog">
		<div class="modal-dialog modal-md">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">RTU 등록</h4>
				</div>
				<div class="modal-body">
					<div class="input-group">
						<label for="siteName" class="input-name">사이트</label>
						<div id="siteName" class="dropdown">
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
								선택해주세요.<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
						</div>
					</div>
					<div class="input-group">
						<label for="siteName" class="input-name">시리얼 번호</label>
						<div id="serialNum" class="dropdown">
							<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
								선택해주세요.<span class="caret"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn_type" data-dismiss="modal">확인</button>
					<button type="button" class="btn btn-btn_type" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-xl-5 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv collect_box">
				<div class="tbl_wrap_type collect_wrap">
					<div class="tbl_top clear">
						<h2 class="ntit fl">RTU</h2>
						<button type="button" class="btn_type fr" data-toggle="modal" data-target="#registerModal">등록</button>
					</div>
					<table class="his_tbl" id="PV_INVERTER">
						<thead>
							<tr>
								<th>사이트 ID</th>
								<th>RTU ID</th>
								<th>RTU 시리얼 번호</th>
								<th>등록 일자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
						</tbody>
					</table>
					<div class="paging_wrap">
						<a href="#;" class="btn_prev">prev</a>
						<strong>1</strong>
						<%--<a href="#;">2</a>--%>
						<%--<a href="#;">3</a>--%>
						<a href="#;" class="btn_next">next</a>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-7 col-lg-6 col-md-6 col-sm-12">
			<div class="indiv collect_box_fixed">
				<div class="tbl_top clear">
					<h2 class="ntit fl">RTU 이름</h2>
					<button type="button" class="btn_type fr">삭제</button>
				</div>
				<div class="row">
					<div class="col-6 pt-0">
						<ul class="device_list">
							<li>
								<span>기기 정보</span>
								<span></span>
							</li>
							<li>
								<td>RTU 이름</td>
								<span></span>
							</li>
							<li>
								<td>시리얼 번호</td>
								<span></span>
							</li>
							<li>
								<td>디스트 사용량</td>
								<span></span>
							</li>
							<li>
								<td>코드 버전</td>
								<span></span>
							</li>
						</ul>
					</div>
					<div class="col-6 pt-0">
						<ul class="device_list">
							<li>
								<span>기기 상태</span>
								<span></span>
							</li>
							<li>
								<td>CPU 사용량</td>
								<span></span>
							</li>
							<li>
								<td>메모리 사용량</td>
								<span></span>
							</li>
							<li>
								<td>디스트 사용량</td>
								<span></span>
							</li>
							<li>
								<td>기기 온도</td>
								<span></span>
							</li>
						</ul>
					</div>
				</div>
				<div class="tbl_top clear">
					<h2 class="ntit fl">연결 설비</h2>
				</div>
				<div class="collect_wrap table_scroll">
					<table class="his_tbl">
						<thead>
							<tr>
								<th>설비 타입</th>
								<th>설비 명</th>
								<th>통신 유형</th>
								<th>Baud Rate</th>
								<th>설비 용량</th>
								<th>상세 정보</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="paging_wrap">
					<a href="#;" class="btn_prev">prev</a>
					<strong>1</strong>
					<%--<a href="#;">2</a>--%>
					<%--<a href="#;">3</a>--%>
					<a href="#;" class="btn_next">next</a>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-12">
			<div class="indiv collect_box">
				<div class="tbl_wrap_type collect_wrap">
					<div class="tbl_top clear">
						<h2 class="ntit fl">데이터 수집 로그</h2>
					</div>
					<div class="clear inp_align">
						<div class="fl">
							<span class="tx_tit">기간 설정</span>
							<div class="sel_calendar">
								<input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
								<em></em>
								<input type="text" id="timepicker1" name="timepicker1" class="sel timepicker"/>
								<em></em>
								<input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
								<em></em>
								<input type="text" id="timepicker2" name="timepicker2" class="sel timepicker"/>
								<script>
									$('.timepicker').wickedpicker({twentyFour: true});
									$('#datepicker1').datepicker({ dateFormat: 'yy-mm-dd'}).datepicker("setDate", new Date()); //데이트 피커 기본
									$('#datepicker2').datepicker({ dateFormat: 'yy-mm-dd'}).datepicker("setDate", new Date()); //데이트 피커 기본
								</script>
							</div>
						</div>
						<div class="fl">
							<button type="submit" class="btn_type" id="selectLogByDate">검색</button>
						</div>
					</div>
					<table class="his_tbl" id="logTable">
						<colgroup>
						<col style="width:10%">
						<col style="width:10%">
						<col style="width:10%">
						<col style="width:12%">
						<col style="width:12%">
						<col style="width:10%">
						<col>
						</colgroup>
						<thead>
							<tr>
								<th>사이트 ID</th>
								<th>수집 타입 ID</th>
								<th>수집기 ID</th>
								<th>송신 시간</th>
								<th>수신 시간</th>
								<th>상태</th>
								<th>수신 데이터</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td class="ellipsis">-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td class="ellipsis">-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td class="ellipsis">-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td class="ellipsis">-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td class="ellipsis">-</td>
							</tr>
							<tr>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td>-</td>
								<td class="ellipsis">-</td>
							</tr>
						</tbody>
					</table>
					<div class="paging_wrap">
						<a href="#;" class="btn_prev">prev</a>
						<strong>1</strong>
						<%--<a href="#;">2</a>--%>
						<%--<a href="#;">3</a>--%>
						<a href="#;" class="btn_next">next</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			//사업소 정보 받아오기
			const oid = "spower";
			const now = new Date();
			const nowLocal = now.format("yyyyMMddhhmmss");
			const beforeHour = new Date(now.getFullYear(), now.getMonth(), now.getDay(), now.getHours()-1, now.getMinutes(), now.getSeconds()).format("yyyyMMddhhmmss");

			function selectLog(rids, startTime, endTime, limit=5, page=1){
				const now = new Date();
				const nowLocal = now.format("yyyyMMddhhmmss");
				const beforeHour = new Date(now.getFullYear(), now.getMonth(), now.getDay(), now.getHours()-1, now.getMinutes(), now.getSeconds()).format("yyyyMMddhhmmss");

				if(startTime === undefined) startTime = beforeHour;
				if(endTime === undefined) endTime = nowLocal;
				$.ajax({
					url: "http://iderms.enertalk.com:8443/log",
					type: "get",
					async: false,
					data: {
						rids,
						startTime,
						endTime,
						limit,
						page
					},
					success: function (result){
						//데이터 세팅
						let logTable = $("#logTable").find("tbody");
						let str = ``;
						logTable.empty();
						result.logs.forEach((log,logIdx)=>{
							str = `
								<tr>
									<td>${'${log.sName}'}</td>
									<td>${'${log.rName}'}</td>
									<td>${'${log.dName}'}</td>
									<td>${'${log.dTimestamp}'}</td>
									<td>${'${log.dLocaltime}'}</td>
									<td>${'${log.dOperation}'}</td>
									<td class="ellipsis">${'${log.log}'}</td>
								</tr>
							`;
							logTable.append(str);
						})
					},
					error: function (error){
						console.error(error);
					}
				})
			};
			
			$.ajax({
				url: "http://iderms.enertalk.com:8443/config/sites",
				type: "get",
				async: false,
				data: {
					oid,
				},
				success: function (sites) {
					const siteSum = $('#siteSummary');
					const tableData = $('#PV_INVERTER').find("tbody");
					const arrIcon = '<span class="caret"></span>';
					const siteList = $('#siteList');
					const dateFilter = $('#selectLogByDate');

					siteSum.text(`${'${sites[0].name}'} 외 ${'${sites.length-1}개'}`).append(arrIcon);
					siteList.empty();
					tableData.empty();

					let str = ``;
					let newList = ``;
					sites.forEach((site, siteIdx) =>{
						newList = `
							<li>
								<a href="#" data-value="option${'${site.siteIdx}'}" tabindex="-1">
									<input type="checkbox" id="chk_op${'${site.siteIdx}'}" value="${'${site.name}'}" name="${'${site.siteIdx}'}">
									<label for="chk_op0${'${site.siteIdx}'}"><span></span>${'${site.name}'}</label>
								</a>
							</li>
						`;
						siteList.append(newList);
						$.ajax({
							url: "http://iderms.enertalk.com:8443/config/rtus",
							type: "get",
							async: false,
							data: {
								oid,
								sid: site.sid
							},
							success: function (rtus) {
								let rtuDate = ``;
								rtus.forEach((rtu, rtuIdx)=>{
									rtuDate = new Date(rtu.createdAt).format("yyyy-MM-dd");
									str = `
									<tr id="${'${rtu.serialNumber}'}">
										<td>${'${site.name}'}</td>
										<td>${'${rtu.name}'}</td>
										<td>${'${rtu.serialNumber}'}</td>
										<td>${'${rtuDate}'}</td>
									</tr>`;
									tableData.append(str);
									$(`#${'${rtu.serialNumber}'}`).on('click', ()=>{selectLog(rtu.rid)});
									dateFilter.on('click', ()=>{
										const start = new Date($('#datepicker1').val().slice(0,4),Number($('#datepicker1').val().slice(5,7))-1, $('#datepicker1').val().slice(8,10),$('#timepicker1').val().slice(0,2),$('#timepicker1').val().slice(5,7),0 ).format("yyyyMMddhhmmss");
										const end = new Date($('#datepicker2').val().slice(0,4),Number($('#datepicker2').val().slice(5,7))-1, $('#datepicker2').val().slice(8,10),$('#timepicker2').val().slice(0,2),$('#timepicker2').val().slice(5,7),0 ).format("yyyyMMddhhmmss");
										selectLog(rtu.rid, start, end);
									});
								});
							},
							error: function (error){
								console.error(error);
							}
						})
					})
					
				},
				error: function (error){
					console.error(error);
				}
			});
		})
	</script>