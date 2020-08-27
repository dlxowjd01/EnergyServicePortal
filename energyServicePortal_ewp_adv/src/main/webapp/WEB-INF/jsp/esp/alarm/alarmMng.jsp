<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">알람</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv minvh">
			<div class="set_top clear">
				<h2 class="ntit fl">알람 메시지 레벨 설정</h2>
			</div>
			<div class="nsearch clear">
				<div class="fl">
					<div class="select" id="deviceType">
						<a href="#">설비 타입</a>
						<ul class="inq">
						</ul>
					</div>
				</div>
				<div class="fl">
					<div class="select" id="manufacturer">
						<a href="#">제조사</a>
						<ul class="inq">
						</ul>
					</div>
				</div>
				<div class="fl">
					<div class="select" id="modelList">
						<a href="#">모델명</a>
						<ul class="inq">
						</ul>
					</div>
				</div>
				<div class="fl">
					<select name="schVersion" id="schVersion" class="sel">
						<option value="">펌웨어버전</option>
					</select>
				</div>
				<div class="fl ml10">
					<button type="button" class="fl dbtn dark" id="schBtn">조회</button>
					<!-- <button type="button" class="fl ml10 dbtn gray" id="deleteBtn">삭제</button> -->
				</div>
			</div>
			<div class="s_tbl mt10">
				<table id="alarmLevelTable">
					<colgroup>
						<col width="50">
						<col width="80">
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox"></th>
							<th>NO</th>
							<!-- <th>설비타입</th>
							<th>제조사</th>
							<th>펌웨어 버전</th>
							<th>에러 코드</th>
							<th>메세지</th>
							<th>알람 레벨</th>
							<th>추가 정보</th> -->
							<th>알람 코드 셋</th>
							<th>설비타입</th>
							<th>제조사</th>
							<th>모델명</th>
							<th>펌웨어 버전</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>

			<div class="btn_right">
				<ul>
					<!-- <li><button type="button" class="dbtn gray" id="excelUploadBtn">엑셀 업로드</button></li>
					<li><button type="button" class="dbtn gray" id="excelDownloadBtn">엑셀 내보내기</button></li>
					<li><button type="button" class="dbtn" id="applyAlarmBtn">적용</button></li> -->
					<li><button type="button" id="addCodeSet" class="dbtn">추가</button></li>
					<li><button type="button" id="updtCodeSet" class="dbtn">수정</button></li>
					<li><button type="button" id="deleteCodeSet" class="dbtn gray">삭제</button></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<!-- ###### Popup Start ###### -->
<div id="layerbox" class="msg_code" style="min-width:1000px; min-height:700px;">
    <div class="stit">
        <h2>알람 메시지 코드</h2>
        <a href="javascript:popupClose('msg_code');">닫기</a>
    </div>
	<div class="lbody mt30">
		<div class="">
			<div class="nsearch mt20 clear">
				<div class="fl"><span>알람 코드 셋 명</span></div>
				<div class="fl ml10" id="alarmSetName">

				</div>
				<div class="fr clear">
					<div class="fl"><button type="file" class="dbtn dark" onclick="document.getElementById('excelUploadBtn').click();">엑셀 불러오기</button></div>
					<input type="file" id="excelUploadBtn" style="display : none;"/>
					<div class="fl ml10"><button type="button" class="dbtn dark" id="excelDownloadBtn">엑셀 내보내기</button></div>
				</div>
			</div>

			<div class="s_tbl mt10">
				<table id="codeTable">
					<colgroup>
						<col width="50">
						<col width="80">
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox"></th>
							<th>NO</th>
							<th>설비타입</th>
							<th>제조사</th>
							<th>펌웨어 버전</th>
							<th>에러 코드</th>
							<th>메세지</th>
							<th>알람 레벨</th>
							<th>추가 정보</th>
							<th></th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>

		</div>
	</div>
    <div class="btn_center">
		<a href="#;" class="dbtn" id="insertCodeSet">적용</a>
		<a href="javascript:popupClose('msg_code');" class="dbtn gray">취소</a>
	</div>
</div>
<!-- ###### Popup End ###### -->

	<script type="text/javascript">
	var apiURL = gIderms_URL;
	var oid = gIderms_OID;
	var fileJSON;
	var excelArray = [];
	var schAlarmMsgListUnder = [];
	var update_deleteArr = [];
	var update_updateArr = [];
	var schAlarmMsgList = new Array();
	var deviceTemplate = {
			'SM': '스마트미터',
			'SM_ISMART': '한전 아이스마트',
			'SM_KPX': '전력거래소 계량포털',
			'SM_CRAWLING': '데이터 수집기',
			'SM_MANUAL': '수기 입력',
			'INV_PV': '태양광 인버터',
			'INV_WIND': '풍력 인버터',
			'PCS_ESS': 'ESS PCS',
			'BMS_SYS': 'BMS 시스템',
			'BMS_RACK': 'BMS 랙',
			'SENSOR_SOLAR': '태양광 센서',
			'SENSOR_FRAME': '불꽃 센서',
			'SENSOR_TEMP_HUMIDITY': '온습도 센서',
			'CCTV': 'CCTV'
	};

	var levelTemplate = {
			9: '알수없음',
			0: '정보',
			1: '경고',
			2: '이상',
			3: '트립',
			4: '긴급'
	};

	$(function(){
		initPage();

		jQuery.browser = {};
		(function () {
		    jQuery.browser.msie = false;
		    jQuery.browser.version = 0;
		    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
		        jQuery.browser.msie = true;
		        jQuery.browser.version = RegExp.$1;
		    }
		})();
		//사이트 선택 시
		$(document).on('click', ':checkbox[name="deviceType"]', function(e) {
			filteringManufList = new Array();
			$("#modelList  ul").empty();
			$("#schVersion").empty().append('<option value="">펌웨어버전</option>');
			getFiltering('deviceType');
		});

		//제조사 선택 시
		$(document).on('click', ':checkbox[name="manuf"]', function(e) {
			filteringModelList = new Array();
			$("#schVersion").empty().append('<option value="">펌웨어버전</option>');
			getFiltering('manufacturer');
		});

		//모델명 선택 시
		$(document).on('click', ':checkbox[name="model"]', function(e) {
			filteringVersionList = new Array();
			getFiltering('model');
		});

		// 조회 버튼
		$("#schBtn").on("click", function() {
			schAlarmList();
		});

		// 알람목록 헤더 체크박스
		$("#alarmLevelTable thead input:checkbox").on("click", function() {
			var checked = $(this).is(":checked");

			if (checked == true) {
				$(':checkbox[name="almMsgApplyYn"]').prop('checked', true);
			} else {
				$(':checkbox[name="almMsgApplyYn"]').prop('checked', false);
			}
		});

		// 엑셀 업로드 버튼
		$("#excelUploadBtn").on("change", function(evt) {

			 var reader = new FileReader();

		    reader.onload = function(e){
		        if (reader.result)
		            reader.content = reader.result;

		        //In IE browser event object is null
		        var data = e ? e.target.result : reader.content;
		        var baseEncoded = btoa(data);
		        var wb = XLSX.read(baseEncoded, {type: 'base64'});

		        processWorkbook(wb);
		    };

		    reader.onerror = function(ex){
		        console.log(ex);
		    };

		    //I'm reading the first file
		    //You can modify it as per your need
		    console.log(evt.target.files[0]);

		    reader.readAsBinaryString(evt.target.files[0]);

		    /*
		    var files = evt.target.files[0]; //input file 객체를 가져온다.

	        var reader = new FileReader(); //FileReader를 생성한다.

		        //성공적으로 읽기 동작이 완료된 경우 실행되는 이벤트 핸들러를 설정한다.
	        reader.onload = function(e) {

	           var data = e.target.result; //FileReader 결과 데이터(컨텐츠)를 가져온다.

		           //바이너리 형태로 엑셀파일을 읽는다.
	           var workbook = XLSX.read(data, {type: 'binary'});

		           //엑셀파일의 시트 정보를 읽어서 JSON 형태로 변환한다.
	           workbook.SheetNames.forEach(function(item, index, array) {
	               var EXCEL_JSON = XLSX.utils.sheet_to_json(workbook.Sheets[item]);
	               fileJSON = EXCEL_JSON;

	           });//end. forEach

	           console.log("fileJSON", fileJSON);
			    if( !isEmpty(fileJSON) ) {
			        var tbodyStr = "";
			        var alarmName = "";
			        alarmName += '	<span>';
			        alarmName += fileJSON[0].DEV_TYPE + '_' + fileJSON[0].MANUFACTURER + '_' + fileJSON[0].MODEL + '_' + fileJSON[0].VERSION;
			        alarmName += '	</span>';

					for(var i=0; i<fileJSON.length; i++) {
						console.log("fileJSON[i] : ", fileJSON[i]);
						var el = fileJSON[i];
						var deviceName = eval('deviceTemplate.' + el.DEV_TYPE);
						tbodyStr += '	<tr>';
						tbodyStr += '		<td><input type="checkbox" name="almMsgApplyCodeYn" value="'+el.set_id+'" device-type="'+el.device_type+'"></td>';
						tbodyStr += '		<td>'+(i+1)+'</td>'; // NO
						tbodyStr += '		<td>'+( (isEmpty(el.DEV_TYPE)) ? '-' :  deviceName )+'</td>'; // 설비타입
						tbodyStr += '		<td>'+( (isEmpty(el.MANUFACTURER)) ? '-' : el.MANUFACTURER )+'</td>'; // 제조사
						tbodyStr += '		<td>'+( (isEmpty(el.VERSION)) ? '-' : el.VERSION )+'</td>'; // 버전
						tbodyStr += '		<td>'+( (isEmpty(el.ALARM_CODE)) ? '-' : el.ALARM_CODE )+'</td>'; // 에러코드
						tbodyStr += '		<td>'+( (isEmpty(el.ALARM_MSG)) ? '-' : el.ALARM_MSG )+'</td>'; // 메세지
						tbodyStr += '		<td><select name="" id="" class="sel h36"><option value="">문제발생</option><option value="">위험</option><option value="" selected>경고</option><option value="">정보</option></select></td>'; // 알람레벨
						tbodyStr += '		<td>'+( (isEmpty(el.MODEL)) ? '-' : el.MODEL )+'</td>'; // 추가정보
						tbodyStr += '		<td><a href="javascript:;"><img src="../img/del2.png" alt=""></a></td>'; // X Button
						tbodyStr += '	<td>';
						tbodyStr += '	</tr>';
					}
				} else {
					tbodyStr += '';
				}

				$('#alarmSetName').empty().append(alarmName);
				$('#codeTable tbody').empty().append(tbodyStr);
	        }; //end onload

		        //파일객체를 읽는다. 완료되면 원시 이진 데이터가 문자열로 포함됨.
	        reader.readAsBinaryString(files);
	       */

	});
	function processWorkbook(workbook) {
		var sheetLength = workbook.Sheets[workbook.SheetNames]['!ref'].split(":")[1];
		var sheetNames = workbook.SheetNames;
		sheetLength = parseInt(sheetLength.replace(/[^0-9]/g, ""));

		console.log(workbook, sheetLength);
		var DEV_TYPE = { v : workbook.Sheets[sheetNames]["A2"].v };
		var MANUFACTURER = { v : workbook.Sheets[sheetNames]["B2"].v };
		var MODEL = { v : workbook.Sheets[sheetNames]["C2"].v };
		var VERSION = { v : workbook.Sheets[sheetNames]["D2"].v };
		var ALARM_CODE = { v : "" };
		var ALARM_MSG = { v : "" };
		var LEVEL = { v : "" };
		var cnt = 1;
		console.log(DEV_TYPE, MANUFACTURER, MODEL, VERSION);


	    for(var i = 2 ; i < sheetLength+1; i++){

			ALARM_CODE.v = workbook.Sheets[sheetNames]["E"+i].v;
			ALARM_MSG.v = workbook.Sheets[sheetNames]["F"+i].v;
			LEVEL.v = workbook.Sheets[sheetNames]["G"+i].v;

			excelArray.push({
				cnt : cnt,
				ALARM_CODE: ALARM_CODE.v,
				ALARM_MSG: ALARM_MSG.v,
				DEV_TYPE: DEV_TYPE.v,
				LEVEL: LEVEL.v,
				MANUFACTURER: MANUFACTURER.v,
				MODEL: MODEL.v,
				VERSION: VERSION.v
			})
			cnt++;
	    }

	    if( !isEmpty(excelArray) ) {
	        var tbodyStr = "";
	        var alarmName = "";
	        alarmName += '	<span>';
	        alarmName += excelArray[0].DEV_TYPE + '_' + excelArray[0].MANUFACTURER + '_' + excelArray[0].MODEL + '_' + excelArray[0].VERSION;
	        alarmName += '	</span>';

			for(var i=0; i<excelArray.length; i++) {
				console.log("excelArray[i] : ", excelArray[i]);
				var el = excelArray[i];
				var deviceName = eval('deviceTemplate.' + el.DEV_TYPE);
				tbodyStr += '	<tr>';
				tbodyStr += '		<td><input type="checkbox" name="almMsgApplyCodeYn" value="'+el.set_id+'" device-type="'+el.DEV_TYPE+'"></td>';
				tbodyStr += '		<td>'+(i+1)+'</td>'; // NO
				tbodyStr += '		<td>'+( (isEmpty(el.DEV_TYPE)) ? '-' :  deviceName )+'</td>'; // 설비타입
				tbodyStr += '		<td>'+( (isEmpty(el.MANUFACTURER)) ? '-' : el.MANUFACTURER )+'</td>'; // 제조사
				tbodyStr += '		<td>'+( (isEmpty(el.VERSION)) ? '-' : el.VERSION )+'</td>'; // 버전
				tbodyStr += '		<td>'+( (isEmpty(el.ALARM_CODE)) ? '-' : el.ALARM_CODE )+'</td>'; // 에러코드
				tbodyStr += '		<td>'+( (isEmpty(el.ALARM_MSG)) ? '-' : el.ALARM_MSG )+'</td>'; // 메세지
				if(el.LEVEL == 9) tbodyStr += '		<td><select name="" id="" class="sel h36"><option value="9" selected>알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>'; // 알람레벨
				if(el.LEVEL == 0) tbodyStr += '		<td><select name="" id="" class="sel h36"><option value="9">알수없음</option><option value="0" selected>정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>';
				if(el.LEVEL == 1) tbodyStr += '		<td><select name="" id="" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" selected>경고</option><option value="2">이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>';
				if(el.LEVEL == 2) tbodyStr += '		<td><select name="" id="" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2" selected>이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>';
				if(el.LEVEL == 3) tbodyStr += '		<td><select name="" id="" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3" selected>트립</option><option value="4">긴급</option></select></td>';
				if(el.LEVEL == 4) tbodyStr += '		<td><select name="" id="" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3">트립</option><option value="4" selected>긴급</option></select></td>';

				tbodyStr += '		<td>'+( (isEmpty(el.MODEL)) ? '-' : el.MODEL )+'</td>'; // 추가정보
				tbodyStr += '		<td><a id="addDeleteCode_'+(i+1)+'" name='+(i+1)+' href="javascript:;"><img src="../img/del2.png" alt=""></a></td>'; // X Button
				tbodyStr += '	<td>';
				tbodyStr += '	</tr>';
			}
		} else {
			tbodyStr += '';
		}

		$('#alarmSetName').empty().append(alarmName);
		$('#codeTable tbody').empty().append(tbodyStr);

	}

		$(document).on('click', 'a[id^="addDeleteCode_"]', function() { // 삭제 클릭
			if (confirm('삭제 하시겠습니까?')) {
				$(this).parent().parent().remove();
				var attrName = parseInt($(this).attr('name'));
				excelArray = excelArray.filter(function(el) {
					return attrName != el.cnt;
				});
			}

		});

		// 엑셀 내보내기 버튼
		$("#excelDownloadBtn").on("click", function() {
			console.log('다운로드');
			var bDataExist = false;
			var xlsTableArr = $('#codeTable').find('tbody');
			for(var i = 0; i < xlsTableArr.length; i++) {

				var tableObj = xlsTableArr[i];
				var allTRs = tableObj.getElementsByTagName( "tr" );

				if(1 < allTRs.length) {
					bDataExist = true;
					break;
				}
			}

			if(false == bDataExist) {
				alert('다운받을 데이터가 없습니다.');
				return;
			}

			if (confirm('엑셀로 저장하시겠습니까?')) {
				console.log($('#alarmSetName span').text());
				var excelName = $('#alarmSetName span').text();
				exportExcel2(excelName, $('#codeTable').find('tbody'));
			}

		});

		// 추가버튼
		$('#addCodeSet').on('click', function() {
			console.log("추가");
			alarmFormInit(); // 폼 초기화
			$("#updateCodeSet").attr("id", "insertCodeSet");
			popupOpen('msg_code');
		});

		// 수정버튼
		$('#updtCodeSet').on('click', function() {
			console.log("수정");

			if($(':checkbox[name="almMsgApplyYn"]:checked').length == 0) {
				alert('코드셋를 선택해 주세요.');
				return false;
			}

			if($(':checkbox[name="almMsgApplyYn"]:checked').length > 1) {
				alert('코드셋을 한개만 선택해 주세요.');
				return false;
			}

			var updateRow = $(':checkbox[name="almMsgApplyYn"]:checked').val();

			var updateRowData;
			for(var i = 0 ; i < schAlarmMsgList.length ; i++){
				if(schAlarmMsgList[i].set_id == updateRow){
					updateRowData = schAlarmMsgList[i];

					break;
				}
			}


			var alarmName = "";
	        alarmName += '	<span>';
	        alarmName += updateRowData.device_type + '_' + updateRowData.manufacturer + '_' + updateRowData.model + '_' + updateRowData.version;
	        alarmName += '	</span>';

	        $('#alarmSetName').empty().append(alarmName);


	        schAlarmMsgListUnder = [];

            $.each(updateRowData.codes, function(j, codes) {

				codes.cnt = j+1;
				codes.device_type = schAlarmMsgList.device_type;
				codes.manufacturer = schAlarmMsgList.manufacturer;
				codes.model = schAlarmMsgList.model;
				codes.version = schAlarmMsgList.version;
				schAlarmMsgListUnder.push(codes);
			});



			var tbodyStr = "";
			if( !isEmpty(schAlarmMsgListUnder) ) {
				for(var i=0; i<schAlarmMsgListUnder.length; i++) {

					var el = schAlarmMsgListUnder[i];
					var deviceName = eval('deviceTemplate.' + el.device_type);
					tbodyStr += '	<tr>';
					tbodyStr += '		<td><input type="checkbox" name="almMsgApplyYn" value="'+el.set_id+'" device-type="'+el.device_type+'"></td>';
					tbodyStr += '		<td>'+(i+1)+'</td>'; // NO
					tbodyStr += '		<td>'+( (isEmpty(el.device_type)) ? '-' : deviceName )+'</td>'; // 설비타입
					tbodyStr += '		<td>'+( (isEmpty(el.manufacturer)) ? '-' : el.manufacturer )+'</td>'; // 제조사
					tbodyStr += '		<td>'+( (isEmpty(el.version)) ? '-' : el.version )+'</td>'; // 버전?
					tbodyStr += '		<td>'+( (isEmpty(el.code)) ? '-' :  el.code )+'</td>'; // 에러코드
					tbodyStr += '		<td>'+( (isEmpty(el.message)) ? '-' : el.message )+'</td>'; // 메세지
					if(el.level == 9) tbodyStr += '		<td><select name='+(i+1)+' id="updateSelectCode_'+(i+1)+'" class="sel h36"><option value="9" selected>알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>'; // 알람레벨
					if(el.level == 0) tbodyStr += '		<td><select name='+(i+1)+' id="updateSelectCode_'+(i+1)+'" class="sel h36"><option value="9">알수없음</option><option value="0" selected>정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>';
					if(el.level == 1) tbodyStr += '		<td><select name='+(i+1)+' id="updateSelectCode_'+(i+1)+'" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" selected>경고</option><option value="2">이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>';
					if(el.level == 2) tbodyStr += '		<td><select name='+(i+1)+' id="updateSelectCode_'+(i+1)+'" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2" selected>이상</option><option value="3">트립</option><option value="4">긴급</option></select></td>';
					if(el.level == 3) tbodyStr += '		<td><select name='+(i+1)+' id="updateSelectCode_'+(i+1)+'" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3" selected>트립</option><option value="4">긴급</option></select></td>';
					if(el.level == 4) tbodyStr += '		<td><select name='+(i+1)+' id="updateSelectCode_'+(i+1)+'" class="sel h36"><option value="9">알수없음</option><option value="0">정보</option><option value="1" >경고</option><option value="2">이상</option><option value="3">트립</option><option value="4" selected>긴급</option></select></td>';

					tbodyStr += '		<td>'+( (isEmpty(el.description)) ? '-' : el.description )+'</td>'; // 추가정보
					tbodyStr += '		<td><a id="updtDeleteCode_'+(i+1)+'" name='+(i+1)+' href="javascript:;"><img src="../img/del2.png" alt=""></a></td>'; // X Button
					tbodyStr += '	<td>';
					tbodyStr += '	</tr>';
				}
			} else {
				tbodyStr += '';
			}
			console.log('schAlarmMsgList : ',schAlarmMsgList);
			console.log('schAlarmMsgListUnder : ',schAlarmMsgListUnder);
	        $('#codeTable tbody').empty().append(tbodyStr);
	        $("#insertCodeSet").attr("id", "updateCodeSet");
	        popupOpen('msg_code');
		});

		// 삭제
		$('#deleteCodeSet').on('click', function() {
			console.log("삭제");
			if (confirm('코드셋을 삭제하시겠습니까?')) {


				if($(':checkbox[name="almMsgApplyYn"]:checked').length == 0) {
					alert('코드셋를 선택해 주세요.');
					return false;
				}

				var deleteRow = [];

				$(':checkbox[name="almMsgApplyYn"]:checked').each(function() {

					deleteRow.push($(this).val())

				});


				for(var i = 0 ; i < deleteRow.length ; i++){
					var rowKey = parseInt(deleteRow[i]);
					//console.log("deleteRow", deleteRow[i], typeof deleteRow[i]);
					ajax_deleteCodeSet(rowKey);
				}
			}
		});

		$(document).on('change', '[id^="updateSelectCode_"]', function() { // 업데이트 array

				$("option[value=" + this.value + "]", this).attr("selected", true).siblings().removeAttr("selected");

				var attrName = parseInt($(this).attr('name'));
				var updateArr = [];
				updateArr = schAlarmMsgListUnder.filter(function(el) {
					return attrName == el.cnt;
				});

				update_updateArr.push({
					cnt : updateArr[0].cnt,
					code : updateArr[0].code,
					description : updateArr[0].description,
					device_type : updateArr[0].device_type,
					level : parseInt($(this).val()),
					manufacturer : updateArr[0].manufacturer,
					message : updateArr[0].message,
					model : updateArr[0].model,
					set_id : updateArr[0].set_id,
					version : updateArr[0].version
				});

		});


		$(document).on('click', 'a[id^="updtDeleteCode_"]', function() { // 삭제 array
			$(this).parent().parent().remove();
			var attrName = parseInt($(this).attr('name'));
			var deleteArr = [];
			deleteArr = schAlarmMsgListUnder.filter(function(el) {
				return attrName == el.cnt;
			});

			update_deleteArr.push({
				cnt : deleteArr[0].cnt,
				code : deleteArr[0].code,
				description : deleteArr[0].description,
				device_type : deleteArr[0].device_type,
				level : deleteArr[0].level,
				manufacturer : deleteArr[0].manufacturer,
				message : deleteArr[0].message,
				model : deleteArr[0].model,
				set_id : deleteArr[0].set_id,
				version : deleteArr[0].version
			});

			// ajax_deleteAlarmMsg(deleteArr[0].set_id, deleteArr[0].code);
	});

		function alarmFormInit() {
			$('#alarmSetName span').text('');
			if($.browser.msie) {
				$('#excelUploadBtn').replaceWith($("#excelUploadBtn").clone(true));
			}
			else{
				$('#excelUploadBtn').val("");
			}

			$('#codeTable tbody').empty();
		}

		// 적용 버튼
		$("#applyAlarmBtn").on("click", function() {
			if($(':checkbox[name="almMsgApplyYn"]:checked').length == 0) {
				alert('알람메세지를 한개이상 선택해 주세요.');
				return false;
			}

			if(confirm("선택한 알람메세지의 레벨을 적용하시겠습니까?")) {
				applyData();
			}
		});

		// 삭제 버튼
		$("#deleteBtn").on("click", function() {
			if($(':checkbox[name="almMsgApplyYn"]:checked').length == 0) {
				alert('알람메세지를 한개이상 선택해 주세요.');
				return false;
			}

			var almLen = $(':checkbox[name="almMsgApplyYn"]:checked').length;

			if(confirm(""+almLen+"개의 항목을 삭제하겠습니다. 정말 삭제하시겠습니까?")) {
				deleteAlarmMsg();
			}
		});
		$(document).on('click', "#insertCodeSet", function() {
			console.log("insertCodeSet");
			if(!isEmpty(excelArray))
			{
				if(confirm("적용하시겠습니까?")) {
					$.ajax({
						url: apiURL + "/alarms/code_sets",
						type: 'post',
						async: true,
						data: JSON.stringify({
							"manufacturer": excelArray[0].MANUFACTURER,
							"model": excelArray[0].MODEL,
							"version": excelArray[0].VERSION,
							"description": "",
							"device_type": excelArray[0].DEV_TYPE
						}),
						contentType: 'application/json; charset=UTF-8',
						success: function (result) {
							console.log("result : ", result.data[0].set_id);

							excelArray.forEach(function(value, key) {

								$.ajax({
									url: apiURL + "/alarms/code_sets/"+result.data[0].set_id+"/codes",
									type: 'post',
									async: true,
									data: JSON.stringify({
										"code": value.ALARM_CODE,
										"level": value.LEVEL,
										"message": value.ALARM_MSG,
										"description": ""
									}),
									contentType: 'application/json; charset=UTF-8',
									success: function (result) {

										if(key == excelArray.length-1){

											popupClose('msg_code');
											if($('#alarmLevelTable tbody tr').length > 1){
												console.log("schAlarmList call");
												schAlarmList();
											}
											else{
												console.log("no Rendering");
											}

										}
									},
									error: function(result, status, error) {
										console.log(error);
									}

								});

							});

						},
						error: function(result, status, error) {
							console.log(error);
						}
					});
				}
			}
		})
		.on('click', "#updateCodeSet", function(){
			var requestFncArr = new Array(); // promise를 위한 함수배열 선언

			if(confirm("적용하시겠습니까?")){
				console.log("updateCodeSet");
				console.log("delete Array : ", update_deleteArr);
				console.log("update Array : ", update_updateArr);


				for(var i = 0 ; i < update_updateArr.length ; i++){

					var setId = update_updateArr[i].set_id;
					var code = update_updateArr[i].code;

					var almMsgData = {
							level: Number(update_updateArr[i].level)
					};

					requestFncArr.push( ajax_updtAlarmMsg(setId, code, almMsgData) );
				}

				for(var i = 0 ; i < update_deleteArr.length ; i++){

					var setId = update_deleteArr[i].set_id;
					var code = update_deleteArr[i].code;

					requestFncArr.push( ajax_deleteAlarmMsg(setId, code) );

				}

				Promise.all(requestFncArr).then(function(res){
					console.log("[update&&Delete SUCCESS]");
					alert ("적용되었습니다.");
					popupClose('msg_code');
					schAlarmList();
				}).catch(function(error){
					console.log("[deleteRtu ERROR]");
				});
			}
		});

	});

// 		var almMsgPaging = new pagination('#almMsgPage'); // 그룹목록 페이징처리

	var almMsgList;
	var initPage = function () {
		deviceType();

		$.ajax({
			url: apiURL + "/alarms/code_sets",
			type: 'get',
			async: true,
			data : {
				includeCodes: true
			},
			success: function (result) {
				var tbodyStr = "";
				almMsgList = result.data;
			},
			error: function(result, status, error) {
				console.log(error);
			}
		});
	};

	// 설비타입 조회
	var deviceType = function (result) {
		var liStr = '';
		$.each(deviceProperties, function(i, el) {
			liStr += '<li><input type="checkbox" name="deviceType" id="deviceType_' + i + '" value="' + i + '" class="his_chk"><label for="deviceType_' + i + '">'+el.name.kr+'</label></li>';
		});
		$('#deviceType ul').empty().append(liStr);
	};

	var filteringManufList = new Array();
	var filteringModelList = new Array();
	var filteringVersionList = new Array();
	// 제조사, 모델명 조회
	var getFiltering = function (param) {
		var str = '', target = '';
		if(param == 'deviceType') {
			var typeArray = new Array();
			$(':checkbox[name="deviceType"]:checked').each(function() {
				typeArray.push($(this).val());
			});
			target = '#manufacturer  ul';
			var manufArray = new Array();
			if( !isEmpty(almMsgList) ) {
				$.each(almMsgList, function(i, el) {
					if( $.inArray(el.device_type, typeArray) > -1 ) {
						filteringManufList.push(el);
						if( $.inArray(el.manufacturer, manufArray) === -1 ) {
							manufArray.push(el.manufacturer);
							str += '<li><input type="checkbox" name="manuf" id="manuf_' + el.manufacturer + '" value="' + el.manufacturer + '" class="his_chk"><label for="manuf_' + el.manufacturer + '">'+el.manufacturer+'</label></li>';
						}
					}
				});
			}
		} else if(param == 'manufacturer') {
			var manufArray = new Array();
			$(':checkbox[name="manuf"]:checked').each(function() {
				manufArray.push($(this).val());
			});
			target = '#modelList  ul';
			var modelArray = new Array();
			if( !isEmpty(filteringManufList) ) {
				$.each(filteringManufList, function(i, el) {
					if( $.inArray(el.manufacturer, manufArray) > -1 ) {
						filteringModelList.push(el);
						if( $.inArray(el.model, modelArray) === -1 ) {
							modelArray.push(el.model);
							str += '<li><input type="checkbox" name="model" id="model_' + el.model + '" value="' + el.model + '" class="his_chk"><label for="model_' + el.model + '">'+el.model+'</label></li>';
						}
					}
				});

			}
		} else if(param == 'model') {
			var manufArray = new Array();
			$(':checkbox[name="manuf"]:checked').each(function() {
				manufArray.push($(this).val());
			});
			target = '#schVersion';
			var modelArray = new Array();
			if( !isEmpty(filteringModelList) ) {
				str += '<option value="">펌웨어버전</option>';
				str += '<option value="all">전체</option>';
				$.each(filteringModelList, function(i, el) {
					if( $.inArray(el.manufacturer, manufArray) > -1 ) {
						filteringVersionList.push(el);
						if( $.inArray(el.model, modelArray) === -1 ) {
							modelArray.push(el.model);
							str += '<option value="'+el.version+'">'+el.version+'</option>';
						}
					}
				});
			}
		}

		$(target).empty().append(str);
	};

	// 알람메세지목록 조회
	var schAlarmList = function (skip) {

		if($(':checkbox[name="deviceType"]:checked').length == 0) {
			alert('설비타입을 한개이상 선택해 주세요.');
			return false;
		}

		// 2020.07.14 제조사, 모델명 정보가 제대로 셋팅안되는거 같음. 설비를 골라도 정보가 없는경우가 많음.

        if($(':checkbox[name="manuf"]:checked').length == 0) {
            alert('제조사를 한개이상 선택해 주세요.');
            return false;
        }

		if($(':checkbox[name="model"]:checked').length == 0) {
			alert('모델을 한개이상 선택해 주세요.');
            return false;
        }

		loadingAni_Show();

		setTimeout(function() {
			schAlarmListProc(skip);
		}, 500);
	};
	function schAlarmListProc(skip) {
		var _skip = (isEmpty(skip)) ? 0 : skip;
		var limit = 5;

		$.ajax({
			url: apiURL + "/alarms/code_sets",
			type: 'get',
			async: true,
			data : {
				includeCodes: true
			},
			success: function (result) {
				var tbodyStr = "";
				if( !isEmpty(result) ) {
					if( !isEmpty(result.data) ) {
						schAlarmMsgList = [];
						$.each(result.data, function(i, codeSets) {
							var schYn = filteringChk(codeSets);
							if( schYn ) {

								schAlarmMsgList.push(codeSets);
							}
						});

						cb_schAlarmList(schAlarmMsgList/* , limit, _skip */);
					}
				}
				loadingAni_Hide();
			},
			error: function(result, status, error) {
				loadingAni_Hide();
				console.log(error);
			}
		});
	}

	var filteringChk = function (codeSets) {
		var typeArray = new Array();
		$(':checkbox[name="deviceType"]:checked').each(function() {
			typeArray.push($(this).val());
		});
		var manufacturerArray = new Array();
		$(':checkbox[name="manuf"]:checked').each(function() {
			manufacturerArray.push($(this).val());
		});
		var modelArray = new Array();
		$(':checkbox[name="model"]:checked').each(function() {
			modelArray.push($(this).val());
		});
		var schVersion = $("#schVersion").val();

		var res = false;
		if($.inArray(codeSets.device_type, typeArray) > -1 && $.inArray(codeSets.manufacturer, manufacturerArray) > -1
				&& $.inArray(codeSets.model, modelArray) > -1) {
			res = true;
		}

		if(schVersion != 'all') {
			if(schVersion == codeSets.version) {
				res = true;
			} else {
				res = false;
			}
		}

		return res;
	};

	var cb_schAlarmList = function (schAlarmMsgList/* , limit, skip */) {
		var totCnt = schAlarmMsgList.length;
		console.log("schAlarmMsgList : ", schAlarmMsgList);
		var tbodyStr = "";
		if( !isEmpty(schAlarmMsgList) ) {
// 				var end = ( (skip+limit)>totCnt ) ? totCnt : skip+limit;
// 				for(var i=skip; i<end; i++) {
			for(var i=0; i<totCnt; i++) {

				var el = schAlarmMsgList[i];
				var alarmName = "";
		        alarmName += el.device_type + '_' + el.manufacturer + '_' + el.model + '_' + el.version;
				var deviceName = eval('deviceTemplate.' + el.device_type);
				tbodyStr += '	<tr>';
				tbodyStr += '		<td><input type="checkbox" name="almMsgApplyYn" value="'+el.set_id+'" device-type="'+el.device_type+'"></td>';
				tbodyStr += '		<td>'+(i+1)+'</td>'; // NO
				tbodyStr += '		<td>'+( (isEmpty(alarmName)) ? '-' :  alarmName )+'</td>'; // 알람 코드 셋
				tbodyStr += '		<td>'+( (isEmpty(el.device_type)) ? '-' : deviceName )+'</td>'; // 설비타입
				tbodyStr += '		<td>'+( (isEmpty(el.manufacturer)) ? '-' : el.manufacturer )+'</td>'; // 제조사
				tbodyStr += '		<td>'+( (isEmpty(el.model)) ? '-' : el.model )+'</td>'; // 모델명
				tbodyStr += '		<td>'+( (isEmpty(el.version)) ? '-' : el.version )+'</td>'; // 버전
				tbodyStr += '	<td>';
				tbodyStr += '	</tr>';
			}
		} else {
			tbodyStr += '';
		}
		$('#alarmLevelTable tbody').empty().append(tbodyStr);

// 			var pageObj = {
// 					"limit": limit, // 보여질 데이터 수
// 					"skip": skip, // 보여져야 할 데이터 순번
// 					"page": 5, // 보여질 페이지 수
// 					"totCnt": totCnt // 총 건수
// 				};
// 			almMsgPaging.drawPage(pageObj);
	};

	// 알람메세지 변경사항 적용
	var applyData = function () {
		var requestFncArr = new Array(); // promise를 위한 함수배열 선언
		$(':checkbox[name="almMsgApplyYn"]:checked').each(function() {
			var setId = $(this).val();
			var code = $(this).data('code');
			var level = $(this).parent().parent().find('select').val();
			var almMsgData = {
					level: Number(level)
			};
			requestFncArr.push( ajax_updtAlarmMsg(setId, code, almMsgData) );
		});

		Promise.all(requestFncArr).then(function(res){
			console.log("[applyData SUCCESS]");
			alert ("적용되었습니다.");
			schAlarmList();
		}).catch(function(error){
			console.log("[applyData ERROR]");
		});
	};

	var ajax_updtAlarmMsg = function (setId, code, almMsgData) {
		return new Promise(function(resolve, reject){
			$.ajax({
				url: apiURL + "/alarms/code_sets/"+setId+"/codes/"+code,
				type: 'patch',
				async: true,
				data: JSON.stringify(almMsgData),
				contentType: 'application/json; charset=UTF-8',
			}).done(function (result){
				// patch, delete는 성공해도 결과값이 undefined이다
				resolve(result); // resolve 호출을 안하면 then이나 catch가 구동안됨
			}).fail(function(jqXHR, textStatus, errorThrown){
				console.log("code: " + jqXHR.status + "\n" + "message: " + jqXHR.responseText +"\n" + "error: " + errorThrown);
				reject(new Error("ajax_updtAlarmMsg"));
			});
		});
	};

	// 알람메세지 삭제
	var deleteAlarmMsg = function () {
		var requestFncArr = new Array(); // promise를 위한 함수배열 선언
		$(':checkbox[name="almMsgApplyYn"]:checked').each(function() {
			var setId = $(this).val();
			var code = $(this).data('code');
			requestFncArr.push( ajax_deleteAlarmMsg(setId, code) );
		});

		Promise.all(requestFncArr).then(function(res){
			console.log("[deleteAlarmMsg SUCCESS]");
			alert ("삭제되었습니다.");
			schAlarmList();
		}).catch(function(error){
			console.log("[deleteAlarmMsg ERROR]");
		});
	};

	var ajax_deleteAlarmMsg = function (setId, code) {
		return new Promise(function(resolve, reject){
			$.ajax({
				url: apiURL + "/alarms/code_sets/"+setId+"/codes/"+code,
				type: 'delete',
				async: true,
			}).done(function (result){
				// patch, delete는 성공해도 결과값이 undefined이다
				resolve(result); // resolve 호출을 안하면 then이나 catch가 구동안됨
			}).fail(function(jqXHR, textStatus, errorThrown){
				console.log("code: " + jqXHR.status + "\n" + "message: " + jqXHR.responseText +"\n" + "error: " + errorThrown);
				reject(new Error("ajax_deleteAlarmMsg"));
			});
		});
	};

	var ajax_deleteCodeSet = function (setId) {
		return new Promise(function(resolve, reject){
			$.ajax({
				url: apiURL + "/alarms/code_sets/"+setId,
				type: 'delete',
				async: true,
			}).done(function (result){
				// patch, delete는 성공해도 결과값이 undefined이다
				schAlarmList();
				resolve(result); // resolve 호출을 안하면 then이나 catch가 구동안됨
			}).fail(function(jqXHR, textStatus, errorThrown){
				console.log("code: " + jqXHR.status + "\n" + "message: " + jqXHR.responseText +"\n" + "error: " + errorThrown);
				reject(new Error("ajax_deleteAlarmMsg"));
			});
		});
	};

</script>