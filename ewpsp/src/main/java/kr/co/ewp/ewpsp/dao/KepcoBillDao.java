package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("kepcoBillDao")
public class KepcoBillDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getKepcoBillList(HashMap param) {
		List resultList = sqlSession.selectList("kepcoBill.getKepcoBillList", param);
		return resultList;
	}
	
	public List getKepcoTexBillList(HashMap param) {
		List resultList = sqlSession.selectList("kepcoBill.getKepcoTexBillList", param);
		return resultList;
	}
	
	public List getKepcoResentBillList(HashMap param) {
		List resultList = sqlSession.selectList("kepcoBill.getKepcoResentBillList", param);
		return resultList;
	}

}
