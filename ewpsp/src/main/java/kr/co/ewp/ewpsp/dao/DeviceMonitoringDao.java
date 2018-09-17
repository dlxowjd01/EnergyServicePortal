package kr.co.ewp.ewpsp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("deviceMonitoringDao")
public class DeviceMonitoringDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public List getDeviceIOEList(HashMap param) {
		List resultList = sqlSession.selectList("deviceMonitoring.getDeviceIOEList", param);
		return resultList;
	}

	public int getDeviceIOEListCnt(HashMap param) {
		return sqlSession.selectOne("deviceMonitoring.getDeviceIOEListCnt", param);
	}

	public Map getDeviceIOEDetail(HashMap param) {
		Map result = sqlSession.selectOne("deviceMonitoring.getDeviceIOEDetail", param);
		return result;
	}
	
	public List getDevicePCSList(HashMap param) {
		List resultList = sqlSession.selectList("deviceMonitoring.getDevicePCSList", param);
		return resultList;
	}

	public int getDevicePCSListCnt(HashMap param) {
		return sqlSession.selectOne("deviceMonitoring.getDevicePCSListCnt", param);
	}

	public Map getDevicePCSDetail(HashMap param) {
		Map result = sqlSession.selectOne("deviceMonitoring.getDevicePCSDetail", param);
		return result;
	}
	
	public List getDeviceBMSList(HashMap param) {
		List resultList = sqlSession.selectList("deviceMonitoring.getDeviceBMSList", param);
		return resultList;
	}

	public int getDeviceBMSListCnt(HashMap param) {
		return sqlSession.selectOne("deviceMonitoring.getDeviceBMSListCnt", param);
	}

	public Map getDeviceBMSDetail(HashMap param) {
		Map result = sqlSession.selectOne("deviceMonitoring.getDeviceBMSDetail", param);
		return result;
	}
	
	public List getDevicePVList(HashMap param) {
		List resultList = sqlSession.selectList("deviceMonitoring.getDevicePVList", param);
		return resultList;
	}
	
	public int getDevicePVListCnt(HashMap param) {
		return sqlSession.selectOne("deviceMonitoring.getDevicePVListCnt", param);
	}

	public Map getDevicePVDetail(HashMap param) {
		Map result = sqlSession.selectOne("deviceMonitoring.getDevicePVDetail", param);
		return result;
	}

	public List getDeviceList(HashMap param) {
		List resultList = sqlSession.selectList("deviceMonitoring.getDeviceList", param);
		return resultList;
	}
	
	public HashMap<String, String> getDevice(String deviceId) {
	  return sqlSession.selectOne("deviceMonitoring.getDevice", deviceId);
	}
	
}
