/**
 * class name : DERUsageController
 * description : 사용량구성 화면 controller
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

import kr.co.ewp.ewpsp.service.DERUsageService;
import kr.co.ewp.ewpsp.service.PVGenService;
import kr.co.ewp.ewpsp.service.UsageService;

@Controller
public class DERUsageController {

	private static final Logger logger = LoggerFactory.getLogger(DERUsageController.class);

	@Resource(name="derUsageService")
	private DERUsageService derUsageService;

	@Resource(name="usageService")
	private UsageService usageService;

	@Resource(name="pvGenService")
	private PVGenService pvGenService;

	@RequestMapping("/derUsage")
	public String main() {
		logger.debug("/derUsage");
		
		return "ewp/energy/derUsage";
	}

	@RequestMapping("/getESSUsageList")
	public @ResponseBody Map<String, Object> getESSUsageList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getESSUsageList");
		logger.debug("param ::::: "+param.toString());
		
		Map list = derUsageService.getESSUsageList(param, request);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}
	
	@RequestMapping("/getDERUsageList")
	public @ResponseBody Map<String, Object> getDERUsageList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDERUsageList");
		logger.debug("param ::::: "+param.toString());
		
		Map kepcoUsageList = usageService.getUsageRealList(param, request); // 한전 사용량
		Map essUsageList = derUsageService.getESSUsageList(param, request);// ESS 사용량
//		List pvUsageList = derUsageService.getPVUsageList(param); // PV 사용량
		Map pvUsageList = pvGenService.getPVGenRealList(param, request); // PV 사용량
		
		List loopCntSheetList = null;
		List loopCntChartList = null;
		if(kepcoUsageList != null && kepcoUsageList.size() > 0) {
			loopCntSheetList = (List) kepcoUsageList.get("sheetList");
			loopCntChartList = (List) kepcoUsageList.get("chartList");
		} else if(essUsageList != null && essUsageList.size() > 0) {
			loopCntSheetList = (List) essUsageList.get("sheetList");
			loopCntChartList = (List) essUsageList.get("chartList");
		} else if(pvUsageList != null && pvUsageList.size() > 0) {
			loopCntSheetList = (List) pvUsageList.get("sheetList");
			loopCntChartList = (List) pvUsageList.get("chartList");
		}
		System.out.println("loopCntSheetList   "+loopCntSheetList);
		System.out.println("loopCntChartList          "+loopCntChartList);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("kepcoUsageSheetList", kepcoUsageList.get("sheetList"));
		resultMap.put("kepcoUsageChartList", kepcoUsageList.get("chartList"));
		resultMap.put("essUsageListSheetList", essUsageList.get("sheetList"));
		resultMap.put("essUsageListChartList", essUsageList.get("chartList"));
		resultMap.put("pvUsageListSheetList", pvUsageList.get("sheetList"));
		resultMap.put("pvUsageListChartList", pvUsageList.get("chartList"));
		resultMap.put("loopCntSheetList", loopCntSheetList);
		resultMap.put("loopCntChartList", loopCntChartList);
		
		return resultMap;
	}
	
}
