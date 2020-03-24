package kr.co.esp.energy.web;

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

import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.energy.service.DerUsageService;
import kr.co.esp.energy.service.PvGenService;
import kr.co.esp.energy.service.UsageService;

@Controller
public class DerUsageController {

	private static final Logger logger = LoggerFactory.getLogger(DerUsageController.class);
	
	@Resource(name="derUsageService")
	private DerUsageService derUsageService;
	
	@Resource(name="usageService")
	private UsageService usageService;
	
	@Resource(name="pvGenService")
	private PvGenService pvGenService;
	
	@RequestMapping(value = "/energy/derUsage.do")
	public String derUsage(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/energy/derUsage.do");
		return "esp/energy/derUsage";
	}

	@RequestMapping("/energy/getESSUsageList.json")
	public @ResponseBody Map<String, Object> getESSUsageList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getESSUsageList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> list = derUsageService.getESSUsageList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/energy/getDERUsageList.json")
	public @ResponseBody Map<String, Object> getDERUsageList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getDERUsageList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> kepcoUsageList = usageService.getUsageRealList(param, request); // 한전 사용량
		Map<String, Object> essUsageList = derUsageService.getESSUsageList(param, request);// ESS 사용량
		Map<String, Object> pvUsageList = pvGenService.getPVGenRealList(param, request); // PV 사용량

		List<Map<String, Object>> loopCntSheetList = null;
		List<Map<String, Object>> loopCntChartList = null;
		if ((List<Map<String, Object>>) kepcoUsageList.get("sheetList") != null && ((List<Map<String, Object>>) kepcoUsageList.get("sheetList")).size() > 0) {
			loopCntSheetList = (List<Map<String, Object>>) kepcoUsageList.get("sheetList");
			loopCntChartList = (List<Map<String, Object>>) kepcoUsageList.get("chartList");
		} else if ((List<Map<String, Object>>) essUsageList.get("sheetList") != null && ((List<Map<String, Object>>) essUsageList.get("sheetList")).size() > 0) {
			loopCntSheetList = (List<Map<String, Object>>) essUsageList.get("sheetList");
			loopCntChartList = (List<Map<String, Object>>) essUsageList.get("chartList");
		} else if ((List<Map<String, Object>>) pvUsageList.get("sheetList") != null && ((List<Map<String, Object>>) pvUsageList.get("sheetList")).size() > 0) {
			loopCntSheetList = (List<Map<String, Object>>) pvUsageList.get("sheetList");
			loopCntChartList = (List<Map<String, Object>>) pvUsageList.get("chartList");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if ((List<Map<String, Object>>) kepcoUsageList.get("sheetList") != null) {
			resultMap.put("kepcoUsageSheetList", kepcoUsageList.get("sheetList"));
			resultMap.put("kepcoUsageChartList", kepcoUsageList.get("chartList"));
		}
		if ((List<Map<String, Object>>) essUsageList.get("sheetList") != null) {
			resultMap.put("essUsageListSheetList", essUsageList.get("sheetList"));
			resultMap.put("essUsageListChartList", essUsageList.get("chartList"));
		}
		if ((List<Map<String, Object>>) pvUsageList.get("sheetList") != null) {
			resultMap.put("pvUsageListSheetList", pvUsageList.get("sheetList"));
			resultMap.put("pvUsageListChartList", pvUsageList.get("chartList"));
		}
		resultMap.put("loopCntSheetList", loopCntSheetList);
		resultMap.put("loopCntChartList", loopCntChartList);

		return resultMap;
	}
	
}
