<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const spc_id = '<c:out value="${param.spc_id}" escapeXml="false" />';
	const gen_id = '<c:out value="${param.gen_id}" escapeXml="false" />';
	const currentTime = '<c:out value="${nowTime}" escapeXml="false" />';
	let supInfoLength = '';

	$(function () {
		initRow('addList');
		addRow('addList');

		//SPC명 가져오기
		$.ajax({
			url: apiHost + '/spcs/' + spc_id,
			type: 'get',
			async: false,
			data: { oid: oid },
			success: function (json) {
				if (json.data.length > 0) {
					$('#name').text(json.data[0].name)
				} else {
					alert('등록된 데이터가 없습니다.');
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});

		//발전소명 가져오기
		$.ajax({
			url: apiHost + '/spcs/' + spc_id + "/gens/" + gen_id,
			type: "get",
			async: false,
			data: { "oid": oid },
			success: function (json) {
				if (json.data.length > 0) {
					$("#발전소명").text(json.data[0].name);
				} else {
					alert("등록된 데이터가 없습니다.");
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});

		// 이관자료 가져오기
		supInfoLength = getGridList(supInfoLength);
	});

	// 파일 추가
	$(document).on('change', 'input[type="file"]', function(e) {
		e.preventDefault();
		if(($(this).attr('id')).match('사용자정의')){
			if(isEmpty($(this).next().val())){
				alert('추가 항목명을 입력하고 파일을 추가해야 합니다.');
				supInfoLength = getGridList(supInfoLength);
				return false;
			}
		}
		let uuid = genUuid();
		let thisId = $(this).prop('id');

		$(this).clone().appendTo('#upload');
		$('#upload').find('input').attr('name', uuid).attr('id', uuid);

		callAjax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: apiHost + '/files/upload?oid=' + oid,
			data: new FormData($('#upload')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000
		}, setUploadAfter, thisId);
	});


	$(document).on('click', 'button[name="rowDelete"]', function(){
		let result = confirm("삭제하시겠습니까?");
		$(this).parents('tr').remove();

		sendSupplementPatch();
	});

	// 삭제버튼 클릭
	$(document).on('click', 'button.btn_img', function(){
		var result = confirm("삭제하시겠습니까?");
		if (result) {
			let tr = $(this).parents('tr');
			tr.next().val('');
			tr.find('input[type="text"]').val('')
			tr.find('input[type="hidden"]').val('')
			tr.find('.down').removeAttr('onclick');
			tr.find('.down').addClass('hidden');
			$(this).hide();

			sendSupplementPatch();
		}
	});

	$(document).on('blur', '[id^=사용자정의]', function() {
		// 수정과 등록 분기
		if (supInfoLength > 0){
			sendSupplementPatch(); // 수정
		} else {
			sendSupplementPost(); // 등록
		}
	});

	const getGridList = function(supInfoLength){
		$.ajax({
			url: apiHost + '/spcs/' + spc_id + "/gens/" + gen_id + "/supplement?oid=" + oid,
			type: "get",
			dataType: 'json',
			async: false,
			contentType: "application/json",
			success: function (json) {
				$('button.btn_type07').addClass('hidden'); // 삭제버튼 비활성 초기화
				$('button.down').addClass('hidden'); // 다운로드 버튼 비활성 초기화
				supInfoLength = json.data.length;
				// 이관자료가 기존에 존재하면 테이블에 매칭
				if (supInfoLength > 0) {
					var linkDownUrl = apiHost + '/files/download/';
					var supplementList = json.data[0].supplement_info
					supplementInfo = JSON.parse(supplementList)

					delete supplementInfo[null];
					var keys = Object.keys(supplementInfo);

					var customArray = new Array();
					for(var i in keys) {
						var key = keys[i],
							val = supplementInfo[key];

						if (key.match('사용자정의')) {
							let customIndex = Number(key.replace(/[^0-9]/g, ''));
							if (customIndex != 0) {
								if ($.inArray(customIndex, customArray) === -1) customArray.push(customIndex);
							}
						} else if (key.match('_fieldName')) {
							let keyName = key.replace('_fieldName', '');
							supplementInfo[keyName + '_filedName'] = val;
						}
					}

					customArray.sort();
					customArray.forEach(function(el) {
						addRow('addList', 'escalation', el);
					});

					setJsonAutoMapping(supplementInfo, 'supplement_info');

					$('#supplement_info input[id$="_originalName"]').each(function() {
						var thisVal = $(this).val(),
							thisId = $(this).attr('id');

						if (!isEmpty(thisVal)) {
							var downCount = $(this).parents('tr').find('input[id$="_다운로드"]').val();
							if (isEmpty(downCount)) {
								$(this).parents('tr').find('input[id$="_다운로드"]').val(0);
							}

							$(this).parents('tr').find('.down').removeClass('hidden');
							$(this).parents('tr').find('.btn_type07').removeClass('hidden');

							if (thisId.match('사용자정의')) {
								$(this).parents('td').next().find('input').val(thisVal);

								let customIndex = Number(key.replace(/[^0-9]/g, ''));
								if (customIndex != 0) {
									$(this).parents('tr').find('.btn_type07').eq(0).addClass('hidden');
								}
							}
						}
					});
				}
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
		return supInfoLength;
	}

	const callAjax = function (option, callBack, param) {
		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if (typeof callBack == 'function') {
				callBack.call(this, data, param);
			} else if (typeof callBack == 'string') {
				eval(callBack + '("' + param + '")');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	// 파일 업로드 후 처리
	const setUploadAfter = function (data, propName, param) {
		if (data.files.length > 0) {
			let prop = $('#' + propName);

			$('#' + propName + '_originalName').val(data.files[0].originalname);
			$('#' + propName + '_filedName').val(data.files[0].fieldname);
			$('#' + propName + '_다운로드').val(0);
			$('#' + propName + '_regDt').val((new Date()).format('yyyy-MM-dd')); // 발급일자 추가

			if (propName.match('사용자정의')) {
				let custumIdx = Number(propName.replace(/[/^0-9]/, ''));
				$('#' + propName + '_filedName').parents('td').next().find('input').val(data.files[0].originalname);
				if (custumIdx == 0) {
					prop.parents('tr').find('.btn_type07').eq(1).removeClass('hidden'); //삭제버튼 활성화
				} else {
					prop.parents('tr').find('.btn_type07').removeClass('hidden'); //삭제버튼 활성화
				}
				prop.parents('tr').find('.down').removeClass('hidden'); //다운로드 버튼 활성화
			} else {
				prop.parents('tr').find('.btn_type07').removeClass('hidden'); //삭제버튼 활성화
				prop.parents('tr').find('.down').removeClass('hidden'); //다운로드 버튼 활성화

				if (prop.parents('tr').find('.btn_type07').css('display') != '') {
					prop.parents('tr').find('.btn_type07').removeAttr('style');
				}
			}

			// 수정과 등록 분기
			if (supInfoLength > 0){
				sendSupplementPatch(); // 수정
			} else {
				sendSupplementPost(); // 등록
			}
		}
	}

	// 이관자료 전체 등록
	function sendSupplementPost() {
		var supplement_info = setAreaParamData("supplement_info");
		$.ajax({
			url: apiHost + '/spcs/' + spc_id + "/gens/" + gen_id + "/supplement?oid=" + oid,
			type: "post",
			dataType: 'json',
			async: false,
			contentType: "application/json",
			data: JSON.stringify({
				"supplement_info": JSON.stringify(supplement_info),
				"updated_by": loginId
			}),
			success: function (json) {
				$(document).find('input[type="file"]').val('');
				//location.reload();
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	// 이관자료 전체 수정
	function sendSupplementPatch() {
		var supplement_info = setAreaParamData("supplement_info");
		$.ajax({
			url: apiHost + '/spcs/' + spc_id + "/gens/" + gen_id + "/supplement?oid=" + oid,
			type: "patch",
			dataType: 'json',
			async: false,
			contentType: "application/json",
			data: JSON.stringify({
				"supplement_info": JSON.stringify(supplement_info),
				"updated_by": loginId
			}),
			success: function (json) {
				$(document).find('input[type="file"]').val('');
				//location.reload();
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	function goMoveList() {
		location.href = "/spc/supplementaryDocuments.do";
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

	function addListPost(addId){
		let trLength = $("#supplement_info table").find("tr").length;
		let $selecter = $("#supplement_info table").find("tr").eq(trLength-1);

		let tdStr = "";
		    tdStr += "<tr>";
		    tdStr += "<th></th>";
		for(let i = 0; i < $("#" + addId).find("td").length; i++){
			if(i==0){
				tdStr += "<td id='td'" +addId+ "'_'"+i+" class='group_type flex_start'>" + $("#" + addId).find("td").eq(i).html() +"</td>";
			}else{
				tdStr += "<td>" + $("#" + addId).find("td").eq(i).html() +"</td>";
			}
		}
			tdStr += "</tr>";
		$selecter.parent().append(tdStr);
		$("#supplement_info table").find("tr").eq(trLength).find("input").attr("placeholder", "직접 입력");
	}

	function downloadFile($selector) {
		var $selectorTr = $selector.parents('tr'),
			filedName = $selectorTr.find('[id$="_filedName"]').val(),
			originalName = $selectorTr.find('[id$="_originalName"]').val(),
			downCount = $selectorTr.find('[id$="_다운로드"]').val();
		location.href = apiHost + '/files/download/' + filedName + '?oid=' + oid + '&orgFilename=' + originalName;

		$selectorTr.find('[id$="_다운로드"]').val(Number(downCount) + 1);

		// 수정과 등록 분기
		if (supInfoLength > 0) {
			sendSupplementPatch(); // 수정
		} else {
			sendSupplementPost(); // 등록
		}
	}
</script>

<form id="upload" name="upload" method="multipart/form-data" style="display:none;">
</form>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">SPC 이관자료</h1>
	</div>
</div>
<div class="row" id="supplement_info">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width: 15%">
						<col style="width: 35%">
						<col style="width: 15%">
						<col style="width: 35%">
					</colgroup>
					<tr>
						<th>SPC명</th>
						<td id="name"></td>
						<th>발전소명</th>
						<td id="발전소명"></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25">
			<div class="spc_tbl_row pb20 fileBox">
				<table class="mt30">
					<colgroup>
						<col style="width: 15%">
						<col style="width: 15%">
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<tr>
						<th>구분</th>
						<th></th>
						<th>파일이름</th>
						<th></th>
						<th>다운로드</th>
						<th>발급일자</th>
						<th>파일첨부</th>
					</tr>
					<tr>
						<th>사업조직도</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="사업조직도" class="uploadBtn">
							<input type="text" id="사업조직도_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="사업조직도_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="사업조직도_다운로드" name="사업조직도_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="사업조직도_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="사업조직도" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>설치 업체 담당자 연락처</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="설치_업체_담당자_연락처" class="uploadBtn">
							<input type="text" id="설치_업체_담당자_연락처_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="설치_업체_담당자_연락처_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="설치_업체_담당자_연락처_다운로드" name="설치_업체_담당자_연락처_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="설치_업체_담당자_연락처_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="설치_업체_담당자_연락처" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>투자/계약 심의</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="투자_계약_심의" class="uploadBtn">
							<input type="text" id="투자_계약_심의_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="투자_계약_심의_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="투자_계약_심의_다운로드" name="투자_계약_심의_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="투자_계약_심의_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="투자_계약_심의" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>사업자 등록증</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="사업자_등록증" class="uploadBtn">
							<input type="text" id="사업자_등록증_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="사업자_등록증_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="사업자_등록증_다운로드" name="사업자_등록증_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="사업자_등록증_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="사업자_등록증" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>발전사업 허가증</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="발전사업_허가증" class="uploadBtn">
							<input type="text" id="발전사업_허가증_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="발전사업_허가증_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="발전사업_허가증_다운로드" name="발전사업_허가증_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="발전사업_허가증_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="발전사업_허가증" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>토지 및 건물 등기부등록</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="토지_및_건물_등기부등록" class="uploadBtn">
							<input type="text" id="토지_및_건물_등기부등록_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="토지_및_건물_등기부등록_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="토지_및_건물_등기부등록_다운로드" name="토지_및_건물_등기부등록_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="토지_및_건물_등기부등록_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="토지_및_건물_등기부등록" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>토지대장 및 건물도면</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="토지대장_및_건물도면" class="uploadBtn">
							<input type="text" id="토지대장_및_건물도면_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="토지대장_및_건물도면_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="토지대장_및_건물도면_다운로드" name="토지대장_및_건물도면_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="토지대장_및_건물도면_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="토지대장_및_건물도면" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>원도급 계약서</th>
						<td>실사 협약서</td>
						<td class="px-0">
							<input type="file" id="원도급_계약서_실사_협약서" class="uploadBtn">
							<input type="text" id="원도급_계약서_실사_협약서_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="원도급_계약서_실사_협약서_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="원도급_계약서_실사_협약서_다운로드" name="원도급_계약서_실사_협약서_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="원도급_계약서_실사_협약서_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="원도급_계약서_실사_협약서" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>토지이용 허가서</td>
						<td class="px-0">
							<input type="file" id="원도급_계약서_토지이용_허가서" class="uploadBtn">
							<input type="text" id="원도급_계약서_토지이용_허가서_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="원도급_계약서_토지이용_허가서_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="원도급_계약서_토지이용_허가서_다운로드" name="원도급_계약서_토지이용_허가서_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="원도급_계약서_토지이용_허가서_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="원도급_계약서_토지이용_허가서" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>하도급 계약서</th>
						<td>공사도급 계약서</td>
						<td class="px-0">
							<input type="file" id="하도급_계약서_공사도급_계약서" class="uploadBtn">
							<input type="text" id="하도급_계약서_공사도급_계약서_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="하도급_계약서_공사도급_계약서_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="하도급_계약서_공사도급_계약서_다운로드" name="하도급_계약서_공사도급_계약서_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="하도급_계약서_공사도급_계약서_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="하도급_계약서_공사도급_계약서" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>설계용역 계약서</td>
						<td class="px-0">
							<input type="file" id="하도급_계약서_설계용역_계약서" class="uploadBtn">
							<input type="text" id="하도급_계약서_설계용역_계약서_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="하도급_계약서_설계용역_계약서_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="하도급_계약서_설계용역_계약서_다운로드" name="하도급_계약서_설계용역_계약서_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="하도급_계약서_설계용역_계약서_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="하도급_계약서_설계용역_계약서" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>감리용역 계약서</td>
						<td class="px-0">
							<input type="file" id="하도급_계약서_감리용역_계약서" class="uploadBtn">
							<input type="text" id="하도급_계약서_감리용역_계약서_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="하도급_계약서_감리용역_계약서_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="하도급_계약서_감리용역_계약서_다운로드" name="하도급_계약서_감리용역_계약서_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="하도급_계약서_감리용역_계약서_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="하도급_계약서_감리용역_계약서" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>기자재 시험 성적서</th>
						<td>인버터</td>
						<td class="px-0">
							<input type="file" id="기자재_시험_성적서_인버터" class="uploadBtn">
							<input type="text" id="기자재_시험_성적서_인버터_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="기자재_시험_성적서_인버터_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="기자재_시험_성적서_인버터_다운로드" name="기자재_시험_성적서_인버터_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="기자재_시험_성적서_인버터_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="기자재_시험_성적서_인버터" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>모듈</td>
						<td class="px-0">
							<input type="file" id="기자재_시험_성적서_모듈" class="uploadBtn">
							<input type="text" id="기자재_시험_성적서_모듈_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="기자재_시험_성적서_모듈_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="기자재_시험_성적서_모듈_다운로드" name="기자재_시험_성적서_모듈_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="기자재_시험_성적서_모듈_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="기자재_시험_성적서_모듈" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>변압기</td>
						<td class="px-0">
							<input type="file" id="기자재_시험_성적서_변압기" class="uploadBtn">
							<input type="text" id="기자재_시험_성적서_변압기_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="기자재_시험_성적서_변압기_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="기자재_시험_성적서_변압기_다운로드" name="기자재_시험_성적서_변압기_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="기자재_시험_성적서_변압기_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="기자재_시험_성적서_변압기" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>수배전반</td>
						<td class="px-0">
							<input type="file" id="기자재_시험_성적서_수배전반" class="uploadBtn">
							<input type="text" id="기자재_시험_성적서_수배전반_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="기자재_시험_성적서_수배전반_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="기자재_시험_성적서_수배전반_다운로드" name="기자재_시험_성적서_수배전반_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="hidden" id="기자재_시험_성적서_수배전반_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="기자재_시험_성적서_수배전반" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr>
						<th>모듈 Inspection Sheet</th>
						<td></td>
						<td class="px-0">
							<input type="file" id="모듈_Inspection_Sheet" class="uploadBtn">
							<input type="text" id="모듈_Inspection_Sheet_originalName" value="" class="fileName tx_file" readonly>
							<input type="hidden" id="모듈_Inspection_Sheet_filedName" value="">
						</td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="모듈_Inspection_Sheet_다운로드" name="모듈_Inspection_Sheet_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="모듈_Inspection_Sheet_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="모듈_Inspection_Sheet" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
					<tr id="addList">
						<th>추가항목<a href="javascript:addRow('addList', 'escalation');" class="btn_add fr">추가</a></th>
						<td class="group_type flex_start">
							<div class="tx_inp_type edit">
								<input type="file" id="사용자정의[index]" name="사용자정의[index]" class="uploadBtn">
								<input type="text" id="사용자정의명[index]" name="사용자정의명[index]" placeholder="직접 입력">
								<input type="hidden" id="사용자정의[index]_originalName" name="사용자정의[index]_originalName" value="" class="fileName tx_file" readonly>
								<input type="hidden" id="사용자정의[index]_filedName" name="사용자정의[index]_filedName" value="">

							</div>
							<button class="btn_type07 hidden" name="rowDelete">삭제</button>
						</td>
						<td><input type="text" class="fileName tx_file" readonly="readonly"></td>
						<td>
							<button class="btn_file down" onclick="downloadFile($(this));">다운로드</button>
						</td>
						<td class="px-0">
							<input type="text" id="사용자정의[index]_다운로드" name="사용자정의[index]_다운로드" class="fileName tx_file w50" readonly>
						</td>
						<td class="px-0">
							<input type="text" id="사용자정의[index]_regDt" name="사용자정의[index]_regDt" value="" class="fileName tx_file w80" readonly>
						</td>
						<td class="px-0">
							<label for="사용자정의[index]" class="btn_type_attachment">추가</label>
							<button class="btn_type07 btn_img">삭제</button>
						</td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02 mt30"><button type="button" class="btn_type03" onclick="goMoveList();">목록</button></div>
		</div>
	</div>
</div>
