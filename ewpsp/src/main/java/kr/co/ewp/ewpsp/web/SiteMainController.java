/**
 * class name : SiteMainController
 * description : 사이트메인 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.ewp.ewpsp.common.energy.PeriodDataSetting;
import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil;
import kr.co.ewp.ewpsp.common.util.PMGrowApiUtil;
import kr.co.ewp.ewpsp.model.BmsEquipmentModel;
import kr.co.ewp.ewpsp.model.DeviceModel;
import kr.co.ewp.ewpsp.model.PcsEquipmentModel;
import kr.co.ewp.ewpsp.model.PvEquipmentModel;
import kr.co.ewp.ewpsp.service.AlarmService;
import kr.co.ewp.ewpsp.service.ControlService;
import kr.co.ewp.ewpsp.service.DRRevenueService;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;
import kr.co.ewp.ewpsp.service.ESSChargeService;
import kr.co.ewp.ewpsp.service.ESSRevenueService;
import kr.co.ewp.ewpsp.service.PVRevenueService;

@Controller
public class SiteMainController {

	private static final Logger logger = LoggerFactory.getLogger(SiteMainController.class);

	@Resource(name="controlService")
	private ControlService controlService;

	@Resource(name="essChargeService")
	private ESSChargeService essChargeService;

	@Resource(name="essRevenueService")
	private ESSRevenueService essRevenueService;

	@Resource(name="pvRevenueService")
	private PVRevenueService pvRevenueService;

	@Resource(name="drRevenueService")
	private DRRevenueService drRevenueService;

	@Resource(name="deviceMonitoringService")
	private DeviceMonitoringService deviceMonitoringService;
	
	@Autowired
	private AlarmService alarmService;

	@RequestMapping("/siteMain")
	public String siteMain(@RequestParam HashMap param, HttpSession session, Model model) {
		logger.debug("/siteMain + "+param.get("siteId"));
		
		return "ewp/main/siteMain";
	}

	@RequestMapping("/getAlarmList")
	public @ResponseBody Map<String, Object> getAlarmList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getAlarmList");
		logger.debug("param ::::: "+param.toString());
		
		param = PeriodDataSetting.setSearchTerm(param);
		
		Map result = controlService.getDeviceAlarmCnt(param); // 장치별 알람건수
		List alarmList = alarmService.getMainAlarmList(param); // 최근 알람 목록 조회(3건)
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		resultMap.put("alarmList", alarmList);
		return resultMap;
	}
	
	@RequestMapping("/getESSChargeSum")
	public @ResponseBody Map<String, Object> getESSChargeSum(@RequestParam HashMap param) throws Exception {
		logger.debug("/getESSChargeSum");
		logger.debug("param ::::: "+param.toString());
		
		param = PeriodDataSetting.setSearchTerm(param);
		
		Map result = essChargeService.getESSChargeSum(param); // ess 충방전량 합계 조회
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultListMap", result);
		return resultMap;
	}
	
	@RequestMapping("/getDeviceList")
	public @ResponseBody Map<String, Object> getDeviceList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 8;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List deviceList = deviceMonitoringService.getDeviceList(param);
		List newDeviceList = new ArrayList();
		if(deviceList != null && deviceList.size() > 0) {
			Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
			String host = (String) siteDetail.get("local_ems_addr");
			for(int i=0; i<deviceList.size(); i++) {
				Map<String, Object> deviceMap = new HashMap<String, Object>();
				deviceMap = (Map<String, Object>) deviceList.get(i);
				String deviceType = (String) deviceMap.get("device_type");
				if("1".equals(deviceType)) { // PCS
					PcsEquipmentModel pcsDetail = PMGrowApiUtil.getPcsEquipmentList(host, (String) deviceMap.get("device_id"));
					if(pcsDetail != null) {
						Integer acPower = (pcsDetail.getAcPower() == null) ? 0 : pcsDetail.getAcPower();
						Integer dcPower = (pcsDetail.getDcPower() == null) ? 0 : pcsDetail.getDcPower();
						deviceMap.put("apiPower", acPower+dcPower);
					}
					
				} else if("2".equals(deviceType)) { // BMS
					BmsEquipmentModel bmsDetail = PMGrowApiUtil.getBmsEquipmentList(host, (String) deviceMap.get("device_id"));
					if(bmsDetail != null) {
						Integer soc = (bmsDetail.getSysSoc() == null) ? 0 : bmsDetail.getSysSoc();
						deviceMap.put("apiSoc", soc);
					}
					
				} else if("3".equals(deviceType)) { // PV(localEMS)
					PvEquipmentModel pvDetail = PMGrowApiUtil.getPvEquipmentList(host, (String) deviceMap.get("device_id"));
					if(pvDetail != null) {
						Integer totPower = (pvDetail.getTotalGenPower() == null) ? 0 : pvDetail.getTotalGenPower();
						deviceMap.put("apiTotPower", totPower);
					}
					
				} else if("5".equals(deviceType)) { // PV(Enertalk)
					DeviceModel ioeDetail = EnertalkApiUtil.getDevice((String) deviceMap.get("device_id"));
					if(ioeDetail != null) {
						Date upLoadedAt = ioeDetail.getUploadedAt();
						if(upLoadedAt != null) {
							if(new Date().getTime() - upLoadedAt.getTime() > 120000) { // 2분 보다 크면 disconnect
								deviceMap.put("apiStatus", 2);
							} else {
								deviceMap.put("apiStatus", 1);
							}
						} else {
							deviceMap.put("apiStatus", 2);
						}
					}
					
				} else {
					DeviceModel ioeDetail = EnertalkApiUtil.getDevice((String) deviceMap.get("device_id"));
					if(ioeDetail != null) {
						Date upLoadedAt = ioeDetail.getUploadedAt();
						if(upLoadedAt != null) {
							if(new Date().getTime() - upLoadedAt.getTime() > 120000) { // 2분 보다 크면 disconnect
								deviceMap.put("apiStatus", 2);
							} else {
								deviceMap.put("apiStatus", 1);
							}
						} else {
							deviceMap.put("apiStatus", 2);
						}
					}
				}
				newDeviceList.add(deviceMap);
			}
		} else {
			newDeviceList = deviceList;
		}
		
		int listCnt = deviceMonitoringService.getDeviceListCnt(param);
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
		resultMap.put("deviceList", newDeviceList);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}
	
	@RequestMapping("/getRevenueList")
	public @ResponseBody Map<String, Object> getRevenueList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		param = PeriodDataSetting.setSearchTerm(param);
		
		String selTermFrom = (String) param.get("selTermFrom");
		String selTermTo = (String) param.get("selTermTo");
		
		// pv 수익 조회
		Date today = new Date();
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(   today.getTime()   );
		cal.set(Calendar.DATE, 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		Date start = new Timestamp(cal.getTime().getTime());
		param.put("selTermFrom", CommonUtils.convertDateFormat(start, "yyyyMMddHHmmss"));
		
		Calendar cal2 = Calendar.getInstance();
		cal2.setTimeInMillis(   today.getTime()   );
		cal2.set(Calendar.DATE, cal2.getActualMaximum(Calendar.DAY_OF_MONTH));
		cal2.set(Calendar.HOUR_OF_DAY, 23);
		cal2.set(Calendar.MINUTE, 59);
		cal2.set(Calendar.SECOND, 59);
		Date end = new Timestamp(cal2.getTime().getTime());
		param.put("selTermTo", CommonUtils.convertDateFormat(end, "yyyyMMddHHmmss"));
		
		param.put("selTerm", "month");
		param.put("selPeriodVal", "day");
		logger.debug("                                   param ::::: "+param.toString());
		Map result = pvRevenueService.getPVRevenueList(param, request);
		Map totPriceMap = (Map) result.get("totPriceMap");
		List totPriceList = (totPriceMap == null) ? null : (List) totPriceMap.get("chartList");
		
		// ess 수익 조회
		String siteId = (String) param.get("siteId");
		List essRevenueList = essRevenueService.getESSRevenueDayList(param); // api로 변경
		
		// dr 수익 조회
		param.put("selTermFrom", selTermFrom.substring(0, 6));
		param.put("selTermTo", selTermTo.substring(0, 6));
		param.put("selPeriodVal", "day");
		Map drRevenueMap = drRevenueService.getDRRevenueList(param);
		List drRevenueList = (List) drRevenueMap.get("chartList");

		List loopCntList = null;
		String loopGbn = "";
		if(essRevenueList != null && essRevenueList.size() > 0) {
			loopCntList = essRevenueList;
			loopGbn = "ess";
		} else if(totPriceList != null && totPriceList.size() > 0) {
			loopCntList = totPriceList;
			loopGbn = "pv";
		} else if(drRevenueList != null && drRevenueList.size() > 0) {
			loopCntList = drRevenueList;
			loopGbn = "dr";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("essRevenueList", essRevenueList);
		resultMap.put("pvRevenueList", totPriceList);
		resultMap.put("drRevenueList", drRevenueList);
		resultMap.put("loopCntList", loopCntList);
		resultMap.put("loopGbn", loopGbn);
		return resultMap;
	}

}
