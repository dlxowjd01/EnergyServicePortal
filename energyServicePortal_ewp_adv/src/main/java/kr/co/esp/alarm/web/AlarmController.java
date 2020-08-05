package kr.co.esp.alarm.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class AlarmController {
	private static final Logger logger = LoggerFactory.getLogger(AlarmController.class);

	@RequestMapping(value = "/alarm/alarmMng.do")
	public String alarmMng(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/alarm/alarmMng.do");
		return "esp/alarm/alarmMng";
	}
}
