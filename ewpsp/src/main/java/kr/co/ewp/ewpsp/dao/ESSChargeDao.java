package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("essChargeDao")
public class ESSChargeDao {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List getESSChargeRealList(HashMap param) {
		List resultList = sqlSession.selectList("essCharge.getESSChargeRealList", param);
		return resultList;
	}

	public List getESSChargeFutureList(HashMap param) {
		List resultList = sqlSession.selectList("essCharge.getESSChargeFutureList", param);
		return resultList;
	}

}
