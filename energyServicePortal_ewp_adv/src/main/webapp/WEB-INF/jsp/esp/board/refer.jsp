<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	$(function() {
		getUserInfo(setUserInfo);
		getDBData();
		
		$('#referFiles').on('change', function(e) {
			
			var tempInsList = $('.fileList').find('li.ins');
			$(tempInsList).each(function() {
				this.remove();  //리스트 초기화
			});
			
			var fileCnt = $('#referFiles')[0].files.length;
			if (fileCnt > 0) {
				$fileList = $('.fileList');
				for(var i = 0; i < fileCnt; i++) {
					$fileList.append('<li class="ins">'+this.files[i].name+'</li>'); //리스트 새로 그리기
				}
			}
		});	

	});
	
	var userInfo = null;
	function setUserInfo(result) {
		userInfo = result;
	}
	
// 	function deleteFile(obj) {
// 		if($(obj).closest('li').hasClass('ins')) {
// 			var fileIdx = $(obj).closest('li').data('i');
// 			$('#referFiles')[0].files[fileIdx] = null;
// 			$(obj).closest('li').remove();
// 		} else {
// 			$(obj).closest('li').addClass('del').hide();
// 		}
// 	}
	
	function getDBData() {
		var formData = $("#schForm").serializeObject();
		getReferList(formData); // 자료 목록 조회
	}

	// FAQ 목록 조회
	function getReferList(formData) {
	    $.ajax({
	        url: "/board/getReferList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var referList = result.list;
	        	
	    		var strHtml = "";
	    		var $ul = $("#referList");
	    		$ul.empty();
	    		if (referList == null || referList.length < 1) {
	    			$ul.append('<li><a href="#;" class="question"><span class="gubun">검색 결과가 없습니다.<span></a></li>');
	    		} else {
	    			for (var i = 0; i < referList.length; i++) {
	    				var adminBtn = '';
	    				var fileBtn = '';
	    				if (userInfo !== null && userInfo.auth_type === '1') {
	    					adminBtn = $('<div class="edit_btn mt15 fr" />')
	    						.append('<a href="#;" onclick="updateReferForm(' + referList[i].rfnc_idx + ')"><i class="glyphicon glyphicon-edit"></i></a>')
	    						.append('<a href="#;" onclick="deleteReferYn(' + referList[i].rfnc_idx + ')"><i class="glyphicon glyphicon-remove"></i></a>')
	    				}
	    	
	    				var fileStr = '';
						if(referList[i].files.length > 0) {
							fileBtn = $('<div class="edit_btn mt15 fr" />');
							for(var j = 0; j < referList[i].files.length; j++) {
								fileStr += '<a href="javascript:void(0);" onclick="downReferFile(\'' + referList[i].files[j].file_save_name + '\',\''+referList[i].files[j].file_origin_name+'\')"><i class="glyphicon glyphicon-cloud-download"></i>'+referList[i].files[j].file_origin_name+'</a>'
							}
							fileBtn.append(fileStr);
						}
	    				$ul.append(
	    					$('<li />')
	    						.append($('<a href="#;" class="question" />')
	    							.append($('<span class="gubun" data-cate-idx="' + referList[i].rfnc_cate_idx + '" />').append(referList[i].rfnc_cate_name))
	    							.append($('<span class="sbj" />').append(referList[i].title))
	    						)
	    						.append($('<div class="answer" />')
	    							.append(referList[i].contents)
	    							.append(adminBtn)
	    							.append(fileBtn)
	    						)
	    				);
	    			}
	    		}
	    	
	    		// 클릭이벤트 재등록
	    		$(".faq_list .question").click(function() {
	    			$(this).next(".answer").slideToggle();
	    			$(this).toggleClass("on");
	    			return false;
	    		});
	    	
	    		// 카테고리 초기화
	    		$('#cateList > a').removeClass('on');
	    		$('#cateList > a:eq(0)').addClass('on');
	        }
	    });
	}
	
	function downReferFile(saveName, originName) {
// 		var formData = new FormData();
// 		formData.append("saveName", saveName);
// 		formData.append("originName", originName);
// 		var xhr = new XMLHttpRequest();
// 		xhr.open("post", "/board/downloadFile.do")
// 		xhr.send(formData);

		location.href="/board/downloadFile.do?saveName=" + saveName + "&originName=" + originName;		
	}
	
	
	function changeReferCate(aElmt, cateIdx) {
		$('#cateList > a').removeClass('on');
		$(aElmt).addClass('on');
		if (cateIdx == '') {
			$('#referList > li').show();
		} else {
			$('#referList > li').each(function(idx, liElmt) {
				var liObj = $(liElmt);
				var gubun = liObj.find('.gubun');	
				if (gubun.data('cateIdx') != cateIdx) {
					liObj.hide();
				} else {
					liObj.show();
				}
			});
		}
	}

	var referInsUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	var categoryInsUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	// FAQ
	$( function () {
		$("#insertReferFormBtn").click(function(){
			referInsUpdFlag = 1;
	
			$('#referForm').each(function() {
				this.reset();
			});
	
			getReferCateSelBox();
	
			popupOpen('referedit');
		});
	
		$("#confirmReferBtn").click(function(){
			var $referCateIdx = $('#referCateIdx');
			if ( isEmpty($referCateIdx.val()) ) {
				alert('카테고리를 선택하세요.');
				$referCateIdx.focus();
				return;
			}
			var $title = $('#referTitle');
			if ( isEmpty($title.val()) ) {
				alert('제목을 입력하세요.');
				$title.focus();
				return;
			}
			var $contents = $('#referContents');
			if ( isEmpty($contents.val()) ) {
				alert('내용을 입력하세요.');
				$contents.focus();
				return;
			}
			var files = $('#referFiles')[0].files;
			var totalSize = 0;
			$(files).each(function() {
				totalSize += Number(this.size);
			});
			
			var savedTags = $('.fileList').find('li.saved'); //saved클래스 list
			for(var i=0; i < savedTags.length; i++) {
					var file_size = Number(savedTags[i].dataset.file_size); //기존 저장파일 사이즈
					if (!isNaN(file_size)) {
						totalSize += file_size;
					}
			}
			
			if(totalSize > 20000000) {
				alert('최대 파일용량(20MB) 을 초과합니다.');
				return;
			}
			
			var form = $("#referForm")[0];
			var data = new FormData(form);
			
			if (confirm("저장하시겠습니까?")) {
				if(referInsUpdFlag ===  1) insertRefer(data);
				else if(referInsUpdFlag ===  2) updateRefer(data);
			}
		});
	
		$("#cancelReferBtn, #cancelReferBtnX").click(function(){
			referInsUpdFlag = 0;
			$('#referForm').each(function() {
				this.reset();
			});
			
			
			$('.fileList').empty();
			popupClose('referedit');
		});
	});

	function getReferCateSelBox() {
		$.ajax({
			url : "/board/getReferCateList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				var list = result.list;

				var $referCateIdxSelBox = $("#referCateIdx");
				$referCateIdxSelBox.children('option').not(':eq(0)').remove();
				for(var i=0; i<list.length; i++) {
					$referCateIdxSelBox.append('<option value="' + list[i].rfnc_cate_idx+'">' + list[i].rfnc_cate_name + '</option>');
				}
			}
		});
	}
	
	// FAQ 등록
	function insertRefer(data) {
		
	    $.ajax({
	        url: "/board/insertRefer.json",
	        type: 'post',
	        enctype: 'multipart/form-data',
	        processData: false,
	        contentType: false,
	        async: false, // 동기로 처리해줌
	        data: data,
	        success: function (result) {
	        
	        	var resultCnt = result.resultCnt;
	        	var resultMsg = result.resultMsg; 
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			location.reload();
	    		} else {
	    			alert(resultMsg);
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function updateReferForm(referIdx) {
		referInsUpdFlag = 2;
		getReferDetail(referIdx);
	}

	// FAQ 한건 조회
	function getReferDetail(referIdx) {
	    $.ajax({
	        url: "/board/getReferDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	        	referIdx: referIdx
	        },
	        success: function (result) {
	        	var referDetail = result.detail;
	        	
	    		if(referDetail == null) {
	    			alert("조회 결과가 없습니다.");
	    		} else {
	    			$("#referIdx").val(referDetail.rfnc_idx);
	    			$("#referTitle").val(referDetail.title);
	    			$("#referContents").val(referDetail.contents);
	    	
	    			$.ajax({
	    				url : "/board/getReferCateList.json",
	    				type : 'post',
	    				async : false, // 동기로 처리해줌
	    				success: function(result) {
	    					var list = result.list;

	    					var $referCateIdxSelBox = $("#referCateIdx");
	    					$referCateIdxSelBox.children('option').not(':eq(0)').remove();
	    					for(var i=0; i<list.length; i++) {
	    						$referCateIdxSelBox.append('<option value="' + list[i].rfnc_cate_idx+'">' + list[i].rfnc_cate_name + '</option>');
	    					}
	    				}
	    			});
	    			$("#referCateIdx").val(referDetail.rfnc_cate_idx);
	    	
	    		}
 				var files = result.files;
		
 				if(files.length > 0) {
 					$('#attachIdx').val(files[0].attach_idx); //
 					
	 				var $fileList = $('.fileList');
					var fileStr = '';
	 				for(var i=0; i < files.length; i++) {
	 					fileStr += '<li class="saved" data-attach_idx_no="'+files[i].attach_idx_no+'"';
	 					fileStr +=     'data-file_path="'+files[i].file_path+'"';
	 					fileStr +=     'data-file_size="'+files[i].file_size+'"';
	 					fileStr +=     'data-file_save_name="'+files[i].file_save_name+'">';
	 					fileStr += files[i].file_origin_name+'<input type="button" value="x" onclick="$(this).closest(\'li\').removeClass(\'saved\').addClass(\'del\').hide();"></li>';
	 				}
	 				$fileList.append('<ul/>').append(fileStr);
				}
    			popupOpen('referedit');
	        }
	    });
	}

	// FAQ 수정
	function updateRefer(formData) {
		
		//여기
		var delTags = $('.fileList').find('li.del');
		
		for(var i=0; i < delTags.length; i++) {
			var file_path = delTags[i].dataset.file_path;
			var file_save_name = delTags[i].dataset.file_save_name;
			var attachIdxNo = delTags[i].dataset.attach_idx_no;
			formData.set('delFile'+ i, file_path +','+file_save_name+','+attachIdxNo);
		}
		
	    $.ajax({
	        url: "/board/updateRefer.json",
	        type: 'post',
	        enctype: 'multipart/form-data',
	        processData: false,
	        contentType: false,
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
	
	function deleteReferYn(referIdx) {
		if(confirm("삭제하시겠습니까?")) {
			deleteRefer(referIdx);
		}
	}

	// FAQ 삭제
	function deleteRefer(referIdx) {
	    $.ajax({
	        url: "/board/deleteRefer.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	        	referIdx: referIdx
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
	
	// FAQ 카테고리
	$(function() {
		$("#insertReferCateFormBtn").click(function(){
			referCateInit();
	
			popupOpen('category_edit');
		});
	
		$("#confirmReferCateBtn").click(function(){
			var $referCateName= $('#referCateName');
			if ( isEmpty($referCateName.val()) ) {
				alert('카테고리명을 입력하세요.');
				$referCateName.focus();
				return;
			}
			var formData = $("#referCateForm").serializeObject();
			if (confirm("저장하시겠습니까?")) {
				if(categoryInsUpdFlag ===  1) insertReferCate(formData);
				else if(categoryInsUpdFlag ===  2) updateReferCate(formData);
			}
		});

		$("#cancelFAQCateBtn, #cancelFAQCateBtnX").click(function(){
			categoryInsUpdFlag  = 0;
			$('#confirmReferCateBtn').val('추가하기');
			$('#referCateForm').each(function() {
				this.reset();
			});
	
			popupClose('category_edit');
			getReferCateSelBox();
		});
	});

	function referCateInit() {
		categoryInsUpdFlag = 1;
		$('#confirmReferCateBtn').val('추가하기');

		$('#referCateForm').each(function() {
			this.reset();
		});

		getReferCateList();
	}

	function getReferCateList() {
		$.ajax({
			url : "/board/getReferCateList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				var list = result.list;

				$tbody = $("#referCateTBody");
				$tbody.empty();
				for (var i = 0; i < list.length; i++) {
					$tbody.append(
							$('<tr />')
									.append($('<td />').append(i + 1))
									.append($('<td />').append('<a href="#;" onclick="updateReferCateForm(' + list[i].rfnc_cate_idx + ')">' + list[i].rfnc_cate_name + '</a>'))
									.append($('<td />').append('<a href="#;" onclick="deleteReferCateYn(' + list[i].rfnc_cate_idx + ')"><i class="glyphicon glyphicon-remove"></i></a>'))
					);
				}
				
			}
		});
	}

	// FAQ 카테고리 등록
	function insertReferCate(formData) {
	    $.ajax({
	        url: "/board/insertReferCate.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			referCateInit();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function updateReferCateForm(referCateIdx) {
		categoryInsUpdFlag = 2;
		$('#confirmReferCateBtn').val('수정하기');
		getReferCateDetail(referCateIdx);
	}

	// FAQ 카테고리 한건 조회
	function getReferCateDetail(referCateIdx) {
	    $.ajax({
	        url: "/board/getReferCateDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	        	referCateIdx: referCateIdx
	        },
	        success: function (result) {
	        	var referCateDetail = result.detail;
	        	
	    		if(referCateDetail == null) {
	    			alert("조회 결과가 없습니다.");
	    		} else {
	    			$("#referCateIdx2").val(referCateDetail.rfnc_cate_idx);
	    			$("#referCateName").val(referCateDetail.rfnc_cate_name);
	    	
// 	    			popupOpen('category_edit');
	    		}
	        }
	    });
	}

	// FAQ 카테고리 수정
	function updateReferCate(formData) {
	    $.ajax({
	        url: "/board/updateReferCate.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			referCateInit();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function deleteReferCateYn(referCateIdx) {
		if(confirm("삭제하시겠습니까?")) {
			getReferListCnt(referCateIdx);
		}
	}

	// FAQ 카테고리 내 게시물 존재 유무 체크
	function getReferListCnt(referCateIdx) {
		$.ajax({
			url: "/board/getReferListCnt.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: {
				cateIdx: referCateIdx
			},
			success: function (result) {
				var cnt = result.resultCnt;
				if(cnt > 0) {
					if(confirm("카테고리 안에 게시물이 "+cnt+"건 존재합니다. 그래도 카테고리를 삭제 하시 겠습니까?")) {
						deleteReferCate(referCateIdx);
					}
				} else {
					deleteReferCate(referCateIdx);
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	// FAQ 카테고리 삭제
	function deleteReferCate(referCateIdx) {
	    $.ajax({
	        url: "/board/deleteReferCate.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	        	referCateIdx: referCateIdx
	        },
	        success: function (result) {
	        	var msg = result.msg;
	    		var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("삭제되었습니다.");
	    			referCateInit();
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
						<h1 class="page-header">자료실</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv faq">
							<div class="search_box">
								<div class="infield">
									<form id="schForm" name="schForm">
										<input type="text" placeholder="궁금하신 점을 검색해 보세요.">
										<input type="image" src="../img/search.png" onclick="getDBData(); return false;">
									</form>
								</div>
							</div>
							<div class="faq_table mt30">
								<div class="cate" id="cateList">
									<a href="#;" onclick="changeReferCate(this, '')" class="on">전체</a>
									<c:forEach var="item" items="${referCateList}">
									<a href="#;" onclick="changeReferCate(this, '${item.rfnc_cate_idx}')">${item.rfnc_cate_name}</a>
									</c:forEach>
								</div>
								<ul class="faq_list mt15" id="referList">
								</ul>
							</div>
							<c:if test="${not empty userInfo and userInfo.auth_type eq '1'}">
								<div class="faq_bottom mt30 clear">
									<a href="#;" class="default_btn fr" id="insertReferFormBtn"><i class="glyphicon glyphicon-cloud-upload"></i> 업로드</a>
								</div>
							</c:if>
						</div>
					</div>
				</div>




    <!-- ###### 게시물 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="referedit" style="min-width:600px;">
        <div class="stit">
        	<h2>자료 등록</h2>        	
			<a href="#;" id="cancelReferBtnX">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="set_tbl">
				<form id="referForm" name="referForm">
					<input type="hidden" id="referIdx" name="referIdx" />
					<input type="hidden" id="attachIdx" name="attachIdx" />
					<table>
						<colgroup>
							<col width="100">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>카테고리</span></th>
								<td class="clear">
									<select name="referCateIdx" id="referCateIdx" class="sel">
										<option value="">선택</option>
									</select>
									<a href="javascript:void(0);" class="default_btn fr" id="insertReferCateFormBtn"><i class="glyphicon glyphicon-edit"></i> 카테고리 편집</a>
								</td>
							</tr>
							<tr>
								<th><span>제목</span></th>
								<td><input type="text" id="referTitle" name="referTitle" class="input" style="width:100%"></td>
							</tr>
							<tr>
								<th><span>내용</span></th>
								<td>
									<textarea id="referContents" name="referContents" style="width:100%" class="textarea" rows="10"></textarea>
								</td>
							</tr>
							<tr>
								<th><span>파일첨부</span></th>
								<td>
									<input multiple="multiple" type="file" class="hidden" name="referFiles" id="referFiles" style="width:100%" />
									<label for="referFiles" class="btn file_upload">파일 선택</label>
									<span class="upload_text ml-16"></span>
								</td>
							</tr>
							<tr>
								<th><span>저장파일목록</span></th>
								<td class="fileList">
<!-- 									<label><input type="checkbox" name="selFiles" checked>이거</label> -->
								</td>
							</tr>
						</tbody>			
					</table>
				</form>
			</div>
		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmReferBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelReferBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->


    <!-- ###### 카테고리 편집 Popup Start ###### -->
    <div id="layerbox" class="category_edit" style="min-width:400px;">
        <div class="stit">
        	<h2>카테고리 편집</h2>        	
			<a href="#;" id="cancelFAQCateBtnX">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="company_list mt10">				
				<table>
					<colgroup>
						<col width="50">
						<col>
						<col width="50">
					</colgroup>
					<thead>
						<tr>
							<th>No</th>
							<th>카테고리명</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody id="referCateTBody">
					</tbody>
				</table>
			</div>
			<div class="set_tbl mt10 clear">
				<form id="referCateForm" name="referCateForm">
					<input type="hidden" id="referCateIdx2" name="referCateIdx" />
					<div class="fl" style="width:calc(100% - 120px);">
						<table>
							<colgroup>
								<col width="120">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th><span>카테고리명</span></th>
									<td><input type="text" id="referCateName" name="referCateName" class="input" style="width:100%"></td>
								</tr>
							</tbody>			
						</table>
					</div>
					<div class="fr">
						<input type="submit" id="confirmReferCateBtn" value="추가하기" class="submit" onclick="return false">
					</div>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="cancel_btn w80" id="cancelFAQCateBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### --> 