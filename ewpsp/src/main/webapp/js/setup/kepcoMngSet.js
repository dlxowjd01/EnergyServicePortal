	$(document).ready(function() {
		getDBData();
	});
	
	function getDBData() {
		getSiteSetDetail(); // 한전 계약 및 전력관리 정보 조회
	}
	
	// 한전 계약 및 전력관리 정보 조회
	function callback_getSiteSetDetail(result) {
		var siteSetDetail = result.detail;
		
		if(siteSetDetail == null) {
			alert("조회된 데이터가 없습니다.");
//			location.href = "/siteMain";
		} else {
			$("#planType").val( siteSetDetail.plan_type );
			$("#contractPower").val( siteSetDetail.contract_power );
			$("#meterReadDay").val( siteSetDetail.meter_read_day );
			$("#chargeYearm").val( siteSetDetail.charge_yearm );
			$("#chargePower").val( siteSetDetail.charge_power );
			$("#goalPower").val( siteSetDetail.goal_power );
			$("#chargeRate").val( siteSetDetail.charge_rate );
			$("#siteSetIdx").val( siteSetDetail.site_set_idx );
			$("#siteId").val( siteSetDetail.site_id );
			
//			popupOpen('dview_ioe');
		}
		
	}
	
	$( function () {
		$(".confirm_btn").click(function(){
			var formData = $("#siteSetForm").serializeObject();
			if(confirm("저장하시겠습니까?")) {
				updateSiteSet(formData);
			}
		});
	});
	
	function callback_updateSiteSet(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
