package kr.co.esp.main.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("totalMonitoringMapper")
public interface TotalMonitoringMapper {

	String[] getDataExistMonth(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getDailyPowerChartPerSiteOnToday(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getDailyPowerChartPerEnergeKindOnToday(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getDailyPowerChartIn2Month(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getMonthlyPowerChartIn2Year(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getSiteInfo(Map<String, Object> param) throws Exception;
	List<Map<String, Object>> getAlarmInfo(Map<String, Object> param) throws Exception;
}
