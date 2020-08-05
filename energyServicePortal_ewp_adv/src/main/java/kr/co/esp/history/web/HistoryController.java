package kr.co.esp.history.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class HistoryController {

	private static final Logger logger = LoggerFactory.getLogger(HistoryController.class);

	@RequestMapping(value = "/history/operationHistory.do")
	public String operationHistory(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/history/operationHistory";
	}

	@RequestMapping(value = "/history/alarmHistory.do")
	public String alarmHistory(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/history/alarmHistory";
	}
}
