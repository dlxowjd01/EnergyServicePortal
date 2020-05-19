<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script>
	let today = new Date();
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const siteList = JSON.parse('${siteList}');

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
		var column = ["spc_name","name","start_yyyymm","","cash_in","cash_out","balance"], //json Key
			header = ["SPC명","발전소 명","기준년월","용량","현금유입(원)" ,"현금유(원)", "기말 현금흐름(원)"]; //csv 파일 헤더

		getJsonCsvDownload($("#listData").data("gridJsonData"), column, header, "spc_spower.csv"); // json list, 컬럼, 헤더명, 파일명
	}

	function getDataList(){
		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/balance/year",
			type: "get",
			async: false,
			data: {oid: oid},
			success: function (result) {
				var jsonList = [],
					keyWord = $("#key_word").val();

				for(var i in result.data) {
					var temp = result.data[i];

					for(var j in siteList) {
						if(siteList[j].sid == temp.site_id) {
							result.data[i].name = siteList[j].name;
						}
					}
				}

				setMakeList(result.data, "listData", {"dataFunction" : {"INDEX" : getNumberIndex}}); //list생성

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

	function setCheckedDataModify() {
		var checkDataList = getCheckList("rowCheck");
		count = checkDataList.length,
			sucessCnt = 0;

		if(count == 0){
			alert("수정 할 목록을 선택하세요.");
			return;
		}

		for(var i = 0; i < count; i++){
			var rowData = checkDataList[i];
			var locationUrl = '/spc/balanceSheetEdit.do?spc_id=' + rowData.spc_id +'&site_id=' + rowData.site_id +'&yyyymm=' + rowData.start_yyyymm;

			location.href = locationUrl;
		}
	}

	function deleteRow() {
		var checkDataList = getCheckList("rowCheck");
		count = checkDataList.length,
			sucessCnt = 0;

		if(count == 0){
			alert("삭제 할 목록을 선택하세요.");
			return;
		}

		for(var i = 0; i < count; i++){
			var rowData = checkDataList[i];
			var locationUrl = '/spcs/'+ rowData.spc_id +'/balance/year?oid=' + oid + '&site_id=' + rowData.site_id +'&yyyy=' + rowData.balance_yyyy;
			$.ajax({
				url: 'http://iderms.enertalk.com:8443' + locationUrl,
				type: 'delete',
				async: false,
				data: {},
				success: function (json) {
					sucessCnt++;
				},
				error: function (request, status, error) { alert('처리 중 오류가 발생했습니다.'); return false; }
			});
		}

		if(sucessCnt > 0) {
			alert('삭제 되었습니다.');
			location.reload();
			return false;
		}
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 원가관리</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12 clear inp_align">
		<div class="fl">
			<span class="tx_tit">기준</span>
			<div class="sa_select">
				<div class="dropdown" id="year">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">2020년
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
						<li><a href="#">전체</a></li>
						<li><a href="#">2020년</a></li>
						<li><a href="#">2019년</a></li>
						<li><a href="#">2018년</a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<div class="tx_inp_type">
				<input type="text" id="searchName" name="searchName" placeholder="입력">
			</div>
		</div>
		<div class="fl">
			<button type="submit" class="btn_type">검색</button>
		</div>
		<div class="fr">
			<a href="javascript:getCsvDown();" class="save_btn">CVS 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type" onclick="location.href='/spc/balanceSheetPost.do'">신규 등록</button>
			</div>
			<div class="spc_tbl align_type">
				<table class="chk_type">
					<thead>
					<tr>
						<th>
							<input type="checkbox" id="chk_op01" value="순번">
							<label for="chk_op01"><span></span>순번</label>
						</th>
						<th><button class="btn_align down">SPC명</button></th>
						<th><button class="btn_align down">발전소 명</button></th>
						<th><button class="btn_align down">기준년월</button></th>
						<th class="right"><button class="btn_align down">용량(kW)</button></th>
						<th class="right"><button class="btn_align down">현금유입(원)</button></th>
						<th class="right"><button class="btn_align down">현금유출(원)</button></th>
						<th class="right"><button class="btn_align down">기말 현금흐름(원)</button></th>
					</tr>
					</thead>
					<tbody id="listData">
					<tr>
						<td>
							<input type="checkbox" id="chk_op[INDEX]" name="rowCheck" value="">
							<label for="chk_op[INDEX]"><span></span>[INDEX]</label>
						</td>
						<td>[spc_name]</td>
						<td><a href="/spc/entityDetailsBySite.do?spc_id=[spc_id]&site_id=[site_id]&balance_yyyy=[balance_yyyy]" class="tbl_link">[name]</a></td>
						<td>[start_yyyymm]</td>
						<td class="right">-</td>
						<td class="right">[cash_in]</td>
						<td class="right">[cash_out]</td>
						<td class="right">[balance]</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="setCheckedDataModify();">선택 수정</button>
				<button type="button" class="btn_type03" onclick="deleteRow();">선택 삭제</button>
			</div>
			<div class="paging_wrap">
				<a href="#;" class="btn_prev">prev</a>
				<strong>1</strong>
				<a href="#;" class="btn_next">next</a>
			</div>
		</div>
	</div>
</div>
