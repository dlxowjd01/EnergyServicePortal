package kr.co.esp.energy.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class PvGenController {
	private static final Logger logger = LoggerFactory.getLogger(PvGenController.class);

	@RequestMapping(value = "/energy/pvGen.do")
	public String pvGen(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/energy/pvGen";
	}
}
