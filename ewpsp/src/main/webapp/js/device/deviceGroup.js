	$(document).ready(function() {
		getDBData();
	});
	
	function getDBData() {
		getDeviceGroupList();
		
	}
	
	// 장치그룹목록 조회
	function callback_getDeviceGroupList(result) {
		var deviceGroupList = result.list;
		
		$div = $(".dg_wrap");
		$div.empty();
		if(deviceGroupList == null || deviceGroupList.length < 1) {
			$div.append( '<h2 class="dtit">조회된 데이터가 없습니다.</h2>' );
		} else {
			for(var i=0; i<deviceGroupList.length; i++) {
				$div.append( '<h2 class="dtit">'+deviceGroupList[i].device_grp_name+'</h2>' );
				getDvInDeviceGroupList(deviceGroupList[i].device_grp_idx);
				
				$('.dsec').last().append(
						$('<div class="fr clear" />').append(
								$('<dl class="aler fl" />').append(
										'<dt><span>ALERT</span> <em>0</em></dt>'+
										'<dd><p></p></dd>'
								)
						).append(
								$('<dl class="warn fr" />').append(
										'<dt><span>WARNNING</span> <em>1</em></dt>'+
										'<dd><p>PCS_1</p></dd>'
								)
						)
				)
				
			}
			
		}
		
	}
	
	function callback_getDvInDeviceGroupList(result) {
		var deviceList = result.list;
		console.log("deviceList : "+deviceList);

		var addHtml = "";
		if(deviceList == null || deviceList.length < 1) {
			addHtml += "조회된 데이터가 없습니다.";
		} else {
			for(var i=0; i<deviceList.length; i++) {
				var strHtml = ""
				if(deviceList[i].device_type == 4) strHtml = '<li class="ioe">'; 
				else if(deviceList[i].device_type == 1) strHtml = '<li class="pcs">'; 
				else if(deviceList[i].device_type == 2) strHtml = '<li class="bms">'; 
				else if(deviceList[i].device_type == 3) strHtml = '<li class="pv">';
				else strHtml = '<li class="ioe">';
				
				addHtml += strHtml;
				addHtml += '<a href="#"></a>';
				addHtml += '<span class="dname">'+deviceList[i].device_name+'</span>';
				addHtml += '<span class="dmemo">'+""+'</span>';
				addHtml += '</li>';
				console.log("addHtml : "+addHtml);
			}
			
		}
		
		$(".dg_wrap").append( $('<div class="dsec clear" />').append(
				$('<div class="fl" />').append( $('<ul class="device clear" />').append(addHtml) ).append(
						$('<div class="new_add" />').append( '<a href="javascript:insertDeviceForm();"><i class="glyphicon glyphicon-plus"></i></a>' )
				)
		) )
		
	}
	
	function insertDeviceForm() {
		getSitePopupList("");
		popupOpen('ddevice');
	}

	function callback_getSitePopupList(result) {
//		var grpSiteList = result.grpSiteList;
		var allSiteList = result.allSiteList;
		
		$siteIdSelBox = $("#siteId");
		$siteIdSelBox.empty();
		if(allSiteList == null || allSiteList.length < 1) {
			
		} else {
			for(var i=0; i<allSiteList.length; i++) {
				$siteIdSelBox.append('<option value="'+allSiteList[i].site_id+'">'+allSiteList[i].site_name+'</option>')
				
			}
			
		}
		
	}
