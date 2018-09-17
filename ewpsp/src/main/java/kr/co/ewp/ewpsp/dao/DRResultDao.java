package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("drResultDao")
public class DRResultDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getDRResultList(HashMap param) {
		List resultList = sqlSession.selectList("drResult.getDRResultList", param);
		return resultList;
	}

}
