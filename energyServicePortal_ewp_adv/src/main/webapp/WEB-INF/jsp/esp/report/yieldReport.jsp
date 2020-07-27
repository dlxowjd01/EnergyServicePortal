<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/custom/jszip.js" charset="utf-8"></script>
<script type="text/javascript" src="/js/custom/jszip-utils.js" charset="utf-8"></script>
<script type="text/javascript" src="/js/custom/FileSaver.js" charset="utf-8"></script>

<script type="text/javascript">
	let today = new Date();
	let repeat_type_method = 'post';
	let repeatCoastNumber = new Object();
	let reportType = {
		regular_mm: '월간 실적',
		regular_qt: '분기 실적',
		regular_yy: '년간 실적',
		profit_mm: '수익보고서'
	}

	$(function () {
		// popOption();
		initRow('yield_list');

		setInitList("listData"); //리스트초기화

		getDataList(page);
	})

	$(document).on('click', '#yield_list > li > button.btn_type07', function () {
		let idx = $('#yield_list > li > button.btn_type07').index($(this));
		delRow('yield_list', idx);
	});

	$(document).on('click', '.dropdown li', function (e) {
		e.preventDefault();
		let dataValue = $(this).data('value');
		let dataText = $(this).text();
		let id = $(this).parents('.dropdown').prop('id');
		$(this).parents('.dropdown').find('button').html(dataText + '<span class="caret"></span>').data('value', dataValue);

		if (id == 'spc_id') {
			callAjax({
				url: apiHost + '/spcs/' + dataValue,
				type: 'get',
				data: {
					oid: oid,
					includeGens: true
				}
			}, setSpcGen);
		} else if (id == 'report_type') {
			let spcid = $('#spc_id button').data('value');
			callAjax({
				url: apiHost + '/spcs/' + spcid,
				type: 'get',
				data: {
					oid: oid,
					includeGens: true
				}
			}, setSpcGenReport);
		}
	});

	$(document).on('change', 'input[type="file"]', function () {
		let uuid = genUuid();
		let thisId = $(this).prop('id');
		$('#upload').empty();
		$(this).clone().appendTo('#upload');
		$('#upload').find('input').attr('name', uuid).attr('id', uuid);

		callAjax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: apiHost + '/files/upload?oid=' + oid,
			data: new FormData($('#upload')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000
		}, setUploadAfter, thisId);
	});

	const callAjax = function (option, callBack, param) {
		$.ajax(option).done(function (data, textStatus, jqXHR) {
			if (typeof callBack == 'function') {
				if (param != undefined) {
					callBack.call(this, data, param);
				} else {
					callBack.call(this, data);
				}
			} else if (typeof callBack == 'string') {
				eval(callBack + '("' + param + '")');
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			alert('처리 중 오류가 발생했습니다.');
			return false;
		});
	}

	$(document).on('keyup', '#key_word', function (e) {
		if (e.keyCode == 13) {
			getDataList();
		}
	})

	const modalInit = function () {
		callAjax({
			url: apiHost + '/spcs',
			type: 'get',
			data: {
				oid: oid
			}
		}, setSpc);
	}

	const setSpc = function (data) {
		let spcList = data.data;
		let html = '';

		for (let i in spcList) {
			let temp = spcList[i];
			html += '<li data-value="' + temp.spc_id + '"><a href="javascript:void(0);">' + temp.name + '</a></li>';
		}

		$('#spc_id ul').empty().append(html);
		$('#site_id ul').empty();

		delRow('yield_list');

		//팝업 오픈시 value 초기화
		$('#reportModal input').each(function () {
			$(this).val('');
		});

		$('#reportModal button.btn-primary').each(function () {
			$(this).data('value', '').html($(this).data('name') + '<span class="caret"></span>');
		});

		$('#reportModal').modal();
	}

	const setSpcGen = function (data) {
		let siteList = data.data[0].spcGens;
		let html = '';

		$('#site_id button').html('선택 <span class="caret"></span>').data('value', ''); //초기화

		for (let i in siteList) {
			let temp = siteList[i];
			html += '<li data-value="' + temp.gen_id + '"><a href="javascript:void(0);">' + temp.name + '</a></li>';
		}

		$('#site_id ul').empty().append(html);
	}
	
	const setSpcGenReport = function (data){
		let spcIdList = data.data[0].spcGens;
		let siteName = $('#site_id button').text();
		let dataValue = $('#report_type button').data('value');
		let managePeriod = "";
		
		for (let i in spcIdList){
			let contractInfo = JSON.parse(spcIdList[i].contract_info);
			if(siteName == spcIdList[i].name){
				managePeriod = contractInfo.관리_운영_기간.trim();
			}
		}
		
		let startMonth = managePeriod.substring(5,7);
		let startDay = managePeriod.substring(8,10); 
		
		if(managePeriod.length > 20){
			if (dataValue == 'regular_mm') {
				let reportDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() -1, startDay));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth(), startDay-1));
			} else if (dataValue == 'regular_qt') {
				var quarter = Math.floor((startMonth - 3) / 3);
				prevtq = new Date(today.getFullYear(), quarter * 3, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear(), quarter * 3, startDay));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), (quarter + 1) * 3, startDay-1));
			} else if (dataValue == 'regular_yy') {
				let reportDate = new Date(today.getFullYear() - 1, 0, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear() - 1, startMonth -1, startDay));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), startMonth -1, startDay-1));
			} else if (dataValue == 'profit_mm') {
				let reportDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() -1, startDay));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth(), startDay-1));
			} else {
				alert('보고서 유형이 선택되지 않았습니다.');
				return false;
			}
		}else{
			if (dataValue == 'regular_mm') {
				let reportDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - 2, 1));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - 1, 0));
			} else if (dataValue == 'regular_qt') {
				var quarter = Math.floor((today.getMonth() - 3) / 3);
				prevtq = new Date(today.getFullYear(), quarter * 3, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear(), quarter * 3, 1));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), (quarter + 1) * 3, 0));
			} else if (dataValue == 'regular_yy') {
				let reportDate = new Date(today.getFullYear() - 1, 0, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear() - 1, 0, 1));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), 0, 0));
			} else if (dataValue == 'profit_mm') {
				let reportDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
				$('.fromDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - 2, 1));
				$('.toDate').datepicker('setDate', new Date(today.getFullYear(), today.getMonth() - 1, 0));
			} else {
				alert('보고서 유형이 선택되지 않았습니다.');
				return false;
			}
		}
		
	}

	//보고서 생성
	const reportCreate = function () {
		let data = setAreaParamData('reportModal', 'dropdown'),
			report_variable = new Array();

		$('[id^=report_variable_key_]').each(function () {
			let keyText = $(this).find('button').data('value'),
				valText = $(this).next().find('input').val(),
				temp = new Object();

			temp[keyText] = valText;
			report_variable.push(temp);
		});

		$.map(data, function (val, key) {
			if (key.match('report_variable_')) {
				delete data[key];
			}
		});

		data['report_variable'] = JSON.stringify(report_variable);
		data['generated_by'] = loginId;
		data['updated_by'] = loginId;
		data['generated_at'] = today.toISOString();

		let option = {
			url: apiHost + '/reports/performance?oid=' + oid,
			method: 'post',
			dataType: 'json',
			contentType: "application/json",
			traditional: true,
			data: JSON.stringify(data)
		};

		callAjax(option, afterCreate);
	}

	const afterCreate = function (data) {
		alert('보고서 등록이 완료되었습니다.');
		$('#reportModal').modal('hide');
		getDataList(page);
	}

	function getDataList(page, n, sort) {
		if (page == undefined) {
			page = 1;
		} else {
			if(isEmpty(n) && isEmpty(sort)) {
				$('.sort_table > thead').find('button').each(function(){
					if($(this).attr('class') != 'btn_align'){
						n = $(this).data('colname');
						sort = $(this).data('classname');
					}
				});
				
			}
		}
		
		let type = $('#reportClass button').data('value');
		let data = {
			oid: oid
		}
		if (type != undefined && type != '') {
			data['report_type'] = type;
		}

		$.ajax({
			url: apiHost + '/reports/performance',
			type: "get",
			async: false,
			data: data,
			success: function (result) {
				var jsonList = [],
					keyWord = $('#key_word').val();
				for (var i in result.data) {
					var temp = result.data[i],
						reportTypeName = reportType[temp.report_type],
						report_data_start = (new Date(temp.report_data_start)).format('yyyy-MM-dd'),
						report_data_end = (new Date(temp.report_data_end)).format('yyyy-MM-dd');

					result.data[i].reportTypeName = reportTypeName; //리포트 유형명
					result.data[i].report_date = report_data_start + '~' + report_data_end;

					if (temp.generated_at != null) {
						let generated_date = (new Date(temp.generated_at)).format('yyyy-MM-dd hh:mm:ss');
						result.data[i].generated_date = generated_date;
					}

					if (temp.generated_file_link != null) {
						let linkData = JSON.parse(temp.generated_file_link);
						result.data[i].file_link = 'location.href=\'' + apiHost + '/files/download/' + linkData.fileKey + '?oid=' + oid + '&orgFilename=' + linkData.orgFileName + '\'';
					}

					if (temp.confirmed_at != null) {
						let confirmed_date = (new Date(temp.confirmed_at)).format('yyyy-MM-dd hh:mm:ss');
						let linkData = JSON.parse(temp.confirmed_file_link);
						let file_link = 'location.href=\'' + apiHost + '/files/download/' + linkData.fileKey + '?oid=' + oid + '&orgFilename=' + linkData.orgFileName + '\'';
						result.data[i].confirmed_date = confirmed_date + '<button class="btn_file fr down" onclick="' + file_link + '">다운로드</button>';
					} else {
						let confirmed_date = '확정 보고서 업로드';
						result.data[i].confirmed_date = confirmed_date + '<label for="confirmFile' + temp.id + '" class="btn_file fr up"">업로드</label> <input type="file" id="confirmFile' + temp.id + '" name="confirmFile' + temp.id + '" class="uploadBtn hidden">';
					}

					if (jsonDataFilter(result.data[i])) {
						jsonList.push(result.data[i]);
					}
				}

				$(".sort_table").data("nowjsp", "yield");
				jsonListSort(n, sort, jsonList);
				jsonList = paging(page, jsonList);
				setMakeList(jsonList, "listData", { "dataFunction": { "INDEX": getNumberIndex } }); //list생성

				const now = new Date();
				$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}
	
	function jsonDataFilter(jsonData) {
		let keyWord = $('#key_word').val().trim().toLowerCase(),
			bResult = false, dResult = true, sResult = false;
		
		dResult = dateFilter(jsonData, dResult);
		
		if (jsonData['site_name'].toLowerCase().indexOf(keyWord) > -1 || jsonData['spc_name'].toLowerCase().indexOf(keyWord) > -1 || jsonData['updated_by'].toLowerCase().indexOf(keyWord) > -1) {
			sResult = true;
		}
		
		if(sResult && dResult){
			bResult = true;
		}

		return bResult;
	}

	function dateFilter(jsonData, dResult){
		let selectYear = '';
		let selectMonth = '';
		
		if($('#year button').text().trim() == '전체'){
			selectYear = ''; 
		}else{
			selectYear = $('#year button').text().trim().replace('년','');
		}
		if($('#month button').text().trim() == '전체'){
			selectMonth = '';
		}else{
			selectMonth = $('#month button').text().trim().replace('월','');
		}
		
		let	reportYear = jsonData.report_date.substring(0,4);
		let	reportMonth = jsonData.report_date.substring(5,7);
		
		if(reportMonth.indexOf(0) > -1){
			reportMonth = reportMonth.replace('0','');
		}
		
		if(selectYear != '' && selectMonth != ''){
			if(selectYear != reportYear || selectMonth != reportMonth){
				dResult = false;
			}
		}else if(selectYear != '' || selectMonth != ''){
			if(selectYear != reportYear && selectMonth != reportMonth){
				dResult = false;
			}
		}
		
		return dResult;
	}
	
	function getNumberIndex(index) {
		return index + 1;
	}

	function setCheckedAll(obj, chkName) {
		var checkVal = obj.checked;
		$("input[name='" + chkName + "']").prop("checked", checkVal);
	}

	function getCheckList(checkName) {
		var jsonList = $("#listData").data("gridJsonData"),
			checkList = [];
		$("input[name='" + checkName + "']").each(function (i) {
			if (this.checked) {
				checkList.push(jsonList[i]);
			}
		});

		return checkList;
	}

	function setCheckedDataExcelDown() {
		var checkDataList = getCheckList("rowCheck"),
			count = checkDataList.length,
			sucessCnt = 0;

		if (count == 0) {
			alert("다운로드할 목록을 선택하세요.");
			return;
		}

		var urlArr = new Array();
		var fileNameArr = new Array();
		for (var i = 0; i < count; i++) {
			var rowData = checkDataList[i];
			var fileLink = rowData.file_link.substring(15);
			var fileLinkUrl = fileLink.substring(0, fileLink.length - 1); // 파일링크 (뒤에 쉼표 제거)
			var orgFileName = JSON.parse(rowData.generated_file_link).orgFileName; // 파일이름
			urlArr.push(fileLinkUrl);

			if ($.inArray(orgFileName, fileNameArr) === -1) {
				fileNameArr.push(orgFileName);
			} else {
				let tempName = orgFileName.split('.');
				fileNameArr.push( tempName[0] + '_' + i + '.' + tempName[1]);
			}

		}

		getZip(urlArr, fileNameArr);
		getDataList();
	}

	function setCheckedDataRemove() {
		var checkDataList = getCheckList("rowCheck");
		count = checkDataList.length,
			sucessCnt = 0;

		if (count == 0) {
			alert("삭제 할 목록을 선택하세요.");
			return;
		}

		let delPrompt = prompt(count + '건을 삭제하시겠습니까? \n삭제를 원하시면 아래 "삭제"라고 입력하고 확인을 눌러 주세요.', '');
		if (delPrompt != '삭제') {
			return;
		}

		for (var i = 0; i < count; i++) {
			var rowData = checkDataList[i];
			$.ajax({
				url: apiHost + '/reports/performance/' + rowData.id + '?oid=' + oid,
				type: 'delete',
				async: false,
				data: {},
				success: function (json) {
					sucessCnt++;
				},
				error: function (request, status, error) {
				}
			});
		}

		alert(sucessCnt + "건 삭제처리되었습니다.");
		getDataList(page);
	}

	const setUploadAfter = function (result, propName) {
		if (result.files.length > 0) {
			var checkDataList = $("#listData").data("gridJsonData"),
				resultId = Number(propName.replace('confirmFile', '')),
				idx = 0;
			let fileLen = result.files[0].originalname.length;
			let fileNameDot = result.files[0].originalname.lastIndexOf('.');
			let fileExt = result.files[0].originalname.substring(fileNameDot, fileLen).toLowerCase();
			let newPageCnt = Math.floor((idx-1)/pagePerData);

			checkDataList.forEach(function(el) {
				if (el.id == resultId) {
					idx = el.INDEX;
				}
			});

			if(fileExt == '.pdf'){

				if(newPageCnt > 0){
					idx = idx - pagePerData * newPageCnt;
				}

				let confirmed_file_link = {
					fileKey: result.files[0].fieldname,
					orgFileName: result.files[0].originalname
				}
			
				let data = {
					confirmed_file_link: JSON.stringify(confirmed_file_link),
					confirmed_by: loginId,
					confirmed_at: new Date().toISOString()
				}
			
				let option = {
					url: apiHost + '/reports/performance/' + checkDataList[idx].id + '?oid=' + oid,
					method: 'patch',
					dataType: 'json',
					contentType: "application/json",
					traditional: true,
					data: JSON.stringify(data)
				};

				callAjax(option, confirmUpload);
				
			}else{
				alert('확장자가 pdf인 파일만 업로드가 가능 합니다.');
				return false;
			}
		}
	}

	const confirmUpload = function (data) {
		alert('보고서가 확정 처리 되었습니다.');
		getDataList(page);
	}

	//압축
	const getZip = function (urlArr, fileNameArr) {

		var Promise = window.Promise;
		if (!Promise) {
			Promise = JSZip.external.Promise;
		}
		//압축하기
		var zip = new JSZip();
		var url = ''
		for (var i = 0; i < urlArr.length; i++) {
			zip.file(fileNameArr[i], urlToPromise(urlArr[i]), { binary: true });
		}
		zip.generateAsync({ type: "blob" })
			.then(function (blob) {
				saveAs(blob, "엑셀_다운로드.zip");
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
</script>

<!-- 파일 업로드 폼 -->
<form id="upload" name="upload" method="multipart/form-data"></form>

<!-- 모달 -->
<div id="reportModal" class="modal fade" role="dialog">
	<div class="modal-dialog spc_dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h2>수익 보고서 신규</h2>
			</div>
			<div class="modal-body">
				<div class="ly_wrap report_modal_content container-fluid">
					<div class="row">
						<div class="col-lg-5 col-sm-12">
							<div class="flex_wrap">
								<span class="input_label">SPC</span>
								<div class="dropdown placeholder" id="spc_id">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">
										선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu"></ul>
								</div>
							</div>
							<div class="flex_wrap">
								<span class="input_label">보고서 유형</span>
								<div class="dropdown placeholder" id="report_type">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="선택">
										선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-value="regular_mm"><a href="javascript:void(0);">월간 발전량</a></li>
										<li data-value="regular_qt"><a href="javascript:void(0);">분기 발전량</a></li>
										<li data-value="regular_yy"><a href="javascript:void(0);">년간 발전량</a></li>
										<li data-value="profit_mm"><a href="javascript:void(0);">월간 수익보고서</a></li>
									</ul>
								</div>
							</div>
							<div class="add-wrap">
								<span class="input_label">적용 변수</span>
								<a href="javascript:void(0);" class="btn_add" onclick="addRow('yield_list');">추가</a>
							</div>
						</div>
						<div class="col-lg-7 col-sm-12">
							<div class="flex_wrap">
								<span class="input_label">발전소</span>
								<div class="dropdown placeholder" id="site_id">
									<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">
										선택<span class="caret"></span>
									</button>
									<ul class="dropdown-menu"></ul>
								</div>
							</div>
							<div class="flex_wrap">
								<span class="input_label">적용 기간</span>
								<div class="sel_calendar fl">
									<input type="text" id="report_data_start" name="report_data_start" value="" class="sel fromDate" autocomplete="off" readonly="" placeholder="날짜 선택">
								</div>
								<div class="sel_calendar fl ml">
									<input type="text" id="report_data_end" name="report_data_end" value="" class="sel toDate" autocomplete="off" readonly="" placeholder="날짜 선택">
								</div>
							</div>
						</div>
					</div>
					<hr>
					<ul class="yield_list" id="yield_list">
						<li>
							<div class="dropdown placeholder" id="report_variable_key_[index]">
								<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" data-name="">
									선택<span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li data-value="수익 배분율"><a href="javascript:void(0);">수익 배분율</a></li>
									<li data-value="REC 단가"><a href="javascript:void(0);">REC 단가</a></li>
									<li data-value="추가 예정"><a href="javascript:void(0);">추가 예정</a></li>
								</ul>
							</div>
							<div class="tx_inp_type fl">
								<input type="text" id="report_variable_val_[index]" name="report_variable_val_[index]" placeholder="입력">
							</div>
							<button class="btn_type07">삭제</button>
						</li>
					</ul>
					<div class="btn_wrap_type02">
						<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
						<button type="button" class="btn_type" onclick="reportCreate();">생성</button>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>


<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header fl">수익 보고서</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-12 clear inp_align">
		<div class="fl">
			<span class="tx_tit">유형</span>
			<div class="sa_select">
				<div class="dropdown" id="reportClass">
					<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul class="dropdown-menu" role="menu">
						<li data-value=""><a href="javascript:void(0);">전체</a></li>
						<li data-value="regular_mm"><a href="javascript:void(0);">월간실적</a></li>
						<li data-value="regular_qt"><a href="javascript:void(0);">분기실적</a></li>
						<li data-value="regular_yy"><a href="javascript:void(0);">년간실적</a></li>
						<li data-value="profit_mm"><a href="javascript:void(0);">수익보고서</a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<span class="tx_tit">적용 시작 월</span>
			<div class="sa_select">
				<div class="dropdown" id="year">
					<button class="btn btn-primary dropdown-toggle w7" type="button" data-toggle="dropdown">2020년<span class="caret"></span></button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0);">전체</a></li>
						<li><a href="javascript:void(0);">2020년</a></li>
						<li><a href="javascript:void(0);">2019년</a></li>
						<li><a href="javascript:void(0);">2018년</a></li>
					</ul>
				</div>
			</div>
			<div class="sa_select">
				<div class="dropdown" id="month">
					<button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">전체<span class="caret"></span></button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0);">전체</a></li>
						<li><a href="javascript:void(0);">1월</a></li>
						<li><a href="javascript:void(0);">2월</a></li>
						<li><a href="javascript:void(0);">3월</a></li>
						<li><a href="javascript:void(0);">4월</a></li>
						<li><a href="javascript:void(0);">5월</a></li>
						<li><a href="javascript:void(0);">6월</a></li>
						<li><a href="javascript:void(0);">7월</a></li>
						<li><a href="javascript:void(0);">8월</a></li>
						<li><a href="javascript:void(0);">9월</a></li>
						<li><a href="javascript:void(0);">10월</a></li>
						<li><a href="javascript:void(0);">11월</a></li>
						<li><a href="javascript:void(0);">12월</a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="fl">
			<div class="tx_inp_type"><input type="text" id="key_word" placeholder="입력"></div>
		</div>
		<div class="fl"><button type="submit" class="btn_type" onclick="getDataList(page);">검색</button></div>
	</div>
</div>
<div class="row">
	<div class="col-12">
		<div class="indiv report yield_report">
			<div class="flex_wrapper mb-20">
				<div><!-- 
					--><button type="button" class="btn_type03 big" onclick="setCheckedDataExcelDown();">선택 다운로드</button><!-- 
					--><button type="button" class="btn_type03 big" onclick="setCheckedDataRemove();">선택 삭제</button><!-- 
				--></div>
				<div><button type="button" class="btn_type" onclick="modalInit();">신규 생성</button></div>
			</div>
			<div class="spc_tbl align_type">
				<table class="sort_table chk_type" id="yield_table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="chk_header" value="순번" onclick="setCheckedAll(this, 'rowCheck');">
								<label for="chk_header">순번</label>
							</th>
							<th><button class="btn_align down">SPC명</button></th>
							<th><button class="btn_align down">발전소명</button></th>
							<th><button class="btn_align down">보고서 유형</button></th>
							<th><button class="btn_align down">적용기간</button></th>
							<th>다운로드</th>
							<th><button class="btn_align down">보고서 생성 시간</button></th>
							<th><button class="btn_align down">보고서 확정</button></th>
							<th><button class="btn_align down">최종 작업자</button></th>
						</tr>
					</thead>
					<tbody id="listData">
						<tr>
							<td>
								<input type="checkbox" id="chk_op[INDEX]" name="rowCheck" value="">
								<label for="chk_op[INDEX]">[INDEX]</label>
							</td>
							<td>[spc_name]</td>
							<td>[site_name]</td>
							<td>[reportTypeName]</td>
							<td>[report_date]</td>
							<td onclick="[file_link]">
								<button class="tx_file">EXCEL</button>
							</td>
							<td>[generated_date]</td>
							<td>[confirmed_date]</td>
							<td>[updated_by]</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="paging_wrap" id="paging">
			</div>
		</div>
	</div>
</div>