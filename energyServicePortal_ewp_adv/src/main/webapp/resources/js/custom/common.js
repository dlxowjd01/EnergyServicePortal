// 세션 userInfo 조회
function getUserInfo(fn) {
	$.ajax({
		url: "/getUserInfo",
		type: 'post',
		async: false, // 동기로 처리해줌
		success: function (result) {
			fn(result);
		}
	});
}

$(function() {
	$('.dropdown-menu li a').on('click', function(){
		selectBoxTextApply(this);
	});
});

function selectBoxTextApply(obj) {
	var txt = $(obj).text();
	$(obj).closest('.dropdown').find('[data-toggle="dropdown"]').html(txt+'<span class="caret"></span>');
}







function getPdfDownload() {
	html2canvas(document.getElementById("layerbox"), {
		onrendered: function (canvas) {
			var imgData = canvas.toDataURL('image/png');
			var imgWidth = 210; // A4용지 기준 이미지 width길이
			var imgHeight = canvas.height * imgWidth / canvas.width; //화면내용 이미지화 했을때 이미지파일의 height
			var pageHeight = imgWidth * 1.414;  // A4용지 세로 길이
			var heightLeft = imgHeight;

			/**
			 * Creates new jsPDF document object instance.
			 * @param orientation One of "portrait" or "landscape" (or shortcuts "p" (Default), "l")
			 * @param unit		Measurement unit to be used when coordinates are specified.
			 *					One of "pt" (points), "mm" (Default), "cm", "in"
			 * @param format	  One of 'pageFormats' as shown below, default: a4
			 * @name jsPDF
			 */
			var doc = new jsPDF('p', 'mm', 'a4');
			var position = 0;

			//function(imageData, format, x, y, w, h[, alias[, compression[, rotation]]])
			doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight); //화면의 이미지 파일 추가
			heightLeft -= pageHeight;

			//화면이 길어 1장 이상일때
			while (heightLeft >= 20) {
				position = heightLeft - imgHeight;
				doc.addPage();
				doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
				heightLeft -= pageHeight;
			}

			doc.save('download.pdf');
		}
	});
}

function getPdfTotDownload() {
	html2canvas(document.getElementById("layerboxTot"), {
		onrendered: function (canvas) {
			var imgData = canvas.toDataURL('image/png');
			var imgWidth = 210; // A4용지 기준 이미지 width길이
			var imgHeight = canvas.height * imgWidth / canvas.width; //화면내용 이미지화 했을때 이미지파일의 height
			var pageHeight = imgWidth * 1.414;  // A4용지 세로 길이
			var heightLeft = imgHeight;

			/**
			 * Creates new jsPDF document object instance.
			 * @param orientation One of "portrait" or "landscape" (or shortcuts "p" (Default), "l")
			 * @param unit		Measurement unit to be used when coordinates are specified.
			 *					One of "pt" (points), "mm" (Default), "cm", "in"
			 * @param format	  One of 'pageFormats' as shown below, default: a4
			 * @name jsPDF
			 */
			var doc = new jsPDF('p', 'mm', 'a4');
			var position = 0;

			//function(imageData, format, x, y, w, h[, alias[, compression[, rotation]]])
			doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight); //화면의 이미지 파일 추가
			heightLeft -= pageHeight;

			//화면이 길어 1장 이상일때
			while (heightLeft >= 20) {
				position = heightLeft - imgHeight;
				doc.addPage();
				doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
				heightLeft -= pageHeight;
			}

			doc.save('download.pdf');
		}
	});
}

var summerVal = 0;
var summerOffVal = 0;
var summerMidVal = 0;
var summerMaxVal = 0;
var spring_fallVal = 0;
var springFallOffVal = 0;
var springFallMidVal = 0;
var springFallMaxVal = 0;
var winterVal = 0;
var winterOffVal = 0;
var winterMidVal = 0;
var winterMaxVal = 0;
var basicVal = 0;

function getPlanTypeVal(planType, planType2, planType3) {
	$.ajax({
		url: "/system/getPlanTypeVal.json",
		type: 'post',
		async: false, // 동기로 처리해줌
		data: {
			planType: planType,
			planType2: planType2,
			planType3: planType3,
		},
		success: function (result) {
			var thisDay = new Date();
			thisDay = new Date(thisDay.setMonth(thisDay.getMonth() - 1));
			thisMonth = parseInt(thisDay.format("MM"));
			var planType = result.result;
			if (planType != null) {
				planTypeName = planType.plan_name; //구분 전체
				planTypeName1 = planType.plan_type_name; //구분1
				planTypeName2 = planType.plan_type_name2; //구분2
				planTypeName3 = planType.plan_type_name3; //구분3
				summerVal = planType.summer_val;
				summerOffVal = (planType.summer_off_val == null) ? planType.summer_val : planType.summer_off_val;
				summerMidVal = (planType.summer_mid_val == null) ? planType.summer_val : planType.summer_mid_val;
				summerMaxVal = (planType.summer_max_val == null) ? planType.summer_val : planType.summer_max_val;
				springFallVal = planType.spring_fall_val;
				springFallOffVal = (planType.spring_fall_off_val == null) ? planType.spring_fall_val : planType.spring_fall_off_val;
				springFallMidVal = (planType.spring_fall_mid_val == null) ? planType.spring_fall_val : planType.spring_fall_mid_val;
				springFallMaxVal = (planType.spring_fall_max_val == null) ? planType.spring_fall_val : planType.spring_fall_max_val;
				winterVal = planType.winter_val;
				winterOffVal = (planType.winter_off_val == null) ? planType.spring_fall_val : planType.winter_off_val;
				winterMidVal = (planType.winter_mid_val == null) ? planType.spring_fall_val : planType.winter_mid_val;
				winterMaxVal = (planType.winter_max_val == null) ? planType.spring_fall_val : planType.winter_max_val;
				basicVal = planType.basic_val;
			}

		}
	});
}

var custNum = "";		//고객번호
var useElecAddr = "";		//전기사용 장소
var meterNum = "";		//계량기 번호
var meterSf = "";		//계량기 배수
var meterReadDay = "";		//검침일
var contractPower = "";		//계약전력
var chargePower = "";
var planType = "";
var planType2 = "";
var planType3 = "";
var planTypeName = "";
var planTypeName1 = ""; //구분1 
var planTypeName2 = ""; //구분2 
var planTypeName3 = ""; //구분3 
var reduceAmt = ""; // 감축용량
var smpRate = "";		//SMP 단가
var recRate = "";		//REC 단가
var recWeight = "";		//REC 가중치
var meterClaimDay = 0; // 청구일
var essProfitRatio = 0; // ESS수익배분 비율
var drProfitRatio = 0; // DR수익배분 비율
var pvProfitRatio = 0; // PV수익배분 비율
var recRateDate = "";
var smpRateDate = "";
var essBattery = "";
var essPcs = "";

//한전 계약 및 전력 관리 정보 조회
function getSiteSetDetail() {
	$.ajax({
		url: "/system/getSiteSetDetail.json",
		type: 'post',
		async: false, // 동기로 처리해줌
	//		data : formData,
		success: function (result) {
			var site = result.detail;
			custNum = (site.cust_num == null) ? "-" : site.cust_num;		//고객번호
			useElecAddr = (site.use_elec_addr == null) ? "-" : site.use_elec_addr; // 전기사용 장소
			meterNum = (site.meter_num == null) ? "-" : site.meter_num;		//계량기 번호
			meterSf = (site.meter_sf == null) ? "-" : site.meter_sf;		//계량기 배수
			meterReadDay = site.meter_read_day;		//검침일
			contractPower = site.contract_power;		//계약전력
			chargePower = site.charge_power;		//계약전력
			planType = site.plan_type;		//구분1
			planType2 = site.plan_type2;		//구분2
			planType3 = site.plan_type3;		//구분3
			reduceAmt = site.reduce_amt;
			smpRate = site.smp_rate;		//SMP 단가
			recRate = site.rec_rate;		//REC 단가
			recWeight = site.rec_weight;		//REC 가중치
			meterClaimDay = site.meter_claim_day; // 청구일
			essProfitRatio = site.ess_profit_ratio; // ESS수익배분 비율
			drProfitRatio = site.dr_profit_ratio; // DR수익배분 비율
			pvProfitRatio = site.pv_profit_ratio; // PV수익배분 비율
			recRateDate = site.rec_rate_date;
			smpRateDate = site.smp_rate_date;
			essBattery = site.ess_battery;
			essPcs = site.ess_pcs;
	
			getPlanTypeVal(planType, planType2, planType3);
	
		}
	});
}

