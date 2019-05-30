package kr.co.ewp.ewpsp.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository("deviceGroupDao")
public class DeviceGroupDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public List<HashMap<String, Object>> getDeviceGroupList(HashMap<String, Object> param) {
        List<HashMap<String, Object>> resultList = sqlSession.selectList("deviceGroup.getDeviceGroupList", param);
        return resultList;
    }

    public List<HashMap<String, Object>> getDvInDeviceGroupList(HashMap<String, Object> param) {
        List<HashMap<String, Object>> resultList = sqlSession.selectList("deviceGroup.getDvInDeviceGroupList", param);
        return resultList;
    }

    public List<HashMap<String, Object>> getDeviceGrpAlarmList(HashMap<String, Object> param) {
        List<HashMap<String, Object>> resultList = sqlSession.selectList("deviceGroup.getDeviceGrpAlarmList", param);
        return resultList;
    }

    public List<HashMap<String, Object>> getAllDvInSiteList(HashMap<String, Object> param) {
        List<HashMap<String, Object>> resultList = sqlSession.selectList("deviceGroup.getAllDvInSiteList", param);
        return resultList;
    }

    public List<HashMap<String, Object>> getDeviceNotInGroupList(HashMap<String, Object> param) {
        List<HashMap<String, Object>> resultList = sqlSession.selectList("deviceGroup.getDeviceNotInGroupList", param);
        return resultList;
    }

    public int deleteDeviceGroup(HashMap<String, Object> param) {
        return sqlSession.delete("deviceGroup.deleteDeviceGroup", param);
    }

    public int insertDeviceGroup(HashMap<String, Object> param) {
        return sqlSession.insert("deviceGroup.insertDeviceGroup", param);
    }

    public int getDeviceChk(HashMap<String, Object> param) {
        return sqlSession.selectOne("deviceGroup.getDeviceChk", param);
    }

    public int insertDevice(HashMap<String, Object> param) {
        return sqlSession.insert("deviceGroup.insertDevice", param);
    }

    public int updateDevice(HashMap<String, Object> param) {
        return sqlSession.update("deviceGroup.updateDevice", param);
    }

    public int deleteDevice(HashMap<String, Object> param) {
        return sqlSession.delete("deviceGroup.deleteDevice", param);
    }

}
