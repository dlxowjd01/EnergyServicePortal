package kr.co.esp.history.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.esp.device.service.DeviceMonitoringService;

@Controller
public class HistoryController {

	private static final Logger logger = LoggerFactory.getLogger(HistoryController.class);
	
	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;

	@RequestMapping(value = "/history/operationHistory.do")
	public String groupDashboard(HttpServletRequest request, HttpSession session, Model model) {
		logger.debug("/history/operationHistory.do");
		return "esp/history/operationHistory";
	}
	
	
}
