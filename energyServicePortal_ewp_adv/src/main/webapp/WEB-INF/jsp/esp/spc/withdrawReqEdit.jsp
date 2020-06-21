<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<script>
	const oid = '${sessionScope.userInfo.oid}';
	const loginId = '${sessionScope.userInfo.login_id}';

	$(function() {
		const form = $("#spcReqEdit");
		const fistTable = $("#firstTable");
		const deleteBtn = $("#deleteBtn");
		const checkBoxes = fistTable.find('.select_row input[type="checkbox"]');
		const calendar = $(".sel_calendar");
		const dropdown = $("#spc button.dropdown-toggle");
		const opt1 = "관리운영비<span class='caret'></span>";
		const opt2 = "사무수탁비<span class='caret'></span>";
		const textInput = fistTable.find(".reqFee");
		const note = fistTable.find("td:not('.reqFee')");
		
		note.val("");
		unCheckAll();

		textInput.each(function(index){
			if(index % 2 == 0) {
				$(this).find("input").val("400,000,00");
			} else {
				$(this).find("input").val("20,000,00");
			}
		});

		dropdown.each(function(index){
			if(index % 2 == 0) {
				$(this).html(opt1);
			} else {
				$(this).html(opt2);
			}

		});

		calendar.each(function(index){
			let fullDate = ""
			let yy_mm = "2020-05-0";
			let dd = 2;
			dd+=(index+2);
			let d = dd.toString();
			fullDate = yy_mm+d;

			$(this).find("input").val(fullDate);
		})

		deleteBtn.on("click", function (){
			checkBoxes.each(function(){
				if($(this).prop("checked")){
					$(this).closest("tr").remove();
				} else {
					return
				}
			});
		})
		form.on("submit", function(e){
			e.preventDefault();
				// window.locationtransactionHistory.do

		})

		$("#writeBtn").on("click", function(){
			downloadFile
		})
			// onclick="location.href='http://iderms.enertalk.com:8443/files/download/5c71e049-f73c-2bf9-a9a0-2f91d067ef11?oid=spower&orgFilename=수익보고서_20200526100755.pdf'"
	
		function setSaveData(){
			var spcId = $("#spc").data("value"),
				spcName = $("#name").val(),
				genId = $("#gen").data("value"),
				genName = $("#genName").val();

			if(spcId === undefined){
				alert("SCP명을 선택하세요.");
				return false;
			}

			if(genId === undefined){
				alert("발전소를 선택하세요.");
				return false;
			}

			if(spcId == "" && spcName == ""){
				alert("SCP명을 입력하세요.");
				return false;
			}
			
			if(genId == "" && genName == ""){
				alert("발전소명을 입력하세요.");
				return false;
			}	
			
			//직접입력 발전소 등록..(이걸왜 여기서 하지? 발전소 관리 화면냅두고 직접입력 선택 시 사이트관리 화면 팝업을 띄우던가..ㅉㅉ)
			if(genId == ""){
				var bError = false;
				$.ajax({
					url: "http://iderms.enertalk.com:8443/config/sites?oid="+oid,
					type: "post",
					dataType: 'json',
					async: false,
					contentType: "application/json",
					data: JSON.stringify({
						"name": $("#genName").val(),
						"location": $("#sidoValue").val(),
						"address": $("#address").val(),
						"resource_type" : 0
					}),
					success: function (json) {
						$("#gen").data("value", json.sid);
					},
					error: function (request, status, error) {
						alert('처리 중 오류가 발생했습니다.');
						bError = true;
						return false;
					}
				});
				
				if(bError){
					return false;
				}
			}	
			
			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs",
				type: "get",
				async: true,
				data: {"oid": oid, includeGens: true},
				success: function (result) {
					var checkCountSpc = 0, checkCountGen = 0;

					for(var i = 0, count = result.data.length; i < count; i++){
						var rowData = result.data[i];
						var spcGensList = rowData.spcGens;

						if(rowData.name == spcName && spcId == ""){
							checkCountSpc++;
							break;
						}

						if(spcGensList !== undefined && spcGensList.length > 0){
							for(var j = 0, jcount = spcGensList.length; j < jcount; j++){
								if(genId == spcGensList[j].gen_id){
									checkCountGen++;
									break;
								}
							}
						}
					}

					if( checkCountSpc > 0 ){
						alert("중복되는 SPC명이 존재 합니다.");
						return false;
					}

					if( checkCountGen > 0 ){
						alert("SPC에 등록된 발전소 입니다.");
						return false;
					}

					$("#sendSpcPostModal").modal(); // 처리중 모달띄우기
					
					//신규 spc 일떄..
					if(spcId == ""){
						sendSpcPost();
					}else{
						sendSpcAttchFilePost(spcId);
					}
				},
				error: function (request, status, error) {
					alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
				}
			});
		}


		function downloadFile(spcId){
			var genId = $("#gen").data("value");

			form.find("input[type=file]").each(function(){
				$(this).attr("name", this.name + "_" + spcId +"_" + genId);
			});

			$.ajax({
				type: 'post',
				enctype: 'multipart/form-data',
				url: 'http://iderms.enertalk.com:8443/files/upload?oid='+oid,
				data: new FormData(form),
				processData: false,
				contentType: false,
				cache: false,
				timeout: 600000,
				success: function (result) {
					console.log("form file submitted===", result)
					// sendSpcGenPost(spcId, result.files);
				},
				error: function (request, status, error) {
					alert("오류가 발생하였습니다. \n관리자에게 문의하세요.");
				}
			});
		}

		function sendSpcGenPost(spcId, files){
			var genId = $("#gen").data("value");

			var contract_info = setAreaParamData("contract_info"),
				device_info = setAreaParamData("device_info"),
				finance_info = setAreaParamData("finance_info"),
				warranty_info = setAreaParamData("warranty_info"),
				coefficient_info = setAreaParamData("coefficient_info"),
				contact_info = setAreaParamData("contact_info"),
				attachement_info = files;

			device_info["addList01"] = setAddListParam("addList01");
			device_info["addList02"] = setAddListParam("addList02");
			device_info["addList03"] = setAddListParam("addList03");
			device_info["addList04"] = setAddListParam("addList04");
			device_info["addList05"] = setAddListParam("addList05");
			device_info["addList06"] = setAddListParam("addList06");
			device_info["addList07"] = setAddListParam("addList07");

			$.ajax({
				url: "http://iderms.enertalk.com:8443/spcs/" + spcId +"/gens?oid=" + oid +"&gen_id=" + genId,
				type: "post",
				async: true,
				contentType: "application/json",
				data: JSON.stringify({
					"contract_info": JSON.stringify(contract_info),
					"device_info" : JSON.stringify(device_info),
					"finance_info" : JSON.stringify(finance_info),
					"warranty_info" : JSON.stringify(warranty_info),
					"coefficient_info" : JSON.stringify(coefficient_info),
					"contact_info" : JSON.stringify(contact_info),
					"attachement_info" : JSON.stringify(attachement_info),
					"updated_by" : loginId,
					"del_yn": "N"
				}),
				success: function (json) {
					alert("등록되었습니다.");
					goMoveList();
				},
				error: function (request, status, error) {
					alert('처리 중 오류가 발생했습니다.');
					return false;
				}
			});
		}

	});


</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">출금 요청서 수정</h1>
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATA BASE TIME</span>
			<em class="dbTime">2018-07-27 17:01:02</em>
		</div>
	</div>
</div>

<div class="row spc_search_bar">
	<div class="col-12">
		<span class="tx_tit">SPC 선택</span><div class="sa_select mr-16">
			<div class="dropdown">
				<button type="button" id="spc" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">전체<span class="caret"></span></button>
				<ul id="spcList" class="dropdown-menu chk_type" role="menu">
					<li data-value="14">
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="allSpc" value="all" name="spcName">
							<label for="allSpc"><span></span>전체</label>
						</a>
					</li>
					<li data-value="15">
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="spc1" value="spc1" name="spcName">
							<label for="spc1"><span></span>SPC1</label>
						</a>
					</li>
					<li data-value="16">
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="spc2" value="spc2" name="spcName">
							<label for="spc2"><span></span>SPC2</label>
						</a>
					</li>
					<li data-value="17">
						<a href="javascript:void(0);" tabindex="-1">
							<input type="checkbox" id="spc3" value="spc3" name="spcName">
							<label for="spc3"><span></span>SPC2</label>
						</a>
					</li>
				</ul>
			</div>
		</div><span class="tx_tit ml-12">출금 계좌번호</span><div class="sa_select">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu chk_type" role="menu">
					<li>
						<a href="javascript:void(0);">
							<input type="checkbox" id="accountSelect1" value="kb" name="account_select">
							<label for="accountSelect1"><span></span>KB 120-634348-12-339</label>
						</a>
					</li>
					<li>
						<a href="javascript:void(0);">
							<input type="checkbox" id="accountSelect2" value="ibk" name="account_select">
							<label for="accountSelect2"><span></span>기업 650-665568-12-339</label>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper spc_transaction">
	<div class="col-12">
		<form action="#" method="post" id="spcReqEdit">
			<div class="indiv spc_bal_post">
				<table class="table_footer">
					<colgroup>
						<col style="width:4%">
						<col style="width:16%">
						<col style="width:15%">
						<col style="width:20%">
						<col style="width:30%">
						<col style="width:15%">
						<col>
					</colgroup>
					<thead>
					<tr>
						<th></th>
						<th>출금 요청 일자</th>
						<th>용도 구분</th>
						<th>요청 금액</th>
						<th>입금 계좌 번호</th>
						<th>비고</th>
					</tr>
					</thead>
					<tbody id="firstTable">
						<tr>
							<td>
								<a class="chk_type select_row">
									<input type="checkbox" id="chk01" name="chk01">
									<label for="chk01"><span></span></label>
								</a>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="enforce_1" name="enforce_1" class="sel fromDate" value=""
										autocomplete="off"
										readonly
										placeholder="선택">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="spc">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">선택
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum1" value="accountTypes1" name="accountTypes">
													<label for="accountNum1"><span></span>관리 운영비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum2" value="accountTypes2" name="accountTypes">
													<label for="accountNum2"><span></span>사무 수탁비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountTypes3" value="accountTypes3" name="accountTypes">
													<label for="accountTypes3"><span></span>기타</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td class="reqFee">
								<div class="tx_inp_type">
									<input type="text" id="reqFee2" name="reqFee2" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="accountNum4">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">KB 120-634348-12-339
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum4" value="accountNum" name="accountNum11">
													<label for="accountNum11"><span></span>신한 650-665568-12-339</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum5" value="accountNum" name="accountNum12">
													<label for="accountNum12"><span></span>KB 650-665568-12-339</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="interestRate_1" name="interestRate_1" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<a href="javascript:void(0);" class="chk_type select_row">
									<input type="checkbox" id="chk02" name="chk02">
									<label for="chk02"><span></span></label>
								</a>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="date2" name="date2" class="sel fromDate" value=""
										autocomplete="off"
										readonly
										placeholder="선택">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="spc">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">선택
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum6" value="accountTypes1" name="accountTypes">
													<label for="accountNum1"><span></span>관리 운영비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum7" value="accountTypes2" name="accountTypes">
													<label for="accountNum2"><span></span>사무 수탁비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountTypes8" value="accountTypes3" name="accountTypes">
													<label for="accountTypes3"><span></span>기타</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td class="reqFee">
								<div class="tx_inp_type">
									<input type="text" id="reqFee3" name="reqFee3" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="accountNum5">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">기업 650-665568-12-339
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum9" value="accountNum3" name="accountNum3">
													<label for="accountNum3"><span></span>신한 650-665568-12-339</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum10" value="accountNum4" name="accountNum4">
													<label for="accountNum4"><span></span>KB 650-665568-12-339</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="interestRate_2" name="interestRate_2" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<a href="javascript:void(0);" class="chk_type select_row">
									<input type="checkbox" id="chk03" name="chk03">
									<label for="chk03"><span></span></label>
								</a>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="date4" name="date4" class="sel fromDate" value=""
										autocomplete="off"
										readonly
										placeholder="선택">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="spc">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">선택
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountTypes11" value="accountTypes1" name="accountTypes">
													<label for="accountTypes11"><span></span>관리 운영비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum12" value="accountTypes12" name="accountTypes">
													<label for="accountTypes12"><span></span>사무 수탁비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountTypes3" value="accountTypes13" name="accountTypes">
													<label for="accountTypes13"><span></span>기타</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td class="reqFee">
								<div class="tx_inp_type">
									<input type="text" id="reqFee4" name="reqFee4" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="accountNumGroup1">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">KB 120-634348-12-339
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum21" value="accountNum3" name="accountNum3">
													<label for="accountNum21"><span></span>신한 650-665568-12-339</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum2" value="accountNum22" name="accountNum4">
													<label for="accountNum22"><span></span>KB 650-665568-12-339</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="interestRate_3" name="interestRate_3" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<a href="javascript:void(0);" class="chk_type select_row">
									<input type="checkbox" id="chk04" name="chk04">
									<label for="chk04"><span></span></label>
								</a>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="date1" name="date1" class="sel fromDate" value=""
										autocomplete="off"
										readonly
										placeholder="선택">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="spc">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">선택
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountType4" value="accountTypes21" name="accountTypes">
													<label for="accountTypes21"><span></span>관리 운영비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountType5" value="accountTypes22" name="accountTypes">
													<label for="accountTypes22"><span></span>사무 수탁비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountType6" value="accountTypes23" name="accountTypes">
													<label for="accountTypes23"><span></span>기타</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td class="reqFee">
								<div class="tx_inp_type">
									<input type="text" id="reqFee5" name="reqFee5" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="accountNumGroup3">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">기업 650-665568-12-339
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum30" value="accountNum3" name="accountNum3">
													<label for="accountNum30"><span></span>신한 650-665568-12-339</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum31" value="accountNum4" name="accountNum4">
													<label for="accountNum31"><span></span>KB 650-665568-12-339</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="interestRate_5" name="interestRate_5" placeholder="직접 입력">
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<a href="javascript:void(0);" class="chk_type select_row">
									<input type="checkbox" id="chk05" name="chk05">
									<label for="chk05"><span></span></label>
								</a>
							</td>
							<td>
								<div class="sel_calendar">
									<input type="text" id="date3" name="date3" class="sel fromDate" value=""
										autocomplete="off"
										readonly
										placeholder="선택">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="spc">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">선택
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountTypes40" value="accountTypes1" name="accountTypes">
													<label for="accountTypes40"><span></span>관리 운영비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum2" value="accountTypes42" name="accountTypes">
													<label for="accountTypes42"><span></span>사무 수탁비</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountTypes3" value="accountTypes43" name="accountTypes">
													<label for="accountTypes43"><span></span>기타</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td class="reqFee">
								<div class="tx_inp_type">
									<input type="text" id="reqFee6" name="reqFee6" placeholder="직접 입력">
								</div>
							</td>
							<td>
								<div class="sa_select">
									<div class="dropdown placeholder" id="accountNumGroup2">
										<button class="btn btn-primary dropdown-toggle" type="button"
												data-toggle="dropdown">KB 120-634348-12-339
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu chk_type" role="menu">
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum50" value="accountNum3" name="accountNum3">
													<label for="accountNum50"><span></span>신한 650-665568-12-339</label>
												</a>
											</li>
											<li>
												<a href="javascript:void(0);" tabindex="-1">
													<input type="checkbox" id="accountNum51" value="accountNum4" name="accountNum4">
													<label for="accountNum51"><span></span>KB 650-665568-12-339</label>
												</a>
											</li>
										</ul>
									</div>
								</div>
							</td>
							<td>
								<div class="tx_inp_type">
									<input type="text" id="interestRate_5" name="interestRate_5" placeholder="직접 입력">
								</div>
							</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td></td>
							<td>합계</td>
							<td></td>
							<td>1,240,000,000</td>
							<td colspan="2"></td>
						</tr>
					</tfoot>
				</table>
				<div class="btn_wrap_type">
					<a href="#;" class="btn_type07" id="deleteBtn">선택 삭제</a>
					<a href="javascript:void(0);" class="btn_add"
						onclick="addEmptyRowTable('firstTable'); return false;">열 추가</a>
				</div>
			</div>
			<div class="indiv mt25">
				<div class="spc_tbl_row">
					<table id="secondTable">
						<colgroup>
							<col style="width:15%">
							<col style="width:20%">
							<col>
						</colgroup>
						<tr>
							<th class="th_type">증빙 첨부<a href="javascript:addRowTable('secondTable')" class="btn_add fr">추가</a></th>
							<td id="addFileList01">
								<input type="file" id="spc_file_01" class="hidden" name="spc_file_01" accept=".gif, .jpg, .png">
								<label for="spc_file_01" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td id="addFileList02">
								<input type="file" id="spc_file_02" class="hidden" name="spc_file_02" accept=".gif, .jpg, .png">
								<label for="spc_file_02" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td id="addFileList03">
								<input type="file" id="spc_file_03" class="hidden" name="spc_file_03"  accept=".gif, .jpg, .png">
								<label for="spc_file_03" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td id="addFileList04">
								<input type="file" id="spc_file_04" class="hidden" name="spc_file_04"  accept=".gif, .jpg, .png">
								<label for="spc_file_04" class="btn file_upload">파일 선택</label>
								<span class="upload_text ml-16"></span>
							</td>
							<td></td>
						</tr>
					</table>
				</div>
				<div class="btn_wrap_type05">
					<a class="chk_type mr-24">
						<input type="checkbox" id="chk02" name="chk02">
						<label for="chk02"><span></span>증빙 첨부 포함</label>
					</a>
					<button type="button" class="btn btn_type03 mr-12" id="writeBtn">다운로드</button>
					<button type="submit" class="btn btn_type">제출</button>
				</div>
			</div>
		</form>
	</div>
</div>

<%--
<div class="indiv collapse" id="searchOption">
	<div class="spc_tbl">
		<table class="sort_table chk_type">
			<thead>
				<tr>
					<th>
						<strong>조회 기간</strong>
					</th>
					<th><button class="btn_align down">선택</button></th>
					<th><button class="btn_align down">상태</button></th>
					<th><button class="btn_align down">승인 대기, 승인 중</button></th>
				</tr>
			</thead>
			<tbody id="listData">
				<tr>
					<td><strong>단위</strong></td>
					<td>선택</td>
					<td>계좌 구분</td>
					<td class="right">선택</td>
				</tr>
				<tr>
					<td><strong>입출금 구분</strong></td>
					<td>계좌 구분</td>
					<td>계좌 구분</td>
					<td class="right">선택</td>
				</tr>
			</tbody>
		</table>
		<button class="btn_type fr" onclick="getDataList();">조회</button>
	</div>
</div>
--%>