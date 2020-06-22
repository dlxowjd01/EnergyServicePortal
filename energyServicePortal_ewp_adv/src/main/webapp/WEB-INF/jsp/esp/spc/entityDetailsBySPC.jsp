<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<html>

<head>
	<title>Title</title>
</head>

<body>
	<script type="text/javascript">
		const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
		const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
		const spc_id = '<c:out value="${param.spc_id}" escapeXml="false" />';
		const gen_id = '<c:out value="${param.gen_id}" escapeXml="false" />';
		const currentTime = '<c:out value="${nowTime}" escapeXml="false" />';

		let supInfoLength = "";

		$(function () {

			//SPC명 가져오기
			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs/" + spc_id,
				type: "get",
				async: false,
				data: { "oid": oid },
				success: function (json) {
					if (json.data.length > 0) {
						$("#name").text(json.data[0].name)
					} else {
						alert("등록된 데이터가 없습니다.");
					}
				},
				error: function (request, status, error) {
					alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
				}
			});

			//발전소명 가져오기
			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs/" + spc_id + "/gens/" + gen_id,
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
			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs/" + spc_id + "/gens/" + gen_id + "/supplement?oid=" + oid,
				type: "get",
				dataType: 'json',
				async: false,
				contentType: "application/json",
				success: function (json) {

					$('button.btn_type07').hide(); // 삭제버튼 비활성 초기화
					$('button.down').hide(); // 다운로드 버튼 비활성 초기화

					supInfoLength = json.data.length;

					// 이관자료가 기존에 존재하면 테이블에 매칭
					if (supInfoLength > 0) {
						var linkDownUrl = 'http://iderms.enertalk.com:8443/files/download/';
						var supplementList = json.data[0].supplement_info
						supplementInfo = JSON.parse(supplementList)

						var keys = Object.keys(supplementInfo);
						for (var i in keys) {
							if (keys[i] != 'null') {
								var subStrOriginalName = keys[i].substring(0, keys[i].indexOf("_originalName"));
								var subStrFiledName = keys[i].substring(0, keys[i].indexOf("_filedName"));
								var subStrRegDt = keys[i].substring(0, keys[i].indexOf("_regDt"));

								$('#' + keys[i]).val(supplementInfo[keys[i]]);

								if (subStrOriginalName != '') {
									var originalData = "";
									$('#' + subStrOriginalName).next().val(supplementInfo[keys[i]]);
									originalData += supplementInfo[keys[i]];
								} else if (subStrFiledName != '') {
									if (originalData.length != 0) {
										linkDownUrl += supplementInfo[keys[i]] + '?oid=' + oid + '&orgFilename=' + originalData;
										$('#' + subStrFiledName).parents('tr').find('.down').attr('onclick', 'location.href=\"' + linkDownUrl + '\"');
										linkDownUrl = "http://iderms.enertalk.com:8443/files/download/";

										$('#' + subStrFiledName).parents('tr').find('.btn_type07').show(); //삭제버튼 활성화
										$('#' + subStrFiledName).parents('tr').find('.down').show(); //다운로드 버튼 활성화
									}
								} else if (subStrRegDt != '') {
									$('#' + subStrRegDt + '_regDt').after(supplementInfo[keys[i]]); //다운로드 버튼 활성화
								}
							}
						}
					}
				},
				error: function (request, status, error) {
					alert('처리 중 오류가 발생했습니다.');
					return false;
				}
			});

			// 파일 추가
			$('input[type="file"]').on('change', function () {
				let uuid = genUuid();
				let thisId = $(this).prop('id');

				$(this).clone().appendTo('#upload');
				$('#upload').find('input').attr('name', uuid).attr('id', uuid);

				callAjax({
					type: 'post',
					enctype: 'multipart/form-data',
					url: 'http://iderms.enertalk.com:8443/files/upload?oid=' + oid,
					data: new FormData($('#upload')[0]),
					processData: false,
					contentType: false,
					cache: false,
					timeout: 600000
				}, setUploadAfter, thisId);
			});



			// 삭제버튼 클릭
			$('button.btn_type07').on('click', function () {

				var result = confirm("삭제하시겠습니까?");
				if (result) {
					let tr = $(this).parents('tr');
					tr.next().val('');
					tr.find('input[type="text"]').val('')
					tr.find('input[type="hidden"]').val('')
					tr.find('.down').removeAttr('onclick');
					tr.find('.down').hide();
					$(this).hide();

					sendSupplementPatch();
				}
			});

		});

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
				prop.parents('tr').find('.btn_type07').show(); //삭제버튼 활성화
				prop.parents('tr').find('.down').show(); //다운로드 버튼 활성화

				let linkUrl = 'http://iderms.enertalk.com:8443/files/download/' + data.files[0].fieldname + '?oid=' + oid + '&orgFilename=' + data.files[0].originalname;
				prop.parents('tr').find('.down').attr('onclick', 'location.href=\"' + linkUrl + '\"');

				$('#' + propName + '_originalName').val(data.files[0].originalname);
				$('#' + propName + '_filedName').val(data.files[0].fieldname);

				$('#' + propName + '_regDt').val(currentTime.split(" ")[0]); // 발급일자 추가

				// 수정과 등록 분기
				if (supInfoLength > 0) {
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
				url: "http://iderms.enertalk.com:8443/spcs/" + spc_id + "/gens/" + gen_id + "/supplement?oid=" + oid,
				type: "post",
				dataType: 'json',
				async: false,
				contentType: "application/json",
				data: JSON.stringify({
					"supplement_info": JSON.stringify(supplement_info),
					"updated_by": loginId
				}),
				success: function (json) {
					console.log("등록성공 : " + json);
					location.reload();
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

			console.log(supplement_info);

			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs/" + spc_id + "/gens/" + gen_id + "/supplement?oid=" + oid,
				type: "patch",
				dataType: 'json',
				async: false,
				contentType: "application/json",
				data: JSON.stringify({
					"supplement_info": JSON.stringify(supplement_info),
					"updated_by": loginId
				}),
				success: function (json) {
					console.log("수정성공 : " + json);
					location.reload();
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

		function addList(addId){
			var $selecter = $("#" + addId);
			$selecter.append($selecter.data("form"));
		}

	</script>

	<form id="upload" name="upload" method="multipart/form-data" style="display:none;">
	</form>

	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">SPC 이관자료</h1>
			<div class="time fr">
				<span>CURRENT TIME</span>
				<em class="currTime">${nowTime}</em>
				<span>DATA BASE TIME</span>
				<em class="dbTime">2018-07-27 17:01:02</em>
			</div>
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
							<td>
								<input type="file" id="사업조직도" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="사업조직도_originalName" value="">
								<input type="hidden" id="사업조직도_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td>0</td>
							<td>
								<input type="hidden" id="사업조직도_regDt" value="">
							</td>
							<td>
								<label for="사업조직도" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>설치 업체 담당자 연락처</th>
							<td></td>
							<td>
								<input type="file" id="설치_업체_담당자_연락처" class="uploadBtn">
								<input type="text" class="fileName tx_file">
								<input type="hidden" id="설치_업체_담당자_연락처_originalName" value="">
								<input type="hidden" id="설치_업체_담당자_연락처_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td>0</td>
							<td>
								<input type="hidden" id="설치_업체_담당자_연락처_regDt" value="">
							</td>
							<td>
								<label for="설치_업체_담당자_연락처" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>투자/계약 심의</th>
							<td></td>
							<td>
								<input type="file" id="투자_계약_심의" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="투자_계약_심의_originalName" value="">
								<input type="hidden" id="투자_계약_심의_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td>0</td>
							<td>
								<input type="hidden" id="투자_계약_심의_regDt" value="">
							</td>
							<td>
								<label for="투자_계약_심의" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>사업자 등록증</th>
							<td></td>
							<td>
								<input type="file" id="사업자_등록증" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="사업자_등록증_originalName" value="">
								<input type="hidden" id="사업자_등록증_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="사업자_등록증_regDt" value="">
							</td>
							<td>
								<label for="사업자_등록증" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>발전사업 허가증</th>
							<td></td>
							<td>
								<input type="file" id="발전사업_허가증" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="발전사업_허가증_originalName" value="">
								<input type="hidden" id="발전사업_허가증_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="발전사업_허가증_regDt" value="">
							</td>
							<td>
								<label for="발전사업_허가증" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>토지 및 건물 등기부등록</th>
							<td></td>
							<td>
								<input type="file" id="토지_및_건물_등기부등록" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="토지_및_건물_등기부등록_originalName" value="">
								<input type="hidden" id="토지_및_건물_등기부등록_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="토지_및_건물_등기부등록_regDt" value="">
							</td>
							<td>
								<label for="토지_및_건물_등기부등록" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>토지대장 및 건물도면</th>
							<td></td>
							<td>
								<input type="file" id="토지대장_및_건물도면" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="토지대장_및_건물도면_originalName" value="">
								<input type="hidden" id="토지대장_및_건물도면_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="토지대장_및_건물도면_regDt" value="">
							</td>
							<td>
								<label for="토지대장_및_건물도면" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>원도급 계약서</th>
							<td>실사 협약서</td>
							<td>
								<input type="file" id="원도급_계약서_실사_협약서" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="원도급_계약서_실사_협약서_originalName" value="">
								<input type="hidden" id="원도급_계약서_실사_협약서_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td>0</td>
							<td>
								<input type="hidden" id="원도급_계약서_실사_협약서_regDt" value="">
							</td>
							<td>
								<label for="원도급_계약서_실사_협약서" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th></th>
							<td>토지이용 허가서</td>
							<td>
								<input type="file" id="원도급_계약서_토지이용_허가서" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="원도급_계약서_토지이용_허가서_originalName" value="">
								<input type="hidden" id="원도급_계약서_토지이용_허가서_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td>
								<input type="hidden" id="원도급_계약서_토지이용_허가서_regDt" value="">
							</td>
							<td>
								<label for="원도급_계약서_토지이용_허가서" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>하도급 계약서</th>
							<td>공사도급 계약서</td>
							<td>
								<input type="file" id="하도급_계약서_공사도급_계약서" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="하도급_계약서_공사도급_계약서_originalName" value="">
								<input type="hidden" id="하도급_계약서_공사도급_계약서_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="하도급_계약서_공사도급_계약서_regDt" value="">
							</td>
							<td>
								<label for="하도급_계약서_공사도급_계약서" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th></th>
							<td>설계용역 계약서</td>
							<td>
								<input type="file" id="하도급_계약서_설계용역_계약서" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="하도급_계약서_설계용역_계약서_originalName" value="">
								<input type="hidden" id="하도급_계약서_설계용역_계약서_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="하도급_계약서_설계용역_계약서_regDt" value="">
							</td>
							<td>
								<label for="하도급_계약서_설계용역_계약서" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th></th>
							<td>감리용역 계약서</td>
							<td>
								<input type="file" id="하도급_계약서_감리용역_계약서" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="하도급_계약서_감리용역_계약서_originalName" value="">
								<input type="hidden" id="하도급_계약서_감리용역_계약서_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td>0</td>
							<td>
								<input type="hidden" id="하도급_계약서_감리용역_계약서_regDt" value="">
							</td>
							<td>
								<label for="하도급_계약서_감리용역_계약서" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>기자재 시험 성적서</th>
							<td>인버터</td>
							<td>
								<input type="file" id="기자재_시험_성적서_인버터" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="기자재_시험_성적서_인버터_originalName" value="">
								<input type="hidden" id="기자재_시험_성적서_인버터_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td>0</td>
							<td>
								<input type="hidden" id="기자재_시험_성적서_인버터_regDt" value="">
							</td>
							<td>
								<label for="기자재_시험_성적서_인버터" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th></th>
							<td>모듈</td>
							<td>
								<input type="file" id="기자재_시험_성적서_모듈" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="기자재_시험_성적서_모듈_originalName" value="">
								<input type="hidden" id="기자재_시험_성적서_모듈_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="기자재_시험_성적서_모듈_regDt" value="">
							</td>
							<td>
								<label for="기자재_시험_성적서_모듈" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th></th>
							<td>변압기</td>
							<td>
								<input type="file" id="기자재_시험_성적서_변압기" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="기자재_시험_성적서_변압기_originalName" value="">
								<input type="hidden" id="기자재_시험_성적서_변압기_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="기자재_시험_성적서_변압기_regDt" value="">
							</td>
							<td>
								<label for="기자재_시험_성적서_변압기" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th></th>
							<td>수배전반</td>
							<td>
								<input type="file" id="기자재_시험_성적서_수배전반" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="기자재_시험_성적서_수배전반_originalName" value="">
								<input type="hidden" id="기자재_시험_성적서_수배전반_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="기자재_시험_성적서_수배전반_regDt" value="">
							</td>
							<td>
								<label for="기자재_시험_성적서_수배전반" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>모듈 Inspection Sheet</th>
							<td></td>
							<td>
								<input type="file" id="모듈_Inspection_Sheet" class="uploadBtn">
								<input type="text" class="fileName tx_file" readonly="readonly">
								<input type="hidden" id="모듈_Inspection_Sheet_originalName" value="">
								<input type="hidden" id="모듈_Inspection_Sheet_filedName" value="">
							</td>
							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="모듈_Inspection_Sheet_regDt" value="">
							</td>
							<td>
								<label for="모듈_Inspection_Sheet" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>
						<tr>
							<th>추가항목</th>
							<td><a href="javascript:addList('addList01');" class="btn_add">추가</a></td>
							<td id="addList01" class="group_type">
								<div class="tx_inp_type edit">
									<input type="text" id="name" placeholder="인감 증명">
								</div>
								<button class="btn_type07 fr"></button>
							</td>

							<td>
								<button class="btn_file down">다운로드</button>
							</td>
							<td></td>
							<td>
								<input type="hidden" id="이관자료_테스트1_regDt" value="">
							</td>
							<td>
								<label for="이관자료_테스트1" class="btn_type_attachment">추가</label>
								<button class="btn_type07">삭제</button>
							</td>
						</tr>

					</table>
				</div>
				<div class="btn_wrap_type02 mt30"><button type="button" class="btn_type03" onclick="goMoveList();">목록</button></div>
			</div>
		</div>
	</div>
</body>

</html>