package kr.co.esp.device.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.device.service.DeviceGroupService;
import kr.co.esp.system.service.KepcoMngService;

/**
 * @Class Name : CmmLoginServiceImpl.java
 * @Description : CmmLoginServiceImpl Class
 * @Modification Information
 * @
 * @  수정일			수정자					 수정내용
 * @ -------------   ------------   -------------------------------
 * @ 2018.09.23	MINHA		  최초생성
 *
 * @author HKITS
 * @since 2018.09.23
 * @version 1.0
 * @see
 */
@Service("deviceGroupService")
public class DeviceGroupServiceImpl extends EgovAbstractServiceImpl implements DeviceGroupService {

	@Resource(name="deviceGroupMapper")
	private DeviceGroupMapper deviceGroupMapper;
	
	@Override
	public List<Map<String, Object>> getDeviceGroupList(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.getDeviceGroupList(param);
	}

	@Override
	public List<Map<String, Object>> getDvInDeviceGroupList(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.getDvInDeviceGroupList(param);
	}

	@Override
	public List<Map<String, Object>> getDeviceGrpAlarmList(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.getDeviceGrpAlarmList(param);
	}

	@Override
	public List<Map<String, Object>> getAllDvInSiteList(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.getAllDvInSiteList(param);
	}

	@Override
	public List<Map<String, Object>> getDeviceNotInGroupList(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.getDeviceNotInGroupList(param);
	}

	@Override
	public int deleteDeviceGroup(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.deleteDeviceGroup(param);
	}

	@Override
	public int insertDeviceGroup(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.insertDeviceGroup(param);
	}

	@Override
	public int updateDeviceGroup(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.updateDeviceGroup(param);
	}

	@Override
	public int getDeviceChk(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.getDeviceChk(param);
	}

	@Override
	public int insertDevice(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.insertDevice(param);
	}

	@Override
	public int updateDevice(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.updateDevice(param);
	}

	@Override
	public int deleteDevice(Map<String, Object> param) throws Exception {
		return deviceGroupMapper.deleteDevice(param);
	}
	
}
