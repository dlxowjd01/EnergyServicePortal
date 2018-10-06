package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.dao.AlarmDao;

@Service
public class AlarmServiceImpl implements AlarmService {
  @Autowired
  private AlarmDao alarmDao;

  @Transactional
  public int addAlarm(Map<String, Object> parameter) throws Exception {
    return alarmDao.insertAlaram(parameter);
  }

	public List getMainAlarmList(HashMap param) throws Exception {
		return alarmDao.getMainAlarmList(param);
	}
	
	public List getGMainAlarmList(HashMap param) throws Exception {
		return alarmDao.getGMainAlarmList(param);
	}

	public List getMainAlarmTypeCntList(HashMap param) throws Exception {
		return alarmDao.getMainAlarmTypeCntList(param);
	}
}
