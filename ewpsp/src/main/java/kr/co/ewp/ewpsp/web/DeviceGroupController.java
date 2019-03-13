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
	public @ResponseBody Map<String, Object> getDeviceGroupList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceGroupList");
		logger.debug("param ::::: "+param.toString());
		
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
	public @ResponseBody Map<String, Object> getDvInDeviceGroupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDvInDeviceGroupList");
		logger.debug("param ::::: "+param.toString());
		
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
	public @ResponseBody Map<String, Object> getDeviceGrpAlarmList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceGrpAlarmList");
		logger.debug("param ::::: "+param.toString());
		
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
	public @ResponseBody Map<String, Object> getDvInDeviceGroupPopupList(@RequestParam HashMap param) throws Exception {
		logger.debug("/getDvInDeviceGroupPopupList");
		logger.debug("param ::::: "+param.toString());
		
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
	public @ResponseBody Map<String, Object> getDeviceNotInGroupList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceNotInGroupList");
		logger.debug("param ::::: "+param.toString());
		
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
	public @ResponseBody Map<String, Object> saveDvInDvGrp(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/saveDvInDvGrp");
		logger.debug("param ::::: "+param.toString());
		
		Map userInfo = UserUtil.getUserInfo(request);
		String siteId = (String) request.getSession().getAttribute("selViewSiteId");
		String selDvGrpIdx = (String) param.get("selDvGrpIdx"); // 추가할 그룹id
		String nowDeviceIds = (String) param.get("nowDeviceIds"); // 기존 그룹내 장치목록 id|type,id|type,id|type,...
		String newDeviceIds = (String) param.get("newDeviceIds"); // 변경할 그룹내 장치목록
		System.out.println("nowDeviceIds   "+nowDeviceIds);
		System.out.println("newDeviceIds   "+newDeviceIds);
		String nowDeviceIds_id[] = null; // 기존 그룹내 장치목록
		String nowDeviceIds_type[] = null; // 기존 그룹내 장치목록
		String newDeviceIds_id[] = null; // 변경할 그룹내 장치목록 
		String newDeviceIds_type[] = null; // 변경할 그룹내 장치목록 
		if(nowDeviceIds != null && !"".equals(nowDeviceIds)) {
			String nowDvIds_ids[] = nowDeviceIds.split(","); // [id|type, id|type, id|type, ...]
			System.out.println("                                     nowDvIds_ids    "+Arrays.toString(nowDvIds_ids));
			nowDeviceIds_id = new String[nowDvIds_ids.length];
			nowDeviceIds_type = new String[nowDvIds_ids.length];
			for(int i=0; i<nowDvIds_ids.length; i++) {
				String dvIds[] = nowDvIds_ids[i].split("\\|"); // [id, type]
				System.out.println("                                                           now     dvIds       "+Arrays.toString(dvIds));
				nowDeviceIds_id[i] = dvIds[0];
				nowDeviceIds_type[i] = dvIds[1];
			}
			System.out.println("                                                                                               nowDeviceIds_id     "+Arrays.toString(nowDeviceIds_id));
			System.out.println("                                                                                               nowDeviceIds_type     "+Arrays.toString(nowDeviceIds_type));
		}
		if(newDeviceIds != null && !"".equals(newDeviceIds)) {
			String newDvIds_ids[] = newDeviceIds.split(","); // [id|type, id|type, id|type, ...]
			System.out.println("                                     newDvIds_ids    "+Arrays.toString(newDvIds_ids));
			newDeviceIds_id = new String[newDvIds_ids.length];
			newDeviceIds_type = new String[newDvIds_ids.length];
			for(int i=0; i<newDvIds_ids.length; i++) {
				String dvIds[] = newDvIds_ids[i].split("\\|"); // [id, type]
				System.out.println("                                                          new      dvIds       "+Arrays.toString(dvIds));
				newDeviceIds_id[i] = dvIds[0];
				newDeviceIds_type[i] = dvIds[1];
			}
			System.out.println("                                                                                               newDeviceIds_id     "+Arrays.toString(newDeviceIds_id));
			System.out.println("                                                                                               newDeviceIds_type     "+Arrays.toString(newDeviceIds_type));
		}
		
		// 기존목록과 변경목록이 동일한지 확인 -> 동일하면 변경사항 없음
		String changeYn = "Y";
		changeYn = ( Arrays.equals(nowDeviceIds_id, newDeviceIds_id) ) ? "N" : "Y"; 
		
		if("Y".equals(changeYn)) {
			// 로직 : 기존장치목록과 변경된장치목록을 비교한다.
			// 기존장치에 존재하고 변경된 장치목록에 미존재 : 그룹에저 제외됨
			// 기존장치에도 존재하고 변경된 장치목록에도 존재 : 변동없음
			// 기존장치에 미존재하고 변경된 장치목록에 존재 : 그룹에 새로 추가됨
			// 기존장치목록이 있는데 변경된 장치목록이 null일 경우 : 그룹에서 전부 제외됨
			// 기존장치목록이 null인데 변경된 장치목록이 존재 : 빈 그룹에 새로 추가됨
			int addCnt = 0;
			int delCnt = 0;
			if(nowDeviceIds_id != null) {
				if(nowDeviceIds_id.length > 0) { // 기존장치목록의 데이터가 변동된장치목록에 존재하는지 확인
					System.out.println("1번의경우");
					for (int i = 0; i < nowDeviceIds_id.length; i++) {
						String str = nowDeviceIds_id[i];
						boolean res = false;
						if(newDeviceIds_id != null) res = Arrays.asList(newDeviceIds_id).contains(str);
						if(!res) { // 기존장치에 존재하고 변경된 장치목록에 미존재 : 그룹에서 제외됨
							HashMap<String, Object> dvMap = new HashMap<String, Object>();
							dvMap.put("deviceId", str);
							dvMap.put("deviceType", nowDeviceIds_type[i]);
							dvMap.put("deviceGrpIdx", 0);
							dvMap.put("modUid", userInfo.get("user_id"));
							dvMap.put("siteId", siteId);
							System.out.println("1번.."+dvMap);
							int cnt = deviceGroupService.updateDevice(dvMap);
							delCnt = delCnt + cnt;
						}
					}
				}
				
			} else {
				System.out.println("2번의경우");
				for (int i = 0; i < newDeviceIds_id.length; i++) {
					HashMap<String, Object> dvMap = new HashMap<String, Object>();
					dvMap.put("deviceId", newDeviceIds_id[i]);
					dvMap.put("deviceType", newDeviceIds_type[i]);
					dvMap.put("deviceGrpIdx", selDvGrpIdx);
					dvMap.put("modUid", userInfo.get("user_id"));
					dvMap.put("siteId", siteId);
					System.out.println("2번.."+dvMap);
					int cnt = deviceGroupService.updateDevice(dvMap);
					addCnt = addCnt + cnt;
				}
			}
			
			if(newDeviceIds_id != null) {
				if(newDeviceIds_id.length > 0) { // 변동된장치목록의 데이터가 기존장치목록에 존재하는지 확인
					System.out.println("3번의경우");
					for (int i = 0; i < newDeviceIds_id.length; i++) {
						String str = newDeviceIds_id[i];
						boolean res = false;
						if(nowDeviceIds_id != null) res = Arrays.asList(nowDeviceIds_id).contains(str);
						if(!res) { // 기존장치에 미존재하고 변경된 장치목록에 존재 : 그룹에 새로 추가됨
							HashMap<String, Object> dvMap = new HashMap<String, Object>();
							dvMap.put("deviceId", str);
							dvMap.put("deviceType", newDeviceIds_type[i]);
							dvMap.put("deviceGrpIdx", selDvGrpIdx);
							dvMap.put("modUid", userInfo.get("user_id"));
							dvMap.put("siteId", siteId);
							System.out.println("3번.."+dvMap);
							int cnt = deviceGroupService.updateDevice(dvMap);
							addCnt = addCnt + cnt;
						}
					}
				}
			} else {
				System.out.println("4번의경우");
				for (int i = 0; i < nowDeviceIds_id.length; i++) {
					HashMap<String, Object> dvMap = new HashMap<String, Object>();
					dvMap.put("deviceId", nowDeviceIds_id[i]);
					dvMap.put("deviceType", nowDeviceIds_type[i]);
					dvMap.put("deviceGrpIdx", 0);
					dvMap.put("modUid", userInfo.get("user_id"));
					dvMap.put("siteId", siteId);
					System.out.println("4번.."+dvMap);
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
	 * 사이트 내 장치그룹 추가/제거
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveDvGrp")
	public @ResponseBody Map<String, Object> saveDvGrp(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/saveDvGrp");
		logger.debug("param ::::: "+param.toString());

		Map userInfo = UserUtil.getUserInfo(request);
		String selectSiteId = (String) param.get("selectSiteId"); // 추가할 그룹id
		String nowDvGrpIds = (String) param.get("nowDvGrpIds"); // 기존 사이트내 장치그룹목록
		String newDvGrpIds = (String) param.get("newDvGrpIds"); // 변경할 사이트내 장치그룹목록
		String newDvGrpNms = (String) param.get("newDvGrpNms"); // 새로 추가될 사이트내 장치그룹목록
		String nowDvGrpIds_arr[] = null; // 기존 그룹내 장치목록
		String newDvGrpIds_arr[] = null; // 변경할 그룹내 장치목록 
		String newDvGrpNms_arr[] = null; // 새로 추가될 사이트내 장치그룹목록 
		if(nowDvGrpIds != null && !"".equals(nowDvGrpIds)) {
			nowDvGrpIds_arr = nowDvGrpIds.split(",");
		}
		if(newDvGrpIds != null && !"".equals(newDvGrpIds)) {
			newDvGrpIds_arr = newDvGrpIds.split(",");
		}
		if(newDvGrpNms != null && !"".equals(newDvGrpNms)) {
			newDvGrpNms_arr = newDvGrpNms.split(",");
		}
		
		// 기존목록과 변경목록이 동일한지 확인 -> 동일하면 변경사항 없음(삭제된그룹이 없음, 추가와는 별개)
		String changeYn = "Y";
		changeYn = ( Arrays.equals(nowDvGrpIds_arr, newDvGrpIds_arr) ) ? "N" : "Y"; 
		
		if("Y".equals(changeYn)) {
			// 로직 : 기존장치목록과 변경된장치목록을 비교한다.
			// 기존에 존재하고 변경된 목록에 미존재 : 그룹에저 제외됨
			// 기존에도 존재하고 변경된 목록에도 존재 : 변동없음
			int delCnt = 0;
			if(nowDvGrpIds_arr != null) {
				if(nowDvGrpIds_arr.length > 0) { // 기존장치목록의 데이터를 변동된장치목록에 존재하는지 확인
					for (int i = 0; i < nowDvGrpIds_arr.length; i++) {
						String str = nowDvGrpIds_arr[i];
						boolean res = false;
						if(newDvGrpIds_arr != null) res = Arrays.asList(newDvGrpIds_arr).contains(str);
						if(!res) { // 기존장치에 존재하고 변경된 장치목록에 미존재 : 그룹에서 제외됨
							HashMap dvMap = new HashMap<String, Object>();
							dvMap.put("deviceGrpIdx", str);
//							dvMap.put("deviceGrpIdx", 0);
							param.put("modUid", userInfo.get("user_id"));
							int cnt = deviceGroupService.deleteDeviceGroup(dvMap);
							delCnt = delCnt + cnt;
						}
					}
				}
				
			}
			
		}
		
		// 신규그룹 추가
		int addCnt = 0;
		if(newDvGrpNms_arr != null) {
			for (int i = 0; i < newDvGrpNms_arr.length; i++) {
				HashMap dvMap = new HashMap<String, Object>();
				dvMap.put("deviceGrpName", newDvGrpNms_arr[i]);
				dvMap.put("siteId", selectSiteId);
				dvMap.put("userIdx", 1);
				dvMap.put("regUid", userInfo.get("user_id"));
				int cnt = deviceGroupService.insertDeviceGroup(dvMap);
				addCnt = addCnt + cnt;
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
	public @ResponseBody Map<String, Object> insertDevice(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/insertDevice");
		logger.debug("param ::::: "+param.toString());
		
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
	public @ResponseBody Map<String, Object> deleteDevices(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/deleteDevices");
		logger.debug("param ::::: "+param.toString());
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
	public @ResponseBody Map<String, Object> getDeviceGrpSitePopupList(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getDeviceGrpSitePopupList");
		logger.debug("param ::::: "+param.toString());

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
//		} else if("5".equals(authType)) { // 사이트이용자
//			param.put("userIdx", userInfo.get("user_idx"));
		}
		
		List grpSiteList = cmpyGrpSiteMngService.getGrpSiteList(param);
		List allSiteList = cmpyGrpSiteMngService.getAllSiteList(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("grpSiteList", grpSiteList);
		resultMap.put("allSiteList", allSiteList);
		return resultMap;
	}
	

}
