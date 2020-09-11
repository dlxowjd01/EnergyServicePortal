<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function() {
		policy();
	});

	/**
	 * 정책 조회.
	 *
	 * @returns {Promise<void>}
	 */
	const policy = async () => {
		let option = {
			url : certApiHost + '/deviceReg',
			type : 'GET',
			contentType: 'application/x-www-form-urlencoded',
			crossOrigin: true
		}
		$.ajax(option).done(function (result) {
			const data = result.policyList;
			data.forEach(policy => {
				let liStr = `<li data-value="${'${policy}'}"><a href="javascript:void(0);">${'${policy}'}</a></li>`;
				$('#policy ul').append(liStr);
			});
		}).fail(function (error) {
			console.log(error);
		});
	}

	/**
	 * 기기인증서 신청(기기등록)
	 */
	const register = (data) => {
		const certType = $('#certType > button').data('value');
		const policy = $('#policy > button').data('value');
		const manuName = $('#manuName').val();
		const modelName = $('#modelName').val();
		let certDeviceArray = new Array();
		const deviceRow = document.querySelectorAll('tr.device input[name="macAdd"]');

		if (isEmpty(data)) {
			deviceRow.forEach(device => {
				const idxNum = device.id.replace(/[^0-9]/g, '');
				const serialNum = document.getElementById('serialNum' + idxNum).value;
				certDeviceArray.push({
					macAdd: device.value,
					serialNum: serialNum
				});
			});
		} else {
			certDeviceArray = data;
		}

		let option = {
			url : certApiHost + '/deviceReg/request',
			type : 'POST',
			contentType: 'application/x-www-form-urlencoded',
			crossOrigin: true,
			data: {
				REQUEST: JSON.stringify({
					certPolicy: policy,
					manuName: manuName,
					modelName: modelName,
					devices: certDeviceArray,
					managerID: loginId
				}),
			}
		}

		$.ajax(option).done(function (result) {
			alert('등록 되었습니다.');
			location.href = '/device/certManageList.do';
		}).fail(function (error) {
			console.log(error);
		});
	};

	const sampleDownload = () => {
		let f = document.form1;
		f.action = certApiHost + '/downloadExcelFile';
		f.submit();
	};

	// 기기등록 Excel 업로드
	function doExcelUploadProcess(){
		const f = new FormData(document.getElementById('form1'));
		$.ajax({
			url: certApiHost + '/uploadExcelFile',
			data: f,
			processData: false,
			contentType: false,
			type: 'POST',
			success: function(data){
				if (!isEmpty(data)) {
					register(data);
				}
			}
		})
	}

	const makeDeivceRow = () => {
		const rowCount = $('#row').val();
		const data = $('#policy > button').data('value');
		let disp = '';
		if (!isEmpty(rowCount) && rowCount > 0) {
			if (data == 'P)KPXSVR') {
				disp = 'hidden';
			}
			for(let i = 0; i < rowCount; i++) {
				let trStr = `<tr class="device">
								<th><h2 class="tx_tit">기기 MAC</h2></th>
								<td>
									<div class="tx_inp_type edit">
										<input type="text" id="macAdd${'${i}'}" name="macAdd" placeholder="기기 MAC 입력">
									</div>
								</td>
								<th class="${'${disp}'}"><h2 class="tx_tit">시리얼번호</h2></th>
								<td class="${'${disp}'}">
									<div class="tx_inp_type edit">
										<input type="text" id="serialNum${'${i}'}" name="serialNum" placeholder="시리얼번호">
									</div>
								</td>
							</tr>`;
				$('#manual > table > tbody').append(trStr);
			}
		} else {
			errorMsg('입력하실 기기 수량을 입력해 주세요.');
			return false;
		}
	}

	//후처리
	const rtnDropdown = ($dropdownId) => {
		if ($dropdownId == 'policy') {
			const data = $('#' + $dropdownId + ' > button').data('value');
			const deviceList = document.querySelectorAll('.device');

			if (!isEmpty(deviceList) && deviceList.length > 0) {
				if (data == 'P)KPXSVR') {
					deviceList.forEach(device => {
						device.querySelector('th:nth-of-type(2)').className = 'hidden';
						device.querySelector('td:nth-of-type(2)').className = 'hidden';
						device.querySelector('td:nth-of-type(2) input').value = '';
					});
				} else {
					deviceList.forEach(device => {
						const check = new RegExp('(\\s|^)' + 'hidden' + '(\\s|$)');
						device.querySelector('th:nth-of-type(2)').className = check;
						device.querySelector('td:nth-of-type(2)').className = check;
					});
				}
			}
		}
	}

	/**
	 * 에러 처리
	 *
	 * @param msg
	 */
	const errorMsg = msg => {
		$("#warningMsg").text(msg);
		$("#warningModal").modal("show");
		setTimeout(function(){
			$("#warningModal").modal("hide");
		}, 1800);
	}
</script>
<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content collection_modal_content">
			<div class="modal-body">
				<h2 id="warningMsg" class="warning"></h2>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">기기인증서 신청</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<form id="form1" name="form1" method="get" enctype="multipart/form-data">
			<div class="indiv">
				<div class="flex_wrapper mb-20 mt30">
					<h2 class="ntit">인증서 정보 입력</h2>
				</div>
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:5%">
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
							<col/>
						</colgroup>
						<tbody>
						<tr>
							<th><h2 class="tx_tit">기기인증서 발급 정책</h2></th>
							<td>
								<div class="sa_select">
									<div class="dropdown" id="policy">
										<button type="button" class="dropdown-toggle w5" data-toggle="dropdown" data-value="">
											선택 <span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu"></ul>
									</div>
								</div>
							</td>
							<th></th>
							<td>
							</td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제조사명</h2></th>
							<td>
								<div class="tx_inp_type edit">
									<label for="manuName" class="sr-only">제조사명</label>
									<input type="text" id="manuName" name="manuName" placeholder="제조사명 입력">
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제품모델명 입력</h2></th>
							<td>
								<div class="tx_inp_type edit">
									<label for="modelName" class="sr-only">제품모델명 입력</label>
									<input type="text" id="modelName" name="modelName" placeholder="제품모델명 입력">
								</div>
							</td>
							<th></th>
							<td></td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="flex_wrapper mb-20 mt30">
					<h2 class="ntit">기기 정보 입력</h2>
				</div>
				<div class="tbl_wrap_type collect_wrap">
					<ul class="nav nav-tabs">
						<li class="nav-item active">
							<a class="nav-link" data-toggle="tab" href="#manual">기기정보 수동 입력</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" data-toggle="tab" href="#excel">기기정보 Excel 입력</a>
						</li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane fade active in spc_tbl_row st_edit panel-collapse collapse" id="manual">
							<table class="mt30">
								<colgroup>
									<col style="width:15%">
									<col style="width:35%">
									<col style="width:15%">
									<col style="width:35%">
								</colgroup>
								<tbody>
								<tr>
									<th><h2 class="tx_tit">수량</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="row" name="row" placeholder="수량 입력">
										</div>
									</td>
									<td colspan="2"><button type="button" class="btn_type big" onclick="makeDeivceRow();">수량 입력</button></td>
								</tr>
								</tbody>
							</table>
						</div>
						<div class="tab-pane fade spc_tbl_row st_edit panel-collapse collapse" id="excel">
							<table class="mt30">
								<colgroup>
									<col style="width:15%">
									<col style="width:35%">
									<col style="width:15%">
									<col style="width:35%">
								</colgroup>
								<tbody>
								<th><h2 class="tx_tit">기기정보 EXCEL</h2></th>
								<td>
									<input type="file" id="file1" class="hidden" name="file1" accept=".xls, .xlsx">
									<label for="file1" class="btn file_upload">파일 선택</label>
									<span class="upload_text ml-16"></span>
									<button type="button" class="btn_close fixed_height hidden mt-0" onclick="$(this).parents().closest('.group_type').remove()"></button>
								</td>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="btn_wrap_type_right">
					<button type="button" class="btn_type03 big" onclick="sampleDownload();">샘플 다운로드</button>
					<button type="button" class="btn_type big" onclick="register();">신청</button>
				</div>
			</div>
		</form>
	</div>
</div>