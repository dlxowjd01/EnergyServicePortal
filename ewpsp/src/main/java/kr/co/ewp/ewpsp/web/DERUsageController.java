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

import kr.co.ewp.ewpsp.service.DERUsageService;
import kr.co.ewp.ewpsp.service.UsageService;

@Controller
public class DERUsageController {

	private static final Logger logger = LoggerFactory.getLogger(DERUsageController.class);

	@Resource(name="derUsageService")
	private DERUsageService derUsageService;

	@Resource(name="usageService")
	private UsageService usageService;

	@RequestMapping("/derUsage")
	public String main() {
		logger.debug("/derUsage");
		
		return "ewp/energy/derUsage";
	}

	@RequestMapping("/getESSUsageList")
	public @ResponseBody Map<String, Object> getESSUsageList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getESSUsageList");
		logger.debug("param ::::: "+param.toString());
		
		List list = derUsageService.getESSUsageList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getPVUsageList")
	public @ResponseBody Map<String, Object> getPVUsageList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPVUsageList");
		logger.debug("param ::::: "+param.toString());
		
		List list = derUsageService.getPVUsageList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getDERUsageList")
	public @ResponseBody Map<String, Object> getDERUsageList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDERUsageList");
		logger.debug("param ::::: "+param.toString());
		
		List kepcoUsageList = usageService.getUsageRealList(param); // 한전 사용량
		List essUsageList = derUsageService.getESSUsageList(param);// ESS 사용량
		List pvUsageList = derUsageService.getPVUsageList(param); // PV 사용량
		
		List loopCntList = null;
		if(kepcoUsageList != null && kepcoUsageList.size() > 0) {
			loopCntList = kepcoUsageList;
		} else if(essUsageList != null && essUsageList.size() > 0) {
			loopCntList = essUsageList;
		} else if(pvUsageList != null && pvUsageList.size() > 0) {
			loopCntList = pvUsageList;
		}
		System.out.println("loopCntList : "+loopCntList+", "+loopCntList.toString());
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("kepcoUsageList", kepcoUsageList);
		resultMap.put("essUsageList", essUsageList);
		resultMap.put("pvUsageList", pvUsageList);
		resultMap.put("loopCntList", loopCntList);
		return resultMap;
	}
	
}
