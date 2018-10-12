package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("loginDao")
public class LoginDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public Map getUserDetail(HashMap param) {
		Map result = sqlSession.selectOne("login.getUserDetail", param);
		return result;
	}

	public Map findUserId(HashMap param) {
		Map result = sqlSession.selectOne("login.findUserId", param);
		return result;
	}

	public Map findUserPw(HashMap param) {
		Map result = sqlSession.selectOne("login.findUserPw", param);
		return result;
	}

	public Map checkUserId(HashMap param) {
		Map result = sqlSession.selectOne("login.checkUserId", param);
		return result;
	}

	public int insertUser(HashMap param) {
		return sqlSession.update("login.insertUser", param);
	}
}
