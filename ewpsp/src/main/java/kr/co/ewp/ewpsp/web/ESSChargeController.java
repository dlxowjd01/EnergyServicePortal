/**
 * class name : ESSChargeController
 * description : 충방전량 화면 controller
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.service.ESSChargeService;

@Controller
public class ESSChargeController {

	private static final Logger logger = LoggerFactory.getLogger(ESSChargeController.class);

	@Resource(name="essChargeService")
	private ESSChargeService essChargeService;

	@RequestMapping("/essCharge")
	public String main() {
		logger.debug("/essCharge");
		
		return "ewp/energy/essCharge";
	}

	@RequestMapping("/getESSChargeRealList")
	public @ResponseBody Map<String, Object> getESSChargeRealList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getESSChargeRealList");
		logger.debug("param ::::: "+param.toString());
		
		Map result = essChargeService.getESSChargeRealList(param, request);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chgSheetList", ((Map) result.get("chgMap")).get("sheetList") );
		resultMap.put("chgChartList", ((Map) result.get("chgMap")).get("chartList") );
		resultMap.put("dischgSheetList", ((Map) result.get("dischgMap")).get("sheetList") );
		resultMap.put("dischgChartList", ((Map) result.get("dischgMap")).get("chartList") );
		return resultMap;
	}
	
	@RequestMapping("/getESSChargeFutureList")
	public @ResponseBody Map<String, Object> getESSChargeFutureList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getESSChargeFutureList");
		logger.debug("param ::::: "+param.toString());
		
		Map result = essChargeService.getESSChargeFutureList(param, request);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chgSheetList", ((Map) result.get("chgMap")).get("sheetList") );
		resultMap.put("chgChartList", ((Map) result.get("chgMap")).get("chartList") );
		resultMap.put("dischgSheetList", ((Map) result.get("dischgMap")).get("sheetList") );
		resultMap.put("dischgChartList", ((Map) result.get("dischgMap")).get("chartList") );
		return resultMap;
	}
}
