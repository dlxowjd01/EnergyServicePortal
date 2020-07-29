package kr.co.esp.system.web;

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

import egovframework.com.cmm.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.system.service.CmpyGrpSiteMngService;

@Controller
public class SystemController {

	private static final Logger logger = LoggerFactory.getLogger(SystemController.class);

	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;
	
//	@Value("${globals.fileUpload.rootPath}")
//    private String fileUploadRootPath;
	private String fileUploadRootPath = EgovProperties.getProperty("globals.fileUpload.rootPath");
	

	/**
	 * 군관리메인 지역별 사이트 건수 목록 조회
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/main/getGMainAreaSiteCntList.json")
	public @ResponseBody Map<String, Object> getGMainAreaSiteCntList(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getGMainAreaSiteCntList.json");
		logger.debug("param : {}", param);

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

		List<Map<String, Object>> list = cmpyGrpSiteMngService.getGMainAreaSiteCntList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
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
	@RequestMapping("/main/getGMainSiteList.json")
	public @ResponseBody Map<String, Object> getGMainSiteList(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getGMainSiteList.json");
		logger.debug("param : {}", param);

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 10;
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

		param = PeriodDataSetting.setSearchTerm(param);

		List<Map<String, Object>> list = cmpyGrpSiteMngService.getGMainSiteList(param);
		int listCnt = cmpyGrpSiteMngService.getGMainSiteListCnt(param);
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
	 * 군관리메인 사이트그룹 목록 조회
	 *
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 * @author greatman
	 */
	@RequestMapping("/main/getGMainGroupList.json")
	public @ResponseBody Map<String, Object> getGMainGroupList(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/main/getGMainGroupList.json");
		logger.debug("param : {}", param);

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

		List<Map<String, Object>> list = cmpyGrpSiteMngService.getGMainGroupList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	// @RequestMapping(value = "/system/siteSetting.do")
	// public String systemSiteSetting(HttpServletRequest request, HttpSession session, Model model) {
	// 	System.out.println("/system/siteSetting.do");
	// 	return "esp/system/siteSetting";
	// }

	@RequestMapping(value = "/system/basicInformation.do")
	public String systemBasicInformation(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/system/basicInformation.do");
		return "esp/system/basicInformation";
	}

	@RequestMapping(value = "/system/alarmManagement.do")
	public String systemAlarmManagement(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/system/alarmManagement.do");
		return "esp/system/alarmManagement";
	}

	@RequestMapping(value = "/system/systemCode.do")
	public String systemSystemCode(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/system/systemCode.do");
		return "esp/system/systemCode";
	}

	@RequestMapping(value = "/system/systemSetting.do")
	public String systemSystemSetting(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/system/systemSetting.do");
		return "esp/system/systemSetting";
	}
	
}
