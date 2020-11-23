<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let table = null;
	$(function() {
		table = $('#certTable').DataTable({
			destroy: true,
			'aaData': null,
			'table-layout': 'fixed',
			// "autoWidth": true,
			'bAutoWidth': true,
			'bSearchable' : true,
			'sScrollX': '100%',
			'sScrollXInner': '100%',
			'sScrollY': false,
			'bScrollCollapse': true,
			'aaSorting': [[ 1, 'desc' ]],
			'paging': true,
			'serverSide': true,
			'processing': true,
			'ajax': {
				type: 'GET',
				url: certApiHost + '/searchList',
				data: function(d) {
					let param = new Object();
					param.cpage = (d.start / 10) + 1;
					param.dateFrom = $('#write_date_from').val();
					param.dateTo = $('#write_date_to').val();
					param.deviceSearchType = $('#deviceSearchType button').data('value');
					param.deviceSearchText = $('#deviceSearchText').val();
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
					rtnData.data = json.certList;
					return JSON.stringify(rtnData); // return JSON string
				}
			},
			'aoColumns': [
				{
					sTitle: '순번',
					mData: 'num',
					className: 'dt-center',
					orderable: false
				},
				{
					sTitle: '신청일',
					mData: 'create_DATE',
					render: function ( data, type, full, rowIndex ) {
						const cDate = new Date(data);
						return cDate === 'Invalid Date' ? '' : cDate.format('yyyy-MM-dd HH:mm:ss');
					}
				},
				{
					sTitle: '제품모델명',
					mData: 'pkg_MODEL_NAME'
				},
				{
					sTitle: '기기수량',
					mData: 'device_CNT',
					orderable: false
				},
				{
					sTitle: '담당자명',
					mData: 'approval_MANAGER_ID'
				},
				{
					sTitle: '상태',
					mData: null,
					render: function ( data, type, full, rowIndex ) {
						return `발급 : ${'${data.issue_CNT}'}<br>폐기 : ${'${data.revoke_CNT}'}`
					},
					orderable: false
				},
				{
					sTitle: '보기',
					mData: null,
					render: function ( data, type, full, rowIndex ) {
						return `<button type="button" class="btn-type" onclick="goDetail('${'${data.apply_PKG_ID}'}')">상세</button>`
					},
					orderable: false
				},
				{
					sTitle: 'apply_PKG_ID',
					mData: 'apply_PKG_ID',
					bSortable: false,
					orderable: false,
					bVisible: false
				},
			],
			dom: 'tip',
			"language": {
				"paginate": {
					"previous": "",
					"next": "",
				},
				"info": "_PAGE_ - _PAGES_ " + " / 총 _PAGES_ 개",
				"select": {
					"rows": {
						_: "",
						1: ""
					}
				}
			},
		}).columns.adjust();
	});

	const goSearch = () => {
		table.ajax.reload();
	}

	//기기 인증서 상세 조회
	const goDetail = (pkgId) => {
		let form = $('#form1');
		form.find('[name="apply_PKG_ID"]').val(pkgId);
		form.attr('action', '/device/certManageDetail.do').submit();
	}
</script>

<form id="form1" name="form1" method="post">
	<input type="hidden" name="apply_PKG_ID" value="">
</form>
<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">기기인증서 관리</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12 clear input-align">
		<div class="fl">
			<span class="tx-tit">신청 기간</span>
			<div class="sel-calendar">
				<input type="text" id="write_date_from" class="sel fromDate" value="" autocomplete="off">
				<input type="text" id="write_date_to" class="sel toDate" value="" autocomplete="off">
			</div>
		</div>
		<div class="fl">
			<span class="tx-tit">기기 고유정보</span>
			<div class="sa-select">
				<div class="dropdown" id="deviceSearchType">
					<button type="button" class="dropdown-toggle w5" data-toggle="dropdown" data-value="">
						선택 <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li data-value="1">
							<a href="javascript:void(0);">MAC 주소</a>
						</li>
						<li data-value="2">
							<a href="javascript:void(0);">SERIAL 번호</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<div class="text-input-type">
				<input type="text" id="deviceSearchText" name="deviceSearchText" placeholder="입력">
			</div>
		</div>
		<div class="fl">
			<button type="button" class="btn-type" onclick="goSearch();">검색</button>
		</div>
	</div>
</div>
<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="certTable">
				<colgroup>
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:20%">
					<col style="width:15%">
					<col style="width:20%">
					<col style="width:15%">
					<col>
				</colgroup>
				<thead>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>