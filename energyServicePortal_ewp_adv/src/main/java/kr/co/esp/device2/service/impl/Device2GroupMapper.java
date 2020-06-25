package kr.co.esp.device2.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("device2GroupMapper")
public interface Device2GroupMapper {
	List<Map<String, Object>> getDevice2GroupInfo(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> getDevice2Info(Map<String, Object> param) throws Exception;
	
	int getDevice2Chk(Map<String, Object> param) throws Exception;
	
	int insertDevice2(Map<String, Object> param) throws Exception;
}
