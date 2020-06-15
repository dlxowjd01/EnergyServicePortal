package kr.co.esp.api.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ApiExplorer {
	
	private static final Logger logger = LoggerFactory.getLogger(ApiExplorer.class);
	
	@RequestMapping("/getWeatherData.json")
    public @ResponseBody Map<String, Object> getWeatherData (@RequestParam Map <String, Object> param) throws IOException {
		
		Map<String, Object> resultMap = new HashMap<>();
		
		//site 좌표조회
		
		//초단기 실황, 예보 데이터 가져오기
		List<Map<String, Object>> shortFcstData = getShortFcstData();
		resultMap.put("shortFcstData", shortFcstData);
		//동네예보 데이터 가져오기
        List<Map<String, Object>> dongneData = getDongneData();
        resultMap.put("dongneData", dongneData);
		
        return resultMap;
    }
	
	public List<Map<String, Object>> getShortFcstData() throws IOException { // 
		List<Map<String, Object>> resultList = new ArrayList<>();
		//초단기 실황
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMMdd"); //형태
		SimpleDateFormat sdf2 = new SimpleDateFormat("HH"); //형태
	    Calendar cal = Calendar.getInstance(); //실황 계산용
	    Calendar cal2 = Calendar.getInstance(); //예보 계산용
//	    int nowHour = cal.get(Calendar.HOUR_OF_DAY); // 시간 구하기
	    String baseDate = sdf1.format(cal.getTime());  //ex 200311
	    String baseTime = "";                          
	    String baseTime2 = "";                          
	    int nowMin = cal.get(Calendar.MINUTE);
	    if(nowMin <= 40) {
	    	cal.add(Calendar.HOUR_OF_DAY, -1);
	    }
	    if(nowMin <= 45) {
	    	cal2.add(Calendar.HOUR_OF_DAY, -1);
	    }
	    
	    baseTime = sdf2.format(cal.getTime()) + "00"; //ex 1540 -> 1400 / 1550 -> 1500
	    baseTime2 = sdf2.format(cal2.getTime()) + "30"; //ex 1540 -> 1400 / 1550 -> 1500
	    
		//파라미터 세팅
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("serviceName", "getUltraSrtNcst");
		paramMap.put("baseDate", baseDate);
		paramMap.put("baseTime", baseTime);
		
        List<Map<String, Object>> itemList = getVilageFcstInfo(paramMap);
        Map<String, Object> dataMap = new HashMap<String, Object>();
        
        if (!itemList.isEmpty()) {
            dataMap.put("date", baseDate);
            dataMap.put("time", baseTime);
            for(Map<String, Object> item: itemList) {
            	dataMap.put((String) item.get("category"), item.get("obsrValue"));
            }
        }
        resultList.add(dataMap);
        
        //초단기 예보
        LinkedHashMap<String, Object> orderMap = new LinkedHashMap<String, Object>();
        
        paramMap.put("serviceName", "getUltraSrtFcst");
		paramMap.put("baseTime", baseTime2);
        List<Map<String, Object>> itemList2 = getVilageFcstInfo(paramMap);
        if (!itemList.isEmpty()) {
        	for (Map<String, Object> item : itemList2) {
        		if (orderMap.containsKey((String)item.get("fcstTime"))) {
        			((Map<String, Object>)orderMap.get((String)item.get("fcstTime"))).put((String)item.get("category"), item.get("fcstValue"));
        		} else {
        			Map<String, Object> tmp = new HashMap<String, Object>();
        			tmp.put("time", item.get("fcstTime"));
        			tmp.put("date", item.get("fcstDate"));
        			tmp.put((String)item.get("category"), item.get("fcstValue"));
        			orderMap.put((String) item.get("fcstTime"), tmp);
        		}
        	}
        }
        
        for(String s: orderMap.keySet()) {
        	resultList.add((Map<String, Object>) orderMap.get(s));
        }
        
		return resultList;
	}
	
	public List<Map<String, Object>> getDongneData() throws IOException {
		
		Calendar cal = Calendar.getInstance(); //api조회일자 계산용
		int nowHour = cal.get(Calendar.HOUR_OF_DAY); //현재시각
		int nowMin = cal.get(Calendar.MINUTE); //현재시각
		
		String baseDate = ""; //발표날짜
		String baseTime = ""; //발표시간
		
		int timeZone[] = {23, 20, 17, 14, 11, 8, 5, 2}; // 기준시간
		
		for(int i =0; i < timeZone.length; i++) {
			if(nowHour >= timeZone[i]) { //기준시간과 현재 시간 비교
				int stdTime = 0;
				if(nowMin > 10) { //10분 이상인 경우 기준시간 적용
					stdTime = timeZone[i];
				} else { //10분 이전인 경우, 이전의 기준시간 적용
					if(timeZone[i] == 2) { //현재가 2시 이전인 경우, 전날 23시 기준
						baseTime = "2300"; 
						cal.add(Calendar.DATE, -1);
					} else {
						stdTime = timeZone[i+1];
					}
				}
				baseTime = String.format("%02d", stdTime) + "00";
				break;
				
			} else {
				if(timeZone[i] == 2) { //현재가 2시 이전인 경우, 전날 23시 기준
					baseTime = "2300"; 
					cal.add(Calendar.DATE, -1);
				}
				continue;
			}
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		baseDate = sdf.format(cal.getTime());
		
		//파라미터 세팅
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("serviceName", "getVilageFcst");
		paramMap.put("baseDate", baseDate);
		paramMap.put("baseTime", baseTime);
		
        List<Map<String, Object>> itemList = getVilageFcstInfo(paramMap);
        List<Map<String, Object>> orderedList = new ArrayList<>();
        
        if (!itemList.isEmpty()) { //성공 시
        	
        	String storedTime = "";
        	String storedDate = "";
        	Map<String, Object> tempMap = new HashMap<String, Object>();
        	
        	for(Map<String, Object> item: itemList) {

        		if(storedDate.equals(item.get("fcstDate"))) { //날짜가 같을 때
        			if(storedTime.equals((String)item.get("fcstTime"))) { //시간이 같을 때
        				tempMap.put((String) item.get("category"), item.get("fcstValue")); //데이터 삽입
        			} else { //시간이 다를 때
    					tempMap.put("time", storedTime);
    					tempMap.put("date", storedDate);
    					Map<String, Object> inMap = new HashMap<String, Object>();
    					inMap.putAll(tempMap);
    					orderedList.add(inMap);
    					tempMap.clear();
        				storedTime = (String)item.get("fcstTime"); //시간 저장
        				tempMap.put((String) item.get("category"), item.get("fcstValue"));
        			}
        		} else { //날짜가 다를 때
        			if(!"".equals(storedDate)) { //초기값 제외
    					tempMap.put("time", storedTime);
    					tempMap.put("date", storedDate);
    					Map<String, Object> inMap = new HashMap<String, Object>();
    					inMap.putAll(tempMap);
    					orderedList.add(inMap);
    					tempMap.clear();
        			}
        			storedDate = (String)item.get("fcstDate"); // 날짜 저장
        			storedTime = (String)item.get("fcstTime"); //시간 저장
        			tempMap.put((String) item.get("category"), item.get("fcstValue"));
        		}
        	}
        	if(!tempMap.isEmpty()) {
        		tempMap.put("time", storedTime);
				tempMap.put("date", storedDate);
        		Map<String, Object> inMap = new HashMap<String, Object>();
				inMap.putAll(tempMap);
				orderedList.add(inMap);
				tempMap.clear();
        	}
        }
		return orderedList;
	}
	
	public List<Map<String, Object>> getVilageFcstInfo(Map<String, Object> param) throws IOException {
		
	    String serviceKey = "SqCFwxH%2B3Z2guoNvsiZni02zNMqK40mqJ8FAkN5hFYbz68kxBaqqz0uS%2Bgf5lOx9w%2BS9RoETRR4NCYbj6j80Qg%3D%3D";
	    String base_date = (String)param.get("baseDate"); 
	    String base_time = (String)param.get("baseTime");
	    String serviceName = (String)param.get("serviceName");
	    String nx = "59";
	    String ny = "125";
	    
	    StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService/" + serviceName ); /*URL*/
	    urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=" + serviceKey); /*공공데이터포털에서 받은 인증키*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("500", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON)Default: XML*/
        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(base_date, "UTF-8")); /*발표일자*/
        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode(base_time, "UTF-8")); /*발표시각*/
        urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode(nx, "UTF-8")); /*예보지점 X 좌표값*/
        urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode(ny, "UTF-8")); /*예보지점 Y 좌표값*/
        URL url = new URL(urlBuilder.toString());
        HashMap<String, Object> rs = null;
        try {
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        System.out.println("Response code: " + conn.getResponseCode());
	        BufferedReader rd;
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        //json to map
	        rs = new ObjectMapper().readValue(sb.toString(), HashMap.class);
	    } catch(Exception e) {
	        logger.debug("api connection error: " + e);
	    }
        
        String resultCode = (String)((Map)((Map)rs.get("response")).get("header")).get("resultCode");
        List<Map<String, Object>> itemList = new ArrayList<>();
        Map<String, Object> dataMap = new HashMap<String, Object>();
        
        if ("00".equals(resultCode)) {
        	Map<String, Object> bodyMap = (Map)((Map)rs.get("response")).get("body");
            itemList = (List)((Map<String, Object>) bodyMap.get("items")).get("item");
        }
        
        return itemList;
	}
}