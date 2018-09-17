package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("pvRevenueDao")
public class PVRevenueDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getPVRevenueList(HashMap param) {
		List resultList = sqlSession.selectList("pvRevenue.getPVRevenueList", param);
		return resultList;
	}

	public List getPVRevenueList_test(HashMap param) {
		List resultList = sqlSession.selectList("pvRevenue.getPVRevenueList_test", param);
		return resultList;
	}

}
