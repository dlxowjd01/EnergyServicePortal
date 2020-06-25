<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		navAddClass("setting");
		getUserInfo(setUserInfo);
		getDBData();
	});
	
	var userInfo = null;
	function setUserInfo(result) {
		userInfo = result;
	}
	
	function getDBData() {
		var authType = userInfo.auth_type;
		if(authType === '1') {
			getCmpyList(1); // 회사 목록 조회
		} 
		if(authType === '1' || authType === '2') {
			getGroupList(1); // 그룹 목록 조회
		}
		if(authType === '1' || authType === '2' || authType === '3') {
			getSiteList(1); // 사이트 목록 조회
		}
		
	}

	// 회사 목록 조회
	function getCmpyList(selPageNum) {
	    $.ajax({
	        url: "/system/getCmpyList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            selPageNum: selPageNum
	        },
	        success: function (result) {
	        	var cmpyList = result.list;
	    		
	    		var strHtml = "";
	    		$tbody = $("#cmpyTbody");
	    		$tbody.empty();
	    		if(cmpyList != null && cmpyList.length > 0) {
	    			for(var i=0; i<cmpyList.length; i++) {
	    				var device_stat = (cmpyList[i].device_stat === 1) ? "connect" : "disconnect";
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
	    		} else {
	    			$tbody.append( '<tr><td colspan="5">조회 결과가 없습니다.</td><tr>' );
	    			$('#CmpyPaging').empty();
	    		}
	        }
	    });
	}

	// 그룹 목록 조회
	function getGroupList(selPageNum) {
	    $.ajax({
	        url: "/system/getGroupList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            selPageNum: selPageNum
	        },
	        success: function (result) {
	        	var grpList = result.list;
	    		
	    		$tbody = $("#grpTbody");
	    		$tbody.empty();
	    		if(grpList != null && grpList.length > 0) {
	    			for(var i=0; i<grpList.length; i++) {
	    				var device_stat = (grpList[i].device_stat === 1) ? "connect" : "disconnect";
	    				$tbody.append(
	    						$('<tr />').append( $("<td />").append( grpList[i].rnum ) // no
	    						).append( $("<td />").append( grpList[i].site_grp_name ) // 그룹명
	    						).append( $("<td />").append( grpList[i].site_grp_id ) // 그룹id(내일 생성해야함)
	    						).append( $("<td />").append( grpList[i].comp_name ) // 고객사
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
	    		} else {
	    			$tbody.append( '<tr><td colspan="5">조회 결과가 없습니다.</td><tr>' );
	    			$('#GroupPaging').empty();
	    		}
	        }
	    });
	}

	// 사이트 목록 조회
	function getSiteList(selPageNum) {
	    $.ajax({
	        url: "/system/getSiteList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            selPageNum: selPageNum
	        },
	        success: function (result) {
	        	var siteList = result.list;
	    		
	    		$tbody = $("#siteTbody");
	    		$tbody.empty();
	    		if(siteList != null && siteList.length > 0) {
	    			for(var i=0; i<siteList.length; i++) {
	    				var device_stat = (siteList[i].device_stat === 1) ? "connect" : "disconnect";
	    				$tbody.append(
	    						$('<tr />').append( $('<td />').append( siteList[i].rnum ) // no
	    						).append( $('<td />').append( siteList[i].site_name ) // 사이트명
	    						).append( $('<td />').append( siteList[i].site_id ) // 사이트id
	    						).append( $('<td />').append( siteList[i].site_grp_name ) // 그룹
	    						).append( $('<td />').append( siteList[i].local_ems_addr ) // local ems 주소
	    						).append( $('<td class="ellipsis mxw500" />').append( siteList[i].device_type_nms ) // 등록장치
	    						).append( // 관리
	    								$('<td />').append(
	    										'<a href="#;" onclick="updateSiteForm(\''+siteList[i].site_id+'\');" class="default_btn">수정</a>'+
	    										'<a href="#;" onclick="deleteSiteYn(\''+siteList[i].site_id+'\');" class="cancel_btn">삭제</a>'
	    								)
	    						)
	    				);
	    			}

	    			var pagingMap = result.pagingMap;
	    			makePageNums2(pagingMap, "Site");
	    		} else {
	    			$tbody.append( '<tr><td colspan="7">조회 결과가 없습니다.</td><tr>' );
	    			$('#SitePaging').empty();
	    		}
	        }
	    });
	}
	
	var insUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	$( function () {
		$("#insertCmpyFormBtn").click(function(){
			insUpdFlag = 1;
			$(".dcompany").find('h2').empty().append("신규 회사 등록");
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
				var $newSiteIds = $("#newSiteIds");
				$newSiteIds.val("");
				$newSiteIds.val( ( isEmpty(values) ) ? "" : values.slice(0, -1) );
				var formData = $("#editSiteInSiteGrpForm").serializeObject();
				saveSiteInSiteGrp(formData, "confirm");
			}
		});
		
		$("#applySiteInSiteGrpBtn").click(function(){
			if(confirm("저장하시겠습니까?")) {
				var inputs = $(".inside_site input[name=siteIds]");
				var values = "";
				$.each(inputs, function (index, value) {
					values = values+$(value).val()+",";
				});
				var $newSiteIds = $("#newSiteIds");
				$newSiteIds.val("");
				$newSiteIds.val( ( isEmpty(values) ) ? "" : values.slice(0, -1) );
				var formData = $("#editSiteInSiteGrpForm").serializeObject();
				saveSiteInSiteGrp(formData, "apply");
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
			cmpyPopupFlag = 1;
			getCmpyPopupList(); // 회사목록 조회
			$("#detailImg").hide();
			$("#insertImg").show();
			$("#groupForm").find(".glyphicon-remove").hide();
			$("#br").hide();
			popupOpen('dgroup_add');
		});
		
		$("#insertSiteFormBtn").click(function(){
			insUpdFlag = 1;
			$(".dsite").find('h2').empty().append("신규 사이트 등록");
			cmpyPopupFlag = 2;
			getCmpyPopupList(); // 회사목록 조회
			$('#siteForm').each(function() {
				this.reset();
			});
			$("#userIdx").val( "1" );
			
			popupOpen('dsite');
		});
		
		$("#confirmCmpyBtn").click(function(){
			var $cmpyForm = $("#cmpyForm");
			if( isEmpty($cmpyForm.find("#compName").val()) ) {
				alert("회사명을 입력하세요");
				$cmpyForm.find("#compName").focus();
				return;
			}
			if( isEmpty($cmpyForm.find("#compId").val()) ) {
				alert("회사ID를 입력하세요");
				$cmpyForm.find("#compId").focus();
				return;
			}
			
			var formData = $cmpyForm.serializeObject();
			if(confirm("회사를 저장하시겠습니까?")) {
				if(insUpdFlag ===  1) insertCmpy(formData);
				else if(insUpdFlag ===  2)  updateCmpy(formData);
			}
		});
		
		$("#confirmGrpBtn").click(function(){
			var $groupForm = $("#groupForm");
			if( isEmpty($groupForm.find("#selCompIdx1").val()) ) {
				alert("회사를 선택하세요");
				$groupForm.find("#selCompIdx1").focus();
				return;
			}
			if( isEmpty($groupForm.find("#siteGrpName").val()) ) {
				alert("그룹명을 입력하세요");
				$groupForm.find("#siteGrpName").focus();
				return;
			}
			if( isEmpty($groupForm.find("#siteGrpId").val()) ) {
				alert("그룹ID를 입력하세요");
				$groupForm.find("#siteGrpId").focus();
				return;
			}
			
			var formData = $groupForm.serializeObject();
			if(confirm("그룹을 저장하시겠습니까?")) {
				if(insUpdFlag ===  1) insertGroup(formData);
				else if(insUpdFlag ===  2)  updateGroup(formData);
			}
		});
		
		$("#siteGrpImg").change(function() {
	        $("#fileChangeYn").val("Y");
	    });
		
		$("#confirmSiteBtn").click(function(){
			var $siteForm = $("#siteForm");
			if( isEmpty($siteForm.find("#siteName").val()) ) {
				alert("사이트명을 입력하세요");
				$siteForm.find("#siteName").focus();
				return;
			}
			if( isEmpty($siteForm.find("#siteId").val()) ) {
				alert("사이트id를 입력하세요");
				$siteForm.find("#siteId").focus();
				return;
			}
			if( isEmpty($siteForm.find("#selCompIdx2").val()) ) {
				alert("회사를 선택하세요");
				$siteForm.find("#selCompIdx2").focus();
				return;
			}
			if( isEmpty($siteForm.find("#areaType").val()) ) {
				alert("지역을 선택하세요");
				$siteForm.find("#areaType").focus();
				return;
			}

			var formData = $siteForm.serializeObject();
			if(confirm("사이트를 저장하시겠습니까?")) {
				if(insUpdFlag ===  1) insertSite(formData);
				else if(insUpdFlag ===  2)  updateSite(formData);
			}
		});
	
		$("#cancelCmpyBtn, #cancelCmpyBtnX").click(function(){
			insUpdFlag = 0;
			$('#cmpyForm').each(function() {
				this.reset();
			});
			
			popupClose('dcompany');
		});
		
		$("#cancelGrpBtn, #cancelGrpBtnX").click(function(){
			popupClose('dgroup_add');
			if(insUpdFlag === 2) {
				$('#mask').hide();
			}
			
			cmpyPopupFlag = 0;
			insUpdFlag = 0;
			var $groupForm = $('#groupForm');
			$groupForm.each(function() {
				this.reset();
			});

			$groupForm.find(".glyphicon-remove").show();
			$("#br").show();
			$("#userIdx").val( "1" );
		});
		
		$("#cancelSiteBtn, #cancelSiteBtnX").click(function(){
			cmpyPopupFlag = 0;
			insUpdFlag = 0;
			var $siteForm = $("#siteForm");
			$siteForm.find("#siteId").attr("readonly", false);
			$siteForm.each(function() {
				this.reset();
			});
			$("#userIdx").val( "1" );
			
			popupClose('dsite');
		});
	});

	// 회사 등록
	function insertCmpy(formData) {
	    $.ajax({
	        url: "/system/insertCmpy.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function updateCmpyForm(compIdx) {
		insUpdFlag = 2;
		$(".dcompany").find('h2').empty().append("회사 수정");
		getCmpyDetail(compIdx);
	}

	//회사 한건 조회
	function getCmpyDetail(compIdx) {
	    $.ajax({
	        url: "/system/getCmpyDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            compIdx: compIdx
	        },
	        success: function (result) {
	        	var cmpyDetail = result.detail;
	    		
	    		if(cmpyDetail != null) {
	    			$("#compIdx").val( cmpyDetail.comp_idx );
	    			$("#compName").val( cmpyDetail.comp_name );
	    			$("#compId").val( cmpyDetail.comp_id );

	    			popupOpen('dcompany');
	    		} else {
	    			alert("조회 결과가 없습니다.");
	    		}
	        }
	    });
	}

	// 회사 수정
	function updateCmpy(formData) {
	    $.ajax({
	        url: "/system/updateCmpy.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function deleteCmpyYn(compIdx) {
		if(confirm("삭제하시겠습니까?")) {
			deleteCmpy(compIdx);
		}
	}
	
	// 회사 삭제
	function deleteCmpy(compIdx) {
	    $.ajax({
	        url: "/system/deleteCmpy.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            compIdx: compIdx
	        },
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("삭제되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}

	//그룹 목록(팝업) 조회
	function getGroupPopupList() {
	    $.ajax({
	        url: "/system/getGroupPopupList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
//			data : {
//				selPageNum : selPageNum
//			},
	        success: function (result) {
	        	var groupList = result.list;
	    		
	    		var $selectBox = $("#grpSelectBox");
	    		$selectBox.find("ul").empty();
	    		if(groupList != null && groupList.length > 0) {
	    			for(var i=0; i<groupList.length; i++) {
	    				$selectBox.find("ul").append(
	    						$("<li />").append('<a href="javascript:changeSelGrp(\''+groupList[i].site_grp_idx+'\', \''+groupList[i].site_grp_name+'\');">'+groupList[i].site_grp_name+'</a>')
	    				);
	    			}
	    		}
	        }
	    });
	}
	
	function changeSelGrp(siteGrpIdx, siteGrpName) {
		$("#selSiteGrpIdx1").val(siteGrpIdx);
		$("#selGrpBox").empty().append(siteGrpName).append( $('<span class="caret" />') );
		
		getSitePopupList(siteGrpIdx);
	}

	//사이트 목록(팝업) 조회
	function getSitePopupList(siteGrpIdx) {
	    $.ajax({
	        url: "/system/getSitePopupList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            siteGrpIdx: siteGrpIdx
	        },
	        success: function (result) {
	        	var grpSiteList = result.grpSiteList;
	    		var allSiteList = result.allSiteList;
	    		
	    		var $insideSite = $(".inside_site");
	    		$insideSite.find("ul").empty();
	    		var sites = "";
	    		if(grpSiteList != null && grpSiteList.length > 0) {
	    			for(var i=0; i<grpSiteList.length; i++) {
	    				sites = sites+grpSiteList[i].site_id+",";
	    				$insideSite.find("ul").append(
	    						$("<li />").append('<a href="#;">'+grpSiteList[i].site_name+'</a>').append(
	    								'<input type="hidden" name="siteIds" value="'+grpSiteList[i].site_id+'">'
	    						)
	    				);
	    			}
	    		}

	    		var $nowSiteIds = $("#nowSiteIds");
	    		$nowSiteIds.val("");
	    		$nowSiteIds.val( (sites === "") ? "" : sites.slice(0, -1) );
	    		
	    		var $allSite = $(".all_site");
	    		$allSite.find("ul").empty();
	    		if(allSiteList != null && allSiteList.length > 0) {
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
	    });
	}
	
	function saveSiteInSiteGrp(formData, btnGbn) {
		$.ajax({
			url : "/system/saveSiteInSiteGrp.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultCnt = result.resultCnt;
				var changeYn = result.changeYn;
				
				if(changeYn === "N") {
					alert("저장되었습니다.");
					if(btnGbn === "confirm") location.reload();
				} else if(changeYn === "Y") {
					alert("저장되었습니다.");
					if(btnGbn === "confirm") location.reload();
				}
			}
		});
	}
	
	var cmpyPopupFlag = 0; // 1:groupForm, 2:siteForm, 0:reset 
	function getCmpyPopupList() {
		$.ajax({
			url : "/system/getCmpyPopupList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				var list = result.list;

				var $siteIdSelBox;
				if(cmpyPopupFlag === 1) $siteIdSelBox = $("#groupForm").find("#selCompIdx1");
				else if(cmpyPopupFlag === 2) $siteIdSelBox = $("#siteForm").find("#selCompIdx2");
				$siteIdSelBox.empty();
				$siteIdSelBox.append('<option value="">---회사선택---</option>');
				for(var i=0; i<list.length; i++) {
					$siteIdSelBox.append('<option value="'+list[i].comp_idx+'">'+list[i].comp_name+'</option>');
				}
			}
		});
	}
	
	function changeCmpy() {
		var selCmpyIdx = $("#siteForm").find("#selCompIdx2").val();
		getGrpPopupList(selCmpyIdx); // 그룹목록 조회
	}

	// 그룹 등록
	function insertGroup(formData) {
	    var form = new FormData($("#groupForm")[0]);
	    $.ajax({
	        url: "/system/insertGroup.json",
	        type: 'post',
	        processData: false,
	        contentType: false,
//			async : false, // 동기로 처리해줌
	        data: form,
	        success: function (result) {
	            $('.loading').hide();
	            setTimeout(function () {
	            	var resultCnt = result.resultCnt;
	        		var resultMsg = result.resultMsg;
	        		var resultCode = result.resultCode;
	        		
	        		if(resultCode === 0) {
	        			if(resultCnt > 0) {
	        				alert("저장되었습니다.");
	        				location.reload();
	        			} else {
	        				alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	        			}
	        		} else {
	        			alert(resultMsg);
	        		}
	            }, 500);
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        },
	        beforeSend: function () {
	            $('.loading').show();
	        }
	    });
	}
	
	function updateGroupForm(siteGrpIdx) {
		insUpdFlag = 2;
		cmpyPopupFlag = 1;
		getCmpyPopupList(); // 회사목록 조회
		getGroupDetail(siteGrpIdx);
	}

	//그룹 한건 조회
	function getGroupDetail(siteGrpIdx) {
	    $.ajax({
	        url: "/system/getGroupDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            siteGrpIdx: siteGrpIdx
	        },
	        success: function (result) {
	        	var groupDetail = result.detail;
	    		
	    		if(groupDetail != null) {
	    			var $groupForm = $("#groupForm");
	    			$(".dgroup_add").find('h2').empty().append("그룹 수정");
	    			$groupForm.find("#siteGrpIdx").val( groupDetail.site_grp_idx );
	    			$groupForm.find("#userIdx1").val( groupDetail.user_idx );
	    			$groupForm.find("#selCompIdx1").val( groupDetail.comp_idx );
	    			$groupForm.find("#siteGrpName").val( groupDetail.site_grp_name );
	    			$groupForm.find("#siteGrpId").val( groupDetail.site_grp_id );
	    			var imgName = groupDetail.site_grp_img_rname;
	    			$groupForm.find("#fileNameTag").empty().append( imgName );
	    			if( isEmpty(imgName) ) {
	    				$("#detailImg").hide();
	    				$("#insertImg").show();
	    				$groupForm.find(".glyphicon-remove").hide();
	    				$("#br").hide();
	    			} else {
	    				updateImg('N');
	    			}
	    			$groupForm.find("#fileChangeYn").val( "N" );

	    			popupOpen('dgroup_add');
	    		} else {
	    			alert("조회 결과가 없습니다.");
	    		}
	        }
	    });
	}

	function updateImg(flag) {
		if(flag === 'Y') {
			$("#detailImg").hide();
			$("#insertImg").show();
			$("#br").show().css("display",  "block");
		} else {
			$("#detailImg").show();
			$("#insertImg").hide();
			$("#br").hide();
			$("#groupForm").find("#fileChangeYn").val( "N" );
		}
	}
	
	function popupColseChk() {
		popupClose('dgroup_add');
		if(insUpdFlag === 2) {
			$('#mask').hide();
		}
	}

	// 그룹 수정
	function updateGroup(formData) {
	    var form = new FormData($("#groupForm")[0]);
	    $.ajax({
	        url: "/system/updateGroup.json",
	        type: 'post',
	        processData: false,
	        contentType: false,
//			async : false, // 동기로 처리해줌
	        data: form,
	        success: function (result) {
	            $('.loading').hide();
	            setTimeout(function () {
	            	var resultCnt = result.resultCnt;
	        		if(resultCnt > 0) {
	        			alert("저장되었습니다.");
	        			location.reload();
	        		} else {
	        			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	        		}
	            }, 500);
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        },
	        beforeSend: function () {
	            $('.loading').show();
	        }
	    });
	}
	
	function deleteGroupYn(siteGrpIdx) {
		if(confirm("삭제하시겠습니까?")) {
			deleteGroup(siteGrpIdx);
		}
	}

	// 그룹 삭제
	function deleteGroup(siteGrpIdx) {
	    $.ajax({
	        url: "/system/deleteGroup.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            siteGrpIdx: siteGrpIdx
	        },
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("삭제되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function getGrpPopupList(compIdx) {
		$.ajax({
			url : "/system/getGroupPopupList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				compIdx : compIdx
			},
			success: function(result) {
				var list = result.list;
				
				var $siteIdSelBox = $("#siteForm").find("#selSiteGrpIdx2");
				$siteIdSelBox.empty();
				$siteIdSelBox.append('<option value="">---그룹선택---</option>');
				for(var i=0; i<list.length; i++) {
					$siteIdSelBox.append('<option value="'+list[i].site_grp_idx+'">'+list[i].site_grp_name+'</option>');
					
				}
			}
		});
	}

	// 사이트 등록
	function insertSite(formData) {
	    $.ajax({
	        url: "/system/insertSite.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function updateSiteForm(siteId) {
		insUpdFlag = 2;
		cmpyPopupFlag = 2;
		getCmpyPopupList(); // 회사목록 조회
		$(".dsite").find('h2').empty().append("사이트 수정");
		getSiteDetail(siteId);
	}

	//사이트 한건 조회
	function getSiteDetail(siteId) {
	    $.ajax({
	        url: "/system/getSiteDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            siteId: siteId
	        },
	        success: function (result) {
	        	var siteDetail = result.detail;
	    		
	    		if(siteDetail != null) {
	    			getGrpPopupList(siteDetail.comp_idx);

	    			var $siteForm = $("#siteForm");
	    			$siteForm.find("#selSiteGrpIdx2").val( siteDetail.site_grp_idx );
	    			$siteForm.find("#userIdx2").val( siteDetail.user_idx );
	    			$siteForm.find("#siteName").val( siteDetail.site_name );
	    			$siteForm.find("#siteId").val( siteDetail.site_id );
	    			$siteForm.find("#siteId").attr("readonly", true);
	    			$siteForm.find("#selCompIdx2").val( siteDetail.comp_idx );
	    			$siteForm.find("#areaType").val( siteDetail.area_type );
	    			$siteForm.find("#localEmsAddr").val( siteDetail.local_ems_addr );
	    			$siteForm.find("#localEmsKey").val( siteDetail.local_ems_key );
	    			$siteForm.find("#localEmsApiVer").val( siteDetail.local_ems_api_ver );

	    			popupOpen('dsite');
	    		} else {
	    			alert("조회 결과가 없습니다.");
	    		}
	        }
	    });
	}
	
	// 사이트 수정
	function updateSite(formData) {
	    $.ajax({
	        url: "/system/updateSite.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function deleteSiteYn(siteId) {
		if(confirm("사이트에 등록된 장치그룹과 장치도 같이 삭제됩니다. \n삭제하시겠습니까?")) {
			deleteSite(siteId);
		}
	}

	// 사이트 삭제
	function deleteSite(siteId) {
	    $.ajax({
	        url: "/system/deleteSite.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            siteId: siteId
	        },
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("삭제되었습니다.");
	    			location.reload();
	    		} else {
	    			alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
</script>
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">그룹/사이트 관리</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv">
							<c:if test="${userInfo.auth_type eq '1'}">
								<div class="section" id="cmpyDiv">
									<div class="set_top clear">
										<h2 class="ntit fl">회사 현황</h2>
										<ul class="fr">
											<li><a href="#;" class="default_btn" id="insertCmpyFormBtn"><i class="glyphicon glyphicon-plus"></i> 회사 등록</a></li>
										</ul>								
									</div>
									<div class="s_table">
										<table>
											<colgroup>
												<col width="80">
												<col width="150">
												<col>
												<col width="150">
											</colgroup>
											<thead>
												<tr>
													<th>NO</th>
													<th>회사명</th>
													<th>회사ID</th>
													<th>관리</th>
												</tr>
											</thead>
											<tbody id="cmpyTbody">
												<tr>
													<td colspan="4">조회된 데이터가 없습니다.</td>
												</tr>
											</tbody>
										</table>
									</div>	
									<div class="paging clear" id="CmpyPaging">
									</div>	
								</div>								
							</c:if>
							<c:if test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2'}">
								<div class="section" id="grpDiv">
									<div class="set_top clear">
										<h2 class="ntit fl">그룹 현황</h2>
										<ul class="fr">
											<li><a href="#;" class="default_btn" id="grpMngFormBtn"><i class="glyphicon glyphicon-th-list"></i> 그룹 관리</a></li>
										</ul>								
									</div>
									<div class="s_table">
										<table>
											<colgroup>
												<col width="80">
												<col width="150">
												<col width="150">
												<col>
												<col width="150">
											</colgroup>
											<thead>
												<tr>
													<th>NO</th>
													<th>그룹명</th>
													<th>그룹ID</th>
													<th>고객사</th>
													<th>관리</th>
												</tr>
											</thead>
											<tbody id="grpTbody">
												<tr>
													<td colspan="5">조회된 데이터가 없습니다.</td>
												</tr>
											</tbody>
										</table>
									</div>	
									<div class="paging clear" id="GroupPaging">
									</div>	
								</div>								
							</c:if>
							<c:if test="${userInfo.auth_type eq '1' or userInfo.auth_type eq '2' or userInfo.auth_type eq '3'}">
								<div class="section" id="siteDiv">
									<div class="set_top clear">
										<h2 class="ntit fl">사이트 현황</h2>
										<ul class="fr">
											<li><a href="#;" class="default_btn" id="insertSiteFormBtn"><i class="glyphicon glyphicon-plus"></i> 사이트 등록</a></li>
										</ul>								
									</div>
									<div class="s_table">
										<table>
											<colgroup>
												<col width="80">
												<col width="150">
												<col width="150">
												<col width="150">
												<col>
												<col>
												<col width="150">
											</colgroup>
											<thead>
												<tr>
													<th>NO</th>
													<th>사이트명</th>
													<th>사이트ID</th>
													<th>그룹</th>
													<th>Local EMS 주소</th>
													<th>등록장치</th>
													<th>관리</th>
												</tr>
											</thead>
											<tbody id="siteTbody">
												<tr>
													<td colspan="7">조회된 데이터가 없습니다.</td>
												</tr>
											</tbody>
										</table>
									</div>	
									<div class="paging clear" id="SitePaging">
									</div>	
								</div>				
							</c:if>
						</div>
					</div>
				</div>


    <!-- ###### 회사 관리 Popup Start ###### -->
    <div id="layerbox" class="dcompany" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 회사 등록</h2>        	
			<a href="#;" id="cancelCmpyBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl clear">
				<form id="cmpyForm" name="cmpyForm">
					<input type="hidden" name="compIdx" id="compIdx" class="input" value="">
					<table>
						<colgroup>
							<col width="100">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>회사명</span></th>
								<td><input type="text" name="compName" id="compName" class="input" style="width:100%" maxlength="20"></td>
							</tr>
							<tr>
								<th><span>회사ID</span></th>
								<td><input type="text" name="compId" id="compId" class="input" style="width:100%" maxlength="50"></td>
							</tr>
						</tbody>			
					</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmCmpyBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelCmpyBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- ###### 그룹관리 Popup Start ###### -->
    <div id="layerbox" class="dgroup" style="min-width:800px;">
        <div class="stit">
        	<h2>그룹 관리</h2>        	
			<a href="#;" id="cancelSiteInSiteGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="dgrp_top clear">
				<h2 class="ntit fl">그룹명</h2>
				<div class="dropdown fl" id="grpSelectBox">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" id="selGrpBox">---그룹선택---
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
				<a href="#;" class="default_btn fr" id="insertGrpFormBtn"><i class="glyphicon glyphicon-plus"></i> 그룹 추가하기</a>
			</div>
			<div class="group_wrap clear">
				<form id="editSiteInSiteGrpForm" name="editSiteInSiteGrpForm">
					<input type="hidden" id="selSiteGrpIdx1" name="selSiteGrpIdx1">
					<input type="hidden" id="nowSiteIds" name="nowSiteIds">
					<input type="hidden" id="newSiteIds" name="newSiteIds">
					<div class="inside_site fl">
						<h2 class="ntit">그룹 내 사이트</h2>
						<div class="inbox">
							<ul class="multi_select">
							</ul>
						</div>
					</div>
				</form>
				<div class="cross_btn fl">
					<div><a href="#;" id="moveLeft"><img src="../img/btn_cross_left.png" alt="<"></a></div>
					<div><a href="#;" id="moveRight"><img src="../img/btn_cross_right.png" alt=">"></a></div>
				</div>
				<div class="all_site fl">
					<h2 class="ntit">전체 사이트</h2>
					<div class="inbox">
						<ul class="multi_select">
						</ul>
					</div>
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="applySiteInSiteGrpBtn">적용</a>
			<a href="#;" class="default_btn w80" id="confirmSiteInSiteGrpBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelSiteInSiteGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->    

    <!-- ###### 그룹 추가하기 Popup Start ###### -->
    <div id="layerbox" class="dgroup_add" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 그룹 등록</h2>        	
			<a href="#;" id="cancelGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="groupForm" name="groupForm" method="post" enctype="multipart/form-data">
					<input type="hidden" name="siteGrpIdx" id="siteGrpIdx" class="input" value="">
					<input type="hidden" name="userIdx1" id="userIdx1" class="input" value="">
					<input type="hidden" name="fileChangeYn" id="fileChangeYn" class="input" value="N">
					<table>
						<colgroup>
							<col width="100">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>회사</span></th>
								<td>
									<select name="selCompIdx1" id="selCompIdx1" class="sel" style="width:100%">
									</select>
								</td>
							</tr>
							<tr>
								<th><span>그룹명</span></th>
								<td><input type="text" name="siteGrpName" id="siteGrpName" class="input" style="width:100%" maxlength="50" ></td>
							</tr>
							<tr>
								<th><span>그룹ID</span></th>
								<td><input type="text" name="siteGrpId" id="siteGrpId" class="input" style="width:100%" maxlength="20" ></td>
							</tr>
							<tr>
								<th><span>그룹 이미지</span></th>
								<td>
									<span class="control-fileupload" id="detailImg">
										<label for="file" id="fileNameTag">Choose a file :</label>
										<a href="#;" onclick="updateImg('Y');"><i class="glyphicon glyphicon-edit"></i></a>
									</span>
									<span id="br" style="height: 10px;"></span>
									<span class="control-fileupload" id="insertImg">
										<input type="file" id="siteGrpImg" name="siteGrpImg">
										<a href="#;" onclick="updateImg('N');"><i class="glyphicon glyphicon-remove"></i></a>
									</span>
								</td>
							</tr>
						</tbody>			
					</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmGrpBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->      

    <!-- ###### 신규사이트 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="dsite" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 사이트 등록</h2>        	
			<a href="#;" id="cancelSiteBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="siteForm" name="siteForm">
					<input type="hidden" name="userIdx2" id="userIdx2" class="input" value="">
					<table>
						<colgroup>
							<col width="200">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>사이트명</span></th>
								<td><input type="text" name="siteName" id="siteName" class="input" style="width:100%" maxlength="50"></td>
							</tr>
							<tr>
								<th><span>사이트ID</span></th>
								<td><input type="text" name="siteId" id="siteId" class="input" style="width:100%" maxlength="20"></td>
							</tr>
							<tr>
								<th><span>회사</span></th>
								<td>
									<select name="selCompIdx2" id="selCompIdx2" class="sel" style="width:100%" onchange="changeCmpy();">
									</select>
								</td>
							</tr>
							<tr>
								<th><span>지역</span></th>
								<td>
									<select name="areaType" id="areaType" class="sel" style="width:100%">
										<option value="">---지역선택---</option>
										<option value="01">서울</option>
										<option value="02">부산</option>
										<option value="03">대구</option>
										<option value="04">인천</option>
										<option value="05">광주</option>
										<option value="06">대전</option>
										<option value="07">울산</option>
										<option value="08">세종</option>
										<option value="09">경기</option>
										<option value="10">강원</option>
										<option value="11">충북</option>
										<option value="12">충남</option>
										<option value="13">전북</option>
										<option value="14">전남</option>
										<option value="15">경북</option>
										<option value="16">경남</option>
										<option value="17">제주</option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span>그룹</span></th>
								<td>
									<select name="selSiteGrpIdx2" id="selSiteGrpIdx2" class="sel" style="width:100%">
										
									</select>
								</td>
							</tr>
							<tr>
								<th><span>Local EMS 주소</span></th>
								<td><input type="text" name="localEmsAddr" id="localEmsAddr" class="input" style="width:100%" maxlength="50"></td>
							</tr>
							<tr>
								<th><span>Local EMS 암호키</span></th>
								<td><input type="text" name="localEmsKey" id="localEmsKey" class="input" style="width:100%" maxlength="50"></td>
							</tr>
							<tr>
								<th><span>Local EMS 버전</span></th>
								<td>
									<select name="localEmsApiVer" id="localEmsApiVer" class="sel" style="width:100%">
									<option value="1.0">v1.0</option>
									<option value="1.1">v1.1</option>
									<option value="1.2">v1.2</option>
								</select>
								</td>
							</tr>
						</tbody>			
					</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmSiteBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelSiteBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

 
