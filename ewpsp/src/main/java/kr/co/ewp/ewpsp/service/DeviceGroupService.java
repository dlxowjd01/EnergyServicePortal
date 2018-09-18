package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface DeviceGroupService {

	List getDeviceGroupList(HashMap param) throws Exception;
	
	List getDvInDeviceGroupList(HashMap param) throws Exception;

	int insertDevice(HashMap param) throws Exception;

}
