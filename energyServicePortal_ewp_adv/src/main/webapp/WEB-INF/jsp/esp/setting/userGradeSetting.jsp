<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	let etcTable = null;
	$(function() {
		$.ajax({
			url: apiHost + '/config/custom-level/',
			type: 'GET',
			data: {
				oid: oid
			}
		}).done((data, textStatus, jqXHR) => {
			console.log(data);
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});

		$('.nav-tabs a').on('click', function() {
			const tab = $(this).attr('href');
			$('.tab-content small').addClass('hidden');

			if (/group/.test(tab)) {
				getGroupList();
			} else if (/spc/.test(tab)) {
				getSpcList();
			} else {
				getSiteList();
			}
		});

		etcTable = $('#etcTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			scrollX: true,
			scrollY: '720px',
			scrollCollapse: true,
			sortable: true,
			paging: false,
			columns: [
				{
					sTitle: '구분',
					mData: 'type',
					className: 'dt-center',
					mRender: function ( data, type, full, rowIndex ) {
						let text = '';
						if (data === 'site') {
							text = '발전소';
						} else if(data === 'spc') {
							text = 'SPC';
						} else {
							if (/tag/.test(data)) {
								text = '그룹';
							} else {
								text = 'VPP';
							}
						}
						return text;
					}
				},
				{
					sTitle: '이름',
					mData: 'name',
					className: 'dt-center'
				},
				{
					sTitle: '권한',
					mData: 'grade',
					mRender: function ( data, type, full, rowIndex ) {
						let temp = ``;
						if (data === 'management') {
							temp = `<button type="button" class="btn-type-sm btn-type03">관리 권한</button>`;
						} else {
							temp = `<button type="button" class="btn-type-sm btn-type03">조회 권한</button>`;
						}
						temp += `<button type="button" class="btn-close" data-value="${'${full.code}'}"></button>`;
						return temp;
					},
					className: 'dt-center'
				},
				{
					sTitle: '코드',
					mData: 'code',
					className: 'dt-center',
					visible: false
				},
			],
			language: {
				emptyTable: '조회된 데이터가 없습니다.',
				zeroRecords:  '검색된 결과가 없습니다.',
				infoEmpty: '',
				paginate: {
					previous: '',
					next: '',
				},
				info: '_PAGE_ - _PAGES_ ' + ' / 총 _TOTAL_ 개',
			},
			dom: 'tp'
		});

		getGroupList();
		getMenuList();
	});

	$(document).on('click', ':checkbox[name="menu"]', function() {
		const parent = $(this).data('parent')
			, menuCode = $(this).attr('id').replace('menu-', '');

		if ($(this).is(':checked')) {
			if (isEmpty(parent)) {
				if ($(this).val() === 'all') {
					$(':checkbox[name="menu"]').prop('checked', true);
				} else {
					let subMenuCnt = 0, subMenuChkCnt = 0;
					$(':checkbox[name="menu"]').each(function() {
						if (!isEmpty($(this).data('parent'))) {
							subMenuCnt++;
							if ($(this).is(':checked')) subMenuChkCnt++;
						}
					});

					if (subMenuCnt === subMenuChkCnt) {}
				}
			} else {
				let subMenuCnt = 0, subMenuChkCnt = 0;
				$(':checkbox[name="menu"]').each(function() {
					if ($(this).data('parent') === parent) {
						subMenuCnt++;
						if ($(this).is(':checked')) subMenuChkCnt++;
					}
				});

				if (subMenuCnt === subMenuChkCnt) {
					$(':checkbox[name="menu"][value="' + parent + '"]').prop('checked', true);
				}
			}
		} else {
			if (isEmpty(parent)) {
				if ($(this).val() === 'all') {
					$(':checkbox[name="menu"]').prop('checked', false);
				} else {
					let subMenuCnt = 0, subMenuChkCnt = 0;
					$(':checkbox[name="menu"]').each(function() {
						if (!isEmpty($(this).data('parent'))) {
							subMenuCnt++;
							if ($(this).is(':checked')) subMenuChkCnt++;
						}
					});

					if (subMenuCnt === subMenuChkCnt) {

					}
				}
			} else {

			}
		}

		if (isEmpty(parent)) {
			if ($(this).val() === 'all') {
				$(':checkbox[name="menu"]').prop('checked', true);
			} else {
				$(':checkbox[name="menu"]').each(function() {
					const dataParent = $(this).data('parent');
					if (!isEmpty(dataParent) && menuCode === dataParent) {
						$(this).prop('checked', true);
					}
				});
			}
		} else {
			if ($(':checkbox[name="menu"][value="all"]').is(':checked')) {
				$(':checkbox[name="menu"][value="all"]').prop('checked', false);
			}

			$(':checkbox[name="menu"][id="menu-' + parent + '"]').prop('checked', false);
		}
	});

	$(document).on('click', '.btn-close', function() {
		const value = $(this).data('value');
		if (!isEmpty(value)) {
			const tableList = etcTable.rows().data().toArray();
			let rowIndex = '';
			tableList.forEach((data, index) => {
				if (data.code === value) {
					rowIndex = index;
				}
			});

			etcTable.rows(rowIndex).remove().draw();
		}
	});

	const getGroupList = () => {
		$.ajax({
			url: apiHost + '/auth/me/groups?includeSites=false&includeDevices=false',
			type: 'GET',
			data: { oid: oid }
		}).done((data, textStatus, jqXHR) => {
			let optList = ``;
			let groupList = data.tag_group;
			let vppList = data.vpp_group;

			if (!isEmpty(groupList)) {
				groupList.forEach(li => {
					optList += `<li data-value="${'${li.sgid}'}" data-type="tag"><a href="javascript:void(0);">${'${li.name}'}</a></li>`;
				});
			}

			if (!isEmpty(vppList)) {
				vppList.forEach(li => {
					optList += `<li data-value="${'${li.vgid}'}" data-type="vpp"><a href="javascript:void(0);">${'${li.name}'}</a></li>`;
				});
			}

			$('#groupOptList').empty().append(optList);
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	const getSpcList = () => {
		$.ajax({
			url: apiHost + '/spcs',
			type: 'GET',
			data: { oid: oid }
		}).done((data, textStatus, jqXHR) => {
			let optList = ``;
			if (!isEmpty(data.data)) {
				data.data.forEach(li => {
					optList += `<li data-value="${'${li.spc_id}'}"><a href="javascript:void(0);">${'${li.name}'}</a></li>`;
				});
			} else {
				optList += `<li>선택가능한 항목이 없습니다.</li>`;
			}
			$('#spcOptList').empty().append(optList);
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	const getSiteList = () => {
		$.ajax({
			url: apiHost + '/config/sites',
			type: 'GET',
			data: { oid: oid }
		}).done((data, textStatus, jqXHR) => {
			let optList = ``;
			if (!isEmpty(data)) {
				data.forEach(li => {
					optList += `<li data-value="${'${li.sid}'}"><a href="javascript:void(0);">${'${li.name}'}</a></li>`;
				});
			} else {
				optList += `<li>선택가능한 항목이 없습니다.</li>`;
			}
			$('#siteOptList').empty().append(optList);
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	const getMenuList = () => {
		$.ajax({
			url: apiHost + '/config/custom-level/menu-list',
			type: 'GET',
			data: {}
		}).done((data, textStatus, jqXHR) => {
			const menuList = data.data;
			if (!isEmpty(menuList) && menuList) {
				let menuTemp = ``;
				menuTemp = `
					<input type="checkbox" id="all-menu" name="menu" value="all">
					<label class="custom-checkbox" for="all-menu">전체</label>
				`;
				menuList.forEach(menu => {
					let menuName = JSON.parse(menu.name);
					let menuCode = menu.code;

					if (menu.parent === null) {
						let subMenuList = ``;
						menuList.forEach(subMenu => {
							if (menuCode === subMenu.parent) {
								let subName = JSON.parse(subMenu.name);
								subMenuList += `
									<li>
										<input type="checkbox" id="menu-${'${subMenu.code}'}" name="menu" data-parent="${'${subMenu.parent}'}" value="${'${subMenu.code}'}">
										<label class="custom-checkbox" for="menu-${'${subMenu.code}'}">${'${subName.kr}'}</label>
									</li>
								`;
							}
						});

						menuTemp += `
							<div class="panel panel-default no-border">
								<div class="panel-heading no-padding" role="tab">
									<h4 class="panel-title">
										<input type="checkbox" id="menu-${'${menu.code}'}" name="menu" value="${'${menu.code}'}">
										<label class="custom-checkbox" for="menu-${'${menu.code}'}">${'${menuName.kr}'}</label>
										<a href="#tab-${'${menu.code}'}" role="button" data-toggle="collapse" data-parent="#panelGroup" aria-expanded="false" aria-controls="collapseOne" class="panel-fold"></a>
									</h4>
								</div>
								<div id="tab-${'${menu.code}'}" class="panel-collapse collapse" role="tabpanel">
									<div class="panel-body no-padding">
										<ul>
											${'${subMenuList}'}
										</ul>
									</div>
								</div>
							</div>
						`;
					}
				});
				$('#menuList').empty().append(menuTemp);
			}
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	const addList = () => {
		const addRow = new Array();
		const activeTab = $('.nav-tabs li.active a').attr('href');
		let type = '', name = '', code = '', duplication = false;

		$('.tab-content small').addClass('hidden');
		if (/group/.test(activeTab)) {
			code = $('#groupOpt button').data('value');
			name = $('#groupOpt button').text();
			type = 'group-' + $('#groupOpt button').data('type');
		} else if (/spc/.test(activeTab)) {
			code = $('#spcOpt button').data('value');
			name = $('#spcOpt button').text();
			type = 'spc';
		} else {
			code = $('#siteOpt button').data('value');
			name = $('#siteOpt button').text();
			type = 'site';
		}

		const tableData = etcTable.rows().data().toArray();
		if (tableData.length > 0) {
			tableData.forEach(data => {
				if (data.type === type && data.code === code) {
					if (/group/.test(activeTab)) {
						$('#isGroupSelected').removeClass('hidden');
						duplication = true;
						return false;
					} else if (/spc/.test(activeTab)) {
						$('#isSpcSelected').removeClass('hidden');
						duplication = true;
						return false;
					} else {
						$('#isSiteSelected').removeClass('hidden');
						duplication = true;
						return false;
					}
				}
			});
		}

		if (!duplication) {
			addRow.push({
				type: type,
				code: code,
				name: name,
				grade: $(':radio[name="gradeType"]:checked').val()
			});

			etcTable.rows.add(addRow).draw();
		}
	}

	const addCustomLevel = () => {
		const cstNm = $('#customName').val().trim();
		if (isEmpty(cstNm)) {
			$('#isCustomNameEmpty').removeClass('hidden');
			return false;
		} else {
			$('#isCustomNameEmpty').addClass('hidden');
		}

		if ($(':checkbox[name="menu"]:checked').length === 0) {
			alert('메뉴 권한 설정을 선택해 주세요.');
			return false;
		}

		$.ajax({
			url: apiHost + '/config/custom-level?oid=' + oid,
			type: 'POST',
			data: JSON.stringify({
				name: cstNm,
				description: ''
			}),
			contentType: 'application/json; charset=UTF-8'
		}).done((data, textStatus, jqXHR) => {
			console.log(data);
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}
</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">사용자 관리 설정</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-2 col-md-4 col-sm-6 pvGen-right">
		<div class="indiv chart-pv scroll">
			<div> 사용자 등급<button class="btn-type06"></button></div>
			<h2 class="ntit"></h2>
		</div>
	</div>

	<div class="col-lg-10 col-md-8 col-sm-6">
		<div class="indiv">
			<div class="row">
				<div class="w-25">
					<div class="w-90">
						<h2 class="sm-title">등급 이름</h2>
						<div class="text-input-type mt-20">
							<input type="text" id="customName" name="customName" placeholder="입력" autocomplete="off">
							<small id="isCustomNameEmpty" class="warning hidden">등급 이름을 입력해주세요.</small>
						</div>

						<h2 class="sm-title mt-30">구분</h2>
						<ul class="nav nav-tabs">
							<li class="active w-33"><a data-toggle="tab" href="#groupTab">그룹</a></li>
							<li class="w-33"><a data-toggle="tab" href="#spcTab">SPC</a></li>
							<li class="w-33"><a data-toggle="tab" href="#siteTab">발전소</a></li>
						</ul>

						<div class="tab-content">
							<div id="groupTab" class="tab-pane fade in active">
								<div id="groupOpt" class="dropdown w-100 mt-10">
									<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="groupOptList" class="dropdown-menu"></ul>
								</div>
								<small id="isGroupEmpty" class="warning hidden">추가하실 그룹을 선택해 주세요.</small>
								<small id="isGroupSelected" class="warning hidden">동일한 그룹이 이미 추가 되었습니다.</small>
							</div>

							<div id="spcTab" class="tab-pane fade in">
								<div id="spcOpt" class="dropdown w-100 mt-10">
									<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="spcOptList" class="dropdown-menu"></ul>
								</div>
								<small id="isSpcEmpty" class="warning hidden">추가하실 그룹을 선택해 주세요.</small>
								<small id="isSpcSelected" class="warning hidden">동일한 그룹이 이미 추가 되었습니다.</small>
							</div>

							<div id="siteTab" class="tab-pane fade in">
								<div id="siteOpt" class="dropdown w-100 mt-10">
									<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="siteOptList" class="dropdown-menu"></ul>
								</div>
								<small id="isSiteEmpty" class="warning hidden">추가하실 그룹을 선택해 주세요.</small>
								<small id="isSiteSelected" class="warning hidden">동일한 그룹이 이미 추가 되었습니다.</small>
							</div>
						</div>

						<h2 class="sm-title mt-30">권한</h2>
						<div class="flex-end mt-10">
							<div class="radio-type">
								<input type="radio" id="grade1" name="gradeType" value="management" checked="">
								<label for="grade1">관리 권한</label>
							</div>
							<div class="radio-type">
								<input type="radio" id="grade2" name="gradeType" value="search">
								<label for="grade2">조회 권한</label>
							</div>
						</div>


						<div class="flex-end mt-20">
							<button type="button" class="btn-type big" onclick="addList();">추가</button>
						</div>
					</div>
				</div>
				<div class="w-55 pr-20">
					<h2 class="sm-title mb-10">추가 목록</h2>
					<table id="etcTable" style="min-width: 500px !important;">
						<colgroup>
							<col style="width:25%">
							<col style="width:25%">
							<col style="width:50%">
						</colgroup>
						<thead></thead>
						<tbody></tbody>
					</table>
				</div>
				<div class="w-20">
					<h2 class="sm-title mb-10">메뉴 권한 설정</h2>
					<div id="menuList" class="chk-type w-100" sytle="margin-top: -40px"></div>
				</div>
			</div>
			<div class="row">
				<div class="btn-wrap-type-r mt-20">
					<button type="button" class="btn-type03 big" onclick="alert('초기화 함수 생성');">취소</button>
					<button type="button" class="btn-type big" onclick="addCustomLevel();">저장</button>
				</div>
			</div>
		</div>

	</div>
</div>