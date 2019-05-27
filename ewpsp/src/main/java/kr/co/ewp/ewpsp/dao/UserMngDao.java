package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("userMngDao")
public class UserMngDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public List getUserList(Map<String, Object> param) {
		List resultList = sqlSession.selectList("userMng.getUserList", param);
		return resultList;
	}

	public int getUserListCnt(Map<String, Object> param) {
		return sqlSession.selectOne("userMng.getUserListCnt", param);
	}

	public Map getUserDetail(Map<String, Object> param) {
		Map result = sqlSession.selectOne("userMng.getUserDetail", param);
		return result;
	}

	public Map getLastUserDetail(Map<String, Object> param) {
		Map result = sqlSession.selectOne("userMng.getLastUserDetail", param);
		return result;
	}

	public int insertUser(Map<String, Object> param) {
		return sqlSession.update("userMng.insertUser", param);
	}

	public int updateUser(Map<String, Object> param) {
		return sqlSession.update("userMng.updateUser", param);
	}
	
	public int deleteUser(Map<String, Object> param) {
		return sqlSession.update("userMng.deleteUser", param);
	}

	public int updateUserAuth(Map<String, Object> param) {
		return sqlSession.update("userMng.updateUserAuth", param);
	}
	
}
