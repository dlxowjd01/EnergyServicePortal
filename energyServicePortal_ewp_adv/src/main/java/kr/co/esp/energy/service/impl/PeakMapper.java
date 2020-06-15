package kr.co.esp.energy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("peakMapper")
public interface PeakMapper {

	List<Map<String, Object>> getPeakRealList(Map<String, Object> param) throws Exception;
	
}
