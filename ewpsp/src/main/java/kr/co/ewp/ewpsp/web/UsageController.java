/**
 * class name : UsageController
 * description : 사용자 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.service.UsageService;

@Controller
public class UsageController {
	
	private static final Logger logger = LoggerFactory.getLogger(UsageController.class);
	
	@Resource(name="usageService")
	private UsageService usageService;

	@RequestMapping("/usage")
	public String main(Model model) {
		logger.debug("/usage");
		
//		List list = usageService.usageList();
//		model.addAttribute("list", list);
		
		return "ewp/energy/usage";
	}
	
	@RequestMapping("/getUsageRealList")
	public @ResponseBody Map<String, Object> getUsageRealList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getUsageRealList");
		logger.debug("param ::::: "+param.toString());
		
		List list = usageService.getUsageRealList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getUsageFutureList")
	public @ResponseBody Map<String, Object> getUsageFutureList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getUsageFutureList");
		logger.debug("param ::::: "+param.toString());
		
		List list = usageService.getUsageFutureList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
}
