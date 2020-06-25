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

import kr.co.esp.billRevenue.service.KepcoBillService;

@Controller
public class KepcoBillController {

	private static final Logger logger = LoggerFactory.getLogger(KepcoBillController.class);

	@Resource(name = "kepcoBillService")
	private KepcoBillService kepcoBillService;
	
	@RequestMapping(value = "/billRevenue/kepcoBill.do")
	public String kepcoBill(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/billRevenue/kepcoBill.do");
		return "esp/billRevenue/kepcoBill";
	}

	@RequestMapping("/billRevenue/getKepcoBillList.json")
	public @ResponseBody Map<String, Object> getKepcoBillList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getKepcoBillList.json");
		logger.debug("param ::::: " + param.toString());

		Map<String, Object> list = kepcoBillService.getKepcoBillList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getKepcoTexBillList.json")
	public @ResponseBody Map<String, Object> getKepcoTexBillList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getKepcoTexBillList.json");
		logger.debug("param ::::: " + param.toString());
		Map<String, Object> list = kepcoBillService.getKepcoTexBillList(param);

		Map<String, Object> list2 = kepcoBillService.getKepcoResentBillList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("texList", list.get("result"));
		resultMap.put("sheetList", list2.get("sheetList"));
		resultMap.put("chartList", list2.get("chartList"));
		return resultMap;
	}

	@RequestMapping("/billRevenue/getKepcoTexBill.json")
	public @ResponseBody Map<String, Object> getKepcoTexBill(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/billRevenue/getKepcoTexBill.json");
		logger.debug("param ::::: " + param.toString());
		
		Map<String, Object> list = kepcoBillService.getKepcoTexBillList(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("texList", list.get("result"));
		return resultMap;
	}
	
}
