;(function($){
	$.fn.sectionDisplay = function(options){
		var opts = $.extend({}, $.fn.sectionDisplay.defaults, options);
		
		return this.each(function(){
			//OVJECT SEARCH
			var elem = $(this);
			var nav = opts.nav;
			
			/* DISPLAY RESET */
			var displayReset = function(){
				elem.find(".sec_obj").hide();
				nav.children("*").removeClass("active");
			}
			
			/* HANDLER */
			var handEvent = function(handIndex){
				displayReset(); //SLIDE RESET
				elem.find(".sec_obj").eq(handIndex).show(); //INDEX SLIDE ACTIVE
				nav.children("*").eq(handIndex).addClass("active"); //NAV ACTIVE
				console.log(elem.find(".sec_obj").eq(handIndex))
			}

			//SLIDE OVJECT MARKING
			$(this).children("*").each(function(){
				if(!$(this).hasClass(nav.attr("class"))){
					//클래스 추가 후 HIDE
					$(this).addClass("sec_obj");
					displayReset();
				}
			});
			
			//DEFUALT
			handEvent(opts.start);
			
			//EVENT LISTENER
			nav.children("*").bind("click", function(){
				handEvent($(this).index());
			});


			//EVENT LISTENER
			if(opts.act == "hover"){
				nav.children("*").hover(function(){
					handEvent($(this).index());
				});
			} else if(opts.act == "click"){
				nav.children("*").bind("click", function(){
					handEvent($(this).index());
				});
			}
			
			//이벤트 타이머
			if(opts.auto == true){
				var autoSlideListener = setInterval(function(){autoSlide();}, opts.autoTime);
				
				//마우스 오버시 슬라이드 멈추기
				elem.hover(function(){
					clearInterval(autoSlideListener);
				}, function(){
					autoSlideListener = setInterval(function(){autoSlide();}, opts.autoTime);
				});
				
				var getNowIndex = function(){
					return nav.find(".active");
				}
				var getPagerLength = function(){
					return elem.find(".sec_obj").length;
				}
				var autoSlide = function(){
					var length = getPagerLength();
					var list = getNowIndex();
					
					console.log(list.index() +"/"+ length)
					
					if (list.index() < (length - 1)){
						handEvent(list.index() + 1);
					} else {
						handEvent(0);
					}
				}
			}
			
		});
	}
	$.fn.sectionDisplay.defaults = {
		act : "hover",
		start:0,
		nav : null,
		auto:false,
		autoTime:3000
	}
})(jQuery);

/*

SAMPLE CODE

$(document).ready(function(){
	$("#wrap .slide").sectionDisplay({
		act : "click",
		start:0,
		nav : $('.nav'),
		auto: true,
		autoTime:3000
	});
});

<div id="wrap">
	<div class="nav">
		<a href="#">1</a>
		<a href="#">2</a>
		<a href="#">3</a>
	</div>
	<ul class="slide">
		<li><img src="" alt="" /></li>
		<li><img src="" alt="" /></li>
		<li><img src="" alt="" /></li>
	</ul>
</div>

*/