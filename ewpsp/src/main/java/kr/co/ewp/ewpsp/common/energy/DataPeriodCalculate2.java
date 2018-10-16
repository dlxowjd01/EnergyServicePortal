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

public class DataPeriodCalculate2 {

	private static final Logger logger = LoggerFactory.getLogger(PeriodDataSetting.class);

	public static List periodCalculate(List dataList, Timestamp selTermFrom, Timestamp selTermTo, 
			String term, String period, String timestampStr, String calculValStr, int flag) {
		logger.debug("DataPeriodCalculate.periodCalculate()");
		List newList = new ArrayList();
		
		int calculCnt = sumCntSet(term, period, flag);
		
		int nullCnt = 0;
		int chkCnt = 1;
		Timestamp stdTimestamp = null;
		BigDecimal calculNum = new BigDecimal(0);
		Timestamp incStartDt = selTermFrom;
		Timestamp endListDt = null;
		
		// 조회한 목록의 길이만큼 for문을 돌리면서 데이터를 조합하여 새로운 list에 넣는다
		for(int i=0; i<dataList.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) dataList.get(i);
			System.out.println(i+"번째 (Timestamp) map.get(timestampStr) : "+(Timestamp) map.get(timestampStr));
			
			if( ("15min".equals(period) && flag == 1) || ("hour".equals(period) && flag == 2) ) { // 실제 15분간격 or 예측 1시간간격
				System.out.println("0");
				
				if( !incStartDt.equals(((Timestamp) map.get(timestampStr))) ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
					while( !incStartDt.equals(((Timestamp) map.get(timestampStr))) ) {
						System.out.println("1");
						System.out.println("여기오지? "+incStartDt+", "+((Timestamp) map.get(timestampStr))+", "+(incStartDt != ((Timestamp) map.get(timestampStr)))+", "+(!incStartDt.equals(((Timestamp) map.get(timestampStr)))));
						Map<String, Object> calculMap = new HashMap<String, Object>();
						Iterator<String> paramKeys = map.keySet().iterator();
						while (paramKeys.hasNext()) {
							String name = paramKeys.next();
							calculMap.put(name, map.get(name));
							if(name.equals(timestampStr)) calculMap.put(timestampStr, incStartDt);
							else if(name.equals(calculValStr)) calculMap.put(calculValStr, null); 
						}
						newList.add(calculMap);
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   incStartDt.getTime()   );
						if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
						else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
						incStartDt = new Timestamp(cal.getTime().getTime());
						
//						if( incStartDt == ((Timestamp) map.get(timestampStr)) )
//							break;
					}
				}
				if(i+1 == dataList.size()) {
					endListDt = incStartDt;
				}
				
				System.out.println("2");
				newList.add(map);

				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(   incStartDt.getTime()   );
				if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
				else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
				incStartDt = new Timestamp(cal.getTime().getTime());

			} else if( ("15min".equals(period) && flag == 2) || ("30min".equals(period) && flag == 2) ) { // 예측 15분간격 or 예측 30분간격
				System.out.println("3");
				
				if( !incStartDt.equals(((Timestamp) map.get(timestampStr))) ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
					while( !incStartDt.equals(((Timestamp) map.get(timestampStr))) ) {
						System.out.println("4");
						Map<String, Object> calculMap = new HashMap<String, Object>();
						Iterator<String> paramKeys = map.keySet().iterator();
						while (paramKeys.hasNext()) {
							String name = paramKeys.next();
							calculMap.put(name, map.get(name));
							if(name.equals(timestampStr)) calculMap.put(timestampStr, incStartDt);
							else if(name.equals(calculValStr)) calculMap.put(calculValStr, null); 
						}
						newList.add(calculMap);
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   incStartDt.getTime()   );
						if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
						else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
						incStartDt = new Timestamp(cal.getTime().getTime());
						
//						if( incStartDt == ((Timestamp) map.get(timestampStr)) )
//							break;
					}
				}
				
				System.out.println("5");
				Timestamp strTm = (Timestamp) map.get(timestampStr); // 증가시킬 timestamp
				// 계산해야하는 횟수만큼 for문 실행
				for(int j=0; j<calculCnt; j++) {
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if(name.equals(timestampStr)) {
							Calendar cal = Calendar.getInstance();
							cal.setTimeInMillis(   strTm.getTime()   );
							if(j > 0) { // j==0 은 정시이기 때문에 증가X
								if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
								else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
							}
							calculMap.put(timestampStr, cal.getTime());
							strTm = new Timestamp(cal.getTime().getTime());
						} else if(name.equals(calculValStr)) {
							BigDecimal divideNum = new BigDecimal(  String.valueOf(map.get(calculValStr))  );
							if( divideNum.compareTo(BigDecimal.ZERO) == 0 ) { // compareTo :::: -1은 작다, 0은 같다, 1은 크다
								calculMap.put(calculValStr, 0);
							} else {
								BigDecimal devNum = divideNum.divide( new BigDecimal(calculCnt), 2, BigDecimal.ROUND_UP); // calculCnt로 나누기, 반올림해서 소수점 둘째자리까지 보여준다.
								calculMap.put(calculValStr, devNum); // calculCnt로 나눈 값
							}
						}
					}
					if( !("30min".equals(term) && j>=2) ) { // 예측 30분간격은 두개만 보여줘야한다
						newList.add(calculMap);
					}
				}
				
				if(i+1 == dataList.size()) {
					endListDt = incStartDt;
				}

				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(   incStartDt.getTime()   );
				if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
				else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
				incStartDt = new Timestamp(cal.getTime().getTime());
				
			} else {
				System.out.println(" 맞지hh?");
				System.out.println("여기오지? "+incStartDt+", "+((Timestamp) map.get(timestampStr))+", "+(incStartDt != ((Timestamp) map.get(timestampStr)))+", "+(!incStartDt.equals(((Timestamp) map.get(timestampStr)))));
//				if( incStartDt != ((Timestamp) map.get(timestampStr)) ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
				Timestamp tmp = null;
				tmp = ((Timestamp) map.get(timestampStr));
				if( !incStartDt.equals(tmp) ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
					while( !incStartDt.equals(tmp) ) {
						System.out.println("뭐야? "+incStartDt+", "+((Timestamp) map.get(timestampStr))+", "+tmp);
						nullCnt++; // 더하지 않고 null count를 올린다..
						if(chkCnt == 1) {
							stdTimestamp = incStartDt;
						} else if(chkCnt == calculCnt || i+1 == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
							map.put(timestampStr, stdTimestamp);
							if(nullCnt == chkCnt) map.put(calculValStr, null); // 더한게 모두 null일 경우 
							else map.put(calculValStr, calculNum);
							chkCnt = 0;
							nullCnt = 0;
							calculNum = new BigDecimal(0);
							newList.add(map);
							endListDt = incStartDt;
						}
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   incStartDt.getTime()   );
						if(flag == 1) cal.add(Calendar.MINUTE, 15);
						else if(flag == 2) cal.add(Calendar.HOUR, 1);
						incStartDt = new Timestamp(cal.getTime().getTime());
						
						chkCnt++;

//						if( incStartDt == ((Timestamp) map.get(timestampStr)) )
//							break;
					}
					System.out.println("루프?");
				}
				
				System.out.println("값은? "+String.valueOf(map.get(calculValStr)+", "+map.toString()));
				calculNum = calculNum.add(  new BigDecimal(  String.valueOf(map.get(calculValStr))  )  );
				if(chkCnt == 1) {
//					stdTimestamp = new Timestamp( ((Timestamp) map.get(timestampStr)).getTime() );
					stdTimestamp = incStartDt;
				} else if(chkCnt == calculCnt || i+1 == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
					map.put(timestampStr, stdTimestamp);
					map.put(calculValStr, calculNum);
					chkCnt = 0;
					nullCnt = 0;
					calculNum = new BigDecimal(0);
					newList.add(map);
					endListDt = incStartDt; 
				}

				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(   incStartDt.getTime()   );
				if(flag == 1) cal.add(Calendar.MINUTE, 15);
				else if(flag == 2) cal.add(Calendar.HOUR, 1);
				incStartDt = new Timestamp(cal.getTime().getTime());
				
				chkCnt++;
				
			}
			
		}
		
		System.out.println("중간점검 : "+newList.size()+", "+newList.toString());
		
		List newList2 = finishPeriodCalculate(newList,  term, period, selTermTo, endListDt, timestampStr, calculValStr);
		
		return newList;
	}

	private static List finishPeriodCalculate(List newList, String term, String period, Timestamp selTermTo, Timestamp endListDt, String timestampStr, String calculValStr) {
		List list = newList;
		int cnt = 0;
		
		System.out.println("마지막이야  "+endListDt.equals(selTermTo)); 
		if(!endListDt.equals(selTermTo)) {
			Timestamp tmsp = endListDt;
			
			while(tmsp.getTime() < selTermTo.getTime()) {
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(   tmsp.getTime()   );
				
				if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
				else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
				else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
				else if("day".equals(period)) cal.add(Calendar.DATE, 1);
				else if("month".equals(period)) cal.add(Calendar.MONTH, 1);
				
				tmsp = new Timestamp(cal.getTime().getTime());
				
				Map<String, Object> dateMap = new HashMap<String, Object>();
				dateMap.put(timestampStr, tmsp);
				dateMap.put(calculValStr, null);
				list.add(dateMap);
				cnt++;
				
			}
			
		}
		
		return list;
		
	}

	/**
	 * 계산(더하거나 나누거나)할 횟수 구하기
	 * @param term
	 * @param period
	 * @return
	 */
	public static int sumCntSet(String term, String period, int flag) {
		logger.debug("function sumCntSet()");
		
		// 실제의 경우 데이터간격의 최소단위가 15분이므로 조회 시 데이터간격이 30분 이상이면 합을 구한다
		int sumCntPast = 0;
		
		// 예측의 경우 데이터간격의 최소단위가 1시간이므로 조회 시 데이터간격이 15분이나 30분일 경우 나누고
		// 1일 이상인 경우 합을 구한다
		int sumCntFeture = 0;
		
		if("15min".equals(period)) {
			sumCntFeture = 4; // 4개로 나눈다
		} else if("30min".equals(period)) {
			sumCntPast = 2;
			sumCntFeture = 2; // 2개로 나눈다
		} else if("hour".equals(period)) {
			sumCntPast = 4;
		} else if("day".equals(period)) {
			sumCntPast = 96;
			sumCntFeture = 24;
		} else if("month".equals(period)) {
			sumCntPast = 96*30;
			sumCntFeture = 24*30;
		}
		
		if(flag == 1) {
			return sumCntPast;
		} else {
			return sumCntFeture;
		}
		
	}
	
}
