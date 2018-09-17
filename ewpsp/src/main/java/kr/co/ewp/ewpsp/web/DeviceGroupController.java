package kr.co.ewp.ewpsp.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.ewp.ewpsp.service.DeviceGroupService;

@Controller
public class DeviceGroupController {

	private static final Logger logger = LoggerFactory.getLogger(DeviceGroupController.class);

	@Resource(name="deviceGroupService")
	private DeviceGroupService deviceGroupService;

	@RequestMapping("/deviceGroup")
	public String main(Model model, HttpServletRequest request) {
		logger.debug("/deviceGroup "+request.getParameter("deviceGbn"));
		
		model.addAttribute("deviceGbn", request.getParameter("deviceGbn"));
		
		return "ewp/device/deviceGroup";
	}

//	@RequestMapping("/getDeviceIOEList")
//	public @ResponseBody Map<String, Object> getDeviceIOEList(@RequestParam HashMap param) throws Exception {
//		logger.debug("/getDeviceIOEList");
//		logger.debug("param ::::: "+param.toString());
//		
//		List list = deviceGroupService.getDeviceIOEList(param);
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("list", list);
//		return resultMap;
//	}
//
//	@RequestMapping("/getDeviceIOEDetail")
//	public @ResponseBody Map<String, Object> getDeviceIOEDetail(@RequestParam HashMap param) throws Exception {
//		logger.debug("/getDeviceIOEDetail");
//		logger.debug("param ::::: "+param.toString());
//		
//		Map result = deviceGroupService.getDeviceIOEDetail(param);
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("detail", result);
//		return resultMap;
//	}
//	
//	@RequestMapping("/getDevicePCSList")
//	public @ResponseBody Map<String, Object> getDevicePCSList(@RequestParam HashMap param) throws Exception {
//		logger.debug("/getDevicePCSList");
//		logger.debug("param ::::: "+param.toString());
//		
//		List list = deviceGroupService.getDevicePCSList(param);
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("list", list);
//		return resultMap;
//	}
//	
//	@RequestMapping("/getDeviceBMSList")
//	public @ResponseBody Map<String, Object> getDeviceBMSList(@RequestParam HashMap param) throws Exception {
//		logger.debug("/getDeviceBMSList");
//		logger.debug("param ::::: "+param.toString());
//		
//		List list = deviceGroupService.getDeviceBMSList(param);
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("list", list);
//		return resultMap;
//	}
//	
//	@RequestMapping("/getDevicePVList")
//	public @ResponseBody Map<String, Object> getDevicePVList(@RequestParam HashMap param) throws Exception {
//		logger.debug("/getDevicePVList");
//		logger.debug("param ::::: "+param.toString());
//		
//		List list = deviceGroupService.getDevicePVList(param);
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("list", list);
//		return resultMap;
//	}

}
