package kr.co.esp.device.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.device.service.DeviceMonitoringService;
import kr.co.esp.system.service.UserMngService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일            수정자                     수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23    MINHA          최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("deviceMonitoringService")
public class DeviceMonitoringServiceImpl extends EgovAbstractServiceImpl implements DeviceMonitoringService {

	@Resource(name="deviceMonitoringMapper")
	private DeviceMonitoringMapper deviceMonitoringMapper;
	
	@Override
	public List<Map<String, Object>> getDeviceIOEList(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceIOEList(param);
	}

	@Override
	public int getDeviceIOEListCnt(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceIOEListCnt(param);
	}

	@Override
	public Map<String, Object> getDeviceIOEDetail(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceIOEDetail(param);
	}

	@Override
	public List<Map<String, Object>> getDevicePCSList(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDevicePCSList(param);
	}

	@Override
	public int getDevicePCSListCnt(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDevicePCSListCnt(param);
	}

	@Override
	public Map<String, Object> getDevicePCSDetail(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDevicePCSDetail(param);
	}

	@Override
	public List<Map<String, Object>> getDeviceBMSList(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceBMSList(param);
	}

	@Override
	public int getDeviceBMSListCnt(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceBMSListCnt(param);
	}

	@Override
	public Map<String, Object> getDeviceBMSDetail(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceBMSDetail(param);
	}

	@Override
	public List<Map<String, Object>> getDevicePVList(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDevicePVList(param);
	}

	@Override
	public int getDevicePVListCnt(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDevicePVListCnt(param);
	}

	@Override
	public Map<String, Object> getDevicePVDetail(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDevicePVDetail(param);
	}

//	@Override
//	public List<Map<String, Object>> getDeviceList(Map<String, Object> param) throws Exception {
//		return deviceMonitoringMapper.getDeviceList(param);
//	}

	@Override
	public int getDeviceListCnt(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceListCnt(param);
	}

	@Override
	public Map<String, String> getDevice(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDevice(param);
	}

	@Override
	public Map<String, Object> getDeviceAMIDetail(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceAMIDetail(param);
	}
	
	//임시영역
	@Override
	public List<Map<String, Object>> getDeviceList(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceList(param);
	}
	@Override
	public List<Map<String, Object>> getDeviceType(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDeviceType(param);
	}
	@Override
	public List<Map<String, Object>> getDataByType(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getDataByType(param);
	}
	@Override
	public Map<String, Object> getTodayGenData(Map<String, Object> param) throws Exception {
		return deviceMonitoringMapper.getTodayGenData(param);
	}	
	@Override
	public List<Map<String, Object>> getGenRealList(Map<String, Object> param)
			throws Exception {
		return deviceMonitoringMapper.getGenRealList(param);
	}
	@Override
	public String[] genInverterData(Map<String, Object> param)
			throws Exception {
		return deviceMonitoringMapper.genInverterData(param);
	}
	@Override
	public String[] getInverterIdList(Map<String, Object> param)
			throws Exception {
		return deviceMonitoringMapper.getInverterIdList(param);
	}
	//임시영역
}
