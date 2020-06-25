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

import kr.co.esp.billRevenue.service.EssRevenueService;

@Controller
public class EssRevenueController {

	private static final Logger logger = LoggerFactory.getLogger(EssRevenueController.class);

	@Resource(name = "essRevenueService")
	private EssRevenueService essRevenueService;
	
	@RequestMapping(value = "/billRevenue/essRevenue.do")
	public String essRevenue(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/billRevenue/essRevenue.do");
		return "esp/billRevenue/essRevenue";
	}

	@RequestMapping("/billRevenue/getESSRevenueList.json")
	public @ResponseBody Map<String, Object> getESSRevenueList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getESSRevenueList.json");
		logger.debug("param ::::: " + param.toString());

		Map<String, Object> list = essRevenueService.getESSRevenueList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getESSRevenueTexList.json")
	public @ResponseBody Map<String, Object> getESSRevenueTexList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getESSRevenueTexList.json");
		logger.debug("param ::::: " + param.toString());
		Map<String, Object> list = essRevenueService.getESSRevenueTexList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("texList", list.get("result"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getESSRevenueTex.json")
	public @ResponseBody Map<String, Object> getESSRevenueTex(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getESSRevenueTex.json");
		logger.debug("param ::::: " + param.toString());
		Map<String, Object> list = essRevenueService.getESSRevenueTexList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("texList", list.get("result"));
		return resultMap;
	}
	
}
