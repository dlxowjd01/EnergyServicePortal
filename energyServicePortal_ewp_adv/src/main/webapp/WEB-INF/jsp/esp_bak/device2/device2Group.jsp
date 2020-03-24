<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>


<style type="text/css">
#main_box{    
   width:  100%;              
   height: 100%;
}

.sub_box1{     
   width:  50%;
   height: 200px;
   margin: 10px;
   display: inline-block;
   vertical-align: top;
   background-color: #DEDEEF;
}

.sub_box2{      
   width: 47%;
   height: 200px;
   margin: 10px;
   display: inline-block;
   vertical-align: top;   
   background-color: #DEDEEF;
}

.device_box{      
   width: 19%;
   height: 47%;
   margin: 3px;
   display: inline-block;
   vertical-align: top;   
   background-color: #F1F1F8;
}

.device_box_alarm1{      
   width: 19%;
   height: 47%;
   margin: 3px;
   display: inline-block;
   vertical-align: top;   
   background-color: #F86406;
}

.device_box_alarm2{      
   width: 19%;
   height: 47%;
   margin: 3px;
   display: inline-block;
   vertical-align: top;   
   background-color: #F7B924;
}

.device_box_add{      
   width: 19%;
   height: 47%;
   margin: 3px;
   display: inline-block;
   text-align:center;   
   background-color: #F1F1F8;
}

.device_info{      
   width: 24%;
   height: 47%;
   margin: 3px;
   float: left;
   display: inline-block;
   vertical-align: top;   
   background-color: #F1F1F8;
}

.device_info_bottom{      
   width: 100%;
   height: 25%;
   margin: 0px;
   float: top;
   display: inline-block;
   vertical-align: top;   
   background-color: #F1F1F8;
}

</style>	

<script type="text/javascript">

	function myMap() {
		this.clear();
	}

	myMap.prototype.put = function(key,value) {
	 	this.length++;
	 	this.elements[key] = value;
	}

	myMap.prototype.get = function(key) {
	 	return this.elements[key];
	}

	myMap.prototype.clear = function() {
		this.elements = {};
		this.length = 0;
	}
	
	function getDeviceType() {
		var str = '';
		switch(arguments[0])
		{
		case '1':
			str += 'PCS';
			break;			
		case '2':
			str += 'BMS';
			break;			
		case '3':
			str += 'PV';
			break;			
		case '4':
			str += '부하측정기기';
			break;			
		case '5':
			str += 'PV모니터링기기';
			break;		
		case '6':
			str += 'ESS모니터링기기';
			break;
		case '7':
			str += 'iSmart';
			break;
		case '8':
			str += '총량기기';
			break;
		case '9':
			str += 'AMI';
			break;
		case 'S':
			str += '접속반';
			break;
		case 'I':
			str += '인버터';
			break;
		case 'A':
			str += 'ACB';
			break;
		case 'V':
			str += 'VCB';
			break;			
		default:
			str += '정보없음';
		}
		
		return str;
	}

	// site 생성
	var deviceGroupSiteMap = new myMap();
	
	$(document).ready(function() {
		$("#siteId").val("${selViewSiteId}");
		deviceGroupSiteMap.clear();
		getDevice2GroupInfo();
	});
	
	
	function getDevice2GroupInfo() {
		$.ajax({
			url : "/device2/getDevice2GroupInfo.json",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
	        	var deviceGroupInfoList = result.list;
	    		
    			var $dg = $("#div_main");
    			if(deviceGroupInfoList != null && deviceGroupInfoList.length > 0) {
    				for(var i=0; i<deviceGroupInfoList.length; i++) {
    					// 장치그룹 없으면 div추가하고 alarm표시
    					if($('#div_main').find("#grp_" + deviceGroupInfoList[i].device_grp_idx).length==0) {
    						// site내 장치그룹 추가
    						var deviceGroupMap = new myMap();
    						deviceGroupSiteMap.put(deviceGroupInfoList[i].device_grp_idx, deviceGroupMap);
    						
    						// 장치그룹 div
    						$('#div_main').append('<div id=\"grp_' + deviceGroupInfoList[i].device_grp_idx + '\"' + '></div>');
    						// 장치그룹 title
    						$('#div_main').append('<div>장치그룹: ' + deviceGroupInfoList[i].device_grp_name + '</div>');
    						// alarm type
    						$('#div_main').append('<div style="color:#F86406;">alert: ' + deviceGroupInfoList[i].a1_cnt + '</div>' + '<div style="color:#F7B924;">warning: ' + deviceGroupInfoList[i].a2_cnt + '</div>');
    						
	    					var id1 = 'sub_box'+deviceGroupInfoList[i].device_grp_idx;
	    					var id2 = 'sub_box'+deviceGroupInfoList[i].device_grp_idx+'_2';
	    					// 장치 리스트 div
	    					$('#div_main').append('<div class=sub_box1 id=' + id1 + ' style="overflow:auto;"></div>');
	    					// 장치 상세정보 div
	    					$('#div_main').append('<div class=sub_box2 id=' + id2 + ' style="overflow:auto;"></div>');	    						
    					}

   						var $div_sub = $("#"+"sub_box"+deviceGroupInfoList[i].device_grp_idx);
    					
    					// 장치그룹에 장치추가
    					addDeviceButton($div_sub, deviceGroupInfoList[i]);    					
    				}
    				
    				// 장치그룹별 장치추가버튼 추가
    				for(var i=0; i<deviceGroupInfoList.length; i++) {
   						var $div_sub = $("#"+"sub_box"+deviceGroupInfoList[i].device_grp_idx);
   						// 장치추가버튼 추가
   						addDevicePlusButton($div_sub, deviceGroupInfoList[i]);
    				}	    				
    			} else {
    				$div.append( '조회 결과가 없습니다' );
    			}
	   		},
			error:function(request,status,error){
				alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
			}
		});
	}
	
	function addDeviceButton() {
		$div_sub = arguments[0];
		var data = arguments[1];
		
		// 장치그룹에 장치추가
		getDevice2Info(data.device_id, data.device_grp_idx, data.device_type);
		
		if(data.alarm_type == 1) {
			var str = '';
			str += '<div class = "device_box_alarm1" style="cursor:pointer" onclick="showDevice2DetailInfo(';
			str += '\'';
			str += data.device_id; 
			str += '\'';
			str += ',';
			str += '\''; 
			str += data.device_grp_idx; 
			str += '\'';
			str += ',';
			str += '\''; 
			str += data.device_type; 
			str += '\'';
			str += ');">';
			str += showDevice2Info(data.device_id, data.device_grp_idx, data.device_type, data.device_name);
			str += '</div>';
			$div_sub.append(str);    							
		}
		else if(data.alarm_type == 2) {
			var str = '';
			str += '<div class = "device_box_alarm2" style="cursor:pointer" onclick="showDevice2DetailInfo(';
			str += '\'';
			str += data.device_id; 
			str += '\'';
			str += ',';
			str += '\''; 
			str += data.device_grp_idx; 
			str += '\'';
			str += ',';
			str += '\''; 
			str += data.device_type; 
			str += '\'';
			str += ');">';
			str += showDevice2Info(data.device_id, data.device_grp_idx, data.device_type, data.device_name);
			str += '</div>';
			$div_sub.append(str);    							
		}
		else {
			var str = '';
			str += '<div class = "device_box" style="cursor:pointer" onclick="showDevice2DetailInfo(';
			str += '\'';
			str += data.device_id; 
			str += '\'';
			str += ',';
			str += '\''; 
			str += data.device_grp_idx; 
			str += '\'';
			str += ',';
			str += '\''; 
			str += data.device_type; 
			str += '\'';
			str += ');">';
			str += showDevice2Info(data.device_id, data.device_grp_idx, data.device_type, data.device_name);
			str += '</div>';
			$div_sub.append(str);    							
		}	  		
	}
	
	function addDevicePlusButton() {
		$div_sub = arguments[0];
		var data = arguments[1];
		
		// 장치추가버튼 없으면 추가
		if($('#div_main').find("#device_add_to_grp_" + data.device_grp_idx).length==0) {
			var str = '';
			str += '<div id="device_add_to_grp_';
			str += data.device_grp_idx;
			str += '\"';
			str += ' class="device_box_add" style="cursor:pointer" onClick="addDevicePopup(';
			str += '\'';
			str += data.device_grp_idx
			str += '\'';
			str += ');">' 
			str += '+';
			str += '</div>';
			$div_sub.append(str);
		}		
	}


	function getDevice2Info() {
		//alert(' device id: ' + arguments[0] + ' group idx: ' + arguments[1] + ' device type: ' + arguments[2]);
	    $.ajax({
	        url: "/device2/getDevice2Info.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: {siteId:$("#siteId").val(),
	        	   deviceId:arguments[0],
	        	   deviceGrpIdx:arguments[1],
	        	   deviceType:arguments[2]
	        	   },
	        success: function (result) {
	        	var deviceInfoList = result.list;
    			if(deviceInfoList != null && deviceInfoList.length > 0) {
    				for(var i=0; i<deviceInfoList.length; i++) {
    					if(deviceInfoList[i].device_type == 'I') {
    						getDeviceInfoInverter(deviceInfoList[i]);
    					}
    					else if(deviceInfoList[i].device_type == '1') {
    						getDeviceInfoPCS(deviceInfoList[i]);    					
   						}
    					else if(deviceInfoList[i].device_type == '2') {
    						getDeviceInfoBMS(deviceInfoList[i]);    					
   						}
    					else if(deviceInfoList[i].device_type == '3') {
    						getDeviceInfoPV(deviceInfoList[i]);    					
   						}	    					
    					else {
    						$div_sub.empty();
    					}
    				}
    			}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });		
	}	
	
	
	function getDeviceInfoInverter() {
		var data = arguments[0];
 		var deviceMap = new myMap();
		
 		deviceMap.put("장치이름", data.device_name);
 		deviceMap.put("장치타입", data.device_type);
 		
		deviceMap.put("인버터 출력", data.now_pwr);
		deviceMap.put("태양광 입력", data.now_pwr);
		deviceMap.put("상태", data.connection_state);
		deviceMap.put("금일발전량", data.daily_pwr);
		
		deviceMap.put("R전압", data.ac_volt_r);
		deviceMap.put("S전압", data.ac_volt_s);
		deviceMap.put("T전압", data.ac_volt_t);
		deviceMap.put("주파수", data.hertz);
		
		deviceMap.put("R전류", data.ac_curr_r);
		deviceMap.put("S전류", data.ac_curr_s);
		deviceMap.put("T전류", data.ac_curr_t);
		deviceMap.put("전력", data.pv_watt);
		
 		(deviceGroupSiteMap.get(data.device_grp_idx)).put(data.device_id+'|'+data.device_type, deviceMap);		
	}
	
	function getDeviceInfoPCS() {
		var data = arguments[0];
		var deviceMap = new myMap();
		
		deviceMap.put("장치이름", data.device_name);
		deviceMap.put("장치타입", data.device_type);
		
		deviceMap.put("AC출력[전압]", data.ac_voltage);
		deviceMap.put("AC출력[전력]", data.ac_power);
		deviceMap.put("DC출력[전압]", data.dc_voltage);
		deviceMap.put("DC출력[전력]", data.dc_power);
		
		deviceMap.put("AC출력[전류]", data.ac_current);
		deviceMap.put("AC출력[주파수]", data.ac_freq);
		deviceMap.put("AC출력[전력설정치]", data.ac_set_power);
		deviceMap.put("AC출력[역률]", data.ac_pf);
		
		deviceMap.put("DC출력[전류]", data.dc_current);
		deviceMap.put("DC출력[주파수]", data.dc_freq);
		deviceMap.put("DC출력[전력설정치]", data.dc_set_power);
		deviceMap.put("DC출력[역률]", data.dc_pf);

		(deviceGroupSiteMap.get(data.device_grp_idx)).put(data.device_id+'|'+data.device_type, deviceMap);
	}	
	
	function getDeviceInfoBMS() {
		var data = arguments[0];
		var deviceMap = new myMap();
		
		deviceMap.put("장치이름", data.device_name);
		deviceMap.put("장치타입", data.device_type);
		
		deviceMap.put("SOC", data.sys_soc);
		deviceMap.put("SOC현재", data.curr_soc);
		deviceMap.put("SOH", data.sys_soh);
		deviceMap.put("DoD", data.dod);
		
		deviceMap.put("출력전압", data.sys_voltage);
		deviceMap.put("출력전류", data.sys_current);

		(deviceGroupSiteMap.get(data.device_grp_idx)).put(data.device_id+'|'+data.device_type, deviceMap);
	}		
	
	function getDeviceInfoPV() {
		var data = arguments[0];
		var deviceMap = new myMap();
		
		deviceMap.put("장치이름", data.device_name);
		deviceMap.put("장치타입", data.device_type);
		
		deviceMap.put("AC출력[전압]", data.ac_voltage);
		deviceMap.put("AC출력[전력]", data.ac_power);
		deviceMap.put("DC출력[전압]", data.dc_voltage);
		deviceMap.put("DC출력[전력]", data.dc_power);
		
		deviceMap.put("AC출력[전류]", data.ac_current);
		deviceMap.put("AC출력[주파수]", data.ac_freq);
		deviceMap.put("온도", data.temp);
		
		deviceMap.put("DC출력[전류]", data.dc_current);
		deviceMap.put("DC출력[주파수]", data.dc_freq);
		deviceMap.put("금일누적발전량", data.tot_power);

		(deviceGroupSiteMap.get(data.device_grp_idx)).put(data.device_id+'|'+data.device_type, deviceMap);
	}
	
	function showDevice2Info() {
		var id = arguments[0];
		var group_idx = arguments[1];
		var type = arguments[2];
		var name = arguments[3];
		var data = (deviceGroupSiteMap.get(group_idx)).get(id + '|' + type);	
		
		var str = "";

		if(data === undefined) {
			str += '<br/>';
			str += '장치타입: ' + getDeviceType(type) + '<br/>';
			str += '장치명: ' + name + '<br/>';
			str += '장치ID: ' + id + '<br/>';
			str += ' 상세정보 없음';

			return str;
		}

		if(type == 'I') {
			str += showDevice2InfoInverter(data);
		}
		else if(type == '1') {
			str += showDevice2InfoPCS(data);    					
		}
		else if(type == '2') {
			str += showDevice2InfoBMS(data);    					
		}
		else if(type == '3') {
			str += showDevice2InfoPV(data);    					
		}
		
		return str;
	}
	
	function showDevice2InfoInverter() {
		var data = arguments[0];
		str = "";

		str += '<br/>' + data.get("장치이름");
		str += '<br/>' + '(' + data.get("인버터 출력") + 'kw' + ')';
		str += '<br/>' + data.get("R전압") + 'V&nbsp;' + data.get("R전류") + 'A';
		
		return str;
	}	
	
	function showDevice2InfoPCS() {
		var data = arguments[0];
		str = "";
				
 		str += '<br/>' + data.get("장치이름");
		str += '<br/>' + '(' + data.get("AC출력[전력]") + 'W' + ')';
		str += '<br/>' + data.get("DC출력[전압]") + 'V&nbsp;' + data.get("DC출력[전류]") + 'A';

		return str;
	}	
	
	function showDevice2InfoBMS() {
		var data = arguments[0];
		str = "";

		str += '<br/>' + data.get("장치이름");
		str += '<br/>' + '(' + data.get("SOC현재") + 'kw' + ')';
		str += '<br/>' + data.get("출력전압") + 'V&nbsp;' + data.get("출력전류") + 'A';
		
		return str;
	}
	
	function showDevice2InfoPV() {
		var data = arguments[0];
		str = "";

		str += '<br/>' + data.get("장치이름");
		str += '<br/>' + '(' + data.get("금일누적발전량") + 'Wh' + ')';
		str += '<br/>' + data.get("DC출력[전압]") + 'V&nbsp;' + data.get("DC출력[전류]") + 'A';
		
		return str;
	}

	function showDevice2DetailInfo() {
		var id = arguments[0];
		var group_idx = arguments[1];
		var type = arguments[2];
		var data = (deviceGroupSiteMap.get(group_idx)).get(id + '|' + type);

		var $div_sub = $("#"+"sub_box"+group_idx+"_2");	    					
		$div_sub.empty();
		
		if(type == 'I') {
			showDevice2DetailInfoInverter($div_sub, data);
		}
		else if(type == 1) {
			showDevice2DetailInfoPCS($div_sub, data);    					
		}
		else if(type == 2) {
			showDevice2DetailInfoBMS($div_sub, data);    					
		}
		else if(type == 3) {
			showDevice2DetailInfoPV($div_sub, data);    					
		}	    					
		else {
			$div_sub.empty();
		}
	}
	
	function showDevice2DetailInfoInverter() {
		$div_sub = arguments[0];
		var data = arguments[1];
		
		$div_sub.append('<div class="sub2_top">');
			$div_sub.append('<div class="device_info">' + '인버터 출력: ' + data.get("인버터 출력") + 'kw' + '</div>');
			$div_sub.append('<div class="device_info">' + '태양광 입력: ' + data.get("태양광 입력") + 'kw' + '</div>');
			$div_sub.append('<div class="device_info">' + '상태: ' + data.get("상태") + '</div>');
			$div_sub.append('<div class="device_info">' + '금일발전량: ' + data.get("금일발전량") + 'kwh' + '</div>');
		$div_sub.append('</div>');
		
		$div_sub.append('<div class="sub2_bottom">');
			$div_sub.append('<div class="device_info_bottom">' 
					         + ' R전압: ' + data.get("R전압") + 'V' 
					         + ' S전압: ' + data.get("S전압") + 'V'
					         + ' T전압: ' + data.get("T전압") + 'V' 
					         + ' 주파수: ' + data.get("주파수") + 'Hz' 
					         + '</div>');
			$div_sub.append('<div class="device_info_bottom">' 
					         + ' R전류: ' + data.get("R전류") + 'A' 
					         + ' S전류: ' + data.get("S전류") + 'A' 
					         + ' T전류: ' + data.get("T전류") + 'A' 
					         + ' 전력: ' + data.get("전력") + 'kW' 
					         + '</div>');
		$div_sub.append('</div>');		
	}
	
	function showDevice2DetailInfoPCS() {
		$div_sub = arguments[0];
		var data = arguments[1];
		
		$div_sub.append('<div class="sub2_top">');
			$div_sub.append('<div class="device_info">' + 'AC출력[전압]: ' + data.get("AC출력[전압]") + 'V' + '</div>');
			$div_sub.append('<div class="device_info">' + 'AC출력[전력]: ' + data.get("AC출력[전력]") + 'W' + '</div>');
			$div_sub.append('<div class="device_info">' + 'DC출력[전압]: ' + data.get("DC출력[전압]") + 'V' + '</div>');
			$div_sub.append('<div class="device_info">' + 'DC출력[전력]: ' + data.get("DC출력[전력]") + 'W' + '</div>');
		$div_sub.append('</div>');
		
		$div_sub.append('<div class="sub2_bottom">');
			$div_sub.append('<div class="device_info_bottom">' 
					         + ' AC출력[전류]: ' + data.get("AC출력[전류]") + 'A' 
					         + ' AC출력[주파수]: ' + data.get("AC출력[주파수]") + 'Hz'
					         + ' AC출력[전력설정치]: ' + data.get("AC출력[전력설정치]") + 'W' 
					         + ' AC출력[역률]: ' + data.get("AC출력[역률]") 
					         + '</div>');
			$div_sub.append('<div class="device_info_bottom">' 
					         + ' DC출력[전류]: ' + data.get("DC출력[전류]") + 'A' 
					         + ' DC출력[주파수]: ' + data.get("DC출력[주파수]") + 'Hz'
					         + ' DC출력[전력설정치]: ' + data.get("DC출력[전력설정치]") + 'W' 
					         + ' DC출력[역률]: ' + data.get("DC출력[역률]") 
					         + '</div>');
		$div_sub.append('</div>');		
	}
	
	function showDevice2DetailInfoBMS() {
		$div_sub = arguments[0];
		var data = arguments[1];
		
		$div_sub.append('<div class="sub2_top">');
			$div_sub.append('<div class="device_info">' + 'SOC: ' + data.get("SOC") + '%' + '</div>');
			$div_sub.append('<div class="device_info">' + 'SOC현재: ' + data.get("SOC현재") + 'Wh' + '</div>');
			$div_sub.append('<div class="device_info">' + 'SOH: ' + data.get("SOH") + '%' + '</div>');
			$div_sub.append('<div class="device_info">' + 'DoD: ' + data.get("DoD") + '%' + '</div>');
		$div_sub.append('</div>');
		
		$div_sub.append('<div class="sub2_bottom">');
			$div_sub.append('<div class="device_info_bottom">' 
					         + ' 출력전압: ' + data.get("출력전압") + 'V' 
					         + '</div>');
			$div_sub.append('<div class="device_info_bottom">' 
						     + ' 출력전류: ' + data.get("출력전류") + 'A' 
					         + '</div>');
		$div_sub.append('</div>');		
	}
	
	function showDevice2DetailInfoPV() {
		$div_sub = arguments[0];
		var data = arguments[1];
		
		$div_sub.append('<div class="sub2_top">');
			$div_sub.append('<div class="device_info">' + 'AC출력[전압]: ' + data.get("AC출력[전압]") + 'V' + '</div>');
			$div_sub.append('<div class="device_info">' + 'AC출력[전력]: ' + data.get("AC출력[전력]") + 'W' + '</div>');
			$div_sub.append('<div class="device_info">' + 'DC출력[전압]: ' + data.get("DC출력[전압]") + 'V' + '</div>');
			$div_sub.append('<div class="device_info">' + 'DC출력[전력]: ' + data.get("DC출력[전력]") + 'W' + '</div>');
		$div_sub.append('</div>');
		
		$div_sub.append('<div class="sub2_bottom">');
			$div_sub.append('<div class="device_info_bottom">' 
					         + ' AC출력[전류]: ' + data.get("AC출력[전류]") + 'A' 
					         + ' AC출력[주파수]: ' + data.get("AC출력[주파수]") + 'Hz'
					         + ' 온도: ' + data.get("온도") + '℃' 
					         + '</div>');
			$div_sub.append('<div class="device_info_bottom">' 
						     + ' DC출력[전류]: ' + data.get("DC출력[전류]") + 'A' 
					         + ' DC출력[주파수]: ' + data.get("DC출력[주파수]") + 'Hz'
					         + ' 금일누적발전량: ' + data.get("금일누적발전량") + 'Wh' 
					         + '</div>');
		$div_sub.append('</div>');		
	}	
	
	
	
	function addDevicePopup() {
		$("#insertDeviceForm").find("#deviceGrpIdx").val( arguments[0] );
		popupOpen('add_device');
	}
	
	// popup
	$( function () {
		$("#confirmDeviceBtn").click(function(){
			var formData = $("#insertDeviceForm").serializeObject();
			if(confirm("장치를 저장하시겠습니까?")) {
				insertDevice2(formData);
			}
		});
		
		$("#cancelDeviceBtn, #cancelDeviceBtnX").click(function(){
			$('#insertDeviceForm').each(function() {
				this.reset();
			});
			$("#deviceGrpIdx").val( "" );
			
			popupClose('add_device');
		});
	});
	
	// 장지 등록
	function insertDevice2(formData) {
	    $.ajax({
	        url: "/device2/insertDevice2.json",
	        type: 'post',
	        async: false, // 동기로 처리해줌
	        data: formData,
	        success: function (result) {
	        	var resultCnt = result.resultCnt;
	    		var resultMsg = result.resultMsg;
	    		var resultCode = result.resultCode;
	    		
	    		if(resultCode === 0) {
	    			if(resultCnt > 0) {
	    				alert("저장되었습니다.");
	    				location.reload();
	    			} else {
	    				alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
	    			}
	    		} else {
	    			alert(resultMsg);
	    		}
	        },
	        error: function (request, status, error) {
	            alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
	        }
	    });
	}	
	
</script>	










<%------------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------------------------------------------------------------------------%>
<%------------------------------------------------------------------------------------------------------------------%>

	
	
<!-- <div class="dg_wrap" id="div_main" style="overflow:auto;"> -->
<div class="dg_wrap" id="div_main">
<!-- 	<div id="div_sub"></div> -->
</div>




    <!-- ###### 신규장치 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="add_device" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 장치 등록</h2>        	
			<a href="#;" id="cancelDeviceBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="insertDeviceForm" name="insertDeviceForm">
					<input type="hidden" name="deviceGrpIdx" id="deviceGrpIdx" class="input" value="">
					<input type="hidden" id="siteId" name="siteId">
					<table>
						<colgroup>
							<col width="200">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>사이트</span></th>
								<td>
									<select name="siteIdName" id="siteIdName" class="sel" style="width:100%">
										<option value="1">${selViewSite.site_name}</option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span>장치명</span></th>
								<td><input type="text" id="deviceName" name="deviceName" class="input" style="width:100%"></td>
							</tr>
							<tr>
								<th><span>장치ID</span></th>
								<td><input type="text" id="deviceId" name="deviceId" class="input" style="width:100%"></td>
							</tr>
							<tr>
								<th><span>장치타입</span></th>
								<td>
									<select name="deviceType" id="deviceType" class="sel" style="width:100%">
										<option value="1">PCS</option>
										<option value="2">BMS</option>
										<option value="3">PV</option>
										<option value="4">부하측정기기</option>
										<option value="5">PV모니터링기기</option>
										<option value="6">ESS모니터링기기</option>
										<option value="7">iSmart</option>
										<option value="8">총량기기</option>
										<option value="9">AMI</option>
										<option value="S">접속반</option>
										<option value="I">인버터</option>
										<option value="A">ACB</option>
										<option value="V">VCB</option>										
									</select>
								</td>
							</tr>
						</tbody>			
					</table>
				</form>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmDeviceBtn">확인</a>
			<a href="#;" class="cancel_btn w80" id="cancelDeviceBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->  