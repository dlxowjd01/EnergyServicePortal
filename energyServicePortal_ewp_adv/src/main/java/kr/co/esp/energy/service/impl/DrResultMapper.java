package kr.co.esp.energy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("drResultMapper")
public interface DrResultMapper {

	List<Map<String, Object>> getDRResultList(Map<String, Object> param) throws Exception;

	Map<String, Object> getCbl(Map<String, Object> param) throws Exception;
	
}
