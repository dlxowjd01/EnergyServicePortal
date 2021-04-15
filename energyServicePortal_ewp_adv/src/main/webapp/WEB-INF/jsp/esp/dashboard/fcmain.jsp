<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<link type="text/css" rel="stylesheet" href="/css/fcmain.css" />
<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header"></div>
	<div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATABASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div>
</div>

<div class="row content-wrapper" id="fcmainContent">
	<div class="fcmain-section col-xl-4 col-md-12 col-sm-12">
		<div class="fcmain-block">
			<div class="indiv fcmain-block-s">
				<h2 class="title">금일 발전량</h2>
				<h1 class="value-unit">
					<span>-</span>
					<span>kW</span>
				</h1>
			</div>
			<div class="indiv fcmain-block-s">
				<h2 class="title">금일 열 생산량</h2>
				<h1 class="value-unit">
					<span>-</span>
					<span>Kcal/h</span>
				</h1>
			</div>
		</div>
		<div class="indiv fcmain-block-m" id="fcmain-1-2">
			<h2 class="title">실시간 운영정보</h2>
			<div>
				<div>
					<p>운전 상태</p>
					<span class="status-button normal">운전중</span>
				</div>
				<div>
					<p>통신 상태</p>
					<span class="status-button normal">정상</span>
				</div>
				<div>
					<p>출력 상태</p>
					<span class="status-button off">0%</span>
				</div>
			</div>
			<div>
				<ul>
					<li>연료전지용량</li>
					<li>
						<span>-</span>
						<span></span>
					</li>
				</ul>
				<ul>
					<li>금일 운영시간</li>
					<li>
						<span>-</span>
						<span></span>
					</li>
				</ul>
			</div>
		</div>
		<div class="indiv fcmain-block-l">
			<h2 class="title mb-24">
				금일 발전현황
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span></span>
					<img src="/img/ico-next.svg" class="next hidden">
				</span>
			</h2>

			<div id="hourlyChart">
				<!-- 금일 발전현황 그래프 -->
			</div>
		</div>
	</div>

	<div class="fcmain-section col-xl-4 col-md-12 col-sm-12">
		<div class="fcmain-block">
			<div class="indiv fcmain-block-s">
				<h2 class="title">전일 발전량</h2>
				<h1 class="value-unit">
					<span>-</span>
					<span>천원</span>
				</h1>
			</div>
			<div class="indiv fcmain-block-s">
				<h2 class="title">전일 열 생산량</h2>
				<h1 class="value-unit">
					<span>-</span>
					<span>kWh</span>
				</h1>
			</div>
		</div>
		<div class="indiv fcmain-block-xl">
			<h2 class="title">실시간 운전현황</h2>
			<div id="fcmain-status">
				<div class="fcmain-status-left">
					<p class="subtitle">연료 유입</p>
					<div>
						<div class="fcmain-status-block">
							<ul>
								<li>
									<img src="/img/fcmain/gas.svg" alt="GAS" />
									<span>GAS</span>
								</li>
								<li id="realTimeGas">
									<span>-</span>
									<span>Liter/hr</span>
								</li>
							</ul>
						</div>
						<div class="arrow">
							<div></div>
							<div></div>
							<div></div>
						</div>
					</div>
				</div>
				<div class="fcmain-status-right">
					<div class="fcmain-status-block">
						<ul>
							<li>
								<img src="/img/fcmain/electricity.svg" alt="전력" />
								<span>전력</span>
							</li>
							<li id="realTimeActive">
								<span>-</span>
								<span>kW</span>
							</li>
						</ul>
					</div>

					<div class="arrow">
						<div></div>
						<div></div>
						<div></div>
					</div>

					<div class="fcmain-status-block">
						<ul id="realtimeEfficiency">
							<li>
								<img src="/img/fcmain/fuelcell.svg" alt="연료전지" />
								<span>연료전지</span>
							</li>
						</ul>
						<div>
							<ul>
								<li>전기 효율</li>
								<li><span>-</span> %</li>
							</ul>
							<ul>
								<li>열 효율</li>
								<li><span>-</span> %</li>
							</ul>
						</div>
					</div>

					<div class="arrow">
						<div></div>
						<div></div>
						<div></div>
					</div>

					<div class="fcmain-status-block">
						<ul>
							<li>
								<img src="/img/fcmain/hotwater.svg" alt="열" />
								<span>열</span>
							</li>
							<li id="realTimeHeat">
								<span>-</span>
								<span>kW</span>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="fcmain-section col-xl-4 col-md-12 col-sm-12">
		<div class="fcmain-block">
			<div class="indiv fcmain-block-s">
				<h2 class="title">누적 발전량</h2>
				<h1 class="value-unit">
					<span>-</span>
					<span>MWh</span>
				</h1>
			</div>
			<div class="indiv fcmain-block-s">
				<h2 class="title">누적 열 생산량</h2>
				<h1 class="value-unit">
					<span>-</span>
					<span>Gcal/h</span>
				</h1>
			</div>
		</div>
		<div class="indiv fcmain-block-m fcmain-alarm" data-alarm="">
			<div class="alarm-status">
				<div class="alarm-alert"><span>알림 메시지</span><em>0</em></div>
			</div>
			<div class="alarm-notice">
				<ul id="alarmNotice">
					<li>
						<a href="javascript:void(0);" onclick="pageMove('[sid]', 'alarm');">
							<span class="err-msg">[site_name] - [message]</span>
							<span class="err-time">[standardTime]</span>
						</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="indiv fcmain-block-l">
			<h2 class="title">
				월별 발전량 종합
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span></span>
					<img src="/img/ico-next.svg" class="next hidden">
				</span>
			</h2>

			<div class="fcmain-month-list">
				<ul>
					<li>총 발전량</li>
					<li>
						<span id="monthEnergy">-</span>
						<span>kWh</span>
					</li>
				</ul>
				<ul>
					<li><fmt:message key='smain.totalYearDev' /></li>
					<li>
						<span id="yearEnergy">-</span>
						<span>MWh</span>
					</li>
				</ul>
				<ul>
					<li>총 운영시간</li>
					<li>
						<span id="monthHours">-</span>
						<span>Hrs</span>
					</li>
				</ul>
			</div>

			<div id="dailyChart">
				<!-- 월별 발전량 종합 그래프 -->
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	const siteId = '${sid}';
	const sList = JSON.parse('${siteList}');

	const apiEnergySite = '/energy/sites';
	const apiEnergyNowSite = '/energy/now/sites';
	const apiStatusRawSite = '/status/raw/site';
	const apiStatusHealth = '/get/status/health';

	let f1 = d3.format(',.1f');
	let f2 = d3.format(',.2f');

	const today = new Date();

	$(function() {
		setInitList('alarmNotice'); //알람 공지 세팅
		todayStatus();
		alarmInfoList();
		todayGen();
		dailyGen();

		$('img.next').on('click', function() {
			const standard = $(this).parent().find('span').data('standard');
			if ($('img.next').index(this) === 0) {
				standard.setDate(standard.getDate() + 1);
				if (today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth() && today.getDate() === standard.getDate()) {
					$(this).parent().find('img.next').addClass('hidden');
				} else {
					$(this).parent().find('img.next').removeClass('hidden');
				}
				todayGen(standard);
			} else {
				standard.setDate(1);
				standard.setMonth(standard.getMonth() + 1);
				if (((today.getFullYear() === standard.getFullYear()) && today.getMonth() > standard.getMonth()) || today.getFullYear() != standard.getFullYear()) {
					$(this).parent().find('img.next').removeClass('hidden');
				} else {
					$(this).parent().find('img.next').addClass('hidden');
				}
				dailyGen(standard);
			}
		});

		$('img.back').on('click', function() {
			const standard = $(this).parent().find('span').data('standard');
			if ($('img.back').index(this) === 0) {
				standard.setDate(standard.getDate() - 1);
				if (today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth() && today.getDate() === standard.getDate()) {
					$(this).parent().find('img.next').addClass('hidden');
				} else {
					$(this).parent().find('img.next').removeClass('hidden');
				}
				$('#miniLoadingCircle_month').show();
				todayGen(standard);
			} else {
				standard.setDate(1);
				standard.setMonth(standard.getMonth() - 1);
				if (((today.getFullYear() === standard.getFullYear()) && today.getMonth() > standard.getMonth()) || today.getFullYear() != standard.getFullYear()) {
					$(this).parent().find('img.next').removeClass('hidden');
				} else {
					$(this).parent().find('img.next').addClass('hidden');
				}
				dailyGen(standard);
			}
		});
	});

	//상단 정보 표시
	const todayStatus = async () => {
		const dayData = getSiteMainSchCollection('day');
		const yesterData = getSiteMainSchCollection('yesterday');

		const targetApi = [
			$.ajax({
				url: apiHost + apiEnergyNowSite,
				type: 'GET',
				data: {
					sids: siteId,
					metering_type: 2,
					interval: 'day'
				}
			}),
			$.ajax({
				url: apiHost + apiEnergySite,
				type: 'get',
				dataType: 'json',
				data: {
				sid: siteId,
					startTime: yesterData.startTime,
					endTime: yesterData.endTime,
					interval: 'day',
					displayType: 'dashboard',
					formId: 'v2'
				}
			}),
			$.ajax({
				url: apiHost + apiStatusRawSite,
				type: 'GET',
				data: {
					sid: siteId,
					formId: 'v2'
				}
			}),
			$.ajax({
				url: apiHost + apiStatusHealth,
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({ sids: siteId })
			})
		];

		new Promise(resolve => {
			resolve(Promise.all(targetApi));
		}).then(response => {
			response.forEach((rspns, index) => {
				if (index === 0) {
					const siteEnergy = rspns['data'][siteId];

					if (isEmpty(siteEnergy)) {
						//금일 발전량
						$('.fcmain-block-s .value-unit span:first-child').eq(0).html('-'); //금일 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(0).html(''); //금일 발전량

						//금일 열 생산량
						$('.fcmain-block-s .value-unit span:first-child').eq(1).html('-') //금일 열 생산량
						$('.fcmain-block-s .value-unit span:last-child').eq(1).html('') //금일 열 생산량
					} else {
						const todayEnergy = displayNumberFixedDecimal(siteEnergy['energy'], 'Wh', 3, 1)
							, todayHeat = displayNumberFixedDecimal(siteEnergy['henergy'], 'Wh', 3, 1);

						//금일 발전량
						$('.fcmain-block-s .value-unit span:first-child').eq(0).html(todayEnergy[0]); //금일 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(0).html(todayEnergy[1]); //금일 발전량

						//금일 열 생산량
						$('.fcmain-block-s .value-unit span:first-child').eq(1).html(todayHeat[0]) //금일 열 생산량
						$('.fcmain-block-s .value-unit span:last-child').eq(1).html(todayHeat[1]) //금일 열 생산량
					}
				} else if (index === 1) {
					const siteEnergy = rspns['data'][siteId];

					if (isEmpty(siteEnergy) || isEmpty(siteEnergy[0]['items'])) {
						//전일 발전량
						$('.fcmain-block-s .value-unit span:first-child').eq(2).html('-') //전일 발전량
						$('.fcmain-block-s ㅊ.value-unit span:last-child').eq(2).html('') //전일 발전량

						//전일 열 생산량
						$('.fcmain-block-s .value-unit span:first-child').eq(3).html('-') //전일 열 생성량
						$('.fcmain-block-s .value-unit span:last-child').eq(3).html('') //전일 열 생성량
					} else {
						const yesterdayEnergy = displayNumberFixedDecimal(siteEnergy[0]['items'][0]['energy'], 'Wh', 3, 1)
							, yesterdayHeat = displayNumberFixedDecimal(siteEnergy[0]['items'][0]['henergy'], 'Wh', 3, 1);

						//전일 발전량
						$('.fcmain-block-s .value-unit span:first-child').eq(2).html(yesterdayEnergy[0]) //전일 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(2).html(yesterdayEnergy[1]) //전일 발전량
3
						//전일 열 생산량
						$('.fcmain-block-s .value-unit span:first-child').eq(3).html(yesterdayHeat[0]) //전일 열 생성량
						$('.fcmain-block-s .value-unit span:last-child').eq(3).html(yesterdayHeat[1]) //전일 열 생성량
					}
				} else if (index === 2) {
					if (isEmpty(rspns['INV_FC'])) {
						$('.fcmain-block-s .value-unit span:first-child').eq(4).html('-') //누적 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(4).html('') //누적 발전량

						$('.fcmain-block-s .value-unit span:first-child').eq(5).html('-') //누적 열 생성량
						$('.fcmain-block-s .value-unit span:last-child').eq(5).html('') //누적 열 생성량


						$('#realTimeGas span:first-child').text('-').next().text('');
						$('#realTimeActive span:first-child').text('-').next().text('');
						$('#realTimeHeat span:first-child').text('-').next().text('');
					} else {
						const energy = displayNumberFixedDecimal(rspns['INV_FC']['accumActiveEnergy'], 'Wh', 3, 1)
							, heat = displayNumberFixedDecimal(rspns['INV_FC']['accumHeatEnergy'], 'cal/h', 3, 1)
							, realTimeGas = rspns['INV_FC']['gasUsage']
							, realTimeActive = displayNumberFixedDecimal(rspns['INV_FC']['activePower'], 'W', 3, 1)
							, realTimeHeat = displayNumberFixedDecimal(rspns['INV_FC']['heatPower'], 'W', 3, 1)
							, deviceOperation = rspns['INV_FC']['operation']
							, deviceLoad = rspns['INV_FC']['load']
							, capacity = displayNumberFixedDecimal(sList[0]['capacities']['gen'], 'W', 3, 1);

						$('.fcmain-block-s .value-unit span:first-child').eq(4).html(energy[0]) //누적 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(4).html(energy[1]) //누적 발전량

						$('.fcmain-block-s .value-unit span:first-child').eq(5).html(heat[0]) //누적 열 생성량
						$('.fcmain-block-s .value-unit span:last-child').eq(5).html(heat[1]) //누적 열 생성량

						$('#realTimeGas span:first-child').text(numberComma(realTimeGas));
						$('#realTimeActive span:first-child').text(realTimeActive[0]).next().text(realTimeActive[1]);
						$('#realTimeHeat span:first-child').text(realTimeHeat[0]).next().text(realTimeHeat[1]);

						$('#fcmain-1-2 div:nth-child(3) ul:first-child li:last-child span:first-child').text(capacity[0]).next().text(capacity[1]);

						if (isEmpty(deviceOperation)) {
							$('.status-button').eq(0).attr('class', 'status-button NA').text('N/A');
						} else if (deviceOperation === 0) {
							$('.status-button').eq(0).attr('class', 'status-button off').text('정지');
						} else if (deviceOperation === 1) {
							$('.status-button').eq(0).attr('class', 'status-button normal').text('운전중');
						} else {
							$('.status-button').eq(0).attr('class', 'status-button error').text('오류');
						}


						if (isEmpty(deviceLoad)) {
							$('.status-button').eq(2).attr('class', 'status-button off').text('-');
						} else if (deviceLoad === 0) {
							$('.status-button').eq(2).attr('class', 'status-button off').text(deviceLoad + '%');
						} else if (deviceLoad > 0 && deviceLoad <= 50) {
							$('.status-button').eq(2).attr('class', 'status-button error').text(deviceLoad + '%');
						} else {
							$('.status-button').eq(2).attr('class', 'status-button normal').text(deviceLoad + '%');
						}
					}
				} else {
					if (!isEmpty(rspns['sites']) && !isEmpty(rspns['sites'][0]) && !isEmpty(rspns['sites'][0]['rtus'])) {
						const rtus = rspns['sites'][0]['rtus'];
						const rtuOperation = rtus.find(e => e.operation === 1);
						const rtuType = rtus.find(e => e.rtu_type === 2);

						if (!isEmpty(rtuOperation) && (isEmpty(rtuType) || rtuType !== 2)) {
							$('.status-button').eq(1).attr('class', 'status-button normal').text('정상');
						} else {
							if (rtuType === 2) {
								$('.status-button').eq(1).attr('class', 'status-button NA').text('N/A');
							} else {
								$('.status-button').eq(1).attr('class', 'status-button error').text('error');
							}
						}
					} else {
						$('.status-button').eq(1).attr('class', 'status-button error').text('error');
					}
				}
			})
		}).catch(error => {
			console.error(error);
		});
	}

	//금일 발전현황
	const todayGen = (standard) => {
		let yearData = getSiteMainSchCollection('day');

		let startTime = '', endTime = '';
		if (standard === undefined || (standard !== undefined && today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth() && today.getDate() === standard.getDate())) {
			$('#hourlyChart').parent().find('.title span.term span').text(today.format('yyyy.MM.dd')).data('standard', new Date());
			startTime = Number(yearData.startTime), endTime = Number(yearData.endTime);
		} else {
			$('#hourlyChart').parent().find('.title span.term span').text(standard.format('yyyy.MM.dd')).data('standard', standard);
			startTime = Number(standard.format('yyyyMMdd') + '000000'), endTime = Number(standard.format('yyyyMMdd') + '235959');
		}

		const targetApi = [
			$.ajax({
				url: apiHost + apiEnergySite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: startTime,
					endTime: endTime,
					interval: 'hour',
					displayType: 'dashboard',
					formId: 'v2'
				}
			})
		]

		if (standard === undefined || (standard !== undefined && today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth() && today.getDate() === standard.getDate())) {
			//오늘 일경우 now도 조회한다.
			targetApi.push(
				$.ajax({
					url: apiHost + apiEnergyNowSite,
					type: 'get',
					data: {
						sids: siteId,
						metering_type: '2',
						interval: 'hour'
					}
				})
			);
		}

		new Promise(resolve => {
			resolve(Promise.all(targetApi));
		}).then(response => {
			const hourlyGen = new Array(24).fill(0);
			const hourlyMoney = new Array(24).fill(0);

			response.forEach((rspns, index) => {
				if (index === 0) {
					if (!isEmpty(rspns['data'][siteId])) {
						const siteData = rspns['data'][siteId][0];
						if (!isEmpty(siteData) && !isEmpty(siteData['items'])) {
							const genItems = siteData['items'];
							genItems.forEach(item => {
								const timeIndex = Number(String(item['basetime']).substr(8, 2));
								hourlyGen[timeIndex] = item['energy'] / 1000;
								hourlyMoney[timeIndex] = item['money'] / 1000;
							});
						}
					}
				} else {
					if (!isEmpty(rspns['data']) && !isEmpty(rspns['data'][siteId])) {
						const siteData = rspns['data'][siteId], nowDate = new Date();
						hourlyGen[nowDate.getHours()] = siteData['energy'] / 1000;
						hourlyMoney[nowDate.getHours()] = siteData['money'] / 1000;
					}
				}
			});

			hourlyChart.series.forEach((e, idx) => {
				if (idx === 0) {
					hourlyChart.series[idx].update({data: hourlyGen});
				} else {
					hourlyChart.series[idx].update({data: hourlyMoney});
				}
			});
			hourlyChart.redraw();
		}).catch(error => {
			console.error(error);
		});
	}


	//알람리스트
	const alarmInfoList = async (siteSids) => {
		const alarmColorTemp = ['info', 'warning', 'critical', 'shutoff', 'urgent'];
		$.ajax({
			url: apiHost + '/get/alarms',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify({
				sids: siteId,
				startTime: Number(new Date().format('yyyyMMdd') + '000000'),
				endTime: Number(new Date().format('yyyyMMdd') + '235959'),
				confirm: false
			})
		}).done((data, textStatus, jqXHR) => {
			if (!isEmpty(data)) {
				//localtime 오름차순 정렬
				data.sort((a, b) => {
					return a.localtime > b.localtime ? -1 : a.localtime < b.localtime ? 1 : 0;
				});

				let alarmList = new Array();
				let alarmColor = "";
				let alarmEl = $('.indiv[data-alarm]');

				data.forEach(alarm => {
					if (alarm.level !== 0) {
						let localTime = (alarm.localtime != null && alarm.localtime != '') ? String(alarm.localtime) : '';
						alarm.standardTime = localTime.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1-$2-$3 $4:$5:$6');
						alarmList.push(alarm);
					}
				});

				if (alarmList.length > 0) {
					const alarmColorList = alarmList.slice();
					alarmColorList.sort((a, b) => {
						return a.level < b.level ? -1 : a.level > b.level ? 1 : 0;
					});

					const targetLevel = alarmColorList[0].level;
					if (targetLevel > 4) {
						alarmColor = '';
					} else {
						alarmColor = alarmColorTemp[targetLevel];
					}
				} else {
					alarmColor = '';
				}

				alarmEl.attr('data-alarm', alarmColor);
				alarmEl.find('em').text(alarmList.length);
				setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}}); //list생성
			} else {
				let alarmList = new Array();
				let noTodayErrorMsg = '발생한 오류가 없습니다';
				if(langStatus == 'EN') {
					noTodayErrorMsg = 'There is no alert';
				}
				alarmList.push({
					site_name: "noTodayError",
					message: noTodayErrorMsg,
					standardTime: ""
				});
				setMakeList(alarmList, 'alarmNotice', {'dataFunction': {'level': levelClass}}); //list생성
			}
		}).fail((jqXHR, textStatus, errorThrown) => {
			console.error(textStatus);
		});
	}

	/**
	 * 알람 이력 레벨 클래스
	 * 리스트 작성시 level별 클래스 지정
	 *
	 * @param level
	 * @returns {string}
	 */
	const levelClass = (level) => {
		let rtnClass = '';
		switch (level) {
			case 1 :
				rtnClass = 'warning';
				break;
			case 2 :
				rtnClass = 'critical';
				break;
			case 3 :
				rtnClass = 'shutoff';
				break;
			case 4 :
				rtnClass = 'urgent';
				break;
			case 0 :
				rtnClass = 'info';
				break;
			default :
				rtnClass = '';
		}

		return rtnClass;
	}

	//월별 발전량 종합
	const dailyGen = (standard) => {
		let monthData = getSiteMainSchCollection('month');
		let yearData = getSiteMainSchCollection('year');

		let lastDay = 0, startTime = '', endTime = '';
		if (standard !== undefined && (today.getFullYear() != standard.getFullYear() || today.getMonth() != standard.getMonth())) {
			lastDay = new Date(standard.getFullYear(), standard.getMonth() + 1, 0);
			$('#dailyChart').parent().find('.title span.term span').text(standard.format('yyyy.MM') + '.01 ~ ' + standard.format('yyyy.MM') + '.' + ('0' + lastDay.getDate()).slice(-2)).data('standard', standard);
			startTime = Number(standard.format('yyyyMM') + '01000000'), endTime = Number(lastDay.format('yyyyMMdd') + '235959');
		} else {
			lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
			$('#dailyChart').parent().find('.title span.term span').text(today.format('yyyy.MM') + '.01 ~ ' + today.format('yyyy.MM') + '.' + ('0' + today.getDate()).slice(-2)).data('standard', new Date());
			startTime = Number(monthData.startTime), endTime = Number(monthData.endTime);
		}

		const targetApi = [
			$.ajax({
				url: apiHost + apiEnergySite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: yearData.startTime,
					endTime: yearData.endTime,
					interval: 'month',
					displayType: 'dashboard',
					formId: 'v2'
				}
			}),
			$.ajax({
				url: apiHost + apiEnergyNowSite,
				type: 'get',
				data: {
					sids: siteId,
					metering_type: '2',
					interval: 'month'
				}
			}),
			$.ajax({
				url: apiHost + apiEnergySite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: startTime,
					endTime: endTime,
					interval: 'day',
					displayType: 'dashboard',
					formId: 'v2'
				}
			})
		];

		if (standard === undefined || (standard !== undefined && today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth())) {
			targetApi.push(
				$.ajax({
					url: apiHost + apiEnergyNowSite,
					type: 'get',
					data: {
						sids: siteId,
						metering_type: '2',
						interval: 'day'
					}
				})
			)
		}

		new Promise(resolve => {
			resolve(Promise.all(targetApi));
		}).then(response => {
			const categories = new Array();
			for (let i = 1; i <= lastDay.getDate(); i++) { categories.push(String(i)); }

			let thisYearGen = null;
			const monathlyGenData = new Array(lastDay.getDate()).fill(0);
			const monathlyMoneyData = new Array(lastDay.getDate()).fill(0);

			response.forEach((rspns, index) => {
				if (index === 0) {
					if (!isEmpty(rspns['data'])) {
						const siteData = rspns['data'][siteId][0];
						(siteData.items).forEach(item => {
							thisYearGen = Number(thisYearGen) + item['energy'];
						});
					}
				} else if (index === 1) {
					const siteData = rspns['data'][siteId]
						, nowEnergyData = siteData['energy'];
					thisYearGen = Number(thisYearGen) + nowEnergyData;
				} else if (index === 2) {
					if (!isEmpty(rspns['data'])) {
						const siteData = rspns['data'][siteId][0];
						(siteData.items).forEach(item => {
							const baseTime = item['basetime']
								, targetDay = Number(String(baseTime).substr(6, 2)) - 1;
							monathlyGenData[targetDay] = item['energy'];
							monathlyMoneyData[targetDay] = item['money'];
						});
					}
				} else {
					const siteData = rspns['data'][siteId]
						, nowEnergyData = siteData['energy'];

					monathlyGenData[today.getDate() - 1] = nowEnergyData;
					monathlyMoneyData[today.getDate() - 1] = siteData['money'];
				}
			});

			if (isEmpty(thisYearGen)) {
				$('#yearEnergy').text('-').next().html('');
			} else {
				const refinedYearData = displayNumberFixedDecimal(thisYearGen, 'Wh', 3, 1);
				$('#yearEnergy').text(refinedYearData[0]).next().text(refinedYearData[1]);
			}

			const totalMonthGen = monathlyGenData.reduce( function add(sum, currValue) { return sum + currValue; });
			const refinedTotalMonth = displayNumberFixedDecimal(totalMonthGen, 'Wh', 3, 1);
			const totalMonthGenHour = totalMonthGen / sList[0]['capacities']['gen'] * 100;

			$('#monthEnergy').text(refinedTotalMonth[0]).next().text(refinedTotalMonth[1])

			if (!isFinite(totalMonthGenHour)) {
				$('#monthHours').text('-').next().text('');
			} else {
				$('#monthHours').text(f1(totalMonthGenHour)).next().text('hrs');
			}

			dailyChart.xAxis[0].update({categories: categories});
			dailyChart.series.forEach((e, idx) => {
				if (idx === 0) {
					dailyChart.series[idx].update({data: monathlyGenData});
				} else {
					dailyChart.series[idx].update({data: monathlyMoneyData});
				}
			});
			dailyChart.redraw();
		}).catch(error => {
			console.error(error);
		});
	}

	const hourlyChart = Highcharts.chart('hourlyChart', {
		chart: {
			marginTop: 50,
			marginLeft: 50,
			marginRight: 50,
			height: 380,
			backgroundColor: 'transparent',
			zoomType: 'xy'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: {
			lineColor: 'var(--grey)',
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			labels: {
				align: 'center',
				overflow: 'justify',
				rotation: 0,
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickInterval: 2,
			title: {
				text: null
			},
			categories: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'],
			crosshair: true
		},
		yAxis: [
			{
				showEmpty: false,
				opposite: false,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				gridLineWidth: 1,
				min: 0,
				title: {
					x: 3,
					y: 27,
					text: 'kWh',
					align: 'low',
					rotation: 0,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					overflow: 'justify',
					formatter: function () {
						let length = String(Math.round(this.value)).length;
						if (length >= 7) {
							return f1(this.value / 1000000) + 'M';
						} else if ( (length >= 3) ){
							return f1(this.value / 1000) + 'K';
						} else {
							return f1(this.value);
						}
					},
					x: -5,
					style: {
						color: 'var(--grey)',
						fontSize: '11px'
					}
				}
			}, {
				gridLineWidth: 0,
				title: {
					text: i18nManager.tr("gmain.1000won"),
					align: 'low',
					rotation: 0,
					y: 25,
					x: 15,
					style: {
						color: 'var(--grey)',
						fontSize: '12px',
						transform: 'translate(-30px, 0px)'
					}
				},
				labels: {
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					},
					formatter: function () {
						let length = String(Math.round(this.value)).length;
						if (length >= 7) {
							return f1(this.value / 1000000) + 'M';
						} else if ( (length >= 3) ){
							return f1(this.value / 1000) + 'K';
						} else {
							return f1(this.value);
						}
					},
				},
				opposite: true,
				showEmpty: false
			}
		],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					let value = suffix === "H" ? ((point.y / 100).toFixed(2) * 1)+suffix : numberComma(point.y)+suffix

					return s + '<br/><span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + value;
				}, '<span style="display:flex; margin-bottom:-10px;"><b>'+(langStatus === "KO" ? this.x+'시' : this.x+'H')+'</b></span>');
			},
			shared: true,
			useHTML: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white87)',
			},
		},
		legend: {
			enabled: true,
			x: 5,
			y: -10,
			align: 'right',
			verticalAlign: 'top',
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
				fontWeight: 400
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 3,
			symbolHeight: 7
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderColor: 'var(--grey)',
				borderWidth: 0
			},
			line: {
				marker: {
					enabled: true
				}
			},
			column: {
				//stacking: 'normal'
			}
		},
		credits: {
			enabled: false
		},
		series: [
			{
				type: 'column',
				name: '<fmt:message key='smain.generation' />', /* 발전량 */
				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: []
			},
			{
				type: 'spline',
				dashStyle: 'ShortDash',
				name: '<fmt:message key="gdash.1.revenue" />',
				color: 'var(--white)',
				tooltip: {
					valueSuffix: '만원',
				},
				marker: {
					symbol: 'circle'
				},
				yAxis: 1,
				data: []
			},
		],
	});

	const dailyChart = Highcharts.chart('dailyChart', {
		chart: {
			marginTop: 40,
			marginLeft: 50,
			marginRight: 50,
			height: 300,
			backgroundColor: 'transparent',
			zoomType: 'xy'
		},
		navigation: {
			buttonOptions: {
				enabled: false
			}
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		xAxis: [{
			lineColor: 'var(--grey)',
			tickWidth: 1,
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			type: 'datetime',
			dateTimeLabelFormats: {
				millisecond: '%H:%M:%S.%L',
				second: '%H:%M:%S',
				minute: '%H:%M',
				hour: '%H',
				day: '%m.%d ',
				week: '%m.%e',
				month: '%m',
				year: '%Y'
			},
			labels: {
				align: 'center',
				y: 27,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			tickWidth: 1,
			tickColor: 'var(--grey)',
			tickInterval: 1,
			title: {
				text: null
			},
			categories: null,
			crosshair: true
		}],
		yAxis: [{
			lineColor: 'var(--grey)',
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			gridLineWidth: 1,
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			title: {
				text: 'kWh',
				align: 'low',
				rotation: 0,
				y: 25,
				x: 15,
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-28px, 0px)'
				}
			},
			labels: {
				formatter: function () {
					let length = String(Math.round(this.value)).length;
					if (length >= 7) {
						return f1(this.value / 1000000) + 'M';
					} else if ( (length >= 3) ){
						return f1(this.value / 1000) + 'K';
					} else {
						return f1(this.value);
					}
				},
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			showEmpty: false
		}, {
			gridLineWidth: 0,
			title: {
				text: i18nManager.tr("gmain.1000won"),
				align: 'low',
				rotation: 0,
				y: 25,
				x: 0,
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-30px, 0px)'
				}
			},
			labels: {
				formatter: function () {
					return  numberComma(this.value);
				},
				style: {
					color: 'var(--grey)',
					fontSize: '12px',
					transform: 'translate(-10px, 0px)'
				}
			},
			opposite: true,
			showEmpty: false
		}],
		tooltip: {
			hideDelay: 1,
			formatter: function () {
				return this.points.reduce(function (s, point) {
					if(point.y !== 0) {
						let suffix = point.series.userOptions.tooltip.valueSuffix;
						return s + ' <br/><span style="color:' + point.color + '">\u25CF</span> ' + point.series.name + ': ' + numberComma(Math.round(point.y / 10)) + ' ' + suffix;
					} else {
						return s
					}
				}, `<span style="display:flex;"><b>${'${langStatus === "KO" ? this.x + "일" : dayEN[this.x - 1]}'}</b></span>`);
			},
			shared: true,
			useHTML: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,

			style: {
				color: 'var(--white87)',
			}
		},
		legend: {
			enabled: true,
			align: 'right',
			verticalAlign: 'top',
			x: 5,
			y: -15,
			itemStyle: {
				color: 'var(--white87)',
				fontSize: '12px',
			},
			itemHoverStyle: {
				color: ''
			},
			symbolPadding: 0,
			symbolHeight: 7
		},
		plotOptions: {
			series: {
				label: {
					connectorAllowed: false
				},
				borderWidth: 0,
				events: {
					legendItemClick: function () {
						var visibility = this.visible ? 'visible' : 'hidden';
						this.legendItem.styles.color == 'var(--white60)'
					}
				},
				events: {
					click: function (event) {
						const x = event.point.category;
						goPvGen(x, 'hour');
					}
				}
			},
			line: {
				marker: {
					enabled: false
				}
			},
			column: {
				stacking: 'normal'
			}
		},
		credits: {
			enabled: false
		},
		series: [
			{
				type: 'column',
				name: '<fmt:message key='smain.generation' />', /* 발전량 */
				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: []
			},
			{
				type: 'spline',
				dashStyle: 'ShortDash',
				name: '<fmt:message key="gdash.1.revenue" />',
				color: 'var(--white)',
				tooltip: {
					valueSuffix: '천원',
				},
				marker: {
					symbol: 'circle'
				},
				yAxis: 1,
				data: []
			},
		]
	});
</script>