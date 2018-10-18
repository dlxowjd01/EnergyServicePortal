package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("peakDao")
public class PeakDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getPeakRealList(HashMap param) {
		List resultList = sqlSession.selectList("peak.getPeakRealList", param);
		return resultList;
	}

}
