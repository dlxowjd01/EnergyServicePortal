var formData = null;
var recycleYn = true;
function fn_cycle() {
	if(recycleYn){
		
		$('.loading').show();
		
	}
	formData = getSiteMainSchCollection();

	setTimeout(function() {
		getGMainAlarmList(formData); // 알람 조회
		getGMainSiteRankingTotalDetail(); // 사이트 사용량 순위 누적/예상 총합
		getGMainSiteRankingList(1); // 사이트 사용량 순위 목록 조회
		getGMainSiteTotalDetail(formData); // 사이트 사용량 총합계 조회
		getGMainSiteList(1); // 사이트 목록 조회

		// 콤보박스 변경 (지역별 상태일 경우만 상세정보 타이틀(지역명)을 가져온다)
		if ($('#mapGroup').val() == 'map') {
			$('#selAllArea').text($('.local_name:eq(1)').text());
		}
	}, 1000);
	
	if(recycleYn){

		setTimeout(function() {
			$('.loading').hide();
		}, 1000);
		
	}
	recycleYn = false;
}

function getSiteMainSchCollection() {
//	$("#timeOffset").val( (new Date()).getTimezoneOffset() );
	$("#timeOffset").val( timeOffset );
	
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
	
	var startTime = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0);
	var endTime = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 23, 59, 59);
//	var queryStart = new Date(startTime.setMinutes(startTime.getMinutes() + (new Date()).getTimezoneOffset()));
//	var queryEnd = new Date(endTime.setMinutes(endTime.getMinutes() + (new Date()).getTimezoneOffset()));
	var queryStart = new Date(startTime.getTime());
	var queryEnd = new Date(endTime.getTime());
	queryStart = (queryStart == "") ? "" : queryStart.format("yyyyMMddHHmmss");
	queryEnd = (queryEnd == "") ? "" : queryEnd.format("yyyyMMddHHmmss");
	
	$("#selTermFrom").val(queryStart);
	$("#selTermTo").val(queryEnd);

	// 지역 필터
	var areaType = (area_idx + 1).toString();
	if (areaType.length == 1) {
		areaType = '0' + areaType;
	}
	$('#areaType').val(areaType);

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

function callback_getGMainAlarmList(result) {
	var dvTpAlarmDetail = result.detail;
	var alarmList = result.alarmList;

	$("#todayTotalAlarmCnt").html(dvTpAlarmDetail.total_cnt);
	$("#todayAlarmCnt").html(dvTpAlarmDetail.alert_cnt);
	$("#todayWarningCnt").html(dvTpAlarmDetail.warning_cnt);
	if(dvTpAlarmDetail.notCfm_cnt == 0) {
		$(".no").find('span').hide();
	} else {
		$(".no").find('span').show();
		$(".no").empty().append( '<span>'+dvTpAlarmDetail.notCfm_cnt+'</span>');
	}

	var str = "";
	if(alarmList == null || alarmList.length < 1) {
		str += '<li>';
		str += '	<a href="#;">조회 결과가 없습니다.</a>';
		str += '</li>';
	} else {
		for(var i=0; i<alarmList.length; i++) {
			var tm = new Date( convertDateUTC(alarmList[i].std_date) );
			str += '<li>';
			str += '	<a href="#;">'+alarmList[i].alarm_msg+'</a>';
			str += '	<span>'+tm.format("yyyy-MM-dd HH:mm:ss")+'</span>';
			str += '</li>';
		}
		$(".alarm_notice").find("ul").html(str)
	}
}

function callback_getGMainSiteRankingTotalDetail(result) {
	var total = result.detail;
	var now = new Date();

	$('#rankTime').text(now.format('a/p hh:mm') + ' 기준');
//	console.log(total);

	if (total != null) {
		$('#rankTotal').html('<span class="bul1" />');
		if (oldRankType == 0) {
			var map = convertUnitFormat(total.usage, "mWh");
			var past = toFixedNum(map.get("formatNum"), 2);
			$('#rankTotal > span').text('누적 : ' + past + " " + map.get("unit"));
			
			$('#rankPlan').html('<span class="bul2" />');
			var map2 = convertUnitFormat(total.usage_plan, "mWh");
			var feture = toFixedNum(map2.get("formatNum"), 2);
			$('#rankPlan > span').text('예상 : ' + feture + map2.get("unit"));
		} else if (oldRankType == 1) {
			var map = convertUnitFormat(total.charge, "kWh");
			var past = toFixedNum(map.get("formatNum"), 2);
			$('#rankTotal > span').text('누적 : ' + past + " " + map.get("unit"));
			
			$('#rankPlan').html('<span class="bul2" />');
			var map2 = convertUnitFormat(total.charge_plan, "kWh");
			var feture = toFixedNum(map2.get("formatNum"), 2);
			$('#rankPlan > span').text('예상 : ' + feture + " " + map2.get("unit"));
		} else if (oldRankType == 2) {
			var map = convertUnitFormat(total.gen, "kWh");
			var past = toFixedNum(map.get("formatNum"), 2);
			$('#rankTotal > span').text('누적 : ' + past + " " + map.get("unit"));
			$('#rankPlan').text('');
		} else if (oldRankType == 3) {
			var reward = (total.reward == null) ? 0 : total.reward;
			$('#rankTotal > span').text('수익 : ' + numberComma(reward) + " " + "won");
			$('#rankPlan').text('');
		}
	} else {
		$('#rankTotal').html('<span class="bul1">0kWh</span>');
		$('#rankPlan').html('<span class="bul2">0kWh</span>');
	}
}

function callback_getGMainSiteRankingList(result) {
	var siteList = result.list;

	var $tbody = $('#siteRankingTbody');
	$tbody.empty();

	if (siteList == null || siteList.length < 1) {
		$('#GMainSiteRankingPaging').empty();
	} else {
		for (var i = 0; i < siteList.length; i++) {
			if (i < siteList.length) {
				if (oldRankType == 0) {
					var map = convertUnitFormat(siteList[i].usage, "mWh", 8);
					var map2 = convertUnitFormat(siteList[i].usage_plan, "mWh", 8);
					$tbody.append(
						$('<tr />')
							.append($('<th />').append(siteList[i].site_name))
							.append($('<td />').append(toFixedNum(map.get("formatNum"), 2)))
							.append($('<td />').append(toFixedNum(map2.get("formatNum"), 2)))
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
	var total = result.detail;

	if ($('#mapGroup').val() == 'group') {
		var imgSrc = '/img/group_dimg.png';
		if ($('#grpIdx').val() != '') {
			if (total.site_grp_img_path != null && total.site_grp_img_sname != null) {
				imgSrc = total.site_grp_img_path + total.site_grp_img_sname;
			}
			$('#grpImg').attr('src', imgSrc);
			$('.group_name').text(total.site_grp_name);
		} else {
			$('#grpImg').attr('src', imgSrc);
			$('.group_name').text('전체그룹');
		}
	}

	if (total != null && total.usage != null) {
		var map = convertUnitFormat(total.usage, "mWh");
		var usage = toFixedNum(map.get("formatNum"), 2);
		$('.detailUsage').text(numberComma(usage));
		$('.detailUsageUnit').text(map.get("unit"));
		
		var map2 = convertUnitFormat(total.gen, "kWh");
		var gen = toFixedNum(map2.get("formatNum"), 2);
		$('.detailGen').text(numberComma(gen));
		$('.detailGenUnit').text(map2.get("unit"));
		
		var map3 = convertUnitFormat(total.charge, "kWh");
		var charge = toFixedNum(map3.get("formatNum"), 2);
		$('.detailCharge').text(numberComma(charge));
		$('.detailChargeUnit').text(map3.get("unit"));

		var reward = (total.reward == null) ? 0 : total.reward;
		$('.detailReward').text(numberComma(reward));
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
		$tbody.append('<tr><td colspan="7">조회 결과가 없습니다.</td><tr>');
		$('#GMainSitePaging').empty();
	} else {
		var imgSrc = '';
		var grpName = '';

		for (var i = 0; i < siteList.length; i++) {
			var eq1Cls = siteList[i].ioe > 0 ? ' on' : '';
			var eq2Cls = siteList[i].pcs > 0 ? ' on' : '';
			var eq3Cls = siteList[i].bms > 0 ? ' on' : '';
			var eq4Cls = siteList[i].pv > 0 ? ' on' : '';
			
			var map = convertUnitFormat(siteList[i].usage, "mWh", 8);
			var usage = toFixedNum(map.get("formatNum"), 2);
			var reward = (siteList[i].reward == null) ? 0 : siteList[i].reward;

			$tbody.append(
				$('<tr class="dbclickopen" onclick="activateSite(this, \'' + siteList[i].site_id + '\', \'' + siteList[i].site_grp_idx + '\')" ondblclick="goSiteMain(\'' + siteList[i].site_id + '\')" />')
					.append($('<td />').append(siteList[i].rnum)) // no
					.append($('<td />')
						.append($('<div class="cname" />')
							.append('<a href="#none">' + siteList[i].site_name + '</a>')
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
					.append($('<td />').append(numberComma(usage)))
					.append($('<td />').append(numberComma(siteList[i].charge)))
					.append($('<td />').append(numberComma(siteList[i].gen)))
					.append($('<td />').append(numberComma(reward)))
			);
		}

		var pagingMap = result.pagingMap;
		makePageNums2(pagingMap, "GMainSite");
	}
}

// 사이트 목록 클릭 시 활성화
function activateSite(elmt, siteId, grpIdx) {
	$('.dbclickopen').removeClass('click');
	$(elmt).addClass('click');

	$('#smainLink').attr('href', '/siteMain?siteId=' + siteId);

	$('#grpIdx').val(grpIdx);
	formData.grpIdx = grpIdx;
	getGMainSiteTotalDetail(formData);
}

// 사이트 목록 더블클릭 시 사이트메인으로 이동
function goSiteMain(siteId) {
	location.href = '/siteMain?siteId=' + siteId;
}

var groupListHtml = '';
function callback_getGMainGroupList(result) {
	var groupList = result.list;

	groupListHtml = '<li class="on"><a href="#;" onclick="changeGroup(this, \'All\')">전체그룹</a></li>';
	for (var i = 0; i < groupList.length; i++) {
		var li = '<li>'
			.concat('<a href="#;" onclick="changeGroup(this, \'' + groupList[i].site_grp_idx + '\')">')
			.concat(groupList[i].site_grp_name)
			.concat('</a>');
		groupListHtml = groupListHtml.concat(li);
	}
	$('#selAreaList').html(groupListHtml);
}

var oldRankType = 0;
function changeRanking(tabIdx) {
	// html 이동
	$('.tblDisplay > div:eq(' + oldRankType + ')').empty();
	$('.tblDisplay > div:eq(' + tabIdx + ')').empty().append(chartDiv);
	// 차트 초기화
	initChart();

	oldRankType = tabIdx;

	$('#rankType').val(tabIdx + 4);

	var txt = "";
	if(tabIdx == 0) txt = "사용량 순위(kWh)";
	else if(tabIdx == 1) txt = "충방전 순위( kWh)";
	else if(tabIdx == 2) txt = "발전량 순위( kWh)";
	else if(tabIdx == 3) txt = "수익 순위( WON)";
	$("#tabText").empty().text(txt);
	getGMainSiteRankingTotalDetail(); // 사이트 사용량 순위 누적/예상 총합
	getGMainSiteRankingList(1); // 사이트 사용량 순위 목록 조회
}

function changeTerm(term) {
	recycleYn = true;
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

		$('#selAllArea').text('전체지역');
		$('#selAreaList').html(areaListHtml);

		if (allMapFlag) {
			changeAllMap();
		} else {
			changeLocalMap();
		}
	} else if (text == '그룹별') {
		$('#mapUsage').hide();
		$('#groupUsage').show();
		$('#mapGroup').val('group');
		$('#grpIdx').val('');

		$('#selAllArea').text('전체그룹');
		if (groupListHtml == '') {
			getGMainGroupList(formData);
		} else {
			$('#selAreaList').html(groupListHtml);
		}

		done = true;
		clearTimeout(monitoring_cycle_5sec);
		monitoring_cycle_5sec = null;
	}
	recycleYn = true;
	
	fn_cycle();
}

// 콤보박스 이름을 바꾸고 지도 클릭함수를 호출한다.
function changeAllArea(aElmt, lname, areaType) {
	var text = changeLiClass(aElmt);
	$('#selAllArea').text(text);

	area_idx = areaType;
	if (areaType == 0) {
		changeAllMap();
	} else {
		local_detail(lname, areaType);
		changeLocalMap();
	}
}

// 콤보박스 이름을 바꾸고 그룹별로 다시 조회한다.
function changeGroup(aElmt, grpIdx) {
	var text = changeLiClass(aElmt);
	$('#selAllArea').text(text);

	if (grpIdx == 'All') {
		$('#grpIdx').val('');
	} else {
		$('#grpIdx').val(grpIdx);
	}
	recycleYn = true;
	
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
