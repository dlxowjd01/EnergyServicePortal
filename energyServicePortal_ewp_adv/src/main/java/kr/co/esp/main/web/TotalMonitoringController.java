package kr.co.esp.main.web;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

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

import kr.co.esp.main.service.TotalMonitoringService;


@Controller
public class TotalMonitoringController {

	private static final Logger logger = LoggerFactory.getLogger(TotalMonitoringController.class);
	
	@Resource(name="totalMonitoringService")
	private TotalMonitoringService totalMonitoringService;
	
	@RequestMapping(value = "/main/totalMonitoring.do")
	public String totalMonitoring(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/main/totalMonitoring.do");		
		return "esp/main/totalMonitoring";
	}

	// 사업소별 현황
	@RequestMapping("/main/getDailyPowerChartPerSiteOnToday.json")
	public @ResponseBody Map<String, Object> getDailyPowerChartPerSiteOnToday(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("main/getDailyPowerChartPerSiteOnToday.json");
		logger.debug("param ::::: {}", param);		
		Map<String, Object> resultMap = totalMonitoringService.getDailyPowerChartPerSiteOnToday(param);
		
		return resultMap;
	}
	
	// 신재생유형별 현황
	@RequestMapping("/main/getDailyPowerChartPerEnergeKindOnToday.json")
	public @ResponseBody Map<String, Object> getDailyPowerChartPerEnergeKindOnToday(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/main/getDailyPowerChartPerEnergeKindOnToday.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = totalMonitoringService.getDailyPowerChartPerEnergeKindOnToday(param);
		
		return resultMap;
	}
	
	// data 존재 일자
	@RequestMapping("/main/getDataExistMonth.json")
	public @ResponseBody Map<String, Object> getDataExistMonth(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("main/getDataExistMonth.json");
		logger.debug("param ::::: {}", param);

		Map<String, Object> resultMap = totalMonitoringService.getDataExistMonth(param);
		
		
		return resultMap;
	}	
	

	// 전월비교 월 발전량 추이 chart
	@RequestMapping("/main/getDailyPowerChartIn2Month.json")
	public @ResponseBody Map<String, Object> getDailyPowerChartIn2Month(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("main/getDailyPowerChartIn2Month.json");
		logger.debug("param ::::: {}", param);

		Map<String, Object> resultMap = totalMonitoringService.getDailyPowerChartIn2Month(param);
		
		
		return resultMap;
	}

	
	// 전년비교 년 발전량 추이 chart
	@RequestMapping("/main/getMonthlyPowerChartIn2Year.json")
	public @ResponseBody Map<String, Object> getMonthlyPowerChartIn2Year(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("main/getMonthlyPowerChartIn2Year.json");
		logger.debug("param ::::: {}", param);

		Map<String, Object> resultMap = totalMonitoringService.getMonthlyPowerChartIn2Year(param);
		
		
		return resultMap;
	}
	
	
	// 사이트별 인버터갯수, 금일발전량, 예상발전량, 이용률, ...
	@RequestMapping("/main/getSiteInfo.json")
	public @ResponseBody Map<String, Object> getSiteInfo(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/main/getSiteInfo.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = totalMonitoringService.getSiteInfo(param);
		
		
		return resultMap;
	}
	
	
	// alarm 정보
	@RequestMapping("/main/getAlarmInfo.json")
	public @ResponseBody Map<String, Object> getAlarmInfo(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/main/getAlarmInfo.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = totalMonitoringService.getAlarmInfo(param);
		
		
		return resultMap;
	}
}
