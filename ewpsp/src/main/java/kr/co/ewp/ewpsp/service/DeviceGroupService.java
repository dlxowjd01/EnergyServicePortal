package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface DeviceGroupService {

	List getDeviceIOEList(HashMap param) throws Exception;

	Map getDeviceIOEDetail(HashMap param) throws Exception;
	
	List getDevicePCSList(HashMap param) throws Exception;
	
	List getDeviceBMSList(HashMap param) throws Exception;
	
	List getDevicePVList(HashMap param) throws Exception;

	List getDeviceList(HashMap param) throws Exception;

}
