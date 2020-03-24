<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>
	
	<script>
	
	var weatherData = function(sido, sigungu, eub, grid_x, grid_y, mid_temp_cd, mid_land_cd, order_num) {
		this.sido = sido;
		this.sigungu = sigungu;
		this.eub = eub;
		this.grid_x = grid_x;
		this.grid_y = grid_y;
		this.mid_temp_cd = mid_temp_cd;
		this.mid_land_cd = mid_land_cd;
		this.order_num = order_num;	
	}
	
	var arrayWeatherData = new Array;
	
	$(document).ready(function () {		
		getSido();
	});	

	
	// 기상청 openapi관련 시도 조회
	function getSido() {
	    $.ajax({
	        url: "/weather/getSido.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        success: function (result) {
	    		// DB data 초기화
	    		arrayWeatherData.length = 0;

	        	var sidoList = result.mapSido;	        	
	        	var str = '';

				str += "<option value=''>시도</option>";
				
				for (var i = 0; i < sidoList.length; i++) {
					str += "<option value=" + sidoList[i].sido + '>' + sidoList[i].sido + "</option>";
					//str += "<option value=" + sidoList[i] + '>' + sidoList[i].sido + "</option>";
					arrayWeatherData.push(new weatherData(sidoList[i].sido, sidoList[i].sigungu, sidoList[i].eub, sidoList[i].grid_x, sidoList[i].grid_y, sidoList[i].mid_temp_cd, sidoList[i].mid_land_cd, sidoList[i].order_num));
				}				

				$('#sido_select').html(str);
	        }
	    });
	}
	
	
	// 기상청 openapi관련 시군구 조회
	function getSigungu(sidoData) {
	    $.ajax({
	        url: "/weather/getSigungu.json",
	        type: 'post',
	        data: {
	        	sido: sidoData
	        },	        
	        async: false, // 동기로 처리해줌
	        success: function (result) {
	    		// 읍면동 초기화
	    		$('#eub_select').html('');
	    		
	    		// DB data 초기화
	    		arrayWeatherData.length = 0;

	        	var sigunguList = result.mapSigungu;	        	
	        	var str = '';

				//str += "<option value=''>시군구</option>";
				
				for (var i = 0; i < sigunguList.length; i++) {
					if(sigunguList[i].sigungu == '') {
						str += "<option value=''>시군구</option>";	
					}
					else {
						str += "<option value=" + sigunguList[i].sigungu + '>' + sigunguList[i].sigungu + "</option>";	
					}
					
					arrayWeatherData.push(new weatherData(sigunguList[i].sido, sigunguList[i].sigungu, sigunguList[i].eub, sigunguList[i].grid_x, sigunguList[i].grid_y, sigunguList[i].mid_temp_cd, sigunguList[i].mid_land_cd, sigunguList[i].order_num));
				}				

				$('#sigungu_select').html(str);
	        }
	    });
	}
	
	
	
	// 기상청 openapi관련 읍면동 조회
	function getEub(sigungu) {
	    $.ajax({
	        url: "/weather/getEub.json",
	        type: 'post',
	        data: {
	        	sido: $('#sido_select option:selected').val(),
	        	sigungu: sigungu
	        },	        
	        async: false, // 동기로 처리해줌
	        success: function (result) {
	    		// DB data 초기화
	    		arrayWeatherData.length = 0;
	    		
	        	var eubList = result.mapEub;	        	
	        	var str = '';

				//str += "<option value=''>읍면동</option>";
				
				for (var i = 0; i < eubList.length; i++) {
					if( eubList[i].eub == '') {
						str += "<option value=''>읍면동</option>";
					}
					else {
						str += "<option value=" + eubList[i].eub + '>' + eubList[i].eub + "</option>";
					}
					
					arrayWeatherData.push(new weatherData(eubList[i].sido, eubList[i].sigungu, eubList[i].eub, eubList[i].grid_x, eubList[i].grid_y, eubList[i].mid_temp_cd, eubList[i].mid_land_cd, eubList[i].order_num));
				}				

				$('#eub_select').html(str);
	        }
	    });
	}
	
	function selectSidoSigunguEub() {
		var sido = $('#sido_select').val();
		var sigungu = $('#sigungu_select').val();
		if(sigungu==null) {
			sigungu = undefined;
		}
		var eub = $('#eub_select').val();
		if(eub==null) {
			eub = undefined;
		}
		
		for(var i=0; i<arrayWeatherData.length; i++) {
			if((arrayWeatherData[i].sido == sido) &&  	
               (arrayWeatherData[i].sigungu == sigungu) &&
               (arrayWeatherData[i].eub == eub)) {
				return arrayWeatherData[i];
			}				
		}	
	}
	
	function showWeather() {
		var weatherDB = selectSidoSigunguEub();
		
		if(weatherDB != undefined) {
// 			alert(JSON.stringify(weatherDB));
			
		    $.ajax({
		        url: "/weather/getWeather.json",
		        type: 'post',
		        data: {
		     		grid_x: weatherDB.grid_x,
		     		grid_y: weatherDB.grid_y
		        },	        
		        async: false, // 동기로 처리해줌
		        success: function (result) {
		        	var weatherList = result.mapWeather;	        	
		        	var str = '';

					// {baseDate=20200310, baseTime=2300, category=POP, fcstDate=20200311, fcstTime=0300, fcstValue=0, nx=86, ny=88}
					for (var i = 0; i < weatherList.length; i++) {
						str += i + '<br/>';
						str += 'baseDate: ' + weatherList[i].baseDate + '<br/>';
						str += 'baseTime: ' + weatherList[i].baseTime + '<br/>';
						str += 'category: ' + weatherList[i].category + '<br/>';
						str += 'fcstDate: ' + weatherList[i].fcstDate + '<br/>';
						str += 'fcstTime: ' + weatherList[i].fcstTime + '<br/>';
						str += 'fcstValue: ' + weatherList[i].fcstValue + '<br/>';
						str += 'nx: ' + weatherList[i].nx + '<br/>';
						str += 'ny: ' + weatherList[i].ny + '<br/>';
						str += '<br/>';
						str += '<br/>';
					}

					$('#weather_result').html(str);
		        }
		    });			
		}
	}
	
	
	function showMidWeather() {
		var weatherDB = selectSidoSigunguEub();
		
		if(weatherDB != undefined) {
// 			alert(JSON.stringify(weatherDB));
			
		    $.ajax({
		        url: "/weather/getMidWeather.json",
		        type: 'post',
		        data: {
		     		mid_land_cd: weatherDB.mid_land_cd
		        },	        
		        async: false, // 동기로 처리해줌
		        success: function (result) {
		        	var midWeatherList = result.mapMidWeather;	        	
		        	var str = '';
		        	
					//{"regId":"11B00000","rnSt3Am":0,"rnSt3Pm":20,"rnSt4Am":40,"rnSt4Pm":10,"rnSt5Am":0,"rnSt5Pm":0,"rnSt6Am":30,"rnSt6Pm":60,"rnSt7Am":60,"rnSt7Pm":20,"rnSt8":20,"rnSt9":20,"rnSt10":20,"wf3Am":"맑음","wf3Pm":"맑음","wf4Am":"구름많음","wf4Pm":"맑음","wf5Am":"맑음","wf5Pm":"맑음","wf6Am":"구름많음","wf6Pm":"흐리고 비","wf7Am":"흐리고 비","wf7Pm":"맑음","wf8":"맑음","wf9":"맑음","wf10":"맑음"}
					for (var i = 0; i < midWeatherList.length; i++) {
						str += '강수확률<br/>'
						str += '3일후 오전 강수 확률: ' + midWeatherList[i].rnSt3Am + '<br/>';
						str += '3일후 오후 강수 확률: ' + midWeatherList[i].rnSt3Pm + '<br/>';
						str += '4일후 오전 강수 확률: ' + midWeatherList[i].rnSt4Am + '<br/>';
						str += '4일후 오후 강수 확률: ' + midWeatherList[i].rnSt4Pm + '<br/>';
						str += '5일후 오전 강수 확률: ' + midWeatherList[i].rnSt5Am + '<br/>';
						str += '5일후 오후 강수 확률: ' + midWeatherList[i].rnSt5Pm + '<br/>';
						str += '6일후 오전 강수 확률: ' + midWeatherList[i].rnSt6Am + '<br/>';
						str += '6일후 오후 강수 확률: ' + midWeatherList[i].rnSt6Pm + '<br/>';
						str += '7일후 오전 강수 확률: ' + midWeatherList[i].rnSt7Am + '<br/>';
						str += '7일후 오후 강수 확률: ' + midWeatherList[i].rnSt7Pm + '<br/>';						
						str += '8일후 강수 확률: ' + midWeatherList[i].rnSt8 + '<br/>';
						str += '9일후 강수 확률: ' + midWeatherList[i].rnSt9 + '<br/>';
						str += '10일후 강수 확률: ' + midWeatherList[i].rnSt10 + '<br/>';
						str += '날씨예보<br/>'
						str += '3일후 오전 날씨 예보: ' + midWeatherList[i].wf3Am + '<br/>';
						str += '3일후 오후 날씨 예보: ' + midWeatherList[i].wf3Pm + '<br/>';						
						str += '4일후 오전 날씨 예보: ' + midWeatherList[i].wf4Am + '<br/>';
						str += '4일후 오후 날씨 예보: ' + midWeatherList[i].wf4Pm + '<br/>';
						str += '5일후 오전 날씨 예보: ' + midWeatherList[i].wf5Am + '<br/>';
						str += '5일후 오후 날씨 예보: ' + midWeatherList[i].wf5Pm + '<br/>';
						str += '6일후 오전 날씨 예보: ' + midWeatherList[i].wf6Am + '<br/>';
						str += '6일후 오후 날씨 예보: ' + midWeatherList[i].wf6Pm + '<br/>';
						str += '7일후 오전 날씨 예보: ' + midWeatherList[i].wf7Am + '<br/>';
						str += '7일후 오후 날씨 예보: ' + midWeatherList[i].wf7Pm + '<br/>';
						str += '8일후 날씨 예보: ' + midWeatherList[i].wf8 + '<br/>';
						str += '9일후 날씨 예보: ' + midWeatherList[i].wf9 + '<br/>';
						str += '10일후 날씨 예보: ' + midWeatherList[i].wf10 + '<br/>';
						str += '<br/>';
						str += '<br/>';
					}

					$('#weather_result').html(str);
		        }
		    });			
		}
	}	
	
	
	
	function showMidTempWeather() {
		var weatherDB = selectSidoSigunguEub();
		
		if(weatherDB != undefined) {
// 			alert(JSON.stringify(weatherDB));
			
		    $.ajax({
		        url: "/weather/getMidTempWeather.json",
		        type: 'post',
		        data: {
		     		mid_temp_cd: weatherDB.mid_temp_cd
		        },	        
		        async: false, // 동기로 처리해줌
		        success: function (result) {
		        	var midTempWeatherList = result.mapMidTempWeather;	        	
		        	var str = '';
		        	
// 		        	alert(result.mapVal);
// 		        	var kk = "${modelVal }";
		        	
					//{"regId":"11D20501","taMin3":0,"taMin3Low":1,"taMin3High":1,"taMax3":12,"taMax3Low":1,"taMax3High":1,"taMin4":3,"taMin4Low":1,"taMin4High":0,"taMax4":9,"taMax4Low":2,"taMax4High":1,"taMin5":0,"taMin5Low":1,"taMin5High":1,"taMax5":9,"taMax5Low":2,"taMax5High":2,"taMin6":3,"taMin6Low":2,"taMin6High":2,"taMax6":14,"taMax6Low":2,"taMax6High":2,"taMin7":5,"taMin7Low":1,"taMin7High":1,"taMax7":14,"taMax7Low":2,"taMax7High":2,"taMin8":7,"taMin8Low":0,"taMin8High":3,"taMax8":17,"taMax8Low":0,"taMax8High":2,"taMin9":8,"taMin9Low":0,"taMin9High":2,"taMax9":17,"taMax9Low":0,"taMax9High":1,"taMin10":6,"taMin10Low":0,"taMin10High":2,"taMax10":15,"taMax10Low":0,"taMax10High":2}
					for (var i = 0; i < midTempWeatherList.length; i++) {
						str += '3일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin3 + '<br/>';
						str += '3일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin3Low + '<br/>';
						str += '3일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin3High + '<br/>';
						str += '3일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax3 + '<br/>';
						str += '3일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax3Low + '<br/>';
						str += '3일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax3High + '<br/>';
						str += '4일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin4 + '<br/>';
						str += '4일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin4Low + '<br/>';
						str += '4일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin4High + '<br/>';
						str += '4일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax4 + '<br/>';
						str += '4일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax4Low + '<br/>';
						str += '4일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax4High + '<br/>';						
						str += '5일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin5 + '<br/>';
						str += '5일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin5Low + '<br/>';
						str += '5일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin5High + '<br/>';
						str += '5일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax5 + '<br/>';
						str += '5일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax5Low + '<br/>';
						str += '5일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax5High + '<br/>';						
						str += '6일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin6 + '<br/>';
						str += '6일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin6Low + '<br/>';
						str += '6일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin6High + '<br/>';
						str += '6일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax6 + '<br/>';
						str += '6일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax6Low + '<br/>';
						str += '6일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax6High + '<br/>';						
						str += '7일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin7 + '<br/>';
						str += '7일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin7Low + '<br/>';
						str += '7일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin7High + '<br/>';
						str += '7일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax7 + '<br/>';
						str += '7일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax7Low + '<br/>';
						str += '7일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax7High + '<br/>';
						str += '8일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin8 + '<br/>';
						str += '8일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin8Low + '<br/>';
						str += '8일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin8High + '<br/>';
						str += '8일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax8 + '<br/>';
						str += '8일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax8Low + '<br/>';
						str += '8일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax8High + '<br/>';						
						str += '9일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin9 + '<br/>';
						str += '9일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin9Low + '<br/>';
						str += '9일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin9High + '<br/>';
						str += '9일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax9 + '<br/>';
						str += '9일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax9Low + '<br/>';
						str += '9일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax9High + '<br/>';
						str += '10일 후 예상최저기온(℃): ' + midTempWeatherList[i].taMin10 + '<br/>';
						str += '10일 후 예상최저기온 하한 범위: ' + midTempWeatherList[i].taMin10Low + '<br/>';
						str += '10일 후 예상최저기온 상한 범위: ' + midTempWeatherList[i].taMin10High + '<br/>';
						str += '10일 후 예상최고기온(℃): ' + midTempWeatherList[i].taMax10 + '<br/>';
						str += '10일 후 예상최고기온 하한 범위: ' + midTempWeatherList[i].taMax10Low + '<br/>';
						str += '10일 후 예상최고기온 상한 범위: ' + midTempWeatherList[i].taMax10High + '<br/>';
						str += '<br/>';
						str += '<br/>';
					}

					$('#weather_result').html(str);
		        }
		    });			
		}
	}		
	
	

	</script>

	<!-- 메인페이지용 스타일/스크립트 파일 -->
	<div style="width:100%; height:200px; display:inline-block; background:#e2e2e2; overflow:auto;">
		<select id="sido_select" style="width:20%; background:#ff0052;" onchange="getSigungu(this.value);">
		</select>	
		<select id="sigungu_select" style="width:20%; background:#ff0052;" onchange="getEub(this.value);">
		</select>
		<select id="eub_select" style="width:20%; background:#ff0052;">
		</select>	
		<button id="show_weather" style="width:10%; height:20px; background:#00ff00;" onclick="showWeather();">동네날씨보기</button>
		<button id="show_midweather" style="width:10%; height:20px; background:#00ff00;" onclick="showMidWeather();">중기날씨보기</button>
		<button id="show_midtempweather" style="width:10%; height:20px; background:#00ff00;" onclick="showMidTempWeather();">중기온도보기</button>
		<br/>
		<div id="weather_result" style="overflow:auto"></div>	
	</div>
	