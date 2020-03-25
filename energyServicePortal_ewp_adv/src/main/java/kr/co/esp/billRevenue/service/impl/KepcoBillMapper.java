package kr.co.esp.billRevenue.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("kepcoBillMapper")
public interface KepcoBillMapper {

	List<Map<String, Object>> getKepcoBillList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getKepcoTexBillList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getKepcoResentBillList(Map<String, Object> param) throws Exception;
	
}
