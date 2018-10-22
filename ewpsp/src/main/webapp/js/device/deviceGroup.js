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
		    
		    $(".device li").click(function() {
		        $(this).toggleClass("on");
		        var del_num = $(this).parent('.device').children('.on').length;
		        //alert(del_num);
		        if(del_num > 0) {
		            $(this).parent().parent().parent().siblings('.device_del').show();
		        } else {
		            $(this).parent().parent().parent().siblings('.device_del').hide();
		        }
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
								$("<li />").append('<a href="#;" onclick="selectBoxTextApply(this);changeSelDeviceGrp(\''+deviceGroupList[i].device_grp_idx+'\');">'+deviceGroupList[i].device_grp_name+'</a>')
						);
						
					}
					
				}
				
			} else if(siteViewFlag == 3) {
				$tbody = $("#dvGrpTbody");
				$tbody.empty();
				if(deviceGroupList == null || deviceGroupList.length < 1) {
					$tbody.append( '<tr><td colspan="3">조회된 데이터가 없습니다.</td><tr>' );
				} else {
					var dvGrps = "";
					for(var i=0; i<deviceGroupList.length; i++) {
						$("#selectSiteId").val(deviceGroupList[i].site_id);
						dvGrps = dvGrps+deviceGroupList[i].device_grp_idx+",";
						$tbody.append(
								$('<tr />').append( 
										$("<td />").append( (i+1) )
								).append( $("<td />").append( 
										deviceGroupList[i].device_grp_name+'<input type="hidden" name="dvGrpIds" value="'+deviceGroupList[i].device_grp_idx+'">' 
										)
								).append(
										$("<td />").append( '<a href="#;" onclick="deleteLine(this);"><i class="glyphicon glyphicon-remove"></i></a>' )
								)
						);
					}
					$("#nowDvGrpIds").val(dvGrps.slice(0, -1));
					
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
				else if(deviceList[i].device_type == 1) strHtml = '<li class="pcs" ondblclick="goLEMSPage(\'/lems/setting/pcs\')">'; 
				else if(deviceList[i].device_type == 2) strHtml = '<li class="bms" ondblclick="goLEMSPage(\'/lems/setting/bat\')">'; 
				else if(deviceList[i].device_type == 3) strHtml = '<li class="pv" ondblclick="goLEMSPage(\'/lems/setting/pv\')">';
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
				).append(
						$('<div class="device_del" />').append( '<a href="#;"><i class="glyphicon glyphicon-remove-circle"></i><em>삭제</em></a>' )
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
							$("<li />").append('<a href="#;" onclick="selectBoxTextApply(this);changeSelSite(\''+grpSiteList[i].site_id+'\');">'+grpSiteList[i].site_name+'</a>')
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
							$("<li />").append('<a href="#;" onclick="selectBoxTextApply(this);changeSelSite(\''+grpSiteList[i].site_id+'\');">'+grpSiteList[i].site_name+'</a>')
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
			siteViewFlag = 2;
			$('#editDvGrpForm').each(function() {
				this.reset();
			});
			$("#dvGrpTbody").empty().append('<tr><td colspan="3">사이트를 선택해주세요</td></tr>');
			$('#insideSite2').find("button").empty().append("사이트 선택").append( $('<span class="caret" />') );
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
		
		$("#addDvGrpTbodyBtn").click(function(){
			if($("#selectSiteId").val() == null || $("#selectSiteId").val() == "") {
				alert("장치그룹을 추가할 사이트를 선택해주세요");
				return;
			}
			if($("#deviceGrpName").val() == null || $("#deviceGrpName").val() == "") {
				alert("장치그룹명을 입력해주세요");
				return;
			}
			
			var deviceGrpName = $("#deviceGrpName").val();
			$("#dvGrpTbody").prepend(
					$('<tr />').append( 
							$("<td />").append(  )
					).append( $("<td />").append( deviceGrpName+'<input type="hidden" name="dvGrpNms" value="'+deviceGrpName+'">' )
					).append(
							$("<td />").append( '<a href="#;" onclick="deleteLine(this);"><i class="glyphicon glyphicon-remove"></i></a>' )
					)
			);
			$("#deviceGrpName").val("");
		});
		
		$("#confirmDvGrpBtn").click(function(){
			var formData = $("#editDvGrpForm").serializeObject();
			if(confirm("장치그룹을 저장하시겠습니까?")) {
				var inputs1 = $("#editDvGrpForm input[name=dvGrpIds]");
				var values = "";
				$.each(inputs1, function (index, value) {
					values = values+$(value).val()+",";
				});
				$("#newDvGrpIds").val(values.slice(0, -1));
				
				var inputs2 = $("#editDvGrpForm input[name=dvGrpNms]");
				var values2 = "";
				$.each(inputs2, function (index, value) {
					values2 = values2+$(value).val()+",";
				});
				$("#newDvGrpNms").val(values2.slice(0, -1));
				
				var formData = $("#editDvGrpForm").serializeObject();
				saveDvGrp(formData);
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
			
			siteViewFlag = 0;
			$('#editDvInDvGrpForm').each(function() {
				this.reset();
			});
			$(".inside_site").find("ul").empty();
			$('.all_site').find("ul").empty();
			$('#insideSite').find("button").empty().append("사이트 선택").append( $('<span class="caret" />') );
			$('#insideDeviceGrp').find("button").empty().append("장치그룹 선택").append( $('<span class="caret" />') );
			
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
		if(siteViewFlag == 2) {
			$("#selSiteId").val(siteId);
			$(".inside_site").find("ul").empty();
			$(".all_site").find("ul").empty();	
			
		} else if(siteViewFlag == 3) {
			$("#editDvGrpForm").find("#selectSiteId").val( siteId );
		}
		
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
		
	    $(".multi_select a").click(function() {
	        $(this).toggleClass("on");
	        return false;
	    });
	}
	
	function deleteLine(obj) {
	    var tr = $(obj).parent().parent();
	 
	    //라인 삭제
	    tr.remove();
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
	
	function saveDvGrp(formData) {
		$.ajax({
			url : "/saveDvGrp",
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
