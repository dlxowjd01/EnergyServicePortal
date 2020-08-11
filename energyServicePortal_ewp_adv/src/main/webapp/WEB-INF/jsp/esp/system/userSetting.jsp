<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp" %>

<script src="/js/commonDropdown.js"></script>
<script type="text/javascript">
	$(function () {
		// let table = $("#userTable");
		let option = {
			url: apiHost + "/config/users/",
			type: "get",
			async: true,
			data: {
				uid: userInfoId,
				oid: oid
			},
			beforeSend: function (jqXHR, settings) {
				$('.loading').show();
			},
		}

		getUserList(option);

		$("#userTable").on("click", "input[type='checkbox']", function(e, dt, type, indexes ){
			let tr = $(this).closest("tr");
			tr.addClass("selected");
			console.log("tr===", tr.siblings());
			// table[ type ]( indexes ).nodes().to$().addClass( 'custom-selected' );

		});

		// table.on( 'deselect', function ( e, dt, type, indexes ) {
		// 	console.log("deselect===");
		// 	table[ type ]( indexes ).nodes().to$().removeClass( 'custom-selected' );
		// });

		function getUserList(opt) {
			$.ajax(opt).done(function (json, textStatus, jqXHR) {
				let data = json;
				let newArr = [];
				// console.log("data---", data);

				data.map((item, index)=> {
					// console.log("item---", item);
					let obj = {};
					obj.idx = index + 1;

					obj.user_id = item.login_id;

					if(!isEmpty(item.name)){
						obj.name = item.name;
					} else {
						obj.name = "-";
					}

					if(!isEmpty(item.contact_phone)){
						obj.contact_phone = item.contact_phone;
					} else {
						obj.contact_phone = "-";
					}

					if(!isEmpty(item.contact_email)){
						obj.contact_email = item.contact_email;
					} else {
						obj.contact_email = "-";
					}

					if(!isEmpty(item.team)){
						obj.team = item.team;
					} else {
						obj.team = "-";
					}
				
					if(item.role == 1){
						obj.user_role = "조직 관리자"
					} else {
						obj.user_role = "일반 사용자"
					}

					if(item.task == 0){
						obj.user_task = "일반"
					} else if(item.task == 1){
						obj.user_task = "사무 수탁사"
					} else if(item.task == 2){
						obj.user_task = "자산 운용사"
					} else if(item.task == 3){
						obj.user_task = "사업주"
					}

					if(!isEmpty(item.createdAt)){
						let d = new Date(item.createdAt).toLocaleDateString("en-CA").replace(/\//g, '-') + '&emsp;&emsp;' + new Date(item.createdAt).toLocaleTimeString();
						obj.created_at = d;
					} else {
						obj.created_at = "-";
					}
				
					if(!isEmpty(item.valid_yn)){
						obj.valid_yn = item.valid_yn;
					} else {
						obj.valid_yn = "-";
					}
					newArr.push(obj);
				});

				$('#userTable').dataTable({
					"aaData": newArr,
					// "fixedHeader": true,
					"scrollX": false,
					"scrollY": "400px",
					"lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
					"aoColumns": [
						{
							"sTitle": "",
							"mData": "",
							"mRender": function ( data, type, row )  {
								// onclick="onlyOne(this.children[0]);"
								// select-checkbox
								return '<a href="javascript:void(0);" class="select-checkbox"><input type="checkbox" name="user_row" id="' + row.idx + '" class="select-checkbox" onclick="onlyOne(this);"><label for="' + row.idx + '"></label></a>'

								// return '<a href="javascript:void(0);" class="chk_type"><input type="checkbox" name="user_row" id="' + row.idx + '" class="select-checkbox" onclick="onlyOne(this);"><label for="' + row.idx + '"></label></a>'
							},
							"className": "dt-body-center"
						},
						{
							"sTitle": "순번",
							"mData": "idx",
						
						},
						{
							"sTitle": "ID",
							"mData": "user_id"
						},
						{
							"sTitle": "이름",
							"mData": "name",
						},
						{
							"sTitle": "휴대폰",
							"mData": "contact_phone",
						},
						{
							"sTitle": "이메일",
							"mData": "contact_email",
						},
						{
							"sTitle": "소속",
							"mData": "team",
						},
						{
							"sTitle": "권한 등급",
							"mData": "user_role",
						},
						{
							"sTitle": "업무 구분",
							"mData": "user_task",
						},
						{
							"sTitle": "등록일자",
							"mData": "created_at",
						},
						{
							"sTitle": "사용 여부",
							"mData": "valid_yn",
						},
					],
					dom: 'Bfltip',
					// dom: 'Bfrtip',
					buttons: [
						{
							text: '추가',
							className: "btn_type fr",
							attr:  {
								"data-toggle": "modal",
								"data-target": "#addUserModal",
								"data-backdrop": "static",
								"data-keyboard": "false"
							},
							// action: function (e, node, config){
							// 	$('#addUserModal').modal('show');
							// }
						}
					],
					select: {
						// style: 'os',
						style: 'single',
						selector: 'td:first-child',
						// items: 'cell',
						// items: 'row'
					},
					rowCallback: function ( row, data ) {
						// console.log("data--", data)
						// row.find("input[type='checkbox']").prop( 'checked', true );
	
						// $('input[type="checkbox"]', row).prop('checked', data.active == 1 );
					}
				})

			}).fail(function (jqXHR, textStatus, errorThrown) {
				return false;
			});
		}
	});

	function onlyOne(checkbox) {
		var checkboxes = document.getElementsByName('user_row');
		var table = $("#userTable");

		checkboxes.forEach((item, index) => {
			if (item !== checkbox) {
				item.checked = false;
			} else {
				let tr = $(checkbox).closest("tr");
				// console.log("tr---", tr);
				// tr.addClass("selected");
				// tr.siblings().removeClass("selected");
			}
		});
	}

</script>

<div class="row header-wrapper">
	<div class="col-12">
		<h1 class="page-header">사용자 관리 설정</h1>
	</div>
</div>


<div class="row">
	<div class="col-12">
		<div class="flex_group">
			<span class="tx_tit">사용자 유형</span>
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button"
					data-toggle="dropdown">선택<span class="caret"></span></button>
				<ul class="dropdown-menu" id="userList">
					<li><a href="#" tabindex="-1">전체</a></li>
					<li><a href="#" tabindex="-1">관리자</a></li>
					<li><a href="#" tabindex="-1">일반 사용자</a></li>
				</ul>
			</div>
		</div>

		<div class="flex_group">
			<div class="flex_start">
				<div class="tx_inp_type">
					<input type="text" id="key_word" placeholder="입력">
				</div>
				<button type="button" class="btn_type ml-16" onclick="getDataList();">검색</button>
			</div>
		</div>
	</div>
</div>

<div class="row content-wrapper">
	<div class="col-12">
		<div class="indiv">
			<table id="userTable" class="stripe">
				<thead></thead>
				<tbody>
				</tbody>
				<tfoot>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</div>

<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModal" aria-hidden="true">
	<div class="modal-dialog modal-md">
		<div class="modal-content add-user-content">
			<div class="modal-header"><h1>사용자 추가</h1></div>
			<div class="modal-body">
				<div class="container-fluid">
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">ID</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9">
							<div class="tx_inp_type">
								<input type="text" id="worker" name="worker" placeholder="입력" maxlength="10">
								<small class="hidden warning">사용자 ID를 입력해 주세요</small>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">비밀번호</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-93">
							<div class="tx_inp_type">
								<input type="text" id="pwd" name="pwd" placeholder="입력" maxlength="10">
								<small class="hidden warning">사용자 패스워드를 입력해 주세요</small>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">이름</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9">
							<div class="tx_inp_type">
								<input type="text" id="fullName" name="full_name" placeholder="입력" maxlength="10">
								<small class="hidden warning">이름을 입력해 주세요</small>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">권한 등급</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-93">
							<div class="dropdown" id="userPwd">
								<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value=""><a href="#">조직 관리자</a></li>
									<li data-value=""><a href="#">일반 사용자</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">휴대폰</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9">
							<div class="tx_inp_type">
								<input type="text" id="mobileNum" name="mobil_num" placeholder="입력" minlength="9">
								<small class="hidden warning">휴대폰 번호를 입력해 주세요</small>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">이메일</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-93">
							<div class="tx_inp_type">
								<input type="text" id="emailAddr" name="email_addr" placeholder="입력" minlength="9">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">소속</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9">
							<div class="tx_inp_type">
								<input type="text" id="affiliation" name="affiliation" placeholder="입력" minlength="9">
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">업무 구분</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-93">
							<div class="dropdown" id="userPwd">
								<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="0"><a href="#">일반</a></li>
									<li data-value="1"><a href="#">사무 수탁사</a></li>
									<li data-value="2"><a href="#">자산 운용사</a></li>
									<li data-value="3"><a href="#">사업주</a></li>
								</ul>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">사용 여부</span>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-9">
							<div class="dropdown" id="userPwd">
								<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
								<ul class="dropdown-menu">
									<li data-value="y"><a href="#">Y</a></li>
									<li data-value="n"><a href="#">N</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-2 col-md-2 col-sm-3">
							<span class="input_label">설명</span>
						</div>
						<div class="col-lg-10 col-md-10 col-sm-9">
							<textarea name="user_desc" id="userDesc" class="textarea w-100" placeholder="입력"></textarea>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<ul class="nav nav-tabs">
								<li class="active w-50"><a data-toggle="tab" href="#menu1">사업소</a></li>
								<li class="w-50"><a data-toggle="tab" href="#menu2">SPC</a></li>
							  </ul>
						</div>
					</div>

					<div class="tab-content">
						<div id="menu1" class="tab-pane fade in active">
							<button type="button" class="btn_add" onclick="addRow('pwdList');">추가</button>
							<div id="pwdList" class="flex_start px-12">
								<div class="dropdown w-35" id="userPwd">
									<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="y"><a href="#"></a></li>
									</ul>
								</div>
								<div class="dropdown ml-16 w-25" id="userPwd">
									<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="y"><a href="#">수정/조회</a></li>
										<li data-value="n"><a href="#">조회</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div id="menu2" class="tab-pane fade">
							<div class="flex_start px-12">
								<div class="dropdown w-35" id="userPwd">
									<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="y"><a href="#"></a></li>
									</ul>
								</div>
								<div class="dropdown ml-16 w-25" id="userPwd">
									<button class="btn btn-primary dropdown-toggle required" type="button" data-toggle="dropdown">선택<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li data-value="y"><a href="#"></a></li>
										<li data-value="n"><a href="#"></a></li>
									</ul>
								</div>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-12">
							<div class="btn_wrap_type02">
								<button type="button" class="btn_type03" data-dismiss="modal" aria-label="Close">취소</button>
								<button type="submit" id="addUserBtn" class="btn_type">확인</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>