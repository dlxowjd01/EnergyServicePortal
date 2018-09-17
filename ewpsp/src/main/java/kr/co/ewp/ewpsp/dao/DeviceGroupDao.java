package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("deviceGroupDao")
public class DeviceGroupDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public List getDeviceIOEList(HashMap param) {
		List resultList = sqlSession.selectList("deviceGroup.getDeviceIOEList", param);
		return resultList;
	}

	public Map getDeviceIOEDetail(HashMap param) {
		Map result = sqlSession.selectOne("deviceGroup.getDeviceIOEDetail", param);
		return result;
	}
	
	public List getDevicePCSList(HashMap param) {
		List resultList = sqlSession.selectList("deviceGroup.getDevicePCSList", param);
		return resultList;
	}
	
	public List getDeviceBMSList(HashMap param) {
		List resultList = sqlSession.selectList("deviceGroup.getDeviceBMSList", param);
		return resultList;
	}
	
	public List getDevicePVList(HashMap param) {
		List resultList = sqlSession.selectList("deviceGroup.getDevicePVList", param);
		return resultList;
	}

	public List getDeviceList(HashMap param) {
		List resultList = sqlSession.selectList("deviceGroup.getDeviceList", param);
		return resultList;
	}
	
}
