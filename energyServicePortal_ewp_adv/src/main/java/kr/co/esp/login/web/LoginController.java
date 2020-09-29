package kr.co.esp.login.web;

import kr.co.esp.common.service.EgovMessageSource;
import kr.co.esp.common.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import kr.co.esp.login.service.LoginService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Locale;
import java.util.Map;

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

			if (session != null && userInfoMap != null) {
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

	@RequestMapping("/loginFailure.do")
	public String loginFailure(HttpSession session, RedirectAttributes redirect) throws Exception {
		Locale locale = (Locale) session.getAttribute("sessionLocale");
		redirect.addFlashAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_user", locale));
		return "redirect:/login.do";
	}

	@RequestMapping("/loginSuccess.do")
	public String loginSuccess(HttpSession session) {
		Map<String, Object> userInfoMap = (Map<String, Object>) session.getAttribute(UserUtil.USER_SESSION_ID);

		if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2 || (int) userInfoMap.get("task") == 3)) {
			return "redirect:/spc/transactionCalendar.do";
		} else {
			return "redirect:/dashboard/gmain.do";
		}
	}
}
