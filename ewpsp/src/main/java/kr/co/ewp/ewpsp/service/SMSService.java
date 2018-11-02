package kr.co.ewp.ewpsp.service;

public interface SMSService {

	void sendAlarmMessage(String siteId, String deviceId, String deviceName, String alarmTime, String alarmType, String alarmMsg) throws Exception;
}
