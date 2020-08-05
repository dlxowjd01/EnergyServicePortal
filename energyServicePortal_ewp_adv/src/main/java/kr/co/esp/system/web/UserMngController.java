package kr.co.esp.system.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class UserMngController {

	private static final Logger logger = LoggerFactory.getLogger(UserMngController.class);
	
	@RequestMapping(value = "/system/userMng.do")
	public String userMng(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/system/userMng.do");
		return "esp/system/userMng";
	}

	//페이지 이동
	@RequestMapping(value = "/system/cmmnCdMng.do")
	public String cmmnCdMng(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/system/cmmnCdMng.do");
		return "esp/system/cmmnCdMng";
	}
}
