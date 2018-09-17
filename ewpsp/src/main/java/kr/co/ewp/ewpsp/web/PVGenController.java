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

import kr.co.ewp.ewpsp.service.PVGenService;

@Controller
public class PVGenController {

	private static final Logger logger = LoggerFactory.getLogger(PVGenController.class);

	@Resource(name="pvGenService")
	private PVGenService pvGenService;

	@RequestMapping("/pvGen")
	public String main() {
		logger.debug("/pvGen");
		return "ewp/energy/pvGen";
	}

	@RequestMapping("/getPVGenRealList")
	public @ResponseBody Map<String, Object> getPVGenRealList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPVGenRealList");
		logger.debug("param ::::: "+param.toString());
		
		List list = pvGenService.getPVGenRealList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/getPVGenFutureList")
	public @ResponseBody Map<String, Object> getPVGenFutureList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPVGenFutureList");
		logger.debug("param ::::: "+param.toString());
		
		List list = pvGenService.getPVGenFutureList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
}
