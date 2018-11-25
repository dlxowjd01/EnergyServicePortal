package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("essRevenueDao")
public class ESSRevenueDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getESSRevenueList(HashMap param) {
		List resultList = sqlSession.selectList("essRevenue.getESSRevenueList", param);
		return resultList;
	}

	public List getESSRevenueTexList(HashMap param) {
		List resultList = sqlSession.selectList("essRevenue.getESSRevenueTexList", param);
		return resultList;
	}

	public List getESSRevenueDayList(HashMap param) {
		List resultList = sqlSession.selectList("essRevenue.getESSRevenueDayList", param);
		return resultList;
	}
}
