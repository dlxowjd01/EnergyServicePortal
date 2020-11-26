package kr.co.esp.login.web;

import kr.co.esp.common.service.EgovMessageSource;
import kr.co.esp.common.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.login.service.LoginService;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import static kr.co.esp.common.util.RestApiUtil.get;

@Controller
public class LoginController {
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

	@Resource(name="loginService")
	LoginService loginService;

	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;

	@RequestMapping("/login.do")
	public String login(HttpSession session, Model model, HttpServletRequest req, HttpServletResponse res) {
		String rtnPage = "esp/login/loign";
		try {
			Map<String, Object> userInfoMap = (Map<String, Object>) session.getAttribute(UserUtil.USER_SESSION_ID);
			String serverName = req.getServerName();

			String defaultOid = EgovProperties.getProperty("default.oid");
			String gitVersion = EgovProperties.getGitProperty("git.commit.id.abbrev");
			String apiHost = EgovProperties.getProperty("jsApiHost"); //API 기본 HOST
			String apiHostTest = EgovProperties.getProperty("jsApiHostTest"); //API TEST HOST

			Map<String, Object> oid = loginService.selectOid(serverName);
			model.addAttribute("oid", oid.get("oid"));
			model.addAttribute("defaultOid", defaultOid);
			model.addAttribute("gitVersion", gitVersion);
			if ("test".equals(oid.get("mode"))) {
				model.addAttribute("apiHost", apiHostTest);
			} else {
				model.addAttribute("apiHost", apiHost);
			}

			if (session != null && userInfoMap != null && (userInfoMap.get("token") != null && !"".equals(userInfoMap.get("token")))) {
				if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2)) {
					rtnPage = "redirect:/spc/transactionCalendar.do";
				} else {
					rtnPage = "redirect:/dashboard/gmain.do";
				}
			} else {
				rtnPage = "esp/login/login";
			}
		} catch (Exception e) {
			logger.error("LoginController - loign : " + e.toString());
		}

		return rtnPage;
	}

	@RequestMapping("/logout.do")
	public String logout() {
		return "redirect:/login.do";
	}

	@ResponseBody
	@RequestMapping("/loginFailure.do")
	public Map<String, Object> loginFailure(HttpSession session, RedirectAttributes redirect) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();

		Locale locale = (Locale) session.getAttribute("sessionLocale");

		returnMap.put("rtnUrl", "");
		returnMap.put("msg", egovMessageSource.getMessage("ewp.error.login_no_correct", locale));
		return returnMap;
	}

	@ResponseBody
	@RequestMapping("/loginSuccess.do")
	public Map<String, Object> loginSuccess(HttpSession session, HttpServletResponse res) {
		Map<String, Object> userInfoMap = (Map<String, Object>) session.getAttribute(UserUtil.USER_SESSION_ID);
		Map<String, Object> returnMap = new HashMap<String, Object>();

		try {
			if (userInfoMap.get("required_verify") != null && (Boolean) userInfoMap.get("required_verify") == true) {
				returnMap.put("rtnUrl", "verify");
			} else {
				if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2 || (int) userInfoMap.get("task") == 3)) {
					returnMap.put("rtnUrl", "/spc/transactionCalendar.do");
				} else {
					returnMap.put("rtnUrl", "/dashboard/gmain.do");
				}
			}
		} catch (Exception e) {
			logger.error("LoginController - loginSuccess : " + e.toString());
			returnMap.put("rtnUrl", "");
		}

		return returnMap;
	}

	@ResponseBody
	@RequestMapping("/twoFactorAuth.do")
	public Map<String, Object> twoFactorAuth(HttpSession session, HttpServletRequest req, HttpServletResponse res) {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			String serverName = req.getServerName();
			Map<String, Object> oid = loginService.selectOid(serverName);

			JSONObject obj = new JSONObject();
			obj.put("oid", oid.get("oid"));
			obj.put("login_id", req.getParameter("login_id"));
			obj.put("password", req.getParameter("password"));
			obj.put("verify_code", req.getParameter("verify_code"));

			Map<String, Object> userInfoMap = loginService.selectTwoFactorAuthLogin((String) oid.get("mode"), obj);
			if (userInfoMap != null && !userInfoMap.isEmpty()) {
				session.setAttribute(UserUtil.USER_SESSION_ID, userInfoMap);

				if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2 || (int) userInfoMap.get("task") == 3)) {
					returnMap.put("rtnUrl", "/spc/transactionCalendar.do");
				} else {
					returnMap.put("rtnUrl", "/dashboard/gmain.do");
				}
			} else {
				returnMap.put("rtnUrl", "");
				returnMap.put("msg", "인증번호 확인에 실패했습니다.");
			}
		} catch (Exception e) {
			logger.error("LoginController - twoFactorAuth : " + e.toString());
			returnMap.put("rtnUrl", "");
			returnMap.put("msg", "인증번호 확인에 실패했습니다.");
		}

		return returnMap;
	}
}
