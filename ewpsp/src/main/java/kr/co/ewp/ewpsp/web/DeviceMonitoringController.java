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
	public @ResponseBody Map<String, Object> getDeviceIOEList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceIOEList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", "17094385");
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
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	@RequestMapping("/getDevicePCSList")
	public @ResponseBody Map<String, Object> getDevicePCSList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDevicePCSList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", "17094385");
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
	public @ResponseBody Map<String, Object> getDevicePCSDetail(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDevicePCSDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = deviceMonitoringService.getDevicePCSDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	@RequestMapping("/getDeviceBMSList")
	public @ResponseBody Map<String, Object> getDeviceBMSList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceBMSList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", "17094385");
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
	public @ResponseBody Map<String, Object> getDeviceBMSDetail(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceBMSDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = deviceMonitoringService.getDeviceBMSDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	@RequestMapping("/getDevicePVList")
	public @ResponseBody Map<String, Object> getDevicePVList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDevicePVList");
		logger.debug("param ::::: "+param.toString());
		
		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
		param.put("siteId", "17094385");
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
	public @ResponseBody Map<String, Object> getDevicePVDetail(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDevicePVDetail");
		logger.debug("param ::::: "+param.toString());
		
		Map result = deviceMonitoringService.getDevicePVDetail(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}

}
