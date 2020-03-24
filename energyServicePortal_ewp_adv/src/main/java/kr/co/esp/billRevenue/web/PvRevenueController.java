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

import kr.co.esp.billRevenue.service.PvRevenueService;
import kr.co.esp.energy.PeriodDataSetting;

@Controller
public class PvRevenueController {

	private static final Logger logger = LoggerFactory.getLogger(PvRevenueController.class);

	@Resource(name = "pvRevenueService")
	private PvRevenueService pvRevenueService;

	@RequestMapping(value = "/billRevenue/pvRevenue.do")
	public String pvRevenue(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/billRevenue/pvRevenue.do");
		return "esp/billRevenue/pvRevenue";
	}

	@RequestMapping("/billRevenue/getPVRevenueList.json")
	public @ResponseBody Map<String, Object> getPVRevenueList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/billRevenue/getPVRevenueList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		param.put("selPeriodVal", "month");
		Map<String, Object> result = pvRevenueService.getPVRevenueList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("netGenValSheetList", ((Map<String, Object>) result.get("netGenValMap")).get("sheetList"));
		resultMap.put("netGenValChartList", ((Map<String, Object>) result.get("netGenValMap")).get("chartList"));
		resultMap.put("smpDealSheetList", ((Map<String, Object>) result.get("smpDealMap")).get("sheetList"));
		resultMap.put("smpDealChartList", ((Map<String, Object>) result.get("smpDealMap")).get("chartList"));
		resultMap.put("smpPriceSheetList", ((Map<String, Object>) result.get("smpPriceMap")).get("sheetList"));
		resultMap.put("smpPriceChartList", ((Map<String, Object>) result.get("smpPriceMap")).get("chartList"));
		resultMap.put("recDealSheetList", ((Map<String, Object>) result.get("recDealMap")).get("sheetList"));
		resultMap.put("recDealChartList", ((Map<String, Object>) result.get("recDealMap")).get("chartList"));
		resultMap.put("recPriceSheetList", ((Map<String, Object>) result.get("recPriceMap")).get("sheetList"));
		resultMap.put("recPriceChartList", ((Map<String, Object>) result.get("recPriceMap")).get("chartList"));
		resultMap.put("totPriceSheetList", ((Map<String, Object>) result.get("totPriceMap")).get("sheetList"));
		resultMap.put("totPriceChartList", ((Map<String, Object>) result.get("totPriceMap")).get("chartList"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getPVRevenueTexList.json")
	public @ResponseBody Map<String, Object> getPVRevenueTexList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/billRevenue/getPVRevenueTexList.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		param.put("selPeriodVal", "month");

		Map<String, Object> result = pvRevenueService.getPVRevenueList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("netGenValSheetList", ((Map<String, Object>) result.get("netGenValMap")).get("sheetList"));
		resultMap.put("netGenValChartList", ((Map<String, Object>) result.get("netGenValMap")).get("chartList"));
		resultMap.put("smpDealSheetList", ((Map<String, Object>) result.get("smpDealMap")).get("sheetList"));
		resultMap.put("smpDealChartList", ((Map<String, Object>) result.get("smpDealMap")).get("chartList"));
		resultMap.put("smpPriceSheetList", ((Map<String, Object>) result.get("smpPriceMap")).get("sheetList"));
		resultMap.put("smpPriceChartList", ((Map<String, Object>) result.get("smpPriceMap")).get("chartList"));
		resultMap.put("recDealSheetList", ((Map<String, Object>) result.get("recDealMap")).get("sheetList"));
		resultMap.put("recDealChartList", ((Map<String, Object>) result.get("recDealMap")).get("chartList"));
		resultMap.put("recPriceSheetList", ((Map<String, Object>) result.get("recPriceMap")).get("sheetList"));
		resultMap.put("recPriceChartList", ((Map<String, Object>) result.get("recPriceMap")).get("chartList"));
		resultMap.put("totPriceSheetList", ((Map<String, Object>) result.get("totPriceMap")).get("sheetList"));
		resultMap.put("totPriceChartList", ((Map<String, Object>) result.get("totPriceMap")).get("chartList"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getPVRevenueTex.json")
	public @ResponseBody Map<String, Object> getPVRevenueTex(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/billRevenue/getPVRevenueTex.json");
		logger.debug("param ::::: " + param.toString());

		param = PeriodDataSetting.setSearchTerm(param);

		param.put("selPeriodVal", "month");

		Map<String, Object> result = pvRevenueService.getPVRevenueList(param, request);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("netGenValSheetList", ((Map<String, Object>) result.get("netGenValMap")).get("sheetList"));
		resultMap.put("netGenValChartList", ((Map<String, Object>) result.get("netGenValMap")).get("chartList"));
		resultMap.put("smpDealSheetList", ((Map<String, Object>) result.get("smpDealMap")).get("sheetList"));
		resultMap.put("smpDealChartList", ((Map<String, Object>) result.get("smpDealMap")).get("chartList"));
		resultMap.put("smpPriceSheetList", ((Map<String, Object>) result.get("smpPriceMap")).get("sheetList"));
		resultMap.put("smpPriceChartList", ((Map<String, Object>) result.get("smpPriceMap")).get("chartList"));
		resultMap.put("recDealSheetList", ((Map<String, Object>) result.get("recDealMap")).get("sheetList"));
		resultMap.put("recDealChartList", ((Map<String, Object>) result.get("recDealMap")).get("chartList"));
		resultMap.put("recPriceSheetList", ((Map<String, Object>) result.get("recPriceMap")).get("sheetList"));
		resultMap.put("recPriceChartList", ((Map<String, Object>) result.get("recPriceMap")).get("chartList"));
		resultMap.put("totPriceSheetList", ((Map<String, Object>) result.get("totPriceMap")).get("sheetList"));
		resultMap.put("totPriceChartList", ((Map<String, Object>) result.get("totPriceMap")).get("chartList"));
		return resultMap;
	}
	
}
