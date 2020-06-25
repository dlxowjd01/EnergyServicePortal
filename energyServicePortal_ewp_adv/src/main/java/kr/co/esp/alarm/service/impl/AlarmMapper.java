package kr.co.esp.alarm.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("alarmMapper")
public interface AlarmMapper {

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

	int insertAlarm(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getMainAlarmList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getGMainAlarmList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getMainAlarmTypeCntList(Map<String, Object> param) throws Exception;
	
}
