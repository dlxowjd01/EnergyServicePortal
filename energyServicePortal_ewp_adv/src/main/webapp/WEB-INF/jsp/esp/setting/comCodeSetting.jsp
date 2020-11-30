<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	$(function () {
		getPropertyData();
	});



	function getPropertyData(callbackOption) {
		let option = {
			// url: apiHost + "/common/code?oid=" + oid + "&includeCodes=true",
			url: apiHost + "/common/code?oid=" + oid,
			type: 'get',
			async: true,
		}
		makeAjaxCall(option, callbackOption ).then(res => {
			let lang = $("html").attr("lang");
			let str = ``;

			
			if(!isEmpty(res.data) && res.data.length > 0){
				console.log("res111===", res);
				res.data.forEach((item, index, arr) => {
					// dvcCategory : 디바이스 상위 카테고리
					let dvcCategory = (lang == "en") ? item.name.en :  item.name.kr;
					let dvcNameStr = ``;

					/* // dvcList: 카테고리 하위 디바이스 리스트
					let dvcList; 아직 미정(api update 후 적용)
					dvcList.forEach((item, index) => {
						dvcNameStr += `
						<a href="#collapseOne" role="button" class="">${'${  }'}</a>
						`
					});
					*/

					str += `
						<div class="panel panel-default">
							<div class="panel-heading active" role="tab" id="heading_${'${ index + 1 }'}">
								<h4 class="panel-heading">
									${'${ dvcCategory }'}
									<a href="#collapseOne" role="button" data-toggle="collapse" data-parent="#panelGroup" aria-expanded="true" aria-controls="collapseOne" class="panel-fold"></a>
								</h4>
							</div>
							<div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby=id="heading_${'${ index + 1 }'}">
								<div class="panel-body">

								</div>
							</div>
						</div>
					`;

				});
				$("#panelGroup").append(str);
			} else {
				console.log("res222===", res);

				str = `
					<div class="panel panel-default">
						<div class="panel-heading no-data active" role="tab">
							<h4 class="panel-heading ">디바이스 정보가 없습니다.</h4>
						</div>
					</div>
				`;
				$("#panelGroup").append(str);
			}
			// if(!isEmpty(callbackOption)) {

			// }
		});

	}


</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">공통 코드 관리</h1>
	</div>
</div>

<div class="row">
	<div class="col-3">
		<div class="panel-group" id="panelGroup" role="tablist" aria-multiselectable="true"></div>
	</div>
	<div class="col-9">
		<div class="indiv">
			<h2 class="tx-tit"></h2>
			<table id="comCodeTable">
				<colgroup>
					<col style="width:5%">
					<col style="width:12%">
					<col style="width:16%">
					<col style="width:5%">
					<col style="width:6%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:12%">
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
			<div class="modal-header"><h1>공통 코드 추가</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<form name="add_group_form" id="updateGroupForm" class="setting-form" autocomplete="off">
						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label asterisk">그룹 유형</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newGroupType" class="dropdown-menu">
										<li data-name="사업소 그룹" data-value="tag_group"><a href="#">사업소 그룹</a></li>
										<li data-name="VPP 그룹" data-value="vpp_group"><a href="#">VPP 그룹</a></li>
					 					<!-- <li data-name="DR 그룹" data-value="dr_group"><a href="#">DR 그룹</a></li> -->
									</ul>
								</div>
								<small class="hidden warning">그룹 유형을 선택해 주세요</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40 hidden"><span class="input-label asterisk">거래 ID</span></div>
							<div id="resIdWrapper" class="col-xl-4 col-lg-4 col-md-4 col-sm-12 hidden">
								<div class="text-input-type"><input type="text" id="newResId" name="new_res_id" /></div>
								<small class="hidden warning">거래 ID를 입력해 주세요.</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label asterisk">그룹 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="flex-start">
									<div class="text-input-type offset-width">
										<input type="text" name="new_group_name" id="newGroupName" placeholder="입력" minlength="2" maxlength="15">
									</div>
									<button type="button" id="checkGroupBtn" class="btn-type fr" disabled>중복 체크</button>
								</div>
								<small class="hidden warning">추가하실 그룹을 입력해 주세요</small>
								<small class="hidden warning">2~15 글자를 입력해 주세요.</small>
								<small class="hidden warning">특수 문자는 포함될 수 없습니다.</small>
								<small id="invalidGroup" class="hidden warning">이미 등록되어 있는 그룹 입니다.</small>
								<small id="validGroup" class="text-blue text-sm hidden">추가 가능한 그룹 입니다.</small>
							</div>

							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12 pl-40 hidden"><span class="input-label asterisk">그룹 공유</span></div>
							<div id="shareOptGroup" class="col-xl-4 col-lg-4 col-md-4 col-sm-12 hidden">
								<div class="radio-type flex-start">
									<div class="radio-group">
										<input type="radio" id="shareOpt1" name="share_option" data-value="1" data-option-val="true">
										<label for="shareOpt1">예</label>
									</div>
									<div class="radio-group">
										<input type="radio" id="shareOpt2" name="share_option" data-value="0" data-option-val="false">
										<label for="shareOpt2">아니오</label>
									</div>
								</div>
								<small class="hidden warning">그룹 공유 값을 선택해 주세요.</small>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label">사업소 명</span></div>
							<div class="col-xl-4 col-lg-4 col-md-4 col-sm-12">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle no-close" data-toggle="dropdown" data-name="선택">선택<span class="caret"></span></button>
									<ul id="newSiteList" class="dropdown-menu chk-type">
									</ul>
								</div>
								<!-- <small class="hidden warning">사업소를 선택해 주세요</small> -->
							</div>

							<div class="col-xl-6 col-lg-6 col-md-6 col-sm-12">
								<ul id="selectedSiteList" class="selected-list"></ul>
							</div>
						</div>

						<div class="row">
							<div class="col-xl-2 col-lg-2 col-md-2 col-sm-12"><span class="input-label">추가 정보</span></div>
							<div class="col-xl-10 col-lg-10 col-md-10 col-sm-12">
								<textarea name="new_site_desc" id="newGroupDesc" class="textarea" placeholder="입력"></textarea>
							</div>
						</div>

						<div class="row">
							<div class="col-12">
								<div class="btn-wrap-type02">
									<button type="button" class="btn-type03" data-dismiss="modal" aria-label="Close">취소</button>
									<button type="submit" id="addGroupBtn" class="btn-type" disabled>추가</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
