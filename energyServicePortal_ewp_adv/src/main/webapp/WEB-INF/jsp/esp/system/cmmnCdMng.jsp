<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
<%-- <c:set var="linkGbn" value="setting" /> --%>
<style type="text/css">
.sel_tr {
	font-weight:bold;
}

</style>
<script>

	$(document).ready(function() {
		navAddClass("commonCode");
		getDBData();
		
		$('#modifyCdNm').on('click', function() {  //코드이름 수정버튼(임시) codeDtlTbl
			
			if($('.sel_tr').length == 0) {
				alert('수정하실 row를 선택해주세요');
				return false;
			}
			
			var up_code_id = $('.sel_tr').data('up_code_id');
			var code_id = $('.sel_tr').data('code_id');
			
			$.ajax({
		        url: "/system/selectCodeDetail.json",
		        type: 'post',
		        async: false, // 동기로 처리해줌
		        data: {
		        	up_code_id:up_code_id,
		        	code_id:code_id
		        	},
		        success: function (result) {
		        	var codeDetail = result.data;
		    		
		    		$tbody = $("#codeDtlTbl");
		    		$tbody.empty();
		    		
		    		var html = '';
		    		if(codeDetail != null && codeDetail != '') {
		    			
		    			var code_desc = (codeDetail.code_desc == null)? '':codeDetail.code_desc;
		    			var code_name = (codeDetail.code_name == null)? '':codeDetail.code_name;
		    			var use_yn = (codeDetail.use_yn == null)? 'Y':codeDetail.use_yn;
		    			
		    			html += '<tr>';
		    			html += '	<td>상위분류</td>';
		    			html += '	<td>'+codeDetail.up_code_id+'</td>';
		    			html += '</tr>';
		    			html += '<tr>';
		    			html += '	<td>공통코드ID</td>';
		    			html += '	<td><input type="text" class="input" name="code_id" value="'+codeDetail.code_id+'">';
		    			html += '		<input type="hidden" name="ex_code_id" value="'+codeDetail.code_id+'">';
		    			html += '		<input type="hidden" name="up_code_id" value="'+codeDetail.up_code_id+'"></td>';
		    			html += '</tr>';
		    			html += '<tr>';
		    			html += '	<td>공통코드명</td>';
		    			html += '	<td><input type="text" class="input" name="code_name" value="'+code_name+'"></td>';
		    			html += '</tr>';
		    			html += '<tr>';
		    			html += '	<td>공통코드설명</td>';
		    			html += '	<td><input type="text" class="input" name="code_desc" value="'+code_desc+'"></td>';
		    			html += '</tr>';
		    			html += '<tr>';
		    			html += '	<td>사용여부</td>';
		    			html += '	<td><select name="use_yn">';
		    			if(use_yn=='Y') {
			    			html += '		<option value="Y" selected>Y</option>';
			    			html += '		<option value="N">N</option>';
		    			} else {
			    			html += '		<option value="Y">Y</option>';
			    			html += '		<option value="N" selected>N</option>';
		    			}
		    						'</select></td>';
		    			html += '</tr>';
		    		}
		    		$tbody.append(html);
		        }
			});
			popupOpen('codeDtlMng');
		});
		$('#modifySymbolName').on('click', function() { //심볼이름 수정버튼(임시)
			var symbolArr = $('.img_origin_name');
			var symbolNameMap = new Map();
			for (var i =0; i < symbolArr.length; i++){
				if(symbolArr[i].dataset.origin != symbolArr[i].value) {
					var img_idx = symbolArr[i].dataset.idx;
					var newName = symbolArr[i].value;
					symbolNameMap.put(img_idx, newName);
				}
			}
			
			if(symbolNameMap.length > 0) {
				var data = symbolNameMap.elements;
				$.ajax({
			        url: "/system/updateSymbolName.json",
			        type: 'post',
			        async: false, // 동기로 처리해줌
			        data: data,
			        success: function (result) {
			        	console.log('save success!');
			        	alert("수정되었습니다.");
			        }
				});
			} else {
				alert("수정된 내용이 없습니다.");
			}
		});
		
		$("#modifyCdBtn").click(function(){ // 공통코드 관리 버튼
			$(".cmmnCodeMng").find('h2').empty().append("공통코드 관리");
			
			$.ajax({
		        url: "/system/getCmmnCodeList.json",
		        type: 'post',
		        async: false, // 동기로 처리해줌
		        success: function (result) {
		        	var cmmnCodeList = result.list;
		    		
		    		$tbody = $("#codeTbl");
		    		$tbody.empty();
		    		var depth1Tr = '';
		    		var depth2Tr = '';
		    		
		    		if(cmmnCodeList != null && cmmnCodeList.length > 0) {
		    			
		    			for(var i=0; i<cmmnCodeList.length; i++) {
		    				var tempCodeId = cmmnCodeList[i].code_id;
		    				var tempCodeName = cmmnCodeList[i].code_name;
		    				if(cmmnCodeList[i].up_code_id == 'TOP') { //depth1
			    				depth1Tr += '<tr class="depth1" data-up_code_id="'+cmmnCodeList[i].up_code_id+'" data-code_id="'+cmmnCodeList[i].code_id+'">';
			    				depth1Tr += '<td><input type="text" class="input code_name" onchange="saveRow(this, \'U\');" value="'+cmmnCodeList[i].code_name+'"></td>';
			    				depth1Tr += '<td><input type="text" class="input code_id" onchange="saveRow(this, \'U\');" value="'+cmmnCodeList[i].code_id +'"><input type="button" class="resetBtn" onclick="saveRow(this, \'D\')" value="x"></td>';
			    				depth1Tr += '<td></td>';
			    				depth1Tr += '<td></td>';
			    				depth1Tr += '</tr>';
		    				} else { //depth2
		    					depth2Tr += '<tr class="depth2" data-up_code_id="'+cmmnCodeList[i].up_code_id+'" data-code_id="'+cmmnCodeList[i].code_id+'">';
		    					depth2Tr += '<td></td>';
		    					depth2Tr += '<td><p>'+cmmnCodeList[i].up_code_id +'</p></td>';
		    					depth2Tr += '<td><input type="text" class="input code_name" onchange="saveRow(this, \'U\');" value="'+cmmnCodeList[i].code_name +'"></td>';
		    					depth2Tr += '<td><input type="text" class="input code_id" onchange="saveRow(this, \'U\');" value="'+cmmnCodeList[i].code_id +'"><input type="button" class="resetBtn" onclick="saveRow(this, \'D\')" value="x"></td>';
		    					depth2Tr += '</tr>';
		    				} 		    				
		    			}
		    		}
		    		$tbody.append(depth1Tr + depth2Tr);
		        }
			});
			popupOpen('cmmnCodeMng');
		});
		
		$('#modifySymbolBtn').on('click', function () { //심볼라이브러리 관리 버튼
			$.ajax({
		        url: "/system/getSymbolList.json",
		        type: 'post',
		        async: false, // 동기로 처리해줌
		        success: function (result) {
		        	var symbolList = result.list;
		    		
		    		var tbodyStr = "";
		    		$tbody = $("#symbolTbl");
		    		
		    		if(symbolList != null && symbolList.length > 0) {
			    		$tbody.empty();
		    			for(var i=0; i<symbolList.length; i++) {
							tbodyStr += '<tr data-idx="'+symbolList[i].img_idx +'">';
			    			tbodyStr += '	<td>';
		    				var tempImgSrc = '';
							if (symbolList[i].img_path != null && symbolList[i].img_save_name != null) {
								tempImgSrc = result.imgRoot + symbolList[i].img_path + symbolList[i].img_save_name;
							}
			    			tbodyStr += '		<img src="'+tempImgSrc+'" style="width:40px; height: 40px;">';
			    			tbodyStr += '		<input type="file" class="input img_file" value="심볼 업로드"  onchange="saveRow(this, \'U\');">';
			    			tbodyStr += '		<input type="button" class="resetBtn" onclick="parent.saveRow(this, \'D\')" value="심볼 삭제">';
			    			tbodyStr += '	</td>';
			    			tbodyStr += '	<td>';
			    			tbodyStr += '		<input type="text" class="input img_name" onchange="saveRow(this, \'U\');" style="width:100%"  value="'+((symbolList[i].img_origin_name==null) ? '' : symbolList[i].img_origin_name)+'"><br>	';
			    			tbodyStr += '		<input type="text" class="input img_type" onchange="saveRow(this, \'U\');" style="width:100%" maxlength="50" value="'+((symbolList[i].img_type==null) ? '' : symbolList[i].img_type)+'"><br>	';
			    			tbodyStr += '		<input type="text" class="input img_desc" onchange="saveRow(this, \'U\');" style="width:100%" maxlength="50" value="'+((symbolList[i].img_desc==null) ? '' : symbolList[i].img_desc)+'">';
			    			tbodyStr += '	</td>';
			    			tbodyStr += '</tr>';
		    			}
		    			$tbody.append(tbodyStr);
		    		}
		        }
		    });
			popupOpen('symbolMng');
		});
		
		$("#cancelBtn, #cancelBtnX").on('click', function () { //닫기
			popupClose('cmmnCodeMng');
		});
		
		$("#cancelBtn2, #cancelBtnX2").on('click', function () { //닫기
			popupClose('symbolMng');
		});
		$("#cancelBtn3, #cancelBtnX3").on('click', function () { //닫기
			popupClose('codeDtlMng');
		});
		
		$("#confirmBtn").click(function(){ // 코드관리 팝업 내 적용버튼
			var codeTblLen = $("#codeTbl").find('tr').length;
			var saveForm = new FormData();
			
			for (var i = 0; i < codeTblLen; i++) {
				var up_code_id= '', up_code_name= '', code_id= '', code_name  = '';

				if($('#codeTbl').find('tr').eq(i).hasClass('U')){
					up_code_id = $('#codeTbl').find('tr').eq(i).data('up_code_id');
					code_id = $('#codeTbl').find('tr').eq(i).find('.code_id').val();
					code_name = $('#codeTbl').find('tr').eq(i).find('.code_name').val();
					var ex_code_id = $('#codeTbl').find('tr').eq(i).data('code_id');
					if(code_id =='' || code_name == ''){
						alert('필수값을 입력해주세요');
						return false;
					}
					saveForm.set('U'+ i, up_code_id +','+code_id+','+code_name +','+ ex_code_id);
				}
				if($('#codeTbl').find('tr').eq(i).hasClass('D')){
					up_code_id = $('#codeTbl').find('tr').eq(i).data('up_code_id');
					code_id = $('#codeTbl').find('tr').eq(i).data('code_id');
					saveForm.set('D'+ i, up_code_id +','+code_id);
				}
				if($('#codeTbl').find('tr').eq(i).hasClass('I')){
					if($('#codeTbl').find('tr').eq(i).hasClass('depth1')) {
						up_code_id = 'TOP';
						up_code_name = 'NOTUSE';
						code_id = $('#codeTbl').find('tr').eq(i).find('.code_id').val();
						code_name = $('#codeTbl').find('tr').eq(i).find('.code_name').val();
						if(code_id =='' || code_name == ''){
							alert('필수값을 입력해주세요');
							return false;
						}
					} else {
						up_code_id = $('#codeTbl').find('tr').eq(i).find('.up_code_id').val();
						up_code_name = $('#codeTbl').find('tr').eq(i).find('.up_code_name').val();
						code_id = $('#codeTbl').find('tr').eq(i).find('.code_id').val();
						code_name = $('#codeTbl').find('tr').eq(i).find('.code_name').val();
						if(up_code_id =='' || code_name == '' ||code_id =='' || code_name == ''){
							alert('필수값을 입력해주세요');
							return false;
						}
					}
					saveForm.set('I'+ i, up_code_id +','+ code_id +','+code_name +','+ up_code_name);
				}
				up_code_id= '', up_code_name= '', code_id= '', code_name  = '';
			}	
			
		    $.ajax({
		        url: "/system/saveCommonCode.json",
		        type: 'post',
		        processData: false,
		        contentType: false,
				async : false, // 동기로 처리해줌
		        data: saveForm,
		        success: function (result) {
		        	var insertCnt = result.insertCnt;
		        	var updateCnt = result.updateCnt;
		        	var deleteCnt = result.deleteCnt;
		        	
		        	alert(insertCnt+'개 생성,'+updateCnt+ '개 갱신,'+deleteCnt+ '개 삭제 되었습니다.');
		        	popupClose('cmmnCodeMng');
		        	getCmmnCodeList(1);
		        },
		    	error: function (result) {
		    		alert(result.msg);
		    		
		    	}
		    });
		});
		
		$('#confirmBtn2').on('click', function() { //심볼팝업 내 적용버튼
			var symbolTblLen = $("#symbolTbl").find('tr').length;
			var frmIdx = 0;
			var saveForm = new FormData();
			var idx = "";
			var name = "";
			var desc = "";
			
			for (var i = 0; i < symbolTblLen; i++) {
				
				if($('#symbolTbl').find('tr').eq(i).hasClass('U')){
					var img_file = $('#symbolTbl').find('tr').eq(i).find('.img_file')[0].files[0];
					var img_name = $('#symbolTbl').find('tr').eq(i).find('.img_name').val();
					var img_type = $('#symbolTbl').find('tr').eq(i).find('.img_type').val();
					var img_desc = $('#symbolTbl').find('tr').eq(i).find('.img_desc').val();
					var img_idx = $('#symbolTbl').find('tr').eq(i).data('idx');
					
					saveForm.set('U'+ i, img_idx +','+img_name+','+img_type+','+img_desc+','+'file_update'+ i);
					saveForm.set('file_update'+ i, img_file);
				}
				if($('#symbolTbl').find('tr').eq(i).hasClass('D')){
					var img_idx = $('#symbolTbl').find('tr').eq(i).data('idx');
					saveForm.set('D'+ i, img_idx);
				}
				if($('#symbolTbl').find('tr').eq(i).hasClass('I')){
					var img_file = $('#symbolTbl').find('tr').eq(i).find('.img_file')[0].files[0];
					var img_name = $('#symbolTbl').find('tr').eq(i).find('.img_name').val();
					var img_type = $('#symbolTbl').find('tr').eq(i).find('.img_type').val();
					var img_desc = $('#symbolTbl').find('tr').eq(i).find('.img_desc').val();
					var img_idx = $('#symbolTbl').find('tr').eq(i).data('idx');
					
					saveForm.set('I'+ i, 1 +','+img_name+','+img_type+','+img_desc+','+'file_insert'+ i);
					saveForm.set('file_insert'+ i, img_file);
					
				}
			}	
			
		    $.ajax({
		        url: "/system/saveSymbol.json",
		        type: 'post',
		        processData: false,
		        contentType: false,
				async : false, // 동기로 처리해줌
		        data: saveForm,
		        success: function (result) {
		        	var insertCnt = result.insertCnt;
		        	var updateCnt = result.updateCnt;
		        	var deleteCnt = result.deleteCnt;
		        	
		        	alert(insertCnt+'개 생성,'+updateCnt+ '개 갱신,'+deleteCnt+ '개 삭제 되었습니다.');
		        	popupClose('symbolMng');
		        	getSymbolList(1);
		        },
		    	error: function (result) {
		    		alert(result.msg);
		    	}
		    });
		});
		
		$('#confirmBtn3').on('click', function() {
			//valid check
			//valid check
			
			var formData = $('#codeDtlForm').serializeObject();
			
			$.ajax({
				url : "/system/saveCodeDetail.json",
				type : 'post',
				async : false, // 동기로 처리해줌
				data : formData,
				success: function(result) {
					
					var saveCnt = result.saveCnt;
					if(saveCnt > 0) {
						alert('저장되었습니다.');
						popupClose('codeDtlMng');
						getCmmnCodeList(1);
					} else {
						alert('id가 해당 분류에 이미 존재합니다.');
					}
				},
				error: function(result) {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			});
			
		});
		
	});
	
	function saveRow(obj, flag) { // 수정 시 클래스부여
		$(obj).closest('tr').addClass(flag)
		
		if(flag =='D') {
			$(obj).closest('tr').hide();
		}
	}
	
	function getDBData() {
		getCmmnCodeList(1);// 공통코드 조회
		getSymbolList(1);
	}

	//공통코드 조회
	function getCmmnCodeList(selPageNum) {
	    $.ajax({
	        url: "/system/getCmmnCodeList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            selPageNum: selPageNum  //바닥화면에서 호출 시 페이지 번호 넘김
	        },
	        success: function (result) {
	        	var cmmnCodeList = result.list;
	    		
	    		var tbodyStr = "";
	    		$tbody = $("#codeTbody");
	    		$tbody.empty();
	    		var auth_type = sessionUser.auth_type;
	    		
	    		if(cmmnCodeList != null && cmmnCodeList.length > 0) {
	    			for(var i=0; i<cmmnCodeList.length; i++) {
	    				
	    				tbodyStr += '<tr onclick="selectTR(this);"';
	    				tbodyStr += ' data-up_code_id="'+cmmnCodeList[i].up_code_id+'"';
	    				tbodyStr += ' data-code_id="'+cmmnCodeList[i].code_id+'">';
	    				tbodyStr += '<td>'+((cmmnCodeList[i].rnum == null) ? '' : cmmnCodeList[i].rnum )+'</td>'; // 번호
	    				tbodyStr += '<td>'+((cmmnCodeList[i].code_name==null) ? '' : cmmnCodeList[i].code_name)+'</td>'; // 코드명
	    				tbodyStr += '<td>'+((cmmnCodeList[i].code_id==null) ? '' : cmmnCodeList[i].code_id)+'</td>'; // 코드id
	    				var tempYn = (cmmnCodeList[i].use_yn==null) ? '' : cmmnCodeList[i].use_yn;
	    				if(tempYn == 'Y') {
	    					tempYn = '사용';
	    				} else {
	    					tempYn = '미사용';
	    				}
	    				tbodyStr += '<td>'+tempYn+'</td>'; // 사용유무
	    				tbodyStr += '</tr>';
	    			}
	    	
	    			var pagingMap = result.pagingMap;
	    			makePageNums2(pagingMap, "CmmnCode");
	    			
	    		} else {
	    			tbodyStr += '<tr><td colspan="4">조회 결과가 없습니다.</td><tr>';
	    		}
	    		
	    		$tbody.append( tbodyStr );
	        }
	    });
	}
	
	//심볼 조회
	function getSymbolList(selPageNum) {
		$.ajax({
	        url: "/system/getSymbolList.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {
	            selPageNum: selPageNum //바닥화면에서 호출 시 페이지 번호 넘김
	        },
	        success: function (result) {
	        	var symbolList = result.list;
	    		
	    		var tbodyStr = "";
	    		$tbody = $("#symbolTbody");
	    		$tbody.empty();
	    		
	    		if(symbolList != null && symbolList.length > 0) {
	    			for(var i=0; i<symbolList.length; i++) {
	    				
	    				tbodyStr += '<tr>';
	    				tbodyStr += '<td>'+((symbolList[i].rnum == null) ? '' : symbolList[i].rnum )+'</td>'; // 번호
	    				
	    				var tempImgSrc = '';
						if (symbolList[i].img_path != null && symbolList[i].img_save_name != null) {
							tempImgSrc = result.imgRoot + symbolList[i].img_path + symbolList[i].img_save_name;
						}
	    				tbodyStr += '<td><img src="'+tempImgSrc+'" style="width:50px; height:50px"></td>'; // 심볼이미지
	    				tbodyStr += '<td>'
	    							+ '<input type="text" class="img_origin_name"'
	    							+ 'data-idx="'+((symbolList[i].img_idx==null) ? '' : symbolList[i].img_idx)+'"'
	    							+ 'data-origin="'+((symbolList[i].img_origin_name==null) ? '' : symbolList[i].img_origin_name)+'"'
	    							+ 'value="'+((symbolList[i].img_origin_name==null) ? '' : symbolList[i].img_origin_name)+'">'
	    							+ '</td>'; // 심볼명
	    				tbodyStr += '<td>no data</td>'; // 심볼종류가 db 컬럼에 없음
	    				tbodyStr += '</tr>';
	    			}
	    	
	    			var pagingMap = result.pagingMap;
	    			makePageNums2(pagingMap, "Symbol");
	    			
	    		} else {
	    			tbodyStr += '<tr><td colspan="4">조회 결과가 없습니다.</td><tr>';
	    		}
	    		$tbody.append( tbodyStr );
	        }
	    });
	}
	
	function addCode(depth) { //코드 추가
		
		var addHtml = '';
		if(depth == 'depth1') {
			addHtml += '<tr class="I depth1">';
			addHtml += '	<td><input type="text" class="input code_name"></td>';
			addHtml += '	<td><input type="text" class="input code_id"><input type="button" class="resetBtn" onclick="$(this).closest(\'tr\').remove();" value="x"></td>';
			addHtml += '	<td></td>';
			addHtml += '	<td></td>';
			addHtml += '</tr>';
			$("#codeTbl .depth1:last").after(addHtml);
		} else if (depth == 'depth2') {
			addHtml += '<tr class="I depth2">';
			addHtml += '	<td><input type="text" class="input up_code_name"></td>';
			addHtml += '	<td><input type="text" class="input up_code_id"></td>'; 
			addHtml += '	<td><input type="text" class="input code_name"></td>';
			addHtml += '	<td><input type="text" class="input code_id"><input type="button" class="resetBtn" onclick="$(this).closest(\'tr\').remove();" value="x"></td>';
			addHtml += '</tr>';
			$("#codeTbl .depth2:last").after(addHtml);
		}
	}
	
	function addSymbol() { //심볼 추가
		
		var tbodyStr = '';
		tbodyStr += '<tr class="I">';
		tbodyStr += '	<td>';
		tbodyStr += '		<img src="" class="addSymbol" style="width:40px; height: 40px;">';
		tbodyStr += '		<input type="file" class="img_file" class="addSymbol" value="심볼 업로드">';
		tbodyStr += '		<input type="button" class="addSymbol" onclick="$(this).closest(\'tr\').remove();" value="심볼 삭제">';
		tbodyStr += '	</td>';
		tbodyStr += '	<td>';
		tbodyStr += '		<input type="text" class="input img_name" style="width:100%" value=""><br>	';
		tbodyStr += '		<input type="text" class="input img_type" style="width:100%" maxlength="50" value=""><br>	';
		tbodyStr += '		<input type="text" class="input img_desc" style="width:100%" maxlength="50" value="">';
		tbodyStr += '	</td>';
		tbodyStr += '</tr>';
		
		$('#symbolTbl').append(tbodyStr);
	}
	
	function selectTR(obj) {
		$('#codeTbody').find('tr').removeClass('sel_tr');
		$(obj).addClass('sel_tr');
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
								<a href="#;" class="adduser_btn fr" id="modifyCdNm"><i class="glyphicon glyphicon-user"></i>수정</a>
								<a href="#;" class="adduser_btn fr" id="modifyCdBtn"><i class="glyphicon glyphicon-user"></i> 공통코드관리</a>
							</div>
							<div class="s_table">
								<table>
									<colgroup>
										<col width="150">
										<col width="100">
										<col width="150">
										<col width="150">
									</colgroup>
									<thead>
										<tr>
											<th>번호</th>
											<th>코드명</th>
											<th>설비ID</th>
											<th>사용여부</th>
										</tr>
									</thead>
									<tbody id="codeTbody">
										<tr>
											<td colspan="4">조회된 데이터가 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>	
							<div class="paging clear" id="CmmnCodePaging">
							</div>						
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv">
						<div class="set_top clear">
								<a href="#;" class="adduser_btn fr" id="modifySymbolName"><i class="glyphicon glyphicon-user"></i>심볼명 수정</a>
								<a href="#;" class="adduser_btn fr" id="modifySymbolBtn"><i class="glyphicon glyphicon-user"></i> 심볼라이브러리 관리</a>
							</div>
							<div class="s_table">
								<table>
									<colgroup>
										<col width="150">
										<col width="100">
										<col width="150">
										<col width="150">
									</colgroup>
									<thead>
										<tr>
											<th>번호</th>
											<th>심볼이미지</th>
											<th>심볼명</th>
											<th>심볼종류</th>
										</tr>
									</thead>
									<tbody id="symbolTbody">
										<tr>
											<td colspan="4">조회된 데이터가 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>	
							<div class="paging clear" id="SymbolPaging">
							</div>
						</div>
					</div>
				</div>



    <!-- ###### 공통코드 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="cmmnCodeMng" style="min-width:1000px;">
        <div class="stit">
        	<h2>공통코드 등록/수정</h2>        	
			<a href="#;" id="cancelBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl dg_wrap">
				<form id="codeForm" name="codeForm">
					<table>
						<thead>
							<tr>
		    					<th><span>분류</span></th>
		    					<th><span>코드ID</span></th>
		    					<th><span>타입</span></th>
		    					<th><span>코드ID</span></th>
		    				</tr>
						</thead>
						<tbody id="codeTbl">
						</tbody>			
					</table>
				</form>
			</div>
		</div>
		<div>
	<input type="button" value="분류추가" class="addDepth1" onclick="parent.addCode('depth1');">
	<input type="button" value="타입추가" class="addDepth2" onclick="parent.addCode('depth2');">
		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmBtn">적용</a>
			<a href="#;" class="cancel_btn w80" id="cancelBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->
        <!-- ###### 심볼 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="symbolMng" style="min-width:700px; max-height: 700px;overflow-y: auto;">
        <div class="stit">
        	<h2>심볼라이브러리 관리</h2>        	
			<a href="#;" id="cancelBtnX2">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="set_tbl dg_wrap" >
				<form id="symbolForm" name="symbolForm" enctype="multipart/form-data">
					<table>
						<tbody id="symbolTbl">
						</tbody>
					</table>
				</form>
			</div>
		</div>
		<div class="btn_center">
			<input type="button" id="addSymbol" onclick="parent.addSymbol();" value="심볼 추가">
			<a href="#;" class="default_btn w80" id="confirmBtn2">적용</a>
			<a href="#;" class="cancel_btn w80" id="cancelBtn2">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->
        <!-- ###### 코드 디테일 Popup Start ###### -->
    <div id="layerbox" class="codeDtlMng" style="min-width:700px; max-height: 700px;overflow-y: auto;">
        <div class="stit">
        	<h2>코드 상세 수정</h2>        	
			<a href="#;" id="cancelBtnX3">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="set_tbl dg_wrap" >
				<form id="codeDtlForm" name="codeDtlForm">
					<table>
						<tbody id="codeDtlTbl">
						</tbody>
					</table>
				</form>
			</div>
		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmBtn3">적용</a>
			<a href="#;" class="cancel_btn w80" id="cancelBtn3">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->