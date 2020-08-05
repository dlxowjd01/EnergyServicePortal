package kr.co.esp.billRevenue.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class EssRevenueController {
	private static final Logger logger = LoggerFactory.getLogger(EssRevenueController.class);

	@RequestMapping(value = "/billRevenue/essRevenue.do")
	public String essRevenue(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/billRevenue/essRevenue.do");
		return "esp/billRevenue/essRevenue";
	}
}
