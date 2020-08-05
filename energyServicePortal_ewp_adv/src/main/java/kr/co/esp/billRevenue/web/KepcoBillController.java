package kr.co.esp.billRevenue.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class KepcoBillController {
	private static final Logger logger = LoggerFactory.getLogger(KepcoBillController.class);

	@RequestMapping(value = "/billRevenue/kepcoBill.do")
	public String kepcoBill(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/billRevenue/kepcoBill";
	}
}
