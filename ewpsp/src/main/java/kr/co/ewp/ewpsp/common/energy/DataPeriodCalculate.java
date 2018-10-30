package kr.co.ewp.ewpsp.common.energy;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DataPeriodCalculate {

	private static final Logger logger = LoggerFactory.getLogger(PeriodDataSetting.class);

	/**
	 * 그래프영역 데이터조합
	 * @param resultList
	 * @param selTermFrom
	 * @param selTermTo
	 * @param term
	 * @param period
	 * @param timestampStr
	 * @param calculValStr
	 * @param flag
	 * @return
	 */
	public static List periodCalculate(List resultList, Timestamp selTermFrom, Timestamp selTermTo, 
			String term, String period, String timestampStr, String calculValStr, int flag) {
		List newList = new ArrayList();
		Timestamp endListDt = null;
		
		int calculCnt = sumCntSet(term, period, flag); // for문 루프 횟수 구하기
		
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		List list = null; // 무조건 15분간격 데이터가 존재
		// 예측데이터면 15분 간격으로 쪼갠다..
		if( flag == 2 ) { // 예측
			list = divisionDate15min(resultList, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag);
		} else { // 실제
			list = resultList;
		}
		
		// 조회한 목록의 길이만큼 for문을 돌리면서 데이터를 조합하여 새로운 list에 넣는다
		dataMap = dataCombination(list, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag, calculCnt);
		
		newList = (List) dataMap.get("newList");
		endListDt = (Timestamp) dataMap.get("endListDt");
		
		// 마무리
		List newList2 = finishPeriodCalculate(newList,  term, period, selTermTo, timestampStr, calculValStr, endListDt);
		
		return newList2;
	}

	/**
	 * 예측 데이터 변환(무조건 15분 간격으로 쪼갠다)
	 * @param dataList
	 * @param selTermFrom
	 * @param selTermTo
	 * @param term
	 * @param period
	 * @param timestampStr
	 * @param calculValStr
	 * @param flag
	 * @return
	 */
	private static List divisionDate15min(List dataList, Timestamp selTermFrom, Timestamp selTermTo,
		String term, String period, String timestampStr, String calculValStr, int flag) {
		List newList = new ArrayList();
		
		for(int i=0; i<dataList.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) dataList.get(i);
			Timestamp tmp = (Timestamp) map.get(timestampStr);
			
			Timestamp strTm = tmp; // 증가시킬 timestamp
			for(int j=0; j<4; j++) {
				Map<String, Object> calculMap = new HashMap<String, Object>();
				Iterator<String> paramKeys = map.keySet().iterator();
				while (paramKeys.hasNext()) {
					String name = paramKeys.next();
					calculMap.put(name, map.get(name));
					if(name.equals(timestampStr)) {
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   strTm.getTime()   );
						if(j > 0) { // j==0 은 정시이기 때문에 증가X
							cal.add(Calendar.MINUTE, 15);
						}
						strTm = new Timestamp(cal.getTime().getTime());
						calculMap.put(timestampStr, strTm);
						
					} else if(name.equals(calculValStr)) {
						long divideNum = 0;
						
						if(map.get(calculValStr) instanceof Double) {
							divideNum =  Math.round( (Double) map.get(calculValStr) );
						} else {
							divideNum = Long.parseLong(String.valueOf(map.get(calculValStr)));
						}
						
						if( divideNum == 0 ) {
							calculMap.put(calculValStr, 0);
						} else {
							long devNum = divideNum/4;
							calculMap.put(calculValStr, devNum); // calculCnt로 나눈 값
						}
					}
				}
				newList.add(calculMap);
				
			}
			
		}
		
		return newList;
	}

	/**
	 * 조회한 목록의 길이만큼 for문을 돌리면서 데이터를 조합하여 새로운 list에 넣는다
	 * @param dataList
	 * @param selTermFrom
	 * @param selTermTo
	 * @param term
	 * @param period
	 * @param timestampStr
	 * @param calculValStr
	 * @param flag
	 * @param calculCnt
	 * @return
	 */
	private static Map<String, Object> dataCombination(List dataList, Timestamp selTermFrom, Timestamp selTermTo, String term,
			String period, String timestampStr, String calculValStr, int flag, int calculCnt) {
		List newList = new ArrayList();
		
		int nullCnt = 0;
		int chkCnt = 1;
		Timestamp stdTimestamp = null;
		long calculNum = 0;
		Timestamp incStartDt = selTermFrom;
		Timestamp endListDt = null;
		
		for(int i=0; i<dataList.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) dataList.get(i);
			Timestamp tmp = null;
			tmp = ((Timestamp) map.get(timestampStr));
			
			if( !incStartDt.equals(tmp) ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
				while( incStartDt.getTime() < tmp.getTime() ) {
					nullCnt++; // 더하지 않고 null count를 올린다..
					if(chkCnt == 1) {
						stdTimestamp = incStartDt;
					}
					
					if("month".equals(period)) {
						Calendar compareCal = Calendar.getInstance();
						compareCal.setTimeInMillis(   incStartDt.getTime()   );
						compareCal.add(Calendar.MINUTE, 15);
						int next = new Timestamp(compareCal.getTime().getTime()).getMonth();
						int now = incStartDt.getMonth();
						if(now != next || i+1 == dataList.size()) { // 다음날짜가 달이 바뀌거나 마지막데이터일 때
							Map<String, Object> calculMap = new HashMap<String, Object>();
							Iterator<String> paramKeys = map.keySet().iterator();
							while (paramKeys.hasNext()) {
								String name = paramKeys.next();
								calculMap.put(name, map.get(name));
								if(name.equals(timestampStr)) {
									calculMap.put(timestampStr, stdTimestamp);
								}
								else if(name.equals(calculValStr)) {
									if(nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우 
									else calculMap.put(calculValStr, calculNum);
								}
							}
							chkCnt = 0;
							nullCnt = 0;
							calculNum = 0;
							newList.add(calculMap);
							
							endListDt = stdTimestamp;
							
						}
						
					} else {
						if(chkCnt == calculCnt || i+1 == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
							Map<String, Object> calculMap = new HashMap<String, Object>();
							Iterator<String> paramKeys = map.keySet().iterator();
							while (paramKeys.hasNext()) {
								String name = paramKeys.next();
								calculMap.put(name, map.get(name));
								if(name.equals(timestampStr)) {
									calculMap.put(timestampStr, stdTimestamp);
								}
								else if(name.equals(calculValStr)) {
									if(nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우 
									else calculMap.put(calculValStr, calculNum);
								}
							}
							chkCnt = 0;
							nullCnt = 0;
							calculNum = 0;
							newList.add(calculMap);
							
							endListDt = stdTimestamp;
							
						}
					}
					
					Calendar cal = Calendar.getInstance();
					cal.setTimeInMillis(   incStartDt.getTime()   );
					cal.add(Calendar.MINUTE, 15);
					incStartDt = new Timestamp(cal.getTime().getTime());
					
					chkCnt++;
					
				}
				
			}
			
			if(map.get(calculValStr) != null) {
//				자료형 확인 : (map.get(calculValStr)).getClass().getName()
				if(map.get(calculValStr) instanceof Double) {
					calculNum = calculNum + Math.round( (Double) map.get(calculValStr) );
				} else if(map.get(calculValStr) instanceof Float) {
					calculNum = calculNum + Math.round( (Float) map.get(calculValStr) );
				} else {
					calculNum = calculNum + Long.parseLong(String.valueOf(map.get(calculValStr)));
				}
			}
			
			if(chkCnt == 1) {
				stdTimestamp = incStartDt;
			}
			
			if("month".equals(period)) {
				Calendar compareCal = Calendar.getInstance();
				compareCal.setTimeInMillis(   incStartDt.getTime()   );
				compareCal.add(Calendar.MINUTE, 15);
				int next = new Timestamp(compareCal.getTime().getTime()).getMonth();
				int now = incStartDt.getMonth();
				if(now != next || i+1 == dataList.size()) { // 다음날짜가 달이 바뀌거나 마지막데이터일 때
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if(name.equals(timestampStr)) calculMap.put(timestampStr, stdTimestamp);
						else if(name.equals(calculValStr)) {
							if(nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우 
							else calculMap.put(calculValStr, calculNum);
						}
					}
					chkCnt = 0;
					nullCnt = 0;
					calculNum = 0;
					newList.add(calculMap);
					endListDt = stdTimestamp;
					
				}
				
			} else {
				if(chkCnt == calculCnt || i+1 == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if(name.equals(timestampStr)) calculMap.put(timestampStr, stdTimestamp);
						else if(name.equals(calculValStr)) {
							if(nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우 
							else calculMap.put(calculValStr, calculNum);
						}
					}
					chkCnt = 0;
					nullCnt = 0;
					calculNum = 0;
					newList.add(calculMap);
					endListDt = stdTimestamp;
					
				}
			}
			
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(   incStartDt.getTime()   );
			cal.add(Calendar.MINUTE, 15);
			incStartDt = new Timestamp(cal.getTime().getTime());
			
			chkCnt++;
			
		}
		
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("newList", newList);
		dataMap.put("endListDt", endListDt);
		
		return dataMap;
	}

	private static List finishPeriodCalculate(List newList, String term, String period, Timestamp selTermTo, String timestampStr, String calculValStr, Timestamp endListDt) {
		List list = newList;
		int cnt = 0;
		
		if(!endListDt.equals(selTermTo)) {
			Timestamp tmsp = endListDt;

			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(   tmsp.getTime()   );
			
			if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
			else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
			else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
			else if("day".equals(period)) cal.add(Calendar.DATE, 1);
			else if("month".equals(period)) cal.add(Calendar.MONTH, 1);
			
			tmsp = new Timestamp(cal.getTime().getTime());
			while(tmsp.getTime() <= selTermTo.getTime()) {
				Map<String, Object> dateMap = new HashMap<String, Object>();
				dateMap.put(timestampStr, tmsp);
				dateMap.put(calculValStr, null);
				list.add(dateMap);
				cnt++;
				
				Calendar cal2 = Calendar.getInstance();
				cal2.setTimeInMillis(   tmsp.getTime()   );
				
				if("15min".equals(period)) cal2.add(Calendar.MINUTE, 15);
				else if("30min".equals(period)) cal2.add(Calendar.MINUTE, 30);
				else if("hour".equals(period)) cal2.add(Calendar.HOUR, 1);
				else if("day".equals(period)) cal2.add(Calendar.DATE, 1);
				else if("month".equals(period)) cal2.add(Calendar.MONTH, 1);
				
				tmsp = new Timestamp(cal2.getTime().getTime());
			}
			
		}
		
		return list;
		
	}

	/**
	 * 계산(더하기)할 횟수 구하기
	 * @param term
	 * @param period
	 * @return
	 */
	public static int sumCntSet(String term, String period, int flag) {
		// 실제의 경우 데이터간격의 최소단위가 15분이므로 조회 시 데이터간격이 30분 이상이면 합을 구한다
		int sumCntPast = 0;
		
		if("15min".equals(period)) {
			sumCntPast = 1;
		} else if("30min".equals(period)) {
			sumCntPast = 2;
		} else if("hour".equals(period)) {
			sumCntPast = 4;
		} else if("day".equals(period)) {
			sumCntPast = 96;
		} else if("month".equals(period)) {
			sumCntPast = 96*30;
		}
		
		return sumCntPast;
		
	}
	
}
