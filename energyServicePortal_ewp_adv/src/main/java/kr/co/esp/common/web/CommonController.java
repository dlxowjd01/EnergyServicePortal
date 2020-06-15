package kr.co.esp.common.web;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.esp.common.ExcelDownload;
import kr.co.esp.common.util.CommonUtils;
import kr.co.esp.device.service.DeviceMonitoringService;
import kr.co.esp.energy.service.UsageService;

@Controller
public class CommonController {

	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);
	
	@Resource(name="usageService")
	private UsageService usageService;
	
	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;

	@RequestMapping(value = "/excelDownload.do")
	public void excelDownload(@RequestParam Map<String, Object> param, Model model, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
		logger.debug("/excelDownload.do");
		logger.debug("param ::::: " + param.toString());

		String gbn = (String) param.get("gbn");
		String excelTitle = "";
		String colNm = "";

		List<Map<String, Object>> list = null;
		param.put("siteId", session.getAttribute("selViewSiteId"));
		if ("IOE".equals(gbn)) {
			list = deviceMonitoringService.getDeviceIOEList(param);
			excelTitle = "장치현황(IOE)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
			colNm = "No.|Device Name|Device ID|Device Type|Status|Status Time";
		} else if ("PCS".equals(gbn)) {
			list = deviceMonitoringService.getDevicePCSList(param);
			excelTitle = "장치현황(PCS)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
			colNm = "No.|Device Name|Device ID|Device Type|PCS Status|PCS Message|Status Time";
		} else if ("BMS".equals(gbn)) {
			list = deviceMonitoringService.getDeviceBMSList(param);
			excelTitle = "장치현황(BMS)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
			colNm = "No|Device Name|Device ID|Device Type|BMS Status|BMS Message|Status Time";
		} else if ("PV".equals(gbn)) {
			list = deviceMonitoringService.getDevicePVList(param);
			excelTitle = "장치현황(PV)_" + CommonUtils.convertDateFormat(new Date(), "yyyyMMddHHmmssSSS");
			colNm = "No.|Device Name|Device ID|Device Type|PV Status|Temperature|PV Message|Status Time";
		}

		param.put("colNm", colNm);
		param.put("excelTitle", excelTitle);

		ExcelDownload ed = null;
		try {
			ed = new ExcelDownload(response, param);

			if(list != null && !list.isEmpty()) {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> excelMap = new HashMap<String, Object>();
					excelMap = (Map<String, Object>) list.get(i);
					ed.handleRow(excelMap);
				}

			}

		} catch (NullPointerException e) {
			logger.error("error1 is : " + e.toString());
		} catch (Exception e) {
			logger.error("error is : " + e.toString());
		} finally {
			if (ed != null) {
				ed.close();
			}
		}

	}
	
}
