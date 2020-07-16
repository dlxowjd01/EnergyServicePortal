package kr.co.esp.login.web;

import egovframework.com.cmm.EgovMessageSource;
import kr.co.esp.common.util.RestApiUtil;
import kr.co.esp.common.util.StringUtil;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.login.service.LoginService;
import kr.co.esp.sms.service.SmsService;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

@Controller
public class LoginController {

	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	@Resource(name="cmmLoginService")
	private LoginService cmmLoginService;
	
	@Resource(name="smsService")
	private SmsService smsService;
	
	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@RequestMapping(value = "/login.do")
	public String login(HttpSession session, Model model) {
		logger.debug("/login.do");
		return "esp/login/login";
	}

	@RequestMapping("/logout.do")
	public String logout(HttpSession session, Model model) {
		logger.debug("/logout.do");
		session.removeAttribute(UserUtil.USER_SESSION_ID);
		return "redirect:/login.do";
	}

	@RequestMapping("/loginUser.do")
	public String loginUser(HttpServletRequest request, HttpSession session, Model model, @RequestParam Map<String, Object> param) throws Exception {

		Locale locale = (Locale) session.getAttribute("sessionLocale");

		String serverName = request.getServerName();
		String oid = "encored";
		String mode = "test"; //운영 스테이징 구분

		if (serverName.contains("sundream")) {
			oid = "sundream";
		} else if (serverName.contains("trust")) {
			oid = "trust";
		} else if (serverName.contains("spower") || "localhost".equals(serverName)) {
			oid = "spower";
		} else if (serverName.contains("ewp")) {
			oid = "ewp";
		} else {
			oid = "encored";
		}

		//운영 스테이징 구분
		if (serverName.contains("test") || "127.0.0.1".equals(serverName)) {
			mode = "test";
		} else {
			mode = "real";
		}

		JSONObject obj = new JSONObject();
		obj.put("oid", oid);
		obj.put("login_id", param.get("login_id"));
		obj.put("password", param.get("password"));

		Map<String, Object> userInfoMap = new HashMap<String, Object>();
		Map<String, Object> tokenMap = RestApiUtil.post("/auth/login", mode, obj.toString());
		if(200 == (int) tokenMap.get("code")) {
			userInfoMap.putAll((Map<String, Object>) tokenMap.get("data"));

			Map<String, Object> meMap = RestApiUtil.get("/auth/me", mode,null, (String) userInfoMap.get("token"));
			if(200 == (int) meMap.get("code")) {
				userInfoMap.putAll((Map<String, Object>) meMap.get("data"));
				String auth_type = String.valueOf(userInfoMap.get("role"));
				userInfoMap.put("auth_type", auth_type);
			} else {
				userInfoMap.put("auth_type", "");
			}

			if(userInfoMap.get("auth_type") == null && "".equals(userInfoMap.get("auth_type"))) {
				model.addAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_user", locale));
				return "esp/login/login";
			} else if("1".equals(userInfoMap.get("auth_type")) || "2".equals(userInfoMap.get("auth_type"))) {
				session.setAttribute(UserUtil.USER_SESSION_ID, userInfoMap);
				session.setAttribute("mode", mode); //운영 / 스테이징 구분
				return "redirect:/dashboard/gmain.do";
			} else {
				model.addAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_user", locale));
				return "esp/login/login";
			}
		} else {
			model.addAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_correct", locale));
			return "esp/login/login";
		}
	}

	@RequestMapping("/getUserInfo.json")
	public @ResponseBody Map<String, Object> getUserInfo(HttpSession session) {
		logger.debug("/getUserInfo.json");
		return UserUtil.getUserInfo(session);
	}

	@RequestMapping("/findUserId.json")
	public @ResponseBody Map<String, Object> findUserId(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/findUserId.json");
		logger.debug("param : {}", param);

		Map<String, Object> result = cmmLoginService.findUserId(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	@RequestMapping("/findUserPw.json")
	public @ResponseBody Map<String, Object> findUserPw(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/findUserPw.json");
		logger.debug("param : {}", param);

		String userPw = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 8);

		Map<String, Object> result = cmmLoginService.findUserPw(param);

		if (result != null && StringUtil.isNotEmpty((String) result.get("user_pw"))) {
			param.put("userPw", userPw);
			int resultCnt = cmmLoginService.updateUserPw(param);
			if (resultCnt > 0) {
				smsService.sendFindPassMessage(param);
			}
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		System.out.println("	   " + resultMap);
		return resultMap;
	}

	@RequestMapping("/checkUserId.json")
	public @ResponseBody Map<String, Object> checkUserId(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/checkUserId.json");
		logger.debug("param : {}", param);

		Map<String, Object> result = cmmLoginService.checkUserId(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

	@RequestMapping("/sendAuthCode.json")
	public @ResponseBody Map<String, Object> sendAuthCode(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/sendAuthCode.json");
		logger.debug("param : {}", param);

		int resultCnt = smsService.sendAuthCodeMessage(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	@RequestMapping("/joinUser.json")
	public @ResponseBody Map<String, Object> joinUser(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("joinUser.json");
		logger.debug("param : {}", param);

		int resultCnt = cmmLoginService.insertUser(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	@RequestMapping("/modifyUser.json")
	public @ResponseBody Map<String, Object> modifyUser(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/modifyUser.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		param.put("userIdx", userInfo.get("user_idx"));
		param.put("modUid", userInfo.get("user_id"));

		int resultCnt = cmmLoginService.updateUser(param);

		// 현재 로그인 된 세션의 정보도 수정해 준다.
		userInfo.put("psn_email", param.get("psnEmail"));
		userInfo.put("psn_mobile", param.get("psnMobile"));
		if (param.get("userPw") != null && StringUtil.isNotEmpty((String) param.get("userPw"))) {
			userInfo.put("user_pw", UserUtil.encSHA256((String) param.get("userPw")));
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	@RequestMapping("/removeUser.json")
	public @ResponseBody Map<String, Object> removeUser(HttpSession session, @RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/removeUser.json");
		logger.debug("param : {}", param);

		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		param.put("userIdx", userInfo.get("user_idx"));
		param.put("modUid", userInfo.get("user_id"));

		int resultCnt = cmmLoginService.deleteUser(param);

		// 현재 세션을 끊는다.
		session.removeAttribute(UserUtil.USER_SESSION_ID);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
}
