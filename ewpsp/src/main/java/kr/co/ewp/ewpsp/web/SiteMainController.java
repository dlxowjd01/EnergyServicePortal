/**
 * class name : SiteMainController
 * description : 사이트메인 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.service.AlarmService;
import kr.co.ewp.ewpsp.service.ControlService;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;
import kr.co.ewp.ewpsp.service.ESSRevenueService;
import kr.co.ewp.ewpsp.service.PVRevenueService;

@Controller
public class SiteMainController {

	private static final Logger logger = LoggerFactory.getLogger(SiteMainController.class);

	@Resource(name="controlService")
	private ControlService controlService;

	@Resource(name="essRevenueService")
	private ESSRevenueService essRevenueService;

	@Resource(name="pvRevenueService")
	private PVRevenueService pvRevenueService;

	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;
	
	@Autowired
	private AlarmService alarmService;

	@RequestMapping("/siteMain")
	public String siteMain() {
		logger.debug("/siteMain");
		
		return "ewp/main/siteMain";
	}

	@RequestMapping("/getAlarmList")
	public @ResponseBody Map<String, Object> getAlarmList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getAlarmList");
		logger.debug("param ::::: "+param.toString());
//		param.put("alarmCfmYn", "N");
		
		Map result = controlService.getDeviceAlarmCnt(param); // 장치별 알람건수
		List alarmList = alarmService.getMainAlarmList(param); // 최근 알람 목록 조회(3건)
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		resultMap.put("alarmList", alarmList);
		return resultMap;
	}
	
	@RequestMapping("/getDeviceList")
	public @ResponseBody Map<String, Object> getDeviceIOEList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceList");
		logger.debug("param ::::: "+param.toString());
		
		List deviceList = deviceMonitoringService.getDeviceList(param);
		logger.debug("deviceList : "+deviceList.toString());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("deviceList", deviceList);
		return resultMap;
	}
	
	@RequestMapping("/getRevenueList")
	public @ResponseBody Map<String, Object> getRevenueList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		List essRevenueList = essRevenueService.getESSRevenueList_test(param);
		List pvRevenueList = pvRevenueService.getPVRevenueList_test(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("essRevenueList", essRevenueList);
		resultMap.put("pvRevenueList", pvRevenueList);
		return resultMap;
	}
	
	
}
