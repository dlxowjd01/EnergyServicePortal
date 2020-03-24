package kr.co.esp.device.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("deviceGroupMapper")
public interface DeviceGroupMapper {

	List<Map<String, Object>> getDeviceGroupList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDvInDeviceGroupList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDeviceGrpAlarmList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getAllDvInSiteList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDeviceNotInGroupList(Map<String, Object> param) throws Exception;

	int deleteDeviceGroup(Map<String, Object> param) throws Exception;

	int insertDeviceGroup(Map<String, Object> param) throws Exception;

	int updateDeviceGroup(Map<String, Object> param) throws Exception;

	int getDeviceChk(Map<String, Object> param) throws Exception;

	int insertDevice(Map<String, Object> param) throws Exception;

	int updateDevice(Map<String, Object> param) throws Exception;

	int deleteDevice(Map<String, Object> param) throws Exception;
	
}
