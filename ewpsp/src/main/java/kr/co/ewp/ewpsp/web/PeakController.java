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

import kr.co.ewp.ewpsp.service.PeakService;

@Controller
public class PeakController {

	private static final Logger logger = LoggerFactory.getLogger(PeakController.class);

	@Resource(name="peakService")
	private PeakService peakService;

	@RequestMapping("/peak")
	public String main() {
		logger.debug("/peak");
		return "ewp/energy/peak";
	}

	@RequestMapping("/getPeakRealList")
	public @ResponseBody Map<String, Object> getPeakRealList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPeakRealList");
		logger.debug("param ::::: "+param.toString());
		
		List list = peakService.getPeakRealList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getContractPowerList")
	public @ResponseBody Map<String, Object> getContractPowerList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPeakFutureList");
		logger.debug("param ::::: "+param.toString());
		
		List list = peakService.getContractPowerList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getChargePowerList")
	public @ResponseBody Map<String, Object> getChargePowerList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPeakFutureList");
		logger.debug("param ::::: "+param.toString());
		
		List list = peakService.getChargePowerList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
}
