<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	var countryList = [{"value" : "대한민국"}];
	var sidoList = [
		{"value" :"서울"},{"value" :"부산"},{"value" :"대구"},{"value" :"인천"},{"value" :"광주"},
		{"value" :"울산"},{"value" :"세종"},{"value" :"경기"},{"value" :"강원"},{"value" :"충북"},{"value" :"충남"},
		{"value" :"전북"},{"value" :"전남"},{"value" :"경북"},{"value" :"경남"},{"value" :"제주"}
	];


	$(function () {
		initProcess();
		$("#spcList").on("click", "li", spcListChange);
		$("#genList").on("click", "li", genListChange);
		$("#countryList").on("click", "li", conntryListChange);
		$("#sidoList").on("click", "li", sidoListChange);
		$("#unitPriceList").on("click", "li", unitPriceListChange);
	});

	$(document).on('click', '.dropdown li', function () {
		var dataValue = $(this).data('value'),
			dataText = $(this).text();
		$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);
	});

	function initProcess(){
		initAddListHtml(); //추가 기능 관련 초기화
		setComboBoxData(); //시도 설정
		getSpcData();//SPC명 설정
		getGenData();//발전소명 설정
	}

	function initAddListHtml(){
		$("#addList01").data("form", $("#addList01").html()).data("count", ($("#addList01").html().match(/input/g) || []).length);
		$("#addList02").data("form", $("#addList02").html()).data("count", ($("#addList02").html().match(/input/g) || []).length);
		$("#addList03").data("form", $("#addList03").html()).data("count", ($("#addList03").html().match(/input/g) || []).length);
		$("#addList04").data("form", $("#addList04").html()).data("count", ($("#addList04").html().match(/input/g) || []).length);
		$("#addList05").data("form", $("#addList05").html()).data("count", ($("#addList05").html().match(/input/g) || []).length);
		$("#addList06").data("form", $("#addList06").html()).data("count", ($("#addList06").html().match(/input/g) || []).length);
		$("#addList07").data("form", $("#addList07").html()).data("count", ($("#addList07").html().match(/input/g) || []).length);

		$("#addFileList01").data("form", $("#addFileList01").html());
		$("#addFileList02").data("form", $("#addFileList02").html());
		$("#addFileList03").data("form", $("#addFileList03").html());
		$("#addFileList04").data("form", $("#addFileList04").html());
		$("#addFileList05").data("form", $("#addFileList05").html());
		$("#addFileList06").data("form", $("#addFileList06").html());
		$("#addFileList07").data("form", $("#addFileList07").html());
		$("#addFileList08").data("form", $("#addFileList08").html());
		$("#addFileList09").data("form", $("#addFileList09").html());
		$("#addFileList10").data("form", $("#addFileList10").html());
	}

	function addList(addId){
		var $selecter = $("#" + addId);
		$selecter.append($selecter.data("form"));
	}
	
	function removeList(obj){
		if( $(obj).parent().parent().find(".group_type").length > 1){
			$(obj).parent().remove();	
		};		
	}

	function setAddListParam(addId){
		var param = [],
			$selecter = $("#" + addId),
			rowInputCount = $selecter.data("count"),
			allInputCount = $selecter.find("input[type='text']").length;

		for(var i = 0, count = allInputCount / rowInputCount; i < count; i++){
			var rowData = {};
			for(var j = i*rowInputCount; j < i * rowInputCount + rowInputCount; j++){
				var $input = $selecter.find("input[type='text']").eq(j);
				rowData[$input.attr("name")] = $input.val();
			}
			param.push(rowData);
		}

		return param;
	}

	function setDropDownValue(id, data){
		var $selecter = $("#" + id);
		$selecter.find("li").each(function(){
			if($(this).text() == data){
				$selecter.parents('.dropdown').find('button').html(data + '<span class="caret"></span>').data('value', data);
				return false;
			}
		});
	}

	function spcListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#spcList").find("li").index(this),
			jsonData = $("#spcList").data("gridJsonData")[idx];

		if(jsonData.spc_id == ""){
			$("#name").val("").prop("readonly", false);
		}else{
			$("#name").val(jsonData["name"]).prop("readonly", true);
		}
	}

	function genListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#genList").find("li").index(this),
			jsonData = $("#genList").data("gridJsonData")[idx];

		$("#genName").val(jsonData.name);
		//발전소에 국가정보없는데 뭔...
		//$("#countryValue").val(jsonData["countryValue"]);
		//setDropDownValue("countryList", jsonData["countryValue"]);
		$("#countryValue").val("대한민국");
		setDropDownValue("countryList", "대한민국");

		$("#sidoValue").val(jsonData.location);
		setDropDownValue("sidoList", jsonData.location);
		$("#address").val(jsonData.address);
		
		if(jsonData.sid == ""){
			$("#genName").prop("readonly", false);
		}else{
			$("#genName").prop("readonly", true);
		}
	}

	function conntryListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#countryList").find("li").index(this);

		if( txt != "대한민국"){
			setMakeList([], "sidoList", {"dataFunction" : {}});
		}else{
			setMakeList(sidoList, "sidoList", {"dataFunction" : {}});
		}

		$("#countryValue").val(txt);
	}

	function sidoListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#sidoList").find("li").index(this);

		$("#sidoValue").val(txt);
	}

	function unitPriceListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#unitPriceList").find("li").index(this);

		$("#기준_단가").val(txt);
	}

	function getSpcData(){
		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs",
			type: "get",
			async: false,
			data: {"oid": oid},
			success: function (json) {
				setInitList("spcList");
				json.data.push({"spc_id":"", "name" : "직접입력"});
				setMakeList(json.data, "spcList", {"dataFunction" : {}});
			},
			error: function (request, status, error) {

			}
		});
	}

	function getGenData(){
		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites",
			type: "get",
			async: false,
			data: {"oid": oid},
			success: function (json) {
				setInitList("genList");
				json.push({"sid":"", "name" : "직접입력", "location":"", "address":""});
				setMakeList(json, "genList", {"dataFunction" : {}});
			},
			error: function (request, status, error) {

			}
		});
	}

	function setComboBoxData(){
		setInitList("countryList");
		setMakeList(countryList, "countryList", {"dataFunction" : {}});

		setInitList("sidoList");
		setMakeList(sidoList, "sidoList", {"dataFunction" : {}});
	}

	function setSaveData(){
		var spcId = $("#spc").data("value"),
			spcName = $("#name").val(),
			genId = $("#gen").data("value"),
			genName = $("#genName").val();

		if(spcId === undefined){
			alert("SCP명을 선택하세요.");
			return false;
		}

		if(genId === undefined){
			alert("발전소를 선택하세요.");
			return false;
		}

		if(spcId == "" && spcName == ""){
			alert("SCP명을 입력하세요.");
			return false;
		}
		
		if(genId == "" && genName == ""){
			alert("발전소명을 입력하세요.");
			return false;
		}	
		
		//직접입력 발전소 등록..(이걸왜 여기서 하지? 발전소 관리 화면냅두고 직접입력 선택 시 사이트관리 화면 팝업을 띄우던가..ㅉㅉ)
		if(genId == ""){
			var bError = false;
			$.ajax({
				url: "http://iderms.enertalk.com:8443/config/sites?oid="+oid,
				type: "post",
				dataType: 'json',
				async: false,
				contentType: "application/json",
				data: JSON.stringify({
					"name": $("#genName").val(),
					"location": $("#sidoValue").val(),
					"address": $("#address").val(),
					"resource_type" : 0
				}),
				success: function (json) {
					$("#gen").data("value", json.sid);
				},
				error: function (request, status, error) {
					alert('처리 중 오류가 발생했습니다.');
					bError = true;
					return false;
				}
			});
			
			if(bError){
				return false;
			}
		}	
		
		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs",
			type: "get",
			async: true,
			data: {"oid": oid, includeGens: true},
			success: function (result) {
				var checkCountSpc = 0, checkCountGen = 0;

				for(var i = 0, count = result.data.length; i < count; i++){
					var rowData = result.data[i];
					var spcGensList = rowData.spcGens;

					if(rowData.name == spcName && spcId == ""){
						checkCountSpc++;
						break;
					}

					if(spcGensList !== undefined && spcGensList.length > 0){
						for(var j = 0, jcount = spcGensList.length; j < jcount; j++){
							if(genId == spcGensList[j].gen_id){
								checkCountGen++;
								break;
							}
						}
					}
				}

				if( checkCountSpc > 0 ){
					alert("중복되는 SPC명이 존재 합니다.");
					return false;
				}

				if( checkCountGen > 0 ){
					alert("SPC에 등록된 발전소 입니다.");
					return false;
				}

				$("#sendSpcPostModal").modal(); // 처리중 모달띄우기
				
				//신규 spc 일떄..
				if(spcId == ""){
					sendSpcPost();
				}else{
					sendSpcAttchFilePost(spcId);
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function sendSpcPost(){
		var spc_info = setAreaParamData("spc_info");

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs?oid="+oid,
			type: "post",
			dataType: 'json',
			async: true,
			contentType: "application/json",
			data: JSON.stringify({
				"name": $("#name").val(),
				"spc_info" : "",
				"updated_by" : loginId
			}),
			success: function (json) {
				sendSpcAttchFilePost(json.data[0].spc_id);
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function sendSpcAttchFilePost(spcId){
		var genId = $("#gen").data("value");

		$("#attachement_info").find("input[type=file]").each(function(){
			$(this).attr("name", this.name + "_" + spcId +"_" + genId);
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
			data: new FormData($('#attachement_info')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			success: function (result) {
				sendSpcGenPost(spcId, result.files);
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function sendSpcGenPost(spcId, files){
		var genId = $("#gen").data("value");

		var contract_info = setAreaParamData("contract_info"),
			device_info = setAreaParamData("device_info"),
			finance_info = setAreaParamData("finance_info"),
			warranty_info = setAreaParamData("warranty_info"),
			coefficient_info = setAreaParamData("coefficient_info"),
			contact_info = setAreaParamData("contact_info"),
			attachement_info = files;

		device_info["addList01"] = setAddListParam("addList01");
		device_info["addList02"] = setAddListParam("addList02");
		device_info["addList03"] = setAddListParam("addList03");
		device_info["addList04"] = setAddListParam("addList04");
		device_info["addList05"] = setAddListParam("addList05");
		device_info["addList06"] = setAddListParam("addList06");
		device_info["addList07"] = setAddListParam("addList07");

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/" + spcId +"/gens?oid=" + oid +"&gen_id=" + genId,
			type: "post",
			async: true,
			contentType: "application/json",
			data: JSON.stringify({
				"contract_info": JSON.stringify(contract_info),
				"device_info" : JSON.stringify(device_info),
				"finance_info" : JSON.stringify(finance_info),
				"warranty_info" : JSON.stringify(warranty_info),
				"coefficient_info" : JSON.stringify(coefficient_info),
				"contact_info" : JSON.stringify(contact_info),
				"attachement_info" : JSON.stringify(attachement_info),
				"updated_by" : loginId,
				"del_yn": "N"
			}),
			success: function (json) {
				alert("등록되었습니다.");
				goMoveList();
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function goMoveList(){
		location.href = "/spc/entityInformation.do";
	}
</script>

<!-- Modal (처리 중 모달)-->
<div id="sendSpcPostModal" class="modal fade" role="dialog">
	<div class="modal-dialog his_alarm">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="ly_wrap">
				<h2 class="ly_tit" style="text-align: center;">처리중...</h2>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 신규 등록</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row entity_wrap post">
	<div class="col-lg-12">
		<div class="indiv" id="spc_info">
			<div class="spc_tbl_row st_edit">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>SPC명</th>
						<td class="group_type03">
							<div class="dropdown placeholder edit">
								<button id="spc" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택
									<span class="caret"></span>
								</button>
								<ul id="spcList" class="dropdown-menu" role="menu">
									<li data-value="[spc_id]"><a href="javascript:void(0);" >[name]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="SPC명 입력">
							</div>
						</td>
						<th>발전소명</th>
						<td class="group_type03">
							<div class="dropdown placeholder edit">
								<button id="gen" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택
									<span class="caret"></span>
								</button>
								<ul id="genList" class="dropdown-menu" role="menu">
									<li data-value="[sid]"><a href="javascript:void(0);">[name]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="genName" placeholder="발전소명 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="3" class="group_type03">
							<div class="dropdown placeholder edit">
								<button id="country" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택
									<span class="caret"></span>
								</button>
								<ul id="countryList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
							<div class="dropdown placeholder edit">
								<button id="sido" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택
									<span class="caret"></span>
								</button>
								<ul id="sidoList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="hidden" id="countryValue" value="">
								<input type="hidden" id="sidoValue" value="">
								<input type="text" id="address" placeholder="상세 주소">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="contract_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">운영 정보</h2>
			</div>
			<div class="spc_tbl_row st_edit">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>담당부서</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="담당부서" placeholder="부서 명">
							</div>
						</td>
						<th>담당자</th>
						<td class="group_type">
							<div class="tx_inp_type edit">
								<input type="text" id="담당자" placeholder="담당자 명">
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="담당자_연락처" placeholder="담당자 연락처">
							</div>
						</td>
					</tr>
					<tr>
						<th>설치 용량</th>
						<td class="group_type">
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="설치_용량">
								<span>kW</span>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="설치_용량_기타" placeholder="태양광,ESS">
							</div>
						</td>
						<th>관리 운영 기간</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="관리_운영_기간" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>기상 관측 지점</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="기상_관측_지점" placeholder="직접 입력">
							</div>
						</td>
						<th>하자 보증기간(전기)</th>
						<td>
							<div class="sel_calendar edit twin clear">
								<input type="text" id="하자_보증기간(전기)_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(전기)_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
						</td>
					</tr>
					<tr>
						<th>사용 전 검사 완료일</th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="사용_전_검사_완료일" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th>하자 보증기간(토목)</th>
						<td>
							<div class="sel_calendar edit twin clear">
								<input type="text" id="하자_보증기간(토목)_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(토목)_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
						</td>
					</tr>
					<tr>
						<th>정기 검사</th>
						<td class="group_type02">
							<div class="tx_inp_type edit">
								<input type="text" id="정기_검사_주기" placeholder="주기">
							</div>
							<div class="sel_calendar edit twin clear fl">
								<input type="text" id="정기_검사_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="월 선택">
								<input type="text" id="정기_검사_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="일 선택">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>등기이사 소속 / 등기이사 명</th>
						<td class="group_type">
							<div class="tx_inp_type edit">
								<input type="text" id="등기이사_소속" placeholder="등기이사 소속">
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="등기이사_명" placeholder="등기이사 명">
							</div>
						</td>
						<th>등기 기간</th>
						<td>
							<div class="sel_calendar edit twin clear fl">
								<input type="text" id="등기_기간_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="등기_기간_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
							<div class="chk_type align_type fl">
									<span>
										<input type="checkbox" id="등기_이사_만료_알림" name="chk_04_op01" value="Y">
										<label for="등기_이사_만료_알림"><span></span>등기이사 만료 알림</label>
									</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>계약 단가</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="계약_단가">
								<span>원</span>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="device_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">설비 정보</h2>
			</div>
			<div class="spc_tbl_row st_edit">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>모듈 제조사 / 모델<a href="javascript:addList('addList01');" class="btn_add fr">추가</a></th>
						<td id="addList01">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" name="모듈_제조사" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" name="모듈_제조사_모델" placeholder="모델">
								</div>
								<button class="btn_clse" style="" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>설치 용량</th>
						<td class="group_type">
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="설치_용량_KW">
								<span>kW</span>
							</div>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="설치_용량_매">
								<span>매</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>모듈 설치 각도<a href="javascript:addList('addList02');" class="btn_add fr">추가</a></th>
						<td id="addList02">
							<div class="group_type">
								<div class="tx_inp_type edit unit t1 fl">
									<input type="text" name="모듈_설치_각도">
									<span>︒</span>
								</div>
								<button class="btn_clse" style="" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>모듈 설치 방식</th>
						<td>
							<div class="chk_type align_type">
									<span>
										<input type="checkbox" id="모듈_설치_방식_고정" name="chk_op" value="고정 가변식">
										<label for="모듈_설치_방식_고정"><span></span>고정 가변식</label>
									</span>
								<span>
										<input type="checkbox" id="모듈_설치_방식_트래커" name="chk_op" value="트래커">
										<label for="모듈_설치_방식_트래커"><span></span>트래커</label>
									</span>
								<span>
										<input type="checkbox" id="모듈_설치_방식_경사고정형" name="chk_op" value="경사 고정형">
										<label for="모듈_설치_방식_경사고정형"><span></span>경사 고정형</label>
									</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>인버터 제조사 / 모델<a href="javascript:addList('addList03');" class="btn_add fr">추가</a></th>
						<td id="addList03">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" name="인버터_제조사" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" name="인버터_제조사_모델" placeholder="모델">
								</div>
								<button class="btn_clse" style="" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>인버터 용량 / 대수<a href="javascript:addList('addList04');" class="btn_add fr">추가</a></th>
						<td id="addList04">
							<div class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="인버터_용량">
									<span>kW</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="인버터_용량_대수">
									<span>대</span>
								</div>
								<button class="btn_clse" style="" onclick="removeList(this);">삭제</button>
							</div>
						</td>
					</tr>
					<tr>
						<th>접속반 제조사 / 모델<a href="javascript:addList('addList05');" class="btn_add fr">추가</a></th>
						<td id="addList05">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" placeholder="제조사" name="접속반_제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="모델" name="접속반_제조사_모델">
								</div>
								<button class="btn_clse" style="" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>접속반 채널 / 대수<a href="javascript:addList('addList06');" class="btn_add fr">추가</a></th>
						<td id="addList06">
								<div class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="접속반_채널">
									<span>Ch</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="접속반_채널_대수">
									<span>대</span>
								</div>
								<button class="btn_clse" style="" onclick="removeList(this);">삭제</button>
							</div>
						</td>
					</tr>
					<tr>
						<th>접속반 용량 / 통신방식</th>
						<td class="group_type">
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="접속반_용량">
								<span>kW</span>
							</div>
							<div class="rdo_type align_type">
								<span>
									<input type="radio" id="rdo_03_op01" name="통신방식" value="통신">
									<label for="rdo_03_op01"><span></span>통신</label>
								</span>
								<span>
									<input type="radio" id="rdo_03_op02" name="통신방식" value="비통신">
									<label for="rdo_03_op02"><span></span>비통신</label>
								</span>
							</div>
						</td>
						<th>수배전반 제조사 / 모델<a href="javascript:addList('addList07');" class="btn_add fr">추가</a></th>
						<td id="addList07">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" name="수배전반_제조사" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" name="수배전반_제조사_모델" placeholder="모델">
								</div>
								<button class="btn_clse" style="" onclick="removeList(this);">삭제</button>
							</div>
						</td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td>
							<div class="chk_type align_type">
									<span>
										<input type="checkbox" id="설치_타입_그라운드" name="chk_op2" value="그라운드">
										<label for="설치_타입_그라운드"><span></span>그라운드</label>
									</span>
								<span>
										<input type="checkbox" id="설치_타입_루프탑" name="chk_op2" value="루프탑">
										<label for="설치_타입_루프탑"><span></span>루프탑</label>
									</span>
								<span>
										<input type="checkbox" id="설치_타입_수상" name="chk_op2" value="수상">
										<label for="설치_타입_수상"><span></span>수상</label>
									</span>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="finance_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">금융 정보</h2>
			</div>
			<div class="spc_tbl_row st_edit">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>관련 금융사</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="관련_금융사" placeholder="직접 입력">
							</div>
						</td>
						<th>관련 보험사</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="관련_보험사" placeholder="직접 입력">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="warranty_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">보증 정보</h2>
			</div>
			<div class="spc_tbl_row st_edit">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>보증 방식</th>
						<td>
							<div class="rdo_type align_type">
									<span>
										<input type="radio" id="rdo_op01" name="보증_방식" value="PR">
										<label for="rdo_op01"><span></span>PR</label>
									</span>
								<span>
										<input type="radio" id="rdo_op02" name="보증_방식" value="발전 시간">
										<label for="rdo_op02"><span></span>발전 시간</label>
									</span>
								<span>
										<input type="radio" id="rdo_op03" name="보증_방식" value="PR + 발전시간">
										<label for="rdo_op03"><span></span>PR + 발전 시간</label>
									</span>
							</div>
						</td>
						<th>PR 보증치</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="PR_보증치">
								<span>%</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="발전시간_보증치">
								<span>h</span>
							</div>
						</td>
						<th>보증 감소율</th>
						<td>
							<div class="tx_inp_type edit unit t2">
								<input type="text" id="보증_감소율">
								<span>년차별 %</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="unitPrice" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">기준 단가 선택
									<span class="caret"></span>
								</button>
								<ul id="unitPriceList" class="dropdown-menu" role="menu" id="type">
									<li data-value=""><a href="javascript:void(0);">기준 단가 선택</a></li>
									<li data-value="FIT 단가"><a href="javascript:void(0);">FIT 단가</a></li>
									<li data-value="시장정산실적"><a href="javascript:void(0);">시장정산실적</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit unit t2">
								<input type="hidden" id="기준_단가">
								<input type="text" id="기준_단가_원">
								<span>원 / kW</span>
							</div>
						</td>
						<th>현재 적용 연차</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="현재_적용_연차">
								<span>년차</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="년간_관리_운영비">
								<span>만원</span>
							</div>
						</td>
						<th>물가 반영 비율</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="물가_반영_비율">
								<span>%</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td>
							<div class="rdo_type align_type">
									<span>
										<input type="radio" id="rdo_op2_01" name="추가_보수" value="유">
										<label for="rdo_op2_01"><span></span>유</label>
									</span>
								<span>
										<input type="radio" id="rdo_op2_02" name="추가_보수" value="무">
										<label for="rdo_op2_02"><span></span>무</label>
									</span>
							</div>
						</td>
						<th>추가 보수 용량</th>
						<td>
							<div class="tx_inp_type edit unit t2">
								<input type="text" id="추가_보수_용량">
								<span>kW 이상</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="추가_보수_백분율">
								<span>%</span>
							</div>
						</td>
						<th>전력요금 종별</th>
						<td class="group_type">
							<div class="tx_inp_type edit">
								<input type="text" id="전력요금_종별_요금제" placeholder="요금제">
							</div>
							<div class="tx_inp_type edit unit t2">
								<input type="text" id="전력요금_종별_계약전력" placeholder="계약 전력">
								<span>kW</span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="coefficient_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">환경 변수</h2>
			</div>
			<div class="spc_tbl_row st_edit">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>Annual Variability</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="Annual">
								<span>%</span>
							</div>
						</td>
						<th>PV modul modeling/params</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="PV_modul">
								<span>%</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="Inverter">
								<span>%</span>
							</div>
						</td>
						<th>Soiling, mismatch</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="Soiling">
								<span>%</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>Degradation estimation</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="Degradation">
								<span>%</span>
							</div>
						</td>
						<th>Resulting ann, Variability(sigma)</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="Resulting_ann">
								<span>%</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>System Degradation</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="Degradation">
								<span>%</span>
							</div>
						</td>
						<th>System Availability</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="Availability">
								<span>%</span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="contact_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">관련 정보</h2>
			</div>
			<div class="spc_tbl_row st_edit">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>전기안전 관리 회사명</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="전기안전_관리_회사명" placeholder="직접 입력">
							</div>
						</td>
						<th>회사 연락처</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="회사_연락처" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>전기안전 관리 대표자명</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="전기안전_관리_대표자명" placeholder="직접 입력">
							</div>
						</td>
						<th>대표자 연락처</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="대표자_연락처" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>전기안전 관리 담당자명</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="전기안전_관리_담당자명" placeholder="직접 입력">
							</div>
						</td>
						<th>담당자 연락처</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="담당자_연락처" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th>현장 잠금장치 비밀번호</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="현장_잠금장치_비밀번호" placeholder="직접 입력">
							</div>
						</td>
						<th>시공사</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="시공사" placeholder="직접 입력">
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<form id="attachement_info" name="attachement_info">
			<div class="indiv mt25">
				<div class="tbl_top">
					<h2 class="ntit mt25">첨부 파일</h2>
				</div>
				<div class="spc_tbl_row">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:20%">
							<col>
						</colgroup>
						<tr>
							<th class="th_type">현장 사진<a href="javascript:addList('addFileList01')" class="btn_add fr">추가</a></th>
							<td id="addFileList01"><input name="spc_file_01" type="file" accept=".gif, .jpg, .png"></td>
							<td></td>
						</tr>
						<tr>
							<th>수배전반<a href="javascript:addList('addFileList02')" class="btn_add fr">추가</a></th>
							<td id="addFileList02"><input name="spc_file_02" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>케이블<a href="javascript:addList('addFileList03')" class="btn_add fr">추가</a></th>
							<td id="addFileList03"><input name="spc_file_03" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>모듈<a href="javascript:addList('addFileList04')" class="btn_add fr">추가</a></th>
							<td id="addFileList04"><input name="spc_file_04" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>인버터<a href="javascript:addList('addFileList05')" class="btn_add fr">추가</a></th>
							<td id="addFileList05"><input name="spc_file_05" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>결선도<a href="javascript:addList('addFileList06')" class="btn_add fr">추가</a></th>
							<td id="addFileList06"><input name="spc_file_06" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>토목<a href="javascript:addList('addFileList07')" class="btn_add fr">추가</a></th>
							<td id="addFileList07"><input name="spc_file_07" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>구조물<a href="javascript:addList('addFileList08')" class="btn_add fr">추가</a></th>
							<td id="addFileList08"><input name="spc_file_08" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>접속반<a href="javascript:addList('addFileList09')" class="btn_add fr">추가</a></th>
							<td id="addFileList09"><input name="spc_file_09" type="file"></td>
							<td></td>
						</tr>
						<tr>
							<th>기타설비<a href="javascript:addList('addFileList10')" class="btn_add fr">추가</a></th>
							<td id="addFileList10"><input name="spc_file_10" type="file"></td>
							<td></td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<div class="btn_wrap_type04">
			<button type="button" class="btn_type big" onclick="setSaveData();">등록</button>
		</div>
	</div>
</div>
