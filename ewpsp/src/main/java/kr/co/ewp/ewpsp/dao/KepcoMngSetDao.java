package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("kepcoMngSetDao")
public class KepcoMngSetDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public Map getSiteSetDetail(HashMap param) {
		Map result = sqlSession.selectOne("kepcoMngSet.getSiteSetDetail", param);
		return result;
	}
	
	public Map getPlanTypeVal(HashMap param) {
		Map result = sqlSession.selectOne("kepcoMngSet.getPlanTypeVal", param);
		return result;
	}
	

	public List getPlanType(HashMap param) {
		List resultList = sqlSession.selectList("kepcoMngSet.getPlanType", param);
		return resultList;
	}
	
	public int insertSiteSet(HashMap param) {
		int result = sqlSession.update("kepcoMngSet.insertSiteSet", param);
		return result;
	}
	
	public int updateSiteSet(HashMap param) {
		int result = sqlSession.update("kepcoMngSet.updateSiteSet", param);
		return result;
	}
	
}
