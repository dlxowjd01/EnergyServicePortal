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
			alert("조회 결과가 없습니다.");
//			location.href = "/siteMain";
		} else {
			$("#custNum").val( siteSetDetail.cust_num );
			$("#useElecAddr").val( siteSetDetail.use_elec_addr );
			$("#meterNum").val( siteSetDetail.meter_num );
			$("#meterSf").val( siteSetDetail.meter_sf );
			getPlanType('', '', '', 1);
			getPlanType(siteSetDetail.plan_type, '', '', 2);
			getPlanType(siteSetDetail.plan_type, siteSetDetail.plan_type2, '', 3);
			$("#planType").val( siteSetDetail.plan_type );
			$("#planType2").val( siteSetDetail.plan_type2 );
			$("#planType3").val( siteSetDetail.plan_type3 );
			$("#contractPower").val( siteSetDetail.contract_power );
			$("#meterReadDay").val( siteSetDetail.meter_read_day );
			$("#chargeYearmd").val( siteSetDetail.charge_yearmd );
			var ymd = siteSetDetail.charge_yearmd;
			$("#datepicker10").val( (ymd == "") ? "" : ymd.substring(0, 4)+"-"+ymd.substring(4, 6)+"-"+ymd.substring(6, 8) );
			$("#chargePower").val( siteSetDetail.charge_power );
//			$("#goalPower").val( siteSetDetail.goal_power );
			$("#reduceAmt").val( siteSetDetail.reduce_amt );
			$("#chargeRate").val( siteSetDetail.charge_rate );
			$("#siteSetIdx").val( siteSetDetail.site_set_idx );
			$("#siteId").val( siteSetDetail.site_id );
			
			$("#essProfitRatio").val( siteSetDetail.ess_profit_ratio );
			$("#drProfitRatio").val( siteSetDetail.dr_profit_ratio );
			$("#pvProfitRatio").val( siteSetDetail.pv_profit_ratio );
			$("#essBattery").val( siteSetDetail.ess_battery );
			$("#essPcs").val( siteSetDetail.ess_pcs );
			$("#meterClaimDay").val( siteSetDetail.meter_claim_day );
			$("#recRate").val( siteSetDetail.rec_rate );
			$("#smpRate").val( siteSetDetail.smp_rate );
			$("#recWeight").val( siteSetDetail.rec_weight );
			
			$("#recRateDate").val( siteSetDetail.rec_rate_date );
			var ymd2 = siteSetDetail.rec_rate_date;
			$("#datepicker11").val( (ymd2 == "") ? "" : ymd2.substring(0, 4)+"-"+ymd2.substring(4, 6) );
			$("#smpRateDate").val( siteSetDetail.smp_rate_date );
			var ymd3 = siteSetDetail.smp_rate_date;
			$("#datepicker12").val( (ymd3 == "") ? "" : ymd3.substring(0, 4)+"-"+ymd3.substring(4, 6)+"-"+ymd3.substring(6, 8) );
			
		}
		
	}
	
	$( function () {
		$(".confirm_btn").click(function(){
			if(confirm("저장하시겠습니까?")) {
				$dtpk1 = $("#datepicker10");
				$("#chargeYearmd").val( ($dtpk1.val() == "") ? "" : new Date( $dtpk1.val()+" 00:00:00" ).format("yyyyMMdd") );
				$dtpk2 = $("#datepicker11");
				$("#recRateDate").val( ($dtpk2.val() == "") ? "" : new Date( $dtpk2.val()+" 00:00:00" ).format("yyyyMMdd") );
				$dtpk3 = $("#datepicker12");
				$("#smpRateDate").val( ($dtpk3.val() == "") ? "" : new Date( $dtpk3.val()+" 00:00:00" ).format("yyyyMMdd") );
				var formData = $("#siteSetForm").serializeObject();
				updateSiteSet(formData);
			}
		});
		
		// 요금제구분1 선택 시
		$('#planType').change(function(){
			var planType = $(this).val();
			getPlanType(planType, '', '', 2); // 요금제구분2
		});
		
		// 요금제구분2 선택 시
		$('#planType2').change(function(){
			var planType2 = $(this).val();
			getPlanType($('#planType').val(), planType2, '', 3); // 요금제구분3
		});
	});
	

	function getPlanType(planType, planType2, planType3, gbn) {
		$.ajax({
			url : "/getPlanType",
			type : 'post',
			async : false, // 동기로 처리해줌
			data : {
				planType : planType,
				planType2 : planType2,
				planType3 : planType3,
				gbn : gbn
			},
			success: function(result) {
				var list = result.list;
				
				if(gbn == 1) $siteIdSelBox = $("#siteSetForm").find("#planType");
				else if(gbn == 2) $siteIdSelBox = $("#siteSetForm").find("#planType2");
				else if(gbn == 3) $siteIdSelBox = $("#siteSetForm").find("#planType3");
				$siteIdSelBox.empty();
				$siteIdSelBox.append('<option value="">---선택---</option>');
				for(var i=0; i<list.length; i++) {
					if(gbn == 1) $siteIdSelBox.append('<option value="'+list[i].plan_type+'">'+list[i].plan_type_name+'</option>');
					else if(gbn == 2) $siteIdSelBox.append('<option value="'+list[i].plan_type2+'">'+list[i].plan_type_name2+'</option>');
					else if(gbn == 3) $siteIdSelBox.append('<option value="'+list[i].plan_type3+'">'+list[i].plan_type_name3+'</option>');
				}
				
			}
		});
	}
	
	function callback_updateSiteSet(result) {
		var resultCnt = result.resultCnt;
		if(resultCnt > 0) {
			alert("저장되었습니다.");
			location.reload();
		} else {
			alert("저장에 실패하였습니다. \n 관리자에게 문의하세요.");
		}
	}
	
