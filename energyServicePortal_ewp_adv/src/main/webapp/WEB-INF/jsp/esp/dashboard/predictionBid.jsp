<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>

<link type="text/css" rel="stylesheet" href="/css/predictionBid.css" />

<!-- <div id="loadingCircle" class="loading"><img class="loading-image" src="/img/loading_icon.gif" alt="Loading..."/></div> -->

<div class="modal fade" id="bidResult" tabindex="-1" role="dialog" aria-labelledby="bidResult" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content">
			<h2>입찰 결과</h2>
			<div>
				<div id="">
					<!-- DataTables -->
				</div>
			</div>
			<div class="modal-footer">
				<div>
					<button class="btn-type03">엑셀 다운로드</button>
				</div>
				<div>
					<button class="btn-type03">취소</button>
					<button class="btn-type">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="bidSettingModal" tabindex="-1" role="dialog" aria-labelledby="bidSettingModal" aria-hidden="true" data-keyboard="false" data-backdrop="static">
	<div class="modal-dialog modal-md-lg">
		<div class="modal-content">
			<h2>입찰 설정</h2>
			<!-- !!! Modal Form !!! -->
			<form> 
				<div class="modal-items">
					<div class="row">
						<div><span class="input-label"><span>입찰 모드</span></span></div>
						<div class="input-list">
							<div class="radio-type">
								<input type="radio" id="grade1" name="gradeType" value="1" checked="">
								<label for="grade1">수동입찰 모드</label>
							</div>
							<div class="radio-type">
								<input type="radio" id="grade1" name="gradeType" value="1" checked="">
								<label for="grade1">혼합입찰 모드(자동+수동)</label>
							</div>
						</div>
					</div>
					<div class="row">
						<div><span class="input-label"><span>입찰 양식 업로드</span></span></div>
						<div>
							<input type="file" id="bidExcel" class="hidden" name="bidExcel" accept=".xlsx, .xlsm, .xls" multiple="">
							<label for="bidExcel" class="btn file-upload">파일 선택</label>
							<p>엑셀파일만 가능합니다.</p>
						</div>	
					</div>
					<div class="row">
						<div>
							<span class="input-label"><span>입찰 전송 주소</span></span>
							<a href="#" class="btn-add fr">추가</a>
						</div>
						<div class="input-list">
							<div>
								<input type="email" placeholder="이메일 입력">
								<button class="btn-type03">저장</button>
							</div>
							<div>
								<input type="email" placeholder="이메일 입력">
								<button class="btn-type03">저장</button>
								<img src="/img/predictionBid/delete.svg" alt="delete">
							</div>
						</div>	
					</div>
					<div class="row">
						<div>
							<span class="input-label"><span>입찰 시간</span></span>
							<a href="#" class="btn-add fr">추가</a>
						</div>
						<div class="input-list">
							<div>
								<div class="dropdown-wrapper">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="시간 선택" aria-expanded="false">
											시간 선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu"></ul>
									</div>
								</div>
								<button class="btn-type03">저장</button>
							</div>
							<div>
								<div class="dropdown-wrapper">
									<div class="dropdown">
										<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="시간 선택" aria-expanded="false">
											시간 선택<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu"></ul>
									</div>
								</div>
								<button class="btn-type03">저장</button>
								<img src="/img/predictionBid/delete.svg" alt="delete">
							</div>
						</div>	
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn-type03" onclick="$('#bidSettingModal').modal('hide')">취소</button>
					<button class="btn-type">저장</button>
				</div>
			</form>
		</div>
	</div>
</div>

<form id="linkSiteForm" name="linkSiteForm" method="post"></form>
<div class="row header-wrapper">
	<div class="col-lg-5 col-md-6 col-sm-12 dashboard-header">
		<h1 class="page-header">예측입찰</h1>
	</div>
	<!-- <div class="col-lg-7 col-md-6 col-sm-12">
		<div class="time fr">
			<span>CURRENT TIME</span>
			<em class="currTime">${nowTime}</em>
			<span>DATABASE TIME</span>
			<em class="dbTime"></em>
		</div>
	</div> -->
</div>


<div class="row content-wrapper">
	<div class="col-xl-12 col-md-12 col-sm-12">
		<div class="indiv" id="predictionBid">
			<div class="predictionBid-header">
				<div class="title-area" id="switchView">
					<h2 class="title" data-view="todayList">금일입찰</h2>
					<h2 class="title newBadge" data-view="historyList">입찰내역</h2>
				</div>
				<div>
					<button class="btn-type04" id="bidSetting" onclick="$('#bidSettingModal').modal('show')">입찰 설정</button>
					<button class="btn-type" id="bidNow">즉시입찰</button>
				</div>
			</div>
			<div class="predictionBid-items">
				<ul class="actived">
					<li>1회 입찰</li>
					<li>2021-01-01 11:11:11</li>
				</ul>
				<ul>
					<li>2회 입찰</li>
					<li>2021-01-01 11:11:11</li>
				</ul>
				<ul>
					<li>3회 입찰</li>
					<li>2021-01-01 11:11:11</li>
				</ul>
			</div>
			<div class="predictionBid-content">
				<div class="predictionBid-toolbar">
					<img src="/img/predictionBid/refresh.svg" alt="refresh">
				</div>
				<div class="content" id="todayList">
					<div id="">
						<!-- DataTables -->
					</div>
				</div>
				<div class="content" id="historyList">
					<div class="extracter">
						<div>
							<p>기간</p>
							<div class="dropdown-wrapper">
								<div class="dropdown">
									<button type="button" class="dropdown-toggle" data-toggle="dropdown" data-name="기간" aria-expanded="false">
										기간<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu"></ul>
								</div>
							</div>
						</div>
						<div>
							<p>날짜 입력</p>
							<div class="sel-calendar fl">
								<input type="text" id="datepicker1" name="datepicker1" class="sel" value="">
								<input type="text" id="datepicker2" name="datepicker2" class="sel" value="">
							</div>
						</div>
						<button class="btn-type">추출</button>
					</div>
					<div id="">
						<!-- DataTables -->
					</div>
				</div>
			</div>
			<div class="predictionBid-footer">
				<div>
					<button class="btn-type03">엑셀 다운로드</button>
				</div>
				<div>
					<button class="btn-type03">수정</button>
					<button class="btn-type">저장</button>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	// Document.ready
	$(_ => {
		App.init();
	});

	const App = {
		view: "#todayList",

		init() {
			App.event();

			$("#switchView > h2:first-child").click();
		},

		event() {
			$(document)	
				.on("click", "#switchView > h2", switchView)
		}
	}

	function switchView() {
		$("#switchView > h2").removeClass("actived");
		$(this).addClass("actived");

		App.view = "#" + $(this).data("view");

		$(".predictionBid-content > .content").fadeOut(500);
		$(App.view).fadeIn(500);
	}
</script>