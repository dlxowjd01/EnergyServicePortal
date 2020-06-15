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

	public List<HashMap<String, Object>> getDeviceGroupList(Map<String, Object> param) {
		return sqlSession.selectList("deviceGroup.getDeviceGroupList", param);
	}
	
	public List<HashMap<String, Object>> getDvInDeviceGroupList(Map<String, Object> param) {
		return sqlSession.selectList("deviceGroup.getDvInDeviceGroupList", param);
	}
	
	public List<HashMap<String, Object>> getDeviceGrpAlarmList(Map<String, Object> param) {
		return sqlSession.selectList("deviceGroup.getDeviceGrpAlarmList", param);
	}
	
	public List<HashMap<String, Object>> getAllDvInSiteList(Map<String, Object> param) {
		return sqlSession.selectList("deviceGroup.getAllDvInSiteList", param);
	}
	
	public List<HashMap<String, Object>> getDeviceNotInGroupList(Map<String, Object> param) {
		return sqlSession.selectList("deviceGroup.getDeviceNotInGroupList", param);
	}

	public int deleteDeviceGroup(Map<String, Object> param) {
		return sqlSession.delete("deviceGroup.deleteDeviceGroup", param);
	}
	
	public int insertDeviceGroup(Map<String, Object> param) {
		return sqlSession.insert("deviceGroup.insertDeviceGroup", param);
	}

	public int updateDeviceGroup(Map<String, Object> param) {
		return sqlSession.insert("deviceGroup.updateDeviceGroup", param);
	}

	public int getDeviceChk(Map<String, Object> param) {
		return sqlSession.selectOne("deviceGroup.getDeviceChk", param);
	}
	
	public int insertDevice(Map<String, Object> param) {
		return sqlSession.insert("deviceGroup.insertDevice", param);
	}
	
	public int updateDevice(Map<String, Object> param) {
		return sqlSession.update("deviceGroup.updateDevice", param);
	}
	
	public int deleteDevice(Map<String, Object> param) {
		return sqlSession.delete("deviceGroup.deleteDevice", param);
	}
	
}
