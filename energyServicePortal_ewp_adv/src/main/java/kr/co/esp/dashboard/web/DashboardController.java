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

/**
 * 대시보드 컨트롤러
 */
@Controller
public class DashboardController {
	private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

	/**
	 * 그룹 대시보드
	 *
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
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

	/**
	 * 중개거래 대시보드
	 *
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
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

	/**
	 * 사이트 대시보드
	 *
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
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

	/**
	 * ESS 대시보드
	 *
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dashboard/emain.do")
	public String emin(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/dashboard/emain";
	}

	/**
	 * VPP 대시보드
	 *
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dashboard/VPPmain.do")
	public String VPPmain(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/dashboard/VPPmain";
	}
}
