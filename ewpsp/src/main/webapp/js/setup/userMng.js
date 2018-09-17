	$(document).ready(function() {
		getDBData();
	});
	
	function getDBData(deviceGbn) {
		getUserList(); // 사용자 목록 조회
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
				$tbody.append(
						$('<tr />').append( $("<td />").append( userList[i].user_id ) // id
						).append( $("<td />").append( userList[i].auth_type ) // 권한등급
						).append( $("<td />").append( userList[i].co_name ) // 회사명
						).append( $("<td />").append( userList[i].user_idx ) // 그룹
						).append( $("<td />").append( userList[i].note ) // 설명
						).append( $("<td />").append( userList[i].reg_date ) // 등록일자
						).append(
								$("<td />").append(
										'<a href="#" onclick="updateUserForm(\''+userList[i].user_idx+'\');" class="default_btn">수정</a>'+
										'<a href="#" onclick="deleteUserYn(\''+userList[i].user_idx+'\');" class="cancel_btn">삭제</a>'
								)
						)
				);
			}
			
		}
		
	}

	var insUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	$( function () {
		$("#insertFormBtn").click(function(){
			insUpdFlag = 1;
			popupOpen('duser');
		});
		
		$("#confirmBtn").click(function(){
			var formData = $("#userForm").serializeObject();
			if(confirm("저장하시겠습니까?")) {
				if(insUpdFlag ==  1) insertUser(formData);
				else if(insUpdFlag ==  2)  updateUser(formData);
			}
		});
		
		$("#cancelBtn").click(function(){
			insUpdFlag = 0;
			$('form').each(function() {
				this.reset();
			});
			$("#mainUserYn").val( "N" );
			$("#mainUserIdx").val( "1" );
			
			popupClose('duser');
		});
	});

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
		getUserDetail(userIdx);
	}

	// 사용자 한건 조회
	function callback_getUserDetail(result) {
		var userDetail = result.detail;
		
		if(userDetail == null) {
			alert("조회된 데이터가 없습니다.");
//			location.href = "/siteMain";
		} else {
			$("#mainUserYn").val( userDetail.main_user_yn );
			$("#mainUserIdx").val( userDetail.main_user_idx );
			$("#userIdx").val( userDetail.user_idx );
			$("#userId").val( userDetail.user_id );
			$("#authType").val( userDetail.auth_type );
			$("#note").val( userDetail.note );
			
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
