package kr.co.esp.login.web;

import egovframework.com.cmm.EgovMessageSource;
import kr.co.esp.common.util.RestApiUtil;
import kr.co.esp.common.util.UserUtil;
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

	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;

	@RequestMapping(value = "/login.do")
	public String login(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/login/login";
	}

	@RequestMapping("/logout.do")
	public String logout(HttpSession session, Model model) {
		session.removeAttribute(UserUtil.USER_SESSION_ID);
		return "redirect:/login.do";
	}

	@RequestMapping("/loginUser.do")
	public String loginUser(HttpServletRequest request, HttpSession session, Model model, @RequestParam Map<String, Object> param, RedirectAttributes redirect) throws Exception {

		Locale locale = (Locale) session.getAttribute("sessionLocale");

		String serverName = request.getServerName();
		String oid = "encored";
		String mode = "test"; //운영 스테이징 구분

		if (serverName != null && !"".equals(serverName) && !"localhost".equals(serverName)) {
			Pattern p = Pattern.compile("^(.*?)(?=\\.)");
			Matcher m = p.matcher(serverName);
			String targetHost = "";
			while (m.find()) {
				targetHost = m.group();
			}
			if (targetHost.contains("-")) {
				oid = targetHost.split("-")[0];
				mode = "test";
			} else {
				oid = targetHost;
				mode = "real";
			}
		} else {
			oid = "encored";
			mode = "test";
		}

		JSONObject obj = new JSONObject();
		obj.put("oid", oid);
		obj.put("login_id", param.get("login_id"));
		obj.put("password", param.get("password"));

		Map<String, Object> userInfoMap = new HashMap<String, Object>();
		Map<String, Object> tokenMap = RestApiUtil.post("/auth/login", mode, obj.toString());
		if(200 == (int) tokenMap.get("code")) {
			userInfoMap.putAll((Map<String, Object>) tokenMap.get("data"));

			Map<String, Object> meMap = RestApiUtil.get("/auth/me", mode,"", (String) userInfoMap.get("token"));
			if(200 == (int) meMap.get("code")) {
				userInfoMap.putAll((Map<String, Object>) meMap.get("data"));
				String auth_type = String.valueOf(userInfoMap.get("role"));
				userInfoMap.put("auth_type", auth_type);
			} else {
				userInfoMap.put("auth_type", "");
			}

			if(userInfoMap.get("auth_type") == null && "".equals(userInfoMap.get("auth_type"))) {
				redirect.addFlashAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_user", locale));
				return "redirect:/login.do";
			} else if("1".equals(userInfoMap.get("auth_type")) || "2".equals(userInfoMap.get("auth_type"))) {
				session.setAttribute(UserUtil.USER_SESSION_ID, userInfoMap);
				session.setAttribute("mode", mode); //운영 / 스테이징 구분

				if (userInfoMap.get("task") != null && ((int) userInfoMap.get("task") == 1 || (int) userInfoMap.get("task") == 2)) {
					return "redirect:/spc/transactionCalendar.do";
				} else {
					return "redirect:/dashboard/gmain.do";
				}
			} else {
				redirect.addFlashAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_user", locale));
				return "redirect:/login.do";
			}
		} else {
			redirect.addFlashAttribute("msg", egovMessageSource.getMessage("ewp.error.login_no_correct", locale));
			return "redirect:/login.do";
		}
	}
}
