package kr.co.esp.main.service;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;


@Service
public interface TotalMonitoringService {
	
	Map<String, Object> getDataExistMonth(Map<String, Object> param) throws Exception;
	Map<String, Object> getDailyPowerChartPerSiteOnToday(Map<String, Object> param) throws Exception;
	Map<String, Object> getDailyPowerChartPerEnergeKindOnToday(Map<String, Object> param) throws Exception;
	Map<String, Object> getDailyPowerChartIn2Month(Map<String, Object> param) throws Exception;
	Map<String, Object> getMonthlyPowerChartIn2Year(Map<String, Object> param) throws Exception;
	Map<String, Object> getSiteInfo(Map<String, Object> param) throws Exception;
	Map<String, Object> getAlarmInfo(Map<String, Object> param) throws Exception;
	
}
