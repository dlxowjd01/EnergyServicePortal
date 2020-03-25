<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<c:set var="linkGbn" value="setting" />
<script>
	$(document).ready(function() {
		navAddClass("setting");
		getDBData();
	});
	
	function getDBData() {
		getUserList(1); // 사용자 목록 조회
	}

	// 사용자 목록 조회
	function getUserList(selPageNum) {
	    $.ajax({
	        url: "/system/getUserList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            selPageNum: selPageNum
	        },
	        success: function (result) {
	        	var userList = result.list;
	    		
	    		var tbodyStr = "";
	    		$tbody = $("#userTbody");
	    		$tbody.empty();
	    		var auth_type = sessionUser.auth_type;
	    		if(userList != null && userList.length > 0) {
	    			for(var i=0; i<userList.length; i++) {
	    				var tm = new Date( convertDateUTC(userList[i].reg_date) );
	    				tbodyStr += '<tr>';
	    				tbodyStr += '<td>'+userList[i].user_id+'</td>'; // id
	    				tbodyStr += '<td>'+((userList[i].auth_type_name==null) ? '' : userList[i].auth_type_name)+'</td>'; // 권한등급
	    				tbodyStr += '<td>'+((userList[i].comp_name==null) ? '' : userList[i].comp_name)+'</td>'; // 회사명
	    				tbodyStr += '<td>'+((userList[i].site_grp_name==null) ? '' : userList[i].site_grp_name)+'</td>'; // 그룹
	    				tbodyStr += '<td class="ellipsis mxw500">'+((userList[i].note==null) ? '' : userList[i].note)+'</td>'; // 설명
	    				tbodyStr += '<td>'+tm.format("yyyy-MM-dd HH:mm:ss")+'</td>'; // 등록일자
	    				tbodyStr += '<td>';
	    				if(userList[i].auth_type >= auth_type) {
	    					tbodyStr += '<a href="#" onclick="updateUserForm(\''+userList[i].user_idx+'\');" class="default_btn">수정</a>'
	    						+'<a href="#" onclick="deleteUserYn(\''+userList[i].user_idx+'\');" class="cancel_btn">삭제</a>';
	    				}
	    				tbodyStr += '</td>'; // 그룹
	    				tbodyStr += '</tr>';
	    			}
	    	
	    			var pagingMap = result.pagingMap;
	    			makePageNums2(pagingMap, "User");
	    			
	    		} else {
	    			tbodyStr += '<tr><td colspan="7">조회 결과가 없습니다.</td><tr>';
	    		}
	    		
	    		$tbody.append( tbodyStr );
	        }
	    });
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
			$("#userId").attr("readonly", false);
			$("#authType").not(":selected").attr("disabled", false);
			
			popupOpen('duser');
		});
		
		$("#confirmBtn").click(function(){
            var $userId = $("#userId");
		    if( isEmpty($userId.val()) ) {
				alert("사용자ID를 입력하세요");
                $userId.focus();
				return;
			}
			var $authType = $("#authType");
			var authType = $authType.val();
			if( isEmpty($authType.val()) ) {
				alert("권한을 선택하세요");
				$authType.focus();
				return;
			}
            var $compIdx = $("#compIdx");
			if(authType !== '1') {
				if (isEmpty($compIdx.val())) {
					alert("회사를 선택하세요");
					$compIdx.focus();
					return;
				}
			}
			
            var $siteGrpIdx = $("#siteGrpIdx");
            var $siteId = $("#siteId");
			if(authType === '3') {
				if( isEmpty($siteGrpIdx.val()) ) {
					alert("그룹을 선택하세요");
					$siteGrpIdx.focus();
					return;
				}
			} else if(authType === '4' || authType === '5') {
				if( isEmpty($siteGrpIdx.val()) ) {
					alert("그룹을 선택하세요");
					$siteGrpIdx.focus();
					return;
				}
				if( isEmpty($siteId.val()) ) {
					alert("사이트를 선택하세요");
                    $siteId.focus();
					return;
				}
			}
			
			var formData = $("#userForm").serializeObject();
			if(confirm("저장하시겠습니까?")) {
				if(insUpdFlag ===  1) insertUser(formData);
				else if(insUpdFlag ===  2)  updateUser(formData);
			}
		});
		
		$("#cancelBtn, #cancelBtnX").click(function(){
			insUpdFlag = 0;
			$('#userForm').each(function() {
				this.reset();
			});
			$("#mainUserYn").val( "N" );
			$("#mainUserIdx").val( "1" );
			$("#compIdx").empty();
			$("#siteGrpIdx").empty();
			$("#siteId").empty();
			
			popupClose('duser');
		});
		
		// 권한 선택 시
		$('#authType').change(function(){
			var authType = $(this).val();
			var $compIdx = $("#compIdx");
            var $siteGrpIdx = $("#siteGrpIdx");
            var $siteId = $("#siteId");
            $compIdx.empty();
			$siteGrpIdx.empty();
			$siteId.empty();
            $compIdx.attr("disable", true);
			$siteGrpIdx.attr("disable", true);
			$siteId.attr("disable", true);

			if(authType === '2') { // 고객사 관리자
				$compIdx.attr("disable", false)
			} else if(authType === '3') { // 그룹 관리자
				$compIdx.attr("disable", false);
				$siteGrpIdx.attr("disable", false);
			} else if(authType === '4') { // 사이트 관리자
				$compIdx.attr("disable", false);
				$siteGrpIdx.attr("disable", false);
				$siteId.attr("disable", false);
			} else if(authType === '5') { // 사이트 이용자
				$compIdx.attr("disable", false);
				$siteGrpIdx.attr("disable", false);
				$siteId.attr("disable", false);
			}
			
			if(authType !== '1' || authType !== "") {
				$("#userType").val(2);
				getCmpyPopupList(); // 회사목록 조회
			} else {
				$("#userType").val(1);
			}
		});
		
		// 회사 선택 시
		$('#compIdx').change(function(){
			$("#siteGrpIdx").empty();
			$("#siteId").empty();
			var authType = $('#authType').val();
			if(authType === '3' || authType === '4' || authType === '5') {
				var compIdx = $(this).val();
				getGroupPopupList(compIdx); // 그룹목록 조회
			}
		});
		
		// 그룹 선택 시
		$('#siteGrpIdx').change(function(){
			$("#siteId").empty();
			var authType = $('#authType').val();
			if(authType === '4' || authType === '5') {
				var siteGrpIdx = $(this).val();
				getSitePopupList(siteGrpIdx); // 그룹내 사이트목록 조회
			}
		});
	});
	
	function getCmpyPopupList() {
		$.ajax({
			url : "/system/getCmpyPopupList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				var list = result.list;
				
				var $siteIdSelBox = $("#compIdx");
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
			url : "/system/getGroupPopupList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				compIdx : compIdx
			},
			success: function(result) {
				var list = result.list;
				
				var $siteIdSelBox = $("#siteGrpIdx");
				$siteIdSelBox.empty();
				$siteIdSelBox.append('<option value="">---그룹선택---</option>');
				for(var i=0; i<list.length; i++) {
					$siteIdSelBox.append('<option value="'+list[i].site_grp_idx+'">'+list[i].site_grp_name+'</option>');
				}
			}
		});
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
	    		
	    		var $siteIdSelBox = $("#siteId");
	    		$siteIdSelBox.empty();
	    		$siteIdSelBox.append('<option value="">---사이트선택---</option>');
	    		for(var i=0; i<grpSiteList.length; i++) {
	    			$siteIdSelBox.append('<option value="'+grpSiteList[i].site_id+'">'+grpSiteList[i].site_name+'</option>');
	    		}
	        }
	    });
	}

	// 사용자 등록
	function insertUser(formData) {
	    $.ajax({
	        url: "/system/insertUser.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    	
	    			// 마지막에 추가된 사용자 조회 (Local EMS 연동)
	    			getLastUserDetail($('#userId').val());
	    	
	    			location.reload();
	    		} else {
	    			alert("회원가입이 되어있지 않은 사용자입니다. \n권한을 추가할 수 없습니다.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function updateUserForm(userIdx) {
		insUpdFlag = 2;
		$(".duser").find('h2').empty().append("사용자 정보 수정");
		getUserDetail(userIdx);
	}

	// 사용자 한건 조회
	function getUserDetail(userIdx) {
	    $.ajax({
	        url: "/system/getUserDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            userIdx: userIdx
	        },
	        success: function (result) {
	        	var userDetail = result.detail;
	    		
	    		if(userDetail != null) {
	    			var authType = userDetail.auth_type;

	                var $authType = $("#authType");
	    			if(sessionUser.user_id === userDetail.user_id) {
	    				$authType.not(":selected").attr("disabled", true);
	    			} else {
	    				$authType.not(":selected").attr("disabled", false);
	    			}
	                var $compIdx = $("#compIdx");
	                var $siteGrpIdx = $("#siteGrpIdx");
	                var $siteId = $("#siteId");
	    			$compIdx.empty().attr("disable", true);
	    			$siteGrpIdx.empty().attr("disable", true);
	    			$siteId.empty().attr("disable", true);
	    			
	    			 if(authType === '2') { // 고객사 관리자
	    				$compIdx.attr("disable", false);
	    				getCmpyPopupList(); // 회사목록 조회
	    			} else if(authType === '3') { // 그룹 관리자
	    				$compIdx.attr("disable", false);
	    				$siteGrpIdx.attr("disable", false);
	    				getCmpyPopupList(); // 회사목록 조회
	    				getGroupPopupList(userDetail.comp_idx); // 그룹목록 조회
	    			} else if(authType === '4') { // 사이트 관리자
	    				$compIdx.attr("disable", false);
	    				$siteGrpIdx.attr("disable", false);
	    				$siteId.attr("disable", false);
	    				getCmpyPopupList(); // 회사목록 조회
	    				getGroupPopupList(userDetail.comp_idx); // 그룹목록 조회
	    				getSitePopupList(userDetail.site_grp_idx); // 그룹내 사이트목록 조회
	    			} else if(authType === '5') { // 사이트 이용자
	    				$compIdx.attr("disable", false);
	    				$siteGrpIdx.attr("disable", false);
	    				$siteId.attr("disable", false);
	    				getCmpyPopupList(); // 회사목록 조회
	    				getGroupPopupList(userDetail.comp_idx); // 그룹목록 조회
	    				getSitePopupList(userDetail.site_grp_idx); // 그룹내 사이트목록 조회
	    			}
	    			
	    			$("#mainUserYn").val( userDetail.main_user_yn );
	    			$("#mainUserIdx").val( userDetail.main_user_idx );
	    			$("#userIdx").val( userDetail.user_idx );
	    			$("#userType").val( userDetail.user_type );
	    			var $userId = $("#userId");
	                $userId .val( userDetail.user_id );
	                $userId .attr("readonly", true);
	    			$authType.val( userDetail.auth_type );
	    			$compIdx.val( userDetail.comp_idx );
	    			$("#note").val( userDetail.note );
	    			$siteGrpIdx.val( userDetail.site_grp_idx );
	    			$siteId.val( userDetail.site_id );
	    			
	    			popupOpen('duser');
	    		} else {
	    			alert("조회 결과가 없습니다.");
	    		}
	        }
	    });
	}

	// 마지막에 추가된 사용자 한건 조회
	function getLastUserDetail(userId) {
	    $.ajax({
	        url: "/system/getLastUserDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            userId: userId
	        },
	        success: function (result) {
	        	changeEMSUser(result);
	        }
	    });
	}

	// 사용자 수정
	function updateUser(formData) {
	    $.ajax({
	        url: "/system/updateUser.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			changeEMSUserDB($("#userIdx").val()); // Local EMS 회원 연계
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
	
	function deleteUserYn(userIdx) {
		if(confirm("삭제하시겠습니까?")) {
			$("#userIdx").val(userIdx);
			deleteUser(userIdx);
		}
	}

	// 사용자 삭제
	function deleteUser(userIdx) {
	    $.ajax({
	        url: "/system/deleteUser.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            userIdx: userIdx
	        },
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("삭제되었습니다.");
	    			changeEMSUserDB($("#userIdx").val()); // Local EMS 회원 연계
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
						<h1 class="page-header">사용자 관리 설정</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv">
							<div class="set_top clear">
								<a href="#;" class="adduser_btn fr" id="insertFormBtn"><i class="glyphicon glyphicon-user"></i> 사용자 추가하기</a>
							</div>
							<div class="s_table">
								<table>
									<colgroup>
										<col width="150">
										<col width="100">
										<col width="150">
										<col width="150">
										<col>
										<col width="150">
										<col width="150">
									</colgroup>
									<thead>
										<tr>
											<th>ID</th>
											<th>권한등급</th>
											<th>회사</th>
											<th>그룹</th>
											<th>설명</th>
											<th>등록일자</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody id="userTbody">
										<tr>
											<td colspan="7">조회된 데이터가 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>	
							<div class="paging clear" id="UserPaging">
							</div>						
						</div>
					</div>
				</div>




    <!-- ###### 사용자 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="duser" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 사용자 등록</h2>        	
			<a href="#;" id="cancelBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="userForm" name="userForm">
					<input type="hidden" name="mainUserYn" id="mainUserYn" class="input" value="N">
					<input type="hidden" name="mainUserIdx" id="mainUserIdx" class="input" value="">
					<input type="hidden" name="userIdx" id="userIdx" class="input" value="">
					<input type="hidden" name=userType id="userType" class="input" value="">
					<input type="hidden" name=langType id="langType" class="input" value="1">
					<table>
						<colgroup>
							<col width="150">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>사용자ID</span></th>
								<td><input type="text" name="userId" id="userId" class="input" style="width:100%"></td>
							</tr>
							<tr>
								<th><span>권한</span></th>
								<td>
									<select name="authType" id="authType" class="sel" style="width:100%">
										<option value="">---권한선택---</option>
										<c:if test="${not empty userInfo and userInfo.auth_type <= 1}">
											<option value="1">서비스 포털 관리자</option>
										</c:if>
										<c:if test="${not empty userInfo and userInfo.auth_type <= 2}">
											<option value="2">고객사 관리자</option>
										</c:if>
										<c:if test="${not empty userInfo and userInfo.auth_type <= 3}">
											<option value="3">그룹 관리자</option>
										</c:if>
										<c:if test="${not empty userInfo and userInfo.auth_type <= 4}">
											<option value="4">사이트 관리자</option>
										</c:if>
										<option value="5">사이트 이용자</option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span>회사</span></th>
								<td>
									<select name="compIdx" id="compIdx" class="sel" style="width:100%">
										
									</select>
								</td>
							</tr>
							<tr>
								<th><span>그룹</span></th>
								<td>
									<select name="siteGrpIdx" id="siteGrpIdx" class="sel" style="width:100%">
										
									</select>
								</td>
							</tr>
							<tr>
								<th><span>사이트</span></th>
								<td>
									<select name="siteId" id="siteId" class="sel" style="width:100%">
										<option value=""></option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span>설명</span></th>
								<td>
									<textarea name="note" id="note" style="width:100%" class="textarea" rows="10"></textarea>
								</td>
							</tr>
						</tbody>			
					</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->