<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">설비 구성</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-3 col-md-4 col-sm-6">
		<div class="header_drop_area w_type">
			<div class="dropdown" id="siteList">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="사업소 선택">
					사업소 선택<span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk_type" role="menu" id="siteULList">
					<li>
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
							<label for="site_[INDEX]">[name]</label>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="row content-wrapper device_row scroll">
	<div class="col-lg-12" id="deviceStateTypeList">
		<div class="row" id="[typeId]">
			<div class="col-lg-8">
				<div class="indiv clear">
					<div class="chart_top clear">
						<h2 class="ntit fl">[typeName]</h2>
						<div class="eq_icon fr">
							<span class="eq_normal">정상([normail])</span>
							<span class="eq_alert">중지([alert])</span>
							<span class="eq_error">트립([error])</span>
						</div>
					</div>
					<ul class="eq_list scroll [typeClass]" id="[typeId]_List">
						[deviceList]
					</ul>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="indiv eq_card">
					<div class="chart_top clear">
						<h2 class="ntit fl">선택 설비명</h2>
					</div>
					<ul class="eq_card_ul clear">
						[featureHead]
					</ul>
					<div class="inv_sec_bx">
						<p class="inv_tit">선택 설비 현황</p>
						<ul class="isb_in clear">
							<li>
								<ul class="di_list">[featureBody1]</ul>
							</li>
							<li>
								<ul class="di_list">[featureBody2]</ul>
							</li>
						</ul>
					</div>
					<div class="eq_btn_bx">
						<button type="button" class="btn_type04" onclick="alert('선택된 설비가 없습니다.'); return false;">설비 정보 수정</button>
						<button type="button" class="btn_type04" onclick="alert('선택된 설비가 없습니다.'); return false;">운영 이력 조회</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="addDeviceModal" role="dialog">
	<div class="modal-dialog device_modal modal-lg">
		<div class="modal-content new_device">
			<div class="modal-header stit">
				<h2>신규 장치 등록</h2>
			</div>
			<div class="modal-body">
				<form id="deviceForm1" action="#" method="post" name="deviceForm" novalidate>
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex">
								<label for="addSiteList" class="input_label">사업소</label>
								<div class="dropdown" id="addSiteList">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="사업소 선택">
										사업소 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="addSiteUlList">
										<li data-value="[sid]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="name" class="input_label">장치명</label>
								<input class="input tx_inp_type" type="text" name="name" id="name" placeholder="입력" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="device_type" class="input_label">장치 타입</label>
								<div class="dropdown" id="device_type">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="타입 선택">
										타입 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="device_typeList">
										<li data-value="[type]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="metering_type" class="input_label">계량 유형</label>
								<div class="dropdown" id="metering_type">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="유형 선택">
										유형 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-value="0">
											<a href="javascript:void(0);" tabindex="-1">없음</a>
										</li>
										<li data-value="1">
											<a href="javascript:void(0);" tabindex="-1">소모계량</a>
										</li>
										<li data-value="2">
											<a href="javascript:void(0);" tabindex="-1">발전계량</a>
										</li>
										<li data-value="3">
											<a href="javascript:void(0);" tabindex="-1">충/방전계량</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="manufacturer" class="input_label">제조사</label>
								<div class="dropdown" id="manufacturer">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="제조사 선택">
										제조사 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="manufacturerList">
										<li data-value="[manufacturer]">
											<a href="javascript:void(0);" tabindex="-1">[manufacturer]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="capacity" class="input_label">설비 용량(kW)</label>
								<input class="input tx_inp_type" type="text" name="capacity" id="capacity" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="manager" class="input_label">담당자</label>
								<input class="input tx_inp_type" type="text" name="manager" id="manager" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="alarm_code" class="input_label">알림 코드</label>
								<div class="dropdown" id="alarm_code">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="장치 알람 메세지 설정">
										장치 알람 메세지 설정<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk_type" id="alarm_codeList">
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="alarmMsg_[INDEX]" value="[sid]" name="site">
												<label for="alarmMsg_[INDEX]">[name]</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex chk_type">
								<label for="forecasting" class="input_label">예측</label>
								<input type="checkbox" class="input tx_inp_type" id="forecasting" value="1" name="forecasting">
								<label for="forecasting"></label>
							</div>
							<div class="input-group inline-flex">
								<label for="rid" class="input_label">RTU명</label>
								<div id="rid" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="장치 선택">
										장치 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="ridList">
										<li data-value="[rid]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="parent_did" class="input_label">상위 장치</label>
								<div id="parent_did" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="장치 선택">
										장치 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="parent_didList">
										<li data-value="[did]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceDisplayType" class="input_label">표시 유형</label>
								<div id="addDeviceDisplayType" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="유형 선택">
										유형 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk_type">
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="addDeviceDisplayType0" value="dashboard" name="addDeviceDisplayType">
												<label for="addDeviceDisplayType0">대시보드</label>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="addDeviceDisplayType1" value="billing" name="addDeviceDisplayType">
												<label for="addDeviceDisplayType1">매전량</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="product_name" class="input_label">제품명</label>
								<div class="dropdown" id="product_name">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="제조사 선택">
										제품명 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="product_nameList">
										<li data-value="[set_id]">
											<a href="javascript:void(0);" tabindex="-1">[model]_[version]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="serial_id" class="input_label">시리얼 ID</label>
								<input class="input tx_inp_type" type="text" name="serial_id" id="serial_id" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="contact" class="input_label">담당자 연락처</label>
								<input class="input tx_inp_type" type="text" name="contact" id="contact" autocomplete="off">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="description" class="input_label">설명</label>
								<textarea name="addDeviceDescription" id="description" class="textarea"></textarea>
							</div>
						</div>
					</div>
				</form>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="button" class="btn_type" id="addDevice">등록</button>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="manualAddDeviceModal" role="dialog">
	<div class="modal-dialog device_modal">
		<div class="modal-content manual_input">
			<div class="modal-header stit"><h2>수기 입력</h2></div>
			<div class="modal-body">
				<form id="deviceForm2" action="#" method="post" name="deviceForm" novalidate>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="deviceType" class="input_label">구분</label>
								<div id="deviceType" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="solar_opt"><a href="javascript:void(0)">태양광</a></li>
										<li data-value="wind_opt"><a href="javascript:void(0)">풍력</a></li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="timeInterval" class="input_label">입력 단위</label>
								<div id="timeInterval" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="quarterly"><a href="javascript:void(0)">15분</a></li>
										<li data-value="hourly"><a href="javascript:void(0)">1시간</a></li>
										<li data-value="daily"><a href="javascript:void(0)">1일</a></li>
										<li data-value="monthly"><a href="javascript:void(0)">1개월</a></li>
									</ul>
								</div>
							</div>

							<div id="timeStartGroup" class="input-group inline-flex">
								<label for="datepicker1" class="input_label">시작</label>
								<div class="sel_calendar"><input type="text" id="datepicker1" class="sel" value="" autocomplete="off"></div>
								<div class="dropdown hidden">
									<button class="btn btn-primary dropdown-toggle interval" type="button" data-toggle="dropdown"><span class="caret"></span></button>
									<!-- 개발시에 1 ~ 12시 부분 동적으로 처리!!! -->
									<ul class="dropdown-menu">
										<li data-value="hourly" class="on"><a href="#">1시간</a></li>
									</ul>
								</div>
								<div class="dropdown hidden">
									<button class="btn btn-primary dropdown-toggle interval" type="button" data-toggle="dropdown"><span class="caret"></span></button>
									<!-- 개발시에 15, 30, 45 분 동적으로 처리!!! -->
									<ul class="dropdown-menu">
										<li data-value="quarterly" class="on"><a href="#">15분</a></li>
									</ul>
								</div>
							</div>

							<div id="timeEndGroup" class="input-group inline-flex">
								<label for="datepicker2" class="input_label">종료</label>
								<div class="sel_calendar">
									<input type="text" id="datepicker2" class="sel" value="" autocomplete="off"
									       readonly>
								</div>
								<div class="dropdown hidden" id="hour">
									<button class="btn btn-primary dropdown-toggle w3 interval" type="button"
									        data-toggle="dropdown"><span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="" class="on"><a href="#">0시</a></li>
									</ul>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label class="input_label">데이터 확인</label>
								<button class="btn_type03 end">입력 초기화</button>
							</div>
							<div class="spc_tbl mt20">
								<table class="ly_type">
									<thead>
									<th>15분 단위</th>
									<th>데이터 값</th>
									</thead>
									<tbody id="manualModalTable">
									<tr>
										<td>2020-05-01 01:00</td>
										<td>
											<div class="tx_inp_type center edit">
												<input id="dataValue" type="text" name="dataValue" value=""/>
											</div>
										</td>
									</tr>
									<tr>
										<td>2020-05-01 01:15</td>
										<td>
											<div class="tx_inp_type center edit">
												<input id="dataValue" type="text" name="dataValue" value=""/>
											</div>
										</td>
									</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</form>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal">취소</button>
					<button type="submit" class="btn_type" id="registerBtn">저장</button>
				</div>
			</div>
		</div>
	</div>
</div>
<form id="pageMove" name="pageMove" method="post">
	<input type="hidden" id="did" name="did" value="">
</form>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';

	const apiURL = 'http://iderms.enertalk.com:8443';
	const apiDeviceProperties = '/config/view/device_properties';
	const apiStatusRawSite = '/status/raw/site';
	const apiStatusRaw = '/status/raw';
	const apiConfigRtus = '/config/rtus';
	const apiConfigDevices = '/config/devices';
	const apiAlarmCodeSets = '/alarms/code_sets';

	let codeSetList = new Array();

	$(function () {
		deviceProperties();

		setInitList('siteULList'); //사업소 리스트
		siteMakeList();

		setInitList('deviceStateTypeList'); //장비 리스트
	});

	//사업소 조회
	const siteMakeList = () => {
		setMakeList(siteList, 'siteULList', {'dataFunction': {}}); //list생성
	};

	//드롭다운 선택
	const rtnDropdown = ($dropdownId) => {
		if ($dropdownId == 'siteList') {
			getDeviceList();
		} else if ($dropdownId == 'addSiteList') {
			getRtusList();
		} else if ($dropdownId == 'device_type') {
			setParentDevice();
		}
	}

	//설비 속성 템플릿
	const featureProperties = new Object();
	const featurePropertiesSub = new Object();
	const deviceProperties = () => {
		$.ajax({
			url: apiURL + apiDeviceProperties,
			type: 'get',
			dataType: 'json',
			data: {},
		}).done(function (data, textStatus, jqXHR) {
			$.map(data, function (val, key) {
				let deviceName = key;
				let propList = val.properties;
				let tempFeature = new Array();
				let tempFeature2 = new Array();

				$.map(propList, function (v, k) {
					if (v.status_head) {
						let tempObj = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						tempObj['key'] = k;
						tempObj['value'] = v.name.kr;
						tempObj['suffix'] = unit;
						tempObj['reducer'] = v.dashboard_head_reducer;
						tempFeature.push(tempObj);

						featureProperties[deviceName] = {
							name: val.name.kr,
							prop: tempFeature
						};
					}

					if (v.status_detail) {
						let tempObj2 = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						tempObj2['key'] = k;
						tempObj2['value'] = v.name.kr;
						tempObj2['suffix'] = unit;
						tempFeature2.push(tempObj2);

						featurePropertiesSub[deviceName] = {
							name: val.name.kr,
							prop: tempFeature2
						};
					}
				});
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	};

	const getDeviceList = () => {
		let deviceMap = new Object;
		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			})
		);

		if (siteArray.length > 0) {
			let promiseCnt = 0;
			siteArray.forEach(el => {
				return new Promise((resolve, reject) => {
					$.ajax({
						url: apiURL + apiStatusRawSite,
						type: 'get',
						dataType: 'json',
						data: {
							sid: el,
							formId: 'v2'
						}
					}).done(function (data, textStatus, jqXHR) {
						resolve(data);
					}).fail(function (jqXHR, textStatus, errorThrown) {
						console.error(jqXHR);
						console.error(textStatus);
						console.error(errorThrown);

						reject({error: textStatus});
					});
				}).then(data => {
					$.map(data, (val, key) => {
						if (isEmpty(deviceMap[key])) {
							deviceMap[key] = new Array(val);
						} else {
							deviceMap[key] = deviceMap[key].concat(new Array(val));
						}
					});
					promiseCnt++;
				}).catch(error => {
					console.log(error);
					promiseCnt++;
				}).finally(() => {
					if (siteArray.length == promiseCnt) {
						makeDeviceList(deviceMap);
					}
				});
			});
		} else {
			setMakeList(new Array(), 'deviceStateTypeList', {'dataFunction': {}});
		}
	}

	//디바이스 리스트 가공
	//operation 0: 중지, 1: 정상, 2: 트립
	const makeDeviceList = (deviceMap) => {
		let typeList = new Array();
		$.map(deviceMap, (val, key) => {
			if (isEmpty(featureProperties[key])) return false;

			let normail = 0, alert = 0, error = 0, deviceList = $('<div>');
			//배열로 디바이스 상태 수집
			if (!isEmpty(val)) {
				val.forEach(typeEl => {
					if (!isEmpty(typeEl) && !isEmpty(typeEl.devices)) {
						typeEl.devices.forEach(el => {
							let $li = $('<li>'),
								$a = $('<a>'),
								capacity = isEmpty(el.capacity) ? '-' : displayNumberFixedUnit(el.capacity, el.capacity_unit, 'kW', 2)[0] + 'kW',
								activePower = isEmpty(el.activePower) ? '-' : displayNumberFixedUnit(el.activePower, 'W', 'kW', 2)[0] + 'kW',
								dcPower = isEmpty(el.dcPower) ? '-' : displayNumberFixedUnit(el.dcPower, 'W', 'kW', 2)[0] + 'kW';


							$li.data('dvtype', el.device_type).data('did', el.did).attr('onclick', 'deviceDetailView(\'' + el.did + '\')');
							$a.attr('href', 'javascript:void(0);');
							$('<span>').attr('style', 'text-overflow: ellipsis; white-space: nowrap; overflow: hidden;').text(el.dname).appendTo($li);
							$('<span>').text(capacity).appendTo($li);
							$('<em>').text(activePower + '  ' + dcPower).appendTo($li);
							$a.appendTo($li);
							deviceList.append($li);

							switch (el.operation) {
								case 0:
									alert++;
									break;
								case 1:
									normail++;
									break;
								case 2:
									error++;
									break;
								default:
									alert++;
									break;
							}
						});
					}
				});
			}

			let featureHead = '';
			let featureBody1 = '';
			let featureBody2 = '';
			if (!isEmpty(featureProperties[key])) {
				let prop = featureProperties[key].prop;
				prop.forEach(el => {
					featureHead += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><p class="t_ti">' + el.value + '</p><p class="t_value"></p></li>';
				});
			}

			if (!isEmpty(featurePropertiesSub[key])) {
				let prop = featurePropertiesSub[key].prop;
				prop.forEach((el, idx) => {
					if (idx % 2 == 0) {
						featureBody1 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di_li_tit">' + el.value + '</span><span class="di_li_tx"></span></li>';
					} else {
						featureBody2 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di_li_tit">' + el.value + '</span><span class="di_li_tx"></span></li>';
					}
				});
			}

			let $li = $('<li>'),
				$a = $('<a>');
			$a.attr('href', 'javascript:addDeviceForm("' + key + '");');
			$li.addClass('eq_add').append($a);
			deviceList.append($li);

			let typeClass;
			switch (key) {
				case 'INV_PV':
					typeClass = 'eq_li_type01';
					break;
				case 'SENSOR_SOLAR':
					typeClass = 'eq_li_type02';
					break;
				case 'SM_MANUAL':
					typeClass = 'eq_li_type03';
					break;
				case 'SM':
					typeClass = 'eq_li_type03';
					break;
				case 'PCS_ESS':
					typeClass = 'eq_li_type03';
					break;
				case 'BMS_SYS':
					typeClass = 'eq_li_type03';
					break;
				case 'BMS_RACK':
					typeClass = 'eq_li_type03';
					break;
				case 'SENSOR_WEATHER':
					typeClass = 'eq_li_type03';
					break;
				case 'SENSOR_TEMPHUMID':
					typeClass = 'eq_li_type03';
					break;
				case 'SENSOR_FLAME':
					typeClass = 'eq_li_type03';
					break;
				case 'CIRCUIT_BREAKER':
					typeClass = 'eq_li_type03';
					break;
				case 'COMBINER_BOX':
					typeClass = 'eq_li_type03';
					break;
				default:
					typeClass = 'eq_li_type01';
					break;
			}

			typeList.push({
				typeName: featureProperties[key].name,
				typeId: key,
				alert: alert,
				error: error,
				normail: normail,
				deviceList: deviceList.html(),
				featureHead: featureHead,
				featureBody1: featureBody1,
				featureBody2: featureBody2,
				typeClass: typeClass
			});
		});

		typeList.sort((a, b) => {
			return a.typeId < b.typeId ? -1 : a.typeId > b.typeId ? 1 : 0;
		});

		setMakeList(typeList, 'deviceStateTypeList', {'dataFunction': {}});
	}

	const deviceDetailView = (did) => {
		$.ajax({
			url: apiURL + apiStatusRaw,
			type: 'get',
			dataType: 'json',
			data: {
				dids: did
			}
		}).done(function (data, textStatus, jqXHR) {
			let resultData = data[did].data[0],
				dType = data[did].device_type,
				dName = data[did].dname;

			$('#' + dType + ' .eq_card .ntit').text(dName);
			$('#' + dType + ' .eq_card .inv_tit').text(dName + ' 현황');

			$('#' + dType + ' .eq_card .eq_card_ul li').each(function () {
				let liData = $(this).data('key'),
					suffix = $(this).data('suffix');

				if (liData == 'dname') {
					$(this).find('.t_value').text(dName);
				} else {
					let dValue = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
					dValue = dValue[0] != '-' ? dValue.join(' ') : dValue[0];
					$(this).find('.t_value').text(dValue);
				}
			});

			$('#' + dType + ' .eq_card .isb_in .di_list li').each(function () {
				let liData = $(this).data('key'),
					suffix = $(this).data('suffix');

				let dValue = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
				dValue = dValue[0] != '-' ? dValue.join(' ') : dValue[0];
				$(this).find('.di_li_tx').text(dValue);
			});

			$('#' + dType + ' .eq_card .eq_btn_bx button').eq(0).attr('onclick', 'addDeviceForm("' + dType + '", "' + did + '")'); //설비 수정
			$('#' + dType + ' .eq_card .eq_btn_bx button').eq(1).attr('onclick', 'moveOperation("' + did + '");'); //상태이력으로 이동
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	const addDeviceForm = (devicetype, did) => {
		setInitList('addSiteUlList'); //사업소 리스트
		setInitList('device_typeList');
		setInitList('ridList');
		setInitList('parent_didList');
		setInitList('product_nameList');
		setInitList('manufacturerList');

		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return {
					sid: $(this).val(),
					name: $(this).next('label').text()
				}
			})
		);
		setMakeList(siteArray, 'addSiteUlList', {'dataFunction': {}});

		let deviceTypeList = new Array();
		$.map(featureProperties, function (val, key) {
			deviceTypeList.push({
				type: key,
				name: val.name
			});
		});
		setMakeList(deviceTypeList, 'device_typeList', {'dataFunction': {}});



		$('#addDeviceModal').modal('show');
	}

	const costSetList = () => {
		return new Promise((resolve, reject) => {
			$.ajax({
				url: apiURL + apiAlarmCodeSets,
				type: 'get',
				dataType: 'json',
				async: false,
				data: { includeCodes: true }
			}).done(function (data, textStatus, jqXHR) {
				codeSetList = data.data;
				resolve(data.data);
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);
				reject(error);
			});
		});
	}

	const moveOperation = (did) => {
		let pageForm = $('#pageMove');

		pageForm.find('input[name="did"]').val(did);
		pageForm.attr('action', '/history/operationHistory.do').submit();
	}

	const getRtusList = () => {
		const sid = $('#addSiteList button').data('value');

		$.ajax({
			url: apiURL + apiConfigRtus,
			type: 'get',
			dataType: 'json',
			data: {
				oid: oid,
				sid: sid,
				filter: {}
			}
		}).done(function (data, textStatus, jqXHR) {
			setMakeList(data, 'ridList', {'dataFunction': {}});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			setMakeList(new Array(), 'ridList', {'dataFunction': {}});
		});
	}

	const setParentDevice = () => {
		const sid = $('#addSiteList button').data('value');
		const device_type = $('#device_type button').data('value');
		dropDownInit($('#parent_did'));

		let parentDidList = new Array();

		if (device_type == 'BMS_SYS' || device_type == 'BMS_RACK') {
			$.ajax({
				url: apiURL + apiConfigDevices,
				type: 'get',
				dataType: 'json',
				data: {
					oid: oid,
					sid: sid,
					filter: {}
				}
			}).done(function (data, textStatus, jqXHR) {
				data.forEach(el => {
					if (device_type == 'BMS_SYS' && el.device_type == 'PCS_ESS') {
						parentDidList.push({
							did: el.did,
							name: el.name
						});
					} else if (device_type == 'BMS_RACK' && el.device_type == 'BMS_SYS') {
						parentDidList.push({
							did: el.did,
							name: el.name
						});
					}
				});

				setMakeList(parentDidList, 'parent_didList', {'dataFunction': {}});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				setMakeList(parentDidList, 'parent_didList', {'dataFunction': {}});
			});
		} else {
			setMakeList(parentDidList, 'parent_didList', {'dataFunction': {}});
		}
	}
</script>
