package kr.co.ewp.ewpsp.common.billRevenue;

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

public class BillRevenueDataSetting {

	private static final Logger logger = LoggerFactory.getLogger(BillRevenueDataSetting.class);

	/**
	 * 조회간격에 따라 데이터를 조합하여 셋팅
	 * @param param : 검색조건
	 * @param dataList : db 데이터
	 * @param timestampStr : 계산기준 컬럼명
	 * @param calculValStr : 계산에 사용될 컬럼명
	 * @param flag : 1:실제(15min), 2:예측(hour)
	 * @return
	 */
	public static Map dataSetting(HashMap param, List dataList, String timestampStr) {
		logger.debug("PeriodDataSetting.dataSetting()");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String term = (String) param.get("selTerm"); // 조회기간
		String period = (String) param.get("selPeriodVal"); // 데이터조회간격
		String startDate = (String) param.get("selTermFrom"); //getStartEndTimestamp((String) param.get("selTermFrom"), "1"); // 검색시작일(그래프영역)
		String endDate = (String) param.get("selTermTo"); // getStartEndTimestamp((String) param.get("selTermTo"), "2"); // 검색종료일(그래프영역)
		String selTermFrom = getConvertStartEndTmsp( term, period, (String) param.get("selTermFrom") , "1"); // 검색시작일(표영역)
		String selTermTo = getConvertStartEndTmsp( term, period, (String) param.get("selTermTo") , "2"); // 검색종료일(표영역)
		
		System.out.println(selTermFrom+", "+selTermTo+", "+term+", "+period+", "+startDate+", "+endDate);
		
		// 날짜리스트 생성
		List sheetDateList = getDateList(selTermFrom, selTermTo, term, period, timestampStr); // 표영역
		
		// 날짜리스트+데이터조합 매칭
		List sheetList = matchingLists(sheetDateList, dataList, timestampStr); // 표영역
		System.out.println("sheetList     ======>   "+sheetList.toString());
		
		map.put("sheetList", sheetList);
		
		return map;
	}
	
	/**
	 * 표영역 검색일자 변환(분단위를 00, 15, 30, 45중 하나로 맞추고 timestamp로 리턴)
	 * @param timestamp 정리할 검색일자
	 * @param flag 시작일자:1, 종료일자:2
	 * @return
	 */
	public static String getConvertStartEndTmsp(String term, String period, String timestamp, String flag) {
		String yyyy = timestamp.substring(0, 4);
		String yyyyMM = "";
		
		if("1".equals(flag)) {
			yyyyMM = yyyy+"01";
		} else if("2".equals(flag)) {
			yyyyMM = yyyy+"12";
		}
		
		return yyyyMM;
		
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
	public static List getDateList(String selTermFrom, String selTermTo, String term, String period, String timestampStr) {
		List dateList = new ArrayList();
		
		String tmsp = selTermFrom;
		int cnt = 0;
		String yyyy = tmsp.substring(0, 4);
		String mm = tmsp.substring(4, 6);
		
		while(Integer.parseInt(yyyy+mm) <= Integer.parseInt(selTermTo)) {
//			System.out.println(tmsp+", "+yyyy+mm+", "+selTermTo);
			Map<String, Object> dateMap = new HashMap<String, Object>();
			dateMap.put(timestampStr, yyyy+mm);
//			dateMap.put(calculValStr, "");
			dateList.add(dateMap);
			cnt++;
			
			String mm2 = Integer.toString(Integer.parseInt(mm)+1);
			mm = ( mm2.length() == 1) ? "0"+mm2 : mm2; 
			if(Integer.parseInt(mm) == 13) {
				mm = "01";
				yyyy = Integer.toString(Integer.parseInt(yyyy)+1);
			}
		}
		
		System.out.println("날짜리스트는 => "+dateList.toString());
		
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
	private static List matchingLists(List dateList, List reDataList, String timestampStr) {
		List finalDataList = new ArrayList();
//		System.out.println("사이즈는? "+dateList.size()+", "+reDataList.size());
		Map<String, Object> dtMap = (Map<String, Object>) reDataList.get(0);
		Map<String, Object> nullMap = new HashMap<String, Object>();
		Iterator<String> keys = dtMap.keySet().iterator();
		while (keys.hasNext()) {
			String name = keys.next();
			nullMap.put(name, null);
		}
		
		
		for(int i=0; i<dateList.size(); i++) {
			Map<String, Object> dateMap = (Map<String, Object>) dateList.get(i);
			String str1 = (String) dateMap.get(timestampStr);
			boolean flag = false;
			
			for(int j=0; j<reDataList.size(); j++) {
				Map<String, Object> map = (Map<String, Object>) reDataList.get(j);
				String str2 = (String) map.get(timestampStr);
				if(str1.equals(str2)) {
					Map<String, Object> newDataMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						newDataMap.put(name, map.get(name));
					}
					finalDataList.add(newDataMap);
					flag = true;
				}
				
			}
			System.out.println(nullMap.get(timestampStr)+", "+str1);
			if(!flag) {
				Map<String, Object> newDataMap = new HashMap<String, Object>();
				Iterator<String> paramKeys = nullMap.keySet().iterator();
				while (paramKeys.hasNext()) {
					String name = paramKeys.next();
					newDataMap.put(name, null);
				}
				newDataMap.put(timestampStr, str1);
				System.out.println("ggg  "+newDataMap.get(timestampStr)+", "+str1);
				finalDataList.add(newDataMap);
			}
			System.out.println("         "+finalDataList.toString());
			
		}
		
		return finalDataList;
	}
	
}
