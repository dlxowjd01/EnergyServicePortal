package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("pvGenDao")
public class PVGenDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getPVGenRealList(HashMap param) {
		List resultList = sqlSession.selectList("pvGenDao.getPVGenRealList", param);
		return resultList;
	}

	public List getPVGenFutureList(HashMap param) {
		List resultList = sqlSession.selectList("pvGenDao.getPVGenFutureList", param);
		return resultList;
	}

}
