<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script src="/js/commonDropdown.js"></script>
<script>
	const searchCnt = 0;

	$(function () {
		var spcFrom = document.querySelector('#spc_form button.btn_type');
		var keyWord = document.getElementById("key_word");

		keyWord.addEventListener("focus", function (e) {
			if (!keyWord.value.replace(/\s/g, '').length) {
				keyWord.value = '';
			} else {
				keyWord.value === keyWord.value;
			}
		});

		spcFrom.addEventListener('click', function (e) {
			getDataList(1, '', '', searchCnt);
		});

		setInitList("listData"); //리스트초기화
		getDataList(page);

		$('.save_btn').on('click', function (e) {
			let excelName = 'SPC기본정보';
			let $val = $('#excelList').find('tbody');
			let cnt = $val.length;

			if (cnt < 1) {
				alert('다운받을 데이터가 없습니다.');
			} else {
				if (confirm('엑셀로 저장하시겠습니까?')) {
					tableToExcel('excelList', excelName, e);
				}
			}
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

	function jsonDataFilter(jsonData, searchCnt) {
		let keyWord = $("#key_word").val().trim().toLowerCase(),
			kResult = false, bResult = false , wResult = false, oResult = false, cResult = false;

		wResult = warrantyFilter(jsonData, wResult);
		oResult = operationFilter(jsonData, oResult);
		cResult = contractFilter(jsonData, cResult);

		if (isEmpty(keyWord)) {
			kResult = true;
		} else {
			if (jsonData["name"].toLowerCase().indexOf(keyWord) > -1 || jsonData["발전소_명"].toLowerCase().indexOf(keyWord) > -1) {
				kResult = true;
			}
		}

		if (wResult && oResult && cResult && kResult) {
			kResult = true;
		} else {
			kResult = false;
		}

		return kResult;
	}

	function operationFilter(jsonData, oResult) {
		let operArray = [];
		$(":checkbox[name='operation_opt']:checked").each(function () {
			operArray.push($(this).val());
		});

		if(operArray.length > 0) {
			if(jsonData['spcGens'].length > 0) {
				const maintenanceInfo = JSON.parse(jsonData['spcGens'][0].maintenance_info);
				if (maintenanceInfo == null || maintenanceInfo['운영_여부'] === undefined) {
					oResult = false;
				} else {
					$.each(operArray, function (i, operation) {
						if (maintenanceInfo['운영_여부'].match(operation)) {
							oResult = true;
						}
					});
				}
			} else {
				oResult = false;
			}
		} else {
			oResult = true;
		}

		return oResult;
	}

	function warrantyFilter(jsonData, wResult) {
		let warrantyArray = [];

		$(":checkbox[name='warranty_opt']:checked").each(function () {
			warrantyArray.push($(this).val());
		});

		if(warrantyArray.length > 0) {
			$.each(warrantyArray, function (i, warranty) {
				if (jsonData['보증_방식'] == warranty) {
					wResult = true;
				}
			});
		} else {
			wResult = true;
		}

		return wResult;
	}

	function contractFilter(jsonData, cResult) {
		let contractArray = [];

		$(":checkbox[name='contract_opt']:checked").each(function () {
			contractArray.push($(this).val());
		});

		if(contractArray.length > 0) {
			if(jsonData['spcGens'].length > 0) {
				const maintenanceInfo = JSON.parse(jsonData['spcGens'][0].maintenance_info);
				if (maintenanceInfo['관리_계약_구분'] === undefined) {
					cResult = false;
				} else {
					let contractList = maintenanceInfo['관리_계약_구분'];
					$.each(contractArray, function (i, contract) {
						contractList.forEach(function(el) {
							if (el.match(contract)) {
								cResult = true;
							}
						});
					});
				}
			} else {
				cResult = false;
			}
		} else {
			cResult = true;
		}

		return cResult;
	}

	function setJsonDataFormat(result, page, n, sort, searchCnt) {
		var jsonList = [];

		for (var i = 0, count = result.data.length; i < count; i++) {

			var spcGensList = result.data[i].spcGens;
			if (spcGensList !== undefined && spcGensList.length > 0) {
				for (var j = 0, jcount = spcGensList.length; j < jcount; j++) {

					var spcGensRow = spcGensList[j],
						rowData = result.data[i],
						newData = Object.assign({}, rowData),
						warrantyInfo = JSON.parse(spcGensRow.warranty_info),
						maintenanceInfo = JSON.parse(spcGensRow.maintenance_info);

					let termDate = '';
					if (!isEmpty(maintenanceInfo)) {
						let mainFrom = maintenanceInfo['관리_운영_기간_from'];
						let mainTo = maintenanceInfo['관리_운영_기간_to'];
						if (!isEmpty(mainFrom) && !isEmpty(mainTo)) {
							termDate = new Date(mainFrom).format('yyyy-MM-dd') + ' ~ ' + new Date(mainTo).format('yyyy-MM-dd')
						}
					}

					newData["gen_id"] = spcGensRow.gen_id;
					newData["발전소_명"] = spcGensRow.name;
					newData["관리_운영_기간"] = nvl(termDate, "-");
					newData["연차"] = nvl(warrantyInfo["현재_적용_연차"], "-");
					newData["보증_방식"] = nvl(warrantyInfo["보증_방식"], "-");
					newData["PR_보증치"] = nvl(warrantyInfo["PR_보증치"], "-");
					newData["보증_감소율"] = nvl(warrantyInfo["보증_감소율"], "-");
					newData["추가_보수"] = nvl(warrantyInfo["추가_보수"], "-");

					//키워드 검색 조건 필터 처리
					if (jsonDataFilter(newData, searchCnt)) {
						jsonList.push(newData)
					}
				}
			}
		}
		$(".sort_table").data("nowjsp", "entityinformation");
		jsonListSort(n, sort, jsonList);
		jsonList = paging(page, jsonList);
		return jsonList;
	}

	function getDataList(page, n, sort, searchCnt) {

		if (page == undefined) {
			page = 1;
		} else {
			if (isEmpty(n) && isEmpty(sort)) {
				$('.sort_table > thead').find('button').each(function () {
					if ($(this).attr('class') != 'btn_align') {
						n = $(this).data('colname');
						sort = $(this).data('classname');
					}
				});

			}
		}

		$.ajax({
			url: apiHost + '/spcs',
			type: "get",
			async: true,
			data: {
				"oid": oid,
				includeGens: true
			},
			success: function (result) {
				setMakeList(setJsonDataFormat(result, page, n, sort, searchCnt), "listData", {
					"dataFunction": {
						"INDEX": getNumberIndex
					}
				}); //list생성

				const now = new Date();
				$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
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
				url: apiHost + '/spcs/' + rowData.spc_id + "/gens/" + rowData.gen_id + "?oid=" + oid,
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
		<form id="spc_form" onsubmit="return false;">
			<div class="flex_start">
				<label for="operation_select" class="tx_tit">운영 여부</label>
				<div class="dropdown sa_select mr-16" id="operation_select">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown" data-name="운영 여부 선택">
						운영 여부 선택<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk_type" role="menu" id="operationList">
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="operation_1" value="운영중" name="operation_opt">
								<label for="operation_1">운영중</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="operation_2" value="운영예정" name="operation_opt">
								<label for="operation_2">운영 예정</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="operation_3" value="해지" name="operation_opt">
								<label for="operation_3">해지</label>
							</a>
						</li>
					</ul>
				</div>

				<label for="warranty_select" class="tx_tit">보증 방식</label>
				<div class="dropdown sa_select mr-16" id="warranty_select">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown" data-name="보증 방식 선택">
						보증 방식 선택<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk_type" role="menu" id="warrantyList">
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="warranty_1" value="PR" name="warranty_opt">
								<label for="warranty_1">PR</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="warranty_2" value="발전 시간" name="warranty_opt">
								<label for="warranty_2">발전 시간</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="warranty_3" value="PR + 발전시간" name="warranty_opt">
								<label for="warranty_3">PR + 발전시간</label>
							</a>
						</li>
					</ul>
				</div>

				<label for="contract_select" class="tx_tit">계약 구분</label>
				<div class="dropdown sa_select mr-24" id="contract_select">
					<button class="btn btn-primary dropdown-toggle w8" type="button" data-toggle="dropdown" data-name="계약 구분 선택">
						계약 구분 선택<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk_type" role="menu" id="contractList">
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_1" value="종합" name="contract_opt">
								<label for="contract_1">종합</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_2" value="일반관리" name="contract_opt">
								<label for="contract_2">일반관리</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_3" value="사무수탁" name="contract_opt">
								<label for="contract_3">사무수탁</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_4" value="보험" name="contract_opt">
								<label for="contract_4">보험</label>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" tabindex="-1">
								<input type="checkbox" id="contract_5" value="안전관리자" name="contract_opt">
								<label for="contract_5">안전관리자</label>
							</a>
						</li>
					</ul>
				</div>

				<div class="tx_inp_type mr-12">
					<input type="text" id="key_word" placeholder="입력">
				</div>
				<button type="button" class="btn_type">검색</button>
			</div>
		</form>
	</div>
	<div class="col-2">
		<div class="right">
			<a href="javascript:void(0);" class="save_btn">엑셀 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn_wrap_type01">
				<button type="button" class="btn_type big" onclick="location.href='/spc/entityInformationPost.do'">신규 등록</button>
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
						<th>
							<button class="btn_align down">SPC명</button>
						</th>
						<th>
							<button class="btn_align down">발전소 명</button>
						</th>
						<th>
							<button class="btn_align down">연차</button>
						</th>
						<th>
							<button class="btn_align down">관리 운영기간</button>
						</th>
						<th>
							<button class="btn_align down">보증</button>
						</th>
						<th class="right">
							<button class="btn_align down">보증 값</button>
						</th>
						<th class="right">
							<button class="btn_align down">감소율</button>
						</th>
						<th>
							<button class="btn_align down">- 추가보수</button>
						</th>
					</tr>
					</thead>
					<tbody id="listData">
					<tr>
						<td>
							<input type="checkbox" id="chk_op[INDEX]" name="rowCheck" value="">
							<label for="chk_op[INDEX]">[INDEX]</label>
						</td>
						<td name="aTagTd01">
							<a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">
								[name]
							</a>
						</td>
						<td name="aTagTd02">
							<a href="/spc/entityDetails.do?spc_id=[spc_id]&gen_id=[gen_id]&oid=[oid]" class="tbl_link">
								[발전소_명]
							</a>
						</td>
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