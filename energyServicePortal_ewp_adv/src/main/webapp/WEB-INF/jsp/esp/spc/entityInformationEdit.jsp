<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script src="/js/commonDropdown.js"></script>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function () {
		initProcess();
		$("#unitPriceList").on("click", "li", unitPriceListChange);
	});

	$(document).on('click', '.dropdown li', function () {
		var dataValue = $(this).data('value'),
			dataText = $(this).text();
		$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);
	});

	function initProcess(){
		initAddListHtml(); //추가 기능 관련 초기화
		getSpcAndGenData(); //저장되어있는 spc정보조회
	}

	function initAddListHtml(){
		$("#addList01").data("form", $("#addList01").html()).data("count", ($("#addList01").html().match(/input/g) || []).length);
		$("#addList02").data("form", $("#addList02").html()).data("count", ($("#addList02").html().match(/input/g) || []).length);
		$("#addList03").data("form", $("#addList03").html()).data("count", ($("#addList03").html().match(/input/g) || []).length);
		$("#addList04").data("form", $("#addList04").html()).data("count", ($("#addList04").html().match(/input/g) || []).length);
		$("#addList05").data("form", $("#addList05").html()).data("count", ($("#addList05").html().match(/input/g) || []).length);
		$("#addList06").data("form", $("#addList06").html()).data("count", ($("#addList06").html().match(/input/g) || []).length);
		$("#addList07").data("form", $("#addList07").html()).data("count", ($("#addList07").html().match(/input/g) || []).length);

		setInitList("fileList01");
		setInitList("fileList02");
		setInitList("fileList03");
		setInitList("fileList04");
		setInitList("fileList05");
		setInitList("fileList06");
		setInitList("fileList07");
		setInitList("fileList08");
		setInitList("fileList09");
		setInitList("fileList10");

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

	function getAttachFileDisplay(attachement_info){
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}",
			oid = "${param.oid}";

		var	addFileList01 = [],addFileList02 = [],addFileList03 = [],addFileList04 = [],addFileList05 = [],
			addFileList06 = [],addFileList07 = [],addFileList08 = [],addFileList09 = [],addFileList10 = [];

		for(var i = 0, count = attachement_info.length; i < count; i++){
			if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_01") {
				addFileList01.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_02") {
				addFileList02.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_03") {
				addFileList03.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_04") {
				addFileList04.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_05") {
				addFileList05.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_06") {
				addFileList06.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_07") {
				addFileList07.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_08") {
				addFileList08.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_09") {
				addFileList09.push(attachement_info[i]);
			} else if (attachement_info[i].fieldname.substring(0, 11) == "spc_file_10") {
				addFileList10.push(attachement_info[i]);
			}
		}

			

		setMakeList(addFileList01, "fileList01", {"dataFunction" : {}});
		setMakeList(addFileList02, "fileList02", {"dataFunction" : {}});
		setMakeList(addFileList03, "fileList03", {"dataFunction" : {}});
		setMakeList(addFileList04, "fileList04", {"dataFunction" : {}});
		setMakeList(addFileList05, "fileList05", {"dataFunction" : {}});
		setMakeList(addFileList06, "fileList06", {"dataFunction" : {}});
		setMakeList(addFileList07, "fileList07", {"dataFunction" : {}});
		setMakeList(addFileList08, "fileList08", {"dataFunction" : {}});
		setMakeList(addFileList09, "fileList09", {"dataFunction" : {}});
		setMakeList(addFileList10, "fileList10", {"dataFunction" : {}});
	}

	function setRemoveFileList(fileId, idx){
		var jsonList =  $("#"+fileId).data("gridJsonData");

		jsonList.splice(idx, 1);
		setMakeList(jsonList, fileId, {"dataFunction" : {}});
	}

	function addList(addId){
		var $selecter = $("#" + addId);
		$selecter.append($selecter.data("form"));
		if(addId.indexOf('addFileList') > -1){
			if($selecter.find('input').length >1){
				for(let i = 0; i < $selecter.find('input').length; i++){
					let nowName = $selecter.find('input').eq(i).attr('name');
					$selecter.find('input').eq(i).attr('name', nowName + '_'+ i);
				}
			}
		}
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

	function getAddListDisplay(addId, jsonData){
		var $selecter = $("#" + addId),
			rowInputCount = $selecter.data("count");

		for(var i = 0 , count = jsonData.length; i < count; i++){
			var rowData = jsonData[i];
			for(var key in rowData){
				$("input[name='"+ key +"']").eq(i).val(rowData[key]);
			}

			if(i != count -1 ){
				addList(addId);	//행추가
			}
		}
	}

	function unitPriceListChange(){
		var txt = $(this).find("a").text(),
			idx = $("#unitPriceList").find("li").index(this);

		$("#기준_단가").val(txt);
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

	function getSpcAndGenData(){
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}";

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/"+ spcId,
			type: "get",
			async: true,
			data: {"oid": oid},
			success: function (json) {
				if(json.data.length > 0){
					setJsonAutoMapping(json.data[0], "spc_info");
				}
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});

		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites/"+ genId,
			type: "get",
			async: true,
			data: {},
			success: function (json) {
				$("#genName").text(json.name);
				$("#countryValue").text("대한민국");
				$("#sidoValue").text(json.location);
				$("#address").text(json.address)
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/"+ spcId + "/gens/" + genId,
			type: "get",
			async: true,
			data: {"oid": oid},
			success: function (json) {
				if(json.data.length > 0){
					setJsonAutoMapping(JSON.parse(json.data[0].contract_info), "contract_info");
					setJsonAutoMapping(JSON.parse(json.data[0].device_info), "device_info");
					setJsonAutoMapping(JSON.parse(json.data[0].finance_info), "finance_info");
					setJsonAutoMapping(JSON.parse(json.data[0].warranty_info), "warranty_info");
					setJsonAutoMapping(JSON.parse(json.data[0].coefficient_info), "coefficient_info");
					setJsonAutoMapping(JSON.parse(json.data[0].contact_info), "contact_info");
					getAttachFileDisplay(JSON.parse(json.data[0].attachement_info));

					setDropDownValue("unitPriceList", JSON.parse(json.data[0].warranty_info)["기준_단가"]);

					var device_info = JSON.parse(json.data[0].device_info);
					getAddListDisplay("addList01", device_info["addList01"]);
					getAddListDisplay("addList02", device_info["addList02"]);
					getAddListDisplay("addList03", device_info["addList03"]);
					getAddListDisplay("addList04", device_info["addList04"]);
					getAddListDisplay("addList05", device_info["addList05"]);
					getAddListDisplay("addList06", device_info["addList06"]);
					getAddListDisplay("addList07", device_info["addList07"]);
				}
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function setSaveData(){
		sendSpcPatchPost();
	}

	function sendSpcPatchPost(){
		var spcId = "${param.spc_id}";

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/"+ spcId + "?oid="+oid,
			type: "patch",
			dataType: 'json',
			async: true,
			contentType: "application/json",
			data: JSON.stringify({
				"name": $("#name").val(),
				"spc_info" : "",
				"updated_by" : loginId
			}),
			success: function (json) {
				sendSpcAttchFilePost();
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function sendSpcAttchFilePost(){
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}";

		$("#attachement_info").find("input[type=file]").each(function(){
			$(this).attr("name", this.name + "_" + spcId +"_" + genId);
		});
		console.log("new===", new FormData($('#attachement_info')[0]) )
		$.ajax({
			type: 'patch',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
			data: new FormData($('#attachement_info')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			success: function (result) {
				var existFileList =
					$("#fileList01").data("gridJsonData")
					.concat($("#fileList02").data("gridJsonData"))
					.concat($("#fileList03").data("gridJsonData"))
					.concat($("#fileList04").data("gridJsonData"))
					.concat($("#fileList05").data("gridJsonData"))
					.concat($("#fileList06").data("gridJsonData"))
					.concat($("#fileList07").data("gridJsonData"))
					.concat($("#fileList08").data("gridJsonData"))
					.concat($("#fileList09").data("gridJsonData"))
					.concat($("#fileList10").data("gridJsonData"));

				sendSpcGenPatchPost(existFileList.concat(result.files));
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function sendSpcGenPatchPost(files){
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}";

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
			url: "http://iderms.enertalk.com:8443/spcs/" + spcId +"/gens/" + genId + "?oid=" + oid,
			type: "patch",
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
				alert("수정되었습니다.");
				goNowPage(spcId, genId);
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}
	
	function goNowPage(spcId, genId){
		location.href = "/spc/entityDetails.do?spc_id=" + spcId + "&gen_id=" + genId + "&oid=" + oid;
	}

	function goMoveList(){
		location.href = "/spc/entityInformation.do";
	}
</script>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 수정</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>


<div class="row entity_wrap post content-wrapper">
	<div class="col-lg-12">
		<div class="indiv" id="basic_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">기본 정보</h2>
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
						<th>SPC명</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="spc" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">SPC<span class="caret"></span></button>
								<ul id="spcList" class="dropdown-menu" role="menu">
									<li data-value="[spc_id]"><a href="javascript:void(0);" >[name]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="SPC명 입력">
							</div>
						</td>
						<th>대표자</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="spc" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">SPC<span class="caret"></span></button>
								<ul id="spcList" class="dropdown-menu" role="menu">
									<li data-value="[spc_id]"><a href="javascript:void(0);" >[name]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="SPC명 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="business_license_num">사업자등록번호</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="business_license_num">
							</div>
						</td>
						<th><label for="legal_license_num">법인등록번호</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="legal_license_num">
							</div>
						</td>
					</tr>
					<tr>
						<th>발전소명</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="spc" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">SPC<span class="caret"></span></button>
								<ul id="spcList" class="dropdown-menu" role="menu">
									<li data-value="[spc_id]"><a href="javascript:void(0);" >[name]</a></li>
								</ul>
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="발전소명 입력">
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
								<button id="country" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="countryList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">대한민국</a></li>
									<li><a href="javascript:void(0);">일본</a></li>
								</ul>
							</div>
							<div class="dropdown placeholder edit mr-12">
								<button id="sido" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="sidoList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">서울특별시</a></li>
									<li><a href="javascript:void(0);">부산광역시</a></li>
								</ul>
							</div>
						</td>
						<th><label for="address"></label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="hidden" id="countryValue" value="">
								<input type="hidden" id="sidoValue" value="">
								<input type="text" id="address" placeholder="상세 주소">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="address">사업명</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="address">펀드명</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="address">금융사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="address">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="address">시공사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="address">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="address">사무위탁사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="address">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="address">괸리 운영사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>	
						<th><label for="address">담당자(연락처)</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="address" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="legal_seal_stamp">SPC 법인 인감</label></th>
						<td>
							<input type="file" id="legal_seal_stamp" class="hidden" name="seal_01" accept=".jpg, .png .pdf">
							<label for="legal_seal_stamp" class="btn file_upload">파일 선택</label>
							<span class="upload_text ml-16"></span>
						</td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>
		<div class="indiv mt25" id="maintenance_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">관리 운영 정보</h2>
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
						<th><label for="">설치 용량</label></th>
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
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="country" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="countryList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
							<div class="dropdown placeholder edit mr-12">
								<button id="sido" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="sidoList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">기상 관측 지점</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="담당부서" placeholder="부서 명">
							</div>
						</td>
						<th>하자 보증기간(전기)</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="country" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="countryList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
							<div class="dropdown placeholder edit mr-12">
								<button id="sido" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="sidoList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">정기 검사</label></th>
						<td>
							<div class="sel_calendar edit twin clear">
								<input type="text" id="하자_보증기간(토목)_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(토목)_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
						</td>
						<th></th>
						<td>
							<div class="fixed_height"></div>
						</td>
					</tr>
					<tr>
						<th>등기이사 소속 / 등기 이사 명</th>
						<td class="group_type">
							<div class="dropdown placeholder edit">
								<button id="country" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="countryList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
							<div class="dropdown placeholder edit mr-12">
								<button id="sido" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul id="sidoList" class="dropdown-menu" role="menu">
									<li><a href="javascript:void(0);">[value]</a></li>
								</ul>
							</div>
						</td>
						<th><label for="">등기 기간</label></th>
						<td>
							<div class="sel_calendar edit twin clear">
								<input type="text" id="하자_보증기간(토목)_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(토목)_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">계약 단가</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="하자_보증기간(전기)" placeholder="직접 입력">
							</div>
						</td>
						<th>상업 운전 개시일</th>
						<td>
							<div class="sel_calendar edit twin clear">
								<input type="text" id="하자_보증기간(토목)_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="하자_보증기간(토목)_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="">부지 소유 / 임대 구분</label></th>
						<td>
							<div class="rdo_type align_type">
								<fieldset>
									<legend sr-only="부지 소유 혹은 임대 구분"></legend>
									<input type="radio" id="properted" name="ownership" value="properted">
									<label for="properted">소유</label>
									<input type="radio" id="rented" name="ownership" value="rented">
									<label class="ml-24" for="rented">임대</label>
								</fieldset>
							</div>
						</td>
						<th>개발행위필증 교부 여부</th>
						<td>
							<div class="rdo_type align_type">
								<fieldset>
									<legend sr-only="부지 소유 혹은 임대 구분"></legend>
									<input type="radio" id="properted" name="ownership" value="properted">
									<label for="properted">소유</label>
									<input type="radio" id="rented" name="ownership" value="rented">
									<label class="ml-24" for="rented">임대</label>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
						<th>지상권 및 지상권부근저당 설정 여부</th>
						<td class="group_type">
							<div class="tx_inp_type edit">
								<input type="text" id="등기이사_소속" placeholder="등기이사 소속">
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="등기이사_명" placeholder="등기이사 명">
							</div>
						</td>
						<th>통산담보표지판 설정 여부</th>
						<td class="flex_wrapper">
							<div class="sel_calendar edit twin">
								<input type="text" id="등기_기간_from" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="등기_기간_to" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
							<div class="chk_type align_type">
								<input type="checkbox" id="등기_이사_만료_알림" name="chk_04_op01" value="Y">
								<label for="등기_이사_만료_알림">등기이사 만료 알림</label>
							</div>
						</td>
					</tr>
					<tr>
						<th>자가부지공장근저당 목록 설정 여부</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="계약_단가">
								<span>원</span>
							</div>
						</td>
						<th>권리증 보유 현황</th>
						<td>
							<div class="sel_calendar edit twin clear fl">
								<input type="text" id="commercial_opening_month" class="sel datepicker fromDate" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="commercial_opening_date" class="sel datepicker toDate" value="" autocomplete="off" placeholder="종료일">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="registeredSeal">운영 여부</label></th>
						<td>
							<input type="file" id="registeredSeal" class="hidden" name="seal_01" accept=".jpg, .png .pdf">
							<label for="registeredSeal" class="btn file_upload">파일 선택</label>
							<span class="upload_text ml-16"></span>
						</td>
						<th><label for="">관리 계약 구분</label></th>
						<td>
							<div class="rdo_type align_type">
								<fieldset>
									<legend sr-only="부지 소유 혹은 임대 구분"></legend>
									<input type="radio" id="properted" name="ownership" value="properted">
									<label for="properted">소유</label>
									<input type="radio" id="rented" name="ownership" value="rented">
									<label class="ml-24" for="rented">임대</label>
								</fieldset>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>
		<div class="indiv mt25" id="account_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">계정 정보</h2>
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
						<th><label for="">RPS 시스템 ID</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="">
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
						<th><label for="">전력 거래소 ID</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="name" placeholder="">
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
								<input type="text" id="name" placeholder="">
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
							<div class="tx_inp_type edit">
								<input type="text" id="loan_commitment_fee" name="loan_commitment_fee" placeholder="직접 입력">
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
					<tr>
						<th>
							<div class="fixed_height">은행 계좌</div>
							<a href="javascript:addList('addList01');" class="btn_add fr mt-offset-10">추가</a>
							<div class="fixed_height">예금주</div>
						</th>
						<td id="addList01">
							<div class="fixed_height group_type">
								<div class="dropdown placeholder edit">
									<button id="transaction_opt" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">입출금 구분<span class="caret"></span></button>
									<ul id="transaction_type" class="dropdown-menu" role="menu">
										<li data-value="deposit"><a href="javascript:void(0);">입금</a></li>
										<li data-value="withdrawal"><a href="javascript:void(0);">출금</a></li>
									</ul>
								</div>
								<div class="dropdown placeholder edit">
									<button id="bankOpt" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">은행 리스트<span class="caret"></span></button>
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
						</td>
						<th>
							<div class="fixed_height">
								<label for="account_num">계좌 번호</label>
							</div>
							<div class="fixed_height">
								<label for="account_num">계좌개설 은행(지점)</label>
							</div>
						</th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="account_num" name="account_num" placeholder="직접 입력">
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
						</th>
						<td>
							<div class="fixed_height"></div>

							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="total_volume" name="total_volume" placeholder="직접 입력">
									<span>MW</span>
								</div>
								<span class="fixed_height">(자동계산)원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="maintenance_cost" name="maintenance_cost" placeholder="직접 입력">
									<span>MW</span>
								</div>
								<span class="fixed_height">(자동계산)원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="repair_cost" name="repair_cost" placeholder="직접 입력">
									<span>MW</span>
								</div>
								<span class="fixed_height">(자동계산)원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="custodian_fee" name="custodian_fee" placeholder="직접 입력">
									<span>MW</span>
								</div>
								<span class="fixed_height">(자동계산)원/MW</span>
							</div>
							<div class="flex_start">
								<div class="tx_inp_type edit unit t1 mr-30">
									<input type="text" id="rental_cost" name="rental_cost" placeholder="직접 입력">
									<span>MW</span>
								</div>
								<span class="fixed_height">(자동계산)원/MW</span>
							</div>
						</td>
						<th class="th_align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"><label for="insurance_company">임대료 지급일</label></div>
						</th>
						<td>
							<div class="fixed_height"></div>
							<div class="tx_inp_type edit">
								<input type="text" id="insurance_company" name="insurance_company" placeholder="직접 입력">
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="insurance_company" name="insurance_company" placeholder="직접 입력">
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="insurance_company" name="insurance_company" placeholder="직접 입력">
							</div>
							<div class="tx_inp_type edit">
								<input type="text" id="insurance_company" name="insurance_company" placeholder="직접 입력">
							</div>
							<div class="sel_calendar edit">
								<input type="text" id="insurance_renewal_date" class="sel datepicker" name="insurance_renewal_date" value="" autocomplete="off" placeholder="날짜 선택">
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv mt25" id="finance_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">시공 계약 정보</h2>
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
							<div class="fixed_height w-90">자동 계산<span class="fr">원</span></div>
						</td>
						<th class="th_align_top">
							<div class="fixed_height"></div>
							<div class="fixed_height"><label for="insurance_company">실 지급일</label></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
							<div class="fixed_height"></div>
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
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv mt25" id="insurance_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">보험 정보
					<a href="javascript:addList('addList06');" class="btn_add ml-24">추가</a>
				</h2>
			</div>
			<div class="spc_tbl_row st_edit">
				<table id="addList06">
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>보험 정보</th>
						<td id="addList04">
							<fieldset class="group_type">
								<div class="rdo_type align_type">
									<fieldset>
										<legend sr-only="보험 정보"></legend>
										<input type="radio" id="rdo_insurance_opt1" name="rdo_insurance" value="rdo_insurance">
										<label for="rdo_insurance_opt1">조립 보험</label>
										<input type="radio" id="rdo_insurance_opt2" name="rdo_insurance" value="비통신">
										<label class="ml-24" for="rdo_insurance_opt2">CMI</label>
										<input type="radio" id="rdo_insurance_opt3" name="rdo_insurance" value="CGL">
										<label class="ml-24" for="rdo_insurance_opt3">CGL</label>
									</fieldset>
								</div>
							</fieldset>
						</td>
						<th></th>
						<td></td>

					</tr>
					<tr>
						<th><label for="installAngle">보험사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="installAngle" name="모듈_설치_각도" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="installAngle">보험 중개사</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" id="installAngle" name="모듈_설치_각도" placeholder="직접 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="installAngle">보험 기간</label></th>
						<td class="group_type">
							<div class="sel_calendar edit">
								<input type="text" id="interest_payment_date" class="sel datepicker fromDate" name="interest_payment_date" value="" autocomplete="off" placeholder="시작일">
								<input type="text" id="interest_payment_date" class="sel datepicker toDate" name="interest_payment_date" value="" autocomplete="off" placeholder="종료일">
							</div>
						</td>
						<th><label for="installAngle">보험료</label></th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" name="">
								<span>원</span>
							</div>
						</td>
					</tr>
					<tr>
						<th><label for="installAngle">자가부담금</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" name="" placeholder="직접 입력">
							</div>
						</td>
						<th><label for="installAngle">보험가액</label></th>
						<td>
							<div class="tx_inp_type edit">
								<input type="text" name="" placeholder="직접 입력">
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<div class="indiv mt25" id="device_info">
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
						<th>PR 보증치</th>
						<td>
							<div class="tx_inp_type edit unit t1">
								<input type="text" id="pr">
								<span>%</span>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
								<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
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
						<th><label for="installAngle">모듈 설치 각도</label><a href="javascript:addList('addList02');" class="btn_add fr">추가</a></th>
						<td id="addList02">
							<div class="tx_inp_type edit unit t1 fl">
								<input type="text" name="모듈_설치_각도" id="installAngle">&ensp;&deg;
							</div>
							<button class="btn_close hidden" onclick="removeList(this);">삭제</button>
						</td>
						<th>모듈 설치 방식</th>
						<td>
							<fieldset class="chk_type align_type">
								<legend sr-only="인버터 제조사/모델"></legend>
								<input type="checkbox" id="모듈_설치_방식_고정" name="chk_op" value="고정 가변식">
								<label for="모듈_설치_방식_고정" class="mr-24">고정 가변식</label>
								<input type="checkbox" id="모듈_설치_방식_트래커" name="chk_op" value="트래커">
								<label for="모듈_설치_방식_트래커" class="mr-24">트래커</label>
								<input type="checkbox" id="모듈_설치_방식_경사고정형" name="chk_op" value="경사 고정형">
								<label for="모듈_설치_방식_경사고정형">경사 고정형</label>
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
									<input type="text" name="인버터_용량">
									<span>kW</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="인버터_용량_대수">
									<span>대</span>
								</div>
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
									<input type="text" name="접속반_채널">
									<span>Ch</span>
								</div>
								<div class="tx_inp_type edit unit t1">
									<input type="text" name="접속반_채널_대수">
									<span>대</span>
								</div>
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
							<div class="rdo_type align_type">
								<fieldset>
								<legend sr-only="통신 방식"></legend>
								<input type="radio" id="rdo_03_op01" name="통신방식" value="통신"><label for="rdo_03_op01">통신</label><input type="radio" id="rdo_03_op02" name="통신방식" value="비통신"><label class="ml-24" for="rdo_03_op02">비통신</label></fieldset>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td>
							<div class="chk_type align_type">
								<fieldset>
									<legend sr-only="설치 타입"></legend>
									<input type="checkbox" id="설치_타입_그라운드" name="chk_op2" value="그라운드">
									<label for="설치_타입_그라운드">그라운드</label>

									<input type="checkbox" id="설치_타입_루프탑" name="chk_op2" value="루프탑">
									<label class="ml-24" for="설치_타입_루프탑">루프탑</label>

									<input type="checkbox" id="설치_타입_수상" name="chk_op2" value="수상">
									<label class="ml-24" for="설치_타입_수상">수상</label>
								</fieldset>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
							<fieldset class="rdo_type align_type">
								<legend sr-only="보증 방식"></legend>
								<input type="radio" id="rdo_op01" name="보증_방식" value="PR">
								<label for="rdo_op01">PR</label>
								<input type="radio" id="rdo_op02" name="보증_방식" value="발전 시간">
								<label for="rdo_op02">발전 시간</label>
								<input type="radio" id="rdo_op03" name="보증_방식" value="PR + 발전시간">
								<label for="rdo_op03">PR + 발전 시간</label>
							</fieldset>
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
							<div class="tx_inp_type edit unit t1"><input type="text" id="현재_적용_연차"><span>년차</span></div>
						</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="년간_관리_운영비"><span>만원</span></div>
						</td>
						<th>물가 반영 비율</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="물가_반영_비율"><span>%</span></div>
						</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td>
							<fieldset class="rdo_type align_type">
								<legend sr-only="추가 보수"></legend>
								<input type="radio" id="rdo_op2_01" name="추가_보수" value="유">
								<label for="rdo_op2_01">유</label>

								<input type="radio" id="rdo_op2_02" name="추가_보수" value="무">
								<label for="rdo_op2_02">무</label>
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
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
						<th>Degradation estimation</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="Degradation"><span>%</span></div>
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
							<div class="tx_inp_type edit unit t1"><input type="text" id="Degradation"><span>%</span></div>
						</td>
						<th>System Availability</th>
						<td>
							<div class="tx_inp_type edit unit t1"><input type="text" id="Availability"><span>%</span></div>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
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
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
				--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
			</div>
		</div>

		<form id="attachement_info" name="attachement_info">
			<div class="indiv attachement mt25">
				<div class="tbl_top"><h2 class="ntit mt25">첨부 파일</h2></div>
				<div class="spc_tbl_row">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:85%">
							<col>
						</colgroup>
						<tr>
							<th>현장 사진<a href="javascript:addList('addFileList09')" class="btn_add fr">추가</a></th>
							<td id="addFileList09">
								<input type="file" id="spc_site_pic_file" class="hidden" name="spc_file_01" accept=".gif, .jpg, .png">
								<label for="spc_site_pic_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>수배전반<a href="javascript:addList('addFileList10')" class="btn_add fr">추가</a></th>
							<td id="addFileList10">
								<input type="file" id="spc_incoming_panel_file" class="hidden" name="spc_file_02" accept=".gif, .jpg, .png">
								<label for="spc_incoming_panel_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16">암사 아리수 정수센터 수배전반 외형도.xlxs</span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>케이블<a href="javascript:addList('addFileList11')" class="btn_add fr">추가</a></th>
							<td id="addFileList11">
								<input type="file" id="spc_cable_file" class="hidden" name="spc_file_03">
								<label for="spc_cable_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>모듈<a href="javascript:addList('addFileList12')" class="btn_add fr">추가</a></th>
							<td id="addFileList12">
								<input type="file" id="spc_module_file" class="hidden" name="file">
								<label for="spc_module_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>인버터<a href="javascript:addList('addFileList13')" class="btn_add fr">추가</a></th>
							<td id="addFileList13">
								<input type="file" id="spc_inverter_file" class="hidden" name="spc_file_05" >
								<label for="spc_inverter_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>결선도<a href="javascript:addList('addFileList14')" class="btn_add fr">추가</a></th>
							<td id="addFileList14">
								<input type="file" id="spc_wiring_diagram_file" class="hidden" name="spc_file_06">
								<label for="spc_wiring_diagram_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>토목<a href="javascript:addList('addFileList15')" class="btn_add fr">추가</a></th>
							<td id="addFileList15">
								<input type="file" id="spc_civil_file" class="hidden" name="spc_civil_file">
								<label for="spc_civil_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>구조물<a href="javascript:addList('addFileList16')" class="btn_add fr">추가</a></th>
							<td id="addFileList16">
								<input type="file" id="spc_construct_file" class="hidden" name="spc_file_08">
								<label for="spc_construct_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>접속반<a href="javascript:addList('addFileList17')" class="btn_add fr">추가</a></th>
							<td id="addFileList17">
								<input type="file" id="spc_connection_board_file" class="hidden" name="spc_connection_board_file_09">
								<label for="spc_connection_board_file" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>기타설비<a href="javascript:addList('addFileList19')" class="btn_add fr">추가</a></th>
							<td id="addFileList19">
								<input type="file" id="spc_misc_device" class="hidden" name="spc_file_10">
								<label for="spc_misc_device" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<th></th>
							<td></td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" onclick="goMoveList();">목록</button><!--
					--><button type="button" class="btn_type ml-16" onclick="setSaveData();">수정</button>
				</div>
			</div>
		</form>
	</div>
</div>