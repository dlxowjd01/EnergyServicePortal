package kr.co.esp.device.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class DeviceController {

	private static final Logger logger = LoggerFactory.getLogger(DeviceController.class);

	@RequestMapping(value = "/device/deviceState.do")
	public String deviceState(HttpServletRequest request, HttpSession session, Model model) {
		return "esp/device/deviceState";
	}

	@RequestMapping(value = "/device/collectionState.do")
	public String collectionState(HttpServletRequest request, HttpSession session, Model model) { return "esp/device/collectionState"; }

	@RequestMapping(value = "/device/certManageList.do")
	public String certificateManagement(HttpServletRequest request, HttpSession session, Model model) { return "esp/device/certManageList"; }

	@RequestMapping(value = "/device/certManageDetail.do")
	public String certificateManagementDetail(HttpServletRequest request, HttpSession session, Model model) { return "esp/device/certManageDetail"; }

	@RequestMapping(value = "/device/certApplication.do")
	public String certificateApplication(HttpServletRequest request, HttpSession session, Model model) { return "esp/device/certApplication"; }

	@RequestMapping(value = "/device/certManageProc.do")
	public String certificateManagementProc(HttpServletRequest request, HttpSession session, Model model) { return "esp/device/certManageProc"; }
}
