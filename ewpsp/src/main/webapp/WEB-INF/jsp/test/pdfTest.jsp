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
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script src="/static/js/jquery-1.9.1.min.js"></script>
<script src="/static/js/pdf/html2canvas.js"></script>
<!-- <script src="/js/pdf/canvas2image.js"></script> -->
<script src="/static/js/pdf/jspdf.min.js"></script>
<script src="/static/js/common_util.js"></script>
<script type="text/javascript">
	$(function () {
		$("#pdfDown1Btn").click(function() {
			var c = document.getElementById("pdfTest");
// 			c.ownerDocument.defaultView.innerHeight = c.clientHeight;
// 		    c.ownerDocument.defaultView.innerWidth = c.clientWidth;
			html2canvas(c, {
				onrendered : function(canvas){
// 					document.body.appendChild(canvas);
// 	                // scale paper height based on ratio new canvas height and width
// 	                var paperHeight = 210 * (canvas.height / canvas.width);
// 	                var paperFormatInMm = [210, paperHeight];
// 	                var doc = new jsPDF('p', 'mm', paperFormatInMm);
// 	                doc.addImage(canvas, 'PNG', 2, 2);
					// 이미지저장
// 					if (canvas.msToBlob) { // 망할 익스플로러 예외처리.. 망해라 M$
// 		                var blob = canvas.msToBlob();
// 		                window.navigator.msSaveBlob(blob, "FILENAME.png");
// 		            } else {
// 		                Canvas2Image.saveAsPNG(canvas, document.body.clientWidth, document.body.clientHeight, "FILENAME");
// 		            }
					
					document.getElementById("imgResult").src = canvas.toDataURL();   // 이미지를 보여주고 싶으면 이런식으로 치환해버림 됨
					
					// 캔버스를 이미지로 변환
				    var imgData = canvas.toDataURL('image/png', 1);
// 				    var imgData = canvas.toDataURL('image/jpeg', 1.0);
				     
				    var imgWidth = 210; // 이미지 가로 길이(mm) A4 기준
				    var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
				    var imgHeight = canvas.height * imgWidth / canvas.width;
				    var heightLeft = imgHeight;
				     
				        var doc = new jsPDF('p', 'mm');
				        var position = 0;
				         
				        // 첫 페이지 출력
				        doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
				        heightLeft -= pageHeight;
				         
				        // 한 페이지 이상일 경우 루프 돌면서 출력
				        while (heightLeft >= 20) {
				          position = heightLeft - imgHeight;
				          doc.addPage();
				          doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
				          heightLeft -= pageHeight;
				        }
				        
				 
				        // 파일 저장
				        doc.save('pdf테스트요.._'+new Date().getTime()+'.pdf');
				}
			});
		});
		
		$("#pdfDown2Btn").click(function() {
			html2canvas( document.getElementById("pdfTest"), {
				complete: resultPDF(canvas)
			} );
			
			
// 			html2canvas(document.getElementById("pdfTest"), {
// 				onrendered : function(canvas){
					
// 					document.getElementById("imgResult").src = canvas.toDataURL();   // 이미지를 보여주고 싶으면 이런식으로 치환해버림 됨
					
// 					console.log("ㅎㅎㅎ  "+$("#pdfTest").text());
// // 					var imgData = canvas.toDataURL('image/png');
// // 					console.log("Report Image url : "+imgData);
// 					var doc = new jsPDF('p','mm',[297,210]);
// // 					doc.addImage(imgData, 'PNG', 10,10,190,95);
// // 					doc.save('pdf테스트요.._'+new Date().getTime()+'.pdf');
					
// 				}
// 			});
		});
		
		$("#printBtn").click(function() {
// 			excelDownloadTest();
			
		});
		
		$("#closeBtn").click(function() {
			window.close();
			
		});
		
	});
	
	function resultPDF() {
		console.log("resultPDF");
		console.log("ㅎㅎㅎ  "+$("#pdfTest").text());
	}

	
</script>
</head>
<body>
	<div style="border: solid;">
		<button id="pdfDown1Btn">pdf 저장(jsp에서 저장하는방식)</button>
		<button id="pdfDown2Btn">pdf 저장(java에서 저장하는방식)</button>
		<button id="printBtn">프린터 인쇄</button>
		<button id="closeBtn">닫기</button>
	</div>
	<br><br>
	<div id="pdfTest" style="border: solid;">
		<br>
		<div style="border: solid;">한전 요금 청구서('18년 5월)</div>
		<span>고객명 : 홍길동</span>
		<span>청구일 : 2018-07-20</span>
		<div style="border: solid;">이번 달 청구 금액은 <em>2,200,000</em>원 입니다.</div>
		
		<div style="border: solid;">
			<table border="1">
				<tr>
					<th>전기사용장소</th>
					<td>울산광역시 울주군 온산읍 원산로 40</td>
				</tr>
				<tr>
					<th>고객번호</th>
					<td>10 0000 0001</td>
				</tr>
				<tr>
					<th>청구금액</th>
					<td>2,220,000 원</td>
				</tr>
				<tr>
					<th>납기일</th>
					<td>2018년 08월 15일</td>
				</tr>
				<tr>
					<th>고객전용지정계좌 (예금주 : 한국전력공사)</th>
					<td>
						우리은행  100-100000-10-100     신한은행  100-100000-10-100<br>
						국민은행  100-100000-10-100     농      협  100-100000-10-100 <br>
						하나은행  100-100000-10-100     기업은행  100-100000-10-100<br>
						외환은행  100-100000-10-100     우 체 국   100-100000-10-100<br>
						씨티은행  100-100000-10-100
					</td>
				</tr>
			</table>
			<span>※ 위 계좌번호는 고객님께서 입금할 수 있는 전용 지정계좌입니다. (끝자리 원단위 입금불가)</span>
		</div>
		
		<div style="border: solid;">
			<div style="border: solid; display: inline-block;">
				<div>청구내역</div>
				<table border="1">
					<tr>
						<th>기본요금</th>
						<td>10,000</td>
					</tr>
					<tr>
						<th>전력량요금</th>
						<td>2,000,000</td>
					</tr>
					<tr>
						<th>전기요금계</th>
						<td>2,010,000</td>
					</tr>
					<tr>
						<th>부가가치세</th>
						<td>200,000</td>
					</tr>
					<tr>
						<th>전력기금</th>
						<td>10,006</td>
					</tr>
					<tr>
						<th>원단위절사</th>
						<td>4</td>
					</tr>
					<tr>
						<th>당월요금계</th>
						<td>2,220,000</td>
					</tr>
					<tr>
						<th>미납요금</th>
						<td>0</td>
					</tr>
					<tr>
						<th>청구금액</th>
						<td>2,220,000</td>
					</tr>
				</table>
			</div>
			<div style="border: solid; display: inline-block;">
				<div>고객사항</div>
				<table border="1">
					<tr>
						<th>전기사용 계약종별</th>
						<td>산업용(을) 고압B 선택3</td>
					</tr>
					<tr>
						<th>주거구분</th>
						<td>비주거용</td>
					</tr>
					<tr>
						<th>정기검침일</th>
						<td>25</td>
					</tr>
					<tr>
						<th>계량기번호</th>
						<td>XXX001122</td>
					</tr>
					<tr>
						<th>계량기배수</th>
						<td>1</td>
					</tr>
					<tr>
						<th>계약전력</th>
						<td>3</td>
					</tr>
					<tr>
						<th>가구수</th>
						<td>1</td>
					</tr>
				</table>
				<table border="1">
					<tr>
						<th colspan="2">미납내역</th>
					</tr>
					<tr>
						<th>미납일</th>
						<th>금액</th>
					</tr>
					<tr>
						<td></td>
						<td>미납요금 없음</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<br><br><br><br>
	<img id="imgResult" src="">
</body>
</html>