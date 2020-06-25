<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/js/commonDropdown.js"></script>
<script>
	$(function () {
		init();
		getGenData();
		getDataSpcBasic();
		getDataSpcGen();
	});

	function init() {
		setInitList("addList01");
		setInitList("addList02");
		setInitList("addList03");
		setInitList("addList04");
		setInitList("addList05");
		setInitList("addList06");
		setInitList("addList07");

		setInitList("addFileList01");
		setInitList("addFileList02");
		setInitList("addFileList03");
		setInitList("addFileList04");
		setInitList("addFileList05");
		setInitList("addFileList06");
		setInitList("addFileList07");
		setInitList("addFileList08");
		setInitList("addFileList09");
		setInitList("addFileList10");
	}

	function getAttachFileDisplay(attachement_info) {
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}",
			oid = "${param.oid}";

		var addFileList01 = [], addFileList02 = [], addFileList03 = [], addFileList04 = [], addFileList05 = [],
			addFileList06 = [], addFileList07 = [], addFileList08 = [], addFileList09 = [], addFileList10 = [];

		for (var i = 0, count = attachement_info.length; i < count; i++) {
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

		setMakeList(addFileList01, "addFileList01", { "dataFunction": {} });
		setMakeList(addFileList02, "addFileList02", { "dataFunction": {} });
		setMakeList(addFileList03, "addFileList03", { "dataFunction": {} });
		setMakeList(addFileList04, "addFileList04", { "dataFunction": {} });
		setMakeList(addFileList05, "addFileList05", { "dataFunction": {} });
		setMakeList(addFileList06, "addFileList06", { "dataFunction": {} });
		setMakeList(addFileList07, "addFileList07", { "dataFunction": {} });
		setMakeList(addFileList08, "addFileList08", { "dataFunction": {} });
		setMakeList(addFileList09, "addFileList09", { "dataFunction": {} });
		setMakeList(addFileList10, "addFileList10", { "dataFunction": {} });
		
		let noData = $('#attachement_info .spc_tbl_row .no-data').parent().next().children();
		for(let i in noData){
			noData.hide();
		}
	}

	function getGenData() {
		var genId = "${param.gen_id}";
		$.ajax({
			url: "http://iderms.enertalk.com:8443/config/sites/" + genId,
			type: "get",
			async: false,
			data: {},
			success: function (json) {
				$("#genName").text(json.name);
				$("#countryValue").text("대한민국");
				$("#sidoValue").text(json.location);
				$("#address").text(json.address)
			},
			error: function (request, status, error) {

			}
		});
	}

	function getDataSpcBasic() {
		var spcId = "${param.spc_id}",
			oid = "${param.oid}";

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/" + spcId,
			type: "get",
			async: false,
			data: { "oid": oid },
			success: function (json) {
				if (json.data.length > 0) {
					setJsonAutoMapping(json.data[0], "spc_info");
				} else {
					alert("등록된 데이터가 없습니다.");
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function getDataSpcGen() {
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}",
			oid = "${param.oid}";

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/" + spcId + "/gens/" + genId,
			type: "get",
			async: false,
			data: { "oid": oid },
			success: function (json) {
				if (json.data.length > 0) {
					setJsonAutoMapping(JSON.parse(json.data[0].contract_info), "contract_info");
					setJsonAutoMapping(JSON.parse(json.data[0].device_info), "device_info");
					setJsonAutoMapping(JSON.parse(json.data[0].finance_info), "finance_info");
					setJsonAutoMapping(JSON.parse(json.data[0].warranty_info), "warranty_info");
					setJsonAutoMapping(JSON.parse(json.data[0].coefficient_info), "coefficient_info");
					setJsonAutoMapping(JSON.parse(json.data[0].contact_info), "contact_info");
					getAttachFileDisplay(JSON.parse(json.data[0].attachement_info));

					var device_info = JSON.parse(json.data[0].device_info);
					setMakeList(device_info["addList01"], "addList01", { "dataFunction": {} });
					setMakeList(device_info["addList02"], "addList02", { "dataFunction": {} });
					setMakeList(device_info["addList03"], "addList03", { "dataFunction": {} });
					setMakeList(device_info["addList04"], "addList04", { "dataFunction": {} });
					setMakeList(device_info["addList05"], "addList05", { "dataFunction": {} });
					setMakeList(device_info["addList06"], "addList06", { "dataFunction": {} });
					setMakeList(device_info["addList07"], "addList07", { "dataFunction": {} });

				} else {
					alert("등록된 데이터가 없습니다.");
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function goMoveList() {
		location.href = "/spc/entityInformation.do";
	}

	function setCheckedDataEdit() {
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}";

		location.href = '/spc/entityInformationEdit.do?spc_id=' + spcId + "&gen_id=" + genId;
	}

	function getExcelDown() {
		let excelName = 'spc_info_list';

		var excelHtml = '';
		excelHtml += $('#spc_info .spc_tbl_row').html();
		excelHtml += $('#contract_info .spc_tbl_row').html();
		excelHtml += $('#device_info .spc_tbl_row').html();
		excelHtml += $('#finance_info .spc_tbl_row').html();
		excelHtml += $('#warranty_info .spc_tbl_row').html();
		excelHtml += $('#coefficient_info .spc_tbl_row').html();
		excelHtml += $('#attachement_info .spc_tbl_row').html();

		$('#excelList').html(excelHtml);

		if (confirm('엑셀로 저장하시겠습니까?')) {
			tableToExcel('excelList', excelName);
		}
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
<div class="row entity_detail">
	<div class="col-lg-12">
		<div class="indiv" id="spc_info">
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>SPC명</th>
						<td id="name"></td>
						<th>발전소명</th>
						<td id="genName"></td>
					</tr>
					<tr>
						<th>주소</th>
						<td>
							<span id="countryValue"></span>
							<span id="sidoValue"></span>
							<span id="address"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv" id="contract_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">운영 정보</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>담당부서</th>
						<td id="담당부서"></td>
						<th>담당자</th>
						<td><span id="담당자"></span> <span id="담당자_연락처"></span></td>
					</tr>
					<tr>
						<th>설치 용량</th>
						<td><span id="설치_용량"></span> kW <span id="설치_용량_기타"></span></td>
						<th>관리 운영 기간</th>
						<td id="관리_운영_기간"></td>
					</tr>
					<tr>
						<th>기상 관측 지점</th>
						<td id="기상_관측_지점">38°23'36.2"N, 128°24'05.0"E</td>
						<th>하자 보증기간(전기)</th>
						<td><span id="하자_보증기간(전기)_from"></span> ~ <span id="하자_보증기간(전기)_to"></span></td>
					</tr>
					<tr>
						<th>사용 전 검사 완료일</th>
						<td id="사용_전_검사_완료일">2018-06-18</td>
						<th>하자 보증기간(토목)</th>
						<td><span id="하자_보증기간(토목)_from"></span> ~ <span id="하자_보증기간(토목)_to"></span></td>
					</tr>
					<tr>
						<th>정기 검사</th>
						<td><span id="정기_검사_주기"> </span><span id="정기_검사_from"></span> ~ <span id="정기_검사_to"></span></td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>등기이사 소속 / 등기이사 명</th>
						<td><span id="등기이사_소속"></span> / <span id="등기이사_명"></span></td>
						<th>등기 기간</th>
						<td><span id="등기_기간_from"></span> ~ <span id="등기_기간_to"></span></td>
					</tr>
					<tr>
						<th>계약 단가</th>
						<td><span id="계약_단가"></span> 원</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv" id="device_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">설비 정보</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>모듈 제조사 / 모델</th>
						<td id="addList01">
							[모듈_제조사] / [모듈_제조사_모델]<br />
						</td>
						<th>설치 용량</th>
						<td> <span id="설치_용량_KW"></span> kW / <span id="설치_용량_매"></span> 매</td>
					</tr>
					<tr>
						<th>모듈 설치 각도</th>
						<td id="addList02">
							[모듈_설치_각도]<span>︒</span><br />
						</td>
						<th>모듈 설치 방식</th>
						<td>
							<span id="모듈_설치_방식_고정"></span>
							<span id="모듈_설치_방식_트래커"></span>
							<span id="모듈_설치_방식_경사고정형"></span>
						</td>
					</tr>
					<tr>
						<th>인버터 제조사 / 모델</th>
						<td id="addList03">
							[인버터_제조사] / [인버터_제조사_모델]<br />
						</td>
						<th>인버터 용량 / 대수</th>
						<td id="addList04">
							[인버터_용량] kW / [인버터_용량_대수] 대<br />
						</td>
					</tr>
					<tr>
						<th>접속반 제조사 / 모델</th>
						<td id="addList05">
							[접속반_제조사] / [접속반_제조사_모델]<br />
						</td>
						<th>접속반 채널 / 대수</th>
						<td id="addList06">
							[접속반_채널] Ch / [접속반_채널_대수] 대<br />
						</td>
					</tr>
					<tr>
						<th>접속반 용량 / 통신방식</th>
						<td>
							<span id="접속반_용량">100</span> kW / <span id="통신방식"></span>
						</td>
						<th>수배전반 제조사 / 모델</th>
						<td id="addList07">
							[수배전반_제조사] / [수배전반_제조사_모델]<br />
						</td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td>
							<span id="설치_타입_그라운드"></span>
							<span id="설치_타입_루프탑"></span>
							<span id="설치_타입_수상"></span>
						</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv" id="finance_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">금융 정보</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>관련 금융사</th>
						<td id="관련_금융사">-</td>
						<th>관련 보험사</th>
						<td id="관련_보험사">-</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv" id="warranty_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">보증 정보</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>보증 방식</th>
						<td id="보증_방식">PR</td>
						<th>PR 보증치</th>
						<td><span id="PR_보증치">100</span> %</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td><span id="발전시간_보증치"></span>h</td>
						<th>보증 감소율</th>
						<td><span id="보증_감소율">연차별 0.5</span> %</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td><span id="기준_단가"></span><span id="기준_단가_원"></span> 원 / kW</td>
						<th>현재 적용 연차</th>
						<td><span id="현재_적용_연차">3</span> 년차</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td><span id="년간_관리_운영비"></span> 만원</td>
						<th>물가 반영 비율</th>
						<td><span id="물가_반영_비율"></span> %</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td id="추가_보수">무</td>
						<th>추가 보수 용량</th>
						<td><span id="추가_보수_용량">0</span> kW 이상</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td><span id="전력요금_종별_요금제">0</span> %</td>
						<th>전력요금 종별</th>
						<td><span id="전력요금_종별_계약전력">일반용(갑)</span> kW</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv" id="coefficient_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">환경 변수</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>Annual Variability</th>
						<td><span id="Annual">1.83</span> %</td>
						<th>PV modul modeling/params</th>
						<td><span id="PV_modul">2.00</span> %</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td><span id="Inverter">98.5</span> % </td>
						<th>Soiling, mismatch</th>
						<td><span id="Soiling">1</span> %</td>
					</tr>
					<tr>
						<th>Degradation estimation</th>
						<td><span id="Degradation">1</span> %</td>
						<th>Resulting ann, Variability(sigma)</th>
						<td><span id="Resulting_ann">98</span> %</td>
					</tr>
					<tr>
						<th>System Degradation</th>
						<td><span id="Degradation">0.5</span> %</td>
						<th>System Availability</th>
						<td><span id="Availability">99</span> %</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv" id="contact_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">관련 정보</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="width:15%">
						<col style="width:35%">
					</colgroup>
					<tr>
						<th>전기안전 관리 회사명</th>
						<td id="전기안전_관리_회사명">S-power</td>
						<th>회사 연락처</th>
						<td id="회사_연락처">070-4339-7100</td>
					</tr>
					<tr>
						<th>전기안전 관리 대표자명</th>
						<td id="전기안전_관리_대표자명">박재균 </td>
						<th>대표자 연락처</th>
						<td id="대표자_연락처">070-4339-7100</td>
					</tr>
					<tr>
						<th>전기안전 관리 담당자명</th>
						<td id="전기안전_관리_담당자명">박재균</td>
						<th>담당자 연락처</th>
						<td id="담당자_연락처">010-4711-4415</td>
					</tr>
					<tr>
						<th>현장 잠금장치 비밀번호</th>
						<td id="현장_잠금장치_비밀번호">-</td>
						<th>시공사</th>
						<td id="시공사">S-power</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv" id="attachement_info">
			<div class="tbl_top">
				<h2 class="ntit mt25">첨부 파일</h2>
			</div>
			<div class="spc_tbl_row">
				<table>
					<colgroup>
						<col style="width:15%">
						<col style="width:20%">
						<col>
					</colgroup>
					<tr>
						<th>현장 사진</th>
						<td id="addFileList01">
							<p class="tx_file"><a
								href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>수배전반</th>
						<td id="addFileList02">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>케이블</th>
						<td id="addFileList03">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>모듈</th>
						<td id="addFileList04">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>인버터</th>
						<td id="addFileList05">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>결선도</th>
						<td id="addFileList06">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>토목</th>
						<td id="addFileList07">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>구조물</th>
						<td id="addFileList08">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>접속반</th>
						<td id="addFileList09">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
					<tr>
						<th>기타설비</th>
						<td id="addFileList10">
							<p class="tx_file"><a
									href="http://iderms.enertalk.com:8443/files/download/[fieldname]?oid=${param.oid}&orgFilename=[originalname]">[originalname]</a>
							</p>
						</td>
						<td><button class="btn_file down"></button></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="getExcelDown();">엑셀 다운로드</button>
				<button type="button" class="btn_type03" onclick="setCheckedDataEdit();">수정</button>
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
			</div>
		</div>
		<div id="excelList" style="display:none;">
		</div>
	</div>
</div>