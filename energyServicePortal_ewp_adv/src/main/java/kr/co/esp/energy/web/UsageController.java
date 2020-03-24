package kr.co.esp.energy.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.energy.service.UsageService;

@Controller
public class UsageController {

	private static final Logger logger = LoggerFactory.getLogger(UsageController.class);
	
	@Resource(name="usageService")
	private UsageService usageService;
	
	@RequestMapping(value = "/energy/usage.do")
	public String usage() {
		logger.debug("/energy/usage.do");
		return "esp/energy/usage";
	}

	@RequestMapping("/energy/getUsageRealList.json")
	public @ResponseBody Map<String, Object> getUsageRealList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getUsageRealList.json");
		logger.debug("	 param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> result = usageService.getUsageRealList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", result.get("sheetList"));
		resultMap.put("chartList", result.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/energy/getUsageFutureList.json")
	public @ResponseBody Map<String, Object> getUsageFutureList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getUsageFutureList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> result = usageService.getUsageFutureList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", result.get("sheetList"));
		resultMap.put("chartList", result.get("chartList"));
		return resultMap;
	}
	
}
