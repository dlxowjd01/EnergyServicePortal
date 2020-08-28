<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	let deviceTemplate = new Object();
	let almMsgList = new Array();

	$(function () {
		deviceProperties();
		alermList();
	});

	<!-- 알람 코드 조회 -->
	const alermList = async ()  => {
		$.ajax({
			url: apiHost + '/alarms/code_sets',
			type: 'get',
			data : {
				includeCodes: true
			},
			success: function (result) {
				almMsgList = result.data;
			},
			error: function(result, status, error) {
				console.log(error);
			}
		});
	}

	<!-- properties 조회 -->
	const deviceProperties = async () => {
		$.ajax({
			url: apiHost + '/config/view/device_properties',
			type: 'get',
			async: false,
			data: {},
			success: function (result) {
				Object.entries(result).map(obj => {
					deviceTemplate[obj[0]] = obj[1].name.kr;
				});

				deviceType();
			},
			dataType: 'json'
		});
	};

	// 설비타입 세팅
	const deviceType = () => {
		let liStr = ``;
		let target = $('#deviceType ul');

		target.empty();
		Object.entries(deviceTemplate).map(obj => {
			liStr = `<li>
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" name="deviceType" id="deviceType_${'${obj[0]}'}" value="${'${obj[0]}'}">
							<label for="deviceType_${'${obj[0]}'}">${'${obj[1]}'}</label>
						</a>
					</li>`;
			target.append(liStr);
		});
	};

	<!-- 드롭다운 선택 -->
	const rtnDropdown = ($selector) => {
		if ($selector == 'deviceType') {
			let typeArray = new Array();
			let manufArray = new Array();
			document.querySelectorAll('[name="deviceType"]:checked').forEach(el => {
				typeArray.push(el.value);
			});

			$('#manufacturer ul').empty();
			if (!isEmpty(almMsgList)) {
				almMsgList.forEach(almMsg => {
					const deviceType = almMsg.device_type;
					const manufacturer = almMsg.manufacturer;
					if (typeArray.includes(deviceType)) {
						if (!manufArray.includes(manufacturer)) {
							manufArray.push(manufacturer);
							let liStr = `<li>
											<a href="javascript:void(0);" tabindex="-1">
												<input type="checkbox" name="manuf" id="manuf_${'${manufacturer}'}" value="${'${manufacturer}'}">
												<label for="manuf_${'${manufacturer}'}">${'${manufacturer}'}</label>
											</a>
										</li>`;

							$('#manufacturer ul').append(liStr);
						}
					}
				});
			}
		} else if($selector == 'manufacturer') {
			let typeArray = new Array();
			let manufArray = new Array();
			let modelArray = new Array();

			$('#model ul').empty();
			document.querySelectorAll('[name="deviceType"]:checked').forEach(el => {
				typeArray.push(el.value);
			});

			document.querySelectorAll('[name="manuf"]:checked').forEach(el => {
				manufArray.push(el.value);
			});

			if (!isEmpty(almMsgList)) {
				almMsgList.forEach(almMsg => {
					const deviceType = almMsg.device_type;
					const manufacturer = almMsg.manufacturer;
					const model = almMsg.model;
					if (typeArray.includes(deviceType)) {
						if (manufArray.includes(manufacturer)) {
							if (!modelArray.includes(model)) {
								modelArray.push(model);

								let liStr = `<li data-value="${'${model}'}">
												<a href="javascript:void(0);">
													${'${model}'}
												</a>
											</li>`;

								$('#model ul').append(liStr);
							}
						}
					}
				});
			}
		}
	}

	// 알람메세지목록 조회
	const schAlarmList = function (skip) {

		/* validation check */
		if ($(':checkbox[name="deviceType"]:checked').length == 0) {
			alert('설비타입을 한개이상 선택해 주세요.');
			return false;
		}

		if ($(':checkbox[name="manuf"]:checked').length == 0) {
			alert('제조사를 한개이상 선택해 주세요.');
			return false;
		}
		/* validation check */

		const _skip = (isEmpty(skip)) ? 0 : skip;
		const limit = 5;

		$.ajax({
			url: apiHost + '/alarms/code_sets',
			type: 'get',
			data : {
				includeCodes: true
			},
			success: function (result) {
				almMsgList = result.data;

				let newArr = new Array();
				let typeArray = new Array();
				let manufArray = new Array();
				document.querySelectorAll('[name="deviceType"]:checked').forEach(el => {
					typeArray.push(el.value);
				});

				document.querySelectorAll('[name="manuf"]:checked').forEach(el => {
					manufArray.push(el.value);
				});

				let model = $('#model button').data('value');

				Promise.all(almMsgList.map((x, index) => {
					let type = x.device_type;
					let manufacturer = x.manufacturer;
					if (typeArray.includes(type) && manufArray.includes(manufacturer) && model == x.model) {
						let alarmCodeSet = x.device_type + '_' + x.manufacturer + '_' + x.model + '_' + x.version;
						newArr.push({
							ALRAM_CODE_SET: alarmCodeSet,
							DEVICE_TYPE: type,
							MANUFACTURER: manufacturer,
							MODEL: x.model,
							VERSION: x.version,
							SET_ID: x.set_id
						});
					}
				})).then(result => {
					let alramTable = $('#alramTable').DataTable({
						destroy: true,
						'aaData': newArr,
						'table-layout': 'fixed',
						// "autoWidth": true,
						'bAutoWidth': true,
						'bSearchable' : true,
						'sScrollX': '100%',
						'sScrollXInner': '100%',
						'sScrollY': false,
						'bScrollCollapse': true,
						// "bFilter": false, disabling this option will prevent table.search()
						'aaSorting': [[ 0, 'asc' ]],
						'aoColumns': [
							{
								'sTitle': '순번',
								'mData': null,
								'className': 'dt-center idx no-sorting'
							},
							{
								'sTitle': '알람 코드 셋',
								'mData': 'ALRAM_CODE_SET',
							},
							{
								'sTitle': '설비타입',
								'mData': 'DEVICE_TYPE',
							},
							{
								'sTitle': '제조사',
								'mData': 'MANUFACTURER',
							},
							{
								'sTitle': '추가 정보',
								'mData': 'MODEL',
							},
							{
								'sTitle': '펌웨어 버전',
								'mData': 'VERSION',
							},
							{
								'sTitle': 'ID',
								'mData': 'SET_ID',
							},
						],
						'aoColumnDefs': [
							{
								'aTargets': [ 6 ],
								'bSortable': false,
								'orderable': false,
								'bVisible': false
							}
						],
						"dom": 'tip',
						"select": {
							style: 'single',
							items: 'row'
						},
						initComplete: function(){
							this.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
								cell.innerHTML = i + 1;
								$(cell).data("id", i);
							});
						},
						createdRow: function (row, data, dataIndex){
							// console.log("row===", row);
							$(row).attr({
								'data-sid': data.sid,
							});
						},
						drawCallback: function () {
							selectRow(this);
							$('#siteTable_wrapper').addClass('mb-28');
						},
					});
				})
			},
			error: function(result, status, error) {
				console.error(error);
			}
		});
	};

	const selectRow = (dataTable) => {
		if ($(this).hasClass('selected')) {
			$(this).removeClass('selected');
		} else {
			dataTable.$('tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}
	};
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">알람 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="flex_group">
			<span class="tx_tit">설비 타입</span>
			<div class="dropdown" id="deviceType">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택 <span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk_type" role="menu"></ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">제조사</span>
			<div class="dropdown" id="manufacturer">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택 <span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk_type" role="menu"></ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">모델명</span>
			<div class="dropdown" id="model">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택<span class="caret"></span>
				</button>
				<ul class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex_group">
			<span class="tx_tit">펌웨어 버전</span>
			<div class="flex_start">
				<div class="tx_inp_type">
					<input type="text" id="schVersion" name="schVersion" placeholder="입력">
				</div>
				<button type="button" class="btn_type ml-16" onclick="schAlarmList();">검색</button>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<div class="flex_group">
				<div class="dropdown">
					<button type="button" class="dropdown-toggle" data-toggle="dropdown">선택<span class="caret"></span></button>
					<ul class="dropdown-menu" id="pageLengthList">
						<li data-value=""><a href="javascript:void(0);" tabindex="-1">전체</a></li>
						<li data-value="10"><a href="javascript:void(0);" tabindex="-1">10</a></li>
						<li data-value="30"><a href="javascript:void(0);" tabindex="-1">30</a></li>
						<li data-value="50"><a href="javascript:void(0);" tabindex="-1">50</a></li>
					</ul>
				</div>
				<span class="tx_tit pl-16">개 씩 보기&ensp;</span>
			</div>
			<button type="button" class="btn_type fr mb-20" onclick="updateModal('all')">삭제</button>
			<button type="button" class="btn_type fr mb-20 mr-8" onclick="updateModal('all')">수정</button>
			<button type="button" class="btn_type fr mb-20" onclick="updateModal('all')">추가</button>

			<table id="alramTable">
				<colgroup>
					<col style="width:10%">
					<col style="width:35%">
					<col style="width:15%">
					<col style="width:15%">
					<col style="width:15%">
					<col style="width:15%">
				</colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>

<div class="modal fade" id="addSiteModal" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="setting-modal-content modal-content">
			<div class="modal-header"><h1>사업소 추가</h1></div>
			<div class="modal-body">
			</div>
		</div>
	</div>
</div>
