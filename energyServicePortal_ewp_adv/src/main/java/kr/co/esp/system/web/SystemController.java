package kr.co.esp.system.web;

import egovframework.com.cmm.service.EgovProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class SystemController {
	private static final Logger logger = LoggerFactory.getLogger(SystemController.class);

//	@Value("${globals.fileUpload.rootPath}")
//    private String fileUploadRootPath;
	private String fileUploadRootPath = EgovProperties.getProperty("globals.fileUpload.rootPath");

	// @RequestMapping(value = "/system/siteSetting.do")
	// public String systemSiteSetting(HttpServletRequest request, HttpSession session, Model model) {
	// 	System.out.println("/system/siteSetting.do");
	// 	return "esp/system/siteSetting";
	// }

	@RequestMapping(value = "/system/basicInformation.do")
	public String systemBasicInformation(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/basicInformation";
	}

	@RequestMapping(value = "/system/alarmManagement.do")
	public String systemAlarmManagement(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/alarmManagement";
	}

	@RequestMapping(value = "/system/systemCode.do")
	public String systemSystemCode(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/systemCode";
	}

	@RequestMapping(value = "/system/systemSetting.do")
	public String systemSystemSetting(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/system/systemSetting";
	}
}
