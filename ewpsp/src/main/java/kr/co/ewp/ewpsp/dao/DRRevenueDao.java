package kr.co.ewp.ewpsp.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("drRevenueDao")
public class DRRevenueDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getUsageRealList() {
		List resultList = sqlSession.selectList("drRevenue.getUsageRealList");
		return resultList;
	}

	public List getUsageFutureList() {
		List resultList = sqlSession.selectList("drRevenue.getUsageFutureList");
		return resultList;
	}

}
