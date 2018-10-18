/**
 * class name : DRResultController
 * description : DR 실적 조회 화면 controller
 * version : 1.0
 * author : 이우람
 */

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

import kr.co.ewp.ewpsp.service.DRResultService;

@Controller
public class DRResultController {

	private static final Logger logger = LoggerFactory.getLogger(DRResultController.class);

	@Resource(name="drResultService")
	private DRResultService drResultService;

	@RequestMapping("/drResult")
	public String main() {
		logger.debug("/drResult");
		
		return "ewp/energy/drResult";
	}

	@RequestMapping("/getDRResultList")
	public @ResponseBody Map<String, Object> getDRResultList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDRResultList");
		logger.debug("param ::::: "+param.toString());
		
		List list = drResultService.getDRResultList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
}
