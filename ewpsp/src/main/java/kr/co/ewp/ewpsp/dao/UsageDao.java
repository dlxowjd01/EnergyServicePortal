package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("usageDao")
public class UsageDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getUsageRealList(HashMap param) {
		List resultList = sqlSession.selectList("usage.getUsageRealList", param);
		if(resultList != null) {
			System.out.println("        "+resultList.size()+", "+resultList.toString());
		}
		return resultList;
	}

	public List getUsageFutureList(HashMap param) {
		List resultList = sqlSession.selectList("usage.getUsageFutureList", param);
		return resultList;
	}

}
