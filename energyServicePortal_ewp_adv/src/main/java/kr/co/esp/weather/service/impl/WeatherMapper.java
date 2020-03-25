package kr.co.esp.weather.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;


@Mapper("weatherMapper")
public interface WeatherMapper {
	List<Map<String, Object>> getSido(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getSigungu(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getEub(Map<String, Object> param) throws Exception;
}

