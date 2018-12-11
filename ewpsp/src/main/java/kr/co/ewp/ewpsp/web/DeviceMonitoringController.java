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
		Long voltage = (usageRealtime == null) ? null : usageRealtime.getVoltage();
		if(voltage < 0 || voltage > 1000000000) voltage = null;
		result.put("voltage", voltage);
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
		List<PcsEquipmentModel> pcsDetail = PMGrowApiUtil.getPcsEquipmentList(host, (String) param.get("deviceId"));
		if(pcsDetail == null || pcsDetail.size() == 0) {
			result.put("pcsStatus", null);
			result.put("pcsStatusNm", null);
		} else {
			String statusNm = "";
			if("0".equals(pcsDetail.get(0).getPcsStatus())) {
				statusNm = "OFF";
			} else if("1".equals(pcsDetail.get(0).getPcsStatus())) {
				statusNm = "ON";
			} else if("2".equals(pcsDetail.get(0).getPcsStatus())) {
				statusNm = "Fault";
			} else if("3".equals(pcsDetail.get(0).getPcsStatus())) {
				statusNm = "Warning";
			}
			result.put("pcsStatus", pcsDetail.get(0).getPcsStatus());
			result.put("pcsStatusNm", statusNm);
		}
		result.put("acVoltage", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getAcVoltage());
		result.put("acPower", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getAcPower());
		result.put("acFreq", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getAcFreq());
		result.put("acCurrent", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getAcCurrent());
		result.put("acPf", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getAcPf());
		result.put("acSetPower", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getAcSetPower());
		result.put("dcVoltage", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getDcVoltage());
		result.put("dcPower", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getDcPower());
		result.put("pcsStatus", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getPcsStatus());
		result.put("pcsCommand", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getPcsCommand());
		result.put("todayCEnergy", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getTodayCEnergy());
		result.put("todayDEnergy", (pcsDetail == null || pcsDetail.size() == 0) ? null : pcsDetail.get(0).getTodayDEnergy());
		System.out.println("최종결과 : "+result.toString());
		
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
		System.out.println("최종결과 : "+result.toString());
		
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
		List<PvEquipmentModel> pvDetail = PMGrowApiUtil.getPvEquipmentList(host, (String) param.get("deviceId"));
		if(pvDetail == null || pvDetail.size() == 0) {
			result.put("bmsStatus", null);
			result.put("bmsStatusNm", null);
		} else {
			String statusNm = "";
			if("0".equals(pvDetail.get(0).getStatus())) {
				statusNm = "Stop";
			} else if("1".equals(pvDetail.get(0).getStatus())) {
				statusNm = "Run";
			} else if("2".equals(pvDetail.get(0).getStatus())) {
				statusNm = "Fault";
			} else if("3".equals(pvDetail.get(0).getStatus())) {
				statusNm = "Warning";
			}
			result.put("pvStatus", pvDetail.get(0).getStatus());
			result.put("pvStatusNm", statusNm);
		}
		result.put("temperature", (pvDetail == null) || pvDetail.size() == 0 ? null : pvDetail.get(0).getTemperature());
		result.put("totalPower", (pvDetail == null || pvDetail.size() == 0) ? null : pvDetail.get(0).getTotalPower());
		System.out.println("최종결과 : "+result.toString());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

}
