package kr.co.esp.energy.web;

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

import kr.co.esp.energy.PeriodDataSetting;
import kr.co.esp.energy.service.PeakService;

@Controller
public class PeakController {

	private static final Logger logger = LoggerFactory.getLogger(PeakController.class);
	
	@Resource(name="peakService")
	private PeakService peakService;
	
	@RequestMapping(value = "/energy/peak.do")
	public String peak(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/energy/peak.do");
		return "esp/energy/peak";
	}

    @RequestMapping("/energy/getPeakRealList.json")
    public @ResponseBody Map<String, Object> getPeakRealList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
        logger.debug("/energy/getPeakRealList.json");
        logger.debug("param ::::: " + param.toString());

        param = PeriodDataSetting.setSearchTerm(param);

        Map<String, Object> list = peakService.getPeakRealList(param, request);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("sheetList", list.get("sheetList"));
        resultMap.put("chartList", list.get("chartList"));
        return resultMap;
    }
	
}
