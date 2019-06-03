package kr.co.ewp.ewpsp.service;

import java.util.List;
import java.util.Map;

public interface DeviceGroupService {

	List getDeviceGroupList(Map<String, Object> param) throws Exception;
	
	List getDvInDeviceGroupList(Map<String, Object> param) throws Exception;
	
	List getDeviceGrpAlarmList(Map<String, Object> param) throws Exception;
	
	List getAllDvInSiteList(Map<String, Object> param) throws Exception;
	
	List getDeviceNotInGroupList(Map<String, Object> param) throws Exception;

	int deleteDeviceGroup(Map<String, Object> param) throws Exception;
	
	int insertDeviceGroup(Map<String, Object> param) throws Exception;

	int updateDeviceGroup(Map<String, Object> param) throws Exception;

	int getDeviceChk(Map<String, Object> param) throws Exception;
	
	int insertDevice(Map<String, Object> param) throws Exception;
	
	int updateDevice(Map<String, Object> param) throws Exception;
	
	int deleteDevice(Map<String, Object> param) throws Exception;

}
