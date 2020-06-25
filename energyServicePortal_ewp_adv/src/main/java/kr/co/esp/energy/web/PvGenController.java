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
import kr.co.esp.energy.service.PvGenService;

@Controller
public class PvGenController {

	private static final Logger logger = LoggerFactory.getLogger(PvGenController.class);
	
	@Resource(name="pvGenService")
	private PvGenService pvGenService;
	
	@RequestMapping(value = "/energy/pvGen.do")
	public String pvGen(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/energy/pvGen.do");
		return "esp/energy/pvGen";
	}

	@RequestMapping("/energy/getPVGenRealList.json")
	public @ResponseBody Map<String, Object> getPVGenRealList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getPVGenRealList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> list = pvGenService.getPVGenRealList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/energy/getPVGenFutureList.json")
	public @ResponseBody Map<String, Object> getPVGenFutureList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/energy/getPVGenFutureList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		Map<String, Object> list = pvGenService.getPVGenFutureList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}
	
}
