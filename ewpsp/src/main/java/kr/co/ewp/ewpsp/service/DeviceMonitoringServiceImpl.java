package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.DeviceMonitoringDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("deviceMonitoringService")
public class DeviceMonitoringServiceImpl implements DeviceMonitoringService {

    @Resource(name = "deviceMonitoringDao")
    private DeviceMonitoringDao deviceMonitoringDao;

    public List getDeviceIOEList(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceIOEList(param);
    }

    public int getDeviceIOEListCnt(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceIOEListCnt(param);
    }

    public Map getDeviceIOEDetail(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceIOEDetail(param);
    }

    public List getDevicePCSList(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDevicePCSList(param);
    }

    public int getDevicePCSListCnt(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDevicePCSListCnt(param);
    }

    public Map getDevicePCSDetail(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDevicePCSDetail(param);
    }

    public List getDeviceBMSList(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceBMSList(param);
    }

    public int getDeviceBMSListCnt(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceBMSListCnt(param);
    }

    public Map getDeviceBMSDetail(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceBMSDetail(param);
    }

    public List getDevicePVList(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDevicePVList(param);
    }

    public int getDevicePVListCnt(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDevicePVListCnt(param);
    }

    public Map getDevicePVDetail(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDevicePVDetail(param);
    }

    public List getDeviceList(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceList(param);
    }

    public int getDeviceListCnt(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceListCnt(param);
    }

    public Map<String, String> getDevice(Map<String, Object> dvMap) throws Exception {
        return deviceMonitoringDao.getDevice(dvMap);
    }

    public Map<String, Object> getDeviceAMIDetail(Map<String, Object> param) throws Exception {
        return deviceMonitoringDao.getDeviceAMIDetail(param);
    }

}
