package kr.co.ewp.ewpsp.service;

import java.util.HashMap;

public interface SMSService {

    void sendAlarmMessage(String siteId, String deviceId, String deviceName, String alarmTime, String alarmType, String alarmMsg) throws Exception;

    int sendAuthCodeMessage(HashMap param) throws Exception;

    int sendFindPassMessage(HashMap param) throws Exception;
}
