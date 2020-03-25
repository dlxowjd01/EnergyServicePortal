package kr.co.esp.energy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("derUsageMapper")
public interface DerUsageMapper {

	List<Map<String, Object>> getESSUsageList(Map<String, Object> param) throws Exception;
	
}
