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
public interface DeviceMonitoringService {

	List<Map<String, Object>> getDeviceIOEList(Map<String, Object> param) throws Exception;

	int getDeviceIOEListCnt(Map<String, Object> param) throws Exception;

	Map<String, Object> getDeviceIOEDetail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDevicePCSList(Map<String, Object> param) throws Exception;

	int getDevicePCSListCnt(Map<String, Object> param) throws Exception;

	Map<String, Object> getDevicePCSDetail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDeviceBMSList(Map<String, Object> param) throws Exception;

	int getDeviceBMSListCnt(Map<String, Object> param) throws Exception;

	Map<String, Object> getDeviceBMSDetail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDevicePVList(Map<String, Object> param) throws Exception;

	int getDevicePVListCnt(Map<String, Object> param) throws Exception;

	Map<String, Object> getDevicePVDetail(Map<String, Object> param) throws Exception;

//	List<Map<String, Object>> getDeviceList(Map<String, Object> param) throws Exception;

	int getDeviceListCnt(Map<String, Object> param) throws Exception;

	Map<String, String> getDevice(Map<String, Object> dvMap) throws Exception;

	Map<String, Object> getDeviceAMIDetail(Map<String, Object> param) throws Exception;

	//임시영역
	List<Map<String, Object>> getDeviceList(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getDeviceType(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getDataByType(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getGenRealList(Map<String, Object> param) throws Exception;
	String[] genInverterData(Map<String, Object> param) throws Exception;
	String[] getInverterIdList(Map<String, Object> param) throws Exception;
	Map<String, Object> getTodayGenData(Map<String, Object> param) throws Exception;
	
}
