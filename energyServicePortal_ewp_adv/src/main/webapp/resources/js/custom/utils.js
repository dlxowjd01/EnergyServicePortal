//////////////////////////////////////////////문자관련//////////////////////////////////////////////

// 문자열 모두바꾸기
function replaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
}

/**
 * 바이트 문자 입력가능 문자수 체크
 * @param id : tag id
 * @param title : tag title
 * @param maxLength : 최대 입력가능 수 (byte)
 * @returns {Boolean}
 */
function maxLengthCheck(id, title, maxLength, event) {
	var obj = $("#" + id);
//     console.log(obj+", "+obj.val());
	if (maxLength == null) {
		maxLength = obj.attr("maxLength") != null ? obj.attr("maxLength") : 1000;
	}
//     console.log(Number(byteCheck(obj))+", "+Number(byteCheck(maxLength)));
	if (Number(byteCheck(obj)) > Number(maxLength)) {
//         alert(title + "이(가) 입력가능문자수를 초과하였습니다.\n(영문, 숫자, 일반 특수문자 : " + maxLength + " / 한글, 한자, 기타 특수문자 : " + parseInt(maxLength/2, 10) + ").");
		obj.focus();
		event.preventDefault();
//         return false;
	} else {
		return;
	}
}

/**
 * 바이트수 반환
 * @param el : tag jquery object
 * @returns {Number}
 */
function byteCheck(el) {
	var codeByte = 0;
	for (var idx = 0; idx < el.val().length; idx++) {
		var oneChar = escape(el.val().charAt(idx));
		if (oneChar.length == 1) {
			codeByte++;
		} else if (oneChar.indexOf("%u") != -1) {
			codeByte += 2;
		} else if (oneChar.indexOf("%") != -1) {
			codeByte++;
		}
	}
	return codeByte;
}

// 영문&숫자만 입력받는 함수
function onlyEngNum(event) {
	var code = event.keyCode;
	if ((code >= 65 && code <= 90) || (code >= 97 && code <= 122)) { // 영문
		return;
	}
	if ((code > 47 && code < 58) || (code > 95 && code < 106)) { // 숫자 허용(오른쪽키패트 포함)
		return;
	}
	if (code === 9 || code === 36 || code === 35 || code === 37 ||
		code === 39 || code === 8 || code === 46) { // 특수문자 허용
		return;
	}

	event.preventDefault();
}

// 넘어온 값이 빈값인지 체크
// !value 하면 생기는 논리적 오류를 제거하기 위해 명시적으로 value == 사용
// [], {} 도 빈값으로 처리
var isEmpty = function (value) {
	if (value === "" || value === null || value === undefined || (value !== null && typeof value === "object" && !Object.keys(value).length)) {
		return true;
	} else {
		return false;
	}
};

// 넘어온 값이 특정값인지 체크
var isEqVal = function (value, eqVal) {
	if (!isEmpty(value) && value === eqVal) {
		return true;
	} else {
		return false;
	}
};

//////////////////////////////////////////////숫자관련//////////////////////////////////////////////

// 숫자 콤마 붙이기
function numberComma(num) {
	var parts = num.toString().split(".");
	return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (parts[1] ? "." + parts[1] : "");
//    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// 숫자 단위 변경
function convertUnitFormat(num, unitGbn, len) {
	var formatNum;
	var unit;
	var divNum = 0;

	if (len == null) {
		var str = Math.abs(num).toString();
		len = str.length;
	}

	if (unitGbn == "KRW") {
		formatNum = numberComma(num);
		unit = "KRW";

	} else {
		if (len <= 3) {
			if (unitGbn == "mWh") unit = "mWh";
			if (unitGbn == "Wh") unit = "Wh";
			if (unitGbn == "kWh") unit = "kWh";
			if (unitGbn == "mW") unit = "mW";
			if (unitGbn == "W") unit = "W";
			if (unitGbn == "kW") unit = "kW";

		} else if (len <= 6) {
			divNum = 1000;
			if (unitGbn == "mWh") unit = "Wh";
			if (unitGbn == "Wh") unit = "kWh";
			if (unitGbn == "kWh") unit = "MWh";
			if (unitGbn == "mW") unit = "W";
			if (unitGbn == "W") unit = "kW";
			if (unitGbn == "kW") unit = "MW";

		} else if (len <= 9) {
			divNum = 1000 * 1000;
			if (unitGbn == "mWh") unit = "kWh";
			if (unitGbn == "Wh") unit = "MWh";
			if (unitGbn == "kWh") unit = "GWh";
			if (unitGbn == "mW") unit = "kW";
			if (unitGbn == "W") unit = "MW";
			if (unitGbn == "kW") unit = "GW";

		} else if (len <= 12) {
			divNum = 1000 * 1000 * 1000;
			if (unitGbn == "mWh") unit = "MWh";
			if (unitGbn == "Wh") unit = "GWh";
			if (unitGbn == "kWh") unit = "TWh";
			if (unitGbn == "mW") unit = "MW";
			if (unitGbn == "W") unit = "GW";
			if (unitGbn == "kW") unit = "TW";
		} else {
			divNum = 1000 * 1000 * 1000 * 1000;
			if (unitGbn == "mWh") unit = "GWh";
			if (unitGbn == "Wh") unit = "TWh";
			if (unitGbn == "kWh") unit = "PWh";
			if (unitGbn == "mW") unit = "GW";
			if (unitGbn == "W") unit = "TW";
			if (unitGbn == "kW") unit = "PW";
		}

		if (len <= 3) {
			formatNum = num;
		} else {
			formatNum = Number(num) / divNum;
		}

	}

	if (formatNum == "NaN") formatNum = "0";

	var map = new _Map();
	map.put("formatNum", formatNum);
	map.put("unit", unit);

	return map;
}

// 3자리 숫자를 맞춘다..
// 123 => 123
// 12 => 12.0
// 1 => 1.00
function checkNumLen(num) {
	var chkNum = Math.floor(num);
	chkNum = chkNum.toString();

	var reNum;

	if (chkNum.length == 1) {
		reNum = (Number(num)).toFixed(2)
	} else if (chkNum.length == 2) {
		reNum = (Number(num)).toFixed(1)
	} else if (chkNum.length == 3) {
		reNum = (Number(num)).toFixed(0)
	}

	return reNum;
}

// 소수점 fix자리 반올림
function toFixedNum(num, fix) {
	var no = Number(num);
	return Number(no.toFixed(fix));
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
	return num * (1 + per / 100)
}

// 숫자를 몇퍼센트 감소시키는 공식
// 숫자 * (1 - 퍼센트 / 100)
function numMinusPer(num, per) {
	return num * (1 - per / 100)
}

// 숫자만 입력받는 함수
function onlyNum(event) {
	var code = event.keyCode;
	if ((code > 47 && code < 58) || (code > 95 && code < 106)) { // 숫자 허용(오른쪽키패트 포함)
		return;
	}
	if (code === 9 || code === 36 || code === 35 || code === 37 ||
		code === 39 || code === 8 || code === 46) { // 특수문자 허용
		return;
	}

	event.preventDefault();
}

/**
 * 정수와 소수
 * 만을 입력 할 수 있게 한다.
 *
 * @param event
 */
const onlyDecimal = (event) => {
	let code = event.keyCode;
	let key = event.key;
	let regExp =  /^[0-9]+$/;
	if ((code > 47 && code < 58) || (code > 95 && code < 106)) { // 숫자 허용(오른쪽키패트 포함)
		if(key.match(regExp)) {
			return;
		}
	}

	if (code === 9 || code === 36 || code === 35 || code === 37 ||
		code === 39 || code === 8 || code === 46 || code == 189 ||code == 190 || code == 110) { // 특수문자 허용
		return;
	}
	event.preventDefault();
}

//////////////////////////////////////////////날짜관련//////////////////////////////////////////////

// 날짜에 utc 적용여부
var localYn = "N"; // 개발서버인 경우 N으로 변경
function convertDateUTC(_dateTimestamp) {
//	if(localYn == "Y") {
//		return _dateTimestamp;
//	} else if(localYn == "N") {
	var tm = new Date(_dateTimestamp);
	var cvrtDt = new Date(tm.getUTCFullYear(), tm.getUTCMonth(), tm.getUTCDate(), tm.getUTCHours(), tm.getUTCMinutes(), tm.getUTCSeconds()).getTime();
	return cvrtDt;
//	}

}

// date.getTime()
function dateFormat_getTime(_date) {
	return _date.getTime();

}

// 계절 구분
// 봄 : 3월 1일~5월 31일
// 여름 : 6월 1일~8월 31일
// 가을 : 9월 1일~10월 31일
// 겨울 : 11월 1일~익년 2월 말일
function checkSeason(_date) {
	var chkDate = _date instanceof Date ? _date : new Date(_date);
	var chkMonth = chkDate.getMonth() + 1;

	if (chkMonth == 3 || chkMonth == 4 || chkMonth == 5) {
		return 1;
	} else if (chkMonth == 6 || chkMonth == 7 || chkMonth == 8) {
		return 2;
	} else if (chkMonth == 9 || chkMonth == 10) {
		return 3;
	} else if (chkMonth == 1 || chkMonth == 2 || chkMonth == 11 || chkMonth == 12) {
		return 4;
	}
}

// 공휴일여부 체크(true:공휴일, false:평일or토요일)
function chkHoliday(_date) {
	var chkDate = _date instanceof Date ? _date : new Date(_date);
	var week = ['일', '월', '화', '수', '목', '금', '토'];
	var dayOfWeek = week[chkDate.getDay()];

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
	];


	if ((chkDate.getDay() == 0) || ($.inArray(chkDate.format("yyyy-MM-dd"), holiday) > -1)) { // 일요일이거나 법정공휴일?인 경우
		return true;
	} else {
		return false;
	}
}

// 두개의 날짜를 비교하여 차이를 알려준다.
const dateDiff = (eDate, sDate, type) => {
	eDate = eDate instanceof Date ? eDate : new Date(eDate.substring(2, 4), eDate.substring(4, 6) - 1, eDate.substring(6, 8));
	sDate = sDate instanceof Date ? sDate : new Date(sDate.substring(2, 4), sDate.substring(4, 6) - 1, sDate.substring(6, 8));

	if (type == undefined) {
		let diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
		return Math.ceil(diff / (1000 * 3600 * 24));
	} else {
		if (type == 'day') {
			return (((((eDate - sDate) / 1000) / 60) / 60) / 24) + 1;
		} else if (type == 'month') {
			if (eDate.format('yyyyMMdd').substring(0, 4) == sDate.format('yyyyMMdd').substring(0, 4)) {
				return (eDate.format('yyyyMMdd').substring(4, 6) * 1 - sDate.format('yyyyMMdd').substring(4, 6) * 1) + 1;
			} else {
				return Math.round((eDate - sDate) / (1000 * 60 * 60 * 24 * 365 / 12)) + 1;
			}
		}
	}
}

// 이번주 시작일자를 구한다
function findWeak(now) {
	var nowDayOfWeek = now.getDay();
	var nowDay = now.getDate();
	var nowMonth = now.getMonth();
	var nowYear = now.getYear();
	nowYear += (nowYear < 2000) ? 1900 : 0;
	var weekStartDate = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek);
//    var weekEndDate = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek));
	return weekStartDate;
}

//////////////////////////////////////////////엑셀다운관련//////////////////////////////////////////////

$(function () {

	// 엑셀 다운로드
	// Ajax 파일 다운로드
	jQuery.download = function (url, data, method) {
		// url과 data를 입력받음
		if (url && data) {
			// data 는  string 또는 array/object 를 파라미터로 받는다.
			data = typeof data == 'string' ? data : jQuery.param(data);
			// 파라미터를 form의  input으로 만든다.
			var inputs = '';
			jQuery.each(data.split('&'), function () {
				var pair = this.split('=');
				inputs += '<input type="hidden" name="' + pair[0] + '" value="' + pair[1] + '" />';
			});
			// request를 보낸다.
			jQuery('<form action="' + url + '" method="' + (method || 'post') + '">' + inputs + '</form>')
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
		}
	};

});


var tableToExcel = (function () {
	var uri = 'data:application/vnd.ms-excel;base64,'
		,
		template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
		, base64 = function (s) {
			return window.btoa(unescape(encodeURIComponent(s)))
		}
		, format = function (s, c) {
			return s.replace(/{(\w+)}/g, function (m, p) {
				return c[p];
			})
		};
	return function (table, name, e) {
		if (!table.nodeType) table = document.getElementById(table);
		var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML};
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
		} else {
			var a = document.createElement('a');
			a.href = uri + base64(format(template, ctx));
			var downTmsp = (new Date()).format("yyyyMMddHHmmss");
			a.download = name + '_' + downTmsp + '.xls';
			a.click();
			e.preventDefault();
		}
	}
})();

function ifIE() {
	var isIE11 = navigator.userAgent.indexOf(".NET CLR") > -1;
	var isIE11orLess = isIE11 || navigator.appVersion.indexOf("MSIE") != -1;
	return isIE11orLess;
}

function excelDownload(excelName, e, gbn) {
	$val = $("#pc_use_dataDiv").find('tbody');
	var cnt = 0;
	if (gbn == "drResult") {
		$td = $val.find('tr:eq(0)').find('td');
		var tdCnt = $td.length;
		cnt = (tdCnt == 1) ? 0 : 1;
	} else {
		cnt = $val.length;
	}

	if (cnt < 1) {
		alert("다운받을 데이터가 없습니다.");
	} else {
		if (confirm("엑셀로 저장하시겠습니까?")) {
			tableToExcel('pc_use_dataDiv', excelName, e);
		}
	}
}

function excelDownload2(excelName, e, gbn) {
	drawExcelTable();
	var $val = $("#excel_dataDiv").find('tbody');
	var cnt = 0;
	if (gbn == "drResult") {
		$td = $val.find('tr:eq(0)').find('td');
		var tdCnt = $td.length;
		cnt = (tdCnt == 1) ? 0 : 1;
	} else {
		cnt = $val.length;
	}

	if (cnt < 1) {
		alert("다운받을 데이터가 없습니다.");
	} else {
		if (confirm("엑셀로 저장하시겠습니까?")) {
			tableToExcel('excel_dataDiv', excelName, e);
		}
	}
}

function deviceExcelDownload(excelName, e, gbn) {
	$val = $("#pc_use_dataDiv").find('tbody');
	var cnt = 0;

	var tdCnt = excelCnt;
	cnt = (tdCnt == 0) ? 0 : tdCnt;

	if (cnt < 1) {
		alert("다운받을 데이터가 없습니다.");
	} else {
		if (confirm("엑셀로 저장하시겠습니까?")) {
//			var divId = "device"+selectDeviceGbn+"Div";
//			tableToExcel(divId, excelName, e);

			// 엑셀 다운로드
			$.download('/excelDownload.do',
				"gbn=" + selectDeviceGbn
//					+"&COL_NM="+col_kor
				, 'post');
		}
	}
}

//2020-02-07 박진형 xls download
function exportExcel(infoName) {
	if ('drResult' != infoName) {
		drawExcelTable(); //엑셀테이블 그리기
	}

	// step 1. workbook 생성
	var wb = XLSX.utils.book_new();
	// step 2. 시트 만들기
	var newWorksheet = excelHandler.getWorksheet(infoName);
	// step 3. workbook에 새로만든 워크시트에 이름을 주고 붙인다.
	XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName(infoName));
	// step 4. 엑셀 파일 만들기
	var wbout = XLSX.write(wb, {bookType: 'xlsx', type: 'binary'});
	// step 5. 엑셀 파일 내보내기
	saveAs(new Blob([s2ab(wbout)], {type: "application/octet-stream"}), excelHandler.getExcelFileName(infoName));
}

var excelHandler = {
	getExcelFileName: function (infoName) {
		var downTmsp = (new Date()).format("yyyyMMddHHmmss");
		return infoName + '_' + downTmsp + '.xlsx';
	},
	getSheetName: function (infoName) {
		return infoName + 'Sheet';
	},
	getExcelData: function (infoName) {
		var ArrOfArr = [];
		var xlsTableArr = [];
		if ('drResult' != infoName) {
			xlsTableArr = $('#excel_dataDiv .chart_table');
			for (var i = 0; i < xlsTableArr.length; i++) {
				var tableObj = xlsTableArr[i];
				var ArrFromTable = tableToArr(tableObj);
				for (var j = 0; j < ArrFromTable.length; j++) {
					ArrOfArr.push(tableToArr(tableObj)[j]);
				}
				ArrOfArr.push([]); //개행을 위한 배열 추가
			}
		} else {
			xlsTableArr = tableToArr($('.dr_use')[0]); // dr 테이블 엑셀다운로드 로직 필요
			ArrOfArr = xlsTableArr;
		}
		return ArrOfArr;
	},
	getWorksheet: function (infoName) {
		return XLSX.utils.aoa_to_sheet(this.getExcelData(infoName));
	}
}

function tableToArr(tableObj) { // table -> Array 변환 함수
	var arr = [];
	var allTRs = tableObj.getElementsByTagName("tr");
	for (var trCounter = 0; trCounter < allTRs.length; trCounter++) {
		var tmpArr = [];
		var allTHsInTR = allTRs[trCounter].getElementsByTagName("th");
		var allTDsInTR = allTRs[trCounter].getElementsByTagName("td");
		for (var thCounter = 0; thCounter < allTHsInTR.length; thCounter++) {
			var spanInTH = allTHsInTR[thCounter].getElementsByTagName("span");
			if (spanInTH.length > 0) {
				tmpArr.push(spanInTH[0].innerHTML);
			} else {
				tmpArr.push(allTHsInTR[thCounter].innerHTML);
			}
		}
		for (var tdCounter = 0; tdCounter < allTDsInTR.length; tdCounter++) {
			tmpArr.push(allTDsInTR[tdCounter].innerHTML);
		}
		arr.push(tmpArr);
	}
	return arr;
}

function s2ab(s) {  //2진 버퍼 생성
	var buf = new ArrayBuffer(s.length);
	var view = new Uint8Array(buf);
	for (var i = 0; i < s.length; i++) view[i] = s.charCodeAt(i) & 0xFF;
	return buf;
}

//2020-02-07 박진형 xls download
//////////////////////////////////////////////기타//////////////////////////////////////////////

// form의 serialize화
jQuery.fn.serializeObject = function () {
	var obj = null;
	try {
		if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
			var arr = this.serializeArray();
			if (arr) {
				obj = {};
				jQuery.each(arr, function () {
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

// ============ Map 구조 구현============
// var map = new _Map();
// map.put("name","사과");
// map.get("name");
function _Map() {
	this.elements = {};
	this.length = 0;
}

_Map.prototype.put = function (key, value) {
	this.length++;
	this.elements[key] = value;
};

_Map.prototype.get = function (key) {
	return this.elements[key];
};

_Map.prototype.remove = function (key) {
	this.elements[key] = undefined;
};

// ============ List 구조 구현============
// var list = new List();
// list.add("사과");
// list.get(0);
function List() {
	this.elements = {};
	this.idx = 0;
	this.length = 0;
}

List.prototype.add = function (element) {
	this.length++;
	this.elements[this.idx++] = element;
};

List.prototype.get = function (idx) {
	return this.elements[idx];
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
		$('#' + gubun + 'Paging').append('<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + (startPageNum - 1) + ');"> < </a>');

	for (var i = startPageNum; i <= endPageNum; i++) {
		var page = '<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + i + ');">' + i + '</a>';
		if (selectedPageNum == i)
			page = '<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + i + ');" class="active">' + i + '</a>';
		$('#' + gubun + 'Paging').append(page);
	}

	if (endPageNum != lastPageNum) // 맨마지막으로 이동버튼 구현
		$('#' + gubun + 'Paging').append('<a href="javascript:get' + gubunStr + 'List(\'' + eval("my" + gubunStr + "_param") + '\', ' + (endPageNum + 1) + ');"> > </a>');
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
		$paging.append($('<a href="javascript:get' + gubun + 'List(' + (selPageNum - 1) + ')" class="prev" />').append("PREV"));
	} else {
		$paging.append($('<a href="#;" class="prev" />').append("PREV"));
	}

	$paging.append(
		$('<span />').append($("<strong />").append(selPageNum)).append(" / " + totalPageCnt)
	);

	if (selPageNum < totalPageCnt) {
		$paging.append($('<a href="javascript:get' + gubun + 'List(' + (selPageNum + 1) + ')" class="next" />').append("NEXT"));
	} else {
		$paging.append($('<a href="#;" class="next" />').append("NEXT"));
	}
}


$(function () {
	// pdf 저장
	$("#pdfDownBtn").click(function () {
		var c = document.getElementById("statement");
		html2canvas(c, {
			onrendered: function (canvas) {
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
				doc.save('명세서._' + new Date().getTime() + '.pdf');
			}
		});
	});


	// 리스트박스 왼쪽 목록의 데이터 오른쪽으로 이동
	$("#moveRight").click(function () {
		var item = $(".inside_site").find("ul").find("li").find(".on").parent();
		$('.all_site').find("ul").append(item);
		$('.all_site').find("ul").find("li").find(".on").removeClass("on");
	});

	// 리스트박스 오른쪽 목록의 데이터 왼쪽으로 이동
	$("#moveLeft").click(function () {
		var item = $(".all_site").find("ul").find("li").find(".on").parent();
		$('.inside_site').find("ul").append(item);
		$('.inside_site').find("ul").find("li").find(".on").removeClass("on");
	});

});

// 작성일 : 2020-05-08
// 작성자 : lee sang o
// 기능 : json key value 값으로 자동으로 화면에 매핑해주는 기능
function setJsonAutoMapping(json, areaId) {
	var $selecter = null;

	if (areaId != "") {
		$selecter = $("#" + areaId);
	} else {
		$selecter = $("body");
	}

	for (var prop in json) {

		if (typeof json[prop] == "string") {
			setDataMapping($selecter, json, prop);
		} else if (typeof json[prop] == "object") {

			if (Array.isArray(json[prop])) {
				for (var i = 0, count = json[prop].length; i < count; i++) {
					setJsonAutoMapping(json[prop][i], areaId);
				}
			} else {//오브젝트(key, value)
				setJsonAutoMapping(json[prop], areaId);
			}

		} else if(typeof json[prop] == 'number') {
			setDataMapping($selecter, json, prop);
		}
	}
};

function setDataMapping($selecter, json, prop) {
	var $element = $selecter.find("[id='" + prop + "']"), _TagName = $element.prop("tagName");

	if($element.length == 0) {
		$element = $selecter.find("[name='" + prop + "']");
		if($element.length > 1) {
			$element = $element.eq(0);
			_TagName = $element.prop("tagName");
		} else {
			_TagName = $element.prop("tagName");
		}

	}

	if (_TagName == "INPUT") {
		var _Type = $element.attr("type");

		if (_Type == "text" || _Type == "hidden" || _Type == "password") {
			if (String(json[prop]).match(/^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?(([+-]\d\d:\d\d)|Z)?$/i)) {
				let newDate = new Date(json[prop]);
				$element.val(newDate.format('yyyy-MM-dd'));
			} else {
				$element.val(json[prop]);
			}
//			$element.val(json[prop]);
		} else if (_Type == "radio") {
			var _Name = $element.attr("name");
			$selecter.find("[name='" + _Name + "'][value='" + json[prop] + "']").prop("checked", true);
		} else if (_Type == "checkbox") {
			$selecter.find("[id='" + prop + "'][value='" + json[prop] + "']").prop("checked", true);
		}

	} else if (_TagName == "SELECT") {
		$element.val(json[prop]);
	} else if (_TagName == "TEXTAREA") {
		$element.val(json[prop]);
	} else if (_TagName == "DIV") {
		$.each($element.find('li'), function () {
			if ($(this).data('value') == json[prop]) {
				$element.find('button').html($(this).text() + '<span class="caret"></span>').data('value', json[prop]);
			}
		});
	} else {
		if (String(json[prop]).match(/^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?(([+-]\d\d:\d\d)|Z)?$/i)) {
			let newDate = new Date(json[prop]);
			$element.text(newDate.format('yyyy-MM-dd'));
		} else {
			$element.text(json[prop]);
		}
	}
}

//작성일 : 2020-05-08
//작성자 : lee sang o
//기능 : id 영역 안의 edit 화면 처리
function setDataEditMode(areaId) {
	var $areaId = $("#" + areaId);

	$areaId.find("[data-input]").each(function () {
		var $obj = $(this),
			inputType = $obj.data("input"),
			columnName = $obj.data("column"),
			inputCss = $obj.data("class"),
			columnValue = $obj.text(),
			inputTag = [];

		if ("text" == inputType) {
			inputTag.push("<input ");
			inputTag.push("type=\"" + inputType + "\" ");
			inputTag.push("name=\"" + columnName + "\" ");
			inputTag.push("value=\"" + columnValue + "\" ");
			inputTag.push("class=\"" + inputCss + "\" ");
			inputTag.push("/>");
			$obj[0].innerHTML = inputTag.join("");
		} else if ("file" == inputType) {
			inputTag.push("<input ");
			inputTag.push("type=\"" + inputType + "\" ");
			inputTag.push("name=\"" + columnName + "\" ");
			inputTag.push("class=\"" + inputCss + "\" ");
			inputTag.push("/>");
			$obj[0].innerHTML = inputTag.join("");
		}
	});
}

//작성일 : 2020-05-08
//작성자 : lee sang o
//기능 : json list값 공통 화면그리기 초기화
function setInitList(listId) {
	var listRowTag = document.getElementById(listId).innerHTML.replace(/\t/g, '');
	$.data(document, listId, listRowTag);

	var $selecter = $("#" + listId),
		sTagName = $selecter.prop("tagName"),
		tdCount = ($.data(document, listId).match(/<td/g) || []).length,
		sEmptyMsg = "";

	if ("TBODY" == sTagName || "TABLE" == sTagName) {
		sEmptyMsg = "<tr><td colspan='" + tdCount + "' style='text-align:center;'>조회 데이터가 없습니다.</td></tr>";
	} else if ("UL" == sTagName) {
		sEmptyMsg = '<li class=' + '"no-data"'+ '>조회 데이터가 없습니다.</li>';
	} else if ("SELECT" == sTagName) {
		sEmptyMsg = "";
	} else {
		sEmptyMsg = '<div class=' + '"no-data"'+ '>조회 데이터가 없습니다.</div>';
	}

	$selecter.removeData().html(sEmptyMsg);
}

//작성일 : 2020-05-08
//작성자 : lee sang o
//기능 : json list값  공통 화면그리기 처리
function setMakeList(jsonData, listId, opts) {
	var $selecter = $("#" + listId),
		col_left = "[",
		col_right = "]",
		rowHtml = $.data(document, listId),
		arrTagInfo = [],
		arr_column = [],
		dataLenth = jsonData.length,
		tmpHtml = null,
		sTagName = $selecter.prop("tagName"),
		tdCount = ($.data(document, listId).match(/<td/g) || []).length;

	$selecter.data("gridJsonData", jsonData);

	if (dataLenth > 0) {
		for (var prop in jsonData[0]) {
			arr_column.push(prop);
		}
		arr_column.push("INDEX");
	} else {
		if ("TBODY" == sTagName || "TABLE" == sTagName) {
			arrTagInfo.push("<tr><td colspan='" + tdCount + "' style='text-align:center;'>조회 데이터가 없습니다.</td></tr>");
		} else if ("UL" == sTagName) {
			arrTagInfo.push('<li class=' + '"no-data"'+ '>조회 데이터가 없습니다.</li>');
		} else if ("SELECT" == sTagName) {
			arrTagInfo.push("");
		} else {
			arrTagInfo.push('<div class=' + '"no-data"'+ '>조회 데이터가 없습니다.</div>');
		}
	}

	var columLength = arr_column.length;
	for (var i = 0; i < dataLenth; i++) {
		jsonData[i]["INDEX"] = i;
		tmpHtml = rowHtml;
		for (var j = 0; j < columLength; j++) {

			if (opts.dataFunction[arr_column[j]]) {
				tmpHtml = tmpHtml.split(col_left + arr_column[j] + col_right).join(opts.dataFunction[arr_column[j]](jsonData[i][arr_column[j]]));
			} else {
				tmpHtml = tmpHtml.split(col_left + arr_column[j] + col_right).join(jsonData[i][arr_column[j]]);
			}
		}

		if(opts.dataFunction['align']) {
			tmpHtml = alignFunc(tmpHtml);
		}
		arrTagInfo.push(tmpHtml);
	}
	$selecter.html(arrTagInfo.join(""));
}

function alignFunc(tmpHtml) {
	let $div = $('<div>').append(tmpHtml);

	$div.find('.dbclickopen td').each(function() {
		let text = $(this).text();
		if(text == '-') {
			$(this).removeAttr('class');
		}
	});

	return $div.html();
}

//작성일 : 2020-05-14
//작성자 : lee sang o
//기능 : json list값  csv파일 생성
function getJsonCsvDownload(jsonData, column, header, fileName) {
	var csvData = [],
		headerData = [],
		exportedFilenmae = 'csv_download.csv';

	if (fileName !== undefined) {
		exportedFilenmae = fileName;
	}

	//헤더처리
	for (var i = 0, count = header.length; i < count; i++) {
		headerData.push(header[i]);
	}
	csvData.push(headerData.join(","));

	//내용처리
	for (var i = 0, count = jsonData.length; i < count; i++) {
		var rowData = [];
		for (var j = 0, colSize = column.length; j < colSize; j++) {
			rowData.push(jsonData[i][column[j]]);
		}
		csvData.push(rowData.join(","));
	}


	var blob = new Blob(['\uFEFF' + csvData.join("\r\n")], {type: 'text/csv;charset=UTF-8;'});
	if (navigator.msSaveBlob) { // IE 10+
		navigator.msSaveBlob(blob, exportedFilenmae);
	} else {
		var link = document.createElement("a");
		if (link.download !== undefined) {
			var url = URL.createObjectURL(blob);
			link.setAttribute("href", url);
			link.setAttribute("download", exportedFilenmae);
			link.style.visibility = 'hidden';
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		}
	}
}

//작성일 : 2020-05-14
//작성자 : lee sang o
//기능 : 특정영역 input 값들 id 기준으로 json 데이터 생성
function setAreaParamData(areaId, type) {
	var $area, param = {};
	if(areaId){
		$area = $('#'+areaId);
	}else{
		$area = $('body');
	}

	$area.find(":text,:password").each(function(){
		var obj = this;

		if($.inArray("hasDatepicker", obj.classList) > -1 && $(this).datepicker('getDate') != null){
			param[obj.getAttribute("id")] = $(this).datepicker('getDate').toISOString();
		} else {
			param[obj.getAttribute("id")] = obj.value;
		}
	});

	$area.find("[type='hidden']").each(function(){
		var obj = this;
		param[obj.getAttribute("id")] = obj.value;
	});

	$area.find(":checkbox").each(function(){
		var obj = this;
		if(obj.checked == true){
			param[obj.getAttribute("id")] = obj.value;
		}
	});

	$area.find(":radio").each(function(){
		var obj = this;
		if(obj.checked == true){
			param[obj.getAttribute("name")] = obj.value;
		}
	});

	$area.find("select").each(function(){
		var obj = this;
		param[obj.getAttribute("id")] = obj.value;
	});

	$area.find("textarea").each(function(){
		var obj = this;
		param[obj.getAttribute("id")] = obj.value;	// \n 특수기호 처리해야함

	});

	if(type != undefined && type == 'dropdown') {
		$area.find('button.btn-primary').each(function() {
			var obj = this;
			param[obj.parentElement.getAttribute('id')] = $(this).data('value');	// \n 특수기호 처리해야함
		});
	}

	//alert(JSON.stringify(param));
	return param;
};

/**
 * 테이블에 라인 추가 (아직 작업중)
 *
 * @param tblId
 */
function addRowTable(tblId) {
	var table = document.getElementById(tblId);
	var objTable = $('#' + tblId);
	var rowClone = table.rows[table.rows.length - 1];
	var row = table.insertRow(-1);
	var trLength = objTable.find('tbody tr').length;

	copyAttribute(rowClone, row);

	for (var i = 0; i < table.rows[table.rows.length - 2].cells.length; i++) {
		var cellClone = rowClone.cells[i];
		var cell = row.insertCell();
		cell.innerHTML = cellClone.innerHTML;
		copyAttribute(cellClone, attributeVary(cell, trLength));
	}

	//함수 있으면 실행하기
	if (typeof (rowAppend) == 'function') {
		rowAppend();
	}
}

/**
 * 각 셀의 input id, name도 row에 따라 증가하도록 수정
 *
 * @param cell
 * @param rowNum
 * @returns {*}
 */
function attributeVary(cell, rowNum) {
	if (cell.innerHTML != '' && cell.getElementsByTagName('input')[0] != undefined) {
		var inpAttr = cell.getElementsByTagName('input')[0].attributes;
		for (var i = 0; i < inpAttr.length; i++) {
			var attrib = inpAttr[i];
			if (attrib.name == 'id' || attrib.name == 'name') {
				var attVal = attrib.value.split('_')[0];
				cell.getElementsByTagName('input')[0].setAttribute(attrib.name, attVal + '_' + rowNum);
			}
		}
	}

	if (cell.innerHTML != '' && cell.getElementsByTagName('label')[0] != undefined) {
		var lebelAttr = cell.getElementsByTagName('label')[0].attributes;
		for (var i = 0; i < lebelAttr.length; i++) {
			var attrib = lebelAttr[i];
			if (attrib.name == 'for') {
				var attVal = attrib.value.split('_')[0];
				cell.getElementsByTagName('label')[0].setAttribute(attrib.name, attVal + '_' + rowNum);
			}
		}
	}

	return cell;
}

/**
 * 셀 속성 복사 (아직 작업중)
 *
 * @param source
 * @param target
 */
function copyAttribute(source, target) {
	var attr = source.attributes;
	for (var i = 0; i < attr.length; i++) {
		var attrib = attr[i];
		if (attrib.specified) {
			target.setAttribute(attrib.name, attrib.value);
		}
	}

	if (source.style.cssText != '') target.style.cssText = source.style.cssText;
	if (source.className != '') target.className = source.className;

}

function genUuid() {
	function s4() {
		return ((1 + Math.random()) * 0x10000 | 0).toString(16).substring(1);
	}
	return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

/**
 * 버튼으로 Row 증감할 항목 선
 *
 * @param listId
 */
const initRow = function (listId) {
	let listRowTag = document.getElementById(listId).innerHTML.replace(/\t/g, '');
	$.data(document, listId, listRowTag);
	$('#' + listId).removeData().html('');
}

/**
 * 버튼으로 Row 증가
 *
 * @param listId
 */
const addRow = function (listId) {
	let rowHtml = $.data(document, listId),
		$selecter = $('#' + listId),
		sTagName = $selecter.prop("tagName"),
		listLength = 0,
		col_left = "[",
		col_right = "]";

	if ('TABLE' == sTagName) {
		listLength = $selecter.find('tbody').children().length;
	} else {
		listLength = $selecter.children().length;
	}

	rowHtml = rowHtml.split(col_left + 'index' + col_right).join(listLength);
	$selecter.append(rowHtml);
}

/**
 * 버튼으로 Row 삭제
 *
 * @param listId -- 선택자 아이디
 * @param index -- 삭제할 Index
 */
const delRow = function (listId, index) {
	let $selecter = $('#'+ listId);

	if (index == undefined) {
		$selecter.empty();
	} else {
		$selecter.children().eq(index).remove();
	}
}

const setttingSuffix = function(keyText) {
	if(keyText.toLowerCase().match('voltage')) {
		suffix = 'V';
	} else if(keyText.toLowerCase().match('current')) {
		suffix = 'A';
	} else if(keyText.toLowerCase().match('power')) {
		suffix = 'W';
	} else {
		suffix = '';
	}

	return suffix;
}

$(function() {
	$(document).on('click', '.sort_table', function(i){
		let tables = $(this);
		for (var i = 0; i < tables.length; ++i) {
			var headers = tables[i].getElementsByTagName('th');
			for (var j = 0; j < headers.length; ++j) {
				// 지역 유효범위에 생성할 중첩 함수
				(function (table, n) {
					headers[j].onclick = function () {
						let sort = 'down';
						if (this.getElementsByTagName('button')[0].classList.length == 1) {
							this.getElementsByTagName('button')[0].classList.add('down');
							sort = 'down';
						} else {
							if (this.getElementsByTagName('button')[0].classList[1] == 'up') {
								this.getElementsByTagName('button')[0].classList.replace('up', 'down');
								sort = 'down';
							} else {
								this.getElementsByTagName('button')[0].classList.replace('down', 'up');
								sort = 'up';
							}
						}
						for (var k = 1; k < headers.length; k++) {
							if (n != k) {
								headers[k].getElementsByTagName('button')[0].classList.remove('up');
								headers[k].getElementsByTagName('button')[0].classList.remove('down');
							}
						}
						SortTable(table, n, sort)
					};
				}(tables[i], j));
			}
		}
	})
});

function SortTable(table, n, sort) {
	// table 에 tbody tag 가 반드시 존재한다고 가정한다.
	let tbody = table.tBodies[0];
	let rows = tbody.querySelectorAll('tr');
	let rows2 = tbody.querySelectorAll('tr.detail_info');
	rows = Array.prototype.slice.call(rows, 0);
	rows.sort(function (row1, row2) {
		var cell1 = row1.getElementsByTagName("td")[n];
		var cell2 = row2.getElementsByTagName("td")[n];
		var value1 = cell1.textContent || cell1.innerText;
		var value2 = cell2.textContent || cell2.innerText;

		if(value1 == '-'){
			return 1;
		}else{
			value1 = String(value1).replace(/^\s+|\s+$/g, "");
			value2 = String(value2).replace(/^\s+|\s+$/g, "");

			if (isNumberic(value1) && isNumberic(value2)) {
				value1 = Number(value1.replace(/[^0-9]/g, ''));
				value2 = Number(value2.replace(/[^0-9]/g, ''));
			}

			if (sort == 'up') {
				if (value1 < value2) return -1;
				if (value1 > value2) return 1;
			} else {
				if (value1 < value2) return 1;
				if (value1 > value2) return -1;
			}
		}

		return 0;
	});


	// 정렬된 배열로 row 를 다시 저장한다. 문서에 이미 존재하는 node 는 삽입하면 해당 node 는 자동으로 제거되고 새 위치에 저장된다.
	for (var i = 0; i < rows.length; ++i) {
		let flag = rows[i].classList[1];
		tbody.appendChild(rows[i]);

		for (var j = 0; j < rows2.length; j++) {
			if (rows2[j].classList.contains(flag)) {
				tbody.appendChild(rows2[j]);
			}
		}
	}
}

function isNumberic(num) {
	var regex = /^(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
	if (regex.test(num)) {
		num = String(num).replace(/,/g, "");
		return isNaN(num) ? false : true;
	} else {
		return false;
	}
}

function paging(page, jsonList) {
	let totalPage = Math.ceil(jsonList.length/pagePerData);
	let totalnav = Math.ceil(totalPage/navCount);
	let startNum = (pagePerData*(page-1));
	let endNum = ((pagePerData*page)>= jsonList.length)? jsonList.length : (pagePerData*page);
	jsonList = jsonList.slice(startNum, endNum);
	makeNavigation(page, totalPage);
	return jsonList;
}

function makeNavigation (page, totalPage) {
	$('#paging').empty();
	let pageStr = '';
	let navgroup = Math.floor((page-1)/navCount)+1;
	let startPage = ((navgroup-1)*navCount)+1;
	let totalnav = Math.ceil(totalPage/navCount);
	let endPage = ((startPage + navCount-1) > totalPage)? totalPage : (startPage + navCount-1);

	if (navgroup == 1) {
		pageStr += '<a href="javascript:void(0);" class="btn_prev first_prev">prev</a>';
	} else{
		pageStr += '<a href="javascript:getDataList(' + Number(startPage-1) + ');" class="btn_prev">prev</a>';
	}

	for (let i = startPage ; i <= endPage; i++) {
		if (i==page) {
			pageStr += '<a href="javascript:getDataList('+i+');"><strong>'+i+'</strong></a>';
		} else {
			pageStr += '<a href="javascript:getDataList('+i+');">'+i+'</a>';
		}
	}

	if (navgroup <totalnav) {
		pageStr += '<a href="javascript:getDataList(' + Number(endPage+1) + ');"  class="btn_next">next</a>';
	} else {
		pageStr += '<a href="javascript:void(0);"  class="btn_next larst_next">next</a>';
	}

	$('#paging').append(pageStr);
}

/**
 * 조회한 기간의 기준일 배열을 만든다.
 *
 * @param interval
 * @returns {any[]}
 */
const makeStandard = (interval) => {
	let standard = new Array();
	let sDate = $('#fromDate').datepicker('getDate').format('yyyyMMdd')
	let eDate = $('#toDate').datepicker('getDate').format('yyyyMMdd')

	if (interval == 'day') {
		let diffDay = dateDiff(eDate, sDate, 'day');
		for (let j = 0; j < diffDay; j++) {
			let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
			sDateTime.setDate(Number(sDateTime.getDate()) + j);
			let toDate = sDateTime.format('yyyyMMdd');
			standard.push(toDate);
		}
	} else if (interval == 'month') {
		let diffMonth = dateDiff(eDate, sDate, 'month');
		for (let j = 0; j < diffMonth; j++) {
			let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) + j - 1, 1);
			let toDate = sDateTime.format('yyyyMM');
			standard.push(toDate);
		}
	} else {
		let diffDay = dateDiff(eDate, sDate, 'day');
		//diffDay 1보다 크면 시작일과 종료일이 다르다.
		for (let j = 0; j < diffDay; j++) {
			let sDateTime = new Date(Number(sDate.substring(0, 4)), Number(sDate.substring(4, 6)) - 1, Number(sDate.substring(6, 8)));
			sDateTime.setDate(sDateTime.getDate() + j);
			let toDate = sDateTime.format('yyyyMMdd');

			for (let i = 0; i < 24; i++) {
				if (interval == '15min') { //15분
					if (String(i).length == 1) {
						standard.push(toDate + '0' + i + '0000');
						standard.push(toDate + '0' + i + '1500');
						standard.push(toDate + '0' + i + '3000');
						standard.push(toDate + '0' + i + '4500');
					} else {
						standard.push(toDate + i + '0000');
						standard.push(toDate + i + '1500');
						standard.push(toDate + i + '3000');
						standard.push(toDate + i + '4500');
					}
				} else if (interval == '30min') { //30분
					if (String(i).length == 1) {
						standard.push(toDate + '0' + i + '0000');
						standard.push(toDate + '0' + i + '3000');
					} else {
						standard.push(toDate + i + '0000');
						standard.push(toDate + i + '3000');
					}
				} else { //시간
					if (String(i).length == 1) {
						standard.push(toDate + '0' + i + '0000');
					} else {
						standard.push(toDate + i + '0000');
					}
				}
			}
		}
	}

	return standard;
}

/**
 * 날짜 기준값을 받아서 테이블을 생성한다.
 *
 * @param standard
 * @param interval
 */
const makeTableTemplate = (standard, interval) => {
	$('#datatable').empty();
	let index = 0;

	let targetTable = document.createElement('table');
	let thead = targetTable.createTHead();
	let tbody = targetTable.createTBody();
	let hRow = thead.insertRow();
	let bRow = tbody.insertRow();

	let hCell, firstTh = '', firstTd = '', thText = '', tdText = '', stdDate = '';

	targetTable.setAttribute('class', 'his_tbl');
	tbody.setAttribute('id', 'table_' + index);

	standard.forEach((stnd, idx) => {
		if (stdDate != ''
			&& (((interval == '15min' || interval == 'hour') && stdDate != stnd.substring(0, 8))
				|| (interval == 'day' && stdDate != stnd.substring(0, 6))
				|| (interval == 'month' && stdDate != stnd.substring(0, 4)))
			|| standard.length == idx + 1) {

			if (standard.length == idx + 1) {
				if (interval == 'day') {
					thText = stnd.substring(6, 8);
					tdText = stnd + '000000';
				} else if (interval == 'month') {
					thText = stnd.substring(4, 6);
					tdText = stnd + '01000000';
				} else {
					thText = stnd.substring(8, 10) + ':' + stnd.substring(10, 12);
					tdText = stnd;
				}
				makeTableCell(hRow, hCell, bRow, thText, tdText);
			}

			let $div = $('<div>').addClass('chart_table');
			let html = $('<div>').addClass('fold_div').append(targetTable);
			html.appendTo($div);
			$('#datatable').append($div);
			setInitList('table_' + index);

			index++
			targetTable = document.createElement('table');
			thead = targetTable.createTHead();
			tbody = targetTable.createTBody();
			hRow = thead.insertRow();
			bRow = tbody.insertRow();
			targetTable.setAttribute('class', 'his_tbl');
			tbody.setAttribute('id', 'table_' + index);

			if (interval == 'day') {
				stdDate = stnd.substring(0, 6);
				firstTh = stdDate.replace(/(\d{4})(\d{2})/, '$1-$2');
				firstTd = '[name]';
				thText = stnd.substring(6, 8);
				tdText = stnd + '000000';
			} else if (interval == 'month') {
				stdDate = stnd.substring(0, 4);
				firstTh = stdDate;
				firstTd = 'name';
				thText = stnd.substring(4, 6);
				tdText = stnd + '01000000';
			} else {
				stdDate = stnd.substring(0, 8);
				firstTh = stdDate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
				firstTd = 'name';
				thText = stnd.substring(8, 10) + ':' + stnd.substring(10, 12);
				tdText = stnd;
			}
			makeTableCell(hRow, hCell, bRow, firstTh, firstTd);
			makeTableCell(hRow, hCell, bRow, thText, tdText);
		} else {
			if(idx == 0) {
				if (interval == 'day') {
					stdDate = stnd.substring(0, 6);
					firstTh = stdDate.replace(/(\d{4})(\d{2})/, '$1-$2');
					firstTd = '[name]';
					thText = stnd.substring(6, 8);
					tdText = stnd + '000000';
				} else if (interval == 'month') {
					stdDate = stnd.substring(0, 4);
					firstTh = stdDate;
					firstTd = 'name';
					thText = stnd.substring(4, 6);
					tdText = stnd + '01000000';
				} else {
					stdDate = stnd.substring(0, 8);
					firstTh = stdDate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
					firstTd = 'name';
					thText = stnd.substring(8, 10) + ':' + stnd.substring(10, 12);
					tdText = stnd;
				}
				makeTableCell(hRow, hCell, bRow, firstTh, firstTd);
				makeTableCell(hRow, hCell, bRow, thText, tdText);

				if (standard.length == idx + 1) {
					let $div = $('<div>').addClass('chart_table');
					let html = $('<div>').addClass('fold_div').append(targetTable);
					html.appendTo($div);
					$('#datatable').append($div);
					setInitList('table_' + index);
				}
			} else {
				if (interval == 'day') {
					thText = stnd.substring(6, 8);
					tdText = stnd + '000000';
				} else if (interval == 'month') {
					thText = stnd.substring(4, 6);
					tdText = stnd + '01000000';
				} else {
					thText = stnd.substring(8, 10) + ':' + stnd.substring(10, 12);
					tdText = stnd;
				}

				makeTableCell(hRow, hCell, bRow, thText, tdText);
			}
		}
	});
};

/**
 * 테이블 헤더 셀
 * 테이블 바디 셀
 * 생성
 *
 * @param headerRow
 * @param headerCell
 * @param bodyRow
 * @param headerText
 * @param contentText
 */
const makeTableCell = (headerRow, headerCell, bodyRow, headerText, bodyText) => {
	headerCell = document.createElement('TH');
	headerCell.innerHTML = headerText;
	headerRow.appendChild(headerCell);

	let bodyCell = bodyRow.insertCell();
	bodyCell.innerHTML = '[' + bodyText + ']';
}