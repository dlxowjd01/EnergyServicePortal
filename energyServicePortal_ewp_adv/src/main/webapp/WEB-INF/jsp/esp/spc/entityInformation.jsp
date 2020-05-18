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
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function () {
		setInitList("listData"); //리스트초기화

		getDataList();
	});

	function nvl(value, str){
		if(isEmpty(value)){
			return str;
		}else{
			return value;
		}
	}

	function getCsvDown(){
		var column = ["name","발전소_명","연차","관리_운영_기간","보증_방식","PR_보증치","보증_감소율","추가_보수"], //json Key
			header = ["SPC명","발전소 명","연차","관리 운영기간	","보증" ,"보증 값", "감소율","추가보수"]; //csv 파일 헤더

		getJsonCsvDownload($("#listData").data("gridJsonData"), column, header, "spc_spower.csv"); // json list, 컬럼, 헤더명, 파일명
	}

	function getDataList(){
		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs",
			type: "get",
			async: false,
			data: {"oid": oid, includeGens: true},
			success: function (result) {
				var jsonList = [],
					keyWord = $("#key_word").val();

				for(var i = 0, count = result.data.length; i < count; i++){

					var spcGensList = result.data[i].spcGens;

					if(spcGensList !== undefined && spcGensList.length > 0){

						for(var j = 0, jcount = spcGensList.length; j < jcount; j++){
							var spcGensRow = spcGensList[j],
								rowData = result.data[i],
								newData = {},
								warrantyInfo = JSON.parse(spcGensRow.warranty_info),
								contractInfo = JSON.parse(spcGensRow.contract_info);

							newData["name"] = rowData.name;
							newData["oid"] = rowData.oid;
							newData["spc_id"] = rowData.spc_id;
							newData["gen_id"] = spcGensRow.gen_id;
							newData["발전소_명"] = spcGensRow.name;
							newData["관리_운영_기간"] = nvl(contractInfo["관리_운영_기간"], "-");
							newData["연차"] = nvl(warrantyInfo["현재_적용_연차"], "-");
							newData["보증_방식"] = nvl(warrantyInfo["보증_방식"], "-");
							newData["PR_보증치"] = nvl(warrantyInfo["PR_보증치"], "-");
							newData["보증_감소율"] = nvl(warrantyInfo["보증_감소율"], "-");
							newData["추가_보수"] = nvl(warrantyInfo["추가_보수"], "-");
							//키워드 검색 조건 필터 처리
							if(newData["name"].indexOf(keyWord) > -1 || newData["발전소_명"] .indexOf(keyWord) > - 1){
								jsonList.push(newData)
							}

						}
					}

				}

				setMakeList(jsonList, "listData", {"dataFunction" : {"INDEX" : getNumberIndex}}); //list생성

			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function getNumberIndex(index){
		return index + 1;
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
				url: "http://iderms.enertalk.com:8443/spcs/" + rowData.spc_id + "/gens/" + rowData.gen_id + "?oid="+oid,
				type: "delete",
				dataType: 'json',
				async: false,
				contentType: "application/json",
				data: {"oid": oid},
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

	function setCheckedDataEdit(){
		var checkDataList = getCheckList("rowCheck");
		count = checkDataList.length;

		if( count == 0){
			alert("수정 할 목록을 선택하세요.");
			return false;
		}else if(count > 1){
			alert("1개의 목록만 선택하세요.");
			return false;
		}

		var spcId = checkDataList[0].spc_id,
			genId = checkDataList[0].gen_id;

		location.href='/spc/entityInformationEdit.do?spc_id=' + spcId + "&gen_id="+genId;
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
			<a href="#;" class="save_btn" onclick="getCsvDown();">CVS 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn_wrap_type">
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
						<th><button class="btn_align down">보증</button></th>
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
						<td><a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">[name]</a></td>
						<td><a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">[발전소_명]</a></td>
						<td>[연차]</td>
						<td>[관리_운영_기간]</td>
						<td>[보증_방식]</td>
						<td class="right">[PR_보증치]</td>
						<td class="right">[보증_감소율]</td>
						<td>[추가_보수]</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setCheckedDataEdit();">선택 수정</button>
				<button type="button" class="btn_type03" onclick="setCheckedDataRemove();">선택 삭제</button>
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
