package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface DeviceMonitoringService {

	List getDeviceIOEList(HashMap param) throws Exception;

	int getDeviceIOEListCnt(HashMap param) throws Exception;

	Map getDeviceIOEDetail(HashMap param) throws Exception;
	
	List getDevicePCSList(HashMap param) throws Exception;

	int getDevicePCSListCnt(HashMap param) throws Exception;

	Map getDevicePCSDetail(HashMap param) throws Exception;
	
	List getDeviceBMSList(HashMap param) throws Exception;

	int getDeviceBMSListCnt(HashMap param) throws Exception;

	Map getDeviceBMSDetail(HashMap param) throws Exception;
	
	List getDevicePVList(HashMap param) throws Exception;
	
	int getDevicePVListCnt(HashMap param) throws Exception;

	Map getDevicePVDetail(HashMap param) throws Exception;

	List getDeviceList(HashMap param) throws Exception;

	int getDeviceListCnt(HashMap param) throws Exception;
	
	Map<String, String> getDevice(Map<String, Object> dvMap) throws Exception;
}
