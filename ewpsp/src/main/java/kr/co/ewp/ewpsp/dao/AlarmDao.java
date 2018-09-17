package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AlarmDao {

  @Autowired
  private SqlSessionTemplate sqlSession;

  public int insertAlaram(Map<String, Object> parameter) {
    return sqlSession.insert("alarm.insertAlarm", parameter);
  }

	public List getAlarmList(HashMap param) {
		List resultList = sqlSession.selectList("alarm.getAlarmList", param);
		return resultList;
	}
	
	public List getAlarmTypeCntList(HashMap param) {
		List resultList = sqlSession.selectList("alarm.getAlarmTypeCntList", param);
		return resultList;
	}

}
