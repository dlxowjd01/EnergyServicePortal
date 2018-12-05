/**
 * class name : PVRevenueController
 * description : PV 요금 수익 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.List;
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

import kr.co.ewp.ewpsp.service.PVRevenueService;
import kr.co.ewp.ewpsp.service.UsageService;

@Controller
public class PVRevenueController {

	private static final Logger logger = LoggerFactory.getLogger(PVRevenueController.class);
	
	@Resource(name="pvRevenueService")
	private PVRevenueService pvRevenueService;

	@RequestMapping("/pvRevenue")
	public String main(Model model) {
		logger.debug("/pvRevenue");
		
		return "ewp/billRevenue/pvRevenue";
	}
	
	@RequestMapping("/getPVRevenueList")
	public @ResponseBody Map<String, Object> getPVRevenueList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getPVRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		param.put("selPeriodVal", "month");
		Map result = pvRevenueService.getPVRevenueList(param, request);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("resultListMap", result);
		resultMap.put("netGenValSheetList", ((Map) result.get("netGenValMap")).get("sheetList") );
		resultMap.put("netGenValChartList", ((Map) result.get("netGenValMap")).get("chartList") );
		resultMap.put("smpDealSheetList", ((Map) result.get("smpDealMap")).get("sheetList") );
		resultMap.put("smpDealChartList", ((Map) result.get("smpDealMap")).get("chartList") );
		resultMap.put("smpPriceSheetList", ((Map) result.get("smpPriceMap")).get("sheetList") );
		resultMap.put("smpPriceChartList", ((Map) result.get("smpPriceMap")).get("chartList") );
		resultMap.put("recDealSheetList", ((Map) result.get("recDealMap")).get("sheetList") );
		resultMap.put("recDealChartList", ((Map) result.get("recDealMap")).get("chartList") );
		resultMap.put("recPriceSheetList", ((Map) result.get("recPriceMap")).get("sheetList") );
		resultMap.put("recPriceChartList", ((Map) result.get("recPriceMap")).get("chartList") );
		resultMap.put("totPriceSheetList", ((Map) result.get("totPriceMap")).get("sheetList") );
		resultMap.put("totPriceChartList", ((Map) result.get("totPriceMap")).get("chartList") );
		return resultMap;
	}
	
	@RequestMapping("/getPVRevenueTexList")
	public @ResponseBody Map<String, Object> getPVRevenueTexList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getPVRevenueTexList");
		logger.debug("param ::::: "+param.toString());
		param.put("selPeriodVal", "month");
		
		Map result = pvRevenueService.getPVRevenueList(param, request);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("resultListMap", result);
		resultMap.put("netGenValSheetList", ((Map) result.get("netGenValMap")).get("sheetList") );
		resultMap.put("netGenValChartList", ((Map) result.get("netGenValMap")).get("chartList") );
		resultMap.put("smpDealSheetList", ((Map) result.get("smpDealMap")).get("sheetList") );
		resultMap.put("smpDealChartList", ((Map) result.get("smpDealMap")).get("chartList") );
		resultMap.put("smpPriceSheetList", ((Map) result.get("smpPriceMap")).get("sheetList") );
		resultMap.put("smpPriceChartList", ((Map) result.get("smpPriceMap")).get("chartList") );
		resultMap.put("recDealSheetList", ((Map) result.get("recDealMap")).get("sheetList") );
		resultMap.put("recDealChartList", ((Map) result.get("recDealMap")).get("chartList") );
		resultMap.put("recPriceSheetList", ((Map) result.get("recPriceMap")).get("sheetList") );
		resultMap.put("recPriceChartList", ((Map) result.get("recPriceMap")).get("chartList") );
		resultMap.put("totPriceSheetList", ((Map) result.get("totPriceMap")).get("sheetList") );
		resultMap.put("totPriceChartList", ((Map) result.get("totPriceMap")).get("chartList") );
		return resultMap;
	}
	
	@RequestMapping("/getPVRevenueTex")
	public @ResponseBody Map<String, Object> getPVRevenueTex(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getPVRevenueTex");
		logger.debug("param ::::: "+param.toString());
		param.put("selPeriodVal", "month");
		
		Map result = pvRevenueService.getPVRevenueList(param, request);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("resultListMap", result);
		resultMap.put("netGenValSheetList", ((Map) result.get("netGenValMap")).get("sheetList") );
		resultMap.put("netGenValChartList", ((Map) result.get("netGenValMap")).get("chartList") );
		resultMap.put("smpDealSheetList", ((Map) result.get("smpDealMap")).get("sheetList") );
		resultMap.put("smpDealChartList", ((Map) result.get("smpDealMap")).get("chartList") );
		resultMap.put("smpPriceSheetList", ((Map) result.get("smpPriceMap")).get("sheetList") );
		resultMap.put("smpPriceChartList", ((Map) result.get("smpPriceMap")).get("chartList") );
		resultMap.put("recDealSheetList", ((Map) result.get("recDealMap")).get("sheetList") );
		resultMap.put("recDealChartList", ((Map) result.get("recDealMap")).get("chartList") );
		resultMap.put("recPriceSheetList", ((Map) result.get("recPriceMap")).get("sheetList") );
		resultMap.put("recPriceChartList", ((Map) result.get("recPriceMap")).get("chartList") );
		resultMap.put("totPriceSheetList", ((Map) result.get("totPriceMap")).get("sheetList") );
		resultMap.put("totPriceChartList", ((Map) result.get("totPriceMap")).get("chartList") );
		return resultMap;
	}
	
}
