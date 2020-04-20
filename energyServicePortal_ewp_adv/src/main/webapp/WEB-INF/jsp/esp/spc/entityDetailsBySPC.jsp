<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 16:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
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
	<div class="row">
		<div class="col-lg-12">
			<div class="indiv">
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
							<td>암사정수장</td>
							<th>발전소명</th>
							<td>OCI서울</td>
						</tr>
					</table>	
				</div>
			</div>
			<div class="indiv mt25">
				<div class="spc_tbl_row">			
					<table class="mt30">
						<colgroup>
						<col style="width:10%">
						<col style="width:20%">
						<col>
						</colgroup>
						<tr>
							<th>구분</th>
							<th></th>
							<th>타이틀</th>
							<th></th>
							<th>다운로드</th>
							<th>발급일자</th>
							<th>비고</th>
						</tr>
						<tr>
							<td>사업조직도</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>설치 업체 담당자 연락처</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>투자/계약 심의</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>사업자 등록증</td>
							<td></td>
							<td><p class="tx_file">4.사업자등록증_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>발전사업 허가증</td>
							<td></td>
							<td><p class="tx_file">5.발전사업허가증_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>토지 및 건물 등기부등록</td>
							<td></td>
							<td><p class="tx_file">6.토지등기부등본_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>토지대장 및 건물도면</td>
							<td></td>
							<td><p class="tx_file">7.토지대장_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>원도급 계약서</td>
							<td>실사 협약서</td>
							<td><p class="tx_file">8.원도급_계약서(실시협약서)_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td></td>
							<td>토지이용 허가서</td>
							<td><p class="tx_file">8.원도급계약서(토지이용허가서)_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>하도급 계약서</td>
							<td>공사도급 계약서</td>
							<td><p class="tx_file">9.하도급계약서(공사도급예약)_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td></td>
							<td>설계용역 계약서</td>
							<td><p class="tx_file">9.하도급계약서(공사도급예약)_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td></td>
							<td>감리용역 계약서</td>
							<td><p class="tx_file">9.하도급계약서(설계감리용역)_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>기자재 시험 성적서</td>
							<td>인버터</td>
							<td><p class="tx_file">20.기자재시험성적서(인버터)_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td></td>
							<td>모듈</td>
							<td><p class="tx_file">20.기자재시험성적서(모듈)_암사_서울.pdf</p></td>
							<td><button class="btn_file down">다운로드</button></td>
							<td>O</td>
							<td>2020-03-10</td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td></td>
							<td>변압기</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td></td>
							<td>수배전반</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>모듈 Inspection Sheet</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td>이관자료</td>
							<td>테스트1</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
						<tr>
							<td></td>
							<td>테스트2</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><button class="btn_type05">추가</button></td>
						</tr>
					</table>	
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
