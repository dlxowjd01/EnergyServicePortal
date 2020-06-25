package kr.co.esp.device2.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.device2.service.impl.Device2GroupMapper;
import kr.co.esp.device2.service.Device2GroupService;

@Service("device2GroupService")
public class Device2GroupServiceImpl extends EgovAbstractServiceImpl implements Device2GroupService {
	
	@Resource(name="device2GroupMapper")
	private Device2GroupMapper device2GroupMapper;
	
	@Override
	public List<Map<String, Object>> getDevice2GroupInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return device2GroupMapper.getDevice2GroupInfo(param);
	}	
	
	@Override
	public List<Map<String, Object>> getDevice2Info(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return device2GroupMapper.getDevice2Info(param);
	}	
	
	@Override
	public int getDevice2Chk(Map<String, Object> param) throws Exception {
		return device2GroupMapper.getDevice2Chk(param);
	}
	
	@Override
	public int insertDevice2(Map<String, Object> param) throws Exception {
		return device2GroupMapper.insertDevice2(param);
	}
}
