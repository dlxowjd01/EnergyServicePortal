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
function callback_getFAQList(result) {
	var faqList = result.list;

	var strHtml = "";
	$ul = $("#faqList");
	$ul.empty();
	if (faqList == null || faqList.length < 1) {
		$ul.append('<li><a href="#;" class="question"><span class="gubun">검색 결과가 없습니다.<span></a></li>');
	} else {
		for (var i = 0; i < faqList.length; i++) {
			var adminBtn = '';
			if (userInfo != null && userInfo.auth_type == '1') {
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

var insUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
// FAQ
$( function () {
	$("#insertFAQFormBtn").click(function(){
		insUpdFlag = 1;

		$('#faqForm').each(function() {
			this.reset();
		});

		$.ajax({
			url : "/getFAQCateList",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				var list = result.list;

				$faqCateIdxSelBox = $("#faqForm").find("#faqCateIdx");
				$faqCateIdxSelBox.children('option').not(':eq(0)').remove();
				for(var i=0; i<list.length; i++) {
					$faqCateIdxSelBox.append('<option value="' + list[i].faq_cate_idx+'">' + list[i].faq_cate_name + '</option>');
				}
			}
		});

		popupOpen('faqedit');
	});

	$("#confirmFAQBtn").click(function(){
		if ($('#faqCateIdx').val() == '') {
			alert('카테고리를 선택하세요.');
			$('#faqCateIdx').focus();
			return;
		}
		if ($('#question').val() == '') {
			alert('질문을 입력하세요.');
			$('#question').focus();
			return;
		}
		if ($('#answer').val() == '') {
			alert('답변을 입력하세요.');
			$('#answer').focus();
			return;
		}
		var formData = $("#faqForm").serializeObject();
		if (confirm("저장하시겠습니까?")) {
			if(insUpdFlag ==  1) insertFAQ(formData);
			else if(insUpdFlag ==  2) updateFAQ(formData);
		}
	});

	$("#cancelFAQBtn").click(function(){
		insUpdFlag = 0;
		$('#faqForm').each(function() {
			this.reset();
		});

		popupClose('faqedit');
	});
});

function callback_insertFAQ(result) {
	var resultCnt = result.resultCnt;
	if(resultCnt > 0) {
		alert("저장되었습니다.");
		location.reload();
	} else {
		alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	}
}

function updateFAQForm(faqIdx) {
	insUpdFlag = 2;
	getFAQDetail(faqIdx);
}

// FAQ 한건 조회
function callback_getFAQDetail(result) {
	var faqDetail = result.detail;

	if(faqDetail == null) {
		alert("조회된 데이터가 없습니다.");
	} else {
		$("#faqForm").find("#faqIdx").val(faqDetail.faq_idx);
		$("#faqForm").find("#question").val(faqDetail.question);
		$("#faqForm").find("#answer").val(faqDetail.answer);

		$.ajax({
			url : "/getFAQCateList",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				var list = result.list;

				$faqCateIdxSelBox = $("#faqForm").find("#faqCateIdx");
				$faqCateIdxSelBox.children('option').not(':eq(0)').remove();
				for(var i=0; i<list.length; i++) {
					$faqCateIdxSelBox.append('<option value="' + list[i].faq_cate_idx+'">' + list[i].faq_cate_name + '</option>');
				}
			}
		});
		$("#faqForm").find("#faqCateIdx").val(faqDetail.faq_cate_idx);

		popupOpen('faqedit');
	}
}

function callback_updateFAQ(result) {
	var resultCnt = result.resultCnt;
	if(resultCnt > 0) {
		alert("저장되었습니다.");
		location.reload();
	} else {
		alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	}
}

function deleteFAQYn(faqIdx) {
	if(confirm("삭제하시겠습니까?")) {
		deleteFAQ(faqIdx);
	}
}

function callback_deleteFAQ(result) {
	var resultCnt = result.resultCnt;
	if(resultCnt > 0) {
		alert("삭제되었습니다.");
		location.reload();
	} else {
		alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
	}
}

// FAQ 카테고리
$(function() {
	$("#insertFAQCateFormBtn").click(function(){
		insUpdFlag = 1;
		$('#confirmFAQCateBtn').val('추가하기');

		$('#faqCateForm').each(function() {
			this.reset();
		});

		$.ajax({
			url : "/getFAQCateList",
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

		popupOpen('category_edit');
	});

	$("#confirmFAQCateBtn").click(function(){
		if ($('#faqCateName').val() == '') {
			alert('카테고리명을 입력하세요.');
			$('#faqCateName').focus();
			return;
		}
		var formData = $("#faqCateForm").serializeObject();
		if (confirm("저장하시겠습니까?")) {
			if(insUpdFlag ==  1) insertFAQCate(formData);
			else if(insUpdFlag ==  2) updateFAQCate(formData);
		}
	});

	$("#cancelFAQCateBtn").click(function(){
		insUpdFlag = 0;
		$('#confirmFAQCateBtn').val('추가하기');
		$('#faqCateForm').each(function() {
			this.reset();
		});

		popupClose('category_edit');
	});
});

function callback_insertFAQCate(result) {
	var resultCnt = result.resultCnt;
	if(resultCnt > 0) {
		alert("저장되었습니다.");
		location.reload();
	} else {
		alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	}
}

function updateFAQCateForm(faqCateIdx) {
	insUpdFlag = 2;
	$('#confirmFAQCateBtn').val('수정하기');
	getFAQCateDetail(faqCateIdx);
}

// FAQ 카테고리 한건 조회
function callback_getFAQCateDetail(result) {
	var faqCateDetail = result.detail;

	if(faqCateDetail == null) {
		alert("조회된 데이터가 없습니다.");
	} else {
		$("#faqCateForm").find("#faqCateIdx").val(faqCateDetail.faq_cate_idx);
		$("#faqCateForm").find("#faqCateName").val(faqCateDetail.faq_cate_name);

		popupOpen('category_edit');
	}
}

function callback_updateFAQCate(result) {
	var resultCnt = result.resultCnt;
	if(resultCnt > 0) {
		alert("저장되었습니다.");
		location.reload();
	} else {
		alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	}
}

function deleteFAQCateYn(faqCateIdx) {
	if(confirm("삭제하시겠습니까?")) {
		deleteFAQCate(faqCateIdx);
	}
}

function callback_deleteFAQCate(result) {
	var resultCnt = result.resultCnt;
	if(resultCnt > 0) {
		alert("삭제되었습니다.");
		location.reload();
	} else {
		alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
	}
}
