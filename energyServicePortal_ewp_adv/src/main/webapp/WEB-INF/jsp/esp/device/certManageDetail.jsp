<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	const apply_PKG_ID = '${param.apply_PKG_ID}';
	let table = null;

	$(function () {
		table = $('#deviceTable').DataTable({
			'table-layout': 'fixed',
			'bAutoWidth': true,
			'bSearchable': true,
			'sScrollX': '100%',
			'sScrollXInner': '100%',
			'sScrollY': false,
			'bScrollCollapse': true,
			'aaSorting': [[1, 'desc']],
			'paging': true,
			'serverSide': true,
			'processing': true,
			'ajax': {
				type: 'GET',
				url: certApiHost + '/certDetail/all',
				data: function(d) {
					let param = new Object();
					param.cpage = (d.start / 10) + 1;
					param.applyPkgID = apply_PKG_ID;
					param.targetColumn = (d.columns[d.order[0].column].data).toUpperCase();
					param.orderType = (d.order[0].dir).toUpperCase();
					return param;
				},
				contentType: 'application/x-www-form-urlencoded',
				dataFilter: function (json) {
					json = JSON.parse(json);
					let rtnData = new Object();
					rtnData.recordsTotal = json.paging.totalCount;
					rtnData.recordsFiltered = json.paging.totalCount;
					rtnData.data = json.deviceList;

					json.certCntList.forEach(cert => {
						if (cert.STATUS === '등록') {
							$('#등록').text(cert.CNT + ' 건');
						} else if (cert.STATUS === '폐기') {
							$('#폐기').text(cert.CNT + ' 건');
						}
					});

					$('#CERT_POLICY_VALID').text((json.deviceInfo[0].CERT_POLICY_VALID / 12) + ' 년');
					$('#CERT_POLICY_ID').text(json.deviceInfo[0].CERT_POLICY_ID);
					$('#CREATE_DATE').text(new Date(json.deviceInfo[0].CREATE_DATE).format('yyyy-MM-dd HH:mm:ss'));
					$('#PKG_MANUFACTURE_NAME').text(json.deviceInfo[0].PKG_MANUFACTURE_NAME);
					$('#PKG_MODEL_NAME').text(json.deviceInfo[0].PKG_MODEL_NAME);
					return JSON.stringify(rtnData); // return JSON string
				}
			},
			'aoColumns': [
				{
					sTitle: '',
					mData: null,
					mRender: function ( data, type, full, rowIndex ) {
						let check = '<input type="checkbox" id="check' + rowIndex.row + '" name="table_checkbox"><label for="check' + rowIndex.row + '"></label>';

						if (data.status == '폐기') {
							return null
						} else {
							return check
						}
					},
					className: 'dt-center no-sorting'
				},
				{
					sTitle: '순번',
					mData: 'num',
					className: 'dt-center',
					orderable: false,
				},
				{
					sTitle: 'MAC 주소',
					mData: 'device_MAC_ADDRESS'
				},
				{
					sTitle: '시리얼번호\n(SN)',
					mData: 'device_SERIAL_NO'
				},
				{
					sTitle: '상태\n변경일',
					mData: 'update_DATE'
				},
				{
					sTitle: '상태',
					mData: 'status',
					orderable: false
				},
				{
					sTitle: 'apply_ID',
					mData: 'apply_ID',
					bSortable: false,
					orderable: false,
					bVisible: false
				}
			],
			dom: 'tip',
			select: {
				style: 'multi',
				selector: 'td:first-child > :checkbox'
			},
		}).columns.adjust();
	});

	//기기 인증서 상세 조회
	const goList = () => {
		let form = $('#form1');
		form.find('[name="apply_PKG_ID"]').val('');
		form.find('[name="mode"]').val('');
		form.attr('action', '/device/certManageList.do').submit();
	}

	const downloadCert = () => {
		location.href = certApiHost + '/downCert?applyPkgID=' + apply_PKG_ID;
	}

	const goProc = (mode, modeName) => {
		const deviceTable = $('#deviceTable').DataTable();
		let data = new Object();
		let deviceArray = new Array();

		data.applyPkgID = apply_PKG_ID;

		if (deviceTable.rows('.selected')[0].length > 0) {
			let process = true;
			deviceTable.rows('.selected')[0].forEach(device => {
				const status = deviceTable.rows(device).data()[0].status;

				if ((mode === 'issue' && status == '발급 가능') || (mode === 'revoke' && status == '폐기 가능') || (mode === 'revoke' && status == '발급')) {
					deviceArray.push(deviceTable.rows(device).data()[0].apply_ID);
				} else {
					process = false;
				}
			});

			if (!process) {
				alert('처리가 불가능한 항목이 체크되어있습니다. 다시 확인 부탁드립니다.');
				return false;
			}

			data.devices = deviceArray;

			let option = {
				url : certApiHost + '/deviceCert/' + mode,
				type : 'PUT',
				contentType: 'application/json',
				crossOrigin: true,
				dataType: 'json',
				data: JSON.stringify(data)
			}
			$.ajax(option).done(function (result) {
				alert(modeName + '처리가 완료되었습니다.');
				table.ajax.reload();
				return false;
			}).fail(function (error) {
				console.log(error);
			});
		} else {
			alert('선택된 항목이 존재하지 않습니다.');
			return false;
		}
	}
</script>

<form id="form1" name="form1" method="post">
	<input type="hidden" name="apply_PKG_ID" value="">
	<input type="hidden" name="mode" value="">
</form>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">상세 조회</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<form>
			<div class="indiv">
				<div class="certType">
					<div class="spc_tbl_row st_edit">
						<table>
							<colgroup>
								<col style="width:15%">
								<col style="width:35%">
								<col style="width:15%">
								<col style="width:35%">
								<col/>
							</colgroup>
							<tbody>
							<tr>
								<th><h2 class="tx_tit">신청일</h2></th>
								<td id="CREATE_DATE">
								</td>
								<th><h2 class="tx_tit">기기등록</h2></th>
								<td id="등록">
								</td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">유효기간</h2></th>
								<td id="CERT_POLICY_VALID">
								</td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">발급정책</h2></th>
								<td id="CERT_POLICY_ID"></td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">제조사명</h2></th>
								<td id="PKG_MANUFACTURE_NAME"></td>
								<th><h2 class="tx_tit">폐기</h2></th>
								<td id="폐기"></td>
							</tr>
							<tr>
								<th><h2 class="tx_tit">제품모델명</h2></th>
								<td id="PKG_MODEL_NAME"></td>
								<th></th>
								<td></td>
							</tr>
							</tbody>
						</table>
					</div>
					<div class="flex_wrapper mb-20 mt30">
						<h2 class="ntit">기기인증서 리스트</h2>
					</div>
					<div class="spc_tbl align_type">
						<table class="chk_type" id="deviceTable">
							<colgroup>
								<col style="width:15%">
								<col style="width:25%">
								<col style="width:15%">
								<col style="width:25%">
								<col/>
							</colgroup>
							<thead>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div class="btn_wrap_type_right">
		<button type="button" class="btn_type03" onclick="downloadCert();">인증서 다운로드</button>
		<button type="button" class="btn_type03" onclick="goProc('issue', '발급');">발급</button>
<%--		<button type="button" class="btn_type03" onclick="goProc('reIssue');">갱신</button>--%>
		<button type="button" class="btn_type03" onclick="goProc('revoke', '폐기');">폐기</button>
		<button type="button" class="btn_type03" onclick="goList();">목록</button>
	</div>
</div>