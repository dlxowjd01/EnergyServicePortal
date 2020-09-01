package kr.co.esp.login.web;

import kr.co.esp.common.service.EgovMessageSource;
import kr.co.esp.common.util.UserUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Locale;
import java.util.Map;

@Controller
public class LoginController {
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;

	@RequestMapping("/login.do")
	public String login(HttpSession session) {
		Map<String, Object> userInfoMap = (Map<String, Object>) session.getAttribute(UserUtil.USER_SESSION_ID);

		if (session != null && userInfoMap != null) {
			if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2)) {
				return "redirect:/spc/transactionCalendar.do";
			} else {
				return "redirect:/dashboard/gmain.do";
			}
		} else {
			return "esp/login/login";
		}
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

		if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2)) {
			return "redirect:/spc/transactionCalendar.do";
		} else {
			return "redirect:/dashboard/gmain.do";
		}
	}
}
