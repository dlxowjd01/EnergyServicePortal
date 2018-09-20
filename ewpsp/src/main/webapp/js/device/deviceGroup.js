	$(document).ready(function() {
		getDBData();
	});
	
	var popupYn = "N";
	function getDBData() {
		getDeviceGroupList();
		
	}
	
	// 장치그룹목록 조회
	function callback_getDeviceGroupList(result) {
		var deviceGroupList = result.list;
		
		if(popupYn == "N") {
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
			
		} else if(popupYn == "Y") {
			if(siteViewFlag == 2) {
				$insideSite = $("#insideDeviceGrp");
				$insideSite.find("ul").empty();
				if(deviceGroupList == null || deviceGroupList.length < 1) {
//					$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
				} else {
					for(var i=0; i<deviceGroupList.length; i++) {
						$insideSite.find("ul").append(
								$("<li />").append('<a href="javascript:changeSelDeviceGrp(\''+deviceGroupList[i].device_grp_idx+'\');">'+deviceGroupList[i].device_grp_name+'</a>')
						);
						
					}
					
				}
				
			} else if(siteViewFlag == 3) {
				$tbody = $("#dvGrpTbody");
				$tbody.empty();
				if(deviceGroupList == null || deviceGroupList.length < 1) {
					$tbody.append( '<tr><td colspan="3">조회된 데이터가 없습니다.</td><tr>' );
				} else {
					for(var i=0; i<deviceGroupList.length; i++) {
						var device_stat = (deviceGroupList[i].device_stat == 1) ? "connect" : "disconnect";
						$tbody.append(
								$('<tr />').append( $("<td />").append( (i+1) )
								).append( $("<td />").append( deviceGroupList[i].device_grp_name )
								).append(
//										$("<td />").append( '<a href="#;" onclick="getDeviceIOEDetail(\''+deviceGroupList[i].device_ioe_idx+'\');" class="detail_view">상세보기</a>' )
										$("<td />").append( '<a href="#;" onclick=""><i class="glyphicon glyphicon-remove"></i></a>' )
								)
						);
					}
					
				}
				
			}
			
		}
		
	}
	
	function callback_getDvInDeviceGroupList(result) {
		var deviceList = result.list;

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
			}
			
		}
		
		$(".dg_wrap").append( $('<div class="dsec clear" />').append(
				$('<div class="fl" />').append( $('<ul class="device clear" />').append(addHtml) ).append(
						$('<div class="new_add" />').append( '<a href="javascript:insertDeviceForm(\''+deviceGroupIdx+'\');"><i class="glyphicon glyphicon-plus"></i></a>' )
				)
		) )
		
	}
	
	function insertDeviceForm(deviceGrpIdx) {
		siteViewFlag = 1;
		$("#insertDeviceForm").find("#deviceGrpIdx").val( deviceGrpIdx );
		getSitePopupList("");
		popupOpen('ddevice');
	}

	function callback_getSitePopupList(result) {
		var grpSiteList = result.grpSiteList;
		var allSiteList = result.allSiteList;
		
		if(siteViewFlag == 1) {
			$siteIdSelBox = $("#siteId");
			$siteIdSelBox.empty();
			if(allSiteList == null || allSiteList.length < 1) {
				
			} else {
				for(var i=0; i<allSiteList.length; i++) {
					$siteIdSelBox.append('<option value="'+allSiteList[i].site_id+'">'+allSiteList[i].site_name+'</option>')
					
				}
				
			}
			
		} else if(siteViewFlag == 2) {
			$insideSite = $("#insideSite");
			$insideSite.find("ul").empty();
			if(grpSiteList == null || grpSiteList.length < 1) {
//				$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
			} else {
				for(var i=0; i<grpSiteList.length; i++) {
					$insideSite.find("ul").append(
							$("<li />").append('<a href="javascript:changeSelSite(\''+grpSiteList[i].site_id+'\');">'+grpSiteList[i].site_name+'</a>')
					);
					
				}
				
			}
			
		} else if(siteViewFlag == 3) {
			$insideSite = $("#insideSite2");
			$insideSite.find("ul").empty();
			if(grpSiteList == null || grpSiteList.length < 1) {
//				$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
			} else {
				for(var i=0; i<grpSiteList.length; i++) {
					$insideSite.find("ul").append(
							$("<li />").append('<a href="javascript:changeSelSite(\''+grpSiteList[i].site_id+'\');">'+grpSiteList[i].site_name+'</a>')
					);
					
				}
				
			}
		}
		
	}

	var siteViewFlag = 0; // 1:신규장치등록, 2:장치그룹관리, 3:장치그룹편집
	$( function () {
		
		$("#grpMngFormBtn").click(function(){
			siteViewFlag = 2;
			getSitePopupList("");
			popupOpen('dgdevice');
		});
		
		$("#editDvGrpFormBtn").click(function(){
			siteViewFlag = 3;
			getSitePopupList("");
			popupOpen('dgdevice_edit');
		});
		
		$("#cancelDvGrpBtn, #cancelDvGrpBtnX").click(function(){
//			siteViewFlag = 1;
			$('#editDvGrpForm').each(function() {
				this.reset();
			});
			$("#dvGrpTbody").empty().append('<tr><td colspan="3">사이트를 선택해주세요</td></tr>');
			popupClose('dgdevice_edit');
		});
		
		$("#confirmDvInDbGrpBtn").click(function(){
			if(confirm("저장하시겠습니까?")) {
				var inputs = $(".inside_site input[name=deviceIds]");
				var values = "";
				$.each(inputs, function (index, value) {
					values = values+$(value).val()+",";
				});
				$("#newDeviceIds").val(values.slice(0, -1));
				var formData = $("#editDvInDvGrpForm").serializeObject();
				saveDvInDvGrp(formData);
			}
		});
		
		$("#confirmDvGrpBtn").click(function(){
			var formData = $("#groupForm").serializeObject();
			if(confirm("장치그룹을 저장하시겠습니까?")) {
//				if(siteViewFlag ==  1) insertGroup(formData);
//				else if(siteViewFlag ==  2)  updateGroup(formData);
			}
		});
		
		$("#confirmDeviceBtn").click(function(){
			var formData = $("#insertDeviceForm").serializeObject();
			if(confirm("장치를 저장하시겠습니까?")) {
				if(siteViewFlag ==  1) insertDevice(formData);
				else if(siteViewFlag ==  2)  updateDevice(formData);
			}
		});
		
		$("#cancelDvInDbGrpBtn, #cancelDvInDbGrpBtnX").click(function(){
			popupClose('dgdevice');
//			if(siteViewFlag == 2) {
//				$('#mask').hide();
//			}
			
			siteViewFlag = 0;
			$('#editDvInDvGrpForm').each(function() {
				this.reset();
			});
			$(".inside_site").find("ul").empty();
			$('.all_site').find("ul").empty();
			
//			popupClose('dgroup_add');
		});
		
		$("#cancelDeviceBtn, #cancelDeviceBtnX").click(function(){
			siteViewFlag = 0;
			$('#insertDeviceForm').each(function() {
				this.reset();
			});
			$("#deviceGrpIdx").val( "" );
			
			popupClose('ddevice');
		});
	});

	function changeSelSite(siteId) {
		popupYn = "Y";
		$("#selSiteId").val(siteId);
		getDeviceGroupList(siteId);
	}
	
	function changeSelDeviceGrp(deviceGrpIdx) {
		$("#selDvGrpIdx").val(deviceGrpIdx)
		
		var selSiteId = $("#selSiteId").val();
		var selDvGrpIdx = $("#selDvGrpIdx").val();
		
		getDvInDeviceGroupPopupList(selSiteId, selDvGrpIdx);
	}
	
	function callback_getDvInDeviceGroupPopupList(result) {
		var grpSiteList = result.dvInDeviceGrouplist;
		var allSiteList = result.allDvInSiteList;
		
		$insideSite = $(".inside_site");
		$insideSite.find("ul").empty();
		if(grpSiteList == null || grpSiteList.length < 1) {
//			$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
		} else {
			var devices = "";
			for(var i=0; i<grpSiteList.length; i++) {
				devices = devices+grpSiteList[i].device_id+",";
				$insideSite.find("ul").append(
						$("<li />").append('<a href="#;">'+grpSiteList[i].device_name+'</a>').append(
								'<input type="hidden" name="deviceIds" value="'+grpSiteList[i].device_id+'">'
						)
				);
				
			}
			$("#nowDeviceIds").val(devices.slice(0, -1));
			
		}
		
		$allSite = $(".all_site");
		$allSite.find("ul").empty();
		if(allSiteList == null || allSiteList.length < 1) {
//			$tbody.append( '<tr><td colspan="6">조회된 데이터가 없습니다.</td><tr>' );
		} else {
			for(var i=0; i<allSiteList.length; i++) {
				$allSite.find("ul").append(
						$("<li />").append('<a href="#;">'+allSiteList[i].device_name+'</a>').append(
								'<input type="hidden" name="deviceIds" value="'+allSiteList[i].device_id+'">'
						)
				);
				
			}
			
		}
		
	    $(".multi_select a,").click(function() {
	        $(this).toggleClass("on");
	        return false;
	    });
	}
	
	function saveDvInDvGrp(formData) {
		$.ajax({
			url : "/saveDvInDvGrp",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultCnt = result.resultCnt;
				var changeYn = result.changeYn;
				
				if(changeYn == "N") {
					alert("저장되었습니다.");
					location.reload();
					
				} else if(changeYn == "Y") {
//					if(resultCnt > 0) {
						alert("저장되었습니다.");
						location.reload();
//					} else {
//						alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
//					}
				}
				
			}
		});
	}
	
	function callback_insertDevice(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
