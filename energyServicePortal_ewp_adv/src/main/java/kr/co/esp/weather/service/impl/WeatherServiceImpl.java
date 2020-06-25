package kr.co.esp.weather.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.weather.service.WeatherService;


@Service("weatherService")
public class WeatherServiceImpl extends EgovAbstractServiceImpl implements WeatherService {
	
	@Resource(name="weatherMapper")
	private WeatherMapper weatherMapper;
	
	@Override
	public Map<String, Object> getSido(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = weatherMapper.getSido(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mapSido", maplistMapperResult);
		
		return resultMap;
	}
	
	
	@Override
	public Map<String, Object> getSigungu(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = weatherMapper.getSigungu(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mapSigungu", maplistMapperResult);
		
		return resultMap;
	}
	
	
	@Override
	public Map<String, Object> getEub(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = weatherMapper.getEub(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mapEub", maplistMapperResult);
		
		return resultMap;
	}
	
	
	private String getApiTime() {
		Calendar c1 = new GregorianCalendar();
		c1.add(Calendar.DATE, -1);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String strApiTime = "";
		strApiTime = sdf.format(c1.getTime()) + "2300";
		
		return strApiTime;
	}
	
	
	private String getMidApiTime() {
		//현재시간
		Calendar c1 = new GregorianCalendar();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String strTodayTime = sdf.format(c1.getTime());
		String strTodayH = strTodayTime.substring(8, 10);
		int iTodayH = Integer.parseInt(strTodayH);
		
		//어제 날짜 얻기
		c1.add(Calendar.DATE, -1);
		String strYesterdayTime = sdf.format(c1.getTime());
		
		String strApiTime = "";
		
		// 일 2회(06:00,18:00)회 생성 되며 발표시각을 입력 (최근 24시간 자료만 제공)
		// iTodayH < 6 then yesterday 18:00
		// iTodayH < 18 then today 06:00
		// else today 18:00
		if(iTodayH < 6)
		{
			strApiTime = strYesterdayTime.substring(0, 8) + "1800"; //"202003110600"
		}
		else if(iTodayH < 18)
		{
			strApiTime = strTodayTime.substring(0, 8) + "0600"; //"202003110600"
		}
		else
		{
			strApiTime = strTodayTime.substring(0, 8) + "1800"; //"202003110600"
		}
		
		return strApiTime;
	}
		
	
	@Override
	public Map<String, Object> getWeather(Map<String, Object> param) throws Exception {

		//http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?ServiceKey=BgDSkzXVUuiRWKMzVWbKfjUWfqBlRy%2BuHNv%2BYLztoo06utA1B2GYg3Iuinsh4R2PDsxMwe1Pnyvfy5llbj%2BQHw%3D%3D&nx=86&ny=88&base_date=20200310&base_time=2300&dataType=json&numOfRows=153&pageNo=1
		//{"response":{"header":{"resultCode":"00","resultMsg":"NORMAL_SERVICE"},"body":{"dataType":"JSON","items":{"item":[{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200311","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200311","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200311","fcstTime":"0300","fcstValue":"65","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200311","fcstTime":"0300","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200311","fcstTime":"0300","fcstValue":"3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200311","fcstTime":"0300","fcstValue":"2.6","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200311","fcstTime":"0300","fcstValue":"311","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200311","fcstTime":"0300","fcstValue":"-2.3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200311","fcstTime":"0300","fcstValue":"3.5","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200311","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200311","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"R06","fcstDate":"20200311","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200311","fcstTime":"0600","fcstValue":"70","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"S06","fcstDate":"20200311","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200311","fcstTime":"0600","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200311","fcstTime":"0600","fcstValue":"2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"TMN","fcstDate":"20200311","fcstTime":"0600","fcstValue":"1.0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200311","fcstTime":"0600","fcstValue":"2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200311","fcstTime":"0600","fcstValue":"315","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200311","fcstTime":"0600","fcstValue":"-2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200311","fcstTime":"0600","fcstValue":"2.8","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200311","fcstTime":"0900","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200311","fcstTime":"0900","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200311","fcstTime":"0900","fcstValue":"50","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200311","fcstTime":"0900","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200311","fcstTime":"0900","fcstValue":"4","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200311","fcstTime":"0900","fcstValue":"2.6","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200311","fcstTime":"0900","fcstValue":"321","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200311","fcstTime":"0900","fcstValue":"-3.2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200311","fcstTime":"0900","fcstValue":"4.1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200311","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200311","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"R06","fcstDate":"20200311","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200311","fcstTime":"1200","fcstValue":"30","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"S06","fcstDate":"20200311","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200311","fcstTime":"1200","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200311","fcstTime":"1200","fcstValue":"9","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200311","fcstTime":"1200","fcstValue":"4.3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200311","fcstTime":"1200","fcstValue":"315","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200311","fcstTime":"1200","fcstValue":"-4.3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200311","fcstTime":"1200","fcstValue":"6.1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200311","fcstTime":"1500","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200311","fcstTime":"1500","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200311","fcstTime":"1500","fcstValue":"25","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200311","fcstTime":"1500","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200311","fcstTime":"1500","fcstValue":"11","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"TMX","fcstDate":"20200311","fcstTime":"1500","fcstValue":"12.0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200311","fcstTime":"1500","fcstValue":"4.1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200311","fcstTime":"1500","fcstValue":"316","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200311","fcstTime":"1500","fcstValue":"-4.3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200311","fcstTime":"1500","fcstValue":"5.9","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200311","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200311","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"R06","fcstDate":"20200311","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200311","fcstTime":"1800","fcstValue":"25","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"S06","fcstDate":"20200311","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200311","fcstTime":"1800","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200311","fcstTime":"1800","fcstValue":"10","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200311","fcstTime":"1800","fcstValue":"2.7","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200311","fcstTime":"1800","fcstValue":"320","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200311","fcstTime":"1800","fcstValue":"-3.2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200311","fcstTime":"1800","fcstValue":"4.2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200311","fcstTime":"2100","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200311","fcstTime":"2100","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200311","fcstTime":"2100","fcstValue":"45","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200311","fcstTime":"2100","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200311","fcstTime":"2100","fcstValue":"5","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200311","fcstTime":"2100","fcstValue":"-0.3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200311","fcstTime":"2100","fcstValue":"16","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200311","fcstTime":"2100","fcstValue":"-1.4","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200311","fcstTime":"2100","fcstValue":"1.5","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"0000","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"0000","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"R06","fcstDate":"20200312","fcstTime":"0000","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"0000","fcstValue":"70","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"S06","fcstDate":"20200312","fcstTime":"0000","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"0000","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"0000","fcstValue":"2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"0000","fcstValue":"-0.1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"0000","fcstValue":"90","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"0000","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"0000","fcstValue":"0.2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"0300","fcstValue":"75","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"0300","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"0300","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"R06","fcstDate":"20200312","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"0600","fcstValue":"80","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"S06","fcstDate":"20200312","fcstTime":"0600","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"0600","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"0600","fcstValue":"-2","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"TMN","fcstDate":"20200312","fcstTime":"0600","fcstValue":"-2.0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"0600","fcstValue":"0.5","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"0600","fcstValue":"231","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"0600","fcstValue":"0.4","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"0600","fcstValue":"0.6","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"0900","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"0900","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"0900","fcstValue":"60","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"0900","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"0900","fcstValue":"4","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"0900","fcstValue":"0.5","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"0900","fcstValue":"209","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"0900","fcstValue":"0.9","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"0900","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"R06","fcstDate":"20200312","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"1200","fcstValue":"30","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"S06","fcstDate":"20200312","fcstTime":"1200","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"1200","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"1200","fcstValue":"12","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"1200","fcstValue":"0.9","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"1200","fcstValue":"201","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"1200","fcstValue":"2.3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"1200","fcstValue":"2.5","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"1500","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"1500","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"1500","fcstValue":"25","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"1500","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"1500","fcstValue":"15","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"TMX","fcstDate":"20200312","fcstTime":"1500","fcstValue":"16.0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"1500","fcstValue":"0.9","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"1500","fcstValue":"193","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"1500","fcstValue":"3.8","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"1500","fcstValue":"3.9","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"R06","fcstDate":"20200312","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"1800","fcstValue":"25","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"S06","fcstDate":"20200312","fcstTime":"1800","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"1800","fcstValue":"1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"1800","fcstValue":"13","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"1800","fcstValue":"0.5","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"1800","fcstValue":"187","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"1800","fcstValue":"4","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"1800","fcstValue":"4","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"POP","fcstDate":"20200312","fcstTime":"2100","fcstValue":"20","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"PTY","fcstDate":"20200312","fcstTime":"2100","fcstValue":"0","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"REH","fcstDate":"20200312","fcstTime":"2100","fcstValue":"50","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"SKY","fcstDate":"20200312","fcstTime":"2100","fcstValue":"3","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"T3H","fcstDate":"20200312","fcstTime":"2100","fcstValue":"9","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"UUU","fcstDate":"20200312","fcstTime":"2100","fcstValue":"0.1","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VEC","fcstDate":"20200312","fcstTime":"2100","fcstValue":"183","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"VVV","fcstDate":"20200312","fcstTime":"2100","fcstValue":"1.8","nx":86,"ny":88},{"baseDate":"20200310","baseTime":"2300","category":"WSD","fcstDate":"20200312","fcstTime":"2100","fcstValue":"1.8","nx":86,"ny":88}]},"pageNo":1,"numOfRows":153,"totalCount":164}}}
		
		String strApiTime = getApiTime();
		
		String apiUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst";
		// 홈페이지에서 받은 키
		String serviceKey = "BgDSkzXVUuiRWKMzVWbKfjUWfqBlRy%2BuHNv%2BYLztoo06utA1B2GYg3Iuinsh4R2PDsxMwe1Pnyvfy5llbj%2BQHw%3D%3D";
		String nx = (String) param.get("grid_x"); //"86";	//위도
		String ny = (String) param.get("grid_y"); //"88";	//경도
		String base_date = strApiTime.substring(0, 8);	//조회하고싶은 날짜 이 예제는 어제 날짜 입력해 주면 됨
		String base_time = "2300";	//API 제공 시간을 입력하면 됨
		String dataType = "json";	//타입 xml, json 등등 ..
		String numOfRows = "153";	//한 페이지 결과 수
		String pageNo = "1";
		
		//전날 23시 부터 153개의 데이터를 조회하면 오늘과 내일의 날씨를 알 수 있음
		
		StringBuilder urlBuilder = new StringBuilder(apiUrl);
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode(nx, "UTF-8")); //경도
		urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode(ny, "UTF-8")); //위도
		urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(base_date, "UTF-8")); /* 조회하고싶은 날짜*/
		urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode(base_time, "UTF-8")); /* 조회하고싶은 시간 AM 02시부터 3시간 단위 */
		urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode(dataType, "UTF-8"));	/* 타입 */
		urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode(numOfRows, "UTF-8"));	/* 한 페이지 결과 수 */
		urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode(pageNo, "UTF-8"));	/*  */
		
		// GET방식으로 전송해서 파라미터 받아오기
		URL url = new URL(urlBuilder.toString());
		//어떻게 넘어가는지 확인하고 싶으면 아래 출력분 주석 해제
		System.out.println(url);
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
		System.out.println(sb.toString());
		
		HashMap<String,Object> result = new ObjectMapper().readValue(sb.toString(), HashMap.class);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
	
		String resultCode = (String)((Map)((Map)result.get("response")).get("header")).get("resultCode");
        resultMap.put("resultCode", resultCode);
        
        List<Map<String, Object>> maplistMapperResult = null;//new ArrayList<Map<String, Object>>();
        
        if ("00".equals(resultCode)) { //성공 시
        	Map<String, Object> bodyMap = (Map)((Map)result.get("response")).get("body");
        	maplistMapperResult = (List)((Map<String, Object>) bodyMap.get("items")).get("item");
        }
        
        resultMap.put("mapWeather", maplistMapperResult);
        	
        
        return resultMap;				
	}

	
	@Override
	public Map<String, Object> getMidWeather(Map<String, Object> param) throws Exception {
		
		//http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst?serviceKey=BgDSkzXVUuiRWKMzVWbKfjUWfqBlRy%2BuHNv%2BYLztoo06utA1B2GYg3Iuinsh4R2PDsxMwe1Pnyvfy5llbj%2BQHw%3D%3D&numOfRows=10&pageNo=1&dataType=json&regId=11B00000&tmFc=202003110600
		//{"response":{"header":{"resultCode":"00","resultMsg":"NORMAL_SERVICE"},"body":{"dataType":"JSON","items":{"item":[{"regId":"11B00000","rnSt3Am":0,"rnSt3Pm":20,"rnSt4Am":40,"rnSt4Pm":10,"rnSt5Am":0,"rnSt5Pm":0,"rnSt6Am":30,"rnSt6Pm":60,"rnSt7Am":60,"rnSt7Pm":20,"rnSt8":20,"rnSt9":20,"rnSt10":20,"wf3Am":"맑음","wf3Pm":"맑음","wf4Am":"구름많음","wf4Pm":"맑음","wf5Am":"맑음","wf5Pm":"맑음","wf6Am":"구름많음","wf6Pm":"흐리고 비","wf7Am":"흐리고 비","wf7Pm":"맑음","wf8":"맑음","wf9":"맑음","wf10":"맑음"}]},"pageNo":1,"numOfRows":10,"totalCount":1}}}

		String strApiTime = getMidApiTime();
		
		String apiUrl = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst";
		// 홈페이지에서 받은 키
		String serviceKey = "BgDSkzXVUuiRWKMzVWbKfjUWfqBlRy%2BuHNv%2BYLztoo06utA1B2GYg3Iuinsh4R2PDsxMwe1Pnyvfy5llbj%2BQHw%3D%3D";
		String regId = (String) param.get("mid_land_cd"); //"11B00000";	//지역코드
		String tmFc = strApiTime; //"202003110600";	//API 제공 시간을 입력하면 됨
		String dataType = "json";	//타입 xml, json 등등 ..
		String numOfRows = "100";	//한 페이지 결과 수
		String pageNo = "1";
		
		StringBuilder urlBuilder = new StringBuilder(apiUrl);
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("regId","UTF-8") + "=" + URLEncoder.encode(regId, "UTF-8")); //지역코드
		urlBuilder.append("&" + URLEncoder.encode("tmFc","UTF-8") + "=" + URLEncoder.encode(tmFc, "UTF-8")); /* 조회하고싶은 날짜*/
		urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode(dataType, "UTF-8"));	/* 타입 */
		urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode(numOfRows, "UTF-8"));	/* 한 페이지 결과 수 */
		urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode(pageNo, "UTF-8"));	/*  */
		
		// GET방식으로 전송해서 파라미터 받아오기
		URL url = new URL(urlBuilder.toString());
		//어떻게 넘어가는지 확인하고 싶으면 아래 출력분 주석 해제
		System.out.println(url);
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
		System.out.println(sb.toString());
		
		HashMap<String,Object> result = new ObjectMapper().readValue(sb.toString(), HashMap.class);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
	
		String resultCode = (String)((Map)((Map)result.get("response")).get("header")).get("resultCode");
        resultMap.put("resultCode", resultCode);
        
        List<Map<String, Object>> maplistMapperResult = null;//new ArrayList<Map<String, Object>>();
        
        if ("00".equals(resultCode)) { //성공 시
        	Map<String, Object> bodyMap = (Map)((Map)result.get("response")).get("body");
        	maplistMapperResult = (List)((Map<String, Object>) bodyMap.get("items")).get("item");
        }
        
        resultMap.put("mapMidWeather", maplistMapperResult);
        	
        
        return resultMap;				
	}	
	
	
	@Override
	public Map<String, Object> getMidTempWeather(Map<String, Object> param) throws Exception {

		//http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey=BgDSkzXVUuiRWKMzVWbKfjUWfqBlRy%2BuHNv%2BYLztoo06utA1B2GYg3Iuinsh4R2PDsxMwe1Pnyvfy5llbj%2BQHw%3D%3D&numOfRows=100&pageNo=1&dataType=json&regId=11D20501&tmFc=202003110600
		//{"response":{"header":{"resultCode":"00","resultMsg":"NORMAL_SERVICE"},"body":{"dataType":"JSON","items":{"item":[{"regId":"11D20501","taMin3":0,"taMin3Low":1,"taMin3High":1,"taMax3":12,"taMax3Low":1,"taMax3High":1,"taMin4":3,"taMin4Low":1,"taMin4High":0,"taMax4":9,"taMax4Low":2,"taMax4High":1,"taMin5":0,"taMin5Low":1,"taMin5High":1,"taMax5":9,"taMax5Low":2,"taMax5High":2,"taMin6":3,"taMin6Low":2,"taMin6High":2,"taMax6":14,"taMax6Low":2,"taMax6High":2,"taMin7":5,"taMin7Low":1,"taMin7High":1,"taMax7":14,"taMax7Low":2,"taMax7High":2,"taMin8":7,"taMin8Low":0,"taMin8High":3,"taMax8":17,"taMax8Low":0,"taMax8High":2,"taMin9":8,"taMin9Low":0,"taMin9High":2,"taMax9":17,"taMax9Low":0,"taMax9High":1,"taMin10":6,"taMin10Low":0,"taMin10High":2,"taMax10":15,"taMax10Low":0,"taMax10High":2}]},"pageNo":1,"numOfRows":100,"totalCount":1}}}
		
		String strApiTime = getMidApiTime();

		String apiUrl = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa";
		// 홈페이지에서 받은 키
		String serviceKey = "BgDSkzXVUuiRWKMzVWbKfjUWfqBlRy%2BuHNv%2BYLztoo06utA1B2GYg3Iuinsh4R2PDsxMwe1Pnyvfy5llbj%2BQHw%3D%3D";
		String regId = (String) param.get("mid_temp_cd"); //"11D20501";	//지역코드
		String tmFc = strApiTime; //"202003110600";	//API 제공 시간을 입력하면 됨
		String dataType = "json";	//타입 xml, json 등등 ..
		String numOfRows = "100";	//한 페이지 결과 수
		String pageNo = "1";
		
		StringBuilder urlBuilder = new StringBuilder(apiUrl);
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("regId","UTF-8") + "=" + URLEncoder.encode(regId, "UTF-8")); //지역코드
		urlBuilder.append("&" + URLEncoder.encode("tmFc","UTF-8") + "=" + URLEncoder.encode(tmFc, "UTF-8")); /* 조회하고싶은 날짜*/
		urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode(dataType, "UTF-8"));	/* 타입 */
		urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode(numOfRows, "UTF-8"));	/* 한 페이지 결과 수 */
		urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode(pageNo, "UTF-8"));	/*  */
		
		// GET방식으로 전송해서 파라미터 받아오기
		URL url = new URL(urlBuilder.toString());
		//어떻게 넘어가는지 확인하고 싶으면 아래 출력분 주석 해제
		System.out.println(url);
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
		System.out.println(sb.toString());
		
		HashMap<String,Object> result = new ObjectMapper().readValue(sb.toString(), HashMap.class);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
	
		String resultCode = (String)((Map)((Map)result.get("response")).get("header")).get("resultCode");
        resultMap.put("resultCode", resultCode);
        
        List<Map<String, Object>> maplistMapperResult = null;//new ArrayList<Map<String, Object>>();
        
        if ("00".equals(resultCode)) { //성공 시
        	Map<String, Object> bodyMap = (Map)((Map)result.get("response")).get("body");
        	maplistMapperResult = (List)((Map<String, Object>) bodyMap.get("items")).get("item");
        }
        
        resultMap.put("mapMidTempWeather", maplistMapperResult);
        	
        
        return resultMap;					
	}		
}
