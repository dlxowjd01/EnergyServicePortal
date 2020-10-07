<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let today = new Date();
	const siteList = JSON.parse('${siteList}');

	$(function () {
		setInitList("listData"); //리스트초기화
		getDataList(page);
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

	function getCsvDown() {
		let excelName = 'spc_info_list';
		let $val = $('#excelList').find('tbody');
		let cnt = $val.length;

		if (cnt < 1) {
			alert('다운받을 데이터가 없습니다.');
		} else {
			if (confirm('엑셀로 저장하시겠습니까?')) {
				tableToExcel('excelList', excelName);
			}
		}
	}

	function getDataList(page ,n, sort) {
		if (page == undefined) {
			page = 1;
		}else{
			if(isEmpty(n) && isEmpty(sort)) {
				$('.sort-table > thead').find('button').each(function(){
					if($(this).attr('class') != 'btn-align'){
						n = $(this).data('colname');
						sort = $(this).data('classname');
					}
				});
				
			}
		}
		$.ajax({
			url: apiHost + '/spcs/balance/month',
			type: "get",
			async: false,
			data: {
				oid: oid,
				yyyymm: $('#year button').data('value') + '__'
			},
			success: function (result) {
				var jsonList = [],
					keyWord = $("#key_word").val().trim().toLowerCase();

				for (var i in result.data) {
					var temp = result.data[i],
						balance_info = JSON.parse(temp.balance_info);

					result.data[i].balance_yyyymm = temp.balance_yyyymm.replace(/(\d{4})(\d{2})/, '$1-$2')
					result.data[i].inflowOfCash = numberComma(Math.round(balance_info.inflowOfCash.replace(/[^0-9.]/g, '')));
					result.data[i].outflowOfCash = numberComma(Math.round(balance_info.outflowOfCash.replace(/[^0-9.]/g, '')));
					result.data[i].endOfTermFlow = numberComma(Math.round(balance_info.endOfTermFlow.replace(/[^0-9.]/g, '')));

					for (var j in siteList) {
						if (siteList[j].sid == temp.site_id) {
							result.data[i].name = siteList[j].name;
						}
					}
					if (result.data[i].name.indexOf(keyWord) > -1 || result.data[i].spc_name.indexOf(keyWord) > -1) {
						jsonList.push(result.data[i]);
					}
				}
				$(".sort-table").data("nowjsp", "balance");
				jsonListSort(n, sort, jsonList)
				jsonList = paging(page, jsonList);
				setMakeList(jsonList, "listData", { "dataFunction": { "INDEX": getNumberIndex } }); //list생성

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
		var checkDataList = getCheckList("rowCheck");
		count = checkDataList.length,
			sucessCnt = 0;

		if (count == 0) {
			alert("삭제 할 목록을 선택하세요.");
			return;
		}

		for (var i = 0; i < count; i++) {
			var rowData = checkDataList[i];
			$.ajax({
				url: apiHost + '/spcs/' + rowData.spc_id + "/gens/" + rowData.gen_id,
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
		getDataList(page);
	}

	//     function setCheckedDataModify() {
	//         var checkDataList = getCheckList("rowCheck");
	//         count = checkDataList.length,
	//             sucessCnt = 0;

	//         if (count == 0) {
	//             alert("수정 할 목록을 선택하세요.");
	//             return;
	//         } else if (count > 1) {
	//             alert("1개의 사업소에 대해서만 수정 가능합니다.");
	//             return;
	//         }

	//         var rowData = checkDataList[0];
	//         var locationUrl = '/spc/balanceSheetEdit.do?spc_id=' + rowData.spc_id + '&site_id=' + rowData.site_id + '&yyyymm=' + rowData.balance_yyyymm;

	//         location.href = locationUrl;
	//     }

	function deleteRow() {
		var checkDataList = getCheckList("rowCheck");
		count = checkDataList.length,
			sucessCnt = 0;

		if (count == 0) {
			alert("삭제 할 목록을 선택하세요.");
			return;
		}

		var inputString = prompt(count + '건을 삭제하시겠습니까? \n삭제를 원하시면 아래 "삭제"라고 입력하고 확인을 눌러 주세요.', '');

		if (inputString == '삭제') {
			for (var i = 0; i < count; i++) {
				var rowData = checkDataList[i];
				var locationUrl = '/spcs/' + rowData.spc_id + '/balance/month?oid=' + oid + '&site_id=' + rowData.site_id + '&yyyymm=' + rowData.balance_yyyymm.replace('-', '');
				$.ajax({
					url: apiHost + locationUrl,
					type: 'delete',
					async: false,
					data: {},
					success: function (json) {
						sucessCnt++;
					},
					error: function (request, status, error) {
						alert('처리 중 오류가 발생했습니다.');
						return false;
					}
				});
			}
		}

		if (sucessCnt > 0) {
			alert('삭제 되었습니다.');
			location.reload();
			return false;
		}
	}
</script>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">SPC 금융관리</h1>
	</div>
</div>
<div class="row">
	<div class="col-12 clear input-align">
		<div class="fl">
			<span class="tx-tit">기준</span>
			<div class="sa-select">
				<div class="dropdown" id="year">
					<button type="button" class="dropdown-toggle w8" data-toggle="dropdown"
						data-value="2020">
						2020년<span class="caret"></span>
					</button>
					<ul class="dropdown-menu chk-type" role="menu">
						<li data-value="2020"><a href="#">2020년</a></li>
						<li data-value="2019"><a href="#">2019년</a></li>
						<li data-value="2018"><a href="#">2018년</a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<div class="text-input-type">
				<input type="text" id="key_word" name="searchName" placeholder="입력">
			</div>
		</div>
		<div class="fl">
			<button type="button" class="btn-type" onclick="getDataList();">검색</button>
		</div>
		<div class="fr">
			<a href="javascript:getCsvDown();" class="btn-save">엑셀 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-12">
		<div class="indiv">
			<div class="btn-wrap-type01">
				<button type="button" class="btn-type" onclick="location.href='/spc/balanceSheetPost.do'">신규 등록</button>
			</div>
			<div class="spc-tbl align-type" id="excelList">
				<table class="sort-table chk-type">
					<colgroup>
						<col width="6%">
						<col width="15%">
						<col width="17%">
						<col width="17%">
<%--						<col width="15%">--%>
						<col width="15%">
						<col width="15%">
						<col width="15%">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="chk_op01" value="순번">
								<label for="chk_op01">순번</label>
							</th>
							<th><button type="button" class="btn-align down">SPC명</button></th>
							<th><button type="button" class="btn-align down">발전소 명</button></th>
							<th><button type="button" class="btn-align down">기준년월</button></th>
<%--							<th class="right"><button type="button" class="btn-align down">용량(kW)</button></th>--%>
							<th class="right"><button type="button" class="btn-align down">현금유입(원)</button></th>
							<th class="right"><button type="button" class="btn-align down">현금유출(원)</button></th>
							<th class="right"><button type="button" class="btn-align down">기말 현금흐름(원)</button></th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>
								<input type="checkbox" id="chk_op[INDEX]" name="rowCheck" value="">
								<label for="chk_op[INDEX]">[INDEX]</label>
							</td>
							<td>
								<a href="/spc/entityDetailsBySite.do?spc_id=[spc_id]&site_id=&balance_yyyy=[balance_yyyymm]" class="table-link">[spc_name]</a>
							</td>
							<td>
								<a href="/spc/entityDetailsBySite.do?spc_id=[spc_id]&site_id=[site_id]&balance_yyyy=[balance_yyyymm]" class="table-link">[name]</a>
							</td>
							<td>[balance_yyyymm]</td>
<%--							<td class="right">-</td>--%>
							<td class="right">[inflowOfCash]</td>
							<td class="right">[outflowOfCash]</td>
							<td class="right">[endOfTermFlow]</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-wrap-type02 mt30">
				<!--                 <button type="button" class="btn-type03" onclick="setCheckedDataModify();">선택 수정</button> -->
				<button type="button" class="btn-type03" onclick="deleteRow();">선택 삭제</button>
			</div>
			<div class="pagination-wrapper" id="paging">
			</div>
		</div>
	</div>
</div>