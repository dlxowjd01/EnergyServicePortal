<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<script type="text/javascript">
	$(function() {
		getUserInfo(setUserInfo);
		getDBData();
	});
	
	var userInfo = null;
	function setUserInfo(result) {
		userInfo = result;
	}
	
	function getDBData() {
		var formData = $("#schForm").serializeObject();
		getFAQList(formData); // FAQ 목록 조회
	}

	// FAQ 목록 조회
	function getFAQList(formData) {
	    $.ajax({
	        url: "/board/getFAQList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var faqList = result.list;
	        	
	    		var strHtml = "";
	    		var $ul = $("#faqList");
	    		$ul.empty();
	    		if (faqList == null || faqList.length < 1) {
	    			$ul.append('<li><a href="#;" class="question"><span class="gubun">검색 결과가 없습니다.<span></a></li>');
	    		} else {
	    			for (var i = 0; i < faqList.length; i++) {
	    				var adminBtn = '';
	    				if (userInfo !== null && userInfo.auth_type === '1') {
	    					adminBtn = $('<div class="edit_btn mt15 fr" />')
	    						.append('<a href="#;" onclick="updateFAQForm(' + faqList[i].faq_idx + ')"><i class="glyphicon glyphicon-edit"></i></a>')
	    						.append('<a href="#;" onclick="deleteFAQYn(' + faqList[i].faq_idx + ')"><i class="glyphicon glyphicon-remove"></i></a>')
	    				}
	    	
	    				$ul.append(
	    					$('<li />')
	    						.append($('<a href="#;" class="question" />')
	    							.append($('<span class="gubun" data-cate-idx="' + faqList[i].faq_cate_idx + '" />').append(faqList[i].faq_cate_name))
	    							.append($('<span class="sbj" />').append(faqList[i].question))
	    						)
	    						.append($('<div class="answer" />')
	    							.append(faqList[i].answer)
	    							.append(adminBtn)
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
	
	function changeFAQCate(aElmt, cateIdx) {
		$('#cateList > a').removeClass('on');
		$(aElmt).addClass('on');
		if (cateIdx == '') {
			$('#faqList > li').show();
		} else {
			$('#faqList > li').each(function(idx, liElmt) {
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

	var faqInsUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	var categoryInsUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	// FAQ
	$( function () {
		$("#insertFAQFormBtn").click(function(){
			faqInsUpdFlag = 1;
	
			$('#faqForm').each(function() {
				this.reset();
			});
	
			$.ajax({
				url : "/board/getFAQCateList.json",
				type : 'post',
				async : false, // 동기로 처리해줌
				success: function(result) {
					var list = result.list;

					var $faqCateIdxSelBox = $("#faqCateIdx");
					$faqCateIdxSelBox.children('option').not(':eq(0)').remove();
					for(var i=0; i<list.length; i++) {
						$faqCateIdxSelBox.append('<option value="' + list[i].faq_cate_idx+'">' + list[i].faq_cate_name + '</option>');
					}
				}
			});
	
			popupOpen('faqedit');
		});
	
		$("#confirmFAQBtn").click(function(){
			var $faqCateIdx = $('#faqCateIdx');
			if ( isEmpty($faqCateIdx.val()) ) {
				alert('카테고리를 선택하세요.');
				$faqCateIdx.focus();
				return;
			}
			var $question = $('#question');
			if ( isEmpty($question.val()) ) {
				alert('질문을 입력하세요.');
				$question.focus();
				return;
			}
			var $answer = $('#answer');
			if ( isEmpty($answer.val()) ) {
				alert('답변을 입력하세요.');
				$answer.focus();
				return;
			}
			var formData = $("#faqForm").serializeObject();
			if (confirm("저장하시겠습니까?")) {
				if(faqInsUpdFlag ===  1) insertFAQ(formData);
				else if(faqInsUpdFlag ===  2) updateFAQ(formData);
			}
		});
	
		$("#cancelFAQBtn").click(function(){
			faqInsUpdFlag = 0;
			$('#faqForm').each(function() {
				this.reset();
			});
	
			popupClose('faqedit');
		});
	});

	// FAQ 등록
	function insertFAQ(formData) {
	    $.ajax({
	        url: "/board/insertFAQ.json",
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
	
	function updateFAQForm(faqIdx) {
		faqInsUpdFlag = 2;
		getFAQDetail(faqIdx);
	}

	// FAQ 한건 조회
	function getFAQDetail(faqIdx) {
	    $.ajax({
	        url: "/board/getFAQDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            faqIdx: faqIdx
	        },
	        success: function (result) {
	        	var faqDetail = result.detail;
	        	
	    		if(faqDetail == null) {
	    			alert("조회 결과가 없습니다.");
	    		} else {
	    			$("#faqIdx").val(faqDetail.faq_idx);
	    			$("#question").val(faqDetail.question);
	    			$("#answer").val(faqDetail.answer);
	    	
	    			$.ajax({
	    				url : "/board/getFAQCateList.json",
	    				type : 'post',
	    				async : false, // 동기로 처리해줌
	    				success: function(result) {
	    					var list = result.list;

	    					var $faqCateIdxSelBox = $("#faqCateIdx");
	    					$faqCateIdxSelBox.children('option').not(':eq(0)').remove();
	    					for(var i=0; i<list.length; i++) {
	    						$faqCateIdxSelBox.append('<option value="' + list[i].faq_cate_idx+'">' + list[i].faq_cate_name + '</option>');
	    					}
	    				}
	    			});
	    			$("#faqCateIdx").val(faqDetail.faq_cate_idx);
	    	
	    			popupOpen('faqedit');
	    		}
	        }
	    });
	}

	// FAQ 수정
	function updateFAQ(formData) {
	    $.ajax({
	        url: "/board/updateFAQ.json",
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
	
	function deleteFAQYn(faqIdx) {
		if(confirm("삭제하시겠습니까?")) {
			deleteFAQ(faqIdx);
		}
	}

	// FAQ 삭제
	function deleteFAQ(faqIdx) {
	    $.ajax({
	        url: "/board/deleteFAQ.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            faqIdx: faqIdx
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
		$("#insertFAQCateFormBtn").click(function(){
			faqCateInit();
	
			popupOpen('category_edit');
		});
	
		$("#confirmFAQCateBtn").click(function(){
			var $faqCateName= $('#faqCateName');
			if ( isEmpty($faqCateName.val()) ) {
				alert('카테고리명을 입력하세요.');
				$faqCateName.focus();
				return;
			}
			var formData = $("#faqCateForm").serializeObject();
			if (confirm("저장하시겠습니까?")) {
				if(categoryInsUpdFlag ===  1) insertFAQCate(formData);
				else if(categoryInsUpdFlag ===  2) updateFAQCate(formData);
			}
		});

		$("#cancelFAQCateBtn, #cancelFAQCateBtnX").click(function(){
			categoryInsUpdFlag  = 0;
			$('#confirmFAQCateBtn').val('추가하기');
			$('#faqCateForm').each(function() {
				this.reset();
			});
	
			popupClose('category_edit');
		});
	});

	function faqCateInit() {
		categoryInsUpdFlag = 1;
		$('#confirmFAQCateBtn').val('추가하기');

		$('#faqCateForm').each(function() {
			this.reset();
		});

		getFAQCateList();
	}

	function getFAQCateList() {
		$.ajax({
			url : "/board/getFAQCateList.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				var list = result.list;

				$tbody = $("#faqCateTBody");
				$tbody.empty();
				for (var i = 0; i < list.length; i++) {
					$tbody.append(
							$('<tr />')
									.append($('<td />').append(i + 1))
									.append($('<td />').append('<a href="#;" onclick="updateFAQCateForm(' + list[i].faq_cate_idx + ')">' + list[i].faq_cate_name + '</a>'))
									.append($('<td />').append('<a href="#;" onclick="deleteFAQCateYn(' + list[i].faq_cate_idx + ')"><i class="glyphicon glyphicon-remove"></i></a>'))
					);
				}
			}
		});
	}

	// FAQ 카테고리 등록
	function insertFAQCate(formData) {
	    $.ajax({
	        url: "/board/insertFAQCate.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			faqCateInit();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function updateFAQCateForm(faqCateIdx) {
		categoryInsUpdFlag = 2;
		$('#confirmFAQCateBtn').val('수정하기');
		getFAQCateDetail(faqCateIdx);
	}

	// FAQ 카테고리 한건 조회
	function getFAQCateDetail(faqCateIdx) {
	    $.ajax({
	        url: "/board/getFAQCateDetail.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            faqCateIdx: faqCateIdx
	        },
	        success: function (result) {
	        	var faqCateDetail = result.detail;
	        	
	    		if(faqCateDetail == null) {
	    			alert("조회 결과가 없습니다.");
	    		} else {
	    			$("#faqCateIdx2").val(faqCateDetail.faq_cate_idx);
	    			$("#faqCateName").val(faqCateDetail.faq_cate_name);
	    	
	    			popupOpen('category_edit');
	    		}
	        }
	    });
	}

	// FAQ 카테고리 수정
	function updateFAQCate(formData) {
	    $.ajax({
	        url: "/board/updateFAQCate.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("저장되었습니다.");
	    			faqCateInit();
	    		} else {
	    			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}
	
	function deleteFAQCateYn(faqCateIdx) {
		if(confirm("삭제하시겠습니까?")) {
			getFAQListCnt(faqCateIdx);
		}
	}

	// FAQ 카테고리 내 게시물 존재 유무 체크
	function getFAQListCnt(faqCateIdx) {
		$.ajax({
			url: "/board/getFAQListCnt.json",
			type: 'post',
			async: false, // 동기로 처리해줌
			data: {
				cateIdx: faqCateIdx
			},
			success: function (result) {
				var cnt = result.resultCnt;
				if(cnt > 0) {
					if(confirm("카테고리 안에 게시물이 "+cnt+"건 존재합니다. 그래도 카테고리를 삭제 하시 겠습니까?")) {
						deleteFAQCate(faqCateIdx);
					}
				} else {
					deleteFAQCate(faqCateIdx);
				}
			},
			error: function (request, status, error) {
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}

	// FAQ 카테고리 삭제
	function deleteFAQCate(faqCateIdx) {
	    $.ajax({
	        url: "/board/deleteFAQCate.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            faqCateIdx: faqCateIdx
	        },
	        success: function (result) {
	        	var msg = result.msg;
	    		var resultCnt = result.resultCnt;
	    		if(resultCnt > 0) {
	    			alert("삭제되었습니다.");
	    			faqCateInit();
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
						<h1 class="page-header">자주하는 질문</h1>
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
									<a href="#;" onclick="changeFAQCate(this, '')" class="on">전체</a>
									<c:forEach var="item" items="${faqCateList}">
									<a href="#;" onclick="changeFAQCate(this, '${item.faq_cate_idx}')">${item.faq_cate_name}</a>
									</c:forEach>
								</div>
								<ul class="faq_list mt15" id="faqList">
								</ul>
							</div>
							<c:if test="${not empty userInfo and userInfo.auth_type eq '1'}">
								<div class="faq_bottom mt30 clear">
									<a href="#;" class="default_btn fr" id="insertFAQFormBtn"><i class="glyphicon glyphicon-plus"></i> 글쓰기</a>
								</div>
							</c:if>
						</div>
					</div>
				</div>




    <!-- ###### 게시물 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="faqedit" style="min-width:600px;">
        <div class="stit">
        	<h2>자주하는 질문 등록</h2>        	
			<a href="javascript:popupClose('faqedit');">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="set_tbl">
				<form id="faqForm" name="faqForm">
					<input type="hidden" id="faqIdx" name="faqIdx" />
					<table>
						<colgroup>
							<col width="100">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>카테고리</span></th>
								<td class="clear">
									<select name="faqCateIdx" id="faqCateIdx" class="sel">
										<option value="">선택</option>
									</select>
									<a href="#;" class="default_btn fr" id="insertFAQCateFormBtn"><i class="glyphicon glyphicon-edit"></i> 카테고리 편집</a>
								</td>
							</tr>
							<tr>
								<th><span>질문</span></th>
								<td><input type="text" id="question" name="question" class="input" style="width:100%"></td>
							</tr>
							<tr>
								<th><span>답변</span></th>
								<td>
									<textarea id="answer" name="answer" style="width:100%" class="textarea" rows="10"></textarea>
								</td>
							</tr>
						</tbody>			
					</table>
				</form>
			</div>
		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmFAQBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelFAQBtn">취소</a>
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
					<tbody id="faqCateTBody">
					</tbody>
				</table>
			</div>
			<div class="set_tbl mt10 clear">
				<form id="faqCateForm" name="faqCateForm">
					<input type="hidden" id="faqCateIdx2" name="faqCateIdx" />
					<div class="fl" style="width:calc(100% - 120px);">
						<table>
							<colgroup>
								<col width="120">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th><span>카테고리명</span></th>
									<td><input type="text" id="faqCateName" name="faqCateName" class="input" style="width:100%"></td>
								</tr>
							</tbody>			
						</table>
					</div>
					<div class="fr">
						<input type="submit" id="confirmFAQCateBtn" value="추가하기" class="submit" onclick="return false">
					</div>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="cancel_btn w80" id="cancelFAQCateBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### --> 