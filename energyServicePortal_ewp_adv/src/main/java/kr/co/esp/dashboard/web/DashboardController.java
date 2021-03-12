package kr.co.esp.dashboard.web;

import kr.co.esp.common.service.EgovProperties;
import kr.co.esp.common.util.UserUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
		Map<String, Object> userInfo = UserUtil.getUserInfo(request);
		String dashboardMap = (String) EgovProperties.getProperty("dashboard.map"); // TEST 서버 여부

		String defaultOid = EgovProperties.getProperty("default.oid");
		if ("testkpx".equals(defaultOid)) {
			model.addAttribute("secondYAxis", false);
		} else {
			model.addAttribute("secondYAxis", true);
		}

		boolean haveMenu = true;
		LinkedHashMap<String, Object> menuList = (LinkedHashMap<String, Object>) request.getAttribute("menuList");
		for (Map.Entry<String, Object> elem : menuList.entrySet()) {
			Map<String, Object> menuDetail = (Map<String, Object>) elem.getValue();
			Map<String, Object> access = (Map<String, Object>) menuDetail.get("access");
			String menuCode = (String) menuDetail.get("code");

			if (menuCode.contains("generation")) {
				if (!access.isEmpty()) {
					if (access.containsKey("deny")) {
						Map<String, Object> denyMap = (Map<String, Object>) access.get("deny");
						if (denyMap.containsKey("oid") && ((List) denyMap.get("oid")).contains(userInfo.get("oid"))) {
							haveMenu = false;
						} else {
							if (denyMap.containsKey("role") && ((List) denyMap.get("role")).contains(userInfo.get("role"))) {
								haveMenu = false;
							} else if (denyMap.containsKey("task") && ((List) denyMap.get("task")).contains(userInfo.get("task"))) {
								haveMenu = false;
							}
						}
					}

					if (haveMenu == true) {
						if (access.containsKey("allow")) {
							Map<String, Object> allowMap = (Map<String, Object>) access.get("allow");
							if (allowMap.containsKey("oid") && ((List) allowMap.get("oid")).contains(userInfo.get("oid"))) {
								haveMenu = true;
							} else {
								if (allowMap.containsKey("role") && ((List) allowMap.get("role")).contains(userInfo.get("role"))) {
									haveMenu = true;
								} else if (allowMap.containsKey("task") && ((List) allowMap.get("task")).contains(userInfo.get("task"))) {
									haveMenu = true;
								}
							}
						}
					}
				} else {
					haveMenu = true;
				}
			} else {
				haveMenu = false;
			}
		}

		model.addAttribute("haveMenu", haveMenu);
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
