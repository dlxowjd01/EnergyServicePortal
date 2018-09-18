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
		
	    $('.dsec .device').bxSlider({
	        mode:'horizontal',
	        pager:false,
	        slideWidth: 130,
	        slideMargin: 20,
	        minSlides: 1,
	        maxSlides: 8,
	        moveSlides: 1,
	        pause: 4000,
	        auto:false,
	        controls: true,
	        infiniteLoop: false
	    });
		
	}
	
	function callback_getDvInDeviceGroupList(result) {
		var deviceList = result.list;
		console.log("deviceList : "+deviceList);

		var addHtml = "";
		if(deviceList == null || deviceList.length < 1) {
			addHtml += "조회된 데이터가 없습니다.";
		} else {
			var deviceGroupIdx = "";
			for(var i=0; i<deviceList.length; i++) {
				if(i == 0) deviceGroupIdx = deviceList[i].device_grp_idx;
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
						$('<div class="new_add" />').append( '<a href="javascript:insertDeviceForm(\''+deviceGroupIdx+'\');"><i class="glyphicon glyphicon-plus"></i></a>' )
				)
		) )
		
	}
	
	function insertDeviceForm(deviceGrpIdx) {
		insUpdFlag = 1;
		$("#insertDeviceForm").find("#deviceGrpIdx").val( deviceGrpIdx );
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

	var insUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	$( function () {
//		$("#grpMngFormBtn").click(function(){
////			getGroupPopupList();
////			getSitePopupList(3);
//			popupOpen('dgroup');
//		});
		
//		$("#insertGrpFormBtn").click(function(){
//			insUpdFlag = 1;
//			popupOpen('dgroup_add');
//		});
//		
////		$("#insertSiteFormBtn").click(function(){
////			insUpdFlag = 1;
////			popupOpen('ddevice');
////		});
		
//		$("#confirmGrpBtn").click(function(){
//			var formData = $("#groupForm").serializeObject();
//			if(confirm("그룹을 저장하시겠습니까?")) {
//				if(insUpdFlag ==  1) insertGroup(formData);
//				else if(insUpdFlag ==  2)  updateGroup(formData);
//			}
//		});
		
		$("#confirmDeviceBtn").click(function(){
			var formData = $("#insertDeviceForm").serializeObject();
			if(confirm("장치를 저장하시겠습니까?")) {
				if(insUpdFlag ==  1) insertDevice(formData);
				else if(insUpdFlag ==  2)  updateDevice(formData);
			}
		});
		
//		$("#cancelGrpBtn").click(function(){
//			popupClose('dgroup_add');
//			if(insUpdFlag == 2) {
//				$('#mask').hide();
//			}
//			
//			insUpdFlag = 0;
//			$('#groupForm').each(function() {
//				this.reset();
//			});
//			$("#userIdx").val( "1" );
//			
////			popupClose('dgroup_add');
//		});
		
		$("#cancelDeviceBtn").click(function(){
			insUpdFlag = 0;
			$('#insertDeviceForm').each(function() {
				this.reset();
			});
			$("#deviceGrpIdx").val( "" );
			
			popupClose('ddevice');
		});
	});
	
	function callback_insertDevice(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
