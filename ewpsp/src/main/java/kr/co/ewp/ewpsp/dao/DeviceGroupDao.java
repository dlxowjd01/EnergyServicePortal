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

	public List getDeviceGroupList(HashMap param) {
		List resultList = sqlSession.selectList("deviceGroup.getDeviceGroupList", param);
		return resultList;
	}
	
	public List getDvInDeviceGroupList(HashMap param) {
		List resultList = sqlSession.selectList("deviceGroup.getDvInDeviceGroupList", param);
		return resultList;
	}

	public int insertDevice(HashMap param) {
		return sqlSession.update("deviceGroup.insertDevice", param);
	}
	
}
