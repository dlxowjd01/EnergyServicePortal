package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AlarmService {
    public int addAlarm(Map<String, Object> parameter) throws Exception;

    List getMainAlarmList(HashMap param) throws Exception;

    List getGMainAlarmList(HashMap param) throws Exception;

    List getMainAlarmTypeCntList(HashMap param) throws Exception;
}
