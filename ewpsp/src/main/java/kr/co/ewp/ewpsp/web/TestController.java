package kr.co.ewp.ewpsp.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.ewp.ewpsp.common.ExcelDownload;

@Controller
public class TestController {
	

	@RequestMapping("/hptest")
	public String hptest() {
		System.out.println("일단 여긴 와야지");
//		enertalkAPI_test();
		return "ewp/main/main.jsp";
	}
	
	@RequestMapping(value="/hptest_sub", method = RequestMethod.GET)
	public String hptest_sub(@RequestParam HashMap param, @RequestParam String returnPage, Model model) {
		System.out.println("일단 여긴 와야지");
		model.addAttribute("param", param);
		System.out.println("param은? : "+param.toString());
//		enertalkAPI_test();
		return "ewp"+returnPage;
	}
	
	@RequestMapping(value="/hptest_include", method = RequestMethod.POST)
	public String hptest_include(@RequestParam HashMap param, @RequestParam String returnPage, Model model) {
		System.out.println("일단 여긴 와야지");
		model.addAttribute("param", param);
		System.out.println("param은? : "+param.toString());
//		enertalkAPI_test();
		return "ewp"+returnPage;
	}
	
	@RequestMapping("/hello")
	public String hello() {
		System.out.println("여기오지?");
//		enertalkAPI_test();
		return "test/hello";
	}
	
	@RequestMapping("/pdfTest")
	public String pdfTest() {
		System.out.println("여기오지????");
		return "test/pdfTest";
	}
	
	
	
	
	
	@RequestMapping(value = "/excelDownloadTest")
    public void excelDownloadTest(@RequestParam HashMap param, Model model, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {

		System.out.println("야호!  "+param.get("aa"));
		String queryId = "opbcMngDao.getOpbcApprListExcelDownload";
		String excel_title = "테스트 엑셀_"+System.currentTimeMillis();
		param.put("queryId", queryId);
		param.put("excel_title", excel_title);
		
		String res = excelDonwload(param, response);
		System.out.println("res = "+res);
//		if("end".equals(res)) {
//			// 엑셀 다운로드 요청을 처리하는 곳에서 응답 헤더에 fileDownloadToken 쿠키를 넣어줌.
////		Cookie cookie = new Cookie("fileDownloadToken", "TRUE");
//			response.addCookie(new Cookie("fileDownloadToken", "TRUE"));
//			
//		}

	}
	
	public String excelDonwload(HashMap param, HttpServletResponse response)throws Exception {
		
		System.out.println("엑셀다운로드 직전...");
		String res = "";
		
		ExcelDownload ed = null;
		try {
			ed = new ExcelDownload(response, param);
			
			for (int i = 0; i < 50000; i++) {
				LinkedHashMap map = new LinkedHashMap(); // hashmap인데 순서가있음
				map.put("aaaaaaa", "첫번째컬럼 "+(i+1));
				map.put("bbbbbbb", "두번째컬럼 "+(i+1));
				map.put("ccccccc", "세번째컬럼 "+(i+1));
				map.put("dddd", "네번째컬럼 "+(i+1));
				map.put("eeee", "다섯번째컬럼 "+(i+1));
				map.put("ffffff", "여섯번째컬럼 "+(i+1));
				map.put("gggg", "일곱번째컬럼 "+(i+1));
				map.put("hhhhhhhh", "여덟번째컬럼 "+(i+1));
				map.put("iiiiii", "아홉번째컬럼 "+(i+1));
				map.put("jjj", "열번째컬럼 "+(i+1));
				map.put("kkkkk", "열한번째컬럼 "+(i+1));
				map.put("lllll", "열두번째컬럼 "+(i+1));
				map.put("mmmmmmm", "열세번째컬럼 "+(i+1));
				map.put("nn", "열네번째컬럼 "+(i+1));
				
				System.out.println(i+"번째 map : "+map.toString());
				ed.handleRow(map);
			}
			res = res+",1";
		} catch (Exception e) {
			e.printStackTrace();
			res = res+",2";
		} finally {
			res = res+",3";
			if(ed != null) {
				ed.close();
				res = res+",4";
			}
		}
		
		return res;
		
	}
	
	
	
	
	
	public void enertalkAPI_test() {
		String ServerKey = "Wlhkd1pHVjJRR2hyYVhSekxtTnZMbXR5WDBWWFVDRHNoSnpydVlUc2lxVHRqNnp0ZzRnPQ=="; // 서버키
		String siteId = "17094385";
		String apiURL = "https://api2.enertalk.com/sites/:siteId/usages/periodic";
		String start = "1533135600000";
		String end = "1533221999000";
		String timeType = "past";
		String period = "hour";
		String urlParam = "?start="+start+"&end="+end+"&timeType="+timeType+"&period="+period;
		
		try {
			System.out.println("api url 테스트 시작");
			URL url = new URL(  apiURL.replace(":siteId", siteId) + urlParam  );
			System.out.println("url은? "+apiURL.replace(":siteId", siteId) + urlParam);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("authorization", "Basic " + ServerKey);
			con.setDoOutput(true);
			Map headerFields = con.getHeaderFields();
			System.out.println("header fields are : "+headerFields);
			
			int resCode = con.getResponseCode();
			BufferedReader br;
			if(resCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				System.out.println("while을 몇번돌까?");
				response.append(inputLine);
			}
			br.close();
			System.out.println("apr result : "+response.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
