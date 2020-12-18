<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/custom/jszip.js" charset="utf-8"></script>
<script type="text/javascript" src="/js/custom/jszip-utils.js" charset="utf-8"></script>

<script type="text/javascript">
	let yieldTable = null;

	const yieldReportType = new Object();

	let reportType = new Object();

	$(function () {
		yieldTable = $('#yieldTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			"table-layout": "fixed",
			scrollY: '720px',
			scrollCollapse: true,
			sortable: true,
			paging: true,
			pageLength: 50,
			lengthMenu : [[50, 50, 100, 200], ["보기", 50, 100, 200]],

			columns: [
				{
					title: '<input type="checkbox" id="allCheck"><label for="allCheck"></label>',
					data: null,
					mRender: function ( data, type, full, rowIndex ) {
						return '<input type="checkbox" class="datatable-checkbox" id="check' + rowIndex.row + '" name="table_checkbox"><label for="check' + rowIndex.row + '"></label>';
					},
					className: 'dt-center no-sorting'
				},
				{
					title: '<fmt:message key="yieldReport.index" />',
					data: null,
					render: function (data, type, full, rowIndex) {
						return rowIndex.row + 1;
					},
					className: 'dt-center fixed'
				},
				{
					title: '<fmt:message key="yieldReport.SPC" />',
					data: 'spc_name',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return data;
						}
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.plantName" />',
					data: 'site_name',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return data;
						}
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.type" />',
					data: 'reportTypeName',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return '-';
						} else {
							return data;
						}
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.period" />',
					data: 'report_date',
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.download" />',
					data: 'file_link',
					render: function (data, type, full, rowIndex) {
						return '<button type="button" class="btn-type-sm btn-type03" onclick="' + data + '">EXCEL</button>';
					},
					sortable: false,
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.createdTime" />',
					data: 'generated_at',
					render: function (data, type, full, rowIndex) {
						if (data === null) {
							return '-';
						} else {
							return (new Date(data)).format('yyyy-MM-dd HH:mm:ss');
						}
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.reportEnd" />',
					data: 'confirmed_at',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return `<fmt:message key="yieldReport.confirmReport" />`;
						} else {
							const linkData = JSON.parse(full['confirmed_file_link'])
								, confirmed_date = (new Date(data)).format('yyyy-MM-dd HH:mm:ss');
							return `${'${confirmed_date}'}`;
						}
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.upload" />',
					data: 'confirmed_at',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data)) {
							return `<label for="confirmFile${'${full[\'id\']}'}" class="btn-file up"><fmt:message key="yieldReport.upload" /></label>
									<input type="file" id="confirmFile${'${full[\'id\']}'}" name="confirmFile${'${full[\'id\']}'}" class="btn-upload hidden" accept="application/pdf">`;
						} else {
							const linkData = JSON.parse(full['confirmed_file_link'])
								, confirmed_date = (new Date(data)).format('yyyy-MM-dd HH:mm:ss');
							return `<button type="button" class="btn-file down" onclick="downloadFile('${'${linkData[\'fileKey\']}'}', '${'${linkData[\'orgFileName\']}'}')">다운로드</button>`;
						}
					},
					className: 'dt-center'
				},
				{
					title: '<fmt:message key="yieldReport.person" />',
					data: 'updated_by',
					className: 'dt-center'
				}
			],
			select: {
				style: 'multi',
				selector: 'td:first-child > :checkbox, tr > td:not(:has(button))'
			},
			language: {
				emptyTable: '<fmt:message key="yieldReport.noData.1" />',
				zeroRecords: '<fmt:message key="yieldReport.noData.2" />',
				infoEmpty: "",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / <fmt:message key='table.totalCase.start' /> _TOTAL_ <fmt:message key='table.totalCase.end' />",
			},
			dom: 'tipl',
		}).on('select', function(e, dt, type, indexes) {
			yieldTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", true);
		}).on('deselect', function(e, dt, type, indexes) {
			yieldTable.rows( indexes ).nodes().to$().find("input[type='checkbox']").prop("checked", false);
		}).columns.adjust().draw();

		getProperties();
		getDataList();
	});

	$(document).on('keyup', '#key_word', function (e) {
		if (e.keyCode === 13) { getDataList(); }
	});

	const getProperties = () => {
		// $('#reportClass ul').empty();
		// $('#reportClass ul').append(`<li data-value=""><a href="javascript:void(0);">전체</a></li>`);
		$.ajax({
			url: apiHost + '/config/view/properties',
			type: 'GET',
			data: { oid: oid, types: 'yield_report_type' },
			success: (data, textStatus, jqXHR) => {
				const yieldTemplate = data.yield_report_type;

				// reportType = new Object();
				Object.entries(yieldTemplate).forEach(([index, yield]) => {
					const code = yield['code'];
					const name = (langStatus == 'KO') ? yield['name']['kr'] : yield['name']['en'];
					reportType[code] = name;

					$('#reportClass ul').append(`<li data-value="${'${code}'}"><a href="javascript:void(0);">${'${name}'}</a></li>`);
				});
			},
			error: (jqXHR, textStatus, errorThrown) => {
				console.error(textStatus);
				errorMsg('<fmt:message key="yieldReport.error.1" />');
			}
		});
	}

	/**
	 * 데이터 조회
	 */
	const getDataList = () => {
		new Promise(resolve => {
			$.ajax({
				url: apiHost + '/reports/performance',
				type: 'GET',
				data: { oid: oid },
				success: (result) => {
					if (!isEmpty(result) && !isEmpty(result['data'])) {
						resolve(result['data']);
					} else {
						throw Error('<fmt:message key="yieldReport.error.19" />');
					}
				},
				error: (request, status, error) => {
					console.error(error);
					throw Error('<fmt:message key="yieldReport.error.20" />');
				}
			});
		}).then(resultData => {
			resultData.forEach(data => {
				const reportDataStart = (new Date(data['report_data_start'])).format('yyyy-MM-dd')
					, reportDataEnd = (new Date(data['report_data_end'])).format('yyyy-MM-dd');

				data['reportTypeName'] = reportType[data['report_type']];
				data['report_date'] = reportDataStart + ' ~ ' + reportDataEnd;

				if (isEmpty(data['generated_file_link'])) {
					data['file_link'] = '-';
				} else {
					const linkData = JSON.parse(data['generated_file_link']);
					data['file_link'] = 'location.href=\'' + apiHost + '/files/download/' + linkData.fileKey + '?oid=' + oid + '&orgFilename=' + linkData.orgFileName + '\'';
				}
			});

			//작성일 기준 역순 정렬
			resultData.sort((a, b) => {
				return a['generated_at'] < b['generated_at'] ? 1 : a['generated_at'] > b['generated_at'] ? -1 : 0;
			});

			return resultData;
		}).then(resultData => {
			const searchType = $('#reportClass button').data('value')
				, searchYear = $('#year button').data('value')
				, searchMonth = $('#month button').data('value')
				, keyWord = $('#key_word').val().trim()
				, key_word = new RegExp(keyWord, 'i');

			resultData = resultData.filter(rowData => {
				let	reportYear = Number(rowData['report_date'].substring(0, 4));
				let	reportMonth = Number(rowData['report_date'].substring(5, 7));

				if (((!isEmpty(searchType) && rowData['report_type'] === searchType) || isEmpty(searchType))
					&& ((!isEmpty(searchYear) && reportYear === searchYear) || isEmpty(searchYear))
					&& ((!isEmpty(searchMonth) && reportMonth === searchMonth) || isEmpty(searchMonth))
					&& ((!isEmpty(keyWord) && (rowData['site_name'].match(key_word) || rowData['spc_name'].match(key_word) || rowData['updated_by'].match(key_word))) || isEmpty(keyWord))
				) {
					return true;
				}
			});

			yieldTable.clear();
			yieldTable.rows.add(resultData).draw();
		}).catch(error => {
			yieldTable.clear().draw();
			errorMsg(error);
		});
		$("#allCheck").prop("checked", false)
	}

	/**
	 * 파일 다운로드
	 *
	 * @param fileKey
	 * @param orgFilename
	 */
	const downloadFile = (fileKey, orgFilename) => {
		let url = apiHost + '/files/download/' + fileKey + '?oid=' + oid + '&orgFilename' + orgFilename;
		$.ajax({
			url: url,
			method: 'GET',
			xhrFields: {
				responseType: 'blob'
			},
			success: function(data) {
				let name = orgFilename
				  , a = document.createElement('a')
				  , url = window.URL.createObjectURL(data);

				a.href = url;
				a.download = name;
				document.body.append(a);
				a.click();
				setTimeout(function(){
					a.remove();
					window.URL.revokeObjectURL(url);
				}, 200);
			},
			fail: function(){
				errorMsg('<fmt:message key="yieldReport.error.2" />');
			}
		});
	}

	/**
	 * 등록 팝업
	 */
	const modalInit = () => {
		const spcs = $.ajax({
			url: apiHost + '/spcs',
			type: 'GET',
			data: { oid: oid }
		});

		const props = $.ajax({
			url: apiHost + '/config/view/properties',
			type: 'GET',
			data: { oid: oid, types: 'yield_report_type' }
		});

		Promise.all([spcs, props]).then(response => {
			const resolveData = new Object();
			response.forEach((result, index) => {
				if (index === 0) {
					if (!isEmpty(result) && !isEmpty(result['data'])) {
						resolveData['spcs'] = result['data'];
					} else {
						resolveData['spcs'] = null;
					}
				} else {
					resolveData['yield_report_type'] = result['yield_report_type'];
				}
			});

			return resolveData;
		}).then(data => {
			const spcData = data['spcs']
				, yieldTemplate = data['yield_report_type'];

			$('#spc_id ul').empty(); //SPCID 초기화
			$('#report_type ul').empty(); //보고서타입 초기화
			$('#yieldList').empty(); // 적용변수 초기화

			if (isEmpty(spcData)) {
				$('#spc_id ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
			} else {
				spcData.forEach(spc => {
					$('#spc_id ul').append(`<li data-value="${'${spc[\'spc_id\']}'}"><a href="javascript:void(0);">${'${spc[\'name\']}'}</a></li>`);
				});
			}

			if (isEmpty(yieldTemplate)) {
				$('#report_type ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
			} else {
				Object.entries(yieldTemplate).forEach(([index, yield]) => {
					const name = (langStatus == 'KO') ? yield['name']['kr'] : yield['name']['en'];
					$('#report_type ul').append(`<li data-value="${'${yield[\'code\']}'}" data-options="${'${yield[\'option\']}'}" data-range="${'${yield[\'range\']}'}" data-interval="${'${yield[\'interval\']}'}"><a href="javascript:void(0);">${'${name}'}</a></li>`);
				});
			}

			$('#reportModal input').each(function () {
				$(this).val('');
			});

			$('#reportModal .dropdown-toggle').each(function () {
				$(this).data('value', '').html($(this).data('name') + '<span class="caret"></span>');
			});

			$('#reportModal').modal();
		}).catch(error => {
			console.error(error);
			errorMsg('<fmt:message key="yieldReport.error.3" />');
		});
	}

	/**
	 * 등록 팝업
	 * - 옵션 설
	 */
	const addOption = () => {
		const reportOption = $('#report_type button').data('options')
			, reportValue = $('#report_type button').data('value');

		if (isEmpty(reportValue)) {
			errorMsg('<fmt:message key="yieldReport.error.4" />');
			return false;
		}

		if (isEmpty(reportOption)) {
			errorMsg('<fmt:message key="yieldReport.error.5" />');
		} else {
			let options = new Array()
			  , liIndex = 1;
			options = reportOption.match(',') ? reportOption.split(',') : options.push(reportOption);

			if (reportValue !== $('#yieldList').data('value')) {
				$('#yieldList').empty(); // 적용변수 초기화
			}

			if ($('#yieldList li').length > 0) {
				$('#yieldList li').each(function() {
					if (!isEmpty($(this).find('div.dropdown').attr('id'))) {
						liIndex = Number(($(this).find('div.dropdown').attr('id')).replace(/[^0-9]/g, '')) + 1;
					}
				});
			}

			let liStr = `<li>
							<div class="dropdown placeholder" id="report_variable_key_${'${liIndex}'}">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="">
									<fmt:message key="default.dataNameSelect" /><span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
								</ul>
							</div>
							<div class="text-input-type fl">
								<input type="text" id="report_variable_val_${'${liIndex}'}" name="report_variable_val_${'${liIndex}'}" placeholder="<fmt:message key="yieldReport.enter" />" autocomplete="off">
							</div>
							<button type="button" class="btn-type07" onclick="$(this).parents('li').remove();"><fmt:message key="yieldReport.delete" /></button>
						</li>`;
			$('#yieldList').append(liStr);

			options.forEach(option => {
				$('#report_variable_key_' + liIndex + ' ul').append(`<li data-value="${'${option}'}"><a href="javascript:void(0);">${'${option}'}</a></li>`);
			});
			$('#yieldList').data('value', reportValue);
		}
	}

	/**
	 * 드롭다운 선택
	 */
	const rtnDropdown = ($selector) => {
		if ($selector === 'report_type') {
			const dropdownValue = $('#' + $selector + ' button').data('value');
			if (dropdownValue !== $('#yieldList').data('value')) {
				$('#yieldList').empty(); // 적용변수 초기화
			}

			setSpcGenReport();
		} else if ($selector === 'spc_id') {
			const dropdownValue = $('#' + $selector + ' button').data('value');
			$('#site_id ul').empty();

			$.ajax({
				url: apiHost + '/spcs/' + dropdownValue,
				type: 'GET',
				data: {
					oid: oid,
					includeGens: true
				},
				success: (data) => {
					const siteList = data.data[0]['spcGens'];
					if (!isEmpty(data) && !isEmpty(data.data[0]['spcGens'])) {
						siteList.forEach(gen => {
							let liStr = `<li data-value="${'${gen[\'gen_id\']}'}"><a href="javascript:void(0);">${'${gen[\'name\']}'}</a></li>`;
							$('#site_id ul').append(liStr);
						});
					} else {
						$('#site_id ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
					}
				},
				fail: function(){
					errorMsg('<fmt:message key="yieldReport.error.6" />');
					$('#site_id ul').append(`<li><a href="javascript:void(0);"><fmt:message key="yieldReport.error.19" /></a></li>`);
				}
			});
		} else if ($selector === 'site_id') {
			setSpcGenReport();
		}
 	}

 	/**
	 *
	 */
	const setSpcGenReport = () => {
		const siteId = $('#site_id button').data('value')
			, spcId = $('#spc_id button').data('value')
			, reportType = $('#report_type button').data('value');

	    const dataRange = $('#report_type button').data('range')
		    , dataInterval = $('#report_type button').data('interval')
	        , today = new Date();

	    let month = 1;
	    if (dataInterval === 'year') {
		    month += 12;
	    } else {
		    month += Number(dataRange);
	    }

	    $('.fromDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - month, 1));
	    $('.toDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - 1, 0));
	}

	//보고서 생성
	const reportCreate = function () {
		const today = new Date();
		let data = setAreaParamData('reportModal', 'dropdown'),
			report_variable = new Array();

		if (isEmpty($('#spc_id button').data('value'))) {
			errorMsg('<fmt:message key="yieldReport.error.7" />');
			return;
		}

		if (isEmpty($('#report_type button').data('value'))) {
			errorMsg('<fmt:message key="yieldReport.error.8" />');
			return;
		}

		if (!($('#report_type button').data('value')).match('quaterly')) {
			if (isEmpty($('#site_id button').data('value'))) {
				errorMsg('<fmt:message key="yieldReport.error.9" />');
				return;
			}
		}

		if ($('#report_data_start').datepicker('getDate') === null || $('#report_data_end').datepicker('getDate') === null) {
			errorMsg('<fmt:message key="yieldReport.error.10" />');
			return;
		}

		$('[id^=report_variable_key_]').each(function () {
			let keyText = $(this).find('button').data('value'),
				valText = $(this).next().find('input').val(),
				temp = new Object();

			temp[keyText] = valText;
			report_variable.push(temp);
		});

		Object.entries(data).forEach(([key, val]) => {
			if (key.match('report_variable_')) {
				delete data[key];
			}
		});

		data['report_variable'] = JSON.stringify(report_variable);
		data['generated_by'] = loginId;
		data['updated_by'] = loginId;
		data['generated_at'] = today.toISOString();

		$.ajax({
			url: apiHost + '/reports/performance?oid=' + oid,
			method: 'post',
			dataType: 'json',
			contentType: "application/json",
			traditional: true,
			data: JSON.stringify(data),
			success: () => {
				$('#reportModal').modal('hide');
				errorMsg('<fmt:message key="yieldReport.error.11" />');
				getDataList();
			},
			fail: () => {
				errorMsg('<fmt:message key="yieldReport.error.12" />');
				return false;
			}
		});
	}

	$(document).on('change', 'input[type="file"]', function () {
		let uuid = genUuid();
		let thisId = $(this).prop('id');
		$('#upload').empty();
		$(this).clone().appendTo('#upload');
		$('#upload').find('input').attr('name', uuid).attr('id', uuid);

		new Promise(resolve => {
			$.ajax({
				type: 'post',
				enctype: 'multipart/form-data',
				url: apiHost + '/files/upload?oid=' + oid,
				data: new FormData($('#upload')[0]),
				processData: false,
				contentType: false,
				cache: false,
				timeout: 600000,
				success: (data) => {
					if (isEmpty(data) && isEmpty(data.files)) {
						errorMsg('<fmt:message key="yieldReport.error.13" />');
					} else {
						resolve(data.files);
					}
				},
				fail: () => {
					errorMsg('<fmt:message key="yieldReport.error.14" />');
				}
			})
		}).then(files => {
			const resultId = Number(thisId.replace('confirmFile', ''))
			const confirmed_file_link = {
				fileKey: files[0].fieldname,
				orgFileName: files[0].originalname
			}

			$.ajax({
				url: apiHost + '/reports/performance/' + resultId + '?oid=' + oid,
				method: 'patch',
				dataType: 'json',
				contentType: 'application/json',
				traditional: true,
				data: JSON.stringify({
					confirmed_file_link: JSON.stringify(confirmed_file_link),
					confirmed_by: loginId,
					confirmed_at: new Date().toISOString()
				}),
				success: (data) => {
					errorMsg('<fmt:message key="yieldReport.error.15" />');
					getDataList();
				},
				fail: () => {
					errorMsg('<fmt:message key="yieldReport.error.16" />');
				}
			});
		}).catch(error => {
			errorMsg(error);
		});
	});

	const setCheckedDataExcelDown = () => {
		const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');

		let zipArr = new Array()
		if (checkedArray.length === 0) {
			errorMsg('<fmt:message key="yieldReport.error.17" />');
		} else {
			checkedArray.forEach(checkBox => {
				const chkIndex = Number((checkBox.getAttribute('id')).replace(/[^0-9]/g, ''))
					, rowData = yieldTable.row(chkIndex).data()
					, fileLink = (rowData.file_link.substring(15)).substring(0, rowData.file_link.substring(15).length - 1)
					, orgFileName = JSON.parse(rowData.generated_file_link).orgFileName;

				if (zipArr.some(e => e.fileName === orgFileName)) {
					let tempName = orgFileName.split('.');
					zipArr.push({
						fileLink: fileLink,
						fileName: tempName[0] + '_' + i + '.' + tempName[1]
					});
				} else {
					zipArr.push({
						fileLink: fileLink,
						fileName: orgFileName
					});
				}
			});

			getZip(zipArr);
			getDataList();
		}
	}

	//압축
	const getZip = function (zipArr) {
		let Promise = window.Promise;
		if (!Promise) {
			Promise = JSZip.external.Promise;
		}
		//압축하기
		let zip = new JSZip();
		zipArr.forEach(rowData => {
			zip.file(rowData.fileName, urlToPromise(rowData.fileLink), { binary: true });
		});

		zip.generateAsync({ type: 'blob' })
		.then(function (blob) {
			saveAs(blob, '엑셀_다운로드.zip');
		});
	}

	//바이너리
	const urlToPromise = function (url) {
		return new Promise(function (resolve, reject) {
			JSZipUtils.getBinaryContent(url, function (err, data) {
				if (err) {
					reject(err);
				} else {
					resolve(data);
				}
			});
		});
	}

	function setCheckedDataRemove() {
		const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');

		if (checkedArray.length === 0) {
			errorMsg('<fmt:message key="yieldReport.error.18" />');
		} else {
			let modal = $("#comDeleteModal");
			let deleteBtn = $("#comDeleteBtn");
			let confirmTitle = $("#confirmTitle");

			$("#comDeleteSuccessMsg span").text('<fmt:message key="yieldReport.delete" />');
			modal.find(".modal-body").removeClass("hidden");
			modal.modal("show");

			confirmTitle.on("input keyp", function() {
				if($(this).val() !== '삭제') {
					deleteBtn.prop("disabled", true);
					return false
				} else {
					deleteBtn.prop("disabled", false);
				}
			});
		}
	}


	$(document).on('click', '#comDeleteBtn', function() {
		$('#comDeleteModal').modal('hide');
		$('#confirmTitle').val('');

		const deleteArray = new Array();
		const checkedArray = document.querySelectorAll('[name="table_checkbox"]:checked');
		checkedArray.forEach(checkBox => {
			const chkIndex = Number((checkBox.getAttribute('id')).replace(/[^0-9]/g, ''))
				, rowData = yieldTable.row(chkIndex).data();

			deleteArray.push($.ajax({
				url: apiHost + '/reports/performance/' + rowData.id + '?oid=' + oid,
				type: 'delete'
			}));
		});

		Promise.all(deleteArray).then(response => {
			let totalDelete = 0;
			response.forEach(result => {
				const data = result['data']
					, count = data['count'];

				totalDelete += Number(count);
			});

			errorMsg(totalDelete + '<fmt:message key="yieldReport.countDelete" />');
			getDataList();
		}).catch(error => {
			errorMsg(error);
		});
	});

	/**
	 * 에러 처리
	 *
	 * @param msg
	 */
	const errorMsg = msg => {
		$("#errMsg").text(msg);
		$("#errorModal").modal("show");
		setTimeout(function(){
			$("#errorModal").modal("hide");
		}, 1800);
	}
</script>

<!-- 파일 업로드 폼 -->
<form id="upload" name="upload" method="multipart/form-data"></form>

<!-- 모달 -->
<div id="reportModal" class="modal fade" role="dialog">
	<div class="modal-dialog spc-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h2><fmt:message key='yieldReport.title' /></h2>
			</div>
			<div class="modal-body">
				<div class="report-modal-content container-fluid">
					<div class="row">
						<div class="col-lg-6 col-sm-12">
							<div class="flex-start">
								<span class="input-label">SPC</span>
								<div id="spc_id" class="dropdown placeholder">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='default.dataNameSelect' />">
										<fmt:message key='yieldReport.select' /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu"></ul>
								</div>
							</div>
							<div class="flex-start">
								<span class="input-label"><fmt:message key="revenuereport.2.report_classification" /></span>
								<div id="report_type" class="dropdown placeholder">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='default.dataNameSelect' />">
										<fmt:message key='yieldReport.select' /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-value="regular_mm"><a href="javascript:void(0);"><fmt:message key='yieldReport.gen.month' /></a></li>
										<li data-value="regular_qt"><a href="javascript:void(0);"><fmt:message key='yieldReport.gen.qt' /></a></li>
										<li data-value="regular_yy"><a href="javascript:void(0);"><fmt:message key='yieldReport.gen.year' /></a></li>
										<li data-value="profit_mm"><a href="javascript:void(0);"><fmt:message key='yieldReport.report' /></a></li>
									</ul>
								</div>
							</div>
							<div class="flex-start"><!--
								--><span class="input-label short"><fmt:message key='yieldReport.var' /></span><!--
								--><a href="javascript:void(0);" class="btn-text-blue" onclick="addOption();"><fmt:message key='yieldReport.add' /></a><!--
						--></div>
						</div>

						<div class="col-lg-6 col-sm-12">
							<div class="flex-start">
								<span class="input-label"><fmt:message key='yieldReport.plant' /></span>
								<div class="dropdown placeholder" id="site_id">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="<fmt:message key='default.dataNameSelect' />">
										<fmt:message key='yieldReport.select' /><span class="caret"></span>
									</button>
									<ul class="dropdown-menu"></ul>
								</div>
							</div>
							<div class="flex-start dateField">
								<span class="input-label"><fmt:message key='yieldReport.period' /></span>
								<div class="sel-calendar">
									<input type="text" id="report_data_start" name="report_data_start" value="" class="sel fromDate" autocomplete="off" readonly="" placeholder="<fmt:message key='yieldReport.dateSelect' />">
								</div>
								<div class="sel-calendar ml-22">
									<input type="text" id="report_data_end" name="report_data_end" value="" class="sel toDate" autocomplete="off" readonly="" placeholder="<fmt:message key='yieldReport.dateSelect' />">
								</div>
							</div>
						</div>
					</div>
					<hr class="mt-0">
					<ul id="yieldList" class="yield-list">
					</ul>
					<div class="btn-wrap-type02">
						<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close"><fmt:message key='yieldReport.cancle' /></button>
						<button style="padding: 0px;" type="button" class="btn-type" onclick="reportCreate();"><fmt:message key='yieldReport.create' /></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl"><fmt:message key='yieldReport.report' /></h1>
	</div>
</div>
<div class="row">
	<div class="col-12 clear input-align">
		<div class="fl">
			<span class="tx-tit"><fmt:message key="revenuereport.1.type" /></span>
			<div class="sa-select">
				<div class="dropdown" id="reportClass">
					<button type="button" class="dropdown-toggle w7" data-toggle="dropdown"><fmt:message key="revenuereport.1.all" /><span class="caret"></span></button>
					<ul class="dropdown-menu" role="menu">
						<li data-value=""><a href="javascript:void(0);"><fmt:message key="revenuereport.1.all" /></a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<span class="tx-tit"><fmt:message key='yieldReport.startMonth' /></span>
			<div class="sa-select">
				<div class="dropdown" id="year">
					<button type="button" class="dropdown-toggle w7" data-toggle="dropdown"><fmt:message key="revenuereport.1.2020" /><span class="caret"></span></button>
					<ul class="dropdown-menu" role="menu">
						<li data-value=""><a href="javascript:void(0);"><fmt:message key="revenuereport.1.all" /></a></li>
						<li data-value="2020"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.2020" /></a></li>
						<li data-value="2019"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.2019" /></a></li>
						<li data-value="2018"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.2018" /></a></li>
					</ul>
				</div>
			</div>
			<div class="sa-select">
				<div class="dropdown" id="month">
					<button type="button" class="dropdown-toggle w3" data-toggle="dropdown"><fmt:message key="revenuereport.1.all" /><span class="caret"></span></button>
					<ul class="dropdown-menu" role="menu">
						<li data-value=""><a href="javascript:void(0);"><fmt:message key="revenuereport.1.all" /></a></li>
						<li data-value="1"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.january" /></a></li>
						<li data-value="2"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.february" /></a></li>
						<li data-value="3"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.march" /></a></li>
						<li data-value="4"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.april" /></a></li>
						<li data-value="5"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.may" /></a></li>
						<li data-value="6"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.june" /></a></li>
						<li data-value="7"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.july" /></a></li>
						<li data-value="8"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.august" /></a></li>
						<li data-value="9"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.september" /></a></li>
						<li data-value="10"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.october" /></a></li>
						<li data-value="11"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.november" /></a></li>
						<li data-value="12"><a href="javascript:void(0);"><fmt:message key="revenuereport.1.december" /></a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<div class="text-input-type"><input type="text" id="key_word" placeholder="<fmt:message key='yieldReport.input' />" autocomplete="off"></div>
		</div>
		<div class="fl">
			<button type="button" class="btn-type" onclick="getDataList();">
				<fmt:message key="revenuereport.1.search" />
			</button>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv">
			<div class="flex-wrapper mb-20">
				<div><!-- 
					--><button type="button" class="btn-type03 big" onclick="setCheckedDataExcelDown();"><fmt:message key='yieldReport.selected.download' /></button><!-- 
					--><button type="button" class="btn-type03 big" onclick="setCheckedDataRemove();"><fmt:message key='yieldReport.selected.delete' /></button><!-- 
				--></div>
				<div><button type="button" class="btn-type" onclick="modalInit();"><fmt:message key='yieldReport.new' /></button></div>
			</div>
			<table id="yieldTable" class="chk-type">
				<colgroup>
					<col style="width:5%"> <!-- 체크박스 <fmt:message key='yieldReport.checkbox' /> -->
					<col style="width:5%"> <!-- 순번 <fmt:message key='yieldReport.index' /> -->
					<col style="width:10%"> <!-- SPC명 <fmt:message key='yieldReport.SPC' /> -->
					<col style="width:10%"> <!-- 발전소명 <fmt:message key='yieldReport.plantName' /> -->
					<col style="width:8%"> <!-- 보고서 유형 <fmt:message key='yieldReport.type' /> -->
					<col style="width:15%"> <!-- 적용기간 <fmt:message key='yieldReport.period' /> -->
					<col style="width:6%"> <!-- 다운로드 <fmt:message key='yieldReport.download' /> -->
					<col style="width:12%"> <!-- 보고서 생성 시간 <fmt:message key='yieldReport.createdTime' /> -->
					<col style="width:9%"> <!-- 보고서 확정 <fmt:message key='yieldReport.reportEnd' /> -->
					<col style="width:4%"> <!-- 보고서 확정 <fmt:message key='yieldReport.upload' /> -->
					<col style="width:10%"> <!-- 최종 작업자 <fmt:message key='yieldReport.person' /> -->
				</colgroup>
			</table>
		</div>
	</div>
</div>