package kr.co.esp.energy.web;

import java.util.HashMap;
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
import kr.co.esp.energy.service.EssChargeService;

@Controller
public class EssChargeController {

	private static final Logger logger = LoggerFactory.getLogger(EssChargeController.class);
	
	@Resource(name="essChargeService")
	private EssChargeService essChargeService;
	
	@RequestMapping(value = "/energy/essCharge.do")
	public String essCharge(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/energy/essCharge.do");
		return "esp/energy/essCharge";
	}

	@RequestMapping("/energy/getESSChargeRealList.json")
	public @ResponseBody Map<String, Object> getESSChargeRealList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getESSChargeRealList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> result = essChargeService.getESSChargeRealList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chgSheetList", ((Map<String, Object>) result.get("chgMap")).get("sheetList"));
		resultMap.put("chgChartList", ((Map<String, Object>) result.get("chgMap")).get("chartList"));
		resultMap.put("dischgSheetList", ((Map<String, Object>) result.get("dischgMap")).get("sheetList"));
		resultMap.put("dischgChartList", ((Map<String, Object>) result.get("dischgMap")).get("chartList"));
		return resultMap;
	}

	@RequestMapping("/energy/getESSChargeFutureList.json")
	public @ResponseBody Map<String, Object> getESSChargeFutureList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getESSChargeFutureList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> result = essChargeService.getESSChargeFutureList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chgSheetList", ((Map<String, Object>) result.get("chgMap")).get("sheetList"));
		resultMap.put("chgChartList", ((Map<String, Object>) result.get("chgMap")).get("chartList"));
		resultMap.put("dischgSheetList", ((Map<String, Object>) result.get("dischgMap")).get("sheetList"));
		resultMap.put("dischgChartList", ((Map<String, Object>) result.get("dischgMap")).get("chartList"));
		return resultMap;
	}
	
}
