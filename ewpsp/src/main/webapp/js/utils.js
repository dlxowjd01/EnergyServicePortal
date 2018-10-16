

//////////////////////////////////////////////문자관련//////////////////////////////////////////////

// 문자열 모두바꾸기
function replaceAll(str, searchStr, replaceStr) {
    return str.split(searchStr).join(replaceStr);
}

//////////////////////////////////////////////숫자관련//////////////////////////////////////////////

// 숫자 콤마 붙이기
function numberComma(num) {
	return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// 전체값에서 일부값은 몇퍼센트?
// 일부값 / 전체값 * 100
function numOfTotal_per(totalNum, num) {
	return num / totalNum * 100
}

// 전체값의 몇퍼센트는 얼마?
// 전체값 * 퍼센트 / 100
function perOfTotal_num(totalNum, per) {
	return totalNum / per * 100
}

// 숫자를 몇퍼센트 증가시키는 공식
// 숫자 * (1 + 퍼센트 / 100)
function numPlusPer(num, per) {
	return num*( 1+per/100 )
}

// 숫자를 몇퍼센트 감소시키는 공식
// 숫자 * (1 - 퍼센트 / 100)
function numMinusPer(num, per) {
	return num*( 1-per/100 )
}

// 숫자만 입력받는 함수
//function onlyNum(obj) {
//	var inputVal = $(obj).val();
//    $(obj).val(inputVal.replace(/[^0-9]/gi,''));
//}
//function onlyNum(event) {
//	if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
//        return true;
//    } else {
//        event.returnValue = false;
//    }
//}
function onlyNum(event) {
	var code = event.keyCode;
	if ( (code > 47 && code < 58) || (code > 95 && code < 106) ) { // 숫자 허용
		return;
	}
	if (code === 9 || code === 36 || code === 35 || code === 37 || 
			code === 39 || code === 8 || code === 46) { // 특수문자 허용
		return;
	}
	
	event.preventDefault();
}

//////////////////////////////////////////////날짜관련//////////////////////////////////////////////

// 날짜에 utc 적용여부
var localYn="N"; // 개발서버인 경우 N으로 변경
function convertDateUTC(_dateTimestamp) {
	if(localYn == "Y") {
		return _dateTimestamp;
	} else if(localYn == "N") {
		var tm = new Date(_dateTimestamp);
		var cvrtDt = new Date(tm.getUTCFullYear(), tm.getUTCMonth(), tm.getUTCDate(), tm.getUTCHours(), tm.getUTCMinutes(), tm.getUTCSeconds()).getTime()
		return cvrtDt;
	}
	
}

// 계절 구분
// 봄 : 3월 1일~5월 31일
// 여름 : 6월 1일~8월 31일
// 가을 : 9월 1일~10월 31일
// 겨울 : 11월 1일~익년 2월 말일
function checkSeason(_date) {
	var chkDate = _date instanceof Date ? _date : new Date(_date);
	var chkMonth = chkDate.getMonth()+1;
	
	if(chkMonth == 3 || chkMonth == 4 || chkMonth == 5) {
		return 1;
	} else if(chkMonth == 6 || chkMonth == 7 || chkMonth == 8) {
		return 2;
	} else if(chkMonth == 9 || chkMonth == 10) {
		return 3;
	} else if(chkMonth == 1 || chkMonth == 2 || chkMonth == 11 || chkMonth == 12) {
		return 4;
	}
}

// 공휴일여부 체크(true:공휴일, false:평일or토요일)
function chkHoliday(_date) {
	var chkDate = _date instanceof Date ? _date : new Date(_date);
	var week = ['일', '월', '화', '수', '목', '금', '토'];
	var dayOfWeek = week[chkDate.getDay()];
	console.log(dayOfWeek+", "+chkDate.getDay());
	
	var holiday = [
		// 2018
			"2018-01-01", // 신정
			"2018-02-15", // 설날
			"2018-02-16", // 설날
			"2018-02-17", // 설날
			"2018-03-01", // 3.1절
			"2018-05-05", // 어린이날
			"2018-05-22", // 석가탄신일
			"2018-06-06", // 현충일
			"2018-08-15", // 광복절
			"2018-09-24", // 추석
			"2018-09-25", // 추석
			"2018-09-26", // 추석
			"2018-10-03", // 개천절
			"2018-10-09", // 한글날
			"2018-12-25", // 성탄절
		// 2019
			"2019-01-01", // 신정
			"2019-02-04", // 설날
			"2019-02-05", // 설날
			"2019-02-06", // 설날
			"2019-03-01", // 3.1절
			"2019-05-05", // 어린이날
			"2019-05-12", // 석가탄신일
			"2019-06-06", // 현충일
			"2019-08-15", // 광복절
			"2019-09-12", // 추석
			"2019-09-13", // 추석
			"2019-09-14", // 추석
			"2019-10-03", // 개천절
			"2019-10-09", // 한글날
			"2019-12-25", // 성탄절
		// 2020
			"2020-01-01", // 신정
			"2020-01-24", // 설날
			"2020-01-25", // 설날
			"2020-01-26", // 설날
			"2020-03-01", // 3.1절
			"2020-05-05", // 어린이날
			"2020-05-30", // 석가탄신일
			"2020-06-06", // 현충일
			"2020-08-15", // 광복절
			"2020-09-30", // 추석
			"2020-10-01", // 추석
			"2020-10-02", // 추석
			"2020-10-03", // 개천절
			"2020-10-09", // 한글날
			"2020-12-25", // 성탄절
		// 2021
			"2021-01-01", // 신정
			"2021-02-11", // 설날
			"2021-02-12", // 설날
			"2021-02-13", // 설날
			"2021-03-01", // 3.1절
			"2021-05-05", // 어린이날
			"2021-05-19", // 석가탄신일
			"2021-06-06", // 현충일
			"2021-08-15", // 광복절
			"2021-09-20", // 추석
			"2021-09-21", // 추석
			"2021-09-22", // 추석
			"2021-10-03", // 개천절
			"2021-10-09", // 한글날
			"2021-12-25", // 성탄절
		// 2022
			"2022-01-01", // 신정
			"2022-01-31", // 설날
			"2022-02-01", // 설날
			"2022-02-02", // 설날
			"2022-03-01", // 3.1절
			"2022-05-05", // 어린이날
			"2022-05-08", // 석가탄신일
			"2022-06-06", // 현충일
			"2022-08-15", // 광복절
			"2022-09-09", // 추석
			"2022-09-10", // 추석
			"2022-09-11", // 추석
			"2022-10-03", // 개천절
			"2022-10-09", // 한글날
			"2022-12-25" // 성탄절
		]
	
	
	
	if( (chkDate.getDay() == 0) || ($.inArray(chkDate.format("yyyy-MM-dd"), holiday) > -1) ) { // 일요일이거나 법정공휴일?인 경우
		return true;
	} else {
		return false;
	}
}


// 두개의 날짜를 비교하여 차이를 알려준다.
function dateDiff(_date1, _date2) {
	var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
	var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);
	
	diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
	diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());
	
	var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
	diff = Math.ceil(diff / (1000 * 3600 * 24));
	
	return diff;
}

//날짜포멧 변경
Date.prototype.format = function(f) {
	if (!this.valueOf()) return " ";

	var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
	var d = this;
	
	return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
		switch ($1) {
			case "yyyy": return d.getFullYear();
			case "yy": return (d.getFullYear() % 1000).zf(2);
			case "MM": return (d.getMonth() + 1).zf(2);
			case "dd": return d.getDate().zf(2);
			case "E": return weekName[d.getDay()];
			case "HH": return d.getHours().zf(2);
			case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
			case "HH": return (d.getHours()).zf(2);
			case "mm": return d.getMinutes().zf(2);
			case "ss": return d.getSeconds().zf(2);
			case "a/p": return d.getHours() < 12 ? "오전" : "오후";
			default: return $1;
		}
	});
};
String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};


//////////////////////////////////////////////엑셀다운관련//////////////////////////////////////////////

$(function() {

	// 엑셀 다운로드
	// Ajax 파일 다운로드
	jQuery.download = function(url, data, method){
		// url과 data를 입력받음
		if( url && data ) {
			// data 는  string 또는 array/object 를 파라미터로 받는다.
			data = typeof data == 'string' ? data : jQuery.param(data);
			// 파라미터를 form의  input으로 만든다.
			var inputs = '';
			jQuery.each(data.split('&'), function(){ 
				var pair = this.split('=');
				inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
			});
			// request를 보낸다.
			jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
			.appendTo('body').submit().remove();
			// *** 폼을 동적으로 그리고 submit한 후 폼을 remove한다.
			
			/*
			*** 다운로드방법과 상관없이 사용가능 ***
			1. 엑셀 다운로드를 서버에 요청한다. 
			2. 바로 화면에 뭔가(로딩,프로그레스,스핀 등등)를 띄운다.
			3. 서버에서 쿠키를 응답할 때까지 쭈욱 기다린다.
			4. 서버에서는 파일 생성이 완료되면 다운로드 파일을 포함한 응답을 준다.
			5. 응답 헤더에 쿠키가 포함되어 있어 파일다운로드가 시작되면 화면에서는 뭔가를 끈다.
			6. 파일 다운로드가 시작된다. !!
			*/
////			$("#ajaxLoading").show(); // 로딩바 보여주기
//			// 0.5 초마다 fileDownloadToken 라는 쿠키가 있는지 체크합니다.
//			// 해당 쿠키가 있으면 spin을 끄고 fileDownloadToken 쿠키를 지운 후 Interval 을 종료 합니다.
//			FILEDOWNLOAD_INTERVAL = setInterval(function() {
//				if ($.cookie("fileDownloadToken") != null) { 
//					$.cookie('fileDownloadToken', null, {
//						expires : 0,
//						path : location.pathname
//					});
//					clearInterval(FILEDOWNLOAD_INTERVAL);
////					$("#ajaxLoading").hide(); // 로딩바 숨기기
//				}
//			}, 500);
			
		};
	};

});




var tableToExcel = (function () {
    var uri = 'data:application/vnd.ms-excel;base64,'
        , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
        , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
        , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
    return function (table, name, e) {
        if (!table.nodeType) table = document.getElementById(table)
        var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
        var blob = new Blob([format(template, ctx)]);
        var blobURL = window.URL.createObjectURL(blob);

        if (ifIE()) {
            csvData = table.innerHTML;
            if (window.navigator.msSaveBlob) {
                var blob = new Blob([format(template, ctx)], {
                    type: "text/html"
                });
                var downTmsp = (new Date()).format("yyyyMMddHHmmss");
                navigator.msSaveBlob(blob, '' + name + '_' + downTmsp + '.xls');
            }
        }
        else {
        	var a = document.createElement('a');
        	a.href = uri + base64(format(template, ctx))
        	var downTmsp = (new Date()).format("yyyyMMddHHmmss");
        	a.download = name+'_'+downTmsp+'.xls';
        	a.click();
        	e.preventDefault();
        }
    }
})()

function ifIE() {
    var isIE11 = navigator.userAgent.indexOf(".NET CLR") > -1;
    var isIE11orLess = isIE11 || navigator.appVersion.indexOf("MSIE") != -1;
    return isIE11orLess;
}

function excelDownload(excelName, e, gbn) {
	$val = $("#pc_use_dataDiv").find('tbody');
	var cnt = 0;
	if(gbn == "drResult") {
		$td = $val.find('tr:eq(0)').find('td');
		var tdCnt = $td.length;
		console.log(tdCnt+"??");
		cnt = ((tdCnt-1) == 1) ? 0 : 1;
	} else {
		cnt = $val.length;
	}
	console.log(cnt+"!!!");
	
	if(cnt < 1) {
		alert("다운받을 데이터가 없습니다.");
	} else {
		if(confirm("엑셀로 저장하시겠습니까?")) {
			tableToExcel('pc_use_dataDiv', excelName, e);
		}
	}
}

function deviceExcelDownload(excelName, e, gbn) {
	$val = $("#pc_use_dataDiv").find('tbody');
	var cnt = 0;
	
	var tdCnt = excelCnt;
	cnt = (tdCnt == 0) ? 0 : tdCnt;
	
	if(cnt < 1) {
		alert("다운받을 데이터가 없습니다.");
	} else {
		if(confirm("엑셀로 저장하시겠습니까?")) {
//			var divId = "device"+selectDeviceGbn+"Div";
//			tableToExcel(divId, excelName, e);
			
			// 엑셀 다운로드
			$.download('/excelDownload',
					"gbn="+selectDeviceGbn
//					+"&COL_NM="+col_kor
					,'post' );
		}
	}
}

function downloadExcelPopup(targetId) {
	var excelHtml = $("#pc_use_dataDiv").html();
	window.open("/htmlToExcel?excelHtml="+excelHtml, "", "height=100,width=100,top=100,left=200");
//	window.open("data:application/vnd.ms-excel;filename='test.xls',"+encodeURIComponent(excelHtml), "", "height=100,width=100,top=100,left=200");
}





//////////////////////////////////////////////기타//////////////////////////////////////////////

// form의 serialize화
jQuery.fn.serializeObject = function() {
    var obj = null;
    try {
        if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
            var arr = this.serializeArray();
            if (arr) {
                obj = {};
                jQuery.each(arr, function() {
                    obj[this.name] = this.value;
                });
            }//if ( arr ) {
        }
    } catch (e) {
        alert(e.message);
    } finally {
    }
 
    return obj;
};



// 페이징처리
// 모양 : < 1  2  3  4  5  6  7  [8]  9  10 >
// selectedPageNum : 선택한 페이지번호
// all_tot_cnt : 총 페이지갯수
// page_row_cnt : 한번에 보여질 데이터 수
// page_page_cnt : 한번에 보여질 페이지 수
// 수정이 필요한데 현재 사용하지 않기 때문에 수정 안함
function makePageNums1(selectedPageNum, all_tot_cnt, page_row_cnt, page_page_cnt, gubun) {
	var gubunStr = gubun.charAt(0).toUpperCase() + gubun.slice(1);
	$('#' + gubun + 'Paging').empty();

	// startPageNum : 화면에 보이는 시작페이지, endPageNum : 화면에 보이는 끝페이지
	var lastPageNum = parseInt(all_tot_cnt / page_row_cnt);
	if (all_tot_cnt % page_row_cnt != 0)
		lastPageNum = lastPageNum + 1;
	var startPageNum = 1;
	var selectedPageNumPosition = parseInt(selectedPageNum / page_page_cnt) + 1;
	if (selectedPageNum % page_page_cnt == 0)
		selectedPageNumPosition = selectedPageNumPosition - 1;
	var endPageNum = page_page_cnt * selectedPageNumPosition;
	startPageNum = endPageNum - page_page_cnt + 1;
	if (endPageNum > lastPageNum)
		endPageNum = lastPageNum;
	
	
	if (startPageNum != 1) // 맨처음으로 이동버튼 구현
		$('#' + gubun + 'Paging').append( '<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + (startPageNum - 1) + ');"> < </a>');
	
	for (var i = startPageNum; i <= endPageNum; i++) {
		var page = '<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + i + ');">' + i + '</a>';
		if (selectedPageNum == i)
			page = '<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + i + ');" class="active">' + i + '</a>';
		$('#' + gubun + 'Paging').append(page);
	}

	if (endPageNum != lastPageNum) // 맨마지막으로 이동버튼 구현
		$('#' + gubun + 'Paging').append( '<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + (endPageNum + 1) + ');"> > </a>');
}

//페이징처리
//모양 : < 8/10 >
function makePageNums2(pagingMap, gubun) {
	var gubunStr = gubun.charAt(0).toUpperCase() + gubun.slice(1);
	
	var selPageNum = pagingMap.selPageNum; // 선택한 페이지번호
//	var listCnt = pagingMap.listCnt; // 전체 데이터 수
	var pageRowCnt = pagingMap.pageRowCnt; // 한 페이지 당 보여줄 데이터 수
	var totalPageCnt = pagingMap.totalPageCnt; // 전체 페이지 수
	
	$paging = $('#' + gubun + 'Paging');
	$paging.empty();
	if (selPageNum > 1) {
		$paging.append( $('<a href="javascript:get'+gubun+'List('+(selPageNum-1)+')" class="prev" />').append("PREV") );
	} else {
		$paging.append( $('<a href="#;" class="prev" />').append("PREV") );
	} 
	
	$paging.append(
			$('<span />').append( $("<strong />").append(selPageNum) ).append(" / "+totalPageCnt)
	);
	
	if (selPageNum < totalPageCnt) {
		$paging.append( $('<a href="javascript:get'+gubun+'List('+(selPageNum+1)+')" class="next" />').append("NEXT") );
	} else {
		$paging.append( $('<a href="#;" class="next" />').append("NEXT") );
	}
}


$(function () {
	// pdf 저장
	$("#pdfDownBtn").click(function() {
		var c = document.getElementById("statement");
		html2canvas(c, {
			onrendered : function(canvas){
				document.getElementById("imgResult").src = canvas.toDataURL();   // 이미지를 보여주고 싶으면 이런식으로 치환해버림 됨
				
				// 캔버스를 이미지로 변환
			    var imgData = canvas.toDataURL('image/png', 1);
//				    var imgData = canvas.toDataURL('image/jpeg', 1.0);
			     
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
			        doc.save('명세서._'+new Date().getTime()+'.pdf');
			}
		});
	});
	
	// 프린트
//	$(".lbtn_print").click(function() {
//		if(confirm("인쇄하시겠습니까?")) {
////			window.print();
////			$(".lbody").printThis();
////			$(".lbody").printElement({ printMode: 'popup' });
//			print($(".lbody").html());
//		}
//	});
	
	

	// 리스트박스 왼쪽 목록의 데이터 오른쪽으로 이동
	$("#moveRight").click(function(){
		var item = $(".inside_site").find("ul").find("li").find(".on").parent();
		$('.all_site').find("ul").append(item);
		$('.all_site').find("ul").find("li").find(".on").removeClass("on");
	});
	
	// 리스트박스 오른쪽 목록의 데이터 왼쪽으로 이동
	$("#moveLeft").click(function(){
		var item = $(".all_site").find("ul").find("li").find(".on").parent();
		$('.inside_site').find("ul").append(item);
		$('.inside_site').find("ul").find("li").find(".on").removeClass("on");
	});
	
});

function print(printArea)
{
		win = window.open(); 
		self.focus(); 
		win.document.open();
		
		/*
			1. div 안의 모든 태그들을 innerHTML을 사용하여 매개변수로 받는다.
			2. window.open() 을 사용하여 새 팝업창을 띄운다.
			3. 열린 새 팝업창에 기본 <html><head><body>를 추가한다.
			4. <body> 안에 매개변수로 받은 printArea를 추가한다.
			5. window.print() 로 인쇄
			6. 인쇄 확인이 되면 팝업창은 자동으로 window.close()를 호출하여 닫힘
		*/
		win.document.write('<html><head><title></title>');
		win.document.write('</haed><body>');
		win.document.write(printArea);
 		win.document.write('</body></html>');
		win.document.close();
		win.print();
		win.close();
}



