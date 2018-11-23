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

import kr.co.ewp.ewpsp.service.DRResultService;
import kr.co.ewp.ewpsp.service.DRRevenueService;
import kr.co.ewp.ewpsp.service.UsageService;

@Controller
public class DRRevenueController {

	private static final Logger logger = LoggerFactory.getLogger(DRRevenueController.class);
	
	@Resource(name="drRevenueService")
	private DRRevenueService drRevenueService;

	@RequestMapping("/drRevenue")
	public String main(Model model) {
		logger.debug("/drRevenue");
		
		return "ewp/billRevenue/drRevenue";
	}
	
	@RequestMapping("/getDRRevenueList")
	public @ResponseBody Map<String, Object> getDRRevenueList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDRRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		Map list = drRevenueService.getDRRevenueList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}
	
	@RequestMapping("/getDRRevenueTexList")
	public @ResponseBody Map<String, Object> getDRRevenueTexList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDRRevenueTexList");
		logger.debug("param ::::: "+param.toString());
		
		Map list = drRevenueService.getDRRevenueTexList(param);
		
		Map list2 = drRevenueService.getDRRevenueChartList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("result"));
		resultMap.put("chartList", list2.get("chartList"));
		return resultMap;
	}
	
}
