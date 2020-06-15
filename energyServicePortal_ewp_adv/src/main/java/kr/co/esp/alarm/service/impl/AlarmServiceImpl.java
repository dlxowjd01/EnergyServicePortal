package kr.co.esp.alarm.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.alarm.service.AlarmService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
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
@Service("alarmService")
public class AlarmServiceImpl extends EgovAbstractServiceImpl implements AlarmService {

	@Resource(name="alarmMapper")
	private AlarmMapper alarmMapper;

	@Override
	public Map<String, Object> getDeviceAlarmCnt(Map<String, Object> param) throws Exception {
		return alarmMapper.getDeviceAlarmCnt(param);
	}

	@Override
	public List<Map<String, Object>> getAlarmList(Map<String, Object> param) throws Exception {
		return alarmMapper.getAlarmList(param);
	}

	@Override
	public int getAlarmListCnt(Map<String, Object> param) throws Exception {
		return alarmMapper.getAlarmListCnt(param);
	}

	@Override
	public int updateAlarm(Map<String, Object> param) throws Exception {
		return alarmMapper.updateAlarm(param);
	}

	@Override
	public List<Map<String, Object>> getSmsAddresseeList(Map<String, Object> param) throws Exception {
		return alarmMapper.getSmsAddresseeList(param);
	}

	@Override
	public List<Map<String, Object>> getInsertAddresseeNameList(Map<String, Object> param) throws Exception {
		return alarmMapper.getInsertAddresseeNameList(param);
	}

	@Override
	public int insertAddressee(Map<String, Object> param) throws Exception {
		return alarmMapper.insertAddressee(param);
	}

	@Override
	public int deleteAddressee(Map<String, Object> param) throws Exception {
		return alarmMapper.deleteAddressee(param);
	}

	@Override
	public Map<String, Object> getGMainDeviceAlarmCnt(Map<String, Object> param) throws Exception {
		return alarmMapper.getGMainDeviceAlarmCnt(param);
	}

	@Override
	public Map<String, Object> getGMainAlarmCnt(Map<String, Object> param) throws Exception {
		return alarmMapper.getGMainAlarmCnt(param);
	}

	@Override
	public List<Map<String, Object>> getSmsUserList(Map<String, Object> param) throws Exception {
		return alarmMapper.getSmsUserList(param);
	}

	@Override
	public Map<String, Object> getSiteMainAlarmCnt(Map<String, Object> param) throws Exception {
		return alarmMapper.getSiteMainAlarmCnt(param);
	}
	
	@Override
	public int addAlarm(Map<String, Object> param) throws Exception {
		return alarmMapper.insertAlarm(param);
	}

	@Override
	public List<Map<String, Object>> getMainAlarmList(Map<String, Object> param) throws Exception {
		return alarmMapper.getMainAlarmList(param);
	}

	@Override
	public List<Map<String, Object>> getGMainAlarmList(Map<String, Object> param) throws Exception {
		return alarmMapper.getGMainAlarmList(param);
	}

	@Override
	public List<Map<String, Object>> getMainAlarmTypeCntList(Map<String, Object> param) throws Exception {
		return alarmMapper.getMainAlarmTypeCntList(param);
	}
	
}
