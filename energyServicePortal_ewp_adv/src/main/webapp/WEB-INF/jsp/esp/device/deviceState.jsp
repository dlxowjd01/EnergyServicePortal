<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script src="/js/commonDropdown.js"></script>
<script>
	const siteList = JSON.parse('${siteList}');
	let iderms = null;
	let iderms_oid = "spower";
	let iderms_sid = null;
	//let iderms_login_id = "spadmin";
	//let iderms_password = "11111111";
	let iderms_login_id = "test1111";
	let iderms_password = "test1111";
	let iderms_token = null;
	let iderms_site_list = null;

	$(document).ready(function () {
		iderms = new IdermsClass(iderms_oid, iderms_login_id, iderms_password);
		iderms_token = iderms.postAuthLogin();
		iderms_site_list = JSON.parse('${siteList}');
		
		setInitList('siteULList'); //사업소 리스트 초기화
		siteMakeList(); //사업소 리스트 그리기
		
		if (iderms_site_list != null) {
			putSiteListToPopupAddDeviceSelectBox();
			getDeviceList(iderms_oid);
		}
	});

	// device 추가
	// function addDevice(select_sid, type, name, capacity) {
	function addDevice(select_sid, device) {
		if (confirm("장치를 정말 추가하시겠습니까?")) {
			var result = iderms.postDevices(iderms_oid, select_sid, device); //("dongseo", "72303fa5-990b-44fb-ab7f-8f27a41db446", device);

			if (result != null) {
				alert('장치 추가 성공하였습니다.');
				$("#addDeviceModal").modal("hide");
				getDeviceList(iderms_oid, iderms_sid);
			} else {
				alert('장치 추가 실패하였습니다. 다시 시도해주세요.');
			}
		}
	}

	// device 삭제
	function deleteDevice(did) {
		if (confirm("장치를 정말 삭제하시겠습니까?")) {
			var result = iderms.deleteDevice(iderms_sid, did);

			if (result > 0) {
				alert('장치 삭제 성공하였습니다.');
				getDeviceList(iderms_oid, iderms_sid);
			} else {
				alert('장치 삭제 실패하였습니다. 다시 시도해주세요.');
			}
		}

	}

	function getDeviceTypeName(type) {
		var ret_type = '';

		if (type === "SM") {
			ret_type = "스마트미터";
		} else if (type === "SM_ISMART") {
			ret_type = "한전아이스마트";
		} else if (type === "SM_KPX") {
			ret_type = "전력거래소 계량포털";
		} else if (type === "SM_CRAWLING") {
			ret_type = "데이터 수집기";
		} else if (type === "SM_MANUAL") {
			ret_type = "수기입력";
		} else if (type === "INV_PV") {
			ret_type = "태양광 인버터";
		} else if (type === "INV_WIND") {
			ret_type = "풍력 인버터";
		} else if (type === "PCS_ESS") {
			ret_type = "ESS PCS";
		} else if (type === "BMS_SYS") {
			ret_type = "BMS 시스템";
		} else if (type === "BMS_RACK") {
			ret_type = "BMS 랙";
		} else if (type === "SENSOR_SOLAR") {
			ret_type = "태양광 센서";
		} else if (type === "SENSOR_FLAME") {
			ret_type = "불꽃 감지 센서";
		} else if (type === "SENSOR_TEMP_HUMIDITY") {
			ret_type = "온습도 센서";
		} else if (type === "CCTV") {
			ret_type = "CCTV";
		} else if (type === "COMBINER_BOX") {
			ret_type = "태양광 접속반";
		} else if (type === "CIRCUIT_BREAKER") {
			ret_type = "회로 차단기";
		}

		return ret_type;
	}

	// device 리스트 만들기
	function getDeviceList(oid, sid) {
		let myMap = new Map();
		myMap.set('INV_PV', new Array());
		
		const siteArray = $.makeArray($(':checkbox[name="site"]:checked').map(
			function () {
				return $(this).val();
			}
			)
		);

		var result = null; //iderms.getDevices(oid, sid);

		if (siteArray.length > 0) {
			if (iderms_site_list != null && iderms_site_list.length > 0) {
				for (var i = 0; i < iderms_site_list.length; i++) {
					
					sid = iderms_site_list[i].sid;
					if ($.inArray(sid, siteArray) >= 0) {
						
						result = iderms.getDevices(oid, sid);
						for (var k = 0; k < result.length; k++) {
							
							if (myMap.has(result[k].device_type)) {
								
								let array = myMap.get(result[k].device_type);
								array.push(result[k]);
								
							} else {
								
								let arr = new Array();
								arr.push(result[k]);
								myMap.set(result[k].device_type, arr);
								
							}
							
						}
						
					}
					
				}
			}
		}
		

		var $eqListDiv = $(".row.scroll").find(".col-lg-12");
		$eqListDiv.empty();

		myMap.forEach(function (value, key) {

			let deviceTypeName = getDeviceTypeName(key);

			let normalCnt = 0;
			let errorCnt = 0;
			let tripCnt = 0;

			let deviceType = key;
			let list = value;

			let first_did = null;

			let strFor = "";

			for (var i = 0; i < list.length; i++) {

				var deviceInfo = iderms.getStatusRaw(list[i].did);
				// console.log(deviceInfo);
				// console.log(deviceInfo[list[i].did].data.length);

				if (deviceInfo[list[i].did].data.length > 0) {
					if (deviceInfo[list[i].did].data[0].operation == 0) {
						errorCnt += 1;
					} else if (deviceInfo[list[i].did].data[0].operation == 1) {
						normalCnt += 1;
					} else if (deviceInfo[list[i].did].data[0].operation == 2) {
						tripCnt += 1;
					}
				}


				if (deviceInfo.alertLevel == 0) strFor += '<li data-dvType="' + deviceType + '" data-did="' + list[i].did + '" onclick="deviceDetailView(\'' + list[i].did + '\')">';
				else if (deviceInfo.alertLevel == 1) strFor += '<li class="st_error" data-dvType="' + deviceType + '" data-did="' + list[i].did + '" onclick="deviceDetailView(\'' + list[i].did + '\')">';
				else if (deviceInfo.alertLevel == 2) strFor += '<li class="st_alert" data-dvType="' + deviceType + '" data-did="' + list[i].did + '" onclick="deviceDetailView(\'' + list[i].did + '\')">';
				else if (deviceInfo.alertLevel == 3) strFor += '<li class="st_alert" data-dvType="' + deviceType + '" data-did="' + list[i].did + '" onclick="deviceDetailView(\'' + list[i].did + '\')">';
				else strFor += '<li data-dvType="' + deviceType + '" data-did="' + list[i].did + '" onclick="deviceDetailView(\'' + list[i].did + '\')">';
				strFor += '	<a href="#none"></a>';
				strFor += '	<span style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">' + list[i].name + '</span>';
				strFor += '	<span>' + ((isEmpty(list[i].capacity)) ? '-' : list[i].capacity) + ((isEmpty(list[i].capacity_unit)) ? '' : list[i].capacity_unit) + '</span>';

				if (deviceInfo[list[i].did].device_type == "INV_PV") {
					if (!isEmpty(deviceInfo[list[i].did].data)) {
						var acPowerMap = null,
							dcPowerMap = null;
						var acPower = "-",
							dcPower = "-";
						var acPowerUnit = "",
							dcPowerUnit = "";
						if (!isEmpty(deviceInfo[list[i].did].data[0].acPower)) {
							acPowerMap = convertUnitFormat(deviceInfo[list[i].did].data[0].acPower, "W");
							acPower = toFixedNum(acPowerMap.get("formatNum"), 1);
							acPowerUnit = acPowerMap.get("unit");
						}
						if (!isEmpty(deviceInfo[list[i].did].data[0].dcPower)) {
							dcPowerMap = convertUnitFormat(deviceInfo[list[i].did].data[0].dcPower, "W");
							dcPower = toFixedNum(dcPowerMap.get("formatNum"), 1);
							dcPowerUnit = dcPowerMap.get("unit");
						}
						strFor += '	<em>' + acPower + acPowerUnit + '&nbsp;' + dcPower + dcPowerUnit + '</em>';
					} else {
						strFor += '	<em>' + '-' + '&nbsp;' + '-' + '</em>';
					}
				}

				strFor += '	<button type="button" onclick="javascript:deleteDevice(\'' + list[i].did + '\');">삭제</button>';
				strFor += '</li>';

				if (i == 0) {
					first_did = list[i].did;
				}
			}

			let liStr = "";
			liStr += '<div class="row">';
			liStr += '<div class="col-lg-8">';
			liStr += '<div class="indiv clear">';
			liStr += '	<div class="chart_top clear">';
			liStr += '		<h2 class="ntit fl">' + deviceTypeName + '</h2>';
			liStr += '		<div class="eq_icon fr">';
			liStr += '			<span class="eq_normail">정상(' + normalCnt + ')</span>';
			liStr += '			<span class="eq_alert">중지(' + errorCnt + ')</span>';
			liStr += '			<span class="eq_error">트립(' + tripCnt + ')</span>';
			liStr += '		</div>';
			liStr += '	</div>';
			if (deviceType == "INV_PV") liStr += '	<ul class="eq_list scroll eq_li_type01">';
			else liStr += '	<ul class="eq_list scroll eq_li_type02">';

			liStr += strFor;

			liStr += '			<li class=\"eq_add\">';
			liStr += '				<a href="javascript:addDeviceForm(' + '\'' + deviceType + '\'' + ',' + '\'' + sid + '\'' + initModalForm + ');">추가</a>';
			liStr += '			</li>';
			liStr += '		</ul>';
			liStr += '	</div>';
			liStr += '</div>';

			// 상세조회 영역
			liStr += '<div class="col-lg-4" data-dvType="' + deviceType + '">';
			liStr += '	<div class="indiv eq_card">';
			liStr += '		<div class="chart_top clear">';
			liStr += '			<h2 class="ntit fl">&nbsp;</h2>';
			liStr += '		</div>';
			liStr += '		<ul class="eq_card_ul clear">';
			liStr += '			<li><p class="t_ti"></p><p class="t_value">-</p></li>';
			liStr += '			<li><p class="t_ti"></p><p class="t_value">-</p></li>';
			liStr += '			<li><p class="t_ti"></p><p class="t_value">-</p></li>';
			liStr += '		</ul>';
			liStr += '		<div class="inv_sec_bx">';
			liStr += '			<p class="inv_tit">장치 현황</p>';
			liStr += '			<ul class="isb_in clear">';
			liStr += '				<li>';
			liStr += '					<ul class="di_list">';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '						</li>';
			liStr += '					</ul>';
			liStr += '				</li>';
			liStr += '				<li>';
			liStr += '					<ul class="di_list">';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '						<li><span class="di_li_tit"></span><span class="di_li_tx">-</span></li>';
			liStr += '					</ul>';
			liStr += '				</li>';
			liStr += '			</ul>';
			liStr += '		</div>';
			liStr += '		<div class="eq_btn_bx">';
			liStr += '			<button type="button" class="btn_type04">변경 이력 조회</button>';
			liStr += '			<button type="button" class="btn_type04">운영 이력 조회</button>';
			liStr += '		</div>';
			liStr += '	</div>';
			liStr += '</div>';

			$eqListDiv.append(liStr);

		});
	}

	//site 리스트를 popup add device selectbox에 담기
	function putSiteListToPopupAddDeviceSelectBox() {
		const $tbody = $('#addDeviceSite');
		$tbody.empty();
		let tbodyStr = ``;

		if (iderms_site_list != null && iderms_site_list.length > 0) {
			for (var i = 0; i < iderms_site_list.length; i++) {
				if (i == 0) {
					tbodyStr += '<option value=\"' + iderms_site_list[i].sid + '\" selected>';
					tbodyStr += iderms_site_list[i].name;
					tbodyStr += '</option>';
				} else {
					tbodyStr += '<option value=\"' + iderms_site_list[i].sid + '\">';
					tbodyStr += iderms_site_list[i].name;
					tbodyStr += '</option>';
				}
			}

		} else {
			$('#addDeviceSite').empty();
		}

		$tbody.append(tbodyStr);
	}
	
	//사업소 조회
	const siteMakeList = () => {
		setMakeList(iderms_site_list, 'siteULList', {'dataFunction': {}}); //list생성
	};
	
	const rtnDropdown = function ($selectId) {
		if ($selectId == 'site_list1') {
			getDeviceList(iderms_oid);
			
			let site_name = '';

//			사이트 복수 체크 가능하여 해당 기능 수정 필요
// 			const $tbody = $('#site_list_id');
// 			$tbody.empty();
// 			let tbodyStr = ``;
// 			tbodyStr += site_name;
// 			tbodyStr += '<span class="caret"></span></button>';
// 			$tbody.append(tbodyStr);
		}
	}
</script>
<script type="text/javascript">

	// 안쓰이고 있음!!!!!
	function callback_getSiteDeviceList(result) {
		var deviceTypeList = result.deviceTypeList; // 설비타입리스트
		var $eqListDiv = $(".row.eq_wrap").find(".col-lg-12");
		$eqListDiv.empty();

	}

	function initModalForm() {
		console.log("form init triggered====");
		const optList = $('#');
		let deviceOpts = ``;

		for (let i = 0; i < deviceList.length; i++) {
			if (i === 0) {
				deviceOpts += '<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="site_list_id">';
				deviceOpts += deviceList[i].name;
				deviceOpts += '<span class=' + "caret" + '></span></button>';
				deviceOpts += '<ul class="dropdown-menu">';
				deviceOpts += '<li class="on"><a href="#">전체</a></li>';
				deviceOpts += '<li><a href="#">';
				deviceOpts += deviceList[i].name;
				deviceOpts += '</a></li>';
			} else {
				deviceOpts += '<li><a href="#">';
				deviceOpts += deviceList[i].name;
				deviceOpts += '</a></li>';
			}
		}
		deviceOpts += '</ul>';
	}
	function addDeviceForm(devicetype, sid, callback) {
		$('#addDeviceSite').val(sid).attr("selected", "selected");
		$('#addDeviceType').val(devicetype).attr("selected", "selected");

		$("#deviceForm1")[0].reset();
		callback();
	}

	function deviceDetailView(did) {
		var result = iderms.getStatusRaw(did);
		var device_type = result[did].device_type;
		var dname = result[did].dname;
		if (result[did].data.length != 0) {
			var data = result[did].data[0];

			var alertLevel = 0;
			var divStr = "";
			divStr += '	<div class="indiv eq_card">';
			divStr += '		<div class="chart_top clear">';
			divStr += '			<h2 class="ntit fl">' + dname + '</h2>';
			divStr += '		</div>';
			divStr += '		<ul class="eq_card_ul clear">';
			if (device_type == "INV_PV") {
				divStr += '			<li><p class="t_ti">순시전력</p><p class="t_value">' + ((isEmpty(data.activePower)) ? '-' : displayNumberFixedDecimal((data.activePower), "W").join("")) + '</p></li>';
				divStr += '			<li><p class="t_ti">DC전력</p><p class="t_value">' + ((isEmpty(data.dcPower)) ? '-' : displayNumberFixedDecimal((data.dcPower), "W").join("")) + '</p></li>';
				divStr += '			<li><p class="t_ti">누적발전량</p><p class="t_value">' + ((isEmpty(data.accumActiveEnergy)) ? '-' : displayNumberFixedDecimal(data.accumActiveEnergy, "Wh").join("")) + '</p></li>';
			} else if (device_type == "SENSOR_SOLAR") {
				divStr += '			<li><p class="t_ti">모듈온도</p><p class="t_value">' + ((isEmpty(data.temperature)) ? '-' : (data.temperature).toFixed(2)) + '℃</p></li>';
				divStr += '			<li><p class="t_ti">경사면 일사량</p><p class="t_value">' + ((isEmpty(data.irradiationPoa)) ? '-' : displayNumberFixedDecimal(data.irradiationPoa, "W").join("")) + '/㎡</p></li>';
				divStr += '			<li><p class="t_ti">수평면 일사량</p><p class="t_value">' + ((isEmpty(data.irradiationHorizontal)) ? '-' : displayNumberFixedDecimal(data.irradiationHorizontal, "W").join("").concat('/㎡')) + '</p></li>';
			} else {
				divStr += '			<li><p class="t_ti">DCU 전체 전압</p><p class="t_value">' + '0' + '</p></li>';
				divStr += '			<li><p class="t_ti">DCU 전체 전류</p><p class="t_value">' + '0' + '</p></li>';
				divStr += '			<li><p class="t_ti">금일 발전량 출력</p><p class="t_value">-</p></li>';
			}
			divStr += '		</ul>';
			divStr += '		<div class="inv_sec_bx">';
			divStr += '			<p class="inv_tit">' + dname + ' 현황</p>';
			divStr += '			<ul class="isb_in clear">';
			if (device_type == "INV_PV") {
				divStr += '				<li>';
				divStr += '					<ul class="di_list">';
				divStr += '						<li><span class="di_li_tit">R전압</span><span class="di_li_tx">' + ((isEmpty(data.voltageR)) ? '-' : data.voltageR) + 'V</span></li>';
				divStr += '						<li><span class="di_li_tit">S전압</span><span class="di_li_tx">' + ((isEmpty(data.voltageS)) ? '-' : data.voltageS) + 'V</span></li>';
				divStr += '						<li><span class="di_li_tit">T전압</span><span class="di_li_tx">' + ((isEmpty(data.voltageT)) ? '-' : data.voltageT) + 'V</span></li>';
				divStr += '						<li><span class="di_li_tit">주파수</span><span class="di_li_tx">' + ((isEmpty(data.frequency)) ? '-' : data.frequency) + 'Hz</span></li>';
				divStr += '						</li>';
				divStr += '					</ul>';
				divStr += '				</li>';
				divStr += '				<li>';
				divStr += '					<ul class="di_list">';
				divStr += '						<li><span class="di_li_tit">R전류</span><span class="di_li_tx">' + ((isEmpty(data.currentR)) ? '-' : toFixedNum(data.currentR, 1)) + 'A</span></li>';
				divStr += '						<li><span class="di_li_tit">S전류</span><span class="di_li_tx">' + ((isEmpty(data.currentS)) ? '-' : toFixedNum(data.currentS, 1)) + 'A</span></li>';
				divStr += '						<li><span class="di_li_tit">T전류</span><span class="di_li_tx">' + ((isEmpty(data.currentT)) ? '-' : toFixedNum(data.currentT, 1)) + 'A</span></li>';
				divStr += '						<li><span class="di_li_tit">온도</span><span class="di_li_tx">' + ((isEmpty(data.temperature)) ? '-' : data.temperature) + '℃</span></li>';
				divStr += '					</ul>';
				divStr += '				</li>';
			} else if (device_type == "SENSOR_SOLAR") {
				divStr += '				<li>';
				divStr += '					<ul class="di_list">';
				divStr += '						<li><span class="di_li_tit">누적 경사면 일사량</span><span class="di_li_tx">' + ((isEmpty(data.accumIrradiationPoa)) ? '-' : displayNumberFixedDecimal(data.accumIrradiationPoa, "Wh").join("").concat('/㎡')) + '</span></li>';
				divStr += '						<li><span class="di_li_tit">누적 수평면 일사량</span><span class="di_li_tx">' + ((isEmpty(data.accumIrradiationHorizontal)) ? '-' : displayNumberFixedDecimal(data.accumIrradiationHorizontal, "Wh").join("").concat('/㎡')) + '</span></li>';
				divStr += '						</li>';
				divStr += '					</ul>';
				divStr += '				</li>';
			} else {
				divStr += '				<li>';
				divStr += '					<ul class="di_list">';
				divStr += '						<li><span class="di_li_tit">주변온도</span><span class="di_li_tx">' + '0' + '</span></li>';
				divStr += '						<li><span class="di_li_tit">경사면 일사량</span><span class="di_li_tx">' + '0' + 'kWh/㎡.day</span></li>';
				divStr += '						<li><span class="di_li_tit">수평 일사량</span><span class="di_li_tx">' + '0' + 'kWh/㎡.day</span></li>';
				divStr += '						</li>';
				divStr += '					</ul>';
				divStr += '				</li>';
			}
			divStr += '			</ul>';
			divStr += '		</div>';
			divStr += '		<div class="eq_btn_bx">';
			divStr += '			<button type="button" class="btn_type04">변경 이력 조회</button>';
			divStr += '			<button type="button" class="btn_type04">운영 이력 조회</button>';
			divStr += '		</div>';
			divStr += '	</div>';

			$('.col-lg-4[ data-dvType="' + device_type + '"]').empty().append(divStr);
		} else {
			alert("해당 장치에 유효한 데이터가 없습니다.");
		}

	}
</script>

<form id="schForm" name="schForm">
	<input class="input tx_inp_type" type="hidden" id="startTime" name="startTime" />
	<input class="input tx_inp_type" type="hidden" id="endTime" name="endTime" />
	<input class="input tx_inp_type" type="hidden" id="selTerm" name="selTerm" value="day" />
	<input class="input tx_inp_type" type="hidden" id="timeOffset" name="timeOffset" />
	<input class="input tx_inp_type" type="hidden" id="siteId" name="siteId" />
	<input class="input tx_inp_type" type="hidden" id="renewTypeCode" name="essTypeCode" />
	<input class="input tx_inp_type" type="hidden" id="period" name="period" />
</form>
<script type="text/javascript">
	function getSiteMainSchCollection(termType) { //api에 맞게 수정필요
		//	$("#timeOffset").val( (new Date()).getTimezoneOffset() );
		$("#timeOffset").val(timeOffset);

		// 기간 필터
		const today = new Date();
		let startDate, endDate, lastDay = "";
		if (termType === 'day') {
			// 오늘 00시 ~ 오늘 23시 59분
			// 데이터가 비어도 오늘 치는 다 나오므로 괜찮을 듯.
			startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0);
			endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 23, 59, 59);
			$("#selTerm").val("day");
		} else if (termType === 'week') {
			// 시간 정보 000000 한 다음에 findWeek에서 연월일 가져와서 설정
			const weekSub = (today.getDay() === 0) ? 6 : today.getDay() - 1;
			const weekPls = (today.getDay() === 0) ? 0 : 7 - today.getDay();
			startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() - weekSub);
			endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + weekPls, 23, 59, 59);
			$("#selTerm").val("week");
		} else if (termType === 'month') {
			// 이번달 1일 000000 부터
			startDate = new Date(today.getFullYear(), today.getMonth(), 1);
			lastDay = (new Date(today.getFullYear(), today.getMonth() + 1, 0)).getDate();
			endDate = new Date(today.getFullYear(), today.getMonth(), lastDay, 23, 59, 59);
			$("#selTerm").val("month");
		} else if (termType === 'year') {
			// 이번년 1일 000000 부터
			startDate = new Date(today.getFullYear(), 0, 1);
			endDate = new Date(today.getFullYear(), 11, 31, 23, 59, 59);
			$("#selTerm").val("year");
		}

		startDate = startDate.format("yyyyMMddHHmmss");
		endDate = endDate.format("yyyyMMddHHmmss");

		$("#startTime").val(startDate);
		$("#endTime").val(endDate);

		return $("#schForm").serializeObject();
	}
</script>
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
<div class="row content-wrapper">
	<div class="col-lg-3 col-md-4 col-sm-6">
		<div class="header_drop_area w_type">
			<div class="dropdown" id="site_list1">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택해주세요.">
					선택해주세요.<span class="caret"></span>
				</button>
				<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="siteULList">
					<li data-value="[sid]">
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="site_[INDEX]" value="[sid]" name="site">
							<label for="site_[INDEX]"><span></span>[name]</label>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="row scroll">
	<div class="col-lg-12">
		<div class="row">
			<div class="col-lg-8">
				<div class="indiv clear">
					<div class="chart_top clear">
						<h2 class="ntit fl"></h2>
						<div class="eq_icon fr">
							<span class="eq_normail">정상(0)</span>
							<span class="eq_alert">중지(0)</span>
							<span class="eq_error">트립(0)</span>
						</div>
					</div>
					<ul class="eq_list scroll eq_li_type01">
					</ul>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="indiv eq_card">
					<div class="chart_top clear">
						<h2 class="ntit fl"></h2>
					</div>
					<ul class="eq_card_ul clear">
					</ul>
					<div class="inv_sec_bx">
						<p class="inv_tit"></p>
						<ul class="isb_in clear">
							<li>
								<ul class="di_list">
								</ul>
							</li>
							<li>
								<ul class="di_list">
								</ul>
							</li>
						</ul>
					</div>
					<div class="eq_btn_bx">
						<button type="submit" class="btn_type04">변경 이력 조회</button>
						<button type="submit" class="btn_type04">운영 이력 조회</button>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-8">
				<div class="indiv clear">
					<div class="chart_top clear">
						<h2 class="ntit fl"></h2>
						<div class="eq_icon fr">
							<span class="eq_normail">정상(0)</span>
							<span class="eq_alert">중지(0)</span>
							<span class="eq_error">트립(0)</span>
						</div>
					</div>
					<ul class="eq_list scroll clear eq_li_type02">
					</ul>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="indiv eq_card t2">
					<div class="chart_top clear">
						<h2 class="ntit fl"></h2>
					</div>
					<ul class="eq_card_ul clear">
					</ul>
					<div class="inv_sec_bx">
						<p class="inv_tit"></p>
						<ul class="isb_in clear">
							<li>
								<ul class="di_list">
								</ul>
							</li>
						</ul>
					</div>
					<div class="eq_btn_bx">
						<button type="submit" class="btn_type04">변경 이력 조회</button>
						<button type="submit" class="btn_type04">운영 이력 조회</button>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-8">
				<div class="indiv clear">
					<div class="chart_top clear">
						<h2 class="ntit fl"></h2>
						<div class="eq_icon fr">
							<span class="eq_normail">정상(0)</span>
							<span class="eq_alert">중지(0)</span>
							<span class="eq_error">트립(0)</span>
						</div>
					</div>
					<ul class="eq_list scroll clear eq_li_type03">
					</ul>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="indiv eq_card t3">
					<div class="chart_top clear">
						<h2 class="ntit fl"></h2>
					</div>
					<ul class="eq_card_ul clear">
					</ul>
					<div class="inv_sec_bx">
						<p class="inv_tit"></p>
						<ul class="isb_in clear">
							<li>
								<ul class="di_list">
								</ul>
							</li>
							<li>
								<ul class="di_list">
								</ul>
							</li>
						</ul>
					</div>
					<div class="eq_btn_bx">
						<button type="submit" class="btn_type04">변경 이력 조회</button>
						<button type="submit" class="btn_type04">운영 이력 조회</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="addDeviceModal" role="dialog">
	<div class="modal-dialog modal-lg">
		<div class="modal-content device_modal_content">
			<div class="modal-header stit">
				<h2>신규 장치 등록</h2>
			</div>
			<div class="modal-body">
				<form id="deviceForm1" action="#" method="post" name="deviceForm" novalidate>
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">사업소</label>
								<div class="dropdown" id="siteName">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown"></button>
									<ul class="dropdown-menu dropdown-menu-form">
									</ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name mr-10" class="input_label">장치명</label>
								<input class="input tx_inp_type" type="text" name="deviceName" id="addDeviceName">
							</div>
							<div class="input-group inline-flex">
								<label for="site_name mr-10" class="input_label">장치 타입</label>
								<div id="deviceType" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">계량 유형</label>
								<div id="siteName" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">설비 용량(kW)</label>
								<input class="input tx_inp_type" type="text" name="deviceCapacity"
									id="addDeviceCapacity">
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">제조사</label>
								<input class="input tx_inp_type" type="text" name="deviceManufacturer"
									id="addDeviceManufacturer">
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceManager" class="input_label">담당자</label>
								<input class="input tx_inp_type" type="text" name="deviceManager" id="addDeviceManager">
							</div>
							<div class="input-group inline-flex">
								<label for="" class="input_label">알림 코드</label>
								<div id="siteName" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form"></ul>
								</div>
							</div>
						</div>
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex chk_type">
								<label class="input_label">예측</label>
								<input class="styled-checkbox" id="predictionData" type="checkbox" value="1"
									name="predicted">
								<label class="styled-checkbox-label" for="predictionData"><span></span></label>
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceSerialID" class="input_label">장치 ID</label>
								<div id="addDeviceSerialID" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">상위 장치</label>
								<div id="advancedDevice" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceDisplayType" class="input_label">표시 유형</label>
								<input class="input tx_inp_type" type="text" name="deviceDisplayType"
									id="addDeviceDisplayType">
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceProductName" class="input_label">제품명</label>
								<input class="input tx_inp_type" type="text" name="productName"
									id="addDeviceProductName">
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceContact" class="input_label">담당자 연락처</label>
								<input class="input tx_inp_type" type="text" name="addDeviceContact"
									id="addDeviceContact">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="site_name mr-10" class="input_label">설명</label>
								<textarea name="addDeviceDescription" id="addDeviceDescription"
									class="textarea"></textarea>
							</div>
						</div>
					</div>
				</form>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal">취소</button>
					<button type="submit" class="btn_type" id="registerBtn">등록</button>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="manualAddModal" role="dialog">
	<div class="modal-dialog modal-lg">
		<div class="modal-content device_modal_content">
			<div class="modal-header stit">
				<h2>수기 입력</h2>
			</div>
			<div class="modal-body">
				<form id="deviceForm2" action="#" method="post" name="deviceForm" novalidate>
					<div class="row">
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">사업소</label>
								<div id="siteName" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name mr-10" class="input_label">장치명</label>
								<input class="input tx_inp_type" type="text" name="deviceName" id="addDeviceName">
							</div>
							<div class="input-group inline-flex">
								<label for="site_name mr-10" class="input_label">장치 타입</label>
								<div id="siteName" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">계량 유형</label>
								<div id="siteName" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">설비 용량(kW)</label>
								<input class="input tx_inp_type" type="text" name="deviceCapacity"
									id="addDeviceCapacity">
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">제조사</label>
								<input class="input tx_inp_type" type="text" name="deviceManufacturer"
									id="addDeviceManufacturer">
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceManager" class="input_label">담당자</label>
								<input class="input tx_inp_type" type="text" name="deviceManager" id="addDeviceManager">
							</div>
							<div class="input-group inline-flex">
								<label for="" class="input_label">알림 코드</label>
								<div id="siteName" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
								</div>
							</div>
						</div>
						<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12">
							<div class="input-group inline-flex chk_type">
								<label class="input_label">예측</label>
								<input class="styled-checkbox" id="predictionData" type="checkbox" value="1"
									name="predicted">
								<label class="styled-checkbox-label" for="predictionData"><span></span></label>
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceSerialID" class="input_label">장치 ID</label>
								<div id="addDeviceSerialID" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">상위 장치</label>
								<div id="siteName" class="dropdown">
									<button class="btn btn-primary dropdown-toggle" type="button"
										data-toggle="dropdown">
										선택해주세요.<span class="caret"></span>
									</button>
									<ul class="dropdown-menu dropdown-menu-form chk_type"></ul>
								</div>
							</div>
							<div class="input-group inline-flex">
								<label for="site_name" class="input_label">표시 유형</label>
								<input class="input tx_inp_type" type="text" name="" id="site_name">
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceProductName" class="input_label">제품명</label>
								<input class="input tx_inp_type" type="text" name="productName"
									id="addDeviceProductName">
							</div>
							<div class="input-group inline-flex">
								<label for="addDeviceContact" class="input_label">담당자 연락처</label>
								<input class="input tx_inp_type" type="text" name="addDeviceContact"
									id="addDeviceContact">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="input-group inline-flex">
								<label for="site_name mr-10" class="input_label">설명</label>
								<textarea name="addDeviceDescription" id="addDeviceDescription"
									class="textarea"></textarea>
							</div>
						</div>
					</div>
				</form>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal">취소</button>
					<button type="submit" class="btn_type" id="registerBtn">등록</button>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	$(function () {
		$("#registerBtn").click(function () {
			checkAddDevice();
			return false;
		});
	});

	function checkAddDevice() {
		if (emptyAlert('#addDeviceName')) {
			alert('장치명을 입력하세요');
			return;
		}
		if (emptyAlert('#addDeviceCapacity')) {
			alert('용량값을 입력하세요');
			return;
		}

		// 참고용!! 아래부터는 주석 삭제하지 말아주세요.
		var select_device_type = document.getElementById("addDeviceType");
		var select_site = document.getElementById("addDeviceSite");
		var select_displaytype = document.getElementById("addDeviceDisplayType"); // 표시 유형 : 대시보드, 매전량 (중복선택 or optional)
		var display_val = select_displaytype.options[select_displaytype.selectedIndex].value;
		let device_name = $('#addDeviceName').val();
		let device_parent_did = null; // 상위 장치 : 장치타입  BMS_SYS=>PCS리스트 중 선택,  BMS_RACK=> BMS_SYS리스트 중 선택
		let device_type = select_device_type.options[select_device_type.selectedIndex].value; // 장치 타입: device_properties.json 타입들
		let metering_type = 0; // 계량 유형 0: 계량 안함,  1: 소비, 2: 발전, 3: 충방전 (single selction)
		let dashboard;
		let billing;

		if (display_val == 1) {
			dashboard = true;
			billing = false;
		} else if (display_val == 2) {
			dashboard = false;
			billing = true;
		} else {
			dashboard = false;
			billing = false;
		}

		let forecasting = false; // 예측은 계량 유형이 1,2 소비 발전일 때만 보임
		let detecting = false;
		let capacity = Number($('#addDeviceCapacity').val()); // 설비 용량
		let capacity_unit = "kW"; // 설비 용량 단위
		let product_name = $('#addDeviceProductName').val(); // 제품명
		let manufacturer = $('#addDeviceManufacturer').val(); // 제조사
		let serial_id = $('#addDeviceSerialID').val(); //시리얼 ID
		let manager = $('#addDeviceManager').val(); // 담당자
		let contact = $('#addDeviceContact').val(); // 담당자 연락처
		let alarm_code = "alarm"; // 알람코드 리스트 (api 선택)
		let description = $('#addDeviceDescription').val(); // 메모

		var device = new idermsDevice(device_name, device_parent_did, device_type, metering_type, dashboard, billing, forecasting, detecting, capacity, capacity_unit, product_name, manufacturer, serial_id, manager, contact, alarm_code, description);
		addDevice(select_site.options[select_site.selectedIndex].value, device);

	}

	function emptyAlert(index) {
		if ($(index).val() === '') {
			return true;
		}
	}
</script>