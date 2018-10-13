var formData = null;

function fn_cycle() {
	formData = getSiteMainSchCollection();

	getGMainAlarmList(formData); // 알람 조회
	getGMainSiteRankingTotalDetail(); // 사이트 사용량 순위 누적/예상 총합
	getGMainSiteRankingList(1); // 사이트 사용량 순위 목록 조회
	if ($('#mapGroup').val() == 'map' || $('#grpIdx').val() != '') {
		getGMainSiteTotalDetail(formData); // 사이트 사용량 총합계 조회
	}
	getGMainSiteList(1); // 사이트 목록 조회

	// 콤보박스 변경 (지역별 상태일 경우만 상세정보 타이틀(지역명)을 가져온다)
	if ($('#mapGroup').val() == 'map') {
		$('#selAllArea').text($('.local_name:eq(1)').text());
	}
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

function callback_getGMainSiteRankingTotalDetail(result) {
	var total = result.detail;
	var now = new Date();

	$('#rankTime').text(now.format('a/p hh:mm') + ' 기준');
//	console.log(total);

	if (total != null) {
		$('#rankTotal').html('<span class="bul1" />');
		if (oldRankType == 0) {
			if (total.usage > 1000) {
				$('#rankTotal > span').text('누적 - ' + numberComma(Math.floor(total.usage / 1000)) + 'MWh');
			} else {
				$('#rankTotal > span').text('누적 - ' + numberComma(total.usage) + 'kWh');
			}
			$('#rankPlan').html('<span class="bul2" />');
			if (total.usage_plan > 1000) {
				$('#rankPlan > span').text('예상 - ' + numberComma(Math.floor(total.usage_plan / 1000)) + 'MWh');
			} else {
				$('#rankPlan > span').text('예상 - ' + numberComma(total.usage_plan) + 'kWh');
			}
		} else if (oldRankType == 1) {
			if (total.charge > 1000) {
				$('#rankTotal > span').text('누적 - ' + numberComma(Math.floor(total.charge / 1000)) + 'MWh');
			} else {
				$('#rankTotal > span').text('누적 - ' + numberComma(total.charge) + 'kWh');
			}
			$('#rankPlan').html('<span class="bul2" />');
			if (total.charge_plan > 1000) {
				$('#rankPlan > span').text('예상 - ' + numberComma(Math.floor(total.charge_plan / 1000)) + 'MWh');
			} else {
				$('#rankPlan > span').text('예상 - ' + numberComma(total.charge_plan) + 'kWh');
			}
		} else if (oldRankType == 2) {
			if (total.gen > 1000) {
				$('#rankTotal > span').text('누적 - ' + numberComma(Math.floor(total.gen / 1000)) + 'MWh');
			} else {
				$('#rankTotal > span').text('누적 - ' + numberComma(total.gen) + 'kWh');
			}
			$('#rankPlan').text('');
		} else if (oldRankType == 3) {
			if (total.reward > 1000) {
				$('#rankTotal > span').text('누적 - ' + numberComma(Math.floor(total.reward / 1000)) + 'MWh');
			} else {
				$('#rankTotal > span').text('누적 - ' + numberComma(total.reward) + 'kWh');
			}
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
//	console.log(total);

	if ($('#mapGroup').val() == 'group') {
		var imgSrc = '/img/group_dimg.png';
		if (total.site_grp_img_path != null && total.site_grp_img_sname != null) {
			imgSrc = total.site_grp_img_path + total.site_grp_img_sname;
		}
		$('#grpImg').attr('src', imgSrc);
		$('.group_name').text(total.site_grp_name);
	}

	if (total != null && total.usage != null) {
		if (total.usage > 1000) {
			$('.detailUsage').text(numberComma(Math.floor(total.usage / 1000)));
			$('.detailUsageUnit').text('MWh');
		} else {
			$('.detailUsage').text(numberComma(total.usage));
			$('.detailUsageUnit').text('kWh');
		}
		if (total.gen > 1000) {
			$('.detailGen').text(numberComma(Math.floor(total.gen / 1000)));
			$('.detailGenUnit').text('MWh');
		} else {
			$('.detailGen').text(numberComma(total.gen));
			$('.detailGenUnit').text('kWh');
		}
		if (total.charge > 1000) {
			$('.detailCharge').text(numberComma(Math.floor(total.charge / 1000)));
			$('.detailChargeUnit').text('MWh');
		} else {
			$('.detailCharge').text(numberComma(total.charge));
			$('.detailChargeUnit').text('kWh');
		}

		$('.detailReward').text(numberComma(total.reward));
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
		var imgSrc = '';
		var grpName = '';

		for (var i = 0; i < siteList.length; i++) {
			var eq1Cls = siteList[i].ioe > 0 ? ' on' : '';
			var eq2Cls = siteList[i].pcs > 0 ? ' on' : '';
			var eq3Cls = siteList[i].bms > 0 ? ' on' : '';
			var eq4Cls = siteList[i].pv > 0 ? ' on' : '';

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
					.append($('<td />').append(numberComma(siteList[i].usage)))
					.append($('<td />').append(numberComma(siteList[i].charge)))
					.append($('<td />').append(numberComma(siteList[i].gen)))
					.append($('<td />').append(numberComma(siteList[i].reward)))
			);

			if ($('#mapGroup').val() == 'group' && $('#grpIdx').val() == '' && i == 0) {
				$('#grpIdx').val(siteList[i].site_grp_idx);
				formData.grpIdx = siteList[i].site_grp_idx;
				getGMainSiteTotalDetail(formData);
			}
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

	getGMainSiteRankingTotalDetail(); // 사이트 사용량 순위 누적/예상 총합
	getGMainSiteRankingList(1); // 사이트 사용량 순위 목록 조회
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
