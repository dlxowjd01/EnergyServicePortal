<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
	const oid = "${sessionScope.userInfo.oid}";
	const loginId = "${sessionScope.userInfo.login_id}";

	$(function () {
		setInitList("listData"); //리스트초기화
		getDataList(page);
	});

	$(document).on("click", ".dropdown li", function () {
		var dataValue = $(this).data("value");
		$(this).parents(".dropdown").find("button").data("value", dataValue);
	});

	$(document).on("keyup", "#key_word", function (e) {
		if (e.keyCode == 13) {
			getDataList();
		}
	});

	function nvl(value, str) {
		if (isEmpty(value)) {
			return str;
		} else {
			return value;
		}
	}

	function getCsvDown() {
		var column = [
			"report_type_name",
			"report_id",
			"report_name",
			"updated_by",
			"write_date",
		], //json Key
			header = [
				"보고서구분",
				"문서번호",
				"보고서명",
				"작성자",
				"작성일자",
			]; //csv 파일 헤더

		getJsonCsvDownload(
			$("#listData").data("gridJsonData"),
			column,
			header,
			"work_report.csv"
		); // json list, 컬럼, 헤더명, 파일명
	}

	function jsonDataFilter(jsonData) {
		var keyWord = $("#key_word").val().trim().toLowerCase(),
			report_type = $("#report_type").data("value"),
			write_date_from = $("#write_date_from").val().split("-").join(""),
			write_date_to = $("#write_date_to").val().split("-").join(""),
			filterCheckCount = 0,
			workinfoObj = JSON.parse(jsonData.work_info),
			bReportType = false,
			bWriteDate = false,
			bKeyWord = false;
			bResult = false;
		//보고서 구분
		if ("" != report_type && report_type == jsonData.report_type) {
			bReportType = true;
		} else if ("" == report_type) {
			bReportType = true;
		}
		//작성일자
		if (write_date_from != "" && write_date_to != "") {
			var write_date = jsonData.write_date.split("-").join("");

			if (
				Number(write_date) >= Number(write_date_from) &&
				Number(write_date) <= Number(write_date_to)
			) {
				bWriteDate = true;
			} else {
				bWriteDate = false;
			}
		} else if (write_date_from == "" && write_date_to == "") {
			bWriteDate = true;
		}
		//키워드검색
		if (
			jsonData.report_name.toLowerCase().indexOf(keyWord) > -1 ||
			workinfoObj.출장_장소.toLowerCase().indexOf(keyWord) > -1 ||
			workinfoObj.출장_목적.toLowerCase().indexOf(keyWord) > -1 ||
			workinfoObj.출장자.toLowerCase().indexOf(keyWord) > -1 ||
			jsonData.site_name.toLowerCase().indexOf(keyWord) > -1 ||
			jsonData.updated_by.toLowerCase().indexOf(keyWord) > -1
		) {
			bKeyWord = true;
		}

		if (bReportType && bWriteDate && bKeyWord) {
			bResult = true;
		}

		return bResult;
	}

	function setJsonDataFormat(result, page , n, sort) {
		var jsonList = [];

		for (var i = 0, count = result.data.length; i < count; i++) {
			var rowData = result.data[i],
				work_info = JSON.parse(rowData.work_info);
			rowData["report_type_name"] = getReportTypeName(
				rowData.report_type
			);

			var workInfo = new Date(work_info["작성_일자"]);

			var year = workInfo.getFullYear();
			var month = workInfo.getMonth() + 1;
			var date = workInfo.getDate();

			if (("" + month).length == 1) {
				month = "0" + month;
			}
			if (("" + date).length == 1) {
				date = "0" + date;
			}

			rowData["write_date"] = year + "-" + month + "-" + date;

			if (jsonDataFilter(rowData)) {
				jsonList.push(rowData);
			}
		}
		$(".sort_table").data("nowjsp", "maintenance");
		jsonListSort(n, sort, jsonList);
		jsonList = paging(page, jsonList);
		return jsonList;
	}

	function getDataList(page, n, sort) {
		if (page == undefined) {
			page = 1;
		}else{
			if(isEmpty(n) && isEmpty(sort)) {
				$('.sort_table > thead').find('button').each(function(){
					if($(this).attr('class') != 'btn_align'){
						n = $(this).data('colname');
						sort = $(this).data('classname');
					}
				});
				
			}
		}
		$.ajax({
			url: apiHost + "/reports/remote_work",
			type: "get",
			async: false,
			data: { oid: oid },
			success: function (result) {
				
				setMakeList(setJsonDataFormat(result, page, n, sort), "listData", {
					dataFunction: {
						INDEX: getNumberIndex,
						report_type: getReportTypeName,
					},
				}); //list생성
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			},
		});
	}

	function getReportTypeName(data) {
		var result = "";

		if ("1" == data) {
			result = "출장/조치 보고서";
		} else if ("2" == data) {
			result = "QC 보고서";
		}

		return result;
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
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">작업 보고서</h1>
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
			<span class="tx_tit">보고서 구분</span>
			<div class="sa_select">
				<div class="dropdown">
					<button id="report_type" class="btn btn-primary dropdown-toggle w5" type="button"
						data-toggle="dropdown" data-value="">
						전체
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li data-value="">
							<a href="javascript:void(0);">전체</a>
						</li>
						<li data-value="1">
							<a href="javascript:void(0);">출장/조치 보고서</a>
						</li>
						<li data-value="2">
							<a href="javascript:void(0);">QC 보고서</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<span class="tx_tit">작성 일자</span>
			<div class="sel_calendar">
				<input type="text" id="write_date_from" class="sel datepicker fromDate" value="" autocomplete="off" />
				<em></em>
				<input type="text" id="write_date_to" class="sel datepicker toDate" value="" autocomplete="off" />
			</div>
		</div>
		<div class="fl">
			<div class="tx_inp_type">
				<input type="text" id="key_word" placeholder="입력" />
			</div>
		</div>
		<div class="fl">
			<button type="submit" class="btn_type" onclick="getDataList();">
				검색
			</button>
		</div>
		<div class="fr">
			<a href="javascript:void(0);" class="save_btn" onclick="getCsvDown();">CVS 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv report maintenance_report">
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type" onclick="location.href='/report/maintenanceReportPost.do'">
					등록
				</button>
			</div>
			<div class="spc_tbl align_type">
				<table class="sort_table chk_type">
					<thead>
						<tr>
							<th>순번</th>
							<th>
								<button class="btn_align down">보고서 구분</button>
							</th>
							<th>
								<button class="btn_align down">문서번호</button>
							</th>
							<th>
								<button class="btn_align down">보고서명</button>
							</th>
							<th>
								<button class="btn_align down">작성자</button>
							</th>
							<th>
								<button class="btn_align down">작성일자</button>
							</th>
							<th>
								<button class="btn_align down">등록상태</button>
							</th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>[INDEX]</td>
							<td>[report_type]</td>
							<td>[report_id]</td>
							<td>
								<a href="/report/maintenanceReportDetails.do?report_id=[report_id]"
									class="tbl_link">[report_name]</a>
							</td>
							<td>[updated_by]</td>
							<td>[write_date]</td>
							<td>저장완료</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="paging_wrap" id="paging"></div>
		</div>
	</div>
</div>