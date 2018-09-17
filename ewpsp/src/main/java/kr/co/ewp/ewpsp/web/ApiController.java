package kr.co.ewp.ewpsp.web;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.inject.internal.util.Maps;

import kr.co.ewp.ewpsp.service.AlarmService;
import kr.co.ewp.ewpsp.service.DeviceMonitoringService;

@Controller
public class ApiController {
  @Autowired
  private AlarmService alarmService;
  @Autowired
  private DeviceMonitoringService deviceMonitoringService;

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
}
