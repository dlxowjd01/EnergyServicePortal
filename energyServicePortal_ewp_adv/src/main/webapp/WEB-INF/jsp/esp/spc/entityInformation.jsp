<%--
  Created by IntelliJ IDEA.
  User: Youduk
  Date: 2020/04/18
  Time: 15:53
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
		getDataList();
	});

	function getDataList(){
		setInitList("listData"); //리스트초기화

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs",
			type: "get",
			async: false,
			data: {oid: "spower"},
			success: function (result) {
				if(result.data.length > 0){
					setMakeList(result.data, "listData", {"dataFunction" : {}}); //list생성
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
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
	<div class="col-lg-3">
		<div class="tx_btn_area">
			<div class="tx_inp_type">
				<input type="text" placeholder="입력">
			</div>
			<button type="submit" class="btn_type">검색</button>
		</div>
	</div>
	<div class="col-lg-9">
		<div class="right">
			<a href="#;" class="save_btn">CVS 다운로드</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="btn_wrap_type">
				<button type="button" class="btn_type03">선택 삭제</button>
				<button type="button" class="btn_type">신규 등록</button>
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
						<th><button class="btn_align down">연차</button></th>
						<th><button class="btn_align down">관리 운영기간</button></th>
						<th><button class="btn_align up">보증</button></th>
						<th class="right"><button class="btn_align down">보증 값</button></th>
						<th class="right"><button class="btn_align down">감소율</button></th>
						<th>- 추가보수</th>
					</tr>
					</thead>
					<tbody id="listData">
					<tr>
						<td>
							<input type="checkbox" id="chk_op02" value="1">
							<label for="chk_op02"><span></span>[INDEX]</label>
						</td>
						<td><a href="/spc/entityDetails.do" class="tbl_link">[spc_name1]</a></td>
						<td><a href="/spc/entityDetails.do" class="tbl_link">[spc_name2]</a></td>
						<td>3년차</td>
						<td>2018-06-18 ~ 2020-12-31</td>
						<td>PR</td>
						<td class="right">75</td>
						<td class="right">-</td>
						<td>-</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="paging_wrap">
				<a href="#;" class="btn_prev">prev</a>
				<strong>1</strong>
				<a href="#;" class="btn_next">next</a>
			</div>
		</div>
	</div>
</div>
</body>
</html>
