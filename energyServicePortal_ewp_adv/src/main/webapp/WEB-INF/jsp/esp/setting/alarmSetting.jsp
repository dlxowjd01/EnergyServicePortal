<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	let deviceTemplate = new Object();
	let alarmLevel = new Array();
	let almMsgList = new Array();

	$(function () {
		properties();
		alermList();

		// 엑셀 업로드 버튼
		$('#excelUploadBtn').on('change', function(evt) {
			const reader = new FileReader();
			reader.onload = function(e){
				if (reader.result)
					reader.content = reader.result;

				//In IE browser event object is null
				const data = e ? e.target.result : reader.content;
				const baseEncoded = btoa(data);
				const wb = XLSX.read(baseEncoded, {type: 'base64'});

				processWorkbook(wb);
			};
			reader.onerror = function(ex){
				console.log(ex);
			};
			reader.readAsBinaryString(evt.target.files[0]);
		});

		var alarmTable = $('#alarmTable').DataTable({
			destroy: true,
			'table-layout': 'fixed',
			"fixedHeader": true,
			// "autoWidth": true,
			'bAutoWidth': true,
			'bSearchable' : true,
			"scrollX": true,
			"sScrollXInner": "100%",
			"sScrollY": true,
			"scrollY": "720px",
			"pageLength": 100,
			// 'sScrollY': false,
			'bScrollCollapse': true,
			'aaSorting': [[ 1, 'asc' ]],
			// 'paging': false,
			'aoColumns': [
				{
					sTitle: '',
					mData: null,
					mRender: function ( data, type, full, rowIndex ) {
						return '<input type="checkbox" id="check' + rowIndex.row + '" name="table_checkbox" data-setid="' + data.SET_ID + '" data-code="' + data.CODE + '"><label for="check' + rowIndex.row + '"></label>';
					},
					className: 'dt-center no-sorting'
				},
				{
					sTitle: '순번',
					mData: null,
					mRender: function ( data, type, full, rowIndex ) {
						return rowIndex.row + 1;
					},
					className: 'dt-center no-sorting'
				},
				{
					sTitle: '설비타입',
					mData: 'DEVICE_TYPE'
				},
				{
					sTitle: '제조사',
					mData: 'MANUFACTURER'
				},
				{
					sTitle: '모델명',
					mData: 'MODEL'
				},
				{
					sTitle: '펌웨어 버전',
					mData: 'VERSION'
				},
				{
					sTitle: '에러 코드',
					mData: 'CODE'
				},
				{
					sTitle: '메세지',
					mData: 'MESSAGE'
				},
				{
					sTitle: '알람 레벨',
					mData: 'LEVEL',
					mRender: function ( data ) {
						return alarmLevel[data];
					}
				},
				{
					sTitle: '추가 정보',
					mData: 'DESCRIPTION'
				},
				{
					sTitle: 'LEVEL',
					mData: 'LEVEL',
					bSortable: false,
					orderable: false,
					bVisible: false
				},
				{
					sTitle: 'ID',
					mData: 'SET_ID',
					bSortable: false,
					orderable: false,
					bVisible: false
				}
			],
			'dom': 'Btip',
			'buttons':[
				{
					text: '적용',
					className: 'btn-type fr my-offset-28',
					action: function ( e, dt, node, config ) {
						register();
					},
					attr: {
						id: 'regist',
						disabled: true
					}
				},
				{
					extend: 'excel',
					text: '엑셀 내보내기',
					className: 'btn-type03 fr my-offset-28 mr-8',
					exportOptions: {
						columns: [1, 2, 3, 4, 5, 6, 7, 8, 9]
					},
					filename: '알람 메시지 레벨 설정'
				},
				{
					text: '엑셀 업로드',
					className: 'btn-type03 fr my-offset-28',
					action: function ( e, dt, node, config ) {
						document.getElementById('excelUploadBtn').click();
					}
				}
			],
			select: {
				style: 'multi',
				selector: 'td:first-child > :checkbox, tr'
			},
			language: {
				"emptyTable": "조회된 데이터가 없습니다.",
				"zeroRecords":  "검색된 결과가 없습니다."
			},
			initComplete: function(settings, json) {
				let str = `<div id="btnGroup" class="right-end"><!--
							--><button type="button" disabled class="btn-type03" onclick="deleteRow()">선택 삭제</button><!--
						--></div>`;
				$('#alarmTable_wrapper').append($(str));
			},
			drawCallback: function (settings) {
				$('#alarmTable_wrapper').addClass('mb-28');
			}
		}).on('select', function(e, dt, type, indexes) {
			alarmTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
			$('#btnGroup button').attr('disabled', false);
		}).on('deselect', function(e, dt, type, indexes) {
			alarmTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);

			const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
			if (checkedArray.length > 0) {
				$('#btnGroup button').attr('disabled', false);
			} else {
				$('#btnGroup button').attr('disabled', true);
			}
		}).columns.adjust().draw();

		$("#comDeleteBtn").click(function(){
			$("#comDeleteModal").modal('hide');
			$("#confirmTitle").val('');

			const alarmTable = $('#alarmTable').DataTable();
			const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
			const urls = new Array();
			const deferreds = new Array();
			const deferreds2 = new Array();
			const deferreds3 = new Array();

			if ($('#regist').prop('disabled')) { //조회한 데이터 일경우
				checkedArray.forEach(chk => {
					const setId = chk.dataset.setid;
					const code = chk.dataset.code;
					if (!isEmpty(setId) && !isEmpty(code)) {
						urls.push({
							url: apiHost + '/alarms/code_sets/' + setId + '/codes/' + code,
							type: 'delete',
							dataType: 'json',
						});
					}
				});

				//코드 삭제 START
				urls.forEach(function (url) {
					let deferred = $.Deferred();
					deferreds.push(deferred);

					$.ajax(url).done(function (data) {
						data['url'] = url['url'];
						(function (deferred) {
							return deferred.resolve(data);
						})(deferred);
					}).fail(function (error) {
						console.log(error);
					});
				});

				$.when.apply($, deferreds).then(function () {
					let setIdArray = new Array();
					let selectURL = new Array();
					for (let index = 0; index < arguments.length; index++) {
						let data = arguments[index];
						let url = data.url.split('/');
						setIdArray.push(url[url.length - 3]);
					}

					//codeSet 조회
					setIdArray.forEach(setId => {
						selectURL.push({
							url: apiHost + '/alarms/code_sets/' + setId + '/codes',
							type: 'get',
							dataType: 'json'
						});
					});

					selectURL.forEach(function (url) {
						let deferred = $.Deferred();
						deferreds2.push(deferred);

						$.ajax(url).done(function (data) {
							data['url'] = url['url'];
							(function (deferred) {
								return deferred.resolve(data);
							})(deferred);
						}).fail(function (error) {
							console.log(error);
						});
					});

					$.when.apply($, deferreds2).then(function () {
						let deleteURL = new Array();
						setIdArray = new Array();

						for (let index = 0; index < arguments.length; index++) {
							let data = arguments[index];

							if (isEmpty(data.data)) {
								let url = data.url.split('/');
								setIdArray.push(url[url.length - 2]);
							}
						}

						if (isEmpty(setIdArray)) {
							//codeSet 삭제
							setIdArray.forEach(setId => {
								deleteURL.push({
									url: apiHost + '/alarms/code_sets/' + setId,
									type: 'delete',
									dataType: 'json'
								});
							});

							deleteURL.forEach(function (url) {
								let deferred = $.Deferred();
								deferreds3.push(deferred);

								$.ajax(url).done(function (data) {
									data['url'] = url['url'];
									(function (deferred) {
										return deferred.resolve(data);
									})(deferred);
								}).fail(function (error) {
									console.log(error);
								});
							});

							$.when.apply($, deferreds3).then(function () {
								schAlarmList();
								errorMsg('알람 메세지가 삭제 되었습니다.');
								return false;
							});
						} else {
							schAlarmList();
							errorMsg('알람 메세지가 삭제 되었습니다.');
							return false;
						}
					});
				});
			} else { //엑셀 업로드 일경우
				alarmTable.rows('.selected').remove().draw( false );
			}
		});
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
	const properties = async () => {
		const urlDeivceProp = {
			url: apiHost + '/config/view/device_properties',
			type: 'get',
			data: {},
			dataType: 'json'
		};

		const urlAlarmProp = {
			url: apiHost + '/config/view/properties',
			type: 'get',
			data: {types: 'alarm_level'},
			dataType: 'json'
		};

		$.when($.ajax(urlDeivceProp), $.ajax(urlAlarmProp)).done(function (rstDeviceProp, rstAlarmProp) {
			if (rstDeviceProp[1] === 'success') {
				const resultData = rstDeviceProp[0];
				Object.entries(resultData).map(obj => {
					let propName = (langStatus == 'KO') ? obj[1].name.kr : obj[1].name.en;
					deviceTemplate[obj[0]] = propName;
				});
			}

			if (rstAlarmProp[1] === 'success') {
				const resultData = rstAlarmProp[0].alarm_level;
				Object.entries(resultData).map(arm => {
					const data = arm[1];
					let propName = (langStatus == 'KO') ? data.name.kr : data.name.en;
					alarmLevel[data.code] = propName;
				});
			}

			deviceType();
		}).fail(function () {
			console.log('rejected');
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

			dropDownInit($('#manufacturer'));
			dropDownInit($('#model'));
			dropDownInit($('#version'));
		} else if ($selector == 'manufacturer') {
			let typeArray = new Array();
			let manufArray = new Array();
			let modelArray = new Array();
			let versionArray = new Array();

			$('#model ul').empty();
			document.querySelectorAll('[name="deviceType"]:checked').forEach(el => {
				typeArray.push(el.value);
			});

			document.querySelectorAll('[name="manuf"]:checked').forEach(el => {
				manufArray.push(el.value);
			});

			$('#model ul').empty();
			$('#version ul').empty();
			if (!isEmpty(almMsgList)) {
				almMsgList.forEach(almMsg => {
					const deviceType = almMsg.device_type;
					const manufacturer = almMsg.manufacturer;
					const model = almMsg.model;
					const version = almMsg.version;
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

							if (!versionArray.includes(version)) {
								versionArray.push(version);
							}
						}
					}
				});

				versionArray.forEach(version => {
					let liStr = `<li data-value="${'${version}'}">
									<a href="javascript:void(0);">
										${'${version}'}
									</a>
								</li>`;

					$('#version ul').append(liStr);
				});
			}

			dropDownInit($('#model'));
			dropDownInit($('#version'));
		} else if ($selector == 'model') {
			dropDownInit($('#version'));
		}
	}

	// 알람메세지목록 조회
	const schAlarmList = function (skip) {
		$('#regist').prop('disabled', true);
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
				let version = $('#version button').data('value');

				Promise.all(almMsgList.map((x, index) => {
					let type = x.device_type;
					let manufacturer = x.manufacturer;
					if (typeArray.includes(type) && manufArray.includes(manufacturer) && model == x.model && version == x.version) {
						let alarmCodeSet = x.device_type + '_' + x.manufacturer + '_' + x.model + '_' + x.version;
						const codes = x.codes;

						if (!isEmpty(codes)) {
							codes.forEach(cd => {
								newArr.push({
									ALARM_CODE_SET: alarmCodeSet,
									DEVICE_TYPE: type,
									MANUFACTURER: manufacturer,
									MODEL: x.model,
									VERSION: x.version,
									CODE: cd.code,
									LEVEL: cd.level,
									MESSAGE: cd.message,
									DESCRIPTION: cd.description,
									SET_ID: x.set_id
								});
							});
						}
					}
				})).then(result => {
					let alarmTable = $('#alarmTable').DataTable();
					alarmTable.clear();
					alarmTable.rows.add(newArr).draw();
				})
			},
			error: function(result, status, error) {
				console.error(error);
			}
		});
	};

	const processWorkbook = workbook => {
		let excelArray = new Array();
		let sheetLength = workbook.Sheets[workbook.SheetNames]['!ref'].split(":")[1];
		let strDataSet = '';
		const sheetNames = workbook.SheetNames;
		const levelArray = ['0', '1', '2', '3', '4', '9'];
		sheetLength = parseInt(sheetLength.replace(/[^0-9]/g, ""));

		for (let i = 3 ; i < sheetLength + 1; i++) {
			const DEV_TYPE = { v : workbook.Sheets[sheetNames]['B' + i] != undefined ? String(workbook.Sheets[sheetNames]['B' + i].v).trim() : '' };
			const MANUFACTURER = { v : workbook.Sheets[sheetNames]['C' + i] != undefined ? String(workbook.Sheets[sheetNames]['C' + i].v).trim() : '' };
			const MODEL = { v : workbook.Sheets[sheetNames]['D' + i] != undefined ? String(workbook.Sheets[sheetNames]['D' + i].v).trim() : '' };
			const VERSION = { v : workbook.Sheets[sheetNames]['E' + i] != undefined ? String(workbook.Sheets[sheetNames]['E' + i].v).trim() : '' };
			const ALARM_CODE = { v : workbook.Sheets[sheetNames]['F' + i] != undefined ? String(workbook.Sheets[sheetNames]['F' + i].v).trim() : '' };
			const ALARM_MSG = { v : workbook.Sheets[sheetNames]['G' + i] != undefined ? String(workbook.Sheets[sheetNames]['G' + i].v).trim() : '' };
			const LEVEL = { v : workbook.Sheets[sheetNames]['H' + i] != undefined ? workbook.Sheets[sheetNames]['H' + i].v : '' };
			const DESCRIPTION = { v : workbook.Sheets[sheetNames]['I' + i] != undefined ? String(workbook.Sheets[sheetNames]['I' + i].v).trim() : '' };
			const tempDataSet = DEV_TYPE.v + '_' + MANUFACTURER.v + '_' + MODEL.v  + '_' + VERSION.v;
			if (i === 3) {
				strDataSet = tempDataSet;
			} else {
				if (isEmpty(DEV_TYPE.v)) {
					continue;
				} else if (isEmpty(MANUFACTURER.v)) {
					errorMsg('제조사는 필수값입니다.');
					return false;
				} else if (isEmpty(MODEL.v)) {
					errorMsg('모델명은 필수값입니다.');
					return false;
				} else if (isEmpty(VERSION.v)) {
					errorMsg('펌웨어 버전은 필수값입니다.');
					return false;
				} else if (isEmpty(ALARM_CODE.v)) {
					errorMsg('에러 코드는 필수값입니다.');
					return false;
				} else if (isEmpty(ALARM_MSG.v)) {
					errorMsg('메세지는 필수값입니다.');
					return false;
				}

				if (strDataSet !== tempDataSet) {
					errorMsg('엑셀 업로드는 하나의 데이터 셋만 가능합니다.');
					return false;
				}
			}

			if (isEmpty(alarmLevel[LEVEL.v])) {
				errorMsg('레벨은 정의된 코드만 입력가능합니다.');
				return false;
			}

			excelArray.push({
				DEVICE_TYPE: DEV_TYPE.v,
				MANUFACTURER: MANUFACTURER.v,
				MODEL: MODEL.v,
				VERSION: VERSION.v,
				CODE: ALARM_CODE.v,
				MESSAGE: ALARM_MSG.v,
				LEVEL: LEVEL.v,
				DESCRIPTION: DESCRIPTION.v,
				SET_ID: null
			})
		}

		let alarmTable = $('#alarmTable').DataTable();
		alarmTable.clear();
		alarmTable.rows.add(excelArray).draw();

		$('#regist').prop('disabled', false);
	}

	//적용
	const register = () => {
		const alarmTable = $('#alarmTable').DataTable();
		const tableData = alarmTable.rows().data();
		const dataArray = tableData.toArray();
		const firstData = dataArray[0];

		if (isEmpty(firstData.DEVICE_TYPE)) {
			errorMsg('설비타입은 필수값입니다.');
			return false;
		} else if (isEmpty(firstData.MANUFACTURER)) {
			errorMsg('제조사는 필수값입니다.');
			return false;
		} else if (isEmpty(firstData.MODEL)) {
			errorMsg('모델명은 필수값입니다.');
			return false;
		} else if (isEmpty(firstData.VERSION)) {
			errorMsg('펌웨어 버전은 필수값입니다.');
			return false;
		}

		let option = {
			url: apiHost + '/alarms/code_sets',
			type: 'post',
			dataType: 'json',
			contentType: "application/json",
			data: JSON.stringify({
				manufacturer: firstData.MANUFACTURER,
				model: firstData.MODEL,
				version: firstData.VERSION,
				description: '',
				device_type: firstData.DEVICE_TYPE
			})
		}

		$.ajax(option).done(function (json, textStatus, jqXHR) {
			const data = json.data;
			const setId = data[0].set_id;
			let urls = new Array();
			let deferreds = new Array();

			dataArray.forEach(rowData => {
				urls.push({
					url: apiHost + '/alarms/code_sets/' + setId + '/codes',
					type: 'post',
					dataType: 'json',
					contentType: "application/json",
					data: JSON.stringify({
						code: rowData.CODE,
						level: rowData.LEVEL,
						message: rowData.MESSAGE,
						description: rowData.DESCRIPTION,
						code: rowData.CODE
					})
				});
			});

			urls.forEach(function (url) {
				let deferred = $.Deferred();
				deferreds.push(deferred);

				$.ajax(url).done(function (data) {
					data['url'] = url['url'];
					(function (deferred) {
						return deferred.resolve(data);
					})(deferred);
				}).fail(function (error) {
					console.log(error);
				});
			});

			$.when.apply($, deferreds).then(function () {
				alert('등록 되었습니다.');
				alarmTable.clear().draw();

				$('#excelUploadBtn').val('');
				$('#regist').prop('disabled', true);
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			errorMsg('처리 중 오류가 발생했습니다.');
			console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
			return false;
		});
	}

	//항목 삭제
	const deleteRow = () => {
		let tr = $("#alarmTable").find("tbody tr.selected");
		//let alarmMsg = tr.eq(0).find("td:nth-of-type(8)").text();
		let alarmMsg = '삭제';
		let modal = $("#comDeleteModal");
		let deleteBtn = $("#comDeleteBtn");
		let confirmTitle = $("#confirmTitle");

		$("#comDeleteSuccessMsg span").text(alarmMsg);
		modal.find(".modal-body").removeClass("hidden");
		modal.modal("show");

		confirmTitle.on("input keyp", function() {
			if($(this).val() !== alarmMsg) {
				deleteBtn.prop("disabled", true);
				return false
			} else {
				deleteBtn.prop("disabled", false);
			}
		});
	}

	/**
	 * 에러 처리
	 *
	 * @param msg
	 */
	const errorMsg = msg => {
		$('#excelUploadBtn').val('');

		$("#errMsg").text(msg);
		$("#errorModal").modal("show");
		setTimeout(function(){
			$("#errorModal").modal("hide");
		}, 1800);
	}
</script>

<form id="excelForm" name="excelForm" method="post" class="hidden">
	<input type="file" id="excelUploadBtn" class="stand_alone">
</form>

<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-xs">
		<div class="modal-content warning-modal-content">
			<h2 id="warningMsg" class="warning"></h2>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">알람 메시지 레벨 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-12">
		<div class="flex-group">
			<span class="tx-tit">설비 타입</span>
			<div class="dropdown" id="deviceType">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택 <span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk-type" role="menu"></ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="tx-tit">제조사</span>
			<div class="dropdown" id="manufacturer">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택 <span class="caret"></span>
				</button>
				<ul class="dropdown-menu chk-type" role="menu"></ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="tx-tit">모델명</span>
			<div class="dropdown" id="model">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택<span class="caret"></span>
				</button>
				<ul class="dropdown-menu"></ul>
			</div>
		</div>
		<div class="flex-group">
			<span class="tx-tit">펌웨어 버전</span>
			<div class="dropdown" id="version">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택<span class="caret"></span>
				</button>
				<ul class="dropdown-menu"></ul>
			</div>
			<button type="button" class="btn-type ml-16" onclick="schAlarmList();">검색</button>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="alarmTable" class="chk-type">
				<colgroup>
					<col style="width:5%">
					<col style="width:5%">
					<col style="width:8%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:20%">
					<col style="width:10%">
					<col style="width:12%">
				</colgroup>
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
