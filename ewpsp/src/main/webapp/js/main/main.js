var formData = null;

function fn_cycle() {
	formData = getSiteMainSchCollection();

//	getAlarmList(formData); // 알람 조회
	getGMainSiteRankingList(1); // 사이트 사용량 순위 목록 조회
	getGMainSiteTotalDetail(formData); // 사이트 사용량 총합계 조회
	getGMainSiteList(1); // 사이트 목록 조회
}

function getSiteMainSchCollection() {
	// 기간 필터
	var today = new Date();
	var selTerm = $('#selTerm').val();
	endDay = today.format("yyyyMMdd") + "235959";
	if (selTerm == 'day') {
		// Nothing
	} else if (selTerm == 'week') {
		today.setDate(today.getDate() - today.getDay());
	} else if (selTerm == 'month') {
		today.setDate(1);
	}
	firstDay = today.format("yyyyMMdd") + "000000";
	$("#selTermFrom").val(firstDay);
	$("#selTermTo").val(endDay);

	// 지역 필터
	var areaType = (area_idx + 1).toString();
	if (areaType.length == 1) {
		areaType = '0' + areaType;
	}
	$('#areaType').val(areaType);

	if ($('#allArea').val() == '') {
		$('#areaType2').val(areaType);
	} else {
		// 지역필터가 선택되면 필터값으로 가져온다. (확정된게 아님)
		$('#areaType2').val($('#allArea').val());
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

function callback_getGMainSiteRankingList(result) {
	var siteList = result.list;

	var $tbody = $('#siteRankingTbody');
	$tbody.empty();

	if (siteList == null || siteList.length < 1) {
		$('#GMainSiteRankingPaging').empty();
	} else {
		for (var i = 0; i < 5; i++) {
			if (i < siteList.length) {
				if (oldRankType == 0) {
					$tbody.append(
						$('<tr />')
							.append($('<th />').append(siteList[i].site_name))
							.append($('<td />').append(siteList[i].usage))
							.append($('<td />').append(siteList[i].usage_plan))
					);
				} else if (oldRankType == 1) {
					$tbody.append(
						$('<tr />')
							.append($('<th />').append(siteList[i].site_name))
							.append($('<td />').append(siteList[i].charge))
							.append($('<td />').append(siteList[i].charge_plan))
						);
				} else if (oldRankType == 2) {
					$tbody.append(
						$('<tr />')
							.append($('<th />').append(siteList[i].site_name))
							.append($('<td />').append(siteList[i].gen))
							.append($('<td />').append(0))
						);
				} else if (oldRankType == 3) {
					$tbody.append(
						$('<tr />')
							.append($('<th />').append(siteList[i].site_name))
							.append($('<td />').append(siteList[i].reward))
							.append($('<td />').append(0))
						);
				}
			} else {
				$tbody.append(
						$('<tr />')
							.append($('<th />').append('-'))
							.append($('<td />').append(0))
							.append($('<td />').append(0))
					);
			}
		}

		var pagingMap = result.pagingMap;
		makePageNums2(pagingMap, "GMainSiteRanking");
	}

	if (myChart != null) {
		myChart.update({data:{table: 'gdatatable1'}});
	}
}

function callback_getGMainSiteTotalDetail(result) {
	var usage = result.detail;
//	console.log(usage);
	if (usage != null) {
		if (usage.usage > 1000) {
			$('.detailUsage').text(numberComma(Math.floor(usage.usage / 1000)));
			$('.detailUsageUnit').text('MWh');
		} else {
			$('.detailUsage').text(numberComma(usage.usage));
			$('.detailUsageUnit').text('kWh');
		}
		if (usage.gen > 1000) {
			$('.detailGen').text(numberComma(Math.floor(usage.gen / 1000)));
			$('.detailGenUnit').text('MWh');
		} else {
			$('.detailGen').text(numberComma(usage.gen));
			$('.detailGenUnit').text('kWh');
		}
		if (usage.charge > 1000) {
			$('.detailCharge').text(numberComma(Math.floor(usage.charge / 1000)));
			$('.detailChargeUnit').text('MWh');
		} else {
			$('.detailCharge').text(numberComma(usage.charge));
			$('.detailChargeUnit').text('kWh');
		}

		$('.detailReward').text(numberComma(usage.reward));
	} else {
		$('.detailUsage').text('0');
		$('.detailGen').text('0');
		$('.detailCharge').text('0');
		$('.detailReward').text('0');

		$('.detailUsageUnit').text('MWh');
		$('.detailGenUnit').text('MWh');
		$('.detailChargeUnit').text('MWh');
	}
}

function callback_getGMainSiteList(result) {
	var siteList = result.list;

	var $tbody = $('#siteTbody');
	$tbody.empty();

	if (siteList == null || siteList.length < 1) {
		$tbody.append('<tr><td colspan="7">조회된 데이터가 없습니다.</td><tr>');
		$('#GMainSitePaging').empty();
	} else {
		for (var i = 0; i < siteList.length; i++) {
			var eq1Cls = siteList[i].ioe > 0 ? ' on' : '';
			var eq2Cls = siteList[i].pcs > 0 ? ' on' : '';
			var eq3Cls = siteList[i].bms > 0 ? ' on' : '';
			var eq4Cls = siteList[i].pv > 0 ? ' on' : '';
			$tbody.append(
				$('<tr class="dbclickopen" />')
					.append($('<td />').append(siteList[i].rnum)) // no
					.append($('<td />')
						.append($('<div class="cname" />')
							.append('<a href="/siteMain?siteId=' + siteList[i].site_id + '">' + siteList[i].site_name + '</a>')
						)
					)
					.append($('<td />')
						.append($('<div class="eq_icon" />')
							.append('<span class="eq1' + eq1Cls + '">장치1</span>')
							.append('<span class="eq2' + eq2Cls + '">장치2</span>')
							.append('<span class="eq3' + eq3Cls + '">장치3</span>')
							.append('<span class="eq4' + eq4Cls + '">장치4</span>')
						)
					)
					.append($('<td />').append(numberComma(siteList[i].usage)))
					.append($('<td />').append(numberComma(siteList[i].charge)))
					.append($('<td />').append(numberComma(siteList[i].gen)))
					.append($('<td />').append(numberComma(siteList[i].reward)))
			);
		}

		var pagingMap = result.pagingMap;
		makePageNums2(pagingMap, "GMainSite");
	}
}

var oldRankType = 0;
function changeRanking(tabIdx) {
	// html 이동
	$('.tblDisplay > div:eq(' + oldRankType + ')').empty();
	$('.tblDisplay > div:eq(' + (tabIdx - 1) + ')').empty().append(chartDiv);
	// 차트 초기화
	initChart();

	oldRankType = tabIdx - 1;

	$('#rankType').val(tabIdx + 2);
	fn_cycle();
}

function changeTerm(term) {
	$('#selTerm').val(term);
	fn_cycle();
}

function changeMapGroup(aElmt) {
	var text = changeLiClass(aElmt);
	$('#selMapGroup').text(text);

	if (text == '지역별') {
		$('#mapUsage').show();
		$('#groupUsage').hide();
		$('#mapGroup').val('map');
	} else if (text == '그룹별') {
		$('#mapUsage').hide();
		$('#groupUsage').show();
		$('#mapGroup').val('group');
	}
	fn_cycle();
}

function changeAllArea(aElmt, areaType) {
	var text = changeLiClass(aElmt);
	$('#selAllArea').text(text);
	$('#allArea').val(areaType);
	fn_cycle();
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
