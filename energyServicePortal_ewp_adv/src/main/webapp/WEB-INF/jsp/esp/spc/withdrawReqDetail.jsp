<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script src="/js/commonDropdown.js"></script>
<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';
	
	$(function() {
		const txtArea = $("textarea.textarea");
		txtArea.eq(0).val("2020-04-12 13:20 / 이효섭 / 메모");
		unCheckAll();
		formatToday();
	});
	$(document).on('keyup', '#key_word', function(e) {
		if (e.keyCode == 13) {
			getDataList(page);
		}
	})

	function initTextArea(){
		const txtArea = $("textarea.textarea");
		txtArea.eq(1).val("");
	}

	function tempSave(){
		let str = '';
		let inputStr = txtArea.val();
	}

	function formatToday() {
		let date = new Date().toISOString().substr(0, 10);
	}

	// onclick="location.href='http://iderms.enertalk.com:8443/files/download/5c71e049-f73c-2bf9-a9a0-2f91d067ef11?oid=spower&orgFilename=수익보고서_20200526100755.pdf'"

	function downloadFile(spcId){
		var genId = $("#gen").data("value");

		$("#attachement_info").find("input[type=file]").each(function(){
			$(this).attr("name", this.name + "_" + spcId +"_" + genId);
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
			data: new FormData($('#attachement_info')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			success: function (result) {
				console.log
				// sendSpcGenPost(spcId, result.files);
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	function sendSpcGenPost(spcId, files){
		var genId = $("#gen").data("value");

		var contract_info = setAreaParamData("contract_info"),
			device_info = setAreaParamData("device_info"),
			finance_info = setAreaParamData("finance_info"),
			warranty_info = setAreaParamData("warranty_info"),
			coefficient_info = setAreaParamData("coefficient_info"),
			contact_info = setAreaParamData("contact_info"),
			attachement_info = files;

		device_info["addList01"] = setAddListParam("addList01");
		device_info["addList02"] = setAddListParam("addList02");
		device_info["addList03"] = setAddListParam("addList03");
		device_info["addList04"] = setAddListParam("addList04");
		device_info["addList05"] = setAddListParam("addList05");
		device_info["addList06"] = setAddListParam("addList06");
		device_info["addList07"] = setAddListParam("addList07");

		$.ajax({
			url: "http://iderms.enertalk.com:8443/spcs/" + spcId +"/gens?oid=" + oid +"&gen_id=" + genId,
			type: "post",
			async: true,
			contentType: "application/json",
			data: JSON.stringify({
				"contract_info": JSON.stringify(contract_info),
				"device_info" : JSON.stringify(device_info),
				"finance_info" : JSON.stringify(finance_info),
				"warranty_info" : JSON.stringify(warranty_info),
				"coefficient_info" : JSON.stringify(coefficient_info),
				"contact_info" : JSON.stringify(contact_info),
				"attachement_info" : JSON.stringify(attachement_info),
				"updated_by" : loginId,
				"del_yn": "N"
			}),
			success: function (json) {
				alert("등록되었습니다.");
				goMoveList();
			},
			error: function (request, status, error) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			}
		});
	}

	// function initForm(){
	// 	var f = document.getElementsByTagName('');
	// 	f.reset();
	// }

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 검토</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-xl-8 col-lg-7 col-md-6 col-sm-12">
		<div class="indiv spc-detail">
			<div class="flex_wrapper">
				<h2 class="ntit">출금 요청서</h2>
				<span class="tx_tit blue_text">상태: 검토중</span>
			</div>
			<div class="flex_start">
				<h2 class="tx_tit">SPC 명</h2>
				<span id="spc_name" class="tx_tit">SPC2</span>
			</div>
			<div class="flex_start">
				<h2 class="tx_tit">출금 계좌 번호</h2>
				<span class="tx_tit">신한 225-558-999341</span>
			</div>

			<div class="tbl_wrap_type collect_wrap mt30">
				<table class="his_tbl table-footer">
					<thead>
						<tr>
							<th>출금일자</th>
							<th>구분</th>
							<th>요청 금액</th>
							<th>계좌번호</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>2020-05-08</td>
							<td>관리 운영비</td>
							<td>200,000,000 </td>
							<td>신한 225-558-999341</td>
							<td></td>
						</tr>
						<tr>
							<td>2020-05-08</td>
							<td>관리 운영비</td>
							<td>200,000,000 </td>
							<td>신한 225-558-999341</td>
							<td></td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td>합계</td>
							<td></td>
							<td>100,000,000</td>
							<td colspan="2"></td>
						</tr>
					</tfoot>
				</table>
			</div>

		</div>
	</div>
	<div class="col-xl-4 col-lg-5 col-md-6 col-sm-12">
		<div class="indiv spc-detail">
			<div class="flex_wrapper">
				<h2 class="ntit">증빙 서류</h2>
			</div>
			<div class="flex_wrapper border">
				<a id="file_name" href="#" class="btn_type02">거래 내역서.pdf</a>
				<a onclick="downloadFile('spc_name')" class="save_btn"></a>
			</div>
			
			<div class="flex_wrapper">
				<h2 class="heading">출금 요청서 + 증빙</h2>
				<div class="fr">
					<button type="button" class="btn_type03">인쇄</button><button 
						type="button" class="btn_type ml-12">다운로드</button>
				</div>
			</div>
			<div class="flex_wrapper border mt20">
				<h2 class="heading">출금 요청서</h2>
				<div class="fr">
					<button type="button" class="btn_type03">인쇄</button><button 
					type="button" class="btn_type ml-12">다운로드</button>
				</div>
			</div>
			<div class="flex_wrapper border">
				<textarea class="textarea w-100" readonly></textarea>
			</div>

			<div class="flex_wrapper">
				<h2 class="heading">메모</h2>
				<a class="chk_type">
					<input type="checkbox" id="chk02" name="chk02">
					<label for="chk02">사무수탁사 함께 보기</label>
				</a>
			</div>
			<div class="textarea-container mt20">
				<button type="button" class="btn_type03 fixed_btn" onclick="tempSave()">저장</button>
				<textarea placeholder="직접입력" class="textarea w-100"></textarea>
			</div>

			<div class="spc-btn-group mt20">
				<button type="button" class="btn_type03 w80">반송</button><button
					type="button" class="btn_type ml-12">승인</button>
			</div>
		</div>
	</div>
</div>
