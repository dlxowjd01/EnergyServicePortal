package kr.co.esp.sms.service;

import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * @Class Name : CmmLoginService.java
 * @Description : CmmLoginService
 * @Modification Information
 * @
 * @  수정일			수정자					 수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23	MINHA		  최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service
public interface SmsService {

	void sendAlarmMessage(String siteId, String deviceId, String deviceName, String alarmTime, String alarmType, String alarmMsg) throws Exception;

	int sendAuthCodeMessage(Map<String, Object> param) throws Exception;

	int sendFindPassMessage(Map<String, Object> param) throws Exception;
	
}
