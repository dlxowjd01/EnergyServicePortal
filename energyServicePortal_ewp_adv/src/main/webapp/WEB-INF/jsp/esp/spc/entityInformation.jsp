<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 15:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>Title</title>
</head>
<body>
<script>
	$(function () {
		setInitList("listData"); //리스트초기화

		getDataList();
	});

	function getDataList(){
		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs",
			type: "get",
			async: false,
			data: {oid: "spower", includeGens: true},
			success: function (result) {
				var jsonList = [],
					keyWord = $("#key_word").val();

				for(var i = 0, count = result.data.length; i < count; i++){

					var spcGensList = result.data[i].spcGens;

					if(spcGensList !== undefined && spcGensList.length > 0){

						for(var j = 0, jcount = spcGensList.length; j < jcount; j++){
							var spcGensRow = spcGensList[j];
							var rowData = result.data[i];

							rowData["gen_id"] = spcGensRow.gen_id;
							rowData["발전소_명"] = spcGensRow.site_id;
							rowData["연차"] = "N년차(계산할것)";
							rowData["관리_운영_기간"] = spcGensRow.contract_info["관리_운영_기간"];
							rowData["보증_방식"] = spcGensRow.warranty_info["보증_방식"];
							rowData["PR_보증치"] = spcGensRow.warranty_info["PR_보증치"];
							rowData["보증_감소율"] = spcGensRow.warranty_info["보증_감소율"];
							rowData["추가보수"] = spcGensRow.warranty_info["추가보수"];

							//키워드 검색 조건 필터 처리
							if(rowData["name"].indexOf(keyWord) > -1){
								jsonList.push(rowData)
							}

						}
					}

				}

				setMakeList(jsonList, "listData", {"dataFunction" : {"발전소_명" : getGenName, "INDEX" : getNumberIndex}}); //list생성

			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function getNumberIndex(index){
		return index + 1;
	}

	function getGenName(siteId){
		var result = "";

		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites/" + siteId,
			type: "get",
			async: false,
			data: {includeDevices:false, includeRtus: false},
			success: function (json) {
				result = json.name;
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});

		return result;
	}

	function setCheckedAll(obj, chkName){
		var checkVal = obj.checked;
		$("input[name='"+chkName+"']").prop("checked", checkVal);
	}

	function getCheckList(checkName){
		var jsonList = $("#listData").data("gridJsonData"),
			checkList = [];
		$("input[name='"+checkName+"']").each(function(i){
			if(this.checked){
				checkList.push(jsonList[i]);
			}
		});

		return checkList;
	}

	function setCheckedDataRemove(){
		var checkDataList = getCheckList("rowCheck");
		count = checkDataList.length,
			sucessCnt = 0;

		if(count == 0){
			alert("삭제 할 목록을 선택하세요.");
			return;
		}

		for(var i = 0; i < count; i++){
			var rowData = checkDataList[i];
			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs/" + rowData.spc_id + "/gens/" + rowData.gen_id,
				type: "delete",
				async: false,
				data: {},
				success: function (json) {
					sucessCnt++;
				},
				error: function (request, status, error) {

				}
			});
		}

		alert(sucessCnt + "건 삭제처리되었습니다.");
		getDataList();
	}
</script>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 기본 정보</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-3">
		<div class="tx_btn_area">
			<div class="tx_inp_type">
				<input type="text" id="key_word" placeholder="입력">
			</div>
			<button class="btn_type" onclick="getDataList();">검색</button>
		</div>
	</div>
	<div class="col-lg-9">
		<div class="right">
			<a href="#;" class="save_btn">CVS 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn_wrap_type">
				<button type="button" class="btn_type03" onclick="setCheckedDataRemove();">선택 삭제</button>
				<a href="/spc/entityInformationPost.do">신규 등록</a>
			</div>
			<div class="spc_tbl align_type">
				<table class="chk_type">
					<thead>
					<tr>
						<th>
							<input type="checkbox" id="chk_header" value="순번" onclick="setCheckedAll(this, 'rowCheck');">
							<label for="chk_header"><span></span>순번</label>
						</th>
						<th><button class="btn_align down">SPC명</button></th>
						<th><button class="btn_align down">발전소 명</button></th>
						<th><button class="btn_align down">연차</button></th>
						<th><button class="btn_align down">관리 운영기간</button></th>
						<th><button class="btn_align up">보증</button></th>
						<th class="right"><button class="btn_align down">보증 값</button></th>
						<th class="right"><button class="btn_align down">감소율</button></th>
						<th>- 추가보수</th>
					</tr>
					</thead>
					<tbody id="listData">
					<tr>
						<td>
							<input type="checkbox" id="chk_op[INDEX]" name="rowCheck" value="">
							<label for="chk_op[INDEX]"><span></span>[INDEX]</label>
						</td>
						<td><a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]" class="tbl_link">[name]</a></td>
						<td><a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]" class="tbl_link">[발전소_명]</a></td>
						<td>[연차]</td>
						<td>[관리_운영_기간]</td>
						<td>[보증_방식]</td>
						<td class="right">[PR_보증치]</td>
						<td class="right">[보증_감소율]</td>
						<td>-</td>
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
</body>
</html>
