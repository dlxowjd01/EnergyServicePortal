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

import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.common.util.UserUtil;
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
		
		session.removeAttribute(UserUtil.USER_SESSION_ID);
		
		return "redirect:/login";
	}
	
	@RequestMapping("/loginUser")
	public String loginUser(HttpSession session, @RequestParam HashMap param) throws Exception {
		logger.debug("/loginUser");
		logger.debug("param : {}", param);

		Map result = loginService.getUserDetail(param);
		logger.debug("result : {}", result);

		if (result != null && CommonUtils.isNotEmpty(result.get("user_idx"))) {
			session.setAttribute(UserUtil.USER_SESSION_ID, result);

			String authType = (String)result.get("auth_type");

			if (authType == null) {
				return "ewp/login/login";
			} else if (authType.equals("1") || authType.equals("2")) {
				return "redirect:/main";
			} else {
				return "redirect:/siteMain";
			}
		} else {
			return "ewp/login/login";
		}

	}
}
