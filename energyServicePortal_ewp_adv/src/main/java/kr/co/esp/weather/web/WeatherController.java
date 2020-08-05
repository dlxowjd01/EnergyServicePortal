package kr.co.esp.weather.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


@Controller
public class WeatherController {

	private static final Logger logger = LoggerFactory.getLogger(WeatherController.class);

	@RequestMapping(value = "/weather/weatherSelect.do")
	public String totalMonitoring(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/weather/weatherSelect";
	}
}

