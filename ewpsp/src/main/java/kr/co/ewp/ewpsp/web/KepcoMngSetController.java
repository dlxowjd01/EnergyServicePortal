/**
 * class name : SetupController
 * description : 설정 메뉴 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.service.KepcoMngSetService;

@Controller
public class KepcoMngSetController {

	private static final Logger logger = LoggerFactory.getLogger(KepcoMngSetController.class);
	
	@Resource(name="kepcoMngSetService")
	private KepcoMngSetService kepcoMngSetService;

	@RequestMapping("/kepcoMngSet")
	public String kepcoMngSet(Model model) {
		logger.debug("/kepcoMngSet");
		
		return "ewp/setup/kepcoMngSet";
	}
	
	/**
	 * 한전 계약 및 전력관리 정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getSiteSetDetail")
	public @ResponseBody Map<String, Object> getSiteSetDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getSiteSetDetail");
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		logger.debug("param ::::: "+param.toString());
		
		Map result = kepcoMngSetService.getSiteSetDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	/**
	 * 한전 계약 및 전력관리 정보 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateSiteSet")
	public @ResponseBody Map<String, Object> updateSiteSet(@RequestParam HashMap param) throws Exception {
		logger.debug("/updateSiteSet");
		logger.debug("param ::::: "+param.toString());
		
		int resultCnt = kepcoMngSetService.updateSiteSet(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
}
