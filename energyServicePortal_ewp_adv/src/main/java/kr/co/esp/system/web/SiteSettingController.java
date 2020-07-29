package kr.co.esp.system.web;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SiteSettingController {

	private static final Logger logger = LoggerFactory.getLogger(SiteSettingController.class);

	@RequestMapping(value = "/system/siteSetting.do")
	public String siteSetting(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/system/siteSetting.do");
		return "esp/system/siteSetting";
	}

}
