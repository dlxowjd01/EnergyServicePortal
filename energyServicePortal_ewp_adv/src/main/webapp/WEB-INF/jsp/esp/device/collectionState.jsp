<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl"><fmt:message key='colState.title' /></h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime"></em>
			<span>DATA BASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>
<div class="row">
	<div class="w-100" style="padding: 12px;">
		<div class="dropdown-wrapper w-100 flex-wrap-center">
			<div class="dropdown" id="selectSiteList">
				<button type="button" class="dropdown-toggle w10 no-close" data-toggle="dropdown" data-name="<fmt:message key='colState.register.siteSelect' />">
				<fmt:message key='colState.search.site' /><span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk-type" role="menu" id="siteULList">
					<li data-value="[sid]">
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="site_[INDEX]" data-role="[role]" value="[sid]" name="site">
							<label for="site_[INDEX]">[name]</label>
						</a>
					</li>
				</ul>
			</div>
			<a href="javascript:void(0);" class="btn-type02 btn-save fr" id="excelDown"><fmt:message key="datacolleciton.4.savelog" /></a>
		</div>
	</div>
</div>

<div class="modal fade" id="addRtuModal" aria-labelledby="RTU_Register" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content collect-modal-content">
			<div id="RTU_Register" class="modal-header"><fmt:message key='colState.register.title' /></div>
			<div class="modal-body">
				<div class="input-group inline-flex">
					<label for="rtuSite" class="input-label"><fmt:message key='colState.register.site' /></label>
					<div class="dropdown" id="rtuSite">
						<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='colState.register.siteSelect' />">
							<fmt:message key='colState.register.siteSelect' /><span class="caret"></span>
						</button>
						<ul class="dropdown-menu chk-type" id="rtuSiteULList">
							<li data-value="[sid]">
								<a href="javascript:void(0);" tabindex="-1">[name]</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="input-group inline-flex">
					<label for="serialNumber" class="input-label"><fmt:message key='colState.register.number' /></label>
					<input type="text" name="serialNumber" id="serialNumber" class="text-input-type text-input">
				</div>
				<div class="input-group inline-flex">
					<label for="rtuName" class="input-label"><fmt:message key='colState.register.name' /></label>
					<input type="text" name="rtuName" id="rtuName" class="text-input-type text-input">
				</div>
				<div class="input-group inline-flex">
					<label for="rtuSecret" class="input-label"><fmt:message key='colState.register.password' /></label>
					<input type="text" name="rtuSecret" id="rtuSecret" class="text-input-type text-input">
				</div>
				<div class="input-group inline-flex">
					<label for="description" class="input-label"><fmt:message key='colState.register.memo' /></label>
					<textarea class="textarea" id="description" name="description"></textarea>
				</div>
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key='colState.register.cancle' /></button>
					<button type="button" class="btn-type" onclick="registerRtu(); return false"><fmt:message key='colState.register.ok' /></button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-xl-5 col-lg-6 col-md-6 col-sm-12">
		<div class="indiv collect-box" id="colStateRtu">
			<div class="table-top">
				<h2 class="ntit fl"><fmt:message key="datacolleciton.1.rtu" /></h2>
				<div>
					<button class="status-button rtu-filter-button normal actived" data-status="normal"><fmt:message key="button.normal" /> (0)</button>
					<button class="status-button rtu-filter-button error actived" data-status="error"><fmt:message key="button.error" /> (0)</button>
				</div>
			</div>
			<div class="table-wrap-type collect-wrap">
				<table class="history-table scroll" id="PV_INVERTER">
					<colgroup>
						<col style="width: 6%">
						<col style="width: 30%">
						<col style="width: 20%">
						<col style="width: 14%">
						<col style="width: 18%">
						<col style="width: 17%">
					</colgroup>
					<thead>
						<tr>
							<th><fmt:message key="datacolleciton.1.ix" /></th>
							<th><fmt:message key="datacolleciton.1.siteid" /></th>
							<th><fmt:message key="datacolleciton.1.rtuid" /></th> 
							<th><fmt:message key="datacolleciton.1.rtuStatus" /></th> 
							<th><fmt:message key="datacolleciton.1.rtusn" /></th>
							<th><fmt:message key="datacolleciton.1.reg.date" /></th>
						</tr>
					</thead>
					<tbody>
					<tr>
						<td colspan="5"><fmt:message key='colState.table.info' /></td>
					</tr>
					</tbody>
				</table>
				<div class="pagination-wrapper" id="paging"></div>
			</div>
			<button type="button" class="btn-type fr" id="showRegRtu"><fmt:message key="datacolleciton.1.add" /></button>
		</div>
	</div>
	<div class="col-xl-7 col-lg-6 col-md-6 col-sm-12">
		<div class="indiv collect-box" id="colStateInfo">
			<div class="table-top clear">
				<h2 class="ntit fl"><span id="selectedRTU">RTU</span> <fmt:message key='colState.table.detail' /></h2>
				<div class="btn-wrap-type02 fr">
					<button type="button" class="btn-type03 delete_btn"><fmt:message key='colState.table.del' /></button>
					<button type="button" class="btn-type modify_btn"><fmt:message key='colState.table.update' /></button>
				</div>
			</div>
			<div class="col-scroll">
				<div class="row">
					<div class="w-50">
						<h2 class="list-title"><fmt:message key='colState.detail.title' /></h2>
						<ul id="rtuDeviceInfo" class="device-list">
							<li><fmt:message key='colState.detail.number' /><span class="data-val"></span></li>
							<li><fmt:message key='colState.detail.version' /><span class="data-val"></span></li>
						</ul>
					</div>
					<div class="w-50">
						<h2 class="list-title"><fmt:message key='colState.detail.status' /></h2>
						<ul id="deviceStatus" class="device-list">
							<li><fmt:message key='colState.detail.cpu' /><span class="data-val"></span></li>
							<li><fmt:message key='colState.detail.memory' /><span class="data-val"></span></li>
							<li><fmt:message key='colState.detail.disk' /><span class="data-val"></span></li>
							<li><fmt:message key='colState.detail.temperature' /><span class="data-val"></span></li>
						</ul>
					</div>
				</div>
	
				<div class="table-wrap-type collect-wrap">
					<ul class="nav nav-tabs">
						<li class="nav-item active">
							<a class="nav-link" data-toggle="tab" href="#deviceList"><fmt:message key='colState.detail.connected' /></a>
						</li>
						<li class="nav-item">
							<a class="nav-link" data-toggle="tab" href="#commandSend"><fmt:message key='colState.detail.command' /></a>
						</li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane fade active in spc-table-row st-edit panel-collapse collapse" id="deviceList">
							<div class="table-top clear"></div>
							<div class="collect-wrap table-scroll">
								<table id="detailInfoTable" class="history-table">
									<thead>
									<tr>
										<th><fmt:message key='colState.detail.type' /></th>
										<th><fmt:message key='colState.detail.name' /></th>
										<th><fmt:message key='colState.detail.networkType' /></th>
										<th>Baud Rate</th>
										<th><fmt:message key='colState.detail.size' /></th>
										<th><fmt:message key='colState.detail.info' /></th>
									</tr>
									</thead>
									<tbody>
									<tr>
										<td colspan="6"><fmt:message key='colState.detail.alert' /></td>
									</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="tab-pane fade spc-table-row st-edit panel-collapse collapse" id="commandSend">
							<div class="row">
								<div class="w-100">
									<div id="rtuCommand" class="command-list">
										<div class="flex-group">
											<span class="sm-title"><fmt:message key='colState.detail.sendCmd.command' /></span>
											<div class="dropdown" id="command">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='colState.select' />"><fmt:message key='colState.detail.sendCmd.select' /><span class="caret"></span></button>
												<ul class="dropdown-menu" role="menu">
													<li data-value="kpx_targetPower"><a href="javascript:void(0);" tabindex="-1">kpx_targetPower</a></li>
												</ul>
											</div>
										</div>
										<div class="flex-group">
											<span class="sm-title"><fmt:message key='colState.detail.sendCmd.option' /></span>
											<div class="dropdown" id="commandKey">
												<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='colState.select' />"><fmt:message key='colState.detail.sendCmd.select' /><span class="caret"></span></button>
												<ul class="dropdown-menu" role="menu" id="selectCmdOptList">
													<li data-value="targetPower"><a href="javascript:void(0);" tabindex="-1"><fmt:message key='colState.detail.sendCmd.target' /></a></li>
												</ul>
											</div>
										</div>
										<div class="flex-group">
											<div class="text-input-type">
												<input type="text" id="optionVal" name="optionVal" placeholder="">
											</div>
											<div class="btn-wrap-type02 flex-start">
												<%--								<button type="button" class="btn-type03"><fmt:message key='colState.detail.sendCmd.del' /></button>--%>
												<button type="button" class="btn-type" onclick="commandModal();"><fmt:message key='colState.detail.sendCmd.send' /></button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="indiv collect-box last-box">
			<div class="table-wrap-type collect-wrap">
				<div class="table-top clear">
					<h2 class="ntit fl"><fmt:message key="datacolleciton.3.datacollectionlog" /></h2>
				</div>
				<div class="clear input-align collection-log-filter">
					<div class="fl">
						<span class="tx-tit"><fmt:message key='colState.log.type' /></span>
						<div class="sel-calendar">
							<div class="dropdown" id="logType">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='colState.log.status' />"><fmt:message key='colState.log.status' /><span class="caret"></span></button>
								<ul class="dropdown-menu" role="menu">
									<li data-value="상태">
										<a href="javascript:void(0);" tabindex="-1"><fmt:message key='colState.log.status' /></a>
									</li>
									<li data-value="제어">
										<a href="javascript:void(0);" tabindex="-1"><fmt:message key='colState.log.control' /></a>
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="fl">
						<span class="tx-tit"><fmt:message key="datacolleciton.3.timeframe" /></span>
						<div class="sel-calendar">
							<input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
							<em></em>
							<input type="text" id="timepicker1" name="timepicker1" class="sel timepicker"/>
							<em></em>
							<input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
							<em></em>
							<input type="text" id="timepicker2" name="timepicker2" class="sel timepicker"/>
						</div>
					</div>
					<div class="fl">
						<button type="button" class="btn-type" id="selectLogByDate"><fmt:message key="datacolleciton.3.search" /></button>
					</div>
				</div>
				<div id="logTableDiv">
					<table class="history-table" id="logTable">
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
							<th><fmt:message key="datacolleciton.3.siteid" /></th>
							<th><fmt:message key='colState.log.rtuName' /></th>
							<th><fmt:message key='colState.log.name' /></th>
							<th><fmt:message key="datacolleciton.3.trans.time" /></th>
							<th><fmt:message key="datacolleciton.3.receptiontime" /></th>
							<th><fmt:message key="datacolleciton.3.status" /></th>
							<th><fmt:message key="datacolleciton.3.received.data" /></th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td colspan="7"><fmt:message key='colState.log.alert' /></td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="pagination-wrapper" id="logPaging">
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade in" id="certModal" role="dialog">
	<form id="passForm" name="passForm" method="GET">
		<div class="modal-dialog modal-lg">
			<div class="modal-content device_modal_content">
				<div class="modal-header"><fmt:message key='colState.log.checkPass' /></div>
				<div class="modal-body">
					<div class="row">
						<div class="col-12">
							<input type="password" id="certPass" name="certPass" class="input text-input-type w-100" value="" placeholder="<fmt:message key='colState.log.pasword' />" autocomplete="off">
						</div>
					</div>
					<div class="btn-wrap-type02">
						<button type="button" class="btn-type" onclick="commandSend();"><fmt:message key='colState.log.ok' /></button>
						<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key='colState.log.cancle' /></button>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	pagePerData = 5;
	//사업소 정보 받아오기
	const now = new Date();
	const nowLocal = now.format('yyyyMMddHHmmss');
	const beforeHour = new Date(now.getFullYear(), now.getMonth(), now.getDay(), now.getHours() - 1, now.getMinutes(), now.getSeconds()).format("yyyyMMddHHmmss");
	const searchFilter = JSON.stringify({'include': [{'relation': 'rtus'}]});

	$(function () {
		setInitList('siteULList'); //사업소 리스트 초기화
		setInitList('rtuSiteULList');
		siteMakeList(); //사업소 리스트 그리기
		getRtuDataList(); //RTU 데이터리스트

		let setNowTime = new Date();
		setNowTime.setMinutes(setNowTime.getMinutes() - 5);
		$('#timepicker1').wickedpicker({now: setNowTime.format('HH:mm'), twentyFour: true});
		$('#timepicker2').wickedpicker({twentyFour: true});
		$('#datepicker1').datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', new Date()); //데이트 피커 기본
		$('#datepicker2').datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', new Date()); //데이트 피커 기본

		//RTU 등록 페이지
		$('#showRegRtu').on('click', function () {
			showReigister();
		});

		$('.delete_btn').on('click', function () {
			const rid = $('#selectedRTU').data('rid');

			if (role === '2') {
				let role = true;
				document.querySelectorAll('[name="site"]:checked').forEach(checked => {
					if (!isEmpty(checked.dataset.role) && checked.dataset.role === '2') {
						role = false;
					}
				});

				if (!role) {
					alert('선택한 사이트 중 권한이 없는 사이트가 있습니다.');
					return false;
				}
			}

			if (isEmpty(rid)) {
				alert('<fmt:message key="colState.alert.1" />');
				return false;	
			}

			if (!confirm('<fmt:message key="colState.confirm.1" />')) {
				return false;
			}

			$.ajax({
				url: apiHost + '/config/rtus/' + rid,
				type: 'delete',
				dataType: 'json',
				contentType: 'application/json',
				data: {},
				success: function (data) {
					alert('<fmt:message key="colState.alert.2" />');

					getRtuDataList();
				},
				error: function (error) {
					console.error(error);
					alert('<fmt:message key="colState.alert.3" />');
					return false;
				}
			});
		});
		
		$('#excelDown').on('click', function() {
			const rids = $('#selectedRTU').data('rid');
			const datePicker1 = $('#datepicker1').datepicker('getDate');
			const datePicker2 = $('#datepicker2').datepicker('getDate');
			const start = datePicker1.format('yyyyMMdd');
			const end = datePicker2.format('yyyyMMdd');
			const startTimepicker = $('#timepicker1').wickedpicker('time').replace(/[^0-9]/g, '');
			const endTimepicker = $('#timepicker2').wickedpicker('time').replace(/[^0-9]/g, '');

			let startTime = start + startTimepicker + '00';
			let endTime = end + endTimepicker + '00';

			if (isEmpty(rids)) {
				alert('RTU 정보가 확인되지 않습니다.');
				return false;
			}

			$.ajax({
				url: apiHost + '/log',
				type: 'get',
				async: false,
				data: {
					rids,
					startTime,
					endTime
				},
				success: function (result) {
					var column = ['sName','rName','dName','dTimestamp','dLocaltime','dOperation','log'], //json Key
						header = ['<fmt:message key="colState.thead.1" />','<fmt:message key="colState.thead.2" />','<fmt:message key="colState.thead.3" />','<fmt:message key="colState.thead.4" />','<fmt:message key="colState.thead.5" />' ,'<fmt:message key="colState.thead.6" />', '<fmt:message key="colState.thead.7" />']; //csv 파일 헤더

					let logList = result.logs;

					logList.forEach((log, logIdx) => {
						logList[logIdx]['dTimestamp'] = new Date(log.dTimestamp).format('yyyy-MM-dd HH:mm:ss');
						logList[logIdx]['dLocaltime'] = String(log.dLocaltime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
					})

					if(confirm('<fmt:message key="colState.confirm.2" />')) {
						getJsonExcelDownload(logList, column, header, '<fmt:message key="colState.xlsName" />'); // json list, 컬럼, 헤더명, 파일명
					}
				},
				error: function (error) {
					console.error(error);
				}
			});

		});

		$('.modify_btn').on('click', function () {
			const rid = $('#selectedRTU').data('rid');

			if (role === '2') {
				let role = true;
				document.querySelectorAll('[name="site"]:checked').forEach(checked => {
					if (!isEmpty(checked.dataset.role) && checked.dataset.role === '2') {
						role = false;
					}
				});

				if (!role) {
					alert('선택한 사이트 중 권한이 없는 사이트가 있습니다.');
					return false;
				}
			}


			if (isEmpty(rid)) {
				alert('<fmt:message key="colState.alert.4" />');
				return false;
			}

			$.ajax({
				url: apiHost + '/config/rtus/' + rid,
				type: 'get',
				dataType: 'json',
				data: {},
				success: function (data) {
					showReigister(data);
				},
				error: function (error) {
					console.error(error);
					alert('<fmt:message key="colState.alert.5" />');
					return false;
				}
			});
		});

		$(".rtu-filter-button").on('click', function(e) {
			const l = $(".rtu-filter-button.actived").length;
			if (l === 1 && $(this).hasClass("actived")) {
				$(".rtu-filter-button").addClass("actived");
			} else {
				$(".rtu-filter-button").removeClass("actived");
				$(this).addClass("actived");
			}
			
			statusFilter();
		});

		$('#selectLogByDate')
		.off('click')
		.on('click', () => {
			const rid = $('#selectedRTU').data('rid');

			const datePicker1 = $('#datepicker1').datepicker('getDate');
			const datePicker2 = $('#datepicker2').datepicker('getDate');
			if(datePicker1 != null && datePicker2 != null) {
				const start = datePicker1.format('yyyyMMdd');
				const end = datePicker2.format('yyyyMMdd');
				const startTimepicker = $('#timepicker1').wickedpicker('time').replace(/[^0-9]/g, '');
				const endTimepicker = $('#timepicker2').wickedpicker('time').replace(/[^0-9]/g, '');

				const startDate = start + startTimepicker + '00';
				const endDate = end + endTimepicker + '00';

				selectLog(rid, startDate, endDate);
			} else {
				alert('<fmt:message key="colState.alert.6" />');
				return false;
			}
		});
	})
	function statusFilter() {
		let target = [];
		$(".rtu-filter-button.actived").each((ix, el) => {
			target.push("."+$(el).data("status"));
		});
		
		$("#PV_INVERTER tbody tr").each((ix, el) => {
			$(el).removeClass("visible");
			if ($(el).is(target.join(", "))) {
				$(el).addClass("visible");
			}
		})
	}

	//사업소 조회
	const siteMakeList = function (search = []) {
		const makeSite = search.length ? Array.from(search) : Array.from(siteList);
		makeSite.sortOn('name');
		makeSite.unshift({ sid: 'all', role: '', name: '<fmt:message key="dropDown.all" />'});
		setMakeList(makeSite, 'siteULList', {'dataFunction': {}}); //list생성

		$('#siteULList').find('input[value="all"]').parent().after('<li class="btn-wrap-border-min"></li>');

		if (!$(`.dropdown-search`).length) {
			$(`#selectSiteList`)
				.prepend(`<div class="dropdown-search"><input type="text" placeholder="<fmt:message key="dropdown.siteSearch" />" onKeyup="searchSite($(this).val())" ></div>`)
				.append(`<div class="btn-wrap-type03 btn-wrap-border dropdown-apply"><button type="button" class="btn-type mr-16"><fmt:message key="colState.apply" /></button></div>`);
		}
	}

	const searchSite = keyword => {
		const result = siteList.filter(x => x.name.includes(keyword));

		siteMakeList(result);
	}

	function selectLog(rids, startTime, endTime, limit, page) {
		limit = isEmpty(page) ? pagePerData : limit;
		page = isEmpty(page) ? 1 : page;

		const logType = isEmpty($('#logType button').data('value')) ? '상태' : $('#logType button').data('value');
		if (isEmpty(startTime) || isEmpty(endTime)) {
			const datePicker1 = $('#datepicker1').datepicker('getDate');
			const datePicker2 = $('#datepicker2').datepicker('getDate');
			const start = datePicker1.format('yyyyMMdd');
			const end = datePicker2.format('yyyyMMdd');
			const startTimepicker = $('#timepicker1').wickedpicker('time').replace(/[^0-9]/g, '');
			const endTimepicker = $('#timepicker2').wickedpicker('time').replace(/[^0-9]/g, '');

			startTime = start + startTimepicker + '00';
			endTime = end + endTimepicker + '00';
		}

		const now = new Date();
		const nowLocal = now.format('yyyyMMddHHmmss');
		const beforeHour = new Date(now.getFullYear(), now.getMonth(), now.getDay(), now.getHours() - 1, now.getMinutes(), now.getSeconds()).format('yyyyMMddHHmmss');
		// START: rtu Detail info setting

		const rtuInfo = [
			{
				url: apiHost + '/config/rtus/' + rids,
				type: 'get',
				dataType: 'json',
				data: {
					includeDevices: true
				}
			},
			{
				url: apiHost + '/status/raw',
				type: 'get',
				dataType: 'json',
				data: {
					dids: rids,
					isRtu: true
				}
			}
		];
		// END

		$.when($.ajax(rtuInfo[0]), $.ajax(rtuInfo[1])).done(function (result1, result2) {
			if (result1[0]) {
				const basic = result1[0];
				const info = $('#rtuDeviceInfo').find('.data-val');
				const table = $('#detailInfoTable').find('tbody');
				const devices = basic.devices;
				info.eq(0).text(result1[0].serialNumber);
				basic.version ? info.eq(1).text(basic.version) : info.eq(1).addClass('no-val').text("-");
				table.empty().data('deviceList', devices);

				let str = ``;
				if (!isEmpty(devices)) {
					devices.forEach((device, idx) => {
						let comType = '';
						let baudRate = '';
						let capacity = '';
						let description = '';
						let rtuComm = device.rtu_details;

						if (rtuComm) {
							let newJson = JSON.parse(rtuComm);
							comType = newJson['com-type'];
							baudRate = newJson['baud-rate'];
						} else {
							comType = '-';
							baudRate = '-'
						}
						// TO DO!!!! convert with common library!!!!!
						device.capacity ? (capacity = device.capacity) : (capacity = '-');
						// END
						device.description ? (description = device.description) : (description = '-');
						str = `
								<tr>
									<td>${'${device.device_type}'}</td>
									<td>${'${device.name}'}</td>
									<td>${'${comType}'}</td>
									<td>${'${baudRate}'}</td>
									<td>${'${capacity}'}</td>
									<td>${'${description}'}</td>
								</tr>
							`;
						table.append(str);
					});
				}
			} else {
				return false;
			}

			if (!isEmpty(result2[0][rids]) && !isEmpty(result2[0][rids].data)) {
				const detail = result2[0][rids].data[0];
				const status = $('#deviceStatus').find('.data-val');
				status.eq(0).text(detail.cpu.toFixed(2) + ' %');
				status.eq(1).text(detail.mem.toFixed(2) + ' %');
				status.eq(2).text(detail.disk.toFixed(2) + ' %');
				status.eq(3).html(`${'${detail.temperature.toFixed(2)}'} &#8451;`);

				const dbTime = new Date(detail['timestamp']);
				$('.dbTime').text(dbTime.format('yyyy-MM-dd HH:mm:ss'));
			} else {
				const status = $('#deviceStatus').find('.data-val');
				status.eq(0).text('- %');
				status.eq(1).text('- %');
				status.eq(2).text('- %');
				status.eq(3).html('- &#8451;');

				$('.dbTime').text('');
				return false;
			}
		});

		if (isEmpty(startTime)) startTime = beforeHour;
		if (isEmpty(endTime)) endTime = nowLocal;

		if (logType == '제어') {
			$.ajax({
				url: apiHost + '/control/command_history',
				type: 'get',
				async: false,
				data: {
					oid: oid,
					rids: rids,
					startTime: startTime,
					endTime: endTime,
					limit: limit,
					page: page
				},
				success: function (result) {
					//데이터 세팅
					const rName = $('#selectedRTU').data('rName');
					const sName = $('#selectedRTU').data('sName');
					let logTable = $('#logTable').find('tbody');
					logTable.empty()
					let totalPage = isEmpty(result.count) ? Math.ceil(result.data.length / 5) : Math.ceil(result.count / 5);
					collectionMakeNavigation(rids, page, totalPage);

					result.data.forEach(log => {
						let dTimestamp = String(log.created_at).replace(/[^0-9]/g, '').substring(0, 14).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
						let logToolTip = (JSON.stringify(log.cmd_body)).replace(/\"/g, '\'');
						let str = `
									<tr>
										<td>${'${sName}'}</td>
										<td>${'${rName}'}</td>
										<td>-</td>
										<td>${'${dTimestamp}'}</td>
										<td>-</td>
										<td>-</td>
										<td class="ellipsis" title="${'${logToolTip}'}">${'${JSON.stringify(log.cmd_body)}'}</td>
									</tr>
								`;
						logTable.append(str);
					})
				},
				error: function (error) {
					console.error(error);
				}
			})
		} else {
			$.ajax({
				url: apiHost + '/log',
				type: 'get',
				async: false,
				data: {
					rids,
					startTime,
					endTime,
					limit,
					page
				},
				success: function (result) {
					//데이터 세팅
					let logTable = $('#logTable').find('tbody');
					logTable.empty()
					let totalPage = Math.ceil(result.count / 5);
					collectionMakeNavigation(rids, page, totalPage);
					result.logs.forEach(log => {
						let dTimestamp = new Date(log.dTimestamp).format('yyyy-MM-dd HH:mm:ss');
						let dLocaltime = String(log.dLocaltime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
						let logToolTip = (log.log).replace(/\"/g, '\'');
						let str = `
						<tr>
							<td>${'${log.sName}'}</td>
							<td>${'${log.rName}'}</td>
							<td>${'${log.dName}'}</td>
							<td>${'${dTimestamp}'}</td>
							<td>${'${dLocaltime}'}</td>
							<td>${'${log.dOperation}'}</td>
							<td class="ellipsis" title="${'${logToolTip}'}">${'${log.log}'}</td>
						</tr>
					`;
						logTable.append(str);
					})
				},
				error: function (error) {
					console.error(error);
				}
			})
		}
	};

	/**
	 * 테이블 초기화
	 */
	const initTable = () => {
		const rtuName = $('#selectedRTU');
		rtuName.text('RTU').data('rid', '');

		const info = $('#rtuDeviceInfo').find('.data-val');
		const table = $('#detailInfoTable').find('tbody');
		info.eq(0).text('-');
		info.eq(1).addClass('no-val').text('-')
		table.empty();

		const status = $('#deviceStatus').find('.data-val');
		status.eq(0).text('-');
		status.eq(1).text('-');
		status.eq(2).text('-');
		status.eq(3).html('-');

		const logTable = $('#logTable tbody');

		dropDownInit($('#command'));
		dropDownInit($('#commandKey'));
		$('#optionVal').val('');

		logTable.empty();

		// $("#PV_INVERTER")
	}

	//RTU 조회
	const getRtuDataList = function () {
		initTable();

		let siteArray = new Array();
		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => {
				if (check.value !== 'all') {
					siteArray.push(check.value);
				}
			});
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				siteArray.push(checked.value);
			});
		}

		if (siteArray.length > 0) {
			$.ajax({
				url: apiHost + '/config/sites',
				type: 'get',
				async: false,
				data: {
					oid,
					filter: JSON.stringify({'include': [{'relation': 'rtus'}]})
				},
				success: function (sites) {
					const tableData = $('#PV_INVERTER').find('tbody');
					const dateFilter = $('#selectLogByDate');
					tableData.empty();
					let rtuInfo = ``;
					let rtuList = new Array();

					sites.forEach(site => {
						let siteName = site.name;
						if (site['rtus'] && $.inArray(site.sid, siteArray) >= 0) {
							let rtus = site['rtus'];
							rtus.forEach(rtu => {
								rtu['siteName'] = siteName;
								rtuList.push(rtu);
							});
						}
					});

					tableData.data('dataList', rtuList);
					// rtuList = rtuPaging(1);
					let ix = 1;
					rtuList.forEach(rtu => {
						// RTU 통신이상: 가장 최신 RTU 상태 정보 데이터가 1시간이 넘어가는 경우  
						const reqData = {
							startTime: getTime(1, false),
							rids: rtu.rid,
						}
						$.ajax({
							url: apiHost + "/get/status/health",
							type: "post",
							data: JSON.stringify(reqData),
							dataType: 'json',
							contentType: "application/json",
							async: false,
							success: function (rtuStatus) {
								const rtuDate = new Date(rtu.createdAt).format('yyyy-MM-dd'),
									siteName = rtu.siteName,
									serialId = `#${'${rtu.rid}'}`;
								let status = ["error", "<fmt:message key='button.error' />"];
								if (rtuStatus.rtus.length) {
									status = ["normal", "<fmt:message key='button.normal' />"];
									// if ((new Date().getTime() - rtuStatus.rtus[0]['last_timestamp']) <= 3600000) {
									// }
								}

								rtuInfo =
									`	<tr id="${'${rtu.rid}'}" class="${'${status[0]}'}">
											<td>${'${ix}'}</td>
											<td>${'${siteName}'}</td>
											<td>${'${rtu.name}'}</td>
											<td><span class="status-button ${'${status[0]}'}">${'${status[1]}'}</span></td>
											<td>${'${rtu.serialNumber}'}</td>
											<td>${'${rtuDate}'}</td>
										</tr>
									`
								tableData.append(rtuInfo);

								$(serialId)
									.off('click')
									.on('click', () => {
										const rtuName = $('#selectedRTU');
										rtuName.text(rtu.name).data('rid', rtu.rid).data('rName', rtu.name).data('sName', siteName);
										selectLog(rtu.rid);
									});
								// selectedRTU를 가져오기 위해 바깥으로 뺌, 21.3.15. kimby
								/* dateFilter
									.off('click')
									.on('click', () => {
										const datePicker1 = $('#datepicker1').datepicker('getDate');
										const datePicker2 = $('#datepicker2').datepicker('getDate');
										if(datePicker1 != null && datePicker2 != null) {
											const start = datePicker1.format('yyyyMMdd');
											const end = datePicker2.format('yyyyMMdd');
											const startTimepicker = $('#timepicker1').wickedpicker('time').replace(/[^0-9]/g, '');
											const endTimepicker = $('#timepicker2').wickedpicker('time').replace(/[^0-9]/g, '');

											const startDate = start + startTimepicker + '00';
											const endDate = end + endTimepicker + '00';

											selectLog(rtu.rid, startDate, endDate);
										} else {
											alert('<fmt:message key="colState.alert.6" />');
											return false;
										}
									}); */
								
								statusFilter();

								$(".rtu-filter-button").first().html("<fmt:message key='button.normal' /> ("+$("tr.normal").length+")");
								$(".rtu-filter-button").last().html("<fmt:message key='button.error' /> ("+$("tr.error").length+")");
							}
						});
						ix++;
					});
				},
				error: function (error) {
					console.error(error);
				}
			});
		} else {
			const tableData = $('#PV_INVERTER').find('tbody');
			tableData.empty();
		}

		$('.dbTime').text('');
	}

	const rtnDropdown = function ($selectId) {
		if ($selectId == 'selectSiteList') {
			getRtuDataList();
		}
	}

	const showReigister = (data) => {
		//RTU 등록/수정 초기화
		dropDownInit($('#rtuSite'));
		$('#rtuName').val('');
		$('#rtuSecret').val('');
		$('#serialNumber').val('');
		$('#description').val('');
		//RTU 등록/수정 초기화

		if (role === '2') {
			let role = true;
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				if (!isEmpty(checked.dataset.role) && checked.dataset.role === '2') {
					role = false;
				}
			});

			if (!role) {
				alert('선택한 사이트 중 권한이 없는 사이트가 있습니다.');
				return false;
			}
		}

		let siteArray = new Array();
		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => {
				if (check.value !== 'all') {
					siteArray.push({
						sid: check.value,
						name: check.nextElementSibling.textContent.trim()
					});
				}
			});
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				siteArray.push({
					sid: checked.value,
					name: checked.nextElementSibling.textContent.trim()
				});
			});
		}

		if (siteArray.length > 0) {
			dropDownInit($('#rtuSite'));
			setMakeList(siteArray, 'rtuSiteULList', {'dataFunction': {}});
		} else {
			alert('<fmt:message key="colState.alert.7" />');
			return false;
		}

		//수정
		if (!isEmpty(data)) {
			let siteName = '';
			siteList.forEach(el => {
				if (el.sid == data.sid) {
					siteName = el.name;
				}
			});

			$('#rtuSite button').data('value', data.sid).html(siteName + '<span class="caret"></span>');
			$('#rtuName').val(data.name);
			$('#serialNumber').val(data.serialNumber);
			$('#rtuSecret').val(data.rtu_secret);
			$('#description').val(data.description);

			const rid = $('#selectedRTU').data('rid');
			$('#RTU_Register').text('<fmt:message key="colState.modify.title" />');
			$('#addRtuModal .btn-wrap-type02 button').eq(1).attr('onclick', 'registerRtu("patch", "' + rid + '"); return false');
		} else {
			$('#RTU_Register').text('<fmt:message key="colState.register.title" />');
			$('#addRtuModal .btn-wrap-type02 button').eq(1).attr('onclick', 'registerRtu("post"); return false');
		}

		$('#addRtuModal').modal();
	}

	const registerRtu = (type, rid) => {
		let sid = $('#rtuSite button').data('value'),
			name = $('#rtuName').val(),
			serialNumber = $('#serialNumber').val(),
			rtuSecret = $('#rtuSecret').val(),
			description = $('#description').val(),
			ajaxUrl = '',
			typeName = '';

		if (isEmpty(sid)) {
			alert('<fmt:message key="colState.alert.8" />');
			return false;
		}

		if (isEmpty(name)) {
			alert('<fmt:message key="colState.alert.9" />');
			return false;
		}

		if (type == 'post') {
			ajaxUrl = apiHost + '/config/rtus?oid=' + oid + '&sid=' + sid;
			typeName = langStatus === `KO` ? '등록' : `Register`;
		} else {
			ajaxUrl = apiHost + '/config/rtus/' + rid;
			typeName = langStatus === `KO` ? '수정' : `Modify`;
		}


		$.ajax({
			url: ajaxUrl,
			type: type,
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify({
				name: name,
				serialNumber: serialNumber,
				rtu_secret: rtuSecret,
				description: description
			}),
			success: function (data) {
				alert(`RTU ${"${typeName}"}<fmt:message key="colState.alert.10" />`);

				getRtuDataList();
				$('#addRtuModal').modal('hide');
			},
			error: function (error) {
				console.error(error);
				alert(`RTU ${"${typeName}"}<fmt:message key="colState.alert.11" />`);
				return false;
			}
		});
	}

	// const rtuPaging = (page) => {
	// 	const tableData = $('#PV_INVERTER').find('tbody'),
	// 		pagePer = 8;
	// 	let jsonList = tableData.data('dataList'),
	// 		totalCount = jsonList.length;
	// 	let totalPage = Math.ceil(totalCount / pagePer);
	// 	let totalnav = Math.ceil(totalPage / pagePerData);
	// 	const startNum = (pagePer * (page - 1));
	// 	const endNum = ((pagePer * page) >= totalCount) ? totalCount : (pagePer * page);
	// 	jsonList = jsonList.slice(startNum, endNum);

	// 	makeNavigation(page, totalPage);
	// 	return jsonList;
	// };

	const getDataList = (page) => {
		const tableData = $('#PV_INVERTER').find('tbody'),
			dateFilter = $('#selectLogByDate')
			// rtuList = rtuPaging(page);
		tableData.empty();

		let ix = 1;
		rtuList.forEach(rtu => {
			const reqData = {
				startTime: getTime(1, false),
				rids: rtu.rid,
			}
			$.ajax({
				url: apiHost + "/get/status/health",
				type: "post",
				data: JSON.stringify(reqData),
				dataType: 'json',
				contentType: "application/json",
				async: false,
				success: function (rtuStatus) {
					const rtuDate = new Date(rtu.createdAt).format('yyyy-MM-dd'),
						siteName = rtu.siteName,
						serialId = `#${'${rtu.serialNumber}'}`;

					let status = ["error", "<fmt:message key='button.error' />"];
					if (rtuStatus.rtus.length) {
						status = ["normal", "<fmt:message key='button.normal' />"];
						// if ((new Date().getTime() - rtuStatus.rtus[0]['last_timestamp']) <= 3600000) {
						// }
					}

					rtuInfo =
						`	<tr id="${'${rtu.serialNumber}'}" class="${'${status[0]}'}">
								<td>${'${ix}'}</td>
								<td>${'${siteName}'}</td>
								<td>${'${rtu.name}'}</td>
								<td><span class="status-button ${'${status[0]}'}">${'${status[1]}'}</span></td>
								<td>${'${rtu.serialNumber}'}</td>
								<td>${'${rtuDate}'}</td>
							</tr>
						`
					tableData.append(rtuInfo);

					$(serialId)
						.off('click')
						.on('click', () => {
							const rtuName = $('#selectedRTU');
							rtuName.text(rtu.name).data('rid', rtu.rid).data('rName', rtu.name).data('sName', siteName);
							selectLog(rtu.rid);
						});

					dateFilter
						.off('click')
						.on('click', () => {
							const datePicker1 = $('#datepicker1').datepicker('getDate');
							const datePicker2 = $('#datepicker2').datepicker('getDate');
							if(datePicker1 != null && datePicker2 != null) {
								const start = datePicker1.format('yyyyMMdd');
								const end = datePicker2.format('yyyyMMdd');
								const startTimepicker = $('#timepicker1').wickedpicker('time').replace(/[^0-9]/g, '');
								const endTimepicker = $('#timepicker2').wickedpicker('time').replace(/[^0-9]/g, '');

								const startDate = start + startTimepicker + '00';
								const endDate = end + endTimepicker + '00';

								selectLog(rtu.rid, startDate, endDate);
							} else {
								alert('<fmt:message key="colState.alert.6" />');
								return false;
							}
						});

					statusFilter();

					$(".rtu-filter-button").first().html("<fmt:message key='button.normal' /> ("+$("tr.normal").length+")");
					$(".rtu-filter-button").last().html("<fmt:message key='button.error' /> ("+$("tr.error").length+")");
				}
			});
			ix++;
		});
	}

	const collectionMakeNavigation = (rids, page, totalPage) => {
		$('#logPaging').empty();
		let pageStr = '';
		let navgroup = Math.floor((page - 1) / pagePerData) + 1;
		let startPage = ((navgroup - 1)*pagePerData)+1;
		let totalnav = Math.ceil(totalPage / pagePerData);
		let endPage = ((startPage + pagePerData - 1) > totalPage) ? totalPage : (startPage + pagePerData - 1);

		if (navgroup == 1) {
			pageStr += '<a href="javascript:void(0);" class="btn-prev first_prev">prev</a>';
		} else{
			pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + (startPage -1) + '\');" class="btn-prev">prev</a>';
		}

		for (let i = startPage ; i <= endPage; i++) {
			if (i==page) {
				pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + i + '\');"><strong>'+i+'</strong></a>';
			} else {
				pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + i + '\');">'+i+'</a>';
			}
		}

		if (navgroup <totalnav) {
			pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + (endPage +1) + '\');"  class="btn-next">next</a>';
		} else {
			pageStr += '<a href="javascript:void(0);"  class="btn-next larst_next">next</a>';
		}

		$('#logPaging').append(pageStr);
	}

	const commandModal = () => {
		const rid = $('#selectedRTU').data('rid');
		const command = $('#command button').data('value');
		const commandKey = $('#commandKey button').data('value');
		const optionVal = $('#optionVal').val();

		let bodyCommand = new Object();

		if (isEmpty(rid)) {
			alert('<fmt:message key="colState.alert.13" />');
			return false;
		}

		if (isEmpty(command)) {
			alert('<fmt:message key="colState.alert.14" />');
			return false;
		}

		if (isEmpty(optionVal)) {
			alert('<fmt:message key="colState.alert.15" />');
			return false;
		}

		$('#certModal').modal('show');
	}

	const commandSend = () => {
		const rid = $('#selectedRTU').data('rid');
		const command = $('#command button').data('value');
		const commandKey = $('#commandKey button').data('value');
		const optionVal = $('#optionVal').val();

		let bodyCommand = new Object();

		if (isEmpty(rid)) {
			alert('<fmt:message key="colState.alert.16" />');
			return false;
		}

		if (isEmpty(command)) {
			alert('<fmt:message key="colState.alert.17" />');
			return false;
		}

		if (isEmpty(optionVal)) {
			alert('<fmt:message key="colState.alert.18" />');
			return false;
		}

		if (command.match('target')) {
			bodyCommand[commandKey] = Number(optionVal);
		}

		new Promise((resolve, reject) => {
			$.ajax({
				url: apiHost + '/config/users/confirm_password?oid=' + oid,
				type: 'POST',
				dataType: 'json',
				contentType: 'application/json',
				data: JSON.stringify({
					login_id: loginId,
					password: $('#certPass').val()
				})
			}).done(function (result) {
				resolve(result.passed)
			}).fail(function (error) {
				console.log(error);
			});
		}).then(rtnVal => {
			if (rtnVal === true) {
				$.ajax({
					url: apiHost + '/control/send/' + rid + '?cmdType=' + command,
					type: 'POST',
					dataType: 'json',
					contentType: 'application/json',
					data: JSON.stringify(bodyCommand),
					success: function (data) {
						alert('<fmt:message key="colState.alert.19" />');
						$('#certModal').modal('hide');
						return false;
					},
					error: function (error) {
						console.error(error);
						alert('<fmt:message key="colState.alert.20" />');
						$('#certModal').modal('hide');
						return false;
					}
				});
			} else {
				alert('<fmt:message key="colState.alert.21" />');
				$('#certModal').modal('hide');
				return false;
			}
		}).catch(error => {
			alert('<fmt:message key="colState.alert.22" />');
			$('#certModal').modal('hide');
			return false;
		});
	}
</script>