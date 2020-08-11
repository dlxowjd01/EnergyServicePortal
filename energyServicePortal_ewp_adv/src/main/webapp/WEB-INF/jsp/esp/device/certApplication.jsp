<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/decorators/include/taglibs.jsp" %>
<script type="text/javascript" src="/js/commonDropdown.js"></script>
<script type="text/javascript">

	//후처리
	const rtnDropdown = ($dropdownId) => {
		if ($dropdownId == 'certType') {
			const data = $('#' + $dropdownId).find('button').data('value');
			if (data == '기기등록') {
				$('#certType1').removeClass('hidden');
				$('#certType2').addClass('hidden');
				$('#certType3').addClass('hidden');
				$('#certType4').addClass('hidden');
			} else if (data == '발급') {
				$('#certType1').addClass('hidden');
				$('#certType2').removeClass('hidden');
				$('#certType3').addClass('hidden');
				$('#certType4').addClass('hidden');
			} else if (data == '갱신') {
				$('#certType1').addClass('hidden');
				$('#certType2').addClass('hidden');
				$('#certType3').removeClass('hidden');
				$('#certType4').addClass('hidden');
			} else {
				$('#certType1').addClass('hidden');
				$('#certType2').addClass('hidden');
				$('#certType3').addClass('hidden');
				$('#certType4').removeClass('hidden');
			}
		}
	}
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">기기인증서 신청</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<form>
		<div class="indiv spc-detail">
			<div class="flex_start">
				<h2 class="tx_tit">업무 구분</h2>
				<div class="sa_select">
					<div id="certType" class="dropdown">
						<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown" data-value="">
							기기등록 <span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li data-value="기기등록"><a href="javascript:void(0);">기기등록</a></li>
							<li data-value="발급"><a href="javascript:void(0);">기기인증서 발급</a></li>
							<li data-value="갱신"><a href="javascript:void(0);">기기인증서 갱신</a></li>
							<li data-value="폐기"><a href="javascript:void(0);">기기인증서 폐기</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div id="certType1" class="mt20">
				<div class="flex_start">
					<h2 class="tx_tit">기기인증서 발급 정책</h2>
					<div class="sa_select">
						<div class="dropdown">
							<button class="btn btn-primary dropdown-toggle w5" type="button" data-toggle="dropdown" data-value="">
								선택 <span class="caret"></span>
							</button>
							<ul class="dropdown-menu" role="menu">
								<li data-value=""><a href="javascript:void(0);">기기인증서버용</a></li>
								<li data-value=""><a href="javascript:void(0);">기기 CA</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="flex_start">
					<h2 class="tx_tit">제조사명</h2>
					<div class="tx_inp_type edit">
						<label for="제조사명" class="sr-only">제조사명</label>
						<input type="text" id="제조사명" name="제조사명" placeholder="제조사명 입력">
					</div>
				</div>
				<div class="flex_start">
					<h2 class="tx_tit">제조사명</h2>
					<div class="tx_inp_type edit">
						<label for="제품모델명" class="sr-only">제품모델명 입력</label>
						<input type="text" id="제품모델명" name="제품모델명" placeholder="제품모델명 입력">
					</div>
				</div>

				<div class="flex_wrapper mb-20 mt30">
					<h2 class="ntit">기기 정보 입력</h2>
				</div>
				<div class="tbl_wrap_type collect_wrap">
					<ul class="nav nav-tabs">
						<li class="nav-item active">
							<a class="nav-link" data-toggle="tab" href="#manual">기기정보 수동 입력</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" data-toggle="tab" href="#excel">기기정보 Excel 입력</a>
						</li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane fade active in spc_tbl_row st_edit panel-collapse collapse" id="manual">
							<table class="mt30">
								<colgroup>
									<col style="width:15%">
									<col style="width:35%">
									<col style="width:15%">
									<col style="width:35%">
								</colgroup>
								<tbody>
								<tr>
									<th><h2 class="tx_tit">수량</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="수량" name="수량" placeholder="수량 입력">
										</div>
									</td>
									<td colspan="2"><button type="button" class="btn_type big">수량 입력</button></td>
								</tr>
								<tr>
									<th><h2 class="tx_tit">기기 MAC</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="기기_MAC1" name="기기_MAC1" placeholder="기기 MAC 입력">
										</div>
									</td>
									<th><h2 class="tx_tit">시리얼번호</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="시리얼번호1" name="시리얼번호1" placeholder="시리얼번호">
										</div>
									</td>
								</tr>
								<tr>
									<th><h2 class="tx_tit">기기 MAC</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="기기_MAC2" name="기기_MAC2" placeholder="기기 MAC 입력">
										</div>
									</td>
									<th><h2 class="tx_tit">시리얼번호</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="시리얼번호2" name="시리얼번호2" placeholder="시리얼번호">
										</div>
									</td>
								</tr>
								<tr>
									<th><h2 class="tx_tit">기기 MAC</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="기기_MAC3" name="기기_MAC3" placeholder="기기 MAC 입력">
										</div>
									</td>
									<th><h2 class="tx_tit">시리얼번호</h2></th>
									<td>
										<div class="tx_inp_type edit">
											<input type="text" id="시리얼번호3" name="시리얼번호3" placeholder="시리얼번호">
										</div>
									</td>
								</tr>
								</tbody>
							</table>
						</div>
						<div class="tab-pane fade spc_tbl_row st_edit panel-collapse collapse" id="excel">
							<table class="mt30">
								<colgroup>
									<col style="width:15%">
									<col style="width:35%">
									<col style="width:15%">
									<col style="width:35%">
								</colgroup>
								<tbody>
								<th><h2 class="tx_tit">기기정보 EXCEL</h2></th>
								<td>
									<input type="file" id="file1" class="hidden" name="file1" accept=".xls, .xlsx">
									<label for="file1" class="btn file_upload">파일 선택</label>
									<span class="upload_text ml-16"></span>
									<button class="btn_close fixed_height hidden mt-0" onclick="$(this).parents().closest('.group_type').remove()"></button>
								</td>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="btn_wrap_type_right">
					<button type="button" class="btn_type big">신청</button>
				</div>
			</div>
			<div id="certType2" class="mt20 certType hidden">
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tbody>
						<tr>
							<th><h2 class="tx_tit">신청일</h2></th>
							<td>
								2020-05-20
							</td>
							<th><h2 class="tx_tit">기기등록</h2></th>
							<td>
								20건
							</td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">유효기간</h2></th>
							<td>
								5년
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">발급정책</h2></th>
							<td>테스트발급정책</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제조사명</h2></th>
							<td>테스트제조사</td>
							<th><h2 class="tx_tit">폐기</h2></th>
							<td>20건</td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제품모델명</h2></th>
							<td>테스트모델</td>
							<th></th>
							<td></td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="flex_wrapper mb-20 mt30">
					<h2 class="ntit">신청 기기정보</h2>
				</div>
				<div class="spc_tbl align_type">
					<table class="chk_type">
						<colgroup>
							<col style="width:15%">
							<col style="width:25%">
							<col style="width:15%">
							<col style="width:25%">
							<col/>
						</colgroup>
						<thead>
						<tr>
							<th>
								<input type="checkbox" id="chk_header" value="순번">
								<label for="chk_header">순번</label>
							</th>
							<th>MAC 주소</th>
							<th>시리얼번호 (SN)</th>
							<th>상태 변경일</th>
							<th>상태</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>
								<input type="checkbox" id="chk_op1" name="rowCheck" value="">
								<label for="chk_op1">1</label>
							</td>
							<td>00-00-00-00-00-01</td>
							<td></td>
							<td>2020-08-11</td>
							<td>기기등록</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="chk_op2" name="rowCheck" value="">
								<label for="chk_op2">2</label>
							</td>
							<td>00-00-00-00-00-02</td>
							<td></td>
							<td>2020-08-11</td>
							<td>기기등록</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="chk_op3" name="rowCheck" value="">
								<label for="chk_op3">3</label>
							</td>
							<td>00-00-00-00-00-03</td>
							<td></td>
							<td>2020-08-11</td>
							<td>발급</td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
				<div class="btn_wrap_type_right">
					<button type="button" class="btn_type big">발급</button>
					<button type="button" class="btn_type03">인증서 다운로드</button>
				</div>
			</div>
			<div id="certType3" class="mt20 certType hidden">
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tbody>
						<tr>
							<th><h2 class="tx_tit">신청일</h2></th>
							<td>
								2020-05-20
							</td>
							<th><h2 class="tx_tit">기기등록</h2></th>
							<td>
								20건
							</td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">유효기간</h2></th>
							<td>
								5년
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">발급정책</h2></th>
							<td>테스트발급정책</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제조사명</h2></th>
							<td>테스트제조사</td>
							<th><h2 class="tx_tit">폐기</h2></th>
							<td>20건</td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제품모델명</h2></th>
							<td>테스트모델</td>
							<th></th>
							<td></td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="flex_wrapper mb-20 mt30">
					<h2 class="ntit">신청 기기정보</h2>
				</div>
				<div class="spc_tbl align_type">
					<table class="chk_type">
						<colgroup>
							<col style="width:15%">
							<col style="width:25%">
							<col style="width:15%">
							<col style="width:25%">
							<col/>
						</colgroup>
						<thead>
						<tr>
							<th>
								<input type="checkbox" id="chk_header" value="순번">
								<label for="chk_header">순번</label>
							</th>
							<th>MAC 주소</th>
							<th>시리얼번호 (SN)</th>
							<th>상태 변경일</th>
							<th>상태</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>
								<input type="checkbox" id="chk_op1" name="rowCheck" value="">
								<label for="chk_op1">1</label>
							</td>
							<td>00-00-00-00-00-01</td>
							<td></td>
							<td>2020-08-11</td>
							<td>갱신가능</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="chk_op2" name="rowCheck" value="">
								<label for="chk_op2">2</label>
							</td>
							<td>00-00-00-00-00-02</td>
							<td></td>
							<td>2020-08-11</td>
							<td>갱신가능</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="chk_op3" name="rowCheck" value="">
								<label for="chk_op3">3</label>
							</td>
							<td>00-00-00-00-00-03</td>
							<td></td>
							<td>2020-08-11</td>
							<td>발급</td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
				<div class="btn_wrap_type_right">
					<button type="button" class="btn_type big">갱신</button>
					<button type="button" class="btn_type03">인증서 다운로드</button>
				</div>
			</div>
			<div id="certType4" class="mt20 certType hidden">
				<div class="spc_tbl_row st_edit">
					<table>
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tbody>
						<tr>
							<th><h2 class="tx_tit">신청일</h2></th>
							<td>
								2020-05-20
							</td>
							<th><h2 class="tx_tit">기기등록</h2></th>
							<td>
								20건
							</td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">유효기간</h2></th>
							<td>
								5년
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">발급정책</h2></th>
							<td>테스트발급정책</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제조사명</h2></th>
							<td>테스트제조사</td>
							<th><h2 class="tx_tit">폐기</h2></th>
							<td>20건</td>
						</tr>
						<tr>
							<th><h2 class="tx_tit">제품모델명</h2></th>
							<td>테스트모델</td>
							<th></th>
							<td></td>
						</tr>
						</tbody>
					</table>
				</div>

				<div class="flex_wrapper mb-20 mt30">
					<h2 class="ntit">신청 기기정보</h2>
				</div>
				<div class="spc_tbl align_type">
					<table class="chk_type">
						<colgroup>
							<col style="width:15%">
							<col style="width:25%">
							<col style="width:15%">
							<col style="width:25%">
							<col/>
						</colgroup>
						<thead>
						<tr>
							<th>
								<input type="checkbox" id="chk_header" value="순번">
								<label for="chk_header">순번</label>
							</th>
							<th>MAC 주소</th>
							<th>시리얼번호 (SN)</th>
							<th>상태 변경일</th>
							<th>상태</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>
								<input type="checkbox" id="chk_op1" name="rowCheck" value="">
								<label for="chk_op1">1</label>
							</td>
							<td>00-00-00-00-00-01</td>
							<td></td>
							<td>2020-08-11</td>
							<td>폐지가능</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="chk_op2" name="rowCheck" value="">
								<label for="chk_op2">2</label>
							</td>
							<td>00-00-00-00-00-02</td>
							<td></td>
							<td>2020-08-11</td>
							<td>폐지가능</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="chk_op3" name="rowCheck" value="">
								<label for="chk_op3">3</label>
							</td>
							<td>00-00-00-00-00-03</td>
							<td></td>
							<td>2020-08-11</td>
							<td>폐지</td>
						</tr>
						</tbody>
					</table>
				</div>
				<div class="paging_wrap" id="paging"><a href="javascript:void(0);" class="btn_prev first_prev">prev</a><a href="javascript:getDataList(1);"><strong>1</strong></a><a href="javascript:void(0);" class="btn_next larst_next">next</a></div>
				<div class="btn_wrap_type_right">
					<button type="button" class="btn_type big">폐지</button>
				</div>
			</div>
		</div>
		</form>
	</div>
</div>