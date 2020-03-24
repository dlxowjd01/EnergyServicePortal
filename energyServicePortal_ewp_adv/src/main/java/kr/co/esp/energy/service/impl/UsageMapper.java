package kr.co.esp.energy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("usageMapper")
public interface UsageMapper {

	List<Map<String, Object>> getUsageRealList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getUsageFutureList(Map<String, Object> param) throws Exception;
	
}
