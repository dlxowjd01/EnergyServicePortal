package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ControlService {

	Map getDeviceAlarmCnt(HashMap param) throws Exception;
	
	Map getGMainDeviceAlarmCnt(HashMap param) throws Exception;

	List getAlarmList(HashMap param) throws Exception;
	
	int getAlarmListCnt(HashMap param) throws Exception;

	List getSmsAddresseeList(HashMap param) throws Exception;
	
	List getInsertAddresseeNameList(HashMap param) throws Exception;

	int insertAddressee(HashMap param) throws Exception;

	int deleteAddressee(HashMap param) throws Exception;
}
