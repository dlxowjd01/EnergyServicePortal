package kr.co.esp.energy;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.*;

public class DataPeriodCalculate {

	private static final Logger logger = LoggerFactory.getLogger(PeriodDataSetting.class);

	private static String offset = "";
	private static List<Map<String, Object>> dateList;
	private static int dateListTotCnt = 0;
	private static int dateListCnt = 0;

	/**
	 * 그래프영역 데이터조합
	 *
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
	public static List<Map<String, Object>> periodCalculate(HttpServletRequest request, List<Map<String, Object>> resultList, Timestamp selTermFrom, Timestamp selTermTo,
									   String term, String period, String timestampStr, String calculValStr, int flag, List<Map<String, Object>> emptyDateList) {
		logger.debug("DataPeriodCalculate.periodCalculate()");
		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();
		Timestamp endListDt = null;
//		offset = CommonUtils.getTimeOffset(request);
		offset = (String) request.getAttribute("timeOffset");
		dateList = emptyDateList;
		dateListTotCnt = dateList.size();

		int calculCnt = sumCntSet(term, period, flag); // for문 루프 횟수 구하기

		Map<String, Object> dataMap = new HashMap<String, Object>();

		List<Map<String, Object>> list = null; // 무조건 15분간격 데이터가 존재
		// 예측데이터면 15분 간격으로 쪼갠다..
		if (flag == 2) { // 예측
			list = divisionDate15min(resultList, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag);
		} else { // 실제
			list = resultList;
		}

		String energyGbn = (String) request.getAttribute("energyGbn");

		// 조회한 목록의 길이만큼 for문을 돌리면서 데이터를 조합하여 새로운 list에 넣는다
		if ("peak".equals(energyGbn)) {
			// 30분은 15분 최대 데이터 * 2
			// 1시간은 15분 최대 데이터 * 4
			// 1일 이상은 1시간 피크 * 24 * 일 개수
			dataMap = dataCombinationPeak(list, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag, calculCnt);
		} else {
			// 지정된 횟수만큼 데이터를 합한다
			// 월은 횟수가 아닌 날짜대로 더한다
			dataMap = dataCombination(list, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag, calculCnt);
		}

//		newList = (List<Map<String, Object>>) dataMap.get("newList");
//		endListDt = (Timestamp) dataMap.get("endListDt");

		// 마무리

//		List<Map<String, Object>> newList2 = new ArrayList<Map<String, Object>>();
//		if (endListDt != null) {
//			newList2 = finishPeriodCalculate(newList, term, period, selTermTo, timestampStr, calculValStr, endListDt);
//		}
		dateListCnt = 0; 

		//List newList2 = finishPeriodCalculate(newList,  term, period, selTermTo, timestampStr, calculValStr, endListDt);

//		return newList2;
		return dateList;
	}

	/**
	 * 예측 데이터 변환(무조건 15분 간격으로 쪼갠다)
	 *
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
	private static List<Map<String, Object>> divisionDate15min(List<Map<String, Object>> dataList, Timestamp selTermFrom, Timestamp selTermTo,
										  String term, String period, String timestampStr, String calculValStr, int flag) {
		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();

		for (int i = 0; i < dataList.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) dataList.get(i);
			Timestamp tmp = (Timestamp) map.get(timestampStr);

			Timestamp strTm = tmp; // 증가시킬 timestamp
			for (int j = 0; j < 4; j++) {
				Map<String, Object> calculMap = new HashMap<String, Object>();
				Iterator<String> paramKeys = map.keySet().iterator();
				while (paramKeys.hasNext()) {
					String name = paramKeys.next();
					calculMap.put(name, map.get(name));
					if (name.equals(timestampStr)) {
						Calendar cal = Calendar.getInstance();
						cal.setTimeInMillis(strTm.getTime());
						if (j > 0) { // j==0 은 정시이기 때문에 증가X
							cal.add(Calendar.MINUTE, 15);
						}
						strTm = new Timestamp(cal.getTime().getTime());
						calculMap.put(timestampStr, strTm);

					} else if (name.equals(calculValStr)) {
						long divideNum = 0;

						if (map.get(calculValStr) instanceof Double) {
							divideNum = Math.round((Double) map.get(calculValStr));
						} else {
							divideNum = Long.parseLong(String.valueOf(map.get(calculValStr)));
						}

						if (divideNum == 0) {
							calculMap.put(calculValStr, 0);
						} else {
							long devNum = divideNum / 4;
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
	 *
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
	private static Map<String, Object> dataCombination(List<Map<String, Object>> dataList, Timestamp selTermFrom, Timestamp selTermTo, String term,
													   String period, String timestampStr, String calculValStr, int flag, int calculCnt) {
		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();

		int cnt = 0;
		int nullCnt = 0;
		int chkCnt = 1;
		Timestamp stdTimestamp = null;
		long calculNum = 0;
		Timestamp incStartDt = selTermFrom;
		Timestamp endListDt = null;

		for (int i = 0; i < dataList.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) dataList.get(i);
			Timestamp tmp = null;
			tmp = ((Timestamp) map.get(timestampStr));

			if (!incStartDt.equals(tmp)) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
				while (incStartDt.getTime() < tmp.getTime()) {
					nullCnt++; // 더하지 않고 null count를 올린다..
					if (chkCnt == 1) {
						stdTimestamp = incStartDt;
					}

					if ("month".equals(period)) {
						boolean changeMonthYn = changeMonthYn(incStartDt);

						Calendar compareCal = Calendar.getInstance();
						compareCal.setTimeInMillis(incStartDt.getTime());
						compareCal.add(Calendar.MINUTE, Integer.parseInt(offset) * (-1)); // 로컬시간으로 변경
						compareCal.add(Calendar.MINUTE, 15);

//						if(now != next || i+1 == dataList.size()) {
						if (changeMonthYn == true || cnt == dataList.size()) {
							// 다음날짜가 달이 바뀌거나 마지막데이터일 때
							Map<String, Object> calculMap = new HashMap<String, Object>();
							Iterator<String> paramKeys = map.keySet().iterator();
							while (paramKeys.hasNext()) {
								String name = paramKeys.next();
								calculMap.put(name, map.get(name));
								if (name.equals(timestampStr)) {
									calculMap.put(timestampStr, stdTimestamp);
								} else if (name.equals(calculValStr)) {
									if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
									else calculMap.put(calculValStr, calculNum);
								}
							}
							chkCnt = 0;
							nullCnt = 0;
							calculNum = 0;
							newList.add(calculMap);
							if(dateListCnt == dateListTotCnt) break;
							matchList(calculMap, calculValStr);

							endListDt = stdTimestamp;

						}

					} else {
						if (chkCnt == calculCnt || cnt == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
							Map<String, Object> calculMap = new HashMap<String, Object>();
							Iterator<String> paramKeys = map.keySet().iterator();
							while (paramKeys.hasNext()) {
								String name = paramKeys.next();
								calculMap.put(name, map.get(name));
								if (name.equals(timestampStr)) {
									calculMap.put(timestampStr, stdTimestamp);
								} else if (name.equals(calculValStr)) {
									if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
									else calculMap.put(calculValStr, calculNum);
								}
							}
							chkCnt = 0;
							nullCnt = 0;
							calculNum = 0;
							newList.add(calculMap);
							if(dateListCnt == dateListTotCnt) break;
							matchList(calculMap, calculValStr);

							endListDt = stdTimestamp;

						}
					}

					Calendar cal = Calendar.getInstance();
					cal.setTimeInMillis(incStartDt.getTime());
					if ("5min".equals(period)) cal.add(Calendar.MINUTE, 5);
					else cal.add(Calendar.MINUTE, 15);
					incStartDt = new Timestamp(cal.getTime().getTime());

					chkCnt++;

				}

			}

			if (map.get(calculValStr) != null) {
//				자료형 확인 : (map.get(calculValStr)).getClass().getName()
				if (map.get(calculValStr) instanceof Double) {
					calculNum = calculNum + Math.round((Double) map.get(calculValStr));
				} else if (map.get(calculValStr) instanceof Float) {
					calculNum = calculNum + Math.round((Float) map.get(calculValStr));
				} else {
					calculNum = calculNum + Long.parseLong(String.valueOf(map.get(calculValStr)));
				}
				cnt++;
			}

			if (chkCnt == 1) {
				stdTimestamp = incStartDt;
			}

			if ("month".equals(period)) {
				boolean changeMonthYn = changeMonthYn(incStartDt);

				Calendar compareCal = Calendar.getInstance();
				compareCal.setTimeInMillis(incStartDt.getTime());
				compareCal.add(Calendar.MINUTE, Integer.parseInt(offset) * (-1)); // 로컬시간으로 변경
				compareCal.add(Calendar.MINUTE, 15);

//				if(now != next || i+1 == dataList.size()) {
				if (changeMonthYn == true || cnt == dataList.size()) {
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if (name.equals(timestampStr)) calculMap.put(timestampStr, stdTimestamp);
						else if (name.equals(calculValStr)) {
							if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
							else calculMap.put(calculValStr, calculNum);
						}
					}
					chkCnt = 0;
					nullCnt = 0;
					calculNum = 0;
					newList.add(calculMap);
					if(dateListCnt == dateListTotCnt) break;
					matchList(calculMap, calculValStr);
					endListDt = stdTimestamp;

				}

			} else {
				if (chkCnt == calculCnt || cnt == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if (name.equals(timestampStr)) calculMap.put(timestampStr, stdTimestamp);
						else if (name.equals(calculValStr)) {
							if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
							else calculMap.put(calculValStr, calculNum);
						}
					}
					chkCnt = 0;
					nullCnt = 0;
					calculNum = 0;
					newList.add(calculMap);
					if(dateListCnt == dateListTotCnt) break;
					matchList(calculMap, calculValStr);
					endListDt = stdTimestamp;

				}
			}

			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(incStartDt.getTime());
			if ("5min".equals(period)) cal.add(Calendar.MINUTE, 5);
			else cal.add(Calendar.MINUTE, 15);
			incStartDt = new Timestamp(cal.getTime().getTime());

			chkCnt++;

		}

		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("newList", newList);
		dataMap.put("endListDt", endListDt);

		return dataMap;
	}
	
	public static void matchList(Map<String, Object> calculMap, String calculValStr) {
		dateList.get(dateListCnt).put(calculValStr, calculMap.get(calculValStr));
		dateListCnt = dateListCnt+1;
	}

	/**
	 * 조회한 목록의 길이만큼 for문을 돌리면서 데이터를 조합하여 새로운 list에 넣는다(peak)
	 *
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
	private static Map<String, Object> dataCombinationPeak(List<Map<String, Object>> dataList, Timestamp selTermFrom, Timestamp selTermTo, String term,
														   String period, String timestampStr, String calculValStr, int flag, int calculCnt) {
		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();

		int cnt = 0;
		int nullCnt = 0;
		int chkCnt = 1;
		Timestamp stdTimestamp = null;
		double calculNum = 0;
		Timestamp incStartDt = selTermFrom;
		Timestamp endListDt = null;
		int peakLoopCnt = 0;
		if (calculCnt == 1) {
			peakLoopCnt = 1;
		} else if (calculCnt == 2) {
			peakLoopCnt = 2;
		} else {
			peakLoopCnt = 4;
		}
		int peakChkCnt = 1;
		long peakCalculNum = 0;

		for (int i = 0; i < dataList.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) dataList.get(i);
			Timestamp tmp = null;
			tmp = ((Timestamp) map.get(timestampStr));

			if (!incStartDt.equals(tmp)) { // db에서 조회가 안됐을 때 그 시간대의 값을 null로 만든다
				while (incStartDt.getTime() < tmp.getTime()) {
					nullCnt++; // 더하지 않고 null count를 올린다..
					if (chkCnt == 1) {
						stdTimestamp = incStartDt;
						peakCalculNum = 0;
					}

//					if( peakChkCnt == peakLoopCnt || peakChkCnt == 4 ) {
//						calculNum = calculNum + (peakCalculNum * peakLoopCnt);
//						peakChkCnt = 0;
////						System.out.println("더한값 NULL	   "+stdTimestamp+"   "+peakCalculNum+" * "+peakLoopCnt+" = "+(peakCalculNum * peakLoopCnt)+" ===>"+calculNum);
//					}

					if ("month".equals(period)) {
						boolean changeMonthYn = changeMonthYn(incStartDt);

						Calendar compareCal = Calendar.getInstance();
						compareCal.setTimeInMillis(incStartDt.getTime());
						compareCal.add(Calendar.MINUTE, Integer.parseInt(offset) * (-1)); // 로컬시간으로 변경
						compareCal.add(Calendar.MINUTE, 15);

//						if(now != next || i+1 == dataList.size()) {
						if (changeMonthYn == true || cnt == dataList.size()) {
							// 다음날짜가 달이 바뀌거나 마지막데이터일 때
							Map<String, Object> calculMap = new HashMap<String, Object>();
							Iterator<String> paramKeys = map.keySet().iterator();
							while (paramKeys.hasNext()) {
								String name = paramKeys.next();
								calculMap.put(name, map.get(name));
								if (name.equals(timestampStr)) {
									calculMap.put(timestampStr, stdTimestamp);
								} else if (name.equals(calculValStr)) {
									if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
									else calculMap.put(calculValStr, calculNum);
								}
							}
							chkCnt = 0;
							nullCnt = 0;
							calculNum = 0;
							newList.add(calculMap);
							if(dateListCnt == dateListTotCnt) break;
							matchList(calculMap, calculValStr);

							endListDt = stdTimestamp;

						}

					} else {
						if (chkCnt == calculCnt || cnt == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
							Map<String, Object> calculMap = new HashMap<String, Object>();
							Iterator<String> paramKeys = map.keySet().iterator();
							while (paramKeys.hasNext()) {
								String name = paramKeys.next();
								calculMap.put(name, map.get(name));
								if (name.equals(timestampStr)) {
									calculMap.put(timestampStr, stdTimestamp);
								} else if (name.equals(calculValStr)) {
									if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
									else calculMap.put(calculValStr, calculNum);
								}
							}
							chkCnt = 0;
							nullCnt = 0;
							calculNum = 0;
							newList.add(calculMap);
							if(dateListCnt == dateListTotCnt) break;
							matchList(calculMap, calculValStr);

							endListDt = stdTimestamp;

						}
					}

					Calendar cal = Calendar.getInstance();
					cal.setTimeInMillis(incStartDt.getTime());
					cal.add(Calendar.MINUTE, 15);
					incStartDt = new Timestamp(cal.getTime().getTime());

					chkCnt++;
					peakChkCnt++;

				}

			}


			double peak = 0;
			if (map.get(calculValStr) != null) {
//				자료형 확인 : (map.get(calculValStr)).getClass().getName()
				if (map.get(calculValStr) instanceof Double) {
//					peak = Math.round( (Double) map.get(calculValStr) );
					peak = (Double) map.get(calculValStr);
				} else if (map.get(calculValStr) instanceof Float) {
//					peak = Math.round( (Float) map.get(calculValStr) );
					peak = ((Float) map.get(calculValStr)).doubleValue();
				} else {
					peak = Double.parseDouble(String.valueOf(map.get(calculValStr)));
				}
				cnt++;
			}

			if (peakChkCnt == 1) {
				calculNum = peak;
			} else {
				if (calculNum < peak) {
					calculNum = peak;
				}
			}
//			if(peakChkCnt == 1) {
//				peakCalculNum = peak;
//			} else {
//				if(peakCalculNum < peak) {
//					peakCalculNum = peak;
//				}
//			}

//			if( peakChkCnt == peakLoopCnt || peakChkCnt == 4 ) {
//				calculNum = calculNum + (peakCalculNum * peakLoopCnt);
//				peakChkCnt = 0;
////				System.out.println("더한값		"+stdTimestamp+"   "+peakCalculNum+" * "+peakLoopCnt+" = "+(peakCalculNum * peakLoopCnt)+" ===>"+calculNum);
//			}


			if (chkCnt == 1) {
				stdTimestamp = incStartDt;
			}

			if ("month".equals(period)) {
				boolean changeMonthYn = changeMonthYn(incStartDt);

				Calendar compareCal = Calendar.getInstance();
				compareCal.setTimeInMillis(incStartDt.getTime());
				compareCal.add(Calendar.MINUTE, Integer.parseInt(offset) * (-1)); // 로컬시간으로 변경
				compareCal.add(Calendar.MINUTE, 15);

//				if(now != next || i+1 == dataList.size()) {
				if (changeMonthYn == true || cnt == dataList.size()) {
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if (name.equals(timestampStr)) calculMap.put(timestampStr, stdTimestamp);
						else if (name.equals(calculValStr)) {
							if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
							else calculMap.put(calculValStr, calculNum);
						}
					}
					chkCnt = 0;
					nullCnt = 0;
					calculNum = 0;
					newList.add(calculMap);
					if(dateListCnt == dateListTotCnt) break;
					matchList(calculMap, calculValStr);
					endListDt = stdTimestamp;

				}

			} else {
				if (chkCnt == calculCnt || cnt == dataList.size()) { // 정해진 횟수만큼 더했거나 마지막데이터일 때
					Map<String, Object> calculMap = new HashMap<String, Object>();
					Iterator<String> paramKeys = map.keySet().iterator();
					while (paramKeys.hasNext()) {
						String name = paramKeys.next();
						calculMap.put(name, map.get(name));
						if (name.equals(timestampStr)) calculMap.put(timestampStr, stdTimestamp);
						else if (name.equals(calculValStr)) {
							if (nullCnt == chkCnt) calculMap.put(calculValStr, null); // 더한게 모두 null일 경우
							else calculMap.put(calculValStr, calculNum);
						}
					}
					chkCnt = 0;
					nullCnt = 0;
					calculNum = 0;
					newList.add(calculMap);
					if(dateListCnt == dateListTotCnt) break;
					matchList(calculMap, calculValStr);
					endListDt = stdTimestamp;

				}
			}

			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(incStartDt.getTime());
			cal.add(Calendar.MINUTE, 15);
			incStartDt = new Timestamp(cal.getTime().getTime());

			chkCnt++;
			peakChkCnt++;

		}

		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("newList", newList);
		dataMap.put("endListDt", endListDt);

		return dataMap;
	}

	private static List<Map<String, Object>> finishPeriodCalculate(List<Map<String, Object>> newList, String term, String period, Timestamp selTermTo, String timestampStr, String calculValStr, Timestamp endListDt) {
		List<Map<String, Object>> list = newList;
		int cnt = 0;

		if (!endListDt.equals(selTermTo)) {
			Timestamp tmsp = endListDt;

			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(tmsp.getTime());

			if ("5min".equals(period)) cal.add(Calendar.MINUTE, 5);
			else if ("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
			else if ("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
			else if ("hour".equals(period)) cal.add(Calendar.HOUR, 1);
			else if ("day".equals(period)) cal.add(Calendar.DATE, 1);
			else if ("month".equals(period)) cal.add(Calendar.MONTH, 1);

			tmsp = new Timestamp(cal.getTime().getTime());
			while (tmsp.getTime() <= selTermTo.getTime()) {
				Map<String, Object> dateMap = new HashMap<String, Object>();
				dateMap.put(timestampStr, tmsp);
				dateMap.put(calculValStr, null);
				list.add(dateMap);
				cnt++;

				Calendar cal2 = Calendar.getInstance();
				cal2.setTimeInMillis(tmsp.getTime());

				if ("5min".equals(period)) cal2.add(Calendar.MINUTE, 5);
				else if ("15min".equals(period)) cal2.add(Calendar.MINUTE, 15);
				else if ("30min".equals(period)) cal2.add(Calendar.MINUTE, 30);
				else if ("hour".equals(period)) cal2.add(Calendar.HOUR, 1);
				else if ("day".equals(period)) cal2.add(Calendar.DATE, 1);
				else if ("month".equals(period)) cal2.add(Calendar.MONTH, 1);

				tmsp = new Timestamp(cal2.getTime().getTime());
			}

		}

		return list;

	}

	/**
	 * 계산(더하기)할 횟수 구하기
	 *
	 * @param term
	 * @param period
	 * @return
	 */
	public static int sumCntSet(String term, String period, int flag) {
		// 실제의 경우 데이터간격의 최소단위가 15분이므로 조회 시 데이터간격이 30분 이상이면 합을 구한다
		int sumCntPast = 0;

		if ("15min".equals(period) || "5min".equals(period)) {
			sumCntPast = 1;
		} else if ("30min".equals(period)) {
			sumCntPast = 2;
		} else if ("hour".equals(period)) {
			sumCntPast = 4;
		} else if ("day".equals(period)) {
			sumCntPast = 96;
		} else if ("month".equals(period)) {
			sumCntPast = 96 * 30;
		}

		return sumCntPast;

	}

	public static boolean changeMonthYn(Timestamp incStartDt) {
		boolean flag = false;

		Calendar compareCal = Calendar.getInstance();
		compareCal.setTimeInMillis(incStartDt.getTime());
		compareCal.add(Calendar.MINUTE, Integer.parseInt(offset) * (-1)); // 로컬시간으로 변경

		int now = compareCal.get(Calendar.MONTH);

		compareCal.add(Calendar.MINUTE, 15);
		int next = compareCal.get(Calendar.MONTH);

		if (now != next) {
			flag = true;
		}

		return flag;
	}

}
