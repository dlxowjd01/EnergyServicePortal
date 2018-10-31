	var excelCnt = 0;
	var selectDeviceGbn = "";
	function getDBData(deviceGbn) {
		if(deviceGbn == "IOE") getDeviceIOEList(1); // 장치목록 조회(IOE)
		else if(deviceGbn == "PCS") getDevicePCSList(1); // 장치목록 조회(PCS)
		else if(deviceGbn == "BMS") getDeviceBMSList(1); // 장치목록 조회(BMS)
		else if(deviceGbn == "PV") getDevicePVList(1); // 장치목록 조회(PV)
		
		var today = new Date();
		update_updtDataTime(today); // 검색시간(차트 새로고침시간) 업데이트
	}
	
	// 장치목록 조회(IOE)
	function callback_getDeviceIOEList(result) {
		var ioeList = result.list;
		
		$tbody = $("#ioeTbody");
		$tbody.empty();
		if(ioeList == null || ioeList.length < 1) {
			$tbody.append( '<tr><td colspan="6">조회 결과가 없습니다.</td><tr>' );
			$('#DeviceIOEPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<ioeList.length; i++) {
				var tm = new Date( convertDateUTC(ioeList[i].upload_timestamp) );
				$tbody.append(
						$('<tr />').append( $("<td />").append( ioeList[i].rnum )
						).append( $("<td />").append( ioeList[i].device_name )
						).append( $("<td />").append( ioeList[i].device_id )
						).append( $("<td />").append( ioeList[i].device_type_nm )
						).append( $("<td />").append( ioeList[i].device_stat_name )
						).append( $("<td />").append( tm.format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDeviceIOEDetail(\''+ioeList[i].site_id+"\', \'"+ioeList[i].device_id+"\', \'"+ioeList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DeviceIOE");
			
			excelCnt = ioeList.length;
			selectDeviceGbn = "IOE";
			
		}
		
	}
	
	// 장치목록 조회(PCS)
	function callback_getDevicePCSList(result) {
		var pcsList = result.list;

		$tbody = $("#pcsTbody");
		$tbody.empty();
		if(pcsList == null || pcsList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
			$('#DevicePCSPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<pcsList.length; i++) {
				var tm = new Date( convertDateUTC(pcsList[i].std_date) );
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pcs\')" />').append( $("<td />").append( pcsList[i].rnum )
						).append( $('<td />').append( pcsList[i].device_name )
						).append( $('<td />').append( pcsList[i].device_id )
						).append( $('<td />').append( pcsList[i].device_type_nm )
						).append( $('<td />').append( pcsList[i].device_stat_name )
						).append( $('<td class="ellipsis mxw400" />').append( pcsList[i].alarm_msg )
						).append( $('<td />').append( tm.format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDevicePCSDetail(\''+pcsList[i].site_id+"\', \'"+pcsList[i].device_id+"\', \'"+pcsList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DevicePCS");
			
			excelCnt = pcsList.length;
			selectDeviceGbn = "PCS";
			
		}
		
	}
	
	// 장치목록 조회(BMS)
	function callback_getDeviceBMSList(result) {
		var bmsList = result.list;
		
		$tbody = $("#bmsTbody");
		$tbody.empty();
		if(bmsList == null || bmsList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
			$('#DeviceBMSPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<bmsList.length; i++) {
				var tm = new Date( convertDateUTC(bmsList[i].std_date) );
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/bat\')" />').append( $("<td />").append( bmsList[i].rnum )
						).append( $('<td />').append( bmsList[i].device_name )
						).append( $('<td />').append( bmsList[i].device_id )
						).append( $('<td />').append( bmsList[i].device_type_nm )
						).append( $('<td />').append( bmsList[i].device_stat_name )
						).append( $('<td class="ellipsis mxw400" />').append( bmsList[i].alarm_msg )
						).append( $('<td />').append( tm.format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDeviceBMSDetail(\''+bmsList[i].site_id+"\', \'"+bmsList[i].device_id+"\', \'"+bmsList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DeviceBMS");
			
			excelCnt = bmsList.length;
			selectDeviceGbn = "BMS";
			
		}
		
	}
	
	// 장치목록 조회(PV)
	function callback_getDevicePVList(result) {
		var pvList = result.list;
		
		$tbody = $("#pvTbody");
		$tbody.empty();
		if(pvList == null || pvList.length < 1) {
			$tbody.append( '<tr><td colspan="8">조회 결과가 없습니다.</td><tr>' );
			$('#DevicePVPaging').empty();
			excelCnt = 0;
		} else {
			for(var i=0; i<pvList.length; i++) {
				var tm = new Date( convertDateUTC(pvList[i].std_date) );
				$tbody.append(
						$('<tr ondblclick="goLEMSPage(\'/lems/setting/pv\')" />').append( $("<td />").append( pvList[i].rnum )
						).append( $('<td />').append( pvList[i].device_name )
						).append( $('<td />').append( pvList[i].device_id )
						).append( $('<td />').append( pvList[i].device_type_nm )
						).append( $('<td />').append( pvList[i].device_stat_name )
						).append( $('<td />').append( pvList[i].temp )
						).append( $('<td class="ellipsis mxw400" />').append( pvList[i].alarm_msg )
						).append( $('<td />').append( tm.format("yyyy-MM-dd HH:mm:ss") )
						).append(
								$("<td />").append( '<a href="#;" onclick="getDevicePVDetail(\''+pvList[i].site_id+"\', \'"+pvList[i].device_id+"\', \'"+pvList[i].device_type+'\');" class="detail_view">상세보기</a>' )
						)
				);
			}
			
			var pagingMap = result.pagingMap;
			makePageNums2(pagingMap, "DevicePV");
			
			excelCnt = pvList.length;
			selectDeviceGbn = "PV";
			
		}
		
	}
	
