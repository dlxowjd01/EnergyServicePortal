package kr.co.esp.energy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("pvGenMapper")
public interface PvGenMapper {

	List<Map<String, Object>> getPVGenRealList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getPVGenFutureList(Map<String, Object> param) throws Exception;
	
}
