package kr.co.esp.alarm.service;

import java.util.List;
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
public interface AlarmService {

	Map<String, Object> getDeviceAlarmCnt(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getAlarmList(Map<String, Object> param) throws Exception;

	int getAlarmListCnt(Map<String, Object> param) throws Exception;

	int updateAlarm(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getSmsAddresseeList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getInsertAddresseeNameList(Map<String, Object> param) throws Exception;

	int insertAddressee(Map<String, Object> param) throws Exception;

	int deleteAddressee(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getGMainDeviceAlarmCnt(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getGMainAlarmCnt(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> getSmsUserList(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getSiteMainAlarmCnt(Map<String, Object> param) throws Exception;

	public int addAlarm(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getMainAlarmList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGMainAlarmList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getMainAlarmTypeCntList(Map<String, Object> param) throws Exception;
	
}
