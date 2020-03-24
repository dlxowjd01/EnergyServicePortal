package kr.co.esp.billRevenue.web;

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

import kr.co.esp.billRevenue.service.DrRevenueService;

@Controller
public class DrRevenueController {

	private static final Logger logger = LoggerFactory.getLogger(DrRevenueController.class);

	@Resource(name = "drRevenueService")
	private DrRevenueService drRevenueService;

	@RequestMapping(value = "/billRevenue/drRevenue.do")
	public String drRevenue(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/billRevenue/drRevenue.do");
		return "esp/billRevenue/drRevenue";
	}

	@RequestMapping("/billRevenue/getDRRevenueList.json")
	public @ResponseBody Map<String, Object> getDRRevenueList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getDRRevenueList.json");
		logger.debug("param ::::: " + param.toString());

		Map<String, Object> list = drRevenueService.getDRRevenueList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getDRRevenueTexList.json")
	public @ResponseBody Map<String, Object> getDRRevenueTexList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getDRRevenueTexList.json");
		logger.debug("param ::::: " + param.toString());

		Map<String, Object> list = drRevenueService.getDRRevenueTexList(param);

		Map<String, Object> list2 = drRevenueService.getDRRevenueChartList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("result"));
		resultMap.put("chartList", list2.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getDRRevenueTex.json")
	public @ResponseBody Map<String, Object> getDRRevenueTex(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getDRRevenueTex.json");
		logger.debug("param ::::: " + param.toString());

		Map<String, Object> list = drRevenueService.getDRRevenueTexList(param);


		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("result"));
		return resultMap;
	}
	
}
