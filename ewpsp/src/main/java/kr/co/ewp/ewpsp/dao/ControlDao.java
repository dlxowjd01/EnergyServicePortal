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
	
	public List getAlarmList(HashMap param) {
		List resultList = sqlSession.selectList("control.getAlarmList", param);
		return resultList;
	}
	
	public int getAlarmListCnt(HashMap param) {
		return sqlSession.selectOne("control.getAlarmListCnt", param);
	}
	
}
