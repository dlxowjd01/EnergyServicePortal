<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl"><fmt:message key="deviceState.title" /></h1>
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
				<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key="deviceState.search.site" />">
					<fmt:message key="deviceState.search.site" /><span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk-type " role="menu" id="siteULList">
					<li>
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="site_[INDEX]" data-role="[role]" value="[sid]" name="site">
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
					<div class="chart-top">
						<h2 class="ntit fl"><fmt:message key="deviceState.addSite" /></h2>
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
					<div class="chart-top">
						<h2 class="ntit fl">[typeName]</h2>
						<div class="equip-icon fr">
							<span class="equip-normal pointer"><fmt:message key="deviceState.view.normal" />([normal])</span>
							<span class="equip-alert pointer"><fmt:message key="deviceState.view.stop" />([alert])</span>
							<span class="equip-error pointer"><fmt:message key="deviceState.view.trip" />([error])</span>
						</div>
					</div>
					<ul class="device-list [typeClass]" id="[typeId]_List">
						[deviceList]
					</ul>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="indiv equip-card hidden">
					<div class="chart-top">
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
						<button type="button" class="btn-type04" onclick="alert(`<fmt:message key='deviceState.alert.1' />`); return false;"><fmt:message key="deviceState.update.button" /></button>
						<button type="button" class="btn-type04" onclick="alert(`<fmt:message key='deviceState.alert.1' />`); return false;"><fmt:message key="deviceState.view.history" /></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="addDeviceModal" role="dialog">
	<div class="modal-dialog device-modal modal-lg">
		<div class="modal-content new_device">
			<div class="modal-header"><fmt:message key="deviceState.update.title" /></div>
			<div class="modal-body">
				<form id="deviceForm1" class="device-form" action="#" method="post" name="deviceForm" novalidate>
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex">
								<label for="addSiteList" class="input-label asterisk"><fmt:message key="deviceState.popup.site" /></label>
								<div class="dropdown" id="addSiteList">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='deviceState.search.site' />">
										<fmt:message key="deviceState.search.site" /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="addSiteUlList">
										<li data-value="[sid]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="name" class="input-label asterisk"><fmt:message key="deviceState.popup.deviceNe" /></label>
								<input class="input text-input-type" type="text" name="name" id="name" placeholder="<fmt:message key='deviceState.register.placeholder' />" autocomplete="off" onkeyup="$(this).val($(this).val().replace(/^\s+|\s+$/g, ''))">
							</div>
							<div class="input-group inline-flex">
								<label for="device_type" class="input-label asterisk"><fmt:message key="deviceState.popup.deviceType" /></label>
								<div class="dropdown" id="device_type">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='deviceState.popup.deviceSelect' />">
										<fmt:message key="deviceState.popup.deviceSelect" /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="device_typeList">
										<li data-value="[type]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="metering_type" class="input-label asterisk"><fmt:message key="deviceState.popup.metering" /></label>
								<div class="dropdown" id="metering_type">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='deviceState.popup.meteringSelect' />">
										<fmt:message key="deviceState.popup.meteringSelect" /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-value="0">
											<a href="javascript:void(0);" tabindex="-1"><fmt:message key="deviceState.popup.metering.none" /></a>
										</li>
										<li data-value="1">
											<a href="javascript:void(0);" tabindex="-1"><fmt:message key="deviceState.popup.metering.load" /></a>
										</li>
										<li data-value="2">
											<a href="javascript:void(0);" tabindex="-1"><fmt:message key="deviceState.popup.metering.gen" /></a>
										</li>
										<li data-value="3">
											<a href="javascript:void(0);" tabindex="-1"><fmt:message key="deviceState.popup.metering.ess" /></a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="manufacturer" class="input-label"><fmt:message key="deviceState.popup.producer" /></label>
								<input type="text" id="manufacturer" name="manufacturer" class="input text-input-type" placeholder="<fmt:message key='deviceState.popup.producer' />" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="capacity" class="input-label"><fmt:message key="deviceState.popup.size" /></label>
								<input class="input text-input-type" type="text" name="capacity" id="capacity" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="manager" class="input-label"><fmt:message key="deviceState.popup.person" /></label>
								<input class="input text-input-type" type="text" name="manager" id="manager" autocomplete="off">
							</div>
						</div>
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex chk-type">
								<label for="forecasting" class="input-label"><fmt:message key="deviceState.popup.forecast" /></label>
								<input type="checkbox" class="input text-input-type" id="forecasting" value="true" name="forecasting">
								<label for="forecasting"></label>
							</div>
							<div class="input-group inline-flex">
								<label for="rid" class="input-label"><fmt:message key="deviceState.popup.rtu" /></label>
								<div id="rid" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='deviceState.popup.device' />">
										<fmt:message key="deviceState.popup.device" /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="ridList">
										<li data-value="[rid]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="parent_did" class="input-label"><fmt:message key="deviceState.popup.top" /></label>
								<div id="parent_did" class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='deviceState.popup.device' />">
									<fmt:message key='deviceState.popup.device' /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu" id="parent_didList">
										<li data-value="[did]">
											<a href="javascript:void(0);" tabindex="-1">[name]</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceDisplayType" class="input-label"><fmt:message key="deviceState.popup.view" /></label>
								<div id="addDeviceDisplayType" class="dropdown">
									<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='deviceState.popup.meteringSelect' />">
										<fmt:message key='deviceState.popup.meteringSelect' /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu chk-type">
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="dashboard" value="true" name="dashboard">
												<label for="dashboard"><fmt:message key="deviceState.popup.view.dashboard" /></label>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" id="billing" value="true" name="billing">
												<label for="billing"><fmt:message key="deviceState.popup.view.rev" /></label>
											</a>
										</li>
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="product_name" class="input-label"><fmt:message key="deviceState.popup.name" /></label>
								<input type="text" id="product_name" name="product_name" class="input text-input-type" value="" placeholder="<fmt:message key='deviceState.popup.name' />" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="serial_id" class="input-label"><fmt:message key="deviceState.popup.serial" /></label>
								<input class="input text-input-type" type="text" name="serial_id" id="serial_id" autocomplete="off">
							</div>
							<div class="input-group inline-flex">
								<label for="contact" class="input-label"><fmt:message key="deviceState.popup.contact" /></label>
								<input class="input text-input-type" type="text" name="contact" id="contact" autocomplete="off">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="alarm_code" class="input-label"><fmt:message key="deviceState.popup.alarm" /></label>
								<div class="dropdown-wrapper w-80">
									<div class="dropdown" id="alarm_code">
										<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="<fmt:message key='deviceState.popup.alarmSelect' />">
											<fmt:message key="deviceState.popup.alarmSelect" /><span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk-type" id="alarm_codeList">
											<li data-value="[val]">
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="alarm_codeset[INDEX]" value="[val]" name="alarm_codeset">
													<label for="alarm_codeset[INDEX]">[name]</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="description" class="input-label"><fmt:message key="deviceState.popup.desc" /></label>
								<textarea name="addDeviceDescription" id="description" class="textarea"></textarea>
							</div>
						</div>
					</div>
				</form>
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key="deviceState.manual.cancel" /></button>
					<button type="button" class="btn-type" id="addDevice"><fmt:message key="deviceState.popup.confirm" /></button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="manualAddDeviceModal" role="dialog">
	<div class="modal-dialog device-modal">
		<div class="modal-content manual_input">
			<div class="modal-header"><fmt:message key="deviceState.manual" /></div>
			<div class="modal-body">
				<div class="container-fluid dateField">
					<form id="manualForm" action="#" method="post" name="deviceForm" class="setting-form">
						<section>
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key="deviceState.manual.type" /></span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<div id="deviceType" class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='deviceState.manual.select' />"><fmt:message key="deviceState.manual.select" /><span class="caret"></span></button>
										<ul class="dropdown-menu">
											<li data-value="PV"><a href="javascript:void(0)"><fmt:message key="deviceState.manual.solar" /></a></li>
											<li data-value="WIND"><a href="javascript:void(0)"><fmt:message key="deviceState.manual.wind" /></a></li>
										</ul>
									</div>
									<small class="warning hidden"><fmt:message key="deviceState.manual.selectType" /></small>
								</div>
							</div>
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key="deviceState.manual.unit" /></span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<div id="timeInterval" class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='deviceState.manual.select' />"><fmt:message key="deviceState.manual.select" /><span class="caret"></span></button>
										<ul class="dropdown-menu">
											<li data-value="15min"><a href="javascript:void(0)"><fmt:message key="deviceState.manual.15min" /></a></li>
											<li data-value="hour"><a href="javascript:void(0)"><fmt:message key="deviceState.manual.1h" /></a></li>
											<li data-value="day"><a href="javascript:void(0)"><fmt:message key="deviceState.manual.1d" /></a></li>
											<li data-value="month"><a href="javascript:void(0)"><fmt:message key="deviceState.manual.1m" /></a></li>
										</ul>
									</div>
									<small class="warning hidden"><fmt:message key="deviceState.manual.selectUnit" /></small>
								</div>
							</div>
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key="deviceState.manual.start" /></span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<div class="sel-calendar">
										<input type="text" id="start" name="start" class="sel customFromDate" value="" autocomplete="off" readonly>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xl-1 col-lg-2 col-md-2 col-sm-2"><span class="input-label"><fmt:message key="deviceState.manual.end" /></span></div>
								<div class="col-xl-6 col-lg-6 col-md-10 col-sm-10 pl-0">
									<div class="sel-calendar">
										<input type="text" id="end" name="end"class="sel customToDate" value="" autocomplete="off" readonly>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-12">
									<div class="input-group inline-flex">
										<button type="button" class="btn-type" onclick="setManualForm();"><fmt:message key="deviceState.manual.input" /></button>
										<button type="button" class="btn-type03 end" onclick="initManualForm();"><fmt:message key="deviceState.manual.reset" /></button>
									</div>
									<div class="spc-tbl mt-20">
										<table class="ly-type">
											<thead>
											<th><fmt:message key="deviceState.manual.15min.val" /></th>
											<th><fmt:message key="deviceState.manual.value" /></th>
											</thead>
											<tbody id="manualModalTable">
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</section>
					</form>
				</div>
				<div class="btn-wrap-type02">
					<button type="button" class="btn-type03" onclick="closeManualForm('cancel');"><fmt:message key="deviceState.manual.cancel" /></button>
					<button type="button" class="btn-type" onclick="closeManualForm('save');"><fmt:message key="deviceState.manual.submit" /></button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal stack" id="closeManualModal" tabindex="-1" role="dialog" aria-labelledby="closeManualModal" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content narrow">
			<div class="modal-body">
				<h2><fmt:message key="deviceState.close.confirm1" /></h2>
				<p class="mt-8"><fmt:message key="deviceState.close.confirm2" /></p>
			</div>
			<div class="modal-footer">
				<div class="btn-wrap-type mb-0">
					<button type="button" class="btn-type03" data-dismiss="modal"><fmt:message key="deviceState.manual.cancel" /></button>
					<button type="button" class="btn-type" onclick="closeModal();"><fmt:message key="deviceState.close.button" /></button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal stack" id="saveManualModal" tabindex="-1" role="dialog" aria-labelledby="saveManualModal" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content narrow">
			<div class="modal-body">
				<h2><fmt:message key="deviceState.save.confirm1" /></h2>
				<p class="mt-8"><fmt:message key="deviceState.save.confirm2" /></p>
			</div>
			<div class="modal-footer">
				<div class="btn-wrap-type mb-0">
					<button type="button" class="btn-type03" data-dismiss="modal"><fmt:message key="deviceState.manual.cancel" /></button>
					<button type="button" class="btn-type" onclick="saveManualForm();"><fmt:message key="deviceState.save.button" /></button>
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
	const apiDeviceSetIds = '/config/devices/set_ids';
	const apiEnergyManual = '/energy/manual/input';
	const apiEnergyConvertor = '/energy/manual/energy_converter';
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

	$(document).on('click', '.equip-icon span', function() {
		if ($(this).hasClass('on')) {
			$(this).parents('div.indiv').find('li').each(function() {
				$(this).removeClass('hidden');
			});
			$(this).removeClass('on');
		} else {
			const deviceState = $(this).attr('class').replace('equip-', '').replace('pointer', '').trim();
			$(this).parents('div.indiv').find('li.text-black').each(function() {
				if ($(this).hasClass(deviceState)) {
					$(this).removeClass('hidden');
				} else {
					$(this).addClass('hidden');
				}
			});

			$(this).parents('div.indiv').find('li.text-white').each(function() {
				$(this).addClass('hidden');
			});

			$(this).addClass('on').siblings().removeClass('on');
		}
	});

	//사업소 조회
	const siteMakeList = function (search = []) {
		const makeSite = search.length ? Array.from(search) : Array.from(siteList);
		makeSite.sortOn('name');
		makeSite.unshift({ sid: 'all', role: '', name: '<fmt:message key="dropDown.all" />'});
		setMakeList(makeSite, 'siteULList', {'dataFunction': {}}); //list생성
		
		$('#siteULList').find('input[value="all"]').parent().after('<li class="btn-wrap-border-min"></li>');

		if (!$(`.dropdown-search`).length) {
			$(`#siteList`)
				.prepend(`<div class="dropdown-search"><input type="text" placeholder="<fmt:message key="dropdown.siteSearch" />" onKeyup="searchSite($(this).val())" ></div>`)
				.append(`<div class="btn-wrap-type03 btn-wrap-border dropdown-apply"><button type="button" class="btn-type mr-16"><fmt:message key="deviceState.apply" /></button></div>`);
		}
	};

	const searchSite = keyword => {
		const result = siteList.filter(x => x.name.includes(keyword));

		siteMakeList(result);
	}

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
			let startDate = $('#start').datepicker('getDate')
			  , endDate = $('#end').datepicker('getDate');

			if (std == '15min') {
				$('#startHour').removeClass('hidden');
				$('#startMin').removeClass('hidden');
				$('#endHour').removeClass('hidden');
				$('#endMin').removeClass('hidden');
			} else {
				if (std === 'month') {
					startDate.setDate(1)
					$('#start').datepicker('setDate', startDate.format('yyyy-MM-dd'));

					endDate.setMonth(endDate.getMonth() + 1);
					endDate.setDate(0);
					$('#end').datepicker('setDate', endDate.format('yyyy-MM-dd'));
				}

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

			alert('<fmt:message key="deviceState.alert.2" />');
			return false;
		});
	};

	const getDeviceList = () => {
		let deviceMap = new Object;
		let siteArray = new Array();

		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => { if (check.value !== 'all') { siteArray.push(check.value); } });
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => { siteArray.push(checked.value); });
		}

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

					alert('<fmt:message key="deviceState.alert.2" />');
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
						const targetSite = siteList.find(e => e.sid === el.sid);
						let capacity = "";
						let	activePower = "";
						let dcPower = "";
						let operation = el.operation;

						if(el.device_type.toUpperCase().match("SENSOR_TEMPHUMID") || el.device_type.toUpperCase().match("SENSOR_WEATHER") ){
							capacity = '';
							activePower = isEmpty(el.temperature) ? '-' : displayNumberFixedDecimal(el.temperature, 'W', 'W', 1, 'round')[0] + '&#176;';
							dcPower = isEmpty(el.humidity) ? '-' : displayNumberFixedDecimal(el.humidity, 'W', 'kW', 1, 'round')[0] + '&#37;';
						} else {
							capacity = isEmpty(el.capacity) ? '-' : displayNumberFixedUnit(el.capacity, el.capacity_unit, 'kW', 0, 'round')[0] + 'kW';
							activePower = isEmpty(el.activePower) ? '-' : displayNumberFixedUnit(el.activePower, 'W', 'kW', 0, 'round')[0] + 'kW';
							dcPower = isEmpty(el.dcPower) ? '-' : displayNumberFixedUnit(el.dcPower, 'W', 'kW', 0, 'round')[0] + 'kW';
						}

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
								operation = 'text-white';
								break;
						}

						let deviceStr = `<li class="${'${operation}'}" onclick="deviceDetailView('${'${el.did}'}', '${'${el.operation}'}', $(this))">
											<span>${'${targetSite.name}'}</span>
											<span>${'${el.name}'}</span>
											<span>${'${capacity}'}</span><em>${'${activePower}'}  ${'${dcPower}'}</em>
											<button type="button" onclick="deviceProcess('delete', '${'${el.did}'}', event);" class="delete">삭제</button>
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
							if(el.key.startsWith('voltage') || el.key.match('accumActiveEnergy')){
								featureBody1 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di-li-title">' + el.value + '</span><span class="di-li-text"></span></li>';
							} else if(el.key.startsWith('current')){
								featureBody2 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di-li-title">' + el.value + '</span><span class="di-li-text"></span></li>';
							} else {
								if (idx % 2 == 0) {
									featureBody1 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di-li-title">' + el.value + '</span><span class="di-li-text"></span></li>';
								} else {
									featureBody2 += '<li data-key="' + el.key + '" data-suffix="' + el.suffix + '"><span class="di-li-title">' + el.value + '</span><span class="di-li-text"></span></li>';
								}
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

		typeList.sortOn('typeId');
		setMakeList(typeList, 'deviceStateTypeList', {'dataFunction': {}});

		$('#deviceStateTypeList div.row').each(function() {
			if ($(this).prop('id') == 'SM_MANUAL') {
				$(this).find('.equip-card .eq-btn-box button').eq(1).html('<fmt:message key="deviceState.inputDevice" />');
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

				if(deviceStatus == 0){
					// 중지
					$('#' + dType + ' .equip-card').attr('class', 'indiv equip-card alert');
				} else if(deviceStatus == 1){
					// 정상
					$('#' + dType + ' .equip-card').attr('class', 'indiv equip-card normal');
				} else if(deviceStatus == 2) {
					// 트립
					$('#' + dType + ' .equip-card').attr('class', 'indiv equip-card error');
				} else {
					$('#' + dType + ' .equip-card').removeClass("hidden");
				}

			$('#' + dType + ' .equip-card .ntit').text(dName);
			$('#' + dType + ' .equip-card .inv-title').text(dName + ' <fmt:message key="deviceState.status" />');

			$('#' + dType + ' .equip-card .equip-card-ul li').each(function () {
				let liData = $(this).data('key'),
					suffix = $(this).data('suffix');

				if (liData == 'dname') {
					$(this).find('.t-value').text(dName);
				} else {
					if (!isEmpty(resultData) && !isEmpty(resultData[liData])) {
						let dValue = '';
						if(liData.match("activePower") || liData.match("dcPower")){
							let tempVal = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
							tempVal[0] != '-' ? ( dValue = tempVal.join(' ')) : ( dValue = tempVal[0] );
						} else {
							if(liData.match("temperature") || liData.match("humidity")){
								dValue = resultData[liData] != '-' ? displayNumberFixedUnit(resultData[liData], suffix, suffix, 1)[0] + ' ' + suffix : resultData[liData];
							} else {
								let tempVal = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
								dValue = tempVal[0] != '-' ? tempVal[0] + ' ' + suffix : tempVal[0];
							}
						}
						$(this).find('.t-value').text(dValue);
					} else {
						$(this).find('.t-value').text('-');
					}
				}
			});

			$('#' + dType + ' .equip-card .isb-in .di-list li').each(function (index, element) {
				let liData = $(this).data('key'),
					suffix = $(this).data('suffix');

				if (!isEmpty(resultData) && !isEmpty(resultData[liData])) {
					let dValue = '';
					if(liData.match("accumActiveEnergy")){
						let tempVal = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
						tempVal[0] != '-' ? ( dValue = tempVal.join(' ')) : ( dValue = tempVal[0] );
					} else {
						let tempVal = displayNumberFixedDecimal(resultData[liData], suffix, 3, 2);
						if(liData.match("voltageR") || liData.match("voltageS") || liData.match("voltageT")) {
							dValue = tempVal[0] != '-' ? tempVal[0] + ' ' + 'V' : tempVal[0];
						} else if(liData.match("currentR") || liData.match("currentS") || liData.match("currentT")) {
							dValue = tempVal[0] != '-' ? tempVal[0] + ' ' + 'A' : tempVal[0];
						} else if(liData.match("temperature")){
							dValue = tempVal[0] + suffix;
						} else {
							dValue = tempVal[0] != '-' ? tempVal.join(' ') : tempVal[0];
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

		$('#start').datepicker('setDate', new Date());
		$('#end').datepicker('setDate', new Date());

		$('#manualModalTable').removeData('items');
		$('#manualAddDeviceModal').data('did', did).modal('show');
	}

	const setManualForm = () => {
		const timeInterval = $('#timeInterval button').data('value')
			, timeIntervalTxt = $('#timeInterval button').text()
			, did = $('#manualAddDeviceModal').data('did');

		$('#manualForm > section .dropdown > button').each(function() {
			if (isEmpty($(this).data('value'))) {
				$(this).parent().next().removeClass('hidden');
			} else {
				if (!$(this).parent().next().hasClass('hidden')) {
					$(this).parent().next().addClass('hidden');
				}
			}
		});

		if ($('#manualForm .warning:not(.hidden)').length > 0) return false;

		let startDate = $('#start').datepicker('getDate'),
			endDate = $('#end').datepicker('getDate');
		let dateArr = new Array();

		$('#manualModalTable').empty();
		$('#manualModalTable').parents('table').find('thead th:first-child').text(timeIntervalTxt + '단위');

		if(!isEmpty(timeInterval) && startDate != null && endDate != null) {
			let sDate = startDate.format('yyyyMMdd'),
				eDate = endDate.format('yyyyMMdd');

			if (timeInterval === 'day') {
				let diffDay = dateDiff(eDate, sDate, 'day');
				for (let j = 0; j < diffDay; j++) {
					let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
					sDateTime.setDate(Number(sDateTime.getDate()) + j);
					let toDate = sDateTime.format('yyyyMMdd');
					dateArr.push(toDate);
				}
			} else if (timeInterval === 'month') {
				let diffMonth = dateDiff(eDate, sDate, 'month');
				for (let j = 0; j < diffMonth; j++) {
					let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) + j - 1, 1);
					let toDate = sDateTime.format('yyyyMMdd');
					dateArr.push(toDate);
				}
			} else {
				let diffDay = dateDiff(eDate, sDate, 'day');
				//diffDay 1보다 크면 시작일과 종료일이 다르다.
				for (let j = 0; j < diffDay; j++) {
					let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
					sDateTime.setDate(sDateTime.getDate() + j);
					let toDate = sDateTime.format('yyyyMMdd');

					for (let i = 0; i < 24; i++) {
						if (timeInterval == '15min') { //15분
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
					textDate = date.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
				} else {
					textDate = date.substr(0, 6).replace(/(\d{4})(\d{2})/, '$1-$2');
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

			if (timeInterval === 'month') {
				startDate.setDate(1);
				endDate.setMonth(endDate.getMonth() + 1)
				endDate.setDate(0);
			}

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
				}
			}).done(function (data, textStatus, jqXHR) {
				let resultData = data.data,
					stdDate = '';
				if (!isEmpty(resultData)) {
					let result = resultData[did][0].items,
						manualObj = new Object(),
						data = new Array(),
						items = new Array();

					result.forEach((manual, index) => {
						let baseTime = '',
							thisKey = '',
							thisStdDate = '',
							thisName = String(manual.basetime);
						if (timeInterval === '15min' || timeInterval === 'hour') {
							baseTime = manual.basetime;

							thisStdDate = thisName.substring(0, 8);
							thisKey = thisName.substring(8, 12);
						} else {
							baseTime = String(manual.basetime).substr(0, 8);

							thisStdDate = thisName;
							thisKey = '000000';
						}
						manualObj[baseTime] = Number(manual.energy) / 1000;

						if (isEmpty(stdDate)) {
							stdDate = thisStdDate;

							items.push({
								basetime: thisKey,
								energy: manual.energy
							});
						} else if (stdDate !== thisStdDate) {
							if (timeInterval === 'month' || timeInterval === 'day') {
								stdDate = stdDate.substr(0, 8);
							}

							data.push({
								date: stdDate,
								items: items
							});

							stdDate = thisStdDate;
							items = new Array();

							items.push({
								basetime: thisKey,
								energy: manual.energy
							});
						} else {
							items.push({
								basetime: thisKey,
								energy: manual.energy
							});
						}

						if ((index + 1) === result.length) {
							if (timeInterval === 'month' || timeInterval === 'day') {
								stdDate = stdDate.substr(0, 8);
							}

							data.push({
								date: stdDate,
								items: items
							});
						}
					});

					$('#manualModalTable').data('items', data);
					setJsonAutoMapping(manualObj, 'manualModalTable');
				}
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('<fmt:message key="deviceState.alert.2" />');
				return false;
			});
		} else {
			alert('<fmt:message key="deviceState.alert.3" />');
			return false;
		}
	}

	const initManualForm = () => {
		$('#manualModalTable input').each(function() {
			$(this).val('');
		});
	}

	const objectAreEqual = (a, b) => {
		for (let prop in a) {
			if (a.hasOwnProperty(prop)) {
				if (b.hasOwnProperty(prop)) {
					if (typeof a[prop] === 'object') {
						if (!objectAreEqual(a[prop], b[prop])) return false;
					} else {
						if (a[prop] !== b[prop]) return false;
					}
				} else {
					return false;
				}
			}
		}

		return true;
	}

	const saveManualForm = () => {
		const timeInterval = $('#timeInterval button').data('value'),
			type = $('#deviceType button').data('value'),
			startDate = $('#manualModalTable').data('startDate'),
			endDate = $('#manualModalTable').data('endDate'),
			did = $('#manualAddDeviceModal').data('did');

		const postData = new Object();
		const data = refineManualData(timeInterval);

		if (timeInterval === 'month') {
			let endDateMonth = new Date(String(endDate).substr(0, 4), Number(String(endDate).substr(4, 2)), 0);
			postData['start'] = String(startDate).substr(0, 6) + '01';
			postData['end'] = endDateMonth.format('yyyyMMdd');
		} else {
			postData['start'] = startDate;
			postData['end'] = endDate;
		}
		postData['data'] = data;

		$.ajax({
			url: apiHost + apiEnergyManual + '?oid=' + oid + '&did=' + did + '&interval=' + timeInterval + '&type=' + type,
			type: 'post',
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify(postData),
			beforeSend: function() {
				$('#saveManualModal').modal('hide');
				$('#loadingCircle').show();
			}
		}).done(function (data, textStatus, jqXHR) {
			alert('<fmt:message key="deviceState.alert.4" />');
			$('#manualAddDeviceModal').modal('hide');
			return false;
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('<fmt:message key="deviceState.alert.2" />');
			return false;
		});
	}

	/**
	 * 조회한 데이터와 비교하여
	 * 같으면 창을 닫고 다르면 컨펌창을 띄워준다.
	 *
	 * @param mode - save:저장버튼, cancel: 취소버튼
	 */
	const closeManualForm = (mode) => {
		const manualItems = $('#manualModalTable').data('items')
			, timeInterval = $('#timeInterval button').data('value')
			, data = refineManualData(timeInterval);

		if (manualItems === undefined) {
			if ($('#manualModalTable tr').length === 0) {
				if (mode === 'save') {
					alert('<fmt:message key="deviceState.alert.5" />');
				} else {
					$('#manualAddDeviceModal').modal('hide');
				}
			} else {
				let modify = false;
				$('#manualModalTable input').each(function() {
					if (!isEmpty($(this).val())) {
						modify = true;
					}
				});

				if (modify === true) {
					if (mode === 'save') {
						$('#saveManualModal').modal('show');
					} else {
						$('#closeManualModal').modal('show');
					}
				} else {
					if (mode === 'save') {
						alert('<fmt:message key="deviceState.alert.5" />');
					} else {
						$('#manualAddDeviceModal').modal('hide');
					}
				}
			}
		} else {
			if (isEmpty(manualItems) || (objectAreEqual(manualItems, data))) {
				if (mode === 'save') {
					alert('<fmt:message key="deviceState.alert.6" />');
				} else {
					$('#manualAddDeviceModal').modal('hide');
				}
			} else {
				if (mode === 'save') {
					$('#saveManualModal').modal('show');
				} else {
					$('#closeManualModal').modal('show');
				}
			}
		}
	}

	const closeModal = () => {
		$('#closeManualModal').modal('hide');
		$('#manualAddDeviceModal').modal('hide');
	}

	const refineManualData = (timeInterval) => {
		let stdDate = ''
		  , data = new Array()
		  , items = new Array();

		$('#manualModalTable input').each(function() {
			let index = $('#manualModalTable input').index(this),
				length = $('#manualModalTable input').length,
				thisName = $(this).attr('id'),
				thisKey = '',
				thisStdDate = '';

			if (timeInterval == 'day' || timeInterval == 'month') {
				thisStdDate = thisName;
				thisKey = '000000';
			} else {
				thisStdDate = thisName.substring(0, 8);
				thisKey = thisName.substring(8, 12);
			}

			if (stdDate == '') {
				stdDate = thisStdDate;

				items.push({
					basetime: thisKey,
					energy: Number($(this).val()) * 1000
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
					energy: Number($(this).val()) * 1000
				});
			} else {
				items.push({
					basetime: thisKey,
					energy: Number($(this).val()) * 1000
				});
			}

			if ((index + 1) == length) {
				data.push({
					date: stdDate,
					items: items
				});
			}
		});

		return data;
	}

	const addDeviceForm = (devicetype, did) => {
		const popup = $('#addDeviceModal'),
			dropDown = popup.find('.dropdown'),
			textArea = popup.find('textarea'),
			inputArr = popup.find('input');

		let role = true;
		$(':checkbox[name="site"]').each(function() {
			if (!isEmpty($(this).data('role')) && $(this).data('role') === '2') {
				role = false;
			}
		});

		if (!role) {
			errorMsg('선택한 사이트 중 권한이 없는 사이트가 있습니다.');
			return false;
		}

		dropDown.each(function () {
			dropDownInit($(this));
		});

		textArea.val('');
		inputArr.each(function() {
			$(this).val('');
		});

		let siteArray = new Array();
		if ($(':checkbox[name="site"]:checked').val() === 'all') {
			document.querySelectorAll('[name="site"]').forEach(check => {
				if (check.value !== 'all') {
					siteArray.push({
						sid: check.value,
						name: check.nextElementSibling.textContent
					});
				}
			});
		} else {
			document.querySelectorAll('[name="site"]:checked').forEach(checked => {
				siteArray.push({
					sid: checked.value,
					name: checked.nextElementSibling.textContent
				});
			});
		}
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
					if ($(this).data('value') === sid) {
						const text = $(this).text();
						$(this).parents('.dropdown').find('button').html(text + '<span class="caret"></span>').data('value', sid);
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

				displayDropdown($('#addDeviceDisplayType'));

				costSetList();

				$.ajax({
					url: apiHost + apiDeviceSetIds,
					type: 'get',
					async: false,
					data: {
						oid: oid,
						dids: did
					},
					success: (data) => {
						const resultData = data.data[did];
						if (!isEmpty(resultData)) {
							document.querySelectorAll('#alarm_codeList input').forEach(el => {
								if (resultData.includes(Number(el.value))) {
									el.checked = true;
								}
							});

							displayDropdown($('#alarm_code'));
						}
					},
					error: (jqXHR, textStatus, errorThrown) => {
						console.log(textStatus);
					}
				});
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);

				alert('<fmt:message key="deviceState.alert.2" />');
				return false;
			});

			// 설비 정보 수정 팝업창
			$('#addDeviceModal .modal-header').text("<fmt:message key='deviceState.update.title' /> ");
			$('#addDevice').attr('onclick', 'deviceProcess("patch", "' + did + '")').text("<fmt:message key='deviceState.update.button' />");
		} else {
			$('#addDeviceModal .modal-header').text("<fmt:message key='deviceState.register.title' />");
			$('#addDevice').attr('onclick', 'deviceProcess("post")').text("<fmt:message key='deviceState.register.button' />");
		}

		$('#addDeviceModal').modal('show');
	}

	//등록&수정&삭제
	const deviceProcess = (method, did, event) => {
		if (event !== undefined) {
			event.stopPropagation(); //버블링 방지
		}

		let areaData = setAreaParamData('addDeviceModal', 'dropdown');
		let alertPreffix = '등록';
		let urlSufffix = '';

		if (method != 'delete') {

			if (isEmpty(areaData['addSiteList'])) {
				alert('<fmt:message key="deviceState.alert.7" />');
				return false;
			}

			if (isEmpty(areaData['name'].trim())) {
				alert('<fmt:message key="deviceState.alert.8" />');
				return false;
			}

			if (isEmpty(areaData['device_type'])) {
				alert('<fmt:message key="deviceState.alert.9" />');
				return false;
			}

			if (isEmpty(areaData['metering_type'])) {
				alert('<fmt:message key="deviceState.alert.10" />');
				return false;
			}
		}


		if (method == 'patch' || method == 'delete') {
			urlSufffix = '/' + did;

			if (method == 'patch') {
				delete areaData['alarm_codeset'];
				delete areaData['alarm_code'];

				alertPreffix = '수정';
				if (!confirm('<fmt:message key="deviceState.confirm.1" />')) {
					return false;
				}
			}

			if (method == 'delete') {
				alertPreffix = '삭제';
				let delPrompt = prompt('<fmt:message key="deviceState.prompt.1" /> \n<fmt:message key="deviceState.prompt.2" />', '<fmt:message key="deviceState.prompt.answer" />');
				if (delPrompt != '<fmt:message key="deviceState.prompt.answer" />') {
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

			delete areaData['alarm_codeset'];
			delete areaData['alarm_code'];

			areaData['capacity'] = Number(areaData['capacity']) * 1000;
			areaData['capacity_unit'] = 'W';

			if (isEmpty(areaData['parent_did'])) {
				delete areaData['parent_did'];
			}

			delete areaData['addDeviceDisplayType'];
			delete areaData['addSiteList'];
		}

		new Promise(resolve => {
			$.ajax({
				url: apiHost + apiConfigDevices + urlSufffix,
				type: method,
				dataType: 'json',
				async: false,
				contentType: 'application/json',
				data: JSON.stringify(areaData),
				success: (data) => {
					resolve(data);
				}
			});
		}).then(data => {
			return new Promise(resolve => {
				if (method !== 'delete') {
					let setIdsData = new Object();
					let codeSet = new Array();
					$(':checked[name="alarm_codeset"]').each(function() {
						codeSet.push(Number($(this).val()));
					});

					if (!isEmpty(data) && !isEmpty(data.did)) {
						setIdsData = {
							did: data.did,
							set_id: codeSet
						}
					} else {
						setIdsData = {
							did: did,
							set_id: codeSet
						}
					}

					$.ajax({
						url: apiHost + apiDeviceSetIds,
						type: 'post',
						dataType: 'json',
						async: false,
						contentType: 'application/json',
						data: JSON.stringify(new Array(setIdsData)),
						success: (data) => {
							resolve(data);
						}
					});
				} else {
					resolve();
				}
			});
		}).then(() => {
			if (langStatus === 'KO') {
				alert(alertPreffix + ' 되었습니다.');
			} else {
				switch (alertPreffix) {
					case '등록':
						alert('Device has been registerd');
						break;
					case '수정':
						alert('Device has been modified');
						break;
					case '삭제':
						alert('Device has been deleted');
						break;
				}
			}

			$('#addDeviceModal').modal('hide');
			getDeviceList();
			return false;
		}).catch(error => {
			console.error(error);
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
						$(this).parents('.dropdown').find('button').html(text + '<span class="caret"></span>').data('value', rid);
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

	/**
	 * 에러 처리
	 *
	 * @param msg
	 */
	const errorMsg = msg => {
		$("#errMsg").text(msg);
		$("#errorModal").modal("show");
		setTimeout(function(){
			$("#errorModal").modal("hide");
		}, 1800);
	}
</script>