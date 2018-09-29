/**
 * class name : UsageController
 * description : 사용자 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.service.LoginService;

@Controller
public class LoginController {

	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

	@Resource(name="loginService")
	private LoginService loginService;

	@RequestMapping("/login")
	public String login(Model model) {
		logger.debug("/login");
		
		return "ewp/login/login";
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session, Model model) {
		logger.debug("/logout");
		
		session.removeAttribute("userInfo");
		
		return "redirect:/login";
	}
	
	@RequestMapping("/loginUser")
	public String loginUser(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/loginUser");
		logger.debug("param ::::: "+param.toString());
		
		Map result = loginService.getUserDetail(param);
		logger.debug("result : "+result);
		
		if (result != null && CommonUtils.isEmpty(result.get("userIdx"))) {
			session.setAttribute("userInfo", result);
			return "redirect:/siteMain";
		} else {
			return "ewp/login/login";
		}

	}
}
