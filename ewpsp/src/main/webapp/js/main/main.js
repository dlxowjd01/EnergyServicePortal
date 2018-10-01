// 모니터링 변수 : setInterval()를 변수에 저장하면 나중에 clearInterval()를 이용해 중지시킬 수 있다
var monitoring_cycle_10sec = null;
var monitoring_cycle_1min = null;
var monitoring_cycle_15min = null;
var formData = null;

$(function() {
	formData = getSiteMainSchCollection();

	realTime_monitoring_start();
});

// 사이트ID 변경 처리
function updateUserSite() {
	realTime_monitoring_restart();
}

// 자동 새로고침(실시간 모니터링)
function realTime_monitoring_start() {
	monitoring_cycle_10sec_start();
//	monitoring_cycle_1min_start();
//	monitoring_cycle_15min_start();
}

function realTime_monitoring_restart() {
	monitoring_cycle_10sec_end();
//	monitoring_cycle_1min_end();
//	monitoring_cycle_15min_end();
	realTime_monitoring_start();
}

function monitoring_cycle_10sec_start() {
	if(monitoring_cycle_10sec == null) { // 10초 간격
		fn_cycle_10sec();	// 바로 한번 시작한다.
		monitoring_cycle_10sec = setInterval(function(){
			fn_cycle_10sec();
		}, (1000*10));
	} else {
		alert("이미 모니터링이 실행중입니다.");
	}
}

function monitoring_cycle_10sec_end() {
	clearInterval(monitoring_cycle_10sec);
	monitoring_cycle_10sec = null;
}

function fn_cycle_10sec() {
	getAlarmList(formData); // 알람 조회
}

function getSiteMainSchCollection() {
	var today = new Date();
	firstDay = today.format("yyyyMMdd")+"000000";
	endDay = today.format("yyyyMMdd")+"235959";

	$("#selTermFrom").val(firstDay);
	$("#selTermTo").val(endDay);
	if (userSiteId != '') {
		$('#siteId').val(userSiteId);
	}

	var formData = $("#schForm").serializeObject();
//	{
//			selTerm : "day",
//			selPeriodVal : "15min",
//			selTermFrom : firstDay,
//			selTermTo : endDay, 
//			siteId : "c64b328b"
//	};
	
	return formData;
}

function callback_getAlarmList(result) {
	var dvTpAlarmDetail = result.detail;
	var alarmList = result.alarmList;
	
	$("#todayTotalAlarmCnt").val(dvTpAlarmDetail.total_cnt);
	$("#todayAlarmCnt").val(dvTpAlarmDetail.alert_cnt);
	$("#todayWarningCnt").val(dvTpAlarmDetail.warning_cnt);
	if(dvTpAlarmDetail.notCfm_cnt == 0) {
		$(".no").find('span').hide();
	} else {
		$(".no").find('span').show();
		$(".no").empty().append( '<span>'+dvTpAlarmDetail.notCfm_cnt+'</span>');
	}
	
	$div = $(".alarm_notice");
	$div.find("ul").empty();
	if(alarmList == null || alarmList.length < 1) {
		$div.find("ul").append( $('<li />').append( $('<a href="#;" />').append("조회된 데이터가 없습니다.") ) );
	} else {
		for(var i=0; i<alarmList.length; i++) {
			var tm = new Date( convertDateUTC(alarmList[i].std_date) );
			
			$div.find("ul").append( 
					$('<li />').append( $('<a href="#;" />').append("조회된 데이터가 없습니다.") 
					).append( $('<span />').append( tm.format("yyyy-MM-dd HH:mm:ss") ) ) 
			);
			
		}
		
	}
	
}

function changeMapGroup(aElmt) {
	var text = changeLiClass(aElmt);
	$('#selMapGroup').text(text);

	if (text == '지역별') {
		$('#mapUsage').show();
		$('#groupUsage').hide();
	} else if (text == '그룹별') {
		$('#mapUsage').hide();
		$('#groupUsage').show();
	}
}

function changeAllArea(aElmt) {
	$('#selAllArea').text(changeLiClass(aElmt));
}

// 선택된 li에 class='on'을 붙이고 텍스트를 얻어온다.
function changeLiClass(aElmt) {
	var aObj = $(aElmt);
	var ulObj = aObj.parent().parent();
	var text = aObj.text();

	ulObj.children('li').each(function(idx, liElmt) {
		var liObj = $(liElmt);

		if (liObj.text() == text) {
			liObj.addClass('on');
		} else if (liObj.hasClass('on')) {
			liObj.removeClass('on');
		}
	});

	return text;
}
