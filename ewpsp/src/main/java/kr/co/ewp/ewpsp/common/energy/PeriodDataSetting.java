package kr.co.ewp.ewpsp.common.energy;

import java.sql.Timestamp;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.ewp.ewpsp.common.util.CommonUtils;

public class PeriodDataSetting {

	private static final Logger logger = LoggerFactory.getLogger(PeriodDataSetting.class);

	/**
	 * 조회간격에 따라 데이터를 조합하여 셋팅
	 * @param param : 검색조건
	 * @param dataList : db 데이터
	 * @param timestampStr : 계산기준 컬럼명
	 * @param calculValStr : 계산에 사용될 컬럼명
	 * @param flag : 1:실제(15min), 2:예측(hour)
	 * @return
	 */
	public static Map dataSetting(HashMap param, List dataList, String timestampStr, String calculValStr, int flag) {
		logger.debug("PeriodDataSetting.dataSetting()+"+timestampStr+", "+calculValStr);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String term = (String) param.get("selTerm"); // 조회기간
		String period = (String) param.get("selPeriodVal"); // 데이터조회간격
		Timestamp startDate = getStartEndTimestamp((String) param.get("selTermFrom"), "1"); // 검색시작일(그래프영역)
		Timestamp endDate = getStartEndTimestamp((String) param.get("selTermTo"), "2"); // 검색종료일(그래프영역)
		Timestamp selTermFrom = getConvertStartEndTmsp( term, period, (String) param.get("selTermFrom") , "1"); // 검색시작일(표영역)
		Timestamp selTermTo = getConvertStartEndTmsp( term, period, (String) param.get("selTermTo") , "2"); // 검색종료일(표영역)
		
		// 날짜리스트 생성
		List sheetDateList = getDateList(selTermFrom, selTermTo, term, period, timestampStr, calculValStr); // 표영역
		List chartDateList = getDateList(startDate, endDate, term, period, timestampStr, calculValStr); // 그래프영역
		
		// 데이터조합
		List sheetReDataList = DataPeriodCalculate.periodCalculate(dataList, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag); // 표영역
		List chartReDataList = DataPeriodCalculate.periodCalculate(dataList, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag); // 그래프영역
		
		// 날짜리스트+데이터조합 매칭
		List sheetList = matchingLists(sheetDateList, sheetReDataList, timestampStr, calculValStr); // 표영역
		List chartList = matchingLists(chartDateList, chartReDataList, timestampStr, calculValStr); // 그래프영역
		logger.debug("sheetList     ======>   "+sheetList.toString());
		logger.debug("chartList     ======>   "+chartList.toString());
		
		map.put("sheetList", sheetList);
		map.put("chartList", chartList);
		
		return map;
	}
	
	/**
	 * 그래프영역 검색일자 변환(분단위를 00, 15, 30, 45중 하나로 맞추고 timestamp로 리턴)
	 * @param timestamp
	 * @param flag
	 * @return
	 */
	public static Timestamp getStartEndTimestamp(String timestamp, String flag) {
		String reTimestamp = timestamp.substring(0, 4)+"-"+timestamp.substring(4, 6)+"-"+timestamp.substring(6, 8)+" "+timestamp.substring(8, 10)+":"+timestamp.substring(10, 12)+":"+timestamp.substring(12, 14);
		Timestamp tp = Timestamp.valueOf(reTimestamp);
		Date dt = new Date(tp.getTime());
		if(dt.getMinutes() == 0) {
			dt.setMinutes(0);
		} else if(dt.getMinutes()> 0 && dt.getMinutes() < 15) {
			if("1".equals(flag)) dt.setMinutes(15);
			else if("2".equals(flag)) dt.setMinutes(0);
		} else if(dt.getMinutes() < 30) {
			if("1".equals(flag)) dt.setMinutes(30);
			else if("2".equals(flag)) dt.setMinutes(15);
		} else if(dt.getMinutes() < 45) {
			if("1".equals(flag)) dt.setMinutes(45);
			else if("2".equals(flag)) dt.setMinutes(30);
		} else if(dt.getMinutes() <60) {
			if("1".equals(flag)) {
				dt.setMinutes(0);
				dt.setSeconds(0);
				dt.setHours(dt.getHours()+1);
			}
			else if("2".equals(flag)) dt.setMinutes(45);
		}
		dt.setSeconds(0);
		
		Timestamp tmsp = new Timestamp(dt.getTime());
		return tmsp;
	}

	/**
	 * 표영역 검색일자 변환(분단위를 00, 15, 30, 45중 하나로 맞추고 timestamp로 리턴)
	 * @param timestamp 정리할 검색일자
	 * @param flag 시작일자:1, 종료일자:2
	 * @return
	 */
	public static Timestamp getConvertStartEndTmsp(String term, String period, String timestamp, String flag) {
		String reTimestamp = timestamp.substring(0, 4)+"-"+timestamp.substring(4, 6)+"-"+timestamp.substring(6, 8)+" "+timestamp.substring(8, 10)+":"+timestamp.substring(10, 12)+":"+timestamp.substring(12, 14);
		
		Timestamp tp = Timestamp.valueOf(reTimestamp);
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(   tp.getTime()   );
		
		if("30min".equals(term) || "hour".equals(term)) {
			Date dt = new Date(tp.getTime());
			if(dt.getMinutes() == 0) {
				dt.setMinutes(0);
			} else if(dt.getMinutes()> 0 && dt.getMinutes() < 15) {
				if("1".equals(flag)) dt.setMinutes(15);
				else if("2".equals(flag)) dt.setMinutes(0);
			} else if(dt.getMinutes() < 30) {
				if("1".equals(flag)) dt.setMinutes(30);
				else if("2".equals(flag)) dt.setMinutes(15);
			} else if(dt.getMinutes() < 45) {
				if("1".equals(flag)) dt.setMinutes(45);
				else if("2".equals(flag)) dt.setMinutes(30);
			} else if(dt.getMinutes() <60) {
				if("1".equals(flag)) {
					dt.setMinutes(0);
					dt.setSeconds(0);
					dt.setHours(dt.getHours()+1);
				}
				else if("2".equals(flag)) dt.setMinutes(45);
			}
			dt.setSeconds(0);
			
			Timestamp tmsp = new Timestamp(dt.getTime());
			return tmsp;
			
		} else {
			if("1".equals(flag)) {
				cal.set(Calendar.HOUR_OF_DAY, 0);
				cal.set(Calendar.MINUTE, 0);
				cal.set(Calendar.SECOND, 0);
			} else if("2".equals(flag)) {
				cal.set(Calendar.HOUR_OF_DAY, 23);
				cal.set(Calendar.MINUTE, 59);
				cal.set(Calendar.SECOND, 59);
			}
			
			if("year".equals(term) && "month".equals(period)) { // 1년을 1월간격 조회
				if("1".equals(flag)) {	
					cal.set(Calendar.DATE, 1);
				} else if("2".equals(flag)) {
					cal.set(Calendar.DATE, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
				}
			}
			
			Date dt = new Timestamp(cal.getTime().getTime());
			Timestamp tmsp = new Timestamp(dt.getTime());
			return tmsp;
		}
		
	}
	
	/**
	 * 날짜리스트 생성
	 * @param selTermFrom
	 * @param selTermTo
	 * @param term
	 * @param period
	 * @param timestampStr 
	 * @param calculValStr 
	 * @return
	 */
	public static List getDateList(Timestamp selTermFrom, Timestamp selTermTo, String term, String period, String timestampStr, String calculValStr) {
		List dateList = new ArrayList();
		
		Timestamp tmsp = selTermFrom;
		int cnt = 0;
		
		while(tmsp.getTime() <= selTermTo.getTime()) {
			Map<String, Object> dateMap = new HashMap<String, Object>();
			dateMap.put(timestampStr, tmsp);
			dateMap.put(calculValStr, "");
			dateList.add(dateMap);
			cnt++;
			
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(   tmsp.getTime()   );
			
			if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
			else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
			else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
			else if("day".equals(period)) cal.add(Calendar.DATE, 1);
			else if("month".equals(period)) cal.add(Calendar.MONTH, 1);
			
			tmsp = new Timestamp(cal.getTime().getTime());
		}
		
		return dateList;
	}

	/**
	 * 날짜리스트와 데이터리스트를 매칭시킨다
	 * @param dateList
	 * @param reDataList
	 * @param calculValStr 
	 * @param timestampStr 
	 * @return
	 */
	private static List matchingLists(List dateList, List reDataList, String timestampStr, String calculValStr) {
		List finalDataList = new ArrayList();
		
		for(int i=0; i<dateList.size(); i++) {
			Map<String, Object> dateMap = (Map<String, Object>) dateList.get(i);
			Map<String, Object> dataMap = (Map<String, Object>) reDataList.get(i);
			
			Map<String, Object> newDataMap = new HashMap<String, Object>();
			Iterator<String> paramKeys = dateMap.keySet().iterator();
			while (paramKeys.hasNext()) {
				String name = paramKeys.next();
				newDataMap.put(name, dateMap.get(name));
				if(name.equals(calculValStr)) newDataMap.put(calculValStr, dataMap.get(name)); 
			}
			finalDataList.add(newDataMap);
			
		}
		
		return finalDataList;
	}
	
}
