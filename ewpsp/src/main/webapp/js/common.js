/* datapicker */
$(function() {
    $( "#datepicker1, #datepicker2, #datepicker5, #datepicker10, #datepicker11, #datepicker12" ).datepicker({
        showOn: "both", 
        /*buttonImage: "../2016img/search_calendar.gif", */
        buttonImageOnly: true,
        dateFormat: 'yy-mm-dd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNames: ['일','월','화','수','목','금','토'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
        showMonthAfterYear: true,
        yearSuffix: '년'
    });
    $( "#datepicker3, #datepicker4" ).datepicker({
    	showOn: "both", 
    	/*buttonImage: "../2016img/search_calendar.gif", */
    	buttonImageOnly: true,
    	dateFormat: 'yy-mm',
    	prevText: '이전 달',
    	nextText: '다음 달',
    	monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    	monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    	dayNames: ['일','월','화','수','목','금','토'],
    	dayNamesShort: ['일','월','화','수','목','금','토'],
    	dayNamesMin: ['일','월','화','수','목','금','토'],
    	showMonthAfterYear: true,
    	yearSuffix: '년'
    });
});

/* 
    ## 모바일 레이아웃 스크립트 ##
*/
$(function() {
    /* 카테고리 열기 */
    $('.category').click(function(){
        $('#mask').fadeTo("slow", 0.9);
        $('body').addClass("sidenav-no-scroll");
        $('#gnb').show(200);
    });
    /* 카테고리 닫기 */
    $('.category_close').click(function(){
        $('#mask').hide();
        $('body').removeClass("sidenav-no-scroll");
        $('#gnb').hide();
    });
    /* 서브메뉴 열기/닫기 */
    $('.g_menu li a').click(function(){
        $(this).siblings("ul").slideToggle(500);
    });
});

/* 표 접기/펼치기 */
$(function() {
    $('.fold_btn').click(function(){
        var tbl_height = $(".fold_div").height();
        $(".tbl_wrap").css("min-height",tbl_height);
        $('.fold_div').slideToggle();
        $(this).toggleClass("on");
        $(this).text($(this).text() == '표접기' ? '펼치기' : '표접기');
    });
});

/* 텝메뉴 */
$(function() {
    $(".tblDisplay").sectionDisplay({
        act : "click",
        start:0,
        nav : $('.tab_menu, .gtab_menu'),
        auto: false,
        autoTime:3000
    });
});

/* [군관리 메인] 오늘/이번주/이번달 텝메뉴 */
$(function() {
    $('.term_menu>ul a').click(function(){     
        var indexNo = $(".term_menu>ul").find("a").index(this); 
       $('.term_menu>ul li').removeClass("on");
       $(this).parent().addClass("on");            
   });   
});

/* [군관리 메인] 리스트 더블클릭 */
$(function() {
    var touchtime = 0;
    $('.dbclickopen').click(function() {
        if(touchtime == 0) {
            //set first click
            touchtime = new Date().getTime();
            $('.dbclickopen').removeClass("click");
            $(this).addClass("click");
        } else {
            //compare first click to this click and see if they occurred within double click threshold
            if(((new Date().getTime())-touchtime) < 800) {
                //double click occurred
                touchtime = 0;
                window.location = $(this).find("a").attr(href);
            } else {
                //not a double click so set as a new first click
                touchtime = new Date().getTime();
                $('.dbclickopen').removeClass("click");
                $(this).addClass("click");
            }
        }
        return false;
    });
}); 

/* FAQ slideToggle */
$(function(){
    $(".faq_list .question").click(function() {
        $(this).next(".answer").slideToggle();
        $(this).toggleClass("on");
        return false;
    });
});

/* 선택이동 ToggleClass */
$(function(){
    $(".multi_select a").click(function() {
        $(this).toggleClass("on");
        return false;
    });
});

/* 장치 그룹 현황 ToggleClass */
$(function(){
    $(".device li").click(function() {
        $(this).toggleClass("on");
        var del_num = $(this).parent('.device').children('.on').length;
        //alert(del_num);
        if(del_num > 0) {
            $(this).parent().parent().parent().siblings('.device_del').show();
        } else {
            $(this).parent().parent().parent().siblings('.device_del').hide();
        }
    });
});

/* 테이블 리스트 선택 효과 */
$(function(){
    $(".s_table tbody tr, .chart_table tbody tr, .tbl_box tbody tr, .default_tbl tbody tr").click(function() {
        $(".s_table tbody tr").removeClass("click");
        $(".chart_table tbody tr").removeClass("click");
        $(".tbl_box tbody tr").removeClass("click");
        $(".default_tbl tbody tr").removeClass("click");
        $(this).addClass("click");
        return false;
    });
});

/* input[file] label */
$(function() {
  $('input[type=file]').change(function(){
    var t = $(this).val();
    var labelText = 'File : ' + t.substr(12, t.length);
    $(this).prev('label').text(labelText);
  })
});

/* 장치 그룹 현황 슬라이드 */
$(function() {
//    $('.dsec .device').bxSlider({
//        mode:'horizontal',
//        pager:false,
//        slideWidth: 130,
//        slideMargin: 20,
//        minSlides: 1,
//        maxSlides: 8,
//        moveSlides: 1,
//        pause: 4000,
//        auto:false,
//        controls: true,
//        infiniteLoop: false
//    });
});



// Simple JQuery Draggable Plugin
// https://plus.google.com/108949996304093815163/about
// Usage: $(selector).drags();
// Options:
// handle            => your dragging handle.
//                      If not defined, then the whole body of the
//                      selected element will be draggable
// cursor            => define your draggable element cursor type
// draggableClass    => define the draggable class
// activeHandleClass => define the active handle class
// cancel            => elements to ignore starting the drag operation
//
// Update: 26 February 2013
// 1. Move the `z-index` manipulation from the plugin to CSS declaration
// 2. Fix the laggy effect, because at the first time I made this plugin,
//    I just use the `draggable` class that's added to the element
//    when the element is clicked to select the current draggable element. (Sorry about my bad English!)
// 3. Move the `draggable` and `active-handle` class as a part of the plugin option
// Next update?? NEVER!!! Should create a similar plugin that is not called `simple`!
//
// v 0.2 - @pjfsilva - Added cancel elements option. This fixes the problem where <select> elements inside the draggable
// element stop working and also improves UX as no drag event is triggered when the user is on top of a cancel element.
// This solution is based on jquery-ui cancel solution. 
//
(function($) {
    $.fn.drags = function(opt) {

        opt = $.extend({
            handle: "",
            cursor: "",
            draggableClass: "draggable",
            activeHandleClass: "active-handle",
            cancel: 'a,input,textarea,button,select,option'
        }, opt);

        var $selected = null;
        var $elements = (opt.handle === "") ? this : this.find(opt.handle);

        $elements.css('cursor', opt.cursor).on("mousedown", function(e) {
            var elIsCancel = e.target.nodeName ? $(e.target).closest(opt.cancel).length : false;

            if(opt.handle === "") {
                $selected = $(this);
                $selected.addClass(opt.draggableClass);
            } else {
                $selected = $(this).parent();
                $selected.addClass(opt.draggableClass).find(opt.handle).addClass(opt.activeHandleClass);
            }

            if (elIsCancel){
                // cancel drag if user started on a cancel element
                return true;
            }

            var drg_h = $selected.outerHeight(),
                drg_w = $selected.outerWidth(),
                pos_y = $selected.offset().top + drg_h - e.pageY,
                pos_x = $selected.offset().left + drg_w - e.pageX;
            $(document).on("mousemove", function(e) {
                $selected.offset({
                    top: e.pageY + pos_y - drg_h,
                    left: e.pageX + pos_x - drg_w
                });
            }).on("mouseup", function() {
                $(this).off("mousemove"); // Unbind events from document
                if ($selected !== null) {
                    $selected.removeClass(opt.draggableClass);
                    $selected = null;
                }
            });
            e.preventDefault(); // disable selection
        }).on("mouseup", function() {
            if(opt.handle === "") {
                $selected.removeClass(opt.draggableClass);
            } else {
                $selected.removeClass(opt.draggableClass)
                    .find(opt.handle).removeClass(opt.activeHandleClass);
            }
            $selected = null;
        });

        return this;

    };
})(jQuery);

/* 레이어 팝업 열기 */
function popupOpen(target) {
    $("#mask").fadeTo("slow", 0.9);
    $("."+target+"").css("position", "absolute");
    //영역 가운에데 레이어를 뛰우기 위해 위치 계산 
    $("."+target+"").css("top",(($(window).height() - $("."+target+"").outerHeight()) / 2) + $(window).scrollTop());
    $("."+target+"").css("left",(($(window).width() - $("."+target+"").outerWidth()) / 2) + $(window).scrollLeft());
    $("."+target+"").drags();
    $("."+target+"").show();
}

/* 레이어 팝업 닫기 */
function popupClose(target) {
    $("."+target+"").hide();
    if(target == "dgroup_add" || target == "dgdevice_edit" || target == "category_edit") {} else {$('#mask').hide();}
}



$(document).ready(function(e){
    // input dorpdown
    $( document ).on( 'click', '.bs-dropdown-to-select-group .dropdown-menu li', function( event ) {
        var $target = $( event.currentTarget );
        $target.closest('.bs-dropdown-to-select-group')
            .find('[data-bind="bs-drp-sel-value"]').val($target.attr('data-value'))
            .end()
            .children('.dropdown-toggle').dropdown('toggle');
        $target.closest('.bs-dropdown-to-select-group')
            .find('[data-bind="bs-drp-sel-label"]').text($target.context.textContent);
        return false;
    });
});


/**
*   Body 내용 print 출력
*/
//function commonPrint(){
	
//$("#printArea").printThis();
//	$("#printArea").printArea({
//        mode       : "iframe",
//        standard   : "html5",
//        popClose   : false,
//        //extraCss   : '/css/custom.css,/css/bootstrap.css', 
//        extraHead  : '',
//        retainAttr : ["id","class","style"],
//        printDelay : 500, // tempo de atraso na impressao
//    });
	
//	 var options = {
//			 mode : "iFrame",
//			 standard   : "html5",
//			 popClose : true,
//			 extraCss : '/css/custom.css,/css/bootstrap.css,/css/jquery-ui.css',
//			 retainAttr : ["id","class","style"],
//			 extraHead : "", 
//			 };
//	 
//
//	 $("#printArea").printArea();
//}


function getPdfDownload(){
	html2canvas(document.getElementById("layerbox"), {
		onrendered: function(canvas) {         
			var imgData = canvas.toDataURL('image/png');
			var imgWidth = 210; // A4용지 기준 이미지 width길이
			var imgHeight = canvas.height * imgWidth / canvas.width; //화면내용 이미지화 했을때 이미지파일의 height
			var pageHeight = imgWidth * 1.414;  // A4용지 세로 길이
			var heightLeft = imgHeight;

			/**
			 * Creates new jsPDF document object instance.
			 * @param orientation One of "portrait" or "landscape" (or shortcuts "p" (Default), "l")
			 * @param unit        Measurement unit to be used when coordinates are specified.
			 *                    One of "pt" (points), "mm" (Default), "cm", "in"
			 * @param format      One of 'pageFormats' as shown below, default: a4
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

function getPdfTotDownload(){
	html2canvas(document.getElementById("layerboxTot"), {
		onrendered: function(canvas) {         
			var imgData = canvas.toDataURL('image/png');
			var imgWidth = 210; // A4용지 기준 이미지 width길이
			var imgHeight = canvas.height * imgWidth / canvas.width; //화면내용 이미지화 했을때 이미지파일의 height
			var pageHeight = imgWidth * 1.414;  // A4용지 세로 길이
			var heightLeft = imgHeight;

			/**
			 * Creates new jsPDF document object instance.
			 * @param orientation One of "portrait" or "landscape" (or shortcuts "p" (Default), "l")
			 * @param unit        Measurement unit to be used when coordinates are specified.
			 *                    One of "pt" (points), "mm" (Default), "cm", "in"
			 * @param format      One of 'pageFormats' as shown below, default: a4
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

var winterVal = 0;
var summerVal = 0;
var springFallVal = 0;
var basicVal = 0;
var custNum = "";		//고객번호
var meterNum = "";		//계량기 번호
var meterSf = "";		//계량기 배수
var profitRatio = "";		//수익배분 비율
var meterReadDay = "";		//검침일
var contractPower = "";		//계약전력
var planType = "";
var planType2 = "";
var planType3 = "";
var planTypeName = "";
var planTypeName1 = ""; //구분1 
var planTypeName2 = ""; //구분2 
var planTypeName3 = ""; //구분3 
var smpRate = "";		//SMP 단가
var recRate = "";		//REC 단가
var recWeight = "";		//REC 가중치

function callback_getPlanTypeVal(result){
	var thisDay = new Date();
	thisDay = new Date(thisDay.setMonth(thisDay.getMonth()-1));
	thisMonth = parseInt(thisDay.format("MM"));
	var planType = result.result;
	planTypeName = planType.plan_name; //구분 전체
	basicVal = planType.basic_val;
	plan_type_name1 = planType.plan_type_name; //구분1 
	plan_type_name2 = planType.plan_type_name //구분2 
	plan_type_name3 = planType.plan_type_name //구분3 
	summerVal = planType.summer_val;
	winterVal = planType.winter_val;
	springFallVal = planType.spring_fall_val;
}


function callback_getSiteSetDetail(result){
	
	
	var site = result.detail;
	custNum = site.cust_num;		//고객번호
	meterNum = site.meter_num;		//계량기 번호
	meterSf = site.meter_sf;		//계량기 배수
	profitRatio = 20;//site.profit_ratio;		//수익배분 비율
	meterReadDay = site.meter_read_day;		//검침일
	contractPower = site.contract_power;		//계약전력
	planType = site.plan_type;		//구분1
	planType2 = site.plan_type2;		//구분2
	planType3 = site.plan_type3;		//구분3
	smpRate = 101.59;//읾시 상수처리site.smp_rate;		//SMP 단가
	recRate = 99.92;//임시 상수처리site.rec_rate;		//REC 단가
	recWeight = site.rec_weight;		//REC 가중치
	
	getPlanTypeVal(planType,planType2,planType3);

}


function selectBoxTextApply(obj) {
	var txt = $(obj).text();
	$(obj).parent().parent().parent().find('button').empty().append(txt).append( $('<span class="caret" />') );
}

