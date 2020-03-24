package kr.co.esp.billRevenue.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("drRevenueMapper")
public interface DrRevenueMapper {

	List<Map<String, Object>> getDRRevenueList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDRRevenueTexList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getDRRevenueChartList(Map<String, Object> param) throws Exception;
	
}
