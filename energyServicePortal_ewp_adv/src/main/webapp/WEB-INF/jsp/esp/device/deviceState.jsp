<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">설비 구성</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime"></em>
			<span>DATA BASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-3 col-md-4 col-sm-6">
		<div class="dropdown-wrapper w-60">
			<div class="dropdown" id="siteList">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="사업소 선택">
					사업소 선택<span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk-type" role="menu" id="siteULList">
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
<div class="row content-wrapper device-row">
	<div class="col-lg-12 hidden" id="noDevice">
		<div class="row">
			<div class="col-lg-12">
				<div class="indiv clear">
					<div class="chart-top clear">
						<h2 class="ntit fl">설비 추가</h2>
					</div>
					<ul class="device-list">
						<li class="equip-add">
							<a href="javascript:addDeviceForm('');"></a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<div class="col-lg-12 hide-no-data" id="deviceStateTypeList">
		<div class="row" id="[typeId]">
			<div class="col-lg-8">
				<div class="indiv clear">
					<div class="chart-top clear">
						<h2 class="ntit fl">[typeName]</h2>
						<div class="equip-icon fr">
							<span class="equip-normal">정상([normal])</span>
							<span class="equip-alert">중지([alert])</span>
							<span class="equip-error">트립([error])</span>
						</div>
					</div>
					<ul class="device-list [typeClass]" id="[typeId]_List">
						[deviceList]
					</ul>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="indiv equip-card hidden">
					<div class="chart-top clear">
						<h2 class="ntit fl"></h2>
					</div>
					<ul class="equip-card-ul clear">
						[featureHead]
					</ul>
					<div class="inv-search-box">
						<p class="inv-title"></p>
						<ul class="isb-in clear">
							<li>
								<ul class="di-list">[featureBody1]</ul>
							</li>
							<li>
								<ul class="di-list">[featureBody2]</ul>
							</li>
						</ul>
					</div>
					<div class="eq-btn-box">
						<button type="button" class="btn-type04" onclick="alert('선택된 설비가 없습니다.'); return false;">설비 정보 수정</button>
						<button type="button" class="btn-type04" onclick="alert('선택된 설비가 없습니다.'); return false;">운영 이력 조회</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="addDeviceModal" role="dialog">
	<div class="modal-dialog device-modal modal-lg">
		<div class="modal-content new_device">
			<div class="modal-header">설비 정보 수정</div>
			<div class="modal-body">
				<form id="deviceForm1" action="#" method="post" name="deviceForm" novalidate>
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex">
								<label for="addSiteList" class="input-label">사업소</label>
								<div class="dropdown" id="addSiteList">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="사업소 선택">
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
								<label for="name" class="input-label">장치명</label>
								<input class="input text-input-type" type="text" name="name" id="name" placeholder="입력" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="device_type" class="input-label">장치 타입</label>
								<div class="dropdown" id="device_type">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="타입 선택">
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
								<label for="metering_type" class="input-label">계량 유형</label>
								<div class="dropdown" id="metering_type">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="유형 선택">
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
								<label for="manufacturer" class="input-label">제조사</label>
								<input type="text" id="manufacturer" name="manufacturer" class="input text-input-type" placeholder="제조사" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="capacity" class="input-label">설비 용량(kW)</label>
								<input class="input text-input-type" type="text" name="capacity" id="capacity" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="manager" class="input-label">담당자</label>
								<input class="input text-input-type" type="text" name="manager" id="manager" autocomplete="off">
							</div>
						</div>
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex chk-type">
								<label for="forecasting" class="input-label">예측</label>
								<input type="checkbox" class="input text-input-type" id="forecasting" value="true" name="forecasting">
								<label for="forecasting"></label>
							</div>
							<div class="input-group inline-flex">
								<label for="rid" class="input-label">RTU명</label>
								<div id="rid" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="장치 선택">
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
								<label for="parent_did" class="input-label">상위 장치</label>
								<div id="parent_did" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="장치 선택">
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
								<label for="addDeviceDisplayType" class="input-label">표시 유형</label>
								<div id="addDeviceDisplayType" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="유형 선택">
										유형 선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk-type">
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="dashboard" value="true" name="dashboard">
												<label for="dashboard">대시보드</label>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="billing" value="true" name="billing">
												<label for="billing">매전량</label>
											</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="product_name" class="input-label">제품명</label>
								<input type="text" id="product_name" name="product_name" class="input text-input-type" value="" placeholder="제품명" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="serial_id" class="input-label">시리얼 ID</label>
								<input class="input text-input-type" type="text" name="serial_id" id="serial_id" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="contact" class="input-label">담당자 연락처</label>
								<input class="input text-input-type" type="text" name="contact" id="contact" autocomplete="off">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="alarm_code" class="input-label">알림 코드</label>
								<div class="dropdown-wrapper w-80">
									<div class="dropdown" id="alarm_code">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="장치 알람 메세지 설정">
											장치 알람 메세지 설정<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk-type" id="alarm_codeList">
											<li data-value="[val]">
												<a href="javascript:void(0);" tabindex="-1">[name]</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="description" class="input-label">설명</label>
								<textarea name="addDeviceDescription" id="description" class="textarea"></textarea>
							</div>
						</div>
					</div>
				</form>
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="button" class="btn-type" id="addDevice">등록</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="manualAddDeviceModal" role="dialog">
	<div class="modal-dialog device-modal">
		<div class="modal-content manual_input">
			<div class="modal-header">수기 입력</div>
			<div class="modal-body">
				<form id="deviceForm2" action="#" method="post" name="deviceForm" novalidate>
					<div class="row">
						<div class="col-12 dateField">
							<div class="input-group inline-flex">
								<label for="deviceType" class="input-label">구분</label>
								<div id="deviceType" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="solar_opt">
											<a href="javascript:void(0)">태양광</a>
										</li>
										<li data-value="wind_opt">
											<a href="javascript:void(0)">풍력</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="timeInterval" class="input-label">입력 단위</label>
								<div id="timeInterval" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="15min"><a href="javascript:void(0)">15분</a></li>
										<li data-value="hour"><a href="javascript:void(0)">1시간</a></li>
										<li data-value="day"><a href="javascript:void(0)">1일</a></li>
										<li data-value="month"><a href="javascript:void(0)">1개월</a></li>
									</ul>
								</div>
							</div>

							<div id="timeStartGroup" class="input-group inline-flex">
								<label for="start" class="input-label">시작</label>
								<div class="sel-calendar">
									<input type="text" id="start" name="start" class="sel customFromDate" value="" autocomplete="off" readonly>
								</div>
<%--								<div class="dropdown hidden" id="startHour">--%>
<%--									<button type="button" class="dropdown-toggle interval" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>--%>
<%--									<ul class="dropdown-menu">--%>
<%--										<li data-value="0"><a href="javascript:void(0);">0시</a></li>--%>
<%--										<li data-value="1"><a href="javascript:void(0);">1시</a></li>--%>
<%--										<li data-value="2"><a href="javascript:void(0);">2시</a></li>--%>
<%--										<li data-value="3"><a href="javascript:void(0);">3시</a></li>--%>
<%--										<li data-value="4"><a href="javascript:void(0);">4시</a></li>--%>
<%--										<li data-value="5"><a href="javascript:void(0);">5시</a></li>--%>
<%--										<li data-value="6"><a href="javascript:void(0);">6시</a></li>--%>
<%--										<li data-value="7"><a href="javascript:void(0);">7시</a></li>--%>
<%--										<li data-value="8"><a href="javascript:void(0);">8시</a></li>--%>
<%--										<li data-value="9"><a href="javascript:void(0);">9시</a></li>--%>
<%--										<li data-value="10"><a href="javascript:void(0);">10시</a></li>--%>
<%--										<li data-value="11"><a href="javascript:void(0);">11시</a></li>--%>
<%--										<li data-value="12"><a href="javascript:void(0);">12시</a></li>--%>
<%--										<li data-value="13"><a href="javascript:void(0);">13시</a></li>--%>
<%--										<li data-value="14"><a href="javascript:void(0);">14시</a></li>--%>
<%--										<li data-value="15"><a href="javascript:void(0);">15시</a></li>--%>
<%--										<li data-value="16"><a href="javascript:void(0);">16시</a></li>--%>
<%--										<li data-value="17"><a href="javascript:void(0);">17시</a></li>--%>
<%--										<li data-value="18"><a href="javascript:void(0);">18시</a></li>--%>
<%--										<li data-value="19"><a href="javascript:void(0);">19시</a></li>--%>
<%--										<li data-value="20"><a href="javascript:void(0);">20시</a></li>--%>
<%--										<li data-value="21"><a href="javascript:void(0);">22시</a></li>--%>
<%--										<li data-value="22"><a href="javascript:void(0);">23시</a></li>--%>
<%--										<li data-value="23"><a href="javascript:void(0);">21시</a></li>--%>
<%--									</ul>--%>
<%--								</div>--%>
<%--								<div class="dropdown hidden" id="startMin">--%>
<%--									<button type="button" class="dropdown-toggle interval" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>--%>
<%--									<ul class="dropdown-menu">--%>
<%--										<li data-value="0"><a href="javascript:void(0);">15분</a></li>--%>
<%--										<li data-value="15"><a href="javascript:void(0);">15분</a></li>--%>
<%--										<li data-value="30"><a href="javascript:void(0);">15분</a></li>--%>
<%--										<li data-value="45"><a href="javascript:void(0);">15분</a></li>--%>
<%--									</ul>--%>
<%--								</div>--%>
							</div>

							<div id="timeEndGroup" class="input-group inline-flex">
								<label for="end" class="input-label">종료</label>
								<div class="sel-calendar">
									<input type="text" id="end" name="end"class="sel customToDate" value="" autocomplete="off" readonly>
								</div>
<%--								<div class="dropdown hidden" id="endHour">--%>
<%--									<button type="button" class="dropdown-toggle interval" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>--%>
<%--									<ul class="dropdown-menu">--%>
<%--										<li data-value="0"><a href="javascript:void(0);">0시</a></li>--%>
<%--										<li data-value="1"><a href="javascript:void(0);">1시</a></li>--%>
<%--										<li data-value="2"><a href="javascript:void(0);">2시</a></li>--%>
<%--										<li data-value="3"><a href="javascript:void(0);">3시</a></li>--%>
<%--										<li data-value="4"><a href="javascript:void(0);">4시</a></li>--%>
<%--										<li data-value="5"><a href="javascript:void(0);">5시</a></li>--%>
<%--										<li data-value="6"><a href="javascript:void(0);">6시</a></li>--%>
<%--										<li data-value="7"><a href="javascript:void(0);">7시</a></li>--%>
<%--										<li data-value="8"><a href="javascript:void(0);">8시</a></li>--%>
<%--										<li data-value="9"><a href="javascript:void(0);">9시</a></li>--%>
<%--										<li data-value="10"><a href="javascript:void(0);">10시</a></li>--%>
<%--										<li data-value="11"><a href="javascript:void(0);">11시</a></li>--%>
<%--										<li data-value="12"><a href="javascript:void(0);">12시</a></li>--%>
<%--										<li data-value="13"><a href="javascript:void(0);">13시</a></li>--%>
<%--										<li data-value="14"><a href="javascript:void(0);">14시</a></li>--%>
<%--										<li data-value="15"><a href="javascript:void(0);">15시</a></li>--%>
<%--										<li data-value="16"><a href="javascript:void(0);">16시</a></li>--%>
<%--										<li data-value="17"><a href="javascript:void(0);">17시</a></li>--%>
<%--										<li data-value="18"><a href="javascript:void(0);">18시</a></li>--%>
<%--										<li data-value="19"><a href="javascript:void(0);">19시</a></li>--%>
<%--										<li data-value="20"><a href="javascript:void(0);">20시</a></li>--%>
<%--										<li data-value="21"><a href="javascript:void(0);">22시</a></li>--%>
<%--										<li data-value="22"><a href="javascript:void(0);">23시</a></li>--%>
<%--										<li data-value="23"><a href="javascript:void(0);">21시</a></li>--%>
<%--									</ul>--%>
<%--								</div>--%>
<%--								<div class="dropdown hidden" id="endMin">--%>
<%--									<button type="button" class="dropdown-toggle interval" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>--%>
<%--									<ul class="dropdown-menu">--%>
<%--										<li data-value="0"><a href="javascript:void(0);">15분</a></li>--%>
<%--										<li data-value="15"><a href="javascript:void(0);">15분</a></li>--%>
<%--										<li data-value="30"><a href="javascript:void(0);">15분</a></li>--%>
<%--										<li data-value="45"><a href="javascript:void(0);">15분</a></li>--%>
<%--									</ul>--%>
<%--								</div>--%>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label class="input-label">
									<a href="javascript:void(0);" onclick="setManualForm();">
										데이터 확인
									</a>
								</label>
								<button type="button" class="btn-type03 end" onclick="initManualForm();">입력 초기화</button>
							</div>
							<div class="spc-tbl mt20">
								<table class="ly-type">
									<thead>
									<th>15분 단위</th>
									<th>데이터 값</th>
									</thead>
									<tbody id="manualModalTable">
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</form>
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" data-dismiss="modal">취소</button>
					<button type="button" class="btn-type" onclick="saveManualForm();">저장</button>
				</div>
			</div>
		</div>
	</div>
</div>
<form id="pageMove" name="pageMove" method="post">
	<input type="hidden" id="did" name="did" value="">
</form>
<script type="text/javascript">
	const siteList = JSON.parse('${siteList}');
	const apiDeviceProperties = '/config/view/device_properties';
	const apiStatusRawSite = '/status/raw/site';
	const apiStatusRaw = '/status/raw';
	const apiConfigRtus = '/config/rtus';
	const apiConfigDevices = '/config/devices';
	const apiAlarmCodeSets = '/alarms/code_sets';
	const apiEnergyManual = '/energy/manual/input';
	const apiEnergyDevices = '/energy/devices';

	let codeSetList = new Array();

	$(function () {
		deviceProperties();

		setInitList('siteULList'); //사업소 리스트
		siteMakeList();

		setInitList('deviceStateTypeList'); //장비 리스트

		setInitList('addSiteUlList'); //사업소 리스트
		setInitList('device_typeList');
		setInitList('ridList');
		setInitList('parent_didList');
		setInitList('alarm_codeList');

		$('.customFromDate').datepicker({
			showOn: 'both',
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function(selectedDate) {
				$(this).closest('.dateField').find('.customToDate').datepicker('option', 'minDate', selectedDate);

				if (typeof afterDatePick == 'function') {
					afterDatePick($(this).attr('name'));
				}
			}
		});

		$('.customToDate').datepicker({
			showOn: 'both',
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			onClose: function(selectedDate) {
				$(this).closest('.dateField').find('.customFromDate').datepicker('option', 'maxDate', selectedDate);

				if (typeof afterDatePick == 'function') {
					afterDatePick($(this).attr('name'));
				}
			}
		});
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
			costSetList();
		} else if ($dropdownId == 'timeInterval') {
			let std = $('#timeInterval button').data('value');

			if (std == '15min') {
				$('#startHour').removeClass('hidden');
				$('#startMin').removeClass('hidden');
				$('#endHour').removeClass('hidden');
				$('#endMin').removeClass('hidden');
			} else {
				$('#startHour').addClass('hidden');
				$('#startMin').addClass('hidden');
				$('#endHour').addClass('hidden');
				$('#endMin').addClass('hidden');
			}
		}
	}

	//설비 속성 템플릿
	const featureProperties = new Object();
	const deviceProperties = () => {
		$.ajax({
			url: apiHost + apiDeviceProperties,
			type: 'get',
			dataType: 'json',
			data: {},
		}).done(function (data, textStatus, jqXHR) {
			$.map(data, function (val, key) {
				let deviceName = key;
				let propList = val.properties;
				let tempFeature = new Array();
				let tempFeature2 = new Array();
				let devicePropName = (langStatus == 'KO') ? val.name.kr : val.name.en;

				featureProperties[key] = {
					name: devicePropName,
					headerProp: null,
					bodyProp: null
				}

				$.map(propList, function (v, k) {
					if (v.status_head) {
						let tempObj = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;
						tempObj['key'] = k;
						tempObj['value'] = propName;
						tempObj['suffix'] = unit;
						tempObj['reducer'] = v.dashboard_head_reducer;
						tempFeature.push(tempObj);

						featureProperties[deviceName]['headerProp'] = tempFeature;
					}

					if (v.status_detail) {
						let tempObj2 = new Object();
						let unit = (v.unit != null && v.unit != '') ? '' + v.unit + '' : '';
						let propName = (langStatus == 'KO') ? v.name.kr : v.name.en;
						tempObj2['key'] = k;
						tempObj2['value'] = propName;
						tempObj2['suffix'] = unit;
						tempFeature2.push(tempObj2);

						featureProperties[deviceName]['bodyProp'] = tempFeature2;
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
				const getDevice = {
					url: apiHost + apiConfigDevices,
					type: 'get',
					dataType: 'json',
					data: {
						sid: el,
						formId: 'v2'
					}
				};

				const rawSiteDevice = {
					url: apiHost + apiStatusRawSite,
					type: 'get',
					dataType: 'json',
					data: {
						sid: el,
						formId: 'v2'
					}
				};

				$.when($.ajax(getDevice), $.ajax(rawSiteDevice))
				.done(function (getDeviceData, rawSiteDeviceData) {
					if (getDeviceData[1] == 'success') {
						const devcieArray = getDeviceData[0];
						devcieArray.forEach(function(el) {
							// console.log("el--", el)
							if (isEmpty(deviceMap[el.device_type])) {
								deviceMap[el.device_type] = new Array(el);
							} else {
								deviceMap[el.device_type] = deviceMap[el.device_type].concat(new Array(el));
							}
						});

						if (rawSiteDeviceData[1] == 'success') {
							const rawDevice = rawSiteDeviceData[0];
							$.map(rawDevice, (val, key) => {
								if (isEmpty(deviceMap[key])) {
									deviceMap[key] = new Array(val);
								} else {
									deviceMap[key].forEach(function(el, index) {
										if (!isEmpty(val.devices)) {
											val.devices.forEach(function(element) {
												if(el.did == element.did) {
													const mergeObj = $.extend({}, el, element);
													console.log("el==", el, "elemne===", element)
													deviceMap[key][index] = mergeObj;
														if(el.sid == element.did) {
														}
												}
											});
										}
									});
									deviceMap[key].sort(function(a, b){
										if(a.sid == b.sid){
											if(a["dname"] < b["dname"]){
												return -1;
											} else if(a["dname"] > b["dname"]){
												return 1;
											}
											return 0;
										}
									});
								}
							});
						}
					}
				}).fail(function (jqXHR, textStatus, errorThrown) {
					console.error(jqXHR);
					console.error(textStatus);
					console.error(errorThrown);

					alert('처리 중 오류가 발생했습니다.');
					return false;
				}).always(function(jqXHR, textStatus) {
					promiseCnt++;
					if (siteArray.length == promiseCnt) {
						makeDeviceList(deviceMap);
					}
				});
			});
		} else {
			$('#noDevice').addClass('hidden');
			setMakeList(new Array(), 'deviceStateTypeList', {'dataFunction': {}});
		}
	}

	//디바이스 리스트 가공
	//operation 0: 중지, 1: 정상, 2: 트립
	const makeDeviceList = (deviceMap) => {
		let typeList = new Array();
		if (isEmpty(deviceMap)) {
			$('#noDevice').removeClass('hidden');
		} else {
			$('#noDevice').addClass('hidden');
			$.map(deviceMap, (val, key) => {
				let normal = 0, alert = 0, error = 0, deviceList = $('<div>'), operation = '';
				//배열로 디바이스 상태 수집
				if (!isEmpty(val)) {
					val.forEach((el, index) => {
						let capacity = isEmpty(el.capacity) ? '-' : displayNumberFixedUnit(el.capacity, el.capacity_unit, 'kW', 2)[0] + 'kW',
							activePower = isEmpty(el.activePower) ? '-' : displayNumberFixedUnit(el.activePower, 'W', 'kW', 2)[0] + 'kW',
							dcPower = isEmpty(el.dcPower) ? '-' : displayNumberFixedUnit(el.dcPower, 'W', 'kW', 2)[0] + 'kW',
							operation = el.operation;

						switch (el.operation) {
							case 0:
								alert++;
								operation = 'alert text-black';
								break;
							case 1:
								normal++;
								operation = 'normal text-black';
								break;
							case 2:
								error++;
								operation = 'error text-black';
								break;
							default:
								// alert++;
								operation = '';
								break;
						}

						let deviceStr = `<li class="${'${operation}'}" onclick="deviceDetailView('${'${el.did}'}', '${'${el.operation}'}', $(this) )">
										<span>${'${el.name}'}</span>
										<span>${'${capacity}'}</span><em>${'${activePower}'}  ${'${dcPower}'}</em>
										<button type="button" onclick="deviceProcess('delete', '${'${el.did}'}');" class="delete">삭제</button>
										<a href="javascript:void(0);"></a>
									</li>`;
						deviceList.append(deviceStr);
						if(index == 0) {
							deviceDetailView(el.did, el.operation, $(this))
						}
					});
				}

				let featureHead = '';
				let featureBody1 = '';
				let featureBody2 = '';
				if (!isEmpty(featureProperties[key])) {
					if (!isEmpty(featureProperties[key].headerProp)) {
						let prop = featureProperties[key].headerProp;
						prop.forEach(el => {
							if (!(el.key == 'dname')) {
								featureHead += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><p class="t-title">' + el.value + '</p><p class="t-value"></p></li>';
							}
						});
					}
					if (!isEmpty(featureProperties[key].bodyProp)) {
						let prop = featureProperties[key].bodyProp;
						prop.forEach((el, idx) => {
							if (idx % 2 == 0) {
								featureBody1 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di-li-title">' + el.value + '</span><span class="di-li-text"></span></li>';
							} else {
								featureBody2 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di-li-title">' + el.value + '</span><span class="di-li-text"></span></li>';
							}
						});
					}
				}

				let liTemp = `<li class="equip-add"><a href="javascript:addDeviceForm(\'${'${key}'}\');"></a></li>`;
				deviceList.append(liTemp);

				let typeClass;
				// 1. SM_MANUAL => 수기 입력,
				// 2. SM_ISMART => iSmart(과금 데이터),
				// 3. SM => Smart Meter(전력량계),
				// 4. INV_PV => 태양광 인버터,
				// 5. PCS_ESS => Power Conditioning System,
				// 6. BMS_SYS => Battery Management System,
				// 7. BMS_RACK => BMS Rack,
				// 8. SENSOR_SOLAR, SENSOR_TEMPHUMID, SENSOR_WEATHER, SENSOR_FLAME => 센서,
				// 9. CIRCUIT_BREAKER => 회로 차단기,
				// 10. COMBINER_BOX => 접속반,

				switch (key) {
					case 'SM_MANUAL':
						typeClass = 'list-manual';
						break;
					case 'SM_ISMART':
						typeClass = 'list-ami';
						break;
					case 'SM':
						typeClass = 'list-meter';
						break;
					case 'INV_PV':
						typeClass = 'list-inverter';
						break;
					case 'PCS_ESS':
						typeClass = 'list-pcs';
						break;
					case 'BMS_SYS':
						typeClass = 'list-bms-sys';
						break;
					case 'BMS_RACK':
						typeClass = 'list-bms-rack';
						break;
					case 'SENSOR_SOLAR': case 'SENSOR_WEATHER': case 'SENSOR_TEMPHUMID': case 'SENSOR_FLAME':
						typeClass = 'list-sensor';
						break;
					case 'CIRCUIT_BREAKER':
						typeClass = 'list-disconnector';
						break;
					case 'COMBINER_BOX':
						typeClass = 'list-connector';
						break;
					default:
						typeClass = '';
						break;
				}

				let typeName = '';
				typeName = featureProperties[key].name;

				typeList.push({
					typeName: typeName,
					typeId: key,
					alert: alert,
					error: error,
					normal: normal,
					deviceList: deviceList.html(),
					featureHead: featureHead,
					featureBody1: featureBody1,
					featureBody2: featureBody2,
					typeClass: typeClass
				});
			});
		}

		typeList.sort(function(a, b) {
			return (a.typeId < b.typeId) ? -1 : (a.typeId > b.typeId) ? 1 : 0;
		});

		setMakeList(typeList, 'deviceStateTypeList', {'dataFunction': {}});

		$('#deviceStateTypeList div.row').each(function() {
			if ($(this).prop('id') == 'SM_MANUAL') {
				$(this).find('.equip-card .eq-btn-box button').eq(1).html('데이터 입력');
			}
		});

		$('.dbTime').text('');
	}

	const deviceDetailView = (did, deviceStatus, self) => {
		$.ajax({
			url: apiHost + apiStatusRaw,
			type: 'get',
			dataType: 'json',
			data: {
				dids: did
			}
		}).done(function (data, textStatus, jqXHR) {
			let resultData = data[did].data[0],
				dType = data[did].device_type,
				dName = data[did].dname,
				operation = 't2';

				$('#' + dType + ' .equip-card').removeClass("hidden");
				if(deviceStatus == 0){
					// 중지
					$('#' + dType + ' .equip-card').addClass('alert');
				} else if(deviceStatus == 1){
					// 정상
					$('#' + dType + ' .equip-card').addClass('normal');
				} else if(deviceStatus == 2) {
					// 트립
					$('#' + dType + ' .equip-card').addClass('error');
				}

			$('#' + dType + ' .equip-card .ntit').text(dName);
			$('#' + dType + ' .equip-card .inv-title').text(dName + ' 현황');

			$('#' + dType + ' .equip-card .equip-card-ul li').each(function () {
				let liData = $(this).data('key'),
					suffix = $(this).data('suffix');

				if (liData == 'dname') {
					$(this).find('.t-value').text(dName);
				} else {
					if (!isEmpty(resultData) && !isEmpty(resultData[liData])) {
						let dValue = '';
						if(liData.match("activePower") || liData.match("dcPower")){
							let rounded = Math.round(resultData[liData]);
							if(rounded < 1000){
								let tempVal = displayNumberFixedUnit(resultData[liData], suffix, suffix, 2, "round");
								tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
							} else if(rounded >= 1000 && rounded < 1000000){
								let tempVal = displayNumberFixedUnit(resultData[liData], suffix, "kW", 0, "round");
								tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
							} else if(rounded >= 1000000 && rounded < 1000000000){
								let tempVal = displayNumberFixedUnit(resultData[liData], suffix, "MW", 2, "round");
								console.log("tempVal==", tempVal, "suffix=", suffix )
								tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
							} else if(rounded >= 1000000000){
								let tempVal = displayNumberFixedUnit(resultData[liData], suffix, "GW", 2, "round");
								tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
							}
						} else {
							let tempVal = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
							dValue = tempVal[0] != '-' ? tempVal[0] + ' ' + tempVal[1] : tempVal[0];
						}
						$(this).find('.t-value').text(dValue);
					} else {
						$(this).find('.t-value').text('-');
					}
				}
			});

			$('#' + dType + ' .equip-card .isb-in .di-list li').each(function () {
				let liData = $(this).data('key'),
					suffix = $(this).data('suffix');

				if (!isEmpty(resultData) && !isEmpty(resultData[liData])) {
					let dValue = '';
					if(liData.match("accumActiveEnergy")){
						let rounded = Math.round(resultData[liData]);
						if(rounded < 1000){
							let tempVal = displayNumberFixedUnit(resultData[liData], suffix, suffix, 2, "round");
							tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
						} else if(rounded >= 1000 && rounded < 1000000){
							let tempVal = displayNumberFixedUnit(resultData[liData], suffix, "kWh", 0, "round");
							tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
						} else if(rounded >= 1000000 && rounded < 1000000000){
							let tempVal = displayNumberFixedUnit(resultData[liData], suffix, "MWh", 2, "round");
							tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
						} else if(rounded >= 1000000000){
							let tempVal = displayNumberFixedUnit(resultData[liData], suffix, "GWh", 2, "round");
							tempVal[0] != '-' ? ( dValue = tempVal[0] + ' ' + tempVal[1] ) : ( dValue = tempVal[0] );
						}
					} else {
						let tempVal = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
						if(liData.match("voltageR") || liData.match("voltageS") || liData.match("voltageT")) {
							dValue = tempVal[0] != '-' ? tempVal[0] + ' ' + 'V' : tempVal[0];
						} else if(liData.match("currentR") || liData.match("currentS") || liData.match("currentT")) {
							dValue = tempVal[0] != '-' ? tempVal[0] + ' ' + 'A' : tempVal[0];
						} else {
							dValue = tempVal[0] != '-' ? tempVal[0] + ' ' + tempVal[1] : tempVal[0];
						}
					}
					$(this).find('.di-li-text').text(dValue);
				} else {
					$(this).find('.di-li-text').text('-');
				}

			});

			if (dType == 'SM_MANUAL') {
				$('#' + dType + ' .equip-card .eq-btn-box button').eq(1).attr('onclick', 'addManualForm("' + did + '")'); //설비 수정
			} else {
				$('#' + dType + ' .equip-card .eq-btn-box button').eq(1).attr('onclick', 'moveOperation("' + did + '");'); //상태이력으로 이동
			}
			$('#' + dType + ' .equip-card .eq-btn-box button').eq(0).attr('onclick', 'addDeviceForm("' + dType + '", "' + did + '")'); //설비 수정
			
			self.addClass("active").siblings().removeClass("active");

			if (!isEmpty(resultData)) {
				const now = new Date(resultData['timestamp']);
				$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	const addManualForm = (did) => {
		// $('[class^="manual"]').each(function() {
		// 	$(this).removeClass('w-40');
		//
		// 	if (!$(this).hasClass('w-80')) {
		// 		$(this).addClass('w-80');
		// 	}
		// });
		dropDownInit($('#deviceType'));
		dropDownInit($('#timeInterval'));

		$('#startHour').addClass('hidden');
		$('#startMin').addClass('hidden');
		$('#endHour').addClass('hidden');
		$('#endMin').addClass('hidden');

		$('#manualModalTable').empty();

		$('.customFromDate').datepicker('setDate', new Date());
		$('.customToDate').datepicker('setDate', new Date());


		$('#manualAddDeviceModal').data('did', did).modal('show');
	}

	const setManualForm = () => {
		const timeInterval = $('#timeInterval button').data('value'),
			timeIntervalTxt = $('#timeInterval button').text(),
			startDate = $('#start').datepicker('getDate'),
			endDate = $('#end').datepicker('getDate'),
			did = $('#manualAddDeviceModal').data('did');

		let dateArr = new Array();

		$('#manualModalTable').empty();
		$('#manualModalTable').parents('table').find('thead th:first-child').text(timeIntervalTxt + '단위');
		if(!isEmpty(timeInterval) && startDate != null && endDate != null) {
			let sDate = startDate.format('yyyyMMdd'),
				eDate = endDate.format('yyyyMMdd');

			if (timeInterval == 'day') {
				let diffDay = dateDiff(eDate, sDate, 'day');
				for (let j = 0; j < diffDay; j++) {
					let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
					sDateTime.setDate(Number(sDateTime.getDate()) + j);
					let toDate = sDateTime.format('yyyyMMdd');
					dateArr.push(toDate);
				}
			} else if (timeInterval == 'month') {
				let diffMonth = dateDiff(eDate, sDate, 'month');
				for (let j = 0; j < diffMonth; j++) {
					let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) + j - 1, 1);
					let toDate = sDateTime.format('yyyyMM');
					dateArr.push(toDate);
				}
			} else {
				let diffDay = dateDiff(eDate, sDate, 'day');
				//diffDay 1보다 크면 시작일과 종료일이 다르다.
				for (let j = 0; j < diffDay; j++) {
					let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
					sDateTime.setDate(sDateTime.getDate() + j);
					let toDate = sDateTime.format('yyyyMMdd');

					let startHour = $('#startHour button').data('value');
					let startMin = $('#startMin button').data('value');
					let endHour = $('#endHour button').data('value');
					let endMin = $('#endMin button').data('value');

					for (let i = 0; i < 24; i++) {
						if (timeInterval == '15min') { //15분
							// if (j == 0) {
							// 	if (Number(startHour) == i) {
							// 		if (String(i).length == 1) {
							// 			for (let minute = 1; minute < 4; minute++) {
							// 				let setMinute = Number(startMin) * minute;
							// 				if (setMinute == 0) {
							// 					dateArr.push(toDate + '0' + i + '0000');
							// 				} else if (setMinute <= 60) {
							// 					dateArr.push(toDate + '0' + i + String(setMinute) + '00');
							// 				}
							// 			}
							// 		} else {
							// 			for (let minute = 1; minute < 4; minute++) {
							// 				let setMinute = Number(startMin) * minute;
							// 				if (setMinute == 0) {
							// 					dateArr.push(toDate + '0' + i + '0000');
							// 				} else if (setMinute <= 60) {
							// 					dateArr.push(toDate + '0' + i + String(setMinute) + '00');
							// 				}
							// 			}
							// 		}
							// 	} else if (Number(startHour) < i) {
							// 		if (String(i).length == 1) {
							// 			dateArr.push(toDate + '0' + i + '0000');
							// 			dateArr.push(toDate + '0' + i + '1500');
							// 			dateArr.push(toDate + '0' + i + '3000');
							// 			dateArr.push(toDate + '0' + i + '4500');
							// 		} else {
							// 			dateArr.push(toDate + i + '0000');
							// 			dateArr.push(toDate + i + '1500');
							// 			dateArr.push(toDate + i + '3000');
							// 			dateArr.push(toDate + i + '4500');
							// 		}
							// 	}
							// } else {
								if (String(i).length == 1) {
									dateArr.push(toDate + '0' + i + '0000');
									dateArr.push(toDate + '0' + i + '1500');
									dateArr.push(toDate + '0' + i + '3000');
									dateArr.push(toDate + '0' + i + '4500');
								} else {
									dateArr.push(toDate + i + '0000');
									dateArr.push(toDate + i + '1500');
									dateArr.push(toDate + i + '3000');
									dateArr.push(toDate + i + '4500');
								}
							// }
						} else if (timeInterval == '30min') { //30분
							if (String(i).length == 1) {
								dateArr.push(toDate + '0' + i + '0000');
								dateArr.push(toDate + '0' + i + '3000');
							} else {
								dateArr.push(toDate + i + '0000');
								dateArr.push(toDate + i + '3000');
							}
						} else { //시간
							if (String(i).length == 1) {
								dateArr.push(toDate + '0' + i + '0000');
							} else {
								dateArr.push(toDate + i + '0000');
							}
						}
					}
				}
			}

			dateArr.forEach(date => {
				let textDate = '';
				if (timeInterval == '15min' || timeInterval == 'hour') {
					textDate = date.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
				} else if (timeInterval == 'day') {
					textDate = date.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3') + '000000';
				} else {
					textDate = date.replace(/(\d{4})(\d{2})/, '$1-$2');
				}

				let manualTemplate = `
									<tr>
										<td>${'${textDate}'}</td>
										<td>
											<div class="text-input-type center edit">
												<input id="${'${date}'}" type="text" name="${'${date}'}" value="">
											</div>
										</td>
									</tr>`;
				$('#manualModalTable').append(manualTemplate);
			});
			$('#manualModalTable').data('startDate', startDate.format('yyyyMMdd'));
			$('#manualModalTable').data('endDate', endDate.format('yyyyMMdd'));

			$.ajax({
				url: apiHost + apiEnergyDevices,
				type: 'get',
				dataType: 'json',
				async: false,
				data: {
					dids: did,
					startTime: startDate.format('yyyyMMdd') + '000000',
					endTime: endDate.format('yyyyMMdd') + '235959',
					interval: timeInterval
				},
			}).done(function (data, textStatus, jqXHR) {
				let resultData = data.data;
				if (!isEmpty(resultData)) {
					let result = resultData[did][0].items,
						manualObj = new Object();
					result.forEach(manual => {
						manualObj[manual.basetime] = Number(manual.energy);
					});

					setJsonAutoMapping(manualObj, 'manualModalTable');
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});

		} else {
			alert('입력 단위를 선택해 주세요.');
			return false;
		}
	}

	const initManualForm = () => {
		$('#manualModalTable input').each(function() {
			$(this).val('');
		});
	}

	const saveManualForm = () => {
		const timeInterval = $('#timeInterval button').data('value'),
			startDate = $('#manualModalTable').data('startDate'),
			endDate = $('#manualModalTable').data('endDate'),
			did = $('#manualAddDeviceModal').data('did');

		let postData = new Object();
		let data = new Array();
		let items = new Array();

		if (timeInterval != '15min') {
			alert('현재 15분 단위만 입력 가능합니다.');
			return false;
		}

		let stdDate = '';
		$('#manualModalTable input').each(function() {
			let index = $('#manualModalTable input').index(this),
				length = $('#manualModalTable input').length,
				thisName = $(this).attr('id'),
				thisKey = '',
				thisStdDate = '';

			if (timeInterval == 'day') {
				thisStdDate = thisName.substring(0, 6);
				thisKey = thisName.substring(6, 8);
			} else if (timeInterval == 'month') {
				thisStdDate = thisName.substring(0, 4);
				thisKey = thisName.substring(4, 6);
			} else {
				thisStdDate = thisName.substring(0, 8);
				thisKey = thisName.substring(8, 12);
			}

			if (stdDate == '') {
				stdDate = thisStdDate;

				items.push({
					basetime: thisKey,
					energy: $(this).val()
				});
			} else if (stdDate != thisStdDate) {
				data.push({
					date: stdDate,
					items: items
				});

				stdDate = thisStdDate;
				items = new Array();

				items.push({
					basetime: thisKey,
					energy: $(this).val()
				});
			} else {
				items.push({
					basetime: thisKey,
					energy: $(this).val()
				});
			}

			if ((index + 1) == length) {
				data.push({
					date: stdDate,
					items: items
				});
			}
		});

		postData['start'] = startDate;
		postData['end'] = endDate;
		postData['data'] = data;

		$.ajax({
			url: apiHost + apiEnergyManual + '?oid=' + oid + '&did=' + did + '&interval=' + timeInterval,
			type: 'post',
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify(postData)
		}).done(function (data, textStatus, jqXHR) {
			alert('등록되었습니다.');
			return false;
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	const addDeviceForm = (devicetype, did) => {
		const popup = $('#addDeviceModal'),
			dropDown = popup.find('.dropdown'),
			textArea = popup.find('textarea'),
			inputArr = popup.find('input');

		dropDown.each(function () {
			dropDownInit($(this));
		});

		textArea.val('');
		inputArr.each(function() {
			$(this).val('');
		});

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

		//did가 있으면 수정
		if (!isEmpty(did)) {
			$.ajax({
				url: apiHost + apiConfigDevices + '/' + did,
				type: 'get',
				dataType: 'json',
				async: false,
				data: {},
			}).done(function (data, textStatus, jqXHR) {

				setJsonAutoMapping(data, 'addDeviceModal', 'dropdown');

				const sid = data.sid;
				const rid = data.rid;
				getRtusList(sid, rid);

				$('#addSiteUlList li').each(function() {
					if ($(this).data('value') == sid) {
						const text = $(this).text();
						$(this).parents('.dropdown').find('button').html(text + '<span class="caret"></span>').data('value', 'sid');
					}
				});

				//let propArray = ['dashboard', 'billing', 'forecasting', 'manufacturer', 'alarm_set_id', 'alarm_code'];
				let propArray = ['dashboard', 'billing', 'forecasting', 'capacity'];
				$.map(data, function(val, key) {
					if ($.inArray(key, propArray) >= 0) {
						if (key == 'dashboard' || key == 'billing' || key == 'forecasting') {
							$('#' + key).prop('checked', val);
						} else if (key == 'capacity') {
							let unit = data['capacity_unit'];
							if (unit == 'W') {
								let capacity =(val / 1000).toFixed(2);
								$('#' + key).val(capacity);
							}  else {
								$('#' + key).val(val);
							}
						}
					}
				});

				costSetList();
				if (!isEmpty(data['alarm_code'])) {
					document.querySelectorAll('#alarm_codeList li').forEach(el => {
						if (el.dataset.value == data['alarm_code']) {
							document.querySelector('#alarm_code > button').innerHTML = el.textContent + '<span class="caret"></span>';
							document.querySelector('#alarm_code > button').dataset.value = data['alarm_code'];
						}
					});
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('처리 중 오류가 발생했습니다.');
				return false;
			});

			$('#addDeviceModal .modal-header').text('설비 정보 수정');
			$('#addDevice').attr('onclick', 'deviceProcess("patch", "' + did + '")').text('수정');
		} else {
			$('#addDeviceModal .modal-header').text('설비 정보 등록');
			$('#addDevice').attr('onclick', 'deviceProcess("post")').text('등록');
		}

		$('#addDeviceModal').modal('show');
	}

	//등록&수정&삭제
	const deviceProcess = (method, did) => {
		let areaData = setAreaParamData('addDeviceModal', 'dropdown');
		let alertPreffix = '등록';
		let urlSufffix = '';
		if (method == 'patch' || method == 'delete') {
			urlSufffix = '/' + did;

			if (method == 'patch') {
				if (isEmpty(areaData['alarm_code'])) {
					delete areaData['alarm_code'];
				} else {
					areaData['alarm_code'] = String(areaData['alarm_code']);
				}

				alertPreffix = '수정';
				if (!confirm('설비정보를 수정하시겠습니까?')) {
					return false;
				}
			}

			if (method == 'delete') {
				alertPreffix = '삭제';
				let delPrompt = prompt('해당설비를 삭제하시겠습니까? \n삭제를 원하시면 아래 "삭제"라고 입력하고 확인을 눌러 주세요.', '');
				if (delPrompt != '삭제') {
					return false;
				}
			}
		} else {
			urlSufffix = '?oid=' + oid + '&sid=' + $('#addSiteList button').data('value');
		}

		if (method != 'delete') {
			areaData['forecasting'] = $('#forecasting').is(':checked');
			areaData['dashboard'] = $('#dashboard').is(':checked');
			areaData['billing'] = $('#billing').is(':checked');
			if (isEmpty(areaData['alarm_code'])) {
				delete areaData['alarm_code'];
			} else {
				areaData['alarm_code'] = String(areaData['alarm_code']);
			}
			areaData['capacity'] = Number(areaData['capacity']) * 1000;
			areaData['capacity_unit'] = 'W';

			if (isEmpty(areaData['parent_did'])) {
				delete areaData['parent_did'];
			}

			delete areaData['addDeviceDisplayType'];
			delete areaData['addSiteList'];
		}

		$.ajax({
			url: apiHost + apiConfigDevices + urlSufffix,
			type: method,
			dataType: 'json',
			async: false,
			contentType: 'application/json',
			data: JSON.stringify(areaData),
		}).done(function (data, textStatus, jqXHR) {
			alert(alertPreffix + ' 되었습니다.');

			$('#addDeviceModal').modal('hide');
			getDeviceList();
			return false;
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	const costSetList = () => {
		$.ajax({
			url: apiHost + apiAlarmCodeSets,
			type: 'get',
			dataType: 'json',
			async: false,
			data: { includeCodes: true }
		}).done(function (data, textStatus, jqXHR) {
			codeSetList = data.data;
			const alarmCode = new Array();
			const deviceType = $('#device_type button').data('value');
			const refineList = codeSetList.filter(code => code.device_type == null || code.device_type === deviceType);
			refineList.forEach(codeSet => {
				const devicdType = codeSet['device_type'] === null ? '공통' : featureProperties[codeSet['device_type']]['name'];
				alarmCode.push({
					name: devicdType + '_' + codeSet['manufacturer'] + '_' + codeSet['model'] + '(' + codeSet['version'] + ')',
					val: codeSet['set_id']
				});
			});

			setMakeList(alarmCode, 'alarm_codeList', {'dataFunction': {}})
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
			reject(error);
		});
	}

	const moveOperation = (did) => {
		let pageForm = $('#pageMove');

		pageForm.find('input[name="did"]').val(did);
		pageForm.attr('action', '/history/operationHistory.do').submit();
	}

	const getRtusList = (siteId, rid) => {
		let sid = '';
		if(isEmpty(siteId)) {
			sid = $('#addSiteList button').data('value');
		} else {
			sid = siteId;
		}

		$.ajax({
			url: apiHost + apiConfigRtus,
			type: 'get',
			dataType: 'json',
			data: {
				oid: oid,
				sid: sid,
				filter: {}
			}
		}).done(function (data, textStatus, jqXHR) {

			let rtuList = new Array();
			data.forEach(function(el) {
				if (el.sid == siteId) {
					rtuList.push(el);
				}
			});

			setMakeList(data, 'ridList', {'dataFunction': {}});

			if (!isEmpty(rid)) {
				$('#ridList li').each(function() {
					if ($(this).data('value') == rid) {
						const text = $(this).text();
						$(this).parents('.dropdown').find('button').html(text + '<span class="caret"></span>').data('value', 'sid');
					}
				});
			}
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
				url: apiHost + apiConfigDevices,
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
