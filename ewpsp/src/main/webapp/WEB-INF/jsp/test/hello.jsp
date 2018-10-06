<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="../js/jquery-1.9.1.min.js"></script>
<script src="../js/pdf/html2canvas.js"></script>
<script src="../js/pdf/jspdf.min.js"></script>
<script src="../js/utils.js"></script>
<script src="../js/jquery.form.min.js"></script>
<script type="text/javascript">
	$(function () {
		$("#pdfDownBtn").click(function() {
			html2canvas(document.getElementById("pdfTest"), {
				onrendered : function(canvas){
					var imgData = canvas.toDataURL('image/png');
					console.log("Report Image url : "+imgData);
					var doc = new jsPDF('p','mm',[297,210]);
					doc.addImage(imgData, 'PNG', 10,10,190,95);
					doc.save('pdf테스트요.._'+new Date().getTime()+'.pdf');
				} 
			});
		});
		
		$("#excelDownTest").click(function() {
			excelDownloadTest();
			
		});
		
		$("#pdfPop").click(function() {
			
			window.open("/pdfTest", "", "width=641, height=761, left=300, top=100");
			
		});
		
		$("#uploadFile2").change(function() {
	        alert('changed!');
	    });
		
	});

	function excelDownloadTest() {
		var col_kor = "";
		col_kor = "1번째|2번째|3번째|4번째|5번째";
		console.log("aa");
		
		// 엑셀 다운로드
		$.download('/excelDownloadTest',
				"aa="+$("#aa").val()
				+"&COL_NM="+col_kor
				,'post' );
	}
	
	function fileUpload() {
		var formData = new FormData($("#uploadForm")[0]);
		console.log("formData : "+formData);
        $.ajax({
            type : 'post',
            url : '/fileUpload_test',
            data : formData,
            processData : false,
            contentType : false,
            success : function(html) {
                alert("파일 업로드하였습니다.");
            },
            error : function(error) {
                alert("파일 업로드에 실패하였습니다.");
                console.log(error);
                console.log(error.status);
            }
        });
	}
</script>
</head>
<body>
	hello world
	<br><br><br><br>
	<!-- <span id="excelDownTest">여기 눌러서 엑셀다운로드 테스트</span> -->
	<a id="excelDownTest">여기 눌러서 엑셀다운로드 테스트</a><br><br><br>
	<input type="text" id="aa" name="aa" value="">
	<br><br><br>
	<form id="uploadForm" name="uploadForm" enctype="multipart/form-data">
	<input type="file" id="uploadFile1" name="uploadFile1">
	<input type="file" id="uploadFile2" name="uploadFile2">
	<input type="text" id="bbb" name="bbb" value="">
	<input type="text" id="ccc" name="ccc" value="">
	<br><input type="button" onclick="fileUpload();" value="파일업로드">
	</form>
	<br><br><br>
	<button id="pdfPop">pdf화면출력테스트(팝업)</button>
	<br><br><br>
	<button id="pdfDownBtn">pdf 테스트</button>
	<br><br><br>
	<span id="pdfTest">
	<table border='1'>
		<tr>
			<td>이름</td>
			<td></td>
			<td></td>
		</tr>
	</table>
	</span>
</body>
</html>