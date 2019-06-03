package kr.co.ewp.ewpsp.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.ewp.ewpsp.dao.DeviceGroupDao;

@Service("deviceGroupService")
public class DeviceGroupServiceImpl implements DeviceGroupService{

	@Resource(name="deviceGroupDao")
	private DeviceGroupDao deviceGroupDao;

	public List getDeviceGroupList(Map<String, Object> param) throws Exception {
		return deviceGroupDao.getDeviceGroupList(param);
	}
	
	public List getDvInDeviceGroupList(Map<String, Object> param) throws Exception {
		return deviceGroupDao.getDvInDeviceGroupList(param);
	}
	
	public List getDeviceGrpAlarmList(Map<String, Object> param) throws Exception {
		return deviceGroupDao.getDeviceGrpAlarmList(param);
	}
	
	public List getAllDvInSiteList(Map<String, Object> param) throws Exception {
		return deviceGroupDao.getAllDvInSiteList(param);
	}
	
	public List getDeviceNotInGroupList(Map<String, Object> param) throws Exception {
		return deviceGroupDao.getDeviceNotInGroupList(param);
	}

	@Transactional
	public int deleteDeviceGroup(Map<String, Object> param) throws Exception {
		return deviceGroupDao.deleteDeviceGroup(param);
	}
	
	@Transactional
	public int insertDeviceGroup(Map<String, Object> param) throws Exception {
		return deviceGroupDao.insertDeviceGroup(param);
	}

	@Transactional
	public int updateDeviceGroup(Map<String, Object> param) throws Exception {
		return deviceGroupDao.updateDeviceGroup(param);
	}

	public int getDeviceChk(Map<String, Object> param) throws Exception {
		return deviceGroupDao.getDeviceChk(param);
	}
	
	@Transactional
	public int insertDevice(Map<String, Object> param) throws Exception {
		return deviceGroupDao.insertDevice(param);
	}
	
	@Transactional
	public int updateDevice(Map<String, Object> param) throws Exception {
		return deviceGroupDao.updateDevice(param);
	}
	
	@Transactional
	public int deleteDevice(Map<String, Object> param) throws Exception {
		return deviceGroupDao.deleteDevice(param);
	}
	
}
