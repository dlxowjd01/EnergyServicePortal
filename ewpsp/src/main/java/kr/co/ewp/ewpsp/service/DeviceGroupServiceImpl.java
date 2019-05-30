package kr.co.ewp.ewpsp.service;

import kr.co.ewp.ewpsp.dao.DeviceGroupDao;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service("deviceGroupService")
public class DeviceGroupServiceImpl implements DeviceGroupService {

    @Resource(name = "deviceGroupDao")
    private DeviceGroupDao deviceGroupDao;

    public List getDeviceGroupList(HashMap param) throws Exception {
        return deviceGroupDao.getDeviceGroupList(param);
    }

    public List getDvInDeviceGroupList(HashMap param) throws Exception {
        return deviceGroupDao.getDvInDeviceGroupList(param);
    }

    public List getDeviceGrpAlarmList(HashMap param) throws Exception {
        return deviceGroupDao.getDeviceGrpAlarmList(param);
    }

    public List getAllDvInSiteList(HashMap param) throws Exception {
        return deviceGroupDao.getAllDvInSiteList(param);
    }

    public List getDeviceNotInGroupList(HashMap param) throws Exception {
        return deviceGroupDao.getDeviceNotInGroupList(param);
    }

    @Transactional
    public int deleteDeviceGroup(HashMap param) throws Exception {
        return deviceGroupDao.deleteDeviceGroup(param);
    }

    @Transactional
    public int insertDeviceGroup(HashMap param) throws Exception {
        return deviceGroupDao.insertDeviceGroup(param);
    }

    public int getDeviceChk(HashMap param) throws Exception {
        return deviceGroupDao.getDeviceChk(param);
    }

    @Transactional
    public int insertDevice(HashMap param) throws Exception {
        return deviceGroupDao.insertDevice(param);
    }

    @Transactional
    public int updateDevice(HashMap param) throws Exception {
        return deviceGroupDao.updateDevice(param);
    }

    @Transactional
    public int deleteDevice(HashMap param) throws Exception {
        return deviceGroupDao.deleteDevice(param);
    }

}
