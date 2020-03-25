package kr.co.esp.dashboard.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.esp.alarm.service.AlarmService;
import kr.co.esp.billRevenue.service.DrRevenueService;
import kr.co.esp.billRevenue.service.EssRevenueService;
import kr.co.esp.billRevenue.service.PvRevenueService;
import kr.co.esp.board.web.FaqController;
import kr.co.esp.device.service.DeviceMonitoringService;
import kr.co.esp.energy.service.EssChargeService;

@Controller
public class DashboardController {

	private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);
	
	@Resource(name="essChargeService")
	private EssChargeService essChargeService;
	
	@Resource(name="essRevenueService")
	private EssRevenueService essRevenueService;
	
	@Resource(name="pvRevenueService")
	private PvRevenueService pvRevenueService;
	
	@Resource(name="drRevenueService")
	private DrRevenueService drRevenueService;
	
	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;
	
	@Resource(name="alarmService")
	private AlarmService alarmService;
	
	@RequestMapping(value = "/main/siteMain.do")
	public String siteMain(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/main/siteMain.do");
		return "esp/main/siteMain";
	}

	@RequestMapping(value = "/main/gMain.do")
	public String gMain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/main/gMain.do");
		return "esp/main/gMain";
	}

	@RequestMapping(value = "/dashboard/dmain.do")
	public String groupDashboard(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/dmain.do");
		return "esp/dashboard/dmain";
	}
	
	@RequestMapping(value = "/dashboard/emain.do")
	public String emain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/emain.do");
		return "esp/dashboard/emain";
	}
	
	@RequestMapping(value = "/dashboard/gmain.do")
	public String gmain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/gmain.do");
		return "esp/dashboard/gmain";
	}
	
	@RequestMapping(value = "/dashboard/jmain.do")
	public String jmain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/jmain.do");
		return "esp/dashboard/jmain";
	}
	
	@RequestMapping(value = "/dashboard/smain.do")
	public String smain(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/dashboard/smain.do");
		return "esp/dashboard/smain";
	}
	
}
