package kr.co.esp.system.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class KepcoMngController {

	private static final Logger logger = LoggerFactory.getLogger(KepcoMngController.class);

	@RequestMapping(value = "/system/kepcoMng.do")
	public String kepcoMng(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/kepcoMng";
	}
}
