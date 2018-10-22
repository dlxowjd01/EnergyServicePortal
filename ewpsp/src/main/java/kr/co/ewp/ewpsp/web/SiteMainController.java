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
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
//		param.put("alarmCfmYn", "N");
		
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
		
		Map result = essChargeService.getESSChargeSum(param); // ess 충방전량 합계 조회
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultListMap", result);
		return resultMap;
	}
	
	@RequestMapping("/getDeviceList")
	public @ResponseBody Map<String, Object> getDeviceIOEList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 8;
		int startNum = pageRowCnt*(selPageNum-1);
		
//		param.put("siteId", "");
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		List deviceList = deviceMonitoringService.getDeviceList(param);
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
		resultMap.put("deviceList", deviceList);
		resultMap.put("pagingMap", pagingMap);
		return resultMap;
	}
	
	@RequestMapping("/getRevenueList")
	public @ResponseBody Map<String, Object> getRevenueList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getRevenueList");
		logger.debug("param ::::: "+param.toString());
		
		String selTermFrom = (String) param.get("selTermFrom");
		String selTermTo = (String) param.get("selTermTo");
		
//		List pvRevenueList = pvRevenueService.getPVRevenueList_test(param);
		param.put("selPeriodVal", "month");
		Map result = pvRevenueService.getPVRevenueList(param);
		List totPriceList = (List) result.get("totPriceList");
		
		param.put("selTermFrom", selTermFrom.substring(0, 6));
		param.put("selTermTo", selTermTo.substring(0, 6));
		
		List essRevenueList = null;//essRevenueService.getESSRevenueList(param);
		List drRevenueList = null;//drRevenueService.getDRRevenueList(param);

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
