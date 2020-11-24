<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	const boardURL = '/board';
	const spcURL = '/spcs';
	const prop = ['subject', 'contents', 'level', 'spc_id'];

	let noticeTable = null;
	$(function() {
		setInitList('spcList');
		setInitList('view_attachement_info');
		setInitList('modi_attachement_info');

		noticeTable = $('#noticeTable').DataTable({
			'table-layout': 'fixed',
			autoWidth: true,
			fixedHeader: true,
			scrollCollapse: true,
			scrollY: '720px',
			paging: true,
			pageLength: 15,
			serverSide: true,
			processing: true,
			order: [],
			ajax: {
				type: 'GET',
				url: apiHost + '/board',
				data: function(d) {
					let param = new Object();
					param.oid = oid;
					param.kind = 1;
					param.limit = 15;
					param.page = (d.start / 15) + 1;
					param.includeDeleted = false;
					param.range = 0;
					param.search = document.getElementById('search').value
					return param;
				},
				contentType: 'application/x-www-form-urlencoded',
				dataFilter: function (json) {
					json = JSON.parse(json);

					json.data.forEach(notice => {
						const attachment = isEmpty(notice.attachement_info) ? new Array() : JSON.parse(notice.attachement_info);
						notice['attachment'] = attachment.length;
						notice['updatedAt'] = (new Date(notice.updated_at)).format('yyyy-MM-dd HH:mm:ss');
					});

					return JSON.stringify({
						recordsTotal: json.count,
						recordsFiltered: json.count,
						data: json.data
					}); // return JSON string
				}
			},
			columns: [
				{
					title: 'SPC 명',
					data: 'spc_name',
					render: function (data, type, full, rowIndex) {
						if (!isEmpty(data)) {
							return `<a href="javascript:void(0);" onclick="getDetailNotice('${'${full.id}'}');" class="table-link">${'${data}'}</a>`;
						} else {
							return '';
						}
					},
					className: 'dt-left',
					orderable: false
				},
				{
					title: '제목',
					data: 'subject',
					render: function (data, type, full, rowIndex) {
						if (!isEmpty(data)) {
							return `<a href="javascript:void(0);" onclick="getDetailNotice('${'${full.id}'}');" class="table-link">${'${data}'}</a>`;
						} else {
							return '';
						}
					},
					className: 'dt-left',
					orderable: false
				},
				{
					title: '첨부 파일',
					data: 'attachment',
					render: function (data, type, full, rowIndex) {
						if (isEmpty(data) || data === 0) {
							return '-';
						} else {
							return data + ' 건';
						}
					},
					className: 'dt-center',
					orderable: false
				},
				{
					title: '작성자',
					data: 'created_by',
					className: 'dt-center',
					orderable: false
				},
				{
					title: '작성일',
					data: 'updatedAt',
					className: 'dt-center',
					orderable: false
				}
			],
			dom: 'tip',
			language: {
				emptyTable: "조회된 데이터가 없습니다.",
				zeroRecords:  "검색된 결과가 없습니다.",
				infoEmpty: "",
				paginate: {
					previous: "",
					next: "",
				},
				info: "_PAGE_ - _PAGES_ " + " / 총 _PAGES_ 개",
			},
		}).columns.adjust();
	});

	const getDetailNotice = (viewId) => {
		$.ajax({
			url: apiHost + boardURL,
			type: 'get',
			dataType: 'json',
			data: {
				oid: oid,
				kind: 1,
				id: viewId,
				includeDeleted: false
			}
		}).done(function (data, textStatus, jqXHR) {
			const result = data.data[0];
			if (userInfoId === result.created_by_uid || role === 1) {
				$('#delBtn').removeClass('hidden');
				$('#chgBtn').removeClass('hidden');
				$('#view_level').parents('div.row').removeClass('hidden');
			} else {
				$('#delBtn').addClass('hidden');
				$('#chgBtn').addClass('hidden');
				$('#view_level').parents('div.row').addClass('hidden');
			}

			Object.entries(result).forEach(([key, val]) => {
				const $view = $('#viewNotice'),
					$viewObj = $view.find('#view_' + key);
				if ($viewObj.length > 0) {
					if(key == 'level') {
						let levelText = '';
						switch (val) {
							case 0:
								levelText = '전체';
								break;
							case 1:
								levelText = '자산 운용사';
								break;
							case 2:
								levelText = 'SPC 담당 사무수탁사';
								break;
							default:
								levelText = '전체';
						}
						$viewObj.text(levelText);
					} else if (key == 'attachement_info') {
						if (!isEmpty(val)) {
							let attach = JSON.parse(val);
							setMakeList(attach, 'view_' + key, {'dataFunction': {}});
						} else {
							setMakeList(new Array(), 'view_' + key, {'dataFunction': {}});
						}
					} else if (key == 'spc_name') {
						if (isEmpty(val)) {
							$('#view_' + key).parents('.input-group').addClass('hidden');
						} else {
							$('#view_' + key).text(val).parents('.input-group').removeClass('hidden');
						}
					} else {
						val.replace(/\n/g, '<br/>');
						$viewObj.html(val);
					}
				}
			})

			$('#delBtn').attr('onclick', 'delNotice("' + result.id + '")');
			$('#chgBtn').attr('onclick', 'modalOpen("' + result.id + '")');
			$('#viewNotice').modal('show');
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	function modalOpen(boardId) {
		$('#addNotice input').val('');
		$('#addNotice textarea').val('');
		$('#addNotice div.file_list ul').html('<li class="upload-text"></li>');
		initDropdownValue($('#addNotice .dropdown-toggle'));
		$('#modi_attachement_info').addClass('hidden');
		$('#spc_id').parent().addClass('hidden');

		if (boardId != undefined) {
			$('#viewNotice').modal('hide');
			$('#addNotice').find('#addBtn').attr('onclick', 'setNotice("patch", "' + boardId + '")').text('수정');

			$.ajax({
				url: apiHost + boardURL,
				type: 'get',
				dataType: 'json',
				async: false,
				data: {
					oid: oid,
					kind: 1,
					id: boardId,
					includeDeleted: false
				}
			}).done(function (data, textStatus, jqXHR) {
				const result = data.data[0];
				if (!isEmpty(result)) {

					setJsonAutoMapping(result, 'addNotice');

					if (!isEmpty(result.level) && result.level == '2') {
						$('#spc_id').parent().removeClass('hidden');
						getSpcData();

						$('#addNotice #spc_id button').html(result.spc_name + '<span class="caret"></span>').data('value', result.spc_id);
					} else {
						$('#spc_id').parent().addClass('hidden');
					}

					const attachement = result.attachement_info;
					if (!isEmpty(attachement)) {
						let attach = JSON.parse(attachement);
						setMakeList(attach, 'modi_attachement_info', {'dataFunction': {}});
						$('#modi_attachement_info').removeClass('hidden');
					} else {
						setMakeList(new Array(), 'modi_attachement_info', {'dataFunction': {}});
					}
				}

				const now = new Date();
				$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));
			}).fail(function (jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);
			});

		} else {
			$('#addNotice').find('#addBtn').attr('onclick', 'setNotice("post")').text('등록');
		}

		$('#addNotice').modal('show');
	}

	function getSpcData() {
		$.ajax({
			url: apiHost + spcURL,
			type: 'get',
			dataType: 'json',
			data: { oid: oid }
		}).done(function (data, textStatus, jqXHR) {
			setMakeList(data.data, 'spcList', {'dataFunction': {}});
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	function setNotice(method, id) {
		let preffix = '';
		let urlSuffix = '';
		let areaData = setAreaParamData('addNotice', 'dropdown');

		if (isEmpty(areaData.subject.trim())) { errorMsg('제목은 필수 값입니다.'); return false; }
		if (isEmpty(areaData.contents.trim())) { errorMsg('내용은 필수 값입니다.'); return false; }
		if (isEmpty(areaData.level)) { errorMsg('공개 범위는 필수 값입니다.'); return false; }


		if (method == 'patch') {
			urlSuffix = '/' + id + '?oid=' + oid;
			preffix = '수정';
		} else {
			urlSuffix = '?oid=' + oid;
			areaData['created_by'] = loginId;
			areaData['created_by_uid'] = userInfoId;
			preffix = '등록';
		}
		areaData['kind'] = 1;

		if (isEmpty(areaData['spc_id'])) {
			delete areaData['spc_id'];
		}

		$('#addNotice').find('input[type="file"]').each(function () {
			$(this).attr('name', this.name + '_' + genUuid());
		});

		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: apiHost + '/files/upload?oid=' + oid,
			data: new FormData($('#addNoticeForm')[0]),
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			async: false
		}).done(function (data, textStatus, jqXHR) {
			const resultFiles = data.files;

			if (method == 'patch') {
				areaData['attachement_info'] = JSON.stringify($('#modi_attachement_info').data('gridJsonData').concat(resultFiles));
			} else {
				areaData['attachement_info'] = JSON.stringify(resultFiles);
			}
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});

		$.ajax({
			url: apiHost + boardURL + urlSuffix,
			type: method,
			dataType: 'json',
			contentType: 'application/json',
			data: JSON.stringify(areaData)
		}).done(function (data, textStatus, jqXHR) {
			alert(preffix + '되었습니다.');

			$('#addNotice').modal('hide');
			getNoticeList(1);
			return false;
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);

			return false;
		});
	}

	function pressEnter() {
		if (event.keyCode == 13) {
			noticeTable.ajax.reload();
		}
	}

	function delNotice(viewId) {
		$.ajax({
			url: apiHost + boardURL + '/' + viewId + '?oid=' + oid,
			type: 'delete',
			dataType: 'json',
			data: {}
		}).done(function (data, textStatus, jqXHR) {
			const now = new Date();
			$('.dbTime').text(now.format('yyyy-MM-dd HH:mm:ss'));

			$('#viewNotice').modal('hide');
			getNoticeList(1);
		}).fail(function (jqXHR, textStatus, errorThrown) {
			console.error(jqXHR);
			console.error(textStatus);
			console.error(errorThrown);
		});
	}

	function rtnDropdown($dropdownId) {
		if ($dropdownId == 'level') {
			if($('#level button').data('value') == '2') {
				getSpcData();
				$('#spc_id').parent().removeClass('hidden');
			} else {
				$('#spc_id').parent().addClass('hidden');
				dropDownInit($('#spc_id'));
			}
		}
	}

	function setRemoveFileList(fileId, idx){
		var jsonList =  $('#'+fileId).data('gridJsonData');

		jsonList.splice(idx, 1);
		setMakeList(jsonList, fileId, {'dataFunction' : {}});
	}

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

<div class="modal fade" id="addNotice" tabindex="-1" role="dialog" aria-labelledby="addNotice" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-lg no-flex">
		<form id="addNoticeForm" name="addNoticeForm" autocomplete="off">
			<div class="modal-content">
				<div class="modal-header stit">
					<h2>공지 사항 작성</h2>
				</div>
				<div class="modal-body">
					<form id="noticeForm" action="#" method="post" name="noticeForm" novalidate>
						<div class="row">
							<div class="col-12">
								<div class="input-group inline-flex">
									<label for="subject" class="input-label">제목</label>
									<input type="text" id="subject" class="input text-input-type w-100" name="subject" placeholder="입력" autocomplete="off">
								</div>
								<div class="input-group inline-flex top">
									<label for="contents" class="input-label">내용</label>
									<textarea name="contents" id="contents" class="textarea w-100"></textarea>
								</div>
							</div>
						</div>
						<div class="row mt-8">
							<div class="col-lg-6 col-sm-12">
								<div class="input-group inline-flex">
									<h2 class="input-label">공개 범위</h2>
									<div class="dropdown w-100" id="level">
										<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="공개 범위 선택">
											공개 범위 선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" id="levelList">
											<li data-value="0">
												<a href="javascript:void(0)">전체</a>
											</li>
											<c:if test="${activateSPC eq true}">
											<li data-value="1">
												<a href="javascript:void(0)">자산 운용사</a>
											</li>
											<li data-value="2">
												<a href="javascript:void(0)">SPC 담당 사무수탁사</a>
											</li>
											</c:if>
										</ul>
									</div>
								</div>
							</div>
							<div class="col-lg-6 col-sm-12">
								<div class="input-group inline-flex hidden">
									<h2 class="input-label">SPC 선택</h2>
									<div class="dropdown w-100" id="spc_id">
										<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="SPC 선택">
											SPC 선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" id="spcList">
											<li data-value="[spc_id]">
												<a href="javascript:void(0)">[name]</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12">
								<div class="input-group flex-align-top">
									<h2 class="input-label">첨부 파일</h2>
									<input type="file" id="spc_notice_file" class="hidden" name="spc_notice_file" accept=".gif, .jpg, .png" multiple="">
									<label for="spc_notice_file" class="btn file-upload ml-20">파일 선택</label>
									<div class="file_list ml-16"><ul><li class="upload-text"></li></ul></div>
									<div class="file_list ml-16" id="modi_attachement_info">
										<p class="text-file">
											<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
											<button type="button" class="btn-type07" onclick="setRemoveFileList('modi_attachement_info', [INDEX]);">삭제</button>
										</p>
									</div>
								</div>
							</div>
						</div>
					</form>
					<div class="btn-wrap-type02">
						<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
						<c:if test="${userInfo.task eq 2 or userInfo.role eq 1}">
						<button type="button" class="btn-type" id="addBtn">완료</button>
						</c:if>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>

<div class="modal fade" id="viewNotice" tabindex="-1" role="dialog" aria-labelledby="viewNotice" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-lg no-flex">
		<div class="modal-content">
			<div class="modal-header mb-10">
				<h2>공지 사항 상세</h2>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-12">
						<div class="input-group inline-flex">
							<h2 class="input-label">제목</h2>
							<div id="view_subject"></div>
						</div>
						<div class="input-group inline-flex top">
							<h2 class="input-label">내용</h2>
							<pre id="view_contents"></pre>
						</div>
					</div>
				</div>
				<div class="row mt-8">
					<div class="col-lg-6 col-sm-12">
						<div class="input-group inline-flex">
							<h2 class="input-label">공개 범위</h2>
							<div id="view_level"></div>
						</div>
					</div>
					<div class="col-lg-6 col-sm-12">
						<div class="input-group inline-flex">
							<h2 class="input-label">SPC 선택</h2>
							<div id="view_spc_name"></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-12">
						<div class="input-group flex-align-top">
							<h2 class="input-label">첨부 파일</h2>
							<div class="file_list ml-16" id="view_attachement_info">
								<p class="text-file">
									<a href="${apiHost}/files/download/[fieldname]?oid=${sessionScope.userInfo.oid}&orgFilename=[originalname]">[originalname]</a>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="btn-wrap-type02">
					<c:if test="${userInfo.task eq 2 or userInfo.role eq 1}">
					<button type="button" class="btn-type04" id="delBtn">삭제</button>
					</c:if>
					<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">닫기</button>
					<c:if test="${userInfo.task eq 2 or userInfo.role eq 1}">
					<button type="button" class="btn-type" id="chgBtn">수정</button>
					</c:if>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">공지 사항</h1>
	</div>
</div>
<div class="row">
	<div class="col-10">
		<div class="flex-start">
			<div class="text-input-type mr-12">
				<input type="text" id="search" name="search" placeholder="입력" onKeyDown="pressEnter()">
			</div>
			<button type="button" class="btn-type" onclick="noticeTable.ajax.reload();">검색</button>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="indiv supplementary-docs">
			<div class="btn-wrap-type01">
				<c:if test="${userInfo.task eq 2 or userInfo.role eq 1}">
					<button type="button" class="btn-type big" onclick="modalOpen()">작성</button>
				</c:if>
			</div>
			<table id="noticeTable" class="chk-type">
				<colgroup>
					<col style="width:15%">
					<col style="width:40%">
					<col style="width:12%">
					<col style="width:15%">
					<col style="width:18%">
					<col>
				</colgroup>
			</table>
		</div>
	</div>
</div>