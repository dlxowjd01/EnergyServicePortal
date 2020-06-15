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

import kr.co.esp.common.util.UserUtil;
import kr.co.esp.system.service.KepcoMngService;

@Controller
public class KepcoMngController {

	private static final Logger logger = LoggerFactory.getLogger(KepcoMngController.class);

	@Resource(name="kepcoMngService")
	private KepcoMngService kepcoMngService;
	
	@RequestMapping(value = "/system/kepcoMng.do")
	public String kepcoMng(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/system/kepcoMng.do");
		return "esp/system/kepcoMng";
	}

	/**
	 * 한전 계약 및 전력 관리 정보 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/getSiteSetDetail.json")
	public @ResponseBody Map<String, Object> getSiteSetDetail(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/getSiteSetDetail.json");
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		logger.debug("     param ::::: " + param.toString());

		Map<String, Object> result = kepcoMngService.getSiteSetDetail(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	/**
	 * 요금제 조회
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/getPlanType.json")
	public @ResponseBody Map<String, Object> getPlanType(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/getPlanType.json");
		logger.debug("     param ::::: " + param.toString());

		List<Map<String, Object>> list = kepcoMngService.getPlanType(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * 요금제 조회 및 계절별 값 설정
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/getPlanTypeVal.json")
	public @ResponseBody Map<String, Object> getPlanTypeVal(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/getPlanTypeVal.json");
		logger.debug("     param ::::: " + param.toString());

		Map<String, Object> result = kepcoMngService.getPlanTypeVal(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", result);
		return resultMap;
	}

	/**
	 * 한전 계약 및 전력 관리 정보 수정
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/system/updateSiteSet.json")
	public @ResponseBody Map<String, Object> updateSiteSet(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/system/updateSiteSet.json");
		logger.debug("     param ::::: " + param.toString());

		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("modUid", userInfo.get("user_id"));

		int resultCnt = kepcoMngService.updateSiteSet(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
}
