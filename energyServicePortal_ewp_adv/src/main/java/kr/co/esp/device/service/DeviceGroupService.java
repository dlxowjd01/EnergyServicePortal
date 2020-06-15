package kr.co.esp.device.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * @Class Name : CmmLoginService.java
 * @Description : CmmLoginService
 * @Modification Information
 * @
 * @  수정일            수정자                     수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23    MINHA          최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service
public interface DeviceGroupService {

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
