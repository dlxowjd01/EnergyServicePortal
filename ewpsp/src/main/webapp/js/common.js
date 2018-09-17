/* datapicker */
$(function() {
    $( "#datepicker1, #datepicker2, #datepicker5" ).datepicker({
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
















/* 장치 그룹 현황 */
$(function() {
    $('.dsec .device').bxSlider({
        mode:'horizontal',
        pager:false,
        slideWidth: 130,
        slideMargin: 20,
        minSlides: 1,
        maxSlides: 8,
        moveSlides: 1,
        pause: 4000,
        auto:false,
        controls: true,
        infiniteLoop: false
    });
});

/* 레이어 팝업 열기 */
function popupOpen(target) {
    $("#mask").fadeTo("slow", 0.9);
    $("."+target+"").css("position", "absolute");
    //영역 가운에데 레이어를 뛰우기 위해 위치 계산 
    $("."+target+"").css("top",(($(window).height() - $("."+target+"").outerHeight()) / 2) + $(window).scrollTop());
    $("."+target+"").css("left",(($(window).width() - $("."+target+"").outerWidth()) / 2) + $(window).scrollLeft());
    $("."+target+"").draggable();
    $("."+target+"").show();
}

/* 레이어 팝업 닫기 */
function popupClose(target) {
    $("."+target+"").hide();
    if(target == "dgroup_add" || target == "dgdevice_edit" || target == "category_edit") {} else {$('#mask').hide();}
}



