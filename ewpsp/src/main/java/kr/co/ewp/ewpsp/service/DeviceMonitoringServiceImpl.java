package kr.co.ewp.ewpsp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.ewp.ewpsp.dao.DeviceMonitoringDao;

@Service("deviceMonitoringService")
public class DeviceMonitoringServiceImpl implements DeviceMonitoringService{

	@Resource(name="deviceMonitoringDao")
	private DeviceMonitoringDao deviceMonitoringDao;

	public List getDeviceIOEList(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceIOEList(param);
	}

	public int getDeviceIOEListCnt(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceIOEListCnt(param);
	}

	public Map getDeviceIOEDetail(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceIOEDetail(param);
	}

	public List getDevicePCSList(HashMap param) throws Exception {
		return deviceMonitoringDao.getDevicePCSList(param);
	}

	public int getDevicePCSListCnt(HashMap param) throws Exception {
		return deviceMonitoringDao.getDevicePCSListCnt(param);
	}

	public Map getDevicePCSDetail(HashMap param) throws Exception {
		return deviceMonitoringDao.getDevicePCSDetail(param);
	}

	public List getDeviceBMSList(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceBMSList(param);
	}

	public int getDeviceBMSListCnt(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceBMSListCnt(param);
	}

	public Map getDeviceBMSDetail(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceBMSDetail(param);
	}

	public List getDevicePVList(HashMap param) throws Exception {
		return deviceMonitoringDao.getDevicePVList(param);
	}
	
	public int getDevicePVListCnt(HashMap param) throws Exception {
		return deviceMonitoringDao.getDevicePVListCnt(param);
	}

	public Map getDevicePVDetail(HashMap param) throws Exception {
		return deviceMonitoringDao.getDevicePVDetail(param);
	}

	public List getDeviceList(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceList(param);
	}

	public int getDeviceListCnt(HashMap param) throws Exception {
		return deviceMonitoringDao.getDeviceListCnt(param);
	}
	
	public Map<String, String> getDevice(Map<String, Object> dvMap) throws Exception {
	  return deviceMonitoringDao.getDevice(dvMap);
	}
	
}
