package kr.co.esp.energy.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.esp.common.util.UserUtil;
import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.energy.service.EssChargeService;
import kr.co.esp.system.service.CmpyGrpSiteMngService;

@Controller
public class EnergyController {

	private static final Logger logger = LoggerFactory.getLogger(EnergyController.class);
	
	@Resource(name="essChargeService")
	private EssChargeService essChargeService;

	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;

	@RequestMapping("/main/getESSChargeSum.json")
	public @ResponseBody Map<String, Object> getESSChargeSum(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getESSChargeSum.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> result = essChargeService.getESSChargeSum(param); // ess 충방전량 합계 조회

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultListMap", result);
		return resultMap;
	}
	

	/**
	 * 군관리메인 사이트 사용량 총합계 조회
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/main/getGMainSiteRankingTotalDetail.json")
	public @ResponseBody Map<String, Object> getGMainSiteRankingTotalDetail(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getGMainSiteRankingTotalDetail.json");
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

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> result = cmpyGrpSiteMngService.getGMainSiteRankingTotalDetail(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * 군관리메인 사이트 목록 조회
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/main/getGMainSiteRankingList.json")
	public @ResponseBody Map<String, Object> getGMainSiteRankingList(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getGMainSiteRankingList.json");
		logger.debug("param : {}", param);

		param = PeriodDataSetting.setSearchTerm(param);

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt * (selPageNum - 1);

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
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		if (param.get("rankType") instanceof String) {
			param.put("rankType", Integer.parseInt((String) param.get("rankType")));
		}

		List<Map<String, Object>> list = cmpyGrpSiteMngService.getGMainSiteRankingList(param);
		int listCnt = cmpyGrpSiteMngService.getGMainSiteRankingListCnt(param);
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
	 * 군관리메인 사이트 사용량 총합계 조회
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/main/getGMainSiteTotalDetail.json")
	public @ResponseBody Map<String, Object> getGMainSiteTotalDetail(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getGMainSiteTotalDetail.json");
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

		Map<String, Object> result = cmpyGrpSiteMngService.getGMainSiteTotalDetail(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
//		resultMap.put("imgRoot", fileUploadRootPath);
		resultMap.put("imgRoot", "/imgFiles");
		return resultMap;
	}
	
}
