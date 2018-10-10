package kr.co.ewp.ewpsp.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.net.URLCodec;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.inject.internal.util.Maps;

import kr.co.ewp.ewpsp.common.util.AES256Util;
import kr.co.ewp.ewpsp.common.util.CommonUtils;
import kr.co.ewp.ewpsp.common.util.PMGrowApiUtil;
import kr.co.ewp.ewpsp.common.util.UserUtil;
import kr.co.ewp.ewpsp.model.Soc;
import kr.co.ewp.ewpsp.service.AlarmService;
import kr.co.ewp.ewpsp.service.CmpyGrpSiteMngService;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;
import kr.co.ewp.ewpsp.service.LoginService;

@Controller
public class ApiController {

	private static final Logger logger = LoggerFactory.getLogger(ApiController.class);
	
  @Autowired
  private AlarmService alarmService;
  @Autowired
  private DeviceMonitoringService deviceMonitoringService;

	@Resource(name="cmpyGrpSiteMngService")
	private CmpyGrpSiteMngService cmpyGrpSiteMngService;

	@Resource(name="loginService")
	private LoginService loginService;

  @RequestMapping(value = { "/openapi/alarm" }, method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
  public void getPrototype(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, //
      @RequestParam String deviceId, // 장치ID
      @RequestParam String deviceType, // 장치구분(1:PCS,2:BMS,3:PV,4:부하측정기기,5:PV모니터링기기,6:ESS모니터링기기)
      @RequestParam String alarmTime, // 알람발생일시(형식:YYYYMMDDhhmmss) -> 기준일시에 저장
      @RequestParam String alarmType, // 알람구분(1:비상,2:주의)
      @RequestParam(defaultValue = "") String alarmMsg // 알람메시지 (파라메터는 필수이고 값은 있는 경우에만 세팅)
  ) {
    try {
      Map<String, String> device = deviceMonitoringService.getDevice(deviceId);
      String siteId = device == null ? "" : device.get("site_id");

      Map<String, Object> parameter = Maps.newHashMap();
      parameter.put("siteId", siteId);
      parameter.put("deviceId", deviceId);
      parameter.put("deviceType", deviceType);
      parameter.put("stdDate", alarmTime);
      parameter.put("alarmType", alarmType);
      parameter.put("alarmMsg", alarmMsg);
      parameter.put("alarmCfmYn", "N");
      parameter.put("alarmCfmDate", null);
      parameter.put("alarmCfmUid", "");
      parameter.put("alarmNote", "");
      alarmService.addAlarm(parameter);
      response.setContentType("text/html; charset=UTF-8");
      response.getWriter().print("0");
    } catch (Exception e) {
      e.printStackTrace();
      response.setContentType("text/html; charset=UTF-8");
      try {
        response.getWriter().print("-1");
      } catch (IOException e1) {
        e1.printStackTrace();
      }
    }
  }

	@RequestMapping("/getSoc")
	public @ResponseBody Map<String, Object> getSoc(@RequestParam HashMap param) throws Exception {
		logger.debug("/getSoc");
		logger.debug("param ::::: "+param.toString());

		Map result = cmpyGrpSiteMngService.getSiteDetail(param);
		String host = (String) result.get("local_ems_addr");
		int totalSoc = 0;
		int socCnt = 0;

		List deviceList = deviceMonitoringService.getDeviceList(param);
		if(deviceList != null && deviceList.size() > 0) {
			for (int i = 0; i < deviceList.size(); i++) {
				Map<String, Object> devices = new HashMap<String, Object>();
				devices = (Map<String, Object>) deviceList.get(i);
				String deviceId = (String) devices.get("device_id");
//				String deviceId = "a8324a51"; // (String) devices.get("device_id");
				
//				Random rd = new Random();
//				int soc = rd.nextInt(101); // 0~100 사이의 정수랜덤값을 추출한다.(테스트용)
				Soc resSoc = PMGrowApiUtil.getSoc(host, deviceId);
				if(resSoc != null) {
					int soc = Integer.parseInt(resSoc.getSoc());
					totalSoc = totalSoc+soc;
					socCnt = socCnt+1;
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

	@RequestMapping("/openapi/loginUser")
	public @ResponseBody Integer loginUser(HttpSession session, String userId, String userPw) throws Exception {
		logger.debug("/openapi/loginUser");
		logger.debug("userId : {}, userPw : {}", userId, userPw);

		String key = "aes256-ewpsp-key";
		AES256Util aes256 = new AES256Util(key);
		URLCodec codec = new URLCodec();

//		String userPwEnc = codec.encode(aes256.aesEncode(userPw));
		String userPwDec = aes256.aesDecode(codec.decode(userPw));

		HashMap<String, String> param = new HashMap<String, String>();
		param.put("userId", userId);
		param.put("userPw", userPwDec);

		Map result = loginService.getUserDetail(param);
		logger.debug("result : {}", result);

		if (result != null && CommonUtils.isNotEmpty(result.get("user_idx"))) {
			session.setAttribute(UserUtil.USER_SESSION_ID, result);

			Integer userIdx = (Integer)result.get("user_idx");
			return userIdx;
		} else {
			return -1;
		}
	}
}
