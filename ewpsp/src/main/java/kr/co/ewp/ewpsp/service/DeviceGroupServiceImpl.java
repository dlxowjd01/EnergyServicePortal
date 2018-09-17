package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.DeviceGroupDao;

@Service("deviceGroupService")
public class DeviceGroupServiceImpl implements DeviceGroupService{

	@Resource(name="deviceGroupDao")
	private DeviceGroupDao deviceGroupDao;

	public List getDeviceIOEList(HashMap param) throws Exception {
		return deviceGroupDao.getDeviceIOEList(param);
	}

	public Map getDeviceIOEDetail(HashMap param) throws Exception {
		return deviceGroupDao.getDeviceIOEDetail(param);
	}

	public List getDevicePCSList(HashMap param) throws Exception {
		return deviceGroupDao.getDevicePCSList(param);
	}

	public List getDeviceBMSList(HashMap param) throws Exception {
		return deviceGroupDao.getDeviceBMSList(param);
	}

	public List getDevicePVList(HashMap param) throws Exception {
		return deviceGroupDao.getDevicePVList(param);
	}

	public List getDeviceList(HashMap param) throws Exception {
		return deviceGroupDao.getDeviceList(param);
	}
	
}
