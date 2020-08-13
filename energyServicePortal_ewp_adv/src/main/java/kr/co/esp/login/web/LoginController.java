package kr.co.esp.login.web;

import egovframework.com.cmm.EgovMessageSource;
import kr.co.esp.common.util.RestApiUtil;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.login.service.LoginService;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.HEAD;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
public class LoginController {
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

	@Resource(name="loginService")
	LoginService loginService;

	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;

	@RequestMapping(value = "/login.do")
	public String login(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/login/login";
	}

	@RequestMapping("/logout.do")
	public String logout(HttpSession session, Model model) {
		return "redirect:/login.do";
	}

	@RequestMapping("/loginFailure.do")
	public String loginFailure(HttpServletRequest request, HttpSession session, Model model, RedirectAttributes redirect) throws Exception {
		Locale locale = (Locale) session.getAttribute("sessionLocale");
		redirect.addFlashAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_user", locale));
		return "redirect:/login.do";
	}

	@RequestMapping("/loginSuccess.do")
	public String loginSuccess(HttpServletRequest request, HttpSession session, Model model) {
		Map<String, Object> userInfoMap = (Map<String, Object>) session.getAttribute(UserUtil.USER_SESSION_ID);

		if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2)) {
			return "redirect:/spc/transactionCalendar.do";
		} else {
			return "redirect:/dashboard/gmain.do";
		}
	}
}
