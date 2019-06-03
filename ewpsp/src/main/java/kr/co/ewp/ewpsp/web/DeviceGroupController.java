/**
 * class name : DeviceGroupController
 * description : 장치그룹 현황 화면 controller
 * version : 1.0
 * author : 이우람
 */

package kr.co.ewp.ewpsp.web;

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

import kr.co.ewp.ewpsp.common.util.UserUtil;
import kr.co.ewp.ewpsp.service.CmpyGrpSiteMngService;
import kr.co.ewp.ewpsp.service.DeviceGroupService;

@Controller
public class DeviceGroupController {

	private static final Logger logger = LoggerFactory.getLogger(DeviceGroupController.class);

	@Resource(name="deviceGroupService")
	private DeviceGroupService deviceGroupService;

	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;

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
	public @ResponseBody Map<String, Object> getDeviceGroupList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceGroupList");
		logger.debug("param ::::: {}", param);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
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
	public @ResponseBody Map<String, Object> getDvInDeviceGroupList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/getDvInDeviceGroupList");
		logger.debug("param ::::: {}", param);
		
		List list = deviceGroupService.getDvInDeviceGroupList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	/**
	 * 장치그룹내 장치들의 알람(미조치건) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDeviceGrpAlarmList")
	public @ResponseBody Map<String, Object> getDeviceGrpAlarmList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceGrpAlarmList");
		logger.debug("param ::::: {}", param);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		param.put("alarmType", 1);
		List warningList = deviceGroupService.getDeviceGrpAlarmList(param);
		param.put("alarmType", 2);
		List alertList = deviceGroupService.getDeviceGrpAlarmList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("warningList", warningList);
		resultMap.put("alertList", alertList);
		return resultMap;
	}
	
	/**
	 * 장치그룹내 장치목록(팝업) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDvInDeviceGroupPopupList")
	public @ResponseBody Map<String, Object> getDvInDeviceGroupPopupList(@RequestParam Map<String, Object> param) throws Exception {
		logger.debug("/getDvInDeviceGroupPopupList");
		logger.debug("param ::::: {}", param);
		
		List dvInDeviceGrouplist = deviceGroupService.getDvInDeviceGroupList(param);
		List allDvInSiteList = deviceGroupService.getAllDvInSiteList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("dvInDeviceGrouplist", dvInDeviceGrouplist);
		resultMap.put("allDvInSiteList", allDvInSiteList);
		return resultMap;
	}
	
	/**
	 * 장치목록(사이트 전체 장치 중 장치그룹에 속하지 않은 장치) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDeviceNotInGroupList")
	public @ResponseBody Map<String, Object> getDeviceNotInGroupList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceNotInGroupList");
		logger.debug("param ::::: {}", param);
		
		param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		List deviceNotInGrouplist = deviceGroupService.getDeviceNotInGroupList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", deviceNotInGrouplist);
		return resultMap;
	}

	/**
	 * 장치그룹 내 장치 추가/제거
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveDvInDvGrp")
	public @ResponseBody Map<String, Object> saveDvInDvGrp(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/saveDvInDvGrp");
		logger.debug("param ::::: {}", param);
		
		Map userInfo = UserUtil.getUserInfo(request);
		String siteId = (String) request.getSession().getAttribute("selViewSiteId");
		int selDvGrpIdx = Integer.parseInt((String) param.get("selDvGrpIdx")); // 추가할 그룹id
		String nowDevicePks = (String) param.get("nowDevicePks"); // 기존 그룹내 장치목록 id|type,id|type,id|type,...
		String newDevicePks = (String) param.get("newDevicePks"); // 변경할 그룹내 장치목록 id|type,id|type,id|type,...
		String nowDvPksArr[] = null; // 기존 그룹내 장치목록
		String newDvPksArr[] = null; // 변경할 그룹내 장치목록
		
		if(nowDevicePks != null && !"".equals(nowDevicePks)) {
			nowDvPksArr = nowDevicePks.split(","); // [id|type, id|type, id|type, ...]
		}
		if(newDevicePks != null && !"".equals(newDevicePks)) {
			newDvPksArr = newDevicePks.split(","); // [id|type, id|type, id|type, ...]
		}
		
		// 기존목록과 변경목록이 동일한지 확인 -> 동일하면 변경사항 없음
		String changeYn = ( Arrays.equals(nowDvPksArr, newDvPksArr) ) ? "N" : "Y";
		int addCnt = 0;
		int delCnt = 0;
		if("Y".equals(changeYn)) {
			// 로직 : 기존장치목록과 변경된장치목록을 비교한다.
			// 기존장치에 존재하고 변경된 장치목록에 미존재 : 그룹에저 제외됨
			// 기존장치에도 존재하고 변경된 장치목록에도 존재 : 변동없음
			// 기존장치에 미존재하고 변경된 장치목록에 존재 : 그룹에 새로 추가됨
			// 기존장치목록이 있는데 변경된 장치목록이 null일 경우 : 그룹에서 전부 제외됨
			// 기존장치목록이 null인데 변경된 장치목록이 존재 : 빈 그룹에 새로 추가됨
			if(nowDvPksArr != null) {
				if(nowDvPksArr.length > 0) { // 기존장치목록의 데이터가 변동된장치목록에 존재하는지 확인
					for (int i = 0; i < nowDvPksArr.length; i++) {
						String dvPks = nowDvPksArr[i];
						boolean res = false;
						if(newDvPksArr != null) res = Arrays.asList(newDvPksArr).contains(dvPks);
						if(!res) { // 기존장치에 존재하고 변경된 장치목록에 미존재 : 그룹에서 제외됨
							int cnt = updateDvGrpInDevice(dvPks.split("\\|")/*[id, type]*/, 0, (String) userInfo.get("user_id"), siteId);
							delCnt = delCnt + cnt;
						}
					}
				}
				
			} else {
				for (int i = 0; i < newDvPksArr.length; i++) {
					int cnt = updateDvGrpInDevice(newDvPksArr[i].split("\\|")/*[id, type]*/, selDvGrpIdx, (String) userInfo.get("user_id"), siteId);
					addCnt = addCnt + cnt;
				}
			}
			
			if(newDvPksArr != null) {
				if(newDvPksArr.length > 0) { // 변동된장치목록의 데이터가 기존장치목록에 존재하는지 확인
					for (int i = 0; i < newDvPksArr.length; i++) {
						String dvPks = newDvPksArr[i];
						boolean res = false;
						if(nowDvPksArr != null) res = Arrays.asList(nowDvPksArr).contains(dvPks);
						if(!res) { // 기존장치에 미존재하고 변경된 장치목록에 존재 : 그룹에 새로 추가됨
							int cnt = updateDvGrpInDevice(dvPks.split("\\|")/*[id, type]*/, selDvGrpIdx, (String) userInfo.get("user_id"), siteId);
							addCnt = addCnt + cnt;
						}
					}
				}
			} else {
				for (int i = 0; i < nowDvPksArr.length; i++) {
					int cnt = updateDvGrpInDevice(nowDvPksArr[i].split("\\|")/*[id, type]*/, 0, (String) userInfo.get("user_id"), siteId);
					delCnt = delCnt + cnt;
				}
			}
			
		}
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", addCnt+delCnt);
		resultMap.put("changeYn", changeYn);
		return resultMap;
	}
	
	public int updateDvGrpInDevice(String dvPk[], int dvGrpIdx, String modUid, String siteId) throws Exception {
		HashMap<String, Object> dvMap = new HashMap<String, Object>();
		dvMap.put("deviceId", dvPk[0]);
		dvMap.put("deviceType", dvPk[1]);
		dvMap.put("deviceGrpIdx", dvGrpIdx);
		dvMap.put("modUid", modUid);
		dvMap.put("siteId", siteId);
		
		return deviceGroupService.updateDevice(dvMap);
	}
	
	/**
	 * 장치그룹 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertDeviceGroup")
	public @ResponseBody Map<String, Object> insertDeviceGroup(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/saveDvGrp");
		logger.debug("param ::::: {}", param);

		Map userInfo = UserUtil.getUserInfo(request);
		param.put("regUid", userInfo.get("user_id"));
		param.put("siteId", param.get("selectSiteId"));
		param.put("userIdx", 1);

		int resultCnt = deviceGroupService.insertDeviceGroup(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	/**
	 * 장치그룹 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateDeviceGroup")
	public @ResponseBody Map<String, Object> updateDeviceGroup(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/saveDvGrp");
		logger.debug("param ::::: {}", param);

		Map userInfo = UserUtil.getUserInfo(request);
		param.put("modUid", userInfo.get("user_id"));
		param.put("deviceGrpIdx", param.get("deviceGrpIdx2"));

		int resultCnt = deviceGroupService.updateDeviceGroup(param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	/**
	 * 장치그룹 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteDeviceGroup")
	public @ResponseBody Map<String, Object> deleteDeviceGroup(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/saveDvGrp");
		logger.debug("param ::::: {}", param);

		Map userInfo = UserUtil.getUserInfo(request);

		HashMap<String, Object> dvGrpMap = new HashMap<String, Object>();
		dvGrpMap.put("deviceGrpIdx", param.get("deviceGrpIdx"));
		List<HashMap<String, Object>> dvList = deviceGroupService.getDvInDeviceGroupList(dvGrpMap);
		int delDvCnt = 0;
		if(dvList.size() > 0) {
			for (HashMap<String, Object> dvMap : dvList) {
				HashMap<String, Object> param2 = new HashMap<String, Object>();
				param2.put("deviceId", dvMap.get("device_id"));
				param2.put("siteId", dvMap.get("site_id"));
				param2.put("deviceType", dvMap.get("device_type"));
				param2.put("deviceGrpIdx", 0);
				param2.put("modUid", userInfo.get("user_id"));
				int cnt = deviceGroupService.updateDevice(param2);
				delDvCnt = delDvCnt+cnt;
			}
		}

		int resultCnt = 0;
		if(delDvCnt == dvList.size()) {
			param.put("modUid", userInfo.get("user_id"));
			resultCnt = deviceGroupService.deleteDeviceGroup(dvGrpMap);
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}
	
	/**
	 * 장치 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertDevice")
	public @ResponseBody Map<String, Object> insertDevice(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/insertDevice");
		logger.debug("param ::::: {}", param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = deviceGroupService.getDeviceChk(param);
		if(cnt > 0) {
			resultMap.put("resultCode", 1);
			resultMap.put("resultMsg", "입력하신 장치가 이미 존재합니다. \n다시 입력해주세요.");
			return resultMap;
		}
		
		Map userInfo = UserUtil.getUserInfo(request);
		param.put("regUid", userInfo.get("user_id"));
		param.put("userIdx", userInfo.get("user_idx"));
		
		if("1".equals(param.get("deviceType")) || "2".equals(param.get("deviceType")) || "3".equals(param.get("deviceType"))) {
			param.put("instType", 2); // localEMS
		} else {
			param.put("instType", 1); // enertalk
		}
		
		int resultCnt = deviceGroupService.insertDevice(param);
		
		resultMap.put("resultCnt", resultCnt);
		resultMap.put("resultMsg", "");
		resultMap.put("resultCode", 0);
		return resultMap;
	}
	
	/**
	 * 장치 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteDevices")
	public @ResponseBody Map<String, Object> deleteDevices(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/deleteDevices");
		logger.debug("param ::::: {}", param);
		Map userInfo = UserUtil.getUserInfo(request);
		
		String delDevices = (String) param.get("delDevices"); // 기존 그룹내 장치목록
		String delDevices_arr[] = null; // 기존 그룹내 장치목록
		if(delDevices != null && !"".equals(delDevices)) {
			delDevices_arr = delDevices.split(",");
		}
		
		int delCnt = 0;
		if(delDevices_arr.length > 0) { // 기존장치목록의 데이터를 변동된장치목록에 존재하는지 확인
			for (int i = 0; i < delDevices_arr.length; i++) {
				String str = delDevices_arr[i];
				String delDv[] = str.split("\\|");
				HashMap dvMap = new HashMap<String, Object>();
				dvMap.put("siteId", delDv[0]);
				dvMap.put("deviceId", delDv[1]);
				dvMap.put("deviceType", delDv[2]);
				dvMap.put("modUid", userInfo.get("user_id"));
				int cnt = deviceGroupService.deleteDevice(dvMap);
				delCnt = delCnt + cnt;
			}
		}
		
		int resultCnt = (delCnt == delDevices_arr.length) ? delCnt : 0;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCnt", resultCnt);
		return resultMap;
	}

	/**
	 * 사이트 목록(팝업) 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getDeviceGrpSitePopupList")
	public @ResponseBody Map<String, Object> getDeviceGrpSitePopupList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceGrpSitePopupList");
		logger.debug("param ::::: {}", param);

		Map userInfo = UserUtil.getUserInfo(request);
		String authType = (String)userInfo.get("auth_type");
		if("1".equals(authType)) { // 포털관리자
			param.put("siteId", request.getSession().getAttribute("selViewSiteId"));
		} else if("2".equals(authType)) { // 고객사관리자
			param.put("compIdx", userInfo.get("comp_idx"));
		} else if("3".equals(authType)) { // 그룹관리자
			param.put("siteGrpIdx", userInfo.get("site_grp_idx"));
		} else if("4".equals(authType) || ("5".equals(authType))) { // 사이트관리자 || 사이트이용자
			param.put("siteId", userInfo.get("site_id"));
		}
		
		List grpSiteList = cmpyGrpSiteMngService.getGrpSiteList(param);
		List allSiteList = cmpyGrpSiteMngService.getAllSiteList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("grpSiteList", grpSiteList);
		resultMap.put("allSiteList", allSiteList);
		return resultMap;
	}
	

}
