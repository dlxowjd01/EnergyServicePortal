package kr.co.esp.device2.web;

import java.util.Arrays;
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
import kr.co.esp.device2.service.Device2GroupService;
import kr.co.esp.system.service.CmpyGrpSiteMngService;


@Controller
public class Device2GroupController {

	private static final Logger logger = LoggerFactory.getLogger(Device2GroupController.class);
	
	@Resource(name="device2GroupService")
	private Device2GroupService device2GroupService;
	
	@RequestMapping(value = "/device2/device2Group.do")
	public String device2Group(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/device2/device2Group.do");		
		return "esp/device2/device2Group";
	}
	
	@RequestMapping("/device2/getDevice2GroupInfo.json")
	public @ResponseBody Map<String, Object> getDevice2GroupInfo(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/device2/getDevice2GroupInfo.json");
		logger.debug("param ::::: {}", param);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		List<Map<String, Object> > list = device2GroupService.getDevice2GroupInfo(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/device2/getDevice2Info.json")
	public @ResponseBody Map<String, Object> getDevice2Info(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/device2/getDevice2Info.json");
		logger.debug("param ::::: {}", param);
		
		List<Map<String, Object> > list = device2GroupService.getDevice2Info(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}	
	
	@RequestMapping("/device2/insertDevice2.json")
	public @ResponseBody Map<String, Object> insertDevice2(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/device2/insertDevice2.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();

		int cnt = device2GroupService.getDevice2Chk(param);
		if(cnt > 0) {
			resultMap.put("resultCode", 1);
			resultMap.put("resultMsg", "입력하신 장치가 이미 존재합니다. \n다시 입력해주세요.");
			return resultMap;
		}
		
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		param.put("regUid", userInfo.get("user_id"));
		param.put("userIdx", userInfo.get("user_idx"));
		
		if("1".equals(param.get("deviceType")) || "2".equals(param.get("deviceType")) || "3".equals(param.get("deviceType")) || "9".equals(param.get("deviceType"))) {
			param.put("instType", 2); // localEMS
		} else {
			param.put("instType", 1); // enertalk
		}
		
		int resultCnt = device2GroupService.insertDevice2(param);
		
		resultMap.put("resultCnt", resultCnt);
		resultMap.put("resultMsg", "");
		resultMap.put("resultCode", 0);
		return resultMap;
	}	
}
