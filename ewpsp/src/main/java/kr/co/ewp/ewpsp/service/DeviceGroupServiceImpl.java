package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
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

	public List getDeviceGroupList(HashMap param) throws Exception {
		return deviceGroupDao.getDeviceGroupList(param);
	}
	
	public List getDvInDeviceGroupList(HashMap param) throws Exception {
		return deviceGroupDao.getDvInDeviceGroupList(param);
	}

	@Transactional
	public int insertDevice(HashMap param) throws Exception {
		return deviceGroupDao.insertDevice(param);
	}
	
}
