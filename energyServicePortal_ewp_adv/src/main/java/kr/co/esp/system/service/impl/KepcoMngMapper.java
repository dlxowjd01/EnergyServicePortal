package kr.co.esp.system.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("kepcoMngMapper")
public interface KepcoMngMapper {

	Map<String, Object> getSiteSetDetail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getPlanType(Map<String, Object> param) throws Exception;

	Map<String, Object> getPlanTypeVal(Map<String, Object> param) throws Exception;

	int updateSiteSet(Map<String, Object> param) throws Exception;

	int insertSiteSet(Map<String, Object> param2) throws Exception;
	
}
