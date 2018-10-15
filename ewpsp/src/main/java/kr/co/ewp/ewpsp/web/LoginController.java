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
	public String loginUser(HttpSession session, Model model, @RequestParam HashMap param) throws Exception {
		logger.debug("/loginUser");
		logger.debug("param : {}", param);

		Map result = loginService.getUserDetail(param);
		logger.debug("result : {}", result);

//		session.setMaxInactiveInterval(24 * 60 * 60); // web.xml 에 추가함

		if (result != null && CommonUtils.isNotEmpty(result.get("user_idx"))) {
			String authType = (String)result.get("auth_type");
			String siteId = (String)result.get("site_id");

			if (authType == null) {
				model.addAttribute("msg", "아이디가 없거나 비밀번호가 맞지 않습니다.");
				return "ewp/login/login";
			} else if (authType.equals("1") || authType.equals("2") || authType.equals("3")) {
				session.setAttribute(UserUtil.USER_SESSION_ID, result);
				return "redirect:/main";
			} else if (siteId != null && !siteId.isEmpty()) {
				session.setAttribute(UserUtil.USER_SESSION_ID, result);
				return "redirect:/siteMain?siteId=" + siteId;
			} else {
				model.addAttribute("msg", "등록이 되지 않은 사용자입니다.\\n관리자에게 문의하세요.");
				return "ewp/login/login";
			}
		} else {
			model.addAttribute("msg", "아이디가 없거나 비밀번호가 맞지 않습니다.");
			return "ewp/login/login";
		}
	}

	@RequestMapping("/getUserInfo")
	public @ResponseBody Map getUserInfo(HttpSession session) {
		return UserUtil.getUserInfo(session);
	}

	@RequestMapping("/findUserId")
	public @ResponseBody Map<String, Object> findUserId(@RequestParam HashMap param) throws Exception {
		logger.debug("/findUserId");
		logger.debug("param : {}", param);

		Map result = loginService.findUserId(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	@RequestMapping("/findUserPw")
	public @ResponseBody Map<String, Object> findUserPw(@RequestParam HashMap param) throws Exception {
		logger.debug("/findUserPw");
		logger.debug("param : {}", param);

		Map result = loginService.findUserPw(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	@RequestMapping("/checkUserId")
	public @ResponseBody Map<String, Object> checkUserId(@RequestParam HashMap param) throws Exception {
		logger.debug("/checkUserId");
		logger.debug("param : {}", param);

		Map result = loginService.checkUserId(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	@RequestMapping("/joinUser")
	public @ResponseBody Map<String, Object> joinUser(@RequestParam HashMap param) throws Exception {
		logger.debug("/joinUser");
		logger.debug("param : {}", param);

		int resultCnt = loginService.insertUser(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}


}
