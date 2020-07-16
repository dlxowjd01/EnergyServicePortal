<%@ page language='java' contentType='text/html; charset=utf-8' pageEncoding='utf-8'%>
<%@ include file='/decorators/include/taglibs.jsp'%>
<script src='/js/commonDropdown.js'></script>
<script type="text/javascript">
	const oid = '<c:out value="${sessionScope.userInfo.oid}" escapeXml="false" />';
	const loginId = '<c:out value="${sessionScope.userInfo.login_id}" escapeXml="false" />';
	const loginName = '<c:out value="${sessionScope.userInfo.name}" escapeXml="false" />';

	$(function() {
		const tableBody = $('#tableBody');
		const tableFooter = $('#tableFooter')
		const tbodyClone = tableBody.find("template.table-body").clone().html();
		const tfootClone = tableFooter.find("template.table-footer").clone().html();
		const searchBar = $('.spc-search-bar');
		const searchForm = $('#transactionForm');
		const dropdownOpt = $('#searchOption').find('.dropdown-menu:not(.chk_type) li');
		const sumOptList = $('#sumOptList');
		const perPage = 14;

		var spcInfoArr = [];
		// var totalAmount = 0;
		tableBody.find("template").remove();
		tableFooter.find("template").remove();

		unCheckAll(searchBar);
		getSpcList();
		// selectAll($("#spcList"));
		// selectAll($("#spcStatus"));
		selectAllGroup($("#searchOption"));
		setSingleSelectDropdown($("#searchOption"))
		setSingleSelectDropdown(sumOptList);

		$('#fromDate').datepicker('setDate', 'today');
		$('#toDate').datepicker('setDate', 'today');
		// $('#toDate').datepicker( "option", "maxDate", new Date());

		$('#unitOpt').find("li").on('click', function () {
			$('#toDate').datepicker('setDate', 'today')
			if ($(this).data('value') == 'daily') {
				$('#fromDate').datepicker('setDate', 'today');
			} else if ($(this).data('value') == 'monthly') {
				$('#fromDate').datepicker('setDate', '-30');
			} else if ($(this).data('value') == 'yearly') {
				$('#fromDate').datepicker('setDate', '-365');
			}
		});

		$('.sort_table th button').click(function(){
			var table = $(this).parents("table");
			var rows = tableBody.find('tr').toArray().sort(comparer($(this).index()))
			this.asc = !this.asc;
			if (!this.asc){
				rows = rows.reverse();
				$(this).addClass('down').removeClass('up');
			} else {
				$(this).removeClass('down').addClass('up');
			}
			for (var i = 0, rowLength = rows.length; i<rowLength; i++){
				// TO DO !!!!! sorting json data
				tableBody.append(rows[i])
			}
			// return false;
		});

		// sumOptList.find('li').on('click', function(){
		// 	console.log("val---", $(this).data("value"))
		// 	let val = $(this).data("value");
		// 	return false;
		// });

		searchForm.on('submit', function(e){
			e.preventDefault();
			let page = 1;
			let formArr = [];

			let spcOpts = $('#spcList').find("input:checked");
			let spcStatus = $('#spcStatus').find("input:checked");
			let spcPurpose = $('#spcPurposeList').find("input:checked");

			let fromDate = $('#fromDate');
			let toDate = $('#toDate');

			let transactionType = $('#transactionType').parent().find('.dropdown-toggle');

			let warning = $('.warning');

			let selectedSpc = [];

			spcOpts.each(function(){
				selectedSpc.push($(this).data("value"));
			});

			let selectedPurpose= [];
			spcPurpose.each(function(){
				selectedPurpose.push($(this).data("value"));
			});

			let selectedStatus = [];
			selectedStatus.length == 0;
			spcStatus.each(function(){
				selectedStatus.push($(this).data("value"));
			});
			let newStartDate = fromDate.val().replace(/-/g, '');
			let newEndDate = toDate.val().replace(/-/g, '');

			warning.addClass('hidden');
			formArr.length == 0;
			formArr.push(selectedSpc.toString(), newStartDate, newEndDate, selectedStatus.toString(), transactionType.data("value"), selectedPurpose.toString());

			$.each(formArr, function(index, value){
				if(value ==  undefined ||  value == "선택" || value == "" ) {
					warning.eq(index).removeClass('hidden');
				} else {
					warning.eq(index).addClass('hidden');
				}
			});
			if(searchForm.find('.warning.hidden').length == formArr.length){
				getDataList(page, formArr);
			} else {
				return false;
			}
		});

		function getSpcList() {
			const spcList = $('#spcList');
			const cloned = spcList.clone().html();
			let page = 1;
			let action = 'get';
			let syncOpt = true;
			let option = {
				url: apiHost + "/spcs?oid="+oid,
				type: action,
				async: syncOpt
			}
			$.ajax(option).done(function (json) {
				let spcArr = [];
				let searchArr = [];
				spcList.empty();
				json.data.unshift({"spc_id": "allSelect", "name": "전체"});
				json.data.forEach((item, index) => {
					let listItem = '';
					let uniq = item.spc_id + '_' + index;
					let spcObj = {
						spc_id: item.spc_id,
						spc_name: item.name
					}
					spcInfoArr.push(spcObj);
					if(isEmpty(item.name)){
						listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, "spc_no_name"+ index).replace(/\*uniqName\*/g, uniq);
					} else {
						listItem = cloned.replace(/\*spcId\*/g, item.spc_id).replace(/\*spcName\*/g, item.name).replace(/\*uniqName\*/g, uniq);
					}
					spcList.append($(listItem));
					spcArr.push(item.spc_id);
					// console.log("spcname---", item)
				});
				spcArr.shift();
				selectAll($("#spcList"));
				searchArr.push(spcArr.toString())
				getDataList(page, searchArr)
			}).fail(function (jqXHR, textStatus, errorThrown) {
				alert('처리 중 오류가 발생했습니다.');
				return false;
			});
		}

		// const filtering = (predicate) => (reducing) => (acc, input) => (predicate(input) ? reducing(acc, input): acc)
		// var xhr = new XMLHttpRequest();
		// xhr.open('GET', 'myservice/username?id=some-unique-id');
		// xhr.onload = function() {
		// 	if (xhr.status === 200) {
		// 		alert('User\'s name is ' + xhr.responseText);
		// 	}
		// 	else {
		// 		alert('Request failed.  Returned status of ' + xhr.status);
		// 	}
		// };
		// xhr.send();

		// var xhr = new XMLHttpRequest();
		// xhr.open('PUT', 'myservice/user/1234');
		// xhr.setRequestHeader('Content-Type', 'application/json');
		// xhr.onload = function() {
		//     if (xhr.status === 200) {
		//         var userInfo = JSON.parse(xhr.responseText);
		//     }
		// };
		// xhr.send(JSON.stringify({
		//     name: 'John Smith',
		//     age: 34
		// }));


		function getDataList(page, searchOptArr) {
			var currentPage = '';
			page == undefined ? currentPage = "1" : currentPage = page;

			if(!isEmpty(searchOptArr)) {
				let action = 'get';
				let syncOpt = true;
				let option = {};
				if(searchOptArr.length>1){
					option= {
						url: apiHost + '/spcs/transactions',
						type: action,
						data: {
							'oid' : oid,
							'spcIds' : searchOptArr[0],
							'startDay' : searchOptArr[1],
							'endDay' : searchOptArr[2]
						},
						async: syncOpt
					}
				} else {
					option = {
						url: apiHost + '/spcs/transactions',
						type: action,
						data: {
							'oid' : oid,
							'spcIds' : searchOptArr[0]
						},
						async: syncOpt
					}
				}
	
				$.ajax(option).done(function (json, textStatus, jqXHR) {
					$('#searchOption').removeClass('in');
					tableBody.empty();
					tableFooter.empty();
					// console.log("json---", json.data)
					if (json.data.length > 0) {
						// console.log("json.data---", json.data)
						let perPage = 14;
						let startNum = (Number(currentPage) - 1) * perPage;
						let endNum = Number(currentPage) * perPage + 1;
						// console.log("start---", startNum, "end===", endNum)

						if(searchOptArr.length>1){
							let statusOpt = [...searchOptArr[3].split(",")];
							let newData = json.data.filter(x => {
								return statusOpt.indexOf(x.status.toString()) > -1
							});
							ajaxCallback(Number(currentPage), newData.slice(startNum, endNum), searchOptArr);
							makeNavigation(Number(currentPage), searchOptArr[0], newData.length)
						} else {
							ajaxCallback(Number(currentPage), json.data.slice(startNum, endNum));
							makeNavigation(Number(currentPage), searchOptArr[0], json.data.length);
						}
					}
				}).fail(function (jqXHR, textStatus, errorThrown) {
					alert('처리 중 오류가 발생했습니다.');
					return false;
				});
			} else {
				$("#warningModal .modal-title").text("검색된 SPC 가 없습니다.");
				$("#warningModal").modal("show");
			}
		}

		function ajaxCallback(currentPage, newData, arr) {
			let totalAmount = 0;
			var page = currentPage;
			newData.map((item, index) => {
				// console.log("item===", item)
				totalAmount += item.total_amount;
				if(!isEmpty(arr)) {
					item.opt = arr;	
				}
				return new Promise((resolve, reject) => {
					// typeof v.to_account !== "string" ? JSON.parse(v.to_account) : v.to_account = v.to_account	
						resolve(JSON.parse(item.to_account))
					}).then(res => {
						// let item = Object.assign({}, item);
						// console.log("res===", res, "item===", item)
						// console.log("item==", item, "res====", res)
						// delete(item.to_account);
						const spcMatch = spcInfoArr.findIndex(x => x.spc_id === item.spc_id);
						let perPage = 14;
						let tbodyStr = '';
						let transaction_spc_id = '';
						let transaction_req_id = '';
						let transaction_spc_name = ''
						transaction_spc_name = spcInfoArr[spcMatch].spc_name;
						// withdraw date
						let withdraw_day = item.withdraw_day.substring(0, 4) + '-' + item.withdraw_day.substring(4, 6) + '-' + item.withdraw_day.substring(6, 8);
						let withdraw_bank_name = '';
						let withdraw_acc_num = '';
						if(!isEmpty(withdraw_bank_name)) {
							withdraw_bank_name = item.withdraw_bank;
						} else {
							withdraw_bank_name = '-';
						}
						if(!isEmpty(withdraw_acc_num)) {
							withdraw_acc_num = item.withdraw_account_no;
						} else {
							withdraw_acc_num = '-'
						}
						console.log("withdraw_acc_num==", withdraw_acc_num, "withdraw_bank_name====", withdraw_bank_name)
						let transaction_type = '';
						res.length > 0 ? ( res.length ==1 ? ( transaction_type = '출금' ) : ( transaction_type = '출금 '+ (res.length) + '건' ) ): ( transaction_type = '-' );
						let amount = '';
						let updated_at = ''
						let requested_by = '';
						let approved_by = '';
						let status_changed_by = '';
						// status
						let status = '';
						let status_val = '';
						// delete icon
						let visibility = '';
						let link_attr = '';
						let purposeList = [
							{ label: "출금", value: [ "REC 수익", "SMP 수익", "DSRA 적립", "기타", "유보 계좌", "운영 계좌" ]},
							{ label: "입금", value: [ "관리 운영비", "사무 수탁비", "부채 상환", "대 수선비", "배당금 적림", "일반 지출" ]},
						];
						let account_type_list = [ "전력 판매대금", "REC 판매대금", "관리 운영비", "일반 렌탈", "전력중개 수수료", "전기 요금", "원리금" ];
						let purpose = '';

						const p = [];
						let size = '';

						for(let i=0, arrayLength =res.length; i<arrayLength; i++){
							p.push(res[i].purpose);
						}

						if(!isEmpty(item.opt)){
							let acc = [...item.opt[5].split(',')];
							res.filter(x => {
								let match = acc.indexOf(x.purpose.toString()) > -1;
								// console.log("x===", x)
								return acc.indexOf(x.purpose.toString()) > -1;
							});
							// statusOpt.indexOf(x.status.toString()) > -1

							// console.log("res===", res)
						}
						// console.log("res===", res)
						let uniqSet = new Set(p);
						if( uniqSet.size === 0 ) {
							purpose = '-'
						} else if( uniqSet.size == 1 ) {
						purpose = ( purposeList[0].value[p[0]] )
						} else {
							purpose = ( purposeList[0].value[p[0]] ) + ' 외 +' + ( uniqSet.size - 1 ) + '건';
						}
						transaction_spc_id = item.spc_id;
						transaction_req_id = item.request_id;

						if(item.status == 0) {
							status="반송"
							status_val = "0"
							visibility = "show";
							link_attr = "text-link";
						} else if(item.status == 1) {
							status="승인 대기"
							status_val = "1"
							visibility = "show";
							link_attr = "text-link";
						} else if (item.status == 2) {
							status="승인 중"
							status_val = "2"
							link_attr = "text-link";
							visibility = "hidden";
						} else if(item.status == 3) {
							status="승인 완료"
							status_val = "3"
							visibility = "hidden";
							link_attr = "text-blue";
						}
						
						item.total_amount ? ( amount = item.total_amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' 원' ) : amount = '-';

						( ( item.requested_by !== undefined ) && ( item.requested_by != "string" ) ) ? ( requested_by = item.requested_by ) : ( requested_by = '-' );

						// console.log("()===", item.status_changed_at )

						item.status_changed_at ? ( updated_at = ( new Date(item.status_changed_at).toLocaleDateString("ja-JP").replace(/\//g, '-') + '&emsp;&emsp;' + new Date(item.status_changed_at).toLocaleTimeString()) ) : ( updated_at = '-' );

						item.status_changed_by ? ( approved_by = item.status_changed_by ) : ( approved_by = '-' );

						// res.to_account_bank.locale
						tbodyStr = tbodyClone.replace(/\*index\*/g, (Number(page)-1)*perPage + Number(index)+1 )
							.replace(/\*transactionSpcId\*/g, transaction_spc_id)
							.replace(/\*transactionSpcName\*/g, transaction_spc_name)
							.replace(/\*transactionReqId\*/g, transaction_req_id)
							.replace(/\*withdrawDay\*/g, withdraw_day)
							.replace(/\*withdrawBankName\*/g, withdraw_bank_name).replace(/\*withdrawAccountNum\*/g, withdraw_acc_num)
							.replace(/\*transactionType\*/g, transaction_type)
							.replace(/\*purpose\*/g, purpose)
							.replace(/\*accountType\*/g, account_type_list[res.length])
							.replace(/\*amount\*/g, amount)
							.replace(/\*updatedAt\*/g, updated_at)
							.replace(/\*requestedBy\*/g, requested_by)
							.replace(/\*approvedBy\*/g, approved_by)
							.replace(/\*status\*/g, status)
							.replace(/\*statusVal\*/g, status_val)
							.replace(/\*linkAttr\*/g, link_attr).replace(/\*visibility\*/g, visibility)
							.replace(/\*statusChangedBy\*/g, status_changed_by);
						tableBody.append($(tbodyStr));
					}).then(result => {
						// console.log('result==', result); // 3
					}, function(error){
						if(error){
							console.log("error", error);
							return false;
						};
					});
			})
			// let sum = totalAmount.toLocaleString('kr-KO');
			let str = totalAmount.toString();
			// str = sum.replace(/\d(?=(\d{3})+\.)/g, '$&,')
			// console.log("total---", sum)
			let tfootStr = '';
			tfootStr = tfootClone.replace(/\*total\*/g, totalAmount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,'))
			tableFooter.append($(tfootStr));
		}

		// function setTotal(sum) {
		// 	console.log("sum---", sum)
		// }

		
		// function nvl(value, str) {
		// 	if (isEmpty(value)) {
		// 		return str;
		// 	} else {
		// 		return value;
		// 	}
		// }

		// function getCsvDown() {
		// 	var column = ['name', '발전소_명', '설치_용량', '관리_운영_기간', '', ''], //json Key
		// 		header = ['SPC명', '발전소 명', '용량', '관리 운영기간	', '이관자료', '첨부파일']; //csv 파일 헤더

		// 	getJsonCsvDownload($('#listData').data('gridJsonData'), column, header, 'spc_spower.csv'); // json list, 컬럼, 헤더명, 파일명
		// }

		function getDiff (eDate, sDate, type) {
			eDate = new Date(eDate.substring(2, 4), eDate.substring(4, 6), eDate.substring(6, 8));
			sDate = new Date(sDate.substring(2, 4), sDate.substring(4, 6), sDate.substring(6, 8));
			if (type == 'day') {
				return (((((eDate - sDate) / 1000) / 60) / 60) / 24) + 1;
			} else if (type == 'month') {
				if (eDate.format('yyyyMMdd').substring(0, 4) == sDate.format('yyyyMMdd').substring(0, 4)) {
					return (eDate.format('yyyyMMdd').substring(4, 6) * 1 - sDate.format('yyyyMMdd').substring(4, 6) * 1) + 1;
				} else {
					return Math.round((eDate - sDate) / (1000 * 60 * 60 * 24 * 365 / 12)) + 1;
				}
			}
		}

		function makeNavigation (currentPage, spcId, dataLength) {
			// console.log("spc===", spcId)
			$('#pagination').empty();
			let maxPages = 5;
			let pageStr = '';
			let totalPage = Math.ceil( dataLength / perPage );
			let navGroup = Math.floor((page - 1) / perPage) + 1;
			let startPage = ((navGroup - 1) * perPage) + 1;
			let totalNav = Math.ceil(totalPage / perPage);
			let endPage = ((startPage + perPage - 1) > totalPage) ? totalPage : (startPage + navCount - 1);

			// console.log("dataLength===", dataLength, "endPage===", endPage);

			if (navGroup == 1) {
				// console.log("navGroup == 1===")
				pageStr += '<a href="javascript:void(0);" data-value="1" class="btn-prev first-arrow"></a>';
			} else {
				let prev = currentPage - 1;
				console.log("totoalPAge===", totalPage)
				pageStr += '<a href="javascript:void(0);" data-value="' + prev + '" class="btn-prev last-arrow"></a>';
			}

			for (let i = startPage ; i <= endPage; i++) {
				// console.log("startPage===", startPage)
				if (i==currentPage) {
					pageStr += '<a href="javascript:void(0);" class="active" data-value="'+ i +'">'+i+'</a>';
				} else {
					pageStr += '<a href="javascript:void(0)" class="" data-value="'+ i +'">'+i+'</a>';
				}
			}

			if (navGroup < totalNav) {
				// console.log("navGroup < totalNav===", totalNav, "endPage===", endPage)
				let current = currentPage + 1;
				pageStr += '<a href="javascript:void(0);" class="btn-next" data-value="'+ current +'></a>';
			} else {
				let current = currentPage + 1;
				// console.log("navGroup > totalNav===", totalNav, "endPage===", currentPage + 1)
				pageStr += '<a href="javascript:void(0);" class="btn-next" data-value="' + current + '"></a>';
			}
			$('#pagination').append(pageStr);

			$('#pagination a').on("click", function(){

				let page = $(this).data("value");
				if(currentPage == page) {
					return false;
				}

				spcInfoArr.shift();
				let newArr = [];
				newArr.push(spcInfoArr.map(x=> x.spc_id).join());

				// let join = spcId.join();
				// newArr.push(join);
				// console.log("newArr----", newArr)
				// console.log("newArr----", newArr)
				getDataList(page, newArr);
				return false;
			});

		}

		function getNumberIndex(index) {
			return index + 1;
		}

		function comparer(index) {
			return function(a, b) {
				var valA = getCellValue(a, index), valB = getCellValue(b, index)
				return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.toString().localeCompare(valB)
			}
		}

		function getCellValue(row, index){
			return $(row).children('td').eq(index).text()
		}

	});

	function deleteRow(selector) {
		let delPrompt = prompt('해당 요청서를 삭제하시겠습니까? \n삭제를 원하시면 아래 "삭제" 라고 입력하고 확인을 눌러 주세요.', '');
		if (delPrompt != '삭제') {
			return false;
		}
		let reqId = $(selector).prev().data("id");
		console.log("reqid---", reqId);

		let option= {
			url: apiHost + '/spcs/transactions/' + reqId + '?oid=' + oid,
			type: 'DELETE',
			async: true
		}
		console.log("option---", option)

		$.ajax(option).done(function (json, textStatus, jqXHR) {
			document.location.reload(true);
		}).fail(function (jqXHR, textStatus, errorThrown) {
			alert('처리 중 오류가 발생했습니다.');
			console.log("error===", jqXHR)
			return false;
		});
		// $(selector).parents().closest("tr").css("border", "none");
		// console.log("tr===", $(selector).parents().closest("tr"))
	}

	function goToDetail(self) {
		let spcId = $(self).parents().closest("td").data("id");
		let spcName = $(self).parents().closest("td").data("name");
		let reqId = self.data("id");
		let accNum = self.data("value");
		let status = self.text();
		let statusVal = self.parent().data("value");

		$("#transactionSpcId").val(spcId);
		$("#transactionSpcName").val(spcName);
		$("#transactionReqId").val(reqId);
		$("#transactionAccountInfo").val(accNum);
		$("#transactionStatus").val(status);
		$("#transactionStatusVal").val(statusVal);

		// [사무수탁사]
		// "반송" : 0, "승인 중" : "2", "승인완료": "3"	 => /spc/withdrawReqStatusDetail.do
		// "승인 대기" : 1" 						  => /spc/withdrawReqEdit.do

		if(self.parent().data("value")==1) {
			$("#transactionEditForm").submit();
		} else {
			console.log("detail===")
			$("#transactionDetailForm").submit();
		}
	}
</script>

<form id="transactionDetailForm" class="" action="/spc/withdrawReqStatusDetail.do" method="post">
	<input type="hidden" id="transactionSpcId" name="review_spc_id" value=''/>
	<input type="hidden" id="transactionSpcName" name="review_spc_name" value=''/>
	<input type="hidden" id="transactionReqId" name="review_req_id" value=''/>
	<input type="hidden" id="transactionAccountInfo" name="review_acc_info" value=''/>
	<input type="hidden" id="transactionStatus" name="review_status" value=''/>
	<input type="hidden" id="transactionStatusVal" name="review_status_val" value=''/>
	<!-- <button id="forwardDetailBtn" type="submit" class="hidden"></button> -->
</form>


<form id="transactionEditForm" class="" action="/spc/withdrawReqEdit.do" method="post">
	<input type="hidden" id="transactionSpcId" name="review_spc_id" value=''/>
	<input type="hidden" id="transactionSpcName" name="review_spc_name" value=''/>
	<input type="hidden" id="transactionReqId" name="review_req_id" value=''/>
	<input type="hidden" id="transactionAccountInfo" name="review_acc_info" value=''/>
	<input type="hidden" id="transactionStatus" name="review_status" value=''/>
	<input type="hidden" id="transactionStatusVal" name="review_status_val" value=''/>
	<!-- <button id="forwardDetailBtn" type="submit" class="hidden"></button> -->
</form>

<div class="modal fade" id="warningModal" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content collection_modal_content">
			<div class="modal-header">
				<h4 lass="modal-title">조회된 데이터가 없습니다.</h4>
			</div>
			<div class="modal-footer">
				<div class="btn_wrap_type02">
					<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
					<button type="submit" id="confirmBtn" class="btn_type">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class='row header-wrapper'>
	<div class='col-12'>
		<h1 class='page-header'>입출금 관리 내역</h1>
		<div class="time fr"><span>CURRENT TIME</span><em class="currTime">${nowTime}</em><span>DATA BASE TIME</span><em class="dbTime"></em></div>
	</div>
</div>

<div class='row spc-search-bar header-wrapper'>
	<div class='col-11'><!--
	--><form id='transactionForm'><!--
		--><span class='tx_tit'>SPC 선택</span><!--
		--><div class='sa_select'>
				<div class='dropdown'>
					<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택" data-value="" value="">선택<span class='caret'></span></button>
					<ul id='spcList' class='dropdown-menu chk_type' role='menu'>
						<li data-value="*spcId*"><!--
						--><a href="javascript:void(0);" tabindex="-1"><!--
							--><input type="checkbox" id="*spcName*" value="*spcId*" data-value="*spcId*" name="*uniqName*"><!--
							--><label for="*spcName*">*spcName*</label><!--
						--></a><!--
					--></li><!--
				--></ul>
					<small class="hidden warning">선택해 주세요.</small>
				</div>
			</div><!--
		--><div class='dropdown'>
				<button type='button' id='collapseBtn' class='btn btn-primary dropdown-toggle no_bg w-100 ml-24' data-toggle='collapse' data-target='#searchOption'>상세 조건<span class='caret'></span></button>
				<ul id='searchOption' class='collapse dropdown-menu unused'>
					<li class="ml-6">
						<div class='bx_row aN3'>
							<h2 class='comp_tit'>입출금 조회 기간</h2>
							<div id="dateTerm" class='bx_align mr-30 dropdown'>
								<button type='button' class='btn btn-primary dropdown-toggle' data-toggle='dropdown' data-target="#dateTerm" data-name="선택" value="">선택<span class='caret'></span></button>
								<ul id="unitOpt" class='dropdown-menu dropdown_offset' role='menu'>
									<li data-value="yearly"><a href='javascript:void(0)' tabindex='-1'>년</a></li>
									<li data-value="monthly"><a href='javascript:void(0)' tabindex='-1'>월</a></li>
									<li data-value="daily"><a href='javascript:void(0)' tabindex='-1'>일</a></li>
								</ul>
							</div>
							<div class='w-33 dropdown'>
								<input type='text' id='fromDate' name='fromDate' class='sel fromDate w-100' value='' autocomplete='off' placeholder='시작'>
								<small class="hidden warning">선택해 주세요.</small>
							</div><!--
						--><div class='w-33 ml-12 dropdown'>
								<input type='text' id='toDate' name='toDate' class='sel toDate w-100' value='' autocomplete='off' placeholder='종료'>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
						</div>
					</li>
					<li class="ml-6">
						<div class='bx_row aN3'>
							<div class='bx_align dropdown'>
								<h2 class='comp_tit'>상태</h2>
								<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택" value="">선택<span class='caret'></span></button>
								<ul id="spcStatus" class='dropdown-menu chk_type dropdown_offset' role='menu'>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='allSelect' value='' data-value='0,1,2,3' name='approvalStatus'>
											<label for='allSelect'>전체</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='approved' value='' data-value='3' name='approvalStatus'>
											<label for='approved'>승인 완료</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='onHold' value='' data-value='1' name='approvalStatus'>
											<label for='onHold'>승안 대기</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='inProgress' value='' data-value='2' name='approvalStatus'>
											<label for='inProgress'>승인 중</label>
										</a>
									</li>
									<li>
										<a href='javascript:void(0)' tabindex='-1'>
											<input type='checkbox' id='rejected' value='' data-value='0' name='approvalStatus'>
											<label for='rejected'>반송</label>
										</a>
									</li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
							<div class='bx_align dropdown'>
								<h2 class='comp_tit'>입출금 구분</h2>
								<button type='button' class='btn btn-primary dropdown-toggle' data-toggle='dropdown' value="">선택<span class='caret'></span></button>
								<ul id="transactionType" class='dropdown-menu dropdown_offset' role='menu'>
									<li data-value='deposit'><a href='javascript:void(0)' tabindex='-1'>입금</a></li>
									<li data-value='withdraw'><a href='javascript:void(0)' tabindex='-1'>출금</a></li>
								</ul>
								<small class="hidden warning">선택해 주세요.</small>
							</div>
							<div class='bx_align'>
								<h2 class='comp_tit'>용도 구분</h2>
								<div class='dropdown'>
									<button class='btn btn-primary dropdown-toggle' type='button' data-toggle='dropdown' data-name="선택">선택<span class='caret'></span></button>
									<ul id="spcPurposeList" class='dropdown-menu chk_type dropdown_offset' role='menu'>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='allPurpose' data-value='all' data-name="selectAll" name='spcPurpose'>
												<label for='allPurpose'>전체</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)'tabindex='-1'>
												<input type='checkbox' id='recMargin' data-value='0' data-name="REC 수익" name='spcPurpose'>
												<label for='recMargin'>REC 수익</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='smpMargin' data-value='1' data-name="SMP 수익" name='spcPurpose'>
												<label for='smpMargin'>SMP 수익</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='dsraSaving' data-value='2' data-name="DSRA 적립" name='spcPurpose'>
												<label for='dsraSaving'>DSRA 적립</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='etc' data-value='3' data-name="기타" name='spcPurpose'>
												<label for='etc'>기타</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='pendingAccount' data-value='4' data-name="유보 계좌" name='spcPurpose'>
												<label for='pendingAccount'>유보 계좌</label>
											</a>
										</li>
										<li>
											<a href='javascript:void(0)' tabindex='-1'>
												<input type='checkbox' id='activeAccount' data-value='5' data-name="운영 계좌" name='spcPurpose'>
												<label for='activeAccount'>운영 계좌</label>
											</a>
										</li>
									</ul>
									<small class="hidden warning">선택해 주세요.</small>
								</div>
							</div>
						</div>
					</li>
					<li class='btn_wrap_type03 btn_wrap_border'>
						<button type='button' data-toggle='collapse' data-target='#searchOption' class='btn_type03' id='closeDropdown'>취소</button>
						<button type='submit' class='btn_type ml-6'>검색</button>
					</li>
				</ul>
			</div>
		</form>
	</div>
	<div class="col-1">
		<div class='dropdown fr'><!--
		--><button class="btn btn-primary dropdown-toggle w-100" type="button" data-toggle="dropdown" value="" aria-expanded="true">건 별<span class="caret"></span></button><!-- 
		--><ul id='sumOptList' class='dropdown-menu' role='menu'><!--
			--><li data-value="noSum"><a href="javascript:void(0)" tabindex="-1">건 별</a></li><!--
			--><li data-value="monthSum"><a href="javascript:void(0)" tabindex="-1">월 별</a></li><!--
			--><li data-value="yearSum"><a href="javascript:void(0)" tabindex="-1">년 별</a></li><!--
		--></ul>
		</div>
	</div>
</div>


<div class='row spc-transaction'>
	<div class='col-12'>
		<div class='indiv'>
			<div class='spc_tbl'>
				<table class='sort_table table-footer transaction-table'>
					<colgroup>
						<col style='width:5%'>
						<col style='width:10%'>
						<col style='width:9%'>
						<col style='width:10%'>
						<col style='width:10%'>
						<col style='width:12%'>
						<col style='width:12%'>
						<col style='width:10%'>
						<col style='width:10%'>
						<col style='width:12%'>
						<col>
					</colgroup>
					<thead>
						<tr>
							<!-- <th><button class='btn_align down'>순번</button></th> -->
							<th>순번</th>
							<th><button class='btn_align down'>입출금 일자</button></th>
							<th><button class='btn_align down'>입출금 구분</button></th>
							<th><button class='btn_align down'>용도 구분</button></th>
							<th><button class='btn_align down'>계좌 구분</button></th>
							<th><button class='btn_align down'>금액</button></th>
							<th><button class='btn_align down'>최종 업데이트</button></th>
							<th>요청자</th>
							<th>승인자</th>
							<th class='left'><button class='btn_align down'>상태</button></th>
						</tr>
					</thead>
					<tbody id='tableBody'>
						<tr><td colspan='9' class='no-data center'>데이터가 없습니다.</td></tr></tr>
						<template class='table-body'>
							<tr>
								<td>*index*</td>
								<td>*withdrawDay*</td>
								<td>*transactionType*</td>
								<td>*purpose*</td>
								<td>*accountType*</td>
								<td class="right">*amount*</td>
								<td>*updatedAt*</td>
								<td>*requestedBy*</td>
								<td>*approvedBy*</td>
								<td class='left' data-id="*transactionSpcId*" data-name="*transactionSpcName*" data-value="*statusVal*"><!--
								--><div class="flex_start"><a href="javascript:void(0);" class="*linkAttr*" data-name="*withdrawBankName*" data-value="*withdrawAccountNum*" data-id="*transactionReqId*" onclick="goToDetail($(this))">*status*</a><!--
									--><a href="javascript:void(0);" onclick="deleteRow(this)" class='icon-delete *visibility*'></a><!--
								--></div>
								</td>
							</tr>
						</template>
					</tbody>
					<tfoot id="tableFooter">
						<template class='table-footer'>
							<tr>
								<td></td>
								<td>합계</td>
								<td colspan='3'></td>
								<td>*total* 원</td>
								<td colspan='4'></td>
							</tr>
						</template>
					</tfoot>
				</table>
				<div class='pagination' id='pagination'></div>
			</div>
		</div>
	</div>
</div>