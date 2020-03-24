<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	$(document).ready(function() {
		getDBData();
	});
	
	var popupYn = "N";
	function getDBData() {
		getDeviceNotInGroupList();
		getDeviceGroupList();
		
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
	        infiniteLoop: false,
	        touchEnabled : (navigator.maxTouchPoints > 0) // 또는 false
	    });
		
		$(".device li").click(function() {
	        $(this).toggleClass("on");
	        var del_num = $(this).parent('.device').children('.on').length;
	        
	        if(del_num > 0) {
	            $(this).parent().parent().parent().siblings('.device_del').show();
	        } else {
	            $(this).parent().parent().parent().siblings('.device_del').hide();
	        }
	    });
	}
	
	// 장치그룹에 속하지 않은 장치목록 조회
	function getDeviceNotInGroupList() {
		$.ajax({
			url : "/getDeviceNotInGroupList",
			type : 'post',
			async : false, // 동기로 처리해줌
			success: function(result) {
				$(".dg_wrap").html( '<h2 class="dtit">그룹 없음</h2>' );
				callback_getDvInDeviceGroupList(result, 0);
				
				getDeviceGrpAlarmList(0);
	   		}
		});
		
	}
	
	// 장치그룹목록 조회
	function callback_getDeviceGroupList(result) {
		var deviceGroupList = result.list;
		
		if(popupYn === "N") {
			var $div = $(".dg_wrap");
			if(deviceGroupList != null && deviceGroupList.length > 0) {
				for(var i=0; i<deviceGroupList.length; i++) {
					$div.append( '<h2 class="dtit">'+deviceGroupList[i].device_grp_name+'</h2>' );
					getDvInDeviceGroupList(deviceGroupList[i].device_grp_idx);
					
					getDeviceGrpAlarmList(deviceGroupList[i].device_grp_idx);
				}
			} else {
				$div.append( '<h2 class="dtit">조회 결과가 없습니다.</h2>' );
			}
			
		} else if(popupYn === "Y") {
			if(siteViewFlag === 2) {
				var $insideSite = $("#insideDeviceGrp");
				$insideSite.find("ul").empty();
				if(deviceGroupList != null && deviceGroupList.length > 0) {
					for(var i=0; i<deviceGroupList.length; i++) {
						$insideSite.find("ul").append(
								$("<li />").append('<a href="#;" onclick="selectBoxTextApply(this);changeSelDeviceGrp(\''+deviceGroupList[i].device_grp_idx+'\');">'+deviceGroupList[i].device_grp_name+'</a>')
						);
					}
				} else {
	//				$tbody.append( '<tr><td colspan="6">조회 결과가 없습니다.</td><tr>' );
				}
				
			} else if(siteViewFlag === 3) {
				var $tbody = $("#dvGrpTbody");
				$tbody.empty();
				if(deviceGroupList != null && deviceGroupList.length > 0) {
					var dvGrps = "";
					for(var i=0; i<deviceGroupList.length; i++) {
						$("#selectSiteId").val(deviceGroupList[i].site_id);
						dvGrps = dvGrps+deviceGroupList[i].device_grp_idx+",";
						$tbody.append(
								$('<tr />').append(  $("<td />").append( (i+1) )
								)
										.append($('<td />').append('<a href="#;" onclick="updateDvGrpForm(' + deviceGroupList[i].device_grp_idx + ', \''+deviceGroupList[i].device_grp_name+'\')">' + deviceGroupList[i].device_grp_name + '</a>'))
										.append($('<td />').append('<a href="#;" onclick="deleteDvGrp(' + deviceGroupList[i].device_grp_idx + ')"><i class="glyphicon glyphicon-remove"></i></a>'))
						);
					}
					$("#nowDvGrpIds").val(dvGrps.slice(0, -1));
				} else {
					$tbody.append( '<tr><td colspan="3">조회 결과가 없습니다.</td><tr>' );
				}
				
			}
			
		}
		
	}
	
	function callback_getDvInDeviceGroupList(result, deviceGrpIdx) {
		var deviceList = result.list;
	
		var addHtml = "";
		if(deviceList != null && deviceList.length > 0) {
			for(var i=0; i<deviceList.length; i++) {
				var strHtml = ""
				if(deviceList[i].device_type === 4) strHtml = '<li class="ioe">';
				else if(deviceList[i].device_type === 1) strHtml = '<li class="pcs" ondblclick="goLEMSPage(\'/lems/setting/pcs\')">';
				else if(deviceList[i].device_type === 2) strHtml = '<li class="bms" ondblclick="goLEMSPage(\'/lems/setting/bat\')">';
				else if(deviceList[i].device_type === 3) strHtml = '<li class="pv" ondblclick="goLEMSPage(\'/lems/setting/pv\')">';
				else strHtml = '<li class="ioe">';
				
				addHtml += strHtml;
				addHtml += '<a href="#;" onclick="addDelDvs(\''+deviceList[i].site_id+'\', \''+deviceList[i].device_id+'\', \''+deviceList[i].device_type+'\', this);"></a>';
				addHtml += '<input type="hidden" name="delDevice_'+deviceGrpIdx+'">';
				addHtml += '<span class="dname">'+deviceList[i].device_name+'</span>';
				addHtml += '<span class="dmemo">'+""+'</span>';
				addHtml += '</li>';
			}
			
		} else {
			addHtml += "조회 결과가 없습니다.";
		}
		
		var str = '';
		str += '';
		str += '';
		str += '<div class="dsec clear">';
		str += '<div class="fl">';
		str += '<ul class="device clear">';
		str += addHtml;
		str += '</ul>'; // device clear
		if(sessionUser.auth_type !== 5) {
			str += '<div class="new_add">';
			str += '<a href="javascript:insertDeviceForm(\''+deviceGrpIdx+'\');"><i class="glyphicon glyphicon-plus"></i></a>';
			str += '</div>'; // new_add
			str += '<div class="device_del">';
			str += '<a href="#;" onclick="deleteDeviceInGrp(\''+deviceGrpIdx+'\');"><i class="glyphicon glyphicon-remove-circle"></i><em>삭제</em></a>';
			str += '<input type="hidden" id="delDevices_'+deviceGrpIdx+'" name="delDevices_'+deviceGrpIdx+'">';
			str += '</div>'; // device_del
		}
		str += '</div>'; // fl
		str += '</div>'; // dsec
		$(".dg_wrap").append(str);
		
	}
	
	function getDeviceGrpAlarmList(deviceGrpIdx) {
		$.ajax({
			url : "/getDeviceGrpAlarmList",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				deviceGrpIdx : deviceGrpIdx
			},
			success: function(result) {
				var warningList = result.warningList;
				var alertList = result.alertList;
				
				var warningCnt = 0;
				var alertCnt = 0;
				var warningStr = "";
				var alertStr = "";
				if(warningList != null && warningList.length > 0) {
					for(var i=0; i<warningList.length; i++) {
						warningStr += "<p>"+warningList[i].device_name+"</p>";
						warningCnt = warningCnt+warningList[i].cnt;
					}
				}
				if(alertList != null && alertList.length > 0) {
					for(var i=0; i<alertList.length; i++) {
						alertStr += "<p>"+alertList[i].device_name+"</p>";
						alertCnt = alertCnt+alertList[i].cnt;
					}
				}
				
				$('.dsec').last().append(
						$('<div class="fr clear" />').append( $('<dl class="aler fl" />').append(
								'<dt><span>ALERT</span> <em>'+alertCnt+'</em></dt><dd>'+alertStr+'</dd>' )
						).append( $('<dl class="warn fr" />').append(
								'<dt><span>WARNNING</span> <em>'+warningCnt+'</em></dt><dd>'+warningStr+'</dd>' )
						)
				)
			}
		});
	}
	
	function insertDeviceForm(deviceGrpIdx) {
		siteViewFlag = 1;
		$("#insertDeviceForm").find("#deviceGrpIdx").val( deviceGrpIdx );
		getDeviceGrpSitePopupList("");
		popupOpen('ddevice');
	}
	
	function addDelDvs(siteId, deviceId, deviceType, obj) {
		if($(obj).parent().hasClass('on') === true) {
			$(obj).siblings('input').val("");
		} else {
			$(obj).siblings('input').val(siteId+"|"+deviceId+"|"+deviceType);
		}
	}
	
	function deleteDeviceInGrp(deviceGrpIdx) {
		var inputs = $("input[name=delDevice_"+deviceGrpIdx+"]");
		var values = "";
		$.each(inputs, function (index, value) {
			if($(value).val() != null && $(value).val() !== "") {
				values = values+$(value).val()+",";
			}
		});
		var $delDevices_ = $("#delDevices_"+deviceGrpIdx);
		$delDevices_.val(values.slice(0, -1));
		
		if(confirm("선택한 장치들을 삭제하시겠습니까?")) {
			$.ajax({
				url : "/deleteDevices",
				type : 'post',
				async : false, // 동기로 처리해줌
				data : {
					delDevices : $delDevices_.val()
				},
				success: function(result) {
					var resultCnt = result.resultCnt;
					if(resultCnt > 0) {
						alert("삭제되었습니다.");
						location.reload();
					} else {
						alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
					}
				}
			});
		}
		
	}
	
	//사이트 목록(팝업) 조회
	function getDeviceGrpSitePopupList(siteGrpIdx) {
		$.ajax({
			url : "/getDeviceGrpSitePopupList",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				siteGrpIdx : siteGrpIdx
			},
			success: function(result) {
				callback_getDeviceGrpSitePopupList(result);
			}
		});
	}
	
	function callback_getDeviceGrpSitePopupList(result) {
		var grpSiteList = result.grpSiteList;
		var allSiteList = result.allSiteList;
		
		if(siteViewFlag === 1) {
			$siteIdSelBox = $("#siteId");
			$siteIdSelBox.empty();
			if(grpSiteList != null && grpSiteList.length > 0) {
				for(var i=0; i<grpSiteList.length; i++) {
					$siteIdSelBox.append('<option value="'+grpSiteList[i].site_id+'">'+grpSiteList[i].site_name+'</option>')
					
				}
				
			}
			
		} else if(siteViewFlag === 2) {
			$insideSite = $("#insideSite");
			$insideSite.find("ul").empty();
			if(grpSiteList != null && grpSiteList.length > 0) {
				for(var i=0; i<grpSiteList.length; i++) {
					$insideSite.find("ul").append(
							$("<li />").append('<a href="#;" onclick="selectBoxTextApply(this);changeSelSite(\''+grpSiteList[i].site_id+'\');">'+grpSiteList[i].site_name+'</a>')
					);
					
				}
				
			}
			
		} else if(siteViewFlag === 3) {
			$insideSite = $("#insideSite2");
			$insideSite.find("ul").empty();
			if(grpSiteList != null && grpSiteList.length > 0) {
				for(var i=0; i<grpSiteList.length; i++) {
					$insideSite.find("ul").append(
							$("<li />").append('<a href="#;" onclick="selectBoxTextApply(this);changeSelSite(\''+grpSiteList[i].site_id+'\');">'+grpSiteList[i].site_name+'</a>')
					);
					
				}
				
			}
		}
		
	}
	
	var siteViewFlag = 0; // 1:신규장치등록, 2:장치그룹관리, 3:장치그룹편집
	var dvGrpInsUpdFlag = 0; // 1:insertForm, 2:updateForm, 0:reset
	$( function () {
		
		$("#grpMngFormBtn").click(function(){
			siteViewFlag = 2;
			getDeviceGrpSitePopupList("");
			popupOpen('dgdevice');
		});
		
		$("#editDvGrpFormBtn").click(function(){
			siteViewFlag = 3;
			dvGrpInsUpdFlag = 1;
			$('#confirmDvGrpBtn').val('추가하기');
			$("#deviceGrpName").val("");
			getDeviceGrpSitePopupList("");
			popupOpen('dgdevice_edit');
		});
		
		$("#cancelDvGrpBtn, #cancelDvGrpBtnX").click(function(){
			siteViewFlag = 2;
			dvGrpInsUpdFlag = 0;
			$('#editDvGrpForm').each(function() {
				this.reset();
			});
			$("#dvGrpTbody").empty().append('<tr><td colspan="3">사이트를 선택해주세요</td></tr>');
			$('#insideSite2').find("button").empty().append("사이트 선택").append( $('<span class="caret" />') );
			popupClose('dgdevice_edit');
		});
		
		$("#confirmDvInDbGrpBtn").click(function(){
			if(confirm("저장하시겠습니까?")) {
				var inputs = $(".inside_site input[name=devicePks]");
				var values = "";
				$.each(inputs, function (index, value) {
					values = values+$(value).val()+",";
				});
				$("#newDevicePks").val(values.slice(0, -1));
				var formData = $("#editDvInDvGrpForm").serializeObject();
				saveDvInDvGrp(formData);
			}
		});

		$("#confirmDvGrpBtn").click(function(){
			var $selectSiteId = $("#selectSiteId");
			if( isEmpty($selectSiteId.val()) ) {
				alert("장치그룹을 추가할 사이트를 선택해주세요");
				return;
			}
			var $deviceGrpName = $("#deviceGrpName");
			if( isEmpty($deviceGrpName.val()) ) {
				alert("장치그룹명을 입력해주세요");
				return;
			}

			if(confirm("저장하시겠습니까?")) {
				var formData = $("#editDvGrpForm").serializeObject();
				saveDvGrp(formData, dvGrpInsUpdFlag);
			}
		});
		
		$("#confirmDeviceBtn").click(function(){
			var formData = $("#insertDeviceForm").serializeObject();
			if(confirm("장치를 저장하시겠습니까?")) {
				if(siteViewFlag ===  1) insertDevice(formData);
				else if(siteViewFlag ===  2)  updateDevice(formData);
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
		if(siteViewFlag === 2) {
			$("#selSiteId").val(siteId);
			$(".inside_site").find("ul").empty();
			$(".all_site").find("ul").empty();
			
		} else if(siteViewFlag === 3) {
			$("#editDvGrpForm").find("#selectSiteId").val( siteId );
		}
		
		getDeviceGroupList(siteId);
	}
	
	function changeSelDeviceGrp(deviceGrpIdx) {
		var $selDvGrpIdx = $("#selDvGrpIdx");
		$selDvGrpIdx.val(deviceGrpIdx)
		
		var selSiteId = $("#selSiteId").val();
		var selDvGrpIdx = $selDvGrpIdx.val();
		
		getDvInDeviceGroupPopupList(selSiteId, selDvGrpIdx);
	}
	
	function callback_getDvInDeviceGroupPopupList(result) {
		var grpSiteList = result.dvInDeviceGrouplist;
		var allSiteList = result.allDvInSiteList;
		
		$insideSite = $(".inside_site");
		$insideSite.find("ul").empty();
		var $nowDevicePks = $("#nowDevicePks");
		$nowDevicePks.val("");
		if(grpSiteList != null && grpSiteList.length > 0) {
			var devices = "";
			for(var i=0; i<grpSiteList.length; i++) {
				devices = devices+grpSiteList[i].device_id+"|"+grpSiteList[i].device_type+",";
				$insideSite.find("ul").append(
						$("<li />").append('<a href="#;">'+grpSiteList[i].device_name+'</a>').append(
								'<input type="hidden" name="devicePks" value="'+grpSiteList[i].device_id+"|"+grpSiteList[i].device_type+'">'
						)
				);
				
			}
			$nowDevicePks.val(devices.slice(0, -1));
			
		} else {
	//		$tbody.append( '<tr><td colspan="6">조회 결과가 없습니다.</td><tr>' );
		}
		
		$allSite = $(".all_site");
		$allSite.find("ul").empty();
		if(allSiteList != null && allSiteList.length > 0) {
			for(var i=0; i<allSiteList.length; i++) {
				$allSite.find("ul").append(
						$("<li />").append('<a href="#;">'+allSiteList[i].device_name+'</a>').append(
								'<input type="hidden" name="devicePks" value="'+allSiteList[i].device_id+"|"+allSiteList[i].device_type+'">'
						)
				);
				
			}
			
		} else {
	//		$tbody.append( '<tr><td colspan="6">조회 결과가 없습니다.</td><tr>' );
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

	function updateDvGrpForm(dvGrpIdx, dvGrpName) {
		dvGrpInsUpdFlag = 2;
		$('#confirmDvGrpBtn').val('수정하기');
		$('#deviceGrpIdx2').val(dvGrpIdx);
		$('#deviceGrpName').val(dvGtpName);
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
				
				if(changeYn === "N") {
					alert("변경된 내용이 없습니다.");
					
				} else if(changeYn === "Y") {
					if(resultCnt > 0) {
						alert("저장되었습니다.");
						location.reload();
					} else {
						alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
					}
				}
				
			}
		});
	}
	
	function saveDvGrp(formData, dvGrpInsUpdFlag) {
		var url = "";
		if(dvGrpInsUpdFlag ===  1) url = "insertDeviceGroup";
		else if(dvGrpInsUpdFlag ===  2)  url = "updateDeviceGroup";
		$.ajax({
			url : url,
			type : 'post',
			async : false, // 동기로 처리해줌
			data : formData,
			success: function(result) {
				var resultCnt = result.resultCnt;
				if(resultCnt > 0) {
					alert("저장되었습니다.");
					dvGrpInsUpdFlag = 1;
					$('#confirmDvGrpBtn').val('추가하기');
					$("#deviceGrpName").val("");
					changeSelSite($("#editDvGrpForm").find("#selectSiteId").val());
				} else {
					alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
				}
			},
            error:function(request,status,error){
                alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
            }
		});
	}

	function deleteDvGrp(dvGrpIdx) {
		if(confirm("삭제하시겠습니까?")) {
			$.ajax({
				url : "/deleteDeviceGroup",
				type : 'post',
				async : false, // 동기로 처리해줌
				data : {
					deviceGrpIdx : dvGrpIdx
				},
				success: function(result) {
					var resultCnt = result.resultCnt;
					if(resultCnt > 0) {
						alert("삭제되었습니다.");
						location.reload();
					} else {
						alert("삭제에 실패하였습니다. \n 관리자에게 문의하세요.");
					}
				},
				error:function(request,status,error){
					alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
				}
			});
		}
	}

	function callback_insertDevice(result) {
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
	}
</script>
</head>
<body>

	<!-- 장치 모니터링 현황용 스크립트 -->
    <script src="../js/jquery.bxslider.js" type="text/javascript"></script>

	<div id="wrapper">
		<jsp:include page="../include/layouts/sidebar.jsp">
			<jsp:param value="device" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layouts/header.jsp" />
			<div id="container">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">장치 그룹 현황</h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div class="indiv device_group clear">
							<div class="dg_top clear">
								<h2 class="ntit fl">${selViewSite.site_name }</h2>
								<div class="clear fr">
									<ul class="fl">
									<c:if test="${not empty userInfo and userInfo.auth_type eq '1'}">
										<li><a href="#;" class="default_btn" id="grpMngFormBtn"><i class="glyphicon glyphicon-th-list"></i> 장치그룹관리</a></li>
									</c:if>
									</ul>
								</div>
							</div>
							<div class="dg_wrap">
							</div>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layouts/footer.jsp" />
		</div>
	</div>




    <!-- ###### 신규장치 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="ddevice" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 장치 등록</h2>
			<a href="#;" id="cancelDeviceBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<form id="insertDeviceForm" name="insertDeviceForm">
				<input type="hidden" name="deviceGrpIdx" id="deviceGrpIdx" class="input" value="">
				<table>
					<colgroup>
						<col width="200">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>사이트</span></th>
							<td>
								<select name="siteId" id="siteId" class="sel" style="width:100%">
								
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

    <!-- ###### 장치그룹관리 Popup Start ###### -->
    <div id="layerbox" class="dgdevice" style="min-width:800px;">
        <div class="stit">
        	<h2>장치 그룹 추가/제거</h2>
			<a href="#;" id="cancelDvInDbGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="dgset_top clear">
				<h2 class="ntit fl">사이트</h2>
				<div class="dropdown fl" id="insideSite">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">사이트 선택
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
				<h2 class="ntit fl">장치 그룹</h2>
				<div class="dropdown fl" id="insideDeviceGrp">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">장치그룹 선택
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
				<a href="#;" class="default_btn fr" id="editDvGrpFormBtn"><i class="glyphicon glyphicon-edit"></i> 장치그룹편집</a>
			</div>
			<div class="group_wrap clear">
				<form id="editDvInDvGrpForm" name="editDvInDvGrpForm">
				<input type="hidden" id="selSiteId" name="selSiteId">
				<input type="hidden" id="selDvGrpIdx" name="selDvGrpIdx">
				<input type="hidden" id="nowDevicePks" name="nowDevicePks">
				<input type="hidden" id="newDevicePks" name="newDevicePks">
				<div class="inside_site fl">
					<h2 class="ntit">그룹에 포함된 장치</h2>
					<div class="inbox">
						<ul class="multi_select">
						</ul>
					</div>
				</div>
				</form>
				<div class="cross_btn fl">
					<div><a href="#;" id="moveLeft"><img src="../img/btn_cross_left.png" alt="<"></a></div>
					<div><a href="#;" id="moveRight"><img src="../img/btn_cross_right.png" alt=">"></a></div>
				</div>
				<div class="all_site fl">
					<h2 class="ntit">사이트 내 장치</h2>
					<div class="inbox">
						<ul class="multi_select">
						</ul>
					</div>
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80" id="confirmDvInDbGrpBtn">적용</a>
			<a href="#;" class="cancel_btn w80" id="cancelDvInDbGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->

    <!-- ###### 장치그룹편집 Popup Start ###### -->
    <div id="layerbox" class="dgdevice_edit" style="min-width:600px;">
        <div class="stit">
        	<h2>장치 그룹 편집</h2>
			<a href="#;" id="cancelDvGrpBtnX">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="clear">
				<h2 class="ntit fl">사이트</h2>
				<div class="dropdown fl ml20" id="insideSite2">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">사이트 선택
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				    </ul>
				</div>
			</div>
			<h2 class="ctit mt20">전체 장치그룹</h2>
			<form id="editDvGrpForm" name="editDvGrpForm">
			<input type="hidden" id="selectSiteId" name="selectSiteId">
			<input type="hidden" id="nowDvGrpIds" name="nowDvGrpIds">
			<input type="hidden" id="newDvGrpIds" name="newDvGrpIds">
			<input type="hidden" id="newDvGrpNms" name="newDvGrpNms">
			<div class="company_list mt10">
				<table>
					<colgroup>
						<col width="50">
						<col>
						<col width="50">
					</colgroup>
					<thead>
						<tr>
							<th>No</th>
							<th>장치그룹명</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody id="dvGrpTbody">
						<tr>
							<td colspan="3">사이트를 선택해주세요</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="set_tbl mt10 clear">
				<div class="fl" style="width:calc(100% - 120px);">
					<table>
						<colgroup>
							<col width="150">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th><span>장치그룹명</span></th>
								<td><input type="text" id="deviceGrpName" name="deviceGrpName" class="input" style="width:100%"><input type="hidden" id="deviceGrpIdx2" name="deviceGrpIdx2"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="fr">
					<input type="button" id="confirmDvGrpBtn" value="추가하기" class="submit">
				</div>
			</div>
			</form>

		</div>
		<div class="btn_center">
			<%--<a href="#;" class="default_btn w80" id="confirmDvGrpBtn">확인</a>--%>
			<a href="#;" class="cancel_btn w80" id="cancelDvGrpBtn">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->







</body>
</html>
