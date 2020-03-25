<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/decorators/include/taglibs.jsp"%>


<script src="https://code.highcharts.com/5.0.14/highcharts-more.js"></script>
<script src="https://code.highcharts.com/5.0.14/modules/solid-gauge.js "></script>
<script src="https://code.highcharts.com/5.0.14/modules/exporting.js"></script>
<script src="https://code.highcharts.com/5.0.14/modules/export-data.js"></script>
<script src="https://code.highcharts.com/5.0.14/modules/accessibility.js"></script>


<script>
function sendSms() {
	$.ajax({
		url: "/sendSms.json",
		type: 'post',
		async: false, // 동기로 처리해줌
		data: {
			sms_number: $("#sms_number").val(),
			sms_text: $("#sms_text").val()
		},
		success: function (result) {
			var resultCnt = result.resultCnt;
			if (resultCnt === 40) {
				alert('문자가 발송되었습니다.');
			} else {
				alert('<spring:message code="ewp.error.default" />');
			}
		}
	}); 	
}


function sendEmail() {
	$.ajax({
		url: "/sendMail.json",
		type: 'post',
		async: false, // 동기로 처리해줌
		data: {
			email_address: $("#email_address").val(),
			email_title: $("#email_title").val(),
			email_text: $("#email_text").val()
		},
		success: function (result) {
			var bResult = result.resultVal;
			if (bResult === true) {
				alert('메일이 발송되었습니다.');
			} else {
				alert('<spring:message code="ewp.error.default" />');
			}
		}
	}); 	
}


</script>


<style>
.space {
 	background:#333841;
}
</style>




<!-- 메인페이지용 스타일/스크립트 파일 -->
<link type="text/css" href="../css/main.css" rel="stylesheet">

<div id="tot" class="space" style="width:100%; height:900px; display:inline-block; overflow: auto;">
	<div id="tot_r1_1" class="space" style="width:100%; display:inline-block;">
		<div id="tot_r1_1_c1" style="width: 90%; min-height: 100px; display:inline-block; vertical-align:top; background:#009900; margin: 10px;">
			<label for="sms_number">전화번호</label>
			<input id="sms_number" type="text" />
			<label for="sms_text">문자내용</label>
			<input id="sms_text" type="text" />			
			<button onclick="sendSms()">전송</button>
			<br/><br/>
			<label for="email_address">e-mail</label>
			<input id="email_address" type="text" />
			<label for="email_title">e-mail제목</label>
			<input id="email_title" type="text" />			
			<label for="email_text">e-mail내용</label>
			<textarea input id="email_text" type="textarea" rows="5" cols="100" /></textarea>			
			<button onclick="sendEmail()">전송</button>		
		</div>	
	</div>
	<div id="tot_r1" class="space" style="width:100%; display:inline-block;">
		<div id="tot_r1_c1" style="width: 45%; min-height: 200px; display:inline-block; vertical-align:top; background:#00aa00; margin: 10px;">
		</div>	
		<div id="tot_r1_c2" style="width: 45%; min-height: 200px; display:inline-block; vertical-align:top; background:#00dd00; margin: 10px;">
		</div>		
	</div>
	<div id="tot_r2" class="space" style="width:100%; display:inline-block;">
		<div id="tot_r2_c1" class="space" style="width: 30%; min-height: 200px; display:inline-block; vertical-align:top; margin: 10px;">
			<div id="tot_r2_c1_r1" style="width: 90%; min-height: 200px; display:inline-block; background:#f11111; margin: 10px;">
			</div>
			<div id="tot_r2_c1_r2" style="width: 90%; min-height: 200px; display:inline-block; background:#f33333; margin: 10px;">
			</div>
			<div id="tot_r2_c1_r3_1" style="width: 90%; min-height: 30px; display:inline-block; background:#f55555; margin: 10px;">
			</div>
			<div id="tot_r2_c1_r3" style="width: 90%; min-height: 200px; display:inline-block; background:#f55555; margin: 10px;">
			</div>
			<div id="tot_r2_c1_r4_1" style="width: 90%; min-height: 30px; display:inline-block; background:#f77777; margin: 10px;">
			</div>			
			<div id="tot_r2_c1_r4" style="width: 90%; min-height: 200px; display:inline-block; background:#f77777; margin: 10px;">
			</div>			
		</div>	
		<div id="tot_r2_c2" class="space" style="width: 30%; min-height: 200px; display:inline-block; vertical-align:top; margin: 10px;">
			<div id="tot_r2_c2_r1" style="width: 90%; min-height: 700px; display:inline-block; background:#55f555; margin: 10px;">
			
				<!-- 지역별 사용량 //-->
<!-- 				<button onclick="javascript: document.getElementById('site_info_5').style.background='#ff0000'">abc</button> -->
<!-- 				<button onclick="javascript: document.getElementById('site_info_5').style.minHeight='500px';">abc</button> -->
				<div class="chart_top">
					<h2 class="ntit">군별사용량</h2>
					<a href="#;" class="default_btn fr all_map_view"><span>전체지도보기</span></a>					
				</div>
				<div class="map_wrap">
					<img src="../img/local_map_all.png" alt="전체지도" name="local"
						usemap="#local_map_all" id="local" border="0" />
					<map name="local_map_all" id="local_map_all">
						<area href="javascript:local_detail('Busan')" alt="Busan"
							shape="poly"
							coords="359,486,353,488,351,493,350,498,348,503,345,509,345,516,350,518,359,515,365,509,366,504,370,503,370,499,363,491,361,487"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Jeonbuk')" alt="Jeonbuk"
							shape="poly"
							coords="60,388,83,384,95,381,99,374,103,371,111,370,122,366,127,367,126,373,131,375,142,374,150,372,153,368,160,377,165,381,167,386,177,386,185,385,189,381,193,382,202,386,212,384,216,386,219,385,221,390,221,398,217,403,212,407,206,408,202,414,199,417,196,426,192,437,189,446,190,452,193,459,196,466,194,471,191,476,189,484,180,479,172,477,169,480,160,483,150,484,148,480,139,481,132,483,131,476,127,471,129,466,124,462,120,463,117,468,110,462,103,458,98,459,93,460,90,465,88,471,86,475,70,481,69,476,70,469,66,467,56,469,50,469,55,424,59,395"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Jeonnam')" alt="Jeonnam"
							shape="poly"
							coords="96,489,88,478,95,466,102,462,110,469,116,471,123,467,125,473,127,482,134,485,142,485,149,486,163,487,174,480,183,483,188,493,191,503,199,512,206,523,209,530,210,563,214,588,204,601,152,634,99,646,64,648,28,626,0,595,2,506,46,477,52,473,65,470,65,482,76,483,87,479,95,490,99,499,105,504,114,504,120,498,118,491,111,487,103,487"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Daegu')" alt="Daegu"
							shape="poly"
							coords="297,386,302,383,308,382,314,383,319,387,319,392,320,397,320,402,316,402,316,408,314,410,308,410,305,410,303,416,301,423,298,428,294,424,292,421,292,416,289,412,290,404,295,403,296,399,295,396,297,392"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Daejeon')" alt="Daejeon"
							shape="poly"
							coords="145,317,150,315,155,314,159,318,160,322,164,323,168,322,171,326,171,330,170,333,169,339,164,341,158,346,154,345,152,340,152,334,152,329,149,324,146,320"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Gangwon')" alt="Gangwon"
							shape="poly"
							coords="116,58,139,48,158,46,176,48,200,45,219,47,251,42,264,25,266,7,276,2,284,18,301,58,332,109,356,141,379,178,395,218,403,250,405,283,399,292,392,292,385,286,386,272,384,264,378,262,369,256,364,246,365,243,373,241,376,237,372,232,364,230,357,231,350,231,343,229,339,231,333,225,325,221,321,225,319,228,320,235,310,233,301,230,294,224,288,227,283,222,278,219,269,222,270,217,272,211,263,208,255,208,247,208,240,214,237,205,231,204,223,209,223,214,219,219,216,217,213,211,207,213,197,216,193,216,205,184,208,178,210,172,216,165,211,159,199,155,184,149,184,142,181,134,183,123,189,119,192,111,192,104,187,102,182,97,175,95,172,86,170,79,162,81,156,79,155,73,155,69,148,70,145,73,142,68,138,70,138,77,131,75,123,65"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Gwangju')" alt="Gwangju"
							shape="poly"
							coords="99,490,103,491,106,489,110,490,114,491,116,495,116,498,113,501,109,502,105,501,101,498,98,494,98,492"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Gyeongnam')" alt="Gyeongnam"
							shape="poly"
							coords="374,498,380,482,375,478,372,473,364,468,357,461,350,460,346,455,349,449,349,446,341,443,331,447,326,451,313,449,303,450,297,443,297,438,292,442,285,442,280,444,271,440,259,439,255,434,256,426,249,417,245,415,239,413,234,410,227,407,222,403,216,410,208,412,201,421,199,429,192,448,195,453,199,464,197,471,193,480,189,487,192,496,196,505,201,511,210,523,212,530,214,555,220,574,260,583,313,569,346,522,343,517,341,509,342,504,346,500,349,492,351,487,356,484,363,484,366,492,370,497"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Jeju')" alt="Jeju"
							shape="poly"
							coords="38,709,91,695,109,705,112,719,89,738,67,744,24,744,17,730"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Chungnam')" alt="Chungnam"
							shape="poly"
							coords="16,269,33,242,50,228,71,233,85,239,102,254,111,253,118,255,132,252,140,255,149,262,154,270,153,277,145,288,141,302,140,311,145,324,149,332,151,342,153,349,161,347,168,342,175,326,179,328,170,344,170,355,176,355,181,360,183,370,186,379,180,382,168,380,161,374,158,367,152,364,145,369,136,372,130,371,128,362,121,362,108,366,100,368,92,375,82,381,62,365,31,307,16,278"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Chungbuk')" alt="Chungbuk"
							shape="poly"
							coords="150,254,160,252,163,250,165,245,171,239,177,237,188,220,209,216,209,222,219,222,225,218,226,211,231,208,235,213,237,217,250,213,257,211,268,212,264,218,266,225,276,223,282,228,292,229,306,235,292,244,285,251,282,258,282,266,272,271,269,267,262,261,257,264,255,269,248,265,243,270,238,268,235,278,238,283,227,281,223,285,216,288,213,298,208,300,211,306,218,314,214,331,216,336,213,339,214,348,220,348,225,352,233,352,235,357,230,358,228,365,225,373,220,380,216,382,212,381,206,384,195,379,189,375,184,365,184,356,179,352,172,352,174,344,176,336,180,331,184,326,178,324,173,325,172,318,168,318,163,321,158,311,150,313,144,315,142,308,145,292,150,285,155,279,158,271,153,260"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Kyungbuk')" alt="Kyungbuk"
							shape="poly"
							coords="296,434,290,439,280,441,273,437,262,437,260,427,255,418,248,409,236,407,226,399,225,389,222,381,233,360,240,359,234,348,227,348,217,344,217,338,220,333,220,315,218,307,212,301,221,291,230,285,241,288,237,277,244,272,255,272,260,265,270,272,282,271,287,262,290,251,310,236,322,239,325,227,335,232,341,234,354,235,365,234,370,238,362,238,359,245,363,254,370,263,380,265,381,277,382,290,387,296,396,295,399,300,402,323,394,337,396,359,399,368,397,378,404,381,415,371,417,384,411,405,404,429,401,435,391,433,384,435,379,429,375,426,368,426,359,431,355,434,358,438,348,441,340,441,334,442,326,447,317,446,308,446,299,439,301,429,305,421,310,414,318,412,322,400,324,393,320,385,314,379,305,378,296,382,293,389,290,397,287,404,290,420,294,429"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Ulsan')" alt="Ulsan"
							shape="poly"
							coords="403,439,396,438,390,437,384,438,379,437,378,431,373,430,368,430,363,431,360,433,359,438,355,441,352,445,351,450,350,455,355,458,361,460,368,466,373,470,377,475,382,479,392,473,400,456,404,443"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Ulleungdo')" alt="Ulleungdo"
							shape="poly" coords="434,156,433,167,449,173,449,152"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Seoul')" alt="Seoul"
							shape="poly"
							coords="121,139,127,140,129,144,130,148,130,153,130,158,134,158,137,157,138,160,135,162,135,167,133,170,128,172,124,173,121,171,116,173,112,174,108,174,105,170,103,169,100,167,98,163,95,159,94,156,95,154,99,155,102,156,106,155,107,152,108,149,111,149,115,147,118,141"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Incheon')" alt="Incheon"
							shape="poly"
							coords="27,119,40,119,51,117,61,126,61,138,61,147,69,158,77,158,81,159,86,163,88,168,91,173,89,178,84,181,78,185,72,202,67,208,45,209,16,213,8,200,16,151,23,126"
							onfocus='this.blur()' />
						<area href="javascript:local_detail('Gyeonggi')" alt="Gyeonggi"
							shape="poly"
							coords="95,149,89,144,81,136,81,122,79,113,78,99,92,90,99,80,105,73,112,62,121,68,125,73,132,79,138,81,141,73,146,76,151,72,151,80,155,84,161,84,168,84,170,92,174,100,180,100,183,105,189,111,187,116,180,120,178,129,179,134,176,138,181,141,178,148,182,152,189,155,206,160,211,165,205,177,200,190,193,203,187,216,179,228,173,236,167,239,161,245,159,249,150,252,142,253,135,247,128,248,116,251,104,247,93,233,78,215,76,201,80,187,89,183,92,178,94,173,91,169,89,164,86,158,81,156,71,156,66,146,63,126,69,126,77,127,77,133,79,141,82,144,90,147,92,152,94,161,98,168,102,172,108,176,114,176,121,174,124,176,132,173,136,170,139,167,138,163,141,159,140,155,133,155,133,148,131,140,128,136,123,135,118,137,115,142,111,146,107,147,106,151,102,154,98,153"
							onfocus='this.blur()' />
					</map>
				</div>
				<div class="map_wrap_detail">
					<img src="../img/local_map_Seoul_detail.png" alt="상세지도"
						id="local_detail">
				</div>
				<!-- 전체지도용 지역정보 -->
				<div class="local_info allmap">
					<h2 class="local_name">서울</h2>
					<div class="clear">
						<ul>
							<li><strong>사용량</strong> <span>564</span> <em>MWh</em></li>
							<li><strong>발전량</strong> <span>328</span> <em>MWh</em></li>
						</ul>
						<ul>
							<li><strong>충•방전량</strong> <span>183</span> <em>MWh</em></li>
							<li><strong>수익</strong> <span>99,000</span> <em>won</em></li>
						</ul>
					</div>
				</div>
				<!-- 상세지도용 지역정보 -->
				<div class="local_info detailmap">
					<h2 class="local_name">서울</h2>
					<div class="clear">
						<ul>
							<li><strong>사용량</strong> <span>564</span> <em>MWh</em></li>
							<li><strong>발전량</strong> <span>328</span> <em>MWh</em></li>
						</ul>
						<ul>
							<li><strong>충•방전량</strong> <span>183</span> <em>MWh</em></li>
							<li><strong>수익</strong> <span>99,000</span> <em>won</em></li>
						</ul>
					</div>
				</div>
				<!-- // 지역별 사용량 -->			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			</div>		
			<div id="tot_r2_c2_r2" style="width: 90%; min-height: 200px; display:inline-block; background:#aafaaa; margin: 10px;">
			
			
				<div class="chart_footer">
					<div class="chart_table">
						<table class="main_use">
							<thead>
								<tr>
									<th>충/방전량</th>
									<th>충전량</th>
									<th>방전량</th>
									<th>수익</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>TODAY</th>
									<td>1,350.5 kWh</td>
									<td>850.5 kWh</td>
									<td>2.1</td>
								</tr>
								<tr>
									<th>THIS MONTH</th>
									<td>8.9 MWh</td>
									<td>12.1 MWh</td>
									<td>64.9</td>
								</tr>
								<tr>
									<th>THIS YEAR</th>
									<td>58.9 MWh</td>
									<td>192.1 MWh</td>
									<td>464.9</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>			
			</div>			
		</div>		
		<div id="tot_r2_c3" class="space" style="width: 30%; min-height: 200px; display:inline-block; vertical-align:top; margin: 10px;">
			<div id="tot_r2_c3_r1" style="width: 90%; min-height: 40px; display:inline-block; background:#8888f5; margin: 10px;">
				<div id="tot_r2_c3_r1_c1" style="width: 40%; min-height: 30px; display:inline-block; background:#8888f5; margin: 10px;">
				</div>			
				<div id="tot_r2_c3_r1_c2" style="width: 40%; min-height: 30px; display:inline-block; background:#8888f5; margin: 10px;">
				</div>				
			</div>		
			<div id="tot_r2_c3_r2" style="width: 90%; min-height: 900px; display:inline-block; background:#5555f5; margin: 10px;">
			</div>			
		</div>		
	</div>
</div>