package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AlarmService {
  public int addAlarm(Map<String, Object> parameter) throws Exception;

	List getAlarmList(HashMap param) throws Exception;
	
	List getAlarmTypeCntList(HashMap param) throws Exception;
}
