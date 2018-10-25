<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../include/common_static.jsp" />
<jsp:include page="../include/sub_static.jsp" />
<script src="../js/main/main.js" type="text/javascript"></script>
</head>
<body>

	<!-- 메인페이지용 스타일/스크립트 파일 -->
	<link type="text/css" href="../css/main.css" rel="stylesheet">
	<script type="text/javascript" src="../js/modules/rounded-corners.js"></script>
	<script type="text/javascript" src="../js/jquery.rwdImageMaps.min.js"></script>

	<div id="wrapper">
		<jsp:include page="../include/layout/sidebar.jsp">
			<jsp:param value="main" name="linkGbn"/>
		</jsp:include>
		<div id="page-wrapper">
			<jsp:include page="../include/layout/header.jsp" />
			<div id="container">
				<form id="schForm" name="schForm">
					<input type="hidden" id="areaType" name="areaType" value="" />
					<input type="hidden" id="rankType" name="rankType" value="4" />
					<input type="hidden" id="selTermFrom" name="selTermFrom" />
					<input type="hidden" id="selTermTo" name="selTermTo" />
					<input type="hidden" id="selTerm" name="selTerm" value="day" />
					<input type="hidden" id="mapGroup" name="mapGroup" value="map" />
					<input type="hidden" id="grpIdx" name="grpIdx" value="" />
				</form>
				<div class="row">
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_alarm">
									<div class="chart_top clear">
										<h2 class="ntit">알람</h2>
										<div class="fr today_alarm">
											<div class="total">금일발생 <span id="todayTotalAlarmCnt">0</span></div>
											<div class="no"><span style="display:none">0</span></div>
										</div>
									</div>
									<div class="alarm_stat mt20 clear">
										<div class="a_alert clear">
											<span>ALERT</span><br/>
											<em id="todayAlarmCnt">0</em>
										</div>
										<div class="a_warning clear">
											<span>WARNING</span><br/>
											<em id="todayWarningCnt">0</em>
										</div>
									</div>
									<div class="alarm_notice">
										<h2>최근 알람</h2>
										<ul>
											<li><a href="#;">조회중입니다.</a></li>
<!-- 
											<li>
												<a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망. 메시지가 길면 절삭처리 됩니다. 메시지가 길면 절삭처리 됩니다.</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망.</a>
												<span>2018-08-12 11:41:26</span>
											</li>
											<li>
												<a href="#;">랙 전압 불균형이 감지되었습니다. 신속한 처리요망.</a>
												<span>2018-08-12 11:41:26</span>
											</li>
 -->
										</ul>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_chart">
									<ul class="gtab_menu">
										<li class="active"><a href="javascript:changeRanking(0)">사용</a></li>
										<li><a href="javascript:changeRanking(1)">충•방전</a></li>
										<li><a href="javascript:changeRanking(2)">발전</a></li>
										<li><a href="javascript:changeRanking(3)">수익</a></li>									
									</ul>
									<div class="tblDisplay">
										<!-- 사용 -->
										<div>
											<div class="gchart_top clear">
												<h2>사용량 순위</h2>
												<ul>
													<li id="rankTime"><!-- AM 10:00 기준 --></li>
													<li id="rankTotal"><!-- <span class="bul1">누적 - 0.00 kWh</span> --></li>
													<li id="rankPlan"><!-- <span class="bul2">예상 - 0.00 kWh</span> --></li>
												</ul>
											</div>
											<div class="inchart">
												<div id="gchart1" style="height:333px;"></div>
											</div>
											<!-- 데이터 추출용 테이블 -->
											<div class="hidden_table" style="display:none">
												<table id="gdatatable1">
												    <thead>
												        <tr>
												            <th></th>
												            <th>누적</th>
												            <th>예상</th>
												        </tr>
												    </thead>
												    <tbody id="siteRankingTbody">
<!-- 
												        <tr>
												            <th>한국제지</th>
												            <td>50</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>문수경기장</th>
												            <td>90</td>
												            <td>100</td>
												        </tr>
												        <tr>
												            <th>태광석유화학</th>
												            <td>70</td>
												            <td>90</td>
												        </tr>
												        <tr>
												            <th>한국제지</th>
												            <td>30</td>
												            <td>40</td>
												        </tr>
												        <tr>
												            <th>문수경기장</th>
												            <td>100</td>
												            <td>92</td>
												        </tr>
 -->
												    </tbody>
												</table>
											</div>											
											<div class="paging clear" id="GMainSiteRankingPaging">
												<a href="#;" class="prev">PREV</a>
												<span><strong>1</strong> / 1</span>
												<a href="#;" class="next">NEXT</a>
											</div>
										</div>
										<!-- 충•방전 -->
										<div>
											충•방전
										</div>
										<!-- 발전 -->
										<div>
											발전
										</div>
										<!-- 수익 -->
										<div>
											수익
										</div>
									</div>
								</div>
							</div>
						</div>				
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">

								<!-- 지역별 사용량 //-->
								<div id="mapUsage" class="indiv gmain_map">
									<div class="chart_top clear">
										<h2 class="ntit">군별사용량</h2>
										<a href="#;" class="default_btn fr all_map_view"><span>전체지도보기</span></a>
									</div>
									<div class="map_wrap">
										<img src="../img/local_map_all.png" alt="전체지도" name="local" usemap="#local_map_all" id="local" border="0" />
										<map name="local_map_all" id="local_map_all">
										  <area href="javascript:local_detail('Busan', 2)" alt="Busan" shape="poly" coords="359,486,353,488,351,493,350,498,348,503,345,509,345,516,350,518,359,515,365,509,366,504,370,503,370,499,363,491,361,487" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Jeonbuk', 13)" alt="Jeonbuk" shape="poly" coords="60,388,83,384,95,381,99,374,103,371,111,370,122,366,127,367,126,373,131,375,142,374,150,372,153,368,160,377,165,381,167,386,177,386,185,385,189,381,193,382,202,386,212,384,216,386,219,385,221,390,221,398,217,403,212,407,206,408,202,414,199,417,196,426,192,437,189,446,190,452,193,459,196,466,194,471,191,476,189,484,180,479,172,477,169,480,160,483,150,484,148,480,139,481,132,483,131,476,127,471,129,466,124,462,120,463,117,468,110,462,103,458,98,459,93,460,90,465,88,471,86,475,70,481,69,476,70,469,66,467,56,469,50,469,55,424,59,395" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Jeonnam', 14)" alt="Jeonnam" shape="poly" coords="96,489,88,478,95,466,102,462,110,469,116,471,123,467,125,473,127,482,134,485,142,485,149,486,163,487,174,480,183,483,188,493,191,503,199,512,206,523,209,530,210,563,214,588,204,601,152,634,99,646,64,648,28,626,0,595,2,506,46,477,52,473,65,470,65,482,76,483,87,479,95,490,99,499,105,504,114,504,120,498,118,491,111,487,103,487" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Daegu', 3)" alt="Daegu" shape="poly" coords="297,386,302,383,308,382,314,383,319,387,319,392,320,397,320,402,316,402,316,408,314,410,308,410,305,410,303,416,301,423,298,428,294,424,292,421,292,416,289,412,290,404,295,403,296,399,295,396,297,392" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Daejeon', 6)" alt="Daejeon" shape="poly" coords="145,317,150,315,155,314,159,318,160,322,164,323,168,322,171,326,171,330,170,333,169,339,164,341,158,346,154,345,152,340,152,334,152,329,149,324,146,320" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Gangwon', 10)" alt="Gangwon" shape="poly" coords="116,58,139,48,158,46,176,48,200,45,219,47,251,42,264,25,266,7,276,2,284,18,301,58,332,109,356,141,379,178,395,218,403,250,405,283,399,292,392,292,385,286,386,272,384,264,378,262,369,256,364,246,365,243,373,241,376,237,372,232,364,230,357,231,350,231,343,229,339,231,333,225,325,221,321,225,319,228,320,235,310,233,301,230,294,224,288,227,283,222,278,219,269,222,270,217,272,211,263,208,255,208,247,208,240,214,237,205,231,204,223,209,223,214,219,219,216,217,213,211,207,213,197,216,193,216,205,184,208,178,210,172,216,165,211,159,199,155,184,149,184,142,181,134,183,123,189,119,192,111,192,104,187,102,182,97,175,95,172,86,170,79,162,81,156,79,155,73,155,69,148,70,145,73,142,68,138,70,138,77,131,75,123,65" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Gwangju', 5)" alt="Gwangju" shape="poly" coords="99,490,103,491,106,489,110,490,114,491,116,495,116,498,113,501,109,502,105,501,101,498,98,494,98,492" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Gyeongnam', 16)" alt="Gyeongnam" shape="poly" coords="374,498,380,482,375,478,372,473,364,468,357,461,350,460,346,455,349,449,349,446,341,443,331,447,326,451,313,449,303,450,297,443,297,438,292,442,285,442,280,444,271,440,259,439,255,434,256,426,249,417,245,415,239,413,234,410,227,407,222,403,216,410,208,412,201,421,199,429,192,448,195,453,199,464,197,471,193,480,189,487,192,496,196,505,201,511,210,523,212,530,214,555,220,574,260,583,313,569,346,522,343,517,341,509,342,504,346,500,349,492,351,487,356,484,363,484,366,492,370,497" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Jeju', 17)" alt="Jeju" shape="poly" coords="38,709,91,695,109,705,112,719,89,738,67,744,24,744,17,730" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Chungnam', 12)" alt="Chungnam" shape="poly" coords="16,269,33,242,50,228,71,233,85,239,102,254,111,253,118,255,132,252,140,255,149,262,154,270,153,277,145,288,141,302,140,311,145,324,149,332,151,342,153,349,161,347,168,342,175,326,179,328,170,344,170,355,176,355,181,360,183,370,186,379,180,382,168,380,161,374,158,367,152,364,145,369,136,372,130,371,128,362,121,362,108,366,100,368,92,375,82,381,62,365,31,307,16,278" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Chungbuk', 11)" alt="Chungbuk" shape="poly" coords="150,254,160,252,163,250,165,245,171,239,177,237,188,220,209,216,209,222,219,222,225,218,226,211,231,208,235,213,237,217,250,213,257,211,268,212,264,218,266,225,276,223,282,228,292,229,306,235,292,244,285,251,282,258,282,266,272,271,269,267,262,261,257,264,255,269,248,265,243,270,238,268,235,278,238,283,227,281,223,285,216,288,213,298,208,300,211,306,218,314,214,331,216,336,213,339,214,348,220,348,225,352,233,352,235,357,230,358,228,365,225,373,220,380,216,382,212,381,206,384,195,379,189,375,184,365,184,356,179,352,172,352,174,344,176,336,180,331,184,326,178,324,173,325,172,318,168,318,163,321,158,311,150,313,144,315,142,308,145,292,150,285,155,279,158,271,153,260" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Kyungbuk', 15)" alt="Kyungbuk" shape="poly" coords="296,434,290,439,280,441,273,437,262,437,260,427,255,418,248,409,236,407,226,399,225,389,222,381,233,360,240,359,234,348,227,348,217,344,217,338,220,333,220,315,218,307,212,301,221,291,230,285,241,288,237,277,244,272,255,272,260,265,270,272,282,271,287,262,290,251,310,236,322,239,325,227,335,232,341,234,354,235,365,234,370,238,362,238,359,245,363,254,370,263,380,265,381,277,382,290,387,296,396,295,399,300,402,323,394,337,396,359,399,368,397,378,404,381,415,371,417,384,411,405,404,429,401,435,391,433,384,435,379,429,375,426,368,426,359,431,355,434,358,438,348,441,340,441,334,442,326,447,317,446,308,446,299,439,301,429,305,421,310,414,318,412,322,400,324,393,320,385,314,379,305,378,296,382,293,389,290,397,287,404,290,420,294,429" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Ulsan', 7)" alt="Ulsan" shape="poly" coords="403,439,396,438,390,437,384,438,379,437,378,431,373,430,368,430,363,431,360,433,359,438,355,441,352,445,351,450,350,455,355,458,361,460,368,466,373,470,377,475,382,479,392,473,400,456,404,443" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Ulleungdo', 18)" alt="Ulleungdo" shape="poly" coords="434,156,433,167,449,173,449,152" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Seoul', 1)" alt="Seoul" shape="poly" coords="121,139,127,140,129,144,130,148,130,153,130,158,134,158,137,157,138,160,135,162,135,167,133,170,128,172,124,173,121,171,116,173,112,174,108,174,105,170,103,169,100,167,98,163,95,159,94,156,95,154,99,155,102,156,106,155,107,152,108,149,111,149,115,147,118,141" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Incheon', 4)" alt="Incheon" shape="poly" coords="27,119,40,119,51,117,61,126,61,138,61,147,69,158,77,158,81,159,86,163,88,168,91,173,89,178,84,181,78,185,72,202,67,208,45,209,16,213,8,200,16,151,23,126" onfocus='this.blur()' />
										  <area href="javascript:local_detail('Gyeonggi', 9)" alt="Gyeonggi" shape="poly" coords="95,149,89,144,81,136,81,122,79,113,78,99,92,90,99,80,105,73,112,62,121,68,125,73,132,79,138,81,141,73,146,76,151,72,151,80,155,84,161,84,168,84,170,92,174,100,180,100,183,105,189,111,187,116,180,120,178,129,179,134,176,138,181,141,178,148,182,152,189,155,206,160,211,165,205,177,200,190,193,203,187,216,179,228,173,236,167,239,161,245,159,249,150,252,142,253,135,247,128,248,116,251,104,247,93,233,78,215,76,201,80,187,89,183,92,178,94,173,91,169,89,164,86,158,81,156,71,156,66,146,63,126,69,126,77,127,77,133,79,141,82,144,90,147,92,152,94,161,98,168,102,172,108,176,114,176,121,174,124,176,132,173,136,170,139,167,138,163,141,159,140,155,133,155,133,148,131,140,128,136,123,135,118,137,115,142,111,146,107,147,106,151,102,154,98,153" onfocus='this.blur()' />
										</map>
									</div>
									<div class="map_wrap_detail">
										<img src="../img/local_map_Seoul_detail.png" alt="상세지도" id="local_detail">
									</div>
									<!-- 전체지도용 지역정보 -->
									<div class="local_info allmap">
										<h2 class="local_name">서울</h2>
										<div class="clear">
											<ul>
												<li><strong>사용량</strong> <span class="detailUsage">0</span> <em class="detailUsageUnit">MWh</em></li>
												<li><strong>발전량</strong> <span class="detailGen">0</span> <em class="detailGenUnit">MWh</em></li>
											</ul>
											<ul>
												<li><strong>충•방전량</strong> <span class="detailCharge">0</span> <em class="detailChargeUnit">MWh</em></li>
												<li><strong>수익</strong> <span class="detailReward">0</span> <em class="detailRewardUnit">won</em></li>
											</ul>
										</div>
									</div>
									<!-- 상세지도용 지역정보 -->
									<div class="local_info detailmap">
										<h2 class="local_name">서울</h2>
										<div class="clear">
											<ul>
												<li><strong>사용량</strong> <span class="detailUsage">0</span> <em class="detailUsageUnit">MWh</em></li>
												<li><strong>발전량</strong> <span class="detailGen">0</span> <em class="detailGenUnit">MWh</em></li>
											</ul>
											<ul>
												<li><strong>충•방전량</strong> <span class="detailCharge">0</span> <em class="detailChargeUnit">MWh</em></li>
												<li><strong>수익</strong> <span class="detailReward">0</span> <em class="detailRewardUnit">won</em></li>
											</ul>
										</div>
									</div>
								</div>
								<!-- // 지역별 사용량 -->

								<!-- 그룹별 사용량 //-->
								<div id="groupUsage" class="indiv gmain_group" style="display:none">
									<div class="chart_top clear">
										<h2 class="ntit">그룹별사용량</h2>
									</div>
									<div class="group_wrap">
										<img id="grpImg" src="" onError="this.src='../img/group_dimg.png';" alt="그룹이미지" />
									</div>
									<!-- 그룹별 정보 -->
									<div class="group_info">
										<h2 class="group_name">그룹명</h2>
										<div class="clear">
											<ul>
												<li><strong>사용량</strong> <span class="detailUsage">564</span> <em class="detailUsageUnit">MWh</em></li>
												<li><strong>발전량</strong> <span class="detailGen">328</span> <em class="detailGenUnit">MWh</em></li>
											</ul>
											<ul>
												<li><strong>충•방전량</strong> <span class="detailCharge">183</span> <em class="detailChargeUnit">MWh</em></li>
												<li><strong>수익</strong> <span class="detailReward">99,000</span> <em class="detailRewardUnit">won</em></li>
											</ul>
										</div>
									</div>
								</div>
								<!-- //그룹별 사용량 -->

							</div>
						</div>
					</div>
					<div class="col-lg-4">
						<div class="row">
							<div class="col-sm-12">
								<div class="indiv gmain_table">
									<div class="term_menu clear">
										<ul>
											<li class="on"><a href="javascript:changeTerm('day')">오늘</a></li>
											<li><a href="javascript:changeTerm('week')">이번주</a></li>
											<li><a href="javascript:changeTerm('month')">이번달</a></li>
										</ul>
										<ol>
											<li>
												<div class="dropdown">
												  <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown"><em id="selMapGroup">지역별</em>
												  <span class="caret"></span></button>
												  <ul class="dropdown-menu">
												    <li class="on"><a href="#;" onclick="changeMapGroup(this)">지역별</a></li>
												    <li><a href="#;" onclick="changeMapGroup(this)">그룹별</a></li>
												  </ul>
												</div>
											</li>
											<li>
												<div class="dropdown">
												  <button id="allAreaDiv" class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown"><em id="selAllArea">전체지역</em>
												  <span class="caret"></span></button>
												  <ul id="selAreaList" class="dropdown-menu">
												    <li class="on"><a href="#;" onclick="changeAllArea(this, 'All', 0)">전체지역</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Seoul', 1)">서울</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Busan', 2)">부산</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Daegu', 3)">대구</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Incheon', 4)">인천</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Gwangju', 5)">광주</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Daejeon', 6)">대전</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Ulsan', 7)">울산</a></li>
												    <li style="display:none"><a href="#;" onclick="changeAllArea(this, 'Sejong', 8)">세종</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Gyeonggi', 9)">경기</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Gangwon', 10)">강원</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Chungbuk', 11)">충북</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Chungnam', 12)">충남</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Jeonbuk', 13)">전북</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Jeonnam', 14)">전남</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Kyungbuk', 15)">경북</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Gyeongnam', 16)">경남</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Jeju', 17)">제주</a></li>
												    <li><a href="#;" onclick="changeAllArea(this, 'Ulleungdo', 18)">울릉도</a></li>
												  </ul>
												</div>
											</li>
										</ol>
									</div>
									<div class="gtbl_wrap">
										<table>
											<colgroup>
												<col width="50">
												<col>
												<col>
												<col>
												<col>
												<col>
												<col width="70">
											</colgroup>
										    <thead>
										      <tr>
										      	<th>번호</th>
										        <th>사이트</th>
										        <th>장치현황</th>
										        <th>사용</th>
										        <th>충•방전</th>
										        <th>발전</th>
										        <th>수익</th>
										      </tr>
										    </thead>
										    <tbody id="siteTbody">
										      <tr class="dbclickopen">
										        <td colspan="7">데이터 조회중입니다.</td>
										      </tr>
<!-- 
										      <tr class="dbclickopen">
										        <td>1</td>
										        <td>
										        	<div class="cname"><a href="../main/smain.html">롯데정밀화학Z</a></div>
										        </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>2</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">한국프랜지</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>3</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">제일화성</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>4</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">한국제지</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>5</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">문수경기장</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3 on">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>6</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">태광석유화학</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3 on">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td align="left">7</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">SNF KOREA</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										        <td>8</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">롯데정밀화학</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2 on">장치2</span>
											        	<span class="eq3 on">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>9</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">한국프랜지</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
										      <tr class="dbclickopen">
										      	<td>10</td>
										        <td>
											        <div class="cname"><a href="../main/smain.html">제일화성</a></div>
											    </td>
											    <td>
											    	<div class="eq_icon">
											        	<span class="eq1 on">장치1</span>
											        	<span class="eq2">장치2</span>
											        	<span class="eq3">장치3</span>
											        	<span class="eq4 on">장치4</span>
											        </div>
											    </td>
										        <td>1,100</td>
										        <td>500</td>
										        <td>700</td>
										        <td>200</td>
										      </tr>
 -->
										    </tbody>
										</table>
									</div>
									<div class="paging clear" id="GMainSitePaging">
										<a href="#;" class="prev">PREV</a>
										<span><strong>1</strong> / 1</span>
										<a href="#;" class="next">NEXT</a>
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

<script type="text/javascript">
var chartDiv = '';
var myChart = null;

$(function () {
	// 탭내용의 div를 복사해 둠. 탭 클릭 후 html 이동함.
	chartDiv = $('.tblDisplay > div:eq(0)').html();
	initChart();
});

function initChart() {
	myChart = Highcharts.chart('gchart1', {
		data: {
	        table: 'gdatatable1' /* 테이블에서 데이터 불러오기 */
	    },

		chart: {
			marginTop:30,
			marginRight:0,
			backgroundColor: 'transparent',
			type: 'bar'
		},

		navigation: {
			buttonOptions: {
			  enabled: false /* 메뉴 안보이기 */
			  }
		},

	    title: {
	        text: ''
	    },

	    subtitle: {
	        text: ''
	    },

		xAxis: {
			labels: {
				align: 'left',
				reserveSpace: true,
				style: {
					color: '#8e95a1',
					fontSize: '14px'
				}
			},
			title: {
				text: null
			}
		},

		yAxis: {
			gridLineWidth: 0, /* 기준선 grid 안보이기/보이기 */
		    min: 0, /* 최소값 지정 */
		    title: {
		    	text: '',
		        style: {
		            color: '#fff',
		            fontSize: '12px'
		        }
		    },
		    labels: {
		        overflow: 'justify',
		        x:-10, /* 그래프와의 거리 조정 */
		        style: {
		            color: '#fff',
		            fontSize: '12px'
		        }
		    }
		},									    

		/* 범례 */
		legend: {
			enabled: false,
			align:'right',
			verticalAlign:'top',
			x:18,
			y:-20,										
			itemStyle: {
		        color: '#fff',
		        fontSize: '12px',
		        fontWeight: 400
		    },
		    itemHoverStyle: {
		        color: '' /* 마우스 오버시 색 */
		    },
		    symbolPadding:3, /* 심볼 - 텍스트간 거리 */
		    symbolHeight:7 /* 심볼 크기 */
		},

		/* 툴팁 */
		tooltip: {
			    valueSuffix: ' kwh'
		},

		/* 옵션 */
		plotOptions: {
	        series: {
	            label: {
	                connectorAllowed: true
	            },
	            borderWidth: 0, /* 보더 0 */
	            borderRadiusTopLeft: '50%', /* 막대 모서리 둥글게 효과 */
	            borderRadiusTopRight: '50%', /* 막대 모서리 둥글게 효과 */
	            pointWidth: 5, /* 막대 두께 */
	            pointPadding: 0.3 /* 막대 사이 간격 */
	        },
	        bar: {
	            dataLabels: {
	                enabled: true,
	                inside: true, /* 막대 안으로 라벨 수치 넣기 */
	                format: '{y} kWh', /* 단위 넣기 */
	                style: {
	                    color: '#ffffff',
		                fontSize: '11px',
		                fontWeight: 400
	                }
	            }
	        }
	    },

		/* 출처 */
		credits: {
			enabled: false
		},

		/* 그래프 스타일 */
	    series: [{
	        color: '#74b9fa' /* 누적 */
	    },{
	        color: '#6d7f9b' /* 예상 */
	    }],

	    /* 반응형 */
	    responsive: {
	        rules: [{
	            condition: {
	                maxWidth: 414 /* 차트 사이즈 */									                
	            },
	            chartOptions: {
					xAxis: {
						labels: {
					        style: {
					            fontSize: '12px'
					        }
						}
					}
	            }
	        }],
	        rules: [{
	            condition: {
	                minWidth: 842 /* 차트 사이즈 */									                
	            },
	            chartOptions: {
					xAxis: {
						labels: {
					        style: {
					            fontSize: '18px'
					        }
						}
					},
					yAxis: {
						labels: {
					        style: {
					            fontSize: '18px'
					        }
						}
					},
					plotOptions: {
				        series: {
				            pointWidth: 8
				        },
				        bar: {
				            dataLabels: {
				                style: {
					                fontSize: '15px'
				                }
				            }
				        }
				    }
	            }
	        }]
	    }

	});
}
</script>
<script type="text/javascript">
/* 5초마다 지도/정보 변경 */
var monitoring_cycle_5sec = null; // 지도 변경 스레드ID
var allMapFlag = true; // 전체지도 여부
var done = false; // 스레드 작동 여부
// area_type = area_idx + 1
var area_idx = 0; // 지도 array 인덱스
// site의 area_type 구분정의표 참조 (01:서울, 02:부산... 17:제주)
var area_array = [
	"Seoul",		// 01
	"Busan",		// 02
	"Daegu",		// 03
	"Incheon",		// 04
	"Gwangju",		// 05
	"Daejeon",		// 06
	"Ulsan",		// 07
	"Sejong",		// 08 (이미지 없음)
	"Gyeonggi",		// 09
	"Gangwon",		// 10
	"Chungbuk",		// 11
	"Chungnam",		// 12
	"Jeonbuk",		// 13
	"Jeonnam",		// 14
	"Kyungbuk",		// 15
	"Gyeongnam",	// 16
	"Jeju",			// 17
	"Ulleungdo"		// 18 (코드값 없음)
];
// 지역필터 html을 저장
var areaListHtml = '';

$(function() {
	/* 이미지맵 처리 */
	$('img[usemap]').rwdImageMaps();

	/* 상세지도/정보 보기 */
	$("#local_map_all").click(changeLocalMap);

	/* 전체지도/정보 보기 */
	$(".all_map_view").click(function() {
		changeAllMap();
		$('#selAllArea').text('전체지역');
	});

	areaListHtml = $('#selAreaList').html();

	readArea();
});

function changeLocalMap() {
	$(".map_wrap").hide();
	$(".allmap").hide();
	$(".map_wrap_detail").show();
	$(".detailmap").show();
	$(".all_map_view").show();

	allMapFlag = false;
	done = true;
	clearTimeout(monitoring_cycle_5sec);
	monitoring_cycle_5sec = null;
}

function changeAllMap() {
	$(".all_map_view").hide();
	$(".map_wrap").show();
	$(".allmap").show();
	$(".map_wrap_detail").hide();
	$(".detailmap").hide();

	allMapFlag = true;
	done = false;
	readArea(); // 다시 시작
}

/* 지역별 상세지도/정보 표시 */
function local_detail(lname, area_type) {
	$("#local_detail").attr("src", "../img/local_map_" + lname + "_detail.png");
	if (area_type != null) {
		area_idx = area_type - 1;
	}

	if (lname == "Seoul") {$(".detailmap .local_name").text("서울");}
	if (lname == "Gyeonggi") {$(".detailmap .local_name").text("경기");}
	if (lname == "Incheon") {$(".detailmap .local_name").text("인천");}
	if (lname == "Gangwon") {$(".detailmap .local_name").text("강원");}
	if (lname == "Chungbuk") {$(".detailmap .local_name").text("충북");}
	if (lname == "Daejeon") {$(".detailmap .local_name").text("대전");}
	if (lname == "Chungnam") {$(".detailmap .local_name").text("충남");}
	if (lname == "Kyungbuk") {$(".detailmap .local_name").text("경북");}
	if (lname == "Daegu") {$(".detailmap .local_name").text("대구");}
	if (lname == "Ulsan") {$(".detailmap .local_name").text("울산");}
	if (lname == "Sejong") {$(".detailmap .local_name").text("세종");}
	if (lname == "Gyeongnam") {$(".detailmap .local_name").text("경남");}
	if (lname == "Busan") {$(".detailmap .local_name").text("부산");}
	if (lname == "Jeonbuk") {$(".detailmap .local_name").text("전북");}
	if (lname == "Gwangju") {$(".detailmap .local_name").text("광주");}
	if (lname == "Jeonnam") {$(".detailmap .local_name").text("전남");}	
	if (lname == "Jeju") {$(".detailmap .local_name").text("제주");}
	if (lname == "Ulleungdo") {$(".detailmap .local_name").text("울릉도");}

	/* 데이터 조회 */
	fn_cycle();
}

function readArea() {
	if (done) return;
	if (area_idx == area_array.length) {area_idx = 0;}
//	console.log(area_array[area_idx]);

	/* 전체지도/정보 변경 */
	$("#local").attr("src", "../img/local_map_" + area_array[area_idx] + ".png");
	$('img[usemap]').rwdImageMaps();

	if (area_array[area_idx] == "Seoul") {$(".allmap .local_name").text("서울");}
	if (area_array[area_idx] == "Busan") {$(".allmap .local_name").text("부산");}
	if (area_array[area_idx] == "Daegu") {$(".allmap .local_name").text("대구");}
	if (area_array[area_idx] == "Incheon") {$(".allmap .local_name").text("인천");}
	if (area_array[area_idx] == "Gwangju") {$(".allmap .local_name").text("광주");}
	if (area_array[area_idx] == "Daejeon") {$(".allmap .local_name").text("대전");}
	if (area_array[area_idx] == "Ulsan") {$(".allmap .local_name").text("울산");}
	if (area_array[area_idx] == "Sejong") {$(".allmap .local_name").text("세종");}
	if (area_array[area_idx] == "Gyeonggi") {$(".allmap .local_name").text("경기");}
	if (area_array[area_idx] == "Gangwon") {$(".allmap .local_name").text("강원");}
	if (area_array[area_idx] == "Chungbuk") {$(".allmap .local_name").text("충북");}
	if (area_array[area_idx] == "Chungnam") {$(".allmap .local_name").text("충남");}
	if (area_array[area_idx] == "Jeonbuk") {$(".allmap .local_name").text("전북");}
	if (area_array[area_idx] == "Jeonnam") {$(".allmap .local_name").text("전남");}
	if (area_array[area_idx] == "Kyungbuk") {$(".allmap .local_name").text("경북");}
	if (area_array[area_idx] == "Gyeongnam") {$(".allmap .local_name").text("경남");}
	if (area_array[area_idx] == "Jeju") {$(".allmap .local_name").text("제주");}
	if (area_array[area_idx] == "Ulleungdo") {$(".allmap .local_name").text("울릉도");}

	/* 상세지도/정보 변경 */
	local_detail(area_array[area_idx]);

	area_idx++;
	if (area_idx == 7) { area_idx++ } // 세종(08)은 아직 이미지가 없으므로 스킵
	monitoring_cycle_5sec = setTimeout(readArea, 5000); /* 5초 간격 */
}
</script>





</body>
</html>