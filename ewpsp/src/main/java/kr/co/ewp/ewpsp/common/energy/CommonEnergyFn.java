package kr.co.ewp.ewpsp.common.energy;

import java.math.BigDecimal;
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

import kr.co.ewp.ewpsp.web.UsageController;

public class CommonEnergyFn {

	private static final Logger logger = LoggerFactory.getLogger(UsageController.class);

	/**
	 * 데이터 조회간격에 따른 데이터 조합
	 * @param param :  검색조건
	 * @param resultList : db에서 조회한 목록
	 * @param timestampStr : 기준 시각
	 * @param calculValStr : 합을 계산할 컬럼명
	 * @param flag : 1:실제(15min), 2:예측(hour)
	 * @return
	 */
	public static List periodSet(HashMap param, List resultList, String timestampStr, String calculValStr, int flag) {
		logger.debug("function periodSet()");
		
		String term = (String) param.get("selTerm"); // 조회기간
		String period = (String) param.get("selPeriodVal"); // 데이터조회간격
		
		String str = "";
		if("std_date".equals(timestampStr)) str = "";
		
		int calculCnt = sumCntSet(term, period, flag);
		String selTermFrom = getStartEndTimestamp( (String) param.get("selTermFrom") , "1"); // 검색시작일
		String selTermTo = getStartEndTimestamp( (String) param.get("selTermTo") , "2"); // 검색종료일
		
		String incStartDt = selTermFrom;
//		String EndDt = ;
		int forCnt = getForCnt(selTermFrom, selTermTo, flag); // for문 루프 횟수 구하기
		
		
		// 조회한 목록의 길이만큼 for문을 돌리면서 col_cnt만큼 값을 더하여 새로운 list에 넣는다
		List frsList = new ArrayList();
		int chkCnt = 1;
		Timestamp stdTimestamp = null;
		BigDecimal calculNum = new BigDecimal(0);
		int nullCnt = 0;
		
		// 조회한 목록만큼 for문 실행
		for(int i=0; i<resultList.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) resultList.get(i);
			
			if( ("15min".equals(period) && flag == 1) || ("hour".equals(period) && flag == 2) ) { // 실제 15분간격 or 예측 1시간간격
				if( Long.parseLong(incStartDt) != ((Timestamp) map.get(timestampStr)).getTime() ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
					while( Long.parseLong(incStartDt) == ((Timestamp) map.get(timestampStr)).getTime() ) {
						Map<String, Object> calculMap = new HashMap<String, Object>();
						Iterator<String> paramKeys = map.keySet().iterator();
						while (paramKeys.hasNext()) {
							String name = paramKeys.next();
							calculMap.put(name, map.get(name));
							if(name.equals(timestampStr)) {
								calculMap.put(timestampStr, new Timestamp(Long.parseLong(incStartDt)));
							} else if(name.equals(calculValStr)) {
								calculMap.put(calculValStr, null); 
							}
						}
						frsList.add(calculMap);
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
						
						if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
						else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
						
						incStartDt = String.valueOf(  cal.getTime().getTime()  );
						
					}
				}
				
				frsList.add(map);
				
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
				
				if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
				else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
				
				incStartDt = String.valueOf(  cal.getTime().getTime()  );
				
			} else if( ("15min".equals(period) && flag == 2) || ("30min".equals(period) && flag == 2) ) { // 예측 15분간격 or 예측 30분간격
				if( Long.parseLong(incStartDt) != ((Timestamp) map.get(timestampStr)).getTime() ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
					while( Long.parseLong(incStartDt) == ((Timestamp) map.get(timestampStr)).getTime() ) {
						Map<String, Object> calculMap = new HashMap<String, Object>();
						Iterator<String> paramKeys = map.keySet().iterator();
						while (paramKeys.hasNext()) {
							String name = paramKeys.next();
							calculMap.put(name, map.get(name));
							if(name.equals(timestampStr)) {
								calculMap.put(timestampStr, new Timestamp(Long.parseLong(incStartDt)));
							} else if(name.equals(calculValStr)) {
								calculMap.put(calculValStr, null); 
							}
						}
						frsList.add(calculMap);
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
						
						if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
						else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
						
						incStartDt = String.valueOf(  cal.getTime().getTime()  );
						
					}
				}
				
				String strTm = Long.toString(((Timestamp) map.get(timestampStr)).getTime()); // 증가시킬 timestamp
				
				// 계산해야하는 횟수만큼 for문 실행
				for(int j=0; j<calculCnt; j++) {
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if(name.equals(timestampStr)) {
							Calendar cal = Calendar.getInstance();
							cal.setTimeInMillis(   Long.parseLong(strTm)   );
							if(j > 0) { // j==0 은 정시이기 때문에 증가X
								if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
								else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
							}
							calculMap.put(timestampStr, cal.getTime());
							strTm = String.valueOf(  cal.getTime().getTime()  );
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
						frsList.add(calculMap);
					}
					
				}
				
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
				
				if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
				else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
				
				incStartDt = String.valueOf(  cal.getTime().getTime()  );
				
			} else {
				if( Long.parseLong(incStartDt) != ((Timestamp) map.get(timestampStr)).getTime() ) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
					
					while( Long.parseLong(incStartDt) == ((Timestamp) map.get(timestampStr)).getTime() ) {
						nullCnt++; // 더하지 않고 null count를 올린다..
						if(chkCnt == 1) {
							stdTimestamp = new Timestamp( Long.parseLong(incStartDt) );
						} else if(chkCnt == calculCnt) {
							map.put(timestampStr, stdTimestamp);
							if(nullCnt == chkCnt) map.put(calculValStr, null); // 더한게 모두 null일 경우 
							else map.put(calculValStr, calculNum);
							chkCnt = 0;
							nullCnt = 0;
							calculNum = new BigDecimal(0);
							frsList.add(map);
						}
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
						
						if(flag == 1) cal.add(Calendar.MINUTE, 15);
						else if(flag == 2) cal.add(Calendar.HOUR, 1);
						
						incStartDt = String.valueOf(  cal.getTime().getTime()  );
						
						chkCnt++;
					}
					
				}
				
				calculNum = calculNum.add(  new BigDecimal(  String.valueOf(map.get(calculValStr))  )  );
				if(chkCnt == 1) {
					stdTimestamp = new Timestamp( ((Timestamp) map.get(timestampStr)).getTime() );
				} else if(chkCnt == calculCnt) {
					map.put(timestampStr, stdTimestamp);
					map.put(calculValStr, calculNum);
					chkCnt = 0;
					calculNum = new BigDecimal(0);
					frsList.add(map);
				}
				
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
				
				if(flag == 1) cal.add(Calendar.MINUTE, 15);
				else if(flag == 2) cal.add(Calendar.HOUR, 1);
				
				incStartDt = String.valueOf(  cal.getTime().getTime()  );
				
				chkCnt++;
				
			}
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// for문 마지막인데 지정된 루프횟수를 다 못채웠을때
			if( i==resultList.size()-1 && resultList.size()<forCnt ) {
				for(int k=i+1; k<forCnt; k++) {
					if( ("15min".equals(period) && flag == 1) || ("hour".equals(period) && flag == 2) ||   // 실제 15분간격 or 예측 1시간간격
							("15min".equals(period) && flag == 2) || ("30min".equals(period) && flag == 2)  // 예측 15분간격 or 예측 30분간격
							) {
						
						Map<String, Object> calculMap = new HashMap<String, Object>();
						Iterator<String> paramKeys = map.keySet().iterator();
						while (paramKeys.hasNext()) {
							String name = paramKeys.next();
							calculMap.put(name, map.get(name));
							if(name.equals(timestampStr)) {
								calculMap.put(timestampStr, new Timestamp(Long.parseLong(incStartDt)));
							} else if(name.equals(calculValStr)) {
								calculMap.put(calculValStr, null); 
							}
						}
						frsList.add(calculMap);
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
						if("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
						else if("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
						else if("hour".equals(period)) cal.add(Calendar.HOUR, 1);
						incStartDt = String.valueOf(  cal.getTime().getTime()  );
						
					} else {
						Map<String, Object> calculMap = new HashMap<String, Object>();
						nullCnt++; // 더하지 않고 null count를 올린다..
						if(chkCnt == 1) {
							stdTimestamp = new Timestamp( Long.parseLong(incStartDt) );
						} else if(chkCnt == calculCnt) {
							calculMap.put(timestampStr, stdTimestamp);
							if(nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우 
							else calculMap.put(calculValStr, calculNum);
							chkCnt = 0;
							nullCnt = 0;
							calculNum = new BigDecimal(0);
							frsList.add(calculMap);
						}
						
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(   Long.parseLong(incStartDt)   );
						if(flag == 1) cal.add(Calendar.MINUTE, 15);
						else if(flag == 2) cal.add(Calendar.HOUR, 1);
						incStartDt = String.valueOf(  cal.getTime().getTime()  );
						
						chkCnt++;
						
					}
					
				}
			}
			
		}
		logger.debug("frsList : "+frsList.size()+", "+frsList.toString());
		
		return frsList;
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
	
	/**
	 * 검색일자 정리?
	 * @param timestamp 정리할 검색일자
	 * @param flag 시작일자:1, 종료일자:2
	 * @return
	 */
	public static String getStartEndTimestamp(String timestamp, String flag) {
		String reTimestamp = timestamp.substring(0, 4)+"-"+timestamp.substring(4, 6)+"-"+timestamp.substring(6, 8)+" "+timestamp.substring(8, 10)+":"+timestamp.substring(10, 12)+":"+timestamp.substring(12, 14);
		
		Timestamp tp = Timestamp.valueOf(reTimestamp);
		Date dt = new Date(tp.getTime());
		if(dt.getMinutes() == 0) {
			dt.setMinutes(0);
		}else if(dt.getMinutes()> 0 && dt.getMinutes() < 15) {
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
		
//		dt.setHours(dt.getHours()+9); // 고민해야함
		ZonedDateTime seoulDateTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));
		
		reTimestamp = String.valueOf( new Timestamp(dt.getTime()).getTime() );
		return reTimestamp;
	}
	
	/**
	 * for문 루프 횟수 구하기
	 * @param startDt(java.sql.timestamp)
	 * @param endDt(java.sql.timestamp)
	 * @param flag
	 * @return
	 */
	public static int getForCnt(String startDt, String endDt, int flag) {
		int sec = 0; //15 * 60 * 1000;
		if(flag == 1) sec = 15 * 60 * 1000; // 15분
		if(flag == 2) sec = 60 * 60 * 1000; // 1시간
		
		int returnCnt = (int) (( (new Timestamp( Long.parseLong(endDt) ).getTime() - new Timestamp( Long.parseLong(startDt) ).getTime())/sec )+1);
		
		return returnCnt;
	}
	
}
