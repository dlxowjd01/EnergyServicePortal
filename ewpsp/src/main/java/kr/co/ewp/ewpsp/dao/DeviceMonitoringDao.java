package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository("deviceMonitoringDao")
public class DeviceMonitoringDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List getDeviceIOEList(Map<String, Object> param) {
        return sqlSession.selectList("deviceMonitoring.getDeviceIOEList", param);
    }

    public int getDeviceIOEListCnt(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDeviceIOEListCnt", param);
    }

    public Map getDeviceIOEDetail(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDeviceIOEDetail", param);
    }

    public List getDevicePCSList(Map<String, Object> param) {
        return sqlSession.selectList("deviceMonitoring.getDevicePCSList", param);
    }

    public int getDevicePCSListCnt(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDevicePCSListCnt", param);
    }

    public Map getDevicePCSDetail(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDevicePCSDetail", param);
    }

    public List getDeviceBMSList(Map<String, Object> param) {
        return sqlSession.selectList("deviceMonitoring.getDeviceBMSList", param);
    }

    public int getDeviceBMSListCnt(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDeviceBMSListCnt", param);
    }

    public Map getDeviceBMSDetail(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDeviceBMSDetail", param);
    }

    public List getDevicePVList(Map<String, Object> param) {
        return sqlSession.selectList("deviceMonitoring.getDevicePVList", param);
    }

    public int getDevicePVListCnt(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDevicePVListCnt", param);
    }

    public Map getDevicePVDetail(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDevicePVDetail", param);
    }

    public List getDeviceList(Map<String, Object> param) {
        return sqlSession.selectList("deviceMonitoring.getDeviceList", param);
    }

    public int getDeviceListCnt(Map<String, Object> param) {
        return sqlSession.selectOne("deviceMonitoring.getDeviceListCnt", param);
    }

    public Map<String, String> getDevice(Map<String, Object> dvMap) {
        return sqlSession.selectOne("deviceMonitoring.getDevice", dvMap);
    }

}
