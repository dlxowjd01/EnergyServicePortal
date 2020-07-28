/* datepicker */
$(function() {
    $.datepicker.regional['ko'] = {
        closeText : '닫기',
        prevText : '이전달',
        nextText : '다음달',
        currentText : '오늘',
        monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNames : ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesShort : ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesMin : ['일', '월', '화', '수', '목', '금', '토'],
        weekHeader : 'Wk',
        firstDay : 0,
        isRTL : false,
        showMonthAfterYear : true,
        yearSuffix : '년'
    };
    $.datepicker.setDefaults($.datepicker.regional['ko']);


    $("#datepicker1, #datepicker2, #datepicker5, #datepicker10, #datepicker12, .datepicker").datepicker({
        showOn: "both",
        buttonImageOnly: true,
        dateFormat: 'yy-mm-dd',
        onClose: function(selectedDate) {
            if(typeof repeatEnd == 'function') {
                repeatEnd(selectedDate);
            }
        }
    });

    $("#datepicker3, #datepicker4, #datepicker11, .monthpicker").datepicker({
        showOn: "both",
        /*buttonImage: "../2016img/search_calendar.gif", */
        buttonImageOnly: true,
        dateFormat: 'yy-mm'

    });

    $('.fromDate').datepicker({
        showOn: 'both',
        buttonImageOnly: true,
        dateFormat: 'yy-mm-dd',
        onClose: function(selectedDate) {
            $(this).closest('.dateField').find('.toDate').datepicker('option', 'minDate', selectedDate);

            if (typeof afterDatePick == 'function') {
                afterDatePick($(this).attr('name'));
            }
        }
    });

    $('.toDate').datepicker({
        showOn: 'both',
        buttonImageOnly: true,
        dateFormat: 'yy-mm-dd',
        onClose: function(selectedDate) {
            $(this).closest('.dateField').find('.fromDate').datepicker('option', 'maxDate', selectedDate);

            if (typeof afterDatePick == 'function') {
                afterDatePick($(this).attr('name'));
            }
        }
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
//        $(".tbl_wrap").css("min-height",tbl_height);
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

/* [메인] 오늘/이번주/이번달 텝메뉴 */
$(function() {
    $('.term_menu>ul a').click(function(){
        var indexNo = $(".term_menu>ul").find("a").index(this);
        $('.term_menu>ul li').removeClass("on");
        $(this).parent().addClass("on");
    });
});

/* [메인] 리스트 더블클릭 */
$(function() {
    var touchtime = 0;
    $(document).on('click','.dbclickopen', function () {

        if(typeof(smoothZoom) == 'function') {
            let idx = $('.dbclickopen').index($(this)),
                sid = $(this).data('sid');
            let marker = makerObject[sid];
            if(!isEmpty(marker)) {
                map = marker.getMap();

                if($(this).next().find('.di_wrap').css('display') == 'block') {
                    map.setCenter({lat: 37.549012, lng: 126.988546});
                    smoothZoom(map, 6, map.getZoom(), false);
                } else {
                    map.setCenter(marker.position); // set map center to marker position
                    smoothZoom(map, 18, map.getZoom(), true);
                }
            }
        }

        if(touchtime == 0) {
            //set first click
            touchtime = new Date().getTime();
            //$('.dbclickopen').removeClass("click");
            $(this).toggleClass("click");
            $(this).next(".detail_info").find(".di_wrap").slideToggle();
        } else {
            //compare first click to this click and see if they occurred within double click threshold
            if(((new Date().getTime())-touchtime) < 800) {
                //double click occurred
                touchtime = 0;
                if(!isEmpty(href)) {
                    window.location = $(this).find("a").attr(href);
                }
            } else {
                //not a double click so set as a new first click
                touchtime = new Date().getTime();
                //$('.dbclickopen').removeClass("click");
                $(this).toggleClass("click");
                $(this).next(".detail_info").find(".di_wrap").slideToggle();
            }
        }


        return false;
    });
});

/* 알람 리스트 클릭시 사업소 상세정보 열기 */
function list_detail_open(list_number) {
    var target = list_number;
    //alert(list_number);
    $("."+target+"").find(".di_wrap").slideToggle();
}

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

/* input[file] multi-select || single select label */
$(function () {
	var clone = '';
	$(document).on('change', 'input[type=file]', function () {
		var t = $(this).val();
		var labelText = 'File : ' + t.substr(12, t.length);

		if (isEmpty(t)) {return false;}
		if ($(this).attr("multiple")) {
			let list = $(this).parent().find(".file_list ul");
			let item = $(this).get(0).files;
			let arr = [];
			if ($(this).parent().find(".no-data")) {
				$(this).parent().find(".no-data").addClass("hidden");
			}
			list.empty();
			$.each(item, function (index, element) {
				let listItem = ``;
				let dataId = genUuid();
				listItem = `
					<li class='upload_text' data-id="${dataId}">
						${element.name}
						<button type='button' class='btn_close icon_btn' onclick='deleteFile($(this))'></button>
					</li>
				`
				list.append(listItem);
				arr.push(element.name);
			});
			//$(this).attr("name", arr);
		} else {
            let targetId = $(this).attr('id');
            if (targetId.match('SPC_법인_인감_파일')) {
                let listItem = `<button type='button' class='btn_close file_del_btn' onclick='deleteFile($(this), "front")'></button>`;
                $(this).parent().find(".upload_text").next('.file_del_btn').remove();
                $(this).parent().find(".upload_text").html(labelText).after(listItem);
            } else {
                let listItem = `${labelText}<button type='button' class='btn_close icon_btn' onclick='deleteFile($(this))'></button>`;
                // $(this).prev('label').text(listItem);
                $(this).parent().find(".upload_text").html(listItem);
                // if ($(this).parent().find(".btn_close")) {
                // 	$(this).parent().find(".btn_close").removeClass('hidden')
                // }
            }
		}
	});
});

function deleteFile(self, type) {
    if (type === undefined) {
        let ul = self.parents(".file_list ul");
        if (ul.length == 0) {
            if (self.parent('.upload_text').prop('tagName') == 'LI') {
                self.parent(".upload_text").remove();
            } else {
                self.parent(".upload_text").parent().find('input[type="file"]').val('');
                self.parent(".upload_text").empty();
            }
        } else {
            self.parent(".upload_text").remove();
            if (ul.children().length <= 0) {
                let item = '';
                item = '<li class="no-file">선택된 파일이 없습니다.</li>'
                ul.append(item);
                ul.parents('.file_list').parent().find('input[type="file"]').val('');
            }
        }
    } else {
        let parent = self.parent();
        parent.find('span.upload_text').html('');
        parent.find('input[type="file"]').val('').removeData('file');
        self.remove();
    }
}

/* 장치 그룹 현황 슬라이드 */
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
    $("." + target + "").hide();
    if (target == "dgroup_add" || target == "dgdevice_edit" || target == "category_edit") {
    } else {
        $('#mask').hide();
    }
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




/* 상단 전체메뉴 */
$(function() {
    $("nav .all-menu > a").click(function(){
        $(this).toggleClass("on");
        $(".menu-group").slideToggle();
    });
    $('#page-wrapper').mouseup(function (e){
        var container = $(".menu-group");
        if( container.has(e.target).length === 0)
            container.slideUp();
    });
});

/* toggle */
$(function() {
    $("nav .all-menu .menu-group > ul > li > dl > dd ul label").click(function(){
        $(this).toggleClass("on");
    });
});

/* 체크여부 */
$(function() {
    $(".lo-type label").click(function(){
        if($(".lo label").hasClass("on") === true && $(".type label").hasClass("on") === true) {
            $(".apply-btn").removeAttr("disabled");
        }
    });
});

/* reset */
$(function() {
    $("nav .all-menu .menu-group .btn-group .reset-btn").click(function(){
        $("nav .all-menu .menu-group > ul > li > dl > dd ul label").removeClass("on");
        $(".apply-btn").attr("disabled","disabled");
    });
});


/* type_list slideToggle */
$(document).on('click', ".type_list .chart_top", function() {
    $(this).next(".type_list_detail").slideToggle();
    return false;
});


/* submenu show/hide */
$(function($){
    var nav = $(".sub_layer");

    nav.find("li").each(function() {
        if ($(this).find("div").length > 0) {
            $(this).click(function() {
                $(this).find("div").slideToggle(200);
                $(this).toggleClass("on");
            });
        }
    });
});


/* dropdown-menu multi check */
$(function () {
    var options = [];
    $( '.dropdown-menu-form a' ).on( 'click', function( event ) {
        var $target = $( event.currentTarget ),
            val = $target.attr( 'data-value' ),
            $inp = $target.find( 'input' ),
            idx;
        if ( ( idx = options.indexOf( val ) ) > -1 ) {
            options.splice( idx, 1 );
            setTimeout( function() { $inp.prop( 'checked', false ) }, 0);
        } else {
            options.push( val );
            setTimeout( function() { $inp.prop( 'checked', true ) }, 0);
        }
        $( event.target ).blur();
        
        return false;
    });
});

/* SELECT 버튼 */
$(function() {
    $(".select > a").click(function(){
        $(this).toggleClass("on");
        $(this).next().slideToggle();
    });
});

/* input file */
$(function() {
    var uploadFile = $('.fileBox .uploadBtn');
    uploadFile.on('change', function(){
        if(window.FileReader){
            var filename = $(this)[0].files[0].name;
        } else {
            var filename = $(this).val().split('/').pop().split('\\').pop();
        }

        $(this).siblings('.fileName').val(filename);
    });
});