package kr.co.esp.device.web;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.esp.api.model.AmiEquipmentModel;
import kr.co.esp.api.model.BmsEquipmentModel;
import kr.co.esp.api.model.BmsEquipmentModelBefore;
import kr.co.esp.api.model.DeviceModel;
import kr.co.esp.api.model.PcsEquipmentModel;
import kr.co.esp.api.model.PcsEquipmentModelBefore;
import kr.co.esp.api.model.PvEquipmentModel;
import kr.co.esp.api.model.PvEquipmentModelBefore;
import kr.co.esp.common.util.EnertalkApiUtil;
import kr.co.esp.common.util.PMGrowApiUtil;
import kr.co.esp.common.util.PMGrowApiUtilBefore;
import kr.co.esp.device.service.DeviceMonitoringService;
import kr.co.esp.energy.PeriodDataSetting;

@Controller
public class DeviceController {

	private static final Logger logger = LoggerFactory.getLogger(DeviceController.class);
	
	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;

	@RequestMapping(value = "/device/deviceState.do")
	public String groupDashboard(HttpServletRequest request, HttpSession session, Model model) {
		System.out.println("/device/deviceState.do");
		return "esp/device/deviceState";
	}

//	@RequestMapping("/main/getDeviceList.json")
//	public @ResponseBody Map<String, Object> getDeviceList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
//		logger.debug("/main/getDeviceList.json");
//		logger.debug("param ::::: " + param.toString());
//
//		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
//		int pageRowCnt = 8;
//		int startNum = pageRowCnt * (selPageNum - 1);
//
//		param.put("startNum", startNum);
//		param.put("pageRowCnt", pageRowCnt);
//
//		List<Map<String, Object>> deviceList = deviceMonitoringService.getDeviceList(param);
//		List<Map<String, Object>> newDeviceList = new ArrayList<Map<String, Object>>();
//		if (deviceList != null && deviceList.size() > 0) {
//			Map<String, Object> siteDetail = (Map<String, Object>) request.getSession().getAttribute("selViewSite");
//			String host = (String) siteDetail.get("local_ems_addr");
//			String apiVer = (String) siteDetail.get("local_ems_api_ver");
//			for (int i = 0; i < deviceList.size(); i++) {
//				Map<String, Object> deviceMap = new HashMap<String, Object>();
//				deviceMap = (Map<String, Object>) deviceList.get(i);
//				String deviceType = (String) deviceMap.get("device_type");
//				if ("1".equals(deviceType)) { // PCS
//					if ("1.1".equals(apiVer)) { // 기존
//						PcsEquipmentModelBefore pcsDetail = PMGrowApiUtilBefore.getPcsEquipmentList(host, (String) deviceMap.get("device_id"));
//						if (pcsDetail != null) {
////							for (PcsEquipmentModelBefore pcsDetail : pcsDetailList) {
//								Float acPower = (pcsDetail.getAcPower() == null) ? 0 : pcsDetail.getAcPower();
//								Float dcPower = (pcsDetail.getDcPower() == null) ? 0 : pcsDetail.getDcPower();
//								deviceMap.put("apiPower", acPower + dcPower);
//								deviceMap.put("pcs_device_stat", pcsDetail.getPcsStatus());
////							}
//						} else {
//							deviceMap.put("apiPower", "-");
//							deviceMap.put("pcs_device_stat", 0);
//						}
//					} else {
//						PcsEquipmentModel pcsDetail = PMGrowApiUtil.getPcsEquipmentList(host, (String) deviceMap.get("device_id"));
//						if (pcsDetail != null) {
//							Float acPower = (pcsDetail.getAcPower() == null) ? 0 : pcsDetail.getAcPower();
//							Float dcPower = (pcsDetail.getDcPower() == null) ? 0 : pcsDetail.getDcPower();
//							deviceMap.put("apiPower", acPower + dcPower);
//							deviceMap.put("pcs_device_stat", pcsDetail.getPcsStatus());
//						} else {
//							deviceMap.put("apiPower", "-");
//							deviceMap.put("pcs_device_stat", 0);
//						}
//					}
//
//				} else if ("2".equals(deviceType)) { // BMS
//					if ("1.1".equals(apiVer)) { // 기존
//						BmsEquipmentModelBefore bmsDetail = PMGrowApiUtilBefore.getBmsEquipmentList(host, (String) deviceMap.get("device_id"));
//						if (bmsDetail != null) {
////							for (BmsEquipmentModelBefore bmsDetail : bmsDetailList) {
//								Float soc = (bmsDetail.getSysSoc() == null) ? 0 : bmsDetail.getSysSoc();
//								deviceMap.put("apiSoc", soc);
//								deviceMap.put("bms_device_stat", bmsDetail.getSysMode());
////							}
//						} else {
//							deviceMap.put("apiSoc", "-");
//							deviceMap.put("bms_device_stat", 0);
//						}
//					} else {
//						BmsEquipmentModel bmsDetail = PMGrowApiUtil.getBmsEquipmentList(host, (String) deviceMap.get("device_id"));
//						if (bmsDetail != null) {
//							Float soc = (bmsDetail.getSysSoc() == null) ? 0 : bmsDetail.getSysSoc();
//							deviceMap.put("apiSoc", soc);
//							deviceMap.put("bms_device_stat", bmsDetail.getSysMode());
//						} else {
//							deviceMap.put("apiSoc", "-");
//							deviceMap.put("bms_device_stat", 0);
//						}
//					}
//
//				} else if ("3".equals(deviceType)) { // PV(localEMS)
//					if ("1.1".equals(apiVer)) { // 기존
//						PvEquipmentModelBefore pvDetail = PMGrowApiUtilBefore.getPvEquipmentList(host, (String) deviceMap.get("device_id"));
//						if (pvDetail != null) {
//							Float totPower = (pvDetail.getTotalGenPower() == null) ? 0 : pvDetail.getTotalGenPower();
//							deviceMap.put("apiTotPower", totPower);
//							deviceMap.put("pv_device_stat", pvDetail.getStatus());
//						} else {
//							deviceMap.put("apiTotPower", "-");
//							deviceMap.put("pv_device_stat", 0);
//						}
//					} else {
//						PvEquipmentModel pvDetail = PMGrowApiUtil.getPvEquipmentList(host, (String) deviceMap.get("device_id"));
//						if (pvDetail != null) {
//							Integer totPower = (pvDetail.getTotalGenPower() == null) ? 0 : pvDetail.getTotalGenPower();
//							deviceMap.put("apiTotPower", totPower);
//							deviceMap.put("pv_device_stat", pvDetail.getStatus());
//						} else {
//							deviceMap.put("apiTotPower", "-");
//							deviceMap.put("pv_device_stat", 0);
//						}
//					}
//
//				} else if ("9".equals(deviceType)) { // AMI
//					AmiEquipmentModel amiModel = null;
//					if ("1.1".equals(apiVer)) { // 기존
//						amiModel = PMGrowApiUtilBefore.getAmiEquipmentList(host, (String) deviceMap.get("device_id"));
//					} else {
//						amiModel = PMGrowApiUtil.getAmiEquipmentList(host, (String) deviceMap.get("device_id"));
//					}
//					if(amiModel != null) {
//						String statusNm = "";
//						if(amiModel.getStatus() == null) {
//							statusNm = "Stop";
//						} else if(amiModel.getStatus() == 0) {
//							statusNm = "Stop";
//						} else if(amiModel.getStatus() == 1) {
//							statusNm = "Run";
//						} else if(amiModel.getStatus() == 2) {
//							statusNm = "Fault";
//						} else if(amiModel.getStatus() == 3) {
//							statusNm = "Warning";
//						} else {
//							statusNm = "disconnect";
//						}
//						deviceMap.put("ami_device_stat", amiModel.getStatus());
//						deviceMap.put("ami_status_nm", statusNm);
//					} else {
//						deviceMap.put("ami_device_stat", 2);
//						deviceMap.put("ami_status_nm", "disconnect");
//					}
//
//				} else { // (deviceType == 4, 5, 6, 7, 8)
//					DeviceModel ioeDetail = EnertalkApiUtil.getDevice((String) deviceMap.get("device_id"));
//					if (ioeDetail != null) {
//						Date upLoadedAt = ioeDetail.getUploadedAt();
//						if (upLoadedAt != null) {
//							if (new Date().getTime() - upLoadedAt.getTime() > 120000) { // 2분 보다 크면 disconnect
//								deviceMap.put("apiStatus", 2);
//							} else {
//								deviceMap.put("apiStatus", 1);
//							}
//						} else {
//							deviceMap.put("apiStatus", 2);
//						}
//					} else deviceMap.put("apiStatus", 2);
//
//				}
//				newDeviceList.add(deviceMap);
//			}
//		} else {
//			newDeviceList = deviceList;
//		}
//
//		int listCnt = deviceMonitoringService.getDeviceListCnt(param);
//		int totalPageCnt = 0;
//		if (listCnt > 0) {
//			totalPageCnt = listCnt / pageRowCnt;
//			if (listCnt % pageRowCnt > 0) {
//				totalPageCnt++;
//			}
//		}
//
//		Map<String, Object> pagingMap = new HashMap<String, Object>();
//		pagingMap.put("pageRowCnt", pageRowCnt); // 한 페이지 당 보여줄 데이터 수
//		pagingMap.put("selPageNum", selPageNum); // 선택한 페이지번호
//		pagingMap.put("listCnt", listCnt); // 전체 데이터 수
//		pagingMap.put("totalPageCnt", totalPageCnt); // 전체 페이지 수
//
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("deviceList", newDeviceList);
//		resultMap.put("pagingMap", pagingMap);
//		return resultMap;
//	}
	
	// 임시 영역
	@RequestMapping("/main/getDeviceList.json")
	public @ResponseBody Map<String, Object> getDeviceList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/main/getDeviceList.json");
		logger.debug("param ::::: " + param.toString());
		List<Map<String, Object>> deviceList = deviceMonitoringService.getDeviceList(param);							

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("deviceList", deviceList);
		return resultMap;
	}
	
	@RequestMapping("main/getDeviceType.json")
	public @ResponseBody Map<String, Object> getDeviceType(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/main/getDeviceType.json");
		logger.debug("param ::::: " + param.toString());
		
		List<Map<String, Object>> typeList = new ArrayList<>();
		typeList = deviceMonitoringService.getDeviceType(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("typeList", typeList);
		return resultMap;
	}

	@RequestMapping("main/getDataByType.json")
	public @ResponseBody Map<String, Object> getDataByType(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/main/getDataByType.json");
		logger.debug("param ::::: " + param.toString());
		
		List<Map<String, Object>> dataList = deviceMonitoringService.getDataByType(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("dataList", dataList);
		return resultMap;
	}
	
	//발전량 조회
	@RequestMapping("/main/getGenRealList.json")
	public @ResponseBody Map<String, Object> getGenRealList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/main/getGenRealList.json");
		logger.debug("param ::::: " + param.toString());
		
		param = PeriodDataSetting.setSearchTerm(param);
		//발전량 추이
		List<Map<String, Object>> genRealList = deviceMonitoringService.getGenRealList(param);
		
		//인버터 이용률(전체 발전량)
		String[] inverterIdList = deviceMonitoringService.getInverterIdList(param);
		List<String[]> inverterDataList = new ArrayList<String[]>();
		if (inverterIdList.length > 0) {
			for(String s: inverterIdList) {
				param.put("inverterId", s);
				String[] genInverterData = deviceMonitoringService.genInverterData(param);
				inverterDataList.add(genInverterData);
			}
		}
		//금일 발전량, 계획발전량(작년 발전량)
		Map<String, Object> todayGenData = deviceMonitoringService.getTodayGenData(param);
		double now_pwr = (double) todayGenData.get("now_pwr");
		double daily_pwr = (double) todayGenData.get("daily_pwr");
		double ratio = (now_pwr / daily_pwr)*100;
		DecimalFormat dform = new DecimalFormat("#.#");
		
		todayGenData.put("ratio", dform.format(ratio));
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("todayGenData", todayGenData);
		resultMap.put("genRealList", genRealList);
		resultMap.put("inverterIdList", inverterIdList);
		resultMap.put("inverterDataList", inverterDataList);
		return resultMap;
	}
	// 임시 영역
	
	
}
