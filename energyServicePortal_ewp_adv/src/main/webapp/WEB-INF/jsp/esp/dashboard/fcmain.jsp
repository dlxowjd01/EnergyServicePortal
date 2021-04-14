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
					<p>인버터 상태</p>
					<span class="status-button error">이상</span>
				</div>
			</div>
			<div>
				<ul>
					<li>연료전지용량</li>
					<li><span>0.8</span> MW</li>
				</ul>
				<ul>
					<li>금일 운영시간</li>
					<li><span>4.79</span> Hrs</li>
				</ul>
			</div>
		</div>
		<div class="indiv fcmain-block-l">
			<h2 class="title mb-24">
				금일 발전현황
				<span class="term">
					<img src="/img/ico-back.svg" class="back">
					<span>2021.04.01 ~ 2021.04.13</span>
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
									<span>507</span>
									N<span class="small-text">m</span>3/hr
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
								<span>303,7</span>
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
								<span>60</span>
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
				<h2 class="title">누적 방전량</h2>
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
					<li><fmt:message key='smain.totalMonthDev' /></li>
					<li>
						<span id="monthEnergy">8.49</span>
						<span>kWh</span>
					</li>
				</ul>
				<ul>
					<li><fmt:message key='smain.totalYearDev' /></li>
					<li>
						<span id="yearEnergy">15.90</span>
						<span>MWh</span>
					</li>
				</ul>
				<ul>
					<li><fmt:message key='smain.avgMonthDevTime' /></li>
					<li>
						<span id="monthHours">3.69</span>
						<span>Hrs</span>
					</li>
				</ul>
			</div>

			<div id="monthlyChart">
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

	const today = new Date();

	$(function() {
		setInitList('alarmNotice'); //알람 공지 세팅
		todayStatus();
		alarmInfoList();
		monthlyGen();

		$('img.next').on('click', function() {
			const standard = $(this).parent().find('span').data('standard');
			if ($('img.next').index(this) === 0) {
				standard.setDate(standard.getDate() - 1);
				if (today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth() && today.getDate() === standard.getDate()) {
					$(this).parent().find('img.next').addClass('hidden');
				} else {
					$(this).parent().find('img.next').removeClass('hidden');
				}
				todayGen(standard);
			} else {
				standard.setFullYear(standard.getFullYear() - 1);
				if (today.getFullYear() <= standard.getFullYear()) {
					$(this).parent().find('img.next').addClass('hidden');
				} else {
					$(this).parent().find('img.next').removeClass('hidden');
				}
				$('#miniLoadingCircle_type').show();
				monthlyGen(standard);
			}
		});

		$('img.back').on('click', function() {
			const standard = $(this).parent().find('span').data('standard');
			if ($('img.back').index(this) === 0) {
				standard.setFullYear(standard.getFullYear() - 1);
				if (today.getFullYear() === standard.getFullYear() && today.getMonth() === standard.getMonth() && today.getDate() === standard.getDate()) {
					$(this).parent().find('img.next').addClass('hidden');
				} else {
					$(this).parent().find('img.next').removeClass('hidden');
				}
				$('#miniLoadingCircle_month').show();
				todayGen(standard);
			} else {
				standard.setFullYear(standard.getFullYear() - 1);
				if (today.getFullYear() > standard.getFullYear()) {
					$(this).parent().find('img.next').removeClass('hidden');
				} else {
					$(this).parent().find('img.next').addClass('hidden');
				}
				$('#miniLoadingCircle_month').show();
				monthlyGen(standard);
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
				async: true,
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
				async: true,
				data: {
					sid: siteId,
					formId: 'v2'
				}
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
						const todayEnergy = displayNumberFixedDecimal(siteEnergy['energy'], 'W', 3, 1);

						//금일 발전량
						$('.fcmain-block-s .value-unit span:first-child').eq(0).html(todayEnergy[0]); //금일 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(0).html(todayEnergy[1]); //금일 발전량

						//금일 열 생산량
						$('.fcmain-block-s .value-unit span:first-child').eq(1).html('-') //금일 열 생산량
						$('.fcmain-block-s .value-unit span:last-child').eq(1).html('') //금일 열 생산량
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
						const yesterdayEnergy = displayNumberFixedDecimal(siteEnergy[0]['items'][0]['energy'], 'W', 3, 1);

						//전일 발전량
						$('.fcmain-block-s .value-unit span:first-child').eq(2).html(yesterdayEnergy[0]) //전일 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(2).html(yesterdayEnergy[1]) //전일 발전량

						//전일 열 생산량
						$('.fcmain-block-s .value-unit span:first-child').eq(3).html('-') //전일 열 생성량
						$('.fcmain-block-s .value-unit span:last-child').eq(3).html('') //전일 열 생성량
					}
				} else {
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
							, realTimeGas = displayNumberFixedDecimal(rspns['INV_FC']['gasUsage'], 'Nm3/hr', 3, 1)
							, realTimeActive = displayNumberFixedDecimal(rspns['INV_FC']['activePower'], 'W', 3, 1)
							, realTimeHeat = displayNumberFixedDecimal(rspns['INV_FC']['heatPower'], 'W', 3, 1);

						$('.fcmain-block-s .value-unit span:first-child').eq(4).html(energy[0]) //누적 발전량
						$('.fcmain-block-s .value-unit span:last-child').eq(4).html(energy[1]) //누적 발전량

						$('.fcmain-block-s .value-unit span:first-child').eq(5).html(heat[0]) //누적 열 생성량
						$('.fcmain-block-s .value-unit span:last-child').eq(5).html(heat[1]) //누적 열 생성량

						$('#realTimeGas span:first-child').text(realTimeGas[0]).next().text(realTimeGas[1]);
						$('#realTimeActive span:first-child').text(realTimeActive[0]).next().text(realTimeActive[1]);
						$('#realTimeHeat span:first-child').text(realTimeHeat[0]).next().text(realTimeHeat[1]);
					}
				}
			})
		}).catch(error => {
			console.error(error);
		});
	}

	//실시간 운영정보
	const realTimeOperationInfo = () => {

	}

	//금일 발전현황
	const todayGen = (standard) => {

	}

	//월별 발전량 종합
	const monthlyGen = (standard) => {
		let monthlyDate = new Date();
		let yearData = getSiteMainSchCollection('year');

		let startTime = '', endTime = '';
		if (standard != undefined && (monthlyDate.getFullYear() != standard.getFullYear())) {
			$('#monthlyChart').parent().find('.title span.term span').text(standard.getFullYear() + '.01.01 ~ ' + standard.getFullYear() + '.12.31').data('standard', standard);
			startTime = Number(standard.getFullYear() + '0101000000'), endTime = Number(standard.getFullYear() + '1231235959');
		} else {
			$('#monthlyChart').parent().find('.title span.term span').text(monthlyDate.getFullYear() + '.01.01 ~ ' + monthlyDate.format('yyyy.MM.dd')).data('standard', monthlyDate);
			startTime = Number(yearData.startTime), endTime = Number(yearData.endTime);
		}

		const targetApi = [
			$.ajax({
				url: apiHost + apiEnergySite,
				type: 'get',
				data: {
					sid: siteId,
					startTime: startTime,
					endTime: endTime,
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
			})
		];

		new Promise(resolve => {
			resolve(Promise.all(targetApi));
		}).then(response => {
			const monathlyGenData = new Array(12).fill(0);
			const monathlyMoneyData = new Array(12).fill(0);
			let yearGen = null;

			response.forEach((rspns, index) => {
				if (index === 0) {
					if (!isEmpty(rspns['data'])) {
						const siteData = rspns['data'][siteId][0];
						(siteData.items).forEach(item => {
							const baseTime = item['basetime']
								, targetMonth = Number(String(baseTime).substr(4, 2)) - 1
								, energyData = item['energy'];
							yearGen = Number(yearGen) + energyData;
							monathlyGenData[targetMonth] = energyData;
						});
					}
				} else {
					const siteData = rspns['data'][siteId]
						, nowEnergyData = siteData['energy']
						, capacity = sList[0]['capacities']['gen']
						, refinedData = displayNumberFixedDecimal(nowEnergyData, 'Wh', 3, 1)
						, refinedHour = nowEnergyData / capacity / monthlyDate.getDate();

					yearGen = Number(yearGen) + nowEnergyData;
					monathlyGenData[monthlyDate.getMonth()] = nowEnergyData;

					$('#monthEnergy').text(refinedData[0]).next().html(refinedData[1]);
					if(isFinite(refinedHour)) {
						let f1 = d3.format(',.1f');
						$('#monthHours').text(f1(refinedHour));
					} else {
						$('#monthHours').text('-');
					}
				}
			});

			if (isEmpty(yearGen)) {
				$('#yearEnergy').text('-').next().html('');
			} else {
				const refinedYearData = displayNumberFixedDecimal(yearGen, 'Wh', 3, 1);
				$('#yearEnergy').text(refinedYearData[0]).next().html(refinedYearData[1]);
			}

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
				// let alarmEl = $('.indiv[data-alarm]');
				// alarmEl.attr('data-alarm', '');
				// $('#alarmNotice').empty();

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

	const hourlyChart = Highcharts.chart('hourlyChart', {
		chart: {
			marginTop: 50,
			marginLeft: 50,
			marginRight: 10,
			height: 301,
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
			tickInterval: 1,
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
					x: 13,
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
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 3) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
					x: -5,
					style: {
						color: 'var(--grey)',
						fontSize: '11px'
					}
				}
			}, {}
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
	<c:choose>
		<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				name: '<fmt:message key="smain.generationResults" />',
		</c:when>
		<c:otherwise>
				name: '<fmt:message key='smain.PVGeneratedAmount' />',
		</c:otherwise>
	</c:choose>
				color: 'var(--turquoise)', /* PV발전량 */
				tooltip: {
					valueSuffix: 'kWh',
				},
				data: []
			},
			{
				type: 'spline',
				dashStyle: 'ShortDash',
	<c:choose>
		<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				name: '<fmt:message key="smain.devTime" />',
		</c:when>
		<c:otherwise>
				name: '<fmt:message key="smain.devTime" />',
		</c:otherwise>
	</c:choose>
				color: 'var(--turquoise)',
				tooltip: {
					valueSuffix: 'H',
				},
				marker: {
					symbol: 'circle'
				},
				yAxis: 1,
				data: []
			},
		],
	});

	var monthlyChart = Highcharts.chart('monthlyChart', {
		chart: {
			marginTop: 60,
			marginLeft: 50,
			marginRight: 40,
			height: 280,
			backgroundColor: 'transparent',
			zoomType: 'xy'
		},
		lang: {
			noData: "<fmt:message key='smain.noSearchData' />"
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
			tickColor: 'var(--grey)',
			gridLineColor: 'var(--white25)',
			plotLines: [{
				color: 'var(--grey)',
				width: 1
			}],
			tickInterval: 1,
			title: {
				text: null
			},
			labels: {
				align: 'center',
				overflow: 'justify',
				rotation: 0,
				y: 25,
				style: {
					color: 'var(--grey)',
					fontSize: '12px'
				}
			},
			categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
			crosshair: true
		}],
		yAxis: [
			{
				showEmpty: false,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [{
					color: 'var(--grey)',
					width: 1
				}],
				gridLineWidth: 1,
				title: {
					text: '',
					align: 'low',
					rotation: 0,
					// x: 15,
					y: 25,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						let suffix = this.chart.yAxis[0].userOptions.title.text;
						if(suffix == "MWh"){
							let length = String(this.value).length;
							if(length >= 7 && length < 10){
								return displayNumberFixedUnit(this.value, 'kWh', suffix, 0)[0];
							} else if(length >= 10){
								return displayNumberFixedUnit(this.value, 'kWh', "Gwh", 0)[0] + "k";
							} else {
								// NOT Mwh BUT longer enough to convert into floating number
								if(length >= 3){
									return displayNumberFixedUnit(this.value, 'kWh', suffix, 0)[0];
								} else {
									return displayNumberFixedUnit(this.value, 'kWh', 'kWh', 0)[0];
								}
							}

						} else {
							return displayNumberFixedUnit(this.value, 'kWh', suffix, 0)[0];
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
			},
			// NOT KPX
			<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			{
				showEmpty: false,
				opposite: true,
				lineColor: 'var(--grey)',
				tickColor: 'var(--grey)',
				gridLineColor: 'var(--white25)',
				gridLineWidth: 1,
				plotLines: [
					{
						color: 'var(--grey)',
						width: 1
					}
				],
				gridLineWidth: 1,
				title: {
					text: '<fmt:message key="smain.1000won" />',
					align: 'low',
					rotation: 0,
					y: 25,
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
				labels: {
					formatter: function () {
						let length = String(this.value).length;
						if (length >= 7) {
							return numberComma(this.value / 1000000) + 'M';
						} else if ( (length >= 4) ){
							return numberComma(this.value / 1000) + 'K';
						} else {
							return numberComma(this.value);
						}
					},
					style: {
						color: 'var(--grey)',
						fontSize: '12px'
					}
				},
			},
			</c:if>
		],
		tooltip: {
			formatter: function () {
				return this.points.reduce(function (s, point) {
					let suffix = point.series.userOptions.tooltip.valueSuffix;
					let val;
					if (suffix.toLowerCase() === "hr"){
						val = displayNumberFixedDecimal(point.y, 'kWh', 'kWh', 2)[0];
					} else {
						val = displayNumberFixedDecimal(point.y, 'kWh', 'kWh', 0)[0];
					}
					return s + '<br/><span style="color:' + point.color + '">\u25CF</span>  ' + point.series.name + ': ' + val + " " + suffix;
				}, '<span style="display:flex; margin-bottom:-10px;"><b>'+(langStatus === "KO" ? this.x+'월' : monthEN[this.x-1])+'</b></span>');

			},
			shared: true,
			useHTML: true,
			borderColor: 'none',
			backgroundColor: 'var(--bg-color)',
			padding: 16,
			style: {
				color: 'var(--white)',
			}
		},
		legend: {
			enabled: true,
			// useHTML: true,
			align: 'right',
			verticalAlign: 'top',
			x: 20,
			y: -10,
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
				borderWidth: 0,
				// TO DO!!!!!!!!!!
				// events: {
				// 	legendItemClick: function(event) {
				// 		var thisSeries = this;
				// 		var index = thisSeries._i;
				// 		var chart = thisSeries.chart;
				// 		// var visibility = this.visible ? 'visible' : 'hidden';

				// 		console.log("thisSeries==", index)
				// 		chart.yAxis[index].
				// 		// if (this.visible === true) {
				// 		// 	this.hide();
				// 		// 	chart.get("highcharts-navigator-series").hide();
				// 		// } else {
				// 		// 	this.show();
				// 		// 	chart.series.forEach(function(el, inx) {
				// 		// 		if (el !== thisSeries) {
				// 		// 		el.hide();
				// 		// 		}
				// 		// 	});
				// 		// 	chart.get("highcharts-navigator-series").setData(thisSeries.options.data, false);
				// 		// 	chart.get("highcharts-navigator-series").show();
				// 		// }
				// 		// event.preventDefault();
				// 	}
				// }
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
		series: [
			{
				<c:choose>
				<c:when test="${fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
				name: '<fmt:message key='smain.generationResults' />',
				</c:when>
				<c:otherwise>
				name: '<fmt:message key='smain.PVGeneratedAmount' />',
				</c:otherwise>
				</c:choose>
				type: 'column',
				color: 'var(--turquoise)',
				data: [],
				tooltip: {
					valueSuffix: 'kWh',
				}

			},
			<c:if test="${!fn:contains(sessionScope.userInfo.oid, 'testkpx')}">
			{
				name: '<fmt:message key="smain.irradiance" />',
				type: 'spline',
				dashStyle: 'ShortDash',
				color: 'var(--white60)',
				yAxis: 1,
				data: [],
				tooltip: {
					valueSuffix: '천원',
				}
			}
			</c:if>
		],
		credits: {
			enabled: false
		},
	});
</script>