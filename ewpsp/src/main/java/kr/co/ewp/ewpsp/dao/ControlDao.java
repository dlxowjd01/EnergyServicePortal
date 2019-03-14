package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("controlDao")
public class ControlDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public Map getDeviceAlarmCnt(HashMap param) {
		Map result = sqlSession.selectOne("control.getDeviceAlarmCnt", param);
		return result;
	}
	
	public Map getSiteMainAlarmCnt(HashMap param) {
		Map result = sqlSession.selectOne("control.getSiteMainAlarmCnt", param);
		return result;
	}
	
	public Map getGMainDeviceAlarmCnt(HashMap param) {
		Map result = sqlSession.selectOne("control.getGMainDeviceAlarmCnt", param);
		return result;
	}
	
	public Map getGMainAlarmCnt(HashMap param) {
		Map result = sqlSession.selectOne("control.getGMainAlarmCnt", param);
		return result;
	}
	
	public List getAlarmList(HashMap param) {
		List resultList = sqlSession.selectList("control.getAlarmList", param);
		return resultList;
	}
	
	public int getAlarmListCnt(HashMap param) {
		return sqlSession.selectOne("control.getAlarmListCnt", param);
	}

	public int updateAlarm(HashMap param) {
		return sqlSession.insert("control.updateAlarm", param);
	}

	public List getSmsUserList(HashMap param) {
		List resultList = sqlSession.selectList("control.getSmsUserList", param);
		return resultList;
	}

	public List getSmsAddresseeList(HashMap param) {
		List resultList = sqlSession.selectList("control.getSmsAddresseeList", param);
		return resultList;
	}
	
	public List getInsertAddresseeNameList(HashMap param) {
		List resultList = sqlSession.selectList("control.getInsertAddresseeNameList", param);
		return resultList;
	}

	public int insertAddressee(HashMap param) {
		return sqlSession.insert("control.insertAddressee", param);
	}

	public int deleteAddressee(HashMap param) {
		return sqlSession.update("control.deleteAddressee", param);
	}
	
}
