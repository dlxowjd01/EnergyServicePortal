<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	let deviceTemplate = new Object();
	let almMsgList = new Array();

	$(function () {
		deviceProperties();
		alermList();

		// 엑셀 업로드 버튼
		$('#excelUploadBtn').on('change', function(evt) {
			var reader = new FileReader();
			reader.onload = function(e){
				if (reader.result)
					reader.content = reader.result;

				//In IE browser event object is null
				var data = e ? e.target.result : reader.content;
				var baseEncoded = btoa(data);
				var wb = XLSX.read(baseEncoded, {type: 'base64'});

				processWorkbook(wb);
			};
			reader.onerror = function(ex){
				console.log(ex);
			};
			reader.readAsBinaryString(evt.target.files[0]);
		});

		$('#alarmTable').DataTable({
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
			'aaSorting': [[ 1, 'asc' ]],
			'paging': false,
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
						let levelText = '알수없음';
						switch(data) {
							case 0: levelText = '정보'; break;
							case 1: levelText = '경고'; break;
							case 2: levelText = '이상'; break;
							case 3: levelText = '트립'; break;
							case 4: levelText = '정상'; break;
							default: levelText = '알수없음'; break;
						}
						return levelText;
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
			dom: 'Btip',
			buttons:[
				{
					text: '적용',
					className: 'btn_type fr mb-10',
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
					className: 'btn_type03 fr mb-10 mr-8',
					exportOptions: {
						columns: [1, 2, 3, 4, 5, 6, 7, 8, 9]
					},
					filename: '알람 메시지 레벨 설정'
				},
				{
					text: '엑셀 업로드',
					className: 'btn_type03 fr mb-10',
					action: function ( e, dt, node, config ) {
						document.getElementById('excelUploadBtn').click();
					}
				}
			],
			select: {
				style: 'multi',
				selector: 'td:first-child > :checkbox'
			},
			initComplete: function(settings, json) {
				let str = `<div id="btnGroup" class="right-end"><!--
							--><button type="button" disabled class="btn_type03" onclick="deleteRow()">선택 삭제</button><!--
						--></div>`;
				$('#alarmTable_wrapper').append($(str));
			}
		}).columns.adjust();
	});

	$(document).on('click', '[name="table_checkbox"]', function() {
		if ($('[name="table_checkbox"]:checked').length > 0) {
			$('#btnGroup button').attr('disabled', false);
		} else {
			$('#btnGroup button').attr('disabled', true);
		}
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
		sheetLength = parseInt(sheetLength.replace(/[^0-9]/g, ""));

		for (let i = 3 ; i < sheetLength + 1; i++) {
			const DEV_TYPE = { v : workbook.Sheets[sheetNames]['B' + i] != undefined ? String(workbook.Sheets[sheetNames]['B' + i].v).trim() : '' };
			const MANUFACTURER = { v : workbook.Sheets[sheetNames]['C' + i] != undefined ? String(workbook.Sheets[sheetNames]['C' + i].v).trim() : '' };
			const MODEL = { v : workbook.Sheets[sheetNames]['D' + i] != undefined ? String(workbook.Sheets[sheetNames]['D' + i].v).trim() : '' };
			const VERSION = { v : workbook.Sheets[sheetNames]['E' + i] != undefined ? String(workbook.Sheets[sheetNames]['E' + i].v).trim() : '' };
			const ALARM_CODE = { v : workbook.Sheets[sheetNames]['F' + i] != undefined ? String(workbook.Sheets[sheetNames]['F' + i].v).trim() : '' };
			const ALARM_MSG = { v : workbook.Sheets[sheetNames]['G' + i] != undefined ? String(workbook.Sheets[sheetNames]['G' + i].v).trim() : '' };
			const LEVEL = { v : workbook.Sheets[sheetNames]['H' + i] != undefined ? String(workbook.Sheets[sheetNames]['H' + i].v).trim() : '' };
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

			let levelText = '9';
			if (isNaN(LEVEL.v)) {
				switch(LEVEL.v) {
					case '정보': levelText = 0; break;
					case '경고': levelText = 1; break;
					case '이상': levelText = 2; break;
					case '트립': levelText = 3; break;
					case '정상': levelText = 4; break;
					default: levelText = 9; break;
				}
			}

			excelArray.push({
				DEVICE_TYPE: DEV_TYPE.v,
				MANUFACTURER: MANUFACTURER.v,
				MODEL: MODEL.v,
				VERSION: VERSION.v,
				CODE: ALARM_CODE.v,
				MESSAGE: ALARM_MSG.v,
				LEVEL: levelText,
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
				alarmTable.clear();
			});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			errorMsg('처리 중 오류가 발생했습니다.');
			console.log("jqXHR===", jqXHR, " textStatus==",  textStatus )
			return false;
		});
	}

	//항목 삭제
	const deleteRow = () => {
		const alarmTable = $('#alarmTable').DataTable();
		const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
		let urls = new Array();
		let deferreds = new Array();

		if ($('#regist').prop('disabled')) {
			checkedArray.forEach(chk => {
				const setId = chk.dataset.setid;
				const code = chk.dataset.code;
				urls.push({
					url: apiHost + '/alarms/code_sets/' + setId + '/codes/' + code,
					type: 'delete',
					dataType: 'json',
				});
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
					let deleteURL = new Array();
					for (let index = 0; index < arguments.length; index++) {
						let data = arguments[index];

						if (isEmpty(data.data)) {
							setIdArray = new Array();

							let url = data.url.split('/');
							setIdArray.push(url[url.length - 2]);
						}
					}

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
						alert('삭제가 완료되었습니다.');

						schAlarmList();
						return false;
					});
				});
			});
		} else {
			alarmTable.rows('.selected').remove().draw( false );
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

<form id="excelForm" name="excelForm" method="post" class="hidden">
	<input type="file" id="excelUploadBtn" class="stand_alone">
</form>

<div class="modal fade" id="warningModal" role="dialog" aria-labelledby="warningModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-sm">
		<div class="modal-content collection_modal_content">
			<div class="modal-body">
				<h2 id="warningMsg" class="warning"></h2>
			</div>
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
			<div class="dropdown" id="version">
				<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">
					선택<span class="caret"></span>
				</button>
				<ul class="dropdown-menu"></ul>
			</div>
			<button type="button" class="btn_type ml-16" onclick="schAlarmList();">검색</button>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="alarmTable" class="chk_type">
				<colgroup>
					<col style="width:5%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:17%">
					<col style="width:10%">
					<col style="width:20%">
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
