<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function () {
		var spcFrom = document.getElementById("spc_form");
		var keyWord = document.getElementById("key_word");

		keyWord.addEventListener("focus", function (e) {
			if (!keyWord.value.replace(/\s/g, '').length) {
				keyWord.value = '';
			} else {
				keyWord.value === keyWord.value;
			}
		});

		spcFrom.addEventListener("submit", function (e) {
			e.preventDefault();
			(!keyWord.value || !keyWord.value.trim()) ? (keyWord.value = '') : (keyWord.value === keyWord.value);
			getDataList(page);
		});

		setInitList("listData"); //리스트초기화
		getDataList(page);

		$('.save_btn').on('click', function (e) {
			let excelName = 'spc_info_list';
			let $val = $('#excelList').find('tbody');
			let cnt = $val.length;

			var aTag01 = '<a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">[name]</a>';
			var aTag02 = '<a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">[발전소_명]</a>';

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {

					$('tr td[name="aTagTd01"]').each(function () {
						$(this).html($(this).text())
					});
					$('tr td[name="aTagTd02"]').each(function () {
						$(this).html($(this).text())
					});
					tableToExcel('excelList', excelName, e);
				}
			}
			$('tr td[name="aTagTd01"]').html(aTag01);
			$('tr td[name="aTagTd02"]').html(aTag02);
			getDataList(page);
		});
	});

	$(document).on('keyup', '#key_word', function (e) {
		if (e.keyCode == 13) {
			getDataList(page);
		}
	})

	function nvl(value, str) {
		if (isEmpty(value)) {
			return str;
		} else {
			return value;
		}
	}

	function jsonDataFilter(jsonData) {
		var keyWord = $("#key_word").val().trim().toLowerCase(),
			bResult = false;

		if (jsonData["name"].toLowerCase().indexOf(keyWord) > -1 || jsonData["발전소_명"].toLowerCase().indexOf(keyWord) > -1) {
			bResult = true;
		}

		return bResult;
	}

	function setJsonDataFormat(result, page) {

		var jsonList = [],
			keyWord = $("#key_word").val();

		for (var i = 0, count = result.data.length; i < count; i++) {

			var spcGensList = result.data[i].spcGens;

			if (spcGensList !== undefined && spcGensList.length > 0) {
				for (var j = 0, jcount = spcGensList.length; j < jcount; j++) {

					var spcGensRow = spcGensList[j],
						rowData = result.data[i],
						newData = Object.assign({}, rowData),
						warrantyInfo = JSON.parse(spcGensRow.warranty_info),
						contractInfo = JSON.parse(spcGensRow.contract_info);

					newData["gen_id"] = spcGensRow.gen_id;
					newData["발전소_명"] = spcGensRow.name;
					newData["관리_운영_기간"] = nvl(contractInfo["관리_운영_기간"], "-");
					newData["연차"] = nvl(warrantyInfo["현재_적용_연차"], "-");
					newData["보증_방식"] = nvl(warrantyInfo["보증_방식"], "-");
					newData["PR_보증치"] = nvl(warrantyInfo["PR_보증치"], "-");
					newData["보증_감소율"] = nvl(warrantyInfo["보증_감소율"], "-");
					newData["추가_보수"] = nvl(warrantyInfo["추가_보수"], "-");

					//키워드 검색 조건 필터 처리
					if (jsonDataFilter(newData)) {
						jsonList.push(newData)
					}
				}
			}
		}
		jsonList = paging(page, jsonList);
		return jsonList;
	}

	function getDataList(page) {

		if (page == undefined) {
			page = 1;
		}

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs",
			type: "get",
			async: true,
			data: {
				"oid": oid,
				includeGens: true
			},
			success: function (result) {
			setMakeList(setJsonDataFormat(result, page), "listData", {
					"dataFunction": {
						"INDEX": getNumberIndex
					}
				}); //list생성
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function getNumberIndex(index) {
		return index + 1;
	}

	function setCheckedAll(obj, chkName) {
		var checkVal = obj.checked;
		$("input[name='" + chkName + "']").prop("checked", checkVal);
	}

	function getCheckList(checkName) {
		var jsonList = $("#listData").data("gridJsonData"),
			checkList = [];
		$("input[name='" + checkName + "']").each(function (i) {
			if (this.checked) {
				checkList.push(jsonList[i]);
			}
		});
		return checkList;
	}

	function setCheckedDataRemove() {
		var checkDataList = getCheckList("rowCheck"),
			count = checkDataList.length,
			sucessCnt = 0;

		if (count == 0) {
			alert("삭제 할 목록을 선택하세요.");
			return;
		}

		let delPrompt = prompt(count + '건을 삭제하시겠습니까? \n삭제를 원하시면 아래 "삭제"라고 입력하고 확인을 눌러 주세요.', '');

		if (delPrompt != '삭제') {
			return;
		}

		for (var i = 0; i < count; i++) {
			var rowData = checkDataList[i];
			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs/" + rowData.spc_id + "/gens/" + rowData.gen_id + "?oid=" + oid,
				type: "delete",
				dataType: 'json',
				async: false,
				contentType: "application/json",
				data: {
					"oid": oid
				},
				success: function (json) {
					sucessCnt++;
				},
				error: function (request, status, error) {

				}
			});
		}

		alert(sucessCnt + "건 삭제처리되었습니다.");
		getDataList(page);
	}

	function setCheckedDataEdit() {
		var checkDataList = getCheckList("rowCheck"),
			count = checkDataList.length;

		if (count == 0) {
			alert("수정 할 목록을 선택하세요.");
			return false;
		} else if (count > 1) {
			alert("1개의 목록만 선택하세요.");
			return false;
		}

		var spcId = checkDataList[0].spc_id,
			genId = checkDataList[0].gen_id;

		location.href = '/spc/entityInformationEdit.do?spc_id=' + spcId + "&gen_id=" + genId;
	}
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">SPC 기본 정보</h1>
		<div class="time fr">
			<span>CURRENT TIME</span> <em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span> <em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-10">
		<form id="spc_form">
			<div class="flex_start">
				<label for="operation_select" class="tx_tit">운영 여부</label>
				<div class="dropdown sa_select mr-16" id="operation_select">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="operationList">
						<li data-value="operation_[INDEX]">
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="operation_[INDEX]" value="operation_[INDEX]" name="operation_opt">
								<label for="operation_[INDEX]"><span></span>[name]</label>
							</a>
						</li>
					</ul>
				</div>

				<label for="warranty_select" class="tx_tit">보증 방식</label>
				<div class="dropdown sa_select mr-16" id="warranty_select">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="warrantyList">
						<li data-value="[sid]">
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="warranty_[INDEX]" value="warranty_[INDEX]" name="warranty_opt">
								<label for="warranty_[INDEX]"><span></span>[name]</label>
							</a>
						</li>
					</ul>
				</div>

				<label for="contract_select" class="tx_tit">계약 구분</label>
				<div class="dropdown sa_select mr-24" id="contract_select">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="contractList">
						<li data-value="[sid]">
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_[INDEX]" value="[sid]" name="contract_opt">
								<label for="contract_[INDEX]"><span></span>[name]</label>
							</a>
						</li>
					</ul>
				</div>

				<div class="tx_inp_type mr-12">
					<input type="text" id="key_word" placeholder="입력">
				</div>
				<button class="btn_type">검색</button>
			</div>
		</form>
	</div>
	<div class="col-2">
		<div class="right">
			<a href="#;" class="save_btn">엑셀 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn_wrap_type01">
				<button type="button" class="btn_type" onclick="location.href='/spc/entityInformationPost.do'">
					신규 등록
				</button>
			</div>
			<div class="spc_tbl align_type" id="excelList">
				<table class="sort_table chk_type">
					<colgroup>
						<col style="width:8%">
						<col style="width:8%">
						<col style="width:18%">
						<col style="width:8%">
						<col style="width:20%">
						<col style="width:8%">
						<col style="width:10%">
						<col style="width:10%">
						<col style="width:10%">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th><input
								type="checkbox" id="chk_header" value="순번"
								onclick="setCheckedAll(this, 'rowCheck');"><label for="chk_header">순번</label></th>
							<th><button class="btn_align down">SPC명</button></th>
							<th><button class="btn_align down">발전소 명</button></th>
							<th><button class="btn_align down">연차</button></th>
							<th><button class="btn_align down">관리 운영기간</button></th>
							<th><button class="btn_align down">보증</button></th>
							<th class="right"><button class="btn_align down">보증 값</button></th>
							<th class="right"><button class="btn_align down">감소율</button></th>
							<th><button class="btn_align down">- 추가보수</button></th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>
								<input type="checkbox" id="chk_op[INDEX]" name="rowCheck" value="">
								<label for="chk_op[INDEX]"><span></span>[INDEX]</label>
							</td>
							<td name="aTagTd01"><a
									href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]"
									class="tbl_link">[name]</a></td>
							<td name="aTagTd02"><a
									href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]"
									class="tbl_link">[발전소_명]</a></td>
							<td>[연차] 년차</td>
							<td>[관리_운영_기간]</td>
							<td>[보증_방식]</td>
							<td class="right">[PR_보증치] %</td>
							<td class="right">[보증_감소율] %</td>
							<td>[추가_보수]</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_wrap_type02 mt30">
				<%--				<button type="button" class="btn_type03" onclick="setCheckedDataEdit();">선택 수정</button>--%>
				<button type="button" class="btn_type03" onclick="setCheckedDataRemove();">선택 삭제</button>
			</div>
			<div class="paging_wrap" id="paging"></div>
		</div>
	</div>
</div>