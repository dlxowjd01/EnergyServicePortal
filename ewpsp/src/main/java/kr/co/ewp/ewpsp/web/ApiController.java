package kr.co.ewp.ewpsp.web;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.inject.internal.util.Maps;

import kr.co.ewp.ewpsp.model.BmsEquipmentModelBefore;
import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil.Period;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil.TimeType;
import kr.co.ewp.ewpsp.common.util.EnertalkApiUtil.UsageType;
import kr.co.ewp.ewpsp.common.util.PMGrowApiUtil;
import kr.co.ewp.ewpsp.common.util.PMGrowApiUtilBefore;
import kr.co.ewp.ewpsp.common.util.UserUtil;
import kr.co.ewp.ewpsp.model.BmsEquipmentModel;
import kr.co.ewp.ewpsp.model.DrRequestTarget;
import kr.co.ewp.ewpsp.model.SocModel;
import kr.co.ewp.ewpsp.model.UsageItemModel;
import kr.co.ewp.ewpsp.model.UsageModel;
import kr.co.ewp.ewpsp.model.UsageRealtimeModel;
import kr.co.ewp.ewpsp.service.AlarmService;
import kr.co.ewp.ewpsp.service.CmpyGrpSiteMngService;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;
import kr.co.ewp.ewpsp.service.KepcoMngSetService;
import kr.co.ewp.ewpsp.service.LoginService;
import kr.co.ewp.ewpsp.service.SMSService;

@Controller
public class ApiController {

	private static final Logger logger = LoggerFactory.getLogger(ApiController.class);
	
  @Autowired
  private AlarmService alarmService;
  @Autowired
  private DeviceMonitoringService deviceMonitoringService;

	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;

	@Resource(name="smsService")
	private SMSService smsService;

	@Resource(name="loginService")
	private LoginService loginService;

  @RequestMapping(value = { "/v1/alarm" }, method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE) /*** 12.13 이우람 수정 ***/
  public void getPrototype(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, //
      @RequestParam String siteId, // 사이트ID /*** 12.13 이우람 추가 ***/
      @RequestParam String deviceId, // 장치ID
      @RequestParam Integer deviceType, // 장치구분(1:PCS,2:BMS,3:PV,4:부하측정기기,5:PV모니터링기기,6:ESS모니터링기기,7:iSmart,8:총량기기) /*** 12.13 이우람 수정 ***/
      @RequestParam Long alarmTime, // 알람발생일시(형식:YYYYMMDDhhmmss) -> 기준일시에 저장 /*** 12.13 이우람 수정, 2019.03.13 이우람 수정(Long(timestamp형식으로 변경) ***/
      @RequestParam Integer alarmType, // 알람구분(1:비상,2:주의) /*** 12.13 이우람 수정 ***/
      @RequestParam(defaultValue = "") String alarmMsg, // 알람메시지 (파라메터는 필수이고 값은 있는 경우에만 세팅)
      @RequestParam(required = false, defaultValue = "") String alarmCode // 알람코드
  ) {
    try {
    	Map<String, Object> dvMap = Maps.newHashMap();
    	dvMap.put("siteId", siteId);
        dvMap.put("deviceId", deviceId);
        dvMap.put("deviceType", deviceType);
      Map<String, String> device = deviceMonitoringService.getDevice(dvMap);
//      String siteId = device == null ? "" : device.get("site_id"); /*** 12.13 이우람 수정 ***/

      Map<String, Object> parameter = Maps.newHashMap();
      parameter.put("siteId", siteId);
      parameter.put("deviceId", deviceId);
      parameter.put("deviceType", deviceType); // 1: PCS, 2: BMS, 3: IVT (PV), 4: AMI, 5: AMI Modem, 6: Enertalk
      Timestamp stdDate = new Timestamp(alarmTime);
      parameter.put("stdDate", stdDate); // event time in millisecond
      parameter.put("alarmCode", alarmCode);
      parameter.put("alarmType", alarmType); // 1: emergency, 2: warning
      parameter.put("alarmMsg", alarmMsg); // alarm message
      parameter.put("alarmCfmYn", "N");
      parameter.put("alarmCfmDate", null);
      parameter.put("alarmCfmUid", "");
      parameter.put("alarmActYn", "N");
      parameter.put("alarmNote", "");
      alarmService.addAlarm(parameter);
      response.setContentType("text/html; charset=UTF-8");
      response.getWriter().print("0");
      
      // SMS 전송 (한재종)
      if(device !=null){
    	  String alarmTimeStr = CommonUtils.convertDateFormat(stdDate, "yyyyMMddHHmmss"); /*** 12.13 이우람 추가 ***/
    	  smsService.sendAlarmMessage(siteId, deviceId, device.get("device_name"), alarmTimeStr, Integer.toString(alarmType), alarmMsg); /*** 12.13 이우람 수정 ***/
      }
    } catch (NullPointerException e) {
		logger.error("error is : "+e.toString());
    } catch (Exception e) {
    	logger.error("error is : "+e.toString());
      response.setContentType("text/html; charset=UTF-8");
      try {
        response.getWriter().print("-1");
      } catch (IOException e1) {
    	  logger.error("error is : "+e1.toString());
      }
    }
  }

	@RequestMapping("/getSoc")
	public @ResponseBody Map<String, Object> getSoc(@RequestParam HashMap param, HttpServletRequest request) throws Exception {
		logger.debug("/getSoc");
		logger.debug("param ::::: "+param.toString());

		Map result = cmpyGrpSiteMngService.getSiteDetail(param);
		String host = (String) result.get("local_ems_addr");
		Float totalSoc = (float) 0;
		int socCnt = 0;

		List deviceList = deviceMonitoringService.getDeviceList(param);
		if(deviceList != null && deviceList.size() > 0) {
			for (int i = 0; i < deviceList.size(); i++) {
				Map<String, Object> devices = new HashMap<String, Object>();
				devices = (Map<String, Object>) deviceList.get(i);
				String deviceType = (String) devices.get("device_type");
				if("2".equals(deviceType)) {
					String deviceId = (String) devices.get("device_id");
					String siteId  = (String) devices.get("site_id");
					Map siteDetail = (Map) request.getSession().getAttribute("selViewSite");
					String apiVer = (String) siteDetail.get("local_ems_api_ver");
					if("1.1".equals(apiVer)) { // 기존
						List<BmsEquipmentModelBefore> bmsDetail = PMGrowApiUtilBefore.getBmsEquipmentList(host, deviceId);
						System.out.println("bms 결과 : "+bmsDetail.toString());
						if(bmsDetail != null) {
							for (BmsEquipmentModelBefore bmsEquipmentModel : bmsDetail) {
								Float sysSoc = bmsEquipmentModel.getSysSoc();
								totalSoc = totalSoc+sysSoc;
								socCnt = socCnt+1;
							}
						}
					} else {
						BmsEquipmentModel bmsDetail = PMGrowApiUtil.getBmsEquipmentList(host, deviceId);
						if(bmsDetail != null) {
							Float sysSoc = bmsDetail.getSysSoc();
//							int soc = Integer.parseInt(sysSoc);
							totalSoc = totalSoc+sysSoc;
							socCnt = socCnt+1;
						}
//						SocModel resSoc = PMGrowApiUtil.getSoc(host, deviceId);
//						if(resSoc != null) {
//							int soc = Integer.parseInt(resSoc.getSoc());
//							totalSoc = totalSoc+soc;
//							socCnt = socCnt+1;
//						}
					}
				}
			}
		}
		
		double finalSoc = 0;
		if(socCnt > 0 && totalSoc > 0) {
			finalSoc = Math.round((totalSoc/socCnt)*10)/10.0;
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("finalSoc", finalSoc);
		return resultMap;
	}
	
	@RequestMapping("/getPeak")
	public @ResponseBody Map<String, Object> getPeak(@RequestParam HashMap param) throws Exception {
		logger.debug("/getPeak");
		logger.debug("param ::::: "+param.toString());
		
		Date today = new Date();
		String dfs1 [] = CommonUtils.convertDateFormat(today, "yyyy-MM-dd").split("-");
		String dfs2 [] = CommonUtils.convertDateFormat(today, "HH:mm:ss").split(":");
		
		Date startDate;
		if(Integer.parseInt(dfs2[1]) >= 0 && Integer.parseInt(dfs2[1]) <15) {
			startDate = CommonUtils.getDate(Integer.valueOf(dfs1[0]), Integer.valueOf(dfs1[1]), Integer.valueOf(dfs1[2]), Integer.valueOf(dfs2[0]), 0, 0);
		} else if(Integer.parseInt(dfs2[1]) >= 15 && Integer.parseInt(dfs2[1]) <30) {
			startDate = CommonUtils.getDate(Integer.valueOf(dfs1[0]), Integer.valueOf(dfs1[1]), Integer.valueOf(dfs1[2]), Integer.valueOf(dfs2[0]), 15, 0);
		} else if(Integer.parseInt(dfs2[1]) >= 30 && Integer.parseInt(dfs2[1]) <45) {
			startDate = CommonUtils.getDate(Integer.valueOf(dfs1[0]), Integer.valueOf(dfs1[1]), Integer.valueOf(dfs1[2]), Integer.valueOf(dfs2[0]), 30, 0);
		} else {
			startDate = CommonUtils.getDate(Integer.valueOf(dfs1[0]), Integer.valueOf(dfs1[1]), Integer.valueOf(dfs1[2]), Integer.valueOf(dfs2[0]), 45, 0);
		}
		Date endDate = CommonUtils.getDate(Integer.valueOf(dfs1[0]), Integer.valueOf(dfs1[1]), Integer.valueOf(dfs1[2]), Integer.valueOf(dfs2[0]), Integer.valueOf(dfs2[1]), Integer.valueOf(dfs2[2]));
		logger.debug("피크 검색날짜 ===> "+CommonUtils.convertDateFormat(startDate, "yyyy-MM-dd HH:mm:ss")+", "+CommonUtils.convertDateFormat(endDate, "yyyy-MM-dd HH:mm:ss"));
		
		int totalUsage = 0;
		int usageCnt = 0;
		
		List deviceList = deviceMonitoringService.getDeviceList(param);
		if(deviceList != null && deviceList.size() > 0) {
			for (int i = 0; i < deviceList.size(); i++) {
				Map<String, Object> devices = new HashMap<String, Object>();
				devices = (Map<String, Object>) deviceList.get(i);
				String deviceId = (String) devices.get("device_id");
				
				UsageModel usageModel = EnertalkApiUtil.getUsagePeriodicByDeviceId(deviceId, Period._15min, startDate, endDate, TimeType.past, UsageType.positiveEnergy);
				if(usageModel != null) {
					if(usageModel.getItems() != null) {
						for (UsageItemModel item : usageModel.getItems()) {
							Integer usageVal = item.getUsage().intValue();
							if(usageVal != null) totalUsage = totalUsage+usageVal;
							
						}
					}
					usageCnt = usageCnt+1;
					
				}
			}
		}
		
		Date stdDate = CommonUtils.getDate(Integer.valueOf(dfs1[0]), Integer.valueOf(dfs1[1]), Integer.valueOf(dfs1[2]), Integer.valueOf(dfs2[0]), Integer.valueOf(dfs2[1]), 0);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("stdDate", stdDate);
		resultMap.put("startDate", startDate);
		resultMap.put("totalUsage", totalUsage);
		return resultMap;
	}

	@CrossOrigin("*")
	@RequestMapping("/openapi/loginUser")
	public @ResponseBody Integer loginUser(HttpSession session, String userId, String userPw) throws Exception {
		logger.debug("/openapi/loginUser");
		logger.debug("userId : {}, userPw : {}", userId, userPw);

		HashMap<String, String> param = new HashMap<String, String>();
		param.put("userId", userId);
		param.put("userPw", userPw);

		Map result = loginService.getUserDetailPlain(param);
		logger.debug("result : {}", result);

		if (result != null && CommonUtils.isNotEmpty(result.get("user_idx"))) {
			session.setAttribute(UserUtil.USER_SESSION_ID, result);

			Integer userIdx = (Integer)result.get("user_idx");
			return userIdx;
		} else {
			return -1;
		}
	}

	@CrossOrigin("*")
	@RequestMapping("/openapi/getUser")
	public @ResponseBody Map<String, Object> getUserDetail(String userId, String userPw) throws Exception {
		logger.debug("/openapi/getUser");
		logger.debug("userId : {}, userPw : {}", userId, userPw);

		HashMap<String, String> param = new HashMap<String, String>();
		param.put("userId", userId);
		param.put("userPw", userPw);

		Map result = loginService.getUserDetailPlain(param);
		logger.debug("result : {}", result);

		return result;
	}

	public List<DrRequestTarget> getDrRequest(String siteId, Date start, Date end) {
		List<DrRequestTarget> resultList = EnertalkApiUtil.getDrRequest(siteId, start, end, 0, 50);
		return resultList;
	}
	
	/**
	 * IOE장치 실시간 상세정보
	 * @param deviceId
	 * @return
	 */
	public UsageRealtimeModel getDeviceRealTime(String deviceId) {
		UsageRealtimeModel usageRealtime = EnertalkApiUtil.getDeviceRealTime(deviceId);
		return usageRealtime;
	}
	
}
