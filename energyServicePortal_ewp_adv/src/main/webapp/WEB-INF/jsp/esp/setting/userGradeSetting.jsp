<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script type="text/javascript">
	let etcTable = null;
	$(function() {
		$('.nav-tabs a').on('click', function() {
			const tab = $(this).attr('href');
			$('.tab-content input').val('');
			$('.tab-content small').addClass('hidden');
			$('.tab-content div.dropdown button').removeData('value').html('선택 <span class="caret"></span>');

			if (/group/.test(tab)) { getGroupList(); }
			else if (/spc/.test(tab)) { getSpcList(); }
			else { getSiteList(); }
		});

		etcTable = $('#etcTable').DataTable({
			autoWidth: true,
			fixedHeader: true,
			scrollX: true,
			scrollY: '684px',
			scrollCollapse: true,
			sortable: true,
			paging: false,
			columns: [
				{
					sTitle: '구분',
					mData: 'kind',
					className: 'dt-center',
					mRender: function ( data, type, full, rowIndex ) {
						let text = '';
						if (data === 1) {
							text = '발전소';
						} else if(data === 2) {
							text = 'SPC';
						} else {
							text = '그룹';
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
					mData: 'role',
					mRender: function ( data, type, full, rowIndex ) {
						let temp = ``;
						if (data === 1) {
							temp = `<button type="button" class="btn-type-sm btn-type03">관리 권한</button>`;
						} else {
							temp = `<button type="button" class="btn-type-sm btn-type03">조회 권한</button>`;
						}
						temp += `<button type="button" class="btn-close" data-value="${'${full.id}'}"></button>`;
						return temp;
					},
					className: 'dt-center'
				},
				{
					sTitle: '코드',
					mData: 'id',
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

		getCustomLevel();
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
					$(':checkbox[name="menu"]').each(function() {
						if (!isEmpty($(this).data('parent')) && menuCode === $(this).data('parent')) {
							$(this).prop('checked', true);
						}
					});
				}
			} else {
				let subMenuCnt = 0, subMenuChkCnt = 0;
				$(':checkbox[name="menu"]').each(function() {
					if ($(this).data('parent') === parent) {
						subMenuCnt++;
						if ($(this).is(':checked')) subMenuChkCnt++;
					}
				});

				if (subMenuChkCnt > 0) {
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
						if (!isEmpty($(this).data('parent')) && menuCode === $(this).data('parent')) {
							$(this).prop('checked', false);
						}
					});
				}
			} else {
				let subMenuCnt = 0, subMenuChkCnt = 0;
				$(':checkbox[name="menu"]').each(function() {
					if ($(this).data('parent') === parent) {
						subMenuCnt++;
						if ($(this).is(':checked')) subMenuChkCnt++;
					}
				});

				if (subMenuChkCnt === 0) {
					$(':checkbox[name="menu"][value="' + parent + '"]').prop('checked', false);
				}
			}
		}
	});

	$(document).on('click', '#comDeleteBtn', function() {
		const deleteSite = $('#comDeleteModal').data('value');
		$.ajax({
			url: apiHost + '/config/custom-level/' + deleteSite + '?oid=' + oid,
			type: 'DELETE'
		}).done((data, textStatus, jqXHR) => {
			if (data.info.count >= 1) {
				errorMsg('삭제가 완료되엇습니다.');
				return false;
			} else {
				errorMsg('삭제가 된 항목이 없습니다.');
				return false;
			}
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
			errorMsg('삭제중 오류가 발생했습니다.');
			return false;
		}).always(() => {
			$('#comDeleteModal').modal('hide').removeData('value');
			$('#confirmTitle').val('');

			getCustomLevel();
		});
	});

	$(document).on('click', '#custom-level .grade-block', function() {
		const targetId = $(this).data('levelid')
			, targetNm = $(this).find('span').text();
		$(this).addClass('actived').siblings().removeClass('actived');

		pageInit();

		$('#customName').val(targetNm);
		$('#addLevel').attr('onclick', 'addCustomLevel("PATCH");').text('수정');
		getUserMenuList(targetId);
		getUserSiteList(targetId);
	});

	$(document).on('click', '#custom-level .grade-block .del', function() {
		const targetId = $(this).parent().data('levelid');
		deleteCustomLevel(targetId);
	});

	$(document).on('click', '#etcTable tbody tr td', function(e) {
		if (e.target.classList.contains('btn-type03')) {
			if (etcTable.cell(this).data() === 1) {
				etcTable.cell(this).data(2);
				$(this).find('button.btn-type03').text('조회 권한');
			} else {
				etcTable.cell(this).data(1);
				$(this).find('button.btn-type03').text('관리 권한');
			}
		} else if (e.target.classList.contains('btn-close')) {
			const value = this.children[1].dataset.value;
			if (!isEmpty(value)) {
				const tableList = etcTable.rows().data().toArray();
				let rowIndex = '';
				tableList.forEach((data, index) => {
					if (data.id === value) {
						rowIndex = index;
					}
				});

				etcTable.row(':eq(' + rowIndex + ')').remove().draw();
			}
		}
	});

	const selectInit =() => {
		$('#custom-level .grade-block').removeClass('actived');
	}

	const pageInit = () => {
		$('#customName').val('');
		$('#isCustomNameEmpty').addClass('hidden');
		$('.tab-content input').val('');
		$('.tab-content small').addClass('hidden');
		$('.tab-content div.dropdown button').removeData('value').html('선택 <span class="caret"></span>');

		$('#addLevel').attr('onclick', 'addCustomLevel("POST");').text('등록');
		$('.nav-tabs li:eq(0)').trigger('click');
		etcTable.clear().draw();
		$('#menuList input').prop('checked', false);
		$('#menuList h4.panel-title a').attr('aria-expanded', true);
		$('#menuList div.panel-collapse').attr('aria-expanded', true).addClass('in').removeAttr('style');
	}

	const getCustomLevel = () => {
		$.ajax({
			url: apiHost + '/config/custom-level/',
			type: 'GET',
			data: {
				oid: oid
			}
		}).done((data, textStatus, jqXHR) => {
			let temp = ``;
			(data.data).forEach(custom => {
				temp += `
					<div class="grade-block" data-levelid="${'${custom.level_id}'}">
						<span>${'${custom.name}'}</span>
						<img src="/img/delete.svg" alt="" class="del" />
					</div>
				`;
			});

			$('#custom-level').find('.grade-block').remove();
			$('#custom-level').append(temp);
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
			errorMsg('처리중 오류가 발생했습니다.');
			return false;
		});
	}

	const getUserMenuList = (levelId) => {
		$.ajax({
			url: apiHost + '/config/custom-level/menu',
			type: 'GET',
			data: {
				oid: oid,
				level_id: levelId
			}
		}).done((data, textStatus, jqXHR) => {
			if (!isEmpty(data.data)) {
				(data.data).forEach(data => {
					const menuCode = data.menu_code;
					$(':checkbox[name="menu"][value="' + menuCode + '"]').prop('checked', true).data('have', true);
				});
			}
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	const getUserSiteList = (levelId) => {
		$.ajax({
			url: apiHost + '/config/custom-level/ids',
			type: 'GET',
			data: {
				oid: oid,
				level_id: levelId
			}
		}).done((data, textStatus, jqXHR) => {
			if (!isEmpty(data.data)) {
				etcTable.rows.add(data.data).draw();
				$('#etcTable').data('standard', data.data);
			}
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	const getGroupList = () => {
		$.ajax({
			url: apiHost + '/auth/me/groups?includeSites=true&includeDevices=false',
			type: 'GET',
			data: { oid: oid }
		}).done((data, textStatus, jqXHR) => {
			let optList = ``;
			let groupList = data.tag_group;
			let vppList = data.vpp_group;

			if (!isEmpty(groupList)) {
				groupList.forEach(li => {
					optList += `
						<li data-value="${'${li.sgid}'}" data-type="tag">
							<a href="javascript:void(0);">${'${li.name}'}</a>
						</li>
					`;
				});
			} else {
				optList += `<li><a href="javascript:void(0);">선택가능한 항목이 없습니다.</a></li>`;
			}

			if (!isEmpty(vppList)) {
				vppList.forEach(li => {
					optList += `
						<li data-value="${'${li.vgid}'}" data-type="vpp">
							<a href="javascript:void(0);">${'${li.name}'}</a>
						</li>
					`;
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
				optList += `<li><a href="javascript:void(0);">선택가능한 항목이 없습니다.</a></li>`;
			}
			$('#spcOptList').empty().append(optList);
			$('#spcOptList').prepend('<div class="dropdown-search"><input type="text" placeholder="발전소 검색" onkeyup="searchSite($(this).val())"></div>');
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
				optList += `<li><a href="javascript:void(0);">선택가능한 항목이 없습니다.</a></li>`;
			}
			$('#siteOptList').empty().append(optList);
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	const searchSite = (keyword, type) => {
		const liList = $('#' + type + 'OptList > li');

		liList.each(function() {
			if (($(this).text().trim()).includes(keyword)) {
				$(this).removeClass('hidden');
			} else {
				$(this).addClass('hidden');
			}
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
					let isChecked = '';
					if (menuCode === 'dashboard') isChecked = 'checked';

					if (menu.parent === null) {
						let subMenuList = ``;
						let subDownButton = ``;
						let subDownSection = ``;
						menuList.forEach(subMenu => {
							if (menuCode === subMenu.parent) {
								let subName = JSON.parse(subMenu.name);
								let isSubChecked = '';
								if (subMenu.code === 'gmain') isSubChecked = 'checked';
								subMenuList += `
									<li>
										<input type="checkbox" id="menu-${'${subMenu.code}'}" name="menu" data-parent="${'${subMenu.parent}'}" ${'${isSubChecked}'} value="${'${subMenu.code}'}">
										<label class="custom-checkbox" for="menu-${'${subMenu.code}'}">${'${subName.kr}'}</label>
									</li>
								`;
							}
						});

						if (!isEmpty(subMenuList)) {
							subDownButton = `<a href="#tab-${'${menu.code}'}" role="button" data-toggle="collapse" data-parent="#panelGroup" aria-expanded="true" aria-controls="tab-${'${menu.code}'}" class="panel-fold"></a>`;
							subDownSection = `
								<div id="tab-${'${menu.code}'}" class="panel-collapse collapse in" role="tabpanel" aria-expanded="true">
										<div class="panel-body no-padding">
										<ul>
											${'${subMenuList}'}
										</ul>
									</div>
								</div>
							`;
						} else {
							subDownButton = ``;
							subDownSection = ``;
						}

						menuTemp += `
							<div class="panel panel-default no-border">
								<div class="panel-heading no-padding" role="tab">
									<h4 class="panel-title">
										<input type="checkbox" id="menu-${'${menu.code}'}" name="menu" ${'${isChecked}'} value="${'${menu.code}'}">
										<label class="custom-checkbox" for="menu-${'${menu.code}'}">${'${menuName.kr}'}</label>
										${'${subDownButton}'}
									</h4>
								</div>
								${'${subDownSection}'}
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
		const tableData = etcTable.rows().data().toArray();
		const role = Number($(':radio[name="gradeType"]:checked').val());
		let type = '', name = '', code = '', duplication = false;

		$('.tab-content small').addClass('hidden');
		if (/group/.test(activeTab)) {
			code = $('#groupOpt button').data('value');
			name = $('#groupOpt button').text();
			type = 3;

			if (isEmpty(code)) { $('#isGroupEmpty').removeClass('hidden'); return false; }
		} else if (/spc/.test(activeTab)) {
			code = $('#spcOpt button').data('value');
			name = $('#spcOpt button').text();
			type = 2;

			if (isEmpty(code)) { $('#isSpcEmpty').removeClass('hidden'); return false; }
		} else {
			code = $('#siteOpt button').data('value');
			name = $('#siteOpt button').text();
			type = 1;

			if (isEmpty(code)) {
				$('#isSiteEmpty').removeClass('hidden'); return false;
			} else {
				const duplication = tableData.find(e => e.kind === type && e.id === code);
				if (isEmpty(duplication)) {
					addRow.push({
						kind: type,
						id: code,
						name: name,
						role: role
					});

					etcTable.rows.add(addRow).draw();
				} else {
					errorMsg('중복된 발전소가 존재합니다.');
					return false;
				}
			}
		}

		if (type === 3) {
			$.ajax({
				url: apiHost + '/auth/me/groups?includeSites=true&includeDevice=false&addCapacity=false',
				type: 'GET',
			}).done((data, textStatus, jqXHR) => {
				let siteList = new Array();
				let groupList = data.tag_group;
				let vppList = data.vpp_group;

				if (!isEmpty(groupList)) {
					groupList.forEach(li => {
						if (li.sgid === code) {
							siteList = li.sites;
						}
					});
				}

				if (!isEmpty(vppList)) {
					vppList.forEach(li => {
						if (li.vgid === code) {
							siteList = li.sites;
						}
					});
				}

				if (!isEmpty(siteList)) {
					siteList.forEach(site => {
						const duplication = tableData.find(e => e.kind === 1 && e.id === site.sid);
						if (isEmpty(duplication)) {
							addRow.push({
								kind: 1,
								id: site.sid,
								name: site.name,
								role: role
							});
						}
					});
				}

				etcTable.rows.add(addRow).draw();
			}).fail((jqXHR, textStatus, errorThrown) => {
				console.error(textStatus);
			});
		} else if (type === 2) {
			$.ajax({
				url: apiHost + '/spcs/' + code + '/gens?oid=' + oid,
				type: 'GET',
			}).done((data, textStatus, jqXHR) => {
				const siteList = data.data;
				if (!isEmpty(siteList)) {
					siteList.forEach(site => {
						const duplication = tableData.find(e => e.kind === 1 && e.id === site.gen_id);
						if (isEmpty(duplication)) {
							addRow.push({
								kind: 1,
								id: site.gen_id,
								name: site.name,
								role: role
							});
						}
					});
				}

				etcTable.rows.add(addRow).draw();
			}).fail((jqXHR, textStatus, errorThrown) => {
				console.error(textStatus);
			});
		}
	}

	const addCustomLevel = (method) => {
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

		new Promise((resolve, reject) => {
			let apiUrl = apiHost + '/config/custom-level?oid=' + oid;
			if (method === 'PATCH') {
				let levelId = $('.grade-block.actived').data('levelid');
				apiUrl = apiHost + '/config/custom-level/' + levelId + '?oid=' + oid;
			}

			$.ajax({
				url: apiUrl,
				type: method,
				data: JSON.stringify({
					name: cstNm,
					description: ''
				}),
				contentType: 'application/json; charset=UTF-8'
			}).done((data, textStatus, jqXHR) => {
				resolve(data);
			}).fail((jqXHR, textStatus, errorThrown) => {
				console.error(textStatus);
				console.error(errorThrown);

				reject('등록에 실패했습니다.');
			});
		}).then(resolve => {
			let levelId = resolve.level_id;
			if (method === 'PATCH') levelId = $('.grade-block.actived').data('levelid');
			const registerApi = new Array();
			const menuList = new Array();
			const deleteMenu = new Array();
			const siteList = etcTable.rows().data().toArray();
			const deleteSite = new Array();

			$(':checkbox[name="menu"]').each(function() {
				if ($(this).is(':checked')) {
					menuList.push({
						level_id: levelId,
						menu_code: $(this).val()
					});
				} else {
					if ($(this).data('have') === true) {
						deleteMenu.push({
							level_id: levelId,
							menu_code: $(this).val()
						});
					}
				}
			});

			if (siteList.length > 0) {
				siteList.forEach(site => {
					site['level_id'] = levelId;
					delete site['name'];
				});

				const standard = $('#etcTable').data('standard');
				if (!isEmpty(standard)) {
					standard.forEach(std => {
						const target = siteList.find(e => e.kind === std.kind && e.id === std.id);
						if (isEmpty(target)) deleteSite.push(std);
					});
				}
			}

			registerApi.push(
				$.ajax({
					url: apiHost + '/config/custom-level/menu',
					type: 'POST',
					data: JSON.stringify({
						update: menuList,
						delete: deleteMenu
					}),
					contentType: 'application/json; charset=UTF-8'
				})
			);

			registerApi.push(
				$.ajax({
					url: apiHost + '/config/custom-level/ids',
					type: 'POST',
					data: JSON.stringify({
						update: siteList,
						delete: deleteSite
					}),
					contentType: 'application/json; charset=UTF-8'
				})
			)

			Promise.all(registerApi).then(response => {
				getCustomLevel();
				pageInit();

				if(method === 'PATCH') {
					errorMsg('수정되었습니다.');
				} else {
					errorMsg('등록되었습니다.');
				}

				return false;
			}).catch(error => {
				reject('등록에 실패했습니다.');
			});
		}).catch(error => {
			errorMsg(error);
		});
	}

	const deleteCustomLevel = (levelId) => {
		let modal = $('#comDeleteModal');
		$('#comDeleteSuccessMsg span').text('삭제');
		modal.find('.modal-body').removeClass('hidden');
		modal.modal('show');
		modal.data('value', levelId);

		$('#confirmTitle').on('input keyp', function() {
			if($(this).val() !== '삭제') {
				$('#comDeleteBtn').prop('disabled', true);
			} else {
				$('#comDeleteBtn').prop('disabled', false);
			}
		});
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

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">사용자 관리 설정</h1>
	</div>
</div>

<div class="row" id="userGradeSettingWrap">
	<div class="col-lg-2 col-md-4 col-sm-6 pvGen-right">
		<div id="custom-level" class="indiv chart-pv scroll">
			<div class="title-block"> <span>사용자 등급</span> <button class="btn-type06" onclick="pageInit(); selectInit();"></button> </div>
		</div>
	</div>

	<div class="col-lg-10 col-md-8 col-sm-6">
		<div class="indiv">
			<div class="row" style="margin: 0;">
				<div class="w-25">
					<div>
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
									<div class="dropdown-search w-100"><input type="text" placeholder="그룹 검색" onkeyup="searchSite($(this).val(), 'group')"></div>
									<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="groupOptList" class="dropdown-menu" style="top:75px; width:260px; height:300px;"></ul>
								</div>
								<small id="isGroupEmpty" class="warning hidden">추가하실 그룹을 선택해 주세요.</small>
								<small id="isGroupSelected" class="warning hidden">동일한 그룹이 이미 추가 되었습니다.</small>
							</div>

							<div id="spcTab" class="tab-pane fade in">
								<div id="spcOpt" class="dropdown w-100 mt-10">
									<div class="dropdown-search w-100"><input type="text" placeholder="SPC 검색" onkeyup="searchSite($(this).val(), 'spc')"></div>
									<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="spcOptList" class="dropdown-menu" style="top:75px; width:260px; height:300px;"></ul>
								</div>
								<small id="isSpcEmpty" class="warning hidden">추가하실 그룹을 선택해 주세요.</small>
								<small id="isSpcSelected" class="warning hidden">동일한 그룹이 이미 추가 되었습니다.</small>
							</div>

							<div id="siteTab" class="tab-pane fade in">
								<div id="siteOpt" class="dropdown w-100 mt-10">
									<div class="dropdown-search w-100"><input type="text" placeholder="발전소 검색" onkeyup="searchSite($(this).val(), 'site')"></div>
									<button type="button" class="dropdown-toggle w-100" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="siteOptList" class="dropdown-menu" style="top:75px; width:260px; height:300px;"></ul>
								</div>
								<small id="isSiteEmpty" class="warning hidden">추가하실 그룹을 선택해 주세요.</small>
								<small id="isSiteSelected" class="warning hidden">동일한 그룹이 이미 추가 되었습니다.</small>
							</div>
						</div>

						<h2 class="sm-title mt-30">권한</h2>
						<div class="flex-start mt-10 auth">
							<div class="radio-type">
								<input type="radio" id="grade1" name="gradeType" value="1" checked="">
								<label for="grade1">관리 권한</label>
							</div>
							<div class="radio-type">
								<input type="radio" id="grade2" name="gradeType" value="2">
								<label for="grade2">조회 권한</label>
							</div>
						</div>


						<div class="flex-end mt-20">
							<button type="button" class="btn-type big" onclick="addList();">추가</button>
						</div>
					</div>
				</div>
				<div class="w-55 pr-20 ugs-table-wrap">
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
				<div class="w-20 ugs-menu-setting">
					<h2 class="sm-title mb-10">메뉴 권한 설정</h2>
					<div id="menuList" class="chk-type w-100" sytle="margin-top: -40px"></div>
				</div>
			</div>
			<div class="row">
				<div class="btn-wrap-type-r">
					<button type="button" class="btn-type03 big" onclick="location.href='/setting/userSetting.do'">취소</button>
					<button type="button" class="btn-type big" onclick="addCustomLevel('POST₩');" id="addLevel">저장</button>
				</div>
			</div>
		</div>

	</div>
</div>

<link type="text/css" rel="stylesheet" href="/css/userGradeSetting.css" />