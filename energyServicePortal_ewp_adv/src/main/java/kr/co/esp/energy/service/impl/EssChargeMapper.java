package kr.co.esp.energy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("essChargeMapper")
public interface EssChargeMapper {

	List<Map<String, Object>> getESSChargeRealList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getESSChargeFutureList(Map<String, Object> param) throws Exception;

	Map<String, Object> getESSChargeSum(Map<String, Object> param) throws Exception;
	
}
