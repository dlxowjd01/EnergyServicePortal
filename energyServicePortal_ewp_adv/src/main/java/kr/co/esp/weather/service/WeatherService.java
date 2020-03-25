package kr.co.esp.weather.service;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;


@Service
public interface WeatherService {
	Map<String, Object> getSido(Map<String, Object> param) throws Exception;
	Map<String, Object> getSigungu(Map<String, Object> param) throws Exception;
	Map<String, Object> getEub(Map<String, Object> param) throws Exception;
	
	Map<String, Object> getWeather(Map<String, Object> param) throws Exception;
	Map<String, Object> getMidWeather(Map<String, Object> param) throws Exception;
	Map<String, Object> getMidTempWeather(Map<String, Object> param) throws Exception;
}
