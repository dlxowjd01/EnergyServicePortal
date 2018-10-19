package kr.co.ewp.ewpsp.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.net.URLCodec;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mysql.fabric.xmlrpc.base.Data;

import kr.co.ewp.ewpsp.common.ExcelDownload;
import kr.co.ewp.ewpsp.common.util.AES256Util;
import kr.co.ewp.ewpsp.common.util.UserUtil;

@Controller
public class TestController {
	

//	@Resource(name="prop")
//	private ContextPropertiesUtil properties;
//	@Value("${ccccc.ddd}")
//	private String testStr3;
//	@Value("${globals.driverClassName}")
//	private String testStr4;

	@RequestMapping("/hptest")
	public String hptest() {
		System.out.println("/hptest");
//		enertalkAPI_test();
		return "ewp/main/main.jsp";
	}
	
	@RequestMapping(value="/hptest_sub", method = RequestMethod.GET)
	public String hptest_sub(@RequestParam HashMap param, @RequestParam String returnPage, Model model) {
		System.out.println("/hptest_sub");
		model.addAttribute("param", param);
		System.out.println("param : "+param.toString());
//		enertalkAPI_test();
		return "ewp"+returnPage;
	}
	
	@RequestMapping(value="/hptest_include", method = RequestMethod.POST)
	public String hptest_include(@RequestParam HashMap param, @RequestParam String returnPage, Model model) {
		System.out.println("/hptest_include");
		model.addAttribute("param", param);
		System.out.println("param : "+param.toString());
//		enertalkAPI_test();
		return "ewp"+returnPage;
	}
	
	@RequestMapping("/hello")
	public String hello() {
		System.out.println("여기오지?");
		enertalkAPI_test();
//		String testStr1 = properties.get("test");
//		String testStr2 = properties.get("bbbbb");
//		String testStr3 = properties.get("ccccc.ddd");
//		String testStr4 = properties.get("Globals.DriverClassName");
//		String testStr5 = properties.get("Globals.Password");
//		System.out.println("프로퍼티 값은? >> "+testStr1+", "+testStr2+", "+testStr3+", "+testStr4+", "+testStr5);
//		System.out.println("프로퍼티 값은? >> "+testStr3+", "+testStr4);
		
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
		String deviceId = "a8324a51";
//		String apiURL = "https://api2.enertalk.com/sites/:siteId/usages/periodic";
		String apiURL = "https://api2.enertalk.com/devices/:deviceId/usages/periodic";
		String start = "1533135600000";
		String end = "1533221999000";
		String timeType = "past";
		String period = "hour";
		String urlParam = "?start="+start+"&end="+end+"&timeType="+timeType+"&period="+period;
		System.out.println("조회기간 : "+new Date(Long.parseLong(start))+", "+new Timestamp((Long.parseLong(start)))+", "+new Date(Long.parseLong(end))+", "+new Timestamp((Long.parseLong(end))) );
		
		try {
			System.out.println("api url 테스트 시작");
//			URL url = new URL(  apiURL.replace(":siteId", siteId) + urlParam  );
//			System.out.println("url은? "+apiURL.replace(":siteId", siteId) + urlParam);
			URL url = new URL(  apiURL.replace(":deviceId", deviceId) + urlParam  );
			System.out.println("url은? "+apiURL.replace(":deviceId", deviceId) + urlParam);
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
	

	@RequestMapping("/fileUpload_test")
	public @ResponseBody Map<String, Object> getUsageRealList(@RequestParam HashMap param, MultipartHttpServletRequest multipart) throws Exception {
		System.out.println("/fileUpload_test");
		System.out.println("param ::::: "+param.toString());
		System.out.println("multipart : "+multipart.toString());
//		List list = usageService.getUsageRealList(param);
		
		System.out.println("bbb : " + multipart.getParameter("bbb")); // 파리미터 가져오기..
		System.out.println("ccc : " + multipart.getParameter("ccc")); // 파리미터 가져오기..
		
		 // 저장 경로 설정
//        String root = multipart.getSession().getServletContext().getRealPath("/");
        String root = "d:\\fileUploadTest\\test";
        String path = root+"/resources/upload/";
         
        String newFileName = ""; // 업로드 되는 파일명
         
        File dir = new File(path);
        System.out.println("폴더경로 존재여부 : "+!dir.isDirectory()+", "+!dir.exists());
        if(!dir.exists() ||!dir.isDirectory()){
        	System.out.println("여긴와?");
//            dir.mkdir();
            dir.mkdirs();
        }
         
        Iterator<String> files = multipart.getFileNames();
        while(files.hasNext()){
            String uploadFile = files.next();
                         
            MultipartFile mFile = multipart.getFile(uploadFile);
            String fileName = mFile.getOriginalFilename();
            System.out.println("실제 파일 이름 : " +fileName);
            newFileName = System.currentTimeMillis()+"."
                    +fileName.substring(fileName.lastIndexOf(".")+1);
             
            try {
                mFile.transferTo(new File(path+newFileName));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
		
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("list", list);
		return resultMap;
	}

	@RequestMapping("/test/aesEnc")
	public @ResponseBody String aesEncTest(String text) throws Exception {
		String textEnc = UserUtil.encAES256(text);

		return textEnc;
	}

	@RequestMapping("/test/aesDec")
	public @ResponseBody String aesDecTest(String text) throws Exception {
		String textDec = UserUtil.decAES256(text);

		return textDec;
	}

	@RequestMapping("/test/shaEnc")
	public @ResponseBody String shaEncTest(String text) throws Exception {
		String textEnc = UserUtil.encSHA256(text);

		return textEnc;
	}
}
