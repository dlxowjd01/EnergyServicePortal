<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	let templateList = '';
	let cnt = 0;
	let sectionId = [];
	var countryList = [{"value" : "대한민국"}];
	var sidoList = [
		{"value" :"서울"},{"value" :"부산"},{"value" :"대구"},{"value" :"인천"},{"value" :"광주"},
		{"value" :"울산"},{"value" :"세종"},{"value" :"경기"},{"value" :"강원"},{"value" :"충북"},{"value" :"충남"},
		{"value" :"전북"},{"value" :"전남"},{"value" :"경북"},{"value" :"경남"},{"value" :"제주"}
	];

	// <li data-value="january"><a href="javascript:void(0);">1월</a></li>
	// <li data-value="february"><a href="javascript:void(0);">2월</a></li>
	// <li data-value="march"><a href="javascript:void(0);">3월</a></li>
	// <li data-value="april"><a href="javascript:void(0);">4월</a></li>
	// <li data-value="may"><a href="javascript:void(0);">5월</a></li>
	// <li data-value="june"><a href="javascript:void(0);">6월</a></li>
	// <li data-value="july"><a href="javascript:void(0);">7월</a></li>
	// <li data-value="august"><a href="javascript:void(0);">8월</a></li>
	// <li data-value="september"><a href="javascript:void(0);">9월</a></li>
	// <li data-value="october"><a href="javascript:void(0);">10월</a></li>
	// <li data-value="november"><a href="javascript:void(0);">11월</a></li>
	// <li data-value="december"><a href="javascript:void(0);">12월</a></li>

	$(function () {
		initProcess();
		cloneHtml();
		$("#spcList").on("click", "li", spcListChange);
		$("#genList").on("click", "li", genListChange);
		$("#countryList").on("click", "li", conntryListChange);
		$("#sidoList").on("click", "li", sidoListChange);
		$("#unitPriceList").on("click", "li", unitPriceListChange);
		$("#recCalcList").find("li a").on("click", function(){
			if($(this).parent("li").data("value")==3){
				$("#recCalcVal").val("-        ")
			} else {

			}
		})
	});

	$(document).on('click', '.dropdown li', function () {
		var dataValue = $(this).data('value'),
			dataText = $(this).text();
		$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);
	});
	function cloneHtml(){
		templateList = $("#insuranceInfo").find("template.copy_list").clone().html();
		$("#insuranceInfo").find("template.copy_list").remove();

	}
	function initProcess(){
		initAddListHtml(); //추가 기능 관련 초기화
		setComboBoxData(); //시도 설정
		getSpcData();//SPC명 설정
		getGenData();//발전소명 설정
	}

	function initAddListHtml(){
		$("#addList01").data("form", $("#addList01").html()).data("count", ($("#addList01").html().match(/input/g) || []).length);
		$("#insuranceInfo").data("form", $("#insuranceInfo").html()).data("count", ($("#insuranceInfo").html().match(/input/g) || []).length);
		$("#addList02").data("form", $("#addList02").html()).data("count", ($("#addList02").html().match(/input/g) || []).length);
		// $("#addList03").data("form", $("#addList03").html()).data("count", ($("#addList03").html().match(/input/g) || []).length);
		// $("#addList04").data("form", $("#addList04").html()).data("count", ($("#addList04").html().match(/input/g) || []).length);
		// $("#addList05").data("form", $("#addList05").html()).data("count", ($("#addList05").html().match(/input/g) || []).length);
		// $("#addList06").data("form", $("#addList06").html()).data("count", ($("#addList06").html().match(/input/g) || []).length);

		$("#addFileList01").data("form", $("#addFileList01").html());
		$("#insuranceInfo").data("form", $("#insuranceInfo").html());
		$("#addFileList02").data("form", $("#addFileList02").html());
		// $("#addFileList03").data("form", $("#addFileList03").html());
		// $("#addFileList04").data("form", $("#addFileList04").html());
		// $("#addFileList05").data("form", $("#addFileList05").html());
		// $("#addFileList06").data("form", $("#addFileList06").html());
	}

	function addList(addId){
		var $selector = $("#" + addId);
		let copySelector = $selector.clone();
		cnt += 1;

		if(addId == "insuranceInfo"){
			let copy = $(templateList);
			// 아래 3줄은 꺽 필요하진 않을 수도 => html 에 바로 삭제 하는 부분 처리.
			sectionId[cnt] = "insuranceSection"+cnt;
			copy.attr("id", sectionId[cnt]);
			copy.find(".delete_icon").attr("id", sectionId[cnt]);

			copy.find("input").each(function(){
				let newId = $(this).attr("id") + cnt;
				$(this).attr("id", newId);
			});

			$selector.append(copy);
		} else {
			copySelector.find("input:text").each(function() {
				$(this).val('');
			});
			copySelector.find(".btn_type07").removeClass("hidden");
			copySelector.insertAfter($selector);
		}
	}
	
	function deleteInfo(e){
		console.log("delete===", e);
	}
	function removeList(obj){
		if( $(obj).parent().parent().find(".group_type").length > 1){
			$(obj).parent().remove();	
		};		
	}

	function setAddListParam(addId){
		var param = [],
			$selector = $("#" + addId),
			rowInputCount = $selector.data("count"),
			allInputCount = $selector.find("input[type='text']").length;

		for(var i = 0, count = allInputCount / rowInputCount; i < count; i++){
			var rowData = {};
			for(var j = i*rowInputCount; j < i * rowInputCount + rowInputCount; j++){
				var $input = $selector.find("input[type='text']").eq(j);
				rowData[$input.attr("name")] = $input.val();
			}
			param.push(rowData);
		}

		return param;
	}

	function setDropDownValue(id, data){
		var $selector = $("#" + id);
		$selector.find("li").each(function(){
			if($(this).text() == data){
				$selector.parents('.dropdown').find('button').html(data + '<span class="caret"></span>').data('value', data);
				return false;
			}
		});
	}

	function spcListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#spcList").find("li").index(this),
			jsonData = $("#spcList").data("gridJsonData")[idx],
			disabledInput = $("#name").parents(".tx_inp_type.edit");

		if(jsonData.spc_id == ""){
			$("#name").val("").prop("readonly", false);
			disabledInput.removeClass("disabled");
		}else{
			$("#name").val(jsonData["name"]).prop("readonly", true);
			disabledInput.addClass("disabled");
		}
	}

	function genListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#genList").find("li").index(this),
			jsonData = $("#genList").data("gridJsonData")[idx],
			disabledInput = $("#name").parents(".tx_inp_type.edit");

		disabledInput.addClass("disabled");
		$("#genName").val(jsonData.name);

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

<div class="row entity_wrap_header">
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

<form id="upload" name="upload" method="multipart/form-data"></form>

<div class="row entity_wrap post panel-group" id="accordion">
	<div class="col-12">
		<div class="indiv panel panel-default" id="basicInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">기본 정보</h2><a role="button" href="#basicInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="basicInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>SPC명</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="spc" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">SPC<span class="caret"></span></button>
								<ul id="spcList" class="dropdown-menu" role="menu">
									<li data-value="[spc_id]"><a href="javascript:void(0);" >[name]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit disabled"><!--
							--><label for="spcName" class="sr-only">SPC명 입력</label><!--
							--><input type="text" id="name" placeholder="SPC명 입력"><!--
						--></div>
						</td>
						<th><label for="name">대표자</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="name" name="name" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="businessLicenseNum">사업자등록번호</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="businessLicenseNum" name="business_license_num" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="legalLicenseNum">법인등록번호</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="legalLicenseNum" name="legal_license_num" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="genName">발전소명</label></th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="gen" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">SPC<span class="caret"></span></button>
								<ul id="genList" class="dropdown-menu" role="menu">
									<li data-value="[sid]"><a href="javascript:void(0);" >[name]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="genName" name="power_plant_name" placeholder="발전소명 입력">
							</div>
						</td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="country" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">국가 선택<span class="caret"></span></button>
								<ul id="countryList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">대한민국</a></li>
									<li><a href="javascript:void(0);">일본</a></li>
								</ul>
							</div>
							<div class="dropdown placeholder edit mr-12">
								<button id="sido" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">시/도 선택<span class="caret"></span></button>
								<ul id="sidoList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">서울특별시</a></li>
									<li><a href="javascript:void(0);">부산광역시</a></li>
								</ul>
							</div>
						</td>
						<th><label for="address">상세 주소</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="hidden" id="countryValue" value="">
								<input type="hidden" id="sidoValue" value="">
								<input type="text" id="address" name="minor_address" placeholder="상세 주소">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="businessName">사업명</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="businessName" name="business_name" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="fundName">펀드명</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="fundName" name="fund_name" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="financeCompany">금융사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="financeCompany" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="financeContact">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="financeContact" name="finance_contact" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="constructionCompany">시공사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="constructionCompany" name="construction_company" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="constructionContact">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="constructionContact" name="construction_contact" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="custodianAgent">사무위탁사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="custodianAgent" name="custodian_agent" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="custodianContact">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="custodianContact" name="custodian_contact" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="managementAgent">괸리 운영사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="managementAgent" name="management_agent" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="managementContact">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="managementContact" name="management_contact" placeholder="직접 입력">
							</div>
					</td>
					</tr>
					<tr>
						<th>SPC 법인 인감</th>
						<td>
							<input type="file" id="legalSealStamp" class="hidden" name="seal_01" accept=".jpg, .png, .pdf">
							<label for="legalSealStamp" class="btn file_upload">파일 선택</label>
							<span class="upload_text ml-16"></span>
						</td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="maintenanceInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">관리 운영 정보</h2><a href="#maintenanceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="maintenanceInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>설치 용량</th>
						<td>
							<fieldset>
								<legend class="sr-only">설치 용량 및 설치 용량 기타</legend>
								<div class="group_type">
									<div class="tx_inp_type edit unit t1">
										<input type="text" id="설치_용량">
										<span>kW</span>
									</div>
									<div class="tx_inp_type edit">
										<input type="text" id="설치_용량_기타" placeholder="태양광">
									</div>
								</div>
							</fieldset>
						</td>
						<th>관리 운영 기간</th>
						<td>
							<fieldset class="sel_calendar edit twin clear">
								<legend class="sr-only">관리 운영 기간</legend>
								<input type="text" id="하자_보증기간(토목)_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(토목)_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="기상_관측_지점">기상 관측 지점</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="기상_관측_지점" name="기상_관측_지점" placeholder="직접 입력">
							</div>
						</td>
						<th>하자 보증기간(전기)</th>
						<td>
							<fieldset class="sel_calendar edit twin clear">
								<legend class="sr-only">하자 보증기간(전기)</legend>
								<input type="text" id="하자_보증기간(전기)_from" name="power_warranty_start_date" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(전기)_to" name="power_warranty_end_date" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="사용_전_검사_완료일">사용 전 검사 완료일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="사용_전_검사_완료일" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th>하자 보증기간(토목)</th>
						<td>
							<fieldset class="sel_calendar edit twin clear">
								<legend class="sr-only">하자 보증기간(토목)</legend>
								<input type="text" id="하자_보증기간(토목)_from" name="civil_warranty_start_date" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(토목)_to" name="civil_warranty_end_date" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>정기 검사</th>
						<td>
							<fieldset class="sel_calendar edit twin clear">
								<legend class="sr-only">정기 검사</legend>
								<input type="text" id="정기_검사_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="정기_검사_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</fieldset>
						</td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
					<tr>
						<th>등기이사 소속 / 등기 이사 명</th>
						<td class="group_type">
							<div class="tx_inp_type edit">
								<label for="등기이사_소속" class="sr-only">등기이사 소속 / 등기 이사 명</label>
								<input type="text" id="등기이사_소속" name="director_affiliation" placeholder="등기이사 소속">
							</div>
							<div class="tx_inp_type edit">
								<label for="등기이사_명" class="sr-only"></label>
								<input type="text" id="등기이사_명" name="director_name" placeholder="등기 이사 명">
							</div>
						</td>
						<th>등기 기간</th>
						<td class="flex_start">
							<fieldset class="sel_calendar edit twin clear">
								<legend class="sr-only">등기 기간</legend>
								<input type="text" id="등기_기간_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="등기_기간_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</fieldset>
							<div class="chk_type align_type ml-38">
								<input type="checkbox" id="등기_이사_만료_알림" name="end_notice" value="Y">
								<label for="등기_이사_만료_알림"><span></span>등기이사 만료 알림</label>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="계약_단가">계약 단가</label></th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="계약_단가" name="base_contract_price" placeholder="직접 입력"><!--
							--><span>원</span>
							</div>
						</td>
						<th>상업 운전 개시일</th>
						<td>
							<fieldset class="sel_calendar edit twin clear">
								<legend class="sr-only">상업 운전 개시일</legend>
								<input type="text" id="commercialOperationStartDate" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="commercialOperationEndDate" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="">부지 소유 / 임대 구분</label></th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="부지 소유 혹은 임대 구분"></legend>
								<div class="radio_group">
									<input type="radio" id="privateProperty" name="ownership_opt" value="p">
									<label for="propertied"><span></span>소유</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rental" name="ownership_opt" value="r">
									<label class="ml-24" for="rental"><span></span>임대</label>
								</div>
							</fieldset>
						</td>
						<th>개발행위필증 교부 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="개발행위필증 교부 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="issued" name="issued_opt" value="issued">
									<label for="issued"><span></span>교부함</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="notApplicable" name="issued_opt" value="n/a">
									<label class="ml-24" for="notApplicable"><span></span>해당 없음</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>지상권 및 지상권부근저당 설정 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="지상권 및 지상권부근저당 설정 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="superficies" name="superficies_opt" value="superficies">
									<label for="superficies"><span></span>지상권</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rightOfSuperficies" name="superficies_opt" value="s">
									<label class="ml-24" for="rightOfSuperficies"><span></span>지상관부근저당</label>
								</div>
							</fieldset>
						</td>
						<th>통신담보표지판 설정 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="통신담보표지판 설정 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="" name="settings" value="settings">
									<label for="settings"><span></span>설정함</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rented" name="ownership" value="rented">
									<label class="ml-24" for="rented"><span></span>해당 없음</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>자가부지공장근저당 목록 설정 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="자가부지공장근저당 목록 설정 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="properted" name="ownership" value="properted">
									<label for="properted"><span></span>설정함</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rented" name="ownership" value="rented">
									<label class="ml-24" for="rented"><span></span>해당 없음</label>
								</div>
							</fieldset>
						</td>
						<th>권리증 보유 현황</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="부지 소유 혹은 임대 구분"></legend>
								<div class="radio_group">
									<input type="radio" id="properted" name="ownership" value="properted">
									<label for="properted"><span></span>사무위탁사</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rented" name="ownership" value="rented">
									<label class="ml-24" for="rented"><span></span>자산운영사</label>
								</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>운영 여부</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="운영 여부"></legend>
								<div class="radio_group">
									<input type="radio" id="operating" name="operationAvailability" value="yes">
									<label for="properted"><span></span>운영중</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="toBe" name="operationAvailability" value="tobe">
									<label class="ml-24" for="rented"><span></span>운영 예정</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="notAvailable" name="operationAvailability" value="no">
									<label class="ml-24" for="rented"><span></span>해지</label>
								</div>
							</fieldset>
						</td>
						<th>관리 계약 구분</th>
						<td>
							<div class="dropdown placeholder edit mr-12 w300" id="managementContract">
								<button id="contract_type" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="contractList" class="dropdown-menu dropdown-menu-form chk_type" role="menu">
									<!-- [name] list => 전체, 종합, 일반관리, 사무수탁, 보험, 안전관리자 -->
									<li data-value="[sid]"><!--
										--><a href="javascript:void(0);" tabindex="-1"><!--
										--><input type="checkbox" id="contract_[INDEX]" value="[sid]" name="site"><!--
										--><label for="contract_[INDEX]">[name]</label><!--
									--></a>
									</li>
								</ul>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="accountInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">계정 정보</h2><a role="button" href="#accountInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="accountInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="rpsId">RPS 시스템 ID</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="rpsId" name="rps_id" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="rpsPassword">PW</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="rpsPassword" name="rps_password" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="powerTraderId">전력 거래소 ID</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="">PW</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">발전사명</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="직접 입력">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="financeInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">금융 정보</h2><a role="button" href="#financeInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="financeInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="관련_금융사">금융사(자금 운영 기관)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="관련_금융사" placeholder="직접 입력">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><label for="contract_date">계약 체결일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="contract_date" class="sel datepicker" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th><label for="loan_commitment_fee">대출 약정액</label></th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="loan_commitment_fee" class="right" name="loan_commitment_fee"><!--
							--><span>원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="repayment_due">상환 만기일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="repayment_due" class="sel datepicker" name="repayment_due" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th><label for="interest_payment_date">이자 지급일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="interest_payment_date" class="sel datepicker" name="interest_payment_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="account_opened_branch">보장발전시간 정산일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="interest_payment_date" class="sel datepicker" name="interest_payment_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th><label for="custodian_interest_payment_date">대리기관 수수료 지급일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="interest_payment_date" class="sel datepicker" name="interest_payment_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
					</tr>
					<tr id="addList01">
						<th>
							<div class="fixed_height">은행 계좌</div>
							<a href="javascript:addList('addList01');" class="btn_add fr mt-offset-10">추가</a>
							<div class="fixed_height"><label for="예금주">예금주</label></div>
						</th>
						<td>
							<div class="fixed_height group_type short">
								<div class="dropdown placeholder edit">
									<button id="transaction_opt" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">입출금 구분<span class="caret"></span></button>
									<ul id="transaction_type" class="dropdown-menu" role="menu">
										<li data-value="deposit"><a href="javascript:void(0);">입금</a></li>
										<li data-value="withdrawal"><a href="javascript:void(0);">출금</a></li>
									</ul>
								</div>
								<div class="dropdown placeholder edit">
									<button id="bankOpt" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">계좌구분<span class="caret"></span></button>
									<ul id="bankList" class="dropdown-menu" role="menu">
										<li data-value="shinhan"><a href="javascript:void(0);">신한</a></li>
									</ul>
								</div>
								<div class="dropdown placeholder edit">
									<button id="bankOpt" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">은행 리스트<span class="caret"></span></button>
									<ul id="bankList" class="dropdown-menu" role="menu">
										<li data-value="shinhan"><a href="javascript:void(0);">신한</a></li>
									</ul>
								</div>
							</div>
							<div class="fixed_height">
								<div class="tx_inp_type edit">
									<input type="text" id="예금주" name="account_holder" placeholder="직접 입력">
								</div>
							</div>
						</td>
						<th>
							<div class="fixed_height"><label for="account_num">계좌 번호</label></div>
							<div class="fixed_height"><label for="account_setup_bank">계좌개설 은행(지점)</label></div>
						</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="account_num" name="account_num" placeholder="직접 입력">
							</div>
							<button class="btn_type07 mt-offset-10 hidden fr" onclick="$(this).parents().closest('tr').remove()"></button>
							<div class="tx_inp_type edit">
								<input type="text" id="account_setup_bank" name="account_setup_bank" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="account_num">빠른조회 비밀번호</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="account_num" name="account_num" placeholder="직접 입력">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>공인인증서 등록</th>
						<td id="addList03">
							<input type="file" id="certificate_registration" class="hidden" name="banking_file" accept=".jpg, .png">
							<label for="certificate_registration" class="btn file_upload">파일 선택</label>
							<span class="upload_text ml-16">등록 파일 이름</span>
						</td>
						<th><label for="certificate_password">인증서 비밀번호</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="certificate_password" name="certificate_password" placeholder="비밀번호를 입력해 주세요.">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="dsra_required_amount">DSRA 적립 요구금액</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="dsra_required_amount" name="dsra_required_amount" placeholder="직접 입력">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>
							<div class="fixed_height"><label for="fixed_amount">고정 금액</label></div>
							<div class="fixed_height"><label for="total_volume">전체 용량</label></div>
							<div class="fixed_height"><label for="maintenance_cost">관리 운영비</label></div>
							<div class="fixed_height"><label for="repair_cost">대수선비</label></div>
							<div class="fixed_height"><label for="custodian_fee">사무 수탁비</label></div>
							<div class="fixed_height"><label for="rental_cost">임대료</label></div>
							<div class="fixed_height"><label for="custodian_fee">SMP</label></div>
							<div class="fixed_height"><label for="rental_cost">REC</label></div>
						</th>
						<td class="align_top">
							<div class="fixed_height"></div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="total_volume" class="right" name="total_volume" placeholder="">
									<span>원</span>
								</div>
								<span class="fixed_height"><span class="auto_price">[value]</span>원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="maintenance_cost" class="right" name="maintenance_cost" placeholder="">
									<span>원</span>
								</div>
								<span class="fixed_height"><span class="auto_price">[value]</span>원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="repair_cost" class="right" name="repair_cost" placeholder="">
									<span>원</span>
								</div>
								<span class="fixed_height"><span class="auto_price">[value]</span>원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="custodian_fee" class="right" name="custodian_fee" placeholder="">
									<span>원</span>
								</div>
								<span class="fixed_height"><span class="auto_price">[value]</span>원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="rental_cost" name="rental_cost" placeholder="">
									<span>원</span>
								</div>
								<span class="fixed_height"><span class="auto_price">[value]</span>원/MW</span>
							</div>
							<div class="group_type">
								<div class="dropdown placeholder edit">
									<button id="smpCalcOpt" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">선택<span class="caret"></span></button>
									<ul id="smpCalcList" class="dropdown-menu" role="menu">
										<li data-value="1"><a href="javascript:void(0);">고정가</a></li>
										<li data-value="2"><a href="javascript:void(0);">월 가중 평균</a></li>
										<li data-value="3"><a href="javascript:void(0);">실시간</a></li>
									</ul>
								</div>
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="rental_cost" name="rental_cost" placeholder="">
									<span>원</span>
								</div>
								<span class="fixed_height"><span class="auto_price">[value]</span>원/kWh</span>
							</div>
							<div class="group_type">
								<div class="dropdown placeholder edit">
									<button id="recCalcOpt" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">고정가<span class="caret"></span></button>
									<ul id="recCalcList" class="dropdown-menu" role="menu">
										<li data-value="1"><a href="javascript:void(0);">고정가</a></li>
										<li data-value="2"><a href="javascript:void(0);">SMP + REC</a></li>
										<li data-value="3"><a href="javascript:void(0);">월별 추후 산정</a></li>
									</ul>
								</div>
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="recCalcVal" class="right" name="rental_cost" placeholder="">
									<span>원</span>
								</div>
								<span class="fixed_height"><span class="auto_price">[value]</span>원/kWh</span>
							</div>
						</td>
						<th>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"><label for="insurance_company">임대료 지급일</label></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
						</th>
						<td class="align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="sel_calendar edit">
								<input type="text" id="insurance_renewal_date" class="sel datepicker" name="insurance_renewal_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
							<div class="fixed_height"></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="contractInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">시공 계약 정보</h2><a role="button" href="#contractInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="contractInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="loan_commitment_fee">시공사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="loan_commitment_fee" name="loan_commitment_fee" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="cumulative_withdrawals">약정일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="insurance_renewal_date" class="sel datepicker" name="insurance_renewal_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">(도급 계약서) 공사 계약 금액</label></th>
						<td>
							<div class="tx_inp_type edit unit t1 mr-30">
								<input type="text" id="" name="" placeholder="직접 입력">
								<span>원</span>
							</div>
						</td>
						<th><label for="">약정 금액</label></th>
						<td>
							<div class="tx_inp_type edit unit t1 mr-30">
								<input type="text" id="" name="" placeholder="직접 입력">
								<span>원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">(도급 계약서) 사용전 검사일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="" class="sel datepicker" name="" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th><label for="">실 사용전 검사일자</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="" class="sel datepicker" name="" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">(도급 계약서) 준공일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="" class="sel datepicker" name="" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th><label for="">실 준공일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="" class="sel datepicker" name="" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">인출 가능 기한</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="" class="sel datepicker" name="" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>
							<div class="fixed_height"><label for="fixed_amount">지급 약정</label></div>
							<div class="fixed_height"><label for="fixed_amount">계약서 명시 인출일</label><span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
							<div class="fixed_height"><label for="maintenance_cost">지급금액</label><span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
							<div class="fixed_height"><label for="rental_cost">미지급액</label></div>
						</th>
						<td>
							<div class="fixed_height"></div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="repayment_due" class="sel datepicker" name="repayment_due" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</div>
							<div class="flex_start">

								<div class="sel_calendar edit">
									<input type="text" id="repayment_due" class="sel datepicker" name="repayment_due" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="repayment_due" class="sel datepicker" name="repayment_due" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" name="모듈_제조사" placeholder="직접 입력">
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" name="모듈_제조사" placeholder="직접 입력">
								</div>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit">
									<input type="text" name="모듈_제조사" placeholder="직접 입력">
								</div>
							</div>
							<div class="fixed_height w300">
								<span class="text">자동 계산</span>
								<span class="fr">원</span>
							</div>
						</td>
						<th class="align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height"><label for="insurance_company">실 지급일</label><span class="fr fixed_height">1차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">2차</span></div>
							<div class="fixed_height"><span class="fr fixed_height">3차</span></div>
						</th>
						<td class="align_top">
							<div class="fixed_height"></div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="repayment_due" class="sel datepicker" name="repayment_due" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="repayment_due" class="sel datepicker" name="repayment_due" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</div>
							<div class="flex_start">
								<div class="sel_calendar edit">
									<input type="text" id="repayment_due" class="sel datepicker" name="repayment_due" value="" autocomplete="off" placeholder="날짜 선택">
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="insuranceInfo">
			<div class="tbl_top panel-heading">
				<h2 class="ntit mt25">보험 정보<a role="button" href="javascript:addList('insuranceInfo');" class="btn_add ml-24">추가</a></h2><!--
				--><a role="button" href="#insuranceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a><!--
		--></div>
			<div id="insuranceInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>보험 정보</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="보험 정보"></legend>
								<div class="radio_group">
									<input type="radio" id="rdo_insurance_opt1" name="rdo_insurance" value="rdo_insurance">
									<label for="rdo_insurance_opt1"><span></span>조립 보험</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rdo_insurance_opt2" name="rdo_insurance" value="cmi">
									<label class="ml-24" for="rdo_insurance_opt2"><span></span>CMI</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rdo_insurance_opt3" name="rdo_insurance" value="cgl">
									<label class="ml-24" for="rdo_insurance_opt3"><span></span>CGL</label>
								</div>
							</fieldset>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th><label for="insuranceCompany">보험사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="insuranceCompany" name="insurance_company" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="insuranceAgent">보험 중개사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="insuranceAgent" name="insurance_agent" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="insurancePeriod">보험 기간</label></th>
						<td class="group_type">
							<legend class="sr-only">보험 기간</legend>
							<fieldset class="sel_calendar edit twin clear">
								<input type="text" id="interestStartDate" class="sel datepicker fromDate" name="insurance_start_date" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="interestEndDate" class="sel datepicker toDate" name="insurance_end_date" value="" autocomplete="off" placeholder="종료일">
							</fieldset>
						</td>
						<th><label for="insuranceFee">보험료</label></th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="insuranceFee" name="insurance_fee"><!--
							--><span>원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="deductible">자가부담금</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="deductible" name="deductible" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="insuranceValue">보험가액</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="insuranceValue" name="" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="installAngle">시작일</label></th>
						<td>
							<div class="sel_calendar edit">
								<input type="text" id="interest_payment_date" class="sel datepicker fromDate" name="start_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
						<th><label for="installAngle">종료일</label></th>
						<td class="flex_start">
							<div class="sel_calendar edit mr-24">
								<input type="text" id="interest_payment_date" class="sel datepicker toDate" name="end_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
							<span class="fixed_height">XX일 남음</span>
						</td>
					</tr>
					<tr>
						<th></th>
						<td></td>
						<th><label for="mature_date">만기일</label></th>
						<td class="flex_start">
							<div class="sel_calendar edit mr-24">
								<input type="text" id="mature_date" class="sel datepicker toDate" name="mature_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
							<span class="fixed_height">XX일 남음</span>
						</td>
					</tr>
				</table>
			</div>

			<template class="copy_list">
				<section>
					<div class="tbl_top flex_wrapper mt-offset-10"><h2 class="ntit">보험 정보</h2><button class="delete_icon btn_type07" onclick="$(this).parents().find('section').remove()"></button></div>
					<div class="spc_tbl_row st_edit">
						<table>
							<colgroup>
								<col style="width:15%">
								<col style="width:35%">
								<col style="width:15%">
								<col style="width:35%">
							</colgroup>
							<tr>
								<th>보험 정보</th>
								<td>
									<fieldset class="rdo_type flex_start">
										<legend sr-only="보험 정보"></legend>
										<div class="radio_group">
											<input type="radio" id="rdo_opt_" name="rdo_opt_" value="rdo_insurance">
											<label for="rdo_opt_"><span></span>조립 보험</label>
										</div>
										<div class="radio_group">
											<input type="radio" id="rdo_opt_" name="rdo_opt_" value="cmi">
											<label class="ml-24" for="rdo_opt_"><span></span>CMI</label>
										</div>
										<div class="radio_group">
											<input type="radio" id="rdo_opt_" name="rdo_opt_" value="cgl">
											<label class="ml-24" for="rdo_opt_"><span></span>CGL</label>
										</div>
									</fieldset>
								</td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th><label for="insuranceCompany">보험사</label></th>
								<td>
									<div class="tx_inp_type edit">
										<input type="text" id="insuranceCompany" name="insurance_company" placeholder="직접 입력">
									</div>
								</td>
								<th><label for="insuranceAgent">보험 중개사</label></th>
								<td>
									<div class="tx_inp_type edit">
										<input type="text" id="insuranceAgent" name="insurance_agent" placeholder="직접 입력">
									</div>
								</td>
							</tr>
							<tr>
								<th><label for="insurancePeriod">보험 기간</label></th>
								<td class="group_type">
									<legend class="sr-only">보험 기간</legend>
									<fieldset class="sel_calendar edit twin clear">
										<input type="text" id="interestStartDate" class="sel datepicker fromDate" name="insurance_start_date" value="" autocomplete="off" placeholder="시작일">
										<input type="text" id="interestEndDate" class="sel datepicker toDate" name="insurance_end_date" value="" autocomplete="off" placeholder="종료일">
									</fieldset>
								</td>
								<th><label for="insuranceFee">보험료</label></th>
								<td>
									<div class="tx_inp_type edit unit t1">
										<input type="text" id="insuranceFee" name="insurance_fee"><!--
									--><span>원</span>
									</div>
								</td>
							</tr>
							<tr>
								<th><label for="deductible">자가부담금</label></th>
								<td>
									<div class="tx_inp_type edit">
										<input type="text" id="deductible" name="deductible" placeholder="직접 입력">
									</div>
								</td>
								<th><label for="insuranceValue">보험가액</label></th>
								<td>
									<div class="tx_inp_type edit">
										<input type="text" id="insuranceValue" name="" placeholder="직접 입력">
									</div>
								</td>
							</tr>
							<tr>
								<th><label for="installAngle">시작일</label></th>
								<td>
									<div class="sel_calendar edit">
										<input type="text" id="interest_payment_date" class="sel datepicker fromDate" name="start_date" value="" autocomplete="off" placeholder="날짜 선택">
									</div>
								</td>
								<th><label for="installAngle">종료일</label></th>
								<td class="flex_start">
									<div class="sel_calendar edit mr-24">
										<input type="text" id="interest_payment_date" class="sel datepicker toDate" name="end_date" value="" autocomplete="off" placeholder="날짜 선택">
									</div>
									<span class="fixed_height">XX일 남음</span>
								</td>
							</tr>
							<tr>
								<th></th>
								<td></td>
								<th><label for="mature_date">만기일</label></th>
								<td class="flex_start">
									<div class="sel_calendar edit mr-24">
										<input type="text" id="mature_date" class="sel datepicker toDate" name="mature_date" value="" autocomplete="off" placeholder="날짜 선택">
									</div>
									<span class="fixed_height">XX일 남음</span>
								</td>
							</tr>
						</table>
					</div>
				</section>
			</template>
		</div>

		<div class="indiv panel panel-default" id="deviceInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">설비 정보</h2><a role="button" href="#deviceInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="deviceInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
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
									<label class="sr-only">모듈 제조사</label>
									<input type="text" id="module_manufacturer" name="모듈_제조사" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<label class="sr-only">모듈 제조사 모델</label>
									<input type="text" name="모듈_제조사_모델" placeholder="모델">
								</div>
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>설치 용량</th>
						<td class="group_type">
							<div class="tx_inp_type edit unit t1">
								<label class="sr-only">설치 용량 (KW)</label>
								<input type="text" id="설치_용량_KW"><span>kW</span><!--
						--></div>
							<div class="tx_inp_type edit unit t1">
								<label class="sr-only">설치 용량(매)</label>
								<input type="text" id="설치_용량_매"><span>매</span><!--
						--></div>
						</td>
					</tr>
					<tr>
						<th><label for="installAngle">모듈 설치 각도</label><a href="javascript:addList('addList02');" class="btn_add fr">추가</a></th>
						<td id="addList02">
							<div class="tx_inp_type edit unit t1 fl">
								<input type="text" id="installAngle" name="모듈_설치_각도">&ensp;&deg;
							</div>
							<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
						</td>
						<th>모듈 설치 방식</th>
						<td>
							<fieldset class="chk_type align_type">
								<legend sr-only="인버터 제조사/모델"></legend>
								<input type="checkbox" id="모듈_설치_방식_고정" name="chk_op" value="고정 가변식">
								<label for="모듈_설치_방식_고정" class="mr-24"><span></span>고정 가변식</label>
								<input type="checkbox" id="모듈_설치_방식_트래커" name="chk_op" value="트래커">
								<label for="모듈_설치_방식_트래커" class="mr-24"><span></span>트래커</label>
								<input type="checkbox" id="모듈_설치_방식_경사고정형" name="chk_op" value="경사 고정형">
								<label for="모듈_설치_방식_경사고정형"><span></span>경사 고정형</label>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th>인버터 제조사 / 모델<a href="javascript:addList('addList03');" class="btn_add fr">추가</a></th>
						<td id="addList03">
							<fieldset class="group_type">
								<legend sr-only="인버터 제조사/모델"></legend>
								<div class="tx_inp_type edit">
									<input type="text" name="인버터_제조사" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" name="인버터_제조사_모델" placeholder="모델">
								</div>
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</fieldset>
						</td>
						<th>인버터 용량 / 대수<a href="javascript:addList('addList04');" class="btn_add fr">추가</a></th>
						<td id="addList04">
							<fieldset class="group_type">
								<legend sr-only="인버터 용량 / 대수"></legend>
								<div class="tx_inp_type edit unit t1">
									<input type="text" id="인버터_용량" name="인버터_용량"><span>kW</span><!--
							--></div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" id="인버터_용량_대수" name="인버터_용량_대수"><span>대</span><!--
								--></div>
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</fieldset>
						</td>
					</tr>
					<tr>
						<th><label for="manufacturerInfo">접속반 제조사 / 모델</label><a href="javascript:addList('addList05');" class="btn_add fr">추가</a></th>
						<td id="addList05">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" placeholder="제조사" name="접속반_제조사" id="manufacturerInfo">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" placeholder="모델" name="접속반_제조사_모델">
								</div>
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
						<th>접속반 채널 / 대수<a href="javascript:addList('addList06');" class="btn_add fr">추가</a></th>
						<td id="addList06">
							<div class="group_type">
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="접속반_채널"><span>Ch</span><!--
							--></div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="접속반_채널_대수"><span>대</span><!--
							--></div>
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
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
							<fieldset class="rdo_type flex_start2">
								<legend sr-only="통신 방식"></legend><!--
							--><div class="radio_group"><!--
								--><input type="radio" id="rdo_03_op01" name="통신방식" value="통신"><!--
								--><label for="rdo_03_op01"><span></span>통신</label><!--
							--></div><!--
							--><div class="radio_group"><!--
								--><input type="radio" id="rdo_03_op02" name="통신방식" value="비통신"><!--
								--><label class="ml-24" for="rdo_03_op02"><span></span>비통신</label><!--
							--></div><!--
						--></fieldset>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td>
							<div class="chk_type align_type">
								<fieldset>
									<legend sr-only="설치 타입"></legend><!--
								--><input type="checkbox" id="설치_타입_그라운드" name="chk_op2" value="그라운드"><!--
								--><label for="설치_타입_그라운드"><span></span>그라운드</label><!--
								--><input type="checkbox" id="설치_타입_루프탑" name="chk_op2" value="루프탑"><!--
								--><label class="ml-24" for="설치_타입_루프탑"><span></span>루프탑</label><!--
								--><input type="checkbox" id="설치_타입_수상" name="chk_op2" value="수상"><!--
								--><label class="ml-24" for="설치_타입_수상"><span></span>수상</label><!--
							--></fieldset>
							</div>
						</td>
						<th>수배전반 제조사 / 모델<a href="javascript:addList('addList06');" class="btn_add fr">추가</a></th>
						<td id="addList06">
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" name="접속반_채널" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" name="모델" placeholder="모델">
								</div>
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</div>
							<div class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" name="접속반_채널" placeholder="제조사">
								</div>
								<div class="tx_inp_type edit">
									<input type="text" name="모델" placeholder="모델">
								</div>
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="warrantyInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">보증 정보</h2><a role="button" href="#warrantyInfoToggle" data-toggle="collapse" data-parent="#accordion" class="collapse_arrow"></a></div>
			<div id="warrantyInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
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
							<fieldset class="rdo_type flex_start"><!--
							--><legend sr-only="보증 방식"></legend>
								<div class="radio_group"><!--
								--><input type="radio" id="rdo_op01" name="보증_방식" value="PR"><!--
								--><label for="rdo_op01"><span></span>PR</label><!--
							--></div><!--
							--><div class="radio_group"><!--
								--><input type="radio" id="rdo_op02" name="보증_방식" value="발전 시간"><!--
								--><label for="rdo_op02"><span></span>발전 시간</label><!--
							--><div class="radio_group"><!--
								--><input type="radio" id="rdo_op03" name="보증_방식" value="PR + 발전시간"><!--
								--><label for="rdo_op03"><span></span>PR + 발전 시간</label><!--
							--></div><!--
							--></fieldset>
						</td>
						<th>PR 보증치</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="PR_보증치"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="발전시간_보증치"><span>h</span></div>
						</td>
						<th>보증 감소율</th>
						<td>
							<div class="tx_inp_type edit unit t2"><input type="text" id="보증_감소율"><span>년차별 %</span></div>
						</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="unitPrice" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">기준 단가 선택<span class="caret"></span></button>
								<ul id="unitPriceList" class="dropdown-menu" role="menu" id="type">
									<li data-value=""><a href="javascript:void(0);">기준 단가 선택</a></li>
									<li data-value="FIT 단가"><a href="javascript:void(0);">FIT 단가</a></li>
									<li data-value="시장정산실적"><a href="javascript:void(0);">시장정산실적</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit unit t2">
								<input type="hidden" id="기준_단가">
								<input type="text" id="기준_단가_원"><span>원 / kW</span></div>
						</td>
						<th>현재 적용 연차</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="현재_적용_연차" name="latestYearOff"><span>년차</span></div>
						</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="년간_관리_운영비" name="annualManagementCost"><span>만원</span></div>
						</td>
						<th>물가 반영 비율</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="물가_반영_비율" name="inflationRatio"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td>
							<fieldset class="rdo_type flex_start">
								<legend sr-only="추가 보수"></legend>
								<div class="radio_group">
									<input type="radio" id="rdo_op2_01" name="추가_보수" value="유">
									<label for="rdo_op2_01"><span></span>유</label>
								</div>
								<div class="radio_group">
									<input type="radio" id="rdo_op2_02" name="추가_보수" value="무">
									<label for="rdo_op2_02"><span></span>무</label>
								</div>
							</fieldset>
						</td>
						<th>추가 보수 용량</th>
						<td>
							<div class="tx_inp_type edit unit t2"><input type="text" id="추가_보수_용량"><span>kW 이상</span></div>
						</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="추가_보수_백분율"><span>%</span></div>
						</td>
						<th>전력요금 종별</th>
						<td class="group_type">
							<div class="tx_inp_type edit">
								<input type="text" id="전력요금_종별_요금제" placeholder="요금제">
							</div>
							<div class="tx_inp_type edit unit t2"><input type="text" id="전력요금_종별_계약전력" placeholder="계약 전력"><span>kW</span></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="coefficientInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">환경 변수</h2><a href="#coefficientInfoToggle" data-toggle="collapse" class="collapse_arrow"></a></div>
			<div id="coefficientInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
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
							<div class="tx_inp_type edit unit t1"><input type="text" id="Annual"><span>%</span></div>
						</td>
						<th>PV modul modeling/params</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="PV_modul"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="Inverter"><span>%</span></div>
						</td>
						<th>Soiling, mismatch</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="Soiling"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th><label for="degradationEstimation">Degradation estimation</label></th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="degradationEstimation" name="degradation_estimation"><span>%</span></div>
						</td>
						<th><label for="degradationEstimation">Resulting ann, Variability(sigma)</label></th>
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
							<div class="tx_inp_type edit unit t1"><input type="text" id="Degradation" name="system_degradation"><span>%</span></div>
						</td>
						<th>System Availability</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="Availability" name="system_availability"><span>%</span></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default" id="associatedInfo">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">관련 정보</h2><a href="#associatedInfoToggle" data-toggle="collapse" class="collapse_arrow"></a></div>
			<div id="associatedInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in" role="tabpanel">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th><label for="전기안전_관리_회사명">전기안전 관리 회사명</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="전기안전_관리_회사명" name="power_safety_company" placeholder="직접 입력"></div>
						</td>
						<th><label for="회사_연락처"></label>회사 연락처</th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="회사_연락처" name="power_safety_contact" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="전기안전_관리_대표자명">전기안전 관리 대표자명</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="전기안전_관리_대표자명" name="power_safety_representative" placeholder="직접 입력"></div>
						</td>
						<th>대표자 연락처</th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="전기안전_관리_담당자명">전기안전 관리 담당자명</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="전기안전_관리_담당자명" name="power_safety_manager" placeholder="직접 입력"></div>
						</td>
						<th><label for="담당자_연락처">담당자 연락처</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="담당자_연락처" placeholder="직접 입력"></div>
						</td>
					</tr>
					<tr>
						<th><label for="현장_잠금장치_비밀번호">현장 잠금장치 비밀번호</label></th>
						<td>
							<div class="tx_inp_type edit"><input type="text" id="현장_잠금장치_비밀번호" name="site_security_code" placeholder="직접 입력"></div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>

		<div class="indiv panel panel-default attachement">
			<div class="tbl_top panel-heading"><h2 class="ntit mt25">첨부 파일</h2><a href="#attachementInfoToggle" data-toggle="collapse" class="collapse_arrow"></a></div>
				<div id="attachementInfoToggle" class="spc_tbl_row st_edit panel-collapse collapse in">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:55%">
							<col style="width:30%">
							<col>
						</colgroup>
						<tr>
							<th>현장 사진<a href="javascript:addList('addFileList01')" class="btn_add fr">추가</a></th>
							<td id="addFileList01"><!--
								--><input type="file" id="spc_site_pic_file" class="hidden" name="spc_file_01" accept=".gif, .jpg, .png"><!--
								--><label for="spc_site_pic_file" class="btn file_upload">파일 선택</label><!--
								--><span class="upload_text ml-16"></span><!--
							--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>수배전반<a href="javascript:addList('addFileList10')" class="btn_add fr">추가</a></th>
							<td id="addFileList10">
								<input type="file" id="spc_incoming_panel_file" class="hidden" name="spc_file_02" accept=".gif, .jpg, .png">
								<label for="spc_incoming_panel_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16">암사 아리수 정수센터 수배전반 외형도.xlxs</span><!--
						--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>케이블<a href="javascript:addList('addFileList11')" class="btn_add fr">추가</a></th>
							<td id="addFileList11">
								<input type="file" id="spc_cable_file" class="hidden" name="spc_file_03"><!--
							--><label for="spc_cable_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16"></span><!--
						--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>모듈<a href="javascript:addList('addFileList12')" class="btn_add fr">추가</a></th>
							<td id="addFileList12">
								<input type="file" id="spc_module_file" class="hidden" name="file"><!--
							--><label for="spc_module_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16"></span><!--
						--></td>
						<th></th>
						<td></td>
						</tr>
						<tr>
							<th>인버터<a href="javascript:addList('addFileList13')" class="btn_add fr">추가</a></th>
							<td id="addFileList13">
								<input type="file" id="spc_inverter_file" class="hidden" name="spc_file_05"><!--
							--><label for="spc_inverter_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16"></span><!--
						--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>결선도<a href="javascript:addList('addFileList14')" class="btn_add fr">추가</a></th>
							<td id="addFileList14">
								<input type="file" id="spc_wiring_diagram_file" class="hidden" name="spc_file_06"><!--
							--><label for="spc_wiring_diagram_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16"></span><!--
						--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>토목<a href="javascript:addList('addFileList15')" class="btn_add fr">추가</a></th>
							<td id="addFileList15"><!--
							--><input type="file" id="spc_civil_file" class="hidden" name="spc_civil_file"><!--
							--><label for="spc_civil_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16"></span><!--
						--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>구조물<a href="javascript:addList('addFileList16')" class="btn_add fr">추가</a></th>
							<td id="addFileList16"><!--
							--><input type="file" id="spc_construct_file" class="hidden" name="spc_file_08"><!--
							--><label for="spc_construct_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16"></span><!--
						--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>접속반<a href="javascript:addList('addFileList17')" class="btn_add fr">추가</a></th>
							<td id="addFileList17"><!--
							--><input type="file" id="spc_connection_board_file" class="hidden" name="spc_connection_board_file_09"><!--
							--><label for="spc_connection_board_file" class="btn file_upload">파일 선택</label><!--
							--><span class="upload_text ml-16"></span><!--
						--></td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>기타설비<a href="javascript:addList('addFileList19')" class="btn_add fr">추가</a></th>
							<td id="addFileList19"><!--
								--><input type="file" id="spc_misc_device" class="hidden" name="spc_file_10"><!--
								--><label for="spc_misc_device" class="btn file_upload">파일 선택</label><!--
								--><span class="upload_text ml-16"></span><!--
							--></td>
							<th></th>
							<td></td>
						</tr>
					</table>
				</div>
			</div>
		</div>

		<div class="btn_wrap_type_right">
			<a href="/spc/entityDetails.do" class="btn btn_type03">목록</a><!--
		--><button type="button" class="btn_type big" onclick="setSaveData();">등록</button>
		</div>
	</div>
</div>
