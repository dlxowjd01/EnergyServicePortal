<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
			<button class="btn btn-primary dropdown-toggle w10" type="button" data-toggle="dropdown" data-name="선택해주세요.">선택해주세요.<span class="caret"></span></button>
			<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="siteULList">
				<li data-value="[sid]">
					<a href="javascript:void(0);" tabindex="-1">
						<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
						<label for="site_[INDEX]"><span></span>[name]</label>
					</a>
				</li>
			</ul>
		</div>
		<a href="#" class="btn_type02 collect_btn fr">로그 저장</a>
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
					<label for="siteName" class="input_label">사이트</label>
					<div id="siteName" class="dropdown">
						<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택해주세요.<span class="caret"></span></button>
						<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
					</div>
				</div>
				<div class="input-group inline-flex">
					<label for="siteName" class="input_label">시리얼 번호</label>
					<input type="text" name="serialNum" id="serialNum" class="tx_inp_type text_input">
				</div>
				<div class="input-group inline-flex">
					<label for="siteName" class="input_label">RTU 이름</label>
					<input type="text" name="rtuName" id="rtuName" class="tx_inp_type text_input">
				</div>
				<div class="input-group inline-flex">
					<label for="siteName" class="input_label">메모</label>
					<textarea class="textarea"></textarea>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="submit" class="btn_type">확인</button>
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
				<button type="button" class="btn_type fr" data-toggle="modal" data-target="#addRtuModal">등록</button>
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
						<tr><td colspan="6">왼쪽 표에서 조회하고자 하는 RTU를 클릭해 주세요.</td></tr>
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
							<input type="text" id="timepicker1" name="timepicker1" class="sel timepicker" />
							<em></em>
							<input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
							<em></em>
							<input type="text" id="timepicker2" name="timepicker2" class="sel timepicker" />
							<script>
								$('.timepicker').wickedpicker({ twentyFour: true });
								$('#datepicker1').datepicker({ dateFormat: 'yy-mm-dd' }).datepicker("setDate", new Date()); //데이트 피커 기본
								$('#datepicker2').datepicker({ dateFormat: 'yy-mm-dd' }).datepicker("setDate", new Date()); //데이트 피커 기본
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
							<td colspan="7">위의 표에서 조회하고자 사이트 혹은 RTU를 클릭해 주세요.</td>
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
</div>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');

	//사업소 정보 받아오기
	const oid = "spower";
	const now = new Date();
	const nowLocal = now.format("yyyyMMddhhmmss");
	const beforeHour = new Date(now.getFullYear(), now.getMonth(), now.getDay(), now.getHours() - 1, now.getMinutes(), now.getSeconds()).format("yyyyMMddhhmmss");
	const searchFilter = JSON.stringify({ "include": [{ "relation": "rtus" }] });

	$(function () {
		setInitList('siteULList'); //사업소 리스트 초기화
		siteMakeList(); //사업소 리스트 그리기
		getRtuDataList(); //RTU 데이터리스트
	})

	//사업소 조회
	const siteMakeList = () => {
		setMakeList(siteList, 'siteULList', {'dataFunction': {}}); //list생성
	};

	function selectLog(rids, startTime, endTime, limit = 5, page = 1) {
		const now = new Date();
		const nowLocal = now.format("yyyyMMddhhmmss");
		const beforeHour = new Date(now.getFullYear(), now.getMonth(), now.getDay(), now.getHours() - 1, now.getMinutes(), now.getSeconds()).format("yyyyMMddhhmmss");
		// START: rtu Detail info setting
		const rtuInfo = [
			{
				url: 'http://iderms.enertalk.com:8443/config/rtus/'+rids,
				type: 'get',
				dataType: 'json',
				data: {
					includeDevices: true
				}
			},
			{
				url: 'http://iderms.enertalk.com:8443/status/raw',
				type: 'get',
				dataType: 'json',
				data: {
					dids: rids,
					isRtu: true
				}
			}
		];
		// END

		$.when($.ajax(rtuInfo[0]), $.ajax(rtuInfo[1])).done(function(result1, result2){
			if(result1[0]) {
				const basic = result1[0];
				const info = $("#rtuDeviceInfo").find(".data_val");
				const table = $("#detailInfoTable").find("tbody");
				const device = basic.devices;
				info.eq(0).text(result1[0].serialNumber);
				basic.version ? info.eq(1).text(basic.version) : info.eq(1).addClass("no_val").text("-");
				table.empty();

				let str = ``;
				console.log("device--", device)
				for(let i=0; i<device.length; i++){
					let comType = '';
					let baudRate = '';
					let capacity = '';
					let description = '';
					let rtuComm = device[i].rtu_details;

					if(rtuComm) {
						let newJson = JSON.parse(rtuComm);
						comType = newJson["com-type"];
						baudRate = newJson["baud-rate"];
					} else {
						comType = "-";
						baudRate = "-"
					}
					// TO DO!!!! convert with common library!!!!!
					device[i].capacity ? ( capacity = device[i].capacity ): ( capacity = "-" );
					// END
					device[i].description ? ( description = device[i].description ): ( description = "-" );
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
			} else {
				return false;
			}

			if(result2[0][rids]) {
				const detail = result2[0][rids].data[0];
				const status = $("#deviceStatus").find(".data_val");
				status.eq(0).text(detail.cpu.toFixed(2)+" %");
				status.eq(1).text(detail.mem.toFixed(2)+" %");
				status.eq(2).text(detail.disk.toFixed(2)+" %");
				status.eq(3).html(`${'${detail.temperature.toFixed(2)}'}&#8451;`);
			} else {
				return false;
			}

		});

		if (startTime === undefined) startTime = beforeHour;
		if (endTime === undefined) endTime = nowLocal;
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
			success: function (result) {
				//데이터 세팅
				let logTable = $("#logTable").find("tbody");
				let str = ``;
				logTable.empty();
				result.logs.forEach((log, logIdx) => {
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
			error: function (error) {
				console.error(error);
			}
		})

	};

	//RTU 조회
	const getRtuDataList = function () {
		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(function () {
				return $(this).val();
			})
		);
		if (siteArray.length > 0) {
			$.ajax({
				url: "http://iderms.enertalk.com:8443/config/sites",
				type: "get",
				async: false,
				data: {
					oid,
					filter: JSON.stringify({ "include": [{ "relation": "rtus" }] })
				},
				success: function (sites) {
					const tableData = $('#PV_INVERTER').find("tbody");
					const dateFilter = $('#selectLogByDate');
					tableData.empty();
					let logList = ``;
					let rtuInfo = ``;
					for (let i = 0; i < sites.length; i++) {
						if(sites[i].rtus && $.inArray(sites[i].sid, siteArray) >= 0) {
							let rtuDate = new Date(sites[i].rtus[0].createdAt).format("yyyy-MM-dd");
							let rtuArr = sites[i].rtus;

							if (sites[i].rtus.length > 1) {
								// TO DO!!!!!!!!!!!!! 사이트 당 rtu 가 1개 이상일 경우 nested for loop 으로 처리 예정
							} else if (sites[i].rtus.length > 0 && sites[i].rtus.length === 1) {
								let serialId = `#${'${sites[i].rtus[0].serialNumber}'}`

								rtuInfo =
									`	<tr id="${'${sites[i].rtus[0].serialNumber}'}">
										<td>${'${sites[i].name}'}</td>
										<td>${'${sites[i].rtus[0].name}'}</td>
										<td>${'${sites[i].rtus[0].serialNumber}'}</td>
										<td>${'${rtuDate}'}</td>
									</tr>
								`
								tableData.append(rtuInfo);

								$(serialId).on('click', () => {
									const rtuName = $("#selectedRTU");
									selectLog(sites[i].rtus[0].rid);
									rtuName.text(sites[i].rtus[0].name);
								});

								dateFilter.on('click', () => {
									const datePicker1 = $('#datepicker1');
									const datePicker2 = $('#datepicker2');
									let start_yy = datePicker1.val().slice(0, 4);
									let start_mm = Number(datePicker1.val().slice(5, 7)) - 1;
									let start_dd = datePicker1.val().slice(8, 10);
									let start_hr = datePicker1.val().slice(0, 2);
									let start_min = datePicker1.val().slice(5, 7);

									let end_yy = datePicker2.val().slice(0, 4);
									let end_mm = Number(datePicker2.val().slice(5, 7)) - 1;
									let end_dd = datePicker2.val().slice(8, 10);
									let end_hr = datePicker2.val().slice(0, 2);
									let end_min = datePicker2.val().slice(5, 7);

									const start = new Date(start_yy, start_mm, start_dd, start_hr, start_min, 0).format("yyyyMMddhhmmss");
									const end = new Date(end_yy, end_mm, end_dd, end_hr, end_min, 0).format("yyyyMMddhhmmss");

									selectLog(sites[i].rtus[0].rid, start, end);
								});
							}
						}
					}

				},
				error: function (error) {
					console.error(error);
				}
			});
		}
	}

	const rtnDropdown = function ($selectId) {
		if ($selectId == 'selectSiteList') {
			getRtuDataList();
		}
	}
</script>