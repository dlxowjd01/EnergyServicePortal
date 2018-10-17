	$(document).ready(function() {
		getDBData();
	});
	
	function getDBData() {
		getUserList(1); // 사용자 목록 조회
	}
	
	// 사용자 목록 조회
	function callback_getUserList(result) {
		var userList = result.list;
		
		var strHtml = "";
		$tbody = $("#userTbody");
		$tbody.empty();
		if(userList == null || userList.length < 1) {
			strHtml += '<tr><td colspan="7">조회된 데이터가 없습니다.</td><tr>';
			$tbody.append( strHtml );
		} else {
			for(var i=0; i<userList.length; i++) {
				var tm = new Date( convertDateUTC(userList[i].reg_date) );
				$tbody.append(
						$('<tr />').append( $("<td />").append( userList[i].user_id ) // id
						).append( $("<td />").append( userList[i].auth_type_name ) // 권한등급
						).append( $("<td />").append( userList[i].comp_name ) // 회사명
						).append( $("<td />").append( userList[i].site_grp_name ) // 그룹
						).append( $("<td />").append( userList[i].note ) // 설명
						).append( $("<td />").append( tm.format("yyyy-MM-dd HH:mm:ss") ) // 등록일자
						).append(
								$("<td />").append(
										'<a href="#" onclick="updateUserForm(\''+userList[i].user_idx+'\');" class="default_btn">수정</a>'+
										'<a href="#" onclick="deleteUserYn(\''+userList[i].user_idx+'\');" class="cancel_btn">삭제</a>'
								)
						)
				);
			}

			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "User");
			
		}
		
	}

	var insUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	$( function () {
		$("#insertFormBtn").click(function(){
			insUpdFlag = 1;
			$(".duser").find('h2').empty().append("사용자 추가하기");
			
			$('form').each(function() {
				this.reset();
			});
			$("#mainUserYn").val( "N" );
			$("#mainUserIdx").val( "1" );

//			getCmpyPopupList(); // 회사목록 조회
			
			popupOpen('duser');
		});
		
		$("#confirmBtn").click(function(){
			var formData = $("#userForm").serializeObject();
			if(confirm("저장하시겠습니까?")) {
				if(insUpdFlag ==  1) insertUser(formData);
				else if(insUpdFlag ==  2)  updateUser(formData);
			}
		});
		
		$("#cancelBtn, #cancelBtnX").click(function(){
			insUpdFlag = 0;
			$('#userForm').each(function() {
				this.reset();
			});
			$("#mainUserYn").val( "N" );
			$("#mainUserIdx").val( "1" );
			$("#userForm").find("#compIdx").empty();
			$("#userForm").find("#siteGrpIdx").empty();
			$("#userForm").find("#siteId").empty();
			
			popupClose('duser');
		});
		
		// 권한 선택 시
		$('#authType').change(function(){
			var authType = $(this).val();
			$("#userForm").find("#compIdx").empty();
			$("#userForm").find("#siteGrpIdx").empty();
			$("#userForm").find("#siteId").empty();
			$("#userForm").find("#compIdx").attr("disable", true);
			$("#userForm").find("#siteGrpIdx").attr("disable", true);
			$("#userForm").find("#siteId").attr("disable", true);
			
			if(authType == 1) { // 서비스 포털 관리자
				
			} else if(authType == 2) { // 고객사 관리자
				$("#userForm").find("#compIdx").attr("disable", false)
			} else if(authType == 3) { // 그룹 관리자
				$("#userForm").find("#compIdx").attr("disable", false);
				$("#userForm").find("#siteGrpIdx").attr("disable", false);
			} else if(authType == 4) { // 사이트 관리자
				$("#userForm").find("#compIdx").attr("disable", false);
				$("#userForm").find("#siteGrpIdx").attr("disable", false);
				$("#userForm").find("#siteId").attr("disable", false);
			} else if(authType == 5) { // 사이트 이용자
				$("#userForm").find("#compIdx").attr("disable", false);
				$("#userForm").find("#siteGrpIdx").attr("disable", false);
				$("#userForm").find("#siteId").attr("disable", false);
			}
			
			if(authType != 1 || autyType != "") {
				$("#userType").val(2);
				getCmpyPopupList(); // 회사목록 조회
			} else {
				$("#userType").val(1);
			}
		});
		
		// 회사 선택 시
		$('#compIdx').change(function(){
			$("#userForm").find("#siteGrpIdx").empty();
			$("#userForm").find("#siteId").empty();
			var authType = $('#authType').val();
			if(authType == 3 || authType == 4 || authType == 5) {
				var compIdx = $(this).val();
				getGroupPopupList(compIdx); // 그룹목록 조회
			}
		});
		
		// 그룹 선택 시
		$('#siteGrpIdx').change(function(){
			$("#userForm").find("#siteId").empty();
			var authType = $('#authType').val();
			if(authType == 4 || authType == 5) {
				var siteGrpIdx = $(this).val();
				getSitePopupList(siteGrpIdx); // 그룹내 사이트목록 조회
			}
			
		});
	});
	
	function getCmpyPopupList() {
		$.ajax({
			url : "/getCmpyPopupList",
			type : 'post',
			async : false, // 동기로 처리해줌
//			data : {
//				selPageNum : ""
//			},
			success: function(result) {
				var list = result.list;
				
				$siteIdSelBox = $("#userForm").find("#compIdx");
				$siteIdSelBox.empty();
				$siteIdSelBox.append('<option value="">---회사선택---</option>');
				for(var i=0; i<list.length; i++) {
					$siteIdSelBox.append('<option value="'+list[i].comp_idx+'">'+list[i].comp_name+'</option>');
					
				}
			}
		});
	}
	
	function getGroupPopupList(compIdx) {
		$.ajax({
			url : "/getGroupPopupList",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				compIdx : compIdx
			},
			success: function(result) {
				var list = result.list;
				
				$siteIdSelBox = $("#userForm").find("#siteGrpIdx");
				$siteIdSelBox.empty();
				$siteIdSelBox.append('<option value="">---그룹선택---</option>');
				for(var i=0; i<list.length; i++) {
					$siteIdSelBox.append('<option value="'+list[i].site_grp_idx+'">'+list[i].site_grp_name+'</option>');
					
				}
			}
		});
	}

	function callback_getSitePopupList(result) {
		var grpSiteList = result.grpSiteList;
		var allSiteList = result.allSiteList;
		
		$siteIdSelBox = $("#userForm").find("#siteId");
		$siteIdSelBox.empty();
		$siteIdSelBox.append('<option value="">---사이트선택---</option>');
		for(var i=0; i<grpSiteList.length; i++) {
			$siteIdSelBox.append('<option value="'+grpSiteList[i].site_id+'">'+grpSiteList[i].site_name+'</option>');
			
		}
		
	}

	function callback_insertUser(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
	function updateUserForm(userIdx) {
		insUpdFlag = 2;
		$(".duser").find('h2').empty().append("사용자 정보 수정");
		getUserDetail(userIdx);
	}

	// 사용자 한건 조회
	function callback_getUserDetail(result) {
		var userDetail = result.detail;
		
		if(userDetail == null) {
			alert("조회된 데이터가 없습니다.");
//			location.href = "/siteMain";
		} else {
			var authType = userDetail.auth_type;
			
			$("#userForm").find("#compIdx").empty();
			$("#userForm").find("#siteGrpIdx").empty();
			$("#userForm").find("#siteId").empty();
			$("#userForm").find("#compIdx").attr("disable", true);
			$("#userForm").find("#siteGrpIdx").attr("disable", true);
			$("#userForm").find("#siteId").attr("disable", true);
			
			if(authType == 1) { // 서비스 포털 관리자
				
			} else if(authType == 2) { // 고객사 관리자
				$("#userForm").find("#compIdx").attr("disable", false);
				getCmpyPopupList(); // 회사목록 조회
			} else if(authType == 3) { // 그룹 관리자
				$("#userForm").find("#compIdx").attr("disable", false);
				$("#userForm").find("#siteGrpIdx").attr("disable", false);
				getCmpyPopupList(); // 회사목록 조회
				getGroupPopupList(userDetail.comp_idx); // 그룹목록 조회
			} else if(authType == 4) { // 사이트 관리자
				$("#userForm").find("#compIdx").attr("disable", false);
				$("#userForm").find("#siteGrpIdx").attr("disable", false);
				$("#userForm").find("#siteId").attr("disable", false);
				getCmpyPopupList(); // 회사목록 조회
				getGroupPopupList(userDetail.comp_idx); // 그룹목록 조회
				getSitePopupList(userDetail.site_grp_idx); // 그룹내 사이트목록 조회
			} else if(authType == 5) { // 사이트 이용자
				$("#userForm").find("#compIdx").attr("disable", false);
				$("#userForm").find("#siteGrpIdx").attr("disable", false);
				$("#userForm").find("#siteId").attr("disable", false);
				getCmpyPopupList(); // 회사목록 조회
				getGroupPopupList(userDetail.comp_idx); // 그룹목록 조회
				getSitePopupList(userDetail.site_grp_idx); // 그룹내 사이트목록 조회
			}
			
			$("#mainUserYn").val( userDetail.main_user_yn );
			$("#mainUserIdx").val( userDetail.main_user_idx );
			$("#userIdx").val( userDetail.user_idx );
			$("#userType").val( userDetail.user_type );
			$("#userId").val( userDetail.user_id );
			$("#authType").val( userDetail.auth_type );
			$("#compIdx").val( userDetail.comp_idx );
			$("#note").val( userDetail.note );
			$("#siteGrpIdx").val( userDetail.site_grp_idx );
			$("#siteId").val( userDetail.site_id );
			
			popupOpen('duser');
		}
		
	}

	function callback_updateUser(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
	function deleteUserYn(userIdx) {
		if(confirm("삭제하시겠습니까?")) {
			deleteUser(userIdx);
		}
	}

	function callback_deleteUser(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("삭제되었습니다.");
			location.reload();
		} else {
			alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
