package kr.co.esp.energy;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.esp.common.util.CommonUtils;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.*;

public class PeriodDataSetting {

	private static final Logger logger = LoggerFactory.getLogger(PeriodDataSetting.class);

	private static String offset = "";

	/**
	 * 조회간격에 따라 데이터를 조합하여 셋팅
	 *
	 * @param param		: 검색조건
	 * @param dataList	 : db 데이터
	 * @param timestampStr : 계산기준 컬럼명
	 * @param calculValStr : 계산에 사용될 컬럼명
	 * @param flag		 : 1:실제(15min), 2:예측(hour)
	 * @return
	 */
	public static Map<String, Object> dataSetting(HttpServletRequest request, Map<String, Object> param, List<Map<String, Object>> dataList, String timestampStr, String calculValStr, int flag) {
		logger.debug("PeriodDataSetting.dataSetting()+" + timestampStr + ", " + calculValStr);

		Map<String, Object> map = new HashMap<String, Object>();
//		offset = CommonUtils.getTimeOffset(request);
		offset = (String) param.get("timeOffset");
		request.setAttribute("timeOffset", offset);

		String term = (String) param.get("selTerm"); // 조회기간
		String period = (String) param.get("selPeriodVal"); // 데이터조회간격
		Timestamp startDate = getStartEndTimestamp(term, period, (String) param.get("selTermFrom"), "1"); // 검색시작일(그래프영역)
		Timestamp endDate = getStartEndTimestamp(term, period, (String) param.get("selTermTo"), "2"); // 검색종료일(그래프영역)
		Timestamp selTermFrom = getConvertStartEndTmsp(term, period, (String) param.get("selTermFrom"), "1"); // 검색시작일(표영역)
		Timestamp selTermTo = getConvertStartEndTmsp(term, period, (String) param.get("selTermTo"), "2"); // 검색종료일(표영역)

		// 날짜리스트 생성
		List<Map<String, Object>> sheetDateList = getDateList(selTermFrom, selTermTo, term, period, timestampStr, calculValStr, "sheet"); // 표영역
		List<Map<String, Object>> chartDateList = getDateList(startDate, endDate, term, period, timestampStr, calculValStr, "chart"); // 그래프영역

		// 데이터조합
		List<Map<String, Object>> sheetReDataList = DataPeriodCalculate.periodCalculate(request, dataList, selTermFrom, selTermTo, term, period, timestampStr, calculValStr, flag, sheetDateList); // 표영역
		List<Map<String, Object>> chartReDataList = DataPeriodCalculate.periodCalculate(request, dataList, startDate, endDate, term, period, timestampStr, calculValStr, flag, chartDateList); // 그래프영역

		// 날짜리스트+데이터조합 매칭
//		List<Map<String, Object>> sheetList = matchingLists(sheetDateList, sheetReDataList, timestampStr, calculValStr); // 표영역
//		List<Map<String, Object>> chartList = matchingLists(chartDateList, chartReDataList, timestampStr, calculValStr); // 그래프영역
		List<Map<String, Object>> sheetList = sheetReDataList; // 표영역
		List<Map<String, Object>> chartList = chartReDataList; // 그래프영역
//		logger.debug("sheetList	 " + sheetList.size() + "======>   " + sheetList.toString());
//		logger.debug("chartList	 " + chartList.size() + "======>   " + chartList.toString());

		map.put("sheetList", sheetList);
		map.put("chartList", chartList);

		return map;
	}

	/**
	 * 그래프영역 검색일자 변환(분단위를 00, 15, 30, 45중 하나로 맞추고 timestamp로 리턴)
	 *
	 * @param timestamp
	 * @param flag
	 * @param string2
	 * @param string
	 * @return
	 */
	public static Timestamp getStartEndTimestamp(String term, String period, String timestamp, String flag) {
		Calendar cal = originSearchDate(timestamp, offset);

		if ("30min".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, -1, cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND), 0);
			} else if ("2".equals(flag)) {
				setHms(cal, -1, cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND), 999);
			}

		} else if ("hour".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, -1, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, -1, 59, 59, 999);
			}

		} else if ("day".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, -1, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, -1, 59, 59, 999);
			}

		} else if ("week".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("month".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("year".equals(term)) {
			if ("month".equals(period)) {
				if ("1".equals(flag)) {
					cal.set(Calendar.DATE, 1);
					setHms(cal, 0, 0, 0, 0);
				} else if ("2".equals(flag)) {
					cal.set(Calendar.DATE, Calendar.DAY_OF_MONTH);
					setHms(cal, 23, 59, 59, 999);
				}
			} else {
				if ("1".equals(flag)) {
					setHms(cal, 0, 0, 0, 0);
				} else if ("2".equals(flag)) {
					setHms(cal, 23, 59, 59, 999);
				}
			}

		} else if ("other".equals(term)) { // 에너지모니터링 화면 전체의 기간설정검색
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("selectDay".equals(term)) { // 에너지모니터링 dr실적조회의 날짜검색
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("drday".equals(term) || "today".equals(term)) { // 에너지모니터링 dr실적조회의 오늘날짜
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("billSelectMM_pv".equals(term)) { // 요금수익 pv 수익 조회
			if ("1".equals(flag)) {
				cal.set(Calendar.DATE, 1);
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				cal.set(Calendar.DATE, Calendar.DAY_OF_MONTH);
				setHms(cal, 23, 59, 59, 999);
			}

		}

		cal.add(Calendar.MINUTE, Integer.parseInt(offset));
		Timestamp tmsp = new Timestamp(cal.getTime().getTime());
		return tmsp;
	}

	/**
	 * 표영역 검색일자 변환(분단위를 00, 15, 30, 45중 하나로 맞추고 timestamp로 리턴)
	 *
	 * @param timestamp 정리할 검색일자
	 * @param flag	  시작일자:1, 종료일자:2
	 * @return
	 */
	public static Timestamp getConvertStartEndTmsp(String term, String period, String timestamp, String flag) {
		Calendar cal = originSearchDate(timestamp, offset);

		if ("30min".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, -1, cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND), 0);
			} else if ("2".equals(flag)) {
				setHms(cal, -1, cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND), 999);
			}

		} else if ("hour".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, -1, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, -1, 59, 59, 999);
			}

		} else if ("day".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("week".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("month".equals(term)) {
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("year".equals(term)) {
			if ("month".equals(period)) {
				if ("1".equals(flag)) {
					cal.set(Calendar.DATE, 1);
					setHms(cal, 0, 0, 0, 0);
				} else if ("2".equals(flag)) {
					cal.set(Calendar.DATE, Calendar.DAY_OF_MONTH);
					setHms(cal, 23, 59, 59, 999);
				}
			} else {
				if ("1".equals(flag)) {
					setHms(cal, 0, 0, 0, 0);
				} else if ("2".equals(flag)) {
					setHms(cal, 23, 59, 59, 999);
				}
			}

		} else if ("other".equals(term)) { // 에너지모니터링 화면 전체의 기간설정검색
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("selectDay".equals(term)) { // 에너지모니터링 dr실적조회의 날짜검색
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("drday".equals(term)) { // 에너지모니터링 dr실적조회의 오늘날짜
			if ("1".equals(flag)) {
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				setHms(cal, 23, 59, 59, 999);
			}

		} else if ("billSelectMM_pv".equals(term)) { // 요금수익 pv 수익 조회
			if ("1".equals(flag)) {
				cal.set(Calendar.MONTH, 0);
				cal.set(Calendar.DATE, 1);
				setHms(cal, 0, 0, 0, 0);
			} else if ("2".equals(flag)) {
				cal.set(Calendar.MONTH, 11);
				cal.set(Calendar.DATE, Calendar.DAY_OF_MONTH);
				setHms(cal, 23, 59, 59, 999);
			}

		}

		cal.add(Calendar.MINUTE, Integer.parseInt(offset));
		Timestamp tmsp = new Timestamp(cal.getTime().getTime());
		return tmsp;

	}

	/**
	 * 날짜리스트 생성
	 *
	 * @param selTermFrom
	 * @param selTermTo
	 * @param term
	 * @param period
	 * @param timestampStr
	 * @param calculValStr
	 * @param string
	 * @return
	 */
	public static List<Map<String, Object>> getDateList(Timestamp selTermFrom, Timestamp selTermTo, String term, String period, String timestampStr, String calculValStr, String gbn) {
		List<Map<String, Object>> dateList = new ArrayList<Map<String, Object>>();

		Timestamp tmsp = selTermFrom;
		int cnt = 0;

		while (tmsp.getTime() <= selTermTo.getTime()) {
			Map<String, Object> dateMap = new HashMap<String, Object>();
			dateMap.put(timestampStr, tmsp);
			dateMap.put(calculValStr, null);
			dateList.add(dateMap);
			cnt++;

			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(tmsp.getTime());

			if ("5min".equals(period)) cal.add(Calendar.MINUTE, 5);
			else if ("15min".equals(period)) cal.add(Calendar.MINUTE, 15);
			else if ("30min".equals(period)) cal.add(Calendar.MINUTE, 30);
			else if ("hour".equals(period)) cal.add(Calendar.HOUR, 1);
			else if ("day".equals(period)) cal.add(Calendar.DATE, 1);
			else if ("month".equals(period)) {

				cal.add(Calendar.MINUTE, Integer.parseInt(offset) * (-1)); // 로컬시간으로 변경

				if ("sheet".equals(gbn)) {
					cal.add(Calendar.MONTH, 1);
//					cal.set(Calendar.DATE, -1);
				} else {
					cal.add(Calendar.MONTH, 1);
				}

				cal.add(Calendar.MINUTE, Integer.parseInt(offset));

			}

			tmsp = new Timestamp(cal.getTime().getTime());
		}

		return dateList;
	}

	/**
	 * 날짜리스트와 데이터리스트를 매칭시킨다
	 *
	 * @param dateList
	 * @param reDataList
	 * @param calculValStr
	 * @param timestampStr
	 * @return
	 */
	private static List<Map<String, Object>> matchingLists(List<Map<String, Object>> dateList, List<Map<String, Object>> reDataList, String timestampStr, String calculValStr) {
		List<Map<String, Object>> finalDataList = new ArrayList<Map<String, Object>>();

		for (int i = 0; i < dateList.size(); i++) {
			Map<String, Object> dateMap = (Map<String, Object>) dateList.get(i);
			Map<String, Object> dataMap = (Map<String, Object>) reDataList.get(i);

			Map<String, Object> newDataMap = new HashMap<String, Object>();
			Iterator<String> paramKeys = dateMap.keySet().iterator();
			while (paramKeys.hasNext()) {
				String name = paramKeys.next();
				newDataMap.put(name, dateMap.get(name));
				if (name.equals(calculValStr)) newDataMap.put(calculValStr, dataMap.get(name));
			}
			finalDataList.add(newDataMap);

		}

		return finalDataList;
	}

	/**
	 * 실제 검색시간으로 변경
	 *
	 * @param timestamp
	 * @param offset
	 */
	public static Calendar originSearchDate(String timestamp, String offset) {
		String reTimestamp = timestamp.substring(0, 4) + "-" + timestamp.substring(4, 6) + "-" + timestamp.substring(6, 8) + " " + timestamp.substring(8, 10) + ":" + timestamp.substring(10, 12) + ":" + timestamp.substring(12, 14);
		Timestamp tp = Timestamp.valueOf(reTimestamp);
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(tp.getTime());
		cal.add(Calendar.MINUTE, Integer.parseInt(offset) * (-1)); // 로컬시간으로 변경

		Timestamp tmsp = new Timestamp(cal.getTime().getTime());

		return cal;
	}


	/**
	 * 날짜시간 세팅
	 *
	 * @param calendar
	 * @param hour
	 * @param minute
	 * @param secone
	 * @param milllsecond
	 */
	public static void setHms(Calendar calendar, int hour, int minute, int secone, int milllsecond) {
		if (hour >= 0) calendar.set(Calendar.HOUR_OF_DAY, hour);
		if (minute >= 0) calendar.set(Calendar.MINUTE, minute);
		if (secone >= 0) calendar.set(Calendar.SECOND, secone);
		if (milllsecond >= 0) calendar.set(Calendar.MILLISECOND, milllsecond);
	}

	/**
	 * 검색조건(시작일시, 종료일시) timeOffset 적용
	 *
	 * @param param
	 * @return
	 */
	public static Map<String, Object> setSearchTerm(Map<String, Object> param) {
		param = setDateApplyOffset(param, "selTermFrom");
		param = setDateApplyOffset(param, "selTermTo");

		return param;
	}

	public static Map<String, Object> setDateApplyOffset(Map<String, Object> param, String paramName) {
		String setDate = (String) param.get(paramName);
		String offset = (String) param.get("timeOffset");

		String setDtStr = setDate.substring(0, 4) + "-" + setDate.substring(4, 6) + "-" + setDate.substring(6, 8) + " "
				+ setDate.substring(8, 10) + ":" + setDate.substring(10, 12) + ":" + setDate.substring(12, 14);

		Timestamp tstp = Timestamp.valueOf(setDtStr);

		Calendar cal1 = Calendar.getInstance();
		cal1.setTimeInMillis(tstp.getTime());
		cal1.add(Calendar.MINUTE, Integer.parseInt(offset));

		Date startDate = cal1.getTime();

		param.put(paramName, CommonUtils.convertDateFormat(startDate, "yyyyMMddHHmmss"));

		return param;
	}

}
