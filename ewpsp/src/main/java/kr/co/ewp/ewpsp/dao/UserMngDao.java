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

	public List getUserList(HashMap param) {
		List resultList = sqlSession.selectList("userMng.getUserList", param);
		return resultList;
	}

	public int getUserListCnt(HashMap param) {
		return sqlSession.selectOne("userMng.getUserListCnt", param);
	}

	public Map getUserDetail(HashMap param) {
		Map result = sqlSession.selectOne("userMng.getUserDetail", param);
		return result;
	}

	public Map getLastUserDetail(HashMap param) {
		Map result = sqlSession.selectOne("userMng.getLastUserDetail", param);
		return result;
	}

	public int insertUser(HashMap param) {
		return sqlSession.update("userMng.insertUser", param);
	}

	public int updateUser(HashMap param) {
		return sqlSession.update("userMng.updateUser", param);
	}
	
	public int deleteUser(HashMap param) {
		return sqlSession.update("userMng.deleteUser", param);
	}
	
	
}
