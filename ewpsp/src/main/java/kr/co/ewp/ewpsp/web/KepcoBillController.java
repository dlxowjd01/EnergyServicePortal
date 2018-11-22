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

import kr.co.ewp.ewpsp.service.KepcoBillService;

@Controller
public class KepcoBillController {

	private static final Logger logger = LoggerFactory.getLogger(KepcoBillController.class);
	
	@Resource(name="kepcoBillService")
	private KepcoBillService kepcoBillService;

	@RequestMapping("/kepcoBill")
	public String main(Model model) {
		logger.debug("/kepcoBill");
		
		return "ewp/billRevenue/kepcoBill";
	}
	
	@RequestMapping("/getKepcoBillList")
	public @ResponseBody Map<String, Object> getKepcoBillList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getKepcoBillList");
		logger.debug("param ::::: "+param.toString());
		
		Map list = kepcoBillService.getKepcoBillList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}
	
	@RequestMapping("/getKepcoTexBillList")
	public @ResponseBody Map<String, Object> getKepcoTexBillList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getKepcoTexBillList");
		logger.debug("param ::::: "+param.toString());
		System.out.println("param 텍스리스트:" + param);
		Map list = kepcoBillService.getKepcoTexBillList(param);
		
		Map list2 = kepcoBillService.getKepcoResentBillList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("texList", list.get("result"));
		resultMap.put("sheetList", list2.get("sheetList"));
		resultMap.put("chartList", list2.get("chartList"));
		return resultMap;
	}
	
}
