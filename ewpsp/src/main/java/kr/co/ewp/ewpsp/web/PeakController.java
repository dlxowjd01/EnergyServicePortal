/**
 * class name : PeakController
 * description : 피크전력 현황 화면 controller
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
	public @ResponseBody Map<String, Object> getPeakRealList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getPeakRealList");
		logger.debug("param ::::: "+param.toString());
		
		Map list = peakService.getPeakRealList(param, request);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("sheetList", list.get("sheetList"));
		resultMap.put("chartList", list.get("chartList"));
		return resultMap;
	}
	
}
