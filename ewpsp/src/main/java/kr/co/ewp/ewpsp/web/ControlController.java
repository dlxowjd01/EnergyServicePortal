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

import kr.co.ewp.ewpsp.service.ControlService;

@Controller
public class ControlController {

	private static final Logger logger = LoggerFactory.getLogger(ControlController.class);

	@Resource(name="controlService")
	private ControlService controlService;

	@RequestMapping("/control")
	public String main(Model model, HttpServletRequest request) {
		logger.debug("/control");
		
//		model.addAttribute("deviceGbn", request.getParameter("deviceGbn"));
		
		return "ewp/control/control";
	}

	/**
	 * 장치구분별 알람건수 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDeviceAlarmCnt")
	public @ResponseBody Map<String, Object> getDeviceAlarmCnt(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceAlarmCnt");
		logger.debug("param ::::: "+param.toString());
		
		Map result = controlService.getDeviceAlarmCnt(param); // 장치별 알람건수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("detail", result);
		return resultMap;
	}
	
	/**
	 * 비상 알람 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getWarningAlarmList")
	public @ResponseBody Map<String, Object> getWarningAlarmList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getWarningAlarmList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
//		param.put("siteId", "17094385");
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		param.put("alarmType", 1); // 비상
		List list = controlService.getAlarmList(param);// 알람 목록
		int listCnt = controlService.getAlarmListCnt(param);
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
	
	/**
	 * 주의 알람 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getAlertAlarmList")
	public @ResponseBody Map<String, Object> getAlertAlarmList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getAlertAlarmList");
		logger.debug("param ::::: "+param.toString());

		int selPageNum = Integer.parseInt((String) param.get("selPageNum"));
		int pageRowCnt = 5;
		int startNum = pageRowCnt*(selPageNum-1);
		
//		param.put("siteId", "17094385");
		param.put("startNum", startNum);
		param.put("pageRowCnt", pageRowCnt);
		
		param.put("alarmType", 2); // 주의
		List list = controlService.getAlarmList(param); // 알람 목록
		int listCnt = controlService.getAlarmListCnt(param);
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

	@RequestMapping("/getSmsAddresseeList")
	public @ResponseBody Map<String, Object> getSmsAddresseeList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getSmsAddresseeList");
		logger.debug("param ::::: "+param.toString());
		
		param.put("siteId", "17094385");
		
		List list = controlService.getSmsAddresseeList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	@RequestMapping("/insertAddressee")
	public @ResponseBody Map<String, Object> insertAddressee(@RequestParam HashMap param) throws Exception {
		logger.debug("/insertAddressee");
		logger.debug("param ::::: "+param.toString());
		
		param.put("siteId", "17094385");
		
		int resultCnt = controlService.insertAddressee(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	@RequestMapping("/deleteAddressee")
	public @ResponseBody Map<String, Object> deleteAddressee(@RequestParam HashMap param) throws Exception {
		logger.debug("/deleteAddressee");
		logger.debug("param ::::: "+param.toString());
		
		int resultCnt = controlService.deleteAddressee(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

}
