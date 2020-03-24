package kr.co.esp.billRevenue.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("pvRevenueMapper")
public interface PvRevenueMapper {

	List<Map<String, Object>> getPVRevenueList(Map<String, Object> param) throws Exception;
	
}
