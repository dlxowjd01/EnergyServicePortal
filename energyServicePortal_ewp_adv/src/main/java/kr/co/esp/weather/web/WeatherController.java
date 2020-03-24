package kr.co.esp.weather.web;

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

import kr.co.esp.weather.service.WeatherService;


@Controller
public class WeatherController {

	private static final Logger logger = LoggerFactory.getLogger(WeatherController.class);
	
	@Resource(name="weatherService")
	private WeatherService weatherService;
	
	@RequestMapping(value = "/weather/weatherSelect.do")
	public String totalMonitoring(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/weather/weatherSelect.do");		
		
//		model.addAttribute("modelVal", 6);
		
		return "esp/weather/weatherSelect";
	}

	// select sido
	@RequestMapping("/weather/getSido.json")
	public @ResponseBody Map<String, Object> getSido(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/weather/getSido.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = weatherService.getSido(param);
		
		return resultMap;
	}
	
	// select sigungu
	@RequestMapping("/weather/getSigungu.json")
	public @ResponseBody Map<String, Object> getSigungu(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/weather/getSigungu.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = weatherService.getSigungu(param);
		
		return resultMap;
	}	
		
	// select eub
	@RequestMapping("/weather/getEub.json")
	public @ResponseBody Map<String, Object> getEub(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/weather/getEub.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = weatherService.getEub(param);
		
		return resultMap;
	}	
	
	
	// 기상청 OpenAPI 동네날씨 가져오기
	@RequestMapping("/weather/getWeather.json")
	public @ResponseBody Map<String, Object> getWeather(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/weather/getWeather.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = weatherService.getWeather(param);
		
		return resultMap;
	}	
	
	// 기상청 OpenAPI 중기날씨 가져오기
	@RequestMapping("/weather/getMidWeather.json")
	public @ResponseBody Map<String, Object> getMidWeather(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/weather/getMidWeather.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = weatherService.getMidWeather(param);
		
		return resultMap;
	}
	
	// 기상청 OpenAPI 중기날씨 온도 가져오기
	@RequestMapping("/weather/getMidTempWeather.json")
	public @ResponseBody Map<String, Object> getMidTempWeather(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/weather/getMidTempWeather.json");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = weatherService.getMidTempWeather(param);
//		resultMap.put("mapVal", 5);
		
		return resultMap;
	}	

}

