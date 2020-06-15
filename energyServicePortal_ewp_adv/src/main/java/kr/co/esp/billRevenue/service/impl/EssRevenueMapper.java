package kr.co.esp.billRevenue.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("essRevenueMapper")
public interface EssRevenueMapper {

	List<Map<String, Object>> getESSRevenueList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getESSRevenueTexList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getESSRevenueDayList(Map<String, Object> param) throws Exception;
	
}
