
$(document).ready(function() {
		getDBData();
	});
	
	function getDBData() {
		getCmpyList(1); // 회사 목록 조회(회사table 생성 시 주석 해제)
		getGroupList(1); // 그룹 목록 조회
		getSiteList(1); // 사이트 목록 조회
	}
	
	// 회사 목록 조회
	function callback_getCmpyList(result) {
		var cmpyList = result.list;
		
		var strHtml = "";
		$tbody = $("#cmpyTbody");
		$tbody.empty();
		if(cmpyList == null || cmpyList.length < 1) {
			$tbody.append( '<tr><td colspan="5">조회된 데이터가 없습니다.</td><tr>' );
			$('#CmpyPaging').empty();
		} else {
			for(var i=0; i<cmpyList.length; i++) {
				var device_stat = (cmpyList[i].device_stat == 1) ? "connect" : "disconnect";
				$tbody.append(
						$('<tr />').append( $("<td />").append( cmpyList[i].rnum ) // no
						).append( $("<td />").append( cmpyList[i].comp_name ) // 회사명
						).append( $("<td />").append( cmpyList[i].comp_id ) // 회사id
						).append( // 관리
								$("<td />").append(
										'<a href="#;" onclick="updateCmpyForm(\''+cmpyList[i].comp_idx+'\');" class="default_btn">수정</a>'+
										'<a href="#;" onclick="deleteCmpyYn(\''+cmpyList[i].comp_idx+'\');" class="cancel_btn">삭제</a>'
								)
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "Cmpy");
			
		}
		
	}
	
	// 그룹 목록 조회
	function callback_getGroupList(result) {
		var grpList = result.list;
		
		$tbody = $("#grpTbody");
		$tbody.empty();
		if(grpList == null || grpList.length < 1) {
			$tbody.append( '<tr><td colspan="5">조회된 데이터가 없습니다.</td><tr>' );
			$('#GroupPaging').empty();
		} else {
			for(var i=0; i<grpList.length; i++) {
				var device_stat = (grpList[i].device_stat == 1) ? "connect" : "disconnect";
				$tbody.append(
						$('<tr />').append( $("<td />").append( grpList[i].rnum ) // no
						).append( $("<td />").append( grpList[i].site_grp_name ) // 그룹명
						).append( $("<td />").append( grpList[i].site_grp_id ) // 그룹id(내일 생성해야함)
						).append( $("<td />").append( grpList[i].cmpy_nm ) // 고객사
						).append( // 관리
								$("<td />").append(
										'<a href="#;" onclick="updateGroupForm(\''+grpList[i].site_grp_idx+'\');" class="default_btn">수정</a>'+
										'<a href="#;" onclick="deleteGroupYn(\''+grpList[i].site_grp_idx+'\');" class="cancel_btn">삭제</a>'
								)
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "Group");
			
		}
		
	}
	
	// 사이트 목록 조회
	function callback_getSiteList(result) {
		var siteList = result.list;
		
		$tbody = $("#siteTbody");
		$tbody.empty();
		if(siteList == null || siteList.length < 1) {
			$tbody.append( '<tr><td colspan="7">조회된 데이터가 없습니다.</td><tr>' );
			$('#SitePaging').empty();
		} else {
			for(var i=0; i<siteList.length; i++) {
				var device_stat = (siteList[i].device_stat == 1) ? "connect" : "disconnect";
				$tbody.append(
						$('<tr />').append( $("<td />").append( siteList[i].rnum ) // no
						).append( $("<td />").append( siteList[i].site_name ) // 사이트명
						).append( $("<td />").append( siteList[i].site_id ) // 사이트id
						).append( $("<td />").append( siteList[i].site_grp_name ) // 그룹
						).append( $("<td />").append( siteList[i].local_ems_addr ) // local ems 주소
						).append( $("<td />").append( siteList[i].device_list ) // 등록장치
						).append( // 관리
								$("<td />").append(
										'<a href="#;" onclick="updateSiteForm(\''+siteList[i].site_id+'\');" class="default_btn">수정</a>'+
										'<a href="#;" onclick="deleteSiteYn(\''+siteList[i].site_id+'\');" class="cancel_btn">삭제</a>'
								)
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "Site");
			
		}
		
	}

	var insUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	$( function () {
		$("#insertCmpyFormBtn").click(function(){
			insUpdFlag = 1;
			popupOpen('dcompany');
		});
		
		$("#grpMngFormBtn").click(function(){
			getGroupPopupList();
			popupOpen('dgroup');
		});

		$("#confirmSiteInSiteGrpBtn").click(function(){
			if(confirm("저장하시겠습니까?")) {
				var inputs = $(".inside_site input[name=siteIds]");
				var values = "";
				$.each(inputs, function (index, value) {
					values = values+$(value).val()+",";
				});
				$("#newSiteIds").val("");
				$("#newSiteIds").val( (values == "") ? "" : values.slice(0, -1) );
				var formData = $("#editSiteInSiteGrpForm").serializeObject();
				saveSiteInSiteGrp(formData);
			}
		});

		$("#cancelSiteInSiteGrpBtn, #cancelSiteInSiteGrpBtnX").click(function(){
			popupClose('dgroup');
			
			$('#editSiteInSiteGrpForm').each(function() {
				this.reset();
			});
			$(".inside_site").find("ul").empty();
			$('.all_site').find("ul").empty();
			$("#selGrpBox").empty().append("---그룹선택---").append( $('<span class="caret" />') );
			$("#grpSelectBox").find("ul").empty();
			
		});
		
		$("#insertGrpFormBtn").click(function(){
			insUpdFlag = 1;
			$(".dgroup_add").find('h2').empty().append("신규 그룹 등록");
			popupOpen('dgroup_add');
		});
		
		$("#insertSiteFormBtn").click(function(){
			insUpdFlag = 1;
			
			$('#siteForm').each(function() {
				this.reset();
			});
			$("#userIdx").val( "1" );
			
			$.ajax({
				url : "/getGroupPopupList",
				type : 'post',
				async : false, // 동기로 처리해줌
//				data : {
//					selPageNum : ""
//				},
				success: function(result) {
					var list = result.list;
					
					$siteIdSelBox = $("#siteForm").find("#siteGrpIdx");
					$siteIdSelBox.empty();
					$siteIdSelBox.append('<option value="">---그룹선택---</option>');
					for(var i=0; i<list.length; i++) {
						$siteIdSelBox.append('<option value="'+list[i].site_grp_idx+'">'+list[i].site_grp_name+'</option>');
						
					}
				}
			});
			
			popupOpen('dsite');
		});
		
		$("#confirmCmpyBtn").click(function(){
			var formData = $("#cmpyForm").serializeObject();
			if(confirm("회사를 저장하시겠습니까?")) {
				if(insUpdFlag ==  1) insertCmpy(formData);
				else if(insUpdFlag ==  2)  updateCmpy(formData);
			}
		});
		
		$("#confirmGrpBtn").click(function(){
			var formData = $("#groupForm").serializeObject();
			if(confirm("그룹을 저장하시겠습니까?")) {
				if(insUpdFlag ==  1) insertGroup(formData);
				else if(insUpdFlag ==  2)  updateGroup(formData);
			}
		});
		
		$("#siteGrpImg").change(function() {
	        $("#fileChangeYn").val("Y");
	    });
		
		$("#confirmSiteBtn").click(function(){
			var formData = $("#siteForm").serializeObject();
			if(confirm("사이트를 저장하시겠습니까?")) {
				if(insUpdFlag ==  1) insertSite(formData);
				else if(insUpdFlag ==  2)  updateSite(formData);
			}
		});

		$("#cancelCmpyBtn").click(function(){
			insUpdFlag = 0;
			$('#cmpyForm').each(function() {
				this.reset();
			});
			
			popupClose('dcompany');
		});
		
		$("#cancelGrpBtn").click(function(){
			popupClose('dgroup_add');
			if(insUpdFlag == 2) {
				$('#mask').hide();
			}
			
			insUpdFlag = 0;
			$('#groupForm').each(function() {
				this.reset();
			});
			
			$("#userIdx").val( "1" );
//			$(".control-fileupload").empty().append('<label for="file">Choose a file :</label><input type="file" id="siteGrpImg" name="siteGrpImg">');
		});
		
		$("#cancelSiteBtn, #cancelSiteBtnX").click(function(){
			insUpdFlag = 0;
			$("#siteForm").find("#siteId").attr("readonly", false);
			$('#siteForm').each(function() {
				this.reset();
			});
			$("#userIdx").val( "1" );
			
			popupClose('dsite');
		});
	});

	function callback_insertCmpy(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}

	function updateCmpyForm(compIdx) {
		insUpdFlag = 2;
		getCmpyDetail(compIdx);
	}

	// 회사 한건 조회
	function callback_getCmpyDetail(result) {
		var cmpyDetail = result.detail;
		
		if(cmpyDetail == null) {
			alert("조회된 데이터가 없습니다.");
//			location.href = "/siteMain";
		} else {
			$("#compIdx").val( cmpyDetail.comp_idx );
			$("#compName").val( cmpyDetail.comp_name );
			$("#compId").val( cmpyDetail.comp_id );
			
			popupOpen('dcompany');
		}
		
	}

	function callback_updateCmpy(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
	function deleteCmpyYn(compIdx) {
		if(confirm("삭제하시겠습니까?")) {
			deleteCmpy(compIdx);
		}
	}

	function callback_deleteCmpy(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("삭제되었습니다.");
			location.reload();
		} else {
			alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
	function callback_getGroupPopupList(result) {
		var groupList = result.list;
		
		$selectBox = $("#grpSelectBox");
		$selectBox.find("ul").empty();
		if(groupList == null || groupList.length < 1) {
//			$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
		} else {
			for(var i=0; i<groupList.length; i++) {
				$selectBox.find("ul").append(
						$("<li />").append('<a href="javascript:changeSelGrp(\''+groupList[i].site_grp_idx+'\', \''+groupList[i].site_grp_name+'\');">'+groupList[i].site_grp_name+'</a>')
				);
				
			}
			
		}
		
	}
	
	function changeSelGrp(siteGrpIdx, siteGrpName) {
		$("#selSiteGrpIdx").val(siteGrpIdx);
		$("#selGrpBox").empty().append(siteGrpName).append( $('<span class="caret" />') );
		
		getSitePopupList(siteGrpIdx);
	}
	
	function callback_getSitePopupList(result) {
		var grpSiteList = result.grpSiteList;
		var allSiteList = result.allSiteList;
		
		$insideSite = $(".inside_site");
		$insideSite.find("ul").empty();
		var sites = "";
		if(grpSiteList == null || grpSiteList.length < 1) {
//			$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
		} else {
			for(var i=0; i<grpSiteList.length; i++) {
				sites = sites+grpSiteList[i].site_id+",";
				$insideSite.find("ul").append(
						$("<li />").append('<a href="#;">'+grpSiteList[i].site_name+'</a>').append(
								'<input type="hidden" name="siteIds" value="'+grpSiteList[i].site_id+'">'
						)
				);
				
			}
			
		}
		$("#nowSiteIds").val("");
		$("#nowSiteIds").val( (sites == "") ? "" : sites.slice(0, -1) );
		
		$allSite = $(".all_site");
		$allSite.find("ul").empty();
		if(allSiteList == null || allSiteList.length < 1) {
//			$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
		} else {
			for(var i=0; i<allSiteList.length; i++) {
				$allSite.find("ul").append(
						$("<li />").append('<a href="#;">'+allSiteList[i].site_name+'</a>').append(
								'<input type="hidden" name="siteIds" value="'+allSiteList[i].site_id+'">'
						)
				);
				
			}
			
		}

	    $(".multi_select a").click(function() {
	        $(this).toggleClass("on");
	        return false;
	    });
		
	}

	function saveSiteInSiteGrp(formData) {
		$.ajax({
			url : "/saveSiteInSiteGrp",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultCnt = result.resultCnt;
				var changeYn = result.changeYn;
				
				if(changeYn == "N") {
					alert("저장되었습니다.");
					location.reload();
					
				} else if(changeYn == "Y") {
//					if(resultCnt > 0) {
						alert("저장되었습니다.");
						location.reload();
//					} else {
//						alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
//					}
				}
				
			}
		});
	}

	function callback_insertGroup(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
	function updateGroupForm(siteGrpIdx) {
		insUpdFlag = 2;
		getGroupDetail(siteGrpIdx);
	}

	// 그룹 한건 조회
	function callback_getGroupDetail(result) {
		var groupDetail = result.detail;
		
		if(groupDetail == null) {
			alert("조회된 데이터가 없습니다.");
//			location.href = "/siteMain";
		} else {
			$(".dgroup_add").find('h2').empty().append("그룹 수정");
			$("#groupForm").find("#siteGrpIdx").val( groupDetail.site_grp_idx );
			$("#groupForm").find("#userIdx").val( groupDetail.user_idx );
			$("#groupForm").find("#siteGrpName").val( groupDetail.site_grp_name );
			$("#groupForm").find("#siteGrpId").val( groupDetail.site_grp_id );
			$("#groupForm").find("#fileNameTag").empty().append( groupDetail.site_grp_img_rname );
			
			$("#groupForm").find("#fileChangeYn").val( "N" );
			
			popupOpen('dgroup_add');
//			$('#mask').hide();
		}
		
	}
	
	function popupColseChk() {
		popupClose('dgroup_add');
		if(insUpdFlag == 2) {
			$('#mask').hide();
		}
	}

	function callback_updateGroup(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
	function deleteGroupYn(siteGrpIdx) {
		if(confirm("삭제하시겠습니까?")) {
			deleteGroup(siteGrpIdx);
		}
	}

	function callback_deleteGroup(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("삭제되었습니다.");
			location.reload();
		} else {
			alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}

	function callback_insertSite(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}

	function updateSiteForm(siteId) {
		insUpdFlag = 2;
		getSiteDetail(siteId);
	}

	// 사이트 한건 조회
	function callback_getSiteDetail(result) {
		var siteDetail = result.detail;
		
		if(siteDetail == null) {
			alert("조회된 데이터가 없습니다.");
//			location.href = "/siteMain";
		} else {
			$.ajax({
				url : "/getGroupPopupList",
				type : 'post',
				async : false, // 동기로 처리해줌
				data : {
					selPageNum : ""
				},
				success: function(result) {
					var list = result.list;
					
					$siteIdSelBox = $("#siteForm").find("#siteGrpIdx");
					$siteIdSelBox.empty();
					$siteIdSelBox.append('<option value="">---그룹선택---</option>');
					for(var i=0; i<list.length; i++) {
						$siteIdSelBox.append('<option value="'+list[i].site_grp_idx+'">'+list[i].site_grp_name+'</option>');
						
					}
				}
			});
			
			$("#siteForm").find("#siteGrpIdx").val( siteDetail.site_grp_idx );
			$("#siteForm").find("#userIdx").val( siteDetail.user_idx );
			$("#siteForm").find("#siteName").val( siteDetail.site_name );
			$("#siteForm").find("#siteId").val( siteDetail.site_id );
			$("#siteForm").find("#siteId").attr("readonly", true);
			$("#siteForm").find("#areaType").val( siteDetail.area_type );
			$("#siteForm").find("#localEmsAddr").val( siteDetail.local_ems_addr );
			$("#siteForm").find("#localEmsKey").val( siteDetail.local_ems_key );
			
			popupOpen('dsite');
		}
		
	}

	function callback_updateSite(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
	function deleteSiteYn(siteId) {
		if(confirm("삭제하시겠습니까?")) {
			deleteSite(siteId);
		}
	}

	function callback_deleteSite(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("삭제되었습니다.");
			location.reload();
		} else {
			alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
