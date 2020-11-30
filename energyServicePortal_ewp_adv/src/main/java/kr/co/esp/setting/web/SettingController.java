package kr.co.esp.setting.web;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SettingController {

	private static final Logger logger = LoggerFactory.getLogger(SettingController.class);

	@RequestMapping(value = "/setting/siteSetting.do")
	public String siteSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/setting/siteSetting";
	}

	@RequestMapping(value = "/setting/groupSetting.do")
	public String groupSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/setting/groupSetting";
	}

	@RequestMapping(value = "/setting/alarmSetting.do")
	public String alarmSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/setting/alarmSetting";
	}

	@RequestMapping(value = "/setting/userSetting.do")
	public String userSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/setting/userSetting";
	}

	@RequestMapping(value = "/setting/comCodeSetting.do")
	public String comCodeSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/setting/comCodeSetting";
	}

	@RequestMapping(value = "/setting/batchSetting.do")
	public String batchSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/setting/batchSetting";
	}
	
}
