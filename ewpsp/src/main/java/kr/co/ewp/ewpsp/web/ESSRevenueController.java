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

import kr.co.ewp.ewpsp.service.ESSRevenueService;

@Controller
public class ESSRevenueController {

	private static final Logger logger = LoggerFactory.getLogger(ESSRevenueController.class);
	
	@Resource(name="essRevenueService")
	private ESSRevenueService essRevenueService;

	@RequestMapping("/essRevenue")
	public String main(Model model) {
		logger.debug("/essRevenue");
		
		return "ewp/billRevenue/essRevenue";
	}
	
	@RequestMapping("/getESSRevenueList")
	public @ResponseBody Map<String, Object> getESSRevenueList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getESSRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		Map list = essRevenueService.getESSRevenueList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		System.out.println("resultMap:"+resultMap);
		return resultMap;
	}
	
	@RequestMapping("/getESSRevenueTexList")
	public @ResponseBody Map<String, Object> getESSRevenueTexList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getESSRevenueTexList");
		logger.debug("param ::::: "+param.toString());
		Map list = essRevenueService.getESSRevenueTexList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("texList", list.get("result"));
		return resultMap;
	}
	
}
