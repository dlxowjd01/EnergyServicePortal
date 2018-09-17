package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
	public @ResponseBody Map<String, Object> getESSChargeRealList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getESSChargeRealList");
		logger.debug("param ::::: "+param.toString());
		
		List list = essChargeService.getESSChargeRealList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getESSChargeFutureList")
	public @ResponseBody Map<String, Object> getESSChargeFutureList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getESSChargeFutureList");
		logger.debug("param ::::: "+param.toString());
		
		List list = essChargeService.getESSChargeFutureList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
}
