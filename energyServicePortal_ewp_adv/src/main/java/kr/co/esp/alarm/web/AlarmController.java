package kr.co.esp.alarm.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.esp.alarm.service.AlarmService;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.energy.PeriodDataSetting;

@Controller
public class AlarmController {

	private static final Logger logger = LoggerFactory.getLogger(AlarmController.class);

	@Resource(name="alarmService")
	private AlarmService alarmService;
	
	@RequestMapping(value = "/alarm/alarmMng.do")
	public String alarmMng(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/alarm/alarmMng.do");
		return "esp/alarm/alarmMng";
	}
	
	/**
	 * 장치구분별 알람건수 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/getDeviceAlarmCnt.json")
	public @ResponseBody Map<String, Object> getDeviceAlarmCnt(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/alarm/getDeviceAlarmCnt.json");
		logger.debug("     param ::::: " + param.toString());

		Map<String, Object> result = alarmService.getDeviceAlarmCnt(param); // 장치별 알람건수

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * 비상 알람 목록 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/getWarningAlarmList.json")
	public @ResponseBody Map<String, Object> getWarningAlarmList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/alarm/getWarningAlarmList.json");
		logger.debug("     param ::::: " + param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt * (selPageNum - 1);

		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);

		param.put("alarmType", 1); // 비상
		List<Map<String, Object>> list = alarmService.getAlarmList(param);// 알람 목록
		int listCnt = alarmService.getAlarmListCnt(param);
		int totalPageCnt = 0;
		if (listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if (listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}

		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	/**
	 * 주의 알람 목록 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/getAlertAlarmList.json")
	public @ResponseBody Map<String, Object> getAlertAlarmList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/alarm/getAlertAlarmList.json");
		logger.debug("     param ::::: " + param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt * (selPageNum - 1);

		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);

		param.put("alarmType", 2); // 주의
		List<Map<String, Object>> list = alarmService.getAlarmList(param); // 알람 목록
		int listCnt = alarmService.getAlarmListCnt(param);
		int totalPageCnt = 0;
		if (listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if (listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}

		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	/**
	 * 알람 수정
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/updateAlarm.json")
	public @ResponseBody Map<String, Object> updateAlarm(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/alarm/updateAlarm.json");
		logger.debug("     param ::::: " + param.toString());

		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("modUid", userInfo.get("user_id"));

		int resultCnt = alarmService.updateAlarm(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	/**
	 * 알람 수신자 목록 조회
	 *
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/getSmsAddresseeList.json")
	public @ResponseBody Map<String, Object> getSmsAddresseeList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/alarm/getSmsAddresseeList.json");
		logger.debug("     param ::::: " + param.toString());

		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));

		List<Map<String, Object>> list = alarmService.getSmsAddresseeList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * 알람 수신자 등록가능 이름 목록 조회
	 *
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/getInsertAddresseeNameList.json")
	public @ResponseBody Map<String, Object> getInsertAddresseeNameList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/alarm/getInsertAddresseeNameList.json");
		logger.debug("     param ::::: " + param.toString());

		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));

		List<Map<String, Object>> list = alarmService.getInsertAddresseeNameList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * 알람 수신자 등록
	 *
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/insertAddressee.json")
	public @ResponseBody Map<String, Object> insertAddressee(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/alarm/insertAddressee.json");
		logger.debug("     param ::::: " + param.toString());

		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("regUid", userInfo.get("user_id"));
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));

		int resultCnt = alarmService.insertAddressee(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	/**
	 * 알람 수신자 삭제
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/alarm/deleteAddressee.json")
	public @ResponseBody Map<String, Object> deleteAddressee(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/alarm/deleteAddressee.json");
		logger.debug("     param ::::: " + param.toString());

		int resultCnt = alarmService.deleteAddressee(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	
	
	@RequestMapping("/main/getAlarmList.json")
	public @ResponseBody Map<String, Object> getAlarmList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getAlarmList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> result = alarmService.getDeviceAlarmCnt(param); // 장치별 알람건수
		Map<String, Object> result2 = alarmService.getSiteMainAlarmCnt(param); // 장치타입별 알람건수
		List<Map<String, Object>> alarmList = alarmService.getMainAlarmList(param); // 최근 알람 목록 조회(3건)

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		resultMap.put("detail2", result2);
		resultMap.put("alarmList", alarmList);
		return resultMap;
	}

	/**
	 * 군관리메인 알람 조회
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/main/getGMainAlarmList.json")
	public @ResponseBody Map<String, Object> getGMainAlarmList(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getGMainAlarmList.json");
		logger.debug("param : {}", param);

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap<String, Object>();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer) userInfo.get("user_idx");
		String authType = (String) userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2") && !authType.equals("3"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer) userInfo.get("comp_idx"));
		} else if (authType.equals("3")) {
			param.put("siteGrpIdx", (Integer) userInfo.get("site_grp_idx"));
		}

		Map<String, Object> result = alarmService.getGMainDeviceAlarmCnt(param); // 장치별 알람건수
		Map<String, Object> result2 = alarmService.getGMainAlarmCnt(param); // 장치타입별 알람건수
		List<Map<String, Object>> alarmList = alarmService.getGMainAlarmList(param); // 최근 알람 목록 조회(3건)

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		resultMap.put("detail2", result2);
		resultMap.put("alarmList", alarmList);
		return resultMap;
	}
	
}
