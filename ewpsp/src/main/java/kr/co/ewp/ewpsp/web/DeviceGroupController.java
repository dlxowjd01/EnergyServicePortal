/**
 * class name : DeviceGroupController
 * description : 장치그룹 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

import java.lang.reflect.Array;
import java.util.Arrays;
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
	 * 장치그룹내 장치목록(팝업) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDvInDeviceGroupPopupList")
	public @ResponseBody Map<String, Object> getDvInDeviceGroupPopupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDvInDeviceGroupList");
		logger.debug("param ::::: "+param.toString());
		
		List dvInDeviceGrouplist = deviceGroupService.getDvInDeviceGroupList(param);
		List allDvInSiteList = deviceGroupService.getAllDvInSiteList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("dvInDeviceGrouplist", dvInDeviceGrouplist);
		resultMap.put("allDvInSiteList", allDvInSiteList);
		return resultMap;
	}

	/**
	 * 장치그룹 내 장치 추가/제거
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveDvInDvGrp")
	public @ResponseBody Map<String, Object> saveDvInDvGrp(@RequestParam HashMap param) throws Exception {
		logger.debug("/saveDvInDvGrp");
		logger.debug("param ::::: "+param.toString());
		
		String selDvGrpIdx = (String) param.get("selDvGrpIdx"); // 그룹 목록
		String nowDeviceIds = (String) param.get("nowDeviceIds"); // 기존 그룹내 장치목록
		String newDeviceIds = (String) param.get("newDeviceIds"); // 변경할 그룹내 장치목록
		String nowDeviceIds_arr[] = null; // 기존 그룹내 장치목록
		String newDeviceIds_arr[] = null; // 변경할 그룹내 장치목록 
		if(nowDeviceIds != null && !"".equals(nowDeviceIds)) {
			nowDeviceIds_arr = nowDeviceIds.split(",");
		}
		if(newDeviceIds != null && !"".equals(newDeviceIds)) {
			newDeviceIds_arr = newDeviceIds.split(",");
		}
		
		// 기존목록과 변경목록이 동일한지 확인 -> 동일하면 변경사항 없음
		String changeYn = "Y";
		changeYn = ( Arrays.equals(nowDeviceIds_arr, newDeviceIds_arr) ) ? "N" : "Y"; 
		
		if("Y".equals(changeYn)) {
			// 로직 : 기존장치목록과 변경된장치목록을 비교한다.
			// 기존장치에 존재하고 변경된 장치목록에 미존재 : 그룹에저 제외됨
			// 기존장치에도 존재하고 변경된 장치목록에도 존재 : 변동없음
			// 기존장치에 미존재하고 변경된 장치목록에 존재 : 그룹에 새로 추가됨
			// 기존장치목록이 있는데 변경된 장치목록이 null일 경우 : 그룹에서 전부 제외됨
			// 기존장치목록이 null인데 변경된 장치목록이 존재 : 빈 그룹에 새로 추가됨
			int addCnt = 0;
			int delCnt = 0;
			if(nowDeviceIds_arr != null) {
				if(nowDeviceIds_arr.length > 0) { // 기존장치목록의 데이터를 변동된장치목록에 존재하는지 확인
					for (int i = 0; i < nowDeviceIds_arr.length; i++) {
						String str = nowDeviceIds_arr[i];
						boolean res = false;
						if(newDeviceIds_arr != null) Arrays.asList(newDeviceIds_arr).contains(str);
						if(!res) { // 기존장치에 존재하고 변경된 장치목록에 미존재 : 그룹에저 제외됨
							HashMap dvMap = new HashMap<String, Object>();
							dvMap.put("deviceId", str);
							dvMap.put("deviceGrpIdx", 0);
							dvMap.put("modUid", "tttt");
							int cnt = deviceGroupService.updateDevice(dvMap);
							delCnt = delCnt + cnt;
						}
					}
				}
				
			} else {
				for (int i = 0; i < newDeviceIds_arr.length; i++) {
					HashMap dvMap = new HashMap<String, Object>();
					dvMap.put("deviceId", newDeviceIds_arr[i]);
					dvMap.put("deviceGrpIdx", selDvGrpIdx);
					dvMap.put("modUid", "tttt");
					int cnt = deviceGroupService.updateDevice(dvMap);
					addCnt = addCnt + cnt;
				}
			}
			
			if(newDeviceIds_arr != null) {
				if(newDeviceIds_arr.length > 0) { // 변동된장치목록의 데이터를 기존장치목록에 존재하는지 확인
					for (int i = 0; i < newDeviceIds_arr.length; i++) {
						String str = newDeviceIds_arr[i];
						boolean res = false;
						if(nowDeviceIds_arr != null) Arrays.asList(nowDeviceIds_arr).contains(str);
						if(!res) { // 기존장치에 미존재하고 변경된 장치목록에 존재 : 그룹에 새로 추가됨
							HashMap dvMap = new HashMap<String, Object>();
							dvMap.put("deviceId", str);
							dvMap.put("deviceGrpIdx", selDvGrpIdx);
							dvMap.put("modUid", "tttt");
							int cnt = deviceGroupService.updateDevice(dvMap);
							addCnt = addCnt + cnt;
						}
					}
				}
			} else {
				for (int i = 0; i < nowDeviceIds_arr.length; i++) {
					HashMap dvMap = new HashMap<String, Object>();
					dvMap.put("deviceId", nowDeviceIds_arr[i]);
					dvMap.put("deviceGrpIdx", 0);
					dvMap.put("modUid", "tttt");
					int cnt = deviceGroupService.updateDevice(dvMap);
					delCnt = delCnt + cnt;
				}
			}
			
		}
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", 0);
		resultMap.put("changeYn", changeYn);
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
