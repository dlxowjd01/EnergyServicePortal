/**
 * class name : DeviceGroupController
 * description : 장치그룹 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

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

import kr.co.ewp.ewpsp.service.DeviceGroupService;

@Controller
public class DeviceGroupController {

	private static final Logger logger = LoggerFactory.getLogger(DeviceGroupController.class);

	@Resource(name="deviceGroupService")
	private DeviceGroupService deviceGroupService;

	@RequestMapping("/deviceGroup")
	public String main(Model model, HttpServletRequest request) {
		logger.debug("/deviceGroup");
		
		return "ewp/device/deviceGroup";
	}

	/**
	 * 장치그룹목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDeviceGroupList")
	public @ResponseBody Map<String, Object> getDeviceGroupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDeviceGroupList");
		logger.debug("param ::::: "+param.toString());
		
		List list = deviceGroupService.getDeviceGroupList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	/**
	 * 장치그룹내 장치목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDvInDeviceGroupList")
	public @ResponseBody Map<String, Object> getDvInDeviceGroupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDvInDeviceGroupList");
		logger.debug("param ::::: "+param.toString());
		
		List list = deviceGroupService.getDvInDeviceGroupList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}

	/**
	 * 장치 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertDevice")
	public @ResponseBody Map<String, Object> insertDevice(@RequestParam HashMap param) throws Exception {
		logger.debug("/insertGroup");
		logger.debug("param ::::: "+param.toString());
		param.put("regUid", "test7654");
//		param.put("siteId", "17094385");
		param.put("userIdx", "1");
		
		int resultCnt = deviceGroupService.insertDevice(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

}
