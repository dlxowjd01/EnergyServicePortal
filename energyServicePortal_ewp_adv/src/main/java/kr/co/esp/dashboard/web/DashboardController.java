package kr.co.esp.dashboard.web;

import kr.co.esp.common.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class DashboardController {
	private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

	@RequestMapping(value = "/dashboard/gmain.do")
	public String gmain(HttpServletRequest request, HttpSession session, Model model) {
		String dashboardMap = (String) EgovProperties.getProperty("dashboard.map"); // TEST 서버 여부

		String defaultOid = EgovProperties.getProperty("default.oid");
		if ("testkpx".equals(defaultOid)) {
			model.addAttribute("secondYAxis", false);
		} else {
			model.addAttribute("secondYAxis", true);
		}

		model.addAttribute("dashboardMap", dashboardMap);
		return "esp/dashboard/gmain";
	}

	@RequestMapping(value = "/dashboard/jmain.do")
	public String jmain(HttpServletRequest request, HttpSession session, Model model) {
		String defaultOid = EgovProperties.getProperty("default.oid");
		if ("testkpx".equals(defaultOid)) {
			model.addAttribute("secondYAxis", false);
		} else {
			model.addAttribute("secondYAxis", true);
		}

		return "esp/dashboard/jmain";
	}

	@RequestMapping(value = "/dashboard/smain.do")
	public String smain(HttpServletRequest request, HttpSession session, Model model) {
		Map<String, Object> userInfo = UserUtil.getUserInfo(session);
		return "esp/dashboard/smain";
	}

	/**
	 * DR 대시보드
	 *
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dashboard/dmain.do")
	public String dmain(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/dashboard/dmain";
	}

}
