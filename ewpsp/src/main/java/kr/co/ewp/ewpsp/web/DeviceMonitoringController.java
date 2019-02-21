package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.common.util.PMGrowApiUtil;
import kr.co.ewp.ewpsp.model.BmsEquipmentModel;
import kr.co.ewp.ewpsp.model.PcsEquipmentModel;
import kr.co.ewp.ewpsp.model.PvEquipmentModel;
import kr.co.ewp.ewpsp.model.UsageRealtimeModel;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;

@Controller
public class DeviceMonitoringController {

	private static final Logger logger = LoggerFactory.getLogger(DeviceMonitoringController.class);

	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;

	@RequestMapping("/deviceMonitoring")
	public String main(Model model, HttpServletRequest request) {
		logger.debug("/deviceMonitoring "+request.getParameter("deviceGbn"));
		
		model.addAttribute("deviceGbn", request.getParameter("deviceGbn"));
		
		return "ewp/device/deviceMonitoring";
	}

	@RequestMapping("/getDeviceIOEList")
	public @ResponseBody Map<String, Object> getDeviceIOEList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceIOEList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List list = deviceMonitoringService.getDeviceIOEList(param);
		int listCnt = deviceMonitoringService.getDeviceIOEListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	@RequestMapping("/getDeviceIOEDetail")
	public @ResponseBody Map<String, Object> getDeviceIOEDetail(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceIOEDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = deviceMonitoringService.getDeviceIOEDetail(param);
		ApiController api = new ApiController();
		UsageRealtimeModel usageRealtime = api.getDeviceRealTime((String) param.get("deviceId"));
		Long voltage = (usageRealtime == null || usageRealtime.getVoltage() == null) ? -1 : usageRealtime.getVoltage();
		result.put("voltage", (voltage < 0 || voltage > 1000000000) ? null : voltage);
		result.put("activePower", (usageRealtime == null) ? null : usageRealtime.getActivePower());
		result.put("energy", (usageRealtime == null) ? null : usageRealtime.getPositiveEnergy()+usageRealtime.getNegativeEnergy());
		result.put("energyReactive", (usageRealtime == null) ? null : usageRealtime.getPositiveEnergyReactive()+usageRealtime.getNegativeEnergyReactive());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	@RequestMapping("/getDevicePCSList")
	public @ResponseBody Map<String, Object> getDevicePCSList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDevicePCSList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List list = deviceMonitoringService.getDevicePCSList(param);
		int listCnt = deviceMonitoringService.getDevicePCSListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	@RequestMapping("/getDevicePCSDetail")
	public @ResponseBody Map<String, Object> getDevicePCSDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDevicePCSDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = deviceMonitoringService.getDevicePCSDetail(param);
		Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
		String host = (String) siteDetail.get("local_ems_addr");
		PcsEquipmentModel pcsDetail = PMGrowApiUtil.getPcsEquipmentList(host, (String) param.get("deviceId"));
		if(pcsDetail == null) {
			result.put("pcsStatus", null);
			result.put("pcsStatusNm", null);
		} else {
			String statusNm = "";
			if("0".equals(pcsDetail.getPcsStatus())) {
				statusNm = "OFF";
			} else if("1".equals(pcsDetail.getPcsStatus())) {
				statusNm = "ON";
			} else if("2".equals(pcsDetail.getPcsStatus())) {
				statusNm = "Fault";
			} else if("3".equals(pcsDetail.getPcsStatus())) {
				statusNm = "Warning";
			}
			result.put("pcsStatus", pcsDetail.getPcsStatus());
			result.put("pcsStatusNm", statusNm);
		}
		result.put("acVoltage", (pcsDetail == null) ? null : pcsDetail.getAcVoltage());
		result.put("acPower", (pcsDetail == null) ? null : pcsDetail.getAcPower());
		result.put("acFreq", (pcsDetail == null) ? null : pcsDetail.getAcFreq());
		result.put("acCurrent", (pcsDetail == null) ? null : pcsDetail.getAcCurrent());
		result.put("acPf", (pcsDetail == null) ? null : pcsDetail.getAcPf());
		result.put("acSetPower", (pcsDetail == null) ? null : pcsDetail.getAcSetPower());
		result.put("dcVoltage", (pcsDetail == null) ? null : pcsDetail.getDcVoltage());
		result.put("dcPower", (pcsDetail == null) ? null : pcsDetail.getDcPower());
		result.put("pcsStatus", (pcsDetail == null) ? null : pcsDetail.getPcsStatus());
		result.put("pcsCommand", (pcsDetail == null) ? null : pcsDetail.getPcsCommand());
		result.put("todayCEnergy", (pcsDetail == null) ? null : pcsDetail.getTodayCEnergy());
		result.put("todayDEnergy", (pcsDetail == null) ? null : pcsDetail.getTodayDEnergy());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	@RequestMapping("/getDeviceBMSList")
	public @ResponseBody Map<String, Object> getDeviceBMSList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceBMSList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List list = deviceMonitoringService.getDeviceBMSList(param);
		int listCnt = deviceMonitoringService.getDeviceBMSListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	@RequestMapping("/getDeviceBMSDetail")
	public @ResponseBody Map<String, Object> getDeviceBMSDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceBMSDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = deviceMonitoringService.getDeviceBMSDetail(param);
		Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
		String host = (String) siteDetail.get("local_ems_addr");
		List<BmsEquipmentModel> bmsDetail = PMGrowApiUtil.getBmsEquipmentList(host, (String) param.get("deviceId"));
		if(bmsDetail == null || bmsDetail.size() == 0) {
			result.put("bmsStatus", null);
			result.put("bmsStatusNm", null);
		} else {
			String statusNm = "";
			if("0".equals(bmsDetail.get(0).getSysMode())) {
				statusNm = "Idle";
			} else if("1".equals(bmsDetail.get(0).getSysMode())) {
				statusNm = "Charge";
			} else if("2".equals(bmsDetail.get(0).getSysMode())) {
				statusNm = "Discharge";
			} else if("3".equals(bmsDetail.get(0).getSysMode())) {
				statusNm = "MainS/W on/off";
			} else if("4".equals(bmsDetail.get(0).getSysMode())) {
				statusNm = "Off-line";
			} else if("5".equals(bmsDetail.get(0).getSysMode())) {
				statusNm = "Ready";
			}
			result.put("bmsStatus", bmsDetail.get(0).getSysMode());
			result.put("bmsStatusNm", statusNm);
		}
		result.put("sysSoc", (bmsDetail == null || bmsDetail.size() == 0) ? null : bmsDetail.get(0).getSysSoc());
		result.put("sysSoh", (bmsDetail == null || bmsDetail.size() == 0) ? null : bmsDetail.get(0).getSysSoh());
		result.put("currSoc", (bmsDetail == null || bmsDetail.size() == 0) ? null : bmsDetail.get(0).getCurrSoc());
		result.put("sysVoltage", (bmsDetail == null || bmsDetail.size() == 0) ? null : bmsDetail.get(0).getSysVoltage());
		result.put("sysCurrent", (bmsDetail == null || bmsDetail.size() == 0) ? null : bmsDetail.get(0).getSysCurrent());
		result.put("dod", (bmsDetail == null || bmsDetail.size() == 0) ? null : bmsDetail.get(0).getDod());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	@RequestMapping("/getDevicePVList")
	public @ResponseBody Map<String, Object> getDevicePVList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDevicePVList");
		logger.debug("param ::::: "+param.toString());
		
		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List list = deviceMonitoringService.getDevicePVList(param);
		int listCnt = deviceMonitoringService.getDevicePVListCnt(param);
		int totalPageCnt = 0;
		if(listCnt > 0) {
			totalPageCnt = listCnt / pageRowCnt;
			if(listCnt % pageRowCnt > 0) {
				totalPageCnt++;
			}
		}
		
		Map<String, Object> pagingMap = new HashMap<String, Object>();
		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}

	@RequestMapping("/getDevicePVDetail")
	public @ResponseBody Map<String, Object> getDevicePVDetail(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDevicePVDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = deviceMonitoringService.getDevicePVDetail(param);
		Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
		String host = (String) siteDetail.get("local_ems_addr");
		PvEquipmentModel pvDetail = PMGrowApiUtil.getPvEquipmentList(host, (String) param.get("deviceId"));
		System.out.println("결과 : "+pvDetail.toString());
		if(pvDetail == null) {
			result.put("pvStatus", null);
			result.put("pvStatusNm", null);
		} else {
			String statusNm = "";
			if(pvDetail.getStatus() == 0) {
				statusNm = "Stop";
			} else if(pvDetail.getStatus() == 1) {
				statusNm = "Run";
			} else if(pvDetail.getStatus() == 2) {
				statusNm = "Fault";
			} else if(pvDetail.getStatus() == 3) {
				statusNm = "Warning";
			}
			result.put("pvStatus", pvDetail.getStatus());
			result.put("pvStatusNm", statusNm);
		}
		result.put("temperature", (pvDetail == null) ? -1 : pvDetail.getTemperature());
		result.put("totalPower", (pvDetail == null) ? -1 : pvDetail.getTotalGenPower());
		result.put("todayPower", (pvDetail == null) ? -1 : pvDetail.getTodayGenPower());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

}
