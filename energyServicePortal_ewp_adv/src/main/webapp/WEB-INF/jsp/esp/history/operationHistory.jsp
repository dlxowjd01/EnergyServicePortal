<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript">
	var formData = null;
	var recycleYn = true;
	
	const pollingTerm = 1000 * 60 * 15;
	const pollingTimeout = 5000;
	const debugMode = true;

	const apiURL = 'http://iderms.enertalk.com:8443';
	const configSite = '/config/sites';
	const configDevice = '/config/orgs/' + 'spower';
	const forecasting = '​/energy​/forecasting​/sites';

	const configSiteData = {
		oid: 'spower'
	};

	const configDeviceData = {
		includeUsers: false,
		includSites: false,
		includeDevices: true,
		includeBtus: false
	};
	
	const forecastingData = {
		dids: '',
		metering_type: '',
		interval: '',
		isDummy: true
	}

	let devicesList;
	
    const deviceTemplate = [
    	{
    		'code': 'SM',
    		'value': '스마트미터'
    	},
    	{
    		'code': 'SM_ISMART',
    		'value': '한전 아이스마트'
    	},
    	{
    		'code': 'SM_KPX',
    		'value': '전력거래소 계량포털'
    	},
    	{
    		'code': 'SM_CRAWLING',
    		'value': '데이터 수집기'
    	},
    	{
    		'code': 'SM_MANUAL',
    		'value': '수기 입력'
    	},
    	{
    		'code': 'INV_PV',
    		'value': '태양광 인버터'
    	},
    	{
    		'code': 'INV_WIND',
    		'value': '풍력 인버터'
    	},
    	{
    		'code': 'PCS_ESS',
    		'value': 'ESS PCS'
    	},
    	{
    		'code': 'BMS_SYS',
    		'value': 'BMS 시스템'
    	},
    	{
    		'code': 'BMS_RACK',
    		'value': 'BMS 랙'
    	},
    	{
    		'code': 'SENSOR_SOLAR',
    		'value': '태양광 센서'
    	},
    	{
    		'code': 'SENSOR_FRAME',
    		'value': '불꽃 센서'
    	},
    	{
    		'code': 'SENSOR_TEMP_HUMIDITY',
    		'value': '온습도 센서'
    	},
    	{
    		'code': 'CCTV',
    		'value': 'CCTV'
    	},
    ]

	let tableDummy = [
        {
        'basetime': '20200401000000',
        'd1': '인버터#1',
        'd2': 'IVT001',
        'd3': '사업소#1',
        'd4': 'Connect',
        'd5': '20',
        'd6': '10',
        'd7': '20',
        'd8': '180',
        'd9': '400',
        'd10': '20',
        'd11': '20',
        'd12': '20',
        'd13': '1',
        'd14': '62',
        'd15': '35',
        },
        {
        'basetime': '20200401000000',
        'd1': '인버터#1',
        'd2': 'IVT001',
        'd3': '사업소#1',
        'd4': 'Connect',
        'd5': '21',
        'd6': '11',
        'd7': '21',
        'd8': '181',
        'd9': '401',
        'd10': '21',
        'd11': '21',
        'd12': '21',
        'd13': '2',
        'd14': '63',
        'd15': '36',
        },
        {
        'basetime': '20200401000000',
        'd1': '인버터#1',
        'd2': 'IVT001',
        'd3': '사업소#1',
        'd4': 'Connect',
        'd5': '22',
        'd6': '12',
        'd7': '22',
        'd8': '182',
        'd9': '402',
        'd10': '22',
        'd11': '22',
        'd12': '22',
        'd13': '3',
        'd14': '64',
        'd15': '37',
        },
        {
        'basetime': '20200401000000',
        'd1': '인버터#1',
        'd2': 'IVT001',
        'd3': '사업소#1',
        'd4': 'Connect',
        'd5': '23',
        'd6': '13',
        'd7': '23',
        'd8': '183',
        'd9': '403',
        'd10': '23',
        'd11': '23',
        'd12': '23',
        'd13': '4',
        'd14': '65',
        'd15': '38',
        },
        {
        'basetime': '20200401000000',
        'd1': '인버터#1',
        'd2': 'IVT001',
        'd3': '사업소#1',
        'd4': 'Connect',
        'd5': '24',
        'd6': '14',
        'd7': '24',
        'd8': '184',
        'd9': '404',
        'd10': '24',
        'd11': '24',
        'd12': '24',
        'd13': '5',
        'd14': '66',
        'd15': '39',
        },
    ];
	
	var initPage = function() {
		place();
	};

	//사업소 조회 
	var place = function(result) {
		$.ajax({
			url : apiURL + configSite,
			type : 'get',
			async : false,
			data : configSiteData,
			success: function(result) {
				var data = result;
				if(debugMode) {console.log(data);}
				
				$('#place').empty();
				
				if(result.length > 0) {
					for(var i in result) {
						let placeHtml = $('<li>').append('<a>')
						placeHtml.find('a').attr('href', '#').attr('tabindex', '-1');
						placeHtml.find('a').append('<input id="sid_' + i + '" type="checkbox" name="sid" value="' + result[i].sid + '">').append('<label>');
						placeHtml.find('label').attr('for', 'sid_'+ i).append('<span>').append('&nbsp;'+data[i].name);
						$('#place').append(placeHtml);
					}
				} else {
					let placeHtml = $('<li>').html('조회된 사업소가 없습니다');
					$('#place').append(placeHtml);
					$('#place').before('button').find('div.caret').prepend('선택해주세요.');
				}
			},
            dataType: "json"
        });
	};

	//선택한 SID에 해당하는 유형의 타입을 보여준다.
	var deviceType = function() {
// 		$.ajax({
//             url : apiURL + configDevice,
//             type : 'get',
//             async : false,
//             data : configDeviceData,
//             success: function(result) {
//                 var devicesList = result.devices;
//                 if(debugMode) {console.log(devicesList);}

//                 $('#device').empty();

//                 let deviceType = new Array();
//                 if(devicesList.length > 0) {
//                 	//선택된 사이트를 체크한다.
//                 	var list = '';
//                 	$(':checkbox[name="sid"]:checked').each(function() {
//                 		for(var i in devicesList) {
//                             if(devicesList[i].sid == $(this).val()) {
//                             	if(list != '') {
//                             		if(!(devicesList[i].device_type.test(list))) {
// 	                            		list += ',' + devicesList[i].device_type;
//                             		}
//                             	} else {
//                             		list += devicesList[i].device_type;
//                             	}
//                             }
//                         }
//                 	});

//                 	if(/,/.test(list)) {
//                 		deviceType = list.split(',');
//                 	} else {
// 	                	deviceType.push(list)
//                 	}

//                 	for(var i in deviceType) {
//                 		)
//                 	}
//                 } else {
//                 	let deviceHtml = $('<li>').append('<a>').data('value', '').attr('href', '#').html('조회된 설비가 없습니다.');
//                     $('#device').append(deviceHtml);
//                     $('#device').before('button').empty().append('선택해주세요.').append('<span class="caret"></span>');
//                 }
//             },
//             dataType: "json"
//         });
		device();
	};

	//설비타입 디바이스타입 설정한다.
	var device = function() {
		$.ajax({
            url : apiURL + configDevice,
            type : 'get',
            async : false,
            data : configDeviceData,
            success: function(result) {
                var data = result.devices;
                if(debugMode) {console.log(data);}

                $('#device>li>div.sec_li_bx').remove();

                if(data.length > 0) {
                	
                	//선택된 사이트를 기준으로 한다.
                    $(':checkbox[name="sid"]:checked').each(function() {
                    	var siteNm = $(this).next().text()
                    	  , siteId = $(this).val()
                    	  , siteGrp = $('<div>').addClass('sec_li_bx');
                    	
                    	siteGrp.append('<p>');
                    	siteGrp.find('p').addClass('tx_li_tit').text(siteNm);
                        siteGrp.append('<ul>');
                    	
                        for(var i in data) {
                            if(data[i].sid == siteId) {
                                let deviceHtml = $('<li>').append('<a>');
                                deviceHtml.find('a').attr('href', '#').attr('tabindex', '-1');
                                deviceHtml.find('a').append('<input id="device_' + i + '" type="checkbox" value="' + data[i].did + '">').append('<label>');
                                deviceHtml.find('label').attr('for', 'device_'+ i).append('<span>').append('&nbsp;'+data[i].name);
                                
                                siteGrp.find('ul').append(deviceHtml);
                            }
                        }
                        $('#device>li').prepend(siteGrp);
                    });
                	
                    
                } else {
                    let deviceHtml = $('<li>').append('<a>').data('value', '').attr('href', '#').html('조회된 설비가 없습니다.');
                    $('#device').append(deviceHtml);
                    $('#device').before('button').empty().append('선택해주세요.').append('<span class="caret"></span>');
                }
            },
            dataType: "json"
        });
	}

	var searchGrid = function() {
		$('.his_tbl tbody').empty();
// 		$.ajax({
//             url : apiURL + configDevice,
//             type : 'get',
//             async : false,
//             data : configDeviceData,
//             success: function(result) {
//                 var data = result.devices;
//                 if(debugMode) {console.log(data);}
                
//                 $('#device').empty();
                
//                 if(data.length > 0) {
//                     for(var i in data) {
//                         if(data[i].sid == $('#place').prev('button').data('sid')) {
//                             let deviceHtml = $('<li>').append('<a>');
//                             deviceHtml.find('a').attr('href', '#').data('value', data[i].did);
//                             deviceHtml.find('a').append('<input id="device_' + i + '" type="checkbox">').append('<label>');
//                             deviceHtml.find('label').attr('for', 'device_'+ i).append('&nbsp;'+data[i].name);
//                             $('#device').append(deviceHtml);
//                         }
//                     }
//                 } else {
//                     let deviceHtml = $('<li>').append('<a>').data('value', '').attr('href', '#').html('조회된 설비가 없습니다.');
//                     $('#device').append(deviceHtml);
//                     $('#device').before('button').empty().append('선택해주세요.').append('<span class="caret"></span>');
//                 }
//             },
//             dataType: "json",
//             complete: '',
//             timeout: pollingTimeout
//         });
		tableGrid();
	};

	var tableGrid = function() {
		
		$('.his_tbl tbody').empty();
		
		for(var i in tableDummy) {
           let dummyHtml = $('<tr>')
           dummyHtml.append('<td>' + tableDummy[i].basetime + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d1 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d2 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d3 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d4 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d5 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d6 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d7 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d8 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d9 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d10 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d11 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d12 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d13 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d14 + '</td>');
           dummyHtml.append('<td>' + tableDummy[i].d15 + '</td>');
           
           $('.his_tbl tbody').append(dummyHtml);
       }
	}
	
	$(function() {
		initPage();

		//사업소 선택
		$(document).on('click', '#place a', function(e) {
			e.preventDefault();
			if($(this).find('input').is(':checked') == true) {
				$(this).find('input').prop('checked', false);
			} else {
// 				$(this).parents('ul').prev('button').empty().append($(this).find('label').text()).append('<span class="caret"></span>');
				$(this).find('input').prop('checked', true);
			}
			
			//총 체크한 갯수를 확인한다.
            if($(':checkbox[name="sid"]:checked').length <= 0) {
                $(this).parents('ul').prev('button').empty().append('선택해주세요.').append('<span class="caret"></span>');
            } else {
                let extendText = '';
                if($(':checkbox[name="sid"]:checked').length > 1) {
                    extendText = '외 ' + Number($(':checkbox[name="sid"]:checked').length - 1) + '개';
                }
                //첫 번째 값 + 외 몇개로 표기
                $(this).parents('ul').prev('button').empty().append($(':checkbox[name="sid"]:checked').eq(0).next('label').text() + '&nbsp;' + extendText).append('<span class="caret"></span>');
                deviceType();
            }
		});

		//기간 선택
        $(document).on('click', '#term a', function(e) {
        	e.preventDefault();
            $(this).parents('ul').prev('button').data('value', $(this).data('value')).empty().append($(this).html()).append('<span class="caret"></span>');
            device();
        });
		
		//검색
		$('#search').on('click', function() {
			searchGrid();
		});

		//헤더 클릭
		$('.his_tbl thead th').on('click', function(e) {
			e.preventDefault();
			var idx = $('.his_tbl thead th').index($(this))
			  , order = $(this).data('order')
			  , column = $(this).data('column');
			if(idx > 3 && idx < 16) {
				$('.his_tbl thead th button').removeClass('up').removeClass('down');
				if(order == undefined || order == null || order == '') {
					tableDummy.sort(function(a, b) {
					    return a[column] - b[column];
				    });
					$(this).data('order', 'up');
					$(this).find('button').addClass('up');
				} else if(order == 'up') {
					tableDummy.sort(function(a, b) {
					    return b[column] - a[column];
				    });
					$(this).data('order', 'down');
					$(this).find('button').addClass('down');
				} else {
					tableDummy.sort(function(a, b) {
						return a[column] - b[column];
				    });
					$(this).data('order', 'up');
					$(this).find('button').addClass('up');
				}

				tableGrid();
			}
		});

		//사이트 선택전까지 클릭 방지
		$('#type').prev('button').on('click', function(e) {
			if($(':checkbox[name="sid"]:checked').length <= 0) {
				e.stopPropagation();
			}
		});

		//사이트 선택전까지 클릭 방지
		$('#device').prev('button').on('click', function(e) {
			if($(':checkbox[name="sid"]:checked').length <= 0) {
                e.stopPropagation();
            }
        });

		$('#device button.btn_type03').on('click', function(e) {
			var idx = $('#device button.btn_type03').index($(this));

			if(idx == 0) {
				$('[id^="device_"]').prop('checked', true);
			} else {
				$('[id^="device_"]').prop('checked', false);
			}
		});

		$('#datepicker1').datepicker('setDate', 'today'); //데이트 피커 기본
		$('#datepicker2').datepicker('setDate', 'today'); //데이트 피커 기본
	});
	
</script>

<div class="col-lg-12">
  <div class="row">
    <div class="col-lg-12">
      <h1 class="page-header">운전 이력</h1>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="row">
        <div class="indiv his_chart_top clear">
            <div class="sa_select fl">
                <div class="dropdown">
                <button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">선택해주세요.
                  <span class="caret"></span>
                </button>
                <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="place">
                </ul>
          </div>
        </div>
        <div class="fl">
          <span class="tx_tit">설비 타입</span>
          <div class="sa_select">
            <div class="dropdown">
              <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">전체
                <span class="caret"></span>
              </button>
              <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="type">
                <li>
                   <a href="#" tabindex="-1">
                       <input type="checkbox" id="type_1" value="INV_PV" >
                       <label for="type_1"><span></span>태양광 인버터</label>
                   </a>
               </li>
              </ul>
            </div>
          </div>
          <div class="sa_select">
            <div class="dropdown">
              <button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">복수 선택
                <span class="caret"></span>
              </button>
              <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu" id="device">
                <li class="dropdown_cov clear">
                            <div class="sec_li_bx">
                                <p class="tx_li_tit">사업소#1</p>
                                <ul>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op01" value="인버터#1">
                                            <label for="chk_op01"><span></span>인버터#1</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op02" value="인버터#2">
                                            <label for="chk_op02"><span></span>인버터#2</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op03" value="인버터#3">
                                            <label for="chk_op03"><span></span>인버터#3</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op04" value="인버터#4">
                                            <label for="chk_op04"><span></span>인버터#4</label>
                                        </a>
                                    </li>
                                <ul>
                            </div>
                            <div class="sec_li_bx">
                                <p class="tx_li_tit">사업소#2</p>
                                <ul>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op011" value="인버터#1">
                                            <label for="chk_op011"><span></span>인버터#1</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op022" value="인버터#2">
                                            <label for="chk_op022"><span></span>인버터#2</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op033" value="인버터#3">
                                            <label for="chk_op033"><span></span>인버터#3</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chk_op044" value="인버터#4">
                                            <label for="chk_op044"><span></span>인버터#4</label>
                                        </a>
                                    </li>
                                <ul>
                            </div>
                            <div class="li_btn_bx clear">
                                <div class="fl">
                                    <button type="button" class="btn_type03">모두 선택</button>
                                    <button type="button" class="btn_type03">모두 해제</button>
                                </div>
                                <div class="fr"><button type="button" class="btn_type">적용</button></div>
                            </div>
                        </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="fl">
           <span class="tx_tit">기간 설정</span>
           <div class="sel_calendar">
             <input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
             <em>-</em>
             <input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
           </div>
       </div>
        
        <div class="fl">
          <span>조회기간</span>
          <div class="sa_select">
            <div class="dropdown">
              <button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">15분
                <span class="caret"></span></button>
              <ul class="dropdown-menu" id="term">
                <li><a href="#" data-value="1">1분</a></li>
                <li class="on"><a href="#" data-value="15">15분</a></li>
                <li><a href="#" data-value="hour">1시간</a></li>
                <li><a href="#" data-value="day">1일</a></li>
                <li><a href="#" data-value="week">1주</a></li>
                <li><a href="#" data-value="month">1월</a></li>
              </ul>
            </div>
          </div>
        </div>
        <div class="fl">
          <button type="button" id="search" class="btn_type">조회</button>
        </div>
        <div class="fr">
          <a href="#;" class="save_btn">데이터저장</a>
        </div>
      </div>
		<div class="row">
		  <div class="indiv his_chart_top clear">
			<div class="sa_select fl">
			  <div class="dropdown">
				<button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">사업소#1
				  <span class="caret"></span></button>
				<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
				    <li class="on">
						<a href="#" data-value="option1" tabindex="-1"> 
							<input type="checkbox" id="deviceStatus1" value="전체" checked>
							<label for="deviceStatus1"><span></span>전체</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option2" tabindex="-1">
							<input type="checkbox" id="deviceStatus2" value="사업소#1" checked>
							<label for="deviceStatus2"><span></span>사업소#1</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option3" tabindex="-1">
							<input type="checkbox" id="deviceStatus3" value="사업소#2">
							<label for="deviceStatus3"><span></span>사업소#2</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option4" tabindex="-1">
							<input type="checkbox" id="deviceStatus4" value="사업소#3">
							<label for="deviceStatus4"><span></span>사업소#3</label>
						</a>
					</li>
				</ul>
			  </div>
			</div>
			<div class="fl">
			  <span class="tx_tit">설비 타입</span>
			  <div class="sa_select">
				<div class="dropdown">
				  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
					<span class="caret"></span></button>
				  <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
					<li>
						<a href="#" data-value="option1" tabindex="-1">
							<input type="checkbox" id="sel2_1" value="인버터">
							<label for="sel2_1"><span></span>인버터</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option2" tabindex="-1">
							<input type="checkbox" id="sel2_2" value="접속반" checked>
							<label for="sel2_2"><span></span>접속반</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option3" tabindex="-1">
							<input type="checkbox" id="sel2_3" value="차단기">
							<label for="sel2_3"><span></span>차단기</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option4" tabindex="-1">
							<input type="checkbox" id="sel2_4" value="계량기" checked>
							<label for="sel2_4"><span></span>계량기</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option5" tabindex="-1">
							<input type="checkbox" id="sel2_5" value="기상센서">
							<label for="sel2_5"><span></span>기상센서</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option6" tabindex="-1">
							<input type="checkbox" id="sel2_6" value="기상청 기상정보">
							<label for="sel2_6"><span></span>기상청 기상정보</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option7" tabindex="-1">
							<input type="checkbox" id="sel2_7" value="한전 iSmart">
							<label for="sel2_7"><span></span>한전 iSmart</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option8" tabindex="-1">
							<input type="checkbox" id="sel2_8" value="KPX계량포털">
							<label for="sel2_8"><span></span>KPX계량포털</label>
						</a>
					</li>
					<li>
						<a href="#" data-value="option9" tabindex="-1">
							<input type="checkbox" id="sel2_9" value="CCTV">
							<label for="sel2_9"><span></span>CCTV</label>
						</a>
					</li>
				  </ul>
				</div>
			  </div>
			   <div class="sa_select">
				<div class="dropdown">
				  <button class="btn btn-primary dropdown-toggle w1" type="button" data-toggle="dropdown">복수 선택
					<span class="caret"></span></button>
					<ul class="dropdown-menu dropdown-menu-form chk_type">
						<li class="dropdown_cov clear">
							<div class="sec_li_bx">
								<p class="tx_li_tit">사업소#1</p>
								<ul>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op01" value="인버터#1">
											<label for="chk_op01"><span></span>인버터#1</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op02" value="인버터#2">
											<label for="chk_op02"><span></span>인버터#2</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op03" value="인버터#3">
											<label for="chk_op03"><span></span>인버터#3</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op04" value="인버터#4">
											<label for="chk_op04"><span></span>인버터#4</label>
										</a>
									</li>
								<ul>
							</div>
							<div class="sec_li_bx">
								<p class="tx_li_tit">사업소#2</p>
								<ul>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op011" value="인버터#1">
											<label for="chk_op011"><span></span>인버터#1</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op022" value="인버터#2">
											<label for="chk_op022"><span></span>인버터#2</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op033" value="인버터#3">
											<label for="chk_op033"><span></span>인버터#3</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chk_op044" value="인버터#4">
											<label for="chk_op044"><span></span>인버터#4</label>
										</a>
									</li>
								<ul>
							</div>
							<div class="li_btn_bx clear">
								<div class="fl">
									<button type="submit" class="btn_type03">모두 선택</button>
									<button type="submit" class="btn_type03">모두 해제</button>
								</div>
								<div class="fr"><button type="submit" class="btn_type">적용</button></div>
							</div>
						</li>
					</ul>
				</div>
			  </div>
			</div>
			<div class="fl">
				<span class="tx_tit">기간 설정</span>
				<div class="sel_calendar">
				  <input type="text" id="datepicker1" class="sel" value="" autocomplete="off">
				  <em>-</em>
				  <input type="text" id="datepicker2" class="sel" value="" autocomplete="off">
				</div>
			</div>
			
			<div class="fl">
			  <div class="sa_select">
				<div class="dropdown">
				  <button class="btn btn-primary dropdown-toggle w3" type="button" data-toggle="dropdown">15분
					<span class="caret"></span></button>
				  <ul class="dropdown-menu">
					<li class="on"><a href="#">15분</a></li>
					<li><a href="#">30분</a></li>
					<li><a href="#">1시간</a></li>
					<li><a href="#">1일</a></li>
					<li><a href="#">1월</a></li>
				  </ul>
				</div>
			  </div>
			</div>
			<div class="fl"><button type="submit" class="btn_type">조회</button></div>
			<div class="fr">
			  <a href="#;" class="save_btn">데이터저장</a>
			</div>
		  </div>
		</div>
    </div>
  </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="row">
      <div class="indiv">
        <div class="his_chart_top clear">
            <div class="clear">
                <h2 class="fl s_tit">분석 기준 설비 선택</h2>
                <a href="#" class="btn_type02 fr">분석 조건 저장</a>
            </div>
            <!-- 기본 항목 -->
                <div class="clear">
                    <div class="fl">
                      <div class="sa_select">
                        <div class="dropdown">
                          <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">사이트명
                            <span class="caret"></span></button>
                          <ul class="dropdown-menu">
                            <li class="on"><a href="#">사이트명</a></li>
                            <li><a href="#">사이트명</a></li>
                            <li><a href="#">사이트명</a></li>
                            <li><a href="#">사이트명</a></li>
                            <li><a href="#">사이트명</a></li>
                          </ul>
                        </div>
                      </div>
                      <div class="sa_select">
                        <div class="dropdown">
                          <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
                            <span class="caret"></span></button>
                            <ul class="dropdown-menu dropdown-menu-form rdo_type" role="menu">
                                <li>
                                    <a href="#" data-value="option1" tabindex="-1">
                                        <input type="radio" id="rdo01" name="rdo_btn" value="DC 전압">
                                        <label for="rdo01"><span></span>DC 전압</label>
                                    </a>
                                </li>
                                <li>
                                    <a href="#" data-value="option2" tabindex="-1">
                                        <input type="radio" id="rdo02" name="rdo_btn" value="DC 전류">
                                        <label for="rdo02"><span></span>DC 전류</label>
                                    </a>
                                </li>
                            </ul>
                        </div>
                      </div>
                       <div class="sa_select">
                        <div class="dropdown">
                          <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">최대
                            <span class="caret"></span></button>
                            <ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
                                <li>
                                    <a href="#" data-value="option1" tabindex="-1">
                                        <input type="radio" id="rdo01_1" name="rdo_btn2" value="최대">
                                        <label for="rdo01_1"><span></span>최대</label>
                                    </a>
                                </li>
                                <li>
                                    <a href="#" data-value="option2" tabindex="-1">
                                        <input type="radio" id="rdo01_2" name="rdo_btn2" value="최소">
                                        <label for="rdo01_2"><span></span>최소</label>
                                    </a>
                                </li>
                                <li>
                                    <a href="#" data-value="option2" tabindex="-1">
                                        <input type="radio" id="rdo01_3" name="rdo_btn2" value="평균">
                                        <label for="rdo01_3"><span></span>평균</label>
                                    </a>
                                </li>
                            </ul>
                        </div>
                      </div>
                       <div class="sa_select">
                        <div class="dropdown">
                          <button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">y-좌
                            <span class="caret"></span></button>
                          <ul class="dropdown-menu">
                            <li class="on"><a href="#">y-좌</a></li>
                            <li><a href="#">y-우</a></li>
                          </ul>
                        </div>
                      </div>
                    </div>
                    
                    <!-- 버튼 -->
                    <div class="fl">
                      <button type="button" class="btn_type">그래프 항목 추가</button>
                      <button type="button" class="btn_type">그래프 그리기</button>
                    </div>
                    
                    <!-- 우측 항목 -->
                    <div class="fr his_inp_bx">
                        <div class="rdo_type his_rdo_bx">
                            <span>
                                <input type="radio" id="rdo03_1" name="rdo_btn22" value="시계열 분석" checked>
                                <label for="rdo03_1"><span></span>시계열 분석</label>
                            </span>
                            <span>
                                <input type="radio" id="rdo03_2" name="rdo_btn22" value="상관 분석">
                                <label for="rdo03_2"><span></span>상관 분석</label>
                            </span>
                        </div>
                        
                        <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w6" type="button" data-toggle="dropdown">사이트별 누적
                                <span class="caret"></span></button>
                                <ul class="dropdown-menu rdo_type">
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="radio" id="rdo04_1" name="rdo_btn33" value="사이트별 누적">
                                            <label for="rdo04_1"><span></span>사이트별 누적</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="radio" id="rdo04_2" name="rdo_btn33" value="사이트별 평균">
                                            <label for="rdo04_2"><span></span>사이트별 평균</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option3" tabindex="-1">
                                            <input type="radio" id="rdo04_3" name="rdo_btn33" value="설비별 누적">
                                            <label for="rdo04_3"><span></span>설비별 누적</label>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                      </div>
                    </div>
                </div>
                
                <br>
                <!-- x축 y축 -->
                <div class="clear" style="display:none;">
                    <div class="fl">
                        <span class="tx_tit">x축</span>
                        <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
                                <span class="caret"></span></button>
                              <ul class="dropdown-menu">
                                <li class="on"><a href="#">인버터#1</a></li>
                                <li><a href="#">인버터#2</a></li>
                                <li><a href="#">인버터#3</a></li>
                                <li><a href="#">인버터#4</a></li>
                                <li><a href="#">인버터#5</a></li>
                              </ul>
                            </div>
                          </div>
                          <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
                                <span class="caret"></span></button>
                                <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chktype11" value="DC 전압">
                                            <label for="chktype11"><span></span>DC 전압</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="checkbox" id="chktype12" value="DC 전류">
                                            <label for="chktype12"><span></span>DC 전류</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option3" tabindex="-1">
                                            <input type="checkbox" id="chktype13" value="DC 전력">
                                            <label for="chktype13"><span></span>DC 전력</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option4" tabindex="-1">
                                            <input type="checkbox" id="chktype14" value="금일 발전량">
                                            <label for="chktype14"><span></span>금일 발전량</label>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                          </div>
                           <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">평균
                                <span class="caret"></span></button>
                                <ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="radio" id="rdo04_1" name="rdo_btn5" value="최대">
                                            <label for="rdo04_1"><span></span>최대</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="radio" id="rdo04_2" name="rdo_btn5" value="최소">
                                            <label for="rdo04_2"><span></span>최소</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="radio" id="rdo04_3" name="rdo_btn5" value="평균">
                                            <label for="rdo04_3"><span></span>평균</label>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                          </div>
                    </div>
                    
                    <div class="fl">
                        <span class="tx_tit">y축</span>
                        <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
                                <span class="caret"></span></button>
                              <ul class="dropdown-menu">
                                <li class="on"><a href="#">인버터#1</a></li>
                                <li><a href="#">인버터#2</a></li>
                                <li><a href="#">인버터#3</a></li>
                                <li><a href="#">인버터#4</a></li>
                                <li><a href="#">인버터#5</a></li>
                              </ul>
                            </div>
                          </div>
                          <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
                                <span class="caret"></span></button>
                                <ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="checkbox" id="chktype21" value="DC 전압">
                                            <label for="chktype21"><span></span>DC 전압</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="checkbox" id="chktype22" value="DC 전류">
                                            <label for="chktype22"><span></span>DC 전류</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option3" tabindex="-1">
                                            <input type="checkbox" id="chktype23" value="DC 전력">
                                            <label for="chktype23"><span></span>DC 전력</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option4" tabindex="-1">
                                            <input type="checkbox" id="chktype24" value="금일 발전량">
                                            <label for="chktype24"><span></span>금일 발전량</label>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                          </div>
                           <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">평균
                                <span class="caret"></span></button>
                                <ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="radio" id="rdo05_1" name="rdo_btn6" value="최대">
                                            <label for="rdo05_1"><span></span>최대</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="radio" id="rdo05_2" name="rdo_btn6" value="최소">
                                            <label for="rdo05_2"><span></span>최소</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="radio" id="rdo05_3" name="rdo_btn6" value="평균">
                                            <label for="rdo05_3"><span></span>평균</label>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                          </div>
                    </div>
                    
                    <!-- 버튼 -->
                    <div class="fl">
                      <button type="button" class="btn_type">그래프 항목 추가</button>
                      <button type="button" class="btn_type">그래프 그리기</button>
                    </div>
                    
                    <!-- 우측 항목 -->
                    <div class="fr his_inp_bx">
                        <div class="rdo_type his_rdo_bx">
                            <span>
                                <input type="radio" id="rdo03_1" name="rdo_btn22" value="시계열 분석">
                                <label for="rdo03_1"><span></span>시계열 분석</label>
                            </span>
                            <span>
                                <input type="radio" id="rdo03_2" name="rdo_btn22" value="상관 분석">
                                <label for="rdo03_2"><span></span>상관 분석</label>
                            </span>
                        </div>
                        
                        <div class="sa_select">
                            <div class="dropdown">
                              <button class="btn btn-primary dropdown-toggle w6" type="button" data-toggle="dropdown">사이트별 누적
                                <span class="caret"></span></button>
                                <ul class="dropdown-menu rdo_type">
                                    <li>
                                        <a href="#" data-value="option1" tabindex="-1">
                                            <input type="radio" id="rdo04_1" name="rdo_btn33" value="사이트별 누적">
                                            <label for="rdo04_1"><span></span>사이트별 누적</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option2" tabindex="-1">
                                            <input type="radio" id="rdo04_2" name="rdo_btn33" value="사이트별 평균">
                                            <label for="rdo04_2"><span></span>사이트별 평균</label>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#" data-value="option3" tabindex="-1">
                                            <input type="radio" id="rdo04_3" name="rdo_btn33" value="설비별 누적">
                                            <label for="rdo04_3"><span></span>설비별 누적</label>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                      </div>
                    </div>
                </div>
                
                <!-- x,y축 태그 -->
                <div class="tag_bx clear">
                    <div class="fl">
                        <span class="tx_tit">y-좌</span>
                        <span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
                        <span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
                        <span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
                        <span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
                    </div>
                    <div class="fl">
                        <span class="tx_tit">y-우</span>
                        <span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
                        <span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
                        <span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
                    </div>
                </div>
            </div>
            <br>
            <br>
        <div class="inchart">
          <div id="hchart2"></div>
          <script type="text/javascript">
            $(function () {
              var myChart = Highcharts.chart('hchart2', {
                data: {
                  table: 'datatable' /* 테이블에서 데이터 불러오기 */
                },
                
                chart: {
                  marginLeft: 80,
                  marginRight: 0,
                  backgroundColor: 'transparent',
                  type: 'column'
                },
                
                navigation: {
                  buttonOptions: {
                    enabled: false /* 메뉴 안보이기 */
                  }
                },
                
                title: {
                  text: ''
                },
                
                subtitle: {
                  text: ''
                },
                
                xAxis: {
                  labels: {
                    align: 'center',
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  },
                  tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
                  title: {
                    text: null
                  },
                  crosshair: true /* 포커스 선 */
                },
                
                yAxis: {
                  gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
                  min: 0, /* 최소값 지정 */
                  title: {
                    text: '(kWh)',
                    align: 'low',
                    rotation: 0, /* 타이틀 기울기 */
                    y: 25, /* 타이틀 위치 조정 */
                    x: 5, /* 타이틀 위치 조정 */
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  },
                  labels: {
                    overflow: 'justify',
                    x: -20, /* 그래프와의 거리 조정 */
                    style: {
                      color: '#3d4250',
                      fontSize: '14px'
                    }
                  }
                },
                
                /* 범례 */
                legend: {
                  enabled: true,
                  align: 'right',
                  verticalAlign: 'top',
                  x: 10,
                  itemStyle: {
                    color: '#3d4250',
                    fontSize: '14px',
                    fontWeight: 400
                  },
                  itemHoverStyle: {
                    color: '' /* 마우스 오버시 색 */
                  },
                  symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
                  symbolHeight: 8 /* 심볼 크기 */
                },
                
                /* 툴팁 */
                tooltip: {
                  shared: true /* 툴팁 공유 */
                },
                
                /* 옵션 */
                plotOptions: {
                  series: {
                    label: {
                      connectorAllowed: false
                    },
                    borderWidth: 0 /* 보더 0 */
                  },
                  line: {
                    marker: {
                      enabled: false /* 마커 안보이기 */
                    }
                  },
                  column: {
                    stacking: 'normal'
                  }
                },
                
                /* 출처 */
                credits: {
                  enabled: false
                },
                
                /* 그래프 스타일 */
                series: [{
                  name: '인버터#1 금일발전량',
                  type: 'column',
                  stack: 'male',
                  color: '#6b41ba',
                  tooltip: {
                    valueSuffix: 'kWh'
                  }
                }, {
                  name: '인버터#7 금일발전량',
                  type: 'column',
                  stack: 'male',
                  color: '#7571f9',
                  tooltip: {
                    valueSuffix: 'kWh'
                  }
                }
                  , {
                    name: '인버터#11 금일발전량',
                    type: 'column',
                    stack: 'male',
                    color: '#abb4fa',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }
                  , {
                    name: '인버터#1 누적발전량',
                    type: 'column',
                    stack: 'female',
                    color: '#007bff',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }, {
                    name: '인버터#7 누적발전량',
                    type: 'column',
                    stack: 'female',
                    color: '#3485db',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }
                  , {
                    name: '인버터#11 누적발전량',
                    type: 'column',
                    stack: 'female',
                    color: '#73a2d5',
                    tooltip: {
                      valueSuffix: 'kWh'
                    }
                  }]
                
              });
            });
          </script>
        </div>
        <!-- 데이터 추출용 -->
        <div class="chart_table2" style="display:none;">
          <table id="datatable">
            <thead>
              <tr>
                <th>2018-08</th>
                <th>인버터#1 금일발전량</th>
                <th>인버터#7 금일발전량</th>
                <th>인버터#11 금일발전량</th>
                <th>인버터#1 누적발전량</th>
                <th>인버터#7 누적발전량</th>
                <th>인버터#11 누적발전량</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th>1</th>
                <td>300</td>
                <td>400</td>
                <td>300</td>
                <td>200</td>
                <td>150</td>
                <td>300</td>
              </tr>
              <tr>
                <th>2</th>
                <td>300</td>
                <td>300</td>
                <td>300</td>
                <td>200</td>
                <td>200</td>
                <td>150</td>
              </tr>
              <tr>
                <th>3</th>
                <td>540</td>
                <td>350</td>
                <td>300</td>
                <td>250</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>4</th>
                <td>240</td>
                <td>320</td>
                <td>300</td>
                <td>250</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>5</th>
                <td>550</td>
                <td>480</td>
                <td>300</td>
                <td>200</td>
                <td>250</td>
                <td>210</td>
              </tr>
              <tr>
                <th>6</th>
                <td>310</td>
                <td>260</td>
                <td>300</td>
                <td>200</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>7</th>
                <td>200</td>
                <td>300</td>
                <td>350</td>
                <td>200</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>8</th>
                <td>340</td>
                <td>200</td>
                <td>350</td>
                <td>200</td>
                <td>200</td>
                <td>200</td>
              </tr>
              <tr>
                <th>9</th>
                <td>200</td>
                <td>300</td>
                <td>200</td>
                <td>300</td>
                <td>150</td>
                <td>300</td>
              </tr>
              <tr>
                <th>10</th>
                <td>250</td>
                <td>250</td>
                <td>350</td>
                <td>250</td>
                <td>250</td>
                <td>250</td>
              </tr>
              <tr>
                <th>11</th>
                <td>350</td>
                <td>240</td>
                <td>550</td>
                <td>350</td>
                <td>450</td>
                <td>550</td>
              </tr>
              <tr>
                <th>12</th>
                <td>350</td>
                <td>340</td>
                <td>250</td>
                <td>350</td>
                <td>250</td>
                <td>250</td>
              </tr>
              <tr>
                <th>13</th>
                <td>250</td>
                <td>200</td>
                <td>250</td>
                <td>250</td>
                <td>200</td>
                <td>250</td>
              </tr>
              <tr>
                <th>14</th>
                <td>320</td>
                <td>230</td>
                <td>330</td>
                <td>360</td>
                <td>350</td>
                <td>300</td>
              </tr>
              <tr>
                <th>15</th>
                <td>150</td>
                <td>300</td>
                <td>200</td>
                <td>150</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>16</th>
                <td>150</td>
                <td>200</td>
                <td>300</td>
                <td>250</td>
                <td>200</td>
                <td>100</td>
              </tr>
              <tr>
                <th>17</th>
                <td>320</td>
                <td>250</td>
                <td>310</td>
                <td>220</td>
                <td>440</td>
                <td>330</td>
              </tr>
              <tr>
                <th>18</th>
                <td>350</td>
                <td>200</td>
                <td>150</td>
                <td>250</td>
                <td>200</td>
                <td>10</td>
              </tr>
              <tr>
                <th>19</th>
                <td>150</td>
                <td>230</td>
                <td>200</td>
                <td>150</td>
                <td>280</td>
                <td>260</td>
              </tr>
              <tr>
                <th>20</th>
                <td>330</td>
                <td>220</td>
                <td>150</td>
                <td>350</td>
                <td>150</td>
                <td>250</td>
              </tr>
              <tr>
                <th>21</th>
                <td>150</td>
                <td>420</td>
                <td>230</td>
                <td>240</td>
                <td>250</td>
                <td>200</td>
              </tr>
              <tr>
                <th>22</th>
                <td>150</td>
                <td>220</td>
                <td>250</td>
                <td>350</td>
                <td>330</td>
                <td>220</td>
              </tr>
              <tr>
                <th>23</th>
                <td>150</td>
                <td>200</td>
                <td>200</td>
                <td>300</td>
                <td>350</td>
                <td>300</td>
              </tr>
              <tr>
                <th>24</th>
                <td>250</td>
                <td>200</td>
                <td>350</td>
                <td>250</td>
                <td>350</td>
                <td>250</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
		<div class="row">
		<div class="indiv">
			<div class="his_chart_top clear">
				<div class="clear">
					<h2 class="fl s_tit">분석 기준 설비 선택</h2>
					<a href="#" class="btn_type02 fr">분석 조건 저장</a>
				</div>
				<!-- 기본 항목 -->
				<div class="clear">
					<div class="fl">
					  <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">사이트명
							<span class="caret"></span></button>
						  <ul class="dropdown-menu">
							<li class="on"><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
							<li><a href="#">사이트명</a></li>
						  </ul>
						</div>
					  </div>
					  <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
							<span class="caret"></span></button>
							<ul class="dropdown-menu dropdown-menu-form rdo_type" role="menu">
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="radio" id="rdo01" name="rdo_btn" value="DC 전압">
										<label for="rdo01"><span></span>DC 전압</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option2" tabindex="-1">
										<input type="radio" id="rdo02" name="rdo_btn" value="DC 전류">
										<label for="rdo02"><span></span>DC 전류</label>
									</a>
								</li>
							</ul>
						</div>
					  </div>
					   <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">최대
							<span class="caret"></span></button>
							<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
								<li>
									<a href="#" data-value="option1" tabindex="-1">
										<input type="radio" id="rdo01_1" name="rdo_btn2" value="최대">
										<label for="rdo01_1"><span></span>최대</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option2" tabindex="-1">
										<input type="radio" id="rdo01_2" name="rdo_btn2" value="최소">
										<label for="rdo01_2"><span></span>최소</label>
									</a>
								</li>
								<li>
									<a href="#" data-value="option2" tabindex="-1">
										<input type="radio" id="rdo01_3" name="rdo_btn2" value="평균">
										<label for="rdo01_3"><span></span>평균</label>
									</a>
								</li>
							</ul>
						</div>
					  </div>
					   <div class="sa_select">
						<div class="dropdown">
						  <button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown">y-좌
							<span class="caret"></span></button>
						  <ul class="dropdown-menu">
							<li class="on"><a href="#">y-좌</a></li>
							<li><a href="#">y-우</a></li>
						  </ul>
						</div>
					  </div>
					</div>
					
					<!-- 버튼 -->
					<div class="fl">
					  <button type="submit" class="btn_type">그래프 항목 추가</button>
					  <button type="submit" class="btn_type">그래프 그리기</button>
					</div>
					
					<!-- 우측 항목 -->
					<div class="fr his_inp_bx">
						<div class="rdo_type his_rdo_bx">
							<span>
								<input type="radio" id="rdo03_1" name="rdo_btn22" value="시계열 분석">
								<label for="rdo03_1"><span></span>시계열 분석</label>
							</span>
							<span>
								<input type="radio" id="rdo03_2" name="rdo_btn22" value="상권 분석">
								<label for="rdo03_2"><span></span>상권 분석</label>
							</span>
						</div>
						
						<div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w6" type="button" data-toggle="dropdown">사이트별 누적
								<span class="caret"></span></button>
								<ul class="dropdown-menu rdo_type">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="radio" id="rdo04_1" name="rdo_btn33" value="사이트별 누적">
											<label for="rdo04_1"><span></span>사이트별 누적</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo04_2" name="rdo_btn33" value="사이트별 평균">
											<label for="rdo04_2"><span></span>사이트별 평균</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option3" tabindex="-1">
											<input type="radio" id="rdo04_3" name="rdo_btn33" value="설비별 누적">
											<label for="rdo04_3"><span></span>설비별 누적</label>
										</a>
									</li>
								</ul>
							</div>
					  </div>
					</div>
				</div>
				
				<br>
				<!-- x축 y축 -->
				<div class="clear">
					<div class="fl">
						<span class="tx_tit">x축</span>
						<div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
								<span class="caret"></span></button>
							  <ul class="dropdown-menu">
								<li class="on"><a href="#">인버터#1</a></li>
								<li><a href="#">인버터#2</a></li>
								<li><a href="#">인버터#3</a></li>
								<li><a href="#">인버터#4</a></li>
								<li><a href="#">인버터#5</a></li>
							  </ul>
							</div>
						  </div>
						  <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
								<span class="caret"></span></button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chktype11" value="DC 전압">
											<label for="chktype11"><span></span>DC 전압</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="checkbox" id="chktype12" value="DC 전류">
											<label for="chktype12"><span></span>DC 전류</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option3" tabindex="-1">
											<input type="checkbox" id="chktype13" value="DC 전력">
											<label for="chktype13"><span></span>DC 전력</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option4" tabindex="-1">
											<input type="checkbox" id="chktype14" value="금일 발전량">
											<label for="chktype14"><span></span>금일 발전량</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
						   <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">평균
								<span class="caret"></span></button>
								<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="radio" id="rdo04_1" name="rdo_btn5" value="최대">
											<label for="rdo04_1"><span></span>최대</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo04_2" name="rdo_btn5" value="최소">
											<label for="rdo04_2"><span></span>최소</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo04_3" name="rdo_btn5" value="평균">
											<label for="rdo04_3"><span></span>평균</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
					</div>
					
					<div class="fl">
						<span class="tx_tit">y축</span>
						<div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">인버터
								<span class="caret"></span></button>
							  <ul class="dropdown-menu">
								<li class="on"><a href="#">인버터#1</a></li>
								<li><a href="#">인버터#2</a></li>
								<li><a href="#">인버터#3</a></li>
								<li><a href="#">인버터#4</a></li>
								<li><a href="#">인버터#5</a></li>
							  </ul>
							</div>
						  </div>
						  <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w2" type="button" data-toggle="dropdown">DC 전압
								<span class="caret"></span></button>
								<ul class="dropdown-menu dropdown-menu-form chk_type" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="checkbox" id="chktype21" value="DC 전압">
											<label for="chktype21"><span></span>DC 전압</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="checkbox" id="chktype22" value="DC 전류">
											<label for="chktype22"><span></span>DC 전류</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option3" tabindex="-1">
											<input type="checkbox" id="chktype23" value="DC 전력">
											<label for="chktype23"><span></span>DC 전력</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option4" tabindex="-1">
											<input type="checkbox" id="chktype24" value="금일 발전량">
											<label for="chktype24"><span></span>금일 발전량</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
						   <div class="sa_select">
							<div class="dropdown">
							  <button class="btn btn-primary dropdown-toggle w4" type="button" data-toggle="dropdown">평균
								<span class="caret"></span></button>
								<ul class="dropdown-menu rdo_type dropdown-menu-form" role="menu">
									<li>
										<a href="#" data-value="option1" tabindex="-1">
											<input type="radio" id="rdo05_1" name="rdo_btn6" value="최대">
											<label for="rdo05_1"><span></span>최대</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo05_2" name="rdo_btn6" value="최소">
											<label for="rdo05_2"><span></span>최소</label>
										</a>
									</li>
									<li>
										<a href="#" data-value="option2" tabindex="-1">
											<input type="radio" id="rdo05_3" name="rdo_btn6" value="평균">
											<label for="rdo05_3"><span></span>평균</label>
										</a>
									</li>
								</ul>
							</div>
						  </div>
					</div>
					
					<!-- 버튼 -->
					<div class="fl">
					  <button type="submit" class="btn_type">그래프 항목 추가</button>
					  <button type="submit" class="btn_type">그래프 그리기</button>
					</div>
					
					<!-- 우측 항목 -->
					<div class="fr his_inp_bx">
						<div class="rdo_type his_rdo_bx">
							<span>
								<input type="radio" id="rdo06_1" name="rdo_btn32" value="시계열 분석">
								<label for="rdo06_1"><span></span>시계열 분석</label>
							</span>
							<span>
								<input type="radio" id="rdo06_2" name="rdo_btn32" value="상권 분석">
								<label for="rdo06_2"><span></span>상권 분석</label>
							</span>
						</div>
					</div>
				</div>
				
				<!-- x,y축 태그 -->
				<div class="tag_bx clear">
					<div class="fl">
						<span class="tx_tit">y-좌</span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
					</div>
					<div class="fl">
						<span class="tx_tit">y-우</span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
						<span class="tag_type">인버터 #1: DC 전압 평균<button>닫기</button></span>
					</div>
				</div>
			</div>
			<br>
			<br>
			<div class="inchart">
			  <div id="hchart2"></div>
			  <script language="JavaScript">
				$(function () {
				  var myChart = Highcharts.chart('hchart2', {
					data: {
					  table: 'datatable' /* 테이블에서 데이터 불러오기 */
					},
					
					chart: {
					  marginLeft: 80,
					  marginRight: 0,
					  backgroundColor: 'transparent',
					  type: 'column'
					},
					
					navigation: {
					  buttonOptions: {
						enabled: false /* 메뉴 안보이기 */
					  }
					},
					
					title: {
					  text: ''
					},
					
					subtitle: {
					  text: ''
					},
					
					xAxis: {
					  labels: {
						align: 'center',
						style: {
						  color: '#3d4250',
						  fontSize: '14px'
						}
					  },
					  tickInterval: 1, /* 눈금의 픽셀 간격 조정 */
					  title: {
						text: null
					  },
					  crosshair: true /* 포커스 선 */
					},
					
					yAxis: {
					  gridLineWidth: 1, /* 기준선 grid 안보이기/보이기 */
					  min: 0, /* 최소값 지정 */
					  title: {
						text: '(kWh)',
						align: 'low',
						rotation: 0, /* 타이틀 기울기 */
						y: 25, /* 타이틀 위치 조정 */
						x: 5, /* 타이틀 위치 조정 */
						style: {
						  color: '#3d4250',
						  fontSize: '14px'
						}
					  },
					  labels: {
						overflow: 'justify',
						x: -20, /* 그래프와의 거리 조정 */
						style: {
						  color: '#3d4250',
						  fontSize: '14px'
						}
					  }
					},
					
					/* 범례 */
					legend: {
					  enabled: true,
					  align: 'right',
					  verticalAlign: 'top',
					  x: 10,
					  itemStyle: {
						color: '#3d4250',
						fontSize: '14px',
						fontWeight: 400
					  },
					  itemHoverStyle: {
						color: '' /* 마우스 오버시 색 */
					  },
					  symbolPadding: 3, /* 심볼 - 텍스트간 거리 */
					  symbolHeight: 8 /* 심볼 크기 */
					},
					
					/* 툴팁 */
					tooltip: {
					  shared: true /* 툴팁 공유 */
					},
					
					/* 옵션 */
					plotOptions: {
					  series: {
						label: {
						  connectorAllowed: false
						},
						borderWidth: 0 /* 보더 0 */
					  },
					  line: {
						marker: {
						  enabled: false /* 마커 안보이기 */
						}
					  },
					  column: {
						stacking: 'normal'
					  }
					},
					
					/* 출처 */
					credits: {
					  enabled: false
					},
					
					/* 그래프 스타일 */
					series: [{
					  name: '인버터#1 금일발전량',
					  type: 'column',
					  stack: 'male',
					  color: '#6b41ba',
					  tooltip: {
						valueSuffix: 'kWh'
					  }
					}, {
					  name: '인버터#7 금일발전량',
					  type: 'column',
					  stack: 'male',
					  color: '#7571f9',
					  tooltip: {
						valueSuffix: 'kWh'
					  }
					}
					  , {
						name: '인버터#11 금일발전량',
						type: 'column',
						stack: 'male',
						color: '#abb4fa',
						tooltip: {
						  valueSuffix: 'kWh'
						}
					  }
					  , {
						name: '인버터#1 누적발전량',
						type: 'column',
						stack: 'female',
						color: '#007bff',
						tooltip: {
						  valueSuffix: 'kWh'
						}
					  }, {
						name: '인버터#7 누적발전량',
						type: 'column',
						stack: 'female',
						color: '#3485db',
						tooltip: {
						  valueSuffix: 'kWh'
						}
					  }
					  , {
						name: '인버터#11 누적발전량',
						type: 'column',
						stack: 'female',
						color: '#73a2d5',
						tooltip: {
						  valueSuffix: 'kWh'
						}
					  }]
					
				  });
				});
			  </script>
			</div>
			<!-- 데이터 추출용 -->
			<div class="chart_table2" style="display:none;">
			  <table id="datatable">
				<thead>
				  <tr>
					<th>2018-08</th>
					<th>인버터#1 금일발전량</th>
					<th>인버터#7 금일발전량</th>
					<th>인버터#11 금일발전량</th>
					<th>인버터#1 누적발전량</th>
					<th>인버터#7 누적발전량</th>
					<th>인버터#11 누적발전량</th>
				  </tr>
				</thead>
				<tbody>
				  <tr>
					<th>1</th>
					<td>300</td>
					<td>400</td>
					<td>300</td>
					<td>200</td>
					<td>150</td>
					<td>300</td>
				  </tr>
				  <tr>
					<th>2</th>
					<td>300</td>
					<td>300</td>
					<td>300</td>
					<td>200</td>
					<td>200</td>
					<td>150</td>
				  </tr>
				  <tr>
					<th>3</th>
					<td>540</td>
					<td>350</td>
					<td>300</td>
					<td>250</td>
					<td>250</td>
					<td>200</td>
				  </tr>
				  <tr>
					<th>4</th>
					<td>240</td>
					<td>320</td>
					<td>300</td>
					<td>250</td>
					<td>250</td>
					<td>200</td>
				  </tr>
				  <tr>
					<th>5</th>
					<td>550</td>
					<td>480</td>
					<td>300</td>
					<td>200</td>
					<td>250</td>
					<td>210</td>
				  </tr>
				  <tr>
					<th>6</th>
					<td>310</td>
					<td>260</td>
					<td>300</td>
					<td>200</td>
					<td>250</td>
					<td>200</td>
				  </tr>
				  <tr>
					<th>7</th>
					<td>200</td>
					<td>300</td>
					<td>350</td>
					<td>200</td>
					<td>250</td>
					<td>200</td>
				  </tr>
				  <tr>
					<th>8</th>
					<td>340</td>
					<td>200</td>
					<td>350</td>
					<td>200</td>
					<td>200</td>
					<td>200</td>
				  </tr>
				  <tr>
					<th>9</th>
					<td>200</td>
					<td>300</td>
					<td>200</td>
					<td>300</td>
					<td>150</td>
					<td>300</td>
				  </tr>
				  <tr>
					<th>10</th>
					<td>250</td>
					<td>250</td>
					<td>350</td>
					<td>250</td>
					<td>250</td>
					<td>250</td>
				  </tr>
				  <tr>
					<th>11</th>
					<td>350</td>
					<td>240</td>
					<td>550</td>
					<td>350</td>
					<td>450</td>
					<td>550</td>
				  </tr>
				  <tr>
					<th>12</th>
					<td>350</td>
					<td>340</td>
					<td>250</td>
					<td>350</td>
					<td>250</td>
					<td>250</td>
				  </tr>
				  <tr>
					<th>13</th>
					<td>250</td>
					<td>200</td>
					<td>250</td>
					<td>250</td>
					<td>200</td>
					<td>250</td>
				  </tr>
				  <tr>
					<th>14</th>
					<td>320</td>
					<td>230</td>
					<td>330</td>
					<td>360</td>
					<td>350</td>
					<td>300</td>
				  </tr>
				  <tr>
					<th>15</th>
					<td>150</td>
					<td>300</td>
					<td>200</td>
					<td>150</td>
					<td>250</td>
					<td>200</td>
				  </tr>
				  <tr>
					<th>16</th>
					<td>150</td>
					<td>200</td>
					<td>300</td>
					<td>250</td>
					<td>200</td>
					<td>100</td>
				  </tr>
				  <tr>
					<th>17</th>
					<td>320</td>
					<td>250</td>
					<td>310</td>
					<td>220</td>
					<td>440</td>
					<td>330</td>
				  </tr>
				  <tr>
					<th>18</th>
					<td>350</td>
					<td>200</td>
					<td>150</td>
					<td>250</td>
					<td>200</td>
					<td>10</td>
				  </tr>
				  <tr>
					<th>19</th>
					<td>150</td>
					<td>230</td>
					<td>200</td>
					<td>150</td>
					<td>280</td>
					<td>260</td>
				  </tr>
				  <tr>
					<th>20</th>
					<td>330</td>
					<td>220</td>
					<td>150</td>
					<td>350</td>
					<td>150</td>
					<td>250</td>
				  </tr>
				  <tr>
					<th>21</th>
					<td>150</td>
					<td>420</td>
					<td>230</td>
					<td>240</td>
					<td>250</td>
					<td>200</td>
				  </tr>
				  <tr>
					<th>22</th>
					<td>150</td>
					<td>220</td>
					<td>250</td>
					<td>350</td>
					<td>330</td>
					<td>220</td>
				  </tr>
				  <tr>
					<th>23</th>
					<td>150</td>
					<td>200</td>
					<td>200</td>
					<td>300</td>
					<td>350</td>
					<td>300</td>
				  </tr>
				  <tr>
					<th>24</th>
					<td>250</td>
					<td>200</td>
					<td>350</td>
					<td>250</td>
					<td>350</td>
					<td>250</td>
				  </tr>
				</tbody>
			  </table>
			</div>
		  </div>
		</div>
	</div>
  <div class="row usage_chart_table">
    <div class="col-lg-12">
      <div class="indiv">
        <table class="his_tbl">
          <thead>
            <tr>
              <th data-column="datetime">설비명</th>
              <th data-column="d1">설비ID</th>
              <th data-column="d2">사업소</th>
              <th data-column="d3">상태</th>
              <th data-column="d4"><button class="btn_align">DC전압</button></th>
              <th data-column="d5"><button class="btn_align">DC전류</button></th>
              <th data-column="d6"><button class="btn_align">DC전력</button></th>
              <th data-column="d7"><button class="btn_align">현재출력</button></th>
              <th data-column="d8"><button class="btn_align">금일발전량</button></th>
              <th data-column="d9"><button class="btn_align">누적발전량</button></th>
              <th data-column="d10"><button class="btn_align">AC전압R</button></th>
              <th data-column="d11"><button class="btn_align">AC전압S</button></th>
              <th data-column="d12"><button class="btn_align">AC전압T</button></th>
              <th data-column="d13"><button class="btn_align">역률</button></th>
              <th data-column="d14"><button class="btn_align">주파수</button></th>
              <th data-column="d15"><button class="btn_align">온도</button></th>
              <th data-column="d16" data-column="datetime">시간</th>
				<!-- 
					위 화살표 : up 클래스 추가
					아래 화살표 : down 클래스 추가
				-->
				<th><button class="btn_align down">설비명</button></th>
				<th><button class="btn_align down">설비ID</button></th>
				<th><button class="btn_align down">사업소</button></th>
				<th><button class="btn_align down">상태</button></th>
				<th><button class="btn_align up">DC전압</button></th>
				<th><button class="btn_align up">DC전류</button></th>
				<th><button class="btn_align up">DC전력</button></th>
				<th><button class="btn_align up">현재출력</button></th>
				<th><button class="btn_align up">금일발전량</button></th>
				<th><button class="btn_align up">누적발전량</button></th>
				<th><button class="btn_align up">AC전압R</button></th>
				<th><button class="btn_align up">AC전압S</button></th>
				<th><button class="btn_align up">AC전압T</button></th>
				<th><button class="btn_align up">역률</button></th>
				<th><button class="btn_align up">주파수</button></th>
				<th><button class="btn_align up">온도</button></th>
            </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>