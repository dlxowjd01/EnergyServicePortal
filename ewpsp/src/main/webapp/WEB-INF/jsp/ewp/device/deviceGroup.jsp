<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script type="text/javascript">
	var deviceGbn = "${deviceGbn }";
// 	$(document).ready(function() {
// 		// js파일에서는 동작을 안함
// 		$(".tab_menu").find("li").removeClass("active");
// 		$(".tab_menu").find("#tab_${deviceGbn }").addClass("active").trigger('click');
// 		getDBData(deviceGbn);
// 	});
</script>
<!-- <script src="../js/device/deviceMonitoring.js" type="text/javascript"></script> -->
</head>
<body>

	<!-- 장치 모니터링 현황용 스크립트 -->
    <script src="../js/jquery.bxslider.js" type="text/javascript"></script>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="device" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
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
								<h2 class="ntit fl">제일 화성</h2>
								<div class="clear fr">
									<ul class="fl">
										<li><a href="javascript:popupOpen('dgdevice');" class="default_btn"><i class="glyphicon glyphicon-th-list"></i> 장치그룹관리</a></li>
									</ul>
								</div>
							</div>
							<div class="dg_wrap">

								<!-- 1 -->
								<h2 class="dtit">별관_1</h2>
								<div class="dsec clear">
									<div class="fl">
										<ul class="device clear">
											<li class="pcs">
												<a href="#;"></a>
												<span class="dname">PCS_1</span>
												<span class="dmemo">텍스트 정보 텍스트 정보 텍스트 정보 텍스트 정보</span>
											</li>
											<li class="pcs alert">
												<a href="#;"></a>
												<span class="dname">PCS_2</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="bms">
												<a href="#;"></a>
												<span class="dname">BMS_1</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="ioe">
												<a href="#;"></a>
												<span class="dname">IOE_1</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="pv">
												<a href="#;"></a>
												<span class="dname">PV_1</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="pcs">
												<a href="#;"></a>
												<span class="dname">PCS_2</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="bms">
												<a href="#;"></a>
												<span class="dname">BMS_1</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="ioe">
												<a href="#;"></a>
												<span class="dname">IOE_1</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="pv">
												<a href="#;"></a>
												<span class="dname">PV_1</span>
												<span class="dmemo">텍스트 정보</span>
											</li>											
										</ul>										
										<!-- 장치 추가 버튼 { -->
										<div class="new_add">
											<a href="javascript:popupOpen('ddevice');"><i class="glyphicon glyphicon-plus"></i></a>
										</div>
										<!-- } 장치 추가 버튼 -->										
									</div>
									<div class="fr clear">
										<dl class="aler fl">
											<dt><span>ALERT</span> <em>1</em></dt>
											<dd>
												<p>PCS_2</p>
											</dd>
										</dl>
										<dl class="warn fr">
											<dt><span>WARNNING</span> <em>2</em></dt>
											<dd>
												<p>PV_1</p>
												<p>IOE_1</p>
											</dd>
										</dl>
									</div>
								</div>
								<!-- 2 -->
								<h2 class="dtit">별관_2</h2>
								<div class="dsec clear">
									<div class="fl">
										<ul class="device clear">
											<li class="pcs">
												<a href="#;"></a>
												<span class="dname">PCS_1</span>
												<span class="dmemo">텍스트 정보 텍스트 정보 텍스트 정보 텍스트 정보</span>
											</li>
											<li class="pcs">
												<a href="#;"></a>
												<span class="dname">PCS_2</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
											<li class="bms">
												<a href="#;"></a>
												<span class="dname">BMS_1</span>
												<span class="dmemo">텍스트 정보</span>
											</li>
										</ul>
										<!-- 장치 추가 버튼 { -->
										<div class="new_add">
											<a href="javascript:popupOpen('ddevice');"><i class="glyphicon glyphicon-plus"></i></a>
										</div>
										<!-- } 장치 추가 버튼 -->	
									</div>
									<div class="fr clear">
										<dl class="aler fl">
											<dt><span>ALERT</span> <em>0</em></dt>
											<dd>
												<p></p>
											</dd>
										</dl>
										<dl class="warn fr">
											<dt><span>WARNNING</span> <em>1</em></dt>
											<dd>
												<p>PCS_1</p>
											</dd>
										</dl>
									</div>
								</div>
								<!-- 3 -->
								<h2 class="dtit">별관_3</h2>
								<div class="dsec clear">
									<div class="fl">
										<ul class="device clear">
											
										</ul>
										<!-- 장치 추가 버튼 { -->
										<div class="new_add">
											<a href="javascript:popupOpen('ddevice');"><i class="glyphicon glyphicon-plus"></i></a>
										</div>
										<!-- } 장치 추가 버튼 -->	
									</div>
									<div class="fr clear">
										<dl class="aler fl">
											<dt><span>ALERT</span> <em>0</em></dt>
											<dd>
												<p></p>
											</dd>
										</dl>
										<dl class="warn fr">
											<dt><span>WARNNING</span> <em>0</em></dt>
											<dd>
												<p></p>
											</dd>
										</dl>
									</div>
								</div>

							</div>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="../include/layout/footer.jsp" />
		</div>
	</div>




    <!-- ###### 신규장치 등록/수정 Popup Start ###### -->
    <div id="layerbox" class="ddevice" style="min-width:600px;">
        <div class="stit">
        	<h2>신규 장치 등록</h2>        	
			<a href="javascript:popupClose('ddevice');">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_tbl">
				<table>
					<colgroup>
						<col width="200">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th><span>배치사이트</span></th>
							<td>
								<select name="" id="" class="sel" style="width:100%">
									
								</select>
							</td>
						</tr>
						<tr>
							<th><span>장치명</span></th>
							<td><input type="text" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>장치ID</span></th>
							<td><input type="text" class="input" style="width:100%"></td>
						</tr>
						<tr>
							<th><span>장치타입</span></th>
							<td>
								<select name="" id="" class="sel" style="width:100%">
									
								</select>
							</td>
						</tr>
					</tbody>			
				</table>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80">확인</a>
			<a href="#;" class="cancel_btn w80">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->  

    <!-- ###### 장치그룹관리 Popup Start ###### -->
    <div id="layerbox" class="dgdevice" style="min-width:800px;">
        <div class="stit">
        	<h2>장치 그룹 추가/제거</h2>        	
			<a href="javascript:popupClose('dgdevice');">닫기</a>
        </div>
		<div class="lbody mt30">

			<div class="set_top clear">
				<h2 class="ntit fl">사이트</h2>
				<div class="dropdown fl">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">롯데_PCS_01
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				        <li class="on"><a href="#">롯데_PCS_01</a></li>
				        <li><a href="#">롯데_PCS_02</a></li>
				        <li><a href="#">롯데_PCS_03</a></li>
				    </ul>
				</div>
				<h2 class="ntit fl">장치 그룹</h2>
				<div class="dropdown fl">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">롯데_장치그룹_01
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				        <li class="on"><a href="#">롯데_장치그룹_01</a></li>
				        <li><a href="#">...</a></li>
				        <li><a href="#">...</a></li>
				    </ul>
				</div>
				<a href="javascript:popupOpen('dgdevice_edit');" class="default_btn fr"><i class="glyphicon glyphicon-edit"></i> 장치그룹편집</a>
			</div>
			<div class="group_wrap clear">
				<div class="inside_site fl">
					<h2 class="ntit">그룹에 포함된 장치</h2>
					<div class="inbox">
						<ul class="multi_select">
							<li><a href="#;">롯데_PCS_01</a></li>
							<li><a href="#;">롯데_PCS_02</a></li>
							<li><a href="#;">롯데_PCS_03</a></li>
						</ul>
					</div>
				</div>
				<div class="cross_btn fl">
					<div><a href="#;"><img src="../img/btn_cross_left.png" alt="<"></a></div>
					<div><a href="#;"><img src="../img/btn_cross_right.png" alt=">"></a></div>
				</div>
				<div class="all_site fl">
					<h2 class="ntit">사이트 내 장치</h2>
					<div class="inbox">
						<ul class="multi_select">
							<li><a href="#;">롯데_PCS_01</a></li>
							<li><a href="#;">롯데_PCS_02</a></li>
							<li><a href="#;">롯데_PCS_03</a></li>
							<li><a href="#;">롯데_PCS_04</a></li>
							<li><a href="#;">롯데_PCS_05</a></li>
							<li><a href="#;">롯데_PCS_06</a></li>
							<li><a href="#;">롯데_PCS_07</a></li>
							<li><a href="#;">롯데_PCS_08</a></li>
							<li><a href="#;">롯데_PCS_09</a></li>
						</ul>
					</div>
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80">적용</a>
			<a href="#;" class="cancel_btn w80">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### -->  

    <!-- ###### 장치그룹편집 Popup Start ###### -->
    <div id="layerbox" class="dgdevice_edit" style="min-width:600px;">
        <div class="stit">
        	<h2>장치 그룹 편집</h2>        	
			<a href="javascript:popupClose('dgdevice_edit');">닫기</a>
        </div>
		<div class="lbody mt30">
			<div class="clear">
				<h2 class="ntit fl">사이트</h2>
				<div class="dropdown fl ml20">
				    <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">롯데 정밀 화학
				    <span class="caret"></span></button>
				    <ul class="dropdown-menu">
				        <li class="on"><a href="#">롯데 정밀 화학</a></li>
				        <li><a href="#">...</a></li>
				        <li><a href="#">...</a></li>
				    </ul>
				</div>
			</div>
			<h2 class="ctit mt20">전체 장치그룹</h2>
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
					<tbody>
						<tr>
							<td>1</td>
							<td>롯데_장치그룹_01</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>2</td>
							<td>롯데_장치그룹_02</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>3</td>
							<td>롯데_장치그룹_03</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
						</tr>
						<tr>
							<td>4</td>
							<td>롯데_장치그룹_04</td>
							<td><a href="#;"><i class="glyphicon glyphicon-remove"></i></a></td>
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
								<td><input type="text" class="input" style="width:100%"></td>
							</tr>
						</tbody>			
					</table>
				</div>
				<div class="fr">
					<input type="submit" value="추가하기" class="submit">
				</div>
			</div>

		</div>
		<div class="btn_center">
			<a href="#;" class="default_btn w80">확인</a>
			<a href="#;" class="cancel_btn w80">취소</a>
		</div>
    </div>
    <!-- ###### Popup End ###### --> 


    <!-- 레이어 팝업 배경 -->
    <div id="mask"></div>





</body>
</html>