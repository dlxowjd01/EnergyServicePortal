package kr.co.esp.main.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.co.esp.main.service.TotalMonitoringService;

@Service("totalMonitoringService")
public class TotalMonitoringServiceImpl extends EgovAbstractServiceImpl implements TotalMonitoringService {
	
	@Resource(name="totalMonitoringMapper")
	private TotalMonitoringMapper totalMonitoringMapper;
	
	@Override
	public Map<String, Object> getDataExistMonth(Map<String, Object> param) throws Exception {
		String[] arrayMapperResult = totalMonitoringMapper.getDataExistMonth(param);	
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("listDataDate", arrayMapperResult);
		
		return resultMap;		
	}

	
	@Override
	public Map<String, Object> getDailyPowerChartPerSiteOnToday(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = totalMonitoringMapper.getDailyPowerChartPerSiteOnToday(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mapDailyPower", maplistMapperResult);
		
		return resultMap;
	}
	
	
	@Override
	public Map<String, Object> getDailyPowerChartPerEnergeKindOnToday(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = totalMonitoringMapper.getDailyPowerChartPerEnergeKindOnToday(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mapDailyPowerPerEnerge", maplistMapperResult);
		
		return resultMap;
	}
	
	
	@Override
	public Map<String, Object> getDailyPowerChartIn2Month(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = totalMonitoringMapper.getDailyPowerChartIn2Month(param);	
		
		Map<String, String> mapThisMonth = new HashMap<>();
		Map<String, String> mapPrevMonth = new HashMap<>();
		
		for (Map<String, Object> mapRow : maplistMapperResult) {
			if( mapRow.get("thismonth").toString().equals("1") ) {
				mapThisMonth.put(mapRow.get("day").toString(), mapRow.get("sum_pwr").toString());
			}
			else if( mapRow.get("thismonth").toString().equals("2") ) {
				mapPrevMonth.put(mapRow.get("day").toString(), mapRow.get("sum_pwr").toString());
			} 
		}		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mapCurMon", mapThisMonth);
		resultMap.put("mapPrevMon", mapPrevMonth);
		
		
		return resultMap;
	}	
	
	
	@Override
	public Map<String, Object> getMonthlyPowerChartIn2Year(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = totalMonitoringMapper.getMonthlyPowerChartIn2Year(param);	
		
		Map<String, String> mapThisYear = new HashMap<>();
		Map<String, String> mapPrevYear = new HashMap<>();
		
		for (Map<String, Object> mapRow : maplistMapperResult) {
			if( mapRow.get("thisyear").toString().equals("1") ) {
				mapThisYear.put(mapRow.get("month").toString(), mapRow.get("sum_pwr").toString());
			}
			else if( mapRow.get("thisyear").toString().equals("2") ) {
				mapPrevYear.put(mapRow.get("month").toString(), mapRow.get("sum_pwr").toString());
			} 
		}		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mapCurYear", mapThisYear);
		resultMap.put("mapPrevYear", mapPrevYear);
		
		
		return resultMap;
	}		
	
	
	
	@Override
	public Map<String, Object> getSiteInfo(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = totalMonitoringMapper.getSiteInfo(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("mapSiteInfo", maplistMapperResult);
		
		return resultMap;
	}
	
	
	@Override
	public Map<String, Object> getAlarmInfo(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> maplistMapperResult = totalMonitoringMapper.getAlarmInfo(param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("mapAlarmInfo",  maplistMapperResult);
		
		return resultMap;
	}
	

}
