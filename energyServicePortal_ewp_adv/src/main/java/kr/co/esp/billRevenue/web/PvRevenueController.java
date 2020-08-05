package kr.co.esp.billRevenue.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class PvRevenueController {
	private static final Logger logger = LoggerFactory.getLogger(PvRevenueController.class);

	@RequestMapping(value = "/billRevenue/pvRevenue.do")
	public String pvRevenue(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/billRevenue/pvRevenue";
	}
}
