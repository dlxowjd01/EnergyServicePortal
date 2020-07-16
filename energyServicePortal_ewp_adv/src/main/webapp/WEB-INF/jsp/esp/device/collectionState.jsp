<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">수집 현황</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2020-04-23 14:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-12">
		<div class="dropdown fl" id="selectSiteList">
			<button class="btn btn-primary dropdown-toggle w10" type="button" data-toggle="dropdown" data-name="사업소 선택">
				사업소 선택<span class="caret"></span>
			</button>
			<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="siteULList">
				<li data-value="[sid]">
					<a href="javascript:void(0);" tabindex="-1">
						<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
						<label for="site_[INDEX]">[name]</label>
					</a>
				</li>
			</ul>
		</div>
		<a href="javascript:void(0);" class="btn_type02 collect_btn fr" id="excelDown">로그 저장</a>
	</div>
</div>

<div class="modal fade" id="addRtuModal" aria-labelledby="RTU_Register" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content collection_modal_content">
			<div class="modal-header">
				<h4 id="RTU_Register" class="modal-title">RTU 등록</h4>
			</div>
			<div class="modal-body">
				<div class="input-group inline-flex">
					<label for="rtuSite" class="input_label">사이트</label>
					<div class="dropdown" id="rtuSite">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="사업소 선택">
							사업소 선택<span class="caret"></span>
						</button>
						<ul class="dropdown-menu chk_type" id="rtuSiteULList">
							<li data-value="[sid]">
								<a href="javascript:void(0);" tabindex="-1">[name]</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="input-group inline-flex">
					<label for="serialNumber" class="input_label">시리얼 번호</label>
					<input type="text" name="serialNumber" id="serialNumber" class="tx_inp_type text_input">
				</div>
				<div class="input-group inline-flex">
					<label for="rtuName" class="input_label">RTU 이름</label>
					<input type="text" name="rtuName" id="rtuName" class="tx_inp_type text_input">
				</div>
				<div class="input-group inline-flex">
					<label for="description" class="input_label">메모</label>
					<textarea class="textarea" id="description" name="description"></textarea>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="button" class="btn_type" onclick="registerRtu(); return false">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-xl-5 col-lg-6 col-md-6 col-sm-12">
		<div class="indiv collect_box">
			<div class="tbl_top clear">
				<h2 class="ntit fl">RTU</h2>
				<button type="button" class="btn_type fr" id="showRegRtu">등록</button>
			</div>
			<div class="tbl_wrap_type collect_wrap">
				<table class="his_tbl scroll" id="PV_INVERTER">
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
						<td colspan="4">해당 RTU 사이트를 위에서 선택해 주세요.</td>
					</tr>
					</tbody>
				</table>
				<div class="paging_wrap">
					<a href="#;" class="btn_prev">prev</a>
					<strong>1</strong>
					<a href="#;" class="btn_next">next</a>
				</div>
			</div>
		</div>
	</div>
	<div class="col-xl-7 col-lg-6 col-md-6 col-sm-12">
		<div class="indiv collect_box">
			<div class="tbl_top clear">
				<h2 class="ntit fl"><span id="selectedRTU">RTU</span> 상세정보</h2>
				<div class="btn_wrap_type02 fr">
					<button type="button" class="btn_type03 delete_btn">삭제</button>
					<button type="button" class="btn_type modify_btn">수정</button>
				</div>
			</div>
			<div class="row">
				<div class="w-50">
					<h2 class="list_title">기기정보</h2>
					<ul id="rtuDeviceInfo" class="device_list">
						<li>시리얼 번호<span class="data_val"></span></li>
						<li>코드 버전<span class="data_val"></span></li>
					</ul>
				</div>
				<div class="w-50">
					<h2 class="list_title">기기상태</h2>
					<ul id="deviceStatus" class="device_list">
						<li>CPU 사용량<span class="data_val"></span></li>
						<li>메모리 사용량<span class="data_val"></span></li>
						<li>디스크 사용량<span class="data_val"></span></li>
						<li>기기 온도<span class="data_val"></span></li>
					</ul>
				</div>
			</div>

			<div class="tbl_top clear"><h2 class="ntit fl">연결 설비</h2></div>
			<div class="collect_wrap table_scroll">
				<table id="detailInfoTable" class="his_tbl">
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
							<td colspan="6">왼쪽 표에서 조회하고자 하는 RTU를 클릭해 주세요.</td>
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

<div class="row">
	<div class="col-12">
		<div class="indiv collect_box last_box">
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
						</div>
					</div>
					<div class="fl">
						<button type="submit" class="btn_type" id="selectLogByDate">검색</button>
					</div>
				</div>
				<div id="logTableDiv">
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
							<td colspan="7">위의 표에서 조회하고자 사이트 혹은 RTU를 클릭해 주세요.</td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="paging_wrap" id="paging">
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');

	//사업소 정보 받아오기
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const now = new Date();
	const nowLocal = now.format('yyyyMMddHHmmss');
	const beforeHour = new Date(now.getFullYear(), now.getMonth(), now.getDay(), now.getHours() - 1, now.getMinutes(), now.getSeconds()).format("yyyyMMddHHmmss");
	const searchFilter = JSON.stringify({'include': [{'relation': 'rtus'}]});

	$(function () {
		setInitList('siteULList'); //사업소 리스트 초기화
		setInitList('rtuSiteULList');
		siteMakeList(); //사업소 리스트 그리기
		getRtuDataList(); //RTU 데이터리스트

		$('.timepicker').wickedpicker({twentyFour: true});
		$('#datepicker1').datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', new Date()); //데이트 피커 기본
		$('#datepicker2').datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', new Date()); //데이트 피커 기본

		//RTU 등록 페이지
		$('#showRegRtu').on('click', function () {
			showReigister();
		});

		$('.delete_btn').on('click', function () {
			const rid = $('#selectedRTU').data('rid');

			if (isEmpty(rid)) {
				alert('RTU 정보가 확인되지 않습니다.');
				return false;	
			}

			if (!confirm('RTU 정보를 삭제하시겠습니까?')) {
				return false;
			}

			$.ajax({
				url: apiHost + '/config/rtus/' + rid,
				type: 'delete',
				dataType: 'json',
				contentType: 'application/json',
				data: {},
				success: function (data) {
					alert('RTU 삭제에 성공했습니다.');

					getRtuDataList();
				},
				error: function (error) {
					console.error(error);
					alert('RTU 삭제에 실패했습니다. 값을 다시 확인해 주세요.');
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
						header = ['사이트ID','수집 타입 ID','수집기 ID','송신 시간','수신 시간' ,'상태', '수신 데이터']; //csv 파일 헤더

					let logList = result.logs;

					logList.forEach((log, logIdx) => {
						logList[logIdx]['dTimestamp'] = new Date(log.dTimestamp).format('yyyy-MM-dd HH:mm:ss');
						logList[logIdx]['dLocaltime'] = String(log.dLocaltime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
					})

					if(confirm('저장 하시겠습니까?')) {
						getJsonExcelDownload(logList, column, header, '수집현황.xls'); // json list, 컬럼, 헤더명, 파일명
					}
				},
				error: function (error) {
					console.error(error);
				}
			});

		});

		$('.modify_btn').on('click', function () {
			const rid = $('#selectedRTU').data('rid');

			if (isEmpty(rid)) {
				alert('RTU 정보가 확인되지 않습니다.');
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
					alert('RTU 삭제에 실패했습니다. 값을 다시 확인해 주세요.');
					return false;
				}
			});
		});
	})

	//사업소 조회
	function siteMakeList () {
		setMakeList(siteList, 'siteULList', {'dataFunction': {}}); //list생성
	};

	function logPaging (rids, page, totalCount, jsonList ,startTime , endTime) {
		let totalPage = Math.ceil(totalCount/pagePerData);
		let totalnav = Math.ceil(totalPage/navCount);
		let startNum = (pagePerData*(page-1));
		let endNum = ((pagePerData*page)>= totalCount)? totalCount : (pagePerData*page);
		logMakeNavigation(rids, page, totalPage, startTime , endTime);
		return jsonList;
	};

	const logMakeNavigation = (rids, page, totalPage, startTime , endTime) => {
		$('#paging').empty();
		let pageStr = '';
		let navgroup = Math.floor((page-1)/navCount)+1;
		let startPage = ((navgroup-1)*navCount)+1;
		let totalnav = Math.ceil(totalPage/navCount);
		let endPage = ((startPage + navCount-1) > totalPage)? totalPage : (startPage + navCount-1);

		if (navgroup == 1) {
			pageStr += '<a href="javascript:void(0);" class="btn_prev first_prev">prev</a>';
		} else{
			pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + (startPage -1) + '\');" class="btn_prev">prev</a>';
		}

		for (let i = startPage ; i <= endPage; i++) {
			if (i==page) {
				pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + i + '\');"><strong>'+i+'</strong></a>';
			} else {
				pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + i + '\');">'+i+'</a>';
			}
		}

		if (navgroup <totalnav) {
			pageStr += '<a href="javascript:selectLog(\'' + rids + '\',\'\',\'\',\'5\',\'' + (endPage +1) + '\');"  class="btn_next">next</a>';
		} else {
			pageStr += '<a href="javascript:void(0);"  class="btn_next larst_next">next</a>';
		}
		$('#paging').append(pageStr);
	}
	
	function selectLog(rids, startTime, endTime, limit, page) {
		limit = isEmpty(limit) ? 5 : limit;
		page = isEmpty(page) ? 1 : page;

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
				const info = $('#rtuDeviceInfo').find('.data_val');
				const table = $('#detailInfoTable').find('tbody');
				const device = basic.devices;
				info.eq(0).text(result1[0].serialNumber);
				basic.version ? info.eq(1).text(basic.version) : info.eq(1).addClass('no_val').text("-");
				table.empty();

				let str = ``;
				if (!isEmpty(device)) {
					for (let i = 0; i < device.length; i++) {
						let comType = '';
						let baudRate = '';
						let capacity = '';
						let description = '';
						let rtuComm = device[i].rtu_details;

						if (rtuComm) {
							let newJson = JSON.parse(rtuComm);
							comType = newJson["com-type"];
							baudRate = newJson["baud-rate"];
						} else {
							comType = "-";
							baudRate = "-"
						}
						// TO DO!!!! convert with common library!!!!!
						device[i].capacity ? (capacity = device[i].capacity) : (capacity = "-");
						// END
						device[i].description ? (description = device[i].description) : (description = "-");
						str = `
								<tr>
									<td>${'${device[i].device_type}'}</td>
									<td>${'${device[i].name}'}</td>
									<td>${'${comType}'}</td>
									<td>${'${baudRate}'}</td>
									<td>${'${capacity}'}</td>
									<td>${'${description}'}</td>
								</tr>
							`
						table.append(str);
					}
				}
			} else {
				return false;
			}

			if (!isEmpty(result2[0][rids]) && !isEmpty(result2[0][rids].data)) {
				const detail = result2[0][rids].data[0];
				const status = $('#deviceStatus').find('.data_val');
				status.eq(0).text(detail.cpu.toFixed(2) + ' %');
				status.eq(1).text(detail.mem.toFixed(2) + ' %');
				status.eq(2).text(detail.disk.toFixed(2) + ' %');
				status.eq(3).html(`${'${detail.temperature.toFixed(2)}'}&#8451;`);
			} else {
				return false;
			}
		});

		if (isEmpty(startTime)) startTime = beforeHour;
		if (isEmpty(endTime)) endTime = nowLocal;
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
				let str = ``;
				logTable.empty();
				result.logs = logPaging(rids, page, result.count, result.logs ,startTime , endTime);
				result.logs.forEach((log, logIdx) => {
					let dTimestamp = new Date(log.dTimestamp).format('yyyy-MM-dd HH:mm:ss');
					let dLocaltime = String(log.dLocaltime).replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
					str = `
						<tr>
							<td>${'${log.sName}'}</td>
							<td>${'${log.rName}'}</td>
							<td>${'${log.dName}'}</td>
							<td>${'${dTimestamp}'}</td>
							<td>${'${dLocaltime}'}</td>
							<td>${'${log.dOperation}'}</td>
							<td class="ellipsis">${'${log.log}'}</td>
						</tr>
					`;
					logTable.append(str);
				})
			},
			error: function (error) {
				console.error(error);
			}
		})
	};

	/**
	 * 테이블 초기화
	 */
	const initTable = () => {
		const rtuName = $('#selectedRTU');
		rtuName.text('RTU').data('rid', '');

		const info = $('#rtuDeviceInfo').find('.data_val');
		const table = $('#detailInfoTable').find('tbody');
		info.eq(0).text('-');
		info.eq(1).addClass('no_val').text('-')
		table.empty();

		const status = $('#deviceStatus').find('.data_val');
		status.eq(0).text('-');
		status.eq(1).text('-');
		status.eq(2).text('-');
		status.eq(3).html('-');

		const logTable = $('#logTable tbody');
		logTable.empty();
	}

	//RTU 조회
	const getRtuDataList = function () {

		initTable();

		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(function () {
				return $(this).val();
			})
		);
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
					let logList = ``;
					let rtuInfo = ``;
					for (let i = 0; i < sites.length; i++) {
						if (sites[i].rtus && $.inArray(sites[i].sid, siteArray) >= 0) {
							let rtuDate = new Date(sites[i].rtus[0].createdAt).format('yyyy-MM-dd');
							let rtuArr = sites[i].rtus;
							let siteName = sites[i].name;

							if (sites[i].rtus.length > 0) {
								sites[i].rtus.forEach(el => {
									// TO DO!!!!!!!!!!!!! 사이트 당 rtu 가 1개 이상일 경우 nested for loop 으로 처리 예정
									let serialId = `#${'${el.serialNumber}'}`

									rtuInfo =
										`	<tr id="${'${el.serialNumber}'}">
												<td>${'${siteName}'}</td>
												<td>${'${el.name}'}</td>
												<td>${'${el.serialNumber}'}</td>
												<td>${'${rtuDate}'}</td>
											</tr>
										`
									tableData.append(rtuInfo);

									$(serialId).on('click', () => {
										const rtuName = $('#selectedRTU');
										selectLog(el.rid);
										rtuName.text(el.name).data('rid', el.rid);
									});

									dateFilter.on('click', () => {
										const datePicker1 = $('#datepicker1').datepicker('getDate');
										const datePicker2 = $('#datepicker2').datepicker('getDate');
										if(datePicker1 != null && datePicker2 != null) {
											const start = datePicker1.format('yyyyMMdd');
											const end = datePicker2.format('yyyyMMdd');
											const startTimepicker = $('#timepicker1').wickedpicker('time').replace(/[^0-9]/g, '');
											const endTimepicker = $('#timepicker2').wickedpicker('time').replace(/[^0-9]/g, '');

											const startDate = start + startTimepicker + '00';
											const endDate = end + endTimepicker + '00';

											selectLog(el.rid, startDate, endDate);
										} else {
											alert('검색 시작일과 종료일을 확인해 주세요.');
											return false;
										}
									});
								});
							}
						}
					}
				},
				error: function (error) {
					console.error(error);
				}
			});
		} else {
			const tableData = $('#PV_INVERTER').find('tbody');
			tableData.empty();
		}
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
		$('#serialNumber').val('');
		$('#description').val('');
		//RTU 등록/수정 초기화

		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return {
					sid: $(this).val(),
					name: $(this).next('label').text()
				}
			})
		);

		if (siteArray.length > 0) {
			dropDownInit($('#rtuSite'));
			setMakeList(siteArray, 'rtuSiteULList', {'dataFunction': {}});
		} else {
			alert('한 개 이상의 사업소를 선택해 주세요.');
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
			$('#description').val(data.description);

			const rid = $('#selectedRTU').data('rid');
			$('#RTU_Register').text('RTU 수정');
			$('#addRtuModal .btn_wrap_type02 button').eq(1).attr('onclick', 'registerRtu("patch", "' + rid + '"); return false');
		} else {
			$('#RTU_Register').text('RTU 등록');
			$('#addRtuModal .btn_wrap_type02 button').eq(1).attr('onclick', 'registerRtu("post"); return false');
		}

		$('#addRtuModal').modal();
	}

	const registerRtu = (type, rid) => {
		let sid = $('#rtuSite button').data('value'),
			name = $('#rtuName').val(),
			serialNumber = $('#serialNumber').val(),
			description = $('#description').val(),
			ajaxUrl = '';
		typeName = '';

		if (isEmpty(sid)) {
			alert('사업소를 선택해 주세요.');
			return false;
		}

		if (isEmpty(name)) {
			alert('RTU이름을 입력해 주세요.');
			return false;
		}

		if (type == 'post') {
			ajaxUrl = apiHost + '/config/rtus?oid=' + oid + '&sid=' + sid;
			typeName = '등록';
		} else {
			ajaxUrl = apiHost + '/config/rtus/' + rid;
			typeName = '수정';
		}

		$.ajax({
			url: ajaxUrl,
			type: type,
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify({
				name: name,
				serialNumber: serialNumber,
				description: description
			}),
			success: function (data) {
				alert('RTU ' + typeName + '에 성공했습니다.');

				getRtuDataList();
				$('#addRtuModal').modal('hide');
			},
			error: function (error) {
				console.error(error);
				alert('RTU ' + typeName + '에 실패했습니다. 값을 다시 확인해 주세요.');
				return false;
			}
		});
	}
</script>