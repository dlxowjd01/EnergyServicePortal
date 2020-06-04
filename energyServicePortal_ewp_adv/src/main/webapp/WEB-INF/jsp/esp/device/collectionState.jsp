<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header fl">수집 현황</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2020-04-23 14:01:02</em>
			  </div>
		</div>
		<div class="header_drop_area col-lg-2">
			<div class="dropdown">
				<button id="siteSummary" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu dropdown-menu-form chk_type">
					<li class="dropdown_cov clear">
						<div class="sec_li_bx">
							<p class="tx_li_tit">사업소 별</p>
							<ul id="siteList">
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="checkbox" id="chk_op1" value="사업소#1">
										<label for="chk_op01"><span></span>사업소#1</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="checkbox" id="chk_op2" value="사업소#2">
										<label for="chk_op02"><span></span>사업소#2</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="checkbox" id="chk_op3" value="사업소#3">
										<label for="chk_op03"><span></span>사업소#3</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="checkbox" id="chk_op4" value="사업소#4">
										<label for="chk_op04"><span></span>사업소#4</label>
									</a>
								</li>
							</ul>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="col-lg-10">
			<div class="collect_btn">
				<a href="#" class="btn_type02">로그 저장</a>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-5">
			<div class="indiv">
				<div class="tbl_wrap_type collect_wrap">
					<div class="tbl_top clear">
						<h2 class="ntit fl">RTU</h2>
						<button type="submit" class="btn_type fr">등록</button>
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
		<div class="col-lg-7">
			<div class="indiv">
				<div class="tbl_wrap_type collect_wrap">
					<div class="tbl_top clear">
						<h2 class="ntit fl">Local EMS</h2>
						<button type="submit" class="btn_type fr">등록</button>
					</div>
					<table class="his_tbl">
						<thead>
							<tr>
								<th>사이트 ID</th>
								<th>로컬 EMS ID</th>
								<th>로컬 EMS 주소</th>
								<th>로컬 EMS 암호키</th>
								<th>등록 일자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
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
							</tr>
							<tr>
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
							</tr>
							<tr>
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
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
				<div class="tbl_wrap_type collect_wrap">
					<div class="row tbl_top clear">
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
	<script>
		$(function(){
			//사업소 정보 받아오기
			const oid = "spower";
			// const sites;
			// const rtus;
			
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
						$('#logTable tbody').empty();
						let str = ``;
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
							$('#logTable tbody').append(str);
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
					$('#siteSummary').text(`${'${sites[0].name}'} 외 ${'${sites.length-1}개'}`).append('<span class="caret"></span>');
					$('#siteSummary').html

					$('#siteList').empty();
					$('#PV_INVERTER tbody').empty();
					let str = ``;
					let siteList = ``;
					sites.forEach((site, siteIdx) =>{
						siteList = `
							<li>
								<a href="#" data-value="option${'${site.siteIdx}'}" tabindex="-1">
									<input type="checkbox" id="chk_op${'${site.siteIdx}'}" value="${'${site.name}'}">
									<label for="chk_op0${'${site.siteIdx}'}"><span></span>${'${site.name}'}</label>
								</a>
							</li>
						`;
						$('#siteList').append(siteList);
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
									$('#PV_INVERTER tbody').append(str);
									$(`#${'${rtu.serialNumber}'}`).on('click', ()=>{selectLog(rtu.rid)});
									$('#selectLogByDate').on('click', ()=>{
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