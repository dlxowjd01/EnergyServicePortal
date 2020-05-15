<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 15:55
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
		getDataSpcBasic();
		getDataSpcGen();
	});

	function getDataSpcBasic(){
		var spcId = "${param.spc_id}",
			oid = "${param.oid}";

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/" + spcId,
			type: "get",
			async: false,
			data: {oid : oid},
			success: function (json) {
				if(json.data.length > 0){
					setJsonAutoMapping(json.data[0], "spc_info");
					setJsonAutoMapping(JSON.parse(json.data[0].spc_info), "spc_info");
				}else{
					alert("등록된 데이터가 없습니다.");
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function getDataSpcGen(){
		var spcId = "${param.spc_id}",
			genId = "${param.gen_id}",
			oid = "${param.oid}";

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/" + spcId + "/gens/" + genId,
			type: "get",
			async: false,
			data: {oid : oid},
			success: function (json) {
				if(json.data.length > 0){
					$("#발전소명").text(json.data[0].name);
					setJsonAutoMapping(JSON.parse(json.data[0].contract_info), "contract_info");
					setJsonAutoMapping(JSON.parse(json.data[0].device_info), "device_info");
					setJsonAutoMapping(JSON.parse(json.data[0].finance_info), "finance_info");
					setJsonAutoMapping(JSON.parse(json.data[0].warranty_info), "warranty_info");
					setJsonAutoMapping(JSON.parse(json.data[0].coefficient_info), "coefficient_info");
					setJsonAutoMapping(JSON.parse(json.data[0].attachement_info), "attachement_info");
				}else{
					alert("등록된 데이터가 없습니다.");
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function goMoveList(){
		location.href = "/spc/entityInformation.do";
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
						<td id="발전소명"></td>
					</tr>
					<tr>
						<th>주소</th>
						<td id="주소">강원도 고성군 간성읍 해상리 산 137-2</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="contract_info">
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
						<td id="담당부서">연구소</td>
						<th>담당자</th>
						<td id="담당자">박재균 010-4711-4415</td>
					</tr>
					<tr>
						<th>설치 용량</th>
						<td id="설치_용량">97.28 kW (계약)</td>
						<th>관리 운영 기간</th>
						<td id="관리_운영_기간">2018-06-18 ~ 2020-12-31</td>
					</tr>
					<tr>
						<th>기상 관측 지점</th>
						<td id="기상_관측_지점">38°23'36.2"N, 128°24'05.0"E</td>
						<th>하자 보증기간(전기)</th>
						<td id="하자 _보증기간(전기)">2018-06-18</td>
					</tr>
					<tr>
						<th>사용 전 검사 완료일</th>
						<td id="사용_전_검사_완료일">2018-06-18</td>
						<th>하자 보증기간(토목)</th>
						<td id="하자_보증기간(토목)">-</td>
					</tr>
					<tr>
						<th>정기 검사</th>
						<td id="정기_검사">-</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>등기이사 소속 / 등기이사 명</th>
						<td><span id="등기이사_소속 ">에스파워 회장</span> / <span id="등기이사_명">홍성민</span></td>
						<th>등기 기간</th>
						<td id="등기_기간">-</td>
					</tr>
					<tr>
						<th>계약 단가</th>
						<td id="계약_단가">0 원</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="device_info">
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
						<td>
							<span id="모듈_제조사">S-Energy</span> / <span id="모듈_제조사_모델">SM-300PC8</span><br/>
							<span id="모듈_제조사">S-Energy</span> / <span id="모듈_제조사_모델">SM-300PC8</span>
						</td>
						<th>설치 용량</th>
						<td> <span>100 kW</span> / <span>2100 매</span></td>
					</tr>
					<tr>
						<th>모듈 설치 각도</th>
						<td>
							<span>32</span><br/>
							<span>32</span>
						</td>
						<th>모듈 설치 방식</th>
						<td id="모듈_설치_방식">고정형</td>
					</tr>
					<tr>
						<th>인버터 제조사 / 모델</th>
						<td>
							<span>WILLIMGS</span> / <span>M10-100</span><br/>
							<span>WILLIMGS</span> / <span>M10-100</span>
						</td>
						<th>인버터 용량 / 대수</th>
						<td>
							<span>100 kW</span> / <span>1대</span><br/>
							<span>100 kW</span> / <span>1대</span>
						</td>
					</tr>
					<tr>
						<th>접속반 제조사 / 모델</th>
						<td>
							<span>미래이엔아이</span> / <span>MUX-COM</span><br/>
							<span>미래이엔아이</span> / <span>MUX-COM</span>
						</td>
						<th>접속반 채널 / 대수</th>
						<td>
							<span>16 Ch</span> / <span>1대</span><br/>
							<span>16 Ch</span> / <span>1대</span>
						</td>
					</tr>
					<tr>
						<th>접속반 용량 / 통신방식</th>
						<td>100 kW / 통신</td>
						<th>수배전반 제조사 / 모델</th>
						<td>
							<span>LS산전</span> / <span>GIPAM-115FI</span><br/>
							<span>LS산전</span> / <span>GIPAM-115FI</span>
						</td>
					</tr>
					<tr>
						<th>설치 타입</th>
						<td id="설치_타입">그라운드</td>
						<th></th>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="finance_info">
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
		<div class="indiv mt25" id="warranty_info">
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
						<td id="PR_보증치">75 %</td>
					</tr>
					<tr>
						<th>발전시간 보증치</th>
						<td id="발전시간_보증치">3 h</td>
						<th>보증 감소율</th>
						<td id="보증_감소율">연차별 0.5 %</td>
					</tr>
					<tr>
						<th>기준 단가</th>
						<td id="기준_단가">145 원 /kW</td>
						<th>현재 적용 연차</th>
						<td id="현재_적용_연차">3 년차</td>
					</tr>
					<tr>
						<th>년간 관리 운영비 (1년차)</th>
						<td id="년간_관리_운영비">11,779 만원</td>
						<th>물가 반영 비율</th>
						<td id="물가_반영_비율">100 %</td>
					</tr>
					<tr>
						<th>추가 보수</th>
						<td id="추가_보수">무</td>
						<th>추가 보수 용량</th>
						<td id="추가_보수_용량">0 kW 이상</td>
					</tr>
					<tr>
						<th>추가 보수 백분율</th>
						<td id="추가_보수_백분율">0 %</td>
						<th>전력요금 종별</th>
						<td id="전력요금_종별">일반용(갑) kW</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="coefficient_info">
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
						<td id="Annual">1.83 %</td>
						<th>PV modul modeling/params</th>
						<td id="PV_modul">2.00 %</td>
					</tr>
					<tr>
						<th>Inverter efficiency</th>
						<td id="Inverter">98.5 % </td>
						<th>Soiling, mismatch</th>
						<td id="Soiling">1 %</td>
					</tr>
					<tr>
						<th>Degradation estimation</th>
						<td id="Degradation">1 %</td>
						<th>Resulting ann, Variability(sigma)</th>
						<td id="Resulting_ann">98 %</td>
					</tr>
					<tr>
						<th>System Degradation</th>
						<td id="Degradation">0.5 %</td>
						<th>System Availability</th>
						<td id="Availability">99 %</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="indiv mt25" id="contact_info">
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
		<div class="indiv mt25" id="attachement_info">
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
						<td><div class="img_bx"><img src="../img/@sample02.png"></div></td>
						<td class="vbt"><button class="btn_file up">업로드</button></td>
					</tr>
					<tr>
						<th>수배전반</th>
						<td></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>케이블</th>
						<td></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>모듈</th>
						<td></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>인버터</th>
						<td><p class="tx_file">GCI2014-PS007-M10-100옥외형_제작사양서_V010_140922.pdf</p></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>결선도</th>
						<td><p class="tx_file">M10-100_계통도V020_150302.pdf</p></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>토목</th>
						<td></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>구조물</th>
						<td></td>
						<td><button class="btn_file up">업로드</button></td>
					</tr>
					<tr>
						<th>접속반</th>
						<td></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
					<tr>
						<th>기타설비</th>
						<td></td>
						<td><button class="btn_file down">다운로드</button></td>
					</tr>
				</table>
			</div>
			<div class="btn_wrap_type02">
				<button type="button" class="btn_type03" onclick="">수정</button>
				<button type="button" class="btn_type03" onclick="goMoveList();">목록</button>
			</div>
		</div>
	</div>
</div>
</body>
</html>
