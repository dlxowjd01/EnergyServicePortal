package kr.co.esp.system.web;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SystemController {

	private static final Logger logger = LoggerFactory.getLogger(SystemController.class);

	@RequestMapping(value = "/system/siteSetting.do")
	public String siteSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/siteSetting";
	}

	@RequestMapping(value = "/system/groupSetting.do")
	public String groupSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/groupSetting";
	}

	@RequestMapping(value = "/system/userSetting.do")
	public String userSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/userSetting";
	}

	@RequestMapping(value = "/system/comCodeSetting.do")
	public String comCodeSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/comCodeSetting";
	}

	@RequestMapping(value = "/system/batchSetting.do")
	public String batchSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/batchSetting";
	}

	@RequestMapping(value = "/system/alarmSetting.do")
	public String alarmSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/alarmSetting";
	}
}
