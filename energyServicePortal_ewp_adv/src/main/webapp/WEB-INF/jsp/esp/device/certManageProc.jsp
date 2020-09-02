<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	const certApiHost = '${sessionScope.certApiHost}';
	const apply_PKG_ID = '${param.apply_PKG_ID}';
	const mode = '${param.mode}'
	let table = null;

	<c:choose>
		<c:when test="${param.mode eq 'issue'}">
	const modeName = '발급';
		</c:when>
		<c:when test="${param.mode eq 'reIssue'}">
	const modeName = '갱신';
		</c:when>
		<c:otherwise>
	const modeName = '폐지';
		</c:otherwise>
	</c:choose>

	$(function () {
		table = $('#deviceTable').DataTable({
			'table-layout': 'fixed',
			'bAutoWidth': true,
			'bSearchable': true,
			'sScrollX': '100%',
			'sScrollXInner': '100%',
			'sScrollY': false,
			'bScrollCollapse': true,
			'aaSorting': [[1, 'asc']],
			'paging': true,
			'serverSide': true,
			'processing': true,
			'ajax': {
				type: 'GET',
				url: certApiHost + '/certDetail/' + mode,
				data: function(d) {
					let param = new Object();
					param.cpage = (d.start / 10) + 1;
					param.applyPkgID = apply_PKG_ID;
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
						} else if (cert.STATUS === '폐지') {
							$('#폐지').text(cert.CNT + ' 건');
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

						if (data.status.match('가능')) {
							return check;
						} else {
							return '';
						}
					},
					className: 'dt-center no-sorting'
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
					mData: 'status'
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

	const goProc = () => {
		const deviceTable = $('#deviceTable').DataTable();
		let data = new Object();
		let deviceArray = new Array();

		data.applyPkgID = apply_PKG_ID;

		if (deviceTable.rows('.selected')[0].length > 0) {
			deviceTable.rows('.selected')[0].forEach(device => {
				deviceArray.push(deviceTable.rows(device).data()[0].apply_ID);
			});
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
				table.ajax().reload();
				return false;
			}).fail(function (error) {
				console.log(error);
			});
		} else {

		}
	}

	//기기 인증서 상세 조회
	const goList = () => {
		let form = $('#form1');
		form.find('[name="apply_PKG_ID"]').val('');
		form.attr('action', '/device/certManageList.do').submit();
	}

	const downloadCert = () => {
		location.href = certApiHost + '/downCert?applyPkgID=' + apply_PKG_ID;
	}
</script>

<form id="form1" name="form1" method="post">
	<input type="hidden" name="apply_PKG_ID" value="">
	<input type="hidden" name="mode" value="">
</form>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">기기인증서 신청(
			<c:choose>
				<c:when test="${param.mode eq 'issue'}">
					발급
				</c:when>
				<c:when test="${param.mode eq 'reIssue'}">
					갱신
				</c:when>
				<c:otherwise>
					폐지
				</c:otherwise>
			</c:choose>
			)</h1>
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
								<td id="폐지"></td>
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
		<button type="button" class="btn_type" onclick="goProc();">
		<c:choose>
			<c:when test="${param.mode eq 'issue'}">
				발급
			</c:when>
			<c:when test="${param.mode eq 'reIssue'}">
				갱신
			</c:when>
			<c:otherwise>
				폐지
			</c:otherwise>
		</c:choose>
		</button>
		<c:if test="${param.mode eq 'issue' or param.mode eq 'reIssue'}">
		<button type="button" class="btn_type" onclick="downloadCert();">인증서 다운로드</button>
		</c:if>
		<button type="button" class="btn_type03" onclick="goList();">목록</button>
	</div>
</div>