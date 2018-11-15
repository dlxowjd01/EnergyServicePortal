package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.common.util.UserUtil;
import kr.co.ewp.ewpsp.service.AlarmService;
import kr.co.ewp.ewpsp.service.CmpyGrpSiteMngService;
import kr.co.ewp.ewpsp.service.ControlService;

@Controller
public class MainController {

	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

	@Autowired
	private AlarmService alarmService;

	@Resource(name="controlService")
	private ControlService controlService;

	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;

	@RequestMapping("/main")
	public String main() {
		logger.debug("/main");
		return "ewp/main/main";
	}

	/**
	 * 군관리메인 알람 조회
	 * @author greatman
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGMainAlarmList")
	public @ResponseBody Map<String, Object> getGMainAlarmList(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/getGMainAlarmList");
		logger.debug("param : {}", param);
//		param.put("alarmCfmYn", "N");

		Map userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer)userInfo.get("user_idx");
		String authType = (String)userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer)userInfo.get("comp_idx"));
		}

		Map result = controlService.getGMainDeviceAlarmCnt(param); // 장치별 알람건수
		List alarmList = alarmService.getGMainAlarmList(param); // 최근 알람 목록 조회(3건)

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		resultMap.put("alarmList", alarmList);
		return resultMap;
	}

	/**
	 * 군관리메인 사이트 사용량 총합계 조회
	 * @author greatman
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGMainSiteRankingTotalDetail")
	public @ResponseBody Map<String, Object> getGMainSiteRankingTotalDetail(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/getGMainSiteRankingTotal");
		logger.debug("param : {}", param);

		Map userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer)userInfo.get("user_idx");
		String authType = (String)userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer)userInfo.get("comp_idx"));
		}

		Map result = cmpyGrpSiteMngService.getGMainSiteRankingTotalDetail(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * 군관리메인 사이트 목록 조회
	 * @author greatman
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGMainSiteRankingList")
	public @ResponseBody Map<String, Object> getGMainSiteRankingList(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/getGMainSiteRankingList");
		logger.debug("param : {}", param);

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);

		Map userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer)userInfo.get("user_idx");
		String authType = (String)userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer)userInfo.get("comp_idx"));
		}
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		if (param.get("rankType") instanceof String) {
			param.put("rankType", Integer.parseInt((String)param.get("rankType")));
		}

		List list = cmpyGrpSiteMngService.getGMainSiteRankingList(param);
		int listCnt = cmpyGrpSiteMngService.getGMainSiteRankingListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}

		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

		Map resultMap = new HashMap();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	/**
	 * 군관리메인 사이트 사용량 총합계 조회
	 * @author greatman
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGMainSiteTotalDetail")
	public @ResponseBody Map<String, Object> getGMainSiteTotalDetail(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/getGMainSiteTotalDetail");
		logger.debug("param : {}", param);

		Map userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer)userInfo.get("user_idx");
		String authType = (String)userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer)userInfo.get("comp_idx"));
		}

		Map result = cmpyGrpSiteMngService.getGMainSiteTotalDetail(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * 군관리메인 지역별 사이트 건수 목록 조회
	 * @author greatman
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGMainAreaSiteCntList")
	public @ResponseBody Map<String, Object> getGMainAreaSiteCntList(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/getGMainAreaSiteCntList");
		logger.debug("param : {}", param);

		Map userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer)userInfo.get("user_idx");
		String authType = (String)userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer)userInfo.get("comp_idx"));
		}

		List list = cmpyGrpSiteMngService.getGMainAreaSiteCntList(param);

		Map resultMap = new HashMap();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * 군관리메인 사이트 목록 조회
	 * @author greatman
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGMainSiteList")
	public @ResponseBody Map<String, Object> getGMainSiteList(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/getGMainSiteList");
		logger.debug("param : {}", param);

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 10;
		int startNum = pageRowCnt*(selPageNum-1);

		Map userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer)userInfo.get("user_idx");
		String authType = (String)userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer)userInfo.get("comp_idx"));
		}
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);

		List list = cmpyGrpSiteMngService.getGMainSiteList(param);
		int listCnt = cmpyGrpSiteMngService.getGMainSiteListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}

		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수

		Map resultMap = new HashMap();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	/**
	 * 군관리메인 사이트그룹 목록 조회
	 * @author greatman
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getGMainGroupList")
	public @ResponseBody Map<String, Object> getGMainGroupList(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/getGMainGroupList");
		logger.debug("param : {}", param);

		Map userInfo = UserUtil.getUserInfo(session);
		if (userInfo == null) {
			userInfo = new HashMap();
		}
		logger.debug("userInfo : {}", userInfo);

		Integer userIdx = (Integer)userInfo.get("user_idx");
		String authType = (String)userInfo.get("auth_type");
		if (userIdx == null) {
			userIdx = -1;
		}

		if (authType == null || (!authType.equals("1") && !authType.equals("2"))) {
			param.put("userIdx", userIdx);
		} else if (authType.equals("2")) {
			param.put("compIdx", (Integer)userInfo.get("comp_idx"));
		}

		List list = cmpyGrpSiteMngService.getGMainGroupList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
}
