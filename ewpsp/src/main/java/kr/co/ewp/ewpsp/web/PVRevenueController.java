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
		
//		List list = usageService.usageList();
//		model.addAttribute("list", list);
		
		return "ewp/billRevenue/pvRevenue";
	}
	
	@RequestMapping("/getPVRevenueList")
	public @ResponseBody Map<String, Object> getPVRevenueList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPVRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		param.put("selPeriodVal", "month");
		
		Map result = pvRevenueService.getPVRevenueList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultListMap", result);
		return resultMap;
	}
	
	@RequestMapping("/getPVRevenueList_test")
	public @ResponseBody Map<String, Object> getPVRevenueList_test(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPVRevenueList_test");
		logger.debug("param ::::: "+param.toString());
		
		List list = pvRevenueService.getPVRevenueList_test(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
}
